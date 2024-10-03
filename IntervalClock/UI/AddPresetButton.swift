//
//  AddPresetButton.swift
//  IntervalClock
//
//  Created by Brody on 9/26/24.
//

import SwiftUI

struct AddPresetButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .stroke(Color.black, lineWidth: 6)
                .frame(width: 350, height: 80)
            
            Text("Add Preset: ")
                .font(.custom(AppFonts.ValeraRound, size: 45))
        }
    }
}

#Preview {
    AddPresetButton()
}
