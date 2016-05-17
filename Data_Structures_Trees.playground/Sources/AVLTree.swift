import Foundation

// MARK: - The AVL tree: a self balance Binary Search Tree type
/// A self balance Binary Search Tree type

public class AVLTree<Key: Comparable, Payload> {
	
	public typealias Node = TreeNode<Key, Payload>
	
	private(set) public var root: Node?
	private	var count: Int { return root != nil ? root!.count : 0 }
	private(set) public var size = 0 {
		didSet {
			guard !isBalanced else { display(); return }
			balance()
			display()
		}
	}
	/// check a tree is a balanced tree, return `true` if the heights of the two
	/// child subtrees of any node differ by at most one.
	private var isBalanced: Bool {
		guard let root = root else { return true }
		let array = root.nodeTrasform { (node: Node) -> Bool in
			return node.isBalanced
		}
		return array.reduce(true){ $0 && $1 }
	}
	/// init a blank AVLTree (no tree node at all)
	public init() { }
	private init(subBranch: Node) {
		self.root = subBranch
	}
	
	// MARK: - Searching
	/// subscription function: get payloay by subscript[key]
	public subscript(key: Key) -> Payload? {
		get {
			return search(key)?.payload
		}
		/// need to consider the possibility of data being modified
		set {
			if let node = search(key) {
				node.payload = newValue
			} else {
				insert(key, newValue)
			}
		}
	}
	/// search and get payloay for key. return payload of node which key is `key`
	public func searchFor(key: Key) -> Payload? {
		return search(key)?.payload
	}
	/// search a node contains key, return a node in the tree whose key is `key`
	public func search(key: Key, showNotFound: Bool = true) -> Node? {
		if root?.search(key) == nil && showNotFound {
			print("key: \(key) not found!")
		}
		return root?.search(key)
	}
	/// return if a node in the tree whose key is `key`, return `true` if yes
	public func contains(key: Key) -> Bool {
		return search(key) != nil
	}
}

// MARK: - Debugging

extension AVLTree: CustomStringConvertible, CustomDebugStringConvertible {
	/// CustomStringConvertible
	public var description: String {
		guard let root = root else { return "[]" }
		return root.description
	}
	/// CustomDebugStringConvertible
	public var debugDescription: String {
		guard let root = root else { return "[]" }
		return root.debugDescription
	}
	
	// MARK: - Displaying tree
	// display a node structure
	public func display(node: Node) {
		node.display()
	}
	// display a tree structure
	public func display() {
		guard let root = root else { return }
		root.display()
	}
}

// MARK: - Inserting new items

extension AVLTree {
	/// insert a node to the tree, and keep a AVLTree
	public func insert(key: Key, _ payload: Payload? = nil) {
		// if a node in the tree and its key is `key' skip the inseart
		guard search(key, showNotFound: false) == nil else { return }
		if let root = root {
			root.insert(key, payload: payload)
		} else {
			self.root = Node(key: key, payload: payload)
		}
		size += 1
	}
}

// MARK: - Delete node

extension AVLTree {
	/// delete a node its key is `key` from the tree, and keep a AVLTree
	public func delete(key: Key) -> Node? {
		guard let node = search(key) else { return nil }
		guard size != 1 else {
			self.root = nil
			return nil
		}
		let removed = node.remove(key)
		size -= 1				// remove node in advance of changing size
		return removed
	}
}

extension AVLTree {
	private func balance() {
		guard let root = root else { return }
		guard let unBalancedNode = root.getUnbalancedNode().last else { return }
		if unBalancedNode == root {
			self.root = _balance(root)
		} else {
			let nodes = unBalancedNode.makeSubBranch()
			let mainTail = nodes.main
			let branch = _balance(nodes.branch)
			if branch.key < mainTail.key {
				mainTail.left = branch
			} else {
				mainTail.right = branch
			}
		}
	}
	
	private func _balance(branch: Node) -> Node {
		let pivot = branch.balanceFactor > 1 ? (branch.left!, true) : (branch.right!, false)
		let child = pivot.0.balanceFactor > 0 ? (pivot.0.left!,true) : (pivot.0.right!, false)
		switch (pivot.1, child.1) {
		case (true, true):
			return pivot.0.turn_right()!
		case (false, false):
			return pivot.0.turn_left()!
		case (true, false):
			branch.left = child.0.turn_left()
			return _balance(branch)
		case (false, true):
			branch.right = child.0.turn_right()
			return _balance(branch)
		}
	}
}
