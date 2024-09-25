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
    @State var placeholder: Int = 3
    @State var restMode: Bool = true
    

    
    
    var body: some View {
        ZStack{
            restMode ? AppColors.rest.ignoresSafeArea() : Color.white.ignoresSafeArea()
            ZStack {
                
                Image("timer-icon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .padding(.bottom, 500)
                    .opacity(restMode ? 0.0 : 1.0)
                
                RestView()
                    .padding(.bottom, 500)
                    .opacity(restMode ? 1.0 : 0.0)
                    
                
                
                
                Text("Sets Remaining: \(placeholder)")
                    .font(.custom(AppFonts.ValeraRound, size: 20))
                    .padding(.bottom, 180)
                    .padding(.trailing, 140)

                
                
                Text(timeRemaining)
                    .font(.custom(AppFonts.ValeraRound, size: 130))
                    
                
                
                ZStack{
                    Text(mainLabel)
                        .font(.custom(AppFonts.ValeraRound, size: 30))
                        
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .stroke(Color.black, lineWidth: 4)  // Outline with blue color and 2-point thickness
                                .frame(width: 200, height: 100)
                                
                }
                .padding(.top, 400)
                
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
}

#Preview {
    ContentView()
}
