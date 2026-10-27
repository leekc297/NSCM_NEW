# 작업 원장 — SCP0098 · 2026-10-26 12:54

> 검사 인스턴스 792건 중 PASS·NA 195건 외 **597건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 45 | 구현 위치 실존 |
| W4 | 검사기 구현 | 3 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 46 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 131 | 실행 → PASS |
| W7 | 기대값 확정 | 372 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 355 · E2E 131 · 대조표 62 · 하네스 49
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 8건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 88 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 18 | 33 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-LOC | GEN |  | 45 |  |  |  |  | 5 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| C3 | CASCADE |  |  |  |  |  | 8 | 25 |  |  | 연쇄 자동 채움 |
| B4 | COMBO |  |  |  |  | 8 |  | 16 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C2 | CASCADE |  |  |  |  |  | 7 | 15 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 7 | 15 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| A5 | DESIGN |  |  |  |  |  | 2 | 19 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| B3 | COMBO |  |  |  | 3 |  |  | 15 |  |  | 콤보 후보 정렬 = AS-IS |
| H2 | DESIGN |  |  |  |  |  | 2 | 16 |  |  | 배경·글자색 규칙 |
| D1 | EDIT |  |  |  |  |  | 4 | 14 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 4 | 14 |  |  | 행 값 기반 조건부 잠금 |
| X-REASON | DESIGN |  |  |  |  |  |  | 17 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| H5 | DESIGN |  |  |  |  |  | 4 | 12 |  |  | 라벨 명칭 |
| D4 | EDIT |  |  |  |  |  | 1 | 14 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| G1 | GEN |  |  |  |  |  | 9 | 6 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G5 | POPUP |  |  |  |  | 8 |  | 6 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 5 | 3 | 6 |  |  | 팝업 표준·열림 |
| F4 | DB |  |  |  |  |  | 10 | 4 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| M4 | POPUP |  |  |  |  |  | 8 | 6 |  |  | 팝업 선택값 반영 |
| G4 | DESIGN |  |  |  |  | 2 | 9 | 2 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 9 | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| A1 | GEN |  |  |  |  |  |  | 10 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| DB-SYN | DB |  |  |  |  | 4 |  | 4 |  |  | BE 계정 시노님·권한·대상 객체 |
| B1 | COMBO |  |  |  |  | 6 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 6 |  | 1 |  |  | 콤보 후보 중복 없음 |
| C1 | CASCADE |  |  |  |  |  | 6 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| D5 | EDIT |  |  |  |  |  | 2 | 4 |  |  | 셀 에디터 유형 |
| B6 | COMBO |  |  |  |  | 5 |  |  |  |  | ALL 옵션·다중선택 사양 |
| M3 | POPUP |  |  |  |  |  | 3 |  |  |  | 팝업 내부 기능(조회·CRUD) |
| A6 | GEN |  |  |  |  |  | 2 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| C4 | CASCADE |  |  |  |  |  | 1 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| I1 | DESIGN |  |  |  |  |  |  | 1 |  |  | LBL/MSG 언어별 등록 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |

## W2 구현 위치 확인 (45)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0098-0001 | X-LOC | #1 MSG00012 저장확인 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (#1 MSG00012 저장확인) |
| WK-SCP0098-0002 | X-LOC | #16/#23 CAPA_WORK>10000 저장불가 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (#16/#23 CAPA_WORK>10000 저장불가) |
| WK-SCP0098-0003 | X-LOC | #17/#18/#19 [생산준비율/Capa/CapaWork] 저장실패 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (#17/#18/#19 [생산준비율/Capa/CapaWork] 저장실패) |
| WK-SCP0098-0004 | X-LOC | #2 MSG00199 작업중(save_status RUN) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (#2 MSG00199 작업중(save_status RUN)) |
| WK-SCP0098-0005 | X-LOC | #20 저장할 데이터 없음 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (#20 저장할 데이터 없음) |
| WK-SCP0098-0006 | X-LOC | #35 [Y,N]만 입력 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (#35 [Y,N]만 입력) |
| WK-SCP0098-0007 | X-LOC | #36/#37 복사 완료/실패 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (#36/#37 복사 완료/실패) |
| WK-SCP0098-0008 | X-LOC | #41 비조업 Y/N | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (#41 비조업 Y/N) |
| WK-SCP0098-0009 | X-LOC | #42 가동율 0~100 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (#42 가동율 0~100) |
| WK-SCP0098-0010 | X-LOC | #44 Ramp-up 0~1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (#44 Ramp-up 0~1) |
| WK-SCP0098-0011 | X-LOC | #46/#47 Daily Capa >0/요일불가 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (#46/#47 Daily Capa >0/요일불가) |
| WK-SCP0098-0012 | X-LOC | 1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1) |
| WK-SCP0098-0013 | X-LOC | 10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (10) |
| WK-SCP0098-0014 | X-LOC | 11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (11) |
| WK-SCP0098-0015 | X-LOC | 2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2) |
| WK-SCP0098-0016 | X-LOC | 3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3) |
| WK-SCP0098-0017 | X-LOC | 4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (4) |
| WK-SCP0098-0018 | X-LOC | 5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (5) |
| WK-SCP0098-0019 | X-LOC | 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (6) |
| WK-SCP0098-0020 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (7) |
| WK-SCP0098-0021 | X-LOC | 8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (8) |
| WK-SCP0098-0022 | X-LOC | 9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (9) |
| WK-SCP0098-0023 | X-LOC | D00-1-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-003) |
| WK-SCP0098-0024 | X-LOC | D00-1-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-005) |
| WK-SCP0098-0025 | X-LOC | D00-1-020 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-020) |
| WK-SCP0098-0026 | X-LOC | D00-1-024 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-024) |
| WK-SCP0098-0027 | X-LOC | D00-1-028 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-028) |
| WK-SCP0098-0028 | X-LOC | D00-1-031 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-031) |
| WK-SCP0098-0029 | X-LOC | D00-1-036 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-036) |
| WK-SCP0098-0030 | X-LOC | ExcelButton(FPC0109 옵션→Export) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ExcelButton(FPC0109 옵션→Export)) |
| WK-SCP0098-0031 | X-LOC | FindButton(실동작) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton(실동작)) |
| WK-SCP0098-0032 | X-LOC | P_GET_CAPA_MOBILITYIT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: procedures.d.ts 없음 |  | 1 (P_GET_CAPA_MOBILITYIT) |
| WK-SCP0098-0033 | X-LOC | R1 NO_WORK Y/N | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R1 NO_WORK Y/N) |
| WK-SCP0098-0034 | X-LOC | R1 PRODUCT_READY Auto-Sync | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R1 PRODUCT_READY Auto-Sync) |
| WK-SCP0098-0035 | X-LOC | R2/R10 btnInput bulk-fill | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R2/R10 btnInput bulk-fill) |
| WK-SCP0098-0036 | X-LOC | R3 measure별 편집영역(LockRange 13) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R3 measure별 편집영역(LockRange 13)) |
| WK-SCP0098-0037 | X-LOC | R4 초기 잠금·좌측 세로머지 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R4 초기 잠금·좌측 세로머지) |
| WK-SCP0098-0038 | X-LOC | R5 셀 포맷·색(NO_WORK Blue/DAILY_CAPA 정수콤마) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R5 셀 포맷·색(NO_WORK Blue/DAILY_CAPA 정수콤마)) |
| WK-SCP0098-0039 | X-LOC | R6 chkDetail D_↔M_ 토글 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R6 chkDetail D_↔M_ 토글) |
| WK-SCP0098-0040 | X-LOC | R7 3단 헤더 span + 주말색 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R7 3단 헤더 span + 주말색) |
| WK-SCP0098-0041 | X-LOC | R8 spdInfo 머지 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R8 spdInfo 머지) |
| WK-SCP0098-0042 | X-LOC | R9 시트전환/좌표 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R9 시트전환/좌표) |
| WK-SCP0098-0043 | X-LOC | SaveButton(MSG00012 확인 → save_status 가드  | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton(MSG00012 확인 → save_status 가드 ) |
| WK-SCP0098-0044 | X-LOC | SpdMain_Changed 가드 #9~13(재진입/Action컬럼/ds | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SpdMain_Changed 가드 #9~13(재진입/Action컬럼/ds) |
| WK-SCP0098-0045 | X-LOC | 기타 tran/Exception | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (기타 tran/Exception) |

## W4 검사기 구현 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0098-0046 | B3 | COLUMN_NAME | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 COLUMN_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0098_CAPAReprotSmall.GetDayOfWeek) |
| WK-SCP0098-0047 | B3 | DAY_CODE | 하네스(검증 엔진 _trace.spec.ts) + 구현 확인(TO-BE  | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DAY_CODE | 없음 | 2 (ACT:SCP0098_CAPAReprotSmall.GetDayOfWeek) |
| WK-SCP0098-0048 | B3 | cboDivision / Div  / Division / Div | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Div  / Division / Div | 있음(FE 소스) | 4 (ACT:SCP0098_CAPAReprotSmall.SetChangedCo) |

## W5 검사기 연결 (46)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0098-0049 | B1 | MEASURE_UI | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL MEASURE_UI | 있음(SHEET_COLUMNS) | 1 (D00-1-007) |
| WK-SCP0098-0050 | B1 | cboCategory / Category | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboCategory / Category | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0098-0051 | B1 | cboDayWeek / Day Type / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDayWeek / Day Type / Day Week | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0098-0052 | B1 | cboDivision / Div  / Division / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Div  / Division / Div | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0098-0053 | B1 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0098-0054 | B1 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0098-0055 | B2 | MEASURE_UI | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL MEASURE_UI | 있음(SHEET_COLUMNS) | 1 (D00-1-007) |
| WK-SCP0098-0056 | B2 | cboCategory / Category | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboCategory / Category | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0098-0057 | B2 | cboDayWeek / Day Type / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDayWeek / Day Type / Day Week | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0098-0058 | B2 | cboDivision / Div  / Division / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Div  / Division / Div | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0098-0059 | B2 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0098-0060 | B2 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0098-0061 | B4 | COLUMN_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL COLUMN_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0098_CAPAReprotSmall.GetDayOfWeek) |
| WK-SCP0098-0062 | B4 | DAY_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DAY_CODE | 없음 | 2 (ACT:SCP0098_CAPAReprotSmall.GetDayOfWeek) |
| WK-SCP0098-0063 | B4 | MEASURE_UI | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL MEASURE_UI | 있음(SHEET_COLUMNS) | 1 (D00-1-007) |
| WK-SCP0098-0064 | B4 | cboCategory / Category | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboCategory / Category | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0098-0065 | B4 | cboDayWeek / Day Type / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDayWeek / Day Type / Day Week | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0098-0066 | B4 | cboDivision / Div  / Division / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Div  / Division / Div | 있음(FE 소스) | 5 (D00-1-009 ACT:SCP0098_CAPAReprotSmall.Se) |
| WK-SCP0098-0067 | B4 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0098-0068 | B4 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0098-0069 | B6 | cboCategory / Category | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboCategory / Category | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0098-0070 | B6 | cboDayWeek / Day Type / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDayWeek / Day Type / Day Week | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0098-0071 | B6 | cboDivision / Div  / Division / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Div  / Division / Div | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0098-0072 | B6 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0098-0073 | B6 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0098-0074 | F2 | SCP0098 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0098 화면 | 판단불가(대상 단위 SCREEN) | 578 (D00-4d-005 D00-4d-006 D00-4d-007 COMMON:) |
| WK-SCP0098-0075 | F6 | SCP0098 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0098 화면 | 판단불가(대상 단위 SCREEN) | 568 (SaveButton(MSG00012 확인 → save_status 가드 ) |
| WK-SCP0098-0076 | DB-SYN | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0098_CAPAReprotSmall.GetLastRange) |
| WK-SCP0098-0077 | DB-SYN | SCP0098_SAVE_SCP_CAPA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0098_SAVE_SCP_CAPA | 없음(PROC_M 대응 없음) | 6 (ACT:SCP0098_CAPAReprotSmall.SaveDataFull) |
| WK-SCP0098-0078 | DB-SYN | SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE | 없음(PROC_M 대응 없음) | 8 (ACT:SCP0098_CAPAReprotSmall.SaveDataFull) |
| WK-SCP0098-0079 | DB-SYN | SCP0098_SAVE_SCP_CAPA_WORK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0098_SAVE_SCP_CAPA_WORK | 없음(PROC_M 대응 없음) | 6 (ACT:SCP0098_CAPAReprotSmall.SaveDataFull) |
| WK-SCP0098-0080 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0098_CAPAReprotSmall.InitEvent AC) |
| WK-SCP0098-0081 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:SCP0098_CAPAReprotSmall.InitEvent AC) |
| WK-SCP0098-0082 | G5 | MEASURE_UI | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL MEASURE_UI | 있음(SHEET_COLUMNS) | 1 (D00-1-007) |
| WK-SCP0098-0083 | G5 | SCP0098_CopySelect_Popup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SCP0098_CopySelect_Popup | 판단불가(대상 단위 POPUP) | 3 (MODAL:CopySelectModal SCP0098_CopySelect) |
| WK-SCP0098-0084 | G5 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnInput | 없음 | 1 (D00-1-003) |
| WK-SCP0098-0085 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (MODAL:ShowDialog) |
| WK-SCP0098-0086 | G5 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (MODAL:ShowDialog) |
| WK-SCP0098-0087 | G5 | cboCategory / Category | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboCategory / Category | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0098-0088 | G5 | cboDayWeek / Day Type / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDayWeek / Day Type / Day Week | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0098-0089 | G5 | txtInpuValue / Input Value / Inpu Value | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtInpuValue / Input Value / Inpu Value | 있음(FE 소스) | 1 (D00-1-036) |
| WK-SCP0098-0090 | H6 | MEASURE_UI | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL MEASURE_UI | 있음(SHEET_COLUMNS) | 1 (D00-1-007) |
| WK-SCP0098-0091 | H6 | SCP0098_CopySelect_Popup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SCP0098_CopySelect_Popup | 판단불가(대상 단위 POPUP) | 3 (MODAL:CopySelectModal SCP0098_CopySelect) |
| WK-SCP0098-0092 | H6 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnInput | 없음 | 1 (D00-1-003) |
| WK-SCP0098-0093 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (MODAL:ShowDialog) |
| WK-SCP0098-0094 | H6 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (MODAL:ShowDialog) |

