# DMF0003 (MktFcst / 시장예측) 상세 분석서 v2.0

> **작성일**: 2026-06-15 · **baseline**: 이전 UI분석서 v1.7 후속 (신 상세분석 포맷)
> **성격**: AS-IS 최신 소스 ↔ DB / PKG / SP / LOOKUP **데이터 수준 연계** 상세 분석. 짝 산출물 = `DMF0003_MktFcst_제약매트릭스_v2.0.xlsx` (Division/권한/Measure/FCST_TYPE 매트릭스).
> **정본 소스**: `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Plan.UIL/DMF0003_MktFcst.cs` (5,920줄) + `DMF0003_MktFcst.Designer.cs`
> **실 데이터**: 사내 Oracle(SCM_MGR@OCGSCMD_P01) 직결로 LOOKUP / SHEET_MEASURE / SHEET_COLUMNS 실 row 추출(2026-07-16 실측).

---

## 1. 개요 · 화면 구분

DMF0003 은 **시장예측(MKT Forecast) 입력·조회 화면**이다. 사업부(Division)·기간·고객 등으로 조회하면, 좌측 식별 컬럼 + 우측 기간(일/주/월) 피벗 컬럼으로 수량을 보여주고, 편집 권한이 있는 경우 셀 수량을 고쳐 저장한다. 실적/계획을 함께 모니터링하며, 저장 시 SSP(공급계획)와 동기화된다.

### 화면 구분 (반드시 별개로 이해)

| 구분 | 소스 | 성격 | 본 분석 대상 |
|---|---|---|---|
| **DMF0003** (정본) | `GSCM.DM.Plan.UIL/DMF0003_MktFcst.cs` (5,920줄) | 평문 = **TO-BE 구현 기준** (PSI/Car 없음) | ✅ 주 분석 |
| DMF0003_1 (변형) | `GSCM.DM.Forms.UIL/Plan/DMF0003_1_MktFcst/…` (7,104줄) | PSI(고객수요분석)+Car(시뮬레이션) 혼재본 | 이력·가시성 참조 |
| DMF0003_T | (별도) | 별개 화면 (사용자 정정 2026-07-09) | 제외 |

> ⚠ `_1` 의 PSI/Car 상단 패널은 2026-07-03 결정으로 **TO-BE 제거**(구현·DB 등록분은 `_deploy_packages/DMF0003_PSI_20260703`, `_CAR_/_PR_20260703` 에 보존). 정본에는 애초에 없다. 단 SHEET_COLUMNS 에는 `psi` / `carFcst` / `Customer Demand Analysis` 시트 정의가 아직 남아 있음(실측, 아래 §5).

### 기본 정보

| 항목 | 값 |
|---|---|
| 화면 ID | DMF0003 (MktFcst / 시장예측) |
| 도메인 | Demand (수요) |
| 메뉴 | Demand > Demand Plan > MKT FCST |
| TO-BE FE | `nscm-fe/features/demand/src/pages/mkt-fcst/` |
| 시트(sheetName) | `Mkt Fcst`(메인) / `spreadTitle`(기간 헤더) / `dayRange`(기본 구간) + POPUP 계열 |
| 편집 가능 | **Division 82 만** (회의 확정 2026-07-07, 실 데이터 확인) |

### 범위 — 메인 + POPUP 전체

| POPUP | AS-IS Class | 트리거 | SP | 상태 |
|---|---|---|---|---|
| PR (Request Info) | `DMF0003_PRPopup` | 우클릭 Request_PR | `DMF0003_GET_PRPOPUP` | ✅ 유지 |
| PR History | `DMF0003_PRHistoryPopup` | 우클릭 View_History | `DMF0003_GET_PR_HISTORY_POPUP` | ✅ 유지 |
| SSP Sync | `DMF0003_SspSyncPopUp` | 저장 응답 | (SP 없음) | ✅ 유지 |
| SSP Sync Compare | `DMF0003_SspSyncComparePopUp` | 셀 더블클릭(40&MKT_FCST_RP) | `DMF0003_GET_MKT_FCST_COMPARE_POPUP` | ✅ 유지 |
| Version Cut-Off | `VersionCutOffPopUp` (11화면 공용) | btnCutOff | `DMF0010_GET_DM_MDF_VERSION` | ✅ 유지 |
| **Master Change** | `DMF0003_MatsterChgPopup` | btnIncotermsChg | `DMF0000_GET_MASTER_CHG_POPUP`(사내 미존재) | ⛔ **삭제(2026-07-13)** |
| Project/Item/Owner byDivision | `SCM0002/DM0002/DM0020…` | 조회조건 팝업 | (콤보/팝업 SP) | ✅ 유지 |
| PSI(CustDemandAnalysis) / Car | `_1` 전용 | — | PSI/Car 계열 | ⛔ 제거(_1 전용) |

