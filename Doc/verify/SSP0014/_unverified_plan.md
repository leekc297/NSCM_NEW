# SSP0014 미검증 행별 조치 (2026-11-19 17:0x · 라운드 2 갱신)

- 원천: `unverified_triage.csv`(2026-11-19 16:17:57, 분류 라운드 1). 원장 `verify_ledger.csv`(2026-11-19 16:17:30) 미검증 293행
- 이 표 = 집계 아닌 148행(엔진 115, 판단 28, 가이드 4, 사람 1) + 집계 145행. 합계 293행 = 원장 미검증 293행
- 재측정은 VM 의 CheckList 재수행으로 함. 이번 라운드에서 run_verify, 개별 검사기 재실행 안 함
- 묶음 순서 = 행 수 많은 순. 검사기 결함 번호 T349~T359 = Doc/verify/_checker_defects.md

## 묶음

| 묶음 | 행 | 원인(실측) | 조치(고친 파일) | 다음 CheckList |
|---|---|---|---|---|
| R1 재실행(BE 중단) | 36 | BE 로그 nscm.log 14:33 뒤 15:07 까지 기록 0줄. K3 시험(14:33:21 시작) 조회 9회 0행(사업부 8개 순회), 이어서 E6(14:38), B7(14:43), B1·B2·B6(14:49), G8·G9·G1 텍스트(14:55) 시험이 ERR_CONNECTION_REFUSED, K1(15:01) 로그인 시간 초과. 검사기 결함 아님. 15:1x 서버 자동 기동(server_guard.py, nscm.ts waitBeUp)이 다음 CheckList 에서 BE 를 다시 띄움 | 검사기 수정 없음. 3단계 CheckList 재수행에서 측정 | 미측정(BE 기동 상태에서 재측정) |
| P1 저장 경로 | 28 | 사용자 칸 8개(FPTextModal)는 더블클릭하면 사용자 검색 팝업이 열림(ShipmentModelPicGrid.tsx handleDblClick). 검사기 셀 입력(setCell, typeRaw)이 더블클릭으로 편집을 시작해 시험 값이 팝업에 들어감. CRUD 결과 '편집 가능 셀 7개 시도, 값이 바뀌는 셀 없음'(13:51 crud spec, 14:06 @verify), 저장 세부·저장 경로 시험 'User Popup 이 Save 를 가림'(14:07, 14:08). 첫 행 r0 은 필수 칸 USER_ID 가 비어 저장이 '[User ID] 필수' 안내에 막힘(E7 증거). 사용자 칸은 저장 때 USER_CHECK 로 등록 사용자만 통과(useShipmentModelPicValidation.ts)라 '원값+X' 는 저장 불가 | T350 nscm.ts dismissDblPopup, setCell, saveprobe.ts typeRaw. T349 probe.ts findRow, firstEditableRow, requiredColumns, popupColumn, otherColumnValue, requiredFilled. crud.ts 후보 행 순서, 팝업 칸 값. saveprobe.ts nextOf | 미측정(저장 시험 실행) |
| P4 팝업 인자(G5) | 16 | AS-IS SpdMain_CellDoubleClick(cs:626~831) 사용자 팝업은 셀 값을 넘기지 않음(SSOUserYN, SingleSelectYn, Language 만). 원천 칸 0개인데 '값이 모두 비어' 판정필요 | T352 _verify.spec.ts G5 원천 칸 0개 + 팝업 호출 있음 = PASS(근거 actions.csv) | 미측정(원천 칸 0개면 PASS) |
| P2 필수 빈 첫 행(E7) | 15 | 잘못된 값 저장 차단 시험이 r0 을 씀. r0 USER_ID 빈 값이라 Save 가 '[User ID] 값은 필수 입력 항목입니다'(COLUMN 7행) 또는 메시지·요청 0(EG 8행)으로 끝나 이 칸 차단 여부를 못 잼 | T349 probe.ts findRow(기존행 = 필수 칸 채워진 행 우선), firstEditableRow(필수 칸 채워진 행 1차) | 미측정(필수 칸 채워진 행에서 저장 차단 측정) |
| P5 신규행 기본값(D4) | 9 | TO-BE Insert 없음. AS-IS InsertButton 본문이 주석뿐(cs:254~257, actions_entries.csv 19행, actions.csv 실행 문장 0). 검사기는 TO-BE Insert 가 없으면 AS-IS 무동작 근거를 보지 않음 | T354 _trace.spec.ts D4(asisInsertNoop 근거 NA) | 미측정(AS-IS Insert 무동작이면 NA) |
| P6 연쇄(C3) | 9 | 대입 문장이 자기 칸 대입뿐. 사용자 칸 8개 = 자기 칸 더블클릭 팝업 선택값(cs:649, 724 등 SetValue(e.Row, 자기 칸, item.UserID)), OPERATION_GROUP = 조회 후 'W' → 'Warranty' 표시 변환(cs:358). 원천 칸이 없어 '해석 불가' | T356 mapping_trace.py selfAssign, _trace.spec.ts C3 NA(근거 원문) | 미측정(자기 칸 대입이면 NA) |
| P3 팝업 칸 아이콘(D5) | 8 | 공용 그리드는 팝업 아이콘을 CSS 가상 요소로 그림(_grid.scss:710~730 .wj-cell-popup::after). 검사기는 셀 자식 svg, button 만 찾아 '아이콘 false'. 셀 클래스 기록도 80자에서 잘려 wj-cell-popup 여부가 증거에 없음 | T351 Doc/e2e/specs/eg_popup.spec.ts CELL_ICON(::after 계산 스타일 + 클래스) | 미측정(아이콘 클래스 있으면 PASS) |
| J 판단 | 6 | 행별 근거는 _unverified_decisions.md | 결정 목록 | 결정 대기 |
| R2 재실행(언어 계정) | 4 | 언어 전환 시험이 다른 화면 E2E(SCP0005, SCP0028, SSP0005) 동시 실행으로 계정 언어 전환 생략(T200). lang_texts.json KO, EN, CN 측정 경로 없음. 15:4x 언어 시험 전용 ADMIN 계정(langacct.ts)으로 바뀜. I3 은 이 덤프로 판정(judge.py I3) | 검사기 수정 없음(15:4x 반영분). 3단계 재수행에서 측정 | 미측정(언어 전용 계정) |
| G 대조표 구현 위치(가이드) | 4 | 대조표 부록 C, iter-3 표에 구현 위치 칸 없음 | FE_GUIDE_20261119_1647.md G1~G4 | 가이드 반영 전 미검증 유지 |
| X1 대조표 팝업 오기(가이드) | 4 | 라운드 2(17:0x) 확인: 화면은 2026-10-12 사용자 지시로 공용 품목 팝업 MaterialByDivisionModal(COM0013)로 바뀜(ShipmentModelPic.tsx:545~558). 대조표 28·36·72·98·131·154줄은 교체 전 SCM0002 팝업(PKG_SCM0002)을 적고 있음. 이번 CheckList sqllog_calls.json PKG_SCM0002 호출 0건. popup_args.csv: AS-IS 는 clbFromSite 값을 팝업 인자 _ScmSiteId 로 넘기고 TO-BE 는 안 넘김 | FE_GUIDE_20261119_1647.md G5(대조표 갱신). 출발 사이트 인자 차이 = 결정 D7 | 가이드 반영 전 미검증 유지 |
| P7 SP 짝(A1·A6) | 2 | sp_pair.csv 231~233행에 짝 있음. 골든 생성기, 정렬 검사기는 이름 비교만 해 SSP0014_GET_SHIPMENT_MODEL_PIC ↔ P_SSP0014_GET_MODEL_PIC 를 못 찾음(golden_cases.csv 128행 미매칭). 같은 생성기가 MODEL 안의 DEL 을 저장으로 읽어 kind=SAVE | T358 gen_golden_cases.py sp_pair 우선, 낱말 단위 kind. sort_check.py sp_pair 우선. golden_cases.csv SSP0014 3건 재생성(16:4x, 짝 3/3) | 미측정(골든 짝 생김) |
| P8 멀티선택 후보(G1·G2) | 2 | 결과 칸에서 가장 드문 값 CN003256_40-A 로 후보 검색창을 거름. 이 코드는 AS-IS, TO-BE SCM_MST_SITE 0행(16:46 조회)이라 후보 목록이 비어 '후보 1개' ERROR | T355 _trace.spec.ts 검색어 바꿔 최대 12개 재시도 → 전체 목록 | 미측정(다른 결과 값으로 선택) |
| X2 AS-IS 칸 상수 이름 | 2 | 라운드 2(17:0x) 확인: AS-IS 상수 `const string DIVISION = "DIVISION_ID"`(cs:77). 검사기가 상수 이름 'DIVISION' 을 칸 이름으로 써 그리드에서 못 찾음 | T359 mapping_trace.py 상수 이름 → 원문 상수 값 칸(원장 칸으로 가는 것만) | 미측정(DIVISION_ID 로 측정) |
| P9 숫자 칸 값 유지(F6) | 1 | AS-IS 셀 규칙 21칸 중 숫자 0칸(cell_rules.csv). TO-BE 편집 칸도 숫자 없음. 대상 없음 근거를 보지 않고 ERROR | T353 _verify.spec.ts F6 숫자 칸 없음 근거 NA | 미측정(숫자 칸 0이면 NA) |
| H 사람 | 1 | 스냅샷 승인 대기 | 결정 D1(snap_validate 결과 붙임) | 결정 대기 |
| P10 게이트 G03(G03-WIRE) | 1 | 하네스 게이트 결과 Doc/gen/SSP0014/CHECK.md 없음(생성기를 거치지 않은 화면). 검사기는 결과 파일이 있을 때만 읽음 | T357 mapping_trace.py ev_gates: 결과 없으면 check.js 를 화면 폴더에 읽기 전용 1회 실행 | 미측정(CHECK.md 생성 뒤 판정) |

