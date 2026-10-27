# 작업 원장 — SCP0123 · 2026-10-26 12:55

> 검사 인스턴스 748건 중 PASS·NA 63건 외 **685건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 128 | 구현 위치 실존 |
| W4 | 검사기 구현 | 4 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 22 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 164 | 실행 → PASS |
| W7 | 기대값 확정 | 367 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 352 · E2E 164 · 대조표 143 · 하네스 26
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 6건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 128 |  |  |  |  | 7 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 94 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 40 | 10 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G1 | GEN |  |  |  |  |  | 3 | 40 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 43 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G4 | DESIGN |  |  |  |  | 2 | 17 | 15 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 17 | 15 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| A5 | DESIGN |  |  |  |  |  | 4 | 19 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 3 | 20 |  |  | 배경·글자색 규칙 |
| C3 | CASCADE |  |  |  |  |  | 14 | 7 |  |  | 연쇄 자동 채움 |
| H5 | DESIGN |  |  |  |  |  | 2 | 18 |  |  | 라벨 명칭 |
| F4 | DB |  |  |  |  |  | 10 | 7 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| X-REASON | DESIGN |  |  |  |  |  |  | 15 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| C2 | CASCADE |  |  |  |  |  | 9 | 5 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 9 | 5 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| DB-SYN | DB |  |  |  |  | 5 |  | 7 |  |  | BE 계정 시노님·권한·대상 객체 |
| B4 | COMBO |  |  |  |  | 4 |  | 6 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | CASCADE |  |  |  |  |  | 6 | 4 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| B3 | COMBO |  |  |  | 4 |  |  | 5 |  |  | 콤보 후보 정렬 = AS-IS |
| D3 | EDIT |  |  |  |  |  | 4 | 5 |  |  | 행 값 기반 조건부 잠금 |
| A6 | GEN |  |  |  |  |  | 5 | 3 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G5 | POPUP |  |  |  |  | 4 |  | 3 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 4 |  | 3 |  |  | 팝업 표준·열림 |
| D1 | EDIT |  |  |  |  |  | 4 | 3 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D4 | EDIT |  |  |  |  |  | 1 | 5 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| M4 | POPUP |  |  |  |  |  | 2 | 3 |  |  | 팝업 선택값 반영 |
| M3 | POPUP |  |  |  |  |  | 3 |  |  |  | 팝업 내부 기능(조회·CRUD) |
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

## W2 구현 위치 확인 (128)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0123-0001 | X-LOC | (else) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((else)) |
| WK-SCP0123-0002 | X-LOC | (고정열) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((고정열)) |
| WK-SCP0123-0003 | X-LOC | (병합) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((병합)) |
| WK-SCP0123-0004 | X-LOC | B01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B01) |
| WK-SCP0123-0005 | X-LOC | B02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B02) |
| WK-SCP0123-0006 | X-LOC | B03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B03) |
| WK-SCP0123-0007 | X-LOC | B04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B04) |
| WK-SCP0123-0008 | X-LOC | B05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B05) |
| WK-SCP0123-0009 | X-LOC | B06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B06) |
| WK-SCP0123-0010 | X-LOC | B07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B07) |
| WK-SCP0123-0011 | X-LOC | B08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B08) |
| WK-SCP0123-0012 | X-LOC | B09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B09) |
| WK-SCP0123-0013 | X-LOC | B10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B10) |
| WK-SCP0123-0014 | X-LOC | B11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B11) |
| WK-SCP0123-0015 | X-LOC | B12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B12) |
| WK-SCP0123-0016 | X-LOC | B13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B13) |
| WK-SCP0123-0017 | X-LOC | B14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B14) |
| WK-SCP0123-0018 | X-LOC | B15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B15) |
| WK-SCP0123-0019 | X-LOC | B16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B16) |
| WK-SCP0123-0020 | X-LOC | B17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B17) |
| WK-SCP0123-0021 | X-LOC | B18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B18) |
| WK-SCP0123-0022 | X-LOC | B19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B19) |
| WK-SCP0123-0023 | X-LOC | B20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B20) |
| WK-SCP0123-0024 | X-LOC | B21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B21) |
| WK-SCP0123-0025 | X-LOC | B22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B22) |
| WK-SCP0123-0026 | X-LOC | B23 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B23) |
| WK-SCP0123-0027 | X-LOC | B24 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B24) |
| WK-SCP0123-0028 | X-LOC | B25 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B25) |
| WK-SCP0123-0029 | X-LOC | B26 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B26) |
| WK-SCP0123-0030 | X-LOC | B27 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B27) |
| WK-SCP0123-0031 | X-LOC | B28 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B28) |
| WK-SCP0123-0032 | X-LOC | B29 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B29) |
| WK-SCP0123-0033 | X-LOC | B30 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B30) |
| WK-SCP0123-0034 | X-LOC | B31 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B31) |
| WK-SCP0123-0035 | X-LOC | B32 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B32) |
| WK-SCP0123-0036 | X-LOC | B33 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B33) |
| WK-SCP0123-0037 | X-LOC | B34 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B34) |
| WK-SCP0123-0038 | X-LOC | B35 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B35) |
| WK-SCP0123-0039 | X-LOC | B36 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B36) |
| WK-SCP0123-0040 | X-LOC | B37 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B37) |
| WK-SCP0123-0041 | X-LOC | B38 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B38) |
| WK-SCP0123-0042 | X-LOC | B39 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B39) |
| WK-SCP0123-0043 | X-LOC | B40 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B40) |
| WK-SCP0123-0044 | X-LOC | B41 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (B41) |
| WK-SCP0123-0045 | X-LOC | C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0)) |
| WK-SCP0123-0046 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: SubTitle.tsx 없음, useDirtyRegistry.ts 없음 |  | 1 (COMMON:UC-02) |
| WK-SCP0123-0047 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: DataGrid.tsx 없음 |  | 1 (COMMON:UC-07) |
| WK-SCP0123-0048 | X-LOC | F01 `DBUtils.Filter(dtMyDivision,"CODE I | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (F01 `DBUtils.Filter(dtMyDivision,"CODE I) |
| WK-SCP0123-0049 | X-LOC | F02 `DBUtils.Filter(dtPlanGroupAll,"DIVI | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (F02 `DBUtils.Filter(dtPlanGroupAll,"DIVI) |
| WK-SCP0123-0050 | X-LOC | F03·F05·F07~F10 판정식 6회 중복 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (F03·F05·F07~F10 판정식 6회 중복) |
| WK-SCP0123-0051 | X-LOC | F04 `DBUtils.Filter(dtPlanDateAll,"DIVIS | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (F04 `DBUtils.Filter(dtPlanDateAll,"DIVIS) |
| WK-SCP0123-0052 | X-LOC | G01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G01) |
| WK-SCP0123-0053 | X-LOC | G02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G02) |
| WK-SCP0123-0054 | X-LOC | G03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G03) |
| WK-SCP0123-0055 | X-LOC | G04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G04) |
| WK-SCP0123-0056 | X-LOC | G05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G05) |
| WK-SCP0123-0057 | X-LOC | G06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G06) |
| WK-SCP0123-0058 | X-LOC | G07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G07) |
| WK-SCP0123-0059 | X-LOC | G08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G08) |
| WK-SCP0123-0060 | X-LOC | G10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G10) |
| WK-SCP0123-0061 | X-LOC | G11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G11) |
| WK-SCP0123-0062 | X-LOC | G12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G12) |
| WK-SCP0123-0063 | X-LOC | G13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G13) |
| WK-SCP0123-0064 | X-LOC | G14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G14) |
| WK-SCP0123-0065 | X-LOC | G15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G15) |
| WK-SCP0123-0066 | X-LOC | G16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G16) |
| WK-SCP0123-0067 | X-LOC | G18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G18) |
| WK-SCP0123-0068 | X-LOC | G19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G19) |
| WK-SCP0123-0069 | X-LOC | G20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G20) |
| WK-SCP0123-0070 | X-LOC | G21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G21) |
| WK-SCP0123-0071 | X-LOC | K01 `BLUtils.GetDivision(false,"")` → `U | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (K01 `BLUtils.GetDivision(false,"")` → `U) |
| WK-SCP0123-0072 | X-LOC | K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY) |
| WK-SCP0123-0073 | X-LOC | K03·K05 `Data_SCP.CommonAll(PlanID)` + ` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (K03·K05 `Data_SCP.CommonAll(PlanID)` + `) |
| WK-SCP0123-0074 | X-LOC | K04 `Data.Common(LookupCommon,"OPMZ_DIVI | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (K04 `Data.Common(LookupCommon,"OPMZ_DIVI) |
| WK-SCP0123-0075 | X-LOC | R05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R05) |
| WK-SCP0123-0076 | X-LOC | R07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R07) |
| WK-SCP0123-0077 | X-LOC | R09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R09) |
| WK-SCP0123-0078 | X-LOC | R10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R10) |
| WK-SCP0123-0079 | X-LOC | R11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R11) |
| WK-SCP0123-0080 | X-LOC | R11' | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R11') |
| WK-SCP0123-0081 | X-LOC | R12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R12) |
| WK-SCP0123-0082 | X-LOC | R13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R13) |
| WK-SCP0123-0083 | X-LOC | R14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R14) |
| WK-SCP0123-0084 | X-LOC | R15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R15) |
| WK-SCP0123-0085 | X-LOC | R16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R16) |
| WK-SCP0123-0086 | X-LOC | R17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R17) |
| WK-SCP0123-0087 | X-LOC | R18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R18) |
| WK-SCP0123-0088 | X-LOC | R20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R20) |
| WK-SCP0123-0089 | X-LOC | R21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R21) |
| WK-SCP0123-0090 | X-LOC | R22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R22) |
| WK-SCP0123-0091 | X-LOC | R23 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R23) |
| WK-SCP0123-0092 | X-LOC | R24 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R24) |
| WK-SCP0123-0093 | X-LOC | R25 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R25) |
| WK-SCP0123-0094 | X-LOC | R28 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R28) |
| WK-SCP0123-0095 | X-LOC | R29 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R29) |
| WK-SCP0123-0096 | X-LOC | R30 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R30) |
| WK-SCP0123-0097 | X-LOC | S01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S01) |
| WK-SCP0123-0098 | X-LOC | S02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S02) |
| WK-SCP0123-0099 | X-LOC | S03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S03) |
| WK-SCP0123-0100 | X-LOC | S04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S04) |
| WK-SCP0123-0101 | X-LOC | U01·U02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (U01·U02) |
| WK-SCP0123-0102 | X-LOC | X01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X01) |
| WK-SCP0123-0103 | X-LOC | X02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X02) |
| WK-SCP0123-0104 | X-LOC | X03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X03) |
| WK-SCP0123-0105 | X-LOC | X04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X04) |
| WK-SCP0123-0106 | X-LOC | X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검) |
| WK-SCP0123-0107 | X-LOC | X05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X05) |
| WK-SCP0123-0108 | X-LOC | X06 `ConditionNotUseList.Add(cboPlanDate | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X06 `ConditionNotUseList.Add(cboPlanDate) |
| WK-SCP0123-0109 | X-LOC | X07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X07) |
| WK-SCP0123-0110 | X-LOC | X08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X08) |
| WK-SCP0123-0111 | X-LOC | X08 `DataView.Sort="CODE DESC"` (cs:265- | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X08 `DataView.Sort="CODE DESC"` (cs:265-) |
| WK-SCP0123-0112 | X-LOC | X09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X09) |
| WK-SCP0123-0113 | X-LOC | X13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X13) |
| WK-SCP0123-0114 | X-LOC | X14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X14) |
| WK-SCP0123-0115 | X-LOC | X14 `dsSearchInfo.Tables[3]` = Plan Grou | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X14 `dsSearchInfo.Tables[3]` = Plan Grou) |
| WK-SCP0123-0116 | X-LOC | X15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X15) |
| WK-SCP0123-0117 | X-LOC | X16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X16) |
| WK-SCP0123-0118 | X-LOC | X17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X17) |
| WK-SCP0123-0119 | X-LOC | X18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X18) |
| WK-SCP0123-0120 | X-LOC | X21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X21) |
| WK-SCP0123-0121 | X-LOC | X21 `NowGroupID in (ADMIN, SCM PI Admin) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (X21 `NowGroupID in (ADMIN, SCM PI Admin)) |
| WK-SCP0123-0122 | X-LOC | `emptySpaceItem1`(344px 여백) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`emptySpaceItem1`(344px 여백)) |
| WK-SCP0123-0123 | X-LOC | `imageList1` / `timerStatus` / `componen | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`imageList1` / `timerStatus` / `componen) |
| WK-SCP0123-0124 | X-LOC | `layoutControlItem1/5` · `lciPlanDate` · | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`layoutControlItem1/5` · `lciPlanDate` ·) |
| WK-SCP0123-0125 | X-LOC | `setListBox` 바인딩 직후 첫 행 자동 선택(Division / | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`setListBox` 바인딩 직후 첫 행 자동 선택(Division /) |
| WK-SCP0123-0126 | X-LOC | `spdMain` / `spdSub` (FpSpread) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`spdMain` / `spdSub` (FpSpread)) |
| WK-SCP0123-0127 | X-LOC | `splitContainer1` Orientation=**Horizont | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`splitContainer1` Orientation=**Horizont) |
| WK-SCP0123-0128 | X-LOC | `usrConditionPanel1`(HidePanel) + `usrLa | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`usrConditionPanel1`(HidePanel) + `usrLa) |

