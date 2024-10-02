import Foundation
import SwiftData


class ClockClass {

    var timer: Timer?
    var timeRemaining: TimeInterval = 0
    var isRunning = false
    var isPaused = false
    var inRest = false

    private var globalSetsLeft: Int? = nil
    private var globalRepsLeft: TimeInterval? = nil
    private var globalRestLeft: TimeInterval? = nil

    var updateSetsNum: ((Int) -> Void)?
    var updateRestMode: ((Bool) -> Void)?
    var updatePauseMode: ((Bool) -> Void)?

    // Converts time interval to string
    func timeIntervalToString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // Converts string to time interval
    func timeStringToInterval(_ timeString: String) -> TimeInterval? {
        let cleanedString = timeString.filter { "0123456789".contains($0) }
        guard cleanedString.count <= 6 else { return nil }
        let paddedString = String(repeating: "0", count: 6 - cleanedString.count) + cleanedString
        let hours = Double(String(paddedString.prefix(2))) ?? 0
        let minutes = Double(String(paddedString.dropFirst(2).prefix(2))) ?? 0
        let seconds = Double(String(paddedString.dropFirst(4))) ?? 0
        return (hours * 3600) + (minutes * 60) + seconds
    }

    func startClock(sets: Int, reps: TimeInterval, rest: TimeInterval, timeLeft: TimeInterval? = nil, inRestMode fromRest: Bool, onTick: @escaping (String) -> Void, onFinish: @escaping () -> Void) {
        // Ensure timer state is properly reset before starting
        stopTimer()
        isRunning = true
        isPaused = false
        self.globalSetsLeft = sets
        self.globalRepsLeft = reps
        self.globalRestLeft = rest
        var repsToUse: TimeInterval = 0.0
        // Set the reps to use based on timeLeft or the default rep time
        if fromRest{ repsToUse = reps }
        else { repsToUse = timeLeft ?? reps }
        
        
        
        // Start timer logic
        DispatchQueue.global(qos: .background).async {
            while self.globalSetsLeft! > 0 && self.isRunning {
                // Check if paused
                if self.isPaused {
                    Thread.sleep(forTimeInterval: 0.1)
                    continue
                }

                self.timeRemaining = repsToUse

                // Rep countdown loop
                while self.timeRemaining > 0 && self.isRunning && !self.isPaused {
                    DispatchQueue.main.async {
                        self.inRest = false
                        self.updateRestMode?(self.inRest)
                        onTick(self.timeIntervalToString(from: self.timeRemaining))
                    }
                    Thread.sleep(forTimeInterval: 1.0)
                    self.timeRemaining -= 1
                }

                // Reset `repsToUse` to the default rep time after a complete rep iteration
                repsToUse = self.globalRepsLeft!

                // Only decrement sets count if not paused
                if self.isRunning && !self.isPaused {
                    self.globalSetsLeft! -= 1
                    DispatchQueue.main.async {
                        self.updateSetsNum?(self.globalSetsLeft!)
                    }
                }

                // If all sets are completed
                if self.globalSetsLeft! == 0 {
                    break
                }

                // Rest period loop
                self.timeRemaining = self.globalRestLeft!
                while self.timeRemaining > 0 && self.isRunning && !self.isPaused {
                    DispatchQueue.main.async {
                        self.inRest = true
                        self.updateRestMode?(self.inRest)
                        onTick(self.timeIntervalToString(from: self.timeRemaining))
                    }
                    Thread.sleep(forTimeInterval: 1.0)
                    self.timeRemaining -= 1
                }
                
            }

            // If all sets are completed
            DispatchQueue.main.async {
                self.isRunning = false
                if self.isPaused {
                    print("paused")
                } else {
                    onFinish()
                }
            }
        }
    }


    // Stop the timer
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        timeRemaining = 0
    }

    // Pause the timer and return the current state
    func pauseTimer() -> (timeLeft: TimeInterval?, sets: Int?) {
        isPaused = true
        isRunning = false  // Stop running state
        timer?.invalidate()
        timer = nil
        updatePauseMode?(isPaused)
        return (timeLeft: timeRemaining, sets: globalSetsLeft)
    }

    // Resume the timer by calling `startClock`
    func resumeTimer(timeLeft: TimeInterval, sets: Int, inRest: Bool, onTick: @escaping (String) -> Void, onFinish: @escaping () -> Void) {
        isPaused = false
        isRunning = true
        self.globalSetsLeft = sets
        // Resume from the saved time left

        // Start the timer from the saved state
        startClock(sets: self.globalSetsLeft!, reps: self.globalRepsLeft!, rest: globalRestLeft!, timeLeft: timeLeft, inRestMode: inRest, onTick: onTick, onFinish: onFinish)
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


