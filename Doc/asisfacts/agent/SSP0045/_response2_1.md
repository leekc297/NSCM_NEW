=== FILE: business_analysis.md ===
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

=== FILE: screen_design.md ===
# SSP0045 Shipment Request — 화면설계서

> 근거: Fact Pack(SSP0045)의 controls.csv, props.csv, events.csv, grid_effective.csv, grid_code.csv, flow.csv. 없는 사실은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0045 |
| 화면명 | `Shipment Request` (props `this.Text`, Designer.cs:631) |
| AS-IS 클래스 | `SSP0045_ShipmentRequest` (`06.UIL\GSCM.SSP.Plan.UIL`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행 존재, 값 미첨부) |
| 시트 | `Shipment Request` 1개 (`SpdSheet.shtMain`, CreateSpread:286) |
| Grid 구성 방식 | HYBRID: META(프레임워크) + DB 루프(코드) (+코드 표시/라벨 변경) |
| 프레임워크 버튼 | FindButton(조회), SaveButton(저장), EditButton(449줄, 동작 **확인 필요**) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv Dock/Size)
- props.csv에 SplitContainer(Orientation·SplitterDistance) 항목이 **없다**. 분할은 Dock(Top/Fill)으로만 구성된다.
- 세로 합계: 75(Top) + 574(Fill) = 649. 비율은 상단 11.6%, 하단 88.4%이다(Size 기준 계산값).

```
this (Form, Text="Shipment Request")
├─ usrConditionPanel1   [UsrConditionPanel] Dock=Top  Size=1129×75  PanelType=HidePanel   ── 상단 11.6%
│   └─ usrLayoutControl2 [UsrLayoutControl] Dock=Fill Size=1129×75
│        (layoutControlGroup2 1129×75 — 레이아웃 아이템이 감싸는 컨트롤)
│        ├─ lblCombo           252×29  → cboBizType     "Operation Group*"
│        ├─ lblCombo1          217×29  → cboDivision    "Division*"
│        ├─ lblItemId          141×29  → txtItem_Id     "Model"
│        ├─ layoutControlItem4  43×29  → btnItem_Id     (텍스트 없음)
│        ├─ layoutControlItem3 212×29  → clbFromSite    "From Site"
│        ├─ emptySpaceItem1    244×29  (여백)
│        ├─ lblBucket          217×26  → cboBucketType  "Bucket"
│        ├─ layoutControlItem6 252×26  → drpPeriod      "Period*"
│        ├─ layoutControlItem9 184×26  → chkSum         "Sum"
│        └─ emptySpaceItem3    456×26  (여백)
└─ spdMain              [FpSpread] Dock=Fill Size=1129×574                                 ── 하단 88.4%
     └─ spdMain_Sheet1  [SheetView] → 실행 시 AddSheet로 "Shipment Request" 시트 생성

(parent 없음) usrButton1 [UsrButton] 75×23 — 배치 위치·용도 확인 필요
(parent 없음) imageList1 [ImageList]
```

