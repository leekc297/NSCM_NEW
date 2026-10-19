# SCP0130 ScheduledReceiptInformation — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS 정본: `.cs`/`.Designer.cs` 원본은 이 저장소·이전 세션 어디에서도 확보하지 못했다
> (`design/00_checklist.md`~`03_grid-columns.md` 전건이 "AS-IS 소스 부재"를 명시 — `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/`
> 하위에 `SCP0130` 폴더 자체가 없음). 이 매핑은 (1) `screen-analysis.json`(Roslyn 1.2 산출,
> 라인번호·조건식 원문 포함) + (2) TO-BE Oracle(`ora.py`) 실측 + (3) AS-IS 화면설계서 엑셀
> (`GSCM_SCP_DOC/SCP/UI/GSCM_DE_화면설계서_SCP0130(자재포장재 입고예정 정보).xlsx` — AS-IS 산출물
> 원본, `.cs` 소스는 아님) 세 근거로만 채웠다. AS-IS MSSQL(`asis.py`)은 이번 회차도 재시도했으나
> `08001 Login timeout expired` ERROR — SP 본문 4건은 여전히 미확인.
> 설계 근거: `.atlas/gscm-design/SCP0130/design/00_checklist.md`~`03_grid-columns.md`,
> `convert-flow/goal.md`, `convert-flow/plan.md`
> 상태 표기: 구현 / 해당없음 / 확인 필요(사유 명시). "확인 필요"는 `04_react-gap.md`로도 올린다.

## 1. 진입점(entryPoints 13건, toolbarOverride 5 + event 8, `00_checklist.md §4`)

