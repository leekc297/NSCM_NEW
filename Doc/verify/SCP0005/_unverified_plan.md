# SCP0005 미검증 행별 조치 표 · 라운드 1 · 2026-11-20 08:5x

- 입력: unverified_triage.csv(08:24:15), 원장 verify_ledger.csv(08:12:16, CheckList 07:35). 처리 대상 257행(엔진 153, 판단 103, 사람 1), 집계 95행은 하위 행을 따라감
- 표 행 수 257 = 처리 대상 257. 생성 스크립트 _unverified_plan_gen.py
- 대조: 표에 넣은 행 257, 빠진 행 0, 두 묶음에 겹친 행 0

## 이번 라운드에 고친 묶음

| 묶음 | 행 수 | 원인(실측) | 고친 곳 | 다음 CheckList 판정(미측정) |
|---|---|---|---|---|
| A 컬럼 메타 미조회 시트 route 중복 행(T451) | 50 | TO-BE 메타 SCP0005 시트 3개(Distribution Route 39, route 33, POPUP 16 · Doc/tobefacts/db/sheet_columns.csv). 화면은 컬럼 메타를 'Distribution Route' 로만 조회(useDistributionRouteStore.ts:113~117, distribution-route.constants.ts:12~26). 화면 사실 dts_sheets 빈 값이라 ledger.py 가 세 시트 모두 행을 만들었고 'route' 는 AS-IS 시트(grid_columns_asis)에 없어 'AS-IS 편집 기대 없음' 판정필요 | tools/E2E/lib/nscm.ts recordMetaSheets(/admin/menu/<ID>/column 본문 sheetNm → Doc/verify/<ID>/meta_sheets.json) · tools/Harness/verify/ledger.py 기록에 없고 AS-IS 시트에도 없는 시트 제외 | 첫 CheckList 에서 meta_sheets.json 생성, 그 다음 CheckList 원장부터 route 시트 행 생성 안 함(단위 시험: 기록 [Distribution Route] → route 제외, POPUP 유지) |
| B 셀 규칙 시트 축(T450) | 5 | facts_cellrules.py 가 컬럼 단위로 규칙을 모아 마지막 메타 행(POPUP)의 시트를 남김. SetReNumerCellType(cs:251~255)은 `if (spreadInfo.SheetName == SpdSheet.shtMain)`(cs:243, shtMain = 'Distribution Route' cs:78) 안인데 시트를 바꾸지 않았음 | tools/Harness/verify/facts_cellrules.py guard_sheets(감싼 SheetName 블록 상수 → 그 파일 SpdSheet 값) · Doc/asisfacts/screens/SCP0005/cell_rules.csv 재생성(LT 5칸 POPUP → Distribution Route) | 사실 검토(llm_facts) 다시 만들 때 5행 사라짐 · E1 숫자 칸 기대가 Distribution Route 시트에 붙음 |
| C 저장 왕복 행 식별(T452) | 4 | V-4e4af2a4 증거 'FROM_COUNTRY r359 CN→KR 재조회 (판독 안 함) · 재조회 행 식별 0건'. probe.rowIdentity 가 숫자 칸(ROUTE_ID)을 빼고 문자 칸만 대조해 업무 키(FROM_COUNTRY)를 바꾼 행을 잃음. 뒤 시험 3행은 '[측정 중단] 앞 단계 행 식별 실패'. DB 확인(사내 오라클 08:41): ROUTE_ID 7305 FROM_COUNTRY 'CN'·LAST_UPDATED_BY yangwon_kim 2021-02-24(복원됨) | tools/E2E/lib/saveprobe.ts uniqueIdKey·rowsById(편집 전 값이 유일한 ID 칸으로 보조 식별) | 실측(통과 또는 오류). ID 칸도 겹치면 종전처럼 식별 실패 사유 |
| D 이력 팝업 미열림 판정 문구(T454) | 1 | AS-IS ROUTE_ID 더블클릭 → SCP0005_DistributionRoutePopup(cs:1093~1103, 팝업 SP SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID). TO-BE 그리드 더블클릭 처리는 FROM·TO 도시 칸만(DistributionRouteGrid.tsx:188~200). _trace.spec 이 '열림 감지 실패' FAIL 을 남기고 judge RX_TOOLFAIL 이 검사기 미검증으로 내림 | Doc/e2e/specs/_trace.spec.ts M3: 10초 동안 대화상자 0 · 서버 호출 0 · 편집기 없음이면 '팝업 열리지 않음' 실측 FAIL | FAIL(화면 기능 누락 · FE 가이드 G1) |
| E 화면 조회조건 검색 단추 팝업(T453) | 8 | _trace.spec W4d 분기(ROUTE_ID 더블클릭 → Distribution Route 선택 팝업 prefill, SCP0007 용)가 팝업이 안 열리면 txt* 조건 행 전부를 미검증으로 적음. SCP0005 txtFromCountry 등은 화면 자체 조회조건(cs:358~369 btnFromSrch·btnToSrch → SCM0002_CitybyCountry). TO-BE 조건 칸 돋보기 단추(DistributionRouteForm.tsx:82~87, 123~127) | Doc/e2e/specs/_trace.spec.ts condPopup(조건 칸 검색 단추 → 팝업 → 첫 행 → 확인 → 조건 값 · 원복) | G4 4행 = 팝업 열림 실측 · M4 4행 = 선택값 반영 실측(통과 또는 오류) |
| F Division 조건 없는 화면 J1(T455) | 2 | 증거 'Division 40 선택 못 함 · set=false rows=8036'. AS-IS controls.csv 컨트롤 이름에 Div 0건(SCP0005 Designer 조회조건 = From/To Country·City, Trans Mode, Valid) | tools/Harness/verify/e2e_suite_ingest.py no_div(AS-IS 컨트롤에 Division 0건 + TO-BE 선택 실패 → NA 근거 기록) | NA(Division 별 조회 대상 아님 · 근거 controls.csv) |
| G 팝업 보조 입력 칸 FPTextBox(T456) | 4 | ledger.py T114 분기가 CELL=- 만 일반 텍스트 셀로 봐 FROM_COUNTRY·FROM_CITY(CELL=FPTextBox)에 '직접 편집 차단' 기대를 만듦. 프레임워크는 CELL 빈 값을 FPTextBox 로 정함(SpreadInfo.cs:1387~1389) · AS-IS InsertRow 잠금 칸에 두 칸 없음(cs:950~954) | tools/Harness/verify/ledger.py _plain 에 FPTextBox 포함 | D1 기대 '팝업 보조 입력(직접 입력 허용 + 더블클릭 팝업)' → 실측 편집=true 면 PASS |
| H 미분류 유형 등록(분류표) | 15 | 증거 문구가 분류표 정규식에 없었음: '[검증엔진 무판정]', '실제 AS-IS 조회 SP 원문 없음()', '실제 AS-IS 원문을 찾지 못함', '[전제 미충족 T300]', '버튼 [..] 비노출', '미포함 항목은 수동 검수 대상' | tools/Harness/verify/unverified_classes.csv 71·73·52 행(검사기공백·데이터전제). 측정 경로 보완은 하지 않음(U 묶음과 같이 다음 라운드) | 판정 그대로(미검증) · 담당 엔진으로 분류 |

## 결정 목록으로 보낸 묶음

