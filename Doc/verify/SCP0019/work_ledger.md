# 작업 원장 — SCP0019 · 2026-10-26 12:53

> 검사 인스턴스 510건 중 PASS·NA 64건 외 **446건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 86 | 구현 위치 실존 |
| W4 | 검사기 구현 | 7 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 44 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 108 | 실행 → PASS |
| W7 | 기대값 확정 | 201 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 191 · E2E 108 · 대조표 96 · 하네스 51
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 86 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 50 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 27 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| E4 | EDIT |  |  |  |  |  | 16 | 9 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G1 | GEN |  |  |  |  |  | 7 | 15 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| B4 | COMBO |  |  |  |  | 11 |  | 10 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A5 | DESIGN |  |  |  |  |  | 5 | 15 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| B3 | COMBO |  |  |  | 7 |  |  | 10 |  |  | 콤보 후보 정렬 = AS-IS |
| C3 | CASCADE |  |  |  |  |  | 1 | 15 |  |  | 연쇄 자동 채움 |
| G4 | DESIGN |  |  |  |  | 1 | 9 | 2 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 9 | 3 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| D1 | EDIT |  |  |  |  |  | 5 | 6 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 5 | 6 |  |  | 행 값 기반 조건부 잠금 |
| H2 | DESIGN |  |  |  |  |  | 4 | 6 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 6 | 4 |  |  | 라벨 명칭 |
| X-REASON | DESIGN |  |  |  |  |  |  | 10 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B1 | COMBO |  |  |  |  | 8 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 8 |  |  |  |  | 콤보 후보 중복 없음 |
| F4 | DB |  |  |  |  |  | 6 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| C1 | CASCADE |  |  |  |  |  | 7 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| D5 | EDIT |  |  |  |  |  | 5 | 2 |  |  | 셀 에디터 유형 |
| B6 | COMBO |  |  |  |  | 6 |  |  |  |  | ALL 옵션·다중선택 사양 |
| G5 | POPUP |  |  |  |  | 4 |  | 1 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 2 | 1 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 4 | 1 |  |  | 팝업 선택값 반영 |
| C4 | CASCADE |  |  |  |  |  | 4 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| DB-SYN | DB |  |  |  |  | 1 |  | 2 |  |  | BE 계정 시노님·권한·대상 객체 |
| A6 | GEN |  |  |  |  |  | 3 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| E1 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 숫자 소수자리·정수·부호·범위 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| E5 | EDIT |  |  |  |  | 1 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| I1 | DESIGN |  |  |  |  |  |  | 1 |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  |  | 1 |  |  | 조회조건 순서 = 기준표 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |

## W2 구현 위치 확인 (86)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0019-0001 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-02) |
| WK-SCP0019-0002 | X-LOC | COMMON:UC-03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-03) |
| WK-SCP0019-0003 | X-LOC | COMMON:UC-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-04) |
| WK-SCP0019-0004 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0019-0005 | X-LOC | COMMON:UC-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-06) |
| WK-SCP0019-0006 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-07) |
| WK-SCP0019-0007 | X-LOC | D00-1-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-001) |
| WK-SCP0019-0008 | X-LOC | D00-1-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-003) |
| WK-SCP0019-0009 | X-LOC | D00-1-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-004) |
| WK-SCP0019-0010 | X-LOC | D00-1-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-006) |
| WK-SCP0019-0011 | X-LOC | D00-1-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-007) |
| WK-SCP0019-0012 | X-LOC | D00-1-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-008) |
| WK-SCP0019-0013 | X-LOC | D00-1-009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-009) |
| WK-SCP0019-0014 | X-LOC | D00-1-011 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-011) |
| WK-SCP0019-0015 | X-LOC | D00-1-032 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-032) |
| WK-SCP0019-0016 | X-LOC | D00-1-033 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-033) |
| WK-SCP0019-0017 | X-LOC | D00-1-034 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-034) |
| WK-SCP0019-0018 | X-LOC | D00-1-036 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-036) |
| WK-SCP0019-0019 | X-LOC | D00-2-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-001) |
| WK-SCP0019-0020 | X-LOC | D00-2-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-003) |
| WK-SCP0019-0021 | X-LOC | D00-2-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-004) |
| WK-SCP0019-0022 | X-LOC | D00-2-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-007) |
| WK-SCP0019-0023 | X-LOC | D00-2-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-008) |
| WK-SCP0019-0024 | X-LOC | D00-2-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-010) |
| WK-SCP0019-0025 | X-LOC | D00-3-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-001) |
| WK-SCP0019-0026 | X-LOC | D00-3-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-002) |
| WK-SCP0019-0027 | X-LOC | D00-3-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-003) |
| WK-SCP0019-0028 | X-LOC | D00-3-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-004) |
| WK-SCP0019-0029 | X-LOC | D00-3-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-005) |
| WK-SCP0019-0030 | X-LOC | D00-3-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-006) |
| WK-SCP0019-0031 | X-LOC | D00-3-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-007) |
| WK-SCP0019-0032 | X-LOC | D00-3-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-008) |
| WK-SCP0019-0033 | X-LOC | D00-3-009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-009) |
| WK-SCP0019-0034 | X-LOC | D00-3-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-010) |
| WK-SCP0019-0035 | X-LOC | D00-3-012 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-012) |
| WK-SCP0019-0036 | X-LOC | D00-3-013 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-013) |
| WK-SCP0019-0037 | X-LOC | D00-3-014 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-014) |
| WK-SCP0019-0038 | X-LOC | D00-3-015 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-015) |
| WK-SCP0019-0039 | X-LOC | D00-3-016 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-016) |
| WK-SCP0019-0040 | X-LOC | D00-3-018 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-018) |
| WK-SCP0019-0041 | X-LOC | D00-3-019 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-019) |
| WK-SCP0019-0042 | X-LOC | D00-3-021 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-021) |
| WK-SCP0019-0043 | X-LOC | D00-3-022 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-022) |
| WK-SCP0019-0044 | X-LOC | D00-3-024 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-024) |
| WK-SCP0019-0045 | X-LOC | D00-3-025 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-025) |
| WK-SCP0019-0046 | X-LOC | D00-3-026 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-026) |
| WK-SCP0019-0047 | X-LOC | D00-3-029 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-029) |
| WK-SCP0019-0048 | X-LOC | D00-3-030 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-030) |
| WK-SCP0019-0049 | X-LOC | D00-3-031 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-031) |
| WK-SCP0019-0050 | X-LOC | D00-3-032 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-032) |
| WK-SCP0019-0051 | X-LOC | D00-3-033 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-033) |
| WK-SCP0019-0052 | X-LOC | D00-3-034 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-034) |
| WK-SCP0019-0053 | X-LOC | D00-3-035 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-035) |
| WK-SCP0019-0054 | X-LOC | D00-3-036 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-3-036) |
| WK-SCP0019-0055 | X-LOC | D00-4b-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-001) |
| WK-SCP0019-0056 | X-LOC | D00-4b-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-002) |
| WK-SCP0019-0057 | X-LOC | D00-4b-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-003) |
| WK-SCP0019-0058 | X-LOC | D00-4b-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-004) |
| WK-SCP0019-0059 | X-LOC | D00-4b-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-005) |
| WK-SCP0019-0060 | X-LOC | D00-4b-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-006) |
| WK-SCP0019-0061 | X-LOC | D00-4b-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-007) |
| WK-SCP0019-0062 | X-LOC | D00-4b-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-008) |
| WK-SCP0019-0063 | X-LOC | D00-4b-009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-009) |
| WK-SCP0019-0064 | X-LOC | D00-4b-010 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-010) |
| WK-SCP0019-0065 | X-LOC | D00-4b-011 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-011) |
| WK-SCP0019-0066 | X-LOC | D00-4b-012 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-012) |
| WK-SCP0019-0067 | X-LOC | D00-4b-013 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4b-013) |
| WK-SCP0019-0068 | X-LOC | D00-4c-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4c-001) |
| WK-SCP0019-0069 | X-LOC | D00-4c-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4c-002) |
| WK-SCP0019-0070 | X-LOC | D00-4c-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4c-003) |
| WK-SCP0019-0071 | X-LOC | D00-4d-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-001) |
| WK-SCP0019-0072 | X-LOC | D00-4d-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-002) |
| WK-SCP0019-0073 | X-LOC | D00-4d-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-003) |
| WK-SCP0019-0074 | X-LOC | D00-4d-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-004) |
| WK-SCP0019-0075 | X-LOC | D00-4d-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-005) |
| WK-SCP0019-0076 | X-LOC | D00-4d-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-006) |
| WK-SCP0019-0077 | X-LOC | D00-4d-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4d-007) |
| WK-SCP0019-0078 | X-LOC | D00-4e-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-001) |
| WK-SCP0019-0079 | X-LOC | D00-4e-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-002) |
| WK-SCP0019-0080 | X-LOC | D00-4e-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-003) |
| WK-SCP0019-0081 | X-LOC | D00-4e-004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-004) |
| WK-SCP0019-0082 | X-LOC | D00-4e-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-005) |
| WK-SCP0019-0083 | X-LOC | D00-4e-006 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-006) |
| WK-SCP0019-0084 | X-LOC | D00-4e-007 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-007) |
| WK-SCP0019-0085 | X-LOC | D00-4e-008 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-008) |
| WK-SCP0019-0086 | X-LOC | D00-4e-009 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-4e-009) |

