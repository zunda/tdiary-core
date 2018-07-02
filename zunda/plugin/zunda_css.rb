#
# zunda_css.rb
# $Revision: 1.4 $
#
# theme/*/*.cssにあるテーマをすべて選択可能にします。
#
# Copyright 2002 zunda <zunda at freeshell.org>
# Permission is granted for use, copying, modification, distribution,         
# and distribution of modified versions of this work under the terms          
# of GPL version 2 or later.                                                  
#

def css_tag
	if @mode =~ /conf$/ then
		css = "#{theme_url}/conf.css"
	else
		css = @css
	end
	deftitle = CGI::escapeHTML( File.basename( css, '.css' ) )
	r = <<-CSS
	<meta http-equiv="content-style-type" content="text/css">
	<style type="text/css" media="all">@import url(theme/zunda/sidebar.css);</style>
	<link rel="stylesheet" href="#{css}" title="#{deftitle}" type="text/css" media="all">
	CSS
	Dir.glob( 'theme/*/*.css' ).sort.each do |css|
		title = File.basename( css, '.css' )
		next if title == deftitle
		next if title == 'sidebar'
		r += <<-CSS
		<link rel="alternate stylesheet" href="#{css}" title="#{title}" type="text/css" media="all">
		CSS
	end
	r
end
