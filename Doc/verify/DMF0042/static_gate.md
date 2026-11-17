# 정적 게이트 DMF0042 — 2026-11-17 15:12

- 원장 3834행 · 정적 판정 3801행(ERROR 2551 · FAIL 13 · NA 1074 · PASS 102 · 판정필요 61) · 런타임(E2E) 보류 0행
- **직접 FAIL 1** · 사용자 판정 FAIL 0 · 정적 실측 규칙 13종: A6, B8, DB-SYN, F1, F10, G5, H1, I1, I4, MS1, N1, X-LOC, X-ROW

## 직접 FAIL(정적)

| row_id | 규칙 | 대상 | 기대 원천 | 증거 |
|---|---|---|---|---|
| V-d3787247 | I4 | DMF0042 화면 | DOC:규칙 I4 정의 · 결함원장 유형(Doc/verify/_engin | t() 코드 16개 중 같은 문구의 앞선 코드가 있는데 새로 채번 1: LBL00711↔LBL00309 |

## ERROR 사유(정적)

- 642  | [미검증] 검사기(_verify
- 515  | [미검증] 검사기(_trace.
- 103 진입점 집계 — 대조표 DMF0042
- 52 진입점 집계 1검사 — ERROR:1
- 51  | [미검증] 검사기(combo_o
- 43 검사기 있음(_verify.spec(
- 42 진입점 집계 2검사 — ERROR:2
- 39 이 표에 구현 위치 열이 없고 행에도
- 34  | [미검증] 검사기(smoke 조
- 23 진입점 집계 4검사 — ERROR:4
- 23 진입점 집계 11검사 — ERROR:
- 22  | [미검증] 검사기(popup_a

## E2E 유래 FAIL(직전 실행 결과 · 이번 게이트 범위 밖 · 숨기지 않음) — 1행

- EG-150732a5 F4 DMF0042 전 컬럼 선택 조회 Biz Plan — PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA(Biz Plan) 칸 41개 전부 선택 조회 오류: ORA-00960: ambiguous column naming in select list

> 이 게이트는 CheckList 판을 만들지 않는다. E2E 가 필요한 행은 정규 실행(run_verify.py <ID>) 또는 부분 재판정(--only <규칙>)에서 판정한다.
