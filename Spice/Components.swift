//
//  Components.swift
//  Spice
//
//  Created by Louis Grange on 08.10.2023.
//

import SwiftUI

struct SearchViewItem: ButtonStyle {
    @State var hover: Bool = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(hover ? Color.gray.opacity(0.25) : Color.accentColor.opacity(0))
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .onHover { phase in
                switch phase {
                case true:
                    hover = true
                default:
                    hover = false
                }
            }
    }
}

struct SideBarView: View {
    @Binding var editionMode: String
    @Binding var addComponent: Bool
    var body: some View {
        VStack {
            VStack {
                Button {
                    editionMode = ""
                } label: {
                    Image("cursor")
                }.padding(3)
                .background(editionMode == "" ? .white.opacity(0.2) : .white.opacity(0))
                .buttonStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 7))
                Button {
                    editionMode = "."
                } label: {
                    Image("cursor.select")
                }.padding(3)
                .background(editionMode == "." ? .white.opacity(0.2) : .white.opacity(0))
                .buttonStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 7))
                Button {
                    editionMode = "W"
                } label: {
                    Image("line")
                }.padding(3)
                .background(editionMode == "W" ? .white.opacity(0.2) : .white.opacity(0))
                .buttonStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 7))
            }.padding(6)
            .background(Color("AccentDark"))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 9))
            VStack {
                Button {
                    Task {
                        withAnimation(.snappy(duration: 0.2)) {
                            addComponent.toggle()
                        }
                    }
                } label: {
                    Image("plus")
                    .rotationEffect(addComponent ? Angle(degrees: 45) : .zero)
                }.padding(3)
                .buttonStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 7))
            }.padding(6)
            .background(Color("AccentDark"))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 9))
        }
    }
}

struct MenuButton: ButtonStyle {
    @State var hover: Bool = false
    var funcName: String = ""
    var command: String = ""
    @State var size: CGSize = CGSizeZero
    var alignment: Alignment = .bottom
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label
                .padding(4)
                .onHover(perform: { hovering in
                    self.hover = hovering
                })
                .background(hover ? Color("ButtonHover") : nil)
                .clipShape(RoundedRectangle(cornerRadius: 7))
            if hover && funcName != "" {
                HStack {
                    HStack {
                        Text(LocalizedStringKey(funcName))
                            .lineLimit(1)
                        if command != "" {
                            Text(command)
                                .opacity(0.5)
                        }
                    }.aspectRatio(contentMode: .fill)
                    .saveSize(in: $size)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color("AccentDark"))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                }.offset(x: alignment == .trailing ? size.width/2.0+45.0 :
                            alignment == .bottomTrailing ? -size.width/2.0+6.0 : 0.0,
                         y: alignment == .trailing ? 2 : 50.0)
                .zIndex(100.0)
            }
        }.frame(width: 30, height: 30, alignment: .center)
    }
}


struct SizeCalculator: ViewModifier {
    @Binding var size: CGSize
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            size = proxy.size
                        }
                }
            )
    }
}

extension View {
    func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
    }
}

struct Release: Decodable {
    let tag_name: String
}

struct CanvasConfig {
    var zoom: Double
    var temporizedZoom: Double
    var position: CGPoint
    var running: Bool
    
    init() {
        self.zoom = 1.5
        self.temporizedZoom = 0.0
        self.position = CGPoint.zero
        self.running = false
    }
    
    var magnifying: Double {
        return zoom + temporizedZoom
    }
}
