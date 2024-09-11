namespace :microposts do
  desc 'Empty trash'
  task empty_trash: :environment do
    destroyed = Micropost.where(discarded_at: ..30.days.ago).destroy_all
    puts "Destroyed #{destroyed.size} microposts."
  end
end
