//
//  ContentView.swift
//  IntervalClock
//
//  Created by Brody on 9/24/24.
//

import SwiftUI


struct ContentView: View {
    @State var Clock = ClockClass()
    @State var preset1: Preset?  = nil
    @State var timeRemaining: String = "00:10"
    @State var mainLabel: String = "Run Timer"
    

    
    
    var body: some View {
        
        ZStack {
            Image("timer-icon")
                .resizable()
                .frame(width: 100, height: 100)
                .imageScale(.large)
                .foregroundStyle(.tint)
                .padding(.bottom, 500)
            
            
            
            Text(timeRemaining)
                .font(.custom(AppFonts.AntipastoMed, size: 130))
                
            
            
            ZStack{
                Text(mainLabel)
                    .font(.custom(AppFonts.AntipastoMed, size: 30))
                    .padding(.top, 300)
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .stroke(Color.blue, lineWidth: 2)  // Outline with blue color and 2-point thickness
                            .frame(width: 200, height: 100)
                            .padding(.top,300)
            }
            
            .onTapGesture {
                print("timer is starting: \n")
                preset1 = Preset(sets: 1, reps: TimeInterval(10), rest: TimeInterval(0))
                
                Clock.startTimer(for: preset1!.reps, onTick: { timeString in
                    // Update the UI with the remaining time
                    timeRemaining = timeString
                }, onFinish: {
                    // Handle what happens when the timer finishes
                    print("Reps complete!")
                    timeRemaining = "00:00"  // Reset the display when finished
                })}
                
        }
        .padding()
        
    }
}

#Preview {
    ContentView()
}
