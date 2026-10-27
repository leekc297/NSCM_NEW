# 작업 원장 — SSP0045 · 2026-10-26 12:59

> 검사 인스턴스 624건 중 PASS·NA 210건 외 **414건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 139 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 3 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 7 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 61 | 실행 → PASS |
| W7 | 기대값 확정 | 203 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 188 · 대조표 154 · E2E 61 · 하네스 10 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 139 |  |  |  |  | 15 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 97 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 19 | 13 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G1 | GEN |  |  |  |  |  | 5 | 14 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 18 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-REASON | DESIGN |  |  |  |  |  |  | 15 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| H5 | DESIGN |  |  |  |  |  | 3 | 10 |  |  | 라벨 명칭 |
| C1 | CASCADE |  |  |  |  |  | 4 | 8 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| B4 | COMBO |  |  |  |  | 3 |  | 8 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 3 |  |  | 4 |  |  | 콤보 후보 정렬 = AS-IS |
| F4 | DB |  |  |  |  |  | 7 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  | 6 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G4 | DESIGN |  |  |  |  | 1 | 3 |  |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 3 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| DB-SYN | DB |  |  |  |  | 1 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |

## W2 구현 위치 확인 (139)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0045-0001 | X-LOC | BG03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG03) |
| WK-SSP0045-0002 | X-LOC | BG05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG05) |
| WK-SSP0045-0003 | X-LOC | BG06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG06) |
| WK-SSP0045-0004 | X-LOC | BG07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG07) |
| WK-SSP0045-0005 | X-LOC | BG08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG08) |
| WK-SSP0045-0006 | X-LOC | BG09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG09) |
| WK-SSP0045-0007 | X-LOC | BG11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG11) |
| WK-SSP0045-0008 | X-LOC | BG12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG12) |
| WK-SSP0045-0009 | X-LOC | BG13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG13) |
| WK-SSP0045-0010 | X-LOC | BG14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG14) |
| WK-SSP0045-0011 | X-LOC | BG15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG15) |
| WK-SSP0045-0012 | X-LOC | BG17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG17) |
| WK-SSP0045-0013 | X-LOC | C01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C01) |
| WK-SSP0045-0014 | X-LOC | C02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C02) |
| WK-SSP0045-0015 | X-LOC | C03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C03) |
| WK-SSP0045-0016 | X-LOC | C04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C04) |
| WK-SSP0045-0017 | X-LOC | C05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C05) |
| WK-SSP0045-0018 | X-LOC | C06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C06) |
| WK-SSP0045-0019 | X-LOC | C07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C07) |
| WK-SSP0045-0020 | X-LOC | C08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C08) |
| WK-SSP0045-0021 | X-LOC | C09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C09) |
| WK-SSP0045-0022 | X-LOC | C10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C10) |
| WK-SSP0045-0023 | X-LOC | C11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C11) |
| WK-SSP0045-0024 | X-LOC | C12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C12) |
| WK-SSP0045-0025 | X-LOC | C13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C13) |
| WK-SSP0045-0026 | X-LOC | C14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C14) |
| WK-SSP0045-0027 | X-LOC | C15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C15) |
| WK-SSP0045-0028 | X-LOC | C16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C16) |
| WK-SSP0045-0029 | X-LOC | C18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C18) |
| WK-SSP0045-0030 | X-LOC | C19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C19) |
| WK-SSP0045-0031 | X-LOC | C20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C20) |
| WK-SSP0045-0032 | X-LOC | C22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C22) |
| WK-SSP0045-0033 | X-LOC | C24 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C24) |
| WK-SSP0045-0034 | X-LOC | CB01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CB01) |
| WK-SSP0045-0035 | X-LOC | CB02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CB02) |
| WK-SSP0045-0036 | X-LOC | CB03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CB03) |
| WK-SSP0045-0037 | X-LOC | CB04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CB04) |
| WK-SSP0045-0038 | X-LOC | CB05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CB05) |
| WK-SSP0045-0039 | X-LOC | E01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E01) |
| WK-SSP0045-0040 | X-LOC | E02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E02) |
| WK-SSP0045-0041 | X-LOC | E03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E03) |
| WK-SSP0045-0042 | X-LOC | E04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E04) |
| WK-SSP0045-0043 | X-LOC | E06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E06) |
| WK-SSP0045-0044 | X-LOC | E07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E07) |
| WK-SSP0045-0045 | X-LOC | E08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E08) |
| WK-SSP0045-0046 | X-LOC | E09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E09) |
| WK-SSP0045-0047 | X-LOC | EP01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EP01) |
| WK-SSP0045-0048 | X-LOC | EP02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EP02) |
| WK-SSP0045-0049 | X-LOC | EP06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EP06) |
| WK-SSP0045-0050 | X-LOC | EP07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EP07) |
| WK-SSP0045-0051 | X-LOC | EP08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EP08) |
| WK-SSP0045-0052 | X-LOC | EP09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EP09) |
| WK-SSP0045-0053 | X-LOC | EP10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EP10) |
| WK-SSP0045-0054 | X-LOC | EP11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EP11) |
| WK-SSP0045-0055 | X-LOC | EP12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EP12) |
| WK-SSP0045-0056 | X-LOC | EP13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EP13) |
| WK-SSP0045-0057 | X-LOC | G01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G01) |
| WK-SSP0045-0058 | X-LOC | G02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G02) |
| WK-SSP0045-0059 | X-LOC | G04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G04) |
| WK-SSP0045-0060 | X-LOC | G06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G06) |
| WK-SSP0045-0061 | X-LOC | G07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G07) |
| WK-SSP0045-0062 | X-LOC | G09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G09) |
| WK-SSP0045-0063 | X-LOC | G10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G10) |
| WK-SSP0045-0064 | X-LOC | G11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G11) |
| WK-SSP0045-0065 | X-LOC | G12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G12) |
| WK-SSP0045-0066 | X-LOC | G13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G13) |
| WK-SSP0045-0067 | X-LOC | G15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G15) |
| WK-SSP0045-0068 | X-LOC | G17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G17) |
| WK-SSP0045-0069 | X-LOC | G18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G18) |
| WK-SSP0045-0070 | X-LOC | G22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G22) |
| WK-SSP0045-0071 | X-LOC | GC02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (GC02) |
| WK-SSP0045-0072 | X-LOC | PU01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (PU01) |
| WK-SSP0045-0073 | X-LOC | PU02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (PU02) |
| WK-SSP0045-0074 | X-LOC | PU03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (PU03) |
| WK-SSP0045-0075 | X-LOC | PU04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (PU04) |
| WK-SSP0045-0076 | X-LOC | S01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S01) |
| WK-SSP0045-0077 | X-LOC | S03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S03) |
| WK-SSP0045-0078 | X-LOC | S04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S04) |
| WK-SSP0045-0079 | X-LOC | S05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S05) |
| WK-SSP0045-0080 | X-LOC | S06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S06) |
| WK-SSP0045-0081 | X-LOC | S07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S07) |
| WK-SSP0045-0082 | X-LOC | S08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S08) |
| WK-SSP0045-0083 | X-LOC | S09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S09) |
| WK-SSP0045-0084 | X-LOC | S10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S10) |
| WK-SSP0045-0085 | X-LOC | S11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S11) |
| WK-SSP0045-0086 | X-LOC | S12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S12) |
| WK-SSP0045-0087 | X-LOC | S13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S13) |
| WK-SSP0045-0088 | X-LOC | S14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S14) |
| WK-SSP0045-0089 | X-LOC | S15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S15) |
| WK-SSP0045-0090 | X-LOC | S19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S19) |
| WK-SSP0045-0091 | X-LOC | S21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S21) |
| WK-SSP0045-0092 | X-LOC | S22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S22) |
| WK-SSP0045-0093 | X-LOC | S23 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S23) |
| WK-SSP0045-0094 | X-LOC | S24 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S24) |
| WK-SSP0045-0095 | X-LOC | S25 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S25) |
| WK-SSP0045-0096 | X-LOC | S26 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S26) |
| WK-SSP0045-0097 | X-LOC | S32 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S32) |
| WK-SSP0045-0098 | X-LOC | S33 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S33) |
| WK-SSP0045-0099 | X-LOC | S34 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S34) |
| WK-SSP0045-0100 | X-LOC | S35 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S35) |
| WK-SSP0045-0101 | X-LOC | S36 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: Grid.tsx 없음 |  | 1 (S36) |
| WK-SSP0045-0102 | X-LOC | S37 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S37) |
| WK-SSP0045-0103 | X-LOC | S38 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S38) |
| WK-SSP0045-0104 | X-LOC | S39 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S39) |
| WK-SSP0045-0105 | X-LOC | S40 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S40) |
| WK-SSP0045-0106 | X-LOC | S41 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S41) |
| WK-SSP0045-0107 | X-LOC | S42 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S42) |
| WK-SSP0045-0108 | X-LOC | S43 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S43) |
| WK-SSP0045-0109 | X-LOC | S44 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S44) |
| WK-SSP0045-0110 | X-LOC | S45 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S45) |
| WK-SSP0045-0111 | X-LOC | S46 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S46) |
| WK-SSP0045-0112 | X-LOC | S47 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S47) |
| WK-SSP0045-0113 | X-LOC | S48 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S48) |
| WK-SSP0045-0114 | X-LOC | S49 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S49) |
| WK-SSP0045-0115 | X-LOC | S50 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S50) |
| WK-SSP0045-0116 | X-LOC | S51 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S51) |
| WK-SSP0045-0117 | X-LOC | S52 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S52) |
| WK-SSP0045-0118 | X-LOC | S53 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S53) |
| WK-SSP0045-0119 | X-LOC | S54 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S54) |
| WK-SSP0045-0120 | X-LOC | S55 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S55) |
| WK-SSP0045-0121 | X-LOC | S56 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S56) |
| WK-SSP0045-0122 | X-LOC | S57 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S57) |
| WK-SSP0045-0123 | X-LOC | S58 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S58) |
| WK-SSP0045-0124 | X-LOC | S59 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S59) |
| WK-SSP0045-0125 | X-LOC | S60 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S60) |
| WK-SSP0045-0126 | X-LOC | S61 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S61) |
| WK-SSP0045-0127 | X-LOC | S62 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S62) |
| WK-SSP0045-0128 | X-LOC | S63 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (S63) |
| WK-SSP0045-0129 | X-LOC | SP01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SP01) |
| WK-SSP0045-0130 | X-LOC | SP02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SP02) |
| WK-SSP0045-0131 | X-LOC | SP03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SP03) |
| WK-SSP0045-0132 | X-LOC | SP04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SP04) |
| WK-SSP0045-0133 | X-LOC | SP05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SP05) |
| WK-SSP0045-0134 | X-LOC | V03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V03) |
| WK-SSP0045-0135 | X-LOC | V04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V04) |
| WK-SSP0045-0136 | X-LOC | V05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V05) |
| WK-SSP0045-0137 | X-LOC | V06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V06) |
| WK-SSP0045-0138 | X-LOC | V07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V07) |
| WK-SSP0045-0139 | X-LOC | V08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V08) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0045-0140 | H10 | SSP0045 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SSP0045 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: hooks/useShipmentRequestSemiValidation.ts |  | 9 (V02 V03 V04 V05 V06 V07 V08 V09 G06) |

