# frozen_string_literal: true

class Owner < ApplicationRecord
  include TrackRecord

  has_many :stores
end
