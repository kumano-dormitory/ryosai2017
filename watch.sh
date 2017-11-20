bundle exec ruby build.rb
bundle exec filewatcher base_data/*/*/* base_data/*/* base_data/* assets/* templates/* *.rb "rm -rf _site/*; bundle exec ruby build.rb; echo refreshed!" &
ruby -rwebrick -e 'WEBrick::HTTPServer.new(:DocumentRoot => "./_site", :Port => 8000).start'
