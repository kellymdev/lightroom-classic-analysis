# frozen_string_literal: true

class CalculateRatingsData
  def call
    no_rating = unrated_count
    five_stars = with_rating_count(5.0)
    four_stars = with_rating_count(4.0)
    three_stars = with_rating_count(3.0)
    two_stars = with_rating_count(2.0)
    one_star = with_rating_count(1.0)

    {
      unrated_count: no_rating,
      unrated_percentage: calculate_percentage(no_rating),
      one_star_count: one_star,
      one_star_percentage: calculate_percentage(one_star),
      two_star_count: two_stars,
      two_star_percentage: calculate_percentage(two_stars),
      three_star_count: three_stars,
      three_star_percentage: calculate_percentage(three_stars),
      four_star_count: four_stars,
      four_star_percentage: calculate_percentage(four_stars),
      five_star_count: five_stars,
      five_star_percentage: calculate_percentage(five_stars)
    }
  end

  private

  def unrated_count
    Image.unrated.count
  end

  def with_rating_count(rating)
    Image.with_star_rating(rating).count
  end

  def calculate_percentage(value)
    (value / Image.count.to_d * 100).round(2)
  end
end
