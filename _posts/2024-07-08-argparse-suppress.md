---
title: '[argparse] SUPPRESS'
date: 2024-07-08 11:25:00 +09:00
categories: [Python, argparse]
tags:
  [
    Python,
    argparse,
    Python Library
  ]
---

# Python의 Command-line argument parsing library
`argparse`는 Python 표준 라이브러리 중 하나로, `CLI` 프로그램에서 실행 인수를 쉽게 사용하기 위한 도구입니다.

또한 **특정 인자를 숨기거나 기본값 출력을 억제하고 싶을 때** `SUPPRESS`를 사용할 수 있습니다.

---

## SUPPRESS 란?

`SUPPRESS`는 `argparse` 모듈에서 제공하는 특별한 값으로, 주로 다음과 같은 두 가지 목적으로 사용됩니다.

1. **도움말 출력에서 인자 숨기기**
    - 인자가 명령 줄 도움말에 표시되지 않도록 합니다.
2. **기본값 출력을 억제하기**
    - 인자가 명령 줄에 제공되지 않았을 때, 해당 인자가 `Namespace` 객체에서 아예 존재하지 않게 합니다.

---

## 예시

1. **도움말 출력에서 인자 숨기기**

   인자를 도움말에서 숨기고 싶을 때 `help=argparse.SUPPRESS`를 사용할 수 있습니다.

    ```python
    # suppress.py
    import argparse

    parser = argparse.ArgumentParser(description="Example with SUPPRESS")
    parser.add_argument("--path", help="Specify the path to the input file")
    parser.add_argument('--hidden', help=argparse.SUPPRESS)
    
    args = parser.parse_args()
    ```
    ```bash
    $ python suppress.py -h
    usage: suppress.py [-h] [--path PATH]
    
    Example with SUPPRESS
    
    options:
      -h, --help   show this help message and exit
      --path PATH  Specify the path to the input file
    ```

   위의 예제에서 `--hidden` 인자는 도움말 메시지에 표시되지 않습니다.

2. **기본값 출력을 억제하기**

   인자가 제공되지 않았을 때 기본값을 `argparse.SUPPRESS`로 설정하면, `Namespace`(`args`) 객체에 포함되지 않습니다.

   ```python
    # suppress.py
    import argparse

    parser = argparse.ArgumentParser(description="Example with SUPPRESS")
    parser.add_argument("--path", help="Specify the path to the input file")
    parser.add_argument('--optional', default=argparse.SUPPRESS)

    args = parser.parse_args()
    print(args)
   ```

   ```bash
   $ python suppress.py
    Namespace(path=None)

   $ python suppress.py --optional test
    Namespace(path=None, optional='test')
   ```
   

   위의 예제에서 `--optional` 인자가 제공되지 않으면, `args` 객체에 `optional` 속성이 존재하지 않습니다.

---

## 요약


- `argparse.SUPPRESS`는 특정 인자를 도움말 출력에서 숨기거나, 기본값 출력을 억제할 때 사용됩니다.
- 도움말에서 숨기려면 `help=argparse.SUPPRESS`를 사용합니다.
- 기본값 출력을 억제하려면 `default=argparse.SUPPRESS`를 사용합니다.

이 기능을 통해 `argparse`를 이용한 명령 줄 인터페이스에서 유연하게 인자를 관리할 수 있습니다.