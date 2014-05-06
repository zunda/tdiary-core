# 20sessionid.rb : configuration UI for tdiary/filter/sessionid.rb
# $Id$
#
# Copyright 2005 zunda <zunda at freeshell.org>
#
# Permission is granted for use, copying, modification, distribution, and
# distribution of modified versions of this work under the terms of GPL.
#

# register a session ID
require 'pstore'
@conf['sessionid.dbpath'] ||= File.join( @conf.data_path, 'cache', 'sessionids.dat' )
@conf['sessionid.id_max'] ||= 10**16
@session_id = nil
PStore.new( @conf['sessionid.dbpath'] ).transaction do |db|
	db['ids'] ||= Hash.new
	begin
		@session_id = rand( @conf['sessionid.id_max'] )
	end while db['ids'][@session_id]
	db['ids'][@session_id] = Time.now
end

# show the session ID
def token
	@session_id
end

# setting UI
@sessionid_conf_label ||= 'ID to comment'
@sessionid_exp ||= 'Require a special string (session ID) when a reader comments. As it is set automatically, normal readers should not have any difficulty in commenting.'
@sessionid_spam_exp ||= 'Setup discarding/logging options through the &quot;spam filter&quot; menu.'
@sessionid_expire_label ||= 'Expire in: '
@sessionid_min_age_label ||= 'Valid after: '
@sessionid_time_unit ||= 'seconds'

add_conf_proc( 'sessionid', @sessionid_conf_label, 'security' ) do
	if 'saveconf' == @mode then
		@conf['sessionid.expire'] = @cgi.params['sessionid.expire'][0].empty? ? '10800' : @cgi.params['sessionid.expire'][0]
		@conf['sessionid.min_age'] = @cgi.params['sessionid.min_age'][0].empty? ? '2' : @cgi.params['sessionid.min_age'][0]
	end
	<<"_END"
<p>#{@sessionid_exp}</p>
<p>#{@sessionid_spam_exp}</p>
<ul>
<h3 class="subtitle">#{@sessionid_expire_label}</h3>
<p><input type="text" name="sessionid.expire" size="7" value="#{CGI::escapeHTML( @conf['sessionid.expire'] || '' )}"> #{@sessionid_time_unit}</p>
<h3 class="subtitle">#{@sessionid_min_age_label}</h3>
<p><input type="text" name="sessionid.min_age" size="7" value="#{CGI::escapeHTML( @conf['sessionid.min_age'] || '' )}"> #{@sessionid_time_unit}</p>
_END
end


#
# make comment form
#
def comment_form_text
	unless @diary then
		@diary = @diaries[@date.strftime( '%Y%m%d' )]
		return '' unless @diary
	end

	r = ''
	unless @conf.hide_comment_form then
		r = <<-FORM
			<div class="form">
		FORM
		if @diary.count_comments( true ) >= @conf.comment_limit_per_day then
			r << <<-FORM
				<div class="caption"><a name="c">#{comment_limit_label}</a></div>
			FORM
		else
			r << <<-FORM
				<div class="caption"><a name="c">#{comment_description}</a></div>
				<form class="comment" name="comment-form" method="post" action="#{h @index}"><div>
				<input type="hidden" name="date" value="#{ @date.strftime( '%Y%m%d' )}">
				<div class="field name">
					#{comment_name_label}:<input class="field" name="name" value="#{h( @conf.to_native(@cgi.cookies['tdiary'][0] || '' ))}">
				</div>
				<div class="field mail">
					#{comment_mail_label}:<input class="field" name="mail" value="#{h( @cgi.cookies['tdiary'][1] || '' )}">
				</div>
				<div class="textarea">
					#{comment_body_label}:<textarea name="body" cols="60" rows="5"></textarea>
				</div>
				<div class="button">
					<input type="hidden" name="token" value="#{token}">
					<input type="submit" name="comment" value="#{h comment_submit_label}">
				</div>
				</div></form>
			FORM
		end
		r << <<-FORM
			</div>
		FORM
	end
	r
end

def comment_form_mobile
	return '' if @conf.hide_comment_form
	return '' if bot?
	return '' if hide_comment_day_limit

	if @diaries[@date.strftime('%Y%m%d')].count_comments( true ) >= @conf.comment_limit_per_day then
		return "<HR><P>#{comment_limit_label}</P>"
	end

	return <<-FORM
		<HR>
		<FORM METHOD="POST" ACTION="#{h @index}">
			<INPUT TYPE="HIDDEN" NAME="date" VALUE="#{@date.strftime( '%Y%m%d' )}">
			<P>#{comment_description_short}<BR>
			#{comment_name_label_short}: <INPUT NAME="name"><BR>
			#{comment_form_mobile_mail_field}
			#{comment_body_label_short}:<BR>
			<TEXTAREA NAME="body" COLS="100%" ROWS="5"></TEXTAREA><BR>
			<INPUT TYPE="HIDDEN" NAME="token" VALUE="<%%=token%>">
			<INPUT TYPE="SUBMIT" NAME="comment" value="#{comment_submit_label_short}"></P>
		</FORM>
	FORM
end
