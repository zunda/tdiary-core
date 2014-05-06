# uptime.rb : shows uptime of the host
#
# $Id: uptime.rb,v 1.2 2003/12/12 11:23:36 zunda Exp $
# Copyright 2002 zunda <zunda at freeshell.org>
# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work under the terms of
# GPL version 2 or later.
#

def uptime
  unless bot? then
		rubies = `ps axw`.split( /\n/ ).reject!{ |x| not( /ruby/ =~ x ) }
		nruby = rubies ? rubies.size : 0
    uptime = `uptime`.chomp
		"#{uptime}, #{nruby} #{nruby > 1 ? 'rubies' : 'ruby'}, #{RUBY_VERSION} (#{RUBY_RELEASE_DATE})"
  else
    ''
  end
end
