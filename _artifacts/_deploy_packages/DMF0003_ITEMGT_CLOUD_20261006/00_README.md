# DMF0003 저장 품목 원천 뷰 → 임시테이블 (DB 단, 클라우드 이관)

> 마커 `[E20261006-ITEMGT]` — `PKG_DMF0003` BODY + 임시테이블 4종

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** — `PKG_DMF0003` BODY 1개 + 임시테이블 4종(신규) · 인덱스 1 · 임시테이블 권한/시노님. SPEC · FE · BE · 메타(PROC_M 등) · 원장 테이블 · 데이터 변경 없음 |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1, 2026-10-06 17:12:18) — [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0003_ITEMGT_20261006/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| 전제 | 클라우드 `PKG_DMF0003` 이 사내 변경 직전 판본과 같을 것 — SPEC 지문 `81/6910`(사내 10-02 11:38:28, 저장 인자 CLOB 판) · BODY 지문 `15618/758991`(사내 10-02 20:31:56 판). PRECHECK `[H-SPEC]` · `[H-BODY]` 가 판정 |
| BE 재기동 | 불요 |

## 1. 변경

`P_DMF0003_SAVE_MKT_FCST`(MKT FCST 저장, 82 사업부)가 품목 정보를 뷰 `DM_MST_ITEM_SINGLE_V` 에서 직접 읽던 것을, 저장 시작 때 임시테이블에 한 번 적재해 읽도록 바꾼다.
AS-IS SR [E20260720-000270](DP 입력시 문제 발생 件)의 의도와 같다.

| 변경 | 내용 |
|---|---|
| 임시테이블 4종 신설 | `GT_DMF3_ITEM_SINGLE_ORI` · `_A` · `_B` · `_V_ALL` (세션 유지형) + `IDX1_GT_DMF3_ITEM_SINGLE_V_ALL (DIVISION_ID, ITEM_ID)` |
| 초기화 | 저장 시작 시 임시테이블 4종 `DELETE` (5줄) |
| 적재 | 입력 적재 직후 `SCM_MST_ITEM_SN`(저장 대상 행의 사업부 · `ACTIVE_FLAG='Y'`) → ORI → A/B → V_ALL (87줄) |
| 참조 교체 6곳 | 81 Cell/Car 검증용 품목 적재 · BOM 존재 검증 · 상품·전극 RTF_SYS_RP 삭제/생성 · RMA RTF_SYS_RP 삭제/생성 |

화면에서 달라지는 점
- 검증과 RTF_SYS_RP 대상이 **활성 품목 기준**이 된다. 비활성뿐인 품목은 대상에서 빠진다.
- 활성·비활성 행이 섞인 품목은 품목 유형 등 일부 값이 뷰와 다를 수 있다(사내 82 기준: 품목 유형 9건 · 분류명 33건 등). 품목 수 자체는 뷰의 활성 품목과 같다(사내 82: 38,677 = 38,677).
- 저장마다 사업부 활성 품목 전체를 적재한다(사내 82 기준 약 1.1초).

AS-IS 운영과 다른 점: AS-IS 운영본은 임시테이블 적재 조건(L394)이 구분자 `^` 가 붙은 값과 비교돼 0건이라 위 검증·RTF_SYS_RP 가 동작하지 않는다. TO-BE 는 SR 의도대로 동작하게 했다(사용자 결정 2026-10-06).

변경분 전문 = [A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt](A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt) (8곳).

## 2. 사내 검증

- 82 사업부 실제 저장: 원장에 없던 키 3개(Sales Plan 동기화 호출 제외) + 1개(동기화 포함 전체 경로)를 수정 전(뷰 직접 조회판)·후로 저장 — 전부 `SUCCESS`, 저장 행 전 컬럼 동일(MKT_FCST 1 · RTF_SYS_RP 1 · BALANCE 568, Sales Plan MKT_FCST 1 · RTF_SYS_RP 1).
- 검증 호출 비교 10건(Cell/Car 2 · BOM 6 · Kwh/Cell 2): 수정 전·후 같은 메시지로 중단.
- RTF_SYS_RP 대상 건수(82, 당주): 뷰 기준 319 = 임시테이블 기준 319.
- 본 패키지의 `00` · `10` · `13` · `90` 을 사내에서 실행: `00` = `SKIP — 이미 적용됨`, `10` = 전부 `EXISTS - SKIP`, `90` = V1~V7 전부 PASS. `05` 는 보관 테이블 생성까지 확인 후 사내에서는 지웠다. `98`(롤백)은 실행하지 않았다.
- 화면 경유 저장은 실행하지 않았다.

## 3. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 각각, 번호순)

| # | 사내에서 한 작업 | 파일 | 비고 |
|---|---|---|---|
| 1 | (선판정) | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | 조회 전용. `[H-SPEC]` · `[H-BODY]` JUDGE 가 `적용` / `SKIP` / `⚠`(→ §4). `[G1]` 임시테이블 존재 · `[G2]` 권한 기준 · `[G3]` 82 품목 원천 행수 |
| 2 | (보관) | [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) | 현 SPEC+BODY → `BAK_SRC_DMF0003_ITEMGT` (있으면 건너뜀) |
| 3 | 임시테이블 4종 · 인덱스 · 권한 · 시노님 생성 | [A_DB/10_DDL_GT_DMF3_ITEM_SINGLE.sql](A_DB/10_DDL_GT_DMF3_ITEM_SINGLE.sql) | 멱등(있으면 건너뜀). 권한·시노님은 그 DB 의 기존 `GT_DMF3_ITEM_SINGLE_V` 것을 따른다. **11 보다 먼저** |
| 4 | `PKG_DMF0003` BODY 적용 | [A_DB/11_PKG_DMF0003_BODY.sql](A_DB/11_PKG_DMF0003_BODY.sql) | BODY 전체본 (830KB · 15,711줄 · `CREATE OR REPLACE PACKAGE BODY "PKG_DMF0003"` ~ `END PKG_DMF0003;` + `/`). `[H-BODY]` 가 `적용` 일 때만 |
| 5 | (안전망) | [A_DB/13_RECOMPILE_DEPENDENTS.sql](A_DB/13_RECOMPILE_DEPENDENTS.sql) | 본체 · 의존 INVALID 재컴파일 (사내 의존: `SCM_ADM_MAIL_SEND_BATCH` · `SCM_ADM_MAIL_SEND_DATA`) |
| 6 | (검증) | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 VALID · V2 BODY(표시 9 · 임시테이블 참조 8 · 뷰 참조 0 · ASISPARITY 0) · V3 임시테이블 4+인덱스 · V4 권한/시노님 차이 0행 · V5 앱 계정 EXECUTE · V6 의존 INVALID 0 · V7 82 품목 수 일치 |

사내에서 실행했지만 이관 대상이 아닌 것: 같은 날 14:39 의 `[E20261006-ASISPARITY]`(비활성 8곳)은 본 건이 걷어냈고 클라우드에 올린 적이 없다. 검증용 복제 패키지(`PKG_DMF0003_TB` · `_TN`)는 사내에서 만들고 지웠다.

롤백: [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql) → 13. 임시테이블 4종은 남겨도 된다(복원된 BODY 가 참조하지 않음).

## 4. 지문이 다르면 수동 반영

JUDGE 가 `⚠` 이면 전체본(11)을 쓰지 않는다 — 전체본은 사내 누적본이라 클라우드에만 있는 변경을 지우거나, 클라우드에 아직 없는 사내 선행 변경(10-01·10-02 저장 인자 CLOB 화 등)을 같이 올린다.

1. `10` 은 그대로 실행한다(임시테이블은 판본과 무관).
2. [12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt](A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt) 의 `-` 줄을 클라우드 BODY 의 `P_DMF0003_SAVE_MKT_FCST` 안에서 찾아 `+` 줄로 바꾸고, `+` 만 있는 블록 2개(초기화 5줄 · 적재 88줄)는 앞뒤 원문 위치에 넣는다. `@@` 줄 번호는 사내 기준이므로 앞뒤 원문으로 위치를 찾는다.
3. 적재 블록은 `GT_DMF3_RESULTS` 에 입력이 들어간 뒤(오류 분기 `IF V_INVALID THEN GOTO ERR_RTN; END IF;` 다음)에 와야 한다. 클라우드 BODY 가 입력을 반복문으로 적재하는 옛 판이면 그 반복문이 끝난 뒤에 넣는다.
4. 컴파일 후 `90` 으로 확인한다(V2 의 지문은 다를 수 있고, 표시 9 · 임시테이블 참조 8 · 뷰 참조 0 이 맞으면 된다).

## 5. 주의

- 82 저장은 끝에서 Sales Plan 동기화를 불러 82 사업부 Sales Plan 계획구간 전체를 다시 만든다(기존 동작, 본 건과 무관). 클라우드에서 저장 테스트를 하면 Sales Plan 이 현재 MKT FCST 기준으로 갱신된다.
- AS-IS 운영과 저장 결과가 다르다(§1). AS-IS/TO-BE 결과 비교에서는 BOM·Cell/Car·Kwh/Cell 검증과 RTF_SYS_RP 가 차이로 잡힌다.
- 적재 범위를 "저장 대상 품목만"으로 줄이는 최적화는 넣지 않았다(결정 대기). 넣게 되면 BODY 만 다시 이관한다.
- 재빌드: `python _build.py` (사내 DB 최신 원문을 다시 읽어 전 파일 재생성). 24시간이 지나면 재빌드 후 전달한다.
