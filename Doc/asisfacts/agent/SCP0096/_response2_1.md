=== FILE: business_analysis.md ===
# SCP0096 — Shipment Working Day OSP 업무분석서

> 근거: AsisFacts 정적 추출(Fact Pack)과 1차 분석서(analysis.md · web_components.md · tobe_design.md)만 사용했습니다. 묶음에 없는 사항은 **확인 필요**로 표기했습니다.
> 주석 처리된 호출(commented_calls.csv 줄 456, 1건)은 현행 기능이 아니므로 이 문서의 흐름·규칙·데이터 흐름에서 모두 뺐습니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 명칭 | SCP0096 / `Shipment Working Day OSP` | Designer.cs:663 `this.Text` |
| 도메인 / 위치 | SCP · `06.UIL\GSCM.SCP.Forms.UIL\Master\` (Master 폴더) | files.csv |
| 클래스 | `SCP0096_Shipment_Working_Day_OSP` | files.csv |
| 대상 데이터 | Plant Site(OSP)별·일자별 출하 작업일 여부(Y/N)와 기본 작업시간(Working Time Default) | 저장 파라미터 `p_yyyymmdd`, `p_shipment_yn`, `p_working_time_default`(meta_reads.csv 570~581) · 쓰기 테이블 `SCP_MST_SHIPMENT_WORKING_DAY_OSP`, `SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT` |
| 범위 | 조회(FindButton), 저장(SaveButton), 그리드 일괄 입력(Input 버튼), 합계 컬럼 표시 토글(Sum) | flow.csv · events.csv |
| 범위 밖 | 삭제·행 추가 버튼 코드는 묶음에 없습니다(**확인 필요**) | grid_code.csv · flow.csv |

업무 목적을 설명하는 원문(주석·문서)은 묶음에 없습니다. 위 "대상 데이터"는 파라미터명과 테이블명에서 직접 읽은 사실만 적었습니다. 업무 정의는 **확인 필요**입니다.

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---|---|---|---|---|
| S1 | 화면을 엽니다 | `Form_Load` > InitControls > GetBucketType 에서 `DM.DM0003_GET_BUCKET_TYPE_CODE` 를 호출합니다. 이어 `Form_Load` > CreateSpread > InitSpread > GetSpdTitle 에서 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 을 호출합니다 | 조회조건이 초기화되고 시트 `Shipment Working Day OSP` 가 생성됩니다(메타 6컬럼, 날짜 컬럼, 3단 헤더). Bucket Type 결과를 쓰는 컨트롤은 **확인 필요** | flow.csv 1·2행 |
| S2 | Division·Plant Site·Period 를 지정하고 조회합니다 | FindButton > FindData_Main 에서 `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` 를 호출합니다. FindData_Main > InitSpread > GetSpdTitle 에서 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 을 다시 호출해 날짜 헤더를 다시 만듭니다 | 그리드에 Plant Site × Measure 행과 일자별 Y/N 값이 표시됩니다. 결과 행이 있으면(`siMain.GetMaxRowIndex() > 0`) SetSpreadColumn 으로 컬럼 표시를 다시 적용합니다 | flow.csv 3·4행 · grid_code.csv 484 |
| S3 | 날짜 셀의 Y/N 값을 콤보로 바꿉니다 | 날짜 컬럼은 `AddComboColumn`(데이터 `dtValidYN` = `biz:CommonData.YesOrNo`)입니다 | 셀 값이 변경 상태가 됩니다 | grid_code.csv 203 |
| S4 | Day of the week 를 고릅니다 | `CboDayWeek_SelectedIndexChanged` 가 `GetCheckedListValue` 를 호출(672)하고, 분기에 따라 `cboInputValue.Enabled` 를 false(675) 또는 true(679)로 바꿉니다 | Input Value 콤보가 활성 또는 비활성 상태가 됩니다. 분기 조건은 **확인 필요** | props.csv 675·679 |
| S5 | Input 버튼을 누릅니다 | `BtnInput_Click` 이 `GetCheckedListValue` 를 호출(695·696)합니다. 서버 호출은 없습니다 | 그리드에 값을 일괄 반영하는 규칙은 **확인 필요** | meta 4-2 표 |
| S6 | Sum 을 체크하거나 해제합니다 | `chkSum_CheckedChanged` > SetSpreadColumn(330/335) | 태그가 `M_`·`W_` 로 시작하는 컬럼의 Visible 이 `chkSum.Checked` 값이 됩니다. chkSum 은 Designer 에서 Visible=false 입니다(346) | grid_code.csv 330·335·355 |
| S7 | 저장합니다 | SaveButton > SaveData_Main 에서 `FPExtensions.GetChanges`(609)로 변경분을 모아 `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` 를 호출합니다. 이어 FindData_Main 으로 다시 조회합니다(`SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) | `SCP_MST_SHIPMENT_WORKING_DAY_OSP` 와 `SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT` 에 MERGE 하고 `SCM_SYS_LOG_BATCH` 에 로그를 남긴 뒤, 그리드를 다시 그립니다 | flow.csv 5·6·7행 |
| S8 | Division / Plant Site 를 바꿉니다 | `CboDivision_SelectedIndexChanged` / `ClbPlantSite_SelectedIndexChanged` | 내부 동작이 묶음에 없습니다(**확인 필요**) | events.csv 251·252 |
| S9 | 그리드 셀을 더블클릭하거나 스크롤합니다 | `SpdMain_CellDoubleClick` / `SpdMain_TopChange` | 내부 동작이 묶음에 없습니다(**확인 필요**) | events.csv 249·250 |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 진입]
  Form_Load
   ├─ InitControls ─ GetBucketType ──▶ DM.DM0003_GET_BUCKET_TYPE_CODE (SP DM0003_GET_BUCKET_TYPE_CODE)
   └─ CreateSpread ─ AddSheet("Shipment Working Day OSP", 3, 1, 35)
        └─ InitSpread ─ GetSpdTitle ──▶ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN (SP SCP0009_GET_SHEET_CALENDAR_3SPAN)
             ├─ SetSheetHeaderColumn(siMain, 3)   : 메타 6컬럼 (SCM_MST_SHEET_COLUMNS)
             ├─ InitSpreadDateColumn              : 날짜 컬럼 DB 루프 + 3단 헤더 Span
             └─ SetSpreadColumn                   : D_/W_/M_ 태그별 Visible

