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
        VStack(alignment: .leading, content: {
            if tetrad.dyads.isEmpty {
                Text("Generating Tetrad...")
                    .onAppear {
                        updateTetrad()
                    }
            } else {
                tetradView(tetrad)
                Group {
                    Text("Metrics:")
                        .font(.caption).fontWeight(.bold).dynamicTypeSize(.small).scaledToFit()
                        .padding(.bottom)
                    Text("\t  Dyad[0] Harmony[0] Tone[0]\n\t- Dyad[1] Harmony[0] Tone[0]\n\t  --------------------------\n\t  \(durationDifference, specifier: "%.4f") seconds")
                        .padding(.bottom)
                    Text("\t  Dyad[0] Harmony[0] Tone[0]\n\t+ Dyad[0] Harmony[1] Tone[0]\n\t  --------------------------\n\t  \(sumFirstTonesHarmoniesDyad1, specifier: "%.4f") sec")
                        .padding(.bottom)
                    Text("\t  Dyad[1] Harmony[0] Tone[0]\n\t+ Dyad[1] Harmony[1] Tone[0]\n\t  --------------------------\n\t  \(sumFirstTonesHarmoniesDyad2, specifier: "%.4f") sec")
                }
                .font(.caption).monospaced().fontWeight(.light).dynamicTypeSize(.small).scaledToFit()
                
            }
        })
        .onReceive(timer) { _ in
            updateTetrad()
        }
        .frame(width: .infinity)
    }
    
    @ViewBuilder
    private func tetradView(_ tetrad: Tetrad) -> some View {
        Group {
            ForEach(Array(tetrad.dyads.enumerated()), id: \.offset) { index, dyad in
                Text("Dyad \(index + 1):")
                    .font(.caption).fontWeight(.bold).dynamicTypeSize(.small).scaledToFit()
                    .padding(.bottom)
                
                Group {
                    ForEach(Array(dyad.harmonies.enumerated()), id: \.offset) { harmonyIndex, harmony in
                        Text("\tHarmony \(harmonyIndex + 1): Tone Durations:\t\(harmony.tones.map { $0.duration }) seconds")
                    }
                }
                .font(.caption).monospaced().fontWeight(.light).dynamicTypeSize(.small).scaledToFit()
            }
        }
        .padding(.bottom)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