- 레이아웃 아이템을 높이로 묶으면 두 줄로 나뉜다. 29px 줄은 252+217+141+43+212+244 = 1109, 26px 줄은 217+252+184+456 = 1109이다(Size 합 계산). 각 줄 안의 좌우 순서는 Location이 추출되지 않아 **확인 필요**이다. 위 트리 순서는 controls.csv 선언 순서를 따랐다.

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────────────────────────────────────────── 1129 ─┐
│ [조회조건 usrConditionPanel1 · HidePanel · 75px]                     │
│  Operation Group* [cboBizType▼]  Division* [cboDivision▼]             │
│  Model [txtItem_Id][btnItem_Id]  From Site [clbFromSite☑▼]  (여백)    │
│  Bucket [cboBucketType▼]  Period* [drpPeriod ~ ](비활성)  ☐ Sum (여백)│
├───────────────────────────────────────────────────────────────────────┤
│ [Grid spdMain · 시트 "Shipment Request" · 574px]                       │
│ 헤더 3행: │메타 컬럼(12 표시)│ 대분류 │ … │                            │
│           │                  │ SUM │ 소분류 │ … │                       │
│           │                  │     │ SUM │ 일/주/월 컬럼 … │           │
└───────────────────────────────────────────────────────────────────────┘
```

- 버튼 영역: 화면 자체 버튼 컨트롤은 `btnItem_Id`, `usrButton1`이다. 조회와 저장은 프레임워크 버튼(FindButton/SaveButton)이 담당한다.
- 팝업: `btnItem_Id` 클릭 시 Model 선택 팝업으로 보인다(1198줄 `txtItem_Id.Text = sItemId`). 팝업의 실체는 **확인 필요**.

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrConditionPanel1` | UsrConditionPanel | - | PanelType=HidePanel, Dock=Top | - | - | 접기 가능한 조회조건 패널 |
| `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` (Text 속성 원문, 표시 라벨 아님) | Dock=Fill | - | - | 조회조건 레이아웃(그리드형 폼) |
| `cboBizType` | UsrCombo | `Operation Group*` (lblCombo) | **확인 필요** | Y | `CboBizType_SelectedIndexChanged` | Wijmo ComboBox |
| `cboDivision` | UsrCombo | `Division*` (lblCombo1) | **확인 필요** | Y | `CboDivision_SelectedIndexChanged` | Wijmo ComboBox |
| `cboBucketType` | UsrCombo | `Bucket` (lblBucket) | **확인 필요**(목록 = `DM.DM0003_GET_BUCKET_TYPE_CODE`) | N | `cboBucketType_SelectedIndexChanged` | Wijmo ComboBox (값 DAILY/WEEKLY/MONTHLY) |
| `txtItem_Id` | UsrMultiLineEditor | `Model` (lblItemId) | **확인 필요** | N | (`BtnItem_Id_Click`이 값 설정) | 다건 입력 텍스트 |
| `btnItem_Id` | UsrButton | (Text 없음) | - | - | `BtnItem_Id_Click` | 검색 팝업 버튼 |
| `drpPeriod` | UsrDateRangePicker | `Period*` (layoutControlItem6) | Enabled=false (CreateSpread:291), 값 = `SCP.SCM0001_GET_SCP_DAY_PERIOD` 관련(대입 **확인 필요**) | Y | - | DateRange(읽기 전용) |
| `clbFromSite` | UsrCheckedList | `From Site` (layoutControlItem3) | **확인 필요** | N | - (`SpdMain_CellClick`·FindData_Main에서 GetCheckedListValue로 읽음) | Wijmo MultiSelect |
| `chkSum` | UsrCheckBox | `Sum` | **확인 필요** | N | `chkSum_CheckedChanged` | CheckBox |
| `usrButton1` | UsrButton | 미추출 | - | - | 없음(배선 미추출) | **확인 필요** |
| `spdMain` | FpSpread | - | Dock=Fill | - | `SpdMain_TopChange`, `SpdMain_CellDoubleClick`, `SpdMain_CellClick`, `SpdMain_ComboSelChange` | Wijmo FlexGrid |
| `spdMain_Sheet1` | SheetView | 시트 `Shipment Request` | 헤더 3행 | - | (spdMain 이벤트 공유) | FlexGrid 데이터 뷰 |
| (화면) | Form | `Shipment Request` | - | - | `Form_Load` | 페이지 |

## 4. 그리드 명세 — 시트 `Shipment Request`

연결 규칙: META+코드연결. 헤더 3행(`SetSheetHeaderColumn(siMain, 3)`, InitSpread_2:313). 마스터-디테일 연결은 없다.

### 4-1. 메타 컬럼 (SCM_MST_SHEET_COLUMNS 18행, grid_effective.csv 순서)