[조회]  FindButton ─ FindData_Main
   ├─ GetCheckedListValue(CODE) ×2 (442·443)
   ├─ ▶ SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (SP SCP0096_GET_SHIPMENT_WORKING_DAY_OSP)
   ├─ InitSpread ─ GetSpdTitle ▶ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN
   └─ if (siMain.GetMaxRowIndex() > 0) SetSpreadColumn (484)

[편집]  날짜 셀 Y/N 콤보(biz:CommonData.YesOrNo) 직접 편집
        또는 cboDayWeek / cboInputValue 선택 → btnInput(BtnInput_Click) 일괄 입력(규칙 확인 필요)

[저장]  SaveButton ─ SaveData_Main
   ├─ GetChanges (609) → 파라미터 구성 (558~581, 블록 2개)
   ├─ ▶ SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP (SP SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP)
   │      MERGE SCP_MST_SHIPMENT_WORKING_DAY_OSP / MERGE SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT
   │      EXEC PR_SCM_SYS_LOG_BATCH → INSERT SCM_SYS_LOG_BATCH
   └─ FindData_Main 재조회 (위 [조회] 흐름 반복)
```

## 4. 업무 규칙

| ID | 구분 | 규칙 | 근거 | 확정도 |
|---|---|---|---|---|
| BR-01 | 필수값 | Division 은 필수입니다(라벨 `Division*`) | props.csv 545 | 라벨 기준 확정. 미입력 시 검증 코드·메시지는 **확인 필요** |
| BR-02 | 필수값 | Period 는 필수입니다(라벨 `Period*`) | props.csv 532 | 라벨 기준 확정. 검증 코드는 **확인 필요** |
| BR-03 | 필수값 | Plant Site, Day of the week, Input Value 라벨에는 `*` 가 없습니다 | props.csv 453·598·584 | 필수 여부는 **확인 필요** |
| BR-04 | 날짜/버킷 | 날짜 컬럼 목록·헤더(대분류·소분류 라벨, DAY_CODE)는 `SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과로 정해집니다(SELECT `SCM_SYS_CALENDAR_M`) | endpoints.csv · meta 4-2 | 확정. SP 입력 파라미터는 **확인 필요** |
| BR-05 | 날짜/버킷 | 컬럼명에 `B_` 가 들어 있고 위치가 0보다 크면(`IndexOf("B_") > 0`) 폭 0·숨김 Text 컬럼으로 만들고, 그 외에는 폭 50 Y/N 콤보 컬럼으로 만듭니다 | grid_code.csv 196·203 | 확정. 위치 0 을 빼는 의도는 **확인 필요** |
| BR-06 | 표시 | DAY_CODE 가 `SAT` 이면 글자색 Blue, `SUN` 이면 Red 입니다 | grid_code.csv 208 | 확정 |
| BR-07 | 표시 | 태그가 `D_`·`W_` 로 시작하면 Visible=true(350), `M_`·`W_` 로 시작하면 Visible=`chkSum.Checked`(355) | grid_code.csv 350·355 | `W_` 가 두 조건에 모두 해당할 때의 최종값은 **확인 필요** |
| BR-08 | 표시 | chkSum 초기값 Checked=false(DefineProperty:121), Designer Visible=false(346) | props.csv | 확정. 런타임에 Visible 을 켜는 코드가 있는지는 **확인 필요** |
| BR-09 | 저장 | 변경분만 저장합니다(`FPExtensions.GetChanges`, ROW_ID 기준) | meta 4-2 SaveData_Main:609 | 확정 |
| BR-10 | 저장 | 저장 파라미터: `p_division_id`, `p_plant_site_id`, `p_measure`, `p_user_id`(560~563) + 블록 A(570~573) / 블록 B(578~581) 각각 `p_yyyymmdd`, `p_shipment_yn`, `p_is_save_defalut`, `p_working_time_default` | meta_reads.csv | 두 블록의 분기 조건과 `A` 컬럼(558·600)의 의미는 **확인 필요** |
| BR-11 | 저장 | SAVE SP 는 `SCP_MST_SHIPMENT_WORKING_DAY_OSP` 와 `SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT` 를 MERGE 합니다. DEFAULT MERGE 가 `p_is_save_defalut` 에 따라 갈리는지는 SP 원문이 묶음에 없어 **확인 필요**입니다 | endpoints.csv | 부분 확정 |
| BR-12 | 저장 | 저장 뒤 FindData_Main 으로 다시 조회합니다 | flow.csv 6행 | 확정 |
| BR-13 | 조회 | 조회 결과가 1행 이상일 때만(`siMain.GetMaxRowIndex() > 0`) SetSpreadColumn 을 다시 적용합니다 | grid_code.csv 484 | 확정 |
| BR-14 | 조회 | GET SP 는 임시 테이블 `#TBLDYNAMICPIVOT_SCP0096` 과 동적 SQL(피벗)을 쓰고 `STRING_SPLIT` 을 참조합니다 | endpoints.csv | 확정. 분기 조건은 SP 원문 **확인 필요** |
| BR-15 | 입력 | Day of the week 선택값에 따라 Input Value 활성 여부가 바뀝니다 | props.csv 675·679 | 분기 조건 **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | 호출 지점 | SP | 읽기 | 쓰기 | 화면설계서 §5 액션 |
|---|---|---|---|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | `<field:dtDayWeek>`:49 (진입점 미연결) | UP_FX_GetCommonDataList(코드 분기) | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | — | A-10 |
| `biz:CommonData.YesOrNo` | `<field:dtValidYN>`:51 → InitSpreadDateColumn:203 콤보 데이터 | — (Biz 공통) | **확인 필요** | — | A-02 / A-03 |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | Form_Load > InitControls > GetBucketType:394 | `DM0003_GET_BUCKET_TYPE_CODE` | SCM_ADM_LOOKUP_MASTER_DETAIL | — | A-01 |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | GetSpdTitle:831 (Form_Load / FindButton / SaveButton 경로) | `SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCM_SYS_CALENDAR_M | — | A-02 / A-03 / A-04 |
| `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | FindData_Main:457 (FindButton / SaveButton 경로) | `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_LINE_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT (+REF STRING_SPLIT, 동적 SQL) | #TBLDYNAMICPIVOT_SCP0096 (세션 임시) | A-03 / A-04 |
| `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` | SaveData_Main:608 (SaveButton) | `SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` (+EXEC PR_SCM_SYS_LOG_BATCH) | — | MERGE SCP_MST_SHIPMENT_WORKING_DAY_OSP, MERGE SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, INSERT SCM_SYS_LOG_BATCH | A-04 |

SP 4개: `DM0003_GET_BUCKET_TYPE_CODE`, `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP`, `SCP0009_GET_SHEET_CALENDAR_3SPAN`.

## 6. Division·권한별 변형

| 구분 | 사실 | 근거 |
|---|---|---|
| Division 메타 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 메타 `6/0`(필수+기본 6, 선택 0)입니다 | Fact Pack §10 |
| Division 최종 그리드 | 14개 division 모두 최종 표시 6컬럼입니다 | grid_effective.csv |
| Division 코드 분기 | division 비교 분기가 없습니다(판단 불가 0건) | Fact Pack §12 |
| 결론 | Division 에 따른 그리드·기능 변형은 **없습니다**. 날짜 컬럼 수는 Period 와 SCP0009 결과에 따라 런타임에 정해집니다 | — |
| 권한 | `TB_FX_GroupMenuAuth` 4행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행, `TB_FX_Favorite` 1행이 있습니다. 그룹별 C/R/U/D 값은 묶음에 없어 **확인 필요**입니다 | Fact Pack §8 |
| 사용자 식별 | 저장 시 `p_user_id` 를 전달합니다 | meta_reads.csv 563 |

## 7. 외부 인터페이스

묶음에 외부 시스템 연동(I/F) 사실이 없습니다. 로그 기록(`PR_SCM_SYS_LOG_BATCH` → `SCM_SYS_LOG_BATCH`)은 내부 테이블 쓰기입니다. 외부 인터페이스 해당 없음 여부는 **확인 필요**입니다.

## 8. 미확정·확인 필요

1. `dtDayWeek`(`biz:CommonData.CommonDataList`, LookupCommon)의 lookup 코드값과 바인딩 컨트롤(cboDayWeek 여부)
2. `cboInputValue` 데이터원과 `BtnInput_Click` 의 일괄 입력 대상·규칙
3. `CboDayWeek_SelectedIndexChanged` 에서 Enabled 를 false/true 로 나누는 조건
4. `DM.DM0003_GET_BUCKET_TYPE_CODE` 결과를 쓰는 곳. BucketType 컨트롤이 controls.csv 에 없고, `cboBucketType_SelectedIndexChanged`(311·316)는 배선되지 않음
5. `SpdMain_CellDoubleClick`, `SpdMain_TopChange`, `CboDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged` 내부 동작
6. `SetChangedControl`(417·425)의 호출자
7. SaveData_Main 파라미터 블록 A(570~573)와 B(578~581)의 분기 조건, `A` 컬럼(558·600)의 의미
8. `p_is_save_defalut` 값에 따른 DEFAULT 테이블 MERGE 여부(SAVE SP 원문 필요)
9. `W_` 태그 컬럼의 최종 Visible(350과 355 중복)
10. `B_` 판정이 `IndexOf("B_") > 0` 인 의도(위치 0 제외)
11. 필수값 미입력·조회 결과 0건·SP 오류 시 메시지 문구와 처리
12. 그룹별 메뉴 권한 4행의 C/R/U/D 값
13. 업무 목적 정의(원문 주석·문서 없음)
14. 줄 456 주석 처리 호출 1건: 현행 아님(재사용 여부는 사용자 판단)

=== FILE: screen_design.md ===
# SCP0096 — Shipment Working Day OSP 화면설계서

> 근거: Fact Pack(controls.csv · props.csv · events.csv · grid_code.csv · grid_effective.csv · flow.csv · endpoints.csv)만 사용했습니다. 묶음에 없는 사항은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SCP0096 | files.csv |
| 화면 명칭 | `Shipment Working Day OSP` | Designer.cs:663 |
| AS-IS 클래스 | `SCP0096_Shipment_Working_Day_OSP` | files.csv |
| 소스 | `.cs` 852줄 / `.Designer.cs` 724줄 / `AssemblyInfo.cs` 37줄 | files.csv |
| 메뉴 위치 | **확인 필요**. `TB_FX_MenuItemInfo` 1행이 있지만 경로 값은 묶음에 없음 | Fact Pack §8 |
| 시트 | 1개: `Shipment Working Day OSP` | grid_code.csv 142 |

## 2. 화면 레이아웃

### 2-1. 분할 트리
props.csv 에 SplitContainer(Orientation · SplitterDistance) 행이 **없습니다**. 분할은 Dock 으로만 구성됩니다. controls.csv 의 parent 체인을 그대로 옮기면 다음과 같습니다.

```
this (Form, Text="Shipment Working Day OSP")
├─ usrConditionPanel1   [UsrConditionPanel, Dock=Top, 1192×96, UsrPanelType=HidePanel]   ← 상단 14.8%
│   └─ usrLayoutControl2 [UsrLayoutControl, Dock=Fill, 1192×96]
│        (layoutControlGroup2 1192×96 — 레이아웃 그룹, parent 미기재)
│        ├─ cboDivision    ← layoutControlItem4  "Division*"        (item 236×25 / ctrl 181×20)
│        ├─ clbPlantSite   ← layoutControlItem7  "Plant Site"       (item 226×25 / ctrl 165×21)
│        ├─ dCalendar      ← layoutControlItem2  "Period*"          (item 260×25 / ctrl 210×22)
│        ├─ cboDayWeek     ← layoutControlItem3  "Day of the week"  (item 236×25 / ctrl 134×20)
│        ├─ cboInputValue  ← layoutControlItem1  "Input Value"      (item 226×25 / ctrl 124×20)
│        ├─ btnInput       ← layoutControlItem10 (Text 없음)        (item 81×25  / ctrl 77×21, Text "Input")
│        ├─ chkSum         ← layoutSum           (Text 없음)        (item 50×25  / ctrl 46×20, Text "Sum", Visible=false)
│        └─ emptySpaceItem1·2·3·4·5·6·9·10 (간격 8개)
└─ spdMain              [FpSpread, Dock=Fill, 1192×553]                                     ← 하단 85.2%
     └─ spdMain_Sheet1  [SheetView] → 시트 "Shipment Working Day OSP"

