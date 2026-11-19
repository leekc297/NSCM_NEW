# SCP0096 미검증 결정 목록 (2026-11-18)

| 행 | 규칙 | 정할 내용 | 근거 |
|---|---|---|---|
| EG-33c91716 | A1 | PKG_COM0000 빈 문자열 비교 5곳(Oracle 에서 항상 거짓)이 이 화면 조회 결과에 영향 있는지 · 결함이면 PKG 수정 대상 | [확인 대상] PKG_COM0000 Oracle 에서 항상 거짓인 빈 문자열 비교 5곳: P_MSG_TP_CD = '', P_OWNER_ID = '', p_project_code = '', p_search = '' |
| EG-365577cd | B8 | PKG_COM0000 Team 원천 OWNER→SSO_USER_INFO.DEPT_ID 경유 1곳(본문 837행)이 CR-019(SSPM DEPT_ID) 위반인지 | [확인 대상] PKG_COM0000 에 OWNER→SSO_USER_INFO.DEPT_ID 경유 후보 1곳(본문 줄 [837]) — Team 원천은 SITE_ITEM.DEPT_ID 만 |
| EG-ce8f8757 | G1 | PKG_COM0000 가드 없는 LIKE 2곳에서 NULL 행 탈락이 의도인지 | [확인 대상] PKG_COM0000 가드 없는 LIKE 2곳 — 칸이 NULL 인 행이 조건 때문에 탈락 가능: ['T.ATTRIBUTE2~v_org_upper_dept_id@1808', 'SA.SEGMENT4~A@2258'] |
| ES-450a8579 | G4 | 조회조건 라벨 Input Value·Day of the week 이 TO-BE 에서 Bulk Update 모달로 옮겨진 것을 TO-BE 룰로 인정할지(룰 원장 등록 여부) | 조회조건 라벨 일치 3 · 누락 2: Input Value, Day of the week, TO-BE 룰(라벨 변경 CR-092 · 필수 표시 CR-077 등) 해당 여부 확인 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |
| EG-46e1377f | I1 | 같은 문구 [EN] Saved successfully. 코드 MSG00002·MSG00606 중복 정리 여부 | [다국어 확인 필요] 같은 문구 다른 코드 · MSG00002,MSG00606 · '[EN] Saved successfully.' |
| EG-e3aded01 | I1 | 같은 문구 [EN] No data to save. 코드 MSG00152·MSG01042 중복 정리 여부 | [다국어 확인 필요] 같은 문구 다른 코드 · MSG00152,MSG01042 · '[EN] No data to save.' |
| EG-d98bd5c6 | N1 | SCM_MST_PLAN AS-IS 키 40/145790 이 TO-BE 에 없음 — 데이터 이관 누락인지 AS-IS 개발 DB 시험 행인지(11-15 SSP0015 시험 행 145790 기록 있음) | [확인 대상] SCM_MST_PLAN AS-IS 키 14826건 중 1건 TO-BE 에 없음: 40/145790 · 범위 = 화면 PKG 조건 값 5종(AS-IS 키 14826/20531건 · 범위 밖 0건 제외) |
| EG-85b47891 | N1 | SCM_MST_PROJECT AS-IS 키 3건(G-23-012 등) TO-BE 에 없음 — 이관 누락 여부 | [확인 대상] SCM_MST_PROJECT AS-IS 키 8468건 중 3건 TO-BE 에 없음: G-23-012/0000000001/82, G-23-013/0000000001/82, G-26-031/0000000001/82 |
| EG-a184f82b | N1 | SCM_MST_SITE_ITEM AS-IS 키 24건 TO-BE 에 없음 — 이관 누락 여부 | [확인 대상] SCM_MST_SITE_ITEM AS-IS 키 126627건 중 24건 TO-BE 에 없음: 82//ST00-P/EP096636PFBAD0D2, 82//ST00-P/EP096636PFBAD0D3, 82//ST00-P/EP096636PFB |
| EG-7b487474 | C1 | Plant Site 연쇄 후보 TO-BE 표시값 '?INFAC_40' 1건 — TO-BE 데이터 문자 깨짐인지 | TO-BE 표시값 1건을 AS-IS 코드로 환산 못 함(표현 NAME) 예: ['?INFAC_40'] · TO-BE 19건 · AS-IS 18건 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |
| EG-807044ce | J1 | SCP Planner·Div 40 계정의 후보 다수 기본 선택(DM-65) — TO-BE 빈값이 결함인지 TO-BE 룰인지 | 기대 후보 다수 — 기본 선택 · 실제 빈값 · AS-IS DM-65 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |
| V-4ccf9d80 | A7 | 메인 조회 D_20261121 같은 키 1행 값 차이(CN00254300_40-P 'Y'↔'N') — 데이터 차이(CR-105)로 볼지 | 공통 컬럼 371 중 공란 컬럼 0 · 확인 필요 1 — D_20261121: 같은 키(plantsiteid) 18행 중 1행 값 다름(6%) 예: CN00254300_40-P: 'Y'↔'N' → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |

