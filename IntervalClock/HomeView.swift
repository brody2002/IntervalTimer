//
//  HomeView.swift
//  IntervalClock
//
//  Created by Brody on 9/25/24.
//
import SwiftUI
import SwiftData

struct HomeView: View {
    
    @State var testShow: Bool = true
    @StateObject var PresetList: PresetListClass
    
    // Single Bool for navigation
    @State private var navigateToEdit: Bool = false
    
    // Track which preset is being edited
    @State private var selectedPreset: Preset? = nil
    @State var showMakePreset: Bool = false
    @State var showClockView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 30)
                Text("Interval Timer:")
                    .font(.custom(AppFonts.ValeraRound, size: 50))
                    .bold()
                    .foregroundColor(.black)
                Spacer().frame(height: 120)
                
                NavigationLink(destination: PresetView(preset: Preset(sets: 0, reps: 0.0, rest: 0.0), PresetList: PresetList)) {
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .stroke(Color.black, lineWidth: 3)
                            .frame(width: 350, height: 100)
                            .foregroundColor(.white)
                        
                        Text("Make new preset")
                            .font(.custom(AppFonts.ValeraRound, size: 30))
                            .bold()
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, -10)
                
                Spacer().frame(height: 30)
                
                if testShow {
                    ScrollView {
                        ForEach(PresetList.mainList, id: \.self) { preset in
                            VStack {
                                // Navigation to ContentView
                                NavigationLink(destination: ContentView(
                                    setsNum: preset.sets,
                                    repsNum: preset.reps,
                                    restNum: preset.rest),isActive: self.$showClockView) {
                                        PresetRow(
                                            preset: preset,
                                            PresetList: PresetList,
                                            sets: preset.sets,
                                            reps: preset.reps,
                                            rest: preset.rest,
                                            navigateToEdit: .constant(false)
                                        )
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                        
                                        
                                    }
                                    .frame(width: 360)

                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 420)
                }
                
                Spacer()
            }
        }
//        // NavigationLink for editing, using `navigateToEdit` and `selectedPreset`
//        .background(
//            NavigationLink(
//                destination: PresetView(preset: selectedPreset ?? Preset(sets: 0, reps: 0.0, rest: 0.0), PresetList: PresetList),
//                isActive: $navigateToEdit
//            ) {
//                EmptyView()
//            }
//            .hidden()
//        )
    }
}


#Preview {
    do {
        // Initialize a ModelContainer and context for preview
        let modelContainer = try ModelContainer(for: Preset.self)
        let context = sharedModelContainer.mainContext
        
        // Initialize PresetListClass with a valid context
        let presetList = PresetListClass(context: context)
        
        return HomeView(PresetList: presetList)
    } catch {
        fatalError("Failed to initialize ModelContext for preview: \(error)")
    }
}
