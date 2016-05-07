# 插入排序法(Insertion Sort)

目標：將一個陣列中的元素由高到低(或高至低)排序。插入排序法的運作方式如下：

- 放入一堆沒有順序的元素
- 從這堆中取出一個
- 在新的陣列中加入此元素 
- 在未排序的堆中再取出一個元素，依據與第一個元素比較關係，決定放入新的陣列中之位置。
- 再次取出元素並插入新陣列中依排序規則適當的位置
- 持續進行上述步驟直到無序堆中已無元素

從上述步驟，是取出元素並插入到一個排序陣列的適當位置中，因此稱為插入排序法(Insertion Sort)。 

## 例子

一堆未排序的資料集合`[ 8, 3, 5, 4, 6 ]`。

從中取出第一個元素`8`加入到新的陣列中。排序陣列為`[ 8 ]`，無序集合為`[ 3, 5, 4, 6 ]`。

取出下一個元素`3`將其插入到排序陣列，因為比`8`小，因此將其放置在`8`之前，排序陣列現為`[ 3, 8 ]`，無序集合為`[ 5, 4, 6 ]`。

再取出下一個元素`5`，因為比`3`大且比`8`小，故將其插入到之間的位置。排序陣列現為`[ 3, 5, 8 ]`，無序集合為`[ 4, 6 ]`。

重複這個過程直到無序集合已空。

## 就地排序

由上述說明中，我們需要一個未排序與一個排序過的陣列。也可以藉由分開陣列中已排序與未排序的部分來進行就地排序，如此無需新增一個新陣列。

在上述的例子中，一開始是`[ 8, 3, 5, 4, 6 ]`，我們以`|`來區隔已排序與未排序的部分：

	[| 8, 3, 5, 4, 6 ]

上述表示，已排序部分為空，而未排序部分的第一個元素為`8`，隨著過程進行，陣列為：

	[ 8 | 3, 5, 4, 6 ]

已排序部分為`[ 8 ]`，未排序部分為`[ 3, 5, 4, 6 ]`，分個符號`|`向右位移了一個位置。完整過程的示意如下：

	[| 8, 3, 5, 4, 6 ]
	[ 8 | 3, 5, 4, 6 ]
	[ 3, 8 | 5, 4, 6 ]
	[ 3, 5, 8 | 4, 6 ]
	[ 3, 4, 5, 8 | 6 ]
	[ 3, 4, 5, 6, 8 |]

過程中每個步驟，符號`|`均往右移一格，直到右側未排序部分已空。

## 如何插入

每個步驟中，我們都是取出未排序部分的第一個元素，將其插入到已排序部分適當的位置，而插入適當的位置是如何運作的？

假設我們已經完成一部分步驟：

	[ 3, 5, 8 | 4, 6 ]

下一個要處理的是`4`，我們要將其插入到`[ 3, 5, 8 ]`適當的位置處。在此之前的元素為 `8`。

	[ 3, 5, 8, 4 | 6 ]
	        ^
	        
該元素比`4`大，所以`4`應該被放在`8`之前，因此交換(swap)兩者的位置：

	[ 3, 5, 4, 8 | 6 ]
	        <-->
	       swapped

再往前一個元素為`5`以比`4`大，要再交換位置：

	[ 3, 4, 5, 8 | 6 ]
	     <-->
	    swapped

依序往前為`3`，比`4`小代表現在我們已經排序好`4`的位置了。

上面描述的即是插入排序法內層的迴圈，依照交換(swap)位置的方式來達成排序的效果。

## 實作

以下為插入排序法(insertion sort)的Swift實作：
```swift
func insertionSort<T>(array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
	var a = array
	for x in 1..<a.count {
		var y = x
		while y > 0 && !isOrderedBefore(a[y - 1], a[y]) {
			swap(&a[y], &a[y - 1])
			y -= 1
		}
	}
	return a
}
```

Put this code in a playground and test it like so:

```swift
let list = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
insertionSort(list)
```

Here is how the code works.

1. Make a copy of the array. This is necessary because we cannot modify the contents of the `array` parameter directly. Like Swift's own `sort()`, the `insertionSort()` function will return a sorted *copy* of the original array.

2. There are two loops inside this function. The outer loop looks at each of the elements in the array in turn; this is what picks the top-most number from the pile. The variable `x` is the index of where the sorted portion ends and the pile begins (the position of the `|` bar). Remember, at any given moment the beginning of the array -- from index 0 up to `x` -- is always sorted. The rest, from index `x` until the last element, is the unsorted pile.

