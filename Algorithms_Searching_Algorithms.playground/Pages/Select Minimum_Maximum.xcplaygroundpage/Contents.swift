/*:
[Previous](@previous) | [Next](@next)
***
# Select Minimum / Maximum

Goal: Find the minimum/maximum object in an unsorted array.

## Maximum or minimum

We have an array of generic objects and we iterate over all the objects keeping track of the minimum/maximum element so far.

### An example

Let's say the we want to find the maximum value in the unsorted list `[ 8, 3, 9, 4, 6 ]`.

Pick the first number, `8`, and store it as the maximum element so far.

Pick the next number from the list, `3`, and compare it to the current maximum. `3` is less than `8` so the maximum `8` does not change.

Pick the next number from the list, `9`, and compare it to the current maximum. `9` is greater than `8` so we store `9` as the maximum.

Repeat this process until the all elements in the list have been processed.

### The code

Here is a simple implementation in Swift:
*/

func _getMinMax<T: Comparable>(array: [T], getMin: Bool) -> T? {
	guard !array.isEmpty else {
		return nil
	}
	var temp = array
	var result = temp.removeFirst()
	for element in temp {
		let condition = getMin ? element < result : element > result
		result = condition ? element : result
	}
	return result
}


func minimum<T: Comparable>(array: [T]) -> T? {
	return _getMinMax(array, getMin: true)
}

func maximum<T: Comparable>(array: [T]) -> T? {
	return _getMinMax(array, getMin: false)
}
/*:

Put this code in a playground and test it like so:

*/
var array = [ 8, 3, 9, 4, 6 ]
minimum(array)   // This will return 3
maximum(array)   // This will return 9
/*:

### In the Swift standard library

The Swift library already contains an extension to `SequenceType` that returns the minimum/maximum element in a sequence.

*/
array = [ 8, 3, 9, 4, 6 ]
array.minElement()   // This will return 3
array.maxElement()   // This will return 9
/*:

## Maximum and minimum

To find both the maximum and minimum values contained in array while minimizing the number of comparisons we can compare the items in pairs.

### An example

Let's say the we want to find the minimum and maximum value in the unsorted list `[ 8, 3, 9, 6, 4 ]`.

Pick the first number, `8`, and store it as the minimum and maximum element so far.

Because we have an odd number of items we remove `8` from the list which leaves the pairs `[ 3, 9 ]` and `[ 6, 4 ]`.

Pick the next pair of numbers from the list, `[ 3, 9 ]`. Of these two numbers, `3` is the smaller one, so we compare `3` to the current minimum `8`, and we compare `9` to the current maximum `8`. `3` is less than `8` so the new minimum is `3`. `9` is greater than `8` so the new maximum is `9`.

Pick the next pair of numbers from the list, `[ 6, 4 ]`. Here, `4` is the smaller one, so we compare `4` to the current minimum `3`, and we compare `6` to the current maximum `9`. `4` is greater than `3` so the minimum does not change. `6` is less than `9` so the maximum does not change.

The result is a minimum of `3` and a maximum of `9`.

### The code

Here is a simple implementation in Swift:

*/
func minimumMaximum<T: Comparable>(array: [T]) -> (minimum: T?, maximum: T?) {
	return (_getMinMax(array, getMin: true), _getMinMax(array, getMin: false))
}
/*:

Put this code in a playground and test it like so:

*/
let result = minimumMaximum(array)
result.minimum   // This will return 3
result.maximum   // This will return 9

let empty = [Int]()
minimumMaximum(empty)
/*:

By picking elements in pairs and comparing their maximum and minimum with the running minimum and maximum we reduce the number of comparisons to 3 for every 2 elements.

## Performance

These algorithms run at **O(n)**. Each object in the array is compared with the running minimum/maximum so the time it takes is proportional to the array length.


***
[Previous](@previous) | [Next](@next)
*/
