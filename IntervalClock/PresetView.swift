//
//  PresetView.swift
//  IntervalClock
//
//  Created by Brody on 9/24/24.
//
import SwiftUI

struct PresetView: View {
    @State var setsNum: Int = 0
    @State var repsNum: TimeInterval = 0.00
    @State var restNum: TimeInterval = 0.00
    @State var Clock = ClockClass()
    @ObservedObject var PresetList: PresetListClass
    
    @State private var isIncrementing = false
    @State private var timer: Timer? = nil
    
    @State var hasPressed: Bool = false
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            
            Text("Create Preset:")
                .font(.custom(AppFonts.ValeraRound, size: 50))
                .padding(.bottom, 500)
            
            VStack(alignment: .leading, spacing: 32) {
                
                // Sets (Int with 2-character restriction)
                ZStack {
                    Text("-")
                        .font(.custom(AppFonts.ValeraRound, size: 40))
                        .padding(.trailing, 275)
                        .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
                            self.hasPressed = pressing
                            if pressing { startIncrementing("-", for: "setsNum") }
                            if !pressing { stopIncrementing() }
                        }, perform: {})
                        .onTapGesture {
                            setsNum = max(0, setsNum - 1)
                        }
                    
                    Text("Sets:")
                        .font(.custom(AppFonts.ValeraRound, size: 20))
                        .padding(.trailing, 135)
                    
                    TextField("\(setsNum)", value: $setsNum, formatter: NumberFormatter())
                        .font(.custom(AppFonts.ValeraRound, size: 40))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(width: 80)
                        .onChange(of: setsNum) { newValue in
                            setsNum = min(max(newValue, 0), 99) // Limit between 0 and 99
                        }
                        .bold()
                    
                    Text("+")
                        .font(.custom(AppFonts.ValeraRound, size: 40))
                        .padding(.leading, 275)
                        .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
                            self.hasPressed = pressing
                            if pressing { startIncrementing("+", for: "setsNum") }
                            if !pressing { stopIncrementing() }
                        }, perform: {})
                        .onTapGesture {
                            setsNum = min(setsNum + 1, 99)
                        }
                }
                
                // Reps (TimeInterval in hh:mm:ss format)
                ZStack {
                    Text("-")
                        .font(.custom(AppFonts.ValeraRound, size: 40))
                        .padding(.trailing, 275)
                        .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
                            self.hasPressed = pressing
                            if pressing {
                                startIncrementing("-", for: "repsNum") }
                            if !pressing { stopIncrementing() }
                        }, perform: {})
                        .onTapGesture {
                            repsNum = max(0, repsNum - 1)
                        }
                    
                    Text("Reps:")
                        .font(.custom(AppFonts.ValeraRound, size: 20))
                        .padding(.trailing, 135)
                    
                    TextField(Clock.timeIntervalToString(from: repsNum), text: Binding(
                        get: {
                            Clock.timeIntervalToString(from: repsNum)
                        },
                        set: { newValue in
                            if let interval = Clock.timeStringToInterval(newValue) {
                                repsNum = min(interval, 86399) // Restrict to 3 hours max
                            }
                        }
                    ))
                    .font(.custom(AppFonts.ValeraRound, size: 26))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 150)
                    .bold()
                    .padding(.leading, 80)
                    
                    Text("+")
                        .font(.custom(AppFonts.ValeraRound, size: 40))
                        .padding(.leading, 275)
                        .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
                            self.hasPressed = pressing
                            if pressing {
                                startIncrementing("+", for: "repsNum") }
                            if !pressing { stopIncrementing() }
                        }, perform: {})
                        .onTapGesture {
                            repsNum = min(repsNum + 1, 86399)
                        }
                }
                
                // Rest (TimeInterval in hh:mm:ss format)
                ZStack {
                    Text("-")
                        .font(.custom(AppFonts.ValeraRound, size: 40))
                        .padding(.trailing, 275)
                        .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
                            self.hasPressed = pressing
                            if pressing {
                                startIncrementing("-", for: "restNum") }
                            if !pressing { stopIncrementing() }
                        }, perform: {})
                        .onTapGesture {
                            restNum = max(0, restNum - 1)
                        }
                    
                    Text("Rest:")
                        .font(.custom(AppFonts.ValeraRound, size: 20))
                        .padding(.trailing, 135)
                    
                    TextField(Clock.timeIntervalToString(from: restNum), text: Binding(
                        get: {
                            Clock.timeIntervalToString(from: restNum)
                        },
                        set: { newValue in
                            if let interval = Clock.timeStringToInterval(newValue) {
                                restNum = min(interval, 86399) // Restrict to 3 hours max
                            }
                        }
                    ))
                    .font(.custom(AppFonts.ValeraRound, size: 26))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 150)
                    .bold()
                    .padding(.leading, 80)
                    
                    Text("+")
                        .font(.custom(AppFonts.ValeraRound, size: 40))
                        .padding(.leading, 275)
                        .onLongPressGesture(minimumDuration: 0.5, pressing: { pressing in
                            self.hasPressed = pressing
                            if pressing {
                                startIncrementing("+", for: "restNum") }
                            if !pressing { stopIncrementing() }
                        }, perform: {})
                        .onTapGesture {
                            restNum = min(restNum + 1, 86399)
                        }
                }
            }
            .padding(.trailing, -10)
            .padding(.top, 100)
            
            
            
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .stroke(Color.black, lineWidth: 3)
                .frame(width: 350, height: 400)
                .padding(.top, 200)
            
            
            
            
            
            // Add Preset Button:
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .stroke(Color.black, lineWidth: 3)
                    .frame(width: 350, height: 80)
                
                Text("Add Preset: ")
                    .font(.custom(AppFonts.ValeraRound, size: 30))
            }
            .padding(.top, 520)
            .onTapGesture {
                PresetList.mainList.append(Preset(sets: setsNum, reps: repsNum, rest: restNum))
                print(PresetList.mainList)
            }
        }
    }
    
    
    
    
    
    
    // Function to start incrementing based on input
    private func startIncrementing(_ input: String, for field: String) {
        isIncrementing = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            switch field {
            case "setsNum":
                if input == "+" && setsNum < 99 {
                    setsNum += 1
                } else if input == "-" && setsNum > 0 {
                    setsNum -= 1
                }
            case "repsNum":
                if input == "+" && repsNum < 10800 {
                    repsNum += 1
                } else if input == "-" && repsNum > 0 {
                    repsNum -= 1
                }
            case "restNum":
                if input == "+" && restNum < 10800 {
                    restNum += 1
                } else if input == "-" && restNum > 0 {
                    restNum -= 1
                }
            default:
                break
            }
        }
    }
    
    // Function to stop incrementing
    private func stopIncrementing() {
        isIncrementing = false
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    @ObservedObject var preset = PresetListClass()
    PresetView(PresetList: preset)
}



