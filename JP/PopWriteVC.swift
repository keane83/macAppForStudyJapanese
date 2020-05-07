//
//  PopWriteVC.swift
//  JP
//
//  Created by keane83 on 2020/5/7.
//  Copyright © 2020 keane. All rights reserved.
//

import Cocoa

class PopWriteVC: NSViewController,NSWindowDelegate {
    
    var audioPlayerHelp: AudioHelper = AudioHelper()
    var currentClassIndex:Int!
    var wordsList:NSMutableArray!
    var selectedIndex:Int = -1
    var wordText:NSTextView! = NSTextView()
    var textF:NSTextField! = NSTextField()
    var step:NSStepper = NSStepper()
    var rateValueText:NSTextView = NSTextView()
    
    private var timer: Timer?
    
    func windowWillClose(_ aNotification: Notification) {
        print("windowWillClose")
        timer!.invalidate()
    }
    
    override func viewDidLoad() {
        self.title = "写单词"
        super.viewDidLoad()
        
        view.window?.delegate = self
        
        // Do view setup here.
        self.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 400, height: 300))
        
        
        
        textF.frame = CGRect(origin: CGPoint(x: 20, y: 60), size: CGSize(width: 360, height: 30))
        textF.backgroundColor = .clear
        textF.alignment = .center
        textF.font = NSFont.systemFont(ofSize: 23)
        textF.becomeFirstResponder()
        self.view.addSubview(textF)
        
        
        let attentionText = NSTextView()
        attentionText.frame = CGRect(origin: CGPoint(x: 20, y: 100), size: CGSize(width: 360, height: 30))
        attentionText.string = "输入0，开始下一单词"
        attentionText.font = NSFont.systemFont(ofSize: 12)
        attentionText.textColor = .gray
        attentionText.backgroundColor = .clear
        attentionText.alignment = .left
        attentionText.isEditable = false
        self.view.addSubview(attentionText)
        
        
//        self.view.window?.styleMask = NSWindow.StyleMask(rawValue: NSWindow.StyleMask.titled.rawValue | NSWindow.StyleMask.closable.rawValue | (NSWindow.StyleMask.resizable.rawValue) )
//        self.view.window?.styleMask = NSWindow.StyleMask(rawValue: ~(NSWindow.StyleMask.resizable.rawValue))
        self.view.window?.styleMask = NSWindow.StyleMask(rawValue: 0)
        //textF.window?.windowController
        //textF.window?.standardWindowButton(NSWindow.close)
//        [window setStyleMask:[window styleMask] & ~NSResizableWindowMask];
//        textF.window?.styleMask = (textF.window?.styleMask ?? []) & NSWindow.StyleMask.resizable
//        [[textF window] makeFirstResponder:myTextField];
        
//        let wordText = NSTextView()
        wordText.frame = CGRect(origin: CGPoint(x: 0, y: 200), size: CGSize(width: 400, height: 30))
        wordText.string = " "+(wordsList[selectedIndex] as! String)
        wordText.font = NSFont.systemFont(ofSize: 23)
        wordText.backgroundColor = .clear
        wordText.alignment = .center
        wordText.isEditable = false
        self.view.addSubview(wordText)
        
        
        
        let rateText = NSTextView()
        rateText.frame = CGRect(origin: CGPoint(x: 290, y: 280), size: CGSize(width: 90, height: 20))
        rateText.string = "重复朗读频率"
        rateText.font = NSFont.systemFont(ofSize: 12)
        rateText.textColor = .gray
        rateText.backgroundColor = .clear
        rateText.alignment = .center
        rateText.isEditable = false
        self.view.addSubview(rateText)
        
        
        rateValueText.frame = CGRect(origin: CGPoint(x: 300, y: 258), size: CGSize(width: 70, height: 30))
        rateValueText.string = "4"
        rateValueText.font = NSFont.systemFont(ofSize: 12)
        rateValueText.textColor = .white
        rateValueText.backgroundColor = .gray
        rateValueText.alignment = .center
        rateValueText.isEditable = false
//        rateValueText.layer?.borderColor = NSColor.gray.cgColor
//        rateValueText.layer?.borderWidth = 1
//        rateValueText.wantsLayer = true
        self.view.addSubview(rateValueText)
        
        
        step.frame = CGRect(origin: CGPoint(x: 370, y: 250), size: CGSize(width: 20, height: 30))
        step.isEnabled = true
        step.isContinuous = false
        step.minValue = 1;
        step.maxValue = 10;
        step.increment = 1.0; //步增值
        step.valueWraps = false; //循环，YES - 超过最小值，回到最大值；超过最大值，来到最小值。
        step.autorepeat = true; //默认为 YES-按住加号或减号不松
        step.wantsLayer = true;
        step.action = #selector(stepperAction)
        step.intValue = 4
        self.view.addSubview(step)
        
        self.view.window?.standardWindowButton(NSWindow.ButtonType.closeButton)?.isEnabled = false
        
//        self.view.window?.styleMask = (self.view.window?.styleMask.rawValue)^NSWindow.StyleMask.resizable.rawValue
    
        //[window setStyleMask:window.styleMask^NSResizableWindowMask];
        
        //[[window standardWindowButton:NSWindowZoomButton] setEnabled:NO];
//        [window setStyleMask:window.styleMask^NSResizableWindowMask];
        
        
        
        //添加快捷键上下方向键
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyUp) { (event) -> NSEvent? in
            
            print(event)
            if(event.keyCode == 29){//36 回车
                self.selectedIndex = self.selectedIndex + 1
                self.wordText.string = " "+(self.wordsList[self.selectedIndex] as! String)
                self.textF.stringValue = ""
//                self.dismiss(nil)
            }
            return event
        }
        
        self.audioPlayerHelp.playLessonIndex(self.currentClassIndex+1, wordIndex: self.selectedIndex+1)
        timer = Timer(timeInterval: TimeInterval(step.intValue), repeats: true) { (timer) in
            self.audioPlayerHelp.playLessonIndex(self.currentClassIndex+1, wordIndex: self.selectedIndex+1)
        }
        
        RunLoop.main.add(timer!, forMode: .common)
        
        DispatchQueue.main.async {
            self.textF.window?.makeFirstResponder(self.textF)
        }
    }
    
    
    @objc func stepperAction(sender:NSStepper){
        print("\(#function) \(sender.intValue)")
        rateValueText.string = String(sender.intValue)
        
        timer!.invalidate()
        timer = Timer(timeInterval: TimeInterval(step.intValue), repeats: true) { (timer) in
            self.audioPlayerHelp.playLessonIndex(self.currentClassIndex+1, wordIndex: self.selectedIndex+1)
        }

        RunLoop.main.add(timer!, forMode: .common)
    }
    
}
