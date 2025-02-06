---
title: '[Network] Loopback & Hostname'
date: 2025-02-06 12:00:00 +09:00
categories: [Network, Linux]
tags:
  [
    Network,
    Linux
  ]
---

## Loopback 이란?

네트워크 장치가 자기 자신과 통신할 수 있는 기능이다.

네트워크를 테스트하거나 시스템 내부에서 프로세스 간 통신을 할 때 주로 사용한다.

### 주요 특징

특정 주소(예: `127.0.0.1`)로 보낸 데이터가 바로 자기 시스템[^1]으로 돌아온다.

주요 특징들은 아래와 같다.

---

#### 1. 통신 방식
네트워크 카드(NIC)가 없어도, 즉 네트워크 인터페이스가 없어도, 사용할 수 있다.

루프백 인터페이스(`lo`)를 통해 패킷이 네트워크 장치를 거치지 않고 바로 돌아오기 때문이다. 

리눅스에서 루프백 인터페이스는 아래 명령어를 통해 확인할 수 있다.

```bash
$> ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
  link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
  inet 127.0.0.1/8 scope host lo
      valid_lft forever preferred_lft forever
  inet6 ::1/128 scope host
      valid_lft forever preferred_lft forever

$> ifconfig

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
      inet 127.0.0.1  netmask 255.0.0.0
      inet6 ::1  prefixlen 128  scopeid 0x10<host>
      loop  txqueuelen 1000  (Local Loopback)
      RX packets 1474161760  bytes 323042792762 (300.8 GiB)
      RX errors 0  dropped 0  overruns 0  frame 0
      TX packets 1474161760  bytes 323042792762 (300.8 GiB)
      TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

```

#### 2. 고정된 IP 주소 사용
IP 프로토콜의 Version에 따라서 사용하는 주소가 정해져 있다.

루프백 인터페이스에서 확인할 수 있다.

- IPv4: `127.0.0.1`을 주로 사용
  
  `127.0.0.1/8`을 사용하므로 `127.x.x.x`로 호출을 하면 내 시스템이 응답을 한다.

  ```bash
  $> ping 127.8.9.10
  PING 127.8.9.10 (127.8.9.10) 56(84) bytes of data.
  64 bytes from 127.8.9.10: icmp_seq=1 ttl=64 time=0.054 ms
  64 bytes from 127.8.9.10: icmp_seq=2 ttl=64 time=0.026 ms
  64 bytes from 127.8.9.10: icmp_seq=3 ttl=64 time=0.024 ms
  ```

- IPv6: `::1/128` 주소 하나만 사용

  IPv4와 다르게 IPv6는 주소 하나만 사용한다.
  ```bash
  $> ping6 ::1
  PING ::1(::1) 56 data bytes
  64 bytes from ::1: icmp_seq=1 ttl=64 time=0.043 ms
  64 bytes from ::1: icmp_seq=2 ttl=64 time=0.048 ms
  64 bytes from ::1: icmp_seq=3 ttl=64 time=0.039 ms
  ```

---

## Hostname

`hostname`은 시스템의 네트워크 식별자로, 각 컴퓨터에 부여되는 이름이다.

즉, IP 주소 대신 사람이 기억하기 쉬운 방식으로 시스템을 식별하기 위한 텍스트 기반 이름이다.

---

### Hostname 확인 & 설정

아래 명령어로 Linux 시스템의 `hostname`을 확인, 변경을 할 수 있다.

```bash
# hostname 확인
$> hostname
localhost.localdomain

# hostname 임시 변경
$> sudo hostname domain-test
$> hostname

domain-test

# hostname 영구 변경
## 1. `/etc/hostname` 변경
$> sudo vi /etc/hostname

hostname-test

## 2. `hostnamectl`
$> sudo hostnamectl set-hostname hostname-test-2

## 정확한 적용을 위해 재부팅
$> sudo reboot
```

---

## Loopback IP와 Hostname

서버에 새로운 서비스를 배포하는 도중 아래와 같은 에러가 발생하였다.

- `unable to resolve host {hostname}: Temporary failure in name resolution`

