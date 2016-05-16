import Foundation

// MARK: - TreeNode: Binary Search Tree
/// A Binary Search Tree type.
public class TreeNode<Key: Comparable, Payload>:Equatable, CustomStringConvertible, CustomDebugStringConvertible {
	
	public typealias Node = TreeNode<Key, Payload>
	
	public var key: Key
	public var payload: Payload?
	
	weak public var parent: Node?
	/// if left has been set, set the parent of `left` as well.
	public var left: Node? { didSet { left?.parent = self } }
	/// if right has been set, set the parent of `right` as well.
	public var right: Node? { didSet { right?.parent = self } }
	/// return maximum height of node's sub-branches
	private var height: Int {
		return isLeaf ? 0 : 1 + max(left?.height ?? 0, right?.height ?? 0)
	}
	/// return how far to reach tree root. `root.depth = 0`
	private var depth: Int {
		return parent != nil ? parent!.depth + 1 : 0
	}
	
	public init(key: Key, payload: Payload?, parent: Node?, left: Node?, right: Node?) {
		self.key = key
		self.payload = payload
		self.parent = parent
		self.left = left
		self.right = right
		
		self.left?.parent = self
		self.right?.parent = self
	}
	
	public convenience init(key: Key, payload: Payload?) {
		self.init(key: key, payload: payload, parent: nil, left: nil, right: nil)
	}
	
	public convenience init(key: Key) {
		self.init(key: key, payload: nil)
	}
	
	private var isRoot: Bool {
		return parent == nil
	}
	
	private var isLeaf: Bool {
		return right == nil && left == nil
	}
	
	private var isLeftChild: Bool {
		return parent?.left === self
	}
	
	private var isRightChild: Bool {
		return parent?.right === self
	}
	
	private var hasLeftChild: Bool {
		return left != nil
	}
	
	private var hasRightChild: Bool {
		return right != nil
	}
	
	private var hasAnyChild: Bool {
		return hasLeftChild || hasRightChild
	}
	
