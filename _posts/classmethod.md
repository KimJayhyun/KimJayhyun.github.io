`@classmethod`는 Python에서 클래스 메서드를 정의할 때 사용하는 데코레이터입니다. 클래스 메서드는 인스턴스가 아닌 클래스 자체를 첫 번째 인자로 받습니다. 이를 통해 클래스 메서드는 인스턴스 메서드와 달리 클래스 상태나 클래스 변수를 조작할 수 있습니다.

### 기본 사용법
```python
class MyClass:
    class_variable = 'Hello, world!'
    
    @classmethod
    def class_method(cls):
        return cls.class_variable

# 클래스 메서드를 호출할 때는 인스턴스를 만들 필요 없이 클래스 자체를 통해 호출할 수 있습니다.
print(MyClass.class_method())  # 출력: Hello, world!
```

### 주요 특징
1. **첫 번째 인자**: 클래스 메서드는 첫 번째 인자로 `cls`(보통 이렇게 이름을 짓습니다)를 받습니다. `cls`는 해당 메서드가 속한 클래스를 가리킵니다.
2. **클래스 변수 접근**: 클래스 메서드는 인스턴스가 아니라 클래스를 통해 호출되기 때문에 클래스 변수를 쉽게 접근하고 수정할 수 있습니다.
3. **클래스 상태 변경**: 인스턴스가 아니라 클래스 전체의 상태를 변경할 때 유용합니다.

### 예제
클래스 메서드를 사용하여 클래스 변수를 조작하는 예제를 보겠습니다.

```python
class Counter:
    count = 0
    
    @classmethod
    def increment(cls):
        cls.count += 1
        
    @classmethod
    def get_count(cls):
        return cls.count

# 클래스 메서드 호출
Counter.increment()
Counter.increment()

print(Counter.get_count())  # 출력: 2
```

### 인스턴스 메서드와의 차이점
- **인스턴스 메서드**: 첫 번째 인자로 `self`를 받으며, 이는 인스턴스를 가리킵니다. 주로 인스턴스 변수에 접근하고 이를 변경하는 데 사용됩니다.
- **클래스 메서드**: 첫 번째 인자로 `cls`를 받으며, 이는 클래스를 가리킵니다. 주로 클래스 변수에 접근하고 이를 변경하는 데 사용됩니다.

### 정적 메서드와의 차이점
`@staticmethod` 데코레이터는 클래스나 인스턴스에 대한 참조 없이 함수를 정의하는 데 사용됩니다. 이는 일반 함수와 같지만 클래스 내에 정의되어 해당 클래스의 네임스페이스에 속합니다.

```python
class MyClass:
    @staticmethod
    def static_method():
        return "I'm a static method"
    
    @classmethod
    def class_method(cls):
        return "I'm a class method"

print(MyClass.static_method())  # 출력: I'm a static method
print(MyClass.class_method())   # 출력: I'm a class method
```

### 요약
- `@classmethod`는 클래스 변수를 조작하거나 클래스 상태를 변경할 때 사용됩니다.
- 첫 번째 인자로 클래스를 받기 때문에 클래스 자체를 통해 호출할 수 있습니다.
- 인스턴스 메서드와는 달리 클래스와 관련된 작업에 유용합니다.