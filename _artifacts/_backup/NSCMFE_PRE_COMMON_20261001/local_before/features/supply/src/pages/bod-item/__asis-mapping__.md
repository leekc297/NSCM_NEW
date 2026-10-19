# SCP0030 BOD Item — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS: `06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0030_BOD_ITEM/SCP0030_BOD_ITEM.cs`(+`.Designer.cs`), namespace `GSCM.SCP.Master.UIL`.
> TO-BE: `nscm-fe/features/supply/src/pages/bod-item/`. 근거 설계: `.atlas/gscm-design/SCP0030/design/00~03`.
> 4축 = (1) 레이아웃/버튼 (2) 조회조건 콤보 (3) 그리드 컬럼/셀 (4) 검증/저장.

## 1. 레이아웃·버튼 (01_layout.md)

| AS-IS (cs / Designer) | 동적규칙 | TO-BE |
|---|---|---|
| usrConditionPanel1(HidePanel) + spdMain 2시트 | 조건패널 접기(L9) + 그리드 2탭 | `BodItem.tsx` MainTitle openSearchArea + `TabWrapper`(BOD ITEM/Excluded Item) |
| InitControls `SetDivisionAuthCheck`(cs:221) | Division 권한 0건 → 조회영역 차단(L1) | `Division_SCP` @sesUserId 권한필터 0건이면 콤보 empty(BE 세션 구동). FE 별도 게이트 없음 — 확인필요(육안) |
| FindData_Main/Sub → LockColumn 전잠금 + `_isEditMode=false`(cs:697/794/715) | 조회 직후 read-only(L2) | 조회 시 `setIsEditMode(false)`; 그리드 beginningEdit 가 비편집모드에서 전셀 취소 |
| EditButton `SwitchLock`(cs:604-624) | 편집모드 진입, 화이트리스트만 unlock(L3) | Edit customButton → `isEditMode` 토글. `BOD_ITEM_EDITABLE`/`BOD_EXCLUDED_EDITABLE` 만 편집 |
| InsertButton(cs:572-601, Excluded && !IsLock) | 신규행 Excluded 시트만, VALID_YN='Y'·DIVISION_ID=선택(L4) | `handleInsert`: activeTab===EXCLUDED 가드 + `GridAction.addRow`(VALID_YN='Y', 단일 division 시 DIVISION_ID) |
| bodItem InsertButton 로직 주석(cs:487-568, PJ20209642) | 메인 시트 Insert 비활성 | `handleInsert` activeTab 가드로 bodItem 추가 차단 |
| SaveButton → `_isEditMode=false`(cs:451) | 저장 후 읽기모드 복귀(L5) | `mutateXxx` onSuccess `setIsEditMode(false)` |
| DeleteButton(cs:457-478) | 메인=신규('I')만, Excluded=행삭제(#138)(L6) | `handleDelete` `GridAction.removeRow(grid, true)`(신규행만), 기존행은 VALID_YN 편집 |
| spdSub_ActiveSheetChanging(cs:1732-1762) | 편집중 시트전환 차단 + MSG00129(L8, buttonGuards #6~#9) | `handleTabChange`: 떠나는 시트 dirty(CRUD_TYPE) 시 차단 + `MSG00129` |
| 공통 SubTitle 5버튼 | admin 권한 동적(L10) | `useTabBtnPermissions().hasButton()` × editable 곱. INSERT/DELETE 미등록 → SAVE 권한 게이트(자매 SCP0007) |

## 2. 조회조건 콤보 (02_search-combo.md) — comboCalls 7 / filterCalls 4

| AS-IS 헬퍼(라인) | SQL_ID | TO-BE |
|---|---|---|
| `BLUtils.GetDivisionWithoutEE`(cs:47/226) | `Division_SCP` + `ATTRIBUTE3<>'EE'` | `BodItemForm` Division 콤보 + `.filter(ATTRIBUTE3!=='EE')` FE 재현 |
| `Data_SCP.CommonAll(ToSiteBOD1)`(cs:52/54) FromSite/ToSite | `ToSiteBOD1_SCP_ALL` | 동일 콤보, `buildDivisionFilteredOptions`(division 클라 필터). From=To 후보 동일 |
| `Data.Common(LookupCommon,INCOTERMS)`(cs:55) | `LookupCommon` @lookupType=INCOTERMS | `useTabComboQueries {comboId:LookupCommon, lookupType:'INCOTERMS'}` |
| `Data.Common(LookupCommon,TRANSPORT_MODE_CODE)`(cs:56) | `LookupCommon` @lookupType=TRANSPORT_MODE_CODE | 동일(lookupType='TRANSPORT_MODE_CODE') |
| `SCP0130_GET_SEARCH_INFO` Tables[0](cs:60/232) Plan Group | `PlanGroup_SCP_ALL` | 표준 콤보 재사용(02 §2.3 1:1) + division 클라 필터 |
| `Data.Common(YesOrNo)`(cs:57) | `YesOrNo` | BOD Item Valid 단일 드롭다운 |
| txtItemId(cs:650) 콤마 다중 / txtNickName | (콤보 아님) | `InputField` 자유입력 |
| btnItemId_Click `SCM0002_ItembyDivisionPopup`(cs:1636) | (팝업) | `ItemByDivisionModal`(로컬) — 조회 SP 미배포(convert-sp 후속) |
| cboDivision_SelectedIndexChanged→SetChangeControl(cs:323/315) | cascade 필터(재조회 아님) | `setSearchParams` division 변경 시 하위 'ALL' 리셋 + `buildDivisionFilteredOptions` |
| p_plan_group_id 주석처리(cs:685) | 메인 SP 미전달 | bodItem GET filters 에 planGroupId 미포함(비기능 유지). Excluded GET 은 planGroupId 전달(PROC_M 실측) |

## 3. 그리드 컬럼/셀 (03_grid-columns.md) — gridSignals 69

| AS-IS | 규칙 | TO-BE |
|---|---|---|
| SCM_MST_SHEET_COLUMNS(bodItem 37/Excluded 14) | 동적 컬럼 | `fetchStaticColumns`(ADMIN_SHEET_NAME 'BOD ITEM'/'Excluded Item') → `staticColumns` prop. 하드코딩 0 |
| LockColumn 18건(cs:607-620/697/794) | 편집 화이트리스트(#130 배열 이식 금지) | `BOD_ITEM_EDITABLE`/`BOD_EXCLUDED_EDITABLE` = SAVE SP JSON 계약. beginningEdit 게이트 |
| SetBGColor 24건: checkValidN1~N8(cs:1232~1623) | FROM/TO 검증색 6종 | 재현 안 함 — 검증 호출 자체가 AS-IS 에서 dead(cs:937-942 주석). 편집색(Yellow)만 `BodItemGrid`/`BodExcludedGrid` formatItem 유지 |
| SmartColMerge 5건(cs:389/702/204/403/799) | 세로 병합(#69) | `allowMerging=Cells` + `BOD_ITEM_MERGE_COLUMNS`(bodItem)/`BOD_EXCLUDED_MERGE_COLUMNS`(Excluded, cs:403/799) updatedLayout 재적용 |
| SetCellTypeCombo YesOrNo(BOD_ITEM_VALID/BOD_VALID/ROUTE_VALID/VALID_YN) | 셀 콤보 | admin 컬럼메타(CELL_COMBO_DATA_TYPE=YesOrNo) 구동 — 수동 DataMap 없음 |
| SetValue cascade 12건(cs:1874-1883/1797) | 팝업 반환 자동채움 | `handleItemCellSelect`/`handleBodSelect`(FROM_SITE_NAME/TO_SITE_NAME/BOD_ID/INCOTERMS/TRANSPORT_MODE) |
| cellType PRIORITY 0~99 / SAFETY_STOCK 0~100(cs:386/387) | 숫자 범위 | `handleSaveBodItem` 범위 검증(RANGE) |
| Material팝업(cs:1797)/GetBODItem팝업(cs:1806) | 셀 더블클릭(#5-16) | `BodExcludedGrid` dblClick + `ItemByDivisionModal`/`GetBodItemModal`(팝업셀 편집취소). 조회 SP 미배포(convert-sp 후속) |

## 4. 검증·저장 (03 §4 / validations 21 · buttonGuards 15)

| AS-IS | TO-BE |
|---|---|
| SAVE_BOD_ITEM JSON(cs body:598-612) CRUD_TYPE/SEQ/BOD_ID/DIVISION_ID/ITEM_ID/PRIORITY/FROM/TO/SAFETY_STOCK(+EXISTS)/BOD_ITEM_VALID | `mutateBodItem`(useProcMutation, data CLOB). CRUD_TYPE=EditTracker 마킹(자체 상태필드 금지) |
| SAVE_BOD_EXCLUDED JSON(cs body:770-778) CRUD_TYPE/DIVISION_ID/ITEM_ID/BOD_ID/BOD_EX_FROM/TO/VALID_YN/PRE_KEY_VALUES | `mutateExcluded`(useProcMutation) |
| 필수검증 checkRequiredOfSpread(cs:929) | 공통 `useSaveWithValidation`(staticColumns 기반) |
| checkValidN1~N8(MSG00212/213/216/060/217/219) — cs:937-942 **전건 주석 처리(호출 안 됨)** | 재현 안 함(저장 차단 없음). AS-IS 주석 사유 "BOD LT 2단계 개발 - FROM, TO 저장 BOD UI 에서 관리" 그대로 반영 — 03 §3-B 는 dead 메소드 본문만 추출 |
| cellType 숫자범위 SetReNumerCellType(cs:386/387, 입력 제약, 미주석) | `handleSaveBodItem` 저장시 범위 검증(RANGE, 등가) |
| MSG00129 시트전환 가드 | `handleTabChange` dirty 차단 |

### 검증·저장 정직 보고
- **날짜 6검증(N1~N8) 미재현 = AS-IS 파리티**: AS-IS `SaveData_Main`(cs:905)은 `checkRequiredOfSpread`(cs:929)만 실행하고 `checkValidN1~N8`(cs:937-942)은 전건 주석 처리돼 있다. 메소드 본문(cs:1223-1633)은 남아 있으나 어떤 caller 도 호출하지 않는다(grep 확인). 따라서 TO-BE 도 저장 시 날짜 중첩/역전/비연속 검증을 하지 않는 것이 AS-IS 런타임과 일치한다. 설계 03 §3-B 는 호출부를 확인하지 않고 dead 메소드를 추출한 결과라 런타임과 불일치 — **업무가 이 검증을 SCP0030 에서 부활시키길 원하는지는 확인 필요(업무 축)**.
- 셀 병합 CustomMergeManager 누적키 제약(grid-behavior-parity §1.3): 병합 대상 컬럼 사이 비대상 컬럼이 끼면 그 값까지 같아야 병합 — AS-IS FarPoint 열단위 독립 병합과 미세차(값 다르면 안 붙는 안전 방향). Excluded 시트도 동일 처방(`BOD_EXCLUDED_MERGE_COLUMNS`).
- 병합 대상 컬럼셋: `SCM_MST_SHEET_COLUMNS` 에 per-column 병합 플래그 컬럼 자체가 없다(2026-09-26 ora.py 실측). SmartColMerge 는 admin 메타가 아니라 화면 결정이므로 병합 컬럼셋 상수화가 정합.
- 팝업(Item/BOD) 조회 SP: PKG_SCP0030(4멤버) 밖·미배포. FE 배선·선택→채움 완비, 런타임 데이터는 convert-sp 팝업 SP 배포 후.
- Division 전극 포함(GetAllDivisionCheckedElectrode, cs:1639) 규칙: 팝업 입력 divisionId 를 현재 조회조건 division(EE 제외)으로 전달. 전극 매핑 원천이 없어 EE 포함 세부 규칙 미재현 — 확인필요(업무 축).
