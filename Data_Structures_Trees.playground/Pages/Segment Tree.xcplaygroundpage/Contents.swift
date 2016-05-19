/*:
[Previous](@previous) | [Next](@next)
***

# Segment Tree

I'm pleased to present to you Segment Tree. It's actually one of my favorite data structures because it's very flexible and simple in realization.

Let's suppose that you have an array **a** of some type and some associative function **f**. For example, the function can be sum, multiplication, min, max, gcd, and so on.

Your task is to:

- answer a query for an interval given by **l** and **r**, i.e. perform `f(a[l], a[l+1], ..., a[r-1], a[r])`
- support replacing an item at some index `a[index] = newItem`

For example, if we have an array of numbers:

*/
var a = [ 20, 3, -1, 101, 14, 29, 5, 61, 99 ]
/*:
We want to query this array on the interval from 3 to 7 for the function "sum". That means we do the following:

101 + 14 + 29 + 5 + 61 = 210

because `101` is at index 3 in the array and `61` is at index 7. So we pass all the numbers between `101` and `61` to the sum function, which adds them all up. If we had used the "min" function, the result would have been `5` because that's the smallest number in the interval from 3 to 7.

Here's naive approach if our array's type is `Int` and **f** is just the sum of two integers:

*/
func query(array: [Int], l: Int, r: Int) -> Int {
	var sum = 0
	for i in l...r {
		sum += array[i]
	}
	return sum
}

query(a,l: 2,r: 4) // 114

/*:

The running time of this algorithm is **O(n)** in the worst case, that is when **l = 0, r = n-1** (where **n** is the number of elements in the array). And if we have **m** queries to answer we get **O(m*n)** complexity.

If we have an array with 100,000 items (**n = 10^5**) and we have to do 100 queries (**m = 100**), then our algorithm will do **10^7** units of work. Ouch, that doesn't sound very good. Let's look at how we can improve it.

Segment trees allow us to answer queries and replace items with **O(log n)** time. Isn't it magic? :sparkles:

The main idea of segment trees is simple: we precalculate some segments in our array and then we can use those without repeating calculations.

## Structure of segment tree

A segment tree is just a [binary tree](../Binary Tree/) where each node is an instance of the `SegmentTree` class:

*/
public class SegmentTree<T> {
	public typealias Node = SegmentTree<T>
	private var value: T
	private var function: (T, T) -> T
	private var leftBound: Int
	private var rightBound: Int
	private var left: Node?
	private var right: Node?
/*:
Each node has the following data:

- `leftBound` and `rightBound` describe an interval
- `leftChild` and `rightChild` are pointers to child nodes
- `value` is the result of applying the function `f(a[leftBound], a[leftBound+1], ..., a[rightBound-1], a[rightBound])`

If our array is `[1, 2, 3, 4]` and the function `f = a + b`, the segment tree looks like this:

![structure](Structure.png)

The `leftBound` and `rightBound` of each node are marked in red.

## Building a segment tree

Here's how we create a node of the segment tree:

*/
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
/*:
Because the values of `leftBound` and `rightBound` should be always within the range `0..<array.count`. It is worthy to creat a tree without defining start and end index. Here is the convenience initializer:
*/
	public convenience init(array: [T], function: (T, T) -> T) {
		self.init(array: array, leftBound: 0, rightBound: array.count - 1, function: function)
	}
}
/*:
Notice that this is a recursive method. You give it an array such as `[1, 2, 3, 4]` and it builds up the entire tree, from the root node to all the child nodes.

1. The recursion terminates if `leftBound` and `rightBound` are equal. Such a `SegmentTree` instance represents a leaf node. For the input array `[1, 2, 3, 4]`, this process will create four such leaf nodes: `1`, `2`, `3`, and `4`. We just fill in the `value` property with the number from the array.

2. However, if `rightBound` is still greater than `leftBound`, we create two child nodes. We divide the current segment into two equal segments (at least, if the length is even; if it's odd, one segment will be slightly larger).

3. Recursively build child nodes for those two segments. The left child node covers the interval **[leftBound, middle]** and the right child node covers **[middle+1, rightBound]**.

4. After having constructed our child nodes, we can calculate our own value because **f(leftBound, rightBound) = f(f(leftBound, middle), f(middle+1, rightBound))**. It's math!

Building the tree is an **O(n)** operation.

## Getting answer to query

We go through all this trouble so we can efficiently query the tree.

Here's the code:

*/
extension SegmentTree {
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
}
/*:
Again, this is a recursive method. It checks four different possibilities.

1) First, we check if the query segment is equal to the segment for which our current node is responsible. If it is we just return this node's value.

![equalSegments](EqualSegments.png)

2) Does the query segment fully lie within the right child? If so, recursively perform the query on the right child.

![rightSegment](RightSegment.png)

3) Does the query segment fully lie within the left child? If so, recursively perform the query on the left child.

![leftSegment](LeftSegment.png)

4) If none of the above, it means our query partially lies in both children so we combine the results of queries on both children.

![mixedSegment](MixedSegment.png)

This is how you can test it out in a playground:
*/

let array = [1, 2, 3, 4]

let sumSegmentTree = SegmentTree(array: array, function: +)

sumSegmentTree.queryWithLeftBound(0, rightBound: 3)  // 1 + 2 + 3 + 4 = 10
sumSegmentTree.queryWithLeftBound(1, rightBound: 2)  // 2 + 3 = 5
sumSegmentTree.queryWithLeftBound(0, rightBound: 0)  // just 1
sumSegmentTree.queryWithLeftBound(3, rightBound: 3)  // just 4
//sumSegmentTree.queryWithLeftBound(3, rightBound: 2)  // fatal error

