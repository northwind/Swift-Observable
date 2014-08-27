//
//  Obserable.swift
//  obserable
//
//  Created by Norris Tong on 8/26/14.
//  Copyright (c) 2014 Norris Tong. All rights reserved.
//

import Foundation

public class Event {
    public typealias HandlerType = ( event:Event, params: AnyObject... ) -> Bool
    
    public var name:String
    public var suspend:Bool
    private var listeners:[HandlerWarpper] = []
    
    init( name:String ){
        self.name = name
        self.suspend = false
    }
    
    public func addListener( handler:HandlerType, tag:Int=0 ){
        addListener(HandlerWarpper(handler: handler, tag: tag) )
    }
    
    private func addListener( handler:HandlerWarpper ){
        listeners.append(handler)
    }
    
    public func removeListener( tag:Int ){
        let index = findListener( tag )
        if ( index == -1 ){
            return
        }
        
        var d = listeners.removeAtIndex(index)
    }
    
    public func findListener( tag:Int ) -> Int{
        for (index,wrapper) in enumerate(listeners) {
            if wrapper.tag == tag {
                return index
            }
        }
        
        return -1
    }
    
    public func hasLisener( tag:Int ) -> Bool{
        for wrapper in listeners{
            if wrapper.tag == tag {
                return true
            }
        }
        return false
    }
    
    public func clearListeners(){
        listeners.removeAll(keepCapacity: false)
    }
    
    /*
    *   if one of the listeners returns false, then don't excute next handlers
    */
    public func fire( params: [AnyObject] ){
        if suspend {
            return
        }
        
        for wrapper in listeners {
            if let h = wrapper.handler {
                var shouldContinue:Bool = true
                if ( params.count == 0 ){
                    shouldContinue = h(event: self)
                }else if ( params.count == 1 ){
                    shouldContinue = h(event: self, params:params[0])
                }else if ( params.count == 2 ){
                    shouldContinue = h(event: self, params:params[0],params[1])
                }else if ( params.count == 3 ){
                    shouldContinue = h(event: self, params:params[0],params[1],params[2])
                }else if ( params.count == 4 ){
                    shouldContinue = h(event: self, params:params[0],params[1],params[2],params[3])
                }
                
                if !shouldContinue {
                    return
                }
            }
        }
    }
}

public class HandlerWarpper {
    public typealias HandlerType = Event.HandlerType
    
    public var handler :HandlerType?
    public var tag:Int = 0
    
    init( handler:HandlerType, tag:Int ){
        self.handler = handler
        self.tag = tag
    }
}

