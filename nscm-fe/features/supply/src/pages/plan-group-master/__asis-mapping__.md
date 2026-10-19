# SCP0121_PlanGroupMaster — AS-IS ↔ TO-BE 매핑 (메인 화면)

> AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0121_PlanGroupMaster/SCP0121_PlanGroupMaster.cs`(+`.Designer.cs`)
> TO-BE: `nscm-fe/features/supply/src/pages/plan-group-master/` (convert-react SCP0121 v3, 판정=신규 NEW)
> 설계: `.atlas/gscm-design/SCP0121/design/00_checklist.md`·`01_layout.md`·`02_search-combo.md`·`03_grid-columns.md`
>
> 종전 `__asis-mapping__.md`(SCP0121_OwnerPopup 세대)는 superseded — 원본은 `_ownerpopup-backup/` + git 이력 보존.
> OwnerPopup 는 메인 화면이 직접 열지 않는 자매 팝업(PlanGroupInfoPopup 하위)이라 이 loop 범위 밖이다.
> `components/modals/OwnerSelectModal.*`(잔재)는 이 회차에서 미개조.

## 1. 조회조건 (영역2, 02_search-combo)

| AS-IS (cs:line) | TO-BE | 비고 |
|---|---|---|
| `cboDivision` + `BLUtils.GetDivision(false,"")` (cs:42,132) | `PlanGroupMasterForm` Division `useTabComboQueries({comboId:'Division_SCP',mnuId})` | 권한필터 EE 포함. Division_SCP_NoEE/MyDivision 오매핑 금지(02 §2-A) |
| `clbOperation/Plant/Building/Line/PlanGroup` 체크리스트 (cs:135-140) | Form 5 `CustomDropdown multiple allOption` | 콤보 레지스트리 아님 — GET_SEARCH_INFO 6커서 + 클라 Division 필터(utils/plan-group-master.searchInfo) |
| `GetSearchInfo()` static 1회 (cs:58,160-172) | `useTabProcQuery(searchInfo)` mount 1회(`loadSearchInfo`) — 공용 `PKG_COM0000.P_SCP0121_GET_SEARCH_INFO` | 커서 COL_NM plantList/factoryList/lineList/planGroupList/targetList/operationList (PROC_M 실측) |
| `RefreshOperation/Plant/Building/PlanGroupByDivision` (cs:200-257) | `buildOperation/Plant/Building/PlanGroupOptions(rows, division)` | Plant CODE 중복제거(SRCH-05 = distinctByCode) |
| `RefreshLine` 다축 IN (cs:239) | `buildLineOptions` Division+Op+Plant+Building axisMatch | 미선택 축 `IN('')` AS-IS 거동 재현(axisMatch) |
| `ClbDivision_SelectedIndexChanged` SetChangedControl + ClearDataSource (cs:854) | `setSearchParams({divisionId})` 하위 리셋 + `filters={}` 그리드 clear | SRCH-07 |
| `Clb*_SelectedIndexChanged` + ClearDataSource (cs:861-883) | `changeCondition`/`changeLineParent` + `clearMainFilters()` | 조회조건 변경 전건 그리드 clear |
| `FindButton`→`FindData_PlanGroup` (cs:346) | `handleSearch`→`setMainFilters()` → useTabProcQuery(main) | refetch 직접 호출 금지(§5-1) |

## 2. 레이아웃·버튼·권한 (영역1, 01_layout)

| AS-IS (cs:line) | TO-BE | 비고 |
|---|---|---|
| `btnPlanGroupReg` 그룹권한 Visibility (cs:146-153) | `hasButton('PLAN_GROUP_REG')` → customButton 렌더 게이트 | **그룹 하드코딩 금지 AUTH-11** — 버튼권한 메타 치환(05_register.sql) |
| `BtnPlanGroupReg_Click` 팝업 + OK 재조회 (cs:888-904) | `PlanGroupInfoModal` open + `handlePlanGroupRegistered`(refetchSearchInfo + invalidateCombos['PlanGroup']) | 팝업 본문(등록 그리드)=자매 스코프(셸만, R3) |
| `SetDivisionAuthCheck(usrLayoutControl2)` Division 0건 (cs:130) | Form `disabled` + `MSG00097` toast 1회 | R2 |
| `EditButton` SwitchLock/LockColumn 전열 (cs:369-377) | **미이식**(§2.4) — `canEdit=hasButton('EDIT')` mount 1회 | 편집모드 상태(edit-mode store) 신설 금지. EDIT 권한축 메타만 유지 |
| 조회 직후 `LockColumn(0,max)` (cs:445) | **미이식**(§2.4) — 조회모드 복귀 없음 | R5 |
| `SaveButton` `fps==null` 가드 (cs:381) | `handleSave` `if(!grid)return` | R6 |
| `FindButton/SaveButton/InsertButton` override (cs:346-384) | hotkeyConfig search/save/insert = `hasButton && canEdit` | AUTH-01/04/10 |
| **DeleteButton override 없음**(entryPoints 4=Find/Save/Edit/Insert, cs 00 §4) | hotkeyConfig `delete=false`(미노출) | GAP-06 — AS-IS 미존재 버튼 비노출. 기존행 삭제는 Plan Group 공백화('D')로만. DB DELETE 메타는 v3 등록분 잔존(무해, rollback 사용자 축) |
| `Clb*_SelectedIndexChanged` 조회조건/Division 변경 시 미저장 편집 처리 | Form Division onChange·changeCondition 을 `confirmIfDirtyKey(tabDirtyKey(tabId),'search')`(MSG00704)로 감쌈 | GAP-01 — 편집가능 그리드라 clear 전 confirm. 취소 시 controlled 콤보 복귀(커밋 51d4e9fa/TactTime 패턴) |
| `SaveButton` 저장 확인창 | **없음**(AS-IS Save_Data cs:509-846 에 확인창 없음) | GAP-02 — MSG00001(필수 메시지) 재사용 확인창 제거. convert-core §2.4 엉뚱한 코드 재사용 금지 |

## 3. 그리드·셀·저장 (영역3, 03_grid)

| AS-IS (cs:line) | TO-BE | 비고 |
|---|---|---|
| `spdMain` 11컬럼 DB 메타 구동 (SetSheetHeaderColumnSCP cs:306) | `staticColumns` admin fetch(`/admin/menu/SCP0121/column`, sheet 'Plan Group Master' 11행) | 하드코딩 금지 |
| 키 1~7 LockColumn (cs:375) | 메타 INPUT_TP_CD='S' 컬럼속성 유지(모드 아님) | W1 |
| `OPMZ_PLAN_GR_ID` 셀콤보 SetComBoParam("PlanGroup", dtPlanGroup) (cs:304) | 메타 cellCboDataTp='PlanGroup' + attribute2 `DIVISION_ID:DIVISION_ID` 보정(행 division 좁힘) | §6-3 해소(클라 PARAM2 필터형) |
| `SpdMain_CellDoubleClick`→Item 팝업 SetText (cs:912-932) | Grid `dblClick`→`ItemByDivisionModal`(callFromCell, division=행값)→`setItemId`(editTracker) | W7 |
| `SpdMain_ClipboardPasted` NAME→CODE (cs:946-960) | Grid `initialized` → `pastingCell` 핸들러에서 `resolvePlanGroupCode(붙인값, 행 division 후보)` 로 NAME→CODE 치환. 역조회원=`dataMap.getDisplayValues(행)`(행 division 좁힘). 미매칭 무변경 | W8 — GAP-04(명시 배선, Wijmo coerce 의존 제거). 공용 `clearOutOfListComboOnPaste`(후보 밖 clear) 뒤 실행. salesCompanyGuard 규약(전역 getKeyValue 금지) |
| `spdMain_CellClick` `_currRowIdx` (cs:906) | `grid.selectedItems[0]` (Insert 복사원본) | W6 |
| `InsertButton`→`Insert_Row` 현재행 키복사+잠금 (cs:351-503) | `handleInsert` 선택행 키 1~7 복사 + 복사원본 없으면 가드 return | W5, `?? 기본값` 폴백 금지(§2.4) |
| `Save_Data` I/M/D + `^` 결합 10파라미터 (cs:545-782) | `buildActionRows`/`buildSavePayload` + `useSaveWithValidation(dirty, staticColumns, mutate)` → `apiClient.post(.../SAVE/call-proc)` | GAP-05 공용 필수검증 병행. SP MISSING(convert-sp). false-success 판별(§5-10) |
| 저장검증 MSG00001/MSG00443/literal×2 (cs:577-741, **dtmain 전체 대조**) | `usePlanGroupMasterValidation` W9/W10/W11/W12 — `validate(actionRows, source)` 변경행을 **그리드 전체 source** 와 row-count 대조. W9=MSG00013(필수)·W10=MSG00060(중복키) | GAP-03 — cs:688-745 재현. **GAP-11(iter-6): AS-IS MSG00001/00443 재사용 금지 → TO-BE 문구 역매핑(MSG00013/00060, 2026-10-13 실측)**. literal W11/W12 TO-BE 미등록(0행) → MSG-05 등록 요청, '_' fallback(GAP-07 확인필요) |
| 저장결과 MSG00004/errorMsg/exception (cs:822-839) | `handleSave` 성공 toast(MSG00672 "{0} data saved" `.replace`) / 실패 alert(서버 msg ?? MSG00618) / 변경없음(MSG00004) / finally | W13~W15. **GAP-11(iter-6): AS-IS MSG00004 재사용 시 성공 toast 에 "변경없음" → SAVE_SUCCESS=MSG00672·NO_CHANGE=MSG00004·SAVE_FAIL=MSG00618 역매핑** |

## 4. dead / 미이식 (조용한 제외 금지 — §1)

- `SpdMain_ActiveSheetChanged`(cs:327) / `SpdMain_ComboSelChange`(cs:938): `InitEvent` 배선 주석처리 → **미배선(dead)**. 이식 대상 아님(00_checklist §2 주의).
- `EditButton` 편집모드 토글(cs:369-377) + 조회후 전열잠금(cs:445): **§2.4 미이식**(ANL-06). canEdit 대체. 근거 본 문서 §2.
- `dtType`(GET_SEARCH_INFO targetList): 보이는 조회조건 아님 — Plan Group 등록 팝업 입력(자매 스코프). FE 조회조건 미사용.
