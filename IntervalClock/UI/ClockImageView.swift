import SwiftUI

struct ClockImageView: View {
    // State variable to track the angle of the animation, starting at 90 degrees
    @State private var angle: Double = 90.0
    @State private var direction: Double = 1.0 // Controls the movement direction
    @State private var timer: Timer? // To track the timer
    
    // Parameters for controlling the width and height of the arc
    var arcWidth: CGFloat
    var arcHeight: CGFloat
    @Binding var moveTimer: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            // Circle that moves along a half-circle arc
            Image("timer-icon")
                .resizable()
                .frame(width: 100, height: 100)
                .imageScale(.large)
                .foregroundStyle(.tint)
                .padding(.bottom, 450)
                .position(x: size.width / 2 + halfCircleX(radius: arcWidth / 2, angle: angle),
                          y: size.height / 2 - halfCircleY(radius: arcHeight / 2, angle: angle)) // Negate y for upward arc
        }
        // Start or stop the timer based on `moveTimer` changes
        .onAppear{
            if moveTimer{
                startTimer()
            }
            
        }
        .onChange(of: moveTimer){
            stopTimer()
        }
        
    }
    
    // Function to start the timer
    private func startTimer() {
        // If the timer is already running, don't start another one
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                // Increment or decrement the angle based on direction
                angle += direction
                
                // Reverse direction at the ends of the half-circle (0 to 180 degrees)
                if angle >= 180 || angle <= 0 {
                    direction *= -1
                }
            }
        }
    }
    
    // Function to stop the timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Helper functions to calculate the position offsets for the half-circle arc
    func halfCircleX(radius: CGFloat, angle: Double) -> CGFloat {
        return radius * cos(degreesToRadians(angle)) // x movement follows the half-circle
    }
    
    func halfCircleY(radius: CGFloat, angle: Double) -> CGFloat {
        return radius * sin(degreesToRadians(angle)) // y movement follows the half-circle
    }
    
    // Function to convert degrees to radians
    func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
}

#Preview {
    // Example usage of the ClockImageView with specified arc width and height
    ClockImageView(arcWidth: 200, arcHeight: 100, moveTimer: .constant(true))
}

