=== FILE: business_analysis.md ===
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

=== FILE: screen_design.md ===
# SCP0096 — Shipment Working Day OSP 화면설계서

> **작성 근거**: AsisFacts Fact Pack(controls.csv / props.csv / events.csv / grid_effective.csv / grid_code.csv)과 1차 분석서. 사실에 없는 값은 **확인 필요**로 표기했습니다.
> **상호 참조**: §5 액션 명세의 엔드포인트 = 업무분석서 §5 데이터 흐름. §3 컨트롤명 = 단위테스트 '절차' 열.

---

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SCP0096 | — |
| 화면 명칭 | `Shipment Working Day OSP` | Designer.cs:663 |
| 클래스 | `SCP0096_Shipment_Working_Day_OSP` | controls.csv |
| 도메인 / 분류 | SCP / Master | 경로 |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행 존재, 값 미포함) | Fact Pack §8 |
| 시트 | `Shipment Working Day OSP` (1개) | grid_code.csv 142 |
| 화면 유형 | 조회조건 + 단일 그리드 (팝업 없음) | controls.csv |

---

## 2. 화면 레이아웃

### 2-1. 분할 구조 (SplitContainer)
- props.csv와 controls.csv에 **SplitContainer가 없습니다**. 그래서 SplitContainer 기준(Orientation·SplitterDistance)으로 분할 트리를 그릴 수 없고, **Dock + Size + parent 체인**으로 대신 그렸습니다.
- 상/하 비율: `usrConditionPanel1`(Dock Top, 높이 96) : `spdMain`(Dock Fill, 높이 553) = 96 : 553 → **약 14.8% : 85.2%**(합계 649, 폭 1192 공통)
- 좌/우 분할: **없음**

### 2-2. parent 체인 트리 (controls.csv 원문)
```
this (Form "Shipment Working Day OSP")
├── usrConditionPanel1   [UsrConditionPanel] Dock=Top  Size=1192×96  UsrPanelType=HidePanel
│   └── usrLayoutControl2 [UsrLayoutControl] Dock=Fill Size=1192×96  Text="usrLayoutControl2"
│       ├── dCalendar      [UsrDateRangePicker3]  210×22
│       ├── btnInput       [UsrButton]            77×21   Text="Input"
│       ├── cboDivision    [UsrCombo]             181×20
│       ├── clbPlantSite   [UsrCheckedList]       165×21
│       ├── chkSum         [UsrCheckBox]          46×20   Text="Sum"  Visible=false
│       ├── cboInputValue  [UsrCombo]             124×20
│       └── cboDayWeek     [UsrCombo]             134×20
└── spdMain              [FpSpread] Dock=Fill Size=1192×553
    (spdMain_Sheet1 [SheetView] — parent 미기록, spdMain 의 시트로 추정)

parent 미기록(빈값): usrButton1 [UsrButton] 75×23 / layoutControlGroup2 (1192×96)
                     / layoutControlItem* 7개 / emptySpaceItem* 8개
```

### 2-3. 텍스트 와이어프레임
```
┌──────────────────────────────────────────────────────────────────────────── 1192 ─┐
│ [공통 툴바: 조회(FindButton) · 저장(SaveButton) — 프레임워크 제공, 위치 확인 필요]   │
├───────────────────────────────────────────────────────────────────────────────────┤
│ usrConditionPanel1 / usrLayoutControl2  (높이 96 · 약 14.8%)  ※ HidePanel         │
│  Division* [cboDivision ▼]   Plant Site [clbPlantSite ☑▼]   Period* [dCalendar ~ ] │
│  Day of the week [cboDayWeek ▼]  Input Value [cboInputValue ▼]  [btnInput Input]   │
│  (Sum ☐ chkSum — Visible=false)                                                    │
│  ※ 행·열 배치 순서 = Location 미추출 → 확인 필요 (LayoutItem 높이 25/26, 2행 이상) │
├───────────────────────────────────────────────────────────────────────────────────┤
│ spdMain / spdMain_Sheet1 "Shipment Working Day OSP"  (높이 553 · 약 85.2%)        │
│ ┌────────┬───────────┬─────────┬────────────┬───────┬─────────┬─[LARGE]────────┐ │
│ │ (META 6 컬럼 — 순서 확인 필요)                       │ SUM │[SMALL] SUM│ …  │ │
│ │ DIVISION_ID·PLANT_SITE_ID·PLANT_SITE_NAME·MEASURE·  │     │ 일자 Y/N 콤보 │ │
│ │ WORKING_TIME_DEFAULT·LAST_INPUT_DATE                 │     │ (SAT 파랑/SUN 빨강)│
│ └──────────────────────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────────────────────────┘
```

