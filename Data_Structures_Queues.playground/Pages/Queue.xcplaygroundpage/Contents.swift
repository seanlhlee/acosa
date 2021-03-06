/*:
[Previous](@previous) | [Next](@next)
***

# 佇列(Queue)

佇列(Queue)很像陣列，由資料組最後加入新的元素，而由最前面取出元素，即先進先出(FIFO)。使用*enqueue*方法來新增一個新的元素到佇列的後端，使用*dequeue*方法來自佇列之前端移除元素，或以*peek*方法取得前端的元素而不移出。

在許多演算法中，需要暫時加入元素至一組資料中並在之後將其取出時，當中順序是重要時，可以使用堆疊或是佇列。

例如使用enqueue方法將整數10到佇列中：

	queue.enqueue(10)

現在佇列為`[ 10 ]`。再加入(enqueue)一個整數：

	queue.enqueue(3)

現在佇列為`[ 10, 3 ]`。再加入一個:

	queue.enqueue(57)

現在佇列為`[ 10, 3, 57 ]`。現在自佇列中dequeue出最前方的整數：

	queue.dequeue()

因為最先加入佇列的元素會回傳，回傳值為`10`，現在佇列為`[ 3, 57 ]`。

	queue.dequeue()


若再dequeue則會回傳`3`、`57`直到佇列已空。佇列已空時，可以實作回傳`nil`或是揭露處物訊息如"queue underflow"。

- note:
當操作時加入與移除的順序不重要時，選擇佇列(Queue)並非最佳選擇，堆疊(Stack)會更簡單快速。


以下為佇列的Swift實作：

*/
/*
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
*/

/*:
Enqueuing是一**O(1)**操作。Dequeue的操作是由最前面的元素移除，為 **O(n)**，因為陣列中的所有元素都將在記憶體中位移。

上述的實作，使用了一點小技巧來讓dequeuing為**O(1)**之操作。

此實作，因為要將陣列前頭部分可標記為空`nil`，屬性array的型別為`Element?`，而不是`Element`，並加入另一屬性`head`變數來記錄陣列前方第一個不為空的索引值。當進行dequeue操作時，先將`array[head]`標記為`nil`，並將`head`增加一。如下示意：

首先標記
[ "安琪", "恩宇", "世雄", "靜香", xxx, xxx ]
head

dequeue之後的標記
[ xxx , "恩宇", "世雄", "靜香", xxx, xxx ]
head

如果持續進行enqueue與dequeue的動作，陣列大小會一直增加，因此實作中也在適當的情況下清理陣列閒置的記憶體空間。意義上是當陣列大小超過50且有25%的比例是空物件時，進行記憶體的釋放動作。

還有其他的方法來實作佇列(Queue)，諸如串列(Linked List)、環形緩衝區(Ring Buffer)或是堆積(Heap)。

# **測試**:
*/
var checkoutLane = Queue<String>()
checkoutLane.isEmpty
checkoutLane.enqueue("mary")
checkoutLane.enqueue("Tim")
checkoutLane.enqueue("Tom")
checkoutLane.count
checkoutLane.isEmpty
checkoutLane.dequeue()			// "Mary"
checkoutLane.enqueue("Sylvia")
checkoutLane.enqueue("Johnny")
checkoutLane.dequeue()			// "Tim"
checkoutLane.peek()				// "Tom"
checkoutLane.dequeue()			// "Tom"
checkoutLane.dequeue()			// "Sylvia"
checkoutLane.dequeue()			// "Johnny"
checkoutLane.dequeue()			// nil
checkoutLane.dequeue()			// nil
checkoutLane.isEmpty
checkoutLane.count
checkoutLane.enqueue("Cloudia")

func testCode1() {
	var checkoutLane: Stack<String> = Stack()
	for _ in 0..<100 {
		checkoutLane.push("guest")
	}
	for _ in 0..<80 {
		checkoutLane.pop()
	}
}

func testCode2() {
	var checkoutLane = Queue<String>()
	for _ in 0..<100 {
		checkoutLane.enqueue("guest")
	}
	for _ in 0..<80 {
		checkoutLane.dequeue()
	}
}

func testCode3() {
	var checkoutLane = QueueImprove<String>()
	for _ in 0..<100 {
		checkoutLane.enqueue("guest")
	}
	for _ in 0..<80 {
		checkoutLane.dequeue()
	}
}

timeElapsedInSecondsWhenRunningCode(testCode1)  // 約0.30~0.35秒
timeElapsedInSecondsWhenRunningCode(testCode2)	// 約0.30~0.35秒
timeElapsedInSecondsWhenRunningCode(testCode3)	// 約0.55~0.60秒

// 從實測結果來看，改良版的Queue似乎沒有得到效率上的提升，其原因可能是多了一個變數的讀取寫入動作，是否如此呢? 需要再深入研究。

/*:
***
[Previous](@previous) | [Next](@next)
*/

