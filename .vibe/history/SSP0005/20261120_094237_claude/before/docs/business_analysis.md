# SSP0005 — Shipment Working Day 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0005)과 1차 분석서(analysis.md, web_components.md, tobe_design.md)입니다. Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> 대상 파일은 모두 현행 단일본(`only`)입니다.
> - `06.UIL\GSCM.SSP.Plan.UIL\SSP0005_ShipmentWorkingDay.cs` (955줄)
> - `SSP0005_ShipmentWorkingDay.Designer.cs` (545줄)

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SSP0005 / `SSP0005_ShipmentWorkingDay` | files |
| 도메인 | SSP (`GSCM.SSP.Plan.UIL`) | files |
| Form Text 원문 | `Working Time` | props.csv `this.Text`(501) |
| 메인 시트 | `Shipment Working Day` | grid_code `AddSheet`(179) |
| 업무 대상 데이터 | `SSP_MST_SHIP_CALENDAR`를 조회하고 저장합니다(UPDATE). | endpoints.csv objects |
| 범위(코드로 확인된 기능) | 조회(FindButton), 저장(SaveButton), 일괄 입력(btnInput), 요일 선택에 따른 입력값 활성/비활성, 헤더 더블클릭으로 컬럼 접기/펼치기 | flow.csv, events.csv |
| 범위 밖(확인된 진입점 없음) | 신규·삭제. `EditButton`(352)은 `GetSheetInfo` 호출만 추출되었습니다. | grid_code |
| 업무 목적 서술 | 출하 캘린더(`SSP_MST_SHIP_CALENDAR`)의 일자별 값을 Yes/No 콤보로 편집하는 화면입니다. 업무적 의미(근무일/출하 가능일 등)는 **확인 필요**입니다. | AddComboColumn `YesOrNo`(263) |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---:|---|---|---|
| S1 | 화면 열기 | `Form_Load` → `InitControls`에서 `biz:CommonData.YesOrNo`를 `cboInputValue`에 바인딩합니다(168). `GetDayRange`가 `SCP.SCM0001_GET_SCP_PERIOD`(SP `SCM0001_GET_SCP_PERIOD`)를 호출합니다(941). `CreateSpread > InitSpread > GetSpdTitle`이 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`(SP `SCP0009_GET_SHEET_CALENDAR_3SPAN`)을 호출합니다(925). | 조회조건이 초기화되고, 시트 `Shipment Working Day`의 메타 컬럼과 날짜 컬럼 헤더가 생성됩니다. 기간 값을 `drpPeriod` 초기값으로 쓰는지는 **확인 필요**입니다. |
| S2 | Company·Division·Period*·Day of the week를 지정 | Company·Division·Day of the week의 데이터 원천은 `biz:CommonData.CommonDataList`입니다(코드 Company / MyDivision / LookupCommon, 필드 45~47). 바인딩 경로는 unreached로 판정되어 **확인 필요**입니다. | 조건 입력 |
| S3 | 조회(FindButton) | `FindData_Main`이 Division 등 체크 목록 값을 `GetCheckedListValue`(387·388)로 만듭니다. 이어 `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`(SP `SSP0005_GET_SHIPMENT_WORKING_DAY`)를 호출하고(403), `InitSpread > GetSpdTitle`로 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`을 다시 호출합니다. | 그리드가 다시 구성되고 데이터가 표시됩니다. |
| S4 | Day of the week 변경 | `CboDayWeek_SelectedIndexChanged` → `GetCheckedListValue`(660) → `cboInputValue.Enabled = false`(663) 또는 `true`(666) | Input Value가 활성화되거나 비활성화됩니다. 분기 조건은 **확인 필요**입니다. |
| S5 | Input 버튼(btnInput) 클릭 | `BtnInput_Click` → `GetCheckedListValue`(682). `dsdm.Changed -= SpdMain_Changed`(725)로 해제한 뒤 처리하고 `+=`(821)로 다시 연결합니다. 서버 호출은 추출되지 않았습니다. | 그리드에 일괄 반영됩니다. 반영 대상과 방식은 **확인 필요**입니다. |
| S6 | 그리드 셀 값 변경 | `SpdMain_Changed`가 자기 자신을 `-=`(878) / `+=`(902)로 해제·재연결합니다. | 그 사이 처리 내용은 **확인 필요**입니다. |
| S7 | 컬럼 헤더 더블클릭 | `SpdMain_CellDoubleClick`가 `e.ColumnHeader`일 때만 동작합니다. `M_` 헤더면 `W_` 컬럼과 보이는 `D_` 컬럼을 반전하고, `W_` 헤더면 `D_` 컬럼을 반전합니다. | 컬럼 접기/펼치기 |
| S8 | 저장(SaveButton) | `SaveData_Main`이 `GetChanges`(538, ROW_ID 기준)로 변경분을 추출합니다. 이어 `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`(SP `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`, 535·536·537 참조)를 호출하고 `FindData_Main`으로 재조회합니다. | `SSP_MST_SHIP_CALENDAR`가 UPDATE되고 `SCM_SYS_LOG_BATCH`에 INSERT됩니다. 이후 재조회합니다. |
| S9 | 그리드 스크롤 | `SpdMain_TopChange` | 내부 동작은 **확인 필요**입니다. |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 열기] Form_Load
  ├─ InitControls
  │    ├─ cboInputValue ← biz:CommonData.YesOrNo (168)
  │    └─ GetDayRange → SCP.SCM0001_GET_SCP_PERIOD (941)
  └─ CreateSpread → AddSheet("Shipment Working Day", 3, 1, 35) (179)
       └─ InitSpread
            ├─ GetSpdTitle → SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN (925)
            ├─ SetSheetHeaderColumn(spdInfo, 3) : 메타 COMPANY_ID, DIVISION_ID (196)
            └─ InitSpreadDateColumn : 날짜 Combo 컬럼(YesOrNo) 루프 생성 (198/263)
        ↓
