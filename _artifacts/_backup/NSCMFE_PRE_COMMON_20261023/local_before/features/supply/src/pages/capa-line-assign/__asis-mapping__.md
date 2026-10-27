# SCP0104 CAPA Line Assign — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0104_CAPA_Line_Assign/SCP0104_CAPA_Line_Assign.cs`(6,107줄) + `.Designer.cs`
> 부속 Form: `SCP0104_CAPA_Line.cs`(P03) · `SCP0104_CAPA_Line_Assign_Model.cs`(P02) · `GSCM.SCM.Popup.UIL/SCM0002_CAPAItemPopup.cs`(P01)
> 설계 근거: `.atlas/gscm-design/SCP0104/design/00_checklist.md`(백본 214행) · `01_layout.md`(R-01~R-33) · `02_search-combo.md`(S01~S15 / D01~D10 / V-01~V-27) · `03_grid-columns.md`(C·D·E·S·A·B 51 체크포인트)
> TO-BE: `nscm-fe/features/supply/src/pages/capa-line-assign/`
> 작성: convert-react iter-1 (2026-09-23) · **갱신: iter-3 (2026-09-23)** — iter-2·iter-3 변경분 반영(GAP-17)

---

## 0. 커버리지 요약 (정직 보고 — convert-core §4.3)

| 축 | 기준 n | 매핑 | 미매핑/부분 | 판정 |
|---|---:|---:|---:|:--:|
| 영역1 layout 규칙 R-01~R-33 | 33 | 31 | 2 (R-24·R-25 = 의도적 미이식) | PASS |
| 영역2 조회조건 S01~S15 | 15 | 14 | 1 (S13 팝업 버튼 = S12 에 통합) | PASS |
| 영역2 콤보 D01~D10 | 10 | 8 | 2 (D03·D10 = 의도적 미호출) | PASS |
| 영역3 gridSignals G01~G48 | 48 | 44 | 4 — **ID 단위 열거 미완(아래 주의)**. iter-2 에서 X-F 폭복원·Dummy 채번 2건 해소 | 부분 |
| validations V01~V05 | 5 | 5 | 0 | PASS |
| buttonGuards B01~B38 | 38 | 33 | 5 — **ID 단위 열거 미완(아래 주의)** | 부분 |
| 팝업 P01~P04 | 4 | 4 | 0 (**iter-3 에서 P01 다중선택 해소** — §7 6-1) | PASS |

> **"부분" 은 완료가 아니다.** 구체 항목·사유는 아래 각 표의 `판정` 열과 §7 잔여에 적혀 있고,
> `design/04_react-gap.md` 의 gap 표가 그 단일 출처다.
>
> ⚠ **주의 — 미매핑 9건(gridSignals 4 + buttonGuards 5)의 ID 단위 열거가 이 문서에 없다.**
> 독립 감사(2026-09-23 gap-resolve iter-1 절차 6, 항목 A07)가 지적한 결함이며 사실이다. 종전 문구는
> "아래 §4 표에 사유 명기" 였으나 **§4 는 validations 표**여서 포인터 자체가 틀렸고, §3 은 17개
> **축 단위** 표라 G/B 개별 ID 를 담지 않는다. `§4b` 도 B01~B38 을 9개 **그룹 범위**로만 적어
> "해당없음" 그룹 `B04~B09`(6항목)와 미매핑 수치 5 가 맞지 않는다.
> 해소 절차(다음 회차 R1): `design/03_grid-columns.md` §3 의 gridSignals 48행과 `00_checklist.md`
> §4d buttonGuards 38행을 **ID 단위로 전개**해 각 행을 TO-BE `file:line` 으로 대사하고, 미매핑으로
> 남는 행만 ID·사유와 함께 §7 에 올린다. 그때 위 카운트(44/48, 33/38)도 재산출해 맞춘다.
> **이 열거가 끝나기 전에는 영역3·buttonGuards 축을 "PASS" 로 올릴 수 없다.**

---

## 1. 영역1 — 레이아웃·모드 (01_layout.md R-01~R-33)

