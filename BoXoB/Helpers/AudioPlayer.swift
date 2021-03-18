//
//  AudioPlayer.swift
//  PicCross
//
//  Created by apple on 13/10/19.
//  Copyright © 2019 iOSAppWorld. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer: NSObject {
    static let shared = AudioPlayer()
    var audioPlayer: AVAudioPlayer?

    func mangeAudio()  {
        if UserDefaults.standard.bool(forKey: "backgroundMusic") == true{
            let path = Bundle.main.path(forResource: Constants.MusicFileName, ofType:nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1

                audioPlayer?.play()
            } catch {
                // couldn't load file :(
            }
        }
        else{
            audioPlayer?.stop()
        }
    }

}
