# SCP0096 — Shipment Working Day OSP 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack과 1차 분석서(analysis / web_components / tobe_design)입니다. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.
> 연계 문서: 화면설계서(screen_design.md) §5 액션 명세, 단위테스트(unit_test.md) 근거 열과 엔드포인트 이름을 똑같이 씁니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID | SCP0096 | 클래스 `SCP0096_Shipment_Working_Day_OSP` |
| 화면명 | Shipment Working Day OSP | Designer.cs:663 `this.Text` |
| 도메인 / 분류 | SCP / Master | 경로 `06.UIL\GSCM.SCP.Forms.UIL\Master\...` |
| 목적 | Division과 Plant Site별로 기간(Period) 안의 일자 단위 Shipment Working Day(출하 가능 여부 Y/N) 값을 조회하고 저장합니다 | SP 이름 `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, 날짜 컬럼이 YesOrNo 콤보(:203), 저장 파라미터 `p_yyyymmdd`·`p_shipment_yn`(:570~:571) |
| 범위 | 조회(FindButton), 저장(SaveButton), 그리드 일괄 입력(btnInput), Sum 컬럼 표시 토글(chkSum) | flow.csv, events.csv |
| 범위 밖 | 저장 SP는 Fact Pack에서 추출되지 않았습니다 → **확인 필요** | §8 |

> 업무 목적 문장은 SP 이름, 컬럼 구성, 저장 파라미터 이름에서 읽은 것입니다. 업무 담당자의 공식 정의는 **확인 필요**입니다.

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---|---|---|---|
| S1 | 화면을 엽니다 | `Form_Load` → InitControls → GetBucketType에서 `DM.DM0003_GET_BUCKET_TYPE_CODE` 호출. 이어서 CreateSpread → InitSpread → GetSpdTitle에서 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 호출 | 시트 `Shipment Working Day OSP`가 만들어집니다. 메타 고정 컬럼 6개와 SCP0009 결과로 만든 달력 날짜 컬럼, 헤더 3행이 구성됩니다 |
| S2 | Division*, Plant Site, Period*를 넣고 조회합니다 | FindButton → FindData_Main(:457)에서 `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` 호출. clbPlantSite 값은 GetCheckedListValue(:442/:443)로 추출합니다. InitSpread → GetSpdTitle에서 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`을 다시 호출합니다 | 그리드에 조회 결과가 표시됩니다. `siMain.GetMaxRowIndex() > 0`(:484)이면 SetSpreadColumn으로 컬럼 표시를 다시 적용합니다 |
| S3 | Day of the week(cboDayWeek)를 선택합니다 | `CboDayWeek_SelectedIndexChanged` → GetCheckedListValue(:672) → cboInputValue.Enabled = false(:675) 또는 true(:679) | Input Value 콤보가 활성 또는 비활성으로 바뀝니다. 분기 조건은 **확인 필요**입니다 |
| S4 | Input Value를 고르고 Input 버튼을 누릅니다 | `BtnInput_Click` → GetCheckedListValue(:695, :696) | 그리드에 일괄 입력하는 것으로 보입니다. 상세 로직은 **확인 필요**입니다 |
| S5 | Sum 체크박스를 토글합니다 | `chkSum_CheckedChanged` → SetSpreadColumn(:330/:335) | 태그가 `M_`·`W_`로 시작하는 컬럼의 Visible이 chkSum.Checked로 바뀝니다(:355) |
| S6 | 그리드 셀을 수정하고 저장합니다 | SaveButton → SaveData_Main → GetChanges(:609)로 변경행을 모아 파라미터 행을 만들고, FindData_Main으로 재조회합니다(`SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) | 저장한 뒤 재조회 결과가 표시됩니다. 저장 호출 대상은 **확인 필요**입니다 |
| S7 | Division이나 Plant Site를 바꿉니다 | `CboDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged` | 내부 동작은 **확인 필요**입니다 |
| S8 | 그리드를 더블클릭하거나 스크롤합니다 | `SpdMain_CellDoubleClick`, `SpdMain_TopChange` | 내부 동작은 **확인 필요**입니다 |

## 3. 업무 흐름도 (텍스트)

```
[화면 열기]
  └─ Form_Load
       ├─ InitControls → GetBucketType ─────────────▶ DM.DM0003_GET_BUCKET_TYPE_CODE
       └─ CreateSpread (AddSheet "Shipment Working Day OSP")
            └─ InitSpread
                 ├─ GetSpdTitle ────────────────────▶ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN
                 ├─ SetSheetHeaderColumn(siMain, 3)  (메타 6컬럼, 헤더 3행)
                 ├─ InitSpreadDateColumn            (MEASURE 다음부터 날짜 컬럼)
                 └─ SetSpreadColumn                 (D_/W_/M_ 표시 규칙)
[조건 입력] Division* / Plant Site / Period* / (Sum)
[조회] FindButton
  └─ FindData_Main ─────────────────────────────────▶ SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP
       └─ InitSpread → GetSpdTitle ─────────────────▶ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN
       └─ if GetMaxRowIndex() > 0 → SetSpreadColumn
[편집 보조] cboDayWeek 선택 → cboInputValue Enabled 전환 → btnInput(Input) → 그리드 일괄 입력(상세 확인 필요)
[저장] SaveButton
  └─ SaveData_Main: GetChanges → 파라미터 행 구성 → (저장 호출: 확인 필요)
       └─ FindData_Main 재조회 (위 [조회]와 같음)
```

## 4. 업무 규칙 (사실 기반)

| # | 규칙 | 내용 | 근거 |
|---|---|---|---|
| R1 | 필수 조회조건 | 라벨에 `*`가 붙은 Division*, Period*는 필수로 표시됩니다. 실제 검증 코드와 메시지는 **확인 필요**입니다 | props layoutControlItem4/2 Text |
| R2 | Plant Site 다중 선택 | clbPlantSite(UsrCheckedList) 값은 GetCheckedListValue로 CODE를 추출합니다 | FindData_Main:442/443 |
| R3 | 날짜 컬럼 생성 | SCP0009 결과(dsSpdTitle) 행마다 MEASURE 다음 위치(`GetColumnIndex(MEASURE)+1`)부터 컬럼을 만듭니다 | InitSpread:159 |
| R4 | `B_` 컬럼 | COLUMN_NAME에 `B_`가 들어 있으면(IndexOf > 0) 텍스트 컬럼을 만듭니다. 너비 0, Visible=false입니다 | InitSpreadDateColumn:196 |
| R5 | 일자 값 컬럼 | R4가 아닌 컬럼은 YesOrNo 콤보(`dtValidYN`)로 만듭니다. 너비 50, 표시, 가운데 정렬입니다 | :203 |
| R6 | 주말 표시 | DAY_CODE가 `SAT`이면 파랑, `SUN`이면 빨강 글자색입니다 | :208 |
| R7 | 헤더 3행 | 0행 = LARGE_CLASS_LABEL_NAME 병합, 1행 = SMALL_CLASS_LABEL_NAME 병합, "SUM" 헤더(1~2행 span 또는 2행)입니다 | :215~:244 |
| R8 | 컬럼 표시 규칙 | 태그가 `D_`·`W_`로 시작하면 Visible=true(:350), `M_`·`W_`로 시작하면 Visible=chkSum.Checked(:355)입니다. `W_`의 최종 결과(if/else-if 구조)는 **확인 필요**입니다 | SetSpreadColumn |
| R9 | Sum 기본값 | chkSum.Checked=false(DefineProperty:121)입니다. Designer에서는 Visible=false(:346)입니다 | props |
| R10 | 조회 후 표시 재적용 | `siMain.GetMaxRowIndex() > 0`일 때만 SetSpreadColumn을 호출합니다 | FindData_Main:484 |
| R11 | Input Value 활성 | cboDayWeek 선택 결과에 따라 cboInputValue.Enabled가 false(:675) 또는 true(:679)가 됩니다. 조건은 **확인 필요**입니다 | CboDayWeek_SelectedIndexChanged |
| R12 | 저장 대상 행 | 변경행만 대상입니다(GetChanges, ROW_ID 기준) | SaveData_Main:609 |
| R13 | 저장 파라미터 | p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut(원문 철자), p_working_time_default. 블록이 :570~:573과 :578~:581 두 곳으로 나뉩니다(분기 조건 **확인 필요**) | meta_reads |
| R14 | 저장 후 재조회 | 저장한 뒤 FindData_Main을 호출합니다 | flow.csv |
| R15 | 버킷 규칙 | DM0003(Bucket Type 코드)은 Form_Load에서 호출합니다. 결과를 바인딩하는 컨트롤은 **확인 필요**입니다(cboBucketType은 컨트롤 목록에 없음) | GetBucketType:394 |

## 5. 데이터 흐름 표

| 엔드포인트 | SP | 호출 위치 | 읽기 테이블 | 쓰기 테이블 |
|---|---|---|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | — (코드 분기 UP_FX_GetCommonDataList) | `<field:dtDayWeek>`:49 (진입점 미연결) | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | 없음 |
| `biz:CommonData.YesOrNo` | — | `<field:dtValidYN>`:51. InitSpreadDateColumn:203 콤보 데이터로 사용 | 확인 필요 (Data.CallBizData) | 없음 |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | `DM0003_GET_BUCKET_TYPE_CODE` | GetBucketType:394 (Form_Load) | SCM_ADM_LOOKUP_MASTER_DETAIL | 없음 |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | `SCP0009_GET_SHEET_CALENDAR_3SPAN` | GetSpdTitle:831 (Form_Load / FindButton / SaveButton) | SCM_SYS_CALENDAR_M | 없음 |
| `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | FindData_Main:457 (FindButton / SaveButton 재조회) | SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_LINE_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT (REF STRING_SPLIT, DYNAMIC SQL) | #TBLDYNAMICPIVOT_SCP0096 (임시 테이블 INSERT) |
| (저장) | 확인 필요 | SaveData_Main | 확인 필요 | 확인 필요 |

## 6. Division·권한별 변형

- **Division**: 메타 기준 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 모두 6/0(필수+기본 6, 선택 0)입니다. 최종 Grid도 모두 6컬럼입니다. 코드에는 division 변수를 비교하는 분기가 없습니다. 따라서 **division별 변형은 없습니다.**
- 날짜 동적 컬럼 수는 Period(SCP0009 결과)에 따라 달라지고, division과는 관계가 없습니다.
- **권한**: TB_FX_GroupMenuAuth 4행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_Favorite 1행이 있습니다. 그룹별 C/R/U/D 값은 **확인 필요**입니다(`dbmeta_dbo_TB_FX_GroupMenuAuth.csv`). 코드에서 확인된 버튼 경로는 FindButton, SaveButton, EditButton(:288)입니다.

## 7. 외부 인터페이스

Fact Pack에는 외부 시스템 인터페이스가 없습니다(해당 없음).

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---|---|---|
| 1 | 저장 SP/엔드포인트와 파라미터 계약 | SaveData_Main, meta_reads :558~:600 |
| 2 | `dr["A"]`/`row["A"]` 컬럼 A의 의미 | :558, :600 |
| 3 | `p_is_save_defalut`(원문 철자)와 Default 저장 분기, 파라미터 2블록(:570~:573 / :578~:581)의 분기 조건 | meta_reads |
| 4 | DM0003 결과를 바인딩하는 컨트롤과 `cboBucketType_SelectedIndexChanged`(:311/:316, 배선 없음)를 쓰는지 여부 | grid_code |
| 5 | dtDayWeek(LookupCommon) 코드값과 cboDayWeek에 바인딩되는지 여부 | :49 |
| 6 | cboDivision / clbPlantSite / cboInputValue 데이터 원천 | 미추출 |
| 7 | SpdMain_CellDoubleClick / SpdMain_TopChange / CboDivision_SelectedIndexChanged / ClbPlantSite_SelectedIndexChanged 로직 | 미추출 |
| 8 | BtnInput_Click 일괄 입력 상세, CboDayWeek 분기 조건 | :672~:696 |
| 9 | 필수값(Division*, Period*) 검증 코드와 메시지 | 미추출 |
| 10 | SetSpreadColumn의 W_ 이중 조건 구조 | :350, :355 |
| 11 | chkSum을 런타임에 다시 표시하는지 여부 | Designer :346 |
| 12 | SP 결과 컬럼 접두어(D_/W_/M_/B_) 체계와 동적 PIVOT 매핑 | SP DYNAMIC |
| 13 | 그룹별 권한 값 | TB_FX_GroupMenuAuth |
| 14 | 456행 주석 처리 호출(SCP.SCP0019_GET_WORKING_TIME)은 현행 기능이 아니므로 분석 대상에서 뺐습니다 | commented_calls.csv |