## W4 검사기 구현 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0123-0129 | B3 | CONFIRM | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CONFIRM | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0130 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (K04 `Data.Common(LookupCommon,"OPMZ_DIVI) |
| WK-SCP0123-0131 | B3 | LINK | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 LINK | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0132 | B3 | OPMZ_PLAN_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPMZ_PLAN_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |

## W5 검사기 연결 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0123-0133 | B4 | CONFIRM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CONFIRM | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0134 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (K04 `Data.Common(LookupCommon,"OPMZ_DIVI) |
| WK-SCP0123-0135 | B4 | LINK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL LINK | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0136 | B4 | OPMZ_PLAN_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPMZ_PLAN_ID | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0137 | F2 | SCP0123 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0123 화면 | 판단불가(대상 단위 SCREEN) | 150 (R11' R12 R25 R29 R31 X06 `ConditionNotUs) |
| WK-SCP0123-0138 | F6 | SCP0123 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0123 화면 | 판단불가(대상 단위 SCREEN) | 142 (R12 B05 S04 planControl HANDLER:SaveData) |
| WK-SCP0123-0139 | DB-SYN | P_SCP0123_ACTV_RUN_SAVE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0123_ACTV_RUN_SAVE | 없음(PROC_M 대응 없음) | 1 (planControl) |
| WK-SCP0123-0140 | DB-SYN | P_SCP0123_ENGINE_RUN_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0123_ENGINE_RUN_GET | 없음(PROC_M 대응 없음) | 1 (engineRun) |
| WK-SCP0123-0141 | DB-SYN | P_SCP0123_PLAN_CONTROL_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0123_PLAN_CONTROL_GET | 없음(PROC_M 대응 없음) | 0 () |
| WK-SCP0123-0142 | DB-SYN | SCP0123_GET_PLAN_ID_CREATE_INFO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0123_GET_PLAN_ID_CREATE_INFO | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0123_PlanIDCreatePopup.GetInitInf) |
| WK-SCP0123-0143 | DB-SYN | SCP0123_SAVE_PLAN_CTRL_ACTV_RUN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0123_SAVE_PLAN_CTRL_ACTV_RUN | 없음(PROC_M 대응 없음) | 4 (S04 CRUD:P03:SAVE ACT:SCP0123_PlanContro) |
| WK-SCP0123-0144 | G4 | btnClose | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnClose | 없음 | 2 (ACT:SCP0123_PlanIDCreatePopup.InitEvent ) |
| WK-SCP0123-0145 | G4 | btnCreatePlan | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnCreatePlan | 있음(FE 소스) | 2 (ACT:SCP0123_PlanIDCreatePopup.InitEvent ) |
| WK-SCP0123-0146 | G03-WIRE | SCP0123 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0123 화면 | 판단불가(대상 단위 SCREEN) | 34 (ACT:SCP0123_PlanControl..ctor ACT:SCP012) |
| WK-SCP0123-0147 | G5 | CONFIRM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL CONFIRM | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0148 | G5 | LINK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL LINK | 있음(SHEET_COLUMNS) | 5 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0149 | G5 | OPMZ_PLAN_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL OPMZ_PLAN_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0150 | G5 | SCP0123_PlanIDCreatePopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SCP0123_PlanIDCreatePopup | 판단불가(대상 단위 POPUP) | 2 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0151 | H6 | CONFIRM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CONFIRM | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0152 | H6 | LINK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL LINK | 있음(SHEET_COLUMNS) | 5 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0153 | H6 | OPMZ_PLAN_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL OPMZ_PLAN_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0154 | H6 | SCP0123_PlanIDCreatePopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SCP0123_PlanIDCreatePopup | 판단불가(대상 단위 POPUP) | 2 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |

