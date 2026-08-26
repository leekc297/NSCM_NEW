# DMF0049 Etc Sales Reports — 클라우드 이관 패키지 (2026-08-20)

- **대상 화면**: DMF0049 / Etc Sales Reports (Demand > Demand Plan > Etc Sales Reports)
- **원천**: 사내 Oracle `SCM_MGR@100.65.143.121:1521/OCGSCMD_P01` **라이브 실측 덤프** (2026-08-20)
- **상태**: 사내 적용 완료 / **클라우드 미적용**
- **작성 원칙**: 손나열 금지 — 딕셔너리 기계 전수 스윕. 0행 축은 "0행"으로 명기. 추정값 사용 금지(전부 실측).
- **DB 무변경**: 본 패키지 생성 과정에서 사내/클라우드 DB 에 실행한 것은 **SELECT 뿐**이다.

---

## 1. 적용 순서 (반드시 이 순서)

| # | 파일 | 내용 | 비고 |
|---|---|---|---|
| 0 | — | **PREREQ 확인** (§2) | 미충족 시 중단 |
| 1 | `A_DB/01_DDL_DEFAULT_ON_NULL.sql` | NOT NULL 컬럼 `DEFAULT ON NULL` (멱등) | 22 컬럼 |
| 2 | `A_DB/02_DDL_GTT.sql` | GTT 6본 자급 (멱등) | **PKG 컴파일 전제** |
| 3 | `A_DB/03_DDL_SEQUENCE.sql` | `SEQ1_DM_PLN_SALES_ETC_REPORT_H` (멱등) | **PKG 컴파일 전제** |
| 4 | `A_DB/10_PKG_DMF0049_SPEC.sql` | PACKAGE SPEC | 89 src lines |
| 5 | `A_DB/11_PKG_DMF0049_BODY.sql` | PACKAGE BODY | 1,224 src lines / 마커 3 |
| 6 | `A_DB/20_MENU_META_SYNC.sql` | 메뉴·프로그램·API·버튼·권한 | ⭐ 누락 시 조회 전멸 |
| 7 | `A_DB/21_CMBO_SYNC.sql` | 콤보 22종 | 공유 다수 — §5 확인 |
| 8 | `A_DB/22_SHEET_META_SYNC.sql` | 시트 메타 (COLUMNS 90 / MEASURE 21) | ⭐ 공유 시트 — §4 필독 |
| 9 | `A_DB/23_MSG_LBL_MNU_SYNC.sql` | MSG/LBL/MNU 24코드 × 3언어 | |
| 10 | `A_DB/24_PROC_M_SYNC.sql` | ⭐⭐ `SCM_ADM_PROC_M` 11 SP / 119행 | **누락 = PLS-00306** |
| 11 | `A_DB/25_EXCEL_COLUMNS_SYNC.sql` | (0행 축 — 실행할 DML 없음) | 축 확인 기록용 |
| 12 | `A_DB/30_GRANT_SYNONYM.sql` | EXECUTE GRANT + 시노님 + 표 DML 권한 | |
| 13 | `A_DB/90_VERIFY.sql` | **적용 후 검증** (V1~V11) | 전 항목 PASS 필요 |
| 14 | `C_BE/**` | 공용 titleSet 엔드포인트 (**diff 병합**) | `C_BE/_BE_CHANGE.md` |
| 15 | `B_FE/**` | 화면 폴더 전체 + 타입 + i18n 발췌 | `B_FE/_IMPORT_CLOSURE.md` |

> DDL → PKG → 메타 → (BE/FE) → VERIFY 순서를 지킬 것.
> 메타를 PKG 보다 먼저 넣으면 화면이 잠깐 PLS-00201 상태가 되고, PKG 를 GTT 보다 먼저 넣으면 컴파일이 깨진다.

---

## 2. PREREQ — 선행 배포가 필요한 타 소유 객체

