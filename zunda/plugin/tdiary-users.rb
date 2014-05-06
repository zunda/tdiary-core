def tdiary_wiki( wikiname = 'FrontPage', title = nil )
	wikititle = "tDiary-users(#{wikiname})"
	title = wikititle unless title
  %Q|<a href="http://tdiary-users.sourceforge.jp/cgi-bin/wiki.cgi?#{CGI::escape( wikiname )}" title="#{CGI::escapeHTML( wikititle )}">#{CGI::escapeHTML( title )}</a>|
end
