//import SwiftUI
//
//struct HalfCircleMotionView: View {
//    // State variable to track the angle of the animation, starting at 90 degrees
//    @State private var angle: Double = 90.0
//    @State private var direction: Double = 1.0 // Controls the movement direction
//    
//    // State variables for controlling the width and height of the arc
//    @State private var arcWidth: CGFloat = 200.0
//    @State private var arcHeight: CGFloat = 100.0
//    
//    var body: some View {
//        VStack {
//            GeometryReader { geometry in
//                let size = geometry.size
//                
//                // Circle that moves along a half-circle arc
//                Circle()
//                    .frame(width: 50, height: 50)
//                    .foregroundColor(.blue)
//                    .position(x: size.width / 2 + halfCircleX(radius: arcWidth / 2, angle: angle),
//                              y: size.height / 2 - halfCircleY(radius: arcHeight / 2, angle: angle)) // Negate y for upward arc
//                    .onAppear {
//                        // Start the animation using a timer
//                        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
//                            // Increment or decrement the angle based on direction
//                            angle += direction
//                            
//                            // Reverse direction at the ends of the half-circle (0 to 180 degrees)
//                            if angle >= 180 || angle <= 0 {
//                                direction *= -1
//                            }
//                        }
//                    }
//            }
//            
//            Spacer()
//            
//            // Slider for adjusting the width of the arc
//            VStack {
//                Text("Arc Width: \(Int(arcWidth))")
//                Slider(value: $arcWidth, in: 50...400, step: 1)
//                    .padding()
//            }
//            
//            // Slider for adjusting the height of the arc
//            VStack {
//                Text("Arc Height: \(Int(arcHeight))")
//                Slider(value: $arcHeight, in: 50...200, step: 1)
//                    .padding()
//            }
//        }
//        .padding()
//    }
//    
//    // Helper functions to calculate the position offsets for the half-circle arc
//    func halfCircleX(radius: CGFloat, angle: Double) -> CGFloat {
//        return radius * cos(angle.toRadians()) // x movement follows the half-circle
//    }
//    
//    func halfCircleY(radius: CGFloat, angle: Double) -> CGFloat {
//        return radius * sin(angle.toRadians()) // y movement follows the half-circle
//    }
//}
//
//// Extension to convert degrees to radians
//extension Double {
//    func toRadians() -> Double {
//        return self * .pi / 180.0
//    }
//}
//
//#Preview {
//    HalfCircleMotionView()
//}



//

import SwiftUI

struct ParentView: View {
    @State private var moveTimer: Bool = false
    
    var body: some View {
        VStack {
            ClockImageView(arcWidth: 200, arcHeight: 100, moveTimer: $moveTimer)
            
            // Button to toggle the moveTimer state
            Button("Toggle Timer") {
                moveTimer.toggle()
            }
        }
    }
}

#Preview {
    ParentView()
}