(부모 없음) usrButton1  [UsrButton, 75×23, Text 없음] — 배치 위치 확인 필요
```

- 상/하 비율: 96 : 553 (합 649) = **14.8% : 85.2%**. Designer Size 기준이며 런타임 창 크기에 따라 하단(Fill)만 늘어납니다.
- 좌/우 분할: 없습니다.
- 조회조건 행·열 좌표: LayoutControlItem 의 Location 이 추출되지 않아 **확인 필요**입니다. 항목 높이(25)와 EmptySpaceItem 높이(25·26)가 섞여 있는 것만 사실로 확인됩니다.

### 2-2. 영역 정의

| 영역 | 컨트롤 | 비고 |
|---|---|---|
| 조회조건 | cboDivision, clbPlantSite, dCalendar, cboDayWeek, cboInputValue, chkSum | usrConditionPanel1 > usrLayoutControl2 |
| 버튼 | btnInput(조회조건 영역 안), 공통 툴바 FindButton·SaveButton·EditButton(프레임워크) | 툴바 버튼의 배치·라벨은 **확인 필요** |
| 그리드 | spdMain / spdMain_Sheet1 | 시트 `Shipment Working Day OSP` |
| 팝업 | 없음 | `SpdMain_CellDoubleClick` 이 팝업을 여는지는 **확인 필요** |

### 2-3. 와이어프레임

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ [툴바: 조회 · 저장 ... (프레임워크, 확인 필요)]                                  │
├──────────────────────────────────────────────────────────────────────────────┤ ┐
│ Division* [cboDivision ▼]  Plant Site [clbPlantSite ▼]  Period* [dCalendar ~ ] │ │ usrConditionPanel1
│ Day of the week [cboDayWeek ▼]  Input Value [cboInputValue ▼]  [Input] (☐Sum) │ │ 96px · 14.8%
│   ※ 행 배치·순서는 Location 미추출로 확인 필요 · chkSum Visible=false          │ │
├──────────────────────────────────────────────────────────────────────────────┤ ┘
│ spdMain — Shipment Working Day OSP                                            │ ┐
│ ┌──────────┬────────────┬──────────┬────────┬──────────────┬────────────┬──── │ │
│ │          │            │          │        │              │            │대분류│ │ 헤더 3단
│ │ Division │Plant Site ID│Plant Site│Measure │Working Time  │Last Input  ├──────┤ │
│ │          │            │          │        │Default       │Date        │SUM│소│ │
│ │          │            │          │        │              │            │   │일│ │
│ ├──────────┼────────────┼──────────┼────────┼──────────────┼────────────┼───┼──┤ │ 553px · 85.2%
│ │ ...      │            │          │        │              │            │ Y │N │ │
│ └──────────┴────────────┴──────────┴────────┴──────────────┴────────────┴───┴──┘ │
└──────────────────────────────────────────────────────────────────────────────┘ ┘
```
메타 6컬럼의 실제 순서(SORT_ORDER_NO)는 **확인 필요**입니다. 위 순서는 grid_effective.csv 행 순서가 아니라 1차 분석서의 나열 순서입니다.

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수여부 | 연결 이벤트 | To-Be 컴포넌트(후보) |
|---|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | — (Text 없음) | Dock=Top, UsrPanelType=HidePanel | — | — | 조회조건 패널(접기 지원) |
| usrLayoutControl2 | UsrLayoutControl | `usrLayoutControl2` | Dock=Fill | — | — | 조회조건 레이아웃 그리드 |
| cboDivision | UsrCombo | `Division*` (layoutControlItem4) | 확인 필요 | 예(`*`) | SelectedIndexChanged → `CboDivision_SelectedIndexChanged` | 단일 선택 ComboBox |
| clbPlantSite | UsrCheckedList | `Plant Site` (layoutControlItem7) | 확인 필요 | 확인 필요 | SelectedIndexChanged → `ClbPlantSite_SelectedIndexChanged` | 다중 선택 MultiSelect |
| dCalendar | UsrDateRangePicker3 | `Period*` (layoutControlItem2) | 확인 필요 | 예(`*`) | — | 기간 DateRange |
| cboDayWeek | UsrCombo | `Day of the week` (layoutControlItem3) | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboDayWeek_SelectedIndexChanged` | ComboBox(데이터원 확인 필요, `biz:CommonData.CommonDataList` 후보) |
| cboInputValue | UsrCombo | `Input Value` (layoutControlItem1) | 확인 필요 | 확인 필요 | — (cboDayWeek 변경 시 Enabled 토글) | ComboBox(데이터원 확인 필요) |
| btnInput | UsrButton | `Input` (btnInput.Text) · layoutControlItem10 Text 없음 | — | — | Click → `BtnInput_Click` | Button |
| chkSum | UsrCheckBox | `Sum` (chkSum.Text) · layoutSum Text 없음 | Checked=false(DefineProperty:121), Visible=false(Designer:346) | — | CheckedChanged → `chkSum_CheckedChanged` | CheckBox(숨김 유지 여부 확인 필요) |
| usrButton1 | UsrButton | — (Text 없음, parent 없음) | Size 75×23 | — | — | 용도 확인 필요(화면에 배치되지 않은 것으로 보이나 확정 아님) |
| spdMain | FpSpread | — | Dock=Fill, 1192×553 | — | CellDoubleClick → `SpdMain_CellDoubleClick`, TopChange → `SpdMain_TopChange` | Wijmo FlexGrid |
| spdMain_Sheet1 | SheetView | 시트 `Shipment Working Day OSP` | AddSheet 인자 3·1·35 | — | — | FlexGrid 시트(단일) |

레이아웃 보조(라벨 보유 항목 외): layoutControlGroup2, emptySpaceItem1·2·3·4·5·6·9·10 — 간격 전용입니다.

## 4. 그리드 명세 — 시트 `Shipment Working Day OSP`

### 4-1. 메타 컬럼 (SCM_MST_SHEET_COLUMNS, `SetSheetHeaderColumn(siMain, 3)`)

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시(14종) | 편집 가능 |
|---|---|---|---|---|---|
| DIVISION_ID | Division | 확인 필요 | META | 전부 기본(표시) | 확인 필요 |
| PLANT_SITE_ID | Plant Site ID | 확인 필요 | META | 전부 기본(표시) | 확인 필요 |
| PLANT_SITE_NAME | Plant Site | 확인 필요 | META | 전부 기본(표시) | 확인 필요 |
| MEASURE | Measure | 확인 필요 | META | 전부 기본(표시) | 확인 필요 |
| WORKING_TIME_DEFAULT | Working Time Default | 확인 필요 | META | 전부 기본(표시) | 확인 필요(저장 파라미터 `p_working_time_default` 로 전달됨) |
| LAST_INPUT_DATE | Last Input Date | 확인 필요 | META | 전부 기본(표시) | 확인 필요 |

타입·폭·정렬·편집 속성은 메타 원문(CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, FIXED_FLAG 등)이 묶음에 없어 **확인 필요**입니다.

### 4-2. 날짜 컬럼 (DB 루프, InitSpreadDateColumn — `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과)

