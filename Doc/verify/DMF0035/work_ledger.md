# 작업 원장 — DMF0035 · 2026-10-26 12:50

> 검사 인스턴스 672건 중 PASS·NA 88건 외 **584건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 25 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 47 | 구현 위치 실존 |
| W4 | 검사기 구현 | 4 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 23 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 126 | 실행 → PASS |
| W7 | 기대값 확정 | 329 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 30 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 328 · E2E 126 · 대조표 48 · 선행 W1 완료 후 E2E 30 · 하네스 27 · FE 23 · DB 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 11건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 78 | 17 |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 47 |  |  |  |  | 24 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G1 | GEN |  |  |  |  |  | 18 | 19 | 4 |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 37 | 3 |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A5 | DESIGN |  |  |  |  |  | 1 | 32 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | DESIGN |  |  |  |  | 2 | 17 | 8 | 2 |  | 조회조건 표시·라벨·활성 |
| H2 | DESIGN |  |  |  |  |  | 1 | 27 | 1 |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 4 | 24 |  |  | 라벨 명칭 |
| G6 | GEN |  |  |  |  |  | 17 | 8 | 2 |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-NOTIMPL | GEN | 25 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| E4 | EDIT |  |  |  |  |  | 17 | 6 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F4 | DB |  |  |  |  |  | 16 | 3 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B4 | COMBO |  |  |  |  | 4 |  | 14 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 4 |  |  | 13 |  |  | 콤보 후보 정렬 = AS-IS |
| C3 | CASCADE |  |  |  |  |  | 1 | 16 |  |  | 연쇄 자동 채움 |
| DB-SYN | DB |  |  |  |  | 9 |  | 3 |  |  | BE 계정 시노님·권한·대상 객체 |
| C1 | CASCADE |  |  |  |  |  | 10 | 1 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G5 | POPUP |  |  |  |  | 4 |  | 3 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 | 3 | 3 |  |  | 팝업 표준·열림 |
| A6 | GEN |  |  |  |  |  | 6 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| D5 | EDIT |  |  |  |  |  | 1 | 5 |  |  | 셀 에디터 유형 |
| M4 | POPUP |  |  |  |  |  | 3 | 3 |  |  | 팝업 선택값 반영 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-REASON | DESIGN |  |  |  |  |  |  | 1 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| E1 | EDIT |  |  |  |  |  |  |  | 1 |  | 숫자 소수자리·정수·부호·범위 |

## W1 기능 구현 (25)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0035-0001 | X-NOTIMPL | MODAL:WaterfallVersionModal | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — MODAL:WaterfallVersionModal FE 실존 모달 (components/WaterfallVersionModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입)   미구현 |  | 1 (MODAL:WaterfallVersionModal) |
| WK-DMF0035-0002 | X-NOTIMPL | REQ:CHAT-20260831-W01 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W01 Div Default 선택안됨·변경 시 초기화 안됨 (+Layout 조회상태 한정이면 초기화 시 빈값, Grid 초기화)   미구현 |  | 1 (REQ:CHAT-20260831-W01) |
| WK-DMF0035-0003 | X-NOTIMPL | REQ:CHAT-20260831-W03 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W03 div 선택 시 Biz.Type/Plant Site cascade 누락   미구현 |  | 1 (REQ:CHAT-20260831-W03) |
| WK-DMF0035-0004 | X-NOTIMPL | REQ:CHAT-20260831-W04 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W04 82 선택 시 Plant Site 활성화   미구현 |  | 1 (REQ:CHAT-20260831-W04) |
| WK-DMF0035-0005 | X-NOTIMPL | REQ:CHAT-20260831-W05 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W05 81 일때만 Sender Code 활성 (JV 비활성)   미구현 |  | 1 (REQ:CHAT-20260831-W05) |
| WK-DMF0035-0006 | X-NOTIMPL | REQ:CHAT-20260831-W07 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W07 waterfall type 변경 시 전체 초기화 (+Layout 빈값 세부)   미구현 |  | 1 (REQ:CHAT-20260831-W07) |
| WK-DMF0035-0007 | X-NOTIMPL | REQ:CHAT-20260831-W08 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W08 초기화 시 종료일자 잘못됨 (6개월)   미구현 |  | 1 (REQ:CHAT-20260831-W08) |
| WK-DMF0035-0008 | X-NOTIMPL | REQ:CHAT-20260831-W09 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W09 sort/filter 적용 가능 확인 후 적용   미구현 |  | 1 (REQ:CHAT-20260831-W09) |
| WK-DMF0035-0009 | X-NOTIMPL | REQ:CHAT-20260831-W10 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W10 Menu context 적용 여부 확인 후 적용   미구현 |  | 1 (REQ:CHAT-20260831-W10) |
| WK-DMF0035-0010 | X-NOTIMPL | REQ:CHAT-20260831-W12 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W12 Measure 항목 안 보임 (VISIBLE/DEFAULT Y 시 보임·Layout 에서 Measure 제외) + sales plan SQL 오류   미구현 |  | 1 (REQ:CHAT-20260831-W12) |
| WK-DMF0035-0011 | X-NOTIMPL | REQ:CHAT-20260831-W13 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W13 컬럼 영역 클릭 안 됨   미구현 |  | 1 (REQ:CHAT-20260831-W13) |
| WK-DMF0035-0012 | X-NOTIMPL | REQ:CHAT-20260831-W14 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W14 컬럼을 filter 영역으로 이동 시 동작 확인 (현재 안 보임)   미구현 |  | 1 (REQ:CHAT-20260831-W14) |
| WK-DMF0035-0013 | X-NOTIMPL | REQ:CHAT-20260831-W15 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W15 엑셀 다운로드 Column 영역 포함(보이는 대로) + 파일명에 waterfall type   미구현 |  | 1 (REQ:CHAT-20260831-W15) |
| WK-DMF0035-0014 | X-NOTIMPL | REQ:CHAT-20260831-W16 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W16 DATA 영역 SORT 기능 삭제   미구현 |  | 1 (REQ:CHAT-20260831-W16) |
| WK-DMF0035-0015 | X-NOTIMPL | REQ:CHAT-20260831-W17 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W17 DATA 영역 소수점 삭제   미구현 |  | 1 (REQ:CHAT-20260831-W17) |
| WK-DMF0035-0016 | X-NOTIMPL | REQ:CHAT-20260831-W18 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W18 DATA 클릭 시 마지막 컬럼 TEXT BOLD 삭제   미구현 |  | 1 (REQ:CHAT-20260831-W18) |
| WK-DMF0035-0017 | X-NOTIMPL | REQ:CHAT-20260831-W19 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W19 GRID 표준 CSS 공통 적용 (영역 색 구분 제거·폰트)   미구현 |  | 1 (REQ:CHAT-20260831-W19) |
| WK-DMF0035-0018 | X-NOTIMPL | REQ:CHAT-20260831-W20 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W20 waterfall type 별 UI CATEGORY FIX/WIDTH 적용 (가능여부 판단)   미구현 |  | 1 (REQ:CHAT-20260831-W20) |
| WK-DMF0035-0019 | X-NOTIMPL | REQ:CHAT-20260831-W21 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W21 Waterfall type 별 AS-IS 건수·합계 차이   미구현 |  | 1 (REQ:CHAT-20260831-W21) |
| WK-DMF0035-0020 | X-NOTIMPL | REQ:CHAT-20260831-W22 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W22 DIV 82/Sales plan(Biz plan 동일) Plant Site 비활성 — AS-IS 활성   미구현 |  | 1 (REQ:CHAT-20260831-W22) |
| WK-DMF0035-0021 | X-NOTIMPL | REQ:CHAT-20260831-W23 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W23 KRW/USD/LOC 표시값 AS-IS 통일 (KRW/1, KRW/1,000 …)   미구현 |  | 1 (REQ:CHAT-20260831-W23) |
| WK-DMF0035-0022 | X-NOTIMPL | REQ:CHAT-20260831-W24 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W24 Cell QTY 조회조건 — 40만 활성, 나머지 비활성   미구현 |  | 1 (REQ:CHAT-20260831-W24) |
| WK-DMF0035-0023 | X-NOTIMPL | REQ:CHAT-20260831-W25 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260831-W25 MKT FCST TYPE 조회조건 LAYOUT 을 Sales plan/Biz 와 통일 (Project/Plant Site 접힘 영역 배치)   미구현 |  | 1 (REQ:CHAT-20260831-W25) |
| WK-DMF0035-0024 | X-NOTIMPL | REQ:CHAT-20260901-X12 | DB(🛠️/🧯 적용 가능) | 대조표 미구현 행 구현 — REQ:CHAT-20260901-X12 클라우드 DMF0035 MKT FCST 조회 누락 — CUST_FCST 종속메저 미출력(446 vs 247) + 40 기준 97건 차 EV:_artifacts/_dep |  | 1 (REQ:CHAT-20260901-X12) |
| WK-DMF0035-0025 | X-NOTIMPL | REQ:CHAT-20260901-X13 | DB(🛠️/🧯 적용 가능) | 대조표 미구현 행 구현 — REQ:CHAT-20260901-X13 PKG_DMF0035 SEL_MEASURE division 필터가 ROWNUM=1 임의 1행 기준 (잠재 결함) (미정) 원장 PENDING — 현재 ROWNUM=1  |  | 1 (REQ:CHAT-20260901-X13) |

