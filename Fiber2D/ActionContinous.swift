//
//  ActionContinous.swift
//  Fiber2D
//
//  Created by Andrey Volodin on 03.09.16.
//  Copyright © 2016 s1ddok. All rights reserved.
//

public struct ActionContinousContainer: ActionContainer, Continous {
    
    public mutating func update(state: Float) {
        action.update(state: state)
    }
    
    public mutating  func start(with target: AnyObject?) {
        elapsed = 0
        action.start(with: target)
    }
    
    public mutating func stop() {
        action.stop()
    }
    
    internal mutating func step(dt: Time) {
        elapsed += dt
        
        self.update(state: max(0, // needed for rewind. elapsed could be negative
            min(1, elapsed / max(duration,FLT_EPSILON)) // division by 0
            )
        )
    }
    
    weak var target: AnyObject? = nil
    public var tag: Int = 0
    private(set) public var duration: Time = 0.0
    private(set) public var elapsed:  Time = 0.0

    public var isDone: Bool {
        return elapsed > duration
    }
    
    private(set) var action: ActionModel
    public init(action: ActionModel, duration: Time) {
        self.action = action
        self.duration = duration
    }
    
}

extension ActionModel {
    func continously(duration: Time) -> ActionContinousContainer {
        return ActionContinousContainer(action: self, duration: duration)
    }
}