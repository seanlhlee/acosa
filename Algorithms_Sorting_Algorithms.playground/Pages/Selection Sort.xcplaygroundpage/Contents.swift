/*:
[Previous](@previous) | [Next](@next)
***
*/

import Foundation

func binarySearch<T: Comparable>(key: T, inArray a: [T], range: Range<Int> = a.indices) -> Int? {
	// 如果出現這情況，表示目標元素不在陣列之中
	guard range.startIndex < range.endIndex else { return nil }
	// 計算如何切分陣列查找的範圍
	let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
	// 切分的位置點，剛好找到目標，回傳索引值。不是目標時才往下切分陣列
	guard a[midIndex] != key else { return midIndex }
	// 判斷目標元素是在左或右半側
	let range = a[midIndex] > key ? range.startIndex ..< midIndex : midIndex + 1 ..< range.endIndex
	return binarySearch(key, inArray: a, range: range)
}


let a = [5,89,73,46,51,29,18,6,32,15,64,76,54,29, 31, 37, 41,23,12]
let b = a.sort()

binarySearch(54, inArray: a)

let numbers = [5, 6, 12, 15, 18, 23, 29, 29, 31, 32, 37, 41, 46, 51, 54, 64, 73, 76, 89]

binarySearch(31, inArray: numbers)  // 8
binarySearch(43, inArray: numbers)  // nil

/*:
***
[Previous](@previous) | [Next](@next)
*/
