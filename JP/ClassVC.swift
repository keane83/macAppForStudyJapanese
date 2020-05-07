//
//  ClassVC.swift
//  JP
//
//  Created by keane83 on 2020/4/10.
//  Copyright © 2020 keane. All rights reserved.
//

import Cocoa
import AVFoundation

class ClassVC: NSViewController,NSTableViewDelegate,NSTableViewDataSource {
    var audioPlayerHelp: AudioHelper = AudioHelper()
    var currentClassIndex:Int!
    var wordsList:NSMutableArray!
    var selectedIndex:Int = -1
    var ifWriteBtn:NSSwitch! = NSSwitch()
    private lazy var tableView: NSTableView = {
           let tmpTableView = NSTableView()
           tmpTableView.delegate = self
           tmpTableView.dataSource = self
           tmpTableView.allowsColumnSelection = false
           return tmpTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第"+String(currentClassIndex+1)+"课 " + ViewController.jpClassArray[currentClassIndex/4][currentClassIndex%4]
            
        let fileP = Bundle.main.path(forResource: "lesson\(currentClassIndex+1)", ofType: "plist")
        wordsList = NSMutableArray.init(contentsOfFile: fileP!)
    
        self.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 800, height: 600))
        
        //初始化ScrollView用于承载tableView附有滚动效果
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 800, height: 570))
        scrollView.automaticallyAdjustsContentInsets = false
    
        scrollView.backgroundColor = NSColor.red
        self.view.addSubview(scrollView)
       
        //初始化两个column
        let column1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "test1"))
        column1.width = self.view.frame.size.width
        column1.title = "第"+String(currentClassIndex+1)+"课 " + ViewController.jpClassArray[currentClassIndex/4][currentClassIndex%4]
        //允许自动调整Column的尺寸
        column1.resizingMask = NSTableColumn.ResizingOptions.autoresizingMask
//            tableView.frame = self.view.frame
//            tableView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 800, height: 600))
        tableView.addTableColumn(column1)
//        tableView.backgroundColor = NSColor.red
        tableView.font = NSFont.systemFont(ofSize: 40)
        tableView.headerView = nil
        scrollView.contentView.documentView = tableView
        
    
        let titleView = NSView()
        titleView.frame = CGRect(origin: CGPoint(x: 0, y: 570), size: CGSize(width: 800, height: 30))
        titleView.wantsLayer = true
        titleView.layer?.backgroundColor = NSColor(red: 30/255, green: 32/255, blue: 34/255, alpha: 1).cgColor
        self.view.addSubview(titleView)
        
        
        
        let titleTextView = NSTextView()
        titleTextView.frame = CGRect(origin: CGPoint(x: 0, y: 8), size: CGSize(width: 800, height: 30))
        titleTextView.string = "第"+String(currentClassIndex+1)+"课 " + ViewController.jpClassArray[currentClassIndex/4][currentClassIndex%4]
        titleTextView.backgroundColor = .clear
        titleTextView.alignment = .center
        titleView.addSubview(titleTextView)
    
        let btnHome = NSButton()
        btnHome.title = "目录"
        btnHome.alignment = NSTextAlignment.center
        btnHome.font = NSFont(name: "", size: 14)
        btnHome.frame = CGRect(origin: CGPoint(x: 20, y: 565), size: CGSize(width: 70, height: 40))
        self.view.addSubview(btnHome)
        btnHome.bezelStyle = NSButton.BezelStyle.rounded //按钮的边框样式
        btnHome.target = self
        btnHome.action = #selector(gotoHome)
    
    
        let wholePlayBtn = NSButton()
        wholePlayBtn.title = "►"
        wholePlayBtn.alignment = NSTextAlignment.center
        wholePlayBtn.font = NSFont(name: "", size: 14)
        wholePlayBtn.frame = CGRect(origin: CGPoint(x: 750, y: 565), size: CGSize(width: 40, height: 40))
        self.view.addSubview(wholePlayBtn)
        wholePlayBtn.bezelStyle = NSButton.BezelStyle.rounded //按钮的边框样式
        wholePlayBtn.target = self
        wholePlayBtn.action = #selector(playWholeMP3)
        
        
        
        ifWriteBtn.frame = CGRect(origin: CGPoint(x: 640, y: 565), size: CGSize(width: 40, height: 40))
        self.view.addSubview(ifWriteBtn)
        ifWriteBtn.target = self
        ifWriteBtn.action = #selector(writeChanged)
        
        let writeL = NSTextView()
        writeL.frame = CGRect(origin: CGPoint(x: 680, y: 576), size: CGSize(width: 48, height: 40))
        writeL.string = "写模式"
        writeL.backgroundColor = .clear
        writeL.alignment = .center
        self.view.addSubview(writeL)
        
//        ifWriteBtn.action = #selector(playWholeMP3)
        
        
        
        //添加快捷键上下方向键
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyUp) { (event) -> NSEvent? in
            if(self.selectedIndex == -1){
                return event
            }
            print(event)
            if(event.keyCode == 125){//DOWN
                self.playWords()
            }else if(event.keyCode == 126){//UP
                self.playWords()
            }else if(event.keyCode == 124){//LEFT
                self.playWords()
            }
            return event
        }
    }
       
    @objc func gotoHome() {
        print("######gotoHome")
        self.view.removeFromSuperview()
        audioPlayerHelp.stop()
        isGoing = false
        selectedIndex = -1
    }
    
    @objc func playWholeMP3() {
        print("######playWholeMP3")
        audioPlayerHelp.playWholeLessonIndex(currentClassIndex+1)
    }
    
    @objc func writeChanged(switchBtn:NSSwitch) {
        print("######writeChanged \(switchBtn.state)")
        tableView.reloadData()
    }
    
    @objc func playWords() {
        print(selectedIndex)
        audioPlayerHelp.playLessonIndex(currentClassIndex+1, wordIndex: selectedIndex+1)
    }
    
    @objc func writeWords() {
        print("\(#function) \(selectedIndex)")

        audioPlayerHelp.stop()
        isGoing = false
       
        let cvc = PopWriteVC()
        cvc.currentClassIndex = currentClassIndex
        cvc.wordsList = wordsList
        cvc.selectedIndex = selectedIndex
        self.presentAsModalWindow(cvc)
        
        selectedIndex = -1
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return wordsList.count
    }
           
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
           
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let rowStr = wordsList[row]
        return rowStr
    }
        
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        selectedIndex = row
        //audioPlayerHelp.playLessonIndex(currentClassIndex+1, wordIndex: row+1)
        return true
    }
    
    func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
        let cell:NSButtonCell! = NSButtonCell()
        cell.title = "      "+(wordsList[row] as! String)
        cell.target = self
        cell.tag = row
        cell.action = #selector(playWords)
        if ifWriteBtn!.state.rawValue == 1 {
            cell.action = #selector(writeWords)
        }
//        cell.highlightsBy = NSCell.StyleMask.changeGrayCellMask
        print("\(row) tableView cell update")
        return cell
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        print("######111111111")
    }
    
    func tableView(_ tableView: NSTableView, willDisplayCell cell: Any, for tableColumn: NSTableColumn?, row: Int) {
        let cellT:NSButtonCell = cell as! NSButtonCell
        cellT.font = NSFont.systemFont(ofSize: 18)
        cellT.alignment = .left;
        cellT.backgroundColor = NSColor.clear
    }

}
