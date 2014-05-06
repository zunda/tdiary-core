# zunda_makelirs.rb $Revision: 1.2 $ edited from makelirs.rb Revision: 1.18
#
# 最新の日記のヘッダをファイルとして生成します
#
# makelirs.rb copyright (C) 2002 by Kazuhiro NISHIYAMA
# You can redistribute it and/or modify it under GPL2.
#

add_update_proc do
	cgi = @cgi.clone
	conf = @conf.clone
	def cgi.mobile_agent?; false; end
	def conf.mobile_agent?; false; end

	t = TDiaryLatest::new( cgi, "latest.rhtml", conf )
	body = t.eval_rhtml
	head = {
		'type' => 'text/html',
		'Last-modified' => CGI::rfc1123_date( t.last_modified ),
	}
	File.open( "latest_header.txt", 'w' ) do |f|
		f.print( cgi.header( head ) )
	end
end

