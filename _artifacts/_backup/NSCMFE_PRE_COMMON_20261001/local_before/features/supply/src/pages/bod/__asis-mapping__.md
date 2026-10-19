# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: `asis_mapping_gate.py --init`, 실제 대사(구현 위치/사유)는 `convert-gap-resolve` 세션이 AS-IS `SCP0007_BOD.cs` 원문 + TO-BE `nscm-fe/features/supply/src/pages/bod/**` 직접 대조로 채움(2026-09-21).
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.
> **2026-09-23 갱신**: `Doc/rules/mapping/asis_to_tobe.md §11`(EditButton 토글 어포던스 전 화면 미이식 결정)을 반영해 G1 관련 행 중 토글 어포던스 자체(D00-3-027/028~031/039, D00-4b-005, D00-4f-004, `CRUD:D00-4b-005:EDIT`)를 미구현→제외로 재분류했다. 반대로 D00-3-034/036(기존행 재편집 시 INCOTERMS_SSP 잠금 범위)은 새 룰의 예외 대상이 아니라 여전히 미구현으로 남겨뒀다(`kyr/screens/scp/bod-review-issues.md` #1 조사와 연결).
> **이번 대사에서 신규로 확정한 결함(기존 gap 표에 없던 것들)**: (1) `DIVISION_ID` 그리드 셀 콤보(신규행) 미배선(D00-3-009), (2) 저장 실패 errCode(99010~99040)별 셀 배경색 하이라이트 전체 미구현(D00-3-043~046, D00-4c-011) — `04_react-gap.md §2 표 #23 "통과"는 오기재였음`, (3) `ROUTE_ID` 셀 직접 키보드 편집 차단 미구현(D00-2-007, D00-4b-010), (4) **G16(FROM_SITE→TO_SITE cascade) 블로커 재평가 필요** — AS-IS가 실제로 쓰는 그리드 전용 콤보 `FromSiteByDivision1_SCP_ALL`(comboCalls #5, "Ex" 없는 변형)은 `OSP_YN`을 포함해(`ora.py` 실측 확인, 2026-09-21) 이미 `SCM_ADM_CMBO_SQL_M`에 등록돼 있다 — TO-BE가 이 콤보를 쓰지 않고 조회조건용 `FromSiteByDivision1Ex_SCP_ALL`(OSP_YN 없음)만 그리드에도 재사용한 것이 원인일 가능성이 높다. `convert-sp` 선행 없이 그리드 콤보 소스만 교체해도 풀릴 수 있음 — 다음 회차 우선 검증 대상.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 cboInputStatus / UsrCombo | `BodForm.tsx:153-166` |  | 구현 |
| D00-1-002 | §1 cboValidYN / UsrCombo | `BodForm.tsx:167-182` |  | 구현 |
| D00-1-003 | §1 clbDivision / UsrCheckedList2 | `BodForm.tsx:56-72` |  | 구현 |
| D00-1-004 | §1 clbFromSite / UsrCheckedList2 | `BodForm.tsx:73-88` |  | 구현 |
| D00-1-005 | §1 clbIncoterms / UsrCheckedList2 | `BodForm.tsx:105-120` |  | 구현 |
| D00-1-006 | §1 clbIncotermsSSP / UsrCheckedList2 | `BodForm.tsx:121-136` |  | 구현 |
| D00-1-007 | §1 clbToSite / UsrCheckedList2 | `BodForm.tsx:89-104` |  | 구현 |
| D00-1-008 | §1 clbTransMode / UsrCheckedList2 | `BodForm.tsx:137-152` |  | 구현 |
| D00-1-009 | §1 usrConditionPanel1 / UsrConditionPanel | `Bod.tsx:229-234`(MainTitle openSearchArea 토글), `BodForm.tsx:52`(SearchArea isHidden) |  | 구현 |
| D00-1-010 | §1 components / Container |  | WinForms 디자이너 전용 리소스 컨테이너 — React 대응 요소 없음(UI 동작과 무관) | 해당없음 |
| D00-1-011 | §1 emptySpaceItem1 / EmptySpaceItem |  | WinForms 레이아웃 여백 채움용 — MUI Grid 반응형 레이아웃이 자동 처리, 1:1 대응 요소 없음 | 해당없음 |
| D00-1-012 | §1 emptySpaceItem3 / EmptySpaceItem |  | 위와 동일 사유 | 해당없음 |
| D00-1-013 | §1 imageList1 / ImageList |  | ROUTE_ID 팝업 아이콘 리소스 컨테이너(cellTypeImage 배경, DefineProperty L197-204) — DataGrid 표준 셀 렌더로 대체, 별도 리소스 컨테이너 불필요 | 해당없음 |
| D00-1-014 | §1 layoutControlGroup1 / LayoutControlGroup |  | WinForms 레이아웃 컨테이너 — MUI `Grid` 컴포넌트 구조로 대체(레이아웃 컨테이너 자체는 일부 대응이나 개별 채번 대상 아님) | 해당없음 |
| D00-1-015 | §1 layoutControlGroup2 / LayoutControlGroup |  | 위와 동일 사유 | 해당없음 |
| D00-1-016 | §1 layoutControlItem1 / LayoutControlItem |  | 캡션 레이블 래퍼 — `FormItem label` prop 구조로 대체, 개별 채번 대상 아님 | 해당없음 |
| D00-1-017 | §1 layoutControlItem3 / LayoutControlItem |  | 위와 동일 사유 | 해당없음 |
| D00-1-018 | §1 layoutDivision / LayoutControlItem |  | Division 필드 레이아웃 래퍼 — `FormItem` 구조로 대체 | 해당없음 |
| D00-1-019 | §1 layoutFrom / LayoutControlItem |  | From Site 필드 레이아웃 래퍼 — 위와 동일 | 해당없음 |
| D00-1-020 | §1 layoutIncoterms / LayoutControlItem |  | Incoterms 필드 레이아웃 래퍼 — 위와 동일 | 해당없음 |
| D00-1-021 | §1 layoutSSPIncoterms / LayoutControlItem |  | SSP Incoterms 필드 레이아웃 래퍼 — 위와 동일 | 해당없음 |
| D00-1-022 | §1 layoutToSite / LayoutControlItem |  | To Site 필드 레이아웃 래퍼 — 위와 동일 | 해당없음 |
| D00-1-023 | §1 layoutTransMode / LayoutControlItem |  | Trans Mode 필드 레이아웃 래퍼 — 위와 동일 | 해당없음 |
| D00-1-024 | §1 usrLayoutControl1 / UsrLayoutControl |  | WinForms 커스텀 레이아웃 컨트롤(조건 영역 컨테이너) — `SearchArea`/`Grid` 구조로 대체 | 해당없음 |
| D00-1-025 | §1 usrLayoutControl2 / UsrLayoutControl |  | 위와 동일 사유(Division 권한체크 영역, `SetDivisionAuthCheck` L211-212 — 서버측 `MyDivision` 콤보 필터로 대체) | 해당없음 |
| D00-1-026 | §1 spdMain / FpSpread | `BodGrid.tsx`(`DataGrid` 컴포넌트 전체) |  | 구현 |
| D00-1-027 | §1 spdMain_Sheet1 / SheetView | `BodGrid.tsx`(단일 시트 `SHEETS.BOD`, 다중 시트 없음 — AS-IS도 시트 1개) |  | 구현 |
| D00-2-001 | §2 clbDivision / SelectedIndexChanged | `useBodStore.ts:58-71`(`setSearchParams`, division 변경 시 하위 체크리스트 reset) |  | 구현 |
| D00-2-002 | §2 dsdm / Changed | `BodGrid.tsx:247-249`(`handleCellEdit`, FROM/TO_SITE_CODE 변경 시 `applyCityCode` 호출) | AS-IS는 데이터모델 레벨 이벤트(`dsdm.Changed`)로 트리거하나 TO-BE는 Wijmo `cellEditEnded`/`pastedCell`로 동일 결과(SetCityCode 동등 로직)를 직접 호출 — 이벤트 소스만 다른 구조적 대체 | 구현 |
| D00-2-003 | §2 spdMain / CellDoubleClick | `BodGrid.tsx:252-261`(`handleDblClick`) |  | 구현 |
| D00-2-004 | §2 spdMain / ClipboardPasted | `BodGrid.tsx:307`(`pastedCell={handleCellEdit}`) |  | 구현 |
| D00-2-005 | §2 spdMain / ComboSelChange | `BodGrid.tsx:231-250`(`handleCellEdit`) | Wijmo 에는 FarPoint `ComboSelChange`에 대응하는 별도 이벤트가 없어 `cellEditEnded`(직접편집)로 통합 처리 — 콤보 셀도 결국 편집 종료 시 `cellEditEnded`가 발생하므로 동일 결과 | 구현 |
| D00-2-006 | §2 spdMain / EditChange | — | AS-IS `SpdMain_EditChange`(cs:1328-1353)의 2가지 동작 중 INCOTERMS_SSP 동기화(`BodGrid.tsx:237-244`)만 구현됨 — ROUTE_ID 직접편집 차단(`CancelCellEditing()`, cs:1330-1333)은 미구현(§D00-2-007과 동일 결함) | 미구현 |
| D00-2-007 | §2 spdMain / KeyPress | — | AS-IS `SpdMain_KeyPress`(cs:1322-1327)가 `ActiveColumnIndex==ROUTE_ID`일 때 `e.Handled=true`로 직접 키보드 입력을 막는다. TO-BE `BodGrid.tsx`에 ROUTE_ID 컬럼 편집 차단 로직이 없다(grep 0건) — 그리드 메타도 `CELL_CONTROL_OBJECT_TYPE_CODE` 미등록(ora.py 실측)이라 편집 자체를 막는 장치가 없다. ROUTE_ID는 팝업 선택으로만 채워져야 하는데 사용자가 직접 타이핑 가능한 상태 -- 중위험 — ROUTE_ID 직접 편집 시 Route 팝업 매칭 없는 값이 저장될 수 있음. `SpdMain_EditChange`의 `CancelCellEditing()`과 합쳐 재현 필요 | 미구현 |
| D00-3-001 | §3 SmartColMerge / () | — | **정정(2026-09-23, 소스 추적 완료)**: 종전 "FarPoint 상용 컴포넌트라 소스 없음(G8, 런타임 관측 블로커)" 기재는 틀렸음을 확인 — `SmartColMerge()`는 GSCM 자체 코드(`GSCM/01.Framework/GSCM.Windows.Forms/Class/SpreadInfo.cs:12376-12416`)에 정의돼 있고, 기본값 `_useRightMerge=MergeOption.SmartMerge`(L12345, BOD는 별도 세팅 없음)라 `SmartColMergeOld()`(L13201-13291)가 실행된다. 이 메서드는 첫 **visible + `MergePolicy.Restricted`** 컬럼(L13227-13235) 앞에 숨김 `COLMERGE` 컬럼을 1회 삽입(`MergePolicy.Always`, L13241-13246)하고, 매 호출마다 현재 viewport 행 범위에만 "X"를 채워 병합을 재계산한다(L13252-13279, 병합 로직 자체가 아니라 스크롤 가상화 최적화). "grep 0건" 기재도 틀렸다 — BOD는 `MergePolicy`를 직접 쓰지 않고 프레임워크 wrapper enum `FPMerge`(`AddTextColumn`/`AddComboColumn` 등의 `merge` 인자)를 통해 설정하며, 프레임워크의 `AddColumn()` 내부(예: `SpreadInfo.cs:4073-4087` 등 8곳에 동일 `switch` 중복)가 `FPMerge`를 `FarPoint.Win.Spread.Model.MergePolicy`에 그대로 1:1 대입한다. `SCP0007_BOD.cs` `InitSpread()`(L288-324) 실측 결과 `FPMerge.Restricted`로 등록된 컬럼은 `FROM_COUNTRY`(292,비visible)·`TO_COUNTRY`(293,비visible)·`BOD_ID`(296,비visible)·`DIVISION_ID`(297)·`CUSTOMER`(298)·`FROM_SITE_CODE`(299)·`FROM_CITY`(300)·`TO_SITE_CODE`(301)·`TO_CITY`(302)·`VMI_YN`(303)·`INCOTERMS`(304)·`TRANSPORT_MODE`(308) — 그리드 왼쪽의 "식별/라우팅" 컬럼 블록 전체이고, `SAFETY_STOCK`/`PRIORITY`/`ROUTE_CNT`/`ROUTE_ID`/요일 7종/`LEAD_TIME`/`BOD_VALID`/`ROUTE_VALID`/감사컬럼 4종/`ROUTE_CHK`는 `FPMerge.None`(병합 대상 아님). `FPMerge.Always`는 이 파일에 0건. **구현 완료(2026-09-23)**: `BodGrid.tsx`에 `MERGE_COLUMNS`(비visible 3개 제외 9개: DIVISION_ID/CUSTOMER/FROM_SITE_CODE/FROM_CITY/TO_SITE_CODE/TO_CITY/VMI_YN/INCOTERMS/TRANSPORT_MODE)를 정의하고, `<DataGrid allowMerging={AllowMerging.Cells}>`로 공용 `CustomMergeManager`(`packages/foundation/src/utils/mergeManager.ts`)를 활성화한 뒤, `updatedLayout` effect에서 `col.allowMerging = MERGE_COLUMNS.has(col.binding)`로 이 9개만 병합 대상으로 남기고 나머지 컬럼(공용 DataGrid가 `allowMerging` prop 켜지면 화면 표시 컬럼 전체에 일괄 true를 씌우므로)은 되돌린다. **알려진 제약**: 공용 `CustomMergeManager`는 왼쪽부터 누적한 키(`key(col)=key(col-1)+value(col)`)로 병합 여부를 판정하는 계층형 방식이라, `TRANSPORT_MODE`는 그 사이에 낀 `FPMerge.None` 컬럼(INCOTERMS_SSP/SAFETY_STOCK/PRIORITY/ROUTE_CNT)의 값까지 같아야 병합된다 — AS-IS FarPoint의 컬럼별 독립 `MergePolicy.Restricted` 판정과 정확히 같지 않다(값이 다르면 그냥 안 붙는 안전한 방향의 차이). DIVISION_ID~INCOTERMS 8개는 컬럼 순서가 연속이라 이 제약 없이 1:1 동작한다 | 구현 |
| D00-3-002 | §3 SetReNumerCellType / (PRIORITY,0,0,99) | `SCM_MST_SHEET_COLUMNS.PRIORITY.DATA_SCALE_NUMBER`(ora.py 실측: 공란=정수, AS-IS 소수 0자리와 등가) | 메타 위임 | 구현 |
| D00-3-003 | §3 SetReNumerCellType / (SAFETY_STOCK,0,1) | `SCM_MST_SHEET_COLUMNS.SAFETY_STOCK.DATA_SCALE_NUMBER=1`(ora.py 실측 확인) | 메타 위임 | 구현 |
| D00-3-004 | §3 SmartColMerge / () | `BodGrid.tsx`(`MERGE_COLUMNS` + `allowMerging` effect) | `InitSpread()`(cs:282) 내 호출(컬럼 정의 직후 최초 1회) — D00-3-001과 동일(구현 완료) | 구현 |
| D00-3-005 | §3 VisibleTab / (true) | — | FarPoint Spread 탭(시트 선택 UI) 표시 옵션 — React 그리드는 단일 뷰라 탭 개념 자체가 없음(AS-IS도 시트 1개뿐이라 탭 자체는 무의미했을 가능성 높음) -- React 단일뷰 그리드, 시트탭 개념 없음 | 해당없음 |
| D00-3-006 | §3 Visible= / SAFETY_STOCK.Visible=false | `SCM_MST_SHEET_COLUMNS.SAFETY_STOCK.VISIBLE_FLAG='N'`(ora.py 실측 확인) | 메타 위임 | 구현 |
| D00-3-007 | §3 Delete / () | `Bod.tsx:145-148`(`handleDelete`) |  | 구현 |
| D00-3-008 | §3 Insert / () | `Bod.tsx:111-139`(`handleInsert`) |  | 구현 |
| D00-3-009 | §3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision) | — | **신규 발견**: 신규행에서 DIVISION_ID를 "내 division 목록" 콤보로 제한하는 로직이 TO-BE에 없다(`BodGrid.tsx` grep 0건). DB 메타도 `CELL_CONTROL_OBJECT_TYPE_CODE`/`CELL_COMBO_DATA_TYPE` 둘 다 공란(ora.py 실측) — `03_grid-columns.md:118`도 "코드 전용 배선 필요"로 이미 명시했으나 실제 구현이 안 됐다. 조회조건 division이 정확히 1개일 때는 자동세팅+잠금(D00-3-016/017 구현됨)되어 영향 없지만, 다중/미선택 division으로 조회 후 신규행을 추가하면 DIVISION_ID가 자유 텍스트 입력이 되어 권한 없는 division 코드를 입력할 수 있다 -- 중위험 — 신규 발견, 권한 밖 division 입력 가능 | 미구현 |
| D00-3-010 | §3 SetValue / (VMI_YN,"N") | `Bod.tsx:127`(`defaultRow[VMI_YN]='N'`) |  | 구현 |
| D00-3-011 | §3 SetValue / (BOD_VALID,"Y") | `Bod.tsx:128`(`defaultRow[BOD_VALID]='Y'`) |  | 구현 |
| D00-3-012 | §3 SetValue / (BEFORE_LEAD_TIME,0) | `Bod.tsx:129` |  | 구현 |
| D00-3-013 | §3 SetValue / (AFTER_LEAD_TIME,0) | `Bod.tsx:130` |  | 구현 |
| D00-3-014 | §3 SetValue / (FROM_YYYYMMDD,sYYYYMMDD) | `Bod.tsx:121-124,131`(당주 월요일 계산) |  | 구현 |
| D00-3-015 | §3 SetValue / (TO_YYYYMMDD,"2099-12-27") | `Bod.tsx:132` |  | 구현 |
| D00-3-016 | §3 SetValue / (DIVISION_ID,strSel_Division) | `Bod.tsx:134-136`(division 2자리 단일선택 시에만) |  | 구현 |
| D00-3-017 | §3 LockRange / (DIVISION_ID,true) | `BodGrid.tsx:187-193`(자동세팅된 신규행만 잠금) |  | 구현 |
| D00-3-018 | §3 LockRange / (CUSTOMER,true) | `BodGrid.tsx:143-164`(`NEW_ROW_LOCKED_COLUMNS`) |  | 구현 |
| D00-3-019 | §3 LockRange / (FROM_CITY,true) | `BodGrid.tsx:143-164` |  | 구현 |
| D00-3-020 | §3 LockRange / (TO_CITY,true) | `BodGrid.tsx:143-164` |  | 구현 |
| D00-3-021 | §3 LockRange / (SAFETY_STOCK,true) | `BodGrid.tsx:172-179`(VMI_YN 기반 실시간 판정 — 신규행 기본 VMI_YN='N'이라 결과적으로 잠금) | AS-IS는 Insert 시점에 무조건 1회 잠그지만, TO-BE는 VMI_YN 값 기반 상시 판정 규칙(D00-3-072/073과 동일 로직)으로 통합돼 있어 신규행도 동일하게 커버됨(구조적 대체) -- 구조적 대체 | 구현 |
| D00-3-022 | §3 LockRange / (ROUTE_CNT,true) | `BodGrid.tsx:143-164` |  | 구현 |
| D00-3-023 | §3 LockRange / (ROUTE_ID..BOD_ID,true) | `BodGrid.tsx:143-164`(ROUTE_ID/LT_TYPE/DAYS_MON~SUN/LEAD_TIME/DIS_TOTAL_LEAD_TIME/BOD_ID) |  | 구현 |
| D00-3-024 | §3 LockRange / (ROUTE_VALID..end,true) | `BodGrid.tsx:143-164`(ROUTE_VALID/CREATED_BY/CREATION_DATE/LAST_UPDATED_BY/LAST_UPDATE_DATE/FROM_COUNTRY/TO_COUNTRY/ROUTE_CHK) |  | 구현 |
| D00-3-025 | §3 SetCellTypeCombo / (INCOTERMS, dtIncotermsEdit) | `SCM_MST_SHEET_COLUMNS.INCOTERMS.ATTRIBUTE9='incotermsEdit'`(ora.py 실측), `BodGrid.tsx:219-223`(주석) | 메타 위임 | 구현 |
| D00-3-026 | §3 SetCellTypeCombo / (INCOTERMS_SSP, dtIncotermsEdit) | `SCM_MST_SHEET_COLUMNS.INCOTERMS_SSP.ATTRIBUTE9='incotermsEdit'`(ora.py 실측) | 메타 위임 | 구현 |
| D00-3-027 | §3 SwitchLock / () | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(`asis_to_tobe.md §11`, 2026-09-23, SCP0007 G1 최초 확인) — R3 재질문 대상 아님. 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요(D00-3-034/036 참조) | 제외 |
| D00-3-028 | §3 LockColumn / (DIVISION_ID..INCOTERMS,true) | — | D00-3-027과 동일 근거(EditButton 진입 시 구간 재잠금 — 토글 어포던스 미이식 결정) | 제외 |
| D00-3-029 | §3 LockColumn / (ROUTE_CNT..TRANSPORT_MODE,true) | — | D00-3-027과 동일 근거. 인덱스 역순(AS-IS 해석 불가) 여부는 토글 자체가 없어져 더 이상 의미 없음 | 제외 |
| D00-3-030 | §3 LockColumn / (LT_TYPE..BOD_ID,true) | — | D00-3-027과 동일 근거 | 제외 |
| D00-3-031 | §3 LockColumn / (ROUTE_VALID..end,true) | — | D00-3-027과 동일 근거 | 제외 |
| D00-3-032 | §3 LockRange / (i,SAFETY_STOCK,true) | `BodGrid.tsx:172-179` | EditButton 진입 시 전행 순회 초기화 로직이나, TO-BE는 VMI_YN 값 기반 상시 실시간 판정으로 대체돼 있어 EditButton 유무와 무관하게 항상 올바른 상태 유지(D00-3-021과 동일 근거) -- 구조적 대체 | 구현 |
| D00-3-033 | §3 LockRange / (i,INCOTERMS_SSP,false) | `BodGrid.tsx:195-204` | EditButton() 내부 로직으로, TO_SITE=PLANT 행의 INCOTERMS_SSP 편집을 여는 것 — TO-BE가 동일 조건(toSiteType==='PLANT')을 beginningEdit 시점에 실시간 판정하므로 결과는 동일(구조적 대체) | 구현 |
| D00-3-034 | §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncotermsEdit) | `SCM_MST_SHEET_COLUMNS.INCOTERMS_SSP.ATTRIBUTE9='incotermsEdit'` | EditButton 진입 시 전행에 신규행 전용 콤보로 스왑하는 로직이나, TO-BE는 ATTRIBUTE9가 CRUD_TYPE='I'(신규행)에만 적용되고 기존행 재편집에는 적용되지 않는다. **토글 어포던스 미이식 결정(D00-3-027 등, §11)의 예외 대상 아님** — 이건 "어떤 컬럼이 잠겨야 하는가"라는 실질 잠금 범위 질문이라 계속 R1/R2 검증 대상(`kyr/screens/scp/bod-review-issues.md` #1과 동일 잔여 갭) — 기존행 재편집 시 dtIncotermsEdit 스왑 없음 | 미구현 |
| D00-3-035 | §3 LockRange / (i,INCOTERMS_SSP,true) | `BodGrid.tsx:195-204` | D00-3-033과 동일 근거(TO_SITE≠PLANT 행 잠금, 구조적 대체) -- 구조적 대체 | 구현 |
| D00-3-036 | §3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncoterms) | — | D00-3-034와 동일 근거(EditButton 진입 시 원래 콤보로 복귀) — TO-BE는 이 스왑 자체가 없음(콤보는 조회조건과 동일한 `Incoterms` SQL_ID 고정, 단 §G18 대소문자 결함 별도). **토글 어포던스 미이식 결정의 예외 대상 아님**(D00-3-034와 동일 이유) | 미구현 |
| D00-3-037 | §3 LockRange / (i,INCOTERMS_SSP,true) | `BodGrid.tsx:195-204` | D00-3-035와 동일(중복 라인, AS-IS 원본 자체가 else 분기에 동일 호출 반복) -- 구조적 대체 | 구현 |
| D00-3-038 | §3 Query / (ds) | `Bod.tsx:45-51`(`useTabProcQuery`, `data.o_rc1`을 그리드에 바인딩) | AS-IS는 명시적 `Query(ds)` 호출로 데이터소스를 그리드에 연결하나 TO-BE는 react-query 결과를 `DataGrid itemsSource` prop으로 바인딩하는 선언적 구조 — 결과 동일 -- 구조적 대체 | 구현 |
| D00-3-039 | §3 LockColumn / (0..max,true) | — | 조회 직후 그리드 전체 컬럼을 잠그는 로직(EditButton 클릭 전 초기상태) — D00-3-027과 동일 근거(토글 어포던스 미이식 결정, 잠금 해제가 아니라 최초 잠금 쪽 대응) | 제외 |
| D00-3-040 | §3 SmartColMerge / () | `BodGrid.tsx`(`MERGE_COLUMNS` + `allowMerging` effect) | **정정(2026-09-23)**: 종전 "`EditButton()`(cs:582) 내 호출" 인용이 stale — 실측 결과 cs:582는 `EditButton()`(L438 시작)이 아니라 `FindData_Main()`(L508 시작, 조회/데이터 로드 메서드) 내부이며, 직전 `SetSearchCount(ds)`(578)·직후 `Set_ValidTextColor()`(585) 사이에 위치한다. 즉 EditButton 진입 부수효과가 아니라 **조회 결과 로드 직후마다** 재호출되는 트리거다(§11 EditButton 예외 여부와 무관 — 애초에 EditButton과 무관한 호출). D00-3-001/004와 동일(구현 완료) | 구현 |
| D00-3-041 | §3 SetValue / (i,FROM_YYYYMMDD,mondayDate) | `bod.util.ts:107-112`(`validateBodRows`, 월요일 아니면 자동보정) |  | 구현 |
| D00-3-042 | §3 SetValue / (i,TO_YYYYMMDD,sundayDate) | `bod.util.ts:114-119` |  | 구현 |
| D00-3-043 | §3 SetBGColor / (DIVISION_ID..INCOTERMS,InvalidColor) | — | **신규 발견**: 저장 실패(SP 응답 errCode 99010/99020/99030/99040)시 중복행의 DIVISION_ID~INCOTERMS 구간을 배경색으로 강조하는 로직(cs:900-916). TO-BE `Bod.tsx` `mutate()`(L78-103)는 서버 에러 메시지를 alert으로만 표시하고 셀 하이라이트는 전혀 없다(grep `99010`,`InvalidColor` 0건) — `04_react-gap.md §2 표 #23 "저장 실패 errCode별 강조색 4패턴 — 통과"는 오기재였다(이전 회차가 근거 없이 통과 처리)** -- 고위험, 오기재 정정 — 저장 실패 원인 컬럼이 시각적으로 구분되지 않아 사용자가 어느 행이 문제인지 알기 어려움 | 미구현 |
| D00-3-044 | §3 SetBGColor / (TRANSPORT_MODE..TO_YYYYMMDD,InvalidColor) | — | D00-3-043과 동일 결함(errCode 99030/99040 분기) -- 고위험, D00-3-043과 동일 사유 | 미구현 |
| D00-3-045 | §3 SetBGColor / (TRANSPORT_MODE,InvalidColor) | — | D00-3-043과 동일 결함(errCode 99010 분기) -- 고위험, D00-3-043과 동일 사유 | 미구현 |
| D00-3-046 | §3 SetBGColor / (PRIORITY,InvalidColor) | — | D00-3-043과 동일 결함(errCode 99020 분기) -- 고위험, D00-3-043과 동일 사유 | 미구현 |
| D00-3-047 | §3 SetFGColor / (nStartColIdx..nEndColIdx,InvalidFGColor) | `BodGrid.tsx:271-298`(`formatItem` 핸들러, `ROUTE_VALID_DIMMED_COLUMNS`) |  | 구현 |
| D00-3-048 | §3 SetFGColor / (nStartColIdx..nEndColIdx,DefaultForeColor) | `BodGrid.tsx:271-298`(동일 핸들러, 해제 분기) |  | 구현 |
| D00-3-049 | §3 SetFGColor / (ROUTE_ID,DefaultForeColor) | `BodGrid.tsx:282-285`(ROUTE_CHK==='Y' 분기) |  | 구현 |
| D00-3-050 | §3 SetFGColor / (ROUTE_ID,MarkedForeColor) | `BodGrid.tsx:282-285`(ROUTE_CHK!=='Y' 분기) |  | 구현 |
| D00-3-051 | §3 SetText / (ROUTE_ID,dr["ROUTE_ID"]) | `Bod.tsx:161`(`handleRouteSelect`) |  | 구현 |
| D00-3-052 | §3 SetText / (TRANSPORT_MODE,dr["TRANSPORT_MODE_NAME"]) | `Bod.tsx:164` |  | 구현 |
| D00-3-053 | §3 SetText / (PRIORITY,dr["PRIORITY"]) | `Bod.tsx:165` |  | 구현 |
| D00-3-054 | §3 SetText / (DAYS_MON,dr["DAYS_MON"]) | `Bod.tsx:166`(`DAY_OF_WEEK_COLUMNS` 루프) |  | 구현 |
| D00-3-055 | §3 SetText / (DAYS_TUE,dr["DAYS_TUE"]) | `Bod.tsx:166` |  | 구현 |
| D00-3-056 | §3 SetText / (DAYS_WED,dr["DAYS_WED"]) | `Bod.tsx:166` |  | 구현 |
| D00-3-057 | §3 SetText / (DAYS_THU,dr["DAYS_THU"]) | `Bod.tsx:166` |  | 구현 |
| D00-3-058 | §3 SetText / (DAYS_FRI,dr["DAYS_FRI"]) | `Bod.tsx:166` |  | 구현 |
| D00-3-059 | §3 SetText / (DAYS_SAT,dr["DAYS_SAT"]) | `Bod.tsx:166` |  | 구현 |
| D00-3-060 | §3 SetText / (DAYS_SUN,dr["DAYS_SUN"]) | `Bod.tsx:166` |  | 구현 |
| D00-3-061 | §3 SetText / (ROUTE_VALID,dr["VALID_YN"]) | `Bod.tsx:167` |  | 구현 |
| D00-3-062 | §3 SetText / (DIS_TOTAL_LEAD_TIME,dr["LT_SUM"]) | `Bod.tsx:168` |  | 구현 |
| D00-3-063 | §3 SetText / (LT_TYPE,dr["LT_TYPE"]) | `Bod.tsx:169` |  | 구현 |
| D00-3-064 | §3 SetText / (BOD_VALID,"Y") | `Bod.tsx:170` |  | 구현 |
| D00-3-065 | §3 SetActiveCell / (e.Row,e.Column) | — | Route 팝업 선택 후 커서를 해당 셀로 이동시키는 UX 동작 — `Bod.tsx handleRouteSelect`에 대응 로직 없음(`GridUtils.refreshRow`만 호출) -- 저위험, UX 커서이동 | 미구현 |
| D00-3-066 | §3 ShowCell / (0,0,e.Row,e.Column,Center,Right) | — | 위와 동일(선택 셀을 화면 중앙으로 스크롤) -- 저위험, D00-3-065와 동일 사유 | 미구현 |
| D00-3-067 | §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd) | — | FROM_SITE_CODE 변경 시(`sFromSite=='E'`) TO_SITE 콤보를 `ToSiteBOD1_SCP_ALL` 계열로 교체 — TO-BE `BodGrid.tsx`는 TO_SITE_CODE 셀 콤보를 항상 고정(`ToSiteByDivision`)으로만 쓰고 FROM_SITE_CODE 값에 따른 3분기 전환이 없다(G16과 동일 축, `resolveToSiteBucket` 호출부 0건) -- 중위험, G16 | 미구현 |
| D00-3-068 | §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd) | — | `sFromSite=='A' && OSP_YN=='Y'` 분기(`ToSiteByDivisionPlant1_SCP_ALL`) — 위와 동일 결함(G16) -- 중위험, G16 | 미구현 |
| D00-3-069 | §3 SetCellTypeCombo / (e.Row,TO_SITE_CODE,dtToSiteOfSpd) | — | 그 외 분기(`ToSiteByDivision1_SCP_ALL`) — 위와 동일 결함(G16) -- 중위험, G16 | 미구현 |
| D00-3-070 | §3 SetValue / (e.Row,FROM_CITY,dr["CITY"]) | `BodGrid.tsx:83-84`(`applyCityCode`) | ComboSelChange 시점(직접 편집)의 개별 호출이나, TO-BE는 `cellEditEnded`에서 동일 결과를 산출하는 `applyCityCode`로 통합(구조적 대체) -- 구조적 대체 | 구현 |
| D00-3-071 | §3 SetValue / (e.Row,TO_CITY,dr["CITY"]) | `BodGrid.tsx:87-88`(`applyCityCode`) | 구조적 대체 | 구현 |
| D00-3-072 | §3 LockRange / (e.Row,SAFETY_STOCK,false) | `BodGrid.tsx:172-179`(VMI_YN==='Y' 분기) |  | 구현 |
| D00-3-073 | §3 LockRange / (e.Row,SAFETY_STOCK,true) | `BodGrid.tsx:172-179`(VMI_YN!=='Y' 분기) |  | 구현 |
| D00-3-074 | §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd) | — | `SpdMain_ClipboardPasted`(붙여넣기)의 동일 3분기 — D00-3-067과 동일 결함(G16) -- 중위험, G16 | 미구현 |
| D00-3-075 | §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd) | — | 위와 동일(G16) -- 중위험, G16 | 미구현 |
| D00-3-076 | §3 SetCellTypeCombo / (iRow,TO_SITE_CODE,dtToSiteOfSpd) | — | 위와 동일(G16) -- 중위험, G16 | 미구현 |
| D00-3-077 | §3 SetValue / (iRow,FROM_CITY,dr["CITY"]) | `BodGrid.tsx:83-84,307`(`applyCityCode`가 `pastedCell`에도 배선됨) | 구조적 대체 | 구현 |
| D00-3-078 | §3 SetValue / (iRow,TO_CITY,dr["CITY"]) | `BodGrid.tsx:87-88,307` | 구조적 대체 | 구현 |
| D00-3-079 | §3 LockRange / (iRow,SAFETY_STOCK,false) | `BodGrid.tsx:172-179`(붙여넣기도 `beginningEdit` 실시간 판정 경로를 그대로 통과) | 구조적 대체 | 구현 |
| D00-3-080 | §3 LockRange / (iRow,SAFETY_STOCK,true) | `BodGrid.tsx:172-179` | 구조적 대체 | 구현 |
| D00-3-081 | §3 SetText / (iRow,INCOTERMS_SSP,GetText(INCOTERMS)) | `BodGrid.tsx:237-244,307`(`handleCellEdit`이 `pastedCell`에도 배선) | 구조적 대체 | 구현 |
| D00-3-082 | §3 SetText / (e.Row,INCOTERMS_SSP,GetText(INCOTERMS)) | `BodGrid.tsx:237-244`(직접편집, `SpdMain_EditChange` 중 INCOTERMS_SSP 동기화 부분) |  | 구현 |
| D00-3-083 | §3 GetViewRowFromModelRow / (nRow) | `BodGrid.tsx:75-119`(`applyCityCode`가 grid API로 행을 직접 조작, 모델행/뷰행 변환이 Wijmo 내부에서 처리돼 별도 변환 불필요) | Wijmo는 FarPoint와 달리 모델행/뷰행 분리 API가 노출되지 않아 이 변환 자체가 불필요(프레임워크 차이) -- Wijmo 구조상 불필요 | 해당없음 |
| D00-3-084 | §3 SetText / (nRow,INCOTERMS_SSP,GetText(INCOTERMS)) | `BodGrid.tsx:92-97`(`applyCityCode`, TO_SITE=PLANT && DAP 분기) | 구조적 대체 | 구현 |
| D00-3-085 | §3 LockRange / (nViewRow,INCOTERMS,true) | `BodGrid.tsx:385-395`(TO_SITE=PLANT 분기, 편집 잠금 — 2026-09-23 신규 추가) |  | 구현 |
| D00-3-086 | §3 LockRange / (nViewRow,INCOTERMS_SSP,false) | `BodGrid.tsx:373-383`(TO_SITE=PLANT 분기, 편집 허용) |  | 구현 |
| D00-3-087 | §3 LockRange / (nViewRow,INCOTERMS,false) | `BodGrid.tsx:385-395`(TO_SITE≠PLANT 분기, 편집 허용 — 2026-09-23 신규 추가) |  | 구현 |
| D00-3-088 | §3 LockRange / (nViewRow,INCOTERMS_SSP,true) | `BodGrid.tsx:373-383`(TO_SITE≠PLANT 분기, 편집 잠금) |  | 구현 |
| D00-3-089 | §3 LockRange / (nViewRow,SAFETY_STOCK,false) | `BodGrid.tsx:172-179` | 구조적 대체, VMI_YN 기반 통합 판정 | 구현 |
| D00-3-090 | §3 LockRange / (nViewRow,SAFETY_STOCK,true) | `BodGrid.tsx:172-179` | 구조적 대체 | 구현 |
| D00-4a-001 | §4a SCP.SCP0007_GET_BOD / FindData_Main | `Bod.tsx:45-51` |  | 구현 |
| D00-4a-002 | §4a SCP.SCP0007_GET_COUNTRY_CITY / GetData_Country | `Bod.tsx:63-69` |  | 구현 |
| D00-4a-003 | §4a SCP.SCP0007_SAVE_BOD / SaveData_Main | `Bod.tsx:78-103`(`mutate`) |  | 구현 |
| D00-4a-004 | §4a SCP.SCP0007_GET_ROUTE_CNT / SetCityCode | `BodGrid.tsx:105-116`(`applyCityCode`) |  | 구현 |
| D00-4b-001 | §4b FindButton / toolbarOverride / Search | `Bod.tsx:213-216`(`hasButton('SEARCH')`) |  | 구현 |
| D00-4b-002 | §4b SaveButton / toolbarOverride / Save | `Bod.tsx:213-216`(`hasButton('SAVE')`) |  | 구현 |
| D00-4b-003 | §4b SpdMain_Changed / event(dsdm.Changed) / — | `BodGrid.tsx:247-249` | D00-2-002와 동일(구조적 대체) -- 구조적 대체 | 구현 |
| D00-4b-004 | §4b DeleteButton / toolbarOverride / Delete | `Bod.tsx:213-216`(`hasButton('SAVE')` 게이트, AS-IS는 별도 권한 없음 — `04_react-gap.md §0-2` 근거) |  | 구현 |
| D00-4b-005 | §4b EditButton / toolbarOverride / Edit | — | D00-3-027과 동일 근거(토글 어포던스 미이식 결정) | 제외 |
| D00-4b-006 | §4b InsertButton / toolbarOverride / Insert | `Bod.tsx:213-216`(`hasButton('SAVE')`) |  | 구현 |
| D00-4b-007 | §4b SpdMain_ClipboardPasted / event / spdMain.ClipboardPasted | `BodGrid.tsx:307` |  | 구현 |
| D00-4b-008 | §4b SpdMain_ComboSelChange / event / spdMain.ComboSelChange | `BodGrid.tsx:306`(`cellEditEnded`) | 구조적 대체 | 구현 |
| D00-4b-009 | §4b SpdMain_EditChange / event / spdMain.EditChange | — | INCOTERMS_SSP 동기화(`BodGrid.tsx:237-244`)만 구현, ROUTE_ID 편집 차단은 미구현(D00-2-006/007과 동일) | 미구현 |
| D00-4b-010 | §4b SpdMain_KeyPress / event / spdMain.KeyPress | — | D00-2-007과 동일(신규 발견, ROUTE_ID 직접 편집 차단 없음) -- 중위험 | 미구현 |
| D00-4b-011 | §4b SpdMain_TopChange / event / spdMain.TopChange | — | `SpdMain_TopChange`(cs:190-193) 내 `SmartColMerge()` 호출 — 그리드 스크롤(TopChange)마다 재적용, D00-3-001의 viewport 가상화 재계산(L13252-13279)이 실제 발동하는 지점. TO-BE는 Wijmo `FlexGrid`가 스크롤 시 병합을 별도 트리거 없이 자체 재계산하므로 구조적 대체(D00-3-001 구현으로 커버) -- 구조적 대체, 별도 채번하지 않고 D00-3-001로 통합 | 구현 |
| D00-4b-012 | §4b cboDivision_SelectedIndexChanged / event / clbDivision.SelectedIndexChanged | `useBodStore.ts:58-71` |  | 구현 |
| D00-4b-013 | §4b spdMain_CellDoubleClick / event / spdMain.CellDoubleClick | `BodGrid.tsx:252-261` |  | 구현 |
| D00-4c-001 | §4c MSG00159 / GMessageBox | `Bod.tsx:113-119` |  | 구현 |
| D00-4c-002 | §4c (없음) / GMessageBoxForException | — | `FindData_Main` 조회 실패 시 예외 처리(cs:592 문맥, `SP 조회 예외` 추정) — TO-BE `useTabProcQuery`의 공통 에러 처리(React Query 표준 에러 바운더리)로 대체되는지 소스만으로 확정 불가 | 제외 |
| D00-4c-003 | §4c MSG00085 / GMessageBox | `bod.util.ts:79-82`(BEFORE_LEAD_TIME) |  | 구현 |
| D00-4c-004 | §4c MSG00085 / GMessageBox | `bod.util.ts:84-87`(AFTER_LEAD_TIME) |  | 구현 |
| D00-4c-005 | §4c MSG00165 / GMessageBox | `bod.util.ts:89-92`(REMARKS 바이트길이) |  | 구현 |
| D00-4c-006 | §4c MSG00219 / GMessageBox | `bod.util.ts:99-105`(FROM>TO) |  | 구현 |
| D00-4c-007 | §4c MSG00355 / GMessageBox | `bod.util.ts:107-112`(FROM≠월요일) |  | 구현 |
| D00-4c-008 | §4c MSG00355 / GMessageBox | `bod.util.ts:114-119`(TO≠일요일) |  | 구현 |
| D00-4c-009 | §4c MSG00253 / GMessageBox | `bod.util.ts:122-126`(FROM_SITE=TO_SITE) |  | 구현 |
| D00-4c-010 | §4c MSG00004 / GMessageBox | `Bod.tsx:94`(`CRUD_MSG.SAVED` 토스트) | AS-IS는 저장건수를 포함한 alert(MSG00004), TO-BE는 공통 저장성공 토스트(`CRUD_MSG.SAVED`)로 대체 — 메시지 내용(건수 포함 여부)은 다르나 저장 성공 알림 자체는 동등 -- 구조적 대체, 메시지 문구 단순화 | 구현 |
| D00-4c-011 | §4c (없음) / GMessageBox / errCode in {99010..99040} | — | D00-3-043~046과 동일 결함 — errCode별 구체 메시지(중복기간/중첩기간 등) 없이 서버가 내려준 공용 메시지만 alert로 표시(`Bod.tsx:88-92`) -- 고위험, D00-3-043~046과 결합 | 미구현 |
| D00-4c-012 | §4c MSG00006 / GMessageBox | `Bod.tsx:100`(`CRUD_MSG.SAVE_FAIL`) | 구조적 대체 | 구현 |
| D00-4c-013 | §4c (없음) / GMessageBoxForException | `Bod.tsx:96-102`(`catch` 블록, `setAlert`) | 구조적 대체 | 구현 |
| D00-4d-001 | §4d BLUtils.GetDivisionWithoutEE / false | `SCM_ADM_CMBO_SQL_M.MyDivision.SQL_DTL_CTN`(`WHERE A.ATTRIBUTE3 <> 'EE'`, ora.py 실측, G17) | 메타 위임, 서버 콤보 SQL | 구현 |
| D00-4d-002 | §4d Data_SCP.CommonAll / Customer1 | — | `dtCustomerAll`은 `boundControl=없음`(00_checklist.md §4d #2) — AS-IS 소스상으로도 화면에 바인딩된 컨트롤이 없다(CUSTOMER 컬럼은 `AddTextColumn`이며 콤보가 아님, InitSpread 주석블록 L298). 용도가 SetChangeControl의 `filterExpression` 준비용 후보 테이블일 뿐 실제 그리드 셀 콤보로 쓰이지 않음(TO-BE `SCM_MST_SHEET_COLUMNS.CUSTOMER`도 콤보 메타 미등록, ora.py 실측) -- AS-IS도 미바인딩 후보 테이블, 그리드 콤보 아님 | 해당없음 |
| D00-4d-003 | §4d Data_SCP.CommonAll / FromSiteByDivision1Ex | `bod.constants.ts:92`(`BOD_COMBO_ID.FROM_SITE`, 조회조건) |  | 구현 |
| D00-4d-004 | §4d Data_SCP.CommonAll / ToSiteBOD1 | `bod.constants.ts:94`(`BOD_COMBO_ID.TO_SITE`, 조회조건) |  | 구현 |
| D00-4d-005 | §4d Data_SCP.CommonAll / FromSiteByDivision1 | — | **신규 중요 발견**: 그리드 FROM_SITE_CODE 셀 콤보 전용 원천(`dtFromSiteOfSpd`, `SpreadInfo.SetComBoParam`, cs:273)으로, `OSP_YN` 컬럼을 반환한다(`ora.py` 실측: `SCM_ADM_CMBO_SQL_M.FromSiteByDivision1_SCP_ALL.SQL_DTL_CTN`에 `OSP_YN` 포함 확인, 2026-09-21). TO-BE는 이 콤보를 전혀 쓰지 않고 조회조건용 `FromSiteByDivision1Ex_SCP_ALL`(OSP_YN 없음)만 존재해, G16(TO_SITE cascade)이 "OSP_YN을 어디서도 못 받는다"는 전제로 SP선행(convert-sp)이 필요하다고 판정했었다 — **그 전제가 틀렸을 가능성이 높다.** `FromSiteByDivision1_SCP_ALL`을 그리드 FROM_SITE_CODE 셀 콤보 원천으로 신규 배선하면 OSP_YN을 코드 변경만으로 확보할 수 있다(G16 재평가 필요, convert-sp 불필요할 수도 있음) -- 중위험, G16 원인 재평가 필요 — SP선행 아닐 수 있음 | 미구현 |
| D00-4d-006 | §4d Data_SCP.CommonAll / ToSiteBOD1 | — | 그리드 TO_SITE_CODE 셀 콤보 원천(`dtToSiteOfSpd`) 중 하나(`sFromSite=='E'` 분기) — D00-3-067과 동일 결함(G16) -- 중위험, G16 | 미구현 |
| D00-4d-007 | §4d Data_SCP.CommonAll / ToSiteByDivisionPlant1 | — | 그리드 TO_SITE_CODE 셀 콤보 원천 중 하나(`sFromSite=='A'&&OSP` 분기) — G16과 동일 -- 중위험, G16 | 미구현 |
| D00-4d-008 | §4d Data_SCP.CommonAll / ToSiteByDivision1 | — | 그리드 TO_SITE_CODE 셀 콤보 원천 중 하나(그 외 분기) — G16과 동일 -- 중위험, G16 | 미구현 |
| D00-4d-009 | §4d Data.Common / LookupCommon(INCOTERMS) | `bod.constants.ts:96`(조회조건, `Incoterms` SQL_ID) | 조회조건 축 | 구현 |
| D00-4d-010 | §4d Data.Common / LookupCommon(TRANSPORT_MODE_CODE) | `bod.constants.ts:98`(`TransModeCode`) |  | 구현 |
| D00-4d-011 | §4d Data.Common / YesOrNo | `SCM_MST_SHEET_COLUMNS.VMI_YN/BOD_VALID.CELL_COMBO_DATA_TYPE='YesOrNo'`(ora.py 실측, `CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox'`) | 메타 위임 | 구현 |
| D00-4d-012 | §4d Data.Common / incotermsEdit | `SCM_MST_SHEET_COLUMNS.INCOTERMS/INCOTERMS_SSP.ATTRIBUTE9='incotermsEdit'`(ora.py 실측) | 메타 위임, 신규행 한정 | 구현 |
| D00-4e-001 | §4e dtFromSiteAll / SetChangeControl | `bod.util.ts:23-43`(`buildDivisionFilteredOptions`) |  | 구현 |
| D00-4e-002 | §4e dtToSiteAll / SetChangeControl | `bod.util.ts:23-43`(`BodForm.tsx:99` 호출) |  | 구현 |
| D00-4e-003 | §4e dtCustomerAll / SetChangeControl | — | D00-4d-002와 동일 사유(그리드 콤보 자체가 없음) | 해당없음 |
| D00-4e-004 | §4e dtCustomerAll / FindData_Main | — | 위와 동일 | 해당없음 |
| D00-4e-005 | §4e dtFromSiteOfSpdAll / FindData_Main | — | D00-4d-005와 동일(그리드 FROM_SITE 콤보 division 필터) — 콤보 자체가 미배선이라 필터도 미구현(G16) -- G16과 결합 | 미구현 |
| D00-4e-006 | §4e dtToSiteOfSpdAll / FindData_Main | — | D00-4d-006과 동일(G16) -- G16과 결합 | 미구현 |
| D00-4e-007 | §4e dtToSiteOfSpdAll / SpdMain_ComboSelChange | — | G16과 동일 -- G16과 결합 | 미구현 |
| D00-4e-008 | §4e dtToSiteOfSpdAll1 / SpdMain_ComboSelChange | — | G16과 동일 -- G16과 결합 | 미구현 |
| D00-4e-009 | §4e dtToSiteOfSpdAll2 / SpdMain_ComboSelChange | — | G16과 동일 -- G16과 결합 | 미구현 |
| D00-4e-010 | §4e dtToSiteOfSpdAll / SpdMain_ClipboardPasted | — | G16과 동일(붙여넣기 경로) -- G16과 결합 | 미구현 |
| D00-4e-011 | §4e dtToSiteOfSpdAll1 / SpdMain_ClipboardPasted | — | G16과 동일 -- G16과 결합 | 미구현 |
| D00-4e-012 | §4e dtToSiteOfSpdAll2 / SpdMain_ClipboardPasted | — | G16과 동일 -- G16과 결합 | 미구현 |
| D00-4f-001 | §4f DeleteButton / Delete / action != FlagI | `packages/foundation/src/utils/gridAction.ts`(`deleteOnlyNew=true`, `Bod.tsx:147`) |  | 구현 |
| D00-4f-002 | §4f InsertButton / Insert / InputStatus=="R" | `Bod.tsx:113-119` |  | 구현 |
| D00-4f-003 | §4f spdMain_CellDoubleClick / RowCount<=0 | — | Wijmo는 그리드 행이 0건이면 셀 자체가 없어 더블클릭 이벤트가 발생하지 않는다 — 별도 가드 불필요 -- Wijmo 구조상 불필요 | 해당없음 |
| D00-4f-004 | §4f spdMain_CellDoubleClick / !IsLock(SheetName) | — | 시트 레벨 잠금(EditButton 이전 상태) 개념 자체가 TO-BE에 없음 — D00-3-027과 동일 근거(토글 어포던스 미이식 결정) | 제외 |
| D00-4f-005 | §4f spdMain_CellDoubleClick / Column==ROUTE_ID | `BodGrid.tsx:257` |  | 구현 |
| D00-4f-006 | §4f spdMain_CellDoubleClick / arList.Count==0 | `BodDistributionRoutePopup.tsx:87-89`(`handleApply`, selected 없으면 return), `Bod.tsx:158-159`(`handleRouteSelect`, row/rowIndex 없으면 return) | 구조적 대체 | 구현 |
| D00-4f-007 | §4f SpdMain_ComboSelChange / RowCount==0 | — | Wijmo `cellEditEnded`는 편집 가능한 셀이 있어야 발생 — 행 0건이면 이벤트 자체가 발생하지 않아 가드 불필요 -- Wijmo 구조상 불필요 | 해당없음 |
| D00-4f-008 | §4f SpdMain_ClipboardPasted / RowCount==0 | — | 위와 동일(붙여넣기 대상 셀이 없으면 이벤트 미발생) -- Wijmo 구조상 불필요 | 해당없음 |
| D00-4f-009 | §4f SpdMain_Changed / !CanModelChange | — | FarPoint 특유의 재귀 변경 방지 플래그 — Wijmo `cellEditEnded`/`pastedCell`은 프로그램적 데이터 갱신 시 재귀 발동하지 않는 구조라 별도 플래그 불필요(React 상태관리 특성) -- Wijmo 구조상 불필요 | 해당없음 |
| D00-4f-010 | §4f SpdMain_Changed / ds==null | — | React Query 데이터가 없으면 그리드 자체가 빈 배열을 받아 편집 이벤트가 발생할 데이터가 없음 — 가드 불필요 -- 구조상 불필요 | 해당없음 |
| D00-4f-011 | §4f SpdMain_Changed / e.Column<1 | — | Wijmo는 `binding` 문자열 기반이라 FarPoint의 정수 컬럼 인덱스 가드(0번=RowHeader 제외) 개념이 없음 -- Wijmo 구조상 불필요 | 해당없음 |
| D00-4f-012 | §4f SpdMain_Changed / Column!=FROM_SITE_CODE&&!=TO_SITE_CODE | `BodGrid.tsx:247-249`(`handleCellEdit`이 정확히 이 두 컬럼만 `applyCityCode` 분기) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:D00-4b-001:SEARCH | [SEARCH] §4b FindButton / toolbarOverride / Search | `Bod.tsx:213-216` |  | 구현 |
| CRUD:D00-4b-002:SAVE | [SAVE] §4b SaveButton / toolbarOverride / Save | `Bod.tsx:213-216` |  | 구현 |
| CRUD:D00-4b-004:DELETE | [DELETE] §4b DeleteButton / toolbarOverride / Delete | `Bod.tsx:213-216,145-148` |  | 구현 |
| CRUD:D00-4b-005:EDIT | [EDIT] §4b EditButton / toolbarOverride / Edit | — | D00-3-027과 동일 근거(토글 어포던스 미이식 결정) | 제외 |
| CRUD:D00-4b-006:INSERT | [INSERT] §4b InsertButton / toolbarOverride / Insert | `Bod.tsx:213-216,111-139` |  | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | `BodDistributionRoutePopup.tsx`(전체) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | `packages/foundation/src/utils/gridAction.ts`(`GridAction.addRow`, `Bod.tsx:138`이 호출) | 공통 유틸(`GridAction.addRow`)의 표준 동작에 위임하나, 이 화면 세션에서 `gridAction.ts`의 필터 유지 로직 자체(`keepRowVisibleUnderFilter` 옵션 존재 여부)를 직접 열람해 확정하지 못했다 — 공통 유틸이므로 다른 화면과 동일하게 동작할 가능성이 높으나 실측 없이 PASS로 단정하지 않는다 | 제외 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | — | `Bod.tsx`의 `onSearch`(`BodForm.tsx:44-47`)는 dirty 상태 확인 없이 즉시 `setFilters()`를 호출한다(grep `MSG00703`/`confirm` 0건) — 공통 훅(`useSaveWithValidation` 등)이 전역으로 가로채는지 별도 확인 필요 | 제외 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | `useBodStore.ts:78-105`(`fetchStaticColumns`) | 컬럼 메타 재조회 자체는 구현돼 있으나, "적용 시 기존 조회 데이터 Reset" 동작이 이 화면 코드에 명시적으로 없다 — 공통 admin 컬럼 설정 UI의 표준 흐름(재조회 트리거)에 위임되는지 직접 확인 못함 | 제외 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | `Bod.tsx:80,94`(`setToast`, 저장 성공/무변경 시) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | `packages/foundation/src/utils/columnMapping.ts`(`buildLeafColumnDataMap`, `dataMap` 배선) | 공통 Excel 다운로드 유틸이 컬럼 `dataMap`(콤보 CODE→NAME)을 표준으로 승계하는 구조이나, BOD 화면 자체의 Excel 다운로드 버튼(`SubTitle excelFileName='BOD'`, `Bod.tsx:241`)이 실제로 Name 출력을 내는지 직접 실행 검증은 못했다(공통 유틸 신뢰, 화면별 실측 아님) | 제외 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | — | BOD 화면의 8개 조회조건은 전부 체크리스트/콤보 다중선택 UI이고 자유텍스트 Key-in 필드가 없다(Route 팝업의 From/To Country/City만 자유텍스트이나 그건 팝업 자체 조건, 화면 공통 UC-06 대상 아님) -- 이 화면에 콤마 Key-in 대상 필드 없음 | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | `packages/shared/src/components/organisms/data-grid`(`gridFilterRef`, `Bod.tsx:22,239` 배선) | `FlexGridFilter` ref가 `DataGrid`/`SubTitle`에 표준 배선돼 있으나, 재조회 후 필터 상태가 실제로 유지되는지(rebindFilterColumns 적용 여부)는 공통 컴포넌트 내부 동작이라 화면 코드만으로 확정 불가 | 제외 |
