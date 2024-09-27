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
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 30)
                Text("Interval Timer: ")
                    .font(.custom(AppFonts.ValeraRound, size: 50))
                    .bold()
                    .foregroundColor(.black)
                Spacer().frame(height: 120) // Adjust this to control the button's position
                
                NavigationLink(destination: PresetView(PresetList: PresetList)) {
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
                .padding(.bottom, -10) // Fine-tune the bottom padding if needed
                
                Spacer().frame(height: 30) // Space between the button and the scroll view
                
                if testShow {
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
                                    ).padding(.bottom, -5)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 420)
                }
                
                Spacer()
            }
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