## W4 검사기 구현 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0045-0141 | B3 | cboBizType / Operation Group / Biz Type  | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBizType / Operation Group / Biz Type / Operatio | 있음(FE 소스) | 3 (ACT:SSP0045_ShipmentRequest.CboBizType_S) |
| WK-SSP0045-0142 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 3 (ACT:SSP0045_ShipmentRequest.CboBizType_S) |
| WK-SSP0045-0143 | B3 | drpPeriod / Period | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 drpPeriod / Period | 있음(FE 소스) | 3 (ACT:SSP0045_ShipmentRequest.GetSpdTitle ) |

## W5 검사기 연결 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0045-0144 | B4 | cboBizType / Operation Group / Biz Type  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBizType / Operation Group / Biz Type / Operatio | 있음(FE 소스) | 3 (ACT:SSP0045_ShipmentRequest.CboBizType_S) |
| WK-SSP0045-0145 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 3 (ACT:SSP0045_ShipmentRequest.CboBizType_S) |
| WK-SSP0045-0146 | B4 | drpPeriod / Period | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND drpPeriod / Period | 있음(FE 소스) | 3 (ACT:SSP0045_ShipmentRequest.GetSpdTitle ) |
| WK-SSP0045-0147 | F2 | SSP0045 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0045 화면 | 판단불가(대상 단위 SCREEN) | 114 (V02 V03 V07 V09 S03 S56 SP04 EP02 PU02 G) |
| WK-SSP0045-0148 | F6 | SSP0045 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SSP0045 화면 | 판단불가(대상 단위 SCREEN) | 104 (SP04 ACT:SSP0045_ShipmentRequest.SaveBut) |
| WK-SSP0045-0149 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 3 (SP01 ACT:SSP0045_ShipmentRequest.GetBuck) |
| WK-SSP0045-0150 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 2 (ACT:SSP0045_ShipmentRequest.InitEvent AC) |

