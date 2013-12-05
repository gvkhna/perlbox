Gem::Specification.new do |s|
  s.name         = 'perlbox'
  s.version      = '3.0.0'
  s.date         = Date.today
  s.authors      = ["Gaurav Khanna"]
  s.email        = 'gauravk92@gmail.com'
  s.homepage     = 'http://gauravk92.github.io/perlbox'
  s.license      = 'BSD'
  s.summary      = "Puppet module for modern perl development with Vagrant "
  s.description  = "The lightweight portable reproducible perl virtualized "  \
                   "development environment with baked-in CPAN and package "  \
                   "automatic declarative version controlled dependency "     \
                   "management."

  s.files = Dir["lib/**/*.rb"] + %w{ bin/perlbox README.md LICENSE CHANGELOG.md }
  s.executables   = %w{ perlbox }
  s.require_paths = %w{ lib }

  s.add_runtime_dependency 'claide', '~> 0.4.0'
  s.add_runtime_dependency 'colored', '~> 1.2'
  s.add_runtime_dependency 'escape', '~> 0.0.4'
end
