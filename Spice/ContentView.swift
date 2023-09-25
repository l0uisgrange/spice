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
    @Binding var fileSelector: Bool
    @Binding var editionMode: EditionMode
    @Binding var components: [CircuitComponent]
    var body: some View {
        VStack {
            if file == [] {
                NoContentView(fileSelector: $fileSelector)
                    .navigationSubtitle("NO_FILE_SELECTED")
            } else {
                GeometryReader { geometry in
                    CanvasView(geometry: geometry, origin: $origin, zoom: $zoom, components: $components)
                }
                .navigationSubtitle(file[0].lastPathComponent)
                .edgesIgnoringSafeArea(.all)
            }
        }.toolbar {
            ToolbarItemGroup {
                Button {
                    
                } label: {
                    Label("CANCEL", systemImage: "arrow.uturn.backward")
                }.disabled(file == [])
                .help("CANCEL")
                Button {
                    
                } label: {
                    Label("UNDO", systemImage: "arrow.uturn.forward")
                }.disabled(file == [])
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
                }.disabled(file == [])
                .help("ERASE")
                Button {
                    
                } label: {
                    Label("WIRE", systemImage: "line.diagonal")
                }.disabled(file == [])
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
                    if(zoom >= 1) {
                        withAnimation(.bouncy) {
                            zoom -= 0.5
                        }
                    }
                } label: {
                    Label("ZOOM_OUT", systemImage: "minus.magnifyingglass")
                }.disabled(file == [])
                .help("ZOOM_OUT")
                Button {
                    if(zoom <= 2.5) {
                        withAnimation(.bouncy) {
                            zoom += 0.5
                        }
                    }
                } label: {
                    Label("ZOOM_IN", systemImage: "plus.magnifyingglass")
                }.disabled(file == [])
                .help("ZOOM_IN")
                Spacer()
                Button {
                    withAnimation(.bouncy) {
                        origin = CGPoint.zero
                        zoom = 1.5
                    }
                } label: {
                    Label("FOCUS", systemImage: "viewfinder")
                }.disabled(file == [])
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
                }.disabled(file == [])
                .help("RUN")
            }
        }
    }
}

