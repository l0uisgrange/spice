//
//  Tips.swift
//  Spice
//
//  Created by Louis Grange on 30.09.2023.
//

import SwiftUI
import TipKit

struct RunSimulationTip: Tip {
    var image: Image? {
        Image(systemName: "flag.checkered.2.crossed")
    }
    var title: Text {
        Text("TIP_SIMULATION_TITLE")
    }
    var message: Text? {
        Text("TIP_SIMULATION_DESCRIPTION")
    }
}
