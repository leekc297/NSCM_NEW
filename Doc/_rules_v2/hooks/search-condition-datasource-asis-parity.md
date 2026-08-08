# Hook #117 — 조회조건 데이터 추출 AS-IS 정합 + 공유 CMBO 보호 프로토콜

> **트리거**: 조회조건 콤보/팝업의 **데이터 소스** 작성·수정 · "AS-IS 와 후보가 다르다" 류 이슈 · `SCM_ADM_CMBO_SQL_M` 공유 SQL_ID 수정 시도
>
> #112(명칭·유형·기능 카탈로그)와 별개 축 — 본 hook 은 **각 항목이 어떤 쿼리로 데이터를 뽑는가** 의 1:1 정합.

작성: 2026-07-23 (DMF0003 조회조건 14항목 전수 대조 — 6건 불일치[BizType 81/82 후보 전량 누락·EndCustomer 929행 누락·Team 소스 상이·SalesSite cascade/AS분기 누락·SenderCode 표시명·Period 기본값] 실측 후 전건 보완. 사용자 지시)
관련 메모리: `project_dmf0003_searchcond_asis_align.md` / 패키지: `_deploy_packages/DMF0003_SEARCHCOND_ASIS_ALIGN_20260723`

---

## §1. AS-IS 데이터 소스 원천 (DM 화면)

| AS-IS 호출 | 원천 정본 | 비고 |
|---|---|---|
| `DataService.GetDMInnerTable("키", Filter)` | `GSCM/04.WSL/FoxQuery/DM/Common/BigFilter.xml` (키별 SQL 블록: MyDivision/TeambyDivision/EndCustomerByDivision/BizType/SiteByEndCustomer(40)/FromSiteByDivision/PlantSiteByEndCustomer/EdiSender/ScmSitebyEndCustomer40) | **DM 화면 조회조건 콤보 전부 이 파일이 원천** |
| `UP_FX_GetCommonDataList_DM(CODE=...)` | AS-IS MSSQL SP — `.env.asis` pyodbc `OBJECT_DEFINITION(OBJECT_ID('...'))` 실측 | 화면 개별 override 분기(예 SalesSite AS 분기·OPERATION_GROUP 'W' 제외) 포함 |
| `PR_GET_DAY_RANGE` 등 기본값 SP | 동일 (OBJECT_DEFINITION) | Period 기본값 = 해당월 1일~+p_month개월 구간 말일 |
| SCP/FP/SSP | 각 `04.WSL/FoxQuery/{도메인}/Common/BigFilter.xml` | 도메인별 상이 — DM 것 재사용 금지 |

## §2. 정합 점검 절차 (조회조건 항목별 — 의무)
1. AS-IS: 화면 .cs 의 `SetChangeControl`/로컬 Get* 함수 → 키·파라미터 확정 → §1 원천에서 SQL 원문 확보.
2. TO-BE: 콤보(SQL_ID)·카탈로그 필드·팝업 SP 의 실제 SQL 을 사내 DB 실측.
3. **의미 대조**: 소스 테이블/조인 키/필터(권한·VALID·특수 제외)/표시명(NAME 소스)/정렬/cascade 파라미터/기본값 산식.
4. 불일치 의심 = **사내 데이터로 양식 실행 차집합(MINUS) 실측** 후 판정 (추측 금지 — DMF0003 Team 35/64 차집합 선례).

## §3. 공유 CMBO 보호 프로토콜 (⭐ 절대 규칙)
1. **공유 SQL_ID(`SCM_ADM_CMBO_SQL_M`) 수정 전 소비자 전수 grep 의무**:
   `grep -rn "'<SQL_ID>'" nscm-fe/features` — 조회조건 + **grid 셀 콤보(_comboKey)** + array-form(무바인드) 호출 전부.
   (사고: `SiteByEndCustomer` 를 덮었다가 waterfall·DMF0020 셀콤보 등 **소비자 5곳** 파급 직전 복원 — 2026-07-23)
