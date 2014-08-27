//
//  SwiftObservableDemoTests.swift
//  SwiftObservableDemoTests
//
//  Created by Norris Tong on 8/27/14.
//  Copyright (c) 2014 Norris Tong. All rights reserved.
//

import UIKit
import XCTest


class MyListener {
    let name:String = "mylistener"
    var excuted:String = ""
    var sum:Int = 0
    
    func method1( event:Event, params: AnyObject... ) -> Bool{
        self.excuted = "method1"
        
        sum = 0
        for param in params{
            let number = param as Int
            
            sum += number
        }
        
        return true
    }
    
    func method2( event:Event, params: AnyObject... ) -> Bool{
        self.excuted = "method2"
        
        return false
    }
    
    func recover(){
        excuted = ""
        sum = 0
    }
}

class SwiftObservableDemoTests: XCTestCase {
    var listener1:MyListener = MyListener()
    var listener2:MyListener = MyListener()
    var entity:Observable = Observable()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        entity.addEvents( "add", "remove" )
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        entity.clearEvents()
        listener1.recover()
        listener2.recover()
    }
    
    func testHandleEvents() {
        
        XCTAssert(entity.getEventCount() == 2, "Pass")
        
        entity.removeEvent("dddd")
        XCTAssert(entity.getEventCount() == 2, "Pass")
        
        entity.removeEvent("add")
        XCTAssert(entity.getEventCount() == 1, "Pass")

        XCTAssert(entity.hasEvent("add") == false, "Pass")
        XCTAssert(entity.hasEvent("remove") == true, "Pass")
        
        entity.clearEvents()
        XCTAssert(entity.getEventCount() == 0, "Pass")
    }
    
    func testHandleListeners() {
        entity.on("add", handler: listener1.method1, tag: 1)
        entity.on("add", handler: listener1.method2, tag: 2)
        entity.on("remove", handler: listener1.method1, tag: 3)
        
        entity.fireEvent("remove")
        XCTAssert( listener1.excuted == "method1" , "Pass" )
        
        entity.fireEvent("add")
        XCTAssert( listener1.excuted == "method2" , "Pass" )
        
        entity.un("add", tag: 2)
        entity.fireEvent("add")
        XCTAssert( listener1.excuted == "method1" , "Pass" )
    }
    
    func testSuspend() {
        entity.on("add", handler: listener1.method1, tag: 1)
        entity.on("add", handler: listener1.method2, tag: 2)
        
        entity.suspendEvents()
        entity.fireEvent("add")
        XCTAssert( listener1.excuted == "" , "Pass" )
        
        entity.resumeEvents()
        entity.fireEvent("add")
        XCTAssert( listener1.excuted != "" , "Pass" )
        listener1.recover()
        
        entity.suspendEvent("add")
        entity.fireEvent("add")
        XCTAssert( listener1.excuted == "" , "Pass" )
        
        entity.resumeEvent("add")
        entity.fireEvent("add")
        XCTAssert( listener1.excuted != "" , "Pass" )
    }
    
    func testParams(){
        entity.on("add", handler: listener1.method1, tag: 1)
        
        entity.fireEvent("add", params: 1,2,3,4)
        XCTAssert( listener1.sum == (1+2+3+4) , "Pass" )
        
        entity.fireEvent("add", params: 3,5,3,2)
        XCTAssert( listener1.sum == (3+5+3+2) , "Pass" )
    }
    
}
