# DMF0044 Sales Reports — 클라우드 이관 패키지 (2026-08-20)

> **상태: 클라우드 미적용.** 본 패키지는 **파일 생성만** 수행했다.
> 사내(SCM_MGR@100.65.143.121:1521/OCGSCMD_P01)에서는 **SELECT 만** 실행했고,
> DDL/DML 은 사내·클라우드 어디에도 실행하지 않았다.
>
> 정본 = **사내 라이브** (`ALL_SOURCE` / 딕셔너리 실측). 누적 패치 조합이 아니다.

| 항목 | 값 |
|---|---|
| 화면 | DMF0044 Sales Reports (`demand/demand-plan/sales-reports`) |
| PKG | `SCM_MGR.PKG_DMF0044` — SPEC VALID / BODY VALID (LAST_DDL 2026-08-20 19:17:48) |
| 덤프 시점 | 2026-08-20 (사내 라이브) |
| 패키지 구조 정본 | `_artifacts/_deploy_packages/DMF0035_CLOUD_20260820/` |
| 산출물 | A_DB 12본 / B_FE 34본 / C_BE 6본 |

---

## 1. 본 패키지에 담긴 2026-08-20 당일 사내 적용분

### 1.1 DB — `PKG_DMF0044` BODY (A_DB/11)

라이브 `ALL_SOURCE` 원문에 아래 4계열이 들어 있다. 마커 카운트는 90_VERIFY V2 가 기계 검증한다.

| 마커 | 건수 | 내용 | BODY 위치(파일 라인) |
|---|---:|---|---|
| `E20260820-CFMERGE` | 2 | Cutoff 저장 MERGE 의 대상표 필터를 `UPDATE WHERE` → **`ON` 절로 이동** | 6229 / 6240 |
| `E20260820-CFSETBASED` | 2 | 행별 ROWID 커서 루프 2블록 → **등가 set-based MERGE 2문** | 4929 / 4945 |
| `E20260820-CFNOSTATS` | 1 | 저장 SP 본문의 `DBMS_STATS.GATHER_TABLE_STATS` **제거** (`GT_0044_RESULTS_MST_C` 대상 1건) | 4966 |
| `E20260820-EXAUTH` | 4 | 환율 팝업 권한 뷰 `INNER JOIN` → **`LEFT JOIN`** (4지점, `P_DIVISION_ID='ALL'` UNION ALL 분기 포함) | 1959 / 1988 / 2112 / 2141 |

- CFMERGE / CFSETBASED / CFNOSTATS = `P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF`
- EXAUTH = `P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP` (2) + `..._POPUP_DATA` (2)
- 산출물 계보: `_artifacts/_apply_corporate/DMF0044_SPFIX_20260820/`
  (`00_BACKUP_*_LIVE.sql` 적용 전 백업 / `02_POSTAPPLY_LIVE_BODY.sql` 적용 후 덤프)

> ⚠ **CFNOSTATS 검증 시 오탐 주의** — PKG 전체에는 다른 SP 소관의 `GATHER_TABLE_STATS` 호출이
> **사내 실측 10건 정상 잔존**한다. 그래서 90_VERIFY V2-5 는 프로시저 구간으로 잘라서 0을 확인한다.
> "PKG 전체 0건" 으로 세면 무조건 FAIL 이 나오는 오탐이다.

### 1.2 메타 — `EXRATE_SAVE` 신규 버튼 (A_DB/20 에 포함)

| 테이블 | 행 | 내용 |
|---|---:|---|
| `SCM_ADM_MNU_BTN_MPG_M` | 1 | `MNU_ID=DMF0044 / SHT_NM=exchangeRate / MNU_BTN_CD=EXRATE_SAVE / API_ID=NULL` |
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | 2 | `ADMIN` / `DM ADMIN` |

- `API_ID=NULL` 이 **정상**이다 — 라우팅이 아니라 FE `hasButton('EXRATE_SAVE')` **권한 판정 전용** 행이다.
- ⚠ 기존 `exchangeRate` / `SAVE` 행(`API_ID=DMF0044_exchangeRate_SAVE`)은 **라우팅 담당이라 유지**해야 한다.
  삭제 금지 — 90_VERIFY **V6-3** 이 이 행의 생존을 적출한다.
- `DM Viewer` 는 부여 대상이 아니다(사내 실측 2행). hook `button-auth-sheet-scope-gap` 계보 —
  `hasButton` 이 메뉴 단위 합집합이라 시트별로 못 가르는 문제를 **별도 버튼 코드**로 분리해 해결한 것.
