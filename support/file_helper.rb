# frozen_string_literal: true

require 'simple_symbolize'

module FileHelper
  def self.read_file(file_path:)
    raise FileNotFoundError, "File not found: #{file_path}" unless File.exist?(file_path)

    CSV.parse(File.read(file_path), headers: true, header_converters: ->(h) { SimpleSymbolize.symbolize(h) })
  end

  def self.write_file(file_path:, student:)
    CSV.open(file_path, 'w', write_headers: true, headers: Constants::OUTPUT_HEADERS) do |line|
      line << student
    end
  end
end
