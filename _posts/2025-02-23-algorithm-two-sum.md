---
title: '[Algorithm] 두 수의 합 문제 해결하기'
date: 2025-02-23 17:00:00 +09:00
categories: [Algorithm, Two Sum]
tags:
  [
    Algorithm,
    Two Sum
  ]
---

# Dictionary or Two Pointer

**두 수의 합(Two Sum)** 문제는 

주어진 배열에서 두 원소의 합이 특정 목표값(`target`)과 일치하는 경우 해당 원소들의 인덱스를 반환하는 

코딩 테스트와 알고리즘 문제에서 자주 등장하는 문제이다.

Dictionary(hash map) 혹은 Two Pointer을 활용하여 문제를 해결하는데,

어떤 것을 언제 사용하면 좋을지 비교해보았다.

---

## 문제 정의

문제의 기본 조건은 아래와 같다.

- **입력:** 정수 배열 `nums`와 정수 `target`
- **출력:** 배열 내 두 원소의 합이 `target`이 되는 인덱스 쌍

예를 들어, `nums = [2, 7, 11, 15]`, `target = 9`인 경우, 정답은 `[0, 1]` (즉, 2와 7의 합이 9).

### 같은 유형 문제

- [Two Sum - Leetcode](https://leetcode.com/problems/two-sum/description/)
- [두 용액 - 백준](https://www.acmicpc.net/problem/2470)

---

## 방법 1: Dictionary(hash map) 활용

Dictionary 방식은 배열을 한 번 순회하면서, 

현재 원소의 보수(`target - 현재원소`)가 이미 등장했는지 확인하는 방식이다.

### 코드 예시

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        L = len(nums)
        # num의 index를 저장하는 dict
        dic = {}

        for i in range(L):
            if target - nums[i] in dic:
                return [i, dic[target - nums[i]]]
            else:
                dic[nums[i]] = i
        
        return []
```

---

### 장점

- **빠른 조회** 

Dictionary를 사용하면 

보수 값의 존재 여부를 평균 O(1) 시간에 확인할 수 있으므로 전체 시간 복잡도는 O(n)이다.

- **원본 배열 유지** 

배열을 정렬할 필요가 없으므로, 원래 인덱스를 그대로 반환할 수 있다.

### 단점
- **추가 메모리 사용** 

최악의 경우 배열의 크기만큼 Dictionary에 데이터를 저장해야 하므로 O(n)의 추가 공간이 필요하다.


- **특정 상황 고려** 

딕셔너리 방식은 정확한 `target` 합을 찾는 데 최적화되어 있다.

즉 "**target과 가장 가까운 두 원소의 합**"을 구해야 한다면, 

별도의 후보군 비교 로직을 추가해야 하므로 다른 방법을 사용해야한다.

---

## 방법 2: Two Pointer 활용

Two Pointer 방식은 배열이 **정렬되어 있을 때** 사용하면 된다.

배열의 양쪽 끝에 포인터를 두고, 

두 포인터가 가리키는 값의 합과 `target`을 비교하며 포인터를 이동한다.

### 코드 예시

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        ### nums는 정렬이 되어있다고 가정 ###
        left = 0
        right = len(nums) - 1

        while left < right:
            summation = nums[left] + nums[right]

            if summation == target:
                return [left, right]

            ## 합이 더 크다면 
            # nums[right] > nums[right - 1]이므로 right -= 1
            if summation > target:
                right -= 1

            ## 합이 더 작다면
            # nums[left] < nums[left + 1]이므로 left += 1
            else:
                left += 1

        return []
```

1. 배열을 정렬 (단, 이 경우 원래 인덱스 정보가 손실되므로, 인덱스를 함께 저장하거나 별도로 관리)
2. 왼쪽 포인터(`left`)와 오른쪽 포인터(`right`)를 배열의 시작과 끝으로 초기화
3. 두 포인터가 가리키는 합을 계산하고, 
  - 합이 `target`보다 작으면 왼쪽 포인터를 오른쪽으로 이동
  - 합이 `target`보다 크면 오른쪽 포인터를 왼쪽으로 이동
4. 합이 `target`에 도달하면 정답을 반환

---

### 장점

- **공간 효율적**

추가적인 자료구조 없이 포인터만 사용하므로 메모리 오버헤드가 적다.

- **근접한 합 찾기** 

> [두 용액 Solution](../baekjoon-2470)

정렬된 배열에서 여러 후보군 중 `target`과 가장 근접한 합을  

약간의 코드를 추가하여 찾을 수 있다.

### 단점

- **정렬 과정** 

정렬이 필요한 경우 O(n log n)의 시간이 소요된다.

- **원본 인덱스 문제** 

정렬 시 원본 배열의 인덱스 정보가 변하므로, 원본 인덱스를 반환해야 할 경우 별도의 로직이 필요하다.

즉, 두 원소의 값을 반환할 경우 사용하면 좋다.

---

## 언제 어떤 방법을 선택할까?

### Dictionary(hash map) 방식

- 배열이 정렬되어 있지 않거나 정렬을 허용하지 않는 경우

- 원본 인덱스 반환이 중요한 경우

- 정확히 `target`과 일치하는 합을 빠르게 찾고자 할 때

### Two Pointer 방식

- 배열을 정렬해도 상관없거나 이미 정렬되어 있는 경우

- 공간 사용을 최소화하고자 할 때

- 문제의 변형으로 `target`과 가장 가까운 합을 구하는 경우


| 사용 조건             | Dictionary | Two Pointer |
|----------------------|---------------------------------------------------------|-----------------------------------------------------------------|
| **배열 상태** | 정렬 X | 정렬 O |
| **출력 형식** | 원본 인덱스 | 두 원소의 값 |
| **목표 합 검색** | `target`과 일치하는 합 찾기 | `target`과 가장 가까운 합 찾기  |
| **공간 사용** | O(n)의 공간 복잡도가 필요함 | 공간 복잡도가 최소화됨 |

---

## 결론

두 수의 합 문제는 문제의 요구사항에 따라 다양한 해결법을 적용할 수 있다.

정확한 `target` 합을 찾을 때 **Dictionary**를 사용하고

`target`과 가장 가까운 합을 찾는 문제에 **Two Pointer**를 적용하면 된다.
  
  
