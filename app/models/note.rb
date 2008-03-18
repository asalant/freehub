class Note < ActiveRecord::Base
  belongs_to :notable, :polymorphic => true
  has_userstamps

  validates_presence_of :notable_type, :notable_id, :text

  acts_as_paginated
end
