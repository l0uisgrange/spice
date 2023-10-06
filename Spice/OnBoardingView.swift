//
//  OnBoardingView.swift
//  Spice
//
//  Created by Louis Grange on 23.09.2023.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("symbolsStyle") private var symbolsStyle: SymbolStyle = .IEC
    @AppStorage("gridStyle") private var gridStyle = 1
    @AppStorage("onBoarded") private var onBoarded = false
    @Binding var isPresented: Bool
    let appBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    @State var text: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image("AppIconRep")
                .resizable()
                .frame(width: 60, height: 60)
            Text("ONBOARDING_TITLE")
                .font(.title2)
                .fontWeight(.semibold)
            Text("ONBOARDING_MESSAGE")
            Form {
                Picker("COMPONENTS_APPEARANCE", selection: $symbolsStyle) {
                    Text("ANSI")
                        .tag("ANSI")
                    Text("IEEE")
                        .tag("IEEE")
                    Text("IEC")
                        .tag("IEC")
                }
                Picker("GRID_APPEARANCE", selection: $gridStyle) {
                    Text("NONE")
                        .tag(0)
                    Text("DOTS")
                        .tag(1)
                    Text("GRID")
                        .tag(2)
                }
            }.background(.windowBackground)
            .scrollContentBackground(.hidden)
            .formStyle(.grouped)
            .scrollDisabled(true)
            HStack {
                Link(destination: URL(string: "https://github.com/l0uisgrange/spice/wiki")!) {
                    Text("HELP_BEGIN")
                }.buttonStyle(.bordered)
                .controlSize(.extraLarge)
                Button {
                    onBoarded.toggle()
                    isPresented.toggle()
                } label: {
                    Text("ONBOARDING_BUTTON")
                }.buttonStyle(.borderedProminent)
                .controlSize(.extraLarge)
            }
            HStack {
                Text("VERSION \(appVersion) (\(appBuild))")
                    .font(.caption)
                    .foregroundStyle(.gray)
                if Int(appVersion.components(separatedBy: ".").first ?? "0") == 0 {
                    Text("alpha")
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 7)
                        .overlay(
                            Capsule()
                                .stroke(.orange, lineWidth: 0.9)
                        )
                }
            }
        }.frame(width: 400)
        .padding(40)
        .background(.windowBackground)
    }
}
