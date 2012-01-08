require 'rake'

Gem::Specification.new do |s|
    s.name        = 'KayakoClient'
    s.version     = '0.0.1b'
    s.platform    = Gem::Platform::RUBY

    s.author      = 'Kayako'
    s.email       = 's-andy@andriylesyuk.com'

    s.summary     = 'Official Ruby REST API Client for Kayako.'
    s.description = 'Kayako\'s official Ruby interface library for the REST API.'
    s.homepage    = 'http://forge.kayako.com/projects/kayako-ruby-api-library'

    s.files       = FileList['lib/**/*.rb']
end