| 묶음 | 행 수 | 근거 | 정할 내용 |
|---|---|---|---|
| D1 ROUTE_ID 이력 팝업 미구현(선행 결함) | 44 | AS-IS ROUTE_ID 더블클릭 → 이력 팝업(SCP0005_DistributionRoutePopup.cs:36 시트 'POPUP', :171 SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID). TO-BE 화면에 팝업 없음(대조표 R8 'AS-IS 에 해당 기능 부재 확인(2026-09-27)' 은 원문과 다름). TO-BE DB 는 준비됨(SCM_ADM_MNU_BTN_MPG_M SCP0005/history/SEARCH → P_SCP0005_GET_HIST, PKG_SCP0005.P_SCP0005_GET_ROUTE_HIST · 08:51 조회) | FE 가이드 G1 반영 여부(팝업 구현 · 대조표 R8 정정). 반영 전까지 팝업 그리드 칸 33행(POPUP 시트 D1 32, E1 1)과 팝업 SP 행은 측정 경로 없음 |
| D2 다른 화면에서 ROUTE_ID 를 넘겨 여는 진입 시나리오 | 6 | AS-IS 는 다른 화면이 ROUTE_ID 를 넘겨 열 때만 SCP0005_GET_DISTRIBUTION_ROUTEID 를 부름(AI 검토 근거 cs:499~501). TO-BE 연결 SCP0005/route/SEARCH_ROUTEID → P_SCP0005_GET_ROUTEID(08:51 조회). 검사기에 화면 간 진입 시나리오와 골든 케이스(golden_cases.csv) 없음 | 진입 시나리오(어느 화면에서 어떤 값으로 여는지)를 검사기에 넣을지, 수동 확인으로 둘지 |
| D3 후보 밖 값 행이 데이터에 없음(F3 복사 붙여넣기) | 9 | 증거 '이 행 후보 1건(TRANSPORT_MODE 4건) 밖 값을 가진 기존 행 없음'(Div 40 조회 8036행) | 권장안 NA(조건 데이터 부재). 승인하면 데이터 부재 판정 경로에 넣음. 아니면 시험 데이터 준비 |
| D4 저장 시험 흔적 ROUTE_ID 9917 | 0 | 사내 오라클 08:41 조회: ROUTE_ID 9917 LAST_UPDATED_BY minyonglee1 · 2026-11-19 21:26:21(CREATED_BY ohsun 2024-01-22). 11-19 저녁 CheckList 저장 시험이 감사 칸을 남긴 것으로 보임(값 원복 여부 미확인) | 감사 칸 원복 여부 확인 · 원래 값을 아는 기록이 있으면 복원 |
| D5 AI 검토 TO-BE 룰 후보 | 2 | EG-b7b794bd: 공용 RegionModal(제목 Region Popup)로 SCM0002_CitybyCountry 대체(DistributionRoute.tsx:315). V-6e159871: 공통 컬럼 5개 ''↔'/' 차이(a_port_name 8행, shipping_company 334행 등) = NOT NULL 빈 값 '/' 룰(메모리 2026-11-13) 해당 여부 | 두 건을 전 화면 TO-BE 룰로 등록할지(등록 번호 · 판정 경로) |
| D6 판단 행(룰 근거 미확인) | 18 | B4 2행 = AS-IS 셀 콤보 후보 0건 추출(메타 ATTRIBUTE1 → Param1 미반영 · AI 검토). C3 5행 = 원천 칸 팝업 셀·LT 입력 실패. C6 3행 = 시작 값 0 이 되돌림 값 0 과 같아 대조군 없음. DAYS 2행 = 머리글 묶음. E6 = 첫 타건 IME. H6 2행 · I2 2행 · MS1 1행 = 판정필요 | 행별 근거 확인 뒤 판정 경로 보완(다음 라운드) 또는 사람 판정 |
| D7 스냅샷 승인 | 1 | 스냅샷 '버튼 Div 40' 재실측 승인 대기. snap_validate.py(08:5x) MISMATCH: AS-IS 기대 대비 누락 UPLOAD_SAVE, UPLOAD, SEARCH_ROUTEID, SEARCH_CITY(서버 연결 이름 · 화면 단추 아님 확인 필요). 자동 승인 대상 아님(MISMATCH 제외 규칙) | MISMATCH 4건이 화면 단추 누락인지 서버 연결 이름 차이인지 확인 뒤 snap_approve 승인 여부(사람) |

## 이번 라운드 미보완 88행(엔진 확장 필요 · 다음 라운드)

- 원인은 행 증거와 AI 검토 처리 방법 칸 기준. 이번 라운드에 원문을 다시 확인하지 않은 행은 처리 방법 칸에 미확인으로 적음

## 행별 조치

