#!/usr/bin/ruby

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

  def needs_spec?(structure_hash)
    structure_hash.key?('spec') && structure_hash['spec'].length.zero?
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

  def pass; end
end

FolderStructure.new(ARGV).write
