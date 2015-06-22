Pod::Spec.new do |s|
  s.name             = "Swalt"
  s.version          = "0.1.1"
  s.license          = 'MIT'
  s.summary          = "Flux implementation in pure Swift 2"
  s.homepage         = "https://github.com/mikker/Swalt"
  s.authors          = { "Mikkel Malmberg" => "mikkel@brnbw.com" }
  s.source           = { :git => "https://github.com/mikker/Swalt.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/mikker'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.dependency 'Dispatcher', '~> 0.1'

  s.source_files = 'Pod/Classes/**/*'
  s.requires_arc = true
end
