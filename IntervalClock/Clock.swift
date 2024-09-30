import Foundation
import SwiftData


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
                    DispatchQueue.main.async {
                        self.updateRestMode?(false)
                        onTick(self.timeIntervalToString(from: self.timeRemaining))
                    }
                    
                    Thread.sleep(forTimeInterval: 1.0)
                    self.timeRemaining -= 1
                    print("Reps remaining: \(self.timeRemaining) + 1")
                }
                
                if !self.isRunning { break }
                
                setsLeft -= 1
                
                // Update setsNum through callback
                DispatchQueue.main.async {
                    print("subtract from setsNum")
                    self.updateSetsNum?(setsLeft)
                }
                
                guard setsLeft != 0 else {
                    continue
                }
                
                print("Entering rest")
                
                // Countdown for rest
                self.timeRemaining = rest
                
                // Ensure rest period is displayed correctly
                while self.timeRemaining > 0 && self.isRunning {
                    DispatchQueue.main.async {
                        self.updateRestMode?(true)
                        onTick(self.timeIntervalToString(from: self.timeRemaining))
                    }
                    
                    Thread.sleep(forTimeInterval: 1.0)
                    self.timeRemaining -= 1
                    print("Rest remaining: \(self.timeRemaining + 1.0)")
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


class PresetListClass: ObservableObject {
    var mainList: [Preset] = []
    var context: ModelContext? {
        didSet {
            if context != nil {
                fetchPresets()
            }
        }
    }
    
    init(context: ModelContext?) {
        self.context = context
        if context != nil {
            fetchPresets()
        }
    }
    
    // Fetch all presets from persistent storage
    func fetchPresets() {
        guard let context = context else { return }
        let fetchDescriptor = FetchDescriptor<Preset>()
        if let presets = try? context.fetch(fetchDescriptor) {
            mainList = presets
            print("mainList is now: \(mainList)")
        }
    }
    
    // Add a new preset to persistent storage
    func addPreset(_ preset: Preset) {
        guard let context = context else { return }
        context.insert(preset)
        saveContext()
        fetchPresets() // Refresh the list
    }
    
    func removePreset(_ preset: Preset) {
            guard let context = context else { return }
            context.delete(preset)
            saveContext()
            fetchPresets() // Refresh the list
        }
    
    
    func printPresets() {
        for preset in mainList {
            print("Preset - Sets: \(preset.sets), Reps: \(preset.reps), Rest: \(preset.rest)")
        }
    }
    
    // Save changes to the persistent storage
    private func saveContext() {
        guard let context = context else { return }
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}


@Model
class Preset {
    var sets: Int
    var reps: TimeInterval
    var rest: TimeInterval
    
    init(sets: Int, reps: TimeInterval, rest: TimeInterval) {
        self.sets = sets
        self.reps = reps
        self.rest = rest
    }
}