## W6 검증 실행 (131)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0098-0095 | J2 | SCP0098 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0098 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 259 (D00-1-008 D00-1-029 D00-1-040 D00-2-001 ) |
| WK-SCP0098-0096 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0098_CAPAReprotSmall.InitControls) |
| WK-SCP0098-0097 | C1 | cboCategory / Category | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboCategory / Category · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0098_CAPAReprotSmall.Form_Load:19) |
| WK-SCP0098-0098 | C1 | cboDayWeek / Day Type / Day Week | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDayWeek / Day Type / Day Week · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0098_CAPAReprotSmall.Form_Load:20) |
| WK-SCP0098-0099 | C1 | cboDivision / Div  / Division / Div | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Div  / Division / Div · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.InitControls) |
| WK-SCP0098-0100 | C1 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0098_CAPAReprotSmall.SetChangedCo) |
| WK-SCP0098-0101 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-008 ACT:SCP0098_CAPAReprotSmall.Se) |
| WK-SCP0098-0102 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0103 | C2 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0104 | C2 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0105 | C2 | MEASURE_UI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — MEASURE_UI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0106 | C2 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0107 | C2 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0108 | C2 | PRODUCT_READY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PRODUCT_READY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 38 (D00-2-009 D00-3-030 D00-3-041 R1 PRODUCT) |
| WK-SCP0098-0109 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0110 | C3 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0111 | C3 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0112 | C3 | MEASURE_UI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE_UI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 14 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0113 | C3 | OEE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OEE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0114 | C3 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0115 | C3 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0116 | C3 | PRODUCT_READY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PRODUCT_READY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 46 (D00-2-009 D00-3-030 D00-3-041 R1 PRODUCT) |
| WK-SCP0098-0117 | C4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-008) |
| WK-SCP0098-0118 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0119 | C6 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0120 | C6 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0121 | C6 | MEASURE_UI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — MEASURE_UI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0122 | C6 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0123 | C6 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0124 | C6 | PRODUCT_READY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PRODUCT_READY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 38 (D00-2-009 D00-3-030 D00-3-041 R1 PRODUCT) |
| WK-SCP0098-0125 | G3 | SCP0098 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0098 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 6 (D00-1-040 COMMON:UC-03 COMMON:UC-04 COMM) |
| WK-SCP0098-0126 | K-SA | SCP0098 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0098 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (D00-1-040 usrConditionPanel1(HidePanel) ) |
| WK-SCP0098-0127 | K4 | SCP0098 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0098 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 230 (COMMON:UC-03 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0098-0128 | F1 | SCP0098 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0098 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 581 (D00-2-001 D00-3-034 D00-4d-005 D00-4d-00) |
| WK-SCP0098-0129 | F3 | SCP0098 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0098 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 2 (D00-2-012 D00-4d-010) |
| WK-SCP0098-0130 | F5 | SCP0098 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0098 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 3 (D00-2-001 D00-3-034 R6 chkDetail D_↔M_ 토) |
| WK-SCP0098-0131 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 2 (ACT:SCP0098_CAPAReprotSmall.GetDayRange:) |
| WK-SCP0098-0132 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 536 (SCP0009_GET_SHEET_CALENDAR_3SPAN / SCM_S) |
| WK-SCP0098-0133 | F4 | PKG_SCP0098.P_GET_CAPA_MOBILITYIT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0098.P_GET_CAPA_MOBILITYIT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 1 (P_GET_CAPA_MOBILITYIT) |
| WK-SCP0098-0134 | F4 | PKG_SCP0098.P_SAVE_SCP_CAPA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0098.P_SAVE_SCP_CAPA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (P_SAVE_SCP_CAPA) |
| WK-SCP0098-0135 | F4 | PKG_SCP0098.P_SAVE_SCP_CAPA_PRODUCT_RATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0098.P_SAVE_SCP_CAPA_PRODUCT_RATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 1 (P_SAVE_SCP_CAPA_PRODUCT_RATE) |
| WK-SCP0098-0136 | F4 | PKG_SCP0098.P_SAVE_SCP_CAPA_WORK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0098.P_SAVE_SCP_CAPA_WORK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 1 (P_SAVE_SCP_CAPA_WORK) |
| WK-SCP0098-0137 | F4 | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_SCP_DAILY_PLAN_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 2 (ACT:SCP0098_CAPAReprotSmall.GetLastRange) |
| WK-SCP0098-0138 | F4 | SCP0098_SAVE_SCP_CAPA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0098_SAVE_SCP_CAPA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 482 (ACT:SCP0098_CAPAReprotSmall.SaveButton A) |
| WK-SCP0098-0139 | F4 | SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 510 (ACT:SCP0098_CAPAReprotSmall.SaveButton A) |
| WK-SCP0098-0140 | F4 | SCP0098_SAVE_SCP_CAPA_WORK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0098_SAVE_SCP_CAPA_WORK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 483 (ACT:SCP0098_CAPAReprotSmall.SaveButton A) |
| WK-SCP0098-0141 | A5 | MEASURE_UI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MEASURE_UI · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (D00-1-007 ACT:SCP0098_CAPAReprotSmall.Se) |
| WK-SCP0098-0142 | A5 | OEE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OEE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0143 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0098_CAPAReprotSmall.DefineProper) |
| WK-SCP0098-0144 | G4 | cboCategory / Category | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboCategory / Category · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-007 ACT:SCP0098_CAPAReprotSmall.Fo) |
| WK-SCP0098-0145 | G4 | cboDayWeek / Day Type / Day Week | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDayWeek / Day Type / Day Week · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-008 ACT:SCP0098_CAPAReprotSmall.Fo) |
| WK-SCP0098-0146 | G4 | cboDivision / Div  / Division / Div | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Div  / Division / Div · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 9 (D00-1-009 ACT:SCP0098_CAPAReprotSmall.Fo) |
| WK-SCP0098-0147 | G4 | chkDetail / Detail | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkDetail / Detail · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0098_CAPAReprotSmall.InitEvent AC) |
| WK-SCP0098-0148 | G4 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbLine / Line · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-011) |
| WK-SCP0098-0149 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-012 ACT:SCP0098_CAPAReprotSmall.In) |
| WK-SCP0098-0150 | G4 | txtInpuValue / Input Value / Inpu Value | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtInpuValue / Input Value / Inpu Value · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-036) |
| WK-SCP0098-0151 | G4 | txtItemId / Material / Item Id / Model/N | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Material / Item Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-037) |
| WK-SCP0098-0152 | H2 | MEASURE_UI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE_UI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (D00-1-007 ACT:SCP0098_CAPAReprotSmall.Se) |
| WK-SCP0098-0153 | H2 | OEE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OEE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0154 | H4 | SCP0098 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0098 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SCP0098_CAPAReprotSmall.SpdMain_TopC) |
| WK-SCP0098-0155 | H5 | MEASURE_UI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEASURE_UI · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (D00-1-007 ACT:SCP0098_CAPAReprotSmall.Se) |
| WK-SCP0098-0156 | H5 | OEE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OEE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0157 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 18 (ACT:SCP0098_CAPAReprotSmall.SetLayout:32) |
| WK-SCP0098-0158 | H5 | cboCategory / Category | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboCategory / Category · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (D00-1-007) |
| WK-SCP0098-0159 | SC1 | SCP0098 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0098 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 9 (D00-1-007 D00-1-008 D00-1-009 D00-1-011 ) |
| WK-SCP0098-0160 | D1 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (D00-3-015 ACT:SCP0098_CAPAReprotSmall.Ed) |
| WK-SCP0098-0161 | D1 | MEASURE_UI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEASURE_UI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.EditButton A) |
| WK-SCP0098-0162 | D1 | OEE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OEE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0098_CAPAReprotSmall.EditButton A) |
| WK-SCP0098-0163 | D1 | PRODUCT_READY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRODUCT_READY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (D00-3-016 R3 measure별 편집영역(LockRange 13)) |
| WK-SCP0098-0164 | D3 | MEASURE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEASURE_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (D00-3-015 ACT:SCP0098_CAPAReprotSmall.Ed) |
| WK-SCP0098-0165 | D3 | MEASURE_UI | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEASURE_UI · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.EditButton A) |
| WK-SCP0098-0166 | D3 | OEE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OEE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0098_CAPAReprotSmall.EditButton A) |
| WK-SCP0098-0167 | D3 | PRODUCT_READY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRODUCT_READY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (D00-3-016 R3 measure별 편집영역(LockRange 13)) |
| WK-SCP0098-0168 | D4 | PRODUCT_READY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PRODUCT_READY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (D00-3-041 R1 PRODUCT_READY Auto-Sync) |
| WK-SCP0098-0169 | D5 | MEASURE_UI | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MEASURE_UI · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0098_CAPAReprotSmall.SetSpreadCol) |
| WK-SCP0098-0170 | D5 | OEE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — OEE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0171 | D6 | SCP0098 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0098 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (COMMON:UC-03) |
| WK-SCP0098-0172 | E4 | LINE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LINE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0173 | E4 | MEASURE_UI | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE_UI · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 12 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0174 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (#1 MSG00012 저장확인) |
| WK-SCP0098-0175 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0098_CAPAReprotSmall.btnCopyData_) |
| WK-SCP0098-0176 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0098_CAPAReprotSmall.SaveData_CAP) |
| WK-SCP0098-0177 | E4 | MSG00007 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00007 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0098_CAPAReprotSmall.BtnMeasure_C) |
| WK-SCP0098-0178 | E4 | MSG00012 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00012 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (D00-4d-006 SaveButton(MSG00012 확인 → save) |
| WK-SCP0098-0179 | E4 | MSG00134 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00134 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-4d-017 ACT:SCP0098_CAPAReprotSmall.b) |
| WK-SCP0098-0180 | E4 | MSG00135 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00135 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0098_CAPAReprotSmall.btnInput_Cli) |
| WK-SCP0098-0181 | E4 | MSG00199 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00199 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (#2 MSG00199 작업중(save_status RUN) ACT:SCP) |
| WK-SCP0098-0182 | E4 | OEE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OEE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0183 | E4 | PRODUCT_READY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PRODUCT_READY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 9 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0184 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 25 (ACT:SCP0098_CAPAReprotSmall.SetLayout AC) |
| WK-SCP0098-0185 | E4 | cboDayWeek / Day Type / Day Week | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDayWeek / Day Type / Day Week · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도  |  | 1 (D00-1-008) |
| WK-SCP0098-0186 | E4 | cboDivision / Div  / Division / Div | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Div  / Division / Div · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 9 (ACT:SCP0098_CAPAReprotSmall.SetChangedCo) |
| WK-SCP0098-0187 | E4 | chkDetail / Detail | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkDetail / Detail · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0098_CAPAReprotSmall.SetLayout AC) |
| WK-SCP0098-0188 | E4 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0098_CAPAReprotSmall.SetChangedCo) |
| WK-SCP0098-0189 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 3 (ACT:SCP0098_CAPAReprotSmall.SetChangedCo) |
| WK-SCP0098-0190 | A10 | SCP0098 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0098 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 116 (ACT:SCP0098_CAPAReprotSmall.DefineProper) |
| WK-SCP0098-0191 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 77 (SCP0009_GET_SHEET_CALENDAR_3SPAN / SCM_S) |
| WK-SCP0098-0192 | A6 | PKG_SCP0098.P_GET_CAPA_MOBILITYIT | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0098.P_GET_CAPA_MOBILITYIT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trac |  | 1 (P_GET_CAPA_MOBILITYIT) |
| WK-SCP0098-0193 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0098_CAPAReprotSmall.FindData_Mai) |
| WK-SCP0098-0194 | G1 | cboCategory / Category | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboCategory / Category · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-007) |
| WK-SCP0098-0195 | G1 | cboDayWeek / Day Type / Day Week | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDayWeek / Day Type / Day Week · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-008) |
| WK-SCP0098-0196 | G1 | cboDivision / Div  / Division / Div | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Div  / Division / Div · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-009 ACT:SCP0098_CAPAReprotSmall.Fi) |
| WK-SCP0098-0197 | G1 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbLine / Line · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (D00-1-011 ACT:SCP0098_CAPAReprotSmall.Fi) |
| WK-SCP0098-0198 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (D00-1-012 D00-2-008 ACT:SCP0098_CAPARepr) |
| WK-SCP0098-0199 | G1 | txtInpuValue / Input Value / Inpu Value | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtInpuValue / Input Value / Inpu Value · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-036) |
| WK-SCP0098-0200 | G1 | txtItemId / Material / Item Id / Model/N | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Material / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-037 ACT:SCP0098_CAPAReprotSmall.Fi) |
| WK-SCP0098-0201 | G1 | txtNickName / Nick Name | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtNickName / Nick Name · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0098_CAPAReprotSmall.FindData_Mai) |
| WK-SCP0098-0202 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SCP0098_CAPAReprotSmall.DefineProper) |
| WK-SCP0098-0203 | G6 | cboCategory / Category | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboCategory / Category · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-007 ACT:SCP0098_CAPAReprotSmall.Fo) |
| WK-SCP0098-0204 | G6 | cboDayWeek / Day Type / Day Week | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDayWeek / Day Type / Day Week · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-008 ACT:SCP0098_CAPAReprotSmall.Fo) |
| WK-SCP0098-0205 | G6 | cboDivision / Div  / Division / Div | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Div  / Division / Div · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 9 (D00-1-009 ACT:SCP0098_CAPAReprotSmall.Fo) |
| WK-SCP0098-0206 | G6 | chkDetail / Detail | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkDetail / Detail · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0098_CAPAReprotSmall.InitEvent AC) |
| WK-SCP0098-0207 | G6 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-011) |
| WK-SCP0098-0208 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-012 ACT:SCP0098_CAPAReprotSmall.In) |
| WK-SCP0098-0209 | G6 | txtInpuValue / Input Value / Inpu Value | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtInpuValue / Input Value / Inpu Value · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-036) |
| WK-SCP0098-0210 | G6 | txtItemId / Material / Item Id / Model/N | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Material / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-037) |
| WK-SCP0098-0211 | X-REOPEN | SCP0098 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0098 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 22 (ACT:SCP0098_CAPAReprotSmall.Dispose ACT:) |
| WK-SCP0098-0212 | H6 | cboCategory / Category | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboCategory / Category · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (D00-1-007) |
| WK-SCP0098-0213 | H6 | cboDayWeek / Day Type / Day Week | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDayWeek / Day Type / Day Week · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (D00-1-008) |
| WK-SCP0098-0214 | H6 | txtInpuValue / Input Value / Inpu Value | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtInpuValue / Input Value / Inpu Value · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (D00-1-036) |
| WK-SCP0098-0215 | M3 | SCP0098_CopySelect_Popup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SCP0098_CopySelect_Popup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 7 (ACT:SCP0098_CopySelect_Popup..ctor ACT:S) |
| WK-SCP0098-0216 | M3 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (MODAL:ShowDialog) |
| WK-SCP0098-0217 | M3 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (MODAL:ShowDialog) |
| WK-SCP0098-0218 | M4 | MEASURE_UI | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MEASURE_UI · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-1-007) |
| WK-SCP0098-0219 | M4 | SCP0098_CopySelect_Popup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCP0098_CopySelect_Popup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (MODAL:CopySelectModal SCP0098_CopySelect) |
| WK-SCP0098-0220 | M4 | btnInput | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnInput · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-1-003) |
| WK-SCP0098-0221 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (MODAL:ShowDialog) |
| WK-SCP0098-0222 | M4 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (MODAL:ShowDialog) |
| WK-SCP0098-0223 | M4 | cboCategory / Category | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboCategory / Category · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-1-007) |
| WK-SCP0098-0224 | M4 | cboDayWeek / Day Type / Day Week | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDayWeek / Day Type / Day Week · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-1-008) |
| WK-SCP0098-0225 | M4 | txtInpuValue / Input Value / Inpu Value | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtInpuValue / Input Value / Inpu Value · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-1-036) |

