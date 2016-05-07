/*:
[Previous](@previous) | [Next](@next)
***
# 二元搜尋（Binary Search）

目標：快速查找出陣列中的目標元素

假設您有一陣列，要找出該陣列中是否含有目標元素，如果含有其索引值為何？大部分情形下，Swift內建的`indexOf()`函式非常好用。


	let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]

	numbers.indexOf(43)  // returns 15

根據Matthijs Hollemans的說法，Swift內建的`indexOf()`函式採用線性搜尋法（[Linear Search](gitBook/Algorithms/Searching Algorithms/linear_search.md)），其實作類似：

	func linearSearch<T: Equatable>(a: [T], _ key: T) -> Int? {
		for i in 0 ..< a.count {
			if a[i] == key {
				return i
			}
		}
		return nil
	}

	linearSearch(numbers, 43)  // returns 15

這樣有什麼問題呢？`linearSearch()`函式的迴圈是從頭開始一項一項查找直到找到目標元素，最差情況下，陣列中不含有目標元素，卻仍進行逐一查找的工作。

平均而言，線性搜尋法會查找大約一半的元素，當元素很多時，將會很緩慢。

## 分而治之（Divide and conquer）

典型加速查找工作的方法是二元搜尋法（ *binary search*），訣竅是不斷將資料分半直到找到目標元素。

對一個大小為`n`的陣列，採用線性搜索效率為**O(n)**，而二元搜尋法為**O(log n)**。二元搜尋法查找百萬筆資料的陣列僅需20步（`log_2(1,000,000) = 19.9`）。而查找10億筆資料時也僅需30步。

聽起來很棒，但有一個問題，陣列必須排序過，通常來說這並不是大問題。

以下說明二元搜尋的運作方式：

- 將陣列分成兩半，判斷是否有目標元素（*search key*），判斷目標元素可能出現在陣列之左半部或右半部。
- 透過事先排序，可以經由比較值`<`或`>`判斷哪半部可能含有目標元素（*search key*）。
- 如果目標元素（*search key*）可能在左半側，繼續將左半側資料分半，再判斷可能所在的部分。
- 一直重複上述過程直到找到目標元素。如果無法再細分更小的部分，代表陣列中並不包含目標元素。

這樣的過程稱為分治法（*divide-and-conquer*），是一種快速縮小作業範圍的方式。

## 實作

以下是一個以遞迴的方式實作的Swift二元搜尋法：
*/
import Foundation
// range參數預設值為陣列的全部範圍，用以方便一般之搜尋作業。
func binarySearch<T: Comparable>(key: T, inArray a: [T], range: Range<Int>? = nil) -> Int? {
	let r = range != nil ? range! : a.indices
	// 如果出現這情況，表示目標元素不在陣列之中
	guard r.startIndex < r.endIndex else { return nil }
	// 計算如何切分陣列查找的範圍
	let midIndex = r.startIndex + (r.endIndex - r.startIndex) / 2
	// 切分的位置點，剛好找到目標，回傳索引值。不是目標時才往下切分陣列
	guard a[midIndex] != key else { return midIndex }
	// 判斷目標元素是在左或右半側
	let range = a[midIndex] > key ? r.startIndex ..< midIndex : midIndex + 1 ..< r.endIndex
	return binarySearch(key, inArray: a, range: range)
}

let numbers = [5, 6, 12, 15, 18, 23, 29, 29, 31, 32, 37, 41, 46, 51, 54, 64, 73, 76, 89, 95]

binarySearch(31, inArray: numbers)  // 8
binarySearch(43, inArray: numbers)  // nil

/*:
> **注意：** 搜尋的陣列`numbers`必須事先排序，未排序時此法失效。

陣列需要事先排序，然而如果未排序，整合排序與二元搜尋可能會比直接採用線性搜尋還要慢。二元搜尋法非常適合於排序一次之後，進行很多次的查找作業。

二元搜尋法是不斷的二分查找的部分，此實作中我們使用Swift的`Range`物件來定義要查找的範圍，一開始的範圍是整個陣列，呼叫使用時方便起見，將range參數預設值定為陣列全部範圍`a.indices`，之後再不斷細分查找的範圍。此實作採用遞迴（Recursive Method）的方式，也可以採用疊代法（Iterative Method）來實作。

## 參考資料

[維基百科: Binary Search](https://en.wikipedia.org/wiki/Binary_search_algorithm)

***
[Previous](@previous) | [Next](@next)
*/
