//
//  ViewController.swift
//  FmdbDemo
//
//  Created by pandazheng on 15/9/6.
//  Copyright (c) 2015年 pandazheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        test()
    }
    
    func test() {
        let documentsFolder = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        let path = documentsFolder.stringByAppendingPathComponent("test.sqlite")
        
        println(path)
        
        let database = FMDatabase(path: path)
        
        if !database.open() {
            println("Unable to open database")
            return
        }
        
        if !database.executeUpdate("create table test(x text,y text,z text)", withArgumentsInArray: nil) {
            println("create table failed: \(database.lastErrorMessage())")
        }
        
        if !database.executeUpdate("insert into test(x,y,z) values(?,?,?)", withArgumentsInArray: ["a","b","c"]) {
            println("insert 1 table failed: \(database.lastErrorMessage())")
        }
        
        if !database.executeUpdate("insert into test(x,y,z) values(?,?,?)", withArgumentsInArray: ["e","f","g"]) {
            println("insert 2 table failed: \(database.lastErrorMessage())")
        }
        
        if let rs = database.executeQuery("select x,y,z from test", withArgumentsInArray: nil) {
            while rs.next() {
                let x = rs.stringForColumn("x")
                let y = rs.stringForColumn("y")
                let z = rs.stringForColumn("z")
                println("x = \(x);y = \(y);z = \(z)")
            }
        }
        else {
            println("select failed: \(database.lastErrorMessage())")
        }
        
        database.close()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

