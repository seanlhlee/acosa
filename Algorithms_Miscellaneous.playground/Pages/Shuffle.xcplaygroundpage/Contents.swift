/*:
[Next](@next)
***
# 洗牌

目標：重新排列陣列的內容。

想像一下，你正在做的紙牌遊戲需要洗牌，可以通過一個`Card`陣列代表一副牌，而洗牌代表需要把陣列中的牌重新改變次序，就像是排序的相反。以下是Swift的實作：

*/
import Foundation
public func random(n: Int) -> Int {
	return Int(arc4random_uniform(UInt32(n)))
}

extension Array {
	public mutating func shuffle_X() {
		var temp = [Element]()
		while !isEmpty {
			let i = random(count)
			let obj = removeAtIndex(i)
			temp.append(obj)
		}
		self = temp
	}
}

var list = [ "a", "b", "c", "d", "e", "f", "g" ]
list.shuffle_X()
list.shuffle_X()
list.shuffle_X()
/*

洗牌是*就地*執行的動作，直接修改原始陣列的內容。此演算法先建一個空陣列`temp`，然後從元陣列中亂數選取將其加入到`temp`中直到原始陣列為空。

> **注意** `random()`是一個輔助函式，回傳一個介於0到所指定的最大值間的一個亂數整數值。

此實作運作良好但缺乏效率，進行了**n** 次時間複雜度為**O(n)**的自陣列移除元素的操作，使此演算法總體效率為**O(n^2)**。應該可以再改善。

## 費雪耶茨/克努特洗牌（The Fisher-Yates / Knuth shuffle）

以下是一個改良版本的實作：

*/
extension Array {
	public mutating func shuffle() {
		for i in (count - 1).stride(through: 1, by: -1) {
			let j = random(i + 1)
			if i != j {
				swap(&self[i], &self[j])
			}
		}
	}
}
/*

一樣是隨機挑選，原始版本我們以新的陣列執行，改進版則是隨機挑選出來的牌放到陣列的後端。

> **注意：** 使用 `random(x)`時可能回傳的最大值為`x - 1`

請參考以下的示意：

	[ "a", "b", "c", "d", "e", "f", "g" ]

	[ "a", "b", "g", "d", "e", "f" | "c" ]

	[ "f", "b", "g", "d", "e" | "a", "c" ]

	[ "f", "b", "g", "e" | "d", "a", "c" ]

	⋯⋯

	[ "b" | "e", "f", "g", "d", "a", "c" ]

至此`"b"`已沒有位置交換，就完成了。

因為我們僅對陣列中的每個元素提取一次，其時間複雜度為 **O(n)**，比前版改善許多。

## 創造一個洗完牌的新陣列

以下是需要一個洗完牌的新陣列的實作：

*/
public func shuffledArray(n: Int) -> [Int] {
	var a = [Int](count: n, repeatedValue: 0)
	for i in 0..<n {
		let j = random(i + 1)
		if i != j {
			a[i] = a[j]
		}
		a[j] = i
	}
	return a
}

let numbers = shuffledArray(10)
/*:


## 參考資料

[維基百科：Fisher–Yates_shuffle](https://en.wikipedia.org/wiki/Fisher–Yates_shuffle)

***
[Next](@next)
*/
