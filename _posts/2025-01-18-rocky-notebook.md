---
title: '[Home Server] Rocky Linux Headless 설정'
date: 2025-01-08 09:00:00 +09:00
categories: [Rocky, Home Server]
tags:
  [
    Linux,
    Redhat,
    Rocky,
    Centos,
    Home Server
  ]
---

노트북을 가지고 Home Server를 구축해볼려고 한다.

노트북 디스플레이가 계속 켜져있으니 뭔가 보기 싫고,

덮개도 덮어놓고 싶어서 설정하는 방법을 찾아 정리해보았다.

## Headless Mode

**물리적인 입출력 장치**가 없이 컴퓨터를 운영하는 방식을 `Headless Mode`라고 한다.

즉, **사용자 인터페이스**가 없고 `ssh`와 같은 원격 관리 도구로 접속하여 관리한다.
- 마우스, 키보드, 모니터 등을 말함

이는 아래와 같은 이점을 가질 수 있다.

| **이점**             | **설명**                                                                 |
|----------------------|--------------------------------------------------------------------------|
| **시스템 리소스 절약**     | GUI 관련 프로세스들이 실행되지 않아 CPU와 메모리 사용량이 감소         |
| **전력 소비 감소**         | 디스플레이 구동에 필요한 전력을 절약                                    |
| **보안 강화**             | 물리적 인터페이스가 비활성화되어 직접적인 접근을 차단                  |
| **서버 용도에 최적화**     | 원격 접속을 통한 관리가 가능하며, 백그라운드 서비스 운영에 적합        |


---

<!-- ## 디스플레이 비활성화

반드시 `ssh`와 같은 원격 관리 도구를 설치한 후에 진행하자.

시스템에 대한 설정을 하는 부분들이므로 `root` 권한이 필요하다. -->

## CLI 환경으로 변경

모니터 출력이 아예 안 됬으면 좋겠지만, 자료들을 조금 더 찾아봐야될 것 같다.

먼저 GUI 환경을 CLI 환경으로 바꾸는 작업만 진행하였다.

만약 OS를 GUI 환경으로 구성을 한 경우, 아래와 같이 CLI 환경으로 변경할 수 있다.

### 1. 기본 런레벨(target) 변경
> 시스템 동작 상태

```bash
# 현재 기본 target 확인
$> systemctl get-default

# multi-user.target으로 변경 (GUI 비활성화)
$> sudo systemctl set-default multi-user.target
```

만약 GUI가 필요해지면 아래 명령어를 사용하자.
```bash
$> sudo systemctl set-default graphical.target
```

또 [런레벨 정리](#런레벨target)에서 자주 사용하는 런레벨을 확인할 수 있다.

---

### 2. 디스플레이 매니저 비활성화

1. 실행 중인 디스플레이 매니저 확인

아래 명령어를 사용해서 디스플레이 매니저를 확인한다.

```bash
$> systemctl status display-manager
```
  - **GNOME**: GDM (gdm)
  - **KDE Plasma**: SDDM (sddm)
  - **XFCE, MATE**: LightDM (lightdm)

2. 디스플레이 매니저 비활성화

아래 명령어를 사용해서 디스플레이 매니저를 비활성화한다.

```bash
# GNOME Display Manager 비활성화
$> sudo systemctl stop gdm
$> sudo systemctl disable gdm

# 또는 다른 디스플레이 매니저의 경우
$> sudo systemctl stop lightdm  # LightDM의 경우
$> sudo systemctl disable lightdm

$> sudo systemctl stop sddm    # SDDM의 경우
$> sudo systemctl disable sddm    # SDDM의 경우
```

아래 명령어로 다시 디스플레이 매니저를 활성화할 수 있다.

```bash
# 디스플레이 매니저 활성화
$> sudo systemctl enable gdm  # GNOME의 경우
```

--- 

## 절전 모드 설정

노트북의 덮개를 닫고 `클램쉘` 모드로 사용하고 싶다.

노트북 덮개를 닫아도 시스템이 동작할려면 추가 설정이 필요하다.

### `logind` 서비스 설정
> [logind](#logind-서비스) 서버스란?

`/etc/systemd/logind.conf` 파일에서

아래 내용을 수정하여 절전모드로 전환되지 않도록 한다.

- `#HandleLidSwitch=suspend` => `HandleLidSwitch=ignore`

```bash
$> sudo vi /etc/systemd/logind.conf

[Login]
#NAutoVTs=6
...
#HandleHibernateKeyLongPress=ignore
HandleLidSwitch=ignore
#HandleLidSwitchExternalPower=suspend
#HandleLidSwitchDocked=ignore
...
```


아래 명령어로 `logind`를 재시작한다.
```bash
$> sudo systemctl restart systemd-logind
```

---

## 마치며...

Home 서버에 `kubernetes cluster`를 설치하고 이것 저것 해볼려고 한다.

아직 `Grafana`, `Grafana loki`, `Prometheus` 등 모니터링 툴에 익숙하지 않아서,

모니터링 파이프라인을 구축해볼까 한다.

---

## 참고 내용

### 런레벨(target)
systemd를 사용하는 최신 Linux에서는 시스템 동작상태를 `target`한다.

- target 종류 확인
```bash
# target 목록 확인
systemctl list-units --type=target
```

#### 주요 target 종류

| Target Name         | Runlevel | Mode                | Description                        |
|:-------------------|:--------:|---------------------|------------------------------------|
| `poweroff.target`   | 0        | System Shutdown     | 시스템 종료                        |
| `rescue.target`     | 1        | Single User Mode    | 시스템 복구용                      |
| `multi-user.target` | 3        | CLI Multi-User     | 서버 환경, 네트워크 활성화         |
| `graphical.target`  | 5        | GUI Multi-User     | 데스크톱 환경 제공                 |

---

### logind 서비스
`systemd-logind`는 Linux 시스템에서 `systemd`의 일부로,

사용자 로그인을 관리하는 중요한 서비스이다.

이 서비스는 사용자 세션을 관리하고, 

여러 가지 시스템 자원을 할당 및 추적하는 기능을 제공합니다.

### 주요 기능

1. **사용자 세션 관리**  
   - 사용자의 로그인 세션을 관리하고, 세션 활성화 및 비활성화 시 리소스를 정리하여 효율적인 시스템 자원 사용을 돕습니다.

2. **멀티 시트 지원**  
   - 하나의 시스템에서 여러 사용자가 각자의 세션을 동시에 사용하도록 지원합니다. 각 사용자에게 별도의 키보드, 마우스, 디스플레이를 제공하여 시스템을 공유할 수 있습니다.

3. **시스템 전원 관리**  
   - 사용자가 로그인하거나 로그아웃할 때 시스템을 절전 모드로 전환하거나 다시 활성화합니다. 특정 조건에서 자동으로 재부팅, 종료, 절전 모드 전환을 관리합니다.

4. **장치 접근 관리**  
   - 사용자의 장치 접근 권한을 관리하며, 로그아웃 시 해당 장치에 대한 접근을 자동으로 차단합니다.

5. **세션 잠금 및 잠금 해제**  
   - 사용자가 자리를 비우면 세션을 잠그고, 잠금 해제를 통해 세션을 보호합니다.