---

## 2. 소스 인벤토리

### 2.1 이벤트 핸들러 (정본 26 · `__asis-mapping__.md` 4축 검증 기준)
화면로드(Form_Load/OnShown/InitControls/DefineProperty/InitSpread), 조회조건 cascade(Division/Team/Customer 변경), 그리드(ComboSelChange/CellDoubleClick/Changed/CellClick/ClipboardPasted/KeyUp/우클릭 contextMenu), 버튼(Project/Item/Owner/Column/Measure/Bucket/IncotermsChg), 체크(chkColor/chkSum/cboAS). 4축 커버리지 = **Validation 152 / Expressions 130 / Events 26 / Popup 8** (정본 기준; _1 변형은 validation 154).

### 2.2 호출 SP (FoxDataRequest)
- 메인: `DMF0003_GET_MKT_FCST_DATA`(조회), `DMF0003_SAVE_MKT_FCST`(저장), `DMF0003_GET_SPREAD_TITLE`(기간 헤더), `DMF0003_GET_BUCKET_TYPE_CODE`, `PR_GET_DAY_RANGE`.
- POPUP: `DMF0003_GET_MKT_FCST_COMPARE_POPUP`(SSP 비교), `DMF0003_GET_PRPOPUP` / `DMF0003_GET_PR_HISTORY_POPUP`(PR), `DMF0010_GET_DM_MDF_VERSION`(Version Cut-Off).
- 공통: `UP_FX_GetCommonDataList_DM`(콤보), `SCM0001_GET_*`(division/site/lookup), `Data.Common(...)` 헬퍼.

---

## 3. ⭐ 객체 가시성 · 컨테이너 LAYER 종속 (effective visible)

> **사용자 명시 유의사항**: 개별 객체는 `Visible=true / Enabled=true` 이나, 그 객체를 담은 **LAYER(컨테이너/LayoutItem) 의 Visibility=false** 로 실제로는 사용 불가가 되는 CASE. 부모-자식 종속을 추적한 **실효 표시(effective visible)** 를 아래에 정리한다. (정본 `DMF0003_MktFcst.Designer.cs` + `.cs` 실측)

### 3.1 정본(DMF0003)의 LAYER 은폐 케이스

정본은 DevExpress `LayoutControl` 기반이며, 각 컨트롤은 `layoutControlItemN` 에 담긴다. 아래는 **자식은 표시 의도(Visible=true)이나 LAYER 로 은폐**되는 실제 케이스다.

| 컨트롤 | 담긴 LAYER (Control 바인딩) | 자식 상태 | LAYER 은폐 방식 | 실효 표시 | 근거 |
|---|---|---|---|---|---|
| **cboCellQty** (Cell Qty 체크) | `layoutControlItem10` (Designer L1351) | Designer `cboCellQty.Visible=false` (L1065) | 디자인 고정 은폐. `InitControls` 는 `.Enabled` 만 토글(L445/465, L2107/2140) → **무의미** | **항상 숨김** | Designer L1065/L1351 |
| **chkColor** (Color 체크) | `layoutControlItem6` (Designer L1380) | Visible=true | `.Visibility` 기본 `Never`(cs L548). **ADMIN/DM ADMIN 만 `Always`**(L556). DM Planner·default 는 Never 유지 | ADMIN/DM ADMIN 만 표시 | cs L548/556, Designer L1380 |
| **btnIncotermsChg** (Master Change) | `layoutControlItem7` (Designer L1339) | Visible=true(설계) | `.Visibility` + 런타임 `.Visible`. ADMIN/DM ADMIN/DM Planner=Always(L557/562), default=Never+`.Visible=false`(L566/568) | 권한별(현재 **기능 삭제**) | cs L554~568, Designer L1339 |
| **cboAS** (AS 체크) | `lciASCheck` (Designer L1371) | Visible=true | LAYER 은폐 아님. 단 **W/S Planner → `Enabled=false` + `Checked=true` 강제잠금**(cs L312~315) | 표시(잠금) | cs L312/315, Designer L1371 |

