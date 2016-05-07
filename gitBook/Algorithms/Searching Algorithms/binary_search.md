# 二元搜尋（Binary Search）

目標：快速查找出陣列中的目標元素

假設您有一陣列，要找出該陣列中是否含有目標元素，如果含有其索引值為何？大部分情形下，Swift內建的`indexOf()`函式非常好用。

```swift
let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]

numbers.indexOf(43)  // returns 15
```

根據Matthijs Hollemans的說法，Swift內建的`indexOf()`函式採用線性搜尋法（[Linear Search](gitBook/Algorithms/Searching Algorithms/linear_search.md)），其實作類似：
```swift
func linearSearch<T: Equatable>(a: [T], _ key: T) -> Int? {
  for i in 0 ..< a.count {
    if a[i] == key {
      return i
    }
  }
  return nil
}

linearSearch(numbers, 43)  // returns 15
```

這樣有什麼問題呢？`linearSearch()`函式的迴圈是從頭開始一項一項查找直到找到目標元素，最差情況下，陣列中不含有目標元素，卻仍進行逐一查找的工作。

平均而言，線性搜尋法會查找大約一半的元素，當元素很多時，將會很緩慢。

## 分而治之（Divide and conquer）

典型加速查找工作的方法是二元搜尋法（ *binary search*），訣竅是不斷將資料分半直到找到目標元素。

對一個大小為`n`的陣列，採用線性搜索效率為**O(n)**，而二元搜尋法為**O(log n)**。二元搜尋法查找百萬筆資料的陣列僅需20步（`log_2(1,000,000) = 19.9`）。而查找10億筆資料時也僅需30步。

聽起來很棒，但有一個問題，陣列必須排序過，通常來說這並不是大問題。

以下說明二元搜尋的運作方式：

- 將陣列分成兩半，判斷是否有目標元素（*search key*），判斷目標元素可能出現在陣列之左半部或右半部。 
- 透過事先排序，可以經由比較值`<`或`>`判斷哪半部可能含有目標元素（*search key*）。
- 如果目標元素（*search key*）可能在左半側，繼續將左半側資料分半，再判斷可能所在的部分。
- 一直重複上述過程直到找到目標元素。如果無法再細分更小的部分，代表陣列中並不包含目標元素。 

這樣的過程稱為分治法（*divide-and-conquer*），是一種快速縮小作業範圍的方式。

## 實作

以下是一個以遞迴的方式實作的Swift二元搜尋法：

```swift
// range參數預設值為陣列的全部範圍，用以方便一般之搜尋作業。
func binarySearch<T: Comparable>(key: T, inArray a: [T], range: Range<Int> = a.indices) -> Int? {
	// 如果出現這情況，表示目標元素不在陣列之中
	guard range.startIndex < range.endIndex else { return nil }
	// 計算如何切分陣列查找的範圍
	let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
	// 切分的位置點，剛好找到目標，回傳索引值。不是目標時才往下切分陣列
	guard a[midIndex] != key else { return midIndex }
	// 判斷目標元素是在左或右半側
	let range = a[midIndex] > key ? range.startIndex ..< midIndex : midIndex + 1 ..< range.endIndex
	return binarySearch(key, inArray: a, range: range)
}

let numbers = [5, 6, 12, 15, 18, 23, 29, 29, 31, 32, 37, 41, 46, 51, 54, 64, 73, 76, 89]

binarySearch(31, inArray: numbers)  // 8
binarySearch(43, inArray: numbers)  // nil
```

> **注意：** 搜尋的陣列`numbers`必須事先排序，未排序時此法失效。

I said that binary search works by splitting the array in half, but we don't actually create two new arrays. Instead, we keep track of these splits using a Swift `Range` object. Initially, this range covers the entire array, `0 ..< numbers.count`.  As we split the array, the range becomes smaller and smaller.

> **Note:** One thing to be aware of is that `range.endIndex` always points one beyond the last element. In the example, the range is `0..<19` because there are 19 numbers in the array, and so `range.startIndex = 0` and `range.endIndex = 19`. But in our array the last element is at index 18, not 19, since we start counting from 0. Just keep this in mind when working with ranges: the `endIndex` is always one more than the index of the last element.

## Stepping through the example

It might be useful to look at how the algorithm works in detail.

