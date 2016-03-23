# Chain

[![Swift 2.2](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![Xcode 7.3+](https://img.shields.io/badge/Xcode-7.3+-blue.svg?style=flat)](https://developer.apple.com/swift/)

Method chaining of queued closure (blocks) on GCD (Grand Central Dispatch).

Chain is inspired by [Async](https://github.com/duemunk/Async).

## Features

- Method chain of queued  closures (blocks) on GCD.
- Pass the object to the next queue
- Less code indentation.

## Exsample


### Basics

```swift
Chain.main {
    // called first
    // called at main thread queue
    print("start")
    return "1"
    }.background { result in
         // called second
         // called at background qos class thread queue
         print(result)  // Optional(1)
         return "2"
    }.userInteractive { result in
         // called third
         // called at userInteractive qos class thread queue
         print(result)  // Optional(2)
         return "3"
    }.userInitiated { result in
         // called fourth
         // called at userInitiated qos class thread queue
         print(result)  // Optional(3)
         return "4"
    }.onDefault { result in
         // called fifth
         // called at default qos class thread queue
         print(result)  // Optional(4)
         return "5"
    }.run(.Main) { result in
         // called last
         // called at main thread queue
         print(result)  // Optional(5)
         print("completion")
}
```

### Custom queue

```swift
let customQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)

Chain.custom(customQueue) {
    // called first
    // called at customQueue
    return nil
    }.onDefault { result in
         // called second
         // called at default qos class thread queue
         return result
    }.main { result in
         // called third
         // called at main thread queue
         return result
    }.custom(customQueue) { result in
         // called fourth
         // called at customQueue
         return result
    }.run()
```

### After

```swift
Chain.main {
    // called first
    // called at main thread queue
    print("start after: \(NSDate().description)")
    return "1"
    }.after(seconds: 5) { result in
        // called second
        // called to 5 seconds after the previous block
        // called at background qos class thread queue
        print(result)  // Optional(1)
        return "after 2: \(NSDate().description)"
    }.userInteractive { result in
        // called third
        // called at userInteractive qos class thread queue
        print(result)  // Optional(2)
        return "after 3: \(NSDate().description)"
    }.after(Queue.Utility, seconds: 5) { result in
        // called fourth
        // called to 5 seconds after the previous block
        // called at utility qos class thread queue
        print(result)  // Optional(3)
        return "after 4: \(NSDate().description)"
    }.run(.Main) { result in
        // called last
        // called at main thread queue
        print(result)  // Optional(4)
        print("after completion: \(NSDate().description)")
}
```

### Wait

```swift
Chain.main {
    // called first
    // called at main thread queue
    print("start wait: \(NSDate().description)")
    return "1"
    }.wait(seconds: 5).background { result in
        // called to 5 seconds after the previous block
        // called at background qos class thread queue
        print("wait 2: \(NSDate().description)")
        return result
    }.wait(seconds: 5).main { result in
        // called to 5 seconds after the previous block
        // called at main thread queue
        print("wait 3: \(NSDate().description)")
        return result
    }.run()


```

## Requirements

* iOS 8.0+
* Swift 2.2
* Xcode 7.3+

## Installation

### CocoaPods

Chain is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!

pod "SwChain"
```

### Carthage

To integrate Chain into your Xcode project using Carthage, specify it in your Cartfile:

```ruby
github "xxxAIRINxxx/Chain"
```

## License

MIT license. See the LICENSE file for more info.
