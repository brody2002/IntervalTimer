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
    
    var body: some View {
//        NavigationView{
//            NavigationLink(destination: ContentView(setsNum: sets, repsNum: reps, restNum: rest)){
                ZStack{
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .stroke(Color.black, lineWidth: 3)
                        .frame(width: 350, height: 120)
                    Text("Sets: \(sets)")
                        .font(.custom(AppFonts.ValeraRound, size: 20))
                        .padding(.trailing, 250)
                        .padding(.bottom, 60)
                        .foregroundColor(.black)
                    Text("Reps: \(Clock.timeIntervalToString(from: reps))")
                        .font(.custom(AppFonts.ValeraRound, size: 20))
                        .padding(.leading, 170)
                        .padding(.top, 0)
                        .foregroundColor(.black)
                    Text("Rest: \(Clock.timeIntervalToString(from: rest))")
                        .font(.custom(AppFonts.ValeraRound, size: 20))
                        .padding(.leading, 170)
                        .padding(.top, 70)
                        .foregroundColor(.black)
//                }
//            }
            
        }
        
        
        
    }
}

#Preview {
    PresetRow(sets: 3, reps: 10.0, rest: 33.0)
}
