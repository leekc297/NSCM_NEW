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
