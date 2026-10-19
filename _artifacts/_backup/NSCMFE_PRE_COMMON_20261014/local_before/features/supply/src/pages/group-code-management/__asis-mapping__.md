# SCP0080 (Model Code Master / GroupCodeManagement) — AS-IS ↔ TO-BE 대사표

- AS-IS 정본: `.atlas/gscm-design/SCP0080/roslyn/SCP0080_GroupCodeManagement.json` (WinForms GroupCodeManagement)
- 설계 근거: `design/00_overview.md` · `01_layout.md` · `02_search-combo.md` · `03_grid.md` · `04_react-gap.md` · `05_runtime-parity.md`
- TO-BE 경로: `nscm-fe/features/supply/src/pages/group-code-management/`
- 자매 화면: SCP0048(ProjectRoute Warranty) · SCP0027(ProjectRoute Electrode) — 편집형 그리드 + admin 동적 속성 동일 패턴

## 레이아웃 (design/01)

| AS-IS | TO-BE 위치 | 상태 |
|---|---|---|
| cboDivision(단일 필수) | `GroupCodeManagementForm.tsx:66~85` CustomDropdown Division_SCP_NoEE | 구현 |
| clbOperation(다중 체크리스트) | `GroupCodeManagementForm.tsx:86~113` CustomDropdown 다중 + 클라 필터 | 구현 |
| txtModel | `GroupCodeManagementForm.tsx:114~132` InputField multiline | 구현 |
| txtNickname | `GroupCodeManagementForm.tsx:134~153` InputField multiline | 구현 |
| chkFCST/Production | `GroupCodeManagementForm.tsx:155~175` Checkbox | 구현 |
| chkActive/BOM (Visible=false) | 렌더 생략(파리티) | 구현 |
| spd40 / spd81 / spdEtc(FpSpread 3종) | 단일 DataGrid + division 별 레이아웃(staticColumns) | 구현 |

## 조회조건 (design/02 §5)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| Division (BLUtils.GetDivisionWithoutEE) | `group-code-management.constants.ts:52` `Division_SCP_NoEE` (권한+EE제외 내장) | 구현 |
| Operation (Data_SCP.Common OperationForPlanDivisionId) | `constants.ts:53` `OperationForPlanDivisionId1_SCP_ALL` 전량 로드 후 클라 필터 | 구현 |
| Model → p_model_id | `Form.tsx:127` sc.model 개행 다중값 그대로 전달 | 구현 |
| NickName → p_nick_name | `Form.tsx:148` sc.nickName 개행 다중값 그대로 전달 | 구현 |
| FCST/Production/Active/BOM Y/N | sc.checkFcst 등 | 구현 |

## 그리드 (design/03)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| 컬럼 메타 (division 별 40/81계열/82 레이아웃) | `staticColumns[RESPONSE_SET.MAIN]` SCM_MST_SHEET_COLUMNS 동적(PROGRAM_ID=SCP0080) | 구현 |
| 편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이아웃별) | `editLock.ts:23` EDITABLE_COLUMNS + `Grid.tsx:105~111` beginningEdit white-list | 구현 |
| spdMain_CellDoubleClick RTFGubun 팝업(div=82 GROUP_CODE5) | `editLock.ts:100` isRtfGubunCell + `Grid.tsx:163` RTFGubun dblclick + `tsx:199~209` handleRtfSelected | 구현(E1 해소) |
| spdMain_KeyPress R-KEYBLOCK(RTFGubun 셀 직접입력 차단) | `Grid.tsx:122~136` keydown capture(ESC/Ctrl/Meta/Alt 제외 차단) | 구현 |
| UserInfoPopup PIC 검색(div=82) | `tsx:281` onPicCellDblClick + SsoUserModal | 구현 |
| SpdMain_Change PIC_ID guard | `editLock.ts:99` isPicPopupCell | 구현 |

## 저장 검증

| AS-IS | TO-BE | 상태 |
|---|---|---|
| MSG00048 날짜 순서 검증(line 975) | `constants.ts` MSG.DATE_ORDER | 구현 |
| MSG00251 PIC 미검증(line 1436) | `constants.ts` MSG.PIC_CHECK | 구현 |
| MSG00133 무변경(line) | `constants.ts` MSG.NO_CHANGE | 구현 |
| MSG00004 저장 성공 | `constants.ts` MSG.SAVE_SUCCESS + `tsx:126` setToast | 구현 |
| MSG00284 저장 결과 | `constants.ts` MSG.SAVE_RESULT | 구현 |