	private var hasBothChildren: Bool {
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
	
	public var isBalanced: Bool {
		return abs(balanceFactor) < 2
	}
	
	public var balanceFactor: Int {
		return (left?.height ?? -1) - (right?.height ?? -1)
	}
	
	private var root: Node {
		return isRoot ? self : parent!.root
	}
	
	private func minimum() -> Node {
		return hasLeftChild ? left!.minimum() : self
	}
	private func maximum() -> Node {
		return hasRightChild ? right!.maximum() : self
	}
	
	// MARK: - Debugging
	public var debugDescription: String {
		let meStr = "key: \(key), payload: \(payload), height: \(height)"
		let parentStr = parent != nil ? ", parent: \(parent!.key)" : ""
		let leftStr = left != nil ? ", left = [\(left!.debugDescription)]" : ""
		let rightStr = right != nil ? ", right = [\(right!.debugDescription)]" : ""
		return meStr + parentStr + leftStr + rightStr
	}
	
	public var description: String {
		let leftStr = left != nil ? "(\(left!.description)) <- " : ""
		let rightStr = right != nil ? " -> (\(right!.description))" : ""
		return leftStr + "\(key)" + rightStr
	}
	
	// MARK: - Displaying tree
	/// public displaying structure of a tree or it's branch.
	public func display() {
		self._display(0)
	}
	
	private func _display(level: Int) {
		level == 0 ? __display_underline() : __display_underline(false)
		
		if let right = right {
			right._display(level + 1)
		}
		var levelStr = "\t\t"
		for _ in 0..<level {
			levelStr += "\t\t"
		}
		let preStr = isRoot ? "Root ->\t" : levelStr
		print(preStr + "(\(key))")
		if let left = left {
			left._display(level + 1)
		}
		
		level == 0 ? __display_underline() : __display_underline(false)
	}
	
	private func __display_underline(v: Bool = true) {
		v ? print("______________________________________________") : print(terminator: "")
	}
	
	// MARK: - Insert, Remove Items & Search
	/// insert a node to a tree.
	/// defalt: insert a node by providing `key` value without assigning corresponding payload.
	/// `insert(key, payload)`, insert a node with providing both `key` and corresponding `payload` values.
	public func insert(key: Key, payload: Payload? = nil) {
		if key < self.key {
			if let left = left {
				left.insert(key, payload: payload)
			} else {
				left = TreeNode(key: key, payload: payload)
			}
		} else {
			if let right = right {
				right.insert(key, payload: payload)
			} else {
				right = TreeNode(key: key, payload: payload)
			}
		}
	}
	
	/// remove a node from tree.
	public func remove(key: Key) -> Node? {
		return search(key)?._remove()
	}
	
	private func _remove() -> Node? {
		// Root? true ==> remove by replace values of predecessor() or successor()
		// case: self is root
		guard let parent = parent else {
			if let replacement = hasRightChild ? right?.minimum() : left?.maximum() {
				self.key = replacement.key
				self.payload = replacement.payload
				replacement._remove()
				return replacement
			} else {
				return nil		// remove fail: root is the only remaining element
			}
		}
		// case: self is not root
		// set replacement base on numbers of chiidren
		// prepare replancement for connect to main tree
		var replacement: Node? = nil		// no child, remove directly
		if hasBothChildren {				// both children case
			replacement = right!.minimum()	// set replacement => successor()
			replacement!._remove()			// remove replacement -> indepandent node
			replacement!.left = left		// connect left to replancement
			if right !== replacement {		// connect right to replancement if right is not successor()
				replacement!.right = right
			}
		} else if let left = left {			// with one child
			replacement = left
		} else if let right = right {
			replacement = right
		}
		// connect replacement to parent and delete self from tree
		if isLeftChild {
			parent.left = replacement
		} else {
			parent.right = replacement
		}
		_breakRelation(self)
		return replacement
	}
	
	// MARK: - Searching
	public subscript(key: Key) -> Payload? {
		get {
			if search(key) == nil {
				print("key: \(key) not found!")
			}
			return search(key)?.payload
		}
		set {
			if let node = search(key) {
				node.payload = newValue
			} else {
				insert(key, payload: newValue)
			}
		}
	}
	
	public func search(key: Key) -> Node? {
		return root._search(key)
	}
	
	private func _search(key: Key) -> Node? {
		guard key != self.key else { return self }
		return key < self.key ? left?._search(key) : right?._search(key)
	}
	
	public func contains(key: Key) -> Bool {
		return search(key) != nil
	}
	
	// MARK: - predecessor() & successor()
	public func predecessor() -> Node? {
		guard !hasLeftChild else { return left!.maximum() }
		var node = self
		while case let parent? = node.parent {
			guard parent.key >= key else { return parent }
			node = parent
		}
		return nil
	}
	public func successor() -> Node? {
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
	public func map(@noescape formula: Key -> Key) -> Node {
		let me = TreeNode(key: formula(key) )
		me.left = left != nil ? left!.map(formula) : nil
		me.right = right != nil ? right!.map(formula) : nil
		return me
	}
	
	public func flatMap<T: Comparable>(@noescape formula: Key -> T) -> TreeNode<T, Payload> {
		let me = TreeNode<T, Payload>(key: formula(key) )
		me.left = left != nil ? left!.flatMap(formula) : nil
		me.right = right != nil ? right!.flatMap(formula) : nil
		return me
	}
	
	public func mapToArray<T: Comparable>(@noescape formula: Key -> T) -> [T] {
		let leftArr = left != nil ? left!.mapToArray(formula) : []
		let rightArr = right != nil ? right!.mapToArray(formula) : []
		return leftArr + [ formula(key) ] + rightArr
	}
	
	public func nodeTrasform<T>(@noescape formula: Node -> T) -> [T] {
		let leftArr = left != nil ? left!.nodeTrasform(formula) : []
		let rightArr = right != nil ? right!.nodeTrasform(formula) : []
		return leftArr + [ formula(self) ] + rightArr
	}
	
	public func reduce<T: Comparable>(initial: T, @noescape formula: Key -> T, @noescape combine: (T, Array<T>.Generator.Element) -> T) -> T {
		return mapToArray(formula).reduce(initial, combine: combine)
	}
	
	public var keys: [Key] {
		return mapToArray{ $0 }
	}
	
	public var payloads: [Payload?] {
		return nodeTrasform{ $0.payload }
	}
}

// Mark: - Equatable
public func ==<Key: Comparable, Payload>(lhs: TreeNode<Key, Payload>, rhs: TreeNode<Key, Payload>) -> Bool {
	guard lhs.key == rhs.key else { return false }
	guard lhs.count == rhs.count else { return false }
	return lhs.left == rhs.left && lhs.right == rhs.right
}

extension TreeNode {
	public func makeSubBranch() -> (main:Node, branch: Node) {
		guard let parent = parent else { fatalError("root can't make sub") }
		return (parent, _breakRelation(self)!)
	}
	
	/// break connection to parent but still keep subtrees
	private func _breakRelation(node: Node?) -> Node? {
		guard let node = node else { return nil }
		if node.isLeftChild {
			node.parent?.left = nil
		} else if node.isRightChild {
			node.parent?.right = nil
		}
		node.parent = nil
		return node
	}
	public func _turn_right() -> Node? {
		guard let parent = parent else { return nil }
		// 1. break pivot's right breanch
		let sub_x = _breakRelation(right)
		// 2. break pivot's connection to parent
		let sub_y = _breakRelation(self)!
		// 3. connect sub_x to parent's left
		parent.left = sub_x
		// 4. connect parent to be pivot's right
		sub_y.right = parent
		return sub_y
	}
	
	public func _turn_left() -> Node? {
		guard let parent = parent else { return nil }
		// 1. break pivot's left breanch
		let sub_x = _breakRelation(left)
		// 2. break pivot's connection to parent
		let sub_y = _breakRelation(self)!
		// 3. connect sub_x to parent's right
		parent.right = sub_x
		// 4. connect parent to be pivot's left
		sub_y.left = parent
		return sub_y
	}
	public func getUnbalancedNode() -> [TreeNode] {
		let node = !self.isBalanced ? [self] : []
		let leftArr = left != nil ? left!.getUnbalancedNode() : []
		let rightArr = right != nil ? right!.getUnbalancedNode() : []
		return node + leftArr + rightArr
	}
}

