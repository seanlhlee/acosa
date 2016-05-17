import Foundation

public struct Heap<T> {
	
	var elements = [T]()
	private var isOrderedBefore: (T, T) -> Bool
 
	public init(sort: (T, T) -> Bool) {
		self.isOrderedBefore = sort
	}
	
	public init(array: [T], sort: (T, T) -> Bool) {
		self.isOrderedBefore = sort
		buildHeap(array)
	}
	
	private mutating func buildHeap(array: [T]) {
		elements = array
		for i in (elements.count/2 - 1).stride(through: 0, by: -1) {
			shiftDown(index: i, heapSize: elements.count)
		}
	}
	
	public var isEmpty: Bool {
		return elements.isEmpty
	}
	
	public var count: Int {
		return elements.count
	}
	
	@inline(__always) func indexOfParent(i: Int) -> Int {
		return (i - 1) / 2
	}
	
	@inline(__always) func indexOfLeftChild(i: Int) -> Int {
		return 2 * i + 1
	}
	
	@inline(__always) func indexOfRightChild(i: Int) -> Int {
		return 2 * i + 2
	}
	
	public func peek() -> T? {
		return elements.first
	}
	
	public mutating func insert(value: T) {
		elements.append(value)
		shiftUp(index: elements.count - 1)
	}
	
	public mutating func insert<S : SequenceType where S.Generator.Element == T>(sequence: S) {
		for value in sequence {
			insert(value)
		}
	}
	
	public mutating func replace(index i: Int, value: T) {
		assert(isOrderedBefore(value, elements[i]))
		elements[i] = value
		shiftUp(index: i)
	}
	
	public mutating func remove() -> T? {
		if elements.isEmpty {
			return nil
		} else if elements.count == 1 {
			return elements.removeLast()
		} else {
			// Use the last node to replace the first one, then fix the heap by
			// shifting this new first node into its proper position.
			let value = elements[0]
			elements[0] = elements.removeLast()
			shiftDown()
			return value
		}
	}
	
	public mutating func removeAtIndex(i: Int) -> T? {
		let size = elements.count - 1
		if i != size {
			swap(&elements[i], &elements[size])
			shiftDown(index: i, heapSize: size)
			shiftUp(index: i)
		}
		return elements.removeLast()
	}
	
	mutating func shiftUp(index index: Int) {
		var childIndex = index
		let child = elements[childIndex]
		var parentIndex = indexOfParent(childIndex)
		
		while childIndex > 0 && isOrderedBefore(child, elements[parentIndex]) {
			elements[childIndex] = elements[parentIndex]
			childIndex = parentIndex
			parentIndex = indexOfParent(childIndex)
		}
		
		elements[childIndex] = child
	}
	
	mutating func shiftDown() {
		shiftDown(index: 0, heapSize: elements.count)
	}
	
	mutating func shiftDown(index index: Int, heapSize: Int) {
		var parentIndex = index
		
		while true {
			let leftChildIndex = indexOfLeftChild(parentIndex)
			let rightChildIndex = leftChildIndex + 1
			
			var first = parentIndex
			if leftChildIndex < heapSize && isOrderedBefore(elements[leftChildIndex], elements[first]) {
				first = leftChildIndex
			}
			if rightChildIndex < heapSize && isOrderedBefore(elements[rightChildIndex], elements[first]) {
				first = rightChildIndex
			}
			if first == parentIndex { return }
			
			swap(&elements[parentIndex], &elements[first])
			parentIndex = first
		}
	}
}