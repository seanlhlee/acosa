/*:
[Next](@next)
***

# 字串暴力搜尋法（Brute-Force String Search）

如果不予許`import Foundation`也不能使用`NSString`中的`rangeOfString()`方法，您會如何以純Swift語言來寫一個字串搜尋的演算法呢？

本章節的目標是實作`String`類別的延伸功能`indexOf(pattern: String)`方法，使其可以回傳字串中第一個與目標`pattern`相符的索引值`String.Index`，或字串中無相符時回傳`nil`。

例如:

	// Input:
	let s = "Hello, World"
	s.indexOf("World")

	// Output:
	<String.Index?> 7

	// Input:
	let animals = "🐶🐔🐷🐮🐱"
	animals.indexOf("🐮")

	// Output:
	<String.Index?> 6

- note:
🐮的索引值為6而非3，因為每個表情符號字元儲存所需的位元數較一般字元大。String.Index回傳的數字並不是很重要，其代表的是該字元在字串的連續記憶體中的相對位置。以下為字串暴力搜尋法（Brute-Force String Search）的實作：
*/

extension String {
	func indexOf(pattern: String) -> Index? {
		let patternLength = Int(pattern.startIndex.distanceTo(pattern.endIndex))
		for i in self.startIndex ..< self.endIndex {
			if self[i..<i.advancedBy(patternLength, limit: self.endIndex)] == pattern {
				return i
			}
		}
		return nil
	}
}

let s = "Hello, World"
s.indexOf("World")	// 7

let animals = "🐶🐔🐷🐮🐱"
animals.indexOf("🐮")  // 6


/*:
此方法依序檢查字串中以每個字元起始，長度與目標相同的子字串是否相同，若有相符回傳當下的索引值，若無則繼續比對至迴圈結束，未找到回傳`nil`。

字串暴力搜尋法（Brute-Force String Search）的運作是可行的，然而效率並不好。請參考[*Boyer-Moore字串搜尋法*](Boyer-Moore "")為字串搜尋效率改善的一種演算法。

# 回傳字符數之字串暴力搜尋法（Brute-Force String Search）

額外介紹可以利用整數（第幾個字符）做為字串索引值，以方便利用下角標的方式存取字串的方法，並實作一個回傳以整數字符計算的方法：

*/
extension String {
	subscript(idx: Int) -> Character {
		get {
			let strIdx = self.startIndex.advancedBy(idx, limit: endIndex)
			guard strIdx != endIndex else { fatalError("String index out of bounds") }
			return self[strIdx]
		}
		set {
			self.removeAtIndex(startIndex.advancedBy(idx, limit: endIndex))
			self.insert(newValue, atIndex: startIndex.advancedBy(idx, limit: endIndex))
		}
	}
	// 增加回傳整數索引值的方法，此方法回傳值為第幾個字符
	func indexIntOf(pattern: String) -> Int? {
		if let strIdx = indexOf(pattern) {
			var i = 0
			while i < characters.count {
				if self.startIndex.advancedBy(i) == strIdx {
					return i
				}
				i += 1
			}
		}
		return nil
	}
}

animals.indexIntOf("🐮")  // 3
animals[3]

/*:
***
[Next](@next)
*/
