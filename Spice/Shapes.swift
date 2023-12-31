//
//  Shapes.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import Foundation

class Component: Identifiable, ObservableObject {
    init(_ name: String, position: CGPoint, orientation: Direction, type: String, value: Double) {
        self.position = position
        self.orientation = orientation
        self.type = type
        self.value = value
        self.name = String(localized: LocalizedStringResource(stringLiteral: name))
        self.path = getPath(self)
    }
    let id = UUID()
    var value: Any = 0.0
    var name: String = "NAME"
    var position: CGPoint = CGPoint.zero
    var orientation: Direction = .top
    var type: String = ""
    var path: Path = Path.init()
    func draw(context: GraphicsContext, zoom: Double = 1.0, style: SymbolStyle = .IEC, cursor: CGPoint, color: Color = Color("CircuitColor"), selected: Bool = false) {
        context.drawLayer { ctx in
            if type != "W" {
                let resolved = ctx.resolve(Text(self.name).foregroundStyle(Color("CircuitColor")).font(.footnote))
                ctx.draw(resolved, at: self.position.applying(self.path.placeText(direction: self.orientation)), anchor: self.orientation.alignment)
            }
            ctx.fill(
                self.path,
                with: .color(Color("CanvasBackground"))
            )
            ctx.stroke(
                getPath(self, style: style),
                with: selected ? .color(.accentColor) : .color(color),
                lineWidth: 0.75/zoom
            )
            if selected {
                ctx.stroke(getPath(self, style: style),
                           with: .color(Color("AccentColor").opacity(0.1)),
                           lineWidth: 5/zoom
                           )
            }
        }
    }
}

class Wire: Identifiable {
    init(_ start: CGPoint, _ end: CGPoint) {
        self.start = start
        self.end = end
        self.path = Line(start: start, end: end)
            .path(in: CGRect(x: start.x, y: start.y, width: max(start.x-end.x, 10), height: max(start.y-start.y, 10)))
    }
    let id = UUID()
    var start: CGPoint
    var end: CGPoint
    var path: Path = Path.init()
}

func getPath(_ c: Component, style: SymbolStyle = .IEC) -> Path {
    let smallRect: CGRect = CGRect(x: c.position.x, y: c.position.y-8, width: 60, height: 16)
    let mediumRect: CGRect = CGRect(x: c.position.x, y: c.position.y-15, width: 60, height: 30)
    switch c.type {
    case "R":
        return Resistor(center: c.position, orientation: c.orientation, style: style).path(in: smallRect)
    case "L":
        return Inductor(center: c.position, orientation: c.orientation, style: style).path(in: smallRect)
    case "C":
        return Capacitor(center: c.position, orientation: c.orientation, style: style).path(in: smallRect)
    case "D":
        return Diode(center: c.position, orientation: c.orientation, style: style).path(in: smallRect)
    case "V":
        return VSource(center: c.position, orientation: c.orientation, style: style).path(in: smallRect)
    case "A":
        return ACVSource(center: c.position, orientation: c.orientation).path(in: smallRect)
    case "F":
        return Fuse(center: c.position, orientation: c.orientation).path(in: smallRect)
    case "I":
        return ISource(center: c.position, orientation: c.orientation, style: style).path(in: smallRect)
    case "P":
        return Lamp(center: c.position, orientation: c.orientation).path(in: smallRect)
    case "AMP":
        return Amplifier(center: c.position, orientation: c.orientation, style: style).path(in: mediumRect)
    case "GND":
        return Ground(center: c.position, orientation: c.orientation).path(in: CGRect(x: c.position.x, y: c.position.y-8, width: 20, height: 16))
    case "ETH":
        return Earth(center: c.position, orientation: c.orientation).path(in: CGRect(x: c.position.x, y: c.position.y-8, width: 20, height: 16))
    default:
        print("Type \(c.type) not displayed because not supported")
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
        path.addLine(to: CGPoint(x: 27, y: 0))
        path.move(to: CGPoint(x: 27, y: -10))
        path.addLine(to: CGPoint(x: 27, y: 10))
        path.move(to: CGPoint(x: 33, y: -10))
        path.addLine(to: CGPoint(x: 33, y: 10))
        path.move(to: CGPoint(x: 33, y: 0))
        path.addLine(to: CGPoint(x: 60, y: 0))
        return path.direct(center: center, direction: orientation)
    }
}

struct Earth: Shape {
    var center: CGPoint
    var orientation: Direction
    var style: SymbolStyle = .IEC

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 10, y: 0))
        path.move(to: CGPoint(x: 10, y: 8))
        path.addLine(to: CGPoint(x: 10, y: -8))
        path.move(to: CGPoint(x: 12.5, y: 6))
        path.addLine(to: CGPoint(x: 12.5, y: -6))
        path.move(to: CGPoint(x: 15, y: 4))
        path.addLine(to: CGPoint(x: 15, y: -4))
        return path.direct(center: center, direction: orientation)
    }
}

struct Ground: Shape {
    var center: CGPoint
    var orientation: Direction
    var style: SymbolStyle = .IEC

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 10, y: 0))
        path.move(to: CGPoint(x: 10, y: 8))
        path.addLine(to: CGPoint(x: 10, y: -8))
        path.addLine(to: CGPoint(x: 20, y: 0))
        path.addLine(to: CGPoint(x: 10, y: 8))
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
            path.addEllipse(in: CGRect(x: 15, y: -15, width: 30, height: 30))
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
            path.addEllipse(in: CGRect(x: 15, y: -15, width: 30, height: 30))
            return path.direct(center: center, direction: orientation)
        }
    }
}

