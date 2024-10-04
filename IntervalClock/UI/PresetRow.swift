//
//  PresetRow.swift
//  IntervalClock
//
//  Created by Brody on 9/26/24.
//
import SwiftUI

struct PresetRow: View {
    let preset: Preset
    let PresetList: PresetListClass
    var sets: Int
    var reps: TimeInterval
    var rest: TimeInterval
    var name: String
    @Binding var navigateToEdit: Bool
    var Clock = ClockClass()
    @State var showOptions: Bool = false
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .stroke(Color.black, lineWidth: 6)
                .frame(width: 350, height: 120)
            
            
            Text("Sets:  \(sets)")
                .font(.custom(AppFonts.ValeraRound, size: 20))
                .offset(x: 48, y: -33)
                .foregroundColor(.black)
            
            Text("Reps: \(Clock.timeIntervalToString(from: reps))")
                .font(.custom(AppFonts.ValeraRound, size: 20))
                .offset(x: 85, y: 0)
                .foregroundColor(.black)
            
            Text("Rest:  \(Clock.timeIntervalToString(from: rest))")
                .font(.custom(AppFonts.ValeraRound, size: 20))
                .offset(x: 85.5, y: 35)
                .foregroundColor(.black)
            
            Text("...")
                .font(.custom(AppFonts.ValeraRound, size: 40))
                .offset(x: -140)
                .foregroundColor(.black)
                .onTapGesture {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                        showOptions.toggle()
                    }
                }
                
            
            Text(preset.name.count > 10 ? "\(preset.name.prefix(10))..." : preset.name)
                .font(.custom(AppFonts.ValeraRound, size: 25))
                .frame(width: 200, alignment: .leading) // Set a fixed width and align to leading
                .padding(.trailing, 118)
                .padding(.bottom, 65)
                .foregroundColor(.black)
                .lineLimit(1) // Optional: restrict text to a single line
                .fixedSize(horizontal: true, vertical: false)
            
            // Always keep the PresetOptionsView present and animate its position
            PresetOptionsView(preset: preset, PresetList: PresetList, navigateToEdit: $navigateToEdit)
                .offset(y: showOptions ? 38 : 39) // Adjust these values as needed
                .offset(x: showOptions ?  -120 : -130)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showOptions)
                .opacity(showOptions ? 1.0 : 0)
        }
    }
}


#Preview {
    let context = sharedModelContainer.mainContext
    let presetListClass = PresetListClass(context: context)

    let preset: Preset = Preset(sets: 2, reps: 2.0, rest: 2.0)
    
    
    PresetRow(preset: preset, PresetList: presetListClass, sets: 3, reps: 10.0, rest: 33.0,name: preset.name, navigateToEdit: .constant(false))
}
