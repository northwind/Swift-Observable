//
//  Observable.swift
//  obserable
//
//  Created by Norris Tong on 8/26/14.
//  Copyright (c) 2014 Norris Tong. All rights reserved.
//

import Foundation

public class Observable {
    public typealias HandlerType = Event.HandlerType
    
    public var eventsSuspended:Bool = false
    private var events:[ String : Event ] = Dictionary<String, Event>()
    
    init(){
        
    }
    
    public func on(eventName:String, handler:HandlerType, tag:Int=0){
        var event = getEvent( eventName )
        if ( event == nil ){
            return
        }
        
        event!.addListener(handler, tag: tag)
    }
    
    public func un(eventName:String, tag:Int){
        var event = getEvent( eventName )
        if ( event == nil ){
            return
        }
        
        event!.removeListener(tag)
    }
    
    /*
     * handle event with name
     */
    public func addEvents(eventNames: String...){
        for eventName in eventNames {
            addEvent(eventName)
        }
    }
    
    public func addEvent(eventName:String){
        if ( hasEvent(eventName) ){
            return
        }
        
        let event = Event( name: eventName )
        events[ eventName ] = event
    }
    
    public func removeEvent(eventName:String){
        events.removeValueForKey( eventName )
    }
    
    public func hasEvent(eventName:String) -> Bool{
        return events[ eventName ] !== nil
    }
    
    private func getEvent(eventName:String) -> Event?{
        return events[ eventName ]
    }
    
    public func getEventCount() -> Int{
        return events.count
    }
    
    public func clearEvents(){
        events.removeAll(keepCapacity: false)
    }
    
    /*
     * these functions support suspend feature
     */
    public func suspendEvent(eventName:String){
        var event = getEvent( eventName )
        if ( event == nil ){
            return
        }
        
        event!.suspend = true
    }
    
    public func resumeEvent(eventName:String){
        var event = getEvent( eventName )
        if ( event == nil ){
            return
        }
        
        event!.suspend = false
    }
    
    public func suspendEvents(){
        eventsSuspended = true
    }
    
    public func resumeEvents(){
        eventsSuspended = false
    }
    
    public func fireEvent(eventName:String, params: AnyObject...){
        if eventsSuspended {
            return
        }
        
        var event = getEvent( eventName )
        if ( event == nil ){
            return
        }
        
        //do the real job
        event!.fire( params )
    }
}