- 산출물 계보: `_artifacts/_apply_corporate/DMF0044_EXRATE_AUTH_20260820/apply_exrate_btn.py`

### 1.3 FE (B_FE)

`features/demand/src/pages/sales-reports/` 8건:

1. Report Type 변경 시 그리드 초기화 (`onReportTypeChange`)
2. 저장 스피너 · 연타 차단 (`saving` / `savingRef` + `ProgressIndicator`)
3. 음수 빨강 (`paintNegative`)
4. 모달 6종 **조건부 마운트** + 그리드 `memo`
5. 붙여넣기 병합 전파 (`capturePasteRange` / `propagatePaste`)
6. 소수점 **메타 구동** (`scaleOf` / `DATA_SCALE_NUMBER`)
7. 환율 편집 권한 `hasButton('EXRATE_SAVE')`
8. (위 1~7 에 수반된) 저장 페이로드·editLock·gridCombos 정합

---

## 2. 적용 순서

```
[0] A_DB/00_CLOUD_PRECHECK.sql     ← 클라우드에서 먼저 실행. C1~C8 을 사내값과 대조.
                                      차이 나는 축은 §5 에 기록하고 판단 후 진행.
[1] A_DB/01_DDL_GTT.sql            (SCM_MGR)   GTT 18본 멱등 생성
[2] A_DB/02_DDL_GTT_INDEX.sql      (SCM_MGR)   ⚠ 0행 축 — 실행할 DDL 없음(파일은 증빙용)
[3] A_DB/10_PKG_DMF0044_SPEC.sql   (SCM_MGR)
[4] A_DB/11_PKG_DMF0044_BODY.sql   (SCM_MGR)   ← SPEC 다음. 단독 실행.
[5] A_DB/18_GRANT_SYNONYM.sql      (GRANT=SCM_MGR / SYNONYM=DBA)
[6] A_DB/20_MENU_META_SYNC.sql     (SCM_MGR)
[7] A_DB/21_CMBO_SYNC.sql          (SCM_MGR)   ← C4 diff 확인 후. 충돌 콤보는 주석 처리.
[8] A_DB/22_SHEET_META_SYNC.sql    (SCM_MGR)   ← C5 확인 후. 공유 시트 삭제 범위 주의.
[9] A_DB/23_MSG_LBL_MNU_SYNC.sql   (SCM_MGR)
[10] A_DB/24_PROC_M_SYNC.sql       (SCM_MGR)   ← §1 은 항상. §2 는 C6 이 "실행 필요" 일 때만.
[11] A_DB/25_EXCEL_COLUMNS_SYNC.sql            ⚠ 0행 축 — 실행할 DML 없음(파일은 증빙용)
[12] B_FE  폴더 복사 → pnpm build
[13] C_BE  파일 복사 → ./gradlew build (BE 재기동)
[14] A_DB/90_VERIFY.sql            (SCM_MGR)   ← FAIL 0 확인. WARN 1건은 §5 M1 참조.
```

### PKG 파일 형식 (실행 사고 방지)

`10` / `11` 은 아래 순서를 지킨다.

```
-- 헤더주석 (마커 리터럴 금지 · "PACKAGE BODY" 문자열 금지)
SET DEFINE OFF
SET SQLBLANKLINES ON
CREATE OR REPLACE PACKAGE BODY  "PKG_DMF0044" IS ...
/
SHOW ERRORS
```

> ⚠ **2026-08-20 실사고**: 헤더 주석 안에 `PACKAGE BODY` 문자열이 있으면, 그 문자열로 자르는 실행기가
> `CREATE OR REPLACE` 를 주석에 먹여 **실행 불가**로 만든다.
> 생성기(`_generate_db_files.py`)가 두 가지를 assert 로 강제한다:
> ① 주석·`SET` 제외 **첫 실행 라인 = `CREATE OR REPLACE PACKAGE [BODY]`**
> ② 선행 주석 블록에 `PACKAGE BODY` 리터럴 없음
> 또 마커 리터럴을 헤더에 넣지 않는다 — 실행기가 선행 주석을 statement 에 함께 넘기면
> `ALL_SOURCE` 에 섞여 마커 카운트가 어긋난다.

---

## 3. 축별 실측 카운트 (사내 SCM_MGR, 2026-08-20/21)

