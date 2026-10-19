# DMF0082_MFPERF_20261015 — 과거 버전(MF/SF/SP) 조회 속도 개선 · 사내 ZIOUI1 적용 기록

- 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA` 컷오프 최종수정자 적재 3문장 (마커 `[MFPERF 2026-10-15]` 3곳)
- 방식: DB 만 변경 (FE 무변경) · hook #129 순서 준수

## 0-a / 0-b 병목 실측 (ASH)
| 측정 | 조건 | 시간 | 병목 SQL (ASH 비중) |
|---|---|---|---|
| 40 MF | MF_W_20260824_V001 · 2026-08-03~12-31 · SCM_MGR · SID 715 | **575.6초** | `br0qzg41fkcrf` INSERT GT_DMF0082_T_LAST_DATA_SETUP_FCST_C **73.4%** · `4gsksgxj0ft42` …_PRICE_C **26.3%** |
| 81 MF | MF_W_20260930_V001 · 2026-10-01~12-31 · minyonglee1 · SID 739 | **532.6초** | `g2f236ssg1rpu` INSERT GT_DMF0082_T_LAST_DATA_SETUP_FCST_C (81 arm) **≈99%** |
- 플랜(공통): `MERGE JOIN CARTESIAN`(GT_DMF0082_T_VERSION × GT_DMF0082_TEMP_SITE_ITEM, 추정 58~81행) → `NESTED LOOPS` → **`PARTITION RANGE ALL`** + 원장 인덱스 RANGE SCAN — 전 시간 ON CPU · 플랜 라인 11.
  40 수요 누적 buffer_gets 7억 3,660만 / 40 판가 3억 1,196만.
- 원인: 원장 3개(DM_PLN_CFM_MKT_DEMAND_PLAN_C 17파티션 · DM_PLN_CFM_SELLING_PRICE_C 14 · DM_PLN_MKT_FCST_C 109, 4,012만행)가 `CUTOFF_YYYYMMDD_DATE` RANGE 파티션인데 문장에 파티션 키 조건이 없음.

## #129 순위 검토
| 순위 | 검토 |
|---|---|
| 1 SELECT 함수·스칼라 서브쿼리 | 해당 없음 (MAX 집계만) |
| 1-b 소비 집합 선행축소 | 해당 없음 (GTT 는 이미 선택 조건으로 축소) |
| 2 테이블 함수 | 해당 없음 |
| **3 구문 변경(인덱스/파티션 키 사용)** | **적용** — 파티션 키 `CUTOFF_YYYYMMDD_DATE` 범위 조건 추가 |
| 4 인덱스 추가 · 5 힌트 | 불필요 (3순위로 목표 달성) |

## 변경 (3문장에 2줄씩)
```
AND A.CUTOFF_YYYYMMDD_DATE BETWEEN TO_DATE(CASE WHEN V_CUTOFF_FROM='00000000' THEN '19000101' ELSE V_CUTOFF_FROM END,'YYYYMMDD')
                              AND TO_DATE(CASE WHEN V_CUTOFF_TO  ='99999999' THEN '99991231' ELSE V_CUTOFF_TO   END,'YYYYMMDD')
```
- `V_CUTOFF_FROM/TO` = 선택 버전 날짜의 MIN/MAX (기존 변수, 81 판가 문장이 이미 같은 목적으로 사용).
- 행 무변화 근거(데이터 실측): 버전당 컷오프 1개 · `CUTOFF_YYYYMMDD_DATE = TO_DATE(CUTOFF_YYYYMMDD) = 버전일` — 불일치 0
  (40 수요 317 · 40 판가 74 · 81/82 수요 766 (사업부,버전) 묶음 — 패키지 00_PRECHECK L4 실측). 버전 마스터에 없는 묶음은 원래 버전 GTT 와 조인되지 않음.
- DB: 59.19.252.148:2521/ZIOUI1 · 계정 SCM_MGR · FRESH-GATE 2회(40 → 81) 통과 후 적용 · VALID / 오류 0

## 검증 (조회 SP 실호출, 같은 조건)
| 조회 | 수정 전 | 수정 후 | 결과 |
|---|---|---|---|
| 40 MF_W_20260824 (08-03~12-31) | 575.6초 | **3.5초** | 2,090행 · 키·첫 일자 수정 전과 동일 |
| 40 SF_W_20260824 | 486.6초 | **3.5초** | 동일 |
| 40 SP_W_20260825 | 129.3초 | **2.6초** | 1,228행 동일 |
| 81 MF_W_20260930 (10-01~12-31) | 532.6초 | **3.8초** | 627행 동일 |

## 이관 패키지
- `_artifacts/_deploy_packages/DMF0082_MFPERF_CUTOFFPRUNE_CLOUD_20261015/` — 시뮬레이터 통과 · 사내 리허설(15:52~15:53) 전 단계 기대대로 · 99 원복 == 수정 전 원문 · 10 재적용 == 적용본 (원문 전체 일치)