## W6 검증 실행 (61)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0045-0151 | J2 | SSP0045 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0045 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 45 (C24 E02 E04 V02 V03 V06 V07 V09 S03 S22 ) |
| WK-SSP0045-0152 | C1 | cboBizType / Operation Group / Biz Type  | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0045_ShipmentRequest.InitControls) |
| WK-SSP0045-0153 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0045_ShipmentRequest.InitControls) |
| WK-SSP0045-0154 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SSP0045_ShipmentRequest.InitControls) |
| WK-SSP0045-0155 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SSP0045_ShipmentRequest.CboBizType_S) |
| WK-SSP0045-0156 | G3 | SSP0045 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0045 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 2 (C09 C10) |
| WK-SSP0045-0157 | K-SA | SSP0045 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0045 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (C09 C10) |
| WK-SSP0045-0158 | K4 | SSP0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0045 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 12 (ACT:SSP0045_ShipmentRequest.BtnItem_Id_C) |
| WK-SSP0045-0159 | F1 | SSP0045 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0045 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 127 (V02 V03 V07 V09 S03 S22 S56 SP04 EP02 BG) |
| WK-SSP0045-0160 | F5 | SSP0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0045 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 14 (S22 BG05 BG06 BG07 G22 ACT:SSP0045_Shipm) |
| WK-SSP0045-0161 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 3 (SP01 ACT:SSP0045_ShipmentRequest.GetBuck) |
| WK-SSP0045-0162 | F4 | FN_MULTY_TIME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — FN_MULTY_TIME · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (SP02) |
| WK-SSP0045-0163 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 3 (SP02 ACT:SSP0045_ShipmentRequest.GetDayR) |
| WK-SSP0045-0164 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 155 (SP05 ACT:SSP0045_ShipmentRequest.FindBut) |
| WK-SSP0045-0165 | F4 | PKG_SSP0045.P_SSP0045_GET_BOD_ITEM_PRJ_R | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0045.P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 |  | 1 (PU04) |
| WK-SSP0045-0166 | F4 | PKG_SSP0045.P_SSP0045_GET_SHIPMENT_REQUE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0045.P_SSP0045_GET_SHIPMENT_REQUEST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 155 (SP03 ACT:SSP0045_ShipmentRequest.FindBut) |
| WK-SSP0045-0167 | F4 | PKG_SSP0045.P_SSP0045_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0045.P_SSP0045_SAVE_SHIPMENT_REQUEST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 104 (SP04 ACT:SSP0045_ShipmentRequest.SaveBut) |
| WK-SSP0045-0168 | G4 | cboBizType / Operation Group / Biz Type  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0045_ShipmentRequest.InitControls) |
| WK-SSP0045-0169 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SSP0045_ShipmentRequest.DefineProper) |
| WK-SSP0045-0170 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0045_ShipmentRequest.InitControls) |
| WK-SSP0045-0171 | H4 | SSP0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0045 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SSP0045_ShipmentRequest.SpdMain_TopC) |
| WK-SSP0045-0172 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 17 (ACT:SSP0045_ShipmentRequest.SetSpreadCol) |
| WK-SSP0045-0173 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0045_ShipmentRequest.SetSpreadCol) |
| WK-SSP0045-0174 | H5 | drpPeriod / Period | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — drpPeriod / Period · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SSP0045_ShipmentRequest.CreateSpread) |
| WK-SSP0045-0175 | I1 | SSP0045 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0045 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 18 (V02 V03 V04 V05 V06 V07 V08 V09 G06 ACT:) |
| WK-SSP0045-0176 | D6 | SSP0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0045 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 3 (V06 S32 PU04) |
| WK-SSP0045-0177 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V03 ACT:SSP0045_ShipmentRequest.SaveData) |
| WK-SSP0045-0178 | E4 | MSG00005 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00005 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V06 ACT:SSP0045_ShipmentRequest.SaveData) |
| WK-SSP0045-0179 | E4 | MSG00042 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00042 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V05 ACT:SSP0045_ShipmentRequest.SaveData) |
| WK-SSP0045-0180 | E4 | MSG00084 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00084 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V02 ACT:SSP0045_ShipmentRequest.SaveData) |
| WK-SSP0045-0181 | E4 | MSG00098 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00098 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V08 ACT:SSP0045_ShipmentRequest.SpdMain_) |
| WK-SSP0045-0182 | E4 | MSG00260 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00260 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V09 ACT:SSP0045_ShipmentRequest.checkVal) |
| WK-SSP0045-0183 | E4 | MSG00428 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00428 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V09) |
| WK-SSP0045-0184 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (G06) |
| WK-SSP0045-0185 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V03) |
| WK-SSP0045-0186 | E4 | MSG00676 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00676 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V06) |
| WK-SSP0045-0187 | E4 | MSG00699 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00699 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V02) |
| WK-SSP0045-0188 | E4 | MSG01075 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01075 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V05) |
| WK-SSP0045-0189 | E4 | MSG01126 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01126 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V08) |
| WK-SSP0045-0190 | E4 | cboBizType / Operation Group / Biz Type  | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요 |  | 3 (ACT:SSP0045_ShipmentRequest.SetBODItemID) |
| WK-SSP0045-0191 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 17 (ACT:SSP0045_ShipmentRequest.SetSpreadCol) |
| WK-SSP0045-0192 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 7 (ACT:SSP0045_ShipmentRequest.SetBODItemID) |
| WK-SSP0045-0193 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0045_ShipmentRequest.SetSpreadCol) |
| WK-SSP0045-0194 | E4 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행  |  | 2 (ACT:SSP0045_ShipmentRequest.SetChangedCo) |
| WK-SSP0045-0195 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0045_ShipmentRequest.FindData_Mai) |
| WK-SSP0045-0196 | A10 | SSP0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0045 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 95 (ACT:SSP0045_ShipmentRequest.DefineProper) |
| WK-SSP0045-0197 | A6 | DM0003_GET_BUCKET_TYPE_CODE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec |  | 1 (SP01) |
| WK-SSP0045-0198 | A6 | FN_MULTY_TIME | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — FN_MULTY_TIME · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (SP02) |
| WK-SSP0045-0199 | A6 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 1 (SP02) |
| WK-SSP0045-0200 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 52 (SP05 ACT:SSP0045_ShipmentRequest.FindBut) |
| WK-SSP0045-0201 | A6 | PKG_SSP0045.P_SSP0045_GET_BOD_ITEM_PRJ_R | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0045.P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로  |  | 1 (PU04) |
| WK-SSP0045-0202 | A6 | PKG_SSP0045.P_SSP0045_GET_SHIPMENT_REQUE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0045.P_SSP0045_GET_SHIPMENT_REQUEST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회 |  | 54 (SP03 ACT:SSP0045_ShipmentRequest.FindBut) |
| WK-SSP0045-0203 | G1 | cboBizType / Operation Group / Biz Type  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0045_ShipmentRequest.FindData_Mai) |
| WK-SSP0045-0204 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0045_ShipmentRequest.FindData_Mai) |
| WK-SSP0045-0205 | G1 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0045_ShipmentRequest.FindData_Mai) |
| WK-SSP0045-0206 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (ACT:SSP0045_ShipmentRequest.FindData_Mai) |
| WK-SSP0045-0207 | G1 | txtItem_Id / Model / Item_Id / Model/Nic | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItem_Id / Model / Item_Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0045_ShipmentRequest.FindData_Mai) |
| WK-SSP0045-0208 | G6 | cboBizType / Operation Group / Biz Type  | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SSP0045_ShipmentRequest.InitControls) |
| WK-SSP0045-0209 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SSP0045_ShipmentRequest.DefineProper) |
| WK-SSP0045-0210 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SSP0045_ShipmentRequest.InitControls) |
| WK-SSP0045-0211 | X-REOPEN | SSP0045 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0045 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 9 (ACT:SSP0045_ShipmentRequest.Dispose ACT:) |

