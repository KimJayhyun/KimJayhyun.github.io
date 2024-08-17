---
title: '[algorithm] DP - Dynamic Programming'
date: 2024-08-16 21:00:00 +09:00
categories: [algorithm, DP]
tags:
  [
    algorithm,
    DP
  ]
---

## Dynamic Programming
> 복잡한 문제를 더 간단한 부분 문제로 나누어 해결하는 알고리즘 기법
{: .prompt-tip }


- 주로 최적화 문제에 사용
- 큰 문제를 해결하기 위해 부분 문제의 해를 재사용
  - 부분문제를 하위 문제라고도 표현

- `Memoization` 혹은 `Tabulation` 두 가지 방법 중 하나로 구현

### 적용 대상 문제
#### 1. 최적 부분 구조(Optimal Substructure)
- 문제의 해가 부분 문제들의 최적의 해로 구성됨
- 문제를 하위 문제로 나누고 최적의 해를 결합해서 문제의 최적 해를 구할 수 있음

#### 2. 중복되는 부분 문제(Overlapping Subproblems)
- 동일한 하위 문제를 여러 번 재계산해야 하는 경우에 사용
- 계산한 하위 문제의 해를 저장하여 중복 계산을 피고 필요할 때 다시 사용

### 구현 방법
### 메모리제이션(Memoization)
> 탑다운, 하향식 접근법

- 부분 문제의 해를 메모리에 저장하여 메모리에 저장된 값을 재사용
- 필요할 때마다 하위 문제를 계산하지만 중복을 피함
  
- 분할 정복 알고리즘과 비슷

### 탭뷸레이션(Tabulation)
> 바텀업, 상향식 접근법

- 하위 문제를 모두 해결하고, 상위 문제를 해결
- 일반적인 반복문을 사용하여 적은 문제부터 큰 문제를 해결

## 예시
### 1. 피보나치 수열

1. 재귀
```python
def fib(n):
    if n <= 1:
        return n
    return fib(n-1) + fib(n-2)
```

   - `fib(4)`를 계산하기 위해서 `fib(3)`, `fib(2)`를 호출
   - 문제를 풀기위해 하위 문제를 2 번 호출하고 하위 문제가 또 하위 문제 2 번 호출
   - 중복되는 계산을 여러 번 수행

2. 메모리제이션
```python
def fib(n, memo={}):
    if n in memo:
        return memo[n]
    if n <= 1:
        return n

    memo[n] = fib(n-1, memo) + fib(n-2, memo)
    return memo[n]
```
   - 메모리에 문제의 해를 저장하여 중복 계산을 피함
   - 탑다운 방식이므로 가독성이 비교적 떨어짐

3. 탭뷸레이션
    ```python
    def fib(n):
        if n <= 1:
            return n

        dp = [0] * (n+1)
        dp[1] = 1

        for i in range(2, n+1):
            dp[i] = dp[i-1] + dp[i-2]

        return dp[n]
    ```
   - 첫 항부터 계산하여 가독성이 비교적 높아짐

### 2. 0-1 배낭문제
- 백준 URL
  - [평범한 배낭](https://www.acmicpc.net/problem/12865)
- 풀이법
  - [메모리제이션 해결방법](https://kimjayhyun.github.io/posts/baekjoon-12865/)