**권한 그룹 스위치(cs L550~568)** — `UserInfoContext.Current["NowGroupID"]` 기준:
- `ADMIN` / `DM ADMIN` → btnIncotermsChg 표시 + layoutControlItem6(chkColor)=Always + layoutControlItem7=Always
- `DM Planner` → btnIncotermsChg 표시 + layoutControlItem7=Always (item6=chkColor 는 Never 유지 → **chkColor 숨김**)
- default → btnIncotermsChg 숨김 + item6·item7 Never

### 3.2 변형본(_1)의 PSI/Car 패널 은폐 (이력 — TO-BE 제거)

`_1` 은 `splitContainer2.Panel1` 하위에 PSI(spdSub1)·Car(spdSub2) 블록을 두고, `InitSpread()` 에서 **`clbDivision`이 81 이 아니면 `Panel1Collapsed=true` + `tableLayoutPanel1.Height=0`** 로 전체 은폐한다(cs L550~563). 아래 13개 컨트롤은 개별 `Visible=true`이나 40/82 진입 시 **실효 숨김**이다.

| 컨트롤(자식) | 부모 LAYER | 실효 표시 | 비고 |
|---|---|---|---|
| spdSub1(PSI), spdSub2(Car) | splitContainer2.Panel1 | 81만 표시 / 40·82 숨김 | 그리드 |
| drpPeriodPSI, drpPeriodSimulation, btnFindPSI, btnReport | …Panel1 하위 usrLayoutControl4 | 동상 | PSI 조건/버튼 |
| cmbCarMaker, cmbCarModel, cmbBizType, txtMarketShare, txtBizPerCar, btnCalculation, btnExcelUpload, drpPeriod1, lblExcelInfo(Label) | …Panel1 하위 usrLayoutControl3 | 동상 | Car 조건 |
| btnUpDown | tableLayoutPanel1(Panel2) | division≠81 시 `Height=0` | 토글 |

> **분석서 판정**: 정본에서 실효 은폐 = **cboCellQty(항상)·chkColor(권한)·btnIncotermsChg(권한, 기능삭제)**. PSI/Car 13종은 `_1` 전용이며 TO-BE 제거. '보이는 객체'로 오분류 금지.

---

## 4. 소스 ↔ DB / PKG / SP 연계 (이중 SP 체계)

DMF0003 은 **메인 조회 = 독립(standalone) SP** + **부속 = PKG_DMF0003** 의 이중 구조다.

### 4.1 메인 조회 SP — `DMF0003_GET_MKT_FCST_DATA` (독립, 패키지 아님)
- 소스: `_artifacts/_apply_corporate/DMF0003_GET_MKT_FCST_DATA_patched_20260711.sql` (약 4,345행).
- 시그니처: **22 IN + 4 OUT 커서**. IN = division/scmSite/plantSite/team/customer/bizType/project/item/from·toYYYYMMDD/createdBy/userGroup/itemType/owner/qtyYn/cellYn/invalidExec/asYn/userDeptId/senderCode/userId/menuId. OUT = `O_RC1`(wide 데이터), `O_RC2`(8주 cutoff 주), `O_RC3`(현재/전주), `O_RESULT_CURSOR`(code/msg).
- FE 배선: `procedures.d.ts:1065~1088` 에 22 파라미터 camelCase 1:1.
- 동적 PIVOT: 달력(`SCM_SYS_CALENDAR_M`) 으로 D_/W_/M_ 기간 IN 리스트 생성 → `PIVOT` 으로 wide 전개. 컬럼 목록은 `SCM_MST_SHEET_COLUMNS` + 개인화 `SCM_MST_TITLESET_USER` 를 `XMLAGG` 로 조립.

### 4.2 부속 PKG_DMF0003 (15 프로시저, `09_packages_01.sql` L4860~8719)
GET_SPREAD_TITLE(메인 헤더), GET_MKT_FCST_COMPARE_POPUP(SSP 비교, 8 IN), SAVE_MKT_FCST_PK_DATA_UPDATE(PK 갱신), MKT_FCST_SALES_PLAN_SYNC(Sales Plan 동기화), GET_BUCKET_TYPE_CODE / GET_QTY_TYPE_CODE / GET_REPORT_BUCKET_TYPE_CODE(콤보), 그리고 PSI/Car 계열(GET_DM_ANL_MKT_PSI_*, GET_DM_ANL_CAR_*, GET_SPREAD_TITLE_PSI/_CAR) — PSI/Car 는 TO-BE 미사용. 조회 프로시저는 대부분 `O_RC1 + O_RESULT_CURSOR` 이중 커서.