삽입 위치는 `spdInfo.GetColumnIndex(DefColumns.MEASURE)` 기준입니다(InitSpread:159, 산식 확인 필요).

| 조건 | 컬럼 / 헤더 | 타입 | 폭 | 표시 | 출처 | 편집 |
|---|---|---|---:|---|---|---|
| COLUMN_NAME `IndexOf("B_") > 0` | COLUMN_NAME / COLUMN_LABEL_NAME | Text(AddTextColumn) | 0 | 숨김 | HARDCODED 로직 + DB값 | 확인 필요 |
| 그 외 | COLUMN_NAME / COLUMN_LABEL_NAME | Combo(AddComboColumn, 데이터 `dtValidYN` = `biz:CommonData.YesOrNo`), 가로·세로 Center | 50 | 표시 | HARDCODED 로직 + DB값 | 콤보 편집(잠금 여부 확인 필요) |
| DAY_CODE = SAT | — | — | — | — | HARDCODED | 글자색 Blue |
| DAY_CODE = SUN | — | — | — | — | HARDCODED | 글자색 Red |

### 4-3. 헤더 3단 Span

| 행 | 내용 | 높이 | 근거 |
|---|---|---:|---|
| 0 | LARGE_CLASS_LABEL_NAME (대분류 구간 Span) | 20 | grid_code.csv 215·243 |
| 1 | SMALL_CLASS_LABEL_NAME (소분류 구간 Span) | 20 | 221·230·241 |
| 1~2 | 대분류 시작 열 `"SUM"` (2행 Span) | 20 | 216·244 |
| 2 | 소분류 시작 열 `"SUM"` | 30 / 20 | 222 / 231·242 |

