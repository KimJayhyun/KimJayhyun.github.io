---
title: '[Linux] ISO 파일로 패키지 리포지토리 구축하기'
date: 2024-12-10 13:00:00 +09:00
categories: [Linux, Yum]
tags:
  [
    Linux,
    Redhat,
    Rocky,
    Centos,
    ISO
  ]
---

# On-premise 환경의 패키지 설치
> 네트워크 연결 제한을 곁들인...

가끔 네트워크 연결이 제한된 On-premise 환경의 서버를 구축할 일이 있다.

이때, `iso` 파일을 마운트한 후 `Yum Repository`로 설정하여 운영체제의 패키지들을 설치할 수 있다.

아래와 같이 생각보다 많은 패키지들을 설치할 수 있다.
  - 물론 아래보다 **더 많은 패키지들을 다운로드**받을 수 있다.
  - 각 패키지의 버전은 `iso` 파일에 포함된 버전으로 고정되므로, 필요 버전을 확인하는 것이 중요하다.

| **카테고리**               | **패키지명**              | **설명**                                        |
|----------------------------|---------------------------|-----------------------------------------------|
| **기본 시스템 관리 도구**   | vim                       | 텍스트 편집기                                   |
|                            | net-tools                 | 네트워크 관리 도구 (예: ifconfig, netstat)      |
|                            | curl                      | URL을 통해 데이터를 전송하는 명령줄 도구         |
| **네트워크 및 서버 관리 도구**| openssh-server            | SSH 서버 패키지, 원격 연결을 위한 필수 패키지   |
|                            | httpd                     | Apache 웹 서버                                 |
|                            | nginx                     | Nginx 웹 서버                                  |
| **데이터베이스 관련 패키지**  | mysql-server              | MySQL 데이터베이스 서버                        |
|                            | mariadb-server            | MariaDB 서버 (MySQL의 오픈소스 대체)            |
|                            | postgresql-server         | PostgreSQL 데이터베이스 서버                    |
| **개발 도구**               | gcc                       | GNU 컴파일러 컬렉션, C, C++ 개발을 위한 도구     |
|                            | make                      | 빌드 자동화 도구                                |
|                            | git                       | 버전 관리 도구                                  |
|                            | python3                   | Python 프로그래밍 언어                          |
| **웹 애플리케이션 및 프레임워크** | php                       | PHP 프로그래밍 언어                        |
|                            | perl                      | Perl 프로그래밍 언어                            |
|                            | ruby                      | Ruby 프로그래밍 언어                            |

---

# ISO 파일이란

**ISO 이미지 파일**이라고도 하며, CD, DVD 또는 Blu-ray와 같은 디스크의 전체 내용을 디지털 형식으로 **압축하여 저장한 파일**이다. 

이 파일은 **디스크 이미지**를 그대로 복제한 것이므로 실제 디스크와 동일한 구조를 가지고 있다.

즉, 디스크의 부트 로더, 파일 시스템, 프로그램 파일 등 모든 구성 요소를 포함하여, 원본 디스크를 그대로 재현한다.

`Windows` 운영체제에서는 더블클릭만으로도 `ISO` 파일을 가상 드라이브로 마운트한다.

### 사용 예
- **운영 체제 설치**: ISO 파일은 Linux 배포판, Windows 설치 CD 등 운영 체제 설치 파일을 배포할 때 많이 사용됩니다.
- **백업**: 중요한 데이터를 광학 미디어로 백업할 때 ISO 파일 형식을 사용하면 데이터가 손상되지 않고 안전하게 저장될 수 있습니다.
- **소프트웨어 배포**: 많은 소프트웨어 개발자가 ISO 파일 형식으로 프로그램을 배포합니다. 사용자는 ISO 파일을 다운로드한 후, 이를 설치하거나 실행할 수 있습니다.


---

# Yum Repository 설정

Red Hat 계열 리눅스 배포판 중 `Rocky 9.5`로 테스트를 진행하였다.

아래 명령어들은 모두 `root` 권한이 필요하다.

## 1. **ISO 파일 마운트하기:**
리눅스에서는 자동 마운트가 되지 않으므로, ISO 파일을 서버에 마운트해야 한다. 

예를 들어, `/mnt/iso` 디렉터리를 만들어서 ISO 파일을 마운트할 수 있다.

```bash
$ sudo mkdir /mnt/iso
$ sudo mount -o loop /path/to/your/rocky-linux.iso /mnt/iso
```

## 2. **YUM Repository 설정:**
ISO 파일을 yum repository로 설정하려면, `/etc/yum.repos.d/` 디렉터리에 새로운 repo 파일을 만들어야 한다.

파일의 확장자가 `.repo`이면 repository 설정 파일로 인식을 한다.

예를 들어, `rocky-iso.repo`라는 파일을 생성해보자.

```bash
$ sudo vi /etc/yum.repos.d/rocky-iso.repo
```

그리고 다음과 같은 내용을 추가한다.

```ini
[rocky-iso-AppStream]
name=Rocky Linux $releasever - AppStream # 리포지토리 이름
baseurl=file:///mnt/iso/AppStream # repository 폴더 경로
enabled=1 # 1 : 사용 // 0 : 사용하지 않음
gpgcheck=0 # GPG 서명을 사용하지 않음

[rocky-iso-BaseOS]
name=Rocky Linux $releasever - BaseOS
baseurl=file:///mnt/iso/BaseOS
enabled=1
gpgcheck=0
```

## 3. **마운트된 ISO 파일 사용 확인**
아래 명령어를 통해 repository 설정을 확인할 수 있다.

```bash
$ sudo yum repolist

[jhkim@localhost ~]$ yum repolist
repo id                                                                                                                            repo name
rocky-iso-AppStream                                                                                                                Rocky Linux 9 - AppStream
rocky-iso-BaseOS                                                                                                                   Rocky Linux 9 - BaseOS
```

위처럼 설정한 2 개의 repository가 리스트에 나타나는 것을 확인할 수 있다.

## 4. **ISO 파일을 언마운트하기 (필요시)**
만약 서버를 재부팅하거나 마운트를 해제하려면, 아래 명령어로 ISO 파일을 언마운트할 수 있다.

```bash
$ sudo umount /mnt/iso
```