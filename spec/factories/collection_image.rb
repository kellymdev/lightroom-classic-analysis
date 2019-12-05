# frozen_string_literal: true

FactoryBot.define do
  factory :collection_image do
    collection { 1 }
    image { 1 }
    pick { 0.0 }
    positionInCollection { 1.0 }
  end
end
