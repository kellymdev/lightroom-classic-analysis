# frozen_string_literal: true

class CalculateRatingsData
  attr_reader :image_scope

  def initialize(image_scope)
    @image_scope = image_scope
  end

  def call
    no_rating = unrated_count
    five_stars = with_rating_count(5.0)
    four_stars = with_rating_count(4.0)
    three_stars = with_rating_count(3.0)
    two_stars = with_rating_count(2.0)
    one_star = with_rating_count(1.0)

    {
      unrated: {
        rating: 'Unrated',
        count: no_rating,
        percentage: calculate_percentage(no_rating)
      },
      one_star: {
        rating: '1 star',
        count: one_star,
        percentage: calculate_percentage(one_star)
      },
      two_stars: {
        rating: '2 stars',
        count: two_stars,
        percentage: calculate_percentage(two_stars)
      },
      three_stars: {
        rating: '3 stars',
        count: three_stars,
        percentage: calculate_percentage(three_stars)
      },
      four_stars: {
        rating: '4 stars',
        count: four_stars,
        percentage: calculate_percentage(four_stars)
      },
      five_stars: {
        rating: '5 stars',
        count: five_stars,
        percentage: calculate_percentage(five_stars)
      }
    }
  end

  private

  def unrated_count
    image_scope.unrated.count
  end

  def with_rating_count(rating)
    image_scope.with_star_rating(rating).count
  end

  def calculate_percentage(value)
    if value.zero?
      0.to_d
    else
      (value / image_scope.count.to_d * 100).round(2)
    end
  end
end
