def navi_prev_diary(date); "前の日記"; end
def navi_next_diary(date); "次の日記"; end
def nyear_diary_label; "同日"; end
def nyear_diary_title; "同日"; end
def navi_prev_nyear(date); "前日"; end
def navi_next_nyear(date); "翌日"; end
def category_title; "カテゴリ別"; end
def comment_body_label; 'ツッコミ'; end

def nyear(ymd)
	y, m, d = ymd.scan(/^(\d{4})(\d\d)(\d\d)$/)[0]
	date = Time.local(y, m, d)
	years = @years.find_all {|year, months| months.include? m}
	if @mode != 'nyear' and years.length >= 2
		%Q|[<a href="#{@index}#{anchor m + d}" title="#{nyear_diary_title}">#{nyear_diary_label}</a>]|
	elsif @mode == 'nyear'
		"&nbsp;(#{y}年)"
	else
		""
	end
end

