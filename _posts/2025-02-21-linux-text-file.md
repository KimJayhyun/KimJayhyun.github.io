---
title: '[Linux] Redirection과 cat & tee을 활용한 Text File 생성법'
date: 2025-02-20 13:00:00 +09:00
categories: [Linux, Linux Command]
tags:
  [
    Linux,
    Linux Command,
    Redhat,
    Rocky,
    Centos
  ]
---

# Linux Text File 생성 방법

Linux Text File을 생성할 때 보통 `vim` 에디터를 사용하거나 

`echo "hello world" > text.txt`와 같이 `Redirection`을 간단하게 활용했다.

여러 `Linux` 환경의 솔루션을 설치할 때 `tee` 명령어을 사용하거나

`kubernetes`의 `Resource manifest yaml` 생성 시, `EOF`를 활용하는 경우가 많아

아래와 같이 Text File 생성 방법을 정리해보았다.

---

## Redirection

리다이렉션(`Redirection`)은 Linux에서 명령어의 표준 입력(stdin), 표준 출력(stdout), 표준 에러(stderr)을 

다른 파일이나 명령어로 보내는 기능을 말한다.

표준 입력, 표준 출력 그리고 표준 에러는 기본적으로 아래와 같다.

- **표준 입력(stdin, 0)** → 키보드에서 입력
- **표준 출력(stdout, 1)** → 터미널 화면으로 출력 
- **표준 오류(stderr, 2)** → 터미널 화면으로 출력

즉, `Redirection`을 사용하면 출력을 파일에 저장하거나, 다른 명령어의 입력으로 전달할 수 있다.

---

### 1. 출력 Redirection(`>`, `>>`)을 활용한 Text File 생성

Redirection을 활용하면 표준 출력(`stdout`)을 파일에 저장할 수 있다.

출력 Redirection 명령어는 아래 두 가지이다.

---

#### `>` : 출력 내용을 새 파일로 저장(덮어쓰기)

```bash
# `echo`를 활용한 파일 생성 
$> echo "Hello, Linux"
Hello, Linux

$> echo "Hello, Linux" > file.txt

$> cat file.txt
Hello, Linux

# `echo` 명령어는 여러 줄 작성이 안 됨
$> echo "Hello, Linux\nI am Kimjayhyun" > file.txt

$> cat file.txt
Hello, Linux\nI am Kimjayhyun

# 권장
$> printf "Hello, Linux\nI am Kimjayhyun" > file.txt

$> cat file.txt
Hello, Linux
I am Kimjayhyun

# `-e` 옵션 사용
$> echo -e "Hello, Linux\nI am Kimjayhyun" > file.txt

$> cat file.txt
Hello, Linux
I am Kimjayhyun
```

`file.txt`가 존재하면 **덮어쓰기**하고, 없으면 새로 생성한다.

덮어쓰기이므로 기존 내용이 삭제되어 주의가 필요하다.

#### `>>` : 출력 내용을 기존 파일에 추가

```bash
echo "추가된 내용" >> file.txt
```

만약 `file.txt`가 없다면 생성하고 내용을 작성한다.

기존 `file.txt`의 내용을 유지하면서 새 내용을 추가할 수 있다.

---

### `cat` & 출력 Redirection

`cat` 명령어를 활용하면 터미널에서 텍스트 파일을 간편하게 작성할 수 있다.

```bash
$> cat > file.txt
Hello, World!
This is a new file.
Ctrl + D  # 입력 종료 (EOF: End Of File)

$> cat file.txt
Hello, World!
This is a new file.

$> cat >> file.txt
And this is a new line
Ctrl + D # 입력 종료 (EOF)

$> cat file.txt
Hello, World!
This is a new file.
And this is a new line
```

---

### 2. 입력 Redirection(`<<`, `<<<`)

입력 Redirection을 활용하면 텍스트를 명령어의 `stdin`으로 전달할 수 있다.

아래는 입력 Redirection의 종류이다.

- `<`: **파일의 내용**을 명령어에 입력으로 제공한다.
- `<< (here-document)`: **여러 줄의 텍스트**를 직접 명령어의 입력으로 전달한다.
- `<<< (here-string)`: **단일 문자열**을 명령어에 입력으로 전달한다.

이를 활용하여 Text File을 생성할 수 있다.

#### `<< (here-document)`: 멀티라인 입력하여 파일 생성
```bash
$> cat << EOF
> Hello Linux
> I am Kimjayhyun
> EOF

Hello Linux
I am Kimjayhyun
```

`EOF` 전까지 입력을 받아 `cat`에 전달하여 `stdout`에 출력이 된다.

이 때, `EOF`라는 문자열 대신 다른 문자열도 사용가능하다.

```bash
$> cat << TEST
> Hello Linux
> I am Kimjayhyun
> TEST

Hello Linux
I am Kimjayhyun
```

출력 Redirection을 활용하면 `Ctrl + D`를 입력하지 않아도 Text File을 생성할 수 있다.

```bash
$> cat << EOF > file.txt
> Hello Linux
> I am Kimjayhyun
> EOF

$> cat file.txt
Hello Linux
I am Kimjayhyun

# 순서를 바꾸어도 됨
$> cat >> file.txt << EOF 
> New Line
> EOF

$> cat file.txt
Hello Linux
I am Kimjayhyun
New Line
```

--- 

## `tee`

`tee` 명령어는 파이프라인을 활용하여 표준 입력으로 전달된 데이터를 

표준 출력과 하나 이상의 파일에 동시에 기록하는 데 사용된다. 

즉 명령어의 중간 결과를 파일에 저장하면서도 

파이프라인을 통해 다음 명령어로 데이터를 전달할 수 있다.

### 사용 예시

파이프라인 명령어인 `|`를 활용하여 `tee` 명령어를 사용하면 된다.

```bash
# 파이프라인의 중간 결과를 저장할 수 있음
$> ls -l | tee file.txt | grep file
-rw-r--r--. 1 jhkim jhkim  0  2월 23 17:12 file.txt

$> cat file.txt
합계 0
drwxr-xr-x. 3 jhkim jhkim 31  1월 26 15:08 code
drwxr-xr-x. 4 jhkim jhkim 62  2월 21 10:47 docker
-rw-r--r--. 1 jhkim jhkim  0  2월 23 17:12 file.txt
drwxr-xr-x. 4 jhkim jhkim 53  2월 15 12:14 kubernetes
drwxr-xr-x. 3 jhkim jhkim 60  2월 23 02:54 solutions

# `a` : 파일에 내용 추가
$> cat << EOF | tee -a file.txt
> This is a new line
> EOF
This is a new line

$> cat file.txt
합계 0
drwxr-xr-x. 3 jhkim jhkim 31  1월 26 15:08 code
drwxr-xr-x. 4 jhkim jhkim 62  2월 21 10:47 docker
-rw-r--r--. 1 jhkim jhkim  0  2월 23 17:09 file.txt
drwxr-xr-x. 4 jhkim jhkim 53  2월 15 12:14 kubernetes
drwxr-xr-x. 3 jhkim jhkim 60  2월 23 02:54 solutions
This is a new line
```

위와 같이 내가 Text File에 입력한 Text를 확인할 수 있으면서,

명령어의 중간 결과를 파일에 저장할 수 있다.

---

## 마치며...

결국 Linux Shell을 잘 사용하기 위해서는 `Redirection`과 `Pipe Line`이 핵심인 것 같다.

`Redirection`과 `Pipe Line`을 `tee`, `cat`이라는 도구를 활용해서

Text File을 생성하는 방법에 대해 정리해보았다.