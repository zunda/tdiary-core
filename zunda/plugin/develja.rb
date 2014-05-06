def mo_ml (number = 1, title = nil, name = 'devel.ja')
  number = number.to_i
  real_number = sprintf( '%05d', number )
  www_number = sprintf( '%05d', number - 2 )
  mltitle = "[Momonga-#{name}:#{real_number}]"
	title = mltitle unless title
  "<a href=\"http://www.momonga-linux.org/archive/Momonga-#{name}/msg#{www_number}.html\" title=\"#{mltitle}\">#{title}</a>"
end

%w(devel users).each do |ml|
  %w(en ja).each do |lang|
    eval <<-EOT
      def #{ml}#{lang} (number=1, title=nil)	# develja, develen, usersja, ..
	mo_ml( number, title, "#{ml}.#{lang}" )
      end
    EOT
  end
end

def installer_demand( number=1, title=nil)	# intaller-demand
  mo_ml( number, title, 'installer-demand' )
end
