# 작업 원장 — DMF0044 · 2026-10-26 12:50

> 검사 인스턴스 1167건 중 PASS·NA 72건 외 **1095건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 7 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 145 | 구현 위치 실존 |
| W4 | 검사기 구현 | 5 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 80 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 308 | 실행 → PASS |
| W7 | 기대값 확정 | 526 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 24 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 508 · E2E 308 · 대조표 163 · 하네스 85 · 선행 W1 완료 후 E2E 24 · FE 7
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 23건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 196 | 1 |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 145 |  |  |  |  | 26 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 44 |  | 6 |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F4 | DB |  |  |  |  |  | 35 | 12 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A1 | GEN |  |  |  |  |  |  | 42 | 4 |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| D3 | EDIT |  |  |  |  |  | 18 | 22 |  |  | 행 값 기반 조건부 잠금 |
| M4 | POPUP |  |  |  |  |  | 21 | 18 |  |  | 팝업 선택값 반영 |
| G5 | POPUP |  |  |  |  | 19 |  | 18 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 14 | 5 | 18 |  |  | 팝업 표준·열림 |
| D1 | EDIT |  |  |  |  |  | 18 | 18 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| G1 | GEN |  |  |  |  |  | 10 | 22 | 4 |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| C3 | CASCADE |  |  |  |  |  | 23 | 10 |  |  | 연쇄 자동 채움 |
| DB-SYN | DB |  |  |  |  | 20 |  | 11 |  |  | BE 계정 시노님·권한·대상 객체 |
| H2 | DESIGN |  |  |  |  |  | 11 | 18 |  |  | 배경·글자색 규칙 |
| A5 | DESIGN |  |  |  |  |  | 14 | 12 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 13 | 11 |  |  | 라벨 명칭 |
| G4 | DESIGN |  |  |  |  | 3 | 10 | 5 | 1 |  | 조회조건 표시·라벨·활성 |
| D5 | EDIT |  |  |  |  |  | 16 | 1 | 1 |  | 셀 에디터 유형 |
| X-REASON | DESIGN |  |  |  |  |  |  | 18 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B4 | COMBO |  |  |  |  | 8 |  | 7 | 1 |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G6 | GEN |  |  |  |  |  | 9 | 6 | 1 |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| A6 | GEN |  |  |  |  |  | 11 | 4 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| M3 | POPUP |  |  |  |  |  | 15 |  |  |  | 팝업 내부 기능(조회·CRUD) |
| C2 | CASCADE |  |  |  |  |  | 8 | 6 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 8 | 6 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| B3 | COMBO |  |  |  | 5 |  |  | 7 |  |  | 콤보 후보 정렬 = AS-IS |
| C1 | CASCADE |  |  |  |  |  | 5 | 5 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| D4 | EDIT |  |  |  |  |  | 1 | 6 | 2 |  | 신규행 기본값·자동세팅·Insert 전제 |
| X-NOTIMPL | GEN | 7 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| B1 | COMBO |  |  |  |  | 6 |  |  | 1 |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 6 |  |  | 1 |  | 콤보 후보 중복 없음 |
| E2 | EDIT |  |  |  |  | 1 |  | 1 |  |  | 날짜 형식·유효성 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| E5 | EDIT |  |  |  |  |  |  |  | 1 |  | 콤보 셀 후보 외 값 차단 |

## W1 기능 구현 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0044-0001 | X-NOTIMPL | COMMON:UC-01 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-01 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026 |  | 1 (COMMON:UC-01) |
| WK-DMF0044-0002 | X-NOTIMPL | COMMON:UC-02 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4)   미구현 |  | 1 (COMMON:UC-02) |
| WK-DMF0044-0003 | X-NOTIMPL | COMMON:UC-03 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5)   미구현 |  | 1 (COMMON:UC-03) |
| WK-DMF0044-0004 | X-NOTIMPL | COMMON:UC-04 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-04 CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6)   미구현 |  | 1 (COMMON:UC-04) |
| WK-DMF0044-0005 | X-NOTIMPL | COMMON:UC-05 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-05 Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7)   미구현 |  | 1 (COMMON:UC-05) |
| WK-DMF0044-0006 | X-NOTIMPL | COMMON:UC-06 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)   미구현 |  | 1 (COMMON:UC-06) |
| WK-DMF0044-0007 | X-NOTIMPL | COMMON:UC-07 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — COMMON:UC-07 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②)   미구현 |  | 1 (COMMON:UC-07) |

## W2 구현 위치 확인 (145)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0044-0008 | X-LOC | 1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1) |
| WK-DMF0044-0009 | X-LOC | 2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2) |
| WK-DMF0044-0010 | X-LOC | 3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3) |
| WK-DMF0044-0011 | X-LOC | 4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (4) |
| WK-DMF0044-0012 | X-LOC | 5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (5) |
| WK-DMF0044-0013 | X-LOC | 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (6) |
| WK-DMF0044-0014 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (7) |
| WK-DMF0044-0015 | X-LOC | 8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (8) |
| WK-DMF0044-0016 | X-LOC | A-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A-1) |
| WK-DMF0044-0017 | X-LOC | A-12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 |  | 1 (A-12) |
| WK-DMF0044-0018 | X-LOC | A-14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 |  | 1 (A-14) |
| WK-DMF0044-0019 | X-LOC | A-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/useSalesReportsStore.ts 없음 |  | 1 (A-2) |
| WK-DMF0044-0020 | X-LOC | A-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (A-3) |
| WK-DMF0044-0021 | X-LOC | CRUD:E02:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0044-0022 | X-LOC | CRUD:E03:EDIT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (CRUD:E03:EDIT) |
| WK-DMF0044-0023 | X-LOC | CRUD:E04:SAVE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (CRUD:E04:SAVE) |
| WK-DMF0044-0024 | X-LOC | D-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (D-1) |
| WK-DMF0044-0025 | X-LOC | D-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (D-2) |
| WK-DMF0044-0026 | X-LOC | D-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (D-3) |
| WK-DMF0044-0027 | X-LOC | D-4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (D-4) |
| WK-DMF0044-0028 | X-LOC | E01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (E01) |
| WK-DMF0044-0029 | X-LOC | E01-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (E01-2) |
| WK-DMF0044-0030 | X-LOC | E01-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx 없음 |  | 1 (E01-3) |
| WK-DMF0044-0031 | X-LOC | E01-4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (E01-4) |
| WK-DMF0044-0032 | X-LOC | E01-5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (E01-5) |
| WK-DMF0044-0033 | X-LOC | E02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/useSalesReportsStore.ts 없음 |  | 1 (E02) |
| WK-DMF0044-0034 | X-LOC | E03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (E03) |
| WK-DMF0044-0035 | X-LOC | E03-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (E03-1) |
| WK-DMF0044-0036 | X-LOC | E03-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (E03-2) |
| WK-DMF0044-0037 | X-LOC | E04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (E04) |
| WK-DMF0044-0038 | X-LOC | E04-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.save.ts 없음 |  | 1 (E04-1) |
| WK-DMF0044-0039 | X-LOC | E04-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.save.ts 없음 |  | 1 (E04-2) |
| WK-DMF0044-0040 | X-LOC | E05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/components/versionModal/VersionModal.tsx 없음 |  | 1 (E05) |
| WK-DMF0044-0041 | X-LOC | E05-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/components/versionModal/VersionModal.tsx 없음 |  | 1 (E05-1) |
| WK-DMF0044-0042 | X-LOC | E05-5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음, components/modals/MeasureSelectModal.tsx 없음 |  | 1 (E05-5) |
| WK-DMF0044-0043 | X-LOC | E06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 |  | 1 (E06) |
| WK-DMF0044-0044 | X-LOC | E07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx 없음 |  | 1 (E07) |
| WK-DMF0044-0045 | X-LOC | E08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (E08) |
| WK-DMF0044-0046 | X-LOC | E08-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (E08-1) |
| WK-DMF0044-0047 | X-LOC | E08-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (E08-2) |
| WK-DMF0044-0048 | X-LOC | E09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (E09) |
| WK-DMF0044-0049 | X-LOC | E09-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (E09-1) |
| WK-DMF0044-0050 | X-LOC | E09-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (E09-2) |
| WK-DMF0044-0051 | X-LOC | E10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E10) |
| WK-DMF0044-0052 | X-LOC | E11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.validate.ts 없음 |  | 1 (E11) |
| WK-DMF0044-0053 | X-LOC | HANDLER:DeleteButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (HANDLER:DeleteButton) |
| WK-DMF0044-0054 | X-LOC | HANDLER:EditButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (HANDLER:EditButton) |
| WK-DMF0044-0055 | X-LOC | HANDLER:ExcelButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0044-0056 | X-LOC | HANDLER:FindData | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/useSalesReportsStore.ts 없음 |  | 1 (HANDLER:FindData) |
| WK-DMF0044-0057 | X-LOC | HANDLER:Form_Load | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (HANDLER:Form_Load) |
| WK-DMF0044-0058 | X-LOC | HANDLER:InsertRow | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (HANDLER:InsertRow) |
| WK-DMF0044-0059 | X-LOC | HANDLER:SaveData | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (HANDLER:SaveData) |
| WK-DMF0044-0060 | X-LOC | HANDLER:btnExchangeRate_Click | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (HANDLER:btnExchangeRate_Click) |
| WK-DMF0044-0061 | X-LOC | HANDLER:btnMeasure_Click | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (HANDLER:btnMeasure_Click) |
| WK-DMF0044-0062 | X-LOC | HANDLER:btnSPVer_Click | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 |  | 1 (HANDLER:btnSPVer_Click) |
| WK-DMF0044-0063 | X-LOC | HANDLER:btnTextbox_Click | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (HANDLER:btnTextbox_Click) |
| WK-DMF0044-0064 | X-LOC | HANDLER:clbDivision_SelectedIndexChanged | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (HANDLER:clbDivision_SelectedIndexChanged) |
| WK-DMF0044-0065 | X-LOC | HANDLER:clbType_SelectedIndexChanged | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx 없음 |  | 1 (HANDLER:clbType_SelectedIndexChanged) |
| WK-DMF0044-0066 | X-LOC | HANDLER:spdMain_CellDoubleClick | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0044-0067 | X-LOC | HANDLER:spdMain_Changed | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (HANDLER:spdMain_Changed) |
| WK-DMF0044-0068 | X-LOC | L-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (L-01) |
| WK-DMF0044-0069 | X-LOC | L-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (L-02) |
| WK-DMF0044-0070 | X-LOC | L-03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-03) |
| WK-DMF0044-0071 | X-LOC | L-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (L-04) |
| WK-DMF0044-0072 | X-LOC | L-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-05) |
| WK-DMF0044-0073 | X-LOC | L-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (L-06) |
| WK-DMF0044-0074 | X-LOC | L-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-07) |
| WK-DMF0044-0075 | X-LOC | L-08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-08) |
| WK-DMF0044-0076 | X-LOC | L-09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (L-09) |
| WK-DMF0044-0077 | X-LOC | L-10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-10) |
| WK-DMF0044-0078 | X-LOC | L-11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-11) |
| WK-DMF0044-0079 | X-LOC | L-12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-12) |
| WK-DMF0044-0080 | X-LOC | L-13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-13) |
| WK-DMF0044-0081 | X-LOC | L-14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-14) |
| WK-DMF0044-0082 | X-LOC | L-15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-15) |
| WK-DMF0044-0083 | X-LOC | L-16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-16) |
| WK-DMF0044-0084 | X-LOC | L-17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-17) |
| WK-DMF0044-0085 | X-LOC | L-18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-18) |
| WK-DMF0044-0086 | X-LOC | L-19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-19) |
| WK-DMF0044-0087 | X-LOC | L-20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-20) |
| WK-DMF0044-0088 | X-LOC | L-21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (L-21) |
| WK-DMF0044-0089 | X-LOC | L-24 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 |  | 1 (L-24) |
| WK-DMF0044-0090 | X-LOC | L-26 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 |  | 1 (L-26) |
| WK-DMF0044-0091 | X-LOC | L-27 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 |  | 1 (L-27) |
| WK-DMF0044-0092 | X-LOC | L-28 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 |  | 1 (L-28) |
| WK-DMF0044-0093 | X-LOC | L-29 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 |  | 1 (L-29) |
| WK-DMF0044-0094 | X-LOC | L-30 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx 없음 |  | 1 (L-30) |
| WK-DMF0044-0095 | X-LOC | M-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (M-1) |
| WK-DMF0044-0096 | X-LOC | M-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (M-2) |
| WK-DMF0044-0097 | X-LOC | M-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (M-3) |
| WK-DMF0044-0098 | X-LOC | M-4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음, nscm-fe/features/demand/src/p |  | 1 (M-4) |
| WK-DMF0044-0099 | X-LOC | M-5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (M-5) |
| WK-DMF0044-0100 | X-LOC | M-6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.gridCombos.ts 없음 |  | 1 (M-6) |
| WK-DMF0044-0101 | X-LOC | M-7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.gridCombos.ts 없음 |  | 1 (M-7) |
| WK-DMF0044-0102 | X-LOC | M-8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 |  | 1 (M-8) |
| WK-DMF0044-0103 | X-LOC | MODAL:ExchangeRateModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0044-0104 | X-LOC | MODAL:MeasureSelectModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/MeasureSelectModal.tsx 없음 |  | 1 (MODAL:MeasureSelectModal) |
| WK-DMF0044-0105 | X-LOC | MODAL:SalesReportsModals | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsModals.tsx 없음 |  | 1 (MODAL:SalesReportsModals) |
| WK-DMF0044-0106 | X-LOC | MODAL:TextboxModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx 없음 |  | 1 (MODAL:TextboxModal) |
| WK-DMF0044-0107 | X-LOC | MSG00002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00002) |
| WK-DMF0044-0108 | X-LOC | MSG00004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00004) |
| WK-DMF0044-0109 | X-LOC | MSG00006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00006) |
| WK-DMF0044-0110 | X-LOC | MSG00096 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00096) |
| WK-DMF0044-0111 | X-LOC | MSG00142 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00142) |
| WK-DMF0044-0112 | X-LOC | MSG00279/280/156/143/151 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00279/280/156/143/151) |
| WK-DMF0044-0113 | X-LOC | MSG00281 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00281) |
| WK-DMF0044-0114 | X-LOC | MSG00283 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00283) |
| WK-DMF0044-0115 | X-LOC | MSG00314/00016/00195 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00314/00016/00195) |
| WK-DMF0044-0116 | X-LOC | MSG00318/319/320 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00318/319/320) |
| WK-DMF0044-0117 | X-LOC | MSG00321 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00321) |
| WK-DMF0044-0118 | X-LOC | REQ:CHAT-20260820-10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-10) |
| WK-DMF0044-0119 | X-LOC | REQ:CHAT-20260820-11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-11) |
| WK-DMF0044-0120 | X-LOC | REQ:CHAT-20260820-12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-12) |
| WK-DMF0044-0121 | X-LOC | REQ:CHAT-20260820-13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-13) |
| WK-DMF0044-0122 | X-LOC | REQ:CHAT-20260820-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-2) |
| WK-DMF0044-0123 | X-LOC | REQ:CHAT-20260820-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-3) |
| WK-DMF0044-0124 | X-LOC | REQ:CHAT-20260820-4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-4) |
| WK-DMF0044-0125 | X-LOC | REQ:CHAT-20260820-5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-5) |
| WK-DMF0044-0126 | X-LOC | REQ:CHAT-20260820-6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-6) |
| WK-DMF0044-0127 | X-LOC | REQ:CHAT-20260820-7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-7) |
| WK-DMF0044-0128 | X-LOC | REQ:CHAT-20260820-8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-8) |
| WK-DMF0044-0129 | X-LOC | REQ:CHAT-20260820-9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (REQ:CHAT-20260820-9) |
| WK-DMF0044-0130 | X-LOC | V-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/useSalesReportsStore.ts 없음 |  | 1 (V-1) |
| WK-DMF0044-0131 | X-LOC | V-10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx 없음 |  | 1 (V-10) |
| WK-DMF0044-0132 | X-LOC | V-11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (V-11) |
| WK-DMF0044-0133 | X-LOC | V-12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 |  | 1 (V-12) |
| WK-DMF0044-0134 | X-LOC | V-13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx 없음 |  | 1 (V-13) |
| WK-DMF0044-0135 | X-LOC | V-14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/version-modal.api.ts 없음 |  | 1 (V-14) |
| WK-DMF0044-0136 | X-LOC | V-15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/version-modal.api.ts 없음 |  | 1 (V-15) |
| WK-DMF0044-0137 | X-LOC | V-16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/version-modal.api.ts 없음 |  | 1 (V-16) |
| WK-DMF0044-0138 | X-LOC | V-17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 |  | 1 (V-17) |
| WK-DMF0044-0139 | X-LOC | V-18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 |  | 1 (V-18) |
| WK-DMF0044-0140 | X-LOC | V-19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 |  | 1 (V-19) |
| WK-DMF0044-0141 | X-LOC | V-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (V-2) |
| WK-DMF0044-0142 | X-LOC | V-20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/version-modal.constants.ts 없음 |  | 1 (V-20) |
| WK-DMF0044-0143 | X-LOC | V-21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 |  | 1 (V-21) |
| WK-DMF0044-0144 | X-LOC | V-22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 |  | 1 (V-22) |
| WK-DMF0044-0145 | X-LOC | V-23 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/versionModal/version-modal.api.ts 없음 |  | 1 (V-23) |
| WK-DMF0044-0146 | X-LOC | V-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (V-3) |
| WK-DMF0044-0147 | X-LOC | V-4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 |  | 1 (V-4) |
| WK-DMF0044-0148 | X-LOC | V-5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.validate.ts 없음 |  | 1 (V-5) |
| WK-DMF0044-0149 | X-LOC | V-6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.validate.ts 없음 |  | 1 (V-6) |
| WK-DMF0044-0150 | X-LOC | V-7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (V-7) |
| WK-DMF0044-0151 | X-LOC | V-8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 |  | 1 (V-8) |
| WK-DMF0044-0152 | X-LOC | — | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (—) |

## W4 검사기 구현 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0044-0153 | B3 | DEPARTMENT_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DEPARTMENT_ID | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0154 | B3 | DEPT_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DEPT_ID | 있음(SHEET_COLUMNS) | 2 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0155 | B3 | PRODUCT_GROUP | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PRODUCT_GROUP | 있음(SHEET_COLUMNS) | 1 (DMF0005_REPORT_GROUP3) |
| WK-DMF0044-0156 | B3 | clbDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivision / Division | 있음(FE 소스) | 2 (ACT:DMF0044_United_VersionPopup.GetSpdTi) |
| WK-DMF0044-0157 | B3 | clbType / Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbType / Type | 있음(FE 소스) | 1 (2) |

