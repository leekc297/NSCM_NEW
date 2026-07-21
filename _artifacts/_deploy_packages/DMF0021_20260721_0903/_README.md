# DMF0021 (Sales Plan) — 클라우드 전체 이관 패키지

> **신규 이관 기준 전체 취합** — FE 화면 전체 + DB 메타 전량(사내 OCGSCMD_P01 실측) + SP/PKG DDL.
> 클라우드 환경에서 DMF0021 을 **처음부터 배포**할 수 있도록 자급 구성. (2026-07-21 최신분석 결재분 반영 포함)

- 화면 ID: **DMF0021** (Sales Plan / 매출계획) · 도메인 `demand` · slug **`sales-plan`**
- Division **40/81/82** 단일 화면 · 원장 = `DM_PLN_SALES_PLAN` (+ `DM_PLN_SALES_ETC_PLAN` 기타매출)
- 근거: `Doc/화면분석서/DMF0021_SalesPlan_UI분석서_v2.1.xlsx` + `제약매트릭스/주요이벤트_상세.md` + FE `__asis-mapping__.md`

---

## 1. 패키지 구성 (fe 21 + sql 7 + sp 6)

```
DMF0021_20260721_0903/
├── fe/features/demand/src/pages/sales-plan/     ← 화면 전체 21파일 + __asis-mapping__.md
│   ├── SalesPlan.tsx / index.ts / *.constants.ts / *.types.ts / useSalesPlanStore.ts (+ .test) / *.module.scss
│   ├── components/  (SalesPlanForm, SalesPlanGrid, SalesPlanModals + modals/MeasureSelectModal)
│   └── utils/       (api / division / editLock / gridCombos / merge / save / validate)
├── sql/                                          ← DB 메타 전량 (멱등 MERGE, 사내 실측)
│   ├── 01_DMF0021_menu_api_button.sql            MNU_M 1 / MNU_BTN_MPG 14 / API_M 14
│   ├── 02_DMF0021_proc_m.sql                     PROC_M 72 (SP positional 시그니처)
│   ├── 03_DMF0021_sheet_columns_measure.sql      SHEET_COLUMNS 67 / SHEET_MEASURE 48 (⭐ FROM_SITE_ID 81행 포함)
│   ├── 04_DMF0021_authority.sql                  USER_GR_MNU 3 / USER_GR_BTN 39
│   ├── 05_DMF0021_combo.sql                      CMBO_SQL_M 22 (⭐ CELL_PROD_SITE_ID·SalesPlanUserAuthGroup 신규)
│   ├── 06_DMF0021_message.sql                    MSG_M 33 (11 ID × KO/EN/CN)
│   └── 07_DMF0021_lookup.sql                     LOOKUP_MASTER 2 / DETAIL 117 (GET_ADMIN_GROUP_MEASURE·SP_CELL_PROD_SITE)
├── sp/                                           ← SP/PKG DDL (CREATE OR REPLACE, 사내 실측)
│   ├── PKG_DMF0021_SPEC.sql / PKG_DMF0021_BODY.sql
│   ├── DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX.sql  (⭐ [E20260512] FROM_SITE_ID 출력 + DEFAULT_FLAG NVL 교정 반영)
│   ├── DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL.sql
│   ├── DMF0021_GET_SALES_PLAN_MEASUREINFO.sql / DMF0021_GET_SPREAD_TITLE.sql (⭐ DEFAULT_FLAG NVL 교정)
│   └── _SP_MANIFEST.md
├── _README.md
└── _COMMON_FILES_GUIDE.md
```

> ⚠ **공유 SP 3종 미포함(클라우드 기존재 가정)**: `PR_GET_DAY_RANGE`(dayRange), `DMF0002_GET_TITLESET_POPUP`·`SCM0002_SET_TITLESET_POPUP`(titleSet). 01 API_M 배선 존재.

## 2. 2026-07-21 최신분석(2026-07-20) 결재분 반영 (전체에 이미 포함)

상세 = `Doc/_archive/work_reports/2026-07-21_DMF0021_approval_reflect.md`.
- **[E20260331-000648]** (FE editLock): SalesAmt_LOC 편집=FCST_TYPE='ETC' 행만 / RTF_SYS_RP 편집=div{40,81}만(82 차단).
- **[E20260512-000502]** FROM_SITE_ID(81): FE save.ts 저장치환(81→p_cell_prod_site_id) + **03 SHEET_COLUMNS FROM_SITE_ID 81행**(VISIBLE 'Y', display-only). GET SP 는 FROM_SITE_ID 기출력·SAVE 는 p_cell_prod_site_id 기수신 → **SP 무변경**.
- (기반영) 편집권한 3단 계보: `SalesPlanUserAuthGroup`(05 CMBO) authGroup 주입 + DEFAULT_FLAG NVL 교정(sp/ DATAEX·SPREAD_TITLE 반영본) + SALES_PLAN_ADJUST_YN 게이트.