### 2-4. 영역 정의
| 영역 | 구성 컨트롤 | 비고 |
|---|---|---|
| 조회조건 | cboDivision, clbPlantSite, dCalendar | 필수: Division*, Period* |
| 입력(일괄) 조건 | cboDayWeek, cboInputValue, btnInput | 조회조건 패널 안에 있음 |
| 표시 옵션 | chkSum | Visible=false |
| 버튼 | FindButton, SaveButton(프레임워크), btnInput, usrButton1(용도 확인 필요) | |
| 그리드 | spdMain / spdMain_Sheet1 | 시트 `Shipment Working Day OSP` |
| 팝업 | 없음 (사실 묶음에 팝업 폼 없음) | |

### 2-5. LayoutControlItem 크기 (참고)
| LayoutItem | Control | Size | Text |
|---|---|---|---|
| layoutControlItem4 | cboDivision | 236×25 | `Division*` |
| layoutControlItem7 | clbPlantSite | 226×25 | `Plant Site` |
| layoutControlItem2 | dCalendar | 260×25 | `Period*` |
| layoutControlItem3 | cboDayWeek | 236×25 | `Day of the week` |
| layoutControlItem1 | cboInputValue | 226×25 | `Input Value` |
| layoutControlItem10 | btnInput | 81×25 | (Text 없음) |
| layoutSum | chkSum | 50×25 | (Text 없음) |
| emptySpaceItem1/2/3/4/5/6/9/10 | — | 10×25 / 390×25 / 26×26 / 540×26 / 606×26 / 566×25 / 10×25 / 53×25 | 여백 |

---

## 3. 컨트롤 명세

| # | 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|---|
| C01 | `usrConditionPanel1` | UsrConditionPanel | (Text 없음) | Dock=Top, HidePanel | — | — | 조회조건 패널 컨테이너 |
| C02 | `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` (디자이너 기본명) | Dock=Fill | — | — | 조회조건 Grid 레이아웃 |
| C03 | `cboDivision` | UsrCombo | `Division*` (layoutControlItem4) | **확인 필요** | 필수(`*`) | `CboDivision_SelectedIndexChanged` | Wijmo ComboBox |
| C04 | `clbPlantSite` | UsrCheckedList | `Plant Site` (layoutControlItem7) | **확인 필요** | — | `ClbPlantSite_SelectedIndexChanged` | Wijmo MultiSelect (값 CODE) |
| C05 | `dCalendar` | UsrDateRangePicker3 | `Period*` (layoutControlItem2) | **확인 필요** | 필수(`*`) | — | 기간(From~To) DateRange |
| C06 | `cboDayWeek` | UsrCombo | `Day of the week` (layoutControlItem3) | **확인 필요** | — | `CboDayWeek_SelectedIndexChanged` | Wijmo ComboBox 또는 MultiSelect (672 GetCheckedListValue → 다중 여부 확인 필요). 목록 원천 후보 `biz:CommonData.CommonDataList`(확인 필요) |
| C07 | `cboInputValue` | UsrCombo | `Input Value` (layoutControlItem1) | **확인 필요** (Enabled는 cboDayWeek 따라 false/true) | — | — | Wijmo ComboBox (목록 원천 확인 필요) |
| C08 | `btnInput` | UsrButton | `Input` | — | — | `BtnInput_Click` | Button (일괄 입력) |
| C09 | `chkSum` | UsrCheckBox | `Sum` | Checked=false(121), **Visible=false**(346) | — | `chkSum_CheckedChanged` | CheckBox (노출 정책 확인 필요) |
| C10 | `usrButton1` | UsrButton | (Text 없음) | 75×23, parent 없음 | — | 배선 없음 | **확인 필요** (미사용 후보) |
| C11 | `spdMain` | FpSpread | — | Dock=Fill 1192×553 | — | `SpdMain_CellDoubleClick`, `SpdMain_TopChange` | Wijmo FlexGrid |
| C12 | `spdMain_Sheet1` | SheetView | (시트명 `Shipment Working Day OSP`, AddSheet 142) | 헤더 3행 | — | — | FlexGrid 단일 뷰 (columnHeaders 3행) |

