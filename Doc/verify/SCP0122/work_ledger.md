# 작업 원장 — SCP0122 · 2026-10-26 12:55

> 검사 인스턴스 257건 중 PASS·NA 25건 외 **232건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 22 | 구현 위치 실존 |
| W3 | 동작 수정 | 2 | 재판정 PASS |
| W4 | 검사기 구현 | 2 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 9 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 78 | 실행 → PASS |
| W7 | 기대값 확정 | 119 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 116 · E2E 78 · 대조표 25 · 하네스 11 · FE 1 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 22 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 18 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A5 | DESIGN |  |  |  |  |  | 3 | 14 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 3 | 14 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 3 | 14 |  |  | 라벨 명칭 |
| C3 | CASCADE |  |  |  |  |  | 8 | 5 |  |  | 연쇄 자동 채움 |
| G1 | GEN |  |  |  |  |  | 3 | 10 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 12 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C2 | CASCADE |  |  |  |  |  | 7 | 3 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 7 | 3 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | EDIT |  |  |  |  |  | 7 | 2 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 7 | 2 |  |  | 행 값 기반 조건부 잠금 |
| E4 | EDIT |  |  |  |  |  | 7 | 2 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G6 | GEN |  |  |  |  |  | 3 | 6 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B4 | COMBO |  |  |  |  | 3 |  | 3 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 2 |  |  | 3 |  |  | 콤보 후보 정렬 = AS-IS |
| C1 | CASCADE |  |  |  |  |  | 3 | 2 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F4 | DB |  |  |  |  |  | 3 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| D5 | EDIT |  |  |  |  |  | 1 | 2 |  |  | 셀 에디터 유형 |
| X-REASON | DESIGN |  |  |  |  |  |  | 3 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| D4 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| J2 | AUTH |  |  | 1 |  |  |  |  |  |  | 권한별 버튼·기능 |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| B1 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 중복 없음 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| E5 | EDIT |  |  |  |  | 1 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| E1 | EDIT |  |  |  |  |  | 1 |  |  |  | 숫자 소수자리·정수·부호·범위 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | GEN |  |  |  |  |  | 1 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0001 | X-LOC | Auto-Sync `SetValue` OPMZ_ACTV_CD+5속성 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Auto-Sync `SetValue` OPMZ_ACTV_CD+5속성) |
| WK-SCP0122-0002 | X-LOC | MSG00001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00001) |
| WK-SCP0122-0003 | X-LOC | MSG00004 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00004) |
| WK-SCP0122-0004 | X-LOC | MSG00097 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00097) |
| WK-SCP0122-0005 | X-LOC | MSG00443 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MSG00443) |
| WK-SCP0122-0006 | X-LOC | `BLUtils.GetDivision(false,"")` → `Divis | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`BLUtils.GetDivision(false,"")` → `Divis) |
| WK-SCP0122-0007 | X-LOC | `CboPlanGroup_SelectedIndexChanged`→`Cle | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`CboPlanGroup_SelectedIndexChanged`→`Cle) |
| WK-SCP0122-0008 | X-LOC | `ClbDivision_SelectedIndexChanged`→`Refr | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`ClbDivision_SelectedIndexChanged`→`Refr) |
| WK-SCP0122-0009 | X-LOC | `Data.Common(LookupCommon,false,"OPMZ_PR | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`Data.Common(LookupCommon,false,"OPMZ_PR) |
| WK-SCP0122-0010 | X-LOC | `DeleteButton`→`siMain.Delete` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DeleteButton`→`siMain.Delete`) |
| WK-SCP0122-0011 | X-LOC | `GetPlanGroupByUserID()` Tables[3] → `Pl | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`GetPlanGroupByUserID()` Tables[3] → `Pl) |
| WK-SCP0122-0012 | X-LOC | `Insert_Row` 기본값 5컬럼 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`Insert_Row` 기본값 5컬럼) |
| WK-SCP0122-0013 | X-LOC | `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`LockColumn(0,MaxCol,true)` 조회직후 전체잠금) |
| WK-SCP0122-0014 | X-LOC | `Query(ds)` GET SP 바인딩 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`Query(ds)` GET SP 바인딩) |
| WK-SCP0122-0015 | X-LOC | `RefreshPlanGroupByDivision` DIVISION_ID | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`RefreshPlanGroupByDivision` DIVISION_ID) |
| WK-SCP0122-0016 | X-LOC | `Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세) |
| WK-SCP0122-0017 | X-LOC | `SetDivisionAuthCheck`(`dtMyDivision.Row | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0018 | X-LOC | `SetSheetHeaderColumnSCP`(SCM_MST_SHEET_ | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SetSheetHeaderColumnSCP`(SCM_MST_SHEET_) |
| WK-SCP0122-0019 | X-LOC | `filterCalls#2` `dtActivityCdAll CODE='< | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`filterCalls#2` `dtActivityCdAll CODE='<) |
| WK-SCP0122-0020 | X-LOC | 셀콤보 `SetComBoParam("ActivityCode",dtActi | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (셀콤보 `SetComBoParam("ActivityCode",dtActi) |
| WK-SCP0122-0021 | X-LOC | 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00) |
| WK-SCP0122-0022 | X-LOC | 필수검증(actv_cd/actv_seq 공백 MSG00001) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (필수검증(actv_cd/actv_seq 공백 MSG00001)) |

