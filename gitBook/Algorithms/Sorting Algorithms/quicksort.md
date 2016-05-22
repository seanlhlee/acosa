# 快速排序法（Quicksort）

> **注意：** 本文中以**a**來代表實作程式碼中的*array*

目標：將一個陣列中的元素由高到低（或高至低）排序。

快速排序法（Quicksort）是史上有名的演算法之一，於1959年由Tony Hoare所發明，在當時遞迴還是一個模糊的概念。以下是Swift實作，非常容易理解：
```swift
func quicksort<T: Comparable>(array: [T]) -> [T] {
	guard array.count > 1 else { return array }
	let pivot = array[array.count/2]
	let less = array.filter { $0 < pivot }
	let equal = array.filter { $0 == pivot }
	let greater = array.filter { $0 > pivot }
	return quicksort(less) + equal + quicksort(greater)
}

var list = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
quicksort(list) // [-1, 0, 1, 2, 3, 5, 8, 8, 9, 10, 14, 26, 27]
```
說明如下，有一個未排序陣列，呼叫`quicksort()`時，會基於一個`pivot`的變數，將陣列分為三個部分，此處我們取的是位於陣列中央的元素。比`pivot`小的值放到一個稱為`less`的陣列，與`pivot`相等的放入`equal`陣列，比`pivot`大則放入`greater`陣列`quicksort()` 遞迴地排序`less`與`right`陣列，最後再將子陣列依序合併即可得到排序的結果。

## 例子

假設未排序陣列如下：

	[ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]

首先決定出做為`pivot`的元素，並將陣列基於`pivot`分成`less`、`equal`與`greater`三個子陣列：

	less:    [ 0, 3, 2, 1, 5, -1 ]
	equal:   [ 8, 8 ]
	greater: [ 10, 9, 14, 27, 26 ]

這是一個還不錯的分割方式，我們的挑選的pivot值正好使`less`與`greater`有相同個數的元素。
此處`less`與`greater`陣列都還未排序，所以要再呼叫`quicksort()`來排序子陣列，過程也如前述，選出`pivot`分成三個子陣列，再遞迴。

接著我們來看`less`子陣列：

	[ 0, 3, 2, 1, 5, -1 ]

取中間的元素`1`做為`pivot`並分三子陣列：

	less:    [ 0, -1 ]
	equal:   [ 1 ]
	greater: [ 3, 2, 5 ]

到此尚未完成排序，繼續遞迴呼叫`quicksort()`，我們再觀察`less`這個子陣列：

	[ 0, -1 ]

取中間的元素`-1`做為`pivot`並分三子陣列：

	less:    [ ]
	equal:   [ -1 ]
	greater: [ 0 ]

這次`less`子陣列空了而另兩個子陣列都只有一個元素，這代表我們無須再遞迴。接著我們排序前一個`greater`子陣列：

	[ 3, 2, 5 ]

取中間元素`2`為`pivot`與分三子陣列：

	less:    [ ]
	equal:   [ 2 ]
	greater: [ 3, 5 ]

到此還需要對`greater`子陣列排序一次。從此處，我們也可看出`pivot`的值，若不能很均等地使`less`與`greater`大小相當，將關鍵的影響到需要遞迴的次數。再對`greater`遞迴排序後得到：

	less:    [ 3 ]
	equal:   [ 5 ]
	greater: [ ]

這個程序一直持續到所有的子陣列無須再遞迴。我們可以下圖來說明正個完整的過程：

![Example](/gitBook/pics/Example.png)

現在由左至右將有顏色的格子依序排列，可以得到排序的陣列：

	[ -1, 0, 1, 2, 3, 5, 8, 8, 9, 10, 14, 26, 27 ]

可看出一開始的`8`是一個不錯的`pivot`值，他也正好位在排序後陣列的中央。還有更聰明的方式來切分陣列：

## 分區（Partitioning）

以`pivot`值劃分子陣列稱為*分區*，有幾種不同的分區方式。

假設原陣列為：

	[ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]

我們以中間元素`8`做為`pivot`:

	[ 0, 3, 2, 1, 5, -1  |  8, 8  |  10, 9, 14, 27, 26 ]

在分區後也可能長得像:

	[ 3, 0, 5, 2, -1, 1  |  8, 8  |  14, 26, 10, 27, 9 ]

分區的過程只確保在`pivot`分區後的子陣列中所有元素都大於或都小於`pivot`。這個分區過程是不穩定的，也就是最終的結果可能會使相同值的元素並不維持與未排序前相同的次序。（[合併排序法](merge_sort.md)是穩定排序。）