`ALL_DEPENDENCIES` 실측 결과 **타 스키마 의존은 0건**이다(전부 `SCM_MGR` 소유). 단, 이 PKG 는
**교차 PKG/standalone 을 호출**하므로 그것들이 없으면 `PLS-00201` 이 난다 — 본 PKG 계보에서 실제 발생한 사고다.

| 객체 | 타입 | 사내 STATUS | DMF0049 에서의 역할 |
|---|---|---|---|
| `PKG_DMF0044` | PACKAGE / BODY | VALID / VALID | ⭐ `unitedVersion` 4 SP + `SP_VER` 팝업. **없으면 버전 팝업 전멸** |
| `PKG_DMF0000` | PACKAGE / BODY | VALID / **INVALID** | `unitedVersion` TITLE (공통 spread title). §7 미결 참조 |
| `PKG_SCM_USER_MNU` | PACKAGE / BODY | VALID / VALID | `PR_SCM_EDIT_YN` (편집권한 판정) |
| `DMF0002_GET_TITLESET_POPUP` | PROCEDURE | VALID | Column/Measure 팝업 조회 |
| `SCM0002_SET_TITLESET_POPUP` | PROCEDURE | VALID | Column/Measure 팝업 저장 |
| `FN_GET_COUNTRY_KR_NAME` / `FN_GET_DM_MKT_OWNER_NAME` | FUNCTION | VALID | GET 내 표시명 |
| `PR_DM_SYS_LOG_BATCH` / `PR_SCM_SYS_LOG_BATCH` | PROCEDURE | VALID | 저장 로그 |
| `DM_MST_ITEM_SINGLE_V` | VIEW | VALID | 아이템 조인 |

> `90_VERIFY.sql` **V10** 이 이 축을 기계로 확인한다. `PKG_DMF0044` 가 빠지면 V4 가 `FAIL-A` 로 적출한다.
> ⚠ 본 패키지는 `PKG_DMF0044` 본문을 **동봉하지 않는다** — DMF0044 는 별도 이관 패키지 소관이다.
>   (형제 화면이라 GRANT/시노님/PROC_M 축만 겹쳐 실린다. 전부 멱등이라 중복 적용은 무해하다.)

---

## 3. 2026-08-20 사내 적용분 — 본 패키지에 반드시 포함된 것

### 3-1. DDL — `DEFAULT ON NULL` (`A_DB/01`)

사용자 확정: *"TABLE 내 NOT NULL COLUMN 의 경우 DEFAULT ON NULL 설정"*.

- 사내 적용 완료분: `DM_PLN_SALES_ETC_REPORT_C` / `_H` 의 **QTY → `DEFAULT ON NULL 0`**
  (`ALTER TABLE ... MODIFY (QTY DEFAULT ON NULL 0)`).
- VARCHAR2 NOT NULL **10 컬럼 × 2 표**는 사내에 **이미 `DEFAULT ON NULL '-'`** 로 적용돼 있었으나
  **클라우드는 미확인** → `ALL_TAB_COLUMNS.DEFAULT_ON_NULL` / `DATA_DEFAULT` 를 **실측해 그대로** 멱등 DDL 로 동봉했다.
  대상 컬럼 목록도 실측 산출이다(추정 금지).
- 멱등 가드: `DEFAULT_ON_NULL='YES'` 면 `ALTER` 를 건너뛴다 → 이미 적용된 환경에서도 무해.

**대상 22 컬럼 (표당 11)**

| 표 | 컬럼 | 기본값 |
|---|---|---|
| `DM_PLN_SALES_ETC_REPORT_C` · `_H` | `VERSION_NO` `DIVISION_ID` `CUTOFF_TYPE` `CUTOFF_YYYYMMDD` `DEPARTMENT_ID` `DEPT_ID` `ITEM_ID` `MEASURE` `YYYYMMDD` `CURRENCY` | `'-'` |
| 〃 | `QTY` | `0` |

**⛔ 의도적 제외 (사유 = 조용한 오류 은폐 방지)**