## W4 검사기 구현 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0019-0087 | B3 | COLUMN_NAME | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 COLUMN_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0019_WorkingTime.GetDayOfWeek ACT) |
| WK-SCP0019-0088 | B3 | DAY_CODE | 하네스(검증 엔진 _trace.spec.ts) + 구현 확인(TO-BE  | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DAY_CODE | 없음 | 2 (ACT:SCP0019_WorkingTime.GetDayOfWeek ACT) |
| WK-SCP0019-0089 | B3 | FACTORY_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 FACTORY_ID | 있음(SHEET_COLUMNS) | 1 (D00-4b-004) |
| WK-SCP0019-0090 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:SCP0019_WorkingTime.GetDayRange ACT:) |
| WK-SCP0019-0091 | B3 | cboDayWeek / Day of the week / Day Week | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDayWeek / Day of the week / Day Week | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0019-0092 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0019_WorkingTime.GetDayRange ACT:) |
| WK-SCP0019-0093 | B3 | clbPlantSite / Plant Site | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-4b-007) |

## W5 검사기 연결 (44)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0019-0094 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0019-0095 | B1 | FACTORY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL FACTORY_ID | 있음(SHEET_COLUMNS) | 1 (D00-1-006) |
| WK-SCP0019-0096 | B1 | cboDayWeek / Day of the week / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDayWeek / Day of the week / Day Week | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0019-0097 | B1 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-004) |
| WK-SCP0019-0098 | B1 | clbBuilding / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbBuilding / Building | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0019-0099 | B1 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0019-0100 | B1 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0019-0101 | B1 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0019-0102 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0019-0103 | B2 | FACTORY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL FACTORY_ID | 있음(SHEET_COLUMNS) | 1 (D00-1-006) |
| WK-SCP0019-0104 | B2 | cboDayWeek / Day of the week / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDayWeek / Day of the week / Day Week | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0019-0105 | B2 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-004) |
| WK-SCP0019-0106 | B2 | clbBuilding / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbBuilding / Building | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0019-0107 | B2 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0019-0108 | B2 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0019-0109 | B2 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0019-0110 | B4 | COLUMN_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL COLUMN_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0019_WorkingTime.GetDayOfWeek ACT) |
| WK-SCP0019-0111 | B4 | DAY_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DAY_CODE | 없음 | 2 (ACT:SCP0019_WorkingTime.GetDayOfWeek ACT) |
| WK-SCP0019-0112 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0019-0113 | B4 | FACTORY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FACTORY_ID | 있음(SHEET_COLUMNS) | 2 (D00-1-006 D00-4b-004) |
| WK-SCP0019-0114 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:SCP0019_WorkingTime.GetDayRange ACT:) |
| WK-SCP0019-0115 | B4 | cboDayWeek / Day of the week / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDayWeek / Day of the week / Day Week | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0019-0116 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 3 (D00-1-004 ACT:SCP0019_WorkingTime.GetDay) |
| WK-SCP0019-0117 | B4 | clbBuilding / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbBuilding / Building | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0019-0118 | B4 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0019-0119 | B4 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0019-0120 | B4 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 2 (D00-1-009 D00-4b-007) |
| WK-SCP0019-0121 | B6 | cboDayWeek / Day of the week / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDayWeek / Day of the week / Day Week | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0019-0122 | B6 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-004) |
| WK-SCP0019-0123 | B6 | clbBuilding / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbBuilding / Building | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0019-0124 | B6 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0019-0125 | B6 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0019-0126 | B6 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0019-0127 | F2 | SCP0019 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0019 화면 | 판단불가(대상 단위 SCREEN) | 122 (D00-1-001 D00-4d-002 D00-4e-001 D00-4e-0) |
| WK-SCP0019-0128 | F6 | SCP0019 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0019 화면 | 판단불가(대상 단위 SCREEN) | 115 (D00-4e-002 D00-4e-004 ACT:SCP0019_Workin) |
| WK-SCP0019-0129 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0019_WorkingTime.GetBucketType:57) |
| WK-SCP0019-0130 | G4 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnInput | 있음(FE 소스) | 3 (D00-1-001 ACT:SCP0019_WorkingTime.InitEv) |
| WK-SCP0019-0131 | E5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0019-0132 | G5 | OSP_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL OSP_YN | 있음(SHEET_COLUMNS) | 1 (D00-2-001) |
| WK-SCP0019-0133 | G5 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnInput | 있음(FE 소스) | 3 (D00-1-001 D00-2-001 D00-3-029) |
| WK-SCP0019-0134 | G5 | cboDayWeek / Day of the week / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDayWeek / Day of the week / Day Week | 있음(FE 소스) | 2 (D00-1-003 D00-2-003) |
| WK-SCP0019-0135 | G5 | txtInpuValue / Input Value / Inpu Value | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtInpuValue / Input Value / Inpu Value | 있음(FE 소스) | 1 (D00-1-034) |
| WK-SCP0019-0136 | H6 | OSP_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL OSP_YN | 있음(SHEET_COLUMNS) | 1 (D00-2-001) |
| WK-SCP0019-0137 | H6 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnInput | 있음(FE 소스) | 3 (D00-1-001 D00-2-001 D00-3-029) |

