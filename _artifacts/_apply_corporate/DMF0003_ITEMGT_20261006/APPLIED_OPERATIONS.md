# DMF0003 저장 품목 원천 뷰 → 임시테이블 `[E20261006-ITEMGT]` — 사내 ZIOUI1 실행 작업 대조표

사용자 결정 2026-10-06: "TO-BE 에서 394행을 똑바로 수정하고, 이에 따라 제대로 동작하도록 보완" → 선택지 **B. 원복 + 임시테이블 구현**.
같은 날 14:39 적용한 `[E20261006-ASISPARITY]`(AS-IS 운영의 0건 동작에 맞춘 비활성 8곳)를 대체한다.

| 시각 (2026-10-06) | 계정 | 작업 | 대상 | SQL / 스크립트 |
|---|---|---|---|---|
| 16:51 | SCM_MGR | 착수 원문 조회 (조회 전용) | `PKG_DMF0003` BODY (LAST_DDL 2026-10-06 14:39:56) | — |
| 17:08경 | SCM_MGR | **임시테이블 4종 생성** + 인덱스 1 + `SCMP_APP` 권한(SELECT/INSERT/UPDATE/DELETE) + `SCMP_APP` 시노님 4 | `GT_DMF3_ITEM_SINGLE_ORI` · `_A` · `_B` · `_V_ALL`, `IDX1_GT_DMF3_ITEM_SINGLE_V_ALL` | [01_DDL_GT_DMF3_ITEM_SINGLE.sql](01_DDL_GT_DMF3_ITEM_SINGLE.sql) (`python build_apply.py ddl`) |
| 17:12:18 | SCM_MGR | 적용 직전 원문 백업 → **PKG BODY 적용** (FRESH-GATE 통과 · VALID · ERR 0 · 적용본 == DB 원문 · 의존 INVALID 0) | `PKG_DMF0003` BODY | [00_BACKUP_PKG_DMF0003_BODY.sql](00_BACKUP_PKG_DMF0003_BODY.sql) · [02_PKG_DMF0003_BODY.sql](02_PKG_DMF0003_BODY.sql) (`python build_apply.py apply`) |

## 변경 내용 — `P_DMF0003_SAVE_MKT_FCST` (15,626줄 → 15,711줄)

| # | 내용 | AS-IS 대응 (asis_delta 블록) |
|---|---|---|
| ① | ASISPARITY 가드 8곳 + 설명 주석 3줄 제거 — 제거 결과가 10-02 20:31:56 원문(md5 `869b25fc…`)과 같음을 확인 | — |
| ② | 초기화 구간에 임시테이블 4종 `DELETE` 추가 (5줄) | #002 사전 DROP |
| ③ | 입력 적재(FORALL) 뒤 첫 오류 분기 다음에 ORI → A/B → V_ALL 3단 적재 추가 (87줄). 사업부 = `GT_DMF3_RESULTS.V_DIVISION_ID`, `ACTIVE_FLAG='Y'` | #004 임시테이블 적재 |
| ④ | 저장 멤버 안 `SCM_MGR.DM_MST_ITEM_SINGLE_V` 6곳 → `SCM_MGR.GT_DMF3_ITEM_SINGLE_V_ALL` (81 Cell/Car 검증용 품목 적재 · BOM 존재 검증 · 상품·전극 RTF_SYS_RP 삭제/생성 · RMA RTF_SYS_RP 삭제/생성) | #009 · #015 · #023~026 |

- AS-IS 와 다른 점(의도): AS-IS 운영본은 적재 조건이 `DIVISION_ID = @p_division_id`(구분자 `^` 가 붙은 값)라 0건. TO-BE 는 저장 대상 행의 사업부로 적재한다.
- 뷰와 다른 점(AS-IS 의도와 동일): 임시테이블은 활성 행만 집계한다 → 비활성뿐인 품목은 대상에서 빠지고, 활성·비활성 행이 섞인 품목은 일부 컬럼 값이 뷰와 다를 수 있다(아래 검증 1).
- SPEC · PROC_M · 메타 · 원장 테이블 변경 없음.

## 검증 (2026-10-06 17:09~) — 수정 전 = 복제 `PKG_DMF0003_TB`(10-02 원문 = 뷰 직접 조회판), 수정 후 = `PKG_DMF0003`