## W7 기대값 확정 (203)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0045-0212 | C1 | E01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E01: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E01) |
| WK-SSP0045-0213 | C1 | E03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E03: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E03) |
| WK-SSP0045-0214 | C1 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E04: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-SSP0045-0215 | C1 | E09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E09: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E09) |
| WK-SSP0045-0216 | C1 | EP07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — EP07: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (EP07) |
| WK-SSP0045-0217 | C1 | EP08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — EP08: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (EP08) |
| WK-SSP0045-0218 | C1 | EP09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — EP09: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (EP09) |
| WK-SSP0045-0219 | C1 | EP10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — EP10: 행 집계 — C1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (EP10) |
| WK-SSP0045-0220 | B3 | SP01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SP01: 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (SP01) |
| WK-SSP0045-0221 | B3 | SSP0045_ShipmentRequest.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0045_ShipmentRequest.GetBucketType: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0045_ShipmentRequest.GetBucketTyp) |
| WK-SSP0045-0222 | B3 | SSP0045_ShipmentRequest.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0045_ShipmentRequest.GetDayRange: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0045_ShipmentRequest.GetDayRange:) |
| WK-SSP0045-0223 | B3 | SSP0045_ShipmentRequest.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0045_ShipmentRequest.GetSpdTitle: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0045_ShipmentRequest.GetSpdTitle:) |
| WK-SSP0045-0224 | B4 | CB03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — CB03: 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (CB03) |
| WK-SSP0045-0225 | B4 | CB05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — CB05: 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (CB05) |
| WK-SSP0045-0226 | B4 | G02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — G02: 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (G02) |
| WK-SSP0045-0227 | B4 | S36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — S36: 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (S36) |
| WK-SSP0045-0228 | B4 | SP01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SP01: 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (SP01) |
| WK-SSP0045-0229 | B4 | SSP0045_ShipmentRequest.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0045_ShipmentRequest.GetBucketType: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0045_ShipmentRequest.GetBucketTyp) |
| WK-SSP0045-0230 | B4 | SSP0045_ShipmentRequest.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0045_ShipmentRequest.GetDayRange: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0045_ShipmentRequest.GetDayRange:) |
| WK-SSP0045-0231 | B4 | SSP0045_ShipmentRequest.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0045_ShipmentRequest.GetSpdTitle: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0045_ShipmentRequest.GetSpdTitle:) |
| WK-SSP0045-0232 | H5 | BG06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — BG06: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (BG06) |
| WK-SSP0045-0233 | H5 | C22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — C22: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (C22) |
| WK-SSP0045-0234 | H5 | E01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E01: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (E01) |
| WK-SSP0045-0235 | H5 | G22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G22: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (G22) |
| WK-SSP0045-0236 | H5 | PU01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — PU01: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (PU01) |
| WK-SSP0045-0237 | H5 | S23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — S23: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (S23) |
| WK-SSP0045-0238 | H5 | SSP0045_ShipmentRequest.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0045_ShipmentRequest.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0045_ShipmentRequest.CreateSpread) |
| WK-SSP0045-0239 | H5 | SSP0045_ShipmentRequest.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0045_ShipmentRequest.SetImageCell: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0045_ShipmentRequest.SetImageCell) |
| WK-SSP0045-0240 | H5 | SSP0045_ShipmentRequest.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0045_ShipmentRequest.SetSpreadColumn: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0045_ShipmentRequest.SetSpreadCol) |
| WK-SSP0045-0241 | H5 | V09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — V09: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (V09) |
| WK-SSP0045-0242 | X-REASON | BG01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — BG01 `fps == null` (Edit) Edit 미이식 제외(§11) |  | 1 (BG01) |
| WK-SSP0045-0243 | X-REASON | BG02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — BG02 `fps.Name=="spdMain"` (Edit) 동상 제외(§11) |  | 1 (BG02) |
| WK-SSP0045-0244 | X-REASON | BG04 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — BG04 Action 컬럼 hidden 분기 모드 OFF 복귀 경로 제외(§11) |  | 1 (BG04) |
| WK-SSP0045-0245 | X-REASON | BG10 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — BG10 `IsLock == true` → return 모드 없음 — 신규행 조건(BG11)만 남는다 제외(§11) |  | 1 (BG10) |
| WK-SSP0045-0246 | X-REASON | BG16 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — BG16 `IsLock == true` (ComboSelChange) 모드 없음 제외(§11) |  | 1 (BG16) |
| WK-SSP0045-0247 | X-REASON | EP03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — EP03 `EditButton` **키 자체 없음** — `asis_to_tobe.md §11` 미이식(`HotkeyConfig` 에 `edit` 키 부재) 제외(§11) |  | 1 (EP03) |
| WK-SSP0045-0248 | X-REASON | G03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G03 더미행 `CODE='-'` **제외** — AS-IS 는 편집 가능한 셀 콤보에서 값을 비우기 위한 빈 행이다. TO-BE 는 컬럼메타 `INPUT_TP_CD='S'` 라 FROM_SITE/T |  | 1 (G03) |
| WK-SSP0045-0249 | X-REASON | G08 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G08 `SetSearchCount` + 시간계측 건수 = `SubTitle dataCount`. 시간계측·`SetSaveLog` 는 **격차 G3 위임** 제외(격차 G3) |  | 1 (G08) |
| WK-SSP0045-0250 | X-REASON | G16 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G16 `usrConditionPanel1.Height=75` px 미이식 — "2단 전제" 의미만 승계(필드 6개 초과분 `extraConditions`) 제외(px 이식 금지) |  | 1 (G16) |
| WK-SSP0045-0251 | X-REASON | G19 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G19 `ComboSelChange -= / +=` 재진입 차단 프로그램적 대입은 `cellEditEnded` 를 발화시키지 않아 재진입 구조가 없다 제외(구조적 부재) |  | 1 (G19) |
| WK-SSP0045-0252 | X-REASON | G20 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G20 Roslyn chain 오표기(EP06) 분석 도구 산출물 오류 — 이식 대상 아님 제외(분석 오표기) |  | 1 (G20) |
| WK-SSP0045-0253 | X-REASON | G21 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G21 `FP_Log2` SpeedUp 계측 **격차 G3 위임** — 화면이 개별 구현하지 않는다(Hard Boundary) 제외(격차 G3) |  | 1 (G21) |
| WK-SSP0045-0254 | X-REASON | GC01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — GC01 `AddTextColumn` (`B_`, hidden) S02 와 동일 — 도달 불가 제외(도달 불가) |  | 1 (GC01) |
| WK-SSP0045-0255 | X-REASON | S02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — S02 `SetReNumerCellType` (`B_` 컬럼) `B_` 분기 **도달 불가**(판정식 `IndexOf("B_")>0`) 제외(도달 불가) |  | 1 (S02) |
| WK-SSP0045-0256 | X-REASON | S20 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — S20 `LockRange(MEASURE+1..end)` (BG04) 모드 OFF 복귀 경로 — 모드 자체가 없다 제외(§11) |  | 1 (S20) |
| WK-SSP0045-0257 | E4 | G04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — G04: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (G04) |
| WK-SSP0045-0258 | E4 | G05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — G05: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (G05) |
| WK-SSP0045-0259 | E4 | SP04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SP04: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (SP04) |
| WK-SSP0045-0260 | E4 | SSP0045_ShipmentRequest.SetBODItemID | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0045_ShipmentRequest.SetBODItemID: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0045_ShipmentRequest.SetBODItemID) |
| WK-SSP0045-0261 | E4 | SSP0045_ShipmentRequest.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0045_ShipmentRequest.SetChangeControl: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0045_ShipmentRequest.SetChangeCon) |
| WK-SSP0045-0262 | E4 | SSP0045_ShipmentRequest.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0045_ShipmentRequest.SetImageCell: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0045_ShipmentRequest.SetImageCell) |
| WK-SSP0045-0263 | E4 | SSP0045_ShipmentRequest.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0045_ShipmentRequest.SetLockSumColumn: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SSP0045_ShipmentRequest.SetLockSumCo) |
| WK-SSP0045-0264 | E4 | SSP0045_ShipmentRequest.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0045_ShipmentRequest.SetSpreadColumn: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0045_ShipmentRequest.SetSpreadCol) |
| WK-SSP0045-0265 | E4 | SSP0045_ShipmentRequest.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0045_ShipmentRequest.Set_MeasureColor: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SSP0045_ShipmentRequest.Set_MeasureC) |
| WK-SSP0045-0266 | E4 | SSP0045_ShipmentRequest.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0045_ShipmentRequest.Set_SumValues: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 28 (ACT:SSP0045_ShipmentRequest.Set_SumValue) |
| WK-SSP0045-0267 | E4 | V04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — V04: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (V04) |
| WK-SSP0045-0268 | E4 | V07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — V07: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (V07) |
| WK-SSP0045-0269 | E4 | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — validations: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (validations) |
| WK-SSP0045-0270 | A1 | CB04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CB04: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (CB04) |
| WK-SSP0045-0271 | A1 | DM0003_GET_BUCKET_TYPE_CODE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DM0003_GET_BUCKET_TYPE_CODE: 골든 비교 케이스 없음(DM0003_GET_BUCKET_TYPE_CODE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 |  | 1 (SP01) |
| WK-SSP0045-0272 | A1 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E02: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (E02) |
| WK-SSP0045-0273 | A1 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E04: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (E04) |
| WK-SSP0045-0274 | A1 | EP01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — EP01: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (EP01) |
| WK-SSP0045-0275 | A1 | EP06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — EP06: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (EP06) |
| WK-SSP0045-0276 | A1 | FN_MULTY_TIME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FN_MULTY_TIME: 골든 비교 케이스 없음(FN_MULTY_TIME — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (SP02) |
| WK-SSP0045-0277 | A1 | G04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G04: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (G04) |
| WK-SSP0045-0278 | A1 | G05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G05: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (G05) |
| WK-SSP0045-0279 | A1 | G22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G22: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (G22) |
| WK-SSP0045-0280 | A1 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD: 골든 비교 케이스 없음(PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD — 팝업·보조 SP 는 golden_ca |  | 1 (SP02) |
| WK-SSP0045-0281 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 52 (SP05 ACT:SSP0045_ShipmentRequest.FindBut) |
| WK-SSP0045-0282 | A1 | PKG_SSP0045.P_SSP0045_GET_BOD_ITEM_PRJ_R | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0045.P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE: 골든 비교 케이스 없음(PKG_SSP0045.P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE — 팝업·보조 SP 는 g |  | 1 (PU04) |
| WK-SSP0045-0283 | A1 | PKG_SSP0045.P_SSP0045_GET_SHIPMENT_REQUE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0045.P_SSP0045_GET_SHIPMENT_REQUEST: 골든 비교 케이스 없음(PKG_SSP0045.P_SSP0045_GET_SHIPMENT_REQUEST — 팝업·보조 SP 는 golde |  | 54 (SP03 ACT:SSP0045_ShipmentRequest.FindBut) |
| WK-SSP0045-0284 | A1 | PU01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PU01: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (PU01) |
| WK-SSP0045-0285 | A1 | S24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — S24: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (S24) |
| WK-SSP0045-0286 | A1 | S25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — S25: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (S25) |
| WK-SSP0045-0287 | A1 | V03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — V03: 행 집계 — A1 6요소: REVIEW:6 |  | 1 (V03) |
| WK-SSP0045-0288 | G03-WIRE | SSP0045 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SSP0045 화면: 게이트 G03 As-is 이벤트 chkSum.CheckedChanged → chkSum / 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에  |  | 14 (ACT:SSP0045_ShipmentRequest..ctor ACT:SS) |
| WK-SSP0045-0289 | G1 | CB04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CB04: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (CB04) |
| WK-SSP0045-0290 | G1 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E02: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (E02) |
| WK-SSP0045-0291 | G1 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E04: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (E04) |
| WK-SSP0045-0292 | G1 | EP01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — EP01: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (EP01) |
| WK-SSP0045-0293 | G1 | EP06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — EP06: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (EP06) |
| WK-SSP0045-0294 | G1 | G04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — G04: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (G04) |
| WK-SSP0045-0295 | G1 | G05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — G05: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (G05) |
| WK-SSP0045-0296 | G1 | G22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — G22: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (G22) |
| WK-SSP0045-0297 | G1 | PU01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — PU01: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (PU01) |
| WK-SSP0045-0298 | G1 | S24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — S24: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (S24) |
| WK-SSP0045-0299 | G1 | S25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — S25: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (S25) |
| WK-SSP0045-0300 | G1 | SP03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SP03: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SP03) |
| WK-SSP0045-0301 | G1 | SP05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SP05: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SP05) |
| WK-SSP0045-0302 | G1 | V03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — V03: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (V03) |
| WK-SSP0045-0303 | X-LOC | **백본 합계** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **백본 합계**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**백본 합계**) |
| WK-SSP0045-0304 | X-LOC | L01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L01: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L01) |
| WK-SSP0045-0305 | X-LOC | L02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L02: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L02) |
| WK-SSP0045-0306 | X-LOC | buttonGuards | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — buttonGuards: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (buttonGuards) |
| WK-SSP0045-0307 | X-LOC | comboCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — comboCalls: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (comboCalls) |
| WK-SSP0045-0308 | X-LOC | controls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — controls: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (controls) |
| WK-SSP0045-0309 | X-LOC | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — entryPoints: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (entryPoints) |
| WK-SSP0045-0310 | X-LOC | events | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — events: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (events) |
| WK-SSP0045-0311 | X-LOC | extractionLimits | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — extractionLimits: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (extractionLimits) |
| WK-SSP0045-0312 | X-LOC | gridColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridColumns: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridColumns) |
| WK-SSP0045-0313 | X-LOC | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridSignals: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridSignals) |
| WK-SSP0045-0314 | X-LOC | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — popups: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (popups) |
| WK-SSP0045-0315 | X-LOC | spCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spCalls: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spCalls) |
| WK-SSP0045-0316 | X-LOC | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — validations: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (validations) |
| WK-SSP0045-0317 | X-LOC | 백본 밖 G | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 백본 밖 G: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (백본 밖 G) |
| WK-SSP0045-0318 | X-ROW | **백본 합계** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — **백본 합계**: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (**백본 합계**) |
| WK-SSP0045-0319 | X-ROW | BG08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BG08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BG08) |
| WK-SSP0045-0320 | X-ROW | BG09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BG09: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BG09) |
| WK-SSP0045-0321 | X-ROW | BG11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BG11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BG11) |
| WK-SSP0045-0322 | X-ROW | BG12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BG12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BG12) |
| WK-SSP0045-0323 | X-ROW | BG13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BG13: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BG13) |
| WK-SSP0045-0324 | X-ROW | BG14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BG14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BG14) |
| WK-SSP0045-0325 | X-ROW | BG17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BG17: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BG17) |
| WK-SSP0045-0326 | X-ROW | C01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C01) |
| WK-SSP0045-0327 | X-ROW | C02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C02) |
| WK-SSP0045-0328 | X-ROW | C03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C03) |
| WK-SSP0045-0329 | X-ROW | C04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C04: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C04) |
| WK-SSP0045-0330 | X-ROW | C05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C05: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C05) |
| WK-SSP0045-0331 | X-ROW | C06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C06) |
| WK-SSP0045-0332 | X-ROW | C08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C08) |
| WK-SSP0045-0333 | X-ROW | C11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C11) |
| WK-SSP0045-0334 | X-ROW | C12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C12) |
| WK-SSP0045-0335 | X-ROW | C13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C13: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C13) |
| WK-SSP0045-0336 | X-ROW | C14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C14) |
| WK-SSP0045-0337 | X-ROW | C16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C16: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C16) |
| WK-SSP0045-0338 | X-ROW | C18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C18: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C18) |
| WK-SSP0045-0339 | X-ROW | C19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C19: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C19) |
| WK-SSP0045-0340 | X-ROW | C20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C20: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C20) |
| WK-SSP0045-0341 | X-ROW | CB01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB01) |
| WK-SSP0045-0342 | X-ROW | CB02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB02) |
| WK-SSP0045-0343 | X-ROW | E07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E07) |
| WK-SSP0045-0344 | X-ROW | EP11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EP11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (EP11) |
| WK-SSP0045-0345 | X-ROW | G01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G01) |
| WK-SSP0045-0346 | X-ROW | G07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G07) |
| WK-SSP0045-0347 | X-ROW | G09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G09: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G09) |
| WK-SSP0045-0348 | X-ROW | G10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G10) |
| WK-SSP0045-0349 | X-ROW | G12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G12) |
| WK-SSP0045-0350 | X-ROW | G15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G15: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G15) |
| WK-SSP0045-0351 | X-ROW | G18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G18: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G18) |
| WK-SSP0045-0352 | X-ROW | GC02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GC02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (GC02) |
| WK-SSP0045-0353 | X-ROW | L01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L01) |
| WK-SSP0045-0354 | X-ROW | L02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L02: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L02) |
| WK-SSP0045-0355 | X-ROW | S05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S05: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S05) |
| WK-SSP0045-0356 | X-ROW | S06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S06) |
| WK-SSP0045-0357 | X-ROW | S07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S07) |
| WK-SSP0045-0358 | X-ROW | S08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S08) |
| WK-SSP0045-0359 | X-ROW | S09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S09: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S09) |
| WK-SSP0045-0360 | X-ROW | S10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S10) |
| WK-SSP0045-0361 | X-ROW | S11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S11) |
| WK-SSP0045-0362 | X-ROW | S12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S12) |
| WK-SSP0045-0363 | X-ROW | S13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S13: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S13) |
| WK-SSP0045-0364 | X-ROW | S14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S14) |
| WK-SSP0045-0365 | X-ROW | S15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S15: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S15) |
| WK-SSP0045-0366 | X-ROW | S38 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S38: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S38) |
| WK-SSP0045-0367 | X-ROW | S39 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S39: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S39) |
| WK-SSP0045-0368 | X-ROW | S40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S40: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S40) |
| WK-SSP0045-0369 | X-ROW | S41 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S41: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S41) |
| WK-SSP0045-0370 | X-ROW | S42 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S42: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S42) |
| WK-SSP0045-0371 | X-ROW | S43 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — S43: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (S43) |
| WK-SSP0045-0372 | X-ROW | SSP0045_ShipmentRequest.BtnItem_Id_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.BtnItem_Id_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0045_ShipmentRequest.BtnItem_Id_C) |
| WK-SSP0045-0373 | X-ROW | SSP0045_ShipmentRequest.CboBizType_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.CboBizType_SelectedIndexCh: 진입점 집계 8검사 — NOT_RUN:4 · NOPATH:2 · TODO:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0045_ShipmentRequest.CboBizType_S) |
| WK-SSP0045-0374 | X-ROW | SSP0045_ShipmentRequest.CboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.CboDivision_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0045_ShipmentRequest.CboDivision_) |
| WK-SSP0045-0375 | X-ROW | SSP0045_ShipmentRequest.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.CreateSpread: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0045_ShipmentRequest.CreateSpread) |
| WK-SSP0045-0376 | X-ROW | SSP0045_ShipmentRequest.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0045_ShipmentRequest.DefineProper) |
| WK-SSP0045-0377 | X-ROW | SSP0045_ShipmentRequest.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0045_ShipmentRequest.EditButton) |
| WK-SSP0045-0378 | X-ROW | SSP0045_ShipmentRequest.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SSP0045_ShipmentRequest.FindButton) |
| WK-SSP0045-0379 | X-ROW | SSP0045_ShipmentRequest.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.FindData_Main: 진입점 집계 16검사 — NOT_RUN:12 · REVIEW:2 · PASS:2 |  | 9 (ACT:SSP0045_ShipmentRequest.FindData_Mai) |
| WK-SSP0045-0380 | X-ROW | SSP0045_ShipmentRequest.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0045_ShipmentRequest.Form_Load) |
| WK-SSP0045-0381 | X-ROW | SSP0045_ShipmentRequest.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.GetBucketType: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0045_ShipmentRequest.GetBucketTyp) |
| WK-SSP0045-0382 | X-ROW | SSP0045_ShipmentRequest.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0045_ShipmentRequest.GetDayRange) |
| WK-SSP0045-0383 | X-ROW | SSP0045_ShipmentRequest.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.InitControls: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0045_ShipmentRequest.InitControls) |
| WK-SSP0045-0384 | X-ROW | SSP0045_ShipmentRequest.InitSpreadDateCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SSP0045_ShipmentRequest.InitSpreadDa) |
| WK-SSP0045-0385 | X-ROW | SSP0045_ShipmentRequest.InitSpread_2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.InitSpread_2: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SSP0045_ShipmentRequest.InitSpread_2) |
| WK-SSP0045-0386 | X-ROW | SSP0045_ShipmentRequest.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/DATA_OP/ENTRY/EXPR/GRID_COMBO/GRID_L |  | 15 (ACT:SSP0045_ShipmentRequest.InsertRow AC) |
| WK-SSP0045-0387 | X-ROW | SSP0045_ShipmentRequest.InsertRow2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.InsertRow2: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/DATA_OP/ENTRY/EXPR/GRID_COMBO/GRID_ |  | 15 (ACT:SSP0045_ShipmentRequest.InsertRow2 A) |
| WK-SSP0045-0388 | X-ROW | SSP0045_ShipmentRequest.RetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.RetValue: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 6 (ACT:SSP0045_ShipmentRequest.RetValue ACT) |
| WK-SSP0045-0389 | X-ROW | SSP0045_ShipmentRequest.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.SaveData: 진입점 집계 15검사 — NOT_RUN:10 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0045_ShipmentRequest.SaveData:855) |
| WK-SSP0045-0390 | X-ROW | SSP0045_ShipmentRequest.SetBODItemID | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.SetBODItemID: 진입점 집계 8검사 — NOT_RUN:4 · NOPATH:2 · TODO:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0045_ShipmentRequest.SetBODItemID) |
| WK-SSP0045-0391 | X-ROW | SSP0045_ShipmentRequest.SetChangeControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.SetChangeControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0045_ShipmentRequest.SetChangeCon) |
| WK-SSP0045-0392 | X-ROW | SSP0045_ShipmentRequest.SetChangedContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.SetChangedControl: 진입점 집계 9검사 — NOT_RUN:5 · NOPATH:2 · TODO:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0045_ShipmentRequest.SetChangedCo) |
| WK-SSP0045-0393 | X-ROW | SSP0045_ShipmentRequest.SetImageCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.SetImageCell: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0045_ShipmentRequest.SetImageCell) |
| WK-SSP0045-0394 | X-ROW | SSP0045_ShipmentRequest.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.SetLockSumColumn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0045_ShipmentRequest.SetLockSumCo) |
| WK-SSP0045-0395 | X-ROW | SSP0045_ShipmentRequest.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.SetSpreadColumn: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0045_ShipmentRequest.SetSpreadCol) |
| WK-SSP0045-0396 | X-ROW | SSP0045_ShipmentRequest.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.Set_MeasureColor: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0045_ShipmentRequest.Set_MeasureC) |
| WK-SSP0045-0397 | X-ROW | SSP0045_ShipmentRequest.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.Set_SumValues: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0045_ShipmentRequest.Set_SumValue) |
| WK-SSP0045-0398 | X-ROW | SSP0045_ShipmentRequest.SpdMain_CellClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.SpdMain_CellClick: 진입점 집계 3검사 — NOT_RUN:2 · WARN:1 |  | 75 (ACT:SSP0045_ShipmentRequest.SpdMain_Cell) |
| WK-SSP0045-0399 | X-ROW | SSP0045_ShipmentRequest.SpdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0045_ShipmentRequest.SpdMain_Cell) |
| WK-SSP0045-0400 | X-ROW | SSP0045_ShipmentRequest.SpdMain_ComboSel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.SpdMain_ComboSelChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SSP0045_ShipmentRequest.SpdMain_Comb) |
| WK-SSP0045-0401 | X-ROW | SSP0045_ShipmentRequest.SpdMain_TopChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0045_ShipmentRequest.SpdMain_TopC) |
| WK-SSP0045-0402 | X-ROW | SSP0045_ShipmentRequest.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.cboBucketType_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0045_ShipmentRequest.cboBucketTyp) |
| WK-SSP0045-0403 | X-ROW | SSP0045_ShipmentRequest.checkValidN0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.checkValidN0: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 61 (ACT:SSP0045_ShipmentRequest.checkValidN0) |
| WK-SSP0045-0404 | X-ROW | SSP0045_ShipmentRequest.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0045_ShipmentRequest.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0045_ShipmentRequest.chkSum_Check) |
| WK-SSP0045-0405 | X-ROW | buttonGuards | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — buttonGuards: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (buttonGuards) |
| WK-SSP0045-0406 | X-ROW | comboCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — comboCalls: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (comboCalls) |
| WK-SSP0045-0407 | X-ROW | controls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — controls: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (controls) |
| WK-SSP0045-0408 | X-ROW | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — entryPoints: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (entryPoints) |
| WK-SSP0045-0409 | X-ROW | events | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — events: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (events) |
| WK-SSP0045-0410 | X-ROW | extractionLimits | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — extractionLimits: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (extractionLimits) |
| WK-SSP0045-0411 | X-ROW | gridColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — gridColumns: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (gridColumns) |
| WK-SSP0045-0412 | X-ROW | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — gridSignals: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (gridSignals) |
| WK-SSP0045-0413 | X-ROW | spCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — spCalls: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (spCalls) |
| WK-SSP0045-0414 | X-ROW | 백본 밖 G | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 백본 밖 G: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (백본 밖 G) |
