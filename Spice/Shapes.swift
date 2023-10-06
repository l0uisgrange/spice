//
//  Shapes.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import Foundation

class Component: Identifiable {
    init(_ name: String, position: CGPoint, orientation: Direction, type: String, value: Double) {
        self.position = position
        self.orientation = orientation
        self.type = type
        self.value = value
        self.name = NSLocalizedString(name, comment: "")
        self.path = getPath(self)
    }
    let id = UUID()
    var value: Any = 0.0
    var name: String = ""
    var position: CGPoint = CGPoint.zero
    var orientation: Direction = .top
    var type: String = ""
    var path: Path = Path.init()
    func draw(context: GraphicsContext, zoom: Double = 1.0, style: SymbolStyle = .IEC, cursor: CGPoint, color: Color = Color("CircuitColor")) {
        context.drawLayer { ctx in
            ctx.stroke(
                getPath(self, style: style),
                with: .color(color),
                lineWidth: 1/zoom
            )
            if type == "L" && style == .IEC {
                ctx.fill(
                    self.path,
                    with: .color(color)
                )
            }
        }
    }
}

class Wire: Identifiable {
    init(_ start: CGPoint, _ end: CGPoint) {
        self.start = start
        self.end = end
        self.path = Line(start: start, end: end).path(in: CGRect(x: start.x, y: start.y, width: max(start.x-end.x, 1.2), height: max(start.y-start.y, 1.2)))
    }
    let id = UUID()
    var start: CGPoint
    var end: CGPoint
    var path: Path = Path.init()
}

func getPath(_ c: Component, style: SymbolStyle = .IEC) -> Path {
    let rect: CGRect = CGRect(x: c.position.x, y: c.position.y-8, width: 60, height: 16)
    switch c.type {
    case "R":
        return Resistor(center: c.position, orientation: c.orientation, style: style).path(in: rect)
    case "L":
        return Inductor(center: c.position, orientation: c.orientation, style: style).path(in: rect)
    case "C":
        return Capacitor(center: c.position, orientation: c.orientation, style: style).path(in: rect)
    case "D":
        return Diode(center: c.position, orientation: c.orientation, style: style).path(in: rect)
    case "V":
        return VSource(center: c.position, orientation: c.orientation, style: style).path(in: rect)
    case "I":
        return ISource(center: c.position, orientation: c.orientation, style: style).path(in: rect)
    default:
        print("Type not printed because not supported")
        return Path.init()
    }
}

struct Line: Shape {
    var start: CGPoint
    var end: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct Resistor: Shape {
    var center: CGPoint
    var orientation: Direction
    var style: SymbolStyle = .IEC

    func path(in rect: CGRect) -> Path {
        switch style {
        case .ANSI_IEEE:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addLine(to: CGPoint(x: 15, y: -rect.height/2))
            path.addLine(to: CGPoint(x: 25, y: rect.height/2))
            path.addLine(to: CGPoint(x: 35, y: -rect.height/2))
            path.addLine(to: CGPoint(x: 45, y: rect.height/2))
            path.addLine(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path.direct(center: center, direction: orientation)
        default:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addRect(CGRect(x: 10, y: -8, width: 40, height: 16))
            path.move(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path.direct(center: center, direction: orientation)
        }
    }
}

struct Capacitor: Shape {
    var center: CGPoint
    var orientation: Direction
    var style: SymbolStyle = .IEC

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 20, y: 0))
        path.move(to: CGPoint(x: 20, y: -8))
        path.addLine(to: CGPoint(x: 20, y: 8))
        path.move(to: CGPoint(x: 30, y: -8))
        path.addLine(to: CGPoint(x: 30, y: 8))
        path.move(to: CGPoint(x: 30, y: 0))
        path.addLine(to: CGPoint(x: 50, y: 0))
        return path.direct(center: center, direction: orientation)
    }
}

struct Inductor: Shape {
    var center: CGPoint
    var orientation: Direction
    var style: SymbolStyle = .IEC

