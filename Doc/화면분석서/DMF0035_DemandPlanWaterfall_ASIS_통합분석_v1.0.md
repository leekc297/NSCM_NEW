# DMF0035 Demand Plan Waterfall — AS-IS 3화면 통합 상세 분석 v1.0

> 작성: 2026-08-06 · 목적: AS-IS 3개 WATERFALL UI(DMF0035/DMF0022/DMF0051)를 TO-BE **DMF0035 "Demand Plan Waterfall"** 단일 UI(GUBUN 콤보: MKT FCST/SALES PLAN/BIZ PLAN, 초기값 MKT FCST)로 통합하기 위한 구현 정본.
> 근거: AS-IS 원소스 전문 정독(.cs/.Designer.cs) + AS-IS MSSQL SP 원문(sys.sql_modules 덤프) + 기존 8종 분석 md/xlsx 3-way cross-check. 전 항목 파일:라인 명기.
> 정본 트리: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\` (신판 — 모놀리식 `GSCM.DM.Plan.UIL` 대비 40~60행 최신).
> 범위: **1차 = 조회 전용 통합** (사용자 확정 2026-08-06). DMF0051_1(편집형 — 저장·Confirm BP·Release SCP·BP CutOff)은 §3.H 인벤토리로 기록만 하고 2차 보류.
> 짝 문서: `DMF0035_DemandPlanWaterfall_Cascade_Filter_전수.md` (hook #123 R2)

---

## §0. 통합 개요

| | DMF0035 (MKT FCST WF) | DMF0022 (SALES PLAN WF) | DMF0051 (BIZ PLAN WF) |
|---|---|---|---|
| 성격 | 조회 전용 리포트 | 조회 전용 | 조회 전용 (0051_1 편집형은 별개) |
| 조회 SP | `DMF0035_GET_MKT_FCST_WATERFALL` (19 IN, 결과셋 3) | `DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL` | `DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL` |
| 헤더 SP | `DMF0035_GET_SPREAD_TITLE` (5 IN) | `DMF0022_GET_SPREAD_TITLE` (7 IN PKG판) | `DMF0051_GET_SPREAD_TITLE` (7 IN PKG판) |
| 사내 Oracle 상태 | PKG=GET만 / TITLE standalone VALID(합류 필요) | PKG 완비 + PROC_M 25행 배선 | PKG=TITLE만 / **GET 재변환 필요(INVALID)** |
| 화면 고유 | EDI Sender(81만)·chkColor·단일 Division 콤보·cboQTY 단위환산·Cell Qty(40만) | 통화 LOC/KRW/USD 콤보·InternalYN | 0022 축소 클론 |
| 그리드 | 동적 PIVOT(D_/W_/M_) + 3단 헤더 병합 + MEASURE까지 freeze + footer SUM + 전 컬럼 Lock | 동일 골격 | 동일 골격 |
| 팝업 | Project/Item/TitleSet(C·M)/Version(Waterfall)/Owner 5종 | 동일 계열 | 동일 계열 |

TO-BE 통합 방향: **GUBUN(초기값 MKT FCST) → 조회 SP 3계열 시트 스위칭** + 조회조건 합집합(GUBUN별 표시 토글) + **Wijmo OLAP PivotGrid**(공용 `OlapPivotGrid` — wide 커서를 `unpivotWideRows`로 long 변환 후 바인딩).

---

## §1. DMF0035 MKT FCST Waterfall — 상세 (원소스 전문 정독)

정본: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0035_MktFcstWaterfall\DMF0035_MktFcstWaterfall.cs` (2,316행, 이하 `.cs`) + `.Designer.cs`(1,668행). SP 원문 = MSSQL sys.sql_modules 덤프(GET 4,895행 / TITLE 373행 — 라인번호는 덤프 기준).
화면 성격: **조회 전용** — 전 컬럼 Lock(`.cs:1155`), ReadOnlySheetList(`.cs:312`), Insert/Delete/Save no-op(`.cs:633~655`).

### §1.A 조회조건 (전 항목)

| 컨트롤 | 라벨 | 유형 | 기본값 | 데이터 원천 | cascade | SP 파라미터 |
|---|---|---|---|---|---|---|
| `cboDivision` | Division* | UsrCombo(단일 DropDownList) | 로드 시 index 1 자동선택(.cs:420-423) | `GetDMInnerTable("MyDivision")` GROUP_ID/USER_ID 필터(.cs:237-244) | 변경 시 Team·EdiSender·Customer·SalesSite·BizType·PlantSite 재로드 + Project/ItemId/Version/Owner 클리어(.cs:1387-1499) | `p_division_id` |
| `clbTeam` | Team | UsrCheckedList(ALL) | ALL | `GetDMInnerTable("UserTeamByDivision")`(.cs:247-253) | Customer+SalesSite 재로드(.cs:1501-1536) | `p_dept_id` |
| `clbCustomer` | End Customer | UsrCheckedList(ALL) | ALL | `GetDMInnerTable("EndCustomerByDivision")` DIVISION+DEPT(.cs:254-261) | SalesSite 재로드(.cs:1538-1563) | `p_end_customer` |
| `clbBizType` | Biz Type | UsrCheckedList(ALL) | ALL | `GetDMInnerTable("BizType")`(.cs:262-267) | Division 변경 시 재로드 | `p_biz_type` |
| `clbEDISender` | Sender Code | UsrCheckedList(ALL) | ALL — **division=='81' 정확일치 시만 enabled**(.cs:350-359,1426-1429) | `GetDMInnerTable("EdiSender")`(.cs:293-297) | Division 변경 시 재로드 | `p_sender_code` |
| `drpPeriod` | Period* | UsrDateRangePickerWtWeek | `PR_GET_DAY_RANGE`(p_month=6) 당월1일~6개월 말일(.cs:406,2005-2019) | Version 팝업 선택 시 popVersion.sPeriod 로 덮어씀(.cs:2142) | `p_from/p_to_yyyymmdd` |
| `clbSalesSite` | Sales Site | UsrCheckedList(ALL) | ALL | `GetDMInnerTable("UserSiteByEndCustomer")`(.cs:269-277) | Team/Customer 변경 시 재로드 | `p_scm_site_id` |
| `txtProject`+btn | Project | 텍스트+팝업 | '' — **81*/82만 enabled, 40 disabled**(.cs:1420-1424,1453-1455) | 팝업 §1.E | Division 변경 시 클리어 | `p_project_code`(부분일치) |
| `txtItemId`+btn | Model/Nickname | 텍스트+팝업 | '' | 팝업 §1.E | Division 변경 시 클리어 | `p_item_id`(ITEM/NICK 부분일치) |
| `cboBucketType` | Bucket | UsrCombo | **MONTHLY**(.cs:430) | `DMF0003_GET_REPORT_BUCKET_TYPE_CODE` — DAILY/WEEKLY/MONTHLY/ONLY_WEEKLY(.cs:181-187) | §1.C 컬럼 토글/재구성(.cs:1594-1617) | `p_bucket` |
| `btnColumn`/`btnMeasure` | (아이콘) | 버튼 | — | 팝업 TitleSet C/M | OK 시 InitSpread 재구성 | (titleset 저장) |
| `chkColor` | Color | 체크박스 | N | — | SetSpreadColumn — §1.C 색상 반전(.cs:1830-1834) | (클라이언트) |
| `cboCellQty` | Cell Qty | 체크박스 | N — **40만 enabled**(.cs:347-348,374) | — | — | `p_cell_yn` |
| `clbPlantSite` | Plant Site | UsrCheckedList(ALL) | ALL — 81*/82만 enabled | `GetDMInnerTable("UserPlantSiteByDivision")`(.cs:278-284) | Division 변경 시 재로드 | `p_plant_site_id` |
| `txtVersion`+btn | Version* | 텍스트+팝업 | ''(=CURRENT) — **KeyDown 도 팝업 오픈**(.cs:2146-2149) | 팝업 §1.E Version | Division 변경 시 클리어 | `p_version_no` |
| `clbItemType` | Item Type | UsrCheckedList(ALL) | ALL | `SCM0001_GET_LOOKUP_VALUES` 'ITEM_TYPE_CODE'(.cs:2065-2077) | — | `p_item_type` |
| `txtOwner`+btn | Owner | 텍스트+팝업 | '' | 팝업 §1.E Owner | Division 변경 시 클리어 | `p_owner`(.Trim) |
| `cboQTY` | QTY | UsrCombo | index 0(=1) | `DMF0003_GET_QTY_TYPE_CODE`(.cs:2052-2063) | **클라이언트 단위환산** ÷1/1k/1M/100M — D_/W_/M_ 값만, Round 2(.cs:2193-2288) | (SP 미전달) |
| `chkSum` | Sum | 체크박스 | N — ONLY_WEEKLY 시 disabled+해제(.cs:450-456) | — | SetSpreadColumn 합계열 토글(.cs:1822-1828) | (없음) |

