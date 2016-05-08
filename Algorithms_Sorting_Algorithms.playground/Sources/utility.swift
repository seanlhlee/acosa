import Foundation

//performance check function
public func timeElapsedInSecondsWhenRunningCode(operation:()->()) -> Double {
	let startTime = CFAbsoluteTimeGetCurrent()
	operation()
	let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
	print("Time elapsed: \(timeElapsed) seconds")
	return Double(timeElapsed)
}

public func insertionSort<T>(array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
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



public func insertionSortImproved<T>(array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
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


public func mergeSort<T>(array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
	func merge<T>(leftPile leftPile: [T], rightPile: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
		// 1
		var leftIndex = 0
		var rightIndex = 0
		
		// 2
		var orderedPile = [T]()
		
		// 3
		while leftIndex < leftPile.count && rightIndex < rightPile.count {
			if isOrderedBefore(leftPile[leftIndex], rightPile[rightIndex]) {
				orderedPile.append(leftPile[leftIndex])
				leftIndex += 1
			} else {
				orderedPile.append(rightPile[rightIndex])
				rightIndex += 1
			}
		}
		
		var index = leftIndex < leftPile.count ? leftIndex : rightIndex
		var remainingPile = leftIndex < leftPile.count ? leftPile : rightPile
		
		// 4
		while index < remainingPile.count {
			orderedPile.append(remainingPile[index])
			index += 1
		}
		
		return orderedPile
	}
	// 1
	guard array.count > 1 else { return array }
	// 2
	let middleIndex = array.count / 2
	// 3
	let leftArray = mergeSort(Array(array[0..<middleIndex]), isOrderedBefore)
	// 4
	let rightArray = mergeSort(Array(array[middleIndex..<array.count]), isOrderedBefore)
	// 5
	return merge(leftPile: leftArray, rightPile: rightArray, isOrderedBefore)
}

public func mergeSortBottomUp<T>(a: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
	let n = a.count
	// 1
	var z = [a, a]
	var d = 0
	// 2
	var width = 1
	while width < n {
  
		var i = 0
		// 3
		while i < n {
			
			var j = i
			var l = i
			var r = i + width
			
			let lmax = min(l + width, n)
			let rmax = min(r + width, n)
			// 4
			while l < lmax && r < rmax {
				if isOrderedBefore(z[d][l], z[d][r]) {
					z[1 - d][j] = z[d][l]
					l += 1
				} else {
					z[1 - d][j] = z[d][r]
					r += 1
				}
				j += 1
			}
			while l < lmax {
				z[1 - d][j] = z[d][l]
				j += 1
				l += 1
			}
			while r < rmax {
				z[1 - d][j] = z[d][r]
				j += 1
				r += 1
			}
			
			i += width*2
		}
		// 5
		width *= 2
		d = 1 - d
	}
	return z[d]
}