헤더 스타일: HorizontalAlignment General, VerticalAlignment General, NoteIndicatorColor Red, Parent `ColumnHeaderDefaultEnhanced`(Designer 628~631).

### 4-4. 컬럼 표시 토글 (SetSpreadColumn)

| 태그 접두어 | Visible | 근거 |
|---|---|---|
| `D_`, `W_` | true | 350 |
| `M_`, `W_` | `chkSum.Checked` | 355 |

`W_` 는 두 조건에 모두 들어 있어 최종값이 **확인 필요**입니다. 호출 지점: InitSpread:160, chkSum_CheckedChanged:330/335, FindData_Main:484(결과 행 > 0), cboBucketType_SelectedIndexChanged:311/316(미배선).

### 4-5. Division별 표시
14개 division 모두 메타 6컬럼으로 같습니다. 코드에 division 분기가 없습니다.

## 5. 액션 명세

| ID | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A-01 | 화면 Load | `Form_Load` | InitControls > GetBucketType | `DM.DM0003_GET_BUCKET_TYPE_CODE` | 반영 컨트롤 확인 필요 |
| A-02 | 화면 Load | `Form_Load` | CreateSpread > InitSpread > GetSpdTitle → 메타 컬럼 + 날짜 컬럼 + 헤더 Span + SetSpreadColumn | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `biz:CommonData.YesOrNo`(콤보 데이터) | 시트 `Shipment Working Day OSP` 구성 |
| A-03 | 조회(툴바) | FindButton > FindData_Main | GetCheckedListValue(442·443) → GET 호출 → InitSpread 재구성 → 결과 행 > 0 이면 SetSpreadColumn | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 데이터 표시 |
| A-04 | 저장(툴바) | SaveButton > SaveData_Main | GetChanges(609) → 파라미터 구성(558~581) → SAVE 호출 → FindData_Main 재조회 | `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` → `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` → `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 저장 후 그리드 재표시 |
| A-05 | spdMain 셀 더블클릭 | `SpdMain_CellDoubleClick` | 확인 필요 | 묶음상 없음 | 확인 필요 |
| A-06 | spdMain 스크롤 | `SpdMain_TopChange` | 확인 필요 | 묶음상 없음 | 확인 필요 |
| A-07 | cboDivision 변경 | `CboDivision_SelectedIndexChanged` | 확인 필요 | 묶음상 없음 | 확인 필요 |
| A-08 | clbPlantSite 변경 | `ClbPlantSite_SelectedIndexChanged` | 확인 필요 | 묶음상 없음 | 확인 필요 |
| A-09 | cboDayWeek 변경 | `CboDayWeek_SelectedIndexChanged` | GetCheckedListValue(672) → 분기 | 없음 | cboInputValue.Enabled = false(675) / true(679) |
| A-10 | cboDayWeek 데이터 | (진입점 미연결 `<field:dtDayWeek>`) | 공통코드 LookupCommon | `biz:CommonData.CommonDataList` | 바인딩 컨트롤 확인 필요 |
| A-11 | btnInput 클릭 | `BtnInput_Click` | GetCheckedListValue(695·696) → 그리드 반영(규칙 확인 필요) | 없음(클라이언트) | 확인 필요 |
| A-12 | chkSum 체크 변경 | `chkSum_CheckedChanged` | SetSpreadColumn(330/335) | 없음 | `M_`·`W_` 컬럼 Visible = chkSum.Checked |

## 6. 검증·메시지

| 항목 | 사실 | 상태 |
|---|---|---|
| Division 필수 | 라벨 `Division*` | 검증 코드·메시지 확인 필요 |
| Period 필수 | 라벨 `Period*` | 검증 코드·메시지 확인 필요 |
| 저장 대상 없음 | GetChanges 사용 | 변경분 0건일 때 메시지 확인 필요 |
| 조회 0건 | SetSpreadColumn 은 결과 행 > 0 일 때만 호출(484) | 메시지 확인 필요 |
| SP 오류 | — | 처리·메시지 확인 필요 |

메시지 문구 원문은 묶음에 없습니다.

## 7. 권한 (C/R/U/D)

| 항목 | 사실 |
|---|---|
| 메타 행 | TB_FX_GroupMenuAuth 4행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_Favorite 1행 |
| 그룹별 C/R/U/D | **확인 필요**(값 미추출) |
| 코드상 액션 | R: FindButton · U: SaveButton · EditButton(288, GetSheetInfo) · C/D 전용 버튼 코드 없음 |

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 영역 | AS-IS | To-Be 관점 |
|---|---|---|
| 그리드 | FarPoint FpSpread, 헤더 3단 ColumnHeaderSpan | Wijmo FlexGrid `columnHeaders` 3행 + 병합(allowMerging), 대분류·소분류·SUM Span 재현 |
| 날짜 컬럼 | DB 루프 AddComboColumn(폭 50, Y/N, Center) / `B_` 숨김 | 조회 응답(SCP0009 결과)으로 컬럼 정의를 동적 생성, `dataMap` 으로 Y/N 콤보, `B_` 는 visible=false |
| 주말 색상 | ForeColor Blue(SAT)/Red(SUN) | 셀 포맷터/클래스로 처리(inline style 금지 규약) |
| 표시 토글 | Columns[].Visible 태그 접두어 판정 | 컬럼 binding 접두어 기준 visible 토글. `W_` 중복 판정은 AS-IS 확인 후 확정 |
| 변경분 저장 | FPExtensions.GetChanges(ROW_ID) | FlexGrid CollectionView `itemsEdited` 기준 변경분 전송 |
| 피벗 조회 SP | MSSQL `#TBLDYNAMICPIVOT_SCP0096` + 동적 SQL + `STRING_SPLIT` | Oracle: 임시 테이블 → GTT, `STRING_SPLIT` → Oracle 분할 방식, 동적 피벗 재구성(MSSQL 키워드 잔존 금지) |
| 저장 SP | MERGE 2개 + PR_SCM_SYS_LOG_BATCH | Oracle MERGE 로 변환, 로그 프로시저 동일 호출 |
| 공통코드 | `biz:CommonData.CommonDataList`(LookupCommon), `biz:CommonData.YesOrNo` | 공통 코드 API로 대체 |
| chkSum | Designer Visible=false | To-Be 노출 여부는 AS-IS 런타임 확인 후 결정 |
| usrButton1 | 부모 없음 | 배치되지 않았는지 확인 후 이관 대상에서 뺄지 결정 |