| # | 컬럼 | 헤더 | 타입 | 출처 | division별 표시(14개 동일) | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | BOD_FROM_YYYYMMDD | BOD_FROM_YYYYMMDD | **확인 필요** | META | 숨김 | **확인 필요** |
| 2 | BOD_ID | BOD_ID | **확인 필요** | META | 숨김 | **확인 필요** |
| 3 | BOD_TO_YYYYMMDD | BOD_TO_YYYYMMDD | **확인 필요** | META | 숨김 | **확인 필요** |
| 4 | DIVISION_ID | Division* | **확인 필요** | META | 기본(표시) | **확인 필요** |
| 5 | FCST_TYPE | FCST Type | **확인 필요** | META | 기본 | **확인 필요** |
| 6 | FROM_SITE | From Site* | **확인 필요** | META | 기본 | **확인 필요** |
| 7 | FROZEN_YYYYMMDD | FROZEN_YYYYMMDD | **확인 필요** | META | 숨김 | **확인 필요** |
| 8 | INCOTERMS | Incoterms* | **확인 필요** | META | 기본 | **확인 필요** |
| 9 | ITEM_ID | Model* | 행 추가 시 콤보(SetCellTypeCombo 772·803) | META(+코드 셀타입) | 기본 | 시트가 잠겨 있지 않을 때 콤보 설정 |
| 10 | LAST_UPDATED_BY | Requestor | **확인 필요** | META | 기본 | **확인 필요** |
| 11 | LT_DAY | L/T(Day) | **확인 필요** | META | 기본 | **확인 필요** |
| 12 | MEASURE | Measure* | **확인 필요** | META | 숨김 | **확인 필요** |
| 13 | MEASURE_COLOR | MEASURE_COLOR | **확인 필요** | META | 숨김 | **확인 필요** |
| 14 | MEASURE_LABEL | Measure | **확인 필요** | META | 기본 | **확인 필요** |
| 15 | NICK_NAME | Nick Name | **확인 필요** | META | 기본 | **확인 필요** |
| 16 | PROJECT_CODE | Project Code | **확인 필요** | META | 기본 | **확인 필요** |
| 17 | TO_SITE | To Site* | **확인 필요** | META | 기본 | **확인 필요** |
| 18 | TR_MODE | Trans Mode* | **확인 필요** | META | 기본 | **확인 필요** |

- 표시 12, 숨김 6이다. 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 모두 같다.
- 실제 표시 순서(SORT_ORDER), 셀 타입, 폭, 정렬, 편집 여부(CELL_CONTROL_OBJECT_TYPE_CODE 등 메타 값)는 행 값이 첨부되지 않아 **확인 필요**.
- 측정값 메타 `SCM_MST_SHEET_MEASURE`는 9행이며 division 간 차이가 없다. 측정값 이름은 **확인 필요**.

### 4-2. 코드 생성 달력 컬럼 (DB 루프 — `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과)

| 조건 | API | 헤더 | 필드 | 폭 | 표시 | 출처 | 줄 |
|---|---|---|---|---:|---|---|---:|
| 컬럼명에 `B_` 포함(`IndexOf("B_") > 0`) | AddTextColumn | COLUMN_LABEL_NAME | COLUMN_NAME | 0 | 숨김 | DB_DRIVEN(코드) | 354 |
| 그 외 | AddNumColumn(숫자) | COLUMN_LABEL_NAME | COLUMN_NAME | 70 | 표시 | DB_DRIVEN(코드) | 358 |
| DAY_CODE = SAT / SUN | ForeColor | - | - | - | Blue / Red | 코드 | 362 |

- 헤더 Span: 0행 = LARGE_CLASS_LABEL_NAME, 1행 = SMALL_CLASS_LABEL_NAME, 그룹 시작 열에 `"SUM"` 헤더(368~396줄, 높이 20/30)를 둔다.
- 표시와 숨김은 다시 SetSpreadColumn(Tag 접두어 `D_`/`W_`/`M_` × `cboBucketType` × `chkSum`)이 결정한다. 규칙은 업무분석서 §4-3 표와 같다.
- 편집 가능 여부: 숫자 컬럼에 저장 대상 수량을 입력하는 것으로 보이나 잠금 규칙은 **확인 필요**.

### 4-3. 헤더 기본 스타일 (Designer.cs 580~583)
HorizontalAlignment=General, VerticalAlignment=General, NoteIndicatorColor=Red, Parent=`ColumnHeaderDefaultEnhanced`.

## 5. 액션 명세

