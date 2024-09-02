---
title: '[Kubernetes] # 1-1. 컨테이너 한방 정리 - 기술의 흐름'
date: 2024-09-01 22:00:00 +09:00
categories: [kubernetes, 쿠버네티스 어나더 클래스 지상편]
tags:
  [
    쿠버네티스 어나더 클래스 지상편,
    kubernetes,
    container,
    Linux
  ]
---


# 기술 흐름으로 이해하는 컨테이너
> 인프런의 [쿠버네티스 어나더 클래스 지상편 - Spring 1,2](https://www.inflearn.com/course/%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4-%EC%96%B4%EB%82%98%EB%8D%94-%ED%81%B4%EB%9E%98%EC%8A%A4-%EC%A7%80%EC%83%81%ED%8E%B8-sprint1) 강의 복습
{: .prompt-info }

## 컨테이너란?
```text
실행중인 컴퓨터의 호스트 운영체제에 격리된 공간을 설정하고, 
이 격리공간 내에 호스트 운영체제로부터 독립된 프로세스를 실행시키는 기술과 
이를 위한 소프트웨어 구성 일체를 이야기한다.

동일한 하드웨어 아키텍쳐(특히 CPU)와
동일한 OS 커널을 보유한 수많은 컴퓨터에서 컨테이너로 이미지화한 소프트웨어의 
동일한 동작을 보장한다.

- 나무위키
```

즉, 컨테이너란 아래 두 가지를 만족시키는 기술을 말한다.

1. Host OS에서 격리된 공간을 가짐
2. 이 공간에서 Host OS와 독립된 프로세스로 실행

`Virtual Machine(VM)`과 마찬가지로 하드웨어 아키텍처 

즉, 물리 PC와 동일한 동작을 보장한다.

---

## 컨테이너 한방 정리

![alt text](assets/img/posts/2024-09-01/kubernates-container/컨테이너_한방_정리.png)

---

## Linux 흐름
![alt text](assets/img/posts/2024-09-01/kubernates-container/리눅스_흐름.png)

### Red Hat 배포판 
#### 1. Red Hat의 배포 순서
1. fedora linux : 기능 개발 버전
2. Red Hat Enterprise Linux(RHEL) : 안정화된 유료 버전
3. CentOS : 안정화된 무료 버전
   - CentOS 7 : 2024 년도에 지원 종료
   - CentOS 8 : 2021 년도에 지원 종료

기업용 배포판 점유율 1 위인 이유 

- `CentOS`를 무료로 배포하여 결국 `RHEL`을 운영용으로 선택을 유도

#### 2. IBM에 인수 후
CentOS의 점유율을 RHEL로 가지고 오는 전략

1. fedora linux : 기능 개발 버전
2. CentOS Stream : 기능 테스트 배포판
   - 바이너리 호환성 보장을 안 함
3. Red Hat Enterprise Linux : 안정화된 유료 버전

---

### CentOS 지원 종료에 따른 OS 선택
1. RHEL로 전환
2. CentOS를 기술지원해주는 기업 선택
3. 타 OS에서 제공하는 마이그레이션 스크립트
4. RHEL 복제 버전인 Rocky Linux, AlmaLinux 사용

---

## Kubernetes를 사용하는 이유
> 기존 APP & Container 배포 방식 vs Container Orchestration의 배포 방식

![alt text](assets/img/posts/2024-09-01/kubernates-container/container_vs_container_orchestration.png)

많은 시스템 운영 노하우를 통하여 App을 컨테이너에 담아서 배포하는 방식

- Kubernetes : Container Orchestration의 표준 Tool

---

## Container & Container Orchestration 흐름
![alt text](assets/img/posts/2024-09-01/kubernates-container/container_and_container_orchestration.png)

### Docker의 보안 이슈
Docker는 `root` 권한으로 운영을 해야했고, 이는 보안상 문제가 되었다.

- rkt의 등장 요인
 
이후, root-less 모드를 지원하여 해결하였다.

---

### Docker와 Kubernetes
Container 운영을 손쉽게 해주는 Container Orchestration Tool들이 개발되었다.

시기상, Docker를 기준으로 Container Orchestration을 개발했다.
  
이후, Kubernetes가 Container Orchestration의 표준이 되었다.

Kubernetes를 표준화를 하면서 Docker를 지원하지 않을 수도 있다는 소문이 생김

- Docker가 Kubernetes의 인터페이스와 맞지 않았기 때문

Kubernetes와 호환을 위해 Docker 이외에 다른 Container Runtime Tool들이 만들어짐

---

### CNCF와 containerd & cri-o
이후 Container Tool은 크게 두 가지가 있다.

1. containerd : docker에서 컨테이너를 만드는 기능만 분리
2. cri-o : Red Hat에서 개발한 컨테이너

두 가지 모두 CNCF(Cloud Native Computing Foundation)에 기부되었다.
- CNCF : 클라우드 네이티브 기술을 발전시키기 위해 다양한 오픈 소스 프로젝트를 관리하고 지원하는 조직

CNCF에는 `Graduated Project`와 `Incubating Project`가 있다.

- Graduated project : CNCF에서 인증(졸업)한 기술 성숙도가 높은 프로젝트
- Incubating project : 유망하다고 인정받지만 비교적 기술 성숙도, 안정성이 낮은 프로젝트

---

### Docker 그 이후
Docker는 `MIRANTIS`에 인수가 되어 Kubernetes의 인터페이스를 맞추었고,

Kubernetes에서 빠지지 않았다.

---

## 결론
쿠버네티스와 컨테이너

1. Kubernetes는 현재 표준을 넘어 여러 분야에서 사용되고 있다.
2. Kubernetes는 컨테이너를 더 쉽게 사용할 수 있게 해준다.
3. Container는 Kubernetes와의 인터페이스가 중요하다.