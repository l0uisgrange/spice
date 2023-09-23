//
//  Data.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import Foundation

struct Point {
    var x = 0
    var y = 0
}

struct Line {
    var color: Color
    let points: [Point]
}
