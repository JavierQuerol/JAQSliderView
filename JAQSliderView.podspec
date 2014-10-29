#
# Be sure to run `pod lib lint JAQSliderView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JAQSliderView"
  s.version          = "0.1.0"
  s.summary          = "Image Slider View with automatic image loader (tappable)"
  s.description      = <<-DESC
                       Image Slider View that takes objects that conforms to a protocol in order to provide an image url and a content url, so the slider automatically gets the images from the urls and shows them in the slider. The slider is tappable and has a delegate to know which object was tapped. 
                       DESC
  s.homepage         = "https://github.com/javierquerol/JAQSliderView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Javier Querol" => "querol.javi@gmail.com" }
  s.source           = { :git => "https://github.com/javierquerol/JAQSliderView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/javierquerol'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'JAQSliderView' => ['Pod/Assets/*.png']
  }

	s.dependency 'SDWebImage'
	s.frameworks = 'UIKit', 'QuartzCore'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
