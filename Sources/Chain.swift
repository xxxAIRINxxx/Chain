//
//  Chain.swift
//  Chain
//
//  Created by xxxAIRINxxx on 2016/01/25.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import Foundation

public typealias Closure = ((Any?) -> Any?)
public typealias StartClosure = (() -> Any?)
public typealias CompletionClosure = ((Any?) -> Void)

// MARK: - Chain Class

public final class Chain {
    
    fileprivate let closure: Closure
    fileprivate let queue: Queue
    fileprivate let previousChain: Chain?
    
    fileprivate init(_ queue: Queue, _ previousChain: Chain? = nil, _ closure: @escaping Closure) {
        self.closure = closure
        self.queue = queue
        self.previousChain = previousChain
    }
    
    fileprivate func runChain(_ next: @escaping Closure) -> Closure? {
        let _closure = self.closure
        let _queue = self.queue.queue
        
        if let _previousChain = self.previousChain {
            return _previousChain.runChain { result in
                _queue.async { _ = next(_closure(result)) }
                return nil
            }
        } else {
            _queue.async { _ = next(_closure(nil)) }
            return nil
        }
    }
}

// MARK: - Run Chain

extension Chain {
    
    public final func run(_ queue: Queue? = nil, _ completion: CompletionClosure? = nil) {
        let _queue = queue?.queue ?? self.queue.queue
        _ = self.runChain { result in
            _queue.async { completion?(result) }
            return nil
        }
    }
}

// MARK: - Static Functions

public extension Chain {
    
    static func main(_ closure: @escaping StartClosure) -> Chain {
        return Chain(Queue.main, nil, { _ in return closure() })
    }
    
    static func background(_ closure: @escaping StartClosure) -> Chain {
        return Chain(Queue.background, nil, { _ in return closure() })
    }
    
    static func userInteractive(_ closure: @escaping StartClosure) -> Chain {
        return Chain(Queue.userInteractive, nil, { _ in return closure() })
    }
    
    static func userInitiated(_ closure: @escaping StartClosure) -> Chain {
        return Chain(Queue.userInitiated, nil, { _ in return closure() })
    }
    
    static func utility(_ closure: @escaping StartClosure) -> Chain {
        return Chain(Queue.utility, nil, { _ in return closure() })
    }
    
    static func onDefault(_ closure: @escaping StartClosure) -> Chain {
        return Chain(Queue.default, nil, { _ in return closure() })
    }
  
    static func custom(_ queue: DispatchQueue, _ closure: @escaping StartClosure) -> Chain {
        return Chain(Queue.custom(queue: queue), nil, { _ in return closure() })
    }
    
    static func after(_ queue: Queue = Queue.background, seconds: Double, _ closure: @escaping StartClosure) -> Chain {
        return Chain(queue, nil) { _ in
            Chain.waitBlock(seconds)()
            return closure()
        }
    }
    
    static func wait(_ queue: Queue = Queue.background, seconds: Double, _ closure: StartClosure) -> Chain {
        return Chain(queue, nil) { _ in
            Chain.waitBlock(seconds)()
            return nil
        }
    }
    
    fileprivate static func waitBlock(_ seconds: Double) -> (() -> Void) {
        return {
            let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
            let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
            
            let sem = DispatchSemaphore(value: 0)
            _ = sem.wait(timeout: time)
        }
    }
}

// MARK: - Instance Functions

public extension Chain {
    
    final func main(_ closure: @escaping Closure) -> Chain {
        return Chain(Queue.main, self, closure)
    }
    
    final func background(_ closure: @escaping Closure) -> Chain {
        return Chain(Queue.background, self, closure)
    }
    
    final func userInteractive(_ closure: @escaping Closure) -> Chain {
        return Chain(Queue.userInteractive, self, closure)
    }
    
    final func userInitiated(_ closure: @escaping Closure) -> Chain {
        return Chain(Queue.userInitiated, self, closure)
    }
    
    final func utility(_ closure: @escaping Closure) -> Chain {
        return Chain(Queue.utility, self, closure)
    }
    
    final func onDefault(_ closure: @escaping Closure) -> Chain {
        return Chain(Queue.default, self, closure)
    }
    
    final func custom(_ queue: DispatchQueue, _ closure: @escaping Closure) -> Chain {
        return Chain(Queue.custom(queue: queue), self, closure)
    }
    
    final func after(_ queue: Queue = Queue.background, seconds: Double, _ closure: @escaping Closure) -> Chain {
        return Chain(queue, self) { result in
            Chain.waitBlock(seconds)()
            return closure(result)
        }
    }
    
    final func wait(_ queue: Queue = Queue.background, seconds: Double) -> Chain {
        return Chain(queue, self) { result in
            Chain.waitBlock(seconds)()
            return result
        }
    }
}
