/*:
[Previous](@previous) | [Next](@next)
***

# 排列組合（Permutations and Combinations）

排列（*permutation*）是將相異物件或符號根據確定的順序重排。每個順序都稱作一個排列。例如，從一到六的數字有720種排列，對應於由這些數字組成的所有不重複亦不闕漏的序列，例如`4, 5, 6, 1, 2, 3`與`1, 3, 5, 2, 4, 6`。又假設英文字母的前5個字母，按其順序排為其中一種排列方式：

`a, b, c, d, e`

還有另一種：

`b, e, d, a, c`

對一`n`個物件的集合，會有`n!`個排列的方式，其中`!`為階乘（factorial）運算元，因此5個字母的排列方法共有：

`5! = 5 * 4 * 3 * 2 * 1 = 120`

若是6個物件的集合則有`6! = 720`個排列方式；10個物件集合為`10! = 3,628,800`，數目增加的非常快速。

`n!`是怎麼來的呢？邏輯說明：例如5字母的集合，第一個位置有5個字母供選擇，第二個位置剩下4個，依序下去，就呈現一個階乘的算式。`5 * 4 * 3 * 2 * 1`。

排列數的實作如下：

*/
func factorial(n: Int) -> Int {
	var n = n
	var result = 1
	while n > 1 {
		result *= n
		n -= 1
	}
	return result
}


factorial(5)   // returns 120
/*:

注意：`factorial(20)`為可以此函式計算的最大數值，在大會有整數的溢位。

假設我們在5個字母的集合中要取出3個元素，總共有幾種可能的方法呢？用前面的邏輯說明，取第一個字母時，我們有5種選擇，第二個為4種，第三個為3種，因此算式為：`5 * 4 * 3 = 60`。用數學公式來表示：

P(n, k) = n! / (n - k)!

其中`n`為集合的大小，`k`為要自集合中選取的個數，範例可以`P(5, 3) = 5! / (5 - 3)! = 120 / 2 = 60`表示。

我們一樣可以`factorial()`函式來實作這個計算，`factorial(20)`會造成溢位，所以要注意此問題；也可以將n! / (n - k)!視為是由`n * (n-1) * (n-2) * ... * (n-k+1)，從而有可能避開整數溢位的問題而進行較大數量集合的計算，以下為其實作：
*/
func permutations(n: Int, _ k: Int) -> Int {
	var n = n
	var answer = n
	for _ in 1..<k {
		n -= 1
		answer *= n
	}
	return answer
}

permutations(5, 3)   // returns 60
permutations(50, 6)  // returns 11441304000
permutations(9, 4)   // returns 3024
/*:

## 生成排列（Generating the permutations）

我們已經知道如何計算排列方法數，那實際把這些排列呈現出來又該如何做呢？

以下是由Niklaus Wirth提出的實作方式：

*/
func permuteWirth<T>(a: [T], _ n: Int) {
	if n == 0 {
		print(a)   // display the current permutation
	} else {
		var a = a
		permuteWirth(a, n - 1)
		for i in 0..<n {
			swap(&a[i], &a[n])
			permuteWirth(a, n - 1)
			swap(&a[i], &a[n])
		}
	}
}

