`Python`에서 **상대 경로로 import하거나 파일을 불러올 때** 작업 경로(현재 작업 디렉터리, `cwd: current working directory`)의 영향을 받는 부분과 그렇지 않은 부분에 대해 명확히 설명하겠습니다.

---

### 🔍 **1. import (모듈 및 패키지)**
#### 📌 **작업 경로의 영향** 
- `import`는 **현재 스크립트 파일의 경로**를 기준으로 하며, **현재 작업 디렉터리 (`os.getcwd()`)의 영향을 받지 않습니다.**
- 그러나, **파이썬 인터프리터를 실행하는 위치에 따라** `sys.path`에 추가되는 경로가 달라질 수 있습니다.
- `sys.path`의 첫 번째 경로는 현재 실행 중인 **스크립트의 디렉터리**이며, 이를 기준으로 상대 경로 import가 가능합니다.

#### 📘 **예시 1: 파이썬 파일로 실행 (정상 작동)**
```
project/
  ├── main.py      # 실행 파일
  └── utils/
      └── helper.py
```
**main.py**
```python
from utils.helper import some_function
```
- `python main.py`를 실행하면, `sys.path`에 `project/`가 포함되어 `utils.helper`를 정상적으로 찾을 수 있습니다.

#### 📘 **예시 2: REPL 또는 `python` 명령으로 직접 실행 (경로 문제 발생 가능)**
```
$ python
>>> from utils.helper import some_function  # ModuleNotFoundError 발생
```
- **왜 발생할까?**  
  `REPL`에서 실행하면 `sys.path`의 첫 번째 경로는 현재 작업 디렉터리 (`os.getcwd()`)이므로 `utils`를 찾을 수 없습니다. 
  - 해결 방법:
    ```python
    import sys
    sys.path.append('/path/to/project')
    from utils.helper import some_function
    ```

#### 🛠️ **정리**
| **실행 환경**          | **sys.path에 추가된 경로**                  | **작업 경로의 영향** |
|-----------------|-----------------------------------|---------------------|
| 스크립트로 실행 (python main.py) | main.py의 디렉터리가 추가됨              | ❌ 영향 없음 (스크립트 기준) |
| REPL / python 명령어  | 현재 작업 디렉터리가 추가됨 (`os.getcwd()`)  | ✅ 작업 경로의 영향을 받음  |

---

### 🔍 **2. 파일 불러오기 (open, with open)**
#### 📌 **작업 경로의 영향**
- `open('파일경로')` 또는 `with open('파일경로')`에서 **상대 경로로 파일을 지정할 때는 작업 경로 (os.getcwd())**에 절대적으로 영향을 받습니다.
- **현재 작업 디렉터리**는 **스크립트의 경로가 아니라 파이썬을 실행한 위치**가 기준입니다.

#### 📘 **예시 1: 스크립트로 실행 (파일을 찾지 못할 수 있음)**
```
project/
  ├── main.py       # 실행 파일
  └── data/
      └── file.txt
```
**main.py**
```python
with open('data/file.txt', 'r') as f:  # 상대 경로로 접근
    print(f.read())
```
- `python main.py` 명령어로 실행하면, `os.getcwd()`는 main.py가 있는 디렉터리이기 때문에 `data/file.txt`가 잘 열립니다.

#### 📘 **예시 2: REPL 또는 `python` 명령어 (파일 경로 오류 발생 가능)**
```
$ python
>>> with open('data/file.txt', 'r') as f:  # FileNotFoundError 발생
```
- **왜 발생할까?**  
  - 이 경우 `os.getcwd()`는 **파이썬 명령어를 실행한 디렉터리**이기 때문에 `data/file.txt`를 찾을 수 없습니다.
  - 해결 방법:
    ```python
    import os
    os.chdir('/path/to/project')  # 작업 디렉터리를 명시적으로 변경
    with open('data/file.txt', 'r') as f:
        print(f.read())
    ```