## 3. 적용 순서 (클라우드 — 신규 배포)

### Step 1. 브랜치
```
git checkout -b feat/dmf0021-full-transfer-20260721
```
### Step 2. SP/PKG 배포 (SCM_MGR)
```
sqlplus SCM_MGR/**@{dsn} @sp/PKG_DMF0021_SPEC.sql
sqlplus SCM_MGR/**@{dsn} @sp/PKG_DMF0021_BODY.sql
for f in sp/DMF0021_*.sql; do sqlplus SCM_MGR/**@{dsn} @$f; done
```
- ⚠ 재배포 세션 pin hang(hook #107 §4) — 접속 종료 또는 `ALTER SESSION SET DDL_LOCK_TIMEOUT=30`.
- 의존 인프라(GTT `GT_DMF0021_*`, `SCM_SYS_CALENDAR_M`, `SCM_MST_SITE_ITEM`, 공유 `UP_FX_*`) 는 클라우드 기존재 가정.
- VALID 검증: `SELECT object_name,status FROM all_objects WHERE object_name LIKE 'DMF0021%' OR object_name='PKG_DMF0021';`

### Step 3. DB 메타 등록 (01→07)
```
for n in 01 02 03 04 05 06 07; do sqlplus SCM_MGR/**@{dsn} @sql/${n}_DMF0021_*.sql; done
```
- 전부 멱등 MERGE. audit='admin' 정합.
- ⚠ **MNU_URL='sales-plan'** (01) ↔ FE 3-SET slug 정합. **SHEET_NAME='Sales Plan'(공백)** 불변.

### Step 4. FE 복사
```
robocopy fe\features\demand\src\pages\sales-plan {repo}\nscm-fe\features\demand\src\pages\sales-plan /E
```
### Step 5. 공통 파일 patch (`_COMMON_FILES_GUIDE.md`) — Router/route-paths/procedures.d.ts/locales
### Step 6. 빌드(type-check/lint/build) → Step 7. E2E 검증(§5)

## 4. 트러블슈팅
- **편집 셀 전무** → 05 `SalesPlanUserAuthGroup` + 07 `GET_ADMIN_GROUP_MEASURE`(SEGMENT2='DMF0021') 미적용 → EDIT_AUTH 전부 'N' (session.groupId 유령필드 계보).
- **필수컬럼/행게이트 누락(빈 그리드)** → sp/ DATAEX·SPREAD_TITLE **DEFAULT_FLAG NVL 교정본** 미배포(구 SP 는 `DEFAULT_FLAG=''` Oracle 항상거짓 함정).
- **81 저장 FROM_SITE_ID 손실** → FE save.ts 치환 미반영 or 03 FROM_SITE_ID 81행 미적용.
- "빈 결과" → 02 PROC_M positional 불일치 / "No Permission"(-9994) → 04 권한 / "API not found" → 01 / Grid 컬럼 빈 → 03 / Measure 코드표시 → 05 'Measure' + FE mnuId.

## 5. E2E 검증 시나리오
1. div 40 — SalesAmt_LOC 는 FCST_TYPE=ETC 행만 편집 / Catch_Up M+3
2. div 82 — RTF_SYS_RP 편집 **차단** / div 40·81 허용
3. div 81 — FROM_SITE_ID 컬럼 표시, 저장→재조회 FROM_SITE_ID 정합 / TEXT 필수
4. Bucket W↔M 전환(MSG00227) / Daily 편집 차단(MSG00361) / 저장 W_ 기준일(ISO주 월요일) 정합
5. DM Viewer 권한(Insert/Delete/Save 미표시)

## 6. 메타데이터
- 작성: Claude Opus 4.8 (2026-07-21) · 룰: 22_PACKAGE_ARTIFACTS / hook #105·#113 / feedback_migration_folder_naming
- 검증: FE tsc 0 · 사내 메타/SP 전수 실측 export(약 500행/6 SP객체) · regression Hard Boundary 0 · FROM_SITE_ID 81행 적용검증
- ⚠ SP/공유콤보/공유lookup/마스터데이터 = AS-IS·공유 자산 — 클라우드 기존재 시 MERGE/CREATE OR REPLACE 가 현행 정합(무해)
