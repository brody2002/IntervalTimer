//
//  Content.swift
//  IntervalClock
//
//  Created by Brody on 9/25/24.
//
import SwiftUI
import SwiftData

struct HomeView: View {
    
    @State var testShow: Bool = true
    @StateObject var PresetList: PresetListClass
    
    // Track which preset is being edited
    @State private var selectedPreset: Preset? = nil
    @State var showMakePreset: Bool = false
    @State var showClockView: Bool = false
    
    // Main navigation path
    @State private var path: [String] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(AppColors.work).ignoresSafeArea()
                VStack {
                    Text("Interval Timer:")
                        .font(.custom(AppFonts.ValeraRound, size: 55))
                        .bold()
                        .foregroundColor(.black)
                        .padding(.top, 100)
                    Spacer(minLength: 80)
                    
                    // Navigation to create a new preset
                    Button(action: {
                        path.append("MakePreset")
                    }) {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .stroke(Color.black, lineWidth: 6)
                                .frame(width: 350, height: 100)
                                .foregroundColor(.white)
                            
                            Text("Make new preset")
                                .font(.custom(AppFonts.ValeraRound, size: 35))
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
                                    // Navigation to ContentView for each preset
                                    Button(action: {
                                        path.append("ContentView-\(preset.id.uuidString)") // Unique identifier
                                    }) {
                                        PresetRow(
                                            preset: preset,
                                            PresetList: PresetList,
                                            sets: preset.sets,
                                            reps: preset.reps,
                                            rest: preset.rest,
                                            name: preset.name,
                                            navigateToEdit: .constant(false)
                                        )
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                    }
                                    .frame(width: 400)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 420)
                    }
                    
                    Spacer()
                }
            }
            // Define navigation destinations based on path
            .navigationDestination(for: String.self) { value in
                switch value {
                case "MakePreset":
                    return AnyView(PresetView(preset: Preset(sets: 0, reps: 0.0, rest: 0.0), PresetList: PresetList))
                    
                case let contentViewId where contentViewId.starts(with: "ContentView-"):
                    // Extract the substring after "ContentView-"
                    let presetIdString = contentViewId.replacingOccurrences(of: "ContentView-", with: "")
                    
                    print("Extracted presetId:", presetIdString)
                    
                    // Print all preset UUIDs for debugging
                    print("All preset UUIDs in PresetList:")
                    for preset in PresetList.mainList {
                        print(preset.id.uuidString)
                    }
                    
                    // Attempt to find the preset and print the result
                    if let preset = PresetList.mainList.first(where: { $0.id.uuidString == presetIdString }) {
                        print("Found matching preset:", preset)
                        return AnyView(ContentView(preset: preset, pressetList: PresetList, path: $path))
                    } else {
                        print("No matching preset found for ID:", presetIdString)
                    }
                    
                    // Return an EmptyView if no preset is found
                    return AnyView(EmptyView())
                    
                default:
                    print("No matching case for value:", value)
                    return AnyView(EmptyView())
                }
            }


        }
        .navigationBarBackButtonHidden(true)
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
