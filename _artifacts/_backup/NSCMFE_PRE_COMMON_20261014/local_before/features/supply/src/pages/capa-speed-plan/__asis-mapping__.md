# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 Division / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:99` | cboDivision 라벨 `LBL00641` | 구현 |
| D00-1-002 | §1 Division1 / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:114` | cboVersion(Plan Month) 라벨 `LBL00053` | 구현 |
| D00-1-003 | §1 Division3 / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:154` | cboProgressStatus 라벨 `LBL00014` | 구현 |
| D00-1-004 | §1 PlanType / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:145` | AS-IS `txtPlanType` 은 TextVisible=false → 빈 라벨로 재현 | 구현 |
| D00-1-005 | §1 VersionSeq / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:129` | cboVersionSeq 라벨 `LBL00606` | 구현 |
| D00-1-006 | §1 btnColumn / UsrButton | `CapaSpeedPlan.tsx:272~293`, `components/CapaSpeedPlanColumnModal.tsx:30~67` | SubTitle 공용 아이콘 `IcGridColumnSetup` 으로 이동(01 §2-G) | 구현 |
| D00-1-007 | §1 btnItemId / UsrButton | `components/CapaSpeedPlanForm.tsx:336~347`, `components/CapaSpeedPlanItemPopup.tsx:27~45` | 입력창+팝업 아이콘 한 덩어리(hook #121 popupSearchField) | 구현 |
| D00-1-008 | §1 cboDivision / UsrCombo | `components/CapaSpeedPlanForm.tsx:96~110` | SQL_ID `Division_SCP`(DB USE_YN=Y 재확인) | 구현 |
| D00-1-009 | §1 cboProgressStatus / UsrCombo | `components/CapaSpeedPlanForm.tsx:151~167` | SQL_ID `CapaProgressStatus_SCP_ALL` | 구현 |
| D00-1-010 | §1 cboVersion / UsrCombo | `components/CapaSpeedPlanForm.tsx:111~125` | SQL_ID `CapaVersion_SCP_ALL` | 구현 |
| D00-1-011 | §1 cboVersionSeq / UsrCombo | `components/CapaSpeedPlanForm.tsx:126~140` | 동일 결과셋 재필터(재조회 없음) | 구현 |
| D00-1-012 | §1 clbElectrodeType / UsrCheckedList | `components/CapaSpeedPlanForm.tsx:297~317` | DivisionType 별 원천 분기(ASSEMBLY=마스터 슬라이스 / ELTR=lookup) | 구현 |
| D00-1-013 | §1 clbFactory / UsrCheckedList | `components/CapaSpeedPlanForm.tsx:221~244` | 표기는 "Building"(`LBL00008`) — "Factory" 아님 | 구현 |
| D00-1-014 | §1 clbLine / UsrCheckedList | `components/CapaSpeedPlanForm.tsx:250~272` | `_C`/`_A` 쌍 재정렬(`utils/capaSpeedPlan.combos.ts:183~214`) | 구현 |
| D00-1-015 | §1 clbOperation / UsrCheckedList | `components/CapaSpeedPlanForm.tsx:273~296` | Formation(`AFFFF`) 제외 | 구현 |
| D00-1-016 | §1 clbPlant / UsrCheckedList | `components/CapaSpeedPlanForm.tsx:195~219` | — | 구현 |
| D00-1-017 | §1 clbSite / UsrCheckedList | `components/CapaSpeedPlanForm.tsx:168~194` | Site 만 SHOP_GROUP 미적용 | 구현 |
| D00-1-018 | §1 emptySpaceItem1 / EmptySpaceItem | — | DevExpress LayoutControl 의 여백 노드. TO-BE 는 CSS Grid(`Grid size`)가 폭을 배분해 대응 컨트롤이 없다(00 §1 static) | 제외 |
| D00-1-019 | §1 emptySpaceItem11 / EmptySpaceItem | — | DevExpress LayoutControl 의 여백 노드. TO-BE 는 CSS Grid(`Grid size`)가 폭을 배분해 대응 컨트롤이 없다(00 §1 static) | 제외 |
| D00-1-020 | §1 emptySpaceItem6 / EmptySpaceItem | — | DevExpress LayoutControl 의 여백 노드. TO-BE 는 CSS Grid(`Grid size`)가 폭을 배분해 대응 컨트롤이 없다(00 §1 static) | 제외 |
| D00-1-021 | §1 fpSpread1 / FpSpread | — | Designer 노드만 존재하고 code-behind 참조 0건 = 미사용 잔재(03 C-10). 실제 그리드는 `spdMain` 하나다 | 제외 |
| D00-1-022 | §1 imageList1 / ImageList | — | 비가시 리소스(아이콘 컨테이너). React 는 아이콘을 컴포넌트로 직접 import 한다(`IcGridColumnSetup`) | 제외 |
| D00-1-023 | §1 layoutControlGroup1 / LayoutControlGroup | — | `usrLayoutControl1` 의 Root 라 함께 사장 — `Items.AddRange` 0건(01 L-07) | 제외 |
| D00-1-024 | §1 layoutControlGroup2 / LayoutControlGroup | `components/CapaSpeedPlanForm.tsx:73~354` | `conditions` 9필드(2단, 합 24) + `extraConditions` 4필드(3단) = hook #52 | 구현 |
| D00-1-025 | §1 layoutControlItem1 / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:83~327` | 1단 조회조건 라벨. Designer 좌표만으로 어느 필드의 라벨인지 확정되지 않는다(BLK-5 와 같은 축) — TO-BE 는 13필드 전건이 `FormItem label` 을 갖고 라벨 누락 0건이며 사용 LBL 22종은 `SCM_ADM_MSG_M` 실재 재확인(2026-09-24) | 구현 |
| D00-1-026 | §1 layoutControlItem10 / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:83~327` | 1단 조회조건 라벨. Designer 좌표만으로 어느 필드의 라벨인지 확정되지 않는다(BLK-5 와 같은 축) — TO-BE 는 13필드 전건이 `FormItem label` 을 갖고 라벨 누락 0건이며 사용 LBL 22종은 `SCM_ADM_MSG_M` 실재 재확인(2026-09-24) | 구현 |
| D00-1-027 | §1 layoutControlItem2 / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:198` | clbPlant 열 라벨 `LBL00030` | 구현 |
| D00-1-028 | §1 layoutControlItem4 / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:224` | clbFactory 열 라벨 `LBL00008`(Building) | 구현 |
| D00-1-029 | §1 layoutControlItem6 / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:253` | clbLine 열 라벨 `LBL00010` | 구현 |
| D00-1-030 | §1 layoutControlItem8 / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:171` | clbSite 열 라벨 `LBL00015` | 구현 |
| D00-1-031 | §1 lciDivisionType / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:83` | AS-IS `lciDivisionType.TextVisible=false`(Designer.cs:700) → 빈 라벨(iter-2 A1-01 해소) | 구현 |
| D00-1-032 | §1 lciElectrodeType / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:51~52`, `components/CapaSpeedPlanForm.tsx:298` | `SetVisibleElectrodeType()` — CELL/MODULE_PACK 만 표시(비대칭 유지) | 구현 |
| D00-1-033 | §1 lciItem / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:323~327` | `lciItem` 동적 Text — Cell/MP=`LBL00054` / ELTR=`LBL00669` | 구현 |
| D00-1-034 | §1 lciOperation / LayoutControlItem | `components/CapaSpeedPlanForm.tsx:50`, `components/CapaSpeedPlanForm.tsx:274` | `SetVisibleOperation()` — ELTR 이면 숨김 | 구현 |
| D00-1-035 | §1 rgrpDivisionType / RadioGroup | `components/CapaSpeedPlanForm.tsx:59~66`, `components/CapaSpeedPlanForm.tsx:80~95` | 공용 RadioGroup 부재 → 단일선택 드롭다운(자매 SCP0114 동일). 초기값 `Cell` 은 사용자 확정 BLK-4 | 구현 |
| D00-1-036 | §1 spdMain / FpSpread | `components/CapaSpeedPlanGrid.tsx:324~338` | 공용 `DataGrid` 1개 + `sheetName` 스위치(03 R-01) | 구현 |
| D00-1-037 | §1 spdMain_Sheet1 / SheetView | — | Designer 초기 시트. 런타임 `AddSheet` 2건(cs:1302·1303)이 대체하고 TO-BE 는 시트 전환을 `sheetName` prop 으로 한다 | 제외 |
| D00-1-038 | §1 txtItem / TextBox | `components/CapaSpeedPlanForm.tsx:320~352` | 팝업 결과 표시 + `p_item_id` 원천 | 구현 |
| D00-1-039 | §1 txtPlanType / TextBox | `components/CapaSpeedPlanForm.tsx:142~148` | 읽기전용 파생 표시(`disabled`), 값은 `hooks/useCapaSpeedPlanCombos.ts:106~115` | 구현 |
| D00-1-040 | §1 usrConditionPanel1 / UsrConditionPanel | `components/CapaSpeedPlanForm.tsx:69~355` | 공용 `SearchArea` | 구현 |
| D00-1-041 | §1 usrLayoutControl1 / UsrLayoutControl | — | `Controls.Add(usrLayoutControl1)` grep 0건 = Form 에 붙지 않는 사장 노드(01 L-06) | 제외 |
| D00-1-042 | §1 usrLayoutControl2 / UsrLayoutControl | `components/CapaSpeedPlanForm.tsx:69~72`, `CapaSpeedPlan.tsx:145~155`, `CapaSpeedPlan.tsx:307` | Division 권한 0건 게이트 — 조회영역 전체 `disabled` + `MSG00667` 1회(01 L-04) | 구현 |
| D00-2-001 | §2 _defaultDataModel / Changed | `components/CapaSpeedPlanGrid.tsx:252~274`, `hooks/useCapaSpeedPlanCellEdit.ts:28~91` | AS-IS 가드 6건 순서 보존 후 `CheckEltrEquipmentType` -> `RecalcSheet` | 구현 |
| D00-2-002 | §2 btnColumn / Click | `CapaSpeedPlan.tsx:272~293`, `components/CapaSpeedPlanColumnModal.tsx:50~65` | OK 시 `clearFilters()` = AS-IS `BeforeFindData()` 의 시트 비움 | 구현 |
| D00-2-003 | §2 btnItemId / Click | `components/CapaSpeedPlanForm.tsx:336~347`, `components/CapaSpeedPlanItemPopup.tsx:27~45` | — | 구현 |
| D00-2-004 | §2 cboDivision / SelectedIndexChanged | `components/CapaSpeedPlanForm.tsx:106`, `hooks/useCapaSpeedPlanConditionEffects.ts:59~68` | Division 변경 = 그리드 비움 + 컬럼메타 재조회 + 개인화 초기화 | 구현 |
| D00-2-005 | §2 cboProgressStatus / SelectedIndexChanged | `components/CapaSpeedPlanForm.tsx:161~163`, `hooks/useCapaSpeedPlanConditionEffects.ts:89~97` | — | 구현 |
| D00-2-006 | §2 cboVersion / SelectedIndexChanged | `components/CapaSpeedPlanForm.tsx:121`, `hooks/useCapaSpeedPlanConditionEffects.ts:89~110` | 그리드 비움 + 기간헤더 재조회(03 V-11/V-15) | 구현 |
| D00-2-007 | §2 cboVersionSeq / SelectedIndexChanged | `components/CapaSpeedPlanForm.tsx:136`, `hooks/useCapaSpeedPlanConditionEffects.ts:89~97` | — | 구현 |
| D00-2-008 | §2 clbFactory / SelectedIndexChanged | `components/CapaSpeedPlanForm.tsx:221~244` | cascade — 하위(Line/Operation/LineType) `ALL` 리셋 | 구현 |
| D00-2-009 | §2 clbLine / SelectedIndexChanged | `components/CapaSpeedPlanForm.tsx:250~272` | cascade — Operation/LineType `ALL` 리셋 | 구현 |
| D00-2-010 | §2 clbOperation / SelectedIndexChanged | `components/CapaSpeedPlanForm.tsx:273~296` | cascade — LineType `ALL` 리셋 | 구현 |
| D00-2-011 | §2 clbPlant / SelectedIndexChanged | `components/CapaSpeedPlanForm.tsx:195~219` | cascade — Building/Line/Operation/LineType `ALL` 리셋 | 구현 |
| D00-2-012 | §2 clbSite / SelectedIndexChanged | `components/CapaSpeedPlanForm.tsx:168~194` | cascade — 하위 5축 `ALL` 리셋 | 구현 |
| D00-2-013 | §2 rgrpDivisionType / SelectedIndexChanged | `components/CapaSpeedPlanForm.tsx:89~91`, `useCapaSpeedPlanStore.ts:172~191`, `hooks/useCapaSpeedPlanConditionEffects.ts:76~82` | 유일한 서버 재조회축(마스터 `comboId` 교체) + 하위 6축 리셋 + CRUD 마킹 초기화 | 구현 |
| D00-2-014 | §2 spdMain / CellClick | `components/CapaSpeedPlanGrid.tsx:204~226` | AS-IS 는 `CellClick` 에서 셀 콤보를 꽂지만 Wijmo 는 `beginningEdit` 가 그 자리다(잠금 셀이면 미표시 — 03 R-04) | 구현 |
| D00-3-001 | §3 Visible= / `spdMain.Sheets[i].Visible = (i == _sheet_idx)` | `CapaSpeedPlan.tsx:80`, `capa-speed-plan.constants.ts:64~68` | 시트 전환은 확정 조회조건(`applied ?? sc`) 기준 | 구현 |
| D00-3-002 | §3 SetSheetHeaderColumnSCP / `(_si, 3, refreshAllColumn, _fixed_column_name)` | `utils/capaSpeedPlan.dateColumns.ts:64~118`, `components/CapaSpeedPlanGrid.tsx:330~334` | 3단 헤더 + `headerRowHeight` 단일 출처(hook #93) | 구현 |
| D00-3-003 | §3 setColumnWidth / `(c, 0)` | `utils/capaSpeedPlan.dateColumns.ts:68~70` | 의도적 편차 — 폭0 대신 **컬럼 자체를 만들지 않는다**(Wijmo 는 폭0 컬럼도 우클릭/컬럼설정에 노출). 행 데이터는 유지 | 구현 |
| D00-3-004 | §3 IsLockCell / `(e.Row, e.Column)` | `components/CapaSpeedPlanGrid.tsx:210~217` | 잠금 셀이면 `event.cancel=true` 후 콤보 미주입 | 구현 |
| D00-3-005 | §3 LockRange2 / `(0, 0, rowCnt-1, _fixed_column_idx, true)` | `utils/capaSpeedPlan.editLock.ts:77` | 기간열이 아니면 전 행 잠금 = `LockRange2(0,0,rowCnt-1,IDX,true)` 등가 | 구현 |
| D00-3-006 | §3 LockRange2 / `(0, 0, rowCnt-1, _fixed_column_idx, true)` | `utils/capaSpeedPlan.editLock.ts:77` | ELTR 도 같은 규칙(시트 분기는 기간열 판정 뒤) | 구현 |
| D00-3-007 | §3 SwitchLock / `()` | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(`Doc/rules/mapping/asis_to_tobe.md §11`, 2026-09-23). 다만 **잠금 범위**는 별개 축이라 `utils/capaSpeedPlan.editLock.ts:63~82` 로 전건 재현했고 `utils/capaSpeedPlan.editLock.test.ts` 13건으로 검증한다 | 제외 |
| D00-3-008 | §3 Delete / `()` | `CapaSpeedPlan.tsx:219~227` | 신규행(`CRUD_TYPE==="I"`)만 제거 — 행 추가가 없어 실질 무동작(03 R-27) | 구현 |
| D00-3-009 | §3 GetColumnValue / `(c)` | `utils/capaSpeedPlan.save.ts:36~37` | AS-IS 스냅샷 대조 → 공용 `EditTracker` 가 찍은 `CRUD_TYPE` | 구현 |
| D00-3-010 | §3 Query / `(ds)` | `CapaSpeedPlan.tsx:109~112` | `itemsSource` 참조 안정화(`useMemo`) | 구현 |
| D00-3-011 | §3 LockColumn / `(0, _si.GetMaxColumnIndex(), true)` | `utils/capaSpeedPlan.editLock.ts:69` | `isEditMode=false` 면 전 셀 읽기전용(03 R-24) | 구현 |
| D00-3-012 | §3 SetBGColor / `(rowIdx, measureNameColIdx, rowIdx, colCnt-1, color)` | `components/CapaSpeedPlanGrid.tsx:165~172`, `components/CapaSpeedPlanGrid.module.scss:5~7` | 대상 measure 는 admin 메타(`SCM_MST_SHEET_MEASURE.ATTRIBUTE3` 4행)에서 도출. 색값 `220,220,220` 은 사용자 확정 BLK-7 | 구현 |
| D00-3-013 | §3 ToggleMerge / `(spdMain.ActiveSheet, true)` | `components/CapaSpeedPlanGrid.tsx:296~298` | `isEditMode` 파생값이라 조회 직후(`AfterFindData`)에도 병합이 걸린다 | 구현 |
| D00-3-014 | §3 SmartColMerge / `()` | `components/CapaSpeedPlanGrid.tsx:296~298` | 공용 `AllowMerging.All` 이 컬럼 병합을 함께 처리 | 구현 |
| D00-3-015 | §3 Insert / `()` | — | AS-IS `InsertButton()` 본문이 빈 구현이라 `Insert_Row`(cs:2367) 호출부 0건 = 도달 불가. TO-BE 는 버튼을 남기고 명시적 무동작(`CapaSpeedPlan.tsx:212`)이다 | 제외 |
| D00-3-016 | §3 SetValue / `(newCell, dic)` | — | 행 추가 경로가 없어 신규행 기본값 세팅에 도달할 수 없다(03 R-16) | 제외 |
| D00-3-017 | §3 SetValue / `(qtyRowIdx, i, base_qty)` | — | `SetBaseToDateColumns` 호출부 3건이 전부 주석이라 런타임 미발동(03 R-17) | 제외 |
| D00-3-018 | §3 SetValue / `(ppmRowIdx, qtyColIdx, ppm)` | `hooks/useCapaSpeedPlanCellEdit.ts:83`, `utils/capaSpeedPlan.recalc.ts:97~186` | PPM 산식 4종 + 블록/measure 정체성 가드 | 구현 |
| D00-3-019 | §3 SetValue / `(ppmRowIdx, 0, "M")` | `hooks/useCapaSpeedPlanCellEdit.ts:84~89` | 공용 `EditTracker.storeChange` 경유 — 자체 행상태 필드 신설 0건 | 구현 |
| D00-3-020 | §3 IsLockCell / `(ppmRowIdx, colIdx)` | `hooks/useCapaSpeedPlanCellEdit.ts:76~82` | PPM 셀이 편집 가능하면 덮어쓰지 않는다(cs:2914) | 구현 |
| D00-3-021 | §3 SetText / `(r, colIdx, ELTR_LN_TP_CD)` | `utils/capaSpeedPlan.editLock.ts:111~128`, `hooks/useCapaSpeedPlanCellEdit.ts:55~65` | 6키가 모두 채워진 행에서만 발동 | 구현 |
| D00-3-022 | §3 SetValue / `(r, 0, "M")` | `hooks/useCapaSpeedPlanCellEdit.ts:58~63` | `storeChange` 로 `CRUD_TYPE=M` | 구현 |
| D00-3-023 | §3 IsLockCell / `(e.Row, e.Column)` | `components/CapaSpeedPlanGrid.tsx:262~271` | 잠금 셀이면 편집 후속(재계산) 자체를 돌리지 않는다 | 구현 |
| D00-4b-001 | §4b BLUtils.GetDivisionWithoutEE / (false) / dtDivision | `hooks/useCapaSpeedPlanCombos.ts:78`, `utils/capaSpeedPlan.combos.ts:54~57` | `Division_SCP` + AS-IS 후처리 `ATTRIBUTE3<>'EE'` 를 FE 클라 필터로 재현(convert-core §2.6) | 구현 |
| D00-4b-002 | §4b Data_SCP.CommonAll / YearFromThisYear / dtFromYYYY | — | `dtFromYYYY` 는 선언(cs:73) 외 참조 0건 — 짝인 `cboFromYYYY` 컨트롤도 Designer 에 없다(02 F-25) | 제외 |
| D00-4b-003 | §4b Data.Common / YesOrNo / dtYesOrNo | — | `dtYesOrNo` 는 선언(cs:74) 외 참조 0건(02 F-25) | 제외 |
| D00-4b-004 | §4b Data_SCP.CommonAll / OperationElectrodeType / tbl → dtElectrodeAll | `hooks/useCapaSpeedPlanCombos.ts:85`, `hooks/useCapaSpeedPlanCombos.ts:182~197`, `components/CapaSpeedPlanGrid.tsx:112~136` | `OperationElectrodeType_SCP_ALL` — 조회조건(ELTR)과 그리드 셀 콤보 양쪽 공급. 셀 콤보는 **행 기준**으로 좁힌다 | 구현 |
| D00-4c-001 | §4c DBUtils.Filter / dtOperationAll | `utils/capaSpeedPlan.combos.ts:322~328` | Operation 후보에서 Formation(`AFFFF`) 제외 | 구현 |
| D00-4c-002 | §4c DBUtils.Filter / tbl → dtElectrodeAll | `utils/capaSpeedPlan.combos.ts:347~367` | ELTR 전극 공정 접두 필터(`OPERATION_ID='E2000'`) | 구현 |
| D00-4c-003 | §4c DBUtils.Filter / dtVersionAll | `utils/capaSpeedPlan.combos.ts:82~98` | VersionSeq 를 Division+Version 으로 한정 | 구현 |
| D00-4c-004 | §4c DBUtils.Filter / dtVersionAll | `utils/capaSpeedPlan.combos.ts:130~142`, `hooks/useCapaSpeedPlanCombos.ts:116~125` | `PROG_STAT` = Edit 차단·Status 필터의 기준값(선택값과 다른 축) | 구현 |
| D00-4c-005 | §4c DBUtils.Filter / dtOperationAll | `utils/capaSpeedPlan.combos.ts:265~296`, `utils/capaSpeedPlan.combos.ts:322~332` | Operation cascade — 상위 6축으로 후보 좁힘 | 구현 |
| D00-4c-006 | §4c DBUtils.Filter / dtElectrodeAll | `utils/capaSpeedPlan.combos.ts:334~345` | ElectrodeType cascade — Operation 선택으로 후보 좁힘(ASSEMBLY) | 구현 |
| D00-4c-007 | §4c DBUtils.Filter / tblRaw | — | `GetExistsDifferentEquipmentType` 의 유일 호출부가 `SaveButton` 내 주석(cs:2023~2031)이라 미발동. 서버 SAVE 의 `50426` 분기가 실질 대체 경로다(`hooks/useCapaSpeedPlanSave.ts:94~101`) | 제외 |
| D00-4d-001 | §4d SpdMain_CellClick / – | `components/CapaSpeedPlanGrid.tsx:220` | 셀 콤보는 ELTR 시트에서만 꽂는다 | 구현 |
| D00-4d-002 | §4d SpdMain_CellClick / – | `utils/capaSpeedPlan.editLock.ts:69`, `components/CapaSpeedPlanGrid.tsx:216~217` | 편집모드가 아니면 전 셀 잠금이라 편집 진입 자체가 없다 | 구현 |
| D00-4d-003 | §4d SpdMain_CellClick / – | `components/CapaSpeedPlanGrid.tsx:210~217` | `isCellEditable` 이 false 면 `event.cancel=true` | 구현 |
| D00-4d-004 | §4d FindButton / Search | `CapaSpeedPlan.tsx:167` | AS-IS `Required` 지정 0건·라벨 `*` 0건 → 실질 게이트는 Division 권한뿐(02 F-21). 필수 alert 신설 금지 | 구현 |
| D00-4d-005 | §4d EditButton / Edit | `CapaSpeedPlan.tsx:191` | `!gridRef.current` = 그리드 미마운트 -> 무반응(메시지 없음) | 구현 |
| D00-4d-006 | §4d EditButton / Edit | `CapaSpeedPlan.tsx:191` | 시트 미생성은 TO-BE 에서 그리드 미마운트와 같은 상태다(단일 그리드 + sheetName 스위치) | 구현 |
| D00-4d-007 | §4d EditButton / Edit | `CapaSpeedPlan.tsx:192` | 조회 결과 0건 -> 무반응 | 구현 |
| D00-4d-008 | §4d EditButton / Edit | `CapaSpeedPlan.tsx:196~202`, `capa-speed-plan.constants.ts:125~131` | 진행상태 `-`/`1`/`2` -> `MSG00109` 차단(Edit 클릭 시점 판정) | 구현 |
| D00-4d-009 | §4d DeleteButton / Delete | `CapaSpeedPlan.tsx:221` | — | 구현 |
| D00-4d-010 | §4d DeleteButton / Delete | `CapaSpeedPlan.tsx:222` | — | 구현 |
| D00-4d-011 | §4d DeleteButton / Delete | `CapaSpeedPlan.tsx:223` | `!grid.selectedRows?.length` | 구현 |
| D00-4d-012 | §4d SaveButton / Save | `hooks/useCapaSpeedPlanSave.ts:137` | — | 구현 |
| D00-4d-013 | §4d SaveButton / Save | `hooks/useCapaSpeedPlanSave.ts:138` | `!isEditMode` = 비편집 상태 저장 차단(AS-IS `IsLock(SheetName)`) | 구현 |
| D00-4d-014 | §4d SaveButton / Save | `hooks/useCapaSpeedPlanSave.ts:139` | — | 구현 |
| D00-4d-015 | §4d SaveButton / Save | `hooks/useCapaSpeedPlanSave.ts:151~154` | 공용 `useSaveWithValidation` 로 배선. 메타 `INPUT_TP_CD` 가 63행 전건 `S`(DB 재실측 2026-09-24)라 **무발동**인 것이 AS-IS 동작이며 사용자 확정(BLK-10)으로 파리티 유지 — 메타 정정·코드 우회 0건 | 구현 |
| D00-4d-016 | §4d _defaultDataModel_Changed / – | `components/CapaSpeedPlanGrid.tsx:256` | `sender.rows.length===0` | 구현 |
| D00-4d-017 | §4d _defaultDataModel_Changed / – | `components/CapaSpeedPlanGrid.tsx:256` | AS-IS `GetMaxRowIndex()==-1` 과 동일 조건 | 구현 |
| D00-4d-018 | §4d _defaultDataModel_Changed / – | `components/CapaSpeedPlanGrid.tsx:257` | 행/열 인덱스가 -1 이면 즉시 return (AS-IS 와 동일 순서) | 구현 |
| D00-4d-019 | §4d _defaultDataModel_Changed / – | `components/CapaSpeedPlanGrid.tsx:258` | `!editModeRef.current` = 시트 잠금 상태 | 구현 |
| D00-4d-020 | §4d _defaultDataModel_Changed / – | `components/CapaSpeedPlanGrid.tsx:258` | 동일 가드(TO-BE 는 `isEditMode` 하나로 시트잠금·편집모드를 함께 표현) | 구현 |
| D00-4d-021 | §4d _defaultDataModel_Changed / – | `components/CapaSpeedPlanGrid.tsx:262~271` | `isCellEditable` false = 잠금 셀이면 후속 재계산 skip | 구현 |
| D00-4e-001 | §4e SCM0002_CAPAItemPopup / ShowDialog | `components/CapaSpeedPlanItemPopup.tsx:27~45`, `features/supply/src/components/CapaItemPopup.tsx` | 공용 컴포넌트 재사용(사본 0건). `multiSelect` + `operationGroup` prop 은 기본값이 기존 동작이라 SCP0104 호출부 불변 | 구현 |
| D00-4e-002 | §4e SCM002_CAPAColumnPopup / ShowDialog | `components/CapaSpeedPlanColumnModal.tsx:30~67` | 공용 `ColumnLayoutModal` 에 `programId`+`sheetName`+`columnType` 3축 전달(hook #115) | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:CapaSpeedPlanColumnModal | FE 실존 모달 (components/CapaSpeedPlanColumnModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | `components/CapaSpeedPlanColumnModal.tsx:23~68` | AS-IS `SCM002_CAPAColumnPopup`(cs:3166~3175) 대응 — FE 단독 모달 아님 | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | `components/CapaSpeedPlanItemPopup.tsx:23~46` | AS-IS `SCM0002_CAPAItemPopup`(cs:3124~3164) 대응 | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | — | 행 추가 경로 자체가 없다 — AS-IS `InsertButton()` 본문이 빈 구현이라 TO-BE 도 명시적 무동작(`CapaSpeedPlan.tsx:212`)이다. 신규행이 생기지 않으므로 `keepRowVisibleUnderFilter` 대상이 없다 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | `components/CapaSpeedPlanGrid.tsx:327`, `packages/shared/src/components/organisms/sub-title/SubTitle.tsx:198` | 공용 위임 — `editTrackerRef` 를 넘기면 `DataGrid.tsx:560~568` 이 `registerDirtyCheck` 로 dirty 를 등록하고, 조회(F5/버튼)는 `confirmIfDirtyKey(dirtyKey, 'search')` 로 확인을 띄운다(`useDirtyRegistry.ts:110` = `MSG00704`). `MSG00704`/`MSG00703` 둘 다 `SCM_ADM_MSG_M` 실재 확인(ora.py 2026-09-24) | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | `components/CapaSpeedPlanColumnModal.tsx:63` | OK 시 `clearFilters()` 로 조회 데이터 Reset — 재조회는 사용자가 다시 누른다(AS-IS `BeforeFindData` 동일) | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | `hooks/useCapaSpeedPlanSave.ts:105~112` | `setToast({type:'success'})` + `MSG00672`(`{0}` 건수 보간). alert 아님 | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | `components/CapaSpeedPlanGrid.tsx:223`, `CapaSpeedPlan.tsx:316` | 이 화면의 콤보 컬럼은 ELTR `ELTR_LN_TP_CD` 1건이고 `DataMap` 의 CODE=NAME(둘 다 `SEGMENT3`)이라 코드 노출이 구조적으로 없다. 엑셀 다운로드는 공용 SubTitle(`excelFileName`) 경유 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | `components/CapaSpeedPlanItemPopup.tsx:34~43`, `hooks/useCapaSpeedPlanCombos.ts:257` | Item 팝업 다중선택 결과를 Distinct 후 `,` 로 이어 `p_item_id` 로 보낸다(AS-IS `GetSelectedValues` + `string.Join(",")`) | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | `components/CapaSpeedPlanGrid.tsx:326`, `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1483` | 공용 위임 — `gridFilterRef` 를 넘기면 레이아웃 갱신마다 `rebindFilterColumns` 가 끊긴 필터-컬럼 연결을 복구한다 | 구현 |

## 근거 문서

| 구분 | 경로 |
|---|---|
| AS-IS 원소스 | `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0105_CAPA_Speed_Plan/SCP0105_CAPA_Speed_Plan.cs` (3,177줄) |
| AS-IS Designer | 같은 폴더 `SCP0105_CAPA_Speed_Plan.Designer.cs` (1,095줄) |
| 설계 00 | `.atlas/gscm-design/SCP0105/design/00_checklist.md` |
| 설계 01 | `.atlas/gscm-design/SCP0105/design/01_layout.md` (L-01~L-27) |
| 설계 02 | `.atlas/gscm-design/SCP0105/design/02_search-combo.md` (F-01~F-25) |
| 설계 03 | `.atlas/gscm-design/SCP0105/design/03_grid-columns.md` (R-01~R-29 / C-01~C-11 / V-01~V-48) |
| 설계 07 | `.atlas/gscm-design/SCP0105/design/07_human-doc-supplement.md` |

## 표기 규약

- `cs:NNNN` = `SCP0105_CAPA_Speed_Plan.cs` / `dsn:NNNN` = `SCP0105_CAPA_Speed_Plan.Designer.cs`.
- 위 두 파일의 라인은 **본 문서 작성 중 원소스를 직접 열어 확인한 값**이다.
- `†` 가 붙은 라인은 공용 프레임워크 파일(`BaseForm` / `ScpCapaBL` / `BLUtils` / `DBUtils` / `CString` / `DataUtil` / `SheetUtils` / `ScpCapa`)이라 이번 회차에 원소스를 열지 않았고, 설계 01~03 의 인용값을 그대로 옮겼다.
- 라인을 확정하지 못한 항목은 `확인필요` 로 적었다. 추측 라인은 쓰지 않았다.
- TO-BE 파일명은 `capa-speed-plan/` 이하 상대경로다.

---

## ① 진입 / 초기화

| AS-IS 요소(메서드/컨트롤) | AS-IS 위치 | TO-BE 위치 | 비고 |
|---|---|---|---|
| `InitControls()` — 진입 시 컨트롤·콤보 일괄 초기화 | cs:1234~1250 | `hooks/useCapaSpeedPlanConditionEffects.ts:44~51`, `hooks/useCapaSpeedPlanCombos.ts:76~87` | AS-IS 는 `Refresh*` 6종을 동기 연쇄 호출(cs:1244~1249). TO-BE 는 react-query 병렬 로드 + 파생 `useMemo` |
| `InitEvent()` — 이벤트 배선 13건 | cs:1401~1418 | `components/CapaSpeedPlanForm.tsx` 각 `onChange`, `components/CapaSpeedPlanGrid.tsx:146~287` | 그리드 핸들러 4종(`formatItem`/`beginningEdit`/`pastingCell`/`cellEditEnded`)만 명시 add/removeHandler |
| 진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건) | cs 참조 0건 (02 F-19) | `hooks/useCapaSpeedPlanConditionEffects.ts:44~51` (`clearFilters()`) | keep-alive 잔여 `filters` 무효화까지 겸한다 |
| `CreateSpread()` — `AddSheet` ×2 (ASSEMBLY/ELTR) | cs:1300~1310 (시트 1302·1303) | `capa-speed-plan.constants.ts:12~16` (`SHEETS`), `components/CapaSpeedPlanGrid.tsx:59~71` | 탭이 아니라 스위치. 그리드는 1개 (03 R-01) |
| `InitSpread()` — 시트 가시성 전환 | cs:1337~1353 (가시성 1341~1344) | `CapaSpeedPlan.tsx:80` (`sheetName` 파생) | 확정 조회조건(`applied ?? sc`) 기준 |
| `_sheet_idx` — DivisionType → 시트 인덱스 | cs:1283~1296 | `capa-speed-plan.constants.ts:64~68` (`SHEET_BY_DIVISION_TYPE`) | |
| `_division_type_name` — `ScpCapa.GetDivisionTypeName` | cs:187~193 | `capa-speed-plan.constants.ts:31~34` (`ADMIN_SHEET_NAME`), `hooks/useCapaSpeedPlanCombos.ts:261` | admin `SHEET_NAME` 과 대소문자까지 동일 |
| `_fixed_column_name` = `DefColumns.IDX` | cs:175~185 | `capa-speed-plan.constants.ts:184` (`FIXED_COLUMN`) | 좌측 고정 경계. 소비처는 ③ 참조 |
| `_sheet_status` — GET SP 변형 선택자 | cs:552~573 | `capa-speed-plan.constants.ts:132~137` (`SHEET_STATUS`) | `'2'`(2nd Cutoff)는 AS-IS 도 빈 문자열 → 도달 불가 |
| `_sheet_name` — QueryId 접미 조립 | cs:545~551 | `hooks/useCapaSpeedPlanCombos.ts:265` (`p_sheet_status`) | `PKG_SCP0105` 미배포로 런타임 체인 미완(goal BLK-2) |
| `_from_yyyymm` — 선택 Plan Month +1개월 | cs:243~264 | `utils/capaSpeedPlan.dateColumns.ts:32~35` (`toFromYyyymm`) | `DateTime.ParseExact` → `dayjs` |
| Division 권한 0건 게이트 `SetDivisionAuthCheck(usrLayoutControl2)` | cs:1241~1242 (BaseForm:5995~6003†) | `CapaSpeedPlan.tsx:145~155`, `CapaSpeedPlan.tsx:307` (`disabled`), `components/CapaSpeedPlanForm.tsx:21~23` | 메시지는 `MSG00097` → **`MSG00667`** 재매핑 (01 L-04) |
| `_division_type` getter — `rgrpDivisionType.SelectedIndex` | cs:194~217 | `useCapaSpeedPlanStore.ts:98` (`divisionType`) | 정수 `0/1/2` → 문자열 enum. ⑧ BLK-4 참조 |
| `_division` getter | cs:219~242 | `useCapaSpeedPlanStore.ts:99` (`divisionId`) | |
| admin 컬럼/Measure 메타 동적 fetch | AS-IS 대응 없음 | `useCapaSpeedPlanStore.ts:270~300`, `275~294` | TO-BE 고유 의무(CLAUDE.md §2 체크3). mount 1회 + 매 Search refetch |
| Division 변경 시 그리드·컬럼셋 초기화 | cs:2423~2432 (`cboDivision_SelectedIndexChanged`) | `hooks/useCapaSpeedPlanConditionEffects.ts:59~68` | `fetchStaticColumns(sc.divisionId)` 에 새 값을 **인자로** 넘긴다 |

---

## ② 조회조건 · 콤보 · cascade

### 컨트롤 13필드

| AS-IS 요소(메서드/컨트롤) | AS-IS 위치 | TO-BE 위치 | 비고 |
|---|---|---|---|
| `rgrpDivisionType` (라디오 3옵션) | dsn:609~621 (항목 615~618), 값 cs:194~217 | `components/CapaSpeedPlanForm.tsx:59~66`, `76~92` | 공용 RadioGroup 부재 → 단일선택 드롭다운. 초기값은 ⑧ BLK-4 |
| `cboDivision` | 소스 cs:45, `RefreshDivision()` cs:1018~1021 | `components/CapaSpeedPlanForm.tsx:93~107`, 옵션 `utils/capaSpeedPlan.combos.ts:54~57` | SQL_ID `Division_SCP` (`constants.ts:77`) |
| `cboVersion` (Plan Month) | 소스 cs:47, `RefreshVersion()` cs:1023~1031 | `components/CapaSpeedPlanForm.tsx:108~122`, `utils/capaSpeedPlan.combos.ts:65~79` | 서버 정렬 유지(FE 재정렬 금지) |
| `cboVersionSeq` (Version) | `RefreshVersionSeq()` cs:1033~1042 | `components/CapaSpeedPlanForm.tsx:123~137`, `utils/capaSpeedPlan.combos.ts:82~98` | |
| `txtPlanType` (읽기전용 파생) | `RefreshPlanType()` cs:1044~1047 (`txtPlanType.Text` 1046) | `components/CapaSpeedPlanForm.tsx:138~145`, `utils/capaSpeedPlan.combos.ts:115~123` | 라벨 없는 disabled InputField |
| `cboProgressStatus` (Status) | 소스 cs:50, `RefreshProgressStatus()` cs:1071~1107 | `components/CapaSpeedPlanForm.tsx:148~164`, `utils/capaSpeedPlan.combos.ts:144~164` | 3중 필터 전건 이식 |
| `GetCurrVersionProgessStatus()` | cs:1049~1069 | `utils/capaSpeedPlan.combos.ts:130~142`, `useCapaSpeedPlanStore.ts:55`·`120` | Status 콤보 **선택값과 다른 값**이다. Edit 게이트 기준 |
| Status 기본선택 `UIUtils.GetIndexByCode` | cs:1097~1106 | `hooks/useCapaSpeedPlanCombos.ts:224~231` | 없으면 첫 행 |
| `clbSite` | `RefreshSiteAll()` cs:905~914, `RefreshSite()` cs:1109~1117 | `components/CapaSpeedPlanForm.tsx:165~191`, `utils/capaSpeedPlan.combos.ts:297~305` | Site 만 `SHOP_GROUP_ID` 미적용(BL:144~166†) |
| `clbPlant` | cs:916~925, cs:1119~1127 | `components/CapaSpeedPlanForm.tsx:192~216`, `utils/capaSpeedPlan.combos.ts:307~308` | |
| `clbFactory` (표기 "Building") | cs:927~936, cs:1129~1137 | `components/CapaSpeedPlanForm.tsx:217~241`, `utils/capaSpeedPlan.combos.ts:310~311` | 라벨 `LBL00008` — "Factory" 아님 |
| `clbLine` | cs:938~947, `RefreshLine()` cs:1139~1199 | `components/CapaSpeedPlanForm.tsx:247~269`, `utils/capaSpeedPlan.combos.ts:313~316` + `183~214` | `_C`/`_A` 쌍 재정렬(02 F-13) |
| `clbOperation` | cs:949~962, `RefreshOperation()` cs:1201~1214 | `components/CapaSpeedPlanForm.tsx:270~293`, `utils/capaSpeedPlan.combos.ts:322~328` | Formation 더미 `AFFFF` 제외(`constants.ts:89`) |
| `clbElectrodeType` (Line Type) | cs:964~996, `RefreshElectrodeType()` cs:1216~1229 | `components/CapaSpeedPlanForm.tsx:294~314`, `utils/capaSpeedPlan.combos.ts:334~339`(ASSEMBLY) / `356~367`(ELTR) | 원천이 시트축마다 다르다 |
| `txtItem` + `btnItemId` | `ShowItem()` cs:3124~3154, `btnItem_Click` cs:3156~3164 | `components/CapaSpeedPlanForm.tsx:317~349`, `components/CapaSpeedPlanItemPopup.tsx:27~45` | 반환 컬럼 분기(cs:3138~3149) → `components/CapaSpeedPlanItemPopup.tsx:34~40` |
| Item 라벨 동적 치환 (01 L-03) | cs:2478·2485 (ScpCapa:50~54†) | `components/CapaSpeedPlanForm.tsx:320~324` | Cell/MP = Basic Nickname / ELTR = Model |
| `SetVisibleOperation()` (01 L-01) | cs:2462~2472 | `components/CapaSpeedPlanForm.tsx:50`, `271` | 조건식 `!== ELTR` |
| `SetVisibleElectrodeType()` (01 L-02) | cs:2474~2490 | `components/CapaSpeedPlanForm.tsx:51~52`, `295` | 조건식 `in {CELL, MODULE_PACK}` — **두 식의 비대칭을 통일하지 않는다** |

### cascade / payload

| AS-IS 요소 | AS-IS 위치 | TO-BE 위치 | 비고 |
|---|---|---|---|
| `rgrpDivisionType_SelectedIndexChanged` | cs:2453~2460 | `useCapaSpeedPlanStore.ts:172~194` | 유일한 서버 재조회축(마스터 comboId 교체) |
| `cboDivision_SelectedIndexChanged` | cs:2423~2432 | `components/CapaSpeedPlanForm.tsx:103`, `hooks/useCapaSpeedPlanConditionEffects.ts:59~68` | |
| `cboVersion_SelectedIndexChanged` | cs:2434~2442 | `components/CapaSpeedPlanForm.tsx:118`, `hooks/useCapaSpeedPlanCombos.ts:205~218` | |
| `cboVersionSeq_SelectedIndexChanged` | cs:2444~2451 | `components/CapaSpeedPlanForm.tsx:133`, `hooks/useCapaSpeedPlanCombos.ts:205~218` | |
| `cboProgressStatus_SelectedIndexChanged` | cs:2492~2497 | `components/CapaSpeedPlanForm.tsx:158~160` | |
| `clbSite_SelectedIndexChanged` | cs:2500~2506 | `components/CapaSpeedPlanForm.tsx:178~187` | 하위 5축 `ALL` 리셋 |
| `clbPlant_SelectedIndexChanged` | cs:2508~2513 | `components/CapaSpeedPlanForm.tsx:204~212` | |
| `clbFactory_SelectedIndexChanged` | cs:2515~2519 | `components/CapaSpeedPlanForm.tsx:230~237` | |
| `clbLine_SelectedIndexChanged` | cs:2521~2524 | `components/CapaSpeedPlanForm.tsx:259~265` | |
| `clbOperation_SelectedIndexChanged` | cs:2526~2529 | `components/CapaSpeedPlanForm.tsx:283~288` | |
| `RefreshAllPre()` — 마스터 전량 재수신 | cs:1261~1271 | `hooks/useCapaSpeedPlanCombos.ts:76~87` | `comboId` 가 바뀌면 react-query 키가 갈라져 자동 재조회 |
| `RefreshAll()` — 6축 재계산 | cs:1273~1281 | `hooks/useCapaSpeedPlanCombos.ts:133~197` | 서버 왕복 0회(클라 슬라이스, 02 F-15) |
| `BLUtils.GetDivisionWithoutEE` — `ATTRIBUTE3 <> 'EE'` | BLUtils.cs:107~116† | `utils/capaSpeedPlan.combos.ts:56`, `constants.ts:86` | 이관 CMBO WHERE 에 없어 FE 재현 |
| `ScpCapaBL.GetFilteredPackCell` — `SHOP_GROUP_ID` | ScpCapaBL.cs:35~42† | `utils/capaSpeedPlan.combos.ts:283`, `constants.ts:57~61` | |
| `ScpCapa.GetShopGroupId` | ScpCapa/CAPA:111~135† | `capa-speed-plan.constants.ts:57~61` | |
| `GetElectrodeOperationFilter` — `OPERATION_ID` 접두 | ScpCapaBL.cs:634~652† | `utils/capaSpeedPlan.combos.ts:347~354`, `constants.ts:92` | 빠지면 ELTR 에서 125건 전량 노출(02 F-12) |
| `GetSortedCode` — `DMY_` 후치 | ScpCapaBL.cs:81~136† | `utils/capaSpeedPlan.combos.ts:171~175`, `constants.ts:95` | Site/Plant/Building/Line 4곳 |
| `DBUtils.DeleteEmptyName` | DBUtils.cs:572~633† | `utils/capaSpeedPlan.combos.ts:237~262` | `isCodeIsName` 2모드 모두 재현 |
| `CString.GetCheckedListValueNone` — 다중선택 전개 | CString.cs:554~581† | `utils/capaSpeedPlan.combos.ts:381~385`, `constants.ts:105`·`108` | 무선택 = 후보 전체 join, 0건 = `NONE` |
| `SetQueryInfoGet()` — GET payload 15건 | cs:2226~2258 (파라미터 2240~2254) | `hooks/useCapaSpeedPlanCombos.ts:239~266` | 파라미터명 AS-IS 그대로 |
| GET QueryId 조립 | cs:2238 | `capa-speed-plan.constants.ts:7` (주석), `hooks/useCapaSpeedPlanCombos.ts:265` | 4변형 |
| 콤보 SQL_ID 6종 | — (이관 `SCM_ADM_CMBO_SQL_M`) | `capa-speed-plan.constants.ts:76~83` | `_SCP` / `_SCP_ALL` 접미 규약 |
| 조회조건 13필드 타입 | — | `capa-speed-plan.types.ts:7~20` | |

---

## ③ 그리드 컬럼 · 동적 기간열

| AS-IS 요소(메서드/컨트롤) | AS-IS 위치 | TO-BE 위치 | 비고 |
|---|---|---|---|
| `spdMain` (FpSpread, 2시트) | dsn:942~951†, cs:1300~1310 | `components/CapaSpeedPlanGrid.tsx:324~338` | 공용 `DataGrid` 1개 + `sheetName` prop |
| `RefreshSheetHeader()` / `SetSheetHeaderColumnSCP(_si, 3, ...)` — 3단 헤더 | cs:1355~1379 (3단 지정 1359) | `capa-speed-plan.constants.ts:244~245`, `components/CapaSpeedPlanGrid.tsx:334` | 높이는 `headerRowHeight` prop 단일 출처(hook #93) |
| `GetSpdTitle()` — 기간 헤더 SP 호출 | cs:1312~1335 (파라미터 1318~1320) | `utils/capaSpeedPlan.dateColumns.ts:131~138`, `CapaSpeedPlan.tsx:99~105` | `PKG_SCP0104` 공용 SP. 3축 전부 캐시키에 실린다(hook #115) |
| `_sheetDateColumns` — `_ASSIGN_PRIORITY` 제외 목록 | cs:1326~1327 | `utils/capaSpeedPlan.dateColumns.ts:45~48` | 저장 직렬화 순서의 원천 |
| 기간 컬럼명 규약 `M_01yyyymm` / `Y_yyyy` | cs:2887~2888 (`M_`/`Y_` 판정) | `capa-speed-plan.constants.ts:175`, `utils/capaSpeedPlan.dateColumns.ts:17~22` | `M_` 뒤 `01` 누락 시 저장 파싱 붕괴(03 V-13) |
| 3단 그룹 조립 (Large > Small > Column) | AS-IS 는 `SheetUtils` 위임 — 라인 확인필요 | `utils/capaSpeedPlan.dateColumns.ts:64~118` | 1단 라벨은 SCP0105 에서 항상 공백(03 C-11) |
| `RefreshColumnsVisible()` — `*_ASSIGN_PRIORITY` 폭0 + Resizable=false | cs:1380~1397 (판정 1388~1393) | `utils/capaSpeedPlan.dateColumns.ts:68~70` | **의도적 변경**: 컬럼을 만들지 않는다. Wijmo 는 폭0 컬럼도 우클릭 메뉴/컬럼설정에 노출돼 R-03 취지가 깨진다. 행 데이터는 유지 |
| `_fixed_column_idx` 좌측 고정 | cs:1382, `LockRange2` cs:1509 | `components/CapaSpeedPlanGrid.tsx:308~311` | 메타 `FIXED_FLAG` 경로는 `IDX` 폭0라 0 이 나온다 → 정적 컬럼 개수로 직접 산출 |
| `SetSheetMerge()` — 조회모드 병합 | cs:2147~2154 (`ToggleMerge` 2151 / `SmartColMerge` 2152) | `components/CapaSpeedPlanGrid.tsx:296~298` | 편집 진입 시 해제(cs:1483·1578). `isEditMode` 파생값으로 항상 계산 |
| `Set_MeasureColor()` — Measure 행 배경색 | cs:2111~2145 (색 2135, ASSEMBLY 가드 2104~2108) | `components/CapaSpeedPlanGrid.tsx:165~172`, `components/CapaSpeedPlanGrid.module.scss:5~7`, `constants.ts:203~208` | `MEASURE_NAME` 열부터 우측 끝까지. 색값은 ⑧ BLK-7 |
| `SetSheetNumericColumnFormatASSEMBLY()` — measure별 소수자릿수 | cs:1707~1742 | `capa-speed-plan.constants.ts:220~233`, `components/CapaSpeedPlanGrid.tsx:139~144`·`183~196` | 편집/조회 2벌. `PPM_AVG` 는 AS-IS dict 에 없어 넣지 않았다 |
| `SetSheetNumericColumnFormat()` 분기 | cs:1695~1705 | `components/CapaSpeedPlanGrid.tsx:139~144` | ELTR 분기는 ⑦ 참조 |
| `btnColumn_Click` → `SCM002_CAPAColumnPopup("SCP0105", _division_type_name, true)` | cs:3166~3175 (팝업 3168) | `CapaSpeedPlan.tsx:272~293`(버튼), `components/CapaSpeedPlanColumnModal.tsx:30~67`(모달) | `sheetName` 을 넘겨야 ASSEMBLY/ELTR 설정이 섞이지 않는다 |
| 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구성) | cs:3173, `BeforeFindData()` cs:2041~2048 | `components/CapaSpeedPlanColumnModal.tsx:63` (`clearFilters()`) | 조회는 사용자가 다시 누른다 |
| 컬럼 개인화 적용 | AS-IS 는 `SheetUtils` 위임 — 라인 확인필요 | `useCapaSpeedPlanStore.ts:129~153`, `324~334` | 표시/순서/폭/색 |
| `_si.Query(ds)` — 결과 바인딩 | cs:2059 | `CapaSpeedPlan.tsx:109~112` (`rows`) | `itemsSource` 참조 안정화 필요 |
| 행 스키마 (두 시트 공통 + 시트별 확장) | GET SP 반환 컬럼 | `capa-speed-plan.types.ts:49~99` | `IDX`/`EDITABLE_YN`/`MEASURE_COLOR`/`MMS_CF` optional (03 C-01/C-02) |
| 기간 헤더 행 스키마 | `SCP0104_GET_SPREAD_TITLE` 반환 | `capa-speed-plan.types.ts:35~42` | |
| 컬럼 키 상수 | `DefColumns.*` | `capa-speed-plan.constants.ts:149~172` | 컬럼 **목록**은 admin 메타가 원천. 여기는 코드가 의미를 읽는 컬럼만 |
| Measure 코드 7종 | cs:2133 (색상 대상 4종) | `capa-speed-plan.constants.ts:189~208` | |

---

## ④ 편집잠금 · 셀콤보 · 파생계산

| AS-IS 요소(메서드/컨트롤) | AS-IS 위치 | TO-BE 위치 | 비고 |
|---|---|---|---|
| `SetLockColumns()` — 시트별 분기 | cs:1467~1477 | `utils/capaSpeedPlan.editLock.ts:63~82` (`isCellEditable`) | AS-IS 좌표범위 → TO-BE 의미 판정(hook #130) |
| `SetLockColumnsASSEMBLY()` | cs:1479~1572 | `utils/capaSpeedPlan.editLock.ts:76~81` | |
| `SetLockColumnsELTR()` | cs:1574~1693 | `utils/capaSpeedPlan.editLock.ts:71~74`·`77~81` | ELTR 은 `EDITABLE_YN` 을 보지 않는다 — 추가하면 전 셀 잠김 |
| 고정영역 전 행 잠금 `LockRange2(0, 0, rowCnt-1, _fixed_column_idx, true)` | cs:1509 (ELTR 대응 cs:1605) | `utils/capaSpeedPlan.editLock.ts:77` | 기간열이 아니면 전부 잠금 |
| `EDITABLE_YN` 소비 (03 R-06) | cs:1494·1522·1527 | `utils/capaSpeedPlan.editLock.ts:80` | ASSEMBLY 전용 |
| `*_ASSIGN_PRIORITY` 0/공백 잠금 `SheetUtils.IsCurrPriorityNone` | cs:1547 (SheetUtils.cs:1417~1459†) | `utils/capaSpeedPlan.editLock.ts:33~40`, `constants.ts:181` | 화면 비노출이지만 행 데이터에는 반드시 실려야 한다 |
| `ELTR_LN_TP_CD` 편집 조건 (03 R-08) | cs:1618~1638 (판정 1623~1626, 분기 1631) | `utils/capaSpeedPlan.editLock.ts:43~50` | 설비유형 공백 OR `EQUIPMENT_ID` 공백 OR `UI_UPD_YN='Y'` |
| 조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxColumnIndex(), true)` (03 R-24) | cs:2090 | `utils/capaSpeedPlan.editLock.ts:69` | `isEditMode=false` = 전 셀 읽기전용 |
| 편집 게이트 적용점 (`IsLockCell`) | cs:1435, cs:3104 | `components/CapaSpeedPlanGrid.tsx:204~226`(beginningEdit), `228~245`(pastingCell), `174~181`(formatItem 표시) | 공용 `INPUT_TP_CD` 판정 뒤 화면이 최종 재지정 |
| `SpdMain_CellClick` + `SheetUtils.SetComboDataRow` — ELTR 셀 콤보 | cs:1423~1442 (lock 가드 1435, 콤보 1441) | `components/CapaSpeedPlanGrid.tsx:219~224` | 잠금 셀이 아닐 때만 꽂는다(03 R-04) |
| `RefreshElectrodeTypeSpread()` — 행 기준 후보 좁힘 | cs:1444~1449 (`GetFilterElectrodeType` ScpCapaBL.cs:370~403†) | `components/CapaSpeedPlanGrid.tsx:112~136` | 조회조건 Line Type 과 좁히는 기준이 다르다(행의 `DIVISION_ID`+`OPERATION_ID`) |
| `_defaultDataModel_Changed` — 셀 변경 후속 | cs:3085~3119 (가드 3087~3114) | `components/CapaSpeedPlanGrid.tsx:252~274`, `hooks/useCapaSpeedPlanCellEdit.ts:28~91` | 가드 6건을 순서 그대로 |
| 후속 호출 순서 `CheckEltrEquipmentType` → `RecalcSheet` | cs:3116, cs:3118 | `hooks/useCapaSpeedPlanCellEdit.ts:55~65`, `274~292` | 순서를 바꾸면 잠금 셀에도 자동계산이 돈다 |
| `CheckEltrEquipmentType()` — 설비유형 라인 일괄 동기화 | cs:2946~3083 (`M` 마킹 3075~3080†) | `utils/capaSpeedPlan.editLock.ts:111~128`, `hooks/useCapaSpeedPlanCellEdit.ts:55~65` | 6키 전부 채워진 행에서만 발동. 미세 편차 1건은 ⑧ 참조 |
| `RecalcSheet(rowIdx, colIdx)` — 진입 게이트 | cs:2881~2930 (컬럼 조건 2886~2889, ASSEMBLY 가드 2905, PPM lock 게이트 2914) | `utils/capaSpeedPlan.recalc.ts:124`, `hooks/useCapaSpeedPlanCellEdit.ts:71~82` | PPM 셀이 lock 일 때만 재계산 |
| `RecalcSheet(currRowIdx, qtyColIdx, currMeasure)` — 산식 4종 | cs:2676~2879 (산식 2845~2861) | `utils/capaSpeedPlan.recalc.ts:164~171` | MMS / CPM / PPM_AVG / TTT |
| 0 방어 `eltr_qty==0→1`, `mms_cf==0→1` | cs:2752~2775 (2756~2759, 2768~2771) | `utils/capaSpeedPlan.recalc.ts:161~162` | |
| `decimal.Parse` 실패를 catch 로 삼키고 0 유지 | cs:2742~2744 등 | `utils/capaSpeedPlan.recalc.ts:38~43` | |
| PPM 기입 + 자동 `M` 마킹 | cs:2871~2873 | `hooks/useCapaSpeedPlanCellEdit.ts:83~89` | `EditTracker.storeChange` 경유 — 자체 상태필드 금지 |
| `GetQtyRowIndex()` — 행 오프셋 | cs:2594~2618 | `utils/capaSpeedPlan.recalc.ts:87~100` | 조회 정렬을 바꾸면 계산이 통째로 깨진다(03 V-29) |
| `GetSpeedRowIndex()` / `GetPPMRowIndex()` | cs:2620~2623 / cs:2625~2628 | `utils/capaSpeedPlan.recalc.ts:133~134` | qtyRow+1 / qtyRow+2 |
| `IsModelDummy()` — 더미 모델 스킵 | 정의 cs:2653~2674, 사용 cs:2866~2868 | `utils/capaSpeedPlan.recalc.ts:179~184` | AS-IS 는 `_fixed_column_name`(=`IDX`) 컬럼을 읽는 구현 결함(cs:2661)이라 항상 false. TO-BE 는 의미가 성립하는 `NICK_NAME_DUMMY_YN` 으로 이식했고, GET SP 가 `'N'` 고정 반환이라(03 R-20) **런타임 동등** |
| 편집모드 토글 시 재렌더 | cs:1815~1818 (`SetSheetNumericColumnFormat` + `Set_MeasureColor`) | `components/CapaSpeedPlanGrid.tsx:315~318` | `invalidate(true)` |

---

## ⑤ 저장 · 직렬화 · 응답판정

| AS-IS 요소(메서드/컨트롤) | AS-IS 위치 | TO-BE 위치 | 비고 |
|---|---|---|---|
| `SaveButton()` 가드 3종 | cs:2007~2035 (`fps==null` 2009, `_si==null‖IsLock` 2013, `RowCount==0` 2016) | `hooks/useCapaSpeedPlanSave.ts:136~139` | 가드 2번 = **비편집 상태 저장 차단** (01 L-23) |
| `DataUtil.checkRequiredOfSpread(_si)` | cs:2020 (DataUtil† 라인 확인필요) | `hooks/useCapaSpeedPlanSave.ts:154` (`saveWithValidation`) | 메타 `INPUT_TP_CD='S'` 전건이라 무발동 — ⑧ BLK-10 |
| `SaveData()` 변경 0건 가드 | cs:2402~2417 (`CheckChangedValues` 2406, `MSG00133` 2411) | `hooks/useCapaSpeedPlanSave.ts:142~150` | |
| `CheckChangedValues()` — 변경분 판정 | cs:1841~1882 (끝줄 확인필요) | `utils/capaSpeedPlan.save.ts:36~37` (`pickDirtyRows`) | AS-IS 는 `_tblBeforeChanged` 스냅샷 대조, TO-BE 는 공용 `EditTracker` 가 찍은 `CRUD_TYPE` |
| `SetQueryInfoSave()` — SAVE payload 직렬화 | cs:2261~2352 | `utils/capaSpeedPlan.save.ts:50~107` | |
| SAVE QueryId 조립 (2변형) | cs:2273 | `hooks/useCapaSpeedPlanSave.ts:76` | `/${MENU_ID}/${sheetName}/SAVE/call-proc` |
| 행 구분자 `^` / 기간 구분자 `;` | cs:2295~2325† | `capa-speed-plan.constants.ts:250~251`, `utils/capaSpeedPlan.save.ts:84~91` | trailing delimiter 유지 — join 으로 바꾸면 SP 파싱이 깨진다 |
| `p_electrode_type` = **행의** `ELTR_LN_TP_CD` | cs:2304† | `utils/capaSpeedPlan.save.ts:69` | GET 의 동명 파라미터와 의미가 다르다 |
| `PFRSLT_QTY` 는 수집만 하고 미전송 | cs† 라인 확인필요 | `utils/capaSpeedPlan.save.ts:60~75` (부재) | 저장 대상 아님 |
| `*_ASSIGN_PRIORITY` 전송 제외 | cs:2316† | `utils/capaSpeedPlan.save.ts:86` | `periodColumnNames` 가 이미 제외한 목록 |
| `p_sheet_name` | cs:2346 | `utils/capaSpeedPlan.save.ts:102` | |
| `p_user_id` | cs:2253 (GET 기준) | `utils/capaSpeedPlan.save.ts:104` | 빈 문자열 금지(convert-core §2.5) |
| `SaveDataMain()` — SAVE → GET 연쇄 | cs:2392~2400 (2394~2399) | `hooks/useCapaSpeedPlanSave.ts:116` (`activeQuery.refetch()`) | `filters` 가 그대로라 refetch 가 맞다 |
| `AfterSaveData()` — 응답 판정 | cs:2156~2224 (끝줄 확인필요) | `utils/capaSpeedPlan.save.ts:127~159`, `hooks/useCapaSpeedPlanSave.ts:60~129` | `result_code='S'` 단일행 = 성공 / 실패는 결과셋 2개 |
| 저장 실패 `[50426]` 파싱 | 결과셋 기반 — cs 라인 확인필요 | `utils/capaSpeedPlan.save.ts:127~159`, `constants.ts:273` | TO-BE `SCM_ADM_MSG_M` 등가 0건(실측) → 서버 원문 표면화 |
| HTTP/CODE 축 선판정 | AS-IS 대응 없음 | `hooks/useCapaSpeedPlanSave.ts:80~88` | 인터셉터가 500/CODE!=0 도 resolve 하므로 false-success 차단 |
| 저장 성공 메시지 `MSG00004` | cs† 라인 확인필요 | `capa-speed-plan.constants.ts:267` (`MSG00672`), `hooks/useCapaSpeedPlanSave.ts:105~112` | TO-BE `MSG00004` 는 뜻이 뒤집힌다 |
| 저장/조회 성공 시 `IsEditMode=false` (01 L-27) | cs:2097~2100 (`AfterFindData`), cs:2167~2169† (`AfterSaveData`) | `hooks/useCapaSpeedPlanSave.ts:115`, `useCapaSpeedPlanStore.ts:213`·`236` | 병합도 함께 복원된다 |
| 저장 중복 실행 차단 | AS-IS 대응 없음 | `hooks/useCapaSpeedPlanSave.ts:57`·`62`·`73`·`126` (`savingRef`) | TO-BE 고유 |

---

## ⑥ 버튼 · 가드 · 레이아웃

| AS-IS 요소(메서드/컨트롤) | AS-IS 위치 | TO-BE 위치 | 비고 |
|---|---|---|---|
| `FindButton()` (F5) | cs:1455~1461 | `CapaSpeedPlan.tsx:169~175`, `404` | `refetch()` 직접 호출 금지 — `filters` 참조 교체가 곧 재조회 |
| `EditButton()` 가드 4단 | cs:1778~1819 (`spdMain==null` 1780, `_si==null` 1783, `GetMaxRowIndex()<0` 1786, 상태차단 1789~1794) | `CapaSpeedPlan.tsx:186~204` | 판정 시점은 Load 가 아니라 **Edit 클릭 시점** |
| Edit 차단 메시지 `MSG00109` | cs:1791 | `capa-speed-plan.constants.ts:265`, `CapaSpeedPlan.tsx:196~202` | |
| Edit 차단 대상 상태 `-`/`1`/`2` | cs:1789 | `capa-speed-plan.constants.ts:125~129` | Current 버전만 편집 |
| `_si.SwitchLock()` — 편집모드 토글 | cs:1807 | `CapaSpeedPlan.tsx:203`, `useCapaSpeedPlanStore.ts:255~258` | |
| Edit 버튼 노출 | AS-IS 툴바 F2 | `CapaSpeedPlan.tsx:272~286` (`customButtons`) | 공용 `Hotkeys` enum 에 `edit` 키가 없다 → `customButtons` 로 노출(자매 SCP0114 동일) |
| `InsertButton()` (빈 구현) | cs:1463~1465 | `CapaSpeedPlan.tsx:212`, `405` | ⑧ BLK-6 |
| `DeleteButton()` 가드 3종 + 신규행만 제거 | cs:1821~1839 (가드 1823·1826·1829, `FlagI` 판정 1835~1838) | `CapaSpeedPlan.tsx:219~227`, `406` | 행 추가가 없으므로 실질 무동작. **기존 행이 지워지지 않는 것이 핵심**(03 R-27) |
| `SaveButton()` | cs:2007~2035 | `hooks/useCapaSpeedPlanSave.ts:135~155`, `407` | ⑤ 참조 |
| `btnColumn` (조회영역 우측 아이콘) | dsn:623~633† (확인필요), cs:3166~3175 | `CapaSpeedPlan.tsx:272~293` | 공용 `IcGridColumnSetup` 아이콘으로 이동(01 §2-G). 라벨 `LBL00605` 재사용 |
| `btnItemId` | dsn:718~732†, cs:3156~3164 | `components/CapaSpeedPlanForm.tsx:336~343` | `popupSearchField` 한 덩어리(hook #121) |
| Excel / Upload / Manual | AS-IS 대응 기능 없음 | `CapaSpeedPlan.tsx:262~263` (false), `313` (excelFileName) | Excel 은 공용 SubTitle 기본 제공 |
| 버튼 권한 게이트 (`CanUpdate`, `MSG00096`) | BaseForm:3666~3673† (01 L-12) | `CapaSpeedPlan.tsx:53`·`254~261`·`269`, `constants.ts:266` | `useTabBtnPermissions().hasButton()` 경유 의무 |
| `usrConditionPanel1` / `usrLayoutControl2` — 조회영역 | dsn:132~166† | `CapaSpeedPlan.tsx:302~309`, `components/CapaSpeedPlanForm.tsx:69~73` | 공용 `SearchArea` |
| 조회영역 접기 토글 | `usrConditionPanel1` — cs 라인 확인필요 | `CapaSpeedPlan.tsx:297~302`, `useCapaSpeedPlanStore.ts:118`·`260~263` | |
| `layoutControlGroup2` 12-column 배치 | dsn:663~689† | `components/CapaSpeedPlanForm.tsx:73~351` | `conditions` 9필드(2단) + `extraConditions` 4필드(3단) |
| 필드 배치 순서 | dsn — `LayoutControlItem.Location` 과 `Control.Location` 이 상충 | 확인필요 | 정적 소스로 확정 불가. 02 §1 인벤토리 순서 채택(goal BLK-5, 04 리포트 확인필요) |
| 화면 제목 / 건수 표시 | BaseForm† | `CapaSpeedPlan.tsx:297~302`, `312` | |
| 라우트 | AS-IS 메뉴 트리 | 폴더 배치 + DB `ROUTE_PATH='supply/capa-speed-plan'`, `index.ts:1` | |

---

## ⑦ 이식하지 않은 것 (데드코드 · 잔재 · 무발동)

전건 열거한다. **"나중에 하려고 뺀 것"이 아니라 AS-IS 에서 이미 죽어 있어 옮기지 않은 것**이다.

| AS-IS 요소 | AS-IS 위치 | TO-BE | 미이식 사유 |
|---|---|---|---|
| `fpSpread1` (FpSpread) | dsn:72, 993~1000, 1079 | 없음 | Designer 노드만 존재하고 code-behind 참조 0건. 실제 그리드는 `spdMain`. 설계 03 C-10 / 01 §1.1 #21 |
| `usrLayoutControl1` | dsn:32, 108~116, 1051 | 없음 | `Controls.Add(this.usrLayoutControl1)` grep 0건 — Form 에 붙지 않는 사장 노드. 01 L-06 |
| `layoutControlGroup1` | dsn:33, 118~124, 1052 | 없음 | `usrLayoutControl1` 의 Root 라 함께 사장. `Items.AddRange` 0건. 01 L-07 |
| Designer 초기 시트 `spdMain_Sheet1` | dsn:953~991† | 없음 | 런타임 `AddSheet` 2건(cs:1302·1303)으로 대체된다 |
| `dtFromYYYY` (`YearFromThisYear_SCP_ALL`) | cs:73 | 없음 | 선언 1건 외 참조 0건(grep 실측). 02 §2.6 / F-25 |
| `dtYesOrNo` (`YesOrNo`) | cs:74 | 없음 | 선언 1건 외 참조 0건(grep 실측). 02 §2.6 / F-25 |
| `cboFromYYYY_SelectedIndexChanged` | cs:2531~ (끝줄 확인필요) | 없음 | 짝이 되는 컨트롤 `cboFromYYYY` 가 Designer 에 없고 `InitEvent`(cs:1401~1418) 배선 13건에도 없다. 정의만 남은 데드 핸들러 |
| `spdMain_Change` | cs:2933~2943 | 없음 | `InitEvent` 배선 0건(grep 실측 — 정의 1건뿐). 실제 경로는 `_defaultDataModel_Changed`(cs:3085) |
| `SetBaseToDateColumns()` | 정의 cs:2555~2592, 호출부 cs:2893·2922·2926 | 없음 | 호출부 3건이 **전부 주석**이라 런타임 미발동. BASE 값의 기간열 전파 없음이 현행 동작. 03 R-17 |
| `IsDummy()` | 정의 cs:2630~2651, 유일 호출부 cs:2805 | 없음 | 호출부가 블록주석 `/* */`(cs:2804~2841) 내부라 미발동. 살아 있는 더미 판정은 `IsModelDummy`(cs:2866) 하나뿐. 03 R-19 |
| `BASE_EDITABLE_YN` 개별 잠금 | cs:1495·1523·1528·1530 | 없음 | 선언은 살아 있으나 읽기·판정·`SetLockCell` 3줄이 전부 주석. `BASE_QTY` 개별 잠금을 걸면 AS-IS 와 달라진다. 03 R-07 |
| `IsExistsDifferentEquipmentType()` | cs:1884~1918 | 없음 | 유일 호출부인 `SaveButton` 내부가 주석(cs:2023~2031). 03 R-29 |
| `GetExistsDifferentEquipmentType()` | cs:1920~2005 | 없음 | 위 함수의 하위. 함께 미발동. 서버 SAVE 의 `50426` 오류가 실질 대체 경로다 |
| `SaveButton` 의 `MSG00426` 클라 사전검증 | cs:2023~2031 (주석) | 없음 | 위 2건과 동일 블록. TO-BE 는 서버 응답의 `50426` 만 다룬다(`save.ts:148~157`) |
| `SetSheetNumericColumnFormatELTR()` | cs:1744~1776 (키 cs:1756·1764†) | 없음 | AS-IS 가 키를 `EQP_QTY` 로 넣는데 실제 measure 는 `EQP_SPED` 라 매칭 0건 = 사실상 미적용. 현행 동작 재현이라 ELTR 자릿수 맵을 두지 않는다. 03 C-06 (`EQP_SPED` 로 고칠지는 04 리포트 백로그) |
| `Insert_Row()` | cs:2367~2390 | 없음 | 호출부 0건(grep 실측). `InsertButton()` 이 빈 구현이라 도달 불가. 03 R-15 |
| `ReadOnlySheetList.Add(SHEETS.ASSEMBLY)` | cs:1239 | 없음 | BaseForm 이 이 목록으로 하는 일은 **필터 해제 스킵**뿐이고 시트를 읽기전용으로 만들지 않는다(01 L-18 정정). Wijmo 에 등가 개념 없음 |
| `DataUtil.checkRequiredOfSearch(this.Controls)` | cs:1457 (DataUtil.cs:67~92†) | 없음 | 이 화면은 `Required` 지정 0건 / 라벨 `*` 0건이라 실질적으로 Division 권한 게이트로만 동작한다. Search 전 필수 alert 를 **신설하면 AS-IS 위반**. 02 F-21 |
| `EditButton` 의 `_progress_status < _currVersionProgressStatus` 재검사 | cs:1796~1804 (주석) | 없음 | 주석 상태. 현행 차단 조건은 cs:1789 한 줄뿐 |
| `_si.LockColumn(...)` 2줄 | cs:1810~1811 (주석) | 없음 | 주석 상태 |
| `_isCellClipboardPaste` 붙여넣기 가드 | cs:3107~3108 (주석) | 없음 | 주석 상태. TO-BE 는 `pastingCell` 로 **잠금 셀 붙여넣기만** 차단한다(`CapaSpeedPlanGrid.tsx:201~218`) |
| `spdMain.TabStripPolicy = Never` | cs:1339 | 없음 | 시트 탭 UI 자체를 만들지 않으므로 숨길 대상이 없다 |
| `2ND_CUTOFF` GET SP 변형 | cs:552~573 (`'2'` 분기 없음) | `constants.ts:136` (빈 문자열) | AS-IS `_sheet_status` 에 `'2'` 분기가 없고 Status 콤보에서도 제외돼 도달 불가. 03 C-09 |
| Item 팝업 다중선택 / `OPERATION_GROUP` 필터 | cs:3130 (`pop.Init(multiSelect=true, dtDivision, _division, _shop_group, _item_id)`), cs:3140·3146 | 이식 완료(iter-2) — `CapaSpeedPlan.tsx` 팝업 배선 + `features/supply/src/components/CapaItemPopup.tsx` | 공용 컴포넌트를 **기본값 보존 prop**(`multiSelect=false` / `operationGroup?`)으로 확장했다(설계 02 §4.6 이 지정한 convert-core §2.2 예외 절차). SCP0105 는 `multiSelect` + `operationGroup={SHOP_GROUP_ID[divisionType]}` 를 넘기고 선택 전건을 `,` 로 잇는다. `OPERATION_GROUP` 은 AS-IS 와 동일하게 **조회 후 클라 필터**(팝업 SP 에 shop group 파라미터가 없다). **사본 0건**, SCP0104 호출부 3곳은 prop 미전달이라 동작 불변 |

---

## ⑧ 사용자 결정으로 AS-IS 와 의도적으로 달라진 축 (2026-09-23 확정)

아래 4건은 버그가 아니라 **확정된 설계 결정**이다. 재판단·재수정 금지.

| 축 | AS-IS 실측 | TO-BE 채택 | AS-IS 위치 | TO-BE 위치 | 결정 근거 |
|---|---|---|---|---|---|
| **BLK-4** DivisionType 초기값 | Designer 가 `SelectedIndex` 를 세팅하지 않아 DevExpress 기본 `-1`(무선택). 그 상태의 파생값이 `_sheet_idx=1`(ELTR)인데 `_shop_group='P'`(Module/Pack) 라 **비정합** | `Cell` (시트 ASSEMBLY / shop group `'A'`) = 정합 상태 | dsn:609~621 (`SelectedIndex` 세팅 0건), cs:1283~1296, `constants.ts:57~61` 대응 | `capa-speed-plan.constants.ts:47~54`, `useCapaSpeedPlanStore.ts:98` | 사용자 확정 2026-09-23 (goal.md §5-6 BLK-4). 02 §4.2 |
| **BLK-6** INSERT 버튼 | `InsertButton()` 본문이 빈 구현. 버튼은 툴바에 존재 | 메타에 `MNU_BTN_CD='INSERT'` 등록 + **명시적 무동작** `() => undefined` | cs:1463~1465 | `CapaSpeedPlan.tsx:206~212`, `405` | 키를 생략하면 공용 SubTitle 의 기본 `addRow` 가 살아나 AS-IS 에 없던 행 추가가 생기고, `false` 면 버튼이 사라져 시각적으로 달라진다 — 둘 다 오답. 사용자 확정 2026-09-23 (goal.md BLK-6) |
| **BLK-7** Measure 행 배경색 | 코드는 `Color.FromArgb(220,220,220)` 으로 칠하고, DB 메타 `SCM_MST_SHEET_MEASURE.MEASURE_COLOR` 는 `192,192,192` 다. 코드가 메타를 쓰지 않으므로 **런타임 표시색은 220** | 코드값 `220,220,220` 채택. 메타는 고치지 않는다 | cs:2135 | `components/CapaSpeedPlanGrid.module.scss:5~7`, `constants.ts:210~213` | 사용자 확정 2026-09-23 (goal.md §5-6 BLK-7). 03 R-12 / C-04 |
| **BLK-10** 필수검증 무발동 | `checkRequiredOfSpread` 는 호출되지만 메타 `INPUT_TP_CD` 가 63행 전건 `'S'`(SEARCH_ONLY) 라 필수검사가 한 건도 발동하지 않는다 | **파리티 유지**. 배선만 표준대로(`saveWithValidation`) 걸고, 메타 정정이나 코드로 강제 발동을 하지 않는다 | cs:2020 | `hooks/useCapaSpeedPlanSave.ts:151~154`, `components/CapaSpeedPlanGrid.tsx:200~203` | 사용자 확정 2026-09-23 (goal.md BLK-10). 03 C-07 |

### 사용자 결정 외 — 판단 근거를 남긴 의도적 미세 편차 3건

| 축 | AS-IS | TO-BE | AS-IS 위치 | TO-BE 위치 | 근거 |
|---|---|---|---|---|---|
| 설비유형 동기화 시 `M` 마킹 범위 | 값이 **이미 같은 행에도** SetText 후 `'M'` 을 찍는다 | 값이 같으면 건너뛴다 | cs:3075~3080† | `utils/capaSpeedPlan.editLock.ts:124` | 같은 값 행까지 `'M'` 으로 만들면 `EditTracker` 가 원복으로 지울 수 없는 마킹이 남아(자체 CRUD 세팅 = convert-core §2.4 위반) 사용자가 되돌릴 길이 없어진다. 저장되는 **값**은 동일, 저장 건수만 AS-IS 이하 |
| `*_ASSIGN_PRIORITY` 숨김 방식 | 컬럼을 만들고 폭0 + `Resizable=false` | 컬럼 자체를 만들지 않는다(행 데이터는 유지) | cs:1388~1393 | `utils/capaSpeedPlan.dateColumns.ts:68~70` | Wijmo 는 폭0 컬럼도 우클릭 Filter/Sort/Hide 목록과 컬럼설정 모달에 노출해 03 R-03 취지가 깨진다 |
| `IsModelDummy` 판정 컬럼 | `_fixed_column_name`(= `IDX`) 컬럼을 읽는 구현 결함 → 항상 false | `NICK_NAME_DUMMY_YN` 을 읽는다 | cs:2661 | `utils/capaSpeedPlan.recalc.ts:180` | ASSEMBLY GET SP 가 `NICK_NAME_DUMMY_YN` 을 `'N'` 리터럴로 고정 반환해(03 R-20) **어느 쪽으로 읽어도 이 분기는 발동하지 않는다** = 런타임 동등. 의미가 성립하는 쪽으로 이식 |

---

## 확인필요 (라인 미확정 또는 판단 보류)

| # | 항목 | 상태 |
|---|---|---|
| 1 | 조회영역 필드 배치 순서 | Designer 의 `LayoutControlItem.Location` 과 `Control.Location` 이 서로 다른 행 배정을 줘 정적 소스만으로 확정 불가. 02 §1 인벤토리 순서 채택 (goal BLK-5) |
| 2 | 3단 헤더 그룹 조립 AS-IS 라인 | `SheetUtils.SetSheetHeaderColumnSCP` 내부 — 공용 파일 미개봉 |
| 3 | 컬럼 개인화 적용 AS-IS 라인 | 공용 `SheetUtils` / `SCM002_CAPAColumnPopup` 내부 — 미개봉 |
| 4 | `CheckChangedValues()` 끝줄 | cs:1841 시작은 확정, 끝줄 미확인 |
| 5 | `AfterSaveData()` 끝줄 | cs:2156 시작은 확정, 끝줄 미확인 |
| 6 | `cboFromYYYY_SelectedIndexChanged` 끝줄 | cs:2531 시작은 확정, 끝줄 미확인 (데드코드라 영향 없음) |
| 7 | `PFRSLT_QTY` 미전송 / `^`·`;` 직렬화 / `p_electrode_type` AS-IS 라인 | `SetQueryInfoSave`(cs:2261~2352) 범위 안이라는 것은 확정. 설계 03 인용 라인(2295~2325, 2304, 2316)은 원소스 대조 미완 |
| 8 | 저장 실패 `[errno]message` 결과셋 구조의 AS-IS 라인 | `AfterSaveData` 내부 — 범위 미특정 |
| 9 | `btnColumn` Designer 라인 | dsn:623 부터 시작하는 것은 확인, 끝줄 미확정 |
| 10 | `dsn:` 로 표기한 컨트롤 블록 중 `†` 표시분 | 설계 01 인용값. `rgrpDivisionType`(609~621) / `fpSpread1`(993~1000) / `usrLayoutControl1`(108~116) / `layoutControlGroup1`(118~124) 은 본 회차 직접 확인 완료 |
| 11 | 기간 셀 잠금의 `_progress_status == CURRENT` 전제 | AS-IS 는 우선순위 기반 기간열 lock 루프를 `_progress_status == _CURRENT` 일 때만 돈다(cs:1533, cs:1641). TO-BE `isCellEditable` 은 이 조건을 직접 보지 않고 Edit 진입 게이트(`currVersionProgressStatus`)로만 막는다. 두 값은 서로 다른 축이라 **선택 Status 와 버전 현재상태가 어긋나는 조합에서 판정이 달라질 수 있다** — 런타임 대조 필요(`PKG_SCP0105` 배포 후) |
| 12 | `MSG00426` 등가 TO-BE 메시지 | `SCM_ADM_MSG_M` 역조회 0건(ora.py 실측 2026-09-23). 채번 대기 — 04 리포트 |
| 13 | ~~Item 팝업 다중선택 / `OPERATION_GROUP` 필터~~ | **iter-2 에서 해소**(공용 컴포넌트 기본값 보존 prop 확장). 남은 것은 팝업 실조작 런타임 확인(사용자 축) |
| 14 | `Module/Pack` 라벨 채번 | `SCM_ADM_MSG_M` 에 정확 매칭 LBL 없음(LBL00378 'Sub Module' / LBL00379 'Module' 뿐). 영문 표기 유지 (goal BLK-9) |

---

## 커버리지

> 줄 수는 **2026-09-25 `gap-resolve` iter-1 종료 시점 실측**(`wc -l`)이다.
>
> **라인 인용은 시점 정보다.** iter-3 리팩터(Page 541->343행, 저장/셀편집/조건effect/모달 분리) 이후
> 좌표가 통째로 밀려 이번 회차에 본문 인용 **76건 + 재anchor 34건 + 범위초과 3건**을 정정했다.
> `asis_mapping_gate.py --citations` 는 **파일·심볼 존재만** 보고 라인 번호는 검증하지 않으므로,
> 파일을 편집한 회차는 아래를 함께 돌려 범위초과(파일 총행수 초과)를 잡아야 한다:
>
> ```bash
> py -3 .atlas/private/agent/scratch/check_mapping_citations.py   # 인용 348건 / 범위초과 0 이어야 통과
> ```
>
> 범위 안이지만 대상이 어긋난 드리프트(off-by-N)는 이 검사로 잡히지 않는다 — 코드를 고친 파일의
> 인용은 앵커(함수명·prop 명)로 표본 대조할 것.

| TO-BE 파일 | 줄 수 | 본 문서에서 다룬 절 |
|---|---|---|
| `CapaSpeedPlan.tsx` | 346 | ①②③④⑤⑥⑧ |
| `capa-speed-plan.constants.ts` | 280 | ①②③④⑤⑥⑧ |
| `capa-speed-plan.types.ts` | 107 | ②③ |
| `useCapaSpeedPlanStore.ts` | 342 | ①②③⑤⑥ |
| `components/CapaSpeedPlanForm.tsx` | 357 | ①②⑥ |
| `components/CapaSpeedPlanGrid.tsx` | 355 | ①③④⑧ |
| `components/CapaSpeedPlanGrid.module.scss` | 7 | ③⑧ |
| `components/CapaSpeedPlanColumnModal.tsx` | 68 | ①③ |
| `components/CapaSpeedPlanItemPopup.tsx` | 46 | ② |
| `hooks/useCapaSpeedPlanCombos.ts` | 302 | ①② |
| `hooks/useCapaSpeedPlanCellEdit.ts` | 94 | ④ |
| `hooks/useCapaSpeedPlanSave.ts` | 158 | ⑤ |
| `hooks/useCapaSpeedPlanConditionEffects.ts` | 111 | ①②③ |
| `utils/capaSpeedPlan.combos.ts` | 410 | ② |
| `utils/capaSpeedPlan.dateColumns.ts` | 138 | ①③⑧ |
| `utils/capaSpeedPlan.editLock.ts` | 128 | ④⑧ |
| `utils/capaSpeedPlan.editLock.test.ts` | 163 | ④ (단위테스트 13건) |
| `utils/capaSpeedPlan.recalc.ts` | 193 | ④⑧ |
| `utils/capaSpeedPlan.recalc.test.ts` | 168 | ④ (단위테스트 17건) |
| `utils/capaSpeedPlan.combos.test.ts` | 173 | ② (단위테스트 14건) |
| `utils/capaSpeedPlan.save.ts` | 159 | ⑤ |
| `index.ts` | 1 | ⑥ |
