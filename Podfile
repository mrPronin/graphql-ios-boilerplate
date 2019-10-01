# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

# CocoaPods master specs
source 'https://github.com/CocoaPods/Specs.git'
source 'https://mrpronin@bitbucket.org/mrpronin/privatepodspecs.git'

# Uncomment this line if you're using Swift
use_frameworks!

def gt_pods
  # Uncomment this line if you're using Swift or would like to use dynamic frameworks

# Pods for fortunica
    pod 'ReusableDataInput'
    # pod 'ReusableDataInput', :path => '~/Documents/Libraries/ReusableDataInput'
    pod 'iOSReusableExtensions'
    # pod 'iOSReusableExtensions', :path => '~/Documents/Libraries/iOSReusableExtensions'
    # pod 'iOSReusableExtensions', :git => 'https://github.com/adviqo-GmbH/iOSReusableExtensions.git', :tag => '1.0.0'
    pod 'GoogleSignIn'

    # pod 'FacebookCore'
    # pod 'FacebookLogin'
    # pod 'FacebookShare'
    # pod 'FBSDKLoginKit'
    pod 'FBSDKLoginKit'
    pod 'NVActivityIndicatorView'
    pod 'CryptoSwift'
    pod 'Toaster'
    pod 'Apollo'
end

target 'boilerplate' do
    gt_pods
end

target 'boilerplateDev' do
    gt_pods
end

target 'boilerplateTest' do
    gt_pods
end
