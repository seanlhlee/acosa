/*:
[Previous](@previous) | [Next](@next)
***
# 最大最小值搜尋（Select Minimum / Maximum）

目標：在未排序陣列中找到最大值或最小值

## 最大或最小

一個儲存泛型(generic)物件的陣列，遍歷陣列並持續追蹤已知的最大或最小值。

### 範例

假設一為排序陣列`[ 8, 3, 9, 4, 6 ]`，要由其中找出最大值。

首先取出`8`並記錄只知目前最大值。在往下找到`3`，與已知最大值比較。`3`比`8`小，故已知最大值`8`依然最大。再往下比較`9`，此時與已知最大值比較，`9`比`8`大，因此將已知最大值改為`9`。重複以上動作直到遍歷陣列中所有元素。

### 程式碼實作

以下為Swift語言的程式實作：
*/

func minimum<T: Comparable>(array: [T]) -> T? {
	return _getMinMax(array, getMin: true)
}

func maximum<T: Comparable>(array: [T]) -> T? {
	return _getMinMax(array, getMin: false)
}

func _getMinMax<T: Comparable>(array: [T], getMin: Bool) -> T? {
	guard !array.isEmpty else {
		return nil
	}
	var temp = array
	var result = temp.removeFirst()
	for element in temp {
		let condition = getMin ? element < result : element > result
		result = condition ? element : result
	}
	return result
}

/*:
在playground測試：
*/
var array = [ 8, 3, 9, 4, 6 ]
minimum(array)   // This will return 3
maximum(array)   // This will return 9
/*:

### Swift標準函式庫（Swift standard library）

Swift標準函式庫包含可回傳`SequenceType`物件中最大值與最小值的函式。

*/
array = [ 8, 3, 9, 4, 6 ]
array.minElement()   // This will return 3
array.maxElement()   // This will return 9
/*:

## 最大與最小

為了比較的次數較少，可以採用配對比較法，回傳陣列中最大與最小值。

### 範例

假設一為排序陣列`[ 8, 3, 9, 4, 6 ]`，要由其中找出最大值與最小值。首先取出`8`並作為已知的最大與最小值。將剩下的元素配對`[ 3, 9 ]`與`[ 6, 4 ]`。下一組`[ 3, 9 ]`，`3`是配對中的小者，`3`與已知最小值`8`比較，`9`與已知最大值比較`8`比較。`3`比`8`小所以已知最小值改為`3`。`9`比`8`大所以新的最大值為`9`。再繼續下一組比較，`[ 6, 4 ]`中`4`較小與現有最小值`3`比較，`6`與最大值`9`比較，結果均未改變已知的最大最小值。最後結果最小值為`3`最大值為`9`。

### 程式碼實作

以下為Swift語言的程式實作：
*/
func minimumMaximum<T: Comparable>(array: [T]) -> (minimum: T?, maximum: T?) {
	return (_getMinMax(array, getMin: true), _getMinMax(array, getMin: false))
}
/*:
在playground測試：
*/
let result = minimumMaximum(array)
result.minimum   // This will return 3
result.maximum   // This will return 9

let empty = [Int]()
minimumMaximum(empty)
/*:

## 效能

時間複雜度**O(n)**。


***
[Previous](@previous) | [Next](@next)
*/
