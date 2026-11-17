# 작업 원장 — SSP0060 · 2026-11-15 05:34

> 검사 인스턴스 1787건 중 PASS·NA 786건 외 **1001건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 1 | 대조표 구현 + 위치 기입 → W8 실행 |
| W3 | 동작 수정 | 120 | 재판정 PASS |
| W5 | 검사기 연결 | 39 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 135 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 705 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 705 · 사람 판정 / AS-IS 원문 확인 → 재판정 95 · 화면 FE 57 · 대조표 40 · 하네스 39 · FE 36 · DB 메타 17 · 사람판정 8 · DB 객체 2 · DB 1 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 8건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 52 |  |  |  | 7 |  | 52 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 87 | 연쇄 자동 채움 |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 70 | 배경·글자색 규칙 |
| E4 | EDIT |  |  |  |  |  |  |  |  | 64 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 59 | 무변경 편집 종료 시 연쇄 미발동 |
| D3 | EDIT |  |  |  |  |  |  |  |  | 57 | 행 값 기반 조건부 잠금 |
| H6 | POPUP |  |  |  |  | 5 |  |  |  | 40 | 팝업 표준·열림 |
| D1 | EDIT |  |  |  |  |  |  |  |  | 43 | 컬럼 편집 가능 여부(신규행·기존행) |
| A1 | GEN |  |  |  |  |  |  | 41 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-REASON | DESIGN |  |  |  |  |  |  | 40 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| H5 | DESIGN |  |  |  |  |  |  | 1 |  | 36 | 라벨 명칭 |
| F4 | DB |  |  |  |  |  |  | 5 |  | 29 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| X-LOC | GEN |  |  |  |  |  |  | 34 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| M4 | POPUP |  |  | 29 |  |  |  | 4 |  |  | 팝업 선택값 반영 |
| G5 | POPUP |  |  |  |  | 5 |  |  |  | 25 | 팝업 조건 연동(인자) |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 30 | 그리드 셀 cascade 후보 |
| G1 | GEN |  |  |  |  |  |  |  |  | 25 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A5 | DESIGN |  |  | 16 |  |  |  |  |  | 5 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| A6 | GEN |  |  | 8 |  |  |  | 3 |  | 9 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B4 | COMBO |  |  |  |  | 5 |  |  |  | 14 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  |  | 2 |  |  |  | 13 | 콤보 후보 정렬 = AS-IS |
| G4 | DESIGN |  |  | 6 |  | 7 | 1 |  |  |  | 조회조건 표시·라벨·활성 |
| E1 | EDIT |  |  |  |  |  |  |  |  | 11 | 숫자 소수자리·정수·부호·범위 |
| M3 | POPUP |  |  | 3 |  |  |  |  |  | 6 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| D5 | EDIT |  |  |  |  |  |  |  |  | 9 | 셀 에디터 유형 |
| D4 | EDIT |  |  |  |  |  |  |  |  | 8 | 신규행 기본값·자동세팅·Insert 전제 |
| B1 | COMBO |  |  |  |  | 4 |  |  |  | 2 | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 4 |  |  |  | 2 | 콤보 후보 중복 없음 |
| DB-SYN | DB |  |  |  |  | 6 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| C1 | CASCADE |  |  | 1 |  |  |  |  |  | 1 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| X-NOTIMPL | GEN | 1 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| J2 | AUTH |  |  | 1 |  |  |  |  |  |  | 권한별 버튼·기능 |
| K-SA | COMMON |  |  | 1 |  |  |  |  |  |  | 조회영역 토글 |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| F6 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 값 보존 |
| I1 | DESIGN |  |  | 1 |  |  |  |  |  |  | LBL/MSG 언어별 등록 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G3 | COMMON |  |  |  |  |  |  |  |  | 1 | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  |  |  |  | 1 | CRUD Status 표시 정합 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| D6 | EDIT |  |  |  |  |  |  |  |  | 1 | Insert 위치·상태 유지 |
| G6 | GEN |  |  |  |  |  |  |  |  | 1 | 조회조건 초기 기본값 = AS-IS Form_Load |

## W1 기능 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-0001 | X-NOTIMPL | Ra | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — Ra L5503~5510 `CONTAINER` measure 행에서 `LOT_YN=='N'` 이면 FCST_TYPE+1~끝 값 전부 null 미구현(값 규칙) |  | 1 (Ra) |

