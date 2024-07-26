#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Permission'
  s.version          = '0.1.0'
  s.summary          = 'Pod for easily request permission'

  s.homepage         = 'https://github.com/minhvblc/Permission.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MinhND' => '' }
  s.source           = { :git => 'https://github.com/minhvblc/Permission.git', :tag => s.version.to_s }
  s.platform         = :ios, "13.0"
  s.ios.deployment_target = '14.0'
  s.source_files = 'Permission/Pod/Classes/**/*'

end
