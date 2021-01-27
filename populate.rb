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

class FolderStructure
  def initialize(parameter_string)
    @start_dir = Dir.getwd
    @classfile = /[A-Z][a-z]+\b|[a-z]+_[a-z]+\b/
    @lowersnake = /[a-z]+_[a-z]+\b/
    @folder = /[A-Z]+\b/
    @extension = /\A\.[a-z]+\b/
    @file = /[a-z]+\b/
    @structure_hash = parse(parameter_string)
  end

  def write
    @structure_hash.each do |foldername, files|
      Dir.exist?(foldername) ? pass : Dir.mkdir(foldername)
      Dir.chdir(foldername)
      files.each do |file|
        File.write(file, '')
      end
      Dir.chdir('../')
    end
  end

  private

  def parse(parameters)
    parameters = parameters.instance_of?(String) ? parameters.split : parameters
    structure = add_folders(parameters)
    structure['spec'] = generate_specs(structure['lib']) if needs_spec?(structure)
    structure.each_value { |folder| name_files(folder) }
    structure
  end

  def class?(item)
    item.match(@classfile)
  end

  def folder?(item)
    item.match?(@folder)
  end

  def lowersnake?(item)
    item.match?(@lowersnake)
  end

  def extension?(item)
    item.match?(@extension)
  end

  def file?(item)
    item.match?(@file) && !extension?(item)
  end

  def needs_spec?(structure_hash)
    structure_hash.key?('spec') && structure_hash['spec'].length.zero?
  end

  def add_folders(parameters)
    structure = { @start_dir => [] }
    current = @start_dir
    parameters.each do |item|
      if folder?(item)
        structure[item.downcase] = []
        current = item.downcase
      else
        structure[current] << item
      end
    end
    structure
  end

  def name_files(folder)
    return if folder.empty?

    ext = extension?(folder.last) ? folder.last : '.rb'
    folder.map! { |item| "#{item}#{ext}" }
    folder.delete(folder.last) if extension?(folder.last)
  end

  def generate_specs(lib_folder)
    lib_folder.map { |item| "#{item.downcase}_spec" }
  end

  def pass; end
end

FolderStructure.new(ARGV).write
