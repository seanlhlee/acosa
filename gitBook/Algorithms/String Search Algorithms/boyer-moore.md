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

Here's how you could write it in Swift:

```swift
extension String {
  func indexOf(pattern: String) -> String.Index? {
    // Cache the length of the search pattern because we're going to
    // use it a few times and it's expensive to calculate.
    let patternLength = pattern.characters.count
    assert(patternLength > 0)
    assert(patternLength <= self.characters.count)

    // Make the skip table. This table determines how far we skip ahead
    // when a character from the pattern is found.
    var skipTable = [Character: Int]()
    for (i, c) in pattern.characters.enumerate() {
      skipTable[c] = patternLength - i - 1
    }

    // This points at the last character in the pattern.
    let p = pattern.endIndex.predecessor()
    let lastChar = pattern[p]

    // The pattern is scanned right-to-left, so skip ahead in the string by
    // the length of the pattern. (Minus 1 because startIndex already points
    // at the first character in the source string.)
    var i = self.startIndex.advancedBy(patternLength - 1)

    // This is a helper function that steps backwards through both strings 
    // until we find a character that doesn’t match, or until we’ve reached
    // the beginning of the pattern.
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

    // The main loop. Keep going until the end of the string is reached.
    while i < self.endIndex {
      let c = self[i]

      // Does the current character match the last character from the pattern?
      if c == lastChar {

        // There is a possible match. Do a brute-force search backwards.
        if let k = backwards() { return k }

        // If no match, we can only safely skip one character ahead.
        i = i.successor()
      } else {
        // The characters are not equal, so skip ahead. The amount to skip is
        // determined by the skip table. If the character is not present in the
        // pattern, we can skip ahead by the full pattern length. However, if
        // the character *is* present in the pattern, there may be a match up
        // ahead and we can't skip as far.
        i = i.advancedBy(skipTable[c] ?? patternLength)
      }
    }
    return nil
  }
}
```

The algorithm works as follows. You line up the search pattern with the source string and see what character from the string matches the *last* character of the search pattern:

	source string:  Hello, World
	search pattern: World
	                    ^

There are three possibilities:

1. The two characters are equal. You've found a possible match.

2. The characters are not equal, but the source character does appear in the search pattern elsewhere.

3. The source character does not appear in the search pattern at all.

In the example, the characters `o` and `d` do not match, but `o` does appear in the search pattern. That means we can skip ahead several positions:

	source string:  Hello, World
	search pattern:    World
	                       ^

Note how the two `o` characters line up now. Again you compare the last character of the search pattern with the search text: `W` vs `d`. These are not equal but the `W` does appear in the pattern. So skip ahead again to line up those two `W` characters:

	source string:  Hello, World
	search pattern:        World
	                           ^

This time the two characters are equal and there is a possible match. To verify the match you do a brute-force search, but backwards, from the end of the search pattern to the beginning. And that's all there is to it.

The amount to skip ahead at any given time is determined by the "skip table", which is a dictionary of all the characters in the search pattern and the amount to skip by. The skip table in the example looks like:

	W: 4
	o: 3
	r: 2
	l: 1
	d: 0

The closer a character is to the end of the pattern, the smaller the skip amount. If a character appears more than once in the pattern, the one nearest to the end of the pattern determines the skip value for that character.

> **Note:** If the search pattern consists of only a few characters, it's faster to do a brute-force search. There's a trade-off between the time it takes to build the skip table and doing brute-force for short patterns.

Credits: This code is based on the article ["Faster String Searches" by Costas Menico](http://www.drdobbs.com/database/faster-string-searches/184408171) from Dr Dobb's magazine, July 1989 -- Yes, 1989! Sometimes it's useful to keep those old magazines around.

See also: [a detailed analysis](http://www.inf.fh-flensburg.de/lang/algorithmen/pattern/bmen.htm) of the algorithm.

## Boyer-Moore-Horspool algorithm

A variation on the above algorithm is the [Boyer-Moore-Horspool algorithm](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore%E2%80%93Horspool_algorithm).

Like the regular Boyer-Moore algorithm, it uses the `skipTable` to skip ahead a number of characters. The difference is in how we check partial matches. In the above version, if a partial match is found but it's not a complete match, we skip ahead by just one character. In this revised version, we also use the skip table in that situation.

Here's an implementation of the Boyer-Moore-Horspool algorithm:

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

In practice, the Horspool version of the algorithm tends to perform a little better than the original. However, it depends on the tradeoffs you're willing to make.

Credits: This code is based on the paper: [R. N. Horspool (1980). "Practical fast searching in strings". Software - Practice & Experience 10 (6): 501–506.](http://www.cin.br/~paguso/courses/if767/bib/Horspool_1980.pdf)

*Written for Swift Algorithm Club by Matthijs Hollemans*
