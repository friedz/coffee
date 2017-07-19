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
	return si.member?(s)
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
		if @name.downcase != other.name.downcase then
			return @name.casecmp(other.name)
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
	tex += "\\section*{\\Huge CofFEe List}"
	tex += "\n"
	tex += "\\large\n"
	tex += "\\textbf{1} Kreuz = \\textbf{1} Kaffee, \\textbf{25} Kreuze = \\textbf{5 €}\\\\\n"

	tex += "Falls Zeile bezahlt, durchstreichen und neue Zeile anfangen.\\\\\n"

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

options = Hash.new
OptionParser.new do |opts|
	opts.banner = "Usage ./coffe.rb [options] [file]"
	#opts.banner = "Usage ./#{opts.program_name}.rb [options] [file]"
	opts.on("-f", "--file=FILE", "use FILE for the list") do |f|
		options[:file] = f
	end
	opts.on("-0", "--empty", "generate an empty List") do
		options[:empty] = true
	end
	opts.on("-e", "--editor=EDITOR", "open in EDITOR to write list") do |e|
		options[:editor] = e
	end
	opts.on("-h", "--help", "show this help message") do
		puts opts
		puts "Format of the File:"
		puts "    Name"
		puts "    Name,[number]"
		puts "    Name,[number],[paid]"
		puts "    Name,,[paid]"
		puts "0 <= Number <= 25"
		puts "paid = yes|no (in many languages possible)"
		puts "\e[33mNote:\e[0m"
		puts "    \e[33mpaid but not full lines appear \e[32mgreen\e[33m in command line\e[0m"
		puts "    \e[33moutput and need to be crossed out manually\e[0m"
		exit
	end
end.parse!

options[:file] ||= ARGV[0]

unless options[:file] or options.has_key?(:empty)
	puts "foo"
	options[:editor] ||= if ENV.key?("EDITOR")
	  ENV["EDITOR"]
	elsif File.exists?("/usr/bin/editor")
	  "editor"
	else
	  "nano"
	end
	options[:file] = "tmp.csv"
	system(options[:editor], options[:file])
end

unless options.has_key?(:empty) or File.file?(options[:file])
	abort("We Need A List \e[31m(the editor you specified probably doesn't exist)\e[0m")
end

l = Array.new
if options[:empty]
elsif nil != options[:file] and File.file?(options[:file])
	list = File.open(options[:file])

	list.each_line do |i|
		unless i.strip.empty?
			e = Entry.new(i)
			l << e
		end
	end
	list.close
else
	abort("the file must exist")
end

l.select!() do |n|
	not n.delete?
end
l.sort!
l.each do |n|
	puts n
end
File.write("./tmp.tex", make_tex(l))
`xelatex tmp.tex`
`xelatex tmp.tex`
`xelatex tmp.tex`
begin
	File.delete('./tmp.csv')
rescue
end
begin
	File.delete('./tmp.tex')
rescue
end
begin
	File.delete('./tmp.aux')
rescue
end
begin
	File.delete('./tmp.log')
rescue
end
begin
	File.rename('./tmp.pdf', './coffee.pdf')
rescue
end
puts "\e[32mdone\e[0m"
