# SCP0108 CAPA LOB Report — AS-IS ↔ TO-BE 매핑

AS-IS 정본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/SCP0108_CAPA_LOB_Report/SCP0108_CAPA_LOB_Report.cs`(`cs:`)
+ `.Designer.cs`(`dsn:`). 헬퍼: `GSCM.SCP.Common.UIL/Class/ScpCapaBL.cs`(`BL:`)·`ScpCapa.cs`(`CAPA:`) /
`GSCM.Utils/BLUtils.cs`(`BU:`) / `01.Framework/.../BaseForm.cs`(`BaseForm:`)·`SpreadInfo.cs`(`SPINFO:`).

설계 정본: `.atlas/gscm-design/SCP0108/design/00_checklist.md` · `01_layout.md`(L-01~L-38 / V-01~V-26) ·
`02_search-combo.md`(V-01~V-30) · `03_grid-columns.md`(R-01~R-22 / V-01~V-43 / C-01~C-14).
전환 계획: `convert-flow/goal.md` · `convert-flow/plan.md`. 갭·검증 결과: `design/04_react-gap.md`.

> **이 화면의 성격을 한 줄로**: 전건 **조회전용 Report** 다. 편집·저장 경로가 코드·메타·SP 어디에도 없다
> (`INPUT_TP_CD='S'` 44/44 · `LockColumn(0, max, true)` · `IsEditMode` 영구 false · 저장 SP 0건).

---

## 1. Roslyn 백본 12필드 카운트 대사

`00_checklist.md` 가 분류한 백본 전건이 TO-BE 어디로 갔는지(또는 왜 가지 않았는지).

| 필드 | n | TO-BE 귀속 | 비고 |
|---|--:|---|---|
| controls | 43 | 영역1 46노드(`01 §1.1`) → `CapaLobReport.tsx` + `components/CapaLobReportForm.tsx` + `CapaLobReportGrid.tsx` | 사장 노드 3건은 이식 제외(§5) |
| events | 12 | 영역2 10 + 영역3 2 | `btnColumn.Click` → `SubTitle` customButton / `spdMain.TopChange` → wijmo sticky merge(핸들러 없음) |
| validations | 1 | `handleSearch` 의 `currVersionProgressStatus === '-'` 가드 | `MSG01410`(AS-IS `MSG00423` 은 TO-BE 0건) |
| gridSignals | 6 | G1 3단헤더+동적컬럼 / G2 Delete / G3 포맷·색 / G4 커서2 / G5 잠금 / G6 병합 | 전건 소진 — §4 표 |
| gridColumns | 0 | — | 리터럴 `Add*Column` 0건. **전량 DB 구동**(`staticColumns` + 헤더 SP) |
| spCalls | 3 | `spreadTitle` / `CURRENT` / `CUTOFF` 3 시트 | `procedures.d.ts` `SCP0108` 블록 |
| entryPoints | 15 | 조회조건 10 + 툴바 override 3 + 팝업 2 | override 3 = Find/Insert/Delete(§3) |
| comboCalls | 6 | 5 이식 + 1 데드 | `YearFromThisYear_SCP_ALL`(`dtFromYYYY`) = 참조 0건 데드(§5) |
| filterCalls | 4 (+ G-2 미포착 20, 재실측 편입 14) | `utils/capaLobReport.combos.ts` **38연산 전건** | `GetSortedCode` 4건 · `ChangeColumnNameToCodeName` 6건 포함 |
| buttonGuards | 5 (+ override 1) | Find 2 + Delete 3 | Delete 3 가드는 **도달 불가**(§3) |
| popups | 2 | `components/modals/CapaLobReportItemPopup.tsx`(P1) · `CapaLobReportColumnModal.tsx`(P2) | 둘 다 공용 컴포넌트 얇은 래퍼 |
| extractionLimits | 2 (+ G-1~G-4) | — | 프레임워크 헬퍼 4종 정의 부재(03 C-01) → 관측 결과로 재현 |

---

## 2. 파일 ↔ AS-IS 대응

| TO-BE 파일 | AS-IS 대응 | 핵심 |
|---|---|---|
| `CapaLobReport.tsx` | `Form_Load`(cs:965~976) · `FindButton`(cs:1267~1282) · `InsertButton`(cs:1284~1286) · `DeleteButton`(cs:1288~1305) · `InitForm`(cs:969) · `AfterFindData`(cs:1398~1420) | 조립 + 툴바 계약 + 커서 2개 소비 |
| `capa-lob-report.constants.ts` | `SpdSheet`·`DateColumns`·`ProgressStatusType`(CAPA:42~48)·`_fixed_column_name`(cs:365~375) | 시트/상수/LBL·MSG 매핑 |
| `capa-lob-report.types.ts` | GET SP 반환 형상(03 §4.2/§4.4) | 행 타입 + 조회 payload 계약 |
| `useCapaLobReportStore.ts` | `_searchParams` 계열 getter + `InitSpread`(cs:1195~1206) | searchParams/filters 분리 · 폭0→비표시 · 개인화 |
| `hooks/useCapaLobReportCombos.ts` | `InitDatasAll`(cs:868~878) · `RefreshXxx`(cs:989~1122) · `SetQueryInfoGet`(cs:1456~1470) | 콤보 5종 1 round-trip + cascade + payload |
| `hooks/useCapaLobReportConditionEffects.ts` | `BeforeFindData`(cs:1312~1319) · `GetSpdTitle`(cs:1175~1193) | 그리드 비움 + 기간헤더 갱신(단일 커밋) |
| `utils/capaLobReport.combos.ts` | `ScpCapaBL.GetFilterXxx`(BL:144~403) · `GetSortedCode`(BL:81~136) · `DeleteEmptyName` | 후처리 38연산 |
| `utils/capaLobReport.dateColumns.ts` | `_from_yyyymm`(cs:291~312) · `RefreshSpreadDateColumn`(cs:1215~1229) | 3단 헤더 + `M_01`/`Y_` |
| `utils/capaLobReport.cursors.ts` | `_si.Query(ds)` + `_tblBottleneckFlag = ds.Tables[1].Copy()`(cs:1402~1404) | 커서 fallback chain + **키 조인** |
| `components/CapaLobReportForm.tsx` | `usrConditionPanel1`(dsn:133~141) + LayoutControlItem 16종 | 조회조건 14필드 3단 |
| `components/CapaLobReportGrid.tsx` | `spdMain` + `RefreshDateColumnStatus`(cs:1351~1396) + `SetSheetMerge`(cs:1422~1431) | 음수 적색 · Bottleneck 배경 · sticky merge |
| `components/modals/CapaLobReportItemPopup.tsx` | `ShowItem`(cs:1580~1602) → `SCM0002_CAPAItemPopup` | `multiSelect` + `operationGroup` + `,` join |
| `components/modals/CapaLobReportColumnModal.tsx` | `btnColumn_Click`(cs:1614~1623) → `SCM002_CAPAColumnPopup` | `sheetName` 전달 필수 |

---

## 3. 권한 게이트 3형 + Insert/Delete 도달 불가 근거 (`01 §7 #2` / L-28 / L-32)

