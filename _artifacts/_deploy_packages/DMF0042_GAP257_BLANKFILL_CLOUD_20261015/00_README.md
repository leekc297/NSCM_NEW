# DMF0042_GAP257_BLANKFILL_CLOUD_20261015 — 빈 FCST Type·Incoterms 행 키 보정 (클라우드 패치, DB 만)

- 마커: `[E20261015-GAP257]` 5곳 · 대상: `SCM_MGR.PKG_DMF0042` PACKAGE BODY → `P_DMF0042_SAVE_DM_PLN_BP_FCST` "2021.7.23 키 업데이트용 데이터 처리" 블록
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료 · 리허설 재적용(18:48, 사내 적용본과 원문 전체 일치) — `_artifacts/_apply_corporate/DMF0042_GAP257_20261015/APPLIED_OPERATIONS.md`
- **FE 무변경 · BE 재기동 불필요.** 원장 데이터 변경 없음(다음 저장 때 해당 키만 채워짐).

## 무엇이 바뀌나 (AS-IS `DMF0042_SAVE_DM_PLN_BP_FCST` 기준)
같은 키(11개)로 Business Plan 을 저장하면 FCST Type·Incoterms 가 빈 옛 행을 채우고 끝나는 AS-IS 동작을 복원한다.
| # | 변경 | 이유 |
|---|---|---|
| ① | 빈값 검사 `IS NULL` → `IN ('-', '/')` | 두 컬럼 NOT NULL + DEFAULT ON NULL '/' 라 IS NULL 은 항상 거짓. 과도기에 이관 빈값 '-' 와 신규 빈값 '/' 공존 |
| ② | `IF V_CNT_1 > 0 AND V_DIVISION_ID = '40'` | AS-IS 의 40 조건 누락 |
| ③ | 11키 조인 센티널 키 4종(DEPT_ID·END_CUSTOMER·BIZ_TYPE·ITEM_USE) '-'/'/' 동치 | 40 원장 '-' · 저장 GT 정규화 '/' — ①만 고치면 계속 미매칭 |

## 사내 검증 (ZIOUI1)
- 컴파일 VALID · 오류 0 · E2E(원장에 없는 시험키, 종료 후 삭제): 40 '-' 빈값 채움 ✅ · 40 '/' 빈값 채움 ✅ · 81 미변경 ✅
- 패키지: 생성기 시뮬레이터(수정 전→적용 == 적용본 · 적용본→원복 == 수정 전) 통과 · 사내 리허설 90 → 99 → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10 → 90 전 단계 기대대로 · **99 원복 md5 == 수정 전 · 10 재적용 md5 == 사내 적용본**.
- 대상 원장(사내): 40 71,673 · 81 3,084 · 82 368행 — 전부 2024-12 이전(82 는 2025-12) → 현재 편집 기간(2026-09~) 행은 0. 실제 채움은 그 키로 다시 저장할 때만 일어난다.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 5줄 PASS · L2 마커 0 · L4 0 | L1 FAIL 이면 **10 실행 금지**, 결과 회신. L4 > 0 이면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_GAP257_PATCH.sql` | `APPLIED — PKG_DMF0042 BODY VALID · 마커 5곳` | `중단 — …` 이면 원문 무변경, 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 마커 5 · V2 VALID/오류 0 · V3 4줄 전부 PASS | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP257_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |
- L4 의 `V$ACCESS` 조회 권한이 없으면 그 문장만 오류가 난다 — 나머지 판정에는 영향 없음.

## 패치 방식
- 클라우드 BODY 는 사내와 적용 시점이 달라 **전체본 교체 금지**. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 ASCII 앵커(`INTO   V_CNT_1` ~ `GOTO END_PKUPDATE;`) 구간 안에서 **ASCII 토큰으로만** 위치를 찾고 연산 7개를 적용한다(한글 비교 없음). 연산마다 대상 건수가 기대와 다르면 원문 무변경으로 중단.

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 원장·GTT | 기존 객체만 사용 (데이터 변경 없음) |
| 메타 · MSG/LBL · GRANT/SYNONYM | 해당 없음 |
| FE / BE | 해당 없음 |

## 파일
- `build_package.py` — 생성기(FRESH-GATE · 시뮬레이터). 삽입 문구는 사내 적용본에서 그대로 추출.
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 리허설 실행기·결과 · `_md5now.py` · `_md5_corporate_applied.txt`
