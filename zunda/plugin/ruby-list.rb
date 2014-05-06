def ruby_ml( number = 1, title = nil, name = 'ruby-list' )
	number = number.to_i
  urlnumber = sprintf( '%05d', number )
  mltitle = "[#{name}: #{number}]"
	title = mltitle unless title
  %Q|<a href="http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/#{name}/#{urlnumber}" title="#{mltitle}">#{title}</a>|
end

def ruby_list( number = 1, title = nil )
  ruby_ml( number, title, 'ruby-list' )
end

def ruby_talk( number = 1, title = nil )
  ruby_ml( number, title, 'ruby-talk' )
end

def ruby_math( number = 1, title = nil )
  ruby_ml( number, title, 'ruby-math' )
end
def ruby_dev( number = 1, title = nil )
  ruby_ml( number, title, 'ruby-dev' )
end
