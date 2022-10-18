require_relative 'lib/htsgrid/version'

Gem::Specification.new do |spec|
  spec.name          = 'htsgrid'
  spec.version       = HTSGrid::VERSION
  spec.summary       = 'GUI HTS file view for Ruby'
  spec.homepage      = 'https://github.com/kojix2/htsgrid'
  spec.license       = 'MIT'

  spec.author        = 'kojix2'
  spec.email         = '2xijok@gmail.com'

  spec.files         = Dir['*.{md,txt}', '{lib}/**/*']
  spec.require_path  = 'lib'
  spec.bindir        = 'exe'
  spec.executables   = 'htsgrid'

  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency 'glimmer-dsl-libui'
  spec.add_dependency 'htslib'
end
