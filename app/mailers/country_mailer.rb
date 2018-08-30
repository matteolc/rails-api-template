class CountryMailer < ApplicationMailer
	
    default from: "example@#{ENV['MAILER_DOMAIN']}"
    
    def email(country, to, subject='Country info', body='Country information attached.')
        @country = country
        @to = to	 
        @body = body
        attachments["#{@country.name}.pdf"] = File.read(@country.to_pdf)
        mail to: @to, 
             subject: subject
    end
    
end