## W5 검사기 연결 (80)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0044-0158 | B1 | CUST_REPORT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL CUST_REPORT | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0159 | B1 | DEPARTMENT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DEPARTMENT_ID | 있음(SHEET_COLUMNS) | 5 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0160 | B1 | DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DEPT_ID | 있음(SHEET_COLUMNS) | 9 (ACT:DMF0044_Sales_Reports.InsertRow:991:) |
| WK-DMF0044-0161 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0044_SalesReportExchangePopup.Ins) |
| WK-DMF0044-0162 | B1 | END_CUST_REPORT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL END_CUST_REPORT | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0163 | B1 | PRODUCT_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL PRODUCT_GROUP | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0164 | B2 | CUST_REPORT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL CUST_REPORT | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0165 | B2 | DEPARTMENT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DEPARTMENT_ID | 있음(SHEET_COLUMNS) | 5 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0166 | B2 | DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DEPT_ID | 있음(SHEET_COLUMNS) | 9 (ACT:DMF0044_Sales_Reports.InsertRow:991:) |
| WK-DMF0044-0167 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0044_SalesReportExchangePopup.Ins) |
| WK-DMF0044-0168 | B2 | END_CUST_REPORT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL END_CUST_REPORT | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0169 | B2 | PRODUCT_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL PRODUCT_GROUP | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0170 | B4 | CUST_REPORT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CUST_REPORT | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0171 | B4 | DEPARTMENT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DEPARTMENT_ID | 있음(SHEET_COLUMNS) | 7 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0172 | B4 | DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DEPT_ID | 있음(SHEET_COLUMNS) | 11 (ACT:DMF0044_Sales_Reports.InsertRow:991:) |
| WK-DMF0044-0173 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0044_SalesReportExchangePopup.Ins) |
| WK-DMF0044-0174 | B4 | END_CUST_REPORT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL END_CUST_REPORT | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0175 | B4 | PRODUCT_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PRODUCT_GROUP | 있음(SHEET_COLUMNS) | 4 (DMF0005_REPORT_GROUP3 ACT:DMF0044_Sales_) |
| WK-DMF0044-0176 | B4 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 2 (ACT:DMF0044_United_VersionPopup.GetSpdTi) |
| WK-DMF0044-0177 | B4 | clbType / Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbType / Type | 있음(FE 소스) | 1 (2) |
| WK-DMF0044-0178 | F2 | DMF0044 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0044 화면 | 판단불가(대상 단위 SCREEN) | 548 (E02-1 E04 E04-1 E04-2 E05-5 E09-1 V-6 CR) |
| WK-DMF0044-0179 | F6 | DMF0044 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN DMF0044 화면 | 판단불가(대상 단위 SCREEN) | 531 (E04 CRUD:E04:SAVE REQ:CHAT-20260820-5 HA) |
| WK-DMF0044-0180 | DB-SYN | DM0021_GET_DM_MST_VERSION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0021_GET_DM_MST_VERSION | 없음(PROC_M 대응 없음) | 5 (ACT:DMF0044_MDFVersionPopUp.FindData:269) |
| WK-DMF0044-0181 | DB-SYN | DMF0044_GET_COPY_VERSION_POPUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0044_GET_COPY_VERSION_POPUP | 없음(PROC_M 대응 없음) | 3 (ACT:DMF0044_Sales_VersionCopyPopUp.FindD) |
| WK-DMF0044-0182 | DB-SYN | PKG_DMF0044 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_DMF0044 | 없음(PROC_M 대응 없음) | 1 (REQ:CHAT-20260820-5) |
| WK-DMF0044-0183 | DB-SYN | P_CREATED_BY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_CREATED_BY | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0184 | DB-SYN | P_DESCRIPTION1 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION1 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0185 | DB-SYN | P_DESCRIPTION10 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION10 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0186 | DB-SYN | P_DESCRIPTION11 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION11 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0187 | DB-SYN | P_DESCRIPTION12 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION12 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0188 | DB-SYN | P_DESCRIPTION13 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION13 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0189 | DB-SYN | P_DESCRIPTION2 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION2 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0190 | DB-SYN | P_DESCRIPTION3 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION3 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0191 | DB-SYN | P_DESCRIPTION4 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION4 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0192 | DB-SYN | P_DESCRIPTION5 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION5 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0193 | DB-SYN | P_DESCRIPTION6 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION6 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0194 | DB-SYN | P_DESCRIPTION7 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION7 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0195 | DB-SYN | P_DESCRIPTION8 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION8 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0196 | DB-SYN | P_DESCRIPTION9 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DESCRIPTION9 | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0197 | DB-SYN | P_VERSION_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_VERSION_NO | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Fin) |
| WK-DMF0044-0198 | DB-SYN | P_YYYYMM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_YYYYMM | 없음(PROC_M 대응 없음) | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0199 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 6 (ACT:DMF0044_Sales_Reports.GetLookupData:) |
| WK-DMF0044-0200 | G4 | btnExchangeRate | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnExchangeRate | 있음(FE 소스) | 1 (7) |
| WK-DMF0044-0201 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 없음 | 2 (E02-2 7) |
| WK-DMF0044-0202 | G4 | btnSPVer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSPVer | 있음(FE 소스) | 2 (E02-2 5) |
| WK-DMF0044-0203 | E2 | CUTOFF_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL CUTOFF_YYYYMMDD | 있음(SHEET_COLUMNS) | 1 (L-12) |
| WK-DMF0044-0204 | G03-WIRE | DMF0044 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0044 화면 | 판단불가(대상 단위 SCREEN) | 28 (ACT:DMF0044_MDFVersionPopUp..ctor ACT:DM) |
| WK-DMF0044-0205 | G5 | CURRENCY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL CURRENCY | 있음(SHEET_COLUMNS) | 1 (L-28) |
| WK-DMF0044-0206 | G5 | CURRENCY_UNITCURRENCY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL CURRENCY_UNITCURRENCY | 있음(SHEET_COLUMNS) | 2 (L-26 L-29) |
| WK-DMF0044-0207 | G5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (L-24 L-26) |
| WK-DMF0044-0208 | G5 | DMF0044_SalesReportExchangePopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP DMF0044_SalesReportExchangePopup | 판단불가(대상 단위 POPUP) | 2 (E06 ACT:DMF0044_Sales_Reports.btnExchang) |
| WK-DMF0044-0209 | G5 | DMF0044_SalesReport_TextboxPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP DMF0044_SalesReport_TextboxPopup | 판단불가(대상 단위 POPUP) | 2 (E07 ACT:DMF0044_Sales_Reports.btnTextbox) |
| WK-DMF0044-0210 | G5 | DMF0044_Sales_VersionCopyPopUp | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP DMF0044_Sales_VersionCopyPopUp | 판단불가(대상 단위 POPUP) | 1 (ACT:DMF0044_Sales_VersionPopUp.btnCopy_C) |
| WK-DMF0044-0211 | G5 | DMF0044_Sales_VersionPopUp | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP DMF0044_Sales_VersionPopUp | 판단불가(대상 단위 POPUP) | 1 (ACT:DMF0044_Sales_VersionPopUp.spdMain_C) |
| WK-DMF0044-0212 | G5 | DMF0044_United_VersionPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP DMF0044_United_VersionPopup | 판단불가(대상 단위 POPUP) | 3 (E05-1 ACT:DMF0044_Sales_Reports.btnSPVer) |
| WK-DMF0044-0213 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 13 (E08-2 ACT:DMF0044_Sales_Reports.spdMain_) |
| WK-DMF0044-0214 | G5 | SEND_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL SEND_YN | 있음(SHEET_COLUMNS) | 1 (UnitedVersionModal) |
| WK-DMF0044-0215 | G5 | btnExchangeRate | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnExchangeRate | 있음(FE 소스) | 1 (E02-1) |
| WK-DMF0044-0216 | G5 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnMeasure | 없음 | 2 (E02-1 E02-2) |
| WK-DMF0044-0217 | G5 | btnSPVer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnSPVer | 있음(FE 소스) | 2 (E02-1 E02-2) |
| WK-DMF0044-0218 | G5 | btnTextbox | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnTextbox | 있음(FE 소스) | 1 (E02-1) |
| WK-DMF0044-0219 | G5 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 2 (E02-2 ACT:DMF0044_Sales_Reports.btnSPVer) |
| WK-DMF0044-0220 | G5 | clbType / Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbType / Type | 있음(FE 소스) | 6 (E02-2 ACT:DMF0044_Sales_Reports.btnSPVer) |
| WK-DMF0044-0221 | G5 | txtSPVersion / Description / SPVersion | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtSPVersion / Description / SPVersion | 있음(FE 소스) | 3 (E02-2 V-7 V-8) |
| WK-DMF0044-0222 | G5 | usrDataType / Data Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND usrDataType / Data Type | 있음(FE 소스) | 1 (E02-2) |
| WK-DMF0044-0223 | G5 | usrYear / Year | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND usrYear / Year | 있음(FE 소스) | 1 (E02-2) |
| WK-DMF0044-0224 | H6 | CURRENCY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CURRENCY | 있음(SHEET_COLUMNS) | 1 (L-28) |
| WK-DMF0044-0225 | H6 | CURRENCY_UNITCURRENCY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CURRENCY_UNITCURRENCY | 있음(SHEET_COLUMNS) | 2 (L-26 L-29) |
| WK-DMF0044-0226 | H6 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (L-24 L-26) |
| WK-DMF0044-0227 | H6 | DMF0044_SalesReportExchangePopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP DMF0044_SalesReportExchangePopup | 판단불가(대상 단위 POPUP) | 2 (E06 ACT:DMF0044_Sales_Reports.btnExchang) |
| WK-DMF0044-0228 | H6 | DMF0044_SalesReport_TextboxPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP DMF0044_SalesReport_TextboxPopup | 판단불가(대상 단위 POPUP) | 2 (E07 ACT:DMF0044_Sales_Reports.btnTextbox) |
| WK-DMF0044-0229 | H6 | DMF0044_Sales_VersionCopyPopUp | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP DMF0044_Sales_VersionCopyPopUp | 판단불가(대상 단위 POPUP) | 1 (ACT:DMF0044_Sales_VersionPopUp.btnCopy_C) |
| WK-DMF0044-0230 | H6 | DMF0044_Sales_VersionPopUp | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP DMF0044_Sales_VersionPopUp | 판단불가(대상 단위 POPUP) | 1 (ACT:DMF0044_Sales_VersionPopUp.spdMain_C) |
| WK-DMF0044-0231 | H6 | DMF0044_United_VersionPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP DMF0044_United_VersionPopup | 판단불가(대상 단위 POPUP) | 3 (E05-1 ACT:DMF0044_Sales_Reports.btnSPVer) |
| WK-DMF0044-0232 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 13 (E08-2 ACT:DMF0044_Sales_Reports.spdMain_) |
| WK-DMF0044-0233 | H6 | SEND_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL SEND_YN | 있음(SHEET_COLUMNS) | 1 (UnitedVersionModal) |
| WK-DMF0044-0234 | H6 | btnExchangeRate | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnExchangeRate | 있음(FE 소스) | 1 (E02-1) |
| WK-DMF0044-0235 | H6 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnMeasure | 없음 | 2 (E02-1 E02-2) |
| WK-DMF0044-0236 | H6 | btnSPVer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnSPVer | 있음(FE 소스) | 2 (E02-1 E02-2) |
| WK-DMF0044-0237 | H6 | btnTextbox | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnTextbox | 있음(FE 소스) | 1 (E02-1) |