## W2 구현 위치 확인 (47)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0035-0026 | X-LOC | (MSG00109) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((MSG00109)) |
| WK-DMF0035-0027 | X-LOC | (신규) GUBUN | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((신규) GUBUN) |
| WK-DMF0035-0028 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-DMF0035-0029 | X-LOC | InternalYN (0022) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (InternalYN (0022)) |
| WK-DMF0035-0030 | X-LOC | MSG00013 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00013) |
| WK-DMF0035-0031 | X-LOC | MSG00097 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00097) |
| WK-DMF0035-0032 | X-LOC | MSG00108 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00108) |
| WK-DMF0035-0033 | X-LOC | MSG00137 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00137) |
| WK-DMF0035-0034 | X-LOC | MSG00164 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00164) |
| WK-DMF0035-0035 | X-LOC | REQ:CHAT-20260828-C1-DMF0035 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx 없음 |  | 1 (REQ:CHAT-20260828-C1-DMF0035) |
| WK-DMF0035-0036 | X-LOC | REQ:CHAT-20260828-C2-DMF0035 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx 없음 |  | 1 (REQ:CHAT-20260828-C2-DMF0035) |
| WK-DMF0035-0037 | X-LOC | REQ:CHAT-20260828-C3-DMF0035 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx 없음, |  | 1 (REQ:CHAT-20260828-C3-DMF0035) |
| WK-DMF0035-0038 | X-LOC | REQ:CHAT-20260828-C4-DMF0035 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.t |  | 1 (REQ:CHAT-20260828-C4-DMF0035) |
| WK-DMF0035-0039 | X-LOC | REQ:CHAT-20260828-UM02-DMF0035 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260828-UM02-DMF0035) |
| WK-DMF0035-0040 | X-LOC | REQ:CHAT-20260828-UM05-DMF0035 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260828-UM05-DMF0035) |
| WK-DMF0035-0041 | X-LOC | REQ:CHAT-20260828-UM08-DMF0035 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260828-UM08-DMF0035) |
| WK-DMF0035-0042 | X-LOC | REQ:CHAT-20260831-W02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W02) |
| WK-DMF0035-0043 | X-LOC | REQ:CHAT-20260831-W06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W06) |
| WK-DMF0035-0044 | X-LOC | REQ:CHAT-20260831-W11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W11) |
| WK-DMF0035-0045 | X-LOC | REQ:CHAT-20260831-W26 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W26) |
| WK-DMF0035-0046 | X-LOC | REQ:CHAT-20260831-W27 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W27) |
| WK-DMF0035-0047 | X-LOC | REQ:CHAT-20260831-W28 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W28) |
| WK-DMF0035-0048 | X-LOC | REQ:CHAT-20260831-W29 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W29) |
| WK-DMF0035-0049 | X-LOC | REQ:CHAT-20260831-W30 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W30) |
| WK-DMF0035-0050 | X-LOC | REQ:CHAT-20260831-W31 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W31) |
| WK-DMF0035-0051 | X-LOC | REQ:CHAT-20260831-W32 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W32) |
| WK-DMF0035-0052 | X-LOC | REQ:CHAT-20260831-W33 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W33) |
| WK-DMF0035-0053 | X-LOC | REQ:CHAT-20260831-W35 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W35) |
| WK-DMF0035-0054 | X-LOC | REQ:CHAT-20260831-W36 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W36) |
| WK-DMF0035-0055 | X-LOC | REQ:CHAT-20260831-W37 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W37) |
| WK-DMF0035-0056 | X-LOC | REQ:CHAT-20260831-W38 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.m |  | 1 (REQ:CHAT-20260831-W38) |
| WK-DMF0035-0057 | X-LOC | REQ:CHAT-20260831-W39 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W39) |
| WK-DMF0035-0058 | X-LOC | REQ:CHAT-20260831-W40 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W40) |
| WK-DMF0035-0059 | X-LOC | REQ:CHAT-20260831-W44 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W44) |
| WK-DMF0035-0060 | X-LOC | REQ:CHAT-20260831-W45 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260831-W45) |
| WK-DMF0035-0061 | X-LOC | UM-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/olap-field-rail/OlapFieldRail.tsx 없음 |  | 1 (UM-07) |
| WK-DMF0035-0062 | X-LOC | cboBucketType | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboBucketType) |
| WK-DMF0035-0063 | X-LOC | cboCellQty | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboCellQty) |
| WK-DMF0035-0064 | X-LOC | cboDivision(필수) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboDivision(필수)) |
| WK-DMF0035-0065 | X-LOC | cboKRW/USD/LOC/QTY | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboKRW/USD/LOC/QTY) |
| WK-DMF0035-0066 | X-LOC | cbxQty "Qty≠0" (0051) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cbxQty "Qty≠0" (0051)) |
| WK-DMF0035-0067 | X-LOC | chkSum/chkColor(chkMem) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (chkSum/chkColor(chkMem)) |
| WK-DMF0035-0068 | X-LOC | clbEDISender (0035, div81만) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbEDISender (0035, div81만)) |
| WK-DMF0035-0069 | X-LOC | clbTeam/Customer/SalesSite/PlantSite/Biz | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbTeam/Customer/SalesSite/PlantSite/Biz) |
| WK-DMF0035-0070 | X-LOC | drpPeriod | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (drpPeriod) |
| WK-DMF0035-0071 | X-LOC | txtProject/ItemId/Owner + 팝업 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtProject/ItemId/Owner + 팝업) |
| WK-DMF0035-0072 | X-LOC | txtVersion + 팝업 3종 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtVersion + 팝업 3종) |

## W4 검사기 구현 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0035-0073 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 3 (cboBucketType ACT:DMF0035_MktFcstWaterfa) |
| WK-DMF0035-0074 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 2 (ACT:DMF0035_MktFcstWaterfall.GetSpdTitle) |
| WK-DMF0035-0075 | B3 | clbCustomer / End Customer / Customer | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbCustomer / End Customer / Customer | 있음(FE 소스) | 1 (ACT:DMF0035_MktFcstWaterfall.clbTeam_Sel) |
| WK-DMF0035-0076 | B3 | drpPeriod / Period | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 drpPeriod / Period | 있음(FE 소스) | 2 (ACT:DMF0035_MktFcstWaterfall.GetSpdTitle) |

## W5 검사기 연결 (23)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0035-0077 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 3 (cboBucketType ACT:DMF0035_MktFcstWaterfa) |
| WK-DMF0035-0078 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:DMF0035_MktFcstWaterfall.GetSpdTitle) |
| WK-DMF0035-0079 | B4 | clbCustomer / End Customer / Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbCustomer / End Customer / Customer | 있음(FE 소스) | 1 (ACT:DMF0035_MktFcstWaterfall.clbTeam_Sel) |
| WK-DMF0035-0080 | B4 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 2 (ACT:DMF0035_MktFcstWaterfall.GetSpdTitle) |
| WK-DMF0035-0081 | F2 | DMF0035 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0035 화면 | 판단불가(대상 단위 SCREEN) | 5 (COMMON:UC-03 REQ:CHAT-20260831-W44 REQ:C) |
| WK-DMF0035-0082 | F6 | DMF0035 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN DMF0035 화면 | 판단불가(대상 단위 SCREEN) | 1 (version (SAVE)) |
| WK-DMF0035-0083 | DB-SYN | DM0035_GET_MKT_FCST_WATERFALL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0035_GET_MKT_FCST_WATERFALL | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0035_MktFcstWaterfall.FindData:10) |
| WK-DMF0035-0084 | DB-SYN | DMF0003_GET_QTY_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0003_GET_QTY_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0035_MktFcstWaterfall.GetQtyData:) |
| WK-DMF0035-0085 | DB-SYN | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0035_MktFcstWaterfall.GetBucketTy) |
| WK-DMF0035-0086 | DB-SYN | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0035_MktFcstWaterfall.GetBizTypeb) |
| WK-DMF0035-0087 | DB-SYN | SCM0001_GET_CUSTOMER_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_CUSTOMER_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0035_MktFcstWaterfall.GetCustomer) |
| WK-DMF0035-0088 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0035_MktFcstWaterfall.GetItemType) |
| WK-DMF0035-0089 | DB-SYN | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0035_MktFcstWaterfall.GetPlantSit) |
| WK-DMF0035-0090 | DB-SYN | SCM0001_GET_SITE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SITE_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0035_MktFcstWaterfall.GetScmSiteb) |
| WK-DMF0035-0091 | DB-SYN | SCM0001_GET_TEAM_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_TEAM_BY_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0035_MktFcstWaterfall.GetTeambyDi) |
| WK-DMF0035-0092 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 없음 | 2 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0093 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 없음 | 2 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0094 | G03-WIRE | DMF0035 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0035 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:DMF0035_MktFcstWaterfall..ctor ACT:D) |
| WK-DMF0035-0095 | G5 | M | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL M | 있음(FE 소스) | 1 (REQ:CHAT-20260902-W46) |
| WK-DMF0035-0096 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:DMF0035_MktFcstWaterfall.btnColumn_C) |
| WK-DMF0035-0097 | G5 | txtProject / Project | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtProject / Project | 있음(FE 소스) | 1 (txtProject/ItemId/Owner + 팝업) |
| WK-DMF0035-0098 | G5 | txtVersion / Version | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtVersion / Version | 있음(FE 소스) | 1 (txtVersion + 팝업 3종) |
| WK-DMF0035-0099 | H6 | M | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL M | 있음(FE 소스) | 1 (REQ:CHAT-20260902-W46) |

