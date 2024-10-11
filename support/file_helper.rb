# frozen_string_literal: true

require 'simple_symbolize'

module FileHelper
  def self.read_file(file_path:)
    raise FileNotFoundError, "File not found: #{file_path}" unless File.exist?(file_path)

    CSV.parse(File.read(file_path), headers: true, header_converters: ->(h) { SimpleSymbolize.symbolize(h) })
  end

  def self.write_file(file_path:, student:)
    CSV.open(file_path, 'a') do |line|
      line << student
    end
  end

  def self.create_file(file_path:)
    CSV.open(file_path, 'w') do |header|
      header << Constants::OUTPUT_HEADERS
    end
  end
end
