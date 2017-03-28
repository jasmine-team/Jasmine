# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'Jasmine' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Jasmine
  pod 'RealmSwift'
  pod 'SwiftLint'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
  pod 'SnapKit', '~> 3.2.0'

  target 'JasmineTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'JasmineUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
