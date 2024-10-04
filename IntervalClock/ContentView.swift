//
//  ContentView.swift
//  IntervalClock
//
//  Created by Brody on 9/24/24.
//
import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var setsNum: Int
    @State var repsNum: TimeInterval
    @State var restNum: TimeInterval
    var id: UUID
    
    
    
    let PresetList: PresetListClass
    
    @State var Clock = ClockClass()
    @State private var mutatingPreset: Preset  // Use a mutable preset for the timer
    @State var restMode: Bool = false
    @State var pauseMode: Bool = false
    @State var pushedResume: Bool = false
    @State var completed: Bool = false
    @State var isFinished: Bool = true
    @State var show1: Bool = false
    @State var show2: Bool = false
    @State var show3: Bool = false
    @State var showGo: Bool = false
    @State var showTimer: Bool = true
    @State var timeLeft: TimeInterval = 0.00
    @State var isHoldingRunTimer : Bool = false
    @State var isHoldingBack : Bool = false
    @State var allowedInteractPauseResume: Bool = true
    @Binding var path: [String]
    
    @State private var audioPlayer: AVAudioPlayer?

    // I think this makes the NavViews get put into a Stack system
    @Environment(\.presentationMode) var presentationMode
    
    @State var returnTuple: (TimeInterval? , Int?) = (0.0, 0)
    
    
    var originalPreset: Preset  // Store the original preset
    
    init(preset:Preset, pressetList: PresetListClass, path: Binding<[String]> ) {
        self._path = path
        self.setsNum = preset.sets
        self.repsNum = preset.reps
        self.restNum = preset.rest
        self.PresetList = pressetList
        self.id = preset.id
        self.originalPreset = Preset(sets: preset.sets, reps: preset.reps, rest: preset.rest)  // Initialize once and keep constant
        self._mutatingPreset = State(initialValue: originalPreset)  // Initialize mutating preset with original preset
    }
    
    func playAudio(_ inputString: String) {
        if let url = Bundle.main.url(forResource: inputString, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
                print("Audio Playing")
            } catch {
                print("Couldn't play Audio")
            }
        } else {
            print("Can't Find File")
        }
    }
    
    var body: some View { 
        
            ZStack {
                (restMode ? AppColors.rest : AppColors.work)
                                .ignoresSafeArea()
                                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: restMode)
                
                
    
                
                
                NavigationLink(destination: {EditPresetView(preset: Preset(sets: self.setsNum, reps: self.repsNum, rest: self.restNum, id:self.id ), PresetList: PresetList, path: $path)}, label: {
                    Text("Edit")
                        .font(.custom(AppFonts.ValeraRound, size: 20))
                        .foregroundColor(.black)
                        .background(Color.clear)
                        
                    
                        
                })
                .padding(.bottom, 700)
                .padding(.leading, 270)
                
                    
                
                
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .fill(Color.clear) // Use any color you'd like
                        .frame(width: 100, height: 40)
                        .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .stroke(Color.black, lineWidth: 6)
                        )

                    Text(restMode ? "Rest" : "Work")
                        .font(.custom(AppFonts.ValeraRound, size: 30))
                }.padding(.bottom, 700)
                
                
                
                Image(systemName: "pause.fill")
                    .resizable()
                    .frame(width: !pauseMode ? 60 : 0, height: !pauseMode ? 60: 0)
                    .foregroundColor(.black)
                    .padding(.top, 650)
                    .padding(.leading, 200)
                    .zIndex(20).onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 1.2)){
                            self.pauseMode = true
                        }
                        returnTuple = Clock.pauseTimer()
                        print("returntuple: \(returnTuple)")
                        Clock.stopTimer()
                        allowedInteractPauseResume = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                allowedInteractPauseResume = true
                        }
                    }
                    .opacity(self.pauseMode ? 0.0 : 1.0)
                    .allowsHitTesting(!self.pauseMode && !isFinished && allowedInteractPauseResume)
                
                
                Image(systemName: "play.fill")
                    .resizable()
                    .frame(width: pauseMode ? 60 : 0, height: pauseMode ? 60: 0)
                    .foregroundColor(.black)
                    .padding(.top, 650)
                    .padding(.leading, 215)
                    .zIndex(20)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 1.2)){
                            self.pauseMode = false
                        }
                        guard let timeLeft = returnTuple.0, let setsLeft = returnTuple.1 else {
                            print("No saved state for resuming the timer")
                            return
                        }
                        Clock.resumeTimer(timeLeft: timeLeft, sets: setsLeft, inRest: restMode, onTick: { timeString in
                            repsNum = Clock.timeStringToInterval(timeString)!
                        }, onFinish: {
                            repsNum = 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                print("Reps complete!")
                                completed = true
                                isFinished = true
                            }
                        })
                        allowedInteractPauseResume = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                allowedInteractPauseResume = true
                        }
                        print("Resumed timer")
                    }
                    .opacity(!self.pauseMode ? 0.0 : 1.0)
                    .allowsHitTesting(self.pauseMode && allowedInteractPauseResume)
                
                
                //Back Button
                Image(systemName: "arrowshape.turn.up.backward.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(self.isHoldingBack ? Color.black.opacity(0.6) : Color.black)
                    .scaleEffect(x: 1, y: -1)
                    .padding(.bottom, 700)
                    .padding(.trailing, 300)
                    .onTapGesture {
                        Clock.stopTimer()
                        path.removeLast()                    }
                    .onLongPressGesture(minimumDuration: 3, pressing: { isPressing in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            self.isHoldingBack = isPressing
                            }
                        }, perform: {
                            
                        }
                    )
                
                
                Circle()
                    .stroke(Color.black, lineWidth: 6)
                    .frame(width: 140, height: 140)
                    .padding(.top, 650)
                    .padding(.leading, 200)
                
                
                ZStack() {
                    if showTimer{

                        Image("timer-icon")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                            .padding(.bottom, 450)
                    }
                    if show3{Text("3").font(.custom(AppFonts.ValeraRound, size: 70)).bold().padding(.bottom, 450)}
                    if show2{Text("2").font(.custom(AppFonts.ValeraRound, size: 70)).bold().padding(.bottom, 450)}
                    if show1{Text("1").font(.custom(AppFonts.ValeraRound, size: 70)).bold().padding(.bottom, 450)}
                    if showGo{Text("GO!").font(.custom(AppFonts.ValeraRound, size: 70)).bold().padding(.bottom, 450)}

                    
                    Text("Sets Remaining: \(setsNum)")
                        .font(.custom(AppFonts.ValeraRound, size: 20))
                        .padding(.bottom, 200)
                    
                    
                    Text(Clock.timeIntervalToString(from: repsNum))
                        .font(.custom(AppFonts.ValeraRound, size: 80))
                        .padding(.top, 40)

                    
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .fill(isHoldingRunTimer ? Color.white.opacity(0.3) : Color.clear) // Use any color you'd like
                            .frame(width: 320, height: 100)
                            .overlay(
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .stroke(Color.black, lineWidth: 6)
                            )

                        Text("Run Timer")
                            .font(.custom(AppFonts.ValeraRound, size: 50))
                    }
                    .padding(.top, 300)
                    .onTapGesture {
                        
                        setsNum = originalPreset.sets
                        completed = false
                        // Start countdown sequence
                        
                            playAudio("CountDown")
                            showTimer = false
                            show3 = true
                        // Triggers after 1 second has past
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            playAudio("CountDown")
                            show3 = false
                            show2 = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            playAudio("CountDown")
                            show2 = false
                            show1 = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            playAudio("GoSound")
                            show1 = false
                            showGo = true
                            
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0 ){
                            showGo = false
                            self.showTimer = true
                            isFinished = false
                            
                            
                            
                            
                            print("Timer is starting")
                            
                            
                            mutatingPreset = originalPreset
                            
                            print("mutatingPreset: \(mutatingPreset)")
                            completed = false
                            Clock.updateRestMode = { restBool in
                                self.restMode = restBool
    //                            self.moveTimer.toggle()
                            }
                            
                            Clock.updateSetsNum = { remainingSets in
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)){
                                    self.setsNum = remainingSets
                                }
                            }
                            
                            Clock.updatePauseMode = {paused in
                                self.pauseMode = paused
                            }
                            
                            Clock.startClock(sets: mutatingPreset.sets, reps: mutatingPreset.reps, rest: mutatingPreset.rest, inRestMode: false, onTick: { timeString in
                                
                                withAnimation(.spring(response: 0.3 ,dampingFraction: 0.5)){
                                    repsNum = Clock.timeStringToInterval(timeString)!
                                }
                            }, onFinish: {
                                
                                repsNum = 0
                                setsNum = 0
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    print("Reps complete!")
                                    completed = true
                                    isFinished = true
                          
                                }
                                
                            })
                        }
                        
                    }
                    .onLongPressGesture(minimumDuration: 3, pressing: { isPressing in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            self.isHoldingRunTimer = isPressing
                            }
                        }, perform: {
                            
                        }
                    )
                    .allowsHitTesting(isFinished)
                    
                }
                .navigationBarBackButtonHidden(true)
            }
            .onDisappear {
                        // Stop the timer when the view disappears
                        Clock.stopTimer()
                    }
        
        
    }
}

#Preview {
    let preset = Preset(sets: 3, reps: 6, rest: 4)
    let context = sharedModelContainer.mainContext
    let presetListClass = PresetListClass(context: context)
    
    ContentView(preset: preset, pressetList: presetListClass, path: .constant([]))
}
