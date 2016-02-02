//
//  Chain.swift
//  Chain
//
//  Created by xxxAIRINxxx on 2016/01/25.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import Foundation

public typealias Closure = (AnyObject? -> AnyObject?)
public typealias StartClosure = (Void -> AnyObject?)
public typealias CompletionClosure = (AnyObject? -> Void)

// MARK: - Chain Class

public final class Chain {
    
    private let closure: Closure
    private let queue: Queue
    private let previousChain: Chain?
    
    private init(_ queue: Queue, _ previousChain: Chain? = nil, _ closure: Closure) {
        self.closure = closure
        self.queue = queue
        self.previousChain = previousChain
    }
    
    private func runChain(next: Closure) -> Closure? {
        let _closure = self.closure
        let _queue = self.queue.queue
        
        if let _previousChain = self.previousChain {
            return _previousChain.runChain { result in
                dispatch_async(_queue) { next(_closure(result)) }
                return nil
            }
        } else {
            dispatch_async(_queue) { next(_closure(nil)) }
            return nil
        }
    }
}

// MARK: - Run Chain

extension Chain {
    
    public func run(queue: Queue? = nil, _ completion: CompletionClosure? = nil) {
        let _queue = queue?.queue ?? self.queue.queue
        self.runChain { result in
            dispatch_async(_queue) { completion?(result) }
            return nil
        }
    }
}

// MARK: - Static Functions

extension Chain {
    
    public static func main(closure: StartClosure) -> Chain {
        return Chain(Queue.Main, nil, { _ in return closure() })
    }
    
    public static func background(closure: StartClosure) -> Chain {
        return Chain(Queue.Background, nil, { _ in return closure() })
    }
    
    public static func userInteractive(closure: StartClosure) -> Chain {
        return Chain(Queue.UserInteractive, nil, { _ in return closure() })
    }
    
    public static func userInitiated(closure: StartClosure) -> Chain {
        return Chain(Queue.UserInitiated, nil, { _ in return closure() })
    }
    
    public static func utility(closure: StartClosure) -> Chain {
        return Chain(Queue.Utility, nil, { _ in return closure() })
    }
    
    public static func onDefault(closure: StartClosure) -> Chain {
        return Chain(Queue.Default, nil, { _ in return closure() })
    }
  
    public static func custom(queue: dispatch_queue_t, _ closure: StartClosure) -> Chain {
        return Chain(Queue.Custom(queue: queue), nil, { _ in return closure() })
    }
    
    public static func after(queue: Queue = Queue.Background, seconds: Double, _ closure: StartClosure) -> Chain {
        return Chain(queue, nil) { _ in
            Chain.waitBlock(seconds)()
            return closure()
        }
    }
    
    public static func wait(queue: Queue = Queue.Background, seconds: Double, _ closure: StartClosure) -> Chain {
        return Chain(queue, nil) { _ in
            Chain.waitBlock(seconds)()
            return nil
        }
    }
    
    private static func waitBlock(seconds: Double) -> (Void -> Void) {
        return {
            let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
            let time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
            
            let sem = dispatch_semaphore_create(0)
            dispatch_semaphore_wait(sem, time)
        }
    }
}

// MARK: - Instance Functions

extension Chain {
    
    public func main(closure: Closure) -> Chain {
        return Chain(Queue.Main, self, closure)
    }
    
    public func background(closure: Closure) -> Chain {
        return Chain(Queue.Background, self, closure)
    }
    
    public func userInteractive(closure: Closure) -> Chain {
        return Chain(Queue.UserInteractive, self, closure)
    }
    
    public func userInitiated(closure: Closure) -> Chain {
        return Chain(Queue.UserInitiated, self, closure)
    }
    
    public func utility(closure: Closure) -> Chain {
        return Chain(Queue.Utility, self, closure)
    }
    
    public func onDefault(closure: Closure) -> Chain {
        return Chain(Queue.Default, self, closure)
    }
    
    public func custom(queue: dispatch_queue_t, _ closure: Closure) -> Chain {
        return Chain(Queue.Custom(queue: queue), self, closure)
    }
    
    public func after(queue: Queue = Queue.Background, seconds: Double, _ closure: Closure) -> Chain {
        return Chain(queue, self) { result in
            Chain.waitBlock(seconds)()
            return closure(result)
        }
    }
    
    public func wait(queue: Queue = Queue.Background, seconds: Double) -> Chain {
        return Chain(queue, self) { result in
            Chain.waitBlock(seconds)()
            return result
        }
    }
}
