//
//  IntervalClockApp.swift
//  IntervalClock
//
//  Created by Brody on 9/24/24.
//

import SwiftUI

@main
struct IntervalClockApp: App {
    var body: some Scene {
        WindowGroup {
            @ObservedObject var preset: PresetListClass = PresetListClass()
            PresetView(PresetList: preset)
        }
    }
}
