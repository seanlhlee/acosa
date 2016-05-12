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

public class TreeNode<Key: Comparable, Payload> {
	public typealias Node = TreeNode<Key, Payload>
	
	public var payload: Payload?
	
	private var key: Key
	internal var leftChild: Node?
	internal var rightChild: Node?
	private var height: Int
	weak private var parent: Node?
	
	public init(key: Key, payload: Payload?, leftChild: Node?, rightChild: Node?, parent: Node?, height: Int) {
		self.key = key
		self.payload = payload
		self.leftChild = leftChild
		self.rightChild = rightChild
		self.parent = parent
		self.height = height
		
		self.leftChild?.parent = self
		self.rightChild?.parent = self
	}
	
	public convenience init(key: Key, payload: Payload?) {
		self.init(key: key, payload: payload, leftChild: nil, rightChild: nil, parent: nil, height: 1)
	}
	
	public convenience init(key: Key) {
		self.init(key: key, payload: nil)
	}
	
	public var isRoot: Bool {
		return parent == nil
	}
	
	public var isLeaf: Bool {
		return rightChild == nil && leftChild == nil
	}
	
	public var isLeftChild: Bool {
		return parent?.leftChild === self
	}
	
	public var isRightChild: Bool {
		return parent?.rightChild === self
	}
	
	public var hasLeftChild: Bool {
		return leftChild != nil
	}
	
	public var hasRightChild: Bool {
		return rightChild != nil
	}
	
	public var hasAnyChild: Bool {
		return leftChild != nil || rightChild != nil
	}
	
	public var hasBothChildren: Bool {
		return leftChild != nil && rightChild != nil
	}
}

// MARK: - The AVL tree

public class AVLTree<Key: Comparable, Payload> {
	public typealias Node = TreeNode<Key, Payload>
	
	private(set) public var root: Node?
	private(set) public var size = 0
	
	public init() { }
}

// MARK: - Searching

extension TreeNode {
	public func minimum() -> TreeNode? {
		if let leftChild = self.leftChild {
			return leftChild.minimum()
		}
		return self
	}
	
	public func maximum() -> TreeNode? {
		if let rightChild = self.rightChild {
			return rightChild.maximum()
		}
		return self
	}
}

extension AVLTree {
	subscript(key: Key) -> Payload? {
		get { return search(key) }
		set { insert(key, newValue) }
	}
	
	public func search(input: Key) -> Payload? {
		if let result = search(input, root) {
			return result.payload
		} else {
			return nil
		}
	}
	
	private func search(key: Key, _ node: Node?) -> Node? {
		if let node = node {
			if key == node.key {
				return node
			} else if key < node.key {
				return search(key, node.leftChild)
			} else {
				return search(key, node.rightChild)
			}
		}
		return nil
	}
}

// MARK: - Inserting new items

extension AVLTree {
	public func insert(key: Key, _ payload: Payload? = nil) {
		if let root = root {
			insert(key, payload, root)
		} else {
			root = Node(key: key, payload: payload)
		}
		size += 1
	}
	
	private func insert(input: Key, _ payload: Payload?, _ node: Node) {
		if input < node.key {
			if let child = node.leftChild {
				insert(input, payload, child)
			} else {
				let child = Node(key: input, payload: payload, leftChild: nil, rightChild: nil, parent: node, height: 1)
				node.leftChild = child
				balance(child)
			}
		} else {
			if let child = node.rightChild {
				insert(input, payload, child)
			} else {
				let child = Node(key: input, payload: payload, leftChild: nil, rightChild: nil, parent: node, height: 1)
				node.rightChild = child
				balance(child)
			}
		}
	}
}

// MARK: - Balancing tree

extension AVLTree {
	private func updateHeightUpwards(node: Node?) {
		if let node = node {
			let lHeight = node.leftChild?.height ?? 0
			let rHeight = node.rightChild?.height ?? 0
			node.height = max(lHeight, rHeight) + 1
			updateHeightUpwards(node.parent)
		}
	}
	
	private func lrDifference(node: Node?) -> Int {
		let lHeight = node?.leftChild?.height ?? 0
		let rHeight = node?.rightChild?.height ?? 0
		return lHeight - rHeight
	}
	