| # | AS-IS 근거 | AS-IS 동작 | TO-BE 구현 위치 | 판정 |
|---|---|---|---|:--:|
| R-01 | cs:5540-5554 `rgrpDivisionType_SIC` | 모드 전환 시 두 탭 전면 초기화 7단 | `useCapaLineAssignStore.changeDivisionType` + `CapaLineAssign.tsx` divisionType effect(컬럼메타 재fetch·queryClient.removeQueries) | 구현 |
| R-02·R-03 | cs:2117-2154 `Sheets[i].Visible` | 4시트 중 모드별 1시트만 표시 | `ASSIGN_SHEET_BY_DIVISION_TYPE` / `SOP_SHEET_BY_DIVISION_TYPE` — 시트를 동시에 만들지 않는다 | 구현 |
| R-04 | cs:5556-5566 `SetVisibleOperation` | **Cell·Module-Pack 만 Operation 노출**(ELTR 은 Never 로 숨김) | `CapaLineAssignForm.tsx:242` `{!isEltr && multiField(Operation…)}` (iter-2 정정 — iter-1 은 방향이 반대였다, GAP-03) | 구현 |
| R-05 | cs:5568-5584 `SetVisibleElectrodeType` | Line Type 도 **R-04 과 같은 방향**(ELTR 에서 둘 다 숨김. design 01 R-05 2026-09-23 정정본) | 동 파일 `{!isEltr && multiField(Line Type…)}` — 별 FormItem 2개. 숨겨질 때 값도 비운다(U-3 / store `changeDivisionType`) | 구현 |
| R-06 | cs:5572·5579 / ScpCapa.cs:50-54 | Item 라벨 `Basic Nickname`↔`Model` | 동 파일 `t(isEltr ? LBL.MODEL : LBL.BASIC_NICKNAME)` (LBL00669/LBL00054 실측) | 구현 |
| R-07 | cs:1523-1524·1717·1732 | 표시/라벨 재평가 트리거가 조건변경 전반 | React 파생 렌더라 자동 충족(재평가 관리 불필요) — React 파생 렌더라 자동 충족(별도 재평가 관리 불필요) | 구현 |
| R-08 | cs:197-210 `isPageSOP` | 5액션·고정컬럼이 탭으로 갈림 | `activeTab` 로컬 state + 전 핸들러 분기 + SubTitle `grid/gridFilter/dataCount` 삼항 | 구현 |
| R-09 | Designer:949-1020 | 탭 2개, SOP 만 상단 panel1 | `TabWrapper persist` + `TabItem` ×2 (panel1/btnSopNew 는 R-13 으로 흡수) | 구현 |
| R-10 | cs:4078-4125 | Edit 이 탭별로 다른 시퀀스 | `handleEdit` 분기 + Assign 분기에서 `useInvalidateCombos`(=`RefreshSpreadAll` 등가) | 구현 |
| R-11 | Designer grep 0건 / cs:2192-2221 | **탭 전환이 아무것도 트리거하지 않는다** | 탭 전환 effect 를 두지 않았다(hook #81 lazy-fetch 미도입) — hook #81 lazy-fetch 의도적 미도입(AS-IS 에 없는 자동조회 금지) | 구현 |
| R-12 | cs:4078-4125 `IsEditModes` | 편집모드 토글 | store `editMode: Partial<Record<GridSheet, boolean>>` + `setEditMode` | 구현 |
| R-13 | cs:2223-2236 `btnSopNew` 3가드 | SOP 전용 New 버튼 + 3가드 조용한 return | **버튼 미생성(U-1)** — `handleInsert` SOP 분기에 `!sopGridRef.current` / `!editMode[sopSheet]` 재현 — U-1 확정에 따른 재설계(전용 버튼 → SubTitle INSERT 라우팅) | 구현 |
| R-14·R-15 | cs:4093·4115 `SwitchLock` | 시트 잠금 토글 + 행별 차등 | `capaLineAssign.editLock.ts` — `beginningEdit`(e.cancel)와 `formatItem`(배경) 둘 다 같은 판정 함수 | 구현 |
| R-16·R-17 | cs:4495-4553 | 조회 직후 전 컬럼 잠금 + 편집모드 해제 | `CapaLineAssign.tsx` query.data effect → `clearChanges()` + `setEditMode(false)` | 구현 |
| R-18 | cs:4082·4103 | ref 미준비 시 조용한 return | `handleEdit` 첫 줄 `if (!grid) return;` | 구현 |
| R-19·R-20·R-21 | cs:4085-4111 / 1568-1608 | 컷오프(`PROG_STAT` 1·2) 편집 차단 + `'-'` 승격 | `handleEdit` 앞단 `CUTOFF_PROG_STATS.includes(progStat)` → `MSG00109`. 승격은 **재현하지 않는다**(차단목록 등가) | 구현 |
| R-22 | cs:1965-1966 `SetDivisionAuthCheck` | Division 0건 → 조회조건 100% 비활성 + 안내 | `useCapaLineCascade.hasDivisionAuth` → Form 전 필드 `disabled` + 1회 `MSG00667`. **`MSG00097` 재사용 금지**(TO-BE 문구가 다름) | 구현 |
| R-23 | BaseForm:3603-3849 ACL | 5액션 사전 ACL 검사 후 MSG00096 | `useTabBtnPermissions().hasButton()` 곱셈 — 버튼 숨김 구조 대응(메시지 불필요) — 메시지형 ACL 을 버튼 숨김 구조로 대응(hook #63) | 구현 |
| R-24·R-25 | BaseForm:3675-3710 / 5271-5656 | Sort 중 편집 금지 3종 메시지 | **의도적 미이식** — FarPoint 인덱스 회피용 제약이고 Wijmo 는 공존 가능. 화면이 공용 F3/F4 를 무력화하면 hook #63 위반 | 미이식(규범 판단) |
| R-26 | cs:1963 `ReadOnlySheetList` | `SetFilterALLCancel` 제외 목록일 뿐 | TO-BE 구현 대상 없음(오독 주의 — ASSEMBLY 편집을 막으면 AS-IS 와 달라진다) | 해당없음 |
| R-27 | cs:3879 `checkRequiredOfSearch` | ① Division 권한 재검사 ② `*` 필수검사 | ①은 R-22 로 흡수. ②는 **`*` 라벨 0건이라 사문화** → 구현하지 않는다 / ②는 `*` 라벨 0건이라 AS-IS 에서 사문화 → 미구현이 정답 | 구현 |
| R-28·R-30 | Designer:141-147·645-672 | HidePanel + 3단 조건 그룹 | `MainTitle.openSearchArea` + `SearchArea conditions/extraConditions` | 구현 |
| R-29 | Designer:123-137 | `usrLayoutControl1` 고립 노드 | **폐기** — 빈 래퍼 div 로 이식하지 않았다(hook #132) | 해당없음 |
| R-31 | screen-analysis `extractionLimits` | 분석기 매핑 공백 | 설계 문서 §1.3 노드 대응표가 메움 — 분석기 한계 기록 항목이라 구현 대상이 아니다 | 해당없음 |
| R-32 | cs:5621·6006·6037·5691·6092 | 미배선 핸들러 5종 | `cboFromYYYY`(U-5 제외) / `btnAddVersion`(U-2 제외) / `btnTest`(잔재) — 전부 미이식 — U-2·U-5 사용자 확정으로 전환 범위에서 제외 | 제외 |
| R-33 | cs:211-247·4048 | **AS-IS 잠재 결함** `_fixed_column_idx` 교차참조 | **교정**(U-4) — §5 참조 — §5 K-20-a 로 교정(U-4 확정) | 구현 |

---

## 2. 영역2 — 조회조건 (02_search-combo.md)

| AS-IS 컨트롤 | 라벨/LBL | TO-BE | SP 파라미터 | 판정 |
|---|---|---|---|:--:|
| `cboDivision`(S01) | Division / LBL00641 | `CapaLineAssignForm` singleField + `Division_SCP`(@mnuId) + **클라 `ATTRIBUTE3<>'EE'`** | `p_division_id` | 구현 |
| `cboVersion`(S02) | Plan Month / LBL00053 | `CapaVersion_SCP_ALL` 1회 조회의 클라 파생(`useCapaLineCascade.verIdOptions`) | `p_version` | 구현 |
| `cboVersionSeq`(S03) | Version / LBL00606 | 동일 rows 재사용(추가 조회 없음) | `p_version_seq` | 구현 |
| `txtPlanType`(S04) | Plan Type / LBL00040 | readOnly `InputField` + `BIZ_PLAN_USE_YN==='Y'?'BP':'RP'` | — | 구현 |
| `rgrpDivisionType`(S05) | (라벨 없음) | `CustomDropdown` 3옵션(RadioGroup 부재, SCP0114 선례). `Module/Pack` 은 LBL 미등록 → 영문 defaultValue | — (`p_sheet_name` 파생) | 구현 |
| `clbSite`(S06) | Site / LBL00015 | 마스터 파생 distinct + `DIVISION_ID IN && CODE<>'-'` + `DMY_` 후순위 | `p_site_id` | 구현 |
| `clbPlant`(S07) | Plant / LBL00030 | `+SITE_ID IN && SHOP_GROUP_ID IN` | `p_plant_id` | 구현 |
| `clbFactory`(S08) | Building / LBL00008 | `+PLANT_ID IN` — **SITE 조건 없음**(간접 종속) | `p_factory_id` | 구현 |
| `clbLine`(S09) | Line / LBL00010 | `+FACTORY_ID IN` + **`_A`/`_C` 재정렬**(`capaLineAssign.cascade.ts sortLineCodes`) | `p_line_id` | 구현 |
| `clbOperation`(S10) | Operation / LBL00009 | `CapaOperationByLine(EE)_SCP_ALL` + `DIVISION_ID && SHOP_GROUP_ID` 만. **Line 종속 금지**(함정1). ELTR 은 `AFFFF` 제외 | `p_operation_id` | 구현 |
| `clbElectrodeType`(S11) | Line Type / LBL00056 | `OperationElectrodeType_SCP_ALL` + 모드 선필터 + `OPERATION_ID IN` | `p_electrode_type` | 구현 |
| `txtItem`(S12)+`btnItemId`(S13) | LBL00054/LBL00669 | `InputField` + `...` 버튼 → 공용 `CapaItemPopup` **`multiSelect` + `operationGroup`** 배선(iter-3). 다중선택 결과는 distinct 후 `','` 결합해 한 칸에 누적(=`GetSelectedValuesText`) | `p_item_id`(SP 가 콤마 IN) | 구현 |
| (조회조건 Reset) | — | `SearchArea.onResetCondition` → `handleResetCondition` — §4.2 기본값 복원(Division/Plan Month/Version 첫 행, 다중 5축 `ALL`(ELTR 의 Operation·Line Type 은 `[]`), Item 공백, Valid `ALL`). Division Type 은 모드 스위치라 제외 | — | 구현(iter-3, CP-16) |
| `cboValid`(S14) | Valid / LBL00639 | `YesOrNo` + ALL 선행 → `''` 변환 | `p_valid_flag` | 구현 |
| `btnColumn`(S15) | — | SubTitle 공용 `IcGridColumnSetup` 아이콘 → `ColumnLayoutModal` | — | 구현 |

콤보 의미 패리티(convert-core §2.6): 접미 `EE` 2쌍(마스터·Operation)을 **SQL_ID 전환**으로 분리했다.
`CapaProgressStatus_SCP_ALL`(D03)·`YearFromThisYear_SCP_ALL`(D10)은 호출하지 않는다(V-27 — 전자는 죽은 로드, 후자는 바인딩 컨트롤 부재 + U-5 제외).

---

## 3. 영역3 — 그리드 (03_grid-columns.md)

| 축 | AS-IS | TO-BE | 판정 |
|---|---|---|:--:|
| 컬럼셋 | `SetSheetHeaderColumnSetInfo`/`SCP` | admin `SCM_MST_SHEET_COLUMNS` fetch(`fetchStaticColumns` 8 라우팅시트→7 메타시트). 하드코딩 fallback 없음 | 구현 |
| 동적 기간컬럼 | `RefreshSpreadDateColumn`(cs:2165-2180) | `capaLineAssignColumns.buildDateColumns` — `M_01YYYYMM`/`Y_YYYY`, 3단 헤더, 1단 공백, `DUMMY_YN` 뒤 | 구현 |
| 헤더 단수 | Assign **3단**(`SetSheetHeaderColumnSCP(_siAssign, 3, …)` cs:2163) / SOP **1단**(동 `_siSop, 1` cs:2187) / 팝업 P03·P02 **1단**(`SCP0104_CAPA_Line.cs:538`·`..._Model.cs:667-668`) | Assign = `headerRowHeight={16}`(48px 고정, hook #93). **SOP·팝업 2종은 1단으로 강제할 경로가 없다** — 공용 `getColumnDepth`(`packages/foundation/src/utils/columnMapping.ts:630-648`)가 단수를 **메타 class 라벨에서만** 파생하고 공용 DataGrid 에 단수 override prop 이 없다. ora.py 실측: 7시트 전건 `SMALL_CLASS_LABEL_NAME <> LARGE_CLASS_LABEL_NAME` 행이 있다(ASSEMBLY 5 / ELTR 5 / LINE 4 / SOP_* 각 5 / SOP_MODEL_* 각 5 — `SITE_NAME`·`PLANT_NAME`·`FACTORY_NAME`·`LINE_NAME`·`OPERATION_NAME`) → **THREE_DEPTH 로 파생**된다. AS-IS 는 프레임워크에 `iColumnHeaderRowCount=1` 을 넘겨 class 라벨을 **무시**시키므로(`SpreadInfo.cs:2093-2096`) 같은 메타로도 1단이 나온다 | **미구현(설계 C-8 대비 불일치)** — gap-resolve iter-1 A02. 해소는 메타 조정(승인) 또는 공용 prop 신설(별건 PR) 중 하나이며 둘 다 자기 화면 폴더 밖 |
| 편집잠금 | `LockRange2` 7건 | `capaLineAssign.editLock.ts` — 컬럼명 판정(인덱스 배열 이식 금지, hook #130) | 구현 |
| 셀 콤보 16종 | `SheetUtils.SetComboDataRow` 60+ 런타임 주입 | `capaLineAssign.gridCombos.buildCellComboCandidates` — 마스터 콤보에서 행 컨텍스트별 후보 계산 → `beginningEdit` 에서 `col.dataMap` 주입 | 구현 |
| 코드↔명칭 동기 | `CheckValidId`/`CheckValidName`(cs:3160-3699) | `syncCodeAndName` (cellEditEnded) | 구현 |
| 하위 cascade 클리어 | `ClearCurrRowSubCodes`(cs:3702-3820) | `clearSubCodes` — §3.2.1 매트릭스 그대로 | 구현 |
| Dummy 마킹 | `CheckDummyYN`(cs:3290-3300) | `markDummyYn` — `CapaDummyCode_SCP_ALL` + `DMY_` 접두. **OPERATION 미검사**(AS-IS 동일) | 구현 |
| Dummy 코드 채번 | `CHECK_NAME_ON_DUMMY_CODE` get-or-create(cs:3658-3690) | `utils/capaLineAssign.dummyCode.ts` + `CapaLineAssign.handleUnknownItemName`(iter-2 신설) | 구현(정적) / 런타임은 SP 미배포 |
| 편집모드 컬럼 노출 | `SetVisibleSheetColumns`(cs:4371-4493) | `applyEditModeVisibility`(iter-2 신설) — 코드축 8컬럼 토글 + `ATTRIBUTE3='N'` 폭 복원. **원천 차이 주의**: AS-IS 는 titleSet 응답의 `ATTRIBUTE3`, TO-BE 는 admin 메타 값(현재 전건 NULL = 잠복, GAP-24) | 구현(원천 차이 명시) |
| 병합 | `ToggleMerge`+`SmartColMerge`(조회모드만, `FPMerge.Restricted` **전 메타 컬럼**) | 그리드 레벨 `allowMerging={editMode ? ColumnHeaders : All}` 단일 스위치. 컬럼 단위 `applyMergeFlags` 는 iter-3 에서 제거 — 공용 DataGrid 가 정적 컬럼 플래그를 일괄 재지정해 무효였다(GAP-22) | 구현 |
| 컬럼 표시 순서 | 메타 `SORT_ORDER_NO` | 동일. 단 SOP_ASSEMBLY 는 `OPERATION_NAME`/`ELTR_LN_TP_CD` 가 **둘 다 150** 이라 비결정적 → `TIED_COLUMN_ORDER` + `applyTiedColumnOrder` 로 2차 정렬키 고정(자매 SOP_ELTR 실측 순서, GAP-06). 메타 값 정정은 사용자 승인 대기 | 구현(잠정) |
| 행 추가 | `Insert_Row_Assign`/`_Line`/`_Sop` | `handleInsert` + 팝업 confirm 핸들러(중복키 skip) + **P01 다중선택 행추가**(`handleItemPopupSelect`, iter-3) | 구현 |
| 셀 더블클릭 라우팅 | cs:5709-5712 | `CapaLineAssignGrid` dblClick(편집모드 + `isEltr && NICK_NAME` 차단) → `handleAssignCellDblClick`(`NICK_NAME`/`ITEM_ID` → P01, 그 외 → P03). iter-3 에서 ELTR 의 `ITEM_ID` 가 P03 으로 새던 것을 정정 | 구현 |
| 삭제 | `DeleteButton` — 'I' 행만 제거 | `GridAction.removeRow(grid, true)` + 가드 3종 | 구현 |
| 저장 | `SaveData` `^`/`;` 다발 | `capaLineAssign.save.ts` `buildAssignSavePayload`/`buildSopSavePayload` | 구현 |

---

## 4. validations (V01~V05) — **100% 매핑 의무** (Top11 #11)

| ID | 요지 (AS-IS 근거) | 구현 위치 (파일:라인) | 사유 / MSG 매핑 (AS-IS → TO-BE) | 상태 |
|---|---|---|---|:--:|
| V01 | `EditButton` SOP 분기 컷오프(cs:4085-4090) | `CapaLineAssign.tsx:355-361` `handleEdit` 컷오프 게이트 | MSG00109 → **MSG00109**(동번호·동의미 실측 확인) | 구현 |
| V02 | `EditButton` Assign 분기 컷오프(cs:4106-4111) | 동상 — 공통 가드 1개(`CapaLineAssign.tsx:355-361`)로 통합 | MSG00109 → **MSG00109** | 구현 |
| V03 | 저장 성공 건수(cs:4585-) | `CapaLineAssign.tsx:477` `doSave` 성공 분기 toast | MSG00004 → **MSG00672** `{0} data saved.` (번호 겹침 주의 — 아래 각주) | 구현 |
| V04 | 저장 실패(else 분기 — 체크리스트 오기 정정) | `CapaLineAssign.tsx:494·533` `doSave` 실패 분기 ×2 alert | MSG00006 → **MSG00003** `Failed to save.` | 구현 |
| V05 | 변경 0건 차단(cs:5485-5492) | `CapaLineAssign.tsx:525` `handleSave` dirty 0건 toast | MSG00133 → **MSG00004** `No changes to save.` | 구현 |

> hook #114 함정: AS-IS MSG00004(저장성공)와 TO-BE MSG00004(변경없음)가 **번호만 겹치고 의미가 다르다**.
> 번호가 아니라 문구 역조회로 매핑했다(design 03 §4.4 실측표).

## 4b. buttonGuards (B01~B38) 요약

| 그룹 | AS-IS | TO-BE 구현 위치 | 사유 (제외/해당없음 시 필수) | 판정 |
|---|---|---|---|:--:|
| B01~B03 | `btnSopNew` 3가드 | `handleInsert` SOP 분기 2조건(②③은 TO-BE 에서 같은 조건) | 구현 |
| B04~B09 | `_defaultDataModel_Changed` 재진입/타입 가드 | Wijmo `cellEditEnded` 단일 경로라 재귀 가드 불필요 — 구조적 해소 | 해당 없음 |
| B10 | `checkRequiredOfSearch` | R-22 게이트로 흡수(`*` 분기는 사문화) | — | 구현 |
| B11~B13 | Insert 가드 | `handleInsert` Assign 분기 3가드. **TO-BE 추가 가드 1개**: `CapaLineAssign.tsx:395` `if (!applied) return;` = 미조회 상태에서는 무동작. AS-IS `InsertButton`(cs:3893-3907)의 가드는 `isPageSOP`/`spdAssign==null`/`IsLock` 3개뿐이고 조회 여부를 보지 않으며 `_version`/`_division` **getter 현재값**으로 기본값을 채운다. TO-BE 는 CommonCheckList "Insert 시 확정 searchParams 기준 division" 규칙을 우선해 확정 조건(`applied`)이 없으면 행을 만들지 않는다. `handleItemPopupSelect`(:626) 도 동일 | 구현 |
| B14~B18 | Edit 가드 | `handleEdit` ref/컷오프 가드 | 구현 |
| B19~B25 | Delete 가드 | `handleDelete` 3가드 + `deleteOnlyNew` | 구현 |
| B26~B33 | 셀 콤보/클릭 가드 | `beginningEdit` 편집 게이트 + `IsLockCell` 등가 | 구현 |
| B34 | ELTR `NICK_NAME` 더블클릭 미오픈 | `CapaLineAssignGrid` dblClick `if (isEltr && binding===NICK_NAME) return;` | — | 구현 |
| B35~B38 | 저장 전 가드 | `handleSave` 편집모드/dirty/필수키 3단 | 구현 |

---

## 5. AS-IS 잠재 결함 교정 (U-4 확정 — 보고 의무, hook #50)

| # | AS-IS 결함 | 근거 | TO-BE 처리 |
|---|---|---|---|
| K-20-a | `_fixed_column_idx` 가 탭과 무관하게 **항상 `_siAssign` 기준**으로 계산된다(cs:211-227). 그래서 `SetLockColumnsAllSOP` 의 `LockRange2(..., _fixed_column_idx, ...)`(cs:4048)가 **Assign 시트에서 구한 인덱스를 SOP 시트에 적용**한다. 두 시트의 컬럼 수가 다르므로(ASSEMBLY 20 / SOP_ASSEMBLY 22 / ELTR 23 / SOP_ELTR 22) 엉뚱한 컬럼이 잠긴다. `catch {}` 로 `-1` 이 반환되면 조용히 넘어가기도 한다 | cs:211-227·229-247·4048 | **교정.** TO-BE 는 인덱스가 아니라 **컬럼명**으로 판정한다(`SOP_FIXED_COLUMN='ELTR_LN_TP_CD'`, `capaLineAssign.editLock.isSopCellEditable`). "SOP 고정컬럼을 잠근다"는 의도만 살렸고 인덱스 오참조는 구조적으로 재발하지 않는다 |
| K-20-b | `GetCurrSops()` 가 `_siSop` 루프를 돌면서 컬럼 인덱스를 `_si`(Assign) 로 조회한다 | cs:2246-2261 | **교정.** TO-BE 의 SOP 중복키 판정은 컬럼명 배열(`SOP_DUP_KEYS`)로 직접 읽는다(`CapaLineAssign.handleSopModelConfirm`) |
| K-20-c | P01 팝업에서 **2건 이상**을 골라 행을 추가할 때, AS-IS `Edit_Row_Assign` 의 기본값 블록(VER_ID/VER_SEQ/DIVISION_ID/`DUMMY_YN='N'`/`VALID_YN='Y'`/ELTR `ELTR_LN_TP_CD='S'`/기간셀 전건 `"1"`)은 `if (_curr_assign_action == CAppSetting.FlagI)`(cs:5292) 일 때만 실행된다. 그런데 `_curr_assign_action` 은 `_currAssignRowIdx`(= **마지막으로 클릭한 행**)의 Action 이고 `Insert_Row_Assign`(cs:5399-5424)은 `Insert()` 뒤에 `SetSelection` 을 하므로, 기존행('M'/'')을 더블클릭해 다건을 고르면 **새 행에 `ITEM_ID`/`NICK_NAME` 만 채워지고 나머지 기본값이 비어 있다** | cs:5287-5330·5292·5399-5424 | **교정.** TO-BE `CapaLineAssign.tsx:627-639` 는 조건 없이 항상 기본값 블록을 적용한다. 7키 중 하나라도 공백이면 SAVE SP 가 **에러 없이 행을 버리므로**(design 03 §4.3-d) AS-IS 재현이 곧 데이터 유실이다. K-20-a/b 와 같은 급의 의도적 교정이다 |

> 두 건 모두 "AS-IS 가 우연히 맞게 돌고 있을 가능성"이 있어 **TO-BE 결과가 AS-IS 와 달라질 수 있다**.
> 사용자 확정(U-4 = 바로잡는다)에 따른 의도된 차이이며, 런타임 대조 시 이 항목을 먼저 확인할 것.

---

## 6. 권한 절 (hook #50)

| 축 | AS-IS | TO-BE |
|---|---|---|
| 메뉴 가시화 | `SCM_ADM_MNU_M` 무관(WinForms) | `design/05_register.sql` BLOCK 2 — `ROUTE_PATH='supply/capa-line-assign'`, `MNU_DESC` 필수 |
| 그룹→메뉴 | `GetSecurityACL(groupId, userId, menuId)` | `SCM_ADM_USER_GR_MNU_MPG_M` 2그룹(ADMIN / SCP Planner — 자매 SCP0114 미러) |
| 버튼 노출 | 툴바 override 5종(Search/Insert/Edit/Delete/Save) | `SCM_ADM_MNU_BTN_MPG_M` **31행**(ora.py 실측 2026-09-23 iter-3 — 그리드/팝업 9 `SHT_NM` × 버튼) |
| 버튼 권한 | 베이스 ACL `CanSelect/CanInsert/...` | `SCM_ADM_USER_GR_MNU_BTN_MPG_M` **62행** — 누락 시 proc 호출이 `-9997` 로 실패한다 |
| Division 권한 | `dtDivision.Rows.Count==0` → 패널 100% 비활성 | `useCapaLineCascade.hasDivisionAuth` → Form 전 필드 disabled + `MSG00667` 1회. **단 `SearchArea` 자체에는 `disabled` prop 이 없어 Search 버튼은 눌린다**(무동작으로 흡수 — GAP-11, 공용 변경은 별건) |
| API 메타 | — | `SCM_ADM_API_M` **15행 등록 완료**(iter-2 BLOCK 8~10 적용, iter-3 재조회 확인) |
| PROC 메타 | — | `SCM_ADM_PROC_M` **0행 — 미등록**. `PKG_SCP0104` 배포 후 `all_arguments` 실측으로 convert-sp 가 등록한다. 0행이면 공용 fallback 이 더미 1행을 돌려 파라미터 0개 call 이 되어 전 조회/저장이 하드에러다 |

---

## 7. 미매핑·부분 구현 잔여 (완료로 뭉뚱그리지 않는다)

| # | 항목 | 사유 | 보완 |
|---|---|---|---|
| ~~6-1~~ | ~~P01 Item 팝업 다중선택 → 행 추가(A-6)~~ | **iter-3 해소** — 공용 `CapaItemPopup` 이 이미 `multiSelect`/`selectedAll`/`operationGroup` 을 제공(기본값=기존 동작 보존)해 자기 화면 배선만으로 등가가 됐다 | `handleItemPopupSelect`(1건=현재행 수정 / 2건+=행 추가) |
| ~~6-2~~ | ~~Dummy 명칭 신규 채번(G14·G15)~~ | **iter-2 해소(정적)** — `capaLineAssign.dummyCode.ts` 배선 완료 | 런타임은 `PKG_SCP0104` 배포 후 |
| 6-3 | 저장 후 연쇄(`SCP0105_CHECK_*`/`SCP0106_CHECK_*`, §4.3-f) | SAVE SP 내부 호출이라 FE 구현 대상이 아니다 | convert-sp 소관(SP 본문에 포함) |
| ~~6-4~~ | ~~`SetVisibleSheetColumns` 편집모드 폭 복원(§3.6)~~ | **iter-2 해소** — `applyEditModeVisibility` 가 "메타가 보이기로 한 컬럼에 한해 AND" 구조라 메타를 덮어쓰지 않는다 | 잔여는 `ATTRIBUTE3` 원천 차이 1건(GAP-24, 현재 잠복) |
| 6-5 | 런타임 조회·저장 전체 | `PKG_SCP0104` 0건 + `SCM_ADM_PROC_M` 0행(API_M 15행은 등록됨) | convert-sp 14본 배포 + PROC_M 등록 후 재판정 |
| 6-6 | 신규행 편집 판정이 메타 `INPUT_TP_CD='S'` 를 되살린다(GAP-10) | AS-IS `LockRange2(row,0,row,DUMMY_YN,false)`(cs:3985)와 일치하는 **화면 판정 우선** 결정이다. 대상 4컬럼은 전건 `COLUMN_WIDTH=0` 이라 화면에서 도달 불가 | 결정 근거를 여기 남긴다(실질 영향 없음) |
| 6-7 | SOP_ASSEMBLY `SORT_ORDER_NO` 150 중복(GAP-06) | **정정(gap-resolve iter-1, `asis.py` 실측)**: AS-IS `SCM_MST_SHEET_COLUMNS` 도 `SOP_ASSEMBLY.ELTR_LN_TP_CD=150`·`OPERATION_NAME=150` 으로 **동일하게 중복**이다. 이관 오류가 아니라 AS-IS 원본 데이터 상태이며, 160 으로 정정하면 AS-IS 로부터 **이탈**한다 | 메타 UPDATE 를 권고하지 않는다. FE 2차 정렬키(`TIED_COLUMN_ORDER`)가 AS-IS 의 비결정 순서를 자매 시트 `SOP_ELTR`(150/160) 실측 순서로 결정화한 것이므로 현 상태가 유지안이다. 값 변경은 업무 개선 제안이며 사용자 결정 |
| 6-11 | SOP·팝업 2종 그리드가 **3단 헤더로 렌더**된다(설계 C-8 = 1단) | 공용 `getColumnDepth` 가 단수를 메타 class 라벨에서만 파생하고 단수 override prop 이 없다. AS-IS 는 `iColumnHeaderRowCount=1` 을 프레임워크에 넘겨 같은 메타로 1단을 만든다. §3 "헤더 단수" 행 참조 | 메타 `SMALL/LARGE_CLASS_LABEL_NAME` 조정(승인) 또는 공용 DataGrid 단수 prop 신설(별건 PR). 둘 다 자기 화면 폴더 밖이라 이 회차에서 해소 불가 | R3 블로커: 사용자 결정 |
| ~~6-12~~ | ~~P03 Line 팝업 행추가의 `'-'`/공백 가드가 6키 중 `LINE_ID` 1개만~~ | **gap-resolve iter-1 해소.** AS-IS `InsertAssignLine` 은 중복체크 앞에서 6키 전건에 `'-'` 가드와 공백 가드를 **두 번** 건다("빈값 or 오입력 방지"). `'-'` 는 공백이 아니라 `findDroppedRowKey` 와 SAVE SP 공백 탈락 필터를 모두 통과하므로 `'-'` 키 행이 실제로 MERGE 될 수 있었다 | `CapaLineAssign.tsx` `handleLineConfirm` — `LINE_DUP_KEYS` 6키에 `'-'`·공백 가드 2단 추가(가드를 중복체크 **앞**으로 이동) | 해소 |
| ~~6-13~~ | ~~Division 변경 시 하위 다중선택 6축이 초기화되지 않는다~~ | **gap-resolve iter-1 해소.** AS-IS `cboDivision_SelectedIndexChanged`(cs:5510-5519) → `RefreshAll()`(cs:2005-2015)이 Site·Plant·Factory·Line·Operation·ElectrodeType 6축 DataSource 를 전부 재생성한다. 형제 핸들러(Site/Plant/Building)는 하위를 리셋하는데 Division 만 빠져 있었고, 기본값이 `['ALL']` 이라 평시엔 가려지는 잠복 결함이었다(특정 Site/Line 선택 후 Division 변경 시 이전 코드가 `toCsv` 로 SP 에 실린다) | `components/CapaLineAssignForm.tsx` Division `onChange` 에 6축 리셋 추가(모드별 빈값 규약은 store `changeDivisionType` 과 동일: ELTR 은 Operation·Line Type `[]`) | 해소 |
| 6-14 | 조회모드 폭 0 접기·편집모드 폭 복원이 **런타임 무동작** | `applyEditModeVisibility` 의 폭 복원 블록이 `ATTRIBUTE3='N'` 게이트인데 `ATTRIBUTE3` 가 **AS-IS·TO-BE 양쪽 139행 전건 공란**(gap-resolve iter-1 실측)이라 절대 발동하지 않는다. 복원 폭 값 자체는 AS-IS 리터럴과 일치. AS-IS 는 이 메타가 아니라 **titleSet 응답**의 `ATTRIBUTE3` 를 읽으므로 원천이 다르다(GAP-24) | AS-IS 재현이 필요하면 `ATTRIBUTE3='N'` 적재(승인), 불필요하면 FE 분기 삭제. 현 상태는 "조용한 미동작" 이므로 어느 쪽이든 결정이 필요하다 | R3 블로커: 사용자 결정 |
| 6-9 | UI 공통 UC-02(편집 중 재조회 confirm) 미구현 | `handleSearch`(`CapaLineAssign.tsx:338-345`)가 confirm 없이 `assignTrackerRef.current?.clearChanges()`(:340-341)로 변경분을 버린다. 공용 `useDirtyRegistry`(`packages/shared/src/stores/useDirtyRegistry.ts:112`)의 `MSG00703` 은 **화면 닫기** 문구(`이 화면을 닫으시겠습니까?`)이고 재조회용 경로가 아니다. 리포 전체 67화면 중 `useDirtyRegistry` 를 **코드에서 쓰는 화면 0건**(문서 언급 4건뿐) | 전 화면 공통 축이라 이 화면 단독 구현은 UX 불일치를 만든다. 공용 경로 신설 = Hard Boundary 밖(별건 PR) → 사용자 결정. 아래 §9 UC-02 참조 |
| 6-10 | UI 공통 UC-05(Excel Download 콤보 Name) 부분구현 | `*_ID`/`*_NAME` 쌍 컬럼은 NAME 컬럼이 그리드에 실재해 Excel 에도 Name 이 나간다. 다만 `ELTR_LN_TP_CD`(Line Type)는 **쌍 NAME 컬럼이 없고** `CELL_COMBO_DATA_TYPE` 도 NULL(ora.py 실측 — 메타 콤보는 `YesOrNo` 2컬럼뿐)이며, 코드 주입 `dataMap` 은 `beginningEdit` 에서만 붙고 `cellEditEnded` 에서 `null` 로 되돌린다(`CapaLineAssignGrid.tsx:160·174-175`) → 비편집 시점의 Excel 출력은 원 코드값 | 저위험. 메타 `CELL_COMBO_DATA_TYPE` 등재 또는 공용 export 시 dataMap 공급이 필요하며 둘 다 이 화면 범위 밖 요소를 건드린다 → 사용자 결정 |
| 6-8 | 팝업 2시트(`LINE`/`SOP_MODEL_*`)의 `FIXED_FLAG` 가 마지막 컬럼(GAP-23) | **정정(gap-resolve iter-1)**: ① `asis.py` 실측 — AS-IS 메타도 `FIXED_FLAG='Y'` 행이 **7시트 전건 동일**(LINE=`LAST_UPDATE_DATE`, SOP_MODEL_*=`ELTR_LN_TP_CD`). ② AS-IS 프레임워크가 이 메타로 실제 freeze 를 건다 — `SpreadInfo.cs:1547·1559`(주석 "fixed_flag가 설정된 **마지막** 칼럼의 Index" → `freezeColumnIndex=j` → `Freeze(FPFrozen.Col, …)` → `FrozenColumnCount`), 동일 블록이 `GscmExtensions.cs:1622·4272`·`FPExtensions.cs:1512·4058` 에도 있다. 즉 **AS-IS 팝업도 전 컬럼이 고정열**이며 TO-BE `DataGrid.tsx:954` `findLastIndex(_fixed)+1` 과 의미가 같다. 이전 회차의 "AS-IS 에 고정열 0건" 판정은 **화면 폴더만 grep** 해 프레임워크를 놓친 오탐이다 | 메타 `FIXED_FLAG` 해제를 권고하지 않는다(해제 = AS-IS 이탈). 잔여 미확정 1건: SCP 전용 변형 `SetSheetHeaderColumnSCP` 본문이 DLL 전용이라 4번째 인자(`_fixed_column_name`)로 경계를 덮는지 직접 못 읽었다 — 단 `SOP_MODEL_*` 에는 그 인자값(`DefColumns.VALID_YN`)에 해당하는 컬럼이 **존재하지 않으므로**(ora.py 실측) 경계 원천은 `FIXED_FLAG` 가 맞다. 모달 폭 체감은 육안 축 |

---

## 8. CRUD·모달 매트릭스 (2026-08-07 축 — `asis_mapping_gate.py --init` 생성 항목, gap-resolve iter-1 기입)

> 이 절과 §9 는 `asis_mapping_gate.py --check` 가 **부재 시 FAIL** 처리하는 상시 축이다. convert-react iter-1~3 은 이
> 게이트를 실행하지 않아 두 절이 비어 있었고(gap-resolve iter-1 `--check` 결과 FAIL), 아래를 실제 대사해 채웠다.
> 상태 허용값: 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수) / 미구현.

| ID | 요지 | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|:--:|
| MODAL:CapaLineAssignModelModal | P02 SOP Model 팝업 — AS-IS `SCP0104_CAPA_Line_Assign_Model.cs` | `CapaLineAssign.tsx:835` (JSX) · `components/modals/CapaLineAssignModelModal.tsx` · confirm 경로 `handleSopModelConfirm` | CRUD 축: R(조회 `LINE_ASSIGN_MDL_*`) + 선택결과가 부모 SOP 그리드에 **행 추가(C)**. U/D 는 AS-IS 도 없음 | 구현 |
| MODAL:CapaLineModal | P03 CAPA Line 팝업 — AS-IS `SCP0104_CAPA_Line.cs` | `CapaLineAssign.tsx:825` (JSX) · `components/modals/CapaLineModal.tsx` | CRUD 축: R(조회 `LINE_ASSEMBLY`/`LINE_ELTR`) + 선택결과 행 추가(C). U/D 없음 | 구현 |
| MODAL:CustomDialog | P01 Item 팝업(AS-IS `ShowItem` → `SCM0002_CAPAItemPopup`) — 도구가 AS-IS 범용 다이얼로그 API 명으로 잡은 항목 | 그리드 셀 경로 `CapaLineAssign.tsx:853` `<CapaItemPopup multiSelect …>` + `handleItemPopupSelect`(:602-655) / 조회조건 경로 `components/CapaLineAssignForm.tsx:333-351` | **공용 컴포넌트 재사용**(`features/supply/src/components/CapaItemPopup.tsx`, 사본 금지). 조회 전용 팝업이라 C/U/D 해당없음 — 선택결과의 행추가는 부모 그리드 책임 | 구현 |
| MODAL:ShowDialog | P04 컬럼 표시설정 + alert/toast 계열 범용 다이얼로그 | P04 = `CapaLineAssign.tsx:874` `<ColumnLayoutModal>` (공용 재사용, hook #132) · alert = `useMessageStore.setAlert`(:276·356·453·469·494·533·911) · toast = `setToast`(:477·525) | 개인화 설정 모달이라 업무 CRUD 없음(해당없음). 저장 성공/실패 알림은 §9 UC-04 축에서 판정 | 구현 |

---

## 9. UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 7항목, gap-resolve iter-1 기입)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common'.
> 화면 분석 md 에 없는 **전 UI 공통 요구**이며, AS-IS 패리티와 별개 축이다(AS-IS 에 없어도 TO-BE 요구).

| ID | 요지 | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|:--:|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 유지한 채 추가 행이 보이도록(필터 clear 금지) | 공용 위임 — `GridAction.addRow`(`CapaLineAssign.tsx:407`) / `addRowSet`(:655·722·755)가 내부에서 `keepRowVisibleUnderFilter` 호출(`packages/foundation/src/utils/gridAction.ts:836`, 정의 :49). 화면이 필터를 clear 하는 코드 0건 | 화면은 공용 행추가 API 만 쓰므로 자동 충족 | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = confirm(MSG00703) | 없음 — `handleSearch`(`CapaLineAssign.tsx:338-345`)가 confirm 없이 `clearChanges()`(:340-341) | **미구현.** 공용 `useDirtyRegistry`(`packages/shared/src/stores/useDirtyRegistry.ts:112`)의 MSG00703 은 화면 **닫기** 문구이고 재조회 경로가 아니다. 리포 67화면 중 코드 사용 0건 = 플랫폼 공통 미구현이며, 이 화면 단독 구현은 UX 불일치 + 공용 경로 신설은 Hard Boundary 밖 → 사용자 결정(§7 6-9) | 미구현 |
| COMMON:UC-03 | 컬럼 추가/제외 적용 시 기존 조회 데이터 Reset 후 재조회 유도 | 공용 위임 — `CapaLineAssign.tsx:874` `<ColumnLayoutModal>` (공용 재사용, 사본 0건). 화면은 컬럼 레이아웃 적용 결과를 `applyLayoutToColumns` 로만 반영하고 데이터는 React Query 가 보유(store 서버데이터 0건) | 공용 모달이 정의하는 표준 동작에 위임. 화면이 공용 동작을 덮는 코드 0건 | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 | `CapaLineAssign.tsx:477`(저장 성공 `MSG00672`) · `:525`(변경 0건 `MSG00004`) — 둘 다 `setToast`. 실패 경로는 `setAlert`(:494·533) | 성공/무변경은 Toast, 실패는 Alert = LGES WDG 표준(hook #132 §3) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼이 Code 아닌 Name 으로 출력 | `*_ID`/`*_NAME` 쌍 컬럼은 NAME 이 실 컬럼으로 존재(`SCM_MST_SHEET_COLUMNS` 실측 — SITE/COMPANY/PLANT/FACTORY/LINE/OPERATION 6쌍) → Excel 에 Name 출력. 메타 콤보 `VALID_YN`/`DUMMY_YN`(`CELL_COMBO_DATA_TYPE='YesOrNo'`)은 공용 DataGrid 가 dataMap 상주 | **부분구현** — `ELTR_LN_TP_CD` 만 쌍 NAME 없고 메타 콤보도 아니며, 코드 주입 dataMap 이 `beginningEdit`~`cellEditEnded` 구간에만 존재(`components/CapaLineAssignGrid.tsx:160·174-175`) → 비편집 시 코드값 출력. §7 6-10 | 부분구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 | `components/CapaLineAssignForm.tsx:173`(`value.join(',')`) · `:178`(`split(',')`) · `:341-349`(팝업 다건 → 공백제거 + distinct + `','` 결합 = AS-IS `GetSelectedValuesText`) | SP 계약이 콤마 IN 이라 누적이 곧 다중조회(design 02 §4.3) | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용 | 공용 위임 — `packages/shared/.../DataGrid.tsx:1483` `rebindFilterColumns(grid, getGridFilter())` (정의 `gridAction.ts:91`). 화면은 `gridFilterRef` 를 공용에 넘기기만 한다(`CapaLineAssignGrid.tsx:33` · `CapaLineSopGrid.tsx:20`) | 공용 DataGrid 가 컬럼 재대입 후 필터-컬럼 연결을 복구 | 구현 |

**축 합계: 구현 5 / 부분구현 1(UC-05) / 미구현 1(UC-02).** 두 잔여는 §7 6-9·6-10 에 사유와 함께 올렸다.