## Lomuto分區（Lomuto's partitioning scheme）

在一開始的例子，我們呼叫Swift的標準函式`filter()`三次來進行分區，其實很沒有效率。現在介紹一個修改原陣列進行*就地*分區的方式：

*/
func partitionLomuto<T: Comparable>(inout array: [T], low: Int, high: Int) -> Int {
	let pivot = array[high]
	
	var i = low
	for j in low..<high {
		if array[j] <= pivot {
			(array[i], array[j]) = (array[j], array[i])
			i += 1
		}
	}
	
	(array[i], array[high]) = (array[high], array[i])
	return i
}


list = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
var p = partitionLomuto(&list, low: 0, high: list.count - 1)
list  // [0, 3, 2, 1, 5, 8, -1, 8, 9, 10, 14, 26, 27]


/*:
注意，此處`list`需設為變數`var`使其可以做為`partitionLomuto()`的`inout`參數，會比建立一個新陣列有效率。`low`與`high`參數是需要的，因為此函式之後會做為快速排序法的內部輔助函式，過程會是越來越小的分區，而不會一直是整個陣列的分區。

Lomuto分區是以欲分區子陣列的最後一個元素*last*做為`pivot`其值為`a[high]`，分區之後的陣列是：

[ 0, 3, 2, 1, 5, 8, -1, 8, 9, 10, 14, 26, 27 ]

變數`p`為呼叫`partitionLomuto()`函式的回傳值7，此是`pivot`在新陣列的索引值。

左子陣列可視為索引值`[0...p-1]`的部分為`[ 0, 3, 2, 1, 5, 8, -1 ]`，右子陣列可視為索引值`[p+1..<count]`的部分為`[ 9, 10, 14, 26, 27 ]`。注意到`8`在陣列中不只一個，其中一個是在左側，這是一個Lomuto分區比較不好的地方，若陣列中重複的元素太多，會使排序變慢。

接著來看看Lomuto分區法的運作原理，注意到`for`迴圈的部分， loop. This loop divides the array into four regions:

1. `a[low...i]` 包含所有比pivot小的元素
2. `a[i+1...j-1]` 包含所有比pivot大的元素
3. `a[j...high-1]` 還未處理到的部分
4. `a[high]` 做為pivot的元素

意即：

	[ values <= pivot | values > pivot | not looked at yet | pivot ]
	low               i   i+1    j-1   j                 high-1   high

迴圈處理由`low`到`high-1`的元素，如果比較的元素值比pivot小或是相等就將其以換位方式放置第一區（values <= pivot）。

> **注意:** 在Swift語言裡，我們使用`(x, y) = (y, x)`這樣的表達式可以很方便地將純值資料`x`與`y`進行換位，也可以用`swap(&x, &y)`換位。

迴圈執行完成，`pivot`仍然在陣列的最後，因此最後一步我們將棋與大數部分的子陣列首個元素與其換位。

以下是個步驟的分解示意

	[| 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]

	[| 10 | 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]

	[ 0 | 10 | 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]

	[ 0, 3 | 10 | 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]

	[ 0, 3 | 10, 9 | 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]

	[ 0, 3, 2, 1, 5, 8, -1 | 27, 9, 10, 14, 26 | 8 ]

	[ 0, 3, 2, 1, 5, 8, -1 | 8 | 9, 10, 14, 26, 27 ]

最後回傳`pivot`元素的索引值。

接著以Lomuto分區方式來實作快速排序法：
*/
func quicksortLomuto<T: Comparable>(inout array: [T], low: Int, high: Int) {
	if low < high {
		let p = partitionLomuto(&array, low: low, high: high)
		quicksortLomuto(&array, low: low, high: p - 1)
		quicksortLomuto(&array, low: p + 1, high: high)
	}
}
/*:
這個實作很好理解，先呼叫`partitionLomuto()`得到pivot的索引值再遞迴呼叫`quicksortLomuto()`進行左端與右端的現地排序。

*/
list = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
quicksortLomuto(&list, low: 0, high: list.count - 1)
/*:

Lomuto分區方式算是比較容易理解的方法，接下來介紹更少換位的Hoare分區方式。

## Hoare分區（Hoare's partitioning scheme）

這個分區方式也是由快速排序法的發明者所提出。以下是Swift實作的程式碼：

*/
func partitionHoare<T: Comparable>(inout array: [T], low: Int, high: Int) -> Int {
	let pivot = array[low]
	var i = low - 1
	var j = high + 1
	
	while true {
		repeat { j -= 1 } while array[j] > pivot
		repeat { i += 1 } while array[i] < pivot
		
		if i < j {
			swap(&array[i], &array[j])
		} else {
			return j
		}
	}
}

