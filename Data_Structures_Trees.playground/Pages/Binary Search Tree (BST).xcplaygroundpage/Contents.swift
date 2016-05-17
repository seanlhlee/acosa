/*:
[Previous](@previous) | [Next](@next)
***

# Binary Search Tree (BST)

A binary search tree is a special kind of [binary tree](../Binary Tree/) (a tree in which each node has at most two children) that performs insertions and deletions such that the tree is always sorted.

If you don't know what a tree is or what it is for, then please read introduction of Tree.

## "Always sorted" property

Here is an example of a valid binary search tree:

![A binary search tree](Tree1.png)

Notice how each left child is smaller than its parent node, and each right child is greater than its parent node. This is the key feature of a binary search tree.

For example, `2` is smaller than `7` so it goes on the left; `5` is greater than `2` so it goes on the right.

## Inserting new nodes

When performing an insertion, we first compare the new value to the root node. If the new value is smaller, we take the *left* branch; if greater, we take the *right* branch. We work our way down the tree this way until we find an empty spot where we can insert the new value.

Say we want to insert the new value `9`:

- We start at the root of the tree (the node with the value `7`) and compare it to the new value `9`.
- `9 > 7`, so we go down the right branch and repeat the same procedure but this time on node `10`.
- Because `9 < 10`, we go down the left branch.
- We've now arrived at a point where there are no more values to compare with. A new node for `9` is inserted at that location.

The tree now looks like this:

![After adding 9](Tree2.png)

There is always only one possible place where the new element can be inserted in the tree. Finding this place is usually pretty quick. It takes **O(h)** time, where **h** is the height of the tree.

> **Note:** The *height* of a node is the number of steps it takes to go from that node to its lowest leaf. The height of the entire tree is the distance from the root to the lowest leaf. Many of the operations on a binary search tree are expressed in terms of the tree's height.

By following this simple rule -- smaller values on the left, larger values on the right -- we keep the tree sorted in a way such that whenever we query it, we can quickly check if a value is in the tree.

## Searching the tree

To find a value in the tree, we essentially perform the same steps as with insertion:

- If the value is less than the current node, then take the left branch.
- If the value is greater than the current node, take the right branch.
- And if the value is equal to the current node, we've found it!

Like most tree operations, this is performed recursively until either we find what we're looking for, or run out of nodes to look at.

If we were looking for the value `5` in the example, it would go as follows:

![Searching the tree](Searching.png)

Thanks to the structure of the tree, searching is really fast. It runs in **O(h)** time. If you have a well-balanced tree with a million nodes, it only takes about 20 steps to find anything in this tree. (The idea is very similar to [binary search](../Binary Search) in an array.)

## Traversing the tree

Sometimes you don't want to look at just a single node, but at all of them.

There are three ways to traverse a binary tree:

1. *In-order* (or *depth-first*): first look at the left child of a node, then at the node itself, and finally at its right child.
2. *Pre-order*: first look at a node, then its left and right children.
3. *Post-order*: first look at the left and right children and process the node itself last.

Once again, this happens recursively.

If you traverse a binary search tree in-order, it looks at all the nodes as if they were sorted from low to high. For the example tree, it would print `1, 2, 5, 7, 9, 10`:

![Traversing the tree](Traversing.png)

## Deleting nodes

Removing nodes is kinda tricky. It is easy to remove a leaf node, you just disconnect it from its parent:

![Deleting a leaf node](DeleteLeaf.png)

If the node to remove has only one child, we can link that child to the parent node. So we just pull the node out:

![Deleting a node with one child](DeleteOneChild.png)

The gnarly part is when the node to remove has two children. To keep the tree properly sorted, we must replace this node by the smallest child that is larger than the node:

![Deleting a node with two children](DeleteTwoChildren.png)

This is always the leftmost descendant in the right subtree. It requires an additional search of at most **O(h)** to find this child.

Most of the other code involving binary search trees is fairly straightforward (if you understand recursion) but deleting nodes is a bit of a headscratcher.

## The code (solution 1)

So much for the theory. Let's see how we can implement a binary search tree in Swift. There are different approaches you can take. First, I'll show you how to make a class-based version but we'll also look at how to make one using enums.

Here's a first stab at a `BinarySearchTree` class:

*/
import Foundation
public class BinarySearchTree<T: Comparable>: Equatable {
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
	