### 4.3 저장 · 배치
- 저장 = `DMF0003_SAVE_MKT_FCST` (정본, `^` 없는 그리드 편집 저장). 저장 후 `PKG_DMF0003.P_DMF0003_MKT_FCST_SALES_PLAN_SYNC` 로 SSP 동기화.
- 배치 = `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(_BATCH)` / `_WEEKLY_ROLLING`(Daily Cutoff) / `_RESULT_MOVE`(Weekly Rolling).

### 4.4 patched vs backup 차이 (2026-07-11, 기능 변경 1줄)
- backup: `... F.YYYYMMDD BETWEEN V_TO_RESULT AND P_TO_YYYYMMDD`
- patched: `... F.YYYYMMDD BETWEEN GREATEST(V_TO_RESULT, V_FROM_YYYYMMDD) AND P_TO_YYYYMMDD`
- 효과: '실적 없음' 분기(`V_TO_RESULT='19000101'`)에서 옛(2019~23) EDI 이력이 유입돼 **부모 없는 빈 하위 행 643건**이 깔리던 결함 수정(자식 하한 = 당주 월요일로 클램프).

---

## 5. 소스 ↔ LOOKUP / 콤보 / SHEET 데이터 연계 (실측)

> 사내 Oracle 직결로 추출한 **실 코드·명칭** 데이터. (미러는 DDL 전용이라 종전 "확인 안 됨"이었던 부분을 실값으로 대체.)

### 5.1 SHEET_COLUMNS (PROGRAM_ID='DMF0003') — 실측 96행 / 4 시트
- 시트: **`Mkt Fcst`(메인, 66컬럼)** + `Customer Demand Analysis`(10, PSI 팝업, 81) + `carFcst`(2) + `psi`(18). PSI/carFcst/CDA 는 화면 제거됐으나 메타는 잔존.
- 메인('Mkt Fcst')의 **Division 반응형 컬럼**(동일 라벨, DIVISION_ID 로 분기) — 소스↔DB 연계 핵심:

| 논리 컬럼 | 40 전용 | 82/81 계열 | 비고 |
|---|---|---|---|
| Div* | `DIVISION_ID40` | `DIVISION_ID` | |
| End Customer | `END_CUSTOMER40`(콤보 EndCustomerByDivision40) | `END_CUSTOMER`(콤보 EndCustomerByDivisionDept) | |
| Sales Site* | `SCM_SITE_ID40` | `SCM_SITE_ID` | 콤보 SiteByEndCustomer |
| Model* | `ITEM_ID40` | `ITEM_ID` | 콤보 ItemByDivision(FPModal) |
| Plant Site* | — | `PLANT_SITE_ID`(81 계열만, 콤보 PlantByDivisionCompany) | **81만 노출** |
| Energy/Cell | — | `ENERGE`·`CELL_QUANTITY`(82만) | 82 전용 |
| Cell/Car·Module | — | `CELL_PER_CAR`·`CELL_PER_MODULE`·`MODULE_PER_CAR`(81 계열) | 81 전용 |
| Project 계열 | (40 미노출) | `PROJECT_CODE`·`PROJECT_NAME`(82/81) | 40 disabled |

- 공통 콤보 컬럼(전 division): `INCOTERMS`(콤보 Incoterms), `FCST_TYPE`(콤보 FcstType), `DOM_EXP`(콤보 CustomsHandbook), `ITEM_TYPE`(콤보 ItemType), `MEASURE`(콤보 **Measure**, INPUT_TP_CD='IM' 편집), `VMI_YN`(콤보 YesOrNo), `AS_FROM_SITE`(콤보 AS_FROM_SITE), `MEASURE_GROUP`(콤보 Measure).
- `VISIBLE_FLAG='Y'` 기본 노출 = DIVISION_ID·END_CUSTOMER·SCM_SITE_ID·ITEM_ID·ITEM_NAME·NICK_NAME·INCOTERMS·FCST_TYPE·DOM_EXP·MEASURE. 나머지(DEPT/TEAM/BIZ_TYPE/PROJECT/OWNER 등)는 기본 숨김·사용자 선택(USER_SELECTABLE_FLAG='Y').