## W3 동작 수정 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0023 | J2 | SCP0122 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | J2 FAIL 수정 — SCP0122 화면: E2E auth access / E2E auth buttons / E2E authcrud authcrud |  | 17 (`BLUtils.GetDivision(false,"")` → `Divis) |
| WK-SCP0122-0024 | F1 | SCP0122 화면 | DB(🛠️/🧯 적용 가능) | F1 FAIL 수정 — SCP0122 화면: E2E authcrud / E2E crud |  | 13 (`DeleteButton`→`siMain.Delete` `Save_Dat) |

## W4 검사기 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0025 | B3 | OPMZ_PRS_CD | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPMZ_PRS_CD | 있음(SHEET_COLUMNS) | 1 (`Data.Common(LookupCommon,false,"OPMZ_PR) |
| WK-SCP0122-0026 | B3 | cboDivision / Division / Div. | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division / Div. | 있음(FE 소스) | 1 (`BLUtils.GetDivision(false,"")` → `Divis) |

## W5 검사기 연결 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0027 | B1 | OPMZ_ACTV_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL OPMZ_ACTV_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0122-0028 | B2 | OPMZ_ACTV_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL OPMZ_ACTV_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0122-0029 | B4 | OPMZ_ACTV_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPMZ_ACTV_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0122-0030 | B4 | OPMZ_PRS_CD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPMZ_PRS_CD | 있음(SHEET_COLUMNS) | 1 (`Data.Common(LookupCommon,false,"OPMZ_PR) |
| WK-SCP0122-0031 | B4 | cboDivision / Division / Div. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division / Div. | 있음(FE 소스) | 1 (`BLUtils.GetDivision(false,"")` → `Divis) |
| WK-SCP0122-0032 | F2 | SCP0122 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0122 화면 | 판단불가(대상 단위 SCREEN) | 7 (`Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세) |
| WK-SCP0122-0033 | F6 | SCP0122 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0122 화면 | 판단불가(대상 단위 SCREEN) | 4 (ACT:SCP0122_PlanActivityMgmt.SaveButton ) |
| WK-SCP0122-0034 | E5 | OPMZ_ACTV_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL OPMZ_ACTV_NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0122-0035 | G03-WIRE | SCP0122 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0122 화면 | 판단불가(대상 단위 SCREEN) | 8 (ACT:SCP0122_PlanActivityMgmt..ctor ACT:S) |

## W6 검증 실행 (78)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0036 | C1 | cboDivision / Division / Div. | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division / Div. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0122_PlanActivityMgmt.InitControl) |
| WK-SCP0122-0037 | C1 | cboPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0122_PlanActivityMgmt.RefreshPlan) |
| WK-SCP0122-0038 | C1 | cboProcess / Process | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboProcess / Process · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0122_PlanActivityMgmt.InitControl) |
| WK-SCP0122-0039 | C2 | AUTO_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — AUTO_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0040 | C2 | CONFIRM_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CONFIRM_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0041 | C2 | LINK_UI_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LINK_UI_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0042 | C2 | OPMZ_ACTV_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_ACTV_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (Auto-Sync `SetValue` OPMZ_ACTV_CD+5속성 AC) |
| WK-SCP0122-0043 | C2 | OPMZ_ACTV_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_ACTV_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0044 | C2 | OPTION_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPTION_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0045 | C2 | PROGRAM_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PROGRAM_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0046 | C3 | AUTO_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — AUTO_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0047 | C3 | CONFIRM_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CONFIRM_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0048 | C3 | LINK_UI_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LINK_UI_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0049 | C3 | OPMZ_ACTV_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_ACTV_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (Auto-Sync `SetValue` OPMZ_ACTV_CD+5속성 AC) |
| WK-SCP0122-0050 | C3 | OPMZ_ACTV_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_ACTV_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0051 | C3 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Cli) |
| WK-SCP0122-0052 | C3 | OPTION_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPTION_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0053 | C3 | PROGRAM_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROGRAM_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0054 | C6 | AUTO_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — AUTO_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0055 | C6 | CONFIRM_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CONFIRM_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0056 | C6 | LINK_UI_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LINK_UI_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0057 | C6 | OPMZ_ACTV_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPMZ_ACTV_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (Auto-Sync `SetValue` OPMZ_ACTV_CD+5속성 AC) |
| WK-SCP0122-0058 | C6 | OPMZ_ACTV_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPMZ_ACTV_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0059 | C6 | OPTION_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPTION_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0060 | C6 | PROGRAM_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PROGRAM_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0061 | G3 | SCP0122 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0122 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0062 | K-SA | SCP0122 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0122 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0063 | K4 | SCP0122 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0122 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 3 (COMMON:UC-04 COMMON:UC-05 COMMON:UC-07) |
| WK-SCP0122-0064 | F3 | SCP0122 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0122 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 9 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Cli) |
| WK-SCP0122-0065 | F5 | SCP0122 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0122 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 7 (`DeleteButton`→`siMain.Delete` `Save_Dat) |
| WK-SCP0122-0066 | F4 | PKG_COM0000.P_SCP0121_GET_SEARCH_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0121_GET_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 2 (ACT:SCP0122_PlanActivityMgmt.GetPlanGrou) |
| WK-SCP0122-0067 | F4 | PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_MGMT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 |  | 39 (ACT:SCP0122_PlanActivityMgmt.FindButton ) |
| WK-SCP0122-0068 | F4 | PKG_SCP0122.P_SCP0122_SAVE_PLAN_ACTIVITY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0122.P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 6 (ACT:SCP0122_PlanActivityMgmt.SaveButton ) |
| WK-SCP0122-0069 | A5 | OPMZ_ACTV_CD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPMZ_ACTV_CD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (Auto-Sync `SetValue` OPMZ_ACTV_CD+5속성) |
| WK-SCP0122-0070 | A5 | OPMZ_ACTV_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPMZ_ACTV_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (`LockColumn`/`LockRange` 편집범위 = OPMZ_ACT) |
| WK-SCP0122-0071 | A5 | OPMZ_ACTV_SEQ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPMZ_ACTV_SEQ · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (`LockColumn`/`LockRange` 편집범위 = OPMZ_ACT) |
| WK-SCP0122-0072 | H2 | OPMZ_ACTV_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPMZ_ACTV_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (Auto-Sync `SetValue` OPMZ_ACTV_CD+5속성) |
| WK-SCP0122-0073 | H2 | OPMZ_ACTV_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPMZ_ACTV_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (`LockColumn`/`LockRange` 편집범위 = OPMZ_ACT) |
| WK-SCP0122-0074 | H2 | OPMZ_ACTV_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPMZ_ACTV_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (`LockColumn`/`LockRange` 편집범위 = OPMZ_ACT) |
| WK-SCP0122-0075 | H5 | OPMZ_ACTV_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPMZ_ACTV_CD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (Auto-Sync `SetValue` OPMZ_ACTV_CD+5속성) |
| WK-SCP0122-0076 | H5 | OPMZ_ACTV_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPMZ_ACTV_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (`LockColumn`/`LockRange` 편집범위 = OPMZ_ACT) |
| WK-SCP0122-0077 | H5 | OPMZ_ACTV_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPMZ_ACTV_SEQ · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (`LockColumn`/`LockRange` 편집범위 = OPMZ_ACT) |
| WK-SCP0122-0078 | I1 | SCP0122 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0122 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 13 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0079 | SC1 | SCP0122 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0122 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 7 (`BLUtils.GetDivision(false,"")` → `Divis) |
| WK-SCP0122-0080 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0122_PlanActivityMgmt.EditButton ) |
| WK-SCP0122-0081 | D1 | LINK_UI_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LINK_UI_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0122_PlanActivityMgmt.EditButton ) |
| WK-SCP0122-0082 | D1 | OPMZ_ACTV_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPMZ_ACTV_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0122_PlanActivityMgmt.EditButton ) |
| WK-SCP0122-0083 | D1 | OPMZ_ACTV_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPMZ_ACTV_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (`LockColumn`/`LockRange` 편집범위 = OPMZ_ACT) |
| WK-SCP0122-0084 | D1 | OPMZ_ACTV_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPMZ_ACTV_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (`LockColumn`/`LockRange` 편집범위 = OPMZ_ACT) |
| WK-SCP0122-0085 | D1 | OPMZ_PLAN_GR_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPMZ_PLAN_GR_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.EditButton:) |
| WK-SCP0122-0086 | D1 | OPTION_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPTION_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.EditButton:) |
| WK-SCP0122-0087 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0122_PlanActivityMgmt.EditButton ) |
| WK-SCP0122-0088 | D3 | LINK_UI_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LINK_UI_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0122_PlanActivityMgmt.EditButton ) |
| WK-SCP0122-0089 | D3 | OPMZ_ACTV_CD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPMZ_ACTV_CD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0122_PlanActivityMgmt.EditButton ) |
| WK-SCP0122-0090 | D3 | OPMZ_ACTV_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPMZ_ACTV_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (`LockColumn`/`LockRange` 편집범위 = OPMZ_ACT) |
| WK-SCP0122-0091 | D3 | OPMZ_ACTV_SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPMZ_ACTV_SEQ · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (`LockColumn`/`LockRange` 편집범위 = OPMZ_ACT) |
| WK-SCP0122-0092 | D3 | OPMZ_PLAN_GR_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPMZ_PLAN_GR_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.EditButton:) |
| WK-SCP0122-0093 | D3 | OPTION_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPTION_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.EditButton:) |
| WK-SCP0122-0094 | D4 | OPMZ_ACTV_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPMZ_ACTV_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (Auto-Sync `SetValue` OPMZ_ACTV_CD+5속성) |
| WK-SCP0122-0095 | D5 | OPMZ_ACTV_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — OPMZ_ACTV_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0122-0096 | D6 | SCP0122 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0122 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 3 (`Insert_Row` 기본값 5컬럼 ACT:SCP0122_PlanAct) |
| WK-SCP0122-0097 | E1 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Cli) |
| WK-SCP0122-0098 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (필수검증(actv_cd/actv_seq 공백 MSG00001) MSG00) |
| WK-SCP0122-0099 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00004 COMMON:UC-04) |
| WK-SCP0122-0100 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00004 COMMON:UC-04 ACT:SCP0122_PlanAc) |
| WK-SCP0122-0101 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00097) |
| WK-SCP0122-0102 | E4 | MSG00428 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00428 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00) |
| WK-SCP0122-0103 | E4 | MSG00443 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00443 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00) |
| WK-SCP0122-0104 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0105 | A10 | SCP0122 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0122 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 23 (ACT:SCP0122_PlanActivityMgmt.Form_Load A) |
| WK-SCP0122-0106 | A6 | PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_MGMT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로  |  | 34 (ACT:SCP0122_PlanActivityMgmt.FindButton ) |
| WK-SCP0122-0107 | G1 | cboDivision / Division / Div. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division / Div. · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (`BLUtils.GetDivision(false,"")` → `Divis) |
| WK-SCP0122-0108 | G1 | cboPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanGroup / Plan Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0122_PlanActivityMgmt.FindData_Ma) |
| WK-SCP0122-0109 | G1 | cboProcess / Process | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboProcess / Process · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0122_PlanActivityMgmt.FindData_Ma) |
| WK-SCP0122-0110 | G6 | cboDivision / Division / Div. | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division / Div. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (`BLUtils.GetDivision(false,"")` → `Divis) |
| WK-SCP0122-0111 | G6 | cboPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.InitEvent A) |
| WK-SCP0122-0112 | G6 | cboProcess / Process | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboProcess / Process · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0122_PlanActivityMgmt.InitControl) |
| WK-SCP0122-0113 | X-REOPEN | SCP0122 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0122 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0122_PlanActivityMgmt.Dispose ACT) |

