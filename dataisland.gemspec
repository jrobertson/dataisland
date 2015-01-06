Gem::Specification.new do |s|
  s.name = 'dataisland'
  s.version = '0.1.18'
  s.summary = 'dataisland'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_runtime_dependency('dynarex', '~> 1.2', '>=1.2.90')
  s.add_runtime_dependency('rxfhelper', '~> 0.1', '>=0.1.12')
  s.signing_key = '../privatekeys/dataisland.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/dataisland'
  s.required_ruby_version = '>= 2.1.2'
end
