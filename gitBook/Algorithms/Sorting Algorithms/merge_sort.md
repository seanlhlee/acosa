# 合併排序法（Merge Sort）

目標：將一個陣列中的元素由高到低（或高至低）排序。

由John von Neumann於1945年發明，為相當有效率的演算法，時間複雜度**O(n log n)**。採用分治法（**divide and conquer**）的策略，運用先**分解**後**合併**的方式來解決排序的問題。其運作方式如下：

- 放入一堆沒有順序的**n**個元素的集合
- 將整堆分為**兩堆未排序集合**
- 持續細分集合直到無法再拆分，最終你會有**n**個小集合
- 以配對方式開始**合併**小集合，每次的合併都是已排序的小集合

## 例子

### 分解

假設有一個未排序整數集合`[2, 1, 5, 4, 9]`，先將其分成`[2, 1,]`和`[5, 4, 9]`兩個集合。其中`[2, 1]`再分解為`[2]`和`[1]`；而`[5, 4, 9]`分解成`[5]`和`[4, 9]`，當中`[4, 9]`可再分解為`[4]`和`[9]`。 

分解完之後，我們有下列小集合：`[2]` `[1]` `[5]` `[4]` `[9]`。

### 合併

分解完成之後，以**排序**的方式來**合併**這些小集合。`[2]` `[1]` `[5]` `[4]` `[9]`經第一輪合併後是`[1, 2]`、`[4, 5]`和`[9]`，接著下一輪合併`[1, 2]`和`[4, 5]`成為`[1, 2, 4, 5]`並留下`[9]`未合併，最後再將這兩個集合合併為`[1, 2, 4, 5, 9]`。

## Top-down實作

以下為以Swift實作的合併排序法：

```swift
func mergeSort<T>(array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
	// 1
	guard array.count > 1 else { return array }
	// 2
	let middleIndex = array.count / 2
	// 3
	let leftArray = mergeSort(Array(array[0..<middleIndex]), isOrderedBefore)
	// 4
	let rightArray = mergeSort(Array(array[middleIndex..<array.count]), isOrderedBefore)
	// 5
	return merge(leftPile: leftArray, rightPile: rightArray, isOrderedBefore)
}
```

說明:

1. 當陣列為空或是僅有單一元素，無法再差分更小，直接回傳陣列

2. 找到陣列中央的索引值 

3. 遞迴產生左側的子集合

4. 遞迴產生右側的子集合

5. 合併所有的子集合

以下為合併部分的演算法：

```swift
func merge<T>(leftPile leftPile: [T], rightPile: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
	// 1
	var leftIndex = 0
	var rightIndex = 0
	
	// 2
	var orderedPile = [T]()
	
	// 3
	while leftIndex < leftPile.count && rightIndex < rightPile.count {
		if isOrderedBefore(leftPile[leftIndex], rightPile[rightIndex]) {
			orderedPile.append(leftPile[leftIndex])
			leftIndex += 1
		} else {
			orderedPile.append(rightPile[rightIndex])
			rightIndex += 1
		}
	}
	
	var index = leftIndex < leftPile.count ? leftIndex : rightIndex
	var remainingPile = leftIndex < leftPile.count ? leftPile : rightPile
	
	// 4
	while index < remainingPile.count {
		orderedPile.append(remainingPile[index])
		index += 1
	}
	
	return orderedPile
}
```

說明：

1. 需要兩個索引值來追蹤合併的進度

2. 一開始合併前是一個空陣列，後續合併的過程會由其他陣列加入。

3. 第一個`while loop`比較欲合併兩個子集合並決定先合併的子集合使其結果為排序的。 

4. 當離開第一個`while loop`表示`orderedPile`為排序的，只需將剩下的合併。

以下為一個說明`merge()`函式運作的例子，假設我們有兩個子集合分別是`leftPile = [1, 7, 8]`與`rightPile = [3, 6, 9]`，此兩子集合自身為已排序，接下來的過程：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ ]
      l              r

