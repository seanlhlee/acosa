# 計數排序法（Counting Sort）

計數排序法（Counting Sort）是一種排序鍵值(key)為簡單整數的物件集合排序法。其方式是以一陣列來記錄整數鍵值出現的次數，再由索引值排序各鍵值的排序。

## 例子

以下藉由簡單的例子來說明，假設一陣列如下：

	[ 10, 9, 8, 7, 1, 2, 7, 3 ]

### 步驟1：

首先針對每個整數的值出現在陣列中的次數進行計次，其輸出唯一如下之陣列：

	Index 0 1 2 3 4 5 6 7 8 9 10
	Count 0 1 1 1 0 0 0 2 1 1 1

### 步驟2：

此步驟計算每個鍵值的位置，因為我們已經知道每個數字出現的次數，只要將每個索引值將之前的值求和即可。輸出如下：

	Index 0 1 2 3 4 5 6 7 8 9 10
	Count 0 1 2 3 3 3 3 5 6 7 8

### 步驟3：

此步驟將依照第二步得到的陣列，安排每個數字的位置，例如數字10的索引值為7。最後輸出為：

	Index  0 1 2 3 4 5 6 7
	Output 1 2 3 7 7 8 9 10

以下為此部分的實作：

```swift
func countingSort(array: [Int]) -> [Int] {
	let maxElement = array.maxElement() ?? 0
	var countArray = [Int](count: Int(maxElement + 1), repeatedValue: 0)
	// 1 對鍵值計次
	for element in array {
		countArray[element] += 1
	}
	// 2 計算各鍵值在結果陣列之索引值
	for index in 1 ..< countArray.count {
		let sum = countArray[index] + countArray[index - 1]
		countArray[index] = sum
	}
	// 3 依序將各數字填入輸出陣列中
	var sortedArray = [Int](count: array.count, repeatedValue: 0)
	for element in array {
		countArray[element] -= 1
		sortedArray[countArray[element]] = element
	}
	return sortedArray
}

var array = [ 10, 9, 8, 7, 1, 2, 7, 3 ]
countingSort(array)
```

## 效能

這個演算法使用簡單的迴圈來排序集合，其實時間複雜度為**O(n+k)**，其中**O(n)**與**O(k)**分別代表輸出結果陣列的迴圈與產生計次陣列的迴圈。