## 9. 미확정

1. 조회조건 행·열 배치 순서(Location 미추출)
2. 툴바 버튼(FindButton·SaveButton·EditButton) 표시 구성
3. 메타 6컬럼 정렬 순서·폭·타입·편집 가능 여부
4. cboDayWeek / cboInputValue 데이터원, BtnInput_Click 일괄 입력 규칙, CboDayWeek 분기 조건
5. SpdMain_CellDoubleClick, SpdMain_TopChange, CboDivision_SelectedIndexChanged, ClbPlantSite_SelectedIndexChanged 내부 동작
6. `W_` 컬럼 최종 Visible, `B_` 판정의 위치 0 제외 의도
7. `DM.DM0003_GET_BUCKET_TYPE_CODE` 결과 사용처, `cboBucketType_SelectedIndexChanged`·`SetChangedControl` 호출 경로
8. usrButton1 용도
9. 검증 메시지 문구, 권한 C/R/U/D 값, 메뉴 위치

=== FILE: unit_test.md ===
# SCP0096 — Shipment Working Day OSP 단위테스트

> 근거 열은 업무분석서 §5 / 화면설계서 §5 와 같은 엔드포인트·SP·핸들러·시트 이름을 씁니다. 절차 열은 화면설계서 §3 의 컨트롤명을 그대로 씁니다.
> 기대결과에 "확인 필요"가 있는 케이스는 AS-IS 실행 결과를 기대값으로 기록한 뒤 To-Be 와 대조합니다(정적 추출로 동작을 확정할 수 없음).
> 주석 처리된 호출은 테스트 대상이 아닙니다.

