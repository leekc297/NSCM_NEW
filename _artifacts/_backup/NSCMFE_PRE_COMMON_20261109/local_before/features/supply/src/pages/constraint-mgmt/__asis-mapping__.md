# SCP0120 Constraint Mgmt — AS-IS ↔ TO-BE 대사표

AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0120_ConstraintMgmt/SCP0120_ConstraintMgmt.cs` (1,012행)
+ `SCP0120_ConstraintMgmt.Designer.cs` (436행)
TO-BE: `nscm-fe/features/supply/src/pages/constraint-mgmt/`
설계 원천: `.atlas/gscm-design/SCP0120/design/00~03`, 확정 결정 `convert-flow/decisions.md`

> `asis_mapping_gate.py --check` 는 이 세션 allowlist 에 없어 **미실행**이다(`ora.py`/`asis.py` 만 허용).
> 아래 표는 수기 작성분이며 게이트 통과 여부는 미확인으로 남긴다 — `04_react-gap.md` ERROR 항 참조.

---

## §1 레이아웃·컨트롤

| AS-IS | 근거 | TO-BE | 상태 |
|---|---|---|---|
| `splitContainer1` Orientation=**Horizontal**(=상/하), SplitterDistance 406/658 | Designer:73~89 | `PanelGroup orientation='vertical'` + Panel 62/38 (`ConstraintMgmt.tsx`) | 구현 |
| `FixedPanel=Panel2` (하단 px 고정) | Designer:86 | 퍼센트 62/38 + `minSize` 20/15 로 수용. `react-resizable-panels` 은 px 고정이 없다 | 해당없음(라이브러리 한계 — 조작감은 사용자 확인 축) |
| `usrConditionPanel1` `UsrPanelType=HidePanel` | Designer:150 | `MainTitle openSearchArea/toggleOpenSearchArea` + `SearchArea isHidden` | 구현 |
| `usrLayoutControl1` / `layoutControlGroup1`(`TextVisible=false`) | Designer:154~264 | `SearchArea conditions` + `Grid size={3}`. 그룹 제목·테두리 UI 신설 안 함 | 구현 |
| `spdMain` 시트 "Lookup Type" / `spdSub` 시트 "Lookup Values" | cs:169·172 | `DataGrid` 2개 + 제목 `LBL00057` / `TitleArea LBL00637` | 구현 |
| `VisibleTab(true)` (시트탭 표시) | cs:226·283 | 미이식 — Spread 1개당 시트 1개라 탭이 없어도 구분된다. 탭 컴포넌트 신설 금지 | 제외(사유: 1시트/1그리드라 탭 UI 가 표현할 것이 없다) |
| `VisibleAlternatingRow()` zebra | cs:417·535 | 공용 `DataGrid` 기본(`.wj-cell.wj-alt`) — 코드 불요 | 구현(공용) |
| `SetSearchCount(ds)` | cs:414 | `SubTitle countGrid={masterGridRef} dataCount={masterCount}` (Main 고정) + 하단은 `TitleArea totalCases` | 구현 |
| **`cboLookupGroup`** (UsrComboBox, Loc(406,18), tabIndex=8) | Designer:48·372~379·431 | **비이식** | 제외(사유: 선언·속성설정만 있고 어떤 `Controls.Add` 에도 없다 — `usrLayoutControl1.Controls.Add` 는 clbPlanGroup/cboValid/txtLookupType 3개뿐, code-behind 참조 0건. 런타임 미렌더 고아 컨트롤이며 TO-BE 조회조건 카탈로그 3행과도 일치) |
| `DefineProperty()` | cs:144~146 | **비이식** | 제외(사유: 본문이 비어 있어 이식할 동작이 없다) |
| `EssentialCheck()` | cs:925 | **비이식** | 제외(사유: 데드 메서드 — 호출 0건. 실제 필수검증은 `DataUtil.checkRequiredOfSpread`(cs:546·659)가 한다) |
| `DoAfterSave()` | 주석 | **비이식** | 제외(사유: AS-IS 에서 주석 처리돼 있다. 같은 SP 를 부르던 SYS0010 도 대상 프로시저가 TO-BE DB 에 없어 비활성) |
| `spdMain_Sheet1` / `spdSub_Sheet1` (Designer 기본 SheetView) | Designer:35·47·104~140 | **비이식** | 제외(사유: 런타임 시트는 cs:169·172 `AddSheet` 가 새로 만든다. 디자이너 잔재) |
| tabIndex 역전 (`txtLookupType`=4 → `cboValid`=7 → `clbPlanGroup`=9) | Designer | TO-BE 는 **시각(DOM) 순서** = Lookup Type → Plan Group → Active | 해당없음(사유: 사이 번호 8 이 고아 `cboLookupGroup` 이다. 역전은 컨트롤 제거 잔재이지 의도된 UX 가 아니다) |

## §2 편집모드 · 권한

| AS-IS | 근거 | TO-BE | 상태 |
|---|---|---|---|
| `EditButton` → `SwitchLock()` 시트 단위 잠금↔편집 **토글** | cs:343~365 | **미이식**. 편집 가능이 기본값이고 권한만 화면 오픈 시 1회 `hasButton('EDIT')` 로 판정한다 | 제외(사유: 2026-09-23 전 화면 공통 결정 + 2026-09-25 사용자 재확인 — `decisions.md §2`. `Doc/Doc_lgc_bak/rules/11_asis_parity/asis_to_tobe.md §11` 명문화분) |
| 조회 직후 전열 잠금(`LockColumn(0,max,true)` + `Query` 의 `SetLockFlag`) | cs:410~411·531~532 | **무효 처리** — 복귀할 모드가 없다 | 제외(사유: 위와 동일. `D1 R-06·R-07·R-11·R-12·R-35` 가 이 지시로 무효) |
| `Edit` 버튼 노출 | cs:343 | `customButtons` **0건**. `hotkeyConfig.edit` 도 쓰지 않는다(`Hotkeys` enum 에 `edit` 값이 없어 `SubTitle` 이 렌더하지 않는 사문 키) | 제외(사유: `decisions.md §2`) |
| `EDIT` 버튼코드 권한 | `TB_FX_GroupMenuAuth` | `SCM_ADM_MNU_BTN_MPG_M` / `_USER_GR_` 에 **계속 등록**한다 — 버튼은 안 보이지만 `canEdit` 의 권한축이다 | 구현(`05_register.sql` [4][5]) |
| 감사 4열 재잠금 (Main Edit·Insert) | cs:352·817 | `INPUT_TP_CD='S'` × 4 (컬럼 속성이라 모드와 무관하게 유지) | 구현(`05_register.sql` [6-1]) |
| Sub `LOOKUP_TYPE` / `SEGMENT10` / 감사 4열 재잠금 | cs:360~362·838~840 | `INPUT_TP_CD='S'` (+ `SEGMENT10` 은 `VISIBLE_FLAG='N'`) | 구현(`05_register.sql` [6-2]) |
| `Can{Select,Insert,Delete,Update,Save}` → `MSG00096` 후 return | `BaseForm.cs:3025~3231` | `useTabBtnPermissions().hasButton()` 로 **버튼 자체를 비노출** | 구현(`hotkeyConfig`) |
| `NowGroupID ∈ {ADMIN, SCM PI Admin}` 리터럴 비교 3지점 | cs:295~302·384~391·483~487 | `GET_ADMIN_GROUP` / `SEGMENT2='SCP0120'` 메타 2행 + `AdminYn_SCP0120` 콤보 — 판정은 서버 SQL 이 세션 사용자로 수행한다. FE 에 그룹명 리터럴 0건 | 구현(`05_register.sql` [7][8-2]) |
| `p_admin_yn` 서버 필터(`segment10 NOT IN (...)`) | AS-IS SP | TO-BE `PKG_SCP0120` L257 에 이미 이식됨 | 구현(SP 축 — convert-sp 소관) |
| 셀 배경색 `LockColor`/`UnLockColor` | `SpreadInfo.cs:5352~5371` | hook #95 3색 환산: 편집가능 `wj-cell-editable`(Yellow) / 잠금 클래스 없음(White+zebra). `wj-cell-non-editable` 은 항상 false 로 명시 | 구현(`utils/constraintMgmt.editGuard.ts`) |

## §3 버튼 · 저장

| AS-IS | 근거 | TO-BE | 상태 |
|---|---|---|---|
| `FindButton` → `FindData_Main()` | cs:323~326 | `hotkeyConfig.search` → `handleSearch` | 구현 |
| `InsertButton` → `InsertRow()` (`fps.Name` 분기, 가드 0건) | cs:328~331·806~841 | `handleInsert` 활성 그리드 라우팅. Main 은 **임의 가드 추가 없음** | 구현 |
| Sub Insert 마스터 미선택 | (가드 없음) | `MSG00624` 안내 후 행 미추가 | 구현(**AS-IS 미존재 가드 추가**. 사유: 미선택 시 `LOOKUP_TYPE` 이 빈 행이 만들어져 저장 경로까지 흘러간다. SYS0010 선례 동일) |
| `DeleteButton` → `siMain/siSub.Delete()` → `DeleteQueryId` **물리 DELETE** | cs:333~341·631·748 | `GridAction.removeRow(ref, true)` = **신규행만 제거**. 기존 행 비활성화는 `Active='N'` 셀 편집 | 제외(사유: `decisions.md` Q-01 사용자 확정 + hook #138 + SYS0010 선례. **AS-IS 물리삭제 기능 1건 의도적 소실**이며 `PKG_SCP0120` 에 `P_SCP0120_DELETE_LOOKUP_MASTER`/`_DETAIL` D 분기가 이미 배포돼 있어 `removeRow(ref)` 한 줄로 되돌릴 수 있다 — SP·메타 변경 불요) |
| `SaveButton` → `SaveData()` (필수 → 중복 2단 게이트) | cs:367~370·546·548 | `handleSave` → `saveWithValidation`(필수검증) → 콜백 안에서 중복(`findDuplicateRow`, 모집단=그리드 전 행) → `DISPLAY_SEQ` → `mutate` | 구현 |
| 저장 대상 = `fps.Name`(포커스) | cs:543·651 | **변경분 기준** `pickSaveTarget` | 구현(의도적 개선. 사유: AS-IS 는 하단에 행을 넣고 상단을 클릭한 뒤 저장하면 하단 변경이 조용히 남는다) |
| 변경 0건 → `MSG00133` | `BaseForm.cs:3243~3282` | `MSG00004`("No changes to save.") — `useProcMutation` 이 빈 배열을 거부하며 같은 문구를 낸다 | 구현(번호 재매핑) |
| 저장 성공 → `MSG00004` Alert | cs:647·764 | **`MSG00672`**("{0} data saved.") **Toast** | 구현(번호 재매핑 + Alert→Toast) |
| 필수 미입력 → `MSG00002` | `DataUtil.cs` | **`MSG00429`**("{0} value is required.") | 구현(번호 재매핑. TO-BE `MSG00002` 는 "Saved successfully." 라 재사용 금지) |
| 중복키 → `MSG00060` | cs:938~1009 | `MSG00060` (번호·의미 일치) | 구현 |
| 행별 SP 호출(부분 성공 가능) | `SaveDataTable` | `JSON_TABLE` 배치 1회 + `SAVEPOINT`(전건 롤백) | 구현(동작 변경 — 더 안전한 방향. `03 Q-06` 기록) |
| 감사 4열을 FE 가 실어 보냄 | AS-IS | **보내지 않는다** — SP 가 `P_USER_ID`/`SYSDATE` 로 채우고 수정 시 원본을 원장에서 재조회한다 | 구현 |
| `SCP0120_SCP_OPT_LOOKUP_MASTER_DETAIL_HIST` 이력 | AS-IS SP 본문 주석 | 호출 없음 | 해당없음(사유: AS-IS 가 2025-06-11 요청으로 주석 처리했고 TO-BE PKG L808 도 같은 주석을 남겨 호출하지 않는다 — 양쪽 일치) |

## §4 그리드 · 동적 컬럼

| AS-IS | 근거 | TO-BE | 상태 |
|---|---|---|---|
| `AddActionTextBox` CRUD 액션열(인덱스 0, 폭 15) | cs:187·233 | 공용 `DataGrid` CRUD 상태열 자동. 별도 컬럼·Visible 토글 신설 금지 | 구현(공용) |
| `Freeze(0, siMain.GetColumnIndex(DESCRIPTION))` Main | cs:224 | `FIXED_FLAG='Y'` 2건 (`LOOKUP_TYPE_KEY`·`LOOKUP_TYPE`) | 구현 |
| Sub `Freeze` 가 **`siMain`** 인덱스를 참조 | cs:281 | `FIXED_FLAG='Y'` 2건 (`LOOKUP_TYPE`·`SEGMENT1`) — **값 그대로 이식** | 구현(사유: 코딩 실수로 보이지만 `siSub` 기준으로 "고치면" `DESCRIPTION` 인덱스 28 이 고정돼 화면이 무너진다. AS-IS 실행 결과(액션열+2열 고정)가 업무적으로 타당하므로 결과 등가를 택했다) |
| 칼럼 선언 77건 (Main 34 / Sub 43) | cs:188~279 | `SCM_MST_SHEET_COLUMNS` 77행 신규 등록. FE 하드코딩 0 | 구현(`05_register.sql` [6]) |
| Main `SEGMENT10` = **Admin 플래그**(세그먼트 이름 아님), `AddComboColumn` | cs:203 | 라벨 `Admin*`, 셀콤보 `YesOrNo`, `INPUT_TP_CD='M'` | 구현 |
| Main `LOOKUP_TYPE` 개명 허용(Edit 재잠금 대상 아님) | cs:189·352 | `INPUT_TP_CD='M'`. **`IM` 금지** — `IM` 이면 기존 행 개명이 막혀 SP 의 DETAIL cascade UPDATE 경로가 죽는다 | 구현 |
| 셀 콤보 4슬롯 (`dtSystem`/`dtYesOrNo`, `isAddALL=false`) | cs:35~36·191·192·203·244 | `CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox'` + `CELL_COMBO_DATA_TYPE` = `SYSTEM` ×1 / `YesOrNo` ×3. PARAM2/9/10 전건 NULL(cascade 콤보 0건) | 구현 |
| `Data.Type.LookupCommon`(param1='SYSTEM') | cs:35 | TO-BE 는 **`SYSTEM`** SQL_ID 를 쓴다 | 구현(사유: `LookupCommon` 은 `@lookupType` 바인드를 요구해 셀콤보 자동조회 경로에서 `''` 로 치환돼 0행이 되고 셀에 코드 원문이 노출된다. `SYSTEM` 은 상수를 SQL 에 박고 있어 결과가 5행으로 동일하다) |
| `SetColumInfo` + Sub 컬럼 순회 동적 3축 (25슬롯) | cs:455~481·866~896 | `applyDynamicSubColumns(masterRow)` + `ConstraintMgmtDetailGrid` 파생 `staticColumns` useMemo | 구현 |
| `spdMain.CellDoubleClick` → Sub 조회 | cs:849~864 | `dblClick` → `applyDynamicSubColumns` + `setSubFilters` | 구현 |
| 더블클릭 가드 ① `siMain.IsLock(sheetName)==true` 일 때만 | cs:851 | **제거** | 제외(사유: 편집이 기본값인 TO-BE 에서는 이 가드가 Sub 조회를 영구 차단한다 — `decisions.md §2`) |
| 더블클릭 가드 ② `Rows.Count<=0` | cs:853 | `if (!dataItem) return;` + `if (!lookupType) return;` | 구현 |
| Main 신규행 기본값 `VALID_YN='Y'` 1건 | cs:811~815 | `EMPTY_MASTER_ROW` (34열 `''` + `VALID_YN:'Y'`) | 구현 |
| Sub 신규행 기본값 12건 | cs:822~836 | `EMPTY_DETAIL_ROW` + Insert 시 `LOOKUP_TYPE=mainLookupType` | 구현 |
| Sub 신규행 `DISPLAY_SEQ` 기본값 | (없음) | `'0'` 선제 보정 | 구현(사유: AS-IS 기본값엔 없지만 저장 시 `'0'` 보정(cs:674)과 SP 정수 검사(PKG L813)를 앞당긴 것 — 관측 동작 동일) |
| `DBUtils.Filter(ds.Tables[0], col IN (...), true)` Sub 결과 Plan Group 필터 | cs:483~529 | `filterDetailRowsByPlanGroup` FE 클라 필터(useMemo) | 구현(사유: TO-BE `P_SCP0120_GET_LOOKUP_DETAIL` IN 은 `lookupType` 1개뿐이라 서버 경로가 없다. 빠지면 비관리자에게 남의 Plan Group 행이 노출되는 권한 결함) |
| `DBUtils.Filter` 3번째 인자 `true` 의 의미 | cs:522 | 0건 매칭 = **빈 그리드**(예외·전건 폴백 금지) 로 계약 고정 | 해당없음(사유: 워킹트리에 2-arg 오버로드만 있고 SVN BASE 대조 불가 — `svn` CLI 부재. **미확인이지만 두 해석 모두에서 안전한 쪽으로 못박았다**. `04_react-gap.md` ERROR-2) |
| `InitSpread(siSub)` (Main 조회 성공 시 Sub 비움) | cs:421 | `clearDetail()` — 데이터 + 동적 라벨·숨김·`planGroupColumn`·`mainLookupType` 전부 초기화 | 구현 |
| `CanModelChange=false` (바인딩 중 'M' 마킹 차단) | cs:378·419·426·537 | **미해당** | 해당없음(사유: `EditTracker`/`GridAction` 은 `itemsSource` 교체를 사용자 편집으로 보지 않는다. 대응 상태 신설 금지) |
| 셀 병합 | — | **미사용** | 해당없음(사유: 77컬럼 전건 `FPMerge.None`, `SmartColMerge`/`allowMerging` 호출 0건) |
| 다단 헤더 | — | **미사용** | 해당없음(사유: `AddXxxColumn` 에 `sClsLblNm`/`lClsLblNm` 축 없음, `ColumnHeader.Rows` 조작 0건 — 1단) |

