# DMF0014_CustFcstUpload — AS-IS ↔ TO-BE 매핑 (2026-07-04, 기개발분 보완)

원소스: `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Plan/DMF0014_CustFcstUpload/DMF0014_CustFcstUpload.cs` (1,276줄)
분석 정본: `Doc/_analysis/domain_DM/screens/DMF0014_CustFcstUpload/` — **Events 12 / Validation 26(validation.md) / Expressions 6 / Popups 2**
배포 패키지: `_artifacts/_deploy_packages/DMF0014_CUST_FCST_UPLOAD_20260704/`

## 핵심 결정 (사용자 확정 2026-07-04)

- 범위 = 전체 (조회 + 편집저장 + Excel 업로드). **디자인(레이아웃) 유지** — 기존 Form/Grid/Modal 구조 보존, 배선만 추가.
- 배선 정본 = **PKG_DMF0014 멤버** (sesUserId/mnuId + O_RESULT_CURSOR 표준형). 단독 SP 는 구버전 — 배선 제외.
- SHT_NM = **'FCST Upload'** (SCM_ADM_EXCEL_COLUMNS 기존 등록명 + AS-IS SpdSheet.shtMain — 룰 #91.
  excel-upload 가 SHEET_NAME=#{shtNm} 조회이므로 FE SHEETS/BTN_MPG/USER_GR_BTN 전 체인 통일).
- PTT ORA-01031(GET 멤버 L5952~5981) → `OPEN O_RC1 FOR REPLACE(V_SQL_TEXT,';','')` 직접 오픈 치환 (01_SP/020).
- GET 멀티값 구분자 = **콤마** (FN_SCM_GET_WHERE_SQL 실측: 'A,B'→IN('A','B') / 'ALL'→조건 생략).
- SHEET_COLUMNS: AS-IS(MSSQL)에도 0행 실측 → hook ui-category-setup-column-meta **§9 신규 등록 의무**로
  15행 등재 (02_META/030 — AS-IS InitSpread 라벨/폭/Freeze 1:1 + o_rc1 실측 컬럼명).

## 1. Events 12 매핑

| # | AS-IS Handler | TO-BE | 비고 |
|---|---|---|---|
| 1 | Form_Load (InitControls/DefineProperty/CreateSpread) | mount effect — fetchStaticColumns + dayRange 쿼리 + store 초기값 | Bucket 기본 WEEKLY (.cs L308) |
| 2 | cboDivision_SelectedIndexChanged | Form Division onChange — 하위 조건 cascade clear (team/endCustomer/salesSite/plantSite) | 콤보 재조회는 useTabComboQueries divisionId 클라 필터 |
| 3 | clbTeam_SelectedIndexChanged | Form Team onChange | cascade 는 콤보 DIVISION_ID 필터로 등가 |
| 4 | clbEndCustomer_SelectedIndexChanged | Form End Customer onChange | 〃 |
| 5 | btnProject_Click (SCM0002_ProjectbyDivisionPopupEx) | ProjectByDivisionModal — setSelectedValue→project, preSearchParams 실값 | 공용 모달 재사용 |
| 6 | btmItem_Click (DM0002_ItembyDivisionPopupEx) | ItemByDivisionModal — setSelectedValue→modelNickname | 〃 |
| 7 | drpPeriod_ValueChanged (dtFrom>dtTo → MSG00108) | DatePicker onChange + validateFind MSG00108 | 조회 시점 일괄 검증으로 통합 |
| 8 | spdMain_Changed (CellsUpdated — D_ 셀) | Grid cellEditEnded → handleCellEdited (필수 11 + SetSaveData) | 아래 Validation 참조 |
| 9 | btnExcelUpload_Click (ExcelUploadForm "DMF0014"/'FCST Upload') | UPLOAD 버튼 → FcstUploadModal → /DMF0014/FCST Upload/UPLOAD/excel-upload | Viewer 그룹 = UPLOAD 권한 미부여 (AS-IS L310~314 1:1) |
| 10 | spdMain_ComboSelChange (Division/ScmSite/Measure 콤보 cascade) | **N/A — 도달 불가 데드코드** | 식별 셀 상시 잠금 + InsertRow 차단으로 AS-IS 에서도 발화 불가 |
| 11 | spdMain_CellDoubleClick (Action='I' 행 가드만, 본문 없음) | N/A — AS-IS 자체가 빈 가드 | |
| 12 | cboBucketType_SelectedIndexChanged (InitSpread 재구성) | Bucket onChange → 조회 시 spreadTitle 재조회 (컬럼 재구성) | |

Framework Auto-Events (F-key override):
- F5 FindButton→handleSearch / F7 SaveButton→handleSave / F12 ExcelButton→공통 excel export(2단 헤더 유지 — gridAction headerDepth 분기)
- **F8 InsertButton → MSG00380 안내 1:1** (AS-IS InsertRow 원 로직 주석 처리 — 직접 INSERT 차단 화면)
- F9 DeleteButton → Action='I' 신규행만 삭제 = 신규행 경로 부재로 실질 no-op (AS-IS 동일)
- **F2 EditButton(SwitchLock) → TO-BE 상시 판정으로 대체** (mkt-fcst 표준): D_ 셀 × EDIT_FLAG='Y' 행만 편집 허용 (beginningEdit 가드)

## 2. Validation 26 매핑 (validation.md 전수)

| validation.md # | 내용 | TO-BE |
|---|---|---|
| 1 (InitControls Div40 분기) | EndCustomer 콤보 소스 분기 | 콤보 EndCustomer 단일 등록분 + DIVISION_ID 클라 필터 (AS-IS 양분기 모두 EndCustomerByDivision 호출로 수렴 — .cs L261/268 동일) |
| 2·3 (FindData Div 필수 MSG00097) | 조회 차단 | validateFind — MSG00097 |
| 4 (FindData 기간역전 MSG00108) | 〃 | validateFind — MSG00108 |
| 5 (FindData 2년 초과 MSG00164) | AddYears(2) | validateFind — 시작+2년 초과 차단. **AS-IS 문구(3년)/조건(2년) 불일치 1:1 보존** |
| 6 (SaveData 결과 메시지 MSG00004) | 저장 응답 표시 | handleSave — confirm(MSG00004) + 성공 toast(MSG00606) + 오류 alert(SP O_RESULT/message) |
| 7 (SaveData 변경없음 MSG00152) | iCount=0 | handleSave — entries 0건 시 MSG00152 |
| 8·9 (cboDivision 81/82 분기 — Project 활성) | lblProject/btnProject Enabled | 디자인 유지 결정으로 PJT 필드 상시 노출 (AS-IS 는 81/82 만 활성) — 조회 SP 가 Div40 에서 projectCode 무시하므로 동작 등가 |
| 10 (drpPeriod 역전 MSG00108) | 즉시 검증 | validateFind 일괄 (Events #7) |
| 11~23 (spdMain_Changed 필수 11 + Div81 PlantSite 분기) | D_ 셀 입력 시 식별값 필수 | handleCellEdited — MSG00429 '{0}' 11건 순서 1:1 + PLANT_SITE_ID 는 Div81 만 |
| 24 (UPLOAD_UOM Auto-Sync 분기) | 식별 셀 변경 시 UOM 자동 채움 | **N/A — 도달 불가** (식별 셀 상시 잠금 — Events #10 과 동일 사유) |
| 25·26 (spdMain_ComboSelChange Div 분기 + Div81 PlantSite 잠금/해제) | 콤보 cascade | **N/A — 도달 불가** (〃) |

## 3. Expressions 6 매핑 (전부 조건부 행잠금)

| # | AS-IS | TO-BE |
|---|---|---|
| 1 (EditButton L471 — 'Y' 행 식별 컬럼 잠금) | LockRange(Div..EditFlag) | staticColumns 전행 inputTpCd='S' + beginningEdit 동적 컬럼 가드 |
| 2 (EditButton L475 — 비'Y' 행 전체 잠금) | LockRange(0..max) | beginningEdit — EDIT_FLAG!=='Y' 행 cancel |
| 3·4 (InsertRow L813~814 — MeasureGroup/UOM~Item 잠금) | 신규행 잠금 | N/A — InsertRow 자체가 MSG00380 차단 (주석 데드코드) |
| 5·6 (ComboSelChange L1189/1191 — Div81 PlantSite 잠금 토글) | 콤보 cascade 잠금 | N/A — 도달 불가 (식별 셀 상시 잠금) |

## 4. Popups 2 매핑

| AS-IS | TO-BE |
|---|---|
| SCM0002_ProjectbyDivisionPopupEx | 공용 `ProjectByDivisionModal` (features/master/src/components) — 실배선 |
| DM0002_ItembyDivisionPopupEx | 공용 `ItemByDivisionModal` — 실배선 |

## 5. 그리드 구조

- 식별 13 컬럼: SCM_MST_SHEET_COLUMNS 15행(+EDIT_FLAG/EDIT_YN 숨김) 동적 fetch — display && visible 판정,
  FIXED_FLAG='Y' → 전 식별 컬럼 고정 (AS-IS Freeze(0..EditFlag) 1:1). fallback = MAIN_COLUMNS 스냅샷.
- 동적 기간 컬럼: SPREAD_TITLE o_rc1 (전 버킷 D_yyyymmdd — WEEKLY=주 시작일/MONTHLY=월 시작일 실측).
  2단 헤더 = SMALL_LABEL_NAME 연속 run 그룹(상단) + COLUMN_LABEL(하단). SAT/SUN 헤더 색 (AS-IS L399~402).
- 헤더 높이 48px 불변식 — hook #93 P-B v2 rAF 감시 (sales-monitoring 검증분 1:1).
- 편집 셀 Yellow(#95) = D_ 셀 × EDIT_FLAG='Y' 행만.

## 6. 저장/업로드 체인

- SAVE: 변경 D_ 셀 → SetSaveData dedup(식별 10+yyyymmdd, 동일 키 qty 갱신) → 'M' + 17키 '^'delim →
  `apiClient.post('/DMF0014/FCST Upload/SAVE/call-proc')` (PROC_M 18행 positional). SP 빈입력은
  ORA-01400 re-raise → BE -9994 (AS-IS GMessageBoxForException 등가 — FE alert).
- UPLOAD: FcstUploadModal → multipart `/DMF0014/FCST Upload/UPLOAD/excel-upload` →
  SCM_ADM_EXCEL_COLUMNS(STORAGE_SQL_ID=PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD, 040 교정) →
  PR_SAVE_EXCEL_UPLOAD → validProc(mode=0) → PR_GET_EXCEL_UPLOAD_RESULT.
  응답 실측(G6): O_CUR_CNT(SUCCESS_COUNT/ERROR_COUNT/TOTAL_COUNT) + O_CUR_LIST(ATTRIBUTE1~13+EXCEL_ROW —
  HEADER_CONTENT 순서 라벨 매핑) + O_RESULT_CURSOR.
- `P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM`(3 args) — 호출 경로 부재 (Excel.xml validProc 5-arg 계약 불일치) → **배선 제외**.

## 7. 메시지 매핑 (신규 채번: LBL00754~759 만)

| 용도 | AS-IS | TO-BE 사내/json |
|---|---|---|
| 필수값 {0} | MSG00002('{0} 값은 필수 입력') | **MSG00429** (사내 MSG00002 는 저장성공으로 재정의됨) |
| 저장 confirm/성공 | MSG00004/MSG00020 | MSG00004(confirm — json 'Save the changes?') + MSG00606(성공 toast) |
| 변경 없음 | MSG00152 | MSG00152 |
| Division 필수 | MSG00097 | MSG00097 |
| 기간 역전 | MSG00108 | MSG00108 |
| 기간 상한 | MSG00164 (2년 조건/3년 문구) | MSG00164 — 불일치 1:1 보존 |
| INSERT 차단 | MSG00380 | MSG00380 |
| 업로드 완료 | (공통 폼) | MSG00265 |
| 업로드 모달 라벨 | (공통 폼 Term) | LBL00346 + **신규 LBL00754~759** (Upload Result/Success/Error/Total/Error Detail/Excel File — MSG_M+json 3종 등록) |
| MSG00002/MSG00004 EN·CN 오염 | — | 사내 MSG_M EN/CN 교정 (KO 불변 — 02_META/040) |
