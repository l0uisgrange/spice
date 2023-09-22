//
//  ContentView.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var lines: [Line]
    @State var zoom: CGFloat = 1.0
    @State var searchText: String = ""
    @State private var canvasContentOffset: CGPoint = CGPoint.zero
    let dotSize: CGFloat = 1.0
    var body: some View {
        VStack {
            if lines.count == 0 {
                ContentUnavailableView("NO_FILE_SELECTED", systemImage: "folder", description: Text("NO_FILE_SELECTED_MESSAGE"))
                    .navigationSubtitle("NO_FILE_SELECTED")
            } else {
                GeometryReader { geometry in
                    Canvas { context, size in
                        let windowWidth = geometry.frame(in: .global).width
                        let windowHeight = geometry.frame(in: .global).height
                        context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color("CanvasBackground")))
                        context.translateBy(x: windowWidth/2.0 + canvasContentOffset.x, y: windowHeight / 2 + canvasContentOffset.y)
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
                                for line in lines {
                                    path.move(to: CGPoint(x: line.points.first?.x ?? 0, y: line.points.first?.y ?? 0))
                                    for point in line.points {
                                        path.addLine(to: CGPoint(x: point.x, y: point.y))
                                    }
                                }
                            },
                            with: .color(.primary),
                            lineWidth: 1.35/zoom
                        )
                    }.gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.canvasContentOffset.x = gesture.translation.width
                                self.canvasContentOffset.y = gesture.translation.height
                            }
                    )
                }
                .edgesIgnoringSafeArea(.all)
            }
        }.toolbar {
            ToolbarItemGroup {
                Button {
                    
                } label: {
                    Label("CANCEL", systemImage: "arrow.uturn.backward")
                }.disabled(lines.count == 0)
                .help("CANCEL")
                Button {
                    
                } label: {
                    Label("UNDO", systemImage: "arrow.uturn.forward")
                }.disabled(lines.count == 0)
                .help("UNDO")
            }
            ToolbarItem {
                HStack {
                    Spacer()
                    Divider().frame(height: 25)
                    Spacer()
                }
            }
            ToolbarItemGroup {
                Button {
                    
                } label: {
                    Label("ERASE", systemImage: "eraser")
                }.disabled(lines.count == 0)
                .help("ERASE")
                Button {
                    
                } label: {
                    Label("WIRE", systemImage: "line.diagonal")
                }.disabled(lines.count == 0)
                .help("WIRE")
            }
            ToolbarItem {
                HStack {
                    Spacer()
                    Divider().frame(height: 25)
                    Spacer()
                }
            }
            ToolbarItemGroup {
                Button {
                    if(zoom > 0.5) {
                        withAnimation(.bouncy) {
                            zoom -= 0.5
                        }
                    }
                } label: {
                    Label("ZOOM_OUT", systemImage: "minus.magnifyingglass")
                }.disabled(lines.count == 0)
                .help("ZOOM_OUT")
                Button {
                    if(zoom < 3) {
                        withAnimation(.bouncy) {
                            zoom += 0.5
                        }
                    }
                } label: {
                    Label("ZOOM_IN", systemImage: "plus.magnifyingglass")
                }.disabled(lines.count == 0)
                .help("ZOOM_IN")
                Spacer()
                Button {
                    withAnimation(.bouncy) {
                        canvasContentOffset = CGPoint.zero
                    }
                } label: {
                    Label("FOCUS", systemImage: "viewfinder")
                }.disabled(lines.count == 0)
                .help("FOCUS")
            }
            ToolbarItem {
                HStack {
                    Spacer()
                    Divider().frame(height: 25)
                    Spacer()
                }
            }
            ToolbarItem {
                Button {
                    
                } label: {
                    Label("RUN", systemImage: "play.circle")
                }.disabled(lines.count == 0)
                .help("RUN")
            }
        }
    }
}

