//
//  Data.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import Foundation

class CircuitComponent: Identifiable {
    init(_ name: String, start: CGPoint, end: CGPoint, type: String, value: Double) {
        self.startingPoint = start
        self.endingPoint = end
        self.type = type
        self.value = value
        self.name = NSLocalizedString(name, comment: "")
    }
    let id = UUID()
    var value: Any = 0.0
    var name: String = ""
    var startingPoint: CGPoint = CGPoint.zero
    var endingPoint: CGPoint = CGPoint.zero
    var type: String = ""
    func draw(context: GraphicsContext, zoom: Double = 1.0, style: Int = 1, cursor: CGPoint, color: Color = Color.primary) {
        context.drawLayer { ctx in
            if type != "W" {
                ctx.translateBy(x: startingPoint.x, y: startingPoint.y)
                ctx.rotate(by: Angle(degrees: startingPoint.x == endingPoint.x ? 90 : 0))
            }
            ctx.stroke(
                getPath(self, style: style),
                with: .color(color),
                lineWidth: 1.1/zoom
            )
            if type == "I" && style == 2 {
                ctx.fill(
                    getPath(self, style: style),
                    with: .color(color)
                )
            }
        }
    }
}

func getPath(_ c: CircuitComponent, style: Int = 1) -> Path {
    switch c.type {
    case "W":
        return Wire(start: c.startingPoint.alignedPoint, end: c.endingPoint.alignedPoint).path()
    case "R":
        return Resistor(start: c.startingPoint.alignedPoint, end: c.endingPoint.alignedPoint, style: style).path()
    case "L":
        return Inductor(start: c.startingPoint.alignedPoint, end: c.endingPoint.alignedPoint, style: style).path()
    case "C":
        return Capacitor(start: c.startingPoint.alignedPoint, end: c.endingPoint.alignedPoint, style: style).path()
    case "V":
        return VSource(start: c.startingPoint.alignedPoint, end: c.endingPoint.alignedPoint, style: style).path()
    case "I":
        return ISource(start: c.startingPoint.alignedPoint, end: c.endingPoint.alignedPoint, style: style).path()
    default:
        return Wire(start: c.startingPoint.alignedPoint, end: c.endingPoint.alignedPoint).path()
    }
}

struct Wire: Shape {
    var start: CGPoint
    var end: CGPoint

    func path(in rect: CGRect = CGRect(x: 0, y: -5, width: 400, height: 10)) -> Path {
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

    func path(in rect: CGRect = CGRect(x: 0, y: -8, width: 60, height: 16)) -> Path {
        switch style {
        case 2:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addRect(CGRect(x: 10, y: -8, width: 40, height: 15))
            path.move(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path
        default:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addLine(to: CGPoint(x: 15, y: -rect.height/2))
            path.addLine(to: CGPoint(x: 25, y: rect.height/2))
            path.addLine(to: CGPoint(x: 35, y: -rect.height/2))
            path.addLine(to: CGPoint(x: 45, y: rect.height/2))
            path.addLine(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path
        }
    }
}

struct Capacitor: Shape {
    var start: CGPoint
    var end: CGPoint
    var style: Int = 1

    func path(in rect: CGRect = CGRect(x: 0, y: -8, width: 60, height: 16)) -> Path {
        switch style {
        case 2:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addRect(CGRect(x: 10, y: -8, width: 40, height: 15))
            path.move(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path
        default:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addLine(to: CGPoint(x: 15, y: -rect.height/2))
            path.addLine(to: CGPoint(x: 25, y: rect.height/2))
            path.addLine(to: CGPoint(x: 35, y: -rect.height/2))
            path.addLine(to: CGPoint(x: 45, y: rect.height/2))
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

    func path(in rect: CGRect = CGRect(x: 0, y: -8, width: 60, height: 16)) -> Path {
        switch style {
        case 2:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addRect(CGRect(x: 10, y: -8, width: 40, height: 15))
            path.move(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path
        default:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addArc(center: CGPoint(x: 18 , y: 0), radius: 8, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 320), clockwise: true)
            path.addArc(center: CGPoint(x: 30, y: 0), radius: 8, startAngle: Angle(degrees: 220), endAngle: Angle(degrees: 320), clockwise: true)
            path.addArc(center: CGPoint(x: 42, y: 0), radius: 8, startAngle: Angle(degrees: 220), endAngle: Angle(degrees: 0), clockwise: true)
            path.move(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path
        }
    }
}

struct VSource: Shape {
    var start: CGPoint
    var end: CGPoint
    var style: Int = 1

    func path(in rect: CGRect = CGRect(x: 0, y: -8, width: 60, height: 16)) -> Path {
        switch style {
        case 2:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 60, y: 0))
            path.addRoundedRect(in: CGRect(x: 15, y: -15, width: 30, height: 30), cornerSize: CGSize(width: 200, height: 200))
            return path
        default:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 15, y: 0))
            path.addRoundedRect(in: CGRect(x: 15, y: -15, width: 30, height: 30), cornerSize: CGSize(width: 200, height: 200))
            path.move(to: CGPoint(x: 20, y: 0))
            path.addLine(to: CGPoint(x: 25, y: 0))
            path.move(to: CGPoint(x: 22.5, y: 2.5))
            path.addLine(to: CGPoint(x: 22.5, y: -2.5))
            path.move(to: CGPoint(x: 35, y: 0))
            path.addLine(to: CGPoint(x: 40, y: 0))
            path.move(to: CGPoint(x: 45, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path
        }
    }
}

struct ISource: Shape {
    var start: CGPoint
    var end: CGPoint
    var style: Int = 1

    func path(in rect: CGRect = CGRect(x: 0, y: -8, width: 60, height: 16)) -> Path {
        switch style {
        case 2:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 15, y: 0))
            path.addRoundedRect(in: CGRect(x: 15, y: -15, width: 30, height: 30), cornerSize: CGSize(width: 200, height: 200))
            path.move(to: CGPoint(x:45, y:45))
            path.addLine(to: CGPoint(x: 60, y: 0))
            path.move(to: CGPoint(x:30, y:-15))
            path.addLine(to: CGPoint(x: 30, y: 15))
            return path
        default:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 15, y: 0))
            path.addRoundedRect(in: CGRect(x: 15, y: -15, width: 30, height: 30), cornerSize: CGSize(width: 200, height: 200))
            path.move(to: CGPoint(x: 20, y: 0))
            path.addLine(to: CGPoint(x: 25, y: 0))
            path.move(to: CGPoint(x: 22.5, y: 2.5))
            path.addLine(to: CGPoint(x: 22.5, y: -2.5))
            path.move(to: CGPoint(x: 35, y: 0))
            path.addLine(to: CGPoint(x: 40, y: 0))
            path.move(to: CGPoint(x: 45, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path
        }
    }
}