	public var root: BinarySearchTree {
		return isRoot ? self : parent!.root
	}
}

public func ==<T>(lhs: BinarySearchTree<T>, rhs: BinarySearchTree<T>) -> Bool {
	guard lhs.value == rhs.value else { return false }
	guard lhs.count == rhs.count else { return false }
	return lhs.left == rhs.left && lhs.right == rhs.right
}

let tree = BinarySearchTree<Int>(value: 7)
tree.count
tree.left = BinarySearchTree<Int>(value: 2)
tree.right = BinarySearchTree<Int>(value: 10)
tree.count

/*:

This class describes just a single node, not the entire tree. It's a generic type, so the node can store any kind of data. It also has references to its `left` and `right` child nodes and a `parent` node.

Here's how you'd use it:

```swift
let tree = BinarySearchTree<Int>(value: 7)
```

The `count` property determines how many nodes are in the subtree described by this node. This doesn't just count the node's immediate children but also their children and their children's children, and so on. If this particular object is the root node, then it counts how many nodes are in the entire tree. Initially, `count = 0`.

> **Note:** Because `left`, `right`, and `parent` are optionals, we can make good use of Swift's optional chaining (`?`) and nil-coalescing operators (`??`). You could also write this sort of thing with `if let` but that is less concise.

### Inserting nodes

A tree node by itself is pretty useless, so here is how you would add new nodes to the tree:

*/
extension BinarySearchTree {
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
}

tree.insert(1)
tree.insert(5)
tree.insert(9)
tree.count
tree.left?.value
tree.right?.value
tree.left?.left?.value
tree.left?.right?.parent
tree.left?.right?.left
tree.left?.right?.right
tree.right?.left?.value
/*:

Like so many other tree operations, insertion is easiest to implement with recursion. We compare the new value to the values of the existing nodes and decide whether to add it to the left branch or the right branch.

If there is no more left or right child to look at, we create a `BinarySearchTree` object for the new node and connect it to the tree by setting its `parent` property.

> **Note:** Because the whole point of a binary search tree is to have smaller nodes on the left and larger ones on the right, you should always insert elements at the root, to make to sure this remains a valid binary tree!

To build the complete tree from the example you'd do:

```swift
let tree = BinarySearchTree<Int>(value: 7)
tree.insert(2)
tree.insert(5)
tree.insert(10)
tree.insert(9)
tree.insert(1)
```

> **Note:** For reasons that will become clear later, you should insert the numbers in a somewhat random order. If you insert them in sorted order, the tree won't have the right shape.

For convenience, let's add an init method that calls `insert()` for all the elements in an array:

*/
extension BinarySearchTree {
	public convenience init(array: [T]) {
		precondition(array.count > 0)
		self.init(value: array.first!)
		for v in array.dropFirst() {
			insert(v)
		}
	}
}

let treeX = BinarySearchTree(array: [7, 2, 5, 10, 9, 1])

/*:

Now you can simply do this:

```swift
let tree = BinarySearchTree<Int>(array: [7, 2, 5, 10, 9, 1])
```

The first value in the array becomes the root of the tree.

### Debug output

When working with somewhat complicated data structures such as this, it's useful to have human-readable debug output. Moreover, we can creat a custom function `display()` to display the tree (or node) structure for better understanding.

*/
extension BinarySearchTree: CustomStringConvertible, CustomDebugStringConvertible {
	public var description: String {
		let leftStr = left != nil ? "(\(left!.description)) <- " : ""
		let rightStr = right != nil ? " -> (\(right!.description))" : ""
		return leftStr + "\(value)" + rightStr
	}
	
	public var debugDescription: String {
		let meStr = "value: \(value)"
		let parentStr = parent != nil ? ", parent: \(parent!.value)" : ""
		let leftStr = left != nil ? ", left = [\(left!.debugDescription)]" : ""
		let rightStr = right != nil ? ", right = [\(right!.debugDescription)]" : ""
		return meStr + parentStr + leftStr + rightStr
	}
	
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
		print(preStr + "(\(value))")
		if let left = left {
			left._display(level + 1)
		}
		
