# DMF0021 Sales Plan — 81 사업부 RTF 수정기능 추가 상세·단위테스트 개발참조

> **원천 파일**: `Doc/참고자료/Sales Plan 화면 RTF 수정기능 추가 상세문서_수정내용+단위테스트 1.xlsx`
> **시트(9)**: `변경작업` / `TEST CASE`(128건) / `TEST 결과` / `PI님확인` / `사후점검리스트` / `월요일 배포후 확인작업` / `화요일` / `수요일` / `금요일`
> **CSR**: E20260331-000648 — [자동차 SCM] 자동차사업부 '기준수요' 기능 중 **'RTF 수정기능'만 우선 적용** (고객 권수영 / 담당 배지선)
> **화면**: DMF0021 / AS-IS `DMF0021_SalesPlan` / TO-BE slug `sales-plan` ([[project_dmf0021_sales_plan_status]] 구현 완료)
> **연계 회의록**: [`ui_analysis_meet/DMF0021_SalesPlan_회의참고_20260709.md`](../ui_analysis_meet/DMF0021_SalesPlan_회의참고_20260709.md) (SCP 플래너 RTF 수정 / 컷오프 전만 수정)
> **추출 원칙**: 원문 셀 그대로 보존. 스크린샷·TEST 결과 로그(5,065행)는 원천 xlsx 참조.

---

## 1. 핵심 요구사항 (한 줄 요약)

**81 사업부(및 81_JV)** 에서 Sales Plan 화면의 **RTF[R+P] 메져를 SCP Planner 권한이 수정**할 수 있도록 추가하되,
- **컷오프 타이밍 규칙**: 당주 월요일 이후 **Sales Plan CUTOFF 데이터가 존재하는 경우에만** 수정 RTF 적용, 그 이전에는 SCP RTF 적용.
- **FCST Type = ETC** 데이터는 별도 권한 체계(DM 계열)로만 수정.

---

## 2. 변경작업 목록 (`변경작업` 시트 — 12건)

| # | 유형 | 프로그램 소스 | 수정 내역 |
|---|---|---|---|
| 1 | CS | `DMF0021_SalesPlan.cs` | 81 사업부도 EDIT 되도록 수정. **SalesAMT LOC 메져 수정 시 fcst_type 이 ETC 인 데이터만** 수정되도록 보완 |
| 2 | SP | `DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL` | **Validation 추가, 테이블 분기 처리, RTF[R+P] 메져 수정 시 삭제 사업부에 81 추가** |
| 3 | SP | `PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE` | ⭐ **당주 월요일 이후 SALES PLAN CUTOFF 데이터 존재 시에만 수정 RTF 적용, 그 이전엔 SCP RTF 적용** |
| 4 | SP | `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` | ⭐ 동일 (당주 월요일 이후 CUTOFF 존재 시 수정 RTF, 이전엔 SCP RTF) |
| 5 | SP | `DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx` | 81 도 RTF[R+P] 메져 수정 가능하도록 수정. **권한내역 수정, 화면 조회 수정** |
| 6~12 | JOB | `PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81` 외 6종 | **수요일 롤링 JOB 시각 이동** (81 08시→10시 / 81_UC 14시→15시 / 81_HM 08:10→10:10 / 81_ST 08:15→10:15 / 81_HD 14:30→15:30 / 81_HG 14:30→15:30). 기존 시각 사용안함 처리 + 신규 시각 추가 |