## W7 기대값 확정 (372)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0098-0226 | C2 | #35 [Y,N]만 입력 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — #35 [Y,N]만 입력: 행 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (#35 [Y,N]만 입력) |
| WK-SCP0098-0227 | C2 | D00-2-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-2-012: 행 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-012) |
| WK-SCP0098-0228 | C2 | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-3-029: 행 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-029) |
| WK-SCP0098-0229 | C2 | D00-3-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-3-031: 행 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-031) |
| WK-SCP0098-0230 | C2 | D00-3-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-3-042: 행 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-042) |
| WK-SCP0098-0231 | C2 | D00-4d-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-009: 행 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-009) |
| WK-SCP0098-0232 | C2 | D00-4d-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-010: 행 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-010) |
| WK-SCP0098-0233 | C2 | D00-4d-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-011: 행 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-011) |
| WK-SCP0098-0234 | C2 | D00-4d-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-013: 행 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-013) |
| WK-SCP0098-0235 | C2 | R1 NO_WORK Y/N | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — R1 NO_WORK Y/N: 행 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R1 NO_WORK Y/N) |
| WK-SCP0098-0236 | C2 | SCP0098_CAPAReprotSmall.CboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0098_CAPAReprotSmall.CboDivision_SelectedIndexC: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0098_CAPAReprotSmall.CboDivision_) |
| WK-SCP0098-0237 | C2 | SCP0098_CAPAReprotSmall.ChkDetail_Checke | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0098_CAPAReprotSmall.ChkDetail_CheckedChanged: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.ChkDetail_Ch) |
| WK-SCP0098-0238 | C2 | SCP0098_CAPAReprotSmall.SpdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0098_CAPAReprotSmall.SpdMain_Changed: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 45 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0239 | C2 | SCP0098_CAPAReprotSmall.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0098_CAPAReprotSmall.cboBucketType_SelectedInde: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.cboBucketTyp) |
| WK-SCP0098-0240 | C2 | SpdMain_Changed 가드 #9~13(재진입/Action컬럼/ds | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SpdMain_Changed 가드 #9~13(재진입/Action컬럼/ds null): 행 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_Changed 가드 #9~13(재진입/Action컬럼/ds) |
| WK-SCP0098-0241 | C3 | #35 [Y,N]만 입력 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — #35 [Y,N]만 입력: 행 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (#35 [Y,N]만 입력) |
| WK-SCP0098-0242 | C3 | D00-2-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-012: 행 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-012) |
| WK-SCP0098-0243 | C3 | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-029: 행 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-029) |
| WK-SCP0098-0244 | C3 | D00-3-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-031: 행 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-031) |
| WK-SCP0098-0245 | C3 | D00-3-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-042: 행 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-042) |
| WK-SCP0098-0246 | C3 | D00-4d-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-009: 행 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-009) |
| WK-SCP0098-0247 | C3 | D00-4d-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-010: 행 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-010) |
| WK-SCP0098-0248 | C3 | D00-4d-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-011: 행 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-011) |
| WK-SCP0098-0249 | C3 | D00-4d-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-013: 행 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-013) |
| WK-SCP0098-0250 | C3 | R1 NO_WORK Y/N | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — R1 NO_WORK Y/N: 행 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R1 NO_WORK Y/N) |
| WK-SCP0098-0251 | C3 | SCP0098_CAPAReprotSmall.CboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.CboDivision_SelectedIndexC: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0098_CAPAReprotSmall.CboDivision_) |
| WK-SCP0098-0252 | C3 | SCP0098_CAPAReprotSmall.ChkDetail_Checke | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.ChkDetail_CheckedChanged: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.ChkDetail_Ch) |
| WK-SCP0098-0253 | C3 | SCP0098_CAPAReprotSmall.SetCellFormat | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.SetCellFormat: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 42 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0254 | C3 | SCP0098_CAPAReprotSmall.SetCellFormatNeo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.SetCellFormatNeo: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 121 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0255 | C3 | SCP0098_CAPAReprotSmall.SetCellFormat_09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.SetCellFormat_0909: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 125 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0256 | C3 | SCP0098_CAPAReprotSmall.SetCellFormat_LI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.SetCellFormat_LINE: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 131 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0257 | C3 | SCP0098_CAPAReprotSmall.SetChangedContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.SetChangedControl: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0098_CAPAReprotSmall.SetChangedCo) |
| WK-SCP0098-0258 | C3 | SCP0098_CAPAReprotSmall.SetLayout | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.SetLayout: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.SetLayout:31) |
| WK-SCP0098-0259 | C3 | SCP0098_CAPAReprotSmall.SetReTextCellTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.SetReTextCellType: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.SetReTextCel) |
| WK-SCP0098-0260 | C3 | SCP0098_CAPAReprotSmall.SetSaveStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.SetSaveStatus: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.SetSaveStatu) |
| WK-SCP0098-0261 | C3 | SCP0098_CAPAReprotSmall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0098_CAPAReprotSmall.SetSpreadCol) |
| WK-SCP0098-0262 | C3 | SCP0098_CAPAReprotSmall.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadInit: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0263 | C3 | SCP0098_CAPAReprotSmall.SpdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.SpdMain_Changed: 진입점 집계 — C3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 45 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0264 | C3 | SCP0098_CAPAReprotSmall.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0098_CAPAReprotSmall.cboBucketType_SelectedInde: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.cboBucketTyp) |
| WK-SCP0098-0265 | C3 | SpdMain_Changed 가드 #9~13(재진입/Action컬럼/ds | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SpdMain_Changed 가드 #9~13(재진입/Action컬럼/ds null): 행 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_Changed 가드 #9~13(재진입/Action컬럼/ds) |
| WK-SCP0098-0266 | C6 | #35 [Y,N]만 입력 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — #35 [Y,N]만 입력: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (#35 [Y,N]만 입력) |
| WK-SCP0098-0267 | C6 | D00-2-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-2-012: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-012) |
| WK-SCP0098-0268 | C6 | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-3-029: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-029) |
| WK-SCP0098-0269 | C6 | D00-3-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-3-031: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-031) |
| WK-SCP0098-0270 | C6 | D00-3-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-3-042: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-042) |
| WK-SCP0098-0271 | C6 | D00-4d-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-009: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-009) |
| WK-SCP0098-0272 | C6 | D00-4d-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-010: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-010) |
| WK-SCP0098-0273 | C6 | D00-4d-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-011: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-011) |
| WK-SCP0098-0274 | C6 | D00-4d-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-013: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-013) |
| WK-SCP0098-0275 | C6 | R1 NO_WORK Y/N | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — R1 NO_WORK Y/N: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R1 NO_WORK Y/N) |
| WK-SCP0098-0276 | C6 | SCP0098_CAPAReprotSmall.CboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0098_CAPAReprotSmall.CboDivision_SelectedIndexC: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0098_CAPAReprotSmall.CboDivision_) |
| WK-SCP0098-0277 | C6 | SCP0098_CAPAReprotSmall.ChkDetail_Checke | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0098_CAPAReprotSmall.ChkDetail_CheckedChanged: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.ChkDetail_Ch) |
| WK-SCP0098-0278 | C6 | SCP0098_CAPAReprotSmall.SpdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0098_CAPAReprotSmall.SpdMain_Changed: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 45 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0279 | C6 | SCP0098_CAPAReprotSmall.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0098_CAPAReprotSmall.cboBucketType_SelectedInde: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.cboBucketTyp) |
| WK-SCP0098-0280 | C6 | SpdMain_Changed 가드 #9~13(재진입/Action컬럼/ds | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SpdMain_Changed 가드 #9~13(재진입/Action컬럼/ds null): 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_Changed 가드 #9~13(재진입/Action컬럼/ds) |
| WK-SCP0098-0281 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0098-0282 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0098-0283 | B3 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 1: 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0098-0284 | B3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 2: 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0098-0285 | B3 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-001: 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0098-0286 | B3 | D00-4b-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-007: 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-007) |
| WK-SCP0098-0287 | B3 | D00-4b-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-008: 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-008) |
| WK-SCP0098-0288 | B3 | D00-4b-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-011: 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-011) |
| WK-SCP0098-0289 | B3 | SCP0098_CAPAReprotSmall.GetDayOfWeek | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0098_CAPAReprotSmall.GetDayOfWeek: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0098_CAPAReprotSmall.GetDayOfWeek) |
| WK-SCP0098-0290 | B3 | SCP0098_CAPAReprotSmall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0098_CAPAReprotSmall.GetDayRange: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 25 (ACT:SCP0098_CAPAReprotSmall.GetDayRange:) |
| WK-SCP0098-0291 | B3 | SCP0098_CAPAReprotSmall.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0098_CAPAReprotSmall.GetLastRange: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0098_CAPAReprotSmall.GetLastRange) |
| WK-SCP0098-0292 | B3 | SCP0098_CAPAReprotSmall.GetLastWeek | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0098_CAPAReprotSmall.GetLastWeek: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0098_CAPAReprotSmall.GetLastWeek:) |
| WK-SCP0098-0293 | B3 | SCP0098_CAPAReprotSmall.GetLastYYYYMM | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0098_CAPAReprotSmall.GetLastYYYYMM: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0098_CAPAReprotSmall.GetLastYYYYM) |
| WK-SCP0098-0294 | B3 | SCP0098_CAPAReprotSmall.GetNextDayColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0098_CAPAReprotSmall.GetNextDayColumn: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0098_CAPAReprotSmall.GetNextDayCo) |
| WK-SCP0098-0295 | B3 | SCP0098_CAPAReprotSmall.GetNowMonth | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0098_CAPAReprotSmall.GetNowMonth: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.GetNowMonth:) |
| WK-SCP0098-0296 | B3 | SCP0098_CAPAReprotSmall.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0098_CAPAReprotSmall.GetSpdTitle: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0098_CAPAReprotSmall.GetSpdTitle:) |
| WK-SCP0098-0297 | B3 | SCP0098_CAPAReprotSmall.GetSpdTitle2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0098_CAPAReprotSmall.GetSpdTitle2: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0098_CAPAReprotSmall.GetSpdTitle2) |
| WK-SCP0098-0298 | B4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 1: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0098-0299 | B4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 2: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0098-0300 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0098-0301 | B4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-001: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0098-0302 | B4 | D00-4b-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-007: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-007) |
| WK-SCP0098-0303 | B4 | D00-4b-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-008: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-008) |
| WK-SCP0098-0304 | B4 | D00-4b-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-011: 행 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-011) |
| WK-SCP0098-0305 | B4 | SCP0098_CAPAReprotSmall.GetDayOfWeek | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0098_CAPAReprotSmall.GetDayOfWeek: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0098_CAPAReprotSmall.GetDayOfWeek) |
| WK-SCP0098-0306 | B4 | SCP0098_CAPAReprotSmall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0098_CAPAReprotSmall.GetDayRange: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 25 (ACT:SCP0098_CAPAReprotSmall.GetDayRange:) |
| WK-SCP0098-0307 | B4 | SCP0098_CAPAReprotSmall.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0098_CAPAReprotSmall.GetLastRange: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0098_CAPAReprotSmall.GetLastRange) |
| WK-SCP0098-0308 | B4 | SCP0098_CAPAReprotSmall.GetLastWeek | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0098_CAPAReprotSmall.GetLastWeek: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0098_CAPAReprotSmall.GetLastWeek:) |
| WK-SCP0098-0309 | B4 | SCP0098_CAPAReprotSmall.GetLastYYYYMM | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0098_CAPAReprotSmall.GetLastYYYYMM: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0098_CAPAReprotSmall.GetLastYYYYM) |
| WK-SCP0098-0310 | B4 | SCP0098_CAPAReprotSmall.GetNextDayColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0098_CAPAReprotSmall.GetNextDayColumn: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0098_CAPAReprotSmall.GetNextDayCo) |
| WK-SCP0098-0311 | B4 | SCP0098_CAPAReprotSmall.GetNowMonth | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0098_CAPAReprotSmall.GetNowMonth: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.GetNowMonth:) |
| WK-SCP0098-0312 | B4 | SCP0098_CAPAReprotSmall.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0098_CAPAReprotSmall.GetSpdTitle: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0098_CAPAReprotSmall.GetSpdTitle:) |
| WK-SCP0098-0313 | B4 | SCP0098_CAPAReprotSmall.GetSpdTitle2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0098_CAPAReprotSmall.GetSpdTitle2: 진입점 집계 — B4 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0098_CAPAReprotSmall.GetSpdTitle2) |
| WK-SCP0098-0314 | DB-SYN | #16/#23 CAPA_WORK>10000 저장불가 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — #16/#23 CAPA_WORK>10000 저장불가: 행 집계 — DB-SYN 10요소: PASS:6 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (#16/#23 CAPA_WORK>10000 저장불가) |
| WK-SCP0098-0315 | DB-SYN | SCP0098_CAPAReprotSmall.GetSpdTitle2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0098_CAPAReprotSmall.GetSpdTitle2: 진입점 집계 — DB-SYN 10요소: PASS:6 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.GetSpdTitle2) |
| WK-SCP0098-0316 | DB-SYN | SCP0098_CAPAReprotSmall.SCM_SYS_LOG_BATC | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0098_CAPAReprotSmall.SCM_SYS_LOG_BATCH: 진입점 집계 — DB-SYN 10요소: PASS:6 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.SCM_SYS_LOG_) |
| WK-SCP0098-0317 | DB-SYN | SaveButton(MSG00012 확인 → save_status 가드  | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SaveButton(MSG00012 확인 → save_status 가드 → SaveData: 행 집계 — DB-SYN 10요소: PASS:6 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton(MSG00012 확인 → save_status 가드 ) |
| WK-SCP0098-0318 | F4 | #16/#23 CAPA_WORK>10000 저장불가 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — #16/#23 CAPA_WORK>10000 저장불가: 행 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (#16/#23 CAPA_WORK>10000 저장불가) |
| WK-SCP0098-0319 | F4 | SCP0098_CAPAReprotSmall.GetSpdTitle2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0098_CAPAReprotSmall.GetSpdTitle2: 진입점 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.GetSpdTitle2) |
| WK-SCP0098-0320 | F4 | SCP0098_CAPAReprotSmall.SCM_SYS_LOG_BATC | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0098_CAPAReprotSmall.SCM_SYS_LOG_BATCH: 진입점 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.SCM_SYS_LOG_) |
| WK-SCP0098-0321 | F4 | SaveButton(MSG00012 확인 → save_status 가드  | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SaveButton(MSG00012 확인 → save_status 가드 → SaveData: 행 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton(MSG00012 확인 → save_status 가드 ) |
| WK-SCP0098-0322 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0098-0323 | A5 | D00-1-034 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-034: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-034) |
| WK-SCP0098-0324 | A5 | D00-3-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-023: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-023) |
| WK-SCP0098-0325 | A5 | D00-3-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-025: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-025) |
| WK-SCP0098-0326 | A5 | D00-3-035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-035: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-035) |
| WK-SCP0098-0327 | A5 | D00-3-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-036: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-036) |
| WK-SCP0098-0328 | A5 | D00-3-037 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-037: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-037) |
| WK-SCP0098-0329 | A5 | D00-3-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-038: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-038) |
| WK-SCP0098-0330 | A5 | D00-3-039 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-039: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-039) |
| WK-SCP0098-0331 | A5 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4d-008: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-008) |
| WK-SCP0098-0332 | A5 | D00-4d-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4d-014: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-014) |
| WK-SCP0098-0333 | A5 | R4 초기 잠금·좌측 세로머지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R4 초기 잠금·좌측 세로머지: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R4 초기 잠금·좌측 세로머지) |
| WK-SCP0098-0334 | A5 | R8 spdInfo 머지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R8 spdInfo 머지: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R8 spdInfo 머지) |
| WK-SCP0098-0335 | A5 | R9 시트전환/좌표 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R9 시트전환/좌표: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R9 시트전환/좌표) |
| WK-SCP0098-0336 | A5 | SCP0098_CAPAReprotSmall.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0098_CAPAReprotSmall.CreateSpread: 진입점 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0098_CAPAReprotSmall.CreateSpread) |
| WK-SCP0098-0337 | A5 | SCP0098_CAPAReprotSmall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadColumn: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0098_CAPAReprotSmall.SetSpreadCol) |
| WK-SCP0098-0338 | A5 | SCP0098_CAPAReprotSmall.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadInit: 진입점 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0339 | A5 | btnInput_Click 가드 #14~27(0열숨김/CanModelCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — btnInput_Click 가드 #14~27(0열숨김/CanModelChange/Selec: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (btnInput_Click 가드 #14~27(0열숨김/CanModelCh) |
| WK-SCP0098-0340 | A5 | spdMain(FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain(FpSpread): 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread)) |
| WK-SCP0098-0341 | G4 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-029: 행 집계 — G4 11요소: NOT_RUN:9 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-029) |
| WK-SCP0098-0342 | G4 | D00-1-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-040: 행 집계 — G4 11요소: NOT_RUN:9 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-040) |
| WK-SCP0098-0343 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0098-0344 | H2 | D00-1-034 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-034: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-034) |
| WK-SCP0098-0345 | H2 | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-003: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-003) |
| WK-SCP0098-0346 | H2 | D00-3-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-023: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-023) |
| WK-SCP0098-0347 | H2 | D00-3-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-025: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-025) |
| WK-SCP0098-0348 | H2 | D00-3-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-028: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-028) |
| WK-SCP0098-0349 | H2 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4d-008: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-008) |
| WK-SCP0098-0350 | H2 | R4 초기 잠금·좌측 세로머지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R4 초기 잠금·좌측 세로머지: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R4 초기 잠금·좌측 세로머지) |
| WK-SCP0098-0351 | H2 | R5 셀 포맷·색(NO_WORK Blue/DAILY_CAPA 정수콤마) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R5 셀 포맷·색(NO_WORK Blue/DAILY_CAPA 정수콤마): 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R5 셀 포맷·색(NO_WORK Blue/DAILY_CAPA 정수콤마)) |
| WK-SCP0098-0352 | H2 | R7 3단 헤더 span + 주말색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R7 3단 헤더 span + 주말색: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R7 3단 헤더 span + 주말색) |
| WK-SCP0098-0353 | H2 | R8 spdInfo 머지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R8 spdInfo 머지: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R8 spdInfo 머지) |
| WK-SCP0098-0354 | H2 | R9 시트전환/좌표 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R9 시트전환/좌표: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R9 시트전환/좌표) |
| WK-SCP0098-0355 | H2 | SCP0098_CAPAReprotSmall.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0098_CAPAReprotSmall.CreateSpread: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0098_CAPAReprotSmall.CreateSpread) |
| WK-SCP0098-0356 | H2 | SCP0098_CAPAReprotSmall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadColumn: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0098_CAPAReprotSmall.SetSpreadCol) |
| WK-SCP0098-0357 | H2 | SCP0098_CAPAReprotSmall.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadInit: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0358 | H2 | spdMain(FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain(FpSpread): 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread)) |
| WK-SCP0098-0359 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0098-0360 | H5 | D00-1-034 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-034: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-034) |
| WK-SCP0098-0361 | H5 | D00-3-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-023: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-023) |
| WK-SCP0098-0362 | H5 | D00-3-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-025: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-025) |
| WK-SCP0098-0363 | H5 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4d-008: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-008) |
| WK-SCP0098-0364 | H5 | R4 초기 잠금·좌측 세로머지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R4 초기 잠금·좌측 세로머지: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R4 초기 잠금·좌측 세로머지) |
| WK-SCP0098-0365 | H5 | R8 spdInfo 머지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R8 spdInfo 머지: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R8 spdInfo 머지) |
| WK-SCP0098-0366 | H5 | R9 시트전환/좌표 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R9 시트전환/좌표: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R9 시트전환/좌표) |
| WK-SCP0098-0367 | H5 | SCP0098_CAPAReprotSmall.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0098_CAPAReprotSmall.CreateSpread: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0098_CAPAReprotSmall.CreateSpread) |
| WK-SCP0098-0368 | H5 | SCP0098_CAPAReprotSmall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadColumn: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0098_CAPAReprotSmall.SetSpreadCol) |
| WK-SCP0098-0369 | H5 | SCP0098_CAPAReprotSmall.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadInit: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0370 | H5 | spdMain(FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain(FpSpread): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread)) |
| WK-SCP0098-0371 | I1 | SCP0098 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | I1 기대값 확정 — SCP0098 화면: 게이트 I18N1 다국어 미적용 — 화면에 '_Cannot save more than 10 / 게이트 I18N1 다국어 미적용 — 화면에 '_Select a measure row fir /  |  | 57 (D00-4d-006 D00-4d-017 SaveButton(MSG0001) |
| WK-SCP0098-0372 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) — 조회조건은 콤보(PlantSite/Line 다중선택 CSV)·날짜·Item 단일 — key-in |  | 1 (COMMON:UC-06) |
| WK-SCP0098-0373 | X-REASON | D00-1-006 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-006 §1 cboBucketType / UsrCombo  To-Be 문서(SCP0098) Bucket 조회조건 삭제 — `DEFAULT_BUCKET`(DAILY) 고정 제외 |  | 1 (D00-1-006) |
| WK-SCP0098-0374 | X-REASON | D00-1-010 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-010 §1 chkDetail / UsrCheckBox  To-Be 문서(SCP0098) Detail 체크박스 삭제 — Daily 는 일(`D_`) 컬럼만 표시하고 월(`M_`)은 숨김(A |  | 1 (D00-1-010) |
| WK-SCP0098-0375 | X-REASON | D00-1-032 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-032 §1 layoutControlItem9 / LayoutControlItem  To-Be 문서(SCP0098) Bucket 삭제 제외 |  | 1 (D00-1-032) |
| WK-SCP0098-0376 | X-REASON | D00-1-033 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-033 §1 lblBucket / LayoutControlItem  To-Be 문서(SCP0098) Bucket 삭제 제외 |  | 1 (D00-1-033) |
| WK-SCP0098-0377 | X-REASON | D00-1-038 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-038 §1 txtNickName / TextBox  To-Be 문서(SCP0098) Nick Name 조회조건 삭제 — Model/Nickname 에 통합, `nickName` 은 ''  |  | 1 (D00-1-038) |
| WK-SCP0098-0378 | X-REASON | D00-1-039 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-039 §1 usrButton1 / UsrButton — AS-IS x/y=0·tabIndex=0 용도불명 숨김 컨트롤(00_checklist §1 확인필요) — 실동작 없음, 미이식 제외 |  | 1 (D00-1-039) |
| WK-SCP0098-0379 | X-REASON | D00-2-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-005 §2 cboBucketType / SelectedIndexChanged  To-Be 문서(SCP0098) Bucket 삭제 제외 |  | 1 (D00-2-005) |
| WK-SCP0098-0380 | X-REASON | D00-2-006 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-006 §2 cboDivision / SelectedIndexChanged — Division '40' 고정·비활성(AS-IS cs L182~183) — cascade 재적재 이벤트 발생  |  | 1 (D00-2-006) |
| WK-SCP0098-0381 | X-REASON | D00-2-007 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-007 §2 chkDetail / CheckedChanged  To-Be 문서(SCP0098) Detail 삭제 제외 |  | 1 (D00-2-007) |
| WK-SCP0098-0382 | X-REASON | D00-2-010 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-010 §2 spdMain / CellClick — 셀 클릭 단독 파생 로직 없음(AS-IS 본문 NO-OP) — Wijmo 기본 선택 동작으로 등가 해당없음 |  | 1 (D00-2-010) |
| WK-SCP0098-0383 | X-REASON | D00-2-014 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-014 §2 spdMain / TopChange — FpSpread 가상스크롤 top 변경 배관 — Wijmo 네이티브 스크롤로 등가, 파생 로직 없음 해당없음 |  | 1 (D00-2-014) |
| WK-SCP0098-0384 | X-REASON | D00-3-001 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-001 §3 ChangeActiveSheet / 260 — FpSpread 다중시트 전환 — 단일 DataGrid 로 통합, 시트 전환 개념 부재 해당없음 |  | 1 (D00-3-001) |
| WK-SCP0098-0385 | X-REASON | D00-3-002 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-002 §3 SmartColMerge / 275 — spdInfo(정보시트) 컬럼 머지 — 별도 info 시트 미이식(§5 R8/C3, 04 기재) 제외 |  | 1 (D00-3-002) |
| WK-SCP0098-0386 | X-REASON | D00-3-026 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-026 §3 SetActiveCell / 766 — FpSpread 저장 후 선택셀 복원 배관 — Wijmo 편집 유지로 등가, 파생 로직 없음 해당없음 |  | 1 (D00-3-026) |
| WK-SCP0098-0387 | X-REASON | D00-3-027 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-027 §3 ShowCell / 767 — FpSpread 선택셀 스크롤 표시 배관 — Wijmo 네이티브 스크롤로 등가 해당없음 |  | 1 (D00-3-027) |
| WK-SCP0098-0388 | X-REASON | D00-4d-012 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-012 §4d SpdMain_Changed / strColName=="Action" — AS-IS Action(CRUD_TYPE) 컬럼 조기반환 가드 — TO-BE 는 Action 셀 편 |  | 1 (D00-4d-012) |
| WK-SCP0098-0389 | D1 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2-013: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-013) |
| WK-SCP0098-0390 | D1 | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-014: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-014) |
| WK-SCP0098-0391 | D1 | D00-3-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-017: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-017) |
| WK-SCP0098-0392 | D1 | D00-3-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-018: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-018) |
| WK-SCP0098-0393 | D1 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-019: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-SCP0098-0394 | D1 | D00-3-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-020: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-020) |
| WK-SCP0098-0395 | D1 | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-021: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-021) |
| WK-SCP0098-0396 | D1 | D00-3-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-022: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-022) |
| WK-SCP0098-0397 | D1 | D00-3-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-024: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-024) |
| WK-SCP0098-0398 | D1 | D00-3-044 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-044: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-044) |
| WK-SCP0098-0399 | D1 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-015: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SCP0098-0400 | D1 | EditButton(모드토글) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — EditButton(모드토글): 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (EditButton(모드토글)) |
| WK-SCP0098-0401 | D1 | R4 초기 잠금·좌측 세로머지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R4 초기 잠금·좌측 세로머지: 행 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R4 초기 잠금·좌측 세로머지) |
| WK-SCP0098-0402 | D1 | SCP0098_CAPAReprotSmall.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0098_CAPAReprotSmall.EditButton: 진입점 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 43 (ACT:SCP0098_CAPAReprotSmall.EditButton:4) |
| WK-SCP0098-0403 | D3 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2-013: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-013) |
| WK-SCP0098-0404 | D3 | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-014: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-014) |
| WK-SCP0098-0405 | D3 | D00-3-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-017: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-017) |
| WK-SCP0098-0406 | D3 | D00-3-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-018: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-018) |
| WK-SCP0098-0407 | D3 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-019: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-SCP0098-0408 | D3 | D00-3-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-020: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-020) |
| WK-SCP0098-0409 | D3 | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-021: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-021) |
| WK-SCP0098-0410 | D3 | D00-3-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-022: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-022) |
| WK-SCP0098-0411 | D3 | D00-3-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-024: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-024) |
| WK-SCP0098-0412 | D3 | D00-3-044 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-044: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-044) |
| WK-SCP0098-0413 | D3 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-015: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SCP0098-0414 | D3 | EditButton(모드토글) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — EditButton(모드토글): 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (EditButton(모드토글)) |
| WK-SCP0098-0415 | D3 | R4 초기 잠금·좌측 세로머지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R4 초기 잠금·좌측 세로머지: 행 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R4 초기 잠금·좌측 세로머지) |
| WK-SCP0098-0416 | D3 | SCP0098_CAPAReprotSmall.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0098_CAPAReprotSmall.EditButton: 진입점 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 43 (ACT:SCP0098_CAPAReprotSmall.EditButton:4) |
| WK-SCP0098-0417 | D4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 8: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0098-0418 | D4 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-03: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0098-0419 | D4 | D00-3-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-042: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-042) |
| WK-SCP0098-0420 | D4 | D00-3-047 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-047: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-047) |
| WK-SCP0098-0421 | D4 | D00-3-048 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-048: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-048) |
| WK-SCP0098-0422 | D4 | D00-3-049 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-049: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-049) |
| WK-SCP0098-0423 | D4 | D00-3-050 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-050: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-050) |
| WK-SCP0098-0424 | D4 | D00-3-053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-053: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-053) |
| WK-SCP0098-0425 | D4 | D00-3-054 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-054: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-054) |
| WK-SCP0098-0426 | D4 | D00-3-055 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-055: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-055) |
| WK-SCP0098-0427 | D4 | D00-3-056 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-056: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-056) |
| WK-SCP0098-0428 | D4 | D00-3-057 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-057: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-057) |
| WK-SCP0098-0429 | D4 | R1 NO_WORK Y/N | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — R1 NO_WORK Y/N: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R1 NO_WORK Y/N) |
| WK-SCP0098-0430 | D4 | R2/R10 btnInput bulk-fill | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — R2/R10 btnInput bulk-fill: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R2/R10 btnInput bulk-fill) |
| WK-SCP0098-0431 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0098-0432 | D5 | SCP0098_CAPAReprotSmall.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0098_CAPAReprotSmall.CreateSpread: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0098_CAPAReprotSmall.CreateSpread) |
| WK-SCP0098-0433 | D5 | SCP0098_CAPAReprotSmall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadColumn: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0098_CAPAReprotSmall.SetSpreadCol) |
| WK-SCP0098-0434 | D5 | SCP0098_CAPAReprotSmall.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadInit: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0435 | E4 | #16/#23 CAPA_WORK>10000 저장불가 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — #16/#23 CAPA_WORK>10000 저장불가: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (#16/#23 CAPA_WORK>10000 저장불가) |
| WK-SCP0098-0436 | E4 | #17/#18/#19 [생산준비율/Capa/CapaWork] 저장실패 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — #17/#18/#19 [생산준비율/Capa/CapaWork] 저장실패: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (#17/#18/#19 [생산준비율/Capa/CapaWork] 저장실패) |
| WK-SCP0098-0437 | E4 | #20 저장할 데이터 없음 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — #20 저장할 데이터 없음: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (#20 저장할 데이터 없음) |
| WK-SCP0098-0438 | E4 | #35 [Y,N]만 입력 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — #35 [Y,N]만 입력: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (#35 [Y,N]만 입력) |
| WK-SCP0098-0439 | E4 | #36/#37 복사 완료/실패 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — #36/#37 복사 완료/실패: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (#36/#37 복사 완료/실패) |
| WK-SCP0098-0440 | E4 | #41 비조업 Y/N | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — #41 비조업 Y/N: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (#41 비조업 Y/N) |
| WK-SCP0098-0441 | E4 | #42 가동율 0~100 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — #42 가동율 0~100: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (#42 가동율 0~100) |
| WK-SCP0098-0442 | E4 | #44 Ramp-up 0~1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — #44 Ramp-up 0~1: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (#44 Ramp-up 0~1) |
| WK-SCP0098-0443 | E4 | #46/#47 Daily Capa >0/요일불가 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — #46/#47 Daily Capa >0/요일불가: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (#46/#47 Daily Capa >0/요일불가) |
| WK-SCP0098-0444 | E4 | D00-3-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-3-040: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-040) |
| WK-SCP0098-0445 | E4 | D00-3-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-3-042: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-042) |
| WK-SCP0098-0446 | E4 | D00-4d-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-019: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019) |
| WK-SCP0098-0447 | E4 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-020: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0098-0448 | E4 | D00-4d-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-021: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-021) |
| WK-SCP0098-0449 | E4 | D00-4d-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-022: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-022) |
| WK-SCP0098-0450 | E4 | D00-4d-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-023: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-023) |
| WK-SCP0098-0451 | E4 | D00-4d-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-024: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-024) |
| WK-SCP0098-0452 | E4 | D00-4d-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-025: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-025) |
| WK-SCP0098-0453 | E4 | D00-4d-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-026: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-026) |
| WK-SCP0098-0454 | E4 | D00-4d-027 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-027: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-027) |
| WK-SCP0098-0455 | E4 | FindButton(실동작) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — FindButton(실동작): 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (FindButton(실동작)) |
| WK-SCP0098-0456 | E4 | SCP0098_CAPAReprotSmall.SetCellFormat | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0098_CAPAReprotSmall.SetCellFormat: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 42 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0457 | E4 | SCP0098_CAPAReprotSmall.SetCellFormatNeo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0098_CAPAReprotSmall.SetCellFormatNeo: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 121 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0458 | E4 | SCP0098_CAPAReprotSmall.SetCellFormat_09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0098_CAPAReprotSmall.SetCellFormat_0909: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 125 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0459 | E4 | SCP0098_CAPAReprotSmall.SetCellFormat_LI | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0098_CAPAReprotSmall.SetCellFormat_LINE: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 131 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0460 | E4 | SCP0098_CAPAReprotSmall.SetChangedContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0098_CAPAReprotSmall.SetChangedControl: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0098_CAPAReprotSmall.SetChangedCo) |
| WK-SCP0098-0461 | E4 | SCP0098_CAPAReprotSmall.SetLayout | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0098_CAPAReprotSmall.SetLayout: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.SetLayout:31) |
| WK-SCP0098-0462 | E4 | SCP0098_CAPAReprotSmall.SetReTextCellTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0098_CAPAReprotSmall.SetReTextCellType: 진입점 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.SetReTextCel) |
| WK-SCP0098-0463 | E4 | SCP0098_CAPAReprotSmall.SetSaveStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0098_CAPAReprotSmall.SetSaveStatus: 진입점 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.SetSaveStatu) |
| WK-SCP0098-0464 | E4 | SCP0098_CAPAReprotSmall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadColumn: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0098_CAPAReprotSmall.SetSpreadCol) |
| WK-SCP0098-0465 | E4 | SCP0098_CAPAReprotSmall.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadInit: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0466 | E4 | btnInput_Click 가드 #14~27(0열숨김/CanModelCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — btnInput_Click 가드 #14~27(0열숨김/CanModelChange/Selec: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (btnInput_Click 가드 #14~27(0열숨김/CanModelCh) |
| WK-SCP0098-0467 | E4 | 기타 tran/Exception | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 기타 tran/Exception: 행 집계 — E4 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (기타 tran/Exception) |
| WK-SCP0098-0468 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-03) |
| WK-SCP0098-0469 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-07) |
| WK-SCP0098-0470 | A1 | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-008: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-1-008) |
| WK-SCP0098-0471 | A1 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-029: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-1-029) |
| WK-SCP0098-0472 | A1 | D00-1-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-040: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-1-040) |
| WK-SCP0098-0473 | A1 | D00-2-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-008: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-2-008) |
| WK-SCP0098-0474 | A1 | FindButton(실동작) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton(실동작): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (FindButton(실동작)) |
| WK-SCP0098-0475 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 77 (SCP0009_GET_SHEET_CALENDAR_3SPAN / SCM_S) |
| WK-SCP0098-0476 | A1 | PKG_SCP0098.P_COPY_MONTH_WEEK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0098.P_COPY_MONTH_WEEK: 골든 비교 케이스 없음(PKG_SCP0098.P_COPY_MONTH_WEEK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 |  | 1 (D00-2-001) |
| WK-SCP0098-0477 | A1 | PKG_SCP0098.P_GET_CAPA_MOBILITYIT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0098.P_GET_CAPA_MOBILITYIT: 골든 비교 케이스 없음(PKG_SCP0098.P_GET_CAPA_MOBILITYIT — 팝업·보조 SP 는 golden_cases.csv 에 FE 실 |  | 1 (P_GET_CAPA_MOBILITYIT) |
| WK-SCP0098-0478 | G03-WIRE | SCP0098 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0098 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 |  | 27 (ACT:SCP0098_CAPAReprotSmall..ctor ACT:SC) |
| WK-SCP0098-0479 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0098-0480 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0098-0481 | G1 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-029: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-029) |
| WK-SCP0098-0482 | G1 | D00-1-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-040: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-040) |
| WK-SCP0098-0483 | G1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-001: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0098-0484 | G1 | FindButton(실동작) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton(실동작): 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (FindButton(실동작)) |
| WK-SCP0098-0485 | G6 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-029: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-029) |
| WK-SCP0098-0486 | G6 | D00-1-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-040: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-040) |
| WK-SCP0098-0487 | X-LOC | P_COPY_MONTH_WEEK | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_COPY_MONTH_WEEK: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_COPY_MONTH_WEEK) |
| WK-SCP0098-0488 | X-LOC | P_SAVE_SCP_CAPA | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_SAVE_SCP_CAPA: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_SAVE_SCP_CAPA) |
| WK-SCP0098-0489 | X-LOC | P_SAVE_SCP_CAPA_PRODUCT_RATE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_SAVE_SCP_CAPA_PRODUCT_RATE: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_SAVE_SCP_CAPA_PRODUCT_RATE) |
| WK-SCP0098-0490 | X-LOC | P_SAVE_SCP_CAPA_WORK | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — P_SAVE_SCP_CAPA_WORK: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (P_SAVE_SCP_CAPA_WORK) |
| WK-SCP0098-0491 | X-LOC | SCP0009_GET_SHEET_CALENDAR_3SPAN / SCM_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP0009_GET_SHEET_CALENDAR_3SPAN / SCM_SYS_GET_SPR: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP0009_GET_SHEET_CALENDAR_3SPAN / SCM_S) |
| WK-SCP0098-0492 | X-ROW | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (10) |
| WK-SCP0098-0493 | X-ROW | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (11) |
| WK-SCP0098-0494 | X-ROW | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (3) |
| WK-SCP0098-0495 | X-ROW | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (4) |
| WK-SCP0098-0496 | X-ROW | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (5) |
| WK-SCP0098-0497 | X-ROW | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (6) |
| WK-SCP0098-0498 | X-ROW | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 7: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (7) |
| WK-SCP0098-0499 | X-ROW | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 9: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (9) |
| WK-SCP0098-0500 | X-ROW | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-001) |
| WK-SCP0098-0501 | X-ROW | D00-1-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-002) |
| WK-SCP0098-0502 | X-ROW | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-004) |
| WK-SCP0098-0503 | X-ROW | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-005) |
| WK-SCP0098-0504 | X-ROW | D00-1-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-014: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-014) |
| WK-SCP0098-0505 | X-ROW | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-021: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-021) |
| WK-SCP0098-0506 | X-ROW | D00-1-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-022: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-022) |
| WK-SCP0098-0507 | X-ROW | D00-1-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-023: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-023) |
| WK-SCP0098-0508 | X-ROW | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-025: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-025) |
| WK-SCP0098-0509 | X-ROW | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-026: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-026) |
| WK-SCP0098-0510 | X-ROW | D00-1-027 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-027: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-027) |
| WK-SCP0098-0511 | X-ROW | D00-1-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-030: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-030) |
| WK-SCP0098-0512 | X-ROW | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-002) |
| WK-SCP0098-0513 | X-ROW | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-003) |
| WK-SCP0098-0514 | X-ROW | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-004) |
| WK-SCP0098-0515 | X-ROW | D00-3-045 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-045: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-045) |
| WK-SCP0098-0516 | X-ROW | D00-3-046 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-046: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-046) |
| WK-SCP0098-0517 | X-ROW | D00-3-051 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-051: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-051) |
| WK-SCP0098-0518 | X-ROW | D00-3-052 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-052: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-052) |
| WK-SCP0098-0519 | X-ROW | D00-4d-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-016: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-016) |
| WK-SCP0098-0520 | X-ROW | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-018: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-018) |
| WK-SCP0098-0521 | X-ROW | D00-4d-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-028: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-028) |
| WK-SCP0098-0522 | X-ROW | Form SCP0098_CAPAReprotSmall | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Form SCP0098_CAPAReprotSmall: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Form SCP0098_CAPAReprotSmall) |
| WK-SCP0098-0523 | X-ROW | SCP0098_CAPAReprotSmall.BtnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.BtnMeasure_Click: 진입점 집계 4검사 — NOT_RUN:3 · WARN:1 |  | 5 (ACT:SCP0098_CAPAReprotSmall.BtnMeasure_C) |
| WK-SCP0098-0524 | X-ROW | SCP0098_CAPAReprotSmall.CboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.CboDivision_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.CboDivision_) |
| WK-SCP0098-0525 | X-ROW | SCP0098_CAPAReprotSmall.CheckValidationS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.CheckValidationSave: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0098_CAPAReprotSmall.CheckValidat) |
| WK-SCP0098-0526 | X-ROW | SCP0098_CAPAReprotSmall.ChkDetail_Checke | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.ChkDetail_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.ChkDetail_Ch) |
| WK-SCP0098-0527 | X-ROW | SCP0098_CAPAReprotSmall.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.CreateSpread) |
| WK-SCP0098-0528 | X-ROW | SCP0098_CAPAReprotSmall.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.DefineProper) |
| WK-SCP0098-0529 | X-ROW | SCP0098_CAPAReprotSmall.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.EditButton: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.EditButton:4) |
| WK-SCP0098-0530 | X-ROW | SCP0098_CAPAReprotSmall.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/POPUP/THROW/UI_MISC/UI_PRO |  | 17 (ACT:SCP0098_CAPAReprotSmall.ExcelButton ) |
| WK-SCP0098-0531 | X-ROW | SCP0098_CAPAReprotSmall.FinColIndexdOEE | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.FinColIndexdOEE: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 6 (ACT:SCP0098_CAPAReprotSmall.FinColIndexd) |
| WK-SCP0098-0532 | X-ROW | SCP0098_CAPAReprotSmall.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0098_CAPAReprotSmall.FindButton) |
| WK-SCP0098-0533 | X-ROW | SCP0098_CAPAReprotSmall.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.FindData_Main: 진입점 집계 13검사 — NOT_RUN:9 · WARN:2 · REVIEW:1 · PASS:1 |  | 9 (ACT:SCP0098_CAPAReprotSmall.FindData_Mai) |
| WK-SCP0098-0534 | X-ROW | SCP0098_CAPAReprotSmall.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.Form_Load: 진입점 집계 10검사 — NOT_RUN:9 · WARN:1 |  | 3 (ACT:SCP0098_CAPAReprotSmall.Form_Load:18) |
| WK-SCP0098-0535 | X-ROW | SCP0098_CAPAReprotSmall.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.GetDayRange) |
| WK-SCP0098-0536 | X-ROW | SCP0098_CAPAReprotSmall.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.GetLastRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.GetLastRange) |
| WK-SCP0098-0537 | X-ROW | SCP0098_CAPAReprotSmall.GetLastWeek | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.GetLastWeek: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.GetLastWeek) |
| WK-SCP0098-0538 | X-ROW | SCP0098_CAPAReprotSmall.GetLastYYYYMM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.GetLastYYYYMM: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.GetLastYYYYM) |
| WK-SCP0098-0539 | X-ROW | SCP0098_CAPAReprotSmall.GetNextDayColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.GetNextDayColumn: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.GetNextDayCo) |
| WK-SCP0098-0540 | X-ROW | SCP0098_CAPAReprotSmall.GetNowMonth | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.GetNowMonth: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.GetNowMonth) |
| WK-SCP0098-0541 | X-ROW | SCP0098_CAPAReprotSmall.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.GetSpdTitle) |
| WK-SCP0098-0542 | X-ROW | SCP0098_CAPAReprotSmall.GetSpdTitle2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.GetSpdTitle2: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.GetSpdTitle2) |
| WK-SCP0098-0543 | X-ROW | SCP0098_CAPAReprotSmall.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0098_CAPAReprotSmall.InitControls) |
| WK-SCP0098-0544 | X-ROW | SCP0098_CAPAReprotSmall.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.InitSpread) |
| WK-SCP0098-0545 | X-ROW | SCP0098_CAPAReprotSmall.InitSpreadDateCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0098_CAPAReprotSmall.InitSpreadDa) |
| WK-SCP0098-0546 | X-ROW | SCP0098_CAPAReprotSmall.SCM_SYS_LOG_BATC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SCM_SYS_LOG_BATCH: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0098_CAPAReprotSmall.SCM_SYS_LOG_) |
| WK-SCP0098-0547 | X-ROW | SCP0098_CAPAReprotSmall.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SaveData: 진입점 집계 8검사 — NOT_RUN:5 · NOPATH:2 · WARN:1 |  | 8 (ACT:SCP0098_CAPAReprotSmall.SaveData:249) |
| WK-SCP0098-0548 | X-ROW | SCP0098_CAPAReprotSmall.SaveDataFull | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SaveDataFull: 진입점 집계 13검사 — NOT_RUN:6 · NOPATH:5 · WARN:1 · PASS:1 |  | 27 (ACT:SCP0098_CAPAReprotSmall.SaveDataFull) |
| WK-SCP0098-0549 | X-ROW | SCP0098_CAPAReprotSmall.SaveData_CAPA | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SaveData_CAPA: 진입점 집계 8검사 — NOT_RUN:4 · NOPATH:3 · WARN:1 |  | 2 (ACT:SCP0098_CAPAReprotSmall.SaveData_CAP) |
| WK-SCP0098-0550 | X-ROW | SCP0098_CAPAReprotSmall.SaveData_CAPA_PR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SaveData_CAPA_PRODUCT_RATE: 진입점 집계 8검사 — NOT_RUN:4 · NOPATH:3 · WARN:1 |  | 3 (ACT:SCP0098_CAPAReprotSmall.SaveData_CAP) |
| WK-SCP0098-0551 | X-ROW | SCP0098_CAPAReprotSmall.SaveData_CAPA_PR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SaveData_CAPA_PRODUCT_RATE: 진입점 집계 8검사 — NOT_RUN:4 · NOPATH:3 · WARN:1 |  | 3 (ACT:SCP0098_CAPAReprotSmall.SaveData_CAP) |
| WK-SCP0098-0552 | X-ROW | SCP0098_CAPAReprotSmall.SaveData_CAPA_WO | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SaveData_CAPA_WORK: 진입점 집계 8검사 — NOT_RUN:4 · NOPATH:3 · WARN:1 |  | 3 (ACT:SCP0098_CAPAReprotSmall.SaveData_CAP) |
| WK-SCP0098-0553 | X-ROW | SCP0098_CAPAReprotSmall.SetCellFormat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SetCellFormat: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:2 |  | 9 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0554 | X-ROW | SCP0098_CAPAReprotSmall.SetCellFormatNeo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SetCellFormatNeo: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:2 |  | 5 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0555 | X-ROW | SCP0098_CAPAReprotSmall.SetCellFormat_09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SetCellFormat_0909: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:2 |  | 3 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0556 | X-ROW | SCP0098_CAPAReprotSmall.SetCellFormat_LI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SetCellFormat_LINE: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:2 |  | 5 (ACT:SCP0098_CAPAReprotSmall.SetCellForma) |
| WK-SCP0098-0557 | X-ROW | SCP0098_CAPAReprotSmall.SetChangedContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SetChangedControl: 진입점 집계 10검사 — NOT_RUN:8 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0098_CAPAReprotSmall.SetChangedCo) |
| WK-SCP0098-0558 | X-ROW | SCP0098_CAPAReprotSmall.SetLayout | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SetLayout: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0098_CAPAReprotSmall.SetLayout AC) |
| WK-SCP0098-0559 | X-ROW | SCP0098_CAPAReprotSmall.SetReTextCellTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SetReTextCellType: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0098_CAPAReprotSmall.SetReTextCel) |
| WK-SCP0098-0560 | X-ROW | SCP0098_CAPAReprotSmall.SetSaveStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SetSaveStatus: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.SetSaveStatu) |
| WK-SCP0098-0561 | X-ROW | SCP0098_CAPAReprotSmall.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadColumn: 진입점 집계 14검사 — NOT_RUN:8 · REVIEW:6 |  | 6 (ACT:SCP0098_CAPAReprotSmall.SetSpreadCol) |
| WK-SCP0098-0562 | X-ROW | SCP0098_CAPAReprotSmall.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SetSpreadInit: 진입점 집계 18검사 — NOT_RUN:12 · REVIEW:6 |  | 1 (ACT:SCP0098_CAPAReprotSmall.SetSpreadIni) |
| WK-SCP0098-0563 | X-ROW | SCP0098_CAPAReprotSmall.SpdMain_CellClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SpdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/FLAG, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Cell) |
| WK-SCP0098-0564 | X-ROW | SCP0098_CAPAReprotSmall.SpdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Cell) |
| WK-SCP0098-0565 | X-ROW | SCP0098_CAPAReprotSmall.SpdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SpdMain_Changed: 진입점 집계 26검사 — NOT_RUN:22 · REVIEW:3 · WARN:1 |  | 3 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Chan) |
| WK-SCP0098-0566 | X-ROW | SCP0098_CAPAReprotSmall.SpdMain_TopChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0098_CAPAReprotSmall.SpdMain_TopC) |
| WK-SCP0098-0567 | X-ROW | SCP0098_CAPAReprotSmall.btnCopyData_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.btnCopyData_Click: 진입점 집계 9검사 — NOT_RUN:5 · NOPATH:2 · PASS:1 · WARN:1 |  | 6 (ACT:SCP0098_CAPAReprotSmall.btnCopyData_) |
| WK-SCP0098-0568 | X-ROW | SCP0098_CAPAReprotSmall.btnInput_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.btnInput_Click: 진입점 집계 5검사 — NOT_RUN:4 · WARN:1 |  | 17 (ACT:SCP0098_CAPAReprotSmall.btnInput_Cli) |
| WK-SCP0098-0569 | X-ROW | SCP0098_CAPAReprotSmall.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0098_CAPAReprotSmall.btnItemId_Cl) |
| WK-SCP0098-0570 | X-ROW | SCP0098_CAPAReprotSmall.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.cboBucketType_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0098_CAPAReprotSmall.cboBucketTyp) |
| WK-SCP0098-0571 | X-ROW | SCP0098_CAPAReprotSmall.isCellValueChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.isCellValueChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 |  | 14 (ACT:SCP0098_CAPAReprotSmall.isCellValueC) |
| WK-SCP0098-0572 | X-ROW | SCP0098_CAPAReprotSmall.isCellValueChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CAPAReprotSmall.isCellValueChangeItem: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/LOCAL/RETURN, 연결 |  | 14 (ACT:SCP0098_CAPAReprotSmall.isCellValueC) |
| WK-SCP0098-0573 | X-ROW | SCP0098_CopySelect_Popup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CopySelect_Popup..ctor: 진입점 집계 2검사 — WARN:1 · NOT_RUN:1 |  | 6 (ACT:SCP0098_CopySelect_Popup..ctor:55:1 ) |
| WK-SCP0098-0574 | X-ROW | SCP0098_CopySelect_Popup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CopySelect_Popup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0098_CopySelect_Popup.Dispose:16:) |
| WK-SCP0098-0575 | X-ROW | SCP0098_CopySelect_Popup.InitClass | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CopySelect_Popup.InitClass: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0098_CopySelect_Popup.InitClass A) |
| WK-SCP0098-0576 | X-ROW | SCP0098_CopySelect_Popup.MeasureSetForm_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CopySelect_Popup.MeasureSetForm_Load: 진입점 집계 2검사 — WARN:1 · NOT_RUN:1 |  | 10 (ACT:SCP0098_CopySelect_Popup.MeasureSetF) |
| WK-SCP0098-0577 | X-ROW | SCP0098_CopySelect_Popup.SetOption | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CopySelect_Popup.SetOption: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0098_CopySelect_Popup.SetOption A) |
| WK-SCP0098-0578 | X-ROW | SCP0098_CopySelect_Popup.rbOpt1_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CopySelect_Popup.rbOpt1_Click: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0098_CopySelect_Popup.rbOpt1_Clic) |
| WK-SCP0098-0579 | X-ROW | SCP0098_CopySelect_Popup.rbOpt2_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0098_CopySelect_Popup.rbOpt2_Click: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0098_CopySelect_Popup.rbOpt2_Clic) |
| WK-SCP0098-0580 | G5 | D00-1-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-1-020: 행 집계 — G5 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-020) |
| WK-SCP0098-0581 | G5 | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-1-024: 행 집계 — G5 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-024) |
| WK-SCP0098-0582 | G5 | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-1-028: 행 집계 — G5 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-028) |
| WK-SCP0098-0583 | G5 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-1-029: 행 집계 — G5 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-029) |
| WK-SCP0098-0584 | G5 | D00-1-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-1-031: 행 집계 — G5 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-031) |
| WK-SCP0098-0585 | G5 | SCP0098_CAPAReprotSmall.SpdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0098_CAPAReprotSmall.SpdMain_CellDoubleClick: 진입점 집계 — G5 8요소: NOPATH:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Cell) |
| WK-SCP0098-0586 | H6 | D00-1-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-1-020: 행 집계 — H6 8요소: NOPATH:5 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-020) |
| WK-SCP0098-0587 | H6 | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-1-024: 행 집계 — H6 8요소: NOPATH:5 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-024) |
| WK-SCP0098-0588 | H6 | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-1-028: 행 집계 — H6 8요소: NOPATH:5 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-028) |
| WK-SCP0098-0589 | H6 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-1-029: 행 집계 — H6 8요소: NOPATH:5 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-029) |
| WK-SCP0098-0590 | H6 | D00-1-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-1-031: 행 집계 — H6 8요소: NOPATH:5 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-031) |
| WK-SCP0098-0591 | H6 | SCP0098_CAPAReprotSmall.SpdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0098_CAPAReprotSmall.SpdMain_CellDoubleClick: 진입점 집계 — H6 8요소: NOPATH:5 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Cell) |
| WK-SCP0098-0592 | M4 | D00-1-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-1-020: 행 집계 — M4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-020) |
| WK-SCP0098-0593 | M4 | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-1-024: 행 집계 — M4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-024) |
| WK-SCP0098-0594 | M4 | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-1-028: 행 집계 — M4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-028) |
| WK-SCP0098-0595 | M4 | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-1-029: 행 집계 — M4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-029) |
| WK-SCP0098-0596 | M4 | D00-1-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-1-031: 행 집계 — M4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-031) |
| WK-SCP0098-0597 | M4 | SCP0098_CAPAReprotSmall.SpdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0098_CAPAReprotSmall.SpdMain_CellDoubleClick: 진입점 집계 — M4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0098_CAPAReprotSmall.SpdMain_Cell) |
