# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-3-001 | W1 SmartColMerge(cs:153) TopChange 재병합 | components/ScpBomElecGrid.tsx:42-56 (allowMerging Cells + MERGE_COLUMNS 4컬럼) | | 구현 |
| D00-3-002 | W2 ChangeActiveSheet(cs:185) InitSpread | | 단일 그리드로 소멸 — Except 시트 미구현(design 01 R5), 활성시트 전환 개념 없음 | 해당없음 |
| D00-3-003 | W3 SmartColMerge(cs:195) SetSpreadInit 초기병합 | components/ScpBomElecGrid.tsx:42-56 | | 구현 |
| D00-3-004 | R5 VisibleTab(cs:196) 시트탭 | | 단일 DataGrid — 시트탭 UI 없음(단일 시트 SCP BOM Elec) | 해당없음 |
| D00-3-005 | W4 SwitchLock(cs:248) EditButton 편집모드 토글 | | EDIT 모드 토글 어포던스 미이식(asis_to_tobe.md §11 전 화면 공통, convert-core §2.4). 편집범위는 INPUT_TP_CD 메타로 상시 재현 | 제외 |
| D00-3-006 | W5 LockColumn(cs:252) DIVISION~USAGE 7컬럼 잠금 | components/ScpBomElecGrid.tsx:96 staticColumns (INPUT_TP_CD='S' 7컬럼 메타 소비 — DB 실측) | | 구현 |
| D00-3-007 | W6 LockColumn(cs:253) 감사 4컬럼 잠금 | components/ScpBomElecGrid.tsx:96 staticColumns (INPUT_TP_CD='S' 감사4 메타 소비) | | 구현 |
| D00-3-008 | W7 Rows.Locked(cs:263) SCP_YN 대문자 비 Y/N 행 잠금 | utils/scp-bom-elec.editLock.ts:15-19 isRowLocked + components/ScpBomElecGrid.tsx:61-73 beginningEdit e.cancel | | 구현 |
| D00-3-009 | W8 BackColor(cs:264) 잠금행 LockColor | components/ScpBomElecGrid.tsx:77-88 formatItem ROW_LOCK_BG Gray | | 구현 |
| D00-3-010 | W9 Query(cs:320) 조회결과 바인딩 | ScpBomElec.tsx:52-71 useTabProcQuery O_RC1(o_rc1) rows | | 구현 |
| D00-3-011 | W10 LockColumn(cs:321) 조회직후 전컬럼 잠금 | components/ScpBomElecGrid.tsx:96 staticColumns (S11 상시잠금 / M2 편집 — INPUT_TP_CD 메타 대체) | | 구현 |
| D00-3-012 | W11 SmartColMerge(cs:323) 조회후 병합 | components/ScpBomElecGrid.tsx:42-56 | | 구현 |
| D00-3-013 | W12 IsLockCell(cs:457) CellClick | | AS-IS 조건통과 후 빈 블록(no-op — 소스 확정). Wijmo isReadOnly/beginningEdit 이 대체 | 해당없음 |
| D00-3-014 | W13 ChangeActiveSheet(cs:497) ActiveSheetChanged shtMain 재동기 | | 단일 시트로 소멸 — 활성시트 전환 없음 | 해당없음 |
| D00-4b-001 | Data.Common MyDivision 콤보(cs:36) | components/ScpBomElecForm.tsx:41 useTabComboQueries COMBO.DIVISION (SQL_ID MyDivision — DB USE_YN='Y') | | 구현 |
| D00-4d-001 | SpdMain_CellDoubleClick(cs:138) | | AS-IS 좌표 기록뿐 참조 0건 dead 확정. Wijmo 기본 더블클릭 편집진입이 대체 | 해당없음 |
| D00-4d-002 | SaveButton(cs:231) 저장 | ScpBomElec.tsx:121-135 handleSave (dirty CRUD_TYPE + saveWithValidation) | | 구현 |
| D00-4d-003 | SpdMain_Changed(cs:462) 셀변경 가드후 좌표기록 | ScpBomElec.tsx:36 editTrackerRef + components/ScpBomElecGrid.tsx:94 (공용 EditTracker CRUD_TYPE 흡수) | | 구현 |
| D00-4d-004 | SpdMain_Changed(cs:466) IsLock 가드 | components/ScpBomElecGrid.tsx:61-73 beginningEdit (S 컬럼 메타잠금 + 잠금행 차단 = 변경 선차단) | | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:AlertModal | 저장 실패/필수 안내 AlertModal | ScpBomElec.tsx:27 setAlert (useMessageStore 공용 AlertModal) — 저장 'F' ERR_MESSAGE·Division 필수 안내 | | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터 유지 신규행 Insert (keepRowVisibleUnderFilter) | | INSERT NO-OP(design 01 R4 — base 빈 본문). 신규행 추가 경로 자체가 없어(hotkeyConfig.insert=noop) 필터유지 대상 없음 | 해당없음 |
| COMMON:UC-02 | 수정 중 재조회 confirm (MSG00704) | ScpBomElec.tsx:172 editTrackerRef → DataGrid registerDirtyCheck, SubTitle/SearchArea confirmIfDirtyKey 공용 위임(memory asis-mapping-gate-contract-and-ui-common-axes UC-02) | | 구현 |
| COMMON:UC-03 | 컬럼설정 적용 후 Reset·재조회 | ScpBomElec.tsx:158-167 SubTitle 공용 ColumnLayout(사본 0건) + staticColumns refetch | | 구현 |
| COMMON:UC-04 | CRUD 완료 Toast (Alert 아님) | ScpBomElec.tsx:100-106 setToast success / 128 NO_CHANGE toast, 실패만 setAlert | | 구현 |
| COMMON:UC-05 | Excel 콤보 컬럼 Name 출력 | 셀콤보 2컬럼 SCP_YN·STOCK_SUM = YesOrNo(CODE='Y'=NAME, CODE='N'=NAME — DB 실측). CELL_COMBO_DATA_TYPE 등록(NULL 아님)이라 dataMap 승계, Code=Name 이라 불일치 없음 | | 구현 |
| COMMON:UC-06 | 콤마 다중 조회 | useScpBomElecStore.ts normalizeMulti(개행→콤마) + SP UF_FX_STRING_SPLIT (design 02 §2.3) | | 구현 |
| COMMON:UC-07 | 재조회 후 필터 유지 (rebindFilterColumns) | ScpBomElec.tsx:171 gridFilterRef → DataGrid 공용 rebindFilterColumns 위임 | | 구현 |

