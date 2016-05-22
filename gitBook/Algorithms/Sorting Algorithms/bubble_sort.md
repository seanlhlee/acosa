# 氣泡排序法（Bubble Sort）

這個演算法並不好，是一種簡單的排序演算法。它重複地走訪過要排序的數列，一次比較兩個元素，如果他們的順序錯誤就把他們交換過來。走訪數列的工作是重複地進行直到沒有再需要交換，也就是說該數列已經排序完成。這個演算法的名字由來是因為越小的元素會經由交換慢慢「浮」到數列的頂端。

略過此演算法的原理介紹。時間複雜度為**O(n^2)**。

```swift
func bubble_sort<T>(array: [T], isOrderedBefore: (T, T) -> Bool) -> [T] {
	var sorted = array
	for i in 0..<sorted.count {
		for j in 0..<sorted.count-i-1 {
			if !isOrderedBefore(sorted[j], sorted[j+1]) {
				swap(&sorted[j], &sorted[j+1])
			}
		}
	}
	return sorted
}

var array = [3, 8, 17, 0, 6, 9, 20, 15, 8]
bubble_sort(array, isOrderedBefore: <) // [0, 3, 6, 8, 8, 9, 15, 17, 20]
```

