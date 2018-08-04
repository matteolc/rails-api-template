Rails.application.config.generators do |g|
    g.orm               :active_record, primary_key_type: :uuid
    g.template_engine   nil
    g.stylesheet_engine nil
  
    g.assets            false
    g.stylesheets       false
    g.javascripts       false
  
    g.helper            false
    g.helper_specs      false
  
    g.views             false
    g.view_specs        false    
end