[조건 입력] cboCompany / clbDivision / drpPeriod / cboDayWeek(→ CboDayWeek_SelectedIndexChanged) / cboInputValue
        ↓
[조회] FindButton → FindData_Main
  ├─ SSP.SSP0005_GET_SHIPMENT_WORKING_DAY (403)
  └─ InitSpread > GetSpdTitle → SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN (925)
        ↓
[편집] 셀 직접 변경(SpdMain_Changed) / 일괄 입력(BtnInput_Click) / 헤더 접기(SpdMain_CellDoubleClick)
        ↓
[저장] SaveButton → SaveData_Main
  ├─ GetChanges (538, ROW_ID)
  ├─ SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW (535·536·537)
  └─ FindData_Main 재조회 (403 → 925)
```

## 4. 업무 규칙 (사실 근거)

| # | 규칙 | 근거 | 비고 |
|---:|---|---|---|
| R1 | 기간(Period)에 필수 표시 `*`가 있습니다. | props `layoutControlItem6.Text = "Period*"`(391) | 실제 미입력 검증 코드는 **확인 필요** |
| R2 | Division은 체크 목록(다중 선택)이며 값은 `CODE` 기준으로 연결됩니다. | `UsrCheckedList`, `GetCheckedListValue`(FindData_Main:387·388), 메타 컬럼 CODE | 구분자·파라미터명은 **확인 필요** |
| R3 | Division 목록은 사용자 그룹(`UserInfoContext.Current.NowGroupID`)을 기준으로 합니다. | meta_reads(45), `[code=MyDivision]` 코드분기 SELECT `SCM_MST_DIVISION`, `TB_FX_USERGROUPAUTHEXTENTION` | |
| R4 | Day of the week 선택에 따라 Input Value 활성 여부가 바뀝니다. | `CboDayWeek_SelectedIndexChanged` 663(false)/666(true) | 조건은 **확인 필요** |
| R5 | 일괄 입력 중에는 셀 변경 이벤트(`SpdMain_Changed`)를 해제합니다. | events 725(-=)/821(+=) | |
| R6 | `SpdMain_Changed`는 처리 중 자기 재호출을 막습니다. | events 878(-=)/902(+=) | |
| R7 | 날짜 컬럼은 SCP0009 결과 행마다 생성되는 Combo(YesOrNo) 셀입니다. 폭은 70이고 가로·세로 모두 Center입니다. | grid_code 263 | |
| R8 | 컬럼명에 `B_`가 포함되면(`IndexOf("B_") > 0`) AddComboColumn 분기를 타지 않습니다. | grid_code 263 조건 `else!(...)` | B_ 분기 처리 내용은 **확인 필요** |
| R9 | 요일 색상 규칙: `DAY_CODE`가 SAT이면 Blue, SUN이면 Red(ForeColor)입니다. | grid_code 267 | |
| R10 | 헤더는 3단입니다. row 0 = `LARGE_CLASS_LABEL_NAME`, row 1 = `SMALL_CLASS_LABEL_NAME`이 같은 값끼리 병합되며 높이는 20입니다. | grid_code 196(인자 3), 274·280·290·301·303 | 버킷 단위(월·주·일)와의 대응은 **확인 필요** |
| R11 | 버킷 접기/펼치기: Tag 접두어 `M_`·`W_`·`D_` 계층에 따라 Visible을 반전합니다. | grid_code 840·843·854 | 접두어의 업무 의미는 **확인 필요** |
| R12 | 저장 대상은 변경 행뿐입니다(`GetChanges`, ROW_ID). | 4-2 GetChanges(538) | |
| R13 | 저장할 때 배치 로그를 남깁니다. | SP 객체 `EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN`, `INSERT:SCM_SYS_LOG_BATCH` | |
| R14 | 저장 후 자동으로 재조회합니다. | flow `SaveButton > SaveData_Main > FindData_Main` | |
| R15 | 조회 SP는 동적 피벗을 사용합니다. | `INSERT:#TBLDYNAMICPIVOT_SSP0005`, `DYNAMIC@SSP0005_GET_SHIPMENT_WORKING_DAY`, `REF:STRING_SPLIT` | |
| R16 | 기간 산출 SP는 달력과 주차 함수를 참조합니다. | `SCM0001_GET_SCP_PERIOD`: `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE`, `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, `CTE_DATE` | 산출 규칙의 상세는 **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | SP | 호출 지점 | 읽기 | 쓰기 | 화면설계서 §5 액션 |
|---|---|---|---|---|---|
| `biz:CommonData.YesOrNo` | - (biz) | InitControls:168, field dtYesOrNo:48 | 확인 필요 | - | A1 화면 로드 |
| `biz:CommonData.CommonDataList` [code=Company] | - (biz, 코드분기 `UP_FX_GetCommonDataList` / `UP_FX_GetCommonDataList_SCP_ALL`) | field dtCompany:46 (unreached) | `SCM_MST_COMPANY_SN`, `SCM_MST_PLANT_SN` | - | A1 화면 로드(확인 필요) |
| `biz:CommonData.CommonDataList` [code=MyDivision] | - (biz, `UP_FX_GetCommonDataList`) | field dtMyDivision:45 (unreached) | `SCM_MST_DIVISION`, `TB_FX_USERGROUPAUTHEXTENTION` | - | A1 화면 로드(확인 필요) |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | - (biz, `UP_FX_GetCommonDataList`) | field dtDayWeek:47 (unreached) | `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL` | - | A1 화면 로드(확인 필요) |
| `biz:CommonData.CommonDataList` [code=PERIOD_{p:value}] | - (biz) | SetChangedPeriod:910 (unreached) | 확인 필요(결과 FROM_VALUE·TO_VALUE 사용) | - | 확인 필요 |
| `SCP.SCM0001_GET_SCP_PERIOD` | `SCM0001_GET_SCP_PERIOD` | GetDayRange:941 | `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, (함수) `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE`, (CTE) `CTE_DATE` | - | A1 화면 로드 |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | `SCP0009_GET_SHEET_CALENDAR_3SPAN` | GetSpdTitle:925 | `SCM_SYS_CALENDAR_M` | - | A1 화면 로드, A2 조회, A3 저장 후 재조회 |
| `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` | `SSP0005_GET_SHIPMENT_WORKING_DAY` | FindData_Main:403 | `SSP_MST_SHIP_CALENDAR`, `SCM_SYS_CALENDAR_M` | (임시) `#TBLDYNAMICPIVOT_SSP0005` | A2 조회, A3 저장 후 재조회 |
| `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` | `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` (+ `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`) | SaveData_Main:535·536·537 | - | `SSP_MST_SHIP_CALENDAR`(UPDATE), `SCM_SYS_LOG_BATCH`(INSERT) | A3 저장 |

