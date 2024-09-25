//
//  PresetView.swift
//  IntervalClock
//
//  Created by Brody on 9/24/24.
//

import SwiftUI

struct PresetView: View {
    @State var setsNum: Int = 0
    @State var repsNum: TimeInterval = 00.00
    @State var restNum: TimeInterval = 00.00
    @State var Clock = ClockClass()
    @State var PresetList = PresetListClass()
    
    var body: some View {
        ZStack{
            
            
            Color.white.ignoresSafeArea()
            
            
            Text("Create Preset:")
                .font(.custom(AppFonts.AntipastoMed, size: 50))
                .padding(.bottom, 500)
            
            
            VStack(alignment: .leading, spacing: 32) {
                            
                ZStack{
                    Text("-")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.trailing,275)
                        .onTapGesture {
                            setsNum = max(0, setsNum - 1)
                        }
                    
                    Text("Sets:")
                        .font(.custom(AppFonts.AntipastoMed, size: 20))
                        .padding(.trailing, 135)
                    Text(String(setsNum))
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.leading,45)
                        .bold()
                    Text("+")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.leading,275)
                        .onTapGesture {
                            setsNum = min(setsNum + 1, 99)
                        }
                }
                ZStack{
                    Text("-")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.trailing,275)
                        .onTapGesture {
                            repsNum = max(0, repsNum - 1)
                        }
                    Text("Reps:")
                        .font(.custom(AppFonts.AntipastoMed, size: 20))
                        .padding(.trailing, 135)
                    Text(Clock.timeIntervalToString(from: repsNum))
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.leading,80)
                        .bold()
                    Text("+")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.leading,275)
                        .onTapGesture {
                            repsNum = min(repsNum + 1, 10800)
                        }
                }
                ZStack{
                    Text("-")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.trailing,275)
                        .onTapGesture {
                            restNum = max(0, restNum - 1)
                        }
                    Text("Rest:")
                        .font(.custom(AppFonts.AntipastoMed, size: 20))
                        .padding(.trailing, 135)
                    Text(Clock.timeIntervalToString(from: restNum))
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.leading,80)
                        .bold()
                    Text("+")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.leading,275)
                        .onTapGesture {
                            restNum = min(restNum + 1, 10800)
                        }
                }
            }
            .padding(.trailing, -10)
            .padding(.top, 100)
            
            
            
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .stroke(Color.black, lineWidth: 3)
                        .frame(width: 350, height: 400)
                        .padding(.top,200)
            
            // Add Preset Button:
            ZStack{
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .stroke(Color.black, lineWidth: 3)
                            .frame(width: 350, height: 80)
                            
                
                Text("Add Preset: ")
                    .font(.custom(AppFonts.AntipastoMed, size: 30))
                    
                
            }.padding(.top,520)
                .onTapGesture {
                    PresetList.mainList.append(Preset(sets: setsNum, reps: repsNum, rest: restNum))
                    
                    print(PresetList.mainList)
                }
            
        }
        
    }
}

#Preview {
    PresetView()
}
