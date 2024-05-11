//
//  ContentView.swift
//  ToneBarrierDurationGenerator
//
//  Created by James Alan Bush on 5/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var tetrad: Tetrad = Tetrad(dyads: [])
    @State private var durationDifference: Double = 0.0
    @State private var sumFirstTonesHarmoniesDyad1: Double = 0.0
    @State private var sumFirstTonesHarmoniesDyad2: Double = 0.0
    private let generator = TetradGenerator()
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if tetrad.dyads.isEmpty {
                Text("Generating Tetrad...")
                    .onAppear {
                        updateTetrad()
                    }
            } else {
                tetradView(tetrad)
                Text("Difference between first tones of Dyad 1 and Dyad 2: \(durationDifference, specifier: "%.4f") seconds")
                    .padding()
                Text("Sum of first tones in both Harmonies of Dyad 1: \(sumFirstTonesHarmoniesDyad1, specifier: "%.4f") seconds")
                    .padding()
                Text("Sum of first tones in both Harmonies of Dyad 2: \(sumFirstTonesHarmoniesDyad2, specifier: "%.4f") seconds")
                    .padding()
            }
        }
        .onReceive(timer) { _ in
            updateTetrad()
        }
    }
    
    @ViewBuilder
    private func tetradView(_ tetrad: Tetrad) -> some View {
        ForEach(Array(tetrad.dyads.enumerated()), id: \.offset) { index, dyad in
            Text("Dyad \(index + 1):")
                .bold()
            ForEach(Array(dyad.harmonies.enumerated()), id: \.offset) { harmonyIndex, harmony in
                Text("  Harmony \(harmonyIndex + 1): Tone Durations = \(harmony.tones.map { $0.duration }) seconds")
            }
        }
    }
    
    private func updateTetrad() {
        tetrad = generator.generateTetrad()
        calculateDifferencesAndSums()
    }
    
    private func calculateDifferencesAndSums() {
        let dyad1FirstToneDuration = tetrad.dyads.first?.harmonies.first?.tones.first?.duration ?? 0.0
        let dyad2FirstToneDuration = tetrad.dyads.last?.harmonies.first?.tones.first?.duration ?? 0.0
        durationDifference = abs(dyad1FirstToneDuration - dyad2FirstToneDuration)
        
        sumFirstTonesHarmoniesDyad1 = (tetrad.dyads.first?.harmonies.first?.tones.first?.duration ?? 0.0) +
        (tetrad.dyads.first?.harmonies.last?.tones.first?.duration ?? 0.0)
        sumFirstTonesHarmoniesDyad2 = (tetrad.dyads.last?.harmonies.first?.tones.first?.duration ?? 0.0) +
        (tetrad.dyads.last?.harmonies.last?.tones.first?.duration ?? 0.0)
    }
}
