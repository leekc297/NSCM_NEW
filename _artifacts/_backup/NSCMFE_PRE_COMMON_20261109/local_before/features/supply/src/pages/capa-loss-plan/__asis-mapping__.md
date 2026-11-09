# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md`, `01_layout.md`, `02_search-combo.md`, `03_grid-columns.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 Division / LayoutControlItem | components/CapaLossPlanForm.tsx:109 (FormItem label LBL00641 'Division' — cboDivision 라벨) | — | 구현 |
| D00-1-002 | §1 Division1 / LayoutControlItem | components/CapaLossPlanForm.tsx:124 (FormItem label LBL00053 'Plan Month' — cboVersion 라벨. Text 가 컨트롤명과 다른 것을 그대로 재현) | — | 구현 |
| D00-1-003 | §1 Division3 / LayoutControlItem | components/CapaLossPlanForm.tsx:163 (FormItem label LBL00014 'Status' — cboProgressStatus 라벨) | — | 구현 |
| D00-1-004 | §1 PlanType / LayoutControlItem | components/CapaLossPlanForm.tsx:156 (FormItem label='' — AS-IS `TextVisible=false` 재현. 라벨을 붙이면 캡처와 달라진다) | — | 구현 |
| D00-1-005 | §1 VersionSeq / LayoutControlItem | components/CapaLossPlanForm.tsx:139 (FormItem label LBL00606 'Version' — cboVersionSeq 라벨) | — | 구현 |
| D00-1-006 | §1 btnColumn / UsrButton | CapaLossPlan.tsx:329~335 (customButtons Column Setting + IcGridColumnSetup — AS-IS 조회영역 우측 아이콘을 SubTitle 로 이동, 01 L-34) | — | 구현 |
| D00-1-007 | §1 btnItemId / UsrButton | components/CapaLossPlanForm.tsx:396~403 (InputField endAdornment Button + FunctionSearchIcon -> onOpenItemPopup) | — | 구현 |
| D00-1-008 | §1 cboDivision / UsrCombo | components/CapaLossPlanForm.tsx:112 (CustomDropdown value=sc.divisionId options=combos.divisionOptions) | — | 구현 |
| D00-1-009 | §1 cboProgressStatus / UsrCombo | components/CapaLossPlanForm.tsx:166 (CustomDropdown options=combos.statusOptions) | — | 구현 |
| D00-1-010 | §1 cboSheetType / UsrCombo | components/CapaLossPlanForm.tsx:185 (CustomDropdown options=sheetTypeOptions) + capa-loss-plan.constants.ts:115 SHEET_TYPE(MODEL/LINE 코드 하드코딩 재현) | — | 구현 |
| D00-1-011 | §1 cboVersion / UsrCombo | components/CapaLossPlanForm.tsx:127 (CustomDropdown options=combos.versionOptions) | — | 구현 |
| D00-1-012 | §1 cboVersionSeq / UsrCombo | components/CapaLossPlanForm.tsx:142 (CustomDropdown options=combos.versionSeqOptions) | — | 구현 |
| D00-1-013 | §1 chkShowRate / UsrCheckBox | components/CapaLossPlanForm.tsx:419 (Checkbox checked=sc.showRate labelText LBL01117 'Show Rate Columns') | 노출·초기체크만 구현이 파리티다 — 토글 대상 `M_00`(개선율)이 TVF 0건 생성 사문이라 실효 무동작(03 R-02/V-19, 본 문서 §4) | 구현 |
| D00-1-014 | §1 clbElectrodeType / UsrCheckedList | components/CapaLossPlanForm.tsx:358 (CustomDropdown multiple allOption options=combos.lineTypeOptions — Line Type) | — | 구현 |
| D00-1-015 | §1 clbFactory / UsrCheckedList | components/CapaLossPlanForm.tsx:281 (CustomDropdown multiple allOption options=combos.buildingOptions — 라벨은 'Building') | — | 구현 |
| D00-1-016 | §1 clbLine / UsrCheckedList | components/CapaLossPlanForm.tsx:305 (CustomDropdown multiple allOption options=combos.lineOptions) | — | 구현 |
| D00-1-017 | §1 clbOperation / UsrCheckedList | components/CapaLossPlanForm.tsx:334 (CustomDropdown multiple allOption options=combos.operationOptions) | — | 구현 |
| D00-1-018 | §1 clbPlant / UsrCheckedList | components/CapaLossPlanForm.tsx:255 (CustomDropdown multiple allOption options=combos.plantOptions) | — | 구현 |
| D00-1-019 | §1 clbSite / UsrCheckedList | components/CapaLossPlanForm.tsx:229 (CustomDropdown multiple allOption options=combos.siteOptions) | — | 구현 |
| D00-1-020 | §1 emptySpaceItem1 / EmptySpaceItem | — | DevExpress 레이아웃 여백 노드 — 00 §5 static 4행 "여백은 CSS". TO-BE 는 공용 SearchArea + `Grid size` 12분할이 간격을 담당해 대응 DOM 이 없다. 빈 래퍼 생성은 hook #132 위반 | 제외 |
| D00-1-021 | §1 emptySpaceItem2 / EmptySpaceItem | — | DevExpress 레이아웃 여백 노드 — 00 §5 static 4행 "여백은 CSS". TO-BE 는 공용 SearchArea + `Grid size` 12분할이 간격을 담당해 대응 DOM 이 없다. 빈 래퍼 생성은 hook #132 위반 | 제외 |
| D00-1-022 | §1 emptySpaceItem4 / EmptySpaceItem | — | DevExpress 레이아웃 여백 노드 — 00 §5 static 4행 "여백은 CSS". TO-BE 는 공용 SearchArea + `Grid size` 12분할이 간격을 담당해 대응 DOM 이 없다. 빈 래퍼 생성은 hook #132 위반 | 제외 |
| D00-1-023 | §1 imageList1 / ImageList | — | 비가시 리소스 컨테이너 — 00 §5 static "ImageList 는 미이식". 아이콘은 `@foundation/assets`·`@shared/lges-icons` 컴포넌트로 대체된다(CapaLossPlan.tsx:5, components/CapaLossPlanForm.tsx:6) | 제외 |
| D00-1-024 | §1 layoutControlGroup1 / LayoutControlGroup | — | 사장 노드 · 참조 0건(01 L-09) — 본 문서 §4 미이식 확정. 만들면 빈 래퍼 = hook #132 위반 | 제외 |
| D00-1-025 | §1 layoutControlGroup2 / LayoutControlGroup | components/CapaLossPlanForm.tsx:99 (`<SearchArea>` = 살아있는 조회조건 그룹 컨테이너. 1·2행 conditions / 3행 extraConditions 2단 구조로 대응) | — | 구현 |
| D00-1-026 | §1 layoutControlItem1 / LayoutControlItem | CapaLossPlan.tsx:334 (`buttonLabel: ''` — btnColumn 라벨 `TextVisible=false` 재현. 아이콘만 노출) | — | 구현 |
| D00-1-027 | §1 layoutControlItem10 / LayoutControlItem | components/CapaLossPlanForm.tsx:396~403 (Button 에 label 없이 iconComponent 만 — btnItemId 라벨 `TextVisible=false` 재현) | — | 구현 |
| D00-1-028 | §1 layoutControlItem2 / LayoutControlItem | components/CapaLossPlanForm.tsx:252 (FormItem label LBL00030 'Plant') | — | 구현 |
| D00-1-029 | §1 layoutControlItem4 / LayoutControlItem | components/CapaLossPlanForm.tsx:278 (FormItem label LBL00008 'Building' — 컨트롤명 clbFactory 이지만 표기는 Building) | — | 구현 |
| D00-1-030 | §1 layoutControlItem6 / LayoutControlItem | components/CapaLossPlanForm.tsx:302 (FormItem label LBL00010 'Line') | — | 구현 |
| D00-1-031 | §1 layoutControlItem8 / LayoutControlItem | components/CapaLossPlanForm.tsx:226 (FormItem label LBL00015 'Site') | — | 구현 |
| D00-1-032 | §1 lciDivisionType / LayoutControlItem | components/CapaLossPlanForm.tsx:208 (FormItem label='' — lciDivisionType `TextVisible=false`. LBL00038 은 선택지이지 필드명이 아니다) | — | 구현 |
| D00-1-033 | §1 lciElectrodeType / LayoutControlItem | components/CapaLossPlanForm.tsx:61~63 showElectrodeType + :352 조건부 렌더 — MODULE_PACK·ELTR 숨김, CELL 만 표시 | `=== 'CELL'` 로 단순화하지 않는다 — 미선택(-1) 동작이 달라지고 SCP0105 는 규칙 자체가 다르다(01 L-02) | 구현 |
| D00-1-034 | §1 lciItem / LayoutControlItem | components/CapaLossPlanForm.tsx:379~383 (라벨 동적 — showOperation 이면 LBL00054 'Basic Nickname', ELTR 이면 LBL00669 'Model') | 조건은 `!== ELTR` 다. `showElectrodeType`(CELL 전용)을 쓰면 Module/Pack 에서 'Model' 이 떠 틀린다(01 L-03) | 구현 |
| D00-1-035 | §1 lciOperation / LayoutControlItem | components/CapaLossPlanForm.tsx:60 showOperation + :328 조건부 렌더 — ELTR 숨김, 그 외 표시 | — | 구현 |
| D00-1-036 | §1 lciShowRate / LayoutControlItem | components/CapaLossPlanForm.tsx:68 showShowRate + :414 조건부 렌더 — 컷오프(1ST·2ND) && LINE 이면 숨김 | — | 구현 |
| D00-1-037 | §1 rgrpDivisionType / RadioGroup | components/CapaLossPlanForm.tsx:75~82 divisionTypeOptions(Electrode/Cell/Module-Pack 순서 그대로) + :210 CustomDropdown | NSCM 공용에 RadioGroup 이 없어 단일선택 드롭다운으로 매핑(자매 SCP0105/0114 동일 판단) | 구현 |
| D00-1-038 | §1 spdMain / FpSpread | components/CapaLossPlanGrid.tsx:327 (`<DataGrid>` 1개 + `sheetName` prop 스위치 — 8시트를 탭이 아니라 스위치로, 03 R-01) | — | 구현 |
| D00-1-039 | §1 spdMain_Sheet1 / SheetView | — | Designer 가 만든 **빈 초기 시트**이고 런타임은 `AddSheet` 8시트로 대체된다(00 §1 #39, cs:1585~1588) — 설계시점 placeholder 라 이식 대상이 아니다. TO-BE 는 DataGrid 1개 + sheetName 스위치(03 R-01) | 제외 |
| D00-1-040 | §1 txtItem / TextBox | components/CapaLossPlanForm.tsx:386~392 (InputField value=sc.nickName — 팝업 결과 표시 + 직접 key-in) | 대소문자 변환을 넣지 않는다 — 서버가 `MDL_NM` 정확매칭이라 `UPPER()` 임의 추가 금지 | 구현 |
| D00-1-041 | §1 txtPlanType / TextBox | components/CapaLossPlanForm.tsx:157 (InputField disabled value=planType) + utils/capaLossPlan.combos.ts:120 derivePlanType(BIZ_PLAN_USE_YN -> BP/RP) | — | 구현 |
| D00-1-042 | §1 ucpSheetType / LayoutControlItem | components/CapaLossPlanForm.tsx:67 showSheetType + :179 조건부 렌더 — progressStatus in {'1','2'} 일 때만 표시 | 라벨을 붙이지 않는다 — AS-IS `ucpSheetType.Text="Status"` 는 `TextVisible=false` 라 화면에 안 뜬다(01 L-04) | 구현 |
| D00-1-043 | §1 usrConditionPanel1 / UsrConditionPanel | components/CapaLossPlanForm.tsx:99 (`<SearchArea>` 공용 조건패널 — searchButtonLabel/isHidden/onSearch 배선) | — | 구현 |
| D00-1-044 | §1 usrLayoutControl1 / UsrLayoutControl | — | 사장 노드 · 참조 0건(01 L-08) — 본 문서 §4 미이식 확정. 만들면 빈 래퍼 = hook #132 위반 | 제외 |
| D00-1-045 | §1 usrLayoutControl2 / UsrLayoutControl | CapaLossPlan.tsx:103 noDivisionAuth(초기화 후 divisionOptions 0건) + :105~113 안내 1회(MSG00667) + :351 `disabled={noDivisionAuth}` 로 조회영역 전체 비활성 | AS-IS `SetDivisionAuthCheck(usrLayoutControl2)`(cs:1488~1489) 대응. AS-IS 번호 MSG00097 을 그대로 쓰면 TO-BE 에서 "Please select Division." 이 뜬다(01 L-07, hook #114) | 구현 |
| D00-2-001 | §2 _defaultDataModel / Changed | components/CapaLossPlanGrid.tsx:229~238 cellEditEnded 핸들러 -> hooks/useCapaLossPlanCellEdit.ts:104 handleCellEditEnded(재계산 디스패치) | AS-IS 는 `AfterFindData`(cs:2758~2761)에서 `-=` 후 `+=` 동적 배선. TO-BE 는 공용 EditTracker 뒤에 등록되는 정적 핸들러 1개로 대체 | 구현 |
| D00-2-002 | §2 btnColumn / Click | CapaLossPlan.tsx:332 setOpenColumnSetting(true) -> components/CapaLossPlanColumnModal.tsx:40 ColumnLayoutModal, OK 시 :73 clearFilters() | AS-IS 는 OK 에서 `BeforeFindData()` = 헤더 재구성 + 그리드 비움이고 **재조회는 하지 않는다**(V-60) — 그대로 재현 | 구현 |
| D00-2-003 | §2 btnItemId / Click | CapaLossPlan.tsx:350 onOpenItemPopup -> components/CapaLossPlanItemPopup.tsx:43~52 onSelect(빈 결과면 기존 값 유지) | 반환 컬럼이 DivisionType 으로 갈린다 — Cell/Module-Pack `nickName` / Electrode `itemId`(components/CapaLossPlanItemPopup.tsx:45~47) | 구현 |
| D00-2-004 | §2 cboDivision / SelectedIndexChanged | CapaLossPlan.tsx:137~146 division 변경 effect(EditTracker clear + 필터 비움 + 개인화 초기화 + 컬럼메타 재fetch) + hooks/useCapaLossPlanCombos.ts:233~246 하위 콤보 기본선택 재계산 | 컬럼 메타는 division 스코프라 새 값을 **인자로** 넘긴다 — producer 안에서 get() 하면 컬럼셋이 한 스텝 밀린다 | 구현 |
| D00-2-005 | §2 cboProgressStatus / SelectedIndexChanged | useCapaLossPlanStore.ts:197~209 setProgressStatus (Operation·LineType 만 ALL 리셋 + 그리드 비움) + components/CapaLossPlanForm.tsx:172 onChange | AS-IS 가 `RefreshSheetType()` 뒤 `cboSheetType_SelectedIndexChanged(null,null)` 를 직접 호출하므로 1회 변경이 4효과를 함께 낸다 — useEffect 2개로 쪼개면 순서가 어긋난다(02 §5.4) | 구현 |
| D00-2-006 | §2 cboSheetType / SelectedIndexChanged | components/CapaLossPlanForm.tsx:189~196 onChange(sheetType + operationId/electrodeType ALL 리셋) + :67~68 ucpSheetType·lciShowRate 가시성 파생 | 재구성 범위가 Operation·Line Type 뿐이다 — Site/Plant/Building/Line 선택은 보존(02 §0 #9, F-20) | 구현 |
| D00-2-007 | §2 cboVersion / SelectedIndexChanged | CapaLossPlan.tsx:154~162 version/versionSeq 키 변경 effect(EditTracker clear + 그리드 비움) + hooks/useCapaLossPlanCombos.ts:106~114 versionOptions/versionSeqOptions 재계산 | — | 구현 |
| D00-2-008 | §2 cboVersionSeq / SelectedIndexChanged | CapaLossPlan.tsx:154~162 (동일 effect — versionSeq 축) + hooks/useCapaLossPlanCombos.ts:253~259 planType·currVersionProgressStatus 갱신 | AS-IS 는 이 핸들러만 `BeforeFindData` 를 **먼저** 부른다(00 §2 #8). TO-BE 는 두 축이 같은 effect 라 순서 차이가 관측되지 않는다 | 구현 |
| D00-2-009 | §2 chkShowRate / CheckedChanged | components/CapaLossPlanForm.tsx:423 onChange -> setSearchCondition({ showRate }) | 토글 대상 `M_00` 이 0건이라 화면이 바뀌지 않는 것이 파리티다(03 R-02/V-19) — 동작을 "만들어 주지" 않는다 | 구현 |
| D00-2-010 | §2 clbFactory / SelectedIndexChanged | components/CapaLossPlanForm.tsx:287~293 onChange(factoryId + lineId/operationId/electrodeType ALL) -> hooks/useCapaLossPlanCombos.ts:166 lineOptions · :190 operationOptions 재계산 | — | 구현 |
| D00-2-011 | §2 clbLine / SelectedIndexChanged | components/CapaLossPlanForm.tsx:311~316 onChange(lineId + operationId/electrodeType ALL) -> hooks/useCapaLossPlanCombos.ts:190 operationOptions 재계산 | — | 구현 |
| D00-2-012 | §2 clbOperation / SelectedIndexChanged | components/CapaLossPlanForm.tsx:340~345 onChange(operationId + electrodeType ALL) -> hooks/useCapaLossPlanCombos.ts:215 lineTypeOptions 재계산 | — | 구현 |
| D00-2-013 | §2 clbPlant / SelectedIndexChanged | components/CapaLossPlanForm.tsx:261~268 onChange(plantId + factory/line/operation/electrodeType ALL) -> hooks/useCapaLossPlanCombos.ts:156·166·190 재계산 | — | 구현 |
| D00-2-014 | §2 clbSite / SelectedIndexChanged | components/CapaLossPlanForm.tsx:235~243 onChange(siteId + plant/factory/line/operation/electrodeType ALL) -> hooks/useCapaLossPlanCombos.ts:146·156·166·190 재계산 | — | 구현 |
| D00-2-015 | §2 rgrpDivisionType / SelectedIndexChanged | useCapaLossPlanStore.ts:171~186 setDivisionType(하위 6축 ALL + 그리드 비움) + hooks/useCapaLossPlanCombos.ts:86~89 comboId 교체(`CapaLineMaster_SCP_ALL` <-> `CapaLineMasterEE_SCP_ALL`) | AS-IS `RefreshAllPre()` 마스터 전량 재로드 = TO-BE 는 comboId 가 바뀌어 react-query 키가 갈라지며 자동 재조회(02 §0 #9) | 구현 |
| D00-2-016 | §2 spdMain / KeyDown | components/CapaLossPlanGrid.tsx:245~271 keyDownHandler — `Ctrl+Z` preventDefault(:246~249) / `Delete` 선택범위 `0.0` 일괄 기입(:257~269) | 행 삭제도 DBNull 도 아니라 **0.0 기입**이다(03 R-16, V-54). 변경은 EditTracker 에 기록해 `CRUD_TYPE='M'` 을 얻는다 | 구현 |
| D00-3-001 | §3 Visible= / `spdMain.Sheets[i].Visible = (i == _sheet_idx)` | CapaLossPlan.tsx:74 toSheetName(확정 조회조건 기준) + :366 `sheetName` prop -> components/CapaLossPlanGrid.tsx:335 | AS-IS 는 8시트 중 1개만 Visible 로 두지만 TO-BE 는 시트를 **동시에 들고 있지 않는다**(03 R-01 — TabStripPolicy=Never) | 구현 |
| D00-3-002 | §3 ColumnHeaderSpan / `(0, headers.First().Key, 1, headers.Count, 20, ..., FPHAlign.Cente… | utils/capaLossPlan.dateColumns.ts:160~161 largeGroups.map(header=LARGE_CLASS_LABEL_NAME) — 3단 헤더 1단 그룹 | — | 구현 |
| D00-3-003 | §3 ColumnHeaderSpan / `(1, ...)` | utils/capaLossPlan.dateColumns.ts:164~166 subs.map(header=SMALL_CLASS_LABEL_NAME) — 3단 헤더 2단 그룹 | — | 구현 |
| D00-3-004 | §3 ColumnHeaderSpan / `(2, ...)` | utils/capaLossPlan.dateColumns.ts:143~145 leaf header=COLUMN_LABEL_NAME — 3단 헤더 3단(리프) | — | 구현 |
| D00-3-005 | §3 SetSheetHeaderColumnSCP / `(_si, 3, refreshAllColumn, _fixed_column_name)` | utils/capaLossPlan.dateColumns.ts:112 buildPeriodColumns(DB 메타 3단 조립) + components/CapaLossPlanGrid.tsx:313~316 frozenColumns(고정컬럼 경계 = 표시 정적 컬럼 전부) | AS-IS `FIXED_FLAG='Y'` 마지막 행 기준 Freeze 와 결과가 같음을 프레임워크 원본까지 대사해 확정(V-09 종결). 메타 위임식으로 바꾸면 이관 오류(`MEASURE` 에도 'Y')에 끌려간다 | 구현 |
| D00-3-006 | §3 setColumnWidth / `(c, 0)` | utils/capaLossPlan.dateColumns.ts:116~118 (`isEditablePeriodColumn` 으로 `*_ASSIGN_PRIORITY` 를 **컬럼으로 만들지 않는다**) + capa-loss-plan.constants.ts:243 ASSIGN_PRIORITY_SUFFIX | AS-IS 는 폭0+Resizable=false 로 숨기지만 Wijmo 는 컬럼을 만들면 우클릭 Filter/Sort/Hide 와 컬럼설정 모달에 노출된다(03 V-15). 잠금 판정은 행 데이터로 읽는다(utils/capaLossPlan.editLock.ts:70) | 구현 |
| D00-3-007 | §3 setColumnWidth / `(c, DEF_DATE_COL_WIDTH)` | — | `M_00`(개선율) 블록은 TVF 가 **0건 생성하는 전면 사문**이라 미이식 확정(03 §2.2 C-09, 본 문서 §4) — 토글 대상 컬럼이 없어 폭 전환이 발생하지 않는다 | 제외 |
| D00-3-008 | §3 setColumnWidth / `(c, 0)` | — | 위 D00-3-007 과 같은 `M_00` 사문 블록의 미체크 분기 — 대상 컬럼 0건이라 도달 불가(03 §2.2 C-09, 본 문서 §4) | 제외 |
| D00-3-009 | §3 setColumnWidth / `(c, DEF_DATE_COL_WIDTH)` | utils/capaLossPlan.dateColumns.ts:121~122 columnWidth(조회 80 / 편집 140) + :146 width — `M_01`(월)·`Y_`(연) 기간 컬럼 전건 | — | 구현 |
| D00-3-010 | §3 SetValue / `(r, c, value)` | components/CapaLossPlanGrid.tsx:263~266 (`row[binding] = 0` + EditTracker.storeChange) — Delete 키 선택범위 0.0 일괄 기입 | — | 구현 |
| D00-3-011 | §3 IsLockCell / `(r, c)` | — | AS-IS 호출부 `spdMain_ClipboardPasting` 가 `InitEvent`(cs:1870~1878)에서 **주석 처리**된 데드 경로다(00 §2 주의). TO-BE 는 붙여넣기 자체를 차단하므로(components/CapaLossPlanGrid.tsx:217~220 `pastingCell` cancel) 잠금범위 검사에 도달할 수 없다 — 미지원이 파리티(03 R-17, decisions §A BLK-12) | 제외 |
| D00-3-012 | §3 LockRange2 / `(0, 0, rowCnt-1, _fixed_column_idx, true)` | utils/capaLossPlan.editLock.ts:180 (`!isEditablePeriodColumn(binding)` -> false = 기간열/BASE_QTY 외 전 컬럼 잠금) | AS-IS 좌표 범위 잠금을 **의미**로 재현한다 — `LockRange`/컬럼명 상수 배열 이식 금지(hook #130, 본 문서 §3 #7) | 구현 |
| D00-3-013 | §3 LockRange2 / `(0, 0, rowCnt-1, _fixed_column_idx, true)` | — | `SetLockColumnsOneRow` 의 1행 갱신판이고 AS-IS 호출부가 속도개선 **주석 블록**(cs:2534)이라 발동하지 않는다(00 §3 #13). TO-BE 는 순수 판정 함수 1개(utils/capaLossPlan.editLock.ts:154 `isCellEditable`)가 `beginningEdit`/`formatItem` 에서 셀 단위로 매번 재계산하므로 1행 갱신 변형 자체가 불필요 | 제외 |
| D00-3-014 | §3 SwitchLock / `()` | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-3-015 | §3 Delete / `()` | CapaLossPlan.tsx:247~256 handleDelete — 가드 3종 후 `CRUD_TYPE === 'I'` 인 선택행만 `GridAction.removeRow` | Insert 가 NO-OP 라 신규행이 생기지 않으므로 실질 무동작이며, **기존 행이 지워지지 않는 것**이 핵심이다(03 R-25, V-53) | 구현 |
| D00-3-016 | §3 Query / `(ds)` | hooks/useCapaLossPlanQuery.ts:72~78 useTabProcQuery + :95 rows(커서 0번) -> components/CapaLossPlanGrid.tsx:331 itemsSource | 결과셋 개수가 상태별 2~4개 가변이라 커서 **이름이 아니라 순서**로 집는다(hooks/useCapaLossPlanQuery.ts:88~104, hook #80) | 구현 |
| D00-3-017 | §3 LockColumn / `(0, _si.GetMaxColumnIndex(), true)` | utils/capaLossPlan.editLock.ts:164 (`!isEditMode` -> false = 전 셀 읽기전용) + useCapaLossPlanStore.ts:226~227 setFilters 가 조회 시 `isEditMode=false` 선반영 | AS-IS `AfterFindData` 의 전열 잠금(03 R-15) 등가 — 조회 직후는 언제나 읽기 상태다 | 구현 |
| D00-3-018 | §3 SetBGColor / `(i, MEASURE_NAME colIdx, i, ColumnCount-1, mColor)` | components/CapaLossPlanGrid.tsx:154~163 formatItem 배경색(MEASURE_NAME 열 ~ 행 끝) + capa-loss-plan.constants.ts:383 MEASURE_COLOR_BY_CODE | **`MEASURE`(코드) 기준**이다 — AS-IS 의 영문 표시값 19문자열 하드코딩은 다국어에서 즉시 깨진다(03 R-12/V-57, 본 문서 §3 #3). `MC_RT` 는 AS-IS 가 NBSP 때문에 실제로 안 칠하므로 색 맵에서 의도적 제외(§3 #11) | 구현 |
| D00-3-019 | §3 SetBGColor2 / `(rowIndex, MEASURE_NAME colIdx, rowIndex, ColumnCount-1, mColor)` | — | `SetMeasureColorOneRow` 1행 갱신판 — AS-IS 호출부가 주석 블록(cs:2536)이고 `else{continue}` 누락으로 미매칭 measure 를 검정으로 칠하는 dead 코드다(03 R-13, 본 문서 §3 #4 미이식 확정). TO-BE `formatItem` 은 셀 단위로 매 렌더 재계산하므로 1행 갱신 변형이 불필요 | 제외 |
| D00-3-020 | §3 ToggleMerge / `(spdMain.ActiveSheet, true)` | components/CapaLossPlanGrid.tsx:294~296 allowMerging (조회 `AllowMerging.All` / 편집 `ColumnHeaders` 만) | 조회 직후(`AfterFindData`)에도 병합이 걸린다 — "Edit 토글 시에만" 처리하면 누락되므로 `isEditMode` 파생값으로 항상 계산(03 R-14, 01 L-29) | 구현 |
| D00-3-021 | §3 SmartColMerge / `()` | components/CapaLossPlanGrid.tsx:296 `AllowMerging.All`(컬럼 병합 포함) + utils/capaLossPlan.dateColumns.ts:150 기간 컬럼 `allowMerging:false` | 수치 셀은 병합 대상이 아니다 — 좌측 키 컬럼만 묶인다(03 R-14) | 구현 |
| D00-3-022 | §3 IsLockCell / `(e.Row, e.Column)` | components/CapaLossPlanGrid.tsx:235 `if (!canEdit(binding, row)) return;` (가드 6종 중 마지막 — utils/capaLossPlan.editLock.ts:154 isCellEditable) | 잠금 셀은 자동계산 대상이라 재계산을 skip 한다 — 순서를 바꾸면 무한루프가 난다(03 R-18) | 구현 |
| D00-4b-001 | §4b BLUtils.GetDivisionWithoutEE / (false) / dtDivision | utils/capaLossPlan.combos.ts:59~62 buildDivisionOptions(`ATTRIBUTE3 <> 'EE'` 클라 후처리) + capa-loss-plan.constants.ts:147 COMBO.DIVISION('Division_SCP') + :167 DIVISION_EXCLUDE_ATTRIBUTE3 | 이관 CMBO SQL 의 WHERE 에 `<>'EE'` 가 없어 FE 가 재현한다 — 공유 SQL_ID 의 WHERE 를 고치면 타 화면 회귀(hook #117) | 구현 |
| D00-4b-002 | §4b Data_SCP.CommonAll / YearFromThisYear / dtFromYYYY | — | 선언(cs:74) 외 참조 **0건**인 데드 콤보 `dtFromYYYY` — 짝인 `cboFromYYYY_SelectedIndexChanged`(cs:3533)도 `InitEvent` 미배선 데드 핸들러다(00 §4b 분류주의, 02 §2.7 F-32). 본 문서 §4 미이식 확정 | 제외 |
| D00-4b-003 | §4b Data.Common / YesOrNo / dtYesOrNo | — | 선언(cs:75) 외 참조 **0건**인 데드 콤보 `dtYesOrNo` — SCP0105 와 동일한 미사용 잔재(00 §4b 분류주의, 02 §2.7 F-32). 본 문서 §4 미이식 확정 | 제외 |
| D00-4b-004 | §4b Data.Common / LookupCommon / dtOp | hooks/useCapaLossPlanCombos.ts:91~94 (COMBO.LOOKUP_COMMON + lookupType) + capa-loss-plan.constants.ts:160 OPERATION_WHITELIST_LOOKUP_TYPE('CPS_LOSS_CELL_LINE_OPERATION') | 콤보 바인딩이 아니라 Operation **필터 재료**다. AS-IS 는 조건부 호출이지만 훅 배열 길이를 고정해야 하므로 항상 조회하고 **적용만** 조건부다(utils/capaLossPlan.combos.ts:343 needsOperationWhitelist) | 구현 |
| D00-4c-001 | §4c DBUtils.Filter / dtVersionAll | utils/capaLossPlan.combos.ts:87~103 buildVersionSeqOptions(DIVISION_ID + CODE 로 좁힘, 값·표시 모두 `VER_SEQ`) | — | 구현 |
| D00-4c-002 | §4c DBUtils.Filter / dtVersionAll | utils/capaLossPlan.combos.ts:106~117 findVersionRow + :135~140 deriveCurrProgressStatus(`PROG_STAT`) | Edit 게이트(utils/capaLossPlan.sheetKey.ts:95 judgeEditGate)와 Status 콤보 3중 필터의 **기준값**이다 — 사용자가 고른 Status 와 혼동하면 편집 조건이 통째로 달라진다 | 구현 |
| D00-4c-003 | §4c DBUtils.Filter / dtOp | utils/capaLossPlan.combos.ts:363 (`divisionId === SMALL_DIVISION_ID` -> lookup `CODE='40'` 행 선택) + capa-loss-plan.constants.ts:163 SMALL_DIVISION_ID | — | 구현 |
| D00-4c-004 | §4c DBUtils.Filter / dtOp | utils/capaLossPlan.combos.ts:363 (그 외 division -> `CODE='DEFAULT'` 행) + capa-loss-plan.constants.ts:164 OPERATION_WHITELIST_DEFAULT_CODE | — | 구현 |
| D00-4c-005 | §4c DBUtils.Filter / dtOperationAll | utils/capaLossPlan.combos.ts:387~402 buildOperationOptions(마스터 cascade + 화이트리스트 + DISPLAY_SEQ 정렬) | Formation `AFFFF` 를 **전역 제외하지 않는다** — ELTR 축에서만 제외다(02 §0 #4). SCP0105 코드를 베끼면 Cell/Module-Pack 후보가 조용히 좁아진다 | 구현 |
| D00-4c-006 | §4c DBUtils.Filter / dtElectrodeAll | utils/capaLossPlan.combos.ts:427~441 buildLineTypeOptions(+ :411 matchesElectrodeOperationPrefix — Operation 무선택 시 접두 대체 필터) | 원천이 **마스터 1개**다 — SCP0105 처럼 별도 콤보(`OperationElectrodeType_SCP_ALL`)를 부르면 후보 집합이 달라진다(02 §0 #6) | 구현 |
| D00-4c-007 | §4c DBUtils.Filter / _tblMeasure | utils/capaLossPlan.recalc.ts:68 blockKeyOf + :72 buildMeasureMap (키 + measure 맵) | AS-IS 의 `IDX` 행 오프셋 좌표계를 **의도적으로 키 기반으로 교체**했다(본 문서 §3 #1 = 03 R-11 의 TO-BE 권장안). 무정렬 상태 결과는 동일하고, 사용자가 F3/F4 를 걸면 AS-IS 가 엉뚱한 행에 쓰던 결함이 제거된다 | 구현 |
| D00-4c-008 | §4c DBUtils.Filter / _tblMeasure | utils/capaLossPlan.editLock.ts:42~51 targetYnFieldOf(상태별 컬럼명 선택) + :54~67 buildEditableMeasures + hooks/useCapaLossPlanQuery.ts:125~128 배선 | 편집 가능 measure 는 코드 상수가 아니라 GET measure 결과셋의 `*_TARGET_YN` 이 단일 원천이다(03 V-23, hook #130). SP 미배포로 결과셋이 비면 편집 0건 = 닫히는 쪽 실패 | 구현 |
| D00-4d-001 | §4d FindButton / Search | CapaLossPlan.tsx:177~198 handleSearch (:178 Division 권한 0건 차단 + :179 EditTracker clear + :183 setFilters) | AS-IS 가드 `checkRequiredOfSearch(this.Controls)` 의 실효 조건은 **없다** — Designer 에 `Required` 류 속성 0건(00 §4d 주의). 필수 조회조건·라벨 `*`·Search 전 alert 를 신설하지 않는 것이 파리티다(02 §4.4 F-28, components/CapaLossPlanForm.tsx:47 주석) | 구현 |
| D00-4d-002 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-003 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-004 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-005 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-006 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-007 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-008 | §4d DeleteButton / Delete | CapaLossPlan.tsx:249 `if (!grid) return;` (handleDelete 가드 1) | — | 구현 |
| D00-4d-009 | §4d DeleteButton / Delete | CapaLossPlan.tsx:250 `if (grid.rows.length === 0) return;` (handleDelete 가드 2) | — | 구현 |
| D00-4d-010 | §4d DeleteButton / Delete | CapaLossPlan.tsx:251 `if (!grid.selectedRows?.length) return;` (handleDelete 가드 3 — ActiveRow 미선택) | — | 구현 |
| D00-4d-011 | §4d SaveButton / Save | hooks/useCapaLossPlanSave.ts:184 `if (!grid) return;` (handleSave 가드 1) | — | 구현 |
| D00-4d-012 | §4d SaveButton / Save | hooks/useCapaLossPlanSave.ts:185 `if (!isEditMode) return;` (handleSave 가드 2 — 비편집 상태 저장 차단) | AS-IS `_si.IsLock(_si.SheetName)` 는 시트 잠금 = 비편집 상태다. TO-BE 는 `isEditMode` 단일 플래그로 동치 재현한다(토글 어포던스 자체는 asis_to_tobe.md §11 미이식) | 구현 |
| D00-4d-013 | §4d SaveButton / Save | hooks/useCapaLossPlanSave.ts:186 `if (grid.rows.length === 0) return;` (handleSave 가드 3) | — | 구현 |
| D00-4d-014 | §4d SaveButton / Save | hooks/useCapaLossPlanSave.ts:206 saveWithValidation(rowsToSave, staticColumns, doSave) — 메타 기반 필수검증 공용 배선 | AS-IS `checkRequiredOfSpread` 대응. 현 메타가 `INPUT_TP_CD='S'` **226행 전건**이라 실제 무발동이고 그 상태가 **파리티 유지**로 확정됐다(03 C-04, decisions §A BLK-3) — 메타 수정·코드 강제발동 금지. 커스텀 검증만 두면 필수 컬럼 공백 저장이 통과한다(SCP0020 실사고) | 구현 |
| D00-4d-015 | §4d _defaultDataModel_Changed / – | components/CapaLossPlanGrid.tsx:135 `if (!grid) return;` (그리드 미마운트면 핸들러 등록 자체를 하지 않는다) + hooks/useCapaLossPlanCellEdit.ts:106 `if (!grid) return;` | AS-IS `_si == null` 가드 대응 | 구현 |
| D00-4d-016 | §4d _defaultDataModel_Changed / – | components/CapaLossPlanGrid.tsx:230 `if (sender.rows.length === 0) return;` | AS-IS `_si.GetMaxRowIndex() == -1` 가드 대응 | 구현 |
| D00-4d-017 | §4d _defaultDataModel_Changed / – | components/CapaLossPlanGrid.tsx:231 (event.row 또는 event.col 이 -1 이면 return) | AS-IS `(e.Row == -1)` OR `(e.Column == -1)` 가드 대응 — 헤더/필터 행 편집 이벤트를 걸러낸다 | 구현 |
| D00-4d-018 | §4d _defaultDataModel_Changed / – | components/CapaLossPlanGrid.tsx:232 `if (!editModeRef.current) return;` + utils/capaLossPlan.editLock.ts:164 `if (!isEditMode ...) return false;` | AS-IS 는 `_si.IsLock(_si.SheetName)`(시트 잠금)과 `!this.IsEditMode` 를 **2중**으로 본다. TO-BE 는 잠금 상태가 `isEditMode` 단일 플래그라 두 가드가 같은 판정으로 합쳐진다 — EditButton 토글 어포던스 자체는 asis_to_tobe.md §11 로 미이식이지만 "비편집이면 재계산 금지" 의미는 이 라인이 보존한다 | 구현 |
| D00-4d-019 | §4d _defaultDataModel_Changed / – | components/CapaLossPlanGrid.tsx:232 `if (!editModeRef.current) return;` (AS-IS `!this.IsEditMode` 가드) | 위 D00-4d-018 과 같은 라인 — AS-IS 2중 가드가 TO-BE 단일 `isEditMode` 판정으로 합쳐지기 때문이다 | 구현 |
| D00-4d-020 | §4d _defaultDataModel_Changed / – | components/CapaLossPlanGrid.tsx:235 `if (!canEdit(binding, row)) return;` -> utils/capaLossPlan.editLock.ts:154 isCellEditable | AS-IS `_si.IsLockCell(e.Row, e.Column)` 대응 — 잠금 셀은 자동계산 대상이라 재계산 skip(무한루프 방지) | 구현 |
| D00-4d-021 | §4d _defaultDataModel_Changed / – | hooks/useCapaLossPlanCellEdit.ts:121~124 isCurrent 판정 + :124 CURRENT 분기 진입(`recalcCurrentColumn`) | AS-IS `_progress_status == _CURRENT` 분기 진입 가드 대응. `PRE`(`'-'`)도 CURRENT 축이다 | 구현 |
| D00-4d-022 | §4d _defaultDataModel_Changed / – | hooks/useCapaLossPlanCellEdit.ts:119 `if (!editableMeasures.has(measure)) return;` | AS-IS `!_editableMeasures.Contains(measure)` -> return 대응. 집합 원천은 GET measure 결과셋의 `*_TARGET_YN` 이다(utils/capaLossPlan.editLock.ts:54) | 구현 |
| D00-4d-023 | §4d _defaultDataModel_Changed / – | hooks/useCapaLossPlanCellEdit.ts:140 `if (progressStatus === FIRST_CUTOFF && sheetType === LINE)` 분기 진입(`recalcLineColumn`) | AS-IS `_progress_status == _1ST_CUTOFF && _sheet_type == LINE` 대응. `_sheet_status` 파생값이 아니라 **원본 쌍**으로 판정한다(utils/capaLossPlan.sheetKey.ts:45 주석) | 구현 |
| D00-4d-024 | §4d _defaultDataModel_Changed / – | hooks/useCapaLossPlanCellEdit.ts:119 (동일 가드 — LINE 축에서는 `FIRST_LINE_TARGET_YN` 집합이 들어온다) + utils/capaLossPlan.editLock.ts:48 `'FIRST_LINE_TARGET_YN'` | AS-IS 코드 상수 배열 `_recalcLineMeasures`(cs:88 — `SCP_PROD_PLAN SD_RT TD_RT MC_RT`)를 **이식하지 않는다**(hook #130 컬럼·measure 상수 배열 이식 금지). 메타 `FIRST_LINE_TARGET_YN` 실측 결과가 같은 4종이라 집합이 동일하다(03 V-23) | 구현 |
| D00-4e-001 | §4e SCM0002_CAPAItemPopup / ShowDialog | CapaLossPlan.tsx:389 `<CapaLossPlanItemPopup>` -> components/CapaLossPlanItemPopup.tsx:37 공용 `CapaItemPopup` 재사용(multiSelect + operationGroup + params) | 사본 생성 0건(convert-core §2.2). AS-IS `pop.Init(true, dtDivision, _division, _shop_group, _item_id)` 5인자 대응 | 구현 |
| D00-4e-002 | §4e SCM002_CAPAColumnPopup / ShowDialog | CapaLossPlan.tsx:382 `<CapaLossPlanColumnModal>` -> components/CapaLossPlanColumnModal.tsx:40 공용 `ColumnLayoutModal` 재사용 | AS-IS 3인자 중 **`_sheet_name` 8값**을 넘기는 것이 핵심이다(components/CapaLossPlanColumnModal.tsx:45 `ADMIN_SHEET_NAME[sheetName]`) — 헤더 SP 의 `_sheet_status` 4값으로 맞추면 ASSEMBLY/ELTR 개인화가 한 벌로 섞인다(03 §3.3, V-59) | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:CapaLossPlanColumnModal | FE 실존 모달 (components/CapaLossPlanColumnModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/CapaLossPlanColumnModal.tsx:29~77 (공용 `ColumnLayoutModal` 래퍼 — 사본 아님) | 분석 md 근거 있음: 00 §4e #2 `new SCM002_CAPAColumnPopup("SCP0106", _sheet_name, true)`(cs:4363) = D00-4e-002 와 동일 대상. FE 단독 모달이 아니다. CRUD 축은 개인화 설정 저장(`applyColumnLayout`, useCapaLossPlanStore.ts:308)뿐이고 업무 데이터 CRUD 는 없다 | 구현 |
| MODAL:FPModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | — | 추출 오탐 — `FPModal` 은 팝업명이 아니라 `SCM_MST_SHEET_COLUMNS.CELL_CONTROL_OBJECT_TYPE_CODE` 의 **셀 컨트롤 타입 코드**이고 이 화면 실측 **0건**이다(design 03_grid-columns.md:102 "`FPModal`·`FPButton`·`FPCheckBox`·`FPDate` 0건"). 도구의 `*Modal` 정규식이 그 문자열을 모달명으로 집은 것이라 이식 대상이 존재하지 않는다 | 제외 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | — | 추출 오탐 — `ShowDialog` 는 모달명이 아니라 00 §4e 팝업표의 **trigger 열 값**(= 팝업 호출 메서드명)이며 2건 모두 같은 문자열이다(00_checklist.md:373~374). 도구의 `*Dialog` 정규식이 집은 것이고, 실제 팝업 2건은 D00-4e-001(`CapaItemPopup` 재사용) / D00-4e-002(`ColumnLayoutModal` 재사용)로 각각 판정돼 있다 | 제외 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | — | 이 화면에 신규행 추가 경로가 **없다** — AS-IS `InsertButton()` 본문이 빈 `{}`(cs:2081~2083, 00 §4-2 #11, 03 R-26)이고 TO-BE 는 CapaLossPlan.tsx:240 `handleInsert = () => undefined` 로 명시적 무동작이다(버튼은 노출 — decisions §B-4). 필터 상태에서 보여야 할 추가 행이 생기지 않으므로 `keepRowVisibleUnderFilter` 대상 0건이다. 화면이 필터를 clear 하는 코드도 0건(CapaLossPlan.tsx 내 `clearFilters` 는 조회조건 변경 시 **그리드 비움**이고 그리드 컬럼필터가 아니다) | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | 공용 위임 — components/CapaLossPlanForm.tsx:99 `<SearchArea onSearch>` · CapaLossPlan.tsx:354~364 `<SubTitle hotkeyConfig>`(:294 search) 가 `packages/shared/src/components/organisms/search-area/SearchArea.tsx:115` · `packages/shared/src/components/organisms/sub-title/SubTitle.tsx:198` 의 `confirmIfDirtyKey(dirtyKey, 'search')` 로 감싸진다. dirty 등록은 공용 DataGrid + EditTracker(components/CapaLossPlanGrid.tsx:330 editTrackerRef) | 화면 배선 불요 — 조회 2경로(SearchArea 버튼 / SubTitle F5)가 모두 공용 confirm 을 통과한다. 조회 성공 시 편집모드 강제 해제도 useCapaLossPlanStore.ts:226~227 에서 선반영(01 L-31) | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | components/CapaLossPlanColumnModal.tsx:73 `clearFilters()` (컬럼설정 OK 시 조회 데이터 Reset) + useCapaLossPlanStore.ts:308~318 applyColumnLayout(컬럼 메타 즉시 재적용) + CapaLossPlan.tsx:126~130·:196~197 fetchStaticColumns/fetchStaticMeasures 재fetch | AS-IS 도 OK 에서 `BeforeFindData()` = 헤더 재구성 + 그리드 비움만 하고 **자동 재조회는 하지 않는다**(V-60) — 사용자가 다시 조회하도록 유도하는 것이 파리티다 | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | hooks/useCapaLossPlanSave.ts:148~156 setToast(저장 성공 MSG00672) + :192~195 setToast(변경 0건 MSG00133) | 성공·무변경은 하단 Toast, 사전 차단/실패는 Alert(hooks/useCapaLossPlanSave.ts:130·:140·:165, CapaLossPlan.tsx:108·:211·:225) = LGES WDG 표준(hook #132 §3). AS-IS MSG00004 번호를 그대로 쓰면 TO-BE 에서 "No changes to save." 로 뜻이 뒤집힌다(hook #114) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | CapaLossPlan.tsx:359 `<SubTitle excelFileName='CapaLossPlan'>` (공용 GridAction excel 경유 — dataMap 승계) | 이 화면 그리드는 **셀 콤보를 배선하지 않는다**(components/CapaLossPlanGrid.tsx:80~84 주석 — 메타에 `OperationByLine` 이 있으나 대상 컬럼 `1ST_CUTOFF_LINE_ASSEMBLY.OPERATION_ID` 가 폭0 + 코드 숨김 이중 은닉이라 AS-IS 에서 렌더된 적이 없다. 03 C-07, decisions §A BLK-17). 따라서 Code↔Name 승계 이슈 자체가 미해당이고, 코드 컬럼은 메타 폭0 으로 숨고 `*_NAME` 컬럼이 표시된다(components/CapaLossPlanGrid.tsx:103~114 resolvedStaticColumns) | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | components/CapaLossPlanForm.tsx:386~392 nickName 자유 key-in + components/CapaLossPlanItemPopup.tsx:49 `Array.from(new Set(values)).join(',')`(AS-IS `GetSelectedValuesText` 다건 콤마 결합) + hooks/useCapaLossPlanCombos.ts:291 `p_nick_name` 원문 전달 · :284~293 다중선택 6축 `expandMultiSelect`(utils/capaLossPlan.combos.ts:458) | Key-in 필드는 Item(`nickName`) 1개이며 콤마 누적이 곧 다중조회다 — 서버가 `A.MDL_NM IN(...)` 로 매칭한다(02 §3.4, F-24). 다중선택 축은 무선택 시 후보 전체 CODE 를 콤마 join 하고 후보 0건이면 `NONE` 을 보낸다(`'ALL'` 문자열 전송 금지) | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | 공용 위임 — components/CapaLossPlanGrid.tsx:329 `gridFilterRef` 를 공용 DataGrid 에 전달. `rebindFilterColumns`(`packages/foundation/src/utils/gridAction.ts:91`)를 `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1483` 이 컬럼 재대입 후 호출해 필터-컬럼 연결을 복구한다 | 화면 배선 불요. 이 화면은 조회마다 동적 기간 컬럼이 재조립될 수 있어 연결 복구가 특히 중요한데, utils/capaLossPlan.dateColumns.ts:174 periodColumnSignature 로 **내용이 같으면 컬럼 재생성을 억제**해 필터가 끊기는 빈도 자체를 줄인다 | 구현 |

## 1. Roslyn 백본 12필드 카운트 대사 (00 §6)

| 필드 | 백본 수 | TO-BE 처리 | 소진 |
|---|--:|---|:--:|
| controls | 45 | 조회조건 14 + 라벨/컨테이너 12 → `CapaLossPlanForm.tsx` / 그리드·버튼 19 → `CapaLossPlanGrid.tsx`·`CapaLossPlan.tsx`. 사장 2건(`usrLayoutControl1`/`layoutControlGroup1`)은 **미이식**(L-08/L-09) | 45/45 |
| events | 16 | cascade 12 → `useCapaLossPlanCombos` + store 액션(`setDivisionType`/`setProgressStatus`) / `spdMain.KeyDown` → Grid `keydown`(Delete·Ctrl+Z) / `chkShowRate.CheckedChanged` → Form(무동작 파리티) / 나머지 2 = 데드(`cboFromYYYY_SelectedIndexChanged` 외) **미이식** | 16/16 |
| validations | 6 | Edit 3분기(L-12~L-15) → `judgeEditGate` / Save 변경0건(R-22) → `useCapaLossPlanSave` / 그리드 필수값(R-21) → `saveWithValidation` 배선(메타 `INPUT_TP_CD='S'` 전건이라 무발동 — 파리티 유지, dec §A BLK-3) / Division 권한 0건 → `CapaLossPlan.tsx` `noDivisionAuth` | 6/6 |
| gridSignals | 22 | 병합 토글(R-14) · 전열 잠금(R-15) · 조건부 잠금(R-05/R-06) · 셀변경 가드 6+디스패치(R-18) · 폭/포맷 2모드(R-04/R-07) · Measure 색(R-12) · Delete 키(R-16) · 붙여넣기 4핸들러(R-17 **주석처리 = 미지원이 파리티**) | 22/22 |
| gridColumns | 0 | 백본 추출 0건. 컬럼은 전부 admin 메타(`SCM_MST_SHEET_COLUMNS` 226행) 동적 fetch | 0/0 |
| spCalls | 1 | 정적 1건 + **백본 밖 동적 QueryId 4패턴**(GET 8 / SAVE 4 / TITLE 1 / 팝업 1) → `convert-sp` 인계 | 1+4 |
| entryPoints | 21 | 버튼 5 override(§2-H) + Form_Load + cascade 12 + 팝업 2 + 컬럼설정 1 | 21/21 |
| comboCalls | 4 | Division / CapaVersion / CapaProgressStatus / LookupCommon → `COMBO` 상수. 데드 2건 (`YearFromThisYear_SCP_ALL`·`YesOrNo`) **미이식**(F-32) | 4/4 |
| filterCalls | 8 | 클라 필터 7그룹 → `utils/capaLossPlan.combos.ts` 한 파일로 집약 + Operation 화이트리스트 | 8/8 |
| buttonGuards | 24 | Edit 6(L-10~L-15) + 베이스 6(L-22~L-27) + Delete 3(L-16~L-18) + Save 3(L-19~L-21) + 셀변경 6(R-18) | 24/24 |
| popups | 2 | Item(`CapaItemPopup` 재사용) + 컬럼설정(`ColumnLayoutModal` 재사용). **사본 생성 0건** | 2/2 |
| extractionLimits | 2 | 프레임워크 소스 부재(`SheetUtils`/`SetSheetHeaderColumnSCP`) → C-01, 04 리포트 "확인필요" | 2/2 |

---

## 2. 파일 ↔ AS-IS 대응

| TO-BE 파일 | AS-IS 대응 |
|---|---|
| `CapaLossPlan.tsx` | Form 셸 + 버튼 override 5종 + `Form_Load` + `BeforeFindData` 트리거 |
| `components/CapaLossPlanForm.tsx` | `usrConditionPanel1` + 조회조건 27컨트롤(01 §1.2, dec §B-2 배치) |
| `components/CapaLossPlanGrid.tsx` | `spdMain`(FpSpread 8시트) + `SetLockColumns*` + `SetMeasureColor` + `SetSheetMerge` + `spdMain_KeyDown` |
| `components/CapaLossPlanColumnModal.tsx` | `btnColumn_Click` → `SCM002_CAPAColumnPopup("SCP0106", _sheet_name, true)` |
| `components/CapaLossPlanItemPopup.tsx` | `btnItemId_Click` → `SCM0002_CAPAItemPopup.Init(true, …)` |
| `hooks/useCapaLossPlanCombos.ts` | `InitControls` + `RefreshXxx` 6축 + `RefreshVersion/VersionSeq/PlanType/ProgressStatus` + `SetQueryInfoGet` |
| `hooks/useCapaLossPlanCellEdit.ts` | `spdMain_Changed` 디스패치 → `RecalcSheetSelfCurrent` / `RecalcSheetSelfLine` |
| `hooks/useCapaLossPlanSave.ts` | `SaveButton` + `CheckChangedValues` + `SetQueryInfoSave`(MODEL) / `SetQueryInfoSaveLine`(LINE) |
| `utils/capaLossPlan.sheetKey.ts` | `GetSheetStatus`(FORM:482~520) + `GetDivisionTypeName` + `EditButton` 게이트 판정부 |
| `utils/capaLossPlan.combos.ts` | `ScpCapaBL.GetFilterXxx` 6종 + `GetSortedCode` + `RefreshLine` 재정렬 + `CString.GetCheckedListValueNone` |
| `utils/capaLossPlan.dateColumns.ts` | `GetSpdTitle` + `_from_yyyymm` + 3단 헤더 조립(`RefreshSheetHeader`) |
| `utils/capaLossPlan.editLock.ts` | `SetLockColumnsAll` 분기 C1/C2 + `IsCurrPriorityNone` |
| `utils/capaLossPlan.recalc.ts` | `AssemblyUtils.RecalcSelf`(A:665~731) / `EltrUtils.RecalcSelf`(E:859~934) + DDN/WT_RT setter |
| `utils/capaLossPlan.save.ts` | `SetQueryInfoSave`/`SetQueryInfoSaveLine` 직렬화 + 비율 `/100` + 응답 판정 |

---

## 3. AS-IS 와 **의도적으로 다르게** 구현한 항목 (전건)

| # | 항목 | AS-IS | TO-BE | 근거 |
|--:|---|---|---|---|
| 1 | 행 오프셋 좌표계 | `GetRowIdxOfMeasure(curr,target) = curr - (IDX(curr)-IDX(target))` — 시트 정렬 의존 | **키 + measure 맵**(`blockKeyOf`/`buildMeasureMap`) | 03 R-11 의 TO-BE 권장안. 사용자가 F3/F4 를 걸면 AS-IS 는 엉뚱한 행에 쓴다. 무정렬 상태 결과 동일 |
| 2 | setter 부수효과 | 대입 **전에** recalc 호출(stale) | "입력 반영 → `RecalcSelf` 7단계" 순수 함수 | 03 C-21. 값 결과 동일, stale 경로만 제거 |
| 3 | `MEASURE_NAME` 색칠 | 영문 표시값 19문자열 하드코딩 비교 | **`MEASURE`(코드) 기준** | 03 R-12·V-57. 문자열 비교는 다국어에서 즉시 깨진다 |
| 4 | `SetMeasureColorOneRow` | `else{continue}` 누락 → 미매칭 measure 를 검정으로 칠함 | **미이식** | 03 R-13 dead |
| 5 | R-09 "18 measure dirty 마킹" | 값 없이 0열 `"M"` 플래그 | 마킹 대신 **저장 payload 블록 확장**(`expandDirtyRows`) | `EditTracker` 는 "값이 달라졌을 때만" M 을 찍는 계약이라 값 없이 마킹하려면 자체 상태필드가 필요하다(convert-core §2.4 금지). 저장되는 **행 집합은 동일**, 그리드의 빨간 변경표시만 18행에 안 뜬다 |
| 6 | 컬럼 숨김 | 코드 배열 16컬럼(`SetVisibleSheetColumn`) | 메타 `COLUMN_WIDTH === 0 → hidden` | 03 R-03·C-10. 컬럼명 상수 배열 이식 금지(hook #130) + 메타 무수정 경로 |
| 7 | `LockRange2` 좌표 잠금 | 스프레드 좌표 범위 | `beginningEdit` 마지막 override + 순수 판정 함수 | hook #130, 03 V-26 |
| 8 | 편집가능 measure | (동일) GET `*_TARGET_YN` | 동일 — **코드 상수 배열을 두지 않는다**. SP 미배포로 결과셋이 비면 편집 0건(닫히는 쪽 실패) | 03 V-23 |
| 9 | Measure 아이콘(`IcMeasureSelect`) | AS-IS 툴바에 **없음**(캡처 11종 실측) | **미노출** | L-34/V-21 은 TO-BE 확장 제안이고, 공용 `MeasureSelectModal` 이 `features/master` 에만 있어 supply 소비는 Top11 #2 위반. 04 "확인필요" |
| 10 | `isScpPlanFixed` 리셋 누락(C-16) | 행 루프 내 리셋 없음 → 확정기간 이후·연 컬럼까지 계속 잠김 | **AS-IS 실동작 그대로 재현**(`buildScpPlanFixedColumns` latch) | plan STEP0 ⑧ 잠정 방침. 의도/버그 미확정(BLK-13-④) → 04 "확인필요". 버그로 확정되면 함수 1개만 단순 범위 판정으로 교체 |
| 11 | `MC_RT` 색칠 | 라벨 NBSP(U+00A0)로 문자열 비교가 빗나가 **안 칠해짐** | **칠하지 않음**(색 맵에서 의도적 제외) | dec §A BLK-11 "AS-IS 실발현 그대로". 코드 기준으로 옮기면 AS-IS 에 없던 색이 생긴다 |
| 12 | AS-IS MSG 번호 | MSG00419 / MSG00109 / MSG00097 / MSG00004 | **MSG01406 / MSG01454 / MSG00667 / MSG00672** | hook #114 + dec §A BLK-5. 번호 그대로 쓰면 뜻이 뒤집히거나 엉뚱한 문구가 뜬다 |

---

## 4. **미이식 확정** 항목 (있어야 할 자리에 없는 이유)

| 항목 | 사유 |
|---|---|
| `usrLayoutControl1` / `layoutControlGroup1` | 사장 노드, 참조 0건(L-08/L-09). 만들면 빈 래퍼 = hook #132 위반 |
| `M_00`(개선율) 컬럼 계열 · `GetCalcRt` · `IsGoal` | TVF 가 0건 생성하는 전면 사문(03 C-09, R-10) |
| `chkShowRate` 실동작 | 토글 대상(`M_00`)이 0건이라 **무동작이 파리티**(R-02, V-19). 체크박스는 노출·초기체크(dec §B-3) |
| 구 `SetQueryInfoSaveLine` 주석 블록 | `/* */` 주석, 활성 정의 1개뿐(R-32) |
| 붙여넣기 4핸들러 | `InitEvent` 에서 전부 주석 처리 = 미지원이 파리티(R-17, dec §A BLK-12). 공용 wrapper 의 paste 를 `pastingCell` 에서 차단 |
| 셀 콤보 `OperationByLine` | 대상 컬럼이 폭0 + 코드 숨김 이중 은닉 = AS-IS 에서 렌더된 적 없음(C-07, dec §A BLK-17) |
| 데드 콤보 2건(`dtFromYYYY`/`dtYesOrNo`) | 선언 외 참조 0건(02 §2.7, F-32) |
| `ReadOnlySheetList` 를 "읽기전용 시트"로 구현 | 유일 소비처가 필터 일괄해제 skip 이라 편집 차단 기능이 아니다(L-28 정정본, C-03). **`CURRENT_ASSEMBLY` 는 읽기전용이 아니다**(V-26) |

---

## 5. 권한 (AS-IS 8그룹 ACL)

`TB_FX_GroupMenuAuth WHERE MenuID='SCP0106'` 실측 8행(design 승계, `TB_FX_UserMenuAuth` 0건):
- 편집 가능(`BasicACLU=True`) 4: **ADMIN / CAPA Planner / SCM PI Admin / SCP Tester**
- 조회 전용 4: **FP Planner / FP Viewer / SCM Viewer / SCP Planner**

TO-BE 반영은 `design/05_register.sql` §5·§6 — 편집 그룹 = 전 버튼, 조회 전용 = SEARCH·EXCEL.
`CAPA Planner` 는 TO-BE `SCM_ADM_USER_GR_M` 에 없을 수 있어 `EXISTS` 가드를 걸었다(임의 생성 금지).
FE 는 `useTabBtnPermissions().hasButton()` 경유로만 버튼을 구성한다 — 하드코딩 0건.

---

## 6. `convert-sp` 인계 (FE 가 전제로 삼은 서버 계약)

1. GET 8변형 — `p_nick_name`/`p_electrode_type` 의 **SP IN 순번이 계열마다 10/11 ↔ 11/10 으로 뒤바뀐다**(R-29). FE 는 명명 인자로만 보낸다. 위치 인자 바인딩 금지.
2. SAVE 2계열 — MODEL 23 / LINE 20, `p_sheet_name` 비대칭(R-30/R-31). `05_register.sql` 이 API_ID 를 둘로 나눠 등록했다.
3. 결과셋 개수 2~4 가변 — FE 는 커서 **이름이 아니라 순서**로 집는다(`cursors[0..3]`). 배포 후 `all_arguments` 로 이름 확정 시 대사 필요.
4. LINE 재계산의 DDN 분모는 **별도 결과셋** `RS(prodCapaD)` 12컬럼이다(03 §4.2). FE 는 그 계약대로 키 맵을 만든다 — 실물 검증 미완.
5. `@p_nick_name` 매칭식이 SP 변형마다 3형태다(dec §C X-3): ELTR 3종 `IN(...) OR MDL_NM='-'` / `CURRENT_ASSEMBLY` `IN(...)` / ASSEMBLY 컷오프 3종 `LIKE '%'+@p+'%'`. **`'-'` 절을 빠뜨리면 비조업 행이 조용히 사라진다.**
6. AS-IS 결함 5건(C-08/C-14/C-15/C-16/C-18) 판정 대기.
