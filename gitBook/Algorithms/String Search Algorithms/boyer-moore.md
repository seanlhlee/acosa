# Boyer-Moore字串搜尋法

目標：不加載Foundation，也不使用`NSString`中之`rangeOfString()` 函式，以純然Swift程式語言撰寫字串搜尋的演算法，意即實作擴展`String`型別的`indexOf(pattern: String)`方法，並回傳符合第一個被找到的索引值`String.Index`，或當找不到時回傳`nil`。例如：

```swift
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
```

> **注意：** 例子中的🐮索引值為6而非3，是因為Swift的字串使用了更多的記憶體來表示一個表情符號。`String.Index`的值並不重要，只是一個字串中指到正確字元位置的值。

[*字串暴力搜尋法（Brute-Force String Search）*](gitBook/Algorithms/String Search Algorithms/brute-force_string_search.md)可以達到目標要求，但非常沒有效率。實際上要達到功能要求，可以跳過許多的字元，不需對來源字串進行地毯式搜索。這種算法稱為[Boyer-Moore](https://en.wikipedia.org/wiki/Boyer–Moore_string_search_algorithm)演算法，已經存在很長一段時間，被認為是所有的字符串搜索算法的基準。

以下為以Swift實作的程式碼：

```swift
extension String {
	func indexOf(pattern: String) -> String.Index? {
		// 定義一個快取字元長度的變數，會用到很多次，若採每次計算代價很高。
		let patternLength = pattern.characters.count
		assert(patternLength > 0)
		assert(patternLength <= self.characters.count)
		// 建立一個跳過字元數的對照表（字典型別），當找到目標`pattern`中的字元時決定我們跳過的字元數。
		var skipTable = [Character: Int]()
		for (i, c) in pattern.characters.enumerate() {
			skipTable[c] = patternLength - i - 1
		}
		// 目標字串`pattern`的最後一個字元
		let p = pattern.endIndex.predecessor()
		let lastChar = pattern[p]
		// 由右至左掃描目標字串，定義最大跳過不找的字元數為  目標字串長度 - 1
		var i = self.startIndex.advancedBy(patternLength - 1)
		// 內部函式，針對目標字串反向查找是否有不匹配的字元即回傳`nil`，若完全匹配回傳索引值
		func backwards() -> String.Index? {
			var q = p
			var j = i
			while q > pattern.startIndex {
				j = j.predecessor()
				q = q.predecessor()
				if self[j] != pattern[q] { return nil }
			}
			return j
		}
		// 主迴圈，查找來源字串直到終了
		while i < self.endIndex {
			let c = self[i]
			// 判斷目前字元與目標字串最後一個字元是否相同？
			if c == lastChar {
				// 反向查找是否符合目標字串，符合時回傳索引值
				if let k = backwards() { return k }
				// 不符合繼續往後查找
				i = i.successor()
			} else {
				// 若目前字元與目標字串最後一個字元不同，則根據跳過字元數的對照表決定跳過的字數
				// 如果這個字元與目標字串中字源完全不相符，則可跳過整個目標字串的長度。
				// 若有相符的字元跳過的長度會少些
				i = i.advancedBy(skipTable[c] ?? patternLength)
			}
		}
		return nil
	}
}
```

這演算法類似在來源字串中找到匹配目標字串*最後*一個字元與之對齊的方式運行，運作方式如下：

	source string:  Hello, World
	search pattern: World
	                    ^

有三種可能性：

1. 找到相同的字元其為可能吻合的候選

2. 未找到相同字元，但與目標字串其他字元符合

3. 字元完全與目標字串不匹配

此例`o`和`d`不匹配，但`o`是目標陣列中的一個字元，表示可以跳過一部分字元不需比對。

	source string:  Hello, World
	search pattern:    World
	                       ^

現將來源字串與目標字串的`o`字元對齊，比較目標字串最後一個字源`d`對齊來源字串的`W`，不相符合，但`W`也出現在目標字串中，所以在跳過一些字元使兩個`W`對齊：

	source string:  Hello, World
	search pattern:        World
	                           ^

現在最後的兩個字元相符，為一個可能的解，因此採用反向暴力法確定是否與來源字串完全相符。

每次跳過的字元數由"跳過字元數的對照表"決定，此例的表如下：

	W: 4
	o: 3
	r: 2
	l: 1
	d: 0

匹配字元越靠近目標字元的尾端，可跳過的字元數越少，若某一字元在目標中出現兩次以上，跳過的自元數以離尾端近的為準。

> **注意：** 如果目標字串非常短，直接採用暴力字串搜尋法，以節省查找"跳過字元數的對照表"花費的時間。

## Boyer-Moore-Horspool字串搜尋法

為Boyer-Moore字串搜尋法變化而來，一樣使用`skipTable`來跳過一些字元，主要的不同在於如何查找到部分相同時的處理方式。在Boyer-Moore字串搜尋法中，當找到部分吻合時僅跳過一個字元，而Boyer-Moore-Horspool字串搜尋法在此情況下也使用"跳過字元數的對照表"。如下為Swift語言的實作：

```swift
extension String {
  public func indexOf(pattern: String) -> String.Index? {
    let patternLength = pattern.characters.count
    assert(patternLength > 0)
    assert(patternLength <= self.characters.count)

    var skipTable = [Character: Int]()
    for (i, c) in pattern.characters.dropLast().enumerate() {
      skipTable[c] = patternLength - i - 1
    }

    var index = self.startIndex.advancedBy(patternLength - 1)

    while index < self.endIndex {
      var i = index
      var p = pattern.endIndex.predecessor()

      while self[i] == pattern[p] {
        if p == pattern.startIndex { return i }
        i = i.predecessor()
        p = p.predecessor()
      }

      let advance = skipTable[self[index]] ?? patternLength
      index = index.advancedBy(advance)
    }

    return nil
  }
}
```

在實踐中，Horspool版效能上好一點點，但是你需要做出權衡。

Credits: This code is based on the article ["Faster String Searches" by Costas Menico](http://www.drdobbs.com/database/faster-string-searches/184408171) from Dr Dobb's magazine, July 1989 -- Yes, 1989! Sometimes it's useful to keep those old magazines around.

Credits: This code is based on the paper: [R. N. Horspool (1980). "Practical fast searching in strings". Software - Practice & Experience 10 (6): 501–506.](http://www.cin.br/~paguso/courses/if767/bib/Horspool_1980.pdf)

See also: [a detailed analysis](http://www.inf.fh-flensburg.de/lang/algorithmen/pattern/bmen.htm) of the algorithm.

*Written for Swift Algorithm Club by Matthijs Hollemans*