2. 소비자 2곳 이상 or 바인드 시그니처 변경 → **화면 전용 신규 SQL_ID 등록**(`{공유명}_{화면ID}` 또는 AS-IS BigFilter 키 명칭) + 해당 화면만 전환. 공유본 무변경.
3. 카탈로그 필드(@master/searchFields) 확장은 **opt-in prop**(`comboId?`/`division?` — 기본값 = 기존 동작)으로만. shared 기본 동작 변경 금지(`feedback_shared_global_prop_change_forbidden`).
4. 서버 바인드 콤보(@divisionId 등)는 값 quoting 의무 + cascade 는 바인드 queryKey 반응(재조회)으로 구현 (`feedback_bind_combo_value_quoting`).
5. 신규/정정 CMBO 는 바인드 치환 실행 검증(행수) 후 멱등 MERGE 로 이관 패키지 동봉.

## §4. Grid Cell Combo Data Type 축 대조 (2026-07-23 보강 — 5UI 전수 대조 선례)
조회조건과 별개로 그리드 셀 콤보(`SHEET_COLUMNS.CELL_COMBO_DATA_TYPE`)도 동일 원칙으로 대조:
1. **양 DB 직접 diff**: AS-IS(MSSQL) ↔ TO-BE(Oracle) SHEET_COLUMNS 를 (PROGRAM_ID, SHEET_NAME, COLUMN_NAME) 키로 CELL_CONTROL_OBJECT_TYPE_CODE + CELL_COMBO_DATA_TYPE 비교 (행 누락/값 상이/양측 only).
2. **AS-IS 셀 콤보 해석기 = `UP_FX_GetCommonDataList`(공용판)** — 분기 위치는 `sys.sql_modules` definition LIKE 검색으로 확정(추측 금지).
3. **rename 판정 = 값 집합 MINUS**: camelCase 등록명 rename(CURRENCY_LIST→CurrencyList 등)은 AS-IS 분기 SQL ↔ TO-BE CMBO SQL 을 양 DB 에서 실행해 (CODE,NAME) 집합 동일하면 "실질 일치". 다르면 결함(예: FcstType ATTR2 제외 12종 vs AS-IS 14종 / DmBizType 'ALL' UNION — 셀 에디터 ALL 저장 오염 위험).
4. **AS-IS .cs 동적 SetComboCol 확인 의무** — SHEET_COLUMNS 메타가 빈값이어도 화면 코드가 콤보를 설정하는 경우 존재(DMF0042 CELL_PROD_SITE). 메타 빈값=콤보 아님 단정 금지.
5. **사문 컨트롤 = 미이관 정당**: AS-IS 핸들러가 전부 주석인 컨트롤(DMF0021 KRW/USD/LOC, DMF0082 EdiSender[컨트롤 자체 부재])은 TO-BE 미구현이 파리티.
6. 조회조건 콤보에 'ALL' 행 UNION 은 허용(FE allOption 과 별개 판단), **셀 콤보에 'ALL' 행은 결함**(저장값 오염).

---

## §5. ⭐ UP_FX 계열 Filter 콤보 누락분 CMBO 등록 절차 (2026-08-07 사용자 확정)

> 사용자 지시 원문: "CASCADE, FILTER 중 AS-IS 에서 UP_FX_GetCommonDataList 로 사용하고 있는 Filter 조회 중 COMBO 누락분이 있으면 COMBO 에 동일 코드로 추가해주세요. 기존에 동일 코드로 COMBO 가 존재하고 있으면 BigFilter 에서 이미 사용하고 있을 수 있으므로, 동일 코드의 query 를 확인해서 같이 사용 가능하면 같이 사용하고 같이 사용이 불가하면 유사코드로 생성"

