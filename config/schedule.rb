# https://github.com/javan/whenever
# execute the ff to update crontab file for jobs to get executed
# $ whenever --update-crontab

every 1.day, at: '12:00 pm' do
  runner "PersistPackagesWorker.perform_async(PackagesParser.perform)"
end
