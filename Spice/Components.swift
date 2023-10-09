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
            .background(hover ? Color.accentColor : Color.accentColor.opacity(0))
            .foregroundStyle(.white)
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
            Divider().frame(width: 25).padding(.vertical, 2)
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
        .foregroundStyle(Color("CanvasBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 9))
    }
}
