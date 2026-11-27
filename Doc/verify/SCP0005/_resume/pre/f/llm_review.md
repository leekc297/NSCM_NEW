# SCP0005 AI 판정 검토 (2026-11-26 02:39:10)

- 대상 92행: 검토 24 · 검토 제외 68 · 미검토 0
- 인용 확인 24행 · 판정 반영 8행 · 엔진 보완 대상 5행 · 룰 등록 후보 0행
- 호출 2회(캐시 0) · 실패 0회 · 비용 1.6842 USD · 출처 Doc/verify/SCP0005/llm_usage.csv

| 행 | 규칙 | 지금 | 분류 | AI 판정 | 인용 | 반영 | 사유 | 근거 | 고칠 곳 |
|---|---|---|---|---|---|---|---|---|---|
| V-d5a22e0f | M1 | 판정필요 | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS Excel Form 버튼은 숨김 처리되어 있고, 클릭 처리도 팝업 없이 양식 파일만 내려받습니다. TO-BE는 사용자 요구로 버튼을 노출하고 팝업 없이 머리글 1행 양식을 내려받으며, 시험에서도 호출 1건이 확인되었습니다. CR-095는 팝업 없는 양식 다운로드를 오류로 보지 않습니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.Designer.cs:488 ; GSCM/06.UIL/ |  |
| V-6f2db8d3 | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-ba8f9817 | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5804ccc8 | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-5a4e9648 | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-7ac42873 | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-753a87af | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-cb7ed54f | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-3d0ea655 | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-d8ff8497 | F3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-2ca073e5 | N1 | FAIL | 데이터차이 | 판정필요 | Y | Y 데이터 차이 — 판정필요(CR-101) | AS-IS 조회 SP와 TO-BE 조회 패키지 모두 L/T Type(LT_TYPE)을 변환 없이 원장 값 그대로 돌려줍니다. 따라서 화면의 '/' 48칸(전체 11700칸)은 조회 로직이 아니라 TO-BE 원장 SCP_MST_DISTRIBUTION_ROUTE에 저장된 빈 값 센티널에서 옵니다. 해당 행을 정리할지, '/' 표시를 허용할지 사용자가 판정해야 합니다. | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP6_DDL.sql:34713 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP6_DDL.sql:34 |  |
| V-087d756b | E3 | FAIL | 확인불가 | FAIL | Y | N 판정 같음 | AS-IS 는 필수 칸이 빈 행을 Check 칸에 Error-Required 로 표시하고, 뒤이은 요일·숫자 검사가 같은 칸을 덮어쓸 수 있습니다. TO-BE 는 이 파일을 오류 1건(Check 'Error-Number')으로 표시하고 MSG00657 알림으로 저장을 막아, 저장 차단은 AS-IS 와 같습니다. TO-BE 업로드 검증 SP(PKG_SCP0005 EXCEL_UPLOAD)가 To-be_v2_converted/06_Packages 에 없어 TO-BE  | GSCM/01.Framework/GSCM.Windows.Forms/UI/ExcelUploadForm2.cs:960 ; GSCM/01.Framework/GSCM.Windows.Forms/UI/ExcelUploadFor |  |
| V-4e4af2a4 | F1 | FAIL | 확인불가 | FAIL | Y | N 판정 같음 | 값 불일치로 기록된 PRIORITY 칸(4를 5로 변경)은 저장이 RESULT_CODE F 로 거부된 경우다. AS-IS 저장 SP 도 같은 출발지·도착지에 같은 Priority 가 있으면 99020 으로 거부하므로, 이 건은 업무 검증 차단에 해당한다. 나머지 값 불일치 1칸과 입력 경로 실패 4칸은 원장과 e2e_results.json 의 근거 문장이 DAYS_TUE 에서 잘려 있어 대상 컬럼을 확인할 수 없으므로 FAIL 을 그대로 둔다. | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP6_DDL.sql:35459 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP6_DDL.sql:35 |  |
| V-b3450ff5 | E4 | ERROR | 검토 제외 |  | N | N 재측정 대상(실저장필요·사람) — AI 판정 대상 아님 |  |  |  |
| V-0810a59e | H2 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 1278줄은 Save 때 CheckValid 가 이전 오류 색을 지우려고 FROM_CITY_NAME~FROM_CITY 구간을 UnLockColor 로 되돌리는 코드입니다. 이 구간의 FROM_CITY_NAME 은 AS-IS 에서도 Edit 때 잠그는 컬럼입니다(322줄). TO-BE 는 FROM_COUNTRY·FROM_CITY 를 편집색으로, 입력 불가인 FROM_CITY_NAME 을 흰색으로 표시하므로 CR-016 표준과 맞고, 편집색이 아닌 4칸은 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:1278 ; GSCM/06.UIL/GSCM.SCP |  |
| V-c099fa4f | H2 | FAIL | TOBE룰 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 1279줄은 Save 때 CheckValid 가 TO_CITY_NAME~TO_CITY 구간의 오류 색을 UnLockColor 로 되돌리는 코드입니다. 이 구간의 TO_CITY_NAME 은 AS-IS 에서도 Edit 때 잠그는 컬럼입니다(323줄). TO-BE 는 TO_COUNTRY·TO_CITY 를 편집색으로, 입력 불가인 TO_CITY_NAME 을 흰색으로 표시하므로 CR-016 표준과 맞고, 편집색이 아닌 4칸은 모두 TO_CITY_NAME 입니다 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:1279 ; GSCM/06.UIL/GSCM.SCP |  |
| V-b4651880 | H2 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 에서는 PRIORITY 가 1 미만인 편집 행을 Save 하면 PRIORITY 칸을 InvalidColor 로 칠하고 MSG00107 을 띄웁니다. TO-BE 는 'Priority는 양의 정수입니다.' 알림만 띄우고 칸 색은 칠하지 않아, PRIORITY 색이 Save 전후로 같았습니다. 이 차이를 허용하는 TO-BE 룰은 룰 원장에 없습니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:1296 ; GSCM/06.UIL/GSCM.SCP |  |
| V-17e451a7 | H2 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 에서는 FROM_CITY_NAME 이 빈 편집 행을 Save 하면 FROM_CITY_NAME~FROM_CITY 구간을 InvalidColor 로 칠하고 Save 를 멈춥니다. TO-BE 는 Save 할 때 setInvalidCells([]) 로 오류 색을 지우고 알림만 띄웁니다. 그래서 FROM_CITY_NAME·FROM_COUNTRY·FROM_CITY 색이 Save 전후로 같았고, 이 차이를 허용하는 TO-BE 룰은 룰 원장에 없습니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:1305 ; GSCM/06.UIL/GSCM.SCP |  |
| V-e63ff383 | H2 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 에서는 TO_CITY_NAME 이 빈 편집 행을 Save 하면 TO_CITY_NAME~TO_CITY 구간을 InvalidColor 로 칠하고 Save 를 멈춥니다. TO-BE 는 Save 할 때 setInvalidCells([]) 로 오류 색을 지우고 알림만 띄웁니다. 그래서 TO_CITY_NAME·TO_COUNTRY·TO_CITY 색이 Save 전후로 같았고, 이 차이를 허용하는 TO-BE 룰은 룰 원장에 없습니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:1313 ; GSCM/06.UIL/GSCM.SCP |  |
| V-3134fc3e | E4 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | T-ece1c98b 와 원인이 같다. AS-IS 는 중복 오류(99010·99020)에서 MSG00043 에 Route Id 를 넣어 보여 주지만, TO-BE 는 서버 문구 'DUP DATA.'·'DUP PRIORITY.'를 그대로 표시한다. 저장 차단과 위반 칸 색칠은 TO-BE 에도 구현되어 있고, 메시지 문구만 다르다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:812 ; GSCM/06.UIL/GSCM.SCP. |  |
| V-4a0b6271 | E4 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 는 Excel Upload 창을 닫으면 업로드 여부와 관계없이 MSG00265 로 다시 조회할지 묻고, Yes 일 때 재조회합니다. TO-BE 는 업로드에 성공했을 때만 MSG00265 토스트를 띄우고 묻지 않고 재조회하며, Cancel 로 닫으면(handleClose) 메시지가 없습니다. 이 차이를 허용하는 룰은 TO-BE 룰 원장에 없습니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:379 ; GSCM/06.UIL/GSCM.SCP. |  |
| V-e458f301 | MS1 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 업로드 창이 닫힌 뒤 MSG00265 「다시 조회하시겠습니까?」를 Yes/No 확인창으로 묻고, Yes 일 때만 다시 조회합니다. TO-BE 는 같은 번호 MSG00265 를 「Excel 업로드가 완료되었습니다. 재조회합니다.」라는 완료 알림으로 쓰고, 묻지 않고 항상 다시 조회합니다. 같은 문구의 TO-BE 번호 MSG01273 이 있는데 쓰지 않았고, 이 차이를 허용하는 TO-BE 룰도 없습니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:381 ; GSCM/06.UIL/GSCM.SCP. |  |
| V-718e1a16 | H6 | FAIL | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-616b4d31 를 검토) |  |  |  |
| V-7cdbda05 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 의 From/To 검색 버튼과 셀 팝업은 모두 SCM0002_CitybyCountry 를 열고, 버튼 순서는 Find, OK, Close 다. TO-BE 공용 RegionModal 은 Close 다음 OK 로 그려 AS-IS 와 CR-005(OK → CLOSE) 모두와 다르다. No 컬럼과 건수 표시는 맞다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:346 ; GSCM/06.UIL/GSCM.SCM. |  |
| V-616b4d31 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ac0769f6 | H6 | FAIL | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-7cdbda05 를 검토) |  |  |  |
| V-0e9099ba | H6 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-a46588cb | M3 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| V-4cfc72f5 | H6 | ERROR | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-0e9099ba 를 검토) |  |  |  |
| V-cca901cb | H6 | FAIL | 검토 제외 |  | N | N 중복 정리 구성원(대표 V-c9dc5aa7 를 검토) |  |  |  |
| V-c9dc5aa7 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 의 From/To 검색 버튼과 셀 팝업은 모두 SCM0002_CitybyCountry 를 열고, 버튼 순서는 Find, OK, Close 다. TO-BE 공용 RegionModal 은 Close 다음 OK 로 그려 AS-IS 와 CR-005(OK → CLOSE) 모두와 다르다. No 컬럼과 건수 표시는 맞다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:346 ; GSCM/06.UIL/GSCM.SCM. |  |
| V-433764ba | E3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-f8dede79 | M1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ffb5feca | M1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ac167c8b | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-ef37f9e9 | H6 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-76ba2022 | M1 | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-660a833e | H5 | FAIL | 검토 제외 |  | N | N 기준 원장 같은 확인 구성원(C-cc03e5c3c2 대표를 검토) |  |  |  |
| V-a32c8abf | M1 | 판정필요 | 검토 제외 |  | N | N 기준 원장 같은 확인 구성원(C-9e9bb40653 대표를 검토) |  |  |  |
| V-5daefe3f | K4 | ERROR | 검토 제외 |  | N | N 스냅샷 승인 대기(snap_validate·snap_approve 경로) |  |  |  |
| T-78600da2 | F4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-117a91ca | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6d3ab193 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5ab1639a | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c21ed709 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ffd8cc98 | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1254494a | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1b394e4f | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a2e01ea6 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e999c1bd | H6 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-c0a47fd2 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-30dac365 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-643aee5e | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6f3e294f | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d920ea16 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-719d403c | F4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-432b276b | X-ROW | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-e71343b5 | X-ROW | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-0aa76ea9 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a12fee3f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ece1c98b | E4 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 는 저장 응답 오류코드가 99010 또는 99020 이면 MSG00043 「저장시 중복 오류가 발생하였습니다.( Route Id : 번호 )」를 띄운다. TO-BE 는 서버 오류 문구('DUP DATA.', 'DUP PRIORITY.')를 그대로 알림에 띄우고, MSG00043 은 문구가 없을 때만 쓰므로 Route Id 도 표시되지 않는다. 이 차이를 허용하는 TO-BE 룰은 없다(CR-036 은 Excel Upload 대상, DD-010·DD-08 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:813 ; Doc/_legacy_source/DB |  |
| T-1169e814 | H2 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-daa63418 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-3bee5a7f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-2c4e7c8a | E4 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 는 Excel Upload 창을 닫으면 업로드 여부와 관계없이 MSG00265 '다시 조회하시겠습니까?' 를 묻고 Yes 일 때 재조회한다. TO-BE 는 업로드 성공 때만 토스트를 띄우고 묻지 않고 재조회하며, Cancel 로 닫으면 메시지가 없다. 이 차이를 허용하는 TO-BE 룰이 원장에 없다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:379 ; GSCM/06.UIL/GSCM.SCP. |  |
| T-895bac8f | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9e212130 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-1a5e50b8 | X-ROW | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-fce350f2 | M4 | 판정필요 | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS SCP0005_DistributionRoutePopup 은 이력을 보기만 하는 팝업입니다. 닫힌 뒤 처리 블록이 비어 있어서 메인 그리드 칸에 들어가는 값이 없습니다. 팝업 선택값 반영이라는 검사 대상이 AS-IS 에 없으므로 NA 입니다. 팝업이 열리지 않는 결함은 T-6d14c72c 와 EG-a1c25099 에서 따로 FAIL 로 처리합니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:1103 ; GSCM/06.UIL/GSCM.SCP | tools/Harness/verify 의 추적 생성이 CellDoubleClick 으로 여는 팝업을 모두 M4 선택값 반영 대상으로 잡습니다. ShowDialog 뒤 블록에서 그리드 칸에 값을 넣는(SetValue) 코드가 있는 팝업만 대상으로 잡아야 합니다. |
| T-9343bbce | M4 | ERROR | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-d6110a41 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6d14c72c | M3 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 이력 팝업은 열릴 때 ROUTE_ID 로 SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID 를 호출해 변경 이력을 보여 줍니다. TO-BE 에는 이 팝업도 더블클릭 연결도 없어서, ROUTE_ID 를 더블클릭해도 10초 동안 대화상자 0개, 서버 호출 0건이었습니다. EG-a1c25099 와 원인이 같은 결함입니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:1100 ; GSCM/06.UIL/GSCM.SCM |  |
| T-f440761d | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-004bd1d4 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-9bf7f55b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-6cba9e4a | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-70884df3 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ea530cd5 | F4 | ERROR | 검토 제외 |  | N | N 재측정 대상(검사기공백·엔진) — AI 판정 대상 아님 |  |  |  |
| T-09365c5b | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-ec7da311 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-b28fc636 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| EG-b395018a | H6 | FAIL | 검토 제외 |  | N | N 중복 정리 구성원(대표 EG-09469e15 를 검토) |  |  |  |
| EG-09469e15 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 도시 팝업 City by Country는 Find, OK, Close 순서로 버튼을 둔다. TO-BE는 From/To 검색 버튼과 FROM/TO Country·City 셀 더블클릭에서 모두 같은 공용 RegionModal을 여는데, 이 팝업은 Close, OK 순서로 그린다. AS-IS 순서와도 CR-005 OK → CLOSE 규칙과도 다르다. | GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_CitybyCountry.Designer.cs:143 ; GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_CitybyCoun |  |
| EG-813457a4 | H6 | FAIL | 검토 제외 |  | N | N 중복 정리 구성원(대표 EG-24dc66b9 를 검토) |  |  |  |
| EG-a1c25099 | M3 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS는 ROUTE_ID 칸을 더블클릭하면 행 상태와 관계없이 Route 이력 팝업 SCP0005_DistributionRoutePopup을 연다. TO-BE 그리드의 더블클릭 핸들러는 FROM/TO 도시 칸만 처리하고, ROUTE_ID 분기와 이력 팝업이 화면 폴더 어디에도 없다. TO-BE 매핑 문서는 AS-IS에 이 기능이 없다고 적었는데, 이는 원문 cs:1093~1104와 다르다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:187 ; GSCM/06.UIL/GSCM.SCP. |  |
| EG-9c573043 | D5 | 판정필요 | 실결함 | FAIL | Y | Y AS-IS 원문 인용 확인 | AS-IS는 Route Id 칸을 더블클릭하면 Route 이력 팝업(SCP0005_DistributionRoutePopup)을 엽니다. TO-BE 그리드의 더블클릭 처리는 From·To 도시 칸만 다룹니다. nscm-fe 전체에서 ROUTE_HIST·RouteHist를 찾았으나 이력 팝업 호출은 없었고, 이 차이를 허용하는 TO-BE 룰도 없습니다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:187 ; GSCM/06.UIL/GSCM.SCP. |  |
| EG-e97f075b | H6 | FAIL | 검토 제외 |  | N | N 중복 정리 구성원(대표 EG-24dc66b9 를 검토) |  |  |  |
| EG-7b7aa573 | H6 | FAIL | 검토 제외 |  | N | N 중복 정리 구성원(대표 EG-24dc66b9 를 검토) |  |  |  |
| EG-24dc66b9 | H6 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 도시 팝업 City by Country는 Find, OK, Close 순서로 버튼을 둔다. TO-BE는 From/To 검색 버튼과 FROM/TO Country·City 셀 더블클릭에서 모두 같은 공용 RegionModal을 여는데, 이 팝업은 Close, OK 순서로 그린다. AS-IS 순서와도 CR-005 OK → CLOSE 규칙과도 다르다. | GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_CitybyCountry.Designer.cs:143 ; GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_CitybyCoun |  |
| EG-a2cf8306 | A1 | 판정필요 | TOBE룰 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS 조회 SP 는 SCP_MST_DISTRIBUTION_ROUTE 원장을 그대로 읽는다. 차이는 행 수(AS-IS 8,076행, TO-BE 8,079행)와 TO-BE 에만 있는 키 1건뿐이고, 값을 대조한 799칸에서 불일치 컬럼은 0개다. CR-105 에 따라 행·키 집합 차이는 판정에서 빼므로 해당없음으로 둔다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs:424 ; Doc/_legacy_source/DB |  |
| EG-c0692cbc | A1 | 판정필요 | 검토 제외 |  | N | N 중복 정리 구성원(대표 EG-a2cf8306 를 검토) |  |  |  |
| EG-58ec94c4 | N1 | 판정필요 | 데이터차이 | 판정필요 | Y | N 판정 같음 | AS-IS 조회 SP 는 SCM_MST_CITY 에서 From City Name·To City Name 을 읽으며 로직은 키 존재 여부와 상관없이 같습니다. AS-IS 키 89435건 중 TO-BE 에 없는 9건은 AA/AATES, AB/ABTES 처럼 시험용 코드로 보이는 데이터 이관 차이입니다. 이관 대상에서 뺀 것인지 담당자 확인이 필요합니다. | Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP6_DDL.sql:34699 ; Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP6_DDL.sql:34 |  |
