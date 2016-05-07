# 佇列(Queue)

佇列(Queue)很像陣列，由資料組最後加入新的元素，而由最前面取出元素，即先進先出(FIFO)。使用*enqueue*方法來新增一個新的元素到佇列的後端，使用*dequeue*方法來自佇列之前端移除元素，或以*peek*方法取得前端的元素而不移出。

在許多演算法中，需要暫時加入元素至一組資料中並在之後將其取出時，當中順序是重要時，可以使用堆疊或是佇列。

例如使用enqueue方法將整數10到佇列中：

```swift
queue.enqueue(10)
```

現在佇列為`[ 10 ]`。再加入(enqueue)一個整數：

```swift
queue.enqueue(3)
```

現在佇列為`[ 10, 3 ]`。再加入一個:

```swift
queue.enqueue(57)
```

現在佇列為`[ 10, 3, 57 ]`。現在自佇列中dequeue出最前方的整數：

```swift
queue.dequeue()
```

因為最先加入佇列的元素會回傳，回傳值為`10`，現在佇列為`[ 3, 57 ]`。

```swift
queue.dequeue()
```

若再dequeue則會回傳`3`、`57`直到佇列已空。佇列已空時，可以實作回傳`nil`或是揭露處物訊息如"queue underflow"。

> **Note:** 當操作時加入與移除的順序不重要時，選擇佇列(Queue)並非最佳選擇，堆疊(Stack)會更簡單快速。

##	實作

以下為最簡單實現佇列的enqueue、dequeue與peek功能的Swift實作：

```swift
public struct Queue<Element> {
  private var array = [Element]()

  public var isEmpty: Bool {
    return array.isEmpty
  }
  
  public var count: Int {
    return array.count
  }

  public mutating func enqueue(element: Element) {
    array.append(element)
  }
  
  public mutating func dequeue() -> Element? {
	guard !isEmpty else { return nil }
	return array.removeFirst()
  }
  
  public func peek() -> Element? {
    return array.first
  }
}
```

上述的佇列實作可以正常運作，效能上則因dequeue為取出陣列最前面的元素，為一**O(n)**的操作，相較於enqueue為**O(1)**效率上可再改進。如下例子，在佇列中dequeue出第一個元素`安琪`，而之後的幾個元素在記憶體位置中會前移，此操作為**O(n)**。

	原始   [ "安琪", "恩宇", "世雄", "靜香", xxx, xxx ]
 				   /       /      /
				  /       /      /
				 /       /      /
				/       /      /
	之後   [   "恩宇", "世雄", "靜香", xxx, xxx, xxx ]
 

## 效率改進

為了改善dequeue的效率，可嘗試於陣列之前保留一些記憶體空間，做法是在deque時將雲本元素的位置標記為空，取代原本記憶體位移的作法。示意為：

	之後   [ xxx, "恩宇", "世雄", "靜香", xxx, xxx ]

再次dequeue取出`"恩宇"`後，陣列成為:

	[ xxx, xxx, "世雄", "靜香", xxx, xxx ]

在列前頭的空物件會佔據記憶體，可在必要時進行調整成如下，而此動作頻度低，而增進了dequeue的平均效能至**O(1)**。釋放閒置記憶體後，示意為：：

	[ "世雄", "靜香", xxx, xxx, xxx, xxx ]

以下為改善效能的佇列(Queue)實作：

```swift
public struct Queue<Element> {
  private var array = [Element?]()
  private var head = 0
  
  public var isEmpty: Bool {
    return count == 0
  }

  public var count: Int {
    return array.count - head
  }
  
  public mutating func enqueue(element: Element) {
    array.append(element)
  }
  
  public mutating func dequeue() -> Element? {
    guard head < array.count, let element = array[head] else { return nil }
    
	array[head] = nil
    head += 1
    
	let percentage = Double(head)/Double(array.count)
    if array.count > 50 && percentage > 0.25 {
      array.removeFirst(head)
      head = 0
    }
    
    return element
  }
  
	public func peek() -> Element? {
		guard !isEmpty else { return nil }
		return array[head]
	}
}
```

此實作，因為要將陣列前頭部分可標記為空`nil`，屬性array的型別為`Element?`，而不是`Element`，並加入另一屬性`head`變數來記錄陣列前方第一個不為空的索引值。當進行dequeue操作時，先將`array[head]`標記為`nil`，並將`head`增加一。如下示意：

	首先標記
	[ "安琪", "恩宇", "世雄", "靜香", xxx, xxx ]
	  head

	dequeue之後的標記
	[ xxx , "恩宇", "世雄", "靜香", xxx, xxx ]
	        head

如果持續進行enqueue與dequeue的動作，陣列大小會一直增加，因此實作中也在適當的情況下清理陣列閒置的記憶體空間。

```swift
    let percentage = Double(head)/Double(array.count)
    if array.count > 50 && percentage > 0.25 {
      array.removeFirst(head)
      head = 0
    }
```

該實作的意義上是當陣列大小超過50且有25%的比例是空物件時，進行記憶體的釋放動作。

還有其他的方法來實作佇列(Queue)，諸如串列(Linked List)、環形緩衝區(Ring Buffer)或是堆積(Heap)。
