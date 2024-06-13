//
//  TagLineViewController.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/6/12.
//

import UIKit

class TagLineViewController: UIViewController {
    
    @IBOutlet weak var tagLineView: TagLineView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagLineView.setup(maxWid: view.frame.width, tagStrs: ["asdadasdasdhorizontalasdasdadasdasdasdasdadasdasdasd", "qweqwe", "asdasda", "asdasd"])
    }
    
    @objc static func fromSB() -> TagLineViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "TagLineViewController")
        let vc = controller as! TagLineViewController
        return vc
    }
    
    
}
