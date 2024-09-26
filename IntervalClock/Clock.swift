import Foundation

class ClockClass {
    
    var timer: Timer?
    var timeRemaining: TimeInterval = 0
    var isRunning = false
    
    var updateSetsNum: ((Int) -> Void)?
    var updateRestMode: ((Bool) -> Void)?
    
    func timeIntervalToString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func timeStringToInterval(_ timeString: String) -> TimeInterval? {
        let cleanedString = timeString.filter { "0123456789".contains($0) }
        
        guard cleanedString.count <= 6 else { return nil }
        
        let paddedString = String(repeating: "0", count: 6 - cleanedString.count) + cleanedString
        
        let hours = Double(String(paddedString.prefix(2))) ?? 0
        let minutes = Double(String(paddedString.dropFirst(2).prefix(2))) ?? 0
        let seconds = Double(String(paddedString.dropFirst(4))) ?? 0
        
        return (hours * 3600) + (minutes * 60) + seconds
    }
    
    func startTimer(set: Int, for rep: TimeInterval, rest: TimeInterval, onTick: @escaping (String) -> Void, onFinish: @escaping () -> Void) {
        // Reset the timer state before starting
        stopTimer()
        isRunning = true
        print("Starting timer")
        
        // Start a loop for all sets
        DispatchQueue.global(qos: .background).async {
            var setsLeft = set
            
            while setsLeft > 0 && self.isRunning {
                
                self.timeRemaining = rep
                
                // Countdown for reps
                while self.timeRemaining > 0 && self.isRunning {
                    Thread.sleep(forTimeInterval: 1.0)
                    DispatchQueue.main.async {
                        self.updateRestMode?(false)
                    }
                    DispatchQueue.main.async {
                        onTick(self.timeIntervalToString(from: self.timeRemaining))
                    }
                    self.timeRemaining -= 1
                    print("Time remaining: \(self.timeRemaining)")
                }
                
                if !self.isRunning { break }
                
                setsLeft -= 1
                
                // Update setsNum through callback
                DispatchQueue.main.async {
                    self.updateSetsNum?(setsLeft)
                }
                
                guard setsLeft != 0 else {
                    continue
                }
                
                print("Entering rest")
                
                // Countdown for rest
                self.timeRemaining = rest
                while self.timeRemaining > 0 && self.isRunning {
                    Thread.sleep(forTimeInterval: 1.0)
                    DispatchQueue.main.async {
                        self.updateRestMode?(true)
                    }
                    DispatchQueue.main.async {
                        onTick(self.timeIntervalToString(from: self.timeRemaining))
                    }
                    
                    self.timeRemaining -= 1
                    print("Rest remaining: \(self.timeRemaining)")
                }
            }
            
            // If all sets are completed
            DispatchQueue.main.async {
                self.isRunning = false
                print("Finished all sets")
                onFinish()
            }
        }
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timeRemaining = 0  // Reset timeRemaining to avoid conflicts in the next run
    }
}

class PresetListClass : ObservableObject {
    var mainList: [Preset] = []
}

struct Preset {
    var sets: Int
    var reps: TimeInterval
    var rest: TimeInterval
    init(sets: Int, reps: TimeInterval, rest: TimeInterval) {
        self.sets = sets
        self.reps = reps
        self.rest = rest
    }
}

