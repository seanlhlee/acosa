# 二元組（Bit Set）

二元組（Bit Set）為*n*個位元的固定大小的序列。又稱為位元陣列或位元向量。

要存儲真假值可以使用`Bool`類別，但是，需要記住成千上萬個真假值呢？

假設是10,000個，可以建一個容量為10,000的`[Bool]`陣列，或使用10,000位元來代替。這樣的資料更為緊湊，對64位元的CPU而言，相當於160個`Int`型別的儲存空間。

對單個位元操作是有點棘手，可以用`BitSet`隱藏背後的工作。

## 實作

一個二元組（Bit Set）僅僅是一個對一個陣列包裝。該陣列不存儲所謂的位元｀bit｀個體位，而是用稱為"words"的整數儲存。`BitSet`的的主要工作是映射位元資料到正確的字。

```swift

public struct BitSet {
	private(set) public var size: Int
	
	private let N = 64
	public typealias Word = UInt64
	private(set) public var words: [Word]
	
	private let allOnes = ~Word()
	
	public init(size: Int) {
		precondition(size > 0)
		self.size = size
		
		let n = (size + (N-1)) / N
		words = .init(count: n, repeatedValue: 0)
	}
	
	/* 轉換某個位元的索引值為words陣列的索引及其位元遮罩(Int, Word) */
	private func indexOf(i: Int) -> (Int, Word) {
		precondition(i >= 0)
		precondition(i < size)
		let o = i / N
		let m = Word(i - o*N)
		return (o, 1 << m)
	}
	
	/* 回傳words陣列最後一元素的遮罩 */
	private func lastWordMask() -> Word {
		let diff = words.count*N - size
		if diff > 0 {
			// Set the highest bit that's still valid.
			let mask = 1 << Word(63 - diff)
			// Subtract 1 to turn it into a mask, and add the high bit back in.
			return mask | (mask - 1)
		} else {
			return allOnes
		}
	}
	
	/*
	如果容量（size）不是N的整數倍，需要清除沒有使用到的位元，否則在兩長度不相等的二元組（Bit Set）
	進行位元操作會產生錯誤
	*/
	private mutating func clearUnusedBits() {
		words[words.count - 1] &= lastWordMask()
	}
	
	/* 以索引值存取位元，如 bitset[99] = ... */
	public subscript(i: Int) -> Bool {
		get { return isSet(i) }
		set { if newValue { set(i) } else { clear(i) } }
	}
	
	/* 將索引值指定的位元其值設為1  */
	public mutating func set(i: Int) {
		let (j, m) = indexOf(i)
		words[j] |= m
	}
	
	/* 將所有位元都設為1 */
	public mutating func setAll() {
		for i in 0..<words.count {
			words[i] = allOnes
		}
		clearUnusedBits()
	}
	
	/* 將索引值指定的位元其值設為0 */
	public mutating func clear(i: Int) {
		let (j, m) = indexOf(i)
		words[j] &= ~m
	}
	
	/* 將所有位元都設為0 */
	public mutating func clearAll() {
		for i in 0..<words.count {
			words[i] = 0
		}
	}
	
	/* 將指定索引值位置的位元值倒置，0 變 1 或 1 變 0，並回傳其布林值 */
	public mutating func flip(i: Int) -> Bool {
		let (j, m) = indexOf(i)
		words[j] ^= m
		return (words[j] & m) != 0
	}
	
	/* 檢定指定索引值位置的位元值 1 (true) or 0 (false). */
	public func isSet(i: Int) -> Bool {
		let (j, m) = indexOf(i)
		return (words[j] & m) != 0
	}
	
	/*
	回傳位元值為1的位元數（數量），時間複雜度O(s)其中s為位元值為1的位元數
	*/
	public var cardinality: Int {
		var count = 0
		for var x in words {
			while x != 0 {
				let y = x & ~(x - 1)  // find lowest 1-bit
				x = x ^ y             // and erase it
				count += 1
			}
		}
		return count
	}
	
	/* 檢定是否所有位元均為1 */
	public func all1() -> Bool {
		for i in 0..<words.count - 1 {
			if words[i] != allOnes { return false }
		}
		return words[words.count - 1] == lastWordMask()
	}
	
	/* 檢定是有位元為1 */
	public func any1() -> Bool {
		for x in words {
			if x != 0 { return true }
		}
		return false
	}
	
	/* 檢定是否所有位元均為0 */
	public func all0() -> Bool {
		for x in words {
			if x != 0 { return false }
		}
		return true
	}
}

// MARK: - Equality

extension BitSet: Equatable { }

public func ==(lhs: BitSet, rhs: BitSet) -> Bool {
	return lhs.words == rhs.words
}

// MARK: - Hashing

extension BitSet: Hashable {
	/* Based on the hashing code from Java's BitSet. */
	public var hashValue: Int {
		var h = Word(1234)
		for i in words.count.stride(to: 0, by: -1) {
			h ^= words[i - 1] &* Word(i)
		}
		return Int((h >> 32) ^ h)
	}
}

// MARK: - Bitwise operations

extension BitSet: BitwiseOperationsType {
	public static var allZeros: BitSet {
		return BitSet(size: 64)
	}
}

private func copyLargest(lhs: BitSet, _ rhs: BitSet) -> BitSet {
	return (lhs.words.count > rhs.words.count) ? lhs : rhs
}

/*
注意: 所有的位元操作運算（bitwise operations），運算子的左右運算元可以是不同的位元數
傳回的新二元組（BitSet）是位元數多的，位元數較少的二元組會補0
當進行&（AND）位元操作時，會去除較多位元二元組的多出的位元部分
*/

public func &(lhs: BitSet, rhs: BitSet) -> BitSet {
	let m = max(lhs.size, rhs.size)
	var out = BitSet(size: m)
	let n = min(lhs.words.count, rhs.words.count)
	for i in 0..<n {
		out.words[i] = lhs.words[i] & rhs.words[i]
	}
	return out
}

public func |(lhs: BitSet, rhs: BitSet) -> BitSet {
	var out = copyLargest(lhs, rhs)
	let n = min(lhs.words.count, rhs.words.count)
	for i in 0..<n {
		out.words[i] = lhs.words[i] | rhs.words[i]
	}
	return out
}

public func ^(lhs: BitSet, rhs: BitSet) -> BitSet {
	var out = copyLargest(lhs, rhs)
	let n = min(lhs.words.count, rhs.words.count)
	for i in 0..<n {
		out.words[i] = lhs.words[i] ^ rhs.words[i]
	}
	return out
}

prefix public func ~(rhs: BitSet) -> BitSet {
	var out = BitSet(size: rhs.size)
	for i in 0..<rhs.words.count {
		out.words[i] = ~rhs.words[i]
	}
	out.clearUnusedBits()
	return out
}

// MARK: - Debugging

extension UInt64 {
	/* Writes the bits in little-endian order, LSB first. */
	public func bitsToString() -> String {
		var s = ""
		var n = self
		for _ in 1...64 {
			s += ((n & 1 == 1) ? "1" : "0")
			n >>= 1
		}
		return s
	}
}

extension BitSet: CustomStringConvertible {
	public var description: String {
		var s = ""
		for x in words {
			s += x.bitsToString() + " "
		}
		return s
	}
}
```

