=begin
= random date plugin((-$Id: zunda_random-date.rb,v 1.5 2006/01/25 20:39:37 zunda Exp $-))
Make a link to diary of a random date.

== Usage
Activate the plugin through the configuration interface

== Copyright and license
Copyright (C) 2005 zunda <zunda at freeshell.org>

Permission is granted for use, copying, modification, distribution, and
distribution of modified versions of this work under the terms of GPL
version 2 or later.
=end

if not @conf.bot? and ('latest' == @mode or 'day' == @mode or 'month' == @mode or 'nyear' == @mode) then

	_yms  = @years.keys.map{ |y| @years[y].map{ |m| "#{y}#{m}" } }.flatten
	_ym = _yms[ rand( _yms.size ) ]
	_cgi = CGI::new
	_cgi.params['date'] = [ _ym ]
	class TDiaryMonthWoPlugin < TDiary::TDiaryMonth
		def load_plugins; end
	end
	_d = TDiaryMonthWoPlugin.new( _cgi, 'month.rhtml', @conf )
	@_random_date = _d.diaries.keys[ rand( _d.diaries.keys.size ) ]

	alias _navi_user navi_user
	def navi_user
		_navi_user + navi_item( "#{@index}#{anchor @_random_date}", 'Random' )
	end

end