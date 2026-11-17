=== FILE: business_analysis.md ===
# DMF0045 ShipmentRequest — 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(DMF0045)과 1차 분석서(analysis.md, web_components.md, tobe_design.md)입니다. Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> 함께 보는 문서: 화면설계서 `screen_design.md`(§5 액션 명세)와 단위테스트 `unit_test.md`(근거 열)가 이 문서 §5와 같은 엔드포인트·SP 이름을 씁니다.
> 주석 처리된 호출(commented_calls)은 0건입니다. 따라서 이 문서의 모든 호출은 활성 코드 기준입니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | DMF0045 / `DMF0045_ShipmentRequest` | controls.csv, events.csv |
| 폼 Text | `ShipmentRequest` | props.csv Designer:1039 |
| 소속 | `06.UIL\GSCM.DM.Plan.UIL` (DM 도메인) | 파일 구성 |
| 업무 목적 | Fact Pack에 업무 정의 문서가 없어 **확인 필요**입니다. 확인된 사실은 저장 SP가 `DM_PLN_SHIPMENT_REQ`와 `DM_PLN_SHIPMENT_REQ_H`에 INSERT한다는 것뿐입니다 | endpoints.csv `DMF0045_SAVE_SHIPMENT_REQUEST` objects |
| 범위 | 조회 조건(Division·Bucket·Period·Plant Site·Sales Site·End Customer·Team·Project·Model·Sum)으로 Shipment Request를 조회하고, 행 추가·편집·저장. 시트 2개: `Pack Biz`, `Cell Biz` | controls.csv, grid_code.csv CreateSpread:255/260 |
| 범위 밖(사실 없음) | 삭제 버튼과 삭제 API는 Fact Pack에 없습니다. 삭제 기능이 필요한지는 **확인 필요**입니다 | flow.csv(Find/Insert/Save/Edit만 있음) |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 (엔드포인트 / SP) | 결과 |
|---|---|---|---|
| S1 | 화면을 연다 | `Form_Load` > InitControls: `biz:CommonData.CommonDataList` [code=MyDivision](200), [code=Measure](231). InitControls > GetBucketType: `DM.DM0003_GET_BUCKET_TYPE_CODE` → SP `DM0003_GET_BUCKET_TYPE_CODE`(2266). CreateSpread > InitSpread > GetSpdTitle: `DM.DMF0045_GET_SPREAD_TITLE` → SP `DMF0045_GET_SPREAD_TITLE`(2249) | Division·Bucket 콤보가 채워집니다. 시트 `Pack Biz`와 `Cell Biz`가 생성되고 `Pack Biz`가 활성화됩니다(ChangeSheet:265). 3행 헤더가 구성됩니다 |
| S2 | Division을 바꾼다 | `cboDivision_SelectedIndexChanged` > InitSpread > GetSpdTitle: `DM.DMF0045_GET_SPREAD_TITLE` | 그리드 헤더와 컬럼이 다시 구성됩니다. 다른 조건 콤보에 연쇄 갱신되는지는 **확인 필요**입니다(GetCheckedListValue 1086/1097/1102, NowGroupID 1094~1107 읽기만 확인) |
| S3 | 조회를 누른다(FindButton) | FindData: `biz:CommonData.CommonDataList` [code=Measure](579), `DM.DMF0045_GET_SHIPMENT_REQUEST` → SP `DMF0045_GET_SHIPMENT_REQUEST`(609), InitSpread > `DM.DMF0045_GET_SPREAD_TITLE` | 결과가 그리드에 바인딩됩니다. 행이 있으면(`GetMaxRowIndex() >= 0`) SetSpreadColumn으로 버킷 컬럼 표시를 적용합니다(652) |
| S4 | 행추가를 누른다(InsertButton) | InsertRow: `biz:CommonData.CommonDataList` [code=FCST_TYPE](1001), [code=Measure](1004) | 시트가 잠겨 있지 않으면 새 행의 FCST_TYPE·MEASURE 셀에 콤보가 설정됩니다(1003/1005) |
| S5 | 그리드 END_CUSTOMER 콤보를 바꾼다 | `spdMain_ComboSelChange`: `Data.UserSiteByEndCustomer` / `Data.UserSiteByEndCustomerAuth`(1158). 이 두 메서드의 엔드포인트는 **확인 필요**입니다 | 해당 행의 FROM_SITE 콤보가 다시 설정됩니다 |
| S6 | 그리드 FROM_SITE 콤보를 바꾼다 | `spdMain_ComboSelChange`: `biz:CommonData.CommonDataList` [code=MktFcstEditMeasure](1194) | MEASURE 콤보가 다시 설정됩니다(1195) |
| S7 | 그리드 셀 값을 바꾼다 | `spdMain_Changed`(dsdmPack/dsdmCell.Changed): `biz:CommonData.CommonDataList` [code=DefaultBucketDay](1749, 1811) | 값 변경 뒤 처리 내용은 **확인 필요**입니다(DefaultBucketDay 조회만 확인) |
| S8 | 저장을 누른다(SaveButton) | SaveData: `DM.DMF0045_SAVE_SHIPMENT_REQUEST` → SP `DMF0045_SAVE_SHIPMENT_REQUEST`(896). 이어서 FindData 흐름 전체(`DM.DMF0045_GET_SHIPMENT_REQUEST`, `DM.DMF0045_GET_SPREAD_TITLE`, [code=Measure]) | `DM_PLN_SHIPMENT_REQ`, `DM_PLN_SHIPMENT_REQ_H`, `SCM_SYS_LOG_BATCH`에 INSERT한 뒤 재조회합니다 |
| S9 | Bucket을 바꾸거나 Sum을 체크한다 | `cboBucketType_SelectedIndexChanged`(1136), `chkSum_CheckedChanged`(2136) → SetSpreadColumn. API 호출은 없습니다 | D_/W_/M_ 컬럼 표시가 바뀝니다(§4 R-B) |
| S10 | 헤더를 더블클릭한다 | `spdMain_CellDoubleClick`. API 호출은 없습니다 | M_ 헤더는 W_/D_ 컬럼, W_ 헤더는 D_ 컬럼의 표시를 토글합니다 |
| S11 | Project / Model 찾기 버튼을 누른다 | `btnProject_Click`(2093), `btnItemId_Click`(2116) | `txtProject` / `txtItemId`에 선택값이 들어갑니다. 팝업 화면 ID는 **확인 필요**입니다 |
| S12 | Measure 버튼을 누른다 | `btnMeasure_Click` > InitSpread > `DM.DMF0045_GET_SPREAD_TITLE` | 그리드 헤더가 다시 구성됩니다 |
| S13 | 편집을 누른다(EditButton) | GetSheetInfo(활성 시트, 443). API 호출은 없습니다 | 처리 결과는 **확인 필요**입니다 |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 진입]
  Form_Load
   ├─ InitControls
   │   ├─ biz:CommonData.CommonDataList [code=MyDivision] → cboDivision
   │   ├─ biz:CommonData.CommonDataList [code=Measure]
   │   └─ GetBucketType → DM.DM0003_GET_BUCKET_TYPE_CODE (SP DM0003_GET_BUCKET_TYPE_CODE) → cboBucketType
   └─ CreateSpread
       ├─ AddSheet "Pack Biz"(헤더 3행) / AddSheet "Cell Biz"(헤더 3행)
       ├─ ChangeSheet "Pack Biz" (초기 활성)
       └─ InitSpread → GetSpdTitle → DM.DMF0045_GET_SPREAD_TITLE (SP DMF0045_GET_SPREAD_TITLE)
            → CreateSheetHeaderColumn → (dtTitle 행>0) SetSpreadHeaderSpan → SetSpreadColumn
          ↓
[조건 입력] cboDivision 변경 → InitSpread 재호출 / cboBucketType·chkSum → SetSpreadColumn
          ↓
[조회] FindButton → FindData
   ├─ biz:CommonData.CommonDataList [code=Measure]
   ├─ DM.DMF0045_GET_SHIPMENT_REQUEST (SP DMF0045_GET_SHIPMENT_REQUEST)
   ├─ InitSpread → DM.DMF0045_GET_SPREAD_TITLE
   └─ (행≥1) SetSpreadColumn
          ↓
[편집] InsertButton → InsertRow (FCST_TYPE·MEASURE 콤보)
       spdMain_ComboSelChange (END_CUSTOMER → FROM_SITE, FROM_SITE → MEASURE [code=MktFcstEditMeasure])
       spdMain_Changed ([code=DefaultBucketDay])
          ↓
[저장] SaveButton → SaveData → DM.DMF0045_SAVE_SHIPMENT_REQUEST (SP DMF0045_SAVE_SHIPMENT_REQUEST)
          ↓
[재조회] SaveData → FindData (위 [조회]와 같음)

[미연결] GetBizTypebyDivision → SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION (SP SCM0001_GET_BIZ_TYPE_BY_DIVISION)
         — 어떤 진입점에서도 도달하지 않음(unreached)
