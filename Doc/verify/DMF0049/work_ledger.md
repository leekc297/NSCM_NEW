# 작업 원장 — DMF0049 · 2026-10-26 12:51

> 검사 인스턴스 688건 중 PASS·NA 112건 외 **576건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 8 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 21 | 구현 위치 실존 |
| W4 | 검사기 구현 | 9 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 45 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 157 | 실행 → PASS |
| W7 | 기대값 확정 | 314 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 22 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 308 · E2E 157 · 하네스 54 · 대조표 27 · 선행 W1 완료 후 E2E 22 · FE 8
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| D1 | EDIT |  |  |  |  |  | 23 | 28 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 23 | 28 |  |  | 행 값 기반 조건부 잠금 |
| X-ROW | GEN |  |  |  |  |  |  | 50 | 1 |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 21 |  |  |  |  | 20 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A1 | GEN |  |  |  |  |  |  | 22 | 4 |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| B4 | COMBO |  |  |  |  | 13 |  | 11 | 1 |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C3 | CASCADE |  |  |  |  |  | 14 | 8 |  |  | 연쇄 자동 채움 |
| G1 | GEN |  |  |  |  |  | 5 | 13 | 4 |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| F4 | DB |  |  |  |  |  | 6 | 14 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B3 | COMBO |  |  |  | 9 |  |  | 10 |  |  | 콤보 후보 정렬 = AS-IS |
| A5 | DESIGN |  |  |  |  |  | 4 | 13 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| DB-SYN | DB |  |  |  |  | 2 |  | 14 |  |  | BE 계정 시노님·권한·대상 객체 |
| C2 | CASCADE |  |  |  |  |  | 10 | 6 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 10 | 6 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| E4 | EDIT |  |  |  |  |  | 11 | 1 | 3 |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G5 | POPUP |  |  |  |  | 5 |  | 9 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 3 | 2 | 9 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 4 | 9 |  |  | 팝업 선택값 반영 |
| H2 | DESIGN |  |  |  |  |  | 3 | 9 |  |  | 배경·글자색 규칙 |
| D5 | EDIT |  |  |  |  |  | 7 | 3 | 1 |  | 셀 에디터 유형 |
| B1 | COMBO |  |  |  |  | 7 |  | 2 | 1 |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 7 |  | 2 | 1 |  | 콤보 후보 중복 없음 |
| X-NOTIMPL | GEN | 8 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| G4 | DESIGN |  |  |  |  | 2 | 5 |  | 1 |  | 조회조건 표시·라벨·활성 |
| H3 | DESIGN |  |  |  |  |  | 4 | 4 |  |  | 셀 병합 = AS-IS |
| H5 | DESIGN |  |  |  |  |  | 3 | 5 |  |  | 라벨 명칭 |
| A6 | GEN |  |  |  |  |  | 4 | 4 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| C1 | CASCADE |  |  |  |  |  | 4 | 3 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G6 | GEN |  |  |  |  |  | 5 | 1 | 1 |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REASON | DESIGN |  |  |  |  |  |  | 6 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| E2 | EDIT |  |  |  |  | 3 |  | 1 |  |  | 날짜 형식·유효성 |
| C4 | CASCADE |  |  |  |  |  | 1 | 3 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| D4 | EDIT |  |  |  |  |  |  |  | 2 |  | 신규행 기본값·자동세팅·Insert 전제 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| G3 | COMMON |  |  |  |  |  |  |  | 1 |  | 조회조건 저장·복원 |
| E5 | EDIT |  |  |  |  |  |  |  | 1 |  | 콤보 셀 후보 외 값 차단 |

## W1 기능 구현 (8)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0049-0001 | X-NOTIMPL | COMMON:UC-01 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-01 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026 |  | 1 (COMMON:UC-01) |
| WK-DMF0049-0002 | X-NOTIMPL | COMMON:UC-02 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4)   미구현 |  | 1 (COMMON:UC-02) |
| WK-DMF0049-0003 | X-NOTIMPL | COMMON:UC-03 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5)   미구현 |  | 1 (COMMON:UC-03) |
| WK-DMF0049-0004 | X-NOTIMPL | COMMON:UC-04 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-04 CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6)   미구현 |  | 1 (COMMON:UC-04) |
| WK-DMF0049-0005 | X-NOTIMPL | COMMON:UC-05 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-05 Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7)   미구현 |  | 1 (COMMON:UC-05) |
| WK-DMF0049-0006 | X-NOTIMPL | COMMON:UC-06 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)   미구현 |  | 1 (COMMON:UC-06) |
| WK-DMF0049-0007 | X-NOTIMPL | COMMON:UC-07 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-07 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②)   미구현 |  | 1 (COMMON:UC-07) |
| WK-DMF0049-0008 | X-NOTIMPL | REQ:CHAT-20260820-14 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — REQ:CHAT-20260820-14 첫 라인 값 입력 후 저장 시 SQL 오류 발생 (재현: R_S_20260715_V002_C)   미구현 |  | 1 (REQ:CHAT-20260820-14) |

