Pod::Spec.new do |spec|

  spec.name          = 'Map'
  spec.version       = '0.1.0'
  spec.license       = { :type => 'MIT' }
  spec.homepage      = 'https://github.com/pauljohanneskraft/Map'
  spec.authors       = { 'Paul Kraft' => 'pauljohanneskraft@users.noreply.github.com' }
  spec.summary       = 'MKMapView wrapper for SwiftUI as drop-in to MapKit\'s SwiftUI view. Easily extensible annotations and overlays, iOS 13 support and backwards compatible with MKAnnotation and MKOverlay!'
  spec.source        = { :git => 'https://github.com/pauljohanneskraft/Map', :tag => '0.1.0' }
  spec.module_name   = 'Map'
  spec.swift_version = '5.1'

  spec.ios.deployment_target = '13.0'
  spec.osx.deployment_target = '10.15'
  spec.tvos.deployment_target = '13.0'
  spec.watchos.deployment_target = '6.0'

  spec.source_files = 'Sources/**/*.swift'

  spec.framework = 'SwiftUI'
  spec.ios.framework = 'UIKit'
  spec.osx.framework = 'AppKit'
  spec.tvos.framework = 'UIKit'
  spec.watchos.framework = 'WatchKit'

end
