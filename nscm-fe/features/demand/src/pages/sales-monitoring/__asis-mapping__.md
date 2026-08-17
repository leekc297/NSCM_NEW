# DMF0048_SalesMonitoring — AS-IS ↔ TO-BE 4축 매핑 (2026-07-04)

> AS-IS: `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Plan/DMF0048_SalesMonitoring/DMF0048_SalesMonitoring.cs` (1,822줄)
> 분석 정본: `Doc/_analysis/domain_DM/screens/DMF0048_SalesMonitoring/{analysis,validation,expressions}.md`
> 정본 카운트: **Events 21 / Validation 23 / Expressions 7 / Popups 2** — 아래 표에서 100% 매핑 (누락 0)
>
> **화면 성격 (사용자 확정 2026-07-04): read-only.** AS-IS 는 `FindButton()`(L557)/`ExcelButton()`(L564) 만
> override. 저장 스택(`InitSaveDataTable` L1546 — 호출부 L241 주석 / `SetSaveData` L1561 / `fnValidation`
> L1600)은 데드코드. 통화 콤보 cboKRW/USD/LOC 는 Designer.cs 에 컨트롤 미존재 + 핸들러 본문 전부
> 주석(L2116~2144) — 미사용 확정 제외.

## §0 SP / 메타 배선

