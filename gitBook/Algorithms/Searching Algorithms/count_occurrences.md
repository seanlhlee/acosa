# 計數法（Count Occurrences）

目標： 計算陣列中某元素重複的次數

顯然可以利用[線性尋法（linear search）](../Linear Search/)來完成計數，為時間複雜度**O(n)**的演算法。

若經過排序的陣列，使用[二元搜尋法（binary search)](../Binary Search/)可以提高效率至**O(log n)**。 

假設有下例陣列：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

想知道`3`在陣列中的個數，可以對此進行搜尋而得到4個3的其中一個索引值。

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
	           *  *  *  *

還需要再往左與往右查找到所有的`3`，通常效率**O(n)**。陣列已排序時，可以技巧地利用兩個二元搜尋法來找到左邊界與右邊界，以下為實作程式碼：

```swift
func countOccurrencesOfKey(key: Int, inArray a: [Int]) -> Int {
  func leftBoundary() -> Int {
    var low = 0
    var high = a.count
    while low < high {
      let midIndex = low + (high - low)/2
      if a[midIndex] < key {
        low = midIndex + 1
      } else {
        high = midIndex
      }
    }
    return low
  }
  
  func rightBoundary() -> Int {
    var low = 0
    var high = a.count
    while low < high {
      let midIndex = low + (high - low)/2
      if a[midIndex] > key {
        high = midIndex
      } else {
        low = midIndex + 1
      }
    }
    return low
  }
  
  return rightBoundary() - leftBoundary()
}
```

實作中有兩個輔助函式`leftBoundary()`與`rightBoundary()`與[二元搜尋法（binary search)](../Binary Search/)非常類似，差別在於找到後是否繼續。可在playground中測試:

```swift
let a = [ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

countOccurrencesOfKey(3, inArray: a)  // returns 4
```

> **注意:** 需要先對來源陣列進行排序！

範例陣列：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

要找左邊界由`low = 0`、`high = 12`開始，第一個中間索引值`6`其值與目標相同：

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
	                    *

接著繼續找下一個中間索引值`3`其值亦為目標，

	[ 0, 1, 1, 3, 3, 3 | x, x, x, x, x, x ]
	           *

再繼續二分時與目標不同:

	[ 0, 1, 1 | x, x, x | x, x, x, x, x, x ]
	     *

但尚未完成，接下來要往右找：

	[ x, x | 1 | x, x, x | x, x, x, x, x, x ]
	         *

直到範圍已無法再收斂，此時我們找到左邊界之索引值`3`。接著找右邊界索引值:

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
	                    *

	[ x, x, x, x, x, x, x | 6, 8, 10, 11, 11 ]
	                              *

	[ x, x, x, x, x, x, x | 6, 8, | x, x, x ]
	                           *

	[ x, x, x, x, x, x, x | 6 | x | x, x, x ]
	                        *

右邊界索引值為7，做有兩邊界索引值差異7 - 3 = 4，因此得知該陣列中元素`3`的數量有4個。

由上例，左右各做了4個步驟，總共為8步驟，對於僅12個元素的陣列來說不是很快。但對更大的陣列此演算法就會顯現效率。對已排序容量為1,000,000的陣列，僅需要40個步驟即可完成計算任何特定目標在陣列中的個數。

此外，輔助函式會在當目標元素不存在時傳回相同值，此時`rightBoundary()`與`leftBoundary()`沒有差別，並最終回傳0。

此範例同時也說明了如何利用修改二元搜尋法來解決不同的問題，記得，來源陣列要是排序的。

