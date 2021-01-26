#!/usr/bin/ruby

=begin  
folder names in all caps
class files with initial capital
files after a foldername go into that folder
default folder if none given is current folder
files with no extension get .rb
another extension can be passed via .erb for example after file list
extension applied only for files before it in folder
if LIB and SPEC folders given and no files in SPEC, autopopulate SPEC based on LIB and create Rakefile
sample entry: LIB Model View Controller model_repository SPEC VIEWS index about help .erb
 - CURRENT DIR
 -- lib
 --- model.rb
 --- model_repository.rb
 --- view.rb
 --- controller.rb
 -- spec
 --- model_spec.rb
 --- view_spec.rb
 --- controller_spec.rb
 -- views
 --- index.erb
 --- about.erb
 --- help.erb
1   set folder to current folder
2   if item is all caps
2a  reset folder to top folder 
2b  create foldername
2c  and set folder to foldername
3   if item starts with caps or is in lower snake case
3a  create file with lower snake case name
3b  add class init to file
4   if file is all lowercase, one word
4a  check for nearest .extension file before a new folder
4b if no extension, default to .rb
4c else use the nearest extension
=end
require 'pry-byebug'

@REGEX = {
  classfile: /[A-Z][a-z]+\b|[a-z]+_[a-z]+\b/,
  lowersnake: /[a-z]+_[a-z]+\b/,
  folder: /[A-Z]+\b/,
  extension: /\.[a-z]+\b/,
  file: /[a-z]+\b/
}

# @REGEX = /(?<foldername>[A-Z]+\b)|(?<classfile>[A-Z][a-z]+\b)|(?<extension>\.[a-z]+\b)|(?<file>[a-z]+\b)/.freeze
def create_folder(item)
  Dir.mkdir(item.downcase, 755)
  File.chmod(0755, item.downcase)
end

def init_class(item)
  filename = item.downcase
  classname = item.match?(@REGEX[:lowersnake]) ? item.split('_').map(&:capitalize).join : item
  File.open("#{filename}.rb", 'w') do |f|
    f.puts "class #{classname}"
    f.puts '  def initialize(attributes = {})'
    f.puts '  '
    f.puts '  end'
    f.puts 'end'
    f.puts
  end
end

def create_files(files, extension)
  files.each do |file|
    File.write("#{file}#{extension}", '')
  end
end

def generate_specs(lib_path)
  lib_names = Dir.children(lib_path)
  lib_names.each do |filename|
    spec_name = "#{filename.split('.')[0]}_spec.rb"
    File.write(spec_name, '')
  end
end

start_dir = Dir.getwd
files = []

ARGV.each do |item|
  #binding.pry
  if item.match?(@REGEX[:folder])
    create_files(files, '.rb') unless files.empty?
    Dir.chdir(start_dir)
    create_folder(item)
    Dir.chdir("./#{item}")
    next
  elsif item == 'SPEC' && Dir.exist?("#{start_dir}/lib")
    generate_specs("#{start_dir}/lib")
    next
  elsif item.match?(@REGEX[:classfile])
    init_class(item)
    next
  elsif item.match?(@REGEX[:extension])
    create_files(files, item)
    files = []
    next
  elsif item.match?(@REGEX[:file])
    files << item
    next
  end
end