    func path(in rect: CGRect) -> Path {
        switch style {
        case .ANSI_IEEE:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addArc(center: CGPoint(x: 18 , y: 0), radius: 8, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 320), clockwise: true)
            path.addArc(center: CGPoint(x: 30, y: 0), radius: 8, startAngle: Angle(degrees: 220), endAngle: Angle(degrees: 320), clockwise: true)
            path.addArc(center: CGPoint(x: 42, y: 0), radius: 8, startAngle: Angle(degrees: 220), endAngle: Angle(degrees: 0), clockwise: true)
            path.move(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path.direct(center: center, direction: orientation)
        default:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addRect(CGRect(x: 10, y: -8, width: 40, height: 15))
            path.move(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path.direct(center: center, direction: orientation)
        }
    }
}

struct VSource: Shape {
    var center: CGPoint
    var orientation: Direction
    var style: SymbolStyle = .IEC

    func path(in rect: CGRect) -> Path {
        switch style {
        case .ANSI_IEEE:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 15, y: 0))
            path.addRoundedRect(in: CGRect(x: 15, y: -15, width: 30, height: 30), cornerSize: CGSize(width: 200, height: 200))
            path.move(to: CGPoint(x: 20, y: 0))
            path.addLine(to: CGPoint(x: 27.5, y: 0))
            path.move(to: CGPoint(x: 23.75, y: 3.75))
            path.addLine(to: CGPoint(x: 23.75, y: -3.75))
            path.move(to: CGPoint(x: 32.5, y: 0))
            path.addLine(to: CGPoint(x: 40, y: 0))
            path.move(to: CGPoint(x: 45, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            return path.direct(center: center, direction: orientation)
        default:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 60, y: 0))
            path.addRoundedRect(in: CGRect(x: 15, y: -15, width: 30, height: 30), cornerSize: CGSize(width: 200, height: 200))
            return path.direct(center: center, direction: orientation)
        }
    }
}

struct Diode: Shape {
    var center: CGPoint
    var orientation: Direction
    var style: SymbolStyle = .IEC

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 20, y: 0))
        path.addLine(to: CGPoint(x: 20, y: 8))
        path.addLine(to: CGPoint(x: 40, y: 0))
        path.addLine(to: CGPoint(x: 20, y: -8))
        path.addLine(to: CGPoint(x: 20, y: 0))
        path.move(to: CGPoint(x: 40, y: 8))
        path.addLine(to: CGPoint(x: 40, y: -8))
        path.move(to: CGPoint(x: 40, y: 0))
        path.addLine(to: CGPoint(x: 60, y: 0))
        return path.direct(center: center, direction: orientation)
    }
}

struct ISource: Shape {
    var center: CGPoint
    var orientation: Direction
    var style: SymbolStyle = .IEC

    func path(in rect: CGRect) -> Path {
        switch style {
        case .ANSI_IEEE:
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
            return path.direct(center: center, direction: orientation)
        default:
            var path = Path()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 15, y: 0))
            path.addRoundedRect(in: CGRect(x: 15, y: -15, width: 30, height: 30), cornerSize: CGSize(width: 200, height: 200))
            path.move(to: CGPoint(x:45, y:0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            path.move(to: CGPoint(x:30, y:-15))
            path.addLine(to: CGPoint(x: 30, y: 15))
            return path.direct(center: center, direction: orientation)
        }
    }
}

enum Direction {
    case top, bottom, leading, trailing
    func getAngle() -> CGFloat {
        switch self {
        case .top:
            return -.pi/2
        case .bottom:
            return .pi/2
        case .trailing:
            return 0.0
        default:
            return .pi
        }
    }
}

extension Path {
    func direct(center: CGPoint, direction: Direction) -> Path {
        return self.offsetBy(dx: -30, dy: 0).applying(CGAffineTransform(rotationAngle: direction.getAngle())).offsetBy(dx: center.x, dy: center.y)
    }
}
