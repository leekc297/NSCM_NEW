# DMF0044 Sales Reports — 데이터 원천(저장/조회 테이블) 개발참조

> **원천 파일**: `Doc/참고자료/Sales Report 데이터 원천.xlsx` (2시트: `저장 테이블 정보` / `조회 테이블 정보`, 스크린샷 이미지 5)
> **화면**: DMF0044 / AS-IS `DMF0044_Sales_Reports` (`GSCM.DM.Plan.UIL`) / TO-BE slug `sales-reports`(미구현)
> **연계 회의록**: [`ui_analysis_meet/DMF0044_SalesReports_회의참고_20260714.md`](../ui_analysis_meet/DMF0044_SalesReports_회의참고_20260714.md) — 본 문서는 그 회의의 "카피=버전별 컷오프 환율 / ALL=컷오프+ETC 조인" 규칙을 **테이블 레벨로 구체화**한 것.
> **추출 원칙**: 원문 셀 그대로 보존. 이미지(스크린샷)는 원천 xlsx 참조.

---

## 1. 개요 — Version Type 2종

Sales Report 는 **버전(Version) 단위**로 데이터를 적재하며, 생성 방식이 2가지다.

| Version Type | 방식 | 용도 |
|---|---|---|
| `SP_W` | **Version Create** (신규 생성) | Sales Plan 컷오프 기준 신규 리포트 버전 생성 |
| `REPORT_SP_W` | **Version Copy** (기존 버전 복제) | 선택 버전을 복제하여 새 리포트 버전 채번 |

> ⚠ **공통 규칙 (전 케이스 반복 명시)**: ETC 데이터 = `DM_PLN_SALES_ETC_REPORT_C` (**가장 최신 버전의 ETC 데이터**) = **[Demand > Demand Plan > ETC Sales Reports(DMF0049)] 화면의 데이터**.
> **※ Sales Plan(DMF0021) 화면에서 입력하는 ETC 데이터는 포함하지 않는다.** ← 3개 케이스 모두 동일 주석.

---

## 2. 저장 테이블 정보 (`저장 테이블 정보` 시트)

### 2-1. Type `SP_W` — Version Create

| 구분 | 테이블 | 비고 |
|---|---|---|
| 실적기준일 | — | **당주 월요일 기준 (CUTOFF 버전기준)** |
| 계획구간 | `DM_PLN_SALES_PLAN_C` | |
| 실적구간 | `DM_PLN_SALES_PLAN_RESULT_C` | |
| ETC데이터 | `DM_PLN_SALES_ETC_REPORT_C` | 가장 최신 버전의 ETC 데이터 (DMF0049 화면 데이터, Sales Plan 입력 ETC 제외) |

### 2-2. Type `REPORT_SP_W` — Version Copy

**Case 1. 실적 기준일을 설정하는 경우**
> (ETC의 실적월 설정: **말일자로 설정하는 경우에는 해당 월, 아니면 직전 월**)

| 구분 | 테이블 | 비고 |
|---|---|---|
| 계획구간 | `DM_PLN_SALES_PLAN_REPORT_C` | |
| 실적구간 | `DM_PLN_SALES_PLAN_RESULT` | ⚠ Create(`_C`)와 달리 **`_C` 없는 원본 실적 테이블** |
| ETC데이터 | `DM_PLN_SALES_ETC_REPORT_C` | 가장 최신 버전 ETC (DMF0049, Sales Plan 입력 ETC 제외) |

**Case 2. 실적 기준일을 설정하지 않은 경우**

| 구분 | 테이블 | 비고 |
|---|---|---|
| 계획구간 | `DM_PLN_SALES_PLAN_REPORT_C` | |
| 실적구간 | **(없음)** | 실적 기준일 미설정 시 실적구간 미적재 |
| ETC데이터 | `DM_PLN_SALES_ETC_REPORT_C` | 가장 최신 버전 ETC (DMF0049, Sales Plan 입력 ETC 제외) |

---

## 3. 조회 테이블 정보 (`조회 테이블 정보` 시트)