```

## 4. 업무 규칙 (사실 근거만)

### 4-1. 화면 코드 분기 조건

| ID | 규칙 | 근거(파일:줄) |
|---|---|---|
| R-01 | 헤더 Span과 버킷 표시는 타이틀 결과가 있을 때만 적용합니다: `dtTitle != null && dtTitle.Rows.Count > 0` | grid_code InitSpread:276/277 |
| R-02 | 조회 뒤 SetSpreadColumn은 결과 행이 있을 때만 호출합니다: `siMain.GetMaxRowIndex() >= 0` | grid_code FindData:652 |
| R-03 | 행추가는 `siMain != null && siMain.IsLock(siMain.SheetName) == false`이고 `siMain.SheetName == siMain.ActiveSheet.SheetName`일 때만 동작합니다 | grid_code InsertRow:1003/1005 |
| R-04 | FROM_SITE 콤보는 변경된 컬럼이 `END_CUSTOMER`일 때 다시 설정합니다 | grid_code spdMain_ComboSelChange:1158 |
| R-05 | MEASURE 콤보는 변경된 컬럼이 `FROM_SITE`이고, Division 컬럼과 FROM_SITE 컬럼이 모두 존재할 때(`!= -1`) 다시 설정합니다 | grid_code spdMain_ComboSelChange:1195 |
| R-06 | Bucket·Sum 변경 처리는 `siMain != null`일 때만 동작합니다 | grid_code 1136, 2136 |
| R-07 | EditButton은 `this.fps != null`일 때 활성 시트 정보를 가져옵니다 | grid_code EditButton:443 |
| R-08 | MEASURE 콤보 데이터 소스 후보는 `Data.Common(Data.Type.Measure)`, `Data.Common(Data.Type.Measure, false, "DMF0045", 시트명)`, `Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, ...)` 3가지입니다. 어느 분기를 타는지는 **확인 필요**입니다 | grid_code 1005/1195 |
| R-09 | FROM_SITE 콤보 소스는 `UserSiteByEndCustomer`(일반)와 `UserSiteByEndCustomerAuth`(권한) 두 가지입니다. 분기 조건은 **확인 필요**입니다 | grid_code 1158 |

### 4-2. 날짜·버킷 규칙

| ID | 규칙 | 근거 |
|---|---|---|
| R-B1 | Bucket 코드는 `DM.DM0003_GET_BUCKET_TYPE_CODE`(SCM_ADM_LOOKUP_MASTER_DETAIL)에서 가져옵니다. 코드가 분기하는 값은 `DAILY`, `WEEKLY`, `MONTHLY`입니다 | endpoints.csv 2266, grid_code 2152~2184 |
| R-B2 | DAILY: D_·W_ 컬럼 Visible=true(2152), 이어서 M_·W_ 컬럼 Visible=`chkSum.Checked`(2157). W_가 두 조건에 모두 해당하므로 최종 상태는 **확인 필요**입니다 | grid_code 2152/2157 |
| R-B3 | WEEKLY: D_ 숨김(2164), W_ 표시(2168), M_ = `chkSum.Checked`(2173) | grid_code |
| R-B4 | MONTHLY: D_·W_ 숨김(2180), M_ 표시(2184) | grid_code |
| R-B5 | 날짜 버킷 컬럼은 `DMF0045_GET_SPREAD_TITLE`이 `SCM_SYS_CALENDAR_M`을 참조해 만듭니다. 헤더 DAY_CODE가 SAT이면 Blue, SUN이면 Red입니다 | endpoints.csv, grid_code 346 |
| R-B6 | COLUMN_NAME에 `B_`가 포함되면(IndexOf > 0) 컬럼을 숨깁니다 | grid_code 335 |
| R-B7 | 셀 값이 바뀌면 `biz:CommonData.CommonDataList` [code=DefaultBucketDay]를 조회합니다. 조회값을 어디에 쓰는지는 **확인 필요**입니다 | flow.csv 1749/1811 |
| R-B8 | 조회 SP는 `FN_GET_SSP_ETD_DATE`와 `FN_NEXT_DAY`를 참조합니다. 계산 규칙은 SP 원문을 확인해야 합니다(**확인 필요**) | endpoints.csv |
| R-B9 | 기간 `drpPeriod`는 Enabled=false입니다. 값을 설정하는 로직은 **확인 필요**입니다 | props.csv Designer:515 |

### 4-3. SP 내부 분기·필수값·검증

| 항목 | 사실 | 상태 |
|---|---|---|
| `DMF0045_GET_SHIPMENT_REQUEST` 내부 분기 조건 | Fact Pack에는 참조 객체 목록만 있고 분기 조건 원문은 없습니다. 동적 SQL(`DYNAMIC@DMF0045_GET_SHIPMENT_REQUEST`)이 있습니다 | **확인 필요** |
| `DMF0045_SAVE_SHIPMENT_REQUEST` 내부 검증 | `SCP_MST_BOD`, `SCP_MST_DISTRIBUTION_ROUTE`, `DM_PLN_SHIPMENT_REQ`를 SELECT한 뒤 INSERT합니다. 배열 분해 함수 `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL`을 씁니다. 검증 조건 원문은 없습니다 | **확인 필요** |
| 필수 입력 | 그리드 헤더 라벨에 `*`가 붙은 컬럼: Division*, FCST Type*, Frorm ( Plant )*, To ( Sales-Site )*, Incoterms*, Trans Mode*, Model*, Project Code*, Measure*, BOD ID*. 저장 시 실제로 필수 검증을 하는지는 **확인 필요**입니다 | grid_effective.csv 라벨 원문 |
| 조회 조건 필수 여부 | Fact Pack에 없습니다 | **확인 필요** |
| 메시지 | Fact Pack에 메시지 원문이 없습니다 | **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | SP | 호출 위치 | 읽기 테이블 | 쓰기 테이블 |
|---|---|---|---|---|
| `biz:CommonData.CommonDataList` [code=MyDivision] | (코드분기) UP_FX_GetCommonDataList | InitControls:200 | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION | — |
| `biz:CommonData.CommonDataList` [code=Measure] | (코드분기) UP_FX_GetCommonDataList | InitControls:231, FindData:579, InsertRow:1004 | SCM_MST_SHEET_MEASURE, DM_MST_CUSTOMER_FCST | — |
| `biz:CommonData.CommonDataList` [code=FCST_TYPE] | (코드분기) UP_FX_GetCommonDataList, UP_FX_GETCOMMONDATALIST_DM | InsertRow:1001 | SCM_ADM_LOOKUP_MASTER_DETAIL | — |
| `biz:CommonData.CommonDataList` [code=MktFcstEditMeasure] | (코드분기) UP_FX_GetCommonDataList | spdMain_ComboSelChange:1194 | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, DM_MST_CUSTOMER_FCST | — |
| `biz:CommonData.CommonDataList` [code=DefaultBucketDay] | (코드분기) UP_FX_GetCommonDataList | spdMain_Changed:1749, 1811 | SCM_ADM_LOOKUP_MASTER_DETAIL | — |
| `DM.DMF0045_GET_SHIPMENT_REQUEST` | `DMF0045_GET_SHIPMENT_REQUEST` | FindData:609 | TB_FX_USER, SCM_MST_TITLESET_USER, SCM_MST_SHEET_MEASURE, DM_PLN_SHIPMENT_REQ, SCM_MST_SITE, SCM_MST_ITEM_SN, SCM_MST_SSO_DEPT_INFO, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_PLAN_VERSION_V, SCP_MST_BOD_N_V, SCP_PLN_SHIPMENT_PLAN_PEGGING, SCP_PLN_SHIPMENT_PLAN, SCM_SYS_CALENDAR_M, SCP_MST_BOD_V, DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SCM_DNM_CELL_INHOUSE_PLAN_SN, SSP_DNM_FP_PLAN_FROZEN, SCP_ANL_PRODUCTION_PLAN, SSP_DNM_STOCK_C, SCM_MST_LOCATION, SCP_MST_FINAL_ITEM, SSP_DNM_ESS_PACKER_STOCK_V (함수 FN_GET_SSP_ETD_DATE, FN_NEXT_DAY, STRING_SPLIT) | **SCM_MST_TITLESET_USER (INSERT)**. 임시테이블 #TBL_LOC, #TBLDYNAMIC_MEASURE, #TBLDYNAMIC_SHIP_REQ, #TBLDYNAMIC_PLAN, #TBLDYNAMIC_SHIP_ROW, #TBLDYNAMIC_CAL_QTY, #TMP_SCP_ANL_SHIPMENT_PLAN_FG, #TBLDYNAMIC_REQUESTOR, #TBLDYNAMIC_SHIP_PIVOT. 별칭 UPDATE:A / DELETE:A / UPDATE:TOT의 실제 대상은 **확인 필요** |
| `DM.DMF0045_SAVE_SHIPMENT_REQUEST` | `DMF0045_SAVE_SHIPMENT_REQUEST` | SaveData:896 | SCP_MST_BOD, SCP_MST_DISTRIBUTION_ROUTE, DM_PLN_SHIPMENT_REQ (함수 SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL) | **DM_PLN_SHIPMENT_REQ (INSERT)**, **DM_PLN_SHIPMENT_REQ_H (INSERT)**, **SCM_SYS_LOG_BATCH (INSERT, EXEC PR_SCM_SYS_LOG_BATCH)**. 임시테이블 #TBLDYNAMIC_DMF0045_SHPIMENTREQ. 별칭 UPDATE:A 대상은 **확인 필요** |
| `DM.DMF0045_GET_SPREAD_TITLE` | `DMF0045_GET_SPREAD_TITLE` | GetSpdTitle:2249 | SCM_MST_SHEET_COLUMNS, SCM_SYS_CALENDAR_M (STRING_SPLIT) | — |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | `DM0003_GET_BUCKET_TYPE_CODE` | GetBucketType:2266 | SCM_ADM_LOOKUP_MASTER_DETAIL | — |
| `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | `SCM0001_GET_BIZ_TYPE_BY_DIVISION` | GetBizTypebyDivision:2278 (**진입점 미연결**) | SCM_MST_PROJECT (REF:VALUE, REF:NODES) | — |

