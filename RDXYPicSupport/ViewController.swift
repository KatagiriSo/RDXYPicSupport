//
//  ViewController.swift
//  RDXYPicSupport
//
//  Created by 片桐奏羽 on 2016/11/10.
//  Copyright © 2016年 Rodhos. All rights reserved.
//

import Cocoa

class Node {
    var x = 0
    var y = 0
    var point:NSPoint? {
        didSet {
            if let point = point {
                let size = self.field.frame.size
                self.field.frame = NSRect(x:point.x - size.width/2,
                                          y:point.y - size.height/2,
                                          width:size.width,
                                          height:size.height)
            }
        }
    }
    var field:NSTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 50, height: 50))
}

class NodeStock {
    var nodes:[Node] = []
    
    func node(x:Int, y:Int, step:Int) -> Node {
        let ry = (step-1) - y
        return nodes[x+ry*step]
    }
    
    func clearText() {
        for node in nodes {
            node.field.stringValue = ""
        }
    }
}

let stock = NodeStock()

class ViewController: NSViewController, NSTextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var textView: NSTextView!
    
    
    
    var step = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let node = Node()
        node.field.stringValue = ""
        stock.nodes.append(node)
        
        update()

        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func update() {
        var yindex = 0
        var i = 0
        var count = 0
        
        self.scrollView.documentView?.frame.size = CGSize(width: step*50*2, height:step*50*2)

        
        for node in stock.nodes {
            if node.field.superview == nil {
                self.scrollView.documentView?.addSubview(node.field)
            }
            let x = node.field.frame.size.width*2 * CGFloat(i)
            let y = node.field.frame.size.height*2 * CGFloat(yindex)
            
            node.field.frame.origin = NSPoint(x: x, y: y)
            
            count = count + 1
            if count > step*step {
                node.field.removeFromSuperview()
            }
            
            node.x = i
            node.y = yindex
            
            i = i + 1
            if i >= step {
                i = 0
                yindex = yindex + 1
            }
        }
    }
    
    @IBAction func add(_ sender: Any) {
        step = step + 1
        while stock.nodes.count < step*step  {
            let node = Node()
            node.field.stringValue = ""
            stock.nodes.append(node)
        }
        update()
    }
    
    @IBAction func down(_ sender: Any) {
        step = step - 1
        if step <= 0 {
            step = 1
        }
        update()
    }
    
    func latex() -> String {
        var latex = ""
        
        latex = latex.appending("\\xymatrix{\n")
        
        for yindex in 0..<step {
            for i in 0..<step {
                let node = stock.node(x:i,y:yindex,step:step);
                let text = node.field.stringValue
                latex.append(text)
                
                if i != step - 1 {
                    latex.append(" & ")
                }
                
            }
            
            latex.append(" \\\\ \n")
            
            
        }
        
        
        latex = latex.appending("}\n")
        
        return latex
    }
    
    @IBAction func previewButtnPushed(_ sender: Any) {
        self.textView.string = self.latex()
        print(self.textView.string!)
    }
    
    @IBAction func clearButtonPushed(_ sender: Any) {
        stock.clearText()
        update()
    }
    
    
    
}

