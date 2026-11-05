# SCP0096 — Shipment Working Day OSP 업무분석서

> **작성 근거**: AsisFacts 정적 추출 사실 묶음(Fact Pack)과 1차 분석서(analysis.md / web_components.md / tobe_design.md)만 사용했습니다. 사실 묶음에 없는 내용은 **확인 필요**로 표기했고, 업무 규칙을 추측해서 만들지 않았습니다.
> **상호 참조**: §5 데이터 흐름의 엔드포인트 이름은 화면설계서 §5 액션 명세, 단위테스트 '근거' 열과 같은 원문을 씁니다.

---

## 1. 업무 목적·범위

### 1-1. 목적
| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 명칭 | SCP0096 / `Shipment Working Day OSP` | Designer.cs:663 `this.Text` |
| 도메인 | SCP (`06.UIL\GSCM.SCP.Forms.UIL\Master\`) — Master 폴더에 있는 화면 | 파일 경로 |
| 업무 목적(사실 기준) | Plant Site별·일자별 **출하 근무일 여부(Shipment Y/N)** 와 **Working Time Default**를 조회하고 저장하는 화면으로 보입니다. 근거: 저장 파라미터 `p_shipment_yn`, `p_working_time_default`, `p_yyyymmdd`, 그리드 메타 컬럼 `WORKING_TIME_DEFAULT`, 조회 SP의 원천 테이블 `SCP_MST_SHIPMENT_WORKING_DAY_OSP` / `SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT` | meta_reads.csv 560~581, grid_effective.csv, endpoints.csv |
| 업무 용어 'OSP'의 정의 | **확인 필요** (사실 묶음에 정의 없음. 원천 테이블 `SCM_MST_LINE_OSP`가 있다는 사실만 확인됨) | endpoints.csv |

### 1-2. 범위
| 구분 | 포함 기능 | 근거 |
|---|---|---|
| 화면 초기화 | Bucket Type 코드 조회, 그리드 생성(달력 헤더 조회) | flow.csv `Form_Load > …` |
| 조회 | 조회조건으로 출하 근무일 데이터 조회, 그리드 날짜 헤더 재생성 | flow.csv `FindButton > FindData_Main` |
| 저장 | 변경 행(ROW_ID)의 `p_*` 파라미터를 구성한 뒤 저장하고 재조회 | flow.csv `SaveButton > SaveData_Main > FindData_Main`, meta_reads.csv |
| 일괄 입력 | Day of the week / Input Value 기준으로 입력(`btnInput`) | events.csv `BtnInput_Click` |
| 합계 컬럼 표시 토글 | `chkSum`으로 M_/W_ 컬럼 표시 여부 전환 | grid_code.csv 350/355 |
| 범위 밖 | 주석 처리된 호출(Fact Pack §9의 1건)은 현행 기능이 아니므로 제외합니다 | commented_calls.csv |

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---|---|---|---|---|
| S1 | 메뉴에서 화면을 연다 | `Form_Load` → `InitControls` → `GetBucketType` 이 `DM.DM0003_GET_BUCKET_TYPE_CODE` 를 호출하고, `Form_Load` → `CreateSpread` → `InitSpread` → `GetSpdTitle` 이 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 을 호출 | 시트 `Shipment Working Day OSP` 생성(헤더 3행), META 6개 컬럼과 날짜 컬럼 헤더 구성. DM0003 결과를 바인딩하는 컨트롤은 **확인 필요** | flow.csv, grid_code.csv 142~160 |
| S2 | Division*, Plant Site, Period* 를 지정한다 | `CboDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged` 실행(본문 **확인 필요**) | 연동 동작 **확인 필요** | events.csv 251·252 |
| S3 | 조회 버튼(FindButton)을 누른다 | `FindData_Main` 이 `GetCheckedListValue`(442·443)로 체크 목록 값(CODE)을 읽고 `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` 를 호출. 경로 `FindData_Main > InitSpread > GetSpdTitle` 로 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 재호출 | 그리드에 Plant Site/Measure별 일자 데이터 표시. 결과 행이 있으면(`siMain.GetMaxRowIndex() > 0`) `SetSpreadColumn` 으로 컬럼 표시 토글 | flow.csv, grid_code.csv 484 |
| S4 | Day of the week 를 고른다 | `CboDayWeek_SelectedIndexChanged` 가 `GetCheckedListValue`(672) 실행 후 `cboInputValue.Enabled = false`(675) 또는 `true`(679) | Input Value 입력 가능 여부 전환(분기 조건 **확인 필요**) | props.csv 675·679 |
| S5 | Input Value 를 고르고 Input 버튼을 누른다 | `BtnInput_Click` 이 `GetCheckedListValue`(695·696) 실행 | 그리드에 일괄 입력하는 것으로 보이나 대상 범위와 반영 방식은 **확인 필요** | events.csv 254, meta_reads(4-2) |
| S6 | 그리드 날짜 셀(Y/N 콤보)을 수정한다 | 날짜 컬럼은 `AddComboColumn`(데이터 `dtValidYN` = `biz:CommonData.YesOrNo`) | 셀 값 변경(행 변경 상태는 `GetChanges` 저장 단계에서 사용) | grid_code.csv 203 |
| S7 | 저장 버튼(SaveButton)을 누른다 | `SaveData_Main` 이 `p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default` 행을 구성하고 `GetChanges`(ROW_ID)로 변경분 추출 → 저장 호출(**저장 SP 미검출**) → `FindData_Main` 재조회 | 저장 후 재조회 결과 표시 | meta_reads.csv 558~609, flow.csv |
| S8 | Sum 체크를 바꾼다 | `chkSum_CheckedChanged` → `SetSpreadColumn`(330/335) | `M_`/`W_` Tag 컬럼 표시 = `chkSum.Checked`. 단, `chkSum` 은 Designer에서 Visible=false(346) | grid_code.csv 330·335·350·355, props.csv 346 |
| S9 | 그리드 셀을 더블클릭하거나 스크롤한다 | `SpdMain_CellDoubleClick` / `SpdMain_TopChange` | 동작 **확인 필요** | events.csv 249·250 |

---

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 열기]
  └─ Form_Load
       ├─ InitControls → GetBucketType ─→ DM.DM0003_GET_BUCKET_TYPE_CODE (SP DM0003_GET_BUCKET_TYPE_CODE)
       └─ CreateSpread
            ├─ AddSheet("Shipment Working Day OSP", 헤더 3행)  (142)
            ├─ GetSheetInfo / ChangeSheet                      (143·144)
            └─ InitSpread
                 ├─ GetSpdTitle ─→ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN (SP SCP0009_GET_SHEET_CALENDAR_3SPAN)  (151/831)
                 ├─ SetSheetHeaderColumn (META 6컬럼, 헤더 3행)  (156)
                 ├─ InitSpreadDateColumn (날짜 컬럼 DB 루프, MEASURE 다음 열부터)  (159)
                 └─ SetSpreadColumn (Tag 접두어 표시 토글)  (160)

[조건 입력]  cboDivision / clbPlantSite / dCalendar / cboDayWeek / cboInputValue
  ├─ CboDivision_SelectedIndexChanged      (본문 확인 필요)
  ├─ ClbPlantSite_SelectedIndexChanged     (본문 확인 필요)
  └─ CboDayWeek_SelectedIndexChanged → cboInputValue.Enabled false/true

[조회]  FindButton
  └─ FindData_Main
       ├─ GetCheckedListValue(CODE) ×2  (442·443)
       ├─ SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (SP SCP0096_GET_SHIPMENT_WORKING_DAY_OSP)  (457)
       ├─ InitSpread → GetSpdTitle → SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN  (831)
       └─ if (siMain.GetMaxRowIndex() > 0) → SetSpreadColumn  (484)

[일괄 입력]  btnInput → BtnInput_Click → GetCheckedListValue ×2 (695·696) → (반영 방식 확인 필요)

[저장]  SaveButton
  └─ SaveData_Main
       ├─ p_* 파라미터 행 구성 (560~563 공통 / 570~573, 578~581 일자 블록)
       ├─ GetChanges(ROW_ID)  (609)
       ├─ (저장 SP — 미검출, 확인 필요)
       └─ FindData_Main 재조회 (위 [조회]와 동일)

[Sum 토글]  chkSum → chkSum_CheckedChanged → SetSpreadColumn
```

---

## 4. 업무 규칙 (사실 기반)

### 4-1. 필수값
| 규칙 ID | 규칙 | 근거 | 비고 |
|---|---|---|---|
| BR-01 | Division 은 필수입니다(라벨 `Division*`) | props.csv 545 | 미입력 시 검증 메시지·차단 로직은 **확인 필요** |
| BR-02 | Period 는 필수입니다(라벨 `Period*`) | props.csv 532 | 같은 내용 **확인 필요** |
| BR-03 | Plant Site, Day of the week, Input Value 는 라벨에 `*` 가 없습니다 → 필수 표시 없음 | props.csv 453·598·584 | 코드 내 필수 검증 여부 **확인 필요** |

### 4-2. 조회 SP·분기 규칙
| 규칙 ID | 규칙 | 근거 |
|---|---|---|
| BR-10 | 조회는 `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` 하나로 수행합니다. SP 안에 동적 SQL(`DYNAMIC@SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`)과 임시 피벗 테이블(`INSERT:#TBLDYNAMICPIVOT_SCP0096`)이 있습니다 | endpoints.csv |
| BR-11 | 조회 SP는 `STRING_SPLIT` 을 참조합니다 → 다중값(체크 목록) 파라미터를 구분자로 분해하는 것으로 보입니다(구분자·대상 파라미터 **확인 필요**) | endpoints.csv `REF:STRING_SPLIT`, FindData_Main:442·443 GetCheckedListValue |
| BR-12 | 조회 SP의 원천 테이블은 `SCP_MST_SHIPMENT_WORKING_DAY_OSP`, `SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT`, `SCM_MST_SITE`, `SCM_MST_LINE_OSP`, `SCM_SYS_CALENDAR_M` 입니다. 테이블 간 우선순위(OSP 값과 DEFAULT 값의 관계)는 **확인 필요** | endpoints.csv |
| BR-13 | 조회 결과 행이 있을 때만(`siMain.GetMaxRowIndex() > 0`) `SetSpreadColumn` 을 호출합니다 | grid_code.csv 484 |
| BR-14 | SP 내부의 division·Plant Site·기간 분기 조건은 사실 묶음에 없습니다 → **확인 필요** | — |

### 4-3. 날짜·버킷 규칙
| 규칙 ID | 규칙 | 근거 |
|---|---|---|
| BR-20 | 그리드 날짜 컬럼은 `SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과(원천 `SCM_SYS_CALENDAR_M`)의 행마다 하나씩 생성합니다(DB 루프) | grid_code.csv 196·203 |
| BR-21 | 컬럼명에 `"B_"` 가 들어 있고 위치가 0보다 크면(`IndexOf("B_") > 0`) 폭 0의 숨김 Text 컬럼으로 만듭니다. 그 외는 폭 50의 표시 Combo 컬럼(Y/N)으로 만듭니다 | grid_code.csv 196·203 |
| BR-22 | DAY_CODE가 `SAT`이면 글자색 파랑, `SUN`이면 빨강입니다 | grid_code.csv 208 |
| BR-23 | 헤더 3단: 0행 = LARGE_CLASS_LABEL_NAME, 1행 = SMALL_CLASS_LABEL_NAME, 2행 = COLUMN_LABEL_NAME. 그룹이 바뀌는 열에 `"SUM"` 헤더를 Span합니다 | grid_code.csv 215~244 |
| BR-24 | 날짜 컬럼은 MEASURE 컬럼 인덱스 다음 열부터 붙습니다 | grid_code.csv 159 |
| BR-25 | Tag 접두어 규칙: `D_` 또는 `W_` → Visible=true(350), `M_` 또는 `W_` → Visible=`chkSum.Checked`(355). 두 if가 순서대로 실행되므로 `W_` 의 최종값은 `chkSum.Checked` 로 보입니다(실행 확인 필요) | grid_code.csv 350·355 |
| BR-26 | `chkSum` 의 초기값은 Checked=false(121)이고 Designer에서 Visible=false(346)입니다 → 초기 상태에서는 `M_`/`W_` 컬럼이 숨겨집니다 | props.csv |
| BR-27 | Bucket Type(`DM0003_GET_BUCKET_TYPE_CODE`, 원천 `SCM_ADM_LOOKUP_MASTER_DETAIL`)을 조회하지만, 결과를 바인딩하는 컨트롤(`cboBucketType`)은 controls.csv에 없습니다. `cboBucketType_SelectedIndexChanged`(311·316)도 배선되어 있지 않습니다 → 버킷 규칙은 **확인 필요** | flow.csv, controls.csv, events.csv |
| BR-28 | D_/W_/M_ 접두어가 일(Day)/주(Week)/월(Month) 버킷을 뜻하는지는 **확인 필요**(사실 묶음에 정의 없음) | — |

### 4-4. 입력·저장 검증 규칙
| 규칙 ID | 규칙 | 근거 |
|---|---|---|
| BR-30 | `cboDayWeek` 선택에 따라 `cboInputValue.Enabled` 가 false(675)/true(679)로 바뀝니다. 분기 조건은 **확인 필요** | props.csv |
| BR-31 | 일괄 입력(`BtnInput_Click`)은 체크 목록 값 2개(695·696)를 사용합니다. 어느 컨트롤 값인지, 입력 대상 행/열 범위는 **확인 필요** | 4-2 GetCheckedListValue |
| BR-32 | 저장 파라미터: 공통 `p_division_id, p_plant_site_id, p_measure, p_user_id`(560~563), 일자별 `p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default`(570~573, 578~581). `p_is_save_defalut` 철자는 원문 그대로입니다 | meta_reads.csv |
| BR-33 | 일자별 블록 2개(570~573 / 578~581)의 분기 조건은 **확인 필요** | meta_reads.csv |
| BR-34 | 저장 대상 행은 `GetChanges`(ROW_ID)로 고른 변경분입니다 | 4-2 GetChanges SaveData_Main:609 |
| BR-35 | `dr["A"]`(558), `row["A"]`(600) 컬럼 `A` 의 의미는 **확인 필요** | meta_reads.csv |
| BR-36 | 저장 후에는 반드시 `FindData_Main` 으로 재조회합니다 | flow.csv |

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| # | 엔드포인트 | SP / 경로 | 호출 위치 | 읽기 테이블 | 쓰기 테이블 | 화면설계서 §5 액션 |
|---|---|---|---|---|---|---|
| D1 | `biz:CommonData.CommonDataList` [code=LookupCommon] | (biz) `Data.Common[case Type.LookupCommon] > Data.CallBizCommonData` → 코드분기 `UP_FX_GetCommonDataList` | `<field:dtDayWeek>` :49 (진입점 미연결) | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | 없음 | A-11 (cboDayWeek 목록 원천 후보, **확인 필요**) |
| D2 | `biz:CommonData.YesOrNo` | (biz) `Data.Common[case Type.YesOrNo] > Data.CallBizData` | `<field:dtValidYN>` :51 (진입점 미연결로 분류됐지만 grid_code 203 인자에서 `dtValidYN` 사용) | **확인 필요** | 없음 | A-02 (날짜 Combo 셀 데이터) |
| D3 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | SP `DM0003_GET_BUCKET_TYPE_CODE` | `Form_Load > InitControls > GetBucketType` :394 | SCM_ADM_LOOKUP_MASTER_DETAIL | 없음 | A-01 |
| D4 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | SP `SCP0009_GET_SHEET_CALENDAR_3SPAN` | `… > InitSpread > GetSpdTitle` :831 (Form_Load / FindButton / SaveButton 경로) | SCM_SYS_CALENDAR_M | 없음 | A-02, A-03, A-04 |
| D5 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | SP `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | `FindButton > FindData_Main` :457, `SaveButton > SaveData_Main > FindData_Main` :457 | SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, SCM_MST_SITE, SCM_MST_LINE_OSP, SCM_SYS_CALENDAR_M (+ REF STRING_SPLIT, 동적 SQL) | #TBLDYNAMICPIVOT_SCP0096 (임시 테이블 INSERT만, 영구 테이블 쓰기 없음) | A-03, A-04 |
| D6 | (저장 엔드포인트) **미검출 — 확인 필요** | 저장 SP **미검출** | `SaveButton > SaveData_Main` | — | 저장 대상 테이블 **확인 필요** (조회 원천 `SCP_MST_SHIPMENT_WORKING_DAY_OSP` 와 같은지도 확인 필요) | A-04 |

> 영구 테이블에 쓰는 엔드포인트는 사실 묶음에 하나도 없습니다. 저장 기능이 있으므로(SaveButton) 저장 SP 식별이 **최우선 확인 항목**입니다.

---

## 6. Division·권한별 변형

### 6-1. Division
| 항목 | 사실 | 근거 |
|---|---|---|
| 메타 그리드 정의 | 14개 division(40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC) 모두 6/0(필수+기본 6, 선택 0) | Fact Pack §10 |
| 최종 그리드 | 14개 division 모두 6개 컬럼 '기본' 표시, 차이 없음 | grid_effective.csv |
| 코드 분기 | division 변수를 비교하는 코드 분기 없음 | Fact Pack §12 |
| SP 내부 division 분기 | **확인 필요** (`p_division_id` 를 저장 파라미터로 전달하는 사실만 있음) | meta_reads.csv 560 |
| `cboDivision` 변경 시 연동 | `CboDivision_SelectedIndexChanged` 본문 **확인 필요** | events.csv 251 |

→ **결론**: 사실 기준으로는 division별 화면 변형이 없습니다.

### 6-2. 권한
| 항목 | 사실 | 근거 |
|---|---|---|
| 메뉴 권한 메타 | dbo.TB_FX_GroupMenuAuth 4행(행 값 미포함 → C/R/U/D 값 **확인 필요**) | Fact Pack §8 |
| 메뉴/프로그램 | TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_Favorite 1행 | Fact Pack §8 |
| 코드에서 쓰는 버튼 | FindButton(조회), SaveButton(저장). EditButton 메서드(288)가 있지만 진입점 표에는 없음 → **확인 필요** | flow.csv, grid_code.csv 288 |
| 사용자 식별 | 저장 시 `p_user_id` 전달 | meta_reads.csv 563 |

---

## 7. 외부 인터페이스

사실 묶음에 외부 시스템(I/F) 호출 근거가 없습니다. → **해당 없음(확인 필요)**

---

## 8. 미확정·확인 필요

| # | 항목 | 근거·사유 | 우선 |
|---|---|---|---|
| Q1 | 저장 SP/엔드포인트와 저장 대상 테이블 | SaveButton 경로에서 재조회만 검출됨 | 최우선 |
| Q2 | SaveData_Main 일자 블록 570~573 / 578~581 의 분기 조건, 컬럼 `A` 의 의미 | meta_reads.csv | 높음 |
| Q3 | `DM0003_GET_BUCKET_TYPE_CODE` 결과의 사용처(`cboBucketType` 미존재, 핸들러 미배선) | controls.csv / events.csv | 높음 |
| Q4 | `biz:CommonData.CommonDataList` [code=LookupCommon] 의 Lookup 그룹 키와 `cboDayWeek` 바인딩 여부 | 진입점 미연결 분류 | 중 |
| Q5 | `biz:CommonData.YesOrNo` 진입점 미연결 분류와 grid_code 203 사용 간 상충 | flow.csv vs grid_code.csv | 중 |
| Q6 | `cboInputValue` Enabled 토글 조건, `BtnInput_Click` 일괄 입력 대상 범위 | props.csv 675·679, 695·696 | 높음 |
| Q7 | `chkSum` Visible=false 상태 → M_/W_ 컬럼을 사용자가 볼 수 없는지, TO-BE 노출 정책 | props.csv 346·121 | 중 |
| Q8 | D_/W_/M_ Tag 접두어의 업무 의미, `W_` 최종 표시값 | grid_code.csv 350·355 | 중 |
| Q9 | `SpdMain_CellDoubleClick`, `SpdMain_TopChange`, `CboDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged` 본문 | Fact Pack 미포함 | 높음 |
| Q10 | `SetChangedControl`(417·425) 호출 시점, `EditButton`(288) 진입 여부 | Fact Pack 미포함 | 중 |
| Q11 | 조회 SP 내부 분기(division, 기간, STRING_SPLIT 대상 파라미터, OSP/DEFAULT 우선순위) | SP 본문 미포함 | 높음 |
| Q12 | TB_FX_GroupMenuAuth 4행 권한 값 | 행 값 미포함 | 중 |
| Q13 | 'OSP' 업무 정의, 메뉴 위치 | 미포함 | 낮음 |
| 참고 | 456행 주석 처리 호출 1건(Fact Pack §9)은 현행 기능이 아니므로 분석·구현 대상에서 제외했습니다 | commented_calls.csv | — |