## 說明

`N`是`words`陣列中每個`word`的位元數。因為採用UInt64，所以是64位元。

```swift
var bits = BitSet(size: 140)
bits.indexOf(2)  // ( 0, 4)
bits.indexOf(127)  // ( 1, 9223372036854775808)
bits.setAll()
bits.all1()

1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
1111111111110000000000000000000000000000000000000000000000000000

bits.flip(1)
bits.clearAll()
bits.any1()
bits.flip(0)
bits.isSet(1)
bits.any1()
bits.words
```

上例`BitSet`配置一個儲存3個words的陣列，每個`word`有64位元總共是192位元。只使用到140位元。

> **注意：** 在`words`陣列中的第一個元素是尾數，陣列元素的排序是最低位元組在最低位元，最高位元組在最高位元，反序排列。（stored in little endian order）

## Looking up the bits

大部分`BitSet`的操作都以索引值當作傳入的參數，所以找到某個索引值的位元在`words`陣列中的哪個word是有必要的。`indexOf()`方法回傳陣列的索引與遮罩來實際表示該位元的位置。

例如`indexOf(2)`回傳`(0, 4)`，意義是bit 2在第一個元素(index 0)其遮罩是4。以2進位顯示遮罩如下：

`0010000000000000000000000000000000000000000000000000000000000000`

其中`1`的位置就是bit 2在第一個元素的位置

> **注意：** 請記得我採用的是little-endian order系統，Bit 0在最左邊，bit 63在最右邊。

另一例：`indexOf(127)`回傳為`(1, 9223372036854775808)`，這是第二個word的最後一個位元，其遮罩為：

`0000000000000000000000000000000000000000000000000000000000000001`

遮罩一定是64位元。每次都是看一整個word。

## 位元的讀寫（Setting and getting bits）

知道某個位元的位置後，要讀寫就容易了，若要將值設為1只要在word的位置，然後以遮罩和word進行位元操作`OR`，如果原值是0，(0 | 0 = 1 )，如果原值是1，(1 | 0 = 1 )，該位元就寫入1了。

