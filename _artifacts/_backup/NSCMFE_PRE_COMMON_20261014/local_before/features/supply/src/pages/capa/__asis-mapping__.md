# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-4b-001 | §4b Data.Common / MyDivision / dtMyDivision | components/CapaForm.tsx:40 COMBO.DIVISION (MyDivision) |  | 구현 |
| D00-4b-002 | §4b Data_SCP.Common / LaneQtyOfLineAssign / dtLaneQtyOfLineAssign | 그리드 셀콤보 — SCM_MST_SHEET_COLUMNS LANE_QTY CELL_COMBO_DATA_TYPE=LaneQtyOfLineAssign_SCP(DB 실측) + CapaGrid staticColumns |  | 구현 |
| D00-4b-003 | §4b Data_SCP.Common / ShopGroupId / dtShopGroup | components/CapaForm.tsx:41 COMBO.GROUP (ShopGroupId_SCP) |  | 구현 |
| D00-4b-004 | §4b Data_SCP.Common / PlantByGroup / dtPlantByGroup | components/CapaForm.tsx:42 COMBO.PLANT (PlantByGroup_SCP) |  | 구현 |
| D00-4b-005 | §4b Data_SCP.Common / BuildingByShopGroupId / dtBuildingByShopGroupId | components/CapaForm.tsx:41 COMBO.GROUP (ShopGroupId_SCP) |  | 구현 |
| D00-4b-006 | §4b Data_SCP.Common / LineByOperationPlantId / dtLineByOperationPlantId | components/CapaForm.tsx:45 COMBO.LINE (LineByOperationPlantId_SCP) |  | 구현 |
| D00-4b-007 | §4b Data.Common / OperationByLine / dtOperationByLine | components/CapaForm.tsx:52 COMBO.OPERATION (OperationByLine) |  | 구현 |
| D00-4b-008 | §4b Data_SCP.Common / LaneQtyOfLineAssign / dtLaneQtyOfLineAssign | 그리드 셀콤보 — SCM_MST_SHEET_COLUMNS LANE_QTY CELL_COMBO_DATA_TYPE=LaneQtyOfLineAssign_SCP(DB 실측) + CapaGrid staticColumns |  | 구현 |
| D00-4b-009 | §4b Data_SCP.Common / LaneQtyOfLineAssign / dtLaneQtyOfLineAssign | 그리드 셀콤보 — SCM_MST_SHEET_COLUMNS LANE_QTY CELL_COMBO_DATA_TYPE=LaneQtyOfLineAssign_SCP(DB 실측) + CapaGrid staticColumns |  | 구현 |
| D00-4b-010 | §4b Data_SCP.Common / LaneQtyOfLineAssign / dtLaneQtyOfLineAssign | 그리드 셀콤보 — SCM_MST_SHEET_COLUMNS LANE_QTY CELL_COMBO_DATA_TYPE=LaneQtyOfLineAssign_SCP(DB 실측) + CapaGrid staticColumns |  | 구현 |
| D00-4b-011 | §4b Data_SCP.Common / PlantByGroup / dtPlantByGroup | components/CapaForm.tsx:42 COMBO.PLANT (PlantByGroup_SCP) |  | 구현 |
| D00-4b-012 | §4b Data_SCP.Common / BuildingByShopGroupId / dtBuildingByShopGroupId | components/CapaForm.tsx:41 COMBO.GROUP (ShopGroupId_SCP) |  | 구현 |
| D00-4b-013 | §4b Data_SCP.Common / LineByOperationPlantId / dtLineByOperationPlantId | components/CapaForm.tsx:45 COMBO.LINE (LineByOperationPlantId_SCP) |  | 구현 |
| D00-4b-014 | §4b Data.Common / OperationByLine / dtOperationByLine | components/CapaForm.tsx:52 COMBO.OPERATION (OperationByLine) |  | 구현 |
| D00-4b-015 | §4b Data_SCP.Common / BuildingByShopGroupId / dtBuildingByShopGroupId | components/CapaForm.tsx:41 COMBO.GROUP (ShopGroupId_SCP) |  | 구현 |
| D00-4b-016 | §4b Data_SCP.Common / LineByOperationPlantId / dtLineByOperationPlantId | components/CapaForm.tsx:45 COMBO.LINE (LineByOperationPlantId_SCP) |  | 구현 |
| D00-4b-017 | §4b Data.Common / OperationByLine / dtOperationByLine | components/CapaForm.tsx:52 COMBO.OPERATION (OperationByLine) |  | 구현 |
| D00-4b-018 | §4b Data_SCP.Common / LineByOperationPlantId / dtLineByOperationPlantId | components/CapaForm.tsx:45 COMBO.LINE (LineByOperationPlantId_SCP) |  | 구현 |
| D00-4b-019 | §4b Data.Common / OperationByLine / dtOperationByLine | components/CapaForm.tsx:52 COMBO.OPERATION (OperationByLine) |  | 구현 |
| D00-4b-020 | §4b Data_SCP.Common / MDMVersionId / dtVersionId | components/CapaForm.tsx VERSION + Capa.tsx reloadVersionOptions (MDMVersionId_SCP) |  | 구현 |
| D00-4b-021 | §4b Data.Common / OperationByLine / dtOperationByLine | components/CapaForm.tsx:52 COMBO.OPERATION (OperationByLine) |  | 구현 |
| D00-4d-001 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-002 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-003 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-004 | §4d SaveButton / Save | Capa.tsx handleSave (dirty CRUD_TYPE + validateSave + saveWithValidation) |  | 구현 |
| D00-4d-005 | §4d spdMain_CellDoubleClick / - | components/CapaGrid.tsx dblclick — 월 헤더 더블클릭 D_ 드릴다운 토글(Vis8) |  | 구현 |
| D00-4d-006 | §4d BtnNewModel_Click / - | Capa.tsx BtnNewModel → CapaNewModelPopup(features/master) |  | 구현 |
| D00-4d-007 | §4d BtnNewModel_Click / - | Capa.tsx BtnNewModel → CapaNewModelPopup(features/master) |  | 구현 |
| D00-4d-008 | §4d BtnNewVersion_Click / - | Capa.tsx → NewVersionConfirmModal (newVersion SAVE) |  | 구현 |
| D00-4d-009 | §4d BtnNewVersion_Click / - | Capa.tsx → NewVersionConfirmModal (newVersion SAVE) |  | 구현 |
| D00-4d-010 | §4d BtnVersionInfo_Click / - | Capa.tsx → VersionInfoModal (newVersion SEARCH) |  | 구현 |
| D00-4d-011 | §4d BtnVersionInfo_Click / - | Capa.tsx → VersionInfoModal (newVersion SEARCH) |  | 구현 |
| D00-4d-012 | §4d shtMain_Changed / - | Capa.tsx editTrackerRef + CapaGrid — 공용 EditTracker CRUD_TYPE 흡수 |  | 구현 |
| D00-4d-013 | §4d btnExcelUpload_Click / - |  | 엑셀 업로드 — TO-BE 업로드 SP·공용 업로드 모달 미존재(GAP-04). 임의 생성=anti-simplification 위반이라 후속(R3: convert-sp + 공용 인프라) | 미구현 |
| D00-4d-014 | §4d btnExcelUpload_Click / - |  | 엑셀 업로드(일별) — 동상 GAP-04 후속(R3) | 미구현 |
| D00-4d-015 | §4d btnExcelFormDownload_Click / - |  | 엑셀 양식 다운로드 — 행배열→xlsx export 공용 인프라 미존재(GAP-05, R3) | 미구현 |
| D00-4d-016 | §4d btnExcelFormDownload_Click / - |  | 엑셀 양식 다운로드(일별) — 동상 GAP-05 후속(R3) | 미구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:NewVersionConfirmModal | FE 실존 모달 (components/modals/NewVersionConfirmModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/modals/NewVersionConfirmModal.tsx (New Version 생성 — newVersion SAVE 7키) |  | 구현 |
| MODAL:SaveFileDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 |  | 엑셀 저장 다이얼로그 — 엑셀 다운로드(GAP-05) 미배선에 종속, export 인프라 미존재(R3) | 미구현 |
| MODAL:VersionInfoModal | FE 실존 모달 (components/modals/VersionInfoModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/modals/VersionInfoModal.tsx (Version Info 조회 — newVersion SEARCH 6키) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) |  | INSERT NO-OP(design R4/R5 — AS-IS InsertButton 빈 본문). hotkeyConfig.insert=()=>undefined 무동작이라 신규행 추가 경로 없음 → 필터유지 대상 없음 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | Capa.tsx editTrackerRef → DataGrid registerDirtyCheck, SubTitle/SearchArea confirmIfDirtyKey 공용 위임(MSG00704) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | Capa.tsx ColumnLayoutModal onSave → saveTitleSet + fetchStaticColumns 재조회 |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | Capa.tsx postSave setToast(성공)/setAlert(실패) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) |  | Excel Download 자체가 미배선(EXCEL 권한 게이트 hasButton=false → excel:false 숨김, GAP-05 export 인프라 미존재). 콤보 Name 출력 검증 대상이 아직 없음(R3) | 미구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | useCapaStore joinCsv(다중선택 콤보 → CSV) + SP 콤마 IN. Model/Material 텍스트는 단일(AS-IS 동일) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | Capa.tsx gridFilterRef → DataGrid 공용 rebindFilterColumns 위임 |  | 구현 |