## W6 검증 실행 (164)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0123-0155 | J2 | SCP0123 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0123 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 60 (R08 R10 R11 R11' R12 R21 R25 R27 R29 R31) |
| WK-SCP0123-0156 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0123_PlanControl.InitControls:200) |
| WK-SCP0123-0157 | C1 | cboParameter / Parameter | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboParameter / Parameter · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0158 | C1 | cboPlanDate / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0123_PlanControl.RefreshPlanDate:) |
| WK-SCP0123-0159 | C1 | cboPlanGroup / FCST Version / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanGroup / FCST Version / Plan Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0123_PlanControl.RefreshPlanGroup) |
| WK-SCP0123-0160 | C1 | cboProdCd / Plan Type  / Prod Cd | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboProdCd / Plan Type  / Prod Cd · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0161 | C1 | cboShipCd / Plan Type  / Ship Cd | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboShipCd / Plan Type  / Ship Cd · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0162 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0163 | C2 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0164 | C2 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0165 | C2 | OPMZ_ACTV_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_ACTV_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0166 | C2 | OPMZ_ACTV_RUN_STAT_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_ACTV_RUN_STAT_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (G18 ACT:SCP0123_PlanControl.SpdMain_Comb) |
| WK-SCP0123-0167 | C2 | OPMZ_ACTV_RUN_STAT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_ACTV_RUN_STAT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0168 | C2 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0169 | C2 | OPMZ_PLAN_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_PLAN_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 13 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0170 | C2 | PLAN_START_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLAN_START_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0171 | C3 | DETAILS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DETAILS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SetEngineStatus ) |
| WK-SCP0123-0172 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0173 | C3 | END_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — END_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SetEngineStatus ) |
| WK-SCP0123-0174 | C3 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0123_PlanControl.FindData_Sub:602) |
| WK-SCP0123-0175 | C3 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0123_PlanControl.FindData_Sub:601) |
| WK-SCP0123-0176 | C3 | LINK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LINK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0177 | C3 | OPMZ_ACTV_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_ACTV_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0178 | C3 | OPMZ_ACTV_RUN_STAT_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_ACTV_RUN_STAT_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (G18 ACT:SCP0123_PlanControl.FindData_Sub) |
| WK-SCP0123-0179 | C3 | OPMZ_ACTV_RUN_STAT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_ACTV_RUN_STAT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0180 | C3 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0181 | C3 | OPMZ_PLAN_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_PLAN_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 14 (ACT:SCP0123_PlanControl.FindData_Main:45) |
| WK-SCP0123-0182 | C3 | PLAN_START_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLAN_START_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0183 | C3 | START_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — START_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0123_PlanControl.SetEngineStatus ) |
| WK-SCP0123-0184 | C3 | STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0123_PlanControl.SetEngineStatus ) |
| WK-SCP0123-0185 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0186 | C6 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0187 | C6 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0188 | C6 | OPMZ_ACTV_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPMZ_ACTV_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0189 | C6 | OPMZ_ACTV_RUN_STAT_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPMZ_ACTV_RUN_STAT_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (G18 ACT:SCP0123_PlanControl.SpdMain_Comb) |
| WK-SCP0123-0190 | C6 | OPMZ_ACTV_RUN_STAT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPMZ_ACTV_RUN_STAT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0191 | C6 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0192 | C6 | OPMZ_PLAN_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPMZ_PLAN_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 13 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0193 | C6 | PLAN_START_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLAN_START_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0194 | G3 | SCP0123 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0123 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 5 (`usrConditionPanel1`(HidePanel) + `usrLa) |
| WK-SCP0123-0195 | K-SA | SCP0123 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0123 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (`usrConditionPanel1`(HidePanel) + `usrLa) |
| WK-SCP0123-0196 | K4 | SCP0123 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0123 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 7 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-07 A) |
| WK-SCP0123-0197 | F1 | SCP0123 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0123 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 152 (R11 R11' R12 R25 R29 R31 X06 `ConditionN) |
| WK-SCP0123-0198 | F5 | SCP0123 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0123 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 2 (R11 R11') |
| WK-SCP0123-0199 | F4 | PKG_COM0000.P_SCP0121_GET_SEARCH_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0121_GET_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 4 (S01 searchInfo ACT:SCP0123_PlanControl.G) |
| WK-SCP0123-0200 | F4 | PKG_SCP0123.P_SCP0123_GET_PLAN_CONTROL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0123.P_SCP0123_GET_PLAN_CONTROL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 164 (S02 CRUD:P01:SEARCH ACT:SCP0123_PlanCont) |
| WK-SCP0123-0201 | F4 | PKG_SCP0123.P_SCP0123_GET_PLAN_ENGINE_RU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0123.P_SCP0123_GET_PLAN_ENGINE_RUN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 65 (S03 engineRun ACT:SCP0123_PlanControl.Fi) |
| WK-SCP0123-0202 | F4 | PKG_SCP0123.P_SCP0123_SAVE_PLAN_ACTV_RUN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0123.P_SCP0123_SAVE_PLAN_ACTV_RUN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 2 (S04 planControl) |
| WK-SCP0123-0203 | F4 | PKG_SCP0123.P_SCP0123_SAVE_PLAN_ID_CREAT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0123.P_SCP0123_SAVE_PLAN_ID_CREATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 88 (ACT:SCP0123_PlanIDCreatePopup.SaveData A) |
| WK-SCP0123-0204 | F4 | P_SCP0123_ACTV_RUN_SAVE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0123_ACTV_RUN_SAVE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (planControl) |
| WK-SCP0123-0205 | F4 | P_SCP0123_ENGINE_RUN_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0123_ENGINE_RUN_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (engineRun) |
| WK-SCP0123-0206 | F4 | P_SCP0123_PLAN_CONTROL_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0123_PLAN_CONTROL_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 0 () |
| WK-SCP0123-0207 | F4 | SCP0123_GET_PLAN_ID_CREATE_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0123_GET_PLAN_ID_CREATE_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tr |  | 2 (ACT:SCP0123_PlanIDCreatePopup.GetInitInf) |
| WK-SCP0123-0208 | F4 | SCP0123_SAVE_PLAN_CTRL_ACTV_RUN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0123_SAVE_PLAN_CTRL_ACTV_RUN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tr |  | 50 (S04 CRUD:P03:SAVE ACT:SCP0123_PlanContro) |
| WK-SCP0123-0209 | A5 | CONFIRM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CONFIRM · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0123_PlanControl.FindData_Main:46) |
| WK-SCP0123-0210 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (X08) |
| WK-SCP0123-0211 | A5 | LINK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LINK · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0212 | A5 | OPMZ_PLAN_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPMZ_PLAN_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0213 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0123_PlanControl.InitControls ACT) |
| WK-SCP0123-0214 | G4 | cboParameter / Parameter | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboParameter / Parameter · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0215 | G4 | cboPlanDate / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanDate / Plan Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (X06 `ConditionNotUseList.Add(cboPlanDate) |
| WK-SCP0123-0216 | G4 | cboPlanGroup / FCST Version / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanGroup / FCST Version / Plan Group · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0123_PlanControl.InitControls ACT) |
| WK-SCP0123-0217 | G4 | cboProdCd / Plan Type  / Prod Cd | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboProdCd / Plan Type  / Prod Cd · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0218 | G4 | cboProdPlanID / Plan ID  / Prod Plan ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboProdPlanID / Plan ID  / Prod Plan ID · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0219 | G4 | cboShipCd / Plan Type  / Ship Cd | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboShipCd / Plan Type  / Ship Cd · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0220 | G4 | cboShipPlanID / Plan ID  / Ship Plan ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboShipPlanID / Plan ID  / Ship Plan ID · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0221 | G4 | chkCellNoFrozen / No Frozen / Cell No Fr | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkCellNoFrozen / No Frozen / Cell No Frozen · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0123_PlanIDCreatePopup.ChkCellNoF) |
| WK-SCP0123-0222 | G4 | chkProdNoFrozen / No Frozen / Prod No Fr | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkProdNoFrozen / No Frozen / Prod No Frozen · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0123_PlanIDCreatePopup.ChkProdNoF) |
| WK-SCP0123-0223 | G4 | chkShipNoFrozen / No Frozen / Ship No Fr | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkShipNoFrozen / No Frozen / Ship No Frozen · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0123_PlanIDCreatePopup.ChkShipNoF) |
| WK-SCP0123-0224 | G4 | txtCellStart / Cell  / Cell Start | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtCellStart / Cell  / Cell Start · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0225 | G4 | txtFcstVersion / FCST Version / Fcst Ver | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtFcstVersion / FCST Version / Fcst Version · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0226 | G4 | txtHorizonStart / Plan Horizon / Horizon | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtHorizonStart / Plan Horizon / Horizon Start · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0227 | G4 | txtPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtPlanGroup / Plan Group · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0228 | G4 | txtProdStart / Period / Prod Start | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProdStart / Period / Prod Start · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0229 | G4 | txtShipStart / Period  / Ship Start | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtShipStart / Period  / Ship Start · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0230 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (X08) |
| WK-SCP0123-0231 | H2 | LINK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LINK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (G10) |
| WK-SCP0123-0232 | H2 | OPMZ_PLAN_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPMZ_PLAN_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0123_PlanControl.FindData_Main:44) |
| WK-SCP0123-0233 | H5 | CONFIRM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CONFIRM · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCP0123_PlanControl.FindData_Main:46) |
| WK-SCP0123-0234 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (X08) |
| WK-SCP0123-0235 | I1 | SCP0123 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0123 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 51 (R07 R09 R25 R28 B04 B06 B11 B13 B16 B17 ) |
| WK-SCP0123-0236 | SC1 | SCP0123 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0123 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 16 (K01 `BLUtils.GetDivision(false,"")` → `U) |
| WK-SCP0123-0237 | D1 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (G05 ACT:SCP0123_PlanControl.FindData_Mai) |
| WK-SCP0123-0238 | D1 | OPMZ_ACTV_RUN_STAT_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPMZ_ACTV_RUN_STAT_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (G05 ACT:SCP0123_PlanControl.FindData_Mai) |
| WK-SCP0123-0239 | D1 | OPMZ_PLAN_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPMZ_PLAN_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (HANDLER:SpdMain_KeyPress) |
| WK-SCP0123-0240 | D1 | OPMZ_PLAN_ID_INDP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPMZ_PLAN_ID_INDP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (G04 ACT:SCP0123_PlanControl.FindData_Mai) |
| WK-SCP0123-0241 | D3 | LAST_UPDATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (G05 ACT:SCP0123_PlanControl.FindData_Mai) |
| WK-SCP0123-0242 | D3 | OPMZ_ACTV_RUN_STAT_CD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPMZ_ACTV_RUN_STAT_CD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (G05 ACT:SCP0123_PlanControl.FindData_Mai) |
| WK-SCP0123-0243 | D3 | OPMZ_PLAN_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPMZ_PLAN_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (HANDLER:SpdMain_KeyPress) |
| WK-SCP0123-0244 | D3 | OPMZ_PLAN_ID_INDP_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPMZ_PLAN_ID_INDP_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (G04 ACT:SCP0123_PlanControl.FindData_Mai) |
| WK-SCP0123-0245 | D4 | OPMZ_ACTV_RUN_STAT_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPMZ_ACTV_RUN_STAT_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (G14) |
| WK-SCP0123-0246 | D6 | SCP0123 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0123 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 5 (R11 R11' X08 `DataView.Sort="CODE DESC"`) |
| WK-SCP0123-0247 | E4 | CONFIRM | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CONFIRM · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 18 (R25 CRUD:P03:SAVE ACT:SCP0123_PlanContro) |
| WK-SCP0123-0248 | E4 | DETAILS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DETAILS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0123_PlanControl.SetEngineStatus ) |
| WK-SCP0123-0249 | E4 | END_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — END_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0123_PlanControl.SetEngineStatus ) |
| WK-SCP0123-0250 | E4 | LINK | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LINK · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 18 (MODAL:SCP0039_ValidationMaster ACT:SCP01) |
| WK-SCP0123-0251 | E4 | MSG00093 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00093 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (B06 B25 B28 B35 B41 ACT:SCP0123_PlanCont) |
| WK-SCP0123-0252 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R09) |
| WK-SCP0123-0253 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0123_PlanIDCreatePopup.SaveData:4) |
| WK-SCP0123-0254 | E4 | MSG00183 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00183 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (B22 B26 B33 B38 ACT:SCP0123_PlanControl.) |
| WK-SCP0123-0255 | E4 | MSG00184 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00184 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (B18 ACT:SCP0123_PlanControl.SpdMain_Cell) |
| WK-SCP0123-0256 | E4 | MSG00465 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00465 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (B20 ACT:SCP0123_PlanControl.SpdMain_Cell) |
| WK-SCP0123-0257 | E4 | MSG00466 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00466 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (B32 ACT:SCP0123_PlanControl.SpdMain_Cell) |
| WK-SCP0123-0258 | E4 | MSG00469 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00469 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (B16 ACT:SCP0123_PlanControl.SpdMain_Cell) |
| WK-SCP0123-0259 | E4 | MSG00470 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00470 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (B17 ACT:SCP0123_PlanControl.SpdMain_Cell) |
| WK-SCP0123-0260 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (R07 R09) |
| WK-SCP0123-0261 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0123-0262 | E4 | MSG00704 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00704 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0123-0263 | E4 | MSG01122 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01122 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (B06) |
| WK-SCP0123-0264 | E4 | MSG01125 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01125 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R25) |
| WK-SCP0123-0265 | E4 | MSG01438 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01438 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (B20) |
| WK-SCP0123-0266 | E4 | MSG01439 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01439 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (B32 B38) |
| WK-SCP0123-0267 | E4 | MSG01441 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01441 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (B16) |
| WK-SCP0123-0268 | E4 | MSG01442 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01442 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (B17) |
| WK-SCP0123-0269 | E4 | MSG01456 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01456 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (B22 B26 B33 B38) |
| WK-SCP0123-0270 | E4 | MSG01457 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01457 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (B18) |
| WK-SCP0123-0271 | E4 | MSG01462 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01462 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (B11) |
| WK-SCP0123-0272 | E4 | MSG01463 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01463 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (B24) |
| WK-SCP0123-0273 | E4 | MSG01464 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01464 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (B30) |
| WK-SCP0123-0274 | E4 | MSG01465 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01465 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R28) |
| WK-SCP0123-0275 | E4 | OPMZ_PLAN_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OPMZ_PLAN_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 16 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0276 | E4 | START_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — START_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0123_PlanControl.SetEngineStatus ) |
| WK-SCP0123-0277 | E4 | STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — STATUS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0123_PlanControl.SetEngineStatus ) |
| WK-SCP0123-0278 | E4 | cboParameter / Parameter | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboParameter / Parameter · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 3 (ACT:SCP0123_PlanIDCreatePopup.Set_PlanID) |
| WK-SCP0123-0279 | E4 | cboProdCd / Plan Type  / Prod Cd | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboProdCd / Plan Type  / Prod Cd · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도  |  | 4 (ACT:SCP0123_PlanIDCreatePopup.Set_PlanID) |
| WK-SCP0123-0280 | E4 | cboProdPlanID / Plan ID  / Prod Plan ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboProdPlanID / Plan ID  / Prod Plan ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지 |  | 4 (ACT:SCP0123_PlanIDCreatePopup.Set_PlanID) |
| WK-SCP0123-0281 | E4 | cboShipCd / Plan Type  / Ship Cd | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboShipCd / Plan Type  / Ship Cd · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도  |  | 3 (ACT:SCP0123_PlanIDCreatePopup.Set_PlanID) |
| WK-SCP0123-0282 | E4 | cboShipPlanID / Plan ID  / Ship Plan ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboShipPlanID / Plan ID  / Ship Plan ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지 |  | 3 (ACT:SCP0123_PlanIDCreatePopup.Set_PlanID) |
| WK-SCP0123-0283 | E4 | chkCellNoFrozen / No Frozen / Cell No Fr | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkCellNoFrozen / No Frozen / Cell No Frozen · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단)  |  | 5 (ACT:SCP0123_PlanIDCreatePopup.Set_PlanID) |
| WK-SCP0123-0284 | E4 | chkProdNoFrozen / No Frozen / Prod No Fr | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkProdNoFrozen / No Frozen / Prod No Frozen · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단)  |  | 5 (ACT:SCP0123_PlanIDCreatePopup.Set_PlanID) |
| WK-SCP0123-0285 | E4 | chkShipNoFrozen / No Frozen / Ship No Fr | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkShipNoFrozen / No Frozen / Ship No Frozen · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단)  |  | 3 (ACT:SCP0123_PlanIDCreatePopup.Set_PlanID) |
| WK-SCP0123-0286 | E4 | txtDesc / Desc. / Desc | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtDesc / Desc. / Desc · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 3 (ACT:SCP0123_PlanIDCreatePopup.Set_PlanID) |
| WK-SCP0123-0287 | A10 | SCP0123 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0123 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 119 (ACT:SCP0123_PlanControl.DefineProperty A) |
| WK-SCP0123-0288 | A6 | PKG_COM0000.P_SCP0121_GET_SEARCH_INFO | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0121_GET_SEARCH_INFO · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _ |  | 2 (S01 searchInfo) |
| WK-SCP0123-0289 | A6 | PKG_SCP0123.P_SCP0123_GET_PLAN_CONTROL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0123.P_SCP0123_GET_PLAN_CONTROL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 116 (S02 CRUD:P01:SEARCH ACT:SCP0123_PlanCont) |
| WK-SCP0123-0290 | A6 | PKG_SCP0123.P_SCP0123_GET_PLAN_ENGINE_RU | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0123.P_SCP0123_GET_PLAN_ENGINE_RUN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 65 (S03 engineRun ACT:SCP0123_PlanControl.Fi) |
| WK-SCP0123-0291 | A6 | P_SCP0123_ENGINE_RUN_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCP0123_ENGINE_RUN_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@t |  | 1 (engineRun) |
| WK-SCP0123-0292 | A6 | P_SCP0123_PLAN_CONTROL_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCP0123_PLAN_CONTROL_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec( |  | 0 () |
| WK-SCP0123-0293 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (ACT:SCP0123_PlanControl.FindData_Main AC) |
| WK-SCP0123-0294 | G1 | cboPlanDate / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 7 (X06 `ConditionNotUseList.Add(cboPlanDate) |
| WK-SCP0123-0295 | G1 | cboPlanGroup / FCST Version / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanGroup / FCST Version / Plan Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (ACT:SCP0123_PlanControl.FindData_Main AC) |
| WK-SCP0123-0296 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0123_PlanControl.InitControls ACT) |
| WK-SCP0123-0297 | G6 | cboParameter / Parameter | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboParameter / Parameter · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0298 | G6 | cboPlanDate / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (X06 `ConditionNotUseList.Add(cboPlanDate) |
| WK-SCP0123-0299 | G6 | cboPlanGroup / FCST Version / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanGroup / FCST Version / Plan Group · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.InitControls ACT) |
| WK-SCP0123-0300 | G6 | cboProdCd / Plan Type  / Prod Cd | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboProdCd / Plan Type  / Prod Cd · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0301 | G6 | cboProdPlanID / Plan ID  / Prod Plan ID | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboProdPlanID / Plan ID  / Prod Plan ID · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0302 | G6 | cboShipCd / Plan Type  / Ship Cd | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboShipCd / Plan Type  / Ship Cd · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0303 | G6 | cboShipPlanID / Plan ID  / Ship Plan ID | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboShipPlanID / Plan ID  / Ship Plan ID · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0304 | G6 | chkCellNoFrozen / No Frozen / Cell No Fr | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkCellNoFrozen / No Frozen / Cell No Frozen · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanIDCreatePopup.InitEvent ) |
| WK-SCP0123-0305 | G6 | chkProdNoFrozen / No Frozen / Prod No Fr | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkProdNoFrozen / No Frozen / Prod No Frozen · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanIDCreatePopup.InitEvent ) |
| WK-SCP0123-0306 | G6 | chkShipNoFrozen / No Frozen / Ship No Fr | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkShipNoFrozen / No Frozen / Ship No Frozen · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanIDCreatePopup.InitEvent ) |
| WK-SCP0123-0307 | G6 | txtCellStart / Cell  / Cell Start | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtCellStart / Cell  / Cell Start · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0308 | G6 | txtFcstVersion / FCST Version / Fcst Ver | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtFcstVersion / FCST Version / Fcst Version · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0309 | G6 | txtHorizonStart / Plan Horizon / Horizon | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtHorizonStart / Plan Horizon / Horizon Start · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0310 | G6 | txtPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0311 | G6 | txtProdStart / Period / Prod Start | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProdStart / Period / Prod Start · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0312 | G6 | txtShipStart / Period  / Ship Start | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtShipStart / Period  / Ship Start · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0313 | X-REOPEN | SCP0123 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0123 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 15 (ACT:SCP0123_PlanControl.Dispose ACT:SCP0) |
| WK-SCP0123-0314 | M3 | SCP0123_PlanIDCreatePopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SCP0123_PlanIDCreatePopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 17 (ACT:SCP0123_PlanIDCreatePopup..ctor ACT:) |
| WK-SCP0123-0315 | M3 | btnClose | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnClose · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanIDCreatePopup.InitEvent ) |
| WK-SCP0123-0316 | M3 | btnCreatePlan | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnCreatePlan · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 4 (ACT:SCP0123_PlanIDCreatePopup.InitEvent ) |
| WK-SCP0123-0317 | M4 | OPMZ_ACTV_CD | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — OPMZ_ACTV_CD · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_CellDoub) |
| WK-SCP0123-0318 | M4 | OPMZ_PLAN_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — OPMZ_PLAN_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0123_PlanControl.SpdMain_CellDoub) |

