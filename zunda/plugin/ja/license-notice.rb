# ja/license-notice.rb: Japanese language resource for license-notice.rb
#
# $Id: license-notice.rb,v 1.1 2008/01/15 07:02:48 zunda Exp $
#
# Copyright 2008 zunda <zunda at freeshell.org>
# Distributed under the GPL version 2 or later
#

module LicenseNotice
	extend ERB::Util

	module_function
	def conf_html
		<<_HTML
<h3>フィード(RSS)へのライセンス表示</h3>
<ul>
<li><label for="license_notice.show"><input type="checkbox" id="license_notice.show" name="license_notice.show" value="t"#{conf( 'show' ) ? ' checked' : ''}> フィード(RSS)にライセンス表示を含める</label>
</ul>
<p>必要のない項目は空白のままでかまいません。</p>
<ul>
<li>著者名: <input id="license_notice.author_name" name="license_notice.author_name" value="#{h conf( 'author_name' )}" type="text" size="40">
  - ライセンス表示は英語です。日本語の読めない人にも理解してもらえるように、アルファベットでの表記にした方が良いかもしれません。
<li>メールアドレス: <input id="license_notice.author_mail" name="license_notice.author_mail" value="#{h conf( 'author_mail' )}" type="text" size="40">
  - spamを避けるため、例えば「@」を「 at 」に変換するなどの工夫をした方が良いかもしれません。
<li>ライセンス名: <input id="license_notice.license_name" name="license_notice.license_name" value="#{h conf( 'license_name' )}" type="text" size="40">
<li>ライセンスの記されたURL: <input id="license_notice.license_url" name="license_notice.license_url" value="#{h conf( 'license_url' )}" type="text" size="70">
</ul>
<h4>ライセンス表示の例</h4>
#{notice_html( Time.now )}
_HTML
	end
end

@license_notice_conf_label = 'フィードのライセンス'
