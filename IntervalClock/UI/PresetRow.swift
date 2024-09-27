//
//  PresetRow.swift
//  IntervalClock
//
//  Created by Brody on 9/26/24.
//
import SwiftUI

struct PresetRow: View {
    var sets: Int
    var reps: TimeInterval
    var rest: TimeInterval
    var Clock = ClockClass()
    @State var showOptions: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .stroke(Color.black, lineWidth: 3)
                .frame(width: 350, height: 120)
            
            Text("Sets: \(sets)")
                .font(.custom(AppFonts.ValeraRound, size: 20))
                .offset(x: -125, y: -30)
                .foregroundColor(.black)
            
            Text("Reps: \(Clock.timeIntervalToString(from: reps))")
                .font(.custom(AppFonts.ValeraRound, size: 20))
                .offset(x: 85, y: 0)
                .foregroundColor(.black)
            
            Text("Rest: \(Clock.timeIntervalToString(from: rest))")
                .font(.custom(AppFonts.ValeraRound, size: 20))
                .offset(x: 88, y: 35)
                .foregroundColor(.black)
            
            Text("...")
                .font(.custom(AppFonts.ValeraRound, size: 40))
                .offset(x: -140)
                .foregroundColor(.black)
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        showOptions.toggle()
                    }
                }
            
            // Always keep the PresetOptionsView present and animate its position
            PresetOptionsView()
                .offset(y: showOptions ? 38 : 60) // Adjust these values as needed
                .offset(x: showOptions ?  -120 : -150)
                .animation(.spring(response: 0.3, dampingFraction: 0.9), value: showOptions)
                .opacity(showOptions ? 1.0 : 0)
        }
    }
}


#Preview {
    PresetRow(sets: 3, reps: 10.0, rest: 33.0)
}
