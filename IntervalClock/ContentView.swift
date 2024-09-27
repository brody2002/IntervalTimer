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
    @State var isFinished: Bool = true
    @State var show1: Bool = false
    @State var show2: Bool = false
    @State var show3: Bool = false
    @State var showGo: Bool = false
    @State var showTimer: Bool = true
    
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
            restMode ? AppColors.rest.ignoresSafeArea() : AppColors.work.ignoresSafeArea()
            
            ZStack() {
                
                
                if showTimer{
                    Image("timer-icon")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .opacity(restMode ? 0.0 : 1.0)
                        .padding(.bottom, 450)
                }
                if show3{Text("3").font(.custom(AppFonts.ValeraRound, size: 70)).bold().padding(.bottom, 450)}
                if show2{Text("2").font(.custom(AppFonts.ValeraRound, size: 70)).bold().padding(.bottom, 450)}
                if show1{Text("1").font(.custom(AppFonts.ValeraRound, size: 70)).bold().padding(.bottom, 450)}
                if showGo{Text("GO!").font(.custom(AppFonts.ValeraRound, size: 70)).bold().padding(.bottom, 450)}
               
                
                if restMode {
                    RestView()
                        .padding(.bottom, 450)
                }
                
                Text("Sets Remaining: \(setsNum)")
                    .font(.custom(AppFonts.ValeraRound, size: 20))
                    .padding(.bottom, 200)
                
                if completed{
                    Text("Completed")
                        .font(.custom(AppFonts.ValeraRound, size: 50))
                        .padding(.top, 200)
                        .bold()
                        .foregroundColor(.red)
                }
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
                    setsNum = originalPreset.sets
                    isFinished = false
                    completed = false
                    // Start countdown sequence
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        showTimer = false
                        show3 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {  // Delay for 1 second after show3
                        show3 = false
                        show2 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {  // Delay for 1 second after show2
                        show2 = false
                        show1 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {  // Delay for 1 second after show1
                        show1 = false
                        showGo = true
                        
                        // Start the timer immediately when "GO!" is displayed
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
                            repsNum = Clock.timeStringToInterval(timeString)!
                        }, onFinish: {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                repsNum = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                print("Reps complete!")
                                completed = true
                                isFinished = true
                            }
                            
                        })
                    }
                    
                    // After "GO!" has been shown for 1 second, revert back to the timer icon
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        showGo = false
                        showTimer = true
                    }
                }.allowsHitTesting(isFinished)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ContentView(setsNum: 3, repsNum: 3, restNum: 1)
}
