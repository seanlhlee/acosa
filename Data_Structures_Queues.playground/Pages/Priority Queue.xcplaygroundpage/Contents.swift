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