### 5.2 SHEET_MEASURE (PROGRAM_ID='DMF0003', SHEET_NAME='Mkt Fcst') — 실측 48행
기본표시(DEFAULT_FLAG='Y') = **CUST_FCST(50)·MKT_FCST_RP(70)·RTF_SYS_RP(90)·BNPIn(82,340)** (+ 무효 CUST_FCST_EDI/ORG/RTF). Division 별 노출: `MKT_FCST_ENERGY`·`RTF_ENERGY`·`RTF_RP_CELL`·`RTF`(82 전용), `MKT_FCST_RP_CAR`·`RTF_SYS_RP_CAR/CELL`(81 계열), `RMA`·`RTF_TEST`(40). 유효(VALID_YN='Y') 22종 / 무효 26종. (xlsx 메저마스터와 정합 확인.)

### 5.3 LOOKUP_MASTER_DETAIL — 실측 (DMF0003 사용 타입 11종)

| LOOKUP_TYPE | 건수(유효) | 실 데이터 요지 | 화면 용도 |
|---|---|---|---|
| **GET_ADMIN_GROUP** | 9(9) | ADMIN·DM ADMIN·SCM PI Admin·**DM Planner (W/S)→DMF0003**(admin 부여)·DM Planner→DMF000 등. ATTRIBUTE1='Y'=관리자급 | 관리자 권한 판정(SEGMENT2 IN 'ALL','DMF0003') |
| **DM_UI_EDITABLE_DIVISION** | 6(6) | **DMF0003: 81=N / 40=N / 82=Y**(ATTRIBUTE1). DMF0020: 81=N,40=N / DMF0082: 82=N | 편집 가능 division(콤보 MktFcstEditableDivision → 82 단건) |
| **MKT_FCST_MEASURE** | 24(22) | 편집가능 measure/division: 40=CUST_FCST·MKT_FCST_RP·VMI_In_Req / 81=MKT_FCST_RP·VMI_In_Req·TMM_FCST(ATTR2=Y)·AS_In_Req / 82=MKT_FCST_RP·RTF_SYS_RP·VMI(3)·BNPIn·AS_In_Req / 81_HD·HG·HM·ST=MKT_FCST_RP | 그리드 편집 measure 콤보(MktFcstEditMeasure) |
| **AS_SITE_PLANT** | 18(13) | site-AS↔plant 매핑(SEGMENT3=division 40/81/82). 예 A002-40-AS→A002_40-W | AS site 판정·as_yn 승격·AS measure 생성 |
| **TMM_MEASURE_ADMIN** | 70(70) | 81 / item A15AI4002(C-BEV) / SEGMENT4=사용자ID 70명 | TMM_FCST 표시 권한(등록 사용자만) |
| **CELL_TYPE** | 21(21) | [P]POUCH→Pouch, [C]CYLINDRICAL→Cyl 등 셀타입 정규화 | Cell 표시명 |
| **DM_BIZ_TYPE** | 3(3) | CELL·PACK·MODULE | Biz Type 콤보 |
| **DM_BIZ_TYPE_40** | 1(1) | 40/AMDMO0001A/MODULE | 40 Biz Type |
| **EDI_END_CUSTOMER** | 16(16) | 81 고객 EDI 스케줄(Audi/BMW/Daimler…, ATTR2=요일 MON/TUE) | EDI 고객·수신요일 |
| **RPA_END_CUSTOMER** | 4(4) | FCA/HKMC/Renault(81), 40 IM_CN_NGG | RPA 고객 |
| **DM_MEASURE_POSITIONAL_NOTATION** | 29(29) | division×measure 소수표기(INTEGER / POINT). 82 KRW/LOC=POINT(소수3), 그 외 대부분 INTEGER | measure 소수 자릿수 |

### 5.4 신규 콤보(CMBO_SQL_M) 5종 (2026-07 신설)

| 콤보 SQL_ID | 바인드 | 반환 | 용도 |
|---|---|---|---|
| `MktFcstEditMeasure` | @divisionId | LOOKUP MKT_FCST_MEASURE(SEGMENT1=div, ATTR2≠Y=TMM제외) code/명 | 그리드 편집 measure |
| `MktFcstEditableDivision` | 없음 | DM_UI_EDITABLE_DIVISION(DMF0003, ATTR1='Y') → **82** | 편집가능 division |
| `MktFcstUserEditDivision` | @sesUserId | `SCM_ADM_USER_GR_UNIT_AUTH_MPG_M`(UNIT_TP_CD='D', EDIT_YN='Y', **OR 다중그룹**) | 사용자 편집 권한 division |
| `MktFcstWsPlannerYn` | @sesUserId | `SCM_ADM_USER_GR_MPG_M` USER_GR_ID='DM Planner (W/S)' EXISTS → Y/N | W/S Planner 판정(AS 강제) |
| `BizType` | 없음 | ALL + DM_BIZ_TYPE code/명 | Biz Type |

