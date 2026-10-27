# 작업 원장 — SCP0096 · 2026-10-26 12:54

> 검사 인스턴스 360건 중 PASS·NA 77건 외 **283건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 66 | 구현 위치 실존 |
| W4 | 검사기 구현 | 5 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 22 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 61 | 실행 → PASS |
| W7 | 기대값 확정 | 129 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 124 · 대조표 71 · E2E 61 · 하네스 27
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 66 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 36 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| G1 | GEN |  |  |  |  |  | 6 | 11 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 16 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| E4 | EDIT |  |  |  |  |  | 8 | 6 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| B4 | COMBO |  |  |  |  | 6 |  | 6 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 5 |  |  | 5 |  |  | 콤보 후보 정렬 = AS-IS |
| H2 | DESIGN |  |  |  |  |  | 2 | 8 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 3 | 6 |  |  | 라벨 명칭 |
| D1 | EDIT |  |  |  |  |  | 4 | 5 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 4 | 5 |  |  | 행 값 기반 조건부 잠금 |
| G6 | GEN |  |  |  |  |  | 6 | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F4 | DB |  |  |  |  |  | 4 | 3 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| D5 | EDIT |  |  |  |  |  | 2 | 4 |  |  | 셀 에디터 유형 |
| B1 | COMBO |  |  |  |  | 4 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 4 |  | 1 |  |  | 콤보 후보 중복 없음 |
| C1 | CASCADE |  |  |  |  |  | 5 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| A6 | GEN |  |  |  |  |  | 3 | 2 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REASON | DESIGN |  |  |  |  |  |  | 5 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B6 | COMBO |  |  |  |  | 4 |  |  |  |  | ALL 옵션·다중선택 사양 |
| DB-SYN | DB |  |  |  |  | 1 |  | 3 |  |  | BE 계정 시노님·권한·대상 객체 |
| C4 | CASCADE |  |  |  |  |  | 4 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| G4 | DESIGN |  |  |  |  | 1 |  | 2 |  |  | 조회조건 표시·라벨·활성 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| E1 | EDIT |  |  |  |  |  | 1 |  |  |  | 숫자 소수자리·정수·부호·범위 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| I1 | DESIGN |  |  |  |  |  |  | 1 |  |  | LBL/MSG 언어별 등록 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |

