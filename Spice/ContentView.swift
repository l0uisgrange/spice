//
//  ContentView.swift
//  Spice
//
//  Created by Louis Grange on 20.09.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Binding var file: [URL]
    @Binding var zoom: Double
    @State private var origin: CGPoint = CGPoint.zero
    let dotSize: CGFloat = 1.0
    @Binding var editionMode: EditionMode
    @Binding var components: [CircuitComponent]
    var body: some View {
        GeometryReader { geometry in
            CanvasView(geometry: geometry, origin: $origin, zoom: $zoom, components: $components)
        }
        .edgesIgnoringSafeArea(.all)
        .toolbar {
            ToolbarItemGroup {
                Button {
                    
                } label: {
                    Label("CANCEL", systemImage: "arrow.uturn.backward")
                }
                .help("CANCEL")
                Button {
                    
                } label: {
                    Label("UNDO", systemImage: "arrow.uturn.forward")
                }.help("UNDO")
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
                }.help("ERASE")
                Button {
                    
                } label: {
                    Label("WIRE", systemImage: "line.diagonal")
                }.help("WIRE")
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
                    if(zoom >= 1) {
                        withAnimation(.bouncy) {
                            zoom -= 0.5
                        }
                    }
                } label: {
                    Label("ZOOM_OUT", systemImage: "minus.magnifyingglass")
                }.help("ZOOM_OUT")
                Button {
                    if(zoom <= 2.5) {
                        withAnimation(.bouncy) {
                            zoom += 0.5
                        }
                    }
                } label: {
                    Label("ZOOM_IN", systemImage: "plus.magnifyingglass")
                }.help("ZOOM_IN")
                Spacer()
                Button {
                    withAnimation(.bouncy) {
                        origin = CGPoint.zero
                        zoom = 1.5
                    }
                } label: {
                    Label("FOCUS", systemImage: "viewfinder")
                }.help("FOCUS")
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
                }.help("RUN")
            }
        }
    }
}