The array from the above example consists of 19 numbers and looks like this when sorted:

	[ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67 ]

We're trying to determine if the number `43` is in this array.

To split the array in half, we need to know the index of the object in the middle. That's determined by this line:

```swift
    let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
```

Initially, the range has `startIndex = 0` and `endIndex = 19`. Filling in these values, we find that `midIndex` is `0 + (19 - 0)/2 = 19/2 = 9`. It's actually `9.5` but because we're using integers, the answer is rounded down.

In the next figure, the `*` shows the middle item. As you can see, the number of items on each side is the same, so we're split right down the middle.

	[ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
                                      *

Now binary search will determine which half to use. The relevant section from the code is:

```swift
    if a[midIndex] > key {
      // use left half
    } else if a[midIndex] < key {
      // use right half
    } else {
      return midIndex
    }
```

In this case, `a[midIndex] = 29`. That's less than the search key, so we can safely conclude that the search key will never be in the left half of the array. After all, the left half only contains numbers smaller than `29`. Hence, the search key must be in the right half somewhere (or not in the array at all).

Now we can simply repeat the binary search, but on the array interval from `midIndex + 1` to `range.endIndex`:

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43, 47, 53, 59, 61, 67 ]

Since we no longer need to concern ourselves with the left half of the array, I've marked that with `x`'s. From now on we'll only look at the right half, which starts at array index 10.

We calculate the index of the new middle element: `midIndex = 10 + (19 - 10)/2 = 14`, and split the array down the middle again.

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
	                                                 *

As you can see, `a[14]` is indeed the middle element of the array's right half.

Is the search key greater or smaller than `a[14]`? It's smaller because `43 < 47`. This time we're taking the left half and ignore the larger numbers on the right:

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43 | x, x, x, x, x ]

The new `midIndex` is here:

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43 | x, x, x, x, x ]
	                                     *

The search key is greater than `37`, so continue with the right side:

	[ x, x, x, x, x, x, x, x, x, x | x, x | 41, 43 | x, x, x, x, x ]
	                                        *

Again, the search key is greater, so split once more and take the right side:

	[ x, x, x, x, x, x, x, x, x, x | x, x | x | 43 | x, x, x, x, x ]
	                                            *

And now we're done. The search key equals the array element we're looking at, so we've finally found what we were searching for: number `43` is at array index `13`. w00t!

It may have seemed like a lot of work, but in reality it only took four steps to find the search key in the array, which sounds about right because `log_2(19) = 4.23`. With a linear search, it would have taken 14 steps.

What would happen if we were to search for `42` instead of `43`? In that case, we can't split up the array any further. The `range.endIndex` becomes smaller than `range.startIndex`. That tells the algorithm the search key is not in the array and it returns `nil`.

> **Note:** Many implementations of binary search calculate `midIndex = (startIndex + endIndex) / 2`. This contains a subtle bug that only appears with very large arrays, because `startIndex + endIndex` may overflow the maximum number an integer can hold. This situation is unlikely to happen on a 64-bit CPU, but it definitely can on 32-bit machines.

## Iterative vs recursive

Binary search is recursive in nature because you apply the same logic over and over again to smaller and smaller subarrays. However, that does not mean you must implement `binarySearch()` as a recursive function. It's often more efficient to convert a recursive algorithm into an iterative version, using a simple loop instead of lots of recursive function calls.

Here is an iterative implementation of binary search in Swift:

```swift
func binarySearch<T: Comparable>(a: [T], key: T) -> Int? {
  var range = 0..<a.count
  while range.startIndex < range.endIndex {
    let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
    if a[midIndex] == key {
      return midIndex
    } else if a[midIndex] < key {
      range.startIndex = midIndex + 1
    } else {
      range.endIndex = midIndex
    }
  }
  return nil
}
```

As you can see, the code is very similar to the recursive version. The main difference is in the use of the `while` loop.

Use it like this:

```swift
let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]

binarySearch(numbers, key: 43)  // gives 13
```

## The end

Is it a problem that the array must be sorted first? It depends. Keep in mind that sorting takes time -- the combination of binary search plus sorting may be slower than doing a simple linear search. Binary search shines in situations where you sort just once and then do many searches.

See also [Wikipedia](https://en.wikipedia.org/wiki/Binary_search_algorithm).

*Written for Swift Algorithm Club by Matthijs Hollemans*