해법은 `/etc/hosts` 호스트 파일에 `127.0.1.1`을 `hostname`으로 매핑되도록 설정을 해야한다.
> [참고 사이트](https://askubuntu.com/questions/1343609/sudo-unable-to-resolve-host-hostname-temporary-failure-in-name-resolution)

### `127.0.1.1`

`127.0.1.1`은 리눅스 Debian 배포판에서 주로 사용하는 특수한 `loopback ip`이다.

자기 시스템의 `hostname`을 매핑하기 위해 사용하고 아래와 같이 설정하면 된다.

- 만약 `hostname`이 `worker-node`라면

  ```bash
  $> sudo vi /etc/hosts
  
  127.0.0.1   localhost
  127.0.1.1   worker-node # 해당 라인을 추가
  ```

--

## 결론

사실 `127.0.1.1`이 어떤 IP를 뜻하는지 정리를 하기 위해 이 긴 글을 작성하였다.

`127.0.1.1`은 Debian 계열 리눅스에서 `hostname`이 `loopback`을 하기 위해 사용하는 IP이다.

---

## 참고사항

### `DNS Server` 란

`Domain Name System`의 약자로  `domain` 매핑되는 `IP` 주소 정보를 가지고 있어 `domain`을 IP 주소로 변환하는 서버이다.

여러 `DNS Server`가 존재하고 계층적으로 구성되어 있다.

주로 사용하는 `DNS Server`는 구글이 운영하는 `8.8.8.8` 서버이다.

---

### Hostname Resolution

`hostname`은 `ip` 대신 사용하는 것이므로 컴퓨터가 이해할 수 있도록 `ip`로 바꾸어 줘야한다.

`hostname` 혹은 도메인(`domain`, 예: `www.google.com`)을 IP로 바꾸는 과정을 `Name Resolution`, `Hostname Resolution`이라고 한다.

---

### Name Resolution 적용 순위

`hostname` 혹은 `domain`은 이미 어딘가에 등록되어 있다.

등록되어 있는 여러 파일 혹은 서버 중 우선순위가 존자하여 해석을 한다.

일반적인 우선순위를 알아보자.

---

#### 1. `/etc/hosts`
가장 먼저 시스템 로컬에 저장되어있는 호스트네임과 IP 매핑 정보를 확인한다.

```bash
$> sudo cat /etc/hosts

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```

#### 2. 시스템 캐시 (`nscd`, `systemd-resolved`)  

`nscd`(Name Service Cache Daemon) 또는 `systemd-resolved`가 실행 중이면, 

**최근 조회한 DNS 결과를 캐시**하여 빠르게 응답한다.  

아래 명령어로 시스템 캐시를 사용할 수 있다.

```bash
# `nscd`가 없는 경우, 설치
## Debian/Ubuntu 계열
$> sudo apt-get install nscd

## RedHat/CentOS 계열
$> sudo yum install nscd

# 캐시 서비스 시작
## nscd 시작
$> sudo systemctl start nscd

## systemd-resolved 시작
$> sudo systemctl start systemd-resolved
```
  - 대부분의 최신 리눅스 배포판에는 `systemd-resolved`가 포함되어 있음


#### 3. `/etc/resolv.conf`에 정의된 `DNS Server`

시스템에 적용이 되어있는 `DNS Server`에 `domain`을 요청하여 `IP`를 반환 받는다.

```bash
$> cat /etc/resolv.conf

nameserver 8.8.8.8
nameserver 168.126.63.1 # KT DNS Server
```

---

### 예제: `example.com`의 IP 주소

```sh
ping example.com
```

위와 같이 `example.com`에 핑을 날리면, 아래와 같은 단계로 ip 주소를 검색한다.

1. `/etc/hosts`에서 `example.com`이 있는지 확인.  
2. 시스템 캐시에 `example.com`의 ip 주소가 있는지 확인.
3. `/etc/resolv.conf`에서 DNS 서버 목록을 확인하고, 해당 서버에 `example.com` 질의.  
4. 응답을 받아 해당 IP 주소로 연결 시도.  

---

[^1]: 네트워크에서 말하는 **시스템**은 보통 모든 독립적인 장치를 뜻한다. (서버, 클라이언트, 라우터, IoT 기기 등)