`clear`將索引位置位元的值設為0：要將位元值設為0，這次用位元操作`AND`，以反遮罩和word進行位元操作`AND`，反遮罩即將所有位元值顛倒，`~00100000...0`成為`11011111...1`，意即位元位置為0而其他位置均為1。`&`的位元操作就使該位元設為0。

檢定某位元是否為1一樣用`AND`，但不相反遮罩。

加入`subscript`函式，對某位元讀寫的表達式會更簡易：
```swift
bits = BitSet(size: 140)
bits[2] = true
bits[99] = true
bits[128] = true
print(bits)
```

上段程式碼會印出如下：
```swift
0010000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000010000000000000000000000000000
1000000000000000000000000000000000000000000000000000000000000000
```
`flip()`其功能為倒置位元的原值，0->1或1->0。

一樣用位元操作來達成，以XOR來倒置原值，傳回的布林值為新值。

## 忽略未使用位元

大部分的`BitSet`函式都很容易實作，例如`clearAll()`功能為將所有位元設為0，與`setAll()`將所有位元設為1。然而需要注意一個小問題，當我們對每一個word的位元均設為1之後會是：
```swift
1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
```
這是不正確的，因為最後一個word的最後幾個位元是不使用的，應該要將那些位元設為0：

```swift
1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111111111111111111111111111
1111111111110000000000000000000000000000000000000000000000000000
```

現在192個位元都是1就變成140個位元是1了，事實上大部分情況下，最後一個word的最後幾個未使用位元都應該使其值為0。要設置那些未使用位元的值都是0可以使用`clearUnusedBits()`的輔助函式。若`BitSet`的大小不為`N`的整數倍，就在不使用的位元都設為0。不這樣做，兩個不同大小二元組的位元操作（bitwise operations）會有誤，之後會說明。

`clearUnusedBits()`函式中用到比較進階的位元操作，以下是分步解說，請特別留意：

1) `diff`是未使用到位元的數量，上例中為`3*64 - 140 = 52`

2) 建立一個最高位位元的遮罩：

`0000000000010000000000000000000000000000000000000000000000000000`

3) 減去1得到：

`1111111111100000000000000000000000000000000000000000000000000000`

再將最高位位置設回去1:

`1111111111110000000000000000000000000000000000000000000000000000`

現在有12個值為1的位元`140 - 2*64 = 12`.

4) 這樣最高位後面的為元都是0了

接下來說明當`BitSet`的大小不同時，若未使用位元未設為0會發生錯誤的情況。為了說明起見，我們採8位元的OR位元操作：
```swift
	10001111  size=4
	00100011  size=8
```
第一個我們只用前4位元，第二個為8位元，因此第一個實際上應該是`10000000`，假設我們未將無效位元設為0，這兩數的OR會如下：
```swift
	10001111
	00100011
	-------- OR
	10101111
```
這個結果是錯的，正確的應該是：
```swift
	10000000       unused bits set to 0 first!
	00100011
	-------- OR
	10100011
```
接著是`|`實作的說明：

注意，此處`|`是對整個二元組操作，而不僅是個別的位元。當兩個二元組大小不同時，需要額外的程序，將大小較大的複製到`out`變數，再與進行位元操作的部分相結合。範例如下：

```swift
var a = BitSet(size: 4)
a.setAll()
a[1] = false
a[2] = false
a[3] = false
print(a)

var b = BitSet(size: 8)
b[2] = true
b[6] = true
b[7] = true
print(b)

let c = a | b
print(c)        // 1010001100000000...0
```

其他位元操作AND（`&`）、XOR（`^`）與NOT（`~`）也以類似方式實作。

## 計算位元值為1的位元個數

要計算位元值為1的位元個數可以走訪陣列中的每一個位元，這是**O(n)**時間複雜度的計算，也有更聰明的方法。

當`x & ~(x - 1)`，會得到一個只有一個位元為1的值，此為x當中有1的最低位，一樣用8為元說明如下：（此例為little-endian order系統）

`00101101`

將其減1得到：

`11001101`

倒置所有位元：

`00110010`

與原數取AND位元操作：

00101101
00110010
-------- AND
00100000

最後得到原數當中有1的最低位，然後在與原數取XOR位元操作：

00101101
00100000
-------- XOR
00001101

這是原數將最低位設為0的結果，持續這樣到所有位元均為0，就可以計算出有多少位元是1，時間複雜度為**O(s)**其中**s**是位元的值為1的數目。

## 參考資料

[Bit Twiddling Hacks](http://graphics.stanford.edu/~seander/bithacks.html)

