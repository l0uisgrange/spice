//
//  Data.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import Foundation

struct Wire {
    var color: Color
    var points: [CGPoint]
}

struct Resistor {
    var color: Color
    var position: CGPoint
    var orientation: Angle
}
