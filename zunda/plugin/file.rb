=begin
= Make a link to a local file or an URL((-$Id: file.rb,v 1.1.1.1 2003/12/05 09:06:34 zunda Exp $-))

== Copyright
Copyright 2002 zunda <zunda at freeshell.org> Permission is granted for
use, copying, modification, distribution, and distribution of modified
versions of this work under the terms of GPL version 2 or later.
=end

def file (path)
  %Q[<a href="#{path}">#{CGI::escapeHTML( path )}</a>]
end
