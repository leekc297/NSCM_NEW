# 작업 원장 — SCP0006 · 2026-10-26 12:52

> 검사 인스턴스 472건 중 PASS·NA 42건 외 **430건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 2 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 31 | 구현 위치 실존 |
| W4 | 검사기 구현 | 4 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 24 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 139 | 실행 → PASS |
| W7 | 기대값 확정 | 225 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 5 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 225 · E2E 139 · 대조표 31 · 하네스 28 · 선행 W1 완료 후 E2E 4 · FE 2 · 선행 W1 완료 후 검증 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 9건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 55 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 32 | 19 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-LOC | GEN |  | 31 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| H2 | DESIGN |  |  |  |  |  | 10 | 17 | 1 |  | 배경·글자색 규칙 |
| A1 | GEN |  |  |  |  |  |  | 25 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A5 | DESIGN |  |  |  |  |  | 5 | 18 | 1 |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 5 | 17 | 1 |  | 라벨 명칭 |
| C3 | CASCADE |  |  |  |  |  | 12 | 8 |  |  | 연쇄 자동 채움 |
| G1 | GEN |  |  |  |  |  | 6 | 10 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| M4 | POPUP |  |  |  |  |  | 10 | 6 |  |  | 팝업 선택값 반영 |
| F4 | DB |  |  |  |  |  | 6 | 7 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G4 | DESIGN |  |  |  |  | 3 | 6 | 2 |  |  | 조회조건 표시·라벨·활성 |
| D1 | EDIT |  |  |  |  |  | 7 | 4 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 7 | 4 |  |  | 행 값 기반 조건부 잠금 |
| DB-SYN | DB |  |  |  |  | 5 |  | 5 |  |  | BE 계정 시노님·권한·대상 객체 |
| B3 | COMBO |  |  |  | 4 |  |  | 5 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 4 |  | 5 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A6 | GEN |  |  |  |  |  | 6 | 3 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G5 | POPUP |  |  |  |  | 2 |  | 6 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 | 1 | 6 |  |  | 팝업 표준·열림 |
| G6 | GEN |  |  |  |  |  | 6 | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| D5 | EDIT |  |  |  |  |  | 6 | 1 |  |  | 셀 에디터 유형 |
| C1 | CASCADE |  |  |  |  |  | 3 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| X-NOTIMPL | GEN | 2 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| B1 | COMBO |  |  |  |  | 2 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 2 |  |  |  |  | 콤보 후보 중복 없음 |
| E5 | EDIT |  |  |  |  | 2 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| E3 | EDIT |  |  |  |  |  |  |  | 2 |  | 필수 입력 검증 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W1 기능 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0006-0001 | X-NOTIMPL | MSG00226 (N0) | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — MSG00226 (N0) 외주 PACKER 미구현 — AS-IS 자체가 dead code라 정합(§R-OS-DEAD 참고) |  | 1 (MSG00226 (N0)) |
| WK-SCP0006-0002 | X-NOTIMPL | R-OSCLR 외주 PACKER 클리어(MSG00226) | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — R-OSCLR 외주 PACKER 클리어(MSG00226) L1321-1356 미구현 — **AS-IS 자체가 dead code라 정합**(design/03 §3 R-OS-DEAD 확정, 2026-09-21  |  | 1 (R-OSCLR 외주 PACKER 클리어(MSG00226)) |

## W2 구현 위치 확인 (31)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0006-0003 | X-LOC | A2 spdSite_CellDoubleClick → BOM 조회 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A2 spdSite_CellDoubleClick → BOM 조회) |
| WK-SCP0006-0004 | X-LOC | A3 spdBOM_CellDoubleClick → Plant 조회 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A3 spdBOM_CellDoubleClick → Plant 조회) |
| WK-SCP0006-0005 | X-LOC | A5 spdPlant_CellDoubleClick → CAPA(SCP00 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A5 spdPlant_CellDoubleClick → CAPA(SCP00) |
| WK-SCP0006-0006 | X-LOC | A6 spdPlant_Change FROM/TO → ORG/MERGE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A6 spdPlant_Change FROM/TO → ORG/MERGE) |
| WK-SCP0006-0007 | X-LOC | COMMON:UC-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0008 | X-LOC | Delete 'I'행만 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Delete 'I'행만) |
| WK-SCP0006-0009 | X-LOC | MSG00101~110·48 (N1~N9) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00101~110·48 (N1~N9)) |
| WK-SCP0006-0010 | X-LOC | MSG00109 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00109) |
| WK-SCP0006-0011 | X-LOC | MSG00116 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00116) |
| WK-SCP0006-0012 | X-LOC | MSG00133 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00133) |
| WK-SCP0006-0013 | X-LOC | R-DYN Div 82/40 컬럼 visible | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-DYN Div 82/40 컬럼 visible) |
| WK-SCP0006-0014 | X-LOC | R-EDIT/R-INS-LOCK 편집 5컬럼만 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-EDIT/R-INS-LOCK 편집 5컬럼만) |
| WK-SCP0006-0015 | X-LOC | R-INS-DEF 신규행 기본값 5종 + MSG00116 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-INS-DEF 신규행 기본값 5종 + MSG00116) |
| WK-SCP0006-0016 | X-LOC | R11 PLANT_PER_ITEM=nInput/nTot | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R11 PLANT_PER_ITEM=nInput/nTot) |
| WK-SCP0006-0017 | X-LOC | R2 Division 82/40 → Project clear·disabl | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R2 Division 82/40 → Project clear·disabl) |
| WK-SCP0006-0018 | X-LOC | R3 그 외 division → Project enable | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R3 그 외 division → Project enable) |
| WK-SCP0006-0019 | X-LOC | R4 clbSalesSite 항상 ALL·비활성(선택값), 후보목록은 d | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R4 clbSalesSite 항상 ALL·비활성(선택값), 후보목록은 d) |
| WK-SCP0006-0020 | X-LOC | R5 btnAllFind Input All | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R5 btnAllFind Input All) |
| WK-SCP0006-0021 | X-LOC | Save SAVE_PLANT ^-delim | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Save SAVE_PLANT ^-delim) |
| WK-SCP0006-0022 | X-LOC | SetCalendar 동적 월 컬럼 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetCalendar 동적 월 컬럼) |
| WK-SCP0006-0023 | X-LOC | cboDivision (`BLUtils.GetDivisionWithout | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0006-0024 | X-LOC | cboStatus (YesOrNo) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboStatus (YesOrNo)) |
| WK-SCP0006-0025 | X-LOC | clbSalesSite (死필터) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbSalesSite (死필터)) |
| WK-SCP0006-0026 | X-LOC | dead: GET_DATE_RANGE_1MONTH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (dead: GET_DATE_RANGE_1MONTH) |
| WK-SCP0006-0027 | X-LOC | drpPeriod (월범위, PERIOD_DEFAULT+11M) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (drpPeriod (월범위, PERIOD_DEFAULT+11M)) |
| WK-SCP0006-0028 | X-LOC | spdBOM(siBOM, read-only) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdBOM(siBOM, read-only)) |
| WK-SCP0006-0029 | X-LOC | spdMain(siSite, read-only) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain(siSite, read-only)) |
| WK-SCP0006-0030 | X-LOC | spdPlant(siPlant, 편집) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdPlant(siPlant, 편집)) |
| WK-SCP0006-0031 | X-LOC | txtItemId + btnItemId (Model) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0006-0032 | X-LOC | txtProject + btnProject (Project) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtProject + btnProject (Project)) |
| WK-SCP0006-0033 | X-LOC | usrConditionPanel1(HidePanel) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrConditionPanel1(HidePanel)) |

## W4 검사기 구현 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0006-0034 | B3 | PLANT_SITE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0006-0035 | B3 | VALID_YN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0006-0036 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 2 (cboDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0006-0037 | B3 | drpPeriod / Period | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 drpPeriod / Period | 있음(FE 소스) | 1 (ACT:SCP0006_ProjectRoute.SetCalendar:419) |

## W5 검사기 연결 (24)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0006-0038 | B1 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0006-0039 | B1 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0006-0040 | B2 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0006-0041 | B2 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0006-0042 | B4 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0006-0043 | B4 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0006-0044 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (cboDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0006-0045 | B4 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 1 (ACT:SCP0006_ProjectRoute.SetCalendar:419) |
| WK-SCP0006-0046 | F2 | SCP0006 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0006 화면 | 판단불가(대상 단위 SCREEN) | 19 (Save SAVE_PLANT ^-delim MSG00133 MSG0010) |
| WK-SCP0006-0047 | F6 | SCP0006 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0006 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:SCP0006_ProjectRoute.SaveButton ACT:) |
| WK-SCP0006-0048 | DB-SYN | PKG_SCP0006 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SCP0006 | 없음(PROC_M 대응 없음) | 1 (COMMON:UC-06) |
| WK-SCP0006-0049 | DB-SYN | P_ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_ITEM_ID | 없음(PROC_M 대응 없음) | 1 (COMMON:UC-06) |
| WK-SCP0006-0050 | DB-SYN | P_PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_PROJECT_CODE | 없음(PROC_M 대응 없음) | 1 (COMMON:UC-06) |
| WK-SCP0006-0051 | DB-SYN | P_SPLIT_LIST | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SPLIT_LIST | 없음(PROC_M 대응 없음) | 1 (COMMON:UC-06) |
| WK-SCP0006-0052 | DB-SYN | SCP0006_GET_PROJECT_ROUTE_SITE_82 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0006_GET_PROJECT_ROUTE_SITE_82 | 없음(PROC_M 대응 없음) | 1 (ACT:SCP0006_ProjectRoute.FindDataSite:74) |
| WK-SCP0006-0053 | G4 | btnAllFind | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnAllFind | 있음(FE 소스) | 2 (ACT:SCP0006_ProjectRoute.InitEvent ACT:S) |
| WK-SCP0006-0054 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0006-0055 | G4 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProject | 없음 | 1 (txtProject + btnProject (Project)) |
| WK-SCP0006-0056 | E5 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0006-0057 | E5 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0006-0058 | G03-WIRE | SCP0006 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0006 화면 | 판단불가(대상 단위 SCREEN) | 11 (ACT:SCP0006_ProjectRoute..ctor ACT:SCP00) |
| WK-SCP0006-0059 | G5 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnProject | 없음 | 1 (txtProject + btnProject (Project)) |
| WK-SCP0006-0060 | G5 | txtProject / sProjectCode / Project / PJ | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtProject / sProjectCode / Project / PJT | 있음(FE 소스) | 1 (txtProject + btnProject (Project)) |
| WK-SCP0006-0061 | H6 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProject | 없음 | 1 (txtProject + btnProject (Project)) |

## W6 검증 실행 (139)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0006-0062 | J2 | SCP0006 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0006 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 59 (R1 Division 권한 0건 → SetDivisionAuthCheck) |
| WK-SCP0006-0063 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.InitControls:25) |
| WK-SCP0006-0064 | C1 | cboStatus / Status | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboStatus / Status · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0006_ProjectRoute.InitControls:26) |
| WK-SCP0006-0065 | C1 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0006_ProjectRoute.SetChangedContr) |
| WK-SCP0006-0066 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.SetChangedContr) |
| WK-SCP0006-0067 | C3 | FROM_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.SetOrgData ACT:) |
| WK-SCP0006-0068 | C3 | IS_PASS_N6 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — IS_PASS_N6 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN6:19) |
| WK-SCP0006-0069 | C3 | IS_PASS_N7 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — IS_PASS_N7 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN7:19) |
| WK-SCP0006-0070 | C3 | MERGE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MERGE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.SetOrgData ACT:) |
| WK-SCP0006-0071 | C3 | ORG_FROM_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ORG_FROM_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.SetOrgData ACT:) |
| WK-SCP0006-0072 | C3 | ORG_TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ORG_TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.SetOrgData ACT:) |
| WK-SCP0006-0073 | C3 | PLANT_PER_ITEM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_PER_ITEM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0006_ProjectRoute.AfterFindDataBO) |
| WK-SCP0006-0074 | C3 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0006_ProjectRoute.ChkPlantOs:1352) |
| WK-SCP0006-0075 | C3 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.SetOrgData ACT:) |
| WK-SCP0006-0076 | C3 | YYYYMM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — YYYYMM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.SetCalendar ACT) |
| WK-SCP0006-0077 | C3 | YYYYMM_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — YYYYMM_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.SetCalendar ACT) |
| WK-SCP0006-0078 | G3 | SCP0006 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0006 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (usrConditionPanel1(HidePanel) COMMON:UC-) |
| WK-SCP0006-0079 | K-SA | SCP0006 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0006 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (usrConditionPanel1(HidePanel) COMMON:UC-) |
| WK-SCP0006-0080 | K4 | SCP0006 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0006 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 40 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0006-0081 | F1 | SCP0006 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0006 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 31 (Delete 'I'행만 Save SAVE_PLANT ^-delim MSG) |
| WK-SCP0006-0082 | F5 | SCP0006 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0006 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 12 (Delete 'I'행만 ACT:SCP0006_ProjectRoute.De) |
| WK-SCP0006-0083 | F4 | PKG_SCP0006 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0006 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0084 | F4 | PKG_SCP0006.P_SCP0006_GET_PROJECT_ROUTE_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0006.P_SCP0006_GET_PROJECT_ROUTE_SITE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 |  | 58 (COMMON:UC-06 ACT:SCP0006_ProjectRoute.Fi) |
| WK-SCP0006-0085 | F4 | P_ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_ITEM_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0086 | F4 | P_PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_PROJECT_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0087 | F4 | P_SPLIT_LIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SPLIT_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0088 | F4 | SCP0006_GET_PROJECT_ROUTE_SITE_82 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0006_GET_PROJECT_ROUTE_SITE_82 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 57 (ACT:SCP0006_ProjectRoute.FindButton ACT:) |
| WK-SCP0006-0089 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread:344:) |
| WK-SCP0006-0090 | A5 | PLANT_PER_ITEM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLANT_PER_ITEM · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R11 PLANT_PER_ITEM=nInput/nTot) |
| WK-SCP0006-0091 | A5 | PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0092 | A5 | SALES_MODEL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SALES_MODEL · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0093 | A5 | SCM_SITE_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SCM_SITE_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0094 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0006-0095 | G4 | cboStatus / Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboStatus / Status · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (cboStatus (YesOrNo) ACT:SCP0006_ProjectR) |
| WK-SCP0006-0096 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (clbSalesSite (死필터)) |
| WK-SCP0006-0097 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (drpPeriod (월범위, PERIOD_DEFAULT+11M) ACT:) |
| WK-SCP0006-0098 | G4 | txtItemId / sItemId / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / sItemId / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0006-0099 | G4 | txtProject / sProjectCode / Project / PJ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / sProjectCode / Project / PJT · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtProject + btnProject (Project)) |
| WK-SCP0006-0100 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.InitSpread:344:) |
| WK-SCP0006-0101 | H2 | MERGE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MERGE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN5:18) |
| WK-SCP0006-0102 | H2 | ORG_FROM_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ORG_FROM_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0006_ProjectRoute.checkValidN1:15) |
| WK-SCP0006-0103 | H2 | ORG_TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ORG_TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0006_ProjectRoute.checkValidN1:15) |
| WK-SCP0006-0104 | H2 | PLANT_PER_ITEM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_PER_ITEM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R11 PLANT_PER_ITEM=nInput/nTot) |
| WK-SCP0006-0105 | H2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.checkValidN0:15) |
| WK-SCP0006-0106 | H2 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN4:17) |
| WK-SCP0006-0107 | H2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0108 | H2 | SALES_MODEL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SALES_MODEL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0109 | H2 | SCM_SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SCM_SITE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0110 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread:344:) |
| WK-SCP0006-0111 | H5 | PLANT_PER_ITEM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLANT_PER_ITEM · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R11 PLANT_PER_ITEM=nInput/nTot) |
| WK-SCP0006-0112 | H5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0113 | H5 | SALES_MODEL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SALES_MODEL · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0114 | H5 | SCM_SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SCM_SITE_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0115 | I1 | SCP0006 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0006 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 29 (R1 Division 권한 0건 → SetDivisionAuthCheck) |
| WK-SCP0006-0116 | SC1 | SCP0006 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0006 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 8 (cboDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0006-0117 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.EditButton ACT:) |
| WK-SCP0006-0118 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.EditButton ACT:) |
| WK-SCP0006-0119 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.EditButton ACT:) |
| WK-SCP0006-0120 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.EditButton:524:) |
| WK-SCP0006-0121 | D1 | PRIORITY_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRIORITY_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.EditButton ACT:) |
| WK-SCP0006-0122 | D1 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.EditButton ACT:) |
| WK-SCP0006-0123 | D1 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.EditButton ACT:) |
| WK-SCP0006-0124 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.EditButton ACT:) |
| WK-SCP0006-0125 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.EditButton ACT:) |
| WK-SCP0006-0126 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.EditButton ACT:) |
| WK-SCP0006-0127 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.EditButton:524:) |
| WK-SCP0006-0128 | D3 | PRIORITY_SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRIORITY_SEQ · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.EditButton ACT:) |
| WK-SCP0006-0129 | D3 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.EditButton ACT:) |
| WK-SCP0006-0130 | D3 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0006_ProjectRoute.EditButton ACT:) |
| WK-SCP0006-0131 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread:344:) |
| WK-SCP0006-0132 | D5 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0006-0133 | D5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0134 | D5 | SALES_MODEL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SALES_MODEL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0135 | D5 | SCM_SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0136 | D5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0006-0137 | D6 | SCP0006 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0006 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 5 (R-INS-DEF 신규행 기본값 5종 + MSG00116 MSG00116) |
| WK-SCP0006-0138 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0006_ProjectRoute.SetChangedContr) |
| WK-SCP0006-0139 | E4 | FROM_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FROM_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0006_ProjectRoute.SetOrgData ACT:) |
| WK-SCP0006-0140 | E4 | MERGE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MERGE_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0006_ProjectRoute.SetOrgData ACT:) |
| WK-SCP0006-0141 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0006_ProjectRoute.AfterSaveDataPl) |
| WK-SCP0006-0142 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0006_ProjectRoute.AfterSaveDataPl) |
| WK-SCP0006-0143 | E4 | MSG00048 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00048 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN8:20) |
| WK-SCP0006-0144 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (R1 Division 권한 0건 → SetDivisionAuthCheck) |
| WK-SCP0006-0145 | E4 | MSG00101 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00101 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00101~110·48 (N1~N9) ACT:SCP0006_Proj) |
| WK-SCP0006-0146 | E4 | MSG00102 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00102 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN2:16) |
| WK-SCP0006-0147 | E4 | MSG00103 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00103 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN3:17) |
| WK-SCP0006-0148 | E4 | MSG00104 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00104 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN4:17) |
| WK-SCP0006-0149 | E4 | MSG00105 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00105 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN5:18) |
| WK-SCP0006-0150 | E4 | MSG00106 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00106 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN6:19) |
| WK-SCP0006-0151 | E4 | MSG00107 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00107 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN7:19) |
| WK-SCP0006-0152 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN8:20) |
| WK-SCP0006-0153 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00109 ACT:SCP0006_ProjectRoute.EditBu) |
| WK-SCP0006-0154 | E4 | MSG00110 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00110 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0006_ProjectRoute.checkValidN9:21) |
| WK-SCP0006-0155 | E4 | MSG00116 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00116 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (R-INS-DEF 신규행 기본값 5종 + MSG00116 MSG00116) |
| WK-SCP0006-0156 | E4 | MSG00133 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00133 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00133 COMMON:UC-04 ACT:SCP0006_Projec) |
| WK-SCP0006-0157 | E4 | MSG00226 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00226 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (R-OSCLR 외주 PACKER 클리어(MSG00226) MSG00226) |
| WK-SCP0006-0158 | E4 | MSG00704 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00704 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0006-0159 | E4 | ORG_FROM_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ORG_FROM_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0006_ProjectRoute.SetOrgData ACT:) |
| WK-SCP0006-0160 | E4 | ORG_TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ORG_TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0006_ProjectRoute.SetOrgData ACT:) |
| WK-SCP0006-0161 | E4 | PLANT_PER_ITEM | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_PER_ITEM · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R11 PLANT_PER_ITEM=nInput/nTot) |
| WK-SCP0006-0162 | E4 | PLANT_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0006_ProjectRoute.ChkPlantOs:1351) |
| WK-SCP0006-0163 | E4 | TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0006_ProjectRoute.SetOrgData ACT:) |
| WK-SCP0006-0164 | E4 | YYYYMM | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — YYYYMM · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0006_ProjectRoute.SetCalendar ACT) |
| WK-SCP0006-0165 | E4 | YYYYMM_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — YYYYMM_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0006_ProjectRoute.SetCalendar ACT) |
| WK-SCP0006-0166 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 17 (ACT:SCP0006_ProjectRoute.SetChangedContr) |
| WK-SCP0006-0167 | E4 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 7 (ACT:SCP0006_ProjectRoute.SetChangedContr) |
| WK-SCP0006-0168 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SCP0006_ProjectRoute.SetCalendar ACT) |
| WK-SCP0006-0169 | E4 | txtProject / sProjectCode / Project / PJ | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtProject / sProjectCode / Project / PJT · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메 |  | 5 (ACT:SCP0006_ProjectRoute.SetChangedContr) |
| WK-SCP0006-0170 | A10 | SCP0006 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0006 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 69 (ACT:SCP0006_ProjectRoute.Form_Load ACT:S) |
| WK-SCP0006-0171 | A6 | PKG_SCP0006 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0006 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0172 | A6 | PKG_SCP0006.P_SCP0006_GET_PROJECT_ROUTE_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0006.P_SCP0006_GET_PROJECT_ROUTE_SITE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로  |  | 58 (COMMON:UC-06 ACT:SCP0006_ProjectRoute.Fi) |
| WK-SCP0006-0173 | A6 | P_ITEM_ID | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_ITEM_ID · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0174 | A6 | P_PROJECT_CODE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_PROJECT_CODE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0175 | A6 | P_SPLIT_LIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SPLIT_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0176 | A6 | SCP0006_GET_PROJECT_ROUTE_SITE_82 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0006_GET_PROJECT_ROUTE_SITE_82 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trac |  | 57 (ACT:SCP0006_ProjectRoute.FindButton ACT:) |
| WK-SCP0006-0177 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0006-0178 | G1 | cboStatus / Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboStatus / Status · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboStatus (YesOrNo) ACT:SCP0006_ProjectR) |
| WK-SCP0006-0179 | G1 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (R4 clbSalesSite 항상 ALL·비활성(선택값), 후보목록은 d) |
| WK-SCP0006-0180 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (drpPeriod (월범위, PERIOD_DEFAULT+11M) ACT:) |
| WK-SCP0006-0181 | G1 | txtItemId / sItemId / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / sItemId / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtItemId + btnItemId (Model) ACT:SCP000) |
| WK-SCP0006-0182 | G1 | txtProject / sProjectCode / Project / PJ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / sProjectCode / Project / PJT · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtProject + btnProject (Project) ACT:SC) |
| WK-SCP0006-0183 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0006-0184 | G6 | cboStatus / Status | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboStatus / Status · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (cboStatus (YesOrNo) ACT:SCP0006_ProjectR) |
| WK-SCP0006-0185 | G6 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (clbSalesSite (死필터)) |
| WK-SCP0006-0186 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (drpPeriod (월범위, PERIOD_DEFAULT+11M) ACT:) |
| WK-SCP0006-0187 | G6 | txtItemId / sItemId / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / sItemId / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0006-0188 | G6 | txtProject / sProjectCode / Project / PJ | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / sProjectCode / Project / PJT · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtProject + btnProject (Project)) |
| WK-SCP0006-0189 | X-REOPEN | SCP0006 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0006 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 5 (ACT:SCP0006_ProjectRoute.Dispose ACT:SCP) |
| WK-SCP0006-0190 | H6 | txtProject / sProjectCode / Project / PJ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtProject / sProjectCode / Project / PJT · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (txtProject + btnProject (Project)) |
| WK-SCP0006-0191 | M4 | CELL_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CELL_TYPE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.spdBOM_CellDoub) |
| WK-SCP0006-0192 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 7 (ACT:SCP0006_ProjectRoute.spdBOM_CellDoub) |
| WK-SCP0006-0193 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 6 (ACT:SCP0006_ProjectRoute.spdBOM_CellDoub) |
| WK-SCP0006-0194 | M4 | OPERATION_GROUP_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — OPERATION_GROUP_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCP0006_ProjectRoute.spdBOM_CellDoub) |
| WK-SCP0006-0195 | M4 | OPERATION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — OPERATION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.spdPlant_CellDo) |
| WK-SCP0006-0196 | M4 | PLANT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PLANT_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0006_ProjectRoute.spdPlant_CellDo) |
| WK-SCP0006-0197 | M4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCP0006_ProjectRoute.spdBOM_CellDoub) |
| WK-SCP0006-0198 | M4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCP0006_ProjectRoute.spdBOM_CellDoub) |
| WK-SCP0006-0199 | M4 | btnProject | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnProject · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (txtProject + btnProject (Project)) |
| WK-SCP0006-0200 | M4 | txtProject / sProjectCode / Project / PJ | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtProject / sProjectCode / Project / PJT · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (txtProject + btnProject (Project)) |

## W7 기대값 확정 (225)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0006-0201 | C3 | A6 spdPlant_Change FROM/TO → ORG/MERGE | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — A6 spdPlant_Change FROM/TO → ORG/MERGE: 행 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (A6 spdPlant_Change FROM/TO → ORG/MERGE) |
| WK-SCP0006-0202 | C3 | SCP0006_ProjectRoute.ClbDivision_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0006_ProjectRoute.ClbDivision_SelectedIndexChan: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.ClbDivision_Sel) |
| WK-SCP0006-0203 | C3 | SCP0006_ProjectRoute.SetCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0006_ProjectRoute.SetCalendar: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.SetCalendar:422) |
| WK-SCP0006-0204 | C3 | SCP0006_ProjectRoute.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0006_ProjectRoute.SetChangedPeriod: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0006_ProjectRoute.SetChangedPerio) |
| WK-SCP0006-0205 | C3 | SCP0006_ProjectRoute.SetOrgData | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0006_ProjectRoute.SetOrgData: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0006_ProjectRoute.SetOrgData:1360) |
| WK-SCP0006-0206 | C3 | SCP0006_ProjectRoute.SetQueryInfoGetBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0006_ProjectRoute.SetQueryInfoGetBOM: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0006_ProjectRoute.SetQueryInfoGet) |
| WK-SCP0006-0207 | C3 | SCP0006_ProjectRoute.SetQueryInfoGetPlan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0006_ProjectRoute.SetQueryInfoGetPlant: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0006_ProjectRoute.SetQueryInfoGet) |
| WK-SCP0006-0208 | C3 | SCP0006_ProjectRoute.SetQueryInfoSavePla | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0006_ProjectRoute.SetQueryInfoSavePlant: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0006_ProjectRoute.SetQueryInfoSav) |
| WK-SCP0006-0209 | B3 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — COMMON:UC-06: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0210 | B3 | SCP0006_ProjectRoute.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0006_ProjectRoute.GetDayRange: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.GetDayRange:113) |
| WK-SCP0006-0211 | B3 | SCP0006_ProjectRoute.GetQueryInfoGetBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0006_ProjectRoute.GetQueryInfoGetBOM: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0006_ProjectRoute.GetQueryInfoGet) |
| WK-SCP0006-0212 | B3 | SCP0006_ProjectRoute.GetQueryInfoGetPlan | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0006_ProjectRoute.GetQueryInfoGetPlant: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0006_ProjectRoute.GetQueryInfoGet) |
| WK-SCP0006-0213 | B3 | SCP0006_ProjectRoute.GetQueryInfoSavePla | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0006_ProjectRoute.GetQueryInfoSavePlant: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SCP0006_ProjectRoute.GetQueryInfoSav) |
| WK-SCP0006-0214 | B4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-06: 행 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0215 | B4 | SCP0006_ProjectRoute.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0006_ProjectRoute.GetDayRange: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.GetDayRange:113) |
| WK-SCP0006-0216 | B4 | SCP0006_ProjectRoute.GetQueryInfoGetBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0006_ProjectRoute.GetQueryInfoGetBOM: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0006_ProjectRoute.GetQueryInfoGet) |
| WK-SCP0006-0217 | B4 | SCP0006_ProjectRoute.GetQueryInfoGetPlan | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0006_ProjectRoute.GetQueryInfoGetPlant: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0006_ProjectRoute.GetQueryInfoGet) |
| WK-SCP0006-0218 | B4 | SCP0006_ProjectRoute.GetQueryInfoSavePla | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0006_ProjectRoute.GetQueryInfoSavePlant: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SCP0006_ProjectRoute.GetQueryInfoSav) |
| WK-SCP0006-0219 | DB-SYN | SCP0006_ProjectRoute.FindDataBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0006_ProjectRoute.FindDataBOM: 진입점 집계 — DB-SYN 6요소: NOPATH:5 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.FindDataBOM:862) |
| WK-SCP0006-0220 | DB-SYN | SCP0006_ProjectRoute.FindDataBOMPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0006_ProjectRoute.FindDataBOMPlant: 진입점 집계 — DB-SYN 6요소: NOPATH:5 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.FindDataBOMPlan) |
| WK-SCP0006-0221 | DB-SYN | SCP0006_ProjectRoute.FindDataPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0006_ProjectRoute.FindDataPlant: 진입점 집계 — DB-SYN 6요소: NOPATH:5 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.FindDataPlant:8) |
| WK-SCP0006-0222 | DB-SYN | SCP0006_ProjectRoute.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0006_ProjectRoute.GetDayRange: 진입점 집계 — DB-SYN 6요소: NOPATH:5 · PASS:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.GetDayRange:113) |
| WK-SCP0006-0223 | DB-SYN | SCP0006_ProjectRoute.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0006_ProjectRoute.SaveData: 진입점 집계 — DB-SYN 6요소: NOPATH:5 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.SaveData:997:4) |
| WK-SCP0006-0224 | F4 | SCP0006_ProjectRoute.FindDataBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0006_ProjectRoute.FindDataBOM: 진입점 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0006_ProjectRoute.FindDataBOM ACT) |
| WK-SCP0006-0225 | F4 | SCP0006_ProjectRoute.FindDataBOMPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0006_ProjectRoute.FindDataBOMPlant: 진입점 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0006_ProjectRoute.FindDataBOMPlan) |
| WK-SCP0006-0226 | F4 | SCP0006_ProjectRoute.FindDataPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0006_ProjectRoute.FindDataPlant: 진입점 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0006_ProjectRoute.FindDataPlant A) |
| WK-SCP0006-0227 | F4 | SCP0006_ProjectRoute.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0006_ProjectRoute.GetDayRange: 진입점 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.GetDayRange:113) |
| WK-SCP0006-0228 | F4 | SCP0006_ProjectRoute.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0006_ProjectRoute.SaveButton: 진입점 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.SaveButton) |
| WK-SCP0006-0229 | F4 | SCP0006_ProjectRoute.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0006_ProjectRoute.SaveData: 진입점 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.SaveData) |
| WK-SCP0006-0230 | F4 | SCP0006_ProjectRoute.SaveDataPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0006_ProjectRoute.SaveDataPlant: 진입점 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.SaveDataPlant) |
| WK-SCP0006-0231 | A5 | A2 spdSite_CellDoubleClick → BOM 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — A2 spdSite_CellDoubleClick → BOM 조회: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (A2 spdSite_CellDoubleClick → BOM 조회) |
| WK-SCP0006-0232 | A5 | A3 spdBOM_CellDoubleClick → Plant 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — A3 spdBOM_CellDoubleClick → Plant 조회: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (A3 spdBOM_CellDoubleClick → Plant 조회) |
| WK-SCP0006-0233 | A5 | A5 spdPlant_CellDoubleClick → CAPA(SCP00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — A5 spdPlant_CellDoubleClick → CAPA(SCP0049): 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (A5 spdPlant_CellDoubleClick → CAPA(SCP00) |
| WK-SCP0006-0234 | A5 | A6 spdPlant_Change FROM/TO → ORG/MERGE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — A6 spdPlant_Change FROM/TO → ORG/MERGE: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (A6 spdPlant_Change FROM/TO → ORG/MERGE) |
| WK-SCP0006-0235 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0006-0236 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0006-0237 | A5 | Delete 'I'행만 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Delete 'I'행만: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Delete 'I'행만) |
| WK-SCP0006-0238 | A5 | MSG00109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — MSG00109: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (MSG00109) |
| WK-SCP0006-0239 | A5 | R-DYN Div 82/40 컬럼 visible | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-DYN Div 82/40 컬럼 visible: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R-DYN Div 82/40 컬럼 visible) |
| WK-SCP0006-0240 | A5 | R-EDIT/R-INS-LOCK 편집 5컬럼만 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-EDIT/R-INS-LOCK 편집 5컬럼만: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R-EDIT/R-INS-LOCK 편집 5컬럼만) |
| WK-SCP0006-0241 | A5 | R-INS-DEF 신규행 기본값 5종 + MSG00116 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-INS-DEF 신규행 기본값 5종 + MSG00116: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R-INS-DEF 신규행 기본값 5종 + MSG00116) |
| WK-SCP0006-0242 | A5 | R2 Division 82/40 → Project clear·disabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R2 Division 82/40 → Project clear·disable, SalesSi: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R2 Division 82/40 → Project clear·disabl) |
| WK-SCP0006-0243 | A5 | SCP0006_ProjectRoute.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0006_ProjectRoute.CreateSpread: 진입점 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0006_ProjectRoute.CreateSpread:27) |
| WK-SCP0006-0244 | A5 | Save SAVE_PLANT ^-delim | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Save SAVE_PLANT ^-delim: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Save SAVE_PLANT ^-delim) |
| WK-SCP0006-0245 | A5 | SetCalendar 동적 월 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SetCalendar 동적 월 컬럼: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SetCalendar 동적 월 컬럼) |
| WK-SCP0006-0246 | A5 | spdBOM(siBOM, read-only) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdBOM(siBOM, read-only): 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdBOM(siBOM, read-only)) |
| WK-SCP0006-0247 | A5 | spdMain(siSite, read-only) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain(siSite, read-only): 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(siSite, read-only)) |
| WK-SCP0006-0248 | A5 | spdPlant(siPlant, 편집) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdPlant(siPlant, 편집): 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdPlant(siPlant, 편집)) |
| WK-SCP0006-0249 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 9요소: NOT_RUN:6 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0250 | G4 | dead: GET_DATE_RANGE_1MONTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — dead: GET_DATE_RANGE_1MONTH: 행 집계 — G4 9요소: NOT_RUN:6 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (dead: GET_DATE_RANGE_1MONTH) |
| WK-SCP0006-0251 | H2 | A2 spdSite_CellDoubleClick → BOM 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — A2 spdSite_CellDoubleClick → BOM 조회: 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (A2 spdSite_CellDoubleClick → BOM 조회) |
| WK-SCP0006-0252 | H2 | A3 spdBOM_CellDoubleClick → Plant 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — A3 spdBOM_CellDoubleClick → Plant 조회: 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (A3 spdBOM_CellDoubleClick → Plant 조회) |
| WK-SCP0006-0253 | H2 | A5 spdPlant_CellDoubleClick → CAPA(SCP00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — A5 spdPlant_CellDoubleClick → CAPA(SCP0049): 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (A5 spdPlant_CellDoubleClick → CAPA(SCP00) |
| WK-SCP0006-0254 | H2 | A6 spdPlant_Change FROM/TO → ORG/MERGE | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — A6 spdPlant_Change FROM/TO → ORG/MERGE: 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (A6 spdPlant_Change FROM/TO → ORG/MERGE) |
| WK-SCP0006-0255 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0006-0256 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0006-0257 | H2 | Delete 'I'행만 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Delete 'I'행만: 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (Delete 'I'행만) |
| WK-SCP0006-0258 | H2 | MSG00109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — MSG00109: 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (MSG00109) |
| WK-SCP0006-0259 | H2 | R-DYN Div 82/40 컬럼 visible | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-DYN Div 82/40 컬럼 visible: 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R-DYN Div 82/40 컬럼 visible) |
| WK-SCP0006-0260 | H2 | R-EDIT/R-INS-LOCK 편집 5컬럼만 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-EDIT/R-INS-LOCK 편집 5컬럼만: 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R-EDIT/R-INS-LOCK 편집 5컬럼만) |
| WK-SCP0006-0261 | H2 | R-INS-DEF 신규행 기본값 5종 + MSG00116 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-INS-DEF 신규행 기본값 5종 + MSG00116: 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R-INS-DEF 신규행 기본값 5종 + MSG00116) |
| WK-SCP0006-0262 | H2 | SCP0006_ProjectRoute.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0006_ProjectRoute.CreateSpread: 진입점 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0006_ProjectRoute.CreateSpread:27) |
| WK-SCP0006-0263 | H2 | Save SAVE_PLANT ^-delim | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Save SAVE_PLANT ^-delim: 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (Save SAVE_PLANT ^-delim) |
| WK-SCP0006-0264 | H2 | SetCalendar 동적 월 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SetCalendar 동적 월 컬럼: 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (SetCalendar 동적 월 컬럼) |
| WK-SCP0006-0265 | H2 | spdBOM(siBOM, read-only) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdBOM(siBOM, read-only): 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (spdBOM(siBOM, read-only)) |
| WK-SCP0006-0266 | H2 | spdMain(siSite, read-only) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain(siSite, read-only): 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(siSite, read-only)) |
| WK-SCP0006-0267 | H2 | spdPlant(siPlant, 편집) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdPlant(siPlant, 편집): 행 집계 — H2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (spdPlant(siPlant, 편집)) |
| WK-SCP0006-0268 | H5 | A2 spdSite_CellDoubleClick → BOM 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — A2 spdSite_CellDoubleClick → BOM 조회: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (A2 spdSite_CellDoubleClick → BOM 조회) |
| WK-SCP0006-0269 | H5 | A3 spdBOM_CellDoubleClick → Plant 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — A3 spdBOM_CellDoubleClick → Plant 조회: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (A3 spdBOM_CellDoubleClick → Plant 조회) |
| WK-SCP0006-0270 | H5 | A5 spdPlant_CellDoubleClick → CAPA(SCP00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — A5 spdPlant_CellDoubleClick → CAPA(SCP0049): 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (A5 spdPlant_CellDoubleClick → CAPA(SCP00) |
| WK-SCP0006-0271 | H5 | A6 spdPlant_Change FROM/TO → ORG/MERGE | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — A6 spdPlant_Change FROM/TO → ORG/MERGE: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (A6 spdPlant_Change FROM/TO → ORG/MERGE) |
| WK-SCP0006-0272 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0006-0273 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0006-0274 | H5 | Delete 'I'행만 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Delete 'I'행만: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Delete 'I'행만) |
| WK-SCP0006-0275 | H5 | MSG00109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — MSG00109: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (MSG00109) |
| WK-SCP0006-0276 | H5 | R-DYN Div 82/40 컬럼 visible | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-DYN Div 82/40 컬럼 visible: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R-DYN Div 82/40 컬럼 visible) |
| WK-SCP0006-0277 | H5 | R-EDIT/R-INS-LOCK 편집 5컬럼만 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-EDIT/R-INS-LOCK 편집 5컬럼만: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R-EDIT/R-INS-LOCK 편집 5컬럼만) |
| WK-SCP0006-0278 | H5 | R-INS-DEF 신규행 기본값 5종 + MSG00116 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-INS-DEF 신규행 기본값 5종 + MSG00116: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R-INS-DEF 신규행 기본값 5종 + MSG00116) |
| WK-SCP0006-0279 | H5 | SCP0006_ProjectRoute.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0006_ProjectRoute.CreateSpread: 진입점 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0006_ProjectRoute.CreateSpread:27) |
| WK-SCP0006-0280 | H5 | Save SAVE_PLANT ^-delim | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Save SAVE_PLANT ^-delim: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Save SAVE_PLANT ^-delim) |
| WK-SCP0006-0281 | H5 | SetCalendar 동적 월 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SetCalendar 동적 월 컬럼: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SetCalendar 동적 월 컬럼) |
| WK-SCP0006-0282 | H5 | spdBOM(siBOM, read-only) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdBOM(siBOM, read-only): 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdBOM(siBOM, read-only)) |
| WK-SCP0006-0283 | H5 | spdMain(siSite, read-only) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain(siSite, read-only): 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(siSite, read-only)) |
| WK-SCP0006-0284 | H5 | spdPlant(siPlant, 편집) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdPlant(siPlant, 편집): 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdPlant(siPlant, 편집)) |
| WK-SCP0006-0285 | D1 | MSG00109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — MSG00109: 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (MSG00109) |
| WK-SCP0006-0286 | D1 | R-EDIT/R-INS-LOCK 편집 5컬럼만 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-EDIT/R-INS-LOCK 편집 5컬럼만: 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R-EDIT/R-INS-LOCK 편집 5컬럼만) |
| WK-SCP0006-0287 | D1 | SCP0006_ProjectRoute.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0006_ProjectRoute.EditButton: 진입점 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0006_ProjectRoute.EditButton:495:) |
| WK-SCP0006-0288 | D1 | spdPlant(siPlant, 편집) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — spdPlant(siPlant, 편집): 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (spdPlant(siPlant, 편집)) |
| WK-SCP0006-0289 | D3 | MSG00109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — MSG00109: 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (MSG00109) |
| WK-SCP0006-0290 | D3 | R-EDIT/R-INS-LOCK 편집 5컬럼만 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-EDIT/R-INS-LOCK 편집 5컬럼만: 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R-EDIT/R-INS-LOCK 편집 5컬럼만) |
| WK-SCP0006-0291 | D3 | SCP0006_ProjectRoute.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0006_ProjectRoute.EditButton: 진입점 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0006_ProjectRoute.EditButton:495:) |
| WK-SCP0006-0292 | D3 | spdPlant(siPlant, 편집) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — spdPlant(siPlant, 편집): 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (spdPlant(siPlant, 편집)) |
| WK-SCP0006-0293 | D5 | SCP0006_ProjectRoute.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0006_ProjectRoute.CreateSpread: 진입점 집계 — D5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0006_ProjectRoute.CreateSpread:27) |
| WK-SCP0006-0294 | E4 | A2 spdSite_CellDoubleClick → BOM 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — A2 spdSite_CellDoubleClick → BOM 조회: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (A2 spdSite_CellDoubleClick → BOM 조회) |
| WK-SCP0006-0295 | E4 | A3 spdBOM_CellDoubleClick → Plant 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — A3 spdBOM_CellDoubleClick → Plant 조회: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (A3 spdBOM_CellDoubleClick → Plant 조회) |
| WK-SCP0006-0296 | E4 | A5 spdPlant_CellDoubleClick → CAPA(SCP00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — A5 spdPlant_CellDoubleClick → CAPA(SCP0049): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (A5 spdPlant_CellDoubleClick → CAPA(SCP00) |
| WK-SCP0006-0297 | E4 | A6 spdPlant_Change FROM/TO → ORG/MERGE | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — A6 spdPlant_Change FROM/TO → ORG/MERGE: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (A6 spdPlant_Change FROM/TO → ORG/MERGE) |
| WK-SCP0006-0298 | E4 | Delete 'I'행만 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — Delete 'I'행만: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (Delete 'I'행만) |
| WK-SCP0006-0299 | E4 | R-DYN Div 82/40 컬럼 visible | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-DYN Div 82/40 컬럼 visible: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-DYN Div 82/40 컬럼 visible) |
| WK-SCP0006-0300 | E4 | R-EDIT/R-INS-LOCK 편집 5컬럼만 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-EDIT/R-INS-LOCK 편집 5컬럼만: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-EDIT/R-INS-LOCK 편집 5컬럼만) |
| WK-SCP0006-0301 | E4 | R5 btnAllFind Input All | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R5 btnAllFind Input All: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R5 btnAllFind Input All) |
| WK-SCP0006-0302 | E4 | SCP0006_ProjectRoute.SetCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0006_ProjectRoute.SetCalendar: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.SetCalendar:422) |
| WK-SCP0006-0303 | E4 | SCP0006_ProjectRoute.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0006_ProjectRoute.SetChangedPeriod: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0006_ProjectRoute.SetChangedPerio) |
| WK-SCP0006-0304 | E4 | SCP0006_ProjectRoute.SetOrgData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0006_ProjectRoute.SetOrgData: 진입점 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0006_ProjectRoute.SetOrgData:1360) |
| WK-SCP0006-0305 | E4 | SCP0006_ProjectRoute.SetQueryInfoGetBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0006_ProjectRoute.SetQueryInfoGetBOM: 진입점 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0006_ProjectRoute.SetQueryInfoGet) |
| WK-SCP0006-0306 | E4 | SCP0006_ProjectRoute.SetQueryInfoGetPlan | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0006_ProjectRoute.SetQueryInfoGetPlant: 진입점 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0006_ProjectRoute.SetQueryInfoGet) |
| WK-SCP0006-0307 | E4 | SCP0006_ProjectRoute.SetQueryInfoSavePla | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0006_ProjectRoute.SetQueryInfoSavePlant: 진입점 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0006_ProjectRoute.SetQueryInfoSav) |
| WK-SCP0006-0308 | E4 | Save SAVE_PLANT ^-delim | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — Save SAVE_PLANT ^-delim: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (Save SAVE_PLANT ^-delim) |
| WK-SCP0006-0309 | E4 | SetCalendar 동적 월 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SetCalendar 동적 월 컬럼: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (SetCalendar 동적 월 컬럼) |
| WK-SCP0006-0310 | E4 | spdBOM(siBOM, read-only) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — spdBOM(siBOM, read-only): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (spdBOM(siBOM, read-only)) |
| WK-SCP0006-0311 | E4 | spdMain(siSite, read-only) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — spdMain(siSite, read-only): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(siSite, read-only)) |
| WK-SCP0006-0312 | E4 | spdPlant(siPlant, 편집) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — spdPlant(siPlant, 편집): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (spdPlant(siPlant, 편집)) |
| WK-SCP0006-0313 | A1 | A2 spdSite_CellDoubleClick → BOM 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A2 spdSite_CellDoubleClick → BOM 조회: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (A2 spdSite_CellDoubleClick → BOM 조회) |
| WK-SCP0006-0314 | A1 | A3 spdBOM_CellDoubleClick → Plant 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A3 spdBOM_CellDoubleClick → Plant 조회: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (A3 spdBOM_CellDoubleClick → Plant 조회) |
| WK-SCP0006-0315 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (COMMON:UC-02) |
| WK-SCP0006-0316 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (COMMON:UC-07) |
| WK-SCP0006-0317 | A1 | PKG_SCP0006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0006: 골든 비교 케이스 없음(PKG_SCP0006 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0318 | A1 | PKG_SCP0006.P_SCP0006_GET_PROJECT_ROUTE_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0006.P_SCP0006_GET_PROJECT_ROUTE_SITE: 골든 비교 케이스 없음(PKG_SCP0006.P_SCP0006_GET_PROJECT_ROUTE_SITE — 팝업·보조 SP 는 g |  | 58 (COMMON:UC-06 ACT:SCP0006_ProjectRoute.Fi) |
| WK-SCP0006-0319 | A1 | P_ITEM_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_ITEM_ID: 골든 비교 케이스 없음(P_ITEM_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0320 | A1 | P_PROJECT_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_PROJECT_CODE: 골든 비교 케이스 없음(P_PROJECT_CODE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0321 | A1 | P_SPLIT_LIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SPLIT_LIST: 골든 비교 케이스 없음(P_SPLIT_LIST — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0322 | A1 | R1 Division 권한 0건 → SetDivisionAuthCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R1 Division 권한 0건 → SetDivisionAuthCheck: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (R1 Division 권한 0건 → SetDivisionAuthCheck) |
| WK-SCP0006-0323 | A1 | R4 clbSalesSite 항상 ALL·비활성(선택값), 후보목록은 d | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R4 clbSalesSite 항상 ALL·비활성(선택값), 후보목록은 division별 실: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (R4 clbSalesSite 항상 ALL·비활성(선택값), 후보목록은 d) |
| WK-SCP0006-0324 | A1 | SCP0006_GET_PROJECT_ROUTE_SITE_82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0006_GET_PROJECT_ROUTE_SITE_82: 골든 비교 케이스 없음(SCP0006_GET_PROJECT_ROUTE_SITE_82 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실 |  | 57 (ACT:SCP0006_ProjectRoute.FindButton ACT:) |
| WK-SCP0006-0325 | A1 | SCP0006_ProjectRoute.AfterFindDataBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0006_ProjectRoute.AfterFindDataBOM: 진입점 집계 — A1 6요소: REVIEW:6 |  | 1 (ACT:SCP0006_ProjectRoute.AfterFindDataBO) |
| WK-SCP0006-0326 | A1 | SCP0006_ProjectRoute.AfterFindDataPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0006_ProjectRoute.AfterFindDataPlant: 진입점 집계 — A1 6요소: REVIEW:6 |  | 1 (ACT:SCP0006_ProjectRoute.AfterFindDataPl) |
| WK-SCP0006-0327 | A1 | SCP0006_ProjectRoute.AfterFindDataSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0006_ProjectRoute.AfterFindDataSite: 진입점 집계 — A1 6요소: REVIEW:6 |  | 1 (ACT:SCP0006_ProjectRoute.AfterFindDataSi) |
| WK-SCP0006-0328 | A1 | SCP0006_ProjectRoute.FindDataBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0006_ProjectRoute.FindDataBOM: 진입점 집계 — A1 6요소: REVIEW:6 |  | 4 (ACT:SCP0006_ProjectRoute.FindDataBOM ACT) |
| WK-SCP0006-0329 | A1 | SCP0006_ProjectRoute.FindDataBOMPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0006_ProjectRoute.FindDataBOMPlant: 진입점 집계 — A1 6요소: REVIEW:6 |  | 3 (ACT:SCP0006_ProjectRoute.FindDataBOMPlan) |
| WK-SCP0006-0330 | A1 | SCP0006_ProjectRoute.FindDataPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0006_ProjectRoute.FindDataPlant: 진입점 집계 — A1 6요소: REVIEW:6 |  | 3 (ACT:SCP0006_ProjectRoute.FindDataPlant A) |
| WK-SCP0006-0331 | A1 | cboDivision (`BLUtils.GetDivisionWithout | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision (`BLUtils.GetDivisionWithoutEE`): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (cboDivision (`BLUtils.GetDivisionWithout) |
| WK-SCP0006-0332 | A1 | cboStatus (YesOrNo) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboStatus (YesOrNo): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (cboStatus (YesOrNo)) |
| WK-SCP0006-0333 | A1 | clbSalesSite (死필터) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbSalesSite (死필터): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (clbSalesSite (死필터)) |
| WK-SCP0006-0334 | A1 | dead: GET_DATE_RANGE_1MONTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — dead: GET_DATE_RANGE_1MONTH: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (dead: GET_DATE_RANGE_1MONTH) |
| WK-SCP0006-0335 | A1 | drpPeriod (월범위, PERIOD_DEFAULT+11M) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — drpPeriod (월범위, PERIOD_DEFAULT+11M): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (drpPeriod (월범위, PERIOD_DEFAULT+11M)) |
| WK-SCP0006-0336 | A1 | txtItemId + btnItemId (Model) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtItemId + btnItemId (Model): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0006-0337 | A1 | txtProject + btnProject (Project) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtProject + btnProject (Project): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (txtProject + btnProject (Project)) |
| WK-SCP0006-0338 | A6 | SCP0006_ProjectRoute.FindDataBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0006_ProjectRoute.FindDataBOM: 진입점 집계 — A6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0006_ProjectRoute.FindDataBOM ACT) |
| WK-SCP0006-0339 | A6 | SCP0006_ProjectRoute.FindDataBOMPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0006_ProjectRoute.FindDataBOMPlant: 진입점 집계 — A6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0006_ProjectRoute.FindDataBOMPlan) |
| WK-SCP0006-0340 | A6 | SCP0006_ProjectRoute.FindDataPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0006_ProjectRoute.FindDataPlant: 진입점 집계 — A6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0006_ProjectRoute.FindDataPlant A) |
| WK-SCP0006-0341 | G1 | A2 spdSite_CellDoubleClick → BOM 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — A2 spdSite_CellDoubleClick → BOM 조회: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (A2 spdSite_CellDoubleClick → BOM 조회) |
| WK-SCP0006-0342 | G1 | A3 spdBOM_CellDoubleClick → Plant 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — A3 spdBOM_CellDoubleClick → Plant 조회: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (A3 spdBOM_CellDoubleClick → Plant 조회) |
| WK-SCP0006-0343 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0006-0344 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0345 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0006-0346 | G1 | R1 Division 권한 0건 → SetDivisionAuthCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R1 Division 권한 0건 → SetDivisionAuthCheck: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R1 Division 권한 0건 → SetDivisionAuthCheck) |
| WK-SCP0006-0347 | G1 | SCP0006_ProjectRoute.FindDataBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0006_ProjectRoute.FindDataBOM: 진입점 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0006_ProjectRoute.FindDataBOM:447) |
| WK-SCP0006-0348 | G1 | SCP0006_ProjectRoute.FindDataBOMPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0006_ProjectRoute.FindDataBOMPlant: 진입점 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.FindDataBOMPlan) |
| WK-SCP0006-0349 | G1 | SCP0006_ProjectRoute.FindDataPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0006_ProjectRoute.FindDataPlant: 진입점 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.FindDataPlant:4) |
| WK-SCP0006-0350 | G1 | dead: GET_DATE_RANGE_1MONTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — dead: GET_DATE_RANGE_1MONTH: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (dead: GET_DATE_RANGE_1MONTH) |
| WK-SCP0006-0351 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0006-0352 | G6 | dead: GET_DATE_RANGE_1MONTH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — dead: GET_DATE_RANGE_1MONTH: 행 집계 — G6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (dead: GET_DATE_RANGE_1MONTH) |
| WK-SCP0006-0353 | X-ROW | MODAL:ProjectRouteListSaveModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:ProjectRouteListSaveModal: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:ProjectRouteListSaveModal) |
| WK-SCP0006-0354 | X-ROW | R3 그 외 division → Project enable | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R3 그 외 division → Project enable: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R3 그 외 division → Project enable) |
| WK-SCP0006-0355 | X-ROW | SCP0006_ProjectRoute.AfterFindDataBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.AfterFindDataBOM: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 20 (ACT:SCP0006_ProjectRoute.AfterFindDataBO) |
| WK-SCP0006-0356 | X-ROW | SCP0006_ProjectRoute.AfterFindDataPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.AfterFindDataPlant: 진입점 집계 1검사 — NOPATH:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0006_ProjectRoute.AfterFindDataPl) |
| WK-SCP0006-0357 | X-ROW | SCP0006_ProjectRoute.AfterFindDataSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.AfterFindDataSite: 진입점 집계 1검사 — NOPATH:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0006_ProjectRoute.AfterFindDataSi) |
| WK-SCP0006-0358 | X-ROW | SCP0006_ProjectRoute.AfterSaveDataPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.AfterSaveDataPlant: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0006_ProjectRoute.AfterSaveDataPl) |
| WK-SCP0006-0359 | X-ROW | SCP0006_ProjectRoute.CheckChangedValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.CheckChangedValues: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/DATA_OP/ENTRY/EXPR/FLOW/LOCAL/ |  | 56 (ACT:SCP0006_ProjectRoute.CheckChangedVal) |
| WK-SCP0006-0360 | X-ROW | SCP0006_ProjectRoute.ChkPlantOs | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.ChkPlantOs: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0006_ProjectRoute.ChkPlantOs ACT:) |
| WK-SCP0006-0361 | X-ROW | SCP0006_ProjectRoute.ClbDivision_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.ClbDivision_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.ClbDivision_Sel) |
| WK-SCP0006-0362 | X-ROW | SCP0006_ProjectRoute.ClearUsrCheckedList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 요소 검사 |  | 4 (ACT:SCP0006_ProjectRoute.ClearUsrChecked) |
| WK-SCP0006-0363 | X-ROW | SCP0006_ProjectRoute.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.CreateSpread) |
| WK-SCP0006-0364 | X-ROW | SCP0006_ProjectRoute.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0006_ProjectRoute.FindButton) |
| WK-SCP0006-0365 | X-ROW | SCP0006_ProjectRoute.FindDataBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.FindDataBOM: 진입점 집계 5검사 — NOPATH:3 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.FindDataBOM) |
| WK-SCP0006-0366 | X-ROW | SCP0006_ProjectRoute.FindDataBOMPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.FindDataBOMPlant: 진입점 집계 5검사 — NOPATH:3 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.FindDataBOMPlan) |
| WK-SCP0006-0367 | X-ROW | SCP0006_ProjectRoute.FindDataPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.FindDataPlant: 진입점 집계 5검사 — NOPATH:3 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.FindDataPlant) |
| WK-SCP0006-0368 | X-ROW | SCP0006_ProjectRoute.FindDataSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.FindDataSite: 진입점 집계 15검사 — NOT_RUN:11 · REVIEW:2 · PASS:1 · NOPATH:1 |  | 7 (ACT:SCP0006_ProjectRoute.FindDataSite:43) |
| WK-SCP0006-0369 | X-ROW | SCP0006_ProjectRoute.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.Form_Load) |
| WK-SCP0006-0370 | X-ROW | SCP0006_ProjectRoute.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.GetDayRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.GetDayRange) |
| WK-SCP0006-0371 | X-ROW | SCP0006_ProjectRoute.GetQueryInfoGetBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.GetQueryInfoGetBOM: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0006_ProjectRoute.GetQueryInfoGet) |
| WK-SCP0006-0372 | X-ROW | SCP0006_ProjectRoute.GetQueryInfoGetPlan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.GetQueryInfoGetPlant: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0006_ProjectRoute.GetQueryInfoGet) |
| WK-SCP0006-0373 | X-ROW | SCP0006_ProjectRoute.GetQueryInfoSavePla | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.GetQueryInfoSavePlant: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0006_ProjectRoute.GetQueryInfoSav) |
| WK-SCP0006-0374 | X-ROW | SCP0006_ProjectRoute.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.InitControls: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0006_ProjectRoute.InitControls:24) |
| WK-SCP0006-0375 | X-ROW | SCP0006_ProjectRoute.InitQueryDics | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.InitQueryDics: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.InitQueryDics) |
| WK-SCP0006-0376 | X-ROW | SCP0006_ProjectRoute.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.InitSpread: 진입점 집계 17검사 — NOT_RUN:17 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.InitSpread ACT:) |
| WK-SCP0006-0377 | X-ROW | SCP0006_ProjectRoute.InitSpreadBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.InitSpreadBOM: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.InitSpreadBOM A) |
| WK-SCP0006-0378 | X-ROW | SCP0006_ProjectRoute.InitSpreadPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.InitSpreadPlant: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.InitSpreadPlant) |
| WK-SCP0006-0379 | X-ROW | SCP0006_ProjectRoute.InitSpreadSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.InitSpreadSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.InitSpreadSite ) |
| WK-SCP0006-0380 | X-ROW | SCP0006_ProjectRoute.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.InsertButton) |
| WK-SCP0006-0381 | X-ROW | SCP0006_ProjectRoute.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.InsertRow: 진입점 집계 16검사 — NOT_RUN:16 (미실행 검사가 남아 판정필요) |  | 23 (ACT:SCP0006_ProjectRoute.InsertRow ACT:S) |
| WK-SCP0006-0382 | X-ROW | SCP0006_ProjectRoute.SetCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.SetCalendar: 진입점 집계 9검사 — NOT_RUN:5 · REVIEW:2 · NOPATH:1 · TODO:1 |  | 1 (ACT:SCP0006_ProjectRoute.SetCalendar:429) |
| WK-SCP0006-0383 | X-ROW | SCP0006_ProjectRoute.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.SetChangedControl: 진입점 집계 9검사 — NOT_RUN:7 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.SetChangedContr) |
| WK-SCP0006-0384 | X-ROW | SCP0006_ProjectRoute.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.SetChangedPeriod: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0006_ProjectRoute.SetChangedPerio) |
| WK-SCP0006-0385 | X-ROW | SCP0006_ProjectRoute.SetOrgData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.SetOrgData: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:2 |  | 3 (ACT:SCP0006_ProjectRoute.SetOrgData:1377) |
| WK-SCP0006-0386 | X-ROW | SCP0006_ProjectRoute.SetQueryInfoGetBOM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.SetQueryInfoGetBOM: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.SetQueryInfoGet) |
| WK-SCP0006-0387 | X-ROW | SCP0006_ProjectRoute.SetQueryInfoGetPlan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.SetQueryInfoGetPlant: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.SetQueryInfoGet) |
| WK-SCP0006-0388 | X-ROW | SCP0006_ProjectRoute.SetQueryInfoSavePla | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.SetQueryInfoSavePlant: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.SetQueryInfoSav) |
| WK-SCP0006-0389 | X-ROW | SCP0006_ProjectRoute.TxtProject_TextChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.TxtProject_TextChanged2: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0006_ProjectRoute.TxtProject_Text) |
| WK-SCP0006-0390 | X-ROW | SCP0006_ProjectRoute.btnAllFind_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.btnAllFind_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0006_ProjectRoute.btnAllFind_Clic) |
| WK-SCP0006-0391 | X-ROW | SCP0006_ProjectRoute.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0006_ProjectRoute.btnItemId_Click) |
| WK-SCP0006-0392 | X-ROW | SCP0006_ProjectRoute.btnProject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.btnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0006_ProjectRoute.btnProject_Clic) |
| WK-SCP0006-0393 | X-ROW | SCP0006_ProjectRoute.checkValidN0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.checkValidN0: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 40 (ACT:SCP0006_ProjectRoute.checkValidN0 AC) |
| WK-SCP0006-0394 | X-ROW | SCP0006_ProjectRoute.checkValidN1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.checkValidN1: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 33 (ACT:SCP0006_ProjectRoute.checkValidN1 AC) |
| WK-SCP0006-0395 | X-ROW | SCP0006_ProjectRoute.checkValidN2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.checkValidN2: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 33 (ACT:SCP0006_ProjectRoute.checkValidN2 AC) |
| WK-SCP0006-0396 | X-ROW | SCP0006_ProjectRoute.checkValidN3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.checkValidN3: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 34 (ACT:SCP0006_ProjectRoute.checkValidN3 AC) |
| WK-SCP0006-0397 | X-ROW | SCP0006_ProjectRoute.checkValidN4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.checkValidN4: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 35 (ACT:SCP0006_ProjectRoute.checkValidN4 AC) |
| WK-SCP0006-0398 | X-ROW | SCP0006_ProjectRoute.checkValidN5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.checkValidN5: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 48 (ACT:SCP0006_ProjectRoute.checkValidN5 AC) |
| WK-SCP0006-0399 | X-ROW | SCP0006_ProjectRoute.checkValidN6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.checkValidN6: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 44 (ACT:SCP0006_ProjectRoute.checkValidN6 AC) |
| WK-SCP0006-0400 | X-ROW | SCP0006_ProjectRoute.checkValidN7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.checkValidN7: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 25 (ACT:SCP0006_ProjectRoute.checkValidN7 AC) |
| WK-SCP0006-0401 | X-ROW | SCP0006_ProjectRoute.checkValidN8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.checkValidN8: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 42 (ACT:SCP0006_ProjectRoute.checkValidN8 AC) |
| WK-SCP0006-0402 | X-ROW | SCP0006_ProjectRoute.checkValidN9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.checkValidN9: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 33 (ACT:SCP0006_ProjectRoute.checkValidN9 AC) |
| WK-SCP0006-0403 | X-ROW | SCP0006_ProjectRoute.spdBOM_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.spdBOM_CellDoubleClick: 진입점 집계 9검사 — NOT_RUN:7 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0006_ProjectRoute.spdBOM_CellDoub) |
| WK-SCP0006-0404 | X-ROW | SCP0006_ProjectRoute.spdPlant_CellDouble | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.spdPlant_CellDoubleClick: 진입점 집계 8검사 — NOT_RUN:6 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0006_ProjectRoute.spdPlant_CellDo) |
| WK-SCP0006-0405 | X-ROW | SCP0006_ProjectRoute.spdPlant_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.spdPlant_Change: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/EXPR, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0006_ProjectRoute.spdPlant_Change) |
| WK-SCP0006-0406 | X-ROW | SCP0006_ProjectRoute.spdSite_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0006_ProjectRoute.spdSite_CellDoubleClick: 진입점 집계 7검사 — NOT_RUN:5 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0006_ProjectRoute.spdSite_CellDou) |
| WK-SCP0006-0407 | X-ROW | splitContainer1(Horizontal) + splitConta | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — splitContainer1(Horizontal) + splitContainer2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (splitContainer1(Horizontal) + splitConta) |
| WK-SCP0006-0408 | G5 | A2 spdSite_CellDoubleClick → BOM 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — A2 spdSite_CellDoubleClick → BOM 조회: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (A2 spdSite_CellDoubleClick → BOM 조회) |
| WK-SCP0006-0409 | G5 | A3 spdBOM_CellDoubleClick → Plant 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — A3 spdBOM_CellDoubleClick → Plant 조회: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (A3 spdBOM_CellDoubleClick → Plant 조회) |
| WK-SCP0006-0410 | G5 | A5 spdPlant_CellDoubleClick → CAPA(SCP00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — A5 spdPlant_CellDoubleClick → CAPA(SCP0049): 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (A5 spdPlant_CellDoubleClick → CAPA(SCP00) |
| WK-SCP0006-0411 | G5 | SCP0006_ProjectRoute.spdBOM_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0006_ProjectRoute.spdBOM_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0006_ProjectRoute.spdBOM_CellDoub) |
| WK-SCP0006-0412 | G5 | SCP0006_ProjectRoute.spdPlant_CellDouble | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0006_ProjectRoute.spdPlant_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SCP0006_ProjectRoute.spdPlant_CellDo) |
| WK-SCP0006-0413 | G5 | SCP0006_ProjectRoute.spdSite_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0006_ProjectRoute.spdSite_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0006_ProjectRoute.spdSite_CellDou) |
| WK-SCP0006-0414 | H6 | A2 spdSite_CellDoubleClick → BOM 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — A2 spdSite_CellDoubleClick → BOM 조회: 행 집계 — H6 2요소: NOT_RUN:1 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (A2 spdSite_CellDoubleClick → BOM 조회) |
| WK-SCP0006-0415 | H6 | A3 spdBOM_CellDoubleClick → Plant 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — A3 spdBOM_CellDoubleClick → Plant 조회: 행 집계 — H6 2요소: NOT_RUN:1 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (A3 spdBOM_CellDoubleClick → Plant 조회) |
| WK-SCP0006-0416 | H6 | A5 spdPlant_CellDoubleClick → CAPA(SCP00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — A5 spdPlant_CellDoubleClick → CAPA(SCP0049): 행 집계 — H6 2요소: NOT_RUN:1 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (A5 spdPlant_CellDoubleClick → CAPA(SCP00) |
| WK-SCP0006-0417 | H6 | SCP0006_ProjectRoute.spdBOM_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0006_ProjectRoute.spdBOM_CellDoubleClick: 진입점 집계 — H6 2요소: NOT_RUN:1 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0006_ProjectRoute.spdBOM_CellDoub) |
| WK-SCP0006-0418 | H6 | SCP0006_ProjectRoute.spdPlant_CellDouble | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0006_ProjectRoute.spdPlant_CellDoubleClick: 진입점 집계 — H6 2요소: NOT_RUN:1 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SCP0006_ProjectRoute.spdPlant_CellDo) |
| WK-SCP0006-0419 | H6 | SCP0006_ProjectRoute.spdSite_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0006_ProjectRoute.spdSite_CellDoubleClick: 진입점 집계 — H6 2요소: NOT_RUN:1 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0006_ProjectRoute.spdSite_CellDou) |
| WK-SCP0006-0420 | M4 | A2 spdSite_CellDoubleClick → BOM 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — A2 spdSite_CellDoubleClick → BOM 조회: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (A2 spdSite_CellDoubleClick → BOM 조회) |
| WK-SCP0006-0421 | M4 | A3 spdBOM_CellDoubleClick → Plant 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — A3 spdBOM_CellDoubleClick → Plant 조회: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (A3 spdBOM_CellDoubleClick → Plant 조회) |
| WK-SCP0006-0422 | M4 | A5 spdPlant_CellDoubleClick → CAPA(SCP00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — A5 spdPlant_CellDoubleClick → CAPA(SCP0049): 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (A5 spdPlant_CellDoubleClick → CAPA(SCP00) |
| WK-SCP0006-0423 | M4 | SCP0006_ProjectRoute.spdBOM_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0006_ProjectRoute.spdBOM_CellDoubleClick: 진입점 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0006_ProjectRoute.spdBOM_CellDoub) |
| WK-SCP0006-0424 | M4 | SCP0006_ProjectRoute.spdPlant_CellDouble | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0006_ProjectRoute.spdPlant_CellDoubleClick: 진입점 집계 — M4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SCP0006_ProjectRoute.spdPlant_CellDo) |
| WK-SCP0006-0425 | M4 | SCP0006_ProjectRoute.spdSite_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0006_ProjectRoute.spdSite_CellDoubleClick: 진입점 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0006_ProjectRoute.spdSite_CellDou) |

## W8 구현 후 검증 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0006-0426 | A5 | R-OSCLR 외주 PACKER 클리어(MSG00226) | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 R-OSCLR 외주 PACKER 클리어(MSG00226) 구현 후 검증 · 대상 R-OSCLR 외주 PACKER 클리어(MSG00226) |  | 1 (R-OSCLR 외주 PACKER 클리어(MSG00226)) |
| WK-SCP0006-0427 | H2 | R-OSCLR 외주 PACKER 클리어(MSG00226) | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 R-OSCLR 외주 PACKER 클리어(MSG00226) 구현 후 검증 · 대상 R-OSCLR 외주 PACKER 클리어(MSG00226) |  | 1 (R-OSCLR 외주 PACKER 클리어(MSG00226)) |
| WK-SCP0006-0428 | H5 | R-OSCLR 외주 PACKER 클리어(MSG00226) | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 R-OSCLR 외주 PACKER 클리어(MSG00226) 구현 후 검증 · 대상 R-OSCLR 외주 PACKER 클리어(MSG00226) |  | 1 (R-OSCLR 외주 PACKER 클리어(MSG00226)) |
| WK-SCP0006-0429 | E3 | MSG00226 (N0) | 선행 W1 완료 후 E2E | E3 — 대조표 미구현 행 MSG00226 (N0) 구현 후 검증 · 대상 MSG00226 (N0) |  | 1 (MSG00226 (N0)) |
| WK-SCP0006-0430 | E3 | R-OSCLR 외주 PACKER 클리어(MSG00226) | 선행 W1 완료 후 E2E | E3 — 대조표 미구현 행 R-OSCLR 외주 PACKER 클리어(MSG00226) 구현 후 검증 · 대상 R-OSCLR 외주 PACKER 클리어(MSG00226) |  | 1 (R-OSCLR 외주 PACKER 클리어(MSG00226)) |