---

## 4. 그리드 명세 — 시트 `Shipment Working Day OSP`

연결 규칙: **META+코드연결** / 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** / 헤더 3행.

### 4-1. META 고정 컬럼 (SCM_MST_SHEET_COLUMNS 6행)
| 컬럼 | 헤더 | 타입 | 출처 | division별 표시(14개) | 편집 가능 | 비고 |
|---|---|---|---|---|---|---|
| DIVISION_ID | Division | 확인 필요 | META | 전 division 기본 | 확인 필요 | |
| PLANT_SITE_ID | Plant Site ID | 확인 필요 | META | 전 division 기본 | 확인 필요 | |
| PLANT_SITE_NAME | Plant Site | 확인 필요 | META | 전 division 기본 | 확인 필요 | |
| MEASURE | Measure | 확인 필요 | META | 전 division 기본 | 확인 필요 | 날짜 컬럼은 이 컬럼 다음 열부터 붙음(159) |
| WORKING_TIME_DEFAULT | Working Time Default | 확인 필요 | META | 전 division 기본 | 확인 필요 | 저장 파라미터 `p_working_time_default` 와 대응 추정 |
| LAST_INPUT_DATE | Last Input Date | 확인 필요 | META | 전 division 기본 | 확인 필요 | |

> 위 표의 행 순서는 grid_effective.csv 순서가 아닙니다. 실제 SORT_ORDER_NO·COLUMN_WIDTH·INPUT 속성·FIXED_FLAG 값은 사실 묶음에 없어 **확인 필요**입니다. division 14개(40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC) 모두 6/0이며 표시 차이는 없습니다.

### 4-2. 코드 생성 날짜 컬럼 (DB 루프 — `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과)
| 조건 | 컬럼 | 헤더 | 타입 | 출처 | 폭 | 표시 | 편집 | 스타일 | 근거 |
|---|---|---|---|---|---:|---|---|---|---|
| `COLUMN_NAME.IndexOf("B_") > 0` | COLUMN_NAME | COLUMN_LABEL_NAME | Text | HARDCODED(코드)+DB값 | 0 | 숨김 | — | — | 196 |
| 그 외 | COLUMN_NAME | COLUMN_LABEL_NAME | Combo (`dtValidYN` = `biz:CommonData.YesOrNo`) | HARDCODED(코드)+DB값 | 50 | 표시 | Combo 셀(편집 잠금 여부 확인 필요) | 가로·세로 Center, DAY_CODE SAT → 파랑 / SUN → 빨강 | 203·208 |

### 4-3. 헤더 3단 Span
| 헤더 행 | 내용 | 높이 | 근거 |
|---|---|---|---|
| 0행 | LARGE_CLASS_LABEL_NAME (그룹 Span) | 20 | 215·243 |
| 1행 | SMALL_CLASS_LABEL_NAME (그룹 Span), Large 그룹 시작 열에 `"SUM"`(행 Span 2) | 20 | 216·221·230·241·244 |
| 2행 | COLUMN_LABEL_NAME, Small 그룹 시작 열에 `"SUM"` | 30(222) / 20(231·242) | 222·231·242 |

### 4-4. 표시 토글 (SetSpreadColumn, Tag 접두어)
| Tag 접두어 | Visible | 근거 |
|---|---|---|
| `D_` | true | 350 |
| `M_` | `chkSum.Checked` | 355 |
| `W_` | 350에서 true → 355에서 `chkSum.Checked`(최종값 실행 확인 필요) | 350·355 |

