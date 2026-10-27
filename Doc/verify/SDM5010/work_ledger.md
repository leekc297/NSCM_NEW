# 작업 원장 — SDM5010 · 2026-10-26 12:55

> 검사 인스턴스 507건 중 PASS·NA 307건 외 **200건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 97 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W5 | 검사기 연결 | 2 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 25 | 실행 → PASS |
| W7 | 기대값 확정 | 75 | 기대 확정 → PASS/FAIL |

- 담당: 대조표 100 · 사람 판정 / AS-IS 원문 확인 → 재판정 72 · E2E 25 · 하네스 2 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 97 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A1 | GEN |  |  |  |  |  |  | 59 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| E4 | EDIT |  |  |  |  |  | 15 | 2 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-ROW | GEN |  |  |  |  |  |  | 10 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-REASON | DESIGN |  |  |  |  |  |  | 3 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| F4 | DB |  |  |  |  |  | 1 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A6 | GEN |  |  |  |  |  | 1 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |

## W2 구현 위치 확인 (97)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SDM5010-0001 | X-LOC | CF-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-01) |
| WK-SDM5010-0002 | X-LOC | CF-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-02) |
| WK-SDM5010-0003 | X-LOC | CF-03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-03) |
| WK-SDM5010-0004 | X-LOC | CF-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-04) |
| WK-SDM5010-0005 | X-LOC | CF-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-05) |
| WK-SDM5010-0006 | X-LOC | CF-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-06) |
| WK-SDM5010-0007 | X-LOC | CF-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-07) |
| WK-SDM5010-0008 | X-LOC | CF-08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-08) |
| WK-SDM5010-0009 | X-LOC | CF-09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-09) |
| WK-SDM5010-0010 | X-LOC | CF-10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-10) |
| WK-SDM5010-0011 | X-LOC | CF-11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-11) |
| WK-SDM5010-0012 | X-LOC | CF-12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-12) |
| WK-SDM5010-0013 | X-LOC | CF-13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-13) |
| WK-SDM5010-0014 | X-LOC | CF-14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-14) |
| WK-SDM5010-0015 | X-LOC | CF-15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-15) |
| WK-SDM5010-0016 | X-LOC | CF-16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-16) |
| WK-SDM5010-0017 | X-LOC | CF-17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-17) |
| WK-SDM5010-0018 | X-LOC | CF-18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-18) |
| WK-SDM5010-0019 | X-LOC | CF-19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-19) |
| WK-SDM5010-0020 | X-LOC | CF-21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-21) |
| WK-SDM5010-0021 | X-LOC | CF-22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-22) |
| WK-SDM5010-0022 | X-LOC | CF-23 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-23) |
| WK-SDM5010-0023 | X-LOC | CF-24 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-24) |
| WK-SDM5010-0024 | X-LOC | CF-25 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-25) |
| WK-SDM5010-0025 | X-LOC | CF-26 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CF-26) |
| WK-SDM5010-0026 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-02) |
| WK-SDM5010-0027 | X-LOC | COMMON:UC-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-04) |
| WK-SDM5010-0028 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SDM5010-0029 | X-LOC | COMMON:UC-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-06) |
| WK-SDM5010-0030 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-07) |
| WK-SDM5010-0031 | X-LOC | CRUD:E01:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E01:SEARCH) |
| WK-SDM5010-0032 | X-LOC | CRUD:E02:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E02:SEARCH) |
| WK-SDM5010-0033 | X-LOC | CRUD:E04:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E04:SEARCH) |
| WK-SDM5010-0034 | X-LOC | CRUD:E06:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E06:SEARCH) |
| WK-SDM5010-0035 | X-LOC | CRUD:E07:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E07:SEARCH) |
| WK-SDM5010-0036 | X-LOC | CRUD:E09:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E09:SEARCH) |
| WK-SDM5010-0037 | X-LOC | CRUD:E10:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E10:SEARCH) |
| WK-SDM5010-0038 | X-LOC | CRUD:E11:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E11:SEARCH) |
| WK-SDM5010-0039 | X-LOC | CRUD:E12:INSERT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E12:INSERT) |
| WK-SDM5010-0040 | X-LOC | CRUD:E12:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E12:SEARCH) |
| WK-SDM5010-0041 | X-LOC | CRUD:E13:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E13:SEARCH) |
| WK-SDM5010-0042 | X-LOC | CRUD:E14:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E14:SEARCH) |
| WK-SDM5010-0043 | X-LOC | CRUD:E16:SAVE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E16:SAVE) |
| WK-SDM5010-0044 | X-LOC | CRUD:E16:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E16:SEARCH) |
| WK-SDM5010-0045 | X-LOC | CRUD:E18:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E18:SEARCH) |
| WK-SDM5010-0046 | X-LOC | CRUD:E20:SAVE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E20:SAVE) |
| WK-SDM5010-0047 | X-LOC | CRUD:E20:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E20:SEARCH) |
| WK-SDM5010-0048 | X-LOC | CRUD:E23:SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CRUD:E23:SEARCH) |
| WK-SDM5010-0049 | X-LOC | E01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E01) |
| WK-SDM5010-0050 | X-LOC | E01-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E01-1) |
| WK-SDM5010-0051 | X-LOC | E01-2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E01-2) |
| WK-SDM5010-0052 | X-LOC | E01-3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E01-3) |
| WK-SDM5010-0053 | X-LOC | E01-4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E01-4) |
| WK-SDM5010-0054 | X-LOC | E01-5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E01-5) |
| WK-SDM5010-0055 | X-LOC | E02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E02) |
| WK-SDM5010-0056 | X-LOC | E03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E03) |
| WK-SDM5010-0057 | X-LOC | E04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E04) |
| WK-SDM5010-0058 | X-LOC | E05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E05) |
| WK-SDM5010-0059 | X-LOC | E06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E06) |
| WK-SDM5010-0060 | X-LOC | E07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E07) |
| WK-SDM5010-0061 | X-LOC | E08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E08) |
| WK-SDM5010-0062 | X-LOC | E09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E09) |
| WK-SDM5010-0063 | X-LOC | E10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E10) |
| WK-SDM5010-0064 | X-LOC | E11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E11) |
| WK-SDM5010-0065 | X-LOC | E12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E12) |
| WK-SDM5010-0066 | X-LOC | E13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E13) |
| WK-SDM5010-0067 | X-LOC | E14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E14) |
| WK-SDM5010-0068 | X-LOC | E15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E15) |
| WK-SDM5010-0069 | X-LOC | E16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E16) |
| WK-SDM5010-0070 | X-LOC | E17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E17) |
| WK-SDM5010-0071 | X-LOC | E18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E18) |
| WK-SDM5010-0072 | X-LOC | E19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E19) |
| WK-SDM5010-0073 | X-LOC | E20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E20) |
| WK-SDM5010-0074 | X-LOC | E21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E21) |
| WK-SDM5010-0075 | X-LOC | E23 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E23) |
| WK-SDM5010-0076 | X-LOC | E24 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E24) |
| WK-SDM5010-0077 | X-LOC | MODAL:ProjectAuthRegModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MODAL:ProjectAuthRegModal) |
| WK-SDM5010-0078 | X-LOC | P-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-01) |
| WK-SDM5010-0079 | X-LOC | P-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-02) |
| WK-SDM5010-0080 | X-LOC | P-03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-03) |
| WK-SDM5010-0081 | X-LOC | P-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-04) |
| WK-SDM5010-0082 | X-LOC | P-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-05) |
| WK-SDM5010-0083 | X-LOC | P-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-06) |
| WK-SDM5010-0084 | X-LOC | P-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-07) |
| WK-SDM5010-0085 | X-LOC | P-08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-08) |
| WK-SDM5010-0086 | X-LOC | P-09 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-09) |
| WK-SDM5010-0087 | X-LOC | P-10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-10) |
| WK-SDM5010-0088 | X-LOC | P-11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-11) |
| WK-SDM5010-0089 | X-LOC | P-12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-12) |
| WK-SDM5010-0090 | X-LOC | P-13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-13) |
| WK-SDM5010-0091 | X-LOC | P-15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-15) |
| WK-SDM5010-0092 | X-LOC | P-16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-16) |
| WK-SDM5010-0093 | X-LOC | P-17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-17) |
| WK-SDM5010-0094 | X-LOC | P-18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-18) |
| WK-SDM5010-0095 | X-LOC | P-19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-19) |
| WK-SDM5010-0096 | X-LOC | P-20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-20) |
| WK-SDM5010-0097 | X-LOC | P-21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (P-21) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SDM5010-0098 | H10 | SDM5010 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SDM5010 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: project-master.constants.ts |  | 17 (E03 E06 E07 E12 E18 E20 P-01 P-02 P-03 P) |

