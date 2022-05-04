
platform :ios, '11.0'

target 'Tickt' do
  
  use_frameworks!
  pod 'MoEngage-iOS-SDK', '~> 7.1.4' 
  pod 'Segment-MoEngage’, '~> 6.1.0'  
  pod 'SwiftyJSON'
  pod 'SDWebImage'
  pod 'GoogleMaps'
#, '~> 5.0.0'
  pod 'MessageKit'
  pod 'Toast-Swift'
  pod 'GoogleSignIn', '~> 5.0.2'
  pod 'GooglePlaces'
#, '~> 5.0.0'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'TagCellLayout'
  pod 'DZNEmptyDataSet'
  pod 'DZNEmptyDataSet'
  pod 'FloatRatingView'
  pod 'Firebase/Database'
  pod 'Cosmos'
#, '~> 23.0'
  pod 'Firebase/Messaging'
  pod 'TTTAttributedLabel'
  pod 'Alamofire', '~> 4.9.1'
  pod 'Socket.IO-Client-Swift'
  pod 'IQKeyboardManagerSwift'
  pod 'UITextView+Placeholder'
  pod 'JTAppleCalendar'
#, '~> 8.0'
  pod 'FloatRatingView'
  pod 'Intercom', '~> 10.3.0'
#, '~> 10.0.2'
  pod 'SwiftyJSON'
  pod 'Mixpanel-swift'
  pod 'Stripe'
  pod 'SwiftyDropbox'




  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings[‘EXCLUDED_ARCHS[sdk=iphonesimulator*]’] = ‘arm64’
     end
  end
end
