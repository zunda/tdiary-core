# sessionid.rb : Shows only comments sent with genuine sessionid
# $Id: sessionid.rb,v 1.1 2007/01/17 01:13:11 zunda Exp $
#
# usage: add the following to skeltons of tsukkomi form
# <input type="hidden" name="token" value="<%%=token%>">
#
# options:
# @conf.options['sessionid.expire'] : time in seconds before a token expires
# @conf.options['sessionid.min_age'] : time in seconds before a token becomes valid
# @conf.options['spamfilter.debug_mode'] : logs invalid/expired tokens if true
# @conf.options['spamfilter.filter_mode'] : set false to discard tsukkomi
#
# Copyright 2005 zunda <zunda at freeshell.org>
#
# Permission is granted for use, copying, modification, distribution, and
# distribution of modified versions of this work under the terms of GPL.
#

require 'pstore'

module TDiary
	module Filter
		class SessionidFilterError < StandardError; end

		class SessionidFilter < Filter

			def dbpath
				@conf['sessionid.dbpath'] || File.join( @conf.data_path, 'cache', 'sessionids.dat' )
			end

			def initialize( *args )
				super( *args )

				# clean up old IDs
				PStore.new( dbpath ).transaction do |db|
					db['ids'] ||= Hash.new
					db['ids'].each_pair do |id, ctime|
						db['ids'].delete( id ) if ctime + max_age < Time.now
					end
				end
			end

			def max_age
				e = @conf.options['sessionid.expire']
				e ? e.to_i : 10800	# 3 hours
			end

			def min_age
				e = @conf.options['sessionid.min_age']
				e ? e.to_i : 2
			end

			def consume( given )
				raise SessionidFilterError, 'no session id given' unless given
				begin
					session_id = Integer( given )
				rescue ArgumentError
					raise SessionFilterError, 'invalid session id format'
				end
				ctime = nil
				begin
					PStore.new( dbpath ).transaction do |db|
						ctime = db['ids'].delete( session_id )
						raise SessionidFilterError, "invalid or expired session id: #{session_id}" unless ctime
					end
					now = Time.now
					raise SessionidFilterError, "session id: #{session_id} too old" if ctime + max_age < now
					raise SessionidFilterError, "session id: #{session_id} too fresh" if ctime + min_age >= now
				end
				ctime
			end

			def comment_filter( diary, comment )
				begin
					consume( @cgi.params['token'][0] )
				rescue SessionidFilterError => msg
					log( msg ) if @conf.options['spamfilter.debug_mode']
					comment.show = false 
					return @conf.options.has_key?( 'spamfilter.filter_mode' ) ?  @conf.options['spamfilter.filter_mode'] : true
				end
				true
			end

			def log( msg )
				require 'time'
				path = @conf.options['spamfilter.debug_file']
				if path and not path.empty? then
					File.open( path, 'a' ) do |f|
						f.flock( File::LOCK_EX )
						if @cgi.params['date'][0] then
							f.puts "#{Time.now.iso8601}: #{ENV['REMOTE_ADDR']}->#{@cgi.params['date'][0].dump}: #{msg}"
						else
							f.puts "#{Time.now.iso8601}: #{ENV['REMOTE_ADDR']}: #{msg}"
						end
					end
				end
			end

		end
	end
end
