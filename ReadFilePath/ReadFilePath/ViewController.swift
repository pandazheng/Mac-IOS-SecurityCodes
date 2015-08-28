//
//  ViewController.swift
//  ReadFilePath
//
//  Created by pandazheng on 15/8/28.
//  Copyright (c) 2015年 pandazheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    func directory(dir : NSSearchPathDirectory) -> String {
        let paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(dir, NSSearchPathDomainMask.UserDomainMask, true)
        let path: String! = paths[0] as! String
        return path
    }
    
    func documentsDirectory() -> String {
        return directory(NSSearchPathDirectory.DocumentDirectory)
    }
    
    func cachesDirectory() -> String {
        return directory(NSSearchPathDirectory.CachesDirectory)
    }
    
    func tmpDirectory() -> String {
        return NSTemporaryDirectory()
    }
    
    func homeDirectory() -> String {
        return NSHomeDirectory()
    }
    
    func codeResourcesPath() -> String {
        let appPath = NSBundle.mainBundle().bundlePath
        let sigPath = appPath.stringByAppendingString("/_CodeSignature")
        return sigPath
    }
    
    func binaryPath() -> String {
        let appPath = NSBundle.mainBundle().bundlePath
        
        return appPath
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let signDirectory = codeResourcesPath()
        println(signDirectory)
        let appDirectory = binaryPath()
        println(appDirectory)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

