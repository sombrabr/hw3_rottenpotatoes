# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.find_or_create_by_title(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  regexp = Regexp.compile "#{Regexp.quote(e1)}.*#{Regexp.quote(e2)}"
  assert page.body =~ regexp
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(',')
  ratings.each do |rating|
    step "I #{uncheck}check \"ratings_#{rating.strip}\"" 
  end
end


Then /^(?:|I )should see \/([^\/]*)\/ in "([^"]*)"$/ do |regexp, table|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath("//table[@id='#{table}']/tbody/tr/td[2]", :text => regexp)
  else
    assert page.has_xpath?("//table[@id='#{table}']/tbody/tr/td[2]", :text => regexp)
  end
end

Then /^(?:|I )should not see \/([^\/]*)\/ in "([^"]*)"$/ do |regexp, table|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_no_xpath("//table[@id='#{table}']/tbody/tr/td[2]", :text => regexp)
  else
    assert page.has_no_xpath?("//table[@id='#{table}']/tbody/tr/td[2]", :text => regexp)
  end
end

Then /^I should see all of the movies$/ do
  total = Movie.count('title')
  rows = page.all(:xpath, "//table[@id='movies']/tbody/tr").length
  if rows.respond_to? :should
    rows.should==total
  else
    assert rows==total
  end
end
