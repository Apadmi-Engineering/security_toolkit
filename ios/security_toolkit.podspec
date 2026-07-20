Pod::Spec.new do |s|
  s.name             = 'security_toolkit'
  s.version          = '0.0.1'
  s.summary          = 'Security utilities for Flutter apps.'
  s.description      = <<-DESC
Security utilities for Flutter apps.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Apadmi Ltd.' => 'tomh@apadmi.com' }
  s.source           = { :path => '.' }
  s.source_files = 'security_toolkit/Sources/security_toolkit/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
