Gem::Specification.new do |s|
  s.name        = 'rays'
  s.version     = '0.1.0'
  s.summary     = 'SFL Liferay developer tool'
  s.description = 'Command line tool to create and manage liferay projects'

  s.author      = 'Dmitri Carpov'
  s.email       = 'dmitri.carpov@gmail.com'
  s.homepage    = 'http://projects.savoirfairelinux.net/projects/rays'

  s.files       = Dir['lib/**/*', 'lib/rays/config/templates/project/.rays', 'rubygems_hooks.rb']
  s.executables << '__rays_exec.rb'
  s.post_install_message = lambda {
    require('./rubygems_hooks.rb')
    require('colorize')
    return "registered rays function in your .bashrc\nplease make sure you reloaded your bash (execute . ~/.bashrc)".green
  }.call # awful way to do it, until a proper way to set gem hooks is found
end


