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

    func startClock(sets: Int, reps: TimeInterval, rest: TimeInterval, timeLeft: TimeInterval? = nil, inRestMode: Bool, onTick: @escaping (String) -> Void, onFinish: @escaping () -> Void) {
            // Ensure timer state is properly reset before starting
            stopTimer()
            isRunning = true
            isPaused = false
            self.globalSetsLeft = sets
            self.globalRepsLeft = reps
            self.globalRestLeft = rest
            
            // Determine if resuming from rest or work period
            if let remainingTime = timeLeft {
                self.timeRemaining = remainingTime
                self.inRest = inRestMode
            } else {
                self.timeRemaining = reps
                self.inRest = false
            }
            
            // Start timer logic
            DispatchQueue.global(qos: .background).async {
                while self.globalSetsLeft! > 0 && self.isRunning {
                    // Check if paused
                    
                    if self.isPaused {
                        Thread.sleep(forTimeInterval: 0.1)
                        continue
                    }

                    // **Handle Work and Rest Cycles**
                    if self.inRest {
                        // Handle rest period
                        
                        
                        
                        while self.timeRemaining > 0 && self.isRunning && !self.isPaused {
                            DispatchQueue.main.async {
                                self.updateRestMode?(true)
                                onTick(self.timeIntervalToString(from: self.timeRemaining))
                            }
                            Thread.sleep(forTimeInterval: 1.0)
                            self.timeRemaining -= 1
                        }
                        // Switch to work mode after rest
                        self.inRest = false
                        self.timeRemaining = self.globalRepsLeft!
                    } else {
                        // Handle work period
                        
                        
                        while self.timeRemaining > 0 && self.isRunning && !self.isPaused {
                            DispatchQueue.main.async {
                                self.updateRestMode?(false)
                                onTick(self.timeIntervalToString(from: self.timeRemaining))
                            }
                            Thread.sleep(forTimeInterval: 1.0)
                            self.timeRemaining -= 1
                        }
                       
                        // Switch to rest mode after work
                        
                        if self.globalSetsLeft == 1{
                            break
                        }
                        
                        self.inRest = true
                        self.timeRemaining = self.globalRestLeft!
                    }

                    // Only decrement sets count if not paused
                    if self.isRunning && !self.isPaused && !self.inRest {
                        self.globalSetsLeft! -= 1
                        // If all sets are completed
                        
                        DispatchQueue.main.async {
                            self.updateSetsNum?(self.globalSetsLeft!)
                        }
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
        self.inRest = inRest
        self.globalSetsLeft = sets
        
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
    func printPreset(_ preset: Preset) -> String{
        return ("Preset - Sets: \(preset.sets), Reps: \(preset.reps), Rest: \(preset.rest), Name: \(preset.name), ID: \(preset.id)")
    }
    func printPresets() {
        for preset in mainList {
            print("Preset - Sets: \(preset.sets), Reps: \(preset.reps), Rest: \(preset.rest), Name: \(preset.name), ID: \(preset.id)")
        }
    }
    
    // Fetch all presets from persistent storage
    func fetchPresets() {
        guard let context = context else { return }
        let fetchDescriptor = FetchDescriptor<Preset>()
        if let presets = try? context.fetch(fetchDescriptor) {
            mainList = presets
            print("PResetList: ")
            printPresets()
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
    
    
    
    
    func editPreset(_ preset: Preset, inputPreset: Preset) {
        print("InputPreset: \(printPreset(inputPreset)) originalPreset: \(printPreset(preset))")

        guard let context = context else { return }
        
        // Re-fetch the original preset from the context
        let fetchDescriptor = FetchDescriptor<Preset>()
        if let fetchedPresets = try? context.fetch(fetchDescriptor),
           let fetchedPreset = fetchedPresets.first(where: { $0.id == preset.id }) {
            print("we found the same id! YIPEEE")
            
            // Modify properties of the re-fetched preset
            
            fetchedPreset.sets = inputPreset.sets
            fetchedPreset.reps = inputPreset.reps
            fetchedPreset.rest = inputPreset.rest
            fetchedPreset.name = inputPreset.name
            
            // Save the changes to the persistent storage
            saveContext()
            
            print("Updated fetchedPreset: \(printPreset(fetchedPreset))")
        } else {
            print("Failed to fetch the original preset from the context")
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
    var name: String
    var sets: Int
    var reps: TimeInterval
    var rest: TimeInterval
    var id : UUID
    
    init(sets: Int, reps: TimeInterval, rest: TimeInterval,name: String? = nil, id: UUID? = nil) {
        self.sets = sets
        self.reps = reps
        self.rest = rest
        if let name = name{ self.name = name } else { self.name = "Preset"}
        if let id = id{self.id = id} else{ self.id = UUID()}
    }
}



