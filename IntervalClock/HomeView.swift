//
//  HomeView.swift
//  IntervalClock
//
//  Created by Brody on 9/25/24.
//

import SwiftUI


struct HomeView: View {
    @StateObject var PresetList = PresetListClass()
    @State var testShow: Bool = false
    var body: some View {
            NavigationView {
                ZStack {
                    ZStack {
                        NavigationLink(destination: PresetView(PresetList: PresetList)) {
                            Text("Make new preset")
                                .padding(.bottom, 450)
                                .bold()
                        }
                        
                        Text("Choose Preset")
                            .font(.headline)
                            .padding(.bottom, 550)
                        
                        Button(action: {
                            // Your action here
                            print(PresetList.mainList)
                            testShow = true
                        }) {
                            // Your label here
                            Text("show presets")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.bottom, 300)
                        }
                        if testShow{
                            VStack{
                                ScrollView {
                                    ForEach(0..<PresetList.mainList.count, id: \.self) { index in
                                        PresetRow(sets:PresetList.mainList[index].sets, reps: PresetList.mainList[index].reps, rest: PresetList.mainList[index].rest)
                                        
                                    }
                                }
                            }.padding(.top,400)
                        }
                        
                        
                    }
                }
                .navigationTitle("Home")
            }
    }
        
        
        
        
}
        


#Preview {
    HomeView()
}
