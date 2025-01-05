# Uncomment the next line to define a global platform for your project
platform :ios, '17.6'

source 'https://github.com/spotify/ios-sdk.git'
source 'https://cdn.cocoapods.org/'

target 'MoodScape' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MoodScape
  
  pod 'Gifu', '~> 3.3.1'

  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Firebase/Firestore'
  pod 'Alamofire'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Set the deployment target to iOS 17.6
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.6'
    end
  end
end