- 엔드포인트 목록에 없는 데이터 호출: `Data.UserSiteByEndCustomer` / `Data.UserSiteByEndCustomerAuth`(spdMain_ComboSelChange:1158). 엔드포인트와 SP는 **확인 필요**입니다.
- 조회 SP(`DMF0045_GET_SHIPMENT_REQUEST`)는 조회인데도 `SCM_MST_TITLESET_USER`에 INSERT합니다(사실). 이 부작용을 TO-BE에서 어떻게 처리할지는 §8에 남겼습니다.

## 6. Division·권한별 변형

### 6-1. Division별 그리드 메타 (grid_rule / grid_effective)

| 시트 | 40 | 81 | 81_UC | 82 | 81_HD/HG/HM/ST, EE 계열 |
|---|---|---|---|---|---|
| `Cell Biz` 컬럼(필수+기본 / 선택) | 메타 없음 | 13/0 | 13/0 | 13/0 | 메타 없음 |
| `Pack Biz` 컬럼 | 메타 없음 | 13/0 | 13/0 | 13/0 | 메타 없음 |
| `Cell Biz` SCM_MST_SHEET_MEASURE 행 | 메타 없음 | 11 | 11 | 10 | 메타 없음 |
| `Pack Biz` SCM_MST_SHEET_MEASURE 행 | 메타 없음 | 9 | 9 | 8 | 메타 없음 |

- 고정 컬럼 구성(필수 4, 기본 9, 숨김 3)은 81, 81_UC, 82가 같습니다.
- Division 82는 시트마다 Measure가 1개 적습니다. 빠지는 Measure가 무엇인지는 **확인 필요**입니다(dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv).
- Division 40과 EE 계열은 메타가 없습니다. 이 Division에서 화면을 쓸 수 있는지는 **확인 필요**입니다.
- SP 실행 결과와 메타를 비교하면 28개 시트×division 조합에서 차이가 1054건 있습니다(grid_diff.csv). 세부 내용은 **확인 필요**입니다.
- 시트 선택(Cell Biz / Pack Biz)과 Division Biz Type의 관계는 **확인 필요**입니다. 미연결 메서드 `GetBizTypebyDivision`(`SCM0001_GET_BIZ_TYPE_BY_DIVISION`)이 관련 있을 수 있으나 정적 분석으로는 확정할 수 없습니다.

### 6-2. 권한 관련 사실

| 사실 | 근거 |
|---|---|
| Division 콤보 목록이 사용자 그룹 권한 테이블 `TB_FX_USERGROUPAUTHEXTENTION`을 참조합니다 | [code=MyDivision] 코드분기 |
| `UserInfoContext.Current["NowGroupID"]`를 InitControls, InsertRow, cboDivision/clbTeam/clbCustomer 변경, spdMain_ComboSelChange에서 읽습니다 | meta_reads.csv |
| FROM_SITE 콤보에 권한 버전(`UserSiteByEndCustomerAuth`) 분기가 있습니다 | grid_code 1158 |
| `TB_FX_GroupMenuAuth` 13행, `TB_FX_ProgramInfo` 1행, `TB_FX_MenuItemInfo` 1행이 있습니다. 권한 값(C/R/U/D)은 **확인 필요**입니다 | dbmeta 8장 |
| 시트 잠금(`IsLock`)이면 행추가를 막습니다. 잠금 판정 기준은 **확인 필요**입니다 | grid_code 1003 |

## 7. 외부 인터페이스

- Fact Pack에 외부 시스템 인터페이스(I/F) 사실은 없습니다.
- 저장 SP가 `PR_SCM_SYS_LOG_BATCH`를 EXEC하고 `SCM_SYS_LOG_BATCH`에 INSERT합니다. 이것은 내부 로그 기록이며 외부 I/F가 아닙니다. 다른 배치가 이 로그를 쓰는지는 **확인 필요**입니다.

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---|---|---|
| 1 | 업무 목적과 메뉴 위치 | Fact Pack에 업무 정의 없음 |
| 2 | `GetBizTypebyDivision`(`SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`)의 런타임 사용 여부, TO-BE 반영 여부 | unreached |
| 3 | `Data.UserSiteByEndCustomer` / `UserSiteByEndCustomerAuth`의 엔드포인트·SP, 두 메서드의 분기 조건 | 1158 |
| 4 | MEASURE 콤보 소스 3가지 중 실제로 타는 분기 | 1005/1195 |
| 5 | `spdMain_TopChange`, `spdMain_KeyUp` 동작 | 배선만 확인됨 |
| 6 | `clbCustomer_SelectedIndexChanged`, `clbTeam_SelectedIndexChanged`, `cboDivision_SelectedIndexChanged`가 연쇄 갱신하는 대상 | NowGroupID·GetCheckedListValue 읽기만 확인됨 |
| 7 | Plant Site / Sales Site / End Customer / Team 콤보의 데이터 소스 | 엔드포인트 목록에 없음 |
| 8 | DAILY일 때 W_ 컬럼의 최종 표시 상태 | 2152/2157 조건 중복 |
| 9 | 조회 SP의 `SCM_MST_TITLESET_USER` INSERT, 별칭 UPDATE:A/DELETE:A/UPDATE:TOT의 실제 대상 | endpoints.csv |
| 10 | 저장 SP의 검증·분기 원문, 기존 행 처리 방식(UPDATE:A) | endpoints.csv |
| 11 | Fact Pack 4-2가 `SaveData`를 `PersonalSettingPopup.SaveData`로 해석한 것이 오판인지 여부(화면 자체에 SaveData 807/896이 있음) | Fact Pack 4-2 |
| 12 | `spdMain_Changed`에서 [code=DefaultBucketDay] 값을 어디에 쓰는지 | 1749/1811 |
| 13 | `drpPeriod` 값 설정 로직, Enabled=false인 이유 | props 515 |
| 14 | SP 결과와 메타의 차이 1054건 세부 | grid_diff.csv |
| 15 | `TB_FX_GroupMenuAuth` 13행의 권한 값 | dbmeta |

=== FILE: screen_design.md ===
# DMF0045 ShipmentRequest — 화면설계서

> 근거: AsisFacts Fact Pack(DMF0045)의 controls.csv, props.csv, events.csv, flow.csv, grid_code.csv, grid_effective.csv입니다. 없는 사실은 **확인 필요**로 적었습니다.
> 함께 보는 문서: §5 액션 명세의 엔드포인트는 업무분석서 §5, 단위테스트 근거 열과 같은 이름입니다. §3 컨트롤명은 단위테스트 절차 열에서 그대로 씁니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | DMF0045 |
| 화면 명칭(폼 Text) | `ShipmentRequest` (Designer:1039) |
| 클래스 | `DMF0045_ShipmentRequest` |
| 프로젝트 | `06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj` |
| 메뉴 위치 | **확인 필요** (`TB_FX_MenuItemInfo` 1행이 있지만 값은 Fact Pack에 없음) |
| 프레임워크 버튼 | FindButton(조회), InsertButton(행추가), SaveButton(저장), EditButton(편집) — flow.csv, grid_code 443 |
| 그리드 시트 | `Pack Biz`(초기 활성), `Cell Biz` |

## 2. 화면 레이아웃

### 2-1. 분할 구조 판정

- props.csv에는 **SplitContainer가 없습니다**(Orientation·SplitterDistance 속성 0건). 그래서 화면은 SplitContainer 분할이 아니라 **Dock 배치**로 구성됩니다.
- controls.csv parent 체인은 다음과 같습니다.