3. The inner loop looks at the element at position `x`. This is the number at the top of the pile, and it may be smaller than any of the previous elements. The inner loop steps backwards through the sorted array; every time it finds a previous number that is larger, it swaps them. When the inner loop completes, the beginning of the array is sorted again, and the sorted portion has grown by one element.

> **Note:** The outer loop starts at index 1, not 0. Moving the very first element from the pile to the sorted portion doesn't actually change anything, so we might as well skip it. 

## No more swaps

The above version of insertion sort works fine, but it can be made a tiny bit faster by removing the call to `swap()`. 

You've seen that we swap numbers to move the next element into its sorted position:

	[ 3, 5, 8, 4 | 6 ]
	        <-->
            swap
	        
	[ 3, 5, 4, 8 | 6 ]
         <-->
	     swap

Instead of swapping with each of the previous elements, we can just shift all those elements one position to the right, and then copy the new number into the right position.

	[ 3, 5, 8, 4 | 6 ]   remember 4
	           *
	
	[ 3, 5, 8, 8 | 6 ]   shift 8 to the right
	        --->
	        
	[ 3, 5, 5, 8 | 6 ]   shift 5 to the right
	     --->
	     
	[ 3, 4, 5, 8 | 6 ]   copy 4 into place
	     *

In code that looks like this:

```swift
func insertionSort(array: [Int]) -> [Int] {
  var a = array
  for x in 1..<a.count {
    var y = x
    let temp = a[y]
    while y > 0 && temp < a[y - 1] {
      a[y] = a[y - 1]                // 1
      y -= 1
    }
    a[y] = temp                      // 2
  }
  return a
}
```

The line at `//1` is what shifts up the previous elements by one position. At the end of the inner loop, `y` is the destination index for the new number in the sorted portion, and the line at `//2` copies this number into place.

## Making it generic

It would be nice to sort other things than just numbers. We can make the datatype of the array generic and use a user-supplied function (or closure) to perform the less-than comparison. This only requires two changes to the code.

The function signature becomes:

```swift
func insertionSort<T>(array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
```

The array has type `[T]` where `T` is the placeholder type for the generics. Now `insertionSort()` will accept any kind of array, whether it contains numbers, strings, or something else.

The new parameter `isOrderedBefore: (T, T) -> Bool` is a function that takes two `T` objects and returns true if the first object comes before the second, and false if the second object should come before the first. This is exactly what Swift's built-in `sort()` function does.

The only other change is in the inner loop, which now becomes:

```swift
      while y > 0 && isOrderedBefore(temp, a[y - 1]) {
```

Instead of writing `temp < a[y - 1]`, we call the `isOrderedBefore()` function. It does the exact same thing, except we can now compare any kind of object, not just numbers.

To test this in a playground, do:

```swift
let numbers = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
insertionSort(numbers, <)
insertionSort(numbers, >)
```

The `<` and `>` determine the sort order, low-to-high and high-to-low, respectively.

Of course, you can also sort other things such as strings,

```swift
let strings = [ "b", "a", "d", "c", "e" ]
insertionSort(strings, <)
```

or even more complex objects:

```swift
let objects = [ obj1, obj2, obj3, ... ]
insertionSort(objects) { $0.priority < $1.priority }
```

The closure tells `insertionSort()` to sort on the `priority` property of the objects.

Insertion sort is a *stable* sort. A sort is stable when elements that have identical sort keys remain in the same relative order after sorting. This is not important for simple values such as numbers or strings, but it is important when sorting more complex objects. In the example above, if two objects have the same `priority`, regardless of the values of their other properties, those two objects don't get swapped around.

## Performance

Insertion sort is really fast if the array is already sorted. That sounds obvious, but this is not true for all search algorithms. In practice, a lot of data will already be largely -- if not entirely -- sorted and insertion sort works quite well in that case.

The worst-case and average case performance of insertion sort is **O(n^2)**. That's because there are two nested loops in this function. Other sort algorithms, such as quicksort and merge sort, have **O(n log n)** performance, which is faster on large inputs.

Insertion sort is actually very fast for sorting small arrays. Some standard libraries have sort functions that switch from a quicksort to insertion sort when the partition size is 10 or less.

I did a quick test comparing our `insertionSort()` with Swift's built-in `sort()`. On arrays of about 100 items or so, the difference in speed is tiny. However, as your input becomes larger, **O(n^2)** quickly starts to perform a lot worse than **O(n log n)** and insertion sort just can't keep up.

## See also

[Insertion sort on Wikipedia](https://en.wikipedia.org/wiki/Insertion_sort)

*Written for Swift Algorithm Club by Matthijs Hollemans*