## W6 검증 실행 (308)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0044-0238 | J2 | DMF0044 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0044 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 285 (E01-2 E01-3 E02 E02-1 E02-2 E03 E03-1 E0) |
| WK-DMF0044-0239 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 5 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0240 | C1 | clbDivisions / Division / Divisions | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivisions / Division / Divisions · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0044_MDFVersionPopUp.InitControls) |
| WK-DMF0044-0241 | C1 | clbType / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbType / Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0044_Sales_Reports.InitControls:1) |
| WK-DMF0044-0242 | C1 | usrDataType / Data Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — usrDataType / Data Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:DMF0044_Sales_Reports.InitControls:1) |
| WK-DMF0044-0243 | C1 | usrYear / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — usrYear / Year · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReportExchangePopup.Yea) |
| WK-DMF0044-0244 | C2 | CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0245 | C2 | DEPARTMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 34 (E08-1 ACT:DMF0044_Sales_Reports.spdMain_) |
| WK-DMF0044-0246 | C2 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 54 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0247 | C2 | END_CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — END_CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 12 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0248 | C2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0249 | C2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0250 | C2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0251 | C2 | PRODUCT_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PRODUCT_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0252 | C3 | CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0253 | C3 | DEPARTMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 34 (E08-1 ACT:DMF0044_Sales_Reports.spdMain_) |
| WK-DMF0044-0254 | C3 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 54 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0255 | C3 | DESCRIPTION1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0256 | C3 | DESCRIPTION10 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION10 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0257 | C3 | DESCRIPTION11 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION11 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0258 | C3 | DESCRIPTION12 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION12 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0259 | C3 | DESCRIPTION13 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION13 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0260 | C3 | DESCRIPTION2 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION2 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0261 | C3 | DESCRIPTION3 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION3 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0262 | C3 | DESCRIPTION4 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION4 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0263 | C3 | DESCRIPTION5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0264 | C3 | DESCRIPTION6 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION6 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0265 | C3 | DESCRIPTION7 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION7 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0266 | C3 | DESCRIPTION8 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION8 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0267 | C3 | DESCRIPTION9 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DESCRIPTION9 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0268 | C3 | END_CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — END_CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 12 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0269 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:DMF0044_Sales_Reports.InsertRow:1027) |
| WK-DMF0044-0270 | C3 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:DMF0044_Sales_Reports.InsertRow:1024) |
| WK-DMF0044-0271 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:DMF0044_Sales_Reports.spdMain_CellDo) |
| WK-DMF0044-0272 | C3 | PRODUCT_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PRODUCT_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0273 | C3 | VERSION_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VERSION_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:DMF0044_Sales_VersionPopUp.SetItem A) |
| WK-DMF0044-0274 | C3 | YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:DMF0044_Sales_VersionPopUp.SetItem A) |
| WK-DMF0044-0275 | C6 | CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0276 | C6 | DEPARTMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 34 (E08-1 ACT:DMF0044_Sales_Reports.spdMain_) |
| WK-DMF0044-0277 | C6 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 54 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0278 | C6 | END_CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — END_CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 12 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0279 | C6 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0280 | C6 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0281 | C6 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0282 | C6 | PRODUCT_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PRODUCT_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0283 | G3 | DMF0044 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — DMF0044 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 8 (E02-2 COMMON:UC-01 COMMON:UC-02 COMMON:U) |
| WK-DMF0044-0284 | K-SA | DMF0044 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — DMF0044 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (E02-2) |
| WK-DMF0044-0285 | K4 | DMF0044 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0044 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 214 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-DMF0044-0286 | F1 | DMF0044 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0044 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 567 (E02-1 E03-2 E04 E04-1 E04-2 E05-5 E09-1 ) |
| WK-DMF0044-0287 | F3 | DMF0044 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — DMF0044 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 2 (REQ:CHAT-20260820-10 REQ:CHAT-20260820-1) |
| WK-DMF0044-0288 | F5 | DMF0044 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0044 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 22 (E02-1 E03-2 E05-5 E09-1 V-16 V-20 MSG003) |
| WK-DMF0044-0289 | F4 | DM0021_GET_DM_MST_VERSION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0021_GET_DM_MST_VERSION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 47 (ACT:DMF0044_MDFVersionPopUp.FindButton A) |
| WK-DMF0044-0290 | F4 | DMF0044_GET_COPY_VERSION_POPUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0044_GET_COPY_VERSION_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 31 (ACT:DMF0044_Sales_VersionCopyPopUp.FindB) |
| WK-DMF0044-0291 | F4 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 109 (ACT:DMF0044_Sales_VersionCopyPopUp.FindB) |
| WK-DMF0044-0292 | F4 | PKG_DMF0044 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (REQ:CHAT-20260820-5) |
| WK-DMF0044-0293 | F4 | PKG_DMF0044.P_DMF0044_GET_EXCHANGE_POPUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_GET_EXCHANGE_POPUP_SPREAD_TI · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 127 (ACT:DMF0044_SalesReportExchangePopup.Fin) |
| WK-DMF0044-0294 | F4 | PKG_DMF0044.P_DMF0044_GET_MEASURE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_GET_MEASURE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 2 (ACT:DMF0044_Sales_Reports.GetMeasure:106) |
| WK-DMF0044-0295 | F4 | PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 |  | 300 (ACT:DMF0044_Sales_Reports.FindButton ACT) |
| WK-DMF0044-0296 | F4 | PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 79 (ACT:DMF0044_Sales_VersionPopUp.FindButto) |
| WK-DMF0044-0297 | F4 | PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHAN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_PO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 127 (ACT:DMF0044_SalesReportExchangePopup.Fin) |
| WK-DMF0044-0298 | F4 | PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHAN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_PO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 127 (ACT:DMF0044_SalesReportExchangePopup.Fin) |
| WK-DMF0044-0299 | F4 | PKG_DMF0044.P_DMF0044_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 299 (ACT:DMF0044_Sales_Reports.FindButton ACT) |
| WK-DMF0044-0300 | F4 | PKG_DMF0044.P_DMF0044_GET_TEXTBOX | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_GET_TEXTBOX · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 69 (ACT:DMF0044_SalesReport_TextboxPopup.Fin) |
| WK-DMF0044-0301 | F4 | PKG_DMF0044.P_DMF0044_SAVE_BIZ_PLAN_VERS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_SAVE_BIZ_PLAN_VERSION_COPY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 51 (ACT:DMF0044_Sales_VersionCopyPopUp.SaveD) |
| WK-DMF0044-0302 | F4 | PKG_DMF0044.P_DMF0044_SAVE_DM_EXCHANGE_R | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 90 (ACT:DMF0044_SalesReportExchangePopup.Sav) |
| WK-DMF0044-0303 | F4 | PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_RE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 263 (ACT:DMF0044_Sales_Reports.SaveButton ACT) |
| WK-DMF0044-0304 | F4 | PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_RE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 263 (ACT:DMF0044_Sales_Reports.SaveButton ACT) |
| WK-DMF0044-0305 | F4 | PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_VE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 54 (ACT:DMF0044_Sales_VersionCopyPopUp.SaveD) |
| WK-DMF0044-0306 | F4 | PKG_DMF0044.P_DMF0044_SAVE_TEXTBOX | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0044.P_DMF0044_SAVE_TEXTBOX · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 54 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0307 | F4 | P_CREATED_BY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_CREATED_BY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0308 | F4 | P_DESCRIPTION1 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION1 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0309 | F4 | P_DESCRIPTION10 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION10 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0310 | F4 | P_DESCRIPTION11 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION11 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0311 | F4 | P_DESCRIPTION12 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION12 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0312 | F4 | P_DESCRIPTION13 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION13 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0313 | F4 | P_DESCRIPTION2 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION2 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0314 | F4 | P_DESCRIPTION3 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION3 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0315 | F4 | P_DESCRIPTION4 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION4 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0316 | F4 | P_DESCRIPTION5 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION5 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0317 | F4 | P_DESCRIPTION6 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION6 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0318 | F4 | P_DESCRIPTION7 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION7 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0319 | F4 | P_DESCRIPTION8 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION8 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0320 | F4 | P_DESCRIPTION9 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DESCRIPTION9 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0321 | F4 | P_VERSION_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_VERSION_NO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 70 (ACT:DMF0044_SalesReport_TextboxPopup.Fin) |
| WK-DMF0044-0322 | F4 | P_YYYYMM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_YYYYMM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 53 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0323 | F4 | SCM0001_GET_LOOKUP_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 6 (ACT:DMF0044_Sales_Reports.GetLookupData:) |
| WK-DMF0044-0324 | A5 | CURRENCY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CURRENCY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0325 | A5 | CURRENCY_UNITCURRENCY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CURRENCY_UNITCURRENCY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Di |  | 4 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0326 | A5 | DEPARTMENT_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0327 | A5 | DEPT_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0328 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (L-24 ACT:DMF0044_MDFVersionPopUp.InitSpr) |
| WK-DMF0044-0329 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:DMF0044_Sales_Reports.spdMain_CellDo) |
| WK-DMF0044-0330 | A5 | LAST_UPDATED_BY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0331 | A5 | LAST_UPDATE_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0332 | A5 | UNIT_CURRENCY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — UNIT_CURRENCY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0333 | A5 | VERSION_DESCRIPTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VERSION_DESCRIPTION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0334 | A5 | VERSION_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VERSION_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0335 | A5 | VERSION_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VERSION_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0336 | A5 | VER_CRE_SEQ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VER_CRE_SEQ · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0337 | A5 | YYYYMMDD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — YYYYMMDD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0338 | G4 | chkMV / MV | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkMV / MV · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0044_United_VersionPopup.chkMV_Ch) |
| WK-DMF0044-0339 | G4 | chkUpdate / 최신화 / Update | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkUpdate / 최신화 / Update · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0044_United_VersionPopup.InitCont) |
| WK-DMF0044-0340 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 28 (E02-2 1 — ACT:DMF0044_SalesReportExchang) |
| WK-DMF0044-0341 | G4 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivisions / Division / Divisions · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitControls) |
| WK-DMF0044-0342 | G4 | clbType / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbType / Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 38 (E02-2 2 ACT:DMF0044_Sales_Reports.InitCo) |
| WK-DMF0044-0343 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (ACT:DMF0044_MDFVersionPopUp.Form_Load AC) |
| WK-DMF0044-0344 | G4 | txtSPVersion / Description / SPVersion | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtSPVersion / Description / SPVersion · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (E02-2 5) |
| WK-DMF0044-0345 | G4 | txtType / sVersion_Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtType / sVersion_Type / Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0044_Sales_VersionCopyPopUp.InitC) |
| WK-DMF0044-0346 | G4 | usrDataType / Data Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — usrDataType / Data Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (E02-2 4 ACT:DMF0044_Sales_Reports.InitCo) |
| WK-DMF0044-0347 | G4 | usrYear / Year | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — usrYear / Year · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (E02-2 3 ACT:DMF0044_SalesReportExchangeP) |
| WK-DMF0044-0348 | H2 | CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0349 | H2 | CURRENCY_UNITCURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CURRENCY_UNITCURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0350 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (L-24 ACT:DMF0044_MDFVersionPopUp.InitSpr) |
| WK-DMF0044-0351 | H2 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0352 | H2 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0353 | H2 | UNIT_CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — UNIT_CURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0354 | H2 | VERSION_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VERSION_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0355 | H2 | VERSION_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VERSION_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0356 | H2 | VERSION_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VERSION_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0357 | H2 | VER_CRE_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VER_CRE_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0358 | H2 | YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0359 | H4 | DMF0044 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0044 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 20 (ACT:DMF0044_MDFVersionPopUp.spdMain_TopC) |
| WK-DMF0044-0360 | H5 | CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CURRENCY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0361 | H5 | CURRENCY_UNITCURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CURRENCY_UNITCURRENCY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0362 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (L-24 ACT:DMF0044_MDFVersionPopUp.InitSpr) |
| WK-DMF0044-0363 | H5 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LAST_UPDATED_BY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0364 | H5 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0365 | H5 | UNIT_CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — UNIT_CURRENCY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0366 | H5 | VERSION_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VERSION_DESCRIPTION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0367 | H5 | VERSION_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VERSION_NO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0368 | H5 | VERSION_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VERSION_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0369 | H5 | VER_CRE_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VER_CRE_SEQ · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0370 | H5 | YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — YYYYMMDD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0371 | H5 | clbDivision / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbDivision / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 8 (ACT:DMF0044_Sales_Reports.InitSpread ACT) |
| WK-DMF0044-0372 | H5 | usrYear / Year | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — usrYear / Year · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 7 (V-13 ACT:DMF0044_SalesReportExchangePopu) |
| WK-DMF0044-0373 | I1 | DMF0044 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0044 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 90 (E05-5 E11 V-17 V-5 V-6 COMMON:UC-02 REQ:) |
| WK-DMF0044-0374 | SC1 | DMF0044 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — DMF0044 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 14 (E01-2 E01-3 E02-2 A-14 COMMON:UC-06 1 2 ) |
| WK-DMF0044-0375 | D1 | APPLICATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — APPLICATION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (L-16 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0376 | D1 | BIZ_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — BIZ_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (L-17 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0377 | D1 | BIZ_TYPE_NAME40 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — BIZ_TYPE_NAME40 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (L-18 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0378 | D1 | CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (L-28 ACT:DMF0044_SalesReportExchangePopu) |
| WK-DMF0044-0379 | D1 | CURRENCY_UNITCURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CURRENCY_UNITCURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (L-26 L-29 ACT:DMF0044_MDFVersionPopUp.Ed) |
| WK-DMF0044-0380 | D1 | CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (M-7) |
| WK-DMF0044-0381 | D1 | CUTOFF_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CUTOFF_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (L-12 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0382 | D1 | DEPARTMENT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DEPARTMENT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (L-10 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0383 | D1 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (M-7) |
| WK-DMF0044-0384 | D1 | DEPT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DEPT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (L-11 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0385 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 8 (L-24 L-26 ACT:DMF0044_SalesReportExchang) |
| WK-DMF0044-0386 | D1 | DMS_CUSTOMER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DMS_CUSTOMER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (L-20 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0387 | D1 | DMS_SALES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DMS_SALES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (L-19 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0388 | D1 | EDIT_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — EDIT_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 16 (A-3 ACT:DMF0044_Sales_Reports.EditButton) |
| WK-DMF0044-0389 | D1 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 16 (D-2 L-01 L-02 L-04 L-06 L-21 M-4 ACT:DMF) |
| WK-DMF0044-0390 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (L-13 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0391 | D1 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (L-15 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0392 | D1 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (L-14 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0393 | D3 | APPLICATION | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — APPLICATION · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (L-16 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0394 | D3 | BIZ_TYPE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — BIZ_TYPE_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (L-17 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0395 | D3 | BIZ_TYPE_NAME40 | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — BIZ_TYPE_NAME40 · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (L-18 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0396 | D3 | CURRENCY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CURRENCY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (L-28 ACT:DMF0044_SalesReportExchangePopu) |
| WK-DMF0044-0397 | D3 | CURRENCY_UNITCURRENCY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CURRENCY_UNITCURRENCY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (L-26 L-29 ACT:DMF0044_MDFVersionPopUp.Ed) |
| WK-DMF0044-0398 | D3 | CUST_REPORT | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CUST_REPORT · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (M-7) |
| WK-DMF0044-0399 | D3 | CUTOFF_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CUTOFF_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (L-12 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0400 | D3 | DEPARTMENT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DEPARTMENT_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (L-10 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0401 | D3 | DEPT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DEPT_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (M-7) |
| WK-DMF0044-0402 | D3 | DEPT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DEPT_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (L-11 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0403 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 8 (L-24 L-26 ACT:DMF0044_SalesReportExchang) |
| WK-DMF0044-0404 | D3 | DMS_CUSTOMER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DMS_CUSTOMER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (L-20 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0405 | D3 | DMS_SALES | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DMS_SALES · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (L-19 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0406 | D3 | EDIT_FLAG | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — EDIT_FLAG · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 16 (A-3 ACT:DMF0044_Sales_Reports.EditButton) |
| WK-DMF0044-0407 | D3 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 16 (D-2 L-01 L-02 L-04 L-06 L-21 M-4 ACT:DMF) |
| WK-DMF0044-0408 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (L-13 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0409 | D3 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (L-15 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0410 | D3 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (L-14 ACT:DMF0044_Sales_Reports.InsertRow) |
| WK-DMF0044-0411 | D4 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (L-21 M-4) |
| WK-DMF0044-0412 | D5 | CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0413 | D5 | CURRENCY_UNITCURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CURRENCY_UNITCURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0414 | D5 | CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0415 | D5 | DEPARTMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DEPARTMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0416 | D5 | DEPT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DEPT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 9 (ACT:DMF0044_Sales_Reports.InsertRow:991:) |
| WK-DMF0044-0417 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0418 | D5 | END_CUST_REPORT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — END_CUST_REPORT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0419 | D5 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0420 | D5 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0421 | D5 | PRODUCT_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PRODUCT_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0422 | D5 | UNIT_CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — UNIT_CURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0423 | D5 | VERSION_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VERSION_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0424 | D5 | VERSION_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VERSION_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0425 | D5 | VERSION_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VERSION_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0426 | D5 | VER_CRE_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VER_CRE_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0427 | D5 | YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0428 | D6 | DMF0044 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0044 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 16 (E02-1 E03-1 E09-1 M-4 COMMON:UC-01 COMMO) |
| WK-DMF0044-0429 | E4 | DESCRIPTION1 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION1 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0430 | E4 | DESCRIPTION10 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION10 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0431 | E4 | DESCRIPTION11 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION11 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0432 | E4 | DESCRIPTION12 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION12 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0433 | E4 | DESCRIPTION13 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION13 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0434 | E4 | DESCRIPTION2 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION2 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0435 | E4 | DESCRIPTION3 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION3 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0436 | E4 | DESCRIPTION4 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION4 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0437 | E4 | DESCRIPTION5 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION5 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0438 | E4 | DESCRIPTION6 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION6 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0439 | E4 | DESCRIPTION7 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION7 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0440 | E4 | DESCRIPTION8 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION8 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0441 | E4 | DESCRIPTION9 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DESCRIPTION9 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0442 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (MSG00002 MSG00004 ACT:DMF0044_SalesRepor) |
| WK-DMF0044-0443 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 13 (MSG00004 ACT:DMF0044_SalesReportExchange) |
| WK-DMF0044-0444 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00006 ACT:DMF0044_SalesReport_Textbox) |
| WK-DMF0044-0445 | E4 | MSG00016 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00016 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0044_United_VersionPopup.btnVerDe) |
| WK-DMF0044-0446 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00096 ACT:DMF0044_SalesReportExchange) |
| WK-DMF0044-0447 | E4 | MSG00142 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00142 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00142 ACT:DMF0044_Sales_Reports.btnEx) |
| WK-DMF0044-0448 | E4 | MSG00143 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00143 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0044_MDFVersionPopUp.SaveData:345) |
| WK-DMF0044-0449 | E4 | MSG00151 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00151 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0044_Sales_VersionPopUp.SaveData:) |
| WK-DMF0044-0450 | E4 | MSG00156 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00156 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (ACT:DMF0044_Sales_VersionCopyPopUp.SaveD) |
| WK-DMF0044-0451 | E4 | MSG00195 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00195 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0044_United_VersionPopup.btnTranC) |
| WK-DMF0044-0452 | E4 | MSG00279 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00279 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 11 (MSG00279/280/156/143/151 ACT:DMF0044_Sal) |
| WK-DMF0044-0453 | E4 | MSG00280 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00280 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0044_Sales_VersionCopyPopUp.btnBu) |
| WK-DMF0044-0454 | E4 | MSG00281 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00281 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (MSG00281 ACT:DMF0044_Sales_Reports.SaveD) |
| WK-DMF0044-0455 | E4 | MSG00283 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00283 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (V-5 MSG00283 ACT:DMF0044_Sales_Reports.F) |
| WK-DMF0044-0456 | E4 | MSG00314 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00314 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (V-17 MSG00314/00016/00195 ACT:DMF0044_Un) |
| WK-DMF0044-0457 | E4 | MSG00318 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00318 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00318/319/320 ACT:DMF0044_United_Vers) |
| WK-DMF0044-0458 | E4 | MSG00319 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00319 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0044_United_VersionPopup.btnTranC) |
| WK-DMF0044-0459 | E4 | MSG00320 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00320 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0044_United_VersionPopup.btnVerDe) |
| WK-DMF0044-0460 | E4 | MSG00321 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00321 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00321 ACT:DMF0044_Sales_Reports.EditB) |
| WK-DMF0044-0461 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (REQ:CHAT-20260820-11 MSG00002) |
| WK-DMF0044-0462 | E4 | MSG00618 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00618 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00006) |
| WK-DMF0044-0463 | E4 | MSG00680 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00680 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00142) |
| WK-DMF0044-0464 | E4 | MSG00681 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00681 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00321) |
| WK-DMF0044-0465 | E4 | MSG00682 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00682 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (UnitedVersionModal MSG00314/00016/00195) |
| WK-DMF0044-0466 | E4 | MSG00685 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00685 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (UnitedVersionModal MSG00318/319/320) |
| WK-DMF0044-0467 | E4 | MSG00688 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00688 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (E05-5 V-6 MSG00281) |
| WK-DMF0044-0468 | E4 | SEND_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SEND_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (UnitedVersionModal MSG00318/319/320) |
| WK-DMF0044-0469 | E4 | VERSION_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — VERSION_NO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:DMF0044_Sales_VersionPopUp.SetItem A) |
| WK-DMF0044-0470 | E4 | YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:DMF0044_Sales_VersionPopUp.SetItem A) |
| WK-DMF0044-0471 | E4 | chkResult / Result | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkResult / Result · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V-17 ACT:DMF0044_United_VersionPopup.btn) |
| WK-DMF0044-0472 | E4 | txtSPVersion / Description / SPVersion | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtSPVersion / Description / SPVersion · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지· |  | 8 (V-5 V-6 V-7 V-8 ACT:DMF0044_Sales_Report) |
| WK-DMF0044-0473 | A10 | DMF0044 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0044 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 283 (ACT:DMF0044_MDFVersionPopUp.DefineProper) |
| WK-DMF0044-0474 | A6 | DM0021_GET_DM_MST_VERSION | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DM0021_GET_DM_MST_VERSION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@ |  | 23 (ACT:DMF0044_MDFVersionPopUp.FindButton A) |
| WK-DMF0044-0475 | A6 | DMF0044_GET_COPY_VERSION_POPUP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DMF0044_GET_COPY_VERSION_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.s |  | 31 (ACT:DMF0044_Sales_VersionCopyPopUp.FindB) |
| WK-DMF0044-0476 | A6 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 74 (ACT:DMF0044_Sales_VersionCopyPopUp.FindB) |
| WK-DMF0044-0477 | A6 | PKG_DMF0044.P_DMF0044_GET_EXCHANGE_POPUP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0044.P_DMF0044_GET_EXCHANGE_POPUP_SPREAD_TI · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 36 (ACT:DMF0044_SalesReportExchangePopup.Fin) |
| WK-DMF0044-0478 | A6 | PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로  |  | 38 (ACT:DMF0044_Sales_Reports.FindButton ACT) |
| WK-DMF0044-0479 | A6 | PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 50 (ACT:DMF0044_Sales_VersionPopUp.FindButto) |
| WK-DMF0044-0480 | A6 | PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHAN | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_PO · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 38 (ACT:DMF0044_SalesReportExchangePopup.Fin) |
| WK-DMF0044-0481 | A6 | PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHAN | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_PO · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 38 (ACT:DMF0044_SalesReportExchangePopup.Fin) |
| WK-DMF0044-0482 | A6 | PKG_DMF0044.P_DMF0044_GET_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0044.P_DMF0044_GET_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 35 (ACT:DMF0044_Sales_Reports.FindButton ACT) |
| WK-DMF0044-0483 | A6 | PKG_DMF0044.P_DMF0044_GET_TEXTBOX | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0044.P_DMF0044_GET_TEXTBOX · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trac |  | 18 (ACT:DMF0044_SalesReport_TextboxPopup.Fin) |
| WK-DMF0044-0484 | A6 | P_VERSION_NO | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_VERSION_NO · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 17 (ACT:DMF0044_SalesReport_TextboxPopup.Fin) |
| WK-DMF0044-0485 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 13 (E02-2 1 — ACT:DMF0044_SalesReportExchang) |
| WK-DMF0044-0486 | G1 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivisions / Division / Divisions · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0044_MDFVersionPopUp.FindData ACT) |
| WK-DMF0044-0487 | G1 | clbType / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbType / Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (E02-2 2 ACT:DMF0044_Sales_Reports.FindDa) |
| WK-DMF0044-0488 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 12 (ACT:DMF0044_MDFVersionPopUp.FindData ACT) |
| WK-DMF0044-0489 | G1 | txtDes / Des | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtDes / Des · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:DMF0044_MDFVersionPopUp.FindData ACT) |
| WK-DMF0044-0490 | G1 | txtDesc / Description / Desc | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtDesc / Description / Desc · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0044_United_VersionPopup.FindData) |
| WK-DMF0044-0491 | G1 | txtSPVersion / Description / SPVersion | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtSPVersion / Description / SPVersion · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 8 (E02-2 V-5 5 ACT:DMF0044_Sales_Reports.Fi) |
| WK-DMF0044-0492 | G1 | txtType / sVersion_Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtType / sVersion_Type / Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:DMF0044_MDFVersionPopUp.FindData ACT) |
| WK-DMF0044-0493 | G1 | usrDataType / Data Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — usrDataType / Data Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (E02-2 4 ACT:DMF0044_Sales_Reports.FindDa) |
| WK-DMF0044-0494 | G1 | usrYear / Year | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — usrYear / Year · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 8 (E02-2 V-13 3 ACT:DMF0044_SalesReportExch) |
| WK-DMF0044-0495 | G6 | chkUpdate / 최신화 / Update | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkUpdate / 최신화 / Update · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0044_United_VersionPopup.InitCont) |
| WK-DMF0044-0496 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 28 (E02-2 1 — ACT:DMF0044_SalesReportExchang) |
| WK-DMF0044-0497 | G6 | clbDivisions / Division / Divisions | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivisions / Division / Divisions · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0044_MDFVersionPopUp.InitControls) |
| WK-DMF0044-0498 | G6 | clbType / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbType / Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 10 (E02-2 2 ACT:DMF0044_Sales_Reports.InitCo) |
| WK-DMF0044-0499 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 8 (ACT:DMF0044_MDFVersionPopUp.Form_Load AC) |
| WK-DMF0044-0500 | G6 | txtSPVersion / Description / SPVersion | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtSPVersion / Description / SPVersion · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (E02-2 5) |
| WK-DMF0044-0501 | G6 | txtType / sVersion_Type / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtType / sVersion_Type / Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0044_Sales_VersionCopyPopUp.InitC) |
| WK-DMF0044-0502 | G6 | usrDataType / Data Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — usrDataType / Data Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (E02-2 4 ACT:DMF0044_Sales_Reports.InitCo) |
| WK-DMF0044-0503 | G6 | usrYear / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — usrYear / Year · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 8 (E02-2 3 ACT:DMF0044_SalesReportExchangeP) |
| WK-DMF0044-0504 | X-REOPEN | DMF0044 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0044 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 54 (ACT:DMF0044_MDFVersionPopUp.Dispose ACT:) |
| WK-DMF0044-0505 | H6 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (E02-2 ACT:DMF0044_Sales_Reports.btnSPVer) |
| WK-DMF0044-0506 | H6 | clbType / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbType / Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 6 (E02-2 ACT:DMF0044_Sales_Reports.btnSPVer) |
| WK-DMF0044-0507 | H6 | txtSPVersion / Description / SPVersion | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtSPVersion / Description / SPVersion · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 3 (E02-2 V-7 V-8) |
| WK-DMF0044-0508 | H6 | usrDataType / Data Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — usrDataType / Data Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (E02-2) |
| WK-DMF0044-0509 | H6 | usrYear / Year | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — usrYear / Year · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (E02-2) |
| WK-DMF0044-0510 | M3 | DMF0044_MDFVersionPopUp | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0044_MDFVersionPopUp · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 20 (ACT:DMF0044_MDFVersionPopUp..ctor ACT:DM) |
| WK-DMF0044-0511 | M3 | DMF0044_SalesReportExchangePopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0044_SalesReportExchangePopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 22 (ACT:DMF0044_SalesReportExchangePopup..ct) |
| WK-DMF0044-0512 | M3 | DMF0044_SalesReport_TextboxPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0044_SalesReport_TextboxPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 18 (ACT:DMF0044_SalesReport_TextboxPopup..ct) |
| WK-DMF0044-0513 | M3 | DMF0044_Sales_VersionCopyPopUp | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0044_Sales_VersionCopyPopUp · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 16 (ACT:DMF0044_Sales_VersionCopyPopUp..ctor) |
| WK-DMF0044-0514 | M3 | DMF0044_Sales_VersionPopUp | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0044_Sales_VersionPopUp · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 17 (ACT:DMF0044_Sales_VersionPopUp..ctor ACT) |
| WK-DMF0044-0515 | M3 | DMF0044_United_VersionPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0044_United_VersionPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 30 (ACT:DMF0044_United_VersionPopup..ctor AC) |
| WK-DMF0044-0516 | M3 | btnClose | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnClose · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0044_United_VersionPopup.btnClose) |
| WK-DMF0044-0517 | M3 | btnCopy | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnCopy · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0044_Sales_VersionPopUp.btnCopy_C) |
| WK-DMF0044-0518 | M3 | btnFind | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnFind · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0044_United_VersionPopup.btnFind_) |
| WK-DMF0044-0519 | M3 | btnOK | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnOK · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0044_United_VersionPopup.btnOK_Cl) |
| WK-DMF0044-0520 | M3 | btnTranCancel | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnTranCancel · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0044_United_VersionPopup.btnTranC) |
| WK-DMF0044-0521 | M3 | btnTransfer | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnTransfer · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 3 (ACT:DMF0044_Sales_VersionCopyPopUp.btnTr) |
| WK-DMF0044-0522 | M3 | btnVerCopy | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnVerCopy · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0044_United_VersionPopup.btnVerCo) |
| WK-DMF0044-0523 | M3 | btnVerCre | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnVerCre · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0044_United_VersionPopup.btnVerCr) |
| WK-DMF0044-0524 | M3 | btnVerDel | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnVerDel · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:DMF0044_United_VersionPopup.btnVerDe) |
| WK-DMF0044-0525 | M4 | CURRENCY | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CURRENCY · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (L-28) |
| WK-DMF0044-0526 | M4 | CURRENCY_UNITCURRENCY | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CURRENCY_UNITCURRENCY · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (L-26 L-29) |
| WK-DMF0044-0527 | M4 | DEPT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DEPT_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:DMF0044_Sales_Reports.spdMain_CellDo) |
| WK-DMF0044-0528 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (L-24 L-26 ACT:DMF0044_Sales_Reports.spdM) |
| WK-DMF0044-0529 | M4 | DMF0044_SalesReportExchangePopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0044_SalesReportExchangePopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (E06) |
| WK-DMF0044-0530 | M4 | DMF0044_SalesReport_TextboxPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0044_SalesReport_TextboxPopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (E07) |
| WK-DMF0044-0531 | M4 | DMF0044_Sales_VersionPopUp | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0044_Sales_VersionPopUp · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (ACT:DMF0044_Sales_VersionPopUp.spdMain_C) |
| WK-DMF0044-0532 | M4 | DMF0044_United_VersionPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0044_United_VersionPopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (E05-1 ACT:DMF0044_United_VersionPopup.sp) |
| WK-DMF0044-0533 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 13 (E08-2 ACT:DMF0044_Sales_Reports.spdMain_) |
| WK-DMF0044-0534 | M4 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0044_Sales_Reports.spdMain_CellDo) |
| WK-DMF0044-0535 | M4 | SEND_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SEND_YN · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (UnitedVersionModal) |
| WK-DMF0044-0536 | M4 | VERSION_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — VERSION_NO · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:DMF0044_United_VersionPopup.spdMain_) |
| WK-DMF0044-0537 | M4 | btnExchangeRate | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnExchangeRate · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (E02-1) |
| WK-DMF0044-0538 | M4 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (E02-1 E02-2) |
| WK-DMF0044-0539 | M4 | btnSPVer | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnSPVer · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (E02-1 E02-2) |
| WK-DMF0044-0540 | M4 | btnTextbox | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnTextbox · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (E02-1) |
| WK-DMF0044-0541 | M4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (E02-2) |
| WK-DMF0044-0542 | M4 | clbType / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — clbType / Type · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (E02-2 ACT:DMF0044_United_VersionPopup.sp) |
| WK-DMF0044-0543 | M4 | txtSPVersion / Description / SPVersion | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtSPVersion / Description / SPVersion · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (E02-2 V-7 V-8) |
| WK-DMF0044-0544 | M4 | usrDataType / Data Type | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — usrDataType / Data Type · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (E02-2) |
| WK-DMF0044-0545 | M4 | usrYear / Year | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — usrYear / Year · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (E02-2) |

