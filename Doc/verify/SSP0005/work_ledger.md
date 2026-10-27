# 작업 원장 — SSP0005 · 2026-10-26 12:55

> 검사 인스턴스 412건 중 PASS·NA 50건 외 **362건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 75 | 구현 위치 실존 |
| W4 | 검사기 구현 | 4 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 9 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 65 | 실행 → PASS |
| W7 | 기대값 확정 | 209 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 188 · 대조표 96 · E2E 65 · 하네스 13
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 75 |  |  |  |  | 15 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 43 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-REASON | DESIGN |  |  |  |  |  |  | 21 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | GEN |  |  |  |  |  |  | 20 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| E4 | EDIT |  |  |  |  |  | 14 | 5 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G1 | GEN |  |  |  |  |  | 3 | 13 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| B4 | COMBO |  |  |  |  | 4 |  | 8 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| H2 | DESIGN |  |  |  |  |  | 2 | 10 |  |  | 배경·글자색 규칙 |
| B3 | COMBO |  |  |  | 4 |  |  | 7 |  |  | 콤보 후보 정렬 = AS-IS |
| A5 | DESIGN |  |  |  |  |  | 1 | 10 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| D4 | EDIT |  |  |  |  |  | 1 | 10 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| D3 | EDIT |  |  |  |  |  | 2 | 8 |  |  | 행 값 기반 조건부 잠금 |
| G4 | DESIGN |  |  |  |  | 1 | 5 | 3 |  |  | 조회조건 표시·라벨·활성 |
| D1 | EDIT |  |  |  |  |  | 2 | 7 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| G6 | GEN |  |  |  |  |  | 5 | 4 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F4 | DB |  |  |  |  |  | 5 | 3 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| C3 | CASCADE |  |  |  |  |  | 3 | 4 |  |  | 연쇄 자동 채움 |
| H5 | DESIGN |  |  |  |  |  | 1 | 6 |  |  | 라벨 명칭 |
| C1 | CASCADE |  |  |  |  |  | 4 | 2 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| A6 | GEN |  |  |  |  |  | 4 | 2 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| DB-SYN | DB |  |  |  |  | 2 |  | 3 |  |  | BE 계정 시노님·권한·대상 객체 |
| D5 | EDIT |  |  |  |  |  | 1 | 3 |  |  | 셀 에디터 유형 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| SC1 | DESIGN |  |  |  |  |  |  | 1 |  |  | 조회조건 순서 = 기준표 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |

## W2 구현 위치 확인 (75)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0001 | X-LOC | A01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A01) |
| WK-SSP0005-0002 | X-LOC | A02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A02) |
| WK-SSP0005-0003 | X-LOC | A03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A03) |
| WK-SSP0005-0004 | X-LOC | A04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A04) |
| WK-SSP0005-0005 | X-LOC | A10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A10) |
| WK-SSP0005-0006 | X-LOC | A11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A11) |
| WK-SSP0005-0007 | X-LOC | A13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A13) |
| WK-SSP0005-0008 | X-LOC | A14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A14) |
| WK-SSP0005-0009 | X-LOC | A15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A15) |
| WK-SSP0005-0010 | X-LOC | A16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A16) |
| WK-SSP0005-0011 | X-LOC | A17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (A17) |
| WK-SSP0005-0012 | X-LOC | C01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C01) |
| WK-SSP0005-0013 | X-LOC | C02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C02) |
| WK-SSP0005-0014 | X-LOC | C03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C03) |
| WK-SSP0005-0015 | X-LOC | C04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C04) |
| WK-SSP0005-0016 | X-LOC | C05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C05) |
| WK-SSP0005-0017 | X-LOC | C06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C06) |
| WK-SSP0005-0018 | X-LOC | C07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C07) |
| WK-SSP0005-0019 | X-LOC | C08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C08) |
| WK-SSP0005-0020 | X-LOC | C09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C09) |
| WK-SSP0005-0021 | X-LOC | C12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C12) |
| WK-SSP0005-0022 | X-LOC | C13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C13) |
| WK-SSP0005-0023 | X-LOC | C14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C14) |
| WK-SSP0005-0024 | X-LOC | C15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C15) |
| WK-SSP0005-0025 | X-LOC | C16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C16) |
| WK-SSP0005-0026 | X-LOC | C17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C17) |
| WK-SSP0005-0027 | X-LOC | C18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C18) |
| WK-SSP0005-0028 | X-LOC | C19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C19) |
| WK-SSP0005-0029 | X-LOC | D01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D01) |
| WK-SSP0005-0030 | X-LOC | D02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D02) |
| WK-SSP0005-0031 | X-LOC | D03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D03) |
| WK-SSP0005-0032 | X-LOC | D04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D04) |
| WK-SSP0005-0033 | X-LOC | D05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D05) |
| WK-SSP0005-0034 | X-LOC | D06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D06) |
| WK-SSP0005-0035 | X-LOC | D07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D07) |
| WK-SSP0005-0036 | X-LOC | E01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E01) |
| WK-SSP0005-0037 | X-LOC | E05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E05) |
| WK-SSP0005-0038 | X-LOC | G01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G01) |
| WK-SSP0005-0039 | X-LOC | G02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G02) |
| WK-SSP0005-0040 | X-LOC | G03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G03) |
| WK-SSP0005-0041 | X-LOC | G04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G04) |
| WK-SSP0005-0042 | X-LOC | G05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G05) |
| WK-SSP0005-0043 | X-LOC | G06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G06) |
| WK-SSP0005-0044 | X-LOC | G07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G07) |
| WK-SSP0005-0045 | X-LOC | G08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G08) |
| WK-SSP0005-0046 | X-LOC | G10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G10) |
| WK-SSP0005-0047 | X-LOC | G11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G11) |
| WK-SSP0005-0048 | X-LOC | G13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G13) |
| WK-SSP0005-0049 | X-LOC | G14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G14) |
| WK-SSP0005-0050 | X-LOC | G17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G17) |
| WK-SSP0005-0051 | X-LOC | G18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G18) |
| WK-SSP0005-0052 | X-LOC | G19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G19) |
| WK-SSP0005-0053 | X-LOC | G20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G20) |
| WK-SSP0005-0054 | X-LOC | G21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G21) |
| WK-SSP0005-0055 | X-LOC | GC01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (GC01) |
| WK-SSP0005-0056 | X-LOC | P01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P01) |
| WK-SSP0005-0057 | X-LOC | P02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P02) |
| WK-SSP0005-0058 | X-LOC | P03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P03) |
| WK-SSP0005-0059 | X-LOC | P04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P04) |
| WK-SSP0005-0060 | X-LOC | P05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P05) |
| WK-SSP0005-0061 | X-LOC | P06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P06) |
| WK-SSP0005-0062 | X-LOC | P07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P07) |
| WK-SSP0005-0063 | X-LOC | P10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P10) |
| WK-SSP0005-0064 | X-LOC | S01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S01) |
| WK-SSP0005-0065 | X-LOC | S02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S02) |
| WK-SSP0005-0066 | X-LOC | S03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S03) |
| WK-SSP0005-0067 | X-LOC | S04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S04) |
| WK-SSP0005-0068 | X-LOC | U01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (U01) |
| WK-SSP0005-0069 | X-LOC | U02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (U02) |
| WK-SSP0005-0070 | X-LOC | V01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V01) |
| WK-SSP0005-0071 | X-LOC | V02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V02) |
| WK-SSP0005-0072 | X-LOC | V03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V03) |
| WK-SSP0005-0073 | X-LOC | V04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V04) |
| WK-SSP0005-0074 | X-LOC | V05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V05) |
| WK-SSP0005-0075 | X-LOC | V06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V06) |

