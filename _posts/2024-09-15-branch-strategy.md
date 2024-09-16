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

# Git Branch

Branch는 전체 코드를 복사하여 독립적으로 개발을 하기 위한 기능이다.

모든 버전 관리 시스템은 Branch를 지원한다.

하지만 Git의 Branch는 매우 가볍다.

이는 Git의 큰 장점이자, 우리가 Git을 쓰는 가장 큰 이유라고 생각해도 문제가 없지 않을까?

> 참고자료 : [[git-scm] Git 브랜치 - 브랜치란 무엇인가](https://git-scm.com/book/ko/v2/Git-%EB%B8%8C%EB%9E%9C%EC%B9%98-%EB%B8%8C%EB%9E%9C%EC%B9%98%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80)

Branch를 사용하면서 얻는 이점 중 몇 가지를 작성해봤다.

- 병렬 개발
  - 기능 격리 및 안정성 유지
- 작업 추적 및 이력 관리
  - `issue`를 통한 협업 및 문서화
- 코드 리뷰 및 협업 용이
  - `Pull Request(or Merge Request)`를 통한 코드 리뷰


또한 Branch를 `main` & `develop`으로 나눔으로써, CI/CD까지 도입이 가능하다.

이런 Branch를 효율적으로 사용하기 위해서는 여러 가지 방법이 있겠지만, 

그 중 Git Branch 관리 전략에 대해 정리했다.

---

# Git Branch Strategy

Git Branch Strategy를 간단하게 설명하자면 아래와 같다.

- 어떤 Workflow로 Branch를 사용할 것인가

Branch의 종류를 설정하고 어떤 Workflow로 Branch를 생성, 병합할 것인지 설정하는 것이다.

이 전략에는 여러 가지 종류가 있지만, 그 중 Git Flow, Github Flow에 대해서 정리했다.

---

## Git Flow
Git Flow는 `기능 개발`, `Release 준비`, `버그 수정`을 명확하게 구분하기 위해 여러 Branch를 사용한다.

그 중 `master`(or `main`) Branch는 `항상 배포가 가능하여야 한다.`라는 원칙을 지켜야한다.

이 원칙을 대부분의 Git Branch 전략이 지키고 있다.

Git Flow가 사용하는 대표적인 Branch는 아래와 같다.

- `master` : 바로 배포가 가능한 Branch
- `develop` : 다음 배포 버전을 개발하는 Branch
- `feature/*` : 기능 개발을 위한 Branch
- `release/*` : 배포를 준비하기 위한 Branch
- `hotfix/*` : 배포한 버전의 버그를 수정하기 위한 Branch

아래 유명한 그림을 보며 Workflowf를 설명 해보자.

![alt text](assets/img/posts/2024-09-15/branch-strategy/git_flow.png)


### Git Flow의 Workflow

아주 기본적인 Workflow를 로그인 기능 개발을 예시로 설명하자면, 

1. 초기에 Tag가 0.1인 `master`와 이를 복제한 `develop`가 있다.
2. 로그인 기능을 개발하기 위해 `feature/login` Branch를 생성한다.
3. 로그인 개발을 완료하면 `feature/login` Branch를 `develop` Branch에 Merge를 한다.
4. 그 동안 개발된 기능들을 포함하여 `develop` Branch를 `release/1.0` Branch에 Merge한다.
5. `release/1.0`에서 배포 준비를 하고, 버그를 발견하여 수정도 한다.
6. 배포 준비가 끝난다면 `release/1.0` Branch를 `master` Branch에 Merge한다.
7. `master` Branch에 Merge가 되면 배포가 되었다고 보고 Tag 1.0을 생성한다.

### hotfix를 위한 Workflow

왼쪽 상단 부분의 `hotfix` 관련 Workflow를 보면,

1. Tag 0.1인 `master` Branch에서 로그인 기능에 버그가 발생했다.
2. 이를 수정하기 위해 `hotfix/login` Branch를 생성한다.
3. 수정 후 `master` Branch와 `develop` Branch에 Merge한다.
  - 이 후, 버전에도 기능이 수정되야 하므로 `develop` Branch에도 Merge를 한다.
4. `master` Branch를 배포하고 Tag 0.2를 생성한다.

### Git Flow의 장단점

Git Flow를 사용하면 아래 장단점을 갖는다.

- 장점 : 복잡한 프로젝트에서 체계적이고 명확하게 Branch를 관리한다.
- 단점 : Branch가 많아지면서 관리가 복잡할 수 있다.

즉, 작은 프로젝트에서는 Git Flow가 너무 과할 수 있다.

---

## Github Flow

작은 프로젝트에서는 Git Flow가 너무 복잡할 수 있다. 

이 때는 Github Flow를 사용하여 간단한 Workflow를 구성할 수 있다.

Github Flow는 `master`, `feature/*` Branch만 사용한다.

![alt text](assets/img/posts/2024-09-15/branch-strategy/github_flow.png)


### Github Flow의 Workflow
위 그림을 보면 Git Flow의 `master`, `feature/*` Branch만 사용하는 것을 알 수 있다.

간단하게 설명하면,

1. `master` Branch에서 로그인 기능 개발을 위한 `feature/login` 생성한다.
2. 로그인 기능 개발이 끝나면 `master` Branch에 Merge를 한다.

### Github Flow의 장단점

Git Flow보다 간단해지면서 아래와 같은 장단점을 얻을 수 있다.

- 장점 : Branch를 간결하게 관리하고 빠르게 배포할 수 있다.
- 단점 : 릴리즈 준비 과정이나 복잡한 Workflow를 지원하기 어렵다.

---

# 그 외의 Branch Strategy

이 외에도 Github Flow를 확장하여 개발, 테스트, 운영 등을 구분하여 관리하는 `GitLab Flow`,

Github Flow와 같이 하나의 Branch를 사용하여 

지속적인 통합과 빠른 배포를 목표로 하는 `Trunck Based Development`가 있다.

---

# 결론

Git은 이제 개발에 없어서는 안 될 필수 도구가 되었다. 그 핵심은 바로 Branch 기능이다.

Branch를 나눔으로써 우리는 병렬 개발, 협업, 코드 리뷰 등이 가능해졌고,

CI/CD, DevOps, GitOps와 같이 Git을 활용한 여러 기술들 또한 사용할 수 있다.

프로젝트에 적합한 Branch 전략을 도입함으로써 Git이 제공하는 강력한 기능을 최대한 활용할 수 있을 것이다.