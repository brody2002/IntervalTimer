import SwiftUI
import AVFoundation

struct ParentView: View {
    @State private var audioPlayer: AVAudioPlayer?

    func playAudio(_ inputString: String) {
        if let url = Bundle.main.url(forResource: inputString, withExtension: "mp3") {
            print("entered")
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
                print("audio playing")
            } catch {
                print("audio not playing")
            }
        } else {
            print("didn't work")
        }
    }
    

    var body: some View {
        Text("Play Sound")
            .onTapGesture {
                playAudio("GoSound")
            }
       
    }
}

#Preview {
    ParentView()
}

