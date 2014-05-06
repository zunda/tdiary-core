# license-notice.rb: show license notice to RSS feeds
#
# $Id: license-notice.rb,v 1.2 2008/01/15 07:02:45 zunda Exp $
#
# Copyright 2008 zunda <zunda at freeshell.org>
# Distributed under the GPL version 2 or later
#

module LicenseNotice
	extend ERB::Util
	module_function

	def import_conf( conf )
		@@conf = conf
	end

	def conf( name )
		item = "license_notice.#{name}"
		return nil unless @@conf[item]
		return nil if @@conf[item].respond_to?(:empty?) and @@conf[item].empty?
		return @@conf[item]
	end

	def notice_html( date )
		copyright = date.strftime( "Copyright %Y" )
		copyright << ' by' if conf( 'author_name' ) or conf( 'author_mail' )
		copyright << " #{h conf( 'author_name' )}" if conf( 'author_name' )
		copyright << " &lt;#{h conf( 'author_mail' )}&gt;" if conf( 'author_mail' )
		copyright << "."

		if conf( 'license_name' )
			if conf( 'license_url' )
				license = %Q| Published under the terms of <a href="#{h conf( 'license_url' )}">#{h conf( 'license_name' )}</a>.|
			else
				license = %Q| Published under the terms of #{h conf( 'license_name' )}.|
			end
		else
			if conf( 'license_url' )
				license = %Q| Published under the terms at <a href="#{h conf( 'license_url' )}">#{h conf( 'license_url' )}</a>.|
			else
				license = ''
			end
		end

		return %Q|<div class="copyright" style="font-size:50%;text-align:right;"><p>#{copyright}#{license}</p></div>|
	end

	unless defined?(conf_html)
		def conf_html
			<<_HTML
<h3>License notice in feeds</h3>
<ul>
<li><label for="license_notice.show"><input type="checkbox" id="license_notice.show" name="license_notice.show" value="t"#{conf( 'show' ) ? ' checked' : ''}> Inlude license notice into feeds</label>
</ul>
<p>Items can be left blank.</p>
<ul>
<li>Name of the author: <input id="license_notice.author_name" name="license_notice.author_name" value="#{h conf( 'author_name' )}" type="text" size="40">
<li>E-mail address of the author: <input id="license_notice.author_mail" name="license_notice.author_mail" value="#{h conf( 'author_mail' )}" type="text" size="40">
<li>Name of the license: <input id="license_notice.license_name" name="license_notice.license_name" value="#{h conf( 'license_name' )}" type="text" size="40">
<li>URL of the license: <input id="license_notice.license_url" name="license_notice.license_url" value="#{h conf( 'license_url' )}" type="text" size="70">
</ul>
<h4>Example of the notice</h4>
#{notice_html( Time.now )}
_HTML
		end
	end
end

LicenseNotice.import_conf(@conf)
@license_notice_conf_label = 'License Notice' unless @license_notice_conf_label

add_conf_proc( 'license_notice', @license_notice_conf_label, 'etc' ) do
	if @mode == 'saveconf' then
		# user configured
		%w( show ).each do |s|
			item = "license_notice.#{s}"
			@conf[item] = ( 't' == @cgi.params[item][0] )
		end
		%w( author_name author_mail license_name license_url ).each do |s|
			item = "license_notice.#{s}"
			@conf[item] = @conf.to_native( @cgi.params[item][0] || '' )
		end
	else
		# defaults
		@conf['license_notice.show'] ||= true
		@conf['license_notice.author_name'] ||= @conf.author_name
		@conf['license_notice.author_mail'] ||= @conf.author_mail
	end
	LicenseNotice::conf_html
end

add_body_leave_proc do |date|
	LicenseNotice::notice_html( date ) if @conf['license_notice.show'] and feed?
end
