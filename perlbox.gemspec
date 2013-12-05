Gem::Specification.new do |s|
  s.name         = 'perlbox'
  s.version      = '3.0.0'
  s.date         = '2012-01-01'
  s.summary      = "Puppet module for modern perl development with Vagrant"
  s.description  = "The lightweight portable reproducible perl virtualized development environment with baked-in CPAN and package automatic declarative version controlled dependency management."
  s.authors      = ["Gaurav Khanna"]
  s.email        = 'gauravk92@gmail.com'
  s.files        = ["lib/perlbox.rb", "lib/perlbox/installer.rb"]
  s.homepage     = 'http://rubygems.org/gems/perlbox'
  s.license      = 'bsd'
  s.executables  << 'perlbox'
end