## W4 검사기 구현 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0076 | B3 | COLUMN_NAME | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 COLUMN_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0005_ShipmentWorkingDay.GetDayOfW) |
| WK-SSP0005-0077 | B3 | DAY_CODE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DAY_CODE | 있음(FE 소스) | 2 (ACT:SSP0005_ShipmentWorkingDay.GetDayOfW) |
| WK-SSP0005-0078 | B3 | cboDayWeek / Day of the week / Day Week | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDayWeek / Day of the week / Day Week | 있음(FE 소스) | 1 (C16) |
| WK-SSP0005-0079 | B3 | drpPeriod / Period | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 drpPeriod / Period | 있음(FE 소스) | 4 (ACT:SSP0005_ShipmentWorkingDay.GetSpdTit) |

## W5 검사기 연결 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0080 | B4 | COLUMN_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL COLUMN_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0005_ShipmentWorkingDay.GetDayOfW) |
| WK-SSP0005-0081 | B4 | DAY_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DAY_CODE | 있음(FE 소스) | 2 (ACT:SSP0005_ShipmentWorkingDay.GetDayOfW) |
| WK-SSP0005-0082 | B4 | cboDayWeek / Day of the week / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDayWeek / Day of the week / Day Week | 있음(FE 소스) | 1 (C16) |
| WK-SSP0005-0083 | B4 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 4 (ACT:SSP0005_ShipmentWorkingDay.GetSpdTit) |
| WK-SSP0005-0084 | F2 | SSP0005 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0005 화면 | 판단불가(대상 단위 SCREEN) | 95 (V01 V02 S02 P05 A01 A02 A14 Δ3 Δ4 ACT:SS) |
| WK-SSP0005-0085 | F6 | SSP0005 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SSP0005 화면 | 판단불가(대상 단위 SCREEN) | 87 (U02 ACT:SSP0005_ShipmentWorkingDay.SaveB) |
| WK-SSP0005-0086 | DB-SYN | P_SSP0005_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SSP0005_GET | 없음(PROC_M 대응 없음) | 1 (S01) |
| WK-SSP0005-0087 | DB-SYN | SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW | 없음(PROC_M 대응 없음) | 1 (ACT:SSP0005_ShipmentWorkingDay.SaveData_) |
| WK-SSP0005-0088 | G4 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnInput | 있음(FE 소스) | 3 (C12 ACT:SSP0005_ShipmentWorkingDay.InitE) |

