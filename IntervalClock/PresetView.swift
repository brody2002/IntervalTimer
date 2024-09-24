//
//  PresetView.swift
//  IntervalClock
//
//  Created by Brody on 9/24/24.
//

import SwiftUI

struct PresetView: View {
    
    var body: some View {
        ZStack{
            
            
            Color.white.ignoresSafeArea()
            
            
            Text("Create Preset:")
                .font(.custom(AppFonts.AntipastoMed, size: 50))
                .padding(.bottom, 500)
            
            
            VStack(alignment: .leading, spacing: 32) {
                            
                HStack{
                    Text("+")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.trailing,30)
                    Text("Sets:")
                        .font(.custom(AppFonts.AntipastoMed, size: 20))
                        .padding(.trailing, 55)
                    Text("5")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .bold()
                    Text("-")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.leading,72)
                }
                HStack{
                    Text("+")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.trailing,30)
                    Text("Reps:")
                        .font(.custom(AppFonts.AntipastoMed, size: 20))
                        .padding(.trailing, 24)
                    Text("02:30")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .bold()
                    Text("-")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.leading,20)
                }
                HStack{
                    Text("+")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.trailing,30)
                    Text("Rest:")
                        .font(.custom(AppFonts.AntipastoMed, size: 20))
                        .padding(.trailing, 30)
                    Text("00:30")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .bold()
                    Text("-")
                        .font(.custom(AppFonts.AntipastoMed, size: 40))
                        .padding(.leading,20)
                }
            }
            .padding(.trailing, -10)
            .padding(.top, 100)
            
            
            
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .stroke(Color.black, lineWidth: 3)  // Outline with blue color and 2-point thickness
                        .frame(width: 350, height: 400)
                        .padding(.top,200)
            ZStack{
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .stroke(Color.black, lineWidth: 3)  // Outline with blue color and 2-point thickness
                            .frame(width: 350, height: 80)
                            
                
                Text("Add Preset: ")
                    .font(.custom(AppFonts.AntipastoMed, size: 30))
                    
                
            }.padding(.top,520)
            
        }
        
    }
}

#Preview {
    PresetView()
}
