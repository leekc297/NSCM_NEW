# 작업 원장 — DMF0074 · 2026-10-26 12:51

> 검사 인스턴스 793건 중 PASS·NA 258건 외 **535건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 104 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 1 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 17 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 78 | 실행 → PASS |
| W7 | 기대값 확정 | 334 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 321 · 대조표 117 · E2E 78 · 하네스 18 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 104 |  |  |  |  | 4 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 15 | 55 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-ROW | GEN |  |  |  |  |  |  | 64 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 43 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 9 | 24 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G5 | POPUP |  |  |  |  | 7 |  | 17 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 4 | 3 | 17 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 6 | 17 |  |  | 팝업 선택값 반영 |
| F4 | DB |  |  |  |  |  | 4 | 13 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  | 4 | 12 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| DB-SYN | DB |  |  |  |  | 1 |  | 13 |  |  | BE 계정 시노님·권한·대상 객체 |
| G4 | DESIGN |  |  |  |  | 2 | 9 | 2 |  |  | 조회조건 표시·라벨·활성 |
| X-REASON | DESIGN |  |  |  |  |  |  | 13 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B3 | COMBO |  |  |  | 1 |  |  | 11 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 1 |  | 11 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| H5 | DESIGN |  |  |  |  |  | 1 | 11 |  |  | 라벨 명칭 |
| G6 | GEN |  |  |  |  |  | 9 | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C1 | CASCADE |  |  |  |  |  | 5 | 5 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| M3 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 내부 기능(조회·CRUD) |

## W2 구현 위치 확인 (104)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0074-0001 | X-LOC | 10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (10) |
| WK-DMF0074-0002 | X-LOC | 11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (11) |
| WK-DMF0074-0003 | X-LOC | 12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (12) |
| WK-DMF0074-0004 | X-LOC | 13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (13) |
| WK-DMF0074-0005 | X-LOC | 14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (14) |
| WK-DMF0074-0006 | X-LOC | 15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (15) |
| WK-DMF0074-0007 | X-LOC | 16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (16) |
| WK-DMF0074-0008 | X-LOC | 17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (17) |
| WK-DMF0074-0009 | X-LOC | 18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (18) |
| WK-DMF0074-0010 | X-LOC | 19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (19) |
| WK-DMF0074-0011 | X-LOC | 20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (20) |
| WK-DMF0074-0012 | X-LOC | 21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (21) |
| WK-DMF0074-0013 | X-LOC | 5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (5) |
| WK-DMF0074-0014 | X-LOC | 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (6) |
| WK-DMF0074-0015 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (7) |
| WK-DMF0074-0016 | X-LOC | 8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (8) |
| WK-DMF0074-0017 | X-LOC | 9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (9) |
| WK-DMF0074-0018 | X-LOC | COMMON:UC-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/fcst-upload-modal/FcstUploadModal.tsx 없음 |  | 1 (COMMON:UC-04) |
| WK-DMF0074-0019 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: BusinessPlanGrid.tsx 없음 |  | 1 (COMMON:UC-07) |
| WK-DMF0074-0020 | X-LOC | E01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E01) |
| WK-DMF0074-0021 | X-LOC | E02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E02) |
| WK-DMF0074-0022 | X-LOC | E02-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E02-1) |
| WK-DMF0074-0023 | X-LOC | E02-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E02-3) |
| WK-DMF0074-0024 | X-LOC | E03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E03) |
| WK-DMF0074-0025 | X-LOC | E03-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E03-1) |
| WK-DMF0074-0026 | X-LOC | E03-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E03-2) |
| WK-DMF0074-0027 | X-LOC | E04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E04) |
| WK-DMF0074-0028 | X-LOC | E05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E05) |
| WK-DMF0074-0029 | X-LOC | E05-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E05-1) |
| WK-DMF0074-0030 | X-LOC | E07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E07) |
| WK-DMF0074-0031 | X-LOC | ED-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ED-02) |
| WK-DMF0074-0032 | X-LOC | ED-03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ED-03) |
| WK-DMF0074-0033 | X-LOC | EV-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-001) |
| WK-DMF0074-0034 | X-LOC | EV-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-002) |
| WK-DMF0074-0035 | X-LOC | EV-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-003) |
| WK-DMF0074-0036 | X-LOC | EV-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-004) |
| WK-DMF0074-0037 | X-LOC | EV-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-005) |
| WK-DMF0074-0038 | X-LOC | EV-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-006) |
| WK-DMF0074-0039 | X-LOC | EV-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-007) |
| WK-DMF0074-0040 | X-LOC | EV-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-008) |
| WK-DMF0074-0041 | X-LOC | EV-009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-009) |
| WK-DMF0074-0042 | X-LOC | EV-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-010) |
| WK-DMF0074-0043 | X-LOC | EV-011 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-011) |
| WK-DMF0074-0044 | X-LOC | EV-012 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-012) |
| WK-DMF0074-0045 | X-LOC | EV-013 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-013) |
| WK-DMF0074-0046 | X-LOC | EV-014 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-014) |
| WK-DMF0074-0047 | X-LOC | EV-015 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-015) |
| WK-DMF0074-0048 | X-LOC | EV-016 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-016) |
| WK-DMF0074-0049 | X-LOC | EV-017 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-017) |
| WK-DMF0074-0050 | X-LOC | EV-018 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-018) |
| WK-DMF0074-0051 | X-LOC | EV-019 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-019) |
| WK-DMF0074-0052 | X-LOC | EV-020 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-020) |
| WK-DMF0074-0053 | X-LOC | EV-021 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-021) |
| WK-DMF0074-0054 | X-LOC | EV-022 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-022) |
| WK-DMF0074-0055 | X-LOC | EV-023 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-023) |
| WK-DMF0074-0056 | X-LOC | EV-024 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-024) |
| WK-DMF0074-0057 | X-LOC | EV-025 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-025) |
| WK-DMF0074-0058 | X-LOC | EV-026 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-026) |
| WK-DMF0074-0059 | X-LOC | EV-027 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-027) |
| WK-DMF0074-0060 | X-LOC | EV-028 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-028) |
| WK-DMF0074-0061 | X-LOC | EV-029 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-029) |
| WK-DMF0074-0062 | X-LOC | EV-030 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-030) |
| WK-DMF0074-0063 | X-LOC | EV-031 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-031) |
| WK-DMF0074-0064 | X-LOC | EV-032 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-032) |
| WK-DMF0074-0065 | X-LOC | EV-033 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-033) |
| WK-DMF0074-0066 | X-LOC | EV-034 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-034) |
| WK-DMF0074-0067 | X-LOC | EV-035 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-035) |
| WK-DMF0074-0068 | X-LOC | EV-036 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-036) |
| WK-DMF0074-0069 | X-LOC | EV-037 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-037) |
| WK-DMF0074-0070 | X-LOC | EV-038 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-038) |
| WK-DMF0074-0071 | X-LOC | EV-039 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-039) |
| WK-DMF0074-0072 | X-LOC | EV-040 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-040) |
| WK-DMF0074-0073 | X-LOC | EV-041 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-041) |
| WK-DMF0074-0074 | X-LOC | EV-042 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-042) |
| WK-DMF0074-0075 | X-LOC | EV-043 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-043) |
| WK-DMF0074-0076 | X-LOC | EV-044 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-044) |
| WK-DMF0074-0077 | X-LOC | EV-045 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-045) |
| WK-DMF0074-0078 | X-LOC | EV-046 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-046) |
| WK-DMF0074-0079 | X-LOC | EV-047 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-047) |
| WK-DMF0074-0080 | X-LOC | EV-048 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-048) |
| WK-DMF0074-0081 | X-LOC | EV-049 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EV-049) |
| WK-DMF0074-0082 | X-LOC | GP-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (GP-01) |
| WK-DMF0074-0083 | X-LOC | GP-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (GP-02) |
| WK-DMF0074-0084 | X-LOC | GP-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (GP-05) |
| WK-DMF0074-0085 | X-LOC | GP-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (GP-06) |
| WK-DMF0074-0086 | X-LOC | HANDLER:DeleteButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:DeleteButton) |
| WK-DMF0074-0087 | X-LOC | HANDLER:EditButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:EditButton) |
| WK-DMF0074-0088 | X-LOC | HANDLER:ExcelButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0074-0089 | X-LOC | HANDLER:FindButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:FindButton) |
| WK-DMF0074-0090 | X-LOC | HANDLER:FindData | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:FindData) |
| WK-DMF0074-0091 | X-LOC | HANDLER:Form_Load | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:Form_Load) |
| WK-DMF0074-0092 | X-LOC | HANDLER:InsertButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:InsertButton) |
| WK-DMF0074-0093 | X-LOC | HANDLER:SaveButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:SaveButton) |
| WK-DMF0074-0094 | X-LOC | HANDLER:btmItem_Click | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:btmItem_Click) |
| WK-DMF0074-0095 | X-LOC | HANDLER:btnExcelUpload_Click | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:btnExcelUpload_Click) |
| WK-DMF0074-0096 | X-LOC | HANDLER:btnProject_Click | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:btnProject_Click) |
| WK-DMF0074-0097 | X-LOC | HANDLER:btnSPVer_Click | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:btnSPVer_Click) |
| WK-DMF0074-0098 | X-LOC | HANDLER:btnTemplate_Click | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:btnTemplate_Click) |
| WK-DMF0074-0099 | X-LOC | HANDLER:clbDivisions_SelectedIndexChange | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:clbDivisions_SelectedIndexChange) |
| WK-DMF0074-0100 | X-LOC | HANDLER:clbEndCustomer_SelectedIndexChan | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:clbEndCustomer_SelectedIndexChan) |
| WK-DMF0074-0101 | X-LOC | HANDLER:clbTeam_SelectedIndexChanged | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (HANDLER:clbTeam_SelectedIndexChanged) |
| WK-DMF0074-0102 | X-LOC | MODAL:ItemByDivisionModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MODAL:ItemByDivisionModal) |
| WK-DMF0074-0103 | X-LOC | MODAL:ProjectByDivisionModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MODAL:ProjectByDivisionModal) |
| WK-DMF0074-0104 | X-LOC | VA-08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: features/demand/src/pages/metal-link-price/components/fcst-upload-modal/FcstUploadModal.tsx 없음 |  | 1 (VA-08) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0074-0105 | H10 | DMF0074 화면 | DB(🛠️/🧯 적용 가능) | H10 FAIL 수정 — DMF0074 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: metal-link-price.constants.ts |  | 28 (E05-1 COMMON:UC-04 COMMON:UC-06 COMMON:U) |

