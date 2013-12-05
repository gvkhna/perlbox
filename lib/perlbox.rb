class Perlbox
  def self.start
    installer = Installer.new
    installer.install
  end
end

require 'perlbox/installer'
