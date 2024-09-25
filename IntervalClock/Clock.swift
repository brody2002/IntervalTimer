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
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func timeStringToInterval(_ timeString: String) -> TimeInterval? {
        // Remove non-numeric characters for clean input processing
        let cleanedString = timeString.filter { "0123456789".contains($0) }
        
        guard cleanedString.count <= 6 else { return nil }
        
        // Pad the string with zeros to ensure it's 6 digits (hhmmss)
        let paddedString = String(repeating: "0", count: 6 - cleanedString.count) + cleanedString
        
        // Extract hours, minutes, and seconds
        let hours = Double(String(paddedString.prefix(2))) ?? 0
        let minutes = Double(String(paddedString.dropFirst(2).prefix(2))) ?? 0
        let seconds = Double(String(paddedString.dropFirst(4))) ?? 0
        
        return (hours * 3600) + (minutes * 60) + seconds
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


class PresetListClass : ObservableObject{
    var mainList: [Preset] = []
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
