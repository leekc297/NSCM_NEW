# SCP0131 Sales Site Priority — AS-IS <-> TO-BE 매핑 매트릭스

> convert-core §2.1 Top11 #11: validations / gridSignals / buttonGuards / events 전건 1:1 매핑.
> AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0131_SalesSitePriority/SCP0131_SalesSitePriority.cs`(+`.Designer.cs`).
> **2026-09-26 iter-3 갱신**: iter-1/iter-2 는 이 저장소에서 `.cs`/`.Designer.cs` 원본을 찾지 못했다고
> 기록했으나(`grep -rl "SCP0131" --include=*.cs .` 당시 0건 보고), iter-3 재확인 결과 저장소 루트
> `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0131_SalesSitePriority/` 아래 원본 4파일(`.cs` 1074줄 +
> `.Designer.cs` 698줄 + Resources/Settings Designer)이 실존한다 — 이전 grep 이 저장소 루트가 아닌
> 하위 경로에서 실행됐거나 범위를 놓친 것으로 추정된다(원인 불명, 재발 방지: 이 activity 는 매 회차
> `grep -rl "<code>" --include=*.cs .`(저장소 루트 기준)를 직접 재실행해 원본 존재를 스스로 확인했다).
> 이 발견으로 아래 G04(SmartColMerge)/G05(붙여넣기 isValid)/G06(InsertButton) 확인필요 3건을 원본
> 실측으로 확정했다. 백본: `.atlas/gscm-design/SCP0131/design/00_checklist.md` §2~§4d, `01_layout.md`,
> `02_search-combo.md`, `03_grid-columns.md`(design 문서 자체는 이 activity 소관이 아니라 갱신하지
> 않았다 — 확인필요 표기가 남아 있을 수 있음, design 단계 재검증 필요).
> TO-BE: `features/supply/src/pages/sales-site-priority/`.

## validations (n=12, design 00 §4a)

| # | msgId(AS-IS) | AS-IS 조건 | TO-BE 구현 |
|--:|---|---|---|
| 1 | MSG00001 | division/planGroup/site/item/prioRank/from/to/validYn 중 하나라도 빈값(l616) | `useSalesSitePriorityValidation.validateSaveRows` 1) — MSG.REQUIRED_FIELDS(MSG00013 "Please enter the required fields.") |
| 2 | MSG00260 | 저장 시 안전재고 영향 경고(l641) | **미구현(확인 필요)** — 서버(SAVE SP) 판정 영역, TO-BE `PKG_SCP0131` 미배포로 런타임 검증 불가. 문구 일치 TO-BE MSG_ID 도 미확인(design 02/03 §7 동일 명시) |
| 3 | MSG00046 | 저장 확인 팝업(l662) | 표준 공통 규약으로 대체 — `useSaveWithValidation`/`useProcMutation` 저장 확인 다이얼로그 미배선(자매 SCP0037 동일 — 저장 확인 팝업은 NSCM 표준에 없음, 저장 즉시 실행 + 성공 toast) |
| 4 | MSG00219 | From>To 저장 차단(l669) | `validateSaveRows` 3) — MSG.PERIOD_INVALID(MSG01135 "The start date can not be later than the end date.") |
| 5 | MSG00175 | PRIO_RANK<1 저장 차단(l677) | `validateSaveRows` 2) — MSG.PRIO_MIN(MSG00699 "Please enter an integer greater than 0.") |
| 6 | MSG00458 | Item 존재 확인(l695) | **미구현(확인 필요)** — 서버(SAVE SP) 판정 영역, SP MISSING 으로 런타임 검증 불가. TO-BE MSG01366("ITEM_ID does not exist.") 후보 확인했으나 배선 대상 SP 부재 |
| 7 | MSG00004 | 저장 성공(l783) | `useProcMutation` 표준 onSuccess toast — MSG.SAVE_SUCCESS(MSG00672 "{0} data saved.") |
| 8 | (없음) | 저장 실패 errorMsg(l792) | `useProcMutation` 표준 실패 핸들(서버 메시지 표준 경로) |
| 9 | (없음, GMessageBoxForException) | 예외 발생(l800) | `useProcMutation` 표준 에러 핸들 |
| 10 | MSG00049 | TO_YYYYMMDD 수동편집 형식 오류(SpdMain_EditChange l987~994) | **해결(iter-3)** — 이 검증은 붙여넣기가 아니라 **셀 편집(EditChange)** 전용이다. TO-BE 는 날짜 컬럼이 date picker/typed editor 로 형식을 원천 차단하므로 형식 오류 메시지 자체가 발생하지 않는다 — 미구현이 아니라 "해당 없음"(입력 채널이 달라 재현 대상 아님) |
| 11 | MSG00219 | TO_YYYYMMDD 수동편집 From>To 재검증 + TO 클리어(l999~1004) | **해당 없음(2026-09-26 정정)** — 이 검증의 실제 트리거 `SpdMain_EditChange` 는 AS-IS `InitEvent()` l325 에서 이벤트 구독 자체가 주석처리돼 런타임에 전혀 발동하지 않는 죽은 코드다(runtime-parity-gate SCP0131 v1 G09, react-gap-audit iter-3 적대적 검증으로 확정). iter-3 에서 `cellEditEnded` 핸들러로 이 로직을 살려 AS-IS 에 없던 신규 동작을 추가했었으나, AS-IS 와 동일하게 구현하기 위해 제거했다 — From>To 는 #4 저장 시점 차단(`validateSaveRows`)만으로 재현 |
| 12 | MSG00049 | FROM_YYYYMMDD 수동편집 형식 오류(l1024~1028) | 위 #10 과 동일 사유로 "해당 없음"(date picker 형식 원천 차단) |

## buttonGuards (n=5, design 00 §4d) + override 미매칭 2건

| # | method | AS-IS 조건 | TO-BE 구현 |
|--:|---|---|---|
| 1 | DeleteButton | `fps==null` early-return, 메시지 없음(l362) | `SalesSitePriority.handleDelete` — `if(!selected) return`(무메시지) |
| 2 | spdMain_CellClick | `!siMain.IsLock(sheetName)`(l867) | 상시편집 모드 대체(design 01 §5#4 대체 근거 참조) — 전용 게이트 미배선(자매 SCP0037 선례와 동일) |
| 3 | spdMain_CellClick | `action!=FlagI && !this._isEditMode`(l884) | `isItemPopupCell`이 binding==='ITEM_ID' 만 게이트 — 신규/기존행 불문 팝업 허용(design 01 §5#4 상시편집 대체와 일관) |
| 4 | SpdMain_CellDoubleClick | `!e.ColumnHeader`(l917) | DataGrid `hitTest.cellType===CellType.Cell` 로 헤더 더블클릭 배제 |
| 5 | SpdMain_CellDoubleClick | `IsLock \|\| (action!=FlagI) && !_isEditMode`(l920) | 상시편집 대체(#2/#3과 동일) |
| - | EditButton override 본문 | **해결(iter-3)** — 원본 확인: 실동작(SwitchLock() + LockColumn(DIVISION_ID) + LockColumn(CREATED_BY~PRE_KEY_VALUES) + `_isEditMode=true`, l369~380) | **미배선(확정 유지)** — hotkeyConfig 에 edit 키 없음. TO-BE 등록 버튼(`SCM_ADM_MNU_BTN_MPG_M` MNU_ID='SCP0131' 4행 SEARCH/INSERT/SAVE/DELETE, EDIT 없음)이 이미 EDIT 버튼 자체를 배제하고 있어, 자매 SCP0037 상시편집 대체가 최종 설계로 확정된다(AS-IS 는 실동작이었지만 TO-BE 버튼 카탈로그가 다르게 결정됨 — admin 정책 사항, 코드 결함 아님) |
| - | InsertButton override 본문 | **해결(iter-3)** — 원본 확인: 실동작(Insert_Row() 호출, l355~358) — Insert_Row 본문(l503~521)은 `siMain.Insert()`로 행 삽입 후 `DIVISION_ID`=조회조건 division, `VALID_YN`='Y' 기본값 설정, DIVISION_ID·감사4칸 LockRange | **구현 확정** — `handleInsert`(division 확정 조건부 배선) + `insertDefaults`(DIVISION_ID + `VALID_YN='Y'`, iter-3 에서 VALID_YN 기본값 추가 수정). 01_layout.md §2#5 "최종 확정 전 미완" 유보 해제 — 원본과 1:1 일치 확인 |

## events (n=6, design 00 §2)

| # | control.event | AS-IS handler | TO-BE 구현 |
|--:|---|---|---|
| 1 | btnItemId.Click | btnItemId_Click(l952) | `SalesSitePriorityForm` 돋보기 버튼 onClick -> `setOpenItemModal(true)` -> MaterialByDivisionModal open |
| 2 | cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged(l836) | `SalesSitePriorityForm` Division onChange -> planGroupIds/siteIds cascade 초기화 |
| 3 | spdMain.CellClick | spdMain_CellClick(l863) | `SalesSitePriorityGrid` — Plan Group 셀 division 기준 재필터(filterCalls#6)는 **미구현(확인 필요)** — admin PARAM2 등록 여부에 따라 자동콤보 경로로 대체 예정, 05_register.sql 참조 |
| 4 | spdMain.CellDoubleClick | SpdMain_CellDoubleClick(l915) | `SalesSitePriorityGrid` dblclickHandler — ITEM_ID 팝업 오픈(MaterialByDivisionModal 재사용) |
| 5 | spdMain.ClipboardPasted | SpdMain_ClipboardPasted(l1050) — 본문은 Plan Group NAME->CODE 변환 1건뿐(원본 확인, l1060~1065) | **해결(iter-3)** — `SalesSitePriorityGrid.tsx` `pastedCell` 핸들러(OPMZ_PLAN_GR_ID 바인딩) + `findPlanGroupCodeByName`(cascadeCombo.ts) |
| 6 | spdMain.TopChange | SpdMain_TopChange(l851) — `siMain.SmartColMerge()` 호출 | **해결(iter-3, 대응 없음 확정)** — 호출은 있으나 이 화면은 어떤 컬럼에도 `MergePolicy.Restricted` 를 설정하지 않아(Designer.cs grep 0건) `SmartColMergeOld()`(프레임워크 `SpreadInfo.cs:10405`) 진입 시 숨은 헬퍼 컬럼만 갱신하고 시각적 병합은 발생하지 않는다 — AS-IS 자체가 무병합이므로 TO-BE 대응 불필요(추측이 아니라 프레임워크 소스 실측) |

## gridSignals (n=15, design 00 §3) — 규칙 그룹 매핑

| gridSignal(line) | 카테고리 | AS-IS | TO-BE |
|---|---|---|---|
| SetSheetHeaderColumnSCP(315) | other | 시트 헤더 컬럼 초기 세팅 | 공용 DataGrid staticColumns(admin 메타) 초기화로 대체 |
| Delete(365) | other | 삭제 실행(가드는 buttonGuards#1) | `handleDelete` — `GridAction.removeRow(grid)` |
| SwitchLock(374) | lock(영역1) | 시트 전체 Lock/Unlock 토글(EditButton) | **대체(확정, iter-3)** — 실동작 확인됐으나 TO-BE 버튼 카탈로그에 EDIT 이 없어(admin 정책) 상시편집 모드로 대체 |
| LockColumn(375) | lock | DIVISION_ID 항상 편집 불가 | `isCellEditable` — DIVISION_ID 는 EDITABLE_COLUMNS 밖(자동 차단) |
| LockColumn(377) | lock | 감사4칸+PRE_KEY_VALUES 항상 편집 불가 | `isCellEditable` — 동일(EDITABLE_COLUMNS 밖) |
| Query(461, dataSource) | dataSource | GET SP 결과 바인딩 | `useTabProcQuery` data.o_rc1 -> DataGrid itemsSource |
| LockColumn(462) | lock | 조회 직후 전체 read-only | **대체(확정, iter-3)** — 상시편집 white-list 로 대체(#SwitchLock 과 동일 근거) |
| Insert(507) | other | 신규 행 삽입 | `GridAction.addRow(insertDefaults(division))` |
| SetValue(516) | value | 신규행 기본값(defaultData: DIVISION_ID, VALID_YN="Y") | **해결(iter-3)** — `insertDefaults` DIVISION_ID(확정값) + `VALID_YN: 'Y'`(원본 실측 반영, iter-3 수정) |
| LockRange(518) | lock | 신규행 DIVISION_ID 잠금 | `isCellEditable` 로 통합 처리(신규/기존행 공통 화이트리스트) |
| LockRange(519) | lock | 신규행 감사4칸 잠금 | `isCellEditable` 로 통합 처리 |
| SmartColMerge(854) | merge | 셀 병합 재계산(SpdMain_TopChange 내부) | **해결(iter-3, 대응 없음 확정)** — 프레임워크 `SpreadInfo.SmartColMergeOld()` 실측: 이 화면 어떤 컬럼도 `MergePolicy.Restricted` 미설정이라 시각적 병합이 발생하지 않는다. "미구현"이 아니라 "AS-IS 도 무병합" — TO-BE 대응 불필요 |
| SetText(945) | value | ITEM_ID <- 팝업 sItemId | `applyItemSelect(row, itemId)` |
| SetValue(1004) | value | TO_YYYYMMDD 클리어(수동편집 From>To 검증 실패 시, SpdMain_EditChange) | **해당 없음(2026-09-26 정정)** — 트리거 `SpdMain_EditChange` 구독이 AS-IS 에서 주석처리돼 죽은 코드다(위 validations#11 참조). TO-BE 도 대응 로직(`clearToDate`)을 제거해 AS-IS 와 동일화 |
| SetValue(1064) | value | OPMZ_PLAN_GR_ID <- 붙여넣기 NAME 매칭 codeVal(ClipboardPasted, l1064) | **해결(iter-3)** — line 863(spdMain_CellClick)의 콤보 렌더링과 line 1064(ClipboardPasted)의 붙여넣기 변환은 서로 다른 이벤트다. 후자는 `pastedCell` 핸들러 + `findPlanGroupCodeByName` 로 구현. 전자(division cascade 콤보 렌더)는 events#3 과 동일 — admin PARAM2 등록 여부에 의존, 별건 |

## 미이관/대체 정직 표기 (convert-core §4.3)

- **EditButton/InsertButton override 본문 — iter-3 해결**: 2026-09-26 저장소 루트 `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0131_SalesSitePriority/SCP0131_SalesSitePriority.cs`(1074줄)+`.Designer.cs`(698줄) 원본을 재확인해 확보했다(iter-1/iter-2 의 "저장소 전체 grep 0건" 보고는 재현되지 않음 — 원인 불명이나 이번 회차엔 `grep -rl "SCP0131" --include=*.cs .` 로 4개 파일 즉시 확인됨). InsertButton=Insert_Row 실동작(division+VALID_YN='Y' 기본값, l503~521), EditButton=SwitchLock+LockColumn 실동작(l369~380) 확정. TO-BE 는 InsertButton 을 그대로 구현(`insertDefaults` VALID_YN='Y' 반영)하고, EditButton 은 TO-BE 버튼 카탈로그(`SCM_ADM_MNU_BTN_MPG_M` 4행에 EDIT 없음, admin 정책)에 따라 상시편집 대체를 최종 설계로 확정한다. **전환 완료 간주**(01_layout.md §2#5 유보 해제). (gap-audit iter-1 SCP0131-G06, 해결)
- **셀 병합(SmartColMerge, line854) — iter-3 해결**: 프레임워크 원본(`GSCM/01.Framework/GSCM.Windows.Forms/Class/SpreadInfo.cs:10114,10405`)까지 추적해 `SmartColMergeOld()` 로직을 실측했다 — 병합은 `MergePolicy.Restricted` 가 설정된 컬럼에서만 발생하는데, 이 화면 Designer.cs 에는 어떤 컬럼에도 이 정책이 설정돼 있지 않다(`grep -n "Restricted\|ColumnMerge\|MergePolicy"` 0건). 즉 AS-IS 자체가 이 화면에서 시각적 병합을 만들지 않는다 — "미구현"이 아니라 "대응 대상 없음"으로 확정한다. (gap-audit iter-1 SCP0131-G04, 해결)
- **Plan Group 셀 division 재필터(filterCalls#6, gridSignals#15) — iter-2 해결**: `SCM_MST_SHEET_COLUMNS.ATTRIBUTE2`(PARAM2)를 `OPMZ_PLAN_GR_ID`에 `'DIVISION_ID:DIVISION_ID'`(필터모드 표준 형식)로 등록·적용 완료(`05_register.sql`, `ora.py exec` 재조회 확인). `PlanGroup` SQL_ID가 DIVISION_ID 컬럼을 반환함을 실측 확인했으므로 division 좁힘이 공용 DataGrid 자동콤보 경로로 재현된다. (gap-audit iter-1 SCP0131-G02, 해결)
- **붙여넣기(ClipboardPasted)/수동편집(EditChange) 경로 — 2026-09-26 정정**: ClipboardPasted(l1050~1070) 는 Plan Group NAME->CODE 변환만 수행(From/To 검증 없음) — `pastedCell` 핸들러(OPMZ_PLAN_GR_ID) + `findPlanGroupCodeByName` 로 구현, 유지. EditChange(l973~1031, TO_YYYYMMDD From>To 재검증 + `clearToDate`)는 이전 회차가 `cellEditEnded` 핸들러로 살려 구현했으나, `InitEvent()` l325 에서 `SpdMain_EditChange` 이벤트 구독 자체가 주석처리돼 있어 AS-IS 런타임에서 전혀 발동하지 않는 죽은 코드임이 확정됐다(runtime-parity-gate SCP0131 v1 G09). AS-IS 와 동일하게 구현하기 위해 `cellEditEnded` 핸들러와 `clearToDate` 를 제거했다 — From>To 검증은 #4 저장 시점(`validateSaveRows`)만 유효하다. 날짜 형식 오류(MSG00049)는 TO-BE date picker 가 형식을 원천 차단해 해당 없음. (gap-audit iter-1/iter-2 SCP0131-G05 해결, runtime-parity-gate v1 G09 정정 완료)
- **안전재고 경고(MSG00260)/Item 존재확인(MSG00458)**: 서버(SAVE SP) 판정 영역이며 `PKG_SCP0131` 미배포로 런타임 검증이 애초에 불가능하다 — FE 배선 대상이 아니므로 미구현.
- **콤보 데이터소스 3종(Plan Group/Site/Valid) — iter-2 재확인**: `PlanGroup`(등록 확인, 조회조건 클라 필터로 사용 — DIVISION_ID 반환 실측 확인) / `ScmSite`(응답에 CODE/NAME만 있고 별도 콤보 SQL_ID 등록 없음 — 그리드 셀은 조회조건과 동일 `SiteMasterAll_SCP` 로 iter-2 에서 재배선, `05_register.sql`) / `ValidYn`(그리드 셀은 `YesOrNo` 로 iter-2 에서 재배선). 조회조건 Site 콤보의 클라 cascade 필터 결함(SCP0131-G01, 데이터 계약 불일치)은 iter-2 에서 서버 `@divisionId` 파라미터 방식으로 해결 — 상세는 `SalesSitePriorityForm.tsx` 주석·impl-notes.md 참조. (gap-audit iter-1 SCP0131-G01/G03, 해결)
- **ITEM_ID 그리드 셀 CTL 메타 표준화 — 확인 필요(유지)**: `FPModal` CTL 등록이 표준(SCP0001 전례)이나, 이 화면은 이미 화면 자체 dblclick 핸들러(`isItemPopupCell`)로 팝업을 트리거하고 있어 CTL 값이 렌더링에 영향을 주지 않는다 — admin 메타 표준화 여부는 근거 부족으로 이번 회차에 반영하지 않음(사용자 판단 필요). (gap-audit iter-1 SCP0131-G07, 미해결)
- **TO-BE `PKG_SCP0131`/`PKG_SCP0128` 미배포** -> 조회/저장 런타임 전체 미검증(convert-sp 후속). GET/SAVE 계약은 design 03 §4.
- **메뉴/권한 게이트 — iter-2 등록 완료**: `SCM_ADM_MNU_M`/`SCM_ADM_MSG_M`/`SCM_ADM_USER_GR_MNU_MPG_M`/`SCM_ADM_API_M`/`SCM_ADM_MNU_BTN_MPG_M`/`SCM_ADM_USER_GR_MNU_BTN_MPG_M` 전부 자매 SCP0122 실등록행 미러로 등록·`ora.py exec` 적용·재조회 확인(`05_register.sql`). PKG 배포는 여전히 convert-sp 소관.

## UI 공통(통합테스트) 체크 축

> 원천: 통합테스트 사전점검 Common 축. 자매 SCP0037 와 동일하게 공용 DataGrid/GridAction/useSaveWithValidation/useProcMutation 인프라를 그대로 위임 소비하며 화면 자체 override·opt-out 이 없다. 실제 화면 육안 동작은 사용자 확인 축(미확인).

| ID | 요지 | 구현 위치 | 상태 |
|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지 | 공용 DataGrid(keepRowVisibleUnderFilter) + SalesSitePriority.tsx handleInsert(화면 자체 필터 clear 없음) | 구현(패턴 위임) |
| COMMON:UC-02 | 수정 중 다른 데이터 조회 시 confirm | 공용 DataGrid registerDirtyCheck + editTrackerRef 배선 | 구현(패턴 위임) |
| COMMON:UC-03 | 컬럼 설정 적용 시 재조회 유도 | useSalesSitePriorityStore.fetchStaticColumns + mount/Search 재조회. Measure 없음(pivot X) | 구현(패턴 위임) |
| COMMON:UC-04 | CRUD 완료 알림 = Toast | setToast + useProcMutation/saveWithValidation 표준 성공 toast | 구현(패턴 위임) |
| COMMON:UC-05 | Excel Download 콤보 Name 출력 | SubTitle excelFileName(공용 DataGrid dataMap 승계) | 구현(패턴 위임) |
| COMMON:UC-06 | 콤마 다중 조회조건 전건 조회 | useSalesSitePriorityStore.setFilter(planGroupIds/siteIds join(',')) — 런타임은 PKG 배포 후 실검증 | 구현(배선만, 런타임 미검증) |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 필터 유지 | gridFilterRef + 공용 DataGrid(rebindFilterColumns) | 구현(패턴 위임) |
