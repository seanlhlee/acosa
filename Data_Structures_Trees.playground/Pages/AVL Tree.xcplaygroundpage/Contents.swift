/*:
[Previous](@previous) | [Next](@next)
***

# AVL Tree

An AVL tree is a self-balancing form of a [binary search tree](@previous), in which the height of subtrees differ at most by only 1.

A binary tree is *balanced* when its left and right subtrees contain roughly the same number of nodes. That is what makes searching the tree really fast. But if a binary search tree is unbalanced, searching can become really slow.

This is an example of an unbalanced tree:

![Unbalanced tree](Unbalanced.png)

All the children are in the left branch and none are in the right. This is essentially the same as a **linked list**. As a result, searching takes **O(n)** time instead of the much faster **O(log n)** that you'd expect from a binary search tree.

A balanced version of that tree would look like this:

![Balanced tree](Balanced.png)

One way to make the binary search tree balanced is to insert the nodes in a totally random order. But that doesn't guarantee success, nor is it always practical.

The other solution is to use a *self-balancing* binary tree. This type of data structure adjusts the tree to keep it balanced after you insert or delete nodes. The height of such a tree is guaranteed to be *log(n)* where *n* is the number nodes. On a balanced tree all insert, remove, and search operations take only **O(log n)** time. That means fast. ;-)

## Introducing the AVL tree

An AVL tree fixes any imbalances by "rotating" the tree to the left or right.

A node in an AVL tree is considered balanced if its subtrees differ in "height" by at most 1. The tree itself is balanced if all its nodes are balanced.

The *height* of a node is how many steps it takes to get to that node's lowest leaf. For example, in the following tree it takes three steps to go from A to E, so the height of A is 3. The height of B is 2, the height of C is 1, and the height of the others is 0 because they are leaf nodes.

![Node height](Height.png)

As mentioned, in an AVL tree a node is balanced if its left and right subtree have the same height. It doesn't have to be the exact same height, but the difference may not be greater than 1. These are all examples of balanced trees:

![Balanced trees](BalanceOK.png)

But the following are trees that are unbalanced, because the height of the left subtree is too large compared to the right subtree:

![Unbalanced trees](BalanceNotOK.png)

The difference between the heights of the left and right subtrees is called the *balance factor*. It is calculated as follows:

balance factor = abs(height(left subtree) - height(right subtree))

If after an insertion or deletion the balance factor becomes greater than 1, then we need to re-balance this part of the AVL tree. And that is done with rotations.

## Rotations

Each tree node keeps track of its current balance factor in a variable. After inserting a new node, we need to update the balance factor of its parent node. If that balance factor becomes greater than 1, we "rotate" part of that tree to restore the balance.

TODO: describe with pictures how these rotations work

Insertion never needs more than 2 rotations. Removal might require up to *log(n)* rotations.

## The code

Most of the code in [AVLTree.swift](AVLTree.swift) is just regular [binary search tree](../Binary Search Tree/) stuff. You'll find this in any implementation of a binary search tree. For example, searching the tree is exactly the same. The only things that an AVL tree does slightly differently are inserting and deleting the nodes.

> **Note:** If you're a bit fuzzy on the regular operations of a binary search tree, I suggest you [catch up on those first](@previous). It will make the rest of the AVL tree easier to understand.

The interesting bits are in the following methods:

- `updateBalance()`. Called after inserting a new node. This may cause the node's parent to be rebalanced.
- `rebalance()`. Figures out how to rotate the nodes to restore the balance.
- `rotateRight()` and `rotateLeft()` perform the actual rotations.

*/
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
//	private init(subBranch: Node) {
//		self.root = subBranch
//	}
	
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

/*:
## See also

[AVL tree on Wikipedia](https://en.wikipedia.org/wiki/AVL_tree)

AVL tree was the first self-balancing binary tree. These days, the [red-black tree](../Red-Black Tree/) seems to be more popular.

# 測試：
*/
var tree = AVLTree<Int, Int>()

tree.insert(7)
tree.insert(12)
tree.insert(3)
tree.insert(5)
tree.insert(2)
tree.insert(6)
tree.insert(1)
tree.insert(13)
tree.insert(8)
tree.insert(10)
tree.insert(9)
tree.insert(15)
tree.insert(11)
tree.insert(14)
tree.insert(4)

tree.delete(14)
tree.delete(13)
tree.delete(12)

tree.root?.isBST(minValue: 0, maxValue: 20)

var aTree = AVLTree<Int, String>()


aTree.insert(7)
aTree.insert(12)
aTree.insert(3)
aTree.insert(5)
aTree.insert(2)
aTree.insert(6)

aTree.insert(1)
aTree.insert(13)
aTree.insert(8)
aTree.insert(10)

aTree.insert(9)

aTree.insert(15)
aTree.insert(11)
aTree.insert(14)

aTree.insert(4)

//
//
aTree.delete(14)
aTree.delete(13)
aTree.delete(12)

aTree.root?.isBST(minValue: 0, maxValue: 20)

aTree.delete(4)
aTree.delete(3)
aTree.delete(5)
aTree.delete(10)
aTree.delete(11)
aTree.delete(8)
aTree.delete(15)
aTree.delete(9)
aTree.delete(6)
aTree.delete(1)
aTree.delete(2)
aTree.delete(7)
aTree.insert(8, "eight")
aTree.insert(4, "four")
aTree.insert(12, "twelve")
aTree.insert(2, "two")
aTree.insert(6, "six")
aTree.insert(10, "ten")
aTree.insert(14, "fourteen")
aTree.insert(1, "one")
aTree.insert(3, "three")
aTree.insert(5, "five")
aTree.insert(7, "seven")
aTree.insert(9, "nine")
aTree.insert(11, "element")
aTree.insert(13, "thirteen")
aTree.insert(15, "fifteen")

aTree.root?.keys
let payloads: [String] = (aTree.root?.payloads.flatMap{ x in
	if let s = x {
		return s
	}
	return ""
	})!

aTree.delete(14)
aTree.delete(13)
aTree.delete(12)

aTree.search(4)?.display()

let bTree = AVLTree<UInt32, Int>()

for i in 0..<1000 {
	let x = arc4random_uniform(100)
	let y = Int(x)
	bTree.insert(x, y)
}

for i in 0..<100 {
	let x = arc4random_uniform(100)
	bTree.delete(x)
}
bTree.count
bTree.isBalanced

/*:
***
[Previous](@previous) | [Next](@next)
*/
