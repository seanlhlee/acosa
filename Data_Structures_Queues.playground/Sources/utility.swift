import Foundation

//performance check function
public func timeElapsedInSecondsWhenRunningCode(operation:()->()) -> Double {
	let startTime = CFAbsoluteTimeGetCurrent()
	operation()
	let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
	print("Time elapsed: \(timeElapsed) seconds")
	return Double(timeElapsed)
}


public struct Stack<Element> {
	private var array = [Element]()
	
	public init() {}
	
	public var isEmpty: Bool {
		return array.isEmpty
	}
	
	public var count: Int {
		return array.count
	}
	
	public mutating func push(element: Element) {
		array.append(element)
	}
	
	public mutating func pop() -> Element? {
		guard !isEmpty else { return nil } // 也可以實作fatalError("stack underflow")
		return array.removeLast()
	}
	
	public func peek() -> Element? {
		return array.last
	}
}


public struct Queue<T> {
	private var array = [T]()
	
	public init() {}
	
	public var count: Int {
		return array.count
	}
	
	public var isEmpty: Bool {
		return array.isEmpty
	}
	
	public mutating func enqueue(element: T) {
		array.append(element)
	}
	
	public mutating func dequeue() -> T? {
		if isEmpty {
			return nil
		} else {
			return array.removeFirst()
		}
	}
	
	public func peek() -> T? {
		return array.first
	}
}

public struct QueueImprove<Element> {
	private var array = [Element?]()
	private var head = 0
	
	public init() {}
	
	public var isEmpty: Bool {
		return count == 0
	}
	
	public var count: Int {
		return array.count - head
	}
	
	public mutating func enqueue(element: Element) {
		array.append(element)
	}
	
	public mutating func dequeue() -> Element? {
		guard head < array.count, let element = array[head] else { return nil }
		
		array[head] = nil
		head += 1
		
		let percentage = Double(head)/Double(array.count)
		if array.count > 50 && percentage > 0.25 {
			array.removeFirst(head)
			head = 0
		}
		
		return element
	}
	
	public func peek() -> Element? {
		guard !isEmpty else { return nil }
		return array[head]
	}
}
