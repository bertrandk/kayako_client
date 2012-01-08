require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
    test.warning = true
end

task :default => :test
