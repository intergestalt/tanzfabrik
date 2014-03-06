ActiveAdmin.register Page do

  menu :priority => 0
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  permit_params :title_de, :content_de, :title_en, :content_en
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
  index do
    selectable_column
    column "URL" do |page|
      link_to page.slug, page
    end
    column :title
    column :content
    actions do |page|
        link_to "Wysiwig", '/editor/' + page.slug, :class => "member_link"
    end
  end

  filter :title
  filter :content
  
  config.per_page = 10
  
  show do
    attributes_table do
      row "URL" do |page|
        link_to page.slug, page
      end
      row :title_de
      row :title_en
      row :content_de
      row :content_en
    end
    active_admin_comments
  end
  
  form do |f|
    f.inputs "Details" do
      f.input :title_de
      f.input :title_en
    end
    f.inputs "Content" do
      f.input :content_de
      f.input :content_en
    end
    f.actions
  end
  
  
end