| 형 | AS-IS 지점 | 판정 기준 | 관측 동작 | TO-BE |
|---|---|---|---|---|
| (1) **Division 권한 0건** | `cs:1133~1134` → `BaseForm:5269~5277` | `dtDivision.Rows.Count == 0`. 원천 콤보 `Division_SCP` WHERE 가 `@sesUserId` 기준이라 **USER_ID 보유 권한 합집합**이다(hook #128) | 조회영역 전체 `Enabled=false` + 메시지 1회 | `noDivisionAuth = isDivisionSettled && divisionOptions.length === 0` → `<Form disabled>` + **`MSG00667`** 1회. AS-IS 번호 `MSG00097` 은 TO-BE 에서 "Please select Division." 이라 오매핑이다 |
| (2) **버튼 ACL** | `BaseForm:3023~3032`(Select) · `3171~3231`(C/U/D) | `ViewModel.SecurityContext.Can*`. AS-IS `TB_FX_GroupMenuAuth WHERE MenuID='SCP0108'` 실측 **8행** | 권한 없으면 `MSG00096` | `useTabBtnPermissions().hasButton()` 조건부 `hotkeyConfig`(하드코딩 금지) |
| (3) **시트 잠금** | `BaseForm:3302~3340`(`CheckValidation`) | `si.IsLock(si.SheetName)` | Insert `MSG00008` / Delete `MSG00009` / Save `MSG00010` 후 **override 미호출** | `handleInsert` = `MSG01044` alert / `handleDelete` = `MSG01045` alert / `save: false` |

### L-28 ACL 8그룹 실측표 (`asis.py TB_FX_GroupMenuAuth WHERE MenuID='SCP0108'`)

| GroupID | BasicACLR | BasicACLC/U/D | TO-BE 버튼 권한(`05_register.sql` 6번 블록) |
|---|:--:|:--:|---|
| ADMIN | True | True | SEARCH·EXCEL·INSERT·DELETE |
| CAPA Planner | True | True | 동상 — **단 TO-BE `SCM_ADM_USER_GR_M` 에 그룹이 없다**(EXISTS 가드로 skip, 04 확인필요) |
| SCM PI Admin | True | True | SEARCH·EXCEL·INSERT·DELETE |
| SCP Tester | True | True | 동상 |
| FP Planner | True | False | SEARCH·EXCEL |
| FP Viewer | True | False | SEARCH·EXCEL |
| SCM Viewer | True | False | SEARCH·EXCEL |
| SCP Planner | True | False | SEARCH·EXCEL |

C/U/D 는 4그룹뿐이나 **이 화면엔 C/U/D 도달 경로가 없어 실질 무의미**하다.

### Insert / Delete 가 "도달 불가" 인 근거 (전수 grep 실측)

1. `IsLock` 은 시트별 Hashtable `ht` 를 읽고(`SPINFO:7994~8008`), `ht` 항목은 **`AddSheet` 가
   `true`(잠금)로 등록**하며(`SPINFO:307`,`442`), `Query(ds)` 가 매 조회마다 `SetLockFlag(sheet,true)`
   를 다시 한다(`SPINFO:6310`).
2. 잠금을 해제하는 유일한 경로는 `SwitchLock(false)`(`SPINFO:7828~`)인데 **SCP0108 에서 호출 0건**.
   → **`IsLock` 영구 true**.
3. 그래서 `CheckValidation(Insert|Delete|Save)` 가 먼저 `MSG00008/00009/00010` 을 띄우고 화면 override
   에 도달하지 않는다. `InsertButton` 본문은 애초에 완전 공백(`{ }`, cs:1284~1286)이고 `DeleteButton`
   본문의 `_si.Delete()` 는 선택행 0열이 `CAppSetting.FlagI`(신규행)일 때만 실행되는데 **신규행을 만들
   경로가 없다**(Insert NO-OP).
4. 따라서 TO-BE 는 **행 추가·제거 로직을 만들지 않고 alert 만 재현**한다. `hotkeyConfig` 에서
   `insert`/`delete` 키를 **생략하면 공용 SubTitle 기본 `addRow`/`removeRow` 가 살아나 AS-IS 에 없던
   동작이 생기고**, `false` 로 주면 버튼이 사라져 시각적으로 달라진다 — **둘 다 오답**이다.

---

## 4. gridSignals 6건 ↔ TO-BE 기제 (그리드 동작 파리티 게이트, skill 2.5)

`grep` 으로 추출한 스프레드 동작 호출 전건을 TO-BE 대응 기제에 1:1 매핑했다(미매핑 0건).

| # | AS-IS 호출 | 라인 | 동작 | TO-BE 기제 |
|---|---|---|---|---|
| G1 | `SetSheetHeaderColumnSCP(_si, 3, refreshAllColumn, "ELTR_LN_TP_CD")` + `RefreshSpreadDateColumn(...)` | cs:1213 / 1215~1229 | 3단 헤더 + 동적 기간컬럼(폭 80) | `staticColumns`(메타 `L/S CLASS_LABEL_NAME`) + `buildPeriodColumns()` + `headerRowHeight={16}`(총 48px) |
| G2 | `_si.Delete()` (신규행 한정) | cs:1299~1305 | 행 삭제 | **미구현**(도달 불가 — §3). `handleDelete` = alert |
| G3 | `SetRowFormat(r,c,1,"###,##0.0","",false,columnColor)` + `LightPink` 판정 | cs:1351~1396 | 기간셀 포맷 · 음수 적색 · Bottleneck 배경 | 컬럼 `format:'n1'` + `formatItem` 에서 `styles.negativeValue` / `styles.bottleneckCell` 토글 |
| G4 | `_si.Query(ds)` + `ds.Tables[1].Copy()` | cs:1402~1404 | 커서 2개 소비 | `pickDataRows` / `pickBottleneckRows` fallback chain + `buildBottleneckIndex` **키 조인** |
| G5 | `_si.LockColumn(0, GetMaxColumnIndex(), true)` | cs:1406 | 전 컬럼 잠금 | 메타 `INPUT_TP_CD='S'` 44/44 를 공용 DataGrid 가 소비. **컬럼명 배열 이식 0건**(hook #130) |
| G6 | `SetSheetMerge()` → `RightColMerge2()` (3경로: cs:1231·1408·1256) | cs:1422~1431 | 좌측 고정영역 병합 + 스크롤 재적용 | `allowMerging={AllowMerging.All}` → 공용 DataGrid 가 wijmo `CustomMergeManager`(sticky) 설치. **스크롤 핸들러 0건** |

셀 병합/Lock/셀 타입 콤보 판별 결과: **셀 콤보 0건**(`CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox'` 0행 ·
`CELL_COMBO_DATA_TYPE` 44행 전건 공란 · `FPModal`/`FPButton`/`FPCheckBox`/`FPDate`/`FPNumber` 전건 0행 ·
`CellChanged`/`RowChanged` 핸들러 0건). 미이관 의심 0건 — 편집 경로 자체가 없는 화면이다(03 §1.4).

---

## 5. 이식 금지 항목 — 항목별 사유

| 항목 | AS-IS 근거 | 이식하지 않은 이유 |
|---|---|---|
| `usrLayoutControl1` / `layoutControlGroup1` | dsn:109~125. `Controls.Add` grep **0건** | **화면에 붙지 않는 사장 노드**다(01 L-01/L-02). 이식하면 빈 래퍼가 하나 더 생겨 hook #132 §1-2 위반 |
| `imageList1` | dsn:127~131. 어떤 컨트롤의 `ImageList` 에도 배정 0건 | 데드 리소스(01 L-38). 아이콘은 공용 `IcGridColumnSetup` 사용 |
| `dtFromYYYY`(`YearFromThisYear_SCP_ALL`) | cs:68. 선언 외 참조 0건, 바인딩 컨트롤 `cboFromYYYY` 가 Designer 에 부재 | 데드 콤보(02 §2.7 C5). 이식하면 서버 왕복 1회가 늘고 쓰이지 않는다 |
| `dtYesOrNo` 필드 | cs:69. 실바인딩은 `cboBottleneck.DataBind(...)` 가 따로 한다 | 중복 로드 잔재(02 §2.7 C6-b) |
| 데드 핸들러 `cboSheetType_SelectedIndexChanged` / `cboFromYYYY_SelectedIndexChanged` | cs:1528 / cs:1564. `InitEvent` 11건 배선에 없음 + 컨트롤 부재 | 발화 경로 없음(02 §0 #7) |
| `_ASSIGN_PRIORITY` 제외 필터 | cs:1189~1192 | TVF 가 SCP0108 에는 그 컬럼을 **생성하지 않는다**(실측 0건, 03 §2.3) → 항상 무동작 **사문 코드**. 자매 SCP0105/0106 에서 복사하면 죽은 코드가 생긴다(R-07 / V-18) |
| `LockColumn` 컬럼명 상수 배열 | cs:1406 | 파리티가 메타 `INPUT_TP_CD='S'` 로 이미 표현돼 있다(hook #130) |
| `isEditMode` state | 01 L-33. `IsEditMode` true 세팅 경로 0건 | 편집모드가 존재하지 않는다(03 V-31) |
| `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현 | cs:1131. 소비처는 `SetFilterALLCancel` **한 곳뿐**(`BaseForm:403`,`3141`,`3143`) | 실제 의미는 "**CURRENT 시트에서는 조회/편집 시 컬럼 필터를 자동 해제하지 않는다**"(01 L-30 정정본). 공용 DataGrid 는 조회 시 `gridFilterRef` 필터를 자동 해제하지 않으므로 **기본 충족**(별도 구현 불요, 01 V-18) |
| `frozenColumns={1}` 하드코딩 | `AddSheet(..., 3, 1, 35)` 의 `1` | 고정열이 아니라 `RowHeader.ColumnCount`(좌측 No. 1열)였다(03 §0.4 오독 정정 / C-13). 고정 경계는 메타 `FIXED_FLAG='Y'`(=`ELTR_LN_TP_CD`)가 원천이고 공용 DataGrid 가 계산한다 |
| `spdMain_TopChange` 스크롤 핸들러 | cs:1252~1259 | wijmo sticky merge 가 같은 효과를 내므로 스크롤마다 재계산하는 코드를 만들지 않는다(hook #69 / 03 V-33) |
| `statusIdx = UIUtils.GetIndexByCode(...)` | cs:1042~1046 | 어디에도 쓰이지 않는 사문 코드(02 §2.3). Status 목록은 3중 필터로 항상 1건이라 `SelectedIndex = Count-1` 이 곧 인덱스 0이다 |
| `_dateStartColIdx` / `_dateEndColIdx` | cs:329~363. 참조 0건 | 사문 프로퍼티(03 §2.5) |
| AS-IS 헤더 높이 75px(1단 35 + 2·3단 20) | `AddSheet` 5번째 인자 35 | TO-BE 표준 48px 을 따른다(hook #93 / 03 §2.5) |
| AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패) | cs:291~312 | 실패 시 `"-"` 가 SP 로 가서 TVF 변환오류가 난다 → `/^\d{6}$/` 가드로 **헤더 조회 자체를 skip**(03 V-16) |
| Bottleneck **행 인덱스** 대응 | cs:1373 (`_tblBottleneckFlag.Rows[r]`) | CURRENT SP 는 두 커서 모두 `ORDER BY` 가 없어 순서 동일이 보장되지 않는다(03 C-09) → **키 조인**으로 구현(V-23) |
| Formation(`AFFFF`) **전역** 제외 | 자매 SCP0105 구현 | SCP0108 은 `GetFilterOperation` 안에서 **ELTR 축에서만** 제외한다(BL:355~361 / 02 §0 #4). 전역 제외는 Cell/Module·Pack 후보를 AS-IS 보다 좁힌다 |
| `CapaLineMasterEE_SCP_ALL` 콤보 스왑 | 자매 SCP0105/0106 구현 | SCP0108 은 호출 0건이다(grep). 화면설계서 R64 "전극은 단일 공정이므로 리포트 대상에서 제외" 가 설계 의도이며 EE 보정 콤보 추가는 금지(goal.md BLK-7 RESOLVED) |
| `fetchStaticMeasures` / `staticMeasures` | 자매 전 화면 구현 | `SCM_MST_SHEET_MEASURE` TO-BE 0행 · AS-IS 0행 = **설계상 Measure 축이 없는 화면**(03 §1.5 / V-04). 정의조차 하지 않는다 |
| `useProcMutation`/`useSaveWithValidation`/`EditTracker`/`CRUD_TYPE` | 자매 전 화면 구현 | 저장 SP 가 없다(03 §4.3 / V-29) |
| 시트 탭 UI(`TabWrapper`/`TabPanel`) | `TabStripPolicy.Never`(cs:1197) | 시트 2개가 있어도 사용자에게 탭이 보이지 않는다(01 L-35 / 03 V-41) |
| Edit 버튼(`customButtons`) | `EditButton` override 0건 → 베이스 빈 구현 | 클릭해도 **메시지조차 없다**(01 L-31 §2-E). 편집모드 state 도 없다(V-14) |
| 필수 조회조건 UI(`*`) · Search 전 alert | `DataUtil.InitCheck`(DataUtil:370~622) 전문 read | SCP0108 라벨 12종에 `*` 로 끝나는 것이 **0건**이라 그 축은 미발생이다(01 L-23 / 02 V-24). 신설하면 오히려 위반 |

### AS-IS 대비 의도적 차이 (근거 기재 의무)

| # | 차이 | 사유 |
|--:|---|---|
| 1 | AS-IS 는 Division 권한 0건 안내를 **Load 1회 + Search 클릭마다** 반복한다(`Enabled` 체크가 `SavePanelCondition` 에만 있음) | TO-BE 는 Load 1회 안내 + 조회영역 비활성으로 통일한다(01 V-07 — 설계가 "의도적 차이" 로 명시) |
| 2 | AS-IS 는 필드 초기화만으로 서버 왕복 6~7회 | TO-BE 는 `useTabComboQueries` **1 round-trip 5콤보**. 기능 누락이 아니라 불필요 호출 제거(02 §2.7) |
| 3 | AS-IS 는 Insert/Delete 버튼을 권한 없는 그룹에도 노출하고 클릭 시 `MSG00096` | TO-BE 는 `hasButton()` 이 false 면 버튼이 노출되지 않는다(프레임워크 차이). 어느 쪽이든 행 추가·삭제는 불가 |
| 4 | AS-IS `rgrpDivisionType` 은 RadioGroup(Columns=3) | NSCM 공용에 RadioGroup 컴포넌트가 없어(`@shared/components`·`@shared/lges` 전수 확인) 단일선택 드롭다운으로 매핑했다 — 자매 SCP0104/0105/0106/0114 와 동일 판단 |
| 5 | AS-IS `MSG01410` 인자가 `"'Current"`(닫는 따옴표 누락 오타) | 오타를 이식하지 않고 `'Current'` 로 복원했다(01 L-22 / 00_checklist §2-b 주의 1) |
| 6 | AS-IS 는 콤보 조회 실패와 Division 권한 0건을 구분하지 않는다(동기 로드라 실패=예외 화면) | TO-BE 는 3상태로 나눠 실패 시 `MSG01390` 안내만 하고 **조회영역을 잠그지 않는다**(재시도 가능). 권한 0건만 `MSG00667` + 비활성(iter-2 G-03) |
| 7 | AS-IS 는 컬럼 메타 조회 실패를 별도로 알리지 않는다 | TO-BE 는 `columnMetaFailed` -> `MSG01052` 1회 안내. 컬럼 0건 렌더의 원인 표시가 없으면 사용자가 데이터 문제로 오인한다(iter-2 G-11) |

### iter-2 에서 **제거한** 초과 구현 (AS-IS 에 없던 동작)

| # | 제거 대상 | AS-IS 근거 |
|--:|---|---|
| 1 | Basic Nickname 입력창 `onDoubleClick` -> Item 팝업 | `txtItem` 은 순수 TextBox 이고 더블클릭 이벤트 배선이 0건이다(cs:1604~1612 / dsn:524~529). 팝업 트리거는 `btnItemId.Click` 단독 |
| 2 | Site/Plant/Building/Line 변경 시 `electrodeType`(Line Type) 선택 초기화 | `clbSite~clbLine` 핸들러(cs:1533~1557)가 `RefreshElectrodeType` 를 호출하지 않아 재바인딩이 없고 체크가 유지된다. 초기화하면 `p_electrode_type` 이 무필터로 넓어져 조회 결과가 달라진다 |

### iter-3 에서 **제거한** 초과 구현 (AS-IS 에 없던 동작)

| # | 제거 대상 | AS-IS 근거 |
|--:|---|---|
| 1 | Site/Plant/Building/Line 변경 시 Line Type **후보 목록** 재계산 | 위 #2 와 같은 근거의 **목록 축**이다. iter-2 는 선택값 초기화만 걷어냈고 후보 목록은 `searchParams.operationId` 를 직접 읽어 그 4개 핸들러의 Operation 리셋에 딸려 다시 계산됐다(iter-2 G-16). AS-IS 는 `RefreshElectrodeType`(=`RefreshAll` 및 `clbOperation` 핸들러)에서만 목록을 다시 만든다 — TO-BE 는 `lineTypeOperationId` 스냅샷을 두고 Division / DivisionType / Operation 변경 3곳에서만 갱신한다(`useCapaLobReportStore.ts` `syncLineTypeSource`) |

### iter-2 에서 신규 등록한 i18n 코드

`LBL01143 = 'Module/Pack'`(KO/EN/CN 3행) — 기존 `SCM_ADM_MSG_M` 에 정확 매칭이 0건이라(`LBL00378 Sub
Module`/`LBL00379 Module` 뿐) `design/05_register.sql` 1b 블록이 **실측 채번**(`MAX=LBL01142` 확인 후
`LBL01143` 공석 확인)으로 등록했고 화면은 `t(LBL_MODULE_PACK, {defaultValue:'Module/Pack'})` 로 참조한다.
자매 SCP0105/SCP0106 과 공유하는 번호다(goal.md BLK-5 사용자 결정). 엉뚱한 기존 LBL 재사용 0건(hook #114).

---

## 6. 메모리 `input-tp-cd-search-only-kills-save-validation` 대조 — **사고 조건 성립 불가**

그 사고는 "메타가 `INPUT_TP_CD='S'`(SEARCH_ONLY) 전건인데 화면이 커스텀 `editLock` 으로 편집을 열어
`useSaveWithValidation` 의 필수검사가 무발동되는" 조건이다.

SCP0108 은 **저장 경로 자체가 존재하지 않는다**:
- `entryPoints` 에 `SaveButton` override 0건이고 베이스는 빈 구현이다(`BaseForm:3352~3371`).
- `QueryDics` 는 `DIC_GET_CAPA_LOB` 하나뿐이다(cs:129, `InitQueryDics` cs:973).
- `IsLock` 이 영구 true 라 `CheckValidation(Save)` 가 `MSG00010` 으로 먼저 막는다(§3).
- TO-BE 도 `useProcMutation`/`useSaveWithValidation`/`EditTracker` 를 **정의하지 않았고**
  `beginningEdit` 커스텀 허용 로직도 0건이다.

→ 필수검사가 무발동될 저장 경로가 없으므로 **그 사고 조건은 이 화면에서 성립하지 않는다**.
`INPUT_TP_CD='S'` 44/44 는 AS-IS `LockColumn` 전 컬럼 잠금과 **방향이 일치**하는 정상 메타다(hook #89 §E 통과).
