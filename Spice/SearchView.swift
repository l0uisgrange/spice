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
    @State var typeSelected: ComponentType.ID?
    @Binding var editionMode: String
    let components = [
        ComponentType("RESISTOR", type: "R"),
        ComponentType("INDUCTOR", type: "L"),
        ComponentType("CAPACITOR", type: "C"),
        ComponentType("DIODE", type: "D"),
        ComponentType("VSOURCE", type: "V"),
        ComponentType("ISOURCE", type: "I"),
        ComponentType("TRANSISTOR", type: "T")
    ]
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
                    .padding(.bottom, -3)
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
    
    var filteredComponents: [ComponentType] {
        components.sorted { $0.name < $1.name }.filter {
            if searchText.count > 0 {
                $0.name.lowercased().contains(searchText.lowercased())
            } else { true }
        }
    }
}

struct ComponentType: Identifiable {
    init(_ name: String, type: String) {
        self.name = NSLocalizedString(name, comment: "")
        self.type = type
    }
    var id: UUID = UUID()
    var name: String = ""
    var type: String = ""
}