## W6 검증 실행 (108)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0019-0138 | J2 | SCP0019 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0019 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 101 (D00-1-001 D00-1-003 D00-1-034 D00-1-036 ) |
| WK-SCP0019-0139 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0019_WorkingTime.InitControls:217) |
| WK-SCP0019-0140 | C1 | cboDayWeek / Day of the week / Day Week | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDayWeek / Day of the week / Day Week · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-003 ACT:SCP0019_WorkingTime.InitCo) |
| WK-SCP0019-0141 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-004 ACT:SCP0019_WorkingTime.InitCo) |
| WK-SCP0019-0142 | C1 | clbBuilding / Building | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbBuilding / Building · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0019_WorkingTime.RefreshBuilding:) |
| WK-SCP0019-0143 | C1 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0019_WorkingTime.RefreshLine:655:) |
| WK-SCP0019-0144 | C1 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-007 ACT:SCP0019_WorkingTime.Refres) |
| WK-SCP0019-0145 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-008 ACT:SCP0019_WorkingTime.Refres) |
| WK-SCP0019-0146 | C3 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0019_WorkingTime.SetSpreadColumn ) |
| WK-SCP0019-0147 | C4 | cboDayWeek / Day of the week / Day Week | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDayWeek / Day of the week / Day Week · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-003) |
| WK-SCP0019-0148 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-004) |
| WK-SCP0019-0149 | C4 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-007) |
| WK-SCP0019-0150 | C4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-008) |
| WK-SCP0019-0151 | G3 | SCP0019 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0019 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (D00-1-036 COMMON:UC-02 COMMON:UC-03 COMM) |
| WK-SCP0019-0152 | K-SA | SCP0019 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0019 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (D00-1-036) |
| WK-SCP0019-0153 | K4 | SCP0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0019 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 69 (COMMON:UC-02 COMMON:UC-03 COMMON:UC-04 C) |
| WK-SCP0019-0154 | F1 | SCP0019 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0019 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 122 (D00-1-001 D00-4d-002 D00-4e-001 D00-4e-0) |
| WK-SCP0019-0155 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0019_WorkingTime.GetBucketType:57) |
| WK-SCP0019-0156 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 1 (D00-4b-013) |
| WK-SCP0019-0157 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 159 (ACT:SCP0019_WorkingTime.FindButton ACT:S) |
| WK-SCP0019-0158 | F4 | PKG_SCP0019.P_SCP0019_GET_WORKING_TIME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0019.P_SCP0019_GET_WORKING_TIME · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 160 (ACT:SCP0019_WorkingTime.FindButton ACT:S) |
| WK-SCP0019-0159 | F4 | PKG_SCP0019.P_SCP0019_SAVE_WORKING_TIME_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0019.P_SCP0019_SAVE_WORKING_TIME_ROW · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 113 (ACT:SCP0019_WorkingTime.SaveButton ACT:S) |
| WK-SCP0019-0160 | F4 | SCM0001_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0019_WorkingTime.GetDivision:1456) |
| WK-SCP0019-0161 | A5 | FACTORY_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (D00-1-006 D00-4b-004 D00-4c-002) |
| WK-SCP0019-0162 | A5 | MEASURE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MEASURE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0019_WorkingTime.SetSpreadColumn ) |
| WK-SCP0019-0163 | A5 | OSP_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OSP_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0019_WorkingTime.InitSpread ACT:S) |
| WK-SCP0019-0164 | A5 | PLANT_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0019_WorkingTime.InitSpread:246:2) |
| WK-SCP0019-0165 | A5 | WORKING_TIME_DEFAULT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — WORKING_TIME_DEFAULT · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Div |  | 2 (ACT:SCP0019_WorkingTime.InitSpread ACT:S) |
| WK-SCP0019-0166 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0019_WorkingTime.DefineProperty A) |
| WK-SCP0019-0167 | G4 | cboDayWeek / Day of the week / Day Week | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDayWeek / Day of the week / Day Week · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (D00-1-003 D00-2-003 ACT:SCP0019_WorkingT) |
| WK-SCP0019-0168 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (D00-1-004 ACT:SCP0019_WorkingTime.InitCo) |
| WK-SCP0019-0169 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0019_WorkingTime.DefineProperty A) |
| WK-SCP0019-0170 | G4 | clbBuilding / Building | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbBuilding / Building · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-006 ACT:SCP0019_WorkingTime.InitEv) |
| WK-SCP0019-0171 | G4 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbLine / Line · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-007) |
| WK-SCP0019-0172 | G4 | clbOperation / Operation | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbOperation / Operation · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-008 ACT:SCP0019_WorkingTime.InitEv) |
| WK-SCP0019-0173 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-009 ACT:SCP0019_WorkingTime.InitEv) |
| WK-SCP0019-0174 | G4 | txtInpuValue / Input Value / Inpu Value | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtInpuValue / Input Value / Inpu Value · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-034) |
| WK-SCP0019-0175 | H2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0019_WorkingTime.SetSpreadColumn ) |
| WK-SCP0019-0176 | H2 | OSP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OSP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (D00-3-015 ACT:SCP0019_WorkingTime.InitSp) |
| WK-SCP0019-0177 | H2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0019_WorkingTime.InitSpread:246:2) |
| WK-SCP0019-0178 | H2 | WORKING_TIME_DEFAULT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — WORKING_TIME_DEFAULT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0019_WorkingTime.InitSpread ACT:S) |
| WK-SCP0019-0179 | H4 | SCP0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0019 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 5 (D00-2-010 ACT:SCP0019_WorkingTime.SpdMai) |
| WK-SCP0019-0180 | H5 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEASURE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0019_WorkingTime.SetSpreadColumn ) |
| WK-SCP0019-0181 | H5 | OSP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OSP_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0019_WorkingTime.InitSpread ACT:S) |
| WK-SCP0019-0182 | H5 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLANT_SITE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCP0019_WorkingTime.InitSpread:246:2) |
| WK-SCP0019-0183 | H5 | WORKING_TIME_DEFAULT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — WORKING_TIME_DEFAULT · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0019_WorkingTime.InitSpread ACT:S) |
| WK-SCP0019-0184 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 18 (ACT:SCP0019_WorkingTime.SetSpreadColumn ) |
| WK-SCP0019-0185 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SCP0019_WorkingTime.SetSpreadColumn ) |
| WK-SCP0019-0186 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (D00-3-012 ACT:SCP0019_WorkingTime.EditBu) |
| WK-SCP0019-0187 | D1 | LAST_INPUT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_INPUT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (D00-3-013 ACT:SCP0019_WorkingTime.EditBu) |
| WK-SCP0019-0188 | D1 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-3-012 ACT:SCP0019_WorkingTime.EditBu) |
| WK-SCP0019-0189 | D1 | OSP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OSP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (D00-3-013 D00-3-014 D00-3-015 D00-4d-002) |
| WK-SCP0019-0190 | D1 | WORKING_TIME_DEFAULT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — WORKING_TIME_DEFAULT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (D00-3-001) |
| WK-SCP0019-0191 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (D00-3-012 ACT:SCP0019_WorkingTime.EditBu) |
| WK-SCP0019-0192 | D3 | LAST_INPUT_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_INPUT_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (D00-3-013 ACT:SCP0019_WorkingTime.EditBu) |
| WK-SCP0019-0193 | D3 | LINE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LINE_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-3-012 ACT:SCP0019_WorkingTime.EditBu) |
| WK-SCP0019-0194 | D3 | OSP_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OSP_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (D00-3-013 D00-3-014 D00-3-015 D00-4d-002) |
| WK-SCP0019-0195 | D3 | WORKING_TIME_DEFAULT | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — WORKING_TIME_DEFAULT · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (D00-3-001) |
| WK-SCP0019-0196 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0019-0197 | D5 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0019_WorkingTime.SetSpreadColumn ) |
| WK-SCP0019-0198 | D5 | OSP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — OSP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0019_WorkingTime.InitSpread ACT:S) |
| WK-SCP0019-0199 | D5 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCP0019_WorkingTime.InitSpread:246:2) |
| WK-SCP0019-0200 | D5 | WORKING_TIME_DEFAULT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — WORKING_TIME_DEFAULT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0019_WorkingTime.InitSpread ACT:S) |
| WK-SCP0019-0201 | D6 | SCP0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0019 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (COMMON:UC-03) |
| WK-SCP0019-0202 | E1 | WORKING_TIME_DEFAULT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — WORKING_TIME_DEFAULT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (D00-3-001) |
| WK-SCP0019-0203 | E4 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0019_WorkingTime.SetSpreadColumn ) |
| WK-SCP0019-0204 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4e-004 ACT:SCP0019_WorkingTime.SaveD) |
| WK-SCP0019-0205 | E4 | MSG00050 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00050 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4e-009 ACT:SCP0019_WorkingTime.BtnIn) |
| WK-SCP0019-0206 | E4 | MSG00134 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00134 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-4d-004 D00-4e-008 ACT:SCP0019_Workin) |
| WK-SCP0019-0207 | E4 | MSG00135 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00135 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (D00-2-001 D00-4d-001 D00-4e-007 ACT:SCP0) |
| WK-SCP0019-0208 | E4 | MSG00203 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00203 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (D00-4e-002 D00-4e-003 ACT:SCP0019_Workin) |
| WK-SCP0019-0209 | E4 | MSG00662 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00662 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4e-007) |
| WK-SCP0019-0210 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0019-0211 | E4 | MSG01037 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01037 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4e-002 D00-4e-003) |
| WK-SCP0019-0212 | E4 | MSG01082 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01082 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4e-009) |
| WK-SCP0019-0213 | E4 | MSG01153 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01153 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4e-008) |
| WK-SCP0019-0214 | E4 | OSP_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OSP_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-2-001 D00-4d-002 D00-4d-006) |
| WK-SCP0019-0215 | E4 | WORKING_TIME_DEFAULT | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — WORKING_TIME_DEFAULT · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 1 (D00-4e-002) |
| WK-SCP0019-0216 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 18 (ACT:SCP0019_WorkingTime.SetSpreadColumn ) |
| WK-SCP0019-0217 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 6 (ACT:SCP0019_WorkingTime.SetChangedContro) |
| WK-SCP0019-0218 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0019_WorkingTime.SetSpreadColumn ) |
| WK-SCP0019-0219 | A10 | SCP0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0019 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 82 (ACT:SCP0019_WorkingTime.DefineProperty A) |
| WK-SCP0019-0220 | A6 | PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회 |  | 1 (D00-4b-013) |
| WK-SCP0019-0221 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 47 (ACT:SCP0019_WorkingTime.FindButton ACT:S) |
| WK-SCP0019-0222 | A6 | PKG_SCP0019.P_SCP0019_GET_WORKING_TIME | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0019.P_SCP0019_GET_WORKING_TIME · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 50 (ACT:SCP0019_WorkingTime.FindButton ACT:S) |
| WK-SCP0019-0223 | G1 | cboDayWeek / Day of the week / Day Week | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDayWeek / Day of the week / Day Week · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (D00-1-003 D00-2-003) |
| WK-SCP0019-0224 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-004 ACT:SCP0019_WorkingTime.FindDa) |
| WK-SCP0019-0225 | G1 | clbBuilding / Building | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbBuilding / Building · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (D00-1-006 D00-4b-010 D00-4b-011 ACT:SCP0) |
| WK-SCP0019-0226 | G1 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbLine / Line · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-007 ACT:SCP0019_WorkingTime.FindDa) |
| WK-SCP0019-0227 | G1 | clbOperation / Operation | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbOperation / Operation · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (D00-1-008 D00-4b-012 ACT:SCP0019_Working) |
| WK-SCP0019-0228 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (D00-1-009 D00-4b-007 D00-4b-008 D00-4b-0) |
| WK-SCP0019-0229 | G1 | txtInpuValue / Input Value / Inpu Value | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtInpuValue / Input Value / Inpu Value · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-034) |
| WK-SCP0019-0230 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SCP0019_WorkingTime.DefineProperty A) |
| WK-SCP0019-0231 | G6 | cboDayWeek / Day of the week / Day Week | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDayWeek / Day of the week / Day Week · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (D00-1-003 D00-2-003 ACT:SCP0019_WorkingT) |
| WK-SCP0019-0232 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-004 ACT:SCP0019_WorkingTime.InitCo) |
| WK-SCP0019-0233 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0019_WorkingTime.DefineProperty A) |
| WK-SCP0019-0234 | G6 | clbBuilding / Building | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbBuilding / Building · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-006 ACT:SCP0019_WorkingTime.InitEv) |
| WK-SCP0019-0235 | G6 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-007) |
| WK-SCP0019-0236 | G6 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-008 ACT:SCP0019_WorkingTime.InitEv) |
| WK-SCP0019-0237 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-009 ACT:SCP0019_WorkingTime.InitEv) |
| WK-SCP0019-0238 | G6 | txtInpuValue / Input Value / Inpu Value | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtInpuValue / Input Value / Inpu Value · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-034) |
| WK-SCP0019-0239 | X-REOPEN | SCP0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0019 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 9 (ACT:SCP0019_WorkingTime.Dispose ACT:SCP0) |
| WK-SCP0019-0240 | H6 | cboDayWeek / Day of the week / Day Week | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDayWeek / Day of the week / Day Week · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (D00-1-003 D00-2-003) |
| WK-SCP0019-0241 | H6 | txtInpuValue / Input Value / Inpu Value | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtInpuValue / Input Value / Inpu Value · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (D00-1-034) |
| WK-SCP0019-0242 | M4 | OSP_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — OSP_YN · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-2-001) |
| WK-SCP0019-0243 | M4 | btnInput | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnInput · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (D00-1-001 D00-2-001 D00-3-029) |
| WK-SCP0019-0244 | M4 | cboDayWeek / Day of the week / Day Week | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDayWeek / Day of the week / Day Week · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (D00-1-003 D00-2-003) |
| WK-SCP0019-0245 | M4 | txtInpuValue / Input Value / Inpu Value | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtInpuValue / Input Value / Inpu Value · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-1-034) |