以`l`來代表左集合的索引值，指向左集合的第一個元素`1`，以`r`來代表右集合的索引值，指向右集合的第一個元素`3`，經過比較`orderedPile`會先加入`1`這個元素，並將左側索引加1指向下一個元素。

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1 ]
      -->l           r

現在`l`指向`7`而`r`仍指向`3`，因此將較小`3`的合併到`orderedPile`：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3 ]
         l           -->r

過程持續進行，每一次都左子集合`leftPile`與右子集合`rightPile`中的元素較小者合併至`orderedPile`：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6 ]
         l              -->r
	
	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6, 7 ]
         -->l              r
	
	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6, 7, 8 ]
            -->l           r

到這裡，左子集合已空，我們只需將右子集合未完成部分加入就完工了，最後是`[ 1, 3, 6, 7, 8, 9 ]`。


## Bottom-up實作

之前的實作為先分解再合併的"top-down"方式，也可以忽略分解的過程直接自陣列中的個別元素開始合併，此方式稱為"bottom-up"實作。

```swift
func mergeSortBottomUp<T>(a: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
  let n = a.count
  // 1
  var z = [a, a]      
  var d = 0
  // 2
  var width = 1
  while width < n {   
  
    var i = 0
    // 3
    while i < n {    

      var j = i
      var l = i
      var r = i + width
      
      let lmax = min(l + width, n)
      let rmax = min(r + width, n)
      // 4
      while l < lmax && r < rmax {             
        if isOrderedBefore(z[d][l], z[d][r]) {
          z[1 - d][j] = z[d][l]
          l += 1
        } else {
          z[1 - d][j] = z[d][r]
          r += 1
        }
        j += 1
      }
      while l < lmax {
        z[1 - d][j] = z[d][l]
        j += 1
        l += 1
      }
      while r < rmax {
        z[1 - d][j] = z[d][r]
        j += 1
        r += 1
      }

      i += width*2
    }
    // 5
    width *= 2
    d = 1 - d     
  }
  return z[d]
}

let array = [2, 1, 5, 4, 9]
mergeSortBottomUp(array, <)   // [1, 2, 4, 5, 9]
```

看起來比top-down的做法嚇人，與`merge()`函式包含了三個相同功能的`while`迴圈。

要點說明：

1. 合併排序需要一個暫存的工作陣列，因為無法在合併的過程中同時改寫其內容。每次合併都建一個工作陣列又太浪費，因此使用*雙緩衝（double-buffering）*技巧建立兩個工作陣列，以非0即1的變數`d`來切換工作陣列，`z[d]`用來讀取，`z[1 - d]`用作寫入。

2. 觀念上，bottom-up方式與top-down方式有著相同的工作原理。首先先合併只有一個元素最小子集合，然後合併兩個元素的子集合，之後是四個...這樣下去。實作中我們以變數`width`來代表子集合的大小。開始時`width`是`1`，迴圈的每個步驟完成後就乘以2，最外部的迴圈即以`width`的值來進行要合併子集合的大小。

3. 內迴圈則是合併配對的子集合並將合併寫入`z[1 - d]`。

4. 正個運作邏輯與top-down完全相同，差異在於使用了*雙緩衝（double-buffering）*，以`z[d]`讀取並寫入至`z[1 - d]`。同時也使用`isOrderedBefore`的函式(或閉包)作為元素比較排序的方法來使合併排序可泛用於各種型別。

5. 最後一點，當從`z[d]`合併`width`子集合大小至`z[1 - d]`工作陣列後，`z[1 - d]`成為子集合大小為`width * 2`的下一輪需要合併的對象，因此切換兩個工作陣列的角色，意即上一輪中寫入的角色會成為下一輪讀取的工作陣列。

## 效能

合併排序法的效率與資料中是否部分排序無關，因為總是要將原集合分解到無法拆分，所以其平均、最佳與最差情況的時間複雜度均為**O(n log n)**。 

## 參考資料

[維基百科: Merge sort](https://en.wikipedia.org/wiki/Merge_sort)

