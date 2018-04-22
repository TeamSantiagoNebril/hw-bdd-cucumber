# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date]) if Movie.find_by title: movie[:title] == nil
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  expect(page.text.index(e1) < page.text.index(e2)).to be true
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #fail "Unimplemented"
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
    rating_list.split(', ').each do |rating|
        if(uncheck)
          step "I uncheck \"ratings[#{rating}]\""
        else
          step "I check \"ratings[#{rating}]\""
        end
        
    end
end

Then /I should see entries with: (.*)/ do |rating_list|
  rating_list.split(', ').each do |rating|
    Movie.where(:rating => rating).each do |x|
      step "I should see \"#{x[:title]}\""
    end
  end
end

Then /I should not see entries with: (.*)/ do |rating_list2|
  rating_list2.split(', ').each do |rating2|
    Movie.where(:rating => rating2).each do |x2|
      step "I should not see \"#{x2[:title]}\""
    end
  end
end

Then /I should see all the movies/ do
  rows = page.all('table#movies tr').count - 1
  expect(rows).to eq Movie.all.length
end
