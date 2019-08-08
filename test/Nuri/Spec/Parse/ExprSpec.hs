module Nuri.Spec.Parse.ExprSpec where

import           Test.Hspec
import           Test.Hspec.Megaparsec

import           Nuri.Parse.Expr
import           Nuri.Expr

import           Nuri.Spec.Util
import           Nuri.Spec.Parse.Util

spec :: Spec
spec = do
  describe "정수 파싱" $ do
    describe "2진수 파싱" $ do
      it "0b1010을 10으로 파싱" $ do
        testParse parseIntegerExpr "0b1010" `shouldParse` litInteger 10
      it "0B1010을 10으로 파싱" $ do
        testParse parseIntegerExpr "0B1010" `shouldParse` litInteger 10
      it "0b0000을 0으로 파싱" $ do
        testParse parseIntegerExpr "0b0000" `shouldParse` litInteger 0

    describe "8진수 파싱" $ do
      it "012을 10으로 파싱" $ do
        testParse parseIntegerExpr "012" `shouldParse` litInteger 10
      it "000을 0으로 파싱" $ do
        testParse parseIntegerExpr "000" `shouldParse` litInteger 0

    describe "10진수 파싱" $ do
      it "10을 10으로 파싱" $ do
        testParse parseIntegerExpr "10" `shouldParse` litInteger 10
      it "0을 0으로 파싱" $ do
        testParse parseIntegerExpr "0" `shouldParse` litInteger 0

    describe "16진수 파싱" $ do
      it "0x000A를 10으로 파싱" $ do
        testParse parseIntegerExpr "0x000A" `shouldParse` litInteger 10
      it "0x0010을 16으로 파싱" $ do
        testParse parseIntegerExpr "0x0010" `shouldParse` litInteger 16
      it "0xffFF를 65535으로 파싱" $ do
        testParse parseIntegerExpr "0xffFF" `shouldParse` litInteger 65535
      it "0XffFF를 65535으로 파싱" $ do
        testParse parseIntegerExpr "0XffFF" `shouldParse` litInteger 65535
      it "0x0000을 0으로 파싱" $ do
        testParse parseIntegerExpr "0x0000" `shouldParse` litInteger 0

  describe "실수 파싱" $ do
    it "0.1을 0.1로 파싱" $ do
      testParse parseReal "0.1" `shouldParse` 0.1
    it "0.01을 0.01로 파싱" $ do
      testParse parseReal "0.01" `shouldParse` 0.01
    it "10.0을 10.0으로 파싱" $ do
      testParse parseReal "10.0" `shouldParse` 10.0
    it "0을 0.0으로 파싱" $ do
      testParse parseReal "0.0" `shouldParse` 0.0

  describe "문자 파싱" $ do
    it "'a'를 'a'로 파싱" $ do
      testParse parseChar "'a'" `shouldParse` 'a'
    it "'가'를 '가'로 파싱" $ do
      testParse parseChar "'가'" `shouldParse` '가'
    it "'\\''를 '\\''로 파싱" $ do
      testParse parseChar "'\\''" `shouldParse` '\''
    it "'\\n를 '\\n로 파싱" $ do
      testParse parseChar "'\\n'" `shouldParse` '\n'
    it "'''에 대해서 오류" $ do
      testParse parseChar `shouldFailOn` "'''"
    it "'ab'에 대해서 오류" $ do
      testParse parseChar `shouldFailOn` "'ab'"

  describe "부울 파싱" $ do
    it "참을 True로 파싱" $ do
      testParse parseBool "참" `shouldParse` True
    it "거짓을 False로 파싱" $ do
      testParse parseBool "거짓" `shouldParse` False

  describe "사칙연산식 파싱" $ do
    describe "단항 연산자" $ do
      it "양의 부호 정수" $ do
        testParse parseArithmetic "+2" `shouldParse` unaryOp Plus (litInteger 2)
      it "(떨어져 있는) 양의 부호 정수" $ do
        testParse parseArithmetic "+ 2"
          `shouldParse` unaryOp Plus (litInteger 2)
      it "음의 부호 정수" $ do
        testParse parseArithmetic "-2"
          `shouldParse` unaryOp Minus (litInteger 2)
      it "(떨어져 있는) 음의 부호 정수" $ do
        testParse parseArithmetic "- 2"
          `shouldParse` unaryOp Minus (litInteger 2)
      it "양의 부호 실수" $ do
        testParse parseArithmetic "+2.5"
          `shouldParse` unaryOp Plus (litReal 2.5)
      it "음의 부호 실수" $ do
        testParse parseArithmetic "-2.5"
          `shouldParse` unaryOp Minus (litReal 2.5)
    describe "이항 연산자" $ do
      it "두 정수 더하기" $ do
        testParse parseArithmetic "1 + 2"
          `shouldParse` binaryOp Plus (litInteger 1) (litInteger 2)
      it "두 실수 더하기" $ do
        testParse parseArithmetic "1.0 + 2.5"
          `shouldParse` binaryOp Plus (litReal 1.0) (litReal 2.5)
      it "실수와 정수 더하기" $ do
        testParse parseArithmetic "1.0 + 2"
          `shouldParse` binaryOp Plus (litReal 1.0) (litInteger 2)
      it "(붙어있는) 두 정수 더하기" $ do
        testParse parseArithmetic "1+2"
          `shouldParse` binaryOp Plus (litInteger 1) (litInteger 2)
      it "(부호있는) 두 정수 더하기" $ do
        testParse parseArithmetic "1++2"
          `shouldParse` binaryOp
                          Plus
                          (litInteger 1)
                          (unaryOp Plus (litInteger 2))
      it "두 정수 빼기" $ do
        testParse parseArithmetic "2 - 4"
          `shouldParse` binaryOp Minus (litInteger 2) (litInteger 4)
      it "두 정수 곱하기" $ do
        testParse parseArithmetic "2 * 4"
          `shouldParse` binaryOp Asterisk (litInteger 2) (litInteger 4)
      it "두 정수 나누기" $ do
        testParse parseArithmetic "8 / 2"
          `shouldParse` binaryOp Slash (litInteger 8) (litInteger 2)
      it "두 정수 동등 비교" $ do
        testParse parseArithmetic "8 = 2"
          `shouldParse` binaryOp Equal (litInteger 8) (litInteger 2)
      it "두 정수 부등 비교" $ do
        testParse parseArithmetic "8 != 2"
          `shouldParse` binaryOp Inequal (litInteger 8) (litInteger 2)
    describe "복합 연산" $ do
      it "두 정수 나누고 한 정수 더하기" $ do
        testParse parseArithmetic "4 / 2 + 3" `shouldParse` binaryOp
          Plus
          (binaryOp Slash (litInteger 4) (litInteger 2))
          (litInteger 3)
      it "두 정수 나누고 한 정수 더하기 (순서 바꿔서)" $ do
        testParse parseArithmetic "3 + 4 / 2" `shouldParse` binaryOp
          Plus
          (litInteger 3)
          (binaryOp Slash (litInteger 4) (litInteger 2))

  describe "식별자 파싱" $ do
    it "영문 식별자" $ do
      testParse parseIdentifierExpr "[foo]" `shouldParse` var "foo"
    it "(대문자) 영문 식별자" $ do
      testParse parseIdentifierExpr "[Foo]" `shouldParse` var "Foo"
    it "한글 음절 식별자" $ do
      testParse parseIdentifierExpr "[사과]" `shouldParse` var "사과"
    it "한글 자음 식별자" $ do
      testParse parseIdentifierExpr "[ㅅㄷㅎ]" `shouldParse` var "ㅅㄷㅎ"
    it "한글 모음 식별자" $ do
      testParse parseIdentifierExpr "[ㅓㅗㅜㅣ]" `shouldParse` var "ㅓㅗㅜㅣ"
    it "숫자가 포함된 식별자" $ do
      testParse parseIdentifierExpr "[사람2]" `shouldParse` var "사람2"
    it "공백이 포함된 식별자" $ do
      testParse parseIdentifierExpr "[사과는 맛있다]" `shouldParse` var "사과는 맛있다"
    it "숫자로 시작하는 식별자에 대해 오류" $ do
      testParse parseIdentifierExpr `shouldFailOn` "[10마리 펭귄]"
    it "공백으로 시작하는 식별자에 대해 오류" $ do
      testParse parseIdentifierExpr `shouldFailOn` "[ Foo]"
    it "공백만 포함된 식별자에 대해서 오류" $ do
      testParse parseIdentifierExpr `shouldFailOn` "[  ]"
    it "비어있는 식별자에 대해서 오류" $ do
      testParse parseIdentifierExpr `shouldFailOn` "[]"

  describe "함수 이름 파싱" $ do
    it "더하고" $ do
      testParse parseFuncIdentifier "더하고" `shouldParse` "더하고"
    it "반환 키워드에 대해서 오류" $ do
      testParse parseFuncIdentifier `shouldFailOn` "반환하다"
    it "부울 키워드에 대해서 오류" $ do
      testParse parseFuncIdentifier `shouldFailOn` "참"

  describe "함수 호출식 파싱" $ do
    it "인자가 2개인 함수 호출식" $ do
      testParse parseFuncCall "1 2 더하다"
        `shouldParse` app (var "더하다") [litInteger 1, litInteger 2]
    it "인자가 없는 함수 호출식" $ do
      testParse parseFuncCall "깨우다" `shouldParse` app (var "깨우다") []

  describe "중첩된 함수 호출식 파싱" $ do
    it "한 번 중첩된 식" $ do
      testParse parseNestedFuncCalls "4 2 더하고 2 나누다" `shouldParse` app
        (var "나누다")
        [app (var "더하고") [litInteger 4, litInteger 2], litInteger 2]
    it "두 번 중첩된 식" $ do
      testParse parseNestedFuncCalls "4 2 더하고 2 나누고 3 더하다" `shouldParse` app
        (var "더하다")
        [ app (var "나누고")
              [app (var "더하고") [litInteger 4, litInteger 2], litInteger 2]
        , litInteger 3
        ]

  describe "식 우선순위 테스트" $ do
    it "사칙연산 우선순위 괄호를 통해 변경" $ do
      testParse parseExpr "(1 + 1) / 2" `shouldParse` binaryOp
        Slash
        (binaryOp Plus (litInteger 1) (litInteger 1))
        (litInteger 2)
    it "함수 호출식이 사칙연산식보다 우선순위 높음" $ do
      testParse parseExpr "1 + 1 2 더하다" `shouldParse` binaryOp
        Plus
        (litInteger 1)
        (app (var "더하다") [litInteger 1, litInteger 2])
    it "함수 호출식과 사칙연산식 우선순위 괄호를 통해 변경" $ do
      testParse parseExpr "(1 + 1) 2 더하다" `shouldParse` app
        (var "더하다")
        [binaryOp Plus (litInteger 1) (litInteger 1), litInteger 2]

  describe "대입식 파싱" $ do
    it "단순 정수 대입" $ do
      testParse parseAssignment "[상자]: 10"
        `shouldParse` (assign "상자" (litInteger 10))
    it "(붙어있는) 단순 정수 대입" $ do
      testParse parseAssignment "[상자]:10"
        `shouldParse` (assign "상자" (litInteger 10))
    it "(떨어져있는) 단순 정수 대입" $ do
      testParse parseAssignment "[상자] : 10"
        `shouldParse` (assign "상자" (litInteger 10))
    it "사칙연산식 대입" $ do
      testParse parseAssignment "[상자]: 10 + 2"
        `shouldParse` (assign
                        "상자"
                        (binaryOp Plus (litInteger 10) (litInteger 2))
                      )
    it "대입식 대입" $ do
      testParse parseAssignment "[상자]: [박스]: 10"
        `shouldParse` (assign "상자" (assign "박스" (litInteger 10)))