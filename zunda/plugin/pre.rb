# pre.rb $Revision: 1.2 $
#
# <%=pre text, escape, atributes %>
# 引数の文字列を<pre>〜</pre>内にそのまま出力します。
#   text:          <pre>〜</pre>内に表示する文字列
#   escape=true:   文字列の中の&<>"をそれぞれ&amp;&lt;&gt;&quot;に変換します。
#   attributes='': style="color:red;"等の記述が可能です。
#
# <%=pre <<'_PRE'
# hoge
# moga
#
# above is an empty line
# _PRE
# %>
#
# のように書くといいでしょう。ヒアドキュメントの終わりの印 _PRE の行には、
# 他には何も書けませんのでご注意ください。
#
# Copyright 2002 zunda <zunda at freeshell.org>
# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work under the terms
# of GPL version 2 or later.
#
=begin ChangeLog
2002-12-05 zunda <zunda at freeshell.org>
	* first commit
2002-12-13 zunda <zunda at freeshell.org>
	* better to put single quotation marks around the _PRE
=end

def pre (text, escape = true, attr='')
  attr = ' ' + attr unless attr.empty?
  "<pre#{attr}>#{escape ? CGI::escapeHTML(text) : text}</pre>"
end
