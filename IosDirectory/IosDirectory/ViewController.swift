//
//  ViewController.swift
//  IosDirectory
//
//  Created by pandazheng on 15/8/21.
//  Copyright (c) 2015年 pandazheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //沙盒目录
        let homedirectory = NSHomeDirectory()
        println(homedirectory)
        
        //APP.app
        let apppath = NSBundle.mainBundle().bundlePath
        println(apppath)
        
        //tmp目录
        let temppath = NSTemporaryDirectory()
        println(temppath)
        
        //Documents目录
        let path:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docpath: AnyObject = path[0]
        println(docpath)
        
        //Library目录
        let path2 = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let libpath: AnyObject = path2[0]
        println(libpath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