## W6 검증 실행 (65)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0089 | J2 | SSP0005 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0005 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 96 (C09 C12 V01 V02 V04 S02 B04 D01 G13 P01 ) |
| WK-SSP0005-0090 | C1 | cboCompany / Company | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboCompany / Company · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0091 | C1 | cboDayWeek / Day of the week / Day Week | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDayWeek / Day of the week / Day Week · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0092 | C1 | cboInputValue / Input Value | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboInputValue / Input Value · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0093 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0094 | C3 | DAY_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DAY_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (A15) |
| WK-SSP0005-0095 | C3 | P_FIRST_ROW | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — P_FIRST_ROW · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0005_ShipmentWorkingDay.SaveData_) |
| WK-SSP0005-0096 | C3 | P_LAST_ROW | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — P_LAST_ROW · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0005_ShipmentWorkingDay.SaveData_) |
| WK-SSP0005-0097 | G3 | SSP0005 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0005 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 2 (C01 C02) |
| WK-SSP0005-0098 | K-SA | SSP0005 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0005 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (C01 C02) |
| WK-SSP0005-0099 | K4 | SSP0005 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0005 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 68 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0100 | F1 | SSP0005 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0005 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 98 (V01 V02 S02 P03 P05 U02 A01 A02 A14 Δ3 Δ) |
| WK-SSP0005-0101 | F3 | SSP0005 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SSP0005 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 1 (Δ11) |
| WK-SSP0005-0102 | F5 | SSP0005 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0005 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 2 (P03 Δ10) |
| WK-SSP0005-0103 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 3 (S04 ACT:SSP0005_ShipmentWorkingDay.GetDa) |
| WK-SSP0005-0104 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 118 (S03 ACT:SSP0005_ShipmentWorkingDay.FindB) |
| WK-SSP0005-0105 | F4 | PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 118 (S01 ACT:SSP0005_ShipmentWorkingDay.FindB) |
| WK-SSP0005-0106 | F4 | P_SSP0005_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SSP0005_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (S01) |
| WK-SSP0005-0107 | F4 | SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 86 (ACT:SSP0005_ShipmentWorkingDay.SaveButto) |
| WK-SSP0005-0108 | A5 | DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0109 | G4 | cboCompany / Company | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboCompany / Company · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0110 | G4 | cboDayWeek / Day of the week / Day Week | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDayWeek / Day of the week / Day Week · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0111 | G4 | cboInputValue / Input Value | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboInputValue / Input Value · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0112 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0113 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0114 | H2 | DAY_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DAY_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (G02) |
| WK-SSP0005-0115 | H2 | DIVISION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0116 | H4 | SSP0005 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0005 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 7 (E05 G08 P10 ACT:SSP0005_ShipmentWorkingD) |
| WK-SSP0005-0117 | H5 | DIVISION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0118 | I1 | SSP0005 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0005 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 20 (C08 V01 V02 V03 V04 V05 V06 D01 D03 D05 ) |
| WK-SSP0005-0119 | D1 | COMPANY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — COMPANY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (G10 ACT:SSP0005_ShipmentWorkingDay.EditB) |
| WK-SSP0005-0120 | D1 | DIVISION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (G10 ACT:SSP0005_ShipmentWorkingDay.EditB) |
| WK-SSP0005-0121 | D3 | COMPANY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — COMPANY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (G10 ACT:SSP0005_ShipmentWorkingDay.EditB) |
| WK-SSP0005-0122 | D3 | DIVISION | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (G10 ACT:SSP0005_ShipmentWorkingDay.EditB) |
| WK-SSP0005-0123 | D4 | DAY_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DAY_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (G21) |
| WK-SSP0005-0124 | D5 | DIVISION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0125 | D6 | SSP0005 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0005 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 4 (P02 Δ1 Δ7 Δ10) |
| WK-SSP0005-0126 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V01 ACT:SSP0005_ShipmentWorkingDay.SaveD) |
| WK-SSP0005-0127 | E4 | MSG00050 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00050 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0128 | E4 | MSG00093 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00093 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V05 ACT:SSP0005_ShipmentWorkingDay.BtnIn) |
| WK-SSP0005-0129 | E4 | MSG00134 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00134 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (V06 Δ8 ACT:SSP0005_ShipmentWorkingDay.Bt) |
| WK-SSP0005-0130 | E4 | MSG00135 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00135 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V04 ACT:SSP0005_ShipmentWorkingDay.BtnIn) |
| WK-SSP0005-0131 | E4 | MSG00614 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00614 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (Δ6) |
| WK-SSP0005-0132 | E4 | MSG00618 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00618 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V02) |
| WK-SSP0005-0133 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (A04) |
| WK-SSP0005-0134 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V01) |
| WK-SSP0005-0135 | E4 | MSG00719 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00719 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V04 D01) |
| WK-SSP0005-0136 | E4 | MSG01122 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01122 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V05 D03) |
| WK-SSP0005-0137 | E4 | MSG01153 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01153 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V06 D05) |
| WK-SSP0005-0138 | E4 | cboInputValue / Input Value | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboInputValue / Input Value · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — |  | 2 (D03 ACT:SSP0005_ShipmentWorkingDay.BtnIn) |
| WK-SSP0005-0139 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0005_ShipmentWorkingDay.SetChange) |
| WK-SSP0005-0140 | A10 | SSP0005 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0005 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 69 (ACT:SSP0005_ShipmentWorkingDay.Form_Load) |
| WK-SSP0005-0141 | A6 | PKG_COM0000.P_SCM0001_GET_SCP_PERIOD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCM0001_GET_SCP_PERIOD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 1 (S04) |
| WK-SSP0005-0142 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 34 (S03 ACT:SSP0005_ShipmentWorkingDay.FindB) |
| WK-SSP0005-0143 | A6 | PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 36 (S01 ACT:SSP0005_ShipmentWorkingDay.FindB) |
| WK-SSP0005-0144 | A6 | P_SSP0005_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SSP0005_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (S01) |
| WK-SSP0005-0145 | G1 | cboCompany / Company | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboCompany / Company · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (Δ9 ACT:SSP0005_ShipmentWorkingDay.FindDa) |
| WK-SSP0005-0146 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0005_ShipmentWorkingDay.FindData_) |
| WK-SSP0005-0147 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0005_ShipmentWorkingDay.FindData_) |
| WK-SSP0005-0148 | G6 | cboCompany / Company | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboCompany / Company · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0149 | G6 | cboDayWeek / Day of the week / Day Week | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDayWeek / Day of the week / Day Week · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0150 | G6 | cboInputValue / Input Value | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboInputValue / Input Value · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0151 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0152 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0153 | X-REOPEN | SSP0005 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0005 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 8 (ACT:SSP0005_ShipmentWorkingDay.Dispose A) |