```
this (DMF0045_ShipmentRequest, Text="ShipmentRequest")
 ├─ usrConditionPanel1   [UsrConditionPanel, Dock=Top, 1284×95, UsrPanelType=HidePanel]
 │   └─ usrLayoutControl2 [UsrLayoutControl, Dock=Fill, 1284×95, Text="usrLayoutControl2"]
 │        ├─ cboDivision, cboBucketType, drpPeriod
 │        ├─ clbPlantSite, clbSalesSite, clbCustomer, clbTeam
 │        ├─ txtProject, btnProject, txtItemId, btnItemId
 │        └─ chkSum, btnMeasure, btnColumn(Visible=false)
 └─ spdMain              [FpSpread, Dock=Fill, 1284×479]
      └─ spdMain_Sheet1  [SheetView, parent 미추출]
 (parent 미추출) usrLayoutControl1 [UsrLayoutControl, Dock=Fill, 657×184] / layoutControlGroup1 657×184
```

### 2-2. 텍스트 와이어프레임 (상/하 분할, 비율은 Size 실측값으로 계산)

- 계산식: 상단 95 / (95+479) = 16.55%, 하단 479 / 574 = 83.45%
- 좌우 분할은 없습니다.

```
┌──────────────────────────────── 1284 ────────────────────────────────┐
│ [조회조건] usrConditionPanel1 (Dock Top, 높이 95 = 16.55%, 접기 HidePanel) │
│   usrLayoutControl2 / layoutControlGroup2 (1284×95)                   │
│   Division[cboDivision]  Bucket[cboBucketType]  Period[drpPeriod(비활성)] │
│   Plant Site[clbPlantSite]  Sales Site[clbSalesSite]                  │
│   End Customer[clbCustomer]  Team[clbTeam]                            │
│   Project[txtProject][btnProject]  Model[txtItemId][btnItemId]        │
│   [chkSum "Sum"] [btnMeasure] [btnColumn(Visible=false)]              │
│   ※ 위 행·열 배치 순서는 확인 필요(Location 미추출)                   │
├───────────────────────────────────────────────────────────────────────┤
│ [그리드] spdMain (Dock Fill, 높이 479 = 83.45%)                       │
│   시트 탭: [Pack Biz] [Cell Biz]  — 헤더 3행 + ColumnFooter(합계)      │
│   고정 컬럼 | M_ / W_ / D_ 버킷 컬럼(SP 생성) + SUM                     │
└───────────────────────────────────────────────────────────────────────┘
[팝업] btnProject_Click / btnItemId_Click → 선택값 반환(팝업 화면 ID 확인 필요)
```

- 조회조건 영역의 높이: emptySpaceItem8의 Size가 10×75이고 LayoutControlItem 높이가 25이므로, 높이상 25×3 = 3행분입니다. 실제 행·열 배치는 **확인 필요**입니다.
- 조회조건 LayoutControlItem 크기(props.csv): clbDivision 303×25, lblBucket 316×25, Period 236×25, lblPlantSite 303×25, lblSalesSite 303×25, lblCustomer 346×25, lblTeam 359×25, lblProject 316×25, layoutControlItem3 43×25, lblModel 309×25, layoutControlItem1 41×25, layoutControlItem5 61×25, layoutControlItem4 38×25, layoutControlItem2 44×25, layoutControlItem6 128×25, layoutControlItem7 146×25, lblItemType 297×24.
- `lblItemType`("Item Type"), layoutControlItem6, layoutControlItem7에 연결된 컨트롤은 추출되지 않았습니다(**확인 필요**).

## 3. 컨트롤 명세

| # | 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값/속성 | 필수 | 연결 이벤트 | To-Be 컴포넌트(후보) |
|---:|---|---|---|---|---|---|---|
| 1 | `usrLayoutControl1` | UsrLayoutControl | — | Dock=Fill, 657×184. parent 미추출 | — | — | 용도 **확인 필요** |
| 2 | `usrConditionPanel1` | UsrConditionPanel | — | Dock=Top, 1284×95, UsrPanelType=HidePanel | — | — | 조회조건 패널(접기) |
| 3 | `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2`(Text) | Dock=Fill, 1284×95 | — | — | 조회조건 레이아웃 |
| 4 | `cboDivision` | UsrCombo | `Division`(clbDivision.Text:936) | 257×20. 목록 = `biz:CommonData.CommonDataList` [code=MyDivision] | 확인 필요 | SelectedIndexChanged → `cboDivision_SelectedIndexChanged` | 단일 선택 콤보(Wijmo ComboBox 계열) |
| 5 | `cboBucketType` | UsrCombo | `Bucket`(lblBucket.Text:948) | 256×20. 목록 = `DM.DM0003_GET_BUCKET_TYPE_CODE`. 초기 선택값 확인 필요 | 확인 필요 | SelectedIndexChanged → `cboBucketType_SelectedIndexChanged` | 단일 선택 콤보 |
| 6 | `drpPeriod` | UsrDateRangePicker | 확인 필요(LayoutControlItem 이름 `Period`, Text 미추출) | **Enabled=false**(515), 180×20 | 확인 필요 | — | 기간(From~To) 입력, 비활성 |
| 7 | `clbPlantSite` | UsrCheckedList | `Plant Site`(901) | 242×21. 데이터 소스 확인 필요 | 확인 필요 | — | 다중 선택(MultiSelect) |
| 8 | `clbSalesSite` | UsrCheckedList | `Sales Site`(824) | 242×21. 데이터 소스 확인 필요 | 확인 필요 | — | 다중 선택 |
| 9 | `clbCustomer` | UsrCheckedList | `End Customer`(798) | 247×21. 데이터 소스 확인 필요 | 확인 필요 | SelectedIndexChanged → `clbCustomer_SelectedIndexChanged` | 다중 선택 |
| 10 | `clbTeam` | UsrCheckedList | `Team`(786) | 306×21. 데이터 소스 확인 필요 | 확인 필요 | SelectedIndexChanged → `clbTeam_SelectedIndexChanged` | 다중 선택 |
| 11 | `txtProject` | UsrMultiLineEditor | `Project`(856) | 255×21 | 확인 필요 | (`btnProject_Click`이 값 대입) | 멀티라인 입력 |
| 12 | `btnProject` | UsrButton | 확인 필요(layoutControlItem3 Text 미추출) | 39×21 | — | Click → `btnProject_Click` | 찾기 버튼 + 팝업 |
| 13 | `txtItemId` | UsrMultiLineEditor | `Model`(844) | 255×21 | 확인 필요 | (`btnItemId_Click`이 값 대입) | 멀티라인 입력 |
| 14 | `btnItemId` | UsrButton | 확인 필요(layoutControlItem1 Text 미추출) | 37×21 | — | Click → `btnItemId_Click` | 찾기 버튼 + 팝업 |
| 15 | `chkSum` | UsrCheckBox | `Sum`(278) | 70×21. 초기 체크 여부 확인 필요 | — | CheckedChanged → `chkSum_CheckedChanged` | 체크박스 |
| 16 | `btnMeasure` | UsrButton | 확인 필요(layoutControlItem4 Text 미추출) | 34×21 | — | Click → `btnMeasure_Click` | 버튼 |
| 17 | `btnColumn` | UsrButton | 확인 필요(layoutControlItem2 Text 미추출) | **Visible=false**(356), 40×21 | — | Click → `btnColumn_Click` | 미표시 버튼(TO-BE 필요 여부 확인 필요) |
| 18 | `spdMain` | FpSpread | — | Dock=Fill, 1284×479 | — | CellDoubleClick → `spdMain_CellDoubleClick` / ComboSelChange → `spdMain_ComboSelChange` / TopChange → `spdMain_TopChange` / KeyUp → `spdMain_KeyUp`. 데이터소스 dsdmPack·dsdmCell Changed → `spdMain_Changed` | Wijmo FlexGrid(시트 2개 → 탭 + Grid) |
| 19 | `spdMain_Sheet1` | SheetView | — | Designer 기본 시트. 런타임 시트는 AddSheet로 `Pack Biz`, `Cell Biz`를 생성합니다. spdMain_Sheet1과의 관계는 **확인 필요** | — | — | (TO-BE 별도 대응 없음, 확인 필요) |

- 폼 이벤트: this.Load → `Form_Load`(.ctor:165).

## 4. 그리드 명세

### 4-1. 공통 구성

| 항목 | 내용 | 출처 | 근거 |
|---|---|---|---|
| 시트 생성 | `AddSheet(spdMain, "Pack Biz", ..., 3, 1, 40)`, `AddSheet(spdMain, "Cell Biz", ..., 3, 1, 40)`. 초기 활성은 `ChangeSheet("Pack Biz")` | HARDCODED | CreateSpread:255/260/265 |
| 컬럼 생성 | `CreateSheetHeaderColumn(siMain, 3, dtTitle)`. dtTitle = `DM.DMF0045_GET_SPREAD_TITLE` | META | InitSpread:272 |
| 메타 소비 컬럼 | COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, LARGE/SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, PROGRAM_ID, SHEET_NAME | META | Fact Pack 4-2 |
| 헤더 3행 | 0행 = 대분류(LARGE_LABEL) Span + `SUM`, 1행 = 소분류(SMALL_LABEL) Span, 2행 = `SUM`. Span 기준 컬럼은 `DefColumns.Requestor` | HARDCODED+META | SetSpreadHeaderSpan:327~381 |
| `B_` 컬럼 | 숨김 | HARDCODED | 335 |
| 주말 헤더색 | DAY_CODE SAT = Blue, SUN = Red | HARDCODED | 346 |
| 날짜 버킷 컬럼 | 태그 접두어 `D_`/`W_`/`M_`. SP가 생성(SCM_SYS_CALENDAR_M) | SP 동적 | 2152~2184 |
| Footer | `ColumnFooter.Visible = true`. Set_SumValues가 MEASURE 컬럼을 참조 | HARDCODED | 285, 734 |
| 헤더 기본 스타일 | HorizontalAlignment=General, VerticalAlignment=General, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced | HARDCODED | Designer:999~1002 |

