load_plugin( 'misc/plugin/todo.rb' )

def todo_pretty_print(todos)
	s = ''
	s << %Q|<ul>\n|
	now = Time.now
	today = Time.local(now.year, now.month, now.day)
	todos.each_with_index do |x, idx|
		break if idx >= @conf['todo.n']
		s << "<li>"
		s << %Q|<del>| if x.deleted?
		s << apply_plugin( x.todo )
		if x.limit
			s << "(〜#{x.limit}"
			y, m, d = ParseDate.parsedate(x.limit)
			y = today.year unless y
			if y and m and d
				limit = Time.local(y, m, d)
				diff = ((limit - today)/86400).to_i
				if diff > 0
					s << %Q| <span class="todo-in-time">#{todo_msg_in_time(diff)}</span>|
				elsif diff == 0
					s << %Q| <span class="todo-today">#{todo_msg_today}</span>|
				else
					s << %Q| <span class="todo-too-late">#{todo_msg_late(diff.abs)}</span>|
				end
			end
			s << ")"
		end
		s << %Q|</del>| if x.deleted?
		s << "</li>\n"
	end
	s << %Q|</ul>\n|
end

def todo
	todo_init
	<<TODO
<div class="todo">
	<div class="todo-title">
		<h2>#{@conf['todo.title']}</h2>
	</div>
	<div class="todo-body">
#{todo_pretty_print(@todos)}
	</div>
</div>
TODO
end
