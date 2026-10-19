# DMF0068_GAP392_PROJSORT_CLOUD_20261015 — Demand Manager 조회 결과·Project 선택 목록 정렬 (클라우드 패치)

- 마커: `[GAP392 2026-10-15]` · 대상: `SCM_MGR.PKG_DMF0068` PACKAGE BODY → `P_DMF0068_GET_LOOKUPPROJECT` · `P_DMF0068_GET_ORDERLIST`
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료(2026-10-15 19:59:21) · 리허설 후 최종 재적용(20:05:01, 내용 동일 md5 `8a7d892d…`) — `_artifacts/_apply_corporate/GAP392_DMF0068_PROJSORT_20261015/APPLIED_OPERATIONS.md`

## 무엇이 바뀌나
조회 결과와 Project 선택 목록이 대문자 우선(`BRP → BW.Akasol → Bosch → Boston Dynamics`)으로 정렬돼 AS-IS(`Bosch → Boston Dynamics → BRP → BW.Akasol`)와 순서가 달랐다.
AS-IS 도 같은 `ORDER BY` 였지만 AS-IS DB 콜레이션이 `Latin1_General_CI_AS`(대소문자 무시)이고 Oracle 은 BINARY 라서 생긴 차이다.
- **Project 셀 콤보**: `ORDER BY SEGMENT1` → `ORDER BY UPPER(D.SEGMENT1), D.SEGMENT1`
- **조회 결과**(동적 SQL 2분기): `ORDER BY B.PROJECT_NAME, …` → `ORDER BY UPPER(B.PROJECT_NAME), B.PROJECT_NAME, …` (뒤 정렬키 수주기간 시작·MEASURE 그대로)
- 뒤의 원래 값 키는 대소문자만 다른 값(예 `Honda●…` / `HONDA●…`)의 순서를 고정한다.
- 조회 행·값 · 원장 · 메타 · FE · 권한 · GTT 무변경. **BE 재기동 불필요.**

## 사내 검증 결과 (ZIOUI1, minyonglee1, FE 실전송값 10-15 15:10 로그)
| 항목 | 수정 전 | 수정 후 |
|---|---|---|
| Project 콤보 (35건) — AS-IS 콜레이션 정렬 대비 위치 다름 | **12건** (GAP 기재 12) | **0건** |
| 조회 결과 (72행 = 36세트) — AS-IS 대비 위치 다름 | **6세트** (GAP 기재 6) | **0세트** |
| 조회 행 수 | 72 | 72 (동일) |

- AS-IS 순서 = TO-BE 가 돌려준 값 목록을 AS-IS DB(LGCE_SCMDEV)에서 `COLLATE Latin1_General_CI_AS` 로 정렬한 순서.
- 리허설: 99(SKIP 사본) → 90 → 99 → 99(SKIP) → 90(미적용 FAIL 검출) → 00 → 10 → 10(SKIP) → 90, 전 단계 기대대로.
- **99 원복 결과 == 수정 전 원문 (md5 `26854a30…`)** · **10 재적용 결과 == 사내 적용본 (md5 `8a7d892d…`)**.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 L1 1건 · O1 2건 PASS · L2 마커 0 · L3 0행 | L1 FAIL 이면 **10 실행 금지**, 결과 회신. L3 에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_GAP392_PATCH.sql` | `APPLIED — PKG_DMF0068 BODY VALID · 마커 3곳` | `중단 — …` 이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 3줄(Project 콤보 · 조회 R_S · 조회 R_B) 순서 역전 0 PASS | 회신 |
| 4 | 화면 DMF0068 조회 | 조회 결과·Project 콤보가 `Bosch → Boston Dynamics → BRP → BW.Akasol`, `Honda●예정●EVF → HONDA●예정●Plug-in` 순 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP392_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

- 90_VERIFY V3 는 두 SP 를 직접 호출한다(없는 버전 `R_S_GAP392_VERIFY`/`R_B_GAP392_VERIFY` → SP 가 NULL 처리, 행은 DM_PLN_ORDER_MGT 전체). 원장 무변경, 조회 SP 의 세션 임시표만 사용. SP 자체 출력은 버리고 판정 줄만 보인다.

## 패치 방식 (왜 전체본이 아닌가)
- 클라우드 BODY 와 사내 BODY 는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 2종 문구(L1 1곳, O1 2곳)만 바꾼다. 문구는 모두 ASCII · 탭 없음.
- 99 원복은 적용 문구를 구 문구로 되돌린다 — 한글 비교 없음.
- 가드: 마커 존재 → SKIP / 대상 건수 불일치 → 중단 / 조립 마커 수 불일치 → 중단 / 컴파일 오류 → 원문 자동 복원(`EXECUTE IMMEDIATE` 를 `BEGIN…EXCEPTION` 으로 감쌈, ORA-24344 대응).

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 메타(MNU/API/BTN/SHEET_COLUMNS/MSG/LBL) | 해당 없음 |
| GTT/TABLE DDL | 해당 없음 |
| GRANT/SYNONYM | 해당 없음 — 객체 신설 없음 |
| FE (`B_FE` / `FE_MERGE`) · BE | 해당 없음 (FE 는 SP 순서를 그대로 표시 — 재정렬 없음 확인, 재기동 불필요) |

## 파일
- `build_package.py` — 생성기. 치환 정의는 사내 적용 스크립트 `apply_corp.py` 의 `OPS` 를 import(단일 원천). FRESH-GATE + 시뮬레이터.
- `run_rehearsal.py` · `_rehearsal_out/`(A·B 두 묶음) · `_rehearsal_99_SKIPCOPY.sql` — 사내 리허설.
- `_md5_corporate_applied.txt` · `_md5now.py` — 사내 적용본/수정 전 md5.
