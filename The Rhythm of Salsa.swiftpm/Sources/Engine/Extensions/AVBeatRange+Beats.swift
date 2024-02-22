import AVFoundation

extension AVBeatRange {
    init(_ range: Range<Beats>) {
        self = AVMakeBeatRange(
            AVMusicTimeStamp(range.lowerBound),
            AVMusicTimeStamp(range.upperBound)
        )
    }
}
