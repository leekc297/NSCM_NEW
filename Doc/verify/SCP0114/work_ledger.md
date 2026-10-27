# 작업 원장 — SCP0114 · 2026-10-26 12:55

> 검사 인스턴스 511건 중 PASS·NA 65건 외 **446건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 33 | 구현 위치 실존 |
| W4 | 검사기 구현 | 2 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 8 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 161 | 실행 → PASS |
| W7 | 기대값 확정 | 242 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 239 · E2E 161 · 대조표 36 · 하네스 10
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 56 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 33 |  |  |  |  | 16 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| H2 | DESIGN |  |  |  |  |  | 15 | 24 |  |  | 배경·글자색 규칙 |
| A5 | DESIGN |  |  |  |  |  | 15 | 22 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 15 | 22 |  |  | 라벨 명칭 |
| D1 | EDIT |  |  |  |  |  | 14 | 9 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 14 | 9 |  |  | 행 값 기반 조건부 잠금 |
| M4 | POPUP |  |  |  |  |  | 11 | 10 |  |  | 팝업 선택값 반영 |
| C3 | CASCADE |  |  |  |  |  | 11 | 8 |  |  | 연쇄 자동 채움 |
| C2 | CASCADE |  |  |  |  |  | 11 | 6 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 11 | 6 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| D5 | EDIT |  |  |  |  |  | 15 | 2 |  |  | 셀 에디터 유형 |
| A1 | GEN |  |  |  |  |  |  | 12 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 1 | 10 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| F4 | DB |  |  |  |  |  | 2 | 7 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| D4 | EDIT |  |  |  |  |  | 3 | 6 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| E4 | EDIT |  |  |  |  |  | 7 | 2 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A6 | GEN |  |  |  |  |  | 1 | 4 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B3 | COMBO |  |  |  | 2 |  |  | 2 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 2 |  | 2 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | CASCADE |  |  |  |  |  | 1 | 2 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| X-REASON | DESIGN |  |  |  |  |  |  | 3 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| G4 | DESIGN |  |  |  |  |  | 1 | 1 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 1 | 1 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B1 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 중복 없음 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| E5 | EDIT |  |  |  |  | 1 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (33)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0114-0001 | X-LOC | 1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1) |
| WK-SCP0114-0002 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (7) |
| WK-SCP0114-0003 | X-LOC | 8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 0 () |
| WK-SCP0114-0004 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: SubTitle.tsx 없음, gridAction.ts 없음 |  | 1 (COMMON:UC-05) |
| WK-SCP0114-0005 | X-LOC | I/M/D 마킹행만 수집 (813) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (I/M/D 마킹행만 수집 (813)) |
| WK-SCP0114-0006 | X-LOC | Level1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Level1) |
| WK-SCP0114-0007 | X-LOC | Level2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Level2) |
| WK-SCP0114-0008 | X-LOC | Level3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Level3) |
| WK-SCP0114-0009 | X-LOC | Level4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Level4) |
| WK-SCP0114-0010 | X-LOC | Level5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Level5) |
| WK-SCP0114-0011 | X-LOC | R18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: gridAction.ts 없음 |  | 1 (R18) |
| WK-SCP0114-0012 | X-LOC | R2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R2) |
| WK-SCP0114-0013 | X-LOC | `InsertRow` `spreadLevel.IsLock(SheetNam | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`InsertRow` `spreadLevel.IsLock(SheetNam) |
| WK-SCP0114-0014 | X-LOC | `SaveData` `_si.ActiveSheet.Rows.Count < | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SaveData` `_si.ActiveSheet.Rows.Count <) |
| WK-SCP0114-0015 | X-LOC | `SaveData` `_si.IsLock(SheetName) == fal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SaveData` `_si.IsLock(SheetName) == fal) |
| WK-SCP0114-0016 | X-LOC | `^` 구분 병렬 배열 17 파라미터 (824~897) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`^` 구분 병렬 배열 17 파라미터 (824~897)) |
| WK-SCP0114-0017 | X-LOC | `activeLevel = fps.Name 끝자리` (776) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`activeLevel = fps.Name 끝자리` (776)) |
| WK-SCP0114-0018 | X-LOC | `cboDivision`(UsrCombo) + `Division` Lay | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`cboDivision`(UsrCombo) + `Division` Lay) |
| WK-SCP0114-0019 | X-LOC | `p_created_by/p_last_updated_by` = 세션 Us | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`p_created_by/p_last_updated_by` = 세션 Us) |
| WK-SCP0114-0020 | X-LOC | `p_shop_group_id` L1~3 `'-'` / L4~5 `_sh | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`p_shop_group_id` L1~3 `'-'` / L4~5 `_sh) |
| WK-SCP0114-0021 | X-LOC | `p_valid_yn` 전 레벨 `'Y'` 하드코딩 (841/854/86 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`p_valid_yn` 전 레벨 `'Y'` 하드코딩 (841/854/86) |
| WK-SCP0114-0022 | X-LOC | `panel1`(라디오바) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`panel1`(라디오바)) |
| WK-SCP0114-0023 | X-LOC | `panel2/3` + `spdLevel4/5` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`panel2/3` + `spdLevel4/5`) |
| WK-SCP0114-0024 | X-LOC | `panel4/5/6` + `spdLevel1/2/3` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`panel4/5/6` + `spdLevel1/2/3`) |
| WK-SCP0114-0025 | X-LOC | `splitContainer1`(Horizontal, SplitterDi | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`splitContainer1`(Horizontal, SplitterDi) |
| WK-SCP0114-0026 | X-LOC | `usrLabel1`("Product Group") + `rgrpSear | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`usrLabel1`("Product Group") + `rgrpSear) |
| WK-SCP0114-0027 | X-LOC | `usrPanel`(UsrConditionPanel, HidePanel) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`usrPanel`(UsrConditionPanel, HidePanel)) |
| WK-SCP0114-0028 | X-LOC | 결과 `Rows[0][0]=='S'` 분기 (930) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (결과 `Rows[0][0]=='S'` 분기 (930)) |
| WK-SCP0114-0029 | X-LOC | 공통 툴바(Find/Insert/Delete/Edit/Save) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (공통 툴바(Find/Insert/Delete/Edit/Save)) |
| WK-SCP0114-0030 | X-LOC | 드릴다운 `Columns[StringAction].Visible` (17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (드릴다운 `Columns[StringAction].Visible` (17) |
| WK-SCP0114-0031 | X-LOC | 레벨별 미해당 컬럼 `'-'` (832~892) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (레벨별 미해당 컬럼 `'-'` (832~892)) |
| WK-SCP0114-0032 | X-LOC | 성공 후 `FindData(activeLevel)` (935~954) → | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (성공 후 `FindData(activeLevel)` (935~954) →) |
| WK-SCP0114-0033 | X-LOC | 합 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (합) |

## W4 검사기 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0114-0034 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0114_CAPA_LineMaster.getCurrDivis) |
| WK-SCP0114-0035 | B3 | VALID_YN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 VALID_YN | 있음(SHEET_COLUMNS) | 1 (7) |

## W5 검사기 연결 (8)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0114-0036 | B1 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0114-0037 | B2 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0114-0038 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0114_CAPA_LineMaster.getCurrDivis) |
| WK-SCP0114-0039 | B4 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 2 (7 COMMON:UC-05) |
| WK-SCP0114-0040 | F2 | SCP0114 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0114 화면 | 판단불가(대상 단위 SCREEN) | 211 (2 3 4 `SaveData` `_si.ActiveSheet.Rows.C) |
| WK-SCP0114-0041 | F6 | SCP0114 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0114 화면 | 판단불가(대상 단위 SCREEN) | 193 (`SaveData` `_si.ActiveSheet.Rows.Count <) |
| WK-SCP0114-0042 | E5 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0114-0043 | G03-WIRE | SCP0114 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0114 화면 | 판단불가(대상 단위 SCREEN) | 41 (ACT:SCP0114_CAPA_LineMaster..ctor ACT:SC) |

## W6 검증 실행 (161)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0114-0044 | J2 | SCP0114 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0114 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 33 (2 3 4 5 18~22 `InsertRow` `spreadLevel.I) |
| WK-SCP0114-0045 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0114_CAPA_LineMaster.InitControls) |
| WK-SCP0114-0046 | C2 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 56 (ACT:SCP0114_CAPA_LineMaster.RefreshSprea) |
| WK-SCP0114-0047 | C2 | COMPANY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — COMPANY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 51 (ACT:SCP0114_CAPA_LineMaster.RefreshSprea) |
| WK-SCP0114-0048 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SCP0114_CAPA_LineMaster.spdLevel1_Co) |
| WK-SCP0114-0049 | C2 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 16 (ACT:SCP0114_CAPA_LineMaster.RefreshSprea) |
| WK-SCP0114-0050 | C2 | FACTORY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FACTORY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:SCP0114_CAPA_LineMaster.RefreshSprea) |
| WK-SCP0114-0051 | C2 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 15 (ACT:SCP0114_CAPA_LineMaster.RefreshSprea) |
| WK-SCP0114-0052 | C2 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (ACT:SCP0114_CAPA_LineMaster.RefreshSprea) |
| WK-SCP0114-0053 | C2 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 20 (ACT:SCP0114_CAPA_LineMaster.RefreshSprea) |
| WK-SCP0114-0054 | C2 | PLANT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:SCP0114_CAPA_LineMaster.RefreshSprea) |
| WK-SCP0114-0055 | C2 | SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 79 (ACT:SCP0114_CAPA_LineMaster.RefreshSprea) |
| WK-SCP0114-0056 | C2 | SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SITE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 64 (ACT:SCP0114_CAPA_LineMaster.RefreshSprea) |
| WK-SCP0114-0057 | C3 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 53 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0058 | C3 | COMPANY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COMPANY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 49 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0059 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCP0114_CAPA_LineMaster.spdLevel1_Co) |
| WK-SCP0114-0060 | C3 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 13 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0061 | C3 | FACTORY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FACTORY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0062 | C3 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 12 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0063 | C3 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0064 | C3 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 17 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0065 | C3 | PLANT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0066 | C3 | SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 76 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0067 | C3 | SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SITE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 62 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0068 | C6 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 53 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0069 | C6 | COMPANY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — COMPANY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 49 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0070 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SCP0114_CAPA_LineMaster.spdLevel1_Co) |
| WK-SCP0114-0071 | C6 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 13 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0072 | C6 | FACTORY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — FACTORY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0073 | C6 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 12 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0074 | C6 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0075 | C6 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 17 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0076 | C6 | PLANT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0077 | C6 | SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 76 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0078 | C6 | SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SITE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 62 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0079 | G3 | SCP0114 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0114 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (`usrPanel`(UsrConditionPanel, HidePanel)) |
| WK-SCP0114-0080 | K-SA | SCP0114 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0114 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 3 (`usrPanel`(UsrConditionPanel, HidePanel)) |
| WK-SCP0114-0081 | K4 | SCP0114 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0114 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 5 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0114-0082 | F1 | SCP0114 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0114 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 240 (2 3 4 `SaveData` `_si.ActiveSheet.Rows.C) |
| WK-SCP0114-0083 | F3 | SCP0114 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0114 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 21 (18~22 ACT:SCP0114_CAPA_LineMaster.spdLev) |
| WK-SCP0114-0084 | F5 | SCP0114 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0114 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 30 (R18 공통 툴바(Find/Insert/Delete/Edit/Save) ) |
| WK-SCP0114-0085 | F4 | PKG_SCP0114.P_SCP0114_GET_CAPA_LINE_MAST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0114.P_SCP0114_GET_CAPA_LINE_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 294 (ACT:SCP0114_CAPA_LineMaster.FindButton A) |
| WK-SCP0114-0086 | F4 | PKG_SCP0114.P_SCP0114_SAVE_CAPA_LINE_MAS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0114.P_SCP0114_SAVE_CAPA_LINE_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 191 (`GSCM/06.UIL/GSCM.SCP.Forms.UIL/**Master) |
| WK-SCP0114-0087 | A5 | COMPANY_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 10 (R7 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0088 | A5 | COMPANY_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — COMPANY_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 12 (R7 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0089 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 25 (R2 R13 ACT:SCP0114_CAPA_LineMaster.InitS) |
| WK-SCP0114-0090 | A5 | DUMMY_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DUMMY_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (R10 R12 ACT:SCP0114_CAPA_LineMaster.Init) |
| WK-SCP0114-0091 | A5 | FACTORY_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (R9 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0092 | A5 | FACTORY_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FACTORY_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 7 (R9 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0093 | A5 | LINE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (R10 ACT:SCP0114_CAPA_LineMaster.InitSpre) |
| WK-SCP0114-0094 | A5 | LINE_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (R10 ACT:SCP0114_CAPA_LineMaster.InitSpre) |
| WK-SCP0114-0095 | A5 | PLANT_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (R8 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0096 | A5 | PLANT_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLANT_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 10 (R8 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0097 | A5 | SHOP_GROUP_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHOP_GROUP_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (R10 R17 ACT:SCP0114_CAPA_LineMaster.Init) |
| WK-SCP0114-0098 | A5 | SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SITE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 12 (R6 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0099 | A5 | SITE_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SITE_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 14 (R6 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0100 | A5 | SORT_ORDER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SORT_ORDER · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 12 (R11 ACT:SCP0114_CAPA_LineMaster.InitSpre) |
| WK-SCP0114-0101 | A5 | VALID_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 9 (7 R12 Level5 ACT:SCP0114_CAPA_LineMaster) |
| WK-SCP0114-0102 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0114_CAPA_LineMaster.InitControls) |
| WK-SCP0114-0103 | H2 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (R7 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0104 | H2 | COMPANY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — COMPANY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 12 (R7 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0105 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 25 (R2 R13 ACT:SCP0114_CAPA_LineMaster.InitS) |
| WK-SCP0114-0106 | H2 | DUMMY_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DUMMY_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (R10 R12 ACT:SCP0114_CAPA_LineMaster.Init) |
| WK-SCP0114-0107 | H2 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (R9 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0108 | H2 | FACTORY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FACTORY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (R9 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0109 | H2 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (R10 ACT:SCP0114_CAPA_LineMaster.InitSpre) |
| WK-SCP0114-0110 | H2 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (R10 ACT:SCP0114_CAPA_LineMaster.InitSpre) |
| WK-SCP0114-0111 | H2 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (R8 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0112 | H2 | PLANT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (R8 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0113 | H2 | SHOP_GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHOP_GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (R10 R17 ACT:SCP0114_CAPA_LineMaster.Init) |
| WK-SCP0114-0114 | H2 | SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 12 (R6 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0115 | H2 | SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SITE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 14 (R6 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0116 | H2 | SORT_ORDER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SORT_ORDER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 12 (R11 ACT:SCP0114_CAPA_LineMaster.InitSpre) |
| WK-SCP0114-0117 | H2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (7 R12 Level5 ACT:SCP0114_CAPA_LineMaster) |
| WK-SCP0114-0118 | H5 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — COMPANY_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 10 (R7 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0119 | H5 | COMPANY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — COMPANY_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 12 (R7 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0120 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 25 (R2 R13 ACT:SCP0114_CAPA_LineMaster.InitS) |
| WK-SCP0114-0121 | H5 | DUMMY_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DUMMY_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 8 (R10 R12 ACT:SCP0114_CAPA_LineMaster.Init) |
| WK-SCP0114-0122 | H5 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — FACTORY_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (R9 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0123 | H5 | FACTORY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — FACTORY_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 7 (R9 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0124 | H5 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LINE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (R10 ACT:SCP0114_CAPA_LineMaster.InitSpre) |
| WK-SCP0114-0125 | H5 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LINE_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (R10 ACT:SCP0114_CAPA_LineMaster.InitSpre) |
| WK-SCP0114-0126 | H5 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLANT_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 8 (R8 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0127 | H5 | PLANT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLANT_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 10 (R8 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0128 | H5 | SHOP_GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHOP_GROUP_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (R10 R17 ACT:SCP0114_CAPA_LineMaster.Init) |
| WK-SCP0114-0129 | H5 | SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SITE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 12 (R6 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0130 | H5 | SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SITE_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 14 (R6 ACT:SCP0114_CAPA_LineMaster.InitSprea) |
| WK-SCP0114-0131 | H5 | SORT_ORDER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SORT_ORDER · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 12 (R11 ACT:SCP0114_CAPA_LineMaster.InitSpre) |
| WK-SCP0114-0132 | H5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VALID_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 9 (7 R12 Level5 ACT:SCP0114_CAPA_LineMaster) |
| WK-SCP0114-0133 | I1 | SCP0114 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0114 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 13 (2 3 4 `InsertRow` `spreadLevel.IsLock(Sh) |
| WK-SCP0114-0134 | SC1 | SCP0114 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0114 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 0 () |
| WK-SCP0114-0135 | D1 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:SCP0114_CAPA_LineMaster.EditButton A) |
| WK-SCP0114-0136 | D1 | COMPANY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — COMPANY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0114_CAPA_LineMaster.EditButton A) |
| WK-SCP0114-0137 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (R13 ACT:SCP0114_CAPA_LineMaster.EditButt) |
| WK-SCP0114-0138 | D1 | DUMMY_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DUMMY_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 26 (R10 ACT:SCP0114_CAPA_LineMaster.EditButt) |
| WK-SCP0114-0139 | D1 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0114_CAPA_LineMaster.EditButton:6) |
| WK-SCP0114-0140 | D1 | FACTORY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FACTORY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0114_CAPA_LineMaster.EditButton:6) |
| WK-SCP0114-0141 | D1 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (R10 ACT:SCP0114_CAPA_LineMaster.EditButt) |
| WK-SCP0114-0142 | D1 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (R10 ACT:SCP0114_CAPA_LineMaster.EditButt) |
| WK-SCP0114-0143 | D1 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:SCP0114_CAPA_LineMaster.EditButton A) |
| WK-SCP0114-0144 | D1 | PLANT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PLANT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0114_CAPA_LineMaster.EditButton:5) |
| WK-SCP0114-0145 | D1 | SHOP_GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHOP_GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (R10 ACT:SCP0114_CAPA_LineMaster.EditButt) |
| WK-SCP0114-0146 | D1 | SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (R6 ACT:SCP0114_CAPA_LineMaster.EditButto) |
| WK-SCP0114-0147 | D1 | SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SITE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (R6 ACT:SCP0114_CAPA_LineMaster.EditButto) |
| WK-SCP0114-0148 | D1 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (`p_valid_yn` 전 레벨 `'Y'` 하드코딩 (841/854/86) |
| WK-SCP0114-0149 | D3 | COMPANY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — COMPANY_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:SCP0114_CAPA_LineMaster.EditButton A) |
| WK-SCP0114-0150 | D3 | COMPANY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — COMPANY_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0114_CAPA_LineMaster.EditButton A) |
| WK-SCP0114-0151 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (R13 ACT:SCP0114_CAPA_LineMaster.EditButt) |
| WK-SCP0114-0152 | D3 | DUMMY_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DUMMY_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 26 (R10 ACT:SCP0114_CAPA_LineMaster.EditButt) |
| WK-SCP0114-0153 | D3 | FACTORY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FACTORY_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0114_CAPA_LineMaster.EditButton:6) |
| WK-SCP0114-0154 | D3 | FACTORY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FACTORY_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0114_CAPA_LineMaster.EditButton:6) |
| WK-SCP0114-0155 | D3 | LINE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LINE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (R10 ACT:SCP0114_CAPA_LineMaster.EditButt) |
| WK-SCP0114-0156 | D3 | LINE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LINE_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (R10 ACT:SCP0114_CAPA_LineMaster.EditButt) |
| WK-SCP0114-0157 | D3 | PLANT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PLANT_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:SCP0114_CAPA_LineMaster.EditButton A) |
| WK-SCP0114-0158 | D3 | PLANT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PLANT_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0114_CAPA_LineMaster.EditButton:5) |
| WK-SCP0114-0159 | D3 | SHOP_GROUP_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHOP_GROUP_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (R10 ACT:SCP0114_CAPA_LineMaster.EditButt) |
| WK-SCP0114-0160 | D3 | SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (R6 ACT:SCP0114_CAPA_LineMaster.EditButto) |
| WK-SCP0114-0161 | D3 | SITE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SITE_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (R6 ACT:SCP0114_CAPA_LineMaster.EditButto) |
| WK-SCP0114-0162 | D3 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (`p_valid_yn` 전 레벨 `'Y'` 하드코딩 (841/854/86) |
| WK-SCP0114-0163 | D4 | DUMMY_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DUMMY_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R12) |
| WK-SCP0114-0164 | D4 | SORT_ORDER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — SORT_ORDER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R11) |
| WK-SCP0114-0165 | D4 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R12) |
| WK-SCP0114-0166 | D5 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 9 (ACT:SCP0114_CAPA_LineMaster.InitSpread A) |
| WK-SCP0114-0167 | D5 | COMPANY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — COMPANY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 11 (ACT:SCP0114_CAPA_LineMaster.InitSpread A) |
| WK-SCP0114-0168 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 23 (ACT:SCP0114_CAPA_LineMaster.InitSpread A) |
| WK-SCP0114-0169 | D5 | DUMMY_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DUMMY_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SCP0114_CAPA_LineMaster.InitSpread A) |
| WK-SCP0114-0170 | D5 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SCP0114_CAPA_LineMaster.InitSpread A) |
| WK-SCP0114-0171 | D5 | FACTORY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — FACTORY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SCP0114_CAPA_LineMaster.InitSpread:3) |
| WK-SCP0114-0172 | D5 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0114_CAPA_LineMaster.InitSpread:3) |
| WK-SCP0114-0173 | D5 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0114_CAPA_LineMaster.InitSpread:3) |
| WK-SCP0114-0174 | D5 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 7 (ACT:SCP0114_CAPA_LineMaster.InitSpread A) |
| WK-SCP0114-0175 | D5 | PLANT_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PLANT_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 9 (ACT:SCP0114_CAPA_LineMaster.InitSpread A) |
| WK-SCP0114-0176 | D5 | SHOP_GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHOP_GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCP0114_CAPA_LineMaster.InitSpread:3) |
| WK-SCP0114-0177 | D5 | SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 11 (ACT:SCP0114_CAPA_LineMaster.InitSpread A) |
| WK-SCP0114-0178 | D5 | SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SITE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 13 (ACT:SCP0114_CAPA_LineMaster.InitSpread A) |
| WK-SCP0114-0179 | D5 | SORT_ORDER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SORT_ORDER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 11 (ACT:SCP0114_CAPA_LineMaster.InitSpread A) |
| WK-SCP0114-0180 | D5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 7 (COMMON:UC-05 ACT:SCP0114_CAPA_LineMaster) |
| WK-SCP0114-0181 | D6 | SCP0114 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0114 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 8 (`InsertRow` `spreadLevel.IsLock(SheetNam) |
| WK-SCP0114-0182 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (4) |
| WK-SCP0114-0183 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (2 `SaveData` `_si.ActiveSheet.Rows.Count) |
| WK-SCP0114-0184 | E4 | MSG00060 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00060 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (3 S3) |
| WK-SCP0114-0185 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0114-0186 | E4 | MSG00662 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00662 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (`InsertRow` `spreadLevel.IsLock(SheetNam) |
| WK-SCP0114-0187 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (2 COMMON:UC-04) |
| WK-SCP0114-0188 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0114-0189 | A10 | SCP0114 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0114 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 167 (ACT:SCP0114_CAPA_LineMaster.Form_Load AC) |
| WK-SCP0114-0190 | A6 | PKG_SCP0114.P_SCP0114_GET_CAPA_LINE_MAST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0114.P_SCP0114_GET_CAPA_LINE_MASTER · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회 |  | 105 (ACT:SCP0114_CAPA_LineMaster.FindButton A) |
| WK-SCP0114-0191 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0114_CAPA_LineMaster.FindButton A) |
| WK-SCP0114-0192 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCP0114_CAPA_LineMaster.InitControls) |
| WK-SCP0114-0193 | X-REOPEN | SCP0114 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0114 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 11 (ACT:SCP0114_CAPA_LineMaster.Dispose ACT:) |
| WK-SCP0114-0194 | M4 | COMPANY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — COMPANY_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 14 (ACT:SCP0114_CAPA_LineMaster.SpdLevel2_Ce) |
| WK-SCP0114-0195 | M4 | COMPANY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — COMPANY_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0114_CAPA_LineMaster.SpdLevel2_Ce) |
| WK-SCP0114-0196 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 25 (ACT:SCP0114_CAPA_LineMaster.SpdLevel1_Ce) |
| WK-SCP0114-0197 | M4 | FACTORY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — FACTORY_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 8 (ACT:SCP0114_CAPA_LineMaster.SpdLevel4_Ce) |
| WK-SCP0114-0198 | M4 | FACTORY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — FACTORY_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0114_CAPA_LineMaster.SpdLevel4_Ce) |
| WK-SCP0114-0199 | M4 | LINE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — LINE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (ACT:SCP0114_CAPA_LineMaster.SpdLevel5_Ce) |
| WK-SCP0114-0200 | M4 | LINE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — LINE_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0114_CAPA_LineMaster.SpdLevel5_Ce) |
| WK-SCP0114-0201 | M4 | PLANT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PLANT_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 11 (ACT:SCP0114_CAPA_LineMaster.SpdLevel3_Ce) |
| WK-SCP0114-0202 | M4 | PLANT_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PLANT_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0114_CAPA_LineMaster.SpdLevel3_Ce) |
| WK-SCP0114-0203 | M4 | SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 17 (ACT:SCP0114_CAPA_LineMaster.SpdLevel1_Ce) |
| WK-SCP0114-0204 | M4 | SITE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SITE_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0114_CAPA_LineMaster.SpdLevel1_Ce) |

## W7 기대값 확정 (242)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0114-0205 | C1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 7: 행 집계 — C1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0206 | C1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 8: 행 집계 — C1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0207 | C2 | SCP0114_CAPA_LineMaster._defaultDataMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0114_CAPA_LineMaster._defaultDataModel_Changed: 진입점 집계 — C2 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 21 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0208 | C2 | SCP0114_CAPA_LineMaster.cboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0114_CAPA_LineMaster.cboDivision_SelectedIndexC: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.cboDivision_) |
| WK-SCP0114-0209 | C2 | SCP0114_CAPA_LineMaster.rgrpSearchLevel_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0114_CAPA_LineMaster.rgrpSearchLevel_SelectedIn: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0114_CAPA_LineMaster.rgrpSearchLe) |
| WK-SCP0114-0210 | C2 | SCP0114_CAPA_LineMaster.spdAssign_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0114_CAPA_LineMaster.spdAssign_ComboSelChange: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SCP0114_CAPA_LineMaster.spdAssign_Co) |
| WK-SCP0114-0211 | C2 | SCP0114_CAPA_LineMaster.spdLevel1_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel1_ComboSelChange: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.spdLevel1_Co) |
| WK-SCP0114-0212 | C2 | SCP0114_CAPA_LineMaster.spdLevel2_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel2_ComboSelChange: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.spdLevel2_Co) |
| WK-SCP0114-0213 | C3 | 18~22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 18~22: 행 집계 — C3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (18~22) |
| WK-SCP0114-0214 | C3 | SCP0114_CAPA_LineMaster.SetSpreadNameToC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0114_CAPA_LineMaster.SetSpreadNameToCode: 진입점 집계 — C3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 32 (ACT:SCP0114_CAPA_LineMaster.SetSpreadNam) |
| WK-SCP0114-0215 | C3 | SCP0114_CAPA_LineMaster._defaultDataMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0114_CAPA_LineMaster._defaultDataModel_Changed: 진입점 집계 — C3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 21 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0216 | C3 | SCP0114_CAPA_LineMaster.cboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0114_CAPA_LineMaster.cboDivision_SelectedIndexC: 진입점 집계 — C3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.cboDivision_) |
| WK-SCP0114-0217 | C3 | SCP0114_CAPA_LineMaster.rgrpSearchLevel_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0114_CAPA_LineMaster.rgrpSearchLevel_SelectedIn: 진입점 집계 — C3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0114_CAPA_LineMaster.rgrpSearchLe) |
| WK-SCP0114-0218 | C3 | SCP0114_CAPA_LineMaster.spdAssign_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0114_CAPA_LineMaster.spdAssign_ComboSelChange: 진입점 집계 — C3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SCP0114_CAPA_LineMaster.spdAssign_Co) |
| WK-SCP0114-0219 | C3 | SCP0114_CAPA_LineMaster.spdLevel1_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel1_ComboSelChange: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.spdLevel1_Co) |
| WK-SCP0114-0220 | C3 | SCP0114_CAPA_LineMaster.spdLevel2_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel2_ComboSelChange: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.spdLevel2_Co) |
| WK-SCP0114-0221 | C6 | SCP0114_CAPA_LineMaster._defaultDataMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0114_CAPA_LineMaster._defaultDataModel_Changed: 진입점 집계 — C6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 21 (ACT:SCP0114_CAPA_LineMaster._defaultData) |
| WK-SCP0114-0222 | C6 | SCP0114_CAPA_LineMaster.cboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0114_CAPA_LineMaster.cboDivision_SelectedIndexC: 진입점 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.cboDivision_) |
| WK-SCP0114-0223 | C6 | SCP0114_CAPA_LineMaster.rgrpSearchLevel_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0114_CAPA_LineMaster.rgrpSearchLevel_SelectedIn: 진입점 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0114_CAPA_LineMaster.rgrpSearchLe) |
| WK-SCP0114-0224 | C6 | SCP0114_CAPA_LineMaster.spdAssign_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0114_CAPA_LineMaster.spdAssign_ComboSelChange: 진입점 집계 — C6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SCP0114_CAPA_LineMaster.spdAssign_Co) |
| WK-SCP0114-0225 | C6 | SCP0114_CAPA_LineMaster.spdLevel1_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel1_ComboSelChange: 진입점 집계 — C6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.spdLevel1_Co) |
| WK-SCP0114-0226 | C6 | SCP0114_CAPA_LineMaster.spdLevel2_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel2_ComboSelChange: 진입점 집계 — C6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.spdLevel2_Co) |
| WK-SCP0114-0227 | B3 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 1: 행 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0114-0228 | B3 | SCP0114_CAPA_LineMaster.getCurrDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0114_CAPA_LineMaster.getCurrDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0114_CAPA_LineMaster.getCurrDivis) |
| WK-SCP0114-0229 | B4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 1: 행 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0114-0230 | B4 | SCP0114_CAPA_LineMaster.getCurrDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0114_CAPA_LineMaster.getCurrDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0114_CAPA_LineMaster.getCurrDivis) |
| WK-SCP0114-0231 | F4 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 12: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0232 | F4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 2: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0233 | F4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 7: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0234 | F4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 8: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0235 | F4 | `SaveData` `_si.ActiveSheet.Rows.Count < | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `SaveData` `_si.ActiveSheet.Rows.Count <= 0` (782): 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`SaveData` `_si.ActiveSheet.Rows.Count <) |
| WK-SCP0114-0236 | F4 | `SaveData` `_si.IsLock(SheetName) == fal | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `SaveData` `_si.IsLock(SheetName) == false` (784): 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`SaveData` `_si.IsLock(SheetName) == fal) |
| WK-SCP0114-0237 | F4 | 성공 후 `FindData(activeLevel)` (935~954) → | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 성공 후 `FindData(activeLevel)` (935~954) → `InitSpre: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (성공 후 `FindData(activeLevel)` (935~954) →) |
| WK-SCP0114-0238 | A5 | 13~17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 13~17: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (13~17) |
| WK-SCP0114-0239 | A5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 4: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0240 | A5 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 7: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0241 | A5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-01: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0114-0242 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0114-0243 | A5 | Level1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Level1: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Level1) |
| WK-SCP0114-0244 | A5 | Level2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Level2: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Level2) |
| WK-SCP0114-0245 | A5 | Level3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Level3: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Level3) |
| WK-SCP0114-0246 | A5 | Level4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Level4: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Level4) |
| WK-SCP0114-0247 | A5 | R1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R1: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R1) |
| WK-SCP0114-0248 | A5 | R14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R14: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R14) |
| WK-SCP0114-0249 | A5 | R15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R15: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R15) |
| WK-SCP0114-0250 | A5 | R16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R16: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R16) |
| WK-SCP0114-0251 | A5 | R18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R18: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R18) |
| WK-SCP0114-0252 | A5 | R3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R3: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R3) |
| WK-SCP0114-0253 | A5 | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R4: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R4) |
| WK-SCP0114-0254 | A5 | R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R5: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R5) |
| WK-SCP0114-0255 | A5 | SCP0114_CAPA_LineMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0114_CAPA_LineMaster.CreateSpread: 진입점 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 35 (ACT:SCP0114_CAPA_LineMaster.CreateSpread) |
| WK-SCP0114-0256 | A5 | SCP0114_CAPA_LineMaster.SetSpreadNameToC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0114_CAPA_LineMaster.SetSpreadNameToCode: 진입점 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 32 (ACT:SCP0114_CAPA_LineMaster.SetSpreadNam) |
| WK-SCP0114-0257 | A5 | `activeLevel = fps.Name 끝자리` (776) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `activeLevel = fps.Name 끝자리` (776): 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`activeLevel = fps.Name 끝자리` (776)) |
| WK-SCP0114-0258 | A5 | `panel2/3` + `spdLevel4/5` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `panel2/3` + `spdLevel4/5`: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`panel2/3` + `spdLevel4/5`) |
| WK-SCP0114-0259 | A5 | 합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 합: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (합) |
| WK-SCP0114-0260 | G4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 7: 행 집계 — G4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0261 | H2 | 13~17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 13~17: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (13~17) |
| WK-SCP0114-0262 | H2 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 4: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0263 | H2 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 7: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0264 | H2 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-01: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0114-0265 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0114-0266 | H2 | Level1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Level1: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Level1) |
| WK-SCP0114-0267 | H2 | Level2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Level2: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Level2) |
| WK-SCP0114-0268 | H2 | Level3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Level3: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Level3) |
| WK-SCP0114-0269 | H2 | Level4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Level4: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Level4) |
| WK-SCP0114-0270 | H2 | R1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R1: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R1) |
| WK-SCP0114-0271 | H2 | R14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R14: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R14) |
| WK-SCP0114-0272 | H2 | R15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R15: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R15) |
| WK-SCP0114-0273 | H2 | R16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R16: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R16) |
| WK-SCP0114-0274 | H2 | R18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R18: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R18) |
| WK-SCP0114-0275 | H2 | R3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R3: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R3) |
| WK-SCP0114-0276 | H2 | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R4: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R4) |
| WK-SCP0114-0277 | H2 | R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R5: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R5) |
| WK-SCP0114-0278 | H2 | SCP0114_CAPA_LineMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0114_CAPA_LineMaster.CreateSpread: 진입점 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 35 (ACT:SCP0114_CAPA_LineMaster.CreateSpread) |
| WK-SCP0114-0279 | H2 | SCP0114_CAPA_LineMaster.SetSpreadNameToC | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0114_CAPA_LineMaster.SetSpreadNameToCode: 진입점 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 32 (ACT:SCP0114_CAPA_LineMaster.SetSpreadNam) |
| WK-SCP0114-0280 | H2 | `activeLevel = fps.Name 끝자리` (776) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `activeLevel = fps.Name 끝자리` (776): 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`activeLevel = fps.Name 끝자리` (776)) |
| WK-SCP0114-0281 | H2 | `panel2/3` + `spdLevel4/5` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `panel2/3` + `spdLevel4/5`: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`panel2/3` + `spdLevel4/5`) |
| WK-SCP0114-0282 | H2 | 공통 툴바(Find/Insert/Delete/Edit/Save) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 공통 툴바(Find/Insert/Delete/Edit/Save): 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (공통 툴바(Find/Insert/Delete/Edit/Save)) |
| WK-SCP0114-0283 | H2 | 브라우저 시각·조작감(셀 색/드롭다운/토스트/스플리터) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 브라우저 시각·조작감(셀 색/드롭다운/토스트/스플리터): 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 시각·조작감(셀 색/드롭다운/토스트/스플리터)) |
| WK-SCP0114-0284 | H2 | 합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 합: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (합) |
| WK-SCP0114-0285 | H5 | 13~17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 13~17: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (13~17) |
| WK-SCP0114-0286 | H5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 4: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0287 | H5 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 7: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0288 | H5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-01: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0114-0289 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0114-0290 | H5 | Level1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Level1: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Level1) |
| WK-SCP0114-0291 | H5 | Level2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Level2: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Level2) |
| WK-SCP0114-0292 | H5 | Level3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Level3: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Level3) |
| WK-SCP0114-0293 | H5 | Level4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Level4: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Level4) |
| WK-SCP0114-0294 | H5 | R1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R1: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R1) |
| WK-SCP0114-0295 | H5 | R14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R14: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R14) |
| WK-SCP0114-0296 | H5 | R15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R15: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R15) |
| WK-SCP0114-0297 | H5 | R16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R16: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R16) |
| WK-SCP0114-0298 | H5 | R18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R18: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R18) |
| WK-SCP0114-0299 | H5 | R3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R3: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R3) |
| WK-SCP0114-0300 | H5 | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R4: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R4) |
| WK-SCP0114-0301 | H5 | R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R5: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (R5) |
| WK-SCP0114-0302 | H5 | SCP0114_CAPA_LineMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0114_CAPA_LineMaster.CreateSpread: 진입점 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 35 (ACT:SCP0114_CAPA_LineMaster.CreateSpread) |
| WK-SCP0114-0303 | H5 | SCP0114_CAPA_LineMaster.SetSpreadNameToC | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0114_CAPA_LineMaster.SetSpreadNameToCode: 진입점 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 32 (ACT:SCP0114_CAPA_LineMaster.SetSpreadNam) |
| WK-SCP0114-0304 | H5 | `activeLevel = fps.Name 끝자리` (776) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `activeLevel = fps.Name 끝자리` (776): 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`activeLevel = fps.Name 끝자리` (776)) |
| WK-SCP0114-0305 | H5 | `panel2/3` + `spdLevel4/5` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `panel2/3` + `spdLevel4/5`: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`panel2/3` + `spdLevel4/5`) |
| WK-SCP0114-0306 | H5 | 합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 합: 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (합) |
| WK-SCP0114-0307 | X-REASON | 2~6 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 2~6 `Data_SCP.CommonAll(Capa{Site,Company,Plant,Factory,Line})` (64~68) AS-IS 에서도 소비 지점(`RefreshSpreadAll`)이 `I |  | 1 (2~6) |
| WK-SCP0114-0308 | X-REASON | 6 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 6 Change `spreadLevel == null` (1733) 그리드별 핸들러라 sender 가 항상 존재 — 구조상 해소 해당없음 |  | 1 (6) |
| WK-SCP0114-0309 | X-REASON | `RefreshEnabled()` (1705) — 5그리드 항상 `Ena | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `RefreshEnabled()` (1705) — 5그리드 항상 `Enabled=true` 동적 enable 분기 없음(도입하지 않음) 해당없음 |  | 1 (`RefreshEnabled()` (1705) — 5그리드 항상 `Ena) |
| WK-SCP0114-0310 | D1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 10: 행 집계 — D1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0311 | D1 | 18~22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 18~22: 행 집계 — D1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (18~22) |
| WK-SCP0114-0312 | D1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 4: 행 집계 — D1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0313 | D1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 5: 행 집계 — D1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0114-0314 | D1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 7: 행 집계 — D1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0315 | D1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 8: 행 집계 — D1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0316 | D1 | R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R5: 행 집계 — D1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (R5) |
| WK-SCP0114-0317 | D1 | SCP0114_CAPA_LineMaster.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0114_CAPA_LineMaster.EditButton: 진입점 집계 — D1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 55 (ACT:SCP0114_CAPA_LineMaster.EditButton:4) |
| WK-SCP0114-0318 | D1 | 공통 툴바(Find/Insert/Delete/Edit/Save) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 공통 툴바(Find/Insert/Delete/Edit/Save): 행 집계 — D1 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (공통 툴바(Find/Insert/Delete/Edit/Save)) |
| WK-SCP0114-0319 | D3 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 10: 행 집계 — D3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0320 | D3 | 18~22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 18~22: 행 집계 — D3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (18~22) |
| WK-SCP0114-0321 | D3 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 4: 행 집계 — D3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0322 | D3 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 5: 행 집계 — D3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0114-0323 | D3 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 7: 행 집계 — D3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0324 | D3 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 8: 행 집계 — D3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0325 | D3 | R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R5: 행 집계 — D3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (R5) |
| WK-SCP0114-0326 | D3 | SCP0114_CAPA_LineMaster.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0114_CAPA_LineMaster.EditButton: 진입점 집계 — D3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 55 (ACT:SCP0114_CAPA_LineMaster.EditButton:4) |
| WK-SCP0114-0327 | D3 | 공통 툴바(Find/Insert/Delete/Edit/Save) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 공통 툴바(Find/Insert/Delete/Edit/Save): 행 집계 — D3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (공통 툴바(Find/Insert/Delete/Edit/Save)) |
| WK-SCP0114-0328 | D4 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 11: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0329 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0114-0330 | D4 | R3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — R3: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R3) |
| WK-SCP0114-0331 | D4 | S3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — S3: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (S3) |
| WK-SCP0114-0332 | D4 | `InsertRow` `spreadLevel.IsLock(SheetNam | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — `InsertRow` `spreadLevel.IsLock(SheetName) == fals: 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`InsertRow` `spreadLevel.IsLock(SheetNam) |
| WK-SCP0114-0333 | D4 | 공통 툴바(Find/Insert/Delete/Edit/Save) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 공통 툴바(Find/Insert/Delete/Edit/Save): 행 집계 — D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (공통 툴바(Find/Insert/Delete/Edit/Save)) |
| WK-SCP0114-0334 | D5 | SCP0114_CAPA_LineMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0114_CAPA_LineMaster.CreateSpread: 진입점 집계 — D5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 35 (ACT:SCP0114_CAPA_LineMaster.CreateSpread) |
| WK-SCP0114-0335 | D5 | SCP0114_CAPA_LineMaster.SetSpreadNameToC | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0114_CAPA_LineMaster.SetSpreadNameToCode: 진입점 집계 — D5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 32 (ACT:SCP0114_CAPA_LineMaster.SetSpreadNam) |
| WK-SCP0114-0336 | E4 | SCP0114_CAPA_LineMaster.SetSpreadNameToC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0114_CAPA_LineMaster.SetSpreadNameToCode: 진입점 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 32 (ACT:SCP0114_CAPA_LineMaster.SetSpreadNam) |
| WK-SCP0114-0337 | E4 | 브라우저 시각·조작감(셀 색/드롭다운/토스트/스플리터) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 브라우저 시각·조작감(셀 색/드롭다운/토스트/스플리터): 행 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 시각·조작감(셀 색/드롭다운/토스트/스플리터)) |
| WK-SCP0114-0338 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-SCP0114-0339 | A1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 12: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-SCP0114-0340 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-SCP0114-0341 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 1요소: REVIEW:1 |  | 0 () |
| WK-SCP0114-0342 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0114-0343 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0114-0344 | A1 | PKG_SCP0114.P_SCP0114_GET_CAPA_LINE_MAST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0114.P_SCP0114_GET_CAPA_LINE_MASTER: 골든 비교 케이스 없음(PKG_SCP0114.P_SCP0114_GET_CAPA_LINE_MASTER — 팝업·보조 SP 는 golde |  | 105 (ACT:SCP0114_CAPA_LineMaster.FindButton A) |
| WK-SCP0114-0345 | A1 | R17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R17: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (R17) |
| WK-SCP0114-0346 | A1 | R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R5: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (R5) |
| WK-SCP0114-0347 | A1 | `panel1`(라디오바) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `panel1`(라디오바): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`panel1`(라디오바)) |
| WK-SCP0114-0348 | A1 | 공통 툴바(Find/Insert/Delete/Edit/Save) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 공통 툴바(Find/Insert/Delete/Edit/Save): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (공통 툴바(Find/Insert/Delete/Edit/Save)) |
| WK-SCP0114-0349 | A1 | 성공 후 `FindData(activeLevel)` (935~954) → | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 성공 후 `FindData(activeLevel)` (935~954) → `InitSpre: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (성공 후 `FindData(activeLevel)` (935~954) →) |
| WK-SCP0114-0350 | A6 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 12: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0351 | A6 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 7: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0352 | A6 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 8: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0353 | A6 | 성공 후 `FindData(activeLevel)` (935~954) → | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 성공 후 `FindData(activeLevel)` (935~954) → `InitSpre: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (성공 후 `FindData(activeLevel)` (935~954) →) |
| WK-SCP0114-0354 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0355 | G1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 12: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0356 | G1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 7: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0357 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0114-0358 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0114-0359 | G1 | R17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R17: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R17) |
| WK-SCP0114-0360 | G1 | R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R5: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R5) |
| WK-SCP0114-0361 | G1 | `panel1`(라디오바) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `panel1`(라디오바): 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`panel1`(라디오바)) |
| WK-SCP0114-0362 | G1 | 공통 툴바(Find/Insert/Delete/Edit/Save) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 공통 툴바(Find/Insert/Delete/Edit/Save): 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (공통 툴바(Find/Insert/Delete/Edit/Save)) |
| WK-SCP0114-0363 | G1 | 성공 후 `FindData(activeLevel)` (935~954) → | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 성공 후 `FindData(activeLevel)` (935~954) → `InitSpre: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (성공 후 `FindData(activeLevel)` (935~954) →) |
| WK-SCP0114-0364 | G6 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 7: 행 집계 — G6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0365 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0114-0366 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0114-0367 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-SCP0114-0368 | X-LOC | 13~17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13~17: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (13~17) |
| WK-SCP0114-0369 | X-LOC | 18~22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 18~22: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (18~22) |
| WK-SCP0114-0370 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0114-0371 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0114-0372 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0114-0373 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0114-0374 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-SCP0114-0375 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0114-0376 | X-LOC | `GSCM/06.UIL/GSCM.SCP.Forms.UIL/**Master | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `GSCM/06.UIL/GSCM.SCP.Forms.UIL/**Master**/SCP0114: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`GSCM/06.UIL/GSCM.SCP.Forms.UIL/**Master) |
| WK-SCP0114-0377 | X-LOC | `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/SCP0114_CAP: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/S) |
| WK-SCP0114-0378 | X-LOC | `PKG_SCP0114` GET/SAVE 런타임 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `PKG_SCP0114` GET/SAVE 런타임: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`PKG_SCP0114` GET/SAVE 런타임) |
| WK-SCP0114-0379 | X-LOC | `SCM_ADM_PROC_M` 파라미터 메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SCM_ADM_PROC_M` 파라미터 메타: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SCM_ADM_PROC_M` 파라미터 메타) |
| WK-SCP0114-0380 | X-LOC | 브라우저 시각·조작감(셀 색/드롭다운/토스트/스플리터) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 브라우저 시각·조작감(셀 색/드롭다운/토스트/스플리터): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (브라우저 시각·조작감(셀 색/드롭다운/토스트/스플리터)) |
| WK-SCP0114-0381 | X-ROW | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (10) |
| WK-SCP0114-0382 | X-ROW | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 11: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (11) |
| WK-SCP0114-0383 | X-ROW | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (12) |
| WK-SCP0114-0384 | X-ROW | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 8: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0114-0385 | X-ROW | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 9: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (9) |
| WK-SCP0114-0386 | X-ROW | SCP0114_CAPA_LineMaster.CheckDummyDuplic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.CheckDummyDuplication: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/FLOW/LOCAL/RETURN, |  | 104 (ACT:SCP0114_CAPA_LineMaster.CheckDummyDu) |
| WK-SCP0114-0387 | X-ROW | SCP0114_CAPA_LineMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.CreateSpread) |
| WK-SCP0114-0388 | X-ROW | SCP0114_CAPA_LineMaster.EditModesCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.EditModesCheck: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/FLOW, 연결된 요소 검사 없음 |  | 23 (ACT:SCP0114_CAPA_LineMaster.EditModesChe) |
| WK-SCP0114-0389 | X-ROW | SCP0114_CAPA_LineMaster.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.FindData: 진입점 집계 5검사 — NOT_RUN:3 · REVIEW:1 · PASS:1 |  | 5 (ACT:SCP0114_CAPA_LineMaster.FindData ACT) |
| WK-SCP0114-0390 | X-ROW | SCP0114_CAPA_LineMaster.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.Form_Load) |
| WK-SCP0114-0391 | X-ROW | SCP0114_CAPA_LineMaster.IconFileDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.IconFileDialog: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/POPUP/RETURN/UI_PROP, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0114_CAPA_LineMaster.IconFileDial) |
| WK-SCP0114-0392 | X-ROW | SCP0114_CAPA_LineMaster.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0114_CAPA_LineMaster.InitControls) |
| WK-SCP0114-0393 | X-ROW | SCP0114_CAPA_LineMaster.InitEditModes | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.InitEditModes: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.InitEditMode) |
| WK-SCP0114-0394 | X-ROW | SCP0114_CAPA_LineMaster.InitSheetDatas | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.InitSheetDatas: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.InitSheetDat) |
| WK-SCP0114-0395 | X-ROW | SCP0114_CAPA_LineMaster.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.InitSpread: 진입점 집계 61검사 — NOT_RUN:61 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.InitSpread) |
| WK-SCP0114-0396 | X-ROW | SCP0114_CAPA_LineMaster.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.InsertButton) |
| WK-SCP0114-0397 | X-ROW | SCP0114_CAPA_LineMaster.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.InsertRow: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 127 (ACT:SCP0114_CAPA_LineMaster.InsertRow AC) |
| WK-SCP0114-0398 | X-ROW | SCP0114_CAPA_LineMaster.RefreshAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.RefreshAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0114_CAPA_LineMaster.RefreshAll A) |
| WK-SCP0114-0399 | X-ROW | SCP0114_CAPA_LineMaster.RefreshCompanySp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.RefreshCompanySpread: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 9 (ACT:SCP0114_CAPA_LineMaster.RefreshCompa) |
| WK-SCP0114-0400 | X-ROW | SCP0114_CAPA_LineMaster.RefreshEditMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.RefreshEditMode: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY, 연결된 요소 검사 없음 |  | 6 (ACT:SCP0114_CAPA_LineMaster.RefreshEditM) |
| WK-SCP0114-0401 | X-ROW | SCP0114_CAPA_LineMaster.RefreshEnabled | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.RefreshEnabled: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/STATE, 연결된 요소 검사 없음 |  | 6 (ACT:SCP0114_CAPA_LineMaster.RefreshEnabl) |
| WK-SCP0114-0402 | X-ROW | SCP0114_CAPA_LineMaster.RefreshFactorySp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.RefreshFactorySpread: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 9 (ACT:SCP0114_CAPA_LineMaster.RefreshFacto) |
| WK-SCP0114-0403 | X-ROW | SCP0114_CAPA_LineMaster.RefreshLineSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.RefreshLineSpread: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 9 (ACT:SCP0114_CAPA_LineMaster.RefreshLineS) |
| WK-SCP0114-0404 | X-ROW | SCP0114_CAPA_LineMaster.RefreshPlantSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.RefreshPlantSpread: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 9 (ACT:SCP0114_CAPA_LineMaster.RefreshPlant) |
| WK-SCP0114-0405 | X-ROW | SCP0114_CAPA_LineMaster.RefreshSiteAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.RefreshSiteAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/COMBO_DATA/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0114_CAPA_LineMaster.RefreshSiteA) |
| WK-SCP0114-0406 | X-ROW | SCP0114_CAPA_LineMaster.RefreshSiteSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.RefreshSiteSpread: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 9 (ACT:SCP0114_CAPA_LineMaster.RefreshSiteS) |
| WK-SCP0114-0407 | X-ROW | SCP0114_CAPA_LineMaster.RefreshSpreadAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.RefreshSpreadAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 11 (ACT:SCP0114_CAPA_LineMaster.RefreshSprea) |
| WK-SCP0114-0408 | X-ROW | SCP0114_CAPA_LineMaster.RefreshSpreadCom | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.RefreshSpreadComboAll: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0114_CAPA_LineMaster.RefreshSprea) |
| WK-SCP0114-0409 | X-ROW | SCP0114_CAPA_LineMaster.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.SaveData: 진입점 집계 10검사 — NOT_RUN:6 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.SaveData:771) |
| WK-SCP0114-0410 | X-ROW | SCP0114_CAPA_LineMaster.SetSpreadNameToC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.SetSpreadNameToCode: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.SetSpreadNam) |
| WK-SCP0114-0411 | X-ROW | SCP0114_CAPA_LineMaster.SpdLevel1_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.SpdLevel1_CellDoubleClick: 진입점 집계 6검사 — NOT_RUN:4 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.SpdLevel1_Ce) |
| WK-SCP0114-0412 | X-ROW | SCP0114_CAPA_LineMaster.SpdLevel2_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.SpdLevel2_CellDoubleClick: 진입점 집계 7검사 — NOT_RUN:5 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.SpdLevel2_Ce) |
| WK-SCP0114-0413 | X-ROW | SCP0114_CAPA_LineMaster.SpdLevel3_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.SpdLevel3_CellDoubleClick: 진입점 집계 8검사 — NOT_RUN:6 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.SpdLevel3_Ce) |
| WK-SCP0114-0414 | X-ROW | SCP0114_CAPA_LineMaster.SpdLevel4_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.SpdLevel4_CellDoubleClick: 진입점 집계 9검사 — NOT_RUN:7 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.SpdLevel4_Ce) |
| WK-SCP0114-0415 | X-ROW | SCP0114_CAPA_LineMaster.SpdLevel5_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.SpdLevel5_CellDoubleClick: 진입점 집계 10검사 — NOT_RUN:8 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.SpdLevel5_Ce) |
| WK-SCP0114-0416 | X-ROW | SCP0114_CAPA_LineMaster.cboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.cboDivision_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.cboDivision_) |
| WK-SCP0114-0417 | X-ROW | SCP0114_CAPA_LineMaster.rgrpSearchLevel_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.rgrpSearchLevel_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.rgrpSearchLe) |
| WK-SCP0114-0418 | X-ROW | SCP0114_CAPA_LineMaster.spdAssign_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spdAssign_Change: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/EXPR/LOCAL/RETURN, 연결된  |  | 7 (ACT:SCP0114_CAPA_LineMaster.spdAssign_Ch) |
| WK-SCP0114-0419 | X-ROW | SCP0114_CAPA_LineMaster.spdAssign_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spdAssign_ComboSelChange: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.spdAssign_Co) |
| WK-SCP0114-0420 | X-ROW | SCP0114_CAPA_LineMaster.spdLevel1_CellCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel1_CellClick: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0114_CAPA_LineMaster.spdLevel1_Ce) |
| WK-SCP0114-0421 | X-ROW | SCP0114_CAPA_LineMaster.spdLevel1_Clipbo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel1_ClipboardPasted: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.spdLevel1_Cl) |
| WK-SCP0114-0422 | X-ROW | SCP0114_CAPA_LineMaster.spdLevel2_CellCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel2_CellClick: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0114_CAPA_LineMaster.spdLevel2_Ce) |
| WK-SCP0114-0423 | X-ROW | SCP0114_CAPA_LineMaster.spdLevel2_Clipbo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel2_ClipboardPasted: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.spdLevel2_Cl) |
| WK-SCP0114-0424 | X-ROW | SCP0114_CAPA_LineMaster.spdLevel3_CellCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel3_CellClick: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0114_CAPA_LineMaster.spdLevel3_Ce) |
| WK-SCP0114-0425 | X-ROW | SCP0114_CAPA_LineMaster.spdLevel3_Clipbo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel3_ClipboardPasted: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.spdLevel3_Cl) |
| WK-SCP0114-0426 | X-ROW | SCP0114_CAPA_LineMaster.spdLevel4_CellCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel4_CellClick: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0114_CAPA_LineMaster.spdLevel4_Ce) |
| WK-SCP0114-0427 | X-ROW | SCP0114_CAPA_LineMaster.spdLevel4_Clipbo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel4_ClipboardPasted: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.spdLevel4_Cl) |
| WK-SCP0114-0428 | X-ROW | SCP0114_CAPA_LineMaster.spdLevel5_CellCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel5_CellClick: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0114_CAPA_LineMaster.spdLevel5_Ce) |
| WK-SCP0114-0429 | X-ROW | SCP0114_CAPA_LineMaster.spdLevel5_Clipbo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spdLevel5_ClipboardPasted: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0114_CAPA_LineMaster.spdLevel5_Cl) |
| WK-SCP0114-0430 | X-ROW | SCP0114_CAPA_LineMaster.spreadNow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0114_CAPA_LineMaster.spreadNow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/FLOW/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 15 (ACT:SCP0114_CAPA_LineMaster.spreadNow AC) |
| WK-SCP0114-0431 | X-ROW | `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/SCP0114_CAP: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`GSCM/06.UIL/GSCM.SCP.Forms.UIL/Report/S) |
| WK-SCP0114-0432 | X-ROW | `cboDivision`(UsrCombo) + `Division` Lay | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `cboDivision`(UsrCombo) + `Division` LayoutControl: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`cboDivision`(UsrCombo) + `Division` Lay) |
| WK-SCP0114-0433 | X-ROW | `panel4/5/6` + `spdLevel1/2/3` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `panel4/5/6` + `spdLevel1/2/3`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`panel4/5/6` + `spdLevel1/2/3`) |
| WK-SCP0114-0434 | X-ROW | `splitContainer1`(Horizontal, SplitterDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `splitContainer1`(Horizontal, SplitterDistance=271: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`splitContainer1`(Horizontal, SplitterDi) |
| WK-SCP0114-0435 | X-ROW | `usrLabel1`("Product Group") + `rgrpSear | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `usrLabel1`("Product Group") + `rgrpSearchLevel`(R: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`usrLabel1`("Product Group") + `rgrpSear) |
| WK-SCP0114-0436 | X-ROW | 드릴다운 `Columns[StringAction].Visible` (17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 드릴다운 `Columns[StringAction].Visible` (1748/1767/17: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (드릴다운 `Columns[StringAction].Visible` (17) |
| WK-SCP0114-0437 | M4 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 12: 행 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0438 | M4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 3: 행 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0439 | M4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 4: 행 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0440 | M4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 5: 행 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0441 | M4 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 6: 행 집계 — M4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0114-0442 | M4 | SCP0114_CAPA_LineMaster.SpdLevel1_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0114_CAPA_LineMaster.SpdLevel1_CellDoubleClick: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.SpdLevel1_Ce) |
| WK-SCP0114-0443 | M4 | SCP0114_CAPA_LineMaster.SpdLevel2_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0114_CAPA_LineMaster.SpdLevel2_CellDoubleClick: 진입점 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.SpdLevel2_Ce) |
| WK-SCP0114-0444 | M4 | SCP0114_CAPA_LineMaster.SpdLevel3_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0114_CAPA_LineMaster.SpdLevel3_CellDoubleClick: 진입점 집계 — M4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.SpdLevel3_Ce) |
| WK-SCP0114-0445 | M4 | SCP0114_CAPA_LineMaster.SpdLevel4_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0114_CAPA_LineMaster.SpdLevel4_CellDoubleClick: 진입점 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0114_CAPA_LineMaster.SpdLevel4_Ce) |
| WK-SCP0114-0446 | M4 | SCP0114_CAPA_LineMaster.SpdLevel5_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0114_CAPA_LineMaster.SpdLevel5_CellDoubleClick: 진입점 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0114_CAPA_LineMaster.SpdLevel5_Ce) |