## W7 기대값 확정 (209)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0154 | C1 | E01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E01: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E01) |
| WK-SSP0005-0155 | C1 | P07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — P07: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (P07) |
| WK-SSP0005-0156 | C3 | SSP0005_ShipmentWorkingDay.CboDayWeek_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0005_ShipmentWorkingDay.CboDayWeek_SelectedInde: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0005_ShipmentWorkingDay.CboDayWee) |
| WK-SSP0005-0157 | C3 | SSP0005_ShipmentWorkingDay.SetChangedPer | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0005_ShipmentWorkingDay.SetChangedPeriod: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0005_ShipmentWorkingDay.SetChange) |
| WK-SSP0005-0158 | C3 | SSP0005_ShipmentWorkingDay.SpdMain_Chang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0005_ShipmentWorkingDay.SpdMain_Changed: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SSP0005_ShipmentWorkingDay.SpdMain_C) |
| WK-SSP0005-0159 | C3 | Δ11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — Δ11: 행 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Δ11) |
| WK-SSP0005-0160 | B3 | B01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B01: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (B01) |
| WK-SSP0005-0161 | B3 | B02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B02: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (B02) |
| WK-SSP0005-0162 | B3 | B03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B03: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (B03) |
| WK-SSP0005-0163 | B3 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — B04: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (B04) |
| WK-SSP0005-0164 | B3 | SSP0005_ShipmentWorkingDay.GetDayOfWeek | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0005_ShipmentWorkingDay.GetDayOfWeek: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0005_ShipmentWorkingDay.GetDayOfW) |
| WK-SSP0005-0165 | B3 | SSP0005_ShipmentWorkingDay.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0005_ShipmentWorkingDay.GetDayRange: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0005_ShipmentWorkingDay.GetDayRan) |
| WK-SSP0005-0166 | B3 | SSP0005_ShipmentWorkingDay.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0005_ShipmentWorkingDay.GetSpdTitle: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0005-0167 | B4 | B01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B01: 행 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (B01) |
| WK-SSP0005-0168 | B4 | B02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B02: 행 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (B02) |
| WK-SSP0005-0169 | B4 | B03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B03: 행 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (B03) |
| WK-SSP0005-0170 | B4 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — B04: 행 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (B04) |
| WK-SSP0005-0171 | B4 | GC01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — GC01: 행 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (GC01) |
| WK-SSP0005-0172 | B4 | SSP0005_ShipmentWorkingDay.GetDayOfWeek | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0005_ShipmentWorkingDay.GetDayOfWeek: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0005_ShipmentWorkingDay.GetDayOfW) |
| WK-SSP0005-0173 | B4 | SSP0005_ShipmentWorkingDay.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0005_ShipmentWorkingDay.GetDayRange: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0005_ShipmentWorkingDay.GetDayRan) |
| WK-SSP0005-0174 | B4 | SSP0005_ShipmentWorkingDay.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0005_ShipmentWorkingDay.GetSpdTitle: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0005-0175 | DB-SYN | B03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — B03: 행 집계 — DB-SYN 5요소: PASS:3 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (B03) |
| WK-SSP0005-0176 | DB-SYN | U01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — U01: 행 집계 — DB-SYN 5요소: PASS:3 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (U01) |
| WK-SSP0005-0177 | DB-SYN | U02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — U02: 행 집계 — DB-SYN 5요소: PASS:3 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (U02) |
| WK-SSP0005-0178 | F4 | B03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — B03: 행 집계 — F4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (B03) |
| WK-SSP0005-0179 | F4 | U01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — U01: 행 집계 — F4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (U01) |
| WK-SSP0005-0180 | F4 | U02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — U02: 행 집계 — F4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (U02) |
| WK-SSP0005-0181 | A5 | A17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — A17: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (A17) |
| WK-SSP0005-0182 | A5 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — B04: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (B04) |
| WK-SSP0005-0183 | A5 | C01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — C01: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (C01) |
| WK-SSP0005-0184 | A5 | C09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — C09: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (C09) |
| WK-SSP0005-0185 | A5 | C18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — C18: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (C18) |
| WK-SSP0005-0186 | A5 | C19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — C19: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (C19) |
| WK-SSP0005-0187 | A5 | D01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D01: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D01) |
| WK-SSP0005-0188 | A5 | P02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — P02: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (P02) |
| WK-SSP0005-0189 | A5 | SSP0005_ShipmentWorkingDay.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0005_ShipmentWorkingDay.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0005_ShipmentWorkingDay.CreateSpr) |
| WK-SSP0005-0190 | A5 | Δ11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Δ11: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Δ11) |
| WK-SSP0005-0191 | G4 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — B04: 행 집계 — G4 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (B04) |
| WK-SSP0005-0192 | G4 | C09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — C09: 행 집계 — G4 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (C09) |
| WK-SSP0005-0193 | G4 | Δ6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Δ6: 행 집계 — G4 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (Δ6) |
| WK-SSP0005-0194 | H2 | A17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — A17: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (A17) |
| WK-SSP0005-0195 | H2 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — B04: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (B04) |
| WK-SSP0005-0196 | H2 | C18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — C18: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (C18) |
| WK-SSP0005-0197 | H2 | C19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — C19: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (C19) |
| WK-SSP0005-0198 | H2 | E05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E05: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (E05) |
| WK-SSP0005-0199 | H2 | G08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G08: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (G08) |
| WK-SSP0005-0200 | H2 | P10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — P10: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (P10) |
| WK-SSP0005-0201 | H2 | SSP0005_ShipmentWorkingDay.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0005_ShipmentWorkingDay.CreateSpread: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0005_ShipmentWorkingDay.CreateSpr) |
| WK-SSP0005-0202 | H2 | Δ10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Δ10: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Δ10) |
| WK-SSP0005-0203 | H2 | Δ11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Δ11: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Δ11) |
| WK-SSP0005-0204 | H5 | A17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — A17: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (A17) |
| WK-SSP0005-0205 | H5 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — B04: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (B04) |
| WK-SSP0005-0206 | H5 | C18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — C18: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (C18) |
| WK-SSP0005-0207 | H5 | C19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — C19: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (C19) |
| WK-SSP0005-0208 | H5 | SSP0005_ShipmentWorkingDay.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0005_ShipmentWorkingDay.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0005_ShipmentWorkingDay.CreateSpr) |
| WK-SSP0005-0209 | H5 | Δ11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Δ11: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Δ11) |
| WK-SSP0005-0210 | SC1 | SSP0005 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | SC1 기대값 확정 — SSP0005 화면: 게이트 SC2 기준표가 BUTTON_AREA(조회조건 영역 → 버튼 영역) 로 정한 조 |  | 4 (C09 C12 B04 Δ6) |
| WK-SSP0005-0211 | X-REASON | A05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A05 `UnFilterInsertRow = true` cs:124 Insert 가 NO-OP 라 신규행이 생기지 않아 실효 없음. 컬럼셋은 조회 발사 시점 스냅샷으로만 재구성 미이식(실효 없음) |  | 1 (A05) |
| WK-SSP0005-0212 | X-REASON | A06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A06 저장 대상 = action AND 글자색 Red cs:491-492 **색상 축 폐기** — `CRUD_TYPE`(EditTracker) 단일 축. btnInput 도 `storeChange` |  | 1 (A06) |
| WK-SSP0005-0213 | X-REASON | A07 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A07 `iCount==0` 시 첫/끝 행 플래그 cs:514-515 **미이식 — AS-IS 결함 재현 금지.** `if (iCount>0)` 밖에서 `Rows[0]`/`Rows[iCount-1]` |  | 1 (A07) |
| WK-SSP0005-0214 | X-REASON | A09 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A09 `DefineProperty()` 빈 본문 cs:142-144 대응물 없음 미이식(해당 없음) |  | 1 (A09) |
| WK-SSP0005-0215 | X-REASON | C10 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — C10 `emptySpaceItem1` dsn:420-426 여백 전용 — React 대응물 없음(Grid 잔여 칸이 등가) 미이식(해당 없음) |  | 1 (C10) |
| WK-SSP0005-0216 | X-REASON | C11 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — C11 `emptySpaceItem2` dsn:348-354 동일 — 여백 전용 미이식(해당 없음) |  | 1 (C11) |
| WK-SSP0005-0217 | X-REASON | C20 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — C20 `components`(Container) dsn:31 WinForms 인프라 — 대응물 없음 미이식(해당 없음) |  | 1 (C20) |
| WK-SSP0005-0218 | X-REASON | D08 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D08 `ds == null` cs:730 **구조 복제 금지 — AS-IS 잠재 결함.** 직전 cs:725 가 `dsdm.Changed -=` 를 실행한 뒤라 여기서 return 하면 핸들러가 영 |  | 1 (D08) |
| WK-SSP0005-0219 | X-REASON | D09 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D09 `!CanModelChange`(Changed) cs:873 E04 미이식에 포함 미이식(근거 기재) |  | 1 (D09) |
| WK-SSP0005-0220 | X-REASON | D10 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D10 `ds == null`(Changed) cs:885 동일. `finally { dt.AcceptChanges() }` 가 `dt` null 이면 NRE — 복제 금지 미이식(결함 재현 금지) |  | 1 (D10) |
| WK-SSP0005-0221 | X-REASON | E04 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E04 `SpdMain_Changed` cs:872-907 **미이식** — `case CellsUpdated:` 본문이 비어 있어 실효 로직 0. 남은 것은 FarPoint 전용 재귀 방지/`Acc |  | 1 (E04) |
| WK-SSP0005-0222 | X-REASON | G09 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G09 `SwitchLock`(EditButton) cs:353 **미이식** — 편집모드 토글 폐기(convert-core §2.4). `canEdit = hasButton('EDIT')` 단일 축 |  | 1 (G09) |
| WK-SSP0005-0223 | X-REASON | G12 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G12 `LockColumn(0, max, true)`(조회 직후 전열 잠금) cs:420 **미이식** — G09 와 같은 축. 그대로 옮기면 편집이 영구 차단된다 미이식(근거 기재) |  | 1 (G12) |
| WK-SSP0005-0224 | X-REASON | G15 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G15 `GetModelColumnFromViewColumn`(cRow) cs:742 **미이식(사문)** — 산출값 `cRow`/`cCol` 이 이후 한 번도 쓰이지 않는다(cs:744 이후 전부  |  | 1 (G15) |
| WK-SSP0005-0225 | X-REASON | G16 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G16 `GetModelColumnFromViewColumn`(cCol) cs:743 동일 미이식(근거 기재) |  | 1 (G16) |
| WK-SSP0005-0226 | X-REASON | G22 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G22 `Visible=`(`M_` → `W_` 토글) cs:840 **미이식(사문)** — E03 동일 근거 미이식(근거 기재) |  | 1 (G22) |
| WK-SSP0005-0227 | X-REASON | G23 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G23 `Visible=`(`M_` → `D_` 숨김) cs:843 동일 미이식(근거 기재) |  | 1 (G23) |
| WK-SSP0005-0228 | X-REASON | G24 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G24 `Visible=`(`W_` → `D_` 토글) cs:854 동일 미이식(근거 기재) |  | 1 (G24) |
| WK-SSP0005-0229 | X-REASON | P08 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — P08 `SpdMain_CellDoubleClick` cs:834 미이식(E03 사문) 미이식(근거 기재) |  | 1 (P08) |
| WK-SSP0005-0230 | X-REASON | P09 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — P09 `SpdMain_Changed` cs:872 미이식(E04 본문 공란) 미이식(근거 기재) |  | 1 (P09) |
| WK-SSP0005-0231 | X-REASON | V07 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — V07 `MSG00050` 숫자 형식 cs:714 **미이식 — 도달 불가.** `try` 블록(cs:708-717)에 숫자 파싱이 없어 `FormatException` 이 발생할 수 없다 미이식(근 |  | 1 (V07) |
| WK-SSP0005-0232 | D1 | D01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D01: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D01) |
| WK-SSP0005-0233 | D1 | P04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — P04: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (P04) |
| WK-SSP0005-0234 | D1 | P05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — P05: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (P05) |
| WK-SSP0005-0235 | D1 | SSP0005_ShipmentWorkingDay.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SSP0005_ShipmentWorkingDay.EditButton: 진입점 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0005_ShipmentWorkingDay.EditButto) |
| WK-SSP0005-0236 | D1 | V04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — V04: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (V04) |
| WK-SSP0005-0237 | D1 | Δ11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Δ11: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Δ11) |
| WK-SSP0005-0238 | D1 | Δ2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Δ2: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Δ2) |
| WK-SSP0005-0239 | D3 | D01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D01: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D01) |
| WK-SSP0005-0240 | D3 | P04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — P04: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (P04) |
| WK-SSP0005-0241 | D3 | P05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — P05: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (P05) |
| WK-SSP0005-0242 | D3 | SSP0005_ShipmentWorkingDay.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SSP0005_ShipmentWorkingDay.EditButton: 진입점 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0005_ShipmentWorkingDay.EditButto) |
| WK-SSP0005-0243 | D3 | V04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — V04: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (V04) |
| WK-SSP0005-0244 | D3 | Δ10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Δ10: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Δ10) |
| WK-SSP0005-0245 | D3 | Δ11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Δ11: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Δ11) |
| WK-SSP0005-0246 | D3 | Δ2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Δ2: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Δ2) |
| WK-SSP0005-0247 | D4 | G17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — G17: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G17) |
| WK-SSP0005-0248 | D4 | G18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — G18: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G18) |
| WK-SSP0005-0249 | D4 | G19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — G19: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G19) |
| WK-SSP0005-0250 | D4 | G20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — G20: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G20) |
| WK-SSP0005-0251 | D4 | P02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — P02: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (P02) |
| WK-SSP0005-0252 | D4 | Δ1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — Δ1: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Δ1) |
| WK-SSP0005-0253 | D4 | Δ10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — Δ10: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Δ10) |
| WK-SSP0005-0254 | D4 | Δ4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — Δ4: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Δ4) |
| WK-SSP0005-0255 | D4 | Δ7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — Δ7: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Δ7) |
| WK-SSP0005-0256 | D4 | Δ9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — Δ9: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Δ9) |
| WK-SSP0005-0257 | D5 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — B04: 행 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (B04) |
| WK-SSP0005-0258 | D5 | GC01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — GC01: 행 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (GC01) |
| WK-SSP0005-0259 | D5 | SSP0005_ShipmentWorkingDay.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0005_ShipmentWorkingDay.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0005_ShipmentWorkingDay.CreateSpr) |
| WK-SSP0005-0260 | E4 | A02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — A02: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (A02) |
| WK-SSP0005-0261 | E4 | C08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — C08: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (C08) |
| WK-SSP0005-0262 | E4 | P05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — P05: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (P05) |
| WK-SSP0005-0263 | E4 | SSP0005_ShipmentWorkingDay.SetChangedPer | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0005_ShipmentWorkingDay.SetChangedPeriod: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0005_ShipmentWorkingDay.SetChange) |
| WK-SSP0005-0264 | E4 | V03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — V03: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (V03) |
| WK-SSP0005-0265 | A1 | A02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A02: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (A02) |
| WK-SSP0005-0266 | A1 | A04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A04: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (A04) |
| WK-SSP0005-0267 | A1 | A15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A15: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (A15) |
| WK-SSP0005-0268 | A1 | B03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B03: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (B03) |
| WK-SSP0005-0269 | A1 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B04: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (B04) |
| WK-SSP0005-0270 | A1 | C09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — C09: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (C09) |
| WK-SSP0005-0271 | A1 | C12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — C12: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (C12) |
| WK-SSP0005-0272 | A1 | D01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D01: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D01) |
| WK-SSP0005-0273 | A1 | G13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G13: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (G13) |
| WK-SSP0005-0274 | A1 | P01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P01: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (P01) |
| WK-SSP0005-0275 | A1 | PKG_COM0000.P_SCM0001_GET_SCP_PERIOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCM0001_GET_SCP_PERIOD: 골든 비교 케이스 없음(PKG_COM0000.P_SCM0001_GET_SCP_PERIOD — 팝업·보조 SP 는 golden_cases.csv  |  | 1 (S04) |
| WK-SSP0005-0276 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 34 (S03 ACT:SSP0005_ShipmentWorkingDay.FindB) |
| WK-SSP0005-0277 | A1 | PKG_SSP0005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0005: 골든 비교 케이스 없음(PKG_SSP0005 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (Δ9) |
| WK-SSP0005-0278 | A1 | PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY: 골든 비교 케이스 없음(PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY — 팝업·보조 SP |  | 36 (S01 ACT:SSP0005_ShipmentWorkingDay.FindB) |
| WK-SSP0005-0279 | A1 | P_SSP0005_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0005_GET: 골든 비교 케이스 없음(P_SSP0005_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (S01) |
| WK-SSP0005-0280 | A1 | U01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — U01: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (U01) |
| WK-SSP0005-0281 | A1 | V04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — V04: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (V04) |
| WK-SSP0005-0282 | A1 | Δ1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Δ1: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (Δ1) |
| WK-SSP0005-0283 | A1 | Δ11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Δ11: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (Δ11) |
| WK-SSP0005-0284 | A1 | Δ6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Δ6: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (Δ6) |
| WK-SSP0005-0285 | A6 | B03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — B03: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (B03) |
| WK-SSP0005-0286 | A6 | U01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — U01: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (U01) |
| WK-SSP0005-0287 | G03-WIRE | SSP0005 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SSP0005 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 / 게이트 G03 As-is 이벤트 spdMain.CellDoubleClick → SpdM  |  | 13 (ACT:SSP0005_ShipmentWorkingDay..ctor ACT) |
| WK-SSP0005-0288 | G1 | A02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — A02: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (A02) |
| WK-SSP0005-0289 | G1 | A04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — A04: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (A04) |
| WK-SSP0005-0290 | G1 | A15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — A15: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (A15) |
| WK-SSP0005-0291 | G1 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — B04: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (B04) |
| WK-SSP0005-0292 | G1 | C09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — C09: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (C09) |
| WK-SSP0005-0293 | G1 | C12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — C12: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (C12) |
| WK-SSP0005-0294 | G1 | D01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D01: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D01) |
| WK-SSP0005-0295 | G1 | G13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — G13: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (G13) |
| WK-SSP0005-0296 | G1 | P01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — P01: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (P01) |
| WK-SSP0005-0297 | G1 | V04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — V04: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (V04) |
| WK-SSP0005-0298 | G1 | Δ1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Δ1: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Δ1) |
| WK-SSP0005-0299 | G1 | Δ11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Δ11: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Δ11) |
| WK-SSP0005-0300 | G1 | Δ6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Δ6: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Δ6) |
| WK-SSP0005-0301 | G6 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — B04: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (B04) |
| WK-SSP0005-0302 | G6 | C09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — C09: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (C09) |
| WK-SSP0005-0303 | G6 | C12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — C12: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (C12) |
| WK-SSP0005-0304 | G6 | Δ6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Δ6: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Δ6) |
| WK-SSP0005-0305 | X-LOC | B01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — B01: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (B01) |
| WK-SSP0005-0306 | X-LOC | B03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — B03: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (B03) |
| WK-SSP0005-0307 | X-LOC | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — B04: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (B04) |
| WK-SSP0005-0308 | X-LOC | Δ1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ1) |
| WK-SSP0005-0309 | X-LOC | Δ10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ10) |
| WK-SSP0005-0310 | X-LOC | Δ11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ11) |
| WK-SSP0005-0311 | X-LOC | Δ2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ2) |
| WK-SSP0005-0312 | X-LOC | Δ3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ3) |
| WK-SSP0005-0313 | X-LOC | Δ4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ4) |
| WK-SSP0005-0314 | X-LOC | Δ5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ5) |
| WK-SSP0005-0315 | X-LOC | Δ6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ6) |
| WK-SSP0005-0316 | X-LOC | Δ7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ7) |
| WK-SSP0005-0317 | X-LOC | Δ8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ8) |
| WK-SSP0005-0318 | X-LOC | Δ9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ9) |
| WK-SSP0005-0319 | X-LOC | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — —: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (—) |
| WK-SSP0005-0320 | X-ROW | A03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — A03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (A03) |
| WK-SSP0005-0321 | X-ROW | A10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — A10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (A10) |
| WK-SSP0005-0322 | X-ROW | A11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — A11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (A11) |
| WK-SSP0005-0323 | X-ROW | A13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — A13: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (A13) |
| WK-SSP0005-0324 | X-ROW | C03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C03) |
| WK-SSP0005-0325 | X-ROW | C04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C04: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C04) |
| WK-SSP0005-0326 | X-ROW | C05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C05: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C05) |
| WK-SSP0005-0327 | X-ROW | C06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C06) |
| WK-SSP0005-0328 | X-ROW | C07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C07) |
| WK-SSP0005-0329 | X-ROW | C13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C13: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C13) |
| WK-SSP0005-0330 | X-ROW | C14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C14) |
| WK-SSP0005-0331 | X-ROW | C17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C17: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C17) |
| WK-SSP0005-0332 | X-ROW | D02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D02) |
| WK-SSP0005-0333 | X-ROW | D04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D04: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D04) |
| WK-SSP0005-0334 | X-ROW | D06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D06) |
| WK-SSP0005-0335 | X-ROW | D07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D07) |
| WK-SSP0005-0336 | X-ROW | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E02) |
| WK-SSP0005-0337 | X-ROW | G03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G03) |
| WK-SSP0005-0338 | X-ROW | G04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G04: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G04) |
| WK-SSP0005-0339 | X-ROW | G05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G05: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G05) |
| WK-SSP0005-0340 | X-ROW | G06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G06) |
| WK-SSP0005-0341 | X-ROW | G07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G07) |
| WK-SSP0005-0342 | X-ROW | G11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G11) |
| WK-SSP0005-0343 | X-ROW | G14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G14) |
| WK-SSP0005-0344 | X-ROW | P06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — P06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (P06) |
| WK-SSP0005-0345 | X-ROW | SSP0005_ShipmentWorkingDay.BtnInput_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.BtnInput_Click: 진입점 집계 9검사 — NOT_RUN:8 · WARN:1 |  | 5 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0346 | X-ROW | SSP0005_ShipmentWorkingDay.CboDayWeek_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.CboDayWeek_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.CboDayWee) |
| WK-SSP0005-0347 | X-ROW | SSP0005_ShipmentWorkingDay.ClearUsrCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 |  | 4 (ACT:SSP0005_ShipmentWorkingDay.ClearUsrC) |
| WK-SSP0005-0348 | X-ROW | SSP0005_ShipmentWorkingDay.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.CreateSpr) |
| WK-SSP0005-0349 | X-ROW | SSP0005_ShipmentWorkingDay.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.FindButto) |
| WK-SSP0005-0350 | X-ROW | SSP0005_ShipmentWorkingDay.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.FindData_Main: 진입점 집계 12검사 — NOT_RUN:8 · REVIEW:2 · PASS:2 |  | 7 (ACT:SSP0005_ShipmentWorkingDay.FindData_) |
| WK-SSP0005-0351 | X-ROW | SSP0005_ShipmentWorkingDay.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.Form_Load) |
| WK-SSP0005-0352 | X-ROW | SSP0005_ShipmentWorkingDay.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.GetDayRan) |
| WK-SSP0005-0353 | X-ROW | SSP0005_ShipmentWorkingDay.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.InitControls: 진입점 집계 15검사 — NOT_RUN:15 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0354 | X-ROW | SSP0005_ShipmentWorkingDay.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.InitSpread: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0355 | X-ROW | SSP0005_ShipmentWorkingDay.InitSpreadDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0356 | X-ROW | SSP0005_ShipmentWorkingDay.SaveData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.SaveData_Main: 진입점 집계 14검사 — NOT_RUN:9 · NOPATH:3 · PASS:2 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SSP0005_ShipmentWorkingDay.SaveData_) |
| WK-SSP0005-0357 | X-ROW | SSP0005_ShipmentWorkingDay.SetChangedPer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.SetChangedPeriod: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0005_ShipmentWorkingDay.SetChange) |
| WK-SSP0005-0358 | X-ROW | SSP0005_ShipmentWorkingDay.SpdMain_CellD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0005_ShipmentWorkingDay.SpdMain_C) |
| WK-SSP0005-0359 | X-ROW | SSP0005_ShipmentWorkingDay.SpdMain_Chang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.SpdMain_Changed: 진입점 집계 4검사 — NOT_RUN:3 · WARN:1 |  | 2 (ACT:SSP0005_ShipmentWorkingDay.SpdMain_C) |
| WK-SSP0005-0360 | X-ROW | SSP0005_ShipmentWorkingDay.SpdMain_TopCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0005_ShipmentWorkingDay.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0005_ShipmentWorkingDay.SpdMain_T) |
| WK-SSP0005-0361 | X-ROW | Δ5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Δ5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Δ5) |
| WK-SSP0005-0362 | X-ROW | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — —: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (—) |