## 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0096-001 | 초기화 | 메뉴 권한 보유 사용자 로그인 | 1. SCP0096 화면을 연다 | — | `DM.DM0003_GET_BUCKET_TYPE_CODE` 가 1회 호출되고 오류 없이 로드된다. 결과 반영 컨트롤은 확인 필요 | `Form_Load` · `DM.DM0003_GET_BUCKET_TYPE_CODE` · SP `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SCP0096-002 | 초기화 | 동일 | 1. 화면을 연다 2. spdMain 의 시트를 확인한다 | — | 시트 `Shipment Working Day OSP` 1개가 생성되고 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 이 호출되어 3단 헤더가 그려진다 | `Form_Load` · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` · SP `SCP0009_GET_SHEET_CALENDAR_3SPAN` · 시트 `Shipment Working Day OSP` |
| TC-SCP0096-003 | 초기화 | 동일 | 1. 화면을 연다 2. chkSum 상태를 확인한다 | — | chkSum Checked=false, Visible=false(Designer:346). usrConditionPanel1 은 상단(Dock Top), spdMain 은 나머지 영역(Fill) | `Form_Load` · props.csv DefineProperty:121 |
| TC-SCP0096-004 | 조회 | 저장 데이터가 있는 Division/Plant Site | 1. cboDivision 선택 2. clbPlantSite 다중 선택 3. dCalendar 기간 입력 4. 조회(FindButton) | Division, Plant Site 2건, Period 1개월 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` 호출 후 spdMain 에 행이 표시되고, 결과 행이 있으면 SetSpreadColumn 이 다시 적용된다(484) | FindData_Main · `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` · SP `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-005 | 조회 | 동일 | 1. TC-004 조회 후 dCalendar 기간을 바꿔 다시 조회 | 기간 변경 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 이 다시 호출되어 날짜 컬럼 수·헤더가 새 기간에 맞게 바뀐다 | FindData_Main > InitSpread > GetSpdTitle · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-006 | 조회 | 데이터가 없는 조건 | 1. cboDivision·clbPlantSite·dCalendar 를 데이터 없는 조건으로 지정 2. 조회 | 데이터 없는 Plant Site/기간 | 빈 결과: spdMain 0행, 오류 없음. SetSpreadColumn 재호출 안 됨(484 조건). 안내 메시지는 확인 필요 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` · grid_code.csv 484 |
| TC-SCP0096-007 | 조회 | SP 오류 유발 환경(예: SP 미배포 또는 잘못된 파라미터) | 1. 조회 실행 | 오류 유발 조건 | 오류 응답: 화면이 비정상 종료되지 않는다. 오류 메시지 문구·그리드 유지 여부는 확인 필요 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` · SP `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-008 | 조회 | 화면 로드 | 1. cboDivision 을 비운다(가능한 경우) 2. 조회 | Division 빈값 | `Division*` 필수: 조회가 막히는지와 메시지는 확인 필요 | 업무분석서 BR-01 · `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-009 | 조회 | 화면 로드 | 1. dCalendar 를 비운다(가능한 경우) 2. 조회 | Period 빈값 | `Period*` 필수: 조회가 막히는지와 메시지는 확인 필요 | 업무분석서 BR-02 · `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-010 | 그리드 | TC-004 조회 완료 | 1. spdMain 메타 컬럼 헤더를 확인한다 | — | 시트 `Shipment Working Day OSP` 에 Division, Plant Site ID, Plant Site, Measure, Working Time Default, Last Input Date 6컬럼이 표시된다(순서는 메타 원문 확인 필요) | 시트 `Shipment Working Day OSP` · grid_effective.csv |
| TC-SCP0096-011 | 그리드 | TC-004 조회 완료 | 1. 날짜 컬럼을 확인한다 2. 날짜 셀 콤보를 연다 | — | `B_` 포함(위치 > 0) 컬럼은 숨김(폭 0). 그 외는 폭 50, 가운데 정렬 Y/N 콤보이며 콤보 항목은 `biz:CommonData.YesOrNo` 결과 | `biz:CommonData.YesOrNo` · InitSpreadDateColumn 196·203 · 시트 `Shipment Working Day OSP` |
| TC-SCP0096-012 | 그리드 | 토·일요일이 포함된 기간 조회 | 1. 주말 날짜 컬럼을 확인한다 | 주말 포함 기간 | DAY_CODE SAT 컬럼 글자색 Blue, SUN 컬럼 Red | InitSpreadDateColumn 208 · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-013 | 그리드 | TC-004 조회 완료 | 1. 헤더 3단을 확인한다 | — | 0행 대분류 라벨 Span, 1행 소분류 라벨 Span, 각 구간 시작 열에 `SUM` 헤더 | InitSpreadDateColumn 215~244 · 시트 `Shipment Working Day OSP` |
| TC-SCP0096-014 | 저장 | TC-004 조회 완료 | 1. spdMain 날짜 셀 Y→N 변경 2. 저장(SaveButton) | 셀 1개 변경 | `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` 호출 → SCP_MST_SHIPMENT_WORKING_DAY_OSP MERGE, SCM_SYS_LOG_BATCH 기록 → `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` 재조회로 변경값 유지 표시 | SaveData_Main · `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` · SP `SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-015 | 저장 | TC-004 조회 완료 | 1. Working Time Default 셀 변경(편집 가능한 경우) 2. 저장 | 값 변경 | SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT MERGE 여부를 확인한다(`p_is_save_defalut` 조건 확인 필요) | `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` · meta_reads.csv 572·580 |
| TC-SCP0096-016 | 저장 | TC-004 조회 완료, 변경 없음 | 1. 저장 | 변경 0건 | GetChanges 결과 0건일 때 SP 호출 여부·메시지 확인 필요 | SaveData_Main:609 · `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-017 | 저장 | SP 오류 유발 환경 | 1. 셀 변경 후 저장 | 오류 유발 조건 | 오류 응답: 테이블 변경 없음(롤백). 오류 메시지·재조회 여부 확인 필요 | `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-018 | 저장 | TC-014 저장 완료 | 1. 저장 뒤 헤더 확인 | — | 재조회 경로에서 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 이 다시 호출되어 헤더가 같게 유지된다 | SaveButton > SaveData_Main > FindData_Main > InitSpread > GetSpdTitle · `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-019 | 이벤트 | TC-004 조회 완료 | 1. spdMain 셀을 더블클릭 | 데이터 셀 | 동작 확인 필요(AS-IS 결과 기록 후 대조) | `SpdMain_CellDoubleClick` |
| TC-SCP0096-020 | 이벤트 | 화면 높이를 넘는 행 조회 | 1. spdMain 을 세로 스크롤 | — | 동작 확인 필요(AS-IS 결과 기록 후 대조) | `SpdMain_TopChange` |
| TC-SCP0096-021 | 이벤트 | 화면 로드 | 1. cboDivision 값을 바꾼다 | 다른 Division | 동작 확인 필요(clbPlantSite 목록 갱신 여부 등 AS-IS 결과 기록) | `CboDivision_SelectedIndexChanged` |
| TC-SCP0096-022 | 이벤트 | 화면 로드 | 1. clbPlantSite 선택을 바꾼다 | Plant Site 선택 변경 | 동작 확인 필요(AS-IS 결과 기록 후 대조) | `ClbPlantSite_SelectedIndexChanged` |
| TC-SCP0096-023 | 이벤트 | 화면 로드 | 1. cboDayWeek 값을 바꾼다(각 선택지) | Day of the week 각 값 | 선택값에 따라 cboInputValue.Enabled 가 false 또는 true 가 된다. 값별 분기는 확인 필요 | `CboDayWeek_SelectedIndexChanged` · props.csv 675·679 |
| TC-SCP0096-024 | 이벤트 | 화면 로드 | 1. cboDayWeek 콤보 항목을 연다 | — | 콤보 항목이 `biz:CommonData.CommonDataList`(LookupCommon) 결과와 같은지 확인한다(바인딩 확인 필요) | `biz:CommonData.CommonDataList` · `<field:dtDayWeek>`:49 |
| TC-SCP0096-025 | 이벤트 | TC-004 조회 완료 | 1. cboDayWeek 선택 2. cboInputValue 선택 3. btnInput 클릭 | Day of the week, Input Value | 서버 호출 없이 그리드에 값이 반영된다. 반영 대상·규칙은 확인 필요 | `BtnInput_Click` |
| TC-SCP0096-026 | 이벤트 | TC-004 조회 완료, chkSum 조작 가능 상태(Visible=false 이므로 조작 경로 확인 필요) | 1. chkSum 체크 2. chkSum 해제 | Checked true/false | `M_`·`W_` 태그 컬럼이 체크 시 표시, 해제 시 숨김. `W_` 최종값은 확인 필요 | `chkSum_CheckedChanged` · SetSpreadColumn 350·355 |
| TC-SCP0096-027 | division | Division 40, 81, 82, EE 사용자 각각 | 1. 각 Division 으로 조회 | Division 40 / 81 / 82 / EE | 4개 모두 시트 `Shipment Working Day OSP` 메타 6컬럼이 같다(division 변형 없음) | 시트 `Shipment Working Day OSP` · grid_effective.csv · `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-028 | 권한 | TB_FX_GroupMenuAuth 4개 그룹 사용자 | 1. 그룹별로 화면을 연다 2. 조회·저장 실행 | 그룹별 계정 | 그룹별 C/R/U/D 에 따라 조회·저장 가능 여부가 갈린다. 값은 확인 필요 | TB_FX_GroupMenuAuth · `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` |

## 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 핸들러 | `Form_Load` | 001·002·003 |
| 핸들러 | `SpdMain_CellDoubleClick` | 019 |
| 핸들러 | `SpdMain_TopChange` | 020 |
| 핸들러 | `CboDivision_SelectedIndexChanged` | 021 |
| 핸들러 | `ClbPlantSite_SelectedIndexChanged` | 022 |
| 핸들러 | `CboDayWeek_SelectedIndexChanged` | 023 |
| 핸들러 | `BtnInput_Click` | 025 |
| 핸들러 | `chkSum_CheckedChanged` | 026 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 024 |
| 엔드포인트 | `biz:CommonData.YesOrNo` | 011 |
| 엔드포인트 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | 001 |
| 엔드포인트 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | 004·006·007·008·009·027 |
| 엔드포인트 | `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` | 014·015·016·017·028 |
| 엔드포인트 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 002·005·012·018 |
| 시트 | `Shipment Working Day OSP` | 002·010·011·013·027 |
| 빈 결과 / 오류 응답 | — | 006 / 007·017 |
| division | 변형 없음 확인 | 027 |