## W7 기대값 확정 (367)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0123-0319 | C1 | HANDLER:CboPlanDate_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:CboPlanDate_SelectedIndexChanged: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:CboPlanDate_SelectedIndexChanged) |
| WK-SCP0123-0320 | C1 | HANDLER:CboPlanGroup_SelectedIndexChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:CboPlanGroup_SelectedIndexChanged: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:CboPlanGroup_SelectedIndexChange) |
| WK-SCP0123-0321 | C1 | HANDLER:DpPlanDate_Days_ValueChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:DpPlanDate_Days_ValueChanged: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:DpPlanDate_Days_ValueChanged) |
| WK-SCP0123-0322 | C1 | HANDLER:cboDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — HANDLER:cboDivision_SelectedIndexChanged: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboDivision_SelectedIndexChanged) |
| WK-SCP0123-0323 | C2 | HANDLER:SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — HANDLER:SpdMain_ComboSelChange: 행 집계 — C2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SpdMain_ComboSelChange) |
| WK-SCP0123-0324 | C2 | SCP0123_PlanControl.CboPlanDate_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0123_PlanControl.CboPlanDate_SelectedIndexChang: 진입점 집계 — C2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.CboPlanDate_Sele) |
| WK-SCP0123-0325 | C2 | SCP0123_PlanControl.CboPlanGroup_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0123_PlanControl.CboPlanGroup_SelectedIndexChan: 진입점 집계 — C2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.CboPlanGroup_Sel) |
| WK-SCP0123-0326 | C2 | SCP0123_PlanControl.DpPlanDate_Days_Valu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0123_PlanControl.DpPlanDate_Days_ValueChanged: 진입점 집계 — C2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.DpPlanDate_Days_) |
| WK-SCP0123-0327 | C2 | SCP0123_PlanControl.cboDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0123_PlanControl.cboDivision_SelectedIndexChang: 진입점 집계 — C2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.cboDivision_Sele) |
| WK-SCP0123-0328 | C3 | HANDLER:SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — HANDLER:SpdMain_ComboSelChange: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SpdMain_ComboSelChange) |
| WK-SCP0123-0329 | C3 | SCP0123_PlanControl.CboPlanDate_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0123_PlanControl.CboPlanDate_SelectedIndexChang: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.CboPlanDate_Sele) |
| WK-SCP0123-0330 | C3 | SCP0123_PlanControl.CboPlanGroup_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0123_PlanControl.CboPlanGroup_SelectedIndexChan: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.CboPlanGroup_Sel) |
| WK-SCP0123-0331 | C3 | SCP0123_PlanControl.DpPlanDate_Days_Valu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0123_PlanControl.DpPlanDate_Days_ValueChanged: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.DpPlanDate_Days_) |
| WK-SCP0123-0332 | C3 | SCP0123_PlanControl.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0123_PlanControl.SetChangedControl: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.SetChangedContro) |
| WK-SCP0123-0333 | C3 | SCP0123_PlanControl.SetEngineStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0123_PlanControl.SetEngineStatus: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0123_PlanControl.SetEngineStatus:) |
| WK-SCP0123-0334 | C3 | SCP0123_PlanControl.cboDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0123_PlanControl.cboDivision_SelectedIndexChang: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.cboDivision_Sele) |
| WK-SCP0123-0335 | C6 | HANDLER:SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — HANDLER:SpdMain_ComboSelChange: 행 집계 — C6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SpdMain_ComboSelChange) |
| WK-SCP0123-0336 | C6 | SCP0123_PlanControl.CboPlanDate_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0123_PlanControl.CboPlanDate_SelectedIndexChang: 진입점 집계 — C6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.CboPlanDate_Sele) |
| WK-SCP0123-0337 | C6 | SCP0123_PlanControl.CboPlanGroup_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0123_PlanControl.CboPlanGroup_SelectedIndexChan: 진입점 집계 — C6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.CboPlanGroup_Sel) |
| WK-SCP0123-0338 | C6 | SCP0123_PlanControl.DpPlanDate_Days_Valu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0123_PlanControl.DpPlanDate_Days_ValueChanged: 진입점 집계 — C6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.DpPlanDate_Days_) |
| WK-SCP0123-0339 | C6 | SCP0123_PlanControl.cboDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0123_PlanControl.cboDivision_SelectedIndexChang: 진입점 집계 — C6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.cboDivision_Sele) |
| WK-SCP0123-0340 | B3 | K01 `BLUtils.GetDivision(false,"")` → `U | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — K01 `BLUtils.GetDivision(false,"")` → `UP_FX_GetCo: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (K01 `BLUtils.GetDivision(false,"")` → `U) |
| WK-SCP0123-0341 | B3 | K03·K05 `Data_SCP.CommonAll(PlanID)` + ` | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — K03·K05 `Data_SCP.CommonAll(PlanID)` + `SetComBoPa: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (K03·K05 `Data_SCP.CommonAll(PlanID)` + `) |
| WK-SCP0123-0342 | B3 | SCP0123_PlanControl.GetDataSet_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0123_PlanControl.GetDataSet_Main: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0123_PlanControl.GetDataSet_Main:) |
| WK-SCP0123-0343 | B3 | SCP0123_PlanControl.GetPlanGroupByUserID | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0123_PlanControl.GetPlanGroupByUserID: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0123_PlanControl.GetPlanGroupByUs) |
| WK-SCP0123-0344 | B3 | X01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — X01: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (X01) |
| WK-SCP0123-0345 | B4 | K01 `BLUtils.GetDivision(false,"")` → `U | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — K01 `BLUtils.GetDivision(false,"")` → `UP_FX_GetCo: 행 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (K01 `BLUtils.GetDivision(false,"")` → `U) |
| WK-SCP0123-0346 | B4 | K03·K05 `Data_SCP.CommonAll(PlanID)` + ` | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — K03·K05 `Data_SCP.CommonAll(PlanID)` + `SetComBoPa: 행 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (K03·K05 `Data_SCP.CommonAll(PlanID)` + `) |
| WK-SCP0123-0347 | B4 | SCP0123_PlanControl.GetDataSet_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0123_PlanControl.GetDataSet_Main: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0123_PlanControl.GetDataSet_Main:) |
| WK-SCP0123-0348 | B4 | SCP0123_PlanControl.GetPlanGroupByUserID | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0123_PlanControl.GetPlanGroupByUserID: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0123_PlanControl.GetPlanGroupByUs) |
| WK-SCP0123-0349 | B4 | X01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — X01: 행 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (X01) |
| WK-SCP0123-0350 | B4 | X08 `DataView.Sort="CODE DESC"` (cs:265- | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — X08 `DataView.Sort="CODE DESC"` (cs:265-267): 행 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (X08 `DataView.Sort="CODE DESC"` (cs:265-) |
| WK-SCP0123-0351 | DB-SYN | B05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — B05: 행 집계 — DB-SYN 10요소: PASS:5 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (B05) |
| WK-SCP0123-0352 | DB-SYN | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:FindButton: 행 집계 — DB-SYN 10요소: PASS:5 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindButton) |
| WK-SCP0123-0353 | DB-SYN | HANDLER:SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — HANDLER:SaveData: 행 집계 — DB-SYN 10요소: PASS:5 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SaveData) |
| WK-SCP0123-0354 | DB-SYN | R10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — R10: 행 집계 — DB-SYN 10요소: PASS:5 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (R10) |
| WK-SCP0123-0355 | DB-SYN | R12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — R12: 행 집계 — DB-SYN 10요소: PASS:5 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (R12) |
| WK-SCP0123-0356 | DB-SYN | R29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — R29: 행 집계 — DB-SYN 10요소: PASS:5 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (R29) |
| WK-SCP0123-0357 | DB-SYN | SCP0123_PlanControl.GoPage | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0123_PlanControl.GoPage: 진입점 집계 — DB-SYN 10요소: PASS:5 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.GoPage:812:3 ACT) |
| WK-SCP0123-0358 | F4 | B05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — B05: 행 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (B05) |
| WK-SCP0123-0359 | F4 | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:FindButton: 행 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindButton) |
| WK-SCP0123-0360 | F4 | HANDLER:SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — HANDLER:SaveData: 행 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SaveData) |
| WK-SCP0123-0361 | F4 | R10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — R10: 행 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R10) |
| WK-SCP0123-0362 | F4 | R12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — R12: 행 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R12) |
| WK-SCP0123-0363 | F4 | R29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — R29: 행 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R29) |
| WK-SCP0123-0364 | F4 | SCP0123_PlanControl.GoPage | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0123_PlanControl.GoPage: 진입점 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.GoPage:812:3 ACT) |
| WK-SCP0123-0365 | A5 | (고정열) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — (고정열): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 ((고정열)) |
| WK-SCP0123-0366 | A5 | (병합) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — (병합): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 ((병합)) |
| WK-SCP0123-0367 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0123-0368 | A5 | CRUD:P01:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — CRUD:P01:SEARCH: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:P01:SEARCH) |
| WK-SCP0123-0369 | A5 | G01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — G01: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (G01) |
| WK-SCP0123-0370 | A5 | G02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — G02: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (G02) |
| WK-SCP0123-0371 | A5 | HANDLER:CboPlanDate_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — HANDLER:CboPlanDate_SelectedIndexChanged: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:CboPlanDate_SelectedIndexChanged) |
| WK-SCP0123-0372 | A5 | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — HANDLER:Form_Load: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:Form_Load) |
| WK-SCP0123-0373 | A5 | HANDLER:cboDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — HANDLER:cboDivision_SelectedIndexChanged: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboDivision_SelectedIndexChanged) |
| WK-SCP0123-0374 | A5 | R13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R13: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R13) |
| WK-SCP0123-0375 | A5 | R16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R16: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R16) |
| WK-SCP0123-0376 | A5 | R17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R17: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R17) |
| WK-SCP0123-0377 | A5 | R18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R18: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R18) |
| WK-SCP0123-0378 | A5 | R23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R23: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R23) |
| WK-SCP0123-0379 | A5 | R29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R29: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R29) |
| WK-SCP0123-0380 | A5 | SCP0123_PlanControl.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0123_PlanControl.CreateSpread: 진입점 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0123_PlanControl.CreateSpread:282) |
| WK-SCP0123-0381 | A5 | X02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — X02: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (X02) |
| WK-SCP0123-0382 | A5 | X08 `DataView.Sort="CODE DESC"` (cs:265- | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — X08 `DataView.Sort="CODE DESC"` (cs:265-267): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (X08 `DataView.Sort="CODE DESC"` (cs:265-) |
| WK-SCP0123-0383 | A5 | `spdMain` / `spdSub` (FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `spdMain` / `spdSub` (FpSpread): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`spdMain` / `spdSub` (FpSpread)) |
| WK-SCP0123-0384 | G4 | C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0): 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0)) |
| WK-SCP0123-0385 | G4 | F01 `DBUtils.Filter(dtMyDivision,"CODE I | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — F01 `DBUtils.Filter(dtMyDivision,"CODE IN (planGro: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (F01 `DBUtils.Filter(dtMyDivision,"CODE I) |
| WK-SCP0123-0386 | G4 | F02 `DBUtils.Filter(dtPlanGroupAll,"DIVI | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — F02 `DBUtils.Filter(dtPlanGroupAll,"DIVISION_ID='.: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (F02 `DBUtils.Filter(dtPlanGroupAll,"DIVI) |
| WK-SCP0123-0387 | G4 | F03·F05·F07~F10 판정식 6회 중복 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — F03·F05·F07~F10 판정식 6회 중복: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (F03·F05·F07~F10 판정식 6회 중복) |
| WK-SCP0123-0388 | G4 | F04 `DBUtils.Filter(dtPlanDateAll,"DIVIS | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — F04 `DBUtils.Filter(dtPlanDateAll,"DIVISION_ID='..: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (F04 `DBUtils.Filter(dtPlanDateAll,"DIVIS) |
| WK-SCP0123-0389 | G4 | F06 3키 좁힘 (cs:262) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — F06 3키 좁힘 (cs:262): 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (F06 3키 좁힘 (cs:262)) |
| WK-SCP0123-0390 | G4 | K01 `BLUtils.GetDivision(false,"")` → `U | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — K01 `BLUtils.GetDivision(false,"")` → `UP_FX_GetCo: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (K01 `BLUtils.GetDivision(false,"")` → `U) |
| WK-SCP0123-0391 | G4 | K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY)`: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY) |
| WK-SCP0123-0392 | G4 | K03·K05 `Data_SCP.CommonAll(PlanID)` + ` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — K03·K05 `Data_SCP.CommonAll(PlanID)` + `SetComBoPa: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (K03·K05 `Data_SCP.CommonAll(PlanID)` + `) |
| WK-SCP0123-0393 | G4 | K04 `Data.Common(LookupCommon,"OPMZ_DIVI | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — K04 `Data.Common(LookupCommon,"OPMZ_DIVISION_GM")`: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (K04 `Data.Common(LookupCommon,"OPMZ_DIVI) |
| WK-SCP0123-0394 | G4 | X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검사: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검) |
| WK-SCP0123-0395 | G4 | X08 `DataView.Sort="CODE DESC"` (cs:265- | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — X08 `DataView.Sort="CODE DESC"` (cs:265-267): 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (X08 `DataView.Sort="CODE DESC"` (cs:265-) |
| WK-SCP0123-0396 | G4 | X14 `dsSearchInfo.Tables[3]` = Plan Grou | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — X14 `dsSearchInfo.Tables[3]` = Plan Group 공급: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (X14 `dsSearchInfo.Tables[3]` = Plan Grou) |
| WK-SCP0123-0397 | G4 | X21 `NowGroupID in (ADMIN, SCM PI Admin) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — X21 `NowGroupID in (ADMIN, SCM PI Admin)` ? `p_use: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (X21 `NowGroupID in (ADMIN, SCM PI Admin)) |
| WK-SCP0123-0398 | G4 | `setListBox` 바인딩 직후 첫 행 자동 선택(Division / | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `setListBox` 바인딩 직후 첫 행 자동 선택(Division / Plan Grou: 행 집계 — G4 19요소: NOT_RUN:17 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`setListBox` 바인딩 직후 첫 행 자동 선택(Division /) |
| WK-SCP0123-0399 | H2 | (고정열) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — (고정열): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 ((고정열)) |
| WK-SCP0123-0400 | H2 | (병합) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — (병합): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 ((병합)) |
| WK-SCP0123-0401 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0123-0402 | H2 | CRUD:P01:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — CRUD:P01:SEARCH: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:P01:SEARCH) |
| WK-SCP0123-0403 | H2 | G01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G01: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (G01) |
| WK-SCP0123-0404 | H2 | G02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G02: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (G02) |
| WK-SCP0123-0405 | H2 | HANDLER:CboPlanDate_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — HANDLER:CboPlanDate_SelectedIndexChanged: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:CboPlanDate_SelectedIndexChanged) |
| WK-SCP0123-0406 | H2 | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — HANDLER:Form_Load: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:Form_Load) |
| WK-SCP0123-0407 | H2 | HANDLER:cboDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — HANDLER:cboDivision_SelectedIndexChanged: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboDivision_SelectedIndexChanged) |
| WK-SCP0123-0408 | H2 | R01~R03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R01~R03: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R01~R03) |
| WK-SCP0123-0409 | H2 | R05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R05: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R05) |
| WK-SCP0123-0410 | H2 | R13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R13: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R13) |
| WK-SCP0123-0411 | H2 | R16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R16: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R16) |
| WK-SCP0123-0412 | H2 | R17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R17: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R17) |
| WK-SCP0123-0413 | H2 | R18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R18: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R18) |
| WK-SCP0123-0414 | H2 | R29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R29: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R29) |
| WK-SCP0123-0415 | H2 | SCP0123_PlanControl.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0123_PlanControl.CreateSpread: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0123_PlanControl.CreateSpread:282) |
| WK-SCP0123-0416 | H2 | X02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — X02: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (X02) |
| WK-SCP0123-0417 | H2 | X08 `DataView.Sort="CODE DESC"` (cs:265- | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — X08 `DataView.Sort="CODE DESC"` (cs:265-267): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (X08 `DataView.Sort="CODE DESC"` (cs:265-) |
| WK-SCP0123-0418 | H2 | `spdMain` / `spdSub` (FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `spdMain` / `spdSub` (FpSpread): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`spdMain` / `spdSub` (FpSpread)) |
| WK-SCP0123-0419 | H5 | (고정열) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — (고정열): 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 ((고정열)) |
| WK-SCP0123-0420 | H5 | (병합) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — (병합): 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 ((병합)) |
| WK-SCP0123-0421 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0123-0422 | H5 | CRUD:P01:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — CRUD:P01:SEARCH: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:P01:SEARCH) |
| WK-SCP0123-0423 | H5 | G01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G01: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (G01) |
| WK-SCP0123-0424 | H5 | G02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G02: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (G02) |
| WK-SCP0123-0425 | H5 | HANDLER:CboPlanDate_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — HANDLER:CboPlanDate_SelectedIndexChanged: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:CboPlanDate_SelectedIndexChanged) |
| WK-SCP0123-0426 | H5 | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — HANDLER:Form_Load: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:Form_Load) |
| WK-SCP0123-0427 | H5 | HANDLER:cboDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — HANDLER:cboDivision_SelectedIndexChanged: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboDivision_SelectedIndexChanged) |
| WK-SCP0123-0428 | H5 | R13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R13: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R13) |
| WK-SCP0123-0429 | H5 | R16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R16: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R16) |
| WK-SCP0123-0430 | H5 | R17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R17: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R17) |
| WK-SCP0123-0431 | H5 | R18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R18: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R18) |
| WK-SCP0123-0432 | H5 | R29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R29: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R29) |
| WK-SCP0123-0433 | H5 | SCP0123_PlanControl.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0123_PlanControl.CreateSpread: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0123_PlanControl.CreateSpread:282) |
| WK-SCP0123-0434 | H5 | X02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — X02: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (X02) |
| WK-SCP0123-0435 | H5 | X08 `DataView.Sort="CODE DESC"` (cs:265- | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — X08 `DataView.Sort="CODE DESC"` (cs:265-267): 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (X08 `DataView.Sort="CODE DESC"` (cs:265-) |
| WK-SCP0123-0436 | H5 | `spdMain` / `spdSub` (FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `spdMain` / `spdSub` (FpSpread): 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`spdMain` / `spdSub` (FpSpread)) |
| WK-SCP0123-0437 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지)  이 화면은 ** |  | 1 (COMMON:UC-01) |
| WK-SCP0123-0438 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도  이 화면은 SubTitle 의 컬럼설정·Measure 아이콘을 쓰지 않 |  | 1 (COMMON:UC-03) |
| WK-SCP0123-0439 | X-REASON | COMMON:UC-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-05 Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 공용 위임 — `SubTitle` excel + `gridAction` 의 dataMap 승 |  | 1 (COMMON:UC-05) |
| WK-SCP0123-0440 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회  이 화면 조회조건 3필드는 전부 단일 select(`CustomDropdown` 2) + DatePicker 1  |  | 1 (COMMON:UC-06) |
| WK-SCP0123-0441 | X-REASON | CRUD:DELETE | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CRUD:DELETE (AS-IS Delete(F9) override 부재 = NO-OP)  삭제 기능이 AS-IS·TO-BE 모두 없다 — `MNU_BTN_CD` DELETE 0행(DB 실측), ` |  | 1 (CRUD:DELETE) |
| WK-SCP0123-0442 | X-REASON | CRUD:INSERT | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CRUD:INSERT (AS-IS Insert(F8) override 부재 = `BaseForm` 빈 구현 NO-OP)  행 추가 기능이 AS-IS·TO-BE 모두 없다 — `SCM_ADM_MNU_B |  | 1 (CRUD:INSERT) |
| WK-SCP0123-0443 | X-REASON | G17 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G17 SCP0039 팝업 OK 시 `DETAIL` 기입 + `isValidSearch=true` (cs:930-936) store `setMasterValidation` 배선은 있으나 **팝업 반환 |  | 1 (G17) |
| WK-SCP0123-0444 | X-REASON | MODAL:SCP0123_PlanIDCreatePopup | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:SCP0123_PlanIDCreatePopup `00_checklist §4e` U02/U04/U05 — A002 의 조회·생성 두 모드 팝업(AS-IS 별도 Form + SP 2건)  g |  | 1 (MODAL:SCP0123_PlanIDCreatePopup) |
| WK-SCP0123-0445 | X-REASON | R26 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — R26 `TB_FX_GroupMenuAuth` 4그룹 TO-BE `USER_GR_MNU_BTN_MPG_M` 동일 4그룹 — 변경 불요 AS-IS 4그룹 = TO-BE `SCM_ADM_USER_GR_M |  | 1 (R26) |
| WK-SCP0123-0446 | X-REASON | U03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — U03 `SCP0039_ValidationMaster`(division_id, plan_group_id) → `criticalCnt`/`warningCnt` 반환 TO-BE SCP0039 는 **모달 |  | 1 (U03) |
| WK-SCP0123-0447 | X-REASON | U05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — U05 〃 생성 모드(CONFIRM A002, plan_id='') 동상 goal.md §0-D **B3** 승인된 범위 밖 — `SCP0123_PlanIDCreatePopup` 은 메인 폼 전환 범 |  | 1 (U05) |
| WK-SCP0123-0448 | X-REASON | X06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — X06 `ConditionNotUseList.Add(cboPlanDate)` TO-BE 조회조건 저장 기능 부재 TO-BE 에 조회조건 저장(Condition) 기능 자체가 없다 — 이식 대상 0건( |  | 1 (X06) |
| WK-SCP0123-0449 | X-REASON | X10 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — X10 `AddSheet(spd,name,name,1,1,30)` frozen 1행/1열 `FIXED_FLAG` 전건 `-` → frozenColumns 0. AS-IS frozen col 1 은 폭 |  | 1 (X10) |
| WK-SCP0123-0450 | X-REASON | X19 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — X19 A001 LINK → SCP0039 팝업 §4 X19 행 goal.md §0-D **D2** 승인된 의도적 차이 — TO-BE SCP0039 는 모달이 아니라 독립 화면(supply/maste |  | 1 (X19) |
| WK-SCP0123-0451 | X-REASON | X20 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — X20 A002 CONFIRM → Plan ID 생성 팝업 §4 X20 행 goal.md §0-D **B3** 승인된 범위 밖 — `SCP0123_PlanIDCreatePopup` 은 메인 폼 전환  |  | 1 (X20) |
| WK-SCP0123-0452 | D1 | G08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G08: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (G08) |
| WK-SCP0123-0453 | D1 | G13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G13: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (G13) |
| WK-SCP0123-0454 | D1 | X05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — X05: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (X05) |
| WK-SCP0123-0455 | D3 | G08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G08: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (G08) |
| WK-SCP0123-0456 | D3 | G13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G13: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (G13) |
| WK-SCP0123-0457 | D3 | R01~R03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R01~R03: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R01~R03) |
| WK-SCP0123-0458 | D3 | R05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R05: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R05) |
| WK-SCP0123-0459 | D3 | X05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — X05: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (X05) |
| WK-SCP0123-0460 | D4 | (else) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — (else): 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 ((else)) |
| WK-SCP0123-0461 | D4 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — B04: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (B04) |
| WK-SCP0123-0462 | D4 | R11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — R11: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R11) |
| WK-SCP0123-0463 | D4 | R11' | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — R11': 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R11') |
| WK-SCP0123-0464 | D4 | X08 `DataView.Sort="CODE DESC"` (cs:265- | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — X08 `DataView.Sort="CODE DESC"` (cs:265-267): 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (X08 `DataView.Sort="CODE DESC"` (cs:265-) |
| WK-SCP0123-0465 | E4 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — B04: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (B04) |
| WK-SCP0123-0466 | E4 | B13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — B13: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (B13) |
| WK-SCP0123-0467 | E4 | B15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — B15: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (B15) |
| WK-SCP0123-0468 | E4 | G06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — G06: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (G06) |
| WK-SCP0123-0469 | E4 | HANDLER:CboPlanDate_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — HANDLER:CboPlanDate_SelectedIndexChanged: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:CboPlanDate_SelectedIndexChanged) |
| WK-SCP0123-0470 | E4 | HANDLER:cboDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — HANDLER:cboDivision_SelectedIndexChanged: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:cboDivision_SelectedIndexChanged) |
| WK-SCP0123-0471 | E4 | R29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R29: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (R29) |
| WK-SCP0123-0472 | E4 | SCP0123_PlanControl.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0123_PlanControl.SetChangedControl: 진입점 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanControl.SetChangedContro) |
| WK-SCP0123-0473 | E4 | SCP0123_PlanControl.SetEngineStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0123_PlanControl.SetEngineStatus: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0123_PlanControl.SetEngineStatus:) |
| WK-SCP0123-0474 | E4 | X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검사: 행 집계 — E4 40요소: NOT_RUN:40 (미실행 요소가 남아 판정필요) |  | 1 (X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검) |
| WK-SCP0123-0475 | A1 | B16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B16: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (B16) |
| WK-SCP0123-0476 | A1 | B29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B29: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (B29) |
| WK-SCP0123-0477 | A1 | B30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B30: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (B30) |
| WK-SCP0123-0478 | A1 | B36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B36: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (B36) |
| WK-SCP0123-0479 | A1 | B40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B40: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (B40) |
| WK-SCP0123-0480 | A1 | C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0)) |
| WK-SCP0123-0481 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-02) |
| WK-SCP0123-0482 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-07) |
| WK-SCP0123-0483 | A1 | F01 `DBUtils.Filter(dtMyDivision,"CODE I | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F01 `DBUtils.Filter(dtMyDivision,"CODE IN (planGro: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (F01 `DBUtils.Filter(dtMyDivision,"CODE I) |
| WK-SCP0123-0484 | A1 | F02 `DBUtils.Filter(dtPlanGroupAll,"DIVI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F02 `DBUtils.Filter(dtPlanGroupAll,"DIVISION_ID='.: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (F02 `DBUtils.Filter(dtPlanGroupAll,"DIVI) |
| WK-SCP0123-0485 | A1 | F03·F05·F07~F10 판정식 6회 중복 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F03·F05·F07~F10 판정식 6회 중복: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (F03·F05·F07~F10 판정식 6회 중복) |
| WK-SCP0123-0486 | A1 | F04 `DBUtils.Filter(dtPlanDateAll,"DIVIS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F04 `DBUtils.Filter(dtPlanDateAll,"DIVISION_ID='..: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (F04 `DBUtils.Filter(dtPlanDateAll,"DIVIS) |
| WK-SCP0123-0487 | A1 | F06 3키 좁힘 (cs:262) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F06 3키 좁힘 (cs:262): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (F06 3키 좁힘 (cs:262)) |
| WK-SCP0123-0488 | A1 | G06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G06: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (G06) |
| WK-SCP0123-0489 | A1 | G18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G18: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (G18) |
| WK-SCP0123-0490 | A1 | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:FindButton: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (HANDLER:FindButton) |
| WK-SCP0123-0491 | A1 | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:Form_Load: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (HANDLER:Form_Load) |
| WK-SCP0123-0492 | A1 | HANDLER:SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:SpdMain_CellDoubleClick: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (HANDLER:SpdMain_CellDoubleClick) |
| WK-SCP0123-0493 | A1 | HANDLER:SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — HANDLER:SpdMain_ComboSelChange: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (HANDLER:SpdMain_ComboSelChange) |
| WK-SCP0123-0494 | A1 | K01 `BLUtils.GetDivision(false,"")` → `U | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — K01 `BLUtils.GetDivision(false,"")` → `UP_FX_GetCo: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (K01 `BLUtils.GetDivision(false,"")` → `U) |
| WK-SCP0123-0495 | A1 | K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY)`: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY) |
| WK-SCP0123-0496 | A1 | K03·K05 `Data_SCP.CommonAll(PlanID)` + ` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — K03·K05 `Data_SCP.CommonAll(PlanID)` + `SetComBoPa: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (K03·K05 `Data_SCP.CommonAll(PlanID)` + `) |
| WK-SCP0123-0497 | A1 | K04 `Data.Common(LookupCommon,"OPMZ_DIVI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — K04 `Data.Common(LookupCommon,"OPMZ_DIVISION_GM")`: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (K04 `Data.Common(LookupCommon,"OPMZ_DIVI) |
| WK-SCP0123-0498 | A1 | PKG_COM0000.P_SCP0121_GET_SEARCH_INFO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0121_GET_SEARCH_INFO: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0121_GET_SEARCH_INFO — 팝업·보조 SP 는 golden_cases.cs |  | 2 (S01 searchInfo) |
| WK-SCP0123-0499 | A1 | PKG_SCP0123.P_SCP0123_GET_PLAN_CONTROL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0123.P_SCP0123_GET_PLAN_CONTROL: 골든 비교 케이스 없음(PKG_SCP0123.P_SCP0123_GET_PLAN_CONTROL — 팝업·보조 SP 는 golden_cases. |  | 116 (S02 CRUD:P01:SEARCH ACT:SCP0123_PlanCont) |
| WK-SCP0123-0500 | A1 | PKG_SCP0123.P_SCP0123_GET_PLAN_ENGINE_RU | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0123.P_SCP0123_GET_PLAN_ENGINE_RUN: 골든 비교 케이스 없음(PKG_SCP0123.P_SCP0123_GET_PLAN_ENGINE_RUN — 팝업·보조 SP 는 golden_ |  | 65 (S03 engineRun ACT:SCP0123_PlanControl.Fi) |
| WK-SCP0123-0501 | A1 | P_SCP0123_ENGINE_RUN_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0123_ENGINE_RUN_GET: 골든 비교 케이스 없음(P_SCP0123_ENGINE_RUN_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 1 (engineRun) |
| WK-SCP0123-0502 | A1 | P_SCP0123_PLAN_CONTROL_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0123_PLAN_CONTROL_GET: 골든 비교 케이스 없음(P_SCP0123_PLAN_CONTROL_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추 |  | 0 () |
| WK-SCP0123-0503 | A1 | R08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R08: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (R08) |
| WK-SCP0123-0504 | A1 | R10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R10: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (R10) |
| WK-SCP0123-0505 | A1 | R21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R21: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (R21) |
| WK-SCP0123-0506 | A1 | R27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R27: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (R27) |
| WK-SCP0123-0507 | A1 | R29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R29: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (R29) |
| WK-SCP0123-0508 | A1 | U01·U02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — U01·U02: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (U01·U02) |
| WK-SCP0123-0509 | A1 | X01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — X01: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (X01) |
| WK-SCP0123-0510 | A1 | X04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — X04: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (X04) |
| WK-SCP0123-0511 | A1 | X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검사: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검) |
| WK-SCP0123-0512 | A1 | X06 `ConditionNotUseList.Add(cboPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — X06 `ConditionNotUseList.Add(cboPlanDate)`: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (X06 `ConditionNotUseList.Add(cboPlanDate) |
| WK-SCP0123-0513 | A1 | X08 `DataView.Sort="CODE DESC"` (cs:265- | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — X08 `DataView.Sort="CODE DESC"` (cs:265-267): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (X08 `DataView.Sort="CODE DESC"` (cs:265-) |
| WK-SCP0123-0514 | A1 | X14 `dsSearchInfo.Tables[3]` = Plan Grou | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — X14 `dsSearchInfo.Tables[3]` = Plan Group 공급: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (X14 `dsSearchInfo.Tables[3]` = Plan Grou) |
| WK-SCP0123-0515 | A1 | X17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — X17: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (X17) |
| WK-SCP0123-0516 | A1 | X21 `NowGroupID in (ADMIN, SCM PI Admin) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — X21 `NowGroupID in (ADMIN, SCM PI Admin)` ? `p_use: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (X21 `NowGroupID in (ADMIN, SCM PI Admin)) |
| WK-SCP0123-0517 | A1 | `setListBox` 바인딩 직후 첫 행 자동 선택(Division / | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `setListBox` 바인딩 직후 첫 행 자동 선택(Division / Plan Grou: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (`setListBox` 바인딩 직후 첫 행 자동 선택(Division /) |
| WK-SCP0123-0518 | A6 | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — HANDLER:FindButton: 행 집계 — A6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindButton) |
| WK-SCP0123-0519 | A6 | R10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — R10: 행 집계 — A6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R10) |
| WK-SCP0123-0520 | A6 | R29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — R29: 행 집계 — A6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R29) |
| WK-SCP0123-0521 | G1 | B16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — B16: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (B16) |
| WK-SCP0123-0522 | G1 | B29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — B29: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (B29) |
| WK-SCP0123-0523 | G1 | B30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — B30: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (B30) |
| WK-SCP0123-0524 | G1 | B36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — B36: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (B36) |
| WK-SCP0123-0525 | G1 | B40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — B40: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (B40) |
| WK-SCP0123-0526 | G1 | C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0): 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0)) |
| WK-SCP0123-0527 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0123-0528 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0123-0529 | G1 | CRUD:P01:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CRUD:P01:SEARCH: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:P01:SEARCH) |
| WK-SCP0123-0530 | G1 | F01 `DBUtils.Filter(dtMyDivision,"CODE I | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F01 `DBUtils.Filter(dtMyDivision,"CODE IN (planGro: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (F01 `DBUtils.Filter(dtMyDivision,"CODE I) |
| WK-SCP0123-0531 | G1 | F02 `DBUtils.Filter(dtPlanGroupAll,"DIVI | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F02 `DBUtils.Filter(dtPlanGroupAll,"DIVISION_ID='.: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (F02 `DBUtils.Filter(dtPlanGroupAll,"DIVI) |
| WK-SCP0123-0532 | G1 | F03·F05·F07~F10 판정식 6회 중복 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F03·F05·F07~F10 판정식 6회 중복: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (F03·F05·F07~F10 판정식 6회 중복) |
| WK-SCP0123-0533 | G1 | F04 `DBUtils.Filter(dtPlanDateAll,"DIVIS | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F04 `DBUtils.Filter(dtPlanDateAll,"DIVISION_ID='..: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (F04 `DBUtils.Filter(dtPlanDateAll,"DIVIS) |
| WK-SCP0123-0534 | G1 | F06 3키 좁힘 (cs:262) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F06 3키 좁힘 (cs:262): 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (F06 3키 좁힘 (cs:262)) |
| WK-SCP0123-0535 | G1 | G06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — G06: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (G06) |
| WK-SCP0123-0536 | G1 | G18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — G18: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (G18) |
| WK-SCP0123-0537 | G1 | HANDLER:FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — HANDLER:FindButton: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:FindButton) |
| WK-SCP0123-0538 | G1 | HANDLER:Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — HANDLER:Form_Load: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:Form_Load) |
| WK-SCP0123-0539 | G1 | HANDLER:SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — HANDLER:SpdMain_CellDoubleClick: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SpdMain_CellDoubleClick) |
| WK-SCP0123-0540 | G1 | HANDLER:SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — HANDLER:SpdMain_ComboSelChange: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SpdMain_ComboSelChange) |
| WK-SCP0123-0541 | G1 | K01 `BLUtils.GetDivision(false,"")` → `U | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — K01 `BLUtils.GetDivision(false,"")` → `UP_FX_GetCo: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (K01 `BLUtils.GetDivision(false,"")` → `U) |
| WK-SCP0123-0542 | G1 | K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY)`: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY) |
| WK-SCP0123-0543 | G1 | K03·K05 `Data_SCP.CommonAll(PlanID)` + ` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — K03·K05 `Data_SCP.CommonAll(PlanID)` + `SetComBoPa: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (K03·K05 `Data_SCP.CommonAll(PlanID)` + `) |
| WK-SCP0123-0544 | G1 | K04 `Data.Common(LookupCommon,"OPMZ_DIVI | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — K04 `Data.Common(LookupCommon,"OPMZ_DIVISION_GM")`: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (K04 `Data.Common(LookupCommon,"OPMZ_DIVI) |
| WK-SCP0123-0545 | G1 | R08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R08: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R08) |
| WK-SCP0123-0546 | G1 | R10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R10: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R10) |
| WK-SCP0123-0547 | G1 | R21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R21: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R21) |
| WK-SCP0123-0548 | G1 | R27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R27: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R27) |
| WK-SCP0123-0549 | G1 | U01·U02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — U01·U02: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (U01·U02) |
| WK-SCP0123-0550 | G1 | X01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — X01: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (X01) |
| WK-SCP0123-0551 | G1 | X04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — X04: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (X04) |
| WK-SCP0123-0552 | G1 | X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검사: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검) |
| WK-SCP0123-0553 | G1 | X08 `DataView.Sort="CODE DESC"` (cs:265- | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — X08 `DataView.Sort="CODE DESC"` (cs:265-267): 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (X08 `DataView.Sort="CODE DESC"` (cs:265-) |
| WK-SCP0123-0554 | G1 | X14 `dsSearchInfo.Tables[3]` = Plan Grou | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — X14 `dsSearchInfo.Tables[3]` = Plan Group 공급: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (X14 `dsSearchInfo.Tables[3]` = Plan Grou) |
| WK-SCP0123-0555 | G1 | X17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — X17: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (X17) |
| WK-SCP0123-0556 | G1 | X21 `NowGroupID in (ADMIN, SCM PI Admin) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — X21 `NowGroupID in (ADMIN, SCM PI Admin)` ? `p_use: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (X21 `NowGroupID in (ADMIN, SCM PI Admin)) |
| WK-SCP0123-0557 | G1 | `setListBox` 바인딩 직후 첫 행 자동 선택(Division / | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `setListBox` 바인딩 직후 첫 행 자동 선택(Division / Plan Grou: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`setListBox` 바인딩 직후 첫 행 자동 선택(Division /) |
| WK-SCP0123-0558 | G1 | engineRun | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — engineRun: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (engineRun) |
| WK-SCP0123-0559 | G1 | planControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — planControl: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0123-0560 | G1 | searchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — searchInfo: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (searchInfo) |
| WK-SCP0123-0561 | G6 | C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0): 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (C3-1~C3-8 cascade 전건 "필터 방식"(서버 재조회 0)) |
| WK-SCP0123-0562 | G6 | F01 `DBUtils.Filter(dtMyDivision,"CODE I | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — F01 `DBUtils.Filter(dtMyDivision,"CODE IN (planGro: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (F01 `DBUtils.Filter(dtMyDivision,"CODE I) |
| WK-SCP0123-0563 | G6 | F02 `DBUtils.Filter(dtPlanGroupAll,"DIVI | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — F02 `DBUtils.Filter(dtPlanGroupAll,"DIVISION_ID='.: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (F02 `DBUtils.Filter(dtPlanGroupAll,"DIVI) |
| WK-SCP0123-0564 | G6 | F03·F05·F07~F10 판정식 6회 중복 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — F03·F05·F07~F10 판정식 6회 중복: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (F03·F05·F07~F10 판정식 6회 중복) |
| WK-SCP0123-0565 | G6 | F04 `DBUtils.Filter(dtPlanDateAll,"DIVIS | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — F04 `DBUtils.Filter(dtPlanDateAll,"DIVISION_ID='..: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (F04 `DBUtils.Filter(dtPlanDateAll,"DIVIS) |
| WK-SCP0123-0566 | G6 | F06 3키 좁힘 (cs:262) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — F06 3키 좁힘 (cs:262): 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (F06 3키 좁힘 (cs:262)) |
| WK-SCP0123-0567 | G6 | K01 `BLUtils.GetDivision(false,"")` → `U | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — K01 `BLUtils.GetDivision(false,"")` → `UP_FX_GetCo: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (K01 `BLUtils.GetDivision(false,"")` → `U) |
| WK-SCP0123-0568 | G6 | K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY)`: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (K02 `Data_SCP.CommonAll(OPMZ_DATE_WEEKLY) |
| WK-SCP0123-0569 | G6 | K03·K05 `Data_SCP.CommonAll(PlanID)` + ` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — K03·K05 `Data_SCP.CommonAll(PlanID)` + `SetComBoPa: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (K03·K05 `Data_SCP.CommonAll(PlanID)` + `) |
| WK-SCP0123-0570 | G6 | K04 `Data.Common(LookupCommon,"OPMZ_DIVI | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — K04 `Data.Common(LookupCommon,"OPMZ_DIVISION_GM")`: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (K04 `Data.Common(LookupCommon,"OPMZ_DIVI) |
| WK-SCP0123-0571 | G6 | X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검사: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (X04 `checkRequiredOfSearch` 필수(`*`) 라벨 검) |
| WK-SCP0123-0572 | G6 | X08 `DataView.Sort="CODE DESC"` (cs:265- | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — X08 `DataView.Sort="CODE DESC"` (cs:265-267): 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (X08 `DataView.Sort="CODE DESC"` (cs:265-) |
| WK-SCP0123-0573 | G6 | X14 `dsSearchInfo.Tables[3]` = Plan Grou | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — X14 `dsSearchInfo.Tables[3]` = Plan Group 공급: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (X14 `dsSearchInfo.Tables[3]` = Plan Grou) |
| WK-SCP0123-0574 | G6 | X21 `NowGroupID in (ADMIN, SCM PI Admin) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — X21 `NowGroupID in (ADMIN, SCM PI Admin)` ? `p_use: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (X21 `NowGroupID in (ADMIN, SCM PI Admin)) |
| WK-SCP0123-0575 | G6 | `setListBox` 바인딩 직후 첫 행 자동 선택(Division / | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `setListBox` 바인딩 직후 첫 행 자동 선택(Division / Plan Grou: 행 집계 — G6 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (`setListBox` 바인딩 직후 첫 행 자동 선택(Division /) |
| WK-SCP0123-0576 | X-LOC | **SCP Planner** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **SCP Planner**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**SCP Planner**) |
| WK-SCP0123-0577 | X-LOC | ADMIN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ADMIN: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ADMIN) |
| WK-SCP0123-0578 | X-LOC | FP Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FP Planner: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FP Planner) |
| WK-SCP0123-0579 | X-LOC | SCM PI Admin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCM PI Admin: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCM PI Admin) |
| WK-SCP0123-0580 | X-LOC | engineRun | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — engineRun: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (engineRun) |
| WK-SCP0123-0581 | X-LOC | planControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — planControl: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (planControl) |
| WK-SCP0123-0582 | X-LOC | searchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — searchInfo: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (searchInfo) |
| WK-SCP0123-0583 | X-ROW | **SCP Planner** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — **SCP Planner**: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (**SCP Planner**) |
| WK-SCP0123-0584 | X-ROW | ADMIN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ADMIN: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (ADMIN) |
| WK-SCP0123-0585 | X-ROW | B01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B01) |
| WK-SCP0123-0586 | X-ROW | B02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B02) |
| WK-SCP0123-0587 | X-ROW | B03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B03) |
| WK-SCP0123-0588 | X-ROW | B07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B07) |
| WK-SCP0123-0589 | X-ROW | B08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B08) |
| WK-SCP0123-0590 | X-ROW | B09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B09: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B09) |
| WK-SCP0123-0591 | X-ROW | B10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B10) |
| WK-SCP0123-0592 | X-ROW | B12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B12) |
| WK-SCP0123-0593 | X-ROW | B14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B14) |
| WK-SCP0123-0594 | X-ROW | B19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B19: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B19) |
| WK-SCP0123-0595 | X-ROW | B21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B21: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B21) |
| WK-SCP0123-0596 | X-ROW | B23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B23: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B23) |
| WK-SCP0123-0597 | X-ROW | B27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B27: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B27) |
| WK-SCP0123-0598 | X-ROW | B31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B31: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B31) |
| WK-SCP0123-0599 | X-ROW | B34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B34: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B34) |
| WK-SCP0123-0600 | X-ROW | B37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B37: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B37) |
| WK-SCP0123-0601 | X-ROW | B39 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B39: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B39) |
| WK-SCP0123-0602 | X-ROW | FP Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — FP Planner: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (FP Planner) |
| WK-SCP0123-0603 | X-ROW | G03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G03) |
| WK-SCP0123-0604 | X-ROW | G07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G07) |
| WK-SCP0123-0605 | X-ROW | G11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G11) |
| WK-SCP0123-0606 | X-ROW | G12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G12) |
| WK-SCP0123-0607 | X-ROW | G15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G15: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G15) |
| WK-SCP0123-0608 | X-ROW | G16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G16: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G16) |
| WK-SCP0123-0609 | X-ROW | G19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G19: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G19) |
| WK-SCP0123-0610 | X-ROW | G20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G20: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G20) |
| WK-SCP0123-0611 | X-ROW | G21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G21: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G21) |
| WK-SCP0123-0612 | X-ROW | HANDLER:SpdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — HANDLER:SpdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (HANDLER:SpdMain_CellClick) |
| WK-SCP0123-0613 | X-ROW | R14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R14) |
| WK-SCP0123-0614 | X-ROW | R15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R15: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R15) |
| WK-SCP0123-0615 | X-ROW | R19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R19: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R19) |
| WK-SCP0123-0616 | X-ROW | R20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R20: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R20) |
| WK-SCP0123-0617 | X-ROW | R22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R22: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R22) |
| WK-SCP0123-0618 | X-ROW | R24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R24: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R24) |
| WK-SCP0123-0619 | X-ROW | R30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R30: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R30) |
| WK-SCP0123-0620 | X-ROW | SCM PI Admin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM PI Admin: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SCM PI Admin) |
| WK-SCP0123-0621 | X-ROW | SCP0123_PlanControl.CboPlanDate_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.CboPlanDate_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0123_PlanControl.CboPlanDate_Sele) |
| WK-SCP0123-0622 | X-ROW | SCP0123_PlanControl.CboPlanGroup_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.CboPlanGroup_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0123_PlanControl.CboPlanGroup_Sel) |
| WK-SCP0123-0623 | X-ROW | SCP0123_PlanControl.CheckEngineStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.CheckEngineStatus: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0123_PlanControl.CheckEngineStatu) |
| WK-SCP0123-0624 | X-ROW | SCP0123_PlanControl.CheckPreStepComplete | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.CheckPreStepCompleted: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/FLOW/LOCAL/RETURN, 연결된 요소 검사 |  | 22 (ACT:SCP0123_PlanControl.CheckPreStepComp) |
| WK-SCP0123-0625 | X-ROW | SCP0123_PlanControl.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0123_PlanControl.CreateSpread) |
| WK-SCP0123-0626 | X-ROW | SCP0123_PlanControl.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0123_PlanControl.DefineProperty A) |
| WK-SCP0123-0627 | X-ROW | SCP0123_PlanControl.DpPlanDate_Days_Valu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.DpPlanDate_Days_ValueChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0123_PlanControl.DpPlanDate_Days_) |
| WK-SCP0123-0628 | X-ROW | SCP0123_PlanControl.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0123_PlanControl.FindButton) |
| WK-SCP0123-0629 | X-ROW | SCP0123_PlanControl.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.FindData_Main: 진입점 집계 16검사 — NOT_RUN:15 · REVIEW:1 |  | 8 (ACT:SCP0123_PlanControl.FindData_Main:36) |
| WK-SCP0123-0630 | X-ROW | SCP0123_PlanControl.FindData_Sub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.FindData_Sub: 진입점 집계 15검사 — NOT_RUN:11 · REVIEW:2 · PASS:2 |  | 6 (ACT:SCP0123_PlanControl.FindData_Sub:506) |
| WK-SCP0123-0631 | X-ROW | SCP0123_PlanControl.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0123_PlanControl.Form_Load) |
| WK-SCP0123-0632 | X-ROW | SCP0123_PlanControl.GetDataSet_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.GetDataSet_Main: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0123_PlanControl.GetDataSet_Main ) |
| WK-SCP0123-0633 | X-ROW | SCP0123_PlanControl.GetPlanGroupByUserID | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.GetPlanGroupByUserID: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0123_PlanControl.GetPlanGroupByUs) |
| WK-SCP0123-0634 | X-ROW | SCP0123_PlanControl.GoPage | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.GoPage: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0123_PlanControl.GoPage ACT:SCP01) |
| WK-SCP0123-0635 | X-ROW | SCP0123_PlanControl.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.InitControls: 진입점 집계 9검사 — NOT_RUN:8 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0123_PlanControl.InitControls:175) |
| WK-SCP0123-0636 | X-ROW | SCP0123_PlanControl.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.InitEvent: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0123_PlanControl.InitEvent ACT:SC) |
| WK-SCP0123-0637 | X-ROW | SCP0123_PlanControl.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0123_PlanControl.InitSpread ACT:S) |
| WK-SCP0123-0638 | X-ROW | SCP0123_PlanControl.RefreshPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.RefreshPlanDate: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0123_PlanControl.RefreshPlanDate ) |
| WK-SCP0123-0639 | X-ROW | SCP0123_PlanControl.RefreshPlanGroupByDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.RefreshPlanGroupByDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0123_PlanControl.RefreshPlanGroup) |
| WK-SCP0123-0640 | X-ROW | SCP0123_PlanControl.RefreshPlanID | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.RefreshPlanID: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/LOCAL/UI_PROP, 연결된  |  | 12 (ACT:SCP0123_PlanControl.RefreshPlanID AC) |
| WK-SCP0123-0641 | X-ROW | SCP0123_PlanControl.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.SaveData: 진입점 집계 9검사 — NOT_RUN:5 · NOPATH:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0123_PlanControl.SaveData:728:14 ) |
| WK-SCP0123-0642 | X-ROW | SCP0123_PlanControl.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0123_PlanControl.SetChangedContro) |
| WK-SCP0123-0643 | X-ROW | SCP0123_PlanControl.SetEngineStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.SetEngineStatus: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:2 |  | 4 (ACT:SCP0123_PlanControl.SetEngineStatus:) |
| WK-SCP0123-0644 | X-ROW | SCP0123_PlanControl.SpdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.SpdMain_CellClick: 진입점 집계 29검사 — NOT_RUN:15 · NOPATH:11 · TODO:3 (미실행 검사가 남아 판정필요) |  | 115 (ACT:SCP0123_PlanControl.SpdMain_CellClic) |
| WK-SCP0123-0645 | X-ROW | SCP0123_PlanControl.SpdMain_ComboSelChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.SpdMain_ComboSelChange: 진입점 집계 27검사 — NOT_RUN:27 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0123_PlanControl.SpdMain_ComboSel) |
| WK-SCP0123-0646 | X-ROW | SCP0123_PlanControl.SpdMain_KeyPress | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.SpdMain_KeyPress: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/UI_PROP, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0123_PlanControl.SpdMain_KeyPress) |
| WK-SCP0123-0647 | X-ROW | SCP0123_PlanControl.cboDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanControl.cboDivision_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0123_PlanControl.cboDivision_Sele) |
| WK-SCP0123-0648 | X-ROW | SCP0123_PlanIDCreatePopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0123_PlanIDCreatePopup..ctor:67:1) |
| WK-SCP0123-0649 | X-ROW | SCP0123_PlanIDCreatePopup.BtnClose_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.BtnClose_Click: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0123_PlanIDCreatePopup.BtnClose_C) |
| WK-SCP0123-0650 | X-ROW | SCP0123_PlanIDCreatePopup.BtnCreatePlan_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.BtnCreatePlan_Click: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0123_PlanIDCreatePopup.BtnCreateP) |
| WK-SCP0123-0651 | X-ROW | SCP0123_PlanIDCreatePopup.CboProdCd_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.CboProdCd_SelectedIndexC: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanIDCreatePopup.CboProdCd_) |
| WK-SCP0123-0652 | X-ROW | SCP0123_PlanIDCreatePopup.CboShipCd_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.CboShipCd_SelectedIndexC: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanIDCreatePopup.CboShipCd_) |
| WK-SCP0123-0653 | X-ROW | SCP0123_PlanIDCreatePopup.ChkCellNoFroze | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.ChkCellNoFrozen_CheckedC: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0123_PlanIDCreatePopup.ChkCellNoF) |
| WK-SCP0123-0654 | X-ROW | SCP0123_PlanIDCreatePopup.ChkProdNoFroze | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.ChkProdNoFrozen_CheckedC: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0123_PlanIDCreatePopup.ChkProdNoF) |
| WK-SCP0123-0655 | X-ROW | SCP0123_PlanIDCreatePopup.ChkShipNoFroze | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.ChkShipNoFrozen_CheckedC: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0123_PlanIDCreatePopup.ChkShipNoF) |
| WK-SCP0123-0656 | X-ROW | SCP0123_PlanIDCreatePopup.ConvertToDateS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.ConvertToDateString: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0123_PlanIDCreatePopup.ConvertToD) |
| WK-SCP0123-0657 | X-ROW | SCP0123_PlanIDCreatePopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0123_PlanIDCreatePopup.Dispose:16) |
| WK-SCP0123-0658 | X-ROW | SCP0123_PlanIDCreatePopup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0123_PlanIDCreatePopup.Form_Load ) |
| WK-SCP0123-0659 | X-ROW | SCP0123_PlanIDCreatePopup.GetInitInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.GetInitInfo: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0123_PlanIDCreatePopup.GetInitInf) |
| WK-SCP0123-0660 | X-ROW | SCP0123_PlanIDCreatePopup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.InitControls: 진입점 집계 27검사 — NOT_RUN:27 (미실행 검사가 남아 판정필요) |  | 58 (ACT:SCP0123_PlanIDCreatePopup.InitContro) |
| WK-SCP0123-0661 | X-ROW | SCP0123_PlanIDCreatePopup.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.InitEvent: 진입점 집계 17검사 — NOT_RUN:14 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0123_PlanIDCreatePopup.InitEvent:) |
| WK-SCP0123-0662 | X-ROW | SCP0123_PlanIDCreatePopup.RefreshPlanId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.RefreshPlanId: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0123_PlanIDCreatePopup.RefreshPla) |
| WK-SCP0123-0663 | X-ROW | SCP0123_PlanIDCreatePopup.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.SaveData: 진입점 집계 9검사 — NOT_RUN:6 · NOPATH:2 · PASS:1 (미실행 검사가 남아 판정필요) |  | 87 (ACT:SCP0123_PlanIDCreatePopup.SaveData:4) |
| WK-SCP0123-0664 | X-ROW | SCP0123_PlanIDCreatePopup.Set_PlanID_Inf | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0123_PlanIDCreatePopup.Set_PlanID_Info: 진입점 집계 11검사 — NOT_RUN:11 (미실행 검사가 남아 판정필요) |  | 34 (ACT:SCP0123_PlanIDCreatePopup.Set_PlanID) |
| WK-SCP0123-0665 | X-ROW | X03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — X03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (X03) |
| WK-SCP0123-0666 | X-ROW | X07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — X07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (X07) |
| WK-SCP0123-0667 | X-ROW | X09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — X09: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (X09) |
| WK-SCP0123-0668 | X-ROW | X12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — X12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (X12) |
| WK-SCP0123-0669 | X-ROW | X13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — X13: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (X13) |
| WK-SCP0123-0670 | X-ROW | X14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — X14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (X14) |
| WK-SCP0123-0671 | X-ROW | X16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — X16: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (X16) |
| WK-SCP0123-0672 | X-ROW | X18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — X18: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (X18) |
| WK-SCP0123-0673 | X-ROW | X21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — X21: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (X21) |
| WK-SCP0123-0674 | X-ROW | `imageList1` / `timerStatus` / `componen | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `imageList1` / `timerStatus` / `components`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`imageList1` / `timerStatus` / `componen) |
| WK-SCP0123-0675 | X-ROW | `layoutControlItem1/5` · `lciPlanDate` · | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `layoutControlItem1/5` · `lciPlanDate` · `lciPlanD: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`layoutControlItem1/5` · `lciPlanDate` ·) |
| WK-SCP0123-0676 | X-ROW | `splitContainer1` Orientation=**Horizont | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `splitContainer1` Orientation=**Horizontal**(=상/하): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`splitContainer1` Orientation=**Horizont) |
| WK-SCP0123-0677 | G5 | HANDLER:SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — HANDLER:SpdMain_CellDoubleClick: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SpdMain_CellDoubleClick) |
| WK-SCP0123-0678 | G5 | SCP0123_PlanControl.SpdMain_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0123_PlanControl.SpdMain_CellDoubleClick: 진입점 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0123_PlanControl.SpdMain_CellDoub) |
| WK-SCP0123-0679 | G5 | U01·U02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — U01·U02: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (U01·U02) |
| WK-SCP0123-0680 | H6 | HANDLER:SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — HANDLER:SpdMain_CellDoubleClick: 행 집계 — H6 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SpdMain_CellDoubleClick) |
| WK-SCP0123-0681 | H6 | SCP0123_PlanControl.SpdMain_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0123_PlanControl.SpdMain_CellDoubleClick: 진입점 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0123_PlanControl.SpdMain_CellDoub) |
| WK-SCP0123-0682 | H6 | U01·U02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — U01·U02: 행 집계 — H6 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (U01·U02) |
| WK-SCP0123-0683 | M4 | HANDLER:SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — HANDLER:SpdMain_CellDoubleClick: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (HANDLER:SpdMain_CellDoubleClick) |
| WK-SCP0123-0684 | M4 | SCP0123_PlanControl.SpdMain_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0123_PlanControl.SpdMain_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0123_PlanControl.SpdMain_CellDoub) |
| WK-SCP0123-0685 | M4 | U01·U02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — U01·U02: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (U01·U02) |
