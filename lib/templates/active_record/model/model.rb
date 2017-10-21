<% module_namespacing do -%>
    class <%= class_name %> < <%= parent_class_name.classify %>
        <% attributes.select(&:reference?).each do |attribute| -%>
        belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %><%= ', required: true' if attribute.required? %>
        <% end -%>
        include PgSearch      
        pg_search_scope :search, against: column_names, using: { tsearch: { prefix: true, normalization: 2 } }    
    end
<% end -%>