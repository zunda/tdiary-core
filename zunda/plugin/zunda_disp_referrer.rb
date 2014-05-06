def referer_of_today_short( diary, limit = 10 )
	return '' if bot? or not diary or limit < 1
	@referer_of_today_setup ||= DispRef2Setup.new( @conf, limit, false, nil, @mode )

	DispRef2Refs.new( diary, @referer_of_today_setup ).to_short_html
end