## 0. 미이식(설계 근거 있는 의도적 제외)

| AS-IS | 판정 | 근거 |
|---|---|---|
| EDIT 모드 토글(`EditButton`/`SwitchLock`/`bEdit_Mode`, cs:498~647) | **미이식** | convert-core §2.4 / asis_to_tobe §11 전화면 공통 — editMode state 금지. 편집 가능성은 `utils/capa.editLock.isCellEditable` 종합식(bRealFlag·EDITORBLE_YN·권한·행규칙)으로 실시간 판정(01 R2). self-check grep `editMode|setEditMode` 0 hit. |
| `SetSpreadRow` 클라 행 Visible 토글(Vis1~4, cs:1800~1836) | **미이식(dead code)** | 03 Vis1~4 — 호출부 0건·CheckedChanged 배선 0건 실측. 체크박스 5종은 GET_CAPA IN 파라미터 전용(재조회로만 반영). |
| `Set_ChangeValue`(V2, cs:1556) | **미이식(dead code)** | 03 §3 V2 — 유일 호출부가 도달불가 분기 안(가드 모순). |
| `spdExcel`/`siExcelTemp` 별도 그리드(dz) | **미이식** | 엑셀 export 데이터 가공 전용 — 화면 UI 렌더 대상 아님(01 §1, 03 §1.3). |

