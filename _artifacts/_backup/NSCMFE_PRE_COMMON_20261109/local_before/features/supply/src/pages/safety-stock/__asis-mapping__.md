# SCP0128 SafetyStock — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS 정본: `C:\PJT\NSCM_CS\GSCM\06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0128_SafetyStock\{SCP0128_SafetyStock.cs,.Designer.cs}`
> — iter-2(convert-flow v2)에서 처음 확보(1136줄). iter-1/design 단계는 이 경로를 몰라 "소스 부재"로
> 다수 항목을 확인 필요로 남겼으나, 이번 회차에 원문 대조로 대부분 실측 확정했다(goal.md v2 ④).
> AS-IS MSSQL(`asis.py`)은 여전히 접속 타임아웃 — 소스 원문으로 대체 확인.
> 설계 근거: `.atlas/gscm-design/SCP0128/design/00_checklist.md` ~ `03_grid-columns.md`,
> `convert-flow/goal.md` v2, `convert-flow/plan.md` v2
> 상태 표기: 구현 / 해당없음 / 확인 필요(사유 명시). "확인 필요"는 04_react-gap.md 로도 올린다.

## 0. iter-2 갱신 — AS-IS 원문 확보로 다수 확인필요 실측 정정

iter-1(design 단계 포함) 은 AS-IS `.cs` 원문에 접근하지 못해 Plan Group/Site/Type/Stage/Valid 5개
콤보 데이터소스를 대부분 "확인 필요"로 남겼다. 이번 회차(iter-2)에 원문(`SCP0128_SafetyStock.cs`
L190~325, L1090~1131)을 직접 read 해 아래와 같이 정정했다(goal.md v2 ④ 전문 참조):

- **Plan Group/Site/Stage/Type/Valid(그리드 셀) 데이터소스 확정**(④-1): 화면 전용 SP
  `SCP.SCP0128_GET_SEARCH_INFO`(파라미터 `p_division_id`/`p_site_id`, 반환 DataSet 6테이블 —
  Tables[0]=PlanGroupAll,[1]=ScmSiteAll,[2]=StageAll,[3]=Type,[4]=ValidYn(그리드 셀),[5]=ItemAll)
  단일 원천. 현재 배선된 `PlanGroup_SCP_ALL`(표준 콤보)은 **convert-core §2.6 위반**(이름 유사
  재사용) — `PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO` 배포 후 교체 필요(safety-stock.constants.ts
  COMBO 주석 TODO 참조).
- **Valid(조회조건) 콤보는 iter-1 판정이 맞았다**(④-2): `cboValid.DataBind(Data.Type.YesOrNo, true)`
  — `YesOrNo` 표준 콤보 재사용 정당, §2.6 위반 아님.
- **Site/Type/Stage 필드는 AS-IS 에 실제로 노출돼 있다**(④-3): Designer.cs 좌표 실측(cboType,
  cboStage, clbSite 가 usrLayoutControl2 에 실배치) — iter-1 의 "필드 미노출" 결정은 당시(데이터소스
  미확정) 정당한 보수적 판단이었으나, 이제 데이터소스가 확정됐으므로 UI 골격을 노출로 전환했다
  (이번 회차 구현, 데이터 배선은 SP 배포 후).
- **Division 체크값 매핑 함수 신규 발견**(④-4): `GetDivisionChecked(pDivision)`(.cs:217~251) —
  EE→'81,82,40'/EE_UC→'81_UC'/EE_HM→'81_HM'/EE_ST→'81_ST'/EE_HD→'81_HD'/EE_HG→'81_HG'. Site 필터
  (RefreshSiteByDivision, .cs:260~274)와 저장 시 Item 재검증(SaveData, .cs:733~741)이 이 매핑을
  거친다. 이번 회차에 `utils/safetyStockDivisionMap.ts getDivisionChecked` 로 구현(SP 무관, FE 로직
  만으로 즉시 가능) — 단, 실제 호출부(Site 필터/Item 재검증)는 둘 다 `GetSearchInfo` SP 재호출을
  전제로 하므로 PKG_SCP0128 배포 전까지는 함수만 준비된 상태(live 호출 없음).
