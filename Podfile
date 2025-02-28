platform :ios, '13.0'  # Update to 13.0 or higher

target 'StryVr' do
  use_frameworks!

  # ✅ Firebase Dependencies (Updated)
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Analytics'
  pod 'Firebase/AppCheck'
  pod 'Firebase/AppDistribution'
  pod 'Firebase/Crashlytics'
  
  # ✅ Logging & Debugging
  pod 'CocoaLumberjack/Swift' 

  # ✅ Fix Apple Silicon Compatibility
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64' 
      end
    end
  end
end

