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
    let dotSize: CGFloat = 1.0
    var body: some View {
        VStack {
            if lines.count == 0 {
                ContentUnavailableView("NO_FILE_SELECTED", systemImage: "folder", description: Text("NO_FILE_SELECTED_MESSAGE"))
                    .navigationSubtitle("NO_FILE_SELECTED")
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
                                with: .color(.black),
                                lineWidth: 1.35/zoom
                            )
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }.toolbar {
            ToolbarItemGroup {
                Button {
                    
                } label: {
                    Label("RESISTOR", image: "resistor")
                }
            }
            ToolbarItemGroup {
                Button {
                    
                } label: {
                    Label("ERASE", systemImage: "eraser")
                }.disabled(lines.count == 0)
                Menu {
                    Button {
                        
                    } label: {
                        Image(systemName: "house")
                        Text("WIRE")
                    }
                    Divider()
                    Button {
                        
                    } label: {
                        Image(systemName: "house")
                        Text("SOURCE")
                    }
                    Button {
                        
                    } label: {
                        Image("resistor")
                        Text("RESISTOR")
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "house")
                        Text("INDUCTOR")
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "house")
                        Text("CAPACITOR")
                    }
                    Divider()
                } label: {
                    Label("ADD", systemImage: "plus")
                }.disabled(lines.count == 0)
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
                        zoom -= 0.5
                    }
                } label: {
                    Label("ZOOM_OUT", systemImage: "minus.magnifyingglass")
                }.disabled(lines.count == 0)
                Button {
                    if(zoom < 3) {
                        zoom += 0.5
                    }
                } label: {
                    Label("ZOOM_IN", systemImage: "plus.magnifyingglass")
                }.disabled(lines.count == 0)
                Spacer()
                Button {
                    
                } label: {
                    Label("FOCUS", systemImage: "target")
                }.disabled(lines.count == 0)
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
            }
        }
    }
}