### 4-2. 시트 `Cell Biz` 컬럼 (grid_effective, 출처 META)

> 컬럼 순서는 grid_effective 나열 순서이며 SORT_ORDER_NO가 아닙니다. 실제 순서는 **확인 필요**(dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv)입니다.
> 셀 타입은 메타 CELL_CONTROL_OBJECT_TYPE_CODE에 따르지만 값은 Fact Pack에 없습니다. 코드에서 콤보를 설정하는 것이 확인된 컬럼만 '콤보'로 적었습니다.

| 컬럼 | 헤더(원문) | 타입 | 출처 | 40 | 81 | 81_UC | 82 | EE 계열 | 편집 가능 |
|---|---|---|---|---|---|---|---|---|---|
| DIVISION_ID | Division* | 확인 필요 | META | 메타 없음 | 필수 | 필수 | 필수 | 메타 없음 | 확인 필요 |
| TEAM_NAME_KO | Team | 확인 필요 | META | 메타 없음 | 필수 | 필수 | 필수 | 메타 없음 | 확인 필요 |
| END_CUSTOMER | End Customer | 콤보(ComboSelChange 대상) | META | 메타 없음 | 필수 | 필수 | 필수 | 메타 없음 | 편집 가능(콤보 변경 이벤트 존재) |
| LAST_UPDATED_BY | Requestor | 확인 필요 | META | 메타 없음 | 필수 | 필수 | 필수 | 메타 없음 | 확인 필요 |
| FCST_TYPE | FCST Type* | 콤보(InsertRow:1003) | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 행추가 시 콤보 |
| FROM_SITE | Frorm ( Plant )* | 콤보(1158) | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 편집 가능(콤보) |
| TO_SITE | To ( Sales-Site )* | 확인 필요 | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 확인 필요 |
| INCOTERMS | Incoterms* | 확인 필요 | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 확인 필요 |
| TR_MODE | Trans Mode* | 확인 필요 | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 확인 필요 |
| ITEM_ID | Model* | 확인 필요 | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 확인 필요 |
| PROJECT_CODE | Project Code* | 확인 필요 | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 확인 필요 |
| MEASURE | Measure* | 콤보(1005/1195) | META | 메타 없음 | 기본 | 기본 | 기본 | 메타 없음 | 편집 가능(콤보) |
| BOD_ID | BOD ID* | 확인 필요 | META | 메타 없음 | 숨김 | 숨김 | 숨김 | 메타 없음 | — |
| MEASURE_COLOR | MEASUR_COLOR | 확인 필요 | META | 메타 없음 | 숨김 | 숨김 | 숨김 | 메타 없음 | — |
| SHIP_FROZEN | DMF0045 | 확인 필요 | META | 메타 없음 | 숨김 | 숨김 | 숨김 | 메타 없음 | — |
| D_* / W_* / M_* | 날짜·SUM 라벨 | 숫자(확인 필요) | SP(HARDCODED 표시 제어) | — | Bucket·Sum에 따름 | 같음 | 같음 | — | 확인 필요 |

- `Cell Biz`의 SCM_MST_SHEET_MEASURE 행 수: 81 = 11, 81_UC = 11, 82 = 10.
- 원문 오탈자(`Frorm`, `MEASUR_COLOR`)와 라벨 `DMF0045`(SHIP_FROZEN)는 원문 그대로 적었습니다.

### 4-3. 시트 `Pack Biz` 컬럼 (grid_effective, 출처 META)

- 고정 컬럼 16개(표시 13, 숨김 3)의 컬럼·헤더·필수/기본/숨김 구분은 §4-2 `Cell Biz` 표와 **완전히 같습니다**(grid_effective.csv 행 단위 대조 결과).
- `Pack Biz`의 SCM_MST_SHEET_MEASURE 행 수: 81 = 9, 81_UC = 9, 82 = 8.
- 데이터소스 `dsdmPack`의 Changed 이벤트가 `spdMain_Changed`에 연결되어 있습니다(InitEvent:391). `Cell Biz` 쪽은 `dsdmCell`(394)입니다.

### 4-4. 버킷 표시 규칙 (SetSpreadColumn)