list = [ 8, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, -1, 26 ]
p = partitionHoare(&list, low: 0, high: list.count - 1)
list  // [-1, 0, 3, 8, 2, 5, 1, 27, 10, 14, 9, 8, 26]
/*:

Hoare分區是以欲分區子陣列的第一個元素*first*做為`pivot`其值為`a[low]`，分區後的結果為：

	[ -1, 0, 3, 8, 2, 5, 1, 27, 10, 14, 9, 8, 26 ]

請注意，回傳值不需是分區後新陣列`pivot`的索引值。分區後區隔為`[low...p]`與`[p+1...high]`兩部分，回傳`p`變數的值是6，分區為`[ -1, 0, 3, 8, 2, 5, 1 ]`與`[ 27, 10, 14, 9, 8, 26 ]`兩部分。與`pivot`直相等的元素在兩個區中，但此演算法並不會告知會在哪一分區的哪個位置。因為分區方式的差異，實作快速排序法也有所不同：

*/
func quicksortHoare<T: Comparable>(inout array: [T], low: Int, high: Int) {
	if low < high {
		let p = partitionHoare(&array, low: low, high: high)
		quicksortHoare(&array, low: low, high: p)
		quicksortHoare(&array, low: p + 1, high: high)
	}
}
/*:

## 選擇一個好的pivot

Lomuto分區採最後一個元素，而Hoare分區採首個元素來作為`pivot`，都無法確保這項選擇是好的。以下是一個選到不好的情況，假設如下陣列：

	[ 7, 6, 5, 4, 3, 2, 1 ]

採用Lomuto分區`1`是`pivot`，分區後得到如下結果：

	less than pivot: [ ]
	equal to pivot: [ 1 ]
	greater than pivot: [ 7, 6, 5, 4, 3, 2 ]

接著進行遞迴排序過程如下：

	less than pivot: [ ]
	equal to pivot: [ 2 ]
	greater than pivot: [ 7, 6, 5, 4, 3 ]

	*************************************

	less than pivot: [ ]
	equal to pivot: [ 3 ]
	greater than pivot: [ 7, 6, 5, 4 ]

	*************************************

	持續..



可以看出來這非常糟。比較好的是分成大小相當的兩區。對這個例子來說`4`是比較好的選擇：

	less than pivot: [ 3, 2, 1 ]
	equal to pivot: [ 4 ]
	greater than pivot: [ 7, 6, 5 ]

理想上，*中位數*是最佳的選擇，然而未排序前很難知道*中位數*，是一個蛋生雞雞生蛋的問題。可用一點技巧來選擇較好的而不一定是最好的來作為`pivot`，此技巧是從三個元素中取最好的做為`pivot`值，或是亂數選擇作為`pivot`的元素。以下是亂數決定`pivot`元素的實作：

*/
func quicksortRandom<T: Comparable>(inout array: [T], low: Int, high: Int) {
	if low < high {
		let pivotIndex = random(min: low, max: high)         // 1
		
		(array[pivotIndex], array[high]) = (array[high], array[pivotIndex])  // 2
		
		let p = partitionLomuto(&array, low: low, high: high)
		quicksortRandom(&array, low: low, high: p - 1)
		quicksortRandom(&array, low: p + 1, high: high)
	}
}
/*:

與之前有兩個主要不同點：

1. `random(min:max:)`函式回傳`min...max`範圍之間的一個整數值作為選取`pivot`的索引值。

2. 因為Lomuto分區以`a[high]`作為`pivot`，因此需要以`a[pivotIndex]`替代`a[high]`再呼叫`partitionLomuto()`輔助函式。

取亂數值對於一個排序函數來說很奇怪，但此舉可讓快速排序法在各種情形下都表現的穩定，而避免了選取到不好的`pivots`使時間複雜度糟糕到**O(n^2)**，亂數可讓快速排序法的時間複雜度比較穩定地表現**O(n log n)**，這個效率在排序演算法中算很好。

## 荷蘭國旗分區（Dutch national flag partitioning）

還有一些最佳化的方法可以做。例如在之前說明中，分區後成為：

	[ values < pivot | values equal to pivot | values > pivot ]

當`pivot`的值在陣列中不只一個時，採用Lomuto分區或Hoare分區都會使效率降低。此處我們介紹一個荷蘭國旗分區法，其得名乃基於我們希望將分區結果分為三部分，可參見[荷蘭國旗](https://en.wikipedia.org/wiki/Flag_of_the_Netherlands)。其實作如下：

*/
func partitionDutchFlag<T: Comparable>(inout array: [T], low: Int, high: Int, pivotIndex: Int) -> (Int, Int) {
	let pivot = array[pivotIndex]
	
	var smaller = low
	var equal = low
	var larger = high
	
	while equal <= larger {
		if array[equal] < pivot {
			swap(&array, smaller, equal)
			smaller += 1
			equal += 1
		} else if array[equal] == pivot {
			equal += 1
		} else {
			swap(&array, equal, larger)
			larger -= 1
		}
	}
	return (smaller, larger)
}
/*:

運作方式與Lomuto分區法類似：

- `[low ... smaller-1]` 包含所有比pivot小的元素
- `[smaller ... equal-1]` 包含所有與pivot值相等的元素
- `[equal ... larger]` 包含所有比pivot大的元素
- `[larger ... high]` 還未處理到的部分

注意到此法並不預設一個固定作為`pivot`的位置，選擇可以自訂。使用範例如下：

*/
list = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
partitionDutchFlag(&list, low: 0, high: list.count - 1, pivotIndex: 10)
list  // show the results
/*:
我們依然選擇`8`作為`pivot`其結果是：

	[ -1, 0, 3, 2, 5, 1, 8, 8, 27, 14, 9, 26, 10 ]

兩個`8`位在陣列相鄰位置，`partitionDutchFlag()`回傳的值是`(6, 7)`，代表與`pivot`值相同的元素之位置索引值。 以此實作快速排序法：

*/
func quicksortDutchFlag<T: Comparable>(inout array: [T], low: Int, high: Int) {
	if low < high {
		let pivotIndex = random(min: low, max: high)
		let (p, q) = partitionDutchFlag(&array, low: low, high: high, pivotIndex: pivotIndex)
		quicksortDutchFlag(&array, low: low, high: p - 1)
		quicksortDutchFlag(&array, low: q + 1, high: high)
	}
}

