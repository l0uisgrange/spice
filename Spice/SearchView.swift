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
        CircuitComponent("RESISTOR", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "R", value: 0),
        CircuitComponent("INDUCTOR", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "L", value: 0),
        CircuitComponent("CAPACITOR", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "C", value: 0),
        CircuitComponent("DIOD", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "D", value: 0),
        CircuitComponent("VSOURCE", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "V", value: 0),
        CircuitComponent("ISOURCE", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "I", value: 0),
        CircuitComponent("TRANSISTOR", start: CGPoint(x: -30, y: 0), end: CGPoint(x: 30, y: 0), type: "T", value: 0)
    ]
    @Binding var editionMode: String
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment: .center, spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                TextField("SEARCH_COMPONENT", text: $searchText)
                    .onSubmit {
                        editionMode = components.first(where: { $0.id == typeSelected })?.name ?? ""
                        isPresented.toggle()
                    }
                    .textFieldStyle(.plain)
                    .font(.title2)
                    .tint(.accentColor)
            }.padding(20)
            .font(.title2)
            Divider()
            Form {
                Table(filteredComponents, selection: $typeSelected) {
                    TableColumn("NAME") { el in
                        Text(el.name)
                    }
                    TableColumn("TYPE", value: \.type)
                }.frame(height: 300)
                .listStyle(.plain)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }.formStyle(GroupedFormStyle())
            .scrollContentBackground(.hidden)
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
                    editionMode = components.first(where: { $0.id == typeSelected })?.type ?? (searchText.count > 0 ? filteredComponents.first?.type ?? "" : "")
                    isPresented.toggle()
                } label: {
                    Text("ADD")
                }.buttonStyle(.borderedProminent)
                .controlSize(.extraLarge)
            }.padding(15)
        }.frame(width: 500)
        .background(.windowBackground)
    }
    
    var filteredComponents: [CircuitComponent] {
        components.sorted { $0.name < $1.name }.filter {
            if searchText.count > 0 {
                $0.name.lowercased().contains(searchText.lowercased())
            } else { true }
        }
    }
}