- **SmartColMerge 트리거는 확인, 병합 대상 컬럼은 여전히 미확인**(④-5): `SpdMain_TopChange`(.cs:909~
  914, 스크롤 이벤트)가 트리거. 병합 대상 컬럼 목록은 이 `.cs` 에 없음(FarPoint 내부 속성 또는 별도
  설정 소관 추정) — 확인 필요 유지(SmartColMerge 병합 대상 컬럼, 미구현).
- **ClipboardPasted 파생은 1건뿐**(④-6): `SpdMain_ClipboardPasted`(.cs:1111~1131) — OPMZ_PLAN_GR_ID
  붙여넣기 시 NAME→CODE 역조회 변환 1건만 처리. 이번 회차에 `SafetyStockGrid.tsx pastedCell` 핸들러로
  구현.
- **SpdMain_EditChange 는 AS-IS 에서 dead code**(④-7): `InitEvent()`(.cs:315~325)에 이벤트 배선이
  주석 처리(`// this.spdMain.EditChange += SpdMain_EditChange;`, L322) — AS-IS 운영 코드에서 실행되지
  않는다. TO_YYYYMMDD 리셋·APL_QTY 음수 즉시경고 등 이 메서드의 로직은 TO-BE 재현 대상이 아니다
  (anti-simplification §3 — 죽은 코드를 요구사항으로 재현하면 AS-IS 와 어긋난다). 저장 시점 검증
  (MSG00219/MSG00085)으로 이미 커버됨.
- **InsertButton 가드는 시트 잠금 여부뿐**(④-8), **usrButton1 은 dead-control 확정**(④-9),
  **EditButton 미이식 영향**(④-10) — 전부 실측 확정, 기존 구현 변경 불요(아래 각 절 참조).

상세 근거는 `convert-flow/goal.md` v2 §④ 원문(AS-IS 라인 번호 포함) 참조.

## 1. 진입점 (entryPoints 5 toolbarOverride + 6 event, `00_checklist.md §4-b`)