## W2 구현 위치 확인 (66)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0001 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-02) |
| WK-SCP0096-0002 | X-LOC | COMMON:UC-03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-03) |
| WK-SCP0096-0003 | X-LOC | COMMON:UC-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-04) |
| WK-SCP0096-0004 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0096-0005 | X-LOC | COMMON:UC-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-06) |
| WK-SCP0096-0006 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-07) |
| WK-SCP0096-0007 | X-LOC | CRUD:DELETE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:DELETE) |
| WK-SCP0096-0008 | X-LOC | CRUD:INSERT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:INSERT) |
| WK-SCP0096-0009 | X-LOC | CRUD:SAVE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:SAVE) |
| WK-SCP0096-0010 | X-LOC | CRUD:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:SEARCH) |
| WK-SCP0096-0011 | X-LOC | D00-1-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-001) |
| WK-SCP0096-0012 | X-LOC | D00-1-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-002) |
| WK-SCP0096-0013 | X-LOC | D00-1-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-003) |
| WK-SCP0096-0014 | X-LOC | D00-1-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-004) |
| WK-SCP0096-0015 | X-LOC | D00-1-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-005) |
| WK-SCP0096-0016 | X-LOC | D00-1-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-006) |
| WK-SCP0096-0017 | X-LOC | D00-1-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-007) |
| WK-SCP0096-0018 | X-LOC | D00-1-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-008) |
| WK-SCP0096-0019 | X-LOC | D00-1-009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-009) |
| WK-SCP0096-0020 | X-LOC | D00-1-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-010) |
| WK-SCP0096-0021 | X-LOC | D00-1-011 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-011) |
| WK-SCP0096-0022 | X-LOC | D00-1-021 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-021) |
| WK-SCP0096-0023 | X-LOC | D00-2-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-001) |
| WK-SCP0096-0024 | X-LOC | D00-2-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-002) |
| WK-SCP0096-0025 | X-LOC | D00-2-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-003) |
| WK-SCP0096-0026 | X-LOC | D00-2-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-004) |
| WK-SCP0096-0027 | X-LOC | D00-2-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-005) |
| WK-SCP0096-0028 | X-LOC | D00-2-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-007) |
| WK-SCP0096-0029 | X-LOC | D00-3-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-001) |
| WK-SCP0096-0030 | X-LOC | D00-3-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-002) |
| WK-SCP0096-0031 | X-LOC | D00-3-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-003) |
| WK-SCP0096-0032 | X-LOC | D00-3-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-004) |
| WK-SCP0096-0033 | X-LOC | D00-3-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-005) |
| WK-SCP0096-0034 | X-LOC | D00-3-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-006) |
| WK-SCP0096-0035 | X-LOC | D00-3-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-007) |
| WK-SCP0096-0036 | X-LOC | D00-3-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-008) |
| WK-SCP0096-0037 | X-LOC | D00-3-009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-009) |
| WK-SCP0096-0038 | X-LOC | D00-3-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-010) |
| WK-SCP0096-0039 | X-LOC | D00-3-011 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-011) |
| WK-SCP0096-0040 | X-LOC | D00-3-012 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-012) |
| WK-SCP0096-0041 | X-LOC | D00-3-013 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-013) |
| WK-SCP0096-0042 | X-LOC | D00-3-014 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-014) |
| WK-SCP0096-0043 | X-LOC | D00-3-016 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-016) |
| WK-SCP0096-0044 | X-LOC | D00-3-017 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-017) |
| WK-SCP0096-0045 | X-LOC | D00-3-018 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-018) |
| WK-SCP0096-0046 | X-LOC | D00-3-019 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-019) |
| WK-SCP0096-0047 | X-LOC | D00-3-021 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-021) |
| WK-SCP0096-0048 | X-LOC | D00-3-023 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-023) |
| WK-SCP0096-0049 | X-LOC | D00-3-024 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-024) |
| WK-SCP0096-0050 | X-LOC | D00-3-025 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-025) |
| WK-SCP0096-0051 | X-LOC | D00-3-026 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-026) |
| WK-SCP0096-0052 | X-LOC | D00-3-027 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-027) |
| WK-SCP0096-0053 | X-LOC | D00-3-028 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-028) |
| WK-SCP0096-0054 | X-LOC | D00-3-029 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-029) |
| WK-SCP0096-0055 | X-LOC | D00-3-030 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-030) |
| WK-SCP0096-0056 | X-LOC | D00-3-031 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-031) |
| WK-SCP0096-0057 | X-LOC | D00-4b-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-001) |
| WK-SCP0096-0058 | X-LOC | D00-4b-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-002) |
| WK-SCP0096-0059 | X-LOC | D00-4b-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-003) |
| WK-SCP0096-0060 | X-LOC | D00-4b-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-004) |
| WK-SCP0096-0061 | X-LOC | D00-4d-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-001) |
| WK-SCP0096-0062 | X-LOC | D00-4d-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-002) |
| WK-SCP0096-0063 | X-LOC | D00-4d-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-003) |
| WK-SCP0096-0064 | X-LOC | D00-4d-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-004) |
| WK-SCP0096-0065 | X-LOC | D00-4d-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-005) |
| WK-SCP0096-0066 | X-LOC | D00-4d-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-006) |

## W4 검사기 구현 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0067 | B3 | COLUMN_NAME | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 COLUMN_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0068 | B3 | DAY_CODE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DAY_CODE | 있음(FE 소스) | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0069 | B3 | cboDayWeek / Day of the week / Day Week  | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDayWeek / Day of the week / Day Week / - | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0096-0070 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 3 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0071 | B3 | cboInputValue / Input Value / - | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboInputValue / Input Value / - | 있음(FE 소스) | 1 (D00-4b-003) |

