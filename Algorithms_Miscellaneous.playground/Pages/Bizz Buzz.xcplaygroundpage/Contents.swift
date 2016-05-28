/*:
[Next](@next)
***
# Fizz Buzz

Fizz buzz是一個教小朋友的數學的團隊遊戲，遊戲的進行是小朋友依序報數，當他報的數是3的倍數時喊出"fizz"，是5的倍數時喊出"buzz"，同時是3也是5的倍數時喊出"Fizz buzz"。

Fizz buzz現在也用來作為企業徵才時的一項題目。

## 例子

報數喊出的順序如下：

`1`, `2`, `Fizz`, `4`, `Buzz`, `Fizz`, `7`, `8`, `Fizz`, `Buzz`, `11`, `Fizz`, `13`, `14`, `Fizz Buzz`, `16`, `17`, `Fizz`, `19`, `Buzz`, `Fizz`, `22`, `23`, `Fizz`, `Buzz`, `26`, `Fizz`, `28`, `29`, `Fizz Buzz`, `31`, `32`, `Fizz`, `34`, `Buzz`, `Fizz`, ...

## 	模數運算子（Modulus Operator）

模數運算子（Modulus Operator, `%`）是解題的關鍵，回傳整數除法的餘數：

	| Division      | Division Result            | Modulus         | Modulus Result  |
	| ------------- | -------------------------- | --------------- | ---------------:|
	| 1 / 3         | 0 with a remainder of 3    | 1 % 3           | 1               |
	| 5 / 3         | 1 with a remainder of 2    | 5 % 3           | 2               |
	| 16 / 3        | 5 with a remainder of 1    | 16 % 3          | 1               |

通常要判斷一整數為奇數還是偶數也是用模數運算子（Modulus Operator, `%`）：

	| Modulus   | Result  | Swift Code                      | Swift Code Result | Comment                                       |
	| ----------| -------:| ------------------------------- | -----------------:| --------------------------------------------- |
	| 6 % 2     | 0       | `let isEven = (number % 2 == 0)`| `true`            | If a number is divisible by 2 it is *even*    |
	| 5 % 2     | 1       | `let isOdd = (number % 2 != 0)` | `true`            | If a number is not divisible by 2 it is *odd* |

## 解題

以模數運算子（Modulus Operator, `%`）解題

以整數除以3的餘數來判斷：

| Modulus | Modulus Result | Swift Code    | Swift Code Result |
| ------- | --------------:| ------------- |------------------:|
| 1 % 3 | 1            | `1 % 3 == 0`  | `false`           |
| 2 % 3 | 2            | `2 % 3 == 0`  | `false`           |
| 3 % 3 | 0            | `3 % 3 == 0`  | `true`            |
| 4 % 3 | 1            | `4 % 3 == 0`  | `false`           |

以整數除以5的餘數來判斷：

| Modulus | Modulus Result | Swift Code    | Swift Code Result |
| ------- | --------------:| ------------- |------------------:|
| 1 % 5 | 1            | `1 % 5 == 0`  | `false`           |
| 2 % 5 | 2            | `2 % 5 == 0`  | `false`           |
| 3 % 5 | 3            | `3 % 5 == 0`  | `false`           |
| 4 % 5 | 4            | `4 % 5 == 0`  | `false`           |
| 5 % 5 | 0            | `5 % 5 == 0`  | `true`            |
| 6 % 5 | 1            | `6 % 5 == 0`  | `false`           |

## 實作

Swift程式碼實作如下：

*/
func fizzBuzz(numberOfTurns: Int) {
	var result = ""
	for i in 1...numberOfTurns {
		var fizzBuzz : String = ""
		if i % 3 == 0 {
			fizzBuzz += "Fizz\t\t"
		}
		if i % 5 == 0 {
			fizzBuzz += (result.isEmpty ? "" : " ") + "Buzz\t"
		}
		if fizzBuzz.isEmpty {
			fizzBuzz += "\(i)\t"
		}
		result += fizzBuzz
	}
	print(result)
}

fizzBuzz(15)
/*:

輸出：

1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz, 11, Fizz, 13, 14, Fizz Buzz

## 參考資料

[維基百科：Fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz)

***
[Next](@next)
*/
