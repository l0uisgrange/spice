//
//  OnBoardingView.swift
//  Spice
//
//  Created by Louis Grange on 23.09.2023.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("symbolsStyle") private var symbolsStyle = 0
    @Binding var isPresented: Bool
    var body: some View {
        VStack(alignment: .center) {
            Text("ONBOARDING_TITLE")
                .font(.largeTitle)
                .fontWeight(.semibold)
             Text("ONBOARDING_MESSAGE")
                .font(.title3)
            HStack(spacing: 20) {
                AppearanceView(styleId: 1, styleName: "EU_STYLE")
                AppearanceView(styleId: 2, styleName: "US_STYLE")
            }.padding(.top, 20)
            Button {
                isPresented.toggle()
            } label: {
                Text("ONBOARDING_BUTTON")
            }.buttonStyle(.borderedProminent)
            #if os(macOS)
                .controlSize(.extraLarge)
            #endif
            .padding(.top, 30)
        }.padding(40)
    }
}

struct AppearanceView: View {
    @AppStorage("symbolsStyle") private var symbolsStyle = 0
    var styleId: Int
    var styleName: String
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Canvas { context, size in
                    context.translateBy(x: 75, y: 50)
                    if styleId == 1 {
                        context.stroke(
                            Path() { path in
                                path.move(to: CGPoint(x: -75, y: 0))
                                path.addLine(to: CGPoint(x: -30, y: 0))
                                path.addLine(to: CGPoint(x: -25, y: 13))
                                path.addLine(to: CGPoint(x: -15, y: -13))
                                path.addLine(to: CGPoint(x: -5, y: 13))
                                path.addLine(to: CGPoint(x: 5, y: -13))
                                path.addLine(to: CGPoint(x: 15, y: 13))
                                path.addLine(to: CGPoint(x: 25, y: -13))
                                path.addLine(to: CGPoint(x: 30, y: 0))
                                path.addLine(to: CGPoint(x: 75, y: 0))
                            },
                            with: .color(.primary),
                            lineWidth: 1.35)
                    } else {
                        context.stroke(
                            Path() { path in
                                path.move(to: CGPoint(x: -75, y: 0))
                                path.addLine(to: CGPoint(x: -30, y: 0))
                                path.addLine(to: CGPoint(x: -30, y: 13))
                                path.addLine(to: CGPoint(x: 30, y: 13))
                                path.addLine(to: CGPoint(x: 30, y: -13))
                                path.addLine(to: CGPoint(x: -30, y: -13))
                                path.addLine(to: CGPoint(x: -30, y: 0))
                                path.move(to: CGPoint(x: 30, y: 0))
                                path.addLine(to: CGPoint(x: 75, y: 0))
                            },
                            with: .color(.primary),
                            lineWidth: 1.35)
                    }
                }.frame(width: 150, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(symbolsStyle == styleId ? .blue : .secondary.opacity(0.5), lineWidth: symbolsStyle == styleId ? 2 : 0.5)
                )
            }.padding(.top, 5)
        }.onTapGesture {
            symbolsStyle = styleId
        }
    }
}