| 시각 | 작업 | 스크립트 · 결과 파일 |
|---|---|---|
| 17:09경 | **적재 구문 단독 실행** — 세션 임시테이블만, ROLLBACK | `t01_test.py load` → `_test_load.json` |
| 17:13 / 17:15 | **RTF_SYS_RP 4문장 대상 건수** — 뷰 기준 vs 임시테이블 기준 (조회만) | `t01_test.py rtf` → `_test_rtf.json` |
| 17:14 | 검증용 복제 패키지 생성 — 운영 무영향 | `t01_test.py clone` |
| 17:15~17:27 | **검증 호출 비교 1차** — 대표 SHIP-TO 없는 사이트 입력(반드시 중단 · 원장 무기록 · 호출마다 ROLLBACK) | `t01_test.py cases` → `_test_cases.json` |
| 17:28~ | **검증 호출 비교 2차** — 단가 검증 제외 Fcst Type(SMF) | `t01_test.py cases3` → `_test_cases3.json` |
| 17:28~ | **실제 저장 왕복** — 원장에 없는 81 키 2개 · 수정 전 저장→정리→수정 후 저장→정리 | `t02_e2e.py` → `_test_e2e.json` |

결과
1. 적재: 임시테이블 품목 집합 = 뷰의 활성 품목과 일치 (한쪽에만 있는 품목 0 · 중복 키 0).

   | 사업부 | ORI / A / B / V_ALL 행 | 소요 | 뷰 활성 / 전체 | 뷰와 값이 다른 품목 수 (주요 컬럼) |
   |---|---|---:|---|---|
   | 40 | 118,768 / 103,313 / 86,223 / 103,313 | 2.40s | 103,313 / 170,321 | ITEM_TYPE 676 · MATERIAL_CLASS_NAME 130 · ITEM_NAME 47 · ITEM_CLASS_NAME 31 |
   | 82 | 76,492 / 38,677 / 33,333 / 38,677 | 1.09s | 38,677 / 52,617 | MATERIAL_CLASS_NAME 106 · FORECAST_INFO_CELL_PACK_COUNT 64 · ITEM_CLASS_NAME 33 · ITEM_TYPE 9 |
   | 81 | 67,463 / 43,986 / 32,041 / 43,986 | 1.27s | 43,986 / 86,446 | FORECAST_INFO_CELL_PACK_COUNT 137 · MATERIAL_CLASS_NAME 50 · ITEM_TYPE 26 · ITEM_CLASS_NAME 19 |
   | 11 | 146 / 146 / 114 / 146 | 0.21s | 146 / 174 | 0 |
   | 81_UC | 21,828 / 21,828 / 21,694 / 21,828 | 0.62s | 21,828 / 21,847 | 0 |

2. RTF_SYS_RP(당주 MKT_FCST 키 전부 재저장 가정): 82 = 삭제 319 / 319 · 생성 319 / 319 (뷰 / 임시테이블) · 40·81·RMA = 0 / 0.
3. 검증 호출 비교(수정 전 → 수정 후 메시지 동일 여부): Cell/Car 81 2건 동일 · BOM 82 2건 · 40 2건 · 81 2건 동일 · Kwh/Cell 81 2건 동일. 전부 같은 메시지로 같은 검증에서 중단.
   소요: BOM 검증 도달 4.0~8.9s → 1.8~3.7s / Cell/Car·Kwh 검증 도달 0.04~0.3s → 1.2~1.5s (임시테이블 적재가 앞에 붙음).
4. 실제 저장 왕복(81): 2개 키 모두 수정 전·후 `SUCCESS`, `DM_PLN_MKT_FCST` 569건 감사 일시 제외 전 컬럼 동일, `DM_PLN_CFM_MKT_DEMAND_PLAN` 0건 동일, 정리 후 잔존 0건.
   소요: 1번 키 142.9s(첫 호출) → 5.5s / 2번 키 3.8s → 6.3s.
   잔존: `DM_PLN_MKT_FCST_H` 이력에 테스트 저장분(키 `81/A15BW7002/BMW_DE_BKB/APBMW48CL-A2-2I0`, `81/A15PA7004/PSA_FR_MHS/ACPN4041I-A1T000`, 20261012, minyonglee1) 추가 — 감사 기록으로 남김.

