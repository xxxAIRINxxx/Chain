//
//  Chain.swift
//  Chain
//
//  Created by xxxAIRINxxx on 2016/01/25.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import Foundation

public typealias Closure = (AnyObject? -> AnyObject?)

// MARK: - Chain Class

public final class Chain {
    
    private let block: Closure
    private let queue: Queue
    private let previousChain: Chain?
    
    private init(_ queue: Queue, _ previousChain: Chain? = nil, _ block: Closure) {
        self.block = block
        self.queue = queue
        self.previousChain = previousChain
    }
    
    private func runChain(next: Closure) -> Closure? {
        let _block = self.block
        let _queue = self.queue.queue
        
        if let _previousChain = self.previousChain {
            return _previousChain.runChain { result in
                dispatch_async(_queue) { next(_block(result)) }
                return nil
            }
        } else {
            dispatch_async(_queue) { next(_block(nil)) }
            return nil
        }
    }
    
    private func chain(chainingBlock: Closure) -> Chain {
        return Chain(Queue.Default, self, chainingBlock)
    }
}

// MARK: - Run Chain

extension Chain {
    
    public func run(queue: Queue? = nil, _ completion: (AnyObject? -> Void)? = nil) {
        let _queue = queue?.queue ?? self.queue.queue
        self.runChain { result in
            dispatch_async(_queue) { completion?(result) }
            return nil
        }
    }
}

// MARK: - Static Functions

extension Chain {
    
    public static func main(block: Void -> AnyObject?) -> Chain {
        return Chain(Queue.Main, nil, { _ in return block() })
    }
    
    public static func background(block: Void -> AnyObject?) -> Chain {
        return Chain(Queue.Background, nil,  { _ in return block() })
    }
    
    public static func userInteractive(block: Void -> AnyObject?) -> Chain {
        return Chain(Queue.UserInteractive, nil,  { _ in return block() })
    }
    
    public static func userInitiated(block: Void -> AnyObject?) -> Chain {
        return Chain(Queue.UserInitiated, nil,  { _ in return block() })
    }
    
    public static func utility(block: Void -> AnyObject?) -> Chain {
        return Chain(Queue.Utility, nil,  { _ in return block() })
    }
    
    public static func onDefault(block: Void -> AnyObject?) -> Chain {
        return Chain(Queue.Default, nil,  { _ in return block() })
    }
  
    public static func custom(queue: dispatch_queue_t, _ block: Void -> AnyObject?) -> Chain {
        return Chain(Queue.Custom(queue: queue), nil,  { _ in return block() })
    }
    
    public static func after(queue: Queue = Queue.Background, seconds: Double, _ block:  Void -> AnyObject?) -> Chain {
        return Chain(queue, nil) { _ in
            Chain.waitBlock(seconds)()
            return block()
        }
    }
    
    public static func wait(queue: Queue = Queue.Background, seconds: Double, _ block:  Void -> AnyObject?) -> Chain {
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
    
    public func main(block: Closure) -> Chain {
        return Chain(Queue.Main, self, block)
    }
    
    public func background(block: Closure) -> Chain {
        return Chain(Queue.Background, self, block)
    }
    
    public func userInteractive(block: Closure) -> Chain {
        return Chain(Queue.UserInteractive, self, block)
    }
    
    public func userInitiated(block: Closure) -> Chain {
        return Chain(Queue.UserInitiated, self, block)
    }
    
    public func utility(block: Closure) -> Chain {
        return Chain(Queue.Utility, self, block)
    }
    
    public func onDefault(block: Closure) -> Chain {
        return Chain(Queue.Default, self, block)
    }
    
    public func custom(queue: dispatch_queue_t, _ block: Closure) -> Chain {
        return Chain(Queue.Custom(queue: queue), self, block)
    }
    
    public func after(queue: Queue = Queue.Background, seconds: Double, _ block: Closure) -> Chain {
        return Chain(queue, self) { result in
            Chain.waitBlock(seconds)()
            return block(result)
        }
    }
    
    public func wait(queue: Queue = Queue.Background, seconds: Double) -> Chain {
        return Chain(queue, self) { result in
            Chain.waitBlock(seconds)()
            return result
        }
    }
}
