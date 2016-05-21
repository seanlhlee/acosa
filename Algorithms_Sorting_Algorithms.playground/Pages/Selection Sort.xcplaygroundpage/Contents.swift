/*:
[Previous](@previous) | [Next](@next)
***
# 選擇排序法（Selection Sort）

目標: 將一個陣列中的元素由高到低（或高至低）排序。

將一個無序的陣列正確排序。選擇排序法（Selection Sort）將陣列分為兩部分，在陣列前端為排序過的部分，後面的是帶排序的部分。

	[ ...sorted numbers... | ...unsorted numbers... ]

此點與[插入排序法](Insertion%20Sort)相似，不同在於如何將新的元素加入已排序的部分中。其運作方式如下：

- 找到陣列中最小的元素，這可以藉由暫存一個最小值的變數並遍歷整個陣列的迴圈達成
- 將此最小值與索引值0的位置交換
- 找到索引值1到最後未排序部分的最小值
- 與索引值為1的元素位置交換
- 之後一直重複將未排序部分的最小值與該部分的最前方索引值進行位置交換
- 持續到所有元素均排序

這個演算法稱為選擇排序法（Selection Sort），因為每次均自未排序的部分選擇出最小值來。

## 例子

假設有一個未排序整數集合`[ 5, 8, 3, 4, 6 ]`，我們以`|`符號來代表分割已排序與未排序的部分。開始時已排序部分是空的：

	[| 5, 8, 3, 4, 6 ]

在集合中`|`之後找到最小值`3`，藉由與`5`位置交換將其放到已排序部分:

	[ 3 | 8, 5, 4, 6 ]

現在已排序部分`[ 3 ]`，待排序部分為`[ 8, 5, 4, 6 ]`，我們再由其中找到最小值`4`並與`8`的位置交換：

	[ 3, 4 | 5, 8, 6 ]

完成每個步驟，`|`符號均向右移一位。繼續找未排序部分最小值`5`，`5`已在對的位置上因此僅將`|`符號右移：

	[ 3, 4, 5 | 8, 6 ]

持續以上步驟直到完成。

[ 3, 4, 5, 6, 8 |]

正如你所看到的，選擇排序是*就地*排序，一切都在同一陣列中發生的；無需額外的暫存陣列（實際上我們以Swift實作是以複製相同的陣列完成）。還可以實作為*穩定*的排序，即相同的值元素在排序後依然維持原次序。（請注意，下面實作的版本是不穩定的）

## 實作程式碼：

以下為以Swift實作的選擇排序法：

*/
func selectionSort<T>(array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
	guard !array.isEmpty else { return array }  // 1
	
	var a = array                    // 2
	
	for i in 0..<a.count - 1 {     // 3
		var indexMin = i
		for j in i + 1 ..< a.count {   // 4
			if isOrderedBefore(a[j], a[indexMin]) {
				indexMin = j
			}
		}
		
		if i != indexMin {               // 5
			swap(&a[i], &a[indexMin])
		}
	}
	return a
}


var list = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
selectionSort(list, <) // [-1, 0, 1, 2, 3, 3, 5, 8, 9, 10, 26, 27]

func selectionSorted<T>(inout array: [T], _ isOrderedBefore: (T, T) -> Bool) {
	guard !array.isEmpty else { return }
	for i in 0..<array.count - 1 {
		var indexMin = i
		for j in i + 1 ..< array.count {
			if isOrderedBefore(array[j], array[indexMin]) {
				indexMin = j
			}
		}
		if i != indexMin {
			swap(&array[i], &array[indexMin])
		}
	}
}

list
selectionSorted(&list, <) // [-1, 0, 1, 2, 3, 3, 5, 8, 9, 10, 26, 27]
list

/*:

分步解說：

1. 若陣列為空直接回傳

2. 複製來源陣列，排序之後回傳的是一個副本。

3. 有兩個迴圈，外迴圈依序選擇陣列中的元素，如同說明中`|`符號右移。

4. 內迴圈用來找到未排序部分的最小值。

5. 將最小值與目前未排序的第一個位置交換，`if`確認`swap()`的必要性。

總結: 對於陣列中的每個元素，會與未排序部分的最小值進行位置交換，並由左至右進行。

- note: 外迴圈終止於`a.count - 2`，因為最後一個元素必然已經是在對的位置上。

## 效能

選擇排序法非常容易理解，但其效能不高，時間複雜度為**O(n^2)**比[插入排序法](Insertion%20Sort)差但比[氣泡排序法](Bubble%20Sort)好。效能最大的關鍵是在未排序部分找到最小值。

*堆積排序法（Heap sort）* 使用相同的原理，但更快速地找到未排序資料中的最小值，其實時間複雜度為**O(n log n)**.

## 參考資料

[維基百科：Selection sort](https://en.wikipedia.org/wiki/Selection_sort)

***
[Previous](@previous) | [Next](@next)
*/
