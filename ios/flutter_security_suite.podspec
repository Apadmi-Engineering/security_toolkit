Pod::Spec.new do |s|
  s.name             = 'flutter_security_suite'
  s.version          = '0.0.1'
  s.summary          = 'Security utilities for Flutter apps.'
  s.description      = <<-DESC
Security utilities for Flutter apps.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Apadmi Ltd.' => 'tomh@apadmi.com' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_security_suite/Sources/flutter_security_suite/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
