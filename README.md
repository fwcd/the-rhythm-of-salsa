# The Rhythm of Salsa

A beat sequencer for Salsa music featuring an interactive introduction.

<div align="center">
<p>
<img alt="Logo" src="Icons/AppIconRounded.svg" width="80">
</p>

<p>
<img alt="Screenshot" src="Screenshots/Beat Sequencer.png" width="600">
</p>
</div>

## Description

"The Rhythm of Salsa" is a small introduction to Salsa music featuring an interactive, GarageBand-inspired beat sequencer. Diving into the rich polyrhythms of Latin music, the introduction provides an overview of the most important instruments and their rhythmic patterns in Salsa. During the entire tutorial, the user is encouraged to tweak the rhythm and experiment with new musical ideas. The final beat sequencer additionally supports fine-grained mixing controls, along with MIDI import and export, making it seamless to transition projects into a fully featured Digital Audio Workstation such as GarageBand or Logic Pro.

On the technical side, the app makes heavy use of SwiftUI, AVFoundation's powerful audio sequencer, its sampler and AudioToolbox's MIDI support. The app combines the classic model-view architecture with a modern, value- and protocol-oriented programming style that takes full advantage of modern Swift features such as property wrappers or multiple trailing closures. A delta update mechanism efficiently synchronizes the audio sequencer with the model, letting the user navigate the app freely while never missing a beat.

## See also

- [MiniCAD](https://github.com/fwcd/mini-cad), a parametric 3D modeller using a Swift-inspired DSL (my 2023 project)
- [MiniBlocks](https://github.com/fwcd/mini-blocks), an open-world sandbox game built with SceneKit (my 2022 project)
- [MiniCut](https://github.com/fwcd/mini-cut), a tiny video editor built with SpriteKit (my 2021 project)
- [MiniJam](https://github.com/fwcd/mini-jam), a tiny digital audio workstation built with SwiftUI (my 2020 project)