| AS-IS Endpoint | TO-BE | 비고 |
|---|---|---|
| `DM.DMF0048_GET_DM_PLN_SALES_MONITORING` | `PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING` (sheet 'Sales Monitoring' SEARCH) | PKG 멤버 = TO-BE 정본 (sesUserId/mnuId + O_RESULT_CURSOR). 단독 SP 는 ORA-38104 잔존 구버전 — 배선 제외 |
| `DM.DMF0048_GET_SPREAD_TITLE` | `DMF0048_GET_SPREAD_TITLE` (sheet 'spreadTitle' SEARCH) | 2026-07-04 O_RC1 복원 변환 (01_SP/030) |
| `DM.PR_GET_DAY_RANGE` | `PR_GET_DAY_RANGE` (sheet 'dayRange' SEARCH) | o_rc2 = AS-IS Tables[1] (.cs L996) — 기본 Period |
| `DM.DMF0003_GET_BUCKET_TYPE_CODE` | 정적 옵션 (DAILY/WEEKLY/MONTHLY — SP 실측 3행 고정) | 콤보 값 하드동일. 값 확장 시 SP 연동 전환 |
| `SCM.SCM0001_GET_DIVISION` | CMBO `MyDivision` | TO-BE 콤보 표준 = CMBO 레지스트리 |
| `SCM.SCM0001_GET_TEAM_BY_DIVISION` | CMBO `TeambyDivision` | SP 자체도 정상화 (01_SP/020 — XML split→JSON_TABLE) |
| `SCM.SCM0001_GET_CUSTOMER_BY_DIVISION` | CMBO `EndCustomer` | |
| `SCM.SCM0001_GET_SITE_BY_DIVISION` | CMBO `ScmSitebyEndCustomer40` | |
| `SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER` | CMBO `SalesPlant` (+divisionId) | |
| `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | CMBO `BizType` | |
| `SCM.SCM0001_GET_LOOKUP_VALUES` (ItemType) | CMBO `ItemType` | |
| (Excel) | SubTitle EXCEL (wijmo client export) | AS-IS F12 ExcelButton 1:1 |

파라미터 구분자: PKG `FN_SPLITSTRING(x, ',')` 실측 — **콤마** join. 콤보 멀티 빈값=`'ALL'`, 텍스트
(projectCode/itemId/owner) 빈값=`''`(→NULL). `p_item_id` 는 LIKE 부분일치 (PKG L1010).

## §1 Event 축 (21/21)

| # | AS-IS Handler (.cs) | TO-BE | 매핑 |
|---|---|---|---|
| 1 | `Form_Load` (InitControls→CreateSpread→…) | `SalesMonitoring.tsx` mount useEffect — clearFilters + fetchStaticColumns/Measures + dayRange 조회 | 1:1 |
| 2 | `txtProject_KeyDown` (→btnProject_Click) | `ProjectField` 카탈로그 필드 (입력+Enter/돋보기 popup 자체 관리) | 위임 |
| 3 | `txtItemId_KeyDown` (→btnItemId_Click) | `ItemField` 카탈로그 필드 | 위임 |
| 4 | `btnProject_Click` (Project popup) | `ProjectField` multiCheckbox popup | 위임 |
| 5 | `btnItemId_Click` (Model popup) | `ItemField` multiCheckbox popup | 위임 |
| 6 | `spdMain_TopChange` (SmartColMerge, L1122) | `SalesMonitoringGrid` scrollPositionChanged → invalidate (HierarchicalMergeManager 재계산) | 1:1 |
| 7 | `cboBucketType_SelectedIndexChanged` (L1129 — SetSpreadColumn + 현재주 강조) | Form Bucket 드롭다운 onChange → store bucketType → Grid 표시 매트릭스/강조 재적용 | 1:1 |
| 8 | `spdMain_CellDoubleClick` (L1385) | **N/A — AS-IS 빈 핸들러** (본문 0줄) | 근거 제외 |
| 9 | `Dsdm_Changed` (L1390 — 셀 편집 시 Red + 월합계 재계산) | **N/A — read-only** (SHEET_COLUMNS INPUT_TP_CD 전행 'S' 실측 + 저장 미구현). beginningEdit cancel 이중 방어 | 근거 제외 |
| 10 | `chkSum_CheckedChanged` (L1739 → SetSpreadColumn) | Form Sum 체크 → Grid applyDynVisibility (상위 합계 M_/W_ 표시 토글) | 1:1 |
| 11 | `chkColor_CheckedChanged` (L1747 → SetSpreadColumn/setResultPeriod) | Form Color 체크 → Grid formatItem (과거 구간 회색 + 헤더 강조 해제) | 1:1 |
| 12 | `btnColumn_Click` (L1755 — DM0002_TitleSetForm column 모드) | SubTitle customButton 'Column Setting' → 공용 `ColumnSettingModal` | 1:1 |
| 13 | `btnMeasure_Click` (L1768 — DM0002_TitleSetForm measure 모드) | SubTitle customButton 'Measure' → `MeasureSelectModal` (SHEET_MEASURE 39행 dual list) | 1:1 |
| 14 | `clbCustomer_SelectedIndexChanged` (SetChangeControl) | Form End Customer onChange — 하위(Sales Site/Plant Site) cascade clear | 1:1 |
| 15 | `clbDivision_SelectedIndexChanged` (SetChangeControl→GetBizTypebyDivision) | Form Div onChange — 하위 전체 cascade clear + 콤보 DIVISION_ID 클라 필터 | 1:1 |
| 16 | `clbTeam_SelectedIndexChanged` (SetChangeControl) | Form Team onChange — 하위(End Customer/Sales Site) cascade clear | 1:1 |
| 17 | `cboKRW_SelectedIndexChanged` (L2116) | **N/A — 데드코드** (컨트롤 미존재 + 본문 전부 주석) | 근거 제외 |
| 18 | `cboUSD_SelectedIndexChanged` (L2126) | **N/A — 데드코드** (동일) | 근거 제외 |
| 19 | `cboLOC_SelectedIndexChanged` (L2136) | **N/A — 데드코드** (동일) | 근거 제외 |
| 20 | `btnOwner_Click` (Owner popup — DM0020_OwnerbyDivisionPopup) | `OwnerField` 카탈로그 필드 popup | 위임 |
| 21 | `cboBucketType_Click` (L2160 — Insert 행 존재 시 Bucket 변경 가드 MSG00227) | **N/A — read-only** (Insert 미지원 → Insert 행 자체가 없음) | 근거 제외 |

Framework Auto-Events (BaseForm — 이벤트 축 외 F키): F5 Find=`handleSearch`(override 1:1) /
F12 Excel=SubTitle EXCEL / **F2 Edit·F7 Save·F8 Insert·F9 Delete = 미지원** (AS-IS override 없음 —
hotkeyConfig insert/delete/save=false + BTN 메타 미등록 → hasButton=false).

## §2 API 축 (12/12)

§0 표 참조 — AS-IS 12 endpoint 전부 매핑 (DMF0048 2 + 공유 10). 신규 TO-BE 시트 배선 3
('Sales Monitoring' / 'spreadTitle' / 'dayRange') + titleSet(공용 DMF0002_GET_TITLESET_POPUP).

## §3 Validation 축 (23/23)

validation.md 전수 (라인 = AS-IS .cs):

| # | Handler | MSG | 조건 | TO-BE |
|---|---|---|---|---|
| 1 | InitControls L338 | — | `sDivision=="40"` 분기 (BizType 로딩) | 콤보 DIVISION_ID 클라 필터 (Form) |
| 2 | txtProject_KeyDown L444 | — | KeyDown 가드 | ProjectField 위임 |
| 3 | txtItemId_KeyDown L452 | — | KeyDown 가드 | ItemField 위임 |
| 4 | FindData L625 | MSG00137 | `blnWork` (작업 중) | `validateFind` — isFetching 가드 |
| 5 | FindData L638 | MSG00108 | 기간 역전 | `validateFind` 1:1 |
| 6 | FindData L645 | MSG00164 | 기간 3년 초과 | `validateFind` 1:1 |
| 7 | FindData L671 | MSG00097 | Division 미선택 | `validateFind` 1:1 |
| 8 | FindData L721 | (silent) | 0행 return | react-query 빈 배열 → 그리드 0행 (동등) |
| 9 | btnProject_Click L1084 | — | Division '81' substring 분기 (popup 파라미터) | ProjectField division prop 위임 |
| 10 | Dsdm_Changed L1398 | (silent) | `e.Column/Row < 0` 가드 | N/A — read-only (편집 이벤트 없음) |
| 11 | Dsdm_Changed L1413 | (silent) | MEASURE 공란 가드 | N/A — read-only |
| 12~19 | fnValidation L1619~1714 (8건) | — | 저장 전 division 분기 필수/중복 검증 | **N/A — 데드코드** (저장 스택 주석 L241, 저장 미구현) |
| 20 | GetThisWeekMonday L1806 | (silent) | 월요일 탐색 루프 | N/A — 편집 cutoff 미사용 (read-only). 과거 판정은 o_rc2 기반 |
| 21 | clbDivision_SelectedIndexChanged L1855 | — | `sDivision=="40"` 분기 | Form Div onChange cascade 1:1 |
| 22 | clbTeam_SelectedIndexChanged L2021 | — | '81' substring 분기 | Form Team onChange cascade (콤보 필터) |
| 23 | cboBucketType_Click L2173 | MSG00227 | Insert 행 존재 시 Bucket 변경 불가 | N/A — read-only (Insert 미지원). MSG 상수는 기록 보존 |

MSG ID 5종 (00097/00108/00137/00164/00227) 전부 사내 SCM_ADM_MSG_M 실존 — 재채번 없이 재사용.

## §4 Expression 축 (7/7)

| # | AS-IS (expressions.md) | TO-BE |
|---|---|---|
| 1 | `ColumnHeaderSpan(1, iLargeStartCol, 2,1,20,"SUM")` L1350 | M_ 컬럼 2·3단 'SUM' 세로 머지 — `HierarchicalMergeManager` (M_ r≥1 세로) + dynamicColumns sub='SUM' |
| 2 | `ColumnHeaderSpan(2, iSmallStartCol,1,1,30,"SUM")` L1356 | W_ 컬럼 3단 leaf='SUM' — dynamicColumns leaf 라벨 |
| 3 | `ColumnHeaderSpan(2, iSmallStartCol,1,1,20,"SUM")` L1364 | 동일 (주차 그룹 경계) |
| 4 | `ColumnHeaderSpan(2, iSmallStartCol,1,1,20,"SUM")` L1376 | 동일 (마지막 그룹 flush) |
| 5 | `ColumnHeaderSpan(1, iLargeStartCol,2,1,20,"SUM")` L1378 | 동일 (마지막 월 그룹 flush) |
| 6 | `iMonthlySum += GetText(...)` L1456 (Dsdm_Changed 월합계 누적) | **N/A — read-only** (셀 편집 불가 → 재계산 트리거 없음. 합계는 SP 가 M_/W_ 컬럼으로 서버 계산 반환) |
| 7 | `SetText(e.Row, iStartCol-1, iMonthlySum)` L1461 (월합계 기록) | **N/A — read-only** (동일) |

⭐ 의도적 편차 (사용자 지시 2026-07-04): AS-IS `Freeze(0, MEASURE+1)` (L1380 — 식별 컬럼 블록 전체
하드코드 고정, FIXED_FLAG 미참조)은 **재현하지 않음**. TO-BE 는 컬럼 고정을 admin
SCM_MST_SHEET_COLUMNS.FIXED_FLAG 에 위임 (현재 사내 데이터 전행 공란 = 고정 0 / admin 'Y' 등록 시
화면 수정 없이 즉시 고정 반영).

부수 표현 (expressions.md 외 — 구현 반영): SetSpreadHeaderSpan 의 주말 요일색(L1340~1343 토=Blue/일=Red)
→ Grid formatItem D_ leaf 헤더 요일색 / SetSpreadColumn 현재 월·주 헤더 Green Bold (chkColor=false)
→ formatItem o_rc2(THIS_YYYYMM/THIS_YYYYMMWW) 강조 / setResultPeriod 과거 구간 Gainsboro (chkColor=true)
→ formatItem `isPastBinding` + `wj-cell-non-editable`.

## §5 Popup 축 (2/2)

| # | AS-IS Popup | TO-BE |
|---|---|---|
| 1 | `DM0002_TitleSetForm_Popup` (btnColumn/btnMeasure — column/measure 모드) | 공용 `ColumnSettingModal` (DMF0002_GET_TITLESET_POPUP, titleSet 시트 배선) + `MeasureSelectModal` (SHEET_MEASURE 동적) |
| 2 | `DM0020_OwnerbyDivisionPopup` (btnOwner) | `OwnerField` 카탈로그 필드 popup (공용 Owner popup) |

(참고: `SCM0002_TitleSetForm_Popup` 은 AS-IS 소스에서 주석 처리 — Designer 부재로 분석 대상 제외됨.)

## §6 버튼 매핑 (G2 — 10버튼)

| 버튼 | AS-IS | TO-BE | 메타 |
|---|---|---|---|
| SEARCH(F5) | FindButton override | handleSearch (validateFind→setFilter) | BTN행 ○ |
| EXCEL(F12) | ExcelButton override | SubTitle EXCEL (client export) | BTN행 ○ |
| SORT(F3)/FILTER(F4)/CONDITION(F6)/RESET(F10) | Framework 기본 | SubTitle DefaultButtonActions 자동 | SORT/FILTER BTN행 ○ |
| COLUMN_SETUP | btnColumn | ColumnSettingModal customButton | BTN행 ○ |
| MEASURE_SELECT | btnMeasure | MeasureSelectModal customButton | BTN행 ○ |
| INSERT(F8)/DELETE(F9)/SAVE(F7)/EDIT(F2) | override 없음 (미구현) | hotkeyConfig false + BTN행 미등록 → hidden | 의도적 미등록 |

## §7 변경 파일 대장

| 구분 | 파일 |
|---|---|
| FE 신규 | `features/demand/src/pages/sales-monitoring/` — index.ts / SalesMonitoring.tsx(+scss) / sales-monitoring.constants.ts / sales-monitoring.types.ts / useSalesMonitoringStore.ts / components/{SalesMonitoringForm.tsx(+scss), SalesMonitoringGrid.tsx, MeasureSelectModal.tsx} / utils/sales-monitoring.merge.ts / __asis-mapping__.md |
| FE 수정 | `apps/web/src/core/Router.tsx` (lazy + 'dmf0048' 라우트) / `configs/types/procedures.d.ts` (DMF0048 블록) / `public/locales/{KO,EN,CN}.json` (LBL00753) |
| DB SP | `_artifacts/_deploy_packages/DMF0048_SALES_MONITORING_20260704/01_SP/` 010~060 (INVALID 4건 정상화 + PKG PTT→WITH 패치 + GRANT) |
| DB 메타 | 동 `02_META/` 010(API 9+PROC 34) / 020(BTN 9+권한 27) / 030(감사) / 040(LBL00753) |
| BE | **변경 0** (GeneralController call-proc + MenuController 메타 — DMF0003 동일) |
