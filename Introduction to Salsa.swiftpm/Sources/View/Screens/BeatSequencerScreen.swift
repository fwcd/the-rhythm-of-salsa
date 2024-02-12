import SwiftUI

struct BeatSequencerScreen: View {
    @EnvironmentObject private var engine: BeatSequencerEngine
    
    var body: some View {
        SharedBeatSequencerView()
            .onAppear {
                engine.model.tracks = Instrument.allCases.map { Track(preset: .init(instrument: $0)) }
                
                // FIXME: Figure out where to actually load the MIDI riff
                let midiURL = Bundle.main.url(forResource: "Riff I-I-V-V", withExtension: "mid")!
                let midi = try! BeatSequencerModel(midiFileURL: midiURL)
                var track = midi.tracks.first!
                track.isLooping = true
                engine.model.tracks.append(track)
            }
            .navigationTitle("Beat Sequencer")
    }
}

#Preview {
    BeatSequencerScreen()
        .environmentObject(BeatSequencerEngine())
        .preferredColorScheme(.dark)
}
