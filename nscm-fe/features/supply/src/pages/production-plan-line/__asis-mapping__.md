# SCP0013 Production Plan Line — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Analysis/SCP0013_ProductionPlanLine/SCP0013_ProductionPlanLine.cs`(+Designer)
> 설계 정본: `.atlas/gscm-design/SCP0013/design/00_checklist.md` ~ `03_grid-columns.md` (v2, DB 실측).
> 규범: `.atlas/workbenches/nscm-convert/guides/convert-core.md`(anti-simplification·Hard Boundary·정직 3값).
> 조회/저장 버튼-API 배선: `SCM_ADM_MNU_BTN_MPG_M`(SCP0013)=main/SEARCH·main/SAVE·load/SEARCH 3행 등록됨(ora.py 2026-09-18).
> SAVE=`P_SCP0013_SAVE_LINE_ROW_JSON`. SP 배포 완료(PKG_SCP0013 VALID). New/Fix/Unfix/cellTypeGr 등 서버 서브호출(GET_LINE_LIST/
> SAVE_YN/EDIT_INFO/NEW_POPUP…)용 API_M 10행은 등록됐으나 버튼/그룹 배선·FE 호출은 미이식(런타임 검증 축, 04 리포트 M1/M3/M4/M5).

## 영역1 Layout 동적처리 (design 01) → 구현

| AS-IS(cs) | 규칙 | TO-BE 구현 |
|---|---|---|
| Form_Load/DefineProperty(242) | A1 초기값 Bucket=WEEKLY, chkSum/LineAssign=false, 패널펼침 | `useProductionPlanLineStore.initSearch` |
| InitControls(269) 권한없음 | A2 검색영역/btnLoad disable | 근사(세션 division) — 권한메타 확인필요(design 01 §6) |
| GetLastRange==W52(299) | A3 btnWLast 숨김/라벨 | `ProductionPlanLineForm.showWLast`(wLastPeriod) — SP 미배선 근사 |
| division=="40"(1785) | B1/B2 CellTypeGr·ExtraSpec enable/clear | `isCellTypeExtraSpecEnabled` + Form effect |
| division EE(1774) | B3 OperationGroup 코드셋 스왑 | `isEeDivision` → COMBO.OP_GROUP_EE 스왑 |
| OperationGroup A/P(3886) | C1/C2 Electrode ALL+disable | `isElectrodeEnabled` + Form effect |
| PlanDate/Type/Seq change(3996) | D1 Fix/Unfix/New enable | `canFixUnfixNew`(util) + 페이지 `canFix` |
| 버전 변경(3947) | D2 그리드 clear | `setDivision`/planDate·Type onChange filters clear |
| Edit(648)/is_editable(681) | F1/F2 셀 잠금/편집행 해제 | `isRowEditable`+`isPivotCellEditable` (서버 is_editable+4규칙) |
| SetLockSumColumn(1155) | F3 SUM(W_/M_) 잠금 | `editablePivotKindForBucket`(SUM kind 제외) |
| FindData_Main(2088) | G2 조회직후 전 컬럼 잠금 | pivot baseline readOnly + beginningEdit white-list |
| chkAll/chkSum/chkLineAssign | H1~H3 | store `chkAll/chkSum/chkLineAssign` + 22-param |
| btnW26/52/WLast(961) | H5 기간 프리셋 | 페이지 `handlePreset`(dayjs 로컬) |
| usrConditionPanel1(HidePanel) | I1 접이식 패널 | SearchArea isHidden(openSearchArea) |
| btnFix/Unfix Click(993/1018) | E1~E4 권한/모드/SAVE_YN 가드 | 페이지 `runFix`(권한+canFix, 서버 SAVE_YN 확인필요) |
| btnNew Click(842) | E5 3가드 + 삽입팝업 | 페이지 `handleInsert`(권한+canFix+조회행) |
| btnLoad Click(898) | Load 팝업 | `ProductionPlanLineLoadModal` + setLoadFilter |

## 영역2 조회조건 combo (design 02) → 구현

