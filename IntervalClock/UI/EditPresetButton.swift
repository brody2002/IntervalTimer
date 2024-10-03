//
//  EditPresetButton.swift
//  IntervalClock
//
//  Created by Brody on 10/2/24.
//

import SwiftUI

struct EditPresetButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .stroke(Color.black, lineWidth: 6)
                .frame(width: 350, height: 80)
            
            Text("Edit Preset: ")
                .font(.custom(AppFonts.ValeraRound, size: 45))
        }
    }
}

#Preview {
    EditPresetButton()
}

