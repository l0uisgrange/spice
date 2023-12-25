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
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label
                .padding(3)
                .onHover(perform: { hovering in
                    self.hover = hovering
                })
                .background(hover ? Color("ButtonHover") : nil)
                .clipShape(RoundedRectangle(cornerRadius: 7))
            if hover && funcName != "" {
                VStack {
                    Spacer()
                    HStack {
                        Text(LocalizedStringKey(funcName))
                            .lineLimit(1)
                        if command != "" {
                            Text(command)
                                .opacity(0.5)
                        }
                    }.aspectRatio(contentMode: .fill)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color("AccentDark"))
                    .foregroundStyle(.white)
                    .overlay(RoundedRectangle(cornerRadius: 7).stroke())
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                }.frame(height: 90)
            }
        }.frame(width: 30)
    }
}