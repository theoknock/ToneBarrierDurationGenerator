//
//  TetradGenerator.swift
//  ToneBarrierDurationGenerator
//
//  Created by Xcode Developer on 5/11/24.
//

import Foundation

struct Tone {
    var duration: Double
}

struct Harmony {
    var tones: [Tone]
}

struct Dyad {
    var harmonies: [Harmony]
}

struct Tetrad {
    var dyads: [Dyad]
}

class TetradGenerator {
    func generateDistinctDurations() -> (Double, Double) {
        let lowerBound = 0.3125
        let upperBound = 1.6875
        let firstDuration = round(10000 * Double.random(in: lowerBound...upperBound)) / 10000
        var secondDuration = round(10000 * Double.random(in: lowerBound...upperBound)) / 10000
        
        // Ensure the difference between durations is greater than 0.3125
        while abs(firstDuration - secondDuration) <= 0.3125 {
            secondDuration = round(10000 * Double.random(in: lowerBound...upperBound)) / 10000
        }
        
        return (firstDuration, secondDuration)
    }
    
    func generateTetrad() -> Tetrad {
        let (firstHarmonyDuration, secondHarmonyDuration) = generateDistinctDurations()
        let dyad1 = Dyad(
            harmonies: [
                Harmony(tones: [Tone(duration: round(10000 * firstHarmonyDuration) / 10000), Tone(duration: round(10000 * firstHarmonyDuration) / 10000)]),
                Harmony(tones: [Tone(duration: round(10000 * (2.0 - firstHarmonyDuration)) / 10000), Tone(duration: round(10000 * (2.0 - firstHarmonyDuration)) / 10000)])
            ]
        )
        
        let dyad2 = Dyad(
            harmonies: [
                Harmony(tones: [Tone(duration: round(10000 * secondHarmonyDuration) / 10000), Tone(duration: round(10000 * secondHarmonyDuration) / 10000)]),
                Harmony(tones: [Tone(duration: round(10000 * (2.0 - secondHarmonyDuration)) / 10000), Tone(duration: round(10000 * (2.0 - secondHarmonyDuration)) / 10000)])
            ]
        )
        
        return Tetrad(dyads: [dyad1, dyad2])
    }
}
