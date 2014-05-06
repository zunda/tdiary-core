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
<h3>�ե�����(RSS)�ؤΥ饤����ɽ��</h3>
<ul>
<li><label for="license_notice.show"><input type="checkbox" id="license_notice.show" name="license_notice.show" value="t"#{conf( 'show' ) ? ' checked' : ''}> �ե�����(RSS)�˥饤����ɽ����ޤ��</label>
</ul>
<p>ɬ�פΤʤ����ܤ϶���ΤޤޤǤ��ޤ��ޤ���</p>
<ul>
<li>����̾: <input id="license_notice.author_name" name="license_notice.author_name" value="#{h conf( 'author_name' )}" type="text" size="40">
  - �饤����ɽ���ϱѸ�Ǥ������ܸ���ɤ�ʤ��ͤˤ����򤷤Ƥ�館��褦�ˡ�����ե��٥åȤǤ�ɽ���ˤ��������ɤ����⤷��ޤ���
<li>�᡼�륢�ɥ쥹: <input id="license_notice.author_mail" name="license_notice.author_mail" value="#{h conf( 'author_mail' )}" type="text" size="40">
  - spam���򤱤뤿�ᡢ�㤨�С�@�פ�� at �פ��Ѵ�����ʤɤι��פ򤷤������ɤ����⤷��ޤ���
<li>�饤����̾: <input id="license_notice.license_name" name="license_notice.license_name" value="#{h conf( 'license_name' )}" type="text" size="40">
<li>�饤���󥹤ε����줿URL: <input id="license_notice.license_url" name="license_notice.license_url" value="#{h conf( 'license_url' )}" type="text" size="70">
</ul>
<h4>�饤����ɽ������</h4>
#{notice_html( Time.now )}
_HTML
	end
end

@license_notice_conf_label = '�ե����ɤΥ饤����'