| cboBucketType | D_ | W_ | M_ | 근거 |
|---|---|---|---|---|
| DAILY | true | true(2152), 이어서 `chkSum.Checked`(2157). 최종값 **확인 필요** | `chkSum.Checked` | 2152/2157 |
| WEEKLY | false | true | `chkSum.Checked` | 2164/2168/2173 |
| MONTHLY | false | false | true | 2180/2184 |

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 로드 (this.Load) | `Form_Load` | InitControls → GetBucketType. CreateSpread → InitSpread | `biz:CommonData.CommonDataList` [code=MyDivision], [code=Measure], `DM.DM0003_GET_BUCKET_TYPE_CODE`, `DM.DMF0045_GET_SPREAD_TITLE` | cboDivision·cboBucketType 목록, 시트 `Pack Biz`/`Cell Biz`, 헤더 3행 |
| A2 | 조회 | FindButton → FindData | Measure 조회 → 데이터 조회 → InitSpread → (행≥1) SetSpreadColumn | `biz:CommonData.CommonDataList` [code=Measure], `DM.DMF0045_GET_SHIPMENT_REQUEST`, `DM.DMF0045_GET_SPREAD_TITLE` | spdMain 바인딩, 버킷 표시 |
| A3 | 행추가 | InsertButton → InsertRow | IsLock=false이고 활성 시트일 때 행 추가, 콤보 설정 | `biz:CommonData.CommonDataList` [code=FCST_TYPE], [code=Measure] | FCST_TYPE·MEASURE 셀 콤보 |
| A4 | 저장 | SaveButton → SaveData | 활성 시트(GetSheetInfo:807) 데이터 저장 → FindData 재조회 | `DM.DMF0045_SAVE_SHIPMENT_REQUEST` → 이어서 A2의 엔드포인트 | DM_PLN_SHIPMENT_REQ / _H INSERT, 재조회 |
| A5 | 편집 | EditButton | `fps != null`일 때 GetSheetInfo(활성 시트) | 없음 | **확인 필요** |
| A6 | Division 변경 | `cboDivision_SelectedIndexChanged` | GetCheckedListValue, InitSpread | `DM.DMF0045_GET_SPREAD_TITLE` | 헤더·컬럼 재구성 |
| A7 | Bucket 변경 | `cboBucketType_SelectedIndexChanged` | `siMain != null`일 때 SetSpreadColumn | 없음 | D_/W_/M_ 표시 전환 |
| A8 | Sum 체크 | `chkSum_CheckedChanged` | `siMain != null`일 때 SetSpreadColumn | 없음 | M_/W_ 표시 전환 |
| A9 | Measure 버튼 | `btnMeasure_Click` | InitSpread | `DM.DMF0045_GET_SPREAD_TITLE` | 헤더 재구성 |
| A10 | Column 버튼(Visible=false) | `btnColumn_Click` | InitSpread | `DM.DMF0045_GET_SPREAD_TITLE` | 헤더 재구성(버튼 비표시) |
| A11 | Project 찾기 | `btnProject_Click` | 선택값 반환 | 확인 필요 | `txtProject.Text = sProjectCode`(2093) |
| A12 | Model 찾기 | `btnItemId_Click` | 선택값 반환 | 확인 필요 | `txtItemId.Text = sItemId`(2116) |
| A13 | End Customer 조건 변경 | `clbCustomer_SelectedIndexChanged` | NowGroupID 읽기(1128) | 확인 필요 | **확인 필요** |
| A14 | Team 조건 변경 | `clbTeam_SelectedIndexChanged` | NowGroupID 읽기(1116/1120) | 확인 필요 | **확인 필요** |
| A15 | 헤더 더블클릭 | `spdMain_CellDoubleClick` | `e.ColumnHeader`일 때 M_ → W_/D_ 토글, W_ → D_ 토글 | 없음 | 컬럼 접기·펼치기 |
| A16 | 셀 콤보 변경 | `spdMain_ComboSelChange` | END_CUSTOMER → FROM_SITE 콤보(UserSiteByEndCustomer[Auth]). FROM_SITE → MEASURE 콤보 | `biz:CommonData.CommonDataList` [code=MktFcstEditMeasure] (+ FROM_SITE용 API 확인 필요) | 같은 행의 콤보 목록 재설정 |
| A17 | 스크롤 상단 변경 | `spdMain_TopChange` | **확인 필요** | 확인 필요 | 확인 필요 |
| A18 | 키 입력 | `spdMain_KeyUp` | **확인 필요** | 확인 필요 | 확인 필요 |
| A19 | 데이터 변경 (dsdmPack/dsdmCell.Changed) | `spdMain_Changed` | DefaultBucketDay 조회 | `biz:CommonData.CommonDataList` [code=DefaultBucketDay] | **확인 필요** |
| A20 | (진입점 미연결) | GetBizTypebyDivision | 정적 분석상 호출 경로 없음 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` (SP `SCM0001_GET_BIZ_TYPE_BY_DIVISION`) | 현행 화면 동작에 반영되지 않음(확인 필요) |

## 6. 검증·메시지

| 항목 | 사실 | 상태 |
|---|---|---|
| 조회조건 필수 검증 | Fact Pack에 없음 | **확인 필요** |
| 그리드 필수 표시 | 헤더 라벨의 `*`(Division*, FCST Type*, Frorm ( Plant )*, To ( Sales-Site )*, Incoterms*, Trans Mode*, Model*, Project Code*, Measure*, BOD ID*) | 라벨 원문 사실. 저장 시 검증하는지는 **확인 필요** |
| 행추가 차단 | 시트 잠금(IsLock) 또는 비활성 시트이면 동작하지 않음 | 사실(1003). 메시지 표시 여부는 **확인 필요** |
| 메시지 원문 | Fact Pack에 없음 | **확인 필요** |
| 저장 오류 처리 | Fact Pack에 없음 | **확인 필요** |

## 7. 권한(C/R/U/D) 사실

| 구분 | 사실 | 근거 |
|---|---|---|
| R(조회) | FindButton 진입점 존재 | flow.csv |
| C(행추가) | InsertButton 진입점 존재. IsLock=false 조건 | flow.csv, grid_code 1003 |
| U(저장) | SaveButton 진입점 존재 | flow.csv |
| D(삭제) | 버튼·API 모두 Fact Pack에 없음 | **확인 필요** |
| 메뉴 권한 값 | `TB_FX_GroupMenuAuth` 13행. 값은 Fact Pack에 없음 | **확인 필요** |
| 데이터 권한 | Division 목록 = TB_FX_USERGROUPAUTHEXTENTION([code=MyDivision]). FROM_SITE = `UserSiteByEndCustomerAuth` 분기. NowGroupID 참조 | endpoints, grid_code 1158, meta_reads |

## 8. To-Be 전환 메모 (Wijmo·Oracle 관점)

| 항목 | AS-IS 사실 | To-Be 전환 시 바뀌는 점 |
|---|---|---|
| 시트 2개 | FpSpread `AddSheet`로 `Pack Biz`/`Cell Biz` 생성 | 탭 + FlexGrid. 활성 시트명을 SHEET_NAME 파라미터로 전달해야 합니다 |
| 헤더 3행 Span | SetSpreadHeaderSpan(LARGE/SMALL 라벨 + SUM) | FlexGrid columnHeaders 다행 + allowMerging으로 재현해야 합니다 |
| 버킷 컬럼 표시 | 컬럼 Tag 접두어 D_/W_/M_로 Visible 제어 | 컬럼 binding/name 접두어로 visible 제어. DAILY W_ 최종값은 확인 후 결정해야 합니다 |
| 헤더 더블클릭 접기 | CellDoubleClick + `e.ColumnHeader` | FlexGrid hitTest(CellType.ColumnHeader)로 대체해야 합니다 |
| 셀 콤보 연쇄 | SetCellTypeCombo(END_CUSTOMER → FROM_SITE → MEASURE) | 행 단위 DataMap 또는 동적 itemsSource가 필요합니다 |
| Footer 합계 | ColumnFooter + Set_SumValues | FlexGrid columnFooters 집계 |
| 비표시 버튼 | btnColumn Visible=false | TO-BE 필요 여부를 확인해야 합니다 |
| 조회 SP | `DMF0045_GET_SHIPMENT_REQUEST`: #임시테이블 다수, 동적 SQL, STRING_SPLIT, 조회 중 SCM_MST_TITLESET_USER INSERT | Oracle 19c에는 STRING_SPLIT와 #임시테이블이 없으므로 PKG/GTT/분해 함수로 전환해야 합니다. 조회 중 INSERT는 트랜잭션 처리를 확인해야 합니다 |
| 저장 SP | `DMF0045_SAVE_SHIPMENT_REQUEST`: SCM_ARR_SPL_CNT/VAL 배열 분해, 이력·로그 INSERT | 배열 파라미터 전달 방식을 Oracle 방식으로 바꿔야 합니다. 이력(_H)과 로그(PR_SCM_SYS_LOG_BATCH) 동작은 그대로 유지해야 합니다 |
| 타이틀 SP | `DMF0045_GET_SPREAD_TITLE`: SCM_MST_SHEET_COLUMNS + SCM_SYS_CALENDAR_M, STRING_SPLIT | 위와 같이 STRING_SPLIT를 대체해야 합니다 |
| 미연결 SP | `SCM0001_GET_BIZ_TYPE_BY_DIVISION` | 현행 미사용. 이관 여부를 확인해야 합니다 |
| 메타 차이 | SP 결과와 메타의 차이 1054건 | 컬럼을 확정하기 전에 grid_diff.csv와 대조해야 합니다 |

## 9. 미확정

1. 메뉴 위치와 `TB_FX_GroupMenuAuth` 권한 값
2. 조회조건의 행·열 배치 순서, `lblItemType`·layoutControlItem6·layoutControlItem7의 연결 컨트롤, `usrLayoutControl1`의 용도
3. btnMeasure, btnColumn, btnProject, btnItemId의 표시 문구(LayoutControlItem Text 미추출)
4. drpPeriod 라벨과 값 설정 로직
5. clbPlantSite, clbSalesSite, clbCustomer, clbTeam의 데이터 소스와 연쇄 갱신
6. Project / Model 찾기 팝업 화면 ID
7. `spdMain_TopChange`, `spdMain_KeyUp`, `spdMain_Changed`(DefaultBucketDay 사용처), EditButton의 동작
8. MEASURE 콤보 3가지 소스 중 실제 분기, FROM_SITE 콤보 API
9. DAILY일 때 W_ 컬럼의 최종 Visible
10. 컬럼 SORT_ORDER_NO, 셀 타입, 편집 가능 여부, Division 82에서 빠지는 Measure
11. Division 40과 EE 계열에서 화면을 쓸 수 있는지
12. `spdMain_Sheet1`과 런타임 시트의 관계, 시트 선택 규칙(Biz Type)

=== FILE: unit_test.md ===
# DMF0045 ShipmentRequest — 단위테스트

> 근거: Fact Pack(DMF0045)과 업무분석서·화면설계서입니다. 기대결과가 Fact Pack에 없으면 **확인 필요**로 적었습니다. 이런 케이스는 AS-IS를 실행해 실측값을 확정한 뒤 판정합니다.
> 절차 열의 컨트롤명은 화면설계서 §3 컨트롤명입니다. 근거 열의 엔드포인트·SP·핸들러·시트 이름은 원문입니다.
> 주석 처리된 호출(commented_calls)은 0건이어서 테스트 대상에서 제외할 것이 없습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-DMF0045-001 | 초기화 | Division 81 권한 계정으로 로그인 | DMF0045 화면을 연다 | — | `cboDivision`에 사용자 그룹 권한(TB_FX_USERGROUPAUTHEXTENTION) Division 목록이 표시됩니다 | `Form_Load`, `biz:CommonData.CommonDataList` [code=MyDivision] (InitControls:200) |
| TC-DMF0045-002 | 초기화 | 001과 같음 | 화면을 연 뒤 `cboBucketType` 목록을 확인한다 | — | SCM_ADM_LOOKUP_MASTER_DETAIL 기반 Bucket 코드(DAILY/WEEKLY/MONTHLY 포함 여부 확인)가 표시됩니다. 초기 선택값은 **확인 필요** | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, SP `DM0003_GET_BUCKET_TYPE_CODE` (GetBucketType:2266) |
| TC-DMF0045-003 | 초기화 | 001과 같음 | 화면을 연 뒤 `spdMain` 시트 탭을 확인한다 | — | 시트 `Pack Biz`, `Cell Biz` 2개가 생성되고 `Pack Biz`가 활성화됩니다. 헤더는 3행입니다 | `Form_Load`, CreateSpread:255/260/265, `DM.DMF0045_GET_SPREAD_TITLE`, SP `DMF0045_GET_SPREAD_TITLE`, 시트 `Pack Biz`, `Cell Biz` |
| TC-DMF0045-004 | 초기화 | 001과 같음 | 화면을 열 때 호출 로그를 확인한다 | — | Measure 공통 코드 조회가 1회 호출됩니다 | `Form_Load`, `biz:CommonData.CommonDataList` [code=Measure] (InitControls:231) |
| TC-DMF0045-005 | 초기화 | 001과 같음 | `drpPeriod`, `btnColumn`의 상태를 확인한다 | — | `drpPeriod`는 비활성(Enabled=false), `btnColumn`은 비표시(Visible=false)입니다 | props.csv 515/356, `btnColumn_Click` |
| TC-DMF0045-006 | 그리드 | Division 81, 조회 완료 | `spdMain`에서 `Cell Biz` 탭을 선택해 컬럼을 확인한다 | `cboDivision`=81 | 표시 13개: Division*, Team, End Customer, Requestor, FCST Type*, Frorm ( Plant )*, To ( Sales-Site )*, Incoterms*, Trans Mode*, Model*, Nick Name, Project Code*, Measure*. 숨김: BOD_ID, MEASURE_COLOR, SHIP_FROZEN. 순서는 SORT_ORDER_NO 확인 후 판정 | 시트 `Cell Biz`, grid_effective.csv, `DM.DMF0045_GET_SPREAD_TITLE` |
| TC-DMF0045-007 | 그리드 | Division 81, 조회 완료 | `Pack Biz` 탭의 컬럼을 확인한다 | `cboDivision`=81 | 006과 같은 13개 컬럼이 표시되고 3개가 숨겨집니다 | 시트 `Pack Biz`, grid_effective.csv |
| TC-DMF0045-008 | 그리드 | 조회 결과 1행 이상 | 헤더를 확인한다 | — | 0행 대분류 Span + SUM, 1행 소분류 Span, 2행 SUM입니다. `B_` 포함 컬럼은 숨김입니다. 토요일 헤더는 Blue, 일요일 헤더는 Red입니다 | SetSpreadHeaderSpan:327~381/335/346, `DM.DMF0045_GET_SPREAD_TITLE`, 시트 `Pack Biz` |
| TC-DMF0045-009 | 그리드 | 조회 결과 1행 이상 | 그리드 하단 Footer를 확인한다 | — | ColumnFooter가 표시되고 MEASURE 기준 합계가 나옵니다. 합계 방식은 **확인 필요** | InitSpreadFooterSum:285, Set_SumValues:734, 시트 `Cell Biz` |
| TC-DMF0045-010 | division | Division 81_UC 권한 계정 | `cboDivision`=81_UC로 조회한 뒤 두 시트의 컬럼·Measure를 확인한다 | 81_UC | 두 시트 모두 표시 컬럼 13개입니다. Measure 메타 행 수: `Cell Biz` 11, `Pack Biz` 9. 실제 표시 Measure 종류 수와 일치하는지 확인합니다 | `cboDivision_SelectedIndexChanged`, `DM.DMF0045_GET_SHIPMENT_REQUEST`, 시트 `Cell Biz`, `Pack Biz` |
| TC-DMF0045-011 | division | Division 82 권한 계정 | `cboDivision`=82로 조회한 뒤 두 시트의 Measure를 확인한다 | 82 | 표시 컬럼 13개입니다. Measure 메타 행 수: `Cell Biz` 10, `Pack Biz` 8(81보다 1개 적음). 빠지는 Measure는 **확인 필요** | `DM.DMF0045_GET_SHIPMENT_REQUEST`, SP `DMF0045_GET_SHIPMENT_REQUEST`(SCM_MST_SHEET_MEASURE), 시트 `Cell Biz`, `Pack Biz` |
| TC-DMF0045-012 | division | Division 81 권한 계정 | `cboDivision`=81로 조회한 뒤 Measure 수를 확인한다 | 81 | Measure 메타 행 수: `Cell Biz` 11, `Pack Biz` 9 | `DM.DMF0045_GET_SHIPMENT_REQUEST`, 시트 `Cell Biz`, `Pack Biz` |
| TC-DMF0045-013 | division | Division 40 또는 EE 계열 계정 | 해당 Division으로 화면을 열고 조회한다 | 40 / EE | 메타(SCM_MST_SHEET_COLUMNS) 정의가 없습니다. 화면 동작(컬럼 미생성 또는 사용 불가)은 **확인 필요** | `DM.DMF0045_GET_SPREAD_TITLE`, grid_rule, 시트 `Cell Biz`, `Pack Biz` |
| TC-DMF0045-014 | 조회 | Division 81, 데이터 있음 | 조건을 입력하고 조회(FindButton)를 누른다 | `cboDivision`=81, `cboBucketType`=WEEKLY | Measure 조회 → 데이터 조회 → 타이틀 조회 순서로 호출되고 결과가 바인딩됩니다. SetSpreadColumn이 적용됩니다(652) | FindData, `biz:CommonData.CommonDataList` [code=Measure](579), `DM.DMF0045_GET_SHIPMENT_REQUEST`, SP `DMF0045_GET_SHIPMENT_REQUEST`(609), `DM.DMF0045_GET_SPREAD_TITLE` |
| TC-DMF0045-015 | 조회 | 조회 전후 SCM_MST_TITLESET_USER 행 수 기록 | 조회를 누른다 | 014와 같음 | 조회 SP가 SCM_MST_TITLESET_USER에 INSERT하는지(행 수 변화) 확인합니다. 조건은 **확인 필요** | SP `DMF0045_GET_SHIPMENT_REQUEST` (INSERT:SCM_MST_TITLESET_USER) |
| TC-DMF0045-016 | 조회 | 결과가 없는 조건 | 결과가 없는 조건으로 조회를 누른다 | `txtItemId`=존재하지 않는 모델 | 그리드가 0행입니다. `GetMaxRowIndex() < 0`이므로 SetSpreadColumn이 호출되지 않습니다. 메시지는 **확인 필요** | FindData:652, `DM.DMF0045_GET_SHIPMENT_REQUEST` |
| TC-DMF0045-017 | 조회 | 조회 SP 오류를 유발할 수 있는 환경(예: 시험 DB에서 SP 권한 회수) | 조회를 누른다 | 014와 같음 | 오류 응답 시 화면 처리(메시지·그리드 유지)는 **확인 필요**입니다. 그리드가 깨지지 않아야 합니다 | `DM.DMF0045_GET_SHIPMENT_REQUEST` 오류 응답 |
| TC-DMF0045-018 | 저장 | 조회 완료, 편집 가능 행 존재 | 행을 수정하고 저장(SaveButton)을 누른다 | Measure 값 변경 | 저장 SP가 호출되고 DM_PLN_SHIPMENT_REQ, DM_PLN_SHIPMENT_REQ_H, SCM_SYS_LOG_BATCH에 INSERT됩니다. 이후 재조회됩니다. 시험 후 원복합니다 | SaveData:896, `DM.DMF0045_SAVE_SHIPMENT_REQUEST`, SP `DMF0045_SAVE_SHIPMENT_REQUEST`, SaveData > FindData > `DM.DMF0045_GET_SHIPMENT_REQUEST` |
| TC-DMF0045-019 | 저장 | `Cell Biz` 활성 | `Cell Biz` 탭에서 수정 후 저장한다 | — | 활성 시트(GetSheetInfo:807) 데이터만 저장되는지 확인합니다 | SaveData:807, `DM.DMF0045_SAVE_SHIPMENT_REQUEST`, 시트 `Cell Biz` |
| TC-DMF0045-020 | 저장 | 필수값(`*` 컬럼) 비움 | Model* 셀을 비우고 저장한다 | ITEM_ID 공란 | 검증·오류 메시지는 **확인 필요**입니다(SP는 SCP_MST_BOD / SCP_MST_DISTRIBUTION_ROUTE 참조) | `DM.DMF0045_SAVE_SHIPMENT_REQUEST` 오류 응답, SP `DMF0045_SAVE_SHIPMENT_REQUEST` |
| TC-DMF0045-021 | 저장 | 변경 없음 | 수정 없이 저장을 누른다 | — | 처리(호출 여부·메시지)는 **확인 필요** | `DM.DMF0045_SAVE_SHIPMENT_REQUEST` |
| TC-DMF0045-022 | 그리드 | `Pack Biz` 활성, 잠금 아님 | 행추가(InsertButton)를 누른다 | — | 새 행의 FCST_TYPE 셀은 FCST_TYPE 콤보, MEASURE 셀은 Measure 콤보입니다 | InsertRow:1001/1003/1004/1005, `biz:CommonData.CommonDataList` [code=FCST_TYPE], [code=Measure], 시트 `Pack Biz` |
| TC-DMF0045-023 | 권한 | 시트 잠금 상태(IsLock=true) | 행추가를 누른다 | — | 행이 추가되지 않습니다. 메시지는 **확인 필요** | InsertRow 조건 `IsLock(...) == false` (1003) |
| TC-DMF0045-024 | 이벤트 | 화면 로드 완료 | `cboDivision`을 다른 Division으로 바꾼다 | 81 → 82 | 타이틀 SP가 다시 호출되고 헤더가 재구성됩니다. 다른 조건의 연쇄 갱신은 **확인 필요** | `cboDivision_SelectedIndexChanged`, `DM.DMF0045_GET_SPREAD_TITLE` |
| TC-DMF0045-025 | 이벤트 | 조회 결과 있음 | `cboBucketType`을 WEEKLY로 바꾼다 | WEEKLY, `chkSum` 해제 | D_ 숨김, W_ 표시, M_ 숨김 | `cboBucketType_SelectedIndexChanged`(1136), SetSpreadColumn 2164/2168/2173 |
| TC-DMF0045-026 | 이벤트 | 조회 결과 있음 | `cboBucketType`을 MONTHLY로 바꾼다 | MONTHLY | D_·W_ 숨김, M_ 표시 | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn 2180/2184 |
| TC-DMF0045-027 | 이벤트 | `cboBucketType`=DAILY, 조회 결과 있음 | `chkSum`을 체크했다가 해제한다 | `chkSum` on/off | D_는 항상 표시, M_은 `chkSum` 상태를 따릅니다. W_ 최종 표시는 **확인 필요**(2152/2157 중복) | `chkSum_CheckedChanged`(2136), SetSpreadColumn 2152/2157 |
| TC-DMF0045-028 | 이벤트 | `cboBucketType`=WEEKLY | `chkSum`을 체크한다 | `chkSum` on | M_ 컬럼이 표시됩니다 | `chkSum_CheckedChanged`, SetSpreadColumn 2173 |
| TC-DMF0045-029 | 이벤트 | 화면 로드 완료 | `btnMeasure`를 누른다 | — | 타이틀 SP가 다시 호출되고 헤더가 재구성됩니다 | `btnMeasure_Click`, `DM.DMF0045_GET_SPREAD_TITLE` |
| TC-DMF0045-030 | 이벤트 | 화면 로드 완료 | `btnColumn`이 화면에 없는지 확인한다(Visible=false) | — | 버튼이 표시되지 않습니다. 핸들러가 실행되면 타이틀 SP를 다시 호출합니다(코드 경로) | `btnColumn_Click`, `DM.DMF0045_GET_SPREAD_TITLE` |
| TC-DMF0045-031 | 이벤트 | 화면 로드 완료 | `btnProject`를 누르고 Project를 선택한다 | Project 1건 선택 | `txtProject`에 선택한 Project 코드가 들어갑니다. 팝업 화면은 **확인 필요** | `btnProject_Click`(2093) |
| TC-DMF0045-032 | 이벤트 | 화면 로드 완료 | `btnItemId`를 누르고 Model을 선택한다 | Model 1건 선택 | `txtItemId`에 선택한 Model이 들어갑니다 | `btnItemId_Click`(2116) |
| TC-DMF0045-033 | 이벤트 | 화면 로드 완료 | `clbCustomer`의 선택을 바꾼다 | 1건 체크 | 연쇄 갱신 대상은 **확인 필요**(NowGroupID 읽기만 확인). AS-IS 실측 후 판정 | `clbCustomer_SelectedIndexChanged`(1128) |
| TC-DMF0045-034 | 이벤트 | 화면 로드 완료 | `clbTeam`의 선택을 바꾼다 | 1건 체크 | 연쇄 갱신 대상은 **확인 필요**. AS-IS 실측 후 판정 | `clbTeam_SelectedIndexChanged`(1116/1120) |
| TC-DMF0045-035 | 그리드 | `cboBucketType`=MONTHLY, 조회 결과 있음 | `spdMain`의 M_ 컬럼 헤더를 더블클릭한다(2회) | — | 1회차에 W_/D_ 컬럼 표시가 토글되고, 2회차에 원래대로 돌아옵니다 | `spdMain_CellDoubleClick` 1211/1217 |
| TC-DMF0045-036 | 그리드 | W_ 컬럼 표시 상태 | W_ 컬럼 헤더를 더블클릭한다 | — | D_ 컬럼 표시가 토글됩니다 | `spdMain_CellDoubleClick` 1233 |
| TC-DMF0045-037 | 그리드 | 편집 가능 행 | END_CUSTOMER 콤보 값을 바꾼다 | 다른 End Customer | 같은 행 FROM_SITE 콤보 목록이 다시 설정됩니다(UserSiteByEndCustomer[Auth]). 목록 기준은 **확인 필요** | `spdMain_ComboSelChange`(1158) |
| TC-DMF0045-038 | 그리드 | 편집 가능 행, Division·FROM_SITE 컬럼 존재 | FROM_SITE 콤보 값을 바꾼다 | 다른 Plant | MEASURE 콤보 목록이 다시 설정됩니다 | `spdMain_ComboSelChange`(1194/1195), `biz:CommonData.CommonDataList` [code=MktFcstEditMeasure] |
| TC-DMF0045-039 | 이벤트 | 조회 결과가 화면보다 많음 | `spdMain`을 세로 스크롤한다 | — | 동작은 **확인 필요**(배선만 확인). AS-IS 실측 후 판정 | `spdMain_TopChange` (Designer:982) |
| TC-DMF0045-040 | 이벤트 | 조회 결과 있음 | `spdMain` 셀에서 키를 입력한다 | 임의 키 | 동작은 **확인 필요**(배선만 확인). AS-IS 실측 후 판정 | `spdMain_KeyUp` (Designer:983) |
| TC-DMF0045-041 | 이벤트 | `Pack Biz` 활성, 조회 결과 있음 | 셀 값을 바꾼다 | 수량 변경 | DefaultBucketDay 조회가 호출됩니다. 반영 결과는 **확인 필요** | `spdMain_Changed` (dsdmPack.Changed), `biz:CommonData.CommonDataList` [code=DefaultBucketDay](1749/1811), 시트 `Pack Biz` |
| TC-DMF0045-042 | 이벤트 | `Cell Biz` 활성, 조회 결과 있음 | 셀 값을 바꾼다 | 수량 변경 | 041과 같은 처리가 dsdmCell 기준으로 일어납니다 | `spdMain_Changed` (dsdmCell.Changed), `biz:CommonData.CommonDataList` [code=DefaultBucketDay], 시트 `Cell Biz` |
| TC-DMF0045-043 | 권한 | 그룹 권한이 다른 두 계정 | 각 계정으로 화면을 열어 `cboDivision` 목록을 비교한다 | 계정 A / B | 그룹 권한(NowGroupID, TB_FX_USERGROUPAUTHEXTENTION)에 따라 목록이 달라집니다. 메뉴 C/R/U/D 권한(TB_FX_GroupMenuAuth 13행)은 **확인 필요** | `Form_Load`, `biz:CommonData.CommonDataList` [code=MyDivision] |
| TC-DMF0045-044 | 이벤트 | 조회 결과 있음 | 편집(EditButton)을 누른다 | — | 활성 시트 정보(GetSheetInfo)를 가져옵니다. 결과는 **확인 필요** | EditButton:443 |
| TC-DMF0045-045 | 조회 | 화면 전 기능 수행(로드·조회·행추가·저장·이벤트) | 호출 로그에서 SCM0001 호출 여부를 확인한다 | — | 진입점 미연결이므로 호출되지 않습니다. 호출되면 미연결 판정을 재검토합니다 | GetBizTypebyDivision:2278, `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION`, SP `SCM0001_GET_BIZ_TYPE_BY_DIVISION` |
| TC-DMF0045-046 | 초기화 | 공통코드 조회 오류를 유발할 수 있는 환경 | 화면을 연다 | — | 오류 응답 시 화면 처리는 **확인 필요**. 화면이 비정상 종료되지 않아야 합니다 | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE` / `DM.DMF0045_GET_SPREAD_TITLE` 오류 응답 |