## W6 검증 실행 (126)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0035-0100 | J2 | DMF0035 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0035 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 107 (REQ:CHAT-20260828-C1-DMF0035 REQ:CHAT-20) |
| WK-DMF0035-0101 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0102 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 6 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0103 | C1 | cboQTY / QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboQTY / QTY · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0104 | C1 | clbBizType / Biz Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbBizType / Biz Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0105 | C1 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 6 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0106 | C1 | clbEDISender / Sender Code / EDISender | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbEDISender / Sender Code / EDISender · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0107 | C1 | clbItemType / Item Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbItemType / Item Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0108 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0109 | C1 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 5 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0110 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0111 | C3 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0112 | G3 | DMF0035 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — DMF0035 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (COMMON:UC-03 COMMON:UC-05 COMMON:UC-06 C) |
| WK-DMF0035-0113 | K4 | DMF0035 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0035 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 70 (COMMON:UC-03 COMMON:UC-05 COMMON:UC-06 C) |
| WK-DMF0035-0114 | F1 | DMF0035 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0035 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 9 (COMMON:UC-03 REQ:CHAT-20260831-W16 REQ:C) |
| WK-DMF0035-0115 | F5 | DMF0035 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0035 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 4 (REQ:CHAT-20260831-W16 REQ:CHAT-20260831-) |
| WK-DMF0035-0116 | F4 | DM0035_GET_MKT_FCST_WATERFALL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0035_GET_MKT_FCST_WATERFALL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 61 (ACT:DMF0035_MktFcstWaterfall.FindButton ) |
| WK-DMF0035-0117 | F4 | DMF0003_GET_QTY_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0003_GET_QTY_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetQtyData:) |
| WK-DMF0035-0118 | F4 | DMF0003_GET_REPORT_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0003_GET_REPORT_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetBucketTy) |
| WK-DMF0035-0119 | F4 | DMF0073_GET_VERSION_SALESPRICE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0073_GET_VERSION_SALESPRICE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 1 (version) |
| WK-DMF0035-0120 | F4 | PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_P | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERF · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 1 (salesPlanWaterfall) |
| WK-DMF0035-0121 | F4 | PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 |  | 63 (mktFcstWaterfall ACT:DMF0035_MktFcstWate) |
| WK-DMF0035-0122 | F4 | PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 62 (ACT:DMF0035_MktFcstWaterfall.FindButton ) |
| WK-DMF0035-0123 | F4 | PKG_DMF0035.P_DMF0035_SAVE_VERSION_MRF | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0035.P_DMF0035_SAVE_VERSION_MRF · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 1 (version (SAVE)) |
| WK-DMF0035-0124 | F4 | PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFAL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 1 (bizPlanWaterfall) |
| WK-DMF0035-0125 | F4 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_BIZ_TYPE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetBizTypeb) |
| WK-DMF0035-0126 | F4 | SCM0001_GET_CUSTOMER_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_CUSTOMER_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetCustomer) |
| WK-DMF0035-0127 | F4 | SCM0001_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetDivision) |
| WK-DMF0035-0128 | F4 | SCM0001_GET_LOOKUP_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetItemType) |
| WK-DMF0035-0129 | F4 | SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetPlantSit) |
| WK-DMF0035-0130 | F4 | SCM0001_GET_SITE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_SITE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetScmSiteb) |
| WK-DMF0035-0131 | F4 | SCM0001_GET_TEAM_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_TEAM_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetTeambyDi) |
| WK-DMF0035-0132 | A5 | C | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — C · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (동적 PIVOT + titleset 'C' 고정컬럼 **GRID COLU) |
| WK-DMF0035-0133 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 15 (cboBucketType ACT:DMF0035_MktFcstWaterfa) |
| WK-DMF0035-0134 | G4 | cboCellQty / Cell Qty | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboCellQty / Cell Qty · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboCellQty ACT:DMF0035_MktFcstWaterfall.) |
| WK-DMF0035-0135 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 25 (cboDivision(필수) ACT:DMF0035_MktFcstWater) |
| WK-DMF0035-0136 | G4 | cboQTY / QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboQTY / QTY · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0137 | G4 | chkColor / Color | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkColor / Color · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (chkSum/chkColor(chkMem) ACT:DMF0035_MktF) |
| WK-DMF0035-0138 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 9 (chkSum/chkColor(chkMem) ACT:DMF0035_MktF) |
| WK-DMF0035-0139 | G4 | clbBizType / Biz Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbBizType / Biz Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0140 | G4 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0141 | G4 | clbEDISender / Sender Code / EDISender | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbEDISender / Sender Code / EDISender · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (clbEDISender (0035, div81만) ACT:DMF0035_) |
| WK-DMF0035-0142 | G4 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbItemType / Item Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0143 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0144 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0145 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (clbTeam/Customer/SalesSite/PlantSite/Biz) |
| WK-DMF0035-0146 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (drpPeriod ACT:DMF0035_MktFcstWaterfall.F) |
| WK-DMF0035-0147 | G4 | txtItemId / Model / Nickname / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0148 | G4 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (txtProject/ItemId/Owner + 팝업 ACT:DMF0035) |
| WK-DMF0035-0149 | G4 | txtVersion / Version | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtVersion / Version · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtVersion + 팝업 3종) |
| WK-DMF0035-0150 | H2 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (동적 PIVOT + titleset 'C' 고정컬럼 **GRID COLU) |
| WK-DMF0035-0151 | H4 | DMF0035 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0035 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 6 (REQ:CHAT-20260831-W38 **세로 셀 병합(SmartCol) |
| WK-DMF0035-0152 | H5 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — C · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (동적 PIVOT + titleset 'C' 고정컬럼 **GRID COLU) |
| WK-DMF0035-0153 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 26 (ACT:DMF0035_MktFcstWaterfall.InitSpread ) |
| WK-DMF0035-0154 | H5 | chkColor / Color | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkColor / Color · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 20 (chkColor 회색 실적구간 ACT:DMF0035_MktFcstWate) |
| WK-DMF0035-0155 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 9 (ACT:DMF0035_MktFcstWaterfall.InitSpread ) |
| WK-DMF0035-0156 | I1 | DMF0035 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0035 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 12 (drpPeriod MSG00137 MSG00097 MSG00013 MSG) |
| WK-DMF0035-0157 | SC1 | DMF0035 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — DMF0035 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 19 (COMMON:UC-06 REQ:CHAT-20260831-W36 REQ:C) |
| WK-DMF0035-0158 | D5 | C | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — C · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0159 | D6 | DMF0035 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0035 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 3 (COMMON:UC-03 REQ:CHAT-20260831-W30 REQ:C) |
| WK-DMF0035-0160 | E4 | C | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — C · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0161 | E4 | MSG00013 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00013 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00013) |
| WK-DMF0035-0162 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00097 ACT:DMF0035_MktFcstWaterfall.Fi) |
| WK-DMF0035-0163 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00108 ACT:DMF0035_MktFcstWaterfall.Fi) |
| WK-DMF0035-0164 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 ((MSG00109) ACT:DMF0035_MktFcstWaterfall.) |
| WK-DMF0035-0165 | E4 | MSG00137 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00137 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00137) |
| WK-DMF0035-0166 | E4 | MSG00164 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00164 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (drpPeriod MSG00164 ACT:DMF0035_MktFcstWa) |
| WK-DMF0035-0167 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 18 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0168 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:DMF0035_MktFcstWaterfall.SetClbVersi) |
| WK-DMF0035-0169 | E4 | cboQTY / QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboQTY / QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 15 (ACT:DMF0035_MktFcstWaterfall.SetAmountCa) |
| WK-DMF0035-0170 | E4 | chkColor / Color | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkColor / Color · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 19 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0171 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0172 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:DMF0035_MktFcstWaterfall.SetClbVersi) |
| WK-DMF0035-0173 | E4 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:DMF0035_MktFcstWaterfall.SetClbVersi) |
| WK-DMF0035-0174 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (drpPeriod ACT:DMF0035_MktFcstWaterfall.F) |
| WK-DMF0035-0175 | E4 | txtItemId / Model / Nickname / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지· |  | 2 (ACT:DMF0035_MktFcstWaterfall.SetClbVersi) |
| WK-DMF0035-0176 | E4 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 2 (ACT:DMF0035_MktFcstWaterfall.SetClbVersi) |
| WK-DMF0035-0177 | A10 | DMF0035 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0035 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 93 (ACT:DMF0035_MktFcstWaterfall.DefinePrope) |
| WK-DMF0035-0178 | A6 | DM0035_GET_MKT_FCST_WATERFALL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DM0035_GET_MKT_FCST_WATERFALL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.sp |  | 61 (ACT:DMF0035_MktFcstWaterfall.FindButton ) |
| WK-DMF0035-0179 | A6 | DMF0073_GET_VERSION_SALESPRICE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0073_GET_VERSION_SALESPRICE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.s |  | 1 (version) |
| WK-DMF0035-0180 | A6 | PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_P | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERF · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 1 (salesPlanWaterfall) |
| WK-DMF0035-0181 | A6 | PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATER | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로  |  | 63 (mktFcstWaterfall ACT:DMF0035_MktFcstWate) |
| WK-DMF0035-0182 | A6 | PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 60 (ACT:DMF0035_MktFcstWaterfall.FindButton ) |
| WK-DMF0035-0183 | A6 | PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFAL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 1 (bizPlanWaterfall) |
| WK-DMF0035-0184 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboBucketType ACT:DMF0035_MktFcstWaterfa) |
| WK-DMF0035-0185 | G1 | cboCellQty / Cell Qty | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboCellQty / Cell Qty · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboCellQty ACT:DMF0035_MktFcstWaterfall.) |
| WK-DMF0035-0186 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboDivision(필수) ACT:DMF0035_MktFcstWater) |
| WK-DMF0035-0187 | G1 | cboQTY / QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboQTY / QTY · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0035_MktFcstWaterfall.FindData AC) |
| WK-DMF0035-0188 | G1 | chkColor / Color | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkColor / Color · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (chkSum/chkColor(chkMem)) |
| WK-DMF0035-0189 | G1 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkSum / Sum · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (chkSum/chkColor(chkMem)) |
| WK-DMF0035-0190 | G1 | clbBizType / Biz Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbBizType / Biz Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0035_MktFcstWaterfall.FindData AC) |
| WK-DMF0035-0191 | G1 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0035_MktFcstWaterfall.FindData AC) |
| WK-DMF0035-0192 | G1 | clbEDISender / Sender Code / EDISender | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbEDISender / Sender Code / EDISender · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbEDISender (0035, div81만) ACT:DMF0035_) |
| WK-DMF0035-0193 | G1 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbItemType / Item Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0035_MktFcstWaterfall.FindData AC) |
| WK-DMF0035-0194 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0035_MktFcstWaterfall.FindData AC) |
| WK-DMF0035-0195 | G1 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0035_MktFcstWaterfall.FindData AC) |
| WK-DMF0035-0196 | G1 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (clbTeam/Customer/SalesSite/PlantSite/Biz) |
| WK-DMF0035-0197 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 7 (drpPeriod ACT:DMF0035_MktFcstWaterfall.F) |
| WK-DMF0035-0198 | G1 | txtItemId / Model / Nickname / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0035_MktFcstWaterfall.FindData AC) |
| WK-DMF0035-0199 | G1 | txtOwner / Owner | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtOwner / Owner · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0035_MktFcstWaterfall.FindData AC) |
| WK-DMF0035-0200 | G1 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtProject/ItemId/Owner + 팝업 ACT:DMF0035) |
| WK-DMF0035-0201 | G1 | txtVersion / Version | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtVersion / Version · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (txtVersion + 팝업 3종 ACT:DMF0035_MktFcstWa) |
| WK-DMF0035-0202 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 15 (cboBucketType ACT:DMF0035_MktFcstWaterfa) |
| WK-DMF0035-0203 | G6 | cboCellQty / Cell Qty | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboCellQty / Cell Qty · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboCellQty ACT:DMF0035_MktFcstWaterfall.) |
| WK-DMF0035-0204 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 25 (cboDivision(필수) ACT:DMF0035_MktFcstWater) |
| WK-DMF0035-0205 | G6 | cboQTY / QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboQTY / QTY · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0206 | G6 | chkColor / Color | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkColor / Color · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (chkSum/chkColor(chkMem) ACT:DMF0035_MktF) |
| WK-DMF0035-0207 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 9 (chkSum/chkColor(chkMem) ACT:DMF0035_MktF) |
| WK-DMF0035-0208 | G6 | clbBizType / Biz Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbBizType / Biz Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0209 | G6 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0210 | G6 | clbEDISender / Sender Code / EDISender | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbEDISender / Sender Code / EDISender · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (clbEDISender (0035, div81만) ACT:DMF0035_) |
| WK-DMF0035-0211 | G6 | clbItemType / Item Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbItemType / Item Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0212 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0213 | G6 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0214 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (clbTeam/Customer/SalesSite/PlantSite/Biz) |
| WK-DMF0035-0215 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (drpPeriod ACT:DMF0035_MktFcstWaterfall.I) |
| WK-DMF0035-0216 | G6 | txtItemId / Model / Nickname / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0217 | G6 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (txtProject/ItemId/Owner + 팝업 ACT:DMF0035) |
| WK-DMF0035-0218 | G6 | txtVersion / Version | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtVersion / Version · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtVersion + 팝업 3종) |
| WK-DMF0035-0219 | X-REOPEN | DMF0035 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0035 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 17 (ACT:DMF0035_MktFcstWaterfall.Dispose ACT) |
| WK-DMF0035-0220 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:DMF0035_MktFcstWaterfall.btnColumn_C) |
| WK-DMF0035-0221 | H6 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtProject / Project · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (txtProject/ItemId/Owner + 팝업) |
| WK-DMF0035-0222 | H6 | txtVersion / Version | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtVersion / Version · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (txtVersion + 팝업 3종) |
| WK-DMF0035-0223 | M4 | M | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — M · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (REQ:CHAT-20260902-W46) |
| WK-DMF0035-0224 | M4 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (txtProject/ItemId/Owner + 팝업) |
| WK-DMF0035-0225 | M4 | txtVersion / Version | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtVersion / Version · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (txtVersion + 팝업 3종) |

