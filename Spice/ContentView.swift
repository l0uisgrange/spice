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
                    context.scaleBy(x: zoom, y: zoom)
                    context.translateBy(x: windowWidth / 2, y: windowHeight / 2)
                    context.stroke(
                        Path() { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: 200, y: -200))
                            path.addLine(to: CGPoint(x: -200, y: -200))
                            path.addLine(to: CGPoint(x: 200, y: 200))
                        },
                        with: .color(.blue),
                        lineWidth: 2)
                }
            }
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        if(zoom > 0.5) {
                            zoom -= 0.5
                        }
                    } label: {
                        Label("Add Item", systemImage: "minus.magnifyingglass")
                    }
                    Button {
                        if(zoom < 2) {
                            zoom += 0.5
                        }
                    } label: {
                        Label("Add Item", systemImage: "plus.magnifyingglass")
                    }
                }
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem {
                    Button {
                        
                    } label: {
                        Label("Add Item", systemImage: "play.circle")
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