> ⚠ 합계만 적으면 빠진 축이 안 보인다 — **축 이름과 함께** 본다.
> 아래 값은 전부 `90_VERIFY.sql` 을 사내에서 실제 실행해 나온 값이다(§6).

### 3.1 DB 객체

| 축 | 사내 실측 | 파일 |
|---|---:|---|
| GTT (DDL) | **18** | `01_DDL_GTT.sql` |
| GTT INDEX | **0** ⚠ | `02_DDL_GTT_INDEX.sql` (0행 명기) |
| PKG SPEC | 1 (59행) | `10_...SPEC.sql` |
| PKG BODY | 1 (9,373행) | `11_...BODY.sql` |
| GRANT (SCMD_APP·SCMP_APP EXECUTE) | **2** | `18_GRANT_SYNONYM.sql` |
| SYNONYM (SCMD_APP·SCMP_APP) | **2** | `18_GRANT_SYNONYM.sql` |

GTT 18본 축 확정 = **소스 grep(주석 제거 LIVE) 18 ∩ `ALL_DEPENDENCIES` 18 = 완전 일치**, 딕셔너리 실존 18.
(`GT_0044_*` 5 / `GT_DMF0044_*` 2 / `GT_DMF0_*` 5 / `GT_F044_*` 6)

### 3.2 메타 (딕셔너리 기계 전수 스윕)

스윕 방식 = `SCM_MGR` 의 `PROGRAM_ID`/`MENU_ID`/`MNU_ID`/`UI_ID`/`SCREEN_ID` 컬럼 보유
**테이블-컬럼 54종 전수** → `'DMF0044'` 행 카운트 → HIT **14축**.
(손나열 금지 — 2026-08-14 BTN 축 조용한 스킵 계보)

| 축 | 사내 실측 | MERGE ON 키 (PK 실측) | 파일 |
|---|---:|---|---|
| `SCM_ADM_MNU_M` | **1** | `MNU_ID` | 20 |
| `SCM_ADM_PROGRAM` | **1** | `PROGRAM_ID` | 20 |
| `SCM_ADM_API_M` | **28** | `API_ID` | 20 |
| `SCM_ADM_MNU_BTN_MPG_M` | **29** | `MNU_ID, SHT_NM, MNU_BTN_CD` | 20 |
| `SCM_ADM_USER_GR_MNU_MPG_M` | **3** | `USER_GR_ID, MNU_ID` | 20 |
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | **77** | `USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD` | 20 |
| `SCM_ADM_CMBO_SQL_M` | **23** | `SQL_ID` | 21 |
| `SCM_MST_SHEET_COLUMNS` | **114** (시트 3종 전량) | (SHEET_NAME 단위 DELETE→INSERT) | 22 |
| `SCM_MST_SHEET_MEASURE` | **21** (시트 1종 전량) | (동) | 22 |
| `SCM_ADM_MSG_M` | **102** (34코드 × 3언어) | `MSG_ID, LANG_CD` | 23 |
| `SCM_ADM_PROC_M` §1 본화면 | **151** (15 SP) | `PROC_NM, COL_NM, COL_TP_CD` | 24 |
| `SCM_ADM_PROC_M` §2 공유·조건부 | **29** (3 객체) | (동) | 24 |
| `SCM_ADM_EXCEL_COLUMNS` | **0** ⚠ | — | 25 (0행 명기) |

`MNU_BTN_MPG_M` 29 vs `API_M` 28 의 차이 1 = `EXRATE_SAVE`(`API_ID` NULL). **정상**이다.

#### 시트 메타 상세 (공유 시트 — 삭제 범위 = 삽입 범위)

| 테이블 | SHEET_NAME | 전량 | PROGRAM_ID 분해 |
|---|---|---:|---|
| `SCM_MST_SHEET_COLUMNS` | `MDF Reports` | 90 | DMF0044 **46** + DMF0049 44 |
| `SCM_MST_SHEET_COLUMNS` | `MDFVerpopup` | 20 | DMF0041 8 + DMF0044 **12** |
| `SCM_MST_SHEET_COLUMNS` | `exchangeRate` | 4 | DMF0044 **4** |
| `SCM_MST_SHEET_MEASURE` | `MDF Reports` | 21 | DMF0044 **18** + DMF0049 3 |

DMF0044 소유분 합계 = SHEET_COLUMNS 62 / SHEET_MEASURE 18.

#### PROC_M §1 상세 (PROC_M 행수 = `ALL_ARGUMENTS` 인자수, 15/15 일치)

