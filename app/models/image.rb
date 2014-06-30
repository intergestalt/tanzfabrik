class Image < ActiveRecord::Base  
  has_attached_file :attachment,
    :styles => { :medium => "300x300>", :thumb => "100x100>" },
    :storage => :s3,
    :bucket         => ENV['S3_TANZFABRIK_BUCKET'],
    :s3_credentials => { :access_key_id     => ENV['S3_KEY'], 
                         :secret_access_key => ENV['S3_SECRET'] },
    :url => ':s3_domain_url',
    :path => "images/:id/image.:extension"
  
  
  # needs to be declared after has_attached_file !!
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/ 
  
  belongs_to :studio
  belongs_to :person
  belongs_to :event
  belongs_to :festival
  belongs_to :page

end
