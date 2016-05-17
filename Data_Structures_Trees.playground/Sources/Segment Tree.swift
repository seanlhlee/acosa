import Foundation

public class SegmentTree<T> {
	public typealias Node = SegmentTree<T>
	private var value: T
	private var function: (T, T) -> T
	private var leftBound: Int
	private var rightBound: Int
	private var left: Node?
	private var right: Node?
	
	private init(array: [T], leftBound: Int, rightBound: Int, function: (T, T) -> T) {
		self.leftBound = leftBound
		self.rightBound = rightBound
		self.function = function
		// 1
		guard leftBound != rightBound else { value = array[leftBound]; return }
		// 2
		let middle = (leftBound + rightBound) / 2
		// 3
		self.left = SegmentTree<T>(array: array, leftBound: leftBound, rightBound: middle, function: function)
		self.right = SegmentTree<T>(array: array, leftBound: middle + 1, rightBound: rightBound, function: function)
		// 4
		self.value = function(left!.value, right!.value)
	}
	
	public convenience init(array: [T], function: (T, T) -> T) {
		self.init(array: array, leftBound: 0, rightBound: array.count - 1, function: function)
	}
	
	// MARK: - query
	
	public func queryWithLeftBound(leftBound: Int, rightBound: Int) -> T {
		// 1
		guard self.leftBound != leftBound || self.rightBound != rightBound else { return self.value }
		guard let left = left else { fatalError("left should not be nil") }
		guard let right = right else { fatalError("right should not be nil") }
		// 2
		if left.rightBound < leftBound {
			return right.queryWithLeftBound(leftBound, rightBound: rightBound)
			// 3
		} else if right.leftBound > rightBound {
			return left.queryWithLeftBound(leftBound, rightBound: rightBound)
			// 4
		} else {
			let leftResult = left.queryWithLeftBound(leftBound, rightBound: left.rightBound)
			let rightResult = right.queryWithLeftBound(right.leftBound, rightBound: rightBound)
			return function(leftResult, rightResult)
		}
	}
	
	public func queryWithRange(range: Range<Int>) -> T {
		return queryWithLeftBound(range.startIndex, rightBound: range.endIndex - 1)
	}

	// MARK: - Replace Item
	
	public func replaceItemAtIndex(index: Int, withItem item: T) {
		guard leftBound != rightBound else { self.value = item; return }
		if let left = left, right = right {
			if left.rightBound >= index {
				left.replaceItemAtIndex(index, withItem: item)
			} else {
				right.replaceItemAtIndex(index, withItem: item)
			}
			self.value = function(left.value, right.value)
		}
	}
}
