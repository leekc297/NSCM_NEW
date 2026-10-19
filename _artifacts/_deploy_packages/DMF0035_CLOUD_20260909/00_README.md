# DMF0035_CLOUD_20260909 — Demand Plan Waterfall 3 TYPE 축 통일 + MEASURE 명칭 정정

대상 화면 : **DMF0035 (Demand Plan Waterfall)** 단독.
DMF0035 는 AS-IS 3 UI 통합 화면이라 TYPE 별로 실행 PKG 가 갈린다 — 그래서 3본이 함께 들어간다.
**타 화면(DMF0040 / DMF0053 / DMF0082 등) 작업분은 본 패키지에 포함하지 않는다.**

## 1. 무엇을 고치나 (신고 2건)

| # | 신고 | 원인 | 조치 |
|---:|---|---|---|
| ① | 메저 6종을 선택했는데 2종만 조회 | 메저 개인화 **저장 시트명 ≠ 조회 시트명**. FE 는 `Mkt Fcst Waterfall` 에 저장하는데 `PKG_DMF0035` 는 `mktFcstWaterfall`(어느 메타 테이블에도 실등록되지 않은 이름)을 읽어 **구본**을 표시 | `01_DB/01_` — LIVE 13곳 실등록명 전환 |
| ② | 조회 메저명이 모달 명칭이 아닌 `Mkt Fcst` | MEASURE 는 **콤보 셀**인데 공유 콤보 `Measure` 의 SQL 에 `SHEET_NAME` 필터가 없어 DMF0035 3시트가 뭉침. `MKT_FCST` 가 3회 등록되고 **Biz Plan 라벨(`Mkt Fcst`)이 이김** | `02_META/` — 시트 한정 콤보 3종 + 배선 |
| ③ | (①과 동일 계보) SALES/BIZ TYPE 도 개인화 미반영 | `PKG_DMF0022`=`DMF0022`/`salesPlanWaterfall`, `PKG_DMF0051`=`DMF0051` 을 읽음 | `01_DB/02_`,`03_` — 메타 축을 `DMF0035` + AS-IS 시트명으로 |

### ④ AS-IS 대비 건수 초과 (2026-09-10 추가) — `[E20260910-GRAINFIX]`

클라우드 조회 AS-IS 1,080행 vs TO-BE 1,094행(**+14**). 전 행 대조 결과:

- 14행 전부 **신규 키가 아니라 기존 키의 분할** (ASIS 누락 0 / 신규 키 0)
- 분할 쌍은 **기간 값만** 다르고 나머지 컬럼은 공백까지 동일
- 기간별 합계 14/14 일치 · **전체 총합 296,093,862 양측 동일(차이 0)** ⇒ 누락·중복·값오류 없음

**원인**: TO-BE 에만 있던 `[E20260828-ALLCOLS]` 블록이 UI CATEGORY 의 사업부 매칭 VALID 컬럼을
컬럼목록 뒤에 자동으로 덧붙였다(FE OLAP '필드 후보' 용도). 그런데 이 목록은 그대로
`SELECT / GROUP BY / PIVOT` 축이라 **화면에 없는 컬럼이 집계 grain 을 쪼갠다.**

**분할 축 = `PLANT_SITE_ID`** (사내 데이터로 재현):

| 원천 | PLANT_SITE_ID | QTY |
|---|---|---:|
| 계획 `DM_PLN_MKT_FCST` | `MI00-P` | 0 |
| 계획 `DM_PLN_MKT_FCST` | `WA00-P` | **72** |
| 실적 `DM_PLN_MKT_FCST_RESULT` | `MI00-P` | **18** |
| 실적 `DM_PLN_MKT_FCST_RESULT` | `WA00-P` | 48 |

(`Ford AS_US_HLM` / `AMFMCC727-A1` / `MKT_FCST` / 2026-08 — 클라우드 엑셀의 `18`/`72` 두 행과 일치.
같은 조건에서 표시키당 `PLANT_SITE_ID` 2종인 키가 사내에 33건.)

**AS-IS 근거**: `DMF0035_GET_MKT_FCST_WATERFALL` 의 `@ColList` 대입 지점은 titleset/기본값 2곳 +
`,[NOTATION]` + MEASURE/VERSION 확장 REPLACE 가 전부다. **컬럼 확장 블록은 없다(전수 0건)** —
AS-IS 의 GROUP BY 축은 오직 표시 컬럼(`[@V_COLUMN]`)이다.

