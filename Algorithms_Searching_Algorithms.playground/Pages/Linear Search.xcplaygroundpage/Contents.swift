/*:
[Previous](@previous) | [Next](@next)
***
*/

import Foundation

func linearSearch<T: Equatable>(array: [T], _ object: T) -> Int? {
	for (index, obj) in array.enumerate() where obj == object {
		return index
	}
	return nil
}

let array = [5, 2, 4, 7]
linearSearch(array, 2) 	// This will return 1

/*:
***
[Previous](@previous) | [Next](@next)
*/