| SP | 행 | SP | 행 |
|---|---:|---|---:|
| `P_DMF0044_GET_SALES_REPORTS_DATA` | 11 | `P_DMF0044_SAVE_SALES_PLAN_REPORT_C` | 22 |
| `P_DMF0044_GET_SALES_VERSION_POPUP` | 9 | `P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF` | 24 |
| `P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP` | 8 | `P_DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT` | 10 |
| `P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA` | 8 | `P_DMF0044_SAVE_TEXTBOX` | 17 |
| `P_DMF0044_GET_TEXTBOX` | 7 | `P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY` | 9 |
| `P_DMF0044_GET_SPREAD_TITLE` | 6 | `P_DMF0044_SAVE_BIZ_PLAN_VERSION_COPY` | 6 |
| `P_DMF0044_GET_MEASURE` | 5 | `P_DMF0044_MOBILE_REPORT_CREATE` | 6 |
| `P_DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE` | 3 | **합계** | **151** |

§2 공유 3본: `DMF0002_GET_TITLESET_POPUP` 7 / `PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE` 8 /
`SCM0002_SET_TITLESET_POPUP` 14 = 29행. **기본 주석 처리**(타 화면 소관 공유 축).

#### 콤보 23종 축 (양축 합집합)

FE grep 8종 + 시트 메타 `CELL_COMBO_DATA_TYPE` 15종 (센티널 `' '` 제외), 합집합 23 — 전부 사내 등록 확인.

```
APPLICATION  CALENDAR_YYYY  COUNTRY_MST  CUST_GROUP_DTL  CurrencyList
DMF0005_REPORT_GROUP1/2/3/4/6  DMF0044_DEPARTMENT_TEAM  DMF0044_DEPARTMENT_TEAM2
DMF0044_ETC_SALE_RESULT_TYPE_40  DMF0044_MDF_MEASURE  DM_COMPANY  DM_LOOKUP_DIV
Division  DmBizType  END_CUST_REPORT  FcstType  MDF_TYPE  MDF_TYPE2  SOLD_TO_CUST_REPORT
```

#### MSG/LBL/MNU 34코드 축

