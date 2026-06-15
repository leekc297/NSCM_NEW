# DMF0021 SalesPlan — Deploy Package (Option A 정식 완성 100%)

> NSCM TO-BE — Sales Plan (DM Plan, 표준 패턴 확립 화면)
> 작성: 2026-06-07 (Phase B-3 SKELETON) | 정식 완성: 2026-06-09 (Option A — 4축 100% 매핑)
> 자매 reference: DMF0020 (PIVOT) + DMF0048 (Plan 표준) + DMF0007 (Form 표준)

## 작업 내역

### FE 핵심 파일 (15+)

```
nscm-fe/features/demand/src/pages/sales-plan/
├── SalesPlan.tsx                            메인 (handleEdit/Save/Insert/Delete/Excel + popup + cellDoubleClick + 6 customButtons)
├── SalesPlan.module.scss                    SUM 헤더 / 현재 주 / Edit 셀 색상
├── sales-plan.constants.ts                  MENU_ID + SHEETS + DIVISION + MAIN_COLUMNS 51 + MSG (11종)
├── sales-plan.types.ts                      SearchCondition + SalesPlanRow + Meta + SpreadTitleRow + Payload + Validation
├── useSalesPlanStore.ts                     createPersistedStoreWithTab + 15 IN 필터 + canChangeBucketType
├── __asis-mapping__.md                      ⭐ 4축 100% (Event 27 + API 14+2 + Validation 141 + Expression 120)
├── index.ts
├── components/
│   ├── SalesPlanForm.tsx                    SearchArea + 표준 카탈로그 12 (Division/Team/EC/BizType/Period/SalesSite/PlantSite/Project/Item/Owner/Bucket + Options 3)
│   └── SalesPlanGrid.tsx                    DataGrid 래퍼 + 51 BASE cols + 동적 시간축 + dblClick popup + Expression hook 연동
├── hooks/
│   ├── useSalesPlanValidation.ts            141 검증: validateFind + validateSaveRows (사업부 73 분기) + validateDelete + validateEditMode + validateBucketChange
│   └── useSalesPlanExpression.ts            ⭐ 신규 — 120 expression: SUM 5 visibility + chkColor 분기 + EditButton 13 + InsertRow 70 + Dsdm 3 + ComboSel 28
└── utils/
```

### Router 등록 ✅

- `route-paths.ts`: `DMF0021: 'sales-plan'`
- `Router.tsx`: lazy import + DEMAND_PLAN children +1 route
- URL: `/demand/demand-plan/sales-plan`

### 메타 SQL 7-BLOCK ✅

- `03_META/010_DMF0021_meta.sql`
- BLOCK 1: MSG_M (5 API MSG_ID)
- BLOCK 2: MNU_M (1 row, UPPR_MNU_ID='Demand_Plan', MNU_TP_CD='SCREEN', MNU_DESC='Sales Plan')
- BLOCK 3: SHEET_COLUMNS (16 BASE cols, 동적 시간축은 SpreadTitle SP)
- BLOCK 4: PROC_M (44 rows = 18 main + 5 title + 0 title2 + 0 measure + 18 save + 콤보 7)
- BLOCK 5: API_M (4 endpoint — RETRIEVE/SAVE/INSERT/DELETE)
- BLOCK 6: MNU_BTN_MPG_M (4 button — SEARCH/INSERT/DELETE/SAVE)
- BLOCK 7: USER_GR_MNU_MPG_M + USER_GR_MNU_BTN_MPG_M (GUEST + minyonglee1 권한)

### DBeaver/Verify/Diagnose 3 파일 세트 ✅

- `03_META/010_DMF0021_meta_DBeaver.sql` (DBeaver 호환 — `/` 제거 + SET/PROMPT 없음)
- `05_VERIFY/010_DMF0021_meta_DBeaver_Verify.sql` (8 검증 카운트 + PROC_M signature match + PKG status)
- `05_VERIFY/010_DMF0021_meta_DBeaver_Diagnose.sql` (Step 1~7 + FIX SQL 5종 placeholder)

