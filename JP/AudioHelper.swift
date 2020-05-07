//
//  AudioHelper.swift
//  JP
//
//  Created by keane83 on 2020/4/13.
//  Copyright © 2020 keane. All rights reserved.
//

import Cocoa
import AVFoundation

class AudioHelper: NSObject {
    var audioPlayer: AVAudioPlayer!
    func playLessonIndex(_ lessIndex:Int,wordIndex:Int){
        
        if (self.audioPlayer != nil) {
            self.audioPlayer.stop()
        }
        
        let pathStr = String(format: "mp3/lesson\(lessIndex)/lesson\(lessIndex)-%02d", wordIndex)
        let file = Bundle.main.path(forResource: pathStr, ofType: "mp3")
        if file == nil {
            let alert = NSAlert.init()
            alert.messageText = "单个单词音频还没有生成，可以先点击右上角播放整课单词！"
            alert.runModal()
            return
        }
        let url = NSURL(fileURLWithPath: file!)
        do{
            self.audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
        }catch let error as NSError {
            print(error.description)
        }
        self.audioPlayer.play()
    }
    
    func playWholeLessonIndex(_ lessIndex:Int){
        
        if (self.audioPlayer != nil) {
            self.audioPlayer.stop()
        }
        
        let pathStr = String(format: "mp3/lesson/lesson\(lessIndex)")
        let file = Bundle.main.path(forResource: pathStr, ofType: "mp3")
        let url = NSURL(fileURLWithPath: file!)
        do{
            self.audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
        }catch let error as NSError {
            print(error.description)
        }
        self.audioPlayer.play()
    }
    
    func stop() {
        if(self.audioPlayer != nil){
            self.audioPlayer.stop()
        }
    }
}

