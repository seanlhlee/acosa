# 双端佇列（Deque）

兩頭皆能插入與刪除，稱作Deque，同時有著Stack和Queue的功效。Deque的發音類似"deck"。

一般的[queue](Queue)由後加入元素由前取出元素而双端佇列（Deque）也允許自前加入元素與自後取出元素，及自兩端peek元素。

以下是以Swift實作程式碼：
```swift
public struct Deque<T> {
	private var array = [T]()
	
	public var isEmpty: Bool {
		return array.isEmpty
	}
	
	public var count: Int {
		return array.count
	}
	
	public mutating func enqueue(element: T) {
		array.append(element)
	}
	
	public mutating func enqueueFront(element: T) {
		array.insert(element, atIndex: 0)
	}
	
	public mutating func dequeue() -> T? {
		guard !isEmpty else {return nil }
		return array.removeFirst()
	}
	
	public mutating func dequeueBack() -> T? {
		guard !isEmpty else {return nil }
		return array.removeLast()
	}
	
	public func peekFront() -> T? {
		return array.first
	}
	
	public func peekBack() -> T? {
		return array.last
	}
}
```
此實作以內部陣列來實現，Enqueuing與dequeuing都是很簡單的自陣列首或尾來增加或移除元素。以下為在playground的測試：
```swift
var deque = Deque<Int>()
deque.enqueue(1)
deque.enqueue(2)
deque.enqueue(3)
deque.enqueue(4)

deque.dequeue()       // 1
deque.dequeueBack()   // 4

deque.enqueueFront(5)
deque.dequeue()       // 5
```

此版實作非常簡單去非很有效率。`enqueueFront()`與`dequeue()`操作的時間複雜度為**O(n)**。

## 一個更有效率的版本

`enqueueFront()`與`dequeue()`操作的時間複雜度為**O(n)**的原因是自陣列的前方操作，需要將其他的元素在記憶體中位移。例如

 自陣列`[ 1, 2, 3, 4 ]``dequeue()`會從陣列中移除`1`而其他的`2`、`3`與`4`向前位移一個位置成`[ 2, 3, 4 ]`。而當`enqueueFront(5)`時也是相同的情況`[ 5, 2, 3, 4 ]`。然而`enqueue()`和`dequeueBack()`操作的對象是陣列的尾端，沒有位移的過程。

一開始的陣列`[ 1, 2, 3, 4]`在記憶體中看起來像：

	[ 1, 2, 3, 4, x, x, x ]

其中`x`代表陣列中沒有使用的部分。呼叫`enqueue(6)`就簡單地將新的元素放到未使用的位置：

	[ 1, 2, 3, 4, 6, x, x ]

`dequeueBack()`方法使用到`array.removeLast()`方法來移除元素，並沒有壓縮陣列的記憶體而僅將`array.count`減1。因此對陣列尾端的操作其時間複雜度為 **O(1)**。

陣列後面未被使用的預留空間也可能被用完，此時Swift會重新一個新的較大的陣列來儲存，此操作時間複雜度**O(n)**，而此動作短期間內只做一次，平均來說之後的自陣列尾端的操作效率為**O(1)**。

因此我們可以利用相同的機制來改善對於陣列前方操作的效率：

	[ x, x, x, 1, 2, 3, 4, x, x, x ]

安排一些未使用的空間在陣列的前方，當在前方新增或移除元素時也可以有**O(1)**的效率。以下為改良版的實作

```swift
public struct Deque<T> {
	private var array: [T?]
	private var head: Int
	private var capacity: Int
	
	public init(capacity: Int = 10) {
		self.capacity = max(capacity, 1)
		array = .init(count: capacity, repeatedValue: nil)
		head = capacity
	}
	
	public var isEmpty: Bool {
		return count == 0
	}
	
	public var count: Int {
		return array.count - head
	}
	
	public mutating func enqueue(element: T) {
		array.append(element)
	}
	
	public mutating func enqueueFront(element: T) {
		if head == 0 {
			capacity *= 2
			let emptySpace = [T?](count: capacity, repeatedValue: nil)
			array.insertContentsOf(emptySpace, at: 0)
			head = capacity
		}
		
		head -= 1
		array[head] = element
	}
	
	public mutating func dequeue() -> T? {
		guard head < array.count, let element = array[head] else { return nil }
		
		array[head] = nil
		head += 1
		
		if capacity > 10 && head >= capacity*2 {
			let amountToRemove = capacity + capacity/2
			array.removeFirst(amountToRemove)
			head -= amountToRemove
			capacity /= 2
		}
		return element
	}
	
	public mutating func dequeueBack() -> T? {
		guard !isEmpty else {return nil }
		return array.removeLast()
	}
	
	public func peekFront() -> T? {
		guard !isEmpty else {return nil }
		return array[head]
	}
	
	public func peekBack() -> T? {
		guard !isEmpty else {return nil }
		return array.last!
	}
}
```

## 參考資料

[A fully-featured deque implementation in Swift](https://github.com/lorentey/Deque)

