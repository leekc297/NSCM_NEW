# SCP0096 AI 판정 검토 (2026-11-19 16:43:45)

- 대상 38행: 검토 13 · 검토 제외 25 · 미검토 0
- 인용 확인 13행 · 판정 반영 9행 · 엔진 보완 대상 9행 · 룰 등록 후보 0행
- 호출 3회(캐시 0) · 실패 0회 · 비용 0.0000 USD · 출처 Doc/verify/SCP0096/llm_usage.csv

| 행 | 규칙 | 지금 | 분류 | AI 판정 | 인용 | 반영 | 사유 | 근거 | 고칠 곳 |
|---|---|---|---|---|---|---|---|---|---|
| V-2a948121 | A1 | 판정필요 | 데이터차이 | 판정필요 | Y | N 판정 같음 | Division 40, 2026년 조회에서 AS-IS 18행, TO-BE 19행이고 공통 17행의 순서는 일치한다. TO-BE 전용 행은 PLANT_SITE_ID PL01279700_40-P(INFAC_40) 1행이고 CN00254300_40-P 행은 D_20261121, D_20261122 값이 AS-IS Y, TO-BE N 으로 다르다. 공장 마스터 행과 출하일 Y/N 값은 각 DB 의 데이터이므로 CR-101 에 따라 판정필요로 둔다. | Doc/golden/SCP0096/SCP0096_GET_SHIPMENT_WORKING_DAY_OSP.md:4 ; Doc/golden/SCP0096/SCP0096_GET_SHIPMENT_WORKING_DAY_OSP.m |  |
| V-4a2afe1f | F5 | FAIL | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 Insert 버튼과 Delete 버튼이 빈 재정의로 무동작이라 TO-BE 가 두 버튼을 숨긴 것은 처리 대상에 차이가 없고, 삭제 행과 병합 행의 상태 표시는 이 화면에 대상이 없다. 수정 행은 AS-IS 가 M 플래그로 저장하고 TO-BE 도 EditTracker 가 CRUD_TYPE M 을 상태 열에 표시하며 같은 실행의 저장 시험에서 WORKING_TIME_DEFAULT 수정이 저장 요청까지 나갔다. 검사기는 InputNumber 편집기 칸에 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs:274 ; GSCM/06 | Doc/e2e/specs/_trace.spec.ts W4b F5 — setByEditor 뒤 probe.value 로 값 반영을 확인하고 미반영이면 saveprobe typeCell(키보드) 경로로 재시도한 뒤 CRUD_TYPE 을 읽는다. |
| V-eb856b69 | A3 | FAIL | 검사기오판 | NA | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 Designer 에서 chkSum.Visible = false 로 두어 Sum 체크박스가 화면에 보이지 않고, Checked 도 false 라 W_·M_ 합계 컬럼은 항상 숨겨진다. TO-BE 도 showSum 을 false 로 고정해 W_·M_ 컬럼을 숨기므로 동작이 같다. 사용자가 쓸 수 없는 체크박스의 토글 기대를 만든 것이라 대상이 없다. | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.Designer.cs:346  | tools/Harness/verify/gen_expect.py p_sumtoggle 이 chkSum 의 Checked 초기값만 보고 Designer 의 chkSum.Visible = false 를 보지 않아 숨긴 체크박스에 P28 토글 기대를 만든다. |
| V-d8f314e2 | H2 | FAIL | 검토 제외 |  | N | N 선행 결함 종속(선행 행을 검토) |  |  |  |
| V-9a4ab0ac | H11 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS SaveData_Main 은 진행 창 prg.Show 가 주석 처리되고 FoxAsyncProxy 의 ShowProgress 가 false 라 저장 중 로딩 표시가 없으며, 조회 FindData_Main 만 prg.Show 로 진행 창을 띄운다. TO-BE handleSave 도 isPending 재진입 차단만 하고 로딩 표시 없이 저장하므로 저장 중 로딩 없음은 AS-IS 와 같고 조회 중 로딩 38회 관측도 AS-IS 와 같다. 검사기는 AS-IS  | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs:518 ; GSCM/06 | tools/Harness/verify — H11 저장 중 로딩 전용 행은 AS-IS 저장 메서드에 ProgressForm Show 또는 ShowProgress true 가 주석 아닌 코드로 있을 때만 기대하고 없으면 NA 로 둔다. |
| V-b713388c | A6 | 판정필요 | 추출오류 | PASS | Y | Y AS-IS 원문 인용 확인 | 120줄의 ORDER BY SORT_ORDER_NO 는 SELECT @MQRY_SUM = @MQRY_SUM + ... 변수 대입문에 붙어 피벗 일자 컬럼 문자열의 나열 순서를 정하는 것이고 결과 행을 내는 문장이 아니다. 결과 행 순서는 139줄 ORDER BY LAST_INPUT_DATE, DIVISION_ID, PLANT_SITE_ID, MEASURE 이며 TO-BE PKG 키와 같고 실측 순서도 일치한다. 사실 추출본이 변수 대입문의 ORDER BY 를 결 | Doc/asisfacts/db/modules/dbo.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP.sql:112 ; Doc/asisfacts/db/modules/dbo.SCP0096_GET_SHI | tools/Harness/verify/facts_sortrules.py sp_rules 가 모든 줄의 ORDER BY 를 결과 정렬 규칙으로 추출하므로 SELECT @변수 = 대입문(동적 컬럼 목록 생성)의 ORDER BY 는 제외해야 한다. |
| V-a007d973 | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 결과 행 순서는 139줄의 동적 SQL ORDER BY LAST_INPUT_DATE, DIVISION_ID, PLANT_SITE_ID, MEASURE 이고 sort_check.csv 의 139줄 행은 TO-BE 키 순서 동일로 PASS 다. judge.py 가 sort_check 행을 SP 이름과 가드만으로 찾아 같은 SP 의 120줄 FAIL 행을 이 행에도 붙였다. 같은 인자 실측 순서도 일치한다. | Doc/asisfacts/db/modules/dbo.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP.sql:139 ; Doc/asisfacts/db/modules/dbo.SCP0096_GET_SHI | tools/Harness/verify/judge.py 1046줄 sort_check 행 매칭이 sp 와 guard 만 비교해 같은 SP 의 ORDER BY 가 둘이면 첫 행을 두 원장 행에 모두 붙이므로 asis_line 을 매칭 키에 넣어야 한다. |
| V-4ccf9d80 | A7 | 판정필요 | 검토 제외 |  | N | N 사용자가 판정한 행 |  |  |  |
| V-9e29a0e2 | D3 | FAIL | 검토 제외 |  | N | N 선행 결함 종속(선행 행을 검토) |  |  |  |
| V-f95f27ac | J4 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-b26007f0 | N1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-56781cf1 | N1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-d99fa380 | N1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-07d772e7 | N1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-e8aeb458 | N1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-6ff00758 | N1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-48b7999b | N1 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| V-0d52121b | G4 | FAIL | 검토 제외 |  | N | N 스냅샷 승인 대기(snap_validate·snap_approve 경로) |  |  |  |
| T-3168aa6e | D3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-8cdb4616 | X-REASON | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 405줄 부근의 LockColumn 은 제목 시트 잠금이 아니고 SetLockSumColumn 이 Edit 버튼 뒤에 태그 W_·M_ 합계 컬럼을 편집 잠금하는 코드다. TO-BE 는 W_·M_ SUM 열을 SEARCH_ONLY 로 선언하고 isEditableBinding 이 D_ 열과 WORKING_TIME_DEFAULT 만 편집 허용하며 beginningEdit 에서 그 외 칸의 편집을 취소하므로 합계 칸 잠금 동작이 같다. 대조표 D00-3-02 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs:294 ; GSCM/06 | nscm-fe/features/supply/src/pages/shipment-working-day-osp/__asis-mapping__.md:67 행을 'SetLockSumColumn W_·M_ 합계 칸 잠금 · 구현 위치 ShipmentWorkingDayOspGrid.tsx:212·2 |
| T-428f2fa6 | X-REASON | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 더블클릭 접기는 태그 M_ 이고 헤더 문구가 SUM 인 컬럼 헤더에서만 동작하는데, SCP0096 은 Sum 체크박스가 Visible=false 이고 조회 후 SetSpreadColumn 이 W_·M_ 컬럼을 chkSum.Checked(초기값 N)로 숨기므로 사용자가 더블클릭할 SUM 헤더가 화면에 나오지 않는다. TO-BE 도 W_·M_ SUM 열을 항상 숨기므로 더블클릭 결과는 AS-IS 와 TO-BE 모두 없다. 대조표 사유의 '전 화면 pivo | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs:249 ; GSCM/06 | nscm-fe/features/supply/src/pages/shipment-working-day-osp/__asis-mapping__.md:46·79 사유를 'chkSum Visible=false(Designer.cs:346)·조회 후 SetSpreadColumn(cs:355·484) |
| T-cf17d66b | D3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-5618d74a | D3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-a8c0dab9 | F5 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | AS-IS 는 Insert 버튼과 Delete 버튼이 빈 재정의로 무동작이고 수정 행만 M 플래그로 저장 대상이 되며, TO-BE 는 EditTracker 가 변경 셀을 기록하면 CRUD_TYPE M 을 상태 열에 표시한다. 같은 실행의 저장 시험에서는 키보드 입력으로 WORKING_TIME_DEFAULT 2행을 7 에서 6 으로 고쳐 저장 요청이 나갔으므로 수정 표시 경로는 동작한다. 검사기 W4b 는 InputNumber 편집기 칸에 ed.value 로 값을 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs:274 ; GSCM/06 | Doc/e2e/specs/_trace.spec.ts W4b F5 — setByEditor 뒤 probe.value 로 값 반영을 확인하고 미반영이면 saveprobe typeCell(키보드) 경로로 재시도한 뒤 CRUD_TYPE 을 읽는다. |
| T-41297850 | D3 | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-64d83c17 | X-ROW | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-7312ac1d | X-ROW | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-bea62187 | X-ROW | 판정필요 | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| T-03dcfd08 | X-ROW | FAIL | 검토 제외 |  | N | N 집계·상속 행(하위 행을 검토) |  |  |  |
| EG-807044ce | J1 | FAIL | 검토 제외 |  | N | N 사용자가 판정한 행 |  |  |  |
| EG-ad36724d | J1 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 는 Division 콤보를 DataSource 바인딩으로 채워 첫 후보가 선택된 상태로 열리고 화면 로드 때 그 선택값으로 조회 기간까지 계산하므로, 후보가 40 하나인 SCM Viewer 계정은 40 이 자동 선택된다. TO-BE 는 Division 기본값을 81 로 고정해 81 권한이 없는 계정은 Division 이 빈값으로 표시되고 수동 선택이 필요하다. 같은 원인의 EG-807044ce 를 사용자가 11-18 에 FAIL 로 확정했고 빈 기본값 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs:130 ; GSCM/01 |  |
| EG-c63a0d42 | J1 | FAIL | 실결함 | FAIL | Y | N 판정 같음 | AS-IS 는 Division 콤보를 DataSource 바인딩으로 채워 첫 후보가 선택된 상태로 열리고 화면 로드 때 그 선택값으로 조회 기간까지 계산하므로, 후보가 82 하나인 SCM Viewer 계정은 82 가 자동 선택된다. TO-BE 는 Division 기본값을 81 로 고정해 81 권한이 없는 계정은 Division 이 빈값으로 표시되고 수동 선택이 필요하다. 같은 원인의 EG-807044ce 를 사용자가 11-18 에 FAIL 로 확정했고 빈 기본값 | GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0096_Shipment_Working_Day_OSP/SCP0096_Shipment_Working_Day_OSP.cs:130 ; GSCM/01 |  |
| EG-a24f3b24 | J4 | FAIL | 검토 제외 |  | N | N 시험 계정 필요(사람) |  |  |  |
| EG-e0881be0 | A1 | 판정필요 | 데이터차이 | 판정필요 | Y | N 판정 같음 | Division 81 조회에서 AS-IS 1행, TO-BE 2행이며 TO-BE 추가 행은 PLANT_SITE_ID AU000062_81-P, PLANT_SITE_NAME TEST 인 값 없는 행이다. 조회 행은 SCM_MST_SITE 의 OSP_YN=Y 공장 마스터에서 나오므로 TO-BE DB 에만 있는 테스트 사이트 데이터 차이다. 검사기가 D_ 일자 값 컬럼까지 키로 써서 AS-IS 1행도 전용으로 셌으나 건수 차이 자체는 데이터 차이라 CR-101 에 따라 | Doc/verify/SCP0096/a1_live.csv ; Doc/asisfacts/db/modules/dbo.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP.sql:54 ; Doc/asisfact |  |
| EG-d965ca33 | A6 | 판정필요 | 검사기오판 | PASS | Y | Y AS-IS 원문 인용 확인 | sort_check.py 가 TO-BE ORDER BY 원문을 300자로 잘라 저장했고 그 문장이 PLANT_SITE_ID 의 NLSSORT 괄호 앞에서 끊겨 sort_ci_check 가 대소문자 무시와 NULLS FIRST 가 없다고 읽었다. LAST_INPUT_DATE 는 AS-IS 에서 MAX(YYYYMMDD) 숫자 문자열이라 대소문자 구분이 생길 수 없고 TO-BE 에는 NULLS FIRST 가 있다. TO-BE 정렬 키 4개는 AS-IS 139줄과 같고 | Doc/asisfacts/db/modules/dbo.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP.sql:139 ; Doc/asisfacts/db/modules/dbo.SCP0096_GET_SHI | tools/Harness/verify/sort_check.py 302줄이 tobe_order_by 를 300자로 잘라 쓰고 tools/Harness/verify/sort_ci_check.py 가 그 잘린 문장으로 키별 대소문자·NULL 판정을 한다. |
| EG-cac7a1b1 | N1 | FAIL | 검토 제외 |  | N | N 사용자가 판정한 행 |  |  |  |
| EG-85b47891 | N1 | FAIL | 검토 제외 |  | N | N 사용자가 판정한 행 |  |  |  |
| EG-a184f82b | N1 | FAIL | 검토 제외 |  | N | N 사용자가 판정한 행 |  |  |  |
