# 排序陣列（Ordered Array）

排序陣列（Ordered Array）一個總是排序好的陣列。插入一個新的元素會直接插入在排序的位置上。適用於希望資料總是排序也較少有新資料的添加時。如果資料經常會變動，比較好的方式還是使用一般的陣列，再手動排序。

實作：

```swift
public struct OrderedArray<T: Comparable>: CustomStringConvertible {
	private var array = [T]()
	
	public init(array: [T], sortedByAscending: Bool) {
		let sort: (T, T) -> Bool = sortedByAscending ? (<) : (>)
		self.array = array.sort(sort)
	}
	
	public init(array: [T]) {
		self.array = array.sort()
	}
	
	public var isEmpty: Bool {
		return array.isEmpty
	}
	
	public var count: Int {
		return array.count
	}
	
	public subscript(index: Int) -> T {
		return array[index]
	}
	
	public mutating func removeAtIndex(index: Int) -> T {
		return array.removeAtIndex(index)
	}
	
	public mutating func removeAll() {
		array.removeAll()
	}

	public var description: String {
		return array.description
	}

	public mutating func insert(newElement: T) -> Int {
		let i = findInsertionPoint(newElement)
		array.insert(newElement, atIndex: i)
		return i
	}
	
	private func findInsertionPoint(newElement: T) -> Int {
		var range = 0..<array.count
		while range.startIndex < range.endIndex {
			let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
			if array[midIndex] == newElement {
				return midIndex
			} else if array[midIndex] < newElement {
				range.startIndex = midIndex + 1
			} else {
				range.endIndex = midIndex
			}
		}
		return range.startIndex
	}
}
```

輔助函式`findInsertionPoint()`採用二元搜尋法（binary search）來找到正確的位置將新元素插入。輔助函式與常規的二元搜尋法的不同只在此輔助函式不會回傳`nil`。

> **注意：** 如果沒有找到合適的插入點，我們可以簡單地以`array.count`作為索引，將新元素插入到陣列最後即可。


請注意使用二元搜尋法查找插入點的時間複雜度為**O(log n)**，但此演算法的時間複雜度仍是由`insert()`決定，因為插入元素到陣列中最差情況其時間複雜度為**O(n)**。. 在實際運用上，對較大的陣列來說，此方法還是很快的。

# 測試

```swift
var a = OrderedArray<Int>(array: [5, 1, 3, 9, 7, -1])
a              // [-1, 1, 3, 5, 7, 9]

a.insert(4)    // inserted at index 3
a              // [-1, 1, 3, 4, 5, 7, 9]

a.insert(-2)   // inserted at index 0
a.insert(10)   // inserted at index 8
a              // [-2, -1, 1, 3, 4, 5, 7, 9, 10]

var b = OrderedArray<Int>(array: [8,0,4,9,1,3,7], sortedByAscending: false) // [9, 8, 7, 4, 3, 1, 0]

```