| # | AS-IS name(line) | kind | TO-BE 구현 | 상태 |
|--:|---|---|---|:--:|
| 1 | FindButton(514) → FindData_Main | toolbarOverride | `onSearch` → `setFilters()` + `fetchStaticColumns()` | 구현 |
| 2 | SaveButton(546) → SaveData(3-SP 체인) | toolbarOverride | `onSave` — 중복체크(`findDuplicateScheduledReceiptRows`) → 행별 검증(`validateScheduledReceiptRow`) → `saveWithValidation(…, mutate)` | 구현(SP 미배포로 런타임 미완) |
| 3 | DeleteButton(524, 가드 `fps==null` line526) | toolbarOverride | `onDelete` — 선택행 없으면 return | 구현 |
| 4 | EditButton(533) → SwitchLock(538) | toolbarOverride | `onEdit` — `isEditMode` 토글, `isSheetCellEditable` 이 참조 | 구현(라인 경계 계산으로 EditButton 소속 확정, design 01 §2 #4) |
| 5 | InsertButton(519~523, gridSignal 없음 — Roslyn 만으로 확인 불가) | toolbarOverride | `onInsert` — **AS-IS 화면설계서 엑셀 "3.화면설계_이벤트항목" 시트로 실동작 확정**(design/01_layout.md §2 #5가 Roslyn만으로 "확인 필요"로 남긴 항목을 엑셀 원본으로 해소. `.cs` 소스 자체는 아니므로 완전 확정은 아니나 AS-IS 산출물 근거). `GridAction.addRow` 위임 | 구현(엑셀 근거, `.cs` 원문 재확보 시 재검증 권장) |
| 6 | SpdMain_ActiveSheetChanged(1466) → GetSearchInfo → `SCP0130_GET_SEARCH_INFO` | event | **미구현** — 시트 전환 시 보조정보 패널(그리드 데이터 아님) 갱신. 이 화면 그리드 계약에 영향 없음(design 03 §4) | 해당없음(그리드 외 부가정보, SP 후속) |
| 7 | CboPlanGroup_SelectedIndexChanged(1299) | event | store `setSearchParams` — planGroupIds 변경 시 Site cascade는 클라 필터(design 02 §3) | 구현(2단 cascade는 Site 콤보 미확정으로 부분) |
| 8 | ClbDivision_SelectedIndexChanged(1292) | event | `setSearchParams({divisionId})` → PlanGroup/Site/ChildMaterial 'ALL' 초기화 | 구현 |
| 9 | DatePicker_ValueChanged(1616) | event | 단순 값 저장(재조회 트리거 아님 — Roslyn만으로 확인 불가, 보수적으로 단순 바인딩 처리) | 구현(확인 필요 승계 — 재조회 여부) |
| 10 | SpdMain_CellDoubleClick(1384) → 팝업 | event | `VirtualBomGrid handleDblClick` — ITEM_ID 컬럼만, 헤더 제외, 신규행/편집모드만 | 구현 |
| 11 | SpdMain_ClipboardPasted(1423) | event | `ScheduledReceiptInformationMainGrid`/`VirtualBomGrid`의 `pastedCell` 핸들러 — `OPMZ_PLAN_GR_ID`에 붙여넣은 텍스트가 화면에 이미 로드된 PlanGroup 콤보 옵션의 `NAME`과 일치(같은 DIVISION_ID 한정)하면 `CODE`로 치환. **원문(`.cs:1423-1443`) 미확보라 변환 소스·조건은 추정** — AS-IS가 실제로 PlanGroup NAME→CODE만 다뤘는지(다른 컬럼도 포함했는지)는 확인 불가 | **구현(iter-2 해소, SCP0130-10 — 추정 구현, `.cs` 원문 재확보 시 재검증 권장)** |
| 12 | SpdMain_TopChange(1312) → SmartColMerge(1315) | event | **미구현** — 병합 대상 컬럼 미확인(design 03 §6-8) | 확인 필요 |
| 13 | btnItemId_Click(1445) → 팝업 | event | `ScheduledReceiptInformationForm` — InputField 팝업 버튼 → `MaterialByDivisionModal` | 구현 |

## 2. 버튼 가드(buttonGuards 6건, `00_checklist.md §4d`)

| # | method/condition(line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 1 | DeleteButton `fps==null`(526) | `onDelete` — `selection.row<0`이면 return(메시지 없음) | 구현 |
| 2 | spdMain_CellClick `!IsLock(...)`(1328) | `isSheetCellEditable`(EditButton 토글 + 신규행 예외)로 대체 — 셀 클릭 시 별도 cascade 재호출 로직은 이 화면에 미구현(§1 #7~#9와 연계된 filterCalls#7~9는 그리드 셀 콤보 후보용, 03_grid-columns §4 "그리드 셀 콤보 후보 소스" 참조) | 구현(대체) |
| 3 | spdMain_CellClick `action!=FlagI && !_isEditMode`(1353) | `isSheetCellEditable`의 `crudType(row)==='I'` 우선 분기가 동일 의미 재현 | 구현 |
| 4 | SpdMain_CellDoubleClick `!e.ColumnHeader`(1386) | `handleDblClick`의 `ht.cellType!==CellType.Cell \|\| ht.col<0` | 구현 |
| 5 | SpdMain_CellDoubleClick `IsLock(...) \|\| (action!=I)&&!_isEditMode`(1389) | `handleDblClick`의 `row.CRUD_TYPE!=='I' && !isEditMode` | 구현 |
| 6 | spdSub_ActiveSheetChanging `!IsLock(...)`(1511, MSG00129) | **미구현** — 단일 활성 탭(TabWrapper) 전환 시 편집중 경고. 다중시트 legacy 잔존 여부 미확정(design 01 §5 #5/#8) | 확인 필요 |

## 3. 검증(validations 24건, `03_grid-columns.md §3.1`)

| msgId(대표 line) | AS-IS 의미 | TO-BE 구현 | 상태 |
|---|---|---|:--:|
| MSG00001(792/1078, TO-BE 미배선 — 본문 공백) | 7개 필수값(DIVISION_ID/OPMZ_PLAN_GR_ID/PLANT_SITE_ID/ITEM_ID(_CHILD)/TO_EXPC_QTY/VALID_YN, TO_YYYYMMDD 포함) 공백 차단 | `validateScheduledReceiptRow` — `MSG.REQUIRED_FIELDS='MSG00013'`(근접 등록 코드로 대체, TO-BE MSG00001 은 의미가 다름 — "저장하시겠습니까?"), 7필드 전건 재현 | 구현(대체 코드 사용 — 확인 필요) |
| MSG00046(835/873/1111/1146, 미등록) | Valid To/Arrival Date 필수·형식 | **미구현** — TO-BE 미등록, 이 화면 컬럼 사양상 TO_YYYYMMDD(날짜)는 이미 필수 검증에 포함되나 별도 msgId 배선은 안 함 | 확인 필요(i18n 미등록) |
| (literal, msgId 없음, 900/1172) | 소수 10자리 초과 금지 | `validateScheduledReceiptRow` — `MSG.QTY_DECIMAL_OVERFLOW='MSG00165'`(근접 등록 코드 재사용) | 구현(대체 코드) |
| MSG00050(907/1179, 미등록) | 숫자 형식 아니면 오류 | `validateScheduledReceiptRow` — `MSG.QTY_NOT_NUMBER='MSG00050'`(코드 그대로 유지, TO-BE 미등록이라 화면엔 fallback 문구로만 표시) | 구현(i18n 미등록) |
| MSG00085(890/913/1162/1185/1594, 등록 TODO) | 수량 0 미만 금지 | `validateScheduledReceiptRow` — 0 미만 검사 | 구현(TO-BE 본문 TODO) |
| MSG00004(990/1260, 등록 본문공백) | 저장 SP 성공 알림 | `MSG.NO_CHANGE='MSG00004'` — 저장 대상 없음 알림으로 재사용(원 의미는 SP 성공 콜백이라 완전 일치 아님) | 구현(의미 재해석 — 확인 필요) |
| MSG00260(1097, 등록 본문존재) | Division/PlanGroup/Site/ItemChild/ValidTo 조합 중복 | `findDuplicateScheduledReceiptRows` | 구현 |
| MSG00129(1515, 등록) | 편집중 시트 전환 경고 | **미구현**(§2 #6과 동일) | 확인 필요 |
| MSG00193(1590, 미등록) | 공용 숫자검증 UPPER_ZERO 분기 | 해당 없음(도달 컬럼 미확정, design 03 §3.1) | 확인 필요 |
| MSG00160(1599, 미등록) | 공용 숫자검증 OVER_DAY_MIN 분기 | 해당 없음(이 화면에 "최소일수" 개념 컬럼 미식별, dead branch 의심 — design 03 §6-8) | 확인 필요 |

## 4. 그리드 시그널(gridSignals 24건, `03_grid-columns.md §3`)

| # | call(line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 1 | SetReNumerCellType TO_EXPC_QTY(420) | `SCM_MST_SHEET_COLUMNS.CELL_CONTROL_OBJECT_TYPE_CODE='FPNumber'`+`DATA_SCALE_NUMBER=3`(2 sheetNm, `05_register.sql` 8번 블록, ora.py exec 적용+재조회 확인) + 저장 검증(소수 10자리 초과 금지) — 표시 자릿수는 admin 메타 경로로 이관(코드 하드코딩 아님, CLAUDE.md §2 체크4 준수). 화면 코드 `QTY_DECIMAL_DIGITS` 상수는 무의미해져 삭제 | **구현(iter-2 해소, SCP0130-02)** |
| 2,3,5 | SetSheetHeaderColumnSCP/VisibleTab(433,435,445) | `staticColumns` admin fetch + `TabWrapper` 탭 노출 | 구현(대체) |
| 4 | ChangeActiveSheet(sht01VirtualBom, 444) | 초기 활성 탭 = Virtual Bom(`SHEET_INDEX.VIRTUAL_BOM=0`, 기본 state) | 구현 |
| 6 | SetSheetHeaderColumnSCP siObj(462) | 정체 미상(design 03 §6-1) | 확인 필요 |
| 7 | Delete(529) | `onDelete` → `GridAction.removeRow` | 구현 |
| 8 | SwitchLock(538) | `onEdit`의 `isEditMode` 토글 | 구현 |
| 9,10,12,15,16,18,19 | LockColumn/LockRange(539,541,651,686,687,697,698) | `isSheetCellEditable` — `LOCKED_ALWAYS`(DIVISION_ID/감사4컬럼/PRE_KEY_VALUES) 항상 잠금 + 신규행 예외 + 조회직후 전체잠금 | 구현 |
| 11 | Query(650) | `useTabProcQuery` → `o_rc1` → rows | 구현(SP 미배포로 런타임 미완) |
| 13,14,17 | Insert/SetValue defaultData(673,684,695) | `virtualBomInsertDefaults`/`scheduledReceiptInsertDefaults` — Division만 조회조건값 상속, 나머지는 빈 값(원식 미확인, SCP0122/SCP0127/SCP0128 선례) | 구현(확인 필요 — defaultData 원문) |
| 20 | SmartColMerge(1315) | **미구현** — 대상 컬럼 미확인. `allowMerging` prop 자체를 지정하지 않아 임의 병합을 걸지 않음(추측 금지) | 확인 필요 |
| 21 | SetText ITEM_ID(1415) | `VirtualBomGrid setSelectedValue` — `editTrackerRef.storeChange` + `row.ITEM_ID = items` | 구현 |
| 22 | SetValue OPMZ_PLAN_GR_ID=codeVal(1437) | 셀콤보 `PlanGroup` SQL_ID 등록 완료(`PlanGroup_SCP_ALL` 미러, `05_register.sql` 7번 블록) — admin fetch 경로(staticColumns)로 자동 렌더 | **구현(iter-2 해소, SCP0130-01)** |
| 23 | SetValue(nRow,nCol,0)(1569) | 대상 컬럼 미확인 | 확인 필요 |
| 24 | SetActiveCell(1605) | 순수 UX(포커스 복원) — 데이터 계약 영향 없음, 미구현해도 무방(design 03 §3 판정) | 해당없음(UX 선택사항) |

## 5. 컨트롤/레이아웃(controls 30건, `00_checklist.md §1`)

| AS-IS 영역 | TO-BE 구현 | 상태 |
|---|---|:--:|
| `usrLayoutControl2`/`layoutControlGroup2`/`pnlCondition` | `SearchArea`(`ScheduledReceiptInformationForm`) + `MainTitle.openSearchArea` 토글 | 구현 |
| 조회조건 7논리조건(8컨트롤) | Division/Valid/ItemId(+팝업)/PlanGroup/FromDate 5건 데이터 배선 완료, Site/ChildMaterial 2건은 comboId 미확정으로 UI 골격만 노출(disabled) | 구현(2건 콤보 등록 후속) |
| `spdMain`/`spdMain_Sheet1`(2 sheetNm) | `TabWrapper` + `ScheduledReceiptInformationVirtualBomGrid`/`ScheduledReceiptInformationMainGrid` | 구현 |
| `usrButton1`(x0/y0/tab0, 용도불명) | **렌더 제외** — 이벤트·핸들러 전건 미검출(design 01 §1), 다른 화면 dead-control 선례(SCP0128 usrButton1)와 동일 좌표 패턴 | 구현(제외, 원문 재확보 시 재검증 권장) |
| static(`components`,`emptySpaceItem*`) | 비시각 — 매핑 대상 아님 | 해당없음 |

## 6. 콤보(comboCalls 1 + filterCalls 5, `00_checklist.md §4b/§4c`)

| 조건 | AS-IS 근거 | TO-BE comboId | 상태 |
|---|---|---|:--:|
| Division | `BLUtils.GetDivision(false,"")`→`dtMyDivision` | `COMBO.DIVISION='MyDivision'`(변수명 일치 강한 정황, BLUtils 소스·AS-IS DB 둘 다 미확보로 5층 완전대조 미완) | 구현(확인 필요 — EE 노출 QA) |
| Plan Group | `dtPlanGroupAll`(최초적재 경로 미포착) → `RefreshPlanGroupByDivision` 클라필터 | `COMBO.PLAN_GROUP='PlanGroup_SCP_ALL'`(전량로드+클라필터 패턴 일치, 5층 대조 미완) | 구현(확인 필요) |
| Site | `dtPlantSiteAll`/`dtPlantSiteTemp`, Division 1차+PlanGroup 2차 cascade | **미배선** — 후보 다수(`PlantSiteByDivision` 등)이나 이름 유사성만으로 단정 금지(SCP0022 오배선 선례), UI 골격만 노출 | 확인 필요 |
| Child Material | `dtItemIdChildlAll`, Division 필터 | **미배선** — `SCM_ADM_CMBO_SQL_M` 0건(미등록), AS-IS 실측 불가(DB ERROR)로 등록 불가 | 확인 필요(AS-IS 축단, 등록 보류) |
| Valid(조회조건) | UsrComboBox 정적 하드코딩(Designer.cs 미확보) | 정적 옵션 All/Y/N — 화면설계서 엑셀 "1.화면 개요" 목업("Valid \| All ▼") + 그리드 VALID_YN 값역(Y/N) 실측으로 확정 | 구현(엑셀 근거) |
| 그리드 셀 `OPMZ_PLAN_GR_ID`(FPComboBox) | `PlanGroup` SQL_ID(2 sheetNm 공통) | **등록 완료**(`PlanGroup_SCP_ALL`의 기존 AS-IS 실측·변환 SQL 본문을 그대로 복제 등록, `ora.py exec` 적용+재조회 확인) | **구현(iter-2 해소, SCP0130-01)** |
| 그리드 셀 `PLANT_SITE_ID`/`ITEM_ID_CHILD`/`VALID_YN`(Scheduled Reciept Information 시트) | `CELL_COMBO_DATA_TYPE`='PlantSiteSir'/'ItemIdChild'/'ValidYn' 값은 있으나 `SCM_ADM_CMBO_SQL_M`/`SCM_ADM_LOOKUP_MASTER_DETAIL` 전부 0 rows(재확인, ora.py) — PlanGroup과 달리 재사용할 기존 등록 콤보가 없어 미러 등록 불가 | 미완(확인 필요, SCP0130-05 — AS-IS 축단) |
| Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSite` | 등록은 돼 있으나(`USE_YN=Y`) SQL 본문이 `DM_PLN_MKT_FCST`(수요계획 시장예측) JOIN 기준(재확인, `ora.py`로 SQL_DTL_CTN 재조회) — SCP0130(자재포장재 예정입고) 도메인과 의미 불일치 의심(§2.6 "이름 유사 재사용 금지" 패턴과 일치) | 확인 필요(SCP0130-04, AS-IS `.cs`/SP 원문 대조 전까지 재사용 여부 미확정) |

## 7. 저장 계약(spCalls 4건, `00_checklist.md §4`)

| AS-IS SP | TO-BE | 상태 |
|---|---|---|
| `SCP0130_GET_VIRTUAL_BOM`(7파라미터: Division/PlanGroup/Site/Item/ItemChild/ValidYn/FromDate) | `useTabProcQuery` ×2(sheet별) — `filters={divisionId,planGroupId,siteId,itemIdChild,validYn,fromDate,itemId}` | 구현(SP 미배포로 런타임 미완, `PKG_SCP0130` 배포는 convert-sp 소관) |
| `SCP0130_GET_SEARCH_INFO`(파라미터 Division/Site) | 미구현 — 그리드 데이터 아닌 보조정보 패널(§1 #6) | 해당없음(범위 밖) |
| `SCP0130_SVAE_VIRTUAL_BOM`(원문 오탈자 그대로 유지, PRE_* 포함) | `useProcMutation`(virtualBom) — `saveWithValidation` 경유 | 구현(SP 미배포로 런타임 미완) |
| `SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMATION`(PRE_* 5종 포함) | `useProcMutation`(scheduledReceipt) — `saveWithValidation` 경유. 저장 후 `GET_VIRTUAL_BOM` 재조회는 React Query invalidate 표준 경로로 대체(공용 mutation 계층) | 구현(SP 미배포로 런타임 미완) |

## 7a. 필수값 게이트 이원화 확인(react-gap-audit iter-2 SCP0130-14)

`OPMZ_PLAN_GR_ID` 등 컬럼 라벨은 `Plan Group*`처럼 `*`(필수 표시)가 붙어 `hasRequiredMark`(관리자
UI 라벨 규약)로는 필수 컬럼으로 인식된다. 그러나 `useSaveWithValidation.ts`의
`isEditableForRow`(packages/shared/src/hooks/useSaveWithValidation.ts:25-38)는 `column.inputTpCd`가
`MANDATORY`/`OPTIONAL`/`*_INSERT_ONLY`가 아니면(즉 `SEARCH_ONLY` 또는 미등록, default 분기) 무조건
`false`를 반환한다 — 이 화면은 `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD`가 27컬럼 전건 `'S'`
(design/03_grid-columns.md §1)이므로 라벨의 `*` 인식 여부와 무관하게 `findMissingMandatory`가
이 화면 컬럼을 단 하나도 검사 대상에 넣지 못한다(공통 훅 경로는 형식상 통과만 함).

따라서 이 화면의 실질적 필수값 게이트는 `utils/scheduledReceiptInformationSaveValidation.ts`의
`validateScheduledReceiptRow`(이미 구현됨, DIVISION_ID/OPMZ_PLAN_GR_ID/PLANT_SITE_ID/ITEM_ID_CHILD/
TO_YYYYMMDD/TO_EXPC_QTY/VALID_YN 7개 전건 검사)가 유일한 방어선이며, `onSave`(ScheduledReceiptInformation.tsx)
에서 `saveWithValidation`(공통 훅) 호출 전에 이 커스텀 검증을 먼저 통과시키는 순서로 이미 배선돼 있다.
`INPUT_TP_CD`를 `M`/`IM`으로 임의 변경해 공통 훅 경로를 활성화하는 것은 admin 메타 임의 변경
(convert-core §2.3, CLAUDE.md §2 체크4 위반)이므로 하지 않는다 — admin UI에서 이 값을 재등록할지는
사용자 판단 대상으로 남긴다(design/03_grid-columns.md §1 "중요 확인 필요" 각주와 동일 결론).

## 8. 미완 / 후속

iter-2(react-gap-audit iter-2 gap-audit.md) 재검증 결과 — AS-IS MSSQL(`asis.py`)은 이번 회차도
재시도했으나 동일하게 `08001 Login timeout expired` ERROR(재확인 시각: 이 회차 실행 시점). 아래
표는 회차 시작 시점 기준으로 갱신했다.

| 축 | 상태 | 사유 |
|---|---|---|
| `PKG_SCP0130`(GET_VIRTUAL_BOM/GET_SEARCH_INFO/SVAE_VIRTUAL_BOM/SAVE_SCHEDULED_RECIEPT_INFORMATION) 런타임 | 미완 | TO-BE 미배포(`all_objects` 0건) — `convert-sp` 후속 |
| 그리드 셀 콤보 `PlanGroup`(SCP0130-01) | **해소** | `PlanGroup_SCP_ALL`(기존 AS-IS 실측·변환 완료본) SQL_DTL_CTN 을 그대로 복제해 `SQL_ID='PlanGroup'`로 등록(`ora.py exec` 적용 + 재조회 확인, `05_register.sql` 7번 블록) — 같은 CODE(`PlanGroup`)·같은 SP 변형(`CommonAll`/`_SCP_ALL`)이라 §2.6 5층 대조상 값 변경 없는 복제 |
| TO_EXPC_QTY 소수 3자리 셀 렌더(SCP0130-02) | **해소** | `SCM_MST_SHEET_COLUMNS.CELL_CONTROL_OBJECT_TYPE_CODE='FPNumber'`+`DATA_SCALE_NUMBER=3`(두 sheetNm) 등록 — AS-IS gridSignal#1 `SetReNumerCellType(...,0,3)` 실측을 메타로 이관(`05_register.sql` 8번 블록, 적용+재조회 확인). 화면 코드 `QTY_DECIMAL_DIGITS` 상수는 이제 무의미해 삭제(미참조 orphan) |
| 그리드 셀 콤보 `PlantSiteSir`/`ItemIdChild`/`ValidYn`(SCP0130-05) 등록 | 미완(확인 필요) | AS-IS MSSQL 접속 ERROR로 실데이터 이관 불가(임의 등록 금지) — PlanGroup과 달리 재사용할 기존 등록 콤보가 없음(0 rows 그대로) |
| Virtual Bom `PLANT_SITE_ID` 콤보 `PlantSite` 도메인 불일치 의심(SCP0130-04) | 확인 필요(재확인) | `ora.py`로 `SQL_DTL_CTN` 재실측 — `DM_PLN_MKT_FCST`(수요계획 시장예측) JOIN 확정(§2.6 "이름 유사 재사용 금지" 해당 패턴과 일치하는 정황). 단 AS-IS `.cs`/SP 원문 미확보라 SCP0130이 실제로 이 콤보를 그대로 썼는지(공용 프레임워크가 의도적으로 수요계획 사이트 후보를 재사용했을 가능성 포함) 확정 불가 — 화면 코드는 그대로 두고(admin 메타 재등록은 사용자 판단), 이 사실만 기록 |
| 조회조건 Site/Child Material 콤보 배선(SCP0130-03) | 미완(확인 필요) | 동일 사유(AS-IS ERROR) — UI 골격만 노출 |
| SmartColMerge 병합 대상 컬럼(SCP0130-08) | 미구현(확인 필요) | `.cs` 원문 미확보로 대상 컬럼 특정 불가 |
| SpdMain_ClipboardPasted 파생 로직(SCP0130-10) | **해소(추정 구현)** | `ScheduledReceiptInformationMainGrid.tsx`/`ScheduledReceiptInformationVirtualBomGrid.tsx`에 `pastedCell` 핸들러 추가 — `OPMZ_PLAN_GR_ID` 붙여넣기 시 PlanGroup 콤보 옵션(NAME↔CODE, DIVISION_ID 한정)으로 치환. AS-IS `.cs` 원문 미확보로 변환 로직 원본과의 완전 일치는 확인 불가(추정 구현) — 원문 재확보 시 재검증 권장 |
| From Date 기본값 자동세팅(react-gap-audit issue ID `SCP0130-07` — 이 파일 자체 §7 번호체계와는 별개 ID, 아래 `usrButton1` 행의 `SCP0130-07`과 혼동 주의) | **해소(추정 구현)** | `useScheduledReceiptInformationStore.ts` `initSearchParams.fromDate`를 `utils/scheduledReceiptInformationDate.ts`의 `thisWeekMonday()`(ISO 월=1 기준 금주 월요일, `YYYYMMDD`)로 배선. AS-IS `.cs:215-229 setDatePicker()` 원문 미확보로 알고리즘 완전 일치는 확인 불가(추정 구현) — 원문 재확보 시 재검증 권장 |
| spdSub_ActiveSheetChanging(MSG00129) 편집중 경고(SCP0130-09) | 미구현(확인 필요) | 다중시트 legacy 잔존 여부 미확정 |
| SetActiveCell 포커스 복원(SCP0130-11) | 미구현(선택사항) | design 03 §3 자체판정 데이터계약 영향없음 — 필요시만 구현 대상, 이번 회차 미착수 |
| i18n 갭(MSG00046/050/160/193 미등록, SCP0130-12) | 미완(확인 필요) | `ora.py` 재조회로 4종 전부 0 rows 재확인 — admin 메타 등록 예외(b) 경로이나 AS-IS 원문 문구 확보 불가, 사용자 협의로 정확한 문구 확정 필요(임의 등록 금지) |
| formatItem(wj-cell-editable 시각 강조, SCP0130-06) | **해소** | `ScheduledReceiptInformationMainGrid.tsx`/`ScheduledReceiptInformationVirtualBomGrid.tsx`에 `formatItem` 핸들러 추가 — 공용 `DataGrid` wrapper(`GridUtils.isEditableCell`)가 `INPUT_TP_CD='S'`(SEARCH_ONLY 분기, 전 컬럼)라 무조건 `false`를 반환해 `wj-cell-editable`을 못 붙이는 것을, 이 화면의 실질 판정 함수(`isSheetCellEditable`)로 사후 재토글해 해소 |
| InsertButton 사전조건 가드(SCP0130-13) | 확인 필요(재검증) | `packages/foundation/src/utils/gridAction.ts:857` `addRow`는 `addRowSet`(808행)에 위임하고, 그 내부 가드(818행)는 `itemsSource.length !== 0 && editFlag`(빈 그리드는 무조건 통과)만 확인 — AS-IS `InsertButton` override 본문(line519~523, 5줄)이 여기 없는 사전조건 가드를 실제로 갖고 있는지는 `.cs` 원문을 읽어야 확정된다(design/01_layout.md §5 #3와 동일 결론). `.cs` 원문이 이 세션에서도 확보되지 않아(§0 재확인) 가드 신설을 보류 — 화면 로컬에 임의 가드를 추가하면 오히려 AS-IS에 없는 제약을 만들 위험(anti-simplification §1)이 있어 손대지 않았다 |
| `OPMZ_PLAN_GR_ID` 필수 라벨(*) vs `INPUT_TP_CD='S'` 불일치(SCP0130-14) | **문서화 완료** | §7a 신설 — `useSaveWithValidation.isEditableForRow`가 SEARCH_ONLY 분기에서 항상 false 라 공통 훅 경로는 이 화면에 무효이고, 커스텀 `validateScheduledReceiptRow`가 유일한 방어선임을 코드 근거(file:line)로 확정 기록 |
| `usrButton1`(용도불명, SCP0130-07) | 확인 필요(재확인, 확정도 낮음 유지) | `.cs`/`.Designer.cs` 원본이 이 세션에서도 확보되지 않아(§0) 렌더 제외 판정을 변경할 근거가 늘지 않음 — 기존 판정(제외) 유지, 재확정 불가 |
| InsertButton 실동작 판정 자체(NO-OP 여부) | 구현(엑셀 근거, 확정도는 `.cs` 원문보다 낮음, 유지) | `.cs` 원문 재확보 시 재검증 권장 — 이번 회차도 원문 미확보로 변경 없음 |
| 브라우저 시각·조작감(그리드 렌더, 콤보 드롭다운) | 미완(사용자 확인 축) | 정적 검증으로 대체 불가 |

## UI 공통(통합테스트) 체크 축 (전 화면 상시 6+1항목)

| ID | 요지 | 구현 위치 | 상태 |
|---|---|---|:--:|
| COMMON:UC-01 | 필터 상태 Insert 시 필터 유지 | `onInsert` → `GridAction.addRow` | 구현 |
| COMMON:UC-02 | 수정 중 재조회 confirm | 공용 `SearchArea.onSearch`/`SubTitle` 단축키 dirty 시 confirm 경유 | 구현(공용 경로) |
| COMMON:UC-03 | Column 설정 적용 시 Reset 후 재조회 | 해당없음 — Measure 0행(pivot 없음), Column Settings UI 미사용 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 Toast(실패/차단은 Alert) | 저장 완료=공용 mutation 성공 Toast, 검증 실패=`setAlert` | 구현 |
| COMMON:UC-05 | Excel 콤보 Code→Name 출력 | `SubTitle excelFileName='ScheduledReceiptInformation'` 공용 경로 | 구현 |
| COMMON:UC-06 | Key-in 콤마 다중조회 | 해당없음 — Item ID 는 팝업 단일선택 | 해당없음 |
| COMMON:UC-07 | 필터 상태 재조회 시 필터 유지 | 공용 `DataGrid` rebindFilterColumns 경유 | 구현 |