## SAVE

| AS-IS | TO-BE | 상태 |
|---|---|---|
| SCP0080_SAVE (40 params, SaveData_Main line 1115) | `handleSave` (tsx:141) → PKG_SCP0080.P_SCP0080_SAVE (42 args, VALID) | 구현 |
| SCP0050_GET_CAPA_PIC_USERINFO_POPUP (CheckUser line 1417) | API_URL = PKG_SCP0080.P_SCP0050_GET_CAPA_PIC_USERINFO_POPUP (06_pic_check_apiurl_fix.sql 적용, PKG_SCP0080 VALID) | 구현(PIC_CHECK 미배포 참조 함정 해소) |

## CRUD 버튼

| 버튼 | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| SEARCH | 실동작 | `hotkeyConfig.search` hasButton('SEARCH') → handleSearch | 구현 |
| EDIT | 편집 토글 | customButtons hasButton('EDIT') → handleEditToggle (tsx:256~270) | 구현 |
| SAVE | 실동작(편집모드) | `hotkeyConfig.save` hasButton('SAVE') && isEditMode → handleSave | 구현 |
| INSERT | 무동작(AS-IS 미구현) | `hotkeyConfig.insert` → () => undefined (NO-OP) | 구현(파리티) |
| DELETE | 무동작(AS-IS 미구현) | `hotkeyConfig.delete` → () => undefined (NO-OP) | 구현(파리티) |
| EXCEL | 실동작 | SubTitle 자동(excelFileName='GroupCodeManagement') | 구현 |
| MANUAL/UPLOAD | 없음 | false | 해당없음 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 7항목)

| ID | 요지 | 구현 위치 file:line | 사유 | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터 유지(keepRowVisibleUnderFilter — 필터 clear 금지) | — | 해당없음: INSERT 무동작(AS-IS 미구현, `GroupCodeManagement.tsx` hotkeyConfig.insert = () => undefined NO-OP) — 필터 하 행 추가 자체가 없음 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = confirm | 공용 DataGrid 자동 등록 `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:564` registerDirtyCheck. 편집모드 EditTracker 대상 |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 Reset 후 재조회 | — | 해당없음: Column/Measure 설정 UI(ColumnLayoutModal/MeasureSelectModal) 없음. 컬럼은 SCM_MST_SHEET_COLUMNS admin 메타 구동(fetchStaticColumns), PIVOT measure 없음(SHEET_MEASURE 0행) | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast | `GroupCodeManagement.tsx:126` `setToast`(저장 성공, MSG.SAVE_RESULT). 오류만 setAlert |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼이 Code 아닌 Name 출력(gridAction dataMap 승계) | SubTitle 자동 excel(`GroupCodeManagement.tsx:253` excelFileName) → 공용 gridAction dataMap 스냅샷, 셀콤보 dataMap 으로 NAME 출력 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 다중 입력 시 전건 조회 | `GroupCodeManagementForm.tsx:114~153` Model/NickName InputField multiline(개행 다중값→p_model_id/p_nick_name SP 그대로) + Operation 다중선택 |  | 구현 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 필터 그대로 적용(rebindFilterColumns) | 공용 DataGrid 자동 `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1483` rebindFilterColumns + gridFilterRef(`GroupCodeManagement.tsx:251`) |  | 구현 |

## 미완/확인필요 (정직 보고 — convert-core §4.3, design/04 iter-2 기준)

1. **V-SALES-MODEL(81계열) Contains 검증**: ProductionModels(ITEM_ID) Contains 소스가 GET SP o_rc1 에 없어 FE 재현 불가. 허위 검증 금지 원칙에 따라 재현하지 않음(MERGE 는 UPDATE-only). R2 문서화 한계.
2. **V-SALES-PRIORITY**: AS-IS(cs:743) 항상 disabled(true) — 재현 불필요, 미구현 아님. R2 문서화 한계.
3. **NickName 라벨 LBL 미정의**: SEARCH_LABEL.nickName 은 SCM_ADM_MSG_M 미등록. LBL INSERT 는 convert-core §2.3 범위 밖(임시 하드코딩 금지) → defaultValue('NickName') 만 사용. R3 범위 밖.
