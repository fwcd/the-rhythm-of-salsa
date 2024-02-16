import SwiftUI

struct BeatSequencerScreen: View {
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        SharedBeatSequencerView()
            .onAppear {
                engine.model.tracks = Instrument.allCases.compactMap { instrument in
                    instrument.patterns.first.map {
                        Track(preset: .init(instrument: instrument), pattern: $0)
                    }
                }
                
                // FIXME: Figure out where to actually load the MIDI riff
                
            }
            .navigationTitle("Beat Sequencer")
    }
}

#Preview {
    BeatSequencerScreen()
        .environmentObject(BeatSequencerEngine())
        .preferredColorScheme(.dark)
}