no-op 배선(이관 제외): `SetClbVersion` stub(.cs:1565-1592), 그리드 셀 더블클릭 팝업 2종(Action=='I' 가드 — read-only라 도달 불가), `spdMain_ComboSelChange`, 구 ExportExcel 블록(662-931).

### §1.B 조회 SP 계약

**GET `DMF0035_GET_MKT_FCST_WATERFALL` — 19 IN** (기존 analysis.md "19 params" 정확 / 사내 PKG 판 21 IN은 P_USER_ID/P_MENU_ID 추가분):

| # | 파라미터 | 의미 |
|---|---|---|
| 1 | `@p_division_id` | 단일 division. **'40'이면 원천 `DM_PLN_CFM_MKT_DEMAND_PLAN(_C)`, 그 외 `DM_PLN_MKT_FCST(_C)` 스위칭**(SP:782-790 외 전 구간) |
| 2 | `@p_dept_id` | ≠ALL: `#TEMP_SCM_MST_SITE_ITEM.DEPT_ID` DELETE 필터(SP:3460-3492) |
| 3 | `@p_end_customer` | ≠ALL: 40=PROJECT_CODE 토큰 / 그 외 SCM_MST_SITE.END_CUSTOMER(SP:3494-3515) |
| 4 | `@p_scm_site_id` | ≠ALL: SCM_SITE_ID 정확일치(SP:3517-3525) |
| 5 | `@p_project_code` | ≠'': PROJECT_CODE 또는 PROJECT_NAME LIKE(SP:3412-3425) |
| 6 | `@p_item_id` | ≠'': ITEM_ID/NICK_NAME LIKE(SP:3428-3440) |
| 7 | `@p_item_type` | ≠ALL: ITEM_TYPE(P>H>Q>R 집약) 필터(SP:3063-3070, 3537-3546) |
| 8/9 | `@p_from/@p_to_yyyymmdd` | 계획 `>= @V_NOW_YYYYMMDD`(당주 월요일 SP:120) / 실적 `<` 분리 |
| 10 | `@p_created_by` | titleset(C/M) 개인화 키 |
| 11 | `@p_plant_site_id` | ≠ALL 필터(SP:3527-3535) |
| 12 | `@p_biz_type` | 40=FORECAST_INFO_BIZ_TYPE / 그 외 PROJECT.BIZ_TYPE LIKE(SP:3548-3570) |
| 13 | `@p_owner` | OWNER/OWNER_NAME(EN/KO) LIKE(SP:3443-3458) |
| 14 | `@p_version_no` | 'CURRENT' 또는 MF/ME/SF 버전 CSV — "버전(Wxx)" 괄호 절단(SP:342-343), %MF%/%ME%/%SF% LIKE 분기 |
| 15 | `@p_bucket` | DAILY/WEEKLY/MONTHLY/ONLY_WEEKLY — PIVOT 컬럼·집계 분기(SP:3775-3815, 4687-4759) |
| 16/17 | `@p_user_dept_id`/`@p_group_id` | **dead param(선언만, 본문 미사용)** |
| 18 | `@p_cell_yn` | 'Y': QTY×FORECAST_INFO_CELL_PACK_COUNT(제외 MEASURE_GROUP 6종, SP:4626-4630) |
| 19 | `@p_sender_code` | ≠ALL: SENDER_CODE 미일치 행 DELETE — 비 EDI 메저 행도 함께 사라짐(SP:3572-3580) |

**결과셋 3개**: ①메인 PIVOT(동적 SQL — 고정컬럼 @ColList=titleset 'C'(없으면 DEFAULT_FLAG='Y')+강제치환 `[VERSION_NO]→[VERSION_SORT],[VERSION_NO]`/`[MEASURE]→[MEASURE_GROUP],[MEASURE],[SORT_ORDER_NO]`/`+[NOTATION]`(SP:3966-3973), 고정컬럼 카탈로그 `#T_COLUMN_SETUP` 약 60종(SP:4008-4111), 기간컬럼 PIVOT SUM ISNULL 0) ②`ISO_WEEK, BASIS_DATE` 1행(당주 계산·색 기준) ③`DATA_ORDER` 정렬문자열 1행(FE DataView.Sort 직결).

**집계 규칙**: MEASURE ∈ (BALANCE, VMI_Inv, AS_Inv, SS_LVL, SS_GAP)=기말값(WEEK/MONTH_END_YN='Y'만) / `LOC`=**AVG** / 그 외 SUM(SP:4700-4725).