| 행 ID | 규칙 | 유형 | 묶음 | 조치 |
|---|---|---|---|---|
| V-f069cc0b | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-b6684398 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-e3a95ba8 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-a8e42f1b | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-d13d9d93 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-d63c8c9a | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-efd885dd | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-a2b3892f | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-5f21d590 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-91d8baf9 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-37e29a8f | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-71c59c4c | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-f949ef0c | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-69c86016 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-d2820cb9 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-9a6fcce6 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-1bc44512 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-0ca2a4ea | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-d250eb92 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-c9b880e6 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-c58f5984 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-f0ce28a6 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-db291d83 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-7846248d | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-6ff4fa6b | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-a60ebda3 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-613909ff | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-b40b2f86 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-5f5baa0d | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-6d214120 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-71f0bdf9 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-e2555e29 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-99320598 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-1619a565 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-33771477 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-8c7cbe73 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-696d0104 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-c933e6e0 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-33598a73 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-f735840b | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-c2c1137d | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-78d583dc | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-dacaefd0 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-ddf83f9d | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-b7d4d9af | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-d3fc1ec0 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-d72694b1 | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-ef2c44ae | D1 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-0267c456 | E1 | 검사기공백 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| V-afc23080 | B4 | 판단 | A | A 컬럼 메타 미조회 시트 route 중복 행(T451) |
| FACT-4087be3b |  | AI검토:추출오류 | B | B 셀 규칙 시트 축(T450) |
| FACT-54671821 |  | AI검토:추출오류 | B | B 셀 규칙 시트 축(T450) |
| FACT-a5b873a6 |  | AI검토:추출오류 | B | B 셀 규칙 시트 축(T450) |
| FACT-e47ec2b2 |  | AI검토:추출오류 | B | B 셀 규칙 시트 축(T450) |
| FACT-f5874cc4 |  | AI검토:추출오류 | B | B 셀 규칙 시트 축(T450) |
| V-4e4af2a4 | F1 | 미분류 | C | C 저장 왕복 행 식별(T452) |
| V-26d2974c | F1 | 미분류 | C | C 저장 왕복 행 식별(T452) |
| V-7116d2aa | F6 | 미분류 | C | C 저장 왕복 행 식별(T452) |
| V-72fbb5b2 | F6 | 미분류 | C | C 저장 왕복 행 식별(T452) |
| T-6d14c72c | M3 | 검사기공백 | D | D 이력 팝업 미열림 판정 문구(T454) |
| T-9b463365 | G4 | 미분류 | E | E 화면 조회조건 검색 단추 팝업(T453) |
| T-88891164 | G4 | 미분류 | E | E 화면 조회조건 검색 단추 팝업(T453) |
| T-6d65f303 | G4 | 미분류 | E | E 화면 조회조건 검색 단추 팝업(T453) |
| T-90d2d30f | G4 | 미분류 | E | E 화면 조회조건 검색 단추 팝업(T453) |
| T-3d44d32d | M4 | 미분류 | E | E 화면 조회조건 검색 단추 팝업(T453) |
| T-47ab9353 | M4 | 미분류 | E | E 화면 조회조건 검색 단추 팝업(T453) |
| T-ef2618be | M4 | 미분류 | E | E 화면 조회조건 검색 단추 팝업(T453) |
| T-26aaaaf4 | M4 | 미분류 | E | E 화면 조회조건 검색 단추 팝업(T453) |
| ES-0967e6d0 | J1 | 데이터전제 | F | F Division 조건 없는 화면 J1(T455) |
| ES-fe8e48bc | J1 | 데이터전제 | F | F Division 조건 없는 화면 J1(T455) |
| V-5b44fefc | D1 | AI검토:검사기오판 | G | G 팝업 보조 입력 칸 FPTextBox(T456) |
| V-9a1db2df | D1 | AI검토:검사기오판 | G | G 팝업 보조 입력 칸 FPTextBox(T456) |
| V-1ff8658b | D1 | AI검토:검사기오판 | G | G 팝업 보조 입력 칸 FPTextBox(T456) |
| V-599dd774 | D1 | AI검토:검사기오판 | G | G 팝업 보조 입력 칸 FPTextBox(T456) |
| V-28e296d5 | A4 | 미분류 | H | H 미분류 유형 등록(분류표) |
| EG-d5dc785f | B3 | 미분류 | H | H 미분류 유형 등록(분류표) |
| EG-e6babac5 | B3 | 미분류 | H | H 미분류 유형 등록(분류표) |
| EG-334fdc63 | B3 | 미분류 | H | H 미분류 유형 등록(분류표) |
| T-b82f895f | C3 | 미분류 | H | H 미분류 유형 등록(분류표) |
| T-5edb7122 | C3 | 미분류 | H | H 미분류 유형 등록(분류표) |
| T-38e03b62 | C3 | 미분류 | H | H 미분류 유형 등록(분류표) |
| T-653f2a16 | C3 | 미분류 | H | H 미분류 유형 등록(분류표) |
| EG-4cbe8d28 | G4 | 미분류 | H | H 미분류 유형 등록(분류표) |
| EG-df9c2d26 | G4 | 미분류 | H | H 미분류 유형 등록(분류표) |
| EG-a875887e | G4 | 미분류 | H | H 미분류 유형 등록(분류표) |
| V-8fd091cc | K3 | 미분류 | H | H 미분류 유형 등록(분류표) |
| EG-6a0f18bc | M3 | 미분류 | H | H 미분류 유형 등록(분류표) |
| EG-f670f773 | M3 | 미분류 | H | H 미분류 유형 등록(분류표) |
| EG-75f112d6 | M3 | 미분류 | H | H 미분류 유형 등록(분류표) |
| V-e8602478 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-c09178ce | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-71fb5be1 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-2144e9aa | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-e0967fb3 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-5288a224 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-f7aad894 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-74666abe | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-4692bd5f | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-ba067d18 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-d2825947 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-e4428757 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-7fdb371b | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-1f11c130 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-d561dda3 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-ccf7a91d | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-7778ce8c | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-2b51dd40 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-791b1969 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-16de807e | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-2ad82300 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-9fef8850 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-8b7e1398 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-222e2ec8 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-5d1de751 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-77654a3a | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-c7abf566 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-df790ade | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-0c943a4c | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-44e401f8 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-1afc1aeb | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-ae463842 | D1 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-a882d140 | E1 | 검사기공백 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| T-336fa068 | A6 | 검사기공백 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-f574c4a3 | A6 | 검사기공백 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| T-ea530cd5 | F4 | 검사기공백 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| T-74b664fb | DB-SYN | 검사기공백 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| T-c65db01b | A1 | AI검토:검사기오판 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-a46588cb | M3 | 검사기공백 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-0e9099ba | H6 | 검사기공백 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| V-4cfc72f5 | H6 | 검사기공백 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| EG-9c573043 | D5 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| EG-4041a815 | D5 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| T-fce350f2 | M4 | 판단 | D1 | 결정 목록 D1 ROUTE_ID 이력 팝업 미구현(선행 결함) |
| T-2f7778bd | A6 | 검사기공백 | D2 | 결정 목록 D2 다른 화면에서 ROUTE_ID 를 넘겨 여는 진입 시나리오 |
| V-fc7cfdc8 | A6 | 검사기공백 | D2 | 결정 목록 D2 다른 화면에서 ROUTE_ID 를 넘겨 여는 진입 시나리오 |
| V-4d5799f3 | A7 | 검사기공백 | D2 | 결정 목록 D2 다른 화면에서 ROUTE_ID 를 넘겨 여는 진입 시나리오 |
| T-719d403c | F4 | 검사기공백 | D2 | 결정 목록 D2 다른 화면에서 ROUTE_ID 를 넘겨 여는 진입 시나리오 |
| T-9374e9e4 | DB-SYN | 검사기공백 | D2 | 결정 목록 D2 다른 화면에서 ROUTE_ID 를 넘겨 여는 진입 시나리오 |
| T-94b3ad3d | A1 | AI검토:검사기오판 | D2 | 결정 목록 D2 다른 화면에서 ROUTE_ID 를 넘겨 여는 진입 시나리오 |
| V-3d0ea655 | F3 | 검사기공백 | D3 | 결정 목록 D3 후보 밖 값 행이 데이터에 없음(F3 복사 붙여넣기) |
| V-5804ccc8 | F3 | 검사기공백 | D3 | 결정 목록 D3 후보 밖 값 행이 데이터에 없음(F3 복사 붙여넣기) |
| V-5a4e9648 | F3 | 검사기공백 | D3 | 결정 목록 D3 후보 밖 값 행이 데이터에 없음(F3 복사 붙여넣기) |
| V-6f2db8d3 | F3 | 검사기공백 | D3 | 결정 목록 D3 후보 밖 값 행이 데이터에 없음(F3 복사 붙여넣기) |
| V-753a87af | F3 | 검사기공백 | D3 | 결정 목록 D3 후보 밖 값 행이 데이터에 없음(F3 복사 붙여넣기) |
| V-7ac42873 | F3 | 검사기공백 | D3 | 결정 목록 D3 후보 밖 값 행이 데이터에 없음(F3 복사 붙여넣기) |
| V-ba8f9817 | F3 | 검사기공백 | D3 | 결정 목록 D3 후보 밖 값 행이 데이터에 없음(F3 복사 붙여넣기) |
| V-cb7ed54f | F3 | 검사기공백 | D3 | 결정 목록 D3 후보 밖 값 행이 데이터에 없음(F3 복사 붙여넣기) |
| V-d8ff8497 | F3 | 검사기공백 | D3 | 결정 목록 D3 후보 밖 값 행이 데이터에 없음(F3 복사 붙여넣기) |
| EG-b7b794bd | D5 | AI검토:룰등록 | D5 | 결정 목록 D5 AI 검토 TO-BE 룰 후보 |
| V-6e159871 | A7 | 판단 | D5 | 결정 목록 D5 AI 검토 TO-BE 룰 후보 |
| V-5bcb735c | B4 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| V-82d97d20 | B4 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| T-1d878a60 | C3 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| T-0803d2d0 | C3 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| V-03851efe | C3 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| V-63a7bd27 | C3 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| V-eab82e73 | C3 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| V-4ce029f5 | C6 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| V-4ad20009 | C6 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| V-3fa9771e | C6 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| T-24a1a8c9 | E3 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| V-18c565cc | E6 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| T-d786155a | H5 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| T-fd52bd41 | H6 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| T-50c6a15b | H6 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| EG-2037a747 | I2 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| EG-60363cec | I2 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| V-e458f301 | MS1 | 판단 | D6 | 결정 목록 D6 판단 행(룰 근거 미확인) |
| V-5daefe3f | K4 | 스냅샷승인 | D7 | 결정 목록 D7 스냅샷 승인 |
| V-5a7b8946 | I3 | 검사기공백 | U | 미보완: [측정 코드 없음] 언어 전환 비교 미구현 — 명칭 컬럼 FROM_CITY_NAME,D_PORT_NAME,A_PORT_NAME,TO_CITY_NAME 표본 50건 중 한글 0(참고값 · 판정 근거 아님, 종전엔 무조건 PASS 였음 2026-10-31) |
| V-1f03b82a | C1 | 검사기공백 | U | 미보완: [측정 경로 없음] [자동] LT_TYPE 셀 콤보 후보 = 서버 콤보 LookupCommon: 서버 콤보 LookupCommon 응답 없음(수집 48건) · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:8036행·신규0 |
| V-2e931168 | C1 | 검사기공백 | U | 미보완: [측정 경로 없음] [자동] TRANSPORT_MODE 셀 콤보 후보 = 서버 콤보 LookupCommon: 서버 콤보 LookupCommon 응답 없음(수집 72건) · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:80 |
| V-b3450ff5 | E4 | 검사기공백 | U | 미보완: 기존 행 값을 신규 행 39칸에 그대로 입력(메타 필수 컬럼 없음 · 동적 기간 칸 제외) → Save(서버 미전송) · [입력 경로 실패] SHIP_DOC_PREPARATION_DATE,One_SEGMENT_COST,Two_SEGMENT_COST,Three_SEGME |
| V-0bbe47b0 | E1 | 검사기공백 | U | 미보완:  / [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) / [미검증] 검사기(_verify.spec(@verify) · _t |
| V-aa0e05de | E1 | 검사기공백 | U | 미보완:  / [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) / [미검증] 검사기(_verify.spec(@verify) · _t |
| V-1695d2c6 | E1 | 검사기공백 | U | 미보완:  / [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) / [미검증] 검사기(_verify.spec(@verify) · _t |
| V-caa77d38 | E1 | 검사기공백 | U | 미보완:  / [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) / [미검증] 검사기(_verify.spec(@verify) · _t |
| V-c56bdc72 | H2 | 검사기공백 | U | 미보완: [측정 경로 없음] 조건 만족 행에 값 있는 기간 칸 없음 · AS-IS SCP0005_DistributionRoute:1276 SetBGColor 편집 모드 색 UnLockColor(조회 모드 UnLockColor) · 조건 TRUE · 계정 minyonglee1(그 |
| V-0810a59e | H2 | 검사기공백 | U | 미보완: [측정 경로 없음] 조건 만족 행에 값 있는 기간 칸 없음 · AS-IS SCP0005_DistributionRoute:1278 SetBGColor 편집 모드 색 UnLockColor(조회 모드 UnLockColor) · 조건 TRUE · 계정 minyonglee1(그 |
| V-c099fa4f | H2 | 검사기공백 | U | 미보완: [측정 경로 없음] 조건 만족 행에 값 있는 기간 칸 없음 · AS-IS SCP0005_DistributionRoute:1279 SetBGColor 편집 모드 색 UnLockColor(조회 모드 UnLockColor) · 조건 TRUE · 계정 minyonglee1(그 |
| V-b4651880 | H2 | 검사기공백 | U | 미보완: [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 8036행 중 조건 만족 0행 · 평가 불가 8036행 — |
| V-17e451a7 | H2 | 검사기공백 | U | 미보완: [측정 경로 없음] 조건 FALSE 을 만족하는 계정·Division 조합 없음(계정 minyonglee1/jooyong026/dana.robot · Division 후보 40) |
| V-e63ff383 | H2 | 검사기공백 | U | 미보완: [측정 경로 없음] 조건 FALSE 을 만족하는 계정·Division 조합 없음(계정 minyonglee1/jooyong026/dana.robot · Division 후보 40) |
| V-b6f27092 | H2 | 검사기공백 | U | 미보완: [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 8036행 중 조건 만족 0행 · 평가 불가 8036행 — |
| V-bc631885 | H2 | 검사기공백 | U | 미보완: [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 8036행 중 조건 만족 0행 · 평가 불가 8036행 — |
| V-06e7dec2 | H2 | 검사기공백 | U | 미보완: [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 8036행 중 조건 만족 0행 · 평가 불가 8036행 — |
| V-fa71e89c | H2 | 검사기공백 | U | 미보완: [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 8036행 중 조건 만족 0행 · 평가 불가 8036행 — |
| V-dc54eed4 | H2 | 검사기공백 | U | 미보완: [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 8036행 중 조건 만족 0행 · 평가 불가 8036행 — |
| V-a6bb7234 | G5 | 검사기공백 | U | 미보완:  / [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) / [미검증] 검사기(popup_args_check.py · _verify.spec(@verif |
| V-e14533b1 | H6 | 검사기공백 | U | 미보완:  / [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) / [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — |
| V-4a0b6271 | E4 | 검사기공백 | U | 미보완: MSG00265 — btnEaxel_Upload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btnEaxel_Upload_Click)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |
| V-718e1a16 | H6 | 검사기공백 | U | 미보완:  / [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) / [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — |
| V-616b4d31 | H6 | 검사기공백 | U | 미보완:  / [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) / [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — |
| V-3e95d2be | E4 | 검사기공백 | U | 미보완: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(spdMainDataModel_Changed)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |
| V-ecd963f8 | J4 | 검사기공백 | U | 미보완: 그룹별 메뉴·버튼 권한 대조 2026-11-20 07:35:42: PARTIAL — 그룹 15↔15 · ADMIN U→EDIT: TO-BE 메뉴에 EDIT 버튼 정의 없음; SCM PI Admin U→EDIT: TO-BE 메뉴에 EDIT 버튼 정의 없음; SSP Pla |
| V-57e814bb | M1 | 검사기공백 | U | 미보완: [측정 코드 없음] Excel Upload 버튼 있음 [KOR / 이 이민용 / Home / Distribution Route / Scroll tabs left / Scroll tabs right / Close others / Close All / Full screen |
| V-98e969ba | M1 | 검사기공백 | U | 미보완: [측정 코드 없음] Excel Upload 버튼 있음 [KOR / 이 이민용 / Home / Distribution Route / Scroll tabs left / Scroll tabs right / Close others / Close All / Full screen |
| V-219edc76 | M1 | 검사기공백 | U | 미보완: [측정 코드 없음] Excel Upload 버튼 있음 [KOR / 이 이민용 / Home / Distribution Route / Scroll tabs left / Scroll tabs right / Close others / Close All / Full screen |
| V-a32c8abf | M1 | 검사기공백 | U | 미보완: [측정 코드 없음] Excel Upload 버튼 있음 [KOR / 이 이민용 / Home / Distribution Route / Scroll tabs left / Scroll tabs right / Close others / Close All / Full screen |
| T-85f3a8bb | G4 | 검사기공백 | U | 미보완: [측정 경로 없음] AS-IS btnFromSrch 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인) |
| T-cdb32d07 | H6 | 검사기공백 | U | 미보완: 실측[T-cdb32d07]: 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke / [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작 |
| T-7e1a41bb | G4 | 검사기공백 | U | 미보완: [측정 경로 없음] AS-IS btnToSrch 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인) |
| T-117d4f08 | H6 | 검사기공백 | U | 미보완: 실측[T-117d4f08]: 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke / [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작 |
| T-6e75e40a | C2 | 검사기공백 | U | 미보완: PRIORITY 연쇄 원천 해석 불가 — AS-IS — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trac |
| T-6e2ef7c8 | C6 | 검사기공백 | U | 미보완: PRIORITY 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5)가  |
| T-aa4e2eb2 | A5 | 검사기공백 | U | 미보완: DAYS: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |
| T-c7a43f16 | C2 | 검사기공백 | U | 미보완: DAYS 연쇄 원천 해석 불가 — AS-IS — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W |
| T-4dd85db6 | C3 | 검사기공백 | U | 미보완: DAYS 연쇄 원천 컬럼 해석 불가 — AS-IS → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |
| T-dc040561 | C6 | 검사기공백 | U | 미보완: DAYS 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5)가 이 대상 |
| T-eb5343b6 | G4 | 검사기공백 | U | 미보완: [측정 경로 없음] AS-IS btnEaxel 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인) |
| T-8b3ad504 | C3 | 검사기공백 | U | 미보완: VALID_YN 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRow:947 siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VALID_YN), "Y") [if (fps.Name == |
| T-e3d3d7ca | DB-SYN | 검사기공백 | U | 미보완: 실측[T-e3d3d7ca]: 검사기(syn_check.py·fixture dberr)는 있으나 이 대상(SP)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / [미검증] 검사기(syn_check.py·fixture db |
| T-2c4e7c8a | E4 | 검사기공백 | U | 미보완: MSG00265 — btnEaxel_Upload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btnEaxel_Upload_Click)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |
| T-e19b6757 | E4 | 검사기공백 | U | 미보완: MSG00265 — btnEaxel_Upload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btnEaxel_Upload_Click)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |
| T-dba493fd | E4 | 검사기공백 | U | 미보완: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(spdMainDataModel_Changed)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |
| T-eea49685 | E4 | 검사기공백 | U | 미보완: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(spdMainDataModel_Changed)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |
| T-6a512ae5 | E4 | 검사기공백 | U | 미보완: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(spdMainDataModel_Changed)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |
| T-7eacee67 | H6 | 검사기공백 | U | 미보완: 실측[T-7eacee67]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / [미검증] 검사기(_verify.spec(@v |
| T-e425f595 | H6 | 검사기공백 | U | 미보완: 실측[T-e425f595]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / [미검증] 검사기(_verify.spec(@v |
| T-709cb183 | H6 | 검사기공백 | U | 미보완: 실측[T-709cb183]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / [미검증] 검사기(_verify.spec(@v |
| T-3beee65f | G5 | 검사기공백 | U | 미보완: 실측[T-3beee65f]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / [미검증] 검사기(popup |
| T-a391f109 | G5 | 검사기공백 | U | 미보완: 실측[T-a391f109]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / [미검증] 검사기(popup |
| T-7be01876 | G5 | 검사기공백 | U | 미보완: 실측[T-7be01876]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) / [미검증] 검사기(popup |
| ES-836708a8 | F1 | 재실행 | U | 미보완: [측정 전제 미충족: 실행 예외] 저장 기능 판정 못 함 · mode=insert save=Y insert=Y delete=Y editable=- inserted=Y saved=N found=N updated=N cleaned=Y restored=Y saveCalls= |
| ES-88905017 | F1 | 재실행 | U | 미보완: [측정 전제 미충족: 실행 예외] 저장 기능 판정 못 함 · mode=insert save=Y insert=Y delete=Y editable=- inserted=Y saved=N found=N updated=N cleaned=Y restored=Y saveCalls= |
| V-f648eb06 | J1 | AI검토:검사기오판 | U | 미보완: [FAIL] 검사기는 AS-IS SetDivisionAuthCheck 와 같은 권한 기반 Division 후보를 기대했지만 SCP0005 소스에는 SetDivisionAuthCheck 호출도 Division 콤보도 없습니다. GetDivisionWithoutEE 를 부 |
| V-e32d34a2 | L1 | AI검토:검사기오판 | U | 미보완: [FAIL] AS-IS는 SCP0005_GET_DISTRIBUTION_ROUTE 한 번으로 조회하고, TO-BE의 같은 조회(route/SEARCH, 8037행)는 실측 687ms입니다. 다른 측정도 조회 1507ms, 저장 127ms, 방향키 34ms로 모두 기준 1 |
| V-3aecb21a | F2 | AI검토:검사기오판 | U | 미보완: [FAIL] AS-IS 는 라벨에 *가 붙은 L/T Type 컬럼이 빈 신규 행을 저장하지 못하게 막고 필수 입력 메시지를 띄운다. TO-BE 도 같은 '[L/T Type] 값은 필수 입력 항목입니다.' 메시지로 막았으므로 AS-IS 와 같은 동작이다. TO-BE 저장 |
| V-e4a3ef56 | C3 | AI검토:검사기오판 | U | 미보완: [FAIL] AS-IS 에서 FROM_CITY 칸으로 도시 팝업을 열면 FROM_COUNTRY·FROM_CITY·FROM_CITY_NAME 만 채우고 TO_COUNTRY 는 건드리지 않습니다. TO-BE 에서도 FROM_CITY='AATES' 가 들어가고 TO_COUN |
| V-9beff6f2 | C3 | AI검토:검사기오판 | U | 미보완: [FAIL] AS-IS 에서 FROM_COUNTRY 칸으로 도시 팝업을 열면 FROM_COUNTRY·FROM_CITY·FROM_CITY_NAME 세 칸만 채웁니다. TO_COUNTRY 는 TO_* 칸으로 팝업을 열 때만 채웁니다(cs:1156~1158). TO-BE 에 |
| V-087d756b | E3 | AI검토:검사기오판 | U | 미보완: [FAIL] TO-BE 업로드는 오류 1건·성공 0건으로 저장 요청 없이 막혔다. 차단 안내 '오류 행이 존재하여 저장할 수 없습니다'를 띄웠고, 결과 그리드 Check 칸에는 'Error-Number' 를 보였다. AS-IS ExcelUploadForm2 도 Erro |
| V-bc940519 | H11 | AI검토:검사기오판 | U | 미보완: [판정필요] AS-IS SaveData 는 비동기 호출(ExecuteAsync) 줄을 주석 처리했고 SCP0005_SAVE_DISTRIBUTION_ROUTE 를 바로 호출합니다. ProgressForm 진행 창은 조회(FindDataMain)에만 쓰고 저장에는 쓰지 않 |
| V-1d8d1afb | F10 | AI검토:검사기오판 | U | 미보완: [FAIL] AS-IS Excel Upload는 엑셀 행마다 SCP0005_DISTRIBUTION_ROUTE_EXCEL_UPLOAD를 한 번씩 호출하고, 그 SP가 행마다 BEGIN TRAN과 COMMIT TRAN으로 확정하므로 원래 행 단위 저장입니다. TO-BE P |
| V-57cbc36c | K3 | AI검토:검사기오판 | U | 미보완: [FAIL] 이 화면의 팝업은 City by Country(RegionModal) 하나이고, 팝업 실측에서 No. 컬럼, 조회 건수 '총89,431', 필터 후 건수 '총2', Sort, ↓ 키는 모두 PASS 였습니다. FAIL 은 No. 컬럼·건수와 관계없는 SEL |
| V-f426f87d | K3 | AI검토:검사기오판 | U | 미보완: [FAIL] DM-116 의 기대는 Ctrl+클릭 비연속 다중 선택입니다. 메인 그리드와 City by Country 팝업 모두 Ctrl+클릭으로 2행이 선택되어 기대를 충족합니다. 팝업 SELECT_MODE FAIL 은 AS-IS 단일 반환(_bMultiSelect= |
| V-536d9503 | L1 | AI검토:검사기오판 | U | 미보완: [FAIL] 이 행은 그리드 방향키 반복 이동 응답을 보는 행인데, 증거에는 방향키가 아닌 조회 벽시계 시간 63878ms가 들어 있습니다. 같은 화면의 방향키 전용 측정(V-913a7260)에서 40회 이동 시 앞 10회 34ms, 뒤 10회 37ms로 누적 지연이  |
| V-96a5218a | K3 | AI검토:검사기오판 | U | 미보완: [FAIL] F5 를 누르면 조회 호출(SEARCH) 1건이 실행되고 페이지 이동은 0회로 PASS 입니다. SCP0005 원문에는 Version 팝업이 없어서 '버전 선택 직후 F5' 조건은 이 화면에 대상이 없습니다. FAIL 은 F5 와 관계없는 도시 팝업의 SE |
| V-612b1d63 | K3 | AI검토:검사기오판 | U | 미보완: [FAIL] CR-037 은 팝업을 포함한 모든 그리드에서 Ctrl+클릭 다중 선택을 요구합니다. 메인 그리드(LT_TYPE 0행·2행)와 City by Country 팝업 모두 Ctrl+클릭으로 2행이 선택되어 요구를 충족합니다. AS-IS 의 _bMultiSelec |
| AD-9d969364 | A6 | AI검토:검사기오판 | U | 미보완: [판정필요] AS-IS SCP0005_GET_DISTRIBUTION_ROUTE는 from_country, from_city, TO_COUNTRY, TO_CITY, PRIORITY로만 정렬하므로 동률 행의 순서가 정해져 있지 않습니다. TO-BE는 같은 키 순서에 ROU |
| AD-dc3e6a42 | A6 | AI검토:검사기오판 | U | 미보완: [판정필요] AS-IS SCP0005_GET_DISTRIBUTION_ROUTE는 다섯 키(from_country, from_city, TO_COUNTRY, TO_CITY, PRIORITY)로만 정렬하므로 동률 행의 순서가 정해져 있지 않습니다. TO-BE는 같은 키 순 |
| AD-e49a18e6 | A6 | AI검토:검사기오판 | U | 미보완: [판정필요] AS-IS SCP0005_GET_DISTRIBUTION_ROUTE는 다섯 키로만 정렬하므로 동률 행의 순서가 정해져 있지 않습니다. TO-BE는 같은 키 순서에 ROUTE_ID를 마지막 키로 더했습니다. 호출 #5(Transport Mode AIR)의 첫  |
| AD-80df7337 | A6 | AI검토:검사기오판 | U | 미보완: [판정필요] AS-IS SCP0005_GET_DISTRIBUTION_ROUTE는 from_country, from_city, TO_COUNTRY, TO_CITY, PRIORITY 다섯 키로만 정렬하므로, 다섯 값이 모두 같은 행끼리는 순서가 정해져 있지 않습니다. TO |
| T-438facd0 | G5 | AI검토:검사기오판 | U | 미보완: [ERROR] AS-IS To City 검색 버튼은 조회조건 To Country·To City 입력값을 도시 팝업에 넘기고, TO-BE 도 조회조건 toCountry·toCity 를 RegionModal 의 country·city 로 넘깁니다. 검사기는 이 조회조건 대 |
| T-86a9a3c4 | X-NOTIMPL | AI검토:검사기오판 | U | 미보완: [판정필요] Division·Site·BodType 콤보 메서드(GetDivision, GetFromSitebyDivision, GetToSitebyDivision, GetBodType)는 정의만 있고 호출하는 곳이 없습니다. dtFromCountry·dtToCount |
| T-a48010ce | X-REASON | AI검토:검사기오판 | U | 미보완: [판정필요] AS-IS SCP0005 화면 폴더(.cs·Designer.cs)를 ColumnSet·Measure 로 검색했지만, 컬럼·Measure 설정 팝업(FPC0097_ColumnSetForm_Popup 등)을 부르는 코드는 없었습니다. 그리드는 InitSprea |
| T-40117668 | X-REASON | AI검토:검사기오판 | U | 미보완: [판정필요] AS-IS 조회 SP 에서 From/To Country 는 단일 값 일치, From/To City 는 앞자리 LIKE 한 건으로만 비교하므로 직접 입력하는 조회조건에 콤마 다중 입력이 없습니다. 콤마로 나누는 조건은 Trans Mode 하나뿐이고, 이 값은 |
| T-ece1c98b | E4 | AI검토:검사기오판 | U | 미보완: [FAIL] AS-IS는 저장 응답 오류코드가 99010 또는 99020일 때만 MSG00043을 띄우고 위반 행의 구간 셀을 색칠합니다. 99030과 99040 분기는 없고 그 밖의 코드는 MSG00006으로 처리합니다. TO-BE는 99010과 99020 응답에서  |
| T-f048d4a9 | E4 | AI검토:검사기오판 | U | 미보완: [FAIL] T-ece1c98b와 같은 실측 묶음입니다. TO-BE는 MSG00043을 저장 중복 메시지로 쓰고, 99010과 99020 응답에서 각각 AS-IS와 같은 구간 셀을 색칠합니다. 검사기는 저장 요청 없이(req 0) 고정 문구로 FAIL을 기록했습니다. |
| EG-50fe3754 | M4 | AI검토:검사기오판 | U | 미보완: [FAIL] AS-IS 에서 _bMultiSelect=false 는 OK 를 눌렀을 때 활성 행 한 건의 값만 읽게 하는 설정이고, City by Country 팝업 그리드에서 Ctrl 로 여러 행을 고르는 것까지 막지는 않습니다. TO-BE 도 OK 를 누르면 선택한 |
| EG-9afd4a78 | A6 | AI검토:검사기오판 | U | 미보완: [판정필요] 정렬 키 FROM_COUNTRY, FROM_CITY, TO_COUNTRY, TO_CITY는 대문자 코드만 들어가는 필수 값입니다. AS-IS는 저장할 때 From·To 도시명이 비어 있으면 막고, 국가·도시 값을 도시 마스터에서 대문자로 바꿔 넣습니다. 그 |
| FACT-7973bc33 |  | AI검토:추출오류 | U | 미보완: 원문 SetImageCell은 조회 후 모든 행과 신규 행의 FROM_COUNTRY 셀 CellType을 cellTypeImage(new TextCellType, 오른쪽 배경 이미지)로 바꾼다. 추출본에는 메타의 FPTextBox max_length 2만 있고 이 셀  |
| FACT-d095c5be |  | AI검토:추출오류 | U | 미보완: 원문 SetImageCell은 FROM_CITY 셀 CellType을 cellTypeImage(new TextCellType)로 바꾼다. 추출본에는 메타의 FPTextBox max_length 5만 있다. |
| FACT-48f74816 |  | AI검토:추출오류 | U | 미보완: 원문 SetImageCell은 TO_COUNTRY 셀 CellType을 cellTypeImage(new TextCellType)로 바꾼다. 추출본에는 메타의 FPTextBox max_length 2만 있다. |
| FACT-a27a58c3 |  | AI검토:추출오류 | U | 미보완: 원문 SetImageCell은 TO_CITY 셀 CellType을 cellTypeImage(new TextCellType)로 바꾼다. 추출본에는 메타의 FPTextBox max_length 5만 있다. |
| FACT-36750505 |  | AI검토:추출오류 | U | 미보완: 원문 SetSpreadColumn은 조회 결과가 1행 이상일 때 모든 행의 ROUTE_ID 셀 BackColor를 colorLink(Color.Yellow)로 칠한다. 추출본 color_rules에는 이 규칙이 없다. |
| FACT-7567717d |  | AI검토:추출오류 | U | 미보완: 원문 CheckValid 1305줄 SetBGColor(FROM_CITY_NAME~FROM_CITY, InvalidColor)는 FROM_CITY_NAME 값이 빈 문자열일 때(string.IsNullOrEmpty(strFromCity)) 실행된다. 추출본은 cond를 |
| FACT-cb5c20fa |  | AI검토:추출오류 | U | 미보완: 원문 CheckValid 1313줄 SetBGColor(TO_CITY_NAME~TO_CITY, InvalidColor)는 TO_CITY_NAME 값이 빈 문자열일 때(string.IsNullOrEmpty(strToCity)) 실행된다. 추출본은 cond를 FALSE로  |

## 라운드 2 (2026-11-20 10:0x)

- 입력: 원장 verify_ledger.csv(09:06:10, CheckList 재검 08:59 시작 · 09:56:56 시나리오 실행 중 멈춤 · 1,996행 중 NOT_RUN 1,758행). 분류 10:00:50 재생성
- 원장이 판정 단계를 마치지 않아 처리 대상 행은 지난 판정 검토(llm_review 08:11)·사실 검토(llm_facts 09:05)가 가린 행이고, 측정 근거는 재검 E2E 결과(e2e_results.json 09:43, 813행)를 함께 씀
- 표 행 수 182 = 처리 대상 182. 라운드 1 표에 있는 행 175, 새 행 7(FACT 7, 라운드 1 FACT 7행과 같은 내용의 새 ID)
- 라운드 2 보완 행 중 처리 대상 밖 행(재검 E2E 에서 FAIL·ERROR 로 측정): T-9b463365, T-6d65f303, T-3d44d32d, T-ef2618be(T458), V-4e4af2a4, V-26d2974c, V-7116d2aa, V-72fbb5b2(T457), T-85f3a8bb, T-7e1a41bb(T459)

| 행 ID | 규칙 | 유형 | 라운드 1 묶음 | 라운드 2 조치 |
|---|---|---|---|---|
| V-28e296d5 | A4 | AI검토:검사기오판 | H | 라운드 1 보완 H 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-5a7b8946 | I3 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-f648eb06 | J1 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-e32d34a2 | L1 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-1f03b82a | C1 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-2e931168 | C1 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-ba8f9817 | F3 | AI검토:검사기오판 | D3 | 결정 목록 D3 |
| V-7ac42873 | F3 | AI검토:검사기오판 | D3 | 결정 목록 D3 |
| V-cb7ed54f | F3 | AI검토:검사기오판 | D3 | 결정 목록 D3 |
| V-d8ff8497 | F3 | AI검토:검사기오판 | D3 | 결정 목록 D3 |
| V-3aecb21a | F2 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-e4a3ef56 | C3 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-9beff6f2 | C3 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-087d756b | E3 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-bc940519 | H11 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-1d8d1afb | F10 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-5bcb735c | B4 | AI검토:추출오류 | D6 | 결정 목록 D6 |
| V-5b44fefc | D1 | AI검토:검사기오판 | G | 라운드 1 보완 G 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-9a1db2df | D1 | AI검토:검사기오판 | G | 라운드 1 보완 G 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-1ff8658b | D1 | AI검토:검사기오판 | G | 라운드 1 보완 G 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-599dd774 | D1 | AI검토:검사기오판 | G | 라운드 1 보완 G 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-82d97d20 | B4 | AI검토:추출오류 | D6 | 결정 목록 D6 |
| V-0bbe47b0 | E1 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-e8602478 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-c09178ce | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-71fb5be1 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-2144e9aa | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-e0967fb3 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-5288a224 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-f7aad894 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-74666abe | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-4692bd5f | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-ba067d18 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-d2825947 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-e4428757 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-7fdb371b | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-1f11c130 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-d561dda3 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-ccf7a91d | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-7778ce8c | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-2b51dd40 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-791b1969 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-16de807e | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-2ad82300 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-9fef8850 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-8b7e1398 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-222e2ec8 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-5d1de751 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-77654a3a | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-c7abf566 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-df790ade | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-a882d140 | E1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-0c943a4c | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-44e401f8 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-1afc1aeb | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-ae463842 | D1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| V-f069cc0b | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-b6684398 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-e3a95ba8 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-a8e42f1b | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-afc23080 | B4 | AI검토:추출오류 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-d13d9d93 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-d63c8c9a | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-efd885dd | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-a2b3892f | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-5f21d590 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-91d8baf9 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-37e29a8f | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-71c59c4c | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-f949ef0c | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-69c86016 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-d2820cb9 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-9a6fcce6 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-1bc44512 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-0ca2a4ea | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-d250eb92 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-c9b880e6 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-c58f5984 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-f0ce28a6 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-db291d83 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-7846248d | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-6ff4fa6b | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-a60ebda3 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-613909ff | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-b40b2f86 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-5f5baa0d | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-6d214120 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-71f0bdf9 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-e2555e29 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-99320598 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-1619a565 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-33771477 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-8c7cbe73 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-696d0104 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-c933e6e0 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-33598a73 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-f735840b | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-c2c1137d | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-78d583dc | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-dacaefd0 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-ddf83f9d | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-b7d4d9af | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-d3fc1ec0 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-d72694b1 | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-ef2c44ae | D1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-0267c456 | E1 | AI검토:검사기오판 | A | 라운드 1 보완 A 묶음 · 재검 원장 미완료로 반영 미측정 |
| V-c56bdc72 | H2 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-c099fa4f | H2 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-fa71e89c | H2 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-dc54eed4 | H2 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-a6bb7234 | G5 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-4ce029f5 | C6 | AI검토:검사기오판 | D6 | 결정 목록 D6 |
| V-4ad20009 | C6 | AI검토:검사기오판 | D6 | 결정 목록 D6 |
| V-3fa9771e | C6 | AI검토:검사기오판 | D6 | 결정 목록 D6 |
| V-eab82e73 | C3 | AI검토:검사기오판 | D6 | 결정 목록 D6 |
| V-03851efe | C3 | AI검토:추출오류 | D6 | 결정 목록 D6 |
| V-57cbc36c | K3 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-f426f87d | K3 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-536d9503 | L1 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-ecd963f8 | J4 | AI검토:룰등록 | U | 미보완(라운드 1 U 묶음) |
| V-96a5218a | K3 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-612b1d63 | K3 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| V-a32c8abf | M1 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| AD-9d969364 | A6 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| AD-dc3e6a42 | A6 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| AD-e49a18e6 | A6 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| AD-80df7337 | A6 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-9b463365 | G4 | AI검토:검사기오판 | E | 라운드 2 보완 T458 |
| T-cdb32d07 | H6 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-3d44d32d | M4 | AI검토:검사기오판 | E | 라운드 2 보완 T458 |
| T-47ab9353 | M4 | AI검토:검사기오판 | E | 라운드 1 보완 E 묶음 · 재검 원장 미완료로 반영 미측정 |
| T-90d2d30f | G4 | AI검토:검사기오판 | E | 라운드 1 보완 E 묶음 · 재검 원장 미완료로 반영 미측정 |
| T-438facd0 | G5 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-ef2618be | M4 | AI검토:검사기오판 | E | 라운드 2 보완 T458 |
| T-26aaaaf4 | M4 | AI검토:검사기오판 | E | 라운드 1 보완 E 묶음 · 재검 원장 미완료로 반영 미측정 |
| T-86a9a3c4 | X-NOTIMPL | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-6e75e40a | C2 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-6e2ef7c8 | C6 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-aa4e2eb2 | A5 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-c7a43f16 | C2 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-4dd85db6 | C3 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-dc040561 | C6 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-a48010ce | X-REASON | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-40117668 | X-REASON | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-94b3ad3d | A1 | AI검토:검사기오판 | D2 | 결정 목록 D2 |
| T-eb5343b6 | G4 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-8b3ad504 | C3 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-ece1c98b | E4 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-f048d4a9 | E4 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-1d878a60 | C3 | AI검토:검사기오판 | D6 | 결정 목록 D6 |
| T-b82f895f | C3 | AI검토:검사기오판 | H | 라운드 1 보완 H 묶음 · 재검 원장 미완료로 반영 미측정 |
| T-5edb7122 | C3 | AI검토:검사기오판 | H | 라운드 1 보완 H 묶음 · 재검 원장 미완료로 반영 미측정 |
| T-0803d2d0 | C3 | AI검토:검사기오판 | D6 | 결정 목록 D6 |
| T-38e03b62 | C3 | AI검토:검사기오판 | H | 라운드 1 보완 H 묶음 · 재검 원장 미완료로 반영 미측정 |
| T-653f2a16 | C3 | AI검토:검사기오판 | H | 라운드 1 보완 H 묶음 · 재검 원장 미완료로 반영 미측정 |
| T-2c4e7c8a | E4 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-e19b6757 | E4 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-e425f595 | H6 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-3beee65f | G5 | AI검토:추출오류 | U | 미보완(라운드 1 U 묶음) |
| T-a391f109 | G5 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| T-c65db01b | A1 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| EG-6a0f18bc | M3 | AI검토:검사기오판 | H | 라운드 1 보완 H 묶음 · 재검 원장 미완료로 반영 미측정 |
| EG-f670f773 | M3 | AI검토:검사기오판 | H | 라운드 1 보완 H 묶음 · 재검 원장 미완료로 반영 미측정 |
| EG-75f112d6 | M3 | AI검토:검사기오판 | H | 라운드 1 보완 H 묶음 · 재검 원장 미완료로 반영 미측정 |
| EG-b7b794bd | D5 | AI검토:룰등록 | D5 | 결정 목록 D5 |
| EG-50fe3754 | M4 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| EG-4041a815 | D5 | AI검토:검사기오판 | D1 | 결정 목록 D1 |
| EG-d5dc785f | B3 | AI검토:검사기오판 | H | 라운드 1 보완 H 묶음 · 재검 원장 미완료로 반영 미측정 |
| EG-e6babac5 | B3 | AI검토:검사기오판 | H | 라운드 1 보완 H 묶음 · 재검 원장 미완료로 반영 미측정 |
| EG-334fdc63 | B3 | AI검토:검사기오판 | H | 라운드 1 보완 H 묶음 · 재검 원장 미완료로 반영 미측정 |
| EG-9afd4a78 | A6 | AI검토:검사기오판 | U | 미보완(라운드 1 U 묶음) |
| EG-2037a747 | I2 | AI검토:검사기오판 | D6 | 결정 목록 D6 |
| EG-60363cec | I2 | AI검토:검사기오판 | D6 | 결정 목록 D6 |
| ES-0967e6d0 | J1 | AI검토:검사기오판 | F | 라운드 1 보완 F 묶음 · 재검 원장 미완료로 반영 미측정 |
| ES-fe8e48bc | J1 | AI검토:검사기오판 | F | 라운드 1 보완 F 묶음 · 재검 원장 미완료로 반영 미측정 |
| FACT-a3f92559 |  | AI검토:추출오류 | 신규 | 라운드 2 보완 T460 |
| FACT-3d955bfe |  | AI검토:추출오류 | 신규 | 라운드 2 보완 T460 |
| FACT-d2d86d60 |  | AI검토:추출오류 | 신규 | 미보완(라운드 1 FACT-36750505·7973bc33·d095c5be·48f74816·a27a58c3 와 같은 내용 · SetImageCell 셀 형식 · SetSpreadColumn ROUTE_ID 색) |
| FACT-ec341492 |  | AI검토:추출오류 | 신규 | 미보완(라운드 1 FACT-36750505·7973bc33·d095c5be·48f74816·a27a58c3 와 같은 내용 · SetImageCell 셀 형식 · SetSpreadColumn ROUTE_ID 색) |
| FACT-fa328956 |  | AI검토:추출오류 | 신규 | 미보완(라운드 1 FACT-36750505·7973bc33·d095c5be·48f74816·a27a58c3 와 같은 내용 · SetImageCell 셀 형식 · SetSpreadColumn ROUTE_ID 색) |
| FACT-c5b7854f |  | AI검토:추출오류 | 신규 | 미보완(라운드 1 FACT-36750505·7973bc33·d095c5be·48f74816·a27a58c3 와 같은 내용 · SetImageCell 셀 형식 · SetSpreadColumn ROUTE_ID 색) |
| FACT-ea98ca20 |  | AI검토:추출오류 | 신규 | 미보완(라운드 1 FACT-36750505·7973bc33·d095c5be·48f74816·a27a58c3 와 같은 내용 · SetImageCell 셀 형식 · SetSpreadColumn ROUTE_ID 색) |