		level == 0 ? __display_underline() : __display_underline(false)
	}
	
	private func __display_underline(v: Bool = true) {
		v ? print("______________________________________________") : print(terminator: "")
	}
}

tree.left?.right?.value
print(treeX)
print(treeX.debugDescription)
treeX.display()

//treeX.insert(4)
//treeX.insert(4)
//treeX.insert(4)

/*:

When you do a `print(tree)`, you should get something like this:

((1) <- 2 -> (5)) <- 7 -> ((9) <- 10)

The root node is in the middle. With some imagination, you should see that this indeed corresponds to the following tree:

![The tree](Tree2.png)

By the way, you may be wondering what happens when you insert duplicate items? We always insert those in the right branch. Try it out!

### Searching

What do we do now that we have some values in our tree? Search for them, of course! Being able to find items quickly is the entire purpose of a binary search tree. :-)

Here is the implementation of `search()`:

*/
extension BinarySearchTree {
	public func search(value: T) -> BinarySearchTree? {
		return root._search(value)
	}
	private func _search(value: T) -> BinarySearchTree? {
		guard value != self.value else { return self }
		return value < self.value ? left?._search(value) : right?._search(value)
	}
	public func contains(value: T) -> Bool {
		return search(value) != nil
	}
}

treeX.display()
treeX.search(7)
treeX.search(6)
treeX.contains(7)
treeX.contains(6)

/*:
For more convenient, we can creat a subscript method to make search a valu in a tree is easier.
*/
extension BinarySearchTree {
	public subscript(value: T) -> BinarySearchTree? {
		get {
			if search(value) == nil {
				print("value: \(value) not found!")
			}
			return search(value)
		}
	}
}

treeX[7]
treeX[6]
/*:

I hope the logic is clear: this starts at the current node (usually the root) and compares the values. If the search value is less than the node's value, we continue searching in the left branch; if the search value is greater, we dive into the right branch.

Of course, if there are no more nodes to look at -- when `left` or `right` is nil -- then we return `nil` to indicate the search value is not in the tree.

> **Note:** In Swift that's very conveniently done with optional chaining; when you write `left?.search(value)` it automatically returns nil if `left` is nil. There's no need to explicitly check for this with an `if` statement.

Searching is a recursive process but you can also implement it with a simple loop instead:

```swift
public func search(value: T) -> BinarySearchTree? {
	var node: BinarySearchTree? = self
	while case let n? = node {
		if value < n.value {
			node = n.left
		} else if value > n.value {
			node = n.right
		} else {
			return node
		}
	}
	return nil
}
```

Verify for yourself that you understand that these two implementations are equivalent. Personally, I prefer to use iterative code over recursive code but your opinion may differ. ;-)

Here's how to test searching:

```swift
tree.search(5)
tree.search(2)
tree.search(7)
tree.search(6)   // nil
```

The first three lines all return the corresponding `BinaryTreeNode` object. The last line returns `nil` because there is no node with value `6`.

> **Note:** If there are duplicate items in the tree, `search()` always returns the "highest" node. That makes sense, because we start searching from the root downwards.

### Traversal

Remember there are 3 different ways to look at all nodes in the tree? Here they are:

*/
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

tree.traverseInOrder{ print($0, terminator: " ") }  // 1 2 5 7 9 10
print()
tree.traversePreOrder{ print($0, terminator: " ") } // 7 2 1 5 10 9
print()
tree.traversePostOrder{ print($0, terminator: " ") } // 1 5 2 9 10 7
print()
/*:

They all do pretty much the same thing but in different orders. Notice once again that all the work is done recursively. Thanks to Swift's optional chaining, the calls to `traverseInOrder()` etc are ignored when there is no left or right child.

To print out all the values from the tree sorted from low to high you can write:

```swift
tree.traverseInOrder { value in print(value) }
```

This prints the following:

1
2
5
7
9
10

You can also add things like `map()` and `filter()` to the tree. For example, here's an implementation of map:

*/
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

print(tree.mapToArray{ $0 * 8 })
print(tree.map{ $0 * 8 })
tree.toArray()  // [1, 2, 5, 7, 9, 10]