#### 📘 **예시 3: 스크립트 내부에서 경로 명확히 지정 (권장 방식)**
```python
import os

base_dir = os.path.dirname(__file__)  # 현재 파일의 디렉터리 경로
file_path = os.path.join(base_dir, 'data/file.txt')

with open(file_path, 'r') as f:
    print(f.read())
```
- `os.path.dirname(__file__)`는 스크립트 파일이 있는 디렉터리 경로를 반환합니다.
- **작업 디렉터리와 무관하게 파일을 항상 정확한 경로로 참조**할 수 있는 안전한 방법입니다.

#### 🛠️ **정리**
| **실행 환경**        | **파일 경로 기준**         | **작업 경로의 영향** |
|-----------------|---------------------|----------------------|
| 스크립트로 실행 (python main.py) | os.getcwd() (스크립트 실행 위치) | ✅ 영향을 받음      |
| REPL / python 명령어  | os.getcwd() (현재 쉘 위치)  | ✅ 영향을 받음      |
| `__file__` 사용  | 파일이 있는 경로          | ❌ 영향 없음        |

---

### 📝 **중요한 차이 요약**
| **구분**           | **스크립트 기준**        | **작업 디렉터리 (os.getcwd()) 기준** | 
|-----------------|-----------------|--------------------------------|
| **import**       | ✅ 기준 경로는 **스크립트 경로** | ❌ 작업 디렉터리의 영향을 받지 않음 |
| **파일 불러오기**  | ❌ 스크립트 기준이 아님      | ✅ 작업 디렉터리 (`os.getcwd()`) 기준 |

---

### 💡 **결론 및 팁**
1. **import (모듈 및 패키지)**
   - 파이썬 인터프리터의 실행 위치에 따라 `sys.path`가 달라지므로, 경로 문제로 `ModuleNotFoundError`가 발생할 수 있습니다.
   - 스크립트가 `project/main.py`에 있는 경우, 스크립트의 경로가 `sys.path`에 포함되므로 문제없지만, **REPL에서 import할 때는 cwd의 영향을 받습니다.**
   - 해결 방법:
     ```python
     import sys
     sys.path.append('/path/to/project')
     ```

2. **파일 불러오기 (open)**
   - **상대 경로로 파일을 열 때는 작업 디렉터리 (`os.getcwd()`)의 영향을 받습니다.**
   - `python` 명령으로 REPL을 실행할 때 작업 디렉터리는 **현재 쉘의 디렉터리**가 됩니다.
   - 파일 경로를 명확히 하려면 다음을 사용합니다:
     ```python
     import os
     base_dir = os.path.dirname(__file__)  # 현재 파일의 디렉터리
     file_path = os.path.join(base_dir, 'data/file.txt')
     with open(file_path, 'r') as f:
         print(f.read())
     ```

---

### 🛠️ **추천하는 코드 패턴**
```python
import os

# import 관련 - 항상 절대 경로로 sys.path 추가 (REPL 및 pytest에서 유용)
import sys
sys.path.append(os.path.dirname(__file__))

# 파일 불러오기 관련 - 항상 절대 경로로 파일 불러오기
base_dir = os.path.dirname(__file__)  # 현재 파일의 디렉터리
file_path = os.path.join(base_dir, 'data/file.txt')

with open(file_path, 'r') as f:
    print(f.read())
```

---

이제 `import`와 파일 불러오기가 작업 경로에 어떤 영향을 받는지 확실히 이해하셨을 겁니다.  
**스크립트 경로**와 **작업 디렉터리 (os.getcwd())**가 다르게 작동한다는 점을 기억하세요.  
필요에 따라 `os.path.dirname(__file__)`을 사용하여 안정적인 코드 경로를 유지하는 것이 좋습니다.

궁금한 부분이나 추가로 설명이 필요한 부분이 있으면 알려주세요! 😊


---
---
---

`pyinstaller`로 빌드할 때, **`os.path.dirname(__file__)`**을 사용하는 경우 **정상 작동하지 않을 수 있습니다**.  
이유는 PyInstaller가 **모든 파일을 하나의 실행 파일 (EXE)로 패키징**하기 때문에, 파일 경로가 더 이상 기존의 파일 시스템 경로와 같지 않기 때문입니다.

