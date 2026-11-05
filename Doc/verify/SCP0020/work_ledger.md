# 작업 원장 — SCP0020 · 2026-10-30 12:21

> 검사 인스턴스 555건 중 PASS·NA 413건 외 **142건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_FE** — FE 항목은 적용 대상. 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 1 | 구현 위치 실존 |
| W3 | 동작 수정 | 16 | 재판정 PASS |
| W5 | 검사기 연결 | 2 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 3 | 실행 → PASS |
| W7 | 기대값 확정 | 55 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 65 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 65 · 사람 판정 / AS-IS 원문 확인 → 재판정 53 · DB 메타 7 · 화면 FE 5 · 대조표 3 · DB 객체 3 · E2E 3 · 하네스 2 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| D3 | EDIT |  |  |  |  |  |  |  |  | 36 | 행 값 기반 조건부 잠금 |
| X-ROW | GEN |  |  | 5 |  |  |  | 15 |  | 7 | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 1 |  |  |  |  | 21 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A1 | GEN |  |  |  |  |  |  | 11 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| E4 | EDIT |  |  | 3 |  |  |  |  |  | 5 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G1 | GEN |  |  |  |  |  |  |  |  | 8 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A5 | DESIGN |  |  | 7 |  |  |  |  |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 6 | 연쇄 자동 채움 |
| A6 | GEN |  |  |  |  |  |  | 4 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| DB-SYN | DB |  |  |  |  | 2 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G4 | DESIGN |  |  |  |  |  | 2 |  |  |  | 조회조건 표시·라벨·활성 |
| X-REASON | DESIGN |  |  |  |  |  |  | 2 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| I1 | DESIGN |  |  |  |  |  |  | 1 |  |  | LBL/MSG 언어별 등록 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |

## W2 구현 위치 확인 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0001 | X-LOC | 2 조회 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: modals/ItemSearchModal.tsx 없음 |  | 1 (2 조회) |