> 원천 시트는 테이블명 헤더 + 각 구간 화면 스크린샷(이미지 5)으로 구성. **조회에 사용되는 테이블 2종**:

| # | 테이블 | 성격 |
|---|---|---|
| 1 | `DM_PLN_SALES_PLAN_REPORT_C` | 계획(REPORT) 구간 조회 |
| 2 | `DM_PLN_SALES_ETC_REPORT_C` | ETC 구간 조회 (최신 버전) |

> ※ 원천 셀 순서: `DM_PLN_SALES_PLAN_REPORT_C` → `DM_PLN_SALES_ETC_REPORT_C` → `DM_PLN_SALES_ETC_REPORT_C` → `DM_PLN_SALES_PLAN_REPORT_C` (구간별 반복 — 상세 화면 매핑은 xlsx 스크린샷 대조 필요).

---

## 4. TO-BE 개발 시 확정/주의 (개발참조 체크포인트)

1. **저장 SP 는 Version Type(`SP_W` / `REPORT_SP_W`) 분기 필수** — Create(계획=`DM_PLN_SALES_PLAN_C`, 실적=`_RESULT_C`) vs Copy(계획=`DM_PLN_SALES_PLAN_REPORT_C`, 실적=`_RESULT`).
2. **실적 기준일 설정 여부가 실적구간 적재를 좌우** — 미설정 시 실적구간 테이블 미포함 (Case 2). 설정 시 ETC 실적월 규칙(말일=해당월 / 그외=직전월) 적용.
3. **ETC 원천은 항상 `DM_PLN_SALES_ETC_REPORT_C`(최신 버전)** = DMF0049 데이터. **Sales Plan(DMF0021) 입력 ETC 는 절대 포함 금지** — 조인/union 시 원천 구분 명확히.
4. **환율**: 회의 확정(카피 시 최신 환율 아님 / 버전별 컷오프 시점 환율 동반) — 버전 헤더 환율 스냅샷과 위 테이블 적재를 함께 검증 ([회의참고](../ui_analysis_meet/DMF0044_SalesReports_회의참고_20260714.md) ㉮-4).
5. **`_C` suffix 규약 주의**: 계획/실적/ETC 대부분 `_C`(컷오프 스냅샷) 테이블이나, Copy Case 1 의 실적구간만 `DM_PLN_SALES_PLAN_RESULT`(무 `_C`) — 오타 아님, 원천 명시.

---

## 부록 — 원천 셀 전문 (누락 0)

```
[저장 테이블 정보]
Type: SP_W / Version Create
  실적기준일: 당주 월요일 기준(CUTOFF 버전기준)
  계획구간:  DM_PLN_SALES_PLAN_C
  실적구간:  DM_PLN_SALES_PLAN_RESULT_C
  ETC데이터: DM_PLN_SALES_ETC_REPORT_C ( 가장 최신 버전의 ETC 데이터 )
             [Demand > Demand Plan > ETC Sales Reports 화면의 데이터]
             ※ Sales Plan 화면에서 입력하는 ETC 데이터는 포함하지 않는다

Type: REPORT_SP_W / Version Copy
  1. 실적 기준일을 설정하는 경우 (ETC의 실적월 설정: 말일자→해당 월, 아니면 직전 월)
     계획구간:  DM_PLN_SALES_PLAN_REPORT_C
     실적구간:  DM_PLN_SALES_PLAN_RESULT
     ETC데이터: DM_PLN_SALES_ETC_REPORT_C ( 가장 최신 버전의 ETC 데이터 ) [DMF0049]
  2. 실적 기준일을 설정하지 않은경우
     계획구간:  DM_PLN_SALES_PLAN_REPORT_C
     ETC데이터: DM_PLN_SALES_ETC_REPORT_C ( 가장 최신 버전의 ETC 데이터 ) [DMF0049]

[조회 테이블 정보]
  테이블: DM_PLN_SALES_PLAN_REPORT_C
  테이블: DM_PLN_SALES_ETC_REPORT_C
  테이블: DM_PLN_SALES_ETC_REPORT_C
  테이블: DM_PLN_SALES_PLAN_REPORT_C
```
