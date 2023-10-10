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
    @AppStorage("symbolsStyle") private var symbolsStyle: SymbolStyle = .IEC
    @State var typeSelected: ComponentType.ID?
    @Binding var editionMode: String
    enum FocusField: Hashable {
        case field
    }
    let components = [
        ComponentType("RESISTOR", type: "R"),
        ComponentType("INDUCTOR", type: "L"),
        ComponentType("CAPACITOR", type: "C"),
        ComponentType("DIODE", type: "D"),
        ComponentType("VSOURCE", type: "V"),
        ComponentType("ISOURCE", type: "I"),
        ComponentType("FUSE", type: "F"),
        ComponentType("ACVSOURCE", type: "A")
    ]
    @FocusState var isFocusOn: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 13) {
                Image("search")
                TextField("", text: $searchText, prompt: Text("SEARCH_COMPONENT"))
                    .focused($isFocusOn)
                    .textFieldStyle(.plain)
                    .font(.title2)
                    .controlSize(.extraLarge)
                    .padding(.top, 2)
                    .onSubmit {
                        editionMode = filteredComponents.first?.type ?? ""
                        isPresented.toggle()
                    }
                    .onAppear {
                        Task {
                            try? await Task.sleep(nanoseconds: 200_000_000)
                            isFocusOn = true
                        }
                    }
            }.padding(15)
            Divider().padding(.bottom, 6)
            if filteredComponents.count == 0 {
                HStack {
                    Text("NO_RESULT")
                    Spacer()
                }.padding(.horizontal, 15)
                .padding(.vertical, 10)
            }
            ForEach(filteredComponents) { c in
                Button {
                    editionMode = c.type
                } label: {
                    HStack(alignment: .center, spacing: 15) {
                        Canvas { context, size in
                            let comp = Component("", position: .zero, orientation: .trailing, type: c.type, value: 0.0)
                            context.translateBy(x: 21, y: 15)
                            context.scaleBy(x: 0.7, y: 0.7)
                            comp.draw(context: context, zoom: 0.7, style: symbolsStyle, cursor: .zero, color: .primary)
                        }.frame(width: 42, height: 30)
                        Text(c.name)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                    }.padding(.horizontal, 9)
                    .padding(.vertical, 0)
                }.buttonStyle(SearchViewItem())
                .padding(.horizontal, 6)
            }
        }.frame(width: 250)
        .padding([.bottom], 6)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 9))
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
