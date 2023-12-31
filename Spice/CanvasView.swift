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
    @Binding var cG: CanvasConfig
    @State private var cursorPosition: CGPoint = CGPoint.zero
    @Binding var components: [Component]
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
    @Binding var selectedComponents: [Component]
    var body: some View {
        Canvas { context, size in
            let windowWidth = geometry.size.width
            let windowHeight = geometry.size.height
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color("CanvasBackground")))
            context.translateBy(x: windowWidth/2.0 + cG.position.x + canvasContentOffset.x, y: windowHeight / 2 + cG.position.y + canvasContentOffset.y)
            context.scaleBy(x: cG.magnifying, y: cG.magnifying)
            context.drawGrid(gridStyle: gridStyle, zoom: cG.magnifying)
            if editionMode != "" && editionMode != "." {
                Component(editionMode, position: hoverLocation.alignedPoint, orientation: orientationMode, type: editionMode, value: 0)
                    .draw(context:context, zoom: cG.magnifying, style: symbolsStyle, cursor: hoverLocation)
            }
            for c in components {
                c.name = c.type
                c.draw(context: context, zoom: cG.magnifying, style: symbolsStyle, cursor: hoverLocation, selected: selectedComponents.contains { $0.id == c.id })
            }
            for w in wires {
                context.stroke(w.path, with: selectedWires.contains { $0.id == w.id } ? .color(Color("AccentColor")) : .color(Color("CircuitColor")), lineWidth: 1/cG.magnifying)
                if selectedWires.contains(where: { $0.id == w.id }) {
                    context.stroke(w.path, with: .color(Color("AccentColor").opacity(0.1)), lineWidth: 5/cG.magnifying)
                }
            }
            if hoverRect != nil {
                context.stroke(Path(roundedRect: hoverRect!, cornerRadius: 0), with: .color(Color("SelectionColor")), style: StrokeStyle(lineWidth: 1.2/cG.magnifying, dash: [4]))
            }
            if wireBegin != nil {
                let wire = Wire(wireBegin ?? hoverLocation.alignedPoint, hoverLocation.alignedPoint)
                context.stroke(wire.path, with: .color(Color("CircuitColor").opacity(0.5)), lineWidth: 1/cG.magnifying)
            }
        }.focusable()
        /*.onKeyPress { result in
            switch result.key {
            case .downArrow:
                cG.position.y -= 50/cG.magnifying
            case .upArrow:
                cG.position.y += 50/cG.magnifying
            case .rightArrow:
                cG.position.x -= 50/cG.magnifying
            case .leftArrow:
                cG.position.x += 50/cG.magnifying
            case .escape:
                print("No more edition")
                editionMode = ""
            case "r":
                switch orientationMode {
                case .bottom:
                    orientationMode = .trailing
                case .top:
                    orientationMode = .leading
                case .leading:
                    orientationMode = .bottom
                default:
                    orientationMode = .top
                }
            case "\u{7F}":
                print("Deleted")
                Task {
                    for c in selectedComponents {
                        components = components.filter { $0.id != c.id }
                    }
                    for w in selectedWires {
                        wires = wires.filter { $0.id != w.id }
                    }
                }
            case .space:
                cG.zoom = 1.5
                cG.position = CGPoint.zero
            default:
                print("Key not recognized \(result.key)" )
            }
            return .handled
        }*/
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
            case ".":
                print("Hey")
            default:
                let newComponent = Component(editionMode, position: hoverLocation.alignedPoint, orientation: orientationMode, type: editionMode, value: 0)
                components.append(newComponent)
            }
        }
        .onContinuousHover(coordinateSpace: .local) { phase in
            switch phase {
            case .active(let location):
                let y  = -geometry.size.height/(2*cG.magnifying) + location.y/cG.magnifying - cG.position.y/cG.magnifying
                let x  = -geometry.size.width/(2*cG.magnifying) + location.x/cG.magnifying - cG.position.x/cG.magnifying
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
                                selectedComponents.removeAll()
                                selectedWires.removeAll()
                                hoverRect = CGRect(origin: hoverLocation, size: CGSizeZero)
                            } else {
                                hoverRect?.size.width = gesture.translation.width/cG.magnifying
                                hoverRect?.size.height = gesture.translation.height/cG.magnifying
                            }
                        }
                    }
                    .onEnded { gesture in
                        if editionMode != "." {
                            if -2000 + geometry.size.width/2.0 < canvasContentOffset.x + cG.position.x && canvasContentOffset.x + cG.position.x < 2000 - geometry.size.width/2.0 && -2000 + geometry.size.height/2.0 < canvasContentOffset.y + cG.position.y && canvasContentOffset.y + cG.position.y < 2000 - geometry.size.height/2.0 {
                                cG.position.x += self.canvasContentOffset.x
                                cG.position.y += self.canvasContentOffset.y
                            }
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
        self.stroke(Path() { path in
            path.move(to: CGPoint(x: 0, y: -20))
            path.addLine(to: CGPoint(x: 0, y: 20))
            path.move(to: CGPoint(x: -20, y: 0))
            path.addLine(to: CGPoint(x: 20, y: 0))
        },
        with: .color(.gray.opacity(0.6)),
        lineWidth: 0.8/zoom)
    }
}