## W7 기대값 확정 (119)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0122-0114 | C1 | `CboPlanGroup_SelectedIndexChanged`→`Cle | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `CboPlanGroup_SelectedIndexChanged`→`ClearDataSour: 행 집계 — C1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`CboPlanGroup_SelectedIndexChanged`→`Cle) |
| WK-SCP0122-0115 | C1 | `ClbDivision_SelectedIndexChanged`→`Refr | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `ClbDivision_SelectedIndexChanged`→`RefreshPlanGro: 행 집계 — C1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`ClbDivision_SelectedIndexChanged`→`Refr) |
| WK-SCP0122-0116 | C2 | SCP0122_PlanActivityMgmt.CboPlanGroup_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0122_PlanActivityMgmt.CboPlanGroup_SelectedInde: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.CboPlanGrou) |
| WK-SCP0122-0117 | C2 | SCP0122_PlanActivityMgmt.ClbDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0122_PlanActivityMgmt.ClbDivision_SelectedIndex: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0122_PlanActivityMgmt.ClbDivision) |
| WK-SCP0122-0118 | C2 | SCP0122_PlanActivityMgmt.SpdMain_ComboSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0122_PlanActivityMgmt.SpdMain_ComboSelChange: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0119 | C3 | SCP0122_PlanActivityMgmt.CboPlanGroup_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0122_PlanActivityMgmt.CboPlanGroup_SelectedInde: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.CboPlanGrou) |
| WK-SCP0122-0120 | C3 | SCP0122_PlanActivityMgmt.ClbDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0122_PlanActivityMgmt.ClbDivision_SelectedIndex: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0122_PlanActivityMgmt.ClbDivision) |
| WK-SCP0122-0121 | C3 | SCP0122_PlanActivityMgmt.SetChangedContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0122_PlanActivityMgmt.SetChangedControl: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.SetChangedC) |
| WK-SCP0122-0122 | C3 | SCP0122_PlanActivityMgmt.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0122_PlanActivityMgmt.SetSpreadInit: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0122_PlanActivityMgmt.SetSpreadIn) |
| WK-SCP0122-0123 | C3 | SCP0122_PlanActivityMgmt.SpdMain_ComboSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0122_PlanActivityMgmt.SpdMain_ComboSelChange: 진입점 집계 — C3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0124 | C6 | SCP0122_PlanActivityMgmt.CboPlanGroup_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0122_PlanActivityMgmt.CboPlanGroup_SelectedInde: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.CboPlanGrou) |
| WK-SCP0122-0125 | C6 | SCP0122_PlanActivityMgmt.ClbDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0122_PlanActivityMgmt.ClbDivision_SelectedIndex: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0122_PlanActivityMgmt.ClbDivision) |
| WK-SCP0122-0126 | C6 | SCP0122_PlanActivityMgmt.SpdMain_ComboSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0122_PlanActivityMgmt.SpdMain_ComboSelChange: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0127 | B3 | SCP0122_PlanActivityMgmt.GetPlanGroupByU | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0122_PlanActivityMgmt.GetPlanGroupByUserID: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0122_PlanActivityMgmt.GetPlanGrou) |
| WK-SCP0122-0128 | B3 | `filterCalls#2` `dtActivityCdAll CODE='< | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `filterCalls#2` `dtActivityCdAll CODE='<actv_cd>'`: 행 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 1 (`filterCalls#2` `dtActivityCdAll CODE='<) |
| WK-SCP0122-0129 | B3 | 셀콤보 `SetComBoParam("ActivityCode",dtActi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 셀콤보 `SetComBoParam("ActivityCode",dtActivityCdAll): 행 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 `SetComBoParam("ActivityCode",dtActi) |
| WK-SCP0122-0130 | B4 | SCP0122_PlanActivityMgmt.GetPlanGroupByU | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0122_PlanActivityMgmt.GetPlanGroupByUserID: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0122_PlanActivityMgmt.GetPlanGrou) |
| WK-SCP0122-0131 | B4 | `filterCalls#2` `dtActivityCdAll CODE='< | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `filterCalls#2` `dtActivityCdAll CODE='<actv_cd>'`: 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (`filterCalls#2` `dtActivityCdAll CODE='<) |
| WK-SCP0122-0132 | B4 | 셀콤보 `SetComBoParam("ActivityCode",dtActi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 셀콤보 `SetComBoParam("ActivityCode",dtActivityCdAll): 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 `SetComBoParam("ActivityCode",dtActi) |
| WK-SCP0122-0133 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0122-0134 | A5 | SCP0122_PlanActivityMgmt.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0122_PlanActivityMgmt.CreateSpread: 진입점 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0122_PlanActivityMgmt.CreateSprea) |
| WK-SCP0122-0135 | A5 | SCP0122_PlanActivityMgmt.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0122_PlanActivityMgmt.SetSpreadInit: 진입점 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0122_PlanActivityMgmt.SetSpreadIn) |
| WK-SCP0122-0136 | A5 | `ClbDivision_SelectedIndexChanged`→`Refr | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `ClbDivision_SelectedIndexChanged`→`RefreshPlanGro: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`ClbDivision_SelectedIndexChanged`→`Refr) |
| WK-SCP0122-0137 | A5 | `DeleteButton`→`siMain.Delete` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `DeleteButton`→`siMain.Delete`: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`DeleteButton`→`siMain.Delete`) |
| WK-SCP0122-0138 | A5 | `Insert_Row` 기본값 5컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `Insert_Row` 기본값 5컬럼: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`Insert_Row` 기본값 5컬럼) |
| WK-SCP0122-0139 | A5 | `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `LockColumn(0,MaxCol,true)` 조회직후 전체잠금: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`LockColumn(0,MaxCol,true)` 조회직후 전체잠금) |
| WK-SCP0122-0140 | A5 | `Query(ds)` GET SP 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `Query(ds)` GET SP 바인딩: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`Query(ds)` GET SP 바인딩) |
| WK-SCP0122-0141 | A5 | `Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세션): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세) |
| WK-SCP0122-0142 | A5 | `SetSheetHeaderColumnSCP`(SCM_MST_SHEET_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `SetSheetHeaderColumnSCP`(SCM_MST_SHEET_COLUMNS 구동: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetHeaderColumnSCP`(SCM_MST_SHEET_) |
| WK-SCP0122-0143 | A5 | `filterCalls#2` `dtActivityCdAll CODE='< | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `filterCalls#2` `dtActivityCdAll CODE='<actv_cd>'`: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`filterCalls#2` `dtActivityCdAll CODE='<) |
| WK-SCP0122-0144 | A5 | 셀콤보 `SetComBoParam("ActivityCode",dtActi | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 셀콤보 `SetComBoParam("ActivityCode",dtActivityCdAll): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 `SetComBoParam("ActivityCode",dtActi) |
| WK-SCP0122-0145 | A5 | 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00443: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00) |
| WK-SCP0122-0146 | A5 | 필수검증(actv_cd/actv_seq 공백 MSG00001) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 필수검증(actv_cd/actv_seq 공백 MSG00001): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (필수검증(actv_cd/actv_seq 공백 MSG00001)) |
| WK-SCP0122-0147 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0122-0148 | H2 | SCP0122_PlanActivityMgmt.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0122_PlanActivityMgmt.CreateSpread: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0122_PlanActivityMgmt.CreateSprea) |
| WK-SCP0122-0149 | H2 | SCP0122_PlanActivityMgmt.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0122_PlanActivityMgmt.SetSpreadInit: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0122_PlanActivityMgmt.SetSpreadIn) |
| WK-SCP0122-0150 | H2 | `ClbDivision_SelectedIndexChanged`→`Refr | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `ClbDivision_SelectedIndexChanged`→`RefreshPlanGro: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`ClbDivision_SelectedIndexChanged`→`Refr) |
| WK-SCP0122-0151 | H2 | `DeleteButton`→`siMain.Delete` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `DeleteButton`→`siMain.Delete`: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`DeleteButton`→`siMain.Delete`) |
| WK-SCP0122-0152 | H2 | `Insert_Row` 기본값 5컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `Insert_Row` 기본값 5컬럼: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`Insert_Row` 기본값 5컬럼) |
| WK-SCP0122-0153 | H2 | `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `LockColumn(0,MaxCol,true)` 조회직후 전체잠금: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`LockColumn(0,MaxCol,true)` 조회직후 전체잠금) |
| WK-SCP0122-0154 | H2 | `Query(ds)` GET SP 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `Query(ds)` GET SP 바인딩: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`Query(ds)` GET SP 바인딩) |
| WK-SCP0122-0155 | H2 | `Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세션): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세) |
| WK-SCP0122-0156 | H2 | `SetSheetHeaderColumnSCP`(SCM_MST_SHEET_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `SetSheetHeaderColumnSCP`(SCM_MST_SHEET_COLUMNS 구동: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetHeaderColumnSCP`(SCM_MST_SHEET_) |
| WK-SCP0122-0157 | H2 | `filterCalls#2` `dtActivityCdAll CODE='< | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `filterCalls#2` `dtActivityCdAll CODE='<actv_cd>'`: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`filterCalls#2` `dtActivityCdAll CODE='<) |
| WK-SCP0122-0158 | H2 | 셀콤보 `SetComBoParam("ActivityCode",dtActi | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 셀콤보 `SetComBoParam("ActivityCode",dtActivityCdAll): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 `SetComBoParam("ActivityCode",dtActi) |
| WK-SCP0122-0159 | H2 | 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00443: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00) |
| WK-SCP0122-0160 | H2 | 필수검증(actv_cd/actv_seq 공백 MSG00001) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 필수검증(actv_cd/actv_seq 공백 MSG00001): 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (필수검증(actv_cd/actv_seq 공백 MSG00001)) |
| WK-SCP0122-0161 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0122-0162 | H5 | SCP0122_PlanActivityMgmt.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0122_PlanActivityMgmt.CreateSpread: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0122_PlanActivityMgmt.CreateSprea) |
| WK-SCP0122-0163 | H5 | SCP0122_PlanActivityMgmt.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0122_PlanActivityMgmt.SetSpreadInit: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0122_PlanActivityMgmt.SetSpreadIn) |
| WK-SCP0122-0164 | H5 | `ClbDivision_SelectedIndexChanged`→`Refr | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `ClbDivision_SelectedIndexChanged`→`RefreshPlanGro: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`ClbDivision_SelectedIndexChanged`→`Refr) |
| WK-SCP0122-0165 | H5 | `DeleteButton`→`siMain.Delete` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `DeleteButton`→`siMain.Delete`: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`DeleteButton`→`siMain.Delete`) |
| WK-SCP0122-0166 | H5 | `Insert_Row` 기본값 5컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `Insert_Row` 기본값 5컬럼: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`Insert_Row` 기본값 5컬럼) |
| WK-SCP0122-0167 | H5 | `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `LockColumn(0,MaxCol,true)` 조회직후 전체잠금: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`LockColumn(0,MaxCol,true)` 조회직후 전체잠금) |
| WK-SCP0122-0168 | H5 | `Query(ds)` GET SP 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `Query(ds)` GET SP 바인딩: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`Query(ds)` GET SP 바인딩) |
| WK-SCP0122-0169 | H5 | `Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세션): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`Save_Data` 캐럿(^)접기 7파라미터(+`p_user_id` 세) |
| WK-SCP0122-0170 | H5 | `SetSheetHeaderColumnSCP`(SCM_MST_SHEET_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `SetSheetHeaderColumnSCP`(SCM_MST_SHEET_COLUMNS 구동: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetHeaderColumnSCP`(SCM_MST_SHEET_) |
| WK-SCP0122-0171 | H5 | `filterCalls#2` `dtActivityCdAll CODE='< | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `filterCalls#2` `dtActivityCdAll CODE='<actv_cd>'`: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`filterCalls#2` `dtActivityCdAll CODE='<) |
| WK-SCP0122-0172 | H5 | 셀콤보 `SetComBoParam("ActivityCode",dtActi | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 셀콤보 `SetComBoParam("ActivityCode",dtActivityCdAll): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 `SetComBoParam("ActivityCode",dtActi) |
| WK-SCP0122-0173 | H5 | 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00443: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00) |
| WK-SCP0122-0174 | H5 | 필수검증(actv_cd/actv_seq 공백 MSG00001) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 필수검증(actv_cd/actv_seq 공백 MSG00001): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (필수검증(actv_cd/actv_seq 공백 MSG00001)) |
| WK-SCP0122-0175 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 - Column/Measure 설정 버튼 없음(SCP0122 Measure 0건,  |  | 1 (COMMON:UC-03) |
| WK-SCP0122-0176 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 - 조회조건 3콤보(Division/PlanGroup/Process)만 — 자유 key-in 콤마 다중검색 텍스트 필드 |  | 1 (COMMON:UC-06) |
| WK-SCP0122-0177 | X-REASON | `prsCd`(GET) = `CString.GetCheckedListVa | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `prsCd`(GET) = `CString.GetCheckedListValue(dtPlanGroup, cboProcess.SelectedValue)` cs:310 AS-IS 오타 인자(dtPlanGr |  | 1 (`prsCd`(GET) = `CString.GetCheckedListVa) |
| WK-SCP0122-0178 | D1 | SCP0122_PlanActivityMgmt.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0122_PlanActivityMgmt.EditButton: 진입점 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0122_PlanActivityMgmt.EditButton:) |
| WK-SCP0122-0179 | D1 | `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `LockColumn(0,MaxCol,true)` 조회직후 전체잠금: 행 집계 — D1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`LockColumn(0,MaxCol,true)` 조회직후 전체잠금) |
| WK-SCP0122-0180 | D3 | SCP0122_PlanActivityMgmt.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0122_PlanActivityMgmt.EditButton: 진입점 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0122_PlanActivityMgmt.EditButton:) |
| WK-SCP0122-0181 | D3 | `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `LockColumn(0,MaxCol,true)` 조회직후 전체잠금: 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`LockColumn(0,MaxCol,true)` 조회직후 전체잠금) |
| WK-SCP0122-0182 | D4 | `Insert_Row` 기본값 5컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — `Insert_Row` 기본값 5컬럼: 행 집계 — D4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`Insert_Row` 기본값 5컬럼) |
| WK-SCP0122-0183 | D5 | SCP0122_PlanActivityMgmt.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0122_PlanActivityMgmt.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0122_PlanActivityMgmt.CreateSprea) |
| WK-SCP0122-0184 | D5 | SCP0122_PlanActivityMgmt.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0122_PlanActivityMgmt.SetSpreadInit: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0122_PlanActivityMgmt.SetSpreadIn) |
| WK-SCP0122-0185 | E4 | SCP0122_PlanActivityMgmt.SetChangedContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0122_PlanActivityMgmt.SetChangedControl: 진입점 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.SetChangedC) |
| WK-SCP0122-0186 | E4 | SCP0122_PlanActivityMgmt.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0122_PlanActivityMgmt.SetSpreadInit: 진입점 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0122_PlanActivityMgmt.SetSpreadIn) |
| WK-SCP0122-0187 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0122-0188 | A1 | MSG00097 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MSG00097: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (MSG00097) |
| WK-SCP0122-0189 | A1 | PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_MGMT: 골든 비교 케이스 없음(PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_MGMT — 팝업·보조 SP 는 g |  | 34 (ACT:SCP0122_PlanActivityMgmt.FindButton ) |
| WK-SCP0122-0190 | A1 | `BLUtils.GetDivision(false,"")` → `Divis | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `BLUtils.GetDivision(false,"")` → `Division_SCP`: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`BLUtils.GetDivision(false,"")` → `Divis) |
| WK-SCP0122-0191 | A1 | `CboPlanGroup_SelectedIndexChanged`→`Cle | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `CboPlanGroup_SelectedIndexChanged`→`ClearDataSour: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`CboPlanGroup_SelectedIndexChanged`→`Cle) |
| WK-SCP0122-0192 | A1 | `ClbDivision_SelectedIndexChanged`→`Refr | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `ClbDivision_SelectedIndexChanged`→`RefreshPlanGro: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`ClbDivision_SelectedIndexChanged`→`Refr) |
| WK-SCP0122-0193 | A1 | `Data.Common(LookupCommon,false,"OPMZ_PR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `Data.Common(LookupCommon,false,"OPMZ_PRS_CD")`: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`Data.Common(LookupCommon,false,"OPMZ_PR) |
| WK-SCP0122-0194 | A1 | `GetPlanGroupByUserID()` Tables[3] → `Pl | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `GetPlanGroupByUserID()` Tables[3] → `PlanGroup_SC: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`GetPlanGroupByUserID()` Tables[3] → `Pl) |
| WK-SCP0122-0195 | A1 | `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `LockColumn(0,MaxCol,true)` 조회직후 전체잠금: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`LockColumn(0,MaxCol,true)` 조회직후 전체잠금) |
| WK-SCP0122-0196 | A1 | `RefreshPlanGroupByDivision` DIVISION_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `RefreshPlanGroupByDivision` DIVISION_ID='' 필터 → 후: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`RefreshPlanGroupByDivision` DIVISION_ID) |
| WK-SCP0122-0197 | A1 | `SetDivisionAuthCheck`(`dtMyDivision.Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `SetDivisionAuthCheck`(`dtMyDivision.Rows.Count==0: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0198 | A1 | 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00443: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00) |
| WK-SCP0122-0199 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0122-0200 | G1 | MSG00097 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MSG00097: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MSG00097) |
| WK-SCP0122-0201 | G1 | `CboPlanGroup_SelectedIndexChanged`→`Cle | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `CboPlanGroup_SelectedIndexChanged`→`ClearDataSour: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`CboPlanGroup_SelectedIndexChanged`→`Cle) |
| WK-SCP0122-0202 | G1 | `ClbDivision_SelectedIndexChanged`→`Refr | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `ClbDivision_SelectedIndexChanged`→`RefreshPlanGro: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`ClbDivision_SelectedIndexChanged`→`Refr) |
| WK-SCP0122-0203 | G1 | `Data.Common(LookupCommon,false,"OPMZ_PR | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `Data.Common(LookupCommon,false,"OPMZ_PRS_CD")`: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(LookupCommon,false,"OPMZ_PR) |
| WK-SCP0122-0204 | G1 | `GetPlanGroupByUserID()` Tables[3] → `Pl | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `GetPlanGroupByUserID()` Tables[3] → `PlanGroup_SC: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`GetPlanGroupByUserID()` Tables[3] → `Pl) |
| WK-SCP0122-0205 | G1 | `LockColumn(0,MaxCol,true)` 조회직후 전체잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `LockColumn(0,MaxCol,true)` 조회직후 전체잠금: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`LockColumn(0,MaxCol,true)` 조회직후 전체잠금) |
| WK-SCP0122-0206 | G1 | `RefreshPlanGroupByDivision` DIVISION_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `RefreshPlanGroupByDivision` DIVISION_ID='' 필터 → 후: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`RefreshPlanGroupByDivision` DIVISION_ID) |
| WK-SCP0122-0207 | G1 | `SetDivisionAuthCheck`(`dtMyDivision.Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `SetDivisionAuthCheck`(`dtMyDivision.Rows.Count==0: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0208 | G1 | 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00443: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (중복체크(I행 PRS_CD+PLAN_GR_ID+ACTV_CD) MSG00) |
| WK-SCP0122-0209 | G6 | `CboPlanGroup_SelectedIndexChanged`→`Cle | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `CboPlanGroup_SelectedIndexChanged`→`ClearDataSour: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`CboPlanGroup_SelectedIndexChanged`→`Cle) |
| WK-SCP0122-0210 | G6 | `ClbDivision_SelectedIndexChanged`→`Refr | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `ClbDivision_SelectedIndexChanged`→`RefreshPlanGro: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`ClbDivision_SelectedIndexChanged`→`Refr) |
| WK-SCP0122-0211 | G6 | `Data.Common(LookupCommon,false,"OPMZ_PR | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `Data.Common(LookupCommon,false,"OPMZ_PRS_CD")`: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(LookupCommon,false,"OPMZ_PR) |
| WK-SCP0122-0212 | G6 | `GetPlanGroupByUserID()` Tables[3] → `Pl | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `GetPlanGroupByUserID()` Tables[3] → `PlanGroup_SC: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`GetPlanGroupByUserID()` Tables[3] → `Pl) |
| WK-SCP0122-0213 | G6 | `RefreshPlanGroupByDivision` DIVISION_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `RefreshPlanGroupByDivision` DIVISION_ID='' 필터 → 후: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`RefreshPlanGroupByDivision` DIVISION_ID) |
| WK-SCP0122-0214 | G6 | `SetDivisionAuthCheck`(`dtMyDivision.Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `SetDivisionAuthCheck`(`dtMyDivision.Rows.Count==0: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`SetDivisionAuthCheck`(`dtMyDivision.Row) |
| WK-SCP0122-0215 | X-ROW | SCP0122_PlanActivityMgmt.CboPlanGroup_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.CboPlanGroup_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.CboPlanGrou) |
| WK-SCP0122-0216 | X-ROW | SCP0122_PlanActivityMgmt.ClbDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.ClbDivision_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.ClbDivision) |
| WK-SCP0122-0217 | X-ROW | SCP0122_PlanActivityMgmt.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.CreateSprea) |
| WK-SCP0122-0218 | X-ROW | SCP0122_PlanActivityMgmt.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0122_PlanActivityMgmt.FindButton) |
| WK-SCP0122-0219 | X-ROW | SCP0122_PlanActivityMgmt.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.FindData_Main: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0122_PlanActivityMgmt.FindData_Ma) |
| WK-SCP0122-0220 | X-ROW | SCP0122_PlanActivityMgmt.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.Form_Load) |
| WK-SCP0122-0221 | X-ROW | SCP0122_PlanActivityMgmt.GetPlanGroupByU | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.GetPlanGroupByUserID: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요 |  | 2 (ACT:SCP0122_PlanActivityMgmt.GetPlanGrou) |
| WK-SCP0122-0222 | X-ROW | SCP0122_PlanActivityMgmt.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.InitControls: 진입점 집계 7검사 — NOT_RUN:5 · PASS:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0122_PlanActivityMgmt.InitControl) |
| WK-SCP0122-0223 | X-ROW | SCP0122_PlanActivityMgmt.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.InitSpread) |
| WK-SCP0122-0224 | X-ROW | SCP0122_PlanActivityMgmt.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.InsertButto) |
| WK-SCP0122-0225 | X-ROW | SCP0122_PlanActivityMgmt.Insert_Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.Insert_Row: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 18 (ACT:SCP0122_PlanActivityMgmt.Insert_Row ) |
| WK-SCP0122-0226 | X-ROW | SCP0122_PlanActivityMgmt.RefreshPlanGrou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.RefreshPlanGroupByDivisio: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0122_PlanActivityMgmt.RefreshPlan) |
| WK-SCP0122-0227 | X-ROW | SCP0122_PlanActivityMgmt.Save_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.Save_Data: 진입점 집계 9검사 — NOT_RUN:7 · PASS:2 (미실행 검사가 남아 판정필요) |  | 82 (ACT:SCP0122_PlanActivityMgmt.Save_Data A) |
| WK-SCP0122-0228 | X-ROW | SCP0122_PlanActivityMgmt.SetChangedContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.SetChangedC) |
| WK-SCP0122-0229 | X-ROW | SCP0122_PlanActivityMgmt.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0122_PlanActivityMgmt.SetSpreadIn) |
| WK-SCP0122-0230 | X-ROW | SCP0122_PlanActivityMgmt.SpdMain_Clipboa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.SpdMain_ClipboardPasted: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Cli) |
| WK-SCP0122-0231 | X-ROW | SCP0122_PlanActivityMgmt.SpdMain_ComboSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.SpdMain_ComboSelChange: 진입점 집계 24검사 — NOT_RUN:21 · REVIEW:3 |  | 6 (ACT:SCP0122_PlanActivityMgmt.SpdMain_Com) |
| WK-SCP0122-0232 | X-ROW | SCP0122_PlanActivityMgmt.spdMain_CellCli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0122_PlanActivityMgmt.spdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0122_PlanActivityMgmt.spdMain_Cel) |