5. **82 실제 저장 (DMF0003 저장 대상 사업부)** — 사용자 지적 "82 DIVISION 이 저장 대상 · 다른 DIVISION 은 저장 대상이 아닙니다" 로 추가.
   - 17:41~17:52 `t03_e2e_82.py` → `_test_e2e_82.json` : 복제 2개(뷰판 `PKG_DMF0003_TB` · 임시테이블판 `PKG_DMF0003_TN`)에서 Sales Plan 동기화 호출 1줄만 뺀 채 저장.
     원장에 없던 82 상품·전극 키 3개(`G-19-172/Fluence_US_BSR/EAPJ00193AA` · `EAWH00694AA` · `EAOT00244AA`) 모두 전·후 `SUCCESS`,
     `DM_PLN_MKT_FCST` MKT_FCST 1 · **RTF_SYS_RP 1** · BALANCE 568 전 컬럼 동일, 정리 후 0. 소요 84.8→50.1s / 9.2→4.0s / 34.5→5.9s.
   - 17:52~18:4x `t04_e2e_82_full.py` → `_test_e2e_82_full.json` : **동기화 포함 전체 경로** (사용자 승인 "사내오라클에서는 실제 저장 구현하고 실행해도 됩니다").
     수정 전 = 복제 `PKG_DMF0003_TB`(뷰판, 동기화 호출 유지) / 수정 후 = 운영 `PKG_DMF0003`. 키 `82/G-19-172/Fluence_US_BSR/EAPJ00193AA`.
     전·후 `SUCCESS`(480.8s / 463.5s — 대부분 동기화, 실행 중 타 사용자의 언두 데이터파일 확장으로 DB I/O 정체),
     세 원장(`DM_PLN_MKT_FCST` · `DM_PLN_CFM_MKT_DEMAND_PLAN` · `DM_PLN_SALES_PLAN`) 테스트 키 행 전 컬럼 동일 — Sales Plan 에 MKT_FCST 1 · RTF_SYS_RP 1 생성.
     테스트 키 밖 82 Sales Plan (행수 / 수량 합): 저장 전 123,985 / 78,711,283,075,368.48 → 수정 전 저장 후 165,387 / 109,693,962,729,651.62 → 수정 후 저장 후 165,387 / 109,693,962,729,651.62 (두 판 결과 동일).
     ⚠ 82 Sales Plan 은 2026-09-15 이후 처음 동기화돼 **계획구간 전체가 현재 MKT FCST 기준으로 다시 만들어졌다**(+41,402행). 화면에서 82 를 저장할 때와 같은 동작이며 되돌리지 않았다.
     정리 후 테스트 키 잔존 0 · 복제 패키지 삭제. 이력(`DM_PLN_MKT_FCST_H`)에 테스트 저장분 잔존.

## 미실시·주의
- 40 사업부의 실제 저장 성공 경로 미실행 (DMF0003 저장 대상 아님 — 사용자 확인).
- **TO-BE 저장 결과가 현재 AS-IS 운영과 다르다** — AS-IS 운영은 검증 3종·RTF_SYS_RP 재생성이 동작하지 않는다(L394 결함). AS-IS/TO-BE 비교 테스트에서 차이로 잡힌다.
- 저장마다 사업부 전체 활성 품목을 임시테이블에 적재한다(40 기준 약 2.4초). 저장 대상 품목만 적재하도록 줄이면 결과는 같고 더 빠르다 — 미적용(결정 대기).
- 클라우드 미적용 — 이관 패키지 작성 완료(2026-10-06 18:5x): [_deploy_packages/DMF0003_ITEMGT_CLOUD_20261006](../../_deploy_packages/DMF0003_ITEMGT_CLOUD_20261006/00_README.md). 패키지의 00·10·13·90 을 사내에서 실행해 동작 확인(05 로 생긴 사내 보관 테이블은 삭제).
- 원복: `python 99_ROLLBACK_apply.py` (현재 DB 원문에서 삽입·치환분만 되돌림 → 10-02 원문 = 뷰 직접 조회판. ASISPARITY 가드는 되살리지 않음).
- asis_delta_20261002 대응: 1단계 SR 우선순위 1·2·6·8·9·10·11·12 (`DMF0003_SAVE_MKT_FCST` #002·#004·#009·#015·#023~026) — 본 건으로 종결.