호출 시점: `InitSpread`(160), `FindData_Main`(484, 결과 행이 있을 때만), `chkSum_CheckedChanged`(330·335).

### 4-5. Designer 헤더 스타일
HorizontalAlignment/VerticalAlignment = General, NoteIndicatorColor = Red, Parent = `ColumnHeaderDefaultEnhanced` (628~631).

---

## 5. 액션 명세

| ID | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A-01 | 화면 Load | `Form_Load` | InitControls → GetBucketType | `DM.DM0003_GET_BUCKET_TYPE_CODE` (SP `DM0003_GET_BUCKET_TYPE_CODE`) | 바인딩 대상 컨트롤 **확인 필요** |
| A-02 | 화면 Load | `Form_Load` | CreateSpread → AddSheet → InitSpread → GetSpdTitle → SetSheetHeaderColumn → InitSpreadDateColumn → SetSpreadColumn | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` (SP `SCP0009_GET_SHEET_CALENDAR_3SPAN`), 날짜 Combo 데이터 `biz:CommonData.YesOrNo` | `spdMain_Sheet1` 헤더 3단, META 6컬럼과 날짜 컬럼 생성 |
| A-03 | 조회 버튼 | FindButton → `FindData_Main` | GetCheckedListValue ×2(442·443) → 조회 → InitSpread(헤더 재생성) → 결과가 있으면 SetSpreadColumn | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` (SP `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`), `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | `spdMain` 데이터 바인딩 |
| A-04 | 저장 버튼 | SaveButton → `SaveData_Main` | p_* 행 구성 → GetChanges(ROW_ID) → (저장 호출 **미검출**) → FindData_Main | 저장 엔드포인트 **확인 필요** → `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 재조회 결과 표시 |
| A-05 | 그리드 셀 더블클릭 | `SpdMain_CellDoubleClick` | **확인 필요** | 없음(검출 기준) | 확인 필요 |
| A-06 | 그리드 스크롤 | `SpdMain_TopChange` | **확인 필요** | 없음(검출 기준) | 확인 필요 |
| A-07 | Division 변경 | `CboDivision_SelectedIndexChanged` | **확인 필요** | 없음(검출 기준) | 확인 필요 |
| A-08 | Plant Site 변경 | `ClbPlantSite_SelectedIndexChanged` | **확인 필요** | 없음(검출 기준) | 확인 필요 |
| A-09 | Day of the week 변경 | `CboDayWeek_SelectedIndexChanged` | GetCheckedListValue(672) → 조건에 따라 `cboInputValue.Enabled` false(675)/true(679) | 없음 | cboInputValue 활성 상태 |
| A-10 | Input 버튼 | `BtnInput_Click` | GetCheckedListValue ×2(695·696) → 그리드 일괄 입력(범위 확인 필요) | 없음(검출 기준) | spdMain 셀 값(확인 필요) |
| A-11 | Day of the week 목록 | (필드 초기화 `dtDayWeek` :49) | Lookup 공통코드 조회 | `biz:CommonData.CommonDataList` [code=LookupCommon] | cboDayWeek 바인딩 여부 **확인 필요** |
| A-12 | Sum 체크 변경 | `chkSum_CheckedChanged` | SetSpreadColumn(330/335) | 없음 | M_/W_ 컬럼 Visible = chkSum.Checked |

---

## 6. 검증·메시지

| # | 검증 | 사실 | 메시지 |
|---|---|---|---|
| V1 | Division 필수 | 라벨 `Division*` | 메시지 ID/문구 **확인 필요** |
| V2 | Period 필수 | 라벨 `Period*` | **확인 필요** |
| V3 | 조회 결과 없음 | `GetMaxRowIndex() > 0` 이 아니면 SetSpreadColumn 생략 | 결과 없음 메시지 **확인 필요** |
| V4 | 저장 변경분 없음 | GetChanges(ROW_ID)로 변경분 추출 | 변경 없음 메시지 **확인 필요** |
| V5 | 저장 성공/실패 | 저장 SP 미검출 | **확인 필요** |
| V6 | Input Value 비활성 | cboDayWeek 따라 Enabled false/true | 메시지 없음(확인 필요) |

