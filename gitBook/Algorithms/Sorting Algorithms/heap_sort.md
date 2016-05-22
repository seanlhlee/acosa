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

> **注意：** 過程很類似[選擇排序](selection_sort.md)，選擇排序重複地在未排序部分找到最小值，而提取最大或最小值正是堆積(Heap)所擅長的。

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
    var h1 = Heap(array: [5, 13, 2, 25, 7, 17, 20, 8, 4], sort: >)
    let a1 = h1.sort()
    
當要由小至大排序時，需要用最大堆積（max-heap），反之要使用最小堆積（min-heap），對此我們可以實作一個如下的輔助函式：

```swift
public func heapsort<T>(a: [T], _ sort: (T, T) -> Bool) -> [T] {
	let reverseOrder = { i1, i2 in sort(i2, i1) }
	var h = Heap(array: a, sort: reverseOrder)
	return h.sort()
}

heapsort([5, 13, 2, 25, 7, 17, 20, 8, 4], <)
heapsort([5, 13, 2, 25, 7, 17, 20, 8, 4], >)
```