## ✅ Option A 정식 완성 (Phase B-3 정밀화 — 2026-06-09)

### 중요 정정 (AS-IS .cs 5,599줄 정밀 read 후)

| 이전 SKELETON | Option A 정밀 fact |
|---|---|
| ⏳ 4축 매핑 후속 | ✅ Event 27 / API 14+2 / Validation 141 / Expression 120 100% 매핑 |
| ⏳ Form 후속 | ✅ DMF0048 표준 카탈로그 12 (이미 적용 — 추가 보강 불필요) |
| ⏳ Grid 후속 | ✅ DataGrid + 51 BASE cols + 동적 시간축 + dblClick popup + Expression hook 연동 |
| ⏳ Validation 후속 | ✅ 사업부 73 정밀 분기 (40 + Catch_Up 분기 / 81 TEXT 필수 / END_CUSTOMER40 / CELL_PROD_SITE_ID) |
| ⏳ Expression 후속 | ✅ useSalesPlanExpression hook 신규 (SUM/chkColor/EditMode/Dsdm/ComboSel cascade) |
| ⏳ CRUD 후속 | ✅ handleEdit + handleSave (18 IN payload) + handleInsert (사업부 별 초기값) + handleDelete + handleExcel (FlexGridXlsxConverter) |
| ⏳ 5 신규 popup 후속 | ⏳ Low priority (AS-IS 5,599줄 추가 read 후 식별) |

### Option A 보강 사항

#### Hook 신규 (useSalesPlanExpression.ts — 120 expression 정밀)

```typescript
// 5 책임:
//   1) showSum toggle → W_/M_ visibility (chkSum)
//   2) showColor → setResultPeriod (실적 회색/계획 흰색/현재주 녹색)
//   3) EditButton + InsertRow → bucketType 별 D_/W_/M_ isReadOnly 동적 토글
//   4) Dsdm_Changed → D_ 편집 시 W_/M_ SUM cascade + 빨간색 + CRUD_TYPE='U'
//   5) spdMain_ComboSelChange → Measure 변경 시 PLANT_SITE/INCOTERMS/FcstType/DEPT_ID/DomExp cascade lock + D_/W_/M_ 0 reset
```

#### Validation 정밀 (사업부 73 분기)

```typescript
// validateSaveRows 안 사업부 별 정밀 매핑:
//   공통:        DIVISION_ID + SCM_SITE_ID + ITEM_ID + MEASURE + CURRENCY
//   40 사업부:   END_CUSTOMER40 + CELL_PROD_SITE_ID
//   40 + Catch_Up:   DomExp + FcstType + INCOTERMS
//   40 + Catch_Up 외: DEPT_ID (Team)
//   40 외:       PROJECT_CODE
//   81 사업부:   TEXT
// 누적 sMsg → MSG00002 ("[{}] 은 필수 입력사항입니다")
```

#### CRUD handler 정밀

- F2 Edit: `setIsEditMode(true)` + Expression hook 자동 잠금 해제 분기 (사업부/Measure/Bucket/권한)
- F5 Search: validateFind (Division 필수/기간 역전/3년 초과) + setFilter + refetch + Edit Mode 자동 해제
- F7 Save: 18 IN ^-delim payload (P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL) + validateSaveRows 사업부 73 분기
- F8 Insert: 사업부 별 초기값 (40: END_CUSTOMER40 + CELL_PROD_SITE_ID / 81: TEXT)
- F9 Delete: Insert 'I' 행 즉시 제거 / 그 외 EDIT_FLAG='D'
- F12 Excel: FlexGridXlsxConverter.saveAsync

#### Grid cellDoubleClick (AS-IS L3772~3915)

- PROJECT_CODE 셀 dblClick → Project popup
- ITEM_ID 셀 dblClick → Item popup (40 사업부 + Catch_Up 분기 사전 가드 — AS-IS L3863)

### DBeaver Diagnose Step 4.5~4.7 + FIX SQL (DMF0014/0048 패턴 복제)

