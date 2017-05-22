#!/usr/bin/env ruby
# encoding: utf-8

require 'set'
require 'optparse'

def ja? s
	if s.nil? then
		return false
	end
	# TODO: kann beliebig um weitere Formen von ja ergänzt werden ;)
	si = Set.new ["jo", "jopp", "ja", "true", "1", "yes", "si", "да", "oui", "sim", "ken", "sea", "jes", "はい", "ndiyo", "gee", "haa'n", "oo", "是", "baleh", "areh", "na'am", "a-yo", "evet"]
	s.downcase!
	if si.member?(s) then
		return true
	else
		return false
	end
end

class Entry
	attr_reader :name, :number, :paid
	@@MaxN = 25
	def initialize s
		tmp = s.split(',')
		tmp.map do |x|
			x.strip!
		end
		@name = tmp[0]
		@number = tmp[1].to_i
		@paid = ja?(tmp[2])
	end
	def to_s
		if @paid then
			return "\e[32m#{@name}, #{@number}\e[0m"
		else
			return "#{@name}, #{@number}"
		end
	end
	def <=>(other)
		if @name != other.name then
			return @name <=> other.name
		elsif @number != other.name then
			return other.number <=> @number
		elsif @paid == other.paid then
			return 0
		elsif @paid then
			return 1
		else
			-1
		end
	end
	def delete?
		return ((@name.empty? or @name.nil?) or
				(@number >= @@MaxN and @paid))
	end
	def multi?
		return (@number >= @@MaxN and not @paid)
	end
	def over_flow
	end
	# TODO: gibt die Zeile Xe aus mit dem Namen zum begin aus
	def line
		l = @name
		(1..25).each do |i|
			l += " &"
			if i <= @number then
				#l += " X"
				l += " \\!$\\times$"
			end
		end
		l += " \\\\\n"
		return l
	end
end

def make_tex(entrys)
	num_lines = 98
	tex = "\\documentclass{article}\n"
	tex += "\\usepackage{amsmath}\n"
	tex += "\\usepackage{longtable}\n"
	tex += "\\usepackage{tikz}\n"
	tex += "\\usepackage{array}\n"
	tex += "\\usepackage{booktabs}\n"
	tex += "\\usepackage[a4paper,left=1cm,right=1cm,top=1cm,bottom=1cm]{geometry}\n"
	tex += "\\pagestyle{empty}"
	tex += "\n"
	tex += "\\begin{document}\n"
	#tex += "\\Huge CofFEe List"
	tex += "\\section*{\\Huge CofFEe List}"
	tex += "\n"
	tex += "\\large\n"
	tex += "\\textbf{1} Kreuz = \\textbf{1} Kaffee, \\textbf{25} Kreuze = \\textbf{5 €}\\\\\n"
	#tex += "\n"
	tex += "Falls Zeile bezahlt, durchstreichen und neue Zeile anfangen.\\\\\n"
	#tex += "\\small\n"
	tex += "Liste wird zusätzlich regelmäßigtm geleert/erneuert\n"
	tex += "\\large\n"
	tex += "\n"
	tex += "\\begin{longtable}{|m{3.5cm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|m{1.5mm}|}\n"
	hline = "\\hline\n"
	tex += hline
	tex += "\\textbf{Name}&1&2&3&4&5&6&7&8&9&\\!10&\\!11&\\!12&\\!13&\\!14&\\!15&\\!16&\\!17&\\!18&\\!19&\\!20&\\!21&\\!22&\\!23&\\!24&\\!25\\\\\n"
	tex += "\\hline\n"
	tex += "\\endhead\n"
	entrys.each do |e|
		tex += e.line()
		tex += hline
	end
	empty_line = " & & & & & & & & & & & & & & & & & & & & & & & & & \\\\\n"
	num_lines -= entrys.size()
	(0..num_lines).each do |l|
		tex += empty_line
		tex += hline
	end
	tex += "\\end{longtable}\n"
	tex += "\\end{document}\n"

	return tex
end


file = ARGV[0]

if file == nil then
	puts "NOPE"
	abort("We Need A List")
end

list = File.open(file)

l = Array.new

list.each_line do |i|
	unless i.strip.empty?
		e = Entry.new(i)
		l << e
	end
end
list.close

l.select!() do |n|
	not n.delete?
end
l.sort!()
l.each do |n|
	puts n
end
puts ""
File.write("./tmp.tex", make_tex(l))
print(".")
`xelatex tmp.tex`
#print(".")
#`xelatex tmp.tex`
#print(".")
#`xelatex tmp.tex`
File.delete('./tmp.tex')
File.delete('./tmp.aux')
File.delete('./tmp.log')
File.rename('./tmp.pdf', './coffee.pdf')

#puts make_tex(l)


