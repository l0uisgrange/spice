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
    @AppStorage("symbolsStyle") private var symbolsStyle: SymbolStyle = .IEC
    @AppStorage("gridStyle") private var gridStyle = 1
    @Binding var origin: CGPoint
    @Binding var zoom: Double
    @State private var currentZoom: Double = 0.0
    @State private var cursorPosition: CGPoint = CGPoint.zero
    @Binding var components: [Component]
    @State var selectedComponents: [Component] = []
    @State var selectedWires: [Wire] = []
    @Binding var wires: [Wire]
    @State private var hoverLocation: CGPoint = .zero
    @State private var hoverRect: CGRect? = nil
    @State private var isHovering = false
    @GestureState private var magnifyBy = 1.0
    @Binding var editionMode: String
    @Binding var orientationMode: Direction
    @State var wireBegin: CGPoint? = nil
    @FocusState private var focused: Bool
    var body: some View {
        Canvas { context, size in
            let windowWidth = geometry.size.width
            let windowHeight = geometry.size.height
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color("CanvasBackground")))
            context.translateBy(x: windowWidth/2.0 + origin.x + canvasContentOffset.x, y: windowHeight / 2 + origin.y + canvasContentOffset.y)
            context.scaleBy(x: zoom + currentZoom, y: zoom + currentZoom)
            context.drawGrid(gridStyle: gridStyle, zoom: zoom + currentZoom)
            if editionMode != "" {
                Component(editionMode, position: hoverLocation.alignedPoint, orientation: orientationMode, type: editionMode, value: 0)
                    .draw(context:context, zoom: currentZoom+zoom, style: symbolsStyle, cursor: hoverLocation)
            }
            for c in components {
                c.draw(context: context, zoom: currentZoom + zoom, style: symbolsStyle, cursor: hoverLocation, selected: selectedComponents.contains { $0.id == c.id })
            }
            for w in wires {
                context.stroke(w.path, with: selectedWires.contains { $0.id == w.id } ? .color(Color("AccentColor")) : .color(Color("CircuitColor")), lineWidth: 1/(zoom+currentZoom))
                if selectedWires.contains(where: { $0.id == w.id }) {
                    context.stroke(w.path, with: .color(Color("AccentColor").opacity(0.1)), lineWidth: 5/(zoom+currentZoom))
                }
            }
            if hoverRect != nil {
                context.fill(Path(roundedRect: hoverRect!, cornerRadius: 0), with: .color(Color("CircuitColor").opacity(0.1)))
            }
            if wireBegin != nil {
                let wire = Wire(wireBegin ?? hoverLocation.alignedPoint, hoverLocation.alignedPoint)
                context.stroke(wire.path, with: .color(Color("CircuitColor").opacity(0.5)), lineWidth: 1/(zoom+currentZoom))
            }
        }.focusable()
        .onKeyPress { result in
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
                print("No more edition")
                editionMode = ""
            case "\u{7F}":
                print("Deleted")
                Task {
                    for c in selectedComponents {
                        components = components.filter { $0.id != c.id }
                    }
                }
            case .space:
                zoom = 1.5
                origin = CGPoint.zero
            default:
                print("Key not recognized \(result.key)" )
            }
            return .handled
        }
        .onTapGesture {
            switch editionMode {
            case "":
                selectedComponents = []
                selectedWires = []
                for c in components {
                    if c.path.boundingRect.contains(hoverLocation) {
                        selectedComponents.append(c)
                    }
                }
                for w in wires {
                    if w.path.boundingRect.contains(hoverLocation) {
                        selectedWires.append(w)
                    }
                }
            case "W":
                if wireBegin != nil {
                    let newWire = Wire(wireBegin!, hoverLocation.alignedPoint)
                    wires.append(newWire)
                    wireBegin = nil
                } else {
                    wireBegin = hoverLocation.alignedPoint
                }
            default:
                let newComponent = Component(editionMode, position: hoverLocation.alignedPoint, orientation: orientationMode, type: editionMode, value: 0)
                components.append(newComponent)
            }
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
        .drawingGroup()
        .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if editionMode != "." {
                            self.canvasContentOffset.x = gesture.translation.width
                            self.canvasContentOffset.y = gesture.translation.height
                        } else {
                            if hoverRect == nil {
                                hoverRect = CGRect(origin: hoverLocation, size: CGSizeZero)
                            } else {
                                hoverRect?.size.width = gesture.translation.width/zoom
                                hoverRect?.size.height = gesture.translation.height/zoom
                            }
                        }
                    }
                    .onEnded { gesture in
                        if editionMode != "." {
                            self.origin.x = self.canvasContentOffset.x + self.origin.x
                            self.origin.y = self.canvasContentOffset.y + self.origin.y
                            self.canvasContentOffset = CGPoint.zero
                        } else {
                            for c in components {
                                if c.path.boundingRect.intersects(hoverRect ?? CGRectNull) {
                                    selectedComponents.append(c)
                                }
                            }
                            for w in wires {
                                if w.path.boundingRect.intersects(hoverRect ?? CGRectNull) {
                                    selectedWires.append(w)
                                }
                            }
                            hoverRect = nil
                        }
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
