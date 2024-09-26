//
//  ContentView.swift
//  IntervalClock
//
//  Created by Brody on 9/24/24.
//
import SwiftUI

struct ContentView: View {
    @State var setsNum: Int
    @State var repsNum: TimeInterval
    @State var restNum: TimeInterval
    
    @State var Clock = ClockClass()
    @State private var mutatingPreset: Preset  // Use a mutable preset for the timer
    @State var restMode: Bool = false
    @State var completed: Bool = false
    
    let originalPreset: Preset  // Store the original preset
    
    init(setsNum: Int, repsNum: TimeInterval, restNum: TimeInterval) {
        self.setsNum = setsNum
        self.repsNum = repsNum
        self.restNum = restNum
        self.originalPreset = Preset(sets: setsNum, reps: repsNum, rest: restNum)  // Initialize once and keep constant
        self._mutatingPreset = State(initialValue: originalPreset)  // Initialize mutating preset with original preset
    }
    
    var body: some View {
        ZStack {
            restMode ? AppColors.rest.ignoresSafeArea() : Color.white.ignoresSafeArea()
            
            ZStack() {
                Image("timer-icon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .opacity(restMode ? 0.0 : 1.0)
                    .padding(.bottom, 450)
                
                if restMode {
                    RestView()
                        .padding(.bottom, 450)
                }
                
                Text("Sets Remaining: \(setsNum)")
                    .font(.custom(AppFonts.ValeraRound, size: 20))
                    .padding(.bottom, 200)
                
                Text("Completed")
                    .font(.custom(AppFonts.ValeraRound, size: 50))
                    .padding(.top, 200)
                    .bold()
                    .foregroundColor(.red)
                Text(Clock.timeIntervalToString(from: repsNum))
                    .font(.custom(AppFonts.ValeraRound, size: 80))
                    .padding(.top, 40)

                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .stroke(Color.black, lineWidth: 4)
                        .frame(width: 200, height: 100)

                    Text("Run Timer")
                        .font(.custom(AppFonts.ValeraRound, size: 30))
                }
                .padding(.top, 400)
                .onTapGesture {
                    print("Timer is starting")
                    
                    // Reset mutatingPreset to originalPreset before starting the timer
                    mutatingPreset = originalPreset
                    
                    print("mutatingPreset: \(mutatingPreset)")
                    completed = false
                    Clock.updateRestMode = { restBool in
                        self.restMode = restBool
                    }
                    
                    Clock.updateSetsNum = { remainingSets in
                        self.setsNum = remainingSets  // Update UI with remaining sets
                    }
                    
                    Clock.startTimer(set: mutatingPreset.sets, for: mutatingPreset.reps, rest: mutatingPreset.rest, onTick: { timeString in
                        // Update the UI with the remaining time
                        repsNum = Clock.timeStringToInterval(timeString)! + 1
                        
                    }, onFinish: {
                        print("Reps complete!")
                        completed = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                            repsNum = 0
                        }
                        
                    })
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView(setsNum: 2, repsNum: 3, restNum: 2)
}