	private func balance(node: Node?) {
		guard let node = node else {
			return
		}
		
		updateHeightUpwards(node.leftChild)
		updateHeightUpwards(node.rightChild)
		
		var nodes = [Node?](count: 3, repeatedValue: nil)
		var subtrees = [Node?](count: 4, repeatedValue: nil)
		let nodeParent = node.parent
		
		let lrFactor = lrDifference(node)
		if lrFactor > 1 {
			// left-left or left-right
			if lrDifference(node.leftChild) > 0 {
				// left-left
				nodes[0] = node
				nodes[2] = node.leftChild
				nodes[1] = nodes[2]?.leftChild
				
				subtrees[0] = nodes[1]?.leftChild
				subtrees[1] = nodes[1]?.rightChild
				subtrees[2] = nodes[2]?.rightChild
				subtrees[3] = nodes[0]?.rightChild
			} else {
				// left-right
				nodes[0] = node
				nodes[1] = node.leftChild
				nodes[2] = nodes[1]?.rightChild
				
				subtrees[0] = nodes[1]?.leftChild
				subtrees[1] = nodes[2]?.leftChild
				subtrees[2] = nodes[2]?.rightChild
				subtrees[3] = nodes[0]?.rightChild
			}
		} else if lrFactor < -1 {
			// right-left or right-right
			if lrDifference(node.rightChild) < 0 {
				// right-right
				nodes[1] = node
				nodes[2] = node.rightChild
				nodes[0] = nodes[2]?.rightChild
				
				subtrees[0] = nodes[1]?.leftChild
				subtrees[1] = nodes[2]?.leftChild
				subtrees[2] = nodes[0]?.leftChild
				subtrees[3] = nodes[0]?.rightChild
			} else {
				// right-left
				nodes[1] = node
				nodes[0] = node.rightChild
				nodes[2] = nodes[0]?.leftChild
				
				subtrees[0] = nodes[1]?.leftChild
				subtrees[1] = nodes[2]?.leftChild
				subtrees[2] = nodes[2]?.rightChild
				subtrees[3] = nodes[0]?.rightChild
			}
		} else {
			// Don't need to balance 'node', go for parent
			balance(node.parent)
			return
		}
		
		// nodes[2] is always the head
		
		if node.isRoot {
			root = nodes[2]
			root?.parent = nil
		} else if node.isLeftChild {
			nodeParent?.leftChild = nodes[2]
			nodes[2]?.parent = nodeParent
		} else if node.isRightChild {
			nodeParent?.rightChild = nodes[2]
			nodes[2]?.parent = nodeParent
		}
		
		nodes[2]?.leftChild = nodes[1]
		nodes[1]?.parent = nodes[2]
		nodes[2]?.rightChild = nodes[0]
		nodes[0]?.parent = nodes[2]
		
		nodes[1]?.leftChild = subtrees[0]
		subtrees[0]?.parent = nodes[1]
		nodes[1]?.rightChild = subtrees[1]
		subtrees[1]?.parent = nodes[1]
		
		nodes[0]?.leftChild = subtrees[2]
		subtrees[2]?.parent = nodes[0]
		nodes[0]?.rightChild = subtrees[3]
		subtrees[3]?.parent = nodes[0]
		
		updateHeightUpwards(nodes[1])    // Update height from left
		updateHeightUpwards(nodes[0])    // Update height from right
		
		balance(nodes[2]?.parent)
	}
}

// MARK: - Displaying tree

extension AVLTree {
	private func display(node: Node?, level: Int) {
		if let node = node {
			display(node.rightChild, level: level + 1)
			print("")
			if node.isRoot {
				print("Root -> ", terminator: "")
			}
			for _ in 0..<level {
				print("        ", terminator:  "")
			}
			print("(\(node.key):\(node.height))", terminator: "")
			display(node.leftChild, level: level + 1)
		}
	}
	
	public func display(node: Node) {
		display(node, level: 0)
		print("")
	}
}

// MARK: - Delete node

extension AVLTree {
	public func delete(key: Key) {
		if size == 1 {
			root = nil
			size -= 1
		} else if let node = search(key, root) {
			delete(node)
			size -= 1
		}
	}
	
	private func delete(node: Node) {
		if node.isLeaf {
			// Just remove and balance up
			if let parent = node.parent {
				guard node.isLeftChild || node.isRightChild else {
					// just in case
					fatalError("Error: tree is invalid.")
				}
				
				if node.isLeftChild {
					parent.leftChild = nil
				} else if node.isRightChild {
					parent.rightChild = nil
				}
				
				balance(parent)
			} else {
				// at root
				root = nil
			}
		} else {
			// Handle stem cases
			if let replacement = node.leftChild?.maximum() where replacement !== node {
				node.key = replacement.key
				node.payload = replacement.payload
				delete(replacement)
			} else if let replacement = node.rightChild?.minimum() where replacement !== node {
				node.key = replacement.key
				node.payload = replacement.payload
				delete(replacement)
			}
		}
	}
}


// MARK: - Debugging

extension TreeNode: CustomDebugStringConvertible {
	public var debugDescription: String {
		var s = "key: \(key), payload: \(payload), height: \(height)"
		if let parent = parent {
			s += ", parent: \(parent.key)"
		}
		if let left = leftChild {
			s += ", left = [" + left.debugDescription + "]"
		}
		if let right = rightChild {
			s += ", right = [" + right.debugDescription + "]"
		}
		return s
	}
}

extension AVLTree: CustomDebugStringConvertible {
	public var debugDescription: String {
		if let root = root {
			return root.debugDescription
		} else {
			return "[]"
		}
	}
}

extension TreeNode: CustomStringConvertible {
	public var description: String {
		var s = ""
		if let left = leftChild {
			s += "(\(left.description)) <- "
		}
		s += "\(key)"
		if let right = rightChild {
			s += " -> (\(right.description))"
		}
		return s
	}
}

extension AVLTree: CustomStringConvertible {
	public var description: String {
		if let root = root {
			return root.description
		} else {
			return "[]"
		}
	}
}


var tree = AVLTree<Int, Int>()
tree.size
tree.insert(8)
tree.size
tree.insert(4)
tree.size
tree.insert(12)
tree.insert(2)
tree.insert(6)
tree.insert(10)
tree.insert(14)
tree.insert(1)
tree.insert(3)
tree.insert(5)
tree.insert(7)
tree.insert(9)
tree.insert(11)
tree.insert(13)
tree.insert(15)
tree.display(tree.root!)

tree[3] = 33
//print(tree.debugDescription)
tree.search(6)
tree[6] = 29
tree[6]
tree.size
tree.delete(3)
tree.delete(9)
tree.size
tree.display(tree.root!)
tree.delete(8)
tree.display(tree.root!)
tree.insert(3)
tree.insert(9)
tree.insert(8)
tree.display(tree.root!)
tree.delete(16)
tree.display(tree.root!)
tree.size







/*:
## See also

[AVL tree on Wikipedia](https://en.wikipedia.org/wiki/AVL_tree)

AVL tree was the first self-balancing binary tree. These days, the [red-black tree](../Red-Black Tree/) seems to be more popular.


***
[Previous](@previous) | [Next](@next)
*/
