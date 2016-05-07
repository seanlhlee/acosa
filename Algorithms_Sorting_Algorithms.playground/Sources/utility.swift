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