## W7 기대값 확정 (329)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0035-0226 | C1 | UM-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — UM-03: 행 집계 — C1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (UM-03) |
| WK-DMF0035-0227 | C3 | DMF0035_MktFcstWaterfall.ClbPlantSite_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.ClbPlantSite_SelectedInde: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.ClbPlantSit) |
| WK-DMF0035-0228 | C3 | DMF0035_MktFcstWaterfall.ClbSalesSite_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.ClbSalesSite_SelectedInde: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.ClbSalesSit) |
| WK-DMF0035-0229 | C3 | DMF0035_MktFcstWaterfall.SetAmountCalcul | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.SetAmountCalculating: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 24 (ACT:DMF0035_MktFcstWaterfall.SetAmountCa) |
| WK-DMF0035-0230 | C3 | DMF0035_MktFcstWaterfall.SetChangeContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.SetChangeControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:DMF0035_MktFcstWaterfall.SetChangeCo) |
| WK-DMF0035-0231 | C3 | DMF0035_MktFcstWaterfall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0232 | C3 | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeader: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0233 | C3 | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeaderSpan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0234 | C3 | DMF0035_MktFcstWaterfall.TxtProject_Chan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.TxtProject_Changed: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.TxtProject_) |
| WK-DMF0035-0235 | C3 | DMF0035_MktFcstWaterfall.cboBucketType_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.cboBucketType_SelectedInd: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:DMF0035_MktFcstWaterfall.cboBucketTy) |
| WK-DMF0035-0236 | C3 | DMF0035_MktFcstWaterfall.cboDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.cboDivision_SelectedIndex: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 38 (ACT:DMF0035_MktFcstWaterfall.cboDivision) |
| WK-DMF0035-0237 | C3 | DMF0035_MktFcstWaterfall.cboQTY_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.cboQTY_SelectedIndexChang: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0035_MktFcstWaterfall.cboQTY_Sele) |
| WK-DMF0035-0238 | C3 | DMF0035_MktFcstWaterfall.chkColor_Checke | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.chkColor_CheckedChanged: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.chkColor_Ch) |
| WK-DMF0035-0239 | C3 | DMF0035_MktFcstWaterfall.chkSum_CheckedC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.chkSum_CheckedChanged: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.chkSum_Chec) |
| WK-DMF0035-0240 | C3 | DMF0035_MktFcstWaterfall.clbCustomer_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.clbCustomer_SelectedIndex: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0035_MktFcstWaterfall.clbCustomer) |
| WK-DMF0035-0241 | C3 | DMF0035_MktFcstWaterfall.clbTeam_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.clbTeam_SelectedIndexChan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:DMF0035_MktFcstWaterfall.clbTeam_Sel) |
| WK-DMF0035-0242 | C3 | DMF0035_MktFcstWaterfall.spdMain_ComboSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0035_MktFcstWaterfall.spdMain_ComboSelChange: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0035_MktFcstWaterfall.spdMain_Com) |
| WK-DMF0035-0243 | B3 | DMF0035_MktFcstWaterfall.GetBizTypebyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetBizTypebyDivision: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0035_MktFcstWaterfall.GetBizTypeb) |
| WK-DMF0035-0244 | B3 | DMF0035_MktFcstWaterfall.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetBucketType: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetBucketTy) |
| WK-DMF0035-0245 | B3 | DMF0035_MktFcstWaterfall.GetCustomerbyDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetCustomerbyDivision: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0035_MktFcstWaterfall.GetCustomer) |
| WK-DMF0035-0246 | B3 | DMF0035_MktFcstWaterfall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetDayRange: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0035_MktFcstWaterfall.GetDayRange) |
| WK-DMF0035-0247 | B3 | DMF0035_MktFcstWaterfall.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetDivision: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetDivision) |
| WK-DMF0035-0248 | B3 | DMF0035_MktFcstWaterfall.GetEdiSender | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetEdiSender: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0035_MktFcstWaterfall.GetEdiSende) |
| WK-DMF0035-0249 | B3 | DMF0035_MktFcstWaterfall.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetItemType: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0035_MktFcstWaterfall.GetItemType) |
| WK-DMF0035-0250 | B3 | DMF0035_MktFcstWaterfall.GetLastWeekSunD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetLastWeekSunDayByDate: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 11 (ACT:DMF0035_MktFcstWaterfall.GetLastWeek) |
| WK-DMF0035-0251 | B3 | DMF0035_MktFcstWaterfall.GetPlantSitebyE | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetPlantSitebyEndCustomer: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.GetPlantSit) |
| WK-DMF0035-0252 | B3 | DMF0035_MktFcstWaterfall.GetQtyData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetQtyData: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetQtyData:) |
| WK-DMF0035-0253 | B3 | DMF0035_MktFcstWaterfall.GetScmSitebyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetScmSitebyDivision: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.GetScmSiteb) |
| WK-DMF0035-0254 | B3 | DMF0035_MktFcstWaterfall.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetSpdTitle: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0035_MktFcstWaterfall.GetSpdTitle) |
| WK-DMF0035-0255 | B3 | DMF0035_MktFcstWaterfall.GetTeambyDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0035_MktFcstWaterfall.GetTeambyDivision: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0035_MktFcstWaterfall.GetTeambyDi) |
| WK-DMF0035-0256 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-DMF0035-0257 | B4 | DMF0035_MktFcstWaterfall.GetBizTypebyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetBizTypebyDivision: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0035_MktFcstWaterfall.GetBizTypeb) |
| WK-DMF0035-0258 | B4 | DMF0035_MktFcstWaterfall.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetBucketType: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetBucketTy) |
| WK-DMF0035-0259 | B4 | DMF0035_MktFcstWaterfall.GetCustomerbyDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetCustomerbyDivision: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0035_MktFcstWaterfall.GetCustomer) |
| WK-DMF0035-0260 | B4 | DMF0035_MktFcstWaterfall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetDayRange: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0035_MktFcstWaterfall.GetDayRange) |
| WK-DMF0035-0261 | B4 | DMF0035_MktFcstWaterfall.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetDivision: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetDivision) |
| WK-DMF0035-0262 | B4 | DMF0035_MktFcstWaterfall.GetEdiSender | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetEdiSender: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0035_MktFcstWaterfall.GetEdiSende) |
| WK-DMF0035-0263 | B4 | DMF0035_MktFcstWaterfall.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetItemType: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0035_MktFcstWaterfall.GetItemType) |
| WK-DMF0035-0264 | B4 | DMF0035_MktFcstWaterfall.GetLastWeekSunD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetLastWeekSunDayByDate: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 11 (ACT:DMF0035_MktFcstWaterfall.GetLastWeek) |
| WK-DMF0035-0265 | B4 | DMF0035_MktFcstWaterfall.GetPlantSitebyE | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetPlantSitebyEndCustomer: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.GetPlantSit) |
| WK-DMF0035-0266 | B4 | DMF0035_MktFcstWaterfall.GetQtyData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetQtyData: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetQtyData:) |
| WK-DMF0035-0267 | B4 | DMF0035_MktFcstWaterfall.GetScmSitebyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetScmSitebyDivision: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.GetScmSiteb) |
| WK-DMF0035-0268 | B4 | DMF0035_MktFcstWaterfall.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetSpdTitle: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0035_MktFcstWaterfall.GetSpdTitle) |
| WK-DMF0035-0269 | B4 | DMF0035_MktFcstWaterfall.GetTeambyDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0035_MktFcstWaterfall.GetTeambyDivision: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0035_MktFcstWaterfall.GetTeambyDi) |
| WK-DMF0035-0270 | DB-SYN | DMF0035_MktFcstWaterfall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0035_MktFcstWaterfall.GetDayRange: 진입점 집계 — DB-SYN 16요소: NOPATH:9 · PASS:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetDayRange) |
| WK-DMF0035-0271 | DB-SYN | DMF0035_MktFcstWaterfall.GetEdiSender | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0035_MktFcstWaterfall.GetEdiSender: 진입점 집계 — DB-SYN 16요소: NOPATH:9 · PASS:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetEdiSende) |
| WK-DMF0035-0272 | DB-SYN | UM-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — UM-05: 행 집계 — DB-SYN 16요소: NOPATH:9 · PASS:7 (미실행 요소가 남아 판정필요) |  | 1 (UM-05) |
| WK-DMF0035-0273 | F4 | DMF0035_MktFcstWaterfall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0035_MktFcstWaterfall.GetDayRange: 진입점 집계 — F4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetDayRange) |
| WK-DMF0035-0274 | F4 | DMF0035_MktFcstWaterfall.GetEdiSender | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0035_MktFcstWaterfall.GetEdiSender: 진입점 집계 — F4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.GetEdiSende) |
| WK-DMF0035-0275 | F4 | UM-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — UM-05: 행 집계 — F4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (UM-05) |
| WK-DMF0035-0276 | A5 | (MSG00109) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — (MSG00109): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 ((MSG00109)) |
| WK-DMF0035-0277 | A5 | **세로 셀 병합(SmartColMerge)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — **세로 셀 병합(SmartColMerge)**: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (**세로 셀 병합(SmartColMerge)**) |
| WK-DMF0035-0278 | A5 | 3단 헤더 병합(LARGE/SMALL/leaf) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 3단 헤더 병합(LARGE/SMALL/leaf): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (3단 헤더 병합(LARGE/SMALL/leaf)) |
| WK-DMF0035-0279 | A5 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-03: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-DMF0035-0280 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0035-0281 | A5 | DMF0035_MktFcstWaterfall.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0035_MktFcstWaterfall.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0035_MktFcstWaterfall.CreateSprea) |
| WK-DMF0035-0282 | A5 | DMF0035_MktFcstWaterfall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadColumn: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0283 | A5 | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeader: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0284 | A5 | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeaderSpan: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0285 | A5 | Excel(F12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Excel(F12): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Excel(F12)) |
| WK-DMF0035-0286 | A5 | Filter(F4)/Sort(F3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Filter(F4)/Sort(F3): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Filter(F4)/Sort(F3)) |
| WK-DMF0035-0287 | A5 | InternalYN (0022) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — InternalYN (0022): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (InternalYN (0022)) |
| WK-DMF0035-0288 | A5 | MEASURE 까지 좌측 고정 `Freeze(0, MEASURE+1)` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — MEASURE 까지 좌측 고정 `Freeze(0, MEASURE+1)`: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MEASURE 까지 좌측 고정 `Freeze(0, MEASURE+1)`) |
| WK-DMF0035-0289 | A5 | REQ:CHAT-20260828-C2-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — REQ:CHAT-20260828-C2-DMF0035: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260828-C2-DMF0035) |
| WK-DMF0035-0290 | A5 | REQ:CHAT-20260831-W26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — REQ:CHAT-20260831-W26: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W26) |
| WK-DMF0035-0291 | A5 | REQ:CHAT-20260831-W29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — REQ:CHAT-20260831-W29: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W29) |
| WK-DMF0035-0292 | A5 | REQ:CHAT-20260831-W44 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — REQ:CHAT-20260831-W44: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W44) |
| WK-DMF0035-0293 | A5 | UM-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — UM-06: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (UM-06) |
| WK-DMF0035-0294 | A5 | UM-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — UM-07: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (UM-07) |
| WK-DMF0035-0295 | A5 | UM-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — UM-12: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (UM-12) |
| WK-DMF0035-0296 | A5 | cboCellQty | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — cboCellQty: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (cboCellQty) |
| WK-DMF0035-0297 | A5 | chkColor 회색 실적구간 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — chkColor 회색 실적구간: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (chkColor 회색 실적구간) |
| WK-DMF0035-0298 | A5 | footer SUM(SumIgnoreHidden) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — footer SUM(SumIgnoreHidden): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (footer SUM(SumIgnoreHidden)) |
| WK-DMF0035-0299 | A5 | 건수 표기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 건수 표기: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (건수 표기) |
| WK-DMF0035-0300 | A5 | 기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(0051): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(005) |
| WK-DMF0035-0301 | A5 | 당기 버킷 Green Bold | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 당기 버킷 Green Bold: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (당기 버킷 Green Bold) |
| WK-DMF0035-0302 | A5 | 버킷·Sum 토글(SetSpreadColumn) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 버킷·Sum 토글(SetSpreadColumn): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (버킷·Sum 토글(SetSpreadColumn)) |
| WK-DMF0035-0303 | A5 | 전 컬럼 읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 전 컬럼 읽기전용: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (전 컬럼 읽기전용) |
| WK-DMF0035-0304 | A5 | 주말 헤더색(SAT 파랑/SUN 빨강) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 주말 헤더색(SAT 파랑/SUN 빨강): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (주말 헤더색(SAT 파랑/SUN 빨강)) |
| WK-DMF0035-0305 | A5 | 행별 NOTATION 포맷 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 행별 NOTATION 포맷: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (행별 NOTATION 포맷) |
| WK-DMF0035-0306 | A5 | 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_)) |
| WK-DMF0035-0307 | A5 | 환산 콤보(SetAmountCalculating) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 환산 콤보(SetAmountCalculating): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (환산 콤보(SetAmountCalculating)) |
| WK-DMF0035-0308 | G4 | (신규) GUBUN | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — (신규) GUBUN: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 ((신규) GUBUN) |
| WK-DMF0035-0309 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0035-0310 | G4 | InternalYN (0022) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — InternalYN (0022): 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (InternalYN (0022)) |
| WK-DMF0035-0311 | G4 | REQ:CHAT-20260831-W31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — REQ:CHAT-20260831-W31: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W31) |
| WK-DMF0035-0312 | G4 | REQ:CHAT-20260831-W36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — REQ:CHAT-20260831-W36: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W36) |
| WK-DMF0035-0313 | G4 | REQ:CHAT-20260831-W41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — REQ:CHAT-20260831-W41: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W41) |
| WK-DMF0035-0314 | G4 | cboKRW/USD/LOC/QTY | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — cboKRW/USD/LOC/QTY: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (cboKRW/USD/LOC/QTY) |
| WK-DMF0035-0315 | G4 | cbxQty "Qty≠0" (0051) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — cbxQty "Qty≠0" (0051): 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (cbxQty "Qty≠0" (0051)) |
| WK-DMF0035-0316 | H2 | **세로 셀 병합(SmartColMerge)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — **세로 셀 병합(SmartColMerge)**: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (**세로 셀 병합(SmartColMerge)**) |
| WK-DMF0035-0317 | H2 | 3단 헤더 병합(LARGE/SMALL/leaf) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 3단 헤더 병합(LARGE/SMALL/leaf): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (3단 헤더 병합(LARGE/SMALL/leaf)) |
| WK-DMF0035-0318 | H2 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-03: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-DMF0035-0319 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0035-0320 | H2 | DMF0035_MktFcstWaterfall.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0035_MktFcstWaterfall.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0035_MktFcstWaterfall.CreateSprea) |
| WK-DMF0035-0321 | H2 | DMF0035_MktFcstWaterfall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadColumn: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0322 | H2 | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeader: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0323 | H2 | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeaderSpan: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0324 | H2 | DMF0035_MktFcstWaterfall.chkColor_Checke | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0035_MktFcstWaterfall.chkColor_CheckedChanged: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.chkColor_Ch) |
| WK-DMF0035-0325 | H2 | Excel(F12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Excel(F12): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Excel(F12)) |
| WK-DMF0035-0326 | H2 | Filter(F4)/Sort(F3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Filter(F4)/Sort(F3): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Filter(F4)/Sort(F3)) |
| WK-DMF0035-0327 | H2 | MEASURE 까지 좌측 고정 `Freeze(0, MEASURE+1)` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — MEASURE 까지 좌측 고정 `Freeze(0, MEASURE+1)`: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MEASURE 까지 좌측 고정 `Freeze(0, MEASURE+1)`) |
| WK-DMF0035-0328 | H2 | REQ:CHAT-20260831-W38 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — REQ:CHAT-20260831-W38: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W38) |
| WK-DMF0035-0329 | H2 | REQ:CHAT-20260831-W44 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — REQ:CHAT-20260831-W44: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W44) |
| WK-DMF0035-0330 | H2 | UM-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — UM-06: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (UM-06) |
| WK-DMF0035-0331 | H2 | UM-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — UM-07: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (UM-07) |
| WK-DMF0035-0332 | H2 | chkColor 회색 실적구간 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — chkColor 회색 실적구간: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (chkColor 회색 실적구간) |
| WK-DMF0035-0333 | H2 | footer SUM(SumIgnoreHidden) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — footer SUM(SumIgnoreHidden): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (footer SUM(SumIgnoreHidden)) |
| WK-DMF0035-0334 | H2 | 건수 표기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 건수 표기: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (건수 표기) |
| WK-DMF0035-0335 | H2 | 기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(0051): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(005) |
| WK-DMF0035-0336 | H2 | 당기 버킷 Green Bold | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 당기 버킷 Green Bold: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (당기 버킷 Green Bold) |
| WK-DMF0035-0337 | H2 | 버킷·Sum 토글(SetSpreadColumn) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 버킷·Sum 토글(SetSpreadColumn): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (버킷·Sum 토글(SetSpreadColumn)) |
| WK-DMF0035-0338 | H2 | 전 컬럼 읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 전 컬럼 읽기전용: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (전 컬럼 읽기전용) |
| WK-DMF0035-0339 | H2 | 주말 헤더색(SAT 파랑/SUN 빨강) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 주말 헤더색(SAT 파랑/SUN 빨강): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (주말 헤더색(SAT 파랑/SUN 빨강)) |
| WK-DMF0035-0340 | H2 | 행별 NOTATION 포맷 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 행별 NOTATION 포맷: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (행별 NOTATION 포맷) |
| WK-DMF0035-0341 | H2 | 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_)) |
| WK-DMF0035-0342 | H2 | 환산 콤보(SetAmountCalculating) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 환산 콤보(SetAmountCalculating): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (환산 콤보(SetAmountCalculating)) |
| WK-DMF0035-0343 | H5 | **세로 셀 병합(SmartColMerge)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — **세로 셀 병합(SmartColMerge)**: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (**세로 셀 병합(SmartColMerge)**) |
| WK-DMF0035-0344 | H5 | 3단 헤더 병합(LARGE/SMALL/leaf) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 3단 헤더 병합(LARGE/SMALL/leaf): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (3단 헤더 병합(LARGE/SMALL/leaf)) |
| WK-DMF0035-0345 | H5 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-03: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-DMF0035-0346 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0035-0347 | H5 | DMF0035_MktFcstWaterfall.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0035_MktFcstWaterfall.CreateSpread: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0035_MktFcstWaterfall.CreateSprea) |
| WK-DMF0035-0348 | H5 | DMF0035_MktFcstWaterfall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadColumn: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0349 | H5 | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeader: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0350 | H5 | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeaderSpan: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0351 | H5 | Excel(F12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Excel(F12): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Excel(F12)) |
| WK-DMF0035-0352 | H5 | Filter(F4)/Sort(F3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Filter(F4)/Sort(F3): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Filter(F4)/Sort(F3)) |
| WK-DMF0035-0353 | H5 | MEASURE 까지 좌측 고정 `Freeze(0, MEASURE+1)` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — MEASURE 까지 좌측 고정 `Freeze(0, MEASURE+1)`: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MEASURE 까지 좌측 고정 `Freeze(0, MEASURE+1)`) |
| WK-DMF0035-0354 | H5 | REQ:CHAT-20260831-W44 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — REQ:CHAT-20260831-W44: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W44) |
| WK-DMF0035-0355 | H5 | UM-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — UM-06: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (UM-06) |
| WK-DMF0035-0356 | H5 | UM-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — UM-07: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (UM-07) |
| WK-DMF0035-0357 | H5 | footer SUM(SumIgnoreHidden) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — footer SUM(SumIgnoreHidden): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (footer SUM(SumIgnoreHidden)) |
| WK-DMF0035-0358 | H5 | 건수 표기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 건수 표기: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (건수 표기) |
| WK-DMF0035-0359 | H5 | 기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(0051): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(005) |
| WK-DMF0035-0360 | H5 | 당기 버킷 Green Bold | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 당기 버킷 Green Bold: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (당기 버킷 Green Bold) |
| WK-DMF0035-0361 | H5 | 버킷·Sum 토글(SetSpreadColumn) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 버킷·Sum 토글(SetSpreadColumn): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (버킷·Sum 토글(SetSpreadColumn)) |
| WK-DMF0035-0362 | H5 | 전 컬럼 읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 전 컬럼 읽기전용: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (전 컬럼 읽기전용) |
| WK-DMF0035-0363 | H5 | 주말 헤더색(SAT 파랑/SUN 빨강) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 주말 헤더색(SAT 파랑/SUN 빨강): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (주말 헤더색(SAT 파랑/SUN 빨강)) |
| WK-DMF0035-0364 | H5 | 행별 NOTATION 포맷 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 행별 NOTATION 포맷: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (행별 NOTATION 포맷) |
| WK-DMF0035-0365 | H5 | 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_)) |
| WK-DMF0035-0366 | H5 | 환산 콤보(SetAmountCalculating) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 환산 콤보(SetAmountCalculating): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (환산 콤보(SetAmountCalculating)) |
| WK-DMF0035-0367 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4)  해당없음 — 편집 기능  |  | 1 (COMMON:UC-02) |
| WK-DMF0035-0368 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-DMF0035-0369 | D5 | DMF0035_MktFcstWaterfall.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0035_MktFcstWaterfall.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0035_MktFcstWaterfall.CreateSprea) |
| WK-DMF0035-0370 | D5 | DMF0035_MktFcstWaterfall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadColumn: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0371 | D5 | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeader: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0372 | D5 | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeaderSpan: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0373 | E4 | DMF0035_MktFcstWaterfall.SetAmountCalcul | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0035_MktFcstWaterfall.SetAmountCalculating: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 24 (ACT:DMF0035_MktFcstWaterfall.SetAmountCa) |
| WK-DMF0035-0374 | E4 | DMF0035_MktFcstWaterfall.SetChangeContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0035_MktFcstWaterfall.SetChangeControl: 진입점 집계 — E4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 18 (ACT:DMF0035_MktFcstWaterfall.SetChangeCo) |
| WK-DMF0035-0375 | E4 | DMF0035_MktFcstWaterfall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadColumn: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0376 | E4 | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeader: 진입점 집계 — E4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0377 | E4 | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeaderSpan: 진입점 집계 — E4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 53 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0378 | E4 | 버킷·Sum 토글(SetSpreadColumn) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 버킷·Sum 토글(SetSpreadColumn): 행 집계 — E4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (버킷·Sum 토글(SetSpreadColumn)) |
| WK-DMF0035-0379 | A1 | (MSG00109) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — (MSG00109): 행 집계 — A1 8요소: REVIEW:8 |  | 1 ((MSG00109)) |
| WK-DMF0035-0380 | A1 | (신규) GUBUN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — (신규) GUBUN: 행 집계 — A1 8요소: REVIEW:8 |  | 1 ((신규) GUBUN) |
| WK-DMF0035-0381 | A1 | **GRID COLUMN SET(신규)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **GRID COLUMN SET(신규)**: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (**GRID COLUMN SET(신규)**) |
| WK-DMF0035-0382 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (COMMON:UC-03) |
| WK-DMF0035-0383 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (COMMON:UC-06) |
| WK-DMF0035-0384 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (COMMON:UC-07) |
| WK-DMF0035-0385 | A1 | DM0035_GET_MKT_FCST_WATERFALL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DM0035_GET_MKT_FCST_WATERFALL: 골든 비교 케이스 없음(DM0035_GET_MKT_FCST_WATERFALL — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 |  | 61 (ACT:DMF0035_MktFcstWaterfall.FindButton ) |
| WK-DMF0035-0386 | A1 | DMF0035_MktFcstWaterfall.Draw | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0035_MktFcstWaterfall.Draw: 진입점 집계 — A1 8요소: REVIEW:8 |  | 1 (ACT:DMF0035_MktFcstWaterfall.Draw:1153:1) |
| WK-DMF0035-0387 | A1 | DMF0073_GET_VERSION_SALESPRICE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0073_GET_VERSION_SALESPRICE: 골든 비교 케이스 없음(DMF0073_GET_VERSION_SALESPRICE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미 |  | 1 (version) |
| WK-DMF0035-0388 | A1 | InternalYN (0022) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — InternalYN (0022): 행 집계 — A1 8요소: REVIEW:8 |  | 1 (InternalYN (0022)) |
| WK-DMF0035-0389 | A1 | MSG00137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MSG00137: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (MSG00137) |
| WK-DMF0035-0390 | A1 | PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_P | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERF: 골든 비교 케이스 없음(PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL |  | 1 (salesPlanWaterfall) |
| WK-DMF0035-0391 | A1 | PKG_DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0035: 골든 비교 케이스 없음(PKG_DMF0035 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (REQ:CHAT-20260902-W46) |
| WK-DMF0035-0392 | A1 | PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATER | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL: 골든 비교 케이스 없음(PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL — 팝업·보조 SP 는 g |  | 63 (mktFcstWaterfall ACT:DMF0035_MktFcstWate) |
| WK-DMF0035-0393 | A1 | PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases. |  | 60 (ACT:DMF0035_MktFcstWaterfall.FindButton ) |
| WK-DMF0035-0394 | A1 | PKG_DMF0035_CLOUD_20260901 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0035_CLOUD_20260901: 골든 비교 케이스 없음(PKG_DMF0035_CLOUD_20260901 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 1 (REQ:CHAT-20260901-X12) |
| WK-DMF0035-0395 | A1 | PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFAL: 골든 비교 케이스 없음(PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL — |  | 1 (bizPlanWaterfall) |
| WK-DMF0035-0396 | A1 | REQ:CHAT-20260828-C1-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:CHAT-20260828-C1-DMF0035: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (REQ:CHAT-20260828-C1-DMF0035) |
| WK-DMF0035-0397 | A1 | REQ:CHAT-20260831-W31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:CHAT-20260831-W31: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (REQ:CHAT-20260831-W31) |
| WK-DMF0035-0398 | A1 | REQ:CHAT-20260831-W34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:CHAT-20260831-W34: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (REQ:CHAT-20260831-W34) |
| WK-DMF0035-0399 | A1 | REQ:CHAT-20260831-W36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:CHAT-20260831-W36: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (REQ:CHAT-20260831-W36) |
| WK-DMF0035-0400 | A1 | REQ:CHAT-20260831-W41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:CHAT-20260831-W41: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (REQ:CHAT-20260831-W41) |
| WK-DMF0035-0401 | A1 | REQ:CHAT-20260831-W43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:CHAT-20260831-W43: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (REQ:CHAT-20260831-W43) |
| WK-DMF0035-0402 | A1 | REQ:CHAT-20260831-W44 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:CHAT-20260831-W44: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (REQ:CHAT-20260831-W44) |
| WK-DMF0035-0403 | A1 | UM-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — UM-05: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (UM-05) |
| WK-DMF0035-0404 | A1 | cboBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboBucketType: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (cboBucketType) |
| WK-DMF0035-0405 | A1 | cboCellQty | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboCellQty: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (cboCellQty) |
| WK-DMF0035-0406 | A1 | cboDivision(필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision(필수): 행 집계 — A1 8요소: REVIEW:8 |  | 1 (cboDivision(필수)) |
| WK-DMF0035-0407 | A1 | cboKRW/USD/LOC/QTY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboKRW/USD/LOC/QTY: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (cboKRW/USD/LOC/QTY) |
| WK-DMF0035-0408 | A1 | cbxQty "Qty≠0" (0051) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cbxQty "Qty≠0" (0051): 행 집계 — A1 8요소: REVIEW:8 |  | 1 (cbxQty "Qty≠0" (0051)) |
| WK-DMF0035-0409 | A1 | chkSum/chkColor(chkMem) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — chkSum/chkColor(chkMem): 행 집계 — A1 8요소: REVIEW:8 |  | 1 (chkSum/chkColor(chkMem)) |
| WK-DMF0035-0410 | A1 | clbEDISender (0035, div81만) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbEDISender (0035, div81만): 행 집계 — A1 8요소: REVIEW:8 |  | 1 (clbEDISender (0035, div81만)) |
| WK-DMF0035-0411 | A1 | clbTeam/Customer/SalesSite/PlantSite/Biz | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbTeam/Customer/SalesSite/PlantSite/BizType/ItemT: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (clbTeam/Customer/SalesSite/PlantSite/Biz) |
| WK-DMF0035-0412 | A1 | drpPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — drpPeriod: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (drpPeriod) |
| WK-DMF0035-0413 | A1 | txtProject/ItemId/Owner + 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtProject/ItemId/Owner + 팝업: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (txtProject/ItemId/Owner + 팝업) |
| WK-DMF0035-0414 | A1 | txtVersion + 팝업 3종 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtVersion + 팝업 3종: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (txtVersion + 팝업 3종) |
| WK-DMF0035-0415 | A1 | 전 컬럼 읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 전 컬럼 읽기전용: 행 집계 — A1 8요소: REVIEW:8 |  | 1 (전 컬럼 읽기전용) |
| WK-DMF0035-0416 | A6 | UM-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — UM-05: 행 집계 — A6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (UM-05) |
| WK-DMF0035-0417 | G1 | (MSG00109) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — (MSG00109): 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 ((MSG00109)) |
| WK-DMF0035-0418 | G1 | (신규) GUBUN | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — (신규) GUBUN: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 ((신규) GUBUN) |
| WK-DMF0035-0419 | G1 | **GRID COLUMN SET(신규)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — **GRID COLUMN SET(신규)**: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (**GRID COLUMN SET(신규)**) |
| WK-DMF0035-0420 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-DMF0035-0421 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0035-0422 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0035-0423 | G1 | InternalYN (0022) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — InternalYN (0022): 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (InternalYN (0022)) |
| WK-DMF0035-0424 | G1 | MSG00137 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00137: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (MSG00137) |
| WK-DMF0035-0425 | G1 | REQ:CHAT-20260828-C1-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — REQ:CHAT-20260828-C1-DMF0035: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260828-C1-DMF0035) |
| WK-DMF0035-0426 | G1 | REQ:CHAT-20260831-W31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — REQ:CHAT-20260831-W31: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W31) |
| WK-DMF0035-0427 | G1 | REQ:CHAT-20260831-W34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — REQ:CHAT-20260831-W34: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W34) |
| WK-DMF0035-0428 | G1 | REQ:CHAT-20260831-W36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — REQ:CHAT-20260831-W36: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W36) |
| WK-DMF0035-0429 | G1 | REQ:CHAT-20260831-W41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — REQ:CHAT-20260831-W41: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W41) |
| WK-DMF0035-0430 | G1 | REQ:CHAT-20260831-W43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — REQ:CHAT-20260831-W43: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W43) |
| WK-DMF0035-0431 | G1 | REQ:CHAT-20260831-W44 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — REQ:CHAT-20260831-W44: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W44) |
| WK-DMF0035-0432 | G1 | REQ:CHAT-20260902-W46 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — REQ:CHAT-20260902-W46: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260902-W46) |
| WK-DMF0035-0433 | G1 | cboKRW/USD/LOC/QTY | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — cboKRW/USD/LOC/QTY: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (cboKRW/USD/LOC/QTY) |
| WK-DMF0035-0434 | G1 | cbxQty "Qty≠0" (0051) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — cbxQty "Qty≠0" (0051): 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (cbxQty "Qty≠0" (0051)) |
| WK-DMF0035-0435 | G1 | 전 컬럼 읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 전 컬럼 읽기전용: 행 집계 — G1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (전 컬럼 읽기전용) |
| WK-DMF0035-0436 | G6 | (신규) GUBUN | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — (신규) GUBUN: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 ((신규) GUBUN) |
| WK-DMF0035-0437 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0035-0438 | G6 | InternalYN (0022) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — InternalYN (0022): 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (InternalYN (0022)) |
| WK-DMF0035-0439 | G6 | REQ:CHAT-20260831-W31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — REQ:CHAT-20260831-W31: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W31) |
| WK-DMF0035-0440 | G6 | REQ:CHAT-20260831-W36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — REQ:CHAT-20260831-W36: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W36) |
| WK-DMF0035-0441 | G6 | REQ:CHAT-20260831-W41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — REQ:CHAT-20260831-W41: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W41) |
| WK-DMF0035-0442 | G6 | cboKRW/USD/LOC/QTY | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — cboKRW/USD/LOC/QTY: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (cboKRW/USD/LOC/QTY) |
| WK-DMF0035-0443 | G6 | cbxQty "Qty≠0" (0051) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — cbxQty "Qty≠0" (0051): 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (cbxQty "Qty≠0" (0051)) |
| WK-DMF0035-0444 | X-LOC | **GRID COLUMN SET(신규)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **GRID COLUMN SET(신규)**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**GRID COLUMN SET(신규)**) |
| WK-DMF0035-0445 | X-LOC | **세로 셀 병합(SmartColMerge)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **세로 셀 병합(SmartColMerge)**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**세로 셀 병합(SmartColMerge)**) |
| WK-DMF0035-0446 | X-LOC | *SpreadTitle ×3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — *SpreadTitle ×3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (*SpreadTitle ×3) |
| WK-DMF0035-0447 | X-LOC | 3단 헤더 병합(LARGE/SMALL/leaf) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3단 헤더 병합(LARGE/SMALL/leaf): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3단 헤더 병합(LARGE/SMALL/leaf)) |
| WK-DMF0035-0448 | X-LOC | Excel(F12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Excel(F12): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Excel(F12)) |
| WK-DMF0035-0449 | X-LOC | Filter(F4)/Sort(F3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Filter(F4)/Sort(F3): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Filter(F4)/Sort(F3)) |
| WK-DMF0035-0450 | X-LOC | MEASURE 까지 좌측 고정 `Freeze(0, MEASURE+1)` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MEASURE 까지 좌측 고정 `Freeze(0, MEASURE+1)`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MEASURE 까지 좌측 고정 `Freeze(0, MEASURE+1)`) |
| WK-DMF0035-0451 | X-LOC | bizPlanWaterfall | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — bizPlanWaterfall: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (bizPlanWaterfall) |
| WK-DMF0035-0452 | X-LOC | chkColor 회색 실적구간 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — chkColor 회색 실적구간: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (chkColor 회색 실적구간) |
| WK-DMF0035-0453 | X-LOC | footer SUM(SumIgnoreHidden) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — footer SUM(SumIgnoreHidden): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (footer SUM(SumIgnoreHidden)) |
| WK-DMF0035-0454 | X-LOC | mktFcstWaterfall | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — mktFcstWaterfall: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (mktFcstWaterfall) |
| WK-DMF0035-0455 | X-LOC | salesPlanWaterfall | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — salesPlanWaterfall: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (salesPlanWaterfall) |
| WK-DMF0035-0456 | X-LOC | version | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — version: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (version) |
| WK-DMF0035-0457 | X-LOC | version (SAVE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — version (SAVE): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (version (SAVE)) |
| WK-DMF0035-0458 | X-LOC | 건수 표기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 건수 표기: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (건수 표기) |
| WK-DMF0035-0459 | X-LOC | 기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(0051): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (기간 컬럼 D_/W_/M_(0035·0022) / M_/Q_/Y_(005) |
| WK-DMF0035-0460 | X-LOC | 당기 버킷 Green Bold | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 당기 버킷 Green Bold: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (당기 버킷 Green Bold) |
| WK-DMF0035-0461 | X-LOC | 동적 PIVOT + titleset 'C' 고정컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 동적 PIVOT + titleset 'C' 고정컬럼: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (동적 PIVOT + titleset 'C' 고정컬럼) |
| WK-DMF0035-0462 | X-LOC | 버킷·Sum 토글(SetSpreadColumn) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 버킷·Sum 토글(SetSpreadColumn): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (버킷·Sum 토글(SetSpreadColumn)) |
| WK-DMF0035-0463 | X-LOC | 전 컬럼 읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 전 컬럼 읽기전용: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (전 컬럼 읽기전용) |
| WK-DMF0035-0464 | X-LOC | 주말 헤더색(SAT 파랑/SUN 빨강) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 주말 헤더색(SAT 파랑/SUN 빨강): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (주말 헤더색(SAT 파랑/SUN 빨강)) |
| WK-DMF0035-0465 | X-LOC | 행별 NOTATION 포맷 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 행별 NOTATION 포맷: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (행별 NOTATION 포맷) |
| WK-DMF0035-0466 | X-LOC | 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_)) |
| WK-DMF0035-0467 | X-LOC | 환산 콤보(SetAmountCalculating) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 환산 콤보(SetAmountCalculating): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (환산 콤보(SetAmountCalculating)) |
| WK-DMF0035-0468 | X-ROW | *SpreadTitle ×3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — *SpreadTitle ×3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (*SpreadTitle ×3) |
| WK-DMF0035-0469 | X-ROW | DMF0035_MktFcstWaterfall.ClbPlantSite_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.ClbPlantSite_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.ClbPlantSit) |
| WK-DMF0035-0470 | X-ROW | DMF0035_MktFcstWaterfall.ClbSalesSite_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.ClbSalesSite_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.ClbSalesSit) |
| WK-DMF0035-0471 | X-ROW | DMF0035_MktFcstWaterfall.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.CreateSprea) |
| WK-DMF0035-0472 | X-ROW | DMF0035_MktFcstWaterfall.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.DefinePrope) |
| WK-DMF0035-0473 | X-ROW | DMF0035_MktFcstWaterfall.Draw | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.Draw: 진입점 집계 1검사 — NOPATH:1 (미실행 검사가 남아 판정필요) |  | 125 (ACT:DMF0035_MktFcstWaterfall.Draw ACT:DM) |
| WK-DMF0035-0474 | X-ROW | DMF0035_MktFcstWaterfall.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.EditButton: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.EditButton) |
| WK-DMF0035-0475 | X-ROW | DMF0035_MktFcstWaterfall.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결 |  | 15 (ACT:DMF0035_MktFcstWaterfall.ExcelButton) |
| WK-DMF0035-0476 | X-ROW | DMF0035_MktFcstWaterfall.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.FindButton: 진입점 집계 9검사 — NOT_RUN:6 · REVIEW:3 |  | 1 (ACT:DMF0035_MktFcstWaterfall.FindButton) |
| WK-DMF0035-0477 | X-ROW | DMF0035_MktFcstWaterfall.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.FindData: 진입점 집계 35검사 — NOT_RUN:29 · REVIEW:3 · PASS:2 · NOPATH:1 |  | 7 (ACT:DMF0035_MktFcstWaterfall.FindData:10) |
| WK-DMF0035-0478 | X-ROW | DMF0035_MktFcstWaterfall.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.Form_Load A) |
| WK-DMF0035-0479 | X-ROW | DMF0035_MktFcstWaterfall.GetBizTypebyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.GetBizTypebyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.GetBizTypeb) |
| WK-DMF0035-0480 | X-ROW | DMF0035_MktFcstWaterfall.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.GetBucketType: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.GetBucketTy) |
| WK-DMF0035-0481 | X-ROW | DMF0035_MktFcstWaterfall.GetCustomerbyDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.GetCustomerbyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.GetCustomer) |
| WK-DMF0035-0482 | X-ROW | DMF0035_MktFcstWaterfall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.GetDayRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.GetDayRange) |
| WK-DMF0035-0483 | X-ROW | DMF0035_MktFcstWaterfall.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.GetDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.GetDivision) |
| WK-DMF0035-0484 | X-ROW | DMF0035_MktFcstWaterfall.GetEdiSender | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.GetEdiSender: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.GetEdiSende) |
| WK-DMF0035-0485 | X-ROW | DMF0035_MktFcstWaterfall.GetItemType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.GetItemType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.GetItemType) |
| WK-DMF0035-0486 | X-ROW | DMF0035_MktFcstWaterfall.GetLastWeekSunD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.GetLastWeekSunDayByDate: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.GetLastWeek) |
| WK-DMF0035-0487 | X-ROW | DMF0035_MktFcstWaterfall.GetPlantSitebyE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.GetPlantSitebyEndCustomer: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.GetPlantSit) |
| WK-DMF0035-0488 | X-ROW | DMF0035_MktFcstWaterfall.GetQtyData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.GetQtyData: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.GetQtyData) |
| WK-DMF0035-0489 | X-ROW | DMF0035_MktFcstWaterfall.GetScmSitebyDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.GetScmSitebyDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.GetScmSiteb) |
| WK-DMF0035-0490 | X-ROW | DMF0035_MktFcstWaterfall.GetTeambyDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.GetTeambyDivision: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.GetTeambyDi) |
| WK-DMF0035-0491 | X-ROW | DMF0035_MktFcstWaterfall.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.InitControls: 진입점 집계 45검사 — NOT_RUN:43 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 16 (ACT:DMF0035_MktFcstWaterfall.InitControl) |
| WK-DMF0035-0492 | X-ROW | DMF0035_MktFcstWaterfall.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.InitSpread: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.InitSpread ) |
| WK-DMF0035-0493 | X-ROW | DMF0035_MktFcstWaterfall.InitSpreadFoote | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.InitSpreadFooterSum: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.InitSpreadF) |
| WK-DMF0035-0494 | X-ROW | DMF0035_MktFcstWaterfall.SetAmountCalcul | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.SetAmountCalculating: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.SetAmountCa) |
| WK-DMF0035-0495 | X-ROW | DMF0035_MktFcstWaterfall.SetChangeContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.SetChangeControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0035_MktFcstWaterfall.SetChangeCo) |
| WK-DMF0035-0496 | X-ROW | DMF0035_MktFcstWaterfall.SetClbVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.SetClbVersion: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.SetClbVersi) |
| WK-DMF0035-0497 | X-ROW | DMF0035_MktFcstWaterfall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadColumn: 진입점 집계 18검사 — NOT_RUN:18 (미실행 검사가 남아 판정필요) |  | 15 (ACT:DMF0035_MktFcstWaterfall.SetSpreadCo) |
| WK-DMF0035-0498 | X-ROW | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeader: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0499 | X-ROW | DMF0035_MktFcstWaterfall.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.SetSpreadHeaderSpan: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.SetSpreadHe) |
| WK-DMF0035-0500 | X-ROW | DMF0035_MktFcstWaterfall.TxtItemId_Enter | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.TxtItemId_Enter: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:DMF0035_MktFcstWaterfall.TxtItemId_E) |
| WK-DMF0035-0501 | X-ROW | DMF0035_MktFcstWaterfall.TxtProject_Chan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.TxtProject_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.TxtProject_) |
| WK-DMF0035-0502 | X-ROW | DMF0035_MktFcstWaterfall.btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.btnColumn_Click: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.btnColumn_C) |
| WK-DMF0035-0503 | X-ROW | DMF0035_MktFcstWaterfall.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.btnItemId_C) |
| WK-DMF0035-0504 | X-ROW | DMF0035_MktFcstWaterfall.btnMeasure_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.btnMeasure_Click: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.btnMeasure_) |
| WK-DMF0035-0505 | X-ROW | DMF0035_MktFcstWaterfall.btnOwner_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.btnOwner_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.btnOwner_Cl) |
| WK-DMF0035-0506 | X-ROW | DMF0035_MktFcstWaterfall.btnProject_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.btnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0035_MktFcstWaterfall.btnProject_) |
| WK-DMF0035-0507 | X-ROW | DMF0035_MktFcstWaterfall.btnVersion_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.btnVersion_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0035_MktFcstWaterfall.btnVersion_) |
| WK-DMF0035-0508 | X-ROW | DMF0035_MktFcstWaterfall.cboBucketType_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.cboBucketType_SelectedInd: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.cboBucketTy) |
| WK-DMF0035-0509 | X-ROW | DMF0035_MktFcstWaterfall.cboDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.cboDivision_SelectedIndex: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.cboDivision) |
| WK-DMF0035-0510 | X-ROW | DMF0035_MktFcstWaterfall.cboQTY_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.cboQTY_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.cboQTY_Sele) |
| WK-DMF0035-0511 | X-ROW | DMF0035_MktFcstWaterfall.chkColor_Checke | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.chkColor_CheckedChanged: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.chkColor_Ch) |
| WK-DMF0035-0512 | X-ROW | DMF0035_MktFcstWaterfall.chkSum_CheckedC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.chkSum_Chec) |
| WK-DMF0035-0513 | X-ROW | DMF0035_MktFcstWaterfall.clbCustomer_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.clbCustomer_SelectedIndex: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.clbCustomer) |
| WK-DMF0035-0514 | X-ROW | DMF0035_MktFcstWaterfall.clbTeam_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.clbTeam_SelectedIndexChan: 진입점 집계 7검사 — NOT_RUN:5 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0035_MktFcstWaterfall.clbTeam_Sel) |
| WK-DMF0035-0515 | X-ROW | DMF0035_MktFcstWaterfall.fnValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.fnValidation: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 21 (ACT:DMF0035_MktFcstWaterfall.fnValidatio) |
| WK-DMF0035-0516 | X-ROW | DMF0035_MktFcstWaterfall.spdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.spdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0035_MktFcstWaterfall.spdMain_Cel) |
| WK-DMF0035-0517 | X-ROW | DMF0035_MktFcstWaterfall.spdMain_ComboSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.spdMain_ComboSelChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0035_MktFcstWaterfall.spdMain_Com) |
| WK-DMF0035-0518 | X-ROW | DMF0035_MktFcstWaterfall.spdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.spdMain_KeyUp: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:DMF0035_MktFcstWaterfall.spdMain_Key) |
| WK-DMF0035-0519 | X-ROW | DMF0035_MktFcstWaterfall.spdMain_TopChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.spdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0035_MktFcstWaterfall.spdMain_Top) |
| WK-DMF0035-0520 | X-ROW | DMF0035_MktFcstWaterfall.txtVersion_KeyD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0035_MktFcstWaterfall.txtVersion_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:DMF0035_MktFcstWaterfall.txtVersion_) |
| WK-DMF0035-0521 | X-ROW | REQ:CHAT-20260828-C3-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-C3-DMF0035: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-C3-DMF0035) |
| WK-DMF0035-0522 | X-ROW | REQ:CHAT-20260828-UM01-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM01-DMF0035: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM01-DMF0035) |
| WK-DMF0035-0523 | X-ROW | REQ:CHAT-20260828-UM02-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM02-DMF0035: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM02-DMF0035) |
| WK-DMF0035-0524 | X-ROW | REQ:CHAT-20260828-UM03-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM03-DMF0035: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM03-DMF0035) |
| WK-DMF0035-0525 | X-ROW | REQ:CHAT-20260828-UM04-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM04-DMF0035: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM04-DMF0035) |
| WK-DMF0035-0526 | X-ROW | REQ:CHAT-20260828-UM05-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM05-DMF0035: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM05-DMF0035) |
| WK-DMF0035-0527 | X-ROW | REQ:CHAT-20260828-UM06-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM06-DMF0035: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM06-DMF0035) |
| WK-DMF0035-0528 | X-ROW | REQ:CHAT-20260828-UM07-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM07-DMF0035: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM07-DMF0035) |
| WK-DMF0035-0529 | X-ROW | REQ:CHAT-20260828-UM08-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM08-DMF0035: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM08-DMF0035) |
| WK-DMF0035-0530 | X-ROW | REQ:CHAT-20260828-UM11-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM11-DMF0035: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM11-DMF0035) |
| WK-DMF0035-0531 | X-ROW | REQ:CHAT-20260828-UM12-DMF0035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260828-UM12-DMF0035: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260828-UM12-DMF0035) |
| WK-DMF0035-0532 | X-ROW | REQ:CHAT-20260831-W02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260831-W02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260831-W02) |
| WK-DMF0035-0533 | X-ROW | REQ:CHAT-20260831-W06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260831-W06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260831-W06) |
| WK-DMF0035-0534 | X-ROW | REQ:CHAT-20260831-W27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260831-W27: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260831-W27) |
| WK-DMF0035-0535 | X-ROW | REQ:CHAT-20260831-W28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260831-W28: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260831-W28) |
| WK-DMF0035-0536 | X-ROW | REQ:CHAT-20260831-W33 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260831-W33: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260831-W33) |
| WK-DMF0035-0537 | X-ROW | REQ:CHAT-20260831-W35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260831-W35: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260831-W35) |
| WK-DMF0035-0538 | X-ROW | REQ:CHAT-20260831-W37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260831-W37: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260831-W37) |
| WK-DMF0035-0539 | X-ROW | REQ:CHAT-20260831-W39 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260831-W39: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260831-W39) |
| WK-DMF0035-0540 | X-ROW | REQ:CHAT-20260831-W40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260831-W40: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260831-W40) |
| WK-DMF0035-0541 | X-ROW | REQ:CHAT-20260831-W45 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — REQ:CHAT-20260831-W45: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (REQ:CHAT-20260831-W45) |
| WK-DMF0035-0542 | X-ROW | UM-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UM-01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (UM-01) |
| WK-DMF0035-0543 | X-ROW | UM-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UM-02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (UM-02) |
| WK-DMF0035-0544 | X-ROW | UM-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UM-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (UM-08) |
| WK-DMF0035-0545 | X-ROW | UM-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UM-11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (UM-11) |
| WK-DMF0035-0546 | G5 | DMF0035_MktFcstWaterfall.spdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0035_MktFcstWaterfall.spdMain_CellDoubleClick: 진입점 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 37 (ACT:DMF0035_MktFcstWaterfall.spdMain_Cel) |
| WK-DMF0035-0547 | G5 | REQ:CHAT-20260831-W11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — REQ:CHAT-20260831-W11: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W11) |
| WK-DMF0035-0548 | G5 | 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_): 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_)) |
| WK-DMF0035-0549 | H6 | DMF0035_MktFcstWaterfall.spdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0035_MktFcstWaterfall.spdMain_CellDoubleClick: 진입점 집계 — H6 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 37 (ACT:DMF0035_MktFcstWaterfall.spdMain_Cel) |
| WK-DMF0035-0550 | H6 | REQ:CHAT-20260831-W11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — REQ:CHAT-20260831-W11: 행 집계 — H6 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W11) |
| WK-DMF0035-0551 | H6 | 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_): 행 집계 — H6 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_)) |
| WK-DMF0035-0552 | M4 | DMF0035_MktFcstWaterfall.spdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0035_MktFcstWaterfall.spdMain_CellDoubleClick: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 37 (ACT:DMF0035_MktFcstWaterfall.spdMain_Cel) |
| WK-DMF0035-0553 | M4 | REQ:CHAT-20260831-W11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — REQ:CHAT-20260831-W11: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260831-W11) |
| WK-DMF0035-0554 | M4 | 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_): 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (헤더 더블클릭 드릴(M_→W_→D_ / BIZ M_↔Q_)) |