## W5 검사기 연결 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0072 | B1 | cboDayWeek / Day of the week / Day Week  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDayWeek / Day of the week / Day Week / - | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0096-0073 | B1 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCP0096-0074 | B1 | cboInputValue / Input Value / - | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboInputValue / Input Value / - | 있음(FE 소스) | 2 (D00-1-004 D00-4b-003) |
| WK-SCP0096-0075 | B1 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0096-0076 | B2 | cboDayWeek / Day of the week / Day Week  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDayWeek / Day of the week / Day Week / - | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0096-0077 | B2 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCP0096-0078 | B2 | cboInputValue / Input Value / - | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboInputValue / Input Value / - | 있음(FE 소스) | 2 (D00-1-004 D00-4b-003) |
| WK-SCP0096-0079 | B2 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0096-0080 | B4 | COLUMN_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL COLUMN_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0081 | B4 | DAY_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DAY_CODE | 있음(FE 소스) | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0082 | B4 | cboDayWeek / Day of the week / Day Week  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDayWeek / Day of the week / Day Week / - | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0096-0083 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 4 (D00-1-001 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0084 | B4 | cboInputValue / Input Value / - | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboInputValue / Input Value / - | 있음(FE 소스) | 2 (D00-1-004 D00-4b-003) |
| WK-SCP0096-0085 | B4 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0096-0086 | B6 | cboDayWeek / Day of the week / Day Week  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDayWeek / Day of the week / Day Week / - | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0096-0087 | B6 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCP0096-0088 | B6 | cboInputValue / Input Value / - | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboInputValue / Input Value / - | 있음(FE 소스) | 1 (D00-1-004) |
| WK-SCP0096-0089 | B6 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0096-0090 | F2 | SCP0096 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0096 화면 | 판단불가(대상 단위 SCREEN) | 80 (D00-1-011 CRUD:SAVE COMMON:UC-02 COMMON:) |
| WK-SCP0096-0091 | F6 | SCP0096 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0096 화면 | 판단불가(대상 단위 SCREEN) | 77 (CRUD:SAVE ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0092 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0093 | G4 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnInput | 있음(FE 소스) | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |

## W6 검증 실행 (61)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0094 | C1 | cboDayWeek / Day of the week / Day Week  | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDayWeek / Day of the week / Day Week / - · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-003 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0095 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (D00-2-001 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0096 | C1 | cboInputValue / Input Value / - | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboInputValue / Input Value / - · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |
| WK-SCP0096-0097 | C1 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-2-004) |
| WK-SCP0096-0098 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-002 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0099 | C4 | cboDayWeek / Day of the week / Day Week  | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDayWeek / Day of the week / Day Week / - · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-003) |
| WK-SCP0096-0100 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-001) |
| WK-SCP0096-0101 | C4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-004) |
| WK-SCP0096-0102 | C4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-002) |
| WK-SCP0096-0103 | G3 | SCP0096 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0096 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (D00-1-010 COMMON:UC-02 COMMON:UC-03 COMM) |
| WK-SCP0096-0104 | K-SA | SCP0096 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0096 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (D00-1-010) |
| WK-SCP0096-0105 | K4 | SCP0096 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0096 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 54 (COMMON:UC-02 COMMON:UC-03 COMMON:UC-04 C) |
| WK-SCP0096-0106 | F5 | SCP0096 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0096 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (CRUD:DELETE) |
| WK-SCP0096-0107 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0108 | F4 | PKG_SCP0019.P_SCP0019_GET_WORKING_TIME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0019.P_SCP0019_GET_WORKING_TIME · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 111 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0109 | F4 | PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 112 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0110 | F4 | PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OS · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 76 (ACT:SCP0096_Shipment_Working_Day_OSP.Sav) |
| WK-SCP0096-0111 | H2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |
| WK-SCP0096-0112 | H2 | WORKING_TIME_DEFAULT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — WORKING_TIME_DEFAULT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |
| WK-SCP0096-0113 | H4 | SCP0096 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0096 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 5 (D00-2-007 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0114 | H5 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEASURE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |
| WK-SCP0096-0115 | H5 | WORKING_TIME_DEFAULT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — WORKING_TIME_DEFAULT · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |
| WK-SCP0096-0116 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0117 | SC1 | SCP0096 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0096 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 8 (D00-1-001 D00-1-002 D00-1-003 D00-1-004 ) |
| WK-SCP0096-0118 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (D00-3-016 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0119 | D1 | LAST_INPUT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_INPUT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (D00-3-017 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0120 | D1 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-3-017 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0121 | D1 | PLANT_SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PLANT_SITE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-3-016 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0122 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (D00-3-016 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0123 | D3 | LAST_INPUT_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_INPUT_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (D00-3-017 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0124 | D3 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-3-017 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0125 | D3 | PLANT_SITE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PLANT_SITE_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-3-016 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0126 | D5 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |
| WK-SCP0096-0127 | D5 | WORKING_TIME_DEFAULT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — WORKING_TIME_DEFAULT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |
| WK-SCP0096-0128 | D6 | SCP0096 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0096 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (CRUD:INSERT) |
| WK-SCP0096-0129 | E1 | WORKING_TIME_DEFAULT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — WORKING_TIME_DEFAULT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (D00-3-001) |
| WK-SCP0096-0130 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Sav) |
| WK-SCP0096-0131 | E4 | MSG00050 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00050 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4d-004) |
| WK-SCP0096-0132 | E4 | MSG00134 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00134 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4d-005 ACT:SCP0096_Shipment_Working_) |
| WK-SCP0096-0133 | E4 | MSG00135 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00135 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4d-001 ACT:SCP0096_Shipment_Working_) |
| WK-SCP0096-0134 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0096-0135 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 7 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0136 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0137 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 3 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0138 | A10 | SCP0096 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0096 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 81 (ACT:SCP0096_Shipment_Working_Day_OSP.Def) |
| WK-SCP0096-0139 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 36 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0140 | A6 | PKG_SCP0019.P_SCP0019_GET_WORKING_TIME | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0019.P_SCP0019_GET_WORKING_TIME · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 37 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0141 | A6 | PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 38 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0142 | G1 | cboDayWeek / Day of the week / Day Week  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDayWeek / Day of the week / Day Week / - · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-003) |
| WK-SCP0096-0143 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-001 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0144 | G1 | cboInputValue / Input Value / - | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboInputValue / Input Value / - · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-004) |
| WK-SCP0096-0145 | G1 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkSum / Sum · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-005) |
| WK-SCP0096-0146 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-002 D00-4b-004 ACT:SCP0096_Shipmen) |
| WK-SCP0096-0147 | G1 | usrButton1 / Button1 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — usrButton1 / Button1 · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-011) |
| WK-SCP0096-0148 | G6 | cboDayWeek / Day of the week / Day Week  | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDayWeek / Day of the week / Day Week / - · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-003 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0149 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-001 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0150 | G6 | cboInputValue / Input Value / - | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboInputValue / Input Value / - · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-004 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0151 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-005 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0152 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-002 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0153 | G6 | usrButton1 / Button1 | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — usrButton1 / Button1 · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-011) |
| WK-SCP0096-0154 | X-REOPEN | SCP0096 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0096 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 8 (ACT:SCP0096_Shipment_Working_Day_OSP.Dis) |

