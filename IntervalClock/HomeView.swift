//
//  HomeView.swift
//  IntervalClock
//
//  Created by Brody on 9/25/24.
//

import SwiftUI
import SwiftData
struct HomeView: View {
    
    @State var testShow: Bool = false
    
    
    
    @StateObject var PresetList: PresetListClass
    
    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    NavigationLink(destination: PresetView(PresetList: PresetList)) {
                        Text("Make new preset")
                            .padding(.bottom, 450)
                            .bold()
                    }
                    
                    Text("Choose Preset")
                        .font(.headline)
                        .padding(.bottom, 550)
                    
                    Button(action: {
                        print(PresetList.mainList)
                        testShow = true
                    }) {
                        Text("Show Presets")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 300)
                    }
                    
                    if testShow {
                        VStack {
                            ScrollView {
                                ForEach(PresetList.mainList, id: \.self) { preset in
                                    NavigationLink(destination: ContentView(
                                        setsNum: preset.sets,
                                        repsNum: preset.reps,
                                        restNum: preset.rest)) { // Navigate to ContentView
                                            PresetRow(
                                                sets: preset.sets,
                                                reps: preset.reps,
                                                rest: preset.rest
                                            )
                                            .padding()
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding(.top, 400)
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    do {
        // Try to initialize a ModelContainer and get its context for preview
        let modelContainer = try ModelContainer(for: Preset.self)
        let context = sharedModelContainer.mainContext
        
        // Initialize PresetListClass with a valid context
        let presetList = PresetListClass(context: context)
        
        return HomeView(PresetList: presetList)
    } catch {
        fatalError("Failed to initialize ModelContext for preview: \(error)")
    }
}