- ① FE 폴더 전수 grep 중 **주석 제거 LIVE 30종** (hook #138 — 주석은 근거가 아니다)
- ② 공통 UI 경로 1종 `MSG00703` (`@shared` `useDirtyRegistry` 화면 닫기 confirm)
- ③ `MNU_M.MNU_MSG_ID` 3종 — `MNU00038`(DMF0044) / `MNU00011`(Demand_Plan) / `MNU00002`(Demand)
- **주석에만 등장하여 제외한 6종**: `LBL00513` `LBL00605` `LBL00665` `MSG00142` `MSG00281` `MSG00321`
- 34코드 전부 3언어 완비(102행). 신규 채번 없음 — 전부 기존 코드 재사용.

### 3.3 FE / BE

| 축 | 건수 |
|---|---:|
| B_FE 페이지 폴더 (`sales-reports/`) | 22 파일 / 3,829행 |
| B_FE out-of-page 폐포 | 8 파일 / 2,040행 |
| B_FE `configs/types/procedures.d.ts` | 1 파일 / 4,273행 |
| B_FE locales 발췌 (KO/EN/CN) | 3 파일 / 각 34코드 |
| C_BE | 6 파일 / 467행 |

---

## 4. 이관 **제외** 축 (명기 — 조용한 스킵 아님)

| 테이블 | 사내 행수 | 제외 사유 |
|---|---:|---|
| `SCM_MST_TITLESET_USER` | **234** (`MDF Reports` 70 / `mdfReports` 164) | 사용자 개인화 데이터 — 이관 대상 아님 |
| `SCM_COM_SYS_LOG` | 985 | 실행 로그 |
| `NSCM_UI_TEMP` / `_0211` / `_0304` | 각 3 | 임시 테이블 |
| `SCM_MST_SHEET_COLUMNS_0408` / `_260408` | 각 58 | 백업 테이블 |

`SCM_ADM_EXCEL_COLUMNS` 는 **0행**이다(제외가 아니라 원래 없음) — `25_EXCEL_COLUMNS_SYNC.sql` 에 명기.
DMF0044 의 `[EXCEL]` 버튼은 조회결과 클라이언트 다운로드이고 **업로드 적재 경로가 없다**
(hook #135 2-Step Upload 대상 아님).

---

## 5. 미결 · 판단 필요 항목

### M1. `PKG_DMF0000` PACKAGE BODY = **INVALID** (사내 실측)

- 본 화면 `unitedVersion` 팝업의 타이틀 경로가 `PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE` 이다
  (`API_M` = `DMF0044_unitedVersion_TITLE`).
- 사내에서 `PKG_DMF0000` BODY 가 **INVALID** 다 (LAST_DDL 2026-07-27). `PROC_M` 8행은 정상.
- **본 패키지 소관 밖**(DMF0000)이므로 손대지 않았다. 90_VERIFY V8-3 은 이를 `WARN` 으로 낸다.
- 판단 필요: 클라우드도 INVALID 면 해당 팝업 타이틀이 실패할 수 있다 → DMF0000 소관으로 별도 처리.

### M2. 공유 콤보 덮어쓰기 범위

- 21_CMBO_SYNC 23종 중 **본 화면 전용은 `DMF0044_*` 4종**뿐이고 나머지 19종은 타 화면과 공유한다
  (`DMF0005_REPORT_GROUP*`, `Division`, `CurrencyList`, `DM_LOOKUP_DIV` 등).
- 클라우드 본문이 사내와 다르면 MERGE 가 **타 화면 회귀**를 만든다.
- → `00_CLOUD_PRECHECK C4` 의 길이/MD5 를 사내값과 대조하고, 차이 나는 `SQL_ID` 는
  해당 MERGE 문을 주석 처리한 뒤 개별 판단할 것. (사내 MD5 는 C4 를 사내에서 재실행해 확보)

### M3. 공유 시트 삭제 범위

- `22_SHEET_META_SYNC.sql` 은 `SHEET_NAME` 단위 `DELETE` → 전체 `INSERT` 다.
- 클라우드의 **DMF0049 / DMF0041 행수가 사내와 다르면 그 차이만큼 소실**된다.
- → `00_CLOUD_PRECHECK C5` 로 클라우드 분해 카운트를 먼저 확인할 것.
  사내: `MDF Reports` COL 46+44 / MSR 18+3, `MDFVerpopup` 8+12, `exchangeRate` 4.

### M4. `24_PROC_M_SYNC.sql` §2 실행 여부

- 공유 3본은 기본 주석 처리했다. `00_CLOUD_PRECHECK C6` 이 `정상 — 손대지 말 것` 이면 실행 금지.
  `0행` 또는 `인자수 불일치` 일 때만 §2 주석을 해제한다.

### M5. C_BE 는 **"변경 없음"이 아니다**

- BE 소스에 `DMF0044` 리터럴은 **0건**이다(generic call-proc 구조). 화면 전용 BE 코드는 없다.
- 그러나 2026-08-20 09:49~09:52 에 추가된 **공용 titleset 엔드포인트 2본이 본 화면의 폐포 안**이다:
  - `POST /admin/menu/{mnuId}/titleset/search` ← 본 화면 Column Setup 모달이 **재진입 복원**에 사용
    (`@shared` `ColumnLayoutModal` → `organisms/data-grid/titleSetApi.fetchTitleSet`)
  - `POST /admin/menu/{mnuId}/titleset` (저장) ← 같은 변경분에 함께 추가됨(원자 적용)
- 이 엔드포인트가 클라우드 BE 에 없으면 **404 → 컬럼 개인화가 복원되지 않는다**(조회 자체는 동작).
- 반면 본 화면의 titleSet **저장**은 화면 전용 `POST /DMF0044/titleSet/SAVE/call-proc` 경로를 쓴다
  (`utils/sales-reports.api.ts` `saveTitleSet`) — 이쪽은 기존 generic 경로라 BE 변경 불필요.
- 판단 필요: 클라우드 BE 가 이미 이 2본을 갖고 있으면 C_BE 는 생략 가능하다.
  확인 = 클라우드에서 `POST /admin/menu/DMF0044/titleset/search` 가 404 인지.
- `dto/TitleSetSearchRequest.java` / `TitleSetSaveRequest.java` 는 **이미 커밋된 파일**이지만
  자급을 위해 동봉했다(덮어써도 동일 내용).

### M6. B_FE out-of-page 폐포의 범위 판단

- 페이지의 out-of-page import 는 alias 15종(`@foundation/*` 8, `@shared/*` 6, `features/master/*` 1)
  + 외부 npm 3종(`react`, `@mescius/wijmo.grid`, `@mescius/wijmo.grid.filter`)이다.
- alias 배럴 전체를 동봉하면 무관한 화면까지 끌고 들어가므로,
  **폐포 ∩ 2026-08-20 세션 변경분 8파일**만 담았다(아래). 나머지 배럴 구성요소는 클라우드 기존재 전제다.
- ⚠ 그중 `mergeManager.ts` / `olap-pivot-grid` 변경은 **DMF0082 / DMF0035 작업분**이다.
  `mergeManager` 는 `allowEmptyCellMerge()` 확장점 추가이고 기본값 `false` = 기존 동작 보존이라
  본 화면 회귀 위험은 없다. 다만 **타 화면 동시 반영**이 되므로 적용 시점을 인지할 것.
- `features/master/.../columnLayoutModal/ColumnLayoutModal.tsx` 는 2026-08-20 정본 단일화로
  **8행짜리 재수출 스텁**이 되었다(정본 = `@shared`). 스텁만 넘기고 `@shared` 정본을 안 넘기면 깨진다 —
  둘 다 동봉했다.

---

## 6. 90_VERIFY 사내 실행 결과 (2026-08-21 실측)

`90_VERIFY.sql` 전 18 statement 를 사내에서 실행했다. **FAIL 0 / WARN 1**.

| 검증 | 결과 |
|---|---|
| V1-1 PKG STATUS | PACKAGE VALID / PACKAGE BODY VALID — **PASS** |
| V1-2 ALL_ERRORS | 0 — **PASS** |
| V2-1~4 마커 | CFMERGE 2/2 · CFSETBASED 2/2 · CFNOSTATS 1/1 · EXAUTH 4/4 — **PASS** |
| V2-5 CF저장SP `GATHER_TABLE_STATS` | 0 — **PASS** |
| V3-1 PROC_M 결손/불일치 적출 | **0행 (적출 없음)** — PASS |
| V3-2 PROC_M 요약 | API_URL 18 / PROC_M 180행 / BAD 0 — **PASS** |
| V4-1 MNU_M | `Demand_Plan` / `D` / `Y` / LV 3 / `demand/demand-plan/sales-reports` — **PASS** |
| V4-2 메뉴 조상 체인 | 3단 전부 `USE_YN='Y'` — **PASS** |
| V4-3 `USER_GR_MNU_MPG_M` | 3 — **PASS** |
| V4-4 권한 뷰 반환 | **63행 (>0)** — PASS |
| V5-01~16 메타 축 16종 | 전부 기대값 일치 — **PASS** |
| V6-1 EXRATE_SAVE 배선 | `API_ID=(NULL)` / `USE_YN=Y` — **PASS** |
| V6-2 EXRATE_SAVE 권한 | 2 (`ADMIN, DM ADMIN`) — **PASS** |
| V6-3 exchangeRate/SAVE 라우팅 유지 | `DMF0044_exchangeRate_SAVE` — **PASS** |
| V7 GTT 18본 컬럼수·DURATION | 18/18 — **PASS** |
| V8-1 GRANT | 2 — **PASS** |
| V8-2 SYNONYM | 2 — **PASS** |
| V8-3 공유 객체 4행 | PROCEDURE 2 VALID · `PKG_DMF0000` SPEC VALID / **BODY INVALID = WARN** (§5 M1) |

`00_CLOUD_PRECHECK.sql` 전 10 statement 도 사내에서 실행해 문법·기대값 baseline 을 확보했다
(C1~C8 전부 정상 반환. C3 은 사내 자기대조라 9축 전부 일치).

---

## 7. 실행하지 않은 것 (전부)

- 사내 DB: **DDL/DML 0건**. `PKG` 재컴파일·`MERGE`·`INSERT`·`DELETE`·`GRANT`·`SYNONYM` 모두 미실행.
  수행한 것은 `ALL_SOURCE` / `ALL_OBJECTS` / `ALL_TABLES` / `ALL_TAB_COLUMNS` / `ALL_DEPENDENCIES` /
  `ALL_ARGUMENTS` / `ALL_CONSTRAINTS` / `ALL_CONS_COLUMNS` / `DBA_TAB_PRIVS` / `ALL_SYNONYMS` /
  `SCM_ADM_*` / `SCM_MST_*` **SELECT 뿐**이다.
- 클라우드 DB: **접속 자체 없음**. `00_CLOUD_PRECHECK` 는 클라우드에서 **아직 실행되지 않았다**
  (§6 의 실행은 사내 대조용).
- git: `add` / `commit` / `push` **미실행**.
- FE/BE: 원본 워킹트리 **무수정**(복사만). `pnpm build` / `gradlew build` 미실행.
