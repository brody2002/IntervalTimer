//
//  SleepZs.swift
//  IntervalClock
//
//  Created by Brody on 9/25/24.
//

import SwiftUI

struct RestView: View {
    var body: some View {
        ZStack{
            Image("snorlax")
                .resizable()
                .frame(width: 100, height: 100)
            ZStack{
                Text("Z")
                    .font(.custom(AppFonts.ValeraRound, size: 25))
                Text("Z")
                    .font(.custom(AppFonts.ValeraRound, size: 30))
                    .padding(.bottom, 80)
                    .padding(.leading, 20)
                    .rotationEffect(.degrees(20))
                Text("Z")
                    .font(.custom(AppFonts.ValeraRound, size: 40))
                    .padding(.bottom, 100)
                    .padding(.leading, 110)
                    .rotationEffect(.degrees(-20))
                Text("Z")
                    .font(.custom(AppFonts.ValeraRound, size: 60))
                    .rotationEffect(Angle(degrees: -40))
                    .padding(.bottom, 220)
                    .padding(.leading, 120)
            }.padding(.leading, 50)
                .padding(.bottom ,20)
        }
       
        
    }
}

#Preview {
    RestView()
}