| # | 트리거(버튼/이벤트) | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A1 | 화면 로드 | `Form_Load` | InitControls → SetChangedControl / GetBucketType / FP_Log2 → CreateSpread(AddSheet, drpPeriod 비활성, GetDayRange, InitSpread_2) | `biz:CommonData.CommonDataList`[PlantByDivisionOperation], `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `biz:CommonData.CommonDataList`[PlantSiteByDivision], `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 조회조건 콤보 채움, 시트 `Shipment Request` 생성(메타 헤더와 달력 컬럼) |
| A2 | cboDivision 변경 | `CboDivision_SelectedIndexChanged` | SetChangedControl | `biz:CommonData.CommonDataList`[PlantByDivisionOperation] | 연동 컨트롤 갱신(대상 **확인 필요**) |
| A3 | cboBizType 변경 | `CboBizType_SelectedIndexChanged` | Data.Common(PlantByDivisionOperation) | `biz:CommonData.CommonDataList`[PlantByDivisionOperation] | 연동 컨트롤 갱신(대상 **확인 필요**) |
| A4 | btnItem_Id 클릭 | `BtnItem_Id_Click` | Model 선택 | 팝업 API **확인 필요** | `txtItem_Id.Text = sItemId` |
| A5 | cboBucketType 변경 | `cboBucketType_SelectedIndexChanged` | `siMain != null`이면 SetSpreadColumn | 없음 | 달력 컬럼 표시와 숨김 재계산 |
| A6 | chkSum 체크 변경 | `chkSum_CheckedChanged` | `siMain != null`이면 SetSpreadColumn | 없음 | Sum 대상(`M_`, DAILY 시 `W_`) 컬럼 표시 토글 |
| A7 | 조회(FindButton) | (프레임워크) FindData_Main | GetCheckedListValue → InitSpread_2 → 조회 → Set_SumValues | `biz:CommonData.CommonDataList`[PlantSiteByDivision], `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SSP.SSP0045_GET_SHIPMENT_REQUEST` | 시트 재초기화와 데이터 바인딩 |
| A8 | 저장(SaveButton) | (프레임워크) SaveData | 저장 → 재조회(A7과 같음) | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` (+ A7 엔드포인트) | 저장 후 시트 갱신 |
| A9 | 시트 셀 클릭 | `SpdMain_CellClick` | GetCheckedListValue(1227·1228), ComboSelChange 해제(1252) 후 재등록(1334) | 서버 호출 여부 **확인 필요** | **확인 필요** |
| A10 | 시트 콤보 선택 | `SpdMain_ComboSelChange` | 미추출 | **확인 필요** | **확인 필요** |
| A11 | 시트 셀 더블클릭 | `SpdMain_CellDoubleClick` | 미추출 | **확인 필요** | **확인 필요** |
| A12 | 시트 스크롤 | `SpdMain_TopChange` | 미추출 | **확인 필요** | **확인 필요** |
| A13 | 행 추가 | InsertRow / InsertRow2 | ITEM_ID 콤보 = Data_SCP.Common(BODItemProjectRoute) | **확인 필요**(엔드포인트 목록에 없음) | 시트가 잠겨 있지 않으면 ITEM_ID 콤보 설정 |
| A14 | 편집(EditButton) | (프레임워크) EditButton | `fps.Name == "spdMain"`이면 GetSheetInfo | 없음 | **확인 필요** |

> 화면 834줄의 주석 처리된 호출은 현행 액션에 넣지 않았습니다.

## 6. 검증·메시지

| # | 검증 | 사실 | 메시지 |
|---|---|---|---|
| V1 | 필수 조회조건 | 라벨에 `*`: Operation Group*, Division*, Period* | 검증 코드와 메시지 **확인 필요** |
| V2 | 저장 행 키 비교 | checkValidN0: dr/cpDr의 p_division_id, p_scm_site_id, p_item_id, p_incoterms, p_transport_mode, p_plant_site_id, p_bod_id, p_project_code, p_fcst_type(+dr p_user_id) | **확인 필요** |
| V3 | 그리드 필수 컬럼 | 헤더 `*`: Division*, From Site*, Incoterms*, Model*, To Site*, Trans Mode*, Measure*(숨김) | 검증 위치와 메시지 **확인 필요** |
| V4 | 시트 잠금 | 행 추가 시 `siMain.IsLock(...) == false`일 때만 ITEM_ID 콤보 설정 | - |

## 7. 권한(C/R/U/D) 사실

| 구분 | 사실 |
|---|---|
| R | FindButton → `SSP.SSP0045_GET_SHIPMENT_REQUEST` |
| C/U | SaveButton → `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` (SP 내부 INSERT DM_PLN_SHIPMENT_REQ / UPDATE:A) |
| D | 삭제 버튼과 삭제 처리 사실 없음 → **확인 필요** |
| 권한 메타 | TB_FX_GroupMenuAuth 11행, TB_FX_ProgramInfo 1행, TB_FX_MenuItemInfo 1행. 플래그 값 **확인 필요** |
| 사용자/그룹 필터 | SetChangeControl: Filter[GROUP_ID], NowGroupID, Filter[USER_ID] → GetSSPInnerTable |

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 영역 | AS-IS | To-Be 고려사항 |
|---|---|---|
| 그리드 | FarPoint FpSpread, 헤더 3행 + ColumnHeaderSpan | Wijmo FlexGrid `columnHeaders` 3행 + 병합으로 대분류/소분류/SUM 헤더를 재현 |
| 동적 컬럼 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과 루프로 Add*Column | 같은 결과로 FE에서 컬럼 배열을 생성. `B_` 컬럼은 숨김, SAT 파랑/SUN 빨강 |
| 표시 토글 | SetSpreadColumn(Tag 접두어) | FE 상태(Bucket, Sum)로 column.visible 계산. 서버 호출 없음 |
| 메타 | SetSheetHeaderColumn(SCM_MST_SHEET_COLUMNS) | TO-BE 메타 컬럼 정의로 이관(18행, 표시 12) |
| 기간 | drpPeriod Enabled=false | 읽기 전용 DateRange, 값 = `SCP.SCM0001_GET_SCP_DAY_PERIOD` 결과 |
| SP 변환 | MSSQL SP, `#TBLDYNAMIC_*` 임시테이블, `STRING_SPLIT`, 동적 SQL | Oracle 19c: 임시테이블은 GTT/WITH절, STRING_SPLIT은 Oracle 분해 함수로 바꿔야 함. 동적 피벗(#TBLDYNAMIC_SHIP_PIVOT)은 변환 설계 필요 |
| 공통코드 | `biz:CommonData.CommonDataList`(UP_FX_GetCommonDataList / _SCP 코드분기) | TO-BE 공통코드 API(PlantByDivisionOperation, PlantSiteByDivision) |
| 저장 | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST`(SCM_ARR_SPL_CNT/VAL 배열 문자열) | 행 단위 파라미터 전달 방식으로 재설계할지 **확인 필요** |

## 9. 미확정
- `usrButton1` 용도와 배치(parent 없음).
- 조회조건 줄 안의 좌우 순서(Location 미추출).
- 콤보 초기값, 데이터 원천, PlantByDivisionOperation 결과의 대상 컨트롤.
- `SpdMain_TopChange` / `SpdMain_CellDoubleClick` / `SpdMain_ComboSelChange` / `SpdMain_CellClick`의 상세 처리.
- InsertRow/InsertRow2 진입 버튼, BODItemProjectRoute 원천, EditButton 동작.
- 메타 컬럼 순서, 타입, 편집 여부, 측정값 9행.
- DAILY에서 `W_` 컬럼의 최종 표시.
- 권한 플래그 값.

=== FILE: unit_test.md ===
# SSP0045 Shipment Request — 단위테스트

> 근거 열의 이름은 업무분석서 §5와 화면설계서 §5의 엔드포인트·SP·핸들러·시트 이름 원문을 그대로 씁니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 내부 로직이 추출되지 않은 항목은 기대결과를 "AS-IS 실행 대조(확인 필요)"로 적었습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0045-001 | 초기화 | 화면 권한이 있는 사용자로 로그인 | 화면을 연다 | - | `cboBizType`·`cboDivision` 관련 공통코드 조회가 1회 실행되고 오류가 없다 | `Form_Load`, `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] |
| TC-SSP0045-002 | 초기화 | 위와 같음 | 화면을 열고 `cboBucketType` 목록을 펼친다 | - | 버킷 코드 목록이 표시되고 DAILY/WEEKLY/MONTHLY 값이 있다 | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, SP `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SSP0045-003 | 초기화 | 위와 같음 | 화면을 열고 `drpPeriod`를 클릭·입력해 본다 | - | `drpPeriod`가 비활성(Enabled=false)이라 편집할 수 없다. 기간 값은 SP 결과와 같다(대입 방식 확인 필요) | `Form_Load`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, SP `SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0045-004 | 초기화 | 위와 같음 | 화면을 열고 `spdMain` 시트 탭과 헤더를 확인한다 | - | 시트 `Shipment Request` 1개가 생성되고 헤더가 3행이다. 달력 컬럼이 SP 결과 행 수만큼 생성된다 | `Form_Load`, `biz:CommonData.CommonDataList` [code=PlantSiteByDivision], `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, SP `SCP0009_GET_SHEET_CALENDAR_3SPAN`, 시트 `Shipment Request` |
| TC-SSP0045-005 | 이벤트 | 화면 로드 완료 | `cboDivision`의 값을 다른 Division으로 바꾼다 | Division 변경(예: 40 → 81) | 공통코드가 다시 조회되고 연동 컨트롤 목록이 Division 기준으로 갱신된다(대상 컨트롤 확인 필요) | `CboDivision_SelectedIndexChanged`, `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] |
| TC-SSP0045-006 | 이벤트 | 화면 로드 완료 | `cboBizType`의 값을 바꾼다 | Operation Group 변경 | 공통코드가 다시 조회되고 연동 목록이 갱신된다(대상 확인 필요) | `CboBizType_SelectedIndexChanged`, `biz:CommonData.CommonDataList` [code=PlantByDivisionOperation] |
| TC-SSP0045-007 | 이벤트 | 화면 로드 완료 | `btnItem_Id`를 클릭하고 팝업에서 Model을 선택해 확인한다 | Model 1건 선택 | 선택한 Model 값이 `txtItem_Id`에 들어간다(1198줄) | `BtnItem_Id_Click` |
| TC-SSP0045-008 | 이벤트 | 조회 완료(시트 존재), `chkSum` 해제 | `cboBucketType`을 DAILY로 바꾼다 | DAILY | Tag `D_` 컬럼이 표시되고 `M_` 컬럼은 숨겨진다. `W_` 컬럼 최종 표시는 AS-IS 실행 대조(확인 필요) | `cboBucketType_SelectedIndexChanged`, 시트 `Shipment Request` |
| TC-SSP0045-009 | 이벤트 | 조회 완료, `chkSum` 해제 | `cboBucketType`을 WEEKLY로 바꾼다 | WEEKLY | `D_` 숨김, `W_` 표시, `M_` 숨김 | `cboBucketType_SelectedIndexChanged`, 시트 `Shipment Request` |
| TC-SSP0045-010 | 이벤트 | 조회 완료 | `cboBucketType`을 MONTHLY로 바꾼다 | MONTHLY | `D_`·`W_` 숨김, 그 외 컬럼 표시 | `cboBucketType_SelectedIndexChanged`, 시트 `Shipment Request` |
| TC-SSP0045-011 | 이벤트 | 조회 완료, `cboBucketType` = WEEKLY | `chkSum`을 체크한 뒤 다시 해제한다 | 체크 → 해제 | 체크하면 `M_` 컬럼이 표시되고, 해제하면 숨겨진다 | `chkSum_CheckedChanged`, 시트 `Shipment Request` |
| TC-SSP0045-012 | 이벤트 | 조회 완료, `cboBucketType` = DAILY | `chkSum`을 체크한 뒤 해제한다 | 체크 → 해제 | `M_` 컬럼이 체크 상태를 따라 표시/숨김된다. `W_`는 AS-IS 실행 대조(확인 필요) | `chkSum_CheckedChanged`, 시트 `Shipment Request` |
| TC-SSP0045-013 | 조회 | 데이터가 있는 조건 | `cboBizType`, `cboDivision` 선택 후 `clbFromSite` 체크, `txtItem_Id` 입력, 조회(FindButton) 클릭 | 유효 조건 | 시트를 다시 초기화한 뒤 결과 행이 바인딩된다. 메타 표시 12컬럼과 달력 컬럼에 값이 나온다 | `SSP.SSP0045_GET_SHIPMENT_REQUEST`, SP `SSP0045_GET_SHIPMENT_REQUEST`, `biz:CommonData.CommonDataList` [code=PlantSiteByDivision], `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, 시트 `Shipment Request` |
| TC-SSP0045-014 | 조회 | 해당 데이터가 없는 조건 | 존재하지 않는 Model을 `txtItem_Id`에 넣고 조회(FindButton) 클릭 | 없는 Model 값 | 0행이 표시되고 헤더(메타·달력)는 유지되며 오류가 없다. 안내 메시지 여부는 AS-IS 대조(확인 필요) | `SSP.SSP0045_GET_SHIPMENT_REQUEST`, 시트 `Shipment Request` |
| TC-SSP0045-015 | 조회 | SP 오류를 유도할 수 있는 환경(예: DB 객체 권한 제거) | 조회(FindButton) 클릭 | - | 오류 메시지가 표시되고 시트가 깨지지 않는다(메시지 원문 확인 필요) | `SSP.SSP0045_GET_SHIPMENT_REQUEST`, SP `SSP0045_GET_SHIPMENT_REQUEST` |
| TC-SSP0045-016 | 그리드 | 조회 완료 | 시트 `Shipment Request`의 메타 컬럼 표시와 숨김을 확인한다 | - | 표시 12: Division*, FCST Type, From Site*, Incoterms*, Model*, Requestor, L/T(Day), Measure, Nick Name, Project Code, To Site*, Trans Mode*. 숨김 6: BOD_FROM_YYYYMMDD, BOD_ID, BOD_TO_YYYYMMDD, FROZEN_YYYYMMDD, MEASURE, MEASURE_COLOR | 시트 `Shipment Request`, SCM_MST_SHEET_COLUMNS |
| TC-SSP0045-017 | 그리드 | 조회 완료 | 달력 컬럼의 헤더, 색상, 숨김 컬럼을 확인한다 | - | 헤더 0행 대분류, 1행 소분류, 그룹 시작 열에 SUM 헤더. SAT 글자 Blue, SUN 글자 Red. `B_` 포함 컬럼은 숨김(폭 0). 그 외 숫자 컬럼 폭 70 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, 시트 `Shipment Request` |
| TC-SSP0045-018 | 저장 | 조회 완료, 수정 가능한 행 존재 | 시트 `spdMain`의 수량 셀을 수정하고 저장(SaveButton) 클릭 | 수량 변경 1건 | 저장이 성공하고 자동 재조회 후 변경 값이 반영된다. DM_PLN_SHIPMENT_REQ와 이력 DM_PLN_SHIPMENT_REQ_H에 행이 생성된다(DB 확인) | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST`, SP `SSP0045_SAVE_SHIPMENT_REQUEST`, `SSP.SSP0045_GET_SHIPMENT_REQUEST` |
| TC-SSP0045-019 | 저장 | 조회 완료 | 키 컬럼(Division, From Site, Model, Incoterms, Trans Mode, Project Code, FCST Type 등)이 같은 행을 두 개 만든 뒤 저장(SaveButton) | 중복 키 2행 | 저장 전 키 비교 결과가 AS-IS와 같다(판정과 메시지 확인 필요) | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` (checkValidN0) |
| TC-SSP0045-020 | 저장 | SP 오류를 유도할 수 있는 환경 | 저장(SaveButton) 클릭 | 수정 1건 | 오류 메시지가 표시되고 데이터가 부분 반영되지 않는다(롤백 확인) | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST`, SP `SSP0045_SAVE_SHIPMENT_REQUEST` |
| TC-SSP0045-021 | 저장 | 조회 완료, 변경 없음 | 수정 없이 저장(SaveButton) 클릭 | - | 저장 대상 없음 처리가 AS-IS와 같다(메시지 확인 필요) | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` |
| TC-SSP0045-022 | 그리드 | 조회 완료 | `spdMain`의 셀을 클릭한다 | 임의 셀 | `clbFromSite` 등의 체크 값을 읽어 셀 처리가 이루어진다. 클릭 후에도 콤보 선택 이벤트가 정상 동작한다(해제·재등록). 상세는 AS-IS 대조(확인 필요) | `SpdMain_CellClick` |
| TC-SSP0045-023 | 그리드 | 조회 완료, 콤보 셀 존재 | `spdMain` 콤보 셀에서 값을 선택한다 | 콤보 값 변경 | AS-IS 실행 결과와 같은 연동 동작(확인 필요) | `SpdMain_ComboSelChange` |
| TC-SSP0045-024 | 그리드 | 조회 완료 | `spdMain` 셀을 더블클릭한다 | 임의 셀 | AS-IS 실행 결과와 같은 동작(확인 필요) | `SpdMain_CellDoubleClick` |
| TC-SSP0045-025 | 그리드 | 조회 결과가 화면 높이를 넘는 상태 | `spdMain`을 세로로 스크롤한다 | 스크롤 | AS-IS 실행 결과와 같은 동작(확인 필요) | `SpdMain_TopChange` |
| TC-SSP0045-026 | 그리드 | 조회 완료, 시트 잠금 아님 | 행 추가 후 ITEM_ID(Model*) 셀을 확인한다 | `cboDivision`, `cboBizType` 선택 상태 | ITEM_ID 셀이 Division·Operation Group 조건의 콤보 목록이 된다(진입 버튼과 원천 확인 필요) | 시트 `Shipment Request` (InsertRow/InsertRow2) |
| TC-SSP0045-027 | 권한 | 조회만 허용된 그룹 사용자(권한 값 확인 필요) | 화면을 열고 조회(FindButton)와 저장(SaveButton)을 시도한다 | - | 조회는 되고 저장 버튼 동작은 TB_FX_GroupMenuAuth 권한값과 같다(확인 필요) | `SSP.SSP0045_GET_SHIPMENT_REQUEST`, `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` |
| TC-SSP0045-028 | division | Division 40 사용자 | `cboDivision` = 40으로 조회 | Division 40 | 메타 표시 컬럼 12개가 위 TC-016과 같다. 결과 데이터는 AS-IS SP 결과와 일치한다(40 전용 SP 처리 확인 필요) | `SSP.SSP0045_GET_SHIPMENT_REQUEST`, SP `SSP0045_GET_SHIPMENT_REQUEST`, 시트 `Shipment Request` |
| TC-SSP0045-029 | division | Division 81(또는 82·EE 계열) 사용자 | `cboDivision` = 81로 조회 | Division 81 | 메타 표시 컬럼 12개가 Division 40과 같다. 결과 데이터는 AS-IS SP 결과와 일치한다 | `SSP.SSP0045_GET_SHIPMENT_REQUEST`, 시트 `Shipment Request` |

### 커버리지 점검표

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001~004 |
| | `CboDivision_SelectedIndexChanged` | 005 |
| | `CboBizType_SelectedIndexChanged` | 006 |
| | `BtnItem_Id_Click` | 007 |
| | `cboBucketType_SelectedIndexChanged` | 008~010 |
| | `chkSum_CheckedChanged` | 011, 012 |
| | `SpdMain_CellClick` | 022 |
| | `SpdMain_ComboSelChange` | 023 |
| | `SpdMain_CellDoubleClick` | 024 |
| | `SpdMain_TopChange` | 025 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 001, 004, 005, 006, 013 |
| | `DM.DM0003_GET_BUCKET_TYPE_CODE` | 002 |
| | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | 003 |
| | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 004, 013, 017 |
| | `SSP.SSP0045_GET_SHIPMENT_REQUEST` | 013~015, 018, 027~029 |
| | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` | 018~021, 027 |
| 시트 | `Shipment Request` | 004, 008~013, 016, 017, 026, 028, 029 |
| 빈 결과 / 오류 | 조회 0행 / 조회 오류 / 저장 오류 | 014 / 015 / 020 |
| division | 40 / 81 | 028 / 029 |

> 주석 처리된 호출(화면 834줄)은 현행 기능이 아니므로 테스트 케이스에서 제외했습니다.