## W4 검사기 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0074-0106 | B3 | clbDivisions / Division / Divisions | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivisions / Division / Divisions | 있음(FE 소스) | 4 (ACT:DMF0074_MetalLinkPrice.GetSpdTitle A) |

## W5 검사기 연결 (17)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0074-0107 | B4 | clbDivisions / Division / Divisions | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivisions / Division / Divisions | 있음(FE 소스) | 4 (ACT:DMF0074_MetalLinkPrice.GetSpdTitle A) |
| WK-DMF0074-0108 | F2 | DMF0074 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN DMF0074 화면 | 판단불가(대상 단위 SCREEN) | 17 (E02 E02-2 CRUD:E02:SAVE COMMON:UC-04 11 ) |
| WK-DMF0074-0109 | DB-SYN | PKG_DMF0074 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_DMF0074 | 없음(PROC_M 대응 없음) | 1 (E02-3) |
| WK-DMF0074-0110 | G4 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProject | 없음 | 1 (CT-06) |
| WK-DMF0074-0111 | G4 | btnSPVer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSPVer | 있음(FE 소스) | 1 (CT-09) |
| WK-DMF0074-0112 | G03-WIRE | DMF0074 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN DMF0074 화면 | 판단불가(대상 단위 SCREEN) | 10 (ACT:DMF0074_MetalLinkPrice..ctor ACT:DMF) |
| WK-DMF0074-0113 | G5 | DMF0074_MetalLinkPricePopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP DMF0074_MetalLinkPricePopup | 판단불가(대상 단위 POPUP) | 2 (PU-04 ACT:DMF0074_MetalLinkPrice.btnTemp) |
| WK-DMF0074-0114 | G5 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnProject | 없음 | 3 (13 IT-14 BT-04) |
| WK-DMF0074-0115 | G5 | btnSPVer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnSPVer | 있음(FE 소스) | 3 (15 IT-16 BT-06) |
| WK-DMF0074-0116 | G5 | btnTemplate | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnTemplate | 있음(FE 소스) | 3 (16 IT-17 BT-07) |
| WK-DMF0074-0117 | G5 | clbDivisions / Division / Divisions | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbDivisions / Division / Divisions | 있음(FE 소스) | 1 (ACT:DMF0074_MetalLinkPrice.btnTemplate_C) |
| WK-DMF0074-0118 | G5 | txtItemId / Model / Nickname / Item Id | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Model / Nickname / Item Id | 있음(FE 소스) | 1 (IT-15) |
| WK-DMF0074-0119 | G5 | txtProject / Project | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtProject / Project | 있음(FE 소스) | 1 (IT-14) |
| WK-DMF0074-0120 | H6 | DMF0074_MetalLinkPricePopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP DMF0074_MetalLinkPricePopup | 판단불가(대상 단위 POPUP) | 2 (PU-04 ACT:DMF0074_MetalLinkPrice.btnTemp) |
| WK-DMF0074-0121 | H6 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProject | 없음 | 3 (13 IT-14 BT-04) |
| WK-DMF0074-0122 | H6 | btnSPVer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnSPVer | 있음(FE 소스) | 3 (15 IT-16 BT-06) |
| WK-DMF0074-0123 | H6 | btnTemplate | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnTemplate | 있음(FE 소스) | 3 (16 IT-17 BT-07) |

