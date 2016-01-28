# Chain

[![Swift 2.1](https://img.shields.io/badge/Swift-2.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![Xcode 7.1+](https://img.shields.io/badge/Xcode-7.1+-blue.svg?style=flat)](https://developer.apple.com/swift/)

Method chaining of queued closure (blocks) on GCD (Grand Central Dispatch).

Chain is inspired by [Async](https://github.com/duemunk/Async).

## Features

- Method chain of queued  closures (blocks) on GCD.
- Pass the object to the next queue
- Less code indentation.

## Exsample


### Basics

```
Chain.main {
    // called first
    // called at main thread queue
    print("start")
    return "1"
    }.background { result in
         // called second
         // called at background thread queue
         print(result)  // Optional(1)
         return "2"
    }.userInteractive { result in
         // called third
         // called at userInteractive thread queue
         print(result)  // Optional(2)
         return "3"
    }.userInitiated { result in
         // called fourth
         // called at userInitiated thread queue
         print(result)  // Optional(3)
         return "4"
    }.on { result in
         // called fifth
         // called in the same thread queue as before
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

```
let customQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)

Chain.custom(customQueue) {
    // called first
    // called at customQueue
    return nil
    }.on { result in
         // called second
         // called at customQueue
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

## Requirements

* Xcode 7.1+
* iOS 8.0+
* Swift 2.1

## Installation

### CocoaPods

Chain is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
use_frameworks!

pod "SwChain"
```

### Carthage

To integrate Chain into your Xcode project using Carthage, specify it in your Cartfile:

```
github "xxxAIRINxxx/Chain"
```

## License

MIT license. See the LICENSE file for more info.
