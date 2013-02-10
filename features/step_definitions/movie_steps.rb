# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create! movie
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  page.body.index(e1).should < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  unless uncheck
    Movie.all_ratings.each do |rating|
      step(%{I uncheck "ratings_#{rating}"})
    end
  end
  rating_list.delete(' ').split(',').each do |rating|
    if uncheck
      step(%{I uncheck "ratings_#{rating}"})
    else
      step(%{I check "ratings_#{rating}"})
    end
  end
end

Then /^I should see all of the movies/ do
  rows = page.all("table#movies tbody tr td[1]").map! {|t| t.text}
  assert ( rows.size == Movie.all.count )
end

Then /^I should see movies with ratings: (.*)/ do |rating_list|
  ratings = rating_list.delete(' ').split(',')
  page.all('table#movies tbody tr td[2]').each do |td|
    movie_rating = td.text.delete("\n").delete("\r").strip()
    ratings.should include movie_rating
  end
end

Given /^I uncheck all ratings/ do
  Movie.all_ratings.each do |rating|
    step(%{I uncheck "ratings_#{rating}"})
  end
end

Given /^I check all ratings/ do
  Movie.all_ratings.each do |rating|
    step(%{I check "ratings_#{rating}"})
  end
end