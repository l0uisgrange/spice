//
//  CanvasView.swift
//  Spice
//
//  Created by Louis Grange on 23.09.2023.
//

import SwiftUI

struct CanvasView: View {
    @State var geometry: GeometryProxy
    @State private var canvasContentOffset: CGPoint = CGPoint.zero
    @AppStorage("symbolsStyle") private var symbolsStyle: SymbolStyle = .ANSI
    @AppStorage("gridStyle") private var gridStyle = 1
    @Binding var origin: CGPoint
    @Binding var zoom: Double
    @State private var currentZoom: Double = 0.0
    @State private var cursorPosition: CGPoint = CGPoint.zero
    @Binding var components: [CircuitComponent]
    @State private var hoverLocation: CGPoint = .zero
    @State private var isHovering = false
    @GestureState private var magnifyBy = 1.0
    @Binding var editionMode: String
    @Binding var orientationMode: Direction
    var body: some View {
        Canvas { context, size in
            let windowWidth = geometry.size.width
            let windowHeight = geometry.size.height
            //context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.white))
            context.translateBy(x: windowWidth/2.0 + origin.x + canvasContentOffset.x, y: windowHeight / 2 + origin.y + canvasContentOffset.y)
            context.scaleBy(x: zoom + currentZoom, y: zoom + currentZoom)
            context.drawGrid(gridStyle: gridStyle, zoom: zoom + currentZoom)
            if editionMode != "" {
                CircuitComponent(editionMode, position: hoverLocation.alignedPoint, orientation: orientationMode, type: editionMode, value: 0)
                    .draw(context:context, zoom: currentZoom+zoom, style: symbolsStyle, cursor: hoverLocation)
            }
            for c in components {
                c.draw(context: context, zoom: currentZoom + zoom, style: symbolsStyle, cursor: hoverLocation)
            }
        }
        .onTapGesture {
            let newComponent = CircuitComponent(editionMode, position: hoverLocation.alignedPoint, orientation: orientationMode, type: editionMode, value: 0)
            components.append(newComponent)
        }
        .onContinuousHover(coordinateSpace: .local) { phase in
            switch phase {
            case .active(let location):
                let y  = -geometry.size.height/(2*(zoom+currentZoom)) + location.y/(zoom+currentZoom) - origin.y/(zoom+currentZoom)
                let x  = -geometry.size.width/(2*(zoom+currentZoom)) + location.x/(zoom+currentZoom) - origin.x/(zoom+currentZoom)
                hoverLocation = CGPoint(x: x, y: y)
                isHovering = true
                if editionMode != "" {
                    NSCursor.crosshair.push()
                }
            case .ended:
                isHovering = false
                NSCursor.arrow.push()
            }
        }
        .focusable()
        .onKeyPress(keys: [.downArrow, .upArrow, .rightArrow, .leftArrow, .escape, .space, "W", "R", "L", "C"], phases: [.repeat, .up]) { result in
            switch result.key {
            case .downArrow:
                origin.y -= 50/zoom
            case .upArrow:
                origin.y += 50/zoom
            case .rightArrow:
                origin.x -= 50/zoom
            case .leftArrow:
                origin.x += 50/zoom
            case .escape:
                editionMode = ""
            case .space:
                zoom = 1.5
                origin = CGPoint.zero
            default:
                print("Key not recognized (key)")
                switch result.characters {
                case "W":
                    print("Switch to W")
                    editionMode = "W"
                case "R":
                    print("Switch to R")
                    editionMode = "R"
                case "L":
                    print("Switch to L")
                    editionMode = "L"
                case "C":
                    print("Switch to C")
                    editionMode = "C"
                default:
                    print("Key not recognized (char)")
                }
            }
            return .handled
        }
        .drawingGroup()
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.canvasContentOffset.x = gesture.translation.width
                    self.canvasContentOffset.y = gesture.translation.height
                }
                .onEnded { gesture in
                    self.origin.x = self.canvasContentOffset.x + self.origin.x
                    self.origin.y = self.canvasContentOffset.y + self.origin.y
                    self.canvasContentOffset = CGPoint.zero
                }
        )
    }
}

extension CGPoint {
    var alignedPoint: CGPoint {
        let x = self.x-self.x.remainder(dividingBy: 10)
        let y = self.y-self.y.remainder(dividingBy: 10)
        return CGPoint(x: x, y: y)
    }
}

extension GraphicsContext {
    func drawGrid(gridStyle: Int, zoom: Double) {
        let dotSize: Double = 1.0
        self.stroke(
            Path() { path in
                if gridStyle == 1 {
                    for row in 0..<200 {
                        for column in 0..<200 {
                            let dotCenter = CGPoint(
                                x: -2000 + CGFloat(column) * CGFloat(20),
                                y: -2000 + CGFloat(row) * CGFloat(20)
                            )
                            path.addEllipse(
                                in: CGRect(
                                    x: dotCenter.x - dotSize / 2 / zoom,
                                    y: dotCenter.y - dotSize / 2 / zoom,
                                    width: dotSize / zoom,
                                    height: dotSize / zoom
                                )
                            )
                        }
                    }
                } else if gridStyle == 2 {
                    if zoom >= 1.5 {
                        for column in 0..<200 {
                            path.move(to: CGPoint(x: -1990 + CGFloat(column) * CGFloat(20), y: -2000))
                            path.addLine(to: CGPoint(x: -1990 + CGFloat(column) * CGFloat(20), y: 2000))
                        }
                        for row in 0..<200 {
                            path.move(to: CGPoint(x:-2000, y: -1990 + CGFloat(row) * CGFloat(20)))
                            path.addLine(to: CGPoint(x:2000, y: -1990 + CGFloat(row) * CGFloat(20)))
                        }
                    }
                    for column in 0..<200 {
                        path.move(to: CGPoint(x: -2000 + CGFloat(column) * CGFloat(20), y: -2000))
                        path.addLine(to: CGPoint(x: -2000 + CGFloat(column) * CGFloat(20), y: 2000))
                    }
                    for row in 0..<200 {
                        path.move(to: CGPoint(x:-2000, y: -2000 + CGFloat(row) * CGFloat(20)))
                        path.addLine(to: CGPoint(x:2000, y: -2000 + CGFloat(row) * CGFloat(20)))
                    }
                }
            },
            with: .color(gridStyle == 1 ? .gray.opacity(0.4) : .gray.opacity(0.1)),
            lineWidth: 0.8/zoom)
    }
}
