set :output, "/home/deploy/qna/log/cron.log"

every 1.day do
  runner "DailyDigestJob.perform_now"
end

every 20.minutes do
  rake 'ts:index'
end
