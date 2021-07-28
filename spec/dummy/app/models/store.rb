# frozen_string_literal: true

class Store < ApplicationRecord
  include TrackRecord

  belongs_to :owner
end
