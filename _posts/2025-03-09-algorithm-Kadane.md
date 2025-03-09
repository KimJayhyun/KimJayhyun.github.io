---
title: '[Algorithm] Kadane Algorithm - 합이 가장 큰 부분 배열'
date: 2025-03-09 18:00:00 +09:00
categories: [Algorithm, Array Problem]
tags:
  [
    Algorithm,
    Array Problem,
    Must Know Algorithms,
    Maximum Subarray Sum,
    DP
  ]
---

# Kadane 알고리즘: 최대 부분합(Subarray Sum) 문제 해결

## 📌 Kadane 알고리즘이란?

`Kadane's Algorithm`은 **배열의 연속된 부분 배열(subarray) 중에서 최대 합을 찾는 알고리즘**이다.

최대 부분합 문제 (Maximum Subarray Sum Problem)이라고도 한다.

이 알고리즘은 `O(N)`의 시간 복잡도로 실행되며, 가장 효율적으로 문제를 해결할 수 있다.

`Divide & Conquer` 방식으로도 해결할 수 있지만 

`DP` 기반의 `Kadane` 알고리즘이 가장 빠르고 간단한 풀이방법이다.

---

## 📌 문제 정의

> **배열이 주어졌을 때, 연속된 부분 배열 중에서 합이 가장 큰 값을 찾으시오.**

**🔹 예제 입력:**

```python
arr = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
```

**🔹 예제 출력:**

```python
6  # (부분 배열: [4, -1, 2, 1])
```

---

## 📌 Kadane 알고리즘 개념 및 동작 원리

1. `max_sum`을 **가장 작은 값**으로 초기화한다.

2. `current_sum`을 0 으로 설정한 후 배열을 순회하며 현재값 `num`을 더한다.

3. `current_sum`이 `max_sum`보다 크면 갱신한다.

4. `current_sum`이 0 보다 작아지면 0 으로 리셋한다. 
    
    - **Why??**
        
        `current_sum`이 0 보다 작다면, 즉 `currnet_num`이 음수라면
    
        다음 값인 `num`을 더 해도 `num`보다 클 수 없다. 

5. 위와 같이 배열을 끝까지 탐색한다면, `max_sum`이 **최대 부분합**이다.

---

## 📌 Kadane 알고리즘 구현 (Python)

```python
def max_subarray_sum(arr):
    max_sum = float('-inf')  # 최댓값 저장 (초기값: 음의 무한대)
    current_sum = 0  # 현재 부분합

    for num in arr:
        current_sum += num  # 현재 원소를 더함
        max_sum = max(max_sum, current_sum)  # 최댓값 갱신
        if current_sum < 0:  # 음수가 되면 초기화
            current_sum = 0

    return max_sum

# 테스트
arr = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
print(max_subarray_sum(arr))  # 결과: 6
```

---

## 📌 Kadane 알고리즘 예제 분석

| 인덱스 | 현재 원소 | 부분합 (`current_sum`) | 최대 부분합 (`max_sum`) |
| --- | ----- | ------------------- | ------------------ |
| 0   | -2    | -2 (`0`으로 초기화)  | -2                 |
| 1   | 1     | 1                   | 1                  |
| 2   | -3    | -2 (`0`으로 초기화)  | 1                  |
| 3   | 4     | 4                   | 4                  |
| 4   | -1    | 3                   | 4                  |
| 5   | 2     | 5                   | 5                  |
| 6   | 1     | 6                   | **6**              |
| 7   | -5    | 1                   | 6                  |
| 8   | 4     | 5                   | 6                  |

✅ **결과: `[-2, 1, -3, 4, -1, 2, 1, -5, 4]`의 최대 부분합 = `6`**

---

## 📌 Kadane 알고리즘 확장: 최대 부분 배열 찾기

아래와 같이 인덱스를 같이 저장을 한다면, 부분합뿐만 아니라 

**최대 부분 배열 자체**를 찾을 수 있다.

```python
def kadane_with_subarray(arr):
    max_sum = float('-inf')
    current_sum = 0
    start = end = s = 0

    for i, num in enumerate(arr):
        current_sum += num

        # max_sum = max(max_sum, current_sum)  # 기존 코드
        if current_sum > max_sum:
            max_sum = current_sum
            start, end = s, i  # 최댓값이 갱신될 때마다 시작, 끝 인덱스 갱신

        if current_sum < 0:
            current_sum = 0
            s = i + 1  # 새로운 부분합을 시작할 위치 저장

    return max_sum, arr[start:end+1]

# 테스트
arr = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
print(kadane_with_subarray(arr))  # (6, [4, -1, 2, 1])
```

---

## 📌 시간 복잡도 분석

- **시간 복잡도:** `O(N)` (한 번의 순회만 수행)
- **공간 복잡도:** `O(1)` (추가 메모리 사용 없음)

이는 가장 효율적인 **선형 시간 알고리즘**으로, 면접에서도 자주 등장하는 개념이다. 🚀

---

## 📌 확장 문제 및 응용 사례

1. **주식 최대 이익 문제** (`Best Time to Buy and Sell Stock`)
   - `Kadane 알고리즘`을 변형하여, 주가 변동을 분석하는 문제 해결 가능

2. **2D 배열에서 최대 부분합 찾기** (`Kadane's Algorithm in 2D`)
   - 행렬에서 최대 합을 갖는 부분 행렬 찾기

3. **최대 연속 곱 (Product)**
   - `max_product = max(max_product * num, num)` 방식으로 변형 가능

---

## 📌 정리

✅ **Kadane 알고리즘은 `DP`를 활용하여 최대 부분합을 찾는다.**

✅ **`current_sum`을 유지하면서 `0`보다 작아지면 초기화를 하는 것이 핵심이다.**

✅ **부분 배열을 찾고 싶다면 인덱스를 추가하여 추적하면 된다.**