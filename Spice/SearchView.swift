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
    @AppStorage("symbolsStyle") private var symbolsStyle = 0
    @State var typeSelected: CircuitComponent.ID?
    @State var components: [CircuitComponent] = [
        CircuitComponent("WIRE", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "W", value: 0),
        CircuitComponent("RESISTOR", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "R", value: 0),
        CircuitComponent("INDUCTOR", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "L", value: 0),
        CircuitComponent("CAPACITOR", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "C", value: 0)
    ]
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            VStack {
                TextField("SEARCH_COMPONENT", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .controlSize(.extraLarge)
                    .tint(.accentColor)
                    .padding([.horizontal, .top], 20)
                Form {
                    Table(components, selection: $typeSelected) {
                        TableColumn("NAME") { el in
                            Text(LocalizedStringKey(el.name))
                        }
                        TableColumn("TYPE", value: \.type)
                    }.frame(height: 300)
                    .listStyle(.plain)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }.formStyle(GroupedFormStyle())
                .scrollContentBackground(.hidden)
            }
            Divider()
            HStack {
                Link(destination: URL(string: "https://github.com/l0uisgrange/spice/wiki")!) {
                    Label("NEED_HELP?", systemImage: "questionmark")
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
        .searchable(text: $searchText, prompt: "")
    }
}
