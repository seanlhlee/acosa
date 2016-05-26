# 定容陣列（Fixed Size Array）

早期的程式語言並沒有很花哨的陣列。建立一個特定的大小的陣列，從那一刻起它永遠不會增長或收縮陣列。在C和Objective-C標準陣列都仍是這種類型。而定義一個陣列的語法像：

`int myArray[10];`

假設`int`型別占4位元組記憶空間，編譯器會配置一段連續的40 bytes的記憶區塊：

![An array with room for 10 elements](/gitBook/pics/array.png)

這個陣列會一直維持這個大小。如果要讓陣列大小可以變動，需要用到動態陣列（[dynamic array](https://en.wikipedia.org/wiki/Dynamic_array) ）物件，例如Objective-C裡的`NSMutableArray`或是C++的`std::vector` in C++，當然Swift的陣列是隨需要變動記憶體大小的。傳統陣列不便之處在於一開始要地易足夠大的空間，沒有利用到的就成為空間上的浪費，同時需要小心安全缺陷與緩衝溢位造成當機。綜上所述，固定大小的數組不夠彈性，幾乎沒有留容錯的空間。

但是有人會說，我喜歡**定容陣列（Fixed Size Array）**，因為他們簡單、快速又可預測。

典型陣列有以下可用操作：

- 新增新的元素到尾端
- 插入新的元素到陣列中或最前面
- 刪除元素
- 以索引值找到元素
- 計算陣列的大小

定容陣列（Fixed Size Array）若還沒有滿，新增元素是容易的：

![Appending a new element](/gitBook/pics/append.png)

以索引查找元素也超容易：

![Indexing the array](/gitBook/pics/indexing.png)

這兩項操作時間複雜度都為**O(1)**，代表其完成動作所需的時間與陣列大小無關。

可變動大小陣列，當滿容時必須要配置更多的記憶體，並將就資料拷貝到新的記憶暫存中。平均而言其新增元素的時間複雜度也是**O(1)**，但底層如何運作是難以預期的（除非你很瞭解其運作）。插入跟刪除元素的代價相對就高了，因為涉及其他元素在記憶體中的位移。例如，將`7`插入到陣列的中間：

![Insert requires a memory copy](/gitBook/pics/insert.png)

刪除元素也需要其他元素的位移：

![Delete also requires a memory copy](/gitBook/pics/delete.png)

對`NSMutableArray`或Swift的陣列，插入跟刪除時間複雜度為**O(n)**，陣列越大效率越慢。

因為定容陣列（Fixed Size Array）的以下優點，有時候還是需要它：

1. 已知最大元素量時。在遊戲中可以被同時激活的物件數量有限制。
2. 不需要排序的陣列

陣列無需排序代表`insertAtIndex()`的操作是不需要的，要加入元素就直接加在陣列末端未使用位置。實作上的程式碼就像：

	func append(newElement) {
		if count < maxSize {
			array[count] = newElement
			count += 1
		}
	}

`count`變數追蹤陣列已被利用的大小，因此可以索引值來直接存取第一個未被使用的記憶體位置。要知道陣列中現存多少元素，也只要讀取`count`的值，是**O(1)**的操作。

刪除的實作也一樣簡單：

	func removeAtIndex(index) {
		count -= 1
		array[index] = array[count]
	}

只是把最後一個元素拷貝到要刪除元素的位置，並且`count`解減1而已。

![Deleting just means copying one element](/gitBook/pics/delete-no-copy.png)

這也是不希望有排序情況的原因，這樣做就避免了插入與刪除時需要位移其他元素的過程。

刪除後陣列的記憶體中有兩個`6`，最後的那個`6`已經是非激活的，是無用資料，再下一次新增元素時就會被覆寫。

以下為Swift的實作：

```swift
struct FixedSizeArray<T>: CustomStringConvertible {
	private var maxSize: Int
	private var defaultValue: T
	private var array: [T]
	private (set) var count = 0
	
	init(maxSize: Int, defaultValue: T) {
		self.maxSize = maxSize
		self.defaultValue = defaultValue
		self.array = [T](count: maxSize, repeatedValue: defaultValue)
	}
	
	subscript(index: Int) -> T {
		assert(index >= 0)
		assert(index < count)
		return array[index]
	}
	
	mutating func append(newElement: T) {
		assert(count < maxSize)
		array[count] = newElement
		count += 1
	}
	
	mutating func removeAtIndex(index: Int) -> T {
		assert(index >= 0)
		assert(index < count)
		count -= 1
		let result = array[index]
		array[index] = array[count]
		array[count] = defaultValue
		return result
	}
	var description: String {
		return array[0..<count].description
	}
}
```

以下面方式建立一個新的陣列:
```swift
var a = FixedSizeArray(maxSize: 10, defaultValue: 0)
```

請注意`removeAtIndex()`函式以`defaultValue`覆寫來清除垃圾。通常來說，保留也是沒關係的，不過關聯型別是class物件時，可能與其他物件間有強參考，將其歸零是好的。

