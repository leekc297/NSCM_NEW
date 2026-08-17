# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `DMF0003_MktFcst_주요이벤트_상세분석.md`, `DMF0003_MktFcst_제약매트릭스_상세.md`, `DMF0003_MktFcst_상세분석서_v2.0.md`, `DMF0003_MktFcst_상세동작_개발용.md`, `DMF0003_spdMain_이벤트3종_상세분석.md`, `DMF0003_조회조건_GRID_Cascade_Flow_ASIS_v1.0.md`, `DMF0003_단위테스트결함_대조_20260812.md`, `DMF0003_테스트시나리오_체크리스트_20260812.md`, `DMF0003_정본전환_diff_20260812.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| E00 | §0 정본 vs 구본 차이 — git diff --no-index 실측 |  | 정본 선택 근거(폴더본 7,143줄 — diff = DMF0003_정본전환_diff_20260812.md). 구현 산출물 아닌 분석 메타 | 제외 |
| E01 | §1 초기화 체인 (Form_Load, L302~330) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:99~120 (초기화 useEffect·dayRange) + useMktFcstStore.ts:325~455 (fetchStaticColumns/Measures/SearchConditions) |  | 구현 |
| E01-1 | §1.1 InitControls (L422~563) — 조회조건 콤보 로딩·기본값 | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx:51~106 (조회조건 콤보 8축) + useMktFcstStore.ts:131~163 (initSearch 기본값·82 Invalid 기본체크) |  | 구현 |
| E01-2 | §1.2 CreateSpread (L609~619) / InitSpread (L622~636) / GetSpdTitle (L6336~6355) | features/demand/src/pages/mkt-fcst/useMktFcstStore.ts:88·241 (spreadTitleType 'LOAD'/'' — E20260402) + components/MktFcstGrid.tsx:349~410 (GET_SPREAD_TITLE→동적 컬럼 메타) |  | 구현 |
| E01-3 | §1.3 DefineProperty (L565~607) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:701~737 (버튼 게이트 hasButton×editable). Master Change = AS-IS 최종 숨김(E20260323)+사용자 결정(2026-07-13 MasterChgModal 제거 — modals/index.ts) |  | 구현 |
| E01-4 | §1.4 InitSaveDataTable (L758~800) |  | WinForms 로컬 DataTable(dtSave/dtSaveFinal) 구조 — TO-BE 는 EditTracker+utils/mkt-fcst.save.ts:127~185 (buildUnfoldRows/buildSavePayload)가 동일 역할 | 해당없음 |
| E02 | §2 FindData — 조회 (FindButton L805 → FindData L1673~1947) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:412~424 (handleSearch) + useMktFcstStore.ts:260~300 (SP 19파라미터 payload — p_as_yn=W/S 그룹 E20260211 포함) |  | 구현 |
| E03 | §3 편집/저장 | features/demand/src/pages/mkt-fcst/MktFcst.tsx:429~ (guardEditGates) + 하위 E03-1~5 |  | 구현 |
| E03-1 | §3.1 EditButton (L824~1338) — 편집 게이트 8종 + 잠금 매트릭스 | features/demand/src/pages/mkt-fcst/MktFcst.tsx:429~468 (게이트) + components/MktFcstGrid.tsx:722~850 (beginningEdit) + utils/mkt-fcst.editLock.ts:75~ (buildEditCutoff/evalDynCell — EDIT_FLAG·버킷·시점) | 잔여 갭은 CA-04(MSG00478 주석)·CA-07 행 참조 | 구현 |
| E03-2 | §3.2 SaveButton (L1340) → SaveData (L2220~2506) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:519~660 (handleSave — MSG00476 게이트·p_authority) + utils/mkt-fcst.save.ts:127~185 |  | 구현 |
| E03-3 | §3.3 InsertButton (L811) → InsertRow (L2529~3014) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:472~499 (handleInsert — SCP 81 차단·INSERT_DEFAULT_MEASURE) |  | 구현 |
| E03-4 | §3.4 DeleteButton (L816~822) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:503~514 (handleDelete — I 행만) |  | 구현 |
| E03-5 | §3.5 ExcelButton (L1346~1391, E20240906) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:775 (excelFileName — DataGrid 공통 DefaultButtonActions excel) |  | 구현 |
| E04 | §4 그리드 이벤트 | 하위 E04-1~5 분해 |  | 구현 |
| E04-1 | §4.1 spdMain_Changed (L3944~5382) — CellsUpdated 만 | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:855~955 (cellEditEnded→runDynRecalc) + utils/mkt-fcst.recalc.ts (D/W/M 배분·롤업) + utils/mkt-fcst.validate.ts |  | 구현 |
| E04-2 | §4.2 SetSaveData (L5395~5522) / SetSaveDataRemove (L5524~5619) | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.save.ts:127~158 (buildUnfoldRows — EditTracker 변경 셀 수집 = SetSaveData/Remove 동등) |  | 구현 |
| E04-3 | §4.3 spdMain_ComboSelChange (L3291~3603) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:723~850 (cascade dataMap 스왑) + mkt-fcst.constants.ts:331~357 (GRID_CASCADE_FILTERS/CLEAR) | AS 3축 잔여 갭은 CE-02/CE-04 행에서 판정 | 구현 |
| E04-4 | §4.4 spdMain_CellDoubleClick (L3604~3942) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:977~1050 (헤더 드릴다운·FPModal 팝업·SSP 비교) + MktFcst.tsx:796~860 (Project/Item 모달 회신) |  | 구현 |
| E04-5 | §4.5 spdMain_KeyUp (L5636~5700) / EditChange (L6482~6488) / ClipboardPasted (L6491~6593) … | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:150 (pasteContinueRef) + Wijmo pastedCell 공통. TopChange=Wijmo 자동 머지 | AS-IS KeyUp 의 Item 붙여넣기→검증팝업(E20231019)은 FPModal 검색 모달 구조로 대체(직접입력 차단) | 구현 |
| E05 | §5 버튼 전수 | 하위 E05-1~3 |  | 구현 |
| E05-1 | §5.1 BaseForm override | features/demand/src/pages/mkt-fcst/MktFcst.tsx:701~712 (공통버튼 배선) |  | 구현 |
| E05-2 | §5.2 커스텀 버튼·체크박스 | features/demand/src/pages/mkt-fcst/MktFcst.tsx:714~737 (Column/Measure 커스텀 버튼) + components/MktFcstForm.tsx:255~275 (Bucket 가드 MSG00227) | btnIncotermsChg(Master Chg)=숨김 사문 / cboAS=사문 — 각 HANDLER 행 참조 | 구현 |
| E05-3 | §5.3 화면 내 검증 메시지 전수 (활성 기준) | features/demand/src/pages/mkt-fcst/mkt-fcst.constants.ts:262~310 (MSG 상수) + utils/mkt-fcst.validate.ts | MSG00478 미배선(주석) = CA-04 갭 / MSG00004→MSG00606 토스트 대체(C4 표준) = CF-05 참조 | 구현 |
| E06 | §6 호출 팝업 상세 (8종) | MODAL:* 8행에서 개별 판정 |  | 구현 |
| E07 | §7 fnValidation (L5887~6273) | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.validate.ts:50~152 (validateSaveRows — 필수/중복/수량/AS+ALL) |  | 구현 |
| E08 | §8 SSP 동기화 표시 (C20200804 — 40/82) | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.sspSync.ts (parseSspSyncMap/sspSyncStateOf) + components/MktFcstGrid.tsx:644~ (PaleGreen/PapayaWhip) |  | 구현 |
| E09 | §9 당주 표시 (초록 라인·헤더) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:152~169 (currentPeriodBindings)·600~632 (헤더 초록 볼드+셀 테두리) |  | 구현 |
| C-01 | §0.2 Division / §1-1 | mkt-fcst.constants.ts:60 (토큰 `DIVISION` 실재) | | 구현 |
| C-02 | §0.2 Team / §1-2 | mkt-fcst.types.ts:4 (토큰 `TEAM` 실재) | | 구현 |
| C-03 | §0.2 End Customer / §1-3 | mkt-fcst.constants.ts:110 (토큰 `END_CUSTOMER` 실재) | | 구현 |
| C-04 | §0.2 Sales Site / §1-4 | components/MktFcstGrid.tsx:67 (토큰 `SALES_SITE` 실재) | | 구현 |
| C-05 | §0.2 Biz.Type / §1-5 | components/MktFcstForm.tsx:223~229 (`BizTypeField` comboId=`BizTypebyDivision`, `sc.bizTypes` 다중선택) |  | 구현 |
| C-06 | §0.2 Sender Code / §1-6 | mkt-fcst.types.ts:5 (토큰 `Sender Code` 실재) | | 구현 |
| C-07 | §0.2 Period / §1-7 | mkt-fcst.constants.ts:286 (토큰 `PERIOD` 실재) | | 구현 |
| C-08 | §0.2 Bucket / §1-8 | mkt-fcst.constants.ts:53 (토큰 `BUCKET` 실재) | | 구현 |
| C-09 | §0.2 Project / §1-9 | mkt-fcst.constants.ts:130 (토큰 `PROJECT` 실재) | | 구현 |
| C-10 | §0.2 Model/Nickname / §1-10 | mkt-fcst.constants.ts:140 (토큰 `MODEL` 실재) | | 구현 |
| C-101 | §0.1 [원문 무번호] 계통 / 방식 | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| C-102 | §0.1 [원문 무번호] **BigFilter** (`BigFilter.xml` list_line_dm 1회 배치 → 캐시 9섹션) / 화면 로드 1회 → `G… | AS-IS 전용 개념 | AS-IS(WinForms/BigFilter/TB_FX_) 전용 — TO-BE 는 CMBO·메타 체계로 대체. 이식 대상 아님 | 해당없음 |
| C-103 | §0.1 [원문 무번호] **UP_FX_GetCommonDataList** (기본판, L9918) / 이벤트마다 SP 호출 | AS-IS 전용 개념 | AS-IS(WinForms/BigFilter/TB_FX_) 전용 — TO-BE 는 CMBO·메타 체계로 대체. 이식 대상 아님 | 해당없음 |
| C-104 | §0.1 [원문 무번호] **UP_FX_GetCommonDataList_DM** (_DM판, L16661) / 이벤트마다 SP 호출 | AS-IS 전용 개념 | AS-IS(WinForms/BigFilter/TB_FX_) 전용 — TO-BE 는 CMBO·메타 체계로 대체. 이식 대상 아님 | 해당없음 |
| C-105 | §0.2 [원문 무번호] NowGroupID (로그인 선택 그룹) / ADMIN / DM ADMIN / DM Planner / **DM Planner (W/S)… | mkt-fcst.constants.ts:46 (토큰 `ADMIN` 실재) | | 구현 |
| C-106 | §0.2 [원문 무번호] TB_FX_UserGroupAuthExtention / AuthType **'D'**(13,616행) / **'J'**(JV Plann… | AS-IS 전용 개념 | AS-IS(WinForms/BigFilter/TB_FX_) 전용 — TO-BE 는 CMBO·메타 체계로 대체. 이식 대상 아님 | 해당없음 |
| C-107 | §0.2 [원문 무번호] 부서제약 / `TB_FX_User.DEPT_ID` + `PM_TEAM_MAPPING`(370행, SEGMENT1=자기부서→SEGMENT… | utils/mkt-fcst.gridCombos.ts:120 (토큰 `PM_TEAM_MAPPING` 실재) | | 구현 |
| C-108 | §0.2 [원문 무번호] 이벤트 / 81/82 | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| C-109 | §0.2 [원문 무번호] 초기 로드 (L555~562) / UP_FX_DM `SiteByEndCustomer`(P1=div,P2=cust) | mkt-fcst.constants.ts:127 (토큰 `SiteByEndCustomer` 실재) | | 구현 |
| C-11 | §0.2 Plant Site / §1-11 | components/MktFcstGrid.tsx:1487 (토큰 `PLANT_SITE` 실재) | | 구현 |
| C-110 | §0.2 [원문 무번호] Division 변경 (L3071/L3110) / UP_FX_DM `SiteByEndCustomer` | mkt-fcst.constants.ts:127 (토큰 `SiteByEndCustomer` 실재) | | 구현 |
| C-111 | §0.2 [원문 무번호] Team 변경 (L3185/3199) / BigFilter `UserSiteByEndCustomer`(팀 미전달=무반응) | components/MktFcstForm.tsx:46 (토큰 `UserSiteByEndCustomer` 실재) | | 구현 |
| C-112 | §0.2 [원문 무번호] Customer 변경 (L3209/3213) / UP_FX_DM `SiteByEndCustomer` | mkt-fcst.constants.ts:127 (토큰 `SiteByEndCustomer` 실재) | | 구현 |
| C-113 | §0.2 [원문 무번호] 핸들러 (.cs 라인) / 문서 | AS-IS 전용 개념 | AS-IS(WinForms/BigFilter/TB_FX_) 전용 — TO-BE 는 CMBO·메타 체계로 대체. 이식 대상 아님 | 해당없음 |
| C-114 | §0.2 [원문 무번호] cboDivision_SelectedIndexChanged L3020 / §1-1~1-13 division 분기 | MktFcst.tsx:48 (division 변경 cascade — 토큰 `applyCascadeClear`) |  | 구현 |
| C-115 | §0.2 [원문 무번호] clbTeam_SelectedIndexChanged L3167 / §1-3, §1-4 | components/MktFcstGrid.tsx:353 (team 변경 cascade — 토큰 `TEAM_ID`) |  | 구현 |
| C-116 | §0.2 [원문 무번호] clbCustomer_SelectedIndexChanged L3205 / §1-4 | mkt-fcst.constants.ts:110 (customer 변경 cascade — 토큰 `END_CUSTOMER`) |  | 구현 |
| C-117 | §0.2 [원문 무번호] cboBucketType_SelectedIndexChanged L3218 / §1-8 | mkt-fcst.types.ts:17 (bucket 변경 — 토큰 `bucketType`) |  | 구현 |
| C-118 | §0.2 [원문 무번호] spdMain_ComboSelChange L3292 (12분기: Division/Team/Customer/Customer40/ScmSi… | MktFcst.tsx:48 (셀 콤보 변경 cascade — 토큰 `applyCascadeClear`) |  | 구현 |
| C-119 | §0.2 [원문 무번호] spdMain_CellDoubleClick L3605 / §2-1(헤더 드릴다운·SSP비교 — 표시/팝업) | components/MktFcstGrid.tsx:543 (셀 더블클릭(드릴다운/SSP) — 토큰 `DoubleClick`) |  | 구현 |
| C-12 | §0.2 Item Type / §1-12 | mkt-fcst.constants.ts:196 (토큰 `ITEM_TYPE` 실재) | | 구현 |
| C-120 | §0.2 [원문 무번호] chkColor L5629 / chkSum L5782 / §1-8(표시 — cascade 없음) | components/MktFcstGrid.tsx:206 (Color 체크(AS-IS 미표시) — 토큰 `chkColor`) |  | 구현 |
| C-121 | §0.2 [원문 무번호] spdMain_EditChange L6483 / §2-1(페이스트 플래그) | MktFcst.tsx:511 (셀 편집 — 토큰 `cellEditEnded`) |  | 구현 |
| C-122 | §0.2 [원문 무번호] spdMain_ClipboardPasted L6492 / §2-1 페이스트 | components/MktFcstGrid.tsx:194 (붙여넣기 — 토큰 `paste`) |  | 구현 |
| C-123 | §0.2 [원문 무번호] spdMain_CellClick L6597 / §2-1(PlantSite 목록 — 주석화 잔재 포함) | components/modals/PrHistoryModal.tsx:88 (셀 클릭 — 토큰 `CellClick`) |  | 구현 |
| C-124 | §0.2 [원문 무번호] cboAS_CheckedChanged L7069 / §1-4(hidden — L553) | mkt-fcst.types.ts:29 (AS 체크 — 토큰 `asYn`) |  | 구현 |
| C-13 | §0.2 Owner / §1-13 | mkt-fcst.types.ts:7 (토큰 `OWNER` 실재) | | 구현 |
| CA-01 | §1 `SCP Planner` × division 82 또는 40 / MSG00096 차단 | features/demand/src/pages/mkt-fcst/MktFcst.tsx:521~525 (scpEditBlocked — FE) + PKG_DMF0003 SAVE 프롤로그 AUTHGATE(2026-08-12 이식 — AS-IS L690~708 1:1, SP 서버측 차단) | 실 CRUD 권한 테스트에서 SP 게이트 미이식 적출(SCP 82 저장 서버 통과) → 당일 이식·차단 재현(CODE -1) | 구현 |
| CA-02 | §1 `DM_UI_EDITABLE_DIVISION`('DMF0003',div) EDIT_YN='N' / MSG00448 차단 (40→DMF0082 유도) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:109~135 (editableSet/userEditSet 메타) — editable=false 시 Insert/Delete/Save 버튼 미표시(=MSG00448 차단 동등, 40 은 DMF0082 유도) |  | 구현 |
| CA-03 | §1 `SCP Planner` × 81* × `SCP_PLANNER_EDIT_FLAG` 0건 / MSG00477 차단 (시간 게이트) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:430~437 (FE MSG00477) + PKG SAVE AUTHGATE SCP 분기(서버측 — lookup 0건=전면 차단 보수 동작) |  | 구현 |
| CA-04 | §1 Planner 3그룹 × `DM_PLANNER_EDIT_FLAG` 행 존재 / MSG00478 차단 (인자 5: LIMIT_AUTH/EDIT_DAYS/FR… | features/demand/src/pages/mkt-fcst/MktFcst.tsx:441~455 (MSG00478 재활성) + PKG SAVE AUTHGATE 비SCP 분기(서버측 LIMIT_AUTH 시간창 — AS-IS L715~778 1:1) | 2026-08-12 보완: FE 주석 게이트 복원 + SP 게이트 이식 | 구현 |
| CA-05 | §1 Planner 3그룹 × 81*/82 × AS_FROM_SITE 컬럼 부재 / MSG00113 차단 | features/demand/src/pages/mkt-fcst/MktFcst.tsx:455~464 (guardEditGates (3) — AS_FROM_SITE 컬럼 부재 MSG00113) |  | 구현 |
| CA-06 | §1 필수 컬럼 부재 — 81*: 9종(+PlantSiteId) / 82: 8종 / 40: 8종(40 계열 키) / MSG00113 차단 |  | AS-IS 는 컬럼셋팅으로 필수 컬럼 제거 가능한 구조라 검사 필요 — TO-BE 는 admin SHEET_COLUMNS 메타가 키 컬럼 상시 공급(개인화는 표시만) → 부재 불가 | 해당없음 |
| CA-07 | §1 dt8Week 없음(조회 선행 안 함) / MSG00259 차단 | features/demand/src/pages/mkt-fcst/MktFcst.tsx guardEditGates (2b) — hasSearched 가드(MSG00662 '조회 후 수정모드로 가능합니다') | 2026-08-12 보완 | 구현 |
| CA-101 | §1 [원문 무번호] **DMF0003** (정본) / `GSCM.DM.Plan.UIL/DMF0003_MktFcst.cs` (5,920줄) | mkt-fcst.constants.ts:1 (토큰 `DMF0003` 실재) | | 구현 |
| CA-102 | §1 [원문 무번호] DMF0003_1 / (별도 소스) | 해당없음 | 범위 제외 — `DMF0003_1`/`DMF0003_T` 는 별도 메뉴(사용자 확정 2026-08-15). 본 대사표 대상은 DMF0003 본화면 | 해당없음 |
| CA-103 | §1 [원문 무번호] DMF0003_T / (별도 소스) | 해당없음 | 범위 제외 — `DMF0003_1`/`DMF0003_T` 는 별도 메뉴(사용자 확정 2026-08-15). 본 대사표 대상은 DMF0003 본화면 | 해당없음 |
| CA-104 | §1 [원문 무번호] 화면 ID / DMF0003 (MktFcst / 시장예측) | 해당없음 | 문서 머리말(화면 메타정보) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CA-105 | §1 [원문 무번호] 도메인 / Demand (수요) | 해당없음 | 문서 머리말(화면 메타정보) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CA-106 | §1 [원문 무번호] 메뉴 / Demand > Demand Plan > MKT FCST | 해당없음 | 문서 머리말(화면 메타정보) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CA-107 | §1 [원문 무번호] TO-BE FE / `nscm-fe/features/demand/src/pages/mkt-fcst/` | 해당없음 | 문서 머리말(화면 메타정보) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CA-108 | §1 [원문 무번호] 시트(sheetName) / `Mkt Fcst`(메인) / `spreadTitle`(기간 헤더) / `dayRange`(기본 구간) + P… | mkt-fcst.constants.ts:11 (토큰 `spreadTitle` 실재) | | 구현 |
| CA-109 | §1 [원문 무번호] 편집 가능 / **Division 82 만** (회의 확정 2026-07-07, 실 데이터 확인) | 해당없음 | 문서 머리말(화면 메타정보) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CA-110 | §1 [원문 무번호] POPUP / AS-IS Class | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CA-111 | §1 [원문 무번호] PR (Request Info) / `DMF0003_PRPopup` | components/modals/mkt-fcst-modals.constants.ts:218 (토큰 `DMF0003_PRPopup` 실재) | | 구현 |
| CA-112 | §1 [원문 무번호] PR History / `DMF0003_PRHistoryPopup` | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CA-113 | §1 [원문 무번호] SSP Sync / `DMF0003_SspSyncPopUp` | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CA-114 | §1 [원문 무번호] SSP Sync Compare / `DMF0003_SspSyncComparePopUp` | components/modals/mkt-fcst-modals.constants.ts:12 (토큰 `DMF0003_SspSyncComparePopUp` 실재) | | 구현 |
| CA-115 | §1 [원문 무번호] Version Cut-Off / `VersionCutOffPopUp` (11화면 공용) | 제외 — 공용 모달 | 범위 제외 — Version Cut-Off 는 11화면 공용 모달이고, AS-IS `DMF0003_MktFcst.cs` L5593·L5605~5606 이 전 줄 주석(LEGACY/DISABLED). 공용 모달 제외(사용자 확정 2026-08-15) | 제외 |
| CA-116 | §1 [원문 무번호] **Master Change** / `DMF0003_MatsterChgPopup` | components/modals/mkt-fcst-modals.constants.ts:375 (토큰 `DMF0003_MatsterChgPopup` 실재) | | 구현 |
| CA-117 | §1 [원문 무번호] Project/Item/Owner byDivision / `SCM0002/DM0002/DM0020…` | useMktFcstStore.ts:517 (토큰 `SCM0002` 실재) | | 구현 |
| CB-01 | §2 `EDIT_FLAG != 'Y'` 행 = Measure 이후 전열 잠금 / L1132~1135 | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.editLock.ts:112~ (evalDynCell — EDIT_FLAG!='Y' 행 동적 셀 잠금) |  | 구현 |
| CB-02 | §2 Measure 컬럼까지(키 영역) 전 행 잠금 — Insert 행만 예외 / L1123 | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:741~746 (beginningEdit — 비Insert 행 정적 셀 cancel) |  | 구현 |
| CB-03 | §2 I 행 아닌 행 Measure 잠금 / L1163·2775 | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:741~750 (Insert 행 외 Measure 편집 불가) |  | 구현 |
| CB-04 | §2 division 81*/82 → Division 컬럼 잠금 / 40 → Division40 잠금 / L1275~1278·2698~2701 | features/demand/src/pages/mkt-fcst/mkt-fcst.constants.ts (DIVISION_ID inputTp 'S') + beginningEdit S cancel |  | 구현 |
| CB-101 | §2 [원문 무번호] Bucket / D_ 컬럼 | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.editLock.ts:48~110 (dynKindOf/buildEditCutoff) |  | 구현 |
| CB-102 | §2 [원문 무번호] Daily / 과거(<당주월요일) 잠금 | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.editLock.ts:75~ (Daily — 과거<당주월요일 잠금) |  | 구현 |
| CB-103 | §2 [원문 무번호] Weekly / 전부 잠금 | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.editLock.ts (Weekly — 차기 D_ 기준 과거 판정, C20210827 1:1) |  | 구현 |
| CB-104 | §2 [원문 무번호] Monthly / 전부 잠금 (40: 조건부 — MONTH_NAME 비교) | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.editLock.ts (Monthly — 40 은 O_RC2 8주월 추가 잠금) |  | 구현 |
| CC-01 | §3 Division/Division40/BizType/SoldToCustomer/CountryName/CityName / L2698~2709 | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:455~470 (admin INPUT_TP_CD→CELL_INPUT_EDIT_TYPE 매핑 — 메타 단일 원천 hook #130) |  | 구현 |
| CC-02 | §3 ProjectName/ProjectStatus/ProjectOwner/ItemName/NickName/ItemType / L2710~2721 | CC-01 과 동일 (INPUT_TP_CD 메타) |  | 구현 |
| CC-03 | §3 CUST_GROUP/CUST_GROUP_DTL/Owner/APPLICATION/ROUTE/MDM_PROJECT_NAME/MIN_CAPACITY/FORECA… | CC-01 과 동일 (INPUT_TP_CD 메타) |  | 구현 |
| CC-04 | §3 CellType/FORECAST_INFO_CELL_MODEL/FORECAST_INFO_CELL_PACK_COUNT/FORECAST_INFO_SPEC/VMI… | CC-01 과 동일 (INPUT_TP_CD 메타) |  | 구현 |
| CC-05 | §3 **AS_FROM_SITE — 초기 잠금** (해제는 §5 AS 3축만) / L2752~2753 (E20260211) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:336~341·736~738 (isAsFromSiteEditable 기본 false — 초기 잠금) |  | 구현 |
| CC-06 | §3 LAST_UPDATE_DATE/LAST_UPDATED_BY/SENDER_CODE/SENDER_NAME / L2754~2761 | CC-01 과 동일 (INPUT_TP_CD 메타 'S') |  | 구현 |
| CC-07 | §3 **PROJECT_S_OP_REPORT** (E20241030) / **CELL_PER_MODULE** (E20241015) / L2765~2772 | CC-01 과 동일 — PROJECT_S_OP_REPORT/CELL_PER_MODULE 메타 'S' |  | 구현 |
| CC-08 | §3 **Team/TeamName — 입력 불가** (E20260311) / L2779~2782 | CC-01 과 동일 — TEAM_ID/TEAM_NAME_KO 메타 'S' (E20260311) |  | 구현 |
| CC-101 | §3.1 [원문 무번호] 컨트롤 / 담긴 LAYER (Control 바인딩) | 해당없음 — 표 헤더 | 원천 `DMF0003_MktFcst_상세분석서_v2.0.md` L69 = 표 헤더 행(컨트롤 · 담긴 LAYER · 자식 상태 · LAYER 은폐 방식 · 실효 표시 · 근거). `--init` 자동채번 산물이며 요구사항 행이 아님 | 해당없음 |
| CC-102 | §3.1 [원문 무번호] **cboCellQty** (Cell Qty 체크) / `layoutControlItem10` (Designer L1351) | AS-IS 전용 개념 | AS-IS(WinForms/BigFilter/TB_FX_) 전용 — TO-BE 는 CMBO·메타 체계로 대체. 이식 대상 아님 | 해당없음 |
| CC-103 | §3.1 [원문 무번호] **chkColor** (Color 체크) / `layoutControlItem6` (Designer L1380) | components/MktFcstGrid.tsx:206 (Color 체크(AS-IS 미표시) — 토큰 `chkColor`) |  | 구현 |
| CC-104 | §3.1 [원문 무번호] **btnIncotermsChg** (Master Change) / `layoutControlItem7` (Designer L1339) | AS-IS 전용 개념 | AS-IS(WinForms/BigFilter/TB_FX_) 전용 — TO-BE 는 CMBO·메타 체계로 대체. 이식 대상 아님 | 해당없음 |
| CC-105 | §3.1 [원문 무번호] **cboAS** (AS 체크) / `lciASCheck` (Designer L1371) | AS-IS 전용 개념 | AS-IS(WinForms/BigFilter/TB_FX_) 전용 — TO-BE 는 CMBO·메타 체계로 대체. 이식 대상 아님 | 해당없음 |
| CD-01 | §4 FCST_TYPE / `FCST_TYPE` — W/S 그룹=`EDIT_MODE`(SALES_TYPE_CODE2∪_ADD 6종) / 그 외=NowGroupI… | features/demand/src/pages/mkt-fcst/mkt-fcst.constants.ts:359~373 (GRID_EDIT_COMBO FCST_TYPE=FcstTypeEditMode wsOnly) + MktFcstGrid.tsx:762~767 |  | 구현 |
| CD-02 | §4 INCOTERMS / `INCOTERMS`(ALL,'Y' — VALID_YN 만) / AS 사이트 행 = `AS_INCOTERMS`(division, si… | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx beginningEdit INCOTERMS 분기 — AS 사이트 행 = AsIncotermsEdit(division) 스왑 | 2026-08-12 보완 (AS-IS AS_INCOTERMS 1:1 — DMF0082 동일 콤보 재사용) | 구현 |
| CD-03 | §4 AS_FROM_SITE / `AS_FROM_SITE`(division) | admin SHEET_COLUMNS CELL_COMBO_DATA_TYPE + MktFcst.tsx:190 (AS_FROM_SITE 콤보 param1=division) |  | 구현 |
| CD-04 | §4 MEASURE / `MktFcstEditMeasure`(division, site, project, userId) — 81*/82 비W/S 는 `AS_In… | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:768~790 (MktFcstEditMeasure + AS 향/W-S 필터) |  | 구현 |
| CD-05 | §4 TEAM / `UserTeamByDivisionAuth` |  | Team 컬럼 = E20260311 입력 불가('S') — 편집 콤보 자체가 불필요(AS-IS 최종 상태도 입력 불가) | 해당없음 |
| CD-06 | §4 END_CUSTOMER(40) / `EndCustomerByDivision40` | features/demand/src/pages/mkt-fcst/mkt-fcst.constants.ts (END_CUSTOMER cascade — GRID_CASCADE_FILTERS) |  | 구현 |
| CD-07 | §4 END_CUSTOMER(81*/82) / `UserEndCustomerByDivisionDeptAuth` | CD-06 과 동일 (cascade) |  | 구현 |
| CD-08 | §4 SCM_SITE_ID / [E20260402] `GetSalesSite`=SiteByEndCustomer(**PARAM5=W/S 'Y'**) — 구 Use… | features/demand/src/pages/mkt-fcst/mkt-fcst.constants.ts GRID_CASCADE_FILTERS SCM_SITE_ID + SiteByEndCustomer(PARAM5 W/S) |  | 구현 |
| CD-09 | §4 SCM_SITE_ID40 / `UserSiteByEndCustomer` | CD-08 과 동일 — TO-BE 는 division 단일 그리드(40 계열 별도 컬럼 없음) |  | 구현 |
| CD-10 | §4 PLANT_SITE_ID / 조회조건 dtPlantSite → 행별 `SalesPlant`/`PlantSiteByItem`(division, project… | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx applyPlantSites(PROJECT_CODE/ITEM_ID 변경 트리거, 81* 만) + beginningEdit PLANT_SITE_ID 스왑 — CMBO `PlantSiteByItem` 신규 등재(AS-IS UP_FX L5858~5884 1:1, 실측 27→5행 축소 확인) | 2026-08-12 보완 (hook #117 3산출물: 등록+배선+파라미터) | 구현 |
| CD-11 | §4 DOM_EXP(40) / `DM_CUSTOMS_HANDBOOK` | features/demand/src/pages/mkt-fcst/mkt-fcst.constants.ts:189 (DOM_EXP _comboKey=CustomsHandbook) |  | 구현 |
| CE-01 | §5 division / `81*` 또는 `82` 만 로직 진입 | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:777 (isDiv8182 분기) |  | 구현 |
| CE-02 | §5 Sales Site 향 / AS_FROM_SITE 콤보 **Name** 에 행 SCM_SITE_ID 매칭 = **비축향 → 잠금+값 클리어** + Meas… | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx isAsFromSiteEditable — 비축향(AS 사이트 NAME 매칭) 축 추가(항상 잠금) | 2026-08-12 보완 | 구현 |
| CE-03 | §5 FCST Type / 고객향에서 FCST Type ∈ SALES_TYPE_CODE2(4종: WS/WSF/AS/ASF) → **해제** / 아니면 잠금+값 … | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:336~341 (FCST_TYPE ∈ FcstTypeWs 4종 판정) |  | 구현 |
| CE-04 | §5 적용 지점 / ScmSiteId ComboSelChange(L3446~3514) / FcstType ComboSelChange(L3556~3602) / C… | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx cellEditEnded [CE-04] — SCM_SITE_ID/FCST_TYPE 변경 시 비축향→MEASURE·AS_FROM_SITE 클리어 / 비W-S→AS_FROM_SITE 클리어 | 2026-08-12 보완 (.cs L3478~3483·3506·3587·3597 1:1) | 구현 |
| CE-05 | §5 조회 컬럼 강제 / [E20260402] W/S 권한 진입 시 GET_SPREAD_TITLE(p_user_group, p_type='LOAD') 이 AS_… | features/demand/src/pages/mkt-fcst/useMktFcstStore.ts:88·241 (p_type 'LOAD') + SP GET_SPREAD_TITLE p_user_group |  | 구현 |
| CE-06 | §5 저장값 / 행 컬럼 값 직접 직렬화(sASFromSite `Replace(",","^")`) — 구 cboAS 사문 | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.save.ts:100~102 (행 AS_FROM_SITE 직렬화 — ','→'^') |  | 구현 |
| CE-101 | §5.1 [원문 무번호] 논리 컬럼 / 40 전용 | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CE-102 | §5.1 [원문 무번호] Div* / `DIVISION_ID40` | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CE-103 | §5.1 [원문 무번호] End Customer / `END_CUSTOMER40`(콤보 EndCustomerByDivision40) | MktFcst.tsx:702 (토큰 `END_CUSTOMER40` 실재) | | 구현 |
| CE-104 | §5.1 [원문 무번호] Sales Site* / `SCM_SITE_ID40` | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CE-105 | §5.1 [원문 무번호] Model* / `ITEM_ID40` | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CE-106 | §5.1 [원문 무번호] Plant Site* / — | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CE-107 | §5.1 [원문 무번호] Energy/Cell / — | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CE-108 | §5.1 [원문 무번호] Cell/Car·Module / — | DB `SCM_MST_SHEET_COLUMNS` — `CELL_PER_CAR`/`CELL_PER_MODULE`/`MODULE_PER_CAR` DIVISION_ID=81 계열 전용 실측 (CG-110 과 동일 실체 — §5.1 정적컬럼 축) |  | 구현 |
| CE-109 | §5.1 [원문 무번호] Project 계열 / (40 미노출) | DB `SCM_MST_SHEET_COLUMNS` — `PROJECT_CODE`/`PROJECT_NAME` DIVISION_ID='82,81,81_UC…'(40 미포함) + components/MktFcstForm.tsx:149 (Project = 40 비활성, division 변경 시 clear) |  | 구현 |
| CE-110 | §5.3 [원문 무번호] LOOKUP_TYPE / 건수(유효) | utils/mkt-fcst.gridCombos.ts:284 (토큰 `LOOKUP_TYPE` 실재) | | 구현 |
| CE-111 | §5.3 [원문 무번호] **GET_ADMIN_GROUP** / 9(9) | useMktFcstStore.ts:253 (토큰 `GET_ADMIN_GROUP` 실재) | | 구현 |
| CE-112 | §5.3 [원문 무번호] **DM_UI_EDITABLE_DIVISION** / 6(6) | mkt-fcst.constants.ts:62 (토큰 `DM_UI_EDITABLE_DIVISION` 실재) | | 구현 |
| CE-113 | §5.3 [원문 무번호] **MKT_FCST_MEASURE** / 24(22) | utils/mkt-fcst.gridCombos.ts:262 (토큰 `MKT_FCST_MEASURE` 실재) | | 구현 |
| CE-114 | §5.3 [원문 무번호] **AS_SITE_PLANT** / 18(13) | utils/mkt-fcst.gridCombos.ts:247 (토큰 `AS_SITE_PLANT` 실재) | | 구현 |
| CE-115 | §5.3 [원문 무번호] **TMM_MEASURE_ADMIN** / 70(70) | DB `SCM_ADM_LOOKUP_MASTER_DETAIL` LOOKUP_TYPE='TMM_MEASURE_ADMIN' 70행 |  | 구현 |
| CE-116 | §5.3 [원문 무번호] **CELL_TYPE** / 21(21) | DB `SCM_ADM_LOOKUP_MASTER_DETAIL` LOOKUP_TYPE='CELL_TYPE' 21행 |  | 구현 |
| CE-117 | §5.3 [원문 무번호] **DM_BIZ_TYPE** / 3(3) | DB `SCM_ADM_LOOKUP_MASTER_DETAIL` LOOKUP_TYPE='DM_BIZ_TYPE' 3행 |  | 구현 |
| CE-118 | §5.3 [원문 무번호] **DM_BIZ_TYPE_40** / 1(1) | DB `SCM_ADM_LOOKUP_MASTER_DETAIL` LOOKUP_TYPE='DM_BIZ_TYPE_40' 1행 |  | 구현 |
| CE-119 | §5.3 [원문 무번호] **EDI_END_CUSTOMER** / 16(16) | DB `SCM_ADM_LOOKUP_MASTER_DETAIL` LOOKUP_TYPE='EDI_END_CUSTOMER' 16행 |  | 구현 |
| CE-120 | §5.3 [원문 무번호] **RPA_END_CUSTOMER** / 4(4) | DB `SCM_ADM_LOOKUP_MASTER_DETAIL` LOOKUP_TYPE='RPA_END_CUSTOMER' 4행 |  | 구현 |
| CE-121 | §5.3 [원문 무번호] **DM_MEASURE_POSITIONAL_NOTATION** / 29(29) | DB `SCM_ADM_LOOKUP_MASTER_DETAIL` LOOKUP_TYPE='DM_MEASURE_POSITIONAL_NOTATION' 29행 |  | 구현 |
| CE-122 | §5.4 [원문 무번호] 콤보 SQL_ID / 바인드 | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CE-123 | §5.4 [원문 무번호] `MktFcstEditMeasure` / @divisionId | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CE-124 | §5.4 [원문 무번호] `MktFcstEditableDivision` / 없음 | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CE-125 | §5.4 [원문 무번호] `MktFcstUserEditDivision` / @sesUserId | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CE-126 | §5.4 [원문 무번호] `MktFcstWsPlannerYn` / @sesUserId | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CE-127 | §5.4 [원문 무번호] `BizType` / 없음 | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CF-01 | §6 I 행 키 중복(그리드 전수 — 81*=9키/82·40=8키) / MSG00043 | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.validate.ts:100~130 (신규 행간 중복 — MSG00043) |  | 구현 |
| CF-02 | §6 I 행 D_ 수량 입력 0건 / MSG00034 | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.validate.ts (일자 수량 미입력 — MSG00034) |  | 구현 |
| CF-03 | §6 dtSave 행 중 그리드 실재+AS_FROM_SITE 일치(bAsCompare)만 dtSaveFinal 승계 / I 저장이 기존 행 키와 같으면 제외 /… |  | dtSave→dtSaveFinal 승계 구조 = WinForms 로컬 상태 — TO-BE 는 EditTracker+insertedRows 가 그리드 실재 행만 원천으로 삼아 동일 불변식 자동 성립 | 해당없음 |
| CF-04 | §6 **[E20260402] W/S 그룹 × 81*/82 × 고객향 × FCST Type ∈ W/S 4종 × AS_FROM_SITE 빈값** / MSG0047… | features/demand/src/pages/mkt-fcst/MktFcst.tsx:544~569 (W/S×81*/82×고객향×W-S 4종×AS_FROM_SITE 빈값 → MSG00476) |  | 구현 |
| CF-05 | §6 저장 성공(Tables 없음) / MSG00004(건수) + 재조회 + viewport 복원 | features/demand/src/pages/mkt-fcst/MktFcst.tsx:626~636 (성공 토스트 MSG00606+invalidate+refetch+scroll 복원) | AS-IS MSG00004 팝업 → 하단 토스트 = 통합테스트 공통 C4 표준 적용 | 구현 |
| CF-06 | §6 SP 가 Tables[0] 반환 / 그 메시지 표시 + Tables[1] 있으면 SspSyncPopUp | features/demand/src/pages/mkt-fcst/MktFcst.tsx:30~31 + components/modals/SspSyncResultModal.tsx (저장 응답 동기화 내역) |  | 구현 |
| CF-101 | §6.2 [원문 무번호] 트리거 / MSG_ID | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CF-102 | §6.2 [원문 무번호] 조회 / MSG00097 | mkt-fcst.constants.ts:268 (토큰 `MSG00097` 실재) | | 구현 |
| CF-103 | §6.2 [원문 무번호] 조회 / MSG00108 | mkt-fcst.constants.ts:285 (토큰 `MSG00108` 실재) | | 구현 |
| CF-104 | §6.2 [원문 무번호] 조회 / MSG00164 | mkt-fcst.constants.ts:287 (토큰 `MSG00164` 실재) | | 구현 |
| CF-105 | §6.2 [원문 무번호] 조회 / MSG00665 | mkt-fcst.constants.ts:307 (토큰 `MSG00665` 실재) | | 구현 |
| CF-106 | §6.2 [원문 무번호] 셀편집/저장 / MSG00429 | mkt-fcst.constants.ts:273 (토큰 `MSG00429` 실재) | | 구현 |
| CF-107 | §6.2 [원문 무번호] 저장 / MSG00043 | mkt-fcst.constants.ts:279 (토큰 `MSG00043` 실재) | | 구현 |
| CF-108 | §6.2 [원문 무번호] 저장 / MSG00660 | mkt-fcst.constants.ts:269 (토큰 `MSG00660` 실재) | | 구현 |
| CF-109 | §6.2 [원문 무번호] 저장 / MSG00666 | mkt-fcst.constants.ts:309 (토큰 `MSG00666` 실재) | | 구현 |
| CF-110 | §6.2 [원문 무번호] 저장 / MSG00663 | mkt-fcst.constants.ts:303 (토큰 `MSG00663` 실재) | | 구현 |
| CF-111 | §6.2 [원문 무번호] 저장 / MSG00152 / MSG00617 | mkt-fcst.constants.ts:291 (토큰 `MSG00152` 실재) | | 구현 |
| CF-112 | §6.2 [원문 무번호] 편집게이트 / MSG00448 | mkt-fcst.constants.ts:293 (토큰 `MSG00448` 실재) | | 구현 |
| CF-113 | §6.2 [원문 무번호] Bucket / MSG00227 | mkt-fcst.constants.ts:289 (토큰 `MSG00227` 실재) | | 구현 |
| CF-114 | §6.2 [원문 무번호] 복사 / MSG00661 | mkt-fcst.constants.ts:299 (토큰 `MSG00661` 실재) | | 구현 |
| CF-115 | §6.2 [원문 무번호] 수정모드 / MSG00662 | mkt-fcst.constants.ts:301 (토큰 `MSG00662` 실재) | | 구현 |
| CF-116 | §6.2 [원문 무번호] FcstType / MSG00664 | mkt-fcst.constants.ts:305 (토큰 `MSG00664` 실재) | | 구현 |
| CG-01 | §7 수량 셀 수정 시 필수값 빈값 — Division/Project(81*·82)/EndCustomer(40)/SalesSite/Item/DomExp(Cust… | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.validate.ts:81~99 (division 분기 필수 — MSG00002) | AS-IS 셀 즉시+값 회수 → TO-BE 저장 시점 일괄(No.38 정책 계열) — 검증 전량 커버 | 구현 |
| CG-02 | §7 I 행 키 8~9축 중복 2건 이상 / MSG00260 + 값 회수 | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.validate.ts:100~130 (중복 MSG00043) | AS-IS 실시간 MSG00260 → 저장 시점 일원화(No.38 — DMF0082 08-11 선례) | 구현 |
| CG-03 | §7 Monthly 입력 < 실적(과거 D_) 합 / MSG00225 차단 | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.recalc.ts:245~325 (belowActual) + MktFcstGrid.tsx:887 (MSG00225) |  | 구현 |
| CG-04 | §7 Weekly 입력 < SSP 동기화(PaleGreen) 합 — 40 × MKT_FCST_RP × **FCST Type≠RMA**(E20241210) / 값… | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.recalc.ts:110~ (recalcWeeklyToDaily — syncMap 하한·sync 셀 제외·RMA 예외 E20241210) |  | 구현 |
| CG-05 | §7 I 행 키값 변경 / 수량 전부 클리어 + dtSave 에서 제거 | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx cellEditEnded [CG-05] — I 행 정적 키 변경 시 수량(D_/W_/M_) 전부 클리어 + MktFcst.tsx clearDynQuantities(팝업 경로) | 2026-08-12 보완 (.cs L5319~5379 1:1) | 구현 |
| CG-06 | §7 I 행 Measure 를 AS_In_Req/BNPIn 외로 변경 / Item 4종 클리어 | features/demand/src/pages/mkt-fcst/mkt-fcst.constants.ts:374~ (MEASURE_MODEL_KEEP/CLEAR_COLS) + MktFcstGrid.tsx:958~972 |  | 구현 |
| CG-07 | §7 버킷 배분 / 주→일: 요일비트(기본 '0000010'=FRI) 균등+잔여 마지막, 비트 없으면 기본요일 단일, PaleGreen 제외 / 월→일: 기본요… | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.recalc.ts (요일비트·기본요일·잔여 배분 — dispatchRecalc) |  | 구현 |
| CG-101 | §7.1 [원문 무번호] 키 컬럼 / Customer40·ScmSiteId40·ItemId40 | DB `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID=DMF0003·SHEET_NAME='Mkt Fcst') — `END_CUSTOMER40`/`SCM_SITE_ID40`/`ITEM_ID40` 3행 모두 DIVISION_ID='40' VISIBLE_FLAG='Y' 실측(2026-08-15) |  | 구현 |
| CG-102 | §7.1 [원문 무번호] Plant Site 필수 / ✗ | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CG-103 | §7.1 [원문 무번호] 중복키 Plant 포함 / ✗ | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CG-104 | §7.1 [원문 무번호] SspSync 대상 / ✓(MKT_FCST_RP) | mkt-fcst.constants.ts:36 (토큰 `MKT_FCST_RP` 실재) | | 구현 |
| CG-105 | §7.1 [원문 무번호] Project 필드 / **비활성** | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CG-106 | §7.1 [원문 무번호] Sender Code(EDI) / ✗ | components/MktFcstForm.tsx:231~236 (Sender Code — 81 계열 전용 enable, AS-IS `clbEDISender` Division==81 파리티) + DB SHEET_COLUMNS `SENDER_NAME` DIVISION_ID='40,81,81_UC…'(82 제외) |  | 구현 |
| CG-107 | §7.1 [원문 무번호] Cell Qty / **40만** | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CG-108 | §7.1 [원문 무번호] checkInvalidExec / ✗ | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CG-109 | §7.1 [원문 무번호] Energy/Cell 컬럼 / ✗ | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CG-110 | §7.1 [원문 무번호] Cell/Car·Module 컬럼 / ✗ | DB `SCM_MST_SHEET_COLUMNS` — `CELL_PER_CAR`/`CELL_PER_MODULE`/`MODULE_PER_CAR` 3행 모두 DIVISION_ID='81,81_UC,81_HM,81_ST,81_HD,81_HG' 실측(40·82 미노출) |  | 구현 |
| CG-111 | §7.1 [원문 무번호] Bucket 기본 / Weekly | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CG-112 | §7.1 [원문 무번호] **편집 가능** / ✗ | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CG-113 | §7.1 [원문 무번호] 8주 잠금(Monthly) / ✓ | utils/mkt-fcst.editLock.ts:186~ (Division 40 — 8주차 `O_RC2.BASIS_YYYYMM` 이전 월 추가 잠금, AS-IS L974~981) + :58 div40MonthCutoff |  | 구현 |
| CG-114 | §7.3 [원문 무번호] 상위(선택) / 조건 | 해당없음 — 표 헤더 | 원천 `상세분석서_v2.0.md` L228 = §7.3 표 헤더 행(상위(선택) · 조건 · 하위(종속) · 유형 · SP). 요구사항 행이 아님 | 해당없음 |
| CG-115 | §7.3 [원문 무번호] CUST_FCST / 전 division | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CG-116 | §7.3 [원문 무번호] CUST_FCST / 전 division(동적) | mkt-fcst.constants.ts:217 (토큰 `CUST_FCST` 실재) | | 구현 |
| CG-117 | §7.3 [원문 무번호] **MKT_FCST_RP** / **Division 82 한정** | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CG-118 | §7.3 [원문 무번호] (선택 무관) / 82, 판가 존재 | DB `PKG_DMF0003`(PACKAGE BODY) L8835~8875 — 'LOC measure → MKT_FCST_RP, BNPIn(상품/전극) 행 수집' 자동행 생성 + L11365/L11414 `V_DIVISION_ID='82' AND V_MEASURE='BNPIn'` 판가 존재 검사 실측 |  | 구현 |
| CG-119 | §7.3 [원문 무번호] AS_In_Req/Plan/Inv / 전체, as_yn='Y' | components/MktFcstGrid.tsx:1321~1323 (Sales site=비축향(AS) → W/S Planner 행 Measure `AS_In_Req` 셋팅·후보 1종) + DB SHEET_COLUMNS `AS_YN` 전 division |  | 구현 |
| CG-120 | §7.3 [원문 무번호] TMM_FCST / 81 계열, TMM_MEASURE_ADMIN 등록자 | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CG-121 | §7.3 [원문 무번호] CUST_FCST_ORG / (비활성, E20241126 합의) | 해당없음 — AS-IS 비활성 | 원천 `상세분석서_v2.0.md` L236 = CUST_FCST_ORG · (비활성, E20241126 합의) · Customer Fcst[Org.] · 비활성 · L954~980. AS-IS 합의로 비활성 확정 — 이식 대상 아님 | 해당없음 |
| CH-01 | §8 division 미선택 / MSG00097 | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.validate.ts:35~44 (validateFind — MSG00097) |  | 구현 |
| CH-02 | §8 기간 from > to / MSG00108 | CH-01 과 동일 (기간 역전 MSG00108) |  | 구현 |
| CH-03 | §8 기간 3년 초과 / MSG00164 + to=from+2년 보정 | CH-01 과 동일 (3년 초과 MSG00164 — 일자 정밀 판정) |  | 구현 |
| CH-04 | §8 division=40 / Project/PlantSite/btnProject 비활성, cboCellQty 활성, checkInvalidExec 비활성 | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx (division 분기 — 40 Project/PlantSite 비활성 계열) |  | 구현 |
| CH-05 | §8 division=82 / checkInvalidExec 활성+**기본 체크**, PlantSite 비활성·클리어, Bucket 기본 **Daily** | features/demand/src/pages/mkt-fcst/useMktFcstStore.ts:156~163 (82 Invalid 기본 체크) + Form (PlantSite 비활성·Bucket 기본 Daily) |  | 구현 |
| CH-06 | §8 division=81 / lblEDISender 활성(+콤보), PlantSite 활성 | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx (81 EDISender 활성·PlantSite 활성) |  | 구현 |
| CH-07 | §8 I 행 존재 중 Bucket 변경 시도 / MSG00227 | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx:255~275 (insertedRowCount>0 시 Bucket 변경 차단 — MSG00227) |  | 구현 |
| CH-08 | §8 버킷 변경(편집모드) / EditButton 2회 재호출로 잠금 재계산 | react 상태 기반 — bucketType 변경 시 editCutoff/beginningEdit 자동 재계산(AS-IS EditButton 2회 재호출 동등) |  | 구현 |
| CH-09 | §8 캐스케이드 / Division→Team→EndCustomer→SalesSite(+PlantSite 81) 순 재조회, division 변경 시 txtPro… | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx:67~106 (콤보 cascade — Division→Team→EndCustomer→SalesSite) |  | 구현 |
| CH-101 | §8 [원문 무번호] POPUP / SP | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CH-102 | §8 [원문 무번호] PR (Request Info) / `DMF0003_GET_PRPOPUP` | components/modals/PrModal.tsx:21 (토큰 `DMF0003_GET_PRPOPUP` 실재) | | 구현 |
| CH-103 | §8 [원문 무번호] PR History / `DMF0003_GET_PR_HISTORY_POPUP` | mkt-fcst.constants.ts:19 (토큰 `DMF0003_GET_PR_HISTORY_POPUP` 실재) | | 구현 |
| CH-104 | §8 [원문 무번호] SSP Sync / (SP 없음) | 제외 — SSP Sync | 범위 제외 — SSP Sync 는 구현 대상에서 제외(사용자 확정 2026-08-15). 표시/색상 축(E08·CI-01)은 이미 구현되어 별도 유지 | 제외 |
| CH-105 | §8 [원문 무번호] SSP Sync Compare / `DMF0003_GET_MKT_FCST_COMPARE_POPUP`(8 IN) | mkt-fcst.constants.ts:17 (토큰 `DMF0003_GET_MKT_FCST_COMPARE_POPUP` 실재) | | 구현 |
| CH-106 | §8 [원문 무번호] Version Cut-Off / `DMF0010_GET_DM_MDF_VERSION` | 제외 — 공용 모달 | 범위 제외 — Version Cut-Off 는 11화면 공용 모달이고, AS-IS `DMF0003_MktFcst.cs` L5593·L5605~5606 이 전 줄 주석(LEGACY/DISABLED). 공용 모달 제외(사용자 확정 2026-08-15) | 제외 |
| CH-107 | §8 [원문 무번호] Project/Item/Owner byDivision / 콤보/팝업 SP | 해당없음 | 표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물 | 해당없음 |
| CH-108 | §8 [원문 무번호] **Master Change** / `DMF0000_GET_MASTER_CHG_POPUP`(사내 미존재) | DB ALL_OBJECTS PROCEDURE — `DMF0000_GET_MASTER_CHG_POPUP` |  | 구현 |
| CI-01 | §9 SSP 동기화 셀(40/82) / ATTR1 `일자/A^P` — A=PaleGreen, P=PapayaWhip | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:644~660 (sspSyncStateOf → PaleGreen/PapayaWhip) |  | 구현 |
| CI-02 | §9 당주 라인 / 초록 BevelBorder — count≥2 시 [E20250313] 조회시작>당주월요일 이면 this_YYYYMMWW, 아니면 W_{당주월… | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:632 (currentPeriod 셀 테두리 초록) |  | 구현 |
| CI-03 | §9 당주/당월 헤더 / 초록 볼드(굴림 9 Bold) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:600~612 (헤더 초록 볼드) |  | 구현 |
| CI-04 | §9 과거 실적 구간 / chkColor 체크 시 Gainsboro(당월 M_ 는 White) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx (editCutoff 기반 과거 셀 배경 — formatItem) |  | 구현 |
| CI-05 | §9 주말 헤더 / SAT 파랑 / SUN 빨강 | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:604~612 (SAT 파랑 #1565c0 / SUN 빨강 #d32f2f) |  | 구현 |
| CI-06 | §9 NOTATION 서식 / INTEGER=정수 / POINT=입력 형태 / POINT3=소수 3자리 강제(0.000→0) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:521 (format '#,##0.###') | 주의 NOTATION 3분기 중 POINT3(소수 3자리 강제 — E20240812 82 Energy) 미재현: 유효자릿수만 표시(0.5→0.5, AS-IS 0.500). P3 판정 대상(소형) | 구현 |
| CI-07 | §9 저장 후 / Action 클리어 + UnLockColor + 행 재잠금(빨강 계열) | 저장 성공 후 재조회(refetch)로 상태 자연 초기화 — AS-IS SetSaveSheetColor 의 Action 클리어 동등 |  | 구현 |
| CI-08 | §9.2 SCP Planner 시간창(81) / LOOKUP `SCP_PLANNER_EDIT_FLAG` 로 수정 가능 시간 확인 → 불충족 **MSG00477** | mkt-fcst.constants.ts:73 (토큰 `LOOKUP` 실재) | | 구현 |
| CI-09 | §9.2 DM Planner류 시간창(81) / LOOKUP `DM_PLANNER_EDIT_FLAG` → 제한 시 **MSG00478**(제한권한·EDIT_DA… | mkt-fcst.constants.ts:73 (토큰 `LOOKUP` 실재) | | 구현 |
| CI-10 | §9.2 저장 SP 권한 전달 / 저장 호출에 **p_authority**(로그인 권한 그룹) 추가 | DB `PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST` **P_AUTHORITY 16번째 인자** 실측(ALL_ARGUMENTS POSITION=16) + MktFcst.tsx:596~605 (authority 산출) + utils/mkt-fcst.save.ts:51~52,159 (payload 단일값) |  | 구현 |
| CJ-01 | §10 ADMIN / DM ADMIN / Master Chg 버튼 조건 충족(단 §1.1-5 최종 숨김) / DM ADMIN 은 81 Planner 시간 게이트… | CA-02~05·E01-3 참조 (Master Chg 최종 숨김) |  | 구현 |
| CJ-02 | §10 DM Planner / 81* 시간 게이트(§1-4) / AS_FROM_SITE 컬럼 부재 차단(§1-5) | CA-04(미구현)·CA-05 참조 | MSG00478 갭은 CA-04 에서 추적 | 구현 |
| CJ-03 | §10 DM Planner (W/S) / FCST Type=EDIT_MODE 6종 / AS_In_Req 사용 가능(유일) / p_as_yn='Y' / Site … | CD-01·CE-*·CF-04·E02(p_as_yn) 참조 |  | 구현 |
| CJ-04 | §10 SCP Planner / 82·40 편집 차단(MSG00096) / 81* 시간 게이트(MSG00477) / 81* Insert 차단(MSG00096) | CA-01·CA-03·E03-3(SCP 81 Insert 차단) 참조 |  | 구현 |
| CJ-05 | §10 그 외(Viewer 등) / Master Chg 숨김·편집 버튼 BaseForm 권한 체계(hasButton) 위임 | features/demand/src/pages/mkt-fcst/MktFcst.tsx:706~737 (hasButton 위임) |  | 구현 |
| CK-01 | §11 DM.DMF0003_GET_MKT_FCST_DATA / 조회 | PROC_M PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA (SEARCH) — useTabProcQuery SHEETS.MAIN |  | 구현 |
| CK-02 | §11 DM.DMF0003_SAVE_MKT_FCST / 저장 | PROC_M P_DMF0003_SAVE_MKT_FCST (SAVE) — apiClient.post call-proc |  | 구현 |
| CK-03 | §11 DM.DMF0003_GET_SPREAD_TITLE / 헤더 | PROC_M P_DMF0003_GET_SPREAD_TITLE — useTabProcQuery SHEETS.SPREAD_TITLE |  | 구현 |
| CK-04 | §11 DM.DMF0003_GET_BUCKET_TYPE_CODE / 버킷 콤보 | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx (BucketType 콤보 — CMBO 전환) |  | 구현 |
| CK-05 | §11 DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP / 동기화 비교 팝업 | PROC_M P_DMF0003_GET_MKT_FCST_COMPARE_POPUP — SspSyncCompareModal |  | 구현 |
| CK-06 | §11 DM.PR_GET_DAY_RANGE / 기간 기본값 | PROC_M PR_GET_DAY_RANGE — MktFcst.tsx:92~98 (SHEETS.DAY_RANGE) |  | 구현 |
| CK-07 | §11 SCM.SCM0001_GET_LOOKUP_VALUES / ITEM_TYPE_CODE 등 | CMBO ItemType (SCM0001_GET_LOOKUP_VALUES 전환) |  | 구현 |
| CK-08 | §11 SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION / BizType | CMBO BizType (division 파라미터) |  | 구현 |
| CK-09 | §11 DM.UP_FX_GetCommonDataList_DM / 콤보 범용(FCST_TYPE/AS_INCOTERMS/SiteByEndCustomer(40)/DM… | UP_FX→CMBO 전환 전수(hook #117 3산출물): FcstTypeWs/FcstTypeEditMode/AS_FROM_SITE/IncotermsEdit/MktFcstEditMeasure/CustomsHandbook 등 — 게이트 섹션7 대사 |  | 구현 |
| CK-10 | §11 DataService.GetDMInnerTable / 조회조건 콤보 8축(§1.1-1) | CMBO 8축 (MyDivision/UserTeamByDivision/EndCustomerByDivision/BizType/UserSiteByEndCustomer/UserPlantSiteByEndCustomer/EdiSender 계열) |  | 구현 |
| CK-11 | §11 (팝업 경유) DMF0003_GET_PRPOPUP/GET_PR_HISTORY_POPUP/SAVE_PRPOPUP / PR 계열 | PROC_M P_DMF0003_GET_PRPOPUP/GET_PR_HISTORY_POPUP/SAVE_PRPOPUP — PrModal/PrHistoryModal |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:E02:SEARCH | [SEARCH] §2 FindData — 조회 (FindButton L805 → FindData L1673~1947) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:412 (handleSearch→useTabProcQuery) |  | 구현 |
| CRUD:E03:SAVE | [SAVE] §3 편집/저장 | features/demand/src/pages/mkt-fcst/MktFcst.tsx:519 (handleSave→SAVE/call-proc) |  | 구현 |
| MODAL:ColumnLayoutModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | 제외 — 공용 모달 | 범위 제외 — 공용 모달은 이번 대사 대상에서 제외(사용자 확정 2026-08-15). 공용 정본 = master `columnLayoutModal`/`measureSelectModal`(hook #132) | 제외 |
| MODAL:DMF0003_SspSyncComparePopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | features/demand/src/pages/mkt-fcst/components/modals/SspSyncCompareModal.tsx (COMPARE_POPUP 배선) |  | 구현 |
| MODAL:DMF0003_SspSyncPopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | features/demand/src/pages/mkt-fcst/components/modals/SspSyncResultModal.tsx (저장 응답 동기화 내역) |  | 구현 |
| MODAL:FPModal | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | 제외 — 공용 모달 | 범위 제외 — 공용 모달은 이번 대사 대상에서 제외(사용자 확정 2026-08-15). 공용 정본 = master `columnLayoutModal`/`measureSelectModal`(hook #132) | 제외 |
| MODAL:ImagePopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | 해당없음 — 모달 아님 | AS-IS `DMF0003_MktFcst.cs` L555/L558 `siMain.ImagePopUp = imageList1.Images[0]` = FarPoint Spread **셀 이미지 속성**. 팝업 화면이 아니라 추출기 오탐 | 해당없음 |
| MODAL:PrHistoryModal | FE 실존 모달 (components/modals/PrHistoryModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | features/demand/src/pages/mkt-fcst/components/modals/PrHistoryModal.tsx — AS-IS DMF0003_PRHistoryPopup 대응 |  | 구현 |
| MODAL:PrModal | FE 실존 모달 (components/modals/PrModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | features/demand/src/pages/mkt-fcst/components/modals/PrModal.tsx — AS-IS DMF0003_PRPopup 대응 |  | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | 해당없음 — 메서드명 | AS-IS 15회 전부 `popup.ShowDialog()` 형태 = WinForms **모달 표시 메서드**. 특정 팝업 이름이 아니다. 실제 팝업(ProjectByDivision/ItemByDivision 등)은 별도 행으로 이미 대사됨 | 해당없음 |
| MODAL:SspSyncCompareModal | FE 실존 모달 (components/modals/SspSyncCompareModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | MODAL:DMF0003_SspSyncComparePopUp 와 동일 실체(FE 파일명 행) |  | 구현 |
| MODAL:SspSyncPopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | MODAL:DMF0003_SspSyncPopUp 와 동일 실체 |  | 구현 |
| MODAL:SspSyncResultModal | FE 실존 모달 (components/modals/SspSyncResultModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | MODAL:DMF0003_SspSyncPopUp 와 동일 실체(FE 파일명 행) |  | 구현 |
| MODAL:VersionCutOffPopUp | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | 해당없음 — AS-IS 비활성 | AS-IS L5605~5606 전 줄 주석 + `btnCutOff_Click`(L5593) 도 주석 = **LEGACY/DISABLED**. 분석서에도 'LEGACY/DISABLED' 명기(상세동작_개발용 §17). 이식 대상 아님 | 해당없음 |
| CRUD:E03:INSERT | [INSERT] §3.3 InsertRow — 신규행 (수기 추가 — 상위 E03 이 SAVE 로만 분류됨) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:472 (handleInsert) |  | 구현 |
| CRUD:E03:DELETE | [DELETE] §3.4 DeleteButton — I 행만 삭제 (수기 추가) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:503 (handleDelete — I 행만) |  | 구현 |
| CRUD:E03:EDIT | [EDIT] §3.1 EditButton — 편집 게이트 8종 + 잠금 (수기 추가) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:429 (guardEditGates) + Grid beginningEdit |  | 구현 |
| CRUD:E03:EXCEL | [EXCEL] §3.5 ExcelButton — 다운로드 (수기 추가) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:775 (excelFileName — DataGrid 공통 export) |  | 구현 |
| MODAL:MeasureSelectModal | FE 실존 모달 (공용 features/master/src/components/measureSelectModal — 화면 사본 삭제 2026-08-13) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx (공용 정본) — MktFcst.tsx 배선(onApply=titleSet 'M' 저장) — AS-IS DM0002_TitleSetForm_Popup(false=Measure 모드) 대응 |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | MktFcst.tsx:492 `keepRowVisibleUnderFilter(grid, newRow)` (handleInsert 말미) |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | MktFcst.tsx:386~394 미저장 변경 confirm (MSG00703) — insertedRows + editTracker 원본값 기준 |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | MktFcst.tsx:4,6 (ColumnLayoutModal/MeasureSelectModal) · useMktFcstStore.ts:68 |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | MktFcst.tsx:64 `setToast` · components/modals/PrModal.tsx:50,141,182 |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | MktFcst.tsx:393 (dataMap) · components/MktFcstGrid.tsx:301 · utils/mkt-fcst.gridCombos.ts:3 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | components/MktFcstForm.tsx:182,187 (join/split ',') · utils/mkt-fcst.gridCombos.ts:531 |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/MktFcstGrid.tsx:1658 `rebindFilterColumns` (updatedLayout 핸들러 0-c) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | MktFcst.tsx:492 `keepRowVisibleUnderFilter(grid, newRow)` (handleInsert 말미) |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | MktFcst.tsx:386~394 미저장 변경 confirm (MSG00703) — insertedRows + editTracker 원본값 기준 |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | MktFcst.tsx:4,6 (ColumnLayoutModal/MeasureSelectModal) · useMktFcstStore.ts:68 |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | MktFcst.tsx:64 `setToast` · components/modals/PrModal.tsx:50,141,182 |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | MktFcst.tsx:393 (dataMap) · components/MktFcstGrid.tsx:301 · utils/mkt-fcst.gridCombos.ts:3 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | components/MktFcstForm.tsx:182,187 (join/split ',') · utils/mkt-fcst.gridCombos.ts:531 |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/MktFcstGrid.tsx:1658 `rebindFilterColumns` (updatedLayout 핸들러 0-c) |  | 구현 |

## §0. 커버리지 요약 (4축)

| 축 | AS-IS 건수 | 적용(직접) | inline/대체 | 미구현(사유 명시) | 커버 |
|---|---:|---:|---:|---:|---:|
| Validation | **152** | 22 | 121 (division 분기 → division.ts + editLock matrix) | 9 (Excel/legacy/Find 내부) | **152/152** |
| Expressions | **130** | 125 | 0 | 5 (AS_FROM_SITE 조건부 잠금 = 콤보/BE 의존) | **130/130 분류** |
| Events | **26** | 24 | 2 (EditChange/ClipboardPasted = Wijmo cellEditEnding/pastedCell) | 0 | **26/26** |
| Popup | **8** | 8 | 0 | 0 | **8/8** |

> "적용(직접)" = To-Be 코드에 1:1 함수/가드 존재. "inline/대체" = 사업부분기(division.ts) 또는 편집 matrix(editLock.ts) 로 흡수된 항목. "미구현" = 사유 명시(아래 각 축).

---

## §1. Validation 축 — 152건 전수

### 1.1 카테고리 분포 (validation.md)

| 카테고리 | 건수 | To-Be 처리 위치 |
|---|---:|---|
| 사업부분기(40/81/82) | 113 | `utils/mkt-fcst.division.ts` (키/필수/중복키/SspSync/PlantSite 분기) |
| 기타(사전검증분기) | 25 | `validate.ts` 가드 + `editLock.ts` cutoff + Excel(미구현) |
| 필수값 | 4 | `validate.ts` validateSaveRows (REQUIRED division 분기) |
| 중복체크 | 3 | `validate.ts` (buildDuplicateKey) + `prContext.ts` (Model dup) |
| 날짜기간 | 2 | `validate.ts` validateFind (역전/3년) |
| 확인메시지 | 2 | `MktFcst.tsx` handleSave setAlert confirm |
| 모드분기 | 1 | `validate.ts` validateEditMode |
| 숫자값검증 | 1 | `recalc.ts` recalcMonthlyToDaily belowActual(MSG00225) |
| Grid입력 | 1 | `MktFcstGrid.tsx` cellEditEnding(EditChange) |

### 1.2 GMessageBox / 직접 메시지 — MSG/LBL ID 정밀 매핑 (2026-06-28 사내 SCM_ADM_MSG_M 정합 재채번)

> ⚠️ **GSCM-era MSG ID 재채번**: AS-IS 의 `GMessageBox("MSG####")` ID 는 NSCM 사내 메시지 마스터와
> **의미가 일치하지 않는다**(사내 실측: MSG00002='성공적으로 저장되었습니다.', MSG00004='저장하시겠습니까?' 만 일치).
> 따라서 AS-IS 한글 원문을 사내 텍스트 매칭(READ)한 결과 **MSG00004 1건만 재사용**, 나머지는 전부 사내 미존재 →
> 정식 채번(MSG00631+ / LBL00679+, gap 포함). 등록 handoff = `_artifacts/_apply_corporate/40_dmf0003_i18n_register.py`.

| va# | .cs Line | AS-IS 한글 원문 | 사내 정합 ID | FE 키 | 조치 | To-Be 위치 | 상태 |
|---:|---:|---|---|---|---|---|:--:|
| 10/12/14 | L802/814/826 | 복사할 데이터를 선택하세요. | **MSG00637** | SELECT_COPY_ROW | 신규 | `validate.ts` validateCopyTarget | ✅ |
| 15 | L847 | 조회 후 수정모드로 가능합니다. | **MSG00641** | EDIT_AFTER_SEARCH | 신규 | `validate.ts` validateEditMode | ✅ |
| 30 | L1213 | Division 을 선택하세요. | **MSG00635** | REQUIRE_DIVISION | 신규 | `validate.ts` validateFind | ✅ |
| 31 | L1224 | (기간 역전) | **MSG00636** | PERIOD_INVERTED | 신규 | `validate.ts` validateFind | ✅ |
| 32 | L1230 | (기간 3년 초과) | **MSG00638** | PERIOD_MAX_3YEAR | 신규 | `validate.ts` validateFind | ✅ |
| 36 | L1493 | 저장시 중복 오류가 발생하였습니다.{0} | **MSG00633** | DUPLICATE | 신규 | `validate.ts` validateSaveRows (dup) | ✅ |
| 37/43 | L1499/L1660 | MKT FCST 수량이 입력된 일자가 없습니다. | **MSG00632** | NO_QTY_INPUT | 신규 | `validate.ts` validateSaveRows hasAnyDailyInput | ✅ |
| 40 | L1569 | AS From-Site 를 ALL 로 저장 불가 | **MSG00643** | AS_SITE_ALL | 신규 | `validate.ts` validateSaveRows AS+ALL | ✅ |
| 41/42 | L1621/L1636 | 저장하시겠습니까? (AS-IS '수정한 내용을~') | **MSG00004** | CONFIRM_SAVE | **재사용**(정확일치) | `MktFcst.tsx` handleSave confirm | ✅ |
| 73 | L3388 | (FcstType 코드 invalid) | **MSG00644** | FCST_TYPE_INVALID | 신규 | constants.MSG.FCST_TYPE_INVALID (콤보 dataMap 단계) | ⚠️ 콤보의존 |
| 95 | L3253 | 신규 입력 데이터 중 중복된 데이터가 있습니다. | **MSG00642** | DUPLICATE_INPUT | 신규 | `validate.ts` (buildDuplicateKey 동일 경로) | ✅ |
| 101 | L3844 | 실적 수량보다 작은 숫자를 넣을 수 없습니다. | **MSG00639** | BELOW_ACTUAL | 신규 | `recalc.ts` recalcMonthlyToDaily belowActual | ✅ |
| 106 | L4335 | [{0}] 은 필수 입력사항입니다. | **MSG00631** | REQUIRED_FIELD | 신규(오매핑 MSG00002 교정) | `validate.ts` validateSaveRows REQUIRED {0} | ✅ |
| — | (숫자값) | 0 보다 큰 수를 입력하세요. | **MSG00634** | POSITIVE_QTY | 신규 | (숫자 입력 가드) | ✅ |
| — | (Period 누락) | 조회 기간을 입력하세요. | **MSG00645** | REQUIRED_PERIOD | 신규(필수값과 분리) | `validate.ts` validateFind | ✅ |
| — | (저장대상 0) | 저장할 데이터가 없습니다. | **MSG00646** | NO_SAVE_DATA | 신규 | `validate.ts` validateSaveRows | ✅ |
| 111 | L4412 | YYYYMMDD형식이 맞지 않습니다. | (구조보장) | — | — | `save.ts` unfoldCell (D_ 셀만 8자리) | ➖ |
| 130 | L5401 | (Insert 행 Bucket 변경 불가) | **MSG00640** | INSERT_ONLY_BUCKET | 신규 | `validate.ts` validateBucketChange | ✅ |
| 138 | L5519 | 선택된 셀이 없습니다. | **LBL00709** | (prContext msgKey) | 신규 | `prContext.ts` + `MktFcstGrid.tsx` | ✅ |
| 140 | L5594 | 실적 구간이 포함되어 있습니다. | **LBL00703** | (prContext msgKey) | 신규 | `prContext.ts` buildRequestPr | ✅ |
| 141/150 | L5620/L5713 | 일자컬럼에서만 사용가능합니다. | **LBL00702** | (prContext msgKey) | 신규 | `prContext.ts` | ✅ |
| 144 | L5638 | Request 할 내용이 없습니다. | **LBL00704** | (prContext msgKey) | 신규 | `prContext.ts` buildRequestPr | ✅ |
| 145 | L5644 | Model 은 중복될 수 없습니다. | **LBL00705** | (prContext msgKey) | 신규 | `prContext.ts` buildRequestPr | ✅ |
| 146 | L5652 | Project 는 동일해야 합니다. | **LBL00706** | (prContext msgKey) | 신규 | `prContext.ts` buildRequestPr | ✅ |
| 148 | L5699 | 한 개의 셀만 선택할 수 있습니다. | **LBL00707** | (prContext msgKey) | 신규 | `prContext.ts` buildSingleCell | ✅ |
| 149 | L5706 | BNP In 메저행에서만 사용가능합니다. | **LBL00708** | (prContext msgKey) | 신규 | `prContext.ts` buildSingleCell | ✅ |
| 8 | L… | MSG00448 (편집가능 division — 미등록) | (BE 메타 의존) | — | — | (DM_UI_EDITABLE_DIVISION) | ⚠️ BE의존 |
| 28 | L1586 | MSG00003 (Excel 관련 — 미등록) | (공통) | — | — | SubTitle excel DefaultButtonActions | ➖ 공통 |

> **모달/이력/저장 MSG (tsx/modals)**: PR 발행 확인=**MSG00649**, PR 발행됨=**MSG00650**, PR 발행실패=**MSG00651**,
> 이력없음=**MSG00652**, MasterChange SP대기=**MSG00653**, 저장됨=**MSG00606**(공용 재사용), 저장오류=**MSG00618**(공용 재사용).
> **2026-06-28 재채번 결정**: 구 scaffold 의 GSCM MSG ID(MSG00002/00034/00043/…)·임의 LBL01900~01917 은 사내 미존재로
> 폐기, AS-IS 원문 텍스트 매칭 후 사내 max+1 정식 채번으로 교체. `MSG00004`(저장 확인) 만 정확 일치 재사용.
> 컬럼 라벨 재사용(정확 일치): SalesSite=LBL00011 / PlantSite=LBL00005 / EndCustomer=LBL00080 / Incoterms=LBL00024 /
> Measure=LBL00310 / Owner=LBL00082 / ItemType=LBL00068 / SenderCode=LBL00090 / Team=LBL00044 / Period=LBL00013 /
> Bucket=LBL00032 / Model=LBL00669(공용). 라벨 신규: FCST Type=LBL00679 / Customs Handbook=LBL00680 / Daily~Cell Qty=LBL00682~00691.

### 1.3 사업부분기 113건 — division.ts 1:1

| AS-IS 분기 패턴 (va# 다수) | .cs 근거 | To-Be |
|---|---|---|
| `Substring(0,2)=="81"` / `=="82"` / else(40) | 전반 | `divisionKindOf()` (D81/D82/D40) |
| 키 컬럼 40=Customer40/ScmSiteId40/ItemId40 vs 81·82=Project/ScmSiteId/ItemId | L4861~4881 / L1509~1522 | `divisionKeyColumns()` / `readIdentity()` |
| PlantSite 필수(81만) | L4365 / L5227 | `requiresPlantSite()` |
| 중복키 81=+PlantSite / 82=제외 / 40=Customer40계열 | L4892~4956 | `buildDuplicateKey()` |
| SspSync(40 & MKT_FCST_RP) | L1610 / L2628 | `isSspSyncTarget()` + grid CellDblClick |
| VMI_YN/STD_DIO 표시(82만) | 보강 §6 / L3056 | 컬럼 `_divisionAllow`(ATTRIBUTE3 토큰, hook #92) |
| 8주 잠금(40 Monthly) | L974~981 | `editLock.evalDynCell` div40MonthCutoff |

### 1.4 미구현 9건 (사유 명시 — 은폐 금지)

| va# | 항목 | 사유 |
|---:|---|---|
| 8 | MSG00448 사업부 편집권(DM_UI_EDITABLE_DIVISION) | BE 메타(편집가능 division 테이블) 의존 — SP/메타 적재 후 (handoff). |
| 26/27/28 | ExportExcel 사전검증(myarray/FrozenColumnCount)+MSG00003 | Excel 내보내기 = SubTitle DefaultButtonActions 공통 처리(화면별 검증 불필요). |
| 34 | FindData data_start_pos<0 | 조회 응답 파싱 내부 가드 — SP O_RC1 구조가 보장(컬럼 메타 기반). |
| 73 | MSG00472 FcstType 코드 검증 | 콤보 dataMap(useTabComboQueries) 가 유효 코드만 노출 → 입력 단계 차단. MSG 키만 등록. |
| 99/122 | iWeeklySum<iWkSum_Sync / iValidation>1 (내부 분기) | `recalc.ts`/`validate.ts` 내부 로직으로 흡수(별도 사용자 메시지 없음). |
| 111 | YYYYMMDD 형식 | `save.ts` 가 D_ 셀(8자리)만 unfold → 구조적으로 형식 보장. |

---

## §2. Expressions 축 — 130건 cross-check (2a~2d editLock/recalc)

### 2.1 분류별 반영

| 분류 | 건수 | To-Be 위치 | 상태 |
|---|---:|---|:--:|
| SUM헤더 (#1~5) | 5 | `MktFcstGrid.tsx` mainDynamicColumns (2단 nested 'SUM' 그룹) | ✅ |
| 행잠금: 좌측 상세컬럼 read-only (#8~27, #34~70) | ~57 | 컬럼 메타 `_inputEditType='S'` + beginningEdit(non-insert cancel) | ✅ |
| 행잠금: bucket×past 셀 잠금 (#28~33, #71~87) | ~23 | `editLock.ts` evalDynCell (Daily/Weekly/Monthly + Div40 8주) | ✅ |
| 행잠금: AS_FROM_SITE 조건부 (#90~95, #128~130) | 9 | `MktFcstGrid.tsx` beginningEdit — W/S Planner + FCST_TYPE∈W/S 4종(FcstTypeWs)일 때만 편집 허용, 그 외 cancel (2026-07-20 E20260402 반영과 함께 해소) | ✅ |
| 합계변수: iWeeklySum/iMonthlySum (#96~127, 일↔주↔월) | 32 | `recalc.ts` recalcDailyToWeekMonth / recalcWeeklyToDaily / recalcMonthlyToDaily | ✅ |

### 2.2 합계변수 32건 → recalc.ts 1:1 (핵심)

| 합계 변수 | .cs Line | recalc.ts 함수 |
|---|---|---|
| iWeeklySum 누적/세팅 (#96/97/122/125) | L4245/4251/4973/5007 | recalcDailyToWeekMonth (weeklySum 루프) |
| iMonthlySum 누적/세팅 (#98/99/112/127) | L4270/4275/4635/5034 | recalcDailyToWeekMonth (monthlySum 루프) |
| iWkSum_Sync 강제상향 (#102/105/106) | L4321/4376/4378 | recalcWeeklyToDaily (wkSumSync / forceWeeklyValue) |
| iDailyQty/iRemnant 분배 (#103/104/107/108/110) | L4367/4368/4379/4380/4385 | recalcWeeklyToDaily (dailyQty/remnant) |
| iLastWeeklySum 과거합 (#115/116/117) | L4676/4709/4711 | recalcMonthlyToDaily (lastWeeklySum / belowActual) |
| iMonthlySum-iLastWeeklySum 분배 (#118/119) | L4718/4719 | recalcMonthlyToDaily (monthlySum-lastWeeklySum) |

### 2.3 Expressions 누락 보완분 (이번 Phase 2f)

> 2a~2d(editLock/recalc) 대조 결과 **합계 32 + bucket 잠금 23 + SUM헤더 5 + 좌측 read-only 57 = 117 은 이미 반영**.
> **잔여 13 중**:
> - **AS_FROM_SITE 조건부 잠금 9건(#90~95, #128~130)**: ✅ **2026-07-20 해소** — `MktFcstGrid.tsx` beginningEdit 에 AS_FROM_SITE 분기 신설: W/S Planner(store wsPlannerYn) 이고 행 FCST_TYPE 이 W/S 4종(CMBO 'FcstTypeWs'=SALES_TYPE_CODE2)일 때만 편집, 그 외 cancel. 컬럼 자체는 GET_SPREAD_TITLE p_type='LOAD'(첫 진입/Division 변경) 분기가 자동추가(E20260402 — standalone SP 기구현 실측).
> - **InsertRow 상세컬럼 잠금 일부(#46~67 의 CUST_GROUP/APPLICATION/ROUTE 등)**: To-Be 컬럼 메타에 미정의(동적 staticColumns 미적재) → admin SCM_MST_SHEET_COLUMNS 적재 시 `_inputEditType='S'` 로 자동 잠금. fallback MAIN_COLUMNS 에는 핵심 10 컬럼만 → 나머지는 메타 적재 의존(은폐 아님, 메타 주도).

---

## §3. Events 축 — 26건

| # | AS-IS Handler | .cs Line | To-Be 위치 | 상태 |
|---:|---|---:|---|:--:|
| 1 | Form_Load | L312 | `MktFcst.tsx` useEffect mount | ✅ |
| 2 | OnShown | L334 | (Div82 분기 = division.ts) | ✅ |
| 3 | InitControls | L429~540 | column meta + division.ts | ✅ |
| 4 | EditButton (F2) | L795~ | `validate.ts` validateCopyTarget/validateEditMode | ✅ |
| 5 | ExportExcel | L1357~1586 | SubTitle excel (DefaultButtonActions) | ➖ 공통 |
| 6 | FindData (F5) | L1207~ | `MktFcst.tsx` handleSearch + validateFind | ✅ |
| 7 | SaveData (F7) | L1464~1664 | `MktFcst.tsx` handleSave + validateSaveRows | ✅ |
| 8 | InsertRow (F8) | L2389~ | `MktFcst.tsx` handleInsert | ✅ |
| 9 | cboDivision_SelectedIndexChanged | L2861~ | `MktFcstForm.tsx` division change + division.ts | ✅ |
| 10 | clbTeam_SelectedIndexChanged | L2981 | `MktFcstForm.tsx` cascade combo | ✅ |
| 11 | clbCustomer_SelectedIndexChanged | L3016 | `MktFcstForm.tsx` cascade combo | ✅ |
| 12 | spdMain_ComboSelChange | L3107~ | `MktFcstGrid.tsx` combo dataMap | ✅ |
| 13 | spdMain_CellDoubleClick | L3513 / L2628 | `MktFcstGrid.tsx` dblclickHandler (popup + SSP compare) | ✅ |
| 14 | spdMain_Changed | L3798~5141 | `MktFcstGrid.tsx` cellEditEnded → dispatchRecalc | ✅ |
| 15 | ValidationCheck | L4332 | `validate.ts` (필수/형식 가드) | ✅ |
| 16 | fnValidation | L4829 | `validate.ts` validateSaveRows (필수/중복/수량) | ✅ |
| 17 | cboBucketType_Click | L… | `validate.ts` validateBucketChange | ✅ |
| 18 | spdMain_EditChange | L5407 | `MktFcstGrid.tsx` cellEditEnding (pasteContinue) | ✅ inline |
| 19 | spdMain_ClipboardPasted | L5416 | `MktFcstGrid.tsx` pastedCell (combo 재설정) | ✅ inline |
| 20 | spdMain_CellClick | L6405 | `MktFcstGrid.tsx` (PlantSite/82 분기) | ✅ |
| 21 | contextMenuStrip1_ItemClicked | L5510~5753 | `MktFcstGrid.tsx` contextMenuHandler + `prContext.ts` | ✅ |
| 22 | cboAS_CheckedChanged | L6871 | `MktFcstForm.tsx` AS 체크 + handleSave asFromSite | ✅ |
| 23 | btnIncotermsChg | L5359 | ❌ 기능 삭제 (2026-07-13 사용자 결정 — Master Change 버튼·기능 전체 제거, 미이관 확정) | ➖ |
| 24 | btnOwner | L5374 | `MktFcst.tsx` OwnerByDivisionModal | ✅ |
| 25 | btnProject | L… | `MktFcst.tsx` ProjectByDivisionModal | ✅ |
| 26 | btnItemId | L… | `MktFcst.tsx` ItemByDivisionModal | ✅ |

---

## §4. Popup 축 — 8건

| # | AS-IS Popup | 트리거(.cs) | To-Be Modal | 상태 |
|---:|---|---|---|:--:|
| 1 | DM0002_TitleSetForm (컬럼/Measure) | btnColumn/btnMeasure | (공용 ColumnLayoutModal 연동 완료) | ⚠️ wire |
| 2 | SCM0002_ProjectbyDivision | CellDblClick/btnProject | `ProjectByDivisionModal` | ✅ |
| 3 | DM0002_ItembyDivision | CellDblClick/btnItemId | `ItemByDivisionModal` | ✅ |
| 4 | DM0020_OwnerbyDivision | btnOwner | `OwnerByDivisionModal` | ✅ |
| 5 | DMF0003_MatsterChgPopup | btnIncotermsChg L5359 | ❌ 기능 삭제 (2026-07-13 사용자 결정 — 모달/버튼/메타 전체 제거) | ➖ |
| 6 | DMF0003_PRPopup / PRHistoryPopup | contextMenu Request/View/History | `PrModal` / `PrHistoryModal` + `prContext.ts` | ✅ |
| 7 | DMF0003_SspSyncComparePopUp | CellDblClick(Div40&MKT_FCST_RP&동기화색) L2628 | `SspSyncCompareModal` | ✅ |
| 8 | DMF0003_SspSyncPopUp | SaveData 응답 L1610 | `SspSyncResultModal` | ✅ |

> ColumnSetting(#1) 은 컬럼 가시/Measure 동적 fetch(`fetchStaticColumns`/`fetchStaticMeasures`)로 baseline 확보, 사용자 popup wire-up 은 공용 ColumnLayoutModal 연동 완료 — `MktFcst.tsx` applyColumnVisibility 준비 완료.

---

## §5. 변경/신규 파일 (Phase 2f)

| 파일 | 종류 | 내용 |
|---|---|---|
| `utils/mkt-fcst.division.ts` | 신규 | Division 40/81/82 분기 단일원 (키/필수/중복키/SspSync/PlantSite) |
| `utils/mkt-fcst.validate.ts` | 신규 | useMktFcstValidation (find/saveRows/bucketChange/copyTarget/editMode) |
| `mkt-fcst.constants.ts` | 수정 | MSG 객체 사내 정합 재채번(MSG00631~00646 + CONFIRM_SAVE=MSG00004 재사용) |
| `utils/mkt-fcst.division.ts` | 수정 | 컬럼 라벨 LBL 정합(재사용 + FCST Type=LBL00679/Customs Handbook=LBL00680 신규) |
| `components/MktFcstForm.tsx` | 수정 | 조회조건 라벨 재채번(Daily~Cell Qty=LBL00682~00691, Owner/ItemType 등 정확일치 재사용) |
| `utils/mkt-fcst.prContext.ts` | 수정 | contextMenu 임시 LBL01910~01917 → 정식 LBL00702~00709 |
| `components/MktFcstGrid.tsx` | 수정 | "선택 셀 없음" LBL01917 → LBL00709 |
| `components/modals/{PrModal,PrHistoryModal,SspSync*}.tsx` | 수정 | 모달 헤더 LBL01900~01907 → LBL00694~00700 / PR·이력 MSG → MSG00649~00652 (MasterChgModal 은 2026-07-13 기능 전체 삭제 — LBL00701/MSG00653 dead meta 정리) |
| `MktFcst.tsx` | 수정 | 저장/삭제 MSG·LBL 공용 ID 정합(MSG00606/00618, LBL00665/00666 재사용) |
| `public/locales/{KO,EN,CN}.json` | 수정 | 신규 49 키 등록 + 공용 5 키 + 임의 LBL019xx 제거 |
| `_artifacts/_apply_corporate/40_dmf0003_i18n_register.py` | 신규 | 사내 SCM_ADM_MSG_M 멱등 등록 handoff(신규 49 + 공용 5 = 54키 × 3 lang = 162행, dry-run 기본) |
| `__asis-mapping__.md` | 수정 | 본 문서(2026-06-28 사내 정합 재채번 반영) |

> BE(Java)/SP/foundation/shared/lges/타화면 코드 **무변경**. i18n t()/상대경로/console/any/inline/직접fetch **0**.
> 사내 DB **쓰기 0**(handoff dry-run 검증만 — 적용은 작성자 검토 후 `--apply`).

---

# PSI 고객수요분석 영역 — **범위 제외** (사용자 확정 2026-08-15)

> ⛔ 이 영역의 원천은 `DMF0003_1_MktFcst.cs` 이고 **메뉴 `DMF0003_1` 소속**이다.
> 본 대사표의 대상은 **`DMF0003` 본화면**이므로 PSI/Car/CustDemand 영역은 **대사·게이트 대상이 아니다**.
>
> 근거: `SCM_ADM_MNU_M` 에 `DMF0003` 과 `DMF0003_1` 이 별도 등재. 2026-07-03 정본 전환 시
> "`DMF0003_1_MktFcst` 전용으로 확인 → 화면에서 제거" 로 이미 판정된 영역이다.
> 구현·DB 등재분은 `_artifacts/_deploy_packages/DMF0003_PSI_20260703/` 에 보존되어 있다.
>
> (제외 처리로 걷어낸 원문 3,251자 — 이력은 git 에 남는다)

---

## 2026-07-03 (오후) — 평문 AS-IS 정합 + PR 4기능 복구 (사용자 지시 8건)

- **정본 변경**: 원천 = 평문 `DMF0003_MktFcst.cs` (사용자 실행 AS-IS). 상단 PSI/Car/CustDemand 는 별개 변형
  `DMF0003_1_MktFcst` 전용으로 확인 → **화면에서 제거** (구현·DB 등록분은 `_deploy_packages/DMF0003_PSI_20260703/` 보존).
- **Color 체크박스 제거**: AS-IS chkColor 는 실행 UI 미표시·초기 false → false 경로 고정
  (과거 Gray 없음 + 현재 W_/M_ 헤더 초록 Bold — .cs L5654~5687 1:1).
- **우클릭 PR 4기능**: PROC_M/API_M 0행 + SP 결함 4건(대소문자 'Add_History'/'View_History'·커서 미오픈·
  ORA-22950·SAVE INVALID) 복구 + FE 격차 8건 교정 — 카운트 대사: AS-IS 검증 11종(V1~V7+S1~S3+Div40) = TO-BE 11종 ✅,
  메뉴 4항목·모달 2종·헤더 필드(4+5)·행클릭 PR_HEADER ✅. 상세 = `_deploy_packages/DMF0003_PR_20260703/README.md`.
- **그리드 콤보**: UI Category 메타(cellCboDataTp) 기반 + cascade(hook #59 §5-G) + Model 셀 아이콘(DMF0020 동일)
  + Model 선택 시 ITEM_NAME/NICK_NAME 자동입력(메타 'S' 전환).
- FcstType/CustomsHandbook 콤보 SQL = AS-IS 정본(param-less)으로 교체 — BE makeComboQuery 가 파라미터 콤보를
  치환하지 못하는 구조 실측(hook 이관: 파라미터 콤보 등록 금지).

## 의도적 편차 — 컬럼 고정(freeze) 메타 위임 (2026-07-04 사용자 지시)

AS-IS `Freeze(0, MEASURE 인덱스+1)` (좌측 식별 컬럼 블록 하드코드 고정, FIXED_FLAG 미참조)은
**재현하지 않음**. `MktFcstGrid.mainStaticColumns` 의 `fixed: true` 리터럴을 `fixed: c.fixed`
(admin `SCM_MST_SHEET_COLUMNS.FIXED_FLAG` 위임)로 전환 — hook `ui-category-setup-column-meta` §12
(관리 속성 "속성 단위" 하드코딩 금지, DMF0048 FIX 사고 후속 일괄 조치).
사내 메타 실측: DMF0003 'Mkt Fcst' 67행 전행 FIXED_FLAG 공란 = 현재 고정 0.
고정이 필요하면 admin SYS0004 에서 FIXED_FLAG='Y' 등록 (화면 수정 불요).

---

## §7. AS-IS 최신 반영분 (2026-07-20 — 이관 baseline 이후 결재 2건, UI분석서 v2.2 시트10 계보)

> 원천: GSCM_20260512 ↔ GSCM diff 265줄 정독(.cs 6,944→7,143) + 사내 DB 실측. 상세 = work_reports/2026-07-20_DMF0003_asis_latest_reflect.md

### [E20260402-001736] AS 관련 기능 개선 (2026-04-27)

| # | AS-IS (.cs 최신 라인) | To-Be | 상태 |
|---:|---|---|:--:|
| 1 | Measure 편집 제한 — 비W/S: Form_Load(L313~329) MKT_FCST_RP 화이트리스트 / InsertRow(L2675~2691) AS_In_Req 제거 / ComboSelChange(L3465~3497) AS사이트=AS_In_Req만·고객향=MKT_FCST_RP만 | `MktFcstGrid.tsx` beginningEdit MEASURE 후보 필터(사이트 확정=단일 measure / 미정+비W/S 81*/82=AS_In_Req 제거) | ✅ |
| 2 | InitSpread(sType) 5곳 — CreateSpread·Division변경='LOAD' / 조회·컬럼/메저팝업='' (L615~5777) + GET_SPREAD_TITLE p_user_group·p_type (L6336~6355) | `useMktFcstStore` spreadTitleLoadPending → filters type 'LOAD'/'COLUMN' (SP·PROC_M 은 기구현 실측 — standalone 6 IN VALID) | ✅ |
| 3 | AS FROM SITE 필수 — MSG00113(EditButton L876~888, DM Planner/W-S/DM ADMIN+81*/82 컬럼부재) / MSG00476(SaveData L2300~2329, W/S+고객향+FcstType W/S 4종+빈값) | `MktFcst.tsx` guardEditGates(3) + handleSave MSG00476 검사(insertedRows) | ✅ |
| 4 | FCST_TYPE 편집 콤보 분기(L2587~2605) — W/S=EDIT_MODE 6종 / 그 외 GetFcstType 12종 | `GRID_EDIT_COMBO.FCST_TYPE{wsOnly}` + CMBO 'FcstTypeEditMode'(SALES_TYPE_CODE2∪_ADD) | ✅ |
| 5 | Sales Site 재로드 GetSalesSite (L2653~2656/L3103~3111) | 기존 콤보 레지스트리(division 반응형) 유사 반영 — cross-check 완료 | ✅ |
| 6 | 공통 콤보 PARAM5 W/S 플래그 — GetSalesSite40(L7047~7066) 'Y'/'N' | 기존 'MktFcstWsPlannerYn' 계보 콤보가 W/S 반영 — 사이트40 콤보 파라미터는 콤보 SQL 위임 | △(콤보 SQL 확인 항목) |

### [E20260604-000994] SCM FCST 기준수요 (2026-06-08)

| # | AS-IS | To-Be | 상태 |
|---:|---|---|:--:|
| 7 | SCP Planner 차단 — Edit 82·40(L828~834) / Insert 81(L2531~2537) MSG00096 | `editable` 3단 AND(!scpEditBlocked) + handleInsert/handleSave MSG00096 | ✅ |
| 8 | SCP 시간창(81) — LOOKUP SCP_PLANNER_EDIT_FLAG 행 0=차단 MSG00477 (L848~860) | guardEditGates(1) + CMBO 'Dmf0003ScpPlannerEditFlag' (⚠ lookup 데이터 0행 — 운영값 협의 대기, 0행=AS-IS 보수 동작 그대로 차단) | ✅(구조) |
| 9 | DM류 시간창 — LOOKUP DM_PLANNER_EDIT_FLAG 행 존재=차단 MSG00478 5파라미터 (L862~874, ⚠ 괄호 원본결함: 81 제한이 DM ADMIN 에만 결합 — 원문 파리티 이식) | guardEditGates(2) + CMBO 'Dmf0003DmPlannerEditFlag' (^연결 5값. 데이터 0행=통과) | ✅(구조) |
| 10 | SAVE p_authority 16번째 (L2421~2441) | SP P_AUTHORITY(DEFAULT NULL)+PROC_M authority 16+`buildSavePayload` authority — 사내 VALID 검증. ⚠ SP 내 저장 시간창 게이트 본문(AS-IS L597~686)은 MSSQL 원문 미확보로 후속(수신만) | ✅(부분) |

### 그룹 판정 방식 (TO-BE 편차 — 명시)

AS-IS `NowGroupID`(로그인 시 선택한 단일 그룹) ↔ TO-BE 는 그룹 선택 개념 부재 → CMBO 'MktFcstUserGroups'(USER_GR_MPG_M @sesUserId) **membership** 판정 + 대표 DM류 그룹 우선순위(W/S > DM Planner > DM ADMIN). 겸직 사용자는 게이트 중복 적용 가능 — 사내 실측(2026-07-20) SCP Planner 소속자 0명(신설 그룹, 배정 전)으로 현재 리스크 없음. 배정 시 협의 항목.

## AS-IS 이벤트 핸들러 인벤토리 (2026-08-08 축 — 분석서가 놓친 핸들러 차단)

> 원천: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0003_MktFcst\DMF0003_MktFcst.cs` — `.cs` 에서 **기계 추출**한 UI 이벤트 핸들러 33개.
> 대사표의 E번호는 **분석 md** 기준이라 분석서가 누락한 핸들러를 못 잡는다. 이 축이 그 구멍을 막는다.
> 사문(빈 몸통) 핸들러는 **미이관이 파리티** — 상태 '제외' + 사유 기재로 통과시킨다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| HANDLER:DeleteButton | AS-IS `DMF0003_MktFcst.cs:816` (라이브 6행) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:503 (handleDelete) |  | 구현 |
| HANDLER:EditButton | AS-IS `DMF0003_MktFcst.cs:824` (라이브 358행) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:429 (guardEditGates) + Grid beginningEdit/editCutoff |  | 구현 |
| HANDLER:ExcelButton | AS-IS `DMF0003_MktFcst.cs:1346` (라이브 25행) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:775 (DataGrid excel) |  | 구현 |
| HANDLER:FindButton | AS-IS `DMF0003_MktFcst.cs:805` (라이브 3행) · **사문(빈 몸통)** |  | 사문 래퍼(3행 — FindData 위임). TO-BE handleSearch 직접 담당 | 제외 |
| HANDLER:FindData | AS-IS `DMF0003_MktFcst.cs:1673` (라이브 80행) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:412 + useMktFcstStore.ts:260~300 |  | 구현 |
| HANDLER:Form_Load | AS-IS `DMF0003_MktFcst.cs:302` (라이브 23행) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:99~120 (초기화 useEffect) |  | 구현 |
| HANDLER:InsertButton | AS-IS `DMF0003_MktFcst.cs:811` (라이브 3행) · **사문(빈 몸통)** |  | 사문 래퍼(3행 — InsertRow 위임) | 제외 |
| HANDLER:InsertRow | AS-IS `DMF0003_MktFcst.cs:2529` (라이브 55행) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:472 (handleInsert) |  | 구현 |
| HANDLER:OnShown | AS-IS `DMF0003_MktFcst.cs:332` (라이브 12행) | features/demand/src/pages/mkt-fcst/useMktFcstStore.ts (initSearch — 82 Daily/그 외 Weekly 기본 버킷) |  | 구현 |
| HANDLER:SaveButton | AS-IS `DMF0003_MktFcst.cs:1340` (라이브 3행) · **사문(빈 몸통)** |  | 사문 래퍼(3행 — SaveData 위임) | 제외 |
| HANDLER:SaveData | AS-IS `DMF0003_MktFcst.cs:2220` (라이브 199행) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:519~660 + utils/mkt-fcst.save.ts |  | 구현 |
| HANDLER:btnColumn_Click | AS-IS `DMF0003_MktFcst.cs:5749` (라이브 10행) | features/demand/src/pages/mkt-fcst/MktFcst.tsx:901~ (공용 ColumnLayoutModal) |  | 구현 |
| HANDLER:btnIncotermsChg_Click | AS-IS `DMF0003_MktFcst.cs:6434` (라이브 11행) |  | Master Change — AS-IS 최종 숨김(E20260323) + 사용자 결정(2026-07-13 MasterChgModal 제거 — modals/index.ts 주석) | 제외 |
| HANDLER:btnItemId_Click | AS-IS `DMF0003_MktFcst.cs:5725` (라이브 17행) | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx (Model 조회조건 — 표준 검색 필드) |  | 구현 |
| HANDLER:btnMeasure_Click | AS-IS `DMF0003_MktFcst.cs:5765` (라이브 10행) | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx (공용 정본 — MktFcst.tsx 배선) |  | 구현 |
| HANDLER:btnOwner_Click | AS-IS `DMF0003_MktFcst.cs:6449` (라이브 14행) | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx (Owner 조회조건) |  | 구현 |
| HANDLER:btnProject_Click | AS-IS `DMF0003_MktFcst.cs:5702` (라이브 17행) | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx (Project 조회조건 — ProjectByDivisionModal) |  | 구현 |
| HANDLER:cboAS_CheckedChanged | AS-IS `DMF0003_MktFcst.cs:7068` (라이브 11행) |  | 사문 — E20260211 로 cboAS 숨김(lciASCheck.ContentVisible=false). W/S 그룹 자동 판정 대체(store wsPlannerYn) | 제외 |
| HANDLER:cboBucketType_Click | AS-IS `DMF0003_MktFcst.cs:6470` (라이브 10행) | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx:255~275 (MSG00227 가드) |  | 구현 |
| HANDLER:cboBucketType_SelectedIndexChanged | AS-IS `DMF0003_MktFcst.cs:3217` (라이브 49행) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx (bucketPrefix 표시 규칙 — summaryBindings/drillBindings) |  | 구현 |
| HANDLER:cboDivision_SelectedIndexChanged | AS-IS `DMF0003_MktFcst.cs:3019` (라이브 30행) | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx (division 변경 cascade) + useMktFcstStore.ts:241 (spreadTitleType LOAD) |  | 구현 |
| HANDLER:chkColor_CheckedChanged | AS-IS `DMF0003_MktFcst.cs:5628` (라이브 6행) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx (formatItem 색 규칙 상시 적용) | AS-IS chkColor 토글 = 색 모드 전환 — TO-BE 단일 표준(과거 Gainsboro+당주 초록 상시) | 구현 |
| HANDLER:chkSum_CheckedChanged | AS-IS `DMF0003_MktFcst.cs:5781` (라이브 6행) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:71 (Sum 체크박스 — sumYn 토글) |  | 구현 |
| HANDLER:clbCustomer_SelectedIndexChanged | AS-IS `DMF0003_MktFcst.cs:3204` (라이브 11행) | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx (EndCustomer→SalesSite cascade) |  | 구현 |
| HANDLER:clbTeam_SelectedIndexChanged | AS-IS `DMF0003_MktFcst.cs:3166` (라이브 18행) | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx (Team→EndCustomer→SalesSite cascade) |  | 구현 |
| HANDLER:spdMain_CellClick | AS-IS `DMF0003_MktFcst.cs:6596` (라이브 74행) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx (Measure 편집 진입 스왑 — beginningEdit 통합) | AS-IS CellClick 의 PlantSite 행별 재조회는 CD-10 갭에서 추적 | 구현 |
| HANDLER:spdMain_CellDoubleClick | AS-IS `DMF0003_MktFcst.cs:3604` (라이브 255행) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:977~1050 (헤더 드릴다운+팝업+SSP 비교) |  | 구현 |
| HANDLER:spdMain_Changed | AS-IS `DMF0003_MktFcst.cs:3944` (라이브 920행) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:855~955 (cellEditEnded→runDynRecalc) | 잔여 갭 CG-05(키변경 수량 클리어) 별도 추적 | 구현 |
| HANDLER:spdMain_ClipboardPasted | AS-IS `DMF0003_MktFcst.cs:6491` (라이브 81행) | Wijmo pastedCell 공통 + cascade 재적용 | AS 3축 paste 재적용은 CE-04 갭에서 추적 | 구현 |
| HANDLER:spdMain_ComboSelChange | AS-IS `DMF0003_MktFcst.cs:3291` (라이브 248행) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:723~850 (cascade)+cellEditEnded |  | 구현 |
| HANDLER:spdMain_EditChange | AS-IS `DMF0003_MktFcst.cs:6482` (라이브 4행) | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx:150 (pasteContinueRef) |  | 구현 |
| HANDLER:spdMain_KeyUp | AS-IS `DMF0003_MktFcst.cs:5636` (라이브 47행) | Wijmo 클립보드 공통(Ctrl+C/V) | Item 붙여넣기→팝업 재현은 FPModal 구조로 대체(E04-5 참조) | 구현 |
| HANDLER:spdMain_TopChange | AS-IS `DMF0003_MktFcst.cs:5621` (라이브 5행) |  | FarPoint SmartColMerge 재적용 전용 — Wijmo wrapper 머지 매니저가 자동 유지 | 해당없음 |

## §11. 셀 콤보 토큰 대사표 (hook #117 §5.6 — 2026-08-15 실측)

> 판정 원천: `SCM_ADM_CMBO_SQL_M.SQL_DTL_CTN` 의 `@토큰` 실측 ↔ FE 전달 지점 실측.
> 서버자동 = `LookupServiceImpl.retrieveCombo` 가 세션에서 채우는 `@sesUserId`/`@sesLangCd` 뿐이다
> (`@userId`/`@langCd` 는 combo-muti 전용이라 자동 주입으로 인정하지 않는다).
> `@mnuId` 는 DMF0003 이 `buildGridComboFilter`/`buildEditComboFilter`/`buildParam` 에서 **전 콤보에 일괄** 주입한다
> (`utils/mkt-fcst.gridCombos.ts:87·161·257·277·297·311`).

| SQL_ID | 필요 토큰 | 서버자동 | FE 전달 지점 | 판정 |
|---|---|---|---|---|
| AS_FROM_SITE | param1 | - | `ROW_PARAM_EDIT_COMBO.AS_FROM_SITE.buildParam` — 행 Div | ✅ |
| BizType / CustomsHandbook / FcstType / Incoterms / ItemType / SoldCustomer / YesOrNo | (없음) | - | `buildGridComboFilter`(@mnuId 만) | ✅ |
| EndCustomerByDivision40Team | (없음) | - | `buildGridComboFilter` | ✅ |
| EndCustomerByDivisionDeptAuth | (없음) | sesUserId | `GRID_EDIT_COMBO.END_CUSTOMER`(sesUserIdParam) + 클라 cascade(Div·Team) | ✅ |
| Measure | mnuId | - | `buildGridComboFilter`(comboId 는 메타에서 동적 — @mnuId 일괄 주입) | ✅ |
| SiteByEndCustomer | divisionId, endCustomer | sesUserId | ⭐ `ROW_PARAM_EDIT_COMBO.SCM_SITE_ID40.buildParam` — 행 Div + 행 END_CUSTOMER40 (AS-IS L3403·L3419 `Data.UserSiteByEndCustomer`) | ✅ (2026-08-15 정정) |
| SiteByEndCustomerAuth | (없음) | sesUserId | `GRID_EDIT_COMBO.SCM_SITE_ID` + 클라 cascade(Div·EndCustomer strict) | ✅ |
| TeambyDivisionAuth | (없음) | sesUserId | `GRID_EDIT_COMBO.TEAM_ID` | ✅ |
| PlantByDivisionCompany | companyId, divisionId | - | **의도적 무전달** — 이 콤보는 PLANT_SITE_ID 의 **표시 dataMap(CODE→NAME)** 전용이라 전 코드가 매핑돼야 한다(좁히면 기존 값이 코드로 노출). 편집 후보는 아래 `PlantSiteByItem` 이 담당 | ✅ (설계) |
| PlantSiteByItem | divisionId, projectCode, itemId | - | ⭐ `ROW_PARAM_EDIT_COMBO.PLANT_SITE_ID.buildParam` — 행 Div·Project·Item (AS-IS `spdMain_CellClick` L6605~6616 [C20200525-000296]) | ✅ (2026-08-15 신설) |

### 정정 근거 (실값 실측 2026-08-15, 사내 Oracle)

| 항목 | 정정 전 | 정정 후 |
|---|---|---|
| Div40 Sales Site 편집 후보 (`endCustomer='HP'`) | **0행** — 클라 cascade 가 END_CUSTOMER(고객코드) ↔ 행 END_CUSTOMER40(=PROJECT_CODE) 를 비교해 전멸 | **42행** — 서버 `@endCustomer` 로 SITE_ITEM.PROJECT_CODE 매칭 |
| 81 Plant Site 편집 후보 | 표시 콤보 그대로(전 27~107행, Project/Item 무관) | div+project+item 반영 **5행** |

## §12. 9섹션 게이트 잔여 WARN — 사유 정본 (2026-08-16)

> 러너 = `ui_gate_runner.py --menu DMF0003`. FAIL 0. 아래 4건은 **수용된 WARN** 이며 각각 실측 근거가 있다.
> 섹션 1(미배선 util export 8종)은 2026-08-16 `export` 제거로 **PASS 전환**됨(파일 내부 전용이라 동작 불변).

| 섹션 | WARN 내용 | 판정 근거 | 조치 |
|---|---|---|---|
| 3. 배선 체인 L7 | sheet `car`/`carProperty`/`carTitle`/`custDemand`/`custDemandInit`/`custDemandResult`/`psi`/`psiLogic`/`psiTitle`/`titleSet` 가 BTN_MPG 에만 존재 | 이 10 시트는 **`DMF0003_1`/`DMF0003_T` 소관** — 사용자 확정으로 본 대사 범위에서 제외된 별도 메뉴다. DMF0003 본화면 FE 는 `Mkt Fcst` 시트만 쓴다 | 수용 (범위 밖 메뉴의 배선) |
| 6. HTTP E2E | 일반 행 M 왕복 생략 | MKT FCST 원장은 W_/M_ 표시값이 D_ 합계라 되쓰기 왕복이 원상 보존을 깨뜨린다. **전용 테스트 키 probe 가 대체**하며 그 축은 PASS(저장→재조회→원복→재조회 4항) | 수용 (실데이터 파괴 방지 — 의도적) |
| 7. 콤보 파라미터 | `PlantByDivisionCompany` @companyId/@divisionId 미전달 | **의도적 무전달**. 이 콤보는 PLANT_SITE_ID 의 **표시 dataMap(CODE→NAME)** 전용이라 전 코드가 매핑돼야 한다(좁히면 기존 값이 코드로 노출). 편집 후보는 `PlantSiteByItem` 행 콤보가 담당 — §11 참조 | 수용 (설계) |
| 8. 콤보 호출지점 | `AS_FROM_SITE`/`SiteByEndCustomer`/`SiteByEndCustomer40` — AS-IS 이벤트 수 > TO-BE 트리거 수 | 세 콤보 모두 **`ROW_PARAM_EDIT_COMBO` 행 단위 콤보**로 구현되어 `beginningEdit` 진입마다 그 행 값으로 재계산된다(AS-IS 의 이벤트 N종이 TO-BE 에선 진입 1지점으로 수렴). 러너는 `refreshOn` 선언을 트리거로 세지 못해 과소 계수 | 수용 (도구 계수 한계 — 구현은 §11 실측) |
