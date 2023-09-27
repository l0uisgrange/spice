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
    @AppStorage("symbolsStyle") private var symbolsStyle = 0
    @AppStorage("gridStyle") private var gridStyle = 1
    @Binding var origin: CGPoint
    @Binding var zoom: Double
    @State private var currentZoom: Double = 0.0
    @State private var cursorPosition: CGPoint = CGPoint.zero
    let dotSize: Double = 1.0
    @Binding var components: [CircuitComponent]
    @State private var hoverLocation: CGPoint = .zero
    @State private var isHovering = false
    @Binding var editionMode: EditionMode
    var body: some View {
        Canvas { context, size in
            let windowWidth = geometry.frame(in: .global).width
            let windowHeight = geometry.frame(in: .global).height
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color("CanvasBackground")))
            context.translateBy(x: windowWidth/2.0 + origin.x + canvasContentOffset.x, y: windowHeight / 2 + origin.y + canvasContentOffset.y)
            context.scaleBy(x: zoom + currentZoom, y: zoom + currentZoom)
            context.stroke(
                Path() { path in
                    if gridStyle == 1 {
                        for row in 0..<100 {
                            for column in 0..<100 {
                                let dotCenter = CGPoint(
                                    x: -1000 + CGFloat(column) * CGFloat(20),
                                    y: -1000 + CGFloat(row) * CGFloat(20)
                                )
                                path.addEllipse(
                                    in: CGRect(
                                        x: dotCenter.x - dotSize / 2 / (zoom+currentZoom),
                                        y: dotCenter.y - dotSize / 2 / (zoom+currentZoom),
                                        width: dotSize / (zoom+currentZoom),
                                        height: dotSize / (zoom+currentZoom)
                                    )
                                )
                            }
                        }
                    } else if gridStyle == 2 {
                        for column in 0..<100 {
                            path.move(to: CGPoint(x: -1000 + CGFloat(column) * CGFloat(20), y: -1000))
                            path.addLine(to: CGPoint(x: -1000 + CGFloat(column) * CGFloat(20), y: 1000))
                        }
                        for row in 0..<100 {
                            path.move(to: CGPoint(x:-1000, y: -1000 + CGFloat(row) * CGFloat(20)))
                            path.addLine(to: CGPoint(x:1000, y: -1000 + CGFloat(row) * CGFloat(20)))
                        }
                    }
                },
                with: .color(gridStyle == 1 ? .gray : .gray.opacity(0.3)),
                lineWidth: 1/(zoom+currentZoom))
            context.stroke(
                Path() { path in
                    path.move(to: CGPoint(x: -1000, y: 0))
                    path.addLine(to: CGPoint(x: 1000, y: 0))
                    path.move(to: CGPoint(x: 0, y: -1000))
                    path.addLine(to: CGPoint(x: 0, y: 1000))
                },
                with: .color(.gray.opacity(0.2)),
                lineWidth: 1/(zoom+currentZoom))
            if editionMode == .wire {
                context.stroke(
                    Path() { path in
                        path.move(to: CGPoint(x: -1000, y: hoverLocation.y))
                        path.addLine(to: CGPoint(x: 1000, y: hoverLocation.y))
                        path.move(to: CGPoint(x: hoverLocation.x, y: -1000))
                        path.addLine(to: CGPoint(x: hoverLocation.x, y: 1000))
                    },
                    with: .color(.primary),
                    lineWidth: 1/(zoom+currentZoom))
            }
            for c in components {
                c.draw(context: context, zoom: currentZoom + zoom, style: symbolsStyle, cursor: hoverLocation)
            }
        }
        .onContinuousHover(coordinateSpace: .local) { phase in
            switch phase {
            case .active(let location):
                let y  = -geometry.frame(in: .global).height/(2*(zoom+currentZoom)) + location.y/(zoom+currentZoom)
                let x  = -geometry.frame(in: .global).width/(2*(zoom+currentZoom)) + location.x/(zoom+currentZoom)
                hoverLocation = CGPoint(x: x, y: y)
                isHovering = true
            case .ended:
                isHovering = false
            }
        }
        .focusable()
        .onMoveCommand { direction in
            switch direction {
            case .down:
                origin.y -= 20
            case .up:
                origin.y += 20
            case .right:
                origin.x -= 20
            case .left:
                origin.x += 20
            default:
                origin.x = origin.x
            }
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
