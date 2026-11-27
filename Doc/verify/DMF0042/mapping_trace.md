# 대조표 ↔ 검증 추적표 v2 — DMF0042 (AS-IS DMF0042) · 2026-11-27T00:27:59

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 83행 (nscm-fe\features\demand\src\pages\business-plan\__asis-mapping__.md) · AS-IS 액션 9411행(진입점 + 전 문장) = **9494행** → 검사 인스턴스 **2365개**
- 행 판정: FAIL 7896 · 미검증 1438 · 검증완료 160
- 인스턴스 결과: ERROR 1143 · NA 496 · FAIL 372 · PASS 260 · REVIEW 69 · NOT_RUN 13 · NOPATH 12

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 4 | 0 | 0 | 0 | 21 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 7 | 2 | 0 | 1 | 0 | 0 | 13 | 0 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 27 | 10 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 5 | 0 | 0 | 1 | 17 | 0 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 50 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 1 | 11 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 5 | 0 | 0 | 0 | 47 | 5 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 13 | 0 | 0 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 71 | 0 | 0 | 4 | 0 | 8 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 3 | 255 | 0 | 5 | 48 | 11 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 4 | 0 | 0 | 0 | 4 | 3 | 0 | 2 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 4 | 0 | 0 | 0 | 4 | 3 | 0 | 2 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | 있음 | 1 | 0 | 0 | 0 | 14 | 4 | 0 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 1 | 8 | 0 | 0 | 11 | 6 | 0 | 2 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 8 | 0 | 0 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 78 | 7 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 29 | 140 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 1 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 183 | 4 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 22 | 0 | 0 | 0 | 0 | 71 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 35 | 0 | 0 | 0 | 337 | 0 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 1 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 3 | 2 | 0 | 0 | 6 | 15 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E2 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 날짜 형식·유효성 |
| E3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 13 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 10 | 14 | 0 | 0 | 60 | 51 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 2 | 4 | 0 | 0 | 31 | 117 | 0 | 1 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 22 | 57 | 0 | 0 | 73 | 1 | 0 | 1 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 15 | 14 | 0 | 0 | 29 | 2 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 2 | 0 | 0 | 6 | 38 | 6 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J2 | 권한 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 10 | 0 | 0 | 0 | 30 | 0 | 0 | 4 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 2 | 0 | 0 | 2 | 41 | 4 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 18 | 3 | 0 | 2 | 66 | 13 | 13 | 0 | 0 | 0 |
| 동적 생성·조회 | 95 | 266 | 0 | 59 | 100 | 27 | 0 | 0 | 0 | 0 |
| 콤보 후보 | 10 | 8 | 0 | 0 | 33 | 16 | 0 | 6 | 0 | 0 |
| Cascade | 9 | 0 | 0 | 0 | 292 | 156 | 0 | 0 | 0 | 0 |
| 편집·검증 | 75 | 16 | 0 | 0 | 407 | 154 | 0 | 0 | 0 | 0 |
| CRUD | 0 | 3 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 41 | 75 | 0 | 6 | 171 | 126 | 0 | 2 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 12 | 0 | 0 | 2 | 71 | 4 | 0 | 4 | 0 | 0 |

## FAIL 인스턴스

