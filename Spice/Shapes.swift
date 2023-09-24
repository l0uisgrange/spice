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
            if type != "W" {
                ctx.translateBy(x: startingPoint.x, y: startingPoint.y)
                ctx.rotate(by: Angle(degrees: startingPoint.x == endingPoint.x ? 90 : 0))
            }
            ctx.stroke(
                getPath(self, style: style),
                with: .color(color),
                lineWidth: 1.35/zoom
            )
        }
    }
}

func getPath(_ c: CircuitComponent, style: Int = 1) -> Path {
    switch c.type {
    case "W":
        return Wire(start: c.startingPoint, end: c.endingPoint).path()
    case "R":
        return Resistor(start: c.startingPoint, end: c.endingPoint, style: style).path()
    default:
        return Wire(start: c.startingPoint, end: c.endingPoint).path()
    }
}

struct Wire: Shape {
    var start: CGPoint
    var end: CGPoint

    func path(in rect: CGRect = CGRect(x: 0, y: -1, width: 400, height: 2)) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct Resistor: Shape {
    var start: CGPoint
    var end: CGPoint
    var style: Int = 1

    func path(in rect: CGRect = CGRect(x: 0, y: -20, width: 60, height: 40)) -> Path {
        switch style {
        case 2:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addLine(to: CGPoint(x: 10, y: -10))
            path.addLine(to: CGPoint(x: 50, y: -10))
            path.addLine(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            path.move(to: CGPoint(x: 10, y: 0))
            path.addLine(to: CGPoint(x: 10, y: 10))
            path.addLine(to: CGPoint(x: 50, y: 10))
            path.addLine(to: CGPoint(x: 50, y: 0))
            return path
        default:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addLine(to: CGPoint(x: 15, y: -10))
            path.addLine(to: CGPoint(x: 25, y: 10))
            path.addLine(to: CGPoint(x: 35, y: -10))
            path.addLine(to: CGPoint(x: 45, y: 10))
            path.addLine(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path
        }
    }
}

struct Inductor: Shape {
    var start: CGPoint
    var end: CGPoint
    var style: Int = 1

    func path(in rect: CGRect = CGRect(x: 0, y: -20, width: 60, height: 40)) -> Path {
        var path = Path()
        path.move(to: start)
        path.move(to: start)
        return path
    }
}
