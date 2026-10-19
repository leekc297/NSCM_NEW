# DMF0074 Excel Upload — 동적 컬럼 공란 적재 AS-IS 파리티 (EMPTYASIS) · 클라우드 이관

- 작성: 2026-10-01 · 사내 ZIOUI1 적용 완료(BODY LAST_DDL 2026-10-01 16:46:54, VALID, 오류 0)
- 대상: 클라우드 QA · DEV 각각 SCM_MGR
- 범위: `PKG_DMF0074` PACKAGE BODY 1개 (SPEC 변경 없음 · FE/BE 변경 없음 · 메타 변경 없음)

## 무엇이 바뀌나
AS-IS(MSSQL)는 엑셀 빈칸을 `''` 로 받아 UNPIVOT 이 버리지 않으므로, 모델마다 **금속 7행을 항상 저장**했다.
저장값은 이렇다.
- 빈 키·기간·Exception = `''` (이관 후 `'-'`)
- 빈 단가·수량·Energy = `ROUND('')` = 0

TO-BE(Oracle `''`=NULL)는 빈 금속을 버려서 다음 문제가 있었다.
- Metal Link=N / Exception=Y 행이 저장되지 않음
- 81에서 키만 있는 금속이 빠지고 `Save verify failed` 오류가 남
- 빈칸으로 다시 올려도 기존 값이 갱신되지 않음

| 위치 (P_DMF0074_EXCEL_UPLOAD) | 변경 |
|---|---|
| 3-1 ~ 3-6 UNPIVOT (6곳) | `UNPIVOT INCLUDE NULLS` — 빈 금속도 7행 유지 |
| 3-7 조인 METAL_EXCEPTION_YN (5곳) | NVL 양변 — Exception 공란 행 탈락 방지 |
| 3-7 SELECT | 키·기간·Exception NVL `'-'` / Energy·단가·수량 NVL 0 |

검증 블록(`NULL APPLY PRICE TYPE CODE.`, `NULL <금속> :` 등)은 **변경하지 않았다** — AS-IS 와 동일하게 유지.

## 포함되는 사내 선행분
`01` 은 사내 현행 BODY 전문이다. 09-15 클라우드 판본(DMF0074_EXCELUPLOAD_CLOUD_20260915)에 비해 아래 두 가지가 더 들어 있다.
- `[E20260918-KEYNAMETOCODE]` — 광물 Key 명칭 입력을 코드로 정규화. 클라우드 미이관분.
- 본 건 `[E20261001-EMPTYASIS]`.

## 실행 순서
1. `A_DB/00_PRECHECK.sql` → `VERDICT = OK` 확인 (아니면 결과 공유 · 중지)
2. `A_DB/01_PKG_DMF0074_BODY.sql` (sqlplus/SQL Developer 스크립트 실행 — `SET SQLBLANKLINES ON` 포함)
3. `A_DB/90_VERIFY.sql` → VALID · 마커 수 EMPTYASIS 12 / KEYNAMETOCODE 3 / NOLOADGUARD 2

## 사내 검증
- 구조 게이트(`_apply_corporate/DMF0074_EMPTYASIS_20261001/test_mock_unpivot.py`)
  - 적용된 BODY 문장을 세션 GTT 모의 3행으로 실행하고 ROLLBACK 했다. 원장은 건드리지 않았다.
  - 21행(3×7) 생성 · NULL 0 · 입력값과 반올림(10.555→10.56) 정상 · 공란 `'-'`/0 → **PASS**
- 원장 근거: AS-IS 이관분 전 모델 금속 7행 / 키 `'-'`+단가 0 = 81 8,165행 · 82 1,875행 / 81 Energy 0 33,495행

## 원복
`_apply_corporate/DMF0074_EMPTYASIS_20261001/00_BACKUP_PKG_DMF0074_BODY.sql` 은 사내 적용 직전 전문이다.
클라우드는 적용 전 판본이 다를 수 있으므로, 적용 전에 클라우드 BODY 를 따로 백업해 둘 것.
