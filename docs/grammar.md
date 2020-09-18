# 누리 문법

누리 0.1.0 버전을 기준으로 언어의 문법에 대한 설명을 기재한 문서입니다.

## 기본 요소

### 정수

2, 8, 10, 16진수를 리터럴을 지원합니다.

- 2진수 (`0b1101`)
- 8진수 (`0123`)
- 10진수 (`123`)
- 16진수 (`0xABCD`)

### 실수

정수부는 10진수만 지원합니다.

- `10.123`, `0.1`

### 문자

작은 따옴표로 감쌉니다. 유니코드를 지원합니다. 이스케이프 시퀀스를 지원합니다.

- `'a'`, `'\n'`, `'가'`

### 부울

- `참`, `거짓`

### 없음 (null, None 등에 해당)

- `없음`

## 목록

목록은 `{}` 로 감싸며, 원소들 사이에 `,` 를 넣어서 구분합니다.

- `{1, 2, 3, 4, 5}`, `{3.14, 'a'}`, `{}`

목록은 연결 리스트로 구현되고 구조체입니다. `첫번째`, `나머지` 라는 필드를 가지고 있습니다.

`첫번째` 는 첫번째 원소를 가지고 있으며, `나머지` 는 첫번째 원소를 제외한 나머지 목록을 가지고 있습니다. 비어있는 목록은 `없음` 으로 표현됩니다.

## 문자열

문자열은 큰 따옴표로 감쌉니다. 유니코드를 지원합니다. 이스케이프 시퀀스를 지원합니다.

- `"Hello, world!"`, `"안녕하세요.\n"`

문자열은 문자의 목록과 일치합니다.

- `"hello\\n" == {'h', 'e', 'l', 'l', 'o', '\\n'}`

## 상수 접근

상수에 접근할 때는 상수의 이름에 대괄호를 감쌉니다. 

- `[ㄱ]`, `[사과]`, `[상자-1개]`

## 연산자

연산은 다음과 같은 우선 순위로 처리됩니다.

1. `-` (단항 음수 부호), `+` (단항 양수 부호), `!` (단항 논리 부정)
2. `*` (곱하기), `/` (나누기), `%` (나머지)
3. `+` (더하기), `-` (빼기)
4. `==` (일치), `!=` (불일치)
5. `<=` (이하), `>=` (이상), `<` (미만), `>` (초과)
6. `그리고`, `또는`

## 함수 호출

### 일반적 함수 호출

각 인수뒤에 공백없이 조사를 붙이고, 함수 이름을 붙여서 호출합니다. 조사는 생략할 수 없습니다.

- `1과 2를 더하다`

조사와 인수의 결합은 모든 사칙 연산보다 우선 순위가 낮습니다.

- `1+1과 2를 더하다 == 1+(1과 2를 더하다)`

### 함수의 연쇄 호출

동사로 선언된 함수(아직 언어 차원에서 품사를 구별하여 활용 가능성을 결정하지는 않습니다)는 `~(하)고` 의 형식으로 함수끼리 연쇄적으로 호출할 수 있습니다.

- `1과 2를 더하고 출력하다 == (1과 2를 더하다)를 출력하다`

함수 호출의 연쇄 시 뒤에 오는 함수의 인수 조사를 지정할 수 없습니다. 가장 앞에 있는 인자에 배정됩니다.

동사의 활용 변환은 `~고` 를 그대로 `~다` 로 바꾸는 방식으로 진행됩니다.

- 더하고 → 더하다
- 던지고 → 던지다
- 기고 → 기다

2개 이상의 함수 연쇄 또한 가능합니다.

### C-style 함수 호출

C, Python 등의 방식으로도 함수를 호출할 수 있습니다.

- `더하다(1, 2)`

함수의 이름과 괄호 사이에 공백이 있으면 안됩니다.

이 방식으로 함수를 호출할 경우 조사를 지정할 수 없습니다. 가장 앞에 있는 인자부터 배정됩니다.

## 조건식

`만약`, `이라면`, `아니라면` 예약어를 사용하여 조건식을 구성합니다.

- `만약 1과 2가 같다 이라면 3 아니라면 4`

## 순서대로 표현식

`순서대로` 키워드를 사용하여 여러 개의 표현식을 순서대로 실행합니다. (시퀀스)

```python
순서대로
  1을 출력하다
  2를 출력하다

  3를 출력하다
```

`순서대로` 키워드 뒤에는 표현식이 바로 나올 수 없고, 줄바꿈이 있어야합니다. `순서대로` 키워드 다음에 처음으로 나오는 표현식의 들여쓰기가 기준이 되고, 그 들여쓰기와 일치하는 표현식들을 모두 시퀀스의 일부로 포함시킵니다.

