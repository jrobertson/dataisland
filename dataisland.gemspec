Gem::Specification.new do |s|
  s.name = 'dataisland'
  s.version = '0.2.0'
  s.summary = 'Transforms an HTML page containing XML data islands (a Microsoft Internet Explorer 5.0 like feature) to HTML.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/dataisland.rb']
  s.add_runtime_dependency('dynarex', '~> 1.7', '>=1.7.0')
  s.add_runtime_dependency('rxfhelper', '~> 0.2', '>=0.2.3')
  s.signing_key = '../privatekeys/dataisland.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/dataisland'
  s.required_ruby_version = '>= 2.1.2'
end