---

## 🔍 **왜 작동하지 않는가?**
1. **단일 실행 파일** (`--onefile` 옵션)로 빌드할 때, PyInstaller는 파일을 **임시 디렉터리 (Temp Directory)**에 압축 해제한 후 메모리에서 실행합니다.
2. `__file__`의 값은 빌드된 실행 파일의 **임시 경로**가 되므로, 소스 코드에 있었던 원래의 경로가 아닙니다.

---

## 🔍 **해결 방법**
### ✅ **1. `sys._MEIPASS`를 사용하기**
PyInstaller는 빌드된 실행 파일이 임시 디렉터리에서 실행될 때, 임시 디렉터리의 경로를 **`sys._MEIPASS`**에 저장합니다.  
이를 활용하면, 빌드된 파일에서도 파일 참조 경로를 올바르게 가져올 수 있습니다.

```python
import sys
import os

# PyInstaller 빌드 환경을 고려한 파일 경로 설정
base_path = getattr(sys, '_MEIPASS', os.path.dirname(os.path.abspath(__file__)))

# 예를 들어, resources 폴더에 있는 data.txt 파일을 참조
file_path = os.path.join(base_path, 'resources', 'data.txt')

print(f"File path: {file_path}")
```

> 🔍 **동작 방식**
- `sys._MEIPASS`: PyInstaller가 **임시 디렉터리**에 압축 해제한 경로.
- `os.path.dirname(__file__)`: 개발 환경(스크립트 실행)에서의 경로.
- `getattr(sys, '_MEIPASS', os.path.dirname(__file__))`: 빌드 환경에서는 **`sys._MEIPASS`**를 사용하고, 개발 환경에서는 **`__file__`**을 사용.

---

### ✅ **2. PyInstaller에 파일 추가하기**
PyInstaller로 빌드할 때 **외부 파일을 포함**시켜야 하는 경우, `--add-data` 옵션을 사용합니다.

```bash
pyinstaller --onefile --add-data "resources/data.txt:resources" myscript.py
```

> 🔍 **동작 방식**
- `--add-data "소스 파일:대상 경로"`  
- 예) `resources/data.txt`를 빌드에 포함시켜, 빌드된 실행 파일의 `resources/data.txt`에 위치시킵니다.

---

## 📘 **정리**
| **환경**        | **os.path.dirname(__file__)** 사용 가능? | **해결책** |
|-----------------|------------------------------------------|------------|
| **로컬 실행**    | ✅ **가능** (정상 작동)                  | `__file__` 사용 가능 |
| **PyInstaller**  | ❌ **불가능** (임시 디렉터리에서 실행)    | `sys._MEIPASS` 사용 |

---

## 🧑‍💻 **최종 코드 예시**
다양한 환경에서 작동할 수 있는 코드를 작성하는 경우 다음과 같이 작성하면 됩니다.

```python
import os
import sys

# base_path 설정 (빌드 환경과 개발 환경 모두 호환)
base_path = getattr(sys, '_MEIPASS', os.path.dirname(os.path.abspath(__file__)))

# 데이터 파일 경로 생성
data_file_path = os.path.join(base_path, 'resources', 'data.txt')

# 파일 읽기 예시
with open(data_file_path, 'r', encoding='utf-8') as f:
    data = f.read()

print(f"File Content: {data}")
```

---

## 📌 **결론**
- **개발 환경**: `os.path.dirname(__file__)` 사용 가능.  
- **PyInstaller 빌드 환경**: `sys._MEIPASS`로 임시 디렉터리 경로를 가져와야 함.  
- 외부 파일을 실행 파일에 포함하려면, **`--add-data` 옵션**을 사용해야 함.  

이 방법을 사용하면, 개발 환경과 빌드 환경 모두에서 동일한 코드로 파일을 참조할 수 있습니다.  
궁금한 사항이 있으면 알려주세요! 😊