struct ACVSource: Shape {
    var center: CGPoint
    var orientation: Direction

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 15, y: 0))
        path.addRoundedRect(in: CGRect(x: 15, y: -15, width: 30, height: 30), cornerSize: CGSize(width: 200, height: 200))
        path.move(to: CGPoint(x: 45, y: 0))
        path.addLine(to: CGPoint(x: 60, y: 0))
        path.move(to: CGPoint(x: 20, y: 0))
        path.addCurve(to: CGPoint(x: 40, y: 0), control1: CGPoint(x: 28.5, y: -20), control2: CGPoint(x: 31.5, y: 20))
        return path.direct(center: center, direction: orientation)
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
            path.addLine(to: CGPoint(x: 40, y: 0))
            path.move(to: CGPoint(x: 36, y: 5))
            path.addLine(to: CGPoint(x: 40, y: 0))
            path.move(to: CGPoint(x: 36, y: -5))
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

struct Lamp: Shape {
    var center: CGPoint
    var orientation: Direction

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 15, y: 0))
        path.addRoundedRect(in: CGRect(x: 15, y: -15, width: 30, height: 30), cornerSize: CGSize(width: 200, height: 200))
        path.move(to: CGPoint(x: 40.607, y: 10.607))
        path.addLine(to: CGPoint(x: 19.393, y: -10.607))
        path.move(to: CGPoint(x: 19.393, y: 10.607))
        path.addLine(to: CGPoint(x: 40.607, y: -10.607))
        path.move(to: CGPoint(x:45, y:0))
        path.addLine(to: CGPoint(x: 60, y: 0))
        return path.direct(center: center, direction: orientation)
    }
}

struct Fuse: Shape {
    var center: CGPoint
    var orientation: Direction

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 60, y: 0))
        path.addRect(CGRect(x: 10, y: -8, width: 40, height: 16))
        return path.direct(center: center, direction: orientation)
    }
}

struct Amplifier: Shape {
    var center: CGPoint
    var orientation: Direction
    var style: SymbolStyle = .IEC

    func path(in rect: CGRect) -> Path {
        switch style {
        case .ANSI_IEEE:
            var path = Path()
            path.move(to: CGPoint(x:0,y:-10))
            path.addLine(to: CGPoint(x: 10, y: -10))
            path.move(to: CGPoint(x:0,y:10))
            path.addLine(to: CGPoint(x: 10, y: 10))
            path.move(to: CGPoint(x:10,y:-20))
            path.addLine(to: CGPoint(x: 10, y: 20))
            path.move(to: CGPoint(x:10,y:20))
            path.addLine(to: CGPoint(x: 50, y: 0))
            path.move(to: CGPoint(x:10,y:-20))
            path.addLine(to: CGPoint(x: 50, y: 0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            // SIGNS
            path.move(to: CGPoint(x: 12.5, y: 10))
            path.addLine(to: CGPoint(x: 20, y: 10))
            path.move(to: CGPoint(x: 12.5, y: -10))
            path.addLine(to: CGPoint(x: 20, y: -10))
            path.move(to: CGPoint(x: 16.25, y: -6.25))
            path.addLine(to: CGPoint(x: 16.25, y: -13.75))
            return path.direct(center: center, direction: orientation)
        default:
            var path = Path()
            path.move(to: CGPoint(x: 0, y: -10))
            path.addLine(to: CGPoint(x: 10, y: -10))
            path.move(to: CGPoint(x: 0, y: 10))
            path.addLine(to: CGPoint(x: 10, y: 10))
            path.addRect(CGRect(x: 10, y: -20, width: 40, height: 40))
            path.move(to: CGPoint(x: 50, y:0))
            path.addLine(to: CGPoint(x: 60, y: 0))
            // SIGNS
            path.move(to: CGPoint(x: 12.5, y: 10))
            path.addLine(to: CGPoint(x: 20, y: 10))
            path.move(to: CGPoint(x: 12.5, y: -10))
            path.addLine(to: CGPoint(x: 20, y: -10))
            path.move(to: CGPoint(x: 16.25, y: -6.25))
            path.addLine(to: CGPoint(x: 16.25, y: -13.75))
            return path.direct(center: center, direction: orientation)
        }
    }
}

extension Path {
    func placeText(direction: Direction) -> CGAffineTransform {
        switch direction {
        case .top:
            return CGAffineTransform(translationX: self.boundingRect.width/2+5, y: 0)
        case .bottom:
            return CGAffineTransform(translationX: self.boundingRect.width/2+5, y: 0)
        default:
            return CGAffineTransform(translationX: 0, y: self.boundingRect.height/2+10)
        }
    }
}

enum Direction {
    case top, bottom, leading, trailing
    var angle: CGFloat {
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
    var alignment: UnitPoint {
        switch self {
        case .top:
            return .leading
        case .bottom:
            return .leading
        default:
            return .center
        }
    }
}

extension Path {
    func direct(center: CGPoint, direction: Direction) -> Path {
        return self
            .offsetBy(dx: -self.boundingRect.width/2.0, dy: 0)
            .applying(CGAffineTransform(rotationAngle: direction.angle))
            .offsetBy(dx: center.x, dy: center.y)
    }
}
