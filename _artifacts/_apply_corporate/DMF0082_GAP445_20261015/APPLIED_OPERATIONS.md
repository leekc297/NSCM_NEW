# DMF0082_GAP445_20261015 — 사내 ZIOUI1 적용 기록

- 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA` Current·MF 분기 (마커 `[GAP445 2026-10-15]` 블록 2개 삽입)
- 방식: DB 만 변경 (FE 무변경)

## AS-IS 확인 (사용자 지시 — 보완 전 AS-IS 복사 실재 확인)
- AS-IS DB 165.244.95.223 / LGCE_SCMDEV `DMF0082_GET_MAIN_DATA` (modify 2026-07-22 14:28) 원문 직접 조회
- `'MKT_FCST_PP' AS MEASURE` 6곳 — **MSSQL 중첩 블록주석 반영 판정**

| 분기 | 기준일 이전 P(`DM_PLN_MKT_FCST_RESULT*`) | 기준일 이후 P(`DM_PLN_CFM_MKT_DEMAND_PLAN*`, `A.MEASURE='MKT_FCST' AND B.MEASURE='MKT_FCST_PP'`) |
|---|---|---|
| Current (L1491~) | 주석 (L1717) | **실행** (L1798~1895) |
| MF (L2659~) | 주석 (L2899 "2025.07.18 주석 처리") | **실행** (L3008~3108) |
| SF (L4246~) | 주석 (L4486) | **실행** (L4595~4675) |

→ AS-IS 는 Current·MF·SF 모두 계획구간 MKT_FCST 를 MKT_FCST_PP 로 복사 적재한다. TO-BE 는 SF(L2762~)에만 존재.

## 변경
- SF 분기 MKT_FCST_PP 복사 블록(81·82 `DM_PLN_MKT_FCST_C` / 40 `DM_PLN_CFM_MKT_DEMAND_PLAN_C`)을 원본으로
  - **Current**: 원장 비 `_C`(`DM_PLN_MKT_FCST` / `DM_PLN_CFM_MKT_DEMAND_PLAN` / `GT_DMF0082_T_LAST_DATA_SETUP_FCST`) · 버전 조인 제거 · `'Current'`/NULL → Current '계획구간 수요' 블록 바로 뒤 삽입 (117줄)
  - **MF**: 버전 조건 `'SF%'` → `'MF%'` → MF '계획구간 수요 (Cutoff)' 블록 바로 뒤 삽입 (119줄)
- DB: 59.19.252.148:2521/ZIOUI1 · 계정 SCM_MGR · 착수 기준본 LAST_DDL 2026-10-15 13:58:28 · FRESH-GATE 통과 후 적용 · VALID / 오류 0

## 검증 (40 · 20260901~20270228 · ADMIN 그룹, 조회 SP 실호출 — 조회 전용)
| 항목 | 수정 전 | 수정 후 |
|---|---|---|
| Current MKT_FCST_PP 행 (minyonglee1 — 화면 설정 MKT_FCST_PP 보유) | 29 | **309** |
| Current MKT_FCST 행 (SCM_MGR — MKT_FCST 보유) | 304 | 304 (불변) |
| Current 계획구간(20261012~, 일자 310칸) 값 비교 PP ↔ MKT_FCST | — | **키 302 = 302 · 전 칸 값 일치 · 차이 0** |
| 다른 메저(SCM_FCST 305 · RTF_SYS_RP 221 · LOC/KRW/USD 2157) | — | 불변 |
| MF_W_20260921_V001 MKT_FCST_PP | 0 | 1 (= 같은 버전 MKT_FCST 1) |

- 총 행 수 차이(PP 309 ↔ MKT_FCST 304)는 **실적 구간(2026-09-06) 행**에서만 난다 — PP 에만 5건 / MKT_FCST 에만 1건(Honda MPCHODMPP21E). 실적 arm 이 MKT_FCST 와 MKT_FCST_PP 를 서로 다른 실적 원천으로 매핑하는 기존 동작이며 이번 복사(계획구간)와 무관. GAP 문서의 AS-IS 330=330 대비 실적 구간 매핑 파리티는 별도 확인 필요.

## 이관 패키지
- `_artifacts/_deploy_packages/DMF0082_GAP445_MKTFCSTPP_CLOUD_20261015/` — 사내 리허설(14:21) 90 → 99 → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10 전 단계 기대대로 · 99 원복 == 수정 전 원문 · 10 재적용 == 적용본 (원문 전체 일치) · 최종 VALID
- 참고: 생성 시점 사내 BODY LAST_DDL 2026-10-15 14:12:14 — 원문 전체가 본 적용본과 동일함을 대조로 확인(내용 변경 없는 재컴파일)
