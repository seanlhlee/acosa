# 線性搜尋法（Linear Search）

目標: 在陣列中找到特定值

有一格儲存泛型（Generic）物件的陣列，線性搜尋法遍歷陣列元素與欲尋找物件比較，若比較為不相同繼續遍歷直到比較相等或以完整遍歷整個陣列。

## 範例

假設有一陣列`[5, 2, 4, 7]`，要在其中找到`2`。首先我們先比較第一個元素`5`與目標`2`，結果不同，便繼續往下查找。直到遍歷至`2`與目標`2`比較相同，此時的索引值為`1`將會被回傳，代表找到目標在陣列中的位置。

## 程式碼實作

以下為Swift語言的程式實作：

```swift
func linearSearch<T: Equatable>(array: [T], _ object: T) -> Int? {
  for (index, obj) in array.enumerate() where obj == object {
    return index
  }
  return nil
}
```

在playground中可以測試:

```swift
let array = [5, 2, 4, 7]
linearSearch(array, 2) 	// This will return 1
```

## 效能

線性效能的時間複雜度為**O(n)**，因為遍歷陣列元素，因此搜尋時間隨陣列的資料量增加而線性成長，最差情況需要所有元素都遍歷過。

最佳情況**O(1)**，平均來說是陣列大小的一半。

## See also

[Linear search on Wikipedia](https://en.wikipedia.org/wiki/Linear_search)

*Written by [Patrick Balestra](http://www.github.com/BalestraPatrick)*