/*:
使用荷蘭國旗分區法可以在陣列中有許多重複元素的情況下有較好的效率。

> **注意：** 上述實作`partitionDutchFlag()`使用到一個客製化的函式`swap()`，用來針對陣列中的兩元素進行換位。

## 參考資料

[維基百科: Quicksort](https://en.wikipedia.org/wiki/Quicksort)



***
[Previous](@previous) | [Next](@next)
*/





# Quicksort

Goal: Sort an array from low to high (or high to low).

Quicksort is one of the most famous algorithms in history. It was invented way back in 1959 by Tony Hoare, at a time when recursion was still a fairly nebulous concept.

Here's an implementation in Swift that should be easy to understand:

```swift
func quicksort<T: Comparable>(a: [T]) -> [T] {
  if a.count <= 1 {
    return a
  } else {
    let pivot = a[a.count/2]
    let less = a.filter { $0 < pivot }
    let equal = a.filter { $0 == pivot }
    let greater = a.filter { $0 > pivot }
    return quicksort(less) + equal + quicksort(greater)
  }
}
```

Put this code in a playground and test it like so:

```swift
let list = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
quicksort(list)
```

Here's how it works. When given an array, `quicksort()` splits it up into three parts based on a "pivot" variable. Here, the pivot is taken to be the element in the middle of the array (later on you'll see other ways to choose the pivot).

All the elements less than the pivot go into a new array called `less`. All the elements equal to the pivot go into the `equal` array. And you guessed it, all elements greater than the pivot go into the third array, `greater`. This is why the generic type `T` must be `Comparable`, so we can compare the elements with `<`, `==`, and `>`.

Once we have these three arrays, `quicksort()` recursively sorts the `less` array and the `right` array, then glues those sorted subarrays back together with the `equal` array to get the final result. 

## An example

Let's walk through the example. The array is initially:

	[ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]

First, we pick the pivot element. That is `8` because it's in the middle of the array. Now we split the array into the less, equal, and greater parts:

	less:    [ 0, 3, 2, 1, 5, -1 ]
	equal:   [ 8, 8 ]
	greater: [ 10, 9, 14, 27, 26 ]

This is a good split because `less` and `equal` roughly contain the same number of elements. So we've picked a good pivot that chopped the array right down the middle.

