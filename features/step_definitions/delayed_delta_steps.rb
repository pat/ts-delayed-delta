When /^I run the delayed jobs$/ do
  if Delayed::Worker.respond_to? :backend
    Delayed::Worker.new(:quiet => true).work_off
  else
    Delayed::Job.work_off
  end
end

When /^I change the name of delayed beta (\w+) to (\w+)$/ do |current, replacement|
  DelayedBeta.find_by_name(current).update_attributes(:name => replacement)
end
