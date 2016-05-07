/*:
[Next](@next)
***
# 插入排序法（Insertion Sort）

目標：將一個陣列中的元素由高到低（或高至低）排序。插入排序法的運作方式如下：

- 放入一堆沒有順序的元素
- 從這堆中取出一個
- 在新的陣列中加入此元素
- 在未排序的堆中再取出一個元素，依據與第一個元素比較關係，決定放入新的陣列中之位置。
- 再次取出元素並插入新陣列中依排序規則適當的位置
- 持續進行上述步驟直到無序堆中已無元素

從上述步驟，是取出元素並插入到一個排序陣列的適當位置中，因此稱為插入排序法（Insertion Sort）。

## 例子

一堆未排序的資料集合`[ 8, 3, 5, 4, 6 ]`。

從中取出第一個元素`8`加入到新的陣列中。排序陣列為`[ 8 ]`，無序集合為`[ 3, 5, 4, 6 ]`。

取出下一個元素`3`將其插入到排序陣列，因為比`8`小，因此將其放置在`8`之前，排序陣列現為`[ 3, 8 ]`，無序集合為`[ 5, 4, 6 ]`。

再取出下一個元素`5`，因為比`3`大且比`8`小，故將其插入到之間的位置。排序陣列現為`[ 3, 5, 8 ]`，無序集合為`[ 4, 6 ]`。

重複這個過程直到無序集合已空。

## 就地排序

由上述說明中，我們需要一個未排序與一個排序過的陣列。也可以藉由分開陣列中已排序與未排序的部分來進行就地排序，如此無需新增一個新陣列。

在上述的例子中，一開始是`[ 8, 3, 5, 4, 6 ]`，我們以`|`來區隔已排序與未排序的部分：

	[| 8, 3, 5, 4, 6 ]

上述表示，已排序部分為空，而未排序部分的第一個元素為`8`，隨著過程進行，陣列為：

	[ 8 | 3, 5, 4, 6 ]

已排序部分為`[ 8 ]`，未排序部分為`[ 3, 5, 4, 6 ]`，分個符號`|`向右位移了一個位置。完整過程的示意如下：

	[| 8, 3, 5, 4, 6 ]
	[ 8 | 3, 5, 4, 6 ]
	[ 3, 8 | 5, 4, 6 ]
	[ 3, 5, 8 | 4, 6 ]
	[ 3, 4, 5, 8 | 6 ]
	[ 3, 4, 5, 6, 8 |]

過程中每個步驟，符號`|`均往右移一格，直到右側未排序部分已空。

## 如何插入

每個步驟中，我們都是取出未排序部分的第一個元素，將其插入到已排序部分適當的位置，而插入適當的位置是如何運作的？

假設我們已經完成一部分步驟：

	[ 3, 5, 8 | 4, 6 ]

下一個要處理的是`4`，我們要將其插入到`[ 3, 5, 8 ]`適當的位置處。在此之前的元素為 `8`。

	[ 3, 5, 8, 4 | 6 ]
			   ^

該元素比`4`大，所以`4`應該被放在`8`之前，因此交換（swap）兩者的位置：

	[ 3, 5, 4, 8 | 6 ]
			<-->
			swapped

再往前一個元素為`5`以比`4`大，要再交換位置：

	[ 3, 4, 5, 8 | 6 ]
		 <-->
		 swapped

依序往前為`3`，比`4`小代表現在我們已經排序好`4`的位置了。

上面描述的即是插入排序法內層的迴圈，依照交換（swap）位置的方式來達成排序的效果。

## 實作

以下為插入排序法（insertion sort）的Swift實作：
*/
/*
func insertionSort<T>(array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
	var a = array
	for x in 1..<a.count {
		var y = x
		while y > 0 && !isOrderedBefore(a[y - 1], a[y]) {
			swap(&a[y], &a[y - 1])
			y -= 1
		}
	}
	return a
}
*/
/*:
實作原理說明：

1. 傳入Swift函式之參數值不可變，因此先複製一份與`array`內容相同的陣列，最終回傳的是一個經過排序的*陣列副本*。

2. 函數中有兩迴圈，外迴圈依序處理陣列中的元素，變數`x`為已排序部分與未排序部分界線的索引值，可以想成是`|`分界符號的位置。

3. 內迴圈處理`x`之前的位置，並以反向的方式半段元素位置是否交換（swap）。

> **注意：** 外迴圈由1開始，因為內迴圈的運作包含兩元素值的比較判斷。

## 不做換位（swap）的改良

前面的實作透過換位的方式將處理的元素移到排序好的部分：

	[ 3, 5, 8, 4 | 6 ]
			<-->
			swap

	[ 3, 5, 4, 8 | 6 ]
		 <-->
		 swap

可以改寫為不呼叫換位函式`swap()`，而是將已排序部分原本需要被交換的元素右移的方式來進行，以改善效能。

	[ 3, 5, 8, 4 | 6 ]   remember 4
			   *

	[ 3, 5, 8, 8 | 6 ]   shift 8 to the right
			--->

	[ 3, 5, 5, 8 | 6 ]   shift 5 to the right
		 --->

	[ 3, 4, 5, 8 | 6 ]   copy 4 into place
		 *

In code that looks like this:
*/
/*
func insertionSortImproved<T>(array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
	var a = array
	for x in 1..<a.count {
		var y = x
		let temp = a[y]
		while y > 0 && !isOrderedBefore(a[y - 1], temp) {
			a[y] = a[y - 1]
			y -= 1
		}
		a[y] = temp
	}
	return a
}
*/
/*:
## 效能

如果陣列中的元素已部分有序，插入排序法是很有效率的方法。最差狀況，因為有兩層迴圈，插入排序法的效率是**O(n^2)**。 其他的排序演算法如快速排序法（quicksort）與合併排序法（merge sort）效率為**O(n log n)**，差異在當數據量大時才比較明顯。

插入排序法事實上很快，部分標準函式庫甚至將處理元素量少於10的排序函式由快速排序法轉為使用插入排序法。

## 參考資料

[維基百科: Insertion sort](https://en.wikipedia.org/wiki/Insertion_sort)
***
# **測試**:
*/
import Foundation

let array = [2,7,3,1,0,9,8,5]
insertionSort(array, <)
insertionSortImproved(array, >)

func testCode1() {
	var array = [UInt32]()
	for _ in 0..<100 {
		array.append(arc4random_uniform(3000))
	}
	insertionSort(array, <)
}

func testCode2() {
	var array = [UInt32]()
	for _ in 0..<100 {
		array.append(arc4random_uniform(3000))
	}
	insertionSortImproved(array, <)
}

func testCode3() {
	var array = [UInt32]()
	for _ in 0..<100 {
		array.append(arc4random_uniform(3000))
	}
	array.sort()
}


timeElapsedInSecondsWhenRunningCode(testCode1)
timeElapsedInSecondsWhenRunningCode(testCode2)
timeElapsedInSecondsWhenRunningCode(testCode3)

/*:
***
[Next](@next)
*/
