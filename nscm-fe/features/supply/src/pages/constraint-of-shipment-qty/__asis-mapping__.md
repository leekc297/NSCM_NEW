# SCP0132 Constraint Of Shipment Qty — AS-IS <-> TO-BE 매핑 매트릭스

> convert-core §2.1 Top11 #11: validations / gridSignals / buttonGuards / entryPoints 전건 1:1 매핑.
> AS-IS 정본(명목): `06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0132_ConstraintOfShipmentQty/SCP0132_ConstraintOfShipmentQty.cs`(+`.Designer.cs`).
> **환경 제약**: 이 `.cs`/`.Designer.cs` 원본이 이 저장소(및 GSCM 체크아웃)에 실존하지 않는다(design
> 3개 문서·본 activity 세션 재확인 모두 동일 — `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/` 하위 실존 폴더는
> `SCP0201_CAPA` 뿐). 아래 매핑은 `screen-analysis.json`(Roslyn 1.2-syntax) 사실 앵커 + design
> 00~03 산출물 근거로 작성했다. 라인 단위 본문 확정이 불가능한 항목은 "확인 필요"로 명시(추측 금지).
> 백본: `.atlas/gscm-design/SCP0132/design/00_checklist.md`~`03_grid-columns.md`.
> TO-BE: `features/supply/src/pages/constraint-of-shipment-qty/`.

## entryPoints/override 5종 (design 01 §2)

| # | method | AS-IS 판정 | TO-BE 구현 |
|--:|---|---|---|
| 1 | FindButton | 가드없음, 실동작(GET SP 체인 확정) | `ConstraintOfShipmentQty.handleSearch` — Division 필수 선행 alert 후 `setFilter`+`fetchStaticColumns` |
| 2 | SaveButton | 가드없음, 실동작(SAVE SP + 재조회 체인 확정) | `handleSave` — `validateSaveRows`(필수8+수량2+날짜1) 통과 후 `saveWithValidation`. Item존재/Sales Site Priority 게이트는 서버(SP) 영역 — PKG_SCP0132 미배포로 이 회차 미검증 |
| 3 | DeleteButton | `fps==null` early-return(가드 확정), SwitchLock 미관여(정정) | `handleDelete` — `if(!selected) return`(무메시지) |
| 4 | EditButton | **실동작 확정**(SwitchLock+LockColumn 2건 스코프 포함) | `useConstraintOfShipmentQtyStore.setEditMode` 토글 + `SubTitle customButtons`(EDIT, `hasButton('EDIT')` 게이트) — DIVISION_ID·VAL_TP_CD~PRE_KEY_VALUES 는 `editLock.ALWAYS_LOCKED_COLUMNS`로 토글 무관 항상잠금 |
| 5 | InsertButton | **확인 필요**(NO-OP/실동작 미확정, 사전조건 가드 유무 불명) | **잠정 구현** — `handleInsert` 배선(division 확정 필요, 조회 후에만 허용). §3 gridSignals#8~11(Insert/SetValue/LockRange 조합)이 방향성(실동작)은 뒷받침하나 override 본문 자체의 가드 유무는 미확정 — 최종 확정 전 전환 완료로 간주하지 않는다(design 01 §2#5 명시 규정 그대로 적용) |

## 조회 직후 전체잠금 / 헤더초기화 (design 01 §2 #7,#8)

| # | 트리거 | AS-IS | TO-BE |
|--:|---|---|---|
| 7 | FindData_Main 흐름 | `LockColumn(0,Max,true)` 조회 직후 전체 읽기전용 | `useConstraintOfShipmentQtyStore.setFilter` 가 `isEditMode=false` 로 재설정 + `editLock.isCellEditable` 이 `isEditMode=false`·비신규행이면 전체 차단 |
| 8 | Form_Load/그리드 초기화 | `SetSheetHeaderColumnSCP` 헤더 1행 초기화 | 공용 `DataGrid` staticColumns(admin 메타) 초기화로 대체(1회성, 동적 분기 아님) |

## 그리드 White-list 18건(design 03 §3) — 규칙 그룹 매핑