사람 담당 8행(스냅샷 승인 5 · 시험 계정 3)은 Doc/verify/SCP0096/unverified_triage.md 담당 사람 절 참고.

## 검증 중 발견한 TO-BE 결함 (2026-11-18 17:5x 실측)
- PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP: 조회 기간이 약 990일을 넘으면 실패(ORA-00604 / ORA-01003). 실측(사내 ZIOUI1 직접 실행, Div 81 · Plant ALL · 끝 20271114): 시작 20251118(727일) 성공 컬럼 733 · 20250301(989일) 성공 컬럼 995 · 20250101(1048일) 실패 · 20241118(1092일) 실패. 일자별 컬럼이 Oracle 1000컬럼 한도를 넘는 것으로 보임(미확인). AS-IS SCP0096_GET_SHIPMENT_WORKING_DAY_OSP 는 같은 인자로 조회됨(차등 검증 #23~#29 ERR_TOBE). 조회 기간 상한을 둘지(AS-IS 화면 제한 여부 미확인) PKG 를 고칠지 결정 필요.
- J1 자동 선택(EG-ad36724d · EG-c63a0d42): SCM Viewer 계정 Division 후보 1개(40 · 82)인데 TO-BE 빈값 · AS-IS DM-65 는 자동 선택 → FAIL 로 판정됨.

## 확인 작업 결과 (2026-11-18 20:20~20:26 · 사내 ZIOUI1·AS-IS 개발 DB 조회)

| 행 | 규칙 | 확인 결과 | 처리 |
|---|---|---|---|
| EG-33c91716 | A1 | 빈 문자열 비교 5곳은 P_COM0004·P_COM0005·P_COM0006·P_COM0007·P_COM0012 안에 있음. 화면 호출 프로시저는 P_SCM0001_GET_SCP_MONTH_PERIOD(2697행)·P_SCP0009_GET_SHEET_CALENDAR_3SPAN(2899행) 2개(proc_meta, FE 상수) | 화면 대상 아님. db_ref_check 가 공용 패키지는 호출 프로시저 구간만 보게 수정 → EMPTY_EQ PASS |
| EG-365577cd | B8 | 837행 = P_COM0006_GET_OWNER_DATA | 위와 같음. 호출 구간에 SCM_MST_SITE_ITEM 참조 없음 → TEAM_SRC 행 없음(판정 대상 아님) |
| EG-ce8f8757 | G1 | 1808행 = P_COM0009_GET_TEAM_POPUP, 2258행 = P_SCP0121_GET_SEARCH_INFO(plan-group-dashboard 등 다른 화면 소스만 사용) | 위와 같음 → LIKE_NULL PASS |
| EG-46e1377f | I1 | 화면 사용 MSG00002(KO '성공적으로 저장되었습니다.'). MSG00606 은 KO '저장되었습니다.' 로 다른 메시지, EN 만 같음 | i18n_static 이 화면이 묶음 중 1개만 쓰고 KO 가 다르면 제외 → DUP 0 |
| EG-e3aded01 | I1 | 화면 사용 MSG00152(KO '저장할 데이터가 없습니다.'). MSG01042 는 KO '변경/추가된 데이터가 없습니다.' | 위와 같음 |
| EG-7b487474 | C1 | '?' 는 검사기 표시(combo_oracle.py:809 AS-IS 이름 대응 없음). TO-BE SCM_MST_SITE PL01279700_40-P 'INFAC_40' 문자 정상(DUMP AL32UTF8 49,4e,46,41,43,5f,34,30 · 2026-09-08 등록), AS-IS 에 이 행 없음 | TO-BE 에만 있는 데이터 행 · 판정필요(CR-101) |
| EG-d98bd5c6 | N1 | AS-IS SCM_MST_PLAN 40/145790 = ATTRIBUTE15 'ASISLIVE_TEST_20261115'(11-15 시험 행) | master_sweep 이 AS-IS 시험 표시 행 제외 → PASS |
| EG-cac7a1b1 | N1 | AS-IS SCM_MST_PLAN_DETAIL 40/1/Y/SP/101/145790/1 = 같은 시험 행 1건 | 시험 행 제외 후 12 → 11건 남음. 나머지 11건(1458 계열 등)은 이관 누락 여부 결정 필요 |

판정 반영 시점: 원장(verify_ledger.csv) 행은 다음 CheckList 실행 때 바뀜. 검사기 결과 파일(db_ref.csv · i18n_static.csv · master_sweep.csv)은 20:2x 재실행으로 갱신됨.

## 사용자 결정 반영 (2026-11-18 20:3x)
- J1 EG-807044ce: FAIL 확정. Doc/verify/SCP0096/static_verdicts.csv 행 ID + 대상 정규식 2줄(행 ID 가 바뀐 실행 대비). SCM Viewer 2건(EG-ad36724d, EG-c63a0d42)과 같은 원인.
- G4 ES-450a8579: TO-BE 룰 CR-112 등록(tools/Harness/rules/confirmed_requirements.csv · tobe_rule_kind.csv) · static_verdicts.csv PASS. 근거 ShipmentWorkingDayOspInputModal.tsx:92~.
- 원장 반영은 다음 CheckList 실행 때(judge.py 정적 판정 단계). 현재 원장 대조: 두 행 모두 static_verdicts 와 일치 확인.


## 사용자 결정 반영 (2026-11-18 22:53, N1 3건)

사용자 지시 'N1 3건은 이관 누락으로 확인' 을 static_verdicts.csv 에 FAIL 로 등록함. 22:53 master_sweep 재측정값이 20:2x 값과 같음.

| 행 | 표 | 누락 키 | 판정 |
|---|---|---|---|
| EG-cac7a1b1 | SCM_MST_PLAN_DETAIL | 11건(PLAN_ID 1458 계열, Div 40·81·81_UC·82·EE) | FAIL(이관 누락) |
| EG-85b47891 | SCM_MST_PROJECT | 3건(G-23-012, G-23-013, G-26-031, Div 82) | FAIL(이관 누락) |
| EG-a184f82b | SCM_MST_SITE_ITEM | 24건(Div 82, ST00-P, EP096636PFBA* 품목) | FAIL(이관 누락) |

- 키 전체 38건: n1_migration_gap_keys.csv
- 행 ID 가 바뀐 실행에 대비해 대상 이름 정규식 줄 3개 같이 등록함
- 이관 후 키가 채워지면 측정 결과가 PASS 가 되어 이 판정은 적용되지 않음
- 데이터 이관 실행은 이번 작업 범위 아님(정합검증 단계 보완 금지)

## 사용자 결정 반영 (2026-11-18 23:0x, A7 · 계정 2건)

### A7 V-4ccf9d80
- 판정필요로 둠. Doc/verify/_user_verdicts_direct.csv 에 등록함(다음 CheckList 때 반영)

### 계정 2건 확인 결과

| 행 | 확인 내용 | 결과 |
|---|---|---|
| EG-c5e0731c (A6 계정쌍) | SCM_MST_TITLESET_USER PROGRAM_ID=SCP0096 행 수: AS-IS 0행, TO-BE 0행. PKG_SCP0096 참조 0곳. 칸 설정 버튼 없음 | 칸 설정이 없는 화면이라 보유 계정이 있을 수 없음. 검사기를 고쳐 NA 로 판정함 |
| EG-9d49925f (J4 무권한 첫 화면) | 사내 ZIOUI1 GUEST 그룹만 쓰는 계정 96명. 공용 계정 'Guest' 를 명부(tools/E2E/users.json guestAccount)에 등록함. BE 로그인 200 | 측정 결과 FAIL. 로그인 뒤 첫 화면이 Home 이고 안내창만 뜸. 안내창 확인 뒤에도 Home |
| V-f95f27ac (J4 결함원장 DM-247) | 같은 결함을 재는 EG-9d49925f 결과를 따름 | 다음 CheckList 에서 FAIL 로 바뀜 |

23:07 재측정 결과(임시 폴더, 작업 결과 파일은 그대로 둠):
- EG032 NA: '이 화면 칸 설정 없음: AS-IS SCM_MST_TITLESET_USER PROGRAM_ID=SCP0096 0행 · TO-BE 0행 · 화면 PKG 참조 0곳'
- EG380 FAIL: 'URL /view/home · 안내창 You are not authorized to NSCM. Apply for permission. · 안내창 확인 뒤 URL /view/home'
- 결함을 일부러 만든 상태(EG_MUT=guest_home)에서도 FAIL 확인

### EG380 FE 수정 가이드 (DB MODE 라 직접 고치지 않음)
- 문제: 권한이 없는 사용자(GUEST 그룹만 보유)가 로그인하면 Home 화면과 안내창만 나옴. 권한 신청 화면(Auth Request, SYS0011)이 열리지 않음
- 기준: 결함 DM-247(2026-09-22 완료 처리) '권한 미보유 사용자가 로그인할 경우 Auth Request 화면이 메인에 보여지도록 적용'. AS-IS 는 미등록 사용자를 'Guest' 사용자로 로그인시킴(GSCM/01.Framework/GSCM.Windows.Forms/LogInForm.cs:163)
- 고칠 곳: nscm-fe/apps/web/src/layout/useGuestNotice.ts:24~28
- 변경 전: 게스트이면 안내창(MSG00023)만 띄움
- 변경 후: 안내창을 닫으면 권한 신청 화면(SYS0011)을 탭으로 연다. GUEST 그룹 메뉴에 SYS0011 사용 'Y' 로 이미 있음(SCM_ADM_USER_GR_MNU_MPG_M)
- 확인: 'Guest' 로 로그인 → 안내창 확인 → 주소가 /view/SYS0011 이고 Auth Request 화면이 보이는지 확인. 검사 EG380 이 PASS 로 바뀌는지 확인
- 화면 공통 동작이라 SCP0096 외 전 화면 CheckList 의 EG380 행이 같은 결과를 따름


## 라운드 4 결정 목록 (2026-11-19 00:2x · CheckList v33 원장 기준)

| 행 | 정할 내용 | 근거 |
|---|---|---|
| V-0d52121b, V-06af9fa9, V-74ab8496 | 스냅샷 골든 승인(snap_approve.py) 여부 | snap_validate 00:14 조회조건_Div_40 OK, 버튼_Div_40 OK(EDIT 없음 = CR-084·CR-093, Search 는 조회영역 버튼), 헤더 OK(수신 추가 칸 = 일자·주 머리글) · 누락·순서 차이 0 |
| V-b36b0750, V-308cf4c5 | 화면샷 1920·1366 골든 승인 여부 | snap_validate NA(화면샷 기대 없음 · 사람 확인) · 자동 후보 png 와 865픽셀(1%) 차이 |
| V-d8f314e2, V-9e29a0e2 | Sum 체크박스(V-eb856b69 FAIL) 보완 뒤 측정 | 선행 결함. AS-IS cs:355 W_ 칸 표시 = chkSum · FE 가이드 FE_GUIDE_20261119_0017.md 1번 · fixlist FX-SCP0096-003 보류(가이드) |
| T-8cdb4616 | 대조표 D00-3-020 문장 정정 | AS-IS cs:400~407 은 W_·M_ 합계 칸 잠금(SetLockSumColumn). 대조표는 제목 시트 잠금으로 적음 · FE 가이드 3번 |
| T-428f2fa6 | 더블클릭 칸 접기·펼치기(SetDblClickColumnShowHide, cs:817~819) 미이식을 유지할지 | 대조표 사유 '부가기능 미이식 · 향후 재설계' 에 룰·지시 근거 없음 · FE 가이드 4번 |
| V-70799fba | 다음 CheckList 가 FAIL(TO-BE 빈값 거부 · AS-IS 빈값 → 0 저장)로 내면 화면 보완 여부 | AS-IS cs:568~569 · 23:2x 측정 '7' 유지 · FE 가이드 2번 |


## 라운드 5 결정 목록 (2026-11-19 01:0x · recheck 원장 00:59 기준 · 6건)

| 행 | 정할 내용 | 근거 |
|---|---|---|
| V-0d52121b, V-06af9fa9, V-74ab8496 | 스냅샷 골든 승인(snap_approve.py) 여부 | snap_validate 01:05 OK 3건(누락·순서 차이 0) |
| V-b36b0750, V-308cf4c5 | 화면샷 1920·1366 골든 승인 여부 | snap_validate 01:05 NA(화면샷 기대 없음) · 후보 png 와 865픽셀(1%) 차이 |
| V-d8f314e2, V-9e29a0e2 | Sum 체크박스(V-eb856b69 FAIL) 보완 뒤 측정 | 선행 결함 · FE_GUIDE_20261119_0106.md 1번 · fixlist 보류(가이드) |
| T-8cdb4616 | 대조표 D00-3-020 문장 정정 | AS-IS cs:400~407 합계 칸 잠금 · FE 가이드 3번 |
| T-428f2fa6 | 더블클릭 칸 접기·펼치기 미이식 유지 여부 | 사유에 룰·지시 근거 없음 · FE 가이드 4번 |
| V-70799fba | 다음 CheckList 가 FAIL(빈값 거부 · AS-IS 빈값 → 0)로 내면 화면 보완 여부 | 같은 칸 키보드 0·6 입력 성공, 빈값만 7 유지(00:3x) · AS-IS cs:568~569 · FE 가이드 2번 |

## 라운드 10 결정 목록 (2026-11-19 10:0x · CheckList v38)

| 행 | 정할 내용 | 근거 |
|---|---|---|
| V-0d52121b | 조회조건 라벨 'Div.' → 'Div' 변경을 인정할지. 인정하면 다음 CheckList 에서 PASS(골든 09:59 교체됨) | 08:54 골든 'Div.' · 09:28 실측 'Div' · snap_validate AS-IS 대조 OK · FE 병합 0건, 변경 원천 미확인 |
| T-8cdb4616 | D00-3-020 합계 칸 잠금 제외 사유 정정(AS-IS cs:400~407 잠금 있음) | 판정필요 · FE 가이드 3번(DB MODE) |
| T-428f2fa6 | D00-3-032 더블클릭 칸 접기 미이식 인정 여부 | 판정필요 · 룰·지시 근거 없음 · FE 가이드 4번 |
| V-d8f314e2, V-9e29a0e2 | Sum 체크박스 보완 | FAIL(선행 결함 종속 V-eb856b69) · FE 가이드 1번 |
