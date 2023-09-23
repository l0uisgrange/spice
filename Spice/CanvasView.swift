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
    @Binding var origin: CGPoint
    @Binding var zoom: Double
    let dotSize: Double = 1.0
    var body: some View {
        Canvas { context, size in
            let windowWidth = geometry.frame(in: .global).width
            let windowHeight = geometry.frame(in: .global).height
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color("CanvasBackground")))
            context.translateBy(x: windowWidth/2.0 + origin.x + canvasContentOffset.x, y: windowHeight / 2 + origin.y + canvasContentOffset.y)
            context.scaleBy(x: zoom, y: zoom)
            context.stroke(
                Path() { path in
                    for row in 0..<100 {
                        for column in 0..<100 {
                            let dotCenter = CGPoint(
                                x: -1000 + CGFloat(column) * CGFloat(20),
                                y: -1000 + CGFloat(row) * CGFloat(20)
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
                },
                with: .color(.gray),
                lineWidth: 1/zoom)
            context.stroke(
                Path() { path in
                    path.move(to: CGPoint(x: -1000, y: 0))
                    path.addLine(to: CGPoint(x: 1000, y: 0))
                    path.move(to: CGPoint(x: 0, y: -1000))
                    path.addLine(to: CGPoint(x: 0, y: 1000))
                },
                with: .color(.gray.opacity(0.2)),
                lineWidth: 1/zoom)
            /*
                context.stroke(
                    Path() { path in
                        path.move(to: line.points.first ?? CGPoint.zero)
                        for point in line.points {
                            path.addLine(to: point)
                        }
                    },
                    with: .color(line.color),
                    lineWidth: 1.35/zoom
                )
            }
             */
        }.gesture(
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
