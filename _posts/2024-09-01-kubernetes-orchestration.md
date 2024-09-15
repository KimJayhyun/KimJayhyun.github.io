---
title: '[Kubernetes] # 1-2. 컨테이너 한방 정리 - Container & Orchestration'
date: 2024-09-01 23:00:00 +09:00
categories: [Kubernetes, 쿠버네티스 어나더 클래스 지상편]
tags:
  [
    쿠버네티스 어나더 클래스 지상편,
    Kubernetes,
    Container,
    Linux
  ]
---


# Container와 Container Orchestration
> 인프런의 [쿠버네티스 어나더 클래스 지상편 - Spring 1,2](https://www.inflearn.com/course/%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4-%EC%96%B4%EB%82%98%EB%8D%94-%ED%81%B4%EB%9E%98%EC%8A%A4-%EC%A7%80%EC%83%81%ED%8E%B8-sprint1) 강의 복습
{: .prompt-info }

#### 기술 흐름으로 이해하는 컨테이너
- [\# 1-1. 컨테이너 한방 정리 - 기술의 흐름](/posts/kubernetes-container/) 

---

## Docker Engine
![alt text](assets/img/posts/2024-09-01/container-orchestration/docker_engine.png)

Docker는 High Level Container Runtime이다.

Docker Engine에는 컨테이너를 생성하는 기능인 containerd 이외에도 여러 기능을 지원한다.

- Log
- Network
- Storage

이런 부가기능이 사용자 편의성을 높혔다.

하지만, Kubernetes에서는 컨테이너를 생성하는 기능만 필요하다.

---

## Container Runtime
> 

![alt text](assets/img/posts/2024-09-01/container-orchestration/container_runtime.png)

---

### LXC

LinuX Container의 약자로 Low Level 컨테이너 런타임으로 최초의 컨테이너 런타임이다.

아래 Kernel Level의 기술로 만들어졌다.

- `chroot, namespace, cgroup`

VM을 대신하여 운영체제를 컨테이너 가상화로 나누기 위한 목적으로 개발되었다.

---

### Docker

LXC를 활용하는 Low Level 컨테이너 런타임인 libcontainer를 만든 후,

High Level 컨테이너 런타임인 Docker가 개발되었다.

App들을 독립적인 환경에서 실행하기 위한 목적을 가지고 있다.

---

### Kubernetes의 Container Runtime 사용

Kubernetes에는 kube-apiserver와 kubelet이라는 컴포넌트가 있다.

kube-apiserver는 Kubernetes의 모든 API를 받아 담당하는 컴포넌트를 실행한다.

예를 들어, 컨테이너 2 개를 포함한 Pod를 생성하라는 명령어를 Kubernetes에 보내면

kube-apiserver가 Pod 생성을 담당하는 kubelet에 명령을 전달한다.

그러면 kubelet은 컨테이너 런타임에 컨테이너 생성 요청을 2 번 한다.

---

### kubelet과 CRI

#### v1.0 ~ v1.20

![alt text](assets/img/posts/2024-09-01/container-orchestration/v1.0.png)

kubelet에서 컨테이너 런타임 API를 호출을 한다.

Kubernetes 1.0 버전에서는 kubelet 소스에 docker, rkt 호출 API를 모아둔 패키지가 있었다.

허나, 시간이 지날 수록 컨테이너 런타임이 늘어난다.
  
- Docker에서 containerd를 분리하는 경우 등

#### v1.5 ~ v1.23

![alt text](assets/img/posts/2024-09-01/container-orchestration/v1.5.png)

이에 Kubernetes는 1.5 버전부터 kube에 Interface를 만들고 

Interface의 구현부을 CRI(Container Runtime Interface)라고 명명했다.

이 구현부에서 각각의 컨테이너 런타임 API를 호출한다.

추가적으로 CRI는 오픈소스인 Kubernetes 프로젝트에 포함되어 있으므로,

docker, rkt에서 Kubernetes 프로젝트에 contribution을 하는 형태였다.

위 내용을 잘못 이해하여 docker를 kubernetes에서 제외한다는 소문이 돌았지만,

CRI 규격에 맞추어진 dockershim이 있으므로 사실은 아니였다.

#### v1.24 ~ 

![alt text](assets/img/posts/2024-09-01/container-orchestration/v1.24.png)

v1.5 ~ v1.23까지 dockershim에 관리가 안 되고 버그가 많아서

다시 kubernetes에서 제외한다는 소문이 돌았다.

MIRANTIS가 인수하기 전 수익모델이 없어 관리하기 힘들어서 그런 것으로 예상한다.

인수 이후, v1.24 버전부터 docker의 CRI인 dockershim을 MIRANTIS에서 개발하였고,

이를 미란티스 컨테이너 런타임이라고 불렀다.

또한, CRI가 kubernetes 프로젝트에 포함될 경우, 

컨테이너 런타임이 업데이트가 될 때마다 kubernetes 프로젝트도 업데이터가 되어야 한다.

이 문제를 해결하기 위해서, 

containerd에서는 CRI-Plugin이라는 기능을 추가하고

미란티스 런타임도 cri-dockerd를 만들었다.

---

### OCI와 runC
> 컨테이너 런타임을 변경하면 container image도 다시 만들어야할까?

이 문제를 해결하기 위해 컨테이너 런타임이 컨테이너를 만들 때,

지켜야할 규약을 관리하는 `OCI`가 설립되었다.

`OCI`의 규약을 지켜서 컨테이너를 만들면, 다른 컨테이너 런타임과 공유를 할 수 있다. 

docker에서 이 규약을 맞추기 위해 `runC`를 만들었고, containerd에서 `runC`를 사용하도록 변경하였다.

`runC`는 `libcontainer`와 달리 LXC를 사용하지 않고, 바로 Kernel 레벨의 가상화 기술을 사용한다.