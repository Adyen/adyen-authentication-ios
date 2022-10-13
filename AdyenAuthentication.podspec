version = '1.1.1'

Pod::Spec.new do |spec|
  spec.name                   = 'AdyenAuthentication'
  spec.version                = version
  spec.license                = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  spec.homepage               = 'https://adyen.com'
  spec.authors                = { 'Adyen' => 'support@adyen.com' }
  spec.summary                = 'Adyen passwordless Authentication SDK.'
  spec.source                 = { :git => 'https://github.com/Adyen/adyen-authentication-ios.git', :tag => version }
  spec.vendored_frameworks    = 'XCFramework/Dynamic/AdyenAuthentication.xcframework'
  spec.ios.deployment_target  = '10.0'
end