- J2|SCREEN — 원장 V-02d642c4 RULE_SCREEN / 원장 V-22a4a892 DEFECT / 원장 V-fcbc1908 GENERAL / 원장 V-49ea4cea GENERAL / 원장 V-afc361fb GENERAL / 원장 V-5217d1e9 GENERAL / 원장 V-a1a8b607 (대조표 755행)
- F1|SCREEN — 원장 V-1f2afd11 RULE_SCREEN / 원장 V-eb3408a8 RULE_SCREEN / 원장 V-ef57270d RULE_SCREEN / 원장 V-48f42d7f RULE_SCREEN / 원장 V-267856ab RULE_SCREEN / 원장 V-81ebcecf RULE_S (대조표 1666행)
- A6|ROW:1#9 — 행 집계 — 대조표 1#9 'drpPeriod (PR_GET_DAY_RANGE p_month=7)' 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 정렬대조  (대조표 1행)
- G4|COND:cboQty — E2E smoke labels — 누락 라벨 (대조표 1행)
- G4|COND:cboClosed — E2E smoke labels — 누락 라벨 (대조표 17행)
- F5|SCREEN — 원장 V-749baf1a RULE_SCREEN / 원장 V-a8211de7 RULE_SCREEN / 원장 V-dc85b250 RULE_SCREEN / 원장 V-7215060e DEFECT / 원장 V-f2173d62 GENERAL / 원장 V-50b54547 GENERAL / 원장 V- (대조표 42행)
- H6|BTN:btnItemId — 원장 V-8f152d01 ASIS / 원장 V-d9e8d469 ASIS / 원장 V-1210bb26 ASIS / 원장 V-0e2a72bd ASIS / 원장 V-70c4b471 ASIS / 원장 V-868f5891 ASIS / 원장 V-c7c1bd4d ASIS / 원장 V-8b285a32 (대조표 22행)
- H6|BTN:btnOwner — 원장 V-d830ece8 ASIS / 원장 V-164c2875 ASIS / 원장 V-ad991fd0 ASIS / 원장 V-1d196413 ASIS / 원장 V-b38b55d4 ASIS / 원장 V-12fa1b10 ASIS / 원장 V-e3661a2a ASIS / 원장 V-e9fba552 (대조표 22행)
- G5|BTN:btnProject — 원장 V-519e804c ASIS / 원장 V-e17c91de ASIS / 원장 V-1848a229 ASIS / 원장 V-8d7a1c14 ASIS / 원장 V-14e5f59d ASIS / 원장 V-d5843cbb ASIS / 원장 V-e2c0363c ASIS / 원장 V-fb9361cf (대조표 2행)
- G5|COND:txtProject — 원장 V-5fddf3df SEARCH / 원장 EG-a5542dfc 팝업 실측 SCM0002_ProjectbyDivisionPopupEx COND:Project CORNERS / 원장 EG-316b6de4 팝업 실측 SCM0002_ProjectbyDivisionPopupEx COND:P (대조표 1행)
- H6|COND:txtItemId — 원장 EG-480e08d7 팝업 실측 DM0002_ItembyDivisionPopupEx COND:Model / Nickname BTN_ORDER / 원장 EG-ec144d48 팝업 실측 DM0002_ItembyDivisionPopupEx COND:Model / Nickname NO_C (대조표 1행)
- H6|COND:txtOwner — 원장 EG-6891cb81 팝업 실측 DM0020_OwnerbyDivisionPopup COND:Owner BTN_ORDER / 원장 EG-a4515a49 팝업 실측 DM0020_OwnerbyDivisionPopup COND:Owner NO_COL / 원장 EG-96bd8ca6 팝업 실 (대조표 1행)
- H6|COL:ITEM_ID — 원장 V-d9ba3d99 ASIS / 원장 V-1b89c571 ASIS / 원장 V-1841845a ASIS / 원장 V-6bbd9c1f ASIS / 원장 V-5448b137 ASIS / 원장 V-26c433fa ASIS / 원장 V-7880f905 ASIS / 원장 V-25aabeee (대조표 278행)
- F3|SCREEN — 원장 V-71d9bb1a RULE_SCREEN / 원장 V-08ebae1c RULE_SCREEN / 원장 V-78dce8d4 RULE_SCREEN / 원장 V-a033d198 RULE_SCREEN / 원장 V-100cf309 RULE_SCREEN / 원장 V-2dc58ed4 RULE_S (대조표 2행)
- H4|SCREEN — 원장 V-988babf4 RULE_SCREEN / 원장 V-66450783 RULE_SCREEN / 원장 V-d06c548b RULE_SCREEN / 원장 V-a04d6c13 RULE_SCREEN / 원장 V-e98fdd6f RULE_SCREEN / 원장 V-212c38a8 RULE_S (대조표 25행)
- A6|ROW:20 — 행 집계 — 대조표 20 'FindButton → FindData (L684~799)' 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 정렬대조 FAIL 1번 (대조표 1행)
- H6|ROW:21 — 행 집계 — 대조표 21 'InsertButton → InsertRow (L1150~1417)' 의 H6 151요소: ERROR:73 · FAIL:54 · PASS:22 · NA:1 · NOPATH:1 · FAIL 요소: btnItemId — 원장 V-8f152d01 ASIS / 원장  (대조표 1행)
- G5|ROW:21 — 행 집계 — 대조표 21 'InsertButton → InsertRow (L1150~1417)' 의 G5 152요소: NA:116 · ERROR:31 · FAIL:2 · PASS:2 · NOPATH:1 · FAIL 요소: btnProject — 원장 V-519e804c ASIS / 원장 (대조표 1행)
- E4|MSG:MSG00310 — 원장 V-3e41b595 ASIS / 원장 V-119e9de9 ASIS / 원장 V-a097e1c2 ASIS / 원장 V-e3630fbf ASIS / 원장 V-87e8f4da ASIS / 원장 V-d9b2a1c2 ASIS / 원장 V-10fd120c ASIS / 원장 V-bca54e32 (대조표 13행)
- A6|ROW:25 — 행 집계 — 대조표 25 'btnSetPrice_Click (L3115~3136)' 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 정렬대조 FAIL 1번째  (대조표 1행)
- A6|ROW:Division 분기 33 (사업부분기 전수) — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_G (대조표 1행)
- E4|MSG:MSG00002 — 원장 V-e02c62bd ASIS / 원장 V-86dcf637 ASIS / 원장 V-82c08dd4 ASIS / 원장 V-aa9f4ac3 ASIS / 원장 V-64ccae99 ASIS / 원장 V-11ab8740 ASIS / 원장 V-92830b3d ASIS / 실측[T-e7d5daed (대조표 9행)
- H6|ROW:6#6 — 행 집계 — 대조표 6#6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 H6 151요소: ERROR:73 · FAIL:54 · PASS:22 · NA:1 · NOPATH:1 · FAIL 요소: btnItemId — 원장 V-8f152 (대조표 1행)
- G5|ROW:6#6 — 행 집계 — 대조표 6#6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 G5 152요소: NA:116 · ERROR:31 · FAIL:2 · PASS:2 · NOPATH:1 · FAIL 요소: btnProject — 원장 V-519e (대조표 1행)
- M3|POPUP:DMF0042_1_BizPlan — 원장 V-fa946da2 ASIS / 원장 V-61b1b3e0 ASIS / 원장 V-d0296cf9 ASIS / 원장 V-675768c9 ASIS / 원장 V-1c96c6d6 ASIS / 원장 V-f32309f8 ASIS / 원장 V-ec1c0834 ASIS / 원장 V-a1e299fa (대조표 54행)
- X-ROW|ENTRY:DMF0042_1_BizPlan..ctor — 진입점 집계 2검사 — NA:1 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.CreateSpread — 진입점 집계 1검사 — FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.DefineProperty — 진입점 집계 9검사 — PASS:4 · NA:2 · NOT_RUN:2 · FAIL:1 (대조표 18행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.DeleteButton — 진입점 집계 4검사 — FAIL:3 · ERROR:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.Dispose — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.EditButton — 진입점 집계 29검사 — ERROR:22 · PASS:4 · NA:2 · FAIL:1 (대조표 48행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.FindButton — 진입점 집계 4검사 — FAIL:2 · REVIEW:1 · PASS:1 (대조표 2행)
- A6|SP:P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA — 원장 V-9d782ebf SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['USER_ID'] ↔ TO-BE ["' || v_Gro / 대소문자·NULL 대조 NA 문자 정렬 키 없음 · 자료형 모름 1건(' || v_GroupList)(sort_ci.csv) / 실측[T-f (대조표 192행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.FindData — 진입점 집계 29검사 — ERROR:16 · PASS:7 · FAIL:2 · NA:2 · REVIEW:1 · NOT_RUN:1 (대조표 78행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.Form_Load — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.GetBizTypebyDivision — 진입점 집계 4검사 — PASS:1 · NA:1 · NOPATH:1 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.GetCellColor — 진입점 집계 1검사 — FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.GetCellIndexBySpanRowCells — 진입점 집계 1검사 — FAIL:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.GetCellNumbersByRow — 진입점 집계 1검사 — FAIL:1 (대조표 16행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.GetCellProdSite — 진입점 집계 4검사 — ERROR:2 · PASS:1 · FAIL:1 (대조표 14행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.GetDayRange — 진입점 집계 4검사 — ERROR:2 · FAIL:1 · PASS:1 (대조표 10행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.GetFuturePriceInfo — 진입점 집계 6검사 — NA:2 · PASS:2 · FAIL:1 · ERROR:1 (대조표 10행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.GetLookupData — 진입점 집계 4검사 — PASS:1 · FAIL:1 · NA:1 · NOPATH:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.GetSpdTitle — 진입점 집계 8검사 — ERROR:4 · NA:2 · FAIL:1 · PASS:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.GetThisWeekMonday — 진입점 집계 3검사 — NA:2 · FAIL:1 (대조표 11행)
- M3|BTN:btnProject — 원장 V-f32309f8 ASIS / 원장 V-e2d3e239 ASIS / 원장 V-02175830 ASIS / 원장 V-0679fe5e ASIS / 원장 V-41d17e31 ASIS / 원장 EG-3c664aec 팝업 실측 SCM0002_ProjectbyDivisionPopupEx C (대조표 36행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.InitControls — 진입점 집계 39검사 — PASS:20 · NOT_RUN:9 · FAIL:5 · ERROR:4 · NA:1 (대조표 101행)
- M3|BTN:btnColumn — 원장 V-fa946da2 ASIS / 원장 V-cb73350f ASIS / 원장 V-31ccdc9f ASIS / 원장 V-084a9f65 ASIS / 원장 V-9e2dfac9 ASIS / 원장 EG-bdc030cb 팝업 실측 DM0002_TitleSetForm_Popup BTN:btnC (대조표 12행)
- M3|BTN:btnMeasure — 원장 V-675768c9 ASIS / 원장 V-a61baf50 ASIS / 원장 V-1b4aec2a ASIS / 원장 V-7189d831 ASIS / 원장 V-7b310ef6 ASIS / 원장 EG-bdc030cb 팝업 실측 DM0002_TitleSetForm_Popup BTN:btnC (대조표 12행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.InitSaveDataTable — 진입점 집계 2검사 — FAIL:1 · PASS:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.InitSpread — 진입점 집계 5검사 — PASS:3 · NOT_RUN:1 · FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.InsertButton — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 2행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.InsertRow — 진입점 집계 198검사 — ERROR:118 · NA:52 · PASS:19 · NOPATH:6 · FAIL:3 (대조표 368행)
- B4|COL:CELL_PROD_SITE — 원장 V-736e5e45 COLUMN (대조표 3행)
- D5|COL:CELL_PROD_SITE — 실측[T-2deb2d76]: CELL_PROD_SITE: AS-IS TEXT(cell_rules) ↔ TO-BE dataType=0 dataMap=Y — AS-IS TEXT 에디터가 아님 (대조표 8행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.MinColumnChk — 진입점 집계 1검사 — FAIL:1 (대조표 19행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.OnShown — 진입점 집계 1검사 — FAIL:1 (대조표 5행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.ParameterString — 진입점 집계 1검사 — FAIL:1 (대조표 33행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.SaveButton — 진입점 집계 6검사 — FAIL:2 · ERROR:2 · PASS:1 · NA:1 (대조표 1행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.SaveData — 진입점 집계 23검사 — ERROR:10 · FAIL:6 · PASS:5 · NA:2 (대조표 266행)
- E4|LEDGER:V-3e41b595 — 원장 V-3e41b595 / 실측[T-1115bd5d]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (대조표 1행)
- E4|LEDGER:V-119e9de9 — 원장 V-119e9de9 / 실측[T-ab18b973]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (대조표 1행)
- E4|LEDGER:V-a097e1c2 — 원장 V-a097e1c2 / 실측[T-7286563e]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (대조표 1행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.SetCellColor — 진입점 집계 1검사 — FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.SetSpreadColumn — 진입점 집계 11검사 — ERROR:7 · NA:2 · PASS:1 · FAIL:1 (대조표 26행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.SetSpreadHeaderSpan — 진입점 집계 31검사 — NA:16 · ERROR:14 · FAIL:1 (대조표 53행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.ValidationCheck — 진입점 집계 4검사 — FAIL:2 · PASS:1 · ERROR:1 (대조표 15행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.btnColumn_Click — 진입점 집계 18검사 — ERROR:6 · FAIL:5 · PASS:5 · NA:2 (대조표 9행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.btnCutOff_Click — 진입점 집계 8검사 — ERROR:3 · FAIL:2 · NA:2 · PASS:1 (대조표 18행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.btnExchangeRate_Click — 진입점 집계 15검사 — ERROR:12 · FAIL:2 · PASS:1 (대조표 14행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.btnItemId_Click — 진입점 집계 11검사 — FAIL:5 · NA:3 · ERROR:2 · PASS:1 (대조표 22행)
- H6|LEDGER:V-8f152d01 — 원장 V-8f152d01 (대조표 1행)
- H6|LEDGER:V-d9e8d469 — 원장 V-d9e8d469 (대조표 1행)
- H6|LEDGER:V-1210bb26 — 원장 V-1210bb26 (대조표 1행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.btnMeasure_Click — 진입점 집계 18검사 — ERROR:6 · FAIL:5 · PASS:5 · NA:2 (대조표 9행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.btnOwner_Click — 진입점 집계 11검사 — FAIL:5 · NA:3 · ERROR:2 · PASS:1 (대조표 21행)
- H6|LEDGER:V-d830ece8 — 원장 V-d830ece8 (대조표 1행)
- H6|LEDGER:V-164c2875 — 원장 V-164c2875 (대조표 1행)
- H6|LEDGER:V-ad991fd0 — 원장 V-ad991fd0 (대조표 1행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.btnProject_Click — 진입점 집계 11검사 — FAIL:4 · ERROR:4 · NA:3 (대조표 22행)
- M3|LEDGER:V-f32309f8 — 원장 V-f32309f8 (대조표 1행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.btnReplace_Click — 진입점 집계 10검사 — ERROR:3 · NA:3 · FAIL:2 · PASS:2 (대조표 54행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.btnSetPrice_Click — 진입점 집계 13검사 — PASS:7 · ERROR:3 · FAIL:2 · NA:1 (대조표 15행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.cboBucketType_Click — 진입점 집계 6검사 — ERROR:3 · FAIL:2 · PASS:1 (대조표 4행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.cboBucketType_SelectedIndexChanged — 진입점 집계 1검사 — FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.cboDivision_SelectedIndexChanged — 진입점 집계 11검사 — PASS:5 · FAIL:4 · ERROR:2 (대조표 89행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.chkSum_CheckedChanged — 진입점 집계 1검사 — FAIL:1 (대조표 5행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.clbCustomer_SelectedIndexChanged — 진입점 집계 8검사 — ERROR:6 · FAIL:1 · PASS:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.clbTeam_SelectedIndexChanged — 진입점 집계 7검사 — ERROR:5 · PASS:1 · FAIL:1 (대조표 23행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.fnValidation — 진입점 집계 1검사 — FAIL:1 (대조표 95행)
- H6|POPUP:DMF0042_1_BizPlan — 원장 V-1417ed28 ASIS / 원장 V-699254bf ASIS / 원장 V-1dd724bf ASIS / 원장 V-7ef290e8 ASIS / 원장 V-c02d48d9 ASIS / 원장 V-8f152d01 ASIS / 원장 V-d9e8d469 ASIS / 원장 V-1210bb26 (대조표 1행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.spdMain_CellDoubleClick — 진입점 집계 78검사 — ERROR:38 · NA:23 · FAIL:8 · PASS:5 · NOT_RUN:2 · NOPATH:2 (대조표 139행)
- H6|LEDGER:V-d9ba3d99 — 원장 V-d9ba3d99 (대조표 1행)
- H6|LEDGER:V-1b89c571 — 원장 V-1b89c571 (대조표 1행)
- H6|LEDGER:V-1841845a — 원장 V-1841845a (대조표 1행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.spdMain_Changed — 진입점 집계 68검사 — ERROR:43 · NA:23 · PASS:1 · FAIL:1 (대조표 468행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.spdMain_ComboSelChange — 진입점 집계 27검사 — ERROR:13 · NA:7 · PASS:6 · FAIL:1 (대조표 17행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.spdMain_EditChange — 진입점 집계 1검사 — FAIL:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_1_BizPlan.spdMain_TopChange — 진입점 집계 2검사 — FAIL:2 (대조표 6행)
- X-ROW|ENTRY:DMF0042_1_RTF.FindData — 진입점 집계 7검사 — ERROR:3 · REVIEW:1 · FAIL:1 · PASS:1 · NA:1 (대조표 21행)
- A6|ENTRY:DMF0042_1_RTF.FindData — 진입점 집계 — 대조표 DMF0042_1_RTF.FindData 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 정렬대조 FAIL 1번째 키부터 다름: AS- (대조표 1행)
- X-ROW|ENTRY:DMF0042_1_RTF.FindDataMain — 진입점 집계 4검사 — ERROR:2 · REVIEW:1 · FAIL:1 (대조표 6행)
- A6|ENTRY:DMF0042_1_RTF.FindDataMain — 진입점 집계 — 대조표 DMF0042_1_RTF.FindDataMain 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 정렬대조 FAIL 1번째 키부터 다름: (대조표 1행)
- X-ROW|ENTRY:DMF0042_1_RTF.SaveButton — 진입점 집계 5검사 — ERROR:4 · FAIL:1 (대조표 1행)
- X-ROW|ENTRY:DMF0042_1_RTF.SaveData — 진입점 집계 9검사 — ERROR:5 · PASS:2 · FAIL:1 · NA:1 (대조표 66행)
- X-ROW|ENTRY:DMF0042_1_RTF.btnButtonList_UsrButtonList_Click_Detected — 진입점 집계 3검사 — ERROR:2 · FAIL:1 (대조표 15행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.CreateSpread — 진입점 집계 4검사 — ERROR:3 · FAIL:1 (대조표 4행)
- D5|ENTRY:DMF0042_2_BizPlan.CreateSpread — 진입점 집계 — 대조표 DMF0042_2_BizPlan.CreateSpread 의 D5 23요소: NA:15 · ERROR:4 · PASS:3 · FAIL:1 · FAIL 요소: CELL_PROD_SITE / Cell Prod Sit — 실측[T-2deb2d76]: CELL_PROD_S (대조표 4행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.DeleteButton — 진입점 집계 3검사 — FAIL:2 · ERROR:1 (대조표 1행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.FindButton — 진입점 집계 4검사 — ERROR:2 · REVIEW:1 · FAIL:1 (대조표 1행)
- A6|ENTRY:DMF0042_2_BizPlan.FindButton — 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindButton 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 정렬대조 FAIL 1번째 키부터 다 (대조표 2행)
- A6|ENTRY:DMF0042_2_BizPlan.FindData — 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindData 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 정렬대조 FAIL 1번째 키부터 다름: (대조표 34행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.FindData — 진입점 집계 30검사 — ERROR:20 · PASS:5 · NA:2 · REVIEW:1 · FAIL:1 · NOT_RUN:1 (대조표 16행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.GetBizTypebyDivision — 진입점 집계 5검사 — FAIL:1 · ERROR:1 · PASS:1 · NA:1 · NOPATH:1 (대조표 2행)
- B4|ENTRY:DMF0042_2_BizPlan.GetBizTypebyDivision — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetBizTypebyDivision 의 B4 18요소: ERROR:10 · NA:4 · NOPATH:2 · PASS:1 · FAIL:1 · FAIL 요소: CELL_PROD_SITE / Cell Prod Sit — 원장 V-736 (대조표 4행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.GetCellColor — 진입점 집계 3검사 — ERROR:2 · FAIL:1 (대조표 3행)
- B4|ENTRY:DMF0042_2_BizPlan.GetCellColor — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellColor 의 B4 18요소: ERROR:10 · NA:4 · NOPATH:2 · PASS:1 · FAIL:1 · FAIL 요소: CELL_PROD_SITE / Cell Prod Sit — 원장 V-736e5e45 CO (대조표 5행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.GetCellIndexBySpanRowCells — 진입점 집계 2검사 — FAIL:1 · ERROR:1 (대조표 2행)
- B4|ENTRY:DMF0042_2_BizPlan.GetCellIndexBySpanRowCells — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellIndexBySpanRowCells 의 B4 18요소: ERROR:10 · NA:4 · NOPATH:2 · PASS:1 · FAIL:1 · FAIL 요소: CELL_PROD_SITE / Cell Prod Sit — 원장 (대조표 5행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.GetCellNumbersByRow — 진입점 집계 2검사 — FAIL:1 · ERROR:1 (대조표 2행)
- B4|ENTRY:DMF0042_2_BizPlan.GetCellNumbersByRow — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellNumbersByRow 의 B4 18요소: ERROR:10 · NA:4 · NOPATH:2 · PASS:1 · FAIL:1 · FAIL 요소: CELL_PROD_SITE / Cell Prod Sit — 원장 V-736e (대조표 14행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.GetCellProdSite — 진입점 집계 5검사 — ERROR:3 · FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:DMF0042_2_BizPlan.GetCellProdSite — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellProdSite 의 B4 18요소: ERROR:10 · NA:4 · NOPATH:2 · PASS:1 · FAIL:1 · FAIL 요소: CELL_PROD_SITE / Cell Prod Sit — 원장 V-736e5e45 (대조표 9행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.GetDayRange — 진입점 집계 5검사 — ERROR:3 · FAIL:1 · PASS:1 (대조표 2행)
- B4|ENTRY:DMF0042_2_BizPlan.GetDayRange — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetDayRange 의 B4 18요소: ERROR:10 · NA:4 · NOPATH:2 · PASS:1 · FAIL:1 · FAIL 요소: CELL_PROD_SITE / Cell Prod Sit — 원장 V-736e5e45 COL (대조표 7행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.GetLookupData — 진입점 집계 5검사 — PASS:1 · FAIL:1 · ERROR:1 · NA:1 · NOPATH:1 (대조표 2행)
- B4|ENTRY:DMF0042_2_BizPlan.GetLookupData — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetLookupData 의 B4 18요소: ERROR:10 · NA:4 · NOPATH:2 · PASS:1 · FAIL:1 · FAIL 요소: CELL_PROD_SITE / Cell Prod Sit — 원장 V-736e5e45 C (대조표 4행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.InitControls — 진입점 집계 33검사 — PASS:20 · NOT_RUN:9 · ERROR:2 · FAIL:1 · NA:1 (대조표 36행)
- E4|LEDGER:V-e3630fbf — 원장 V-e3630fbf / 실측[T-5c0369a9]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (대조표 1행)
- E4|LEDGER:V-87e8f4da — 원장 V-87e8f4da / 실측[T-e96fe73c]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (대조표 1행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.SaveData — 진입점 집계 19검사 — ERROR:12 · FAIL:4 · PASS:2 · NA:1 (대조표 1행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.ValidationCheck — 진입점 집계 3검사 — PASS:1 · FAIL:1 · ERROR:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.btnColumn_Click — 진입점 집계 16검사 — ERROR:6 · PASS:5 · FAIL:3 · NA:2 (대조표 4행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.btnCutOff_Click — 진입점 집계 6검사 — ERROR:3 · FAIL:1 · PASS:1 · NA:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.btnExchangeRate_Click — 진입점 집계 12검사 — ERROR:10 · FAIL:1 · PASS:1 (대조표 4행)
- H6|LEDGER:V-0e2a72bd — 원장 V-0e2a72bd (대조표 1행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.btnItemId_Click — 진입점 집계 9검사 — FAIL:4 · NA:3 · ERROR:1 · PASS:1 (대조표 9행)
- H6|LEDGER:V-70c4b471 — 원장 V-70c4b471 (대조표 1행)
- H6|LEDGER:V-868f5891 — 원장 V-868f5891 (대조표 1행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.btnMeasure_Click — 진입점 집계 16검사 — ERROR:6 · PASS:5 · FAIL:3 · NA:2 (대조표 4행)
- H6|LEDGER:V-1d196413 — 원장 V-1d196413 (대조표 1행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.btnOwner_Click — 진입점 집계 9검사 — FAIL:4 · NA:3 · ERROR:1 · PASS:1 (대조표 9행)
- H6|LEDGER:V-b38b55d4 — 원장 V-b38b55d4 (대조표 1행)
- H6|LEDGER:V-12fa1b10 — 원장 V-12fa1b10 (대조표 1행)
- M3|LEDGER:V-e2d3e239 — 원장 V-e2d3e239 (대조표 1행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.btnProject_Click — 진입점 집계 9검사 — ERROR:4 · NA:3 · FAIL:2 (대조표 9행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.btnReplace_Click — 진입점 집계 8검사 — ERROR:3 · PASS:2 · NA:2 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.btnSetPrice_Click — 진입점 집계 9검사 — PASS:4 · ERROR:3 · FAIL:1 · NA:1 (대조표 3행)
- H6|ENTRY:DMF0042_2_BizPlan.spdMain_CellDoubleClick — 원장 V-6bbd9c1f ASIS / 원장 V-6cecd4cf ASIS / 원장 V-5448b137 ASIS / 원장 V-26c433fa ASIS / 원장 V-7880f905 ASIS / 원장 V-831155be ASIS / 원장 V-3bf44110 ASIS / 원장 V-14b9b3fb (대조표 14행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.spdMain_CellDoubleClick — 진입점 집계 93검사 — ERROR:53 · NA:27 · FAIL:7 · PASS:5 · NOT_RUN:1 (대조표 34행)
- H6|LEDGER:V-5448b137 — 원장 V-5448b137 (대조표 1행)
- H6|LEDGER:V-26c433fa — 원장 V-26c433fa (대조표 1행)
- H6|LEDGER:V-7880f905 — 원장 V-7880f905 (대조표 1행)
- X-ROW|ENTRY:DMF0042_2_BizPlan.spdMain_TopChange — 진입점 집계 1검사 — FAIL:1 (대조표 3행)
- M3|POPUP:DMF0042_3_BizPlan — 원장 V-31ccdc9f ASIS / 원장 V-d5b20abe ASIS / 원장 V-56c78e2b ASIS / 원장 V-1b4aec2a ASIS / 원장 V-8b49f48e ASIS / 원장 V-02175830 ASIS / 원장 V-1804cd2e ASIS / 원장 V-55e298ba (대조표 57행)
- X-ROW|ENTRY:DMF0042_3_BizPlan..ctor — 진입점 집계 2검사 — NA:1 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.CreateSpread — 진입점 집계 1검사 — FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.DefineProperty — 진입점 집계 9검사 — PASS:4 · NOT_RUN:2 · NA:2 · FAIL:1 (대조표 18행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.DeleteButton — 진입점 집계 4검사 — FAIL:3 · ERROR:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.Dispose — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.EditButton — 진입점 집계 29검사 — ERROR:20 · PASS:6 · NA:2 · FAIL:1 (대조표 48행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.FindButton — 진입점 집계 4검사 — FAIL:2 · REVIEW:1 · ERROR:1 (대조표 2행)
- A6|ENTRY:DMF0042_3_BizPlan.FindButton — 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindButton 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 정렬대조 FAIL 1번째 키부터 다 (대조표 1행)
- A6|ENTRY:DMF0042_3_BizPlan.FindData — 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindData 의 A6 5요소: ERROR:3 · FAIL:1 · PASS:1 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — 원장 V-9d782ebf SP / 정렬대조 FAIL 1번째 키부터 다름: (대조표 1행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.FindData — 진입점 집계 29검사 — ERROR:18 · PASS:5 · NA:2 · FAIL:2 · NOT_RUN:1 · REVIEW:1 (대조표 78행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.Form_Load — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.GetBizTypebyDivision — 진입점 집계 4검사 — PASS:1 · NA:1 · NOPATH:1 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.GetCellColor — 진입점 집계 1검사 — FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.GetCellIndexBySpanRowCells — 진입점 집계 1검사 — FAIL:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.GetCellNumbersByRow — 진입점 집계 1검사 — FAIL:1 (대조표 16행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.GetCellProdSite — 진입점 집계 4검사 — ERROR:2 · PASS:1 · FAIL:1 (대조표 14행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.GetComboData — 진입점 집계 4검사 — FAIL:1 · REVIEW:1 · NOPATH:1 · PASS:1 (대조표 12행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.GetDayRange — 진입점 집계 4검사 — ERROR:2 · PASS:1 · FAIL:1 (대조표 10행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.GetFuturePriceInfo — 진입점 집계 6검사 — NA:2 · PASS:2 · FAIL:1 · ERROR:1 (대조표 10행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.GetLookupData — 진입점 집계 4검사 — PASS:1 · NA:1 · NOPATH:1 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.GetSpdTitle — 진입점 집계 8검사 — ERROR:4 · NA:2 · PASS:1 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.GetThisWeekMonday — 진입점 집계 3검사 — NA:2 · FAIL:1 (대조표 11행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.InitControls — 진입점 집계 39검사 — PASS:20 · NOT_RUN:9 · FAIL:5 · ERROR:4 · NA:1 (대조표 95행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.InitSaveDataTable — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.InitSpread — 진입점 집계 5검사 — PASS:3 · NOT_RUN:1 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.InsertButton — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 2행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.InsertRow — 진입점 집계 214검사 — ERROR:127 · NA:58 · PASS:23 · NOPATH:3 · FAIL:3 (대조표 394행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.MinColumnChk — 진입점 집계 1검사 — FAIL:1 (대조표 19행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.OnShown — 진입점 집계 1검사 — FAIL:1 (대조표 5행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.ParameterString — 진입점 집계 1검사 — FAIL:1 (대조표 33행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.SaveButton — 진입점 집계 5검사 — FAIL:2 · ERROR:2 · NA:1 (대조표 1행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.SaveData — 진입점 집계 21검사 — ERROR:10 · FAIL:6 · PASS:3 · NA:2 (대조표 272행)
- E4|LEDGER:V-d9b2a1c2 — 원장 V-d9b2a1c2 / 실측[T-db01f180]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (대조표 1행)
- E4|LEDGER:V-10fd120c — 원장 V-10fd120c / 실측[T-544eb0df]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (대조표 1행)
- E4|LEDGER:V-bca54e32 — 원장 V-bca54e32 / 실측[T-eb828187]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (대조표 1행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.SetCellColor — 진입점 집계 1검사 — FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.SetComboCol — 진입점 집계 1검사 — FAIL:1 (대조표 24행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.SetComboColumn — 진입점 집계 5검사 — NA:2 · ERROR:2 · FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.SetSpreadColumn — 진입점 집계 11검사 — ERROR:7 · NA:2 · PASS:1 · FAIL:1 (대조표 26행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.SetSpreadHeaderSpan — 진입점 집계 31검사 — NA:16 · ERROR:14 · FAIL:1 (대조표 53행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.ValidationCheck — 진입점 집계 4검사 — FAIL:2 · PASS:1 · ERROR:1 (대조표 15행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.btnColumn_Click — 진입점 집계 18검사 — ERROR:6 · FAIL:5 · PASS:5 · NA:2 (대조표 9행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.btnCutOff_Click — 진입점 집계 8검사 — ERROR:3 · FAIL:2 · NA:2 · PASS:1 (대조표 18행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.btnExchangeRate_Click — 진입점 집계 15검사 — ERROR:12 · FAIL:2 · PASS:1 (대조표 14행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.btnItemId_Click — 진입점 집계 11검사 — FAIL:5 · NA:3 · ERROR:2 · PASS:1 (대조표 22행)
- H6|LEDGER:V-c7c1bd4d — 원장 V-c7c1bd4d (대조표 1행)
- H6|LEDGER:V-8b285a32 — 원장 V-8b285a32 (대조표 1행)
- H6|LEDGER:V-5179558f — 원장 V-5179558f (대조표 1행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.btnMeasure_Click — 진입점 집계 18검사 — ERROR:6 · FAIL:5 · PASS:5 · NA:2 (대조표 9행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.btnOwner_Click — 진입점 집계 11검사 — FAIL:5 · NA:3 · ERROR:2 · PASS:1 (대조표 21행)
- H6|LEDGER:V-e3661a2a — 원장 V-e3661a2a (대조표 1행)
- H6|LEDGER:V-e9fba552 — 원장 V-e9fba552 (대조표 1행)
- H6|LEDGER:V-883a7df0 — 원장 V-883a7df0 (대조표 1행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.btnProject_Click — 진입점 집계 11검사 — FAIL:4 · ERROR:4 · NA:3 (대조표 22행)
- M3|LEDGER:V-02175830 — 원장 V-02175830 (대조표 1행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.btnReplace_Click — 진입점 집계 10검사 — ERROR:3 · NA:3 · FAIL:2 · PASS:2 (대조표 54행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.btnSetPrice_Click — 진입점 집계 11검사 — PASS:5 · ERROR:3 · FAIL:2 · NA:1 (대조표 15행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.cboBucketType_Click — 진입점 집계 6검사 — ERROR:3 · FAIL:2 · PASS:1 (대조표 4행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.cboBucketType_SelectedIndexChanged — 진입점 집계 1검사 — FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.cboDivision_SelectedIndexChanged — 진입점 집계 11검사 — PASS:5 · FAIL:4 · ERROR:2 (대조표 83행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.chkSum_CheckedChanged — 진입점 집계 1검사 — FAIL:1 (대조표 5행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.clbCustomer_SelectedIndexChanged — 진입점 집계 8검사 — ERROR:6 · PASS:1 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.clbTeam_SelectedIndexChanged — 진입점 집계 7검사 — ERROR:5 · FAIL:1 · PASS:1 (대조표 23행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.fnValidation — 진입점 집계 1검사 — FAIL:1 (대조표 95행)
- H6|POPUP:DMF0042_3_BizPlan — 원장 V-b0a534ca ASIS / 원장 V-dd4b851f ASIS / 원장 V-38555156 ASIS / 원장 V-41d355a1 ASIS / 원장 V-03ff3146 ASIS / 원장 V-c7c1bd4d ASIS / 원장 V-8b285a32 ASIS / 원장 V-5179558f (대조표 1행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.spdMain_CellDoubleClick — 진입점 집계 78검사 — ERROR:37 · NA:24 · FAIL:8 · PASS:5 · NOT_RUN:2 · NOPATH:2 (대조표 139행)
- H6|LEDGER:V-25aabeee — 원장 V-25aabeee (대조표 1행)
- H6|LEDGER:V-6d74450e — 원장 V-6d74450e (대조표 1행)
- H6|LEDGER:V-75dbe2b3 — 원장 V-75dbe2b3 (대조표 1행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.spdMain_Changed — 진입점 집계 68검사 — ERROR:43 · NA:23 · PASS:1 · FAIL:1 (대조표 468행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.spdMain_ComboSelChange — 진입점 집계 27검사 — ERROR:13 · NA:7 · PASS:6 · FAIL:1 (대조표 17행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.spdMain_EditChange — 진입점 집계 1검사 — FAIL:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_3_BizPlan.spdMain_TopChange — 진입점 집계 2검사 — FAIL:2 (대조표 6행)
- M3|POPUP:DMF0042_BizPlan — 원장 V-084a9f65 ASIS / 원장 V-47ddfba8 ASIS / 원장 V-2534f49c ASIS / 원장 V-7189d831 ASIS / 원장 V-4c454807 ASIS / 원장 V-0679fe5e ASIS / 원장 V-b6d2f17d ASIS / 원장 V-1d043b2b (대조표 109행)
- X-ROW|ENTRY:DMF0042_BizPlan..ctor — 진입점 집계 2검사 — NA:1 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:DMF0042_BizPlan.CreateSpread — 진입점 집계 1검사 — FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_BizPlan.DefineProperty — 진입점 집계 9검사 — PASS:4 · NA:2 · NOT_RUN:2 · FAIL:1 (대조표 18행)
- X-ROW|ENTRY:DMF0042_BizPlan.DeleteButton — 진입점 집계 4검사 — FAIL:3 · ERROR:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_BizPlan.Dispose — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 3행)
- X-ROW|ENTRY:DMF0042_BizPlan.EditButton — 진입점 집계 18검사 — ERROR:14 · NA:2 · FAIL:1 · PASS:1 (대조표 38행)
- X-ROW|ENTRY:DMF0042_BizPlan.ExcelButton — 진입점 집계 1검사 — FAIL:1 (대조표 48행)
- X-ROW|ENTRY:DMF0042_BizPlan.FindButton — 진입점 집계 7검사 — PASS:3 · REVIEW:2 · FAIL:2 (대조표 2행)
- X-ROW|ENTRY:DMF0042_BizPlan.FindData — 진입점 집계 33검사 — ERROR:16 · PASS:10 · REVIEW:2 · FAIL:2 · NA:2 · NOT_RUN:1 (대조표 78행)
- X-ROW|ENTRY:DMF0042_BizPlan.Form_Load — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_BizPlan.GetBizTypebyDivision — 진입점 집계 4검사 — NA:1 · NOPATH:1 · PASS:1 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_BizPlan.GetCellColor — 진입점 집계 1검사 — FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_BizPlan.GetCellIndexBySpanRowCells — 진입점 집계 1검사 — FAIL:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_BizPlan.GetCellNumbersByRow — 진입점 집계 1검사 — FAIL:1 (대조표 16행)
- X-ROW|ENTRY:DMF0042_BizPlan.GetCellProdSite — 진입점 집계 4검사 — ERROR:2 · PASS:1 · FAIL:1 (대조표 14행)
- X-ROW|ENTRY:DMF0042_BizPlan.GetDayRange — 진입점 집계 4검사 — ERROR:2 · PASS:1 · FAIL:1 (대조표 10행)
- X-ROW|ENTRY:DMF0042_BizPlan.GetFuturePriceInfo — 진입점 집계 6검사 — PASS:2 · NA:2 · ERROR:1 · FAIL:1 (대조표 10행)
- X-ROW|ENTRY:DMF0042_BizPlan.GetLookupData — 진입점 집계 4검사 — FAIL:1 · PASS:1 · NA:1 · NOPATH:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_BizPlan.GetSpdTitle — 진입점 집계 8검사 — PASS:3 · NA:2 · ERROR:2 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_BizPlan.GetThisWeekMonday — 진입점 집계 3검사 — NA:2 · FAIL:1 (대조표 11행)
- X-ROW|ENTRY:DMF0042_BizPlan.InitControls — 진입점 집계 39검사 — PASS:20 · NOT_RUN:9 · FAIL:5 · ERROR:4 · NA:1 (대조표 101행)
- X-ROW|ENTRY:DMF0042_BizPlan.InitSaveDataTable — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_BizPlan.InitSpread — 진입점 집계 9검사 — PASS:6 · FAIL:2 · NOT_RUN:1 (대조표 10행)
- X-ROW|ENTRY:DMF0042_BizPlan.InsertButton — 진입점 집계 2검사 — PASS:1 · FAIL:1 (대조표 2행)
- X-ROW|ENTRY:DMF0042_BizPlan.InsertRow — 진입점 집계 198검사 — ERROR:118 · NA:52 · PASS:19 · NOPATH:6 · FAIL:3 (대조표 368행)
- X-ROW|ENTRY:DMF0042_BizPlan.MinColumnChk — 진입점 집계 1검사 — FAIL:1 (대조표 19행)
- X-ROW|ENTRY:DMF0042_BizPlan.OnShown — 진입점 집계 1검사 — FAIL:1 (대조표 5행)
- X-ROW|ENTRY:DMF0042_BizPlan.ParameterString — 진입점 집계 1검사 — FAIL:1 (대조표 33행)
- X-ROW|ENTRY:DMF0042_BizPlan.SaveButton — 진입점 집계 7검사 — FAIL:2 · ERROR:2 · PASS:2 · NA:1 (대조표 1행)
- X-ROW|ENTRY:DMF0042_BizPlan.SaveData — 진입점 집계 25검사 — ERROR:10 · PASS:7 · FAIL:6 · NA:2 (대조표 266행)
- E4|LEDGER:V-05ed2d14 — 원장 V-05ed2d14 / 실측[T-523d21c7]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (대조표 1행)
- E4|LEDGER:V-a8a9ff28 — 원장 V-a8a9ff28 / 실측[T-a0aeacff]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (대조표 1행)
- E4|LEDGER:V-f0299336 — 원장 V-f0299336 / 실측[T-d535e96c]: MSG00310: 위반 대상 END_CUSTOMER40 신규행 편집 불가 — 위반 입력 경로 없음(AS-IS 는 편집 가능) (대조표 1행)
- X-ROW|ENTRY:DMF0042_BizPlan.SetCellColor — 진입점 집계 1검사 — FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_BizPlan.SetComboCol — 진입점 집계 1검사 — FAIL:1 (대조표 24행)
- X-ROW|ENTRY:DMF0042_BizPlan.SetSpreadColumn — 진입점 집계 11검사 — ERROR:7 · NA:2 · PASS:1 · FAIL:1 (대조표 26행)
- X-ROW|ENTRY:DMF0042_BizPlan.SetSpreadHeaderSpan — 진입점 집계 31검사 — NA:16 · ERROR:14 · FAIL:1 (대조표 53행)
- X-ROW|ENTRY:DMF0042_BizPlan.ValidationCheck — 진입점 집계 4검사 — FAIL:2 · PASS:1 · ERROR:1 (대조표 15행)
- X-ROW|ENTRY:DMF0042_BizPlan.btnColumn_Click — 진입점 집계 18검사 — ERROR:6 · FAIL:5 · PASS:5 · NA:2 (대조표 9행)
- X-ROW|ENTRY:DMF0042_BizPlan.btnCutOff_Click — 진입점 집계 8검사 — ERROR:3 · FAIL:2 · NA:2 · PASS:1 (대조표 18행)
- X-ROW|ENTRY:DMF0042_BizPlan.btnExchangeRate_Click — 진입점 집계 15검사 — ERROR:12 · FAIL:2 · PASS:1 (대조표 14행)
- X-ROW|ENTRY:DMF0042_BizPlan.btnItemId_Click — 진입점 집계 11검사 — FAIL:5 · NA:3 · ERROR:2 · PASS:1 (대조표 22행)
- H6|LEDGER:V-39cdf70a — 원장 V-39cdf70a (대조표 1행)
- H6|LEDGER:V-bb1b832d — 원장 V-bb1b832d (대조표 1행)
- H6|LEDGER:V-de1d5f8b — 원장 V-de1d5f8b (대조표 1행)
- X-ROW|ENTRY:DMF0042_BizPlan.btnMeasure_Click — 진입점 집계 18검사 — ERROR:6 · FAIL:5 · PASS:5 · NA:2 (대조표 9행)
- X-ROW|ENTRY:DMF0042_BizPlan.btnOwner_Click — 진입점 집계 11검사 — FAIL:5 · NA:3 · ERROR:2 · PASS:1 (대조표 21행)
- H6|LEDGER:V-8fd84844 — 원장 V-8fd84844 (대조표 1행)
- H6|LEDGER:V-07e182b0 — 원장 V-07e182b0 (대조표 1행)
- H6|LEDGER:V-5163b15e — 원장 V-5163b15e (대조표 1행)
- X-ROW|ENTRY:DMF0042_BizPlan.btnProject_Click — 진입점 집계 11검사 — FAIL:4 · ERROR:4 · NA:3 (대조표 22행)
- M3|LEDGER:V-0679fe5e — 원장 V-0679fe5e (대조표 1행)
- X-ROW|ENTRY:DMF0042_BizPlan.btnReplace_Click — 진입점 집계 10검사 — ERROR:3 · NA:3 · FAIL:2 · PASS:2 (대조표 54행)
- X-ROW|ENTRY:DMF0042_BizPlan.btnSetPrice_Click — 진입점 집계 15검사 — PASS:9 · ERROR:3 · FAIL:2 · NA:1 (대조표 15행)
- X-ROW|ENTRY:DMF0042_BizPlan.cboBucketType_Click — 진입점 집계 6검사 — ERROR:3 · FAIL:2 · PASS:1 (대조표 4행)
- X-ROW|ENTRY:DMF0042_BizPlan.cboBucketType_SelectedIndexChanged — 진입점 집계 1검사 — FAIL:1 (대조표 8행)
- X-ROW|ENTRY:DMF0042_BizPlan.cboDivision_SelectedIndexChanged — 진입점 집계 11검사 — PASS:5 · FAIL:4 · ERROR:2 (대조표 89행)
- X-ROW|ENTRY:DMF0042_BizPlan.chkSum_CheckedChanged — 진입점 집계 1검사 — FAIL:1 (대조표 5행)
- X-ROW|ENTRY:DMF0042_BizPlan.clbCustomer_SelectedIndexChanged — 진입점 집계 8검사 — ERROR:6 · PASS:1 · FAIL:1 (대조표 9행)
- X-ROW|ENTRY:DMF0042_BizPlan.clbTeam_SelectedIndexChanged — 진입점 집계 7검사 — ERROR:5 · FAIL:1 · PASS:1 (대조표 23행)
- X-ROW|ENTRY:DMF0042_BizPlan.fnValidation — 진입점 집계 1검사 — FAIL:1 (대조표 95행)
- H6|POPUP:DMF0042_BizPlan — 원장 V-903e172f ASIS / 원장 V-6b20b2e7 ASIS / 원장 V-f2abcf20 ASIS / 원장 V-b56c42ad ASIS / 원장 V-f2c4be03 ASIS / 원장 V-39cdf70a ASIS / 원장 V-bb1b832d ASIS / 원장 V-de1d5f8b (대조표 2행)
- X-ROW|ENTRY:DMF0042_BizPlan.spdMain_CellDoubleClick — 진입점 집계 78검사 — ERROR:37 · NA:24 · FAIL:8 · PASS:5 · NOPATH:2 · NOT_RUN:2 (대조표 139행)
- H6|LEDGER:V-3da3fdc9 — 원장 V-3da3fdc9 (대조표 1행)
- H6|LEDGER:V-10d1a11a — 원장 V-10d1a11a (대조표 1행)
- H6|LEDGER:V-9b10cb34 — 원장 V-9b10cb34 (대조표 1행)
- X-ROW|ENTRY:DMF0042_BizPlan.spdMain_Changed — 진입점 집계 68검사 — ERROR:43 · NA:23 · PASS:1 · FAIL:1 (대조표 468행)
- X-ROW|ENTRY:DMF0042_BizPlan.spdMain_ComboSelChange — 진입점 집계 27검사 — ERROR:13 · NA:7 · PASS:6 · FAIL:1 (대조표 17행)
- X-ROW|ENTRY:DMF0042_BizPlan.spdMain_EditChange — 진입점 집계 1검사 — FAIL:1 (대조표 7행)
- X-ROW|ENTRY:DMF0042_BizPlan.spdMain_TopChange — 진입점 집계 2검사 — FAIL:2 (대조표 6행)
- M3|POPUP:DMF0042_BizPlan_old — 원장 V-9e2dfac9 ASIS / 원장 V-7e9fa75c ASIS / 원장 V-41d0eafc ASIS / 원장 V-7b310ef6 ASIS / 원장 V-39fc6309 ASIS / 원장 V-41d17e31 ASIS / 원장 V-a08c02de ASIS / 원장 V-1eb70f98 (대조표 53행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- G4|COND:clbDivision — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbTeam — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbCustomer — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbBizType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbSalesSite — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbPlantSite — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbItemType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:cboBucketType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:drpPeriod — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:txtProject — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:chkSum — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:usrMonthFrom — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:usrMonthTo — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