> JOB 6종 = `_81`, `_81_UC`, `_81_HM`, `_81_ST`, `_81_HD`, `_81_HG`. (변경작업 #6~#12, CSR 주석·소스수정내역 동반)

---

## 3. ⭐ 권한 × Fcst Type 수정 매트릭스 (배포후 확인·TEST CASE 종합)

> 축: 메져 `RTF[R+P]` vs `FCST TYPE = ETC` 행 / 사업부 81·81_JV(UC/HM/ST/HD/HG) · 40 · 82

| 권한 | RTF[R+P] 메져 | FCST TYPE = ETC 데이터 |
|---|---|---|
| **SCP Planner** | ✅ 수정 가능 (81·81_JV·40) / ❌ 82 불가 | ❌ 수정 불가 |
| **SCM PI Admin** | ✅ 수정 가능 | ✅ 수정 가능 (82 는 ETC 만) |
| **DM ADMIN** | ❌ 수정 불가 | ✅ ETC 만 수정 |
| **DM Planner** | ❌ 수정 불가 | ✅ ETC 만 수정 |

핵심 규칙:
- **RTF[R+P] 수정 주체 = SCP Planner / SCM PI Admin**. DM 계열(ADMIN/Planner)은 RTF 불가·**ETC 만**.
- **82 사업부**: RTF[R+P] 메져 자체가 없음(노출 X) → SCP Planner 는 수정대상 0. ETC 는 PI Admin/DM 계열이 수정.
- **40 사업부** = 회귀(기존 동작 유지) 기준.

---

## 4. ⭐ 컷오프 타이밍 RTF 적용 규칙 (TEST CASE 33~104 핵심)

| 상황 | 결과 |
|---|---|
| **당주 월요일 이후, Sales Plan CUTOFF 없이** RTF[R+P] 저장 | 저장 진행됨 (정상) |
| **Sales Plan CUTOFF 1회 후** SCP Planner RTF[R+P] 수정·저장 | 저장 데이터로 **Sales Plan / MKT FCST / MKT FCST Cutoff 데이터가 수정 RTF 로 변경**되고, **Sales Plan Cutoff 데이터는 변경되지 않음** |
| **Sales Plan 데이터 수정 없이 BALANCE 실행** (`PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE`) | **MKT FCST RTF = SCP RTF 동일** (마지막 RTF 반영) — Sales Plan/MKT FCST/MKT FCST Cutoff **모두 변경 안 됨** |
| **Sales Plan 수정 후 BALANCE 실행** | 수정한 데이터가 **덮이지 않음**(변경 안 됨) — 수정 RTF 보존 |

> BALANCE 검증 쿼리(원천): `SCP_PLN_RTF_ALLOCATION_V`(ALLOCATION_QTY) FULL OUTER JOIN `DM_PLN_MKT_FCST`(MEASURE='RTF_SYS_RP') 8키 조인 → `ALLOCATION_QTY <> QTY` 0건이면 일치. (PLAN_TYPE='FN', YYYYMMDD >= 기준일)

---

## 5. Waterfall 메져 노출 (TEST CASE 83~90 / 월요일 배포후)

- 신규 메져 **`RTF_PR`** (배포후 확인 시트는 `RTF_PR` / `RTF_BALANCE` 병기) 이 **Sales Plan 화면 + Sales Plan Waterfall 화면**에 노출.
- **81·81_JV·40 = 노출 O** / **82 = 노출 X** (RTF_PR·RTF_BALANCE 없음).

---

## 6. Sales Plan CUTOFF 스케줄 (수요일/금요일 — 사후점검·요일 시트)

> 81/81_JV 는 **SCP FN 엔진 완료 → Sales Plan CUTOFF** 순으로 수요일 진행. JOB 시각 이동(§2 #6~12)의 실측 근거.

| 사업부 | 수요일 오전(변경 전 미수행 확인) | 수요일 정상 수행 시각 |
|---|---|---|
| 81 | 08시 미수행 | **10시** |
| 81_HM | 08:10 미수행 | **10:10** |
| 81_ST | 08:15 미수행 | **10:15** |
| 81_UC | 14시 미수행 | **15:00** |
| 81_HG | 14시 미수행 | **15:30** |
| 81_HD | 14시 미수행 | **15:30** |

- **금요일**: 81 계열 Sales Plan CUTOFF 15:00~15:30 대 수행 + 화면 데이터 수정 가능여부 확인.
- 운영 예외: 엔진 완료 후 CUTOFF 미수행 시 **DM 운영자 수동 CUTOFF 후 SCP 운영자(유명훈 차장) 확인요청**.
- 실측 특이: 81_ST 는 "저장 가능 상태이나 **Price 가 없어 저장 불가**" (수요일 시트).

---

## 7. 단위테스트 구성 (`TEST CASE` 시트 — 128건 UT_DM_IF_00001~00128)

| 그룹(테스트명) | 건수 | 검증 포인트 |
|---|---:|---|
| 권한별 수정컬럼 확인 (SCP Planner / SCM PI Admin / DM ADMIN / DM Planner) | 각 8 | §3 매트릭스 (사업부 8종 × 권한 4종) |
| Sales Plan Cutoff 없이 RTF[R+P] 저장 | 14 | 당주 월요일 이후 CUTOFF 없이 저장 진행 |
| Sales Plan Cutoff 없이 FCST TYPE ETC 저장 | 16 | ETC 저장 진행(회귀) |
| Sales Plan Cutoff 정상 동작 | 6 | 수/금 스케줄 수행(§6) |
| Sales Plan Cutoff 1회 후 SCP Planner 저장 | 11+3 | §4 (Cutoff 불변, SP/MKT FCST 변경) — WEEKLY/MONTHLY 분리 |
| 마지막 Cutoff 완료 후 RTF / ETC 수정여부 | 7+8 | 최종 컷오프 후 편집 가능성 |
| Waterfall 메져(RTF_PR) 노출 | 8 | §5 |
| BALANCE 실행 후 데이터 변경 여부 | 6+8 | §4 (수정분 보존 / 미수정분 SCP RTF 일치) |
| MKT FCST 화면 정상 저장 | 6+2 | 회귀 |

> 결과 상태(정상/회귀) 표기: (정상)=신규 대상 / (회귀)=기존 동작 유지 확인. 실행절차·예상결과 전문은 원천 `TEST CASE` 시트, 실행 로그는 `TEST 결과`(5,065행) 참조.

---

## 8. TO-BE 개발 시 확정/주의 (개발참조 체크포인트)

1. **RTF 수정 게이트 = SCP Planner/SCM PI Admin + 컷오프 타이밍** — 당주 월요일 이후 CUTOFF 존재 시에만 수정 RTF 반영, 이전엔 SCP RTF. (BALANCE SP 2종의 분기 로직 = TO-BE 조회/저장 계약의 근거) ([[project_dmf0021_sales_plan_status]] "컷오프 전만 수정" 정합).
2. **ETC 편집 분리** — SalesAMT LOC 메져 수정 시 **fcst_type='ETC' 행만** 대상(CS `DMF0021_SalesPlan.cs` #1). RTF 메져와 권한 체계 다름.
3. **삭제 사업부에 81 추가** — SAVE SP(`DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL`) RTF[R+P] 수정 시 삭제 대상에 81 포함(테이블 분기 + Validation).
4. **82 = RTF_PR/RTF_BALANCE 메져 미노출** — TO-BE SHEET_MEASURE/CMBO 에서 82 토큰 배제 확인 (하드코딩 금지, 메타 기준 — hook #113).
5. **CUTOFF 는 Sales Plan Cutoff 데이터 불변** — RTF 수정이 계획/실적(MKT FCST·MKT FCST Cutoff)만 갱신, Sales Plan Cutoff 스냅샷은 보존.
6. **JOB/배치 시각 이동은 AS-IS 운영 사항** — TO-BE 화면 개발과 직접 무관하나, CUTOFF 존재여부 판정 로직이 화면 편집권한 결과를 좌우하므로 계보 이해 필요.
7. **RESULT_MEASURE·PIVOT 함정 주의** — RTF_SYS_RP 등 measure 매핑은 [[feedback_sp_result_measure_mapping_and_pivot_collapse]] 참조.
