class Event < ActiveRecord::Base

  translates :title, :description, :warning, :info, fallback: :any

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

  has_many :images
  accepts_nested_attributes_for :images, :allow_destroy => true

  validates_numericality_of :price_regular,
      :only_integer => true,
      :allow_nil => true,
      :greater_than_or_equal_to => 0

  validates_numericality_of :price_reduced,
      :only_integer => true,
      :allow_nil => true,
      :greater_than_or_equal_to => 0
  
  validates_presence_of :type_id

  # event_type to display
  def display_type
    if self.custom_type && !self.custom_type.empty?
      return self.custom_type
    else
      self.type.name
    end
  end

  def self.of_types type_ids
    where_clause = type_ids.map {|type_id| "event_types.id = " + type_id.to_s + " " }.join(" OR ")
    events = Event.joins(:type, :event_details).group('events.id').where(where_clause)
    return events
  end

  def all_studios
    studios = []
    self.event_details.each { |ed| studios << ed.studio }
    return studios.uniq
  end

  def firsttime_in_studio studio
    ft = new Time()
    self.event_details.each do |ed|
      if ed.studio == studio
        if ed.starttime < ft
          ft = ed.starttime
        end
      end
    end
    return ft
  end

  def firsttime
    self.event_details.min_by { |ed| ed.starttime} .starttime
  end

  def start_date
    self.event_details.min_by { |ed| ed.start_date} .start_date
  end

  def end_date
    self.event_details.max_by { |ed| ed.end_date} .end_date
  end

  def tags
    tags = self.event_details.collect_concat { |ed| ed.tags }
    tags
  end
  
  def early_bird_date
    self.start_date - 2.weeks
  end
  
  def workshop_select
    I18n.l(self.start_date, :format => :short) + "-" + I18n.l(self.end_date, :format => :short) + " | " +
    "#{title} | " + self.festivals.map { |f| f.name }.join(", ") + (self.festivals.length > 0 ? " | " : "") + self.tags.map { |t| t.name }.join(", ") + " | #{price_regular},-€ / #{price_reduced},-€*"
  end

end
