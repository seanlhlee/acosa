import Foundation
// MARK: - BinarySearchTree: Binary Search Tree
/// A Binary Search Tree type content value.
public class BinarySearchTree<T: Comparable>: Equatable, CustomStringConvertible {
	public typealias Node = BinarySearchTree<T>
	
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
	
	private func getRoot() -> Node {
		guard !isRoot else { return self }
		return parent!.getRoot()
	}
	
	public var description: String {
		let leftStr = left != nil ? "(\(left!.description)) <- " : ""
		let rightStr = right != nil ? " -> (\(right!.description))" : ""
		return leftStr + "\(value)" + rightStr
	}

	// MARK: - Insert, Remove Items & Search
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
		guard let next = left else { return self }
		return next.minimum()
	}
	public func maximum() -> BinarySearchTree {
		guard let next = right else { return self }
		return next.maximum()
	}

	// MARK: - get height & depth & predecessor() & successor()
	/// height & depth
	public func height() -> Int {
		guard !isLeaf else { return 0 }
		return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
	}
	
	public func depth(value: T) -> Int? {
		return search(value)?._depth()
	}
	
	private func _depth() -> Int {
		guard let parent = parent else { return 0 }
		return parent._depth() + 1
	}
	
	/// predecessor() & successor()
	public func predecessor() -> BinarySearchTree<T>? {
		guard !hasLeftChild else { return left!.maximum() }
		var node = self
		while case let parent? = node.parent {
			guard parent.value >= value else { return parent }
			node = parent
		}
		return nil
	}
	public func successor() -> BinarySearchTree<T>? {
		guard !hasRightChild else { return right!.minimum() }
		var node = self
		while case let parent? = node.parent {
			if parent.value > value { return parent }
			node = parent
		}
		return nil
	}

	// MARK: - traverse
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

	// Mark: - map
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

// Mark: - Equatable
public func ==<T>(lhs: BinarySearchTree<T>, rhs: BinarySearchTree<T>) -> Bool {
	guard lhs.value == rhs.value else { return false }
	guard lhs.count == rhs.count else { return false }
	return lhs.left == rhs.left && lhs.right == rhs.right
}




// MARK: - TreeNode: Binary Search Tree
/// A Binary Search Tree type.
public class TreeNode<Key: Comparable, Payload>:Equatable {
	public typealias Node = TreeNode<Key, Payload>

	private var key: Key
	public var payload: Payload?
	weak private var parent: Node?
	
	internal var left: Node? {
		didSet {
			left?.parent = self
		}
	}
	internal var right: Node? {
		didSet {
			right?.parent = self
		}
	}
	private var height: Int {
		guard !isLeaf else { return 0 }
		return 1 + max(left?.height ?? 0, right?.height ?? 0)
	}
	
	public func depth(key: Key) -> Int? {
		return search(key)?._depth
	}
	
	private var _depth: Int {
		guard let parent = parent else { return 0 }
		return parent._depth + 1
	}
	
	public init(key: Key, payload: Payload?, parent: Node?, left: Node?, right: Node?) {
		self.key = key
		self.payload = payload
		self.left = left
		self.right = right
		self.parent = parent
		
		self.left?.parent = self
		self.right?.parent = self
	}
	
	public convenience init(key: Key, payload: Payload?) {
		self.init(key: key, payload: payload, parent: nil, left: nil, right: nil)
	}
	
	public convenience init(key: Key) {
		self.init(key: key, payload: nil)
	}
	
	public var isRoot: Bool {
		return parent == nil
	}
	