1. **누락 판정**: cascade/filter 정합 작업 시 AS-IS `UP_FX_GetCommonDataList(_DM)` 계열 Filter 조회 키를 전수 나열하고
   `SCM_ADM_CMBO_SQL_M` 등록 여부를 실측한다 (`SELECT SQL_ID FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN (...)`).
   ⚠️ FPModal 계열 키(예: `ProjectByDivision` — COM 팝업 식별자)는 CMBO 대상 아님 — 모달 배선 축으로 분리 판정.
2. **누락 시 = AS-IS 동일 코드(SQL_ID)로 등록**: 쿼리 = AS-IS 원문(`sys.sql_modules` 실측) 1:1 변환. 임의 개명 금지.
3. **동일 코드 기존재 시 = 쿼리 대조 후 분기** (BigFilter/타 화면이 이미 소비 중일 수 있음 — §3 소비자 전수 grep 의무):
   - **같이 사용 가능**(반환 컬럼·바인드·필터 의미가 본 화면 요구를 충족) → **공용 그대로 사용** (SQL 무수정).
   - **같이 사용 불가**(컬럼 추가·바인드 변경·필터 의미 상이 필요) → **유사코드 신규 등록**(예: `SiteByEndCustomer` → `SiteByEndCustomerAuth`)
     — 공유본 무수정 원칙(§3). 유사코드 명명 = 원코드 + 용도 접미(Auth/40/Team 등 선례).
