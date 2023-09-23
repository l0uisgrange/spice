//
//  Data.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import Foundation

struct Line {
    var color: Color
    var points: [CGPoint]
}

class CircuitComponent: Identifiable {
    init(color: Color, start: CGPoint, end: CGPoint, type: String) {
        self.color = color
        self.startingPoint = start
        self.endingPoint = end
        self.type = type
    }
    let id = UUID()
    var color: Color = .primary
    var startingPoint: CGPoint = CGPoint.zero
    var endingPoint: CGPoint = CGPoint.zero
    var type: String = ""
}
