# 정적 게이트 SCP0037 — 2026-11-08 11:51

- 원장 1706행 · 정적 판정 1004행(ERROR 57 · NA 695 · PASS 233 · 판정필요 19) · 런타임(E2E) 보류 0행
- **직접 FAIL 0** · 사용자 판정 FAIL 0 · 정적 실측 규칙 43종: A2, A5, A6, B2, B3, B4, B5, B6, B8, C1, C3, C4, D1, D3, D5, D6, DB-SYN, E3, E4, E5, F1, F10, F3, G1, G4, G5, G7, H1, H10, H2, H4, H5, H6, H8, I1, I4, J1, J2, J4, K4, MS1, X-LOC, X-ROW

## 직접 FAIL(정적)

| row_id | 규칙 | 대상 | 기대 원천 | 증거 |
|---|---|---|---|---|
| - | - | 없음 | | |

## ERROR 사유(정적)

- 12 규칙 C2 판정 6행 중 FAIL 0
- 8 규칙 D4 판정 2행 중 FAIL 0
- 6 규칙 N1 판정 1행 중 FAIL 0
- 4 행 집계 — 대조표 COMMON:UC
- 3 규칙 M3 판정 2행 중 FAIL 0
- 3 규칙 G1 판정 1행 중 FAIL 0
- 2 규칙 C2 판정 2행 중 FAIL 0
- 2 규칙 G2 판정 1행 중 FAIL 0
- 1 규칙 D1 판정 2행 중 FAIL 0
- 1 규칙 D1 판정 3행 중 FAIL 0
- 1 규칙 E4 판정 3행 중 FAIL 0
- 1 규칙 E4 판정 1행 중 FAIL 0

## E2E 유래 FAIL(직전 실행 결과 · 이번 게이트 범위 밖 · 숨기지 않음) — 2행

- V-d73d9696 SC1 SCP0037 화면 — 조회조건 순서가 Excel 과 다름 — 화면 operation → div → plantsite → material → active ↔ Excel(List 시트 순서 · SCP_화면별 조회조건 정리_260731_v0.5.xlsx 114행) 순서·구성: 
- V-eed95e79 E1 Operation LT.LT_DAY (LT(Day)*) — 신규행 r0 LT_DAY: 유효값 '1' 입력 OK(편집기) · 소수 0자리 초과 입력 '1.5' → 값 '' OK · 문자(숫자 아님) 입력 'ab' → 값 '' OK · 최소 1 미만 입력 '0' → 값 '' OK · 최대 100 초과 입력 '10

> 이 게이트는 CheckList 판을 만들지 않는다. E2E 가 필요한 행은 정규 실행(run_verify.py <ID>) 또는 부분 재판정(--only <규칙>)에서 판정한다.
