//
//  UnitPoint.swift
//  Map
//
//  Created by Darron Schall on 10/2/23.
//

import SwiftUI

extension UnitPoint {
    
    func toCGPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }

    func toCenterOffset(in rect: CGRect) -> CGPoint {
        return CGPoint(
            x: (0.5 - x) * rect.width,
            y: (0.5 - y) * rect.height
        )
    }

}