/*:

This calls the `formula` closure on each node in the tree and collects the results in an array. `mapToArray()` works by traversing the tree in-order.

An extremely simple example of how to use `map()`:

```swift
public func toArray() -> [T] {
	return mapToArray{ $0 }
}
```

This turns the contents of the tree back into a sorted array. Try it out in the playground:

```swift
tree.toArray()   // [1, 2, 5, 7, 9, 10]
```

As an exercise for yourself, see if you can implement filter and reduce.

### Deleting nodes

You've seen that deleting nodes can be tricky. We can make the code much more readable by defining some helper functions.
*/
// 作廢
//extension BinarySearchTree {
//	private func reconnectParentToNode(node: BinarySearchTree?) {
//		if let parent = parent {
//			if isLeftChild {
//				parent.left = node
//			} else {
//				parent.right = node
//			}
//		}
//		node?.parent = parent
//	}
//}
/*:

Making changes to the tree involves changing a bunch of `parent` and `left` and `right` pointers. This function helps with that. It takes the parent of the current node -- that is `self` -- and connects it to another node. Usually that other node will be one of the children of `self`.

We also need a function that returns the leftmost descendent of a node:

*/
extension BinarySearchTree {
	public func minimum() -> BinarySearchTree {
		guard let next = left else { return self }
		return next.minimum()
	}
	public func maximum() -> BinarySearchTree {
		guard let next = right else { return self }
		return next.maximum()
	}
}
/*:

To see how this works, take the following tree:

![Example](MinimumMaximum.png)

For example, if we look at node `10`, its leftmost descendent is `6`. We get there by following all the `left` pointers until there are no more left children to look at. The leftmost descendent of the root node `7` is `1`. Therefore, `1` is the minimum value in the entire tree.

We won't need it for deleting, but for completeness' sake, here is the opposite of `minimum()`:

It returns the rightmost descendent of the node. We find it by following `right` pointers until we get to the end. In the above example, the rightmost descendent of node `2` is `5`. The maximum value in the entire tree is `11`, because that is the rightmost descendent of the root node `7`.

Finally, we can write the code that removes a node from the tree:
*/
// 作廢
//extension BinarySearchTree {
//	public func remove() -> BinarySearchTree? {
//		let replacement: BinarySearchTree?
//		
//		if let left = left {
//			if let right = right {
//				replacement = removeNodeWithTwoChildren(left, right)  // 1
//			} else {
//				replacement = left           // 2
//			}
//		} else if let right = right {    // 3
//			replacement = right
//		} else {
//			replacement = nil              // 4
//		}
//		
//		reconnectParentToNode(replacement)
//		
//		parent = nil
//		left = nil
//		right = nil
//		
//		return replacement
//	}
//}
/*:

It doesn't look so scary after all. ;-) There are four situations to handle:

1. This node has two children.
2. This node only has a left child. The left child replaces the node.
3. This node only has a right child. The right child replaces the node.
4. This node has no children. We just disconnect it from its parent.

First, we determine which node will replace the one we're removing and then we call `reconnectParentToNode()` to change the `left`, `right`, and `parent` pointers to make that happen. Since the current node is no longer part of the tree, we clean it up by setting its pointers to `nil`. Finally, we return the node that has replaced the removed one (or `nil` if this was a leaf node).

The only tricky situation here is `// 1` and that logic has its own helper method:

*/
// 作廢
//extension BinarySearchTree {
//	private func removeNodeWithTwoChildren(left: BinarySearchTree, _ right: BinarySearchTree) -> BinarySearchTree {
//		let successor = right.minimum()
//		successor.remove()
//		
//		successor.left = left
//		left.parent = successor
//		
//		if right !== successor {
//			successor.right = right
//			right.parent = successor
//		} else {
//			successor.right = nil
//		}
//		
//		return successor
//	}
//}

extension BinarySearchTree {
	public func remove(value: T) -> BinarySearchTree? {
		return search(value)?._remove()
	}
	