**MEASURE(버전 스냅샷) 축**: `#SELECT_MEASURE` = titleset 'M' × SHEET_MEASURE(division 토큰 일치). ⚠ **SP 쓰기 부작용**: 사용자 메저 미설정 시 TITLESET_USER에 DEFAULT INSERT(SP:372-387 — titleset 면역 룰 #115 직결). 행 생성 GUBUN: CURRENT 계획/실적, MF·SF 버전 계획/실적(`*_C`, div82는 VERSION_NO_W="버전(Wxx)"/"(Wxx) (NO PLAN)"), ME(EDI 소급), 합성 MKT_FCST_RP(계획 MKT_FCST+실적 RTF_SYS_RP), SCM_FCST 실적=RTF_SYS_RP 복제, 환산 7종(*_CAR/*_CELL/RTF·MKT_FCST_ENERGY), LOC 판가(SCM_MST_FUTURE_PRICE 주 시작일 매칭), **div82 전용 VMI_INV carry-forward**(SP:4282-4493). CUST_FCST 파생 8종+DM_MST_CUSTOMER_FCST 동적 메저. 시스템 자동추가(SYSTEM_ADD='Y')는 최종 삭제.

**TITLE `DMF0035_GET_SPREAD_TITLE` — 5 IN**(start/end/created_by/division/bucket, 내부 고정 program='DMF0035', sheet='Mkt Fcst Waterfall'). titleset 'C' 유무 분기 + 기간컬럼 생성(D_=CALENDAR_DAY/W_=YYYYMM+ISO_WEEK/M_/ONLY_WEEKLY 전용 W_ partial-week "MM.DD ~ MM.DD" 라벨). 반환 22컬럼(§1 원문 SP:61-82). ⚠ sheet_name 케이스 불일치(GET='MKT FCST Waterfall'/TITLE='Mkt Fcst Waterfall' — MSSQL CI 함정, hook #118).

### §1.C 그리드

- 3단 헤더(AddSheet .cs:435). freeze = **MEASURE 컬럼까지**(`Freeze(0, GetColumnIndex("MEASURE")+1)` .cs:519,609). 고정컬럼 = TITLE SP 순서.
- 3단 병합(SetSpreadHeaderSpan .cs:522-611): 고정컬럼=3행 통합 span / 기간=LARGE(월)→SMALL(주)→일, LARGE/SMALL 변경 시 span+"SUM" 셀. `B_` 포함 컬럼 숨김. ONLY_WEEKLY는 1단 SetSpreadHeader.
- 버킷 토글(SetSpreadColumn .cs:1839-1909): DAILY=D_표시·W_/M_=chkSum / WEEKLY=W_표시·M_=chkSum / MONTHLY=M_만. 버킷 변경 시 (W/M→DAILY, ONLY_WEEKLY 진출입)만 InitSpread 재구성.
- **헤더 더블클릭 드릴다운**(.cs:1631-1681): M_ 헤더→해당 월 W_ 토글 / W_ 헤더→해당 주 D_ 토글(DAILY).
- Footer SUM(.cs:470-487): ColumnFooter "Sum", `SumIgnoreHidden`, `{0:#,##0.###}`, LightGray.
- 색상: 주말 헤더(SAT 파랑/SUN 빨강) / chkColor OFF=당월 M_·당주 W_ 헤더 Green Bold / chkColor ON=행별 실적구간 Gainsboro(버전별 기준일 — CURRENT=min(BASIS_DATE 전주 일요일, To), cutoff=버전명 6~13자리 날짜 전주 일요일, .cs:1290-1372).
- 숫자 표기: 행 단위 NOTATION(INTEGER/POINT/POINT3 — LOOKUP 'DM_MEASURE_POSITIONAL_NOTATION')(.cs:1199-1277).
- SmartColMerge 세로 병합 + TopChange 재병합(.cs:1722-1727). Ctrl+C 클립보드(.cs:1729-1746).

### §1.D 이벤트·버튼 전수

| 이벤트/버튼 | 핸들러 | 동작 |
|---|---|---|
| F5 Find | .cs:1000-1126 | 필수 체크→기간검증→InitSpread→GET(30분 timeout)→Draw |
| F8/F9/F7 | .cs:633-655 | **no-op** (F2 Edit = MSG00109 후 return) |
| F12 Excel | .cs:932-976 | `SimplexelService.ExportFpSpread`(파일명 `DMF0035_yyyyMMddHHmmss.xlsx`) |
| Division/Team/Customer 변경 | .cs:1387-1563 | §1.A cascade |
| Bucket 변경 | .cs:1594-1617 | 조건부 InitSpread+SetSpreadColumn |
| 헤더 더블클릭 | .cs:1631-1681 | 드릴다운 |
| TopChange / KeyUp | .cs:1722-1746 | 재병합 / 클립보드 |
| btnProject/ItemId/Version/Owner/Column/Measure | §1.E | 팝업 |
| txtVersion KeyDown | .cs:2146-2149 | 팝업 오픈 |
| cboQTY/chkSum/chkColor | .cs:2193/1822/1830 | 단위환산/합계토글/색상토글 |

### §1.E 팝업 5종 기능분석 (hook #123 R1)

| 팝업 | 오픈 게이트 | 조회 SP | 반환값 소비 |
|---|---|---|---|
| `SCM0002_ProjectbyDivisionPopupEx`(602행) | 81*/82만(버튼 enabled). 조건 4종 잠금 표시+자동조회 | `SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX`(6 IN — p_dept_id raw ALL 허용 E20260211-001049) | 멀티 CSV ProjectCode → `!=""`일 때만 txtProject(.cs:1765-1768) |
| `DM0002_ItembyDivisionPopupEx`(659행) | **82 계열/ALL/'' + project<3자 & item<3자 → MSG00147 후 즉시 Close**(Ex:173-183). 40이면 Project 라벨 숨김 | `DMF0002_GET_ITEM_BY_DIVISION_POPUPEx`(7 IN, 30분 timeout). 타이틀 program='SCM0002_40' | ItemID 단일/CSV → txtItemId |
| `SCM0002_VersionByWaterfallPopup`(426행) | btnVersion/txtVersion 아무 키. **sCode="MF_SF"**(PJ2025-50188) | `SCM0002_GET_VERSIONBYWATERFALLPOPUP`(p_version_type=`MF_SF_D,MF_SF_W,MF_SF_M`+`ME_S` — chkDay/Week/Month 조합) | 멀티 CSV sVersions+**sPeriod → drpPeriod 덮어쓰기**(.cs:2139-2143) |
| `DM0002_TitleSetForm_Popup`(665행) | btnColumn(C)/btnMeasure(M) — ctor 즉시 조회 | 조회 `DMF0002_GET_TITLESET_POPUP` / 저장 `SCM0002_SET_TITLESET_POPUP`('^' bulk). MSG00020/00093/00006 | OK → InitSpread 재구성. Measure 는 다음 조회 반영 |
| `DM0020_OwnerbyDivisionPopup`(479행) | btnOwner — 게이트 없음, 자동조회 | `DMF0020_GET_OWNER_DATA`(6 IN, p_project_code='' 고정) | **무조건 대입** txtOwner=OwnerID(취소 시 빈값 되는 AS-IS 특성 .cs:2190) |

### §1.F Validation·MSG / 권한 게이트

살아있는 MSG: MSG00109(읽기전용, .cs:647) / MSG00097(Division 미선택, .cs:1017) / MSG00108(**기간 역전** — 기존 validation.md 문구 오기재, .cs:1026) / MSG00164(조회기간 3년 초과 — To 자동 절단, .cs:1030-1036). dead: MSG00003/MSG00100(주석 블록 내). 팝업측: MSG00147/00020/00093/00006.
권한 게이트: Set_ButtonVisibleFalse 0건·권한 LockColumn 0건(무조건 전 컬럼 Lock). NowGroupID는 콤보 lookup 필터와 p_group_id(SP dead) 전달뿐 — **데이터 접근 통제 = 콤보 lookup의 사용자·그룹 필터**.

### §1.G 기존 분석 md 불일치 (정정 사항)

1. analysis.md §11: F7/F8/F9 저장·행추가·삭제 기재 → **실제 no-op** (read-only).
2. "Grid 34 cols 고정" → 실제는 titleset 개인화 동적 + PIVOT 동적 (정적 매핑 코드 금지).
3. validation.md MSG00108 문구/용도 불일치(기간 역전이 실사용), MSG00003 dead code 오집계.
4. expressions.md: footer SUM/NOTATION 포맷/chkColor 회색 실적구간/당주 강조/주말색 전부 누락 — 본 문서 §1.C 가 정본.
5. SP 쓰기 부작용(titleset 'M' DEFAULT INSERT) 미기재 — #115 면역 룰 연동 필요.

### §1.H DMF0035 고유 요소 요약 (GUBUN=MKT FCST 시 표시 대상)

EDI Sender(div '81' 정확일치 시만)·chkColor(opt-in 색칠)·단일 Division 콤보·Cell Qty(40만)·cboQTY 클라이언트 단위환산·ONLY_WEEKLY 버킷·MF_SF 버전 팝업·(dead: p_user_dept_id/p_group_id/SetClbVersion/셀 더블클릭 팝업/구 ExportExcel).

---

## §2. DMF0022 Sales Plan Waterfall — 상세 (원소스 전문 정독)

정본: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0022_SalesPlanWaterfall\DMF0022_SalesPlanWaterfall.cs`(2,769행, 이하 `.cs`) + `.Designer.cs`(1,801행, `D.cs`). SP 원문 = GET 2,627행 / TITLE 445행(라인=덤프 기준). **조회 전용** — ReadOnlySheetList(.cs:310)+조회 직후 전 컬럼 Lock(.cs:1166)+Edit=MSG00109(.cs:697). MSG 실문구 = AS-IS `TB_FX_MessageInfo` 실측.

⚠ `DMF0022_SalesPlanWaterfall2` 폴더(Shipment.UIL, 2,427행, `..._WATERFALL2` SP)는 **별개 레거시 사본** — TO-BE 정본은 Forms.UIL\Plan 판. 분석 md 폴더의 Waterfall2 는 archive 대상 후보.

### §2.A 조회조건 (전 항목)

| 컨트롤 | 라벨 | 유형 | 기본값 | 데이터 원천 | cascade / 특이 | SP 파라미터 |
|---|---|---|---|---|---|---|
| `clbDivision` | Division | UsrCombo 단일 | 첫 항목 | `MyDivision`(GROUP_ID=NowGroupID+USER_ID)(.cs:243-252) | Team/BizType/Customer/SalesSite/PlantSite 전체 재조회+Project/Item/Owner/Version 클리어+InitSpread(.cs:1499-1628). **div=40: Project·PlantSite disable+클리어, CellQty enable**(.cs:348-357) | `p_division_id` |
| `clbTeam` | Team | UsrCheckedList(ALL) | ALL | `UserTeamByDivision`(.cs:253-259) | Customer→SalesSite 재조회(.cs:2599-2637) | `p_dept_id` |
| `clbCustomer` | End Customer | UsrCheckedList(ALL) | ALL | `EndCustomerByDivision`(.cs:260-267) | SalesSite 재조회(.cs:2308-2321) | `p_end_customer` |
| `clbItemType` | Item Type | UsrCheckedList(ALL) | ALL | `SCM0001_GET_LOOKUP_VALUES('ITEM_TYPE_CODE')`(.cs:2151-2163) | — | `p_item_type` |
| `clbBizType` | Biz.Type | UsrCheckedList(ALL) | ALL | `BizType`(div)(.cs:268-274) | Division 종속 | `p_biztype` |
| `InternalYN` | "Include Internal Txn" | UsrCheckBox | N — **Visible=false**(D.cs:1188) | — | **DMF0022 전용**(0035/0051 부재) | `p_internal_yn` |
| `clbSalesSite` | Sales Site | UsrCheckedList(ALL) | ALL | `UserSiteByEndCustomer`(.cs:275-283) | 변경 핸들러=`SetClbVersion()` no-op(dead)(.cs:1630-1660) | `p_scm_site_id` |
| `txtProject`+btn | Project | 텍스트+팝업(Enter=팝업) | '' | Project 팝업 | div=40 disable+클리어 | `p_project_code` |
| `txtItemId`+btn | Model/Nickname | 텍스트+팝업 | '' | Item 팝업 | — | `p_item_id` |
| `txtOwner`+usrButton1 | Owner | 텍스트+팝업 | '' | Owner 팝업 | — | `p_owner` |
| `drpPeriod` | Period* | UsrDateRangePickerWtWeek | `PR_GET_DAY_RANGE`(p_month=6)(.cs:2101-2115) | Version 팝업 sPeriod 로 덮어씀(.cs:2710) | 시작>종료 MSG00108/3년 초과 MSG00164 | `p_from/p_to` + **FE 계산 `p_now_yyyymmdd`**(§2.B) |
| `clbPlantSite` | Plant Site | UsrCheckedList(ALL) | ALL | 초기 `UserPlantSiteByEndCustomer` / **Division 변경 시 `UserPlantSiteByDivision`**(.cs:292-298,1595-1599) | div=40 disable | `p_plant_site_id` |
| `txtVersion`+btn | Version* | 텍스트+팝업(KeyDown) | '' | **`DMF0073_VersionBySalesPricePopup("SP")`** — 2024-06-18 부로 SCM0002 팝업 교체(.cs:48,2688-2703) | 선택 시 Period 동기 | `p_version_type` |
| `cboKRW`/`cboUSD`/`cboLOC` | KRW/USD/LOC | UsrCombo ×3 | index 0(=1) | `SALES_PLAN_AMOUNT_KRW/USD/LOC`(.cs:414-419) | **클라이언트 표시 환산 전용**(SetAmountCalculating .cs:2362-2597 — 금액 3계+수량 8종 ÷1/1k/1M/100M) | (전달 없음) |
| `cboQTY` | QTY | UsrCombo | index 0 | `DMF0003_GET_QTY_TYPE_CODE`(.cs:2251-2262) | 동일 | (전달 없음) |
| `cboBucketType` | Bucket | UsrCombo | **MONTHLY**(.cs:445) | `DMF0003_GET_REPORT_BUCKET_TYPE_CODE` — DAILY/WEEKLY/MONTHLY/ONLY_WEEKLY(.cs:192-198) | 전환 조합별 InitSpread/SetSpreadColumn(.cs:1662-1686) | `p_bucket` |
| `chkSum` | Sum | UsrCheckBox | N | — | ONLY_WEEKLY 시 강제 해제·disable(.cs:504-507) | (표시 토글) |
| `chkMem` | Color | UsrCheckBox | N | — | 실적구간 Gainsboro(§2.C) | (클라이언트) |
| `cboCellQty` | Cell Qty | UsrCheckBox | N — **Visible=false**(D.cs:1226)·div40만 Enabled·이탈 시 해제(.cs:1571-1572) | — | — | `p_cell_yn` |
| `btnColumn`/`btnMeasure` | 아이콘("Column Show"/"Measure") | 버튼 | — | TitleSet 팝업 | OK 시 InitSpread(true) | (titleset) |

숨은 파라미터: `p_created_by`=UserId / `p_user_dept_id`=Dept_ID / `p_group_id`=NowGroupID(.cs:1136,1145-1146).

### §2.B 조회 SP 계약

**GET `DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL` — IN 20**(FE 전달도 20 — 사내 PKG 22 IN 은 P_USER_ID/P_MENU_ID 추가분):

- 필터 7종(`p_dept_id/end_customer/scm_site_id/plant_site_id/item_type/biztype`): 'ALL' 아니면 String_Split→LEFT-JOIN-NULL DELETE(sql:1110-1241). **div40 특칙**: end_customer→PROJECT_CODE(1181-1187), biztype→FORECAST_INFO_BIZ_TYPE(1225-1232), dept→ETC=ATTRIBUTE1(1143-1148).
- LIKE 3종(`p_project_code/item_id/owner`): 코드+명/닉네임/오너명 KO·EN(1074-1108).
- **`p_now_yyyymmdd` = FE 계산**: 이번주 월요일, 단 from≥이번주월요일→from, to<now→to+1일(.cs:1077-1081). **실적/계획 경계** — TO-BE sales-plan-waterfall 의 `dayjs()` 단순 대입은 오구현(§2.H-2).
- `p_created_by`: titleset 키. **메저 'M' 0건이면 DEFAULT INSERT 부작용**(sql:227-248 — #115 계보, 0035·0051 과 공통).
- `p_internal_yn`: 'Y' 아니면 사내거래처(SCM_MST_COMPANY_SN) 행 DELETE(783-787); div82 실적은 ATTRIBUTE2 내부수량 가산(504,616).
- `p_cell_yn`: 'Y'면 QTY를 `FN_GET_DM_SALES_PLAN_WATERFALL_QTY2` 환산(2472-2483).
- `p_version_type`: 콤마 다중 — `(` 앞 절단 후 #V_VERSION_NO(162-174). `%CURRENT%`→라이브(DM_PLN_SALES_PLAN+ETC+실적 DM_PLN_SALES_PLAN_RESULT, 446-513) / `%SP_%`→컷오프 `_C` 3종(실적경계=CUTOFF 차주월요일-7일, 520-637). div82 는 말미 버전명 `(Wnn)`/`(NO PLAN)` 재가공(2434-2449).
- `p_bucket`: PIVOT 컬럼·집계 분기(1770-1806, 2520-2560).
- `p_user_dept_id`/`p_group_id`: **선언만(JV Planner 주석) — 본문 미사용** (0035 와 동일한 dead 쌍).

MEASURE 축: 사용자 'M'×SHEET_MEASURE division 교집합(258-274) + TMM_FCST 는 LOOKUP 'TMM_MEASURE_ADMIN' 권한자만(291-300) + **ATTRIBUTE5/6/7 룩업 기반 시스템 메저 자동 추가**(374-409, 하드코딩 폐지) + 파생 환산(RP_CAR/RP_CELL/RTF_ENERGY/MKT_FCST_ENERGY, 1673-1742) + 실적 Price=SalesAmt÷RTF_SYS_RP(1255-1353) + 계획 Price=div40 `DM_PLN_CFM_SELLING_PRICE(_C)` / 타 `SCM_MST_FUTURE_PRICE(_C)`(1363-1662) + div40 전용 RTF 재배분 MERGE(2109-2430). SYSTEM_ADD='Y' 최종 삭제.

**OUT 결과셋 3개**: ①메인 동적 PIVOT — 고정컬럼 사전 `#T_COLUMN_SETUP` **55종**(INTERNAL_YN=LEN(SCM_SITE_ID) 3~5→'Y' 파생/SCP_USE_YN/FROM_SITE_ID/CELL_PROD_SITE_ID 포함, 1979-2079), `[VERSION_SORT]` 치환+`[NOTATION]`+SORT_ORDER_NO+버킷 컬럼(D_/W_/M_, ONLY_WEEKLY=W_만). 주간/월간 집계는 **KRW/USD/LOC(단가)만 AVG**, 나머지 SUM(2532-2542) ②오늘 `ISO_WEEK, BASIS_DATE` ③동적 SQL XML dump(디버그).

**TITLE `DMF0022_GET_SPREAD_TITLE` — 5 IN**(start/end/created_by/division/bucket). 단일 결과셋 23컬럼. 'C' titleset 분기 + 숨김(VISIBLE_FLAG='N') UNION + 달력 버킷 컬럼. ONLY_WEEKLY W_ 라벨 = `MM.DD ~ MM.DD` + 폭 100.

### §2.C 그리드 (0035 대비 차이)

골격 동일(3단 헤더 AddSheet(...,3,1,45)/MEASURE+1 freeze/버킷 토글/헤더 더블클릭 드릴/당월·당주 Green Bold/chkMem Gainsboro(CURRENT=전주 일요일·컷오프=버전일 전주 일요일 .cs:1387-1476)/footer SumIgnoreHidden `{0:#,##0.###}`/SmartColMerge+TopChange/NOTATION 행 포맷/B_ 숨김/Ctrl+C).
**차이**: ①KRW/USD/LOC 금액 콤보 3종+SetAmountCalculating(0035 는 cboQTY 뿐) ②InternalYN 전용 ③Version 팝업=DMF0073("SP") ④원천 테이블 DM_PLN_SALES_* 계열 ⑤CELL_PROD_SITE_ID 셀 수직 중앙정렬(.cs:1371-1378).

### §2.D 이벤트·버튼 전수

F5 FindData(30분 timeout)/F8·F9·F7 no-op/F2=MSG00109/F12 `ExportFpSpread`(HideZero/ShowZero, 구 ExportExcel 717-986 전체 주석 dead)/Division cascade(.cs:1499-1628)/Team·Customer cascade/Bucket 전환(.cs:1662-1686)/chkSum·chkMem/통화·QTY 콤보 환산/헤더 더블클릭 드릴(.cs:1700-1748)/TopChange 재병합/KeyUp 클립보드/txtVersion KeyDown 팝업/`spdMain_ComboSelChange`(사문)/FormClosed GC.

### §2.E 팝업

공유 4종(Project/Item/TitleSet(program='DMF0022', sheet='Sales Plan Waterfall')/Owner) = §1.E 와 동일 계열.
**Version(현행) = `DMF0073_VersionBySalesPricePopup`**: `Form_Load(true,"SP",div,from,to)` → `DMF0073_GET_VERSION_SALESPRICE`(p_version_type=`SP_D,SP_W,SP_M` 체크 조합) → 다중 sVersions+sPeriod(Period 덮어쓰기). 구 `SCM0002_VersionByWaterfallPopup` 은 주석 처리(미사용) — 단 그 SP 는 version_type 4분기(`EC*`/`BP`/`MF_SP_SF*`/`MF_SF*`/else=SP) 지원, OUT 9컬럼(CODE/VERSION_NO/DESC/TYPE/EDI_APPLY/VER_CRE_SEQ/YYYYMMDD/CREATED_BY/CREATION_DATE).

### §2.F Validation·MSG (실문구 실측) / 권한

| MSG | 조건 | 실문구(KO) |
|---|---|---|
| MSG00137(.cs:1047) | 조회 중 재조회(blnWork) | "전 작업이 아직 실행 중입니다." |
| MSG00108(.cs:1063) | From > To | "시작일자가 종료일자보다 늦을 수 없습니다." |
| MSG00164(.cs:1070) | 3년 초과(To 보정 후 중단) | "조회 기간은 3년 이상 설정 할 수 없습니다." |
| MSG00097(.cs:1100) | division='' | "권한을 가진 Division이 없습니다." |
| MSG00109(.cs:697) | Edit 시도 | "읽기 전용입니다." |

MSG00003 = dead(주석 블록). 권한: 콤보 원천 전부 GROUP_ID=NowGroupID+USER_ID 스코프 — 화면 내 그룹분기 0건, 유일 UI 분기=div40↔기타.

### §2.G 기존 분석 md 불일치 (정정)

1. Waterfall2 폴더 = 별개 레거시 사본(§2 서두).
2. validation.md MSG 문구 3건 오기(00137/00108/00097 — §2.F 실측이 정본), MSG00003 dead 를 유효 집계(41→40건).
3. analysis.md §4 endpoint 오귀속 다수(팝업 버튼='PR_GET_DAY_RANGE' 등), §11 F7/F8/F9 저장·행추가 서술은 no-op 실체와 불일치.
4. 2024~2026 변경분(DMF0073 팝업 교체/E20250529-001488/PJ2025-50017·50188 CELL_PROD_SITE_ID·FROM_SITE_ID·SCP_USE_YN) 8종 md 전부 미반영.

### §2.H TO-BE sales-plan-waterfall 완성도 매트릭스 (골격 재사용 판단 근거)

구현됨: 조회조건 렌더링 전부+Division cascade 초기화/콤보 9종 배선/FindData 검증 4종/filters 20-key+titleFilters 분리+참조비교/SPREAD_TITLE 동적 컬럼(B_ 제외·3단 라벨)/팝업 3종/ONLY_WEEKLY Sum 해제/CellQty div40 disabled/hotkeyConfig CUD 숨김.

**TODO 9건**(소스 명기): F1 Version 모달(DMF0073) / F4·F5 InternalYN·CellQty Visible=false 정책 / F7 Bucket·QTY·ItemType 콤보 options=[] / F8 콤보 ID casing / F9 chkMem Gainsboro / F12 헤더 드릴 / F15 통화·QTY 환산 / F16 footer SUM / S4 5종(주말·당주 Green/NOTATION/freeze/LockColumn/버킷 토글).

**오구현·누락(TODO 미표기) 8건**: ①userDeptId/groupId 고정 빈값(AS-IS=Dept_ID/NowGroupID) ②**nowYyyymmdd=dayjs() — AS-IS 이번주 월요일+경계 보정 미구현(실적/계획 경계 오차, 차단급)** ③Division 변경 시 project/item/owner/version 클리어 누락 ④div40 Project/PlantSite disable+CellQty 리셋 누락 ⑤PlantSite division 변경 시 `UserPlantSiteByDivision` 미전환 ⑥MSG ID 전부 미배선(fallback) ⑦Version 선택 시 Period 덮어쓰기 부재 ⑧SmartColMerge 근사(TopChange 재병합 미검증).
→ **차단급 = F1·②·F7·S4(freeze/토글)** — 통합 UI 는 TODO 승계 금지(플랜 Phase C 원칙).

## §3. DMF0051 Biz Plan Waterfall — 상세 (원소스 전문 정독)

정본: `GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0051_BizPlanWaterfall\DMF0051_BizPlanWaterfall.cs`(1,881행) + `.Designer.cs`(1,802행). SP 원문 = GET 1,296행 / TITLE 384행(라인=덤프 기준). **조회 전용**(ReadOnlySheetList cs:194 + 전 컬럼 Lock cs:633 + Edit=MSG00109 cs:442). 구조상 0022 축소 클론 — 아래는 0022 대비 차이 중심.

### §3.A 조회조건 (0022 와의 차이 확정)

컨트롤 셋은 0022 와 거의 동일하되:
- **0051 에만 있음**: `cbxQty` "Qty≠0" 체크박스(D.cs:1186) → `p_qty_yn` — 'Y'면 Business_Plan SUM(QTY)=0 차원조합 전체 DELETE(sql:844-873).
- **0051 에 없음**: InternalYN(`p_internal_yn`) — 0022 전용.
- Version 팝업 = `SCM0002_VersionByWaterfallPopup.Form_Load(true,"BP",...)` + monthChecked(true)(cs:1766-1785) — BP 컷오프 버전 다중 + sPeriod 로 Period 동기(cs:1783). (0022=DMF0073 "SP", 0035=SCM0002 "MF_SF")
- Bucket 콤보 원천 = `SCM0001_GET_LOOKUP_VALUES('BUCKET2_TYPE_CODE')`(cs:1346-1357) — **M/Q/Y 계층**(0022/0035 의 DAILY~ONLY_WEEKLY 와 다름). 기본 MONTHLY(cs:318). **버킷 변경=SetSpreadColumn 가시성만, 재조회 없음**(cs:932-954).
- BizType 원천: div40=`Data.Common(DM_BIZ_TYPE)` / 그 외 `SCM0001_GET_BIZ_TYPE_BY_DIVISION`(cs:225-247).
- 금액 콤보 3종(KRW/USD/LOC)+cboQTY = 0022 동일 클라이언트 환산(SetAmountCalculating cs:1482-1718). Period 필수+**10년 초과 MSG00164**(주석은 "2년"이나 실제 10년, cs:532-540).
- Version* 필수(checkRequiredOfSearch 마크). div40: Project·PlantSite·BizType disable + CellQty enable(cs:819-848).

### §3.B 조회 SP 계약

**GET `DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL` — IN 17**(dump:20-37). ⚠ **FE 는 20키 전송(cs:590-611) 중 `p_bucket`/`p_user_dept_id`/`p_group_id` 3개가 SP 시그니처에 없음**(FoxQuery 정의 17개=SP 일치) — 버킷 전환은 서버 미반영(항상 월+분기+연 3계층 전부 반환, FE 가시성 토글만).

- `p_version_type`: `CURRENT`+`BP_*` 콤마 — CURRENT→**`DM_PLN_BP_FCST`(라이브)** / BP_*→**`DM_PLN_BP_FCST_C`(컷오프)**. 월(M_YYYYMM) INSERT→분기(Q_YYYY_Q)→연(Y_YYYY) 3단 롤업. 롤업 집계: `SalesAmt_KRW/LOC/USD, Business_Plan`=SUM, **그 외 measure=MAX**(단가 보존)(dump:196-477).
- titleset 'M' 자동 시드(0건 시 DEFAULT INSERT — 3화면 공통 부작용, dump:104-152).
- 필터=선적재 후 DELETE 방식(dump:680-875): dept=Team Mapping 기준/div40 end_customer=PROJECT_CODE/biztype div40=FORECAST_INFO_BIZ_TYPE 정확일치·그 외 LIKE/`p_qty_yn` 0행 제거.
- `p_now_yyyymmdd`: **수신만 하고 본문 미사용**(0022 와 달리 실적경계 개념 없음 — BP 는 실적 테이블 자체가 없음).
- 아이템 마스터 3단 분할 temp(`_ORI_V/_A_V/_B_V`→`#TEMP_DM_MST_ITEM_SINGLE_V`+CLUSTERED INDEX, ITEM_TYPE P>H>Q>R MIN 트릭, dump:505-625). `#T_PRICE` 미사용 잔재.
- 동적 컬럼: `c_bucket` FAST_FORWARD 커서로 M_/Q_/Y_ PIVOT 리스트(dump:900-937), 고정컬럼 'C' titleset 분기+`[VERSION_SORT]` 치환(CURRENT='ZZZ…' 최상단 DESC)+`[SORT_ORDER_NO],[MEASURE]`(dump:940-1016). `#T_COLUMN_SETUP` 사전 **45항**(END_CUSTOMER40=PROJECT_CODE, MODULE_PER_CAR 등, dump:1032-1098).
- 동적 본문: div40=SCM_MST_SITE INNER JOIN(그 외 LEFT), GROUP BY 시 `LOC/USD/KRW` measure=MAX·그 외 SUM → PIVOT SUM(QTY)(dump:1124-1241).

**OUT 결과셋 3개**: ①피벗 본문(고정컬럼+SORT_ORDER_NO+M_/Q_/Y_ 전체) ②오늘 `ISO_WEEK, BASIS_DATE`(chkMem 기준일, cs:670) ③실행 SQL XML(디버그).

**TITLE `DMF0051_GET_SPREAD_TITLE` — 5 IN**(`p_bucket` 수신만·미사용 — 항상 3계층 생성). 'C' titleset 분기+숨김 UNION+달력 버킷(M_=MONTH_NAME·소분류 Q·대분류 연/Q_/Y_, 폭 50·FPNumber·소수3·우정렬, dump:136-210). div81%/82 는 ATTRIBUTE4/5='Y' 컬럼 `*` 접미(dump:45-53). ⚠ ELSE 분기 Quarterly SORT_ORDER_NO **별칭 누락**(dump:358-362) — Oracle 재변환 시 별칭 명시 필요.

### §3.C 그리드 (0022 대비 차이)

골격 동일(3단 헤더 AddSheet(...,3,1,45) cs:346/MEASURE freeze cs:1230/footer SumIgnoreHidden cs:392-409/헤더 더블클릭=**월↔분기 접기** cs:1019-1068/현재 월·분기·연 헤더 녹색 cs:1270-1308/SmartColMerge/TopChange/Ctrl+C·V — MEASURE 이후 열만).
차이: ①메타 키 program='DMF0051'/sheet=**"Biz Plan Waterfall"** ②chkMem 기준일: CURRENT=BASIS_DATE **전월**, BP_* 행=`VERSION_NO.Substring(5,8)` 컷오프일 전월(cs:668-721) — BP 버전명 포맷 `BP_M_YYYYMMDD_Vnnn` 의존 ③버킷=M/Q/Y(D_/W_ 없음). 잔재: `spdMain_ComboSelChange` DIVISION 교체 로직(cs:957-984, 사문)·`SetClbVersion` 빈 함수.

### §3.D 이벤트·Validation·권한

F5 FindData(30분 timeout, 검증 5건)/F8·F9·F7 no-op/F2=MSG00109/F12 ExportFpSpread(E20241004-000997)/cascade(§3.A)/FormClosed GC.
MSG: MSG00137(중복조회)/silent 필수체크(Period*·Version*)/MSG00108(기간 역전)/MSG00164(10년 초과 — To +10y 보정)/MSG00097(Division)/MSG00109(Edit)/0행·MEASURE 빈값 silent. **기존 validation.md 문구 오매핑**(00137·00108 — §2.F 실문구가 정본).
권한 게이트: 화면 자체 분기 0건 — 콤보 원천의 사용자·그룹 스코프가 전부(p_user_dept_id/p_group_id 는 SP 미수신).

### §3.G 기존 분석 md 불일치 (정정)

1. analysis.md·source_links.md·oracle_migration.md 에 **DMF0051_1_* endpoint 6본 혼입**(prefix 자동매칭) — 0051 실호출은 GET/TITLE 2본+공통 6본뿐.
2. analysis.md §4 API 오귀속(팝업 버튼='PR_GET_DAY_RANGE'/Bucket=TITLE+InitSpread — 실제 SetSpreadColumn 만).
3. §11 F7/F8/F9 저장 서술 — 실제 no-op·읽기전용.
4. §7 참조 테이블 파싱 잔재 토큰(`34.221`, `A`, `B`).
5. oracle_migration.md GET "Params 1" 오기(실측 17) — TO-BE PROC_M 은 17+표준 2(P_USER_ID/P_MENU_ID) 기준.
6. expressions.md 누락: footer/환산 나눗셈/현재 버킷 녹색/chkMem 구간식.

### §3.H DMF0051_1 편집형 기능 인벤토리 (2차 보류 — 기록만)

파일: `Plan\DMF0051_1_BizPlanWaterfall\DMF0051_1_BizPlanWaterfall.cs`(4,686행) + `DMF0071_BPCutOffPopup.cs`. 조회 SP=`DMF0051_1_GET_...`/`DMF0051_1_GET_SPREAD_TITLE` 별개.

| 기능 | 흐름 |
|---|---|
| **Confirm BP**(btnConfirmBP, cs:4047-4084) | Division+Version(앞 23자) → `DMF0051_1_BIZPLAN_TO_BPS` — `XIF_DM_PLN_BIZPLAN_S_SN` DELETE+INSERT(BPS 인터페이스) 후 `DM_PLN_BIZPLAN_C.TRANSFER_FLAG='Y'` |
| **Release(SCP)**(btnReleaseSCP, cs:4005-4045) | `PR_DM_PLN_BIZPLAN_TO_NET_DEMAND`(div, version) — BP→NET DEMAND 다단 전개+PR_SCM_SYS_LOG_BATCH 로깅 |
| **BP CutOff**(btnBPCutOff, cs:4676-4683) | `DMF0071_BPCutOffPopup` — 목록 `DMF0071_GET_BPCUTOFF_LIST`/RTF 버전 `DMF0071_GET_RTF_VERSION`/MakeCutOff=`DMF0071_SAVE_BPCUTOFF` → 내부 `DMF0051_1_TRANSFER_TO_BIZPLAN`→`_BIZPLAN_CUTOFF`→`_CREATE_RTF_MEASURE` 순차 EXEC(스냅샷 버전 생성) |
| **SAVE**(cs:2427-2885) | 필수 MSG00113→Action='M' M_ 컬럼 수집→중복 MSG00043→키·값 `^` 연결 19파라미터 `DMF0051_1_SAVE_DM_PLN_BIZ_PLAN_WATERFALL`(timeout 1,000초)→BEGIN TRAN 내 Conf/Price/Amt MERGE 재계산 후 **MERGE INTO DM_PLN_BIZPLAN_C**→MSG00004+재조회 |
| **편집 셀 범위**(cs:439-688) | 고정컬럼 잠금/현재 Bucket 계열만 해제/EDIT_FLAG='Y'×div81·82=Business_Plan·RTF·BizPlanPrice·SalesAmt 계열 당해년도 이후 잠금(div40 은 BizPlanPrice_Cur 제외 동일)/그 외 measure=TRANSFER_FLAG='Y' 행 잠금/Conf 소수점 `.000` 강제+MSG00289 |

참고: FoxQuery 의 `DMF0051_1_GET_BIZPLAN_CONF/_GET_BIZPLAN_RTF` 는 UI 직접 호출 0건(SP/배치 소비 추정 — 2차 시 확인). 확장판 validation.md(143건)는 2차 편집 구현 시 전수 대사 대상.

## §4. 3화면 공통·차이 매트릭스 + GUBUN 전환 설계

### §4.1 공통 골격 (3화면 동일 — 통합 UI 의 불변부)

조회 전용(전 컬럼 잠금, F7/F8/F9 no-op, F2=MSG00109) / 단일 Division 콤보(MyDivision, 필수 MSG00097) + Team→Customer→SalesSite cascade / Project·Item·TitleSet(C·M)·Owner 팝업 4종 공유 / Period 기본 6개월(PR_GET_DAY_RANGE) / titleset 'C'(고정컬럼)·'M'(메저) 개인화 + **'M' 0건 시 SP 가 DEFAULT INSERT 하는 쓰기 부작용**(3 SP 공통 — #115) / 결과셋 3개(메인 PIVOT + ISO_WEEK·BASIS_DATE + 디버그) / 행 축 = VERSION_NO(CURRENT='ZZZ…' 최상단 DESC)×MEASURE(SORT_ORDER_NO) / 3단 헤더 병합+MEASURE 까지 freeze+footer SumIgnoreHidden `{0:#,##0.###}`+B_ 숨김+NOTATION 행 포맷+SmartColMerge / chkSum·chkColor(Gainsboro 실적구간)·당기 버킷 Green Bold / dead 쌍 p_user_dept_id·p_group_id(0051 은 아예 미수신).

### §4.2 차이 매트릭스 (GUBUN 전환 시 가변부)

| 항목 | MKT FCST (0035) | SALES PLAN (0022) | BIZ PLAN (0051) |
|---|---|---|---|
| GET SP IN | **19** | **20** | **17** (p_bucket/user_dept/group 미수신) |
| TITLE SP IN | 5 (sheet='Mkt Fcst Waterfall') | 5 ('Sales Plan Waterfall') | 5 ('Biz Plan Waterfall', p_bucket 미사용) |
| 버킷 체계 | DAILY/WEEKLY/MONTHLY/ONLY_WEEKLY (D_/W_/M_) | 동일 | **MONTHLY/QUARTERLY/YEARLY (M_/Q_/Y_)** — BUCKET2, 서버 미반영(FE 토글만) |
| p_now(실적경계) | SP 내부 산출(당주 월요일) | **FE 계산 전달**(월요일+보정) | 수신만·미사용 |
| Version 팝업 | SCM0002 "MF_SF" (MF_SF_D/W/M+ME_S) | **DMF0073 "SP"** (SP_D/W/M) | SCM0002 "BP" (month 고정) |
| 고유 조회조건 | EDI Sender(div81 정확일치만)·Cell Qty(40만)·cboQTY 만 | InternalYN(hidden)·통화 KRW/USD/LOC 3콤보+cboQTY·Cell Qty(hidden) | cbxQty "Qty≠0"·통화 3콤보+cboQTY·Cell Qty |
| 원천 테이블 | DM_PLN_MKT_FCST(_C) / div40=DM_PLN_CFM_MKT_DEMAND_PLAN(_C) | DM_PLN_SALES_PLAN(+ETC+RESULT, _C 3종) | DM_PLN_BP_FCST(_C) |
| 버전 접두 | CURRENT/MF_/SF_(+ME) | CURRENT/SP_ | CURRENT/BP_ |
| 집계 특칙 | BALANCE류=기말값·LOC=AVG·그외 SUM | KRW/USD/LOC 단가=AVG·그외 SUM | 롤업 시 금액·Business_Plan=SUM·그외 MAX / 최종 LOC·USD·KRW=MAX |
| 고정컬럼 사전 | ~60종 | 55종 | 45항 |
| chkColor 기준일 | 전주 일요일(CURRENT=min(BASIS_DATE 전주일, To)) | 전주 일요일 | **전월**(CURRENT=BASIS_DATE 전월/BP=버전일 전월) |
| 헤더 드릴 | M_→W_→D_ | 동일 | M_↔Q_ 접기 |
| 사내 Oracle PKG | GET만(TITLE standalone→합류 패치 생성됨) | 완비(PROC_M 25행) | TITLE만(**GET 재변환 필요**) |

### §4.3 GUBUN 전환 설계표 (TO-BE)

`GUBUN = { MKT_FCST, SALES_PLAN, BIZ_PLAN } as const`, store 초기값 **MKT_FCST**. 전환 = ①PROC_M 시트 스위칭(3시트) ②조회조건 표시 토글 ③버킷 콤보 스왑 ④Version 모달 타입 스왑 ⑤그리드 재초기화(Division 변경 Grid reset 표준 준용).

| 조회조건 | MKT_FCST | SALES_PLAN | BIZ_PLAN | 비고 |
|---|:-:|:-:|:-:|---|
| Division/Team/Customer/SalesSite/PlantSite/BizType/ItemType/Project/Item/Owner/Period/Version/Bucket/Sum/Color/Column·Measure 버튼 | ✓ | ✓ | ✓ | 공통(cascade 동일) |
| EDI Sender | ✓(div81만 enabled) | — | — | |
| Cell Qty | ✓(div40만) | AS-IS hidden → **통합도 비표시**(파라미터 'N' 고정) | ✓(div40만) | 0022 는 D.cs Visible=false 실측 |
| Include Internal Txn | — | AS-IS hidden → **비표시**(p_internal_yn='N' 고정) | — | 정책 확정 필요 시 사용자 확인 |
| 통화 KRW/USD/LOC 콤보 | — | ✓ | ✓ | 클라이언트 환산 |
| QTY 콤보 | ✓ | ✓ | ✓ | 클라이언트 환산 |
| Qty≠0 | — | — | ✓ | p_qty_yn |
| Bucket 콤보 원천 | REPORT_BUCKET(D/W/M/OW) | 동일 | **BUCKET2(M/Q/Y)** | GUBUN 전환 시 콤보 자체 스왑 |
| Version 모달 | Waterfall "MF_SF" | SalesPrice "SP" | Waterfall "BP" | sPeriod→Period 덮어쓰기 3화면 공통 |
| Version 필수 여부 | 선택(''=CURRENT) | 필수* | 필수* | 0035 만 비필수 |
| 기간 상한 | 3년(MSG00164) | 3년 | **10년** | GUBUN별 분기 |

파라미터 매핑(시트별 PROC_M): 공통 14종 + 고유 — 0035:`p_version_no`+`p_sender_code`+`p_cell_yn` / 0022:`p_version_type`+`p_now_yyyymmdd`(FE 월요일 보정 산식 의무)+`p_internal_yn`+`p_cell_yn`+`p_bucket` / 0051:`p_version_type`+`p_qty_yn`+`p_cell_yn`(p_bucket·p_now 미전달 또는 무시). dead 쌍(p_user_dept_id/p_group_id)은 TO-BE 계약에서 제외(사내 PKG 표준 P_USER_ID/P_MENU_ID 로 대체).

## §5. TO-BE 매핑 (Wijmo OLAP)

- 화면: `features/report/src/pages/demand-plan-waterfall/` 신설(DMF0035). sales-plan-waterfall 골격 재사용하되 **§2.H 의 TODO 9건+오구현 8건 승계 금지** — 차단급(Version 모달/p_now 월요일 보정/Bucket 콤보/freeze·토글)은 본 문서 §1~§3 근거로 정식 구현.
- 그리드: 공용 `OlapPivotGrid`(`@shared` organisms — PivotEngine autoGenerateFields:false) + `unpivotWideRows`(wide 커서→long). rows=키축(titleset 'C' 순서)+MEASURE, columns=PERIOD(버킷별 D_/W_/M_ 또는 M_/Q_/Y_ — TITLE SP 의 lCls/sCls 계층으로 3단 대체), values=QTY(sum), valueFormats 소수3. 버전축은 rows 최상위(VERSION_SORT DESC). footer 합계=showColumnTotals. Excel=OlapPivotGridRef.exportExcel.
- 표시 규칙 이식: NOTATION 행 포맷/당기 Green/chkColor Gainsboro(기준일 GUBUN별 — 주 vs 월)/주말색은 OLAP 헤더 커스터마이징 단계 적용(1차 필수=NOTATION·잠금·당기 강조, 주말색·드릴은 OLAP 계층 접기로 대체 가능 여부 구현 시 판정).
- DB: PKG_DMF0035 TITLE 합류(패치 생성됨)+PKG_DMF0051 GET 재변환(§3.B 계약 17 IN — TITLE ELSE 분기 별칭 누락 정정 포함)+DS2 표준(`optimizer_dynamic_sampling=2`)+PKG_DMF0022 무변경 재사용.
- 메타: MNU DMF0035 'Demand Plan Waterfall'+ROUTE_PATH='report/demand-plan-waterfall' / PROC_M 3시트(실측 시그니처 1:1) / SHEET_COLUMNS·SHEET_MEASURE 3 GUBUN 시트(AS-IS 메타 이관) / GUBUN CMBO 신설 / MSG 4종+α(#114 실문구 — §2.F 실측 문구 사용).
- 검증: 3 GUBUN×대표 division 조회 SP 실측 ↔ 화면 대조, 본 문서 §1.G/§2.G/§3.G 정정 사항 반영 카운트 일치(#123).

