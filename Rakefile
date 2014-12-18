task :default => :test

desc "run the tests"
	task :test => :spec do
    	sh "ruby test/test.rb"
end

desc "Run server"
    task :server do
      sh "rackup"
end

desc "run the specs"
	task :spec do
	sh "bundle exec rspec spec"
end