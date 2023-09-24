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
    init(_ name: String, color: Color, start: CGPoint, end: CGPoint, type: String, value: Double) {
        self.color = color
        self.startingPoint = start
        self.endingPoint = end
        self.type = type
        self.value = value
        self.name = name
    }
    let id = UUID()
    var value: Any = 0.0
    var name: String = ""
    var color: Color = .primary
    var startingPoint: CGPoint = CGPoint.zero
    var endingPoint: CGPoint = CGPoint.zero
    var type: String = ""
    func draw(context: GraphicsContext, zoom: Double = 1.0, style: Int = 1) {
        context.drawLayer { ctx in
            ctx.stroke(
                Path() { path in
                    path.move(to: startingPoint)
                    for point in componentToLine(self, style: style) {
                        path.addLine(to: point)
                    }
                },
                with: .color(color),
                lineWidth: 1.35/zoom
            )
            ctx.translateBy(x: startingPoint.x, y: startingPoint.y)
        }
    }
}

func componentToLine(_ c: CircuitComponent, style: Int = 1) -> [CGPoint] {
    if c.type == "W" { return [c.endingPoint] }
    switch c.type {
    case "R":
        if style == 1 {
            return [
                CGPoint(x: 0, y: 0),
                CGPoint(x: 10, y: 0),
                CGPoint(x: 15, y: -10),
                CGPoint(x: 25, y: 10),
                CGPoint(x: 35, y: -10),
                CGPoint(x: 45, y: 10),
                CGPoint(x: 50, y: 0),
                CGPoint(x: 60, y: 0)
            ]
        } else {
            return [
                CGPoint(x: 0, y: 0),
                CGPoint(x: 10, y: 0),
                CGPoint(x: 10, y: -7),
                CGPoint(x: 50, y: -7),
                CGPoint(x: 50, y: 7),
                CGPoint(x: 10, y: 7),
                CGPoint(x: 10, y: 0),
                CGPoint(x: 10, y: 7),
                CGPoint(x: 50, y: 7),
                CGPoint(x: 50, y: 0),
                CGPoint(x: 60, y: 0)
            ]
        }
    default:
        return []
    }
}
