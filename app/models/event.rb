class Event < ActiveRecord::Base
  belongs_to :type, :class_name => "EventType"

  has_many :festival_events
  accepts_nested_attributes_for :festival_events, :allow_destroy => true
  
  has_many :festivals, :through => :festival_events
  #accepts_nested_attributes_for :festivals, :allow_destroy => true

  has_many :person_events
  accepts_nested_attributes_for :person_events, :allow_destroy => true
  
  has_many :people, :through => :person_events
  accepts_nested_attributes_for :people, :allow_destroy => true

  has_many :event_details, :dependent => :destroy
  accepts_nested_attributes_for :event_details, :allow_destroy => true

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def self.of_types type_names
    r = []
    type_names.each do |type_name|
      r += self.of_type(type_name)
    end
    return r
  end

  def self.of_type type_name
    #return self.joins(:type).where(:event_types => {:name => type_name})
    event_type = EventType.where(:name => type_name).first
    if event_type
      return self.where(:type_id => event_type.id).to_a    
    else
      return []
    end
  end


end
