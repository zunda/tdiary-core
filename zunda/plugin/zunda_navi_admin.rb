def navi_admin
	if not bot? and @mode == 'day' and @date.strftime('%Y%m%d') != (Time::now + (@conf.hour_offset * 3600).to_i).strftime('%Y%m%d') then
		result = navi_item( "#{@update}?edit=true;year=#{@date.year};month=#{@date.month};day=#{@date.day}", navi_edit )
	else
		result = navi_item( @update, navi_update )
	end
	result << navi_item( "#{@update}?conf=default", navi_preference ) if /^(latest|month|day|comment|conf|nyear|category.*)$/ !~ @mode
	result
end
