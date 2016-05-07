/*:
# 堆疊(Stack)

![](stackPushPop_2x.png)

堆疊很像陣列但功能相對較少。使用*push*方法來新增一個新的元素到堆疊的頂端，使用*pop*方法來自堆疊之頂端移除元素，或以*peek*方法取得頂端的元素而不移出。
在許多演算法中，需要暫時加入元素至一組資料中並在之後將其取出時，當中順序是重要時，可以使用堆疊或是佇列。
堆疊是一個元素後進先出(LIFO)的資料結構，亦即最後一個push進來的元素會被之後的pop取出。而佇列(Queue)則為先進先出(FIFO)的資料結構。

例如將整數10 push到堆疊中：

	stack.push(10)

現在堆疊為`[ 10 ]`。再加入(push)一個整數：

	stack.push(3)

現在堆疊為`[ 10, 3 ]`。再加入(push)一個整數：

	stack.push(57)

現在堆疊是`[ 10, 3, 57 ]`。現在自堆疊中pop出最上方的整數：

	stack.pop()

因為最後push進去的整數會被回傳，回傳值為`57`。現在堆疊又變回是`[ 10, 3 ]`。

	stack.pop()

若再pop則會回傳`3`直到堆疊已空。堆疊已空時，可以實作回傳`nil`或是揭露處物訊息如"stack underflow"。

以下為堆疊的Swift實作：

*/
import Foundation
public struct Stack<Element> {
	private var array = [Element]()
	
	public var isEmpty: Bool {
		return array.isEmpty
	}
	
	public var count: Int {
		return array.count
	}
	
	public mutating func push(element: Element) {
		array.append(element)
	}
	
	public mutating func pop() -> Element? {
		guard !isEmpty else { return nil } // 也可以實作fatalError("stack underflow")
		return array.removeLast()
	}
	
	public func peek() -> Element? {
		return array.last
	}
}
/*:
- note:
注意push方法將新的元素加入到陣列的最後而非開頭。將新元素加入到開頭是一個**O(n)**的操作，因為陣列中的所有元素都將在記憶體中位移。而加在最後為**O(1)**使用的時間是常數與堆疊的元素多寡無關。
*/
