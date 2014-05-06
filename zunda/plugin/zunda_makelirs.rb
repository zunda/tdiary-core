# makelirs.rb $Revision: 1.2 $
#
# 更新情報をLIRSフォーマットのファイルに吐き出す
# また、最新の日記のHTTPヘッダをファイルに吐き出す
#
#   pluginディレクトリに置くだけで動作します。
#
#   サーバのポートが80番以外であったり，SSLを用いてアクセスする場合は
#   tdiary.conf で @options['makelirs.url'] を設定してください．
#   例）
#   @options['makelirs.url'] = 'https://example.net:8080/diary/'
#
#   tdiary.confにおいて、@options['makelirs.file']に
#   ファイル名を指定すると、そのファイルを出力先の
#   LIRSファイルとします。無指定時にはindex.rbと同じ
#   パスにantenna.lirsというファイルになります。
#   いずれも、Webサーバから書き込める権限が必要です。
#
# Copyright (C) 2002 by Kazuhiro NISHIYAMA
#
=begin ChangeLog
2003-08-03 Junichiro Kita <kita@kitaj.no-ip.com>
	* make lirs when receiving TrackBack Ping

2003-04-28 TADA Tadashi <sho@spc.gr.jp>
	* enable running on secure mode.

2003-03-13 zunda <zunda at freeshell.org>
	* also makes the header for the latest diary

2003-03-08 Hiroyuki Ikezoe <zoe@kasumi.sakura.ne.jp>
	* set TD. Thanks koyasu san.

2002-10-28 zoe <zoe@kasumi.sakura.ne.jp>
	* merge 1.4. Thanks koyasu san.

2002-10-06 TADA Tadashi <http://sho.tdiary.net/>
	* for tDiary 1.5.0.20021003.

2002-05-05 TADA Tadashi <http://sho.tdiary.net/>
	* support @options.

2002-05-04 Kazuhiro NISHIYAMA <zn@mbf.nifty.com>
	* create.
=end

if /^(append|replace|comment|trackbackreceive)$/ =~ @mode then
	file = @options['makelirs.file'] || 'antenna.lirs'

	# parse the diary
	t = TDiaryLatest::new( @cgi, "latest.rhtml", @conf )
	body = t.eval_rhtml

	# for header
	head = {
		'type' => 'text/html',
		'Vary' => 'User-agent',
		'charset' => @conf.encoding,
		'Content-Length' => body.size.to_s,
		'Last-Modified' => CGI::rfc1123_date( t.last_modified ),
	}
	File.open( "latest_header.txt", 'w' ) do |f|
		f.print( @cgi.header( head ) )
	end
	# for lirs
	# escape comma
	e = proc{|str| str.gsub(/[,\\]/) { "\\#{$&}" } }

	host = ENV['HTTP_HOST']
	path = ENV['REQUEST_URI']
	path = path[0..path.rindex("/")]
	url =  @options['makelirs.url'] || "http://#{host}#{path}"
	now = Time.now
	utc_offset = (now.hour - now.utc.hour) * 3600

	lirs = "LIRS,#{t.last_modified.tv_sec},#{Time.now.tv_sec},#{utc_offset},#{body.size},#{e[url]},#{e[@html_title]},#{e[@author_name]},,\n"
	File::open( file, 'w' ) do |o|
		o.puts lirs
	end
end
