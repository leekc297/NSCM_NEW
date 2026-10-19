# DMF0044 BP×Cutoff 「입력값 2배」 정정 — 클라우드 이관 패키지 (2026-09-11)

| 항목 | 값 |
|---|---|
| 신고 | BP TYPE + Cutoff Data 에서 `Business_Plan` 입력 시 재조회하면 입력값의 2배 (3건 중 1건꼴) |
| 원장 | `REQ:CHAT-20260911-W66` |
| 마커 | `E20260911-CELLPRODKEY` (BODY 50 / SPEC 1) |
| 사내 적용 | ❌ **미적용** — `GT_0044_RESULTS_MST_C` ORA-14450(타 사용자 DBeaver 세션 다수 점유) |
| 컴파일 검증 | ❌ **미수행** (GTT 컬럼 선행 필요) |

## ⛔ 단독 적용 금지 — 반드시 읽어 주세요

이 패키지만 적용하면 **DMF0044 Cutoff 저장이 전면 실패**합니다.
저장 SP `P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF` 의 IN 파라미터가 **23 → 25** 로 늘어나는데,
호출 계약(`SCM_ADM_PROC_M`)과 FE 가 아직 그 2개를 보내지 않기 때문입니다.

**세트로 함께 적용해야 하는 미완 산출물 (본 패키지에 없음)**
1. `SCM_ADM_PROC_M` — `DMF0044` / `MDF Reports` / `SAVE_CF` 파라미터 **2행 추가**(`CELL_PROD_SITE`, `PLANT_SITE_ID`)
2. FE — `sales-reports.types.ts` · `buildCutoffSaveRows` · `procedures.d.ts` · 그리드 컬럼(`CELL_PROD_SITE_CD`)

## 실행 순서 (순서 의존 — 반드시 지킬 것)

| # | 파일 | 비고 |
|---:|---|---|
| 1 | `01_GTT_ALTER.sql` | **BODY 컴파일의 전제.** GTT 를 쓰는 세션이 있으면 ORA-14450 → 해당 세션 종료 후 재시도 |
| 2 | `02_PKG_DMF0044_SPEC.sql` | SPEC 먼저 (BODY 가 일시 INVALID 가 됨 — 정상) |
| 3 | `03_PKG_DMF0044_BODY.sql` | 적용 후 VALID / ERRORS 0 확인 |

> ⚠ 2번만 적용하고 3번을 못 하면 패키지가 INVALID 상태로 남아 **화면 전체가 멈춥니다.** 2·3은 연속 실행하세요.

원복 = `97_ROLLBACK_BODY.sql` → `98_ROLLBACK_SPEC.sql` → `99_ROLLBACK_GTT.sql` (역순)

## 적용 후 검증 SQL

```sql
-- ① 컴파일 상태
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0044';
SELECT COUNT(*) ERRS FROM USER_ERRORS WHERE NAME='PKG_DMF0044';      -- 기대 0
-- ② 마커
SELECT COUNT(*) MK FROM USER_SOURCE WHERE NAME='PKG_DMF0044' AND TEXT LIKE '%E20260911-CELLPRODKEY%';  -- 기대 51
-- ③ GTT 컬럼
SELECT TABLE_NAME, COLUMN_NAME FROM USER_TAB_COLUMNS
 WHERE (TABLE_NAME='GT_0044_RESULTS_MST_C' AND COLUMN_NAME IN ('CELL_PROD_SITE','PLANT_SITE_ID'))
    OR (TABLE_NAME='GT_F044_T' AND COLUMN_NAME='CELL_PROD_SITE_CD');  -- 기대 3행
```

## 원인 (실측 요약)

원장 `DM_PLN_SALES_PLAN_REPORT_C` 의 **PK 는 16컬럼**인데,

| 축 | 입도 | 문제 |
|---|---|---|
| 조회 표시 | `CELL_PROD_SITE` 를 lookup 번역값 `NVL(LK4.ATTRIBUTE1,'')` 로 GROUP BY + `SUM(QTY)` | `SP_CELL_PROD_SITE` lookup 에 `A01~A06` 미등록 → 전부 `''` 로 접혀 **여러 원장 행이 한 셀로 합산** |
| 저장 매칭 | **14컬럼** (`CELL_PROD_SITE·FCST_TYPE·INCOTERMS·PLANT_SITE_ID` 누락) | 접힌 **모든 행에 같은 값**을 기록 |

→ 2행이 합쳐 보이던 셀에 V 를 입력하면 두 행 모두 V → 재조회 SUM = **2V**

실사례: `R_B_20260814_V001 / 40 / AMDMO0001A / Isuzu_TH_SAP / 20250101 / USD` → `A01`=0.0, `A02`=276.0

**AS-IS 대조**(`LESDFPSTO1C01/LGCE_SCMDEV` 직접 접속): 저장 SP JOIN 키가 **AS-IS 와 동일한 14컬럼** → 변환 결함 아님, AS-IS 계승 구조. lookup 도 AS-IS 51행·A01~A06 0건으로 동일.
**중복 아님**: TO-BE PK16 + 센티널 정규화 기준 중복 **0건**(12,268,009 전부 1행) · AS-IS 도 0건.

## 변경 내역 (BODY 50 / SPEC 1)

| 구분 | 건수 |
|---|---:|
| UPDATE/DELETE 매칭키에 PK 4컬럼 추가 | 32 |
| `B_SUB` 인라인뷰 (컬럼 노출 + 매칭) | 2 |
| 프로시저 시그니처 파라미터 2 | 2 |
| GTT 적재 (전역배열·SPLIT·PAD·INSERT) | 8 |
| 조회 Cutoff (INSERT 컬럼·표시 fallback·원본코드·**GROUP BY**) | 4 |
| 조회 ETC (컬럼 정합) | 2 |
| SPEC 파라미터 | 1 |

**오적용 방지**: `_C_CF` 범위 `X.COMPANY_ID = A.COMPANY_ID` 34건 전수를 소속 문장까지 판별 → UPDATE/DELETE 소속 33건만 대상, INSERT 소속 1건(L5404) 제외. 역순 패턴(INSERT 계열) 28건 미변경. 범위 밖 동일 패턴 0건. 모든 치환에 건수 ASSERT.

**설계 근거**: 원장 PK 5컬럼 NULL **0건**(12,268,009행 전수, 모두 NOT NULL) → `NVL` 불요, 단순 `=` 매칭.

## 화면 변화 (사용자 확인 필요)

- `CELL_PROD_SITE` 가 다른 원장 행이 **별도 행으로 분리**되어 보입니다(종전 합산 1행 → 2행). 대상 = Business_Plan 기준 911,860 그룹 중 **64,428(7.1%)**.
- 표시값은 `NVL(LK4.ATTRIBUTE1, R.CELL_PROD_SITE)` 로 바꿔, lookup 미등록 코드는 **원본 코드(A01/A02)** 가 노출됩니다(구분 가능하도록).