	private func _remove() -> BinarySearchTree? {

		guard let parent = parent else {
			if let replacement = hasRightChild ? right?.minimum() : left?.maximum() {
				self.value = replacement.value
				return replacement
			} else {
				return nil
			}
		}
		var replacement: BinarySearchTree? = nil
		if hasBothChildren {
			replacement = right!.minimum()
			replacement!._remove()
			replacement!.left = left
			if right !== replacement {
				replacement!.right = right
			}
		} else if let left = left {
			replacement = left
		} else if let right = right {
			replacement = right
		}
		if isLeftChild {
			parent.left = replacement
		} else {
			parent.right = replacement
		}
		_breakRelation(self)
		return replacement
	}
	
	private func _breakRelation(node: BinarySearchTree?) -> BinarySearchTree? {
		guard let node = node else { return nil }
		if node.isLeftChild {
			node.parent?.left = nil
		} else if node.isRightChild {
			node.parent?.right = nil
		}
		node.parent = nil
		return node
	}
}




tree.insert(4)
tree.insert(4)
tree.insert(4)
tree == treeX
print(tree)
tree.search(7)
tree.remove(4)
tree.remove(9)
print(tree)


print(treeX)
treeX.search(7)
treeX.search(4)?._remove()
treeX.search(9)?._remove()
print(treeX)

tree == treeX
tree._remove()
print(tree)

/*:

If the node to remove has two children, it must be replaced by the smallest child that is larger than this node's value. That always happens to be the leftmost descendent of the right child, i.e. `right.minimum()`. We take that node out of its original position in the tree and put it into the place of the node we're removing.

Try it out:

```swift
if let node2 = tree.search(2) {
	print(tree)     // before
	node2.remove()
	print(tree)     // after
}
```

First you find the node that you want to remove with `search()` and then you call `remove()` on that object. Before the removal, the tree printed like this:

((1) <- 2 -> (5)) <- 7 -> ((9) <- 10)

But after `remove()` you get:

((1) <- 5) <- 7 -> ((9) <- 10)

As you can see, node `5` has taken the place of `2`.

> **Note:** What would happen if you deleted the root node? In that case, `remove()` tells you which node has become the new root. Try it out: call `tree.remove()` and see what happens.

Like most binary search tree operations, removing a node runs in **O(h)** time, where **h** is the height of the tree.

### Depth and height

Recall that the height of a node is the distance to its lowest leaf. We can calculate that with the following function:

*/
extension BinarySearchTree {
	private var height: Int {
		return isLeaf ? 0 : 1 + max(left?.height ?? 0, right?.height ?? 0)
	}
}
tree.remove(4)
tree.remove(4)
tree.height
print(tree)

/*:

We look at the heights of the left and right branches and take the highest one. Again, this is a recursive procedure. Since this looks at all children of this node, performance is **O(n)**.

> **Note:** Swift's null-coalescing operator is used as shorthand to deal with `left` or `right` pointers that are nil. You could write this with `if let` but this is a lot more concise.

Try it out:

```swift
tree.height()  // 2
```

You can also calculate the *depth* of a node, which is the distance to the root. Here is the code:
*/
extension BinarySearchTree {
	private var depth: Int {
		return parent != nil ? parent!.depth + 1 : 0
	}
}
tree.search(1)?.depth
tree.search(12)?.depth
/*:

It steps upwards through the tree, following the `parent` pointers until we reach the root node (whose `parent` is nil). This takes **O(h)** time. Example:

```swift
if let node9 = tree.search(9) {
	node9.depth()   // returns 2
}
```

### Predecessor and successor

The binary search tree is always "sorted" but that doesn't mean that consecutive numbers are actually next to each other in the tree.

![Example](Tree2.png)

Note that you can't find the number that comes before `7` by just looking at its left child node. The left child is `2`, not `5`. Likewise for the number that comes after `7`.

The `predecessor()` function returns the node whose value precedes the current value in sorted order:

*/
extension BinarySearchTree {
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
}
tree.insert(8)
tree.insert(9)
tree.insert(20)
tree.insert(15)
tree.insert(12)
tree.insert(18)
tree.insert(13)
tree.insert(11)
tree.insert(17)
tree.insert(14)
tree.insert(19)
tree.insert(16)
tree.insert(21)
print(tree)
tree.search(16)?.predecessor()
let node21 = tree.search(21)!
let node16 = tree.search(16)!
node16 == node21
/*:

It's easy if we have a left subtree. In that case, the immediate predecessor is the maximum value in that subtree. You can verify in the above picture that `5` is indeed the maximum value in `7`'s left branch.

However, if there is no left subtree then we have to look at our parent nodes until we find a smaller value. So if we want to know what the predecessor is of node `9`, we keep going up until we find the first parent with a smaller value, which is `7`.

The code for `successor()` works the exact same way but mirrored:

Both these methods run in **O(h)** time.

> **Note:** There is a cool variation called a ["threaded" binary tree](../Threaded Binary Tree) where "unused" left and right pointers are repurposed to make direct links between predecessor and successor nodes. Very clever!

### Is the search tree valid?

If you were intent on sabotage you could turn the binary search tree into an invalid tree by calling `insert()` on a node that is not the root, like so:

```swift
if let node1 = tree.search(1) {
	node1.insert(100)
}
```

The value of the root node is `7`, so a node with value `100` is supposed to be in the tree's right branch. However, you're not inserting at the root but at a leaf node in the tree's left branch. So the new `100` node is in the wrong place in the tree!

As a result, doing `tree.search(100)` gives nil.

You can check whether a tree is a valid binary search tree with the following method:
*/
extension BinarySearchTree {
	public func isBST(minValue minValue: T, maxValue: T) -> Bool {
		guard minValue <= value && maxValue >= value else { return false }
		let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
		let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
		return leftBST && rightBST
	}
}

