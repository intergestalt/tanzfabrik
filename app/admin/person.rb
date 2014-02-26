ActiveAdmin.register Person do

  menu :priority => 3  

  permit_params :id, :name, :bio, :role, :image, :event_ids => []

  index do
    selectable_column
    column :name
    column :role
    column "Events" do |person|
        person.events.map { |e| (link_to e.title, admin_event_path(e)) }.join(', ').html_safe
    end
    column "Image" do |person|
      image_tag(person.image.url) if person.image.exists?
    end
    default_actions
  end
  
  filter :name
  filter :role
  filter :events
  
  show do
    attributes_table do
      row :name
      row :role
      row "Events" do |person|
        person.events.map { |e| (link_to e.title, admin_event_path(e)) }.join(', ').html_safe
      end      
      row :bio
      row :image do
        image_tag(person.image.url) if person.image.exists?
      end
    end
    active_admin_comments
  end
  
  form :html => { :enctype => "multipart/form-data" } do |f|
      f.inputs "Details" do
        f.input :name
        f.input :role
        f.input :bio
        f.input :events, :as => :check_boxes
      end
      if f.object.image.exists?
        f.inputs "Current image" do     
          f.template.content_tag(:li) do
            f.template.image_tag(f.object.image.url(:thumb))
          end
        end
      end
      f.inputs "New image" do     
        # use regular rails helper instead of formtastic, avoid weird error
        f.template.content_tag(:li) do
          f.file_field :image
        end
      end    
      f.actions
  end


  
end