Note that the `less` and `greater` arrays aren't sorted yet, so we call `quicksort()` again to sort those two subarrays. That does the exact same thing: pick a pivot and split the subarray into three even smaller parts.

Let's just take a look at the `less` array:

	[ 0, 3, 2, 1, 5, -1 ]

The pivot element is the one in the middle, `1`. (You could also have picked `2`, it doesn't matter.) Again, we create three subarrays around the pivot:

	less:    [ 0, -1 ]
	equal:   [ 1 ]
	greater: [ 3, 2, 5 ]

We're not done yet and `quicksort()` again is called recursively on the `less` and `greater` arrays. Let's look at `less` again:

	[ 0, -1 ]

As pivot we pick `-1`. Now the subarrays are:

	less:    [ ]
	equal:   [ -1 ]
	greater: [ 0 ]

The `less` array is empty because there was no value smaller than `-1`; the other arrays contain a single element each. That means we're done at this level of the recursion, and we go back up to sort the previous `greater` array.

That `greater` array was:

	[ 3, 2, 5 ]
	
This works just the same way as before: we pick the middle element `2` as the pivot and fill up the subarrays:

	less:    [ ]
	equal:   [ 2 ]
	greater: [ 3, 5 ]

Note that here it would have been better to pick `3` as the pivot -- we would have been done sooner. But now we have to recurse into the `greater` array again to make sure it is sorted. This is why picking a good pivot is important. When you pick too many "bad" pivots, quicksort actually becomes really slow. More on that below.

When we partition the `greater` subarray, we find:

	less:    [ 3 ]
	equal:   [ 5 ]
	greater: [ ]

And now we're done at this level of the recursion because we can't split up the arrays any further.

This process repeats until all the subarrays have been sorted. In a picture:

![Example](/gitBook/pics/Example.png)

Now if you read the colored boxes from left to right, you get the sorted array:

	[ -1, 0, 1, 2, 3, 5, 8, 8, 9, 10, 14, 26, 27 ]

This shows that `8` was a good initial pivot because it appears in the middle of the sorted array too.

I hope this makes the basic principle clear of how quicksort works. Unfortunately, this version of quicksort isn't very quick, because we `filter()` the same array three times. There are more clever ways to split up the array.

## Partitioning

Dividing the array around the pivot is called *partitioning* and there are a few different partitioning schemes.

If the array is,

	[ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]

and we choose the middle element `8` as a pivot then after partitioning the array will look like this:

	[ 0, 3, 2, 1, 5, -1, 8, 8, 10, 9, 14, 27, 26 ]
	  -----------------        -----------------
	  all elements < 8         all elements > 8

The key thing to realize is that after partitioning the pivot element is in its final sorted place already. The rest of the numbers are not sorted yet, they are simply partitioned around the pivot value. Quicksort partitions the array many times over, until all the values are in their final places.

There is no guarantee that partitioning keeps the elements in the same relative order, so after partitioning around pivot `8` you could also end up with something like this:

	[ 3, 0, 5, 2, -1, 1, 8, 8, 14, 26, 10, 27, 9 ]

The only guarantee is that to the left of the pivot are all the smaller elements and to the right are all the larger elements. Because partitioning can change the original order of equal elements, quicksort does not produce a "stable" sort (unlike [merge sort](../Merge Sort/), for example). Most of the time that's not a big deal.

## Lomuto's partitioning scheme

In the first example of quicksort I showed you, partitioning was done by calling Swift's `filter()` function three times. That is not very efficient. So let's look at a smarter partitioning algorithm that works *in place*, i.e. by modifying the original array.

Here's an implementation of Lomuto's partitioning scheme in Swift:

```swift
func partitionLomuto<T: Comparable>(inout a: [T], low: Int, high: Int) -> Int {
  let pivot = a[high]
  
  var i = low
  for j in low..<high {
    if a[j] <= pivot {
      (a[i], a[j]) = (a[j], a[i])
      i += 1
    }
  }
  
  (a[i], a[high]) = (a[high], a[i])
  return i
}
```

To test this in a playground, do:

```swift
var list = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
let p = partitionLomuto(&list, low: 0, high: list.count - 1)
list  // show the results
```

Note that `list` needs to be a `var` because `partitionLomuto()` directly changes the contents of the array (it is passed as an `inout` parameter). That is much more efficient than allocating a new array object.

The `low` and `high` parameters are necessary because when this is used inside quicksort, you don't always want to (re)partition the entire array, only a limited range that becomes smaller and smaller.

Previously we used the middle array element as the pivot but it's important to realize that the Lomuto algorithm always uses the *last* element, `a[high]`, for the pivot. Because we've been pivoting around `8` all this time, I swapped the positions of `8` and `26` in the example so that `8` is at the end of the array and is used as the pivot value here too.

After partitioning, the array looks like this:

	[ 0, 3, 2, 1, 5, 8, -1, 8, 9, 10, 14, 26, 27 ]
	                        *

The variable `p` contains the return value of the call to `partitionLomuto()` and is 7. This is the index of the pivot element in the new array (marked with a star).

The left partition goes from 0 to `p-1` and is `[ 0, 3, 2, 1, 5, 8, -1 ]`. The right partition goes from `p+1` to the end, and is `[ 9, 10, 14, 26, 27 ]` (the fact that the right partition is already sorted is a coincidence). 

You may notice something interesting... The value `8` occurs more than once in the array. One of those `8`s did not end up neatly in the middle but somewhere in the left partition. That's a small downside of the Lomuto algorithm as it makes quicksort slower if there are a lot of duplicate elements.

So how does the Lomuto algorithm actually work? The magic happens in the `for` loop. This loop divides the array into four regions:

1. `a[low...i]` contains all values <= pivot
2. `a[i+1...j-1]` contains all values > pivot
3. `a[j...high-1]` are values we haven't looked at yet
4. `a[high]` is the pivot value

In ASCII art the array is divided up like this:

	[ values <= pivot | values > pivot | not looked at yet | pivot ]
	  low           i   i+1        j-1   j          high-1   high

The loop looks at each element from `low` to `high-1` in turn. If the value of the current element is less than or equal to the pivot, it is moved into the first region using a swap.

> **Note:** In Swift, the notation `(x, y) = (y, x)` is a convenient way to perform a swap between the values of `x` and `y`. You can also write `swap(&x, &y)`.

After the loop is over, the pivot is still the last element in the array. So we swap it with the first element that is greater than the pivot. Now the pivot sits between the <= and > regions and the array is properly partitioned.

Let's step through the example. The array we're starting with is:

	[| 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	   low                                       high
	   i
	   j

Initially, the "not looked at" region stretches from index 0 to 11. The pivot is at index 12. The "values <= pivot" and "values > pivot" regions are empty, because we haven't looked at any values yet.

Look at the first value, `10`. Is this smaller than the pivot? No, skip to the next element.	  

	[| 10 | 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	   low                                        high
	   i
	       j

Now the "not looked at" region goes from index 1 to 11, the "values > pivot" region contains the number `10`, and "values <= pivot" is still empty.

Look at the second value, `0`. Is this smaller than the pivot? Yes, so swap `10` with `0` and move `i` ahead by one.

	[ 0 | 10 | 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	  low                                         high
	      i
	           j

Now "not looked at" goes from index 2 to 11, "values > pivot" still contains `10`, and "values <= pivot" contains the number `0`.

Look at the third value, `3`. This is smaller than the pivot, so swap it with `10` to get:

	[ 0, 3 | 10 | 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	  low                                         high
	         i
	             j

The "values <= pivot" region is now `[ 0, 3 ]`. Let's do one more... `9` is greater than the pivot, so simply skip ahead:

	[ 0, 3 | 10, 9 | 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	  low                                         high
	         i
	                 j

Now the "values > pivot" region contains `[ 10, 9 ]`. If we keep going this way, then eventually we end up with:

	[ 0, 3, 2, 1, 5, 8, -1 | 27, 9, 10, 14, 26 | 8 ]
	  low                                        high
	                         i                   j

The final thing to do is to put the pivot into place by swapping `a[i]` with `a[high]`:

	[ 0, 3, 2, 1, 5, 8, -1 | 8 | 9, 10, 14, 26, 27 ]
	  low                                       high
	                         i                  j

And we return `i`, the index of the pivot element.

> **Note:** If you're still not entirely clear on how the algorithm works, I suggest you play with this in the playground to see exactly how the loop creates these four regions.

Let's use this partitioning scheme to build quicksort. Here's the code:

```swift
func quicksortLomuto<T: Comparable>(inout a: [T], low: Int, high: Int) {
  if low < high {
    let p = partitionLomuto(&a, low: low, high: high)
    quicksortLomuto(&a, low: low, high: p - 1)
    quicksortLomuto(&a, low: p + 1, high: high)
  }
}
```

This is now super simple. We first call `partitionLomuto()` to reorder the array around the pivot (which is always the last element from the array). And then we call `quicksortLomuto()` recursively to sort the left and right partitions.

Try it out:

```swift
var list = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
quicksortLomuto(&list, low: 0, high: list.count - 1)
```

Lomuto's isn't the only partitioning scheme but it's probably the easiest to understand. It's not as efficient as Hoare's scheme, which requires fewer swap operations.

## Hoare's partitioning scheme

This partitioning scheme is by Hoare, the inventor of quicksort.

Here is the code:

```Swift
func partitionHoare<T: Comparable>(inout a: [T], low: Int, high: Int) -> Int {
  let pivot = a[low]
  var i = low - 1
  var j = high + 1
  
  while true {
    repeat { j -= 1 } while a[j] > pivot
    repeat { i += 1 } while a[i] < pivot
    
    if i < j {
      swap(&a[i], &a[j])
    } else {
      return j
    }
  }
}
```

To test this in a playground, do:

```swift
var list = [ 8, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, -1, 26 ]
let p = partitionHoare(&list, low: 0, high: list.count - 1)
list  // show the results
```

Note that with Hoare's scheme, the pivot is always expected to be the *first* element in the array, `a[low]`. Again, we're using `8` as the pivot element.

The result is:

	[ -1, 0, 3, 8, 2, 5, 1, 27, 10, 14, 9, 8, 26 ]

Note that this time the pivot isn't in the middle at all. Unlike with Lomuto's scheme, the return value is not necessarily the index of the pivot element in the new array. 

Instead, the array is partitioned into the regions `[low...p]` and `[p+1...high]`. Here, the return value `p` is 6, so the two partitions are `[ -1, 0, 3, 8, 2, 5, 1 ]` and `[ 27, 10, 14, 9, 8, 26 ]`. 

The pivot is placed somewhere inside one of the two partitions, but the algorithm doesn't tell you which one or where. If the pivot value occurs more than once, then some instances may appear in the left partition and others may appear in the right partition.

Because of these differences, the implementation of Hoare's quicksort is slightly different:

```swift
func quicksortHoare<T: Comparable>(inout a: [T], low: Int, high: Int) {
  if low < high {
    let p = partitionHoare(&a, low: low, high: high)
    quicksortHoare(&a, low: low, high: p)
    quicksortHoare(&a, low: p + 1, high: high)
  }
}
```

I'll leave it as an exercise for the reader to figure out exactly how Hoare's partitioning scheme works. :-)

## Picking a good pivot

Lomuto's partitioning scheme always chooses the last array element for the pivot. Hoare's scheme uses the first element. But there is no guarantee that these pivots are any good.

Here is what happens when you pick a bad value for the pivot. Let's say the array is,

	[ 7, 6, 5, 4, 3, 2, 1 ]

and we're using Lomuto's scheme. The pivot is the last element, `1`. After pivoting, we have the following arrays:

	   less than pivot: [ ]
	    equal to pivot: [ 1 ]
	greater than pivot: [ 7, 6, 5, 4, 3, 2 ]

Now recursively partition the "greater than" subarray and get:

	   less than pivot: [ ]
	    equal to pivot: [ 2 ]
	greater than pivot: [ 7, 6, 5, 4, 3 ]

And again:

	   less than pivot: [ ]
	    equal to pivot: [ 3 ]
	greater than pivot: [ 7, 6, 5, 4 ]

And so on...

That's no good, because this pretty much reduces quicksort to the much slower insertion sort. For quicksort to be efficient, it needs to split the array into roughly two halves. 

The optimal pivot for this example would have been `4`, so we'd get:

	   less than pivot: [ 3, 2, 1 ]
	    equal to pivot: [ 4 ]
	greater than pivot: [ 7, 6, 5 ]

You might think this means we should always choose the middle element rather than the first or the last, but imagine what happens in the following situation:

	[ 7, 6, 5, 1, 4, 3, 2 ]

Now the middle element is `1` and that gives the same lousy results as in the previous example.

Ideally, the pivot is the *median* element of the array that you're partitioning, i.e. the element that sits in the middle of the sorted array. Of course, you won't know what the median is until after you've sorted the array, so this is a bit of a chicken-and-egg problem. However, there are some tricks to choose good, if not ideal, pivots.

One trick is "median-of-three", where you find the median of the first, middle, and last element in this subarray. In theory that often gives a good approximation of the true median.

Another common solution is to choose the pivot randomly. Sometimes this may result in choosing a suboptimal pivot but on average this gives very good results.

Here is how you can do quicksort with a randomly chosen pivot:

```swift
func quicksortRandom<T: Comparable>(inout a: [T], low: Int, high: Int) {
  if low < high {
    let pivotIndex = random(min: low, max: high)         // 1

    (a[pivotIndex], a[high]) = (a[high], a[pivotIndex])  // 2

    let p = partitionLomuto(&a, low: low, high: high)
    quicksortRandom(&a, low: low, high: p - 1)
    quicksortRandom(&a, low: p + 1, high: high)
  }
}
```

There are two important differences with before:

1. The `random(min:max:)` function returns an integer in the range `min...max`, inclusive. This is our pivot index.

2. Because the Lomuto scheme expects `a[high]` to be the pivot entry, we swap `a[pivotIndex]` with `a[high]` to put the pivot element at the end before calling `partitionLomuto()`.

It may seem strange to use random numbers in something like a sorting function, but it is necessary to make quicksort behave efficiently under all circumstances. With bad pivots, the performance of quicksort can be quite horrible, **O(n^2)**. But if you choose good pivots on average, for example by using a random number generator, the expected running time becomes **O(n log n)**, which is as good as sorting algorithms get.

## Dutch national flag partitioning

But there are more improvements to make! In the first example of quicksort I showed you, we ended up with an array that was partitioned like this:

	[ values < pivot | values equal to pivot | values > pivot ]

But as you've seen with the Lomuto partitioning scheme, if the pivot occurs more than once the duplicates end up in the left half. And with Hoare's scheme the pivot can be all over the place. The solution to this is "Dutch national flag" partitioning, named after the fact that the [Dutch flag](https://en.wikipedia.org/wiki/Flag_of_the_Netherlands) has three bands just like we want to have three partitions.

The code for this scheme is:

```swift
func partitionDutchFlag<T: Comparable>(inout a: [T], low: Int, high: Int, pivotIndex: Int) -> (Int, Int) {
  let pivot = a[pivotIndex]

  var smaller = low
  var equal = low
  var larger = high

  while equal <= larger {
    if a[equal] < pivot {
      swap(&a, smaller, equal)
      smaller += 1
      equal += 1
    } else if a[equal] == pivot {
      equal += 1
    } else {
      swap(&a, equal, larger)
      larger -= 1
    }
  }
  return (smaller, larger)
}
```

This works very similarly to the Lomuto scheme, except that the loop partitions the array into four (possibly empty) regions:

- `[low ... smaller-1]` contains all values < pivot
- `[smaller ... equal-1]` contains all values == pivot
- `[equal ... larger]` contains all values > pivot
- `[larger ... high]` are values we haven't looked at yet

Note that this doesn't assume the pivot is in `a[high]`. Instead, you have to pass in the index of the element you wish to use as a pivot.

An example of how to use it:

```swift
var list = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
partitionDutchFlag(&list, low: 0, high: list.count - 1, pivotIndex: 10)
list  // show the results
```

Just for fun, we're giving it the index of the other `8` this time. The result is:

	[ -1, 0, 3, 2, 5, 1, 8, 8, 27, 14, 9, 26, 10 ]

Notice how the two `8`s are in the middle now. The return value from `partitionDutchFlag()` is a tuple, `(6, 7)`. This is the range that contains the pivot value(s).

Here is how you would use it in quicksort:

```swift
func quicksortDutchFlag<T: Comparable>(inout a: [T], low: Int, high: Int) {
  if low < high {
    let pivotIndex = random(min: low, max: high)
    let (p, q) = partitionDutchFlag(&a, low: low, high: high, pivotIndex: pivotIndex)
    quicksortDutchFlag(&a, low: low, high: p - 1)
    quicksortDutchFlag(&a, low: q + 1, high: high)
  }
}
```

Using Dutch flag partitioning makes for a more efficient quicksort if the array contains many duplicate elements. (And I'm not just saying that because I'm Dutch!)

> **Note:** The above implementation of `partitionDutchFlag()` uses a custom `swap()` routine for swapping the contents of two array elements. Unlike Swift's own `swap()`, this doesn't give an error when the two indices refer to the same array element. See [Quicksort.swift](Quicksort.swift) for the code.

## See also

[Quicksort on Wikipedia](https://en.wikipedia.org/wiki/Quicksort)

*Written for Swift Algorithm Club by Matthijs Hollemans*