## W8 구현 후 검증 (30)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0035-0555 | G4 | REQ:CHAT-20260831-W24 | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행 REQ:CHAT-20260831-W24 구현 후 검증 · 대상 REQ:CHAT-20260831-W24 |  | 1 (REQ:CHAT-20260831-W24) |
| WK-DMF0035-0556 | G4 | REQ:CHAT-20260831-W25 | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행 REQ:CHAT-20260831-W25 구현 후 검증 · 대상 REQ:CHAT-20260831-W25 |  | 1 (REQ:CHAT-20260831-W25) |
| WK-DMF0035-0557 | H2 | REQ:CHAT-20260831-W19 | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 REQ:CHAT-20260831-W19 구현 후 검증 · 대상 REQ:CHAT-20260831-W19 |  | 1 (REQ:CHAT-20260831-W19) |
| WK-DMF0035-0558 | E1 | REQ:CHAT-20260831-W17 | 선행 W1 완료 후 E2E | E1 — 대조표 미구현 행 REQ:CHAT-20260831-W17 구현 후 검증 · 대상 REQ:CHAT-20260831-W17 |  | 1 (REQ:CHAT-20260831-W17) |
| WK-DMF0035-0559 | A1 | REQ:CHAT-20260831-W01 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 REQ:CHAT-20260831-W01 구현 후 검증 · 대상 REQ:CHAT-20260831-W01 |  | 1 (REQ:CHAT-20260831-W01) |
| WK-DMF0035-0560 | A1 | REQ:CHAT-20260831-W24 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 REQ:CHAT-20260831-W24 구현 후 검증 · 대상 REQ:CHAT-20260831-W24 |  | 1 (REQ:CHAT-20260831-W24) |
| WK-DMF0035-0561 | A1 | REQ:CHAT-20260831-W25 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 REQ:CHAT-20260831-W25 구현 후 검증 · 대상 REQ:CHAT-20260831-W25 |  | 1 (REQ:CHAT-20260831-W25) |
| WK-DMF0035-0562 | G1 | REQ:CHAT-20260831-W01 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 REQ:CHAT-20260831-W01 구현 후 검증 · 대상 REQ:CHAT-20260831-W01 |  | 1 (REQ:CHAT-20260831-W01) |
| WK-DMF0035-0563 | G1 | REQ:CHAT-20260831-W24 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 REQ:CHAT-20260831-W24 구현 후 검증 · 대상 REQ:CHAT-20260831-W24 |  | 1 (REQ:CHAT-20260831-W24) |
| WK-DMF0035-0564 | G1 | REQ:CHAT-20260831-W25 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 REQ:CHAT-20260831-W25 구현 후 검증 · 대상 REQ:CHAT-20260831-W25 |  | 1 (REQ:CHAT-20260831-W25) |
| WK-DMF0035-0565 | G1 | REQ:CHAT-20260901-X12 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 REQ:CHAT-20260901-X12 구현 후 검증 · 대상 REQ:CHAT-20260901-X12 |  | 1 (REQ:CHAT-20260901-X12) |
| WK-DMF0035-0566 | G6 | REQ:CHAT-20260831-W24 | 선행 W1 완료 후 E2E | G6 — 대조표 미구현 행 REQ:CHAT-20260831-W24 구현 후 검증 · 대상 REQ:CHAT-20260831-W24 |  | 1 (REQ:CHAT-20260831-W24) |
| WK-DMF0035-0567 | G6 | REQ:CHAT-20260831-W25 | 선행 W1 완료 후 E2E | G6 — 대조표 미구현 행 REQ:CHAT-20260831-W25 구현 후 검증 · 대상 REQ:CHAT-20260831-W25 |  | 1 (REQ:CHAT-20260831-W25) |
| WK-DMF0035-0568 | X-ROW | MODAL:WaterfallVersionModal | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 MODAL:WaterfallVersionModal 구현 후 검증 · 대상 MODAL:WaterfallVersionModal |  | 1 (MODAL:WaterfallVersionModal) |
| WK-DMF0035-0569 | X-ROW | REQ:CHAT-20260831-W03 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W03 구현 후 검증 · 대상 REQ:CHAT-20260831-W03 |  | 1 (REQ:CHAT-20260831-W03) |
| WK-DMF0035-0570 | X-ROW | REQ:CHAT-20260831-W04 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W04 구현 후 검증 · 대상 REQ:CHAT-20260831-W04 |  | 1 (REQ:CHAT-20260831-W04) |
| WK-DMF0035-0571 | X-ROW | REQ:CHAT-20260831-W05 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W05 구현 후 검증 · 대상 REQ:CHAT-20260831-W05 |  | 1 (REQ:CHAT-20260831-W05) |
| WK-DMF0035-0572 | X-ROW | REQ:CHAT-20260831-W07 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W07 구현 후 검증 · 대상 REQ:CHAT-20260831-W07 |  | 1 (REQ:CHAT-20260831-W07) |
| WK-DMF0035-0573 | X-ROW | REQ:CHAT-20260831-W08 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W08 구현 후 검증 · 대상 REQ:CHAT-20260831-W08 |  | 1 (REQ:CHAT-20260831-W08) |
| WK-DMF0035-0574 | X-ROW | REQ:CHAT-20260831-W09 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W09 구현 후 검증 · 대상 REQ:CHAT-20260831-W09 |  | 1 (REQ:CHAT-20260831-W09) |
| WK-DMF0035-0575 | X-ROW | REQ:CHAT-20260831-W10 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W10 구현 후 검증 · 대상 REQ:CHAT-20260831-W10 |  | 1 (REQ:CHAT-20260831-W10) |
| WK-DMF0035-0576 | X-ROW | REQ:CHAT-20260831-W12 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W12 구현 후 검증 · 대상 REQ:CHAT-20260831-W12 |  | 1 (REQ:CHAT-20260831-W12) |
| WK-DMF0035-0577 | X-ROW | REQ:CHAT-20260831-W13 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W13 구현 후 검증 · 대상 REQ:CHAT-20260831-W13 |  | 1 (REQ:CHAT-20260831-W13) |
| WK-DMF0035-0578 | X-ROW | REQ:CHAT-20260831-W14 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W14 구현 후 검증 · 대상 REQ:CHAT-20260831-W14 |  | 1 (REQ:CHAT-20260831-W14) |
| WK-DMF0035-0579 | X-ROW | REQ:CHAT-20260831-W15 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W15 구현 후 검증 · 대상 REQ:CHAT-20260831-W15 |  | 1 (REQ:CHAT-20260831-W15) |
| WK-DMF0035-0580 | X-ROW | REQ:CHAT-20260831-W20 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W20 구현 후 검증 · 대상 REQ:CHAT-20260831-W20 |  | 1 (REQ:CHAT-20260831-W20) |
| WK-DMF0035-0581 | X-ROW | REQ:CHAT-20260831-W21 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W21 구현 후 검증 · 대상 REQ:CHAT-20260831-W21 |  | 1 (REQ:CHAT-20260831-W21) |
| WK-DMF0035-0582 | X-ROW | REQ:CHAT-20260831-W22 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W22 구현 후 검증 · 대상 REQ:CHAT-20260831-W22 |  | 1 (REQ:CHAT-20260831-W22) |
| WK-DMF0035-0583 | X-ROW | REQ:CHAT-20260831-W23 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260831-W23 구현 후 검증 · 대상 REQ:CHAT-20260831-W23 |  | 1 (REQ:CHAT-20260831-W23) |
| WK-DMF0035-0584 | X-ROW | REQ:CHAT-20260901-X13 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 REQ:CHAT-20260901-X13 구현 후 검증 · 대상 REQ:CHAT-20260901-X13 |  | 1 (REQ:CHAT-20260901-X13) |