## 화면 개요

- 단일 그리드 마스터, 조회 → 편집(2컬럼) → '^' bulk UPDATE 저장. INSERT/DELETE NO-OP. pivot/모달 없음.
- GET `PKG_SCP0097.P_SCP0097_GET_SCP_BOM_ELEC`(IN 4, OUT O_RC1 13컬럼 + O_RESULT_CURSOR).
- SAVE `PKG_SCP0097.P_SCP0097_SAVE_SCP_BOM_ELEC`(IN 8, OUT O_RESULT_CURSOR).

## 1. Validation (4건 — 100% 매핑)

| ID | AS-IS(cs) | 조건 | TO-BE 처분 | 위치 |
|---|---|---|---|---|
| `V1` | GMessageBoxForException (cs:334) | FindData_Main catch | 공통 예외 토스트/AlertModal 흡수 | apiClient 인터셉터 |
| `V2` | MSG00004 (cs:414) — "{0}개 저장" 성공+건수 | rows[0][0]=='S' | `MSG00672`("{0} data saved.") 성공 Toast + invalidate 재조회 (동번호 MSG00004='No changes' 불일치, #114) | `ScpBomElec.tsx` doSave / `MSG.SAVE_SUCCESS` |
| `V3` | MSG00006 (cs:425) — 실패문구 (errorMsg 조립 cs:419~424 는 dead code) | else('S' 아님) | 'F' 시 **ERR_MESSAGE 실표시**(dead code 재현 금지) AlertModal. `MSG.SAVE_FAIL` fallback | `scp-bom-elec.save.ts` callSaveScpBomElec / doSave |
| `V4` | GMessageBoxForException (cs:431) | SaveData_Main catch | 공통 예외 흡수 + false-success 판정(`res.status>=400 || Number(code)`) | `scp-bom-elec.save.ts` |

프레임워크 발화 검증(백본 밖 — design 02 §4 반전 편입):
| Vf1 | checkRequiredOfSearch — Division* 빈값 → MSG00002 의도(필수) | Division 미선택 | `MSG00097`("Please select Division.") alert + 조회 차단 (동번호 MSG00002='Saved successfully.' 재사용 금지) | `useScpBomElecValidation.validateSearch` |
| Vf2 | checkRequiredOfSearch — cboDivision Items 0건 → MSG00097(권한 없음) | 콤보 후보 0건 | `MSG00097` 안내 + SearchArea disable + 조회 차단 | `ScpBomElecForm`(onDivisionAuth) / `ScpBomElec.tsx` handleSearch |
| Vf3 | checkRequiredOfSpread(cs:365) — 그리드 라벨 `*` 필수 | I/M 행 | 라벨 `*` 0건이라 AS-IS 실질 no-op. TO-BE 는 `useSaveWithValidation`(메타 M) 이 더 강한 방어 | `ScpBomElec.tsx` handleSave |

## 2. Button Guard / toolbarOverride (4 override + 부재 2)

| AS-IS override | cs | 가드 | TO-BE |
|---|---|---|---|
| FindButton (cs:220) | checkRequiredOfSearch 사전검증 | 실동작 조회 | `hotkeyConfig.search`=handleSearch (hasButton 곱) |
| SaveButton (cs:231) | fps==null(#2)→sheet→IsLock(Edit모드)→Rows>0→checkRequiredOfSpread→I/M/D 수집 | 실동작 저장. 가드 ③(Edit 모드)은 EDIT 미이식으로 소멸 → dirty 0건 시 NO_CHANGE 안내 | `hotkeyConfig.save`=handleSave, dirty=CRUD_TYPE |
| EditButton (cs:241) | SwitchLock 토글 + 키컬럼 재잠금 + SCP_YN∉{Y,N} 행 잠금 | **미이식**(asis_to_tobe §11). editMode/setEditMode store 금지 | INPUT_TP_CD 메타(M 2) 상시편집 + `isRowLocked` beginningEdit 차단 + Gray |
| InsertButton (부재) | base 빈 본문(BaseForm.cs:3365~3367) = NO-OP | 노출+무동작(자매 SCP0053 실등록 미러) | `hotkeyConfig.insert`=noop(`() => undefined`, hasButton 곱) — false/키 생략 금지 |
| DeleteButton (부재) | base 빈 본문(BaseForm.cs:3369~3371) = NO-OP | 동상 | `hotkeyConfig.delete`=noop |

## 3. gridSignals (14건 — 영역1 R5 1 + 영역3 13)

| W# | cs | 신호 | TO-BE |
|---|---|---|---|
| (R5) | 196 | VisibleTab(true) — 시트탭(단일 시트) | 단일 DataGrid(탭 UI 없음, Except 시트 dead) |
| `W1` | 153 | SmartColMerge — TopChange | Wijmo CustomMergeManager 자동 유지(재수행 불요) |
| `W2` | 185 | ChangeActiveSheet — InitSpread | 단일 그리드로 소멸 |
| `W3` | 195 | SmartColMerge — SetSpreadInit | 병합(§3.4)로 흡수 |
| `W4` | 248 | SwitchLock — EditButton | 미이식(INPUT_TP_CD 메타 상시재현) |
| `W5` | 252 | LockColumn(DIVISION_ID~USAGE) | INPUT_TP_CD='S' 소비(컬럼상수 이식 금지, #130) |
| `W6` | 253 | LockColumn(감사 4) | 동상('S') |
| `W7` | 263 | Rows[i].Locked = SCP_YN.ToUpper()∉{Y,N} | `isRowLocked` + beginningEdit e.cancel |
| `W8` | 264 | Rows[i].BackColor = LockColor | 잠금행 Gray cssClass(#95) `ROW_LOCK_BG` |
| `W9` | 320 | Query(ds) — 결과 바인딩 | `useTabProcQuery` O_RC1 → itemsSource |
| `W10` | 321 | LockColumn(0~Max) 조회직후 전잠금 | INPUT_TP_CD 상시(S11 잠금/M2 편집) 대체 |
| `W11` | 323 | SmartColMerge — 조회후 | 병합(§3.4) |
| `W12` | 457 | IsLockCell — CellClick(빈 블록) | no-op(Wijmo isReadOnly/beginningEdit 대체) — 미배선 |
| `W13` | 496 | ChangeActiveSheet — ActiveSheetChanged(단일시트 재동기) | 단일 그리드로 소멸 |

## 4. Events (8건 — 영역2 1 + 영역3 7)

| 이벤트 | cs | AS-IS | TO-BE |
|---|---|---|---|
| ClbDivision_SelectedIndexChanged | 445~453 | SetChangedControl(빈) + InitSpread(그리드 클리어) | `changeDivision` = searchCondition 갱신 + `clearFilters()`(Grid 비움) |
| dsdmMain.Changed → SpdMain_Changed | 462~478 | 가드 후 셀좌표 기록(미소비) | 공용 EditTracker(CRUD_TYPE) 흡수 — 자체 행상태 필드 금지 |
| spdMain.ActiveSheetChanged | 492 | shtMain 재동기 | 단일 그리드로 소멸 |
| spdMain.CellClick | 455~460 | 가드 후 빈 블록(no-op) | 배선 불요 |
| spdMain.CellDoubleClick | 138~148 | 좌표 기록뿐(참조 0 — dead) | 미배선(Wijmo 기본 편집진입) |
| spdMain.ClipboardPasted | 481~490 | 가드 후 빈 블록(no-op) | 공용 DataGrid paste + EditTracker 흡수('S' 컬럼 paste 차단) |
| spdMain.EditChange | 503~510 | iSCP_YN 취득 후 미사용(파생 0) | 배선 불요(칼럼 간 파생 없음) |
| spdMain.TopChange | 150~155 | W1 재병합 | mergeManager 자동 유지 |

## 5. 데이터소스 / 콤보 매핑

| AS-IS | TO-BE |
|---|---|
| `Data.Common(Type.MyDivision, false, NowGroupID, UserId)`(cs:36) | 콤보 `MyDivision`(SQL_ID, @sesUserId/@mnuId) — EE제외+unit권한 SQL 내장, 클라 필터 0 |
| `SelectCombo(cboDivision,"CODE","81")`(cs:513~519) | Division 기본값 '81' 존재 시 선택·미존재 시 마지막 항목(R6b) — `ScpBomElecForm` effect |
| txtParentID/txtChildID.Text(개행→콤마 UsrMultiLineEditor) | InputField multiline → `normalizeMulti`(개행→콤마, 공백줄 스킵, 미트림) |
| P_DEBUG_MODE='F'(cs:309) | filters.debugMode='F' / save debugMode='F' |

## 6. 미이식·미배선 명세 (조용한 제외 금지 — convert-core §1)

- **EDIT 모드 토글**: asis_to_tobe §11 전 화면 공통 미이식. editMode/setEditMode store 신설 안 함(self-check grep 0). 편집 = INPUT_TP_CD 메타.
- **컬럼메타 정비 선행**: TO-BE `SCM_MST_SHEET_COLUMNS` 13행 전건 INPUT_TP_CD='S' + SCP_YN/STOCK_SUM CELL_COMBO_DATA_TYPE NULL(실측). 정비(SCP_YN·STOCK_SUM → 'M'+YesOrNo) 는 `05_register.sql`(convert 예외 b, 자매 SCP0053 미러). 정비 전엔 전컬럼 read-only.
- **SCM_ADM_PROC_M 등록 완료**: 05_register.sql (h) 로 15행 등록(ora.py 실측). 커서 읽기키(o_rc1)/filters·save 파라미터 키 = PROC_M COL_NM 과 1:1 일치 확인. pickRows 대소문자 방어는 폴백으로 유지.
- **팝업 0**: ProgressForm = 공통 로딩(useTabProcQuery.isFetching) — 신규 불요.