## 1. 이벤트/버튼 (영역1 이벤트 7 + toolbarOverride 5 + buttonGuards 16)

| AS-IS(cs) | TO-BE | 상태 |
|---|---|---|
| FindButton/FindData_Main (R1, cs:489·773) | `Capa.tsx handleSearch` → `useTabProcQuery(capa)` + 검증가드(from>to·Day+1y·6y) | 구현 |
| SaveButton/SaveData_Main (R3, cs:763·943) | `handleSave` → `buildSaveElems`/`buildSavePayload` → `apiClient.post capa/SAVE` + false-success 차단 + 재조회 없이 dirty 리셋 | 구현 |
| InsertButton NO-OP (R4, cs:494~496) | `hotkeyConfig.insert = () => undefined` (false·키생략 금지) | 구현 |
| DeleteButton NO-OP (R5, cs:759~761) | `hotkeyConfig.delete = () => undefined` | 구현 |
| EditButton (R2, cs:498) | 미이식(§0) — 편집조건 이월(capa.editLock) | 구현(이월) |
| btnColumn 컬럼설정 (R6, cs:2518) | customButtons 아이콘버튼 → `ColumnLayoutModal`(iter-3 배선, saveTitleSet+refetch) | 구현 |
| buttonNewVersion (R7, cs:2479) — CanUpdate 가드 #8·#9 | customButtons(hasButton('SAVE')) → `NewVersionConfirmModal`(폼 재구축) → newVersion/SAVE(7키 계약) | 구현 |
| buttonNewModel (R8, cs:2449) — #6·#7 | customButtons(hasButton('SAVE')) → `CapaNewModelPopup`(재사용) 10파라미터 전달 | 구현 |
| buttonVersionInfo (R9, cs:2497) — #10·#11 | customButtons → `VersionInfoModal`(검색폼 재구축) → newVersion/SEARCH(6키 계약, NEW-01 정정). AS-IS CanUpdate 가드 → SEARCH 게이트로 노출(§5 편차) | 구현 |
| btnExcelUpload (R10, cs:2603) — #13·#14 | **미배선(후속)** — TO-BE 업로드 SP/공용 업로드 모달 미존재 → 임의 생성 금지(anti-simplification) | 미구현 |
| formDown 양식다운 (R11, cs:2628) — #15·#16 | **미배선(후속)** — 행배열→xlsx export 인프라 미존재 → 임의 생성 금지(사전가드 3종 포함 이월) | 미구현 |
| btnRequest Mail (R12, cs:2555) | `handleMailRequest` → mailSend/SAVE(REQUEST_CHK='True' 행 CSV). 체크0=MSG01054 | 구현 |
| 헤더 요약 5종 (R14, cs:895~905) | `data.o_rc2`/`o_rc3` → `Capa.module.scss summaryBar` ReadOnly 우측정렬 | 구현 |