| AS-IS combo | TO-BE 콤보(등록 실측) | 구현 |
|---|---|---|
| cboDivision | `Division` | Form single, setDivision cascade clear |
| cboOperationGroup / EE | `OperationGroup_SCP` / `OperationGroupEE_SCP` | EE 스왑 |
| clbPlantSite | `PlantByDivisionOperation1_SCP_ALL` | 반환 DIVISION_ID/OPERATION_GROUP 클라 필터 |
| clbLine | `LineByOperationAddOSP1_SCP_ALL` | DIVISION_ID/SITE_ID 클라 필터 + '-' 제외 (cellTypeGr 서버 재조회는 미배선) |
| cboCellTypeGr | `CellTypeGr_SCP` | div=40 enable |
| cboElectrode | lookup `ELECTRODE_TYPE` | opGroup A/P → ALL+disable |
| clbExtraSpec | (TO-BE 콤보 미탐 — design 02 §7) | 옵션 미공급, div=40 enable — 확인필요 |
| cboPlanDate/Type/Seq | `DATE_WEEKLY1_SCP_ALL`/`PlanType1_SCP_ALL`/`PlanSeq1_SCP_ALL` | 반환 DIVISION_ID/PLANDATE/PLANTYPE 클라 cascade |
| cboBucketType | `BucketType` | 기본 WEEKLY |
| dCalendar | PeriodField + 프리셋 | GetDayRange 등가 클라 산정 |
| txtItemId+btnItemId | `ItemByDivisionModal` | setSelectedValue → itemId |
| 22-param GET | `P_SCP0013_GET_PROD_PLAN_LINEBY` | `store.setFilter` (SP IN 순번 주석) |

## 영역3 그리드 (design 03) → 구현

| AS-IS | TO-BE |
|---|---|
| 27 고정 컬럼(SCM_MST_SHEET_COLUMNS 'Line') | admin fetch + `FIXED_COLUMNS` fallback (`buildFixedColumns`) |
| div 조건 가시성(EE/40/OpGr=E/Cell) | `isFixedColumnVisible` |
| 동적 D_/W_/M_ 3단 헤더(3SPAN) | `buildPivotColumns`(월>주>일 중첩) |
| bucket×chkSum 가시 매트릭스(§2.4) | `isPivotVisible` |
| SmartColMerge(고정 식별컬럼) | DataGrid allowMerging + pivot 제외 |
| LockRange/LockColumn(편집 white-list) | `isPivotCellEditable`(measure/bucket/과거/is_editable) |
| SetValue W→D 분배·음수원복(1610~1649) | `distributeWeeklyToDaily`/`sumValues` (+test) |
| CalculateSum 재집계(3782) | D_ 편집 시 W_/M_ 재집계 |
| 주말 헤더색(토 Blue/일 Red) | grid formatItem |
| 수량 검증(MSG00084/00317)·신규행(MSG00026) | `useProductionPlanLineValidation.validateSave` |
| Load 팝업(읽기전용) | `ProductionPlanLineLoadModal` |

## 확인 필요 (정직 보고 — design 3문서 §확인 상속)

1. clbExtraSpec TO-BE 전용 콤보 미탐(design 02 §7) — 옵션 미공급.
2. 버튼-API 배선(SCM_ADM_MNU_BTN_MPG_M) = main/SEARCH·main/SAVE·load/SEARCH 3행 등록됨(ora.py 2026-09-18). New/Fix/Unfix 는 화면 update 권한(SAVE)으로 게이트(design 01 R1/§5). SAVE JSON 실동작은 runtime 축.
3. GetLastRange(btnWLast 라벨)·is_editable/SAVE_YN 서버 판정 — SP 배포됨, 버튼 배선 후 연동.
4. i18n LBL/MSG — TO-BE `SCM_ADM_MSG_M` 역매핑 완료(Hook #114, ora.py 2026-09-18). AS-IS 번호가 TO-BE 에서 다른
   문구로 오표시되던 코드 재매핑(REQUIRED_FIELD MSG00002→MSG00429·CONFIRM_UNFIX MSG00016→MSG01438·NEW_ROW_RED_CELL
   MSG00026→MSG00013 등) + LBL00000 placeholder 2건 실측 코드 교정(Fix Reason=LBL00771+LBL00625, Measure=LBL00310).
   일부(SELECT_CELL/CONFIRM_UNFIX/QTY_OVERFLOW)는 코드는 정본이나 배포 번들(public/locales) 미포함이라 영문 fallback 표시.
5. 브라우저 시각·조작감(3단 헤더/병합/W→D 분배 체감) — 사용자 확인 축.