## §5 조회조건 · 콤보

| AS-IS | 근거 | TO-BE | 상태 |
|---|---|---|---|
| `txtLookupType` (자유 입력, 부분일치) | Designer:219~250 / cs:381 | `InputField`. trim 후 그대로 전달, `'ALL'` 치환 금지 | 구현 |
| `clbPlanGroup` (`UsrCheckedList2` 다중 + 내장 ALL + 검색) | Designer:166~207 | `CustomDropdown multiple allOption useClearIcon limitTags={1} sortBy='label'` | 구현 |
| Plan Group 후보 공급 = `SCP0121_GET_SEARCH_INFO` Tables[3] (owner 필터 + NAME 정렬) | cs:48·163~164·291~317 | 전용 콤보 **`PlanGroupByOwner_SCP0120`** 신규 등록 | 구현(사유: 기존 `PlanGroup`/`PlanGroup_SCP_ALL` 은 owner 필터·정렬이 없어 비관리자에게 전 Plan Group 이 노출된다. 두 콤보는 FE 소비자 2화면이 있어 수정 금지(hook #117)) |
| Plan Group 값 축 = **NAME** (`CheckedItems` = `row[1]` = NAME) | `UsrCheckedList2.cs:227~228·266~267` / cs:497·512 | 콤보 option 의 `value` 도 `NAME` | 구현(사유: 필터 비교 대상인 원장 컬럼 값이 `OPMZ_PLAN_GR_NAME` 이라 CODE 로 담으면 매칭 0건이 되어 비관리자 그리드가 통째로 빈다) |
| Plan Group 미선택 = `dtPlanGroupAll` 전건 | cs:490~519 | `picked.length ? picked : ownedPlanGroupNames` | 구현(사유: "미선택 = 무제한" 이 아니라 "내 Owner 전체"다. 표준 `'ALL'` sentinel 해석을 화면이 덮어쓴다) |
| `cboValid` `DataBind(Data.Type.YesOrNo, true)` → ALL/Y/N, 기본 `Y` | cs:152·154 | `CustomDropdown allOption` + `useTabComboQueries(['YesOrNo'])`, 초기값 `'Y'` | 구현(리터럴 배열 금지) |
| `Valid` 명칭 | Designer:288~300 | **`Active`** (`LBL00007`) | 구현(TO-BE 조회조건 카탈로그 지시 개명. `LBL00639`(Valid) 미사용) |
| `CString.GetCheckedListValue(..., true)` ALL→`''` | `CString.cs:550~570` | `validYn === 'ALL' ? '' : validYn` | 구현 |
| cascade(조건 간 연동) | — | **미배선** | 해당없음(사유: Roslyn `events` 1건이 `spdMain.CellDoubleClick` 뿐이고 조회조건 이벤트 배선 0건. 조건 3개가 상호 독립이며 Division 조건 자체가 없다 — 자매 화면의 Division→PlanGroup 형태를 복사하면 없던 의존이 생긴다) |
| 조회조건 팝업 버튼 | — | **없음** | 해당없음(사유: Roslyn `popups: []`, 조회영역 `Controls.Add` 3건이 전부 입력 컨트롤) |

## §6 저장 payload 급소

| 축 | 계약 | 사유 |
|---|---|---|
| `LOOKUP_TYPE_KEY` | GET SP 가 `LOOKUP_TYPE AS LOOKUP_TYPE_KEY` 로 내려준 값을 **손대지 않고 재전송** | UPDATE 는 `WHERE LOOKUP_TYPE = R.LOOKUP_TYPE_KEY` + `SET LOOKUP_TYPE = R.LOOKUP_TYPE` 다(PKG L702·733). 키와 값을 같게 보내면 개명이 조용히 사라지고, DETAIL cascade UPDATE 도 돌지 않는다 |
| `SEGMENT1_KEY`~`SEGMENT10_KEY` | GET SP 가 원본을 직접 내려주므로 그대로 재전송. `INPUT_TP_CD='S'` + `VISIBLE_FLAG='N'` 이 그 보증이다 | UPDATE/DELETE WHERE 가 11키다(PKG L930~940). 편집값을 넣으면 UPDATE 0행 + 무오류 = 조용히 사라진다. SYS0010 과 달리 EditTracker 원본 복원 로직이 불필요하다 |
| `DISPLAY_SEQ` | `String(v ?? '').trim()` 후 `^[+-]?[0-9]{1,10}$` + `±2147483647` 검사. 빈 값은 통과(커서가 `'0'` 보정) | SP 가 `RAISE_APPLICATION_ERROR(-20002)` 를 던진다(PKG L813~821). Oracle NUMBER 가 JS number 로 내려오므로 문자열 메서드를 직접 부르면 TypeError 가 저장 핸들러 밖으로 던져져 무반응이 된다 |
| 빈 세그먼트 저장값 | AS-IS `''` → TO-BE `'-'` (커서 `NVL(TRIM(...),'-')`) | Main 은 SEGMENT1~10 이 전부 필수라 빈 값이 생기지 않고 Sub 는 신규행 기본값이 이미 `'-'` 다 → 관측 차이 0 |
| 저장 후 콤보 캐시 무효화 | **대상 0건** | 이 화면은 `SCP_OPMZ_LOOKUP_*` 를 저장하지만 셀콤보 `SYSTEM`/`YesOrNo` 의 원천은 `SCM_ADM_LOOKUP_*` 로 테이블이 다르다 |
| 저장 성공 토스트의 `{0}` | **전송 행 수**를 쓴다(SP 의 `O_RESULT_CURSOR.EVENT` 가 아님) | `useProcMutation` 의 `onSuccess` 가 `() => void` 라 응답 본문을 주지 않는다. 배치 `SAVEPOINT` 라 성공 시 두 값이 같지만 **정확히 EVENT 는 아니다** — 공용 훅 변경은 Hard Boundary 밖이라 `04_react-gap.md` 에 잔여로 남긴다 |

## §7 iter-2 보완 (react-gap-audit iter-1 지적 해소)

| AS-IS | 근거 | TO-BE | 상태 |
|---|---|---|---|
| `DataUtil.checkRequiredOfSpread(siSub)` — 런타임 라벨의 `*` 를 읽어 빈 값을 MSG00429 로 차단 | cs:659 | 동적 3축 파생 컬럼셋을 `buildDynamicDetailColumns` 로 올려 **그리드 렌더와 `saveWithValidation` 이 같은 컬럼셋**을 쓴다 | 구현(사유: 파생이 그리드 컴포넌트 로컬 useMemo 에만 있으면 저장 검증에 `*` 없는 원본 메타가 넘어가 `isMandatoryColumn` 전건 false — 헤더에 빨간 점은 찍히는데 빈 값이 그대로 저장된다) |
| `checkRequiredOfSpread` → `CheckValidation` 순서 | cs:546~548 / cs:659~661 | `saveWithValidation(..., payload => { 중복 -> DISPLAY_SEQ -> mutate })` — 필수가 먼저 | 구현 |
| `FindData_Sub` 안에서 `clbPlanGroup.CheckedItems` 를 **그 시점 한 번** 읽음 | cs:483~529 | `appliedPlanGroupNames` = `setSubFilters`(마스터 더블클릭) 시점 스냅샷 | 구현(사유: 조회조건을 반응형으로 읽으면 체크박스 조작만으로 하단이 재필터되고 splice 로 넣은 미저장 신규행이 사라진다) |
| `InitSpread(siSub)` — 마스터 행이 바뀌면 Sub 시트 재생성 | cs:455 | 같은 스냅샷 참조 교체가 하단 바인딩 배열을 새로 만든다(`slice()` 복사) | 구현(부수효과로 `GridAction.addRow` 의 splice 가 react-query 캐시 배열을 오염시키지 않게 됐다) |
| 붙여넣기 편집 차단 | — | `pastingCell` 에도 `canEdit` 게이트 | 구현(공용 `setEditableColumns` 는 `_inputEditType` 만 보므로 `canEdit=false` 에서도 'M'/'O' 컬럼 붙여넣기가 통과했다) |
| `CanSelect` 불통과 시 안내 후 return | R-29 | `handleSearch` 앞단 `hasButton('SEARCH')` 게이트 + `MSG00096` | 구현(사유: 공용 `SearchArea` 의 조회 버튼에는 권한 검사가 0건이라 `hotkeyConfig` 만 막으면 그 버튼으로 조회가 그대로 나간다) |
| 오픈 시 첫 포커스 = `txtLookupType`(tabIndex 4) | Designer | `InputField autoFocus` | 구현 |
| `if (!IsNullOrEmpty(nowGroupID) && != ADMIN && != SCM PI Admin)` 의 여집합 = **그룹 미상 사용자도 관리자** | cs:485~486 | `AdminYn_SCP0120` 은 `EXISTS(GET_ADMIN_GROUP ...)` 라 그룹 미상 = `'N'`(비관리자) | 해당없음(사유: **의도적 비이식**. AS-IS 엣지를 그대로 옮기면 그룹이 비어 있는 세션이 관리자 권한을 얻는다 = 권한 확대 방향. TO-BE 는 더 좁은(안전한) 쪽이며 F-01 필터가 더 걸릴 뿐 데이터 유실은 없다. 되살리려면 콤보 SQL 에 `OR NOT EXISTS(사용자 그룹)` 을 더해야 하므로 **사용자 확정 대상**으로 남긴다 — `04_react-gap.md` G-11) |
| AS-IS 물리 삭제(`DeleteQueryId`) | cs:333~341 | `GridAction.removeRow(ref, true)` = 신규행 제거 전용 | 해당없음(사유: `decisions.md` Q-01 사용자 확정. `PKG_SCP0120` D 분기는 배포돼 있어 `removeRow(ref)` 한 줄로 되돌릴 수 있다) |

## §8 iter-3 보완 (react-gap-audit iter-2 지적 해소)

| AS-IS | 근거 | TO-BE | 상태 |
|---|---|---|---|
| `CheckValidation` 이중 루프 — 바깥 루프만 action(I/M/D)으로 좁히고 **안쪽 루프에는 필터가 없다**(`if (i == j) continue;` 만) | cs:946~1001 (바깥 950~951 필터 / 안쪽 966~968 무필터) | `findDuplicateRow(targets, population)` — 검사 대상은 dirty(`GridUtils.getChangedRows`), 비교 모집단은 **그리드에 실린 전 행**(`masterRows`/`detailRows` = itemsSource 배열). 자기 제외는 모집단 키 카운트 2건 이상으로 대신한다 | 구현(사유: 변경행끼리만 비교하면 기존 행과 같은 11키의 신규행이 SP 까지 흘러가 ORA-00001 이 뜨고, 저장 SP 의 `SAVEPOINT` 롤백으로 같은 배치의 정상 편집분까지 함께 실패한다 — 사용자는 MSG00060 대신 DB 원문을 본다) |
| — (TO-BE 고유 축) | — | 상단 바인딩 배열도 `(masterData?.o_rc ?? []).slice()` 로 복사 | 구현(사유: `GridAction.addRowSet` 이 `view.sourceCollection.splice` 로 **화면이 넘긴 배열 자체**를 변형한다. 하단만 복사돼 있어 상단은 react-query 캐시 배열이 신규행으로 오염된 채 MDI keep-alive 동안 남았다 — 하단과 대칭을 맞췄다) |
| `FoxUserInfoContext.Current["NowGroupID"]` 를 **동기**로 읽어 관리자 판정 | cs:384~391 | `AdminYn_SCP0120` 콤보는 비동기라, 응답 전에 Search 를 누르면 `adminYn='N'` 이 `filters` 에 굳는다. 판정이 바뀌면 **적용된 조회조건 스냅샷의 `adminYn` 만** 갈아끼우는 effect 를 둔다(`setAppliedAdminYn` — `setFilters` 를 재사용하면 폼 현재값을 다시 읽어 사용자가 Search 를 누르지 않은 조건이 적용된다. 값이 같으면 무동작 → 루프 없음) | 구현(사유: `filters` 는 다음 Search 전까지 다시 돌지 않아 스스로 복구되지 않는다. 그 상태에서는 관리자에게 `SEGMENT10='Y'` 행이 계속 은닉된다 — 실측 분포 54행) |

## UI 공통(통합테스트) 축 — COMMON:UC-01~07

> `asis_mapping_gate.py` 가 상수로 보유하는 전 UI 공통 요구다(화면 분석 md 에 안 나온다).
> 이 화면은 `--init` 자동 생성 경로를 쓰지 못했다 — 도구 진단문 그대로: `[dialect] 00_checklist.md=design
> 체크리스트(D번호)(0건) … [error] 번호/제약/CRUD·모달 추출 0건`. SCP0120 설계문서가 D번호 방언이
> 아니라 H/R/W/V 번호 체계라 파서가 0건을 뽑는다. 따라서 아래 7행은 오케스트레이터 세션이
> 코드 실증으로 직접 판정해 기입했다(2026-09-26). 도구 미생성 사실을 숨기지 않는다.

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 유지한 채 추가 행이 보이도록 | `ConstraintMgmt.tsx` `handleInsert` — `GridAction.addRow(ref, {...})` | 공용 위임. `GridAction.addRow` 가 내부에서 `keepRowVisibleUnderFilter` 를 부른다. 화면은 Insert 경로에서 필터를 clear 하지 않는다(폴더 내 filter clear 호출 0건) | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 시 confirm | `ConstraintMgmt.tsx` — 두 `DataGrid` 에 `editTrackerRef` 전달(Main·Sub) | 공용 위임. `DataGrid` 가 `editTrackerRef` 를 받으면 `registerDirtyCheck` 로 dirty 를 등록하고 `SubTitle`·`SearchArea` 의 `confirmIfDirtyKey` 가 조회를 가로챈다. 화면에 `excludeFromDirtyCheck` 설정 0건이라 기본 동작이 산다 | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외 설정 적용 시 기존 조회 데이터 Reset 후 재조회 유도 | 공용 `ColumnLayoutModal`(화면 폴더 내 사본 0건) | 공용 위임. 자체 컬럼설정 모달을 만들지 않았고 `staticColumns` 는 mount·Search 마다 `fetchStaticColumns` 로 재조회한다 | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 | `ConstraintMgmt.tsx` `toastSaved`(`setToast` success) · 변경 0건 `setToast` error | 성공·무변경은 `setToast`, 검증 실패·권한 거부만 `setAlert` 로 갈랐다(hook #132 §3) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼이 Code 아닌 Name 으로 출력 | `SCM_MST_SHEET_COLUMNS` 셀콤보 4슬롯(`CELL_COMBO_DATA_TYPE` = `SYSTEM` ×1 · `YesOrNo` ×3, DB 등록 실측) | 코드주입 콤보가 아니라 메타 기반이라 `gridAction` 이 dataMap 을 승계한다. `CELL_COMBO_DATA_TYPE` NULL 컬럼 0건 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 | — | Key-in 조회조건은 `Lookup Type` 1건인데 콤마 분해가 없다. FE 는 trim 만 하고 SP `P_SCP0120_GET_LOOKUP_MASTER` 도 단일 부분일치라 `A,B` 를 넣으면 0건이 된다(AS-IS 도 동일하나 이 축은 AS-IS 패리티가 아니라 전 UI 공통 요구다). 나머지 2건은 체크리스트 다중선택·단일선택이라 Key-in 이 아니다. 조용히 통과시키지 않고 실질 잔여로 남긴다 | 미구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용 | `ConstraintMgmt.tsx` — 두 `DataGrid` 에 `gridFilterRef` 전달(Main·Sub) | 공용 위임. `DataGrid` 의 `rebindFilterColumns` 가 재조회 후 필터 컬럼을 다시 묶는다. 화면이 필터를 직접 비우는 호출 0건 | 구현 |
