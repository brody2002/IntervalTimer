//
//  Clock.swift
//  IntervalClock
//
//  Created by Brody on 9/24/24.
//

import Foundation

class ClockClass {
    
    var timer: Timer?
    var timeRemaining: TimeInterval = 0
    var isRunning = false
    
    
    func timeIntervalToString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    func startTimer(for rep: TimeInterval, onTick: @escaping (String) -> Void, onFinish: @escaping () -> Void) {
        // Invalidate any previous timer
        timer?.invalidate()
        
        timeRemaining = rep
        isRunning = true
        
        // Schedule the timer to fire every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick(onTick: onTick, onFinish: onFinish)
        }
    }
    
    
    func timerTick(onTick: @escaping (String) -> Void, onFinish: @escaping () -> Void) {
        if timeRemaining > 0 {
            timeRemaining -= 1
            onTick(timeIntervalToString(from: timeRemaining))
        } else {
            timer?.invalidate()
            isRunning = false
            onFinish()
        }
    }
    
    
    func stopTimer() {
        timer?.invalidate()
        isRunning = false
    }
}

struct Preset{
    var sets: Int
    var reps: TimeInterval
    var rest: TimeInterval
    init(sets: Int, reps: TimeInterval, rest: TimeInterval){
        self.sets = sets
        self.reps = reps
        self.rest = rest
    }
}