## W5 검사기 연결 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SDM5010-0099 | F2 | SDM5010 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SDM5010 화면 | 판단불가(대상 단위 SCREEN) | 16 (E03 E16 E17 E20 CF-24 CF-26 P-13 P-19 P-) |
| WK-SDM5010-0100 | F6 | SDM5010 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SDM5010 화면 | 판단불가(대상 단위 SCREEN) | 1 (P-20) |

## W6 검증 실행 (25)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SDM5010-0101 | J2 | SDM5010 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SDM5010 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 71 (E01 E01-1 E01-2 E01-5 E02 E03 E04 E05 E0) |
| WK-SDM5010-0102 | G3 | SDM5010 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SDM5010 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 5 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SDM5010-0103 | K4 | SDM5010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SDM5010 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 5 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SDM5010-0104 | F1 | SDM5010 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SDM5010 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 16 (E03 E16 E17 E20 CF-24 CF-26 P-13 P-19 P-) |
| WK-SDM5010-0105 | F5 | SDM5010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SDM5010 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (P-13) |
| WK-SDM5010-0106 | F4 | PKG_SDM1010.P_SDM1010_GET_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SDM1010.P_SDM1010_GET_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 1 (E01-2) |
| WK-SDM5010-0107 | I1 | SDM5010 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SDM5010 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 14 (E03 E06 E07 E12 E18 E20 P-01 P-02 P-03 P) |
| WK-SDM5010-0108 | SC1 | SDM5010 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SDM5010 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 9 (E01 E01-1 E04 E23 CF-04 CRUD:E01:SEARCH ) |
| WK-SDM5010-0109 | D6 | SDM5010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SDM5010 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 5 (E12 P-13 P-17 CRUD:E12:INSERT CRUD:E12:S) |
| WK-SDM5010-0110 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-04) |
| WK-SDM5010-0111 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (E20) |
| WK-SDM5010-0112 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (E18 P-01) |
| WK-SDM5010-0113 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (E18 P-02) |
| WK-SDM5010-0114 | E4 | MSG00164 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00164 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (E18 P-03) |
| WK-SDM5010-0115 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (E03 COMMON:UC-02) |
| WK-SDM5010-0116 | E4 | MSG00716 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00716 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (E12 P-17) |
| WK-SDM5010-0117 | E4 | MSG00717 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00717 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-17) |
| WK-SDM5010-0118 | E4 | MSG01007 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01007 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (E12 P-17) |
| WK-SDM5010-0119 | E4 | MSG01008 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01008 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (E06 P-09) |
| WK-SDM5010-0120 | E4 | MSG01009 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01009 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (E06 P-09 COMMON:UC-04) |
| WK-SDM5010-0121 | E4 | MSG01010 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01010 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-09) |
| WK-SDM5010-0122 | E4 | MSG01011 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01011 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (E07 P-10) |
| WK-SDM5010-0123 | E4 | MSG01012 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01012 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (E07 P-10 COMMON:UC-04) |
| WK-SDM5010-0124 | E4 | MSG01013 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01013 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (P-10) |
| WK-SDM5010-0125 | A6 | PKG_SDM1010.P_SDM1010_GET_PERIOD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SDM1010.P_SDM1010_GET_PERIOD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace |  | 1 (E01-2) |

