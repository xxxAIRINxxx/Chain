//
//  Queue.swift
//  Chain
//
//  Created by xxxAIRINxxx on 2016/01/28.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import Foundation

// MARK: - GCD Queue

public enum Queue {
    case main
    case background
    case userInteractive
    case userInitiated
    case utility
    case `default`
    case custom(queue: DispatchQueue)
    
    public var queue : DispatchQueue {
        switch self {
        case .main:
            return DispatchQueue.main
        case .background:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        case .userInteractive:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        case .userInitiated:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        case .utility:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
        case .default:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        case .custom(let queue):
            return queue
        }
    }
}
