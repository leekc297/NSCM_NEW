# DMF0049_GAP358_GDWDUPNVL_CLOUD_20261015 — ETC Sales Reports 저장 GDW 중복 키 검사 빈 값 누락 보완 (클라우드 패치)

- 마커: `[GAP358 2026-10-15]` · 대상: `SCM_MGR.PKG_DMF0049` PACKAGE BODY → `P_DMF0049_SAVE_SALES_ETC_REPORT_C`
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료(2026-10-15 18:36:26) · 리허설 후 최종 재적용(18:40:33, 내용 동일 md5 `e0b6f145…`) — `_artifacts/_apply_corporate/GAP358_DMF0049_GDWDUP_20261015/APPLIED_OPERATIONS.md`

## 무엇이 바뀌나
저장 시 GDW 중복 키 검사([E20250418-001567], 12키: Division·Department·Team·Model·Measure·YYYYMM·Currency·Company Id·End Cust.(Report)·Cust.(Report)·Product Gr.(Report)·Country Name)의 연결 조건을 바꾼다.
- AS-IS(MSSQL) `A.x = B.x` 는 빈 값끼리(`'' = ''`) 같다고 본다. Oracle 은 빈 값이 NULL 이라 **비교가 성립하지 않아** Country·Cust.(Report) 가 빈 행이 검사에서 빠졌다.
- 연결 조건 12개(VERSION_NO 제외)를 `NVL(A.x,'/') = NVL(B.x,'/')` 로 바꾼다 (센티널 `'/'` — 사용자 지시 2026-10-15).
- 저장 로직 · 원장 · 메타 · FE · 권한 · GTT 정의 무변경. **BE 재기동 불필요.**

## 사내 검증 결과 (ZIOUI1, Div 40, 버전 `R_S_20260823_V004`, 원장 13,287행)
| 항목 | 수정 전 | 수정 후 | AS-IS |
|---|---|---|---|
| 검사 대상(원장 행이 자기 자신과 연결 성립) | 158 / 13,287 | **13,287 / 13,287** | 13,287 / 13,287 |
| 빈 Country 키 중복 2행 → 중복 판정(v_chk) | **0 (누락)** | **1 (탐지)** | 탐지 |
| 값이 다 있는 키 중복 2행(대조) | 1 | 1 | 탐지 |
| 빈 Country 키 1행(비중복, 오탐 점검) | 0 | 0 | 0 |

- 시험 방식: DB 의 현재 BODY 에서 검증 문장을 그대로 추출해 세션 GTT 로 실행(원장 무변경, ROLLBACK).
- 빈 값 실태: 원장 전체 CUST_REPORT NULL 432 · COUNTRY_CODE NULL 853,012 (`'/'`·`'-'`·공백 0) — 12키 중 빈 값은 NULL 형태만.
- 리허설: 99(SKIP 사본) → 90 → 99 → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10 → 99 → 10, 전 단계 기대대로.
- **99 원복 결과 == 수정 전 원문 (md5 `3b7fa217…`)** · **10 재적용 결과 == 사내 적용본 (md5 `e0b6f145…`)**.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | `L1 대상 블록 1건 → PASS` · L2 마커 0 · L3 0행 | L1 FAIL이면 **10 실행 금지**, 결과 회신. L3에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_GAP358_PATCH.sql` | `APPLIED — PKG_DMF0049 BODY VALID · 마커 1곳` | `중단 — …`이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 NVL 12 PASS / 구조건 0 PASS · V4 NEW_NVL_MATCH = TOTAL_ROWS | 회신 |
| 4 | 화면에서 빈 Country 행과 같은 키로 중복 행 저장 시도 | 중복 메시지로 저장 차단 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP358_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식 (왜 전체본이 아닌가)
- 클라우드 BODY 와 사내 BODY 는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 연결 조건 13줄 블록(ASCII)만 바꾼다.
- 99 원복은 적용 블록(ASCII, 마커 주석 포함)을 구 블록으로 되돌린다 — 한글 비교 없음.
- 가드: 마커 존재 → SKIP / 대상 블록 1건 아님 → 중단 / 조립 결과 불일치 → 중단 / 컴파일 오류 → 원문 자동 복원(`EXECUTE IMMEDIATE` 를 `BEGIN…EXCEPTION` 으로 감쌈, ORA-24344 대응).

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 메타(MNU/API/BTN/SHEET_COLUMNS/MSG/LBL) | 해당 없음 — 중복 메시지 문구 기존 그대로 |
| GTT/TABLE DDL | 해당 없음 — 기존 `GT_DMF0049_RESULTS_MST` 그대로 |
| GRANT/SYNONYM | 해당 없음 — 객체 신설 없음 |
| FE (`B_FE` / `FE_MERGE`) · BE | 해당 없음 (재기동 불필요) |

## 파일
- `build_package.py` — 생성기. 사내 BODY 재조회 FRESH-GATE + 시뮬레이터(수정 전→적용 == 적용본 · 적용본→원복 == 수정 전).
- `run_rehearsal.py` · `_rehearsal_out/` · `_rehearsal_99_SKIPCOPY.sql`(99 문법 선검증용 항상-SKIP 사본) — 사내 리허설.
- `_md5_corporate_applied.txt` · `_md5now.py` — 사내 적용본/수정 전 md5.
