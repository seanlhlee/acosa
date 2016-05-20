# 線性搜尋法（Linear Search）

目標: 在陣列中找到特定值

有一格儲存泛型（Generic）物件的陣列，線性搜尋法遍歷陣列元素與欲尋找物件比較，若比較為不相同繼續遍歷直到比較相等或以完整遍歷整個陣列。

## 範例

假設有一陣列`[5, 2, 4, 7]`，要在其中找到`2`。首先我們先比較第一個元素`5`與目標`2`，結果不同，便繼續往下查找。直到遍歷至`2`與目標`2`比較相同，此時的索引值為`1`將會被回傳，代表找到目標在陣列中的位置。

## The code

Here is a simple implementation of linear search in Swift:

```swift
func linearSearch<T: Equatable>(array: [T], _ object: T) -> Int? {
  for (index, obj) in array.enumerate() where obj == object {
    return index
  }
  return nil
}
```

Put this code in a playground and test it like so:

```swift
let array = [5, 2, 4, 7]
linearSearch(array, 2) 	// This will return 1
```

## Performance

Linear search runs at **O(n)**. It compares the object we are looking for with each object in the array and so the time it takes is proportional to the array length. In the worst case, we need to look at all the elements in the array.

The best-case performance is **O(1)** but this case is rare because the object we're looking for has to be positioned at the start of the array to be immediately found. You might get lucky, but most of the time you won't. On average, linear search needs to look at half the objects in the array.

## See also

[Linear search on Wikipedia](https://en.wikipedia.org/wiki/Linear_search)

*Written by [Patrick Balestra](http://www.github.com/BalestraPatrick)*