## W7 기대값 확정 (526)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0044-0546 | C1 | D-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — D-4: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D-4) |
| WK-DMF0044-0547 | C1 | HANDLER:clbDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbDivision_SelectedIndexChanged: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbDivision_SelectedIndexChanged) |
| WK-DMF0044-0548 | C1 | HANDLER:clbType_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbType_SelectedIndexChanged: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbType_SelectedIndexChanged) |
| WK-DMF0044-0549 | C1 | V-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — V-10: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (V-10) |
| WK-DMF0044-0550 | C1 | V-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — V-11: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (V-11) |
| WK-DMF0044-0551 | C2 | DMF0044_Sales_Reports.clbDivision_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0044_Sales_Reports.clbDivision_SelectedIndexCha: 진입점 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_Reports.clbDivision_Se) |
| WK-DMF0044-0552 | C2 | DMF0044_Sales_Reports.clbType_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0044_Sales_Reports.clbType_SelectedIndexChanged: 진입점 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0044_Sales_Reports.clbType_Select) |
| WK-DMF0044-0553 | C2 | DMF0044_Sales_Reports.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — DMF0044_Sales_Reports.spdMain_Changed: 진입점 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0554 | C2 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — E08: 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0044-0555 | C2 | HANDLER:spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — HANDLER:spdMain_Changed: 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_Changed) |
| WK-DMF0044-0556 | C2 | M-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — M-5: 행 집계 — C2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (M-5) |
| WK-DMF0044-0557 | C3 | DMF0044_Sales_Reports.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0044_Sales_Reports.SetChangeControl: 진입점 집계 — C3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_Reports.SetChangeContr) |
| WK-DMF0044-0558 | C3 | DMF0044_Sales_Reports.SetRowSpanFucTwo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0044_Sales_Reports.SetRowSpanFucTwo: 진입점 집계 — C3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 15 (ACT:DMF0044_Sales_Reports.SetRowSpanFucT) |
| WK-DMF0044-0559 | C3 | DMF0044_Sales_Reports.clbDivision_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0044_Sales_Reports.clbDivision_SelectedIndexCha: 진입점 집계 — C3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_Reports.clbDivision_Se) |
| WK-DMF0044-0560 | C3 | DMF0044_Sales_Reports.clbType_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0044_Sales_Reports.clbType_SelectedIndexChanged: 진입점 집계 — C3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0044_Sales_Reports.clbType_Select) |
| WK-DMF0044-0561 | C3 | DMF0044_Sales_Reports.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — DMF0044_Sales_Reports.spdMain_Changed: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0562 | C3 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — E08: 행 집계 — C3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0044-0563 | C3 | HANDLER:spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — HANDLER:spdMain_Changed: 행 집계 — C3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_Changed) |
| WK-DMF0044-0564 | C3 | M-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — M-5: 행 집계 — C3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (M-5) |
| WK-DMF0044-0565 | C3 | REQ:CHAT-20260820-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — REQ:CHAT-20260820-10: 행 집계 — C3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-10) |
| WK-DMF0044-0566 | C3 | REQ:CHAT-20260820-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — REQ:CHAT-20260820-11: 행 집계 — C3 23요소: NOT_RUN:23 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-11) |
| WK-DMF0044-0567 | C6 | DMF0044_Sales_Reports.clbDivision_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0044_Sales_Reports.clbDivision_SelectedIndexCha: 진입점 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_Reports.clbDivision_Se) |
| WK-DMF0044-0568 | C6 | DMF0044_Sales_Reports.clbType_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0044_Sales_Reports.clbType_SelectedIndexChanged: 진입점 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0044_Sales_Reports.clbType_Select) |
| WK-DMF0044-0569 | C6 | DMF0044_Sales_Reports.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — DMF0044_Sales_Reports.spdMain_Changed: 진입점 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0570 | C6 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — E08: 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0044-0571 | C6 | HANDLER:spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — HANDLER:spdMain_Changed: 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_Changed) |
| WK-DMF0044-0572 | C6 | M-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — M-5: 행 집계 — C6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (M-5) |
| WK-DMF0044-0573 | B3 | **DM_LOOKUP_DIV** | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — **DM_LOOKUP_DIV**: 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (**DM_LOOKUP_DIV**) |
| WK-DMF0044-0574 | B3 | DMF0044_Sales_Reports.GetCalendarYYYY | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0044_Sales_Reports.GetCalendarYYYY: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0044_Sales_Reports.GetCalendarYYY) |
| WK-DMF0044-0575 | B3 | DMF0044_Sales_Reports.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0044_Sales_Reports.GetCellColor: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0044_Sales_Reports.GetCellColor:1) |
| WK-DMF0044-0576 | B3 | DMF0044_Sales_Reports.GetCellIndexBySpan | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0044_Sales_Reports.GetCellIndexBySpanRowCells: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_Reports.GetCellIndexBy) |
| WK-DMF0044-0577 | B3 | DMF0044_Sales_Reports.GetCellNumbersByRo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0044_Sales_Reports.GetCellNumbersByRow: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 14 (ACT:DMF0044_Sales_Reports.GetCellNumbers) |
| WK-DMF0044-0578 | B3 | DMF0044_Sales_Reports.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0044_Sales_Reports.GetLookupData: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0044_Sales_Reports.GetLookupData:) |
| WK-DMF0044-0579 | B3 | DMF0044_Sales_Reports.GetMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0044_Sales_Reports.GetMeasure: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0044_Sales_Reports.GetMeasure:105) |
| WK-DMF0044-0580 | B4 | **DM_LOOKUP_DIV** | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — **DM_LOOKUP_DIV**: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (**DM_LOOKUP_DIV**) |
| WK-DMF0044-0581 | B4 | DMF0044_Sales_Reports.GetCalendarYYYY | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0044_Sales_Reports.GetCalendarYYYY: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0044_Sales_Reports.GetCalendarYYY) |
| WK-DMF0044-0582 | B4 | DMF0044_Sales_Reports.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0044_Sales_Reports.GetCellColor: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0044_Sales_Reports.GetCellColor:1) |
| WK-DMF0044-0583 | B4 | DMF0044_Sales_Reports.GetCellIndexBySpan | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0044_Sales_Reports.GetCellIndexBySpanRowCells: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_Reports.GetCellIndexBy) |
| WK-DMF0044-0584 | B4 | DMF0044_Sales_Reports.GetCellNumbersByRo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0044_Sales_Reports.GetCellNumbersByRow: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 14 (ACT:DMF0044_Sales_Reports.GetCellNumbers) |
| WK-DMF0044-0585 | B4 | DMF0044_Sales_Reports.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0044_Sales_Reports.GetLookupData: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0044_Sales_Reports.GetLookupData:) |
| WK-DMF0044-0586 | B4 | DMF0044_Sales_Reports.GetMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0044_Sales_Reports.GetMeasure: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 3 (ACT:DMF0044_Sales_Reports.GetMeasure:105) |
| WK-DMF0044-0587 | DB-SYN | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — DB-SYN 35요소: NOPATH:20 · PASS:15 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0044-0588 | DB-SYN | CRUD:E04:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CRUD:E04:SAVE: 행 집계 — DB-SYN 35요소: NOPATH:20 · PASS:15 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E04:SAVE) |
| WK-DMF0044-0589 | DB-SYN | DMF0044_SalesReportExchangePopup.InitSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0044_SalesReportExchangePopup.InitSpread_X: 진입점 집계 — DB-SYN 35요소: NOPATH:20 · PASS:15 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0590 | DB-SYN | DMF0044_Sales_Reports.GetCalendarYYYY | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0044_Sales_Reports.GetCalendarYYYY: 진입점 집계 — DB-SYN 35요소: NOPATH:20 · PASS:15 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_Reports.GetCalendarYYY) |
| WK-DMF0044-0591 | DB-SYN | DMF0044_Sales_VersionCopyPopUp.btnTransf | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.btnTransfer_Click: 진입점 집계 — DB-SYN 35요소: NOPATH:20 · PASS:15 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_VersionCopyPopUp.btnTr) |
| WK-DMF0044-0592 | DB-SYN | DMF0044_Sales_VersionPopUp.btnTransfer_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0044_Sales_VersionPopUp.btnTransfer_Click: 진입점 집계 — DB-SYN 35요소: NOPATH:20 · PASS:15 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_VersionPopUp.btnTransf) |
| WK-DMF0044-0593 | DB-SYN | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — E02: 행 집계 — DB-SYN 35요소: NOPATH:20 · PASS:15 (미실행 요소가 남아 판정필요) |  | 1 (E02) |
| WK-DMF0044-0594 | DB-SYN | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — E04: 행 집계 — DB-SYN 35요소: NOPATH:20 · PASS:15 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0044-0595 | DB-SYN | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:FindData: 행 집계 — DB-SYN 35요소: NOPATH:20 · PASS:15 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0044-0596 | DB-SYN | HANDLER:SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:SaveData: 행 집계 — DB-SYN 35요소: NOPATH:20 · PASS:15 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SaveData) |
| WK-DMF0044-0597 | DB-SYN | L-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — L-09: 행 집계 — DB-SYN 35요소: NOPATH:20 · PASS:15 (미실행 요소가 남아 판정필요) |  | 1 (L-09) |
| WK-DMF0044-0598 | F4 | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — F4 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0044-0599 | F4 | CRUD:E04:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CRUD:E04:SAVE: 행 집계 — F4 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E04:SAVE) |
| WK-DMF0044-0600 | F4 | DMF0044_SalesReportExchangePopup.InitSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0044_SalesReportExchangePopup.InitSpread_X: 진입점 집계 — F4 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0601 | F4 | DMF0044_Sales_Reports.GetCalendarYYYY | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0044_Sales_Reports.GetCalendarYYYY: 진입점 집계 — F4 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_Reports.GetCalendarYYY) |
| WK-DMF0044-0602 | F4 | DMF0044_Sales_VersionCopyPopUp.btnTransf | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.btnTransfer_Click: 진입점 집계 — F4 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_VersionCopyPopUp.btnTr) |
| WK-DMF0044-0603 | F4 | DMF0044_Sales_VersionPopUp.btnTransfer_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0044_Sales_VersionPopUp.btnTransfer_Click: 진입점 집계 — F4 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_VersionPopUp.btnTransf) |
| WK-DMF0044-0604 | F4 | DMF0044_United_VersionPopup.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0044_United_VersionPopup.SaveButton: 진입점 집계 — F4 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0044_United_VersionPopup.SaveButt) |
| WK-DMF0044-0605 | F4 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — E02: 행 집계 — F4 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (E02) |
| WK-DMF0044-0606 | F4 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — E04: 행 집계 — F4 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0044-0607 | F4 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:FindData: 행 집계 — F4 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0044-0608 | F4 | HANDLER:SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:SaveData: 행 집계 — F4 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SaveData) |
| WK-DMF0044-0609 | F4 | L-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — L-09: 행 집계 — F4 35요소: NOT_RUN:35 (미실행 요소가 남아 판정필요) |  | 1 (L-09) |
| WK-DMF0044-0610 | A5 | DMF0044_Sales_Reports.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — DMF0044_Sales_Reports.CreateSpread: 진입점 집계 — A5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_Reports.CreateSpread:2) |
| WK-DMF0044-0611 | A5 | E01-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E01-4: 행 집계 — A5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (E01-4) |
| WK-DMF0044-0612 | A5 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E08: 행 집계 — A5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0044-0613 | A5 | E10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E10: 행 집계 — A5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (E10) |
| WK-DMF0044-0614 | A5 | H-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — H-1: 행 집계 — A5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (H-1) |
| WK-DMF0044-0615 | A5 | H-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — H-2: 행 집계 — A5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (H-2) |
| WK-DMF0044-0616 | A5 | H-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — H-3: 행 집계 — A5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (H-3) |
| WK-DMF0044-0617 | A5 | H-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — H-4: 행 집계 — A5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (H-4) |
| WK-DMF0044-0618 | A5 | REQ:CHAT-20260820-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — REQ:CHAT-20260820-13: 행 집계 — A5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-13) |
| WK-DMF0044-0619 | A5 | REQ:CHAT-20260820-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — REQ:CHAT-20260820-2: 행 집계 — A5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-2) |
| WK-DMF0044-0620 | A5 | REQ:CHAT-20260820-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — REQ:CHAT-20260820-7: 행 집계 — A5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-7) |
| WK-DMF0044-0621 | A5 | V-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — V-13: 행 집계 — A5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (V-13) |
| WK-DMF0044-0622 | G4 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 6: 행 집계 — G4 13요소: NOT_RUN:10 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-DMF0044-0623 | G4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 8: 행 집계 — G4 13요소: NOT_RUN:10 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0044-0624 | G4 | A-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — A-14: 행 집계 — G4 13요소: NOT_RUN:10 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (A-14) |
| WK-DMF0044-0625 | G4 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — E01-2: 행 집계 — G4 13요소: NOT_RUN:10 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (E01-2) |
| WK-DMF0044-0626 | G4 | E01-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — E01-3: 행 집계 — G4 13요소: NOT_RUN:10 · NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (E01-3) |
| WK-DMF0044-0627 | H2 | DMF0044_Sales_Reports.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0044_Sales_Reports.CreateSpread: 진입점 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_Reports.CreateSpread:2) |
| WK-DMF0044-0628 | H2 | DMF0044_Sales_Reports.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — DMF0044_Sales_Reports.GetCellColor: 진입점 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 5 (ACT:DMF0044_Sales_Reports.GetCellColor:1) |
| WK-DMF0044-0629 | H2 | E01-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E01-4: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (E01-4) |
| WK-DMF0044-0630 | H2 | E02-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E02-1: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (E02-1) |
| WK-DMF0044-0631 | H2 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E08: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0044-0632 | H2 | E10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E10: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (E10) |
| WK-DMF0044-0633 | H2 | H-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — H-1: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (H-1) |
| WK-DMF0044-0634 | H2 | H-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — H-2: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (H-2) |
| WK-DMF0044-0635 | H2 | H-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — H-3: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (H-3) |
| WK-DMF0044-0636 | H2 | H-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — H-4: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (H-4) |
| WK-DMF0044-0637 | H2 | REQ:CHAT-20260820-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — REQ:CHAT-20260820-13: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-13) |
| WK-DMF0044-0638 | H2 | REQ:CHAT-20260820-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — REQ:CHAT-20260820-2: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-2) |
| WK-DMF0044-0639 | H2 | REQ:CHAT-20260820-6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — REQ:CHAT-20260820-6: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-6) |
| WK-DMF0044-0640 | H2 | REQ:CHAT-20260820-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — REQ:CHAT-20260820-7: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-7) |
| WK-DMF0044-0641 | H2 | REQ:CHAT-20260820-8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — REQ:CHAT-20260820-8: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-8) |
| WK-DMF0044-0642 | H2 | REQ:CHAT-20260820-9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — REQ:CHAT-20260820-9: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-9) |
| WK-DMF0044-0643 | H2 | V-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — V-13: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (V-13) |
| WK-DMF0044-0644 | H2 | V-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — V-4: 행 집계 — H2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (V-4) |
| WK-DMF0044-0645 | H5 | DMF0044_Sales_Reports.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0044_Sales_Reports.CreateSpread: 진입점 집계 — H5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_Reports.CreateSpread:2) |
| WK-DMF0044-0646 | H5 | E01-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E01-4: 행 집계 — H5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (E01-4) |
| WK-DMF0044-0647 | H5 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E08: 행 집계 — H5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0044-0648 | H5 | E10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E10: 행 집계 — H5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (E10) |
| WK-DMF0044-0649 | H5 | H-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — H-1: 행 집계 — H5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (H-1) |
| WK-DMF0044-0650 | H5 | H-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — H-2: 행 집계 — H5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (H-2) |
| WK-DMF0044-0651 | H5 | H-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — H-3: 행 집계 — H5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (H-3) |
| WK-DMF0044-0652 | H5 | H-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — H-4: 행 집계 — H5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (H-4) |
| WK-DMF0044-0653 | H5 | REQ:CHAT-20260820-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — REQ:CHAT-20260820-13: 행 집계 — H5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-13) |
| WK-DMF0044-0654 | H5 | REQ:CHAT-20260820-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — REQ:CHAT-20260820-2: 행 집계 — H5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-2) |
| WK-DMF0044-0655 | H5 | REQ:CHAT-20260820-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — REQ:CHAT-20260820-7: 행 집계 — H5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-7) |
| WK-DMF0044-0656 | X-REASON | A-15 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A-15 팝업6 / 버튼 노출  AS-IS 는 NowGroupID∈{ADMIN,DM ADMIN} 그룹 게이트. TO-BE 환율 모달은 **행별 EDIT_YN**(ExchangeRateModal.tsx |  | 1 (A-15) |
| WK-DMF0044-0657 | X-REASON | A-16 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A-16 팝업6 / Edit 실행  AS-IS 는 NowGroupID∈{ADMIN,DM ADMIN} 그룹 게이트. TO-BE 환율 모달은 **행별 EDIT_YN**(ExchangeRateModal.t |  | 1 (A-16) |
| WK-DMF0044-0658 | X-REASON | A-17 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A-17 팝업6 / Save 실행  AS-IS 는 NowGroupID∈{ADMIN,DM ADMIN} 그룹 게이트. TO-BE 환율 모달은 **행별 EDIT_YN**(ExchangeRateModal.t |  | 1 (A-17) |
| WK-DMF0044-0659 | X-REASON | A-18 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A-18 팝업7 / 버튼 노출  동상 — Textbox 모달은 버튼 권한(hasButton('TEXTBOX')) + division 82 게이트로 노출을 통제. AS-IS 의 ADMIN 그룹 하드코딩 |  | 1 (A-18) |
| WK-DMF0044-0660 | X-REASON | A-19 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A-19 팝업7 / Edit 실행  동상 — Textbox 모달은 버튼 권한(hasButton('TEXTBOX')) + division 82 게이트로 노출을 통제. AS-IS 의 ADMIN 그룹 하드 |  | 1 (A-19) |
| WK-DMF0044-0661 | X-REASON | A-20 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A-20 팝업7 / Save 실행  동상 — Textbox 모달은 버튼 권한(hasButton('TEXTBOX')) + division 82 게이트로 노출을 통제. AS-IS 의 ADMIN 그룹 하드 |  | 1 (A-20) |
| WK-DMF0044-0662 | X-REASON | A-6 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A-6 팝업4 / 폼 권한체크  AS-IS `IsPopup=true` = WinForms BaseForm 권한체크 우회 배관. TO-BE 모달은 부모 화면 권한 컨텍스트를 그대로 쓰므로 우회 개념 자 |  | 1 (A-6) |
| WK-DMF0044-0663 | X-REASON | A-8 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A-8 팝업6 / 폼 권한체크  AS-IS `IsPopup=true` = WinForms BaseForm 권한체크 우회 배관. TO-BE 모달은 부모 화면 권한 컨텍스트를 그대로 쓰므로 우회 개념 자 |  | 1 (A-8) |
| WK-DMF0044-0664 | X-REASON | A-9 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A-9 팝업7 / 폼 권한체크  AS-IS `IsPopup=true` = WinForms BaseForm 권한체크 우회 배관. TO-BE 모달은 부모 화면 권한 컨텍스트를 그대로 쓰므로 우회 개념 자 |  | 1 (A-9) |
| WK-DMF0044-0665 | X-REASON | E00 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E00 §0 정본(Forms.UIL) vs Plan.UIL 변형 차이 요약  분석 배경 서술(정본 vs Plan.UIL 변형 차이) — 구현 대상 조문 아님 해당없음 |  | 1 (E00) |
| WK-DMF0044-0666 | X-REASON | E01-1 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E01-1 §1.1 생성자 (L122~L130)  WinForms 배관 — Wijmo/React 아키텍처에 대응 개념 없음(플랫폼 차이) (생성자/InitializeComponent) 해당없음 |  | 1 (E01-1) |
| WK-DMF0044-0667 | X-REASON | HANDLER:FindButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:FindButton AS-IS `DMF0044_Sales_Reports.cs:246` (라이브 3행) · **사문(빈 몸통)**  AS-IS 라이브 3행 = 사문(빈 몸통, 실제 동작은 |  | 1 (HANDLER:FindButton) |
| WK-DMF0044-0668 | X-REASON | HANDLER:InsertButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:InsertButton AS-IS `DMF0044_Sales_Reports.cs:251` (라이브 3행) · **사문(빈 몸통)**  AS-IS 라이브 3행 = 사문(빈 몸통, 실제 동 |  | 1 (HANDLER:InsertButton) |
| WK-DMF0044-0669 | X-REASON | HANDLER:SaveButton | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — HANDLER:SaveButton AS-IS `DMF0044_Sales_Reports.cs:374` (라이브 3행) · **사문(빈 몸통)**  AS-IS 라이브 3행 = 사문(빈 몸통, 실제 동작은 |  | 1 (HANDLER:SaveButton) |
| WK-DMF0044-0670 | X-REASON | MODAL:PopUp | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:PopUp AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무  md 본문의 일반 단어 매칭 — 실체 없음(추출 아티팩트) 해당없음 |  | 1 (MODAL:PopUp) |
| WK-DMF0044-0671 | X-REASON | MODAL:ShowDialog | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:ShowDialog AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무  WinForms 모달 표시 **메서드명** — 모달 자체가 아님(추출 아티팩트) 해당없음 |  | 1 (MODAL:ShowDialog) |
| WK-DMF0044-0672 | X-REASON | REQ:CHAT-20260820-21 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — REQ:CHAT-20260820-21 Cutoff 저장 FULL SCAN 제거 — 인덱스 추가 또는 힌트, 그리고 890행 WHILE 루프 set-based 전환  USER-DECISION 보류 —  |  | 1 (REQ:CHAT-20260820-21) |
| WK-DMF0044-0673 | X-REASON | REQ:CHAT-20260820-22 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — REQ:CHAT-20260820-22 동일 권한 INNER JOIN 안티패턴이 환율 팝업 밖 5곳 잔존 (COPY_VERSION_POPUP / SALES_VERSION_POPUP 2곳 / TEXTBO |  | 1 (REQ:CHAT-20260820-22) |
| WK-DMF0044-0674 | D1 | CRUD:E03:EDIT | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — CRUD:E03:EDIT: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E03:EDIT) |
| WK-DMF0044-0675 | D1 | D-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D-3: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D-3) |
| WK-DMF0044-0676 | D1 | DMF0044_Sales_Reports.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — DMF0044_Sales_Reports.EditButton: 진입점 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 18 (ACT:DMF0044_Sales_Reports.EditButton:272) |
| WK-DMF0044-0677 | D1 | E03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — E03: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (E03) |
| WK-DMF0044-0678 | D1 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — E08: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0044-0679 | D1 | HANDLER:EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — HANDLER:EditButton: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:EditButton) |
| WK-DMF0044-0680 | D1 | HANDLER:InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — HANDLER:InsertRow: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:InsertRow) |
| WK-DMF0044-0681 | D1 | L-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — L-03: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-03) |
| WK-DMF0044-0682 | D1 | L-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — L-05: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-05) |
| WK-DMF0044-0683 | D1 | L-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — L-07: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-07) |
| WK-DMF0044-0684 | D1 | L-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — L-08: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-08) |
| WK-DMF0044-0685 | D1 | L-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — L-09: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-09) |
| WK-DMF0044-0686 | D1 | L-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — L-27: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-27) |
| WK-DMF0044-0687 | D1 | L-30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — L-30: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-30) |
| WK-DMF0044-0688 | D1 | MSG00142 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — MSG00142: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (MSG00142) |
| WK-DMF0044-0689 | D1 | MSG00321 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — MSG00321: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (MSG00321) |
| WK-DMF0044-0690 | D1 | REQ:CHAT-20260820-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — REQ:CHAT-20260820-13: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-13) |
| WK-DMF0044-0691 | D1 | V-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — V-3: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (V-3) |
| WK-DMF0044-0692 | D3 | CRUD:E03:EDIT | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — CRUD:E03:EDIT: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E03:EDIT) |
| WK-DMF0044-0693 | D3 | D-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D-3: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D-3) |
| WK-DMF0044-0694 | D3 | DMF0044_Sales_Reports.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — DMF0044_Sales_Reports.EditButton: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 18 (ACT:DMF0044_Sales_Reports.EditButton:272) |
| WK-DMF0044-0695 | D3 | E02-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — E02-1: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (E02-1) |
| WK-DMF0044-0696 | D3 | E03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — E03: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (E03) |
| WK-DMF0044-0697 | D3 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — E08: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (E08) |
| WK-DMF0044-0698 | D3 | HANDLER:EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — HANDLER:EditButton: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:EditButton) |
| WK-DMF0044-0699 | D3 | HANDLER:InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — HANDLER:InsertRow: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:InsertRow) |
| WK-DMF0044-0700 | D3 | L-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — L-03: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-03) |
| WK-DMF0044-0701 | D3 | L-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — L-05: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-05) |
| WK-DMF0044-0702 | D3 | L-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — L-07: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-07) |
| WK-DMF0044-0703 | D3 | L-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — L-08: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-08) |
| WK-DMF0044-0704 | D3 | L-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — L-09: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-09) |
| WK-DMF0044-0705 | D3 | L-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — L-27: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-27) |
| WK-DMF0044-0706 | D3 | L-30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — L-30: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (L-30) |
| WK-DMF0044-0707 | D3 | MSG00142 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — MSG00142: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (MSG00142) |
| WK-DMF0044-0708 | D3 | MSG00321 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — MSG00321: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (MSG00321) |
| WK-DMF0044-0709 | D3 | REQ:CHAT-20260820-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — REQ:CHAT-20260820-13: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-13) |
| WK-DMF0044-0710 | D3 | REQ:CHAT-20260820-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — REQ:CHAT-20260820-7: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-7) |
| WK-DMF0044-0711 | D3 | REQ:CHAT-20260820-8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — REQ:CHAT-20260820-8: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-8) |
| WK-DMF0044-0712 | D3 | REQ:CHAT-20260820-9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — REQ:CHAT-20260820-9: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-9) |
| WK-DMF0044-0713 | D3 | V-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — V-3: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (V-3) |
| WK-DMF0044-0714 | D4 | E01-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — E01-3: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E01-3) |
| WK-DMF0044-0715 | D4 | E02-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — E02-1: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E02-1) |
| WK-DMF0044-0716 | D4 | E03-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — E03-1: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E03-1) |
| WK-DMF0044-0717 | D4 | E09-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — E09-1: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E09-1) |
| WK-DMF0044-0718 | D4 | HANDLER:InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — HANDLER:InsertRow: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:InsertRow) |
| WK-DMF0044-0719 | D4 | REQ:CHAT-20260820-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — REQ:CHAT-20260820-11: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-11) |
| WK-DMF0044-0720 | D5 | DMF0044_Sales_Reports.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — DMF0044_Sales_Reports.CreateSpread: 진입점 집계 — D5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_Reports.CreateSpread:2) |
| WK-DMF0044-0721 | E2 | ① | 사람 판정 / AS-IS 원문 확인 → 재판정 | E2 기대값 확정 — ①: 행 집계 — E2 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (①) |
| WK-DMF0044-0722 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (1) |
| WK-DMF0044-0723 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (2) |
| WK-DMF0044-0724 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (3) |
| WK-DMF0044-0725 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (4) |
| WK-DMF0044-0726 | A1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 5: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (5) |
| WK-DMF0044-0727 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (6) |
| WK-DMF0044-0728 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (7) |
| WK-DMF0044-0729 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (8) |
| WK-DMF0044-0730 | A1 | A-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-14: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (A-14) |
| WK-DMF0044-0731 | A1 | A-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A-2: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (A-2) |
| WK-DMF0044-0732 | A1 | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0044-0733 | A1 | DM0021_GET_DM_MST_VERSION | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DM0021_GET_DM_MST_VERSION: 골든 비교 케이스 없음(DM0021_GET_DM_MST_VERSION — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가  |  | 23 (ACT:DMF0044_MDFVersionPopUp.FindButton A) |
| WK-DMF0044-0734 | A1 | DMF0044_GET_COPY_VERSION_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0044_GET_COPY_VERSION_POPUP: 골든 비교 케이스 없음(DMF0044_GET_COPY_VERSION_POPUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미 |  | 31 (ACT:DMF0044_Sales_VersionCopyPopUp.FindB) |
| WK-DMF0044-0735 | A1 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01-2: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (E01-2) |
| WK-DMF0044-0736 | A1 | E01-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01-3: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (E01-3) |
| WK-DMF0044-0737 | A1 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E02: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (E02) |
| WK-DMF0044-0738 | A1 | E02-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E02-2: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (E02-2) |
| WK-DMF0044-0739 | A1 | E05-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E05-5: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (E05-5) |
| WK-DMF0044-0740 | A1 | E09-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E09-1: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (E09-1) |
| WK-DMF0044-0741 | A1 | ExchangeRateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ExchangeRateModal: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (ExchangeRateModal) |
| WK-DMF0044-0742 | A1 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindData: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (HANDLER:FindData) |
| WK-DMF0044-0743 | A1 | L-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L-09: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (L-09) |
| WK-DMF0044-0744 | A1 | L-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L-24: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (L-24) |
| WK-DMF0044-0745 | A1 | MSG00283 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MSG00283: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (MSG00283) |
| WK-DMF0044-0746 | A1 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE — 팝업·보조 SP 는 |  | 74 (ACT:DMF0044_Sales_VersionCopyPopUp.FindB) |
| WK-DMF0044-0747 | A1 | PKG_DMF0044 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0044: 골든 비교 케이스 없음(PKG_DMF0044 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (REQ:CHAT-20260820-12) |
| WK-DMF0044-0748 | A1 | PKG_DMF0044.P_DMF0044_GET_EXCHANGE_POPUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0044.P_DMF0044_GET_EXCHANGE_POPUP_SPREAD_TI: 골든 비교 케이스 없음(PKG_DMF0044.P_DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE |  | 36 (ACT:DMF0044_SalesReportExchangePopup.Fin) |
| WK-DMF0044-0749 | A1 | PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA: 골든 비교 케이스 없음(PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA — 팝업·보조 SP 는 g |  | 38 (ACT:DMF0044_Sales_Reports.FindButton ACT) |
| WK-DMF0044-0750 | A1 | PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_POPUP: 골든 비교 케이스 없음(PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_POPUP — 팝업·보조 SP 는 |  | 50 (ACT:DMF0044_Sales_VersionPopUp.FindButto) |
| WK-DMF0044-0751 | A1 | PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHAN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_PO: 골든 비교 케이스 없음(PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP |  | 38 (ACT:DMF0044_SalesReportExchangePopup.Fin) |
| WK-DMF0044-0752 | A1 | PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHAN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_PO: 골든 비교 케이스 없음(PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP |  | 38 (ACT:DMF0044_SalesReportExchangePopup.Fin) |
| WK-DMF0044-0753 | A1 | PKG_DMF0044.P_DMF0044_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0044.P_DMF0044_GET_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0044.P_DMF0044_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases. |  | 35 (ACT:DMF0044_Sales_Reports.FindButton ACT) |
| WK-DMF0044-0754 | A1 | PKG_DMF0044.P_DMF0044_GET_TEXTBOX | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0044.P_DMF0044_GET_TEXTBOX: 골든 비교 케이스 없음(PKG_DMF0044.P_DMF0044_GET_TEXTBOX — 팝업·보조 SP 는 golden_cases.csv 에 FE 실 |  | 18 (ACT:DMF0044_SalesReport_TextboxPopup.Fin) |
| WK-DMF0044-0755 | A1 | P_VERSION_NO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_VERSION_NO: 골든 비교 케이스 없음(P_VERSION_NO — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 17 (ACT:DMF0044_SalesReport_TextboxPopup.Fin) |
| WK-DMF0044-0756 | A1 | REQ:CHAT-20260820-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:CHAT-20260820-13: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (REQ:CHAT-20260820-13) |
| WK-DMF0044-0757 | A1 | REQ:CHAT-20260820-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — REQ:CHAT-20260820-2: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (REQ:CHAT-20260820-2) |
| WK-DMF0044-0758 | A1 | UnitedVersionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — UnitedVersionModal: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (UnitedVersionModal) |
| WK-DMF0044-0759 | A1 | V-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — V-1: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (V-1) |
| WK-DMF0044-0760 | A1 | V-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — V-13: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (V-13) |
| WK-DMF0044-0761 | A1 | V-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — V-5: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (V-5) |
| WK-DMF0044-0762 | A1 | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — —: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (—) |
| WK-DMF0044-0763 | A1 | ④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ④: 행 집계 — A1 12요소: REVIEW:12 |  | 1 (④) |
| WK-DMF0044-0764 | A6 | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — A6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0044-0765 | A6 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — E02: 행 집계 — A6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (E02) |
| WK-DMF0044-0766 | A6 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — HANDLER:FindData: 행 집계 — A6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0044-0767 | A6 | L-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — L-09: 행 집계 — A6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (L-09) |
| WK-DMF0044-0768 | G1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 6: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-DMF0044-0769 | G1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 7: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-DMF0044-0770 | G1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 8: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0044-0771 | G1 | A-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — A-14: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (A-14) |
| WK-DMF0044-0772 | G1 | A-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — A-2: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (A-2) |
| WK-DMF0044-0773 | G1 | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E02:SEARCH) |
| WK-DMF0044-0774 | G1 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E01-2: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (E01-2) |
| WK-DMF0044-0775 | G1 | E01-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E01-3: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (E01-3) |
| WK-DMF0044-0776 | G1 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E02: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (E02) |
| WK-DMF0044-0777 | G1 | E05-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E05-5: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (E05-5) |
| WK-DMF0044-0778 | G1 | E09-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E09-1: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (E09-1) |
| WK-DMF0044-0779 | G1 | ExchangeRateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ExchangeRateModal: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (ExchangeRateModal) |
| WK-DMF0044-0780 | G1 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — HANDLER:FindData: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0044-0781 | G1 | L-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — L-09: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (L-09) |
| WK-DMF0044-0782 | G1 | L-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — L-24: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (L-24) |
| WK-DMF0044-0783 | G1 | MSG00283 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00283: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (MSG00283) |
| WK-DMF0044-0784 | G1 | REQ:CHAT-20260820-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — REQ:CHAT-20260820-12: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-12) |
| WK-DMF0044-0785 | G1 | REQ:CHAT-20260820-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — REQ:CHAT-20260820-13: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-13) |
| WK-DMF0044-0786 | G1 | REQ:CHAT-20260820-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — REQ:CHAT-20260820-2: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-2) |
| WK-DMF0044-0787 | G1 | UnitedVersionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — UnitedVersionModal: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (UnitedVersionModal) |
| WK-DMF0044-0788 | G1 | V-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — V-1: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (V-1) |
| WK-DMF0044-0789 | G1 | ④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ④: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (④) |
| WK-DMF0044-0790 | G6 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 6: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-DMF0044-0791 | G6 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 7: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-DMF0044-0792 | G6 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 8: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0044-0793 | G6 | A-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — A-14: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (A-14) |
| WK-DMF0044-0794 | G6 | E01-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — E01-2: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E01-2) |
| WK-DMF0044-0795 | G6 | E01-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — E01-3: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E01-3) |
| WK-DMF0044-0796 | X-LOC | **DM_LOOKUP_DIV** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **DM_LOOKUP_DIV**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**DM_LOOKUP_DIV**) |
| WK-DMF0044-0797 | X-LOC | APPLICATION | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — APPLICATION: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (APPLICATION) |
| WK-DMF0044-0798 | X-LOC | COUNTRY_MST | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — COUNTRY_MST: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (COUNTRY_MST) |
| WK-DMF0044-0799 | X-LOC | CUST_GROUP_DTL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CUST_GROUP_DTL: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CUST_GROUP_DTL) |
| WK-DMF0044-0800 | X-LOC | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CurrencyList: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CurrencyList) |
| WK-DMF0044-0801 | X-LOC | DMF0005_REPORT_GROUP1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0005_REPORT_GROUP1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0005_REPORT_GROUP1) |
| WK-DMF0044-0802 | X-LOC | DMF0005_REPORT_GROUP2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0005_REPORT_GROUP2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0005_REPORT_GROUP2) |
| WK-DMF0044-0803 | X-LOC | DMF0005_REPORT_GROUP3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0005_REPORT_GROUP3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0005_REPORT_GROUP3) |
| WK-DMF0044-0804 | X-LOC | DMF0005_REPORT_GROUP4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0005_REPORT_GROUP4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0005_REPORT_GROUP4) |
| WK-DMF0044-0805 | X-LOC | DMF0005_REPORT_GROUP6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0005_REPORT_GROUP6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0005_REPORT_GROUP6) |
| WK-DMF0044-0806 | X-LOC | DMF0044_DEPARTMENT_TEAM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0044_DEPARTMENT_TEAM: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0044_DEPARTMENT_TEAM) |
| WK-DMF0044-0807 | X-LOC | DMF0044_DEPARTMENT_TEAM2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0044_DEPARTMENT_TEAM2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0044_DEPARTMENT_TEAM2) |
| WK-DMF0044-0808 | X-LOC | DMF0044_ETC_SALE_RESULT_TYPE_40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0044_ETC_SALE_RESULT_TYPE_40: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0044_ETC_SALE_RESULT_TYPE_40) |
| WK-DMF0044-0809 | X-LOC | DMF0044_MDF_MEASURE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DMF0044_MDF_MEASURE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DMF0044_MDF_MEASURE) |
| WK-DMF0044-0810 | X-LOC | DM_COMPANY | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DM_COMPANY: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DM_COMPANY) |
| WK-DMF0044-0811 | X-LOC | DmBizType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DmBizType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DmBizType) |
| WK-DMF0044-0812 | X-LOC | END_CUST_REPORT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — END_CUST_REPORT: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (END_CUST_REPORT) |
| WK-DMF0044-0813 | X-LOC | ExchangeRateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ExchangeRateModal: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ExchangeRateModal) |
| WK-DMF0044-0814 | X-LOC | FcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FcstType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FcstType) |
| WK-DMF0044-0815 | X-LOC | MeasureSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MeasureSelectModal: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MeasureSelectModal) |
| WK-DMF0044-0816 | X-LOC | SOLD_TO_CUST_REPORT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SOLD_TO_CUST_REPORT: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SOLD_TO_CUST_REPORT) |
| WK-DMF0044-0817 | X-LOC | TextboxModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — TextboxModal: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (TextboxModal) |
| WK-DMF0044-0818 | X-LOC | UnitedVersionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — UnitedVersionModal: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (UnitedVersionModal) |
| WK-DMF0044-0819 | X-LOC | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ②: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (②) |
| WK-DMF0044-0820 | X-LOC | ③ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ③: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (③) |
| WK-DMF0044-0821 | X-LOC | ④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ④: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (④) |
| WK-DMF0044-0822 | X-ROW | A-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — A-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (A-1) |
| WK-DMF0044-0823 | X-ROW | APPLICATION | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — APPLICATION: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (APPLICATION) |
| WK-DMF0044-0824 | X-ROW | COUNTRY_MST | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — COUNTRY_MST: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (COUNTRY_MST) |
| WK-DMF0044-0825 | X-ROW | CUST_GROUP_DTL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CUST_GROUP_DTL: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CUST_GROUP_DTL) |
| WK-DMF0044-0826 | X-ROW | CurrencyList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CurrencyList: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CurrencyList) |
| WK-DMF0044-0827 | X-ROW | D-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D-1) |
| WK-DMF0044-0828 | X-ROW | DMF0005_REPORT_GROUP1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0005_REPORT_GROUP1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0005_REPORT_GROUP1) |
| WK-DMF0044-0829 | X-ROW | DMF0005_REPORT_GROUP2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0005_REPORT_GROUP2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0005_REPORT_GROUP2) |
| WK-DMF0044-0830 | X-ROW | DMF0005_REPORT_GROUP4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0005_REPORT_GROUP4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0005_REPORT_GROUP4) |
| WK-DMF0044-0831 | X-ROW | DMF0005_REPORT_GROUP6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0005_REPORT_GROUP6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0005_REPORT_GROUP6) |
| WK-DMF0044-0832 | X-ROW | DMF0044_DEPARTMENT_TEAM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_DEPARTMENT_TEAM: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0044_DEPARTMENT_TEAM) |
| WK-DMF0044-0833 | X-ROW | DMF0044_DEPARTMENT_TEAM2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_DEPARTMENT_TEAM2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0044_DEPARTMENT_TEAM2) |
| WK-DMF0044-0834 | X-ROW | DMF0044_ETC_SALE_RESULT_TYPE_40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_ETC_SALE_RESULT_TYPE_40: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0044_ETC_SALE_RESULT_TYPE_40) |
| WK-DMF0044-0835 | X-ROW | DMF0044_MDFVersionPopUp..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_MDFVersionPopUp..ctor:93:1 A) |
| WK-DMF0044-0836 | X-ROW | DMF0044_MDFVersionPopUp.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_MDFVersionPopUp.CreateSpread) |
| WK-DMF0044-0837 | X-ROW | DMF0044_MDFVersionPopUp.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_MDFVersionPopUp.DefineProper) |
| WK-DMF0044-0838 | X-ROW | DMF0044_MDFVersionPopUp.DeleteButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.DeleteButton: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_MDFVersionPopUp.DeleteButton) |
| WK-DMF0044-0839 | X-ROW | DMF0044_MDFVersionPopUp.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_MDFVersionPopUp.Dispose:16:1) |
| WK-DMF0044-0840 | X-ROW | DMF0044_MDFVersionPopUp.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.EditButton: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_MDFVersionPopUp.EditButton A) |
| WK-DMF0044-0841 | X-ROW | DMF0044_MDFVersionPopUp.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 3 (ACT:DMF0044_MDFVersionPopUp.FindButton A) |
| WK-DMF0044-0842 | X-ROW | DMF0044_MDFVersionPopUp.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.FindData: 진입점 집계 9검사 — NOT_RUN:7 · REVIEW:1 · NOPATH:1 |  | 19 (ACT:DMF0044_MDFVersionPopUp.FindData:247) |
| WK-DMF0044-0843 | X-ROW | DMF0044_MDFVersionPopUp.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.Form_Load: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0044_MDFVersionPopUp.Form_Load:10) |
| WK-DMF0044-0844 | X-ROW | DMF0044_MDFVersionPopUp.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.InitControls: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_MDFVersionPopUp.InitControls) |
| WK-DMF0044-0845 | X-ROW | DMF0044_MDFVersionPopUp.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.InitSpread: 진입점 집계 34검사 — NOT_RUN:34 (미실행 검사가 남아 판정필요) |  | 13 (ACT:DMF0044_MDFVersionPopUp.InitSpread A) |
| WK-DMF0044-0846 | X-ROW | DMF0044_MDFVersionPopUp.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.InsertButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_MDFVersionPopUp.InsertButton) |
| WK-DMF0044-0847 | X-ROW | DMF0044_MDFVersionPopUp.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.InsertRow: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_MDFVersionPopUp.InsertRow AC) |
| WK-DMF0044-0848 | X-ROW | DMF0044_MDFVersionPopUp.LoadData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.LoadData: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_MDFVersionPopUp.LoadData ACT) |
| WK-DMF0044-0849 | X-ROW | DMF0044_MDFVersionPopUp.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.SaveButton: 진입점 집계 5검사 — NOT_RUN:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_MDFVersionPopUp.SaveButton:2) |
| WK-DMF0044-0850 | X-ROW | DMF0044_MDFVersionPopUp.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.SaveData: 진입점 집계 9검사 — NOT_RUN:6 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 20 (ACT:DMF0044_MDFVersionPopUp.SaveData:303) |
| WK-DMF0044-0851 | X-ROW | DMF0044_MDFVersionPopUp.btnButtonList_Us | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.btnButtonList_UsrButtonLis: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0044_MDFVersionPopUp.btnButtonLis) |
| WK-DMF0044-0852 | X-ROW | DMF0044_MDFVersionPopUp.mOK | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.mOK: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_MDFVersionPopUp.mOK ACT:DMF0) |
| WK-DMF0044-0853 | X-ROW | DMF0044_MDFVersionPopUp.spdMain_TopChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDFVersionPopUp.spdMain_TopChange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0044_MDFVersionPopUp.spdMain_TopC) |
| WK-DMF0044-0854 | X-ROW | DMF0044_MDF_MEASURE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_MDF_MEASURE: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DMF0044_MDF_MEASURE) |
| WK-DMF0044-0855 | X-ROW | DMF0044_SalesReportExchangePopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_SalesReportExchangePopup..ct) |
| WK-DMF0044-0856 | X-ROW | DMF0044_SalesReportExchangePopup.CreateS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_SalesReportExchangePopup.Cre) |
| WK-DMF0044-0857 | X-ROW | DMF0044_SalesReportExchangePopup.DefineP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0044_SalesReportExchangePopup.Def) |
| WK-DMF0044-0858 | X-ROW | DMF0044_SalesReportExchangePopup.DeleteB | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.DeleteButton: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0044_SalesReportExchangePopup.Del) |
| WK-DMF0044-0859 | X-ROW | DMF0044_SalesReportExchangePopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_SalesReportExchangePopup.Dis) |
| WK-DMF0044-0860 | X-ROW | DMF0044_SalesReportExchangePopup.EditBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.EditButton: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0044_SalesReportExchangePopup.Edi) |
| WK-DMF0044-0861 | X-ROW | DMF0044_SalesReportExchangePopup.FindBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.FindButton: 진입점 집계 10검사 — NOT_RUN:7 · REVIEW:3 |  | 3 (ACT:DMF0044_SalesReportExchangePopup.Fin) |
| WK-DMF0044-0862 | X-ROW | DMF0044_SalesReportExchangePopup.FindDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.FindData: 진입점 집계 15검사 — NOT_RUN:9 · REVIEW:3 · PASS:3 |  | 35 (ACT:DMF0044_SalesReportExchangePopup.Fin) |
| WK-DMF0044-0863 | X-ROW | DMF0044_SalesReportExchangePopup.Form_Lo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0044_SalesReportExchangePopup.For) |
| WK-DMF0044-0864 | X-ROW | DMF0044_SalesReportExchangePopup.GetCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.GetCellColor: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0044_SalesReportExchangePopup.Get) |
| WK-DMF0044-0865 | X-ROW | DMF0044_SalesReportExchangePopup.InitCon | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.InitControls: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0866 | X-ROW | DMF0044_SalesReportExchangePopup.InitSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.InitSpread: 진입점 집계 24검사 — NOT_RUN:23 · PASS:1 (미실행 검사가 남아 판정필요) |  | 29 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0867 | X-ROW | DMF0044_SalesReportExchangePopup.InitSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.InitSpread_X: 진입점 집계 6검사 — NOT_RUN:5 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 35 (ACT:DMF0044_SalesReportExchangePopup.Ini) |
| WK-DMF0044-0868 | X-ROW | DMF0044_SalesReportExchangePopup.InsertB | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.InsertButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_SalesReportExchangePopup.Ins) |
| WK-DMF0044-0869 | X-ROW | DMF0044_SalesReportExchangePopup.InsertR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.InsertRow: 진입점 집계 9검사 — NOT_RUN:6 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 19 (ACT:DMF0044_SalesReportExchangePopup.Ins) |
| WK-DMF0044-0870 | X-ROW | DMF0044_SalesReportExchangePopup.LoadDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.LoadData: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_SalesReportExchangePopup.Loa) |
| WK-DMF0044-0871 | X-ROW | DMF0044_SalesReportExchangePopup.SaveBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.SaveButton: 진입점 집계 10검사 — NOT_RUN:8 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_SalesReportExchangePopup.Sav) |
| WK-DMF0044-0872 | X-ROW | DMF0044_SalesReportExchangePopup.SaveDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.SaveData: 진입점 집계 16검사 — NOT_RUN:10 · PASS:4 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 83 (ACT:DMF0044_SalesReportExchangePopup.Sav) |
| WK-DMF0044-0873 | X-ROW | DMF0044_SalesReportExchangePopup.YearSet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.YearSet: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0044_SalesReportExchangePopup.Yea) |
| WK-DMF0044-0874 | X-ROW | DMF0044_SalesReportExchangePopup.btnButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.btnButtonList_Usr: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 18 (ACT:DMF0044_SalesReportExchangePopup.btn) |
| WK-DMF0044-0875 | X-ROW | DMF0044_SalesReportExchangePopup.mOK | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.mOK: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_SalesReportExchangePopup.mOK) |
| WK-DMF0044-0876 | X-ROW | DMF0044_SalesReportExchangePopup.spdMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReportExchangePopup.spdMain_TopChange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0044_SalesReportExchangePopup.spd) |
| WK-DMF0044-0877 | X-ROW | DMF0044_SalesReport_TextboxPopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup..ct) |
| WK-DMF0044-0878 | X-ROW | DMF0044_SalesReport_TextboxPopup.CreateS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_SalesReport_TextboxPopup.Cre) |
| WK-DMF0044-0879 | X-ROW | DMF0044_SalesReport_TextboxPopup.DefineP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0044_SalesReport_TextboxPopup.Def) |
| WK-DMF0044-0880 | X-ROW | DMF0044_SalesReport_TextboxPopup.DeleteB | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.DeleteButton: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_SalesReport_TextboxPopup.Del) |
| WK-DMF0044-0881 | X-ROW | DMF0044_SalesReport_TextboxPopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_SalesReport_TextboxPopup.Dis) |
| WK-DMF0044-0882 | X-ROW | DMF0044_SalesReport_TextboxPopup.EditBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 11 (ACT:DMF0044_SalesReport_TextboxPopup.Edi) |
| WK-DMF0044-0883 | X-ROW | DMF0044_SalesReport_TextboxPopup.FindDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.FindData: 진입점 집계 10검사 — NOT_RUN:6 · REVIEW:2 · PASS:1 · NOPATH:1 |  | 19 (ACT:DMF0044_SalesReport_TextboxPopup.Fin) |
| WK-DMF0044-0884 | X-ROW | DMF0044_SalesReport_TextboxPopup.Form_Lo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0044_SalesReport_TextboxPopup.For) |
| WK-DMF0044-0885 | X-ROW | DMF0044_SalesReport_TextboxPopup.GetCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.GetCellColor: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0044_SalesReport_TextboxPopup.Get) |
| WK-DMF0044-0886 | X-ROW | DMF0044_SalesReport_TextboxPopup.InitSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.InitSpread: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 12 (ACT:DMF0044_SalesReport_TextboxPopup.Ini) |
| WK-DMF0044-0887 | X-ROW | DMF0044_SalesReport_TextboxPopup.InsertB | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.InsertButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.Ins) |
| WK-DMF0044-0888 | X-ROW | DMF0044_SalesReport_TextboxPopup.LoadDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.LoadData: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_SalesReport_TextboxPopup.Loa) |
| WK-DMF0044-0889 | X-ROW | DMF0044_SalesReport_TextboxPopup.SaveBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.SaveButton: 진입점 집계 24검사 — NOT_RUN:22 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0890 | X-ROW | DMF0044_SalesReport_TextboxPopup.SaveDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.SaveData: 진입점 집계 44검사 — NOT_RUN:24 · NOPATH:18 · PASS:2 (미실행 검사가 남아 판정필요) |  | 63 (ACT:DMF0044_SalesReport_TextboxPopup.Sav) |
| WK-DMF0044-0891 | X-ROW | DMF0044_SalesReport_TextboxPopup.SetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.SetChangeRequestI: 진입점 집계 27검사 — NOT_RUN:27 (미실행 검사가 남아 판정필요) |  | 18 (ACT:DMF0044_SalesReport_TextboxPopup.Set) |
| WK-DMF0044-0892 | X-ROW | DMF0044_SalesReport_TextboxPopup.btnButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.btnButtonList_Usr: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 12 (ACT:DMF0044_SalesReport_TextboxPopup.btn) |
| WK-DMF0044-0893 | X-ROW | DMF0044_SalesReport_TextboxPopup.mOK | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.mOK: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_SalesReport_TextboxPopup.mOK) |
| WK-DMF0044-0894 | X-ROW | DMF0044_SalesReport_TextboxPopup.spdMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_SalesReport_TextboxPopup.spdMain_TopChange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0044_SalesReport_TextboxPopup.spd) |
| WK-DMF0044-0895 | X-ROW | DMF0044_Sales_Reports.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_Sales_Reports.CreateSpread) |
| WK-DMF0044-0896 | X-ROW | DMF0044_Sales_Reports.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.DefineProperty: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_Reports.DefineProperty) |
| WK-DMF0044-0897 | X-ROW | DMF0044_Sales_Reports.DeleteButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.DeleteButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_Sales_Reports.DeleteButton:2) |
| WK-DMF0044-0898 | X-ROW | DMF0044_Sales_Reports.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된 요 |  | 15 (ACT:DMF0044_Sales_Reports.ExcelButton AC) |
| WK-DMF0044-0899 | X-ROW | DMF0044_Sales_Reports.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:DMF0044_Sales_Reports.FindButton) |
| WK-DMF0044-0900 | X-ROW | DMF0044_Sales_Reports.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.FindData: 진입점 집계 17검사 — NOT_RUN:13 · REVIEW:2 · PASS:2 |  | 7 (ACT:DMF0044_Sales_Reports.FindData:444:7) |
| WK-DMF0044-0901 | X-ROW | DMF0044_Sales_Reports.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_Sales_Reports.Form_Load) |
| WK-DMF0044-0902 | X-ROW | DMF0044_Sales_Reports.GetCalendarYYYY | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.GetCalendarYYYY: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_Sales_Reports.GetCalendarYYY) |
| WK-DMF0044-0903 | X-ROW | DMF0044_Sales_Reports.GetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.GetCellColor: 진입점 집계 3검사 — NOT_RUN:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_Sales_Reports.GetCellColor) |
| WK-DMF0044-0904 | X-ROW | DMF0044_Sales_Reports.GetCellIndexBySpan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.GetCellIndexBySpanRowCells: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_Sales_Reports.GetCellIndexBy) |
| WK-DMF0044-0905 | X-ROW | DMF0044_Sales_Reports.GetCellNumbersByRo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.GetCellNumbersByRow: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_Sales_Reports.GetCellNumbers) |
| WK-DMF0044-0906 | X-ROW | DMF0044_Sales_Reports.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.GetLookupData: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_Sales_Reports.GetLookupData) |
| WK-DMF0044-0907 | X-ROW | DMF0044_Sales_Reports.GetMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.GetMeasure: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_Sales_Reports.GetMeasure) |
| WK-DMF0044-0908 | X-ROW | DMF0044_Sales_Reports.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.InitControls: 진입점 집계 11검사 — NOT_RUN:10 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_Reports.InitControls:1) |
| WK-DMF0044-0909 | X-ROW | DMF0044_Sales_Reports.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.InitSpread: 진입점 집계 10검사 — NOT_RUN:9 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_Sales_Reports.InitSpread) |
| WK-DMF0044-0910 | X-ROW | DMF0044_Sales_Reports.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_Sales_Reports.InsertButton) |
| WK-DMF0044-0911 | X-ROW | DMF0044_Sales_Reports.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.InsertRow: 진입점 집계 30검사 — NOT_RUN:27 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 39 (ACT:DMF0044_Sales_Reports.InsertRow ACT:) |
| WK-DMF0044-0912 | X-ROW | DMF0044_Sales_Reports.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.SaveData: 진입점 집계 18검사 — NOT_RUN:12 · PASS:4 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 12 (ACT:DMF0044_Sales_Reports.SaveData:521:1) |
| WK-DMF0044-0913 | X-ROW | DMF0044_Sales_Reports.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.SetChangeControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_Reports.SetChangeContr) |
| WK-DMF0044-0914 | X-ROW | DMF0044_Sales_Reports.SetRowSpanFucTwo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.SetRowSpanFucTwo: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_Sales_Reports.SetRowSpanFucT) |
| WK-DMF0044-0915 | X-ROW | DMF0044_Sales_Reports.YearSet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.YearSet: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_Reports.YearSet ACT:DM) |
| WK-DMF0044-0916 | X-ROW | DMF0044_Sales_Reports.btnExchangeRate_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.btnExchangeRate_Click: 진입점 집계 8검사 — NOT_RUN:6 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_Reports.btnExchangeRat) |
| WK-DMF0044-0917 | X-ROW | DMF0044_Sales_Reports.btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.btnMeasure_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_Sales_Reports.btnMeasure_Cli) |
| WK-DMF0044-0918 | X-ROW | DMF0044_Sales_Reports.btnSPVer_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.btnSPVer_Click: 진입점 집계 8검사 — NOT_RUN:4 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_Reports.btnSPVer_Click) |
| WK-DMF0044-0919 | X-ROW | DMF0044_Sales_Reports.btnTextbox_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.btnTextbox_Click: 진입점 집계 7검사 — NOT_RUN:5 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_Reports.btnTextbox_Cli) |
| WK-DMF0044-0920 | X-ROW | DMF0044_Sales_Reports.clbDivision_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.clbDivision_SelectedIndexCha: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_Reports.clbDivision_Se) |
| WK-DMF0044-0921 | X-ROW | DMF0044_Sales_Reports.clbType_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.clbType_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_Sales_Reports.clbType_Select) |
| WK-DMF0044-0922 | X-ROW | DMF0044_Sales_Reports.spdMain_CellDouble | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.spdMain_CellDoubleClick: 진입점 집계 9검사 — NOT_RUN:7 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_Sales_Reports.spdMain_CellDo) |
| WK-DMF0044-0923 | X-ROW | DMF0044_Sales_Reports.spdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_Reports.spdMain_Changed: 진입점 집계 51검사 — NOT_RUN:31 · NOPATH:15 · REVIEW:3 · TODO:2 |  | 36 (ACT:DMF0044_Sales_Reports.spdMain_Change) |
| WK-DMF0044-0924 | X-ROW | DMF0044_Sales_VersionCopyPopUp..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_VersionCopyPopUp..ctor) |
| WK-DMF0044-0925 | X-ROW | DMF0044_Sales_VersionCopyPopUp.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_Sales_VersionCopyPopUp.Creat) |
| WK-DMF0044-0926 | X-ROW | DMF0044_Sales_VersionCopyPopUp.DefinePro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_VersionCopyPopUp.Defin) |
| WK-DMF0044-0927 | X-ROW | DMF0044_Sales_VersionCopyPopUp.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_Sales_VersionCopyPopUp.Dispo) |
| WK-DMF0044-0928 | X-ROW | DMF0044_Sales_VersionCopyPopUp.FindButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.FindButton: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:2 |  | 2 (ACT:DMF0044_Sales_VersionCopyPopUp.FindB) |
| WK-DMF0044-0929 | X-ROW | DMF0044_Sales_VersionCopyPopUp.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.FindData: 진입점 집계 14검사 — NOT_RUN:10 · REVIEW:2 · NOPATH:1 · PASS:1 |  | 28 (ACT:DMF0044_Sales_VersionCopyPopUp.FindD) |
| WK-DMF0044-0930 | X-ROW | DMF0044_Sales_VersionCopyPopUp.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.Form_Load: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0044_Sales_VersionCopyPopUp.Form_) |
| WK-DMF0044-0931 | X-ROW | DMF0044_Sales_VersionCopyPopUp.InitContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0044_Sales_VersionCopyPopUp.InitC) |
| WK-DMF0044-0932 | X-ROW | DMF0044_Sales_VersionCopyPopUp.InitSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.InitSpread: 진입점 집계 8검사 — NOT_RUN:7 · PASS:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:DMF0044_Sales_VersionCopyPopUp.InitS) |
| WK-DMF0044-0933 | X-ROW | DMF0044_Sales_VersionCopyPopUp.LoadData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.LoadData: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0044_Sales_VersionCopyPopUp.LoadD) |
| WK-DMF0044-0934 | X-ROW | DMF0044_Sales_VersionCopyPopUp.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.SaveData: 진입점 집계 13검사 — NOT_RUN:9 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 51 (ACT:DMF0044_Sales_VersionCopyPopUp.SaveD) |
| WK-DMF0044-0935 | X-ROW | DMF0044_Sales_VersionCopyPopUp.btnButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.btnButtonList_UsrBu: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0044_Sales_VersionCopyPopUp.btnBu) |
| WK-DMF0044-0936 | X-ROW | DMF0044_Sales_VersionCopyPopUp.btnTransf | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.btnTransfer_Click: 진입점 집계 11검사 — NOT_RUN:10 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 29 (ACT:DMF0044_Sales_VersionCopyPopUp.btnTr) |
| WK-DMF0044-0937 | X-ROW | DMF0044_Sales_VersionCopyPopUp.spdMain_T | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionCopyPopUp.spdMain_TopChange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_VersionCopyPopUp.spdMa) |
| WK-DMF0044-0938 | X-ROW | DMF0044_Sales_VersionPopUp..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_VersionPopUp..ctor:82:) |
| WK-DMF0044-0939 | X-ROW | DMF0044_Sales_VersionPopUp.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_Sales_VersionPopUp.CreateSpr) |
| WK-DMF0044-0940 | X-ROW | DMF0044_Sales_VersionPopUp.DefinePropert | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_VersionPopUp.DefinePro) |
| WK-DMF0044-0941 | X-ROW | DMF0044_Sales_VersionPopUp.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_Sales_VersionPopUp.Dispose:1) |
| WK-DMF0044-0942 | X-ROW | DMF0044_Sales_VersionPopUp.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.FindButton: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:2 |  | 3 (ACT:DMF0044_Sales_VersionPopUp.FindButto) |
| WK-DMF0044-0943 | X-ROW | DMF0044_Sales_VersionPopUp.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.FindData: 진입점 집계 13검사 — NOT_RUN:9 · REVIEW:2 · PASS:2 |  | 22 (ACT:DMF0044_Sales_VersionPopUp.FindData:) |
| WK-DMF0044-0944 | X-ROW | DMF0044_Sales_VersionPopUp.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.Form_Load: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0044_Sales_VersionPopUp.Form_Load) |
| WK-DMF0044-0945 | X-ROW | DMF0044_Sales_VersionPopUp.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.InitControls: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_Sales_VersionPopUp.InitContr) |
| WK-DMF0044-0946 | X-ROW | DMF0044_Sales_VersionPopUp.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.InitSpread: 진입점 집계 8검사 — NOT_RUN:7 · PASS:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:DMF0044_Sales_VersionPopUp.InitSprea) |
| WK-DMF0044-0947 | X-ROW | DMF0044_Sales_VersionPopUp.LoadData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.LoadData: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0044_Sales_VersionPopUp.LoadData ) |
| WK-DMF0044-0948 | X-ROW | DMF0044_Sales_VersionPopUp.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.SaveData: 진입점 집계 11검사 — NOT_RUN:7 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 24 (ACT:DMF0044_Sales_VersionPopUp.SaveData:) |
| WK-DMF0044-0949 | X-ROW | DMF0044_Sales_VersionPopUp.SetItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.SetItem: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 16 (ACT:DMF0044_Sales_VersionPopUp.SetItem:3) |
| WK-DMF0044-0950 | X-ROW | DMF0044_Sales_VersionPopUp.btnButtonList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.btnButtonList_UsrButton: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0044_Sales_VersionPopUp.btnButton) |
| WK-DMF0044-0951 | X-ROW | DMF0044_Sales_VersionPopUp.btnCopy_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.btnCopy_Click: 진입점 집계 7검사 — NOT_RUN:5 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_Sales_VersionPopUp.btnCopy_C) |
| WK-DMF0044-0952 | X-ROW | DMF0044_Sales_VersionPopUp.btnTransfer_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.btnTransfer_Click: 진입점 집계 11검사 — NOT_RUN:10 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 29 (ACT:DMF0044_Sales_VersionPopUp.btnTransf) |
| WK-DMF0044-0953 | X-ROW | DMF0044_Sales_VersionPopUp.spdMain_CellD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.spdMain_CellDoubleClick: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_Sales_VersionPopUp.spdMain_C) |
| WK-DMF0044-0954 | X-ROW | DMF0044_Sales_VersionPopUp.spdMain_TopCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_Sales_VersionPopUp.spdMain_TopChange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0044_Sales_VersionPopUp.spdMain_T) |
| WK-DMF0044-0955 | X-ROW | DMF0044_United_VersionPopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_United_VersionPopup..ctor:86) |
| WK-DMF0044-0956 | X-ROW | DMF0044_United_VersionPopup.ControlDispl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.ControlDisplay: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 44 (ACT:DMF0044_United_VersionPopup.ControlD) |
| WK-DMF0044-0957 | X-ROW | DMF0044_United_VersionPopup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0044_United_VersionPopup.CreateSp) |
| WK-DMF0044-0958 | X-ROW | DMF0044_United_VersionPopup.DMF0044_MOBI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.DMF0044_MOBILE_REPORT_: 진입점 집계 8검사 — NOT_RUN:6 · PASS:2 (미실행 검사가 남아 판정필요) |  | 20 (ACT:DMF0044_United_VersionPopup.DMF0044_) |
| WK-DMF0044-0959 | X-ROW | DMF0044_United_VersionPopup.DMF0044_SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.DMF0044_SAVE_SALES_PLA: 진입점 집계 10검사 — NOT_RUN:7 · PASS:3 (미실행 검사가 남아 판정필요) |  | 26 (ACT:DMF0044_United_VersionPopup.DMF0044_) |
| WK-DMF0044-0960 | X-ROW | DMF0044_United_VersionPopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_United_VersionPopup.Dispose:) |
| WK-DMF0044-0961 | X-ROW | DMF0044_United_VersionPopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.FindButton: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:2 |  | 2 (ACT:DMF0044_United_VersionPopup.FindButt) |
| WK-DMF0044-0962 | X-ROW | DMF0044_United_VersionPopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.FindData: 진입점 집계 17검사 — NOT_RUN:13 · REVIEW:2 · PASS:2 |  | 21 (ACT:DMF0044_United_VersionPopup.FindData) |
| WK-DMF0044-0963 | X-ROW | DMF0044_United_VersionPopup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 11 (ACT:DMF0044_United_VersionPopup.Form_Loa) |
| WK-DMF0044-0964 | X-ROW | DMF0044_United_VersionPopup.GetLookupDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.GetLookupData: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0044_United_VersionPopup.GetLooku) |
| WK-DMF0044-0965 | X-ROW | DMF0044_United_VersionPopup.GetLookupVal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.GetLookupValues: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0044_United_VersionPopup.GetLooku) |
| WK-DMF0044-0966 | X-ROW | DMF0044_United_VersionPopup.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.GetSpdTitle: 진입점 집계 6검사 — NOT_RUN:3 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0044_United_VersionPopup.GetSpdTi) |
| WK-DMF0044-0967 | X-ROW | DMF0044_United_VersionPopup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.InitControls: 진입점 집계 13검사 — NOT_RUN:12 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 15 (ACT:DMF0044_United_VersionPopup.InitCont) |
| WK-DMF0044-0968 | X-ROW | DMF0044_United_VersionPopup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.InitSpread: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0044_United_VersionPopup.InitSpre) |
| WK-DMF0044-0969 | X-ROW | DMF0044_United_VersionPopup.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.SaveButton: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · REVIEW:1 |  | 1 (ACT:DMF0044_United_VersionPopup.SaveButt) |
| WK-DMF0044-0970 | X-ROW | DMF0044_United_VersionPopup.SingleCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.SingleCheck: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0044_United_VersionPopup.SingleCh) |
| WK-DMF0044-0971 | X-ROW | DMF0044_United_VersionPopup.btnClose_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.btnClose_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_United_VersionPopup.btnClose) |
| WK-DMF0044-0972 | X-ROW | DMF0044_United_VersionPopup.btnFind_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.btnFind_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_United_VersionPopup.btnFind_) |
| WK-DMF0044-0973 | X-ROW | DMF0044_United_VersionPopup.btnOK_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.btnOK_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0044_United_VersionPopup.btnOK_Cl) |
| WK-DMF0044-0974 | X-ROW | DMF0044_United_VersionPopup.btnTranCance | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.btnTranCancel_Click: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0044_United_VersionPopup.btnTranC) |
| WK-DMF0044-0975 | X-ROW | DMF0044_United_VersionPopup.btnTransfer_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.btnTransfer_Click: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0044_United_VersionPopup.btnTrans) |
| WK-DMF0044-0976 | X-ROW | DMF0044_United_VersionPopup.btnVerCopy_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.btnVerCopy_Click: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0044_United_VersionPopup.btnVerCo) |
| WK-DMF0044-0977 | X-ROW | DMF0044_United_VersionPopup.btnVerCre_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.btnVerCre_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_United_VersionPopup.btnVerCr) |
| WK-DMF0044-0978 | X-ROW | DMF0044_United_VersionPopup.btnVerDel_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.btnVerDel_Click: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 9 (ACT:DMF0044_United_VersionPopup.btnVerDe) |
| WK-DMF0044-0979 | X-ROW | DMF0044_United_VersionPopup.chkMV_Checke | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.chkMV_CheckedChanged: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0044_United_VersionPopup.chkMV_Ch) |
| WK-DMF0044-0980 | X-ROW | DMF0044_United_VersionPopup.chkResult_Ch | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.chkResult_CheckedChang: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0044_United_VersionPopup.chkResul) |
| WK-DMF0044-0981 | X-ROW | DMF0044_United_VersionPopup.clbType_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.clbType_SelectedIndexC: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0044_United_VersionPopup.clbType_) |
| WK-DMF0044-0982 | X-ROW | DMF0044_United_VersionPopup.spdMain_Cell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.spdMain_CellClick: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:DMF0044_United_VersionPopup.spdMain_) |
| WK-DMF0044-0983 | X-ROW | DMF0044_United_VersionPopup.spdMain_Cell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.spdMain_CellDoubleClic: 진입점 집계 8검사 — NOT_RUN:5 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0044_United_VersionPopup.spdMain_) |
| WK-DMF0044-0984 | X-ROW | DMF0044_United_VersionPopup.usrButton1_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0044_United_VersionPopup.usrButton1_Click: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0044_United_VersionPopup.usrButto) |
| WK-DMF0044-0985 | X-ROW | DM_COMPANY | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DM_COMPANY: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DM_COMPANY) |
| WK-DMF0044-0986 | X-ROW | DmBizType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DmBizType: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (DmBizType) |
| WK-DMF0044-0987 | X-ROW | E01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E01) |
| WK-DMF0044-0988 | X-ROW | E01-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E01-5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E01-5) |
| WK-DMF0044-0989 | X-ROW | E09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E09: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E09) |
| WK-DMF0044-0990 | X-ROW | E09-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E09-2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E09-2) |
| WK-DMF0044-0991 | X-ROW | END_CUST_REPORT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — END_CUST_REPORT: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (END_CUST_REPORT) |
| WK-DMF0044-0992 | X-ROW | FcstType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — FcstType: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (FcstType) |
| WK-DMF0044-0993 | X-ROW | HANDLER:ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0044-0994 | X-ROW | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:Form_Load: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:Form_Load) |
| WK-DMF0044-0995 | X-ROW | HANDLER:btnExchangeRate_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnExchangeRate_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnExchangeRate_Click) |
| WK-DMF0044-0996 | X-ROW | HANDLER:btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnMeasure_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnMeasure_Click) |
| WK-DMF0044-0997 | X-ROW | HANDLER:btnSPVer_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnSPVer_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnSPVer_Click) |
| WK-DMF0044-0998 | X-ROW | HANDLER:btnTextbox_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnTextbox_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnTextbox_Click) |
| WK-DMF0044-0999 | X-ROW | M-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — M-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (M-1) |
| WK-DMF0044-1000 | X-ROW | M-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — M-2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (M-2) |
| WK-DMF0044-1001 | X-ROW | M-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — M-3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (M-3) |
| WK-DMF0044-1002 | X-ROW | M-6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — M-6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (M-6) |
| WK-DMF0044-1003 | X-ROW | M-8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — M-8: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (M-8) |
| WK-DMF0044-1004 | X-ROW | MODAL:ExchangeRateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:ExchangeRateModal: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:ExchangeRateModal) |
| WK-DMF0044-1005 | X-ROW | MODAL:MeasureSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:MeasureSelectModal: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:MeasureSelectModal) |
| WK-DMF0044-1006 | X-ROW | MODAL:SalesReportsModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:SalesReportsModals: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:SalesReportsModals) |
| WK-DMF0044-1007 | X-ROW | MODAL:TextboxModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MODAL:TextboxModal: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MODAL:TextboxModal) |
| WK-DMF0044-1008 | X-ROW | SOLD_TO_CUST_REPORT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SOLD_TO_CUST_REPORT: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SOLD_TO_CUST_REPORT) |
| WK-DMF0044-1009 | X-ROW | V-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — V-12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (V-12) |
| WK-DMF0044-1010 | X-ROW | V-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — V-14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (V-14) |
| WK-DMF0044-1011 | X-ROW | V-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — V-15: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (V-15) |
| WK-DMF0044-1012 | X-ROW | V-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — V-18: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (V-18) |
| WK-DMF0044-1013 | X-ROW | V-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — V-19: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (V-19) |
| WK-DMF0044-1014 | X-ROW | V-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — V-2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (V-2) |
| WK-DMF0044-1015 | X-ROW | V-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — V-21: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (V-21) |
| WK-DMF0044-1016 | X-ROW | V-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — V-22: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (V-22) |
| WK-DMF0044-1017 | X-ROW | V-23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — V-23: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (V-23) |
| WK-DMF0044-1018 | G5 | A-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — A-12: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (A-12) |
| WK-DMF0044-1019 | G5 | A-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — A-14: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (A-14) |
| WK-DMF0044-1020 | G5 | E05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E05: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (E05) |
| WK-DMF0044-1021 | G5 | E05-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E05-5: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (E05-5) |
| WK-DMF0044-1022 | G5 | E10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E10: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (E10) |
| WK-DMF0044-1023 | G5 | ExchangeRateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ExchangeRateModal: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (ExchangeRateModal) |
| WK-DMF0044-1024 | G5 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0044-1025 | G5 | L-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — L-27: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (L-27) |
| WK-DMF0044-1026 | G5 | L-30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — L-30: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (L-30) |
| WK-DMF0044-1027 | G5 | MSG00279/280/156/143/151 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00279/280/156/143/151: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (MSG00279/280/156/143/151) |
| WK-DMF0044-1028 | G5 | MSG00281 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00281: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (MSG00281) |
| WK-DMF0044-1029 | G5 | MeasureSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MeasureSelectModal: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (MeasureSelectModal) |
| WK-DMF0044-1030 | G5 | REQ:CHAT-20260820-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — REQ:CHAT-20260820-12: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-12) |
| WK-DMF0044-1031 | G5 | REQ:CHAT-20260820-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — REQ:CHAT-20260820-13: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-13) |
| WK-DMF0044-1032 | G5 | REQ:CHAT-20260820-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — REQ:CHAT-20260820-7: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-7) |
| WK-DMF0044-1033 | G5 | TextboxModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — TextboxModal: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (TextboxModal) |
| WK-DMF0044-1034 | G5 | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ②: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (②) |
| WK-DMF0044-1035 | G5 | ④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ④: 행 집계 — G5 19요소: NOPATH:19 (미실행 요소가 남아 판정필요) |  | 1 (④) |
| WK-DMF0044-1036 | H6 | A-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — A-12: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (A-12) |
| WK-DMF0044-1037 | H6 | A-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — A-14: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (A-14) |
| WK-DMF0044-1038 | H6 | E05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E05: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (E05) |
| WK-DMF0044-1039 | H6 | E05-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E05-5: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (E05-5) |
| WK-DMF0044-1040 | H6 | E10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E10: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (E10) |
| WK-DMF0044-1041 | H6 | ExchangeRateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ExchangeRateModal: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ExchangeRateModal) |
| WK-DMF0044-1042 | H6 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0044-1043 | H6 | L-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — L-27: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (L-27) |
| WK-DMF0044-1044 | H6 | L-30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — L-30: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (L-30) |
| WK-DMF0044-1045 | H6 | MSG00279/280/156/143/151 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00279/280/156/143/151: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (MSG00279/280/156/143/151) |
| WK-DMF0044-1046 | H6 | MSG00281 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00281: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (MSG00281) |
| WK-DMF0044-1047 | H6 | MeasureSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MeasureSelectModal: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (MeasureSelectModal) |
| WK-DMF0044-1048 | H6 | REQ:CHAT-20260820-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — REQ:CHAT-20260820-12: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-12) |
| WK-DMF0044-1049 | H6 | REQ:CHAT-20260820-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — REQ:CHAT-20260820-13: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-13) |
| WK-DMF0044-1050 | H6 | REQ:CHAT-20260820-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — REQ:CHAT-20260820-7: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-7) |
| WK-DMF0044-1051 | H6 | TextboxModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — TextboxModal: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (TextboxModal) |
| WK-DMF0044-1052 | H6 | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ②: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (②) |
| WK-DMF0044-1053 | H6 | ④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ④: 행 집계 — H6 19요소: NOPATH:14 · NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (④) |
| WK-DMF0044-1054 | M4 | A-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — A-12: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (A-12) |
| WK-DMF0044-1055 | M4 | A-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — A-14: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (A-14) |
| WK-DMF0044-1056 | M4 | E05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E05: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (E05) |
| WK-DMF0044-1057 | M4 | E05-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E05-5: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (E05-5) |
| WK-DMF0044-1058 | M4 | E10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E10: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (E10) |
| WK-DMF0044-1059 | M4 | ExchangeRateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ExchangeRateModal: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (ExchangeRateModal) |
| WK-DMF0044-1060 | M4 | HANDLER:spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — HANDLER:spdMain_CellDoubleClick: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:spdMain_CellDoubleClick) |
| WK-DMF0044-1061 | M4 | L-27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — L-27: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (L-27) |
| WK-DMF0044-1062 | M4 | L-30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — L-30: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (L-30) |
| WK-DMF0044-1063 | M4 | MSG00279/280/156/143/151 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00279/280/156/143/151: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (MSG00279/280/156/143/151) |
| WK-DMF0044-1064 | M4 | MSG00281 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00281: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (MSG00281) |
| WK-DMF0044-1065 | M4 | MeasureSelectModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MeasureSelectModal: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (MeasureSelectModal) |
| WK-DMF0044-1066 | M4 | REQ:CHAT-20260820-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — REQ:CHAT-20260820-12: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-12) |
| WK-DMF0044-1067 | M4 | REQ:CHAT-20260820-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — REQ:CHAT-20260820-13: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-13) |
| WK-DMF0044-1068 | M4 | REQ:CHAT-20260820-7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — REQ:CHAT-20260820-7: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (REQ:CHAT-20260820-7) |
| WK-DMF0044-1069 | M4 | TextboxModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — TextboxModal: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (TextboxModal) |
| WK-DMF0044-1070 | M4 | ② | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ②: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (②) |
| WK-DMF0044-1071 | M4 | ④ | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ④: 행 집계 — M4 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (④) |