4. **콤보 @바인드 실측 의무**: 등록/재사용 판정 시 `SQL_DTL_CTN` 의 `@토큰` 존재·NULL 관대 가드 여부를 실측
   (`(@x IS NULL OR @x='')` 관대형 = comboParams 미전달 화면에서도 무해 / 비관대형 = 미전달 시 0행 — hook #59 사고 계보).
- 선례: DMF0082 cascade 정합(2026-08-07) — 후보 16키 실측 = CMBO 15 기등록 + `ProjectByDivision` 은 모달 키 판정 → **누락 0**.

---

## §5.5~§5.10 ⭐ UP_FX 3분할 완결 의무 (2026-08-08 신설 — DMF0082 누락 감사)

> **왜 신설했나**: 위 §5 절차대로 "CMBO 등록 여부"를 실측하고 **누락 0** 을 선언했는데도(§5 말미 선례),
> 실제로는 DMF0082 에 **9건의 결함**이 살아 있었다. §5 가 ①등록만 셌고 ②배선·③파라미터 전달을 보지 않았기 때문이다.
>
> AS-IS 는 콤보 데이터를 **3계통**으로 얻는다 — `BigFilter.xml`(조회조건, 로드 1회 배치) /
> `UP_FX_GetCommonDataList_DM`(직접 호출) / `UP_FX_GetCommonDataList`(기본판, `Data.Common(Data.Type.X,…)` 로 **은닉**).
> BigFilter 키는 TO-BE CMBO 와 1:1 이라 눈에 보이지만, **UP_FX 키 1개는 TO-BE 산출물 3개로 쪼개진다.**
> ⚠️ `UP_FX_` 문자열 grep 은 은닉 호출을 놓친다 — DMF0082 실측: grep 6건 vs 실제 소비 **14 CODE**.

### §5.5 3분할 완결 의무

UP_FX 키 1건의 "구현" 선언 조건 = 다음 **3칸 전부**:

| # | 축 | 확인 방법 |
|---|---|---|
| ① | `SCM_ADM_CMBO_SQL_M` SQL_ID 등록 | `SELECT SQL_ID …` |
| ② | 소비지점 배선 | `SHEET_COLUMNS.CELL_COMBO_DATA_TYPE` 또는 FE 의 명시 `getCombo`/`useTabComboQueries` 호출 |
| ③ | FE 파라미터 전달·스왑 | 아래 §5.6~§5.10 |

**①만으로 "누락 0" 선언 금지.**

### §5.6 토큰 대사표 의무

소비 CMBO 의 `SQL_DTL_CTN` 에서 `@(\w+)` 를 전수 추출해 **{서버자동, FE전달, 미전달}** 3분류표를
`__asis-mapping__.md` 에 첨부한다(정본 양식 = DMF0082 `__asis-mapping__.md` 말미).

- **서버 자동 주입은 `@sesUserId` / `@sesLangCd` 뿐**이다(`LookupServiceImpl.retrieveCombo`).
  `@userId` / `@langCd` 는 `/admin/combo-muti` 에만 주입되고 FE 실사용 경로인 단건 `/admin/combo` 에는 **미주입**.
- '미전달' 칸은 그 토큰이 **관대형**임을 SQL 원문 인용으로 증명해야 한다:
  `@t IS NULL OR …` / `NVL(TRIM(@t),'ALL')='ALL' OR …` / `CASE @t WHEN … ELSE … END`(표시 선택자, 행 필터 아님).
- **비관대형(`COL = @t`) + 미전달 = 즉시 FAIL.** BE 가 `''` 로 치환하고 Oracle 에서 `''` = NULL 이므로 **0행**이 되며,
  그리드는 CODE→NAME 매핑을 잃고 **코드를 raw 로 표시**한다(DMF0003 2026-07-20 · DMF0082 2026-08-08 동일 사고).

### §5.7 quoting 단언

BE `BaseService.makeComboQuery` 는 `@토큰` 을 **raw 문자열 치환**한다(바인드 변수 아님).
FE 는 문자열 값을 반드시 `'값'` 형태로 보내야 한다 — 안 그러면 `SCM_SITE_ID = KRSL` 이 되어 **ORA-00904**,
숫자형 컬럼이면 ORA-01722. 정본 헬퍼: `SearchFields.tsx` `q()` / `forecast-price/utils/forecast-price.combo.ts` `q()`.
값이 비면 `'ALL'` 로 보낸다(관대형 SQL 의 전체 게이트).

### §5.8 조용한 실패 금지

콤보 호출에 **빈 `.catch(() => {})` 금지**. 최소 `console.error('[combo]', comboId, err)`.
폴백 동작이 있으면 그 폴백을 코드 주석 + `__asis-mapping__.md` 에 명시한다.
> DMF0082 실측: quoting 누락 + 빈 catch 조합으로 캐스케이드 2종이 **한 번도 동작하지 않았는데** 매핑표에는 "구현"으로 적혀 있었다.

### §5.9 분기 재현 대사

AS-IS SP 의 분기(IF/CASE) 개수 N ↔ TO-BE 재현 N 을 표로 대사한다.
SQL 로 접을 때 쓰는 관용구(선례 실측):
① `EXISTS`/`NOT EXISTS` + `UNION ALL`(그룹 분기 — `FcstTypeByUserGroupDMF0082`)
② `WITH F AS(플래그) … CROSS JOIN F`(다중 IF — `TeambyDivisionAuth`)
③ `NVL(TRIM(@t),'ALL')='ALL' OR INSTR(…)`(CSV + ALL 게이트 — `UserSiteByEndCustomer`)
④ `@t IS NULL OR …`(무필터 폴백 — `CELL_PROD_SITE_ID`)
⑤ `COL NOT IN (CASE WHEN 조건 THEN '값' ELSE CHR(0) END)`(조건부 제외 — `FcstPriceEditMeasure`)
⑥ `REGEXP_SUBSTR + CONNECT BY`(CSV 토크나이저) ⑦ `n AS SORT_ORDER`(분기별 표시 우선순위)

접을 수 없어 CMBO 를 분할했으면 분할 근거를 명시한다(선례: `Incoterms` ↔ `IncotermsEdit` ↔ `AsIncotermsEdit`).

### §5.10 편집/조회 이원화 판정식 — ⭐ 메타 교체 금지 조건

편집 후보 ⊊ 표시 후보인 축은 **`SHEET_COLUMNS.CELL_COMBO_DATA_TYPE` 교체 금지**.
메타를 편집판으로 바꾸면 **원장에 남은 폐지 코드 행의 NAME 변환이 깨져 raw 코드로 표시**된다.

```
판정: SELECT COUNT(*) FROM 원장 WHERE 해당컬럼 NOT IN (편집 후보 집합)
  > 0 → 메타 교체 금지. FE `GRID_EDIT_COMBO` 스왑(진입 스왑 + cellEditEnded 원복 — hook #59 §5-G).
  = 0 → 메타 교체 허용. 단 §3 소비자 전수 grep + **해당 화면 행만** MERGE(공유 CMBO 본문 무수정).
```

**⭐ 적용 범위 판정도 의무** — AS-IS 가 적용하던 division/조건 범위를 넘겨 걸지 말 것.
AS-IS 가 특정 division 전용 화면이었다면 그 큐레이션 목록은 **그 division 전제**다. TO-BE 확장분에 그대로 걸면
실제로 쓰는 코드가 막힌다. 확장 division 은 원장 실측으로 판정한다.
> DMF0082 실측: `INCOTERMS` EDIT_YN='Y' 10종은 40 기준 — 81 원장 76.9만 행 중 **14.9만(19%)이 EDIT_YN='N'**(Z02 14.4만 등).
> `DM_CUSTOMS_HANDBOOK_40` 은 'E' 1종인데 81 은 'D' 1.7만·82 는 'D' 2,034 행 보유. → **40 에만 적용**.

**⭐ 저장 대상 여부 선확인** — 편집판 적용 전에 그 컬럼이 SAVE 파라미터인지 `SCM_ADM_PROC_M` 으로 실측한다.
저장되지 않는 표시 전용 컬럼에 권한/큐레이션 필터를 걸면 이득 없이 빈 콤보 위험만 생긴다.
> DMF0082 `TEAM_ID` = SAVE IN 17종에 `teamId` 없음 → 편집판(`TeambyDivisionAuth`) 적용 **제외**.
> (실측 행수: hongjae.kim 0 / jiwon.park 3 / wonqthanq 0 / bpark416 0 / minyonglee1 29 — 다수 계정 0행)

### 자동 검사

`ui_gate_runner.py` **섹션 7**(UP_FX 콤보 파라미터 정합)이 S7-1~S7-6 으로 위 항목을 기계 검사한다.
`ui_http_e2e.py` **D2 축**은 셀 콤보를 메타에서 자동 수집해 FE 실전달 파라미터로 호출하고,
파라미터 없는 호출과 **행수를 비교**해 "파라미터가 실제로 먹었다"를 런타임으로 증명한다(셀 콤보 0행 = FAIL).

---

## §5.11 ⭐ AS-IS combo SP **프롤로그(공통 변형)** 이식 의무 (2026-08-08 신설 — 사용자 지적)

> 사용자 지적 원문: "asis combo sp 상단에 부서와 권한에 대한 변형을 발생시키는 query 가 있습니다.
> 공통 적용사항이라 적용이 필요한데 tobe 에 적용되어 있나요."

`UP_FX_GetCommonDataList`(기본판)는 **모든 `@Code` 분기 이전**에 두 변형을 수행한다. 분기 본문만 1:1 이식하면
이 프롤로그가 통째로 누락되며, **분기 SQL 은 멀쩡해 보이므로 발각되지 않는다.**

| 변형 | AS-IS 원문 | 의미 |
|---|---|---|
| ① `@v_dept_id` | `TB_FX_User.DEPT_ID` (없으면 `PM_TEAM_MAPPING.SEGMENT3` 후순위 폴백) | 사용자 소속 팀 |
| ② `@v_group_id` | `IF EXISTS(GET_ADMIN_GROUP … SEGMENT2 IN ('ALL','DMF0003') AND SEGMENT1=@Param3) → 'ADMIN'` | **권한 그룹 승격** |

**소비 분기(기본판 255 분기 중 3)**: `TeambyDivisionAuth` · `SiteByEndCustomerAuth` · `Auth_Dept`
(TO-BE 는 `EndCustomerByDivisionDeptAuth` 도 동형). 프롤로그를 가진 SP 는 **기본판 뿐**이다 —
`_DM`/`_FP`/`_SCP`/`_SCP_ALL`/`_REPORT` 는 없음(`PM_TEAM_MAPPING` 위치가 첫 `IF @Code` 이전인지로 판정).

### 의무

1. **combo SP 이식 시 첫 `IF @Code` 이전 구간을 반드시 읽는다.** 분기 본문만 보고 "1:1 이식" 선언 금지.
2. **`@v_group_id` 는 리터럴 그룹명 비교로 축소하지 말 것.** 권한 그룹 승격의 원천은 **lookup `GET_ADMIN_GROUP`**
   이며 운영이 행을 추가·삭제해 조정한다. 리터럴 `USER_GR_ID='ADMIN'` 로 바꾸면 **운영 등록분이 전부 무효**가 된다.
3. **다중 그룹 사용자** = 보유 그룹 중 **하나라도** 등재되면 ADMIN (AUTHUNION 정책, 2026-08-04 사용자 확정).
   AS-IS 는 세션의 단일 `@Param3` 를 쓰지만 TO-BE 에는 "현재 그룹" 개념이 없다.
4. **ADMIN 우회가 없는 분기를 임의로 추가하지 말 것.** AS-IS `TeambyDivisionAuth` 의 다중팀(`@v_team_cnt > 1`)
   분기에는 ADMIN 우회가 **없고** MAPSET 로만 거른다 — 이식본도 동일해야 한다.

### 실사고 (2026-08-08 DMF0003)

3 CMBO 전부가 `USER_GR_ID='ADMIN'` 리터럴로 축소 이식돼 있었다. `GET_ADMIN_GROUP`(SEGMENT2='ALL') 실측 =
`ADMIN` / `DM ADMIN` / `DM Planner` / `SCM PI Admin` / `SCP Planner` (+`DM Planner (W/S)` @DMF0003)
→ **로스터 9계정 중 6계정이 ADMIN 미인정**. 적용 전후 실측:

| CMBO | hongjae.kim(40 Admin) | eunah.koo(40 Planner) | bpark416(81 Planner) | wonqthanq(82 Admin) |
|---|---|---|---|---|
| TeambyDivisionAuth | 0 → **17** | 1 → **17** | 0 → 0(다중팀 분기) | 0 → 0(다중팀 분기) |
| SiteByEndCustomerAuth | 0 → **1,282** | 0 → **1,282** | 0 → **1,191** | 0 → **730** |
| EndCustomerByDivisionDeptAuth | 0 → **4** | 0 → **4** | 0 → **531** | 0 → **344** |

DM Viewer(yooah.chung·park6151)는 등재 대상이 아니라 **변화 없음** — 권한 축소가 아니라 파리티 복원임을 확인.

### 점검 방법

```sql
-- 리터럴 축소 이식 탐지 (전 CMBO)
SELECT SQL_ID FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
 WHERE REGEXP_LIKE(UPPER(SQL_DTL_CTN), 'USER_GR_ID\s*=\s*''ADMIN''')
   AND UPPER(SQL_DTL_CTN) NOT LIKE '%GET_ADMIN_GROUP%';   -- 기대 0건
```

---

## §5.12 ⭐ **호출 지점 수(N) 대사** 의무 (2026-08-08 신설)

§5.5~§5.11 을 다 지켜도 남는 구멍이 하나 있다 — **"어디서 부르는가"**.
SQL 이 맞고 파라미터도 맞는데 **부르는 시점이 빠지면** 기능은 조용히 죽는다.

### 실사고 2건 (같은 날, 같은 원인)

| 대상 | AS-IS 호출 지점 | TO-BE(수정 전) | 증상 |
|---|---:|---:|---|
| `FCST_PRICE_EDIT_MEASURE` (DMF0082) | **6** (.cs L2621 InsertRow / L5841 셀변경 / L7922·L8027 Paste / L8261 Division / L8308 Site·Incoterms) | **1** (SCM_SITE_ID 변경) | **InsertRow 누락이 치명적** — 시드 복사 행을 그대로 저장하는 정상 흐름에서 사이트 특성(VMI_YN) 필터가 한 번도 적용 안 됨 |
| `CELL_PROD_SITE_ID` (DMF0082) | 2 (InsertRow / ITEM_ID 변경) | **0** | 매핑표에는 "구현" 으로 기재돼 있었음 |

### 의무

1. AS-IS 소스에서 해당 CODE/헬퍼의 **호출 지점을 전수 grep 해 개수 N 을 확정**한다.
   ⚠️ 주석 처리된 호출은 제외하되 **제외했다는 사실을 기록**한다(사문 = 미이관이 파리티).
2. TO-BE 트리거 수와 **N:N 대사표**를 `__asis-mapping__.md` 에 기입한다. 수가 다르면 사유 필수.
3. **행 생성(InsertRow) 지점을 최우선 확인**한다. 사용자가 값을 "바꾸는" 경로만 구현하고
   "만드는" 경로를 빼먹는 것이 가장 흔한 누락이며, 시드 복사 화면에서는 **전 사용자가 이 경로를 탄다**.
4. 붙여넣기(paste)는 편집 핸들러를 공유하는지 확인한다(`pastingCell`/`pastedCell` 등록 여부).

### 자동화 (2026-08-08 신설)

```
python _artifacts/_diagnostics/combo_callsite_parity.py --menu <ID> --page <FE 폴더>
python _artifacts/_diagnostics/combo_callsite_parity.py --all     # 전 화면 스윕(읽기 전용)
```
`ui_gate_runner.py` **섹션 8** 로 편입돼 완료 게이트에서 강제된다.

**비교 단위** = AS-IS **구별된 이벤트 핸들러 수** ↔ TO-BE **트리거 수**.
(호출 횟수로 비교하면 안 된다 — AS-IS 는 한 핸들러에서 여러 번 부르고, TO-BE 는 헬퍼 1개를 여러 트리거가 부른다.
 TO-BE 가 `pastedCell` 에 편집 핸들러를 공유하면 Paste 는 AS-IS 집계에서 제외한다.)

**핵심 판정** — AS-IS 에 InsertRow 지점이 있고 **콤보가 행 종속 토큰**(`@divisionId`/`@itemId`/`@scmSiteId`/
`@endCustomer` …)을 가지는데 TO-BE 에 신규행 프라이밍이 없으면 **FAIL**.
메타 자동 바인딩은 **렌더 1회**라 행 생성 시점 재조회를 대체하지 못한다.
반대로 파라미터 없는 콤보는 메타 바인딩으로 충분하다(이 구분이 없으면 오탐이 쏟아진다).

**도구 검증(필수 절차)**: 수정 전 코드(git HEAD)로 돌려 **실제 결함이 FAIL 로 잡히는지 먼저 증명**했다 —
DMF0082 수정 전 **FAIL 3**(`FCST_PRICE_EDIT_MEASURE`·`CELL_PROD_SITE_ID`·`SiteByEndCustomer` 전부 InsertRow 누락)
→ 수정 후 **FAIL 0**. 수작업으로 찾은 결함을 도구가 독립 재발견했다.

> 게이트 한계 명시 — 섹션 7(정적)·D2 축(런타임)은 **"콤보가 올바른 데이터를 주는가"** 만 본다.
> 섹션 8 이 **"제때 부르는가"** 를 담당하지만, 동적 분기(맵/스위치)로 만드는 트리거는 정적 추출이 어렵다 —
> 미식별은 **WARN 으로 노출**하며 조용히 통과시키지 않는다.