**해소(안 B, 사용자 지시 2026-09-10)**: 3본에서 `[E20260828-ALLCOLS]` 블록 제거(각 23줄).

| PKG | 제거 구간 | 라인수 |
|---|---|---|
| `PKG_DMF0035` | L3120~L3142 | 4,250 → 4,236 |
| `PKG_DMF0022` | L2991~L3013 | 3,726 → 3,712 |
| `PKG_DMF0051` | L1589~L1611 | 1,827 → 1,813 |

**A/B 실측** (사내, `jaehun_cho` = 클라우드와 동형 개인화, div81 / 2026-08~2027-02 / MONTHLY):

| | 행수 | 정적컬럼 | `PLANT_SITE_ID` 축 |
|---|---:|---:|---|
| 제거 전 | 531 | 46 | 포함 |
| 제거 후 | **524** | **18** | 제외 |

⚠ **집계 규칙은 변경하지 않았다.** AS-IS L9401~9415 = `BALANCE/VMI_Inv/AS_Inv/SS_LVL/SS_GAP` → 기말값,
**`LOC`(단가) → `AVG`**, 나머지 → `SUM`. TO-BE 가 이미 등가 구현이라 그대로 둔다(MAX 는 AS-IS 근거 없음).

⚠ **부수 영향**: grain 이 넓어지므로 `LOC`(단가) 메저의 `AVG` 대상 집합이 커져 값이 달라질 수 있다.
이는 AS-IS 와 동일한 동작이다(AS-IS 도 표시 컬럼으로만 GROUP BY).
또한 FE OLAP 의 **Fields 레일 후보 컬럼이 줄어든다**(2026-08-28 지시의 되돌림 — 사용자 확정 사항).

### ⑤ 단가(LOC) 집계를 AS-IS 원형으로 (2026-09-10) — `[E20260910-LOCAVG]`

**AS-IS 규칙** (`DMF0035_GET_MKT_FCST_WATERFALL` L9401~9415 / 9429~9443 / 9479~9493, 3곳 동일):

```sql
CASE WHEN F.MEASURE IN ('BALANCE','VMI_Inv','AS_Inv','SS_LVL','SS_GAP')
          THEN CASE WHEN F.WEEK_END_YN = 'Y' THEN SUM(F.QTY) ELSE 0 END
     WHEN F.MEASURE = 'LOC' THEN AVG(F.QTY)      -- 단가 = 평균
     ELSE SUM(F.QTY)
END AS QTY
GROUP BY [@V_COLUMN], F.BASIS_YYYYMM, F.ISO_WEEK, F.WEEK_END_YN
```

**구 TO-BE** 는 `SUM(CASE ... LOC THEN 0 ...) + AVG(CASE WHEN LOC THEN QTY ELSE 0 END)` 로 우회 구현했고
`GROUP BY` 에 `WEEK_END_YN`/`MONTH_END_YN` 이 **없었다**. 대부분의 경우 결과는 같지만, AS-IS 는
기간종료 구분별로 나눈 뒤 AVG 를 내고 바깥에서 합치므로 **LOC 값이 달라질 수 있다.**

**해소**: 집계식 3곳을 AS-IS 형(CASE-of-aggregates)으로 교체 + `GROUP BY` 에
`F.WEEK_END_YN`(주별·ONLY_WEEKLY) / `F.MONTH_END_YN`(월별) 추가.

| 검증 | 결과 |
|---|---|
| `'LOC' THEN AVG(F.QTY)` | **3곳** |
| 구 형태 `AVG(CASE WHEN F.MEASURE = 'LOC'` | **0** |
| `F.WEEK_END_YN, F.EDIT_YN` GROUP BY | 2곳 |
| `F.MONTH_END_YN, F.EDIT_YN` GROUP BY | 1곳 |
| 배포 | 10:40:09 · `VALID` · 오류 0 |
| 런타임 (div81 / 2026-08~2027-02) | `jaehun_cho` **524행**(GRAINFIX 후와 동일) · `minyonglee1` 954행 |