> 주석 처리된 호출 `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY`(569)와 `SCP.GET_DATE_RANGE_1MONTH`(940)는 현행 기능이 아니므로 이 표에서 제외했습니다.

## 6. Division·권한별 변형

| 항목 | 사실 |
|---|---|
| 그리드 메타 컬럼 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같습니다. 필수+기본 2개 / 선택 0개입니다(COMPANY_ID, DIVISION_ID). |
| 코드 내 division 분기 | 추출되지 않았습니다(판단불가 0건). |
| 날짜 컬럼 | SCP0009 실행 결과로 정해지며 정적 집계에는 포함되지 않습니다. division에 따른 차이가 있는지는 **확인 필요**입니다. |
| Division 선택 목록 | 사용자 그룹(`NowGroupID`)과 `TB_FX_USERGROUPAUTHEXTENTION`을 기준으로 합니다. 사용자마다 목록이 다를 수 있습니다. |
| 권한 메타 | `TB_FX_GroupMenuAuth` 13행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행, `TB_FX_Favorite` 5행이 있습니다. 그룹별 C/R/U/D 플래그 값은 **확인 필요**입니다. |
| 조회조건 메타 | `TB_FX_SearchCondition` 19행이 있습니다. 내용은 **확인 필요**입니다. |

## 7. 외부 인터페이스

