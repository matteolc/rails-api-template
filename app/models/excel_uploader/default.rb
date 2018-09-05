# frozen_string_literal: true

class ExcelUploader::Default

    include ActiveModel::Model
  
    attr_accessor :file,
                  :partial,
                  :resource,
                  :unique_key
  
    def initialize(attributes={})
      attributes.each { |name, value| send("#{name}=", value) }
    end
  
    def persisted?
      false
    end

    def klass
      resource.tableize.singularize.camelize.constantize
    end    
  
    def load_imported_rows
      partial || klass.delete_all
      spreadsheet = ActsAsSpreadsheet::Spreadsheet.open(file)      
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).map do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        item = klass.send("find_by_#{unique_key}", row[unique_key]) || klass.new
        Rails.logger.debug row.to_hash
        item.attributes = item.attributes.merge(row.to_hash)
        item
      end
    end
  
    def imported_rows
      @imported_rows ||= load_imported_rows
    end
  
    def save
      if imported_rows.map(&:valid?).all?
        imported_rows.each(&:save!)
        true
      else
        imported_rows.each_with_index do |item, index|
          item.errors.full_messages.each do |msg|
            errors.add :base, "Row #{index + 1}: #{msg}"
          end
        end
        false
      end
    end    

end
  