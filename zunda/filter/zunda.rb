require 'uri'

module TDiary
	module Filter

if __FILE__ == $0 then
		class Filter
			def initialize(conf, cgi)
				@conf = conf
				@cgi = cgi
			end
		end
end

		class ZundaFilterError < StandardError; end
		class ZundaFilter < Filter

			def comment_filter( diary, comment )
				orig_comment_mail = comment.mail.dup
				comment.mail.replace( "#{comment.mail}\t#{ENV['REMOTE_ADDR']} #{ENV['HTTP_USER_AGENT']}" )
				begin
					unless orig_comment_mail.empty? then
						raise(ZundaFilterError, "e-mail is not empty (#{orig_comment_mail.inspect}) in tsukkomi")
					end
					if comment.name.size > 100 then
						raise(ZundaFilterError, "name too long (#{comment.name.size}) in tsukkomi")
					end
					if comment.body.size > 2000 then
						raise(ZundaFilterError, "body too long (#{comment.body.size}) in tsukkomi")
					end
					if /(\banonimous\b|a href|url=|https?)/i =~ comment.name then
						raise(ZundaFilterError, "bad phrase #{$1.dump} for tsukkomi")
					end
					if /\bmu@|\bmumu2004@/ =~ orig_comment_mail then
						raise(ZundaFilterError, "bad e-mail #{orig_comment_mail} for tsukkomi")
					end
					if /(\ba href\b|url=|\bMy\s+homepage\b|profile.zmapple.com|sony.just-allen.com|bloking.jp|hatumono.com|\/url|\/link)/i =~ comment.body then
						raise(ZundaFilterError, "bad phrase #{$1.dump} in tsukkomi")
					end
					urls = comment.body.scan( URI.regexp( %w( http https ) ) ).size
					if urls > 5 then
						raise(ZundaFilterError, "too many URLs (#{urls}) in tsukkomi")
					end
				rescue ZundaFilterError
					comment.show = false
					require 'time'
					File.open(@conf.options['spamfilter.debug_file'], 'a') do |io|
						io.flock(File::LOCK_EX)
						io.puts "#{Time.now.iso8601}: #{@cgi.remote_addr}->#{(@cgi.params['date'][0] || 'no date').dump} by #{ENV['HTTP_USER_AGENT']}: #{$!}"
					end
				end

				return true
			end

		end
	end
end

eval( <<'MODIFY_CLASS', TOPLEVEL_BINDING )
module TDiary
	class TDiaryDay
		def cookie_mail
			c = @cgi.cookies['tdiary'][1]
			if c then
				c.sub( /\t.*\Z/, '' )
			else
				''
			end
		end
	end
end
MODIFY_CLASS

if $0 == __FILE__ then
	class Comment
		attr_reader :name, :mail, :body, :show
		attr_writer :name, :mail, :body, :show
	end
	class Conf
		def options
			{'spamfilter.debug_file' => "t.#{$0}.#{$$}.log"}
		end
	end
	class Cgi
		def params
			{'date' => ['testdate']}
		end
		def remote_addr
			'127.0.0.1'
		end
	end
	require 'test/unit'
	class TestZundaFilter < Test::Unit::TestCase
		def setup
			@filter = TDiary::Filter::ZundaFilter.new(Conf.new, Cgi.new)
			@com = Comment.new
			@com.name = 'zunda'
			@com.mail = 'zunda at freeshell.org'
			@com.body = 'tsukkomi'
			@com.show = true
		end

		def test_good
			assert(@filter.comment_filter( nil, @com ))
			assert(@com.show)
		end

		def test_bad_body
			['a href', 'url=', '/url', '/link'].each do |phrase|
				@com.show = true
				@com.body = phrase
				assert(@filter.comment_filter( nil, @com ))
				assert(!@com.show, "test for phrase '#{phrase}'")
			end
		end

	end
end