## W6 검증 실행 (78)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0074-0124 | J2 | DMF0074 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — DMF0074 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 117 (E02 E02-1 E02-2 E02-3 E03-2 CRUD:E02:SAV) |
| WK-DMF0074-0125 | C1 | clbDivisions / Division / Divisions | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivisions / Division / Divisions · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0074_MetalLinkPrice.InitControls:) |
| WK-DMF0074-0126 | C1 | clbEndCustomer / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbEndCustomer / End Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 5 (ACT:DMF0074_MetalLinkPrice.InitControls:) |
| WK-DMF0074-0127 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0074_MetalLinkPrice.InitControls:) |
| WK-DMF0074-0128 | C1 | clbScmSite / Sales Site / Scm Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbScmSite / Sales Site / Scm Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (ACT:DMF0074_MetalLinkPrice.InitControls:) |
| WK-DMF0074-0129 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:DMF0074_MetalLinkPrice.InitControls:) |
| WK-DMF0074-0130 | G3 | DMF0074 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — DMF0074 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (COMMON:UC-04 COMMON:UC-06 COMMON:UC-07 I) |
| WK-DMF0074-0131 | K-SA | DMF0074 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — DMF0074 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (IT-09) |
| WK-DMF0074-0132 | K4 | DMF0074 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — DMF0074 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 68 (COMMON:UC-04 COMMON:UC-06 COMMON:UC-07 A) |
| WK-DMF0074-0133 | F1 | DMF0074 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — DMF0074 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 19 (E02 E02-2 CRUD:E02:SAVE COMMON:UC-04 11 ) |
| WK-DMF0074-0134 | F5 | DMF0074 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — DMF0074 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 6 (11 HANDLER:DeleteButton IT-12 BT-03 GP-0) |
| WK-DMF0074-0135 | F4 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 71 (18 IT-20 ACT:DMF0074_MetalLinkPrice.Find) |
| WK-DMF0074-0136 | F4 | PKG_DMF0074 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0074 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (E02-3) |
| WK-DMF0074-0137 | F4 | PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 68 (ACT:DMF0074_MetalLinkPrice.FindButton AC) |
| WK-DMF0074-0138 | F4 | PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 36 (ACT:DMF0074_MetalLinkPricePopup.FindButt) |
| WK-DMF0074-0139 | G4 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivisions / Division / Divisions · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 15 (CT-01 ACT:DMF0074_MetalLinkPrice.DefineP) |
| WK-DMF0074-0140 | G4 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (CT-03 ACT:DMF0074_MetalLinkPrice.InitCon) |
| WK-DMF0074-0141 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (CT-05 ACT:DMF0074_MetalLinkPrice.InitCon) |
| WK-DMF0074-0142 | G4 | clbScmSite / Sales Site / Scm Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbScmSite / Sales Site / Scm Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (CT-04 ACT:DMF0074_MetalLinkPrice.InitCon) |
| WK-DMF0074-0143 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (CT-02 ACT:DMF0074_MetalLinkPrice.InitCon) |
| WK-DMF0074-0144 | G4 | drpPeriodMonth / Plan Date / Period Mont | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriodMonth / Plan Date / Period Month · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (CT-08 ACT:DMF0074_MetalLinkPrice.InitCon) |
| WK-DMF0074-0145 | G4 | txtItemId / Model / Nickname / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (CT-07 ACT:DMF0074_MetalLinkPrice.DefineP) |
| WK-DMF0074-0146 | G4 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (CT-06 ACT:DMF0074_MetalLinkPrice.DefineP) |
| WK-DMF0074-0147 | G4 | txtVersion / Version | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtVersion / Version · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (CT-09 ACT:DMF0074_MetalLinkPrice.InitCon) |
| WK-DMF0074-0148 | H4 | DMF0074 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — DMF0074 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:DMF0074_MetalLinkPricePopup.spdMain_) |
| WK-DMF0074-0149 | H5 | clbDivisions / Division / Divisions | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbDivisions / Division / Divisions · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실 |  | 1 (IT-06) |
| WK-DMF0074-0150 | I1 | DMF0074 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — DMF0074 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 38 (E05-1 COMMON:UC-04 5 6 7 8 9 10 15 17 IT) |
| WK-DMF0074-0151 | SC1 | DMF0074 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — DMF0074 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 11 (E03-2 COMMON:UC-06 CT-01 CT-02 CT-03 CT-) |
| WK-DMF0074-0152 | D6 | DMF0074 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — DMF0074 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 5 (11 HANDLER:InsertButton IT-12 BT-03 GP-0) |
| WK-DMF0074-0153 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (E05-1 VA-03 GP-05 ACT:DMF0074_MetalLinkP) |
| WK-DMF0074-0154 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:DMF0074_MetalLinkPrice.FindData:397:) |
| WK-DMF0074-0155 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (6 9 BT-07 VA-06 VA-09 ACT:DMF0074_MetalL) |
| WK-DMF0074-0156 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (5 VA-05 ACT:DMF0074_MetalLinkPrice.FindD) |
| WK-DMF0074-0157 | E4 | MSG00137 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00137 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (VA-01 ACT:DMF0074_MetalLinkPrice.FindDat) |
| WK-DMF0074-0158 | E4 | MSG00255 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00255 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (7 15 IT-16 BT-06 PU-03 VA-07 ACT:DMF0074) |
| WK-DMF0074-0159 | E4 | MSG00265 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00265 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (COMMON:UC-04 8 17 PU-05 VA-08 ACT:DMF007) |
| WK-DMF0074-0160 | E4 | MSG00283 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00283 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (VA-02 ACT:DMF0074_MetalLinkPrice.FindDat) |
| WK-DMF0074-0161 | E4 | MSG00427 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00427 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (10 PU-04 VA-10 ACT:DMF0074_MetalLinkPric) |
| WK-DMF0074-0162 | E4 | MSG00606 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00606 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (COMMON:UC-04 PU-05) |
| WK-DMF0074-0163 | E4 | MSG00614 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00614 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (VA-03 GP-05) |
| WK-DMF0074-0164 | E4 | MSG00656 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00656 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (10 PU-04 VA-10 GP-05) |
| WK-DMF0074-0165 | E4 | MSG00659 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00659 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-04) |
| WK-DMF0074-0166 | E4 | drpPeriodMonth / Plan Date / Period Mont | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriodMonth / Plan Date / Period Month · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메 |  | 2 (ACT:DMF0074_MetalLinkPrice.FindData:387:) |
| WK-DMF0074-0167 | E4 | txtVersion / Version | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtVersion / Version · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 1 (ACT:DMF0074_MetalLinkPrice.FindData:377:) |
| WK-DMF0074-0168 | A10 | DMF0074 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — DMF0074 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 64 (ACT:DMF0074_MetalLinkPrice.DefinePropert) |
| WK-DMF0074-0169 | A6 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 67 (18 IT-20 ACT:DMF0074_MetalLinkPrice.Find) |
| WK-DMF0074-0170 | A6 | PKG_DMF0074 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0074 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (E02-3) |
| WK-DMF0074-0171 | A6 | PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회 |  | 68 (ACT:DMF0074_MetalLinkPrice.FindButton AC) |
| WK-DMF0074-0172 | A6 | PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEM | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 36 (ACT:DMF0074_MetalLinkPricePopup.FindButt) |
| WK-DMF0074-0173 | G1 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivisions / Division / Divisions · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (IT-06 CT-01 ACT:DMF0074_MetalLinkPrice.F) |
| WK-DMF0074-0174 | G1 | clbEndCustomer / End Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbEndCustomer / End Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (CT-03 ACT:DMF0074_MetalLinkPrice.FindDat) |
| WK-DMF0074-0175 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (CT-05 ACT:DMF0074_MetalLinkPrice.FindDat) |
| WK-DMF0074-0176 | G1 | clbScmSite / Sales Site / Scm Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbScmSite / Sales Site / Scm Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (CT-04 ACT:DMF0074_MetalLinkPrice.FindDat) |
| WK-DMF0074-0177 | G1 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (CT-02 ACT:DMF0074_MetalLinkPrice.FindDat) |
| WK-DMF0074-0178 | G1 | drpPeriodMonth / Plan Date / Period Mont | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriodMonth / Plan Date / Period Month · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 12 (CT-08 ACT:DMF0074_MetalLinkPrice.FindDat) |
| WK-DMF0074-0179 | G1 | txtItemId / Model / Nickname / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (CT-07 ACT:DMF0074_MetalLinkPrice.FindDat) |
| WK-DMF0074-0180 | G1 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (CT-06 ACT:DMF0074_MetalLinkPrice.FindDat) |
| WK-DMF0074-0181 | G1 | txtVersion / Version | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtVersion / Version · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (CT-09 ACT:DMF0074_MetalLinkPrice.FindDat) |
| WK-DMF0074-0182 | G6 | clbDivisions / Division / Divisions | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivisions / Division / Divisions · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 15 (CT-01 ACT:DMF0074_MetalLinkPrice.DefineP) |
| WK-DMF0074-0183 | G6 | clbEndCustomer / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbEndCustomer / End Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (CT-03 ACT:DMF0074_MetalLinkPrice.InitCon) |
| WK-DMF0074-0184 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (CT-05 ACT:DMF0074_MetalLinkPrice.InitCon) |
| WK-DMF0074-0185 | G6 | clbScmSite / Sales Site / Scm Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbScmSite / Sales Site / Scm Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (CT-04 ACT:DMF0074_MetalLinkPrice.InitCon) |
| WK-DMF0074-0186 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (CT-02 ACT:DMF0074_MetalLinkPrice.InitCon) |
| WK-DMF0074-0187 | G6 | drpPeriodMonth / Plan Date / Period Mont | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriodMonth / Plan Date / Period Month · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (CT-08 ACT:DMF0074_MetalLinkPrice.InitCon) |
| WK-DMF0074-0188 | G6 | txtItemId / Model / Nickname / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (CT-07 ACT:DMF0074_MetalLinkPrice.DefineP) |
| WK-DMF0074-0189 | G6 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (CT-06 ACT:DMF0074_MetalLinkPrice.DefineP) |
| WK-DMF0074-0190 | G6 | txtVersion / Version | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtVersion / Version · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (CT-09 ACT:DMF0074_MetalLinkPrice.InitCon) |
| WK-DMF0074-0191 | X-REOPEN | DMF0074 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0074 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 13 (ACT:DMF0074_MetalLinkPrice.Dispose ACT:D) |
| WK-DMF0074-0192 | H6 | clbDivisions / Division / Divisions | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivisions / Division / Divisions · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (ACT:DMF0074_MetalLinkPrice.btnTemplate_C) |
| WK-DMF0074-0193 | H6 | txtItemId / Model / Nickname / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (IT-15) |
| WK-DMF0074-0194 | H6 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtProject / Project · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (IT-14) |
| WK-DMF0074-0195 | M3 | DMF0074_MetalLinkPricePopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0074_MetalLinkPricePopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 14 (ACT:DMF0074_MetalLinkPricePopup..ctor AC) |
| WK-DMF0074-0196 | M4 | DMF0074_MetalLinkPricePopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0074_MetalLinkPricePopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (PU-04) |
| WK-DMF0074-0197 | M4 | btnProject | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnProject · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (13 IT-14 BT-04) |
| WK-DMF0074-0198 | M4 | btnSPVer | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnSPVer · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (15 IT-16 BT-06) |
| WK-DMF0074-0199 | M4 | btnTemplate | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnTemplate · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (16 IT-17 BT-07) |
| WK-DMF0074-0200 | M4 | txtItemId / Model / Nickname / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Nickname / Item Id · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (IT-15) |
| WK-DMF0074-0201 | M4 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (IT-14) |