> div81 MKT 데이터에는 현재 `LOC` 메저 행이 **0건**(계획·실적 모두)이라 이번 조회 결과값 변화는 없다.
> 다른 사업부·기간에서 LOC 가 있으면 AS-IS 와 동일한 값으로 산출된다.
>
> `PKG_DMF0022` 는 이미 AS-IS 형(`CASE WHEN F.MEASURE IN ('KRW','USD','LOC') THEN AVG(F.QTY) ELSE SUM(F.QTY) END`,
> 3곳)이라 변경 없음. `PKG_DMF0051` 은 AVG 사용 0건 — Biz Plan 단가(KRW/USD/LOC) 집계는 **별건 점검 대상**.

### ⑥ SALES PLAN div82 SQL ERROR (2026-09-10) — `[E20260910-FROMSITE]`

**증상**: SALES PLAN TYPE / div82 조회 시 SQL ERROR (BE 로그는 `InvocationTargetException: null` 로 가려짐)
**실제 오류**: `ORA-00904: "FROM_SITE_ID": invalid identifier` (`PKG_DMF0022` L3633 `OPEN O_RC1 FOR v_sql_text`)

**원인**: TO-BE `PKG_DMF0022` 의 컬럼사전(`GT_DM22_T_COLUMN_SETUP`)에 **`FROM_SITE_ID` 항목이 변환 시 누락**.
메타(`SCM_MST_SHEET_COLUMNS`)에는 등록돼 있어 컬럼목록에는 들어가는데 사전에 없으니
SELECT 목록에서는 탈락하고 **ORDER BY 에만 남아** 식별자 오류가 난다.
사전 등재 수 실측: **AS-IS 71종 / TO-BE 70종** — 메타 66종 전수 대조에서 미등재는 이 1건뿐.

**AS-IS 원문** (`DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL` L2078):
```sql
INSERT INTO #T_COLUMN_SETUP VALUES ('A','FROM_SITE_ID',
  'CASE WHEN ISNULL(A.CELL_PROD_SITE_ID,''-'') = ''-'' THEN ''N/A'' ELSE A.CELL_PROD_SITE_ID END AS FROM_SITE_ID', 1)
```

**해소**: 동일 항목을 Oracle 형으로 사전에 추가. 배포 11:43:02 · `VALID` · 오류 0.
검증: div82 **494행 정상**(기존 오류) / div40 1,965행 / div81 881행, 3개 division 모두 `FROM_SITE_ID` 반환.

> 이 컬럼은 div81 계열 등록이라 구 camel 시트(`salesPlanWaterfall` 65컬럼)에는 없었고,
> `PROGRAM_ID` 를 `DMF0035` 로 통일(`[E20260909-TYPEAXIS]`)하면서 메타에 들어오며 도달 경로가 생겼다.

### ⑦ SALES PLAN 건수 차이 — `COMPANY_ID` 폴백 (2026-09-10) — `[E20260910-COMPANYID]`

**증상**: SALES PLAN / div40 조회 AS-IS 5,362행 vs TO-BE 5,394행(양방향: ASIS전용 83 / TOBE전용 115)

**원인**: 키를 가르는 컬럼이 `Company Id`. 이 컬럼만 키에서 빼면 전용그룹이 **ASIS 20→3 / TOBE 90→3**.

| | 폴백 조건 |
|---|---|
| AS-IS L2016 | `ISNULL(A.COMPANY_ID,'') = ''` — MSSQL 패딩 비교라 **NULL·''·전부공백** 모두 참 |
| 구 TO-BE L2929 | `NVL(A.COMPANY_ID,'@#@#@#') = '@#@#@#'` — **NULL 일 때만** 참 |

**데이터 실측 (div40)**:

| | NULL | 공백 | `'-'` | 실값 |
|---|---:|---:|---:|---:|
| AS-IS `DM_PLN_SALES_PLAN_RESULT` | 0 | **611,354** | 0 | 445,238 |
| TO-BE 동일 테이블 | 0 | 0 | **610,994** | 445,238 |

실값이 양쪽 445,238 로 동일 = **이관 시 공백이 센티널 `'-'` 로 정규화**됐고, 구 조건은 이를 못 잡아
폴백이 전혀 발동하지 않았다. 그래서 `COMPANY_ID` 가 `'-'` 로 남아 AS-IS 대비 키가 갈렸다.

**해소**: `NVL(TRIM(A.COMPANY_ID),'-') = '-'` — NULL·''·전부공백·`'-'` 을 모두 폴백 대상으로.
배포 11:51:31 · `VALID` · 오류 0.
검증: div40/82/81 조회 시 `COMPANY_ID = '-'` **0건**, 실제 법인코드로 폴백
(div40 `HQ00` 1,230 / `NJ00` 697 / `IL00` 31 / `EG00` 7).