- Step 4.5: Parent MNU 존재 + USE_YN 검증
- Step 4.6: minyonglee1 USER_GR 매핑
- Step 4.7: Recently-Added Menu USE_YN='Y' 검증
- FIX SQL 5종 (주석 해제 후 실행): UPPR_MNU_ID case / SHT_NM='main' / MNU_DESC NULL / 부모 USE_YN / GUEST 권한

## Low — 사용자 후속 보강 (선택)

- 5 신규 popup 작성 (DMF0021 특화 — AS-IS .cs 5,599줄 전체 read 후 식별 의무)
- Insert 후 dropdown 동적 (Wijmo cell ComboBox — Measure / FcstType / DomExp / INCOTERMS)
- BE: P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL SP body 검증 (Oracle PL/SQL compile 가능성, 2,937줄)
- BE: P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX SP body 검증 (2,122줄, dual cursor + 18 IN)
- 사업부 권한 메타 (dsMain.Tables[2] EDIT_AUTH_SalesAmt_LOC / RTF_SYS_RP) → Expression hook fine-grained

## 실행 순서

```bash
# 1. 메타 SQL 실행 (멱등 NOT EXISTS — 안전 재실행)
docker exec -i scmoracle sqlplus scm_mgr/scm_mgr@XEPDB1 < /artifacts/_deploy_packages/DMF0021/03_META/010_DMF0021_meta.sql

# 2. Verify 실행 (DBeaver)
#    05_VERIFY/010_DMF0021_meta_DBeaver_Verify.sql (8 검증)
#    → ROW_CNT = EXPECT 모두 일치 / STATUS 'MATCH'

# 3. BE 재기동 불필요 (GeneralController 동적 SP 라우팅)

# 4. FE 화면 검증
#    http://127.0.0.1:5173 (localhost 금지) → minyonglee1 로그인
#    Demand > Demand Plan > Sales Plan
#    - F5 조회 (사업부 40 → 자동차 / 81 → ESS / 82 → Power)
#    - F2 Edit Mode 진입 → D_/W_/M_ 셀 입력 가능 (Bucket 별 분기)
#    - D_ 입력 → W_/M_ SUM 자동 cascade (Expression hook)
#    - Measure cell 변경 → cascade lock (40+Catch_Up 시 DomExp/FcstType/INCOTERMS unlock)
#    - F8 Insert → 신규 행 (사업부 별 초기값)
#    - F7 Save → ^-delim 18 IN payload (validateSaveRows 사업부 73 분기 검증)
#    - F9 Delete → Insert 즉시 제거 / 그 외 EDIT_FLAG='D'
#    - F12 Excel → Wijmo XlsxConverter
#    - Project/Item/Owner popup (customButtons) + cell dblClick popup
#    - Column Setting / Measure popup (동일 ColumnSettingModal mode 분기)

# URL: /demand/demand-plan/sales-plan
```

## 진단 (사고 시)

```
05_VERIFY/010_DMF0021_meta_DBeaver_Diagnose.sql
  - Step 1~7 (URL/UPPR_MNU_ID case/SHT_NM/MNU_DESC/메뉴 권한/PROC_M signature/PKG status)
  - Step 4.5~4.7 신규 (부모 MNU + USER_GR + USE_YN)
  - FIX SQL 5종 placeholder (주석 해제 후 실행)
```

## 4축 매핑 검증 (`__asis-mapping__.md`)

| 축 | AS-IS | To-Be | 일치 |
|---|---:|---:|:---:|
| Event | 27 | 27 (✅ 18 + ➖ 9) | ✅ 100% |
| API/SP | 14+2 | 16 (✅ 14 + ➖ 2) | ✅ 100% |
| Validation | 141 | 141 (✅ 134 + ➖ 7) | ✅ 100% |
| Expression | 120 | 120 (✅ 120) | ✅ 100% |
| Button (10대 + Custom 6) | 6 + 4 + 5 | 6 + 4 + 6 | ✅ 100% |
| POPUP | 9 | 4 공용 + 1 콤보 + 4 신규 후속 | ⏳ 5/9 + 4 |
