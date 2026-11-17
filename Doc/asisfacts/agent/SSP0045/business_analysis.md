# SSP0045 Shipment Request — 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0045)과 1차 분석서(analysis.md / web_components.md / tobe_design.md). Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다.
> 대상 파일: `06.UIL\GSCM.SSP.Plan.UIL\SSP0045_ShipmentRequest.cs`(1468줄), `SSP0045_ShipmentRequest.Designer.cs`(684줄). 변형은 `only` 1종이며, 공유본과 구버전 사본은 추출되지 않았습니다(0건).

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 명칭 | SSP0045 / `Shipment Request` | props.csv `this.Text` (Designer.cs:631) |
| 클래스 | `SSP0045_ShipmentRequest` | endpoints.csv |
| 도메인 | SSP (`GSCM.SSP.Plan.UIL`) | 파일 구성 |
| 업무 목적 | 출하 요청(Shipment Request) 수량을 조회·저장한다. 조회는 `SSP0045_GET_SHIPMENT_REQUEST`, 저장은 `SSP0045_SAVE_SHIPMENT_REQUEST`가 맡는다. 저장 SP는 `DM_PLN_SHIPMENT_REQ`, `DM_PLN_SHIPMENT_REQ_H`에 INSERT한다. | endpoints.csv objects |
| 범위(포함) | 조회조건 7종(Operation Group, Division, Bucket, Model, Period, From Site, Sum), 시트 1개(`Shipment Request`), 조회(FindButton), 저장(SaveButton) | controls.csv, flow.csv |
| 범위(제외) | 화면 834줄의 주석 처리된 호출은 현행 기능이 아니므로 제외 | commented_calls.csv |
| 업무 정의(용어) | "출하 요청"의 업무적 정의, 요청 주체와 승인 흐름은 Fact Pack에 없음 → **확인 필요** | - |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---|---|---|---|
| S1 | 메뉴에서 화면을 연다 | `Form_Load` 실행<br>① InitControls → SetChangedControl → `biz:CommonData.CommonDataList`[code=PlantByDivisionOperation]<br>② InitControls → GetBucketType → `DM.DM0003_GET_BUCKET_TYPE_CODE`<br>③ CreateSpread → GetDayRange → `SCP.SCM0001_GET_SCP_DAY_PERIOD`<br>④ CreateSpread → InitSpread_2 → `biz:CommonData.CommonDataList`[code=PlantSiteByDivision]<br>⑤ InitSpread_2 → GetSpdTitle → `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 조회조건 콤보가 채워진다. 시트 `Shipment Request`가 생성된다(메타 헤더 3행과 달력 컬럼). `drpPeriod`는 편집할 수 없다(`Enabled=false`, CreateSpread:291). |
| S2 | Division을 바꾼다 | `CboDivision_SelectedIndexChanged` → SetChangedControl → `biz:CommonData.CommonDataList`[code=PlantByDivisionOperation] | Division 기준 Plant/Operation 공통코드를 다시 조회한다. 결과가 들어가는 컨트롤은 **확인 필요**. |
| S3 | Operation Group을 바꾼다 | `CboBizType_SelectedIndexChanged` → `biz:CommonData.CommonDataList`[code=PlantByDivisionOperation] (413줄) | 위와 같다. 반영 대상 컨트롤은 **확인 필요**. |
| S4 | Model 검색 버튼을 누른다 | `BtnItem_Id_Click` | `txtItem_Id.Text = sItemId` (1198줄). 팝업 종류와 데이터 원천은 **확인 필요**. |
| S5 | Bucket을 바꾸거나 Sum을 체크/해제한다 | `cboBucketType_SelectedIndexChanged`(1125) / `chkSum_CheckedChanged`(1130) → `siMain != null`이면 SetSpreadColumn 호출 | 서버를 호출하지 않는다. 컬럼 Tag 접두어(`D_`/`W_`/`M_`)에 따라 컬럼 표시와 숨김을 다시 계산한다(§4-3). |
| S6 | 조회 버튼(FindButton)을 누른다 | FindData_Main → InitSpread_2(`biz:CommonData.CommonDataList`[code=PlantSiteByDivision], `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) → `SSP.SSP0045_GET_SHIPMENT_REQUEST` (587줄) | 시트를 다시 초기화한 뒤 조회 결과를 바인딩한다. Set_SumValues는 결과의 `MEASURE` 컬럼을 사용한다(660줄). |
| S7 | 시트를 편집하고 저장 버튼(SaveButton)을 누른다 | SaveData → `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` (944줄) → FindData_Main 재조회(InitSpread_2, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SSP.SSP0045_GET_SHIPMENT_REQUEST`) | `DM_PLN_SHIPMENT_REQ`, `DM_PLN_SHIPMENT_REQ_H`, `SCM_SYS_LOG_BATCH`에 INSERT한 뒤 다시 조회한다. |
| S8 | 시트 셀을 클릭한다 | `SpdMain_CellClick`: GetCheckedListValue 호출(1227·1228), ComboSelChange 해제(1252) 후 재등록(1334) | 처리 내용(콤보 셀 데이터 설정 여부 등)은 **확인 필요**. |
| S9 | 시트 셀을 더블클릭하거나 스크롤하거나 콤보를 선택한다 | `SpdMain_CellDoubleClick` / `SpdMain_TopChange` / `SpdMain_ComboSelChange` | 내부 로직이 추출되지 않음 → **확인 필요** |
| S10 | 행을 추가한다 | InsertRow(772) / InsertRow2(803): 시트가 잠겨 있지 않으면 `ITEM_ID` 셀을 `Data_SCP.Common(BODItemProjectRoute, false, cboDivision, cboBizType)` 결과 콤보로 설정 | 진입 버튼과 BODItemProjectRoute의 원천 SP는 **확인 필요**. |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 열기] Form_Load
  ├─ InitControls
  │    ├─ SetChangedControl ──▶ biz:CommonData.CommonDataList [PlantByDivisionOperation]
  │    ├─ GetBucketType ──────▶ DM.DM0003_GET_BUCKET_TYPE_CODE
  │    └─ FP_Log2 (199, 201줄: 로그)
  └─ CreateSpread
       ├─ AddSheet(spdMain, "Shipment Request", 3, 1, 35)   (286줄)
       ├─ drpPeriod.Enabled = false                          (291줄)
       ├─ GetDayRange ────────▶ SCP.SCM0001_GET_SCP_DAY_PERIOD
       └─ InitSpread_2
            ├─ biz:CommonData.CommonDataList [PlantSiteByDivision]
            ├─ GetSpdTitle ───▶ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN
            ├─ SetSheetHeaderColumn(siMain, 3)  ← 메타 SCM_MST_SHEET_COLUMNS
            ├─ InitSpreadDateColumn            ← 달력 컬럼 DB 루프
            └─ SetSpreadColumn                 ← Bucket·Sum 기준 표시

[조건 변경] cboDivision / cboBizType ──▶ biz:CommonData.CommonDataList [PlantByDivisionOperation]
[표시 변경] cboBucketType / chkSum ──▶ SetSpreadColumn (서버 호출 없음)

[조회] FindButton ▶ FindData_Main
  ├─ GetCheckedListValue (565, 568, 570줄)
  ├─ InitSpread_2 (위와 같음: PlantSiteByDivision + 3SPAN 달력)
  └─ SSP.SSP0045_GET_SHIPMENT_REQUEST ▶ 바인딩 ▶ Set_SumValues

[저장] SaveButton ▶ SaveData
  ├─ (checkValidN0: 행 키 컬럼 비교 — 호출 위치와 판정은 확인 필요)
  ├─ SSP.SSP0045_SAVE_SHIPMENT_REQUEST
  └─ FindData_Main 재조회 (위 [조회]와 같음)
```

## 4. 업무 규칙 (사실 기반)

### 4-1. 필수값 (라벨의 `*` 표기)
| 조회조건 | 라벨 원문 | 필수 표기 | 근거 |
|---|---|---|---|
| cboBizType | `Operation Group*` | `*` | props lblCombo.Text (475줄) |
| cboDivision | `Division*` | `*` | props lblCombo1.Text (487줄) |
| drpPeriod | `Period*` | `*` | props layoutControlItem6.Text (540줄) |
| cboBucketType / txtItem_Id / clbFromSite / chkSum | `Bucket` / `Model` / `From Site` / `Sum` | 없음 | props |

- 필수값 미입력 시 처리하는 검증 코드와 메시지는 **확인 필요**(미추출).

### 4-2. 기간(Period) 규칙
- `drpPeriod.Enabled = false` (CreateSpread:291). 사용자는 기간을 편집할 수 없다.
- 로드 시 `SCM0001_GET_SCP_DAY_PERIOD`를 호출한다(GetDayRange:647). 이 SP는 `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, `CTE_DATE`를 SELECT하고 `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE`를 참조한다.
- SP 결과를 drpPeriod에 대입하는 코드와 기간 산출 규칙(일수 등)은 **확인 필요**.

### 4-3. 버킷(Bucket) / Sum 표시 규칙 (SetSpreadColumn 1140~1164)
| cboBucketType 값 | 컬럼 Tag 조건 | Visible | 줄 |
|---|---|---|---:|
| DAILY | `D_` 또는 `W_`로 시작 | true | 1140 |
| DAILY | `M_` 또는 `W_`로 시작 | `chkSum.Checked` | 1144 |
| WEEKLY | `D_`로 시작 | false | 1149 |
| WEEKLY | `W_`로 시작 | true | 1152 |
| WEEKLY | `M_`로 시작 | `chkSum.Checked` | 1156 |
| MONTHLY | `D_` 또는 `W_`로 시작 | false | 1161 |
| MONTHLY | 그 외 | true | 1164 |

- 버킷 코드 목록은 `DM0003_GET_BUCKET_TYPE_CODE`(`SCM_ADM_LOOKUP_MASTER_DETAIL`)에서 온다. 코드가 비교하는 값은 `DAILY`/`WEEKLY`/`MONTHLY`이다.
- DAILY일 때 `W_` 컬럼은 1140줄과 1144줄 조건에 모두 해당한다. 최종 표시 값은 if/else 구조를 실행해 확인해야 한다 → **확인 필요**.
- 이 규칙은 `siMain != null`일 때만 적용된다(1125, 1130줄).

### 4-4. 달력 컬럼 규칙 (InitSpreadDateColumn)
- 컬럼 원천은 `SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과(`COLUMN_NAME`, `COLUMN_LABEL_NAME`, `DAY_CODE`, `LARGE_CLASS_LABEL_NAME`, `SMALL_CLASS_LABEL_NAME`)이다.
- 컬럼명에 `B_`가 있으면(`IndexOf("B_") > 0`) 텍스트 컬럼(폭 0, 숨김)으로 만든다(354줄). 그 외는 숫자 컬럼(폭 70, 표시)이다(358줄).
- `DAY_CODE`가 SAT이면 글자색 Blue, SUN이면 Red(362줄)이다.
- 헤더는 3단이다. 0행은 대분류, 1행은 소분류이며, 그룹 시작 열에 `"SUM"` 헤더가 붙는다(368~396줄).

### 4-5. 저장 전 키 비교 (checkValidN0 1396~1436)
- `dr`는 `p_division_id, p_scm_site_id, p_item_id, p_incoterms, p_transport_mode, p_plant_site_id, p_user_id, p_bod_id, p_project_code, p_fcst_type`를 읽는다.
- `cpDr`는 같은 목록에서 `p_user_id`를 뺀 9개를 읽는다.
- 두 행을 비교해 중복이나 유효성을 판정하는 것으로 보이지만, 판정식·호출 위치·메시지는 **확인 필요**.

### 4-6. SP 분기 조건
- `SSP0045_GET_SHIPMENT_REQUEST`는 `#TBLDYNAMIC_SCP0045_40_STD`, `SSP_ANL_SHIP_PLAN_40`을 참조하고 동적 SQL(`DYNAMIC@SSP0045_GET_SHIPMENT_REQUEST`)을 쓴다. 분기 조건(division 40 여부 등)은 추출되지 않음 → **확인 필요**.
- `SSP0045_SAVE_SHIPMENT_REQUEST`는 `SCM_ARR_SPL_CNT`, `SCM_ARR_SPL_VAL`을 참조한다(배열 문자열 분해로 보임). `UPDATE:A`의 실제 대상 테이블(별칭 A)은 **확인 필요**.

### 4-7. 행 추가 규칙
- 시트가 잠겨 있지 않을 때만(`siMain.IsLock(siMain.SheetName) == false`) `ITEM_ID` 셀을 콤보로 설정한다. 콤보 데이터는 `Data_SCP.Common(Data_SCP.Type.BODItemProjectRoute, false, cboDivision.ControlValues, cboBizType.ControlValues)`이다(772, 803줄).

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| # | 엔드포인트 | SP | 호출 위치(메서드:줄) | 진입점 | 읽기(SELECT/REF) | 쓰기 |
|---|---|---|---|---|---|---|
| D1 | `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] | - (코드분기 `UP_FX_GetCommonDataList`) | SetChangedControl:268, CboBizType_SelectedIndexChanged:413 | `Form_Load`, `CboDivision_SelectedIndexChanged`, `CboBizType_SelectedIndexChanged` | SCM_MST_SITE / REF STRING_SPLIT | 없음 |
| D2 | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] | - (코드분기 `UP_FX_GetCommonDataList`, `UP_FX_GetCommonDataList_SCP`) | InitSpread_2:299 | `Form_Load`, FindButton, SaveButton(재조회) | SCM_MST_SITE / REF STRING_SPLIT. 결과 CODE·NAME 사용(302·303줄) | 없음 |
| D3 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | `DM0003_GET_BUCKET_TYPE_CODE` | GetBucketType:279 | `Form_Load` | SCM_ADM_LOOKUP_MASTER_DETAIL | 없음 |
| D4 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | `SCM0001_GET_SCP_DAY_PERIOD` | GetDayRange:647 | `Form_Load` | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, CTE_DATE / REF FN_MULTY_TIME, FN_WEEKOFDAY_DATE | 없음 |
| D5 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | `SCP0009_GET_SHEET_CALENDAR_3SPAN` | GetSpdTitle:1115 | `Form_Load`, FindButton, SaveButton(재조회) | SCM_SYS_CALENDAR_M | 없음 |
| D6 | `SSP.SSP0045_GET_SHIPMENT_REQUEST` | `SSP0045_GET_SHIPMENT_REQUEST` | FindData_Main:587 | FindButton, SaveButton(재조회) | SCP_PLAN_VERSION_V, SCP_PLN_SHIPMENT_PLAN_PEGGING, SCP_PLN_SHIPMENT_PLAN, SCP_MST_BOD_N_V, SCP_ANL_SHIPMENT_PLAN_SEMI, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_CONFIRM, RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, SCM_DNM_EXFACTORY_RESULT, SCP_MST_FINAL_ITEM, DM_PLN_SHIPMENT_REQ, SSP_DNM_SHIP_RESULT_OWMS_V, SSP_ANL_SHIP_PLAN_40, SCM_DNM_CELL_INHOUSE_PLAN_SN, SCM_DNM_PLAN_FROZEN_V, SCM_MST_ITEM_SN, SSP_DNM_STOCK_C, SCM_MST_LOCATION, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE / REF FN_NEXT_DAY, STRING_SPLIT, FN_LIST_LOOKUP_VALUE, FN_GET_ANL_SHIP_FROZEN_DAY_CNT | 임시테이블만: #TBLDYNAMIC_PLAN, #TBLDYNAMIC_SHIP_ROW(INSERT/UPDATE), #TBLDYNAMIC_CAL_QTY, #TBLDYNAMIC_FILTER, #TMP_SCP_ANL_SHIPMENT_PLAN_FG, #TBLDYNAMIC_PLAN_ERP_RESULT, #TBLDYNAMIC_SHIP_REQ, #TBLDYNAMIC_SHIP_REQ_OWMS_RESULT, #TBLDYNAMIC_SCP0045_40_STD, #STOCK, #TBLDYNAMIC_REQUESTOR, #TBLDYNAMIC_SHIP_PIVOT / 동적 SQL |
| D7 | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` | `SSP0045_SAVE_SHIPMENT_REQUEST` | SaveData:944 | SaveButton | DM_PLN_SHIPMENT_REQ / REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | **DM_PLN_SHIPMENT_REQ(INSERT)**, **DM_PLN_SHIPMENT_REQ_H(INSERT)**, **SCM_SYS_LOG_BATCH(INSERT)**, UPDATE:A(대상 **확인 필요**), #TBLDYNAMIC_SSP0045_SHPIMENTREQ(CREATE/INSERT). SP 내부에서 EXEC PR_SCM_SYS_LOG_BATCH 실행 |

> 화면 834줄에 있는 로그 SP 직접 호출은 **주석 처리**되어 있어 현행 기능이 아닙니다. 위 D7의 로그 기록은 저장 SP **내부** EXEC 체인의 사실입니다.

## 6. division·권한별 변형

### 6-1. division
| 구분 | 사실 | 근거 |
|---|---|---|
| 메타 컬럼 | `SCM_MST_SHEET_COLUMNS` 12/0, `SCM_MST_SHEET_MEASURE` 9/0. 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같음 | Fact Pack §10 |
| 최종 Grid | 모든 division에서 표시 컬럼 12개로 같음. 코드에 division 분기 Grid 변경 없음(판단불가 0건) | Fact Pack §12 |
| SP 내부 | `SSP0045_GET_SHIPMENT_REQUEST`가 division 40 전용으로 보이는 객체(`SSP_ANL_SHIP_PLAN_40`, `#TBLDYNAMIC_SCP0045_40_STD`)를 참조함. 분기 조건과 결과 차이는 **확인 필요** | endpoints.csv |
| 조건 연동 | Division 변경 시 `biz:CommonData.CommonDataList`[PlantByDivisionOperation] 재조회. 행 추가 시 ITEM_ID 콤보가 Division·Operation Group 조건에 따름 | flow.csv, grid_code.csv |

### 6-2. 권한
- `TB_FX_GroupMenuAuth` 11행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행이 있다. C/R/U/D 플래그 값은 첨부되지 않음 → **확인 필요**.
- `SetChangeControl`(169~176)은 `Filter[GROUP_ID]`, `UserInfoContext.Current.NowGroupID`, `Filter[USER_ID]`를 사용한 뒤 `GetSSPInnerTable`을 호출한다. 그룹·사용자 기준 필터를 적용한다는 사실만 확인되었다.
- 화면에서 쓰는 프레임워크 버튼은 FindButton, SaveButton, EditButton(449줄)이다. 버튼별 권한 연동은 **확인 필요**.

## 7. 외부 인터페이스
- Fact Pack에 외부 시스템 연계(I/F) 호출은 없다.
- 조회 SP가 참조하는 `SSP_DNM_SHIP_RESULT_OWMS_V`(OWMS 실적 뷰), `RESULT_ERP_C_EXIST`/`RESULT_ERP_C_NON`(ERP 관련 이름)은 DB 객체 참조일 뿐이다. 실제 외부 I/F 여부와 객체 성격은 **확인 필요**.

## 8. 미확정·확인 필요

| # | 항목 | 이유 |
|---|---|---|
| U1 | 업무 정의(출하 요청의 요청·승인 주체) | Fact Pack 범위 밖 |
| U2 | PlantByDivisionOperation 결과가 들어가는 컨트롤(cboBizType/clbFromSite 등) | 대입 코드 미추출 |
| U3 | cboBizType·cboDivision 콤보의 데이터 원천 | 미추출 |
| U4 | `SCM0001_GET_SCP_DAY_PERIOD` 결과를 drpPeriod에 대입하는 방식 | 미추출 |
| U5 | DAILY 버킷에서 `W_` 컬럼의 최종 표시 여부 | 1140·1144 조건 중첩 |
| U6 | checkValidN0의 판정식, 호출 위치, 메시지 | 미추출 |
| U7 | `SSP0045_GET_SHIPMENT_REQUEST` 내부 division 40 분기 조건 | 분기 미추출 |
| U8 | 저장 SP의 `UPDATE:A` 대상 테이블 | 별칭만 추출 |
| U9 | `Data_SCP.Common(BODItemProjectRoute)`의 원천 SP, InsertRow/InsertRow2 진입 버튼 | 엔드포인트 목록에 없음 |
| U10 | SaveButton:527의 `SaveData`가 `PersonalSettingPopup.SaveData`로 매핑된 건(오매핑 가능성) | 이름 충돌 |
| U11 | 권한 C/R/U/D 실제 값 | 메타 행 값 미첨부 |
| U12 | `SpdMain_TopChange`, `SpdMain_CellDoubleClick`, `SpdMain_ComboSelChange` 내부 로직 | 미추출 |
| U13 | 측정값(SCM_MST_SHEET_MEASURE 9행) 목록과 순서 | 행 값 미첨부 |
| U14 | 조건 저장(TB_FX_SearchCondition 55행) 항목 | 행 값 미첨부 |