## W7 기대값 확정 (334)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0074-0202 | C1 | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 20: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (20) |
| WK-DMF0074-0203 | C1 | HANDLER:clbDivisions_SelectedIndexChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbDivisions_SelectedIndexChanged: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbDivisions_SelectedIndexChange) |
| WK-DMF0074-0204 | C1 | HANDLER:clbEndCustomer_SelectedIndexChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbEndCustomer_SelectedIndexChanged: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbEndCustomer_SelectedIndexChan) |
| WK-DMF0074-0205 | C1 | HANDLER:clbTeam_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:clbTeam_SelectedIndexChanged: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:clbTeam_SelectedIndexChanged) |
| WK-DMF0074-0206 | C1 | IT-19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — IT-19: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (IT-19) |
| WK-DMF0074-0207 | B3 | DMF0074_MetalLinkPrice.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0074_MetalLinkPrice.GetDayRange: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0074_MetalLinkPrice.GetDayRange:2) |
| WK-DMF0074-0208 | B3 | DMF0074_MetalLinkPrice.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — DMF0074_MetalLinkPrice.GetSpdTitle: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0074_MetalLinkPrice.GetSpdTitle:7) |
| WK-DMF0074-0209 | B3 | EV-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — EV-011: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-011) |
| WK-DMF0074-0210 | B3 | EV-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — EV-012: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-012) |
| WK-DMF0074-0211 | B3 | EV-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — EV-013: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-013) |
| WK-DMF0074-0212 | B3 | EV-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — EV-014: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-014) |
| WK-DMF0074-0213 | B3 | EV-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — EV-015: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-015) |
| WK-DMF0074-0214 | B3 | EV-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — EV-016: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-016) |
| WK-DMF0074-0215 | B3 | EV-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — EV-017: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-017) |
| WK-DMF0074-0216 | B3 | EV-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — EV-021: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-021) |
| WK-DMF0074-0217 | B3 | EV-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — EV-030: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-030) |
| WK-DMF0074-0218 | B4 | DMF0074_MetalLinkPrice.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0074_MetalLinkPrice.GetDayRange: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0074_MetalLinkPrice.GetDayRange:2) |
| WK-DMF0074-0219 | B4 | DMF0074_MetalLinkPrice.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — DMF0074_MetalLinkPrice.GetSpdTitle: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:DMF0074_MetalLinkPrice.GetSpdTitle:7) |
| WK-DMF0074-0220 | B4 | EV-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — EV-011: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-011) |
| WK-DMF0074-0221 | B4 | EV-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — EV-012: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-012) |
| WK-DMF0074-0222 | B4 | EV-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — EV-013: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-013) |
| WK-DMF0074-0223 | B4 | EV-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — EV-014: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-014) |
| WK-DMF0074-0224 | B4 | EV-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — EV-015: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-015) |
| WK-DMF0074-0225 | B4 | EV-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — EV-016: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-016) |
| WK-DMF0074-0226 | B4 | EV-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — EV-017: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-017) |
| WK-DMF0074-0227 | B4 | EV-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — EV-021: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-021) |
| WK-DMF0074-0228 | B4 | EV-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — EV-030: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (EV-030) |
| WK-DMF0074-0229 | DB-SYN | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 1: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0074-0230 | DB-SYN | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 10: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0074-0231 | DB-SYN | DMF0074_MetalLinkPrice.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — DMF0074_MetalLinkPrice.GetDayRange: 진입점 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0074_MetalLinkPrice.GetDayRange:2) |
| WK-DMF0074-0232 | DB-SYN | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:FindButton: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindButton) |
| WK-DMF0074-0233 | DB-SYN | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:FindData: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0074-0234 | DB-SYN | IT-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — IT-11: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (IT-11) |
| WK-DMF0074-0235 | DB-SYN | VA-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — VA-01: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (VA-01) |
| WK-DMF0074-0236 | DB-SYN | VA-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — VA-02: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (VA-02) |
| WK-DMF0074-0237 | DB-SYN | VA-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — VA-03: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (VA-03) |
| WK-DMF0074-0238 | DB-SYN | VA-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — VA-05: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (VA-05) |
| WK-DMF0074-0239 | DB-SYN | VA-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — VA-06: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (VA-06) |
| WK-DMF0074-0240 | DB-SYN | VA-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — VA-09: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (VA-09) |
| WK-DMF0074-0241 | DB-SYN | VA-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — VA-10: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (VA-10) |
| WK-DMF0074-0242 | F4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 1: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0074-0243 | F4 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 10: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0074-0244 | F4 | DMF0074_MetalLinkPrice.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — DMF0074_MetalLinkPrice.GetDayRange: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0074_MetalLinkPrice.GetDayRange:2) |
| WK-DMF0074-0245 | F4 | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:FindButton: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindButton) |
| WK-DMF0074-0246 | F4 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:FindData: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0074-0247 | F4 | IT-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — IT-11: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (IT-11) |
| WK-DMF0074-0248 | F4 | VA-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — VA-01: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-01) |
| WK-DMF0074-0249 | F4 | VA-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — VA-02: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-02) |
| WK-DMF0074-0250 | F4 | VA-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — VA-03: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-03) |
| WK-DMF0074-0251 | F4 | VA-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — VA-05: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-05) |
| WK-DMF0074-0252 | F4 | VA-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — VA-06: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-06) |
| WK-DMF0074-0253 | F4 | VA-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — VA-09: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-09) |
| WK-DMF0074-0254 | F4 | VA-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — VA-10: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-10) |
| WK-DMF0074-0255 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 11요소: NOT_RUN:9 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0074-0256 | G4 | E03-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — E03-2: 행 집계 — G4 11요소: NOT_RUN:9 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (E03-2) |
| WK-DMF0074-0257 | H5 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 12: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-DMF0074-0258 | H5 | 19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 19: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (19) |
| WK-DMF0074-0259 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0074-0260 | H5 | CRUD:E02:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — CRUD:E02:SAVE: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E02:SAVE) |
| WK-DMF0074-0261 | H5 | DMF0074_MetalLinkPrice.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — DMF0074_MetalLinkPrice.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:DMF0074_MetalLinkPrice.CreateSpread:) |
| WK-DMF0074-0262 | H5 | E02-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E02-1: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E02-1) |
| WK-DMF0074-0263 | H5 | E02-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E02-2: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E02-2) |
| WK-DMF0074-0264 | H5 | ED-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — ED-01: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ED-01) |
| WK-DMF0074-0265 | H5 | ED-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — ED-05: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ED-05) |
| WK-DMF0074-0266 | H5 | ED-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — ED-07: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ED-07) |
| WK-DMF0074-0267 | H5 | IT-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — IT-13: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (IT-13) |
| WK-DMF0074-0268 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) — 그리드 편집 경로가 없 |  | 1 (COMMON:UC-02) |
| WK-DMF0074-0269 | X-REASON | COMMON:UC-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-05 Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) — 그리드에 콤보(dataMap) |  | 1 (COMMON:UC-05) |
| WK-DMF0074-0270 | X-REASON | E05-2 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E05-2 §5.2 Expression — **0건 명기** XP-00 — Expression 0건 AS-IS expressions.md 대조 0건 (조회전용 화면) 해당없음 |  | 1 (E05-2) |
| WK-DMF0074-0271 | X-REASON | E06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E06 §6 ② User 관점 변환 요지 (시트 5 반영용) 사용자 관점 요지 — UI분석서 v1.0 시트5 반영분 분석 문서 서술 절(구현 대상 아님) 해당없음 |  | 1 (E06) |
| WK-DMF0074-0272 | X-REASON | E06-1 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E06-1 §6.1 화면 성격 §6.1 화면 성격 — 조회전용 + 엑셀 업로드 단일 수정경로 동상 해당없음 |  | 1 (E06-1) |
| WK-DMF0074-0273 | X-REASON | E06-2 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E06-2 §6.2 조회 §6.2 조회 서술 — CT/VA 축이 구현 근거 보유 동상 해당없음 |  | 1 (E06-2) |
| WK-DMF0074-0274 | X-REASON | E06-3 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E06-3 §6.3 템플릿 다운로드 · 업로드 §6.3 템플릿·업로드 서술 — PU-04/PU-05 가 구현 근거 보유 동상 해당없음 |  | 1 (E06-3) |
| WK-DMF0074-0275 | X-REASON | ED-04 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — ED-04 §2.1 EDIT_FLAG/ADMIN/시간락 — 이 화면에는 없음 — DMF0044 류 행별 EDIT_FLAG·현재월 게이트가 AS-IS·TO-BE 모두 부재 — 만들면 오구현 해당없음 |  | 1 (ED-04) |
| WK-DMF0074-0276 | X-REASON | GP-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — GP-03 standalone SP 5종 INVALID — 정본은 PKG_DMF0074 이관 패키지 제외 명시 (_deploy_packages/DMF0074_CLOUD_20260818/_README. |  | 1 (GP-03) |
| WK-DMF0074-0277 | X-REASON | GP-04 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — GP-04 MD 줄수 오기 정정(.cs 물리 760줄) 분석 md 각주 반영 완료 문서 사항 해당없음 |  | 1 (GP-04) |
| WK-DMF0074-0278 | X-REASON | MODAL:ShowDialog | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:ShowDialog AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 — AS-IS 코드의 `ShowDialog()` 호출문(WinForms 모달 표시 API)이 팝업 |  | 1 (MODAL:ShowDialog) |
| WK-DMF0074-0279 | X-REASON | VA-04 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — VA-04 FindData MSG00049 — 날짜 형식 오류(사내 미등록) — TO-BE 월 피커(PeriodField)가 비정형 입력을 원천 차단 → 도달 불가. 사내 MSG_M 미등록이 정상 해 |  | 1 (VA-04) |
| WK-DMF0074-0280 | X-REASON | XP-00 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — XP-00 Expression 0건 명기 — SetValue Auto-Sync/조건부 LockRange 없음 — expressions.md 대조 결과 0건. 조회 후 일괄 LockColumn/Smar |  | 1 (XP-00) |
| WK-DMF0074-0281 | E4 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 10: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0074-0282 | E4 | BT-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — BT-01: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (BT-01) |
| WK-DMF0074-0283 | E4 | DMF0074_MetalLinkPrice.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — DMF0074_MetalLinkPrice.SetChangeControl: 진입점 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 20 (ACT:DMF0074_MetalLinkPrice.SetChangeCont) |
| WK-DMF0074-0284 | E4 | E05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — E05: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (E05) |
| WK-DMF0074-0285 | E4 | ED-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — ED-07: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (ED-07) |
| WK-DMF0074-0286 | E4 | EV-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-001: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-001) |
| WK-DMF0074-0287 | E4 | EV-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-002: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-002) |
| WK-DMF0074-0288 | E4 | EV-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-003: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-003) |
| WK-DMF0074-0289 | E4 | EV-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-004: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-004) |
| WK-DMF0074-0290 | E4 | EV-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-005: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-005) |
| WK-DMF0074-0291 | E4 | EV-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-006: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-006) |
| WK-DMF0074-0292 | E4 | EV-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-007: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-007) |
| WK-DMF0074-0293 | E4 | EV-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-008: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-008) |
| WK-DMF0074-0294 | E4 | EV-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-009: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-009) |
| WK-DMF0074-0295 | E4 | EV-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-010: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-010) |
| WK-DMF0074-0296 | E4 | EV-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-011: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-011) |
| WK-DMF0074-0297 | E4 | EV-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-012: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-012) |
| WK-DMF0074-0298 | E4 | EV-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-013: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-013) |
| WK-DMF0074-0299 | E4 | EV-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-014: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-014) |
| WK-DMF0074-0300 | E4 | EV-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-015: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-015) |
| WK-DMF0074-0301 | E4 | EV-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-016: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-016) |
| WK-DMF0074-0302 | E4 | EV-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-017: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-017) |
| WK-DMF0074-0303 | E4 | EV-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-018: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-018) |
| WK-DMF0074-0304 | E4 | EV-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-019: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-019) |
| WK-DMF0074-0305 | E4 | EV-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-020: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-020) |
| WK-DMF0074-0306 | E4 | EV-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-021: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-021) |
| WK-DMF0074-0307 | E4 | EV-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-022: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-022) |
| WK-DMF0074-0308 | E4 | EV-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-023: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-023) |
| WK-DMF0074-0309 | E4 | EV-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-024: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-024) |
| WK-DMF0074-0310 | E4 | EV-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-025: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-025) |
| WK-DMF0074-0311 | E4 | EV-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-026: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-026) |
| WK-DMF0074-0312 | E4 | EV-027 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-027: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-027) |
| WK-DMF0074-0313 | E4 | EV-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-028: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-028) |
| WK-DMF0074-0314 | E4 | EV-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-029: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-029) |
| WK-DMF0074-0315 | E4 | EV-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-030: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-030) |
| WK-DMF0074-0316 | E4 | EV-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-031: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-031) |
| WK-DMF0074-0317 | E4 | EV-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-032: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-032) |
| WK-DMF0074-0318 | E4 | EV-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-033: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-033) |
| WK-DMF0074-0319 | E4 | EV-034 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-034: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-034) |
| WK-DMF0074-0320 | E4 | EV-035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-035: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-035) |
| WK-DMF0074-0321 | E4 | EV-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-036: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-036) |
| WK-DMF0074-0322 | E4 | EV-037 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-037: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-037) |
| WK-DMF0074-0323 | E4 | EV-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-038: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-038) |
| WK-DMF0074-0324 | E4 | EV-039 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-039: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-039) |
| WK-DMF0074-0325 | E4 | EV-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-040: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-040) |
| WK-DMF0074-0326 | E4 | EV-041 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-041: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-041) |
| WK-DMF0074-0327 | E4 | EV-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-042: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-042) |
| WK-DMF0074-0328 | E4 | EV-043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-043: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-043) |
| WK-DMF0074-0329 | E4 | EV-044 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-044: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-044) |
| WK-DMF0074-0330 | E4 | EV-045 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-045: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-045) |
| WK-DMF0074-0331 | E4 | EV-046 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-046: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-046) |
| WK-DMF0074-0332 | E4 | EV-047 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-047: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-047) |
| WK-DMF0074-0333 | E4 | EV-048 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-048: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-048) |
| WK-DMF0074-0334 | E4 | EV-049 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — EV-049: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (EV-049) |
| WK-DMF0074-0335 | E4 | IT-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — IT-11: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (IT-11) |
| WK-DMF0074-0336 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 4요소: REVIEW:4 |  | 0 () |
| WK-DMF0074-0337 | A1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 10: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (10) |
| WK-DMF0074-0338 | A1 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 16: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (16) |
| WK-DMF0074-0339 | A1 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 17: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (17) |
| WK-DMF0074-0340 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (8) |
| WK-DMF0074-0341 | A1 | BT-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — BT-01: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (BT-01) |
| WK-DMF0074-0342 | A1 | BT-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — BT-07: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (BT-07) |
| WK-DMF0074-0343 | A1 | BT-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — BT-08: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (BT-08) |
| WK-DMF0074-0344 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (COMMON:UC-07) |
| WK-DMF0074-0345 | A1 | CT-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CT-01: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (CT-01) |
| WK-DMF0074-0346 | A1 | CT-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CT-02: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (CT-02) |
| WK-DMF0074-0347 | A1 | CT-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CT-03: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (CT-03) |
| WK-DMF0074-0348 | A1 | CT-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CT-04: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (CT-04) |
| WK-DMF0074-0349 | A1 | CT-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CT-05: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (CT-05) |
| WK-DMF0074-0350 | A1 | CT-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CT-06: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (CT-06) |
| WK-DMF0074-0351 | A1 | CT-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CT-07: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (CT-07) |
| WK-DMF0074-0352 | A1 | CT-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CT-08: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (CT-08) |
| WK-DMF0074-0353 | A1 | CT-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CT-09: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (CT-09) |
| WK-DMF0074-0354 | A1 | E03-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E03-2: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (E03-2) |
| WK-DMF0074-0355 | A1 | ED-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ED-01: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (ED-01) |
| WK-DMF0074-0356 | A1 | GP-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GP-02: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (GP-02) |
| WK-DMF0074-0357 | A1 | GP-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GP-08: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (GP-08) |
| WK-DMF0074-0358 | A1 | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindButton: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (HANDLER:FindButton) |
| WK-DMF0074-0359 | A1 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindData: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (HANDLER:FindData) |
| WK-DMF0074-0360 | A1 | IT-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — IT-03: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (IT-03) |
| WK-DMF0074-0361 | A1 | IT-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — IT-06: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (IT-06) |
| WK-DMF0074-0362 | A1 | IT-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — IT-09: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (IT-09) |
| WK-DMF0074-0363 | A1 | IT-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — IT-11: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (IT-11) |
| WK-DMF0074-0364 | A1 | IT-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — IT-18: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (IT-18) |
| WK-DMF0074-0365 | A1 | PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE — 팝업·보조 SP 는 |  | 67 (18 IT-20 ACT:DMF0074_MetalLinkPrice.Find) |
| WK-DMF0074-0366 | A1 | PKG_DMF0074 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0074: 골든 비교 케이스 없음(PKG_DMF0074 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 4 (E02-3 COMMON:UC-06 GP-06 EV-009) |
| WK-DMF0074-0367 | A1 | PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE: 골든 비교 케이스 없음(PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE — 팝업·보조 SP 는 golde |  | 68 (ACT:DMF0074_MetalLinkPrice.FindButton AC) |
| WK-DMF0074-0368 | A1 | PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEM | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE: 골든 비교 케이스 없음(PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE — 팝업·보조 SP 는 |  | 36 (ACT:DMF0074_MetalLinkPricePopup.FindButt) |
| WK-DMF0074-0369 | A1 | PU-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PU-04: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (PU-04) |
| WK-DMF0074-0370 | A1 | PU-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PU-05: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (PU-05) |
| WK-DMF0074-0371 | A1 | VA-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — VA-01: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (VA-01) |
| WK-DMF0074-0372 | A1 | VA-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — VA-02: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (VA-02) |
| WK-DMF0074-0373 | A1 | VA-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — VA-03: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (VA-03) |
| WK-DMF0074-0374 | A1 | VA-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — VA-05: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (VA-05) |
| WK-DMF0074-0375 | A1 | VA-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — VA-06: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (VA-06) |
| WK-DMF0074-0376 | A1 | VA-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — VA-08: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (VA-08) |
| WK-DMF0074-0377 | A1 | VA-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — VA-09: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (VA-09) |
| WK-DMF0074-0378 | A1 | VA-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — VA-10: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (VA-10) |
| WK-DMF0074-0379 | A6 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 1: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0074-0380 | A6 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 10: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0074-0381 | A6 | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — HANDLER:FindButton: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindButton) |
| WK-DMF0074-0382 | A6 | HANDLER:FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — HANDLER:FindData: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindData) |
| WK-DMF0074-0383 | A6 | IT-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — IT-11: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (IT-11) |
| WK-DMF0074-0384 | A6 | VA-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — VA-01: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-01) |
| WK-DMF0074-0385 | A6 | VA-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — VA-02: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-02) |
| WK-DMF0074-0386 | A6 | VA-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — VA-03: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-03) |
| WK-DMF0074-0387 | A6 | VA-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — VA-05: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-05) |
| WK-DMF0074-0388 | A6 | VA-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — VA-06: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-06) |
| WK-DMF0074-0389 | A6 | VA-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — VA-09: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-09) |
| WK-DMF0074-0390 | A6 | VA-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — VA-10: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VA-10) |
| WK-DMF0074-0391 | G1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 10: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-DMF0074-0392 | G1 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 16: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (16) |
| WK-DMF0074-0393 | G1 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 17: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (17) |
| WK-DMF0074-0394 | G1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 8: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-DMF0074-0395 | G1 | BT-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — BT-01: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (BT-01) |
| WK-DMF0074-0396 | G1 | BT-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — BT-07: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (BT-07) |
| WK-DMF0074-0397 | G1 | BT-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — BT-08: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (BT-08) |
| WK-DMF0074-0398 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0074-0399 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-DMF0074-0400 | G1 | E02-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E02-3: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E02-3) |
| WK-DMF0074-0401 | G1 | E03-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E03-2: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E03-2) |
| WK-DMF0074-0402 | G1 | ED-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ED-01: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (ED-01) |
| WK-DMF0074-0403 | G1 | EV-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — EV-009: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (EV-009) |
| WK-DMF0074-0404 | G1 | GP-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — GP-02: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (GP-02) |
| WK-DMF0074-0405 | G1 | GP-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — GP-06: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (GP-06) |
| WK-DMF0074-0406 | G1 | GP-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — GP-08: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (GP-08) |
| WK-DMF0074-0407 | G1 | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — HANDLER:FindButton: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindButton) |
| WK-DMF0074-0408 | G1 | IT-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — IT-03: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (IT-03) |
| WK-DMF0074-0409 | G1 | IT-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — IT-09: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (IT-09) |
| WK-DMF0074-0410 | G1 | IT-11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — IT-11: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (IT-11) |
| WK-DMF0074-0411 | G1 | IT-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — IT-18: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (IT-18) |
| WK-DMF0074-0412 | G1 | PU-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — PU-04: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (PU-04) |
| WK-DMF0074-0413 | G1 | PU-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — PU-05: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (PU-05) |
| WK-DMF0074-0414 | G1 | VA-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — VA-08: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (VA-08) |
| WK-DMF0074-0415 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-DMF0074-0416 | G6 | E03-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — E03-2: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (E03-2) |
| WK-DMF0074-0417 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-DMF0074-0418 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-DMF0074-0419 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-DMF0074-0420 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-DMF0074-0421 | X-ROW | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (1) |
| WK-DMF0074-0422 | X-ROW | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (2) |
| WK-DMF0074-0423 | X-ROW | 21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 21: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (21) |
| WK-DMF0074-0424 | X-ROW | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (3) |
| WK-DMF0074-0425 | X-ROW | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (4) |
| WK-DMF0074-0426 | X-ROW | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0074-0427 | X-ROW | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0074-0428 | X-ROW | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 7: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0074-0429 | X-ROW | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 8: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0074-0430 | X-ROW | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 9: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-DMF0074-0431 | X-ROW | BT-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BT-02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BT-02) |
| WK-DMF0074-0432 | X-ROW | DMF0074_MetalLinkPrice.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0074_MetalLinkPrice.CreateSpread) |
| WK-DMF0074-0433 | X-ROW | DMF0074_MetalLinkPrice.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.DefineProperty: 진입점 집계 8검사 — NOT_RUN:7 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0074_MetalLinkPrice.DefinePropert) |
| WK-DMF0074-0434 | X-ROW | DMF0074_MetalLinkPrice.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된  |  | 15 (ACT:DMF0074_MetalLinkPrice.ExcelButton A) |
| WK-DMF0074-0435 | X-ROW | DMF0074_MetalLinkPrice.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:DMF0074_MetalLinkPrice.FindButton) |
| WK-DMF0074-0436 | X-ROW | DMF0074_MetalLinkPrice.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.FindData: 진입점 집계 27검사 — NOT_RUN:23 · REVIEW:2 · PASS:2 |  | 8 (ACT:DMF0074_MetalLinkPrice.FindData:363:) |
| WK-DMF0074-0437 | X-ROW | DMF0074_MetalLinkPrice.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0074_MetalLinkPrice.Form_Load) |
| WK-DMF0074-0438 | X-ROW | DMF0074_MetalLinkPrice.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.GetDayRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0074_MetalLinkPrice.GetDayRange) |
| WK-DMF0074-0439 | X-ROW | DMF0074_MetalLinkPrice.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.InitControls: 진입점 집계 22검사 — NOT_RUN:22 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0074_MetalLinkPrice.InitControls:) |
| WK-DMF0074-0440 | X-ROW | DMF0074_MetalLinkPrice.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0074_MetalLinkPrice.InitSpread) |
| WK-DMF0074-0441 | X-ROW | DMF0074_MetalLinkPrice.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.SetChangeControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:DMF0074_MetalLinkPrice.SetChangeCont) |
| WK-DMF0074-0442 | X-ROW | DMF0074_MetalLinkPrice.btmItem_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.btmItem_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0074_MetalLinkPrice.btmItem_Click) |
| WK-DMF0074-0443 | X-ROW | DMF0074_MetalLinkPrice.btnExcelUpload_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.btnExcelUpload_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0074_MetalLinkPrice.btnExcelUploa) |
| WK-DMF0074-0444 | X-ROW | DMF0074_MetalLinkPrice.btnProject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.btnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0074_MetalLinkPrice.btnProject_Cl) |
| WK-DMF0074-0445 | X-ROW | DMF0074_MetalLinkPrice.btnSPVer_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.btnSPVer_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0074_MetalLinkPrice.btnSPVer_Clic) |
| WK-DMF0074-0446 | X-ROW | DMF0074_MetalLinkPrice.btnTemplate_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.btnTemplate_Click: 진입점 집계 6검사 — NOT_RUN:3 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0074_MetalLinkPrice.btnTemplate_C) |
| WK-DMF0074-0447 | X-ROW | DMF0074_MetalLinkPrice.clbDivisions_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.clbDivisions_SelectedIndexC: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0074_MetalLinkPrice.clbDivisions_) |
| WK-DMF0074-0448 | X-ROW | DMF0074_MetalLinkPrice.clbEndCustomer_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.clbEndCustomer_SelectedInde: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0074_MetalLinkPrice.clbEndCustome) |
| WK-DMF0074-0449 | X-ROW | DMF0074_MetalLinkPrice.clbTeam_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.clbTeam_SelectedIndexChange: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:DMF0074_MetalLinkPrice.clbTeam_Selec) |
| WK-DMF0074-0450 | X-ROW | DMF0074_MetalLinkPrice.txtItemId_KeyDown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.txtItemId_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:DMF0074_MetalLinkPrice.txtItemId_Key) |
| WK-DMF0074-0451 | X-ROW | DMF0074_MetalLinkPrice.txtProject_KeyDow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPrice.txtProject_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:DMF0074_MetalLinkPrice.txtProject_Ke) |
| WK-DMF0074-0452 | X-ROW | DMF0074_MetalLinkPricePopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0074_MetalLinkPricePopup..ctor:68) |
| WK-DMF0074-0453 | X-ROW | DMF0074_MetalLinkPricePopup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0074_MetalLinkPricePopup.CreateSp) |
| WK-DMF0074-0454 | X-ROW | DMF0074_MetalLinkPricePopup.DefineProper | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0074_MetalLinkPricePopup.DefinePr) |
| WK-DMF0074-0455 | X-ROW | DMF0074_MetalLinkPricePopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0074_MetalLinkPricePopup.Dispose:) |
| WK-DMF0074-0456 | X-ROW | DMF0074_MetalLinkPricePopup.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.ExcelButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 15 (ACT:DMF0074_MetalLinkPricePopup.ExcelBut) |
| WK-DMF0074-0457 | X-ROW | DMF0074_MetalLinkPricePopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:DMF0074_MetalLinkPricePopup.FindButt) |
| WK-DMF0074-0458 | X-ROW | DMF0074_MetalLinkPricePopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.FindData: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:1 · PASS:1 |  | 33 (ACT:DMF0074_MetalLinkPricePopup.FindData) |
| WK-DMF0074-0459 | X-ROW | DMF0074_MetalLinkPricePopup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:DMF0074_MetalLinkPricePopup.Form_Loa) |
| WK-DMF0074-0460 | X-ROW | DMF0074_MetalLinkPricePopup.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.GetSpdTitle: 진입점 집계 6검사 — NOT_RUN:3 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:DMF0074_MetalLinkPricePopup.GetSpdTi) |
| WK-DMF0074-0461 | X-ROW | DMF0074_MetalLinkPricePopup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.InitControls: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0074_MetalLinkPricePopup.InitCont) |
| WK-DMF0074-0462 | X-ROW | DMF0074_MetalLinkPricePopup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.InitSpread: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0074_MetalLinkPricePopup.InitSpre) |
| WK-DMF0074-0463 | X-ROW | DMF0074_MetalLinkPricePopup.btnButtonLis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.btnButtonList_UsrButto: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 10 (ACT:DMF0074_MetalLinkPricePopup.btnButto) |
| WK-DMF0074-0464 | X-ROW | DMF0074_MetalLinkPricePopup.mOK | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.mOK: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0074_MetalLinkPricePopup.mOK ACT:) |
| WK-DMF0074-0465 | X-ROW | DMF0074_MetalLinkPricePopup.spdMain_TopC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0074_MetalLinkPricePopup.spdMain_TopChange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0074_MetalLinkPricePopup.spdMain_) |
| WK-DMF0074-0466 | X-ROW | E01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E01) |
| WK-DMF0074-0467 | X-ROW | E03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E03) |
| WK-DMF0074-0468 | X-ROW | E03-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E03-1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E03-1) |
| WK-DMF0074-0469 | X-ROW | E07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E07) |
| WK-DMF0074-0470 | X-ROW | GP-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GP-01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (GP-01) |
| WK-DMF0074-0471 | X-ROW | GP-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GP-09: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (GP-09) |
| WK-DMF0074-0472 | X-ROW | HANDLER:ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:ExcelButton) |
| WK-DMF0074-0473 | X-ROW | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:Form_Load: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:Form_Load) |
| WK-DMF0074-0474 | X-ROW | HANDLER:btmItem_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btmItem_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btmItem_Click) |
| WK-DMF0074-0475 | X-ROW | HANDLER:btnExcelUpload_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnExcelUpload_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnExcelUpload_Click) |
| WK-DMF0074-0476 | X-ROW | HANDLER:btnProject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnProject_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnProject_Click) |
| WK-DMF0074-0477 | X-ROW | HANDLER:btnSPVer_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnSPVer_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnSPVer_Click) |
| WK-DMF0074-0478 | X-ROW | HANDLER:btnTemplate_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:btnTemplate_Click: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:btnTemplate_Click) |
| WK-DMF0074-0479 | X-ROW | HANDLER:txtItemId_KeyDown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:txtItemId_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:txtItemId_KeyDown) |
| WK-DMF0074-0480 | X-ROW | HANDLER:txtProject_KeyDown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:txtProject_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:txtProject_KeyDown) |
| WK-DMF0074-0481 | X-ROW | IT-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — IT-01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (IT-01) |
| WK-DMF0074-0482 | X-ROW | IT-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — IT-02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (IT-02) |
| WK-DMF0074-0483 | X-ROW | IT-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — IT-07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (IT-07) |
| WK-DMF0074-0484 | X-ROW | IT-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — IT-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (IT-08) |
| WK-DMF0074-0485 | G5 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 10: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-DMF0074-0486 | G5 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 14: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (14) |
| WK-DMF0074-0487 | G5 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 9: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-DMF0074-0488 | G5 | BT-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — BT-05: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (BT-05) |
| WK-DMF0074-0489 | G5 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — E04: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0074-0490 | G5 | IT-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — IT-09: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (IT-09) |
| WK-DMF0074-0491 | G5 | IT-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — IT-10: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (IT-10) |
| WK-DMF0074-0492 | G5 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-DMF0074-0493 | G5 | MODAL:MetalLinkTemplateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:MetalLinkTemplateModal: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MetalLinkTemplateModal) |
| WK-DMF0074-0494 | G5 | MODAL:MetalLinkVersionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:MetalLinkVersionModal: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MetalLinkVersionModal) |
| WK-DMF0074-0495 | G5 | MODAL:ProjectByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ProjectByDivisionModal: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ProjectByDivisionModal) |
| WK-DMF0074-0496 | G5 | PU-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — PU-01: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (PU-01) |
| WK-DMF0074-0497 | G5 | PU-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — PU-02: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (PU-02) |
| WK-DMF0074-0498 | G5 | PU-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — PU-03: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (PU-03) |
| WK-DMF0074-0499 | G5 | PU-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — PU-05: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (PU-05) |
| WK-DMF0074-0500 | G5 | VA-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — VA-09: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (VA-09) |
| WK-DMF0074-0501 | G5 | VA-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — VA-10: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (VA-10) |
| WK-DMF0074-0502 | H6 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 10: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-DMF0074-0503 | H6 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 14: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (14) |
| WK-DMF0074-0504 | H6 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 9: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-DMF0074-0505 | H6 | BT-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — BT-05: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (BT-05) |
| WK-DMF0074-0506 | H6 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — E04: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0074-0507 | H6 | IT-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — IT-09: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (IT-09) |
| WK-DMF0074-0508 | H6 | IT-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — IT-10: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (IT-10) |
| WK-DMF0074-0509 | H6 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-DMF0074-0510 | H6 | MODAL:MetalLinkTemplateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:MetalLinkTemplateModal: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MetalLinkTemplateModal) |
| WK-DMF0074-0511 | H6 | MODAL:MetalLinkVersionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:MetalLinkVersionModal: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MetalLinkVersionModal) |
| WK-DMF0074-0512 | H6 | MODAL:ProjectByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ProjectByDivisionModal: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ProjectByDivisionModal) |
| WK-DMF0074-0513 | H6 | PU-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — PU-01: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (PU-01) |
| WK-DMF0074-0514 | H6 | PU-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — PU-02: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (PU-02) |
| WK-DMF0074-0515 | H6 | PU-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — PU-03: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (PU-03) |
| WK-DMF0074-0516 | H6 | PU-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — PU-05: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (PU-05) |
| WK-DMF0074-0517 | H6 | VA-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — VA-09: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (VA-09) |
| WK-DMF0074-0518 | H6 | VA-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — VA-10: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (VA-10) |
| WK-DMF0074-0519 | M4 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 10: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-DMF0074-0520 | M4 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 14: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (14) |
| WK-DMF0074-0521 | M4 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 9: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-DMF0074-0522 | M4 | BT-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — BT-05: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (BT-05) |
| WK-DMF0074-0523 | M4 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — E04: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-DMF0074-0524 | M4 | IT-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — IT-09: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (IT-09) |
| WK-DMF0074-0525 | M4 | IT-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — IT-10: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (IT-10) |
| WK-DMF0074-0526 | M4 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-DMF0074-0527 | M4 | MODAL:MetalLinkTemplateModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:MetalLinkTemplateModal: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MetalLinkTemplateModal) |
| WK-DMF0074-0528 | M4 | MODAL:MetalLinkVersionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:MetalLinkVersionModal: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:MetalLinkVersionModal) |
| WK-DMF0074-0529 | M4 | MODAL:ProjectByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ProjectByDivisionModal: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ProjectByDivisionModal) |
| WK-DMF0074-0530 | M4 | PU-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — PU-01: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (PU-01) |
| WK-DMF0074-0531 | M4 | PU-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — PU-02: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (PU-02) |
| WK-DMF0074-0532 | M4 | PU-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — PU-03: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (PU-03) |
| WK-DMF0074-0533 | M4 | PU-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — PU-05: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (PU-05) |
| WK-DMF0074-0534 | M4 | VA-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — VA-09: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (VA-09) |
| WK-DMF0074-0535 | M4 | VA-10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — VA-10: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (VA-10) |
