workspace 'RocketXsLaunchSpace'
project 'RocketXsLaunch/RocketXsLaunch'
platform :ios, '15.0'
use_frameworks!

def shared_pods
  pod 'Alamofire'
end

target 'RocketXsLaunch' do
  shared_pods
  
  target 'RocketXsLaunchTests'
end

def ios_pods
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Kingfisher'
end

target 'RocketXsLaunchiOS' do
  shared_pods
  ios_pods
  
  target 'RocketXsLaunchiOSTests'
end