## W3 동작 수정 (120)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-0002 | J2 | SSP0060 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | J2 FAIL 수정 — SSP0060 화면: 원장 V-a2606f62 RULE_SCREEN / 원장 V-aa875ee8 DEFECT / 원장 V-767175f2 GENERAL / 원장 V-26768414 GENERAL / 원장 V-c |  | 220 (D00-1-003 D00-1-004 D00-1-007 D00-1-008 ) |
| WK-SSP0060-0003 | C1 | cboPlanDate / Plan-date / Plan Date | 화면 FE(범위 밖(가이드만)) | C1 FAIL 수정 — cboPlanDate / Plan-date / Plan Date: 실측[T-a94eb0c9]: AS-IS 는 하위 txtModel2 값을 비우는데 값 유지 · 'Plan Date*' → '2026-10-08'  |  | 5 (ACT:SSP0060_ShipmentPlan.InitSpread:631:) |
| WK-SSP0060-0004 | K-SA | SSP0060 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | K-SA FAIL 수정 — SSP0060 화면: E2E smoke common Search Area 조회영역 토글 |  | 2 (D00-1-064 COMMON:UC-02) |
| WK-SSP0060-0005 | F1 | SSP0060 화면 | DB 객체(PKG/SP)(적용 예정) | F1 FAIL 수정 — SSP0060 화면: 원장 V-455fa3da RULE_SCREEN / 원장 V-6ffc13c4 RULE_SCREEN / 원장 V-5b86dddb RULE_SCREEN / 원장 V-5c2ce4a6 RULE_SC |  | 533 (D00-2b-003 D00-2b-021 D00-2b-022 D00-2b-) |
| WK-SSP0060-0006 | F6 | SSP0060 화면 | DB 객체(PKG/SP)(적용 예정) | F6 FAIL 수정 — SSP0060 화면: 원장 V-17898347 RULE_SCREEN / 원장 V-b07e6278 RULE_SCREEN / 원장 V-bdeffec2 RULE_SCREEN / 원장 V-23552254 RULE_SC |  | 516 (D00-4-002 D00-4-003 I2 ACT:SSP0060_Shipm) |
| WK-SSP0060-0007 | A5 | COMMON:UC-01 | DB 메타(적용 예정) | A5 FAIL 수정 — COMMON:UC-01: 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터 유지(keepRowVisibleUnderFil' 의 A5 54요소: PASS:50 · ERROR |  | 1 (COMMON:UC-01) |
| WK-SSP0060-0008 | A5 | COMMON:UC-05 | DB 메타(적용 예정) | A5 FAIL 수정 — COMMON:UC-05: 행 집계 — 대조표 COMMON:UC-05 'Excel Download 콤보 컬럼 Code 아닌 Name 출력' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 ·  |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0009 | A5 | COMMON:UC-07 | DB 메타(적용 예정) | A5 FAIL 수정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 필터 유지(rebindFilterColumns)' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL |  | 1 (COMMON:UC-07) |
| WK-SSP0060-0010 | A5 | D00-1-054 | DB 메타(적용 예정) | A5 FAIL 수정 — D00-1-054: 행 집계 — 대조표 D00-1-054 'spdDetail' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E  |  | 1 (D00-1-054) |
| WK-SSP0060-0011 | A5 | D00-1-057 | DB 메타(적용 예정) | A5 FAIL 수정 — D00-1-057: 행 집계 — 대조표 D00-1-057 'spdMain_Sheet1' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — |  | 1 (D00-1-057) |
| WK-SSP0060-0012 | A5 | D00-2b-015~016 | DB 메타(적용 예정) | A5 FAIL 수정 — D00-2b-015~016: 행 집계 — 대조표 D00-2b-015~016 'MSG00007 Measure sheet 제한' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소 |  | 1 (D00-2b-015~016) |
| WK-SSP0060-0013 | A5 | D00-3-029 | DB 메타(적용 예정) | A5 FAIL 수정 — D00-3-029: 행 집계 — 대조표 D00-3-029 '조회 후 재병합·주석리셋·0치환' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Sit |  | 1 (D00-3-029) |
| WK-SSP0060-0014 | A5 | D00-4a-003 | DB 메타(적용 예정) | A5 FAIL 수정 — D00-4a-003: 행 집계 — 대조표 D00-4a-003 'SaveButton' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E |  | 1 (D00-4a-003) |
| WK-SSP0060-0015 | A5 | I14 | DB 메타(적용 예정) | A5 FAIL 수정 — I14: 행 집계 — 대조표 I14 '정정: BaseForm.FpSpread_CellClick(BaseForm.cs L2303~' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL |  | 1 (I14) |
| WK-SSP0060-0016 | A5 | I16 | DB 메타(적용 예정) | A5 FAIL 수정 — I16: 행 집계 — 대조표 I16 'InitSpreadFooterSum(.cs L764~853 — 시트별 수치구간 Sum + ' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL |  | 1 (I16) |
| WK-SSP0060-0017 | A5 | I16 Measure 시트변형 | DB 메타(적용 예정) | A5 FAIL 수정 — I16 Measure 시트변형: 행 집계 — 대조표 I16 Measure 시트변형 '검증축' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Sit |  | 1 (I16 Measure 시트변형) |
| WK-SSP0060-0018 | A5 | I9 | DB 메타(적용 예정) | A5 FAIL 수정 — I9: 행 집계 — 대조표 I9 'Division/Company 변경 시 그리드 초기화(hook #5, np §5-5)' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소:  |  | 1 (I9) |
| WK-SSP0060-0019 | A5 | TO_SITE / To Site | DB 메타(적용 예정) | A5 FAIL 수정 — TO_SITE / To Site: E2E smoke columns / 실측[T-3b6b3ca6]: TO_SITE: AS-IS(Div 82) '숨김' ↔ TO-BE 표시=Y — 표시 여부 불일치 (TO-BE 메타 |  | 6 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0020 | A5 | 메타 SQL 3종(18/19/20) 적용 | DB 메타(적용 예정) | A5 FAIL 수정 — 메타 SQL 3종(18/19/20) 적용: 행 집계 — 대조표 메타 SQL 3종(18/19/20) 적용 'ERROR(미실행)' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요 |  | 1 (메타 SQL 3종(18/19/20) 적용) |
| WK-SSP0060-0021 | A5 | 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E | DB 메타(적용 예정) | A5 FAIL 수정 — 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·EE행 TransMode 드롭다운: 행 집계 — 대조표 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·EE행 Tran |  | 1 (브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E) |
| WK-SSP0060-0022 | A5 | 음수 = 빨간 글자 | DB 메타(적용 예정) | A5 FAIL 수정 — 음수 = 빨간 글자: 행 집계 — 대조표 음수 = 빨간 글자 '**이식**' 의 A5 54요소: PASS:50 · ERROR:3 · FAIL:1 · FAIL 요소: TO_SITE / To Site — E2E s |  | 1 (음수 = 빨간 글자) |
| WK-SSP0060-0023 | G4 | COMMON:UC-06 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 콤마 다중 입력 전건 조회' 의 G4 18요소: NOPATH:7 · NA:6 · FAIL:3 · PASS:1 · NOT |  | 1 (COMMON:UC-06) |
| WK-SSP0060-0024 | G4 | D00-4e-001 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — D00-4e-001: 행 집계 — 대조표 D00-4e-001 'ItembyDivision(조회조건 2차)' 의 G4 18요소: NOPATH:7 · NA:6 · FAIL:3 · PASS:1 · NOT_RUN:1  |  | 1 (D00-4e-001) |
| WK-SSP0060-0025 | G4 | D00-4e-008 | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — D00-4e-008: 행 집계 — 대조표 D00-4e-008 'ItembyDivision(조회조건 1차)' 의 G4 18요소: NOPATH:7 · NA:6 · FAIL:3 · PASS:1 · NOT_RUN:1  |  | 1 (D00-4e-008) |
| WK-SSP0060-0026 | G4 | chkSum / Sum(Week) / Sum | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — chkSum / Sum(Week) / Sum: E2E smoke labels — 누락 라벨 |  | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0027 | G4 | chkTotPSI / Total PSI / Tot PSI | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — chkTotPSI / Total PSI / Tot PSI: 원장 V-dbc3c7d1 SEARCH / E2E smoke labels — 누락 라벨 |  | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0028 | G4 | clbResultType / Result Type | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbResultType / Result Type: E2E smoke labels — 누락 라벨 |  | 2 (ACT:SSP0060_ShipmentPlan.InitControls AC) |
| WK-SSP0060-0029 | I1 | SSP0060 화면 | DB 메타(적용 예정) | I1 FAIL 수정 — SSP0060 화면: 원장 V-71580525 RULE_SCREEN / 원장 V-e5329991 RULE_SCREEN / 원장 V-e29f70d6 RULE_SCREEN / 원장 V-7bce069a DEFECT  |  | 111 (D00-2-014 D00-2b-002 D00-2b-003 D00-2b-0) |
| WK-SSP0060-0030 | A6 | CRUD:SEARCH | 사람판정(사람판정 대기) | A6 FAIL 수정 — CRUD:SEARCH: 행 집계 — 대조표 CRUD:SEARCH 'FindData_Main + Detail 8-sheet 조회' 의 A6 16요소: ERROR:9 · NOT_RUN:3 · PASS:2 · FAI |  | 1 (CRUD:SEARCH) |
| WK-SSP0060-0031 | A6 | D00-4a-002 | 사람판정(사람판정 대기) | A6 FAIL 수정 — D00-4a-002: 행 집계 — 대조표 D00-4a-002 'FindButton' 의 A6 16요소: ERROR:9 · NOT_RUN:3 · PASS:2 · FAIL:2 · FAIL 요소: PKG_SSP006 |  | 1 (D00-4a-002) |
| WK-SSP0060-0032 | A6 | D00-4a-003 | 사람판정(사람판정 대기) | A6 FAIL 수정 — D00-4a-003: 행 집계 — 대조표 D00-4a-003 'SaveButton' 의 A6 16요소: ERROR:9 · NOT_RUN:3 · PASS:2 · FAIL:2 · FAIL 요소: PKG_SSP006 |  | 1 (D00-4a-003) |
| WK-SSP0060-0033 | A6 | D00-4a-004 | 사람판정(사람판정 대기) | A6 FAIL 수정 — D00-4a-004: 행 집계 — 대조표 D00-4a-004 'DeleteButton (NO-OP 확정)' 의 A6 16요소: ERROR:9 · NOT_RUN:3 · PASS:2 · FAIL:2 · FAIL 요 |  | 1 (D00-4a-004) |
| WK-SSP0060-0034 | A6 | D00-4a-005 | 사람판정(사람판정 대기) | A6 FAIL 수정 — D00-4a-005: 행 집계 — 대조표 D00-4a-005 'InsertButton' 의 A6 16요소: ERROR:9 · NOT_RUN:3 · PASS:2 · FAIL:2 · FAIL 요소: PKG_SSP0 |  | 1 (D00-4a-005) |
| WK-SSP0060-0035 | A6 | D00-4a-006~036 | 사람판정(사람판정 대기) | A6 FAIL 수정 — D00-4a-006~036: 행 집계 — 대조표 D00-4a-006~036 'event 29종' 의 A6 16요소: ERROR:9 · NOT_RUN:3 · PASS:2 · FAIL:2 · FAIL 요소: PKG |  | 1 (D00-4a-006~036) |
| WK-SSP0060-0036 | A6 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_ | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_DETAIL: 원장 V-67e6b905 SP / 원장 V-bb23d73a SP / 정렬대조 FAIL 3번째 키부터 다름: AS-IS ['Y |  | 97 (D00-4-019 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0037 | A6 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUE | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING: 원장 V-c4c65f9c SP / 원장 V-b404c22c SP / 정렬대조 FAIL 1번째 키부터  |  | 50 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0038 | X-ROW | SSP0060_ShipmentPlan.BtnItemID2_Click | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.BtnItemID2_Click: 진입점 집계 9검사 — NA:4 · ERROR:3 · FAIL:1 · PASS:1 (FX-SSP0060-117) |  | 5 (ACT:SSP0060_ShipmentPlan.BtnItemID2_Clic) |
| WK-SSP0060-0039 | X-ROW | SSP0060_ShipmentPlan.BtnMeasure_Click | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.BtnMeasure_Click: 진입점 집계 11검사 — ERROR:4 · FAIL:3 · NA:2 · PASS:2 (FX-SSP0060-118) |  | 5 (ACT:SSP0060_ShipmentPlan.BtnMeasure_Clic) |
| WK-SSP0060-0040 | X-ROW | SSP0060_ShipmentPlan.BtnNew_Click | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.BtnNew_Click: 진입점 집계 29검사 — ERROR:19 · NOPATH:6 · NA:3 · FAIL:1 (FX-SSP0060-119) |  | 3 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0041 | X-ROW | SSP0060_ShipmentPlan.BtnRequestor_Click | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.BtnRequestor_Click: 진입점 집계 7검사 — ERROR:3 · PASS:3 · FAIL:1 (FX-SSP0060-120) |  | 10 (ACT:SSP0060_ShipmentPlan.BtnRequestor_Cl) |
| WK-SSP0060-0042 | X-ROW | SSP0060_ShipmentPlan.BtnSearch_Click | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.BtnSearch_Click: 진입점 집계 2검사 — FAIL:1 · ERROR:1 (FX-SSP0060-121) |  | 12 (ACT:SSP0060_ShipmentPlan.BtnSearch_Click) |
| WK-SSP0060-0043 | X-ROW | SSP0060_ShipmentPlan.EditByChange | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.EditByChange: 진입점 집계 4검사 — ERROR:3 · FAIL:1 (FX-SSP0060-124) |  | 32 (ACT:SSP0060_ShipmentPlan.EditByChange AC) |
| WK-SSP0060-0044 | X-ROW | SSP0060_ShipmentPlan.FindData_Detail | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.FindData_Detail: 진입점 집계 18검사 — PASS:10 · ERROR:4 · NA:2 · REVIEW:1 · FAIL:1 (FX-SSP0060-126) |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_Detail) |
| WK-SSP0060-0045 | X-ROW | SSP0060_ShipmentPlan.GetErpIFCheck | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.GetErpIFCheck: 진입점 집계 12검사 — ERROR:6 · NOPATH:3 · PASS:1 · REVIEW:1 · FAIL:1 |  | 1 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck) |
| WK-SSP0060-0046 | X-ROW | SSP0060_ShipmentPlan.InitControls | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.InitControls: 진입점 집계 11검사 — PASS:5 · NA:4 · ERROR:1 · FAIL:1 (FX-SSP0060-133) |  | 7 (ACT:SSP0060_ShipmentPlan.InitControls:46) |
| WK-SSP0060-0047 | X-ROW | SSP0060_ShipmentPlan.InitSpread | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.InitSpread: 진입점 집계 46검사 — PASS:21 · ERROR:21 · FAIL:2 · NA:2 (FX-SSP0060-134) |  | 18 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0048 | X-ROW | SSP0060_ShipmentPlan.NewNonSoNo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.NewNonSoNo: 진입점 집계 8검사 — ERROR:5 · PASS:2 · FAIL:1 (FX-SSP0060-138) |  | 132 (ACT:SSP0060_ShipmentPlan.NewNonSoNo ACT:) |
| WK-SSP0060-0049 | X-ROW | SSP0060_ShipmentPlan.NonSoNo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.NonSoNo: 진입점 집계 8검사 — ERROR:3 · PASS:2 · NA:2 · FAIL:1 (FX-SSP0060-139) |  | 126 (ACT:SSP0060_ShipmentPlan.NonSoNo ACT:SSP) |
| WK-SSP0060-0050 | X-ROW | SSP0060_ShipmentPlan.Plan_Current_Check | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.Plan_Current_Check: 진입점 집계 8검사 — NA:6 · FAIL:2 (FX-SSP0060-140) |  | 21 (ACT:SSP0060_ShipmentPlan.Plan_Current_Ch) |
| WK-SSP0060-0051 | X-ROW | SSP0060_ShipmentPlan.SaveData_Detail | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.SaveData_Detail: 진입점 집계 31검사 — PASS:12 · ERROR:10 · NA:4 · FAIL:3 · REVIEW:1 · NOPATH:1 (FX-S |  | 4 (ACT:SSP0060_ShipmentPlan.SaveData_Detail) |
| WK-SSP0060-0052 | X-ROW | SSP0060_ShipmentPlan.SaveData_Main | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.SaveData_Main: 진입점 집계 26검사 — ERROR:11 · PASS:9 · FAIL:3 · NA:3 (FX-SSP0060-145) |  | 7 (ACT:SSP0060_ShipmentPlan.SaveData_Main:2) |
| WK-SSP0060-0053 | X-ROW | SSP0060_ShipmentPlan.Simulation | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.Simulation: 진입점 집계 4검사 — ERROR:3 · FAIL:1 (FX-SSP0060-147) |  | 195 (ACT:SSP0060_ShipmentPlan.Simulation ACT:) |
| WK-SSP0060-0054 | X-ROW | SSP0060_ShipmentPlan.SoNo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.SoNo: 진입점 집계 8검사 — ERROR:3 · NA:2 · PASS:2 · FAIL:1 (FX-SSP0060-148) |  | 141 (ACT:SSP0060_ShipmentPlan.SoNo ACT:SSP006) |
| WK-SSP0060-0055 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_CellDoubl | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.SpdDetail_CellDoubleClick: 진입점 집계 59검사 — ERROR:28 · FAIL:13 · NA:12 · NOPATH:4 · PASS:2 (FX-S |  | 7 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0056 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_Clipboard | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.SpdDetail_ClipboardPasted: 진입점 집계 64검사 — ERROR:53 · NA:10 · FAIL:1 (FX-SSP0060-150) |  | 21 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0057 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_ComboSelC | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.SpdDetail_ComboSelChange: 진입점 집계 42검사 — ERROR:41 · FAIL:1 (FX-SSP0060-151) |  | 11 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0058 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_EditChang | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.SpdDetail_EditChange: 진입점 집계 28검사 — ERROR:25 · NA:2 · FAIL:1 (FX-SSP0060-152) |  | 50 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0059 | X-ROW | SSP0060_ShipmentPlan.SpdMain_CellDoubleC | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.SpdMain_CellDoubleClick: 진입점 집계 9검사 — PASS:4 · FAIL:2 · NOPATH:2 · NOT_RUN:1 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-0060 | X-ROW | SSP0060_ShipmentPlan.SpdMain_ClipboardPa | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.SpdMain_ClipboardPasted: 진입점 집계 7검사 — ERROR:4 · NA:2 · FAIL:1 (FX-SSP0060-153) |  | 1 (ACT:SSP0060_ShipmentPlan.SpdMain_Clipboa) |
| WK-SSP0060-0061 | X-ROW | SSP0060_ShipmentPlan.Validation_Check | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.Validation_Check: 진입점 집계 26검사 — ERROR:19 · NA:6 · FAIL:1 (FX-SSP0060-154) |  | 106 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0062 | X-ROW | SSP0060_ShipmentPlan.btnItemId_Click | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.btnItemId_Click: 진입점 집계 9검사 — ERROR:3 · NA:3 · FAIL:2 · PASS:1 (FX-SSP0060-155) |  | 5 (ACT:SSP0060_ShipmentPlan.btnItemId_Click) |
| WK-SSP0060-0063 | X-ROW | SSP0060_ShipmentPlan.checkValidN | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.checkValidN: 진입점 집계 3검사 — NA:2 · FAIL:1 (FX-SSP0060-157) |  | 17 (ACT:SSP0060_ShipmentPlan.checkValidN ACT) |
| WK-SSP0060-0064 | X-ROW | SSP0060_ShipmentPlan.chkERPIFBlockYn | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.chkERPIFBlockYn: 진입점 집계 3검사 — NA:2 · FAIL:1 (FX-SSP0060-158) |  | 13 (ACT:SSP0060_ShipmentPlan.chkERPIFBlockYn) |
| WK-SSP0060-0065 | X-ROW | SSP0060_ShipmentPlan.clbCompanyID_Select | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.clbCompanyID_SelectedIndexChanged: 진입점 집계 10검사 — NOT_RUN:3 · PASS:3 · NA:2 · FAIL:1 · NOPATH: |  | 9 (ACT:SSP0060_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0060-0066 | X-ROW | SSP0060_ShipmentPlan.shtDetail_Change | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.shtDetail_Change: 진입점 집계 9검사 — ERROR:8 · FAIL:1 (FX-SSP0060-160) |  | 71 (ACT:SSP0060_ShipmentPlan.shtDetail_Chang) |
| WK-SSP0060-0067 | X-ROW | SSP0060_ShipmentPlan.spdMain_KeyUp | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlan.spdMain_KeyUp: 진입점 집계 2검사 — FAIL:1 · NA:1 (FX-SSP0060-161) |  | 25 (ACT:SSP0060_ShipmentPlan.spdMain_KeyUp A) |
| WK-SSP0060-0068 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.F | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanConfirmDetailPopup.FindButton: 진입점 집계 4검사 — ERROR:2 · REVIEW:1 · FAIL:1 (FX-SSP0060-162) |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0069 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.F | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanConfirmDetailPopup.FindDataMain: 진입점 집계 7검사 — ERROR:3 · PASS:2 · REVIEW:1 · FAIL:1 (FX-SSP0060 |  | 22 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0070 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.I | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanConfirmDetailPopup.InitSpread: 진입점 집계 190검사 — NA:76 · PASS:59 · ERROR:54 · FAIL:1 (FX-SSP0060- |  | 71 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0071 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.b | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanConfirmDetailPopup.btnButtonList_UsrButt: 진입점 집계 3검사 — ERROR:2 · FAIL:1 (FX-SSP0060-166) |  | 3 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0072 | X-ROW | SSP0060_ShipmentPlanRequestPopup.ChkERPI | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.ChkERPIFBlockYn: 진입점 집계 4검사 — NA:2 · ERROR:1 · FAIL:1 (FX-SSP0060-167) |  | 13 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-0073 | X-ROW | SSP0060_ShipmentPlanRequestPopup.ChkEngP | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.ChkEngProcessing: 진입점 집계 7검사 — PASS:2 · NA:2 · REVIEW:1 · ERROR:1 · FAIL:1 (FX-SS |  | 15 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-0074 | X-ROW | SSP0060_ShipmentPlanRequestPopup.FindBut | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.FindButton: 진입점 집계 4검사 — ERROR:2 · REVIEW:1 · FAIL:1 (FX-SSP0060-170) |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Fin) |
| WK-SSP0060-0075 | X-ROW | SSP0060_ShipmentPlanRequestPopup.FindDat | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.FindData_Main: 진입점 집계 7검사 — ERROR:2 · PASS:2 · REVIEW:1 · FAIL:1 · NA:1 (FX-SSP00 |  | 24 (ACT:SSP0060_ShipmentPlanRequestPopup.Fin) |
| WK-SSP0060-0076 | X-ROW | SSP0060_ShipmentPlanRequestPopup.GetERPI | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.GetERPInterface: 진입점 집계 25검사 — NA:12 · ERROR:9 · PASS:3 · FAIL:1 (FX-SSP0060-172) |  | 106 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0077 | X-ROW | SSP0060_ShipmentPlanRequestPopup.GetShip | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.GetShipmentStatusChk: 진입점 집계 13검사 — NA:7 · ERROR:3 · PASS:2 · FAIL:1 (FX-SSP0060- |  | 31 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0078 | X-ROW | SSP0060_ShipmentPlanRequestPopup.InitSpr | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.InitSpread: 진입점 집계 194검사 — NA:77 · PASS:59 · ERROR:57 · FAIL:1 (FX-SSP0060-176) |  | 71 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-0079 | X-ROW | SSP0060_ShipmentPlanRequestPopup.NonSoNo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.NonSoNo: 진입점 집계 7검사 — ERROR:3 · PASS:2 · FAIL:1 · NA:1 (FX-SSP0060-177) |  | 111 (ACT:SSP0060_ShipmentPlanRequestPopup.Non) |
| WK-SSP0060-0080 | X-ROW | SSP0060_ShipmentPlanRequestPopup.SSP0060 | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.SSP0060_ShipmentPlanRequest: 진입점 집계 7검사 — ERROR:5 · NOT_RUN:1 · FAIL:1 (FX-SSP006 |  | 4 (ACT:SSP0060_ShipmentPlanRequestPopup.SSP) |
| WK-SSP0060-0081 | X-ROW | SSP0060_ShipmentPlanRequestPopup.SaveBut | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.SaveButton: 진입점 집계 8검사 — ERROR:4 · FAIL:2 · PASS:1 · REVIEW:1 (FX-SSP0060-179) |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Sav) |
| WK-SSP0060-0082 | X-ROW | SSP0060_ShipmentPlanRequestPopup.SaveDat | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.SaveData: 진입점 집계 23검사 — PASS:8 · ERROR:8 · FAIL:3 · NA:3 · REVIEW:1 (FX-SSP0060-1 |  | 177 (ACT:SSP0060_ShipmentPlanRequestPopup.Sav) |
| WK-SSP0060-0083 | X-ROW | SSP0060_ShipmentPlanRequestPopup.SoNo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.SoNo: 진입점 집계 10검사 — ERROR:4 · NA:3 · PASS:2 · FAIL:1 (FX-SSP0060-182) |  | 76 (ACT:SSP0060_ShipmentPlanRequestPopup.SoN) |
| WK-SSP0060-0084 | X-ROW | SSP0060_ShipmentPlanRequestPopup.Validat | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.Validation_Check: 진입점 집계 5검사 — ERROR:2 · NA:2 · FAIL:1 (FX-SSP0060-183) |  | 15 (ACT:SSP0060_ShipmentPlanRequestPopup.Val) |
| WK-SSP0060-0085 | X-ROW | SSP0060_ShipmentPlanRequestPopup.btnAuto | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.btnAutoSet_Click: 진입점 집계 9검사 — ERROR:6 · FAIL:2 · NA:1 (FX-SSP0060-184) |  | 4 (ACT:SSP0060_ShipmentPlanRequestPopup.btn) |
| WK-SSP0060-0086 | X-ROW | SSP0060_ShipmentPlanRequestPopup.btnButt | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.btnButtonList_UsrButtonList: 진입점 집계 3검사 — ERROR:2 · FAIL:1 (FX-SSP0060-185) |  | 3 (ACT:SSP0060_ShipmentPlanRequestPopup.btn) |
| WK-SSP0060-0087 | X-ROW | SSP0060_ShipmentPlanRequestPopup.spdMain | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.spdMain_ClipboardPasted: 진입점 집계 6검사 — ERROR:4 · FAIL:1 · NA:1 (FX-SSP0060-186) |  | 5 (ACT:SSP0060_ShipmentPlanRequestPopup.spd) |
| WK-SSP0060-0088 | X-ROW | SSP0060_ShipmentPlanRequestPopup.spdMain | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.spdMain_KeyDown: 진입점 집계 3검사 — ERROR:1 · FAIL:1 · NA:1 (FX-SSP0060-187) |  | 23 (ACT:SSP0060_ShipmentPlanRequestPopup.spd) |
| WK-SSP0060-0089 | X-ROW | SSP0060_ShipmentPlanRequestPopup.usrButt | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0060_ShipmentPlanRequestPopup.usrButtonList1_UsrButtonLis: 진입점 집계 3검사 — ERROR:2 · FAIL:1 (FX-SSP0060-188) |  | 8 (ACT:SSP0060_ShipmentPlanRequestPopup.usr) |
| WK-SSP0060-0090 | M3 | new SCM0002_ItembyDivisionPopup() | 화면 FE(범위 밖(가이드만)) | M3 FAIL 수정 — new SCM0002_ItembyDivisionPopup(): 원장 V-337977ae (FX-SSP0060-021) |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0091 | M3 | new SCM0002_ItembyDivisionPopup() | 화면 FE(범위 밖(가이드만)) | M3 FAIL 수정 — new SCM0002_ItembyDivisionPopup(): 원장 V-7acfe98c (FX-SSP0060-022) |  | 1 (ACT:SSP0060_ShipmentPlan.btnItemId_Click) |
| WK-SSP0060-0092 | M3 | new SCM0002_TitleSetForm_Popup("SSP0060" | 화면 FE(범위 밖(가이드만)) | M3 FAIL 수정 — new SCM0002_TitleSetForm_Popup("SSP0060", shtName, false): 원장 V-c2145116 (FX-SSP0060-015) |  | 1 (ACT:SSP0060_ShipmentPlan.BtnMeasure_Clic) |
| WK-SSP0060-0093 | M4 | BOH_QTY | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — BOH_QTY: 실측[T-57d48d9f]: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 25 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-0094 | M4 | CONFIRM_ID / Confirm/Plan ID | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — CONFIRM_ID / Confirm/Plan ID: 실측[T-f5e8d2af]: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0095 | M4 | D00-2-024 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-2-024: 행 집계 — 대조표 D00-2-024 'SpdMain_CellDoubleClick' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FAIL 요소: btnIte |  | 1 (D00-2-024) |
| WK-SSP0060-0096 | M4 | D00-2b-006~008 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-2b-006~008: 행 집계 — 대조표 D00-2b-006~008 'MSG00098 Item 팝업 필수 3종' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FAIL 요 |  | 1 (D00-2b-006~008) |
| WK-SSP0060-0097 | M4 | D00-2b-009~012 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-2b-009~012: 행 집계 — 대조표 D00-2b-009~012 'MSG00098 Project 팝업 필수 4종' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FAI |  | 1 (D00-2b-009~012) |
| WK-SSP0060-0098 | M4 | D00-3-016 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-3-016: 행 집계 — 대조표 D00-3-016 'Project 팝업 결과 반영' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FAIL 요소: btnItemId — 실 |  | 1 (D00-3-016) |
| WK-SSP0060-0099 | M4 | D00-4d-019~030 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-4d-019~030: 행 집계 — 대조표 D00-4d-019~030 "CellDoubleClick 가드 12종(sheet/컬럼/action='I'/필수값)" 의 M4 17요소: FAIL:13 · NOT_ |  | 1 (D00-4d-019~030) |
| WK-SSP0060-0100 | M4 | D00-4e-001 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-4e-001: 행 집계 — 대조표 D00-4e-001 'ItembyDivision(조회조건 2차)' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FAIL 요소: btnI |  | 1 (D00-4e-001) |
| WK-SSP0060-0101 | M4 | D00-4e-002 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-4e-002: 행 집계 — 대조표 D00-4e-002 'ItembyDivision(Detail 셀)' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FAIL 요소: btn |  | 1 (D00-4e-002) |
| WK-SSP0060-0102 | M4 | D00-4e-003 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-4e-003: 행 집계 — 대조표 D00-4e-003 'ProjectbyDivision(Detail 셀)' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FAIL 요소:  |  | 1 (D00-4e-003) |
| WK-SSP0060-0103 | M4 | D00-4e-005 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-4e-005: 행 집계 — 대조표 D00-4e-005 'ShipmentPlanConfirmDetailPopup' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FAIL 요 |  | 1 (D00-4e-005) |
| WK-SSP0060-0104 | M4 | D00-4e-006 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-4e-006: 행 집계 — 대조표 D00-4e-006 'TitleSetForm(Measure)' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FAIL 요소: btnIte |  | 1 (D00-4e-006) |
| WK-SSP0060-0105 | M4 | D00-4e-007 | DB(🛠️/🧯 적용 가능) | M4 FAIL 수정 — D00-4e-007: 행 집계 — 대조표 D00-4e-007 'UserInfoPopup(Requestor)' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FAIL 요소: btn |  | 1 (D00-4e-007) |
| WK-SSP0060-0106 | M4 | D00-4e-008 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-4e-008: 행 집계 — 대조표 D00-4e-008 'ItembyDivision(조회조건 1차)' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FAIL 요소: btnI |  | 1 (D00-4e-008) |
| WK-SSP0060-0107 | M4 | D00-4e-009~021 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — D00-4e-009~021: 행 집계 — 대조표 D00-4e-009~021 'ProgressForm ×12 + Request' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FA |  | 1 (D00-4e-009~021) |
| WK-SSP0060-0108 | M4 | DIVISION_ID / Div | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — DIVISION_ID / Div: 실측[T-c4ffcb56]: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0109 | M4 | ERP_SO_NO / SO No | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — ERP_SO_NO / SO No: 실측[T-dfd290a7]: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 5 (D00-2-018 MODAL:OrderDetailPopup ACT:SSP) |
| WK-SSP0060-0110 | M4 | FCST_TYPE / FCST Type | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — FCST_TYPE / FCST Type: 실측[T-8d062548]: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않 |  | 30 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-0111 | M4 | FROM_SITE_DESCRIPTION / From Site | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — FROM_SITE_DESCRIPTION / From Site: 실측[T-3e903752]: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행 |  | 3 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0112 | M4 | I10 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — I10: 행 집계 — 대조표 I10 'SpdMain_CellDoubleClick(.cs L2320~2381): MES=Detai' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 ·  |  | 1 (I10) |
| WK-SSP0060-0113 | M4 | I12 Requestor 팝업 | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — I12 Requestor 팝업: 행 집계 — 대조표 I12 Requestor 팝업 '이미구현' 의 M4 17요소: FAIL:13 · NOT_RUN:2 · REVIEW:2 · FAIL 요소: btnItemId — |  | 1 (I12 Requestor 팝업) |
| WK-SSP0060-0114 | M4 | ITEM_ID / Model | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — ITEM_ID / Model: 실측[T-394ac258]: ITEM_ID: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되 |  | 79 (D00-2-018 D00-3-015 ACT:SSP0060_Shipment) |
| WK-SSP0060-0115 | M4 | NICK_NAME / Nick Name | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — NICK_NAME / Nick Name: 실측[T-3515484b]: NICK_NAME: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 |  | 4 (D00-3-015 ACT:SSP0060_ShipmentPlan.SpdDe) |
| WK-SSP0060-0116 | M4 | PROJECT_CODE / Project Code | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — PROJECT_CODE / Project Code: 실측[T-b27c680c]: PROJECT_CODE: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서  |  | 47 (D00-2-018 ACT:SSP0060_ShipmentPlan.SpdDe) |
| WK-SSP0060-0117 | M4 | PROJECT_NAME / Project Name | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — PROJECT_NAME / Project Name: 실측[T-1ea292e3]: PROJECT_NAME: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서  |  | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0118 | M4 | REMARKS2 / Building | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — REMARKS2 / Building: 실측[T-4d180528]: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0119 | M4 | SHIPMENT_DATE / Shipment Date | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — SHIPMENT_DATE / Shipment Date: 실측[T-e9c26091]: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나 |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0120 | M4 | SSP0060_ShipmentPlan.SpdMain_CellDoubleC | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — SSP0060_ShipmentPlan.SpdMain_CellDoubleClick: 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SpdMain_CellDoubleClick 의 M4 2요소: FAI |  | 3 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-0121 | M4 | TO_SITE_DESCRIPTION / To Site | FE(repairScope=DB_ONLY — 이번 범위 밖) | M4 FAIL 수정 — TO_SITE_DESCRIPTION / To Site: 실측[T-19c5db85]: PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 선택 뒤에도 0행 T305) — 팝업에서 가져온 값이 행에 하나 |  | 3 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |

## W5 검사기 연결 (39)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-0122 | B1 | END_CUSTOMER / End Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUSTOMER / End Customer | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-0123 | B1 | FROM_SITE_DESCRIPTION / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL FROM_SITE_DESCRIPTION / From Site | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0124 | B1 | TO_SITE_DESCRIPTION / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TO_SITE_DESCRIPTION / To Site | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0125 | B1 | TRANSPORT_MODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE / Trans Mode | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0126 | B2 | END_CUSTOMER / End Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUSTOMER / End Customer | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-0127 | B2 | FROM_SITE_DESCRIPTION / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL FROM_SITE_DESCRIPTION / From Site | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0128 | B2 | TO_SITE_DESCRIPTION / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TO_SITE_DESCRIPTION / To Site | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0129 | B2 | TRANSPORT_MODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL TRANSPORT_MODE / Trans Mode | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0130 | B3 | TRANSPORT_MODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL TRANSPORT_MODE / Trans Mode | 있음(SHEET_COLUMNS) | 3 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0131 | B3 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-019) |
| WK-SSP0060-0132 | B4 | END_CUSTOMER / End Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUSTOMER / End Customer | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-0133 | B4 | FROM_SITE_DESCRIPTION / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FROM_SITE_DESCRIPTION / From Site | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0134 | B4 | TO_SITE_DESCRIPTION / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TO_SITE_DESCRIPTION / To Site | 있음(SHEET_COLUMNS) | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0135 | B4 | TRANSPORT_MODE / Trans Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL TRANSPORT_MODE / Trans Mode | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0136 | B4 | clbResultType / Result Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbResultType / Result Type | 있음(FE 소스) | 1 (D00-1-019) |
| WK-SSP0060-0137 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 3 (D00-4-017 ACT:SSP0060_ShipmentPlan.GetBu) |
| WK-SSP0060-0138 | DB-SYN | P_PROCEDURE_KEY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_PROCEDURE_KEY | 없음(PROC_M 대응 없음) | 1 (ACT:SSP0060_ShipmentPlan.GetNERPCode:715) |
| WK-SSP0060-0139 | DB-SYN | P_SSP0060_GET_CALENDAR | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SSP0060_GET_CALENDAR | 없음(PROC_M 대응 없음) | 1 (D00-4-028) |
| WK-SSP0060-0140 | DB-SYN | SSP0002_GET_NERP_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0002_GET_NERP_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0060_ShipmentPlan.GetNERPCode:714) |
| WK-SSP0060-0141 | DB-SYN | SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0142 | DB-SYN | SSP0060_SAVE_HOLD_STOCK_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0060_SAVE_HOLD_STOCK_DATA | 없음(PROC_M 대응 없음) | 3 (ACT:SSP0060_ShipmentPlan.SaveData_Detail) |
| WK-SSP0060-0143 | G4 | btnItemID2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemID2 | 있음(FE 소스) | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0144 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0145 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 없음 | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0146 | G4 | btnNew | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnNew | 있음(FE 소스) | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0147 | G4 | btnRequestor | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnRequestor | 있음(FE 소스) | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0148 | G4 | btnSearch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSearch | 있음(FE 소스) | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0149 | G4 | btnSimulation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSimulation | 없음 | 2 (ACT:SSP0060_ShipmentPlan.InitEvent ACT:S) |
| WK-SSP0060-0150 | G03-WIRE | SSP0060 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0060 화면 | 판단불가(대상 단위 SCREEN) | 42 (ACT:SSP0060_ShipmentPlan..ctor ACT:SSP00) |
| WK-SSP0060-0151 | G5 | NICK_NAME / Nick Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL NICK_NAME / Nick Name | 있음(SHEET_COLUMNS) | 1 (D00-3-015) |
| WK-SSP0060-0152 | G5 | REMARKS2 / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL REMARKS2 / Building | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0153 | G5 | SHIPMENT_DATE / Shipment Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL SHIPMENT_DATE / Shipment Date | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0154 | G5 | btnId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnId | 있음(FE 소스) | 1 (D00-4e-004) |
| WK-SSP0060-0155 | G5 | btnItemID2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnItemID2 | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SSP0060-0156 | H6 | NICK_NAME / Nick Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME / Nick Name | 있음(SHEET_COLUMNS) | 1 (D00-3-015) |
| WK-SSP0060-0157 | H6 | REMARKS2 / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL REMARKS2 / Building | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0158 | H6 | SHIPMENT_DATE / Shipment Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL SHIPMENT_DATE / Shipment Date | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0159 | H6 | btnId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnId | 있음(FE 소스) | 1 (D00-4e-004) |
| WK-SSP0060-0160 | H6 | btnItemID2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemID2 | 있음(FE 소스) | 1 (D00-1-003) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-0161 | G4 | cboChangeReason / Change Reason | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboChangeReason / Change Reason · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |

## W7 기대값 확정 (135)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-0162 | F4 | P_PROCEDURE_KEY | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — P_PROCEDURE_KEY: 실측[T-2409bf53]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed)] T87 |  | 1 (ACT:SSP0060_ShipmentPlan.GetNERPCode:715) |
| WK-SSP0060-0163 | F4 | SSP0002_GET_NERP_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0002_GET_NERP_CODE: 실측[T-0459ff01]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=confirmed |  | 2 (ACT:SSP0060_ShipmentPlan.GetNERPCode:714) |
| WK-SSP0060-0164 | F4 | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0003_GET_SSP_PLAN_PROCESSING_CHECK: 실측[T-6baca7d1]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv  |  | 181 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-0165 | F4 | SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING: 실측[T-8c66d86d]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.c |  | 4 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0166 | F4 | SSP0060_SAVE_HOLD_STOCK_DATA | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0060_SAVE_HOLD_STOCK_DATA: 실측[T-a138aecb]: [시험 검사 CM-020 — FAIL 승격 전(화면 2개 이상 사용자 확인 뒤 check_maturity.csv status=co |  | 241 (ACT:SSP0060_ShipmentPlan.SaveButton ACT:) |
| WK-SSP0060-0167 | H5 | chkSum / Sum(Week) / Sum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — chkSum / Sum(Week) / Sum: 검증 엔진이 실행됐으나 이 대상(COND chkSum)을 판정하지 못함 — 라벨 명칭 시나리오 수동 확인 또는 엔진 확장 |  | 3 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0168 | X-REASON | BOH FIGURE 더블클릭 드릴 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — BOH FIGURE 더블클릭 드릴 해당없음 `FIGURE` 0 hit — SSP0060 은 `BOH_TYPE`(7 hit) 체계다 |  | 1 (BOH FIGURE 더블클릭 드릴) |
| WK-SSP0060-0169 | X-REASON | D00-2-023 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-023 SpdDetail_TopChange  [WINFORMS] 스크롤 병합 재적용 — 공용 CustomMergeManager 자동 해당없음 |  | 1 (D00-2-023) |
| WK-SSP0060-0170 | X-REASON | D00-2-027 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-027 spdMain_KeyDown  [WINFORMS] FarPoint InputMap 커스텀 — Wijmo 기본 키맵 등가 해당없음 |  | 1 (D00-2-027) |
| WK-SSP0060-0171 | X-REASON | D00-2-028 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-028 spdMain_KeyUp  [WINFORMS] 동상 해당없음 |  | 1 (D00-2-028) |
| WK-SSP0060-0172 | X-REASON | D00-2-029 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-029 SpdMain_TopChange  [WINFORMS] SmartColMerge 재적용 — 공용 병합 매니저 자동 해당없음 |  | 1 (D00-2-029) |
| WK-SSP0060-0173 | X-REASON | D00-2b-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2b-005 MSG00047 dr null 가드  React Query 미도착 = 빈 그리드, null 역참조 경로 없음 해당없음 |  | 1 (D00-2b-005) |
| WK-SSP0060-0174 | X-REASON | D00-2b-029~030 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2b-029~030 HoldStock 저장 반환 2종 handleSave holdStock 안내 alert HoldStock 저장 SP 미존재(TO-BE/AS-IS 실측) — convert-s |  | 1 (D00-2b-029~030) |
| WK-SSP0060-0175 | X-REASON | D00-2b-031~033 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2b-031~033 MSG00219/267/194 ERP 차단·정합  [SP-CHAIN] 제외 |  | 1 (D00-2b-031~033) |
| WK-SSP0060-0176 | X-REASON | D00-2b-036~057 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2b-036~057 ERP Drafting 체인 메시지 22종(MSG00247/049/404/197/204/324/284/248/249/189/306 등)  [SP-CHAIN] NonSoNo/ |  | 1 (D00-2b-036~057) |
| WK-SSP0060-0177 | X-REASON | D00-2b-058 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2b-058 MSG00313 PlanDate 최신 불일치  콤보 캐시(staleTime 0)와 서버 재대조 배선 보류 — 04 확인필요(MSG01315 예약) 제외 |  | 1 (D00-2b-058) |
| WK-SSP0060-0178 | X-REASON | D00-3-005~007 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-005~007 Footer Sum/포맷/배경색  Footer 합계는 AS-IS Detail 전용 표시 — 공용 DataGrid 미배선, 04 확인필요 제외 |  | 1 (D00-3-005~007) |
| WK-SSP0060-0179 | X-REASON | D00-3-018 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-018 헤더 체크박스 전체선택 토글  대상 컬럼(CHECK_NEED_YN 추정) 메타 미배선 — 04 확인필요 제외 |  | 1 (D00-3-018) |
| WK-SSP0060-0180 | X-REASON | D00-3-021 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-021 SmartColMerge 재적용 공용 병합 매니저 자동 공용 DataGrid 병합 매니저가 자동 재적용 — 화면 코드 불요 해당없음 |  | 1 (D00-3-021) |
| WK-SSP0060-0181 | X-REASON | D00-3-024 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-024 저장 실패 셀 InvalidColor  Main 저장 음수는 저장 전 차단(MSG00225)이라 실패색 경로 미발생 — 셀 단위 표기는 04 확인필요 제외 |  | 1 (D00-3-024) |
| WK-SSP0060-0182 | X-REASON | D00-3-025 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-025 GetViewRowFromModelRow  Wijmo collectionView 인덱스 공용 처리 해당없음 |  | 1 (D00-3-025) |
| WK-SSP0060-0183 | X-REASON | D00-3-030 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-030 조회 후 액티브셀 지정  UX 배관 — Wijmo 기본 포커스 해당없음 |  | 1 (D00-3-030) |
| WK-SSP0060-0184 | X-REASON | D00-3-032 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-032 StickyNote 셀 메모 유지  AS-IS EDIT_YN 노트 표시 — TO-BE wide 커서에 EDIT_YN 부재(실측), 04 확인필요 제외 |  | 1 (D00-3-032) |
| WK-SSP0060-0185 | X-REASON | D00-4-004 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4-004 SSP0060_SAVE_HOLD_STOCK_DATA handleSave holdStock 안내 SP 미존재(TO-BE/AS-IS 실측) — convert-sp 후속. API/BTN  |  | 1 (D00-4-004) |
| WK-SSP0060-0186 | X-REASON | D00-4-005~016 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4-005~016 ERP Drafting 하위 SP 12종(§4 #5~16)  [SP-CHAIN] 제외 |  | 1 (D00-4-005~016) |
| WK-SSP0060-0187 | X-REASON | D00-4-029 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4-029 SCM_SSP_CHECK_CONFIRM_CHANGETIME  [SP-CHAIN] 동시편집 검증 — Confirm 저장 SP 내부 처리 여부 convert-sp 확인 제외 |  | 1 (D00-4-029) |
| WK-SSP0060-0188 | X-REASON | D00-4b-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-005 SSPBlockCheckIF  [SP-CHAIN] ERP 차단 플래그 — Drafting 경로 전용 제외 |  | 1 (D00-4b-005) |
| WK-SSP0060-0189 | X-REASON | D00-4b-006 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-006 Plan_Infor(검증용 Tmp)  MSG00313 대조 경로 보류(D00-2b-058) 제외 |  | 1 (D00-4b-006) |
| WK-SSP0060-0190 | X-REASON | D00-4b-008 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-008 ShipmentPlanToSite  Detail TO_SITE 셀콤보용 — 컬럼 메타 배선 축(PARAM 등재)은 [META-GAP] 계열, 04 확인필요 제외 |  | 1 (D00-4b-008) |
| WK-SSP0060-0191 | X-REASON | D00-4b-012 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-012 EndCustomerByItemForSSP  [META-GAP] 콤보 SQL `EndCustomerByItemForSSP_SCP` 는 등록됨 — 컬럼메타 CTRL/CMBO/A2 미 |  | 1 (D00-4b-012) |
| WK-SSP0060-0192 | X-REASON | I07 Plan Date Packer | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I07 Plan Date Packer 해당없음 `PlanDateShip` 0 hit / `Packer` 0 hit |  | 1 (I07 Plan Date Packer) |
| WK-SSP0060-0193 | X-REASON | I08 GetDayRange offset31 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I08 GetDayRange offset31 해당없음 SSP0060 에 `GetDayRange("A"/"P")` 부재. drpPeriod/2 는 ControlClear L557~560 **공백**,  |  | 1 (I08 GetDayRange offset31) |
| WK-SSP0060-0194 | X-REASON | I10 PACKER_PAST | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I10 PACKER_PAST 해당없음 `Packer` 0 / `_PAST` 0 hit |  | 1 (I10 PACKER_PAST) |
| WK-SSP0060-0195 | X-REASON | I13 Comments(sticky) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I13 Comments(sticky) 해당없음 `CommentsPopup` 0 hit |  | 1 (I13 Comments(sticky)) |
| WK-SSP0060-0196 | X-REASON | I14 PROD_DATE/LOT 셀타입 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I14 PROD_DATE/LOT 셀타입 해당없음 `SetCellTypeDateToText` 0 hit |  | 1 (I14 PROD_DATE/LOT 셀타입) |
| WK-SSP0060-0197 | X-REASON | I15 USER_MOD Blue | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I15 USER_MOD Blue 해당없음 `USER_MOD` 0 hit |  | 1 (I15 USER_MOD Blue) |
| WK-SSP0060-0198 | X-REASON | I17 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I17 EDIT_YN 셀 노트(StickyNote) 미배선 — wide 커서에 EDIT_YN 부재(실측) SP 확장(convert-sp) 또는 미이관 확정 — SP/사용자 축 제외 |  | 1 (I17) |
| WK-SSP0060-0199 | X-REASON | I18 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I18 HoldStock 탭 상시 노출 정책 상시 노출 재현 AS-IS 런타임 거동 확인 필요 — 사용자 축 제외 |  | 1 (I18) |
| WK-SSP0060-0200 | X-REASON | I19 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I19 토/일 DAY_CODE 실값 변경 없음 PROC_M 등재(convert-sp) 후 call-proc 실행값 확인 — SP 축 제외 |  | 1 (I19) |
| WK-SSP0060-0201 | X-REASON | I20 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I20 BtnItemID2_Click plantSite 전달(.cs L1031~1045) 공용 ItemByDivisionModal 계약(preSearchParams 에 plantSite 없음 — CO |  | 1 (I20) |
| WK-SSP0060-0202 | X-REASON | I21 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I21 Confirm payload 키 ↔ PROC_M COL_NM 정합 변경 없음 convert-sp PROC_M 등재 시 확정 — SP 축 제외 |  | 1 (I21) |
| WK-SSP0060-0203 | X-REASON | I7 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — I7 Form_Load FindString(sUserCompany_NM)(.cs L329~334) — 원천 SSP InnerTable MyCompanyID 첫 행 선택만 재현 TO-BE 세션(User |  | 1 (I7) |
| WK-SSP0060-0204 | X-REASON | Production 파란 노트 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — Production 파란 노트 해당없음 `SetProdNote` 0 hit |  | 1 (Production 파란 노트) |
| WK-SSP0060-0205 | X-REASON | Production(PROD_PLAN)·PROD_DATE 표시 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — Production(PROD_PLAN)·PROD_DATE 표시 해당없음 SSP0060 의 PROD_PLAN(L6925·7858·7914)·PROD_DATE(L6726)는 **주/월 합계 계산 규칙** |  | 1 (Production(PROD_PLAN)·PROD_DATE 표시) |
| WK-SSP0060-0206 | X-REASON | WH In Plan Detail 검색조건 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — WH In Plan Detail 검색조건 해당없음 해당 시트 자체가 없다(CreateSpread 6시트) |  | 1 (WH In Plan Detail 검색조건) |
| WK-SSP0060-0207 | X-REASON | WH_IN 기간셀 → Comments 팝업 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — WH_IN 기간셀 → Comments 팝업 해당없음 `WH_IN` 0 hit · `CommentsPopup` 0 hit |  | 1 (WH_IN 기간셀 → Comments 팝업) |
| WK-SSP0060-0208 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 '데이터 수정 중 다른 데이터 조회 시 confirm(MSG00704)' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소 |  | 1 (COMMON:UC-02) |
| WK-SSP0060-0209 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼/Measure 설정 적용 시 기존 데이터 Reset 후 재조회' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: |  | 1 (COMMON:UC-03) |
| WK-SSP0060-0210 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 콤마 다중 입력 전건 조회' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP006 |  | 1 (COMMON:UC-06) |
| WK-SSP0060-0211 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 필터 유지(rebindFilterColumns)' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL |  | 1 (COMMON:UC-07) |
| WK-SSP0060-0212 | A1 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:SEARCH: 행 집계 — 대조표 CRUD:SEARCH 'FindData_Main + Detail 8-sheet 조회' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_S |  | 1 (CRUD:SEARCH) |
| WK-SSP0060-0213 | A1 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-003: 행 집계 — 대조표 D00-1-003 'btnItemID2 (2차 Model 팝업)' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0 |  | 1 (D00-1-003) |
| WK-SSP0060-0214 | A1 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-004: 행 집계 — 대조표 D00-1-004 'btnItemId (1차 Model 팝업)' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP00 |  | 1 (D00-1-004) |
| WK-SSP0060-0215 | A1 | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-007: 행 집계 — 대조표 D00-1-007 'btnRequestor' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_SHIP |  | 1 (D00-1-007) |
| WK-SSP0060-0216 | A1 | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-008: 행 집계 — 대조표 D00-1-008 'btnSearch (Detail 재조회)' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP006 |  | 1 (D00-1-008) |
| WK-SSP0060-0217 | A1 | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-004: 행 집계 — 대조표 D00-2-004 'BtnNew_Click' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_SHIP |  | 1 (D00-2-004) |
| WK-SSP0060-0218 | A1 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-006: 행 집계 — 대조표 D00-2-006 'BtnSearch_Click' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_S |  | 1 (D00-2-006) |
| WK-SSP0060-0219 | A1 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-011: 행 집계 — 대조표 D00-2-011 'chkTotPSI_CheckedChanged' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0 |  | 1 (D00-2-011) |
| WK-SSP0060-0220 | A1 | D00-2-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-012: 행 집계 — 대조표 D00-2-012 'clbCompanyID_SelectedIndexChanged' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP00 |  | 1 (D00-2-012) |
| WK-SSP0060-0221 | A1 | D00-2-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-020: 행 집계 — 대조표 D00-2-020 'SpdDetail_ComboSelChange' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0 |  | 1 (D00-2-020) |
| WK-SSP0060-0222 | A1 | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-014: 행 집계 — 대조표 D00-3-014 '저장 후 강조색 리셋' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_SHIP  |  | 1 (D00-3-014) |
| WK-SSP0060-0223 | A1 | D00-3-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-028: 행 집계 — 대조표 D00-3-028 'Query/LockColumn 조회 바인딩 9건' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SS |  | 1 (D00-3-028) |
| WK-SSP0060-0224 | A1 | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-029: 행 집계 — 대조표 D00-3-029 '조회 후 재병합·주석리셋·0치환' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET |  | 1 (D00-3-029) |
| WK-SSP0060-0225 | A1 | D00-4a-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-002: 행 집계 — 대조표 D00-4a-002 'FindButton' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_SHIP |  | 1 (D00-4a-002) |
| WK-SSP0060-0226 | A1 | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-003: 행 집계 — 대조표 D00-4a-003 'SaveButton' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_SHIP |  | 1 (D00-4a-003) |
| WK-SSP0060-0227 | A1 | D00-4a-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-004: 행 집계 — 대조표 D00-4a-004 'DeleteButton (NO-OP 확정)' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP |  | 1 (D00-4a-004) |
| WK-SSP0060-0228 | A1 | D00-4a-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-005: 행 집계 — 대조표 D00-4a-005 'InsertButton' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_SH |  | 1 (D00-4a-005) |
| WK-SSP0060-0229 | A1 | D00-4a-006~036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-006~036: 행 집계 — 대조표 D00-4a-006~036 'event 29종' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0060_G |  | 1 (D00-4a-006~036) |
| WK-SSP0060-0230 | A1 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4e-001: 행 집계 — 대조표 D00-4e-001 'ItembyDivision(조회조건 2차)' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP |  | 1 (D00-4e-001) |
| WK-SSP0060-0231 | A1 | D00-4e-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4e-008: 행 집계 — 대조표 D00-4e-008 'ItembyDivision(조회조건 1차)' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP |  | 1 (D00-4e-008) |
| WK-SSP0060-0232 | A1 | DM0003_GET_BUCKET_TYPE_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DM0003_GET_BUCKET_TYPE_CODE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0060/DM0003_GET_BUCKET_TYPE_CODE.md — 파라 |  | 1 (D00-4-017) |
| WK-SSP0060-0233 | A1 | I10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — I10: 행 집계 — 대조표 I10 'SpdMain_CellDoubleClick(.cs L2320~2381): MES=Detai' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_ |  | 1 (I10) |
| WK-SSP0060-0234 | A1 | I19 MSG 문구 역조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — I19 MSG 문구 역조회: 행 집계 — 대조표 I19 MSG 문구 역조회 '부분 적용' 의 A1 16요소: REVIEW:15 · PASS:1 · FAIL 요소: PKG_SSP0060.P_SSP0060_GET_S |  | 1 (I19 MSG 문구 역조회) |
| WK-SSP0060-0235 | A1 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0060/SSP0002_GET_USER_INFO_ |  | 1 (D00-4-030) |
| WK-SSP0060-0236 | A1 | PKG_SSP0020.P_USER_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0020.P_USER_CHECK: 골든 비교 케이스 없음(PKG_SSP0020.P_USER_CHECK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 2 (D00-4-030 D00-4a-001) |
| WK-SSP0060-0237 | A1 | PKG_SSP0060.P_SSP0060_GET_HOLD_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_HOLD_STOCK: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0060/SSP0060_GET_HOLD_STOCK.md  |  | 59 (D00-4-024 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0238 | A1 | PKG_SSP0060.P_SSP0060_GET_MES_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_MES_STOCK: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0060/SSP0060_GET_MES_STOCK.md —  |  | 61 (D00-4-025 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0239 | A1 | PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETAIL: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0060/SSP0060_GET_MES_STOC |  | 65 (D00-4-026 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0240 | A1 | PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0060/SSP0060_GET_OWMS_DETAIL.m |  | 61 (D00-4-021 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0241 | A1 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_DIVIS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_DIVISION: golden DIFF AS-IS 0행 ↔ TO-BE 3행: Doc/golden/SSP0060/SSP0060_GET_SHIPMENT_ |  | 1 (D00-4-001) |
| WK-SSP0060-0242 | A1 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN: golden DIFF AS-IS 55행 ↔ TO-BE 49행: Doc/golden/SSP0060/SSP0060_GET_SHIPMENT_PL |  | 72 (D00-4-018 ACT:SSP0060_ShipmentPlan.FindB) |
| WK-SSP0060-0243 | A1 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_DETAIL: golden DIFF AS-IS 0행 ↔ TO-BE 0행: Doc/golden/SSP0060/SSP0060_GET_SHIPME |  | 97 (D00-4-019 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0244 | A1 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM: 골든 비교 케이스 없음(PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DR |  | 50 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0245 | A1 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESUL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESULT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0060/SSP0060_GET_SHIPMENT_ |  | 132 (D00-4-022~023 ACT:SSP0060_ShipmentPlan.F) |
| WK-SSP0060-0246 | A1 | PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION_DETAIL: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SSP0060/SSP0060_GET_STO |  | 61 (D00-4-020 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0247 | A1 | P_SSP0060_GET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0060_GET_CALENDAR: 골든 비교 케이스 없음(P_SSP0060_GET_CALENDAR — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D00-4-028) |
| WK-SSP0060-0248 | A1 | P_SSP0300_GET_ORDER_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0300_GET_ORDER_DETAIL: 골든 비교 케이스 없음(P_SSP0300_GET_ORDER_DETAIL — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 1 (D00-4e-004) |
| WK-SSP0060-0249 | A6 | PKG_SSP0020.P_USER_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_SSP0020.P_USER_CHECK: 검증 엔진이 실행됐으나 이 대상(SP PKG_SSP0020.P_USER_CHECK)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER |  | 2 (D00-4-030 D00-4a-001) |
| WK-SSP0060-0250 | A6 | P_SSP0060_GET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_SSP0060_GET_CALENDAR: 검증 엔진이 실행됐으나 이 대상(SP P_SSP0060_GET_CALENDAR)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY  |  | 1 (D00-4-028) |
| WK-SSP0060-0251 | A6 | P_SSP0300_GET_ORDER_DETAIL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_SSP0300_GET_ORDER_DETAIL: 검증 엔진이 실행됐으나 이 대상(SP P_SSP0300_GET_ORDER_DETAIL)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL O |  | 1 (D00-4e-004) |
| WK-SSP0060-0252 | X-LOC | AS-IS `LGCE_SCMDEV`(asis.py) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS `LGCE_SCMDEV`(asis.py): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS `LGCE_SCMDEV`(asis.py)) |
| WK-SSP0060-0253 | X-LOC | I02 ERP IF 연쇄 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I02 ERP IF 연쇄: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I02 ERP IF 연쇄) |
| WK-SSP0060-0254 | X-LOC | I04 TransMode EE 치환 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I04 TransMode EE 치환: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I04 TransMode EE 치환) |
| WK-SSP0060-0255 | X-LOC | I04 저장 payload 오염 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I04 저장 payload 오염: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I04 저장 payload 오염) |
| WK-SSP0060-0256 | X-LOC | I06 R7a GetSSPUserCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I06 R7a GetSSPUserCheck: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I06 R7a GetSSPUserCheck) |
| WK-SSP0060-0257 | X-LOC | I1-delete | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I1-delete: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I1-delete) |
| WK-SSP0060-0258 | X-LOC | I1-paste | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I1-paste: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I1-paste) |
| WK-SSP0060-0259 | X-LOC | I10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I10) |
| WK-SSP0060-0260 | X-LOC | I12 Requestor 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I12 Requestor 팝업: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I12 Requestor 팝업) |
| WK-SSP0060-0261 | X-LOC | I13 SSP0300 OrderDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I13 SSP0300 OrderDetail: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I13 SSP0300 OrderDetail) |
| WK-SSP0060-0262 | X-LOC | I14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I14: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I14) |
| WK-SSP0060-0263 | X-LOC | I15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I15: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I15) |
| WK-SSP0060-0264 | X-LOC | I15 음수 InvalidColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I15 음수 InvalidColor: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I15 음수 InvalidColor) |
| WK-SSP0060-0265 | X-LOC | I16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I16: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I16) |
| WK-SSP0060-0266 | X-LOC | I16 Measure 시트변형 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I16 Measure 시트변형: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I16 Measure 시트변형) |
| WK-SSP0060-0267 | X-LOC | I19 MSG 문구 역조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I19 MSG 문구 역조회: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I19 MSG 문구 역조회) |
| WK-SSP0060-0268 | X-LOC | I2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I2) |
| WK-SSP0060-0269 | X-LOC | I22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I22: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I22) |
| WK-SSP0060-0270 | X-LOC | I3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I3) |
| WK-SSP0060-0271 | X-LOC | I4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I4) |
| WK-SSP0060-0272 | X-LOC | I5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I5) |
| WK-SSP0060-0273 | X-LOC | I6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I6) |
| WK-SSP0060-0274 | X-LOC | I8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I8) |
| WK-SSP0060-0275 | X-LOC | I9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — I9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (I9) |
| WK-SSP0060-0276 | X-LOC | Model(ITEM_ID) 그룹 경계 검정 실선 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Model(ITEM_ID) 그룹 경계 검정 실선: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Model(ITEM_ID) 그룹 경계 검정 실선) |
| WK-SSP0060-0277 | X-LOC | NEW-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — NEW-1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (NEW-1) |
| WK-SSP0060-0278 | X-LOC | TO-BE `ZIOUI1`(ora.py) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — TO-BE `ZIOUI1`(ora.py): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (TO-BE `ZIOUI1`(ora.py)) |
| WK-SSP0060-0279 | X-LOC | type-check / lint / vitest | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — type-check / lint / vitest: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (type-check / lint / vitest) |
| WK-SSP0060-0280 | X-LOC | 메타 SQL 3종(18/19/20) 적용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 메타 SQL 3종(18/19/20) 적용: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (메타 SQL 3종(18/19/20) 적용) |
| WK-SSP0060-0281 | X-LOC | 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·EE행 TransMo: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E) |
| WK-SSP0060-0282 | X-LOC | 음수 = 빨간 글자 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 음수 = 빨간 글자: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (음수 = 빨간 글자) |
| WK-SSP0060-0283 | X-LOC | 편집 가능 일자(노랑) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 편집 가능 일자(노랑): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (편집 가능 일자(노랑)) |
| WK-SSP0060-0284 | X-LOC | 편집 불가(하늘색 Rc) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 편집 불가(하늘색 Rc): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (편집 불가(하늘색 Rc)) |
| WK-SSP0060-0285 | X-LOC | 확정구간 스타일 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 확정구간 스타일: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (확정구간 스타일) |
| WK-SSP0060-0286 | X-ROW | SSP0060_ShipmentPlan.CalcPlanQty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.CalcPlanQty: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/FLOW/GRID_SET/LOCAL/ |  | 163 (ACT:SSP0060_ShipmentPlan.CalcPlanQty ACT) |
| WK-SSP0060-0287 | X-ROW | SSP0060_ShipmentPlan.CalculateSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.CalculateSum: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/FLOW/LOCAL, 연결된 요소  |  | 104 (ACT:SSP0060_ShipmentPlan.CalculateSum AC) |
| WK-SSP0060-0288 | X-ROW | SSP0060_ShipmentPlan.Convert_Requestor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.Convert_Requestor: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 12 (ACT:SSP0060_ShipmentPlan.Convert_Request) |
| WK-SSP0060-0289 | X-ROW | SSP0060_ShipmentPlan.Measure_SearchIdx | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.Measure_SearchIdx: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 17 (ACT:SSP0060_ShipmentPlan.Measure_SearchI) |
| WK-SSP0060-0290 | X-ROW | SSP0060_ShipmentPlan.ShipmentResult_GetD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.ShipmentResult_GetDayRange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:SSP0060_ShipmentPlan.ShipmentResult_) |
| WK-SSP0060-0291 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_SheetTabC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdDetail_SheetTabClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/GRID_INIT, 연결된 요소 검사  |  | 15 (ACT:SSP0060_ShipmentPlan.SpdDetail_Sheet) |
| WK-SSP0060-0292 | X-ROW | SSP0060_ShipmentPlan.SpdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0060_ShipmentPlan.SpdMain_Change: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:SSP0060_ShipmentPlan.SpdMain_Change ) |
| WK-SSP0060-0293 | M4 | SSP0060_ShipmentPlanRequestPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0060_ShipmentPlanRequestPopup: 검증 엔진이 실행됐으나 이 대상(POPUP SSP0060_ShipmentPlanRequestPop)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 |  | 2 (MODAL:ShipmentRequestModal ACT:SSP0060_S) |
| WK-SSP0060-0294 | M4 | btnId | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnId: 실측[T-1acda743]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] PROJECT_CODE 트리거 그리드 0행(다른 그리드 첫 행 |  | 1 (D00-4e-004) |
| WK-SSP0060-0295 | M4 | btnItemID2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnItemID2: 검증 엔진이 실행됐으나 이 대상(BTN btnItemID2)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (D00-1-003) |
| WK-SSP0060-0296 | M4 | btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnItemId: 실측[T-00acb700]: [증거 부족: 기대원천 GENERAL = FAIL 불가 순위(expected_source_rank.csv)] PROJECT_CODE 트리거 그리드 0행(다른 그리드 |  | 1 (D00-1-004) |

## W9 도구 오류 (705)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0060-0297 | C1 | cboBucketType / Bucket / Bucket Type | 하네스·환경 | C1 도구 오류 — 실측[T-44343677]: 'Bucket' → 'Weekly' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 cboBucketType_SelectedIndexChanged · AS-IS 하위  |  | 1 (ACT:SSP0060_ShipmentPlan.InitControls:46) |
| WK-SSP0060-0298 | C2 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C2 도구 오류 — 실측[T-ab7c69dc]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 26 (D00-4d-007~009 ACT:SSP0060_ShipmentPlan.) |
| WK-SSP0060-0299 | C2 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C2 도구 오류 — 실측[T-4de039d3]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 7 (D00-2-021 D00-2b-004 ACT:SSP0060_Shipmen) |
| WK-SSP0060-0300 | C2 | D00-2-020 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-2-020 'SpdDetail_ComboSelChange' 의 C2 17요소: ERROR:17 |  | 1 (D00-2-020) |
| WK-SSP0060-0301 | C2 | D00-2-025 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-2-025 'SpdMain_Change' 의 C2 17요소: ERROR:17 |  | 1 (D00-2-025) |
| WK-SSP0060-0302 | C2 | D00-3-011 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-3-011 'CHANGE_REASON 코드/상세 연동' 의 C2 17요소: ERROR:17 |  | 1 (D00-3-011) |
| WK-SSP0060-0303 | C2 | D00-3-019 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-3-019 'Main 수량 편집 반영+초과 Red' 의 C2 17요소: ERROR:17 |  | 1 (D00-3-019) |
| WK-SSP0060-0304 | C2 | D00-4d-001~002 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 D00-4d-001~002 'shtDetail_Change 진입가드(Row/Col -1, RowCount 0)' 의 C2 17요소: ERROR:17 |  | 1 (D00-4d-001~002) |
| WK-SSP0060-0305 | C2 | DIVISION_ID | 하네스·환경 | C2 도구 오류 — 원장 V-0a7cdabb |  | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0306 | C2 | DIVISION_ID / Div | 하네스·환경 | C2 도구 오류 — 원장 V-0a7cdabb ASIS / 실측[T-61bf440a]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail  |  | 2 (ACT:SSP0060_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0060-0307 | C2 | EDIT_MAIN | 하네스·환경 | C2 도구 오류 — 실측[T-7cc315ce]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 10 (D00-2-015 D00-3-009 ACT:SSP0060_Shipment) |
| WK-SSP0060-0308 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-7bbb583b |  | 1 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-0309 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-4709f850 |  | 1 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-0310 | C2 | ERP_SO_NO / SO No | 하네스·환경 | C2 도구 오류 — 실측[T-e2cf0293]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0311 | C2 | ETA | 하네스·환경 | C2 도구 오류 — 실측[T-b05f4fc6]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (D00-3-013) |
| WK-SSP0060-0312 | C2 | ETD | 하네스·환경 | C2 도구 오류 — 실측[T-98733b1f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (D00-3-013) |
| WK-SSP0060-0313 | C2 | FCST_TYPE / FCST Type | 하네스·환경 | C2 도구 오류 — 실측[T-f286715f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0060_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0060-0314 | C2 | FROM_SITE_DESCRIPTION | 하네스·환경 | C2 도구 오류 — 원장 V-4ec2effd |  | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0315 | C2 | NEW_ROUTE_ID / Route | 하네스·환경 | C2 도구 오류 — 실측[T-49df8a2b]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0316 | C2 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | C2 도구 오류 — 실측[T-1dafa58b]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (D00-3-013) |
| WK-SSP0060-0317 | C2 | SSP0060_ShipmentPlan.DrpPeriod2_ValueCha | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.DrpPeriod2_ValueChanged 의 C2 17요소: ERROR:17 |  | 4 (ACT:SSP0060_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0060-0318 | C2 | SSP0060_ShipmentPlan.SpdDetail_ActiveShe | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SpdDetail_ActiveSheetChanged 의 C2 17요소: ERROR:17 |  | 6 (ACT:SSP0060_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0060-0319 | C2 | SSP0060_ShipmentPlan.cboBucketType_Selec | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.cboBucketType_SelectedIndexChanged 의 C2 17요소: ERROR:17 |  | 1 (ACT:SSP0060_ShipmentPlan.cboBucketType_S) |
| WK-SSP0060-0320 | C2 | SSP0060_ShipmentPlan.cboPlanDate_Selecte | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.cboPlanDate_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 18 (ACT:SSP0060_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0060-0321 | C2 | SSP0060_ShipmentPlan.chkSum_CheckedChang | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.chkSum_CheckedChanged 의 C2 17요소: ERROR:17 |  | 1 (ACT:SSP0060_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0060-0322 | C2 | SSP0060_ShipmentPlan.chkTotPSI_CheckedCh | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.chkTotPSI_CheckedChanged 의 C2 17요소: ERROR:17 |  | 1 (ACT:SSP0060_ShipmentPlan.chkTotPSI_Check) |
| WK-SSP0060-0323 | C2 | SSP0060_ShipmentPlan.clbCompanyID_Select | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.clbCompanyID_SelectedIndexChanged 의 C2 17요소: ERROR:17 |  | 18 (ACT:SSP0060_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0060-0324 | C2 | SSP0060_ShipmentPlan.clbDivision_ID_Sele | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.clbDivision_ID_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 15 (ACT:SSP0060_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0060-0325 | C2 | TO_SITE_DESCRIPTION | 하네스·환경 | C2 도구 오류 — 원장 V-1c7107de |  | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0326 | C2 | TRANSPORT_MODE | 하네스·환경 | C2 도구 오류 — 원장 V-9a18991f |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0327 | C2 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C2 도구 오류 — 원장 V-9a18991f ASIS / 실측[T-dae9ab9d]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail  |  | 36 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0328 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-c2e14e49 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0329 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-474fe6d3 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0330 | C3 | CHANGE_REASON_CODE | 하네스·환경 | C3 도구 오류 — 원장 V-8fd1e90c |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0331 | C3 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C3 도구 오류 — 원장 V-c2e14e49 ASIS / 원장 V-5bd0b723 ASIS / 원장 V-f7cabf03 ASIS / 원장 V-474fe6d3 ASIS / 원장 V-29d7b3e2 ASIS / 원장 V-8fd1e90c  |  | 37 (D00-4d-007~009 ACT:SSP0060_ShipmentPlan.) |
| WK-SSP0060-0332 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-b2c21d8d |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0333 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-5b43354e |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0334 | C3 | CHANGE_REASON_DETAIL | 하네스·환경 | C3 도구 오류 — 원장 V-369a271a |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0335 | C3 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C3 도구 오류 — 원장 V-b2c21d8d ASIS / 원장 V-5b43354e ASIS / 원장 V-7ce71094 ASIS / 원장 V-369a271a ASIS / 원장 V-e0a8eec9 ASIS / 실측[T-0c0a9759] |  | 18 (D00-2-021 D00-2b-004 ACT:SSP0060_Shipmen) |
| WK-SSP0060-0336 | C3 | CHANGE_REQ_NO / Change Request No | 하네스·환경 | C3 도구 오류 — 실측[T-b0b82957]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 6 (ACT:SSP0060_ShipmentPlan.InitSpread:671:) |
| WK-SSP0060-0337 | C3 | D00-2-020 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-020 'SpdDetail_ComboSelChange' 의 C3 66요소: ERROR:66 |  | 1 (D00-2-020) |
| WK-SSP0060-0338 | C3 | D00-2-025 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-2-025 'SpdMain_Change' 의 C3 66요소: ERROR:66 |  | 1 (D00-2-025) |
| WK-SSP0060-0339 | C3 | D00-3-011 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-3-011 'CHANGE_REASON 코드/상세 연동' 의 C3 66요소: ERROR:66 |  | 1 (D00-3-011) |
| WK-SSP0060-0340 | C3 | D00-3-019 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-3-019 'Main 수량 편집 반영+초과 Red' 의 C3 66요소: ERROR:66 |  | 1 (D00-3-019) |
| WK-SSP0060-0341 | C3 | D00-4d-001~002 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-4d-001~002 'shtDetail_Change 진입가드(Row/Col -1, RowCount 0)' 의 C3 66요소: ERROR:66 |  | 1 (D00-4d-001~002) |
| WK-SSP0060-0342 | C3 | DIFF_QTY | 하네스·환경 | C3 도구 오류 — 실측[T-ef1e8240]: 팝업 내부 그리드 컬럼 DIFF_QTY — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Cal) |
| WK-SSP0060-0343 | C3 | DIVISION_ID / Div | 하네스·환경 | C3 도구 오류 — 실측[T-2eb66e22]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 10 (ACT:SSP0060_ShipmentPlan.InsertRow:2546:) |
| WK-SSP0060-0344 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-f2bbe031 ASIS / 원장 V-492cb7fd ASIS / 원장 V-7de6fc17 ASIS / 원장 V-bc0d2d3b ASIS / 원장 V-24720d48 ASIS / 원장 V-8359e684  |  | 35 (D00-2-015 D00-3-009 ACT:SSP0060_Shipment) |
| WK-SSP0060-0345 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-f2bbe031 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0346 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-492cb7fd |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0347 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-7de6fc17 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0348 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-bc0d2d3b |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0349 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-24720d48 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0350 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-8359e684 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0351 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-7c13fd37 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0352 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-de1c9f6a |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0353 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-3a3b0369 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0354 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-b65f776a |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0355 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-c461c862 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0356 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-806d6721 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0357 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-5bd0b723 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0358 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-f7cabf03 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0359 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-29d7b3e2 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0360 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-4bdeaf83 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0361 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-458da956 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0362 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-433b02d1 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0363 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-7ce71094 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0364 | C3 | EDIT_MAIN | 하네스·환경 | C3 도구 오류 — 원장 V-e0a8eec9 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0365 | C3 | END_CUSTOMER / End Customer | 하네스·환경 | C3 도구 오류 — 실측[T-38749fad]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 6 (ACT:SSP0060_ShipmentPlan.SetEndCustomer ) |
| WK-SSP0060-0366 | C3 | ERP_SO_NO / SO No | 하네스·환경 | C3 도구 오류 — 실측[T-59ad6b6a]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 24 (ACT:SSP0060_ShipmentPlan.InitSpread:666:) |
| WK-SSP0060-0367 | C3 | ETA | 하네스·환경 | C3 도구 오류 — 실측[T-80c205a9]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (D00-3-013) |
| WK-SSP0060-0368 | C3 | ETD | 하네스·환경 | C3 도구 오류 — 실측[T-23db106f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (D00-3-013) |
| WK-SSP0060-0369 | C3 | FCST_TYPE / FCST Type | 하네스·환경 | C3 도구 오류 — 실측[T-5982f602]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 8 (ACT:SSP0060_ShipmentPlan.InitSpread:656:) |
| WK-SSP0060-0370 | C3 | FROM_SITE / From Site | 하네스·환경 | C3 도구 오류 — 실측[T-d38e3c44]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0060_ShipmentPlan.InsertRow:2547:) |
| WK-SSP0060-0371 | C3 | FROM_SITE_DESCRIPTION / From Site | 하네스·환경 | C3 도구 오류 — 실측[T-7d933966]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0060_ShipmentPlan.InsertRow:2548:) |
| WK-SSP0060-0372 | C3 | FROM_SITE_NM / From Site | 하네스·환경 | C3 도구 오류 — 실측[T-e24806ee]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0060_ShipmentPlan.InsertRow:2548:) |
| WK-SSP0060-0373 | C3 | HOLD_YYYYMMDD / Start Date | 하네스·환경 | C3 도구 오류 — 실측[T-a88aa960]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0060_ShipmentPlan.InsertRow:2555:) |
| WK-SSP0060-0374 | C3 | I22 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 I22 'SpdDetail_ClipboardPasted 가드 5종(L1395~) — 잠금해제 셀 붙' 의 C3 66요소: ERROR:66 |  | 1 (I22) |
| WK-SSP0060-0375 | C3 | INCOTERMS / Incoterms | 하네스·환경 | C3 도구 오류 — 실측[T-b00289c7]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 5 (ACT:SSP0060_ShipmentPlan.InitSpread:655:) |
| WK-SSP0060-0376 | C3 | ITEM_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-19e370df]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 11 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0377 | C3 | LOT_YN / Lot_YN | 하네스·환경 | C3 도구 오류 — 실측[T-b6e45051]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0060_ShipmentPlan.Re_Design:5490:) |
| WK-SSP0060-0378 | C3 | MEASURE / Measure | 하네스·환경 | C3 도구 오류 — 실측[T-2274e4af]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 8 (ACT:SSP0060_ShipmentPlan.EditByChange:21) |
| WK-SSP0060-0379 | C3 | MEASURE_NAME / Measure | 하네스·환경 | C3 도구 오류 — 실측[T-40b9b1da]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0060_ShipmentPlan.InitSpread:652:) |
| WK-SSP0060-0380 | C3 | NEW_ETD / ETD | 하네스·환경 | C3 도구 오류 — 실측[T-ac12cd5c]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0381 | C3 | NEW_LT_DAY / L/T(Day | 하네스·환경 | C3 도구 오류 — 실측[T-b14e5a0e]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0382 | C3 | NEW_ROUTE_ID / Route | 하네스·환경 | C3 도구 오류 — 실측[T-72bf345e]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0383 | C3 | NEW_SHIPMENT_CONFIRM_QTY | 하네스·환경 | C3 도구 오류 — 실측[T-45a7a258]: 팝업 내부 그리드 컬럼 NEW_SHIPMENT_CONFIRM_QTY — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작 |  | 4 (ACT:SSP0060_ShipmentPlanRequestPopup.spd) |
| WK-SSP0060-0384 | C3 | NEW_SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-28f6c6ab ASIS / 실측[T-4347898b]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail  |  | 3 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0385 | C3 | NEW_SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-28f6c6ab |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0386 | C3 | NICK_NAME / Nick Name | 하네스·환경 | C3 도구 오류 — 실측[T-3b3eaead]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0060_ShipmentPlan.InsertRow:2550:) |
| WK-SSP0060-0387 | C3 | PROJECT_CODE / Project Code | 하네스·환경 | C3 도구 오류 — 실측[T-9fdf62a7]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 3 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0388 | C3 | PROJECT_NAME / Project Name | 하네스·환경 | C3 도구 오류 — 실측[T-22d6d3cf]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0389 | C3 | PSI | 하네스·환경 | C3 도구 오류 — 실측[T-35a58c32]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0060_ShipmentPlan.InitSpread:651:) |
| WK-SSP0060-0390 | C3 | REMARKS / Remarks | 하네스·환경 | C3 도구 오류 — 원장 V-8359e684 ASIS / 원장 V-7c13fd37 ASIS / 원장 V-c2e14e49 ASIS / 원장 V-de1c9f6a ASIS / 원장 V-3a3b0369 ASIS / 원장 V-b2c21d8d  |  | 7 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0391 | C3 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | C3 도구 오류 — 원장 V-24720d48 ASIS / 원장 V-8359e684 ASIS / 원장 V-7c13fd37 ASIS / 원장 V-c2e14e49 ASIS / 원장 V-de1c9f6a ASIS / 원장 V-3a3b0369  |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0392 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-3a4989a9 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0393 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-e7908f13 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0394 | C3 | SHIPMENT_DATE | 하네스·환경 | C3 도구 오류 — 원장 V-2cd7e28e |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0395 | C3 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | C3 도구 오류 — 원장 V-3a4989a9 ASIS / 원장 V-28f6c6ab ASIS / 원장 V-7de6fc17 ASIS / 원장 V-e7908f13 ASIS / 원장 V-bc0d2d3b ASIS / 원장 V-24720d48  |  | 18 (D00-3-013 ACT:SSP0060_ShipmentPlan.SpdDe) |
| WK-SSP0060-0396 | C3 | SSP0060_ShipmentPlan.DrpPeriod2_ValueCha | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.DrpPeriod2_ValueChanged 의 C3 66요소: ERROR:66 |  | 4 (ACT:SSP0060_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0060-0397 | C3 | SSP0060_ShipmentPlan.SetChangeControl | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SetChangeControl 의 C3 66요소: ERROR:66 |  | 12 (ACT:SSP0060_ShipmentPlan.SetChangeContro) |
| WK-SSP0060-0398 | C3 | SSP0060_ShipmentPlan.SetChangedControl | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SetChangedControl 의 C3 1요소: ERROR:1 |  | 11 (ACT:SSP0060_ShipmentPlan.SetChangedContr) |
| WK-SSP0060-0399 | C3 | SSP0060_ShipmentPlan.SetEndCustomer | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SetEndCustomer 의 C3 4요소: ERROR:4 |  | 9 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-0400 | C3 | SSP0060_ShipmentPlan.SetLockSumColumn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SetLockSumColumn 의 C3 66요소: ERROR:66 |  | 3 (ACT:SSP0060_ShipmentPlan.SetLockSumColum) |
| WK-SSP0060-0401 | C3 | SSP0060_ShipmentPlan.SetNote_Display | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SetNote_Display 의 C3 8요소: ERROR:8 |  | 6 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-0402 | C3 | SSP0060_ShipmentPlan.SetSpreadColumn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SetSpreadColumn 의 C3 1요소: ERROR:1 |  | 1 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0403 | C3 | SSP0060_ShipmentPlan.Set_SumValues | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.Set_SumValues 의 C3 66요소: ERROR:66 |  | 25 (ACT:SSP0060_ShipmentPlan.Set_SumValues:5) |
| WK-SSP0060-0404 | C3 | SSP0060_ShipmentPlan.SpdDetail_ActiveShe | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SpdDetail_ActiveSheetChanged 의 C3 66요소: ERROR:66 |  | 6 (ACT:SSP0060_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0060-0405 | C3 | SSP0060_ShipmentPlan.cboBucketType_Selec | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.cboBucketType_SelectedIndexChanged 의 C3 66요소: ERROR:66 |  | 1 (ACT:SSP0060_ShipmentPlan.cboBucketType_S) |
| WK-SSP0060-0406 | C3 | SSP0060_ShipmentPlan.cboPlanDate_Selecte | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.cboPlanDate_SelectedIndexChanged 의 C3 1요소: ERROR:1 |  | 18 (ACT:SSP0060_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0060-0407 | C3 | SSP0060_ShipmentPlan.chkSum_CheckedChang | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.chkSum_CheckedChanged 의 C3 66요소: ERROR:66 |  | 1 (ACT:SSP0060_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0060-0408 | C3 | SSP0060_ShipmentPlan.chkTotPSI_CheckedCh | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.chkTotPSI_CheckedChanged 의 C3 66요소: ERROR:66 |  | 1 (ACT:SSP0060_ShipmentPlan.chkTotPSI_Check) |
| WK-SSP0060-0409 | C3 | SSP0060_ShipmentPlan.clbCompanyID_Select | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.clbCompanyID_SelectedIndexChanged 의 C3 66요소: ERROR:66 |  | 18 (ACT:SSP0060_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0060-0410 | C3 | SSP0060_ShipmentPlan.clbDivision_ID_Sele | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.clbDivision_ID_SelectedIndexChanged 의 C3 1요소: ERROR:1 |  | 15 (ACT:SSP0060_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0060-0411 | C3 | TO_SITE / To Site | 하네스·환경 | C3 도구 오류 — 실측[T-739a023c]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 7 (I1-paste ACT:SSP0060_ShipmentPlan.InitSp) |
| WK-SSP0060-0412 | C3 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | C3 도구 오류 — 실측[T-bed07f14]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0060_ShipmentPlan.SetEndCustomer ) |
| WK-SSP0060-0413 | C3 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C3 도구 오류 — 원장 V-f2bbe031 ASIS / 원장 V-492cb7fd ASIS / 원장 V-3a4989a9 ASIS / 원장 V-28f6c6ab ASIS / 원장 V-7de6fc17 ASIS / 원장 V-e7908f13  |  | 48 (ACT:SSP0060_ShipmentPlan.InitSpread:654:) |
| WK-SSP0060-0414 | C3 | YYYYMMDD / Shipment Date | 하네스·환경 | C3 도구 오류 — 실측[T-fe60f1b4]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-0415 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-e7f6770c |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0416 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-2206cd23 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0417 | C6 | CHANGE_REASON_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-2bac1fa9 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0418 | C6 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | C6 도구 오류 — 원장 V-e7f6770c ASIS / 원장 V-86b04e21 ASIS / 원장 V-f95c5edc ASIS / 원장 V-297444c8 ASIS / 원장 V-2206cd23 ASIS / 원장 V-797076af  |  | 26 (D00-4d-007~009 ACT:SSP0060_ShipmentPlan.) |
| WK-SSP0060-0419 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-590188b4 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0420 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-f95c5edc |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0421 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-797076af |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0422 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-2e084ea6 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0423 | C6 | CHANGE_REASON_DETAIL | 하네스·환경 | C6 도구 오류 — 원장 V-afe3c5bf |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0424 | C6 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | C6 도구 오류 — 원장 V-590188b4 ASIS / 원장 V-f95c5edc ASIS / 원장 V-797076af ASIS / 원장 V-2e084ea6 ASIS / 원장 V-1baacd01 ASIS / 원장 V-afe3c5bf  |  | 7 (D00-2-021 D00-2b-004 ACT:SSP0060_Shipmen) |
| WK-SSP0060-0425 | C6 | D00-2-020 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-2-020 'SpdDetail_ComboSelChange' 의 C6 46요소: ERROR:46 |  | 1 (D00-2-020) |
| WK-SSP0060-0426 | C6 | D00-2-025 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-2-025 'SpdMain_Change' 의 C6 46요소: ERROR:46 |  | 1 (D00-2-025) |
| WK-SSP0060-0427 | C6 | D00-3-011 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-3-011 'CHANGE_REASON 코드/상세 연동' 의 C6 46요소: ERROR:46 |  | 1 (D00-3-011) |
| WK-SSP0060-0428 | C6 | D00-3-019 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-3-019 'Main 수량 편집 반영+초과 Red' 의 C6 46요소: ERROR:46 |  | 1 (D00-3-019) |
| WK-SSP0060-0429 | C6 | D00-4d-001~002 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 D00-4d-001~002 'shtDetail_Change 진입가드(Row/Col -1, RowCount 0)' 의 C6 46요소: ERROR:46 |  | 1 (D00-4d-001~002) |
| WK-SSP0060-0430 | C6 | DIVISION_ID / Div | 하네스·환경 | C6 도구 오류 — 실측[T-bc132196]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0060_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0060-0431 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-d638e104 ASIS / 원장 V-83a2eb46 ASIS / 원장 V-afe9cd04 ASIS / 원장 V-271b0430 ASIS / 원장 V-961fd7c0 ASIS / 원장 V-ba70542f  |  | 10 (D00-2-015 D00-3-009 ACT:SSP0060_Shipment) |
| WK-SSP0060-0432 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-d638e104 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0433 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-83a2eb46 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0434 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-afe9cd04 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0435 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-271b0430 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0436 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-961fd7c0 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0437 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-ba70542f |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0438 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-11c2f1a9 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0439 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-40d1d339 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0440 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-8d843005 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0441 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-53c5b37a |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0442 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-9d1be601 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0443 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-300ac616 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0444 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-86b04e21 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0445 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-297444c8 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0446 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-ad416356 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0447 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-f7e712a6 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0448 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-d17c3abf |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0449 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-5b3f528c |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0450 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-1baacd01 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0451 | C6 | EDIT_MAIN | 하네스·환경 | C6 도구 오류 — 원장 V-04d8792a |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0452 | C6 | ERP_SO_NO / SO No | 하네스·환경 | C6 도구 오류 — 실측[T-a7e42ddc]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 7 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0453 | C6 | ETA | 하네스·환경 | C6 도구 오류 — 실측[T-3ab5c801]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (D00-3-013) |
| WK-SSP0060-0454 | C6 | ETD | 하네스·환경 | C6 도구 오류 — 실측[T-48d4b51d]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (D00-3-013) |
| WK-SSP0060-0455 | C6 | FCST_TYPE / FCST Type | 하네스·환경 | C6 도구 오류 — 실측[T-a04c9e28]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0060_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0060-0456 | C6 | INCOTERMS | 하네스·환경 | C6 도구 오류 — 원장 V-754a2bfc |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0457 | C6 | NEW_ROUTE_ID / Route | 하네스·환경 | C6 도구 오류 — 실측[T-94554f8f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0458 | C6 | NEW_SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-471cbf6a |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0459 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-d6181b00 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0460 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-e9fee3d1 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0461 | C6 | SHIPMENT_DATE | 하네스·환경 | C6 도구 오류 — 원장 V-5f85066a |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0462 | C6 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | C6 도구 오류 — 원장 V-6a3ef07d ASIS / 원장 V-d6181b00 ASIS / 원장 V-471cbf6a ASIS / 원장 V-afe9cd04 ASIS / 원장 V-e9fee3d1 ASIS / 원장 V-271b0430  |  | 1 (D00-3-013) |
| WK-SSP0060-0463 | C6 | SSP0060_ShipmentPlan.DrpPeriod2_ValueCha | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.DrpPeriod2_ValueChanged 의 C6 46요소: ERROR:46 |  | 4 (ACT:SSP0060_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0060-0464 | C6 | SSP0060_ShipmentPlan.SpdDetail_ActiveShe | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SpdDetail_ActiveSheetChanged 의 C6 46요소: ERROR:46 |  | 6 (ACT:SSP0060_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0060-0465 | C6 | SSP0060_ShipmentPlan.cboBucketType_Selec | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.cboBucketType_SelectedIndexChanged 의 C6 46요소: ERROR:46 |  | 1 (ACT:SSP0060_ShipmentPlan.cboBucketType_S) |
| WK-SSP0060-0466 | C6 | SSP0060_ShipmentPlan.cboPlanDate_Selecte | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.cboPlanDate_SelectedIndexChanged 의 C6 1요소: ERROR:1 |  | 18 (ACT:SSP0060_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0060-0467 | C6 | SSP0060_ShipmentPlan.chkSum_CheckedChang | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.chkSum_CheckedChanged 의 C6 46요소: ERROR:46 |  | 1 (ACT:SSP0060_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0060-0468 | C6 | SSP0060_ShipmentPlan.chkTotPSI_CheckedCh | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.chkTotPSI_CheckedChanged 의 C6 46요소: ERROR:46 |  | 1 (ACT:SSP0060_ShipmentPlan.chkTotPSI_Check) |
| WK-SSP0060-0469 | C6 | SSP0060_ShipmentPlan.clbCompanyID_Select | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.clbCompanyID_SelectedIndexChanged 의 C6 46요소: ERROR:46 |  | 18 (ACT:SSP0060_ShipmentPlan.clbCompanyID_Se) |
| WK-SSP0060-0470 | C6 | SSP0060_ShipmentPlan.clbDivision_ID_Sele | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.clbDivision_ID_SelectedIndexChanged 의 C6 1요소: ERROR:1 |  | 15 (ACT:SSP0060_ShipmentPlan.clbDivision_ID_) |
| WK-SSP0060-0471 | C6 | TRANSPORT_MODE | 하네스·환경 | C6 도구 오류 — 원장 V-4e01c0b7 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0472 | C6 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C6 도구 오류 — 원장 V-d638e104 ASIS / 원장 V-83a2eb46 ASIS / 원장 V-6a3ef07d ASIS / 원장 V-d6181b00 ASIS / 원장 V-471cbf6a ASIS / 원장 V-afe9cd04  |  | 36 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0473 | C6 | siDetail.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-6a3ef07d |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0474 | B1 | COMMON:UC-05 | 하네스·환경 | B1 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 콤보 컬럼 Code 아닌 Name 출력' 의 B1 5요소: NOPATH:4 · ERROR:1 |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0475 | B1 | DIVISION_ID / Div | 하네스·환경 | B1 도구 오류 — 원장 V-78ad284c COLUMN / 원장 V-88fd07e7 COLUMN / 원장 V-5cce569c COLUMN |  | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0476 | B2 | COMMON:UC-05 | 하네스·환경 | B2 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 콤보 컬럼 Code 아닌 Name 출력' 의 B2 5요소: NOPATH:4 · ERROR:1 |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0477 | B2 | DIVISION_ID / Div | 하네스·환경 | B2 도구 오류 — 원장 V-648e646d COLUMN / 원장 V-6748b4a0 COLUMN / 원장 V-e6b3cef2 COLUMN |  | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0478 | B3 | DIVISION_ID / Div | 하네스·환경 | B3 도구 오류 — 원장 V-871c65b0 COLUMN / 원장 V-b509f81b COLUMN / 원장 V-641e79da COLUMN |  | 14 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0479 | B3 | FCST_TYPE / FCST Type | 하네스·환경 | B3 도구 오류 — 원장 V-7210c507 COLUMN / 원장 V-7be372f1 COLUMN |  | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0480 | B3 | I8 | 하네스·환경 | B3 도구 오류 — 행 집계 — 대조표 I8 'SpdDetail_SheetTabClick index5: SetItemChecked(0/1' 의 B3 20요소: NA:15 · ERROR:3 · NOPATH:2 |  | 1 (I8) |
| WK-SSP0060-0481 | B3 | INCOTERMS / Incoterms | 하네스·환경 | B3 도구 오류 — 원장 V-d1f079a5 COLUMN |  | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0482 | B3 | SSP0060_ShipmentPlan.GetBucketType | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetBucketType 의 B3 20요소: NA:15 · ERROR:3 · NOPATH:2 |  | 2 (ACT:SSP0060_ShipmentPlan.GetBucketType:5) |
| WK-SSP0060-0483 | B3 | SSP0060_ShipmentPlan.GetERPInterface | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetERPInterface 의 B3 6요소: NA:5 · ERROR:1 |  | 85 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0484 | B3 | SSP0060_ShipmentPlan.GetErpIFCheck | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetErpIFCheck 의 B3 20요소: NA:15 · ERROR:3 · NOPATH:2 |  | 19 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0485 | B3 | SSP0060_ShipmentPlan.GetErpIFCheckNew | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetErpIFCheckNew 의 B3 20요소: NA:15 · ERROR:3 · NOPATH:2 |  | 43 (ACT:SSP0060_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0060-0486 | B3 | SSP0060_ShipmentPlan.GetErpSoNoCnt | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetErpSoNoCnt 의 B3 20요소: NA:15 · ERROR:3 · NOPATH:2 |  | 9 (ACT:SSP0060_ShipmentPlan.GetErpSoNoCnt:4) |
| WK-SSP0060-0487 | B3 | SSP0060_ShipmentPlan.GetFilteredDs | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetFilteredDs 의 B3 9요소: NA:5 · ERROR:3 · NOPATH:1 |  | 6 (ACT:SSP0060_ShipmentPlan.GetFilteredDs:5) |
| WK-SSP0060-0488 | B3 | SSP0060_ShipmentPlan.GetNERPCode | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetNERPCode 의 B3 20요소: NA:15 · ERROR:3 · NOPATH:2 |  | 9 (ACT:SSP0060_ShipmentPlan.GetNERPCode:714) |
| WK-SSP0060-0489 | B3 | SSP0060_ShipmentPlan.GetNewERPInterface | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetNewERPInterface 의 B3 7요소: NA:6 · ERROR:1 |  | 26 (ACT:SSP0060_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0060-0490 | B3 | SSP0060_ShipmentPlan.GetSSPUserCheck | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetSSPUserCheck 의 B3 20요소: NA:15 · ERROR:3 · NOPATH:2 |  | 9 (ACT:SSP0060_ShipmentPlan.GetSSPUserCheck) |
| WK-SSP0060-0491 | B4 | COMMON:UC-05 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 콤보 컬럼 Code 아닌 Name 출력' 의 B4 23요소: NA:15 · NOPATH:5 · ERROR:3 |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0492 | B4 | DIVISION_ID / Div | 하네스·환경 | B4 도구 오류 — 원장 V-b778ab2b COLUMN / 원장 V-592c8f2f COLUMN / 원장 V-df0da97f COLUMN |  | 15 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0493 | B4 | FCST_TYPE / FCST Type | 하네스·환경 | B4 도구 오류 — 원장 V-c734f478 COLUMN / 원장 V-9fc3aff1 COLUMN |  | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0494 | B4 | I8 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 I8 'SpdDetail_SheetTabClick index5: SetItemChecked(0/1' 의 B4 23요소: NA:15 · NOPATH:5 · ERROR:3 |  | 1 (I8) |
| WK-SSP0060-0495 | B4 | INCOTERMS / Incoterms | 하네스·환경 | B4 도구 오류 — 원장 V-e0a89873 COLUMN |  | 2 (ACT:SSP0060_ShipmentPlan.GetFilteredDs A) |
| WK-SSP0060-0496 | B4 | SSP0060_ShipmentPlan.GetBucketType | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetBucketType 의 B4 23요소: NA:15 · NOPATH:5 · ERROR:3 |  | 2 (ACT:SSP0060_ShipmentPlan.GetBucketType:5) |
| WK-SSP0060-0497 | B4 | SSP0060_ShipmentPlan.GetERPInterface | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetERPInterface 의 B4 6요소: NA:5 · ERROR:1 |  | 85 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0498 | B4 | SSP0060_ShipmentPlan.GetErpIFCheck | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetErpIFCheck 의 B4 23요소: NA:15 · NOPATH:5 · ERROR:3 |  | 19 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0499 | B4 | SSP0060_ShipmentPlan.GetErpIFCheckNew | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetErpIFCheckNew 의 B4 23요소: NA:15 · NOPATH:5 · ERROR:3 |  | 43 (ACT:SSP0060_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0060-0500 | B4 | SSP0060_ShipmentPlan.GetErpSoNoCnt | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetErpSoNoCnt 의 B4 23요소: NA:15 · NOPATH:5 · ERROR:3 |  | 9 (ACT:SSP0060_ShipmentPlan.GetErpSoNoCnt:4) |
| WK-SSP0060-0501 | B4 | SSP0060_ShipmentPlan.GetFilteredDs | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetFilteredDs 의 B4 9요소: NA:5 · ERROR:3 · NOPATH:1 |  | 6 (ACT:SSP0060_ShipmentPlan.GetFilteredDs:5) |
| WK-SSP0060-0502 | B4 | SSP0060_ShipmentPlan.GetNERPCode | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetNERPCode 의 B4 23요소: NA:15 · NOPATH:5 · ERROR:3 |  | 9 (ACT:SSP0060_ShipmentPlan.GetNERPCode:714) |
| WK-SSP0060-0503 | B4 | SSP0060_ShipmentPlan.GetNewERPInterface | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetNewERPInterface 의 B4 7요소: NA:6 · ERROR:1 |  | 26 (ACT:SSP0060_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0060-0504 | B4 | SSP0060_ShipmentPlan.GetSSPUserCheck | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetSSPUserCheck 의 B4 23요소: NA:15 · NOPATH:5 · ERROR:3 |  | 9 (ACT:SSP0060_ShipmentPlan.GetSSPUserCheck) |
| WK-SSP0060-0505 | G3 | SSP0060 화면 | 하네스·환경 | G3 도구 오류 — 원장 V-e37cc7a4 RULE_SCREEN / 원장 V-2c33bc26 GENERAL / 원장 V-f470d7b8 GENERAL / 원장 V-56cad4c3 GENERAL / 원장 V-ec5f0ab4 CONFI |  | 8 (D00-1-064 COMMON:UC-01 COMMON:UC-02 COMM) |
| WK-SSP0060-0506 | K4 | SSP0060 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-50e44432 GENERAL / 원장 V-b836c60a GENERAL / 원장 V-cad7e26b GENERAL / 원장 V-ed8bc220 GENERAL / 원장 V-0f69e0d5 GENERAL / |  | 162 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SSP0060-0507 | F3 | SSP0060 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-14f4f162 RULE_SCREEN / 원장 V-7a7ac6af RULE_SCREEN / 원장 V-5bc710f4 GENERAL / 원장 V-bcc35e97 GENERAL / 원장 V-0d941db3 G |  | 106 (I1-paste I22 ACT:SSP0060_ShipmentPlan.Sp) |
| WK-SSP0060-0508 | F5 | SSP0060 화면 | 하네스·환경 | F5 도구 오류 — 원장 V-46d50262 RULE_SCREEN / 원장 V-26ac350e RULE_SCREEN / 원장 V-557f7fa7 RULE_SCREEN / 원장 V-605e163c DEFECT / 원장 V-4ff22fd |  | 3 (D00-4a-004 CRUD:DELETE I1-delete) |
| WK-SSP0060-0509 | F4 | CRUD:SEARCH | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 CRUD:SEARCH 'FindData_Main + Detail 8-sheet 조회' 의 F4 28요소: ERROR:18 · REVIEW:5 · PASS:4 · NA:1 · FAIL 요소: SS |  | 1 (CRUD:SEARCH) |
| WK-SSP0060-0510 | F4 | D00-4a-002 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 D00-4a-002 'FindButton' 의 F4 28요소: ERROR:18 · REVIEW:5 · PASS:4 · NA:1 · FAIL 요소: SSP0060_DELETE_SHIPMENT_RE |  | 1 (D00-4a-002) |
| WK-SSP0060-0511 | F4 | D00-4a-003 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 D00-4a-003 'SaveButton' 의 F4 28요소: ERROR:18 · REVIEW:5 · PASS:4 · NA:1 · FAIL 요소: SSP0060_DELETE_SHIPMENT_RE |  | 1 (D00-4a-003) |
| WK-SSP0060-0512 | F4 | D00-4a-004 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 D00-4a-004 'DeleteButton (NO-OP 확정)' 의 F4 28요소: ERROR:18 · REVIEW:5 · PASS:4 · NA:1 · FAIL 요소: SSP0060_DELET |  | 1 (D00-4a-004) |
| WK-SSP0060-0513 | F4 | D00-4a-005 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 D00-4a-005 'InsertButton' 의 F4 28요소: ERROR:18 · REVIEW:5 · PASS:4 · NA:1 · FAIL 요소: SSP0060_DELETE_SHIPMENT_ |  | 1 (D00-4a-005) |
| WK-SSP0060-0514 | F4 | D00-4a-006~036 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 D00-4a-006~036 'event 29종' 의 F4 28요소: ERROR:18 · REVIEW:5 · PASS:4 · NA:1 · FAIL 요소: SSP0060_DELETE_SHIPMENT |  | 1 (D00-4a-006~036) |
| WK-SSP0060-0515 | F4 | I2 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 I2 'SaveData_Main IsLock(shtMain)==false 가드(.cs L2935~' 의 F4 28요소: ERROR:18 · REVIEW:5 · PASS:4 · NA:1 · FAI |  | 1 (I2) |
| WK-SSP0060-0516 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 하네스·환경 | F4 도구 오류 — E2E smoke call-proc / 실측[T-0c79f69e]: PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: SCP0009/calendar/SEARCH, SCP0010/ |  | 914 (D00-4-028 ACT:SSP0060_ShipmentPlan.FindB) |
| WK-SSP0060-0517 | F4 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | 하네스·환경 | F4 도구 오류 — 실측[T-db118a18]: PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST: SSP0015/main/USER_CHECK, SSP0021/main/USER_CHECK, SSP0022/mai |  | 4 (D00-4-030 ACT:SSP0060_ShipmentPlan.GetSS) |
| WK-SSP0060-0518 | F4 | PKG_SSP0020.P_USER_CHECK | 하네스·환경 | F4 도구 오류 — 실측[T-3c65b7f9]: PKG_SSP0020.P_USER_CHECK: SSP0020/Delegate/USER_CHECK — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리오에서 판정) |  | 2 (D00-4-030 D00-4a-001) |
| WK-SSP0060-0519 | F4 | PKG_SSP0060.P_SSP0060_GET_ERP_SO_NO_CNT | 하네스·환경 | F4 도구 오류 — 실측[T-082bd5d7]: PKG_SSP0060.P_SSP0060_GET_ERP_SO_NO_CNT: SSP0060/main/GET_ERP_SO_NO_CNT — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회  |  | 431 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0520 | F4 | PKG_SSP0060.P_SSP0060_GET_HOLD_STOCK | 하네스·환경 | F4 도구 오류 — 실측[T-c0a3bfde]: PKG_SSP0060.P_SSP0060_GET_HOLD_STOCK: SSP0060/holdStock/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시 |  | 59 (D00-4-024 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0521 | F4 | PKG_SSP0060.P_SSP0060_GET_MES_STOCK | 하네스·환경 | F4 도구 오류 — 실측[T-b1629ef8]: PKG_SSP0060.P_SSP0060_GET_MES_STOCK: SSP0060/mesStock/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리 |  | 61 (D00-4-025 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0522 | F4 | PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETA | 하네스·환경 | F4 도구 오류 — 실측[T-c59565ad]: PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETAIL: SSP0060/mesStockDetail/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조 |  | 65 (D00-4-026 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0523 | F4 | PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL | 하네스·환경 | F4 도구 오류 — 실측[T-3b99473c]: PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL: SSP0060/owmsDetail/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 |  | 61 (D00-4-021 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0524 | F4 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_ | 하네스·환경 | F4 도구 오류 — 실측[T-ae9185c7]: PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_DETAIL: SSP0060/planDetail/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조 |  | 337 (D00-4-019 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0525 | F4 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUE | 하네스·환경 | F4 도구 오류 — 실측[T-04c0a574]: PKG_SSP0060.P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING: SSP0021/confirmDetail/SEARCH, SSP0060/conf |  | 50 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0526 | F4 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESUL | 하네스·환경 | F4 도구 오류 — 실측[T-f4a9fbf8]: PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESULT: SSP0060/shipmentResult/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 |  | 132 (D00-4-022~023 ACT:SSP0060_ShipmentPlan.F) |
| WK-SSP0060-0527 | F4 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_STATU | 하네스·환경 | F4 도구 오류 — 실측[T-b3ac4bb5]: PKG_SSP0060.P_SSP0060_GET_SHIPMENT_STATUS: SSP0060/main/GET_SHIPMENT_STATUS — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 |  | 431 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0528 | F4 | PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION | 하네스·환경 | F4 도구 오류 — 실측[T-5c7bffdf]: PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION_DETAIL: SSP0060/stockDetail/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 |  | 61 (D00-4-020 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0529 | F4 | PKG_SSP0060.P_SSP0060_SAVE_SHIPMENT_REQU | 하네스·환경 | F4 도구 오류 — 실측[T-44816da8]: [측정 경로 없음] PKG_SSP0060.P_SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM: 이번 Save 는 main/SAVE 로 저장(정상 호출) — 이 SP  |  | 422 (D00-4-003 ACT:SSP0060_ShipmentPlan.SaveB) |
| WK-SSP0060-0530 | F4 | PKG_SSP0060.P_SSP0060_SAVE_SHIPMENT_REQU | 하네스·환경 | F4 도구 오류 — 실측[T-bbb3cb02]: [측정 경로 없음] PKG_SSP0060.P_SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING: 이번 Save 는 main/SAVE 로 저장(정상 호출) — 이 SP |  | 6 (ACT:SSP0060_ShipmentPlan.NewNonSoNo:4928) |
| WK-SSP0060-0531 | F4 | PKG_SSP0060.P_SSP0060_SAVE_SHIPMENT_REQU | 하네스·환경 | F4 도구 오류 — 실측[T-477abad6]: [측정 경로 없음] PKG_SSP0060.P_SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN: 이번 Save 는 main/SAVE 로 저장(정상 호출) — |  | 8 (ACT:SSP0060_ShipmentPlanRequestPopup.Non) |
| WK-SSP0060-0532 | F4 | PKG_SSP0202.P_SSP0202_SAVE_SHIPMENT_REQU | 하네스·환경 | F4 도구 오류 — 실측[T-be76376a]: PKG_SSP0202.P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK: SSP0202/main/IF_CHECK — 화면 진입·조회 중 호출 없음( |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0533 | F4 | P_SSP0300_GET_ORDER_DETAIL | 하네스·환경 | F4 도구 오류 — 실측[T-02819001]: P_SSP0300_GET_ORDER_DETAIL: SSP0015/main/GET_ORDER_DETAIL, SSP0021/main/GET_ORDER_DETAIL, SSP0023/main/ |  | 1 (D00-4e-004) |
| WK-SSP0060-0534 | F4 | SSP0060_ShipmentPlan.ChkConfirmChangeTim | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.ChkConfirmChangeTime 의 F4 28요소: ERROR:18 · REVIEW:5 · PASS:4 · NA:1 · FAIL 요소: SSP006 |  | 2 (ACT:SSP0060_ShipmentPlan.ChkConfirmChang) |
| WK-SSP0060-0535 | F4 | SSP0060_ShipmentPlan.GetErpIFCheckNew | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.GetErpIFCheckNew 의 F4 28요소: ERROR:18 · REVIEW:5 · PASS:4 · NA:1 · FAIL 요소: SSP0060_DE |  | 6 (ACT:SSP0060_ShipmentPlan.GetErpIFCheckNe) |
| WK-SSP0060-0536 | F4 | SSP0060_ShipmentPlanRequestPopup.ChkConf | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlanRequestPopup.ChkConfirmChangeTime 의 F4 28요소: ERROR:18 · REVIEW:5 · PASS:4 · NA:1 · FAI |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-0537 | F4 | SSP0060_ShipmentPlanRequestPopup.GetErpI | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlanRequestPopup.GetErpIFCheckNew 의 F4 28요소: ERROR:18 · REVIEW:5 · PASS:4 · NA:1 · FAIL 요소 |  | 12 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0538 | A5 | DIFF_QTY | 하네스·환경 | A5 도구 오류 — 실측[T-9037faad]: CHANGE_REQ_NO 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0539 | A5 | NEW_SHIPMENT_CONFIRM_QTY | 하네스·환경 | A5 도구 오류 — 실측[T-ecee5f42]: CHANGE_REQ_NO 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0540 | A5 | NEW_YN / New YN | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-35c89e5b]: NEW_YN: [측정 경로 없음] AS-IS 시트 Request Info 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-0541 | A5 | SSP0060_ShipmentPlan.CreateSpread | 하네스·환경 | A5 도구 오류 — 실측[T-504fba87]: AS-IS 기본 표시 컬럼 3 ⊆ TO-BE 그리드 33: 누락 A_COUNTRY, A_PORT_CODE, A_PORT_NAME (AS-IS 숨김·코드추가 helper 컬럼은 비교 제외 |  | 30 (ACT:SSP0060_ShipmentPlan.CreateSpread:56) |
| WK-SSP0060-0542 | A5 | SSP0060_ShipmentPlan.SetSpreadColumn | 하네스·환경 | A5 도구 오류 — 실측[T-f5ac9527]: AS-IS 기본 표시 컬럼 3 ⊆ TO-BE 그리드 33: 누락 A_COUNTRY, A_PORT_CODE, A_PORT_NAME (AS-IS 숨김·코드추가 helper 컬럼은 비교 제외 |  | 1 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0543 | H10 | SSP0060 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 34 (D00-2-014 D00-2b-002 D00-2b-003 D00-2b-0) |
| WK-SSP0060-0544 | H2 | BOH_TYPE | 하네스·환경 | H2 도구 오류 — 원장 V-94772504 COLUMN / 실측[T-9b57152f]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetai |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0545 | H2 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | H2 도구 오류 — 원장 V-1ebc7e12 COLUMN / 원장 V-c326f099 ASIS / 원장 V-499e35e8 ASIS / 원장 V-246df382 ASIS / 원장 V-9990e084 ASIS / 원장 V-2c872ca |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0546 | H2 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | H2 도구 오류 — 원장 V-e7023170 COLUMN / 원장 V-1f8143a0 ASIS / 실측[T-c6f97d86]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertR |  | 5 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0547 | H2 | CHANGE_REQ_NO / Change Request No | 하네스·환경 | H2 도구 오류 — 원장 V-c403e365 COLUMN / 실측[T-bdeebf1d]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetai |  | 9 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0548 | H2 | COMMON:UC-01 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터 유지(keepRowVisibleUnderFil' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (COMMON:UC-01) |
| WK-SSP0060-0549 | H2 | COMMON:UC-05 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 콤보 컬럼 Code 아닌 Name 출력' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0550 | H2 | COMMON:UC-07 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 필터 유지(rebindFilterColumns)' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (COMMON:UC-07) |
| WK-SSP0060-0551 | H2 | CONFIRM_ID / Confirm/Plan ID | 하네스·환경 | H2 도구 오류 — 원장 V-a3acf227 COLUMN / 원장 V-952a7187 COLUMN / 실측[T-97a602c7]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(Inser |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0552 | H2 | D00-1-054 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-054 'spdDetail' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (D00-1-054) |
| WK-SSP0060-0553 | H2 | D00-1-057 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-1-057 'spdMain_Sheet1' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (D00-1-057) |
| WK-SSP0060-0554 | H2 | D00-2b-015~016 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-2b-015~016 'MSG00007 Measure sheet 제한' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (D00-2b-015~016) |
| WK-SSP0060-0555 | H2 | D00-2b-021 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-2b-021 'MSG00084 음수 검증' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (D00-2b-021) |
| WK-SSP0060-0556 | H2 | D00-3-010 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-3-010 'Action 열 강조색(FGAction/BGModified)' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (D00-3-010) |
| WK-SSP0060-0557 | H2 | D00-3-014 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-3-014 '저장 후 강조색 리셋' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (D00-3-014) |
| WK-SSP0060-0558 | H2 | D00-3-029 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-3-029 '조회 후 재병합·주석리셋·0치환' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (D00-3-029) |
| WK-SSP0060-0559 | H2 | D00-4a-003 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 D00-4a-003 'SaveButton' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (D00-4a-003) |
| WK-SSP0060-0560 | H2 | DIFF_QTY | 하네스·환경 | H2 도구 오류 — 실측[T-8eb58d1b]: CHANGE_REQ_NO 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0561 | H2 | DIVISION_ID / Div | 하네스·환경 | H2 도구 오류 — 원장 V-8c7f5d77 COLUMN / 원장 V-728912dc COLUMN / 원장 V-9d92359a COLUMN / 원장 V-a8bd5a36 COLUMN / 원장 V-f06cf112 COLUMN / 원장 V |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0562 | H2 | ERP_SO_NO | 하네스·환경 | H2 도구 오류 — 원장 V-1f8143a0 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0563 | H2 | ERP_SO_NO / SO No | 하네스·환경 | H2 도구 오류 — 원장 V-9151d180 COLUMN / 원장 V-d19fb5b7 COLUMN / 원장 V-1f8143a0 ASIS / 실측[T-0516f747]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 —  |  | 10 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0564 | H2 | ETA | 하네스·환경 | H2 도구 오류 — 원장 V-5ce2b6d1 COLUMN / 실측[T-b916dacb]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetai |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0565 | H2 | ETD | 하네스·환경 | H2 도구 오류 — 원장 V-afc858c4 COLUMN / 실측[T-3c9852d7]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetai |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0566 | H2 | FCST_TYPE / FCST Type | 하네스·환경 | H2 도구 오류 — 원장 V-9ff19d08 COLUMN / 원장 V-4fffc3a2 COLUMN / 실측[T-4f0a6d8c]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(Inser |  | 12 (D00-3-002 Ra ACT:SSP0060_ShipmentPlan.In) |
| WK-SSP0060-0567 | H2 | FROM_SITE_DESCRIPTION / From Site | 하네스·환경 | H2 도구 오류 — 원장 V-dcc49f46 COLUMN / 원장 V-029fd98b COLUMN / 실측[T-0396c6b7]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(Inser |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0568 | H2 | I14 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 I14 '정정: BaseForm.FpSpread_CellClick(BaseForm.cs L2303~' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (I14) |
| WK-SSP0060-0569 | H2 | I16 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 I16 'InitSpreadFooterSum(.cs L764~853 — 시트별 수치구간 Sum + ' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (I16) |
| WK-SSP0060-0570 | H2 | I16 Measure 시트변형 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 I16 Measure 시트변형 '검증축' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (I16 Measure 시트변형) |
| WK-SSP0060-0571 | H2 | I9 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 I9 'Division/Company 변경 시 그리드 초기화(hook #5, np §5-5)' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (I9) |
| WK-SSP0060-0572 | H2 | INCOTERMS / Incoterms | 하네스·환경 | H2 도구 오류 — 원장 V-c00b4f07 COLUMN / 원장 V-9d981456 COLUMN / 원장 V-74ef3a09 COLUMN / 실측[T-7cc31945]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음  |  | 10 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0573 | H2 | ITEM_ID / Model | 하네스·환경 | H2 도구 오류 — 원장 V-add71e65 COLUMN / 원장 V-f0b533b4 COLUMN / 원장 V-7488cf01 COLUMN / 원장 V-9993d4d1 COLUMN / 원장 V-afe8ffa6 COLUMN / 원장 V |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0574 | H2 | LT_DAY / L/T(Day | 하네스·환경 | H2 도구 오류 — 원장 V-9807a977 COLUMN / 실측[T-85df4fd4]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetai |  | 8 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0575 | H2 | MEASURE_NAME / Measure | 하네스·환경 | H2 도구 오류 — 원장 V-826498bc COLUMN / 실측[T-d92f6802]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetai |  | 4 (Rb Re ACT:SSP0060_ShipmentPlan.InitSprea) |
| WK-SSP0060-0576 | H2 | NEW_SHIPMENT_CONFIRM_QTY | 하네스·환경 | H2 도구 오류 — 실측[T-feea3766]: CHANGE_REQ_NO 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0577 | H2 | NEW_YN / New YN | 하네스·환경 | H2 도구 오류 — 실측[T-748977b8]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-0578 | H2 | NICK_NAME / Nick Name | 하네스·환경 | H2 도구 오류 — 원장 V-85466d46 COLUMN / 원장 V-23b9ae3d COLUMN / 원장 V-ee7768ae COLUMN / 원장 V-0fe9e2da COLUMN / 원장 V-d654731c COLUMN / 원장 V |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0579 | H2 | PRODUCT_LEVEL1 / Product Level1 | 하네스·환경 | H2 도구 오류 — 원장 V-8e2d6319 COLUMN / 원장 V-bf4af413 COLUMN / 실측[T-34818699]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(Inser |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0580 | H2 | PROJECT_CODE / Project Code | 하네스·환경 | H2 도구 오류 — 원장 V-751400ee COLUMN / 실측[T-92b0cccf]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetai |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0581 | H2 | PROJECT_NAME / Project Name | 하네스·환경 | H2 도구 오류 — 원장 V-9bc6fbb8 COLUMN / 실측[T-6bf02d33]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetai |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0582 | H2 | PSI | 하네스·환경 | H2 도구 오류 — 원장 V-8009db33 COLUMN / 실측[T-b67f5b20]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetai |  | 2 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0583 | H2 | REMARKS / Remarks | 하네스·환경 | H2 도구 오류 — 원장 V-4dbc6456 COLUMN / 원장 V-f20d0012 COLUMN / 원장 V-05a9a651 COLUMN / 원장 V-c326f099 ASIS / 원장 V-499e35e8 ASIS / 원장 V-c56 |  | 4 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0584 | H2 | REMARKS2 / Building | 하네스·환경 | H2 도구 오류 — 원장 V-e7d0e08e COLUMN / 원장 V-6aec1f48 ASIS / 원장 V-3600c72f ASIS / 실측[T-272a3597]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS |  | 4 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0585 | H2 | REMARKS3 / Customer Requirement | 하네스·환경 | H2 도구 오류 — 원장 V-54b3eedd COLUMN / 실측[T-13be4bf9]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetai |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0586 | H2 | Rd | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 Rd 'L5543~5563' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (Rd) |
| WK-SSP0060-0587 | H2 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | H2 도구 오류 — 원장 V-a073356e COLUMN / 원장 V-b294d9fe ASIS / 원장 V-097e7a60 ASIS / 원장 V-c326f099 ASIS / 원장 V-499e35e8 ASIS / 원장 V-246df38 |  | 8 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0588 | H2 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | H2 도구 오류 — 원장 V-6ecd4c4e COLUMN / 원장 V-b294d9fe ASIS / 원장 V-097e7a60 ASIS / 원장 V-4e44e66e ASIS / 원장 V-c326f099 ASIS / 원장 V-499e35e |  | 9 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0589 | H2 | SSP0060_ShipmentPlan.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.CreateSpread 의 H2 76요소: ERROR:48 · NA:28 |  | 30 (ACT:SSP0060_ShipmentPlan.CreateSpread:56) |
| WK-SSP0060-0590 | H2 | SSP0060_ShipmentPlan.SetSpreadColumn | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SetSpreadColumn 의 H2 1요소: ERROR:1 |  | 1 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0591 | H2 | TO_SITE / To Site | 하네스·환경 | H2 도구 오류 — 원장 V-131df447 COLUMN / 원장 V-49de52e4 COLUMN / 실측[T-315cb24b]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(Inser |  | 7 (Rc ACT:SSP0060_ShipmentPlan.InitSpread A) |
| WK-SSP0060-0592 | H2 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | H2 도구 오류 — 원장 V-ffd56310 COLUMN / 실측[T-53477a20]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetai |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0593 | H2 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | H2 도구 오류 — 원장 V-ec702ebd COLUMN / 원장 V-cf5b3b33 COLUMN / 원장 V-6f8921a2 COLUMN / 원장 V-b294d9fe ASIS / 원장 V-097e7a60 ASIS / 원장 V-4e4 |  | 10 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0594 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-246df382 |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0595 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-9990e084 |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0596 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-d3850d77 |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0597 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-eae229d4 |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0598 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-c56fc516 |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0599 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-6dbc738a |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0600 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-6aec1f48 |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0601 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-3600c72f |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0602 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-2c872ca0 |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0603 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-fffe8ceb |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0604 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-af9807fd |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0605 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-f5ebcdbf |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0606 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-2f2b065f |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0607 | H2 | siDetail.ActiveSheet.Cells[i, siDetail.G | 하네스·환경 | H2 도구 오류 — 원장 V-d4620e21 |  | 1 (ACT:SSP0060_ShipmentPlan.Validation_Chec) |
| WK-SSP0060-0608 | H2 | siMain.ActiveSheet.SetActiveCell | 하네스·환경 | H2 도구 오류 — 원장 V-87d1721a |  | 1 (ACT:SSP0060_ShipmentPlan.FindData_hold_s) |
| WK-SSP0060-0609 | H2 | siMain.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-9a18e7da |  | 1 (ACT:SSP0060_ShipmentPlan.SaveData_Main:2) |
| WK-SSP0060-0610 | H2 | 메타 SQL 3종(18/19/20) 적용 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 메타 SQL 3종(18/19/20) 적용 'ERROR(미실행)' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (메타 SQL 3종(18/19/20) 적용) |
| WK-SSP0060-0611 | H2 | 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·EE행 TransMode 드롭다운 'ERROR(미실행)' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E) |
| WK-SSP0060-0612 | H2 | 음수 = 빨간 글자 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 음수 = 빨간 글자 '**이식**' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (음수 = 빨간 글자) |
| WK-SSP0060-0613 | H2 | 편집 불가(하늘색 Rc) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 편집 불가(하늘색 Rc) '확정구간 이전·이후 — `measureRowBackground` Rc(SHIP_PLAN_D' 의 H2 76요소: ERROR:48 · NA:28 |  | 1 (편집 불가(하늘색 Rc)) |
| WK-SSP0060-0614 | H4 | SSP0060 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-b4fafa47 RULE_SCREEN / 원장 V-4659e3af RULE_SCREEN / 원장 V-d1ee2366 RULE_SCREEN / 원장 V-235e36a6 RULE_SCREEN / 원장 V-84 |  | 7 (ACT:SSP0060_ShipmentPlan.SpdDetail_TopCh) |
| WK-SSP0060-0615 | H5 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | H5 도구 오류 — 실측[T-bda57316]: CHANGE_REASON_CODE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0616 | H5 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | H5 도구 오류 — 실측[T-06d453d1]: CHANGE_REASON_DETAIL 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 5 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0617 | H5 | CHANGE_REQ_NO / Change Request No | 하네스·환경 | H5 도구 오류 — 실측[T-f96772a0]: CHANGE_REQ_NO 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 9 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0618 | H5 | COMMON:UC-01 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터 유지(keepRowVisibleUnderFil' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NO |  | 1 (COMMON:UC-01) |
| WK-SSP0060-0619 | H5 | COMMON:UC-05 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 콤보 컬럼 Code 아닌 Name 출력' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0620 | H5 | COMMON:UC-07 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 필터 유지(rebindFilterColumns)' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (COMMON:UC-07) |
| WK-SSP0060-0621 | H5 | CONFIRM_ID / Confirm/Plan ID | 하네스·환경 | H5 도구 오류 — 실측[T-5a755aee]: CONFIRM_ID 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0622 | H5 | D00-1-054 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-054 'spdDetail' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (D00-1-054) |
| WK-SSP0060-0623 | H5 | D00-1-057 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-057 'spdMain_Sheet1' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (D00-1-057) |
| WK-SSP0060-0624 | H5 | D00-2b-015~016 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-2b-015~016 'MSG00007 Measure sheet 제한' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (D00-2b-015~016) |
| WK-SSP0060-0625 | H5 | D00-3-029 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-3-029 '조회 후 재병합·주석리셋·0치환' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (D00-3-029) |
| WK-SSP0060-0626 | H5 | D00-4a-003 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-4a-003 'SaveButton' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (D00-4a-003) |
| WK-SSP0060-0627 | H5 | DIFF_QTY | 하네스·환경 | H5 도구 오류 — 실측[T-259e6724]: CHANGE_REQ_NO 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0628 | H5 | ERP_SO_NO / SO No | 하네스·환경 | H5 도구 오류 — 실측[T-dfec6b9a]: ERP_SO_NO 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 9 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0629 | H5 | ETA | 하네스·환경 | H5 도구 오류 — 실측[T-6ecf30d0]: ETA 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0630 | H5 | ETD | 하네스·환경 | H5 도구 오류 — 실측[T-75dd0821]: ETD 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0631 | H5 | I14 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 I14 '정정: BaseForm.FpSpread_CellClick(BaseForm.cs L2303~' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (I14) |
| WK-SSP0060-0632 | H5 | I16 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 I16 'InitSpreadFooterSum(.cs L764~853 — 시트별 수치구간 Sum + ' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (I16) |
| WK-SSP0060-0633 | H5 | I16 Measure 시트변형 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 I16 Measure 시트변형 '검증축' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (I16 Measure 시트변형) |
| WK-SSP0060-0634 | H5 | I9 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 I9 'Division/Company 변경 시 그리드 초기화(hook #5, np §5-5)' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (I9) |
| WK-SSP0060-0635 | H5 | LT_DAY / L/T(Day | 하네스·환경 | H5 도구 오류 — 실측[T-a3eed8eb]: LT_DAY 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 8 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0636 | H5 | NEW_SHIPMENT_CONFIRM_QTY | 하네스·환경 | H5 도구 오류 — 실측[T-e17fbe1a]: CHANGE_REQ_NO 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0637 | H5 | NEW_YN / New YN | 하네스·환경 | H5 도구 오류 — 실측[T-f2c59109]: NEW_YN 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-0638 | H5 | PROJECT_CODE / Project Code | 하네스·환경 | H5 도구 오류 — 실측[T-00bf1ec1]: PROJECT_CODE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0639 | H5 | PROJECT_NAME / Project Name | 하네스·환경 | H5 도구 오류 — 실측[T-950fe2d9]: PROJECT_NAME 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0640 | H5 | REMARKS / Remarks | 하네스·환경 | H5 도구 오류 — 실측[T-9c611eb6]: REMARKS 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0641 | H5 | REMARKS2 / Building | 하네스·환경 | H5 도구 오류 — 실측[T-e1decdba]: REMARKS2 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0642 | H5 | REMARKS3 / Customer Requirement | 하네스·환경 | H5 도구 오류 — 실측[T-1ef0354b]: REMARKS3 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0643 | H5 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | H5 도구 오류 — 실측[T-8cc66f20]: SHIPMENT_CONFIRM_QTY 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0644 | H5 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | H5 도구 오류 — 실측[T-44c5919c]: SHIPMENT_DATE 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0645 | H5 | SSP0060_ShipmentPlan.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.CreateSpread 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 30 (ACT:SSP0060_ShipmentPlan.CreateSpread:56) |
| WK-SSP0060-0646 | H5 | SSP0060_ShipmentPlan.SetSpreadColumn | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SetSpreadColumn 의 H5 3요소: PASS:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0647 | H5 | TO_SITE_DESCRIPTION / To Site | 하네스·환경 | H5 도구 오류 — 실측[T-ab7a8259]: TO_SITE_DESCRIPTION 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0648 | H5 | 메타 SQL 3종(18/19/20) 적용 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 메타 SQL 3종(18/19/20) 적용 'ERROR(미실행)' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (메타 SQL 3종(18/19/20) 적용) |
| WK-SSP0060-0649 | H5 | 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·EE행 TransMode 드롭다운 'ERROR(미실행)' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 |  | 1 (브라우저 육안 — R7a 알럿·OrderDetail 그리드·음수셀 색·E) |
| WK-SSP0060-0650 | H5 | 음수 = 빨간 글자 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 음수 = 빨간 글자 '**이식**' 의 H5 55요소: NA:21 · ERROR:19 · PASS:14 · NOT_RUN:1 |  | 1 (음수 = 빨간 글자) |
| WK-SSP0060-0651 | D1 | BACK_COLOR / Back Color | 하네스·환경 | D1 도구 오류 — 실측[T-632e8adb]: BACK_COLOR AS-IS 편집 기대(edit_expect) 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (확정구간 스타일) |
| WK-SSP0060-0652 | D1 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | D1 도구 오류 — 원장 V-dfb14989 COLUMN / 원장 V-e28c4a9b COLUMN / 실측[T-a90dbbbc]: 기존행 r0 CHANGE_REASON_CODE: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0653 | D1 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | D1 도구 오류 — 원장 V-a7e0d871 COLUMN / 원장 V-6def728a COLUMN / 실측[T-d90671e2]: 기존행 r0 CHANGE_REASON_DETAIL: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton:2865) |
| WK-SSP0060-0654 | D1 | CHANGE_REQ_NO / Change Request No | 하네스·환경 | D1 도구 오류 — 원장 V-0d3ebffa COLUMN / 원장 V-99909fec COLUMN / 실측[T-ee425d27]: 기존행 r0 CHANGE_REQ_NO: 현재 그리드에 없음 — 표시 여부는 A5 |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0655 | D1 | CONFIRM_DAY / Confrim Day | 하네스·환경 | D1 도구 오류 — 실측[T-1abbc3cf]: CONFIRM_DAY AS-IS 편집 기대(edit_expect) 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (D00-3-023 편집 가능 일자(노랑) ACT:SSP0060_Shipm) |
| WK-SSP0060-0656 | D1 | CRUD:EDIT | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 CRUD:EDIT '4가드 + 화이트리스트 잠금해제' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (CRUD:EDIT) |
| WK-SSP0060-0657 | D1 | D00-2-020 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-2-020 'SpdDetail_ComboSelChange' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-2-020) |
| WK-SSP0060-0658 | D1 | D00-2b-002 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-2b-002 'MSG00189 ERP C 편집차단' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-2b-002) |
| WK-SSP0060-0659 | D1 | D00-2b-017 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-2b-017 'MSG00251 SSP 사용자 체크' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-2b-017) |
| WK-SSP0060-0660 | D1 | D00-2b-018 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-2b-018 'MSG00170 이전 Plan 편집차단' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-2b-018) |
| WK-SSP0060-0661 | D1 | D00-2b-019 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-2b-019 'MSG00424 편집 Sheet 상이' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-2b-019) |
| WK-SSP0060-0662 | D1 | D00-2b-020 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-2b-020 'MSG00312 Real 아님(Detail)' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-2b-020) |
| WK-SSP0060-0663 | D1 | D00-3-019 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-3-019 'Main 수량 편집 반영+초과 Red' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-3-019) |
| WK-SSP0060-0664 | D1 | D00-3-022 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-3-022 'Insert 신규행 삽입·파생·잠금' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-3-022) |
| WK-SSP0060-0665 | D1 | D00-3-028 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-3-028 'Query/LockColumn 조회 바인딩 9건' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-3-028) |
| WK-SSP0060-0666 | D1 | D00-3-033 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-3-033 'Simulation 신규행·콤보·잠금' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-3-033) |
| WK-SSP0060-0667 | D1 | D00-4a-001 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4a-001 'EditButton(toolbarOverride)' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-4a-001) |
| WK-SSP0060-0668 | D1 | D00-4d-004 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-004 "sErpStatus=='C'" 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-4d-004) |
| WK-SSP0060-0669 | D1 | D00-4d-038 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-038 'EditButton isOK(사용자 체크)' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-4d-038) |
| WK-SSP0060-0670 | D1 | D00-4d-039~040 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-039~040 'EditButton PlanDate/EditSpread' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-4d-039~040) |
| WK-SSP0060-0671 | D1 | D00-4d-041~042 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D00-4d-041~042 'EditButton Detail 분기/RealFlag' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (D00-4d-041~042) |
| WK-SSP0060-0672 | D1 | DIVISION_ID / Div | 하네스·환경 | D1 도구 오류 — 원장 V-5c92b1d1 COLUMN / 원장 V-ebce5472 COLUMN / 원장 V-6ede1da1 COLUMN / 원장 V-4dfb8d99 COLUMN / 원장 V-1c26db4e COLUMN / 원장 V |  | 10 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0673 | D1 | FCST_TYPE / FCST Type | 하네스·환경 | D1 도구 오류 — 원장 V-0c84bedb COLUMN / 원장 V-5a877d83 COLUMN / 원장 V-bc261dcd COLUMN / 원장 V-95b11272 COLUMN / 실측[T-03b597dd]: 기존행 r0 FCST |  | 7 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0674 | D1 | HOLD_YYYYMMDD / Start Date | 하네스·환경 | D1 도구 오류 — 원장 V-e19ad80f COLUMN / 원장 V-8805d314 COLUMN / 원장 V-16c9bca2 COLUMN / 원장 V-15e389e7 COLUMN / 실측[T-cc76138d]: 기존행 r0 HOLD |  | 3 (ACT:SSP0060_ShipmentPlan.EditButton:2874) |
| WK-SSP0060-0675 | D1 | I1-delete | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 I1-delete 'spdMain_KeyUp(.cs L2462~2521 — 선택범위 D_ 셀 "0"+EditB' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (I1-delete) |
| WK-SSP0060-0676 | D1 | I2 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 I2 'SaveData_Main IsLock(shtMain)==false 가드(.cs L2935~' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (I2) |
| WK-SSP0060-0677 | D1 | I22 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 I22 'SpdDetail_ClipboardPasted 가드 5종(L1395~) — 잠금해제 셀 붙' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (I22) |
| WK-SSP0060-0678 | D1 | I9 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 I9 'Division/Company 변경 시 그리드 초기화(hook #5, np §5-5)' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (I9) |
| WK-SSP0060-0679 | D1 | LAST_UPDATED_BY / Last Updated By | 하네스·환경 | D1 도구 오류 — 원장 V-5a032209 COLUMN / 원장 V-bf4f9367 COLUMN / 원장 V-2074c6b4 COLUMN / 원장 V-42d9b381 COLUMN / 실측[T-39845705]: 기존행 r0 LAST |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton:2877) |
| WK-SSP0060-0680 | D1 | LAST_UPDATE_DATE / Last Updated Date | 하네스·환경 | D1 도구 오류 — 원장 V-d1776ba4 COLUMN / 원장 V-465c486f COLUMN / 원장 V-30a6ac75 COLUMN / 원장 V-efce716c COLUMN / 실측[T-c954b418]: 기존행 r0 LAST |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton:2877) |
| WK-SSP0060-0681 | D1 | MEASURE / Measure | 하네스·환경 | D1 도구 오류 — 실측[T-e514dded]: MEASURE AS-IS 편집 기대(edit_expect) 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0682 | D1 | MEASURE_NAME / Measure | 하네스·환경 | D1 도구 오류 — 원장 V-388e56c4 COLUMN / 원장 V-1b96fc14 COLUMN / 실측[T-72a48b8f]: MEASURE_NAME AS-IS 편집 기대(edit_expect) 없음 → 기계 판정 불가 — 수동  |  | 3 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0683 | D1 | NEW-1 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 NEW-1 "공용 wrapper beginningEdit/pastingCell 이 메타 'S' 전건을 " 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (NEW-1) |
| WK-SSP0060-0684 | D1 | NEW_SHIPMENT_CONFIRM_QTY | 하네스·환경 | D1 도구 오류 — 실측[T-cdc668af]: 팝업 내부 그리드 컬럼 NEW_SHIPMENT_CONFIRM_QTY — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작 |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0685 | D1 | PRODUCT_LEVEL1 / Product Level1 | 하네스·환경 | D1 도구 오류 — 원장 V-b854d90d COLUMN / 원장 V-0f16a296 COLUMN / 원장 V-4cf24e77 COLUMN / 원장 V-6d6d09e7 COLUMN / 실측[T-b20b311c]: 기존행 r0 PROD |  | 2 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0686 | D1 | QTY / Shipment Qty | 하네스·환경 | D1 도구 오류 — 원장 V-e3ec9351 COLUMN / 원장 V-6a5a4553 COLUMN / 실측[T-f700a199]: QTY AS-IS 편집 기대(edit_expect) 없음 → 기계 판정 불가 — 수동 검수 대상(작업  |  | 1 (D00-2b-014) |
| WK-SSP0060-0687 | D1 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | D1 도구 오류 — 원장 V-4cb59511 COLUMN / 원장 V-cce3ba1a COLUMN / 실측[T-6fcddcc3]: 기존행 r0 SHIPMENT_CONFIRM_QTY: 현재 그리드에 없음 — 표시 여부는 A5 |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2865) |
| WK-SSP0060-0688 | D1 | SHIPMENT_STATUS / Status | 하네스·환경 | D1 도구 오류 — 원장 V-f3af1cd6 COLUMN / 원장 V-1598179f COLUMN / 실측[T-31403f25]: 기존행 r0 SHIPMENT_STATUS: 현재 그리드에 없음 — 표시 여부는 A5 |  | 3 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0689 | D1 | SSP0060_ShipmentPlan.EditButton | 하네스·환경 | D1 도구 오류 — 원장 V-0e96aba8 ASIS / 원장 V-d552911a ASIS |  | 46 (ACT:SSP0060_ShipmentPlan.EditButton:2714) |
| WK-SSP0060-0690 | D1 | TO_SITE / To Site | 하네스·환경 | D1 도구 오류 — 원장 V-bf517132 COLUMN / 원장 V-6efc35c8 COLUMN / 원장 V-383c6c9f COLUMN / 원장 V-fd6f10ef COLUMN / 실측[T-31bcacee]: 기존행 r0 TO_S |  | 5 (D00-2-004 I1-paste ACT:SSP0060_ShipmentP) |
| WK-SSP0060-0691 | D1 | siMain.LockColumn | 하네스·환경 | D1 도구 오류 — 원장 V-9aa65a05 |  | 1 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0692 | D1 | siMain.SwitchLock | 하네스·환경 | D1 도구 오류 — 원장 V-0e96aba8 |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0693 | D1 | 편집 불가(하늘색 Rc) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 편집 불가(하늘색 Rc) '확정구간 이전·이후 — `measureRowBackground` Rc(SHIP_PLAN_D' 의 D1 35요소: ERROR:20 · NA:15 |  | 1 (편집 불가(하늘색 Rc)) |
| WK-SSP0060-0694 | D3 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | D3 도구 오류 — 원장 V-f1876051 ASIS / 실측[T-dba47931]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / if (sStatu |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0695 | D3 | CHANGE_REASON_CODE,CHANGE_REASON_DETAIL | 하네스·환경 | D3 도구 오류 — 원장 V-f1876051 / 실측[T-63e59dca]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / if (sStatus ==  |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0696 | D3 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | D3 도구 오류 — 원장 V-fbee1743 ASIS / 원장 V-f1876051 ASIS / 실측[T-95e620b0]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode = |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton:2865) |
| WK-SSP0060-0697 | D3 | CHANGE_REQ_NO | 하네스·환경 | D3 도구 오류 — 원장 V-edecdc5f / 실측[T-a4f151f5]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatu |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0698 | D3 | CHANGE_REQ_NO / Change Request No | 하네스·환경 | D3 도구 오류 — 원장 V-edecdc5f ASIS / 실측[T-891fa2f9]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (s |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0699 | D3 | CRUD:EDIT | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 CRUD:EDIT '4가드 + 화이트리스트 잠금해제' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (CRUD:EDIT) |
| WK-SSP0060-0700 | D3 | D00-2-020 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-2-020 'SpdDetail_ComboSelChange' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-2-020) |
| WK-SSP0060-0701 | D3 | D00-2b-002 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-2b-002 'MSG00189 ERP C 편집차단' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-2b-002) |
| WK-SSP0060-0702 | D3 | D00-2b-017 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-2b-017 'MSG00251 SSP 사용자 체크' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-2b-017) |
| WK-SSP0060-0703 | D3 | D00-2b-018 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-2b-018 'MSG00170 이전 Plan 편집차단' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-2b-018) |
| WK-SSP0060-0704 | D3 | D00-2b-019 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-2b-019 'MSG00424 편집 Sheet 상이' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-2b-019) |
| WK-SSP0060-0705 | D3 | D00-2b-020 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-2b-020 'MSG00312 Real 아님(Detail)' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-2b-020) |
| WK-SSP0060-0706 | D3 | D00-3-019 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-019 'Main 수량 편집 반영+초과 Red' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-3-019) |
| WK-SSP0060-0707 | D3 | D00-3-022 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-022 'Insert 신규행 삽입·파생·잠금' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-3-022) |
| WK-SSP0060-0708 | D3 | D00-3-028 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-028 'Query/LockColumn 조회 바인딩 9건' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-3-028) |
| WK-SSP0060-0709 | D3 | D00-3-033 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-033 'Simulation 신규행·콤보·잠금' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-3-033) |
| WK-SSP0060-0710 | D3 | D00-4a-001 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4a-001 'EditButton(toolbarOverride)' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-4a-001) |
| WK-SSP0060-0711 | D3 | D00-4d-004 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4d-004 "sErpStatus=='C'" 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-4d-004) |
| WK-SSP0060-0712 | D3 | D00-4d-038 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4d-038 'EditButton isOK(사용자 체크)' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-4d-038) |
| WK-SSP0060-0713 | D3 | D00-4d-039~040 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4d-039~040 'EditButton PlanDate/EditSpread' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-4d-039~040) |
| WK-SSP0060-0714 | D3 | D00-4d-041~042 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-4d-041~042 'EditButton Detail 분기/RealFlag' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (D00-4d-041~042) |
| WK-SSP0060-0715 | D3 | DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-a4537ad1 / 실측[T-e5a77a92]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatu |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2763) |
| WK-SSP0060-0716 | D3 | DIVISION_ID / Div | 하네스·환경 | D3 도구 오류 — 원장 V-41637c04 ASIS / 원장 V-a4537ad1 ASIS / 원장 V-0e646631 ASIS / 원장 V-a4592d04 ASIS / 원장 V-47a2c3f5 ASIS / 원장 V-1972c890  |  | 10 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0717 | D3 | DIVISION_ID,FCST_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-0e646631 / 실측[T-7b736134]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatu |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2862) |
| WK-SSP0060-0718 | D3 | DIVISION_ID,FCST_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-1972c890 / 실측[T-c8eb8c99]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatu |  | 1 (ACT:SSP0060_ShipmentPlan.InsertRow:2696:) |
| WK-SSP0060-0719 | D3 | DIVISION_ID,HOLD_YYYYMMDD | 하네스·환경 | D3 도구 오류 — 원장 V-a4592d04 / 실측[T-b5889c7f]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatu |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2876) |
| WK-SSP0060-0720 | D3 | DIVISION_ID,HOLD_YYYYMMDD | 하네스·환경 | D3 도구 오류 — 원장 V-47a2c3f5 / 실측[T-ec1d0606]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatu |  | 1 (ACT:SSP0060_ShipmentPlan.InsertRow:2552:) |
| WK-SSP0060-0721 | D3 | DIVISION_ID,PRODUCT_LEVEL1 | 하네스·환경 | D3 도구 오류 — 원장 V-41637c04 / 실측[T-bed10c8b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatu |  | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0722 | D3 | ERP_STATUS / erp_status | 하네스·환경 | D3 도구 오류 — 실측[T-dacf1010]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatus == Shipment_St |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0723 | D3 | FCST_TYPE / FCST Type | 하네스·환경 | D3 도구 오류 — 원장 V-0e646631 ASIS / 원장 V-1972c890 ASIS / 실측[T-b066024b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode = |  | 7 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0724 | D3 | HOLD_YYYYMMDD / Start Date | 하네스·환경 | D3 도구 오류 — 원장 V-a4592d04 ASIS / 원장 V-47a2c3f5 ASIS / 실측[T-bcb05bb0]: HOLD_YYYYMMDD: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가 |  | 3 (ACT:SSP0060_ShipmentPlan.EditButton:2874) |
| WK-SSP0060-0725 | D3 | I1-delete | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 I1-delete 'spdMain_KeyUp(.cs L2462~2521 — 선택범위 D_ 셀 "0"+EditB' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (I1-delete) |
| WK-SSP0060-0726 | D3 | I2 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 I2 'SaveData_Main IsLock(shtMain)==false 가드(.cs L2935~' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (I2) |
| WK-SSP0060-0727 | D3 | I22 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 I22 'SpdDetail_ClipboardPasted 가드 5종(L1395~) — 잠금해제 셀 붙' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (I22) |
| WK-SSP0060-0728 | D3 | I9 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 I9 'Division/Company 변경 시 그리드 초기화(hook #5, np §5-5)' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (I9) |
| WK-SSP0060-0729 | D3 | LAST_UPDATED_BY / Last Updated By | 하네스·환경 | D3 도구 오류 — 원장 V-a943353f ASIS / 원장 V-bfec84fc ASIS / 실측[T-601de8d4]: LAST_UPDATED_BY: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton:2877) |
| WK-SSP0060-0730 | D3 | LAST_UPDATED_BY,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-a943353f / 실측[T-f909878c]: LAST_UPDATED_BY: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2877) |
| WK-SSP0060-0731 | D3 | LAST_UPDATE_DATE / Last Updated Date | 하네스·환경 | D3 도구 오류 — 원장 V-a943353f ASIS / 원장 V-bfec84fc ASIS / 실측[T-4c52c313]: LAST_UPDATE_DATE: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편 |  | 2 (ACT:SSP0060_ShipmentPlan.EditButton:2877) |
| WK-SSP0060-0732 | D3 | MKT_OWNER / MKT Owner | 하네스·환경 | D3 도구 오류 — 원장 V-84560a19 ASIS / 원장 V-486fafcc ASIS / 원장 V-eebef489 ASIS / 실측[T-8b72c01b]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미 |  | 4 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0733 | D3 | MKT_OWNER,ORIGIN_TO_DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-84560a19 / 실측[T-b28e2d24]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatu |  | 1 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0734 | D3 | MKT_OWNER,ORIGIN_TO_DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-486fafcc / 실측[T-edbe9df4]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatu |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2863) |
| WK-SSP0060-0735 | D3 | MKT_OWNER,ORIGIN_TO_DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-eebef489 / 실측[T-8e6d276f]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatu |  | 1 (ACT:SSP0060_ShipmentPlan.InsertRow:2697:) |
| WK-SSP0060-0736 | D3 | NEW-1 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 NEW-1 "공용 wrapper beginningEdit/pastingCell 이 메타 'S' 전건을 " 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (NEW-1) |
| WK-SSP0060-0737 | D3 | NEW_SHIPMENT_CONFIRM_QTY | 하네스·환경 | D3 도구 오류 — 실측[T-8d153cfa]: 팝업 내부 컬럼 NEW_SHIPMENT_CONFIRM_QTY — M3 시나리오 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0738 | D3 | NEW_SHIPMENT_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-12780782 ASIS / 실측[T-b93d50cd]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (s |  | 3 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0739 | D3 | NEW_SHIPMENT_DATE,NEW_SHIPMENT_CONFIRM_Q | 하네스·환경 | D3 도구 오류 — 원장 V-12780782 / 실측[T-3e94cb84]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatu |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0740 | D3 | ORIGIN_TO_DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-84560a19 ASIS / 원장 V-486fafcc ASIS / 원장 V-eebef489 ASIS / 실측[T-23cbce96]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미 |  | 4 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0741 | D3 | PRODUCT_LEVEL1 / Product Level1 | 하네스·환경 | D3 도구 오류 — 원장 V-41637c04 ASIS / 실측[T-41480df7]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (s |  | 2 (D00-2-004 ACT:SSP0060_ShipmentPlan.BtnNe) |
| WK-SSP0060-0742 | D3 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | D3 도구 오류 — 원장 V-fbee1743 ASIS / 실측[T-dcd8f914]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / if (sStatu |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2865) |
| WK-SSP0060-0743 | D3 | SHIPMENT_CONFIRM_QTY,CHANGE_REASON_DETAI | 하네스·환경 | D3 도구 오류 — 원장 V-fbee1743 / 실측[T-aac54ee6]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / if (sStatus ==  |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2865) |
| WK-SSP0060-0744 | D3 | SHIPMENT_STATUS / Status | 하네스·환경 | D3 도구 오류 — 실측[T-73158d90]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatus == Shipment_St |  | 3 (ACT:SSP0060_ShipmentPlan.EditButton ACT:) |
| WK-SSP0060-0745 | D3 | SSP0060_ShipmentPlan.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-14be8ba4 ASIS / 원장 V-a4537ad1 ASIS / 원장 V-4df7aad2 ASIS / 원장 V-df4c933f ASIS / 원장 V-a90a5dbc ASIS / 원장 V-b886b0b5  |  | 46 (ACT:SSP0060_ShipmentPlan.EditButton:2714) |
| WK-SSP0060-0746 | D3 | TO_SITE / To Site | 하네스·환경 | D3 도구 오류 — 실측[T-49a165aa]: 조건 계산 불가(검사기가 AS-IS 조건식을 행 값으로 풀지 못함 — 미검증): if (bEdit_Mode == false) / else of (sStatus == Shipment_St |  | 5 (D00-2-004 I1-paste ACT:SSP0060_ShipmentP) |
| WK-SSP0060-0747 | D3 | siDetail.LockRange2 | 하네스·환경 | D3 도구 오류 — 원장 V-3b703ac5 / 실측[T-b33f999b]: siDetail.LockRange2: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2870) |
| WK-SSP0060-0748 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-4df7aad2 / 실측[T-c45d1596]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2785) |
| WK-SSP0060-0749 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-df4c933f / 실측[T-700770b1]: siMain.LockRange: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2789) |
| WK-SSP0060-0750 | D3 | 편집 불가(하늘색 Rc) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 편집 불가(하늘색 Rc) '확정구간 이전·이후 — `measureRowBackground` Rc(SHIP_PLAN_D' 의 D3 44요소: ERROR:34 · NA:6 · PASS:4 |  | 1 (편집 불가(하늘색 Rc)) |
| WK-SSP0060-0751 | D4 | COMMON:UC-01 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터 유지(keepRowVisibleUnderFil' 의 D4 2요소: ERROR:2 |  | 1 (COMMON:UC-01) |
| WK-SSP0060-0752 | D4 | CRUD:INSERT | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 CRUD:INSERT 'HoldStock/PlanDetail 2원천' 의 D4 2요소: ERROR:2 |  | 1 (CRUD:INSERT) |
| WK-SSP0060-0753 | D4 | D00-3-022 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 D00-3-022 'Insert 신규행 삽입·파생·잠금' 의 D4 2요소: ERROR:2 |  | 1 (D00-3-022) |
| WK-SSP0060-0754 | D4 | D00-4a-005 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 D00-4a-005 'InsertButton' 의 D4 2요소: ERROR:2 |  | 1 (D00-4a-005) |
| WK-SSP0060-0755 | D4 | EDIT_MAIN | 하네스·환경 | D4 도구 오류 — 실측[T-35bfe162]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (D00-3-009) |
| WK-SSP0060-0756 | D4 | I3 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 I3 'InsertRow 두 분기 IsLock==false 가드(.cs L2539/L2558)' 의 D4 2요소: ERROR:2 |  | 1 (I3) |
| WK-SSP0060-0757 | D4 | ITEM_ID / Model | 하네스·환경 | D4 도구 오류 — 실측[T-7f929e84]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (Model(ITEM_ID) 그룹 경계 검정 실선) |
| WK-SSP0060-0758 | D4 | 음수 = 빨간 글자 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 음수 = 빨간 글자 '**이식**' 의 D4 2요소: ERROR:2 |  | 1 (음수 = 빨간 글자) |
| WK-SSP0060-0759 | D5 | COMMON:UC-05 | 하네스·환경 | D5 도구 오류 — 행 집계 — 대조표 COMMON:UC-05 'Excel Download 콤보 컬럼 Code 아닌 Name 출력' 의 D5 52요소: NA:38 · PASS:8 · ERROR:6 |  | 1 (COMMON:UC-05) |
| WK-SSP0060-0760 | D5 | DIFF_QTY | 하네스·환경 | D5 도구 오류 — 실측[T-dd40dced]: CHANGE_REQ_NO 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0761 | D5 | DIVISION_ID / Div | 하네스·환경 | D5 도구 오류 — 실측[T-15ba0b96]: DIVISION_ID: AS-IS COMBO(AS-IS 문장) ↔ TO-BE dataType=1 dataMap=N — 편집 불가 칸이라 입력 방식 차이 없음 · 표시 표본 [82] 을  |  | 5 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0762 | D5 | FCST_TYPE / FCST Type | 하네스·환경 | D5 도구 오류 — 원장 V-fe32a1e5 COLUMN / 원장 V-e4630d72 COLUMN / 실측[T-f37a2775]: FCST_TYPE: AS-IS COMBO(cell_rules) ↔ TO-BE dataType=0 dat |  | 10 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0763 | D5 | FROM_SITE_DESCRIPTION / From Site | 하네스·환경 | D5 도구 오류 — 실측[T-b3ab0f89]: FROM_SITE_DESCRIPTION: AS-IS COMBO(AS-IS 문장) ↔ TO-BE dataType=1 dataMap=N — 편집 불가 칸이라 입력 방식 차이 없음 · 표시  |  | 3 (ACT:SSP0060_ShipmentPlan.BtnNew_Click:74) |
| WK-SSP0060-0764 | D5 | NEW_SHIPMENT_CONFIRM_QTY | 하네스·환경 | D5 도구 오류 — 실측[T-526abeea]: CHANGE_REQ_NO 셀 위치 확인 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0765 | D5 | SSP0060_ShipmentPlan.CreateSpread | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.CreateSpread 의 D5 52요소: NA:38 · PASS:8 · ERROR:6 |  | 30 (ACT:SSP0060_ShipmentPlan.CreateSpread:56) |
| WK-SSP0060-0766 | D5 | SSP0060_ShipmentPlan.SetSpreadColumn | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SetSpreadColumn 의 D5 1요소: ERROR:1 |  | 1 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0767 | D5 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | D5 도구 오류 — 실측[T-1323dbd4]: TRANSPORT_MODE: AS-IS COMBO(AS-IS 문장) ↔ TO-BE dataType=0 dataMap=N — 편집 불가 칸이라 입력 방식 차이 없음 · 표시 표본 [TRK |  | 9 (ACT:SSP0060_ShipmentPlan.InitSpread ACT:) |
| WK-SSP0060-0768 | D6 | SSP0060 화면 | 하네스·환경 | D6 도구 오류 — 원장 V-8c2feea8 RULE_SCREEN / 원장 V-f7a0b8b2 RULE_SCREEN / 원장 V-c2428bce RULE_SCREEN / 원장 V-ad7983c6 GENERAL / 원장 V-99d61d |  | 9 (D00-3-022 D00-4a-005 CRUD:INSERT 음수 = 빨간) |
| WK-SSP0060-0769 | E1 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | E1 도구 오류 — 실측[T-3a30962c]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 8 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0770 | E1 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | E1 도구 오류 — 실측[T-af505d15]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0771 | E1 | ERP_SO_NO / SO No | 하네스·환경 | E1 도구 오류 — 실측[T-7b3b4ccd]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 13 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0772 | E1 | I22 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 I22 'SpdDetail_ClipboardPasted 가드 5종(L1395~) — 잠금해제 셀 붙' 의 E1 15요소: ERROR:9 · NA:6 |  | 1 (I22) |
| WK-SSP0060-0773 | E1 | NEW_SHIPMENT_CONFIRM_QTY | 하네스·환경 | E1 도구 오류 — 실측[T-e8624f88]: 팝업 내부 그리드 컬럼 NEW_SHIPMENT_CONFIRM_QTY — 메인 그리드 대상 아님. 팝업을 연 상태에서 검사(M3 시나리오) 필요 → 기계 판정 불가 — 수동 검수 대상(작 |  | 4 (ACT:SSP0060_ShipmentPlanRequestPopup.spd) |
| WK-SSP0060-0774 | E1 | REMARKS / Remarks | 하네스·환경 | E1 도구 오류 — 실측[T-99d14337]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0775 | E1 | SHIPMENT_CONFIRM_QTY / Shipment Qty | 하네스·환경 | E1 도구 오류 — 원장 V-0f84cd6c COLUMN / 실측[T-9fa5e029]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetai |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0776 | E1 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | E1 도구 오류 — 실측[T-5b09f4dd]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 9 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0777 | E1 | TO_SITE / To Site | 하네스·환경 | E1 도구 오류 — 실측[T-1d6d8ca1]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 3 (I1-paste ACT:SSP0060_ShipmentPlan.SpdMai) |
| WK-SSP0060-0778 | E1 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | E1 도구 오류 — 실측[T-78eb3da4]: [측정 경로 없음] 조회 후 Insert 했으나 신규행 없음 — AS-IS Insert 전제(InsertRow:2541 · if (siDetail != null && siDetail.I |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0779 | E1 | 음수 = 빨간 글자 | 하네스·환경 | E1 도구 오류 — 행 집계 — 대조표 음수 = 빨간 글자 '**이식**' 의 E1 15요소: ERROR:9 · NA:6 |  | 1 (음수 = 빨간 글자) |
| WK-SSP0060-0780 | E4 | CHANGE_REASON_CODE / Change Reason | 하네스·환경 | E4 도구 오류 — 원장 V-08bd5fee ASIS / 원장 V-c55e1e9c ASIS / 실측[T-9918eef5]: MSG00047 — SpdDetail_ClipboardPasted 경로 메시지(저장 전 검증 아님 · Save |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0781 | E4 | CHANGE_REASON_DETAIL / Reason Detail | 하네스·환경 | E4 도구 오류 — 원장 V-6ad0790f ASIS / 실측[T-183aecc7]: MSG00287 — SpdDetail_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 3 (D00-2b-004 ACT:SSP0060_ShipmentPlanConfi) |
| WK-SSP0060-0782 | E4 | ITEM_ID / Model | 하네스·환경 | E4 도구 오류 — 원장 V-7472fe36 ASIS / 원장 V-af4d8347 ASIS / 원장 V-b9f1e980 ASIS / 원장 V-0d660f19 ASIS / 원장 V-745476dd ASIS / 원장 V-38ae3cd9  |  | 12 (ACT:SSP0060_ShipmentPlan.SetEndCustomer ) |
| WK-SSP0060-0783 | E4 | MSG00007 | 하네스·환경 | E4 도구 오류 — 원장 V-49934161 ASIS / 원장 V-f391c6c6 ASIS / 실측[T-890f1644]: MSG00007 — BtnMeasure_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 |  | 3 (D00-2b-015~016 ACT:SSP0060_ShipmentPlan.) |
| WK-SSP0060-0784 | E4 | MSG00007 | 하네스·환경 | E4 도구 오류 — 원장 V-49934161 / 실측[T-6ff1d674]: MSG00007 — BtnMeasure_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnMeasu |  | 1 (ACT:SSP0060_ShipmentPlan.BtnMeasure_Clic) |
| WK-SSP0060-0785 | E4 | MSG00007 | 하네스·환경 | E4 도구 오류 — 원장 V-f391c6c6 / 실측[T-0bbb754f]: MSG00007 — BtnMeasure_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(BtnMeasu |  | 1 (ACT:SSP0060_ShipmentPlan.BtnMeasure_Clic) |
| WK-SSP0060-0786 | E4 | MSG00013 | 하네스·환경 | E4 도구 오류 — 원장 V-77ca1854 ASIS / 실측[T-bd27bc1f]: MSG00013 — SSP0060_ShipmentPlanRequestPopup_FormClosing 경로 메시지(저장 전 검증 아님 · Save 진 |  | 4 (D00-2b-006~008 D00-2b-009~012 D00-4d-019) |
| WK-SSP0060-0787 | E4 | MSG00013 | 하네스·환경 | E4 도구 오류 — 원장 V-77ca1854 / 실측[T-43ebce8a]: MSG00013 — SSP0060_ShipmentPlanRequestPopup_FormClosing 경로 메시지(저장 전 검증 아님 · Save 진입점에서  |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.SSP) |
| WK-SSP0060-0788 | E4 | MSG00047 | 하네스·환경 | E4 도구 오류 — 원장 V-62fca86d |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0789 | E4 | MSG00047 | 하네스·환경 | E4 도구 오류 — 원장 V-62fca86d ASIS / 실측[T-b90886cd]: MSG00047 — SpdDetail_ClipboardPasted 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Clipb) |
| WK-SSP0060-0790 | E4 | MSG00049 | 하네스·환경 | E4 도구 오류 — 원장 V-b9ea7588 ASIS / 원장 V-24e21001 ASIS / 원장 V-4e9a4976 ASIS / 실측[T-d4ee4c9f]: MSG00049: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류  |  | 3 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0791 | E4 | MSG00049 | 하네스·환경 | E4 도구 오류 — 원장 V-24e21001 / 실측[T-9a18c3a3]: MSG00049: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (DateTime.TryParse(s |  | 1 (ACT:SSP0060_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0060-0792 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-7472fe36 ASIS / 원장 V-af4d8347 ASIS / 원장 V-b9f1e980 ASIS / 원장 V-0d660f19 ASIS / 원장 V-745476dd ASIS / 원장 V-38ae3cd9  |  | 9 (D00-2b-006~008 D00-2b-009~012 ACT:SSP006) |
| WK-SSP0060-0793 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-7472fe36 / 실측[T-a37b349c]: MSG00098 — SpdDetail_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0794 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-af4d8347 / 실측[T-2da4d9c8]: MSG00098 — SpdDetail_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0795 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-b9f1e980 / 실측[T-150eb91c]: MSG00098 — SpdDetail_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0796 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-0d660f19 / 실측[T-cc1f3d2c]: MSG00098 — SpdDetail_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0797 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-745476dd / 실측[T-f2ca6e68]: MSG00098 — SpdDetail_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0798 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-38ae3cd9 / 실측[T-18df7a74]: MSG00098 — SpdDetail_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0799 | E4 | MSG00098 | 하네스·환경 | E4 도구 오류 — 원장 V-09cc01e6 / 실측[T-ec929f85]: MSG00098 — SpdDetail_CellDoubleClick 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0800 | E4 | MSG00170 | 하네스·환경 | E4 도구 오류 — 원장 V-2b418157 ASIS / 실측[T-a09192e2]: MSG00170 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButto |  | 2 (D00-2b-018 ACT:SSP0060_ShipmentPlan.Edit) |
| WK-SSP0060-0801 | E4 | MSG00170 | 하네스·환경 | E4 도구 오류 — 원장 V-2b418157 / 실측[T-4bb99bef]: MSG00170 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2732) |
| WK-SSP0060-0802 | E4 | MSG00189 | 하네스·환경 | E4 도구 오류 — 원장 V-3db66ec5 ASIS / 원장 V-99071c9e ASIS / 원장 V-8682ed2b ASIS / 실측[T-ea666759]: MSG00189: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류  |  | 4 (D00-2b-002 ACT:SSP0060_ShipmentPlan.GetS) |
| WK-SSP0060-0803 | E4 | MSG00189 | 하네스·환경 | E4 도구 오류 — 원장 V-99071c9e / 실측[T-100a0791]: MSG00189: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (ds.Tables[2].Rows.C |  | 1 (ACT:SSP0060_ShipmentPlan.shtDetail_Chang) |
| WK-SSP0060-0804 | E4 | MSG00197 | 하네스·환경 | E4 도구 오류 — 원장 V-7bbf2b85 ASIS / 원장 V-2d74edd3 ASIS / 원장 V-28d2d9f0 ASIS / 실측[T-458e337c]: MSG00197: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류  |  | 4 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0805 | E4 | MSG00197 | 하네스·환경 | E4 도구 오류 — 원장 V-2d74edd3 / 실측[T-cf0de450]: MSG00197: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (errConfirmList.Coun |  | 1 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0806 | E4 | MSG00204 | 하네스·환경 | E4 도구 오류 — 원장 V-7555eff5 ASIS / 원장 V-1b4807ba ASIS / 원장 V-6c3dd44d ASIS / 실측[T-6550a692]: MSG00204: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류  |  | 4 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0807 | E4 | MSG00204 | 하네스·환경 | E4 도구 오류 — 원장 V-1b4807ba / 실측[T-76a60117]: MSG00204: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (String.IsNullOrEmpt |  | 1 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0808 | E4 | MSG00247 | 하네스·환경 | E4 도구 오류 — 원장 V-6b18db80 ASIS / 원장 V-e377b154 ASIS / 원장 V-069a6456 ASIS / 실측[T-d60930d8]: MSG00247: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류  |  | 3 (ACT:SSP0060_ShipmentPlan.GetERPInterface) |
| WK-SSP0060-0809 | E4 | MSG00247 | 하네스·환경 | E4 도구 오류 — 원장 V-e377b154 / 실측[T-692a9b74]: MSG00247: 위반 입력 자동 생성 불가(검사기 한계 — 화면 오류 아님 · 수동 검수 W7) — guard 'if (iErpSoCnt != iSheet |  | 1 (ACT:SSP0060_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0060-0810 | E4 | MSG00251 | 하네스·환경 | E4 도구 오류 — 원장 V-19962dff ASIS / 실측[T-e53c55fd]: MSG00251 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButto |  | 2 (D00-2b-017 ACT:SSP0060_ShipmentPlan.Edit) |
| WK-SSP0060-0811 | E4 | MSG00251 | 하네스·환경 | E4 도구 오류 — 원장 V-19962dff / 실측[T-442991a9]: MSG00251 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2720) |
| WK-SSP0060-0812 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-13e2fa12 / 실측[T-fb98d11c]: MSG00275 — btnAutoSet_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btnAutoS |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.btn) |
| WK-SSP0060-0813 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-13e2fa12 ASIS / 실측[T-a3be7b39]: MSG00275 — btnAutoSet_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btn |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.btn) |
| WK-SSP0060-0814 | E4 | MSG00278 | 하네스·환경 | E4 도구 오류 — 원장 V-2b43a981 ASIS / 원장 V-9feba404 ASIS / 실측[T-e7161acd]: MSG00278 — SpdDetail_ComboSelChange 경로 메시지(저장 전 검증 아님 · Save  |  | 3 (D00-2b-003 ACT:SSP0060_ShipmentPlan.SpdD) |
| WK-SSP0060-0815 | E4 | MSG00278 | 하네스·환경 | E4 도구 오류 — 원장 V-2b43a981 / 실측[T-f9a25b1d]: MSG00278 — SpdDetail_ComboSelChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오( |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_Combo) |
| WK-SSP0060-0816 | E4 | MSG00278 | 하네스·환경 | E4 도구 오류 — 원장 V-9feba404 / 실측[T-8d127d91]: MSG00278 — SpdDetail_ComboSelChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오( |  | 1 (ACT:SSP0060_ShipmentPlan.shtDetail_Chang) |
| WK-SSP0060-0817 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-d3a12483 ASIS / 원장 V-c1b7ef9b ASIS / 원장 V-15566429 ASIS / 원장 V-24b8bda7 ASIS / 원장 V-4cb6b34c ASIS / 원장 V-7dad63b2  |  | 12 (D00-2b-023 D00-2b-028 ACT:SSP0060_Shipme) |
| WK-SSP0060-0818 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-d3a12483 |  | 1 (ACT:SSP0060_ShipmentPlan.NewNonSoNo:5019) |
| WK-SSP0060-0819 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-15566429 / 실측[T-cd89a4b2]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0060_ShipmentPlan.SaveData_Detail) |
| WK-SSP0060-0820 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-24b8bda7 / 실측[T-ab90da6c]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0060_ShipmentPlan.SaveData_Detail) |
| WK-SSP0060-0821 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-4cb6b34c / 실측[T-637a2400]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0060_ShipmentPlan.SaveData_Main:3) |
| WK-SSP0060-0822 | E4 | MSG00284 | 하네스·환경 | E4 도구 오류 — 원장 V-5019c7c4 / 실측[T-4c8fe709]: MSG00284 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Sav) |
| WK-SSP0060-0823 | E4 | MSG00287 | 하네스·환경 | E4 도구 오류 — 원장 V-6ad0790f ASIS / 실측[T-ef423e29]: MSG00287 — SpdDetail_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오 |  | 2 (D00-2b-004 ACT:SSP0060_ShipmentPlan.SpdD) |
| WK-SSP0060-0824 | E4 | MSG00287 | 하네스·환경 | E4 도구 오류 — 원장 V-6ad0790f / 실측[T-b62a98c1]: MSG00287 — SpdDetail_EditChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(SpdD |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_EditC) |
| WK-SSP0060-0825 | E4 | MSG00292 | 하네스·환경 | E4 도구 오류 — 원장 V-8e8410c7 ASIS / 실측[T-e07f5945]: MSG00292 — Simulation 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Simulatio |  | 2 (D00-2b-059 ACT:SSP0060_ShipmentPlan.Simu) |
| WK-SSP0060-0826 | E4 | MSG00292 | 하네스·환경 | E4 도구 오류 — 원장 V-8e8410c7 / 실측[T-38d42e36]: MSG00292 — Simulation 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(Simulation)에서  |  | 1 (ACT:SSP0060_ShipmentPlan.Simulation:7481) |
| WK-SSP0060-0827 | E4 | MSG00306 | 하네스·환경 | E4 도구 오류 — 원장 V-9c589130 / 실측[T-ffd546cd]: MSG00306 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetErpIFChe |  | 1 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0828 | E4 | MSG00306 | 하네스·환경 | E4 도구 오류 — 원장 V-9c589130 ASIS / 실측[T-91df6850]: MSG00306 — GetErpIFCheck 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(GetErp |  | 2 (ACT:SSP0060_ShipmentPlan.GetErpIFCheck:4) |
| WK-SSP0060-0829 | E4 | MSG00312 | 하네스·환경 | E4 도구 오류 — 원장 V-a1e3992e ASIS / 실측[T-defacc00]: MSG00312 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButto |  | 2 (D00-2b-020 ACT:SSP0060_ShipmentPlan.Edit) |
| WK-SSP0060-0830 | E4 | MSG00312 | 하네스·환경 | E4 도구 오류 — 원장 V-a1e3992e / 실측[T-674ec5c0]: MSG00312 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2842) |
| WK-SSP0060-0831 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-e7bdf428 ASIS / 원장 V-92fb0990 ASIS / 원장 V-e96be85b ASIS / 원장 V-3c4b1703 ASIS / 원장 V-0f963756 ASIS / 원장 V-fa7e78f7  |  | 7 (D00-2b-027 ACT:SSP0060_ShipmentPlan.NewN) |
| WK-SSP0060-0832 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-e7bdf428 |  | 1 (ACT:SSP0060_ShipmentPlan.NewNonSoNo:4996) |
| WK-SSP0060-0833 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-e96be85b / 실측[T-44ee0bb2]: MSG00324 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0060_ShipmentPlan.SaveData_Detail) |
| WK-SSP0060-0834 | E4 | MSG00324 | 하네스·환경 | E4 도구 오류 — 원장 V-0f963756 / 실측[T-6ead8c8b]: MSG00324 — NewNonSoNo 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(NewNonSoNo)에서  |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.Sav) |
| WK-SSP0060-0835 | E4 | MSG00424 | 하네스·환경 | E4 도구 오류 — 원장 V-45978bfb ASIS / 실측[T-cc98d10b]: MSG00424 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButto |  | 2 (D00-2b-019 ACT:SSP0060_ShipmentPlan.Edit) |
| WK-SSP0060-0836 | E4 | MSG00424 | 하네스·환경 | E4 도구 오류 — 원장 V-45978bfb / 실측[T-3414c78a]: MSG00424 — EditButton 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditButton)에서  |  | 1 (ACT:SSP0060_ShipmentPlan.EditButton:2738) |
| WK-SSP0060-0837 | E4 | MSG00425 | 하네스·환경 | E4 도구 오류 — 원장 V-fc9d478b ASIS / 실측[T-4e781806]: MSG00425 — EditByChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditByC |  | 2 (D00-2b-014 ACT:SSP0060_ShipmentPlan.Edit) |
| WK-SSP0060-0838 | E4 | MSG00425 | 하네스·환경 | E4 도구 오류 — 원장 V-fc9d478b / 실측[T-3b63c223]: MSG00425 — EditByChange 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(EditByChange |  | 1 (ACT:SSP0060_ShipmentPlan.EditByChange:21) |
| WK-SSP0060-0839 | E4 | PROJECT_CODE / Project Code | 하네스·환경 | E4 도구 오류 — 원장 V-0d660f19 ASIS / 원장 V-745476dd ASIS / 원장 V-38ae3cd9 ASIS / 원장 V-09cc01e6 ASIS / 실측[T-f96783c6]: MSG00098 — SpdDetai |  | 4 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0840 | E4 | SHIPMENT_DATE / Shipment Date | 하네스·환경 | E4 도구 오류 — 원장 V-b9ea7588 ASIS / 원장 V-24e21001 ASIS / 원장 V-62fca86d ASIS / 원장 V-6ad0790f ASIS / 원장 V-c55e1e9c ASIS / 실측[T-543203c3] |  | 3 (ACT:SSP0060_ShipmentPlan.GetNewERPInterf) |
| WK-SSP0060-0841 | E4 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | E4 도구 오류 — 원장 V-62fca86d ASIS / 원장 V-2b43a981 ASIS / 원장 V-9feba404 ASIS / 실측[T-719ac5f6]: MSG00047 — SpdDetail_ClipboardPasted 경로  |  | 4 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-0842 | E4 | cboChangeReason / Change Reason | 하네스·환경 | E4 도구 오류 — 실측[T-b79fca0c]: MSG00275 — btnAutoSet_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btnAutoSet_Click)에서 판정 → |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.btn) |
| WK-SSP0060-0843 | E4 | txtReasonDetail / Reason Detail | 하네스·환경 | E4 도구 오류 — 실측[T-8ea5eea6]: MSG00275 — btnAutoSet_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btnAutoSet_Click)에서 판정 → |  | 1 (ACT:SSP0060_ShipmentPlanRequestPopup.btn) |
| WK-SSP0060-0844 | A6 | DM0003_GET_BUCKET_TYPE_CODE | 하네스·환경 | A6 도구 오류 — 원장 V-412092cd SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-20cc8e7d]: DM0003_GET_BUCKET_TYPE_CODE: 화면  |  | 1 (D00-4-017) |
| WK-SSP0060-0845 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 하네스·환경 | A6 도구 오류 — 원장 V-00d80295 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측 순서대조 PASS 공통 19행(Doc/golden/SSP0060/SCP0009_GET_SHEET_CALENDAR_3SPAN.order |  | 583 (D00-4-028 ACT:SSP0060_ShipmentPlan.FindB) |
| WK-SSP0060-0846 | A6 | PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST | 하네스·환경 | A6 도구 오류 — 원장 V-d6a11f71 SP / 정렬대조 NA AS-IS·TO-BE 모두 ORDER BY 없음 — 그리드 비바인딩 룩업 SP(PROC_M / 실측[T-5acf89da]: PKG_SSP0002.P_SSP0002_G |  | 1 (D00-4-030) |
| WK-SSP0060-0847 | A6 | PKG_SSP0060.P_SSP0060_GET_HOLD_STOCK | 하네스·환경 | A6 도구 오류 — 원장 V-96d0de3c SP / 정렬대조 PASS AS-IS 에 없던 ORDER BY 를 TO-BE 가 추가 — 결정적 순서(TO-BE 룰  / 실측[T-0bd3f806]: PKG_SSP0060.P_SSP0060 |  | 59 (D00-4-024 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0848 | A6 | PKG_SSP0060.P_SSP0060_GET_MES_STOCK | 하네스·환경 | A6 도구 오류 — 원장 V-20f0fb0d SP / 정렬대조 NA AS-IS·TO-BE 모두 ORDER BY 없음 — 그리드 비바인딩 룩업 SP(PROC_M / 실측[T-b31ec25e]: PKG_SSP0060.P_SSP0060_G |  | 61 (D00-4-025 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0849 | A6 | PKG_SSP0060.P_SSP0060_GET_MES_STOCK_DETA | 하네스·환경 | A6 도구 오류 — 원장 V-49cf25e6 SP / 정렬대조 NA AS-IS·TO-BE 모두 ORDER BY 없음 — 그리드 비바인딩 룩업 SP(PROC_M / 실측[T-33ca6ca6]: PKG_SSP0060.P_SSP0060_G |  | 65 (D00-4-026 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0850 | A6 | PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL | 하네스·환경 | A6 도구 오류 — 원장 V-e574cb4d SP / 원장 V-e8cf3e45 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-cfe46b07]: PKG_SSP0060.P_SSP0060_GET_OWMS_DETAIL: 화면  |  | 61 (D00-4-021 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0851 | A6 | PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESUL | 하네스·환경 | A6 도구 오류 — 원장 V-86149586 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-9e404ba6]: PKG_SSP0060.P_SSP0060_GET_SHIPMENT_RESULT: 화면 진입·조회 경로에서 이 SP |  | 132 (D00-4-022~023 ACT:SSP0060_ShipmentPlan.F) |
| WK-SSP0060-0852 | A6 | PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION | 하네스·환경 | A6 도구 오류 — 원장 V-1535d206 SP / 원장 V-aa76efac SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-4b2fc5cf]: PKG_SSP0060.P_SSP0060_GET_STOCK_LOCATION_D |  | 61 (D00-4-020 ACT:SSP0060_ShipmentPlan.FindD) |
| WK-SSP0060-0853 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 '데이터 수정 중 다른 데이터 조회 시 confirm(MSG00704)' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (COMMON:UC-02) |
| WK-SSP0060-0854 | G1 | COMMON:UC-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼/Measure 설정 적용 시 기존 데이터 Reset 후 재조회' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (COMMON:UC-03) |
| WK-SSP0060-0855 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 콤마 다중 입력 전건 조회' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (COMMON:UC-06) |
| WK-SSP0060-0856 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 필터 유지(rebindFilterColumns)' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (COMMON:UC-07) |
| WK-SSP0060-0857 | G1 | CRUD:SEARCH | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 CRUD:SEARCH 'FindData_Main + Detail 8-sheet 조회' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (CRUD:SEARCH) |
| WK-SSP0060-0858 | G1 | D00-1-003 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-003 'btnItemID2 (2차 Model 팝업)' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-1-003) |
| WK-SSP0060-0859 | G1 | D00-1-004 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-004 'btnItemId (1차 Model 팝업)' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-1-004) |
| WK-SSP0060-0860 | G1 | D00-1-007 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-007 'btnRequestor' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-1-007) |
| WK-SSP0060-0861 | G1 | D00-1-008 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-1-008 'btnSearch (Detail 재조회)' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-1-008) |
| WK-SSP0060-0862 | G1 | D00-2-004 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-004 'BtnNew_Click' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-2-004) |
| WK-SSP0060-0863 | G1 | D00-2-006 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-006 'BtnSearch_Click' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-2-006) |
| WK-SSP0060-0864 | G1 | D00-2-011 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-011 'chkTotPSI_CheckedChanged' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-2-011) |
| WK-SSP0060-0865 | G1 | D00-2-012 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-012 'clbCompanyID_SelectedIndexChanged' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-2-012) |
| WK-SSP0060-0866 | G1 | D00-2-020 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-2-020 'SpdDetail_ComboSelChange' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-2-020) |
| WK-SSP0060-0867 | G1 | D00-3-014 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-014 '저장 후 강조색 리셋' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-3-014) |
| WK-SSP0060-0868 | G1 | D00-3-028 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-028 'Query/LockColumn 조회 바인딩 9건' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-3-028) |
| WK-SSP0060-0869 | G1 | D00-3-029 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-3-029 '조회 후 재병합·주석리셋·0치환' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-3-029) |
| WK-SSP0060-0870 | G1 | D00-4a-002 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-4a-002 'FindButton' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-4a-002) |
| WK-SSP0060-0871 | G1 | D00-4e-001 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-4e-001 'ItembyDivision(조회조건 2차)' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-4e-001) |
| WK-SSP0060-0872 | G1 | D00-4e-008 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D00-4e-008 'ItembyDivision(조회조건 1차)' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (D00-4e-008) |
| WK-SSP0060-0873 | G1 | I10 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 I10 'SpdMain_CellDoubleClick(.cs L2320~2381): MES=Detai' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (I10) |
| WK-SSP0060-0874 | G1 | I19 MSG 문구 역조회 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 I19 MSG 문구 역조회 '부분 적용' 의 G1 14요소: PASS:9 · ERROR:3 · NA:2 |  | 1 (I19 MSG 문구 역조회) |
| WK-SSP0060-0875 | G1 | clbProductLevel11 / Product Level1 / Pro | 하네스·환경 | G1 도구 오류 — 원장 V-da265f6e SEARCH / 원장 V-311dc011 SEARCH / 원장 V-81a8913c SEARCH / 원장 V-be3a7336 SEARCH / 원장 V-21f4fa52 SEARCH / 원장 V |  | 2 (ACT:SSP0060_ShipmentPlan.FindData_Main A) |
| WK-SSP0060-0876 | G1 | clbProductLevel12 / Product Level1 / Pro | 하네스·환경 | G1 도구 오류 — 원장 V-da265f6e SEARCH / 원장 V-311dc011 SEARCH / 원장 V-81a8913c SEARCH / 원장 V-be3a7336 SEARCH / 원장 V-21f4fa52 SEARCH / 원장 V |  | 16 (ACT:SSP0060_ShipmentPlan.FindData_Detail) |
| WK-SSP0060-0877 | G1 | txtBoxID / Box ID | 하네스·환경 | G1 도구 오류 — 원장 V-42299329 SEARCH / E2E smoke cond InputField |  | 2 (ACT:SSP0060_ShipmentPlan.FindData_MES_st) |
| WK-SSP0060-0878 | G6 | cboChangeReason / Change Reason | 하네스·환경 | G6 도구 오류 — 실측[T-c7952ab7]: 공용 팝업 내부 조건(cboChangeReason) — 팝업을 연 상태에서 확인 필요(팝업 내부 기능 M3 시나리오) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-0879 | X-ROW | SSP0060_ShipmentPlan.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · ERROR:1 |  | 1 (ACT:SSP0060_ShipmentPlan.CreateSpread) |
| WK-SSP0060-0880 | X-ROW | SSP0060_ShipmentPlan.DrpPeriod2_ValueCha | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOT_RUN:3 · NA:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0060_ShipmentPlan.DrpPeriod2_Valu) |
| WK-SSP0060-0881 | X-ROW | SSP0060_ShipmentPlan.FindButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — PASS:3 · ERROR:2 · REVIEW:1 |  | 1 (ACT:SSP0060_ShipmentPlan.FindButton) |
| WK-SSP0060-0882 | X-ROW | SSP0060_ShipmentPlan.FindData_MES_stock | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — PASS:9 · ERROR:5 · REVIEW:1 · NA:1 |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_MES_st) |
| WK-SSP0060-0883 | X-ROW | SSP0060_ShipmentPlan.FindData_MES_stock_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 17검사 — PASS:9 · ERROR:6 · REVIEW:1 · NA:1 |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_MES_st) |
| WK-SSP0060-0884 | X-ROW | SSP0060_ShipmentPlan.FindData_Main | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 20검사 — PASS:12 · NA:4 · ERROR:3 · REVIEW:1 |  | 8 (ACT:SSP0060_ShipmentPlan.FindData_Main:5) |
| WK-SSP0060-0885 | X-ROW | SSP0060_ShipmentPlan.FindData_Shipment_R | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 20검사 — PASS:11 · ERROR:5 · NA:3 · REVIEW:1 |  | 11 (ACT:SSP0060_ShipmentPlan.FindData_Shipme) |
| WK-SSP0060-0886 | X-ROW | SSP0060_ShipmentPlan.FindData_Stock_Deta | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — PASS:9 · ERROR:5 · REVIEW:1 · NA:1 |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_Stock_) |
| WK-SSP0060-0887 | X-ROW | SSP0060_ShipmentPlan.FindData_hold_stock | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — PASS:8 · ERROR:6 · REVIEW:1 · NA:1 |  | 10 (ACT:SSP0060_ShipmentPlan.FindData_hold_s) |
| WK-SSP0060-0888 | X-ROW | SSP0060_ShipmentPlan.FindData_oWMS_Detai | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — PASS:9 · ERROR:5 · REVIEW:1 · NA:1 |  | 5 (ACT:SSP0060_ShipmentPlan.FindData_oWMS_D) |
| WK-SSP0060-0889 | X-ROW | SSP0060_ShipmentPlan.GetErpSoNoCnt | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOPATH:2 · PASS:2 · ERROR:1 |  | 1 (ACT:SSP0060_ShipmentPlan.GetErpSoNoCnt) |
| WK-SSP0060-0890 | X-ROW | SSP0060_ShipmentPlan.GetNERPCode | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:2 · REVIEW:2 · NOPATH:2 · PASS:1 |  | 1 (ACT:SSP0060_ShipmentPlan.GetNERPCode) |
| WK-SSP0060-0891 | X-ROW | SSP0060_ShipmentPlan.GetSSPUserCheck | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — PASS:2 · NOPATH:2 · ERROR:1 |  | 1 (ACT:SSP0060_ShipmentPlan.GetSSPUserCheck) |
| WK-SSP0060-0892 | X-ROW | SSP0060_ShipmentPlan.InsertButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SSP0060_ShipmentPlan.InsertButton) |
| WK-SSP0060-0893 | X-ROW | SSP0060_ShipmentPlan.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 25검사 — ERROR:22 · NA:2 · PASS:1 |  | 123 (ACT:SSP0060_ShipmentPlan.InsertRow ACT:S) |
| WK-SSP0060-0894 | X-ROW | SSP0060_ShipmentPlan.Re_Design | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 64 (ACT:SSP0060_ShipmentPlan.Re_Design ACT:S) |
| WK-SSP0060-0895 | X-ROW | SSP0060_ShipmentPlan.SetChangeControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0060_ShipmentPlan.SetChangeContro) |
| WK-SSP0060-0896 | X-ROW | SSP0060_ShipmentPlan.SetChangedControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — PASS:6 · NA:4 · ERROR:2 |  | 3 (ACT:SSP0060_ShipmentPlan.SetChangedContr) |
| WK-SSP0060-0897 | X-ROW | SSP0060_ShipmentPlan.SetEndCustomer | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — ERROR:8 · NA:5 · NOPATH:3 |  | 3 (ACT:SSP0060_ShipmentPlan.SetEndCustomer:) |
| WK-SSP0060-0898 | X-ROW | SSP0060_ShipmentPlan.SetLockSumColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:1 · NA:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0060_ShipmentPlan.SetLockSumColum) |
| WK-SSP0060-0899 | X-ROW | SSP0060_ShipmentPlan.SetNote_Display | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 18검사 — ERROR:11 · NA:7 |  | 4 (ACT:SSP0060_ShipmentPlan.SetNote_Display) |
| WK-SSP0060-0900 | X-ROW | SSP0060_ShipmentPlan.SetSpreadColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — ERROR:8 · NA:4 · PASS:3 · NOT_RUN:1 |  | 7 (ACT:SSP0060_ShipmentPlan.SetSpreadColumn) |
| WK-SSP0060-0901 | X-ROW | SSP0060_ShipmentPlan.Set_SumValues | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0060_ShipmentPlan.Set_SumValues A) |
| WK-SSP0060-0902 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_ActiveShe | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 67 (ACT:SSP0060_ShipmentPlan.SpdDetail_Activ) |
| WK-SSP0060-0903 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_CellClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 18검사 — ERROR:12 · NOPATH:4 · PASS:2 |  | 58 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0904 | X-ROW | SSP0060_ShipmentPlan.SpdDetail_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_TopCh) |
| WK-SSP0060-0905 | X-ROW | SSP0060_ShipmentPlan.SpdMain_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SSP0060_ShipmentPlan.SpdMain_TopChan) |
| WK-SSP0060-0906 | X-ROW | SSP0060_ShipmentPlan.cboBucketType_Selec | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.cboBucketType_S) |
| WK-SSP0060-0907 | X-ROW | SSP0060_ShipmentPlan.cboPlanDate_Selecte | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:6 · NA:3 |  | 4 (ACT:SSP0060_ShipmentPlan.cboPlanDate_Sel) |
| WK-SSP0060-0908 | X-ROW | SSP0060_ShipmentPlan.chkSum_CheckedChang | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.chkSum_CheckedC) |
| WK-SSP0060-0909 | X-ROW | SSP0060_ShipmentPlan.chkTotPSI_CheckedCh | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0060_ShipmentPlan.chkTotPSI_Check) |
| WK-SSP0060-0910 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.. | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOPATH:1 · ERROR:1 |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0911 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.C | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0912 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.D | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 2 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0913 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.D | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0914 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.F | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 8 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0915 | X-ROW | SSP0060_ShipmentPlanConfirmDetailPopup.S | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — NA:6 · ERROR:6 |  | 13 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0916 | X-ROW | SSP0060_ShipmentPlanRequestPopup..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOPATH:1 · ERROR:1 |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup..ct) |
| WK-SSP0060-0917 | X-ROW | SSP0060_ShipmentPlanRequestPopup.CalcPla | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 6 (ACT:SSP0060_ShipmentPlanRequestPopup.Cal) |
| WK-SSP0060-0918 | X-ROW | SSP0060_ShipmentPlanRequestPopup.ChkConf | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:1 · NOT_RUN:1 · NOPATH:1 · PASS:1 |  | 12 (ACT:SSP0060_ShipmentPlanRequestPopup.Chk) |
| WK-SSP0060-0919 | X-ROW | SSP0060_ShipmentPlanRequestPopup.CopyFro | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 19 (ACT:SSP0060_ShipmentPlanRequestPopup.Cop) |
| WK-SSP0060-0920 | X-ROW | SSP0060_ShipmentPlanRequestPopup.CreateS | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:SSP0060_ShipmentPlanRequestPopup.Cre) |
| WK-SSP0060-0921 | X-ROW | SSP0060_ShipmentPlanRequestPopup.DefineP | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Def) |
| WK-SSP0060-0922 | X-ROW | SSP0060_ShipmentPlanRequestPopup.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:SSP0060_ShipmentPlanRequestPopup.Dis) |
| WK-SSP0060-0923 | X-ROW | SSP0060_ShipmentPlanRequestPopup.EditBut | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — ERROR:14 · NA:2 |  | 15 (ACT:SSP0060_ShipmentPlanRequestPopup.Edi) |
| WK-SSP0060-0924 | X-ROW | SSP0060_ShipmentPlanRequestPopup.Form_Lo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 8 (ACT:SSP0060_ShipmentPlanRequestPopup.For) |
| WK-SSP0060-0925 | X-ROW | SSP0060_ShipmentPlanRequestPopup.GetErpI | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NA:2 · ERROR:2 · PASS:2 |  | 17 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0926 | X-ROW | SSP0060_ShipmentPlanRequestPopup.GetErpI | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:1 · NOPATH:1 · PASS:1 · ERROR:1 |  | 111 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0927 | X-ROW | SSP0060_ShipmentPlanRequestPopup.GetErpS | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — PASS:2 · ERROR:2 |  | 13 (ACT:SSP0060_ShipmentPlanRequestPopup.Get) |
| WK-SSP0060-0928 | X-ROW | SSP0060_ShipmentPlanRequestPopup.InitCon | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:2 · PASS:1 · NOT_RUN:1 |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.Ini) |
| WK-SSP0060-0929 | X-ROW | SSP0060_ShipmentPlanRequestPopup.RowSave | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 4 (ACT:SSP0060_ShipmentPlanRequestPopup.Row) |
| WK-SSP0060-0930 | X-ROW | SSP0060_ShipmentPlanRequestPopup.spdMain | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SSP0060_ShipmentPlanRequestPopup.spd) |
| WK-SSP0060-0931 | G5 | CHANGE_REQ_NO / Change Request No | 하네스·환경 | G5 도구 오류 — 원장 V-3d0e0e58 ASIS / 원장 V-d6c15ca0 ASIS |  | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0932 | G5 | D00-2-024 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-2-024 'SpdMain_CellDoubleClick' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (D00-2-024) |
| WK-SSP0060-0933 | G5 | D00-2b-006~008 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-2b-006~008 'MSG00098 Item 팝업 필수 3종' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (D00-2b-006~008) |
| WK-SSP0060-0934 | G5 | D00-2b-009~012 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-2b-009~012 'MSG00098 Project 팝업 필수 4종' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (D00-2b-009~012) |
| WK-SSP0060-0935 | G5 | D00-3-016 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-3-016 'Project 팝업 결과 반영' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (D00-3-016) |
| WK-SSP0060-0936 | G5 | D00-4d-019~030 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4d-019~030 "CellDoubleClick 가드 12종(sheet/컬럼/action='I'/필수값)" 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PAS |  | 1 (D00-4d-019~030) |
| WK-SSP0060-0937 | G5 | D00-4e-001 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4e-001 'ItembyDivision(조회조건 2차)' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (D00-4e-001) |
| WK-SSP0060-0938 | G5 | D00-4e-002 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4e-002 'ItembyDivision(Detail 셀)' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (D00-4e-002) |
| WK-SSP0060-0939 | G5 | D00-4e-003 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4e-003 'ProjectbyDivision(Detail 셀)' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (D00-4e-003) |
| WK-SSP0060-0940 | G5 | D00-4e-005 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4e-005 'ShipmentPlanConfirmDetailPopup' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (D00-4e-005) |
| WK-SSP0060-0941 | G5 | D00-4e-006 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4e-006 'TitleSetForm(Measure)' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (D00-4e-006) |
| WK-SSP0060-0942 | G5 | D00-4e-007 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4e-007 'UserInfoPopup(Requestor)' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (D00-4e-007) |
| WK-SSP0060-0943 | G5 | D00-4e-008 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4e-008 'ItembyDivision(조회조건 1차)' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (D00-4e-008) |
| WK-SSP0060-0944 | G5 | D00-4e-009~021 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4e-009~021 'ProgressForm ×12 + Request' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (D00-4e-009~021) |
| WK-SSP0060-0945 | G5 | I10 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 I10 'SpdMain_CellDoubleClick(.cs L2320~2381): MES=Detai' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (I10) |
| WK-SSP0060-0946 | G5 | I12 Requestor 팝업 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 I12 Requestor 팝업 '이미구현' 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 1 (I12 Requestor 팝업) |
| WK-SSP0060-0947 | G5 | SSP0060_ShipmentPlan.SpdMain_CellDoubleC | 하네스·환경 | G5 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SpdMain_CellDoubleClick 의 G5 35요소: NA:20 · ERROR:9 · NOPATH:5 · PASS:1 |  | 3 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-0948 | G5 | SSP0060_ShipmentPlanConfirmDetailPopup | 하네스·환경 | G5 도구 오류 — 원장 V-3d0e0e58 ASIS |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0949 | G5 | SSP0060_ShipmentPlanRequestPopup | 하네스·환경 | G5 도구 오류 — 원장 V-3b3c5894 ASIS |  | 3 (MODAL:ShipmentRequestModal ACT:SSP0060_S) |
| WK-SSP0060-0950 | G5 | new SSP0060_ShipmentPlanConfirmDetailPop | 하네스·환경 | G5 도구 오류 — 원장 V-3d0e0e58 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0951 | G5 | new SSP0060_ShipmentPlanRequestPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-3b3c5894 |  | 1 (ACT:SSP0060_ShipmentPlan.SaveData_Main:3) |
| WK-SSP0060-0952 | G5 | new UserInfoPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-191272a2 |  | 1 (ACT:SSP0060_ShipmentPlan.BtnRequestor_Cl) |
| WK-SSP0060-0953 | G5 | pop.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-6071d4dc |  | 1 (ACT:SSP0060_ShipmentPlan.SaveData_Main:3) |
| WK-SSP0060-0954 | G5 | pop.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-d6c15ca0 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0955 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-b05380a1 |  | 1 (ACT:SSP0060_ShipmentPlan.BtnRequestor_Cl) |
| WK-SSP0060-0956 | H6 | CHANGE_REQ_NO / Change Request No | 하네스·환경 | H6 도구 오류 — 원장 V-549da012 ASIS / 원장 V-f9075de1 ASIS |  | 2 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0957 | H6 | D00-2-024 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-2-024 'SpdMain_CellDoubleClick' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (D00-2-024) |
| WK-SSP0060-0958 | H6 | D00-2b-006~008 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-2b-006~008 'MSG00098 Item 팝업 필수 3종' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (D00-2b-006~008) |
| WK-SSP0060-0959 | H6 | D00-2b-009~012 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-2b-009~012 'MSG00098 Project 팝업 필수 4종' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (D00-2b-009~012) |
| WK-SSP0060-0960 | H6 | D00-3-016 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-3-016 'Project 팝업 결과 반영' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (D00-3-016) |
| WK-SSP0060-0961 | H6 | D00-4d-019~030 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4d-019~030 "CellDoubleClick 가드 12종(sheet/컬럼/action='I'/필수값)" 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · N |  | 1 (D00-4d-019~030) |
| WK-SSP0060-0962 | H6 | D00-4e-001 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4e-001 'ItembyDivision(조회조건 2차)' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (D00-4e-001) |
| WK-SSP0060-0963 | H6 | D00-4e-002 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4e-002 'ItembyDivision(Detail 셀)' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (D00-4e-002) |
| WK-SSP0060-0964 | H6 | D00-4e-003 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4e-003 'ProjectbyDivision(Detail 셀)' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (D00-4e-003) |
| WK-SSP0060-0965 | H6 | D00-4e-005 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4e-005 'ShipmentPlanConfirmDetailPopup' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (D00-4e-005) |
| WK-SSP0060-0966 | H6 | D00-4e-006 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4e-006 'TitleSetForm(Measure)' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (D00-4e-006) |
| WK-SSP0060-0967 | H6 | D00-4e-007 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4e-007 'UserInfoPopup(Requestor)' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (D00-4e-007) |
| WK-SSP0060-0968 | H6 | D00-4e-008 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4e-008 'ItembyDivision(조회조건 1차)' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (D00-4e-008) |
| WK-SSP0060-0969 | H6 | D00-4e-009~021 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 D00-4e-009~021 'ProgressForm ×12 + Request' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (D00-4e-009~021) |
| WK-SSP0060-0970 | H6 | ERP_SO_NO / SO No | 하네스·환경 | H6 도구 오류 — 원장 V-31a723b2 ASIS / 원장 V-44e4fb41 ASIS / 원장 V-3c25f582 ASIS |  | 5 (D00-2-018 MODAL:OrderDetailPopup ACT:SSP) |
| WK-SSP0060-0971 | H6 | I10 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 I10 'SpdMain_CellDoubleClick(.cs L2320~2381): MES=Detai' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (I10) |
| WK-SSP0060-0972 | H6 | I12 Requestor 팝업 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 I12 Requestor 팝업 '이미구현' 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 1 (I12 Requestor 팝업) |
| WK-SSP0060-0973 | H6 | ITEM_ID / Model | 하네스·환경 | H6 도구 오류 — 원장 V-7dfa6b54 ASIS / 원장 V-32025616 ASIS / 원장 V-bdb70cf8 ASIS / 원장 V-69a7205e ASIS / 원장 V-b04258c3 ASIS / 원장 V-43bb1fe5  |  | 79 (D00-2-018 D00-3-015 ACT:SSP0060_Shipment) |
| WK-SSP0060-0974 | H6 | PROJECT_CODE / Project Code | 하네스·환경 | H6 도구 오류 — 원장 V-69a7205e ASIS / 원장 V-b04258c3 ASIS / 원장 V-43bb1fe5 ASIS / 원장 V-31a723b2 ASIS / 원장 V-44e4fb41 ASIS / 원장 V-3c25f582  |  | 47 (D00-2-018 ACT:SSP0060_ShipmentPlan.SpdDe) |
| WK-SSP0060-0975 | H6 | SSP0060_ShipmentPlan.SpdMain_CellDoubleC | 하네스·환경 | H6 도구 오류 — 진입점 집계 — 대조표 SSP0060_ShipmentPlan.SpdMain_CellDoubleClick 의 H6 35요소: ERROR:24 · NOPATH:5 · PASS:5 · NA:1 |  | 3 (ACT:SSP0060_ShipmentPlan.SpdMain_CellDou) |
| WK-SSP0060-0976 | H6 | SSP0060_ShipmentPlanConfirmDetailPopup | 하네스·환경 | H6 도구 오류 — 원장 V-549da012 ASIS |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0977 | H6 | SSP0060_ShipmentPlanRequestPopup | 하네스·환경 | H6 도구 오류 — 원장 V-1a082f44 ASIS |  | 3 (MODAL:ShipmentRequestModal ACT:SSP0060_S) |
| WK-SSP0060-0978 | H6 | btnItemId | 하네스·환경 | H6 도구 오류 — 원장 V-bbe8bac7 ASIS / 원장 V-77d1073e ASIS / 원장 V-6236c33f ASIS |  | 1 (D00-1-004) |
| WK-SSP0060-0979 | H6 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-84102e69 |  | 1 (ACT:SSP0060_ShipmentPlan.BtnItemID2_Clic) |
| WK-SSP0060-0980 | H6 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-7dfa6b54 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0981 | H6 | new SCM0002_ItembyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-bbe8bac7 |  | 1 (ACT:SSP0060_ShipmentPlan.btnItemId_Click) |
| WK-SSP0060-0982 | H6 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-69a7205e |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0983 | H6 | new SSP0060_ShipmentPlanConfirmDetailPop | 하네스·환경 | H6 도구 오류 — 원장 V-549da012 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0984 | H6 | new SSP0060_ShipmentPlanRequestPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-1a082f44 |  | 1 (ACT:SSP0060_ShipmentPlan.SaveData_Main:3) |
| WK-SSP0060-0985 | H6 | new SSP0300_OrderDetailPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-31a723b2 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0986 | H6 | pop.Form_Load(_DivisionID, _ErpSoNo, _Co | 하네스·환경 | H6 도구 오류 — 원장 V-44e4fb41 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0987 | H6 | pop.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-d391ea87 |  | 1 (ACT:SSP0060_ShipmentPlan.SaveData_Main:3) |
| WK-SSP0060-0988 | H6 | pop.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-f9075de1 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-0989 | H6 | pop.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-3c25f582 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0990 | H6 | popItem.Form_Load(false, sdivision, sScm | 하네스·환경 | H6 도구 오류 — 원장 V-32025616 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0991 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-064590d2 |  | 1 (ACT:SSP0060_ShipmentPlan.BtnItemID2_Clic) |
| WK-SSP0060-0992 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-bdb70cf8 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0993 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-6236c33f |  | 1 (ACT:SSP0060_ShipmentPlan.btnItemId_Click) |
| WK-SSP0060-0994 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-b04258c3 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0995 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-43bb1fe5 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0996 | M3 | SSP0060_ShipmentPlanConfirmDetailPopup | 하네스·환경 | M3 도구 오류 — 원장 V-03cf0069 ASIS / 실측[T-fa68b1e1]: 팝업을 여는 트리거 셀을 화면 메타에서 찾지 못함 — 팝업 내부 기능 검사 대상 미확정(수동 검수 W7) |  | 10 (ACT:SSP0060_ShipmentPlanConfirmDetailPop) |
| WK-SSP0060-0997 | M3 | SSP0060_ShipmentPlanRequestPopup | 하네스·환경 | M3 도구 오류 — 원장 V-11dbefa8 ASIS / 실측[T-608f6451]: 팝업을 여는 트리거 셀을 화면 메타에서 찾지 못함 — 팝업 내부 기능 검사 대상 미확정(수동 검수 W7) |  | 34 (ACT:SSP0060_ShipmentPlanRequestPopup..ct) |
| WK-SSP0060-0998 | M3 | new SCM0002_ProjectbyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-a5c9a256 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
| WK-SSP0060-0999 | M3 | new SSP0060_ShipmentPlanConfirmDetailPop | 하네스·환경 | M3 도구 오류 — 원장 V-03cf0069 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellC) |
| WK-SSP0060-1000 | M3 | new SSP0060_ShipmentPlanRequestPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-11dbefa8 |  | 1 (ACT:SSP0060_ShipmentPlan.SaveData_Main:3) |
| WK-SSP0060-1001 | M3 | new SSP0300_OrderDetailPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-60adeef3 |  | 1 (ACT:SSP0060_ShipmentPlan.SpdDetail_CellD) |
