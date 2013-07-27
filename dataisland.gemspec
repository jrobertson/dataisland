Gem::Specification.new do |s|
  s.name = 'dataisland'
  s.version = '0.1.13'
  s.summary = 'dataisland'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('dynarex')
  s.add_dependency('rxfhelper') 
  s.signing_key = '../privatekeys/dataisland.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/dataisland'
end
