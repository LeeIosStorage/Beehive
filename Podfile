platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!     #忽略警告

source 'https://github.com/CocoaPods/Specs.git'

def shared_pods
  pod 'AFNetworking', '~> 3.2.0'
end

target 'Beehive' do
  shared_pods

  target 'BeehiveTests' do
    inherit! :search_paths
  end

  target 'BeehiveUITests' do
    inherit! :search_paths
  end

end
