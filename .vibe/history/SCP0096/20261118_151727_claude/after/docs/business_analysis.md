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