sumSegmentTree.queryWithRange(0...3)
sumSegmentTree.queryWithRange(1...2)
sumSegmentTree.queryWithRange(0...0)
sumSegmentTree.queryWithRange(3...3)
//sumSegmentTree.queryWithRange(3...2) // fatal error
/*:

Querying the tree takes **O(log n)** time.

## Replacing items

The value of a node in the segment tree depends on the nodes below it. So if we want to change a value of a leaf node, we need to update all its parent nodes too.

Here is the code:

*/
extension SegmentTree {
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
/*:
As usual, this works with recursion. If the node is a leaf, we just change its value. If the node is not a leaf, then we recursively call `replaceItemAtIndex()` to update its children. After that, we recalculate the node's own value so that it is up-to-date again.

Replacing an item takes **O(log n)** time.

## Debugging

*/

extension SegmentTree: CustomStringConvertible, CustomDebugStringConvertible {
	// MARK: - Debugging, CustomStringConvertible, CustomDebugStringConvertible
	
	public var description: String {
		let leftStr = left != nil ? "(\(left!.description)) <- " : ""
		let rightStr = right != nil ? " -> (\(right!.description))" : ""
		return leftStr + "\(value)" + rightStr
	}
	
	public var debugDescription: String {
		let meStr = "value: \(value)"
		let leftStr = left != nil ? ", left = [\(left!.debugDescription)]" : ""
		let rightStr = right != nil ? ", right = [\(right!.debugDescription)]" : ""
		return meStr + leftStr + rightStr
	}
	
	// MARK: - Debugging, Display()
	
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
		let preStr = /*isRoot ? "Root ->\t" :*/ levelStr
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
/*:
See the playground for more examples of how to use the segment tree.

## See also

[Segment tree at PEGWiki](http://wcipeg.com/wiki/Segment_tree)

# 測試：
*/
sumSegmentTree.display()

sumSegmentTree.queryWithLeftBound(0, rightBound: 3) // 1 + 2 + 3 + 4 = 10
sumSegmentTree.queryWithLeftBound(1, rightBound: 2) // 2 + 3 = 5
sumSegmentTree.queryWithLeftBound(0, rightBound: 0) // 1 = 1

sumSegmentTree.replaceItemAtIndex(0, withItem: 2) //our array now is [2, 2, 3, 4]

sumSegmentTree.queryWithLeftBound(0, rightBound: 0) // 2 = 2
sumSegmentTree.queryWithLeftBound(0, rightBound: 1) // 2 + 2 = 4


//you can use any associative function (i.e (a+b)+c == a+(b+c)) as function for segment tree
func gcd(m: Int, _ n: Int) -> Int {
	var a = 0
	var b = max(m, n)
	var r = min(m, n)
	
	while r != 0 {
		a = b
		b = r
		r = a % b
	}
	return b
}

let gcdArray = [2, 4, 6, 3, 5]

let gcdSegmentTree = SegmentTree(array: gcdArray, function: gcd)

gcdSegmentTree.display()

gcdSegmentTree.queryWithLeftBound(0, rightBound: 1) // gcd(2, 4) = 2
gcdSegmentTree.queryWithLeftBound(2, rightBound: 3) // gcd(6, 3) = 3
gcdSegmentTree.queryWithLeftBound(1, rightBound: 3) // gcd(4, 6, 3) = 1
gcdSegmentTree.queryWithLeftBound(0, rightBound: 4) // gcd(2, 4, 6, 3, 5) = 1

gcdSegmentTree.replaceItemAtIndex(3, withItem: 10) //gcdArray now is [2, 4, 6, 10, 5]

gcdSegmentTree.queryWithLeftBound(3, rightBound: 4) // gcd(10, 5) = 5


//example of segment tree which finds minimum on given range
let minArray = [2, 4, 1, 5, 3]

let minSegmentTree = SegmentTree(array: minArray, function: min)

minSegmentTree.display()

minSegmentTree.queryWithLeftBound(0, rightBound: 4) // min(2, 4, 1, 5, 3) = 1
minSegmentTree.queryWithLeftBound(0, rightBound: 1) // min(2, 4) = 2

minSegmentTree.replaceItemAtIndex(2, withItem: 10) // minArray now is [2, 4, 10, 5, 3]

minSegmentTree.queryWithLeftBound(0, rightBound: 4) // min(2, 4, 10, 5, 3) = 2


//type of elements in array can be any type which has some associative function
let stringArray = ["a", "b", "c", "A", "B", "C"]

let stringSegmentTree = SegmentTree(array: stringArray, function: +)

stringSegmentTree.queryWithLeftBound(0, rightBound: 1) // "a"+"b" = "ab"
stringSegmentTree.queryWithLeftBound(2, rightBound: 3) // "c"+"A" = "cA"
stringSegmentTree.queryWithLeftBound(1, rightBound: 3) // "b"+"c"+"A" = "bcA"
stringSegmentTree.queryWithLeftBound(0, rightBound: 5) // "a"+"b"+"c"+"A"+"B"+"C" = "abcABC"

stringSegmentTree.replaceItemAtIndex(0, withItem: "I")
stringSegmentTree.replaceItemAtIndex(1, withItem: " like")
stringSegmentTree.replaceItemAtIndex(2, withItem: " algorithms")
stringSegmentTree.replaceItemAtIndex(3, withItem: " and")
stringSegmentTree.replaceItemAtIndex(4, withItem: " swift")
stringSegmentTree.replaceItemAtIndex(5, withItem: "!")

stringSegmentTree.queryWithLeftBound(0, rightBound: 5)

stringSegmentTree.display()


/*:
***
[Previous](@previous) | [Next](@next)
*/