## W7 기대값 확정 (75)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SDM5010-0126 | F4 | P-20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — P-20: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (P-20) |
| WK-SDM5010-0127 | X-REASON | CF-20 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CF-20 lookup·마스터 INNER 소실 축 전수 / GET_TAB1 = INNER 9/LEFT 4 · GET_TAB2 = INNER 9/LEFT 6 — INNER …  SP 조회 축 관찰(D9 |  | 1 (CF-20) |
| WK-SDM5010-0128 | X-REASON | CRUD:E17:SAVE | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CRUD:E17:SAVE [SAVE] 팝업 Close/X / 저장 없이 닫기(pending 폐기)  Close = 무저장 계약(pending 폐기 — PAM:104-122 open reset. SAV |  | 1 (CRUD:E17:SAVE) |
| WK-SDM5010-0129 | X-REASON | P-14 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — P-14 TAB2 표시 / TAB2 조회 범위 = `DPJT_REG_STATUS NOT IN ('WRITING','WAITING','REQ_MOD')`(작성중/승인대기/…  SP WHERE 고정 축( |  | 1 (P-14) |
| WK-SDM5010-0130 | E4 | CRUD:E18:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CRUD:E18:SEARCH: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:E18:SEARCH) |
| WK-SDM5010-0131 | E4 | P-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — P-08: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (P-08) |
| WK-SDM5010-0132 | A1 | CF-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-04: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CF-04) |
| WK-SDM5010-0133 | A1 | CF-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-07: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CF-07) |
| WK-SDM5010-0134 | A1 | CF-13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-13: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CF-13) |
| WK-SDM5010-0135 | A1 | CF-14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-14: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CF-14) |
| WK-SDM5010-0136 | A1 | CF-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-16: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CF-16) |
| WK-SDM5010-0137 | A1 | CF-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-18: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CF-18) |
| WK-SDM5010-0138 | A1 | CF-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-24: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CF-24) |
| WK-SDM5010-0139 | A1 | CF-26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CF-26: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CF-26) |
| WK-SDM5010-0140 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-02) |
| WK-SDM5010-0141 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-06) |
| WK-SDM5010-0142 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-07) |
| WK-SDM5010-0143 | A1 | CRUD:E01:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E01:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E01:SEARCH) |
| WK-SDM5010-0144 | A1 | CRUD:E02:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E02:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E02:SEARCH) |
| WK-SDM5010-0145 | A1 | CRUD:E04:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E04:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E04:SEARCH) |
| WK-SDM5010-0146 | A1 | CRUD:E06:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E06:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E06:SEARCH) |
| WK-SDM5010-0147 | A1 | CRUD:E07:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E07:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E07:SEARCH) |
| WK-SDM5010-0148 | A1 | CRUD:E09:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E09:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E09:SEARCH) |
| WK-SDM5010-0149 | A1 | CRUD:E10:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E10:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E10:SEARCH) |
| WK-SDM5010-0150 | A1 | CRUD:E11:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E11:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E11:SEARCH) |
| WK-SDM5010-0151 | A1 | CRUD:E12:INSERT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E12:INSERT: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E12:INSERT) |
| WK-SDM5010-0152 | A1 | CRUD:E12:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E12:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E12:SEARCH) |
| WK-SDM5010-0153 | A1 | CRUD:E13:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E13:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E13:SEARCH) |
| WK-SDM5010-0154 | A1 | CRUD:E14:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E14:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E14:SEARCH) |
| WK-SDM5010-0155 | A1 | CRUD:E16:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E16:SAVE: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E16:SAVE) |
| WK-SDM5010-0156 | A1 | CRUD:E16:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E16:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E16:SEARCH) |
| WK-SDM5010-0157 | A1 | CRUD:E18:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E18:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E18:SEARCH) |
| WK-SDM5010-0158 | A1 | CRUD:E20:SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E20:SAVE: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E20:SAVE) |
| WK-SDM5010-0159 | A1 | CRUD:E20:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E20:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E20:SEARCH) |
| WK-SDM5010-0160 | A1 | CRUD:E23:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:E23:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:E23:SEARCH) |
| WK-SDM5010-0161 | A1 | E01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E01) |
| WK-SDM5010-0162 | A1 | E01-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01-1: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E01-1) |
| WK-SDM5010-0163 | A1 | E01-5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E01-5: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E01-5) |
| WK-SDM5010-0164 | A1 | E02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E02: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E02) |
| WK-SDM5010-0165 | A1 | E04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E04: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E04) |
| WK-SDM5010-0166 | A1 | E06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E06: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E06) |
| WK-SDM5010-0167 | A1 | E07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E07: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E07) |
| WK-SDM5010-0168 | A1 | E08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E08: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E08) |
| WK-SDM5010-0169 | A1 | E10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E10: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E10) |
| WK-SDM5010-0170 | A1 | E11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E11: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E11) |
| WK-SDM5010-0171 | A1 | E12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E12: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E12) |
| WK-SDM5010-0172 | A1 | E13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E13: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E13) |
| WK-SDM5010-0173 | A1 | E14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E14: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E14) |
| WK-SDM5010-0174 | A1 | E16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E16: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E16) |
| WK-SDM5010-0175 | A1 | E18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E18: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E18) |
| WK-SDM5010-0176 | A1 | E20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E20: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E20) |
| WK-SDM5010-0177 | A1 | E23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E23: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (E23) |
| WK-SDM5010-0178 | A1 | P-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-01: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (P-01) |
| WK-SDM5010-0179 | A1 | P-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-02: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (P-02) |
| WK-SDM5010-0180 | A1 | P-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-03: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (P-03) |
| WK-SDM5010-0181 | A1 | P-15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-15: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (P-15) |
| WK-SDM5010-0182 | A1 | P-16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-16: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (P-16) |
| WK-SDM5010-0183 | A1 | P-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-17: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (P-17) |
| WK-SDM5010-0184 | A1 | P-18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-18: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (P-18) |
| WK-SDM5010-0185 | A1 | P-20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P-20: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (P-20) |
| WK-SDM5010-0186 | A1 | PKG_SDM1010.P_SDM1010_GET_PERIOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SDM1010.P_SDM1010_GET_PERIOD: 골든 비교 케이스 없음(PKG_SDM1010.P_SDM1010_GET_PERIOD — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 |  | 1 (E01-2) |
| WK-SDM5010-0187 | A1 | P_DPJT_KEY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DPJT_KEY: 골든 비교 케이스 없음(P_DPJT_KEY — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (CF-21) |
| WK-SDM5010-0188 | A1 | P_SDM1010_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SDM1010_: 골든 비교 케이스 없음(P_SDM1010_ — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (E09) |
| WK-SDM5010-0189 | A1 | P_SES_USER_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SES_USER_ID: 골든 비교 케이스 없음(P_SES_USER_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (P-04) |
| WK-SDM5010-0190 | A1 | P_USER_INFO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_USER_INFO: 골든 비교 케이스 없음(P_USER_INFO — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (CF-23) |
| WK-SDM5010-0191 | X-ROW | CF-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-01) |
| WK-SDM5010-0192 | X-ROW | CF-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-06: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-06) |
| WK-SDM5010-0193 | X-ROW | CF-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-08) |
| WK-SDM5010-0194 | X-ROW | CF-09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-09: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-09) |
| WK-SDM5010-0195 | X-ROW | CF-12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-12) |
| WK-SDM5010-0196 | X-ROW | CF-17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-17: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-17) |
| WK-SDM5010-0197 | X-ROW | CF-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-22: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-22) |
| WK-SDM5010-0198 | X-ROW | CF-25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CF-25: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CF-25) |
| WK-SDM5010-0199 | X-ROW | E01-4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — E01-4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (E01-4) |
| WK-SDM5010-0200 | X-ROW | P-21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — P-21: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (P-21) |
