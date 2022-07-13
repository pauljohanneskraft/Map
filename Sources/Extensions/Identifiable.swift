//
//  Identifiable.swift
//  Map
//
//  Created by Paul Kraft on 23.04.22.
//

import Foundation

public struct IdentifiableObject<Object: AnyObject>: Identifiable, Equatable {
    public static func == (lhs: IdentifiableObject<Object>, rhs: IdentifiableObject<Object>) -> Bool {
        lhs.id == rhs.id
    }
    

    let object: Object

    public var id: ObjectIdentifier {
        ObjectIdentifier(object)
    }

}