- `DATA_SEQ` / `HISTORY_SEQ` — 키·시퀀스. 기본값 `0` 을 주면 **PK 충돌·유령행을 조용히 만든다.**
  비면 지금처럼 즉시 실패해야 한다.
- 감사컬럼 4종 `CREATED_BY` / `CREATION_DATE` / `LAST_UPDATED_BY` / `LAST_UPDATE_DATE` — 확정 제외 계보.
  누가 언제 넣었는지가 비면 그건 배선 결함이지 기본값으로 덮을 대상이 아니다.
- 숫자 컬럼에 `'-'` 는 불가하므로 `QTY` 만 `0` (hook #119 §1.5 규약). AS-IS 도 수치 빈 셀을 0 으로 강제한다.
- `90_VERIFY.sql` **V6c** 가 이 제외축이 그대로 `DEFAULT_ON_NULL='NO'` 인지 역검증한다.

### 3-2. SP — `PKG_DMF0049` BODY `[E20260820-DIVIDSCALAR]` **3곳**

**결함**: `p_division_id` 는 `'^'` 벌크 원문(`"40^40^40…"`)인데 **스칼라 비교**에 쓰이고 있었다.

| 위치 | 구 코드 | 증상 |
|---|---|---|
| L1030 | `WHERE DIVISION_ID = p_division_id;` | `GT_DMF0049_TEMP_ITEM_SINGLE` 이 2행 이상 payload 에서 **항상 0행** → 이후 UPDATE 가 `NICK_NAME` / `FORECAST_INFO_SPEC` / `FORECAST_INFO_CELL_PACK_COUNT` 를 **저장할 때마다 NULL 로 덮어씀**(nullable 이라 에러 없이 조용히) |
| L1058 / L1063 | `CASE WHEN p_division_id = '40'` | 40 "기타부서" fallback 이 **영구 무효** |

**정정**: 같은 SP 가 L932 에서 GTT 대표행으로 이미 확보한 **파싱값 `v_division_id`** 로 교체.
산출물: `_artifacts/_apply_corporate/DMF0049_SPFIX_20260820/`.

> 검증: `90_VERIFY.sql` **V3**(마커 3) + **V3b**(구세대 리터럴 잔존 역판정 0행).
> ⚠ 이 결함은 **에러를 내지 않는다**. 화면에서 부가정보가 사라지는 형태로만 드러나므로 기계 검증이 필수다.

### 3-3. 메타 — `SCM_MST_SHEET_COLUMNS` `INPUT_TP_CD` **40 행 분리**

`PROGRAM_ID='DMF0049'` / `SHEET_NAME='MDF Reports'` 3 컬럼을 division 40 축만 개방했다.

| 컬럼 | 40 | 비-40 (`82,81,81_UC,81_HM,81_ST,81_HD,81_HG`) |
|---|---|---|
| `DEPARTMENT_ID` | `M` (전 행 편집, 필수) | `IM` 유지 (신규행만) |
| `DEPT_ID` | `O` (전 행 편집, 선택) | `IO` 유지 (신규행만) |
| `CUST_REPORT` | `O` (40 전용 행) | — |

- 근거: AS-IS `DMF0049_Sales_ETC_Reports.cs` `EditButton` **L396~406** — 40 분기는 정적 3컬럼을
  **잠그지 않는다**(기존행도 편집 가능). 비-40 은 L409 에서 정적 전 컬럼 잠금.
- ⚠ 비-40 을 `'S'`(전면 잠금)로 바꾸면 81/82 의 **신규행 입력까지** 막혀 AS-IS `InsertRow` 가 회귀한다.
  요구는 "40 기존행 개방"이지 "비-40 잠금 강화"가 아니다 → **비-40 행은 손대지 않았다.**
- 산출물·백업: `_artifacts/_apply_corporate/DMF0049_META_EDIT40_20260820/`
  (`BACKUP_before_20260820.json` = 변경 전 3행 원본).
- 본 패키지의 `22_SHEET_META_SYNC.sql` 덤프에 **이미 반영**돼 있다. 검증 = `90_VERIFY` **V7** (5행 PASS).

### 3-4. FE (`nscm-fe/features/demand/src/pages/etc-sales-reports/`)

| 항목 | 파일 |
|---|---|
| Report Type · Plan/Result 변경 시 초기화 | `EtcSalesReports.tsx` / `components/EtcSalesReportsForm.tsx` |
| 소수점 **메타(`DATA_SCALE_NUMBER`) 구동 3자리** (0 은 빈칸 유지) | `etc-sales-reports.constants.ts` (`dataScaleOf`) / `components/EtcSalesReportsGrid.tsx` |
| 저장 성공 **Toast** + 스피너 · 연타 차단 | `EtcSalesReports.tsx` |
| 병합 `activeSetKey` (클릭한 세트만 분리) | `utils/etc-sales-reports.merge.ts` |
| 저장 빌더 `staticChanged` (정적 컬럼만 수정해도 저장 — MSG00676 오탐 정정) | `utils/etc-sales-reports.save.ts` |

---

## 4. ⚠⚠ 공유 시트 `'MDF Reports'` — DMF0044 와 공유

`SCM_MST_SHEET_COLUMNS` / `SCM_MST_SHEET_MEASURE` 의 `SHEET_NAME='MDF Reports'` 는
**DMF0044(Sales Reports) 와 DMF0049 가 함께 쓰는 시트**다 (`PROGRAM_ID` 로만 구분).

시트 메타 동기화 규약(hook #98 §9)은 **SHEET_NAME 단위 삭제 후 전체 재적재**이므로,
`22_SHEET_META_SYNC.sql` 은 **DMF0044 행까지 전량 동봉**한다.

| 표 | 총행 | 분해 |
|---|---:|---|
| `SCM_MST_SHEET_COLUMNS` | **90** | DMF0044 = 46 / DMF0049 = 44 |
| `SCM_MST_SHEET_MEASURE` | **21** | DMF0044 = 18 / DMF0049 = 3 |

- ⛔ DMF0049 행만 넣으면 **DMF0044 화면이 전멸**한다. 삭제 범위 = 삽입 범위 원칙.
- ⛔ `SHEET_NAME` 개명 금지(룰 #91). PKG LIVE 대입 실측: `P_PROGRAM_ID := 'DMF0049'` / `P_SHEET_NAME := 'MDF Reports'`.
- ⚠ **DMF0044 이관 패키지도 같은 시트를 담는다.** 두 패키지를 모두 적용할 경우
  **나중에 적용된 쪽이 최종**이 된다. 둘 다 같은 시점(2026-08-20) 사내 덤프라면 결과는 동일하다.
  시점이 다르면 **더 최신 덤프를 후행 적용**할 것.
- `90_VERIFY` **V8b** 가 DMF0044 행 보존(46/18)을 확인한다 — 0 이면 잘못 적용한 것이다.

### `SCM_MST_TITLESET_USER` = 이관 제외

사내 실측 `PROGRAM_ID='DMF0049'` → `MDF Reports` 30행 + `mdfReports` 34행 = **64행**.
**사용자 개인화 데이터**이므로 이관하지 않는다(사용자 지시). 클라우드 사용자별로 새로 쌓인다.

---

## 5. 축별 실측 카운트 (2026-08-20 사내)

| 축 (테이블) | 카운트 | 비고 |
|---|---:|---|
| `SCM_ADM_MNU_M` | **1** | ⭐ 없으면 권한 뷰 0행 → 조회 조용히 전멸 |
| `SCM_ADM_PROGRAM` | **1** | |
| `SCM_ADM_API_M` | **19** | 버튼 역추적 (`API_ID LIKE 'DMF0049_%'` 와 동수) |
| `SCM_ADM_MNU_BTN_MPG_M` | **19** | 5시트: MDF Reports 10 / unitedVersion 5 / titleSet 2 / measure 1 / spreadTitle 1 |
| `SCM_ADM_USER_GR_MNU_MPG_M` | **4** | ⭐ ADMIN / DM ADMIN / DM Planner / DM Viewer |
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | **70** | 3그룹 × 19 + DM Viewer 13 |
| `SCM_ADM_PROC_M` | **119** (11 SP) | ⭐⭐ 누락 = PLS-00306 |
| `SCM_ADM_CMBO_SQL_M` | **22** 종 / 22행 | |
| `SCM_MST_SHEET_COLUMNS` (`MDF Reports`) | **90** | DMF0044 46 + DMF0049 44 |
| `SCM_MST_SHEET_MEASURE` (`MDF Reports`) | **21** | DMF0044 18 + DMF0049 3 |
| `SCM_ADM_MSG_M` | **72** (24코드×3언어) | 신규 채번 0 |
| `SCM_ADM_EXCEL_COLUMNS` | **0행** | Excel Upload 미보유 화면 — §6 |
| GTT (`GT_DMF0049_*`) | **6** | PJT 4 / RESULTS_MST 45 / RESULTS_MST_PRICE 36 / SELECT_MEASURE 5 / T 48 / TEMP_ITEM_SINGLE 9 (컬럼수) |
| GTT INDEX | **0행** | 본 화면 GTT 에는 인덱스가 없다 |
| 사용자 정의 TYPE | **0행** | `ALL_DEPENDENCIES` 실측 — 참조 없음 |
| SEQUENCE | **1** | `SEQ1_DM_PLN_SALES_ETC_REPORT_H` |
| EXECUTE GRANT | **20** | 10 객체 × (SCMD_APP, SCMP_APP) |
| SYNONYM | **21** | 10 객체 × 2 + 시퀀스(SCMP_APP 만 — 사내 실측 그대로) |
| 표 DML GRANT | **8** | SCMD_APP × 2표 × (S/I/U/D) |
| `PKG_DMF0049` BODY 마커 | **3** | `E20260820-DIVIDSCALAR` |

### PROC_M 11 SP 내역 (인자수 = `ALL_ARGUMENTS` 실측과 1:1 일치)

| SP | PROC_M | ARGS |
|---|---:|---:|
| `DMF0002_GET_TITLESET_POPUP` | 7 | 7 |
| `PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE` | 8 | 8 |
| `PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_POPUP` | 9 | 9 |
| `PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE` | 6 | 6 |
| `PKG_DMF0044.P_DMF0044_SAVE_BIZ_PLAN_VERSION_COPY` | 6 | 6 |
| `PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY` | 9 | 9 |
| `PKG_DMF0049.P_DMF0049_GET_MEASURE` | 5 | 5 |
| `PKG_DMF0049.P_DMF0049_GET_SALES_ETC_REPORTS_DATA` | 10 | 10 |
| `PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE` | 8 | 8 |
| `PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C` | 37 | 37 |
| `SCM0002_SET_TITLESET_POPUP` | 14 | 14 |

> 2026-08-20 DMF0035 에서 `SCM_ADM_PROC_M` 축이 **메타 sync 목록에 처음부터 없어** 통째 누락 → PLS-00306
> 실사고가 났다. 본 패키지는 그 계보를 반영해 `24_PROC_M_SYNC.sql` 을 필수 파일로 둔다.

### 콤보 22종 (축 = FE LIVE grep ∪ 시트 메타 `CELL_COMBO_DATA_TYPE` ∪ `SQL_ID LIKE '%DMF0049%'`)

`APPLICATION` `CALENDAR_YYYY` `COUNTRY_MST` `CurrencyList` `DMF0005_REPORT_GROUP1`
`DMF0005_REPORT_GROUP2` `DMF0005_REPORT_GROUP4` `DMF0005_REPORT_GROUP6`
`DMF0044_DEPARTMENT_TEAM` `DMF0044_DEPARTMENT_TEAM2` `DMF0044_MDF_DEPARTMENT` `DMF0044_MDF_MEASURE`
`DMF0049_DEPARTMENT_TEAM` `DM_COMPANY` `DM_LOOKUP_DIV` `END_CUST_REPORT`
`EndCustomerByDivisionDept` `FcstType` `Incoterms` `MDF_TYPE` `ReportGroup3` `SOLD_TO_CUST_REPORT`

- 미등록 **0종** (전부 사내 실존).
- ⚠ 대부분 **공유 콤보**다 — 클라우드 본문(`SQL_DTL_CTN`)이 사내와 다르면 MERGE 가 덮어쓴다.
  DMF0044 와 겹치는 축이 많으나 멱등이라 중복 적용은 무해하다.

---

## 6. 0행 축 (명기 — "안 본 축" 이 아니라 "보고 0행이었던 축")

| 축 | 실측 | 판정 |
|---|---:|---|
| `SCM_ADM_EXCEL_COLUMNS` (`PROGRAM_ID='DMF0049'`) | 0 | Excel **Upload 미보유** 화면. `DMF0049_main_EXCEL` 버튼은 조회 SP(`P_DMF0049_GET_SALES_ETC_REPORTS_DATA`)에 배선된 **그리드 내보내기 전용**이고, Upload 계약(`P_MODE` 0/1) SP 가 없다 → hook #135 2단 Upload 대상 아님 |
| `SCM_ADM_EXCEL_COLUMNS` (`SHEET_NAME='MDF Reports'`) | 0 | 동상 |
| GTT INDEX (`GT_DMF0049_*`) | 0 | 인덱스 미보유 |
| 사용자 정의 TYPE 의존 | 0 | `ALL_DEPENDENCIES` `REFERENCED_TYPE='TYPE'` 0행 |
| 타 스키마 의존 | 0 | 전부 `SCM_MGR` 소유 (`SYS`/`PUBLIC` 표준 제외) |
| `nscm-be` 내 `DMF0049` grep | 0 | 화면 전용 BE 코드 없음 (generic call-proc) |
| `ALL_ERRORS` (`PKG_DMF0049`) | 0 | 컴파일 오류 없음 |

---

## 7. 미결 · 판단 필요

1. **클라우드 저장 SQL 오류 원인 미확정** — 클라우드에서 보고된 저장 실패의 근본 원인이 아직 확정되지 않았다.
   확정에는 클라우드 `SCM_SYS_LOG_BATCH` 의 **ERROR 원문**이 필요하다(사내 실측상 해당 표 실존:
   `SCM_SYS_LOG_BATCH` / `SCM_SYS_LOG_BATCH_INF`). 본 패키지의 `01_DDL`(NOT NULL 기본값)과
   `11_PKG BODY`(DIVIDSCALAR) 가 후보 원인 2종을 덮지만, **원문 확보 전에는 해결 선언 금지**다.
   → 클라우드 적용 후 재현 시 `SCM_SYS_LOG_BATCH` ERROR 원문을 먼저 확보할 것.
2. **`PKG_DMF0000` BODY 가 사내에서 `INVALID`** (LAST_DDL 2026-07-27).
   단 `ALL_ERRORS` 는 **0행**이므로 컴파일 오류가 아니라 **의존 변경에 의한 stale invalidation** 이며
   최초 호출 시 자동 재컴파일된다. 그래도 클라우드 적용 후 `ALTER PACKAGE SCM_MGR.PKG_DMF0000 COMPILE BODY`
   로 선제 해소하는 편이 안전하다(`unitedVersion` TITLE 버튼 경로). **DMF0049 소관 밖 — 판단 필요.**
3. **`features/master` 공용 컴포넌트 3본이 작업 트리에 수정돼 있으나 DMF0049 작업분이 아니다**
   (`ColumnLayoutModal.tsx` shim 화 / `columnLayoutModal.utils.ts` / `SearchFields.tsx`).
   본 패키지에 **의도적으로 미포함**. 동봉 여부는 소관 담당 판단 — `B_FE/_IMPORT_CLOSURE.md` §2 참조.
4. **`C_BE` 는 "변경 없음"이 아니다.** 공용 titleSet 엔드포인트 2종이 HEAD 에 없어 동봉했다.
   공유 파일이므로 **덮어쓰기 금지, diff 병합 필수** — `C_BE/_BE_CHANGE.md` §4.
5. **런타임 스모크 미실시** — 본 작업은 패키지 파일 생성만 수행했다.
   화면 실검증 항목은 `90_VERIFY.sql` **V11** 에 7항목으로 남겼다.

---

## 8. 90_VERIFY 사내 실행 결과 (2026-08-20 — 전 항목 PASS)

| 항목 | 결과 |
|---|---|
| V1 PKG STATUS | PACKAGE 89 lines VALID / PACKAGE BODY 1,224 lines VALID |
| V1b INVALID | **0** |
| V2 `ALL_ERRORS` | **0행** |
| V3 마커 `E20260820-DIVIDSCALAR` | **3 / 3 → PASS** |
| V3b 구세대 리터럴 잔존 | **0행** |
| V4 PROC_M 적출 | **0행** ✅ |
| V4b 전량 대조 | **11행 전부 PASS** |
| V5a 메뉴 행 | 1행 / `UNIT_TP_CD='D'` / `USE_YN='Y'` → PASS |
| V5b 라우팅 | `Demand_Plan` / `etc-sales-reports` / `demand/demand-plan/etc-sales-reports` / `MNU00039` / SORT 7 |
| V5c 권한 뷰 (minyonglee1) | **8행 → PASS** |
| V6 DEFAULT ON NULL 적출 | **0행** |
| V6b 카운트 | `_C` 11/11 PASS · `_H` 11/11 PASS |
| V6c 제외축 역검증 | 11행 전부 `NO` → PASS |
| V7 `INPUT_TP_CD` 40 분리 | **5행 전부 PASS** |
| V8 메타 축 카운트 | 10축 전부 EXPECT 일치 (1/1/19/19/4/70/119/22/72/0) |
| V8b 시트 메타 | COLUMNS DMF0044=46, DMF0049=44 / MEASURE DMF0044=18, DMF0049=3 |
| V8c MEASURE 3행 | SalesAmt_LOC(10) · SalesAmt_KRW(30) · RTF_SYS_RP(90) |
| V9a GTT | 6 / 6 PASS |
| V9b GTT 컬럼수 | 4 / 45 / 36 / 5 / 48 / 9 |
| V9c SEQUENCE | 1 / 1 |
| V9d EXECUTE GRANT | 20 / 20 |
| V9e SYNONYM | 21 / 21 |
| V9f 표 DML GRANT | 8 / 8 |
| V10 의존 객체 | 13행 — `PKG_DMF0000` BODY 만 INVALID (§7-2) |

> 실행 방식: `90_VERIFY.sql` 의 SELECT 문을 사내 `SCM_MGR@OCGSCMD_P01` 에서 전량 실행.
> ⛔ DDL/DML 은 실행하지 않았다.

---

## 9. 생성 방법 재현

```bash
python _artifacts/_deploy_packages/DMF0049_CLOUD_20260820/_generate_db_files.py
```

- `A_DB/` 의 `01/02/03/10/11/20/21/22/23/24/25` 를 사내 라이브에서 **재덤프**한다 (SELECT only).
- `30_GRANT_SYNONYM.sql` / `90_VERIFY.sql` 은 수기 작성 파일이라 생성기가 건드리지 않는다.
- PKG 파일에는 **자기검증 assert** 가 걸려 있다:
  헤더 주석에 `PACKAGE` / 마커 리터럴이 들어가면 즉시 실패한다.
  (2026-08-20 실사고 — 헤더 주석의 "PACKAGE BODY" 문자열로 자르는 실행기 때문에 `CREATE OR REPLACE` 가
  주석에 먹혀 실행 불가였다. 토큰 최초 출현이 `CREATE OR REPLACE` 보다 뒤인지 위치로 검증한다.)