let letters = ["a", "b", "c", "d", "e"]
permuteWirth(letters, letters.count - 1)
/*:

以下是印出所有排列方法的結果：

```swift
["a", "b", "c", "d", "e"]
["b", "a", "c", "d", "e"]
["c", "b", "a", "d", "e"]
["b", "c", "a", "d", "e"]
["a", "c", "b", "d", "e"]
...
```
總共會有120種排列方式。此演算法如何運作的？來看一個只有3個元素的集合：

`[ "x", "y", "z" ]`

執行時我們以下列程式碼呼叫：

`permuteWirth([ "x", "y", "z" ], 2)`

`n`的參數一開始時是`array.count - 1`，呼叫`permuteWirth()`會馬上再呼叫以`n = 1`為參數的遞迴，並再呼叫`n = 0`的遞迴。呼叫的次序依序如下：

```swift
permuteWirth([ "x", "y", "z" ], 2)
permuteWirth([ "x", "y", "z" ], 1)
permuteWirth([ "x", "y", "z" ], 0)   // prints ["x", "y", "z"]
```

當`n = 0`時，會印出現在的陣列，此時順序是跟原來一樣的。這個遞迴的結果傳回了基值（base case），因此倒回一個呼叫層級，進入到`for`迴圈中：

```swift
permuteWirth([ "x", "y", "z" ], 2)
permuteWirth([ "x", "y", "z" ], 1)   <--- back to this level
swap a[0] with a[1]
permuteWirth([ "y", "x", "z" ], 0)   // prints ["y", "x", "z"]
swap a[0] and a[1] back
```

此處`"y"`與`"x"`換位並印出結果，再往上回溯一個層級，因為`n = 2`，這次我們要做`for`迴圈的兩次迭代，第一輪：

```swift
permuteWirth([ "x", "y", "z" ], 2)   <--- back to this level
swap a[0] with a[2]
permuteWirth([ "z", "y", "x" ], 1)
permuteWirth([ "z", "y", "x" ], 0)   // prints ["z", "y", "x"]
swap a[0] with a[1]
permuteWirth([ "y", "z", "x" ], 0)   // prints ["y", "z", "x"]
swap a[0] and a[1] back
swap a[0] and a[2] back
```

第二輪：

```swift
permuteWirth([ "x", "y", "z" ], 2)
swap a[1] with a[2]                 <--- second iteration of the loop
permuteWirth([ "x", "z", "y" ], 1)
permuteWirth([ "x", "z", "y" ], 0)   // prints ["x", "z", "y"]
swap a[0] with a[1]
permuteWirth([ "z", "x", "y" ], 0)   // prints ["z", "x", "y"]
swap a[0] and a[1] back
swap a[1] and a[2] back
```

以下是換位過程：

`[ 2, 1, - ]`

`[ 3, -, 1 ]`

`[ 2, 3, - ]`

`[ -, 3, 2 ]`

`[ 3, 1, - ]`


以下為Robert Sedgewick提出的觀察遞迴過程的實作方式：

*/
func permuteSedgewick(a: [Int], _ n: Int, inout _ pos: Int) {
	var a = a
	pos += 1
	a[n] = pos
	if pos == a.count - 1 {
		print(a)              // display the current permutation
	} else {
		for i in 0..<a.count {
			if a[i] == 0 {
				permuteSedgewick(a, i, &pos)
			}
		}
	}
	pos -= 1
	a[n] = 0
}


let numbers = [0, 0, 0, 0]
var pos = -1
permuteSedgewick(numbers, 0, &pos)
/*:

一開始的陣列全為0，0用來作為旗標，用來表示還需要完成遞迴的層數，其輸出：

```swift
[1, 2, 3, 0]
[1, 2, 0, 3]
[1, 3, 2, 0]
[1, 0, 2, 3]
[1, 3, 0, 2]
...
```

## 組合（Combinations）

A combination is like a permutation where the order does not matter. The following are six different permutations of the letters `k` `l` `m` but they all count as the same combination:

k, l, m      k, m, l      m, l, k
l, m, k      l, k, m      m, k, l

So there is only one combination of size 3. However, if we're looking for combinations of size 2, we can make three:

k, l      (is the same as l, k)
l, m      (is the same as m, l)
k, m      (is the same as m, k)

The `C(n, k)` function counts the number of ways to choose `k` things out of `n` possibilities. That's why it's also called "n-choose-k". (A fancy mathematical term for this number is "binomial coefficient".)

The formula for `C(n, k)` is:

n!         P(n, k)
C(n, k) = ------------- = --------
(n - k)! * k!      k!

As you can see, you can derive it from the formula for `P(n, k)`. There are always more permutations than combinations. You divide the number of permutations by `k!` because a total of `k!` of these permutations give the same combination.

Above I showed that the number of permutations of `k` `l` `m` is 6, but if you pick only two of those letters the number of combinations is 3. If we use the formula we should get the same answer. We want to calculate `C(3, 2)` because we choose 2 letters out of a collection of 3.

3 * 2 * 1    6
C(3, 2) = --------- = --- = 3
1! * 2!     2

Here's a simple function to calculate `C(n, k)`:

*/
func combinations(n: Int, _ k: Int) -> Int {
	return permutations(n, k) / factorial(k)
}


