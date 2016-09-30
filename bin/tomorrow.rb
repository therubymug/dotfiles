#!/usr/bin/env ruby

require 'date'

# pass a date string like 2020-12-25 to this script and it will increment it by
# a day
starting_date = nil
if ARGV[0]
  starting_date = ARGV[0]
else
  starting_date = Date.today.to_s
end

original_date = Date.parse starting_date

# if today is Monday, increment by 3 because of the weekend
if (Date.today.wday == 1)
  puts original_date + 3
else
  puts original_date + 1
end
