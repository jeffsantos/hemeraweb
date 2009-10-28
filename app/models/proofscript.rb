class Proofscript < ActiveRecord::Base
  validates_presence_of :title, :specification
  
  belongs_to :user
  has_many :proof_processes
end
