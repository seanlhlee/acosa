# 堆積排序法（Heap Sort）

目標：將一個陣列中的元素由高到低（或高至低）排序。

堆積（Heap）是一種部分排序以陣列的形式儲存的二元數，而堆積排序法（Heap Sort）即是利用這種特點進行快速排序。堆積排序法首先將未排序的陣列轉換為最大值堆積（max-heap），首個元素總是最大值。例如未排序的陣列如下：

	[ 5, 13, 2, 25, 7, 17, 20, 8, 4 ]

首先將陣列轉換為堆積，示意如圖：

![The max-heap](/gitBook/pics/MaxHeap.png)

堆積類別的內部陣列如下：

	[ 25, 13, 20, 8, 7, 17, 2, 5, 4 ]

之後我們將第一個元素與最後一個元素換位得到：

	[ 4, 13, 20, 8, 7, 17, 2, 5, 25 ]

新的根節點為`4`比其子節點小，接著針對在前的*n-2*個元素以*shift down*（或稱為"heapify"程序）修復堆積，第二大的值會再度成為根節點。

	[20, 13, 17, 8, 7, 4, 2, 5 | 25]

重要： 當修復堆積時，僅針對未排序的部分。以`|`符號來代表已排序與未排序的分界。

修復堆積後再次將未排序部分的首末元素互換：

	[5, 13, 17, 8, 7, 4, 2, 20 | 25]

再修復堆積：

	[17, 13, 5, 8, 7, 4, 2 | 20, 25]

再將首末互換，一直重複到陣列排序完成。

> **注意：** 過程很類似[選擇排序](Selection Sort.md)，選擇排序重複地在未排序部分找到最小值，而提取最大或最小值正是堆積(Heap)所擅長的。

## 效能

堆積排序法（Heap Sort）最佳/最差與平均時間複雜度均為**O(n lg n)**。因為直接修改陣列，屬於就地排序的方式，但相同值得元素次序在排序前後不一定保持，屬於不穩定排序。

## 實作程式碼：

以下為以Swift實作的選擇排序法：


	extension Heap {
		public mutating func sort() -> [T] {
			for i in (elements.count - 1).stride(through: 1, by: -1) {
				swap(&elements[0], &elements[i])
				shiftDown(index: 0, heapSize: i)
			}
			return elements
		}
	}
*/
var h1 = Heap(array: [5, 13, 2, 25, 7, 17, 20, 8, 4], sort: >)
let a1 = h1.sort()

/*:

當要由小至大排序時，需要用最大堆積（max-heap），反之要使用最小堆積（min-heap），對此我們可以實作一個如下的輔助函式：

*/
public func heapsort<T>(a: [T], _ sort: (T, T) -> Bool) -> [T] {
	let reverseOrder = { i1, i2 in sort(i2, i1) }
	var h = Heap(array: a, sort: reverseOrder)
	return h.sort()
}

heapsort([5, 13, 2, 25, 7, 17, 20, 8, 4], <)
heapsort([5, 13, 2, 25, 7, 17, 20, 8, 4], >)


/*:
***
[Previous](@previous) | [Next](@next)
*/


# Heap Sort

Sorts an array from low to high using a heap.

A [heap](../Heap/) is a partially sorted binary tree that is stored inside an array. The heap sort algorithm takes advantage of the structure of the heap to perform a fast sort.

To sort from lowest to highest, heap sort first converts the unsorted array to a max-heap, so that the first element in the array is the largest.

Let's say the array to sort is:

	[ 5, 13, 2, 25, 7, 17, 20, 8, 4 ]

This is first turned into a max-heap that looks like this:

![The max-heap](/gitBook/pics/MaxHeap.png)

The heap's internal array is then:

	[ 25, 13, 20, 8, 7, 17, 2, 5, 4 ]

That's hardly what you'd call sorted! But now the sorting process starts: we swap the first element (index *0*) with the last one at index *n-1*, to get:

	[ 4, 13, 20, 8, 7, 17, 2, 5, 25 ]
	  *                          *

Now the new root node, `4`, will be smaller than its children, so we fix up the max-heap up to element *n-2* using the *shift down* or "heapify" procedure. After repairing the heap, the new root is now the second-largest item in the array:

	[20, 13, 17, 8, 7, 4, 2, 5 | 25]

Important: When we fix the heap, we ignore the last item at index *n-1*. That now contains the array's maximum value, so it is in its final sorted place already. The `|` bar indicates where the sorted portion of the array begins. We'll leave that part of the array alone from now on.

Again, we swap the first element with the last one (this time at index *n-2*):

	[5, 13, 17, 8, 7, 4, 2, 20 | 25]
	 *                      *

And fix up the heap to make it valid max-heap again:

	[17, 13, 5, 8, 7, 4, 2 | 20, 25]

As you can see, the largest items are making their way to the back. We repeat this process until we arrive at the root node and then the whole array is sorted.

> **Note:** This process is very similar to [selection sort](../Selection Sort/), which repeatedly looks for the minimum item in the remainder of the array. Extracting the minimum or maximum value is what heaps are good at.

Performance of heap sort is **O(n lg n)** in best, worst, and average case. Because we modify the array directly, heap sort can be performed in-place. But it is not a stable sort: the relative order of identical elements is not preserved.

Here's how you can implement heap sort in Swift:

```swift
extension Heap {
  public mutating func sort() -> [T] {
    for i in (elements.count - 1).stride(through: 1, by: -1) {
      swap(&elements[0], &elements[i])
      shiftDown(index: 0, heapSize: i)
    }
    return elements
  }
}
```

This adds a `sort()` function to our [heap](../Heap/) implementation. To use it, you would do something like this:

```swift
var h1 = Heap(array: [5, 13, 2, 25, 7, 17, 20, 8, 4], sort: >)
let a1 = h1.sort()
```

Because we need a max-heap to sort from low-to-high, you need to give `Heap` the reverse of the sort function. To sort `<`, the `Heap` object must be created with `>` as the sort function. In other words, sorting from low-to-high creates a max-heap and turns it into a min-heap.

We can write a handy helper function for that:

```swift
public func heapsort<T>(a: [T], _ sort: (T, T) -> Bool) -> [T] {
  let reverseOrder = { i1, i2 in sort(i2, i1) }
  var h = Heap(array: a, sort: reverseOrder)
  return h.sort()
}
```

*Written for Swift Algorithm Club by Matthijs Hollemans*
