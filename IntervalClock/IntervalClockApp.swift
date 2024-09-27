//
//  IntervalClockApp.swift
//  IntervalClock
//
//  Created by Brody on 9/24/24.
//

import SwiftUI
import SwiftData



// Singleton or global variable for shared ModelContainer
let sharedModelContainer: ModelContainer = {
    do {
        return try ModelContainer(for: Preset.self)
    } catch {
        fatalError("Failed to initialize ModelContainer: \(error)")
    }
}()

@main
struct IntervalClockApp: App {
    @StateObject private var preset: PresetListClass
    
    init() {
        // Use the shared model context from the global `sharedModelContainer`
        let modelContext = sharedModelContainer.mainContext
        _preset = StateObject(wrappedValue: PresetListClass(context: modelContext))
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(PresetList: preset)
        }
    }
}
