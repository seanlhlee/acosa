/*:
[Next](@next)
***

# 遊程編碼（Run-Length Encoding - RLE）

遊程編碼（Run-Length Encoding - RLE）應該是一種最簡單的資料壓縮方式。假設我們有一份資料如下：

	aaaaabbbcdeeeeeeef...

遊程編碼（Run-Length Encoding - RLE）壓縮後像是這樣：

	5a3b1c1d7e1f...

以位元組在資料中連續出現的次數來取代重複的位元組(byte)。意即`5a`取代`aaaaa`，假若資料有許多連續重複的位元組，遊程編碼（Run-Length Encoding - RLE）壓縮可以節省資料儲存的空間，對影像壓縮而言，此法是有效的。

有非常多的方式來實作遊程編碼（Run-Length Encoding - RLE），在此我們以攥寫`NSData`的延伸功能的方式來實作。

## 實作

- 在資料中，某位元組(byte)連續重複，便將資料壓縮為2個位元組，第一個位元組紀錄連續的次數，第二個位元組紀錄位元組的實際值。第一個位元組紀錄資料形式為`191 + count`，此代表連續重複的位元組數不超過64個位元組的長度。

- 單一個位元組的資料在0 - 191的範圍是直接複製沒有壓縮的資料位元

- 單一個位元組的資料在192 - 255的範圍，代表需看連續兩位元，第一個位元192是連續位元組的個數為192 - 191 = 1，其後位元組為實際的資料

以下為Swift實作程式碼，回傳為包含遊程編碼的`NSData`物件：

*/
import Foundation
extension NSData {
	public func compressRLE() -> NSData {
		let data = NSMutableData()
		if length > 0 {
			var ptr = UnsafePointer<UInt8>(bytes)
			let end = ptr + length
			
			while ptr < end {                        // 1
				var count = 0
				var byte = ptr.memory
				var next = byte
				
				while next == byte && ptr < end && count < 64 {   // 2
					ptr = ptr.advancedBy(1)
					next = ptr.memory
					count += 1
				}
				
				if count > 1 || byte >= 192 {          // 3
					var size = 191 + UInt8(count)
					data.appendBytes(&size, length: 1)
					data.appendBytes(&byte, length: 1)
				} else {                               // 4
					data.appendBytes(&byte, length: 1)
				}
			}
		}
		return data
	}
}
/*:

運作原理：

1. 使用`UnsafePointer`指標來對原始的`NSData`物件進行位元組的步進

2. 將現在位置的位元資料讀進`byte`變數中，若下個位元組是相同的便繼續讀取直到發現不同的位元組或是讀完全部位元組，若連續的長度超過64的位元組我們也停止while迴圈，因為64為此方法編碼的最大連續重複長度。

3. 接下來我們決定如何編碼。有兩種可能性需要以2位元組編碼。即計數遊程為2位元組或更多時，與讀取的位元組資料的值大於192，這兩情況我們寫入2個位元組長度與資料位元來編碼。

4. 若讀到的資料遊程為1位元組且值小於192，便直接複製此位元組資料。

可在playground中進行以下測試：

*/
let originalString = "aaaaabbbcdeeeeeeef"
let utf8 = originalString.dataUsingEncoding(NSUTF8StringEncoding)! // <61616161 61626262 63646565 65656565 6566>
let compressed = utf8.compressRLE() // <c461c262 6364c665 66>
/*:

壓縮後的`NSData`物件為`<c461c262 6364c665 66>`，手動解碼如下：

c4    為10進位的196，代表下個位元組在原始資料中連續重複5次
61    "a"字元的資料位元組
c2    下個位元組連續重複3位元組
62    "b"字元的資料位元組
63    "c"字元的資料位元組，因為值<191，代表為資料位元只出現連續一次
64    "d"字元的資料位元組，只出現連續一次
c6    下個位元組連續重複7位元組
65    "e"字元的資料位元組
66    "f"字元的資料位元組，只出現連續一次

最後我們得到以9位元組的編碼方式來記錄原始長度為18位元組的資料。節省了50%的記憶空間。此方法與來源資料相關性很高，若原始資料中連續重複的位元組很少，此方法並不好。

以下為解碼部分的實作：

*/
extension NSData {
	public func decompressRLE() -> NSData {
		let data = NSMutableData()
		if length > 0 {
			var ptr = UnsafePointer<UInt8>(bytes)
			let end = ptr + length
			
			while ptr < end {
				var byte = ptr.memory                 // 1
				ptr = ptr.advancedBy(1)
				
				if byte < 192 {                       // 2
					data.appendBytes(&byte, length: 1)
					
				} else if ptr < end {                 // 3
					var value = ptr.memory
					ptr = ptr.advancedBy(1)
					
					for _ in 0 ..< byte - 191 {
						data.appendBytes(&value, length: 1)
					}
				}
			}
		}
		return data
	}
}
/*:

1. 再次以`UnsafePointer`指標讀取`NSData`，進行位元組步進讀取

2. 如果讀取位元組值小於192，為資料位元組直接加入資料中

3. 如果資料位元組代表遊程，需在往下讀取位元組資料，重複遊程的長度，加入資料中。

可在playground中進行以下測試：
*/
let decompressed = compressed.decompressRLE() // <61616161 61626262 63646565 65656565 6566>
let restoredString = String(data: decompressed, encoding: NSUTF8StringEncoding) // "aaaaabbbcdeeeeeeef"
originalString == restoredString // true

/*:

解碼後`originalString == restoredString`應該為真。

註腳： 原始的PCX實作有些不同。在原始實作中，位元組值192 (0xC0)代表後面位元組的遊程長度0，而這也限制了遊程紀錄程度為63位元組，同時記錄一個遊程長度0的位元組並不合理，因此在我們的實作中192代表遊程長度為1，而最長可記錄長度為64位元組。

遙想當年設計PCX格式時，這可能是一個權衡之計。因為用二進制來看看，最前兩個位元可以表示一個字節是否被壓縮。為了得到遊程長度，可以簡單地做`byte & 0x3F`的位元操作，得到一個值範圍為0到63的數值。


## 參考資料

[維基百科：Run-Length Encoding](https://en.wikipedia.org/wiki/Run-length_encoding)

[維基百科：PCX image file format](https://en.wikipedia.org/wiki/PCX)

***
[Next](@next)
*/