`순서대로` 표현식 안에는 상수 또는 함수를 선언할 수 있습니다. 해당 상수, 함수는 `순서대로` 표현식이 종료되면 사용할 수 없습니다.

```python
순서대로
  상수 [ㄱ]: 입력받고 정수화하다
  함수 [수1]과 [수2]를 더하다: [수1] + [수2]
  [ㄱ]과 10을 더하고 출력하다
```

`순서대로` 표현식은 다른 표현식의 일부로 사용될 수 있습니다.

```python
만약 1과 2가 같다
  이라면 순서대로
    "이런"을 보여주다
    "말도 안돼!"를 보여주다
  아니라면 "정상"을 보여주다
```

상호 재귀 함수(mutually recursive function)의 사용을 위해서, `순서대로` 표현식 안에서 함수의 실질적인 정의를 남겨두고 이름의 선언만 할 수 있습니다. 이때는 인자를 명시하지 않아도 됩니다.

```python
순서대로
  형용사 짝수이다 # 이 부분이 없으면 오류가 발생합니다. (전역 함수는 필요없음)

  형용사 [수]가 홀수이다:
    만약 [수] == 1 이라면 참
    아니라면 ([수]-1)이 짝수이다

  형용사 [수]가 짝수이다:
    만약 [수] == 0 이라면 참
    아니라면 ([수]-1)이 홀수이다
```

## 선언

### 상수 선언

상수는 다음과 같은 형식으로 선언합니다.

```python
상수 [상수_이름]: 표현식
```

상수의 이름에는 한글 자모, 한글 음절, 로마자, 숫자, 공백만 허용됩니다. 상수의 이름은 공백 혹은 숫자로 시작할 수 없습니다.

### 함수 선언

함수, 동사, 형용사는 각각 다음과 같이 선언합니다. 

```python
함수 [ㄱ]과 [ㄴ]의 합: [ㄱ] + [ㄴ]
동사 [ㄱ]을 [ㄴ]과 더하다: [ㄱ] + [ㄴ]
형용사 [ㄱ]이 [ㄴ]보다 크다: [ㄱ] > [ㄴ]
```

- 함수의 이름에는 한글 음절, 로마자, 띄어쓰기만 허용됩니다.
- 마지막 어절이 아닌 어절은 '고'로 끝날 수 없습니다. (동사 활용과의 모호성)
- 조사에는 공백없는 한글 1 어절만 허용됩니다.

다음 조사쌍들은 같은 것으로 간주됩니다.

- 와 = 과
- 으로 = 로
- 을 = 를
- 은 = 는
- 이 = 가

동사와 형용사는 함수의 이름이 '다'로 끝나야합니다. 함수가 여러 개의 표현식을 실행해야 하는 경우 `순서대로` 표현식을 활용하세요.

### 구조체 선언

구조체는 다음과 같은 형식으로 선언합니다.

```python
구조체 구조체_이름: 첫번째_필드, 두번째_필드, ...
```

- 구조체의 이름에는 한글 음절, 로마자만 허용됩니다.
- 필드의 이름 규칙은 함수의 이름 규칙과 동일합니다.

```python
구조체 사각형: 가로, 세로
```

위와 같이 선언하면, 구조체 값은 다음과 같이 생성합니다.

```python
상수 [나의_사각형]: 사각형(가로: 10, 세로: 20)
```

구조체 생성자에서 필드에 값을 넣는 순서는 필드를 선언한 순서와 일치하지 않아도 되지만, 모든 필드에 값을 넣어야합니다.

구조체를 선언하면, 필드의 이름과 일치하는 필드 가져오기 함수가 각 필드마다 선언됩니다.

```python
[나의_사각형]의 가로
[나의_사각형]의 세로
```

위와 같이 구조체의 필드에 접근할 수 있습니다.

## 꾸러미 (모듈)

꾸러미를 통해서 다른 파일에 있는 누리 코드를 포함시킬 수 있습니다.

```
꾸러미 "표준 라이브러리.nuri"

"안녕하세요"를 보여주다
```

경로는 해당 코드 파일을 기준으로한 상대 경로로 설정됩니다. 상호 포함 파일은 아직 지원하지 않습니다.

## 주석

줄 단위 주석은 `# ...` 으로, 블럭 단위 주석은 `(* ... *)` 으로 사용할 수 있습니다.

```python
1과 2를 더하다 # 안녕, 세상!
```

```ocaml
1과 (* 세상에서 제일 멋진 *) 2를 더하다
```