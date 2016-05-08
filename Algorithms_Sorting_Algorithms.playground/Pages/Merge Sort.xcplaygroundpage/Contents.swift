/*:
[Previous](@previous) | [Next](@next)
***
*/

import Foundation

func mergeSort(array: [Int]) -> [Int] {
	guard array.count > 1 else { return array }    // 1
	
	let middleIndex = array.count / 2              // 2
	
	let leftArray = mergeSort(Array(array[0..<middleIndex]))             // 3
	
	let rightArray = mergeSort(Array(array[middleIndex..<array.count]))  // 4
	
	return merge(leftPile: leftArray, rightPile: rightArray)             // 5
}


func merge(leftPile leftPile: [Int], rightPile: [Int]) -> [Int] {
	// 1
	var leftIndex = 0
	var rightIndex = 0
	
	// 2
	var orderedPile = [Int]()
	
	// 3
	while leftIndex < leftPile.count && rightIndex < rightPile.count {
		if leftPile[leftIndex] < rightPile[rightIndex] {
			orderedPile.append(leftPile[leftIndex])
			leftIndex += 1
		} else if leftPile[leftIndex] > rightPile[rightIndex] {
			orderedPile.append(rightPile[rightIndex])
			rightIndex += 1
		} else {
			orderedPile.append(leftPile[leftIndex])
			leftIndex += 1
			orderedPile.append(rightPile[rightIndex])
			rightIndex += 1
		}
	}
	
	// 4
	while leftIndex < leftPile.count {
		orderedPile.append(leftPile[leftIndex])
		leftIndex += 1
	}
	
	while rightIndex < rightPile.count {
		orderedPile.append(rightPile[rightIndex])
		rightIndex += 1
	}
	
	return orderedPile
}

var array = [1,2,3,6,7,81,2,4,23,13,87,98]
mergeSort(array)



public func swap<T>(inout a: [T], _ i: Int, _ j: Int) {
	if i != j {
		swap(&a[i], &a[j])
	}
}

func mergesort<T>(array: [T], isOrdered: (T,T) -> Bool) -> [T] {
	func slice<T>(array: [T]) -> [[T]] {
		guard array.count > 2 else { return [array] }
		let a = [T](array.dropLast(array.count / 2))
		let b = array.count % 2 == 0 ? [T](array.dropFirst(array.count / 2)) : [T](array.dropFirst(array.count / 2 + 1))
		return slice(a) + slice(b)
	}
	func sort<T>(inout array: [T], isOrdered: (T,T) -> Bool) -> [T] {
		guard array.count == 2 else { return array }
		guard !(isOrdered(array[0], array[1])) else { return array }
		swap(&array[0], &array[1])
		return array
	}
	func merge(inout a: [T],inout b: [T]) -> [T] {
		var temp = [T]()
		while !a.isEmpty || !b.isEmpty	{
			if b.isEmpty {
				temp.append(a.removeFirst())
			} else if a.isEmpty {
				temp.append(b.removeFirst())
			} else if isOrdered(a[0],b[0]) {
				temp.append(a.removeFirst())
			} else {
				temp.append(b.removeFirst())
			}
		}
		return temp
	}
	var sorted = [[T]]()
	for var element in slice(array) {
		sorted.append(sort(&element, isOrdered: isOrdered))
	}
	repeat {
		var temp = [[T]]()
		for i in 0..<sorted.count / 2 {
			if i * 2 + 1 == sorted.count {
				temp.append(sorted[i * 2])
			} else {
				temp.append(merge(&sorted[i * 2], b: &sorted[i * 2 + 1]))
			}
		}
		sorted = temp
	} while sorted.count != 1
	return sorted[0]
}

func test1() {
	for i in 0...100 {
		mergesort(array, isOrdered: <)
	}
}

func test2() {
	for i in 0...100 {
		mergeSort(array)
	}
}
timeElapsedInSecondsWhenRunningCode(test1)
timeElapsedInSecondsWhenRunningCode(test2)




/*:
***
[Previous](@previous) | [Next](@next)
*/
