# DMF0072_GAP412_INSDUP_CLOUD_20261015 — 신규 행 키 중복 시 덮어쓰기 대신 저장 실패 (클라우드 패치, DB 만)

- 마커: `[GAP412 2026-10-15]` 1곳
- 대상: `SCM_MGR.PKG_DMF0072` PACKAGE BODY → `P_DMF0072_SAVE_NNMASTER_MAPPING` 루프 안 확인 블록 1개 삽입
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- **FE·BE 무변경 · BE 재기동 불필요.** 원장 · 메타 · 권한 무변경.
- 같은 날 `DMF0072_G413_SENTINEL_CLOUD_20261015`(GAP413, 같은 SP 센티널 통일)와 서로 독립 — 적용 순서 무관.

## 무엇이 바뀌나
| 구분 | 신규(I) 행의 키가 기존 행과 같을 때 |
|---|---|
| AS-IS `DMF0072_SAVE_NNMASTER_MAPPING` (LGCE_SCMDEV 2025-01-21) | MERGE 가 I 행을 항상 INSERT → PK(`DM_CUST_MODEL_MAPPING_M_PK` 15컬럼, End Customer 미포함) 위반 → **저장 실패**, 같이 보낸 행 전부 미반영 |
| TO-BE 현재 | 저장 커서 `ACT_TYPE IN ('M','I')`(2026.08.13 변경) + "있으면 UPDATE" → **오류 없이 기존 행의 Valid From/To · Active · Mapping Item 을 덮어씀** |
| 패치 후 | I 행이 같은 PK 의 기존 행과 겹치면 오류 → 저장 전체 ROLLBACK. 오류 문구: `Duplicate key: the same mapping already exists. Nothing was saved. (Data Type=…, Company=…, Sold To=…, Ship To=…, Sales Site=…, Project=…, Customer Item=…, Item=…, Mapping Item=…)` |

- 빈 값 비교는 `'-'` · `'--'` · `'/'` · 공백을 같은 값으로 본다 (GAP413 과 같은 정규화). 그래서 옛 행이 `'-'` 로 저장돼 있어도 중복으로 잡힌다.
- 한 번에 같은 키의 신규 행 2개를 보내면, 두 번째 행이 첫 행과 겹쳐 실패한다. AS-IS 의 PK 위반과 같다.
- 수정(M) 행 처리와 저장 커서는 바꾸지 않았다.
- 시트 조치안 중 "업무 확인 후 덮어쓰기 허용"은 택하지 않았다. AS-IS 와 같은 저장 실패로 맞췄다. 덮어쓰기를 허용하기로 결정되면 99_ROLLBACK 으로 되돌리면 된다.

## 검증 상태 (2026-10-15 21:00, 사내 ZIOUI1 59.19.252.148)
- ⚠ **사내 ZIOUI1 은 아직 미적용이다.** 적용 실행이 권한 분류기에 막혀 있다. 그래서 사내 컴파일과 화면 저장 실측은 **미검증**이다.
- 확인한 것 (모두 DB 무변경):
  - 생성 직전 사내 원문을 다시 읽어 착수 조회본과 같음을 확인했다 (FRESH-GATE, LAST_DDL 2026-10-15 11:17:46).
  - 시뮬레이터: 수정 전 → 적용 결과가 적용본과 같고, 적용본 → 원복 결과가 수정 전과 같다.
  - **DRY-RUN**: 10/99 PL/SQL 블록을 사내에서 실행했다. 소스는 바인드로 넣고, 컴파일 대신 결과를 반환하게 했다. 결과:
    - 10 적용 == 적용본 전문
    - 10 재실행 = SKIP
    - 99 원복 == 수정 전 전문
    - 99 재실행 = SKIP
  - 중복 판정식을 실제 원장 행(81 Audi, UNLOADING_POINT `'-'`)에 넣어 조회했다. 빈 값으로 보내는 경우를 가정했을 때도 1건으로 잡힌다.
  - FE 실전송값: 신규 행은 `ACT_TYPE='I'`, ORIGINAL = MAPPING_ITEM_ID (`NnMasterMapping.tsx` L308·L312).
  - 00_PRECHECK 사내 실행: L1·L2 PASS · L3 마커 0 · L4 0행.
  - 90_VERIFY 사내 실행: 문법 정상. 적용 전이라 V1·V3 는 FAIL 이 맞다.
  - 결과 기록 위치: `_rehearsal_out/`
- 사내 적용기: `_artifacts/_apply_corporate/DMF0072_GAP412_20261015/apply_gap412.py apply`. 같은 문구를 쓰며, 적용 후 VALID·오류 0·의존 INVALID 0 을 확인하고 실패 시 원문을 복원한다.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 PASS · L2 PASS · L3 마커 0 · L4 0행 | L1 FAIL 이면 **10 실행 금지**, 결과 회신. L2 FAIL 은 회신 (신규 행 미처리 구판) |
| 2 | `A_DB/10_APPLY_GAP412_PATCH.sql` | `APPLIED — PKG_DMF0072 BODY VALID · 마커 1곳` | `중단 — …` 이면 원문은 바뀌지 않음. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 1 PASS | 회신 |
| 4 | 화면 DMF0072 | 기존 행과 같은 키로 신규 행 저장 → 오류, 기존 행 값 그대로 / 새 키 신규 행 → 정상 저장 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP412_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 파일
- `build_package.py` — 생성기 (FRESH-GATE · 시뮬레이터 · DRY-RUN 포함, 문구는 사내 적용기와 단일 소스).
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 조회 전용 실행 결과 (00·90).
- `_md5_corporate.txt` — 생성 시점 사내 수정 전·적용본 md5.
