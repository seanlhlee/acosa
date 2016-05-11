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

## The code (solution 2)

We've implemented the binary tree node as a class but you can also use an enum.

The difference is reference semantics versus value semantics. Making a change to the class-based tree will update that same instance in memory. But the enum-based tree is immutable -- any insertions or deletions will give you an entirely new copy of the tree. Which one is best totally depends on what you want to use it for.

Here's how you'd make a binary search tree using an enum:

*/
public enum BinarySearchTree<T: Comparable> {
	case Empty
	case Leaf(T)
	indirect case Node(BinarySearchTree, T, BinarySearchTree)
}
/*:

The enum has three cases:

- `Empty` to mark the end of a branch (the class-based version used `nil` references for this).
- `Leaf` for a leaf node that has no children.
- `Node` for a node that has one or two children. This is marked `indirect` so that it can hold `BinarySearchTree` values. Without `indirect` you can't make recursive enums.

> **Note:** The nodes in this binary tree don't have a reference to their parent node. It's not a major impediment but it will make certain operations slightly more cumbersome to implement.

As usual, we'll implement most functionality recursively. We'll treat each case of the enum slightly differently. For example, this is how you could calculate the number of nodes in the tree and the height of the tree:

*/
extension BinarySearchTree {
	public var count: Int {
		switch self {
		case .Empty: return 0
		case .Leaf: return 1
		case let .Node(left, _, right): return left.count + 1 + right.count
		}
	}
	
	public var height: Int {
		switch self {
		case .Empty: return 0
		case .Leaf: return 1
		case let .Node(left, _, right): return 1 + max(left.height, right.height)
		}
	}
}
/*:

Inserting new nodes looks like this:
*/
extension BinarySearchTree {
	public mutating func insert(newValue: T) -> BinarySearchTree {
		switch self {
		case .Empty:
			self = .Leaf(newValue)
			
		case .Leaf(let value):
			if newValue < value {
				self = .Node(.Leaf(newValue), value, .Empty)
			} else {
				self = .Node(.Empty, value, .Leaf(newValue))
			}
			
		case .Node(var left, let value, var right):
			if newValue < value {
				self = .Node(left.insert(newValue), value, right)
			} else {
				self = .Node(left, value, right.insert(newValue))
			}
		}
		return self
	}
}
var tree = BinarySearchTree.Leaf(7)
tree.insert(2)
tree.insert(5)
tree.insert(10)
tree.insert(9)
tree.insert(1)
tree
/*:

Notice that each time you insert something, you get back a completely new tree object. That's why you need to assign the result back to the `tree` variable.

Here is the all-important search function:

*/
extension BinarySearchTree {
	public func search(x: T) -> BinarySearchTree? {
		switch self {
		case .Empty:
			return nil
		case .Leaf(let y):
			return (x == y) ? self : nil
		case let .Node(left, y, right):
			if x < y {
				return left.search(x)
			} else if y < x {
				return right.search(x)
			} else {
				return self
			}
		}
	}
}

tree.search(10)
tree.search(1)
tree.search(11)   // nil

/*:
To print the tree for debug purposes you can use this method:

*/
extension BinarySearchTree: CustomDebugStringConvertible {
	public var debugDescription: String {
		switch self {
		case .Empty: return "."
		case .Leaf(let value): return "\(value)"
		case .Node(let left, let value, let right):
			return "(\(left.debugDescription) <- \(value) -> \(right.debugDescription))"
		}
	}
}
print(tree)

/*

When you do `print(tree)` it will look something like this:

((1 <- 2 -> 5) <- 7 -> (9 <- 10 -> .))

The root node is in the middle; a dot means there is no child at that position.

## When the tree becomes unbalanced...

A binary search tree is *balanced* when its left and right subtrees contain roughly the same number of nodes. In that case, the height of the tree is *log(n)*, where *n* is the number of nodes. That's the ideal situation.

However, if one branch is significantly longer than the other, searching becomes very slow. We end up checking way more values than we'd ideally have to. In the worst case, the height of the tree can become *n*. Such a tree acts more like a [linked list](../Linked List/) than a binary search tree, with performance degrading to **O(n)**. Not good!

One way to make the binary search tree balanced is to insert the nodes in a totally random order. On average that should balance out the tree quite nicely. But it doesn't guarantee success, nor is it always practical.

The other solution is to use a *self-balancing* binary tree. This type of data structure adjusts the tree to keep it balanced after you insert or delete nodes. See [AVL tree](../AVL Tree) and [red-black tree](../Red-Black Tree) for examples.

## See also

[Binary Search Tree on Wikipedia](https://en.wikipedia.org/wiki/Binary_search_tree)



***
[Previous](@previous) | [Next](@next)
*/
