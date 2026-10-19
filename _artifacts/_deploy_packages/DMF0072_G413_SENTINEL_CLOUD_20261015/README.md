# DMF0072 GAP413 — 하역지·플랜트 빈값 매핑 ↔ EDI 연결 보완 / 클라우드 이관 (2026-10-15)

## 내용
조회·연결 시 `NULL / '' / ' ' / '-' / '--' / '/'` 를 모두 같은 "값 없음"으로 인식하도록 DB 객체 5개의 **비교식만** 보완.
저장값·출력값은 바꾸지 않음. FE·BE 변경 없음. 메타(API/PROC_M/권한)·GRANT·시노님 변경 없음(기존 객체 본문만 수정).

| 객체 | 보완 지점 | 대상 라인 |
|---|---|---:|
| PKG_DMF0072 (BODY) | 저장 시 기존행 판정·UPDATE 조건 | 6 |
| PR_DM_CUST_MODEL_MAPPING | EDI → 매핑 기초행 생성 (조회 조인 + MERGE ON) | 6 |
| PR_DM_CUST_MODEL_MAPPING_IF | NERP IF → 매핑 MERGE ON 2곳 | 6 |
| PR_DM_DNM_EDI_CALLOFF_MKT_FCST | 매핑 GTT 적재(GROUP BY) + EDI↔매핑 조인 2곳 | 11 |
| PR_DM_PLN_CUST_FCST_RECORD | 매핑 GTT 적재(GROUP BY) + EDI↔매핑 조인 | 9 |

## 적용 방식 (클라우드 원문 비공개 대응)
클라우드 원문은 사내와 다를 수 있어 **객체 전체를 덮어쓰지 않는다.** `01_APPLY` 가 클라우드 DB 안에서 현재 원문(ALL_SOURCE)을 읽고
대상 라인의 비교식만 정규식으로 치환한 뒤 재컴파일한다. 라인 내 공백·들여쓰기와 대상 밖 코드는 클라우드 원문 그대로 유지된다.
- 대상 라인 수와 같은 모양 라인 총수가 사내와 다르면 **적용하지 않고 ORA-20413 으로 중단**(원문 무변경)
- 이미 적용된 객체(`GAP413` 표식)는 SKIP → 재실행 멱등
- 컴파일 오류 시 같은 블록에서 원래 원문으로 재생성 후 ORA-20414 (자동 원복)

## 실행 순서 (각 파일 전체 F5)
1. `00_PRECHECK.sql` — 조회 전용. 5행 각각 `MATCH_LINES = EXPECT_MATCH` 이고 `ALREADY_MARKED = 0` 이면 진행
   (`ALREADY_MARKED = EXPECT_TARGET` = 이미 적용됨 / 그 외 = 원문 상이 → 적용하지 말고 결과 회신)
2. `01_APPLY.sql` — PL/SQL 블록 1개 + 확인 SELECT. 기대: 5행 `MARKED_LINES = EXPECT_MARKED` · `STATUS = VALID` · `ERRORS = 0`
3. (필요 시에만) `99_ROLLBACK.sql` — 적용 라인만 원래 비교식으로 역치환. 기대: `MARKED_LINES = 0` · `VALID` · `ERRORS = 0`

## 클라우드 1차 실행 결과 (2026-10-15 사용자 회신)
| 객체 | 결과 |
|---|---|
| PKG_DMF0072 / PR_DM_CUST_MODEL_MAPPING | APPLIED (6/6) |
| PR_DM_CUST_MODEL_MAPPING_IF | ORA-20413 — 대상 0/6 (클라우드 LAST_DDL 10-08 16:29, 사내와 원문 상이) → 무변경 |
| PR_DM_DNM_EDI_CALLOFF_MKT_FCST / PR_DM_PLN_CUST_FCST_RECORD | 앞 객체 중단으로 미실행 → `02_APPLY_REMAIN.sql` |

- `02_APPLY_REMAIN.sql` — 잔여 2객체만 적용 (01 과 같은 로직)
- `03_DIAG_IF_SOURCE.sql` — 클라우드 `_IF` 원문 조회 (TEXT 4000자 폭으로 회신 잘림 → 04 로 대체)
- `04_DIAG_IF_LINES.sql` — 비교 라인만 200자 폭 조회. 회신 결과: 클라우드 `_IF` 빈값 상수 = `'-'` (사내 `' '`), 206~208·372~374행
- `05_APPLY_IF.sql` — `_IF` 전용 적용 (상수 `'-'` 유지, 양변 정규화). 사내에 클라우드 모양 임시 프로시저를 만들어 검증: 6라인만 변경 · VALID · 재실행 SKIP (임시 객체 삭제)
- `99_ROLLBACK.sql` — 역치환 정규식에 `'-'` 상수 추가 (05 원복 지원). Oracle REGEXP 로 `'-'` 복원 확인
- 참고: PR_DM_PLN_CUST_FCST_RECORD 는 클라우드에서 적용 전부터 INVALID(ERRORS 0)

## 사내 검증 (ZIOUI1, 2026-10-15 11:17 — 실제 실행)
| 단계 | 결과 |
|---|---|
| 99_ROLLBACK | 5객체 원문(적용 전)과 바이트 일치 · VALID |
| 00_PRECHECK (미적용 상태) | MATCH = EXPECT_MATCH, MARKED = 0 (5/5) |
| 01_APPLY | 5객체 사내 적용본과 바이트 일치 · VALID · ERRORS 0 |
| 01_APPLY 재실행 | 5객체 SKIP · 변경 없음 |
| 00_PRECHECK (적용 상태) | ALREADY_MARKED = EXPECT_TARGET (5/5) |
| 원문 상이 시 중단 경로 | ORA-20413 발생 · LAST_DDL 무변경 |
| 컴파일 오류 자동 원복 경로 | **미검증** (오류 유발 시나리오 미실행) |

## 적용 후 확인 권장
- DMF0072 에서 하역지/플랜트 공란으로 신규 등록 → 다음 EDI 배치 후 MKT FCST / Customer FCST 에 해당 건 연결 여부
- DMF0072 에서 기존 공란 행 재저장 시 행이 추가로 생기지 않는지

## 파일
- `00_PRECHECK.sql` / `01_APPLY.sql` / `99_ROLLBACK.sql` — 클라우드 실행본
- `build_cloud_pkg.py` — 생성기 (사내 FRESH-GATE + 치환 로직 Python 재현 바이트 일치 검증)
- `_test_on_corporate.py` — 사내 실행 검증 스크립트 (클라우드 실행 대상 아님)
- 사내 적용 기록: `_artifacts/_apply_corporate/G413_DMF0072_SENTINEL_20261015/APPLIED_OPERATIONS.md`
