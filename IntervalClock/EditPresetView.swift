//
//  PresetView.swift
//  IntervalClock
//
//  Created by Brody on 9/24/24.
//
import SwiftUI
import SwiftData

struct EditPresetView: View {
    //Inits
    @State var preset: Preset
    @ObservedObject var PresetList: PresetListClass
    @State var setsNum: Int = 0
    @State var repsNum: TimeInterval = 0.00
    @State var restNum: TimeInterval = 0.00
    @State var name : String
    @Binding var path : [String]
    
//    @Binding var path: [String]
    
    
    @State var Clock = ClockClass()
    @State var isHolding: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    init(preset: Preset, PresetList:  PresetListClass, path: Binding<[String]>){
        self._path = path
        self.setsNum = preset.sets
        self.repsNum = preset.reps
        self.restNum = preset.rest
        self.preset = preset
        self.PresetList = PresetList
        self.name = preset.name
        
    }
    
    @State private var isIncrementing = false
    @State private var timer: Timer? = nil
    
    @State var hasPressed: Bool = false
    
    var body: some View {
        ZStack{
            
            AppColors.work.ignoresSafeArea()
            Image(systemName: "arrowshape.turn.up.backward.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(self.isHolding ? Color.black.opacity(0.6) : Color.black)
                .scaleEffect(x: 1, y: -1)
                .padding(.bottom, 700)
                .padding(.trailing, 300)
                .onTapGesture {
                    Clock.stopTimer()
                    self.presentationMode.wrappedValue.dismiss()
                }
                .onLongPressGesture(minimumDuration: 3, pressing: { isPressing in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                        self.isHolding = isPressing
                        }
                    }, perform: {
                        
                    }
                )
            Text("Name:")
                .font(.custom(AppFonts.ValeraRound, size: 35))
                .padding(.bottom, 200)
                .padding(.trailing,170)
            TextField("\(preset.name)", text: $preset.name)
                .font(.custom(AppFonts.ValeraRound, size: 35))
                .padding(.bottom, 200)
                .padding(.leading,190)
            Text("Edit Preset:")
                .font(.custom(AppFonts.ValeraRound, size: 50))
                .padding(.bottom, 400)
            
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
                            setsNum = max(1, setsNum - 1)
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
                        .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    HStack {
                                        Spacer() // Pushes the button to the right
                                        Button("Done") {
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        }
                                    }
                                }
                            }
                    
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
                            repsNum = max(1, repsNum - 1)
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
                .stroke(Color.black, lineWidth: 6)
                .frame(width: 350, height: 450)
                .padding(.top, 150)
            
            
            
            
            
            // Add Preset Button:
        
            EditPresetButton()
            .padding(.top, 520)
            .onTapGesture {
                   // Create an updated preset with the modified values
                let updatedPreset = Preset(sets: setsNum, reps: repsNum, rest: restNum,name: preset.name, id: preset.id)
                   
                   // Call the editPreset function with the original preset and the updated one
                   PresetList.editPreset(preset, inputPreset: updatedPreset)
                   
                   // Notify and dismiss the view
                   PresetList.objectWillChange.send()
                   PresetList.printPresets()
                path.removeLast(min(2, path.count)) 
               }
            
            
            
        }.navigationBarBackButtonHidden(true)
    }
    
    
    
    
    
    
    // Function to start incrementing based on input
    private func startIncrementing(_ input: String, for field: String) {
        isIncrementing = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            switch field {
            case "setsNum":
                if input == "+" && setsNum < 99 {
                    setsNum += 1
                } else if input == "-" && setsNum > 1 {
                    setsNum -= 1
                }
            case "repsNum":
                if input == "+" && repsNum < 10800 {
                    repsNum += 1
                } else if input == "-" && repsNum > 1 {
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
    let context = sharedModelContainer.mainContext
    let PresetList = PresetListClass(context: context) // Properly initialize PresetListClass with context
    let preset: Preset = Preset(sets: 1, reps: 1.0, rest: 0.0)
    EditPresetView(preset: preset, PresetList: PresetList,path: .constant([]))
}




