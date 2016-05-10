import Foundation

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