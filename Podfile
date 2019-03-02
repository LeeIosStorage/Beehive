platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!     #忽略警告

source 'https://github.com/CocoaPods/Specs.git'

def shared_pods
    pod 'CYLTabBarController', '~> 1.17.22'
    pod 'Masonry', '~> 1.0.1'
    #####LLCore 依赖库
    pod 'AFNetworking', '~> 3.2.0'
    pod 'SVProgressHUD', '~> 2.0.3'
    pod 'YYKit', '~> 1.0.6'
    pod 'SDWebImage', '~> 3.8.0'
    pod 'JSONModel', '~> 1.7.0'
    pod 'UMengUShare/Social/WeChat'
    pod 'UMengUShare/Social/QQ'
    pod 'UMengUShare/Social/Sina'
    pod 'MJRefresh', '~> 3.1.15.3'
    pod 'JMRoundedCorner'
    pod 'MBProgressHUD'
    #####
    pod 'Masonry', '~> 1.0.1'
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