## W3 동작 수정 (16)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0002 | A5 | 2 조회 | DB 메타(적용 예정) | A5 FAIL 수정 — 2 조회: 행 집계 — 대조표 2 조회 'btnItemId / txtItemId' 의 A5 3요소: PASS:2 · FAIL:1 · FAIL 요소: OPERATION_NAME / Operation — 실측[T- |  | 0 () |
| WK-SCP0020-0003 | A5 | 3 그리드 | DB 메타(적용 예정) | A5 FAIL 수정 — 3 그리드: 행 집계 — 대조표 3 그리드 'spdExcept' 의 A5 3요소: PASS:2 · FAIL:1 · FAIL 요소: OPERATION_NAME / Operation — 실측[T-6b72d463]: |  | 1 (3 그리드) |
| WK-SCP0020-0004 | A5 | COMMON:UC-01 | DB 메타(적용 예정) | A5 FAIL 수정 — COMMON:UC-01: 행 집계 — 대조표 COMMON:UC-01 '필터링 상태에서 신규행 Insert 시 필터를 유지한 채 추가 행이 보이도록 (keepRo' 의 A5 3요소: PASS:2 · FAIL:1  |  | 1 (COMMON:UC-01) |
| WK-SCP0020-0005 | A5 | COMMON:UC-05 | DB 메타(적용 예정) | A5 FAIL 수정 — COMMON:UC-05: 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력' 의 A5 3요소: PASS:2 · FAIL:1 · FA |  | 1 (COMMON:UC-05) |
| WK-SCP0020-0006 | A5 | COMMON:UC-07 | DB 메타(적용 예정) | A5 FAIL 수정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용' 의 A5 3요소: PASS:2 · FAIL:1 · FAIL 요소: OPERAT |  | 1 (COMMON:UC-07) |
| WK-SCP0020-0007 | A5 | OPERATION_NAME / Operation | DB 메타(적용 예정) | A5 FAIL 수정 — OPERATION_NAME / Operation: 실측[T-6b72d463]: OPERATION_NAME: AS-IS(Div 82) '기본' ↔ TO-BE 표시=N — 표시 여부 불일치 (TO-BE 메타 VIS |  | 3 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0008 | A5 | SmartColMerge | DB 메타(적용 예정) | A5 FAIL 수정 — SmartColMerge: 행 집계 — 대조표 SmartColMerge '9' 의 A5 3요소: PASS:2 · FAIL:1 · FAIL 요소: OPERATION_NAME / Operation — 실측[T-6b |  | 1 (SmartColMerge) |
| WK-SCP0020-0009 | H10 | SCP0020 화면 | FE(적용 대상 — 공통 컴포넌트는 변경 전 확인) | H10 FAIL 수정 — SCP0020 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: hooks/useTactTimeValidation.ts |  | 15 (MSG00193 MSG00085 / MSG00072 MSG00002 MS) |
| WK-SCP0020-0010 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-2cb9b5d9 ASIS / 원장 V-c4c32967 ASIS / 원장 V-00c36130 ASIS / 원장 V-c7a15bd8 ASIS (FX-SCP0020-007) |  | 4 (ACT:SCP0020_TactTime.SaveData_Except:227) |
| WK-SCP0020-0011 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-00c36130 (FX-SCP0020-007) |  | 1 (ACT:SCP0020_TactTime.SaveData_Main:1844:) |
| WK-SCP0020-0012 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-c7a15bd8 (FX-SCP0020-008) |  | 1 (ACT:SCP0020_TactTime.SaveData_Packer:160) |
| WK-SCP0020-0013 | X-ROW | SCP0020_TactTime.InitSpread | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0020_TactTime.InitSpread: 진입점 집계 11검사 — NA:6 · PASS:4 · FAIL:1 (FX-SCP0020-044) |  | 7 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0014 | X-ROW | SCP0020_TactTime.SaveData_Except | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0020_TactTime.SaveData_Except: 진입점 집계 25검사 — NA:14 · ERROR:5 · PASS:2 · NOPATH:2 · WARN:1 · FAIL:1 (FX-SCP0020- |  | 1 (ACT:SCP0020_TactTime.SaveData_Except:215) |
| WK-SCP0020-0015 | X-ROW | SCP0020_TactTime.SaveData_Except_Packer | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0020_TactTime.SaveData_Except_Packer: 진입점 집계 25검사 — NA:14 · ERROR:5 · PASS:4 · WARN:1 · FAIL:1 (FX-SCP0020-047) |  | 1 (ACT:SCP0020_TactTime.SaveData_Except_Pac) |
| WK-SCP0020-0016 | X-ROW | SCP0020_TactTime.SaveData_Main | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0020_TactTime.SaveData_Main: 진입점 집계 29검사 — NA:14 · PASS:7 · ERROR:5 · FAIL:2 · WARN:1 (FX-SCP0020-048) |  | 2 (ACT:SCP0020_TactTime.SaveData_Main:1687:) |
| WK-SCP0020-0017 | X-ROW | SCP0020_TactTime.SaveData_Packer | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0020_TactTime.SaveData_Packer: 진입점 집계 27검사 — NA:11 · PASS:8 · ERROR:5 · FAIL:2 · WARN:1 (FX-SCP0020-049) |  | 3 (ACT:SCP0020_TactTime.SaveData_Packer:147) |

## W5 검사기 연결 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0018 | DB-SYN | SCP0020_GET_TACT_TIME_EXCEPT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0020_GET_TACT_TIME_EXCEPT | 없음(PROC_M 대응 없음) | 5 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0019 | DB-SYN | SCP0020_SAVE_TACT_TIME_EXCEPT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0020_SAVE_TACT_TIME_EXCEPT | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0020_TactTime.SaveData_Except:222) |

## W6 검증 실행 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0020 | K-SA | SCP0020 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0020 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 0 () |
| WK-SCP0020-0021 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0020_TactTime.DefineProperty ACT:) |
| WK-SCP0020-0022 | G4 | cboValid / Valid | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0020_TactTime.InitControls ACT:SC) |

## W7 기대값 확정 (55)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0023 | I1 | SCP0020 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | I1 기대값 확정 — SCP0020 화면: 원장 V-8d5fd474 RULE_SCREEN / 원장 V-978d36ad DEFECT / 원장 V-96052c4f DEFECT / 원장 V-02e5fe55 DEFECT / 원장 V-5f59 |  | 58 (MSG00193 MSG00085 / MSG00072 MSG00002 MS) |
| WK-SCP0020-0024 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도  해당없음 — SCP0020 은 SHEET_COLUMNS 메타 구동 정적 |  | 1 (COMMON:UC-03) |
| WK-SCP0020-0025 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회  해당없음 — SCP0020 조회조건에 자유 텍스트 key-in 필드 없음. txtItemId 는 AS-IS Usr |  | 1 (COMMON:UC-06) |
| WK-SCP0020-0026 | A1 | 2 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2 조회: 행 집계 — 대조표 2 조회 'btnItemId / txtItemId' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_SCP0020_GET_TACT — golden SK |  | 1 (2 조회) |
| WK-SCP0020-0027 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 '데이터 수정 중 다른 데이터 조회 시도 = confirm 프롬프트' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020 |  | 1 (COMMON:UC-02) |
| WK-SCP0020-0028 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_ |  | 1 (COMMON:UC-07) |
| WK-SCP0020-0029 | A1 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT_TIME.md —  |  | 47 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME ) |
| WK-SCP0020-0030 | A1 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCEPT_OSP: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT |  | 34 (ACT:SCP0020_TactTime.FindData_Except_Pac) |
| WK-SCP0020-0031 | A1 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT_TIME_O |  | 4 (SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T) |
| WK-SCP0020-0032 | A1 | SCM0002 Item 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0002 Item 팝업: 행 집계 — 대조표 SCM0002 Item 팝업 '`itemSearch` SEARCH (확인 필요 — 별도 화면 SP)' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0033 | A1 | SCP0020_GET_TACT_TIME_EXCEPT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0020_GET_TACT_TIME_EXCEPT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0020/SCP0020_GET_TACT_TIME_EXCEPT.md —  |  | 35 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0034 | A1 | SCP0020_TactTime.FindData_Main_MaxValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0020_TactTime.FindData_Main_MaxValue: 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Main_MaxValue 의 A1 4요소: REVIEW:4 · FAI |  | 26 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0035 | A1 | SCP0020_TactTime.FindData_Packer_MaxValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0020_TactTime.FindData_Packer_MaxValue: 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Packer_MaxValue 의 A1 4요소: REVIEW:4 · |  | 22 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0036 | A1 | btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnItemId_Click: 행 집계 — 대조표 btnItemId_Click '2541' 의 A1 4요소: REVIEW:4 · FAIL 요소: PKG_SCP0020.P_SCP0020_GET_TACT — gold |  | 1 (btnItemId_Click) |
| WK-SCP0020-0037 | A6 | SCM0002 Item 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCM0002 Item 팝업: 행 집계 — 대조표 SCM0002 Item 팝업 '`itemSearch` SEARCH (확인 필요 — 별도 화면 SP)' 의 A6 4요소: PASS:3 · REVIEW:1 · FAI |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0038 | A6 | SCP0020_GET_TACT_TIME_EXCEPT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0020_GET_TACT_TIME_EXCEPT: 원장 V-4cc685ab SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-e87acdd9]: S |  | 35 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0039 | A6 | SCP0020_TactTime.FindData_Main_MaxValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0020_TactTime.FindData_Main_MaxValue: 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Main_MaxValue 의 A6 4요소: PASS:3 · REVIE |  | 26 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0040 | A6 | SCP0020_TactTime.FindData_Packer_MaxValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0020_TactTime.FindData_Packer_MaxValue: 진입점 집계 — 대조표 SCP0020_TactTime.FindData_Packer_MaxValue 의 A6 4요소: PASS:3 · R |  | 22 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0041 | G03-WIRE | SCP0020 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0020 화면: 게이트 G03 As-is 이벤트 btnItemId.Click → btnItemId_Cl / 게이트 G03 As-is 이벤트 spdMain.EditModeOff → SpdMain_  |  | 18 (ACT:SCP0020_TactTime..ctor ACT:SCP0020_T) |
| WK-SCP0020-0042 | X-LOC | 1 Layout | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1 Layout: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1 Layout) |
| WK-SCP0020-0043 | X-LOC | ClbDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ClbDivision_SelectedIndexChanged: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ClbDivision_SelectedIndexChanged) |
| WK-SCP0020-0044 | X-LOC | ClbPlantSite_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ClbPlantSite_SelectedIndexChanged: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ClbPlantSite_SelectedIndexChanged) |
| WK-SCP0020-0045 | X-LOC | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00002: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00002) |
| WK-SCP0020-0046 | X-LOC | MSG00048 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00048: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00048) |
| WK-SCP0020-0047 | X-LOC | MSG00049 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00049: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00049) |
| WK-SCP0020-0048 | X-LOC | MSG00085 / MSG00072 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00085 / MSG00072: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00085 / MSG00072) |
| WK-SCP0020-0049 | X-LOC | MSG00105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00105: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00105) |
| WK-SCP0020-0050 | X-LOC | MSG00108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00108: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00108) |
| WK-SCP0020-0051 | X-LOC | MSG00109/00199/00161/00004/00006/00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00109/00199/00161/00004/00006/00043: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00109/00199/00161/00004/00006/00043) |
| WK-SCP0020-0052 | X-LOC | MSG00193 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00193: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00193) |
| WK-SCP0020-0053 | X-LOC | MSG00203 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00203: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00203) |
| WK-SCP0020-0054 | X-LOC | SCM0002 Item 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCM0002 Item 팝업: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0055 | X-LOC | SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME) |
| WK-SCP0020-0056 | X-LOC | SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SAVE_TACT_TI: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0057 | X-LOC | SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_TIME_OSP: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T) |
| WK-SCP0020-0058 | X-LOC | SmartColMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SmartColMerge: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SmartColMerge) |
| WK-SCP0020-0059 | X-LOC | SpdMain_EditChange / EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SpdMain_EditChange / EditModeOff: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SpdMain_EditChange / EditModeOff) |
| WK-SCP0020-0060 | X-LOC | btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — btnItemId_Click: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (btnItemId_Click) |
| WK-SCP0020-0061 | X-LOC | spdExcept_EditChange / EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdExcept_EditChange / EditModeOff: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdExcept_EditChange / EditModeOff) |
| WK-SCP0020-0062 | X-LOC | static 8 (GMessageBoxForException) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — static 8 (GMessageBoxForException): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (static 8 (GMessageBoxForException)) |
| WK-SCP0020-0063 | X-ROW | SCP0020_TactTime.CheckDigitValueEntered | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.CheckDigitValueEntered: 진입점 집계 6검사 — NA:5 · WARN:1 |  | 21 (ACT:SCP0020_TactTime.CheckDigitValueEnte) |
| WK-SCP0020-0064 | X-ROW | SCP0020_TactTime.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.FindButton: 진입점 집계 6검사 — PASS:3 · REVIEW:2 · NA:1 |  | 1 (ACT:SCP0020_TactTime.FindButton) |
| WK-SCP0020-0065 | X-ROW | SCP0020_TactTime.FindData_Except | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.FindData_Except: 진입점 집계 8검사 — NA:2 · REVIEW:2 · PASS:2 · NOPATH:1 · WARN:1 |  | 7 (ACT:SCP0020_TactTime.FindData_Except ACT) |
| WK-SCP0020-0066 | X-ROW | SCP0020_TactTime.FindData_Except_Packer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.FindData_Except_Packer: 진입점 집계 8검사 — PASS:4 · NA:2 · REVIEW:1 · WARN:1 |  | 7 (ACT:SCP0020_TactTime.FindData_Except_Pac) |
| WK-SCP0020-0067 | X-ROW | SCP0020_TactTime.FindData_Main_MaxValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.FindData_Main_MaxValue: 진입점 집계 11검사 — PASS:4 · NA:4 · REVIEW:2 · WARN:1 |  | 4 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0068 | X-ROW | SCP0020_TactTime.FindData_Packer_MaxValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.FindData_Packer_MaxValue: 진입점 집계 10검사 — NA:4 · PASS:3 · REVIEW:2 · WARN:1 |  | 4 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0069 | X-ROW | SCP0020_TactTime.Find_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.Find_Data: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 7 (ACT:SCP0020_TactTime.Find_Data ACT:SCP00) |
| WK-SCP0020-0070 | X-ROW | SCP0020_TactTime.Find_Packer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.Find_Packer: 진입점 집계 8검사 — PASS:4 · NA:2 · WARN:1 · REVIEW:1 |  | 41 (ACT:SCP0020_TactTime.Find_Packer ACT:SCP) |
| WK-SCP0020-0071 | X-ROW | SCP0020_TactTime.RefreshLineByOperationO | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.RefreshLineByOperationOfSpd: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0020_TactTime.RefreshLineByOperat) |
| WK-SCP0020-0072 | X-ROW | SCP0020_TactTime.SpdMain_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SpdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0020_TactTime.SpdMain_EditChange ) |
| WK-SCP0020-0073 | X-ROW | SCP0020_TactTime.UnLockOnlyOSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.UnLockOnlyOSP: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/GRID_SET/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0020_TactTime.UnLockOnlyOSP ACT:S) |
| WK-SCP0020-0074 | X-ROW | SCP0020_TactTime.checkValidN0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.checkValidN0: 진입점 집계 8검사 — NA:7 · WARN:1 |  | 24 (ACT:SCP0020_TactTime.checkValidN0 ACT:SC) |
| WK-SCP0020-0075 | X-ROW | SCP0020_TactTime.checkValidN5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.checkValidN5: 진입점 집계 6검사 — NA:5 · WARN:1 |  | 47 (ACT:SCP0020_TactTime.checkValidN5 ACT:SC) |
| WK-SCP0020-0076 | X-ROW | SCP0020_TactTime.checkValidN8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.checkValidN8: 진입점 집계 6검사 — NA:5 · WARN:1 |  | 25 (ACT:SCP0020_TactTime.checkValidN8 ACT:SC) |
| WK-SCP0020-0077 | X-ROW | SCP0020_TactTime.spdExcept_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.spdExcept_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0020_TactTime.spdExcept_EditChang) |

