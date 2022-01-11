workspace 'RocketXsLaunchSpace'
platform :ios, '15.0'
use_frameworks!

def shared_pods
  pod 'Alamofire'
end

def ios_pods
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Kingfisher'
end

project 'RocketXsLaunch/RocketXsLaunch'

target 'RocketXsLaunch' do
  project 'RocketXsLaunch/RocketXsLaunch'
  shared_pods
  target 'RocketXsLaunchTests'
end

target 'RocketXsLaunchiOS' do
  project 'RocketXsLaunch/RocketXsLaunch'
  shared_pods
  ios_pods
  target 'RocketXsLaunchiOSTests'
end

project 'RocketXsLaunchApp/RocketXsLaunchApp'
target 'RocketXsLaunchApp' do
  project 'RocketXsLaunchApp/RocketXsLaunchApp'
  shared_pods
  ios_pods
end
