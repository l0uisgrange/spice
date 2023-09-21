//
//  ContentView.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Binding var lines: [Line]
    @State var zoom: CGFloat = 1.0
    var body: some View {
        if lines.count == 0 {
            ContentUnavailableView("NO_FILE_SELECTED", systemImage: "folder", description: Text("NO_FILE_SELECTED_MESSAGE"))
                .navigationSubtitle("NO_FILE_SELECTED")
                .toolbar {
                    ToolbarItemGroup {
                        Button {
                        } label: {
                            Label("ZOOM_OUT", systemImage: "minus.magnifyingglass")
                        }.disabled(true)
                        Button {
                        } label: {
                            Label("ZOOM_IN", systemImage: "plus.magnifyingglass")
                        }.disabled(true)
                    }
                    ToolbarItem {
                        Button {
                            
                        } label: {
                            Label("RUN", systemImage: "play.circle")
                        }.disabled(true)
                    }
                }
        } else {
            GeometryReader { geometry in
                VStack {
                    Divider()
                    Canvas { context, size in
                        let windowWidth = geometry.frame(in: .global).width
                        let windowHeight = geometry.frame(in: .global).height
                        context.translateBy(x: windowWidth/2.0, y: windowHeight / 2)
                        context.scaleBy(x: zoom, y: zoom)
                        context.stroke(
                            Path() { path in
                                for line in lines {
                                    path.move(to: CGPoint(x: line.points.first?.x ?? 0, y: line.points.first?.y ?? 0))
                                    for point in line.points {
                                        path.addLine(to: CGPoint(x: point.x, y: point.y))
                                    }
                                }
                            },
                            with: .color(.black),
                            lineWidth: 1.35*zoom)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        if(zoom > 0.5) {
                            zoom -= 0.5
                        }
                    } label: {
                        Label("ZOOM_OUT", systemImage: "minus.magnifyingglass")
                    }
                    Button {
                        if(zoom < 2) {
                            zoom += 0.5
                        }
                    } label: {
                        Label("ZOOM_IN", systemImage: "plus.magnifyingglass")
                    }
                }
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem {
                    Button {
                        
                    } label: {
                        Label("RUN", systemImage: "play.circle")
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
