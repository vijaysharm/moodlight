//
//  RepeatTimer.swift
//  Moodlight
//
//  Copyright © 2020 Vijay Sharma. All rights reserved.
//

/// RepeatingTimer mimics the API of DispatchSourceTimer but in a way that prevents
/// crashes that occur from calling resume multiple times on a timer that is
/// already resumed (noted by https://github.com/SiftScience/sift-ios/issues/52
/// https://medium.com/over-engineering/a-background-repeating-timer-in-swift-412cecfd2ef9

import Foundation

class RepeatingTimer {
    private enum State {
        case suspended
        case resumed
    }
	
    var tick: (() -> Void)?
	
	private let timeInterval: TimeInterval
	private let queue: DispatchQueue
	private var state: State = .suspended

    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
			self?.queue.async { [weak self] in
				self?.tick?()
			}
        })
		
        return t
    }()
	
	init(timeInterval: TimeInterval, queue: DispatchQueue = .main) {
		self.queue = queue
        self.timeInterval = timeInterval
    }

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        tick = nil
    }

    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }

    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
