# 작업 원장 — SCP0134 · 2026-10-26 12:55

> 검사 인스턴스 246건 중 PASS·NA 112건 외 **134건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 35 | 구현 위치 실존 |
| W5 | 검사기 연결 | 9 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 32 | 실행 → PASS |
| W7 | 기대값 확정 | 58 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 54 · 대조표 39 · E2E 32 · 하네스 9
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 7건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 35 |  |  |  |  | 9 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A1 | GEN |  |  |  |  |  |  | 20 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| E4 | EDIT |  |  |  |  |  | 14 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| DB-SYN | DB |  |  |  |  | 7 |  | 7 |  |  | BE 계정 시노님·권한·대상 객체 |
| F4 | DB |  |  |  |  |  | 7 | 7 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  | 3 | 4 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REASON | DESIGN |  |  |  |  |  |  | 4 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| X-ROW | GEN |  |  |  |  |  |  | 4 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |

## W2 구현 위치 확인 (35)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0134-0001 | X-LOC | 10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (10) |
| WK-SCP0134-0002 | X-LOC | 11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (11) |
| WK-SCP0134-0003 | X-LOC | 3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3) |
| WK-SCP0134-0004 | X-LOC | 4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (4) |
| WK-SCP0134-0005 | X-LOC | 5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (5) |
| WK-SCP0134-0006 | X-LOC | 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (6) |
| WK-SCP0134-0007 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (7) |
| WK-SCP0134-0008 | X-LOC | 8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (8) |
| WK-SCP0134-0009 | X-LOC | 9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (9) |
| WK-SCP0134-0010 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0134-0011 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: organisms/data-grid/DataGrid.tsx 없음 |  | 1 (COMMON:UC-07) |
| WK-SCP0134-0012 | X-LOC | Closed override (L416-428 전체 주석 — 00_che | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Closed override (L416-428 전체 주석 — 00_che) |
| WK-SCP0134-0013 | X-LOC | DeleteButton NO-OP (L381) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DeleteButton NO-OP (L381)) |
| WK-SCP0134-0014 | X-LOC | EditButton NO-OP (L387-414 전체 주석) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton NO-OP (L387-414 전체 주석)) |
| WK-SCP0134-0015 | X-LOC | FindButton 필수값 가드 (L670, Roslyn 미포착) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton 필수값 가드 (L670, Roslyn 미포착)) |
| WK-SCP0134-0016 | X-LOC | InsertButton NO-OP (L376) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (InsertButton NO-OP (L376)) |
| WK-SCP0134-0017 | X-LOC | R14 REVISION_NO 행별 콤보 (#50-56) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R14 REVISION_NO 행별 콤보 (#50-56)) |
| WK-SCP0134-0018 | X-LOC | R15 Query 바인딩 (#57,#58) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R15 Query 바인딩 (#57,#58)) |
| WK-SCP0134-0019 | X-LOC | R16 dead code (#59,#60) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R16 dead code (#59,#60)) |
| WK-SCP0134-0020 | X-LOC | R17 Confirm 정보 반영 (#61-63) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R17 Confirm 정보 반영 (#61-63)) |
| WK-SCP0134-0021 | X-LOC | R18 Confirm 저장 반영 (#64-66) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R18 Confirm 저장 반영 (#64-66)) |
| WK-SCP0134-0022 | X-LOC | R19 REVISION 변경 파생 (#67-69) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R19 REVISION 변경 파생 (#67-69)) |
| WK-SCP0134-0023 | X-LOC | R20~R22 진행색상 (#70-77) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/planManagementEngine.ts 없음 |  | 1 (R20~R22 진행색상 (#70-77)) |
| WK-SCP0134-0024 | X-LOC | R23 AddActionTextBox (#78,#79) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R23 AddActionTextBox (#78,#79)) |
| WK-SCP0134-0025 | X-LOC | R24 셀 포커스 복원 (#80-83) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R24 셀 포커스 복원 (#80-83)) |
| WK-SCP0134-0026 | X-LOC | R25 GetViewRowFromModelRow (#84) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R25 GetViewRowFromModelRow (#84)) |
| WK-SCP0134-0027 | X-LOC | R3/R5 SmartColMerge 재실행 (#28-30,#32) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R3/R5 SmartColMerge 재실행 (#28-30,#32)) |
| WK-SCP0134-0028 | X-LOC | R4 DIVISION_NAME 병합 (#31) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/planManagementMerge.ts 없음 |  | 1 (R4 DIVISION_NAME 병합 (#31)) |
| WK-SCP0134-0029 | X-LOC | R6 VisibleTab (#33,#34) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R6 VisibleTab (#33,#34)) |
| WK-SCP0134-0030 | X-LOC | R7~R10 RUN/CONFIRM lock (#35-46) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: utils/planManagementLock.ts 없음 |  | 1 (R7~R10 RUN/CONFIRM lock (#35-46)) |
| WK-SCP0134-0031 | X-LOC | SaveButton NO-OP (L432, SaveData() 빈 몸체) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton NO-OP (L432, SaveData() 빈 몸체)) |
| WK-SCP0134-0032 | X-LOC | guard #1 빈 그리드 더블클릭 no-op (L1364) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (guard #1 빈 그리드 더블클릭 no-op (L1364)) |
| WK-SCP0134-0033 | X-LOC | guard #2 CanModelChange 재진입 가드 (L1420) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (guard #2 CanModelChange 재진입 가드 (L1420)) |
| WK-SCP0134-0034 | X-LOC | guard #3 REVISION_NO 컬럼 한정 (L1421) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (guard #3 REVISION_NO 컬럼 한정 (L1421)) |
| WK-SCP0134-0035 | X-LOC | guard #4 ds null 가드 (L1433) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (guard #4 ds null 가드 (L1433)) |

## W5 검사기 연결 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0134-0036 | F2 | SCP0134 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0134 화면 | 판단불가(대상 단위 SCREEN) | 7 (5 6 7 R18 Confirm 저장 반영 (#64-66) 8 Inser) |
| WK-SCP0134-0037 | F6 | SCP0134 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0134 화면 | 판단불가(대상 단위 SCREEN) | 5 (R18 Confirm 저장 반영 (#64-66) SaveButton NO) |
| WK-SCP0134-0038 | DB-SYN | P_RAISE_NOT_MIGRATED | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_RAISE_NOT_MIGRATED | 없음(PROC_M 대응 없음) | 1 (SCP.SCP0015_SAVE_PLAN_MST_RUN) |
| WK-SCP0134-0039 | DB-SYN | SCP0015_GET_PLAN_ENGINE_RUN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0015_GET_PLAN_ENGINE_RUN | 없음(PROC_M 대응 없음) | 1 (SCP.SCP0015_GET_PLAN_ENGINE_RUN) |
| WK-SCP0134-0040 | DB-SYN | SCP0015_GET_PLAN_MST | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0015_GET_PLAN_MST | 없음(PROC_M 대응 없음) | 1 (SCP.SCP0015_GET_PLAN_MST) |
| WK-SCP0134-0041 | DB-SYN | SCP0015_GET_PLAN_MST_COMFIRM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0015_GET_PLAN_MST_COMFIRM | 없음(PROC_M 대응 없음) | 1 (SCP.SCP0015_GET_PLAN_MST_COMFIRM) |
| WK-SCP0134-0042 | DB-SYN | SCP0015_SAVE_PLAN_MST_COMFIRM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0015_SAVE_PLAN_MST_COMFIRM | 없음(PROC_M 대응 없음) | 1 (SCP.SCP0015_SAVE_PLAN_MST_COMFIRM) |
| WK-SCP0134-0043 | DB-SYN | SCP0015_SAVE_PLAN_MST_RUN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0015_SAVE_PLAN_MST_RUN | 없음(PROC_M 대응 없음) | 1 (SCP.SCP0015_SAVE_PLAN_MST_RUN) |
| WK-SCP0134-0044 | DB-SYN | SCP0015_SAVE_PLAN_MST_STOP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0015_SAVE_PLAN_MST_STOP | 없음(PROC_M 대응 없음) | 1 (SCP.SCP0015_SAVE_PLAN_MST_STOP) |

## W6 검증 실행 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0134-0045 | J2 | SCP0134 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0134 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 26 (3 4 5 6 7 R14 REVISION_NO 행별 콤보 (#50-56)) |
| WK-SCP0134-0046 | G3 | SCP0134 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0134 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (FindButton 필수값 가드 (L670, Roslyn 미포착) COM) |
| WK-SCP0134-0047 | K-SA | SCP0134 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0134 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (FindButton 필수값 가드 (L670, Roslyn 미포착)) |
| WK-SCP0134-0048 | K4 | SCP0134 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0134 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 3 (COMMON:UC-04 COMMON:UC-05 COMMON:UC-07) |
| WK-SCP0134-0049 | F1 | SCP0134 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0134 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 11 (5 6 7 R18 Confirm 저장 반영 (#64-66) 8 Inser) |
| WK-SCP0134-0050 | F5 | SCP0134 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0134 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 2 (InsertButton NO-OP (L376) DeleteButton N) |
| WK-SCP0134-0051 | F4 | P_RAISE_NOT_MIGRATED | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_RAISE_NOT_MIGRATED · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (SCP.SCP0015_SAVE_PLAN_MST_RUN) |
| WK-SCP0134-0052 | F4 | SCP0015_GET_PLAN_ENGINE_RUN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0015_GET_PLAN_ENGINE_RUN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (SCP.SCP0015_GET_PLAN_ENGINE_RUN) |
| WK-SCP0134-0053 | F4 | SCP0015_GET_PLAN_MST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0015_GET_PLAN_MST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (SCP.SCP0015_GET_PLAN_MST) |
| WK-SCP0134-0054 | F4 | SCP0015_GET_PLAN_MST_COMFIRM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0015_GET_PLAN_MST_COMFIRM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (SCP.SCP0015_GET_PLAN_MST_COMFIRM) |
| WK-SCP0134-0055 | F4 | SCP0015_SAVE_PLAN_MST_COMFIRM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0015_SAVE_PLAN_MST_COMFIRM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 1 (SCP.SCP0015_SAVE_PLAN_MST_COMFIRM) |
| WK-SCP0134-0056 | F4 | SCP0015_SAVE_PLAN_MST_RUN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0015_SAVE_PLAN_MST_RUN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (SCP.SCP0015_SAVE_PLAN_MST_RUN) |
| WK-SCP0134-0057 | F4 | SCP0015_SAVE_PLAN_MST_STOP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0015_SAVE_PLAN_MST_STOP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (SCP.SCP0015_SAVE_PLAN_MST_STOP) |
| WK-SCP0134-0058 | I1 | SCP0134 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0134 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 11 (5 6 7 8 9 10 11 FindButton 필수값 가드 (L670,) |
| WK-SCP0134-0059 | D6 | SCP0134 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0134 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 10 (guard #1 빈 그리드 더블클릭 no-op (L1364) guard ) |
| WK-SCP0134-0060 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (5 7) |
| WK-SCP0134-0061 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (6 8 9) |
| WK-SCP0134-0062 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (FindButton 필수값 가드 (L670, Roslyn 미포착)) |
| WK-SCP0134-0063 | E4 | MSG00180 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00180 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (Closed override (L416-428 전체 주석 — 00_che) |
| WK-SCP0134-0064 | E4 | MSG00183 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00183 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (10) |
| WK-SCP0134-0065 | E4 | MSG00184 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00184 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (11) |
| WK-SCP0134-0066 | E4 | MSG00185 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00185 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0134-0067 | E4 | MSG00205 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00205 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0134-0068 | E4 | MSG01455 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01455 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (Closed override (L416-428 전체 주석 — 00_che) |
| WK-SCP0134-0069 | E4 | MSG01456 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01456 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (10) |
| WK-SCP0134-0070 | E4 | MSG01457 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01457 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (11) |
| WK-SCP0134-0071 | E4 | MSG01458 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01458 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0134-0072 | E4 | MSG01460 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01460 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0134-0073 | E4 | MSG01461 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01461 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (5 7 COMMON:UC-04) |
| WK-SCP0134-0074 | A6 | SCP0015_GET_PLAN_ENGINE_RUN | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0015_GET_PLAN_ENGINE_RUN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec |  | 1 (SCP.SCP0015_GET_PLAN_ENGINE_RUN) |
| WK-SCP0134-0075 | A6 | SCP0015_GET_PLAN_MST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0015_GET_PLAN_MST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace |  | 1 (SCP.SCP0015_GET_PLAN_MST) |
| WK-SCP0134-0076 | A6 | SCP0015_GET_PLAN_MST_COMFIRM | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0015_GET_PLAN_MST_COMFIRM · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spe |  | 1 (SCP.SCP0015_GET_PLAN_MST_COMFIRM) |

## W7 기대값 확정 (58)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0134-0077 | DB-SYN | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 1: 행 집계 — DB-SYN 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0134-0078 | DB-SYN | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 3: 행 집계 — DB-SYN 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0134-0079 | DB-SYN | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 4: 행 집계 — DB-SYN 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0134-0080 | DB-SYN | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 6: 행 집계 — DB-SYN 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0134-0081 | DB-SYN | R17 Confirm 정보 반영 (#61-63) | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — R17 Confirm 정보 반영 (#61-63): 행 집계 — DB-SYN 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (R17 Confirm 정보 반영 (#61-63)) |
| WK-SCP0134-0082 | DB-SYN | R18 Confirm 저장 반영 (#64-66) | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — R18 Confirm 저장 반영 (#64-66): 행 집계 — DB-SYN 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (R18 Confirm 저장 반영 (#64-66)) |
| WK-SCP0134-0083 | DB-SYN | SaveButton NO-OP (L432, SaveData() 빈 몸체) | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SaveButton NO-OP (L432, SaveData() 빈 몸체): 행 집계 — DB-SYN 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton NO-OP (L432, SaveData() 빈 몸체)) |
| WK-SCP0134-0084 | F4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 1: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0134-0085 | F4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 3: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0134-0086 | F4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 4: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0134-0087 | F4 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 6: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0134-0088 | F4 | R17 Confirm 정보 반영 (#61-63) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — R17 Confirm 정보 반영 (#61-63): 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R17 Confirm 정보 반영 (#61-63)) |
| WK-SCP0134-0089 | F4 | R18 Confirm 저장 반영 (#64-66) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — R18 Confirm 저장 반영 (#64-66): 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R18 Confirm 저장 반영 (#64-66)) |
| WK-SCP0134-0090 | F4 | SaveButton NO-OP (L432, SaveData() 빈 몸체) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SaveButton NO-OP (L432, SaveData() 빈 몸체): 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton NO-OP (L432, SaveData() 빈 몸체)) |
| WK-SCP0134-0091 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태 신규행 Insert 시 필터 유지 — Insert NO-OP(비노출, §4 근거) — 신규행 삽입 경로 없음 해당없음 |  | 1 (COMMON:UC-01) |
| WK-SCP0134-0092 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 재조회 confirm(MSG00703) — 저장 버튼 NO-OP·배치 미저장 편집 개념 없음. REVISION_NO 변경은 즉시 파생(handleRevision |  | 1 (COMMON:UC-02) |
| WK-SCP0134-0093 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼/Measure 설정 적용 시 Reset·재조회 — Column/Measure 설정 모달 없음(customButtons 0, pivot 아님) 해당없음 |  | 1 (COMMON:UC-03) |
| WK-SCP0134-0094 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 콤마 다중 조회 — 조회조건이 콤보 3종(Division/PlanYear/PlanWeek)뿐 — 텍스트 key-in 조회조건 없음(§5 "대소문자 무관" 미해당과  |  | 1 (COMMON:UC-06) |
| WK-SCP0134-0095 | E4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 3: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0134-0096 | E4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 4: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0134-0097 | E4 | SCP.SCP0015_SAVE_PLAN_MST_RUN | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP.SCP0015_SAVE_PLAN_MST_RUN: 행 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (SCP.SCP0015_SAVE_PLAN_MST_RUN) |
| WK-SCP0134-0098 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 4요소: REVIEW:4 |  | 0 () |
| WK-SCP0134-0099 | A1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 10: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (10) |
| WK-SCP0134-0100 | A1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 11: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (11) |
| WK-SCP0134-0101 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 4요소: REVIEW:4 |  | 0 () |
| WK-SCP0134-0102 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (3) |
| WK-SCP0134-0103 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (4) |
| WK-SCP0134-0104 | A1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 5: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (5) |
| WK-SCP0134-0105 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (6) |
| WK-SCP0134-0106 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (7) |
| WK-SCP0134-0107 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (8) |
| WK-SCP0134-0108 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (COMMON:UC-07) |
| WK-SCP0134-0109 | A1 | FindButton 필수값 가드 (L670, Roslyn 미포착) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton 필수값 가드 (L670, Roslyn 미포착): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (FindButton 필수값 가드 (L670, Roslyn 미포착)) |
| WK-SCP0134-0110 | A1 | P_RAISE_NOT_MIGRATED | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_RAISE_NOT_MIGRATED: 골든 비교 케이스 없음(P_RAISE_NOT_MIGRATED — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (9) |
| WK-SCP0134-0111 | A1 | R17 Confirm 정보 반영 (#61-63) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R17 Confirm 정보 반영 (#61-63): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (R17 Confirm 정보 반영 (#61-63)) |
| WK-SCP0134-0112 | A1 | R18 Confirm 저장 반영 (#64-66) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R18 Confirm 저장 반영 (#64-66): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (R18 Confirm 저장 반영 (#64-66)) |
| WK-SCP0134-0113 | A1 | R24 셀 포커스 복원 (#80-83) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R24 셀 포커스 복원 (#80-83): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (R24 셀 포커스 복원 (#80-83)) |
| WK-SCP0134-0114 | A1 | SCP0015_GET_PLAN_ENGINE_RUN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0015_GET_PLAN_ENGINE_RUN: 골든 비교 케이스 없음(SCP0015_GET_PLAN_ENGINE_RUN — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 |  | 1 (SCP.SCP0015_GET_PLAN_ENGINE_RUN) |
| WK-SCP0134-0115 | A1 | SCP0015_GET_PLAN_MST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0015_GET_PLAN_MST: 골든 비교 케이스 없음(SCP0015_GET_PLAN_MST — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (SCP.SCP0015_GET_PLAN_MST) |
| WK-SCP0134-0116 | A1 | SCP0015_GET_PLAN_MST_COMFIRM | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0015_GET_PLAN_MST_COMFIRM: 골든 비교 케이스 없음(SCP0015_GET_PLAN_MST_COMFIRM — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케 |  | 1 (SCP.SCP0015_GET_PLAN_MST_COMFIRM) |
| WK-SCP0134-0117 | A1 | guard #2 CanModelChange 재진입 가드 (L1420) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — guard #2 CanModelChange 재진입 가드 (L1420): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (guard #2 CanModelChange 재진입 가드 (L1420)) |
| WK-SCP0134-0118 | A6 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 3: 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0134-0119 | A6 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 4: 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0134-0120 | A6 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 6: 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0134-0121 | A6 | R17 Confirm 정보 반영 (#61-63) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — R17 Confirm 정보 반영 (#61-63): 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R17 Confirm 정보 반영 (#61-63)) |
| WK-SCP0134-0122 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0134-0123 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0134-0124 | X-LOC | 3/4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3/4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3/4) |
| WK-SCP0134-0125 | X-LOC | SCP.SCP0015_GET_PLAN_ENGINE_RUN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP.SCP0015_GET_PLAN_ENGINE_RUN: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP.SCP0015_GET_PLAN_ENGINE_RUN) |
| WK-SCP0134-0126 | X-LOC | SCP.SCP0015_GET_PLAN_MST | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP.SCP0015_GET_PLAN_MST: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP.SCP0015_GET_PLAN_MST) |
| WK-SCP0134-0127 | X-LOC | SCP.SCP0015_GET_PLAN_MST_COMFIRM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP.SCP0015_GET_PLAN_MST_COMFIRM: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP.SCP0015_GET_PLAN_MST_COMFIRM) |
| WK-SCP0134-0128 | X-LOC | SCP.SCP0015_SAVE_PLAN_MST_COMFIRM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP.SCP0015_SAVE_PLAN_MST_COMFIRM: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP.SCP0015_SAVE_PLAN_MST_COMFIRM) |
| WK-SCP0134-0129 | X-LOC | SCP.SCP0015_SAVE_PLAN_MST_RUN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP.SCP0015_SAVE_PLAN_MST_RUN: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP.SCP0015_SAVE_PLAN_MST_RUN) |
| WK-SCP0134-0130 | X-LOC | SCP.SCP0015_SAVE_PLAN_MST_STOP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP.SCP0015_SAVE_PLAN_MST_STOP: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP.SCP0015_SAVE_PLAN_MST_STOP) |
| WK-SCP0134-0131 | X-ROW | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (1) |
| WK-SCP0134-0132 | X-ROW | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0134-0133 | X-ROW | R1/R2 헤더 span (#1-27) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R1/R2 헤더 span (#1-27): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R1/R2 헤더 span (#1-27)) |
| WK-SCP0134-0134 | X-ROW | R25 GetViewRowFromModelRow (#84) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R25 GetViewRowFromModelRow (#84): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R25 GetViewRowFromModelRow (#84)) |