## W8 구현 후 검증 (24)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0044-1072 | B1 | COMMON:UC-05 | 선행 W1 완료 후 E2E | B1 — 대조표 미구현 행 COMMON:UC-05 구현 후 검증 · 대상 COMMON:UC-05 |  | 1 (COMMON:UC-05) |
| WK-DMF0044-1073 | B2 | COMMON:UC-05 | 선행 W1 완료 후 E2E | B2 — 대조표 미구현 행 COMMON:UC-05 구현 후 검증 · 대상 COMMON:UC-05 |  | 1 (COMMON:UC-05) |
| WK-DMF0044-1074 | B4 | COMMON:UC-05 | 선행 W1 완료 후 E2E | B4 — 대조표 미구현 행 COMMON:UC-05 구현 후 검증 · 대상 COMMON:UC-05 |  | 1 (COMMON:UC-05) |
| WK-DMF0044-1075 | G4 | COMMON:UC-06 | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행 COMMON:UC-06 구현 후 검증 · 대상 COMMON:UC-06 |  | 1 (COMMON:UC-06) |
| WK-DMF0044-1076 | D4 | COMMON:UC-01 | 선행 W1 완료 후 E2E | D4 — 대조표 미구현 행 COMMON:UC-01 구현 후 검증 · 대상 COMMON:UC-01 |  | 1 (COMMON:UC-01) |
| WK-DMF0044-1077 | D4 | COMMON:UC-03 | 선행 W1 완료 후 E2E | D4 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-DMF0044-1078 | D5 | COMMON:UC-05 | 선행 W1 완료 후 E2E | D5 — 대조표 미구현 행 COMMON:UC-05 구현 후 검증 · 대상 COMMON:UC-05 |  | 1 (COMMON:UC-05) |
| WK-DMF0044-1079 | E4 | DMF0044_Sales_Reports.SetChangeControl | 선행 W1 완료 후 E2E | E4 — 대조표 미구현 행  구현 후 검증 · 대상 DMF0044_Sales_Reports.SetChangeControl |  | 4 (ACT:DMF0044_Sales_Reports.SetChangeContr) |
| WK-DMF0044-1080 | E4 | DMF0044_Sales_Reports.SetRowSpanFucTwo | 선행 W1 완료 후 E2E | E4 — 대조표 미구현 행  구현 후 검증 · 대상 DMF0044_Sales_Reports.SetRowSpanFucTwo |  | 15 (ACT:DMF0044_Sales_Reports.SetRowSpanFucT) |
| WK-DMF0044-1081 | E4 | E11 | 선행 W1 완료 후 E2E | E4 — 대조표 미구현 행  구현 후 검증 · 대상 E11 |  | 1 (E11) |
| WK-DMF0044-1082 | E4 | MSG00703 | 선행 W1 완료 후 E2E | E4 — 대조표 미구현 행 COMMON:UC-02 구현 후 검증 · 대상 MSG00703 |  | 1 (COMMON:UC-02) |
| WK-DMF0044-1083 | E4 | REQ:CHAT-20260820-4 | 선행 W1 완료 후 E2E | E4 — 대조표 미구현 행  구현 후 검증 · 대상 REQ:CHAT-20260820-4 |  | 1 (REQ:CHAT-20260820-4) |
| WK-DMF0044-1084 | E4 | REQ:CHAT-20260820-5 | 선행 W1 완료 후 E2E | E4 — 대조표 미구현 행  구현 후 검증 · 대상 REQ:CHAT-20260820-5 |  | 1 (REQ:CHAT-20260820-5) |
| WK-DMF0044-1085 | E5 | COMMON:UC-05 | 선행 W1 완료 후 E2E | E5 — 대조표 미구현 행 COMMON:UC-05 구현 후 검증 · 대상 COMMON:UC-05 |  | 1 (COMMON:UC-05) |
| WK-DMF0044-1086 | A1 | COMMON:UC-02 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 COMMON:UC-02 구현 후 검증 · 대상 COMMON:UC-02 |  | 1 (COMMON:UC-02) |
| WK-DMF0044-1087 | A1 | COMMON:UC-03 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-DMF0044-1088 | A1 | COMMON:UC-06 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 COMMON:UC-06 구현 후 검증 · 대상 COMMON:UC-06 |  | 1 (COMMON:UC-06) |
| WK-DMF0044-1089 | A1 | COMMON:UC-07 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 COMMON:UC-07 구현 후 검증 · 대상 COMMON:UC-07 |  | 1 (COMMON:UC-07) |
| WK-DMF0044-1090 | G1 | COMMON:UC-02 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 COMMON:UC-02 구현 후 검증 · 대상 COMMON:UC-02 |  | 1 (COMMON:UC-02) |
| WK-DMF0044-1091 | G1 | COMMON:UC-03 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 COMMON:UC-03 구현 후 검증 · 대상 COMMON:UC-03 |  | 1 (COMMON:UC-03) |
| WK-DMF0044-1092 | G1 | COMMON:UC-06 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 COMMON:UC-06 구현 후 검증 · 대상 COMMON:UC-06 |  | 1 (COMMON:UC-06) |
| WK-DMF0044-1093 | G1 | COMMON:UC-07 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 COMMON:UC-07 구현 후 검증 · 대상 COMMON:UC-07 |  | 1 (COMMON:UC-07) |
| WK-DMF0044-1094 | G6 | COMMON:UC-06 | 선행 W1 완료 후 E2E | G6 — 대조표 미구현 행 COMMON:UC-06 구현 후 검증 · 대상 COMMON:UC-06 |  | 1 (COMMON:UC-06) |
| WK-DMF0044-1095 | X-ROW | COMMON:UC-04 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행  구현 후 검증 · 대상 COMMON:UC-04 |  | 0 () |