if let node1 = tree.search(1) {
	tree.isBST(minValue: Int.min, maxValue: Int.max)  // true
	node1.insert(100)                                 // EVIL!!!
	tree.search(100)                                  // nil
	tree.isBST(minValue: Int.min, maxValue: Int.max)  // false
}


/*:

This verifies that the left branch does indeed contain values that are less than the current node's value, and that the right branch only contains values that are larger.

Call it as follows:

```swift
if let node1 = tree.search(1) {
	tree.isBST(minValue: Int.min, maxValue: Int.max)  // true
	node1.insert(100)                                 // EVIL!!!
	tree.search(100)                                  // nil
	tree.isBST(minValue: Int.min, maxValue: Int.max)  // false
}
```
## When the tree becomes unbalanced...

A binary search tree is *balanced* when its left and right subtrees contain roughly the same number of nodes. In that case, the height of the tree is *log(n)*, where *n* is the number of nodes. That's the ideal situation.

However, if one branch is significantly longer than the other, searching becomes very slow. We end up checking way more values than we'd ideally have to. In the worst case, the height of the tree can become *n*. Such a tree acts more like a [linked list](../Linked List/) than a binary search tree, with performance degrading to **O(n)**. Not good!

One way to make the binary search tree balanced is to insert the nodes in a totally random order. On average that should balance out the tree quite nicely. But it doesn't guarantee success, nor is it always practical.

The other solution is to use a *self-balancing* binary tree. This type of data structure adjusts the tree to keep it balanced after you insert or delete nodes. See [AVL tree](@next) and **red-black tree** for examples.


## See also

[Binary Search Tree on Wikipedia](https://en.wikipedia.org/wiki/Binary_search_tree)

# 測試：
*/
let aTree = BinarySearchTree(value: 8)
aTree.isRoot
aTree.insert(4)
aTree.insert(12)
aTree.insert(2)
aTree.insert(6)
aTree.insert(10)
aTree.insert(14)
aTree.insert(1)
aTree.insert(3)
aTree.insert(5)
aTree.insert(7)
aTree.insert(9)
aTree.insert(11)
aTree.insert(13)
aTree.insert(15)
aTree.search(8)?.isRoot
print(aTree) //(((1) <- 2 -> (3)) <- 4 -> ((5) <- 6 -> (7))) <- 8 -> (((9) <- 10 -> (11)) <- 12 -> ((13) <- 14 -> (15)))
aTree._remove()
print(aTree) //(((1) <- 2 -> (3)) <- 4 -> ((5) <- 6 -> (7))) <- 9 -> ((10 -> (11)) <- 12 -> ((13) <- 14 -> (15)))
aTree.height
aTree.search(1)?.depth
aTree.search(12)?.depth
aTree.search(5)?.isRoot
aTree.search(9)?.isRoot
aTree.search(8)?.isRoot

/*:
***
[Previous](@previous) | [Next](@next)
*/
