#!/usr/bin/env ruby
# show_keyword.rb: 検索キーワードを拾う
#
# レファラから検索キーワードを拾い出します。
# YADAさんのアイディア
#   http://fuji.sakura.ne.jp/~yada/ruby/20020102.html#p01
# を、disp_referrer.rbより、MUTOH MasaoさんのUTF-8変換手順によって実装し
# なおしました。Googleのcacheからのリンクの場合には、cache:〜の部分を無
# 視します。
#
# Extracts search keywords in the HTTP_REFERER
# original idea by YADA(yada @ fuji.sakura.ne.jp)
# http://fuji.sakura.ne.jp/~yada/ruby/20020102.html#p01
#
# usage:
# <%= show_keyword %> in the header or footer is substituted with the
# search keywords in the HTTP_REFERER
#
# $Id: show_keyword.rb,v 1.4 2009/08/16 02:46:04 zunda Exp $
# Copyright 2002 zunda <zunda @ freeshell.org>
# Permission is granted for use, copying, modification, distribution,         
# and distribution of modified versions of this work under the terms          
# of GPL version 2 or later.                                                  
#
# conversion from UTF-8 to EUC copied from disp_referrer.rb by
# Copyright (C) 2002 MUTOH Masao <mutoh @ highway.ne.jp>
#

def show_keyword
  ref = @cgi.referer ? CGI::unescape( @cgi.referer ) : ''
  if /[\/&?](MT|q|p|qt|kw|search|s)=/ =~ ref then
	  ref = @conf.to_native( ref )
    /[\/&?](MT|q|p|qt|kw|search|s)=(cache:[^\s]+\s)?([^&]*)/ =~ ref
    $3 || ''
  else
    ''
  end
end