| gridSignal(line) | 카테고리 | AS-IS | TO-BE |
|---|---|---|---|
| SetSheetHeaderColumnSCP(344) | other | 헤더 1행 초기화 | 공용 DataGrid staticColumns 초기화 |
| Delete(396) | other | 삭제 실행(가드는 #3 DeleteButton) | `handleDelete` — `GridAction.removeRow(grid)` |
| SwitchLock(405) | lock | 시트 전체 Lock/Unlock 토글(EditButton, 정정 귀속) | `setEditMode()` 토글 |
| LockColumn(406) | lock | DIVISION_ID 항상 편집 불가 | `isCellEditable` — DIVISION_ID 는 ALWAYS_LOCKED_COLUMNS |
| LockColumn(408) | lock | VAL_TP_CD~PRE_KEY_VALUES 항상 편집 불가 | `isCellEditable` — 동일 화이트리스트 |
| Query(493) | dataSource | GET SP 결과 바인딩 | `useTabProcQuery` data.o_rc1 -> DataGrid itemsSource |
| LockColumn(494) | lock | 조회 직후 전체 read-only | `setFilter` isEditMode=false 재설정 + `isCellEditable` |
| Insert(560) | other | 신규 행 삽입(InsertButton 방향성 확정) | `handleInsert` — `GridAction.addRow(insertDefaults(division))` |
| SetValue(570) | value | 신규행 기본값(defaultData — 구체값 확인 필요) | `insertDefaults` — DIVISION_ID 만 확정값, 나머지 EDITABLE_COLUMNS 공란 |
| LockRange(572) | lock | 신규행 DIVISION_ID 잠금 | `isCellEditable`(isNewRow) — NEW_ROW_LOCKED_COLUMNS |
| LockRange(573) | lock | 신규행 VAL_TP_CD~LAST_UPDATE_DATE 잠금(PRE_KEY_VALUES 제외) | `isCellEditable`(isNewRow) — NEW_ROW_LOCKED_COLUMNS(PRE_KEY_VALUES 미포함) |
| SmartColMerge(929) | merge | `SpdMain_TopChange` 셀병합 재계산(대상 컬럼 확인 필요) | **미구현(확인 필요)** — 병합 대상 컬럼을 AS-IS 원본 없이 특정 불가(`grid-behavior-parity.md` 원칙상 침묵 누락 아닌 명시 미구현) |
| SetText(1024) | value | ITEM_ID <- 팝업 sItemId | `applyItemSelect(row, itemId)` |
| SetText(1064) | value | VAL_TP_CD="A"(EditChange 1차) | `applyValTpCdDerivation` — SIPM_MIN_QYT/SIPM_MAX_QTY 편집 시 "A"(컬럼명 기준 추정, 확인 필요) |
| SetText(1068) | value | VAL_TP_CD="B"(EditChange 2차) | `applyValTpCdDerivation` — SAT/SUN 쌍 편집 시 "B"(동일 추정) |
| SetText(1089) | value | VAL_TP_CD="A"(KeyDown 1차, EditChange와 중복 추정) | `applyValTpCdDerivation` 단일 유틸로 EditChange/KeyDown 양쪽 통합(cellEditEnded 1경로) |
| SetText(1093) | value | VAL_TP_CD="B"(KeyDown 2차) | 위와 동일(통합) |
| SetValue(1114) | value | OPMZ_PLAN_GR_ID <- 붙여넣기 codeVal 정규화 | **미구현(확인 필요)** — 붙여넣기 코드 정규화 로직 AS-IS 원본 미확보 |

## 저장 검증 9건(design 03 §3.1)

| # | msgId | AS-IS 조건 | TO-BE 구현 |
|--:|---|---|---|
| 1 | MSG00099 | 일반쌍 Min>Max(SAT/SUN쌍 적용여부 확인필요) | `useConstraintOfShipmentQtyValidation` 2) — 일반쌍만 검사(SAT/SUN 미검사, 확인 필요) |
| 2 | MSG00001 | 8개 필수값 일괄체크 | `validateSaveRows` 1) — `REQUIRED_COLUMNS` 8종(등록됨 MSG00001 그대로 재사용) |
| 3 | MSG00046 | Sales Site Priority(대상 확인 필요) | **미구현(확인 필요)** — 대상 컬럼·조건 원문 미확보 |
| 4 | MSG00219 | From>To | `validateSaveRows` 4) |
| 5 | MSG00022 | 일반쌍 Min/Max 동시공백 | `validateSaveRows` 3) — 일반쌍만(SAT/SUN 미검사, 확인 필요) |
| 6 | MSG00458 | Item 존재 확인 | **미구현(확인 필요)** — 서버(SAVE SP) 판정 영역, PKG_SCP0132 미배포로 런타임 검증 불가 |
| 7 | MSG00004 | 저장 성공(SP 결과 'S') | `useProcMutation` 표준 onSuccess toast 대체 |
| 8 | (없음) | 저장 실패 2차 콜백 | `useProcMutation` 표준 실패 핸들 |
| 9 | (없음, GMessageBoxForException) | 예외 발생 | `useProcMutation` 표준 에러 핸들 |

