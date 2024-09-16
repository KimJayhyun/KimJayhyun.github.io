---
title: '[Git] Git Branch Strategy - Branch 관리 전략'
date: 2024-09-15 16:00:00 +09:00
categories: [Git, Branch Strategy]
tags:
  [
    Git,
    Git Branch Strategy,
    Git Branch Model
  ]
---

# What is Branch ?

모든 버전 관리 시스템은 Branch를 지원한다. Branch는 전체 코드를 복사하여 독립적으로 개발을 하기 위한 기능이다.

Git의 최고 장점을 Branch 모델이라고 뽑는 사람들이 많다. Git의 Branch는 매우 가볍기 때문이다.

다른 버전 관리 시스템과 달리 Branch를 만들어 작업하고 나중에 Merge를 하는 방법을 권장한다.

- 참고자료 : [[git-scm] 브랜치란 무엇인가](https://git-scm.com/book/ko/v2/Git-%EB%B8%8C%EB%9E%9C%EC%B9%98-%EB%B8%8C%EB%9E%9C%EC%B9%98%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80)

# Branch

우리가 Git을 쓰는 가장 큰 이유를 Branch라고 생각해도 문제가 없지 않을까?

Branch를 사용하면서 얻는 이점들을 생각나는 대로 작성해봤다.

- 병렬 개발
- 기능 격리 및 안정성 유지
- 버그 수정 및 긴급 대응
- 실험 및 테스트 용이
- 다양한 환경 지원
  - 개발, 운영, QA 환경 분리

- 작업 추적 및 이력 관리
- 코드 리뷰 및 협업 용이
  - `Pull Request(or Merge Request)`