## W2 구현 위치 확인 (21)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0049-0009 | X-LOC | AU-08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: EtcSalesReportsUtils.test.ts 없음 |  | 1 (AU-08) |
| WK-DMF0049-0010 | X-LOC | Company (캐시만) / clbDivision 이중구독 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Company (캐시만) / clbDivision 이중구독) |
| WK-DMF0049-0011 | X-LOC | DM0002_TitleSetForm_Popup (M 모드) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DM0002_TitleSetForm_Popup (M 모드)) |
| WK-DMF0049-0012 | X-LOC | DMF0044_Sales_VersionPopUp / DM0002_Item | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DMF0044_Sales_VersionPopUp / DM0002_Item) |
| WK-DMF0049-0013 | X-LOC | DMF0044_United_VersionPopup(727 — 공유) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DMF0044_United_VersionPopup(727 — 공유)) |
| WK-DMF0049-0014 | X-LOC | E06-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/etc-sales-reports/components/modals/MeasureSelectModal.tsx 없음 |  | 1 (E06-2) |
| WK-DMF0049-0015 | X-LOC | HANDLER:btnMeasure_Click | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/etc-sales-reports/components/modals/MeasureSelectModal.tsx 없음 |  | 1 (HANDLER:btnMeasure_Click) |
| WK-DMF0049-0016 | X-LOC | MODAL:MeasureSelectModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/etc-sales-reports/components/modals/MeasureSelectModal.tsx 없음 |  | 1 (MODAL:MeasureSelectModal) |
| WK-DMF0049-0017 | X-LOC | REQ:CHAT-20260820-15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-15) |
| WK-DMF0049-0018 | X-LOC | REQ:CHAT-20260820-16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-16) |
| WK-DMF0049-0019 | X-LOC | REQ:CHAT-20260820-17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-17) |
| WK-DMF0049-0020 | X-LOC | REQ:CHAT-20260820-18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-18) |
| WK-DMF0049-0021 | X-LOC | REQ:CHAT-20260820-19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-19) |
| WK-DMF0049-0022 | X-LOC | REQ:CHAT-20260820-20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: column-config.ts 없음, gridAction.ts 없음 |  | 1 (REQ:CHAT-20260820-20) |
| WK-DMF0049-0023 | X-LOC | SCM0002_ProjectbyDivisionPopupEx (ETC=tr | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCM0002_ProjectbyDivisionPopupEx (ETC=tr) |
| WK-DMF0049-0024 | X-LOC | btnMeasure | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnMeasure) |
| WK-DMF0049-0025 | X-LOC | clbDivision (MyDivision) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbDivision (MyDivision)) |
| WK-DMF0049-0026 | X-LOC | clbPlanResult (정적, 기본 Plan L207) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbPlanResult (정적, 기본 Plan L207)) |
| WK-DMF0049-0027 | X-LOC | clbType (MDF_TYPE) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbType (MDF_TYPE)) |
| WK-DMF0049-0028 | X-LOC | txtSPVersion + btnSPVer | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtSPVersion + btnSPVer) |
| WK-DMF0049-0029 | X-LOC | usrYear (CALENDAR_YYYY, 기본 올해 — [E202501 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrYear (CALENDAR_YYYY, 기본 올해 — [E202501) |

## W4 검사기 구현 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0049-0030 | B3 | BIZ_TYPE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 BIZ_TYPE | 있음(SHEET_COLUMNS) | 1 (**DM_LOOKUP_DIV**) |
| WK-DMF0049-0031 | B3 | DATA_SEQ | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DATA_SEQ | 있음(SHEET_COLUMNS) | 27 (ACT:DMF0049_Sales_ETC_Reports.GetMeasure) |
| WK-DMF0049-0032 | B3 | DEPARTMENT_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DEPARTMENT_ID | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0033 | B3 | DEPT_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DEPT_ID | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0034 | B3 | END_CUST_REPORT | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 END_CUST_REPORT | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0035 | B3 | ITEM_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ITEM_ID | 있음(SHEET_COLUMNS) | 1 (**DM_LOOKUP_DIV**) |
| WK-DMF0049-0036 | B3 | ITEM_USE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ITEM_USE | 있음(SHEET_COLUMNS) | 1 (**DM_LOOKUP_DIV**) |
| WK-DMF0049-0037 | B3 | MEASURE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 MEASURE | 있음(SHEET_COLUMNS) | 15 (ACT:DMF0049_Sales_ETC_Reports.GetCellInd) |
| WK-DMF0049-0038 | B3 | clbDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivision / Division | 있음(FE 소스) | 2 (ACT:DMF0049_Sales_ETC_Reports.GetMeasure) |

## W5 검사기 연결 (45)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0049-0039 | B1 | CUST_REPORT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL CUST_REPORT | 있음(SHEET_COLUMNS) | 5 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0040 | B1 | DEPARTMENT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DEPARTMENT_ID | 있음(SHEET_COLUMNS) | 7 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0041 | B1 | DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DEPT_ID | 있음(SHEET_COLUMNS) | 10 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0042 | B1 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0043 | B1 | END_CUST_REPORT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUST_REPORT | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0044 | B1 | PRODUCT_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL PRODUCT_GROUP | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0045 | B1 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0046 | B2 | CUST_REPORT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL CUST_REPORT | 있음(SHEET_COLUMNS) | 5 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0047 | B2 | DEPARTMENT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DEPARTMENT_ID | 있음(SHEET_COLUMNS) | 7 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0048 | B2 | DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DEPT_ID | 있음(SHEET_COLUMNS) | 10 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0049 | B2 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0050 | B2 | END_CUST_REPORT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUST_REPORT | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0051 | B2 | PRODUCT_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL PRODUCT_GROUP | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0052 | B2 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0053 | B4 | BIZ_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL BIZ_TYPE | 있음(SHEET_COLUMNS) | 1 (**DM_LOOKUP_DIV**) |
| WK-DMF0049-0054 | B4 | CUST_REPORT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CUST_REPORT | 있음(SHEET_COLUMNS) | 5 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0055 | B4 | DATA_SEQ | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DATA_SEQ | 있음(SHEET_COLUMNS) | 27 (ACT:DMF0049_Sales_ETC_Reports.GetMeasure) |
| WK-DMF0049-0056 | B4 | DEPARTMENT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DEPARTMENT_ID | 있음(SHEET_COLUMNS) | 10 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0057 | B4 | DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DEPT_ID | 있음(SHEET_COLUMNS) | 14 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0058 | B4 | END_CUSTOMER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUSTOMER | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0059 | B4 | END_CUST_REPORT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUST_REPORT | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0060 | B4 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 1 (**DM_LOOKUP_DIV**) |
| WK-DMF0049-0061 | B4 | ITEM_USE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ITEM_USE | 있음(SHEET_COLUMNS) | 1 (**DM_LOOKUP_DIV**) |
| WK-DMF0049-0062 | B4 | MEASURE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL MEASURE | 있음(SHEET_COLUMNS) | 15 (ACT:DMF0049_Sales_ETC_Reports.GetCellInd) |
| WK-DMF0049-0063 | B4 | PRODUCT_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PRODUCT_GROUP | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0064 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0065 | B4 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 2 (ACT:DMF0049_Sales_ETC_Reports.GetMeasure) |
| WK-DMF0049-0066 | F2 | DMF0049 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0049 화면 | 판단불가(대상 단위 SCREEN) | 224 (E03 E03-2 E05-1 E05-3 L633 L638 L734 L74) |
| WK-DMF0049-0067 | F6 | DMF0049 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN DMF0049 화면 | 판단불가(대상 단위 SCREEN) | 207 (E03-2 L638 L874 DV-09 DV-10 DV-11 DV-12 ) |
| WK-DMF0049-0068 | DB-SYN | P_USER_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_USER_GROUP | 없음(PROC_M 대응 없음) | 1 (AU-03) |
| WK-DMF0049-0069 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0049_Sales_ETC_Reports.GetLookupD) |
| WK-DMF0049-0070 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (btnMeasure) |
| WK-DMF0049-0071 | G4 | btnSPVer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSPVer | 있음(FE 소스) | 1 (txtSPVersion + btnSPVer) |
| WK-DMF0049-0072 | E2 | CELL_MODEL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL CELL_MODEL | 있음(SHEET_COLUMNS) | 1 (—) |
| WK-DMF0049-0073 | E2 | CELL_MODEL_INFO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL CELL_MODEL_INFO | 있음(SHEET_COLUMNS) | 1 (—) |
| WK-DMF0049-0074 | E2 | MEASURE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL MEASURE | 있음(SHEET_COLUMNS) | 1 (—) |
| WK-DMF0049-0075 | G03-WIRE | DMF0049 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0049 화면 | 판단불가(대상 단위 SCREEN) | 6 (ACT:DMF0049_Sales_ETC_Reports..ctor ACT:) |
| WK-DMF0049-0076 | G5 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 19 (E06-3 ACT:DMF0049_Sales_ETC_Reports.spdM) |
| WK-DMF0049-0077 | G5 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (E06-2) |
| WK-DMF0049-0078 | G5 | btnSPVer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnSPVer | 있음(FE 소스) | 1 (E06-1) |
| WK-DMF0049-0079 | G5 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 2 (ACT:DMF0049_Sales_ETC_Reports.btnMeasure) |
| WK-DMF0049-0080 | G5 | clbType / Report Type / Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbType / Report Type / Type | 있음(FE 소스) | 1 (ACT:DMF0049_Sales_ETC_Reports.btnSPVer_C) |
| WK-DMF0049-0081 | H6 | PROJECT_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PROJECT_CODE | 있음(SHEET_COLUMNS) | 19 (E06-3 ACT:DMF0049_Sales_ETC_Reports.spdM) |
| WK-DMF0049-0082 | H6 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (E06-2) |
| WK-DMF0049-0083 | H6 | btnSPVer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnSPVer | 있음(FE 소스) | 1 (E06-1) |

## W6 검증 실행 (157)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0049-0084 | J2 | DMF0049 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0049 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 85 (E01-1 E02 E03 E03-1 E03-2 E03-3 E03-4 E0) |
| WK-DMF0049-0085 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InitContro) |
| WK-DMF0049-0086 | C1 | clbType / Report Type / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbType / Report Type / Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InitContro) |
| WK-DMF0049-0087 | C1 | txtSPVersion / BP Version / SPVersion | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — txtSPVersion / BP Version / SPVersion · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (HANDLER:clbType_SelectedIndexChanged) |
| WK-DMF0049-0088 | C1 | usrYear / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — usrYear / Year · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.YearSet:11) |
| WK-DMF0049-0089 | C2 | CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 13 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0090 | C2 | DEPARTMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 40 (DV-19 ACT:DMF0049_Sales_ETC_Reports.spdM) |
| WK-DMF0049-0091 | C2 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 52 (E04-1 ACT:DMF0049_Sales_ETC_Reports.spdM) |
| WK-DMF0049-0092 | C2 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0093 | C2 | END_CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — END_CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0094 | C2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0095 | C2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0096 | C2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0097 | C2 | PRODUCT_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PRODUCT_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0098 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0099 | C3 | CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 13 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0100 | C3 | DEPARTMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 44 (DV-19 ACT:DMF0049_Sales_ETC_Reports.Defi) |
| WK-DMF0049-0101 | C3 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 59 (E04-1 ACT:DMF0049_Sales_ETC_Reports.Defi) |
| WK-DMF0049-0102 | C3 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0103 | C3 | END_CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — END_CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0104 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0105 | C3 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0106 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0107 | C3 | PRODUCT_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PRODUCT_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 9 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0108 | C3 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0109 | C3 | PROJECT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0110 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0111 | C3 | T_DEPARTMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — T_DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0112 | C3 | T_DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — T_DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0113 | C4 | txtSPVersion / BP Version / SPVersion | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — txtSPVersion / BP Version / SPVersion · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (HANDLER:clbType_SelectedIndexChanged) |
| WK-DMF0049-0114 | C6 | CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 13 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0115 | C6 | DEPARTMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 40 (DV-19 ACT:DMF0049_Sales_ETC_Reports.spdM) |
| WK-DMF0049-0116 | C6 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 52 (E04-1 ACT:DMF0049_Sales_ETC_Reports.spdM) |
| WK-DMF0049-0117 | C6 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0118 | C6 | END_CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — END_CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0119 | C6 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0120 | C6 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0121 | C6 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0122 | C6 | PRODUCT_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PRODUCT_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0123 | C6 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0124 | K4 | DMF0049 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0049 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 18 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-DMF0049-0125 | F1 | DMF0049 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0049 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 250 (E03 E03-2 E03-4 E05-1 E05-3 L633 L638 L7) |
| WK-DMF0049-0126 | F5 | DMF0049 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0049 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 27 (E03-4 E05-1 DV-02 DV-03 DV-04 HANDLER:De) |
| WK-DMF0049-0127 | F4 | PKG_DMF0049.P_DMF0049_GET_MEASURE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0049.P_DMF0049_GET_MEASURE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 3 (DV-13 ACT:DMF0049_Sales_ETC_Reports.GetM) |
| WK-DMF0049-0128 | F4 | PKG_DMF0049.P_DMF0049_GET_SALES_ETC_REPO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0049.P_DMF0049_GET_SALES_ETC_REPORTS_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 249 (ACT:DMF0049_Sales_ETC_Reports.FindButton) |
| WK-DMF0049-0129 | F4 | PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 248 (ACT:DMF0049_Sales_ETC_Reports.FindButton) |
| WK-DMF0049-0130 | F4 | PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 198 (ACT:DMF0049_Sales_ETC_Reports.SaveButton) |
| WK-DMF0049-0131 | F4 | P_USER_GROUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_USER_GROUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (AU-03) |
| WK-DMF0049-0132 | F4 | SCM0001_GET_LOOKUP_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.GetLookupD) |
| WK-DMF0049-0133 | A5 | DEPARTMENT_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0134 | A5 | DEPT_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0135 | A5 | END_CUSTOMER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (EndCustomerByDivisionDept) |
| WK-DMF0049-0136 | A5 | PROJECT_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (E06-3 ACT:DMF0049_Sales_ETC_Reports.spdM) |
| WK-DMF0049-0137 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (clbDivision (MyDivision) Company (캐시만) /) |
| WK-DMF0049-0138 | G4 | clbPlanResult / Plan/Result / Plan Resul | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlanResult / Plan/Result / Plan Result · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (clbPlanResult (정적, 기본 Plan L207) ACT:DMF) |
| WK-DMF0049-0139 | G4 | clbType / Report Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbType / Report Type / Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (clbType (MDF_TYPE) ACT:DMF0049_Sales_ETC) |
| WK-DMF0049-0140 | G4 | txtSPVersion / BP Version / SPVersion | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtSPVersion / BP Version / SPVersion · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtSPVersion + btnSPVer) |
| WK-DMF0049-0141 | G4 | usrYear / Year | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — usrYear / Year · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (usrYear (CALENDAR_YYYY, 기본 올해 — [E202501) |
| WK-DMF0049-0142 | H2 | DEPARTMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (AU-08) |
| WK-DMF0049-0143 | H2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.FindData:5) |
| WK-DMF0049-0144 | H2 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (E06-3) |
| WK-DMF0049-0145 | H3 | CUST_REPORT | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — CUST_REPORT · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (DV-20) |
| WK-DMF0049-0146 | H3 | DATA_SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — DATA_SEQ · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (REQ:CHAT-20260820-18) |
| WK-DMF0049-0147 | H3 | DEPARTMENT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — DEPARTMENT_ID · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (DV-20) |
| WK-DMF0049-0148 | H3 | DEPT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — DEPT_ID · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 1 (DV-20) |
| WK-DMF0049-0149 | H5 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (E06-3) |
| WK-DMF0049-0150 | H5 | clbDivision / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbDivision / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:DMF0049_Sales_ETC_Reports.InitSpread) |
| WK-DMF0049-0151 | H5 | usrYear / Year | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — usrYear / Year · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:DMF0049_Sales_ETC_Reports.InitSpread) |
| WK-DMF0049-0152 | I1 | DMF0049 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0049 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 19 (E05-3 L344 L528 L633 L748 DV-05 AU-02 CO) |
| WK-DMF0049-0153 | SC1 | DMF0049 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — DMF0049 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 8 (COMMON:UC-06 clbDivision (MyDivision) cl) |
| WK-DMF0049-0154 | D1 | BIZ_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — BIZ_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0155 | D1 | CELL_MODEL_INFO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CELL_MODEL_INFO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0156 | D1 | COUNTRY_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — COUNTRY_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0157 | D1 | CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (① ACT:DMF0049_Sales_ETC_Reports.InsertRo) |
| WK-DMF0049-0158 | D1 | CUTOFF_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CUTOFF_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0159 | D1 | DATA_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DATA_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (REQ:CHAT-20260820-18) |
| WK-DMF0049-0160 | D1 | DEPARTMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0161 | D1 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0162 | D1 | DMS_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DMS_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0163 | D1 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (AU-06 ACT:DMF0049_Sales_ETC_Reports.Edit) |
| WK-DMF0049-0164 | D1 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (DV-15 ACT:DMF0049_Sales_ETC_Reports.Inse) |
| WK-DMF0049-0165 | D1 | END_CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — END_CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0166 | D1 | ETC_DESCR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ETC_DESCR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (① ACT:DMF0049_Sales_ETC_Reports.InsertRo) |
| WK-DMF0049-0167 | D1 | FCST_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FCST_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0168 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0169 | D1 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 17 (AU-06 ACT:DMF0049_Sales_ETC_Reports.Edit) |
| WK-DMF0049-0170 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0171 | D1 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0172 | D1 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0173 | D1 | T_DEPARTMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — T_DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0174 | D1 | T_DEPARTMENT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — T_DEPARTMENT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0175 | D1 | T_DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — T_DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0176 | D1 | T_DEPT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — T_DEPT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0177 | D3 | BIZ_TYPE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — BIZ_TYPE_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0178 | D3 | CELL_MODEL_INFO | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CELL_MODEL_INFO · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0179 | D3 | COUNTRY_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — COUNTRY_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0180 | D3 | CURRENCY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CURRENCY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (① ACT:DMF0049_Sales_ETC_Reports.InsertRo) |
| WK-DMF0049-0181 | D3 | CUTOFF_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CUTOFF_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0182 | D3 | DATA_SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DATA_SEQ · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (REQ:CHAT-20260820-18) |
| WK-DMF0049-0183 | D3 | DEPARTMENT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DEPARTMENT_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0184 | D3 | DEPT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DEPT_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0185 | D3 | DMS_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DMS_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0186 | D3 | EDIT_FLAG | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — EDIT_FLAG · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (AU-06 ACT:DMF0049_Sales_ETC_Reports.Edit) |
| WK-DMF0049-0187 | D3 | END_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — END_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (DV-15 ACT:DMF0049_Sales_ETC_Reports.Inse) |
| WK-DMF0049-0188 | D3 | END_CUST_REPORT | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — END_CUST_REPORT · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0189 | D3 | ETC_DESCR | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ETC_DESCR · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (① ACT:DMF0049_Sales_ETC_Reports.InsertRo) |
| WK-DMF0049-0190 | D3 | FCST_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FCST_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0191 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0192 | D3 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 17 (AU-06 ACT:DMF0049_Sales_ETC_Reports.Edit) |
| WK-DMF0049-0193 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0194 | D3 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0195 | D3 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0196 | D3 | T_DEPARTMENT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — T_DEPARTMENT_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0197 | D3 | T_DEPARTMENT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — T_DEPARTMENT_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0198 | D3 | T_DEPT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — T_DEPT_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0199 | D3 | T_DEPT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — T_DEPT_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0200 | D5 | CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0201 | D5 | DEPARTMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 7 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0202 | D5 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 10 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0203 | D5 | END_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — END_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertRow:) |
| WK-DMF0049-0204 | D5 | END_CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — END_CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0205 | D5 | PRODUCT_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PRODUCT_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0206 | D5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0207 | D6 | DMF0049 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0049 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 13 (E03-3 E05-1 L928 DV-13 DV-14 DV-21 AU-02) |
| WK-DMF0049-0208 | E4 | DEPARTMENT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DEPARTMENT_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (L748 AU-08) |
| WK-DMF0049-0209 | E4 | DEPT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DEPT_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0049_Sales_ETC_Reports.SetChangeC) |
| WK-DMF0049-0210 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (L748 ACT:DMF0049_Sales_ETC_Reports.SaveD) |
| WK-DMF0049-0211 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0049_Sales_ETC_Reports.SaveData:8) |
| WK-DMF0049-0212 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (E05-3 L344 DV-05 AU-02 ACT:DMF0049_Sales) |
| WK-DMF0049-0213 | E4 | MSG00281 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00281 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (L633 ACT:DMF0049_Sales_ETC_Reports.SaveD) |
| WK-DMF0049-0214 | E4 | MSG00283 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00283 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (E05-3 L528 txtSPVersion + btnSPVer ACT:D) |
| WK-DMF0049-0215 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (E05-3 L748) |
| WK-DMF0049-0216 | E4 | MSG00676 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00676 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (REQ:CHAT-20260820-19) |
| WK-DMF0049-0217 | E4 | MSG00688 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00688 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (E05-3 L633 txtSPVersion + btnSPVer) |
| WK-DMF0049-0218 | E4 | txtSPVersion / BP Version / SPVersion | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtSPVersion / BP Version / SPVersion · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저 |  | 3 (txtSPVersion + btnSPVer ACT:DMF0049_Sale) |
| WK-DMF0049-0219 | A10 | DMF0049 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0049 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 40 (ACT:DMF0049_Sales_ETC_Reports.DefineProp) |
| WK-DMF0049-0220 | A6 | PKG_DMF0049.P_DMF0049_GET_MEASURE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0049.P_DMF0049_GET_MEASURE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trac |  | 1 (DV-13) |
| WK-DMF0049-0221 | A6 | PKG_DMF0049.P_DMF0049_GET_SALES_ETC_REPO | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0049.P_DMF0049_GET_SALES_ETC_REPORTS_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 52 (ACT:DMF0049_Sales_ETC_Reports.FindButton) |
| WK-DMF0049-0222 | A6 | PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 49 (ACT:DMF0049_Sales_ETC_Reports.FindButton) |
| WK-DMF0049-0223 | A6 | P_USER_GROUP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_USER_GROUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (AU-03) |
| WK-DMF0049-0224 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (clbDivision (MyDivision) Company (캐시만) /) |
| WK-DMF0049-0225 | G1 | clbPlanResult / Plan/Result / Plan Resul | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlanResult / Plan/Result / Plan Result · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 10 (clbPlanResult (정적, 기본 Plan L207) ACT:DMF) |
| WK-DMF0049-0226 | G1 | clbType / Report Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbType / Report Type / Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (clbType (MDF_TYPE) ACT:DMF0049_Sales_ETC) |
| WK-DMF0049-0227 | G1 | txtSPVersion / BP Version / SPVersion | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtSPVersion / BP Version / SPVersion · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 7 (txtSPVersion + btnSPVer ACT:DMF0049_Sale) |
| WK-DMF0049-0228 | G1 | usrYear / Year | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — usrYear / Year · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (usrYear (CALENDAR_YYYY, 기본 올해 — [E202501) |
| WK-DMF0049-0229 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 8 (clbDivision (MyDivision) Company (캐시만) /) |
| WK-DMF0049-0230 | G6 | clbPlanResult / Plan/Result / Plan Resul | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlanResult / Plan/Result / Plan Result · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (clbPlanResult (정적, 기본 Plan L207) ACT:DMF) |
| WK-DMF0049-0231 | G6 | clbType / Report Type / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbType / Report Type / Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (clbType (MDF_TYPE) ACT:DMF0049_Sales_ETC) |
| WK-DMF0049-0232 | G6 | txtSPVersion / BP Version / SPVersion | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtSPVersion / BP Version / SPVersion · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtSPVersion + btnSPVer) |
| WK-DMF0049-0233 | G6 | usrYear / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — usrYear / Year · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (usrYear (CALENDAR_YYYY, 기본 올해 — [E202501) |
| WK-DMF0049-0234 | X-REOPEN | DMF0049 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0049 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 10 (ACT:DMF0049_Sales_ETC_Reports.Dispose AC) |
| WK-DMF0049-0235 | H6 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:DMF0049_Sales_ETC_Reports.btnMeasure) |
| WK-DMF0049-0236 | H6 | clbType / Report Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbType / Report Type / Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (ACT:DMF0049_Sales_ETC_Reports.btnSPVer_C) |
| WK-DMF0049-0237 | M4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 19 (E06-3 ACT:DMF0049_Sales_ETC_Reports.spdM) |
| WK-DMF0049-0238 | M4 | PROJECT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0239 | M4 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (E06-2) |
| WK-DMF0049-0240 | M4 | btnSPVer | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnSPVer · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (E06-1) |

## W7 기대값 확정 (314)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0049-0241 | C1 | AU-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — AU-01: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (AU-01) |
| WK-DMF0049-0242 | C1 | HANDLER:clbDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbDivision_SelectedIndexChanged: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbDivision_SelectedIndexChanged) |
| WK-DMF0049-0243 | C1 | HANDLER:clbPlanResult_SelectedIndexChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbPlanResult_SelectedIndexChanged: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbPlanResult_SelectedIndexChang) |
| WK-DMF0049-0244 | C2 | DMF0049_Sales_ETC_Reports.clbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0049_Sales_ETC_Reports.clbDivision_SelectedInde: 진입점 집계 — C2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0049_Sales_ETC_Reports.clbDivisio) |
| WK-DMF0049-0245 | C2 | DMF0049_Sales_ETC_Reports.clbPlanResult_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0049_Sales_ETC_Reports.clbPlanResult_SelectedIn: 진입점 집계 — C2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0049_Sales_ETC_Reports.clbPlanRes) |
| WK-DMF0049-0246 | C2 | DMF0049_Sales_ETC_Reports.clbType_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0049_Sales_ETC_Reports.clbType_SelectedIndexCha: 진입점 집계 — C2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0049_Sales_ETC_Reports.clbType_Se) |
| WK-DMF0049-0247 | C2 | DMF0049_Sales_ETC_Reports.spdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0049_Sales_ETC_Reports.spdMain_Changed: 진입점 집계 — C2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0248 | C2 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — E04: 행 집계 — C2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0049-0249 | C2 | HANDLER:spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — HANDLER:spdMain_Changed: 행 집계 — C2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_Changed) |
| WK-DMF0049-0250 | C3 | DMF0049_Sales_ETC_Reports.SetChangeContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0049_Sales_ETC_Reports.SetChangeControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0049_Sales_ETC_Reports.SetChangeC) |
| WK-DMF0049-0251 | C3 | DMF0049_Sales_ETC_Reports.SetRowSpanFucT | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0049_Sales_ETC_Reports.SetRowSpanFucTwo: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 14 (ACT:DMF0049_Sales_ETC_Reports.SetRowSpan) |
| WK-DMF0049-0252 | C3 | DMF0049_Sales_ETC_Reports.clbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0049_Sales_ETC_Reports.clbDivision_SelectedInde: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0049_Sales_ETC_Reports.clbDivisio) |
| WK-DMF0049-0253 | C3 | DMF0049_Sales_ETC_Reports.clbPlanResult_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0049_Sales_ETC_Reports.clbPlanResult_SelectedIn: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0049_Sales_ETC_Reports.clbPlanRes) |
| WK-DMF0049-0254 | C3 | DMF0049_Sales_ETC_Reports.clbType_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0049_Sales_ETC_Reports.clbType_SelectedIndexCha: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0049_Sales_ETC_Reports.clbType_Se) |
| WK-DMF0049-0255 | C3 | DMF0049_Sales_ETC_Reports.spdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0049_Sales_ETC_Reports.spdMain_Changed: 진입점 집계 — C3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0256 | C3 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — E04: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0049-0257 | C3 | HANDLER:spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — HANDLER:spdMain_Changed: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_Changed) |
| WK-DMF0049-0258 | C4 | AU-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — AU-01: 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (AU-01) |
| WK-DMF0049-0259 | C4 | HANDLER:clbDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — HANDLER:clbDivision_SelectedIndexChanged: 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbDivision_SelectedIndexChanged) |
| WK-DMF0049-0260 | C4 | HANDLER:clbPlanResult_SelectedIndexChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — HANDLER:clbPlanResult_SelectedIndexChanged: 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbPlanResult_SelectedIndexChang) |
| WK-DMF0049-0261 | C6 | DMF0049_Sales_ETC_Reports.clbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0049_Sales_ETC_Reports.clbDivision_SelectedInde: 진입점 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0049_Sales_ETC_Reports.clbDivisio) |
| WK-DMF0049-0262 | C6 | DMF0049_Sales_ETC_Reports.clbPlanResult_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0049_Sales_ETC_Reports.clbPlanResult_SelectedIn: 진입점 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0049_Sales_ETC_Reports.clbPlanRes) |
| WK-DMF0049-0263 | C6 | DMF0049_Sales_ETC_Reports.clbType_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0049_Sales_ETC_Reports.clbType_SelectedIndexCha: 진입점 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0049_Sales_ETC_Reports.clbType_Se) |
| WK-DMF0049-0264 | C6 | DMF0049_Sales_ETC_Reports.spdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0049_Sales_ETC_Reports.spdMain_Changed: 진입점 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0265 | C6 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — E04: 행 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0049-0266 | C6 | HANDLER:spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — HANDLER:spdMain_Changed: 행 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_Changed) |
| WK-DMF0049-0267 | B1 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — E01-2: 행 집계 — B1 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (E01-2) |
| WK-DMF0049-0268 | B1 | `EtcSalesReportsGrid.tsx` 메타 셀 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — `EtcSalesReportsGrid.tsx` 메타 셀 콤보: 행 집계 — B1 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (`EtcSalesReportsGrid.tsx` 메타 셀 콤보) |
| WK-DMF0049-0269 | B2 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — E01-2: 행 집계 — B2 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (E01-2) |
| WK-DMF0049-0270 | B2 | `EtcSalesReportsGrid.tsx` 메타 셀 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — `EtcSalesReportsGrid.tsx` 메타 셀 콤보: 행 집계 — B2 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (`EtcSalesReportsGrid.tsx` 메타 셀 콤보) |
| WK-DMF0049-0271 | B3 | DMF0044_DEPARTMENT_TEAM2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0044_DEPARTMENT_TEAM2: 행 집계 — B3 9요소: TODO:9 (미실행 요소가 남아 판정필요) |  | 1 (DMF0044_DEPARTMENT_TEAM2) |
| WK-DMF0049-0272 | B3 | DMF0049_Sales_ETC_Reports.GetCalendarYYY | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCalendarYYYY: 진입점 집계 — B3 9요소: TODO:9 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0049_Sales_ETC_Reports.GetCalenda) |
| WK-DMF0049-0273 | B3 | DMF0049_Sales_ETC_Reports.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCellColor: 진입점 집계 — B3 9요소: TODO:9 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0049_Sales_ETC_Reports.GetCellCol) |
| WK-DMF0049-0274 | B3 | DMF0049_Sales_ETC_Reports.GetCellIndexBy | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCellIndexBySpanRowCel: 진입점 집계 — B3 9요소: TODO:9 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0049_Sales_ETC_Reports.GetCellInd) |
| WK-DMF0049-0275 | B3 | DMF0049_Sales_ETC_Reports.GetCellIndexBy | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCellIndexBySpanRowCel: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0049_Sales_ETC_Reports.GetCellInd) |
| WK-DMF0049-0276 | B3 | DMF0049_Sales_ETC_Reports.GetCellNumbers | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCellNumbersByRow: 진입점 집계 — B3 9요소: TODO:9 (미실행 요소가 남아 판정필요) |  | 14 (ACT:DMF0049_Sales_ETC_Reports.GetCellNum) |
| WK-DMF0049-0277 | B3 | DMF0049_Sales_ETC_Reports.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0049_Sales_ETC_Reports.GetLookupData: 진입점 집계 — B3 9요소: TODO:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0049_Sales_ETC_Reports.GetLookupD) |
| WK-DMF0049-0278 | B3 | DMF0049_Sales_ETC_Reports.GetMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0049_Sales_ETC_Reports.GetMeasure: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0049_Sales_ETC_Reports.GetMeasure) |
| WK-DMF0049-0279 | B3 | DMF0049_Sales_ETC_Reports.GetMeasureCntB | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0049_Sales_ETC_Reports.GetMeasureCntBy40: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0049_Sales_ETC_Reports.GetMeasure) |
| WK-DMF0049-0280 | B3 | `EtcSalesReportsGrid.tsx` 메타 셀 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `EtcSalesReportsGrid.tsx` 메타 셀 콤보: 행 집계 — B3 9요소: TODO:9 (미실행 요소가 남아 판정필요) |  | 1 (`EtcSalesReportsGrid.tsx` 메타 셀 콤보) |
| WK-DMF0049-0281 | B4 | DMF0044_DEPARTMENT_TEAM2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0044_DEPARTMENT_TEAM2: 행 집계 — B4 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (DMF0044_DEPARTMENT_TEAM2) |
| WK-DMF0049-0282 | B4 | DMF0049_Sales_ETC_Reports.GetCalendarYYY | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCalendarYYYY: 진입점 집계 — B4 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0049_Sales_ETC_Reports.GetCalenda) |
| WK-DMF0049-0283 | B4 | DMF0049_Sales_ETC_Reports.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCellColor: 진입점 집계 — B4 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0049_Sales_ETC_Reports.GetCellCol) |
| WK-DMF0049-0284 | B4 | DMF0049_Sales_ETC_Reports.GetCellIndexBy | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCellIndexBySpanRowCel: 진입점 집계 — B4 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0049_Sales_ETC_Reports.GetCellInd) |
| WK-DMF0049-0285 | B4 | DMF0049_Sales_ETC_Reports.GetCellIndexBy | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCellIndexBySpanRowCel: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0049_Sales_ETC_Reports.GetCellInd) |
| WK-DMF0049-0286 | B4 | DMF0049_Sales_ETC_Reports.GetCellNumbers | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCellNumbersByRow: 진입점 집계 — B4 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 14 (ACT:DMF0049_Sales_ETC_Reports.GetCellNum) |
| WK-DMF0049-0287 | B4 | DMF0049_Sales_ETC_Reports.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0049_Sales_ETC_Reports.GetLookupData: 진입점 집계 — B4 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0049_Sales_ETC_Reports.GetLookupD) |
| WK-DMF0049-0288 | B4 | DMF0049_Sales_ETC_Reports.GetMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0049_Sales_ETC_Reports.GetMeasure: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0049_Sales_ETC_Reports.GetMeasure) |
| WK-DMF0049-0289 | B4 | DMF0049_Sales_ETC_Reports.GetMeasureCntB | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0049_Sales_ETC_Reports.GetMeasureCntBy40: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0049_Sales_ETC_Reports.GetMeasure) |
| WK-DMF0049-0290 | B4 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — E01-2: 행 집계 — B4 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (E01-2) |
| WK-DMF0049-0291 | B4 | `EtcSalesReportsGrid.tsx` 메타 셀 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `EtcSalesReportsGrid.tsx` 메타 셀 콤보: 행 집계 — B4 13요소: NOPATH:13 (미실행 요소가 남아 판정필요) |  | 1 (`EtcSalesReportsGrid.tsx` 메타 셀 콤보) |
| WK-DMF0049-0292 | DB-SYN | AU-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — AU-08: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (AU-08) |
| WK-DMF0049-0293 | DB-SYN | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0049-0294 | DB-SYN | DMF0049_Sales_ETC_Reports.GetCalendarYYY | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCalendarYYYY: 진입점 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0049_Sales_ETC_Reports.GetCalenda) |
| WK-DMF0049-0295 | DB-SYN | DV-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DV-09: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (DV-09) |
| WK-DMF0049-0296 | DB-SYN | DV-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DV-10: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (DV-10) |
| WK-DMF0049-0297 | DB-SYN | DV-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DV-11: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (DV-11) |
| WK-DMF0049-0298 | DB-SYN | DV-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DV-12: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (DV-12) |
| WK-DMF0049-0299 | DB-SYN | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — E02: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (E02) |
| WK-DMF0049-0300 | DB-SYN | E03-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — E03-2: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (E03-2) |
| WK-DMF0049-0301 | DB-SYN | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:FindData: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0049-0302 | DB-SYN | HANDLER:SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:SaveData: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SaveData) |
| WK-DMF0049-0303 | DB-SYN | L638 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — L638: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (L638) |
| WK-DMF0049-0304 | DB-SYN | L874 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — L874: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (L874) |
| WK-DMF0049-0305 | DB-SYN | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — ②: 행 집계 — DB-SYN 6요소: PASS:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (②) |
| WK-DMF0049-0306 | F4 | AU-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — AU-08: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (AU-08) |
| WK-DMF0049-0307 | F4 | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0049-0308 | F4 | DMF0049_Sales_ETC_Reports.GetCalendarYYY | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCalendarYYYY: 진입점 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0049_Sales_ETC_Reports.GetCalenda) |
| WK-DMF0049-0309 | F4 | DV-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DV-09: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (DV-09) |
| WK-DMF0049-0310 | F4 | DV-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DV-10: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (DV-10) |
| WK-DMF0049-0311 | F4 | DV-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DV-11: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (DV-11) |
| WK-DMF0049-0312 | F4 | DV-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DV-12: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (DV-12) |
| WK-DMF0049-0313 | F4 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — E02: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (E02) |
| WK-DMF0049-0314 | F4 | E03-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — E03-2: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (E03-2) |
| WK-DMF0049-0315 | F4 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:FindData: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0049-0316 | F4 | HANDLER:SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:SaveData: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SaveData) |
| WK-DMF0049-0317 | F4 | L638 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — L638: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (L638) |
| WK-DMF0049-0318 | F4 | L874 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — L874: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (L874) |
| WK-DMF0049-0319 | F4 | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — ②: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (②) |
| WK-DMF0049-0320 | A5 | DMF0049_Sales_ETC_Reports.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0049_Sales_ETC_Reports.CreateSpread: 진입점 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0049_Sales_ETC_Reports.CreateSpre) |
| WK-DMF0049-0321 | A5 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E01-2: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E01-2) |
| WK-DMF0049-0322 | A5 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E04: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0049-0323 | A5 | E05-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E05-1: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E05-1) |
| WK-DMF0049-0324 | A5 | E05-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E05-2: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E05-2) |
| WK-DMF0049-0325 | A5 | H-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — H-1: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (H-1) |
| WK-DMF0049-0326 | A5 | H-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — H-2: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (H-2) |
| WK-DMF0049-0327 | A5 | H-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — H-3: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (H-3) |
| WK-DMF0049-0328 | A5 | H-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — H-4: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (H-4) |
| WK-DMF0049-0329 | A5 | H-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — H-5: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (H-5) |
| WK-DMF0049-0330 | A5 | HANDLER:ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — HANDLER:ExcelButton: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0049-0331 | A5 | Incoterms | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Incoterms: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Incoterms) |
| WK-DMF0049-0332 | A5 | REQ:CHAT-20260820-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — REQ:CHAT-20260820-15: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-15) |
| WK-DMF0049-0333 | H2 | DMF0049_Sales_ETC_Reports.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0049_Sales_ETC_Reports.CreateSpread: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0049_Sales_ETC_Reports.CreateSpre) |
| WK-DMF0049-0334 | H2 | DMF0049_Sales_ETC_Reports.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCellColor: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0049_Sales_ETC_Reports.GetCellCol) |
| WK-DMF0049-0335 | H2 | DV-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DV-11: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (DV-11) |
| WK-DMF0049-0336 | H2 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E01-2: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (E01-2) |
| WK-DMF0049-0337 | H2 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E04: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0049-0338 | H2 | H-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — H-5: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (H-5) |
| WK-DMF0049-0339 | H2 | HANDLER:ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — HANDLER:ExcelButton: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0049-0340 | H2 | REQ:CHAT-20260820-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — REQ:CHAT-20260820-15: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-15) |
| WK-DMF0049-0341 | H2 | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — ②: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (②) |
| WK-DMF0049-0342 | H3 | DV-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — DV-21: 행 집계 — H3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (DV-21) |
| WK-DMF0049-0343 | H3 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — E01-2: 행 집계 — H3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E01-2) |
| WK-DMF0049-0344 | H3 | H-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — H-2: 행 집계 — H3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (H-2) |
| WK-DMF0049-0345 | H3 | REQ:CHAT-20260820-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — REQ:CHAT-20260820-19: 행 집계 — H3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-19) |
| WK-DMF0049-0346 | H5 | DMF0049_Sales_ETC_Reports.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0049_Sales_ETC_Reports.CreateSpread: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0049_Sales_ETC_Reports.CreateSpre) |
| WK-DMF0049-0347 | H5 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E01-2: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (E01-2) |
| WK-DMF0049-0348 | H5 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E04: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0049-0349 | H5 | HANDLER:ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — HANDLER:ExcelButton: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0049-0350 | H5 | REQ:CHAT-20260820-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — REQ:CHAT-20260820-15: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-15) |
| WK-DMF0049-0351 | X-REASON | AU-04 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — AU-04 §2.1-4 L989 InsertRow(81 계열) — UserEndCustomerByDivisionDeptAuth 로 **권한 있는 End Customer 만** 콤보  END_CUSTO |  | 1 (AU-04) |
| WK-DMF0049-0352 | X-REASON | AU-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — AU-05 §2.1-5 L1410 spdMain_Changed(END_CUSTOMER 변경) — UserSiteByEndCustomer 로 권한 Site 콤보  트리거 컬럼(END_CUSTOMER)과 |  | 1 (AU-05) |
| WK-DMF0049-0353 | X-REASON | AU-07 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — AU-07 §2.1-7 L401 EditButton(40) — EDIT_FLAG 를 **컬럼 위치**(0~EDIT_FLAG 열)로만 사용한 잠금 경계 — 값 비교 아님  AS-IS 는 FarPoint |  | 1 (AU-07) |
| WK-DMF0049-0354 | X-REASON | DV-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — DV-01 §1-1 L209 InitControls `gsDivision_id != "40"` — 40 아닐 때만 EndCustomerByDivision 콤보 fetch (L214)  END_CUST |  | 1 (DV-01) |
| WK-DMF0049-0355 | X-REASON | E00 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E00 §0 정본 vs 변형(GSCM.DM.Plan.UIL 평면본) 차이 — git diff --no-index 실측  정본 선택 근거 — `GSCM.DM.Forms.UIL/Plan/DMF0049_S |  | 1 (E00) |
| WK-DMF0049-0356 | X-REASON | E04-3 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E04-3 §4.3 spdMain_CellClick (L1578~1605)  AS-IS `spdMain_CellClick`(L1578~1605)은 CUST_REPORT 셀 콤보 재바인딩 전용이고, 그 |  | 1 (E04-3) |
| WK-DMF0049-0357 | D1 | AU-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — AU-02: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (AU-02) |
| WK-DMF0049-0358 | D1 | CRUD:E03:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CRUD:E03:SAVE: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E03:SAVE) |
| WK-DMF0049-0359 | D1 | DMF0049_Sales_ETC_Reports.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DMF0049_Sales_ETC_Reports.EditButton: 진입점 집계 — D1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0360 | D1 | DV-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DV-05: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-05) |
| WK-DMF0049-0361 | D1 | DV-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DV-06: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-06) |
| WK-DMF0049-0362 | D1 | DV-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DV-07: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-07) |
| WK-DMF0049-0363 | D1 | DV-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DV-08: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-08) |
| WK-DMF0049-0364 | D1 | DV-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DV-16: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-16) |
| WK-DMF0049-0365 | D1 | DV-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DV-17: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-17) |
| WK-DMF0049-0366 | D1 | DV-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DV-18: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-18) |
| WK-DMF0049-0367 | D1 | E03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — E03: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (E03) |
| WK-DMF0049-0368 | D1 | E03-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — E03-1: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (E03-1) |
| WK-DMF0049-0369 | D1 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — E04: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0049-0370 | D1 | E05-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — E05-3: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (E05-3) |
| WK-DMF0049-0371 | D1 | H-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — H-1: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (H-1) |
| WK-DMF0049-0372 | D1 | H-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — H-2: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (H-2) |
| WK-DMF0049-0373 | D1 | H-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — H-3: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (H-3) |
| WK-DMF0049-0374 | D1 | H-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — H-4: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (H-4) |
| WK-DMF0049-0375 | D1 | H-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — H-5: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (H-5) |
| WK-DMF0049-0376 | D1 | HANDLER:EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — HANDLER:EditButton: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:EditButton) |
| WK-DMF0049-0377 | D1 | HANDLER:InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — HANDLER:InsertRow: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:InsertRow) |
| WK-DMF0049-0378 | D1 | L344 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — L344: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (L344) |
| WK-DMF0049-0379 | D1 | L638 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — L638: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (L638) |
| WK-DMF0049-0380 | D1 | L928 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — L928: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (L928) |
| WK-DMF0049-0381 | D1 | REQ:CHAT-20260820-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — REQ:CHAT-20260820-19: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-19) |
| WK-DMF0049-0382 | D1 | REQ:CHAT-20260820-20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — REQ:CHAT-20260820-20: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-20) |
| WK-DMF0049-0383 | D1 | `EtcSalesReports.tsx` sEditMeasure `para | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `EtcSalesReports.tsx` sEditMeasure `param1`/`param: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (`EtcSalesReports.tsx` sEditMeasure `para) |
| WK-DMF0049-0384 | D1 | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — ②: 행 집계 — D1 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (②) |
| WK-DMF0049-0385 | D3 | AU-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — AU-02: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (AU-02) |
| WK-DMF0049-0386 | D3 | CRUD:E03:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CRUD:E03:SAVE: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E03:SAVE) |
| WK-DMF0049-0387 | D3 | DMF0049_Sales_ETC_Reports.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DMF0049_Sales_ETC_Reports.EditButton: 진입점 집계 — D3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 23 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0388 | D3 | DV-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DV-05: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-05) |
| WK-DMF0049-0389 | D3 | DV-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DV-06: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-06) |
| WK-DMF0049-0390 | D3 | DV-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DV-07: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-07) |
| WK-DMF0049-0391 | D3 | DV-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DV-08: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-08) |
| WK-DMF0049-0392 | D3 | DV-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DV-16: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-16) |
| WK-DMF0049-0393 | D3 | DV-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DV-17: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-17) |
| WK-DMF0049-0394 | D3 | DV-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DV-18: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (DV-18) |
| WK-DMF0049-0395 | D3 | E03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — E03: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (E03) |
| WK-DMF0049-0396 | D3 | E03-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — E03-1: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (E03-1) |
| WK-DMF0049-0397 | D3 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — E04: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0049-0398 | D3 | E05-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — E05-3: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (E05-3) |
| WK-DMF0049-0399 | D3 | H-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — H-1: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (H-1) |
| WK-DMF0049-0400 | D3 | H-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — H-2: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (H-2) |
| WK-DMF0049-0401 | D3 | H-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — H-3: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (H-3) |
| WK-DMF0049-0402 | D3 | H-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — H-4: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (H-4) |
| WK-DMF0049-0403 | D3 | H-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — H-5: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (H-5) |
| WK-DMF0049-0404 | D3 | HANDLER:EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — HANDLER:EditButton: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:EditButton) |
| WK-DMF0049-0405 | D3 | HANDLER:InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — HANDLER:InsertRow: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:InsertRow) |
| WK-DMF0049-0406 | D3 | L344 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — L344: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (L344) |
| WK-DMF0049-0407 | D3 | L638 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — L638: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (L638) |
| WK-DMF0049-0408 | D3 | L928 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — L928: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (L928) |
| WK-DMF0049-0409 | D3 | REQ:CHAT-20260820-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — REQ:CHAT-20260820-19: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-19) |
| WK-DMF0049-0410 | D3 | REQ:CHAT-20260820-20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — REQ:CHAT-20260820-20: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-20) |
| WK-DMF0049-0411 | D3 | `EtcSalesReports.tsx` sEditMeasure `para | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `EtcSalesReports.tsx` sEditMeasure `param1`/`param: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (`EtcSalesReports.tsx` sEditMeasure `para) |
| WK-DMF0049-0412 | D3 | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — ②: 행 집계 — D3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (②) |
| WK-DMF0049-0413 | D5 | DMF0049_Sales_ETC_Reports.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0049_Sales_ETC_Reports.CreateSpread: 진입점 집계 — D5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0049_Sales_ETC_Reports.CreateSpre) |
| WK-DMF0049-0414 | D5 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — E01-2: 행 집계 — D5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (E01-2) |
| WK-DMF0049-0415 | D5 | `EtcSalesReportsGrid.tsx` 메타 셀 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — `EtcSalesReportsGrid.tsx` 메타 셀 콤보: 행 집계 — D5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`EtcSalesReportsGrid.tsx` 메타 셀 콤보) |
| WK-DMF0049-0416 | E2 | DMF0044_Sales_VersionPopUp / DM0002_Item | 사람 판정 / AS-IS 원문 확인 → 재판정 | E2 기대값 확정 — DMF0044_Sales_VersionPopUp / DM0002_Item 팝업: 행 집계 — E2 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (DMF0044_Sales_VersionPopUp / DM0002_Item) |
| WK-DMF0049-0417 | E4 | DMF0049_Sales_ETC_Reports.SetChangeContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0049_Sales_ETC_Reports.SetChangeControl: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0049_Sales_ETC_Reports.SetChangeC) |
| WK-DMF0049-0418 | A1 | COLUMN_SETUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COLUMN_SETUP: 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (E05-1) |
| WK-DMF0049-0419 | A1 | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0049-0420 | A1 | Company (캐시만) / clbDivision 이중구독 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Company (캐시만) / clbDivision 이중구독: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (Company (캐시만) / clbDivision 이중구독) |
| WK-DMF0049-0421 | A1 | E01-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01-1: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (E01-1) |
| WK-DMF0049-0422 | A1 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E02: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (E02) |
| WK-DMF0049-0423 | A1 | E05-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E05-3: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (E05-3) |
| WK-DMF0049-0424 | A1 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindData: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (HANDLER:FindData) |
| WK-DMF0049-0425 | A1 | HANDLER:clbDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:clbDivision_SelectedIndexChanged: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (HANDLER:clbDivision_SelectedIndexChanged) |
| WK-DMF0049-0426 | A1 | HANDLER:clbPlanResult_SelectedIndexChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:clbPlanResult_SelectedIndexChanged: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (HANDLER:clbPlanResult_SelectedIndexChang) |
| WK-DMF0049-0427 | A1 | PKG_DMF0049.P_DMF0049_GET_MEASURE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0049.P_DMF0049_GET_MEASURE: 골든 비교 케이스 없음(PKG_DMF0049.P_DMF0049_GET_MEASURE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실 |  | 1 (DV-13) |
| WK-DMF0049-0428 | A1 | PKG_DMF0049.P_DMF0049_GET_SALES_ETC_REPO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0049.P_DMF0049_GET_SALES_ETC_REPORTS_DATA: 골든 비교 케이스 없음(PKG_DMF0049.P_DMF0049_GET_SALES_ETC_REPORTS_DATA — 팝업·보 |  | 52 (ACT:DMF0049_Sales_ETC_Reports.FindButton) |
| WK-DMF0049-0429 | A1 | PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases. |  | 49 (ACT:DMF0049_Sales_ETC_Reports.FindButton) |
| WK-DMF0049-0430 | A1 | P_USER_GROUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_USER_GROUP: 골든 비교 케이스 없음(P_USER_GROUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 2 (AU-01 AU-03) |
| WK-DMF0049-0431 | A1 | P_USER_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_USER_ID: 골든 비교 케이스 없음(P_USER_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (AU-01) |
| WK-DMF0049-0432 | A1 | REQ:CHAT-20260820-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:CHAT-20260820-18: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (REQ:CHAT-20260820-18) |
| WK-DMF0049-0433 | A1 | btnMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnMeasure: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (btnMeasure) |
| WK-DMF0049-0434 | A1 | clbDivision (MyDivision) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbDivision (MyDivision): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (clbDivision (MyDivision)) |
| WK-DMF0049-0435 | A1 | clbPlanResult (정적, 기본 Plan L207) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbPlanResult (정적, 기본 Plan L207): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (clbPlanResult (정적, 기본 Plan L207)) |
| WK-DMF0049-0436 | A1 | clbType (MDF_TYPE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbType (MDF_TYPE): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (clbType (MDF_TYPE)) |
| WK-DMF0049-0437 | A1 | txtSPVersion + btnSPVer | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtSPVersion + btnSPVer: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (txtSPVersion + btnSPVer) |
| WK-DMF0049-0438 | A1 | usrYear (CALENDAR_YYYY, 기본 올해 — [E202501 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — usrYear (CALENDAR_YYYY, 기본 올해 — [E20250121] SP화): 행 집계 — A1 6요소: REVIEW:6 |  | 1 (usrYear (CALENDAR_YYYY, 기본 올해 — [E202501) |
| WK-DMF0049-0439 | A1 | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ②: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (②) |
| WK-DMF0049-0440 | A6 | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0049-0441 | A6 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — E02: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E02) |
| WK-DMF0049-0442 | A6 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — HANDLER:FindData: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0049-0443 | A6 | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — ②: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (②) |
| WK-DMF0049-0444 | G1 | AU-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — AU-01: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (AU-01) |
| WK-DMF0049-0445 | G1 | AU-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — AU-03: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (AU-03) |
| WK-DMF0049-0446 | G1 | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0049-0447 | G1 | E01-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E01-1: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (E01-1) |
| WK-DMF0049-0448 | G1 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E02: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (E02) |
| WK-DMF0049-0449 | G1 | E05-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E05-1: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (E05-1) |
| WK-DMF0049-0450 | G1 | E05-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E05-3: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (E05-3) |
| WK-DMF0049-0451 | G1 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — HANDLER:FindData: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0049-0452 | G1 | HANDLER:clbDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — HANDLER:clbDivision_SelectedIndexChanged: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbDivision_SelectedIndexChanged) |
| WK-DMF0049-0453 | G1 | HANDLER:clbPlanResult_SelectedIndexChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — HANDLER:clbPlanResult_SelectedIndexChanged: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbPlanResult_SelectedIndexChang) |
| WK-DMF0049-0454 | G1 | REQ:CHAT-20260820-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — REQ:CHAT-20260820-18: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-18) |
| WK-DMF0049-0455 | G1 | btnMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — btnMeasure: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (btnMeasure) |
| WK-DMF0049-0456 | G1 | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ②: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (②) |
| WK-DMF0049-0457 | G6 | btnMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — btnMeasure: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (btnMeasure) |
| WK-DMF0049-0458 | X-LOC | **DM_LOOKUP_DIV** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **DM_LOOKUP_DIV**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**DM_LOOKUP_DIV**) |
| WK-DMF0049-0459 | X-LOC | APPLICATION | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — APPLICATION: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (APPLICATION) |
| WK-DMF0049-0460 | X-LOC | COUNTRY_MST | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — COUNTRY_MST: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (COUNTRY_MST) |
| WK-DMF0049-0461 | X-LOC | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CurrencyList: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CurrencyList) |
| WK-DMF0049-0462 | X-LOC | DMF0005_REPORT_GROUP1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0005_REPORT_GROUP1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0005_REPORT_GROUP1) |
| WK-DMF0049-0463 | X-LOC | DMF0005_REPORT_GROUP4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0005_REPORT_GROUP4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0005_REPORT_GROUP4) |
| WK-DMF0049-0464 | X-LOC | DMF0005_REPORT_GROUP6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0005_REPORT_GROUP6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0005_REPORT_GROUP6) |
| WK-DMF0049-0465 | X-LOC | DMF0044_DEPARTMENT_TEAM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0044_DEPARTMENT_TEAM: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0044_DEPARTMENT_TEAM) |
| WK-DMF0049-0466 | X-LOC | DMF0044_DEPARTMENT_TEAM2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0044_DEPARTMENT_TEAM2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0044_DEPARTMENT_TEAM2) |
| WK-DMF0049-0467 | X-LOC | DMF0044_MDF_DEPARTMENT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0044_MDF_DEPARTMENT: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0044_MDF_DEPARTMENT) |
| WK-DMF0049-0468 | X-LOC | DMF0044_MDF_MEASURE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0044_MDF_MEASURE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0044_MDF_MEASURE) |
| WK-DMF0049-0469 | X-LOC | DM_COMPANY | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DM_COMPANY: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DM_COMPANY) |
| WK-DMF0049-0470 | X-LOC | END_CUST_REPORT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — END_CUST_REPORT: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (END_CUST_REPORT) |
| WK-DMF0049-0471 | X-LOC | EndCustomerByDivisionDept | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EndCustomerByDivisionDept: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EndCustomerByDivisionDept) |
| WK-DMF0049-0472 | X-LOC | FcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FcstType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FcstType) |
| WK-DMF0049-0473 | X-LOC | Incoterms | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Incoterms: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Incoterms) |
| WK-DMF0049-0474 | X-LOC | SOLD_TO_CUST_REPORT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SOLD_TO_CUST_REPORT: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SOLD_TO_CUST_REPORT) |
| WK-DMF0049-0475 | X-LOC | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — —: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (—) |
| WK-DMF0049-0476 | X-LOC | ① | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ①: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (①) |
| WK-DMF0049-0477 | X-LOC | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ②: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (②) |
| WK-DMF0049-0478 | X-ROW | APPLICATION | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — APPLICATION: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (APPLICATION) |
| WK-DMF0049-0479 | X-ROW | COUNTRY_MST | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — COUNTRY_MST: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (COUNTRY_MST) |
| WK-DMF0049-0480 | X-ROW | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CurrencyList: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CurrencyList) |
| WK-DMF0049-0481 | X-ROW | DMF0005_REPORT_GROUP1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0005_REPORT_GROUP1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0005_REPORT_GROUP1) |
| WK-DMF0049-0482 | X-ROW | DMF0005_REPORT_GROUP4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0005_REPORT_GROUP4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0005_REPORT_GROUP4) |
| WK-DMF0049-0483 | X-ROW | DMF0005_REPORT_GROUP6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0005_REPORT_GROUP6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0005_REPORT_GROUP6) |
| WK-DMF0049-0484 | X-ROW | DMF0044_DEPARTMENT_TEAM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_DEPARTMENT_TEAM: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0044_DEPARTMENT_TEAM) |
| WK-DMF0049-0485 | X-ROW | DMF0044_MDF_DEPARTMENT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDF_DEPARTMENT: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0044_MDF_DEPARTMENT) |
| WK-DMF0049-0486 | X-ROW | DMF0044_MDF_MEASURE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDF_MEASURE: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0044_MDF_MEASURE) |
| WK-DMF0049-0487 | X-ROW | DMF0049_Sales_ETC_Reports.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0049_Sales_ETC_Reports.CreateSpre) |
| WK-DMF0049-0488 | X-ROW | DMF0049_Sales_ETC_Reports.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.DefineProperty: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0049_Sales_ETC_Reports.DefineProp) |
| WK-DMF0049-0489 | X-ROW | DMF0049_Sales_ETC_Reports.DeleteButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.DeleteButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0049_Sales_ETC_Reports.DeleteButt) |
| WK-DMF0049-0490 | X-ROW | DMF0049_Sales_ETC_Reports.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.EditButton: 진입점 집계 28검사 — NOT_RUN:26 · REVIEW:2 |  | 5 (ACT:DMF0049_Sales_ETC_Reports.EditButton) |
| WK-DMF0049-0491 | X-ROW | DMF0049_Sales_ETC_Reports.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연 |  | 15 (ACT:DMF0049_Sales_ETC_Reports.ExcelButto) |
| WK-DMF0049-0492 | X-ROW | DMF0049_Sales_ETC_Reports.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:DMF0049_Sales_ETC_Reports.FindButton) |
| WK-DMF0049-0493 | X-ROW | DMF0049_Sales_ETC_Reports.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.FindData: 진입점 집계 20검사 — NOT_RUN:16 · REVIEW:2 · PASS:2 |  | 10 (ACT:DMF0049_Sales_ETC_Reports.FindData:5) |
| WK-DMF0049-0494 | X-ROW | DMF0049_Sales_ETC_Reports.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0049_Sales_ETC_Reports.Form_Load) |
| WK-DMF0049-0495 | X-ROW | DMF0049_Sales_ETC_Reports.GetCalendarYYY | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCalendarYYYY: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0049_Sales_ETC_Reports.GetCalenda) |
| WK-DMF0049-0496 | X-ROW | DMF0049_Sales_ETC_Reports.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCellColor: 진입점 집계 3검사 — NOT_RUN:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0049_Sales_ETC_Reports.GetCellCol) |
| WK-DMF0049-0497 | X-ROW | DMF0049_Sales_ETC_Reports.GetCellIndexBy | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCellIndexBySpanRowCel: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0049_Sales_ETC_Reports.GetCellInd) |
| WK-DMF0049-0498 | X-ROW | DMF0049_Sales_ETC_Reports.GetCellNumbers | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.GetCellNumbersByRow: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0049_Sales_ETC_Reports.GetCellNum) |
| WK-DMF0049-0499 | X-ROW | DMF0049_Sales_ETC_Reports.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.GetLookupData: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0049_Sales_ETC_Reports.GetLookupD) |
| WK-DMF0049-0500 | X-ROW | DMF0049_Sales_ETC_Reports.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.InitControls: 진입점 집계 10검사 — NOT_RUN:9 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0049_Sales_ETC_Reports.InitContro) |
| WK-DMF0049-0501 | X-ROW | DMF0049_Sales_ETC_Reports.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.InitSpread: 진입점 집계 10검사 — NOT_RUN:9 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InitSpread) |
| WK-DMF0049-0502 | X-ROW | DMF0049_Sales_ETC_Reports.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0049_Sales_ETC_Reports.InsertButt) |
| WK-DMF0049-0503 | X-ROW | DMF0049_Sales_ETC_Reports.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.InsertRow: 진입점 집계 43검사 — NOT_RUN:37 · NOPATH:6 (미실행 검사가 남아 판정필요) |  | 94 (ACT:DMF0049_Sales_ETC_Reports.InsertRow ) |
| WK-DMF0049-0504 | X-ROW | DMF0049_Sales_ETC_Reports.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.SaveData: 진입점 집계 15검사 — NOT_RUN:10 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0049_Sales_ETC_Reports.SaveData:6) |
| WK-DMF0049-0505 | X-ROW | DMF0049_Sales_ETC_Reports.SetChangeContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.SetChangeControl: 진입점 집계 4검사 — REVIEW:2 · NOT_RUN:2 |  | 2 (ACT:DMF0049_Sales_ETC_Reports.SetChangeC) |
| WK-DMF0049-0506 | X-ROW | DMF0049_Sales_ETC_Reports.SetRowSpanFucT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.SetRowSpanFucTwo: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0049_Sales_ETC_Reports.SetRowSpan) |
| WK-DMF0049-0507 | X-ROW | DMF0049_Sales_ETC_Reports.YearSet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.YearSet: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0049_Sales_ETC_Reports.YearSet AC) |
| WK-DMF0049-0508 | X-ROW | DMF0049_Sales_ETC_Reports.btnMeasure_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.btnMeasure_Click: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0049_Sales_ETC_Reports.btnMeasure) |
| WK-DMF0049-0509 | X-ROW | DMF0049_Sales_ETC_Reports.btnSPVer_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.btnSPVer_Click: 진입점 집계 6검사 — NOT_RUN:4 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0049_Sales_ETC_Reports.btnSPVer_C) |
| WK-DMF0049-0510 | X-ROW | DMF0049_Sales_ETC_Reports.clbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.clbDivision_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0049_Sales_ETC_Reports.clbDivisio) |
| WK-DMF0049-0511 | X-ROW | DMF0049_Sales_ETC_Reports.clbPlanResult_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.clbPlanResult_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0049_Sales_ETC_Reports.clbPlanRes) |
| WK-DMF0049-0512 | X-ROW | DMF0049_Sales_ETC_Reports.clbType_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.clbType_SelectedIndexCha: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0049_Sales_ETC_Reports.clbType_Se) |
| WK-DMF0049-0513 | X-ROW | DMF0049_Sales_ETC_Reports.spdMain_CellCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.spdMain_CellClick: 진입점 집계 9검사 — NOPATH:6 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0514 | X-ROW | DMF0049_Sales_ETC_Reports.spdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.spdMain_CellDoubleClick: 진입점 집계 7검사 — NOT_RUN:5 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ce) |
| WK-DMF0049-0515 | X-ROW | DMF0049_Sales_ETC_Reports.spdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0049_Sales_ETC_Reports.spdMain_Changed: 진입점 집계 62검사 — NOT_RUN:38 · NOPATH:18 · TODO:3 · REVIEW:3 |  | 33 (ACT:DMF0049_Sales_ETC_Reports.spdMain_Ch) |
| WK-DMF0049-0516 | X-ROW | DM_COMPANY | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DM_COMPANY: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DM_COMPANY) |
| WK-DMF0049-0517 | X-ROW | DV-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DV-22: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DV-22) |
| WK-DMF0049-0518 | X-ROW | E01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E01) |
| WK-DMF0049-0519 | X-ROW | E05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E05: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E05) |
| WK-DMF0049-0520 | X-ROW | END_CUST_REPORT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — END_CUST_REPORT: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (END_CUST_REPORT) |
| WK-DMF0049-0521 | X-ROW | FcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — FcstType: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (FcstType) |
| WK-DMF0049-0522 | X-ROW | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:Form_Load: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:Form_Load) |
| WK-DMF0049-0523 | X-ROW | HANDLER:btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnMeasure_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnMeasure_Click) |
| WK-DMF0049-0524 | X-ROW | HANDLER:btnSPVer_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnSPVer_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnSPVer_Click) |
| WK-DMF0049-0525 | X-ROW | L121 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L121: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L121) |
| WK-DMF0049-0526 | X-ROW | MODAL:EtcSalesReportsModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:EtcSalesReportsModals: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:EtcSalesReportsModals) |
| WK-DMF0049-0527 | X-ROW | SOLD_TO_CUST_REPORT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SOLD_TO_CUST_REPORT: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SOLD_TO_CUST_REPORT) |
| WK-DMF0049-0528 | G5 | DM0002_TitleSetForm_Popup (M 모드) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DM0002_TitleSetForm_Popup (M 모드): 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (DM0002_TitleSetForm_Popup (M 모드)) |
| WK-DMF0049-0529 | G5 | DMF0044_Sales_VersionPopUp / DM0002_Item | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0044_Sales_VersionPopUp / DM0002_Item 팝업: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (DMF0044_Sales_VersionPopUp / DM0002_Item) |
| WK-DMF0049-0530 | G5 | DMF0044_United_VersionPopup(727 — 공유) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — DMF0044_United_VersionPopup(727 — 공유): 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (DMF0044_United_VersionPopup(727 — 공유)) |
| WK-DMF0049-0531 | G5 | E04-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E04-2: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (E04-2) |
| WK-DMF0049-0532 | G5 | E05-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E05-3: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (E05-3) |
| WK-DMF0049-0533 | G5 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E06: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (E06) |
| WK-DMF0049-0534 | G5 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0049-0535 | G5 | MODAL:MeasureSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:MeasureSelectModal: 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MeasureSelectModal) |
| WK-DMF0049-0536 | G5 | SCM0002_ProjectbyDivisionPopupEx (ETC=tr | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCM0002_ProjectbyDivisionPopupEx (ETC=true): 행 집계 — G5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ProjectbyDivisionPopupEx (ETC=tr) |
| WK-DMF0049-0537 | H6 | DM0002_TitleSetForm_Popup (M 모드) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DM0002_TitleSetForm_Popup (M 모드): 행 집계 — H6 5요소: NOPATH:3 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (DM0002_TitleSetForm_Popup (M 모드)) |
| WK-DMF0049-0538 | H6 | DMF0044_Sales_VersionPopUp / DM0002_Item | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0044_Sales_VersionPopUp / DM0002_Item 팝업: 행 집계 — H6 5요소: NOPATH:3 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (DMF0044_Sales_VersionPopUp / DM0002_Item) |
| WK-DMF0049-0539 | H6 | DMF0044_United_VersionPopup(727 — 공유) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — DMF0044_United_VersionPopup(727 — 공유): 행 집계 — H6 5요소: NOPATH:3 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (DMF0044_United_VersionPopup(727 — 공유)) |
| WK-DMF0049-0540 | H6 | E04-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E04-2: 행 집계 — H6 5요소: NOPATH:3 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (E04-2) |
| WK-DMF0049-0541 | H6 | E05-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E05-3: 행 집계 — H6 5요소: NOPATH:3 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (E05-3) |
| WK-DMF0049-0542 | H6 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E06: 행 집계 — H6 5요소: NOPATH:3 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (E06) |
| WK-DMF0049-0543 | H6 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — H6 5요소: NOPATH:3 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0049-0544 | H6 | MODAL:MeasureSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:MeasureSelectModal: 행 집계 — H6 5요소: NOPATH:3 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MeasureSelectModal) |
| WK-DMF0049-0545 | H6 | SCM0002_ProjectbyDivisionPopupEx (ETC=tr | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCM0002_ProjectbyDivisionPopupEx (ETC=true): 행 집계 — H6 5요소: NOPATH:3 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ProjectbyDivisionPopupEx (ETC=tr) |
| WK-DMF0049-0546 | M4 | DM0002_TitleSetForm_Popup (M 모드) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DM0002_TitleSetForm_Popup (M 모드): 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (DM0002_TitleSetForm_Popup (M 모드)) |
| WK-DMF0049-0547 | M4 | DMF0044_Sales_VersionPopUp / DM0002_Item | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0044_Sales_VersionPopUp / DM0002_Item 팝업: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (DMF0044_Sales_VersionPopUp / DM0002_Item) |
| WK-DMF0049-0548 | M4 | DMF0044_United_VersionPopup(727 — 공유) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — DMF0044_United_VersionPopup(727 — 공유): 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (DMF0044_United_VersionPopup(727 — 공유)) |
| WK-DMF0049-0549 | M4 | E04-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E04-2: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E04-2) |
| WK-DMF0049-0550 | M4 | E05-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E05-3: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E05-3) |
| WK-DMF0049-0551 | M4 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E06: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E06) |
| WK-DMF0049-0552 | M4 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0049-0553 | M4 | MODAL:MeasureSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:MeasureSelectModal: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MeasureSelectModal) |
| WK-DMF0049-0554 | M4 | SCM0002_ProjectbyDivisionPopupEx (ETC=tr | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCM0002_ProjectbyDivisionPopupEx (ETC=true): 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ProjectbyDivisionPopupEx (ETC=tr) |

## W8 구현 후 검증 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0049-0555 | B1 | COMMON:UC-05 | 선행 W1 완료 후 E2E | B1 — 대조표 미구현 행 COMMON:UC-05 구현 후 검증 · 대상 COMMON:UC-05 |  | 1 (COMMON:UC-05) |
| WK-DMF0049-0556 | B2 | COMMON:UC-05 | 선행 W1 완료 후 E2E | B2 — 대조표 미구현 행 COMMON:UC-05 구현 후 검증 · 대상 COMMON:UC-05 |  | 1 (COMMON:UC-05) |
| WK-DMF0049-0557 | B4 | COMMON:UC-05 | 선행 W1 완료 후 E2E | B4 — 대조표 미구현 행 COMMON:UC-05 구현 후 검증 · 대상 COMMON:UC-05 |  | 1 (COMMON:UC-05) |
| WK-DMF0049-0558 | G3 | DMF0049 화면 | 선행 W1 완료 후 E2E | G3 — 대조표 미구현 행 COMMON:UC-01, COMMON:UC-02, COMMON:UC-03, COMMON:UC-04 구현 후 검증 · 대상 DMF0049 화면 |  | 7 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-DMF0049-0559 | G4 | COMMON:UC-06 | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행 COMMON:UC-06 구현 후 검증 · 대상 COMMON:UC-06 |  | 1 (COMMON:UC-06) |
| WK-DMF0049-0560 | D4 | COMMON:UC-01 | 선행 W1 완료 후 E2E | D4 — 대조표 미구현 행 COMMON:UC-01 구현 후 검증 · 대상 COMMON:UC-01 |  | 1 (COMMON:UC-01) |
| WK-DMF0049-0561 | D4 | COMMON:UC-03 | 선행 W1 완료 후 E2E | D4 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-DMF0049-0562 | D5 | COMMON:UC-05 | 선행 W1 완료 후 E2E | D5 — 대조표 미구현 행 COMMON:UC-05 구현 후 검증 · 대상 COMMON:UC-05 |  | 1 (COMMON:UC-05) |
| WK-DMF0049-0563 | E4 | DMF0049_Sales_ETC_Reports.SetRowSpanFucT | 선행 W1 완료 후 E2E | E4 — 대조표 미구현 행  구현 후 검증 · 대상 DMF0049_Sales_ETC_Reports.SetRowSpanFucTwo |  | 14 (ACT:DMF0049_Sales_ETC_Reports.SetRowSpan) |
| WK-DMF0049-0564 | E4 | MSG00703 | 선행 W1 완료 후 E2E | E4 — 대조표 미구현 행 COMMON:UC-02 구현 후 검증 · 대상 MSG00703 |  | 1 (COMMON:UC-02) |
| WK-DMF0049-0565 | E4 | REQ:CHAT-20260820-17 | 선행 W1 완료 후 E2E | E4 — 대조표 미구현 행  구현 후 검증 · 대상 REQ:CHAT-20260820-17 |  | 1 (REQ:CHAT-20260820-17) |
| WK-DMF0049-0566 | E5 | COMMON:UC-05 | 선행 W1 완료 후 E2E | E5 — 대조표 미구현 행 COMMON:UC-05 구현 후 검증 · 대상 COMMON:UC-05 |  | 1 (COMMON:UC-05) |
| WK-DMF0049-0567 | A1 | COMMON:UC-02 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 COMMON:UC-02 구현 후 검증 · 대상 COMMON:UC-02 |  | 1 (COMMON:UC-02) |
| WK-DMF0049-0568 | A1 | COMMON:UC-03 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-DMF0049-0569 | A1 | COMMON:UC-06 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 COMMON:UC-06 구현 후 검증 · 대상 COMMON:UC-06 |  | 1 (COMMON:UC-06) |
| WK-DMF0049-0570 | A1 | COMMON:UC-07 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 COMMON:UC-07 구현 후 검증 · 대상 COMMON:UC-07 |  | 1 (COMMON:UC-07) |
| WK-DMF0049-0571 | G1 | COMMON:UC-02 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 COMMON:UC-02 구현 후 검증 · 대상 COMMON:UC-02 |  | 1 (COMMON:UC-02) |
| WK-DMF0049-0572 | G1 | COMMON:UC-03 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-DMF0049-0573 | G1 | COMMON:UC-06 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 COMMON:UC-06 구현 후 검증 · 대상 COMMON:UC-06 |  | 1 (COMMON:UC-06) |
| WK-DMF0049-0574 | G1 | COMMON:UC-07 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 COMMON:UC-07 구현 후 검증 · 대상 COMMON:UC-07 |  | 1 (COMMON:UC-07) |
| WK-DMF0049-0575 | G6 | COMMON:UC-06 | 선행 W1 완료 후 E2E | G6 — 대조표 미구현 행 COMMON:UC-06 구현 후 검증 · 대상 COMMON:UC-06 |  | 1 (COMMON:UC-06) |
| WK-DMF0049-0576 | X-ROW | COMMON:UC-04 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행  구현 후 검증 · 대상 COMMON:UC-04 |  | 0 () |
