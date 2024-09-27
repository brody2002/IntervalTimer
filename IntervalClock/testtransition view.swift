//
//  testtransition view.swift
//  IntervalClock
//
//  Created by Brody on 9/27/24.
//

import SwiftUI

import SwiftUI

struct test: View {
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack {
            NavigationLink {
                DetailView()
                    .navigationTransition(.zoom(sourceID: "zoom", in: namespace))
            } label: {
                Text("Source view here soon ")
            }
        }
    }
}

struct DetailView: View {
    
    @State var gradientStyle = Gradient(colors: [
        .blue, .purple, .red, .orange, .yellow
    ])
    
    var body: some View {
        
        VStack {
            Image(systemName: "swift")
                .font(.largeTitle)
                .foregroundStyle(.white)
                
                .background {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: gradientStyle,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 600, height: 200)
                        .ignoresSafeArea()
                }
            
            Spacer()
        }
    }
}

#Preview {
    test()
}
