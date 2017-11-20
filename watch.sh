bundle exec ruby build.rb
bundle exec filewatcher base_data/*/*/* base_data/*/* base_data/* assets/* templates/* site.rb "bundle exec ruby build.rb" &
ruby -rwebrick -e 'WEBrick::HTTPServer.new(:DocumentRoot => "./_site", :Port => 8000).start'
