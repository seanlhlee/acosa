import Foundation
/// BinarySearchTree
public class BinarySearchTree<T: Comparable>: Equatable, CustomStringConvertible {
	
	private(set) public var value: T
	private(set) public var parent: BinarySearchTree?
	private(set) public var left: BinarySearchTree? {
		didSet {
			left?.parent = self
		}
	}
	private(set) public var right: BinarySearchTree? {
		didSet {
			right?.parent = self
		}
	}
	
	public init(value: T) {
		self.value = value
	}
	
	/// convenience init from an array
	public convenience init(array: [T]) {
		precondition(array.count > 0)
		self.init(value: array.first!)
		for v in array.dropFirst() {
			insert(v)
		}
	}
	
	public var isRoot: Bool {
		return parent == nil
	}
	
	public var isLeaf: Bool {
		return left == nil && right == nil
	}
	
	public var isLeftChild: Bool {
		return parent?.left === self
	}
	
	public var isRightChild: Bool {
		return parent?.right === self
	}
	
	public var hasLeftChild: Bool {
		return left != nil
	}
	
	public var hasRightChild: Bool {
		return right != nil
	}
	
	public var hasAnyChild: Bool {
		return hasLeftChild || hasRightChild
	}
	
	public var hasBothChildren: Bool {
		return hasLeftChild && hasRightChild
	}
	
	public var count: Int {
		return (left?.count ?? 0) + 1 + (right?.count ?? 0)
	}
	
	public func isBST(minValue minValue: T, maxValue: T) -> Bool {
		guard minValue <= value && maxValue >= value else { return false }
		let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
		let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
		return leftBST && rightBST
	}
	
	public var description: String {
		let leftStr = left != nil ? "(\(left!.description)) <- " : ""
		let rightStr = right != nil ? " -> (\(right!.description))" : ""
		return leftStr + "\(value)" + rightStr
	}
}

/// Confirm to Equatable
public func ==<T>(lhs: BinarySearchTree<T>, rhs: BinarySearchTree<T>) -> Bool {
	guard lhs.value == rhs.value else { return false }
	guard lhs.count == rhs.count else { return false }
	return lhs.left == rhs.left && lhs.right == rhs.right
}

// MARK: - Insert, Remove Items & Search
extension BinarySearchTree {
	/// insert
	public func insert(value: T) {
		if value < self.value {
			if let left = left {
				left.insert(value)
			} else {
				left = BinarySearchTree(value: value)
			}
		} else {
			if let right = right {
				right.insert(value)
			} else {
				right = BinarySearchTree(value: value)
			}
		}
	}
	
	/// remove
	public func remove(value: T) -> BinarySearchTree? {
		return search(value)?._remove()
	}
	private func _remove() -> BinarySearchTree? {
		func breakRelation(node: BinarySearchTree?) -> BinarySearchTree? {
			guard let node = node else { return nil }
			if node.isLeftChild {
				node.parent?.left = nil
			} else if node.isRightChild {
				node.parent?.right = nil
			}
			node.parent = nil
			return node
		}
		let replacement = right?.minimum()
		if isLeftChild {
			parent?.left = breakRelation(replacement)
			
		} else if isRightChild {
			parent?.right = breakRelation(replacement)
		} else {
			self.value = (replacement?.value)!
			breakRelation(replacement)
		}
		replacement?.left = left
		replacement?.right = right
		return replacement
	}

	public func search(value: T) -> BinarySearchTree? {
		guard value != self.value else { return self }
		return value < self.value ? left?.search(value) : right?.search(value)
	}
	public func contains(value: T) -> Bool {
		return search(value) != nil
	}
	public func minimum() -> BinarySearchTree {
		var node = self
		while case let next? = node.left {
			node = next
		}
		return node
	}
	public func maximum() -> BinarySearchTree {
		var node = self
		while case let next? = node.right {
			node = next
		}
		return node
	}
}

/// get height & depth & predecessor() & successor()
extension BinarySearchTree {
	/// height & depth
	public func height() -> Int {
		guard !isLeaf else { return 0 }
		return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
	}
	
	public func depth(value: T) -> Int? {
		return search(value)?._depth()
	}
	private func _depth() -> Int {
		var node = self
		var edges = 0
		while case let parent? = node.parent {
			node = parent
			edges += 1
		}
		return edges
	}
	/// predecessor() & successor()
	public func predecessor() -> BinarySearchTree<T>? {
		if let left = left {
			return left.maximum()
		} else {
			var node = self
			while case let parent? = node.parent {
				if parent.value < value { return parent }
				node = parent
			}
			return nil
		}
	}
	
	public func successor() -> BinarySearchTree<T>? {
		if let right = right {
			return right.minimum()
		} else {
			var node = self
			while case let parent? = node.parent {
				if parent.value > value { return parent }
				node = parent
			}
			return nil
		}
	}
}

// MARK: - traverse
extension BinarySearchTree {
	public func traverseInOrder(@noescape process: T -> Void) {
		left?.traverseInOrder(process)
		process(value)
		right?.traverseInOrder(process)
	}
	
	public func traversePreOrder(@noescape process: T -> Void) {
		process(value)
		left?.traversePreOrder(process)
		right?.traversePreOrder(process)
	}
	
	public func traversePostOrder(@noescape process: T -> Void) {
		left?.traversePostOrder(process)
		right?.traversePostOrder(process)
		process(value)
	}
}

// map
extension BinarySearchTree {
	public func map(@noescape formula: T -> T) -> BinarySearchTree {
		let me = BinarySearchTree(value: formula(value) )
		me.left = left != nil ? left!.map(formula) : nil
		me.right = right != nil ? right!.map(formula) : nil
		return me
	}
	
	public func mapToArray(@noescape formula: T -> T) -> [T] {
		let leftArr = left != nil ? left!.mapToArray(formula) : []
		let rightArr = right != nil ? right!.mapToArray(formula) : []
		return leftArr + [ formula(value) ] + rightArr
	}
	
	public func toArray() -> [T] {
		return mapToArray{ $0 }
	}
}













