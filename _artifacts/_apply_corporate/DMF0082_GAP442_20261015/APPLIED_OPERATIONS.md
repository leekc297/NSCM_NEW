# DMF0082_GAP442_20261015 — 사내 ZIOUI1 적용 기록

- 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_SAVE_MAIN_DATA` 40 경로 `DM_PLN_CFM_MKT_DEMAND_PLAN` Phase 1 DELETE + MERGE (마커 `[GAP442 2026-10-15]` 4곳)
- AS-IS 근거: AS-IS DB 165.244.95.223 / LGCE_SCMDEV `DMF0082_SAVE_MAIN_DATA` L1917~1945 (2026-10-15 13:1x 조회)
  - MATCHED AND QTY_PRICE = 0 AND MEASURE IN ('MKT_AMT_KRW','MKT_AMT_LOC') → DELETE
  - MATCHED → UPDATE QTY(0 포함) · LAST_UPDATED_BY · LAST_UPDATE_DATE
  - NOT MATCHED AND QTY_PRICE <> 0 → INSERT
- 변경 4줄
  1. Phase 1 DELETE 대상 measure: 5종 → `MKT_AMT_KRW`, `MKT_AMT_LOC`
  2. Phase 1 DELETE 내부 소스 measure: 5종 → 같은 2종
  3. MERGE 소스: `QTY_PRICE <> 0` → `(QTY_PRICE <> 0 OR MEASURE IN ('MKT_FCST','VMI_In_Req','SCM_FCST'))`
  4. MERGE INSERT: `WHERE B.QTY_PRICE <> 0` 추가
- DB: 59.19.252.148:2521/ZIOUI1 · 계정 SCM_MGR · 착수 기준본 LAST_DDL 2026-10-15 13:06:12 · FRESH-GATE 통과 후 적용 · VALID / 오류 0

## 재현 시도 (수정 전, 2026-10-15 13:16) — ⚠ 부수 영향 있음
- 키: 40 / Phylion / Phylion_CN_SUZ / MCCM350415B1 / E / MPS / DAP / '-' / NJ01-A · 일자 20280103 (저장 대상 measure 5종 행 없음 확인)
- `I` qty 100 → `Unit Price Not Found` 검증 차단 (해당 주 판가 없음) → MKT_FCST 행 생성 안 됨 → **재현 불성립**
- `M` qty 0 → SUCCESS. MKT_FCST 등 저장 대상 measure 행 변화 없음
- **⚠ 부수 영향**: 저장 후속 BALANCE 재계산으로 같은 품목·사이트(MCCM350415B1 / Phylion_CN_SUZ)의 `BALANCE` **701행**(20261012~20280911)이 LAST_UPDATED_BY=BALANCE_MAKE, 13:16:12 로 다시 계산됨(예: 20280103 -3,476,667 → -1,248,861). 파생값이며 이전 값 백업 없음 — 일 배치가 다시 계산함.

## 재현 시도 2 (적용 후, 13:22) — Isuzu / Isuzu_JP_TYO / EEA00597AD / EXW · 20271227
- `I` 100 → `MDM에서 Biz Type을 입력하시기 바랍니다` 검증 차단 → 행 생성 안 됨
- `M` 0 → SUCCESS, CFM 변화 없음. 단 DM_PLN_MKT_FCST 에 MKT_FCST QTY 0 행 1개 생성 → **삭제 정리**
- 재현 시도 1(Phylion 20280103 13:16)도 DM_PLN_MKT_FCST 에 같은 QTY 0 행 1개 생성 → **삭제 정리**

## 기능 검증 (사용자 승인 1번 — 판가 있는 키로 SP 실저장, 2026-10-15 13:25)
- 키: 40 / EATON_01 / EATON_01 / EATON_HK_YUE / MCCH335080B1T000 / E / MPS / DDP / '-' / HQ06-A · 20271227 (판가 LOC 2.6 · 저장 대상 5종 행 없음 확인)

| 단계 | DM_PLN_CFM_MKT_DEMAND_PLAN | DM_PLN_MKT_FCST |
|---|---|---|
| 시작 | 없음 | 없음 |
| `I` 100 → SUCCESS | MKT_AMT_KRW 361,400 · MKT_AMT_LOC 260 · MKT_FCST 100 | MKT_FCST 100 |
| `M` 0 → SUCCESS | **MKT_FCST 0 유지 (minyonglee1 · 13:25:35)** · 금액 2종 삭제 | MKT_FCST 0 |

- 판정: AS-IS 와 같음 (수요 0 = 행 유지·수정 / 금액 0 = 삭제) → PASS
- 정리: 테스트 행 삭제 CFM 1 · DM_PLN_MKT_FCST 1 → 오늘 13:00 이후 minyonglee1 생성 잔여 0
- 부수 영향: BALANCE 재계산 MCCH335080B1T000 171행 (파생값 · 사용자 승인 범위)

## 이관 패키지
- `_artifacts/_deploy_packages/DMF0082_GAP442_ZEROKEEP_CLOUD_20261015/` — 리허설(13:29~13:30) 전 단계 기대대로 · 99 원복 == 수정 전 원문 · 10 재적용 == 적용본 (원문 전체 일치)
