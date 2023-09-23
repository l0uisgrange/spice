//
//  Data.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import Foundation

struct Point {
    var x: Double = 0.0
    var y: Double = 0.0
}

struct Line {
    var color: Color
    let points: [Point]
}
