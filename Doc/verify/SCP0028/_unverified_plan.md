# SCP0028 미검증 해소 계획 · 2026-11-20 라운드 3(CheckList 13:07 원장)

- 입력: 원장 verify_ledger.csv(13:07:33) · 분류 unverified_triage.*(13:10:16). 원장 미검증 87 = 엔진 19 · 결정 2 · 집계 66. AI 검토 행 20(미검증 아님) 포함 처리 대상 39
- 목록 41행 = 처리 대상 39 + 결정 2. 집계 66행은 하위 행을 따라가므로 목록에서 뺌
- 묶음: P1 mapping_trace.py · P2a gen_expect·i18n_static·llm_review · P2b sort_check·syn_check·judge B6·popup_args_check·golden · T1 _verify.spec.ts·smoke-extra.ts · T2 _trace.spec.ts. 서로 다른 파일이라 하위 에이전트 4개(P2a·P2b 는 한 에이전트)로 나눔
- 지난 라운드 U(엔진 확장 필요) 34행 중 이번 목록에 남은 행 전부를 이번 라운드에 처리함

| 행 | 담당 | 유형 | 규칙 | 대상 | 묶음 | 고칠 파일 | 원인·조치 |
|---|---|---|---|---|---|---|---|
| V-8da88867 | 엔진 | 검사기공백 | A7 | SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | P2b | tools/DbConn/golden.py | 입력용 SP(인자 = 일괄입력 팝업 선택 행 목록) 실행 인자 원천 없음 |
| V-db17a330 | 엔진 | 검사기공백 | G2 | 조회조건 Model | T1 | Doc/e2e/specs/_verify.spec.ts G2 | Model 텍스트 조회조건(팝업 단추 있는 칸)을 콤마 다중 입력 대상으로 잡지 못함 |
| V-99331be4 | 엔진 | 검사기공백 | G5 | 조회조건 Model | T1 | Doc/e2e/specs/_verify.spec.ts G5 | Model 조회조건 팝업 인자 실측 경로 없음 |
| V-dd4f9db4 | 엔진 | 미분류 | G1 | 조회조건 From Site | T1 | Doc/e2e/specs/_verify.spec.ts·tools/E2E/lib/smoke-extra.ts 멀티선택 | 코드 후보를 설명 칸(FROM_SITE_DESCRIPTION) 값과 대조해 결과에 있는 후보를 못 고름 |
| V-86e7f1e2 | 엔진 | 검사기공백 | G1 | MSG00031 | T2 | Doc/e2e/specs/_trace.spec.ts 팝업 Delete 경로 → G1 행 연결 | smoke 조회조건 대상으로 배정된 FindDelete 메시지 |
| V-a89007be | 엔진 | 검사기공백 | G1 | MSG00284 | T2 | Doc/e2e/specs/_trace.spec.ts 팝업 Delete 경로 → G1 행 연결 | 같은 원인(MSG00284) |
| V-a99ddb18 | 엔진 | 데이터전제 | H2 | siMain.SetBGColor | T2 | Doc/e2e/specs/_trace.spec.ts H2 색 규칙 | action==FlagM 조건을 조회 결과에서만 찾음. 일괄입력 팝업 OK 로 편집 상태 행을 만든 뒤 재야 함(저장 안 함) |
| V-4c3670c9 | 엔진 | 검사기공백 | K3 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | T1 | Doc/e2e/specs/_verify.spec.ts K3 | K3 조작 시험이 메인 그리드만 잼(증거 '미포함: 팝업 그리드'). 팝업 그리드 Ctrl+클릭·F5·No. 칸 측정 추가 |
| V-04302ccf | 엔진 | 검사기공백 | K3 | [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | T1 | Doc/e2e/specs/_verify.spec.ts K3 | K3 조작 시험이 메인 그리드만 잼(증거 '미포함: 팝업 그리드'). 팝업 그리드 Ctrl+클릭·F5·No. 칸 측정 추가 |
| V-cbcda052 | 엔진 | 검사기공백 | K3 | [결함 유형 묶음 K3-G01 · 1건] 그리드 Ctrl+클릭 다중 선택(팝업 그리드 포함) | T1 | Doc/e2e/specs/_verify.spec.ts K3 | K3 조작 시험이 메인 그리드만 잼(증거 '미포함: 팝업 그리드'). 팝업 그리드 Ctrl+클릭·F5·No. 칸 측정 추가 |
| V-6cf2af49 | 엔진 | 검사기공백 | K3 | [결함 유형 묶음 K3-G02 · 2건] 조회 단축키(F5) 실행 | T1 | Doc/e2e/specs/_verify.spec.ts K3 | K3 조작 시험이 메인 그리드만 잼(증거 '미포함: 팝업 그리드'). 팝업 그리드 Ctrl+클릭·F5·No. 칸 측정 추가 |
| V-729c8d58 | 엔진 | 검사기공백 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | T1 | Doc/e2e/specs/_verify.spec.ts K3 | K3 조작 시험이 메인 그리드만 잼(증거 '미포함: 팝업 그리드'). 팝업 그리드 Ctrl+클릭·F5·No. 칸 측정 추가 |
| T-2c20a3fc | 엔진 | 검사기공백 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | 결정 | - | 같은 결정(R3-D2). 대조표 17행 SP 표기 |
| T-fad117f6 | 엔진 | 검사기공백 | F4 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP | 결정 | - | 같은 결정(R3-D2). TO-BE 가 P_SCM0002_GET_ITEM_BY_DIVISION_POPUP 을 부르지 않음 |
| T-52d59336 | 엔진 | 검사기공백 | DB-SYN | PR_GET_MNU_BTN_AUTH | P2b | tools/Harness/verify/syn_check.py | 공용 권한 SP 시노님·객체 상태를 재는 경로 없음 |
| T-6b9a8ce8 | 엔진 | 검사기공백 | F4 | PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | T2 | Doc/e2e/specs/_trace.spec.ts F4 | 입력용 SP 는 일괄입력 팝업 OK 때만 불림. 팝업 Input → From Site → Find → 행 선택 → OK 시나리오 없음 |
| T-0caf6c62 | 엔진 | 검사기공백 | E4 | MSG00031 | T2 | Doc/e2e/specs/_trace.spec.ts 팝업 Delete 경로 | FindDelete 경로 메시지 시나리오 없음(일괄삭제 팝업 OK → 삭제 SP → MSG00031) |
| T-4677b9e5 | 엔진 | 검사기공백 | E4 | MSG00284 | T2 | Doc/e2e/specs/_trace.spec.ts 팝업 Delete 경로 | 같은 원인(MSG00284) |
| T-d6ad4a4e | 엔진 | 검사기공백 | G4 | btnDelete | T2 | Doc/e2e/specs/_trace.spec.ts G4 BTN | popup_args 에 btnDelete_Click 행 2건 있음(host_label 빈 값 · 인자 원천 "D"·sDivision_id). 기능 단추로 여는 팝업을 조회조건 칸 단추로만 찾음 |
| EG-6cc339e1 | 결정 | 판단 | H6 | SCP0028 팝업 SCM0002_ShipmentLotSizePopup BTN:Input COUNT | 결정 | - | 담당 결정(지난 라운드 D6 건수 표시) |
| EG-273588ca | 결정 | 판단 | M3 | SCP0028 팝업 SCM0002_ShipmentLotSizePopup BTN:Input DATA | 결정 | - | 담당 결정(지난 라운드 D6 DATA). T2 일괄입력 팝업 시나리오가 From Site 를 채우면 같이 잼 |
| V-c346a4a2 | 엔진 | AI검토:검사기오판 | H10 | SCP0028 시나리오 [자동] 편집 중 Input 실행 → MSG00680(DM-52 일반 규칙) | P2a | tools/Harness/verify/gen_expect.py P15 | DM-52 시나리오를 AS-IS 편집 중 차단 분기가 없는 버튼(btnInput)에도 만듦 |
| V-5d06fca9 | 엔진 | AI검토:검사기오판 | B6 | 조회조건 Valid | P2b | tools/Harness/verify/judge.py B6 | 조회조건 기준표 행 0 화면에서 AS-IS 컨트롤 사실(combo_src DataBind isAll)로 기대값을 만들지 않음 |
| V-480372c9 | 엔진 | AI검토:검사기오판 | G5 | popItem.Form_Load("D", sDivision_id.ToString()) | P2b | tools/Harness/verify/popup_args_check.py | AS-IS 고정 플래그(_action_flag D·I)를 TO-BE 상태값(setBatchMode → mode prop) 전달로 읽지 못함 |
| V-86b2f489 | 엔진 | AI검토:검사기오판 | G5 | popItem.Form_Load("I", sDivision_id.ToString()) | P2b | tools/Harness/verify/popup_args_check.py | 같은 원인(I 플래그) |
| T-653f1a5d | 엔진 | AI검토:검사기오판 | A6 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION | P2b | tools/Harness/verify/sort_check.py A6 대상 | AS-IS 화면 경로에 없는 SP(SCM0002_GET_MATERIAL_BY_DIVISION)를 A6 대상에 넣음 |
| T-6dc0e2d5 | 엔진 | AI검토:검사기오판 | A6 | PR_GET_MNU_BTN_AUTH | P2b | tools/Harness/verify/sort_check.py A6 대상 | 그리드에 표시하지 않는 공용 권한 SP(PR_GET_MNU_BTN_AUTH) 정렬 대상 판별(CR-075 ③ 확인) |
| T-8ef356b6 | 엔진 | AI검토:검사기오판 | M4 | btnInput | P1 | tools/Harness/verify/mapping_trace.py(TRACE 행 생성) | AS-IS 팝업 연결 없는 요소(조회조건 체크 목록 콤보·숨김 칸·기능 버튼)에 팝업 규칙 G5·H6·M4 행을 만듦. AS-IS 원문에서 팝업 연결 여부 재확인 뒤 대상 판별 추가 |
| T-2a9cd623 | 엔진 | AI검토:검사기오판 | M4 | btnDelete | P1 | tools/Harness/verify/mapping_trace.py(TRACE 행 생성) | AS-IS 팝업 연결 없는 요소(조회조건 체크 목록 콤보·숨김 칸·기능 버튼)에 팝업 규칙 G5·H6·M4 행을 만듦. AS-IS 원문에서 팝업 연결 여부 재확인 뒤 대상 판별 추가 |
| T-449b82ac | 엔진 | AI검토:검사기오판 | H6 | clbFromSite / From Site | P1 | tools/Harness/verify/mapping_trace.py(TRACE 행 생성) | AS-IS 팝업 연결 없는 요소(조회조건 체크 목록 콤보·숨김 칸·기능 버튼)에 팝업 규칙 G5·H6·M4 행을 만듦. AS-IS 원문에서 팝업 연결 여부 재확인 뒤 대상 판별 추가 |
| T-247bdc3c | 엔진 | AI검토:검사기오판 | G5 | clbFromSite / From Site | P1 | tools/Harness/verify/mapping_trace.py(TRACE 행 생성) | AS-IS 팝업 연결 없는 요소(조회조건 체크 목록 콤보·숨김 칸·기능 버튼)에 팝업 규칙 G5·H6·M4 행을 만듦. AS-IS 원문에서 팝업 연결 여부 재확인 뒤 대상 판별 추가 |
| T-5bb8509f | 엔진 | AI검토:검사기오판 | M4 | clbFromSite / From Site | P1 | tools/Harness/verify/mapping_trace.py(TRACE 행 생성) | AS-IS 팝업 연결 없는 요소(조회조건 체크 목록 콤보·숨김 칸·기능 버튼)에 팝업 규칙 G5·H6·M4 행을 만듦. AS-IS 원문에서 팝업 연결 여부 재확인 뒤 대상 판별 추가 |
| T-0855373f | 엔진 | AI검토:검사기오판 | H6 | clbToSite / To Site | P1 | tools/Harness/verify/mapping_trace.py(TRACE 행 생성) | AS-IS 팝업 연결 없는 요소(조회조건 체크 목록 콤보·숨김 칸·기능 버튼)에 팝업 규칙 G5·H6·M4 행을 만듦. AS-IS 원문에서 팝업 연결 여부 재확인 뒤 대상 판별 추가 |
| T-57afcab2 | 엔진 | AI검토:검사기오판 | G5 | clbToSite / To Site | P1 | tools/Harness/verify/mapping_trace.py(TRACE 행 생성) | AS-IS 팝업 연결 없는 요소(조회조건 체크 목록 콤보·숨김 칸·기능 버튼)에 팝업 규칙 G5·H6·M4 행을 만듦. AS-IS 원문에서 팝업 연결 여부 재확인 뒤 대상 판별 추가 |
| T-84c5ee4c | 엔진 | AI검토:검사기오판 | M4 | clbToSite / To Site | P1 | tools/Harness/verify/mapping_trace.py(TRACE 행 생성) | AS-IS 팝업 연결 없는 요소(조회조건 체크 목록 콤보·숨김 칸·기능 버튼)에 팝업 규칙 G5·H6·M4 행을 만듦. AS-IS 원문에서 팝업 연결 여부 재확인 뒤 대상 판별 추가 |
| T-c7a94f1d | 엔진 | AI검토:검사기오판 | H6 | TRANS_MODE_CODE / Trans Mode | P1 | tools/Harness/verify/mapping_trace.py(TRACE 행 생성) | AS-IS 팝업 연결 없는 요소(조회조건 체크 목록 콤보·숨김 칸·기능 버튼)에 팝업 규칙 G5·H6·M4 행을 만듦. AS-IS 원문에서 팝업 연결 여부 재확인 뒤 대상 판별 추가 |
| T-3dbd9fe5 | 엔진 | AI검토:검사기오판 | G5 | TRANS_MODE_CODE / Trans Mode | P1 | tools/Harness/verify/mapping_trace.py(TRACE 행 생성) | AS-IS 팝업 연결 없는 요소(조회조건 체크 목록 콤보·숨김 칸·기능 버튼)에 팝업 규칙 G5·H6·M4 행을 만듦. AS-IS 원문에서 팝업 연결 여부 재확인 뒤 대상 판별 추가 |
| T-41bb3f1f | 엔진 | AI검토:검사기오판 | M4 | TRANS_MODE_CODE / Trans Mode | P1 | tools/Harness/verify/mapping_trace.py(TRACE 행 생성) | AS-IS 팝업 연결 없는 요소(조회조건 체크 목록 콤보·숨김 칸·기능 버튼)에 팝업 규칙 G5·H6·M4 행을 만듦. AS-IS 원문에서 팝업 연결 여부 재확인 뒤 대상 판별 추가 |
| EG-2644dff3 | 엔진 | AI검토:검사기오판 | H6 | SCP0028 팝업 SCM0002_ItembyDivisionPopup COND:Model BTN_ORDER | P2a | tools/Harness/verify/llm_review.py 반영 조건 | AI 검토가 검사기가 FAIL 을 낸 같은 룰(CR-005 OK → CLOSE)을 근거로 FAIL → PASS 로 바꿈. 실측 [Open, Search, Close, OK] = FAIL 이 맞음. 화면 결함은 결정 목록·FE 가이드 |
| EG-ac06e957 | 엔진 | AI검토:룰등록 | G4 | SCP0028 팝업 SCM0002_ItembyDivisionPopup COND:Model COND_LIST | 결정 | - | Model 팝업 COM0013 교체 = 화면 소스 주석 '사용자 지시 2026-10-08'(ShipmentLotSize.tsx:363·371)뿐. 일반 룰 근거 없음 → 화면 결정(R3-D2) |
| EG-bd80125c | 엔진 | AI검토:검사기오판 | MS1 | SCP0028 화면 고정 한글 {0}은 {1} 보다 클 수 없습니다. | P2a | tools/Harness/verify/i18n_static.py | 등록 코드 상수를 첫 인자로 받는 래퍼의 기본 문구를 고정 한글로 잡음 |

## 처리 결과(13:44, 다음 CheckList 판정은 미측정)

| 묶음 | 행 | T번호 | 고친 곳 | 다음 CheckList 에서 바뀔 판정 |
|---|---|---|---|---|
| P1 | T-247bdc3c, T-57afcab2, T-3dbd9fe5, T-449b82ac, T-0855373f, T-c7a94f1d, T-2a9cd623, T-8ef356b6, T-5bb8509f, T-84c5ee4c, T-41bb3f1f | T480 | tools/Harness/verify/mapping_trace.py popup_linkage, main NA 적용, to_ledger asis_ref | 미검증 → 해당없음(사본 원장 드라이런 11/11) |
| P2a | V-c346a4a2 | T485 | gen_expect.py DM-52 반복문 | FAIL 행 생성 안 됨 |
| P2a | EG-bd80125c | T486 | i18n_static.py wrap_default_code | 행 없음(i18n_static.csv 재생성에서 1행 빠짐) |
| P2a | EG-2644dff3 | T487 | llm_review.py same_rule_block | AI 반영 PASS → FAIL 유지. 화면 결함은 FE_GUIDE_20261120_1320.md G1, R3-D1 |
| P2b | T-653f1a5d, T-6dc0e2d5 | T488 | sort_check.py TO-BE 전용 SP(CR-075 ①③) | PASS(ORDER BY 확인), 해당없음(BE 매퍼 전용 Auth.xml:26) |
| P2b | T-52d59336 | T488 | syn_check.py ①-c | 미검증 → 통과 경로(syn_check.csv 재생성 OK) |
| P2b | V-5d06fca9 | T489 | judge.py B6 기준표 0행 AS-IS 사실 경로 | 미검증 → 통과 경로 |
| P2b | V-480372c9, V-86b2f489 | T489 | popup_args_check.py state_literal_trace | 판정필요 → 통과(popup_args.csv 재생성 2행 PASS) |
| P2b | V-8da88867 | T489 | golden.py sqllog_args, no_arg_source_note, judge.py A7 | 미검증 유지(사유 명시). T502 호출 기록이 생기면 실측. R3-D6 |
| T1 | V-4c3670c9, V-04302ccf, V-cbcda052, V-6cf2af49, V-729c8d58 | T496, T500 | _verify.spec.ts K3, tools/E2E/lib/popk3.ts, popk3run.ts | 미검증 → 실측(팝업 0행이면 사유 붙은 미검증) |
| T1 | V-db17a330 | T497 | _verify.spec.ts G8/G9 시험이 G2 행도 받음 | 미검증 → 실측 |
| T1 | V-99331be4 | T498 | _verify.spec.ts G5, popk3run.condPopupArgs | 미검증 → 실측 |
| T1·T2 | V-dd4f9db4 | T499 | tools/E2E/lib/condcol.ts, smoke-extra.ts condColForOpts, _trace.spec.ts 멀티선택 | 미검증 → 실측 |
| T2 | T-d6ad4a4e | T501 | _trace.spec.ts G4 기능 단추 | 미검증 → 실측 |
| T2 | T-6b9a8ce8 | T502, T506 | _trace.spec.ts 'BTN 팝업 경로', _verify.spec.ts CRUD 저장 SP 대상에서 _GET_ SP 제외 | 미검증 → 실측 |
| T2 | T-0caf6c62, T-4677b9e5, V-86e7f1e2, V-a89007be | T503, T504 | _trace.spec.ts 'BTN 팝업 경로' 삭제 분기(가짜 응답, 서버 미전송), W4 E4 넘김 | 미검증 → 실측(MSG00031 통과, MSG00284 오류 경로). R3-D5 |
| T2 | V-a99ddb18 | T505 | _trace.spec.ts H2, h2RuntimeEdit(쓰기 요청 차단 뒤 Save) | 미검증 → 실측 |
| 결정 | EG-ac06e957, T-fad117f6, T-2c20a3fc, EG-6cc339e1, EG-273588ca | - | 수정 없음 | 미검증·판정필요 유지(R3-D2, R3-D3, R3-D4) |

- 처리 못 한 행: 없음. 결정 행 5건은 결정 목록에만 적음
