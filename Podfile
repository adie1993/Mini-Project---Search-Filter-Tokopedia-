# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


use_frameworks!

  # Pods for TestTokped
  def install_pods
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'RealmSwift'
    pod 'SDWebImage'
    pod 'NVActivityIndicatorView'
    pod 'netfox'
    pod 'RevealingSplashView'
    pod 'RangeSeekSlider'
    pod 'TagListView', '~> 1.0'
  end

  target 'TestTokped' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    install_pods
  end
  target 'TestTokpedTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TestTokpedUITests' do
    inherit! :search_paths
    # Pods for testing
  end


post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