> ⚠ 미조치(별건): 같은 div40 대조에서 `SCM FCST[R+P]` **44건 TO-BE 누락**, Energy 메저 2종 각 **+5** 는
> 원인 미확정 — 사용자 지시로 (A) `COMPANY_ID` 만 먼저 조치.

### 축 규약 (사용자 지시 2026-09-09)

- `SCM_MST_SHEET_COLUMNS` / `SCM_MST_SHEET_MEASURE` / `SCM_MST_TITLESET_USER` 축 = **`PROGRAM_ID='DMF0035'` 고정 + `SHEET_NAME` 으로 TYPE 구분**
- **`SHEET_NAME` 은 임의 변경 금지** — 기존 등록명(`Mkt Fcst Waterfall` / `Sales Plan Waterfall` / `Biz Plan Waterfall`) 그대로
- **PKG 는 기존 3본 이름 유지** (`PKG_DMF0035` / `PKG_DMF0022` / `PKG_DMF0051`) — 패키지명·프로시저 시그니처·API 배선 무변경

### AS-IS 근거 (hook #151 — DB 직접 조회)

`UP_FX_GetCommonDataList` (modify 2026-05-12) `@Code='Measure'` **L2155~2156**

```sql
AND   PROGRAM_ID = @Param1
AND   SHEET_NAME = @Param2      -- ← TO-BE 공유 콤보에서 누락된 조건
```

TO-BE 공유 콤보의 등록명에 「SHEET_NAME=@Param2 제거」로 남아 있어 변환 시점의 의도적 누락임이 확인된다.

## 2. ⚠ 공유 콤보는 건드리지 않는다

공유 콤보 `Measure` 는 **28컬럼 / 17프로그램**이 함께 쓴다. 여기에 `SHEET_NAME` 조건을 넣으면
그 값을 넘기지 않는 나머지 프로그램이 **조용히 0행**이 된다.
따라서 이미 이 시스템에 있던 관례(`DMF0051_BP_Measure` 가 `PROGRAM_ID`+`SHEET_NAME` 고정)를 따라
**시트 한정 콤보 3종을 신설**하고 DMF0035 의 MEASURE 컬럼 3행만 재배선했다.
`Measure` 행은 본 패키지에서 **읽지도 쓰지도 않는다** (검증 G9 가 이를 확인).

## 3. 구성

| 순서 | 파일 | 내용 |
|---:|---|---|
| 1 | `01_DB/01_PKG_DMF0035_BODY.sql` | MKT — titleset 시트명 실등록명화 + MEASURE 컬럼 보장 |
| 2 | `01_DB/02_PKG_DMF0022_BODY.sql` | SALES — `PROGRAM_ID`→`DMF0035`, 시트명→`Sales Plan Waterfall` |
| 3 | `01_DB/03_PKG_DMF0051_BODY.sql` | BIZ — `PROGRAM_ID`→`DMF0035` |

> 3본 모두 `[E20260910-GRAINFIX]`(ALLCOLS 제거) 포함 — 2026-09-10 갱신본.
| 4 | `02_META/10_CMBO_DMF0035_MEASURE.sql` | 시트 한정 콤보 3종 (멱등 MERGE) |
| 5 | `02_META/11_SHEET_COLUMNS_MEASURE_COMBO.sql` | MEASURE 컬럼 배선 3행 |
| 6 | `90_VERIFY.sql` | 검증 G1~G10 (읽기 전용) |

모든 `.sql` 은 `CREATE OR REPLACE` 접두어 + 종결자 `/` + `SET SQLBLANKLINES ON` 을 갖춘 **실행용**이다.
(빈 줄이 많은 본문은 `SQLBLANKLINES OFF` 기본값에서 문장이 끊겨 `ORA-00928`/`ORA-00904` 가 난다 — 2026-09-09 실사고)

## 4. 적용 절차

```sql
-- SCM_MGR 로 접속
@01_DB/01_PKG_DMF0035_BODY.sql
@01_DB/02_PKG_DMF0022_BODY.sql
@01_DB/03_PKG_DMF0051_BODY.sql
@02_META/10_CMBO_DMF0035_MEASURE.sql
@02_META/11_SHEET_COLUMNS_MEASURE_COMBO.sql
@90_VERIFY.sql
```