## W7 기대값 확정 (201)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0019-0246 | C3 | D00-3-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-032: 행 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-032) |
| WK-SCP0019-0247 | C3 | D00-3-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-033: 행 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-033) |
| WK-SCP0019-0248 | C3 | D00-3-034 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-034: 행 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-034) |
| WK-SCP0019-0249 | C3 | D00-3-035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-035: 행 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-035) |
| WK-SCP0019-0250 | C3 | D00-3-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-036: 행 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-036) |
| WK-SCP0019-0251 | C3 | SCP0019_WorkingTime.CboDayWeek_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0019_WorkingTime.CboDayWeek_SelectedIndexChange: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0019_WorkingTime.CboDayWeek_Selec) |
| WK-SCP0019-0252 | C3 | SCP0019_WorkingTime.CboDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0019_WorkingTime.CboDivision_SelectedIndexChang: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.CboDivision_Sele) |
| WK-SCP0019-0253 | C3 | SCP0019_WorkingTime.ClbBuilding_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0019_WorkingTime.ClbBuilding_SelectedIndexChang: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.ClbBuilding_Sele) |
| WK-SCP0019-0254 | C3 | SCP0019_WorkingTime.ClbOperation_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0019_WorkingTime.ClbOperation_SelectedIndexChan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.ClbOperation_Sel) |
| WK-SCP0019-0255 | C3 | SCP0019_WorkingTime.ClbPlantSite_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0019_WorkingTime.ClbPlantSite_SelectedIndexChan: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0019_WorkingTime.ClbPlantSite_Sel) |
| WK-SCP0019-0256 | C3 | SCP0019_WorkingTime.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0019_WorkingTime.SetChangedPeriod: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0019_WorkingTime.SetChangedPeriod) |
| WK-SCP0019-0257 | C3 | SCP0019_WorkingTime.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0019_WorkingTime.SetLockSumColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.SetLockSumColumn) |
| WK-SCP0019-0258 | C3 | SCP0019_WorkingTime.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0019_WorkingTime.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.SetSpreadColumn:) |
| WK-SCP0019-0259 | C3 | SCP0019_WorkingTime.cboBucketType_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0019_WorkingTime.cboBucketType_SelectedIndexCha: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0019_WorkingTime.cboBucketType_Se) |
| WK-SCP0019-0260 | C3 | SCP0019_WorkingTime.chkSum_CheckedChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0019_WorkingTime.chkSum_CheckedChanged: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0019_WorkingTime.chkSum_CheckedCh) |
| WK-SCP0019-0261 | B3 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-001: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0019-0262 | B3 | D00-4b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-002: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-002) |
| WK-SCP0019-0263 | B3 | SCP0019_WorkingTime.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0019_WorkingTime.GetBucketType: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.GetBucketType:57) |
| WK-SCP0019-0264 | B3 | SCP0019_WorkingTime.GetDayOfWeek | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0019_WorkingTime.GetDayOfWeek: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0019_WorkingTime.GetDayOfWeek:136) |
| WK-SCP0019-0265 | B3 | SCP0019_WorkingTime.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0019_WorkingTime.GetDayRange: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.GetDayRange:1519) |
| WK-SCP0019-0266 | B3 | SCP0019_WorkingTime.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0019_WorkingTime.GetDivision: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.GetDivision:1453) |
| WK-SCP0019-0267 | B3 | SCP0019_WorkingTime.GetShipToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0019_WorkingTime.GetShipToParty: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.GetShipToParty:1) |
| WK-SCP0019-0268 | B3 | SCP0019_WorkingTime.GetShipType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0019_WorkingTime.GetShipType: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.GetShipType:1476) |
| WK-SCP0019-0269 | B3 | SCP0019_WorkingTime.GetSoldToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0019_WorkingTime.GetSoldToParty: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.GetSoldToParty:1) |
| WK-SCP0019-0270 | B3 | SCP0019_WorkingTime.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0019_WorkingTime.GetSpdTitle: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0019_WorkingTime.GetSpdTitle:1491) |
| WK-SCP0019-0271 | B4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-001: 행 집계 — B4 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0019-0272 | B4 | D00-4b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-002: 행 집계 — B4 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-002) |
| WK-SCP0019-0273 | B4 | SCP0019_WorkingTime.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0019_WorkingTime.GetBucketType: 진입점 집계 — B4 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.GetBucketType:57) |
| WK-SCP0019-0274 | B4 | SCP0019_WorkingTime.GetDayOfWeek | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0019_WorkingTime.GetDayOfWeek: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0019_WorkingTime.GetDayOfWeek:136) |
| WK-SCP0019-0275 | B4 | SCP0019_WorkingTime.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0019_WorkingTime.GetDayRange: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.GetDayRange:1519) |
| WK-SCP0019-0276 | B4 | SCP0019_WorkingTime.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0019_WorkingTime.GetDivision: 진입점 집계 — B4 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.GetDivision:1453) |
| WK-SCP0019-0277 | B4 | SCP0019_WorkingTime.GetShipToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0019_WorkingTime.GetShipToParty: 진입점 집계 — B4 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.GetShipToParty:1) |
| WK-SCP0019-0278 | B4 | SCP0019_WorkingTime.GetShipType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0019_WorkingTime.GetShipType: 진입점 집계 — B4 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.GetShipType:1476) |
| WK-SCP0019-0279 | B4 | SCP0019_WorkingTime.GetSoldToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0019_WorkingTime.GetSoldToParty: 진입점 집계 — B4 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.GetSoldToParty:1) |
| WK-SCP0019-0280 | B4 | SCP0019_WorkingTime.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0019_WorkingTime.GetSpdTitle: 진입점 집계 — B4 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0019_WorkingTime.GetSpdTitle:1491) |
| WK-SCP0019-0281 | DB-SYN | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D00-4e-002: 행 집계 — DB-SYN 6요소: PASS:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SCP0019-0282 | DB-SYN | D00-4e-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D00-4e-004: 행 집계 — DB-SYN 6요소: PASS:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-004) |
| WK-SCP0019-0283 | F4 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-4e-002: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SCP0019-0284 | F4 | D00-4e-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-4e-004: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-004) |
| WK-SCP0019-0285 | A5 | D00-1-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-032: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-032) |
| WK-SCP0019-0286 | A5 | D00-1-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-033: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-033) |
| WK-SCP0019-0287 | A5 | D00-1-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-036: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-036) |
| WK-SCP0019-0288 | A5 | D00-3-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-016: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-016) |
| WK-SCP0019-0289 | A5 | D00-3-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-018: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-018) |
| WK-SCP0019-0290 | A5 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-019: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-SCP0019-0291 | A5 | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-021: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-021) |
| WK-SCP0019-0292 | A5 | D00-3-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-022: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-022) |
| WK-SCP0019-0293 | A5 | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-029: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-029) |
| WK-SCP0019-0294 | A5 | D00-4b-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4b-007: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-007) |
| WK-SCP0019-0295 | A5 | D00-4b-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4b-010: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-010) |
| WK-SCP0019-0296 | A5 | D00-4b-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4b-011: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-011) |
| WK-SCP0019-0297 | A5 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4d-001: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0019-0298 | A5 | SCP0019_WorkingTime.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0019_WorkingTime.CreateSpread: 진입점 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0019_WorkingTime.CreateSpread:229) |
| WK-SCP0019-0299 | A5 | SCP0019_WorkingTime.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0019_WorkingTime.SetSpreadColumn: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.SetSpreadColumn:) |
| WK-SCP0019-0300 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 10요소: NOT_RUN:9 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0019-0301 | G4 | D00-1-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-036: 행 집계 — G4 10요소: NOT_RUN:9 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-036) |
| WK-SCP0019-0302 | H2 | D00-1-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-032: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-032) |
| WK-SCP0019-0303 | H2 | D00-1-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-033: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-033) |
| WK-SCP0019-0304 | H2 | D00-2-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-010: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-010) |
| WK-SCP0019-0305 | H2 | D00-3-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-004: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-004) |
| WK-SCP0019-0306 | H2 | SCP0019_WorkingTime.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0019_WorkingTime.CreateSpread: 진입점 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0019_WorkingTime.CreateSpread:229) |
| WK-SCP0019-0307 | H2 | SCP0019_WorkingTime.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0019_WorkingTime.SetSpreadColumn: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.SetSpreadColumn:) |
| WK-SCP0019-0308 | H5 | D00-1-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-032: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-032) |
| WK-SCP0019-0309 | H5 | D00-1-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-033: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-033) |
| WK-SCP0019-0310 | H5 | SCP0019_WorkingTime.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0019_WorkingTime.CreateSpread: 진입점 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0019_WorkingTime.CreateSpread:229) |
| WK-SCP0019-0311 | H5 | SCP0019_WorkingTime.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0019_WorkingTime.SetSpreadColumn: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.SetSpreadColumn:) |
| WK-SCP0019-0312 | I1 | SCP0019 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | I1 기대값 확정 — SCP0019 화면: 게이트 I18N1 다국어 미적용 — 화면에 '_Invalid period (start >  / 게이트 I18N1 다국어 미적용 — 화면에 '_Please select cell(s).'  /  |  | 26 (D00-2-001 D00-4d-001 D00-4d-002 D00-4d-0) |
| WK-SCP0019-0313 | SC1 | SCP0019 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | SC1 기대값 확정 — SCP0019 화면: 게이트 SC2 기준표가 BUTTON_AREA(조회조건 영역 → 버튼 영역) 로 정한 조 |  | 11 (D00-1-001 D00-1-003 D00-1-004 D00-1-006 ) |
| WK-SCP0019-0314 | X-REASON | D00-1-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-005 §1 chkSum / UsrCheckBox — AS-IS `Visible=false`+`Visibility=Never` 정적 hidden(01_layout §3, Designer 4 |  | 1 (D00-1-005) |
| WK-SCP0019-0315 | X-REASON | D00-2-002 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-002 §2 cboBucketType / SelectedIndexChanged — cboBucketType 정적 hidden(D00-1-002) — 화면 비노출이라 사용자 변경 이벤트 도달 |  | 1 (D00-2-002) |
| WK-SCP0019-0316 | X-REASON | D00-2-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-005 §2 chkSum / CheckedChanged — chkSum 정적 hidden(D00-1-005) — 화면 비노출이라 토글 이벤트 도달 불가. SUM 표시는 기본값 고정(01_l |  | 1 (D00-2-005) |
| WK-SCP0019-0317 | X-REASON | D00-2-009 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-009 §2 spdMain / CellDoubleClick — SetDblClickColumnShowHide(컬럼 접기/펼치기) — AS-IS 부가기능(핵심 조회/편집/저장 무관), 전 화 |  | 1 (D00-2-009) |
| WK-SCP0019-0318 | X-REASON | D00-3-017 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-017 §3 Visible= / Columns[iCol].Visible = chkSum.Checked (SUM 토글) — SUM 열은 chkSum 정적 hidden(D00-1-005)에 종 |  | 1 (D00-3-017) |
| WK-SCP0019-0319 | X-REASON | D00-3-020 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-020 §3 Visible= / Columns[iCol].Visible = chkSum.Checked (SUM 토글) — SUM 열은 chkSum 정적 hidden(D00-1-005)에 종 |  | 1 (D00-3-020) |
| WK-SCP0019-0320 | X-REASON | D00-3-023 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-023 §3 LockColumn / (iCol, true) 정보시트 컬럼 잠금 — AS-IS spreadInfo(제목/헤더 시트) 편집 불가 = TO-BE 는 헤더가 columnGroups |  | 1 (D00-3-023) |
| WK-SCP0019-0321 | X-REASON | D00-3-027 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-027 §3 SetBGColor / (i,j,i,j, InvalidColor) 검증 실패 셀 색(0~7) — AS-IS 는 저장 범위검증 실패 셀을 InvalidColor 로 표기(cs:8 |  | 1 (D00-3-027) |
| WK-SCP0019-0322 | X-REASON | D00-3-028 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-028 §3 SetBGColor / (i,j,i,j, InvalidColor) 검증 실패 셀 색(0~1440) — AS-IS 저장 범위검증 실패 셀 InvalidColor 표기(cs:848 |  | 1 (D00-3-028) |
| WK-SCP0019-0323 | X-REASON | D00-3-037 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-037 §3 SetDblClickColumnShowHide / (sender, e) 더블클릭 컬럼 토글 — 더블클릭 컬럼 접기/펼치기 — AS-IS 부가기능(핵심 조회/편집/저장 무관),  |  | 1 (D00-3-037) |
| WK-SCP0019-0324 | D1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — COMMON:UC-02: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0019-0325 | D1 | D00-3-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-025: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-025) |
| WK-SCP0019-0326 | D1 | D00-4d-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-004: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-004) |
| WK-SCP0019-0327 | D1 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4e-003: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SCP0019-0328 | D1 | D00-4e-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4e-007: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-007) |
| WK-SCP0019-0329 | D1 | SCP0019_WorkingTime.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0019_WorkingTime.EditButton: 진입점 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0019_WorkingTime.EditButton:428:1) |
| WK-SCP0019-0330 | D3 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — COMMON:UC-02: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0019-0331 | D3 | D00-3-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-025: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-025) |
| WK-SCP0019-0332 | D3 | D00-4d-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-004: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-004) |
| WK-SCP0019-0333 | D3 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4e-003: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SCP0019-0334 | D3 | D00-4e-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4e-007: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-007) |
| WK-SCP0019-0335 | D3 | SCP0019_WorkingTime.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0019_WorkingTime.EditButton: 진입점 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0019_WorkingTime.EditButton:428:1) |
| WK-SCP0019-0336 | D5 | SCP0019_WorkingTime.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0019_WorkingTime.CreateSpread: 진입점 집계 — D5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0019_WorkingTime.CreateSpread:229) |
| WK-SCP0019-0337 | D5 | SCP0019_WorkingTime.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0019_WorkingTime.SetSpreadColumn: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.SetSpreadColumn:) |
| WK-SCP0019-0338 | E1 | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D00-3-003: 행 집계 — E1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-003) |
| WK-SCP0019-0339 | E4 | D00-3-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-3-024: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-024) |
| WK-SCP0019-0340 | E4 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-005: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-005) |
| WK-SCP0019-0341 | E4 | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-007: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-007) |
| WK-SCP0019-0342 | E4 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4e-001: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0019-0343 | E4 | D00-4e-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4e-005: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-005) |
| WK-SCP0019-0344 | E4 | D00-4e-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4e-006: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-006) |
| WK-SCP0019-0345 | E4 | SCP0019_WorkingTime.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0019_WorkingTime.SetChangedPeriod: 진입점 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0019_WorkingTime.SetChangedPeriod) |
| WK-SCP0019-0346 | E4 | SCP0019_WorkingTime.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0019_WorkingTime.SetLockSumColumn: 진입점 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.SetLockSumColumn) |
| WK-SCP0019-0347 | E4 | SCP0019_WorkingTime.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0019_WorkingTime.SetSpreadColumn: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.SetSpreadColumn:) |
| WK-SCP0019-0348 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-02) |
| WK-SCP0019-0349 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-03) |
| WK-SCP0019-0350 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-06) |
| WK-SCP0019-0351 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-07) |
| WK-SCP0019-0352 | A1 | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-001: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-1-001) |
| WK-SCP0019-0353 | A1 | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-003: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-1-003) |
| WK-SCP0019-0354 | A1 | D00-1-034 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-034: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-1-034) |
| WK-SCP0019-0355 | A1 | D00-1-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-036: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-1-036) |
| WK-SCP0019-0356 | A1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-001: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-2-001) |
| WK-SCP0019-0357 | A1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-003: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-2-003) |
| WK-SCP0019-0358 | A1 | D00-3-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-024: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-3-024) |
| WK-SCP0019-0359 | A1 | D00-3-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-025: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-3-025) |
| WK-SCP0019-0360 | A1 | D00-3-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-026: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-3-026) |
| WK-SCP0019-0361 | A1 | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-029: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-3-029) |
| WK-SCP0019-0362 | A1 | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-003: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4b-003) |
| WK-SCP0019-0363 | A1 | D00-4b-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-007: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4b-007) |
| WK-SCP0019-0364 | A1 | D00-4b-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-008: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4b-008) |
| WK-SCP0019-0365 | A1 | D00-4b-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-009: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4b-009) |
| WK-SCP0019-0366 | A1 | D00-4b-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-010: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4b-010) |
| WK-SCP0019-0367 | A1 | D00-4b-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-011: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4b-011) |
| WK-SCP0019-0368 | A1 | D00-4b-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-012: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4b-012) |
| WK-SCP0019-0369 | A1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-001: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4d-001) |
| WK-SCP0019-0370 | A1 | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-007: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4d-007) |
| WK-SCP0019-0371 | A1 | D00-4e-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4e-007: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4e-007) |
| WK-SCP0019-0372 | A1 | PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD: 골든 비교 케이스 없음(PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD — 팝업·보조 SP 는 golde |  | 1 (D00-4b-013) |
| WK-SCP0019-0373 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 47 (ACT:SCP0019_WorkingTime.FindButton ACT:S) |
| WK-SCP0019-0374 | A1 | PKG_SCP0019.P_SCP0019_GET_WORKING_TIME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0019.P_SCP0019_GET_WORKING_TIME: 골든 비교 케이스 없음(PKG_SCP0019.P_SCP0019_GET_WORKING_TIME — 팝업·보조 SP 는 golden_cases. |  | 50 (ACT:SCP0019_WorkingTime.FindButton ACT:S) |
| WK-SCP0019-0375 | G03-WIRE | SCP0019 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0019 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 |  | 14 (ACT:SCP0019_WorkingTime..ctor ACT:SCP001) |
| WK-SCP0019-0376 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0019-0377 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0019-0378 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0019-0379 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0019-0380 | G1 | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-001: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-001) |
| WK-SCP0019-0381 | G1 | D00-1-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-036: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-036) |
| WK-SCP0019-0382 | G1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-001: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0019-0383 | G1 | D00-3-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-024: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-024) |
| WK-SCP0019-0384 | G1 | D00-3-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-025: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-025) |
| WK-SCP0019-0385 | G1 | D00-3-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-026: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-026) |
| WK-SCP0019-0386 | G1 | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-029: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-029) |
| WK-SCP0019-0387 | G1 | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4b-003: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-003) |
| WK-SCP0019-0388 | G1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4d-001: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0019-0389 | G1 | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4d-007: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-007) |
| WK-SCP0019-0390 | G1 | D00-4e-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4e-007: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-007) |
| WK-SCP0019-0391 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0019-0392 | G6 | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-001: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-001) |
| WK-SCP0019-0393 | G6 | D00-1-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-036: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-036) |
| WK-SCP0019-0394 | X-ROW | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-011) |
| WK-SCP0019-0395 | X-ROW | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-006) |
| WK-SCP0019-0396 | X-ROW | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-007) |
| WK-SCP0019-0397 | X-ROW | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-008) |
| WK-SCP0019-0398 | X-ROW | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-009: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-009) |
| WK-SCP0019-0399 | X-ROW | D00-3-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-030: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-030) |
| WK-SCP0019-0400 | X-ROW | D00-3-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-031: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-031) |
| WK-SCP0019-0401 | X-ROW | D00-4b-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-005) |
| WK-SCP0019-0402 | X-ROW | D00-4b-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-006) |
| WK-SCP0019-0403 | X-ROW | D00-4c-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-001) |
| WK-SCP0019-0404 | X-ROW | D00-4c-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-003) |
| WK-SCP0019-0405 | X-ROW | D00-4d-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-003) |
| WK-SCP0019-0406 | X-ROW | SCP0019_WorkingTime.BtnInput_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.BtnInput_Click: 진입점 집계 6검사 — NOT_RUN:5 · WARN:1 |  | 5 (ACT:SCP0019_WorkingTime.BtnInput_Click:1) |
| WK-SCP0019-0407 | X-ROW | SCP0019_WorkingTime.CalculateBindingData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.CalculateBindingDataSet: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 7 (ACT:SCP0019_WorkingTime.CalculateBinding) |
| WK-SCP0019-0408 | X-ROW | SCP0019_WorkingTime.CalculateSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.CalculateSum: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/LOCAL, 연결된 요소 검사 없음 |  | 76 (ACT:SCP0019_WorkingTime.CalculateSum ACT) |
| WK-SCP0019-0409 | X-ROW | SCP0019_WorkingTime.CboDayWeek_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.CboDayWeek_SelectedIndexChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.CboDayWeek_Selec) |
| WK-SCP0019-0410 | X-ROW | SCP0019_WorkingTime.CboDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.CboDivision_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.CboDivision_Sele) |
| WK-SCP0019-0411 | X-ROW | SCP0019_WorkingTime.ClbBuilding_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.ClbBuilding_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.ClbBuilding_Sele) |
| WK-SCP0019-0412 | X-ROW | SCP0019_WorkingTime.ClbOperation_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.ClbOperation_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.ClbOperation_Sel) |
| WK-SCP0019-0413 | X-ROW | SCP0019_WorkingTime.ClbPlantSite_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.ClbPlantSite_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.ClbPlantSite_Sel) |
| WK-SCP0019-0414 | X-ROW | SCP0019_WorkingTime.ClearUsrCheckedList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 요소 검사  |  | 4 (ACT:SCP0019_WorkingTime.ClearUsrCheckedL) |
| WK-SCP0019-0415 | X-ROW | SCP0019_WorkingTime.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.CreateSpread) |
| WK-SCP0019-0416 | X-ROW | SCP0019_WorkingTime.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.DefineProperty: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0019_WorkingTime.DefineProperty:1) |
| WK-SCP0019-0417 | X-ROW | SCP0019_WorkingTime.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.EditButton: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:2 |  | 1 (ACT:SCP0019_WorkingTime.EditButton:436:8) |
| WK-SCP0019-0418 | X-ROW | SCP0019_WorkingTime.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0019_WorkingTime.FindButton) |
| WK-SCP0019-0419 | X-ROW | SCP0019_WorkingTime.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.FindData_Main: 진입점 집계 15검사 — NOT_RUN:10 · REVIEW:2 · PASS:2 · WARN:1 |  | 8 (ACT:SCP0019_WorkingTime.FindData_Main:67) |
| WK-SCP0019-0420 | X-ROW | SCP0019_WorkingTime.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.Form_Load) |
| WK-SCP0019-0421 | X-ROW | SCP0019_WorkingTime.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.GetBucketType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.GetBucketType) |
| WK-SCP0019-0422 | X-ROW | SCP0019_WorkingTime.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.GetDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.GetDivision) |
| WK-SCP0019-0423 | X-ROW | SCP0019_WorkingTime.GetShipToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.GetShipToParty: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.GetShipToParty) |
| WK-SCP0019-0424 | X-ROW | SCP0019_WorkingTime.GetShipType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.GetShipType: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.GetShipType) |
| WK-SCP0019-0425 | X-ROW | SCP0019_WorkingTime.GetSoldToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.GetSoldToParty: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.GetSoldToParty) |
| WK-SCP0019-0426 | X-ROW | SCP0019_WorkingTime.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.GetSpdTitle) |
| WK-SCP0019-0427 | X-ROW | SCP0019_WorkingTime.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.InitControls: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0019_WorkingTime.InitControls:195) |
| WK-SCP0019-0428 | X-ROW | SCP0019_WorkingTime.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.InitSpread: 진입점 집계 13검사 — NOT_RUN:13 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.InitSpread) |
| WK-SCP0019-0429 | X-ROW | SCP0019_WorkingTime.InitSpreadDateColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0019_WorkingTime.InitSpreadDateCo) |
| WK-SCP0019-0430 | X-ROW | SCP0019_WorkingTime.RefreshBuilding | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.RefreshBuilding: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0019_WorkingTime.RefreshBuilding ) |
| WK-SCP0019-0431 | X-ROW | SCP0019_WorkingTime.RefreshLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.RefreshLine: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 21 (ACT:SCP0019_WorkingTime.RefreshLine ACT:) |
| WK-SCP0019-0432 | X-ROW | SCP0019_WorkingTime.RefreshOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.RefreshOperation: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.RefreshOperation) |
| WK-SCP0019-0433 | X-ROW | SCP0019_WorkingTime.RefreshPlantSiteByDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.RefreshPlantSiteByDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0019_WorkingTime.RefreshPlantSite) |
| WK-SCP0019-0434 | X-ROW | SCP0019_WorkingTime.SaveData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.SaveData_Main: 진입점 집계 13검사 — NOT_RUN:7 · PASS:3 · NOPATH:2 · WARN:1 |  | 13 (ACT:SCP0019_WorkingTime.SaveData_Main:78) |
| WK-SCP0019-0435 | X-ROW | SCP0019_WorkingTime.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.SetChangedControl: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.SetChangedContro) |
| WK-SCP0019-0436 | X-ROW | SCP0019_WorkingTime.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.SetChangedPeriod: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0019_WorkingTime.SetChangedPeriod) |
| WK-SCP0019-0437 | X-ROW | SCP0019_WorkingTime.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.SetLockSumColumn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.SetLockSumColumn) |
| WK-SCP0019-0438 | X-ROW | SCP0019_WorkingTime.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.SetSpreadColumn: 진입점 집계 16검사 — NOT_RUN:10 · REVIEW:6 |  | 7 (ACT:SCP0019_WorkingTime.SetSpreadColumn:) |
| WK-SCP0019-0439 | X-ROW | SCP0019_WorkingTime.SpdMain_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.SpdMain_CellDoub) |
| WK-SCP0019-0440 | X-ROW | SCP0019_WorkingTime.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0019_WorkingTime.SpdMain_TopChang) |
| WK-SCP0019-0441 | X-ROW | SCP0019_WorkingTime.UnLockOnlyOSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.UnLockOnlyOSP: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/GRID_SET/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0019_WorkingTime.UnLockOnlyOSP AC) |
| WK-SCP0019-0442 | X-ROW | SCP0019_WorkingTime.cboBucketType_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.cboBucketType_SelectedIndexCha: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.cboBucketType_Se) |
| WK-SCP0019-0443 | X-ROW | SCP0019_WorkingTime.chkSum_CheckedChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0019_WorkingTime.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.chkSum_CheckedCh) |
| WK-SCP0019-0444 | G5 | SCP0019_WorkingTime.SpdMain_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0019_WorkingTime.SpdMain_CellDoubleClick: 진입점 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.SpdMain_CellDoub) |
| WK-SCP0019-0445 | H6 | SCP0019_WorkingTime.SpdMain_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0019_WorkingTime.SpdMain_CellDoubleClick: 진입점 집계 — H6 4요소: NOPATH:2 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.SpdMain_CellDoub) |
| WK-SCP0019-0446 | M4 | SCP0019_WorkingTime.SpdMain_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0019_WorkingTime.SpdMain_CellDoubleClick: 진입점 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0019_WorkingTime.SpdMain_CellDoub) |