## 미이관/대체 정직 표기 (convert-core §4.3)

- **InsertButton override 본문 사전조건 가드 미확정**(design 01 §5#3): AS-IS 원본 부재로 확정 불가. `handleInsert`는 division 확정(단일값) 조건부로 잠정 활성화했다 — 최종 확정 전까지 전환 완료로 간주하지 않는다.
- **SmartColMerge(line929) 미구현**: 병합 대상 컬럼을 특정할 원본이 없다.
- **VAL_TP_CD A/B 분기 기준 추정**(design 03 §6#1): 컬럼명(일반쌍 vs SAT/SUN쌍) 기준으로 최선 추정했다 — 정확한 AS-IS 조건은 확인 필요.
- **SAT/SUN 수량쌍 게이트 미적용**(design 03 §6#6): validations#1/#5 조건식 변수명이 일반쌍(`iMin`/`iMax`, `v_sipm_min_qyt`/`v_sipm_max_qty`)만 특정 가능해, SAT/SUN 쌍(4컬럼)에는 이번 회차 게이트를 걸지 않았다.
- **Sales Site Priority 게이트(MSG00046) 미구현**(design 03 §6#7): 대상·조건 원문이 JSON에 없다.
- **Item 존재 확인(MSG00458) 미구현**: 서버(SAVE SP) 판정 영역이며 `PKG_SCP0132` 미배포로 런타임 검증이 애초 불가능하다.
- **붙여넣기(ClipboardPasted) OPMZ_PLAN_GR_ID 정규화 미배선**: AS-IS `codeVal` 정규화 로직 원본 미확보.
- **PRE_KEY_VALUES 신규행 잠금 제외**(design 03 §1 #23 각주): 조회모드 전체잠금엔 포함되나 `NEW_ROW_LOCKED_COLUMNS`엔 제외 — 코드상 확인된 비대칭을 그대로 재현했다(의도 여부 확인 필요).
- **콤보 데이터소스 확인 필요 상태 그대로 잠정 배선**(design 02 §7): Division(`Division_SCP` 1·2·4층 미확인) / Plan Group(`PlanGroup_SCP_ALL` AS-IS 공급원 불명) / From Site·To Site(TO-BE 후보 전부 화이트리스트 미재현 — 재사용 금지, 신규 등록 보류라 이번 회차는 빈 옵션) / Stage·Model Group(TO-BE 미배포 — 신규 등록 보류, 빈 옵션) / Valid(`YesOrNo` 확정 재사용).
- **TO-BE `PKG_SCP0132` 미배포** → 조회/저장 런타임 전체 미검증(convert-sp 후속). GET/SAVE 계약은 design 03 §4.

## UI 공통(통합테스트) 체크 축

> 원천: 통합테스트 사전점검 Common 축. 공용 DataGrid/GridAction/useSaveWithValidation/useProcMutation 인프라를 위임 소비. 실제 화면 육안 동작은 사용자 확인 축(미확인).

| ID | 요지 | 구현 위치 | 상태 |
|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지 | 공용 DataGrid(keepRowVisibleUnderFilter) | 구현(패턴 위임) |
| COMMON:UC-02 | 수정 중 다른 데이터 조회 시 confirm | 공용 DataGrid registerDirtyCheck + editTrackerRef | 구현(패턴 위임) |
| COMMON:UC-03 | 컬럼 설정 적용 시 재조회 유도 | `fetchStaticColumns` mount/Search 재조회. Measure 없음(pivot X) | 구현(패턴 위임) |
| COMMON:UC-04 | CRUD 완료 알림 = Toast | `setToast` + `useProcMutation`/`saveWithValidation` 표준 성공 toast | 구현(패턴 위임) |
| COMMON:UC-05 | Excel Download 콤보 Name 출력 | SubTitle excelFileName(공용 DataGrid dataMap 승계) | 구현(패턴 위임) |
| COMMON:UC-06 | 콤마 다중 조회조건 전건 조회 | `setFilter`(planGroupIds/fromSiteIds/toSiteIds/stageIds/modelGroupIds join(',')) — 런타임은 PKG 배포 후 실검증 | 구현(배선만, 런타임 미검증) |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 필터 유지 | gridFilterRef + 공용 DataGrid(rebindFilterColumns) | 구현(패턴 위임) |