## 커버리지 대조

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 15 | `btnMeasure_Click` 029 · `cboDivision_SelectedIndexChanged` 010, 024 · `chkSum_CheckedChanged` 027, 028 · `btnColumn_Click` 005, 030 · `btnProject_Click` 031 · `btnItemId_Click` 032 · `cboBucketType_SelectedIndexChanged` 025, 026 · `clbCustomer_SelectedIndexChanged` 033 · `clbTeam_SelectedIndexChanged` 034 · `spdMain_CellDoubleClick` 035, 036 · `spdMain_ComboSelChange` 037, 038 · `spdMain_TopChange` 039 · `spdMain_KeyUp` 040 · `Form_Load` 001~004, 043, 046 · `spdMain_Changed` 041, 042 | 15/15 |
| 엔드포인트 6 | `biz:CommonData.CommonDataList` 001, 004, 014, 022, 038, 041 · `DM.DMF0045_GET_SHIPMENT_REQUEST` 014~017 · `DM.DMF0045_SAVE_SHIPMENT_REQUEST` 018~021 · `DM.DMF0045_GET_SPREAD_TITLE` 003, 024, 029 · `DM.DM0003_GET_BUCKET_TYPE_CODE` 002 · `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` 045 | 6/6 |
| 시트 2 | `Cell Biz` 006, 019, 042 · `Pack Biz` 007, 022, 041 | 2/2 |
| division 변형 | 81 012 · 81_UC 010 · 82 011 · 40/EE 013 | 4/4 |
| 빈 결과·오류 | 016(빈 결과) · 017, 020, 046(오류 응답) | 포함 |
