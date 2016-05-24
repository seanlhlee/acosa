# 有界優先佇列（Bounded Priority Queue）

有界優先佇列（Bounded Priority Queue）是有元素數量限制的[優先佇列](priority_queue.md)。當一個新元素被添加到容量飽和的佇列，最不優先的元素從佇列中移出。

## 例子

假設我們有個最大容量是5的有界優先佇列（Bounded Priority Queue），元素的值與優先序如下：

	Value:    [ A,   B,    C,    D,   E   ]
	Priority: [ 0.1, 0.25, 1.33, 3.2, 4.6 ]

定義最小優先序的是最重要的(*min-priority* queue)，`A`比`B`重要，`B`比`C`重要⋯⋯。新增一元素值`F`，優先序`0.4`因為佇列有容量限制為5，所以會將最不重要的`E`移出佇列並移入`F`：

	Value:    [ A,   B,    F,   C,    D   ]
	Priority: [ 0.1, 0.25, 0.4, 1.33, 3.2 ]

由`F`的優先序值決定其會被插入`B`與`C`之間。若要在加入新元素`G`其優先序4.0，則會因為其優先序值大於佇列中其他元素，沒有任何作用。

## 實作

以堆積(Heap)很容易實作優先佇列，實作如下：
```swift
public struct BoundedPriorityQueue<T> {
	private var heap: Heap<T>
	private var maxElements: Int
	private var isOrderedBefore: (T, T) -> Bool
	
	public init(maxElements: Int, sort: (T, T) -> Bool) {
		self.maxElements = maxElements
		self.isOrderedBefore = sort
		self.heap = Heap(sort: sort)
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
		if count < maxElements {
			heap.insert(element)
		} else {
			let tail = heap.reverse().peek()
			if isOrderedBefore(tail!, element) {
				return
			} else {
				var reverseHeap = heap.reverse()
				reverseHeap.remove()
				heap = reverseHeap.reverse()
				heap.insert(element)
			}

		}
	}
	
	public mutating func dequeue() -> T? {
		return heap.remove()
	}
	
	public mutating func changePriority(index i: Int, value: T) {
		return heap.replace(index: i, value: value)
	}
}

extension BoundedPriorityQueue where T: Equatable {
	public func indexOf(element: T) -> Int? {
		return heap.indexOf(element)
	}
}

extension BoundedPriorityQueue: CustomStringConvertible {
	public var description: String {
		return heap.description
	}
}
```
