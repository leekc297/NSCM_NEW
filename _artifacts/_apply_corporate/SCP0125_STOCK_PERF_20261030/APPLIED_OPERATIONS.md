# SCP0125 Stock 탭 조회 속도 보완 — 사내 적용 기록 (2026-10-30)

- 대상 DB: 사내 ZIOUI1 (59.19.252.148:2521, 접속 system · CURRENT_SCHEMA=SCM_MGR)
- 대상 객체: `SCM_MGR.PKG_SCP0125` PACKAGE BODY (SPEC 무변경)
- 착수 원문: ALL_SOURCE 조회 · LAST_DDL 2026-10-23 12:04:35 · VALID → `PKG_SCP0125_BODY_BEFORE_LASTDDL_20261023_120435.sql`
- FRESH-GATE: 적용 직전 재조회 = 착수 원문과 동일(cmp) 확인
- 적용: 2026-10-30 17:47:32 시작 → LAST_DDL 2026-10-30 17:47:37 · VALID · ALL_ERRORS 0
- 적용 후 재조회 원문 == `PKG_SCP0125_BODY_AFTER.sql` (cmp 일치)

## 1. 측정 (hook #129 §0.4 / §0.5)

| 단계 | 근거 |
|---|---|
| 호출별 시간 | SCM_COM_SQL_LOG 실사용 기록: `P_SCP0125_GET_STOCK_ADJ` 81/20260831 6.32s · 82/20260824 4.43s · 10-19 11.85s 등 — 2초 이상 = 튜닝 대상 |
| 문장별 시간 | `prof.py` (V$SQL PROGRAM_ID=PKG_SCP0125 실행 전후 차분). 81/20260831: `GT_0125_INVENTORY_AGE` 적재 3.86~6.92s · `GT_0125_INTRANSIT_V` 1.35s · `GT_0125_OCV_EXCEPT` 0.87s |
| 병목 라인 | ASH: INVENTORY_AGE 적재 = 뷰 `SCM_DNM_STOCK_AGING_V` UNION-ALL 라인 ON CPU. 81 사업부 7일치 756,089행을 읽어 사이트별 마지막 마감일 행 4,129행만 남김 |

## 2. 보완 (1-b 순위: 소비 집합 선행축소)

`P_LOAD_STOCK` (Stock · Stock(UC) 공통 적재) — `GT_0125_INVENTORY_AGE` 적재 직전에 읽기 시작일 `V_AGE_FROM_DATE` 산출 후 WHERE 에 `A.ORG_CUTOFF_DATE >= V_AGE_FROM_DATE` 추가.

- 근거: 적재는 사이트별 마지막 마감일 행만 남긴다(`IA.CUTOFF_DATE = IA.MAX_CUTOFF_DATE`). 모든 사이트의 마지막 마감일 중 가장 이른 날 이전 행은 결과에 들 수 없고, 빼도 어느 사이트의 마지막 날도 변하지 않는다 → 결과 불변.
- 시작일 = MIN( 원장 `SCM_AGING_STOCK_H` 사이트별 MAX(CUTOFF_DATE) , ESS 가상 line 사이트 중 원장에 이 사업부 행이 없는 사이트의 뷰 MAX(ORG_CUTOFF_DATE) ). 대상 없음 = 기존 범위(V_D_CUTOFF_DAY-6) 유지.
- 뷰 첫 갈래는 원장 행이 바깥 조인만으로 그대로 나오므로 원장 사이트별 마지막 날 ≤ 묶음 마지막 날. 둘째 갈래(ESS 가상 line, `FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP`)는 원장에 없는 사이트로 들어올 수 있어 그 사이트만 뷰에서 직접 구함.
- 권한: SCM_MGR → FP_MGR.SCM_AGING_STOCK_H SELECT 보유(DBA_TAB_PRIVS 실측) · 시노님 SCM_MGR.SCM_AGING_STOCK_H 실존.
- 변경 diff: `PKG_SCP0125_BODY.diff` (76줄 · 3지점 · `make_patch.py` 고유 매칭 assert)

## 3. 동등성·시간 검증

`matrix.py` — 사업부 8종(81·82·40·81_HD·81_HG·81_HM·81_ST·83) × 기준일 6종 + 81_UC(UC SP) 6종 + Model 검색 2건 = 56건, 결과 행 전체(컬럼·값·순서) 비교.

- **56건 전부 SAME** (`matrix_compare.txt`) · DIFF 0
- SP 합계 157.7s → 126.2s. 81: 6.62→3.96s(20260831) · 7.32→4.54s(20260907) · 82: 4.88→2.87s · 4.63→2.98s
- HTTP(화면 경로 `/SCP0125/stock/SEARCH/call-proc`, 2회 반복 안정값): 81/20260831 3.56~3.75s (적용 전 로그 6.32s) · 82/20260824 2.95~3.09s (적용 전 4.43s) · 40 2.12~2.25s · 81_UC 1.88~1.91s

## 4. 남은 병목 (이번 미적용 — 사용자 결정 필요)

| 문장 | 시간 | 원인 | 왜 PKG 수정으로 안 되나 | 제안 |
|---|---|---|---|---|
| `GT_0125_INTRANSIT_V` 적재 (공용 뷰 `SCM_DNM_INTRANSIT_V`) | 1.3s 고정 (모든 사업부·결과 0건이어도) | 사업부·기준일 조건이 뷰 안 UNION 으로 전달되지 않아 전 기간 I/C 47K행 + BOD 조인을 매번 계산. VMI 갈래의 `ROW_NUMBER() OVER (PARTITION BY 'V' …)` 가 조건 전달을 막음 | I/C 분리 조회도 0.8+1.1s 로 실측 무효. 뷰 수정은 공용 객체(타 호출처) 영향 | 공용 뷰 변경(VMI 번호 규칙 결정 필요) 또는 이 화면 전용 I/C 뷰 신설 — 승인 시 진행 |
| `GT_0125_OCV_EXCEPT` 적재 (81 만) | 0.8s | `SCM_MST_MODEL_BOM` 4.57M행 FULL — 조인키 (PLANT_ID, PARENT_ITEM_ID) 인덱스 없음. 기존 IX01(DIVISION,PLANT,MODEL) 은 WA00 공장만 125만 행이라 무효 | 탈 인덱스 없음(#129 4순위) | 인덱스 (PLANT_ID, PARENT_ITEM_ID) 신설 — 적재 배치 테이블이라 DML 부하 확인 후 승인 시 |

## 5. 원복

`PKG_SCP0125_BODY_BEFORE_LASTDDL_20261023_120435.sql` 를 `CREATE OR REPLACE ` 접두로 컴파일(`apply.py` 와 같은 방식).

## 6. 클라우드 이관

`_artifacts/_deploy_packages/SCP0125_CLOUD_DB_MOD_20261030_1803/` (cloud_pkg.py 1.0.0 · 사내 리허설 OK · 경고 0). 00_PRECHECK 가 `SCM_AGING_STOCK_H` 시노님·`FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP` 존재를 확인한다 — 클라우드에서 시노님의 FP_MGR SELECT 권한도 확인 필요.
