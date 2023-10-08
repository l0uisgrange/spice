//
//  Components.swift
//  Spice
//
//  Created by Louis Grange on 08.10.2023.
//

import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}
