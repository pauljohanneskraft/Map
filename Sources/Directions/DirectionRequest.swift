import MapKit

public struct DirectionRequest {
    public struct RouteAppearance {
        public let lineWidth: CGFloat
        public let strokeColor: NativeColor
        
        public init(lineWidth: CGFloat, strokeColor: NativeColor) {
            self.lineWidth = lineWidth
            self.strokeColor = strokeColor
        }
    }
    
    public let mkRequest: MKDirections.Request
    public let routeAppearance: RouteAppearance
    public let sourceAnnotation: MapAnnotation
    public let destinationAnnotation: MapAnnotation
    
    public init(mkRequest: MKDirections.Request,
                routeAppearance: RouteAppearance,
                sourceAnnotation: MapAnnotation,
                destinationAnnotation: MapAnnotation) {
        self.mkRequest = mkRequest
        self.routeAppearance = routeAppearance
        self.sourceAnnotation = sourceAnnotation
        self.destinationAnnotation = destinationAnnotation
    }
}

extension DirectionRequest: Equatable {
    public static func ==(lhs: DirectionRequest, rhs: DirectionRequest) -> Bool {
        lhs.mkRequest == rhs.mkRequest
    }
}
