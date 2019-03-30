platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!     #忽略警告

source 'https://github.com/CocoaPods/Specs.git'

def shared_pods
    pod 'CYLTabBarController', '~> 1.17.22'
    pod 'Masonry', '~> 1.0.1'
    #####LLCore 依赖库
    pod 'AFNetworking', '~> 3.2.0'
    pod 'SVProgressHUD', '~> 2.2.5'
    pod 'YYKit', '~> 1.0.6'
    pod 'SDWebImage', '~> 4.4.0'
    pod 'JSONModel', '~> 1.7.0'
    
    pod 'WechatOpenSDK'
    pod 'UMengUShare/Social/ReducedWeChat'
    pod 'UMengUShare/Social/QQ'
    pod 'UMengUShare/Social/Sina'
    pod 'MJRefresh', '~> 3.1.15.3'
    pod 'JMRoundedCorner'
    pod 'MBProgressHUD'
    #####
    pod 'Masonry', '~> 1.0.1'
    pod 'AMap3DMap' #3D地图SDK
    pod 'AMapSearch' #地图SDK搜索功能
    pod 'AMapLocation' #定位SDK
    pod 'SDCycleScrollView', '~> 1.75' #轮播
    pod 'RollingNotice' #上下滚动
    pod 'HXPhotoPicker', '~> 2.1.9' #图片选择器
    pod 'HJTabViewController', '~> 1.0'
    pod 'CocoaDebug', :configurations => ['Debug']
    pod 'AlipaySDK-iOS'
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
