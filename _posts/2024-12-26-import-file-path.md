---
title: '[Python] 라이브러리 import와 파일 경로 정리'
date: 2024-12-26 13:00:00 +09:00
categories: [Python, Pyinstaller]
tags:
  [
    Python,
    Python Library,
    Pyinstaller
  ]
---

# Python의 상대 경로 정리

`Python`에서 **상대 경로로 import하거나 파일을 불러올 때** 보통의 경우 상대경로를 사용하게 된다.

이 때, 작업 경로(`cwd: current working directory`)의 영향을 받는 부분과 그렇지 않은 부분에 대해 정리해봤다.