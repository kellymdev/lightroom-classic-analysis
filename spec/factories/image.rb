# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    id_global { 'global_id_string' }
    fileHeight { 1_080.0 }
    fileWidth { 1_920.0 }
    rating { 5.0 }
  end
end