## 2. 검증/메시지 (validations 31 — 4축)

영역1(21)·영역2 이월(4)·영역3 이월(6). TO-BE i18n 코드는 `capa.constants MSG`(01 §2.6 실측, hook #114).

| AS-IS msgId(cs) | 조건 | TO-BE 코드 | 배선 위치 | 상태 |
|---|---|---|---|---|
| MSG00312 (cs:507·2652) | bRealFlag=false | MSG01314 | capa.editLock(bRealFlag 전제) / (양식다운 미구현) | 부분 |
| MSG00004 (cs:1217) 저장 {0}건 | 성공 | MSG00672 | handleSave toast | 구현 |
| MSG00133 (cs:1251) 변경0 | dirty 0 | MSG00133 | handleSave | 구현 |
| MSG00003 (cs:1227) 저장실패 | !='S' | MSG00003 | handleSave 실패분기 | 구현 |
| MSG00339 (cs:1359) 메일성공 | 'S' | MSG01335 | handleMailRequest | 구현 |
| MSG00284 (cs:1364) 메일실패 | 실패 | MSG01288 | handleMailRequest catch | 구현 |
| MSG00021 (cs:1370) 체크0 | 0건 | MSG01054 | handleMailRequest | 구현 |
| MSG00096 (cs:2455 등 6개소) 권한 | !CanUpdate | MSG00096 | 버튼 hasButton 게이트로 대체(노출 자체 차단) | 구현(등가) |
| MSG00265 (cs:2622) 업로드 재조회 | 닫힘 | MSG00265 | (엑셀 업로드 미구현) | 미구현 |
| MSG00108 (cs:793) from>to | 역전 | MSG00108 | handleSearch | 구현 |
| MSG00354 (cs:799) Day+1y | Day+1년초과 | MSG01348 | handleSearch | 구현 |
| MSG00326 (cs:805) 6y | 6년초과+자동보정 | MSG01323 | handleSearch(To 자동보정) | 구현 |
| MSG00331 (cs:2669) 양식 3y | 현재월+3Y5M | MSG01327 | (양식다운 미구현) | 미구현 |
| MSG00329 (cs:2678) 양식 Day | D 버킷 | MSG01326 | (양식다운 미구현) | 미구현 |
| MSG00337 (cs:1020·1086) E2000 LANE 필수 | 셀 검증 | (미등록) | **셀 저장검증 5종 미구현(iter-1 잔여)** | 미구현 |
| MSG00203/00107 (cs:1047·1058) priority 1~9·정수 | 셀 검증 | MSG00203/MSG00107 | 미구현 | 미구현 |
| MSG00193/00072 (cs:1099·1110) Yield>1·≤100 | 셀 검증 | (미등록) | 미구현 | 미구현 |
| (예외 처리 5건: cs:934/1237/1521/2275/2768) | try/catch | 공용 예외 토스트 | apiClient 인터셉터 | 구현(등가) |

## 3. gridSignals 92 (영역3 — 4축: lock/value/color/visible/기타)

| AS-IS(cs) | TO-BE | 상태 |
|---|---|---|
| L2~L10 편집잠금 종합식(cs:551~627) | `capa.editLock.isCellEditable`(EDITORBLE_YN·LOSS_CODE·권한·CONFIRM_FLAG=ROW_RANKING1·LANE_QTY=LINE ASSIGN·기간경계 WORK_CALENDAR M≥+4/D≥당일/LOSS D불가) → beginningEdit e.cancel | 구현 |
| L4 REQUEST_CHK LA001/2/3 (cs:563) | isCellEditable REQUEST_CHK 분기 | 구현 |
| V3~V9 파생 산식(cs:1669~1716) | `capa.derive.recalcColumn`(XB020/XB021/XC041/XC042/XE500/M08/XD101) — cellEditEnded M_/Y_ + 조회직후 recalcAll | 구현(런타임 수치 파리티 미확인) |
| V10 Best/Worst(cs:1774) | `capa.derive.recalcBestWorst` | 구현(미확인) |
| C1 BEF 회색(cs:658) | formatItem `BEF_` gray | 구현 |
| C2/C3 계산행 LightBlue(cs:687) | formatItem CAL/M08 | 구현 |
| C4 D_ 헤더 요일색(cs:1435) | formatItem ColumnHeader DAY_CODE 7=blue/1=red | 구현 |
| C13 No-Run D_ 회색(cs:716) | formatItem NO_RUN_NOT_PM + D_ | 구현 |
| C14 checkEmpty 연두(cs:747) | formatItem LA002/LA003 0값 | 구현(LA001 0/9 제외 로직 미반영 — 부분) |
| Vis7 D_ 초기숨김(cs:1912) | dynamicColumns D_ visible=false(드릴 시만) | 구현 |
| Vis8 월헤더 더블클릭 드릴다운(cs:2430) | CapaGrid dblclick → 그 월 D_ visible 토글 | 구현(미확인) |
| G2 정렬(cs:890) | SP ORDER BY 유지(클라 재정렬 미도입) | 구현(등가) |
| G4 좌측 키 세로병합(cs:913) | `CustomMergeManager`(CRUD_TYPE='I' 제외) | 구현(미확인) |
| G5 헤더 span(cs:1458) | DataGrid 헤더 머지(allowMerging ColumnHeaders 기본) | 부분(2단 그룹 라벨 미검증) |
| G1 LANE_QTY 셀콤보(cs:596) | 컬럼 메타(05_register.sql — **적용대기**) + DataGrid comboParams | 부분(메타 적용대기) |
| O 그룹(SetDecimal·RemoveRows·엑셀 등 37건) | 소수서식 format 'n2' / checkEmpty RemoveRows 미구현 / 엑셀 미구현 | 부분 |

## 4. 커버리지 요약

- 구현: 이벤트·저장·조회검증·편집잠금 종합식·파생·주요 색상·D_ 드릴다운·병합·헤더요약·New Model/Version/Info·Mail.
- 부분/미구현(iter-1 잔여, react-gap-audit 대상): 컬럼설정 모달·엑셀 업로드/양식 다운로드(가드 3종 포함)·셀 저장검증 5종(MSG00337/203/107/193/072)·C14 LA001 0/9 제외·헤더 2단 span 정밀·LANE_QTY 셀콤보 메타 적용(권한 차단).
- 미확인(사용자/브라우저 축): 파생 수치 파리티·병합/드릴다운/색상 시각·셀 콤보 렌더.
