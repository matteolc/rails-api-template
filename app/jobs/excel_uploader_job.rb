class ExcelUploaderJob < ApplicationJob
    queue_as :critical
   
    def perform(args) 
        uploader = ExcelUploader::Default.new(args)
        uploader.save 
    end
          
end