combinations(28, 5)    // prints 98280
/*:

Because this uses the `permutations()` and `factorial()` functions under the hood, you're still limited by how large these numbers can get. For example, `combinations(30, 15)` is "only" `155,117,520` but because the intermediate results don't fit into a 64-bit integer, you can't calculate it with the given function.

There's a faster approach to calculate `C(n, k)` in **O(k)** time and **O(1)** extra space. The idea behind it is that the formula for `C(n, k)` is:

n!                      n * (n - 1) * ... * 1
C(n, k) = ------------- = ------------------------------------------
(n - k)! * k!      (n - k) * (n - k - 1) * ... * 1 * k!

After the reduction of fractions, we get the following formula:

n * (n - 1) * ... * (n - k + 1)         (n - 0) * (n - 1) * ... * (n - k + 1)
C(n, k) = --------------------------------------- = -----------------------------------------
k!                          (0 + 1) * (1 + 1) * ... * (k - 1 + 1)

We can implement this formula as follows:

*/
func quickBinomialCoefficient(n: Int, _ k: Int) -> Int {
	var result = 1
	for i in 0..<k {
		result *= (n - i)
		result /= (i + 1)
	}
	return result
}
/*:

This algorithm can create larger numbers than the previous method. Instead of calculating the entire numerator (a potentially huge number) and then dividing it by the factorial (also a very large number), here we already divide in each step. That causes the temporary results to grow much less quickly.

Here's how you can use this improved algorithm:

*/
quickBinomialCoefficient(8, 2)     // prints 28
quickBinomialCoefficient(30, 15)   // prints 155117520
/*:

This new method is quite fast but you're still limited in how large the numbers can get. You can calculate `C(30, 15)` without any problems, but something like `C(66, 33)` will still cause integer overflow in the numerator.

Here is an algorithm that uses dynamic programming to overcome the need for calculating factorials and doing divisions. It is based on Pascal's triangle:

0:               1
1:             1   1
2:           1   2   1
3:         1   3   3   1
4:       1   4   6   4   1
5:     1   5  10   10  5   1
6:   1   6  15  20   15  6   1

Each number in the next row is made up by adding two numbers from the previous row. For example in row 6, the number 15 is made by adding the 5 and 10 from row 5. These numbers are called the binomial coefficients and as it happens they are the same as `C(n, k)`.

For example, for row 6:

C(6, 0) = 1
C(6, 1) = 6
C(6, 2) = 15
C(6, 3) = 20
C(6, 4) = 15
C(6, 5) = 6
C(6, 6) = 1

The following code calculates Pascal's triangle in order to find the `C(n, k)` you're looking for:

*/
func binomialCoefficient(n: Int, _ k: Int) -> Int {
	var bc = Array2D(rows: n + 1, columns: n + 1, initialValue: 0)
	
	for i in 0...n {
		bc[i, 0] = 1
		bc[i, i] = 1
	}
	
	if n > 0 {
		for i in 1...n {
			for j in 1..<i {
				bc[i, j] = bc[i - 1, j - 1] + bc[i - 1, j]
			}
		}
	}
	
	return bc[n, k]
}
/*:

This uses [Array2D](../Array2D/) as helper code because Swift doesn't have a built-in two-dimensional array. The algorithm itself is quite simple: the first loop fills in the 1s at the outer edges of the triangle. The other loops calculate each number in the triangle by adding up the two numbers from the previous row.

Now you can calculate `C(66, 33)` without any problems:

*/
binomialCoefficient(66, 33)   // prints a very large number
/*:

You may wonder what the point is in calculating these permutations and combinations, but many algorithm problems are really combinatorics problems in disguise. Often you may need to look at all possible combinations of your data to see which one gives the right solution. If that means you need to search through `n!` potential solutions, you may want to consider a different approach -- as you've seen, these numbers become huge very quickly!

## References

Wirth's and Sedgewick's permutation algorithms and the code for counting permutations and combinations are based on the Algorithm Alley column from Dr.Dobb's Magazine, June 1993. The dynamic programming binomial coefficient algorithm is from The Algorithm Design Manual by Skiena.


***
[Previous](@previous) | [Next](@next)
*/
