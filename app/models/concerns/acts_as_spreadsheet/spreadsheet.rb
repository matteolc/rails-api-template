# frozen_string_literal: true

require 'roo'
require 'roo-xls'

module ActsAsSpreadsheet
  module Spreadsheet
    extend self

    def open(file_path)
      open_spreadsheet(File.open(file_path))
    end

    def open_spreadsheet(file)
      case File.extname(file)
      when '.csv' then Roo::CSV.new(file.path, csv_options: { col_sep: ';' })
      when '.ods' then Roo::OpenOffice.new(file.path)
      when '.xls' then Roo::Excel.new(file.path)
      when '.xlsx' then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file}"
      end
    end
  end
end
