# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, "log/cron_log.log"
env :PATH, ENV['PATH']
env :DISPLAY, ENV['DISPLAY']
set :environment, :development

every '15 0,9,12,18,21 * * *' do
  rake "gocha:get_url"
end

every '20 0,9,12,18,21 * * *' do
  rake "scan:url"
end
