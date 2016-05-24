/*:
[Previous](@previous) | [Next](@next)
***

# 優先佇列（Priority Queue）

優先佇列（Priority Queue）是一種最重要的元素總是排在最前面的[佇列（queue）](Queue)，又分為最大優先佇列（*max-priority* Queue）與最小優先佇列（*min-priority* Queue）兩種。

## 為什麼需要？

優先佇列對於設計經常需要自大量的數據中提取最大或最小或是自定義的最重要的元素的演算法非常有用。有優勢的應用例如下：

- 事件驅動的模擬。每個事件有時間標記，希望依時間標記的順序來執行。優先佇列可以很容易地找到下一個模擬事件。
- 圖的搜尋演算法中Dijkstra演算法使用優先佇列來計算最低的成本。
- 壓縮演算法中的霍夫曼編碼，需要重複找到與不具有父節點且頻度最低的兩節點。
- A *尋路人工智能。
- 其他很多地方！

若採用一般佇列或是陣列要字當中找到下一個極值都需要遍歷整個序列，優先佇列（Priority Queue）可以最佳化這個過程。

## 可以用優先佇列（Priority Queue）做什麼？

優先佇列（Priority Queue）的一般性操作：

- **Enqueue**：在佇列增加新的元素
- **Dequeue**：移除並回傳佇列中最重要（或是最大/最小）的元素
- **Find Minimum**或**Find Maximum**：回傳佇列中最重要（或是最大/最小）的元素但不移除
- **Change Priority**：修改佇列中元素的優先序

## 如何實作優先佇列（Priority Queue）？

有許多不同的方式實作優先佇列：

- 使用已排序陣列（**Ordered Array**）： 將最重要的放在陣列最後，壞處是增加元素的效率很慢。
- 使用平衡二元樹（**balanced binary search tree**, **AVL Tree**）： 對於實作雙端優先佇列（double-ended priority queue）很好，因為對於"find minimum"與"find maximum"都極有效率。
- 使用堆積（**Heap**）： 堆積是一種很自然適合於於實作優先佇列的資料結構，兩個詞也經常被視為同義。堆積只是部分的排序效率上優於排序的陣列，所有的堆（Heap）的操作時間複雜度都是**O(log n)**。

以下我們以堆積（**Heap**）來實作：

*/
public struct PriorityQueue<T> {
	private var heap: Heap<T>
	
	public init(sort: (T, T) -> Bool) {
		heap = Heap(sort: sort)
	}
	
	public var isEmpty: Bool {
		return heap.isEmpty
	}
	
	public var count: Int {
		return heap.count
	}
	
	public func peek() -> T? {
		return heap.peek()
	}
	
	public mutating func enqueue(element: T) {
		heap.insert(element)
	}
	
	public mutating func dequeue() -> T? {
		return heap.remove()
	}
	
	public mutating func changePriority(index i: Int, value: T) {
		return heap.replace(index: i, value: value)
	}
}

extension PriorityQueue where T: Equatable {
	public func indexOf(element: T) -> Int? {
		return heap.indexOf(element)
	}
}

extension PriorityQueue: CustomStringConvertible {
	public var description: String {
			return heap.description
	}
}

/*:

如實作，可以看出實作了堆積，優先佇列（Priority Queue）的實作就幾乎完成了。

## 參考資料

[維基百科：Priority Queue](https://en.wikipedia.org/wiki/Priority_queue)

＃ 測試
*/
var preQ = PriorityQueue<Int>(sort: <)
preQ.enqueue(2)
preQ.enqueue(9)
preQ.enqueue(18)
preQ.enqueue(6)
preQ.enqueue(12)
preQ.count
preQ.isEmpty
preQ.peek()
preQ.changePriority(index: 3, value: 1)
preQ.dequeue()
preQ.dequeue()
preQ.dequeue()
preQ.dequeue()
preQ.dequeue()

/*:
***
[Previous](@previous) | [Next](@next)
*/



# Priority Queue

A priority queue is a [queue](../Queue/) where the most important element is always at the front.

The queue can be a *max-priority* queue (largest element first) or a *min-priority* queue (smallest element first).

## Why use a priority queue?

Priority queues are useful for algorithms that need to process a (large) number of items and where you repeatedly need to identify which one is now the biggest or smallest -- or however you define "most important".

Examples of algorithms that can benefit from a priority queue: 

- Event-driven simulations. Each event is given a timestamp and you want events to be performed in order of their timestamps. The priority queue makes it easy to find the next event that needs to be simulated.
- Dijkstra's algorithm for graph searching uses a priority queue to calculate the minimum cost.
- [Huffman coding](../Huffman Coding/) for data compression. This algorithm builds up a compression tree. It repeatedly needs to find the two nodes with the smallest frequencies that do not have a parent node yet.
- A* pathfinding for artificial intelligence.
- Lots of other places!

With a regular queue or plain old array you'd need to scan the entire sequence over and over to find the next largest item. A priority queue is optimized for this sort of thing.

## What can you do with a priority queue?

Common operations on a priority queue:

- **Enqueue**: inserts a new element into the queue.
- **Dequeue**: removes and returns the queue's most important element.
- **Find Minimum** or **Find Maximum**: returns the most important element but does not remove it.
- **Change Priority**: for when your algorithm decides that an element has become more important while it's already in the queue.

## How to implement a priority queue

There are different ways to implement priority queues:

- As a [sorted array](../Ordered Array/). The most important item is at the end of the array. Downside: inserting new items is slow because they must be inserted in sorted order.
- As a balanced [binary search tree](../Binary Search Tree/). This is great for making a double-ended priority queue because it implements both "find minimum" and "find maximum" efficiently.
- As a [heap](../Heap/). The heap is a natural data structure for a priority queue. In fact, the two terms are often used as synonyms. A heap is more efficient than a sorted array because a heap only has to be partially sorted. All heap operations are **O(log n)**.

Here's a Swift priority queue based on a heap:

```swift
public struct PriorityQueue<T> {
  private var heap: Heap<T>

  public init(sort: (T, T) -> Bool) {
    heap = Heap(sort: sort)
  }

  public var isEmpty: Bool {
    return heap.isEmpty
  }

  public var count: Int {
    return heap.count
  }

  public func peek() -> T? {
    return heap.peek()
  }

  public mutating func enqueue(element: T) {
    heap.insert(element)
  }

  public mutating func dequeue() -> T? {
    return heap.remove()
  }

  public mutating func changePriority(index i: Int, value: T) {
    return heap.replace(index: i, value: value)
  }
}
```

As you can see, there's nothing much to it. Making a priority queue is easy if you have a [heap](../Heap/) because a heap *is* pretty much a priority queue.

## See also

[Priority Queue on Wikipedia](https://en.wikipedia.org/wiki/Priority_queue)

*Written for Swift Algorithm Club by Matthijs Hollemans*
