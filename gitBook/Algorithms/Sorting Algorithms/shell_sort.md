# 希爾排序法（Shell Sort）

希爾排序法（Shell Sort）是基於[插入排序法](Insertion%20Sort)進行效能改良，藉由將原集合分成數個小集合再個別以插入排序法完成排序。

一段不錯的希爾排序法[介紹影片](https://www.youtube.com/watch?v=CmPA7zE8mx0)

## 運作機制

插入排序法是相鄰元素比較，失序時交換位置，而希爾排序法則是比較相隔一段距離的元素，失序時一樣交換位置。相隔的距離是*gap*，如果比較的元素是錯誤的順序，交換位置的距離是*gap*。想法是藉由元素間較長距離的換位來快速達到區域性的排序，使得在之後的步驟因為不用再換位而更快速。一旦一輪結束，交換距離*gap*變得更小再進行相同的步驟一輪，直到*gap*為1。此演算法運作起來就像插入排序法，在一輪一輪過程中椅部分排序而加快了後續的進行。

## 例子

假設我們有一陣列`[64, 20, 50, 33, 72, 10, 23, -1, 4]`以希爾排序法排序，開始時，我們將元素數除以2：`n = floor(9/2) = 4`做為第一輪的`gap`大小，將陣列分成小陣列，每個小陣列元素間間隔為`gap`，再以`insertionSort()`的輔助函式進行子陣列的排序。

第一輪的示意如下:

	子陣列 0:  [ 64, xx, xx, xx, 72, xx, xx, xx, 4  ]
	子陣列 1:  [ xx, 20, xx, xx, xx, 10, xx, xx, xx ]
	子陣列 2:  [ xx, xx, 50, xx, xx, xx, 23, xx, xx ]
	子陣列 3:  [ xx, xx, xx, 33, xx, xx, xx, -1, xx ]

每個子陣列為原陣列間隔4的元素。不在子陣列的元素在示意中標示為`xx`，第一個子集合是`[ 64, 72, 4 ]`，第二個是`[ 20, 10 ]`，使用"gap"變數可以直接在原陣列中操作，而避新建許多新陣列。之後對每個子陣列呼叫輔助函式`insertionSort()`進行排序(此處的實作由後開始往前排序)。

對於子陣列0，`4`與`72`換位，之後`4`再與`64`換位：

	子陣列 0:  [ 4, xx, xx, xx, 64, xx, xx, xx, 72 ]

其他三個子陣列排序後：

	子陣列 1:  [ xx, 10, xx, xx, xx, 20, xx, xx, xx ]
	子陣列 2:  [ xx, xx, 23, xx, xx, xx, 50, xx, xx ]
	子陣列 3:  [ xx, xx, xx, -1, xx, xx, xx, 33, xx ]

而整個陣列現在是：

	[ 4, 10, 23, -1, 64, 20, 50, 33, 72 ]

然還還是沒有排序的，但與未排序前相較是有次序些了。第二輪我們在將gap值除以2：`n = floor(4/2) = 2`，這代表此次我們只有兩個子陣列：

	子陣列 0:  [  4, xx, 23, xx, 64, xx, 50, xx, 72 ]
	子陣列 1:  [ xx, 10, xx, -1, xx, 20, xx, 33, xx ]

針對每個子陣列再次以呼叫`insertionSort()`輔助函式排序：

	子陣列 0:  [  4, xx, 23, xx, 50, xx, 64, xx, 72 ]
	子陣列 1:  [ xx, -1, xx, 10, xx, 20, xx, 33, xx ]

可以注意到每個子陣列只有兩個元素的位置是錯的，原因是第一輪時已些微的排序了一次。而整個列現在是：

	[ 4, -1, 23, 10, 50, 20, 64, 33, 72 ]

最後，再將gap值除以2：`n = floor(2/2) = 1`，陣列已不再分割，同前呼叫`insertionSort()`輔助函式排序即完成：

	[ -1, 4, 10, 20, 23, 33, 50, 64, 72 ]

## 效能

希爾排序法的時間複雜度為**O(n^2)**，最佳時間複雜度為**O(n log n)**此法為不穩定排序，如果有值相同的元素，可能改變其順序。

## 間隔值(gap)的次序

間隔值(gap)的次序決定了每一輪子集合的大小，也會影響此演算法的效率。在我們的實作中我們採跟原始的希爾排序法相同的方式，在每一輪中對`gap`除以2。當然，還有其他的方式，可以自行嘗試。

## 實作

以下為希爾排序法（Shell Sort）的Swift實作：

```swift
public func shellSort<T>(array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
	func insertionSorted(inout list: [T], start: Int, gap: Int) {
		for i in (start + gap).stride(to: list.count, by: gap) {
			let currentValue = list[i]
			var pos = i
			while pos >= gap && isOrderedBefore(currentValue, list[pos - gap]) {
				list[pos] = list[pos - gap]
				pos -= gap
			}
			list[pos] = currentValue
		}
	}
	var sortedArray = array
	var subArrayCount = array.count / 2
	while subArrayCount > 0 {
		for pos in 0..<subArrayCount {
			insertionSorted(&sortedArray, start: pos, gap: subArrayCount)
		}
		subArrayCount = subArrayCount / 2
	}
	return sortedArray
}


public func shellSorted<T>(inout array: [T], _ isOrderedBefore: (T, T) -> Bool) {
	func insertionSorted(inout list: [T], start: Int, gap: Int) {
		for i in (start + gap).stride(to: list.count, by: gap) {
			let currentValue = list[i]
			var pos = i
			while pos >= gap && isOrderedBefore(list[pos - gap], currentValue) {
				list[pos] = list[pos - gap]
				pos -= gap
			}
			list[pos] = currentValue
		}
	}
	var subArrayCount = array.count / 2
	while subArrayCount > 0 {
		for pos in 0..<subArrayCount {
			insertionSorted(&array, start: pos, gap: subArrayCount)
		}
		subArrayCount = subArrayCount / 2
	}
}
```

## 參考資料

[維基百科：Shellsort](https://en.wikipedia.org/wiki/Shellsort)

[Rosetta code: Shell sort](http://rosettacode.org/wiki/Sorting_algorithms/Shell_sort)