### 5.5 신규 메시지 (MSG00660~00666, `DMF0003_msg_register.sql`, KO/EN/CN)
00660 MKT FCST 수량 일자 없음 / 00661 복사 데이터 선택 / 00662 조회 후 수정모드 / 00663 AS From-Site ALL 불가 / 00664 FcstType 코드 유효하지 않음 / 00665 조회 기간 입력 / 00666 실적 수량보다 작은 숫자 불가.

---

## 6. VALIDATION (SOURCE내 / DB내 취합)

> 검증을 **화면(SOURCE=FE)내** 와 **DB(SP)내** 로 구분한다. 상세 매트릭스는 `제약매트릭스_v2.0.xlsx` 시트2 참조.

### 6.1 DB(SP)내 검증
- 메인 조회 SP `DMF0003_GET_MKT_FCST_DATA` 에 **선제 RAISE 검증 없음**(잘못된 입력은 0행으로 흘림). FCST_TYPE/기간/권한은 CASE 분기·조인키로만 사용.
- 유일 명시 = `WHEN OTHERS → RAISE_APPLICATION_ERROR(-20001, …)` + `PR_DM_SYS_LOG_BATCH`(SQLCODE/ERRM/BACKTRACE/PARAMS 로그).
- **조건 게이트(검증 아님, 데이터 분기)**: ① `GET_ADMIN_GROUP`(SEGMENT2 IN 'ALL','DMF0003', SEGMENT1=user_group) → `V_GROUP_ID='ADMIN'`. ② `AS_SITE_PLANT` 매칭 site → `LP_AS_YN='Y'`(AS 메저 승격).

### 6.2 SOURCE(FE)내 검증 — `utils/mkt-fcst.validate.ts` + `division.ts` + `editLock.ts`

| 트리거 | MSG_ID | 조건 |
|---|---|---|
| 조회 | MSG00097 | Division 필수 |
| 조회 | MSG00108 | 기간 역전(start>end) |
| 조회 | MSG00164 | 기간 3년 초과 |
| 조회 | MSG00665 | 조회 기간 입력 |
| 셀편집/저장 | MSG00429 | 필수값(Division/Sales Site/Customer Project/Customer Model/Incoterms/FCST Type/Customs Handbook/Measure Group/Measure/Upload UOM + **81 은 Plant Site**) |
| 저장 | MSG00043 | 행간 중복키 |
| 저장 | MSG00660 | 수량 입력 일자 없음 |
| 저장 | MSG00666 | 실적 수량보다 작은 숫자 불가 |
| 저장 | MSG00663 | AS From-Site 를 ALL 로 저장 불가 |
| 저장 | MSG00152 / MSG00617 | 저장할 데이터 없음 / 저장 확인 |
| 편집게이트 | MSG00448 | 편집 불가(권한/division) |
| Bucket | MSG00227 | Insert 행 Bucket 변경 불가 |
| 복사 | MSG00661 | 복사 데이터 선택 |
| 수정모드 | MSG00662 | 조회 후 수정모드 |
| FcstType | MSG00664 | FcstType 코드 유효하지 않음(콤보 dataMap 단계 차단) |

> 커버리지: 정본 validation.md **152건** — 직접 22 + inline/division 분기 121 + 미구현 9(Excel/legacy 내부, 사유 명시). _1 변형은 154건.

---

## 7. 축별 제약 (Division / 권한 / Measure / FCST_TYPE)

### 7.1 Division (40 / 81 / 82) — 실측 반영

| 항목 | 40 (Mobility) | 81 (Automotive, 81_UC/HM/ST/HD/HG) | 82 (ESS) |
|---|---|---|---|
| 키 컬럼 | Customer40·ScmSiteId40·ItemId40 | Project·ScmSite·Item | Project·ScmSite·Item |
| Plant Site 필수 | ✗ | **✓** (SHEET_COLUMNS PLANT_SITE_ID 81 계열만) | ✗ |
| 중복키 Plant 포함 | ✗ | **✓** | ✗ |
| SspSync 대상 | ✓(MKT_FCST_RP) | ✗ | ✓ |
| Project 필드 | **비활성** | 활성 | 활성 |
| Sender Code(EDI) | ✗ | **81만** | ✗ |
| Cell Qty | **40만** | ✗ | ✗ |
| checkInvalidExec | ✗ | ✗ | **82만** |
| Energy/Cell 컬럼 | ✗ | ✗ | **82만**(ENERGE/CELL_QUANTITY) |
| Cell/Car·Module 컬럼 | ✗ | **81만** | ✗ |
| Bucket 기본 | Weekly | Weekly | **Daily** |
| **편집 가능** | ✗ | ✗ | **✓ (유일)** — DM_UI_EDITABLE_DIVISION 실측 82=Y |
| 8주 잠금(Monthly) | ✓ | — | — |

