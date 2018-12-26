namespace :foreman do
  desc 'A helper task to run foreman start with Procfile.dev'
  task :start do
    FILE_NAME = 'Procfile.dev'.freeze
    content = "web: bundle exec rails server -b 0.0.0.0 -p $PORT\n"
    content += "worker: bundle exec foreman start -f Procfile.workers\n"
    content += "redis: redis-server\n"

    File.open(FILE_NAME, 'w+') do |f|
      f.write(content)
    end
    system('foreman start -f Procfile.dev')
  end
end