## W9 도구 오류 (65)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0078 | C3 | SCP0020_TactTime.ClbDivision_SelectedInd | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.ClbDivision_SelectedIndexChanged 의 C3 27요소: NA:23 · PASS:3 · ERROR:1 |  | 3 (ACT:SCP0020_TactTime.ClbDivision_Selecte) |
| WK-SCP0020-0079 | C3 | SCP0020_TactTime.ClbPlantSite_SelectedIn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.ClbPlantSite_SelectedIndexChanged 의 C3 27요소: NA:23 · PASS:3 · ERROR:1 |  | 3 (ACT:SCP0020_TactTime.ClbPlantSite_Select) |
| WK-SCP0020-0080 | C3 | SCP0020_TactTime.SpdMain_ActiveSheetChan | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0020_TactTime.SpdMain_ActiveSheetChanged 의 C3 27요소: NA:23 · PASS:3 · ERROR:1 |  | 4 (ACT:SCP0020_TactTime.SpdMain_ActiveSheet) |
| WK-SCP0020-0081 | C3 | SpdMain_EditChange / EditModeOff | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 SpdMain_EditChange / EditModeOff '2806/2814' 의 C3 27요소: NA:23 · PASS:3 · ERROR:1 |  | 1 (SpdMain_EditChange / EditModeOff) |
| WK-SCP0020-0082 | C3 | VALID_YN / Valid | 하네스·환경 | C3 도구 오류 — 실측[T-e3deeaf7]: [재측정 필요] 검사 조건이 바뀐 뒤 아직 재실행되지 않음(측정 시점 조건 44fdf28a ≠ 현재 88c1bc10) — 이전 판정 FAIL 보류: 신규행 VALID_YN='' ↔ AS |  | 1 (ACT:SCP0020_TactTime.InsertButton:789:26) |
| WK-SCP0020-0083 | C3 | spdExcept_EditChange / EditModeOff | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 spdExcept_EditChange / EditModeOff '2827/2835' 의 C3 27요소: NA:23 · PASS:3 · ERROR:1 |  | 1 (spdExcept_EditChange / EditModeOff) |
| WK-SCP0020-0084 | F1 | SCP0020 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-724bb0eb RULE_SCREEN / 원장 V-be5582ff GENERAL / 원장 V-f1dc8ac4 GENERAL / 원장 V-13a80b4d GENERAL / 원장 V-7ed1d10d GENER |  | 526 (MSG00109/00199/00161/00004/00006/00043 S) |
| WK-SCP0020-0085 | F2 | SCP0020 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-7a2d0107 RULE_SCREEN / 원장 V-9c928393 GENERAL / 원장 V-999d26ca GENERAL / 원장 V-6514a176 GENERAL / 원장 V-61ce96a6 GENER |  | 511 (MSG00109/00199/00161/00004/00006/00043 S) |
| WK-SCP0020-0086 | F6 | SCP0020 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-1d3237dc RULE_SCREEN / 원장 V-93f57ad7 GENERAL / 원장 V-1d973c5c GENERAL / 원장 V-674263dd GENERAL / 원장 V-b9e52739 GENER |  | 510 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME ) |
| WK-SCP0020-0087 | D3 | BIG_LAST_UPDATE_DATE / Big Last Update D | 하네스·환경 | D3 도구 오류 — 원장 V-d4960312 ASIS |  | 2 (ACT:SCP0020_TactTime.EditButton:569:10 A) |
| WK-SCP0020-0088 | D3 | CREATED_BY / Created By | 하네스·환경 | D3 도구 오류 — 원장 V-38fc7b8e ASIS |  | 2 (ACT:SCP0020_TactTime.EditButton:677:60 A) |
| WK-SCP0020-0089 | D3 | CREATED_BY,LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-38fc7b8e |  | 1 (ACT:SCP0020_TactTime.EditButton:677:60) |
| WK-SCP0020-0090 | D3 | DAILY_CAPACITY / Daily Capacity | 하네스·환경 | D3 도구 오류 — 원장 V-eacbd820 ASIS / 원장 V-cd75ee99 ASIS |  | 6 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0091 | D3 | DAILY_CAPACITY,DAILY_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-cd75ee99 |  | 1 (ACT:SCP0020_TactTime.EditButton:681:62) |
| WK-SCP0020-0092 | D3 | DAILY_CAPACITY,UOM_CONVERT_VALUE | 하네스·환경 | D3 도구 오류 — 원장 V-eacbd820 |  | 1 (ACT:SCP0020_TactTime.EditButton:577:13) |
| WK-SCP0020-0093 | D3 | DIVISION_ID / Division | 하네스·환경 | D3 도구 오류 — 원장 V-061c7c98 ASIS / 원장 V-baada553 ASIS / 원장 V-cbd38703 ASIS |  | 9 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0094 | D3 | DIVISION_ID,LINE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-cbd38703 |  | 1 (ACT:SCP0020_TactTime.EditButton:676:59) |
| WK-SCP0020-0095 | D3 | DIVISION_ID,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-061c7c98 |  | 1 (ACT:SCP0020_TactTime.EditButton:568:9) |
| WK-SCP0020-0096 | D3 | DIVISION_ID,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-baada553 |  | 1 (ACT:SCP0020_TactTime.EditButton:610:26) |
| WK-SCP0020-0097 | D3 | INPUT_STATUS | 하네스·환경 | D3 도구 오류 — 원장 V-8fc49ea7 ASIS / 원장 V-8f4b34b6 ASIS |  | 6 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0098 | D3 | ITEM_UOM / Item UOM | 하네스·환경 | D3 도구 오류 — 원장 V-3398bd74 ASIS |  | 4 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0099 | D3 | ITEM_UOM,TACT_TIME | 하네스·환경 | D3 도구 오류 — 원장 V-3398bd74 |  | 1 (ACT:SCP0020_TactTime.EditButton:573:12) |
| WK-SCP0020-0100 | D3 | JUMBO_MIN / Jumbo / Min | 하네스·환경 | D3 도구 오류 — 원장 V-d4960312 ASIS |  | 3 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0101 | D3 | JUMBO_MIN,BIG_LAST_UPDATE_DATE | 하네스·환경 | D3 도구 오류 — 원장 V-d4960312 |  | 1 (ACT:SCP0020_TactTime.EditButton:569:10) |
| WK-SCP0020-0102 | D3 | LANE_QTY / Slitting Lane | 하네스·환경 | D3 도구 오류 — 원장 V-9fcc948a ASIS / 원장 V-38b9cb23 ASIS |  | 4 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0103 | D3 | LANE_QTY,LANE_QTY | 하네스·환경 | D3 도구 오류 — 원장 V-38b9cb23 |  | 1 (ACT:SCP0020_TactTime.EditButton:598:22) |
| WK-SCP0020-0104 | D3 | LAST_UPDATE_DATE / Last Update Date | 하네스·환경 | D3 도구 오류 — 원장 V-38fc7b8e ASIS |  | 2 (ACT:SCP0020_TactTime.EditButton:677:60 A) |
| WK-SCP0020-0105 | D3 | LINE_ID / Line | 하네스·환경 | D3 도구 오류 — 원장 V-8fc49ea7 ASIS / 원장 V-9fcc948a ASIS / 원장 V-8f4b34b6 ASIS / 원장 V-cbd38703 ASIS |  | 7 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0106 | D3 | LINE_ID,LANE_QTY | 하네스·환경 | D3 도구 오류 — 원장 V-9fcc948a |  | 1 (ACT:SCP0020_TactTime.EditButton:593:20) |
| WK-SCP0020-0107 | D3 | LINE_ID,LINE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-8fc49ea7 |  | 1 (ACT:SCP0020_TactTime.EditButton:588:17) |
| WK-SCP0020-0108 | D3 | LINE_ID,LINE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-8f4b34b6 |  | 1 (ACT:SCP0020_TactTime.EditButton:621:31) |
| WK-SCP0020-0109 | D3 | LockColumn/LockRange (편집잠금 white-list) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 LockColumn/LockRange (편집잠금 white-list) '32' 의 D3 36요소: ERROR:34 · NA:2 |  | 1 (LockColumn/LockRange (편집잠금 white-list)) |
| WK-SCP0020-0110 | D3 | MODEL_SITE / Model Site | 하네스·환경 | D3 도구 오류 — 원장 V-9fcc948a ASIS |  | 4 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0111 | D3 | NICK_NAME / Nick Name | 하네스·환경 | D3 도구 오류 — 원장 V-061c7c98 ASIS / 원장 V-baada553 ASIS |  | 4 (ACT:SCP0020_TactTime.EditButton:568:9 AC) |
| WK-SCP0020-0112 | D3 | OPERATION_GROUP_ID | 하네스·환경 | D3 도구 오류 — 원장 V-8111a744 ASIS / 원장 V-38b9cb23 ASIS |  | 5 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0113 | D3 | OPERATION_GROUP_ID,OPERATION_GROUP_ID | 하네스·환경 | D3 도구 오류 — 원장 V-8111a744 |  | 1 (ACT:SCP0020_TactTime.EditButton:583:15) |
| WK-SCP0020-0114 | D3 | OSP_YN | 하네스·환경 | D3 도구 오류 — 원장 V-29fef4d4 ASIS |  | 2 (ACT:SCP0020_TactTime.EditButton:611:27 A) |
| WK-SCP0020-0115 | D3 | SCP0020_TactTime.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-c52841e9 ASIS / 원장 V-061c7c98 ASIS / 원장 V-d4960312 ASIS / 원장 V-3398bd74 ASIS / 원장 V-eacbd820 ASIS / 원장 V-8111a744  |  | 27 (ACT:SCP0020_TactTime.EditButton:550:1 AC) |
| WK-SCP0020-0116 | D3 | TACT_TIME / Tact Time | 하네스·환경 | D3 도구 오류 — 원장 V-3398bd74 ASIS / 원장 V-29fef4d4 ASIS / 원장 V-ccc2430e ASIS |  | 9 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0117 | D3 | TACT_TIME,OSP_YN | 하네스·환경 | D3 도구 오류 — 원장 V-29fef4d4 |  | 1 (ACT:SCP0020_TactTime.EditButton:611:27) |
| WK-SCP0020-0118 | D3 | TACT_TIME,TACT_TIME | 하네스·환경 | D3 도구 오류 — 원장 V-ccc2430e |  | 1 (ACT:SCP0020_TactTime.EditButton:684:64) |
| WK-SCP0020-0119 | D3 | UOM_CONVERT_VALUE / UOM Convert | 하네스·환경 | D3 도구 오류 — 원장 V-eacbd820 ASIS |  | 2 (ACT:SCP0020_TactTime.EditButton:577:13 A) |
| WK-SCP0020-0120 | D3 | siExcept.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-078f861c |  | 1 (ACT:SCP0020_TactTime.EditButton:674:58) |
| WK-SCP0020-0121 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-c52841e9 |  | 1 (ACT:SCP0020_TactTime.EditButton:564:7) |
| WK-SCP0020-0122 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-d111ac4b |  | 1 (ACT:SCP0020_TactTime.EditButton:608:25) |
| WK-SCP0020-0123 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-8cd135ee |  | 1 (ACT:SCP0020_TactTime.SaveData_Except:226) |
| WK-SCP0020-0124 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-8cd135ee ASIS / 원장 V-82082f68 ASIS / 원장 V-6611670c ASIS / 원장 V-9ef3d80e ASIS |  | 4 (ACT:SCP0020_TactTime.SaveData_Except:226) |
| WK-SCP0020-0125 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-82082f68 |  | 1 (ACT:SCP0020_TactTime.SaveData_Except_Pac) |
| WK-SCP0020-0126 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-6611670c |  | 1 (ACT:SCP0020_TactTime.SaveData_Main:1830:) |
| WK-SCP0020-0127 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-9ef3d80e |  | 1 (ACT:SCP0020_TactTime.SaveData_Packer:158) |
| WK-SCP0020-0128 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 '데이터 수정 중 다른 데이터 조회 시도 = confirm 프롬프트' 의 G1 12요소: NA:8 · PASS:3 · ERROR:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0020-0129 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용' 의 G1 12요소: NA:8 · PASS:3 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0020-0130 | G1 | SCM0002 Item 팝업 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SCM0002 Item 팝업 '`itemSearch` SEARCH (확인 필요 — 별도 화면 SP)' 의 G1 12요소: NA:8 · PASS:3 · ERROR:1 |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0131 | G1 | SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME '`plant` SEARCH / SAVE (useTabProcQuery / useProcMu' 의 G1 12요소: NA:8 |  | 1 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME) |
| WK-SCP0020-0132 | G1 | SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SAVE_TACT_TIME_EXCEPT( '`except` SEARCH / SAVE' 의 G1 12요소: NA:8 · PASS |  | 1 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0133 | G1 | SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_TIME_OSP '`packer` SEARCH / SAVE' 의 G1 12요소: NA:8 · PASS:3 · ERROR:1 |  | 1 (SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T) |
| WK-SCP0020-0134 | G1 | btnItemId_Click | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnItemId_Click '2541' 의 G1 12요소: NA:8 · PASS:3 · ERROR:1 |  | 1 (btnItemId_Click) |
| WK-SCP0020-0135 | G1 | clbLine / Line | 하네스·환경 | G1 도구 오류 — 원장 V-adf441b7 SEARCH |  | 2 (ACT:SCP0020_TactTime.FindData_Main ACT:S) |
| WK-SCP0020-0136 | X-ROW | SCP0020_TactTime.ClbDivision_SelectedInd | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.ClbDivision_Selecte) |
| WK-SCP0020-0137 | X-ROW | SCP0020_TactTime.ClbPlantSite_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.ClbPlantSite_Select) |
| WK-SCP0020-0138 | X-ROW | SCP0020_TactTime.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.CreateSpread) |
| WK-SCP0020-0139 | X-ROW | SCP0020_TactTime.DefineProperty | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:1 · PASS:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0020_TactTime.DefineProperty:199:) |
| WK-SCP0020-0140 | X-ROW | SCP0020_TactTime.FindData_Main | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — PASS:7 · NA:5 · REVIEW:1 · ERROR:1 · WARN:1 |  | 10 (ACT:SCP0020_TactTime.FindData_Main:1030:) |
| WK-SCP0020-0141 | X-ROW | SCP0020_TactTime.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — PASS:6 · NA:3 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0020_TactTime.InitControls:215:3 ) |
| WK-SCP0020-0142 | X-ROW | SCP0020_TactTime.SpdMain_ActiveSheetChan | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0020_TactTime.SpdMain_ActiveSheet) |
