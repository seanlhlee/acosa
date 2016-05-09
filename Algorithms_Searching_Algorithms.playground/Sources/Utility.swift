import Foundation

// swap elements position directly in an array
public func swap<T>(inout a: [T], _ i: Int, _ j: Int) {
	if i != j {
		swap(&a[i], &a[j])
	}
}
public func random(min min: Int, max: Int) -> Int {
	return Int(arc4random_uniform(UInt32(max - min))) + min
}