Fact Pack에는 외부 시스템 인터페이스가 없습니다. 저장 시 `PR_SCM_SYS_LOG_BATCH_CALL_TRAN` → `SCM_SYS_LOG_BATCH`에 기록하는 것은 내부 로그입니다. 이 로그가 외부 배치를 호출하는 계기가 되는지는 **확인 필요**입니다.

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---:|---|---|
| 1 | `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`를 535·536·537 세 지점에서 참조하는 이유와 저장 파라미터 | endpoints site_kind=prop |
| 2 | 필드 초기화(45~48: MyDivision, Company, LookupCommon, YesOrNo)와 `SetChangedPeriod`(910)의 실제 실행 경로 | unreached |
| 3 | `PERIOD_{p:value}` 코드 값, FROM_VALUE·TO_VALUE 사용처 | meta_reads 916·917 |
| 4 | 화면 로컬 `GetSpdTitle`(925)과 프레임워크 `SpreadInfo.GetSpdTitle`(InitSpread:190)의 관계 | Fact Pack 4-2와 flow의 표기 차이 |
| 5 | `CboDayWeek_SelectedIndexChanged`의 Enabled 분기 조건 | 663/666 |
| 6 | `BtnInput_Click`의 일괄 입력 대상과 반영 방식 | 682, 725~821 |
| 7 | `SpdMain_Changed`의 878~902 사이 처리, `SpdMain_TopChange`의 동작 | events |
| 8 | `SaveData_Main`의 컬럼 `A`(502·527)의 의미 | meta_reads |
| 9 | `B_` 컬럼 분기, `AddSheet` 인자(3, 1, 35)의 의미 | grid_code 179·263 |
| 10 | `M_`/`W_`/`D_` 접두어와 `LARGE`/`SMALL_CLASS` 헤더의 업무 의미(버킷 단위) | grid_code |
| 11 | Period 필수 검증 코드와 오류 메시지 | 미추출 |
| 12 | 그룹별 C/R/U/D 플래그 | `TB_FX_GroupMenuAuth` 13행 |
| 13 | 메뉴 위치 | `TB_FX_MenuItemInfo` 1행(내용 미제공) |