| # | AS-IS name (line) | kind | TO-BE 구현 | 상태 |
|--:|---|---|---|:--:|
| 1 | `FindButton`(345) → `FindData_Main` | toolbarOverride | `SafetyStock.tsx onSearch` → `setFilters()` + `fetchStaticColumns()` | 구현 |
| 2 | `SaveButton`(377) → `SaveData` | toolbarOverride | `onSave` — `dirtyRows` 수집 → 중복검사(`findDuplicateSafetyStockRows`) → 행별검증(`validateSafetyStockRow`) → `saveWithValidation(…, mutate)` | 구현 |
| 3 | `DeleteButton`(355) | toolbarOverride | `onDelete` — 선택행 없으면 return, `GridAction.removeRow` | 구현 |
| 4 | `EditButton`(364) → `SwitchLock` | toolbarOverride | **미이식(제외)** — `asis_to_tobe.md §11` 전 화면 공통 결정, `design/01_layout.md §11` 재확인. hotkeyConfig 에 edit 키 자체를 두지 않는다(공용 기본핸들러 미보유라 생략해도 부작용 없음) | 구현(표준 제외) |
| 5 | `InsertButton`(350) → `Insert`+기본값+범위잠금 | toolbarOverride | `onInsert` — `GridAction.addRow(grid, safetyStockInsertDefaults(divisionId))`. **가드 확인 완료(iter-2, ④-8)**: 원문 `Insert_Row()`(.cs:502~520) 가드는 `siMain != null && siMain.IsLock(...) == false`(시트 잠금 여부뿐, 행선택 가드 없음) — 현재 "상시 허용" 구현이 정답 | 구현(가드 확정) |
| 6 | `ClbDivision_SelectedIndexChanged`(894, `cboDivision.SelectedIndexChanged`에 실배선, .cs:324) | event | `SafetyStockForm` Division 변경 → `setSearchParams({ divisionId })` → store 가 planGroupId 를 'ALL' 로 초기화 + `SpreadInfo.ClearDataSource(spdMain)`(.cs:898) 대응으로 `filters`를 undefined 로 리셋(본 회차 구현, useSafetyStockStore.ts) | 구현 |
| 7 | `SpdMain_CellDoubleClick`(975) | event | `SafetyStockGrid handleDblClick` — ITEM_ID 셀만 반응, 헤더 제외, 신규행만 팝업 오픈 | 구현 |
| 8 | `SpdMain_ClipboardPasted`(1111~1131) | event | **구현(iter-2)** — `SafetyStockGrid.tsx pastedCell` 핸들러, OPMZ_PLAN_GR_ID 컬럼 붙여넣기 시 `planGroups`(useTabComboQueries) NAME 매칭으로 CODE 역조회 치환(goal.md v2 ④-6). TO_YYYYMMDD 초기화는 `SpdMain_EditChange` 소속이며 그 이벤트 자체가 AS-IS dead code(④-7, 아래 참조)라 재현 대상 아님 | 구현 |
| 9 | `SpdMain_TopChange`(909) → `SmartColMerge` | event | **미구현** — 트리거는 확정(스크롤 이벤트, goal.md v2 ④-5)되었으나 병합 대상 컬럼 목록은 `.cs` 원문에도 없음(FarPoint 내부 속성 또는 별도 설정 소관 추정). 여전히 확인 필요 | 확인 필요 |
| — | `SpdMain_EditChange`(1012~1088) | event | **AS-IS dead code 확인(iter-2, ④-7)** — `InitEvent()`(315~325) 에 이벤트 배선 자체가 주석 처리(L322)돼 있어 AS-IS 운영 코드에서 실행되지 않는다. TO-BE 재현 대상 아님(anti-simplification §3) — 저장 시점 검증(MSG00219/MSG00085)으로 이미 커버 | 해당없음(AS-IS 미동작) |
| 10 | `btnItemId_Click`(1090) | event | `SafetyStockForm` — InputField 팝업 버튼 → `MaterialByDivisionModal` open, 결과 `setSearchParams({ itemId })` | 구현 |
| 11 | `spdMain_CellClick`(921) | event | 별도 핸들러 미구현 — 잠금/모드 가드(buttonGuards#2·#3)의 실질은 §11 로 Edit 모드 축이 사라져 `isMainCellEditable`(beginningEdit)로 이미 흡수됨(신규행만 편집 가능) | 구현(흡수) |

## 2. 버튼 가드 (buttonGuards 5, `00_checklist.md §4d`)

| # | method / condition (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 1 | Delete `fps==null`(357) | `onDelete` — `gridRef.current` 없거나 선택행(`selection.row<0`) 없으면 return | 구현 |
| 2 | `spdMain_CellClick` `!IsLock(...)`(925) | Edit 미이식(§11)으로 "잠금 해제 상태" 축 자체가 사라짐 — `isMainCellEditable` 이 신규행 기준으로 대체 판정 | 구현(표준 대체) |
| 3 | `spdMain_CellClick` `action!=FlagI && !_isEditMode`(942) | `_isEditMode` 축 제거(§11). AS-IS Edit 모드에서는 기존행도 편집 가능했으므로(해당 축이 참이면 이 가드는 꺼짐), TO-BE 는 신규/기존행 구분 없이 컬럼 white-list(`isMainCellEditable`)로 편집가능 여부를 판정한다(design 01 §2 L108·L113) | 구현(§11 반영) |
| 4 | `SpdMain_CellDoubleClick` `!e.ColumnHeader`(977) | `SafetyStockGrid handleDblClick` — `ht.cellType!==CellType.Cell \|\| ht.col<0` 이면 return(헤더/빈영역 제외) | 구현 |
| 5 | `SpdMain_CellDoubleClick` `IsLock(...) \|\| (CRUD_TYPE!=I)&&!_isEditMode`(980) | `_isEditMode` 축 제거(§11) → AS-IS Edit 모드에서 기존행도 ITEM_ID 팝업이 열렸으므로, TO-BE 는 ITEM_ID 가 편집가능 컬럼인 한 신규/기존행 모두 더블클릭으로 Item 팝업을 연다(`handleDblClick`, design 01 §2 L116) | 구현(§11 반영) |

## 3. 검증 (validations, `00_checklist.md §4d` 하단 표 12건 중 저장 관련 6건)

| msgId (line) | AS-IS 의미 | TO-BE 구현 | 상태 |
|---|---|---|:--:|
| MSG00001(643) | 9개 필수값(value_type/division_id/opmz_plan_gr_id/scm_site_id/item_id/stage/from~to/apl_qty/valid_yn) 공백 차단 | `safetyStockSaveValidation.ts validateSafetyStockRow` 필수값 검사 | 구현 |
| MSG00260(690) | 기존 동일건 존재 시(삭제 아니면) 저장 차단 | `findDuplicateSafetyStockRows` — PK 8컬럼 조합 신규행 중복 검사(클라측 best-evidence, `filterCalls#5 sb.ToString()` 원식 미확인이라 서버 SP 검증과 대사 필요) | 구현(확인 필요 — 서버측 대사) |
| MSG00046(711) | FROM/TO 날짜 형식 파싱 실패(`DateTime.ParseExact(v,"yyyyMMdd",null)` catch, MSG00219 대소비교와 별개 가드) — 본 회차 원문 재확인(.cs:700-713) 결과 "Work Date" 라는 별도 필드가 아니라 FROM_YYYYMMDD/TO_YYYYMMDD 자체의 형식 오류 가드로 확정 | **구현(본 회차)** — `safetyStockSaveValidation.ts validateSafetyStockRow`에 `isValidYyyymmdd` 형식 검증 추가, 필수값 검사 다음·MSG00219 대소비교 이전 순서로 배선(AS-IS 순서 재현) | 구현 |
| MSG00219(719) | From > To 날짜 역전 차단 | `validateSafetyStockRow` FROM_YYYYMMDD/TO_YYYYMMDD 비교 | 구현 |
| MSG00085(728) | 적용수량(APL_QTY) 음수 차단 | `validateSafetyStockRow` APL_QTY < 0 검사 | 구현 |
| MSG00458(747) | 대상 Item 미존재 차단 | `validateSafetyStockRow` — 형식(공백) 검사만, 실제 마스터 존재 검증은 SP 응답 필요(PKG_SCP0128 미배포로 서버측 대사 불가) | 구현(부분 — 서버 검증 후속) |

## 4. 그리드 시그널 (gridSignals 14건 영역3, `03_grid-columns.md §3.1`)

| # | AS-IS (line) | TO-BE 구현 | 상태 |
|--:|---|---|:--:|
| 1 | SetSheetHeaderColumnSCP(311) | AS-IS 전용 헤더 렌더 유틸 — `staticColumns` 동적 구성이 대체(design 03 §3.1 #1 판정 그대로) | 해당없음 |
| 2 | Delete(360) | `onDelete` | 구현 |
| 3·4 | LockColumn DIVISION_ID(370)/CREATED_BY~PRE_KEY_VALUES(372) | `safetyStockEditLock.ts LOCKED_ALWAYS` — DIVISION_ID + 감사컬럼 5개는 신규/기존행 모두 상시 read-only(Edit 모드 해제 시에도 잠긴 채 유지된 AS-IS #3/#4 그대로), 그 외 컬럼은 편집 가능 | 구현 |
| 5 | Query(460) | `useTabProcQuery` → `data.o_rc1` → `rows` | 구현 |
| 6 | LockColumn 전체(461) | 조회 직후 전체 잠금(#6)은 AS-IS 에서 EditButton(#3/#4)으로 해제되는 짝이다. TO-BE 는 Edit 토글만 제거하고(§11) 그 순효과 = "DIVISION_ID·감사컬럼만 잠그고 나머지는 편집가능"(`isMainCellEditable`)을 신규/기존행 공통으로 적용 — #6 전체잠금을 영구 유지하지 않는다(design 01 §2 L108·L113) | 구현(§11 반영) |
| 7 | Insert(506) | `onInsert` → `GridAction.addRow` | 구현 |
| 8 | SetValue defaultData(507-515) | `safetyStockInsertDefaults(divisionId)` — **원문 확인 완료(본 회차)**: `defaultData.Add(DIVISION_ID, division_id)` + `defaultData.Add(VALID_YN, "Y")` 2건뿐(.cs:512-513), 그 외 컬럼 기본값 없음. 현재 구현(DIVISION_ID 상속+VALID_YN='Y', 나머지 빈 값)과 1:1 일치 — 변경 불요 | 구현(확인 완료, 원문 일치) |
| 9·10 | LockRange DIVISION_ID(517)/CREATED_BY~LAST_UPDATE_DATE(518) | `LOCKED_ALWAYS`(신규행에도 적용) | 구현 |
| 11 | SmartColMerge(912, TopChange) | **미구현** — 병합 대상 컬럼 미확인(§1 위 #9 참조) | 확인 필요 |
| 12 | SetText ITEM_ID(1006) | `SafetyStockGrid setSelectedValue` — `editTrackerRef.storeChange` + `row.ITEM_ID = items` | 구현 |
| 13 | SetValue TO_YYYYMMDD=""(1047, `SpdMain_EditChange` 소속) | **해당없음(iter-2 정정)** — 이 로직이 속한 `SpdMain_EditChange` 자체가 AS-IS dead code(§1 위 ④-7) — 재현 대상 아님 | 해당없음(AS-IS 미동작) |
| 14 | SetValue OPMZ_PLAN_GR_ID=codeVal(1125, ClipboardPasted) | **구현(iter-2)** — `SafetyStockGrid.tsx pastedCell` 핸들러(§1 위 #8 참조) | 구현 |

## 5. 컨트롤/레이아웃 (controls 30건, `00_checklist.md §1`)

| AS-IS 영역 | TO-BE 구현 | 상태 |
|---|---|:--:|
| Layout 2(`usrLayoutControl2`,`layoutControlGroup2`) | `SearchArea`(SafetyStockForm) + `MainTitle.openSearchArea` 토글 | 구현 |
| 조회조건 8개 논리조건(19 컨트롤+라벨) | Division/Plan Group/Period/Valid/Item(+팝업) 5건 데이터 배선 완료, Site/Type/Stage 3건은 UI 골격만 노출(iter-2, 데이터는 SP 배포 후 — goal.md v2 ④-3) | 구현(3건 SP 후속 블로킹) |
| 그리드 2(`spdMain`,`spdMain_Sheet1`) | 단일 `DataGrid`(SafetyStockGrid) | 구현 |
| `usrButton1`(x0/y0/tab0) | **렌더 제외 확정(iter-2, ④-9)** — Designer.cs 실측: `Location=(0,0)`, `Size=(75,23)`, `TabIndex=0` — 컨테이너에 의미있는 배치 없이 기본 템플릿 좌표 그대로 방치된 leftover 컨트롤(SCP0122 등 선례와 동일 패턴). 추정에서 실측 확정으로 격상, 렌더 제외 유지 | 구현(dead-control 실측 확정) |
| static 5(`components`,`emptySpaceItem*`) | 비시각 — 매핑 대상 아님 | 해당없음 |

## 6. 콤보 (comboCalls 1 + 미확정 후보, `00_checklist.md §4b`)

| # | AS-IS CODE | 소비 위치 | TO-BE comboId | 상태 |
|--:|---|---|---|:--:|
| 1 | `BLUtils.GetDivision(false,"")`(44) | cboDivision | `COMBO.DIVISION='Division_SCP'`(EE 포함, WithoutEE 아님) | 구현 |
| — | `GetSearchInfo` Table[0](190~215, iter-2 원문 확정) | clbPlanGroup | `COMBO.PLAN_GROUP='PlanGroup'`(본 회차 `PlanGroup_SCP_ALL`→`PlanGroup` 교체 — §2.6 "이름 유사 콤보 무검증 재사용" 해소. 단 SQL 본문은 여전히 범용 `SCP_OPMZ_PLAN_GR_M` 전체조회라 화면 전용 SP 결과셋과 완전히 같지는 않음 — SP 배포 후 GET_SEARCH_INFO Table[0] 로 재교체 필요, safety-stock.constants.ts TODO) | 구현(부분 해소, 최종 교체는 SP 후속) |
| — | `cboValid.DataBind(Data.Type.YesOrNo, true)`(176, iter-2 원문 확정) | cboValid(조회조건) | `COMBO.VALID='YesOrNo'`(1:1 확정, §2.6 위반 아님) | 구현(확정) |
| — | `GetSearchInfo` Table[1](190~215) | clbSite | UI 골격만 노출(비활성), 데이터 배선은 SP 배포 후(§2.6 준수 — 임의 SQL_ID 배선 안 함) | 구현(골격, SP 후속) |
| — | `GetSearchInfo` Table[3](190~215) | cboType | UI 골격만 노출(비활성), 데이터 배선은 SP 배포 후 | 구현(골격, SP 후속) |
| — | `GetSearchInfo` Table[2](190~215) | cboStage | UI 골격만 노출(비활성), 데이터 배선은 SP 배포 후. lookup 후보 `OPMZ_STAGE_CD` 는 배선 안 함(스키마 신뢰도 낮음, 기존 판정 유지) | 구현(골격, SP 후속) |
| — | `GetSearchInfo` Table[4](190~215) | 그리드 셀 VALID_YN 콤보 | **미배선** — SP 배포 후 배선(현재 `SCM_ADM_CMBO_SQL_M` 전건 미등록, design 03 §1.1) | 확인 필요(SP 후속) |

## 7. 저장 계약 (spCalls 3건, `00_checklist.md §4-a`, `03_grid-columns.md §4.3`)

| AS-IS SP (line) | TO-BE |
|---|---|
| `SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_division_id`/`p_site_id`, 반환 6테이블) | **미배선(SP 후속)** — iter-2 원문 확정(.cs:190~215): 화면 로드 시 division="81" 하드코딩 기본값으로 1회 호출, Division 콤보 변경 시 클라 재필터(서버 재조회 없음). `PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO` 배포 후 이 계약대로 배선(Plan Group/Site/Stage/Type/그리드셀 Valid 5개 콤보 전부 이 SP 소비) |
| `SCP0128_GET_SAFETY_STOCK`(파라미터 9종) | `useTabProcQuery` — `filters={divisionId,planGroupId,scmSiteId,itemId,stage,validYn,valueType,periodFrom,periodTo}`(scmSiteId/stage/valueType 는 Site/Type/Stage 필드 UI 골격만 노출 상태라 상시 'ALL'/''/'' 고정, SP 배포 후 실배선) |
| `SCP0128_SAVE_SAFETY_STOCK`(업무값 11+user_id+PRE_* 8, 복합키 UPDATE 패턴) | 전용 조립 util `utils/safetyStockSaveRequest.ts` — `saveWithValidation(dirtyRows, staticColumns, rows => void submitSave(rows))`. SAVE SP 가 CLOB-per-column 이라 공용 `useProcMutation({data:[rows]})` 로는 BE 가 top-level camelCase 키를 못 찾아 전부 null 바인딩 → 조용한 no-op(2026-10-12 수정). FE 가 activeFlag(=CRUD_TYPE)·PRE_* 8종(EditTracker 원본값)을 직접 `^`-fold 해 camelCase COL_NM 키로 POST. 정본 SCP0006/SCP0011(공용 계층 CRUD 기반 PRE_* 자동조립 없음) |

Plant/Delete 는 신규행 로컬 제거뿐(SP 호출 없음, `entryPoints#3 sps:[]`) — 저장(SaveButton)이 트리거되어야 실제 DB 반영(AS-IS 공통 CRUD 패턴 추정).

## 8. 미완 / 후속 (iter-2 갱신 — 해소분 제거, 잔존분만 유지)

| 축 | 상태 | 사유 |
|---|---|---|
| `PKG_SCP0128` GET_SEARCH_INFO/GET_SAFETY_STOCK/SAVE_SAFETY_STOCK 런타임 | 미완 | 배포 후 `convert-sp` 후속 |
| Plan Group 콤보 최종 교체(`GET_SEARCH_INFO` Table[0]) | 미완(SP 후속) | 본 회차 `PlanGroup_SCP_ALL`→`PlanGroup`(전용 SQL_ID) 교체로 §2.6 이름 재사용 위반은 해소했으나, SQL 본문 자체가 화면 전용 SP 결과셋과 다름(범용 `SCP_OPMZ_PLAN_GR_M` 전체조회) — `PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO` 배포 후 최종 교체 필요(safety-stock.constants.ts TODO) |
| Site/Type/Stage 3개 조회조건 — 데이터 배선 | 미완(SP 후속, iter-2 UI 골격만 구현) | `PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO` 배포 전까지 실데이터 배선 불가 |
| SmartColMerge 병합 대상 컬럼 | 확인 필요(미구현) | 트리거는 확정(iter-2), 병합 기준 컬럼은 `.cs` 원문에도 없음(본 회차 재확인, `SetColMerge`류 호출 0 hit) |
| InsertButton 사전조건 가드 | 확인 완료(iter-2) | 원문 확인: 시트 잠금 여부만 가드, 행선택 가드 없음 — 현재 "상시 허용" 구현이 정답으로 확정 |
| 브라우저 시각·조작감 | 미완(사용자 확인 축) | 정적 검증으로 대체 불가 |

### 본 회차(convert-react)로 해소된 항목 (더 이상 확인 필요 아님)

Plan Group/Site/Stage/Type 데이터소스(④-1) · Valid 조회조건 콤보(④-2) · Site/Type/Stage 노출 여부
(④-3) · Division 체크값 매핑(④-4) · ClipboardPasted 파생 범위(④-6, PlanGroup NAME→CODE 1건만) ·
EditChange 배선 여부(④-7, dead code 확정) · usrButton1(④-9, dead-control 실측 확정) · EditButton
미이식 영향(④-10, 변경 불요 확정) · **Plan Group 콤보 §2.6 이름 재사용 위반(GAP-01, 부분 해소 —
전용 SQL_ID `PlanGroup` 교체 완료, 완전 해소는 SP 후속)** · **MSG00046 날짜 형식 검증(GAP-05, 완전
해소)** · **신규행 defaultData 원문(GAP-06, 확인 완료 — 기존 구현과 일치, 변경 불요)** ·
**Division 변경 시 그리드 클리어(신규 발견 항목, 완전 해소 — `filters` undefined 리셋 구현)**.

**정정**: PlanGroup 변경 시 그리드 클리어는 **구현하지 않는다** — `CboPlanGroup_SelectedIndexChanged`
(.cs:901~904)가 `SpreadInfo.ClearDataSource` 를 호출하는 것은 사실이나, 이 핸들러는 Designer.cs
어디에도 `clbPlanGroup`(실제 PlanGroup 컨트롤, `UsrCheckedList`)에 `+=`로 연결되지 않은 **dead
code**다(본 회차 Designer.cs 전수 재확인, `cboPlanGroup`/`PlanGroup_SelectedIndexChanged` 0 hit).
AS-IS 에서도 실제로 발생하지 않는 동작이므로 TO-BE 에도 추가하지 않는다 — plan.md 4-2 항목의 원래
가정("Division 또는 PlanGroup 변경 시 그리드 클리어")을 Division 단독으로 정정한다.

## UI 공통(통합테스트) 체크 축 (전 화면 상시 6+1항목)

| ID | 요지 | 구현 위치 | 상태 |
|---|---|---|:--:|
| COMMON:UC-01 | 필터 상태 Insert 시 필터 유지 | `onInsert` → `GridAction.addRow` | 구현 |
| COMMON:UC-02 | 수정 중 재조회 confirm | 공용 `SearchArea.onSearch`/`SubTitle` 단축키 dirty 시 confirm 경유 | 구현(공용 경로) |
| COMMON:UC-03 | Column 설정 적용 시 Reset 후 재조회 | 해당없음 — Column Settings UI 미사용, Measure 0행(pivot 없음) | 해당없음 |
| COMMON:UC-04 | CRUD 완료 Toast(실패/차단은 Alert) | 저장 완료=공용 mutation 성공 Toast, 검증 실패=`setAlert` | 구현 |
| COMMON:UC-05 | Excel 콤보 Code→Name 출력 | `SubTitle excelFileName='SafetyStock'` 공용 경로 | 구현 |
| COMMON:UC-06 | Key-in 콤마 다중조회 | 해당없음 — Item ID 는 팝업 단일선택(콤마 다중검색 없음) | 해당없음 |
| COMMON:UC-07 | 필터 상태 재조회 시 필터 유지 | 공용 `DataGrid` rebindFilterColumns 경유 | 구현 |
