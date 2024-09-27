//
//  PresetOptionsView.swift
//  IntervalClock
//
//  Created by Brody on 9/27/24.
//

import SwiftUI

struct PresetOptionsView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .foregroundColor(.white)
                .frame(width: 100, height: 40)
//                .padding(.top,70)
//                .padding(.trailing, 240)
            Image(systemName: "trash.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .padding(.trailing, 40)
//                .padding(.top, 70)
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .padding(.leading, 40)
//                .padding(.top, 70)
        }
    }
}

#Preview {
    PresetOptionsView()
}