### 7.2 권한 (실측 GET_ADMIN_GROUP + .cs 스위치)
- **관리자급(GET_ADMIN_GROUP, DMF0003 범위)**: ADMIN·DM ADMIN·SCM PI Admin·**DM Planner (W/S)**. (실측 — .cs 스위치는 ADMIN/DM ADMIN/DM Planner 만 다뤄, SCM PI Admin·W/S 는 DB 메타로만 관리자 부여.)
- chkColor(layoutControlItem6): **ADMIN/DM ADMIN 만 표시**. btnIncotermsChg(item7): ADMIN/DM ADMIN/DM Planner 표시(현재 기능삭제). default: 둘 다 숨김.
- **W/S Planner** → cboAS 강제 ON+잠금(as_yn='Y').
- **편집 권한 = 82 division + 사용자 그룹 EDIT_YN**: FE `editable = isEditableDivision(div, editableSet[82]) AND userEditSet.has(div)`. userEditSet = `MktFcstUserEditDivision`(SCM_ADM_USER_GR_UNIT_AUTH_MPG_M, OR 다중그룹). 회의(2026-07-07): "편집 권한은 82만" + "그룹 2개 보유 시 어드민 기준 재점검".
- titleSet 저장 권한그룹 = ADMIN / DM ADMIN / DM Viewer.

### 7.3 Measure (종속 구조 — 핵심)
동작 3단계: ① 선택 저장(`SCM_MST_TITLESET_USER('M')`) → ② 서버 확장(SP가 base 로 읽어 종속 자동 추가) → ③ 표시조건(해당 키에 데이터 있을 때만 하위 행).

| 상위(선택) | 조건 | 하위(종속) | 유형 | SP |
|---|---|---|---|---|
| CUST_FCST | 전 division | EDI 8종(CUST_FCST_EDI·Backorder·Commercial_Agreement·Firm_Temp·Immidiate·Manumacturing_Material_Temp·Material_Temp·Planning_Forecast) | 고정 종속 | L888~920 |
| CUST_FCST | 전 division(동적) | └EXCEL(Cust.FCST_EXCEL)·└RPA(Cust.FCST_RPA) | 업로드 종속 | L922~952 |
| **MKT_FCST_RP** | **Division 82 한정** | RTF_SYS_RP·VMI_In_Plan·VMI_In_Req·VMI_Inv(선택 무관 강제) | 강제 종속 | L982~1010 |
| (선택 무관) | 82, 판가 존재 | MKT_FCST_RP·BNPIn 자동 행 생성 | 자동(판가) | AS-IS L5230/5254 |
| AS_In_Req/Plan/Inv | 전체, as_yn='Y' | 동일 코드 | AS 게이트 | L3294~ |
| TMM_FCST | 81 계열, TMM_MEASURE_ADMIN 등록자 | 동일 코드 | 권한 게이트 | L875~883 |
| CUST_FCST_ORG | (비활성, E20241126 합의) | Customer Fcst[Org.] | 비활성 | L954~980 |

- 표시명 트리: 하위 measure 는 `' └ '`(공백 4칸) indent. FE `MktFcstGrid.formatItem` MEASURE 셀 `white-space:pre`.
- **Measure 클라이언트 필터 제거**(2026-07): SP 반환 measure 집합 그대로 렌더(종속 measure 잘림 버그 fix).
- 소수 표기: `DM_MEASURE_POSITIONAL_NOTATION`(82 KRW/LOC=POINT 소수3, 그 외 INTEGER).

### 7.4 FCST_TYPE
- SP: FCST_TYPE 을 **조인/그룹 키로만** 사용(코드 유효성 DB 검증 없음).
- 입력 제약(회의 2026-07-07): **AS = 사이트 지정 입력, WS = 2유형 입력 가능, ETC·M/S = 입력 불가**. Sales Site = 자사 플랜트 코드.
- FE: 필수값(SetSaveData) + MSG00664(콤보 dataMap 미매칭 차단). 콤보 = `FcstType`(param-less SQL, AS-IS 정본).

