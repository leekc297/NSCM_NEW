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
