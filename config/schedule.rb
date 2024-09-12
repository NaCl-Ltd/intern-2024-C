env :PATH, ENV['PATH']
set :output, 'log/cron.log'

every :day, at: '3:00am' do
  rake 'microposts:empty_trash'
end
