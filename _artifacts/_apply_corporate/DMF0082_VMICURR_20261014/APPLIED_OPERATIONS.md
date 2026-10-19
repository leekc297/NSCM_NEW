# DMF0082 VMI 메저 CURRENCY = LOC 통화 표시 `[E20261014-DMF0082VMICURR]` — 사내 적용 기록

- 요청(2026-10-14): "DMF0082 에서 VMI 메저일 때도 CURRENCY LOC 에서 가져와서 같이 사용되고, CELL MERGE 되도록"
- 대상 DB: 사내 ZIOUI1 `59.19.252.148:2521/ZIOUI1` (SERVER_HOST=localhost)
- 기준 원문: `PKG_DMF0082` PACKAGE BODY LAST_DDL `2026-10-13 18:25:18` (2026-10-14 11:31 ALL_SOURCE 재조회)

## 원인
조회 SP 가 VMI 계열(`MEASURE LIKE 'VMI%'`)만 두 군데서 통화를 비웠다 (AS-IS `IIF(MEASURE LIKE 'VMI%','',CURRENCY)` 승계).
1. LOC 통화 백필 MERGE 의 `AND A.MEASURE NOT LIKE 'VMI%'` — LOC 통화를 받지 않음
2. `[E20260825-CURRNORM]` 의 `MEASURE LIKE 'VMI%' OR …` — 값이 있어도 `' '` 로 덮음

→ 같은 품목의 LOC·MKT_FCST 행은 `USD`, VMI 행만 빈칸이라 그리드 셀 병합이 VMI 행에서 끊김.

## 적용 (사용자 요청에 따른 AS-IS 와 다른 의도적 변경)
| # | 프로시저 | 위치 | 변경 |
|---|---|---|---|
| 1 | P_DMF0082_GET_MAIN_DATA | 백필 1차(9키)·2차(8키)·3차(5키) MERGE | `NOT LIKE 'VMI%'` 조건 주석 처리 |
| 2 | P_DMF0082_GET_MAIN_DATA | CURRNORM | `MEASURE LIKE 'VMI%' OR` 제거 |
| 3 | P_DMF0082_GET_MAIN_DATA_CURRENT | 백필 MERGE | `NOT LIKE 'VMI%'` 조건 주석 처리 |
| 4 | P_DMF0082_GET_MAIN_DATA_CURRENT | CURRNORM | `MEASURE LIKE 'VMI%' OR` 제거 |

- 손대지 않음: CURRENT 적재 단계 `CASE WHEN A.MEASURE LIKE 'VMI%' THEN NULL ELSE A.CURRENCY END` 2곳 (VMI 자기 원장 통화는 비우고 LOC 통화로 채움).
- 표시값(조회 임시 테이블)만 변경. 원장·저장 SP·단가 검증 무변경. FE 무변경 (정적 컬럼 셀 병합은 값이 같으면 자동).
- 파일: `00_BACKUP_PKG_DMF0082_BODY.sql`(원복용) · `01_PKG_DMF0082_BODY.sql`(적용본, +5줄, 마커 6) · `build_apply.py`

## 적용 결과 (2026-10-14 11:33:14)
- FRESH-GATE PASS · DB 원문 == 적용본 · PACKAGE BODY VALID · USER_ERRORS 0 · SCM_MGR INVALID 63 → 63 (변화 없음)

## 검증 — `test_before_after.py` (조회 SP 만 호출, 매 호출 rollback)
| 프로시저 | 케이스 | VMI 행 CURRENCY 전 → 후 | 비VMI 행 | VMI 행(통화 외) | 판정 |
|---|---|---|---|---|---|
| GET_MAIN_DATA | 40 acer_CN_CKG / minyonglee1 | `' '` → `USD` (LOC=USD) 1행 | 동일 | 동일 | PASS |
| GET_MAIN_DATA | 81 Ford_MX_CTN / minyonglee1 | `' '` → `USD` (LOC=USD) 3행 | 동일 | 동일 | PASS |
| GET_MAIN_DATA | 40·81·82 / k0101, 82 / minyonglee1 | VMI 행 없음(메저 미선택) | 동일 | — | PASS |
| GET_MAIN_DATA_CURRENT | 40 acer_CN_CKG / minyonglee1 | `' '` → `' '` (변화 없음) | 동일 | 동일 | FAIL(기존 결함, 아래) |

- 행 수 전후 동일 — VMI 행이 쪼개지거나 합쳐지지 않음.
- 화면 SEARCH 배선 = `P_DMF0082_GET_MAIN_DATA` (`SCM_ADM_MNU_BTN_MPG_M` FcstNPrice/SEARCH). `SEARCH_CURRENT`(GET_MAIN_DATA_CURRENT) 는 FE 미호출.

## 미해결 / 미실행
- **GET_MAIN_DATA_CURRENT 는 VMI 뿐 아니라 MKT_FCST 도 통화가 비어 있다** (k0101 40 acer: MKT_FCST `' '`, LOC `USD`).
  원인: 계획 arm 이 `'/' AS CURRENCY` 로 적재(L8602·8685·8922·9005)해 백필 조건 `A.CURRENCY IS NULL` 이 항상 거짓. 이번 범위 밖 — 수정 안 함.
- 82 VMI_Inv·VMI_DIO 실데이터 확인 안 됨 (테스트 계정이 그 메저를 선택하지 않음). 로직은 `LIKE 'VMI%'` 공통이라 동일하게 적용됨.
- 화면에서 셀 병합 육안 확인 안 함.
- 클라우드 미적용. 패치형 패키지 `_deploy_packages/DMF0082_VMICURR_CLOUD_20261014/` 작성 (2026-10-14 11:50 리허설 재적용 — 사내 BODY = 직접 적용본과 동일).
