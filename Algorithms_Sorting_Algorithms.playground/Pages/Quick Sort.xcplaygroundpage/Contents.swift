/*:
[Previous](@previous) | [Next](@next)
***
# 快速排序法（Quicksort）

- note: 本文中以**a**來代表實作程式碼中的*array*

目標：將一個陣列中的元素由高到低（或高至低）排序。

快速排序法（Quicksort）是史上有名的演算法之一，於1959年由Tony Hoare所發明，在當時遞迴還是一個模糊的概念。以下是Swift實作，非常容易理解：
*/
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

/*:
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

![Example](Example.png)

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

分區的過程只確保在`pivot`分區後的子陣列中所有元素都大於或都小於`pivot`。這個分區過程是不穩定的，也就是最終的結果可能會使相同值的元素並不維持與未排序前相同的次序。（[合併排序法](Merge20%Sort)是穩定排序。）

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

- note: 在Swift語言裡，我們使用`(x, y) = (y, x)`這樣的表達式可以很方便地將純值資料`x`與`y`進行換位，也可以用`swap(&x, &y)`換位。

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

- note: 上述實作`partitionDutchFlag()`使用到一個客製化的函式`swap()`，用來針對陣列中的兩元素進行換位。

## 參考資料

[維基百科: Quicksort](https://en.wikipedia.org/wiki/Quicksort)



***
[Previous](@previous) | [Next](@next)
*/
