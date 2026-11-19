# 검사기 회귀 대조 SCP0096 — 기준 2026-11-06 16:22 (945행) ↔ 현재 2026-11-19 10:02 (1675행)

- 악화(기준 비FAIL → 현재 FAIL): **9** (그중 승인 스냅샷 0) · 개선(FAIL → 비FAIL): 0 · 그 외 변경: 882 · 사용자 판정 자동 승인 5 · 기준에만 있는 행 48 · 새 행 778
- 승격 대기(received): Doc\verify\_checker_golden\SCP0096.received.csv — 확인 뒤 `checker_regress.py SCP0096 --approve --by 이름`

## 악화 — 검사기 수정이 허위 FAIL 을 만들었는지 확인

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-9e29a0e2 | D3 | spreadInfo.LockColumn | NOT_RUN | FAIL | [선행 결함 종속 V-eb856b69] AS-IS M_, W_ 칸은 chkSum.Checked 일 때 표시(SCP0096_Shipment_Working_Day_OSP.cs:355) |  |
| V-f95f27ac | J4 | Home / Auth Request 메뉴 | NOT_RUN | FAIL | 같은 결함 DM-247 측정 행 EG-a24f3b24 따름(FAIL): 기대 Auth Request(권한 신청) 화면 메인 — DM-247 · 실제 URL /view/home ·  |  |
| V-b26007f0 | N1 | [DMF0003 결함 일반화] AS From Site 공란 데이터 | NOT_RUN | FAIL | 규칙 N1 판정 3행 중 FAIL 1 · 판정필요 0 · 미검증 0 — [EG-a184f82b] SCP0096 기준정보 키 존재 SCM_MST_SITE_ITEM: [정적 판정] [ |  |
| V-56781cf1 | N1 | [DMF0082 결함 유형] 컬럼셋팅 VERSION 컬럼 · AS FROM SITE 컬럼 | NOT_RUN | FAIL | 규칙 N1 판정 3행 중 FAIL 1 · 판정필요 0 · 미검증 0 — [EG-a184f82b] SCP0096 기준정보 키 존재 SCM_MST_SITE_ITEM: [정적 판정] [ |  |
| V-d99fa380 | N1 | [DMF0082 결함 유형] Measure 셋팅(미사용 Measure · VMI 메저 · MKT FCST A | NOT_RUN | FAIL | 규칙 N1 판정 2행 중 FAIL 1 · 판정필요 0 · 미검증 0 — [EG-cac7a1b1] SCP0096 기준정보 키 존재 SCM_MST_PLAN_DETAIL: [정적 판정] |  |
| V-07d772e7 | N1 | [DMF0004 결함 유형] Sales Site 조회조건 표시값 | NOT_RUN | FAIL | 규칙 N1 판정 3행 중 FAIL 1 · 판정필요 0 · 미검증 0 — [EG-a184f82b] SCP0096 기준정보 키 존재 SCM_MST_SITE_ITEM: [정적 판정] [ |  |
| V-e8aeb458 | N1 | [DMF0082 결함 유형] MKT_FCST↔Unit Price(LOC) 조건부 필수·Plant Site I | NOT_RUN | FAIL | 규칙 N1 판정 3행 중 FAIL 1 · 판정필요 0 · 미검증 0 — [EG-a184f82b] SCP0096 기준정보 키 존재 SCM_MST_SITE_ITEM: [정적 판정] [ |  |
| V-6ff00758 | N1 | [DMF0082 결함 유형] Div 81 컬럼·Measure 구성(Project·Cust FCST 등) | NOT_RUN | FAIL | 규칙 N1 판정 3행 중 FAIL 1 · 판정필요 0 · 미검증 0 — [EG-85b47891] SCP0096 기준정보 키 존재 SCM_MST_PROJECT: [정적 판정] [사용 |  |
| V-48b7999b | N1 | [DMF0035 결함 유형] Div별 컬럼·Measure(End Cust(Report)·Project(S R | NOT_RUN | FAIL | 규칙 N1 판정 3행 중 FAIL 1 · 판정필요 0 · 미검증 0 — [EG-85b47891] SCP0096 기준정보 키 존재 SCM_MST_PROJECT: [정적 판정] [사용 |  |

## 개선

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|

## 그 외 변경

| row_id | 규칙 | 대상 | 기준 | 현재 | 현재 증거 | 승인자 |
|---|---|---|---|---|---|---|
| V-36c8d524 | F8 | SCP0096 저장 감사 필드 | NOT_RUN | PASS | 변경 행 5건 감사 칸 정상(생성 칸 불변 · 수정 칸 갱신 · LAST_UPDATED_BY = 저장 계정) · 계정 minyonglee1 · 기준 시각 2026-11-19 09: |  |
| V-7a4e6087 | F7 | SCP0096 저장 연계 테이블 | NOT_RUN | PASS | AS-IS SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 대상 표 SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, SCP_MST_SHIPM |  |
| V-921d237e | F6 | SCP0096 저장 행 수 불변 | NOT_RUN | PASS | 수정 저장 1회 DB 전후 대조 — SCP_MST_SHIPMENT_WORKING_DAY_OSP(키 DIVISION_ID,PLANT_SITE_ID,MEASURE): 추가 0 · 삭제 |  |
| V-1b71768b | F8 | SCP0096 수정 감사 컬럼 | NOT_RUN | PASS | 변경 행 5건 감사 칸 정상(생성 칸 불변 · 수정 칸 갱신 · LAST_UPDATED_BY = 저장 계정) · 계정 minyonglee1 · 기준 시각 2026-11-19 09: |  |
| V-12687ffe | F7 | SCP0096 저장 연계·이력 표 | NOT_RUN | PASS | AS-IS SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 대상 표 SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, SCP_MST_SHIPM |  |
| V-252a8840 | E1 | SCP0096 입력검증 음수 WORKING_TIME_DEFAULT | NOT_RUN | PASS | WORKING_TIME_DEFAULT r1 원값 '7' · '-1' 입력 뒤 칸 '7' · 저장 요청 없음 · 문구 '저장할 데이터가 없습니다.' |  |
| V-06bf0ac0 | H11 | SCP0096 화면 | NOT_RUN | PASS | 조회 클릭 → 로딩 표시 관측 2회(100ms 폴링) · 응답 802ms · 응답 1.5초 뒤 표시 없음 · 조회 전 상시 요소 2개 제외 |  |
| V-59d2ffab | H12 | SCP0096 화면 | NOT_RUN | PASS | 고정 컬럼 6개 [DIVISION_ID, PLANT_SITE_ID, PLANT_SITE_NAME, WORKING_TIME_DEFAULT, LAST_INPUT_DATE, MEASUR |  |
| V-5c6d415a | J3 | SCP0096 화면 | NOT_RUN | NA | AS-IS 잠금 규칙에 권한 그룹(GROUP) 조건이 있는 컬럼 없음 — 권한별 편집 구간 없음 |  |
| V-6ff7c5a4 | F10 | PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP | NOT_RUN | PASS | 본문+하위 2개 호출에 COMMIT/TRUNCATE/DDL/DBMS_STATS/자율 트랜잭션 0건 · 하위 호출 PR_SCM_SYS_LOG_BATCH;PKG_SCP0096.P_SP |  |
| V-b713388c | A6 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | NOT_RUN | 판정필요 | [SORT 기준 차이 → 판정필요] 정렬 기준이 AS-IS 와 다름 — 결함 여부는 사람이 판정(사용자 지시 2026-10-30) · AS-IS ORDER BY [SORT_ORDE |  |
| V-a007d973 | A6 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | NOT_RUN | 판정필요 | [SORT 기준 차이 → 판정필요] 정렬 기준이 AS-IS 와 다름 — 결함 여부는 사람이 판정(사용자 지시 2026-10-30) · AS-IS ORDER BY [SORT_ORDE |  |
| V-6393dee9 | A6 | DM0003_GET_BUCKET_TYPE_CODE | NOT_RUN | NA | 정렬 비교 대상 아님 — AS-IS ORDER BY [DISPLAY_SEQ] · 짝 표: TO-BE 대응 없음 — AS-IS 결과 미사용(SCP0096_Shipment_Workin |  |
| V-33cc7445 | A6 | SCP0009_GET_SHEET_CALENDAR_3SPAN | NOT_RUN | PASS | AS-IS ORDER BY [SORT_ORDER_NO] ↔ TO-BE PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN [SORT_ORDER_NO |  |
| V-9ff07d45 | A7 | DM0003_GET_BUCKET_TYPE_CODE | NOT_RUN | NA | 비교 대상 아님 — 짝 표: TO-BE 대응 없음 — AS-IS 결과 미사용(SCP0096_Shipment_Working_Day_OSP.cs:136 dtBucketType = Ge |  |
| V-63f41719 | A7 | SCP0009_GET_SHEET_CALENDAR_3SPAN | NOT_RUN | PASS | 공통 컬럼 6 중 공란 컬럼 0 · 확인 필요 0 — 전 컬럼 채움 이상 없음 |  |
| V-2ff88be6 | B1 | 조회조건 Div | NOT_RUN | PASS | 조회조건 Div 후보 8건 · 빈 항목 0 |  |
| V-cf76f5b2 | B2 | 조회조건 Div | NOT_RUN | PASS | 조회조건 Div 후보 8건 · 중복 0 |  |
| V-55c97f16 | B3 | 조회조건 Div | NOT_RUN | PASS | [화면 초기(선택 Div=81)] 원문 ORDER BY 있음·정렬 키 해석 불가 — AS-IS 반환 순서와 일치: TO-BE ['81', '40', '82', '81_UC', '8 |  |
| V-e1a1ffe9 | B4 | 조회조건 Div | NOT_RUN | PASS | [화면 초기(선택 Div=81)] 후보 8건 집합 일치 · 원천 UP_FX_GetCommonDataList_SCP Division @InitControls (SCP0096_Ship |  |
| V-5dedc1c3 | B6 | 조회조건 Div | NOT_RUN | PASS | 조회조건 Div: 다중선택 기대 false/화면 false · ALL 기대 false/화면 false · 기대 원천 AS-IS 원문 UsrCombo |  |
| V-a241478b | B7 | 조회조건 Div | NOT_RUN | PASS | NA: (a) 저장 SP SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 대상 SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, SCP_MST |  |
| V-7a825d8e | G1 | 조회조건 Div | NOT_RUN | PASS | [단일선택 Div] '81 Automotive Battery' → 2행 · DIVISION_ID 조건 밖 0 OK ／ '40 Mobility & IT Battery' → 19행 · |  |
| V-77ff74c9 | G2 | 조회조건 Div | NOT_RUN | NA | Div 단일 선택 콤보 — ALL/다중 사양 대상 아님 |  |
| V-5814a68d | G4 | 조회조건 Div | NOT_RUN | PASS | 기준 순서 1번째 'Div' — 화면 1번째 (화면 순서: Div. → Plant Site → Period) · 기준표 순서(CR-071) |  |
| V-aaf5204f | G7 | 조회조건 Div | NOT_RUN | PASS | [화면 초기(선택 Div=81)] AS-IS 표시 NAME (UsrCombo DisplayMember=NAME @SCP0096_Shipment_Working_Day_OSP.cs:1 |  |
| V-f03c037f | H5 | 조회조건 Div | NOT_RUN | PASS | 기준 명칭 'Div' — 화면 라벨 일치 nscm-fe/features/supply/src/pages/shipment-working-day-osp/components/Shipmen |  |
| V-f360d4f6 | C1 | 조회조건 Div | NOT_RUN | PASS | 상속(TRACE T-f68979f8): 'Div' → '40 Mobility & IT Battery' 변경 · 콤보 재요청 1건 · 하위 clbPlantSite(사전 선택 'CS- |  |
| V-7e604b02 | J1 | 조회조건 Div | NOT_RUN | PASS | Division 후보 8건 [81 Automotive Battery, 40 Mobility & IT Battery, 82 ESS Battery, 81_UC Automotive Ba |  |
| V-d01b01e7 | B1 | 조회조건 Plant Site | NOT_RUN | PASS | 조회조건 Plant Site 후보 2건 · 빈 항목 0 |  |
| V-0943c85f | B2 | 조회조건 Plant Site | NOT_RUN | PASS | 조회조건 Plant Site 후보 2건 · 중복 0 |  |
| V-b76a3794 | B3 | 조회조건 Plant Site | NOT_RUN | NA | [화면 초기(선택 Div=81)] AS-IS 원천에 정렬 근거(ORDER BY) 없음 — 순서 기준 없음 · 원천 UP_FX_GetCommonDataList_SCP PlantByD |  |
| V-9cbddc43 | B4 | 조회조건 Plant Site | NOT_RUN | PASS | [화면 초기(선택 Div=81)] 차이 1건 모두 데이터 차이(AS-IS DEV↔사내 시점) — 조건 동일 · AS-IS만 0 [] · TO-BE만 1 ['AU000062_81-P |  |
| V-9f450894 | B6 | 조회조건 Plant Site | NOT_RUN | PASS | 조회조건 Plant Site: 다중선택 기대 true/화면 true · ALL 기대 true/화면 true · 기대 원천 AS-IS 원문 UsrCheckedList |  |
| V-3a399051 | B7 | 조회조건 Plant Site | NOT_RUN | PASS | NA: (a) 저장 SP SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 대상 SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, SCP_MST |  |
| V-958874b6 | G1 | 조회조건 Plant Site | NOT_RUN | PASS | [멀티선택 Plant Site] 'TEST' 1개 선택 조회 → 1행 · PLANT_SITE_NAME 값 전부 일치 (기본 ALL 2행) · 조회 요청 2건(본문에 'TEST' 미 |  |
| V-1a251f88 | G2 | 조회조건 Plant Site | NOT_RUN | PASS | [멀티선택 Plant Site] ALL 선택 조회 → 2행 (개별 1행) |  |
| V-e5df6715 | G4 | 조회조건 Plant Site | NOT_RUN | PASS | 기준 순서 2번째 'Plant Site' — 화면 2번째 (화면 순서: Div. → Plant Site → Period) · 기준표 순서(CR-071) |  |
| V-5f2cb6c0 | G7 | 조회조건 Plant Site | NOT_RUN | PASS | [화면 초기(선택 Div=81)] AS-IS 표시 NAME (UsrCheckedList.DataSource → row[1]=NAME) = TO-BE 표시 NAME (CODE≠NAM |  |
| V-c9529229 | H5 | 조회조건 Plant Site | NOT_RUN | PASS | 기준 명칭 'Plant Site' — 화면 라벨 일치 nscm-fe/features/supply/src/pages/shipment-working-day-osp/components/ |  |
| V-6f3a1fb0 | G1 | 조회조건 Period | NOT_RUN | PASS | 기간 'Period' 끝 값 202711 → 202710(달력 조작) 후 조회 · 요청 본문에 202710 있음 · 결과 월 컬럼 12개 202611~202710 |  |
| V-5368d75a | G2 | 조회조건 Period | NOT_RUN | NA | 기간 범위 칸(시작·끝 단일 범위) — ALL·다중 선택 사양 없음 |  |
| V-9f0c58c6 | G4 | 조회조건 Period | NOT_RUN | PASS | 기준 순서 3번째 'Period' — 화면 3번째 (화면 순서: Div. → Plant Site → Period) · 기준표 순서(CR-071) |  |
| V-4e5fd4ed | H5 | 조회조건 Period | NOT_RUN | PASS | 기준 명칭 'Period' — 화면 라벨 일치 nscm-fe/features/supply/src/pages/shipment-working-day-osp/components/Ship |  |
| V-7c7e18e4 | G8 | 조회조건 Period | NOT_RUN | NA | 'Period' 은 텍스트 입력칸이 아님(period) — 텍스트 조건 검사 대상 아님 |  |
| V-bf4654ef | D1 | Shipment Working Day OSP.DIVISION_ID (Div) | NOT_RUN | PASS | 기존행 r0 DIVISION_ID 편집=false (AS-IS 잠금) |  |
| V-48d656f6 | H2 | Shipment Working Day OSP.DIVISION_ID (Div) | NOT_RUN | PASS | DIVISION_ID: 기존행 편집=false 표시 일치 |  |
| V-cc8f7c51 | D1 | Shipment Working Day OSP.PLANT_SITE_ID (Plant Site ID) | NOT_RUN | PASS | 기존행 r0 PLANT_SITE_ID 편집=false (AS-IS 잠금) |  |
| V-567b421e | H2 | Shipment Working Day OSP.PLANT_SITE_ID (Plant Site ID) | NOT_RUN | PASS | PLANT_SITE_ID: 기존행 편집=false 표시 일치 |  |
| V-8daee420 | D1 | Shipment Working Day OSP.PLANT_SITE_NAME (Plant Site) | NOT_RUN | PASS | 기존행 r0 PLANT_SITE_NAME 편집=false (AS-IS 잠금) |  |
| V-3ba10472 | H2 | Shipment Working Day OSP.PLANT_SITE_NAME (Plant Site) | NOT_RUN | PASS | PLANT_SITE_NAME: 기존행 편집=false 표시 일치 |  |
| V-75647788 | D1 | Shipment Working Day OSP.WORKING_TIME_DEFAULT (Working Time  | NOT_RUN | PASS | 기존행 r0 WORKING_TIME_DEFAULT 편집=true (AS-IS 편집 가능) |  |
| V-3ceff9c4 | D5 | Shipment Working Day OSP.WORKING_TIME_DEFAULT (Working Time  | NOT_RUN | PASS | WORKING_TIME_DEFAULT: AS-IS NUMBER ↔ TO-BE dataType=Number · dataMap=N · editor |  |
| V-7889b183 | E1 | Shipment Working Day OSP.WORKING_TIME_DEFAULT (Working Time  | NOT_RUN | PASS | 기존행 r0 WORKING_TIME_DEFAULT: 유효값 '1' 입력 OK(키보드) · 소수 0자리 초과 입력 '1.5' → 값 '1' OK · 문자(숫자 아님) 입력 'ab'  |  |
| V-9b73a42b | H8 | Shipment Working Day OSP.WORKING_TIME_DEFAULT (Working Time  | NOT_RUN | PASS | WORKING_TIME_DEFAULT: AS-IS 소수 0자리·천단위 Y ↔ TO-BE format='' 표시 '7'(원값 '7') |  |
| V-d74723cb | H2 | Shipment Working Day OSP.WORKING_TIME_DEFAULT (Working Time  | NOT_RUN | PASS | WORKING_TIME_DEFAULT: 기존행 편집=true 표시 일치 |  |
| V-4b5367f5 | H13 | Shipment Working Day OSP.WORKING_TIME_DEFAULT (Working Time  | NOT_RUN | NA | WORKING_TIME_DEFAULT: AS-IS 숫자 규칙 최소 0(음수 불가 컬럼) — 음수 글자색 대상 아님 |  |
| V-ac68ff83 | D1 | Shipment Working Day OSP.LAST_INPUT_DATE (Last Input Date) | NOT_RUN | PASS | 기존행 r0 LAST_INPUT_DATE 편집=false (AS-IS 잠금) |  |
| V-d1546794 | H2 | Shipment Working Day OSP.LAST_INPUT_DATE (Last Input Date) | NOT_RUN | PASS | LAST_INPUT_DATE: 기존행 편집=false 표시 일치 |  |
| V-46a138cc | D1 | Shipment Working Day OSP.MEASURE (Measure) | NOT_RUN | PASS | 기존행 r0 MEASURE 편집=false (AS-IS 잠금) |  |
| V-4e8e8924 | H2 | Shipment Working Day OSP.MEASURE (Measure) | NOT_RUN | PASS | MEASURE: 기존행 편집=false 표시 일치 |  |
| V-66111d89 | D1 | Shipment Working Day OSP.<DYNAMIC:LOOP> (동적 LOOP 컬럼) | NOT_RUN | NA | AS-IS·TO-BE 모두 Insert 없음(AS-IS 근거 [V-5bf21eb5] Insert 없음(수정 저장형) · 대상 칸 해석 불가: DataUtil.checkRequire |  |
| V-7acef6b1 | D1 | Shipment Working Day OSP.<DYNAMIC:LOOP> (동적 LOOP 컬럼) | NOT_RUN | PASS | 기존행 동적 <DYNAMIC:LOOP> → 대표 D_20261118(436개 중) · 접두 /^M_/ 대표 M_202611 M_202611: r0 편집=false / AS-IS 잠 |  |
| V-52c55752 | H1 | .dr[DefColumns.COLUMN_NAME] (dr[DefColumns.COLUMN_LABEL_NAME | NOT_RUN | NA | TO-BE 대응 메타 시트 없음(AS-IS 시트 ) · AS-IS SCP0096_Shipment_Working_Day_OSP.cs:203 · TO-BE 대응 메타 시트 없음 |  |
| V-7c369967 | H1 | Shipment Working Day OSP.DIVISION_ID (Division) | NOT_RUN | PASS | AS-IS center ↔ TO-BE center · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0096/Shipment Working Day OSP) · T |  |
| V-cc72550e | H1 | Shipment Working Day OSP.LAST_INPUT_DATE (Last Input Date) | NOT_RUN | PASS | AS-IS center ↔ TO-BE center · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0096/Shipment Working Day OSP) · T |  |
| V-5c379304 | H1 | Shipment Working Day OSP.MEASURE (Measure) | NOT_RUN | PASS | AS-IS left ↔ TO-BE left · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0096/Shipment Working Day OSP) · TO-BE |  |
| V-b726662b | H1 | Shipment Working Day OSP.PLANT_SITE_ID (Plant Site ID) | NOT_RUN | PASS | AS-IS left ↔ TO-BE left · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0096/Shipment Working Day OSP) · TO-BE |  |
| V-5335e699 | H1 | Shipment Working Day OSP.PLANT_SITE_NAME (Plant Site) | NOT_RUN | PASS | AS-IS left ↔ TO-BE left · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0096/Shipment Working Day OSP) · TO-BE |  |
| V-b0d1d082 | H1 | Shipment Working Day OSP.WORKING_TIME_DEFAULT (Working Time  | NOT_RUN | PASS | AS-IS right ↔ TO-BE right · AS-IS META SCM_MST_SHEET_COLUMNS(SCP0096/Shipment Working Day OSP) · TO- |  |
| V-6d695172 | MS1 | MSG00134 | NOT_RUN | PASS | AS-IS MSG00134 '날짜 선택 후 입력하세요.' → 같은 문구의 TO-BE ID MSG01153 '날짜 선택 후 입력하세요.' — TO-BE 가 MSG01153 사용(FE |  |
| V-e82d924c | MS1 | MSG00134 | NOT_RUN | NA | 같은 메시지 MSG00134 — [V-6d695172] 에서 판정(이 행은 사용 위치 BtnInput_Click 경로(BRANCH)) |  |
| V-fef5f373 | MS1 | MSG00004 | NOT_RUN | PASS | AS-IS MSG00004 '{0}개의 데이터가 저장되었습니다.' → 같은 문구의 TO-BE ID MSG00672 '{0}개의 데이터가 저장되었습니다.' — TO-BE 가 같은 유 |  |
| V-5403aadf | E4 | MSG00135 | NOT_RUN | PASS | MSG00135(조회 전 가드) · 조회 전 'Bulk Update' 클릭 → 차단 알림 '조회 후 수정모드로 가능합니다. Confirm' · 모달 안 열림 |  |
| V-68bd0ef2 | MS1 | MSG00135 | NOT_RUN | PASS | AS-IS MSG00135 '수정모드가 아니므로 입력할 수 없습니다.' → 같은 문구의 TO-BE ID MSG01154 '수정모드가 아니므로 입력할 수 없습니다.' — TO-BE  |  |
| V-ee57bb7a | E4 | MSG00134 | NOT_RUN | PASS | MSG00134(선택 셀 없음 가드) · 'Bulk Update' 모달 'SelectDay' 선택 · 그리드 선택 해제 → 확인 → 차단 알림 '날짜 선택 후 입력하세요. Conf |  |
| V-131ad121 | MS1 | MSG00134 | NOT_RUN | NA | 같은 메시지 MSG00134 — [V-6d695172] 에서 판정(이 행은 사용 위치 BtnInput_Click 경로) |  |
| V-42ede860 | D3 | siMain.SwitchLock | NOT_RUN | PASS | r0 siMain.SwitchLock 그리드에 없음 · r1 siMain.SwitchLock 그리드에 없음 |  |
| V-cede8e21 | D3 | DIVISION_ID,PLANT_SITE_NAME | NOT_RUN | PASS | r0  → DIVISION_ID 편집=false (AS-IS 잠금 SCP0096_Shipment_Working_Day_OSP.EditButton) OK · r1  → DIVISIO |  |
| V-a4ba2e32 | D3 | LAST_INPUT_DATE,MEASURE | NOT_RUN | PASS | r0  → LAST_INPUT_DATE 편집=false (AS-IS 잠금 SCP0096_Shipment_Working_Day_OSP.EditButton) OK · r1  → LAS |  |
| V-1f439558 | E3 | DataUtil.checkRequiredOfSearch | NOT_RUN | NA | 필수 조회조건 Div,Period 전부 비울 수 없는 컨트롤(Div: combo — 사용자가 비울 수 없는 컨트롤 · Period: period — 사용자가 비울 수 없는 컨트롤) |  |
| V-11851cf7 | D1 | siMain.LockColumn | NOT_RUN | NA | TO-BE 룰 CR-093 — TO-BE 는 진입 즉시 편집 모드. AS-IS 조회 직후 전 컬럼 잠금(SCP0096_Shipment_Working_Day_OSP.cs:475 SC |  |
| V-6ba1bcea | G1 | (동적 메시지) | NOT_RUN | NA | 검사 대상 아님 — catch 블록의 예외 메시지(프레임워크 공통 오류 표시). 화면 고유 검증 메시지가 아니다 |  |
| V-5971c412 | J1 | this.SetDivisionAuthCheck | NOT_RUN | PASS | Division 후보 8건 [81 Automotive Battery, 40 Mobility & IT Battery, 82 ESS Battery, 81_UC Automotive Ba |  |
| V-5bf21eb5 | E3 | DataUtil.checkRequiredOfSpread | NOT_RUN | NA | Insert 없음(수정 저장형) · 대상 칸 해석 불가: DataUtil.checkRequiredOfSpread |  |
| V-b0948ec4 | E4 | MSG00004 | NOT_RUN | NA | MSG00004: 저장 성공 분기(if (t.Success))의 안내 메시지 — 위반 입력으로 만들 수 없는 메시지(저장 결과 메시지는 F2·E4_F1LINK 에서 판정) |  |
| V-0c636878 | MS1 | MSG00004 | NOT_RUN | NA | 같은 메시지 MSG00004 — [V-fef5f373] 에서 판정(이 행은 사용 위치 SaveData_Main 경로) |  |
| V-03bcbbd8 | E4 | (동적 메시지) | NOT_RUN | NA | 검사 대상 아님 — catch 블록 예외 메시지(프레임워크 공통 오류 표시) |  |
| V-58504ac4 | E4 | (동적 메시지) | NOT_RUN | NA | 검사 대상 아님 — catch 블록 예외 메시지(프레임워크 공통 오류 표시) |  |
| V-2b2d62b2 | E3 | SCP0096 신규행 필수 공란 저장 | NOT_RUN | NA | Insert 없음(수정 저장형) · 대상 칸 해석 불가: SCP0096 신규행 필수 공란 저장 |  |
| V-3a9cbaea | A5 | 컬럼/Measure 셋팅(개인화 Default) | NOT_RUN | PASS | 규칙 A5 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-9f61ba1b] WORKING_TIME_DEFAULT / Working Time Default: WO |  |
| V-95a50541 | K2 | 컬럼/Measure 셋팅(개인화 Default) | NOT_RUN | NA | 대상 없음 — 대상 없음(근거: COLUMN_SETTING: actions.csv TitleSet／btnColumn 0건) |  |
| V-ec0cd74c | B4 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | NOT_RUN | PASS | 규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-9cbddc43] 조회조건 Plant Site: [화면 초기(선택 Div=81)] 차이 1건 모두 데이 |  |
| V-154fdd71 | C1 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | NOT_RUN | PASS | 규칙 C1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-46eaf186] clbPlantSite / Plant Site: AS-IS 핸들러 ClbPlantSi |  |
| V-f8a41f6a | B8 | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | NOT_RUN | PASS | Team 조건 없음 · Plant Site 후보 = AS-IS 원천 PASS(차이 1건 모두 데이터 차이(AS-IS DEV↔사내 시점) — 조건 동일) |  |
| V-711f513a | H4 | Main Grid 컬럼 폭 | NOT_RUN | PASS | 페이지 가로 스크롤 없음 · 컬럼 폭은 TO-BE 디자인 룰(H9 에서 메타 대조) — TO-BE 기준 준수(사용자 2026-10-26) |  |
| V-6b798c0b | H9 | Main Grid 컬럼 폭 | NOT_RUN | PASS | 컬럼 폭 6개 메타 대조 — 25% 초과 이탈 0: 없음 |  |
| V-40b8c92a | G5 | 팝업 연결 조회조건·그리드 컬럼 | NOT_RUN | NA | 대상 없음 — 대상 없음(근거: POPUP_COND: search_cond 팝업 연결 조건 0행 []) |  |
| V-2728ec46 | H6 | 전체 팝업 버튼 순서 | NOT_RUN | NA | 이 화면에 규칙 H6 의 대상 요소·기능이 없음(같은 규칙의 판정 행 0) — 확정규칙·결함원장 공통 항목 |  |
| V-69c51d21 | H7 | Excel Download 양식(공통 모듈) | NOT_RUN | NA | 대상 없음 — 대상 없음(근거: EXCEL: 버튼 코드 ['EDIT', 'SAVE', 'SEARCH'] · plan.buttons ['Input']) |  |
| V-38535b9d | H6 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | NOT_RUN | NA | 이 화면에 규칙 H6 의 대상 요소·기능이 없음(같은 규칙의 판정 행 0) — 확정규칙·결함원장 공통 항목 |  |
| V-a8bed1eb | K1 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | NOT_RUN | PASS | F3(PLANT_SITE_ID): 정렬 스위치 false → true · 헤더 클릭 ×3: '없음' → '+PLANT_SITE_ID' → '-PLANT_SITE_ID' → '없음' |  |
| V-abe19a87 | K3 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | NOT_RUN | PASS | f5 PASS: F5 → 조회 호출 5건(SEARCH,SEARCH,SEARCH) · 페이지 이동 0회 · 미포함: 팝업 그리드(이 시험은 메인 그리드만), Sort/Filter·정 |  |
| V-de85e28c | I1 | 팝업 메시지 다국어(MSG00445 등) | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 I1 의 다른 대상 3행 PASS 는 이 결함의 근거가 아님 · 참고 [V-721a7ae2] SCP0096 화면 ／ [V-67eb6936] SCP00 |  |
| V-b20f4611 | I2 | 팝업 메시지 다국어(MSG00445 등) | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 I2 의 다른 대상 7행 PASS 는 이 결함의 근거가 아님 · 참고 [V-1719f7e3] SCP0096 화면 ／ [EG-9217af22] SCP0 |  |
| V-80814eff | K1 | 그리드 필터(F4) | NOT_RUN | PASS | F3(PLANT_SITE_ID): 정렬 스위치 false → true · 헤더 클릭 ×3: '없음' → '+PLANT_SITE_ID' → '-PLANT_SITE_ID' → '없음' |  |
| V-8bd60dd7 | B2 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | NOT_RUN | PASS | 규칙 B2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-0943c85f] 조회조건 Plant Site: 조회조건 Plant Site 후보 2건 · 중복 0 |  |
| V-8d132d34 | B3 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | NOT_RUN | NA | 규칙 B3 대상 일치 1행이 모두 NA — [V-b76a3794] 조회조건 Plant Site: [화면 초기(선택 Div=81)] AS-IS 원천에 정렬 근거(ORDER BY) 없 |  |
| V-961dfbab | B4 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | NOT_RUN | PASS | 규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-9cbddc43] 조회조건 Plant Site: [화면 초기(선택 Div=81)] 차이 1건 모두 데이 |  |
| V-2131d48b | I1 | LBL/MSG/MENU 코드 사전 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 I1 의 다른 대상 3행 PASS 는 이 결함의 근거가 아님 · 참고 [V-721a7ae2] SCP0096 화면 ／ [V-67eb6936] SCP00 |  |
| V-f1a09c35 | N1 | LBL/MSG/MENU 코드 사전 | NOT_RUN | NA | 'LBL/MSG/MENU 코드 사전' 은 코드 사전·마스터 전역 항목 — SCP0096 그리드 데이터로 측정할 공란 컬럼 아님(전역 N1 은 사전 점검 도구 대상) |  |
| V-2ceb2cdd | I4 | LBL/MSG/MENU 코드 사전 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 I4 의 다른 대상 1행 PASS 는 이 결함의 근거가 아님 · 참고 [V-8521e99b] SCP0096 화면 |  |
| V-ebddaf2c | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | NOT_RUN | PASS | ctrl PASS: Ctrl+클릭 0행·2행(D_20261118) → 선택 범위 시도1 [[2,2],[0,0]] · selectionMode=6 — 비연속 다중 선택 · 미포함:  |  |
| V-aa082a14 | H4 | 화면 축소 시 조회조건·스크롤 | NOT_RUN | PASS | 페이지 가로 스크롤 없음 · 컬럼 폭은 TO-BE 디자인 룰(H9 에서 메타 대조) — TO-BE 기준 준수(사용자 2026-10-26) |  |
| V-ecb097ed | G2 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 G2 의 다른 대상 5행 PASS 는 이 결함의 근거가 아님 · 참고 [V-4c442f02] SCP0096 복수 선택 조회 ／ [V-dae3584c] |  |
| V-0d4d1a4f | B6 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B6 의 다른 대상 5행 PASS 는 이 결함의 근거가 아님 · 참고 [V-cbf8f2a0] SCP0096 단일 선택 조회 ／ [V-5dedc1c3] |  |
| V-97e852bb | M4 | 팝업 입력 컬럼 | NOT_RUN | NA | 이 화면에 규칙 M4 의 대상 요소·기능이 없음(같은 규칙의 판정 행 0) — 확정규칙·결함원장 공통 항목 |  |
| V-65ac7048 | K3 | 그리드 헤더 클릭 | NOT_RUN | PASS | hdr PASS: 헤더(D_20261118) 클릭 → 선택 행 0~18/19 · 열 6~6(시험 열 6) — 열 전체 선택 |  |
| V-8cfb643a | H4 | 조회조건·버튼 배치 / 조회조건 콤보 드롭다운 | NOT_RUN | PASS | 페이지 가로 스크롤 없음 · 컬럼 폭은 TO-BE 디자인 룰(H9 에서 메타 대조) — TO-BE 기준 준수(사용자 2026-10-26) |  |
| V-f7638a0a | L2 | 조회조건 텍스트 입력 중 그리드 | NOT_RUN | NA | 텍스트 입력 조회조건 없음(조회조건 종류: Div=combo, Plant Site=combo) — 입력 중 재렌더 대상 없음 |  |
| V-ddbe0a9b | L1 | 조회조건 텍스트 입력 중 그리드 | NOT_RUN | PASS | 조회(Division ALL) 응답 158ms(요청~응답 158ms · 벽시계 834ms) · 2행 — 기준 10초(화면 규칙 L1: 조회·저장·키 이동 응답 기준 이내) |  |
| V-81765b2a | F5 | Delete 버튼·CRUD Status D Flag | NOT_RUN | NA | 규칙 F5 화면 실측 1행이 '대상 기능 없음' NA — [V-010f6aa2] Delete 버튼 비노출 |  |
| V-abe4c038 | K2 | Measure 순서·메저셋팅 순서 저장 | NOT_RUN | NA | 대상 없음 — 대상 없음(근거: COLUMN_SETTING: actions.csv TitleSet／btnColumn 0건) |  |
| V-8aa8c198 | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/ | NOT_RUN | PASS | 규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-9cbddc43] 조회조건 Plant Site: [화면 초기(선택 Div=81)] 차이 1건 모두 데이 |  |
| V-ae5ead24 | H6 | From City 검색 버튼 | NOT_RUN | NA | 이 화면에 규칙 H6 의 대상 요소·기능이 없음(같은 규칙의 판정 행 0) — 확정규칙·결함원장 공통 항목 |  |
| V-82010ade | G5 | From City 검색 버튼 | NOT_RUN | NA | 대상 없음 — 대상 없음(근거: POPUP_COND: search_cond 팝업 연결 조건 0행 []) |  |
| V-778a2f6b | I2 | 조회 결과 총/건 표기 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 I2 의 다른 대상 7행 PASS 는 이 결함의 근거가 아님 · 참고 [V-1719f7e3] SCP0096 화면 ／ [EG-9217af22] SCP0 |  |
| V-97b95ba1 | I1 | 조회 결과 총/건 표기 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 I1 의 다른 대상 3행 PASS 는 이 결함의 근거가 아님 · 참고 [V-721a7ae2] SCP0096 화면 ／ [V-67eb6936] SCP00 |  |
| V-0dc16d28 | H8 | 총 건수 표시 | NOT_RUN | PASS | 조회 2행 — 화면에 건수 '2' 표시 있음 · TO-BE 공용 건수 영역 '총2건'(보이는 그리드 행 수 2) = 활성 그리드 건수 → TO-BE 룰 CR-110 PASS(총 건 |  |
| V-c434cb81 | E6 | 텍스트 입력 컨트롤(TEXT BOX · FPText) 마우스 드래그 선택 후 Delete/Backspace | NOT_RUN | NA | 규칙 E6 화면 실측 2행이 '대상 기능 없음' NA — [V-e0498911] ime NA: 기존행에 직접 입력하는 문자 컬럼 없음 ／ auto NA: 콤보 362칸(후보 목록  |  |
| V-ea4d557d | A7 | RTF Measure 금액(AMT) 계산 시 적용 LOC(판가) 기준(RTF · AMT · LOC) | NOT_RUN | NA | 규칙 A7 요소 판정에 FAIL 0 · 판정필요 1 · 미검증 0 있으나 이 결함 대상과 직접 일치하는 요소 없음 — 규칙 전반 상속으로 FAIL 을 만들지 않음(원천 행 참조:  |  |
| V-4996771f | M4 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | NOT_RUN | NA | 이 화면에 규칙 M4 의 대상 요소·기능이 없음(같은 규칙의 판정 행 0) — 확정규칙·결함원장 공통 항목 |  |
| V-5c9911c4 | H6 | 그리드 셀 Model 팝업(ITEM_ID) 선택 모드(단일 선택) | NOT_RUN | NA | 이 화면에 규칙 H6 의 대상 요소·기능이 없음(같은 규칙의 판정 행 0) — 확정규칙·결함원장 공통 항목 |  |
| V-db8f1de8 | DB-SYN | TO-BE PKG 소스(PKG_DMF0003·PKG_DMF0021·PKG_DMF0042·PKG_DMF0045 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 DB-SYN 의 다른 대상 7행 PASS 는 이 결함의 근거가 아님 · 참고 [V-a08818c4] SCP0096 화면 ／ [T-628adaf7] P |  |
| V-e7192bbf | J1 | 사용자 Division 권한 콤보 쿼리(DIVISION_ID · 권한 USE_YN) 필터 | NOT_RUN | PASS | 규칙 J1 판정 12행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-5971c412] this.SetDivisionAuthCheck: Division 후보 8건 [81  |  |
| V-65a3c78c | J4 | 그룹ID별 메뉴·버튼 권한(MENU AUTH · BTN AUTH) 운영데이터 동기화 | NOT_RUN | PASS | 그룹별 메뉴·버튼 권한 대조 2026-11-19 09:59:53: PASS — 그룹 4↔4 · 메뉴 권한 그룹·버튼(R·C·U·D·SAVE) 일치 · AS-IS 그룹 {'ADMIN |  |
| V-804bbd3b | J2 | 그룹ID별 메뉴·버튼 권한(MENU AUTH · BTN AUTH) 운영데이터 동기화 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 J2 의 다른 대상 54행 PASS 는 이 결함의 근거가 아님 · 참고 [V-ccd6a739] SCP0096 화면 ／ [EG-b64d7ad0] SCP |  |
| V-89d56eff | A5 | [SYS0002 결함 유형] User 화면 Group 컬럼 | NOT_RUN | PASS | 규칙 A5 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-9f61ba1b] WORKING_TIME_DEFAULT / Working Time Default: WO |  |
| V-71866a38 | H1 | [DMF0043 결함 유형] Contribution Version Valid_YN 컬럼 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 H1 의 다른 대상 7행 PASS 는 이 결함의 근거가 아님 · 참고 [V-52c55752] .dr[DefColumns.COLUMN_NAME] (dr |  |
| V-5926d711 | B6 | [DMF0043_01 결함 유형] 조회조건 Product Group·Biz Type | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B6 의 다른 대상 5행 PASS 는 이 결함의 근거가 아님 · 참고 [V-cbf8f2a0] SCP0096 단일 선택 조회 ／ [V-5dedc1c3] |  |
| V-0ad0a9bf | G2 | [DMF0043_01 결함 유형] 조회조건 Product Group·Biz Type | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 G2 의 다른 대상 5행 PASS 는 이 결함의 근거가 아님 · 참고 [V-4c442f02] SCP0096 복수 선택 조회 ／ [V-dae3584c] |  |
| V-198eae94 | L1 | [DMF0043_01 결함 유형] Customer Group 조회조건 텍스트 입력 · 그리드 셀 클릭 응답 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 L1 의 다른 대상 3행 PASS 는 이 결함의 근거가 아님 · 참고 [V-f081907e] SCP0096 화면 ／ [V-fe134102] SCP00 |  |
| V-4d61d60d | C2 | [DMF0007 결함 유형] 그리드 End Customer→Sales Site cascade | NOT_RUN | NA | 대상 없음 — 대상 없음(근거: COMBO_CELL: sheet_columns 셀 콤보(FPComboBox) 0열) |  |
| V-ec955775 | B4 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | NOT_RUN | PASS | 규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-9cbddc43] 조회조건 Plant Site: [화면 초기(선택 Div=81)] 차이 1건 모두 데이 |  |
| V-6b42f03d | F1 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F1 의 다른 대상 7행 PASS 는 이 결함의 근거가 아님 · 참고 [V-56c6ac97] SCP0096 화면 ／ [V-7b7c7536] SCP00 |  |
| V-cd193731 | F2 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F2 의 다른 대상 2행 PASS 는 이 결함의 근거가 아님 · 참고 [V-a465668f] SCP0096 화면 ／ [V-4f709640] SCP00 |  |
| V-4654f6d1 | F6 | [DMF0007 결함 유형] 저장(성공 메시지) · Sales Site 셀 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F6 의 다른 대상 5행 PASS 는 이 결함의 근거가 아님 · 참고 [V-6fee2895] SCP0096 화면 ／ [V-921d237e] SCP00 |  |
| V-65ae0310 | B1 | [DMF0007 결함 유형] 그리드 End Customer 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B1 의 다른 대상 5행 PASS 는 이 결함의 근거가 아님 · 참고 [V-1bd39a18] SCP0096 시나리오 [자동] 조회조건 콤보 2종 =  |  |
| V-9a8a30ca | B2 | [DMF0007 결함 유형] 그리드 End Customer 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B2 의 다른 대상 4행 PASS 는 이 결함의 근거가 아님 · 참고 [V-cf76f5b2] 조회조건 Div ／ [V-0943c85f] 조회조건 Pl |  |
| V-d00659eb | B3 | [DMF0007 결함 유형] 그리드 End Customer 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B3 의 다른 대상 6행 PASS 는 이 결함의 근거가 아님 · 참고 [V-55c97f16] 조회조건 Div ／ [V-b76a3794] 조회조건 Pl |  |
| V-df393704 | B5 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_M | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B5 의 다른 대상 7행 PASS 는 이 결함의 근거가 아님 · 참고 [V-e1a1ffe9] 조회조건 Div ／ [V-9cbddc43] 조회조건 Pl |  |
| V-eee433c3 | N1 | [DMF0007 결함 유형] Measure Combo(LOOKUP CUST_FCST_MEASURE)·DM_M | NOT_RUN | PASS | 규칙 N1 판정 4행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [EG-04de84cd] SCP0096 기준정보 키 존재 SCM_ADM_LOOKUP_MASTER: SCM_A |  |
| V-b582e0ff | A4 | [DMF0008 결함 유형] ERP EDI Master Validation 2·3번 Sheet | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 A4 의 다른 대상 1행 PASS 는 이 결함의 근거가 아님 · 참고 [V-0ffe23ba] SCP0096 화면 |  |
| V-721262b2 | A1 | [DMF0048 결함 유형] 조회 결과 건수 | NOT_RUN | NA | 규칙 A1 요소 판정에 FAIL 0 · 판정필요 2 · 미검증 0 있으나 이 결함 대상과 직접 일치하는 요소 없음 — 규칙 전반 상속으로 FAIL 을 만들지 않음(원천 행 참조:  |  |
| V-4fed20fa | F2 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F2 의 다른 대상 2행 PASS 는 이 결함의 근거가 아님 · 참고 [V-a465668f] SCP0096 화면 ／ [V-4f709640] SCP00 |  |
| V-21828c62 | F1 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F1 의 다른 대상 7행 PASS 는 이 결함의 근거가 아님 · 참고 [V-56c6ac97] SCP0096 화면 ／ [V-7b7c7536] SCP00 |  |
| V-f102f158 | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NOT_RUN | PASS | 규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-9cbddc43] 조회조건 Plant Site: [화면 초기(선택 Div=81)] 차이 1건 모두 데이 |  |
| V-6603853d | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NOT_RUN | NA | NA: (a) 저장 SP SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 대상 SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, SCP_MST |  |
| V-543371e2 | F2 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F2 의 다른 대상 2행 PASS 는 이 결함의 근거가 아님 · 참고 [V-a465668f] SCP0096 화면 ／ [V-4f709640] SCP00 |  |
| V-ba4c88bf | F1 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F1 의 다른 대상 7행 PASS 는 이 결함의 근거가 아님 · 참고 [V-56c6ac97] SCP0096 화면 ／ [V-7b7c7536] SCP00 |  |
| V-ceef74d1 | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NOT_RUN | PASS | 규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-9cbddc43] 조회조건 Plant Site: [화면 초기(선택 Div=81)] 차이 1건 모두 데이 |  |
| V-ad5796e9 | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NOT_RUN | NA | NA: (a) 저장 SP SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 대상 SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, SCP_MST |  |
| V-9171349a | F2 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F2 의 다른 대상 2행 PASS 는 이 결함의 근거가 아님 · 참고 [V-a465668f] SCP0096 화면 ／ [V-4f709640] SCP00 |  |
| V-a7cca467 | F1 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F1 의 다른 대상 7행 PASS 는 이 결함의 근거가 아님 · 참고 [V-56c6ac97] SCP0096 화면 ／ [V-7b7c7536] SCP00 |  |
| V-69d61549 | B4 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NOT_RUN | PASS | 규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-9cbddc43] 조회조건 Plant Site: [화면 초기(선택 Div=81)] 차이 1건 모두 데이 |  |
| V-304dfe8e | B7 | [DMF0004 결함 유형] 저장 · Sales Site 조회조건 콤보 | NOT_RUN | NA | NA: (a) 저장 SP SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 대상 SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, SCP_MST |  |
| V-dd7c08a1 | M3 | [DMF0005 결함 유형] Team 팝업 | NOT_RUN | NA | 이 화면에 규칙 M3 의 대상 요소·기능이 없음(같은 규칙의 판정 행 0) — 확정규칙·결함원장 공통 항목 |  |
| V-05e4d0e1 | G5 | [DMF0005 결함 유형] Team 팝업 | NOT_RUN | NA | 대상 없음 — 대상 없음(근거: POPUP_COND: search_cond 팝업 연결 조건 0행 []) |  |
| V-50081974 | C3 | [DMF0005 결함 유형] Team·Owner 컬럼 | NOT_RUN | NA | 이 화면 Insert(신규행) 없음 — 신규행 결함 유형 대상 아님 · 근거 [V-4a2afe1f] Insert 버튼 비노출 · 기존행 WORKING_TIME_DEFAULT 편집  |  |
| V-6cf4c95a | F6 | [DMF0005 결함 유형] Team·Owner 컬럼 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F6 의 다른 대상 5행 PASS 는 이 결함의 근거가 아님 · 참고 [V-6fee2895] SCP0096 화면 ／ [V-921d237e] SCP00 |  |
| V-5a36e94d | F1 | [DMF0005 결함 유형] 하단 Purchase 탭 EDI Incoterms | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F1 의 다른 대상 7행 PASS 는 이 결함의 근거가 아님 · 참고 [V-56c6ac97] SCP0096 화면 ／ [V-7b7c7536] SCP00 |  |
| V-c150ca88 | B1 | [DMF0005 결함 유형] 그리드 End Customer 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B1 의 다른 대상 5행 PASS 는 이 결함의 근거가 아님 · 참고 [V-1bd39a18] SCP0096 시나리오 [자동] 조회조건 콤보 2종 =  |  |
| V-2b20f133 | B2 | [DMF0005 결함 유형] 그리드 End Customer 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B2 의 다른 대상 4행 PASS 는 이 결함의 근거가 아님 · 참고 [V-cf76f5b2] 조회조건 Div ／ [V-0943c85f] 조회조건 Pl |  |
| V-2e8057ad | B3 | [DMF0005 결함 유형] 그리드 End Customer 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B3 의 다른 대상 6행 PASS 는 이 결함의 근거가 아님 · 참고 [V-55c97f16] 조회조건 Div ／ [V-b76a3794] 조회조건 Pl |  |
| V-8ca93d3f | G2 | [DMF0004 결함 유형] 조회조건 Active | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 G2 의 다른 대상 5행 PASS 는 이 결함의 근거가 아님 · 참고 [V-4c442f02] SCP0096 복수 선택 조회 ／ [V-dae3584c] |  |
| V-4728cc98 | E3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | NOT_RUN | NA | 대상 컬럼 Team, Project 이 이 화면 그리드 컬럼 28개에 없음 — 결함 유형 대상 아님 |  |
| V-2541ae8a | F3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F3 의 다른 대상 2행 PASS 는 이 결함의 근거가 아님 · 참고 [V-03dc46d1] SCP0096 병합 셀 붙여넣기 ／ [V-e8b114cb |  |
| V-18f6d7ef | D1 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 D1 의 다른 대상 20행 PASS 는 이 결함의 근거가 아님 · 참고 [V-dc1de6a3] SCP0096 병합 셀 입력 ／ [V-9a5fef97] |  |
| V-ceeeff0a | K3 | [DMF0005 결함 유형] Team(팝업 컬럼)·Project 컬럼 필수 Validation | NOT_RUN | NA | 대상 컬럼 Team, Project 이 이 화면 그리드 컬럼 28개에 없음 — 결함 유형 대상 아님 · 이 화면 K3 실측: K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy· |  |
| V-eb32d9dd | B1 | [DMF0072 결함 유형] 그리드 End Customer 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B1 의 다른 대상 5행 PASS 는 이 결함의 근거가 아님 · 참고 [V-1bd39a18] SCP0096 시나리오 [자동] 조회조건 콤보 2종 =  |  |
| V-fbbf42d7 | B2 | [DMF0072 결함 유형] 그리드 End Customer 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B2 의 다른 대상 4행 PASS 는 이 결함의 근거가 아님 · 참고 [V-cf76f5b2] 조회조건 Div ／ [V-0943c85f] 조회조건 Pl |  |
| V-746c054d | B3 | [DMF0072 결함 유형] 그리드 End Customer 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B3 의 다른 대상 6행 PASS 는 이 결함의 근거가 아님 · 참고 [V-55c97f16] 조회조건 Div ／ [V-b76a3794] 조회조건 Pl |  |
| V-3a459b1e | B4 | [DMF0006 결함 유형] 그리드 End Customer 콤보 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 B4 의 다른 대상 7행 PASS 는 이 결함의 근거가 아님 · 참고 [V-e1a1ffe9] 조회조건 Div ／ [V-9cbddc43] 조회조건 Pl |  |
| V-8220f5f5 | B4 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site | NOT_RUN | PASS | 규칙 B4 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-9cbddc43] 조회조건 Plant Site: [화면 초기(선택 Div=81)] 차이 1건 모두 데이 |  |
| V-6a1bd3fd | C1 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site | NOT_RUN | PASS | 규칙 C1 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-46eaf186] clbPlantSite / Plant Site: AS-IS 핸들러 ClbPlantSi |  |
| V-42deb7b3 | B2 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site | NOT_RUN | PASS | 규칙 B2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-0943c85f] 조회조건 Plant Site: 조회조건 Plant Site 후보 2건 · 중복 0 |  |
| V-ad68aaae | B8 | [DMF0006 결함 유형] 조회조건 Team · 그리드 Team/End Customer/Sales Site | NOT_RUN | NA | 이 화면에 규칙 B8 의 대상 요소·기능이 없음(같은 규칙의 판정 행 0) — 확정규칙·결함원장 공통 항목 |  |
| V-422195b2 | G5 | [DMF0020 결함 유형] Exchange Rate 팝업 · DM_MST_EXCHANGE_RATE | NOT_RUN | NA | 대상 없음 — 대상 없음(근거: POPUP_COND: search_cond 팝업 연결 조건 0행 []) |  |
| V-3f575ec9 | M3 | [DMF0020 결함 유형] Exchange Rate 팝업 · DM_MST_EXCHANGE_RATE | NOT_RUN | NA | 이 화면에 규칙 M3 의 대상 요소·기능이 없음(같은 규칙의 판정 행 0) — 확정규칙·결함원장 공통 항목 |  |
| V-8669764c | N1 | [DMF0020 결함 유형] Exchange Rate 팝업 · DM_MST_EXCHANGE_RATE | NOT_RUN | NA | 규칙 N1 요소 판정에 FAIL 3 · 판정필요 0 · 미검증 0 있으나 이 결함 대상과 직접 일치하는 요소 없음 — 규칙 전반 상속으로 FAIL 을 만들지 않음(원천 행 참조:  |  |
| V-2a38a8e9 | A8 | [DMF0020 결함 유형] Exchange Rate 팝업 · DM_MST_EXCHANGE_RATE | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 A8 의 다른 대상 1행 PASS 는 이 결함의 근거가 아님 · 참고 [V-cf76c416] SCP0096 기간 동적 컬럼 |  |
| V-a88b4856 | D1 | [DMF0020 결함 유형] Team·End Customer 컬럼 | NOT_RUN | PASS | 규칙 D1 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [V-cc8f7c51] Shipment Working Day OSP.PLANT_SITE_ID (Plant S |  |
| V-1289ecaa | C3 | [DMF0020 결함 유형] Team·End Customer 컬럼 | NOT_RUN | NA | 이 화면 Insert(신규행) 없음 — 신규행 결함 유형 대상 아님 · 근거 [V-4a2afe1f] Insert 버튼 비노출 · 기존행 WORKING_TIME_DEFAULT 편집  |  |
| V-35b5ece6 | D1 | [DMF0020 결함 유형] Price Exist 컬럼 | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 D1 의 다른 대상 20행 PASS 는 이 결함의 근거가 아님 · 참고 [V-dc1de6a3] SCP0096 병합 셀 입력 ／ [V-9a5fef97] |  |
| V-e5d019bd | D2 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Mode | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 D2 의 다른 대상 3행 PASS 는 이 결함의 근거가 아님 · 참고 [V-ca0b2246] SCP0096 시나리오 [자동] 값 있는 편집 구간 수량 |  |
| V-960446fa | F6 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Mode | NOT_RUN | NA | 직접 실측 없음 — 같은 규칙 F6 의 다른 대상 5행 PASS 는 이 결함의 근거가 아님 · 참고 [V-6fee2895] SCP0096 화면 ／ [V-921d237e] SCP00 |  |
| V-94552e32 | F4 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Mode | NOT_RUN | NA | 규칙 F4 대상 일치 1행이 모두 NA — [T-2ab58ec9] DM0003_GET_BUCKET_TYPE_CODE: DM0003_GET_BUCKET_TYPE_CODE: AS-IS |  |
| V-6508530f | M3 | [DMF0020 결함 유형] Monthly Bucket 입력 · 저장 값 · Project Code/Mode | NOT_RUN | NA | 이 화면에 규칙 M3 의 대상 요소·기능이 없음(같은 규칙의 판정 행 0) — 확정규칙·결함원장 공통 항목 |  |
| V-0720a2ba | A5 | [DMF0020 결함 일반화] 컬럼셋팅 팝업 Default | NOT_RUN | PASS | 규칙 A5 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 0 — [T-9f61ba1b] WORKING_TIME_DEFAULT / Working Time Default: WO |  |
| V-e062dec7 | K2 | [DMF0020 결함 일반화] 컬럼셋팅 팝업 Default | NOT_RUN | NA | 대상 없음 — 대상 없음(근거: COLUMN_SETTING: actions.csv TitleSet／btnColumn 0건) |  |