---

## 8. POPUP 상세

| POPUP | SP | 역할 | 주요 검증 | 상태 |
|---|---|---|---|---|
| PR (Request Info) | `DMF0003_GET_PRPOPUP` | 81 ERP PR 발행 | BNPIn measure + Daily 컬럼 + 과거일 제외 | ✅ |
| PR History | `DMF0003_GET_PR_HISTORY_POPUP` | PR 발행 이력 | — | ✅ |
| SSP Sync | (SP 없음) | 저장 후 SSP 동기화 결과 표시 | — | ✅ |
| SSP Sync Compare | `DMF0003_GET_MKT_FCST_COMPARE_POPUP`(8 IN) | SSP↔MKT 비교 | Div40 & MKT_FCST_RP & 동기화색 셀 | ✅ |
| Version Cut-Off | `DMF0010_GET_DM_MDF_VERSION` | 버전 컷오프(11화면 공용) | — | ✅ |
| Project/Item/Owner byDivision | 콤보/팝업 SP | 조회조건 팝업 | — | ✅ |
| **Master Change** | `DMF0000_GET_MASTER_CHG_POPUP`(사내 미존재) | Incoterms/PK 마스터 변경 | — | ⛔ 삭제 |

---

## 9. ⭐ 이전 소스 대비 차이점 (v1.7 baseline → 최신)

> AS-IS legacy `.cs` 자체는 무변경(mtime 2026-05-07~08). 실질 변경은 **FE(`mkt-fcst/`) + 사내 적용 아티팩트(`_apply_corporate/`)** 에서 발생.

| # | 변경 | 내용 | 사유 | 근거 |
|---|---|---|---|---|
| 1 | **Master Change 전체 삭제** | 버튼·모달·메타(MNU_BTN_MPG/API_M/MSG00653/LBL00701)·i18n 제거. SP 자산은 보존 | GET SP `DMF0000_GET_MASTER_CHG_POPUP` 사내 미존재 + SAVE OUT커서 부재 → BLOCKED | `38_…handoff.md`, `A3_…full_removal.py` |
| 2 | **PSI/Car 상단패널 제거** | `_1` 전용 판정 → 정본 화면에서 제거 | 화면 구분 정정 | `_deploy_packages/DMF0003_PSI_20260703` |
| 3 | **편집가능 Division=82 등록** | DM_UI_EDITABLE_DIVISION 82=Y INSERT + 사용자그룹 EDIT_YN OR 게이트 | 회의 "편집 권한 82만" | `DMF0003_editable_division_82.sql`(실측 반영) |
| 4 | **Measure 콤보 indent 2단 복원 + 클라필터 제거 + SP 하한 클램프** | 종속 트리 공백4 복원 / SP 반환 그대로 렌더 / 빈행 643건 fix | 종속 measure 잘림·유령행 버그 | `A4_…`, patched_20260711 |
| 5 | **W/S Planner AS 강제** | 구 cboAS 체크 → 그룹 판정 콤보(MktFcstWsPlannerYn) | AS 프로세스 이관 | `DMF0003_cmbo_ws_planner_yn.sql` |
| 6 | **MSG/LBL 재채번** | 6/28 신규 폐기 → 사내 실 ID EXACT 재사용 + 부재분 MSG00660~666 | 사내 마스터 의미 정합 | `DMF0003_msg_register.sql` |
| 7 | **Color 제거 · Freeze 메타 위임 · FcstType/CustomsHandbook param-less 콤보** | chkColor 미표시 고정 / FIXED_FLAG 위임 / 콤보 SQL 교체 | 표준화 | `__asis-mapping__.md` |

---

## 10. 추출 한계 (정직)
- 실 row 데이터는 **2026-07-16 사내 Oracle(OCGSCMD_P01) 실측** 기준. 운영 반영 시점에 따라 값이 갱신될 수 있음.
- 메인 SEARCH 의 `API_M`(API_ID·API_URL) 원 row, PROC_M 22행 INSERT 스크립트는 리포지토리 미포함(FE `procedures.d.ts` 주석·PROC_M rename 스크립트로 매핑 확인).
- `_1` 변형(PSI/Car)의 상세 라인은 정본과 오프셋 상이 — 본 분석은 정본 기준, PSI/Car 는 이력.
- validation.md 152(정본)/154(_1) 병기 — 카운트 차이는 소스본 차이(PSI/Car 검증 2건).
