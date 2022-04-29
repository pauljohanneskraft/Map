![Map](https://user-images.githubusercontent.com/15239005/165400895-182eb850-f05a-4aa5-b525-866efd5628c5.png)

MapKit's SwiftUI implementation of [Map](https://developer.apple.com/documentation/mapkit/map) (UIKit: [MKMapView](https://developer.apple.com/documentation/mapkit/mkmapview)) is very limited. This library can be used as a drop-in solution (i.e. it features a very similar, but more powerful and customizable interface) to the existing [Map](https://developer.apple.com/documentation/mapkit/map) and gives you so much more features and control:

## 🚀 Features

### 📍 Annotations
- Create annotations from annotationItems as in the default MapKit SwiftUI implementation.
- Or: Create annotations from a list of [MKAnnotation](https://developer.apple.com/documentation/mapkit/mkannotation) objects - you can even use your existing [MKAnnotationView](https://developer.apple.com/documentation/mapkit/mkannotationview) implementations!

### 🖼 Overlays
- Use a SwiftUI-style API based on `Identifiable` with overlay items and a closure to create overlays from these items
- Or: Use existing [MKOverlay](https://developer.apple.com/documentation/mapkit/mkoverlay) / [MKOverlayRenderer](https://developer.apple.com/documentation/mapkit/mkoverlayrenderer) objects

### 🛠 Appearance / Behavior Customization
- Map type ([MKMapType](https://developer.apple.com/documentation/mapkit/mkmaptype))
- User tracking mode ([MKUserTrackingMode](https://developer.apple.com/documentation/mapkit/mkusertrackingmode))
- Interaction modes (rotation, pitch, zoom and pan)
- Point of interest filter ([MKPointOfInterestFilter](https://developer.apple.com/documentation/mapkit/mkpointofinterestfilter)).

### 👀 Adapt visibility of:
- Buildings
- Compass
- Pitch control
- Scale
- Traffic
- User heading
- User location
- Zoom controls

### 🪄 Custom controls
- `MapCompass` for [MKCompassButton](https://developer.apple.com/documentation/mapkit/mkcompass)
- `MapPitchControl` for [MKPitchControl](https://developer.apple.com/documentation/mapkit/mkpitchcontrol)
- `MapScale` for [MKScaleView](https://developer.apple.com/documentation/mapkit/mkscaleview)
- `MapZoomControl` for [MKZoomControl](https://developer.apple.com/documentation/mapkit/mkzoomcontrol)

## 💻 Supported Platforms

| 📱 | iOS 13+ |
| :-: | :-: |
| 🖥 | **macOS 10.15+** | 
| 📺 | **tvOS 13+** |
| ⌚️ | **watchOS 6+** |

Keep in mind that not all features are equally available on all platforms (based on what MapKit provides) and therefore might not be available here either. However, if you can use them using UIKit, there is a very high change that it is available here as well - if not: Let me/us know by creating an issue!

## 🧑🏽‍💻 Usage on iOS, macOS and tvOS

Very similar to MapKit's SwiftUI wrapper, you simply create a `Map` view inside the body of your view. You can define a region or mapRect, the map type ([MKMapType](https://developer.apple.com/documentation/mapkit/mkmaptype)), a pointOfInterestFilter ([MKPointOfInterestFilter](https://developer.apple.com/documentation/mapkit/mkpointofinterestfilter)), interactions Modes (with values: .none, .pitch, .pan, .zoon, .rotate and .all - which can be combined as you wish) and showsUserLocation.

```swift
import Map
import SwiftUI

struct MyMapView: View {

    let locations: [MyLocation]
    let directions: MKDirections.Response
    
    @State private var region = MKCoordinateRegion()
    @State private var userTrackingMode = UserTrackingMode.follow

    var body: some View {
        Map(
          coordinateRegion: $region,
          type: .satelliteFlyover,
          pointOfInterestFilter: .excludingAll,
          informationVisibility: .default.union(.userLocation),
          interactionModes: [.pan, .rotate],
          userTrackingMode: $userTrackingMode,
          annotationItems: locations,
          annotationContent: { location in
              ViewMapAnnotation(coordinate: location.coordinate) {
                  Color.red
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
              }
          },
          overlays: directions.routes.map { $0.polyline },
          overlayContent: { overlay in
              RendererMapOverlay(overlay: overlay) { _, overlay in
                  if let polyline = overlay as? MKPolyline else {
                      let isFirstRoute = overlay === directions.routes.first?.overlay
                      let renderer = MKPolylineRenderer(polyline: polyline)
                      renderer.lineWidth = 6
                      renderer.strokeColor = isFirstRoute ? .systemBlue : .systemGray
                      return renderer
                  } else {
                      assertionFailure("Unknown overlay type found.")
                      return MKOverlayRenderer(overlay: overlay)
                  }
              }
          }
        )
        .onAppear {
            region = // ...
        }
    }

}
```

### 📍 Annotations: The modern approach

You can use a collection of items conforming to `Identifiable` and a closure that maps an item to its visual representation (available types: `MapPin`, `MapMarker` and `ViewMapAnnotation` for custom annotations from any SwiftUI `View`).

```swift
Map(
    coordinateRegion: $region,
    annotationItems: items,
    annotationContent: { item in
        if <first condition> {
            ViewMapAnnotation(coordinate: location.coordinate) {
                Color.red
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
             }
         else if <second condition> {
             MapMarker(coordinate: item.coordinate, tint: .red) // tint is `UIColor`, `NSColor` or `Color`
         } else {
             MapPin(coordinate: item.coordinate, tint: .blue) // tint is `UIColor`, `NSColor` or `Color`
         }
     }
)
```

### 📌 Annotations: The old-fashioned approach

Moving an existing code base over to SwiftUI is hard, especially when you want to keep methods, types and properties that you have previously built. This library, therefore, allows the use of [MKAnnotation](https://developer.apple.com/documentation/mapkit/mkannotation) instead of being forced to the new `Identifiable` style. In the additional closure, you can use one of the options mentioned in the modern-approach. Alternatively, we also have an option to use your own [MKAnnotationView](https://developer.apple.com/documentation/mapkit/mkannotationview) implementations. Simply create a struct conforming to the following protocol and you are good to go.

```swift
public protocol MapAnnotation {

    static func registerView(on mapView: MKMapView)
    
    var annotation: MKAnnotation { get }

    func view(for mapView: MKMapView) -> MKAnnotationView?
    
}
```

In `registerView(on:)`, your custom annotation implementation can register a cell type for dequeuing using [`MKMapView.register(_:forAnnotationViewWithReuseIdentifier:)`](https://developer.apple.com/documentation/mapkit/mkmapview/2887124-register). To dequeue the registered cell, implement the `view(for:)` method, similar to [`MKMapViewDelegate.mapView(_:viewFor:)`](https://developer.apple.com/documentation/mapkit/mkmapviewdelegate/1452045-mapview).

Note: Please make sure not to create the value of the property `annotation` dynamically. You can either use an existing object or create the object in your type's initializer. Simply put: Do not make `annotation` a computed property!

### 🌃 Overlays: The modern approach

Similarly to how annotations are handled, you can also use a collection of `Identifiable` and a closure mapping it to specific overlay types. These overlay types currently contain `MapCircle`, `MapMultiPolygon`, `MapMultiPolyline`, `MapPolygon` and `MapPolyline` and this list can easily be extended by creating a type conforming to the following protocol:

```swift
public protocol MapOverlay {

    var overlay: MKOverlay { get }
    
    func renderer(for mapView: MKMapView) -> MKOverlayRenderer
    
}
```

In your implementation, the `renderer(for:)` method creates a renderer for the overlay, similar to [`MKMapViewDelegate.mapView(_:rendererFor:)`](https://developer.apple.com/documentation/mapkit/mkmapviewdelegate/1452203-mapview).

Note: Please make sure not to create the value of the property `overlay` dynamically. You can either use an existing object or create the object in your type's initializer. Simply put: Do not make `overlay` a computed property!

### 🖼 Overlays: The old-fashioned approach

Especially when working with [MKDirections](https://developer.apple.com/documentation/mapkit/mkdirections) or when more customization to the [MKOverlayRenderer](https://developer.apple.com/documentation/mapkit/mkoverlayrenderer) is necessary, you can also provide an array of [MKOverlay](https://developer.apple.com/documentation/mapkit/mkoverlay) objects and use your own [MKOverlayRenderer](https://developer.apple.com/documentation/mapkit/mkoverlayrenderer).

For this, we provide `RendererMapOverlay`:

```swift
Map(
    coordinateRegion: $region,
    overlays: directions.routes.map { $0.polyline },
    overlayContent: { overlay in
        RendererMapOverlay(overlay: overlay) { mapView, overlay in
            guard let polyline = overlay as? MKPolyline else {
                assertionFailure("Unknown overlay type encountered.")
                return MKMapOverlayRenderer(overlay: overlay)
            }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.lineWidth = 4
            renderer.strokeColor = .red
            return renderer
        }
    }
)
```

### 🪄 Custom Map Controls

For the use of `MapCompass`, `MapPitchControl`, `MapScale` and `MapZoomControl` you will need to associate both the `Map` and the control with some form of a shared key. This key needs to conform to the `Hashable` protocol. For each key, there must only be one `Map` (or `MKMapView` respectively) in the view hierarchy at once.

Example: We want to display a scale overlay at the topLeading edge of a `Map`. To accomplish this, let's take a look at the following code snippet.

```swift

struct MyMapView: View {

    @Binding var region: MKCoordinateRegion
    
    var body: some View {
        Map(coordinateRegion: $region)
            .mapKey(1)
            .overlay(alignment: .topLeading) {
                MapScale(key: 1, alignment: .leading, visibility: .visible)
                    .fixedSize()
                    .padding(12)
            }
    }
}
```

## ⌚️ Usage on watchOS

Since MapKit is very limited on watchOS, there is a separate (also similary limited) wrapper in this library. If you are only targeting watchOS, it might not make sense to use this library as the underlying feature set is already very limited (e.g. no overlay support, only a few kinds of possible annotations, etc).

We do include a drop-in interface though for projects that target multiple platforms and share code extensively across these platforms.

```swift
Map(
    coordinateRegion: $region,
    informationVisibility: [.userHeading, .userLocation],
    userTrackingMode: $userTrackingMode,
    annotationItems: annotationItems,
    annotationContent: { item in
        if <first condition> {
            ImageAnnotation(coordinate: item.coordinate, image: UIImage(...), centerOffset: CGPoint(x: 0, y: -2) 
        } else {
            MapPin(coordinate: item.coordinate, color: .red) // color can only be red, green or purple
        }
    }
)
```

## 🔩 Installation

Map is currently only available via Swift Package Manager. See [this tutorial by Apple](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app) on how to add a package dependency to your Xcode project.

## ✍️ Author

Paul Kraft

## 📄 License

Map is available under the MIT license. See the LICENSE file for more info.
