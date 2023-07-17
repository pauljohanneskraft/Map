//
//  File.swift
//  
//
//  Created by Jesse Born on 17.07.23.
//

import Foundation

extension Map {
    func bottomInset (_ inset: CGFloat) -> Map {
        var view = self
        view.bottomInset = inset
        return view
    }
}
