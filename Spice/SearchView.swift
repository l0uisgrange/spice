//
//  SearchView.swift
//  Spice
//
//  Created by Louis Grange on 01.10.2023.
//

import SwiftUI

struct SearchView: View {
    @Binding var isPresented: Bool
    @State var searchText: String = ""
    @State var typeSelected: String = ""
    @State var components: [CircuitComponent] = [
        CircuitComponent("", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "W", value: 0),
        CircuitComponent("", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "R", value: 0),
        CircuitComponent("", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "L", value: 0),
        CircuitComponent("", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "C", value: 0)
    ]
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100, maximum: 300)),
        GridItem(.adaptive(minimum: 100, maximum: 300)),
        GridItem(.adaptive(minimum: 100, maximum: 300))
    ]
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            VStack {
                TextField("SEARCH_COMPONENT", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .controlSize(.extraLarge)
                    .tint(.accentColor)
                    .padding(.bottom, 20)
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(components) { c in
                        ZStack(alignment: .bottomTrailing) {
                            Canvas { context, size  in
                                context.translateBy(x: size.width/2.0, y: size.height/2.0)
                                c.draw(context: context, cursor: CGPoint.zero)
                            }.frame(height: 70)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(typeSelected != c.type ? .gray.opacity(0.3) : .accentColor, lineWidth: typeSelected != c.type ? 0.7 : 1.5)
                                )
                                .onHover { hover in
                                    if hover {
                                        NSCursor.pointingHand.push()
                                    } else {
                                        NSCursor.arrow.push()
                                    }
                                }
                                .onTapGesture {
                                    typeSelected = c.type
                                }
                            VStack {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "info.circle")
                                        .foregroundStyle(.accent)
                                }.buttonStyle(.plain)
                            }.padding(15)
                        }
                    }
                }.frame(height: 300, alignment: .top)
                /*ContentUnavailableView("NO_RESULT", systemImage: "magnifyingglass", description: Text("NO_RESULT_DESCRIPTION"))
                    .padding(.vertical, 30)*/
            }.padding(20)
            Divider()
            HStack {
                Link(destination: URL(string: "https://github.com/l0uisgrange/spice/wiki")!) {
                    Text("NEED_HELP?")
                        .foregroundStyle(.accent)
                }.buttonStyle(.link)
                Spacer()
                Button {
                    isPresented.toggle()
                } label: {
                    Text("CANCEL")
                }.buttonStyle(.bordered)
                .controlSize(.extraLarge)
                Button {
                    isPresented.toggle()
                } label: {
                    Text("ADD")
                }.buttonStyle(.borderedProminent)
                .controlSize(.extraLarge)
            }.padding(15)
        }.frame(width: 500)
        .background(.windowBackground)
    }
}
