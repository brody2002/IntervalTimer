//
//  PresetOptionsView.swift
//  IntervalClock
//
//  Created by Brody on 9/27/24.
//

import SwiftUI

struct PresetOptionsView: View {
    let preset: Preset
    @StateObject var PresetList: PresetListClass
    @Binding var navigateToEdit: Bool

    var body: some View {
        ZStack{
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .foregroundColor(.clear)
                .frame(width: 100, height: 40)
//                .padding(.top,70)
//                .padding(.trailing, 240)
//            Image(systemName: "trash.fill")
//                .resizable()
//                .frame(width: 30, height: 30)
//                .padding(.trailing, 40)
//                .foregroundColor(.black)
//                .onTapGesture {
//                    print("delete preset")
//                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)){
//                        PresetList.removePreset(preset)
//                        PresetList.objectWillChange.send()
//                    }
//                    
//                }
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .padding(.leading, 40)
                .foregroundColor(.black)
                .onTapGesture {
                    print("edit preset! navigateToEdit -> true")
                    navigateToEdit = true
                } /*.navigate(to: PresetView(preset: preset, PresetList: PresetList), when: navigateToEdit)*/
                

        }
    }
}

#Preview {
    let context = sharedModelContainer.mainContext
    let PresetListClass = PresetListClass(context: context)
    let preset = Preset(sets: 1, reps: 2.0, rest: 3.0)
    PresetOptionsView(preset: preset, PresetList: PresetListClass, navigateToEdit: .constant(false) )
}
