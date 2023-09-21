//
//  ContentView.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var file: String = "few"
    @Binding var lines: [Line]
    @State var zoom: CGFloat = 1.0
    var body: some View {
        if file == "" {
            ContentUnavailableView("No file selected", systemImage: "folder", description: Text("Please open a compatible file."))
                .toolbar {
                    ToolbarItem {
                        Button {
                            
                        } label: {
                            Label("Add Item", systemImage: "play.circle.fill")
                        }
                    }
                }
        } else {
            GeometryReader { geometry in
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
                        lineWidth: 1.5)
                }
            }
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        if(zoom > 0.5) {
                            zoom -= 0.5
                        }
                    } label: {
                        Label("Zoom out", systemImage: "minus.magnifyingglass")
                    }
                    Button {
                        if(zoom < 2) {
                            zoom += 0.5
                        }
                    } label: {
                        Label("Zoom in", systemImage: "plus.magnifyingglass")
                    }
                }
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem {
                    Button {
                        
                    } label: {
                        Label("Run", systemImage: "play.circle")
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
