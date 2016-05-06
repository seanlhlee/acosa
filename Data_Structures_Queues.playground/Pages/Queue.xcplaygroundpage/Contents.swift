/*:
# 佇列(Queue)

佇列(Queue)很像陣列，由資料組最後加入新的元素，而由最前面取出元素，即先進先出(FIFO)。使用*enqueue*方法來新增一個新的元素到佇列的後端，使用*dequeue*方法來自佇列之前端移除元素，或以*peek*方法取得前端的元素而不移出。

在許多演算法中，需要暫時加入元素至一組資料中並在之後將其取出時，當中順序是重要時，可以使用堆疊或是佇列。

例如將整數10 enqueue到佇列中：

	queue.enqueue(10)

現在佇列為`[ 10 ]`。再加入(enqueue)一個整數：

	queue.enqueue(3)

現在佇列為`[ 10, 3 ]`。再加入一個:

	queue.enqueue(57)

現在佇列為`[ 10, 3, 57 ]`。現在自佇列中dequeue出最前方的整數：

	queue.dequeue()

因為最先加入佇列的元素會回傳，回傳值為`10`，現在佇列為`[ 3, 57 ]`。

	queue.dequeue()


若再dequeue則會回傳`3`、`57`直到堆疊已空。堆疊已空時，可以實作回傳`nil`或是揭露處物訊息如"queue underflow"。

- note:
當操作時加入與移除的順序不重要時，選擇佇列(Queue)並非最佳選擇，堆疊(Stack)會更簡單快速。


以下為佇列的Swift實作：

*/
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
		if isEmpty {
			return nil
		} else {
			return array[head]
		}
	}
}
/*:
Enqueuing是一**O(1)**操作。Dequeue的操作是由最前面的元素移除，為 **O(n)**，因為陣列中的所有元素都將在記憶體中位移。

上述的實作，使用了一點小技巧來讓dequeuing為**O(1)**之操作。
*/