	public var isLeaf: Bool {
		return right == nil && left == nil
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
	
	public func isBST(minValue minValue: Key, maxValue: Key) -> Bool {
		guard minValue <= key && maxValue >= key else { return false }
		let leftBST = left?.isBST(minValue: minValue, maxValue: key) ?? true
		let rightBST = right?.isBST(minValue: key, maxValue: maxValue) ?? true
		return leftBST && rightBST
	}
	
	public func getRoot() -> Node {
		guard !isRoot else { return self }
		return parent!.getRoot()
	}
	
	public func minimum() -> TreeNode {
		guard let next = left else { return self }
		return next.minimum()
	}
	public func maximum() -> TreeNode {
		guard let next = right else { return self }
		return next.maximum()
	}

	// MARK: - Debugging
	public var debugDescription: String {
		let meStr = "key: \(key), payload: \(payload), height: \(height)"
		let parentStr = parent != nil ? ", parent: \(parent!.key)" : ""
		let leftStr = left != nil ? ", left = [\(left.debugDescription)]" : ""
		let rightStr = right != nil ? ", right = [\(right.debugDescription)]" : ""
		return meStr + parentStr + leftStr + rightStr
	}
	
	public var description: String {
		let leftStr = left != nil ? "(\(left!.description)) <- " : ""
		let rightStr = right != nil ? " -> (\(right!.description))" : ""
		return leftStr + "\(key)" + rightStr
	}
	
	// MARK: - Insert, Remove Items & Search
	/// insert
	public func insert(key: Key) {
		if key < self.key {
			if let left = left {
				left.insert(key)
			} else {
				left = TreeNode(key: key)
			}
		} else {
			if let right = right {
				right.insert(key)
			} else {
				right = TreeNode(key: key)
			}
		}
	}
	
	/// remove
	public func remove(key: Key) -> TreeNode? {
		return search(key)?._remove()
	}
	private func _remove() -> TreeNode? {
		func breakRelation(node: TreeNode?) -> TreeNode? {
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
			self.key = (replacement?.key)!
			breakRelation(replacement)
		}
		replacement?.left = left
		replacement?.right = right
		return replacement
	}
	
	public func search(key: Key) -> TreeNode? {
		guard key != self.key else { return self }
		return key < self.key ? left?.search(key) : right?.search(key)
	}
	public func contains(key: Key) -> Bool {
		return search(key) != nil
	}
	
	// MARK: - predecessor() & successor()
	public func predecessor() -> TreeNode? {
		guard !hasLeftChild else { return left!.maximum() }
		var node = self
		while case let parent? = node.parent {
			guard parent.key >= key else { return parent }
			node = parent
		}
		return nil
	}
	public func successor() -> TreeNode? {
		guard !hasRightChild else { return right!.minimum() }
		var node = self
		while case let parent? = node.parent {
			if parent.key > key { return parent }
			node = parent
		}
		return nil
	}
	
	// MARK: - traverse
	public func traverseInOrder(@noescape process: Key -> Void) {
		left?.traverseInOrder(process)
		process(key)
		right?.traverseInOrder(process)
	}
	
	public func traversePreOrder(@noescape process: Key -> Void) {
		process(key)
		left?.traversePreOrder(process)
		right?.traversePreOrder(process)
	}
	
	public func traversePostOrder(@noescape process: Key -> Void) {
		left?.traversePostOrder(process)
		right?.traversePostOrder(process)
		process(key)
	}
	
	// Mark: - map
	public func map(@noescape formula: Key -> Key) -> TreeNode {
		let me = TreeNode(key: formula(key) )
		me.left = left != nil ? left!.map(formula) : nil
		me.right = right != nil ? right!.map(formula) : nil
		return me
	}
	
	public func mapToArray(@noescape formula: Key -> Key) -> [Key] {
		let leftArr = left != nil ? left!.mapToArray(formula) : []
		let rightArr = right != nil ? right!.mapToArray(formula) : []
		return leftArr + [ formula(key) ] + rightArr
	}
	
	public func toArray() -> [Key] {
		return mapToArray{ $0 }
	}
}

// Mark: - Equatable
public func ==<Key: Comparable, Payload>(lhs: TreeNode<Key, Payload>, rhs: TreeNode<Key, Payload>) -> Bool {
	guard lhs.key == rhs.key else { return false }
	guard lhs.count == rhs.count else { return false }
	return lhs.left == rhs.left && lhs.right == rhs.right
}









