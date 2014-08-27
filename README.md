Swift-Observable
================

Simple Observable for Swift. It is different from KVO, you can simply add/remove/trigger custom events.

### Example
```swift
//1. create an Observable entity
var entity = Observable()

//2. add some custom events
//   you need to add event before adding handler
entity.addEvents( "add", "remove" ) 

//3. create a listener
class MyListener {

    func onAddEvent( event:Event, params: AnyObject... ) -> Bool{
        println( event.name )   // add
        return true
    }

    func onRemoveEvent( event:Event, params: AnyObject... ) -> Bool{
        return false
    }
}
var listener = MyListener()

//4. add handler
entity.on( "add", listener.onAddEvent )

//5. trigger an event
entity.fireEvent( "add" )
entity.fireEvent( "add", params: 2, bool, "a" ) //add special data for this event
```

### API

- on(eventName:String, handler:HandlerType, tag:Int=0)
- un(eventName:String, tag:Int)
- addEvents(eventNames: String...)
- addEvent(eventName:String)
- removeEvent(eventName:String)
- clearEvents()
- suspendEvent(eventName:String)
- resumeEvent(eventName:String)
- suspendEvents()
- resumeEvents()
- fireEvent(eventName:String, params: AnyObject...)

### Installation
Just copy all the swift file in folder SwiftObservable into your project.


### Stuff
As the swift is still in beta, it doesn't seem swifty enough, so some feature can't support now, but going to add in the feature.

- EventProtocol
- Customize Event
- Remove Tag
- Optimize Variadic Parameters 



Hope this library will help you.