> TO-BE 메시지는 AS-IS MSG ID를 그대로 쓰지 말고, 문구 기준으로 TO-BE ID를 찾아 매핑합니다(프로젝트 규약).

---

## 7. 권한 (C/R/U/D)

| 권한 | 사실 | 근거 |
|---|---|---|
| R (조회) | FindButton 사용 | flow.csv |
| C/U (저장) | SaveButton 사용, `p_user_id` 전달. 신규와 수정의 구분은 **확인 필요** | flow.csv, meta_reads.csv |
| D (삭제) | 삭제 버튼·엔드포인트 미검출 | — |
| 메타 | TB_FX_GroupMenuAuth 4행 — 값 **확인 필요** | Fact Pack §8 |
| 기타 | EditButton 메서드(288) — 진입 여부 **확인 필요** | grid_code.csv |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| # | 항목 | AS-IS | To-Be |
|---|---|---|---|
| T1 | 그리드 | FarPoint FpSpread, 헤더 3행 ColumnHeaderSpan | Wijmo FlexGrid `columnHeaders` 3행 + 병합(allowMerging) 또는 컬럼 그룹. SUM 헤더 Span 재현 |
| T2 | 동적 날짜 컬럼 | SCP0009 결과로 DB 루프 AddCombo/AddText | 조회 응답의 컬럼 정의로 columns 동적 생성. `B_` 포함 컬럼은 visible=false |
| T3 | Y/N 콤보 셀 | `dtValidYN` = Data.Common(YesOrNo) | FlexGrid `DataMap`(Y/N), 셀에 NAME 표시 |
| T4 | 주말 색상 | ForeColor SAT 파랑 / SUN 빨강 | `formatItem` 에서 DAY_CODE 기준 class 적용(inline style 금지) |
| T5 | 표시 토글 | Tag 접두어 D_/M_/W_ + chkSum | 컬럼 Tag(바인딩명 접두어)로 visible 계산. chkSum 노출 정책 결정 필요(AS-IS Visible=false) |
| T6 | 체크 목록 | UsrCheckedList / GetCheckedListValue(CODE) | MultiSelect, 선택값 배열 → SP 다중값 인자 |
| T7 | Oracle 변환 | SP 안에 `STRING_SPLIT`, `#TBLDYNAMICPIVOT_SCP0096`(임시 테이블), 동적 SQL PIVOT | `STRING_SPLIT` 은 MSSQL 키워드라 금지 → 다중값은 GTT 적재나 Oracle 분해 방식으로 대체. `#` 임시 테이블 → GTT(DDL 동반). 동적 PIVOT은 IN절과 SELECT 변수를 분리 |
| T8 | 일괄 입력 | btnInput (조회조건 패널 안) | 프로젝트 규약(조회영역 일괄 입력 = SubTitle 버튼 + InputModal, hook #155)을 적용할지는 설계 확정 시 확인 |
| T9 | 저장 | 저장 SP 미검출 | 저장 SP를 확정한 뒤 PKG로 구현. `p_is_save_defalut` 철자는 계약 확정 시 결정 |
| T10 | 미사용 후보 | `usrButton1`, `cboBucketType_SelectedIndexChanged`, DM0003 결과 사용처 | 사용처를 확인한 뒤 이관할지 결정 |

---

## 9. 미확정

1. 저장 SP/엔드포인트와 저장 대상 테이블 (최우선)
2. 조회조건 배치 순서(Location 미추출)와 컨트롤 초기값
3. META 6개 컬럼의 정렬·폭·편집 여부·고정 여부
4. `SpdMain_CellDoubleClick` / `SpdMain_TopChange` / `CboDivision_SelectedIndexChanged` / `ClbPlantSite_SelectedIndexChanged` 본문
5. `cboInputValue` Enabled 분기 조건, `BtnInput_Click` 입력 범위
6. `cboDayWeek` 단일/다중 여부와 목록 원천(`biz:CommonData.CommonDataList`)
7. `chkSum` 노출 정책, `W_` 최종 표시값
8. `usrButton1` 용도, DM0003 결과 사용처
9. 메뉴 위치, TB_FX_GroupMenuAuth 권한 값
10. 456행 주석 처리 호출은 현행 아님 → 설계 대상에서 제외

=== FILE: unit_test.md ===
# SCP0096 — Shipment Working Day OSP 단위테스트

> **작성 근거**: 업무분석서 §5 / 화면설계서 §3·§5와 같은 이름을 씁니다. 기대결과 중 사실 묶음으로 정할 수 없는 부분은 **확인 필요**로 표기했고, 실행할 때 AS-IS 동작을 확인해 확정합니다.
> 주석 처리된 호출은 현행 기능이 아니므로 테스트 대상에서 제외했습니다.

## 테스트 케이스

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0096-001 | 초기화 | 화면 권한이 있는 사용자로 로그인 | 메뉴에서 SCP0096 화면을 연다 | — | `Form_Load` → InitControls → GetBucketType 이 Bucket Type 코드를 1회 호출하고 오류 없이 화면이 열림(결과 바인딩 컨트롤은 확인 필요) | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SCP0096-002 | 초기화 | TC-001과 같음 | 화면을 열고 `spdMain` 의 시트를 확인한다 | — | 시트 `Shipment Working Day OSP` 1개가 생성되고 컬럼 헤더가 3행임. 달력 헤더 조회가 호출됨 | `Form_Load`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` |
| TC-SCP0096-003 | 초기화 | TC-001과 같음 | 화면을 열고 `chkSum` 의 표시·체크 상태를 확인한다 | — | `chkSum` 화면에 보이지 않음(Visible=false), Checked=false. `M_`/`W_` Tag 컬럼 숨김 | `Form_Load`, `chkSum_CheckedChanged`(SetSpreadColumn 355), `Shipment Working Day OSP` |
| TC-SCP0096-004 | 그리드 | 화면 열림 | `spdMain_Sheet1` 의 META 컬럼 헤더를 확인한다 | — | Division / Plant Site ID / Plant Site / Measure / Working Time Default / Last Input Date 6개 컬럼이 표시됨(순서는 META SORT_ORDER_NO 확인 필요) | `Shipment Working Day OSP`, SetSheetHeaderColumn(InitSpread:156) |
| TC-SCP0096-005 | 그리드 | 조회 데이터가 있는 조건 | `cboDivision`·`dCalendar` 를 입력하고 조회 후 날짜 컬럼을 확인한다 | Period = 임의 2주 | MEASURE 다음 열부터 날짜 컬럼이 SCP0009 결과 행 수만큼 생성됨. 폭 50, 가운데 정렬, Y/N 콤보 셀 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `biz:CommonData.YesOrNo`, `Shipment Working Day OSP` |
| TC-SCP0096-006 | 그리드 | TC-005 조회 완료 | 날짜 셀의 콤보 목록을 펼친다 | — | 목록이 Yes/No(YesOrNo 공통 데이터)로 구성됨 | `biz:CommonData.YesOrNo`, `Shipment Working Day OSP` |
| TC-SCP0096-007 | 그리드 | TC-005 조회 완료 | 컬럼명에 `B_` 가 위치 1 이상에 포함된 컬럼이 있는지 확인한다 | — | 해당 컬럼은 폭 0 Text, 숨김 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` (InitSpreadDateColumn 196) |
| TC-SCP0096-008 | 그리드 | 토·일요일이 들어간 기간 | 토·일 날짜 컬럼의 글자색을 확인한다 | Period에 토·일 포함 | DAY_CODE SAT 컬럼은 파랑, SUN 컬럼은 빨강, 평일은 기본색 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` (208) |
| TC-SCP0096-009 | 그리드 | 여러 Large/Small 그룹에 걸친 기간 | 헤더 0~2행을 확인한다 | Period = 그룹 경계를 넘는 기간 | 0행 LARGE_CLASS_LABEL_NAME, 1행 SMALL_CLASS_LABEL_NAME으로 Span. 각 그룹 시작 열에 `SUM` 헤더 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` (215~244) |
| TC-SCP0096-010 | 조회 | 데이터가 있는 Division / Plant Site | `cboDivision`·`clbPlantSite`·`dCalendar` 를 입력하고 조회 버튼을 누른다 | Division=유효값, Plant Site 1개 이상 체크 | 조회 SP가 호출되고, 체크한 Plant Site 행만 그리드에 표시됨. 달력 헤더 재생성. 결과 행이 있으므로 SetSpreadColumn 실행 | FindButton > `FindData_Main`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-011 | 조회 | 데이터가 없는 조건 | 데이터가 없는 조건으로 조회 버튼을 누른다 | 데이터 없는 Plant Site/기간 | 그리드 0행, 오류 없음. `GetMaxRowIndex() > 0` 이 아니므로 SetSpreadColumn 생략. 결과 없음 메시지 여부는 확인 필요 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `FindData_Main`(484) |
| TC-SCP0096-012 | 조회 | 조회 SP 오류를 유발할 수 있는 환경 | 조회 SP가 오류를 반환하는 상태에서 조회 버튼을 누른다 | (오류 응답) | 오류 메시지 표시, 그리드 이전 상태 유지 여부 확인 필요. 화면 비정상 종료 없음 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-013 | 조회 | 화면 열림 | `cboDivision` 또는 `dCalendar` 를 비우고 조회 버튼을 누른다 | Division 빈값 / Period 빈값 | 필수(`Division*`, `Period*`) 검증 동작·메시지 **확인 필요** | FindButton > `FindData_Main`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-014 | 조회 | 달력 헤더 결과가 없는 기간 | 달력 데이터가 없는 기간으로 화면을 열거나 조회한다 | Period = 달력 미등록 기간 | 날짜 컬럼 0개, META 6개 컬럼만 표시. 오류 여부 확인 필요 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SCP0009_GET_SHEET_CALENDAR_3SPAN`, `Shipment Working Day OSP` |
| TC-SCP0096-015 | 조회 | Bucket Type 코드 결과가 0건인 환경 | 화면을 연다 | — | 화면 초기화가 오류 없이 끝남(DM0003 결과 사용처 확인 필요) | `Form_Load`, `DM.DM0003_GET_BUCKET_TYPE_CODE`, `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SCP0096-016 | 저장 | TC-010 조회 완료 | `spdMain` 날짜 셀 1개를 Y↔N로 바꾸고 저장 버튼을 누른다 | 셀 값 변경 1건 | 변경 행(ROW_ID)만 저장 파라미터 `p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default` 로 구성. 저장 후 재조회 결과에 변경값이 반영됨(저장 SP 확인 필요) | SaveButton > `SaveData_Main` > `FindData_Main`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SCP0096-017 | 저장 | TC-010 조회 완료 | 아무것도 바꾸지 않고 저장 버튼을 누른다 | 변경 없음 | GetChanges 결과 0건. 저장 호출 여부·메시지 확인 필요 | `SaveData_Main`(609 GetChanges), `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-018 | 저장 | 저장 오류를 유발할 수 있는 환경 | 셀을 바꾸고 저장 버튼을 누른다 | (오류 응답) | 오류 메시지 표시, 데이터 미반영. 재조회 여부 확인 필요 | `SaveData_Main`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| TC-SCP0096-019 | 이벤트 | TC-010 조회 완료 | `spdMain` 셀을 더블클릭한다 | 임의 데이터 셀 | 핸들러가 실행되고 오류 없음. 동작 내용 확인 필요 | `SpdMain_CellDoubleClick`, `Shipment Working Day OSP` |
| TC-SCP0096-020 | 이벤트 | TC-010 조회 완료(행이 화면보다 많음) | `spdMain` 을 세로로 스크롤한다 | — | 핸들러가 실행되고 오류 없음. 동작 내용 확인 필요 | `SpdMain_TopChange`, `Shipment Working Day OSP` |
| TC-SCP0096-021 | 이벤트 | 화면 열림 | `cboDivision` 값을 바꾼다 | Division A → B | 핸들러가 실행되고 오류 없음. `clbPlantSite` 목록 재조회 등 연동은 확인 필요 | `CboDivision_SelectedIndexChanged` |
| TC-SCP0096-022 | 이벤트 | 화면 열림 | `clbPlantSite` 체크를 바꾼다 | Plant Site 체크/해제 | 핸들러가 실행되고 오류 없음. 연동 동작 확인 필요 | `ClbPlantSite_SelectedIndexChanged` |
| TC-SCP0096-023 | 이벤트 | 화면 열림 | `cboDayWeek` 를 서로 다른 값으로 두 번 바꾸며 `cboInputValue` 활성 상태를 본다 | 값 1 / 값 2 | 선택 조건에 따라 `cboInputValue.Enabled` 가 false(675) / true(679)로 바뀜(조건 확인 필요) | `CboDayWeek_SelectedIndexChanged` |
| TC-SCP0096-024 | 이벤트 | 화면 열림 | `cboDayWeek` 목록을 펼친다 | — | 요일 목록 표시. 원천이 Lookup 공통코드인지 확인 필요 | `biz:CommonData.CommonDataList`, `CboDayWeek_SelectedIndexChanged` |
| TC-SCP0096-025 | 이벤트 | TC-010 조회 완료 | `cboDayWeek`·`cboInputValue` 를 고르고 `btnInput` 을 누른다 | 요일 값, Input Value 값 | 지정한 요일 조건의 날짜 셀에 Input Value가 일괄 반영됨(대상 행/열 범위 확인 필요). 서버 호출 없음 | `BtnInput_Click`, `Shipment Working Day OSP` |
| TC-SCP0096-026 | 이벤트 | TC-010 조회 완료, `chkSum` 을 조작할 수 있는 테스트 환경 | `chkSum` 을 체크 → 해제한다 | Checked true → false | true: `M_`/`W_` 컬럼 표시, `D_` 표시 유지. false: `M_`/`W_` 숨김, `D_` 표시 유지 | `chkSum_CheckedChanged`, `Shipment Working Day OSP` (SetSpreadColumn 350·355) |
| TC-SCP0096-027 | division | 14개 division(40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC) 데이터 | division별로 `cboDivision` 을 바꿔 조회 버튼을 누르고 META 컬럼을 비교한다 | division 14개 | 모든 division에서 META 6개 컬럼이 똑같이 표시됨(division별 변형 없음) | `CboDivision_SelectedIndexChanged`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP`, `Shipment Working Day OSP` |
| TC-SCP0096-028 | 권한 | 조회 권한만 있는 그룹 / 저장 권한이 있는 그룹 | 각 계정으로 화면을 열고 조회·저장 버튼이 보이는지·동작하는지 확인한다 | 권한 그룹 2종 | TB_FX_GroupMenuAuth 값에 따라 버튼 노출·동작(권한 값 확인 필요) | `Form_Load`, FindButton > `FindData_Main`, SaveButton > `SaveData_Main`, `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |

## 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001, 002, 003, 015, 028 |
| | `SpdMain_CellDoubleClick` | 019 |
| | `SpdMain_TopChange` | 020 |
| | `CboDivision_SelectedIndexChanged` | 021, 027 |
| | `ClbPlantSite_SelectedIndexChanged` | 022 |
| | `CboDayWeek_SelectedIndexChanged` | 023, 024 |
| | `BtnInput_Click` | 025 |
| | `chkSum_CheckedChanged` | 003, 026 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 024 |
| | `biz:CommonData.YesOrNo` | 005, 006 |
| | `DM.DM0003_GET_BUCKET_TYPE_CODE` | 001, 015 |
| | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | 010~013, 016~018, 027, 028 |
| | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 002, 005, 007~010, 014, 016 |
| 시트 | `Shipment Working Day OSP` | 002~009, 014, 019, 020, 025~027 |
| 빈 결과 | 조회 0건 / 달력 0건 / 코드 0건 / 변경 0건 | 011, 014, 015, 017 |
| 오류 응답 | 조회 / 저장 | 012, 018 |
| division | 14개 division 동일(변형 없음) | 027 |
