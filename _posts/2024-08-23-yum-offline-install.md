---
title: '[Linux] 오프라인 환경에서 yum 패키지 설치' 
date: 2024-08-23 11:00:00 +09:00
categories: [Linux, yum]
tags:
  [
    Linux,
    Redhat,
    Rocky,
    Centos
  ]
---

# 오프라인 환경에서 패키지 설치를 위한 yum 활용법

네트워크가 연결되지 않은 서버에 패키지를 설치하기 위해, 

필요한 패키지와 그 의존성을 모두 RPM 파일로 다운로드한 후 

이를 오프라인 서버에 옮겨 설치할 수 있습니다.

---

## 1. 패키지 다운로드 준비

- 먼저 네트워크가 되는 서버에 패키지를 설치합니다.
- `yumdownloader`, `yum --downloadonly`, 그리고 `repotrack`를 사용하여 패키지를 다운로드하는 방법을 설명합니다.


### 1.1 `yumdownloader` 사용하기
> `yumdownloader`로 패키지와 그 의존성을 다운로드할 수 있습니다.

- `yumdownloader` 설치

```bash
$ sudo yum install yum-utils # yumdownloader가 포함된 패키지
```

- 패키지와 의존성 다운로드:

```bash
$ sudo yumdownloader --resolve --destdir=/path/to/save {package_name}
```
> `--resolve`: 지정한 패키지와 그 의존성 패키지들을 모두 다운로드합니다.  
> `--destdir`: 다운로드된 패키지들이 저장될 디렉터리를 지정합니다.

- 예를 들어, `httpd` 패키지를 다운로드하려면 다음과 같이 입력합니다.

```bash
$ sudo yumdownloader --resolve --destdir=/path/to/save httpd
```

---

### 1.2 `yum --downloadonly` 사용하기

- `yum --downloadonly`는 패키지와 그 의존성을 함께 다운로드할 수 있는 명령어입니다.

- `--downloadonly` 옵션이 적용되지 않는 경우, 아래 명령어로 설치를 합니다.

```bash
# 둘 중 한 가지 방법으로 설치를 합니다.
$ sudo yum install yum-plugin-downloadonly 
# 혹은
$ sudo yum install yum-downloadonly 
```

- 패키지와 의존성 다운로드:

```bash
$ sudo yum install --downloadonly --downloaddir=/path/to/save {package_name}
```

> `--downloadonly`: 패키지를 다운로드만 하고 설치는 하지 않습니다.  
> `--downloaddir`: 다운로드된 패키지들이 저장될 디렉터리를 지정합니다.

---

### 1.3 `repotrack` 사용하기

- `repotrack`는 패키지의 이력 추적과 저장소 스냅샷을 관리하는 도구로, 고급 기능을 제공합니다. 
- 복잡한 설정이 필요할 수 있습니다.

- `repotrack`는 `yum-utils`에 포함되어 있습니다.

```bash
$ sudo yum install yum-utils
```

- 패키지와 의존성 다운로드:

```bash
$ sudo repotrack -p /path/to/save {package_name}
```
> `-p`: 다운로드된 패키지들이 저장될 디렉터리를 지정합니다.

---

## 2. 다운로드한 패키지 옮기기

- 모든 패키지가 다운로드된 디렉터리(`/path/to/save`)를 네트워크가 연결되지 않은 서버로 복사합니다.
- `scp`를 활용하여 서버로 복사하는 예시입니다.

```bash
$ sudo scp /path/to/save/*.rpm username@offline-server:/path/to/target
```

---

## 3. 오프라인 서버에서 패키지 설치

- 네트워크가 안 되는 서버에 패키지를 모두 복사한 후, `rpm` 명령어로 패키지들을 설치합니다.

- `/path/to/target`에서 해당 명령어를 실행합니다.

```bash
# 보통의 경우
$ sudo rpm -Uvh *.rpm

# Conflicts 또는 기존 의존성때문에 설치가 안 될 경우
$ sudo rpm -Uvh --force --nodeps *.rpm
```

---

## RPM 사용법 및 옵션(참고)
- Install mode: `rpm -i [다른 옵션] [패키지 파일명]`
- Upgrade mode: `rpm -U [다른 옵션] [패키지 파일명]`

> Upgrade mode: 패키지 파일이 없을 경우 설치를 합니다.

## 옵션

| 옵션           | 기능                                                                                   |
|----------------|----------------------------------------------------------------------------------------|
| `--nodeps`     | 패키지를 설치할 때 의존성 검사를 무시합니다. 이 옵션을 사용하면 패키지가 있더라도 다시 설치할 수 있습니다. |
| `--force`      | 아래 `--replacepkgs`, `--replacefiles`, `--oldpackage`를 모두 사용한 것과 같습니다. |
| `--replacefiles` | 이미 설치된 다른 패키지의 파일이 있어도 강제로 설치합니다.                       |
| `--replacepkgs`  | 이미 패키지가 설치되어 있어도 다시 설치합니다.                                     |
| `--oldpackage` | 새로운 패키지를 지우고 더 예전 패키지로 교체할 때 사용합니다.                          |
| `-h, --hash`   | 패키지를 풀 때 #로 현재 진행 상황을 표시합니다. 보통의 경우 `-v` 옵션과 같이 사용합니다. |
| `--percent`    | 패키지 파일을 풀 때 퍼센트(%) 표시를 합니다. 보통의 경우 다른 도구에서 `rpm`을 호출할때 사용합니다. |
| `--test`       | 패키지를 설치하기 전에 오류가 있는지 점검하고 싶을 때 사용합니다. |