## W7 기대값 확정 (129)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0155 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0096-0156 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0096-0157 | B3 | D00-4b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-002: 행 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-002) |
| WK-SCP0096-0158 | B3 | SCP0096_Shipment_Working_Day_OSP.GetBuck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.GetBucketType: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0159 | B3 | SCP0096_Shipment_Working_Day_OSP.GetDayO | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.GetDayOfWeek: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0160 | B3 | SCP0096_Shipment_Working_Day_OSP.GetDayR | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.GetDayRange: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0161 | B3 | SCP0096_Shipment_Working_Day_OSP.GetSpdT | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.GetSpdTitle: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0162 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0096-0163 | B4 | D00-4b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-002: 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-002) |
| WK-SCP0096-0164 | B4 | SCP0096_Shipment_Working_Day_OSP.GetBuck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.GetBucketType: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0165 | B4 | SCP0096_Shipment_Working_Day_OSP.GetDayO | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.GetDayOfWeek: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0166 | B4 | SCP0096_Shipment_Working_Day_OSP.GetDayR | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.GetDayRange: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0167 | B4 | SCP0096_Shipment_Working_Day_OSP.GetSpdT | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.GetSpdTitle: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0168 | DB-SYN | CRUD:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CRUD:SAVE: 행 집계 — DB-SYN 5요소: PASS:4 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:SAVE) |
| WK-SCP0096-0169 | DB-SYN | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — CRUD:SEARCH: 행 집계 — DB-SYN 5요소: PASS:4 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:SEARCH) |
| WK-SCP0096-0170 | DB-SYN | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D00-3-021: 행 집계 — DB-SYN 5요소: PASS:4 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-021) |
| WK-SCP0096-0171 | F4 | CRUD:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CRUD:SAVE: 행 집계 — F4 5요소: NOT_RUN:4 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:SAVE) |
| WK-SCP0096-0172 | F4 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — CRUD:SEARCH: 행 집계 — F4 5요소: NOT_RUN:4 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:SEARCH) |
| WK-SCP0096-0173 | F4 | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-3-021: 행 집계 — F4 5요소: NOT_RUN:4 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-021) |
| WK-SCP0096-0174 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 7요소: PASS:6 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0096-0175 | G4 | D00-1-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-010: 행 집계 — G4 7요소: PASS:6 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-010) |
| WK-SCP0096-0176 | H2 | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-008: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-008) |
| WK-SCP0096-0177 | H2 | D00-1-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-009: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-009) |
| WK-SCP0096-0178 | H2 | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-007: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-007) |
| WK-SCP0096-0179 | H2 | D00-3-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-002: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-002) |
| WK-SCP0096-0180 | H2 | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-003: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-003) |
| WK-SCP0096-0181 | H2 | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-014: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-014) |
| WK-SCP0096-0182 | H2 | SCP0096_Shipment_Working_Day_OSP.CreateS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.CreateSpread: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Cre) |
| WK-SCP0096-0183 | H2 | SCP0096_Shipment_Working_Day_OSP.SetSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SetSpreadColumn: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0184 | H5 | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-008: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-008) |
| WK-SCP0096-0185 | H5 | D00-1-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-009: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-009) |
| WK-SCP0096-0186 | H5 | D00-3-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-002: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-002) |
| WK-SCP0096-0187 | H5 | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-014: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-014) |
| WK-SCP0096-0188 | H5 | SCP0096_Shipment_Working_Day_OSP.CreateS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.CreateSpread: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Cre) |
| WK-SCP0096-0189 | H5 | SCP0096_Shipment_Working_Day_OSP.SetSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SetSpreadColumn: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0190 | I1 | SCP0096 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | I1 기대값 확정 — SCP0096 화면: 게이트 I18N1 다국어 미적용 — 화면에 '_Invalid input value.' 가  |  | 12 (D00-4d-001 D00-4d-003 D00-4d-004 D00-4d-) |
| WK-SCP0096-0191 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태 신규행 Insert 시 필터 유지 (keepRowVisibleUnderFilter) — 이 화면은 신규행 Insert 없음(pivot 셀 편집 전용, Insert= |  | 1 (COMMON:UC-01) |
| WK-SCP0096-0192 | X-REASON | D00-2-006 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-006 §2 spdMain / CellDoubleClick (.cs:817-819) — SetDblClickColumnShowHide(컬럼 접기/펼치기) — D00-3-032 와 동일 신호 |  | 1 (D00-2-006) |
| WK-SCP0096-0193 | X-REASON | D00-3-020 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-020 §3 LockColumn / 405 (spdInfo 제목시트 잠금) — 제목/헤더 시트 편집 불가 = TO-BE 는 헤더가 columnGroups 표현 전용(편집 대상 아님) — 구 |  | 1 (D00-3-020) |
| WK-SCP0096-0194 | X-REASON | D00-3-032 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-032 §3 SetDblClickColumnShowHide / 819 — 더블클릭 컬럼 접기/펼치기 — AS-IS 부가기능(핵심 조회/편집/저장 무관), 전 화면 pivot 편의기능 미이식 |  | 1 (D00-3-032) |
| WK-SCP0096-0195 | X-REASON | MODAL:(none) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:(none) 팝업/모달 없음 — AS-IS SCP0096 은 팝업 없는 단일 화면(조회조건+pivot 편집 그리드) — 분석 md·FE 양쪽 모달 파일 0 해당없음 |  | 1 (MODAL:(none)) |
| WK-SCP0096-0196 | D1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — COMMON:UC-02: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0096-0197 | D1 | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-1-011: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-011) |
| WK-SCP0096-0198 | D1 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-002: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCP0096-0199 | D1 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-006: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SCP0096-0200 | D1 | SCP0096_Shipment_Working_Day_OSP.EditBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.EditButton: 진입점 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0096_Shipment_Working_Day_OSP.Edi) |
| WK-SCP0096-0201 | D3 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — COMMON:UC-02: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0096-0202 | D3 | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-1-011: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-011) |
| WK-SCP0096-0203 | D3 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-002: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCP0096-0204 | D3 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-006: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SCP0096-0205 | D3 | SCP0096_Shipment_Working_Day_OSP.EditBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.EditButton: 진입점 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0096_Shipment_Working_Day_OSP.Edi) |
| WK-SCP0096-0206 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0096-0207 | D5 | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — D00-4b-003: 행 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-003) |
| WK-SCP0096-0208 | D5 | SCP0096_Shipment_Working_Day_OSP.CreateS | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.CreateSpread: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Cre) |
| WK-SCP0096-0209 | D5 | SCP0096_Shipment_Working_Day_OSP.SetSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SetSpreadColumn: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0210 | E4 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CRUD:SEARCH: 행 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:SEARCH) |
| WK-SCP0096-0211 | E4 | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-3-021: 행 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-021) |
| WK-SCP0096-0212 | E4 | D00-4d-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-003: 행 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-003) |
| WK-SCP0096-0213 | E4 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-006: 행 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SCP0096-0214 | E4 | SCP0096_Shipment_Working_Day_OSP.SetLock | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SetLockSumColumn: 진입점 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0215 | E4 | SCP0096_Shipment_Working_Day_OSP.SetSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SetSpreadColumn: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0216 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-02) |
| WK-SCP0096-0217 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-03) |
| WK-SCP0096-0218 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-06) |
| WK-SCP0096-0219 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-07) |
| WK-SCP0096-0220 | A1 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:SEARCH) |
| WK-SCP0096-0221 | A1 | D00-1-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-010: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-1-010) |
| WK-SCP0096-0222 | A1 | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-011: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-1-011) |
| WK-SCP0096-0223 | A1 | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-021: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-3-021) |
| WK-SCP0096-0224 | A1 | D00-3-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-023: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-3-023) |
| WK-SCP0096-0225 | A1 | D00-3-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-024: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-3-024) |
| WK-SCP0096-0226 | A1 | D00-3-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-026: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-3-026) |
| WK-SCP0096-0227 | A1 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-004: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4b-004) |
| WK-SCP0096-0228 | A1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-001: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4d-001) |
| WK-SCP0096-0229 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 36 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0230 | A1 | PKG_SCP0019.P_SCP0019_GET_WORKING_TIME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0019.P_SCP0019_GET_WORKING_TIME: 골든 비교 케이스 없음(PKG_SCP0019.P_SCP0019_GET_WORKING_TIME — 팝업·보조 SP 는 golden_cases. |  | 37 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0231 | A1 | PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP: 골든 비교 케이스 없음(PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP —  |  | 38 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0232 | A6 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — CRUD:SEARCH: 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:SEARCH) |
| WK-SCP0096-0233 | A6 | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-3-021: 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-021) |
| WK-SCP0096-0234 | G03-WIRE | SCP0096 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0096 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 |  | 11 (ACT:SCP0096_Shipment_Working_Day_OSP..ct) |
| WK-SCP0096-0235 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0096-0236 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0096-0237 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0096-0238 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0096-0239 | G1 | CRUD:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CRUD:SEARCH: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:SEARCH) |
| WK-SCP0096-0240 | G1 | D00-1-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-010: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-010) |
| WK-SCP0096-0241 | G1 | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-021: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-021) |
| WK-SCP0096-0242 | G1 | D00-3-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-023: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-023) |
| WK-SCP0096-0243 | G1 | D00-3-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-024: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-024) |
| WK-SCP0096-0244 | G1 | D00-3-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-026: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-026) |
| WK-SCP0096-0245 | G1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4d-001: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0096-0246 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0096-0247 | G6 | D00-1-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-010: 행 집계 — G6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-010) |
| WK-SCP0096-0248 | X-ROW | D00-1-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-006) |
| WK-SCP0096-0249 | X-ROW | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-007) |
| WK-SCP0096-0250 | X-ROW | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-021: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-021) |
| WK-SCP0096-0251 | X-ROW | D00-3-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-004) |
| WK-SCP0096-0252 | X-ROW | D00-3-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-005) |
| WK-SCP0096-0253 | X-ROW | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-006) |
| WK-SCP0096-0254 | X-ROW | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-007) |
| WK-SCP0096-0255 | X-ROW | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-008) |
| WK-SCP0096-0256 | X-ROW | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-009: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-009) |
| WK-SCP0096-0257 | X-ROW | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-010) |
| WK-SCP0096-0258 | X-ROW | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-011) |
| WK-SCP0096-0259 | X-ROW | D00-3-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-012: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-012) |
| WK-SCP0096-0260 | X-ROW | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-013: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-013) |
| WK-SCP0096-0261 | X-ROW | D00-3-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-025: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-025) |
| WK-SCP0096-0262 | X-ROW | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-001) |
| WK-SCP0096-0263 | X-ROW | SCP0096_Shipment_Working_Day_OSP.BtnInpu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.BtnInput_Click: 진입점 집계 5검사 — NOT_RUN:3 · PASS:1 · WARN:1 |  | 5 (ACT:SCP0096_Shipment_Working_Day_OSP.Btn) |
| WK-SCP0096-0264 | X-ROW | SCP0096_Shipment_Working_Day_OSP.CboDayW | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.CboDayWeek_Select: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Cbo) |
| WK-SCP0096-0265 | X-ROW | SCP0096_Shipment_Working_Day_OSP.CboDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.CboDivision_Selec: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Cbo) |
| WK-SCP0096-0266 | X-ROW | SCP0096_Shipment_Working_Day_OSP.CreateS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Cre) |
| WK-SCP0096-0267 | X-ROW | SCP0096_Shipment_Working_Day_OSP.DefineP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.DefineProperty: 진입점 집계 3검사 — NOT_RUN:2 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Def) |
| WK-SCP0096-0268 | X-ROW | SCP0096_Shipment_Working_Day_OSP.FindBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.FindButton: 진입점 집계 9검사 — NOT_RUN:5 · REVIEW:3 · PASS:1 |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0269 | X-ROW | SCP0096_Shipment_Working_Day_OSP.FindDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.FindData_Main: 진입점 집계 16검사 — NOT_RUN:8 · PASS:4 · REVIEW:3 · WARN:1 |  | 8 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0270 | X-ROW | SCP0096_Shipment_Working_Day_OSP.Form_Lo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.For) |
| WK-SCP0096-0271 | X-ROW | SCP0096_Shipment_Working_Day_OSP.GetBuck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.GetBucketType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0272 | X-ROW | SCP0096_Shipment_Working_Day_OSP.GetSpdT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.GetSpdTitle: 진입점 집계 5검사 — PASS:2 · NOPATH:1 · TODO:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Get) |
| WK-SCP0096-0273 | X-ROW | SCP0096_Shipment_Working_Day_OSP.InitCon | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.InitControls: 진입점 집계 10검사 — NOT_RUN:7 · PASS:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |
| WK-SCP0096-0274 | X-ROW | SCP0096_Shipment_Working_Day_OSP.InitSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.InitSpread: 진입점 집계 9검사 — NOT_RUN:7 · PASS:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |
| WK-SCP0096-0275 | X-ROW | SCP0096_Shipment_Working_Day_OSP.InitSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.InitSpreadDateCol: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SCP0096_Shipment_Working_Day_OSP.Ini) |
| WK-SCP0096-0276 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SaveDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SaveData_Main: 진입점 집계 14검사 — PASS:6 · NOT_RUN:5 · NOPATH:2 · WARN:1 |  | 6 (ACT:SCP0096_Shipment_Working_Day_OSP.Sav) |
| WK-SCP0096-0277 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SetChangedControl: 진입점 집계 6검사 — NOT_RUN:4 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0278 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SetLock | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SetLockSumColumn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0279 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SetSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SetSpreadColumn: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0280 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SpdMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SpdMain_CellDoubl: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Spd) |
| WK-SCP0096-0281 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SpdMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Spd) |
| WK-SCP0096-0282 | X-ROW | SCP0096_Shipment_Working_Day_OSP.cboBuck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.cboBucketType_Sel: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.cbo) |
| WK-SCP0096-0283 | X-ROW | SCP0096_Shipment_Working_Day_OSP.chkSum_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.chkSum_CheckedCha: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.chk) |
