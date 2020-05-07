//
//  ViewController.swift
//  JP
//
//  Created by keane83 on 2020/4/10.
//  Copyright © 2020 keane. All rights reserved.
//

import Cocoa
var isGoing:Bool = false

class ViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource {

    private lazy var tableView: NSTableView = {
        let tmpTableView = NSTableView()
        tmpTableView.delegate = self
        tmpTableView.dataSource = self
        tmpTableView.allowsColumnSelection = false
        return tmpTableView
    }()
    
    var dataSourceX = ["小李赴日","小李的公司生活（1）","小李在箱根","小李的公司生活（2）","小李的日常迎新春","再见！日本"]
    static var jpClassArray = [
        ["李さんは中国人です","これは本です","ここはデパートです","部屋に机といすがあります"],
        ["森さんは７時に起きます","吉田さんは先月中国へ行きます","李さんは毎日コービーを飲みます","李さんは日本語で手紙を書きます"],
        ["四川料理は辛いです","京都の紅葉は有名です","小野さんは歌が好きです","李さんは森さんより若いです"],
        ["机の上に本が３册あります","昨日デパートへ行って、買い物しました","小野さんは今新聞を読んでいます","ホテルの部屋は広くてあ明るいです"],
                        ["わたしは　新しい　洋服が　欲しいです","携帯電話はとても小さくなりました","部屋のかぎを忘れないでください","スミスさんはピアノを弾くことができます"],
                        ["私はすき焼きを食べたことがあります","森さんは　毎晩　テレビを　見る","休みの日、散歩したり　買い物に　行ったり　します","李さんは　もう　すぐ　来ると　思います"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //初始化ScrollView用于承载tableView附有滚动效果
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.frame = self.view.frame
        self.view.addSubview(scrollView)
        
        
        //初始化两个column
        let column1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "test1"))
        column1.width = self.view.frame.size.width*2/5
        column1.title = ""
        
//        column1.isHidden = true
        let column2 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "test2"))
        column2.width = self.view.frame.size.width*3/5
        column2.title = ""
        column2.headerCell.backgroundColor = NSColor.red
//        column2.isEditable = true
//        column2.isHidden = true
//        column2.sortDescriptorPrototype = NSSortDescriptor(key: "sortDescriptorPrototyp", ascending: false)
        //允许自动调整Column的尺寸
        column1.resizingMask = NSTableColumn.ResizingOptions.autoresizingMask
        column2.resizingMask = NSTableColumn.ResizingOptions.autoresizingMask
        
        tableView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 800, height: 600))
        tableView.addTableColumn(column1)
        tableView.addTableColumn(column2)
        tableView.headerView = nil
        scrollView.contentView.documentView = tableView
    }

    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 24
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        var rowStr = "      "
        if tableColumn?.identifier ==  NSUserInterfaceItemIdentifier(rawValue: "test1") {
            if (row%4 == 0){
                rowStr += "第" + String(row/4+1) + "单元"+" "+dataSourceX[row/4]
            }else{
                rowStr = ""
            }
            
        }else if tableColumn?.identifier ==  NSUserInterfaceItemIdentifier(rawValue: "test2") {
            
            rowStr += "第" + String(row+1) + "课" + " " + ViewController.jpClassArray[row/4][row%4]
        }
        
        return rowStr
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        print("oldDescriptors[0] -> (sortDescriptorPrototyp, descending, compare:)")
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        
        if isGoing == true{
            return false
        }
        isGoing = true
        let danYuan = String(row/4+1)
        let ke = String(row%4+1)
        print("------- \(danYuan) \(ke)")
        let cvc = ClassVC()
        cvc.currentClassIndex = row
        
//        self.presentAsModalWindow(cvc)
//        self.present(cvc, animator: NSViewControllerPresentationAnimator)
//        self.presentAsSheet(cvc)
//        self.view.window?.contentView = cvc.view
        
        
        self.view.addSubview(cvc.view)
        self.addChild(cvc)
        
        return false
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn){
        print(tableColumn.title)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

