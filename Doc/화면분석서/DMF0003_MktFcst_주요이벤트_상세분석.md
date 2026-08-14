# DMF0003 MKT FCST — 주요 이벤트 상세분석

## 원천 (전수 Read 실측)

- **정본**: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0003_MktFcst/DMF0003_MktFcst.cs` — **7,143줄 처음~끝 전량 Read** (2026-08-12)
- `DMF0003_MktFcst.Designer.cs` — 1,667줄, 이벤트 배선 전수 추출
- 구본(강등): `GSCM.DM.Plan.UIL/DMF0003_MktFcst.cs` 5,920줄 — diff = `DMF0003_정본전환_diff_20260812.md` (정본 전용 EID 14종)
- 시트: `Mkt Fcst` 1개 (SpdSheet.shtMain L150). TO-BE 대상 = 이 시트만 (`DMF0003_1`/`_T` 제외 — 사용자 확정)

### 이벤트 배선 전수 (Designer.cs 실측)

| 컨트롤 | 이벤트 | 핸들러 | Designer L |
|---|---|---|---|
| chkColor | CheckedChanged | chkColor_CheckedChanged | 238 |
| cboAS | CheckedChanged | cboAS_CheckedChanged (⚠ 컨트롤 자체가 L552 `lciASCheck.ContentVisible=false` 로 숨김 — **사문 경로**) | 275 |
| btnOwner | Click | btnOwner_Click | 358 |
| btnIncotermsChg | Click | btnIncotermsChg_Click (Master Change) | 395 |
| chkSum | CheckedChanged | chkSum_CheckedChanged | 471 |
| btnMeasure | Click | btnMeasure_Click | 547 |
| btnColumn | Click | btnColumn_Click | 584 |
| btnProject | Click | btnProject_Click | 620 |
| btnItemId | Click | btnItemId_Click | 690 |
| cboBucketType | SelectedIndexChanged / Click | cboBucketType_SelectedIndexChanged / _Click | 727~728 |
| clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | 922 |
| clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | 962 |
| spdMain | ClipboardPasted/CellClick/CellDoubleClick/ComboSelChange/EditChange/TopChange/KeyUp | spdMain_* 7종 | 1453~1459 |
| contextMenuStrip1 | ItemClicked | contextMenuStrip1_ItemClicked (PR 4메뉴) | 1471 |
| (코드 배선) | Load / Data.Changed / clbDivision.SelectedIndexChanged | Form_Load(L298) / spdMain_Changed(L603) / cboDivision_SelectedIndexChanged(L605) | 본문 |

## 0. 정본 vs 구본 차이 — git diff --no-index 실측

+1,410/-187줄. 정본 전용 EID 14종(64+49+21+12+8+8+4+4+4+3+3+3+3+2+2건) — 인벤토리·요지는
`Doc/화면분석서/DMF0003_정본전환_diff_20260812.md`. 기존 대사표(2026-06-28)·분석서 3본은 구본 기준 → 본 문서가 정본 대체.
TO-BE 구현 산출물이 아니라 **분석 메타** 항목.

## 1. 초기화 체인 (Form_Load, L302~330)

1. clsCtrl 생성 → InitForm → InitControls → CreateSpread → DefineProperty → InitSaveDataTable (L304~309)
2. **[E20260402-001736] measure 프라이밍 (L313~329)**: division 이 `81*` 또는 `82` 면 `MktFcstEditMeasure` 콤보를 미리 받아,
   현재 그룹이 `DM Planner (W/S)` 가 **아니면** `Code != "MKT_FCST_RP"` 행 전부 삭제 — **비W/S 는 MKT_FCST_RP 단독**.
3. 생성자(L299): `UnFilterInsertRow = true` — [E20230509-000677] 필터 상태 Insert 시 신규행 표시.
4. OnShown(L332~356): [E20260211-001189] cboAS 로직 주석 사문화. division `82` → Bucket 기본 **Daily**, 그 외 **Weekly**.

### 1.1 InitControls (L422~563) — 조회조건 콤보 로딩·기본값

1. `SetChangeControl` 축(L368~416, PJ202350699 속도개선): MyDivision / UserTeamByDivision / EndCustomerByDivision /
   BizType / UserSiteByEndCustomer / UserPlantSiteByEndCustomer / EdiSender / ScmSitebyEndCustomer40 —
   전부 `DataService.GetDMInnerTable(코드, Filter)` 이며 Filter 에 `GROUP_ID`(NowGroupID)+`USER_ID` 상시 주입.
2. division=40: BizType·EndCustomer 로딩, **Project·PlantSite·btnProject 비활성**, cboCellQty 활성, checkInvalidExec 비활성 (L443~462)
3. division≠40: Project·PlantSite·btnProject 활성, cboCellQty 비활성·해제. **82: checkInvalidExec 활성+체크**(Sales Price 미등록 제외
   기본 ON). **81: lblEDISender 활성 + EdiSender 로딩** (L463~504)
4. BucketType=`GetBucketType()`(SP DMF0003_GET_BUCKET_TYPE_CODE), Period=`GetDayRange()`(PR_GET_DAY_RANGE p_month=6 —
   당월 1일~6개월 마지막날), ItemType=SCM0001_GET_LOOKUP_VALUES('ITEM_TYPE_CODE') (L531~537)
5. 버튼 3부작 최종 상태(L543~552): `layoutControlItem7.ContentVisible=false`(**Master Change 숨김** — E20260203→E20260312 롤백→
   E20260323 재숨김이 시간순 최종) + `lciASCheck.ContentVisible=false`(cboAS 숨김 — E20260211)
6. [E20260211-001189] Sales Site 재로딩(L554~562): 81*/82 → `GetSalesSite`(SiteByEndCustomer, **PARAM5 = W/S 그룹이면 'Y'**),
   40 → `GetSalesSite40`(SiteByEndCustomer40, PARAM5 동일)

### 1.2 CreateSpread (L609~619) / InitSpread (L622~636) / GetSpdTitle (L6336~6355)

1. 시트 1개 `Mkt Fcst`, 헤더 3단. [E20260402-001736] `InitSpread(sType)` — 최초 진입만 `"LOAD"`, 그 외 `""`.
2. `GetSpdTitle`: SP `DMF0003_GET_SPREAD_TITLE`(p_start/end_yyyymmdd, p_created_by, p_division_id,
   **p_user_group**, **p_type**) — [E20260402] W/S 권한 접근 시 AS FROM SITE 컬럼 **서버가 강제 추가**(p_type='LOAD' 최초 1회).
3. SetSpreadHeaderSpan(L658~756): 3단 span(Large/SUM/Small), `B_` 접두 컬럼 숨김, SAT 파랑/SUN 빨강(L704~709),
   Measure 컬럼까지 Freeze. InitSpreadFooterSum(L638~656): D_/M_/W_ 컬럼 footer SUM(`SumIgnoreHidden`).

### 1.3 DefineProperty (L565~607)

1. 조회조건 높이 108. Bucket 기본 Weekly. cellTypeImage(대문자·우측 이미지) — Insert 행 Project/ItemId 팝업 유도 셀.
2. **권한 스위치(L580~600)**: `ADMIN`/`DM ADMIN` → btnIncotermsChg(Master Chg) 활성+표시, layout6·7 표시 /
   `DM Planner` → btnIncotermsChg 활성+표시, layout7 표시 / **그 외 → 전부 숨김**. (layout7 은 §1.1-5 에서 최종 숨김이
   덮음 — 시간순 최종 상태는 **Master Change 전 그룹 숨김**)
3. `spdMain_Changed` 를 DataModel 에 배선(L602~603), clbDivision/cboBucketType SelectedIndexChanged 배선(L605~606).

### 1.4 InitSaveDataTable (L758~800)

dtSave(16컬럼: Action + Division/Project/ScmSiteId/ItemId/DomExp/Incoterms/FcstType/Measure/PlantSiteId/YYYYMMDD/
Qty(int)/Customer40/ScmSiteId40/ItemId40/**AS_FROM_SITE**) + dtSaveFinal(15컬럼 — Action 없음, [E20260211] AS_FROM_SITE 포함).

## 2. FindData — 조회 (FindButton L805 → FindData L1673~1947)

1. 선행 검증: division 빈값 → **MSG00097** / 기간 from>to → **MSG00108** / from+3년<to → **MSG00164** + to=from+2년 보정 (L1685~1709)
2. [E20260402] `InitSpread("")` 재실행(컬럼 재구성) 후 SP 호출.
3. SP `DMF0003_GET_MKT_FCST_DATA` 파라미터 **19개**(L1734~1756): p_division_id/p_scm_site_id/p_plant_site_id/p_team_id/
   p_customer/p_biz_type/p_project_code(txt)/p_item_id(txt)/p_from·to_yyyymmdd/p_created_by/p_user_group/p_item_type/
   p_owner(txt)/p_qty_yn/p_cell_yn/p_invalid_exec/**p_as_yn**/p_user_dept_id/p_sender_code.
   ⭐ [E20260211-001189] `p_as_yn = (NowGroupID=="DM Planner (W/S)") ? "Y" : "N"` — cboAS 체크 대체.
4. 반환: Tables[0]=본문, **Tables[1]=dt8Week**(40 잠금 기준: CALENDAR_YYYY/ISO_WEEK/MONTH_NAME), Tables[2]=THIS_YYYYMMWW/ISO_WEEK.
5. `Draw()`(L1949~2217, E20240812): **NOTATION 행 서식 3종** — INTEGER(정수)/POINT(들어온 형태)/POINT3(무조건 3자리) 분기표(L2026~2092).
   SetSearchCount. 이후 SSP 동기화 색(§8), 초록 당주 라인(§9).
6. 종료: `sDefaultDay = DefaultBucketDay(division, bucket)` — 주→일 배분 기본 요일 (L1934).

## 3. 편집/저장

### 3.1 EditButton (L824~1338) — 편집 게이트 8종 + 잠금 매트릭스

**게이트(순서 그대로 — MSG 는 제약매트릭스 §V 참조)**
1. [E20260604-000994] `SCP Planner` × division 82/40 → **MSG00096** 차단 (L829~833)
2. [PJ2025-50017] `DM_UI_EDITABLE_DIVISION`('DMF0003', division) EDIT_YN='N' → **MSG00448** (40 은 DMF0082 에서 편집) (L838~846)
3. [E20260604] `SCP Planner` × 81* → `SCP_PLANNER_EDIT_FLAG` lookup 0건이면 **MSG00477**(수정 가능 시간 아님) (L849~859)
4. [E20260604] `DM Planner`/`DM Planner (W/S)`/`DM ADMIN` × 81* → `DM_PLANNER_EDIT_FLAG` 행 존재하면 **MSG00478**
   (인자 5개: LIMIT_AUTH/EDIT_DAYS/FROM_TIME/TO_TIME/AUTH) (L863~873) ⚠ C# 연산자 우선순위상 `||` 뒤 `&&` 라
   DM ADMIN 만 81 조건이 걸리고 Planner 2종은 **division 무관 적용**됨 — 원문 그대로 기록
5. [E20260402-001736] Planner 3그룹 × 81*/82 × AS_FROM_SITE 컬럼 부재 → **MSG00113** (L877~888)
6. 필수 컬럼: 81*=9종(Division/Project/ScmSiteId/ItemId/DomExp/FcstType/Incoterms/Measure/**PlantSiteId**) /
   82=8종(PlantSiteId 제외) / 40=8종(Division40/Customer40/ScmSiteId40/ItemId40+DomExp/FcstType/Incoterms/Measure) → **MSG00113** (L891~924)
7. 조회 선행: dt8Week 없음 → **MSG00259** (L941~945)
8. `SwitchLock()` — 편집 토글(재클릭=해제).

**버킷·시점 잠금 (L953~1117)** — 편집 진입 시 컬럼(세로) 단위:
- 기준일 = **당주 월요일**(sYYYYMMDD, L953~954).
- Daily: D_ 과거(<당주월요일) 잠금, W_/M_ 전부 잠금.
- Weekly: W_ 는 **다음 컬럼(D_)의 일자**로 과거 판정(C20210827), D_/M_ 잠금. (40 의 8주 제한은 C20200325 주석 사문)
- Monthly: M_ 과거 잠금, **40 은 dt8Week.MONTH_NAME 이전 월까지 추가 잠금**, D_/W_ 잠금(40 은 조건부).
- 행 단위(L1119~1281): `EDIT_FLAG != 'Y'` 행은 Measure 이후 전열 잠금. Insert 행(I)은 §3.3 잠금 재적용 + 정적 컬럼
  잠금 목록( SoldTo/ProjectName/ProjectStatus/CellType/BizType/Country(+Name)/City(+Name)/ItemName/ItemType/NickName/
  ProjectOwner/VMI_YN/Owner/MeasureGroup — L1141~1182) + 과거구간 잠금·색(§9).
- division 81*/82 → Division 컬럼 잠금 / 40 → Division40 잠금 (L1275~1278).

### 3.2 SaveButton (L1340) → SaveData (L2220~2506)

1. 편집모드(SheetName unlock) + `Mkt Fcst` 시트에서만.
2. `fnValidation(out bInputCheck)`(§7): 중복 → **MSG00043** / 수량 미입력 → **MSG00034** (L2254~2264)
3. dtSaveFinal 을 '^' 연결 문자열 15축으로 직렬화(L2267~2394). 첫 행 sActionFlag='M', 이후 "^M" 누적.
   40 은 Project←Customer40 / SiteId←ScmSiteId40 / ItemId←ItemId40 스왑.
4. ⭐ **[E20260402-001736] 저장 게이트**(L2300~2329·2362~2391 — 첫 행/누적 행 동일 로직): `DM Planner (W/S)` × 81*/82 에서
   행 사이트가 **비축향 아님**(AS_FROM_SITE 콤보 `Name` 미매칭) AND FCST Type ∈ `GetFcstType()`(W/S 4종) AND AS_FROM_SITE 빈값
   → **MSG00476** 차단.
5. sASFromSite 는 [E20260211] **행 컬럼 값 직접**(구 cboAS 로직 주석 사문). `Replace(",", "^")`.
6. SP `DMF0003_SAVE_MKT_FCST` 파라미터 **16개**(L2424~2439): p_active_flag/p_division_id/p_project_code/p_scm_site_id/
   p_item_id/p_dom_exp/p_fcst_type/p_incoterms/p_measure/p_plant_site_id/p_yyyymmdd/p_qty/p_created_by/
   p_as_from_site/**p_bucket**(E20250313)/**p_authority**(E20260604 — NowGroupID).
7. 응답: Tables 있으면 Tables[0][0][0] 를 메시지로 표시, **Tables[1] 행 있으면 DMF0003_SspSyncPopUp**(40 동기화 내역).
   Tables 없으면 **MSG00004**(건수) + FindData 재조회 + viewport 복원 (L2447~2468).

### 3.3 InsertButton (L811) → InsertRow (L2529~3014)

1. [E20260604] `SCP Planner` × 81* → **MSG00096** 차단 (L2532~2536).
2. 81*/82: Project/ItemId 셀 = cellTypeImage(더블클릭 팝업 유도), Division 값 세팅. 40: ItemId40 이미지, Division40 세팅 +
   **CustomsHandbook 콤보**(DomExp — C20220704) (L2551~2571).
3. 콤보 세팅: PlantSite(dtPlantSite) / **FcstType** — [E20260402] W/S 그룹 = `GetLookupValues("FCST_TYPE","EDIT_MODE")`
   (SALES_TYPE_CODE2 ∪ _ADD → Recall·RMA 포함 6종), 그 외 = `GetFcstType()`(그룹 파라미터 — 비W/S 는 SALES_TYPE_CODE 11종) /
   **Incoterms** — [E20250919] `GetLookupValues("INCOTERMS","ALL","Y")`(VALID_YN='Y' 만 — 과거코드 제외) /
   **AS_FROM_SITE** — [E20260211] `Data.Common(AS_FROM_SITE, division)` (L2573~2618).
4. Team/EndCustomer/SalesSite Auth 콤보: 40 = EndCustomerByDivision40+UserSiteByEndCustomer / 그 외 =
   UserEndCustomerByDivisionDeptAuth + **[E20260402] GetSalesSite 재로딩**(구 UserSiteByEndCustomerAuth 주석) (L2626~2667).
5. **Measure 콤보**: `MktFcstEditMeasure(division, site, project, userId)` — [E20260402] 81*/82 에서 비W/S 그룹은
   `AS_In_Req` 행 삭제 (L2673~2691). 기본값 `MKT_FCST_RP` 세팅(L2694).
6. 정적 컬럼 잠금 약 30종(L2697~2783): §3.1 목록 + CUST_GROUP(+DTL)/APPLICATION/ROUTE/MDM_PROJECT_NAME/MIN_CAPACITY/
   FORECAST_INFO_*/DMS_*/**AS_FROM_SITE**(초기 잠금 — 해제는 ComboSelChange 3축)/LAST_UPDATE_*/SENDER_*/
   **[E20241030] PROJECT_S_OP_REPORT**/**[E20241015] CELL_PER_MODULE**/**[E20260311] Team·TeamName**.
7. Measure 이후 버킷·시점 잠금(L2787~3009): §3.1 동형이나 **행(iRow) 단위 LockRange**.

### 3.4 DeleteButton (L816~822)

Action='I' 행만 `siMain.DeleteRow()` — 기존 행 삭제 불가(조회 화면 아님).

### 3.5 ExcelButton (L1346~1391, E20240906)

`SimplexelService.ExportFpSpread` 단순 내보내기(파일명 `{폼명}_{yyyyMMddHHmmss}.xlsx`). 구 구현(E20240812 소수점 처리
ExportExcel)은 L1392~1664 **전체 주석 사문** — NOTATION 서식은 Draw() 가 처리하므로 시트 서식이 그대로 내려감.

## 4. 그리드 이벤트

### 4.1 spdMain_Changed (L3944~5382) — CellsUpdated 만

1. **필수값 검증 시리즈**(L3980~4088): D_/W_/M_ 셀 수정 시 Division/Project(81*·82)/EndCustomer(40)/SalesSite/Item/
   DomExp/FcstType/Incoterms/Measure/PlantSite(81*) 빈값이면 `ValidationCheck` → **MSG00002**(컬럼명 인자) + 값 회수.
2. 키 컬럼(Division/ScmSiteId/Division40/Project) 변경 → `MktFcstEditMeasure` 재조회·콤보 스왑(L4089~4111) +
   **82 × ScmSiteId → VMI_YN/VMI_STD_DIO 세팅**(DM_VMI_YN — C20201103) (L4114~4136).
3. 81* × Project/ItemId 변경 → PlantSite 후보 재조회(`SalesPlant`) (L4149~4170).
4. **신규행 중복 검사**(L4172~4315): I 행 전체를 키 8~9축(40/81*/82 별)으로 대조, 2건 이상 → 값 회수 + **MSG00260**.
5. **버킷 배분**(L4318~5379): BUCKET 요일비트(7자리, 기본 '0000010'=금요일) 기반.
   - Daily×D_: 주합계(W_)·월합계(M_) 롤업 + SetSaveData(해당 일자).
   - Weekly×W_: [SSP] 40×MKT_FCST_RP×**FCST Type≠RMA**(E20241210) 는 PaleGreen(동기화) 합계 미만 입력 시 값을 sync 합으로
     되돌림(L4496~4516). 배분 = 요일비트 일자 균등 + 잔여는 마지막, 비트 없으면 **기본요일(sDefaultDay) 단일 배분**,
     PaleGreen 셀 제외(L4677~4803). 월 롤업.
   - Monthly×M_: 실적(과거 D_) 합보다 작으면 **MSG00225** 차단(L4899~4905). 기본요일 기준 월내 배분 + 주 롤업(L5008~5167).
   - Weekly/Monthly×D_(40): 주·월 롤업 재계산 + SetSaveData (L5170~5317).
   - **키값 변경 시**(수량 외 컬럼): I 행이면 수량 전부 클리어 + `SetSaveDataRemove` (L5319~5379).

### 4.2 SetSaveData (L5395~5522) / SetSaveDataRemove (L5524~5619)

필수값 가드(빈값 조용히 return — MSG 주석 사문) 후 dtSave upsert(15+AS_FROM_SITE 필터 — AS_FROM_SITE 는
**비어있지 않을 때만 필터에 포함**, C20220328). Remove 는 YYYYMMDD 제외 키로 일괄 삭제.

### 4.3 spdMain_ComboSelChange (L3291~3603)

1. **Division**: Team/Customer(Auth)/Customer40/SalesSite(Auth) 캐스케이드 + BizType 갱신 + **81* 만 PlantSite 잠금 해제**
   (그 외 잠금) + Measure 재조회 (L3297~3373).
2. **Team**: Customer(Auth)→SalesSite(Auth) 연쇄 / 40 축 동일 (L3374~3405).
3. **Customer/Customer40**: SalesSite 재조회 (L3406~3420).
4. **ScmSiteId**(L3421~3514): Project/ProjectName/ProjectStatus/BizType 클리어 + Measure 재조회 + **AS 전용 Incoterms 스왑**
   (`GetIncotermsType` = AS_INCOTERMS(division, site)) + ⭐[E20260211/E20260402] **AS 3축 분기**: 81*/82 && AS_FROM_SITE 컬럼 존재 시 —
   비축향(콤보 Name 매칭) → Measure=`AS_In_Req` 단독 + Measure 값 클리어 + **AS_FROM_SITE 값 클리어+잠금** /
   고객향 → Measure=`MKT_FCST_RP` 단독 + FCST Type ∈ W/S 4종(`GetLookupValues("FCST_TYPE","DM Planner (W/S)")` =
   SALES_TYPE_CODE2)이면 AS_FROM_SITE **해제**, 아니면 클리어+잠금.
5. **ScmSiteId40**: Measure 재조회 (L3517~3527).
6. **Measure**(L3531~3554): I 행에서 `AS_In_Req`/`BNPIn` 외로 바꾸면 Item 4종(Id/Name/Type/NickName) 클리어 (MDM ACTIVE_FLAG 게이트).
7. **FcstType**(L3556~3602): ⭐[E20260211] 비축향 아님 && W/S 4종 → AS_FROM_SITE 해제, 단 **컬럼 부재 시 MSG00472**
   (컬럼셋팅 안내) / W/S 아니면 클리어+잠금 / 비축향이면 클리어+잠금.

### 4.4 spdMain_CellDoubleClick (L3604~3942)

1. 헤더: M_ 더블클릭 → 해당 월의 W_ 토글·D_ 접기 / W_ 더블클릭 → 해당 주 D_ 토글 (L3606~3645).
2. 셀: **40 × MKT_FCST_RP × PaleGreen/PapayaWhip 셀** → SP `DMF0003_GET_MKT_FCST_COMPARE_POPUP`(8 파라미터) →
   `DMF0003_SspSyncComparePopUp` (L3703~3757).
3. I 행 && 미잠금 시: **Project 더블클릭** → `SCM0002_ProjectbyDivisionPopupEx`(division/team/customer/site/project) →
   Project/Name/Status/BizType/Owner 회신 세팅 (L3766~3824) / **ItemId(81*/82)·ItemId40** → `DM0002_ItembyDivisionPopupEx`
   ([E20231019] sMdmActive_Sw='Y' + measure 전달) → Item 4종 세팅 (L3825~3940).

### 4.5 spdMain_KeyUp (L5636~5700) / EditChange (L6482~6488) / ClipboardPasted (L6491~6593) / TopChange / CellClick

1. KeyUp: ItemId/ItemId40 컬럼에서 **V(붙여넣기) → 즉시 CellDoubleClick 재현**([E20231019] — 모델 유효성 팝업 경유),
   C 복사. Measure 이후 컬럼은 V/C 직접 처리 + bPasteContinue.
2. EditChange: Measure 이후 컬럼 편집 시작 시 bPasteContinue=true.
3. ClipboardPasted(C20200306): 붙여넣은 범위 행별 — ScmSiteId40 → Measure 재조회 / ScmSiteId → Incoterms(AS) 재조회 +
   ⭐[E20260211] **AS 3축 분기 재적용** — 단 기준 목록이 `GetLookupValues("FCST_TYPE","EDIT_MODE")`(6종 — Recall·RMA 포함)로
   §4.3-4(4종)보다 **넓음** (L6530).
4. TopChange: SmartColMerge 재적용. CellClick(L6596~6688): 미잠금 시 PlantSite 후보 재조회(PlantSiteByItem) /
   82 × Measure × NEW_FLAG='Y' → Measure 재조회 / 81*·82 × Measure × I 행 → [E20260211] 비축향=AS_In_Req·고객향=MKT_FCST_RP 스왑.

## 5. 버튼 전수

### 5.1 BaseForm override

FindButton(L805)/InsertButton(L811)/DeleteButton(L816)/EditButton(L824)/SaveButton(L1340)/ExcelButton(L1346).

### 5.2 커스텀 버튼·체크박스

1. btnProject(L5702): `SCM0002_ProjectbyDivisionPopupEx`(조회조건 모드) → txtProject.
2. btnItemId(L5725): `DM0002_ItembyDivisionPopupEx` → txtItemId.
3. btnColumn(L5749): `DM0002_TitleSetForm_Popup("DMF0003", "Mkt Fcst", **true**, division)` — 컬럼 셋팅, OK 시 InitSpread("").
4. btnMeasure(L5765): 동일 팝업 **false** — Measure 셋팅, OK 시 InitSpread("").
5. btnIncotermsChg(L6434): `DMF0003_MatsterChgPopup` — §1.1-5 로 **버튼 자체 숨김(사문)**.
6. btnOwner(L6449): `DM0020_OwnerbyDivisionPopup` → txtOwner.
7. cboBucketType_Click(L6470): I 행 존재 시 **MSG00227**(버킷 변경 불가). cboBucketType_SelectedIndexChanged(L3217~3289):
   SetSpreadColumn(버킷별 컬럼 표시) + 초록 라인 재적용 + **편집모드면 EditButton() 2회 호출**(잠금 재계산).
8. chkColor(L5628)/chkSum(L5781): SetSpreadColumn 재적용. cboAS(L7068): **사문**(컨트롤 숨김).
9. contextMenuStrip1(L6710~6953): PR 4메뉴 — **Request_PR**(BNPIn 메저·D_ 컬럼·실적구간 제외·Model 중복 불가·Project 동일,
   '^' 직렬화 → `DMF0003_PRPopup`) / **View_PR·Add_History**(단일 셀 → PRPopup) / **View_History**(단일 셀 → `DMF0003_PRHistoryPopup`).

### 5.3 화면 내 검증 메시지 전수 (활성 기준)

MSG00002(필수값·인자) / MSG00003(예외) / MSG00004(저장 성공·건수) / MSG00034(수량 미입력) / MSG00043(중복) /
MSG00096(권한 없음 ×2) / MSG00097(division 미선택) / MSG00108(기간 역전) / MSG00113(필수 컬럼 부재 ×3) /
MSG00164(3년 초과) / MSG00225(실적 미만 입력) / MSG00227(I 행 존재 버킷 변경) / MSG00259(조회 선행) /
MSG00260(신규행 중복) / MSG00448(EDIT_YN=N) / MSG00472(AS_FROM_SITE 컬럼 부재 안내) / MSG00476(AS FROM SITE 필수) /
MSG00477(SCP 시간 게이트) / MSG00478(Planner 시간 게이트·인자 5) + 하드코딩 MessageBox 7건(YYYYMMDD 형식/선택 셀 없음/
실적 구간 포함/일자컬럼 전용/Request 내용 없음/Model 중복/Project 동일 — PR 메뉴 계열).

## 6. 호출 팝업 상세 (8종)

1. `SCM0002_ProjectbyDivisionPopupEx` — 조회조건 btnProject(true 모드) + 그리드 Project 더블클릭(false 모드).
2. `DM0002_ItembyDivisionPopupEx` — btnItemId + 그리드 ItemId/ItemId40 더블클릭([E20231019] MdmActive·measure 인자).
3. `DM0002_TitleSetForm_Popup` — btnColumn(true)/btnMeasure(false), division 전달.
4. `DMF0003_MatsterChgPopup` — btnIncotermsChg (**버튼 숨김 = 사문**).
5. `DM0020_OwnerbyDivisionPopup` — btnOwner.
6. `DMF0003_PRPopup` — PR Request/View/Add_History (컨텍스트 메뉴).
7. `DMF0003_PRHistoryPopup` — View_History.
8. `DMF0003_SspSyncPopUp`(저장 응답 Tables[1]) / `DMF0003_SspSyncComparePopUp`(동기화 셀 더블클릭) — SSP 동기화 2종.

## 7. fnValidation (L5887~6273)

1. I 행 전수: 그리드 전 행과 키 대조(81*=9키/82=8키/40=8키) — 자기 포함 2건 이상이면 중복 실패(MSG00043 경로).
2. I 행별 D_ 수량 입력 0건이면 bInputCheck=false(MSG00034 경로).
3. dtSave → 그리드 실재 행만 dtSaveFinal 로 옮김(키+**bAsCompare** — AS_FROM_SITE 값 일치, [E20260211] 스프레드 값 승계).
   I 저장인데 그리드 기존(비I) 행 키와 같으면 제외.

## 8. SSP 동기화 표시 (C20200804 — 40/82)

조회 후 ATTR1(`일자/구분^…`) 파싱 → D_ 셀 배경: 'A'(All)=**PaleGreen** / 'P'(Partial)=**PapayaWhip**.
Weekly 입력 시 PaleGreen 합 미만 금지(§4.1-5, RMA 예외 E20241210). PaleGreen 셀은 배분 대상 제외.

## 9. 당주 표시 (초록 라인·헤더)

[E20250313-001251] count(당주 ISO 주 W_ 컬럼 출현 수)≥2 이면 — 조회 시작일 > 당주 월요일 → **this_YYYYMMWW** 에,
아니면 `W_{당주월}{iso}` 에 초록 BevelBorder. 1건이면 this_YYYYMMWW. Daily 는 `D_{당주월요일}`.
SetSpreadColumn(L5815~5885): 버킷별 컬럼 표시(chkSum 시 상위 버킷 표시) + 당주/당월 헤더 **초록 볼드**.

## 부록. 헬퍼/유틸 (활성)

`SetChangeControl`(§1.1) / GetDayRange / GetSpdTitle / GetBucketType / GetItemType(2) / GetBizTypebyDivision /
GetFcstType(**FCST_TYPE + NowGroupID** — UP_FX_GetCommonDataList_DM L68~79: W/S=SALES_TYPE_CODE2 4종·EDIT_MODE=∪_ADD 6종·
그 외=SALES_TYPE_CODE−ATTRIBUTE2'Y' 11종) / GetIncotermsType(AS_INCOTERMS) / GetSalesSite·GetSalesSite40(SiteByEndCustomer(40),
PARAM5=W/S 'Y') / GetCustomsHandbook(DM_CUSTOMS_HANDBOOK) / GetEdiSender(EDI_SENDER_CODE) / GetLookupValues(범용) /
GetWeekNumber / getDayOfWeek / SetSaveSheetColor(L2508 — 저장 후 색·Action 클리어).

## 부록. 비활성(주석) 확인 목록 — 지어내기 방지용 실측

cboAS 계열 전부(E20260211 사문) / C20200325 40 사업부 8주 잠금 3블록 / C20200713 VMI-In Req 자동배분 2블록(C20201015 원복) /
E20240812 구 ExcelButton(L1392~1664) / btnCutOff(L5789~5812) / spdMain_SelectionChanged / MSG00366(ALL 불가 — cboAS 사문과 동반) /
42·44 division 분기 전부 / GetDivision·GetScmSitebyDivision·GetPlantSitebyEndCustomer·GetTeambyDivision·GetCustomerbyDivision
(SCM0001 계열 — 활성 호출 지점 없음, SetChangeControl 로 대체).