## 행별 목록

| 행 | 출처 | 규칙 | 분류(담당) | 대상 | 묶음 | 결정 |
|---|---|---|---|---|---|---|
| V-2b0197b7 | SEARCH | B1 | 검사기공백(엔진) | 조회조건 From Site | R1 |  |
| V-370ee943 | SEARCH | B1 | 검사기공백(엔진) | 조회조건 Active | R1 |  |
| V-4eab6ba7 | SEARCH | B1 | 검사기공백(엔진) | 조회조건 Operation group | R1 |  |
| V-ef082917 | SEARCH | B1 | 검사기공백(엔진) | 조회조건 Div | R1 |  |
| V-6af959b7 | SEARCH | B2 | 검사기공백(엔진) | 조회조건 Operation group | R1 |  |
| V-70b4bd92 | SEARCH | B2 | 검사기공백(엔진) | 조회조건 Active | R1 |  |
| V-c2336a72 | SEARCH | B2 | 검사기공백(엔진) | 조회조건 Div | R1 |  |
| V-c951c278 | SEARCH | B2 | 검사기공백(엔진) | 조회조건 From Site | R1 |  |
| V-205005f5 | SEARCH | B6 | 검사기공백(엔진) | 조회조건 Operation group | R1 |  |
| V-679f2289 | SEARCH | B6 | 검사기공백(엔진) | 조회조건 From Site | R1 |  |
| V-d93f950d | SEARCH | B6 | 검사기공백(엔진) | 조회조건 Div | R1 |  |
| V-df3f9331 | SEARCH | B6 | 검사기공백(엔진) | 조회조건 Active | R1 |  |
| V-1d47e1bf | SEARCH | B7 | 검사기공백(엔진) | 조회조건 Active | R1 |  |
| V-38d59acf | SEARCH | B7 | 검사기공백(엔진) | 조회조건 Operation group | R1 |  |
| V-9d444674 | SEARCH | B7 | 검사기공백(엔진) | 조회조건 Div | R1 |  |
| V-b8fd2a3d | SEARCH | B7 | 검사기공백(엔진) | 조회조건 From Site | R1 |  |
| V-4943e2a1 | RULE_SCREEN | E6 | 검사기공백(엔진) | SSP0014 화면 | R1 |  |
| V-62f3c604 | RULE_SCREEN | G1 | 검사기공백(엔진) | SSP0014 텍스트 부분일치 User ID(Name) | R1 |  |
| V-6b514984 | RULE_SCREEN | G1 | 검사기공백(엔진) | SSP0014 텍스트 부분일치 Model/Nickname | R1 |  |
| V-a7e7a595 | SEARCH | G1 | 검사기공백(엔진) | 조회조건 Model/Nickname | R1 |  |
| V-2138dd48 | SEARCH | G2 | 검사기공백(엔진) | 조회조건 Model/Nickname | R1 |  |
| V-3f89937b | SEARCH | G8 | 검사기공백(엔진) | 조회조건 Model/Nickname | R1 |  |
| V-7c7315ae | SEARCH | G8 | 검사기공백(엔진) | 조회조건 User ID(Name) | R1 |  |
| V-3809bf77 | SEARCH | G9 | 검사기공백(엔진) | 조회조건 User ID(Name) | R1 |  |
| V-c9418134 | SEARCH | G9 | 검사기공백(엔진) | 조회조건 Model/Nickname | R1 |  |
| V-22a8c711 | GENERAL | K3 | 데이터전제(엔진) | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | R1 |  |
| V-683b9a77 | RULE_SCREEN | K3 | 데이터전제(엔진) | SSP0014 화면 | R1 |  |
| V-71b95789 | GENERAL | K3 | 데이터전제(엔진) | [DMF0035 결함 유형] F5 단축키 | R1 |  |
| V-7ee401e3 | GENERAL | K3 | 데이터전제(엔진) | [DMF0035 결함 유형] 조회 버튼 단축키 | R1 |  |
| V-97b5ddd0 | CONFIRMED | K3 | 데이터전제(엔진) | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | R1 |  |
| V-9839bb73 | DEFECT | K3 | 데이터전제(엔진) | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | R1 |  |
| V-b03b2833 | CONFIRMED | K3 | 데이터전제(엔진) | 그리드 헤더 클릭 | R1 |  |
| V-cb823dd1 | DEFECT | K3 | 데이터전제(엔진) | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | R1 |  |
| V-d628ea4b | DEFECT | K3 | 데이터전제(엔진) | 그리드 헤더 클릭 | R1 |  |
| V-ee26898a | GENERAL | K3 | 데이터전제(엔진) | [DMF0035 결함 유형] Ctrl+클릭 다중선택 | R1 |  |
| V-f10c20d5 | GENERAL | K3 | 데이터전제(엔진) | [DMF0020 결함 유형] Exchange Rate 그리드 Copy·Header Hide Column | R1 |  |
| V-7ac6b179 | RULE_SCREEN | E3 | 검사기공백(엔진) | SSP0014 필수 공란 Shipment Model PIC.USER_ID | P1 |  |
| T-01a15dbe | TRACE | E4 | 데이터전제(엔진) | MSG00284 | P1 |  |
| T-64d2c285 | TRACE | E4 | 데이터전제(엔진) | MSG00284 | P1 |  |
| T-927730ac | TRACE | E4 | 데이터전제(엔진) | MSG00004 | P1 |  |
| T-de1acc73 | TRACE | E4 | 데이터전제(엔진) | MSG00004 | P1 |  |
| V-28e0310f | ASIS | E4 | 데이터전제(엔진) | MSG00284 | P1 |  |
| V-339a10c5 | ASIS | E4 | 데이터전제(엔진) | MSG00004 | P1 |  |
| V-45fe7803 | RULE_SCREEN | F1 | 검사기공백(엔진) | SSP0014 화면 | P1 |  |
| V-504dee98 | RULE_SCREEN | F1 | 검사기공백(엔진) | SSP0014 2행 동시 저장 | P1 |  |
| V-5473aa5a | RULE_SCREEN | F1 | 검사기공백(엔진) | SSP0014 저장 실패 처리 | P1 |  |
| V-9bcbf1f5 | RULE_SCREEN | F1 | 검사기공백(엔진) | SSP0014 컬럼별 저장 왕복 | P1 |  |
| V-2dd4a9bd | RULE_SCREEN | F2 | 검사기공백(엔진) | SSP0014 화면 | P1 |  |
| V-947085e8 | RULE_SCREEN | F2 | 검사기공백(엔진) | SSP0014 붙여넣기 저장 인식 | P1 |  |
| T-247065c7 | TRACE | F4 | 검사기공백(엔진) | PKG_SSP0014.P_SSP0014_GET_USER_ID_CHECK | P1 |  |
| V-9526999b | RULE_SCREEN | F4 | 검사기공백(엔진) | SSP0014 화면 | P1 |  |
| V-ea58c4a2 | RULE_SCREEN | F4 | 검사기공백(엔진) | SSP0014 경계값 저장 | P1 |  |
| V-09388b3d | RULE_SCREEN | F6 | 검사기공백(엔진) | SSP0014 빈값 저장 | P1 |  |
| V-244ceb9e | RULE_SCREEN | F6 | 검사기공백(엔진) | SSP0014 화면 | P1 |  |
| V-65af2f69 | RULE_SCREEN | F6 | 검사기공백(엔진) | SSP0014 0 값 저장 | P1 |  |
| V-6ea977f3 | RULE_SCREEN | F6 | 검사기공백(엔진) | SSP0014 저장 행 수 불변 | P1 |  |
| V-0393c4ab | RULE_SCREEN | F7 | 검사기공백(엔진) | SSP0014 저장 연계 테이블 | P1 |  |
| V-6327b4a6 | RULE_SCREEN | F7 | 검사기공백(엔진) | SSP0014 2회 저장 행 수 | P1 |  |
| V-ed0f364d | RULE_SCREEN | F7 | 검사기공백(엔진) | SSP0014 저장 연계·이력 표 | P1 |  |
| V-0f12b7d4 | RULE_SCREEN | F8 | 검사기공백(엔진) | SSP0014 이력 행 값 | P1 |  |
| V-5dba8d06 | RULE_SCREEN | F8 | 검사기공백(엔진) | SSP0014 저장 감사 필드 | P1 |  |
| V-5dfa263a | RULE_SCREEN | F8 | 검사기공백(엔진) | SSP0014 수정 감사 컬럼 | P1 |  |
| V-3a4ddb83 | RULE_SCREEN | H10 | 검사기공백(엔진) | SSP0014 저장 취소 요청 없음 | P1 |  |
| V-9041b5eb | RULE_SCREEN | L1 | 검사기공백(엔진) | SSP0014 저장 응답 시간 | P1 |  |
| V-113d1799 | ASIS | G5 | 데이터전제(엔진) | new UserInfoPopup() | P4 |  |
| V-11a4fcdf | ASIS | G5 | 데이터전제(엔진) | popup.ShowDialog() | P4 |  |
| V-456975c2 | ASIS | G5 | 데이터전제(엔진) | popup.ShowDialog() | P4 |  |
| V-51cca87a | ASIS | G5 | 데이터전제(엔진) | popup.ShowDialog() | P4 |  |
| V-56fc463e | ASIS | G5 | 데이터전제(엔진) | popup.ShowDialog() | P4 |  |
| V-6ad1182d | ASIS | G5 | 데이터전제(엔진) | new UserInfoPopup() | P4 |  |
| V-84d25ca8 | ASIS | G5 | 데이터전제(엔진) | new UserInfoPopup() | P4 |  |
| V-8a43cba5 | ASIS | G5 | 데이터전제(엔진) | new UserInfoPopup() | P4 |  |
| V-92b73e23 | ASIS | G5 | 데이터전제(엔진) | new UserInfoPopup() | P4 |  |
| V-969965a4 | ASIS | G5 | 데이터전제(엔진) | popup.ShowDialog() | P4 |  |
| V-9bbebfe3 | ASIS | G5 | 데이터전제(엔진) | new UserInfoPopup() | P4 |  |
| V-a66510d8 | ASIS | G5 | 데이터전제(엔진) | popup.ShowDialog() | P4 |  |
| V-b70eeccb | ASIS | G5 | 데이터전제(엔진) | new UserInfoPopup() | P4 |  |
| V-c4ea73fb | ASIS | G5 | 데이터전제(엔진) | popup.ShowDialog() | P4 |  |
| V-dfb225ee | ASIS | G5 | 데이터전제(엔진) | new UserInfoPopup() | P4 |  |
| V-e88e29a7 | ASIS | G5 | 데이터전제(엔진) | popup.ShowDialog() | P4 |  |
| EG-27b88211 | RULE_SCREEN | E7 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:USER_ID CELL_BADKEY | P2 |  |
| EG-30ffd910 | RULE_SCREEN | E7 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:MAIL_USER1 CELL_BADKEY | P2 |  |
| EG-5e10c2b6 | RULE_SCREEN | E7 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:PART_LEADER CELL_BADKEY | P2 |  |
| EG-65467583 | RULE_SCREEN | E7 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:MAIL_USER4 CELL_BADKEY | P2 |  |
| EG-76f5b6a8 | RULE_SCREEN | E7 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:MAIL_USER2 CELL_BADKEY | P2 |  |
| EG-8135552b | RULE_SCREEN | E7 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:TEAM_LEADER CELL_BADKEY | P2 |  |
| EG-8aea2a61 | RULE_SCREEN | E7 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:MAIL_USER5 CELL_BADKEY | P2 |  |
| EG-fc0afc74 | RULE_SCREEN | E7 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:MAIL_USER3 CELL_BADKEY | P2 |  |
| V-14d7bde3 | COLUMN | E7 | 판단(판단) | Shipment Model PIC.MAIL_USER3 (Mail User3) | P2 |  |
| V-2cfdd24e | COLUMN | E7 | 판단(판단) | Shipment Model PIC.MAIL_USER1 (Mail User1) | P2 |  |
| V-4c4bab87 | COLUMN | E7 | 판단(판단) | Shipment Model PIC.MAIL_USER2 (Mail User2) | P2 |  |
| V-4f4fa2d7 | COLUMN | E7 | 판단(판단) | Shipment Model PIC.TEAM_LEADER (Team Leader) | P2 |  |
| V-4ff4ac2d | COLUMN | E7 | 판단(판단) | Shipment Model PIC.PART_LEADER (Part Leader) | P2 |  |
| V-6f2508fe | COLUMN | E7 | 판단(판단) | Shipment Model PIC.MAIL_USER5 (Mail User5) | P2 |  |
| V-9f90d59d | COLUMN | E7 | 판단(판단) | Shipment Model PIC.MAIL_USER4 (Mail User4) | P2 |  |
| T-04057317 | TRACE | D4 | 데이터전제(엔진) | USER_ID / User ID | P5 |  |
| T-62d64184 | TRACE | D4 | 데이터전제(엔진) | MAIL_USER3 / Mail User3 | P5 |  |
| T-72273c1d | TRACE | D4 | 데이터전제(엔진) | TEAM_LEADER / Team Leader | P5 |  |
| T-8fba0868 | TRACE | D4 | 데이터전제(엔진) | MAIL_USER5 / Mail User5 | P5 |  |
| T-956fded6 | TRACE | D4 | 데이터전제(엔진) | MAIL_USER2 / Mail User2 | P5 |  |
| T-9dfd7d79 | TRACE | D4 | 데이터전제(엔진) | PART_LEADER / Part Leader | P5 |  |
| T-c4668fe0 | TRACE | D4 | 데이터전제(엔진) | MAIL_USER4 / Mail User4 | P5 |  |
| T-e49d499d | TRACE | D4 | 데이터전제(엔진) | MAIL_USER1 / Mail User1 | P5 |  |
| T-e5b858cc | TRACE | D4 | 데이터전제(엔진) | OPERATION_GROUP / Operation Group | P5 |  |
| T-01c956ac | TRACE | C3 | 검사기공백(엔진) | MAIL_USER4 / Mail User4 | P6 |  |
| T-0de8f686 | TRACE | C3 | 검사기공백(엔진) | PART_LEADER / Part Leader | P6 |  |
| T-1fe84ed3 | TRACE | C3 | 검사기공백(엔진) | MAIL_USER2 / Mail User2 | P6 |  |
| T-23be6f89 | TRACE | C3 | 검사기공백(엔진) | MAIL_USER1 / Mail User1 | P6 |  |
| T-299891aa | TRACE | C3 | 검사기공백(엔진) | TEAM_LEADER / Team Leader | P6 |  |
| T-3443e90f | TRACE | C3 | 검사기공백(엔진) | OPERATION_GROUP / Operation Group | P6 |  |
| T-3a988f9b | TRACE | C3 | 검사기공백(엔진) | USER_ID / User ID | P6 |  |
| T-8c99afdd | TRACE | C3 | 검사기공백(엔진) | MAIL_USER5 / Mail User5 | P6 |  |
| T-f91b5ced | TRACE | C3 | 검사기공백(엔진) | MAIL_USER3 / Mail User3 | P6 |  |
| EG-3aaac93d | RULE_SCREEN | D5 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:USER_ID CELL_ICON | P3 |  |
| EG-455a2b93 | RULE_SCREEN | D5 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:MAIL_USER5 CELL_ICON | P3 |  |
| EG-66343add | RULE_SCREEN | D5 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:PART_LEADER CELL_ICON | P3 |  |
| EG-66837343 | RULE_SCREEN | D5 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:TEAM_LEADER CELL_ICON | P3 |  |
| EG-c85d613c | RULE_SCREEN | D5 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:MAIL_USER4 CELL_ICON | P3 |  |
| EG-d0b1cd5c | RULE_SCREEN | D5 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:MAIL_USER1 CELL_ICON | P3 |  |
| EG-dd402fa1 | RULE_SCREEN | D5 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:MAIL_USER2 CELL_ICON | P3 |  |
| EG-f27d5f75 | RULE_SCREEN | D5 | 판단(판단) | SSP0014 팝업 UserInfoPopup CELL:MAIL_USER3 CELL_ICON | P3 |  |
| V-16ab0403 | RULE_SCREEN | A2 | 판단(판단) | SSP0014 콤보 칸 이름 표시 | J | D2 |
| V-0db2d553 | SEARCH | B4 | 데이터전제(엔진) | 조회조건 From Site | J | D4 |
| V-62f2170d | SEARCH | B4 | 데이터전제(엔진) | 조회조건 Operation group | J | D3 |
| EG-a6f6bebc | RULE_SCREEN | J1 | 판단(판단) | SSP0014 EG366 Division 후보 SSP/81/SSP Viewer | J | D5 |
| T-049a5854 | TRACE | M4 | 판단(판단) | clbFromSite / From Site | J | D7 |
| EG-942cf54f | RULE_SCREEN | N1 | 판단(판단) | SSP0014 기준정보 키 존재 SCM_MST_SITE_ITEM | J | D6 |
| V-bdadf4fc | RULE_SCREEN | I1 | 검사기공백(엔진) | SSP0014 시나리오 [자동] KO 언어 · 변경 없이 저장 → KO 수정사항 없음 알림 | R2 |  |
| EG-a254f3be | RULE_SCREEN | I2 | 검사기공백(엔진) | SSP0014 언어 전환 EN | R2 |  |
| EG-d9be1686 | RULE_SCREEN | I2 | 검사기공백(엔진) | SSP0014 언어 전환 KO | R2 |  |
| V-46efb880 | RULE_SCREEN | I3 | 검사기공백(엔진) | SSP0014 화면 | R2 |  |
| T-59a6ad00 | TRACE | X-LOC | 대조표사유(가이드) | 2 · SwitchLock(EditButton) | G |  |
| T-add9b00e | TRACE | X-LOC | 대조표사유(가이드) | 1 · SmartColMerge(InitSpread) | G |  |
| T-cb6154c3 | TRACE | X-LOC | 대조표사유(가이드) | B-1~B-7 · 해당없음(AS-IS 무관) | G |  |
| T-f989ac6c | TRACE | X-LOC | 대조표사유(가이드) | 13-14 · SmartColMerge(조회후/TopChange) | G |  |
| T-d1bd8978 | TRACE | A6 | 검사기공백(엔진) | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | X1 | D7 |
| T-bab6f023 | TRACE | F4 | 검사기공백(엔진) | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | X1 | D7 |
| T-3a730d4a | TRACE | G5 | 검사기공백(엔진) | clbFromSite / From Site | X1 | D7 |
| T-a5fcd2ff | TRACE | H6 | 검사기공백(엔진) | clbFromSite / From Site | X1 | D7 |
| EG-7617d6c1 | RULE_SCREEN | A1 | 검사기공백(엔진) | SSP0014 실전송 건수 main | P7 |  |
| V-2d3318b4 | SP | A6 | 검사기공백(엔진) | SSP0014_GET_SHIPMENT_MODEL_PIC | P7 |  |
| V-ccba28ce | SEARCH | G1 | 데이터전제(엔진) | 조회조건 From Site | P8 |  |
| V-d8e76528 | SEARCH | G2 | 데이터전제(엔진) | 조회조건 From Site | P8 |  |
| T-0bba9c32 | TRACE | A5 | 검사기공백(엔진) | DIVISION | X2 |  |
| T-86e85805 | TRACE | H5 | 판단(판단) | DIVISION | X2 |  |
| V-01c25404 | RULE_SCREEN | F6 | 검사기공백(엔진) | SSP0014 다른 셀 편집 값 유지 | P9 |  |
| V-3bb51520 | RULE_SCREEN | K4 | 스냅샷승인(사람) | SSP0014 스냅샷 버튼 Div 40 | H | D1 |
| T-b4d54a37 | TRACE | G03-WIRE | 검사기공백(엔진) | SSP0014 화면 | P10 |  |

## 집계 145행

하위 행 판정을 따라감. 따로 고치지 않음.

| 규칙 | 행 |
|---|---|
| A5 | 10 |
| A6 | 1 |
| B2 | 4 |
| B4 | 19 |
| B5 | 7 |
| B6 | 2 |
| B7 | 4 |
| C3 | 9 |
| D4 | 1 |
| D5 | 1 |
| E3 | 1 |
| F4 | 2 |
| G1 | 27 |
| G2 | 5 |
| G5 | 9 |
| G8 | 3 |
| G9 | 2 |
| H5 | 9 |
| H6 | 7 |
| J1 | 7 |
| M4 | 1 |
| N1 | 4 |
| X-ROW | 10 |