메타 2본은 **멱등**이라 재실행해도 결과가 같다(사내에서 재적용 실증).
패키지는 무상태라 `ORA-04068` 이 없어 **BE 재기동 불요**. 화면은 **브라우저 새로고침**만 하면 된다
(컬럼 메타·콤보는 런타임 fetch).

## 5. 검증 게이트 (`90_VERIFY.sql`) — 사내 실측 결과

| 게이트 | 기대 | 사내 실측 |
|---|---|---|
| G1 | 3 PKG 의 PACKAGE/BODY 전부 `VALID` | 6행 전부 VALID |
| G2 | `USER_ERRORS` 0행 | **0행** |
| G3 | 메타 축 상수 = `DMF0035` + AS-IS 시트명 | 15행 전부 정합 |
| G4 | 구 축 리터럴(`mktFcstWaterfall`/`salesPlanWaterfall`/`DMF0022`/`DMF0051`) LIVE 잔존 0 | **0행** |
| G5 | `V_COL_LIST := V_COL_LIST \|\| ',MEASURE';` 1행 | 1행(L3006) |
| G6 | 콤보 3종 `USE_YN='Y'` | 3행 (2225 / 2227 / 285자) |
| G7 | 콤보 3종에 `SHEET_NAME` 필터 존재 | 3행 OK |
| G8 | MEASURE 컬럼 3행이 시트별 전용 콤보 배선 | 3행 |
| G9 | 공유 콤보 `Measure` **UNCHANGED** | `minyonglee1 / 2026-09-07 13:44:39 / UNCHANGED` |
| G10 | MKT 시트 내 라벨 충돌 0 | **0행** |

### 런타임 실측 (사내)

- 콤보 격리: `DMF0035_MKT_Measure` 고유 48 / `MKT_FCST`=`MKT FCST[P+P]` / 충돌 0 / **BIZ 전용 메저(`Business_Plan`,`CAR_QTY`) 유입 0**
  (정정 전 공유 콤보는 고유 63 / `MKT_FCST`=`['MKT FCST[P+P]','Mkt Fcst']` / BIZ 전용 2종 유입)
- 메인 SP: `P_DMF0035_GET_MKT_FCST_WATERFALL`(div81) **468행** 정상, 사용자 저장 메저를 그대로 채택
- 메타 등가(전환 안전성): SALES `DMF0022`↔`DMF0035` 메저 31=31·컬럼 66=66·라벨차 0 / BIZ `DMF0051`↔`DMF0035` 메저 9=9·컬럼 61=61·라벨차 0

## 6. 화면 확인

TYPE = **MKT FCST** 조회 시

1. Measure 모달에서 고른 메저가 **그대로** 조회되는가 (구본 고정 아님)
2. 그리드 MEASURE 열 명칭이 모달과 동일한가 — `MKT FCST[P+P]` / `MKT FCST[R+P]` / `RTF[P+P]` …, **`Mkt Fcst` 가 나오지 않아야 한다**
3. BIZ 전용 메저(`Business Plan`, `Car Qty`)가 목록에 섞이지 않는가

SALES PLAN / BIZ PLAN TYPE 도 각각 메저 개인화가 반영되는지 확인.

## 7. 범위 밖 (본 패키지 미포함)

- 다른 화면 작업분 — `PKG_DMF0040`(VERSION 라벨·Owner), `PKG_DMF0053`(DEPT_ID), `PKG_DMF0082`(Biz Type 문구). 각각 별도 패키지 보유
- FE / BE 소스 변경 없음 — 본 건은 **DB 축 정정만**으로 해소된다
- MSG/LBL/MNU 메타 · GTT/TYPE DDL · GRANT/시노님 : 변경 없음

## 8. 별건 (미조치 — 참고)

- `SSP0026` 도 공유 콤보 `Measure` 를 쓰면서 `SHIP_PLAN` 코드에 라벨 충돌 1종 — 같은 증상 잠재
- `PKG_DMF0022` 는 별도 화면 `MENU_ID='DMF0022'`(메뉴 `USE_YN='Y'`)도 공유한다. 본 변경으로 그 화면도 DMF0035 메타를 읽는다. 단 `SCM_ADM_API_M` 에 `DMF0022_*` 배선이 **0건**이라 현재 독립 호출 경로는 없다
- 구 titleset `DMF0022/'salesPlanWaterfall'` 29행 · `DMF0051/'Biz Plan Waterfall'` 24행은 고아가 되나 **삭제하지 않는다**
