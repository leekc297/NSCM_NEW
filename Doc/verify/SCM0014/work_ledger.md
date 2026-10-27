# 작업 원장 — SCM0014 · 2026-10-26 12:51

> 검사 인스턴스 169건 중 PASS·NA 38건 외 **131건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 21 | 구현 위치 실존 |
| W4 | 검사기 구현 | 2 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 14 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 41 | 실행 → PASS |
| W7 | 기대값 확정 | 53 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 53 · E2E 41 · 대조표 21 · 하네스 16
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 21 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 17 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 13 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 4 | 6 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G4 | DESIGN |  |  |  |  | 2 | 4 | 2 |  |  | 조회조건 표시·라벨·활성 |
| G5 | POPUP |  |  |  |  | 6 |  | 1 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 4 | 1 |  |  | 팝업 표준·열림 |
| H5 | DESIGN |  |  |  |  |  | 1 | 6 |  |  | 라벨 명칭 |
| G6 | GEN |  |  |  |  |  | 4 | 3 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| M4 | POPUP |  |  |  |  |  | 6 | 1 |  |  | 팝업 선택값 반영 |
| B3 | COMBO |  |  |  | 2 |  |  | 1 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 2 |  | 1 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| E4 | EDIT |  |  |  |  |  | 3 |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C1 | CASCADE |  |  |  |  |  | 2 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F4 | DB |  |  |  |  |  | 1 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
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
| A6 | GEN |  |  |  |  |  | 1 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (21)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0014-0001 | X-LOC | (Excel — BaseForm 표준 export) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((Excel — BaseForm 표준 export)) |
| WK-SCM0014-0002 | X-LOC | (Save/Insert/Delete override 없음) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((Save/Insert/Delete override 없음)) |
| WK-SCM0014-0003 | X-LOC | EditButton → GMessageBox('MSG00109'); re | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton → GMessageBox('MSG00109'); re) |
| WK-SCM0014-0004 | X-LOC | FindButton → Find_Data() | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton → Find_Data()) |
| WK-SCM0014-0005 | X-LOC | InitSpread() 리터럴 22컬럼·헤더 span·Freeze | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (InitSpread() 리터럴 22컬럼·헤더 span·Freeze) |
| WK-SCM0014-0006 | X-LOC | LockColumn(0,max,true) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn(0,max,true)) |
| WK-SCM0014-0007 | X-LOC | Query(ds) 시트 바인딩 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Query(ds) 시트 바인딩) |
| WK-SCM0014-0008 | X-LOC | R1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R1) |
| WK-SCM0014-0009 | X-LOC | R2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R2) |
| WK-SCM0014-0010 | X-LOC | R3/S1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R3/S1) |
| WK-SCM0014-0011 | X-LOC | R4/R5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R4/R5) |
| WK-SCM0014-0012 | X-LOC | R6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R6) |
| WK-SCM0014-0013 | X-LOC | R7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R7) |
| WK-SCM0014-0014 | X-LOC | SetSheetHeaderColumn(siMain,2) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetSheetHeaderColumn(siMain,2)) |
| WK-SCM0014-0015 | X-LOC | btnItemId → SCM0002_ItembyDivisionPopup | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnItemId → SCM0002_ItembyDivisionPopup) |
| WK-SCM0014-0016 | X-LOC | btnProjectID → SCM0002_ProjectbyDivision | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnProjectID → SCM0002_ProjectbyDivision) |
| WK-SCM0014-0017 | X-LOC | cboDivision = Data.Common(Type.MyDivisio | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboDivision = Data.Common(Type.MyDivisio) |
| WK-SCM0014-0018 | X-LOC | cboResultType = Data.Common(Type.LookupC | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboResultType = Data.Common(Type.LookupC) |
| WK-SCM0014-0019 | X-LOC | drpPeriod = GetDayRange() | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (drpPeriod = GetDayRange()) |
| WK-SCM0014-0020 | X-LOC | txtPlantSite (TextBox, 콤보 주석) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtPlantSite (TextBox, 콤보 주석)) |
| WK-SCM0014-0021 | X-LOC | txtSaleSite (TextBox, 콤보 주석) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtSaleSite (TextBox, 콤보 주석)) |

## W4 검사기 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0014-0022 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 1 (cboDivision = Data.Common(Type.MyDivisio) |
| WK-SCM0014-0023 | B3 | cboResultType / Result Type / Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboResultType / Result Type / Type | 있음(FE 소스) | 1 (cboResultType = Data.Common(Type.LookupC) |

## W5 검사기 연결 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0014-0024 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (cboDivision = Data.Common(Type.MyDivisio) |
| WK-SCM0014-0025 | B4 | cboResultType / Result Type / Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboResultType / Result Type / Type | 있음(FE 소스) | 1 (cboResultType = Data.Common(Type.LookupC) |
| WK-SCM0014-0026 | F2 | SCM0014 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCM0014 화면 | 판단불가(대상 단위 SCREEN) | 1 ((Save/Insert/Delete override 없음)) |
| WK-SCM0014-0027 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 3 (btnItemId → SCM0002_ItembyDivisionPopup ) |
| WK-SCM0014-0028 | G4 | btnProjectID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProjectID | 있음(FE 소스) | 3 (btnProjectID → SCM0002_ProjectbyDivision) |
| WK-SCM0014-0029 | G03-WIRE | SCM0014 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCM0014 화면 | 판단불가(대상 단위 SCREEN) | 7 (ACT:SCM0014_ValidationShipmentResult..ct) |
| WK-SCM0014-0030 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (btnItemId → SCM0002_ItembyDivisionPopup) |
| WK-SCM0014-0031 | G5 | btnProjectID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnProjectID | 있음(FE 소스) | 1 (btnProjectID → SCM0002_ProjectbyDivision) |
| WK-SCM0014-0032 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (cboDivision = Data.Common(Type.MyDivisio) |
| WK-SCM0014-0033 | G5 | cboResultType / Result Type / Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboResultType / Result Type / Type | 있음(FE 소스) | 1 (cboResultType = Data.Common(Type.LookupC) |
| WK-SCM0014-0034 | G5 | txtPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtPlantSite / Plant Site | 있음(FE 소스) | 2 (txtPlantSite (TextBox, 콤보 주석) btnItemId ) |
| WK-SCM0014-0035 | G5 | txtSaleSite / Sales Site / Sale Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtSaleSite / Sales Site / Sale Site | 있음(FE 소스) | 1 (txtSaleSite (TextBox, 콤보 주석)) |
| WK-SCM0014-0036 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (btnItemId → SCM0002_ItembyDivisionPopup) |
| WK-SCM0014-0037 | H6 | btnProjectID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProjectID | 있음(FE 소스) | 1 (btnProjectID → SCM0002_ProjectbyDivision) |

## W6 검증 실행 (41)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0014-0038 | J2 | SCM0014 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCM0014 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 38 (FindButton → Find_Data() EditButton → GM) |
| WK-SCM0014-0039 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCM0014_ValidationShipmentResult.Ini) |
| WK-SCM0014-0040 | C1 | cboResultType / Result Type / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboResultType / Result Type / Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCM0014_ValidationShipmentResult.Ini) |
| WK-SCM0014-0041 | G3 | SCM0014 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCM0014 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 1 (R7) |
| WK-SCM0014-0042 | K-SA | SCM0014 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCM0014 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (R7) |
| WK-SCM0014-0043 | K4 | SCM0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCM0014 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 23 (ACT:SCM0014_ValidationShipmentResult.Btn) |
| WK-SCM0014-0044 | F1 | SCM0014 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCM0014 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 1 ((Save/Insert/Delete override 없음)) |
| WK-SCM0014-0045 | F5 | SCM0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCM0014 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 ((Save/Insert/Delete override 없음)) |
| WK-SCM0014-0046 | F4 | PKG_SCM0014.P_SCM0014_GET_VALIDATION_SHI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0014.P_SCM0014_GET_VALIDATION_SHIPMENT_RESU · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 5 (ACT:SCM0014_ValidationShipmentResult.Fin) |
| WK-SCM0014-0047 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboDivision = Data.Common(Type.MyDivisio) |
| WK-SCM0014-0048 | G4 | cboResultType / Result Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboResultType / Result Type / Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (cboResultType = Data.Common(Type.LookupC) |
| WK-SCM0014-0049 | G4 | txtPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (txtPlantSite (TextBox, 콤보 주석) btnItemId ) |
| WK-SCM0014-0050 | G4 | txtSaleSite / Sales Site / Sale Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtSaleSite / Sales Site / Sale Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtSaleSite (TextBox, 콤보 주석)) |
| WK-SCM0014-0051 | H5 | cboDivision / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboDivision / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R6) |
| WK-SCM0014-0052 | I1 | SCM0014 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCM0014 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 4 (EditButton → GMessageBox('MSG00109'); re) |
| WK-SCM0014-0053 | SC1 | SCM0014 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCM0014 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 8 (R3/S1 cboDivision = Data.Common(Type.MyD) |
| WK-SCM0014-0054 | D6 | SCM0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCM0014 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 ((Save/Insert/Delete override 없음)) |
| WK-SCM0014-0055 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R1) |
| WK-SCM0014-0056 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (EditButton → GMessageBox('MSG00109'); re) |
| WK-SCM0014-0057 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCM0014_ValidationShipmentResult.Set) |
| WK-SCM0014-0058 | A10 | SCM0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCM0014 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 76 (ACT:SCM0014_ValidationShipmentResult.Def) |
| WK-SCM0014-0059 | A6 | PKG_SCM0014.P_SCM0014_GET_VALIDATION_SHI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0014.P_SCM0014_GET_VALIDATION_SHIPMENT_RESU · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 2 (ACT:SCM0014_ValidationShipmentResult.Fin) |
| WK-SCM0014-0060 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (R6 cboDivision = Data.Common(Type.MyDivi) |
| WK-SCM0014-0061 | G1 | cboResultType / Result Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboResultType / Result Type / Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (cboResultType = Data.Common(Type.LookupC) |
| WK-SCM0014-0062 | G1 | txtPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (txtPlantSite (TextBox, 콤보 주석) btnItemId ) |
| WK-SCM0014-0063 | G1 | txtSaleSite / Sales Site / Sale Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtSaleSite / Sales Site / Sale Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (txtSaleSite (TextBox, 콤보 주석)) |
| WK-SCM0014-0064 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboDivision = Data.Common(Type.MyDivisio) |
| WK-SCM0014-0065 | G6 | cboResultType / Result Type / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboResultType / Result Type / Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (cboResultType = Data.Common(Type.LookupC) |
| WK-SCM0014-0066 | G6 | txtPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (txtPlantSite (TextBox, 콤보 주석) btnItemId ) |
| WK-SCM0014-0067 | G6 | txtSaleSite / Sales Site / Sale Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtSaleSite / Sales Site / Sale Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtSaleSite (TextBox, 콤보 주석)) |
| WK-SCM0014-0068 | X-REOPEN | SCM0014 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCM0014 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:SCM0014_ValidationShipmentResult.Dis) |
| WK-SCM0014-0069 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (cboDivision = Data.Common(Type.MyDivisio) |
| WK-SCM0014-0070 | H6 | cboResultType / Result Type / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboResultType / Result Type / Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (cboResultType = Data.Common(Type.LookupC) |
| WK-SCM0014-0071 | H6 | txtPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtPlantSite / Plant Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (txtPlantSite (TextBox, 콤보 주석) btnItemId ) |
| WK-SCM0014-0072 | H6 | txtSaleSite / Sales Site / Sale Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtSaleSite / Sales Site / Sale Site · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (txtSaleSite (TextBox, 콤보 주석)) |
| WK-SCM0014-0073 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (btnItemId → SCM0002_ItembyDivisionPopup) |
| WK-SCM0014-0074 | M4 | btnProjectID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnProjectID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (btnProjectID → SCM0002_ProjectbyDivision) |
| WK-SCM0014-0075 | M4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (cboDivision = Data.Common(Type.MyDivisio) |
| WK-SCM0014-0076 | M4 | cboResultType / Result Type / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboResultType / Result Type / Type · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (cboResultType = Data.Common(Type.LookupC) |
| WK-SCM0014-0077 | M4 | txtPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (txtPlantSite (TextBox, 콤보 주석) btnItemId ) |
| WK-SCM0014-0078 | M4 | txtSaleSite / Sales Site / Sale Site | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtSaleSite / Sales Site / Sale Site · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (txtSaleSite (TextBox, 콤보 주석)) |

## W7 기대값 확정 (53)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0014-0079 | B3 | SCM0014_ValidationShipmentResult.GetDayR | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCM0014_ValidationShipmentResult.GetDayRange: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCM0014_ValidationShipmentResult.Get) |
| WK-SCM0014-0080 | B4 | SCM0014_ValidationShipmentResult.GetDayR | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCM0014_ValidationShipmentResult.GetDayRange: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCM0014_ValidationShipmentResult.Get) |
| WK-SCM0014-0081 | F4 | SCM0014_ValidationShipmentResult.GetDayR | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCM0014_ValidationShipmentResult.GetDayRange: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCM0014_ValidationShipmentResult.Get) |
| WK-SCM0014-0082 | G4 | R3/S1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — R3/S1: 행 집계 — G4 6요소: NOT_RUN:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (R3/S1) |
| WK-SCM0014-0083 | G4 | drpPeriod = GetDayRange() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — drpPeriod = GetDayRange(): 행 집계 — G4 6요소: NOT_RUN:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (drpPeriod = GetDayRange()) |
| WK-SCM0014-0084 | H5 | InitSpread() 리터럴 22컬럼·헤더 span·Freeze | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — InitSpread() 리터럴 22컬럼·헤더 span·Freeze: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (InitSpread() 리터럴 22컬럼·헤더 span·Freeze) |
| WK-SCM0014-0085 | H5 | LockColumn(0,max,true) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — LockColumn(0,max,true): 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(0,max,true)) |
| WK-SCM0014-0086 | H5 | Query(ds) 시트 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Query(ds) 시트 바인딩: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Query(ds) 시트 바인딩) |
| WK-SCM0014-0087 | H5 | R4/R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R4/R5: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R4/R5) |
| WK-SCM0014-0088 | H5 | SCM0014_ValidationShipmentResult.CreateS | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCM0014_ValidationShipmentResult.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCM0014_ValidationShipmentResult.Cre) |
| WK-SCM0014-0089 | H5 | SetSheetHeaderColumn(siMain,2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SetSheetHeaderColumn(siMain,2): 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SetSheetHeaderColumn(siMain,2)) |
| WK-SCM0014-0090 | A1 | FindButton → Find_Data() | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton → Find_Data(): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (FindButton → Find_Data()) |
| WK-SCM0014-0091 | A1 | PKG_SCM0014.P_SCM0014_GET_VALIDATION_SHI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0014.P_SCM0014_GET_VALIDATION_SHIPMENT_RESU: 골든 비교 케이스 없음(PKG_SCM0014.P_SCM0014_GET_VALIDATION_SHIPMENT_RESULT  |  | 3 (ACT:SCM0014_ValidationShipmentResult.Fin) |
| WK-SCM0014-0092 | A1 | R1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R1: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (R1) |
| WK-SCM0014-0093 | A1 | R3/S1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R3/S1: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (R3/S1) |
| WK-SCM0014-0094 | A1 | R4/R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R4/R5: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (R4/R5) |
| WK-SCM0014-0095 | A1 | R6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R6: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (R6) |
| WK-SCM0014-0096 | A1 | btnItemId → SCM0002_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnItemId → SCM0002_ItembyDivisionPopup: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (btnItemId → SCM0002_ItembyDivisionPopup) |
| WK-SCM0014-0097 | A1 | btnProjectID → SCM0002_ProjectbyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnProjectID → SCM0002_ProjectbyDivisionPopup: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (btnProjectID → SCM0002_ProjectbyDivision) |
| WK-SCM0014-0098 | A1 | cboDivision = Data.Common(Type.MyDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision = Data.Common(Type.MyDivision): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (cboDivision = Data.Common(Type.MyDivisio) |
| WK-SCM0014-0099 | A1 | cboResultType = Data.Common(Type.LookupC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboResultType = Data.Common(Type.LookupCommon,'SHI: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (cboResultType = Data.Common(Type.LookupC) |
| WK-SCM0014-0100 | A1 | drpPeriod = GetDayRange() | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — drpPeriod = GetDayRange(): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (drpPeriod = GetDayRange()) |
| WK-SCM0014-0101 | A1 | txtPlantSite (TextBox, 콤보 주석) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtPlantSite (TextBox, 콤보 주석): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (txtPlantSite (TextBox, 콤보 주석)) |
| WK-SCM0014-0102 | A1 | txtSaleSite (TextBox, 콤보 주석) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtSaleSite (TextBox, 콤보 주석): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (txtSaleSite (TextBox, 콤보 주석)) |
| WK-SCM0014-0103 | G1 | FindButton → Find_Data() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton → Find_Data(): 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (FindButton → Find_Data()) |
| WK-SCM0014-0104 | G1 | R1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R1: 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R1) |
| WK-SCM0014-0105 | G1 | R3/S1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R3/S1: 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R3/S1) |
| WK-SCM0014-0106 | G1 | R4/R5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R4/R5: 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R4/R5) |
| WK-SCM0014-0107 | G1 | btnProjectID → SCM0002_ProjectbyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — btnProjectID → SCM0002_ProjectbyDivisionPopup: 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (btnProjectID → SCM0002_ProjectbyDivision) |
| WK-SCM0014-0108 | G1 | drpPeriod = GetDayRange() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — drpPeriod = GetDayRange(): 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (drpPeriod = GetDayRange()) |
| WK-SCM0014-0109 | G6 | R3/S1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — R3/S1: 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R3/S1) |
| WK-SCM0014-0110 | G6 | btnProjectID → SCM0002_ProjectbyDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — btnProjectID → SCM0002_ProjectbyDivisionPopup: 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (btnProjectID → SCM0002_ProjectbyDivision) |
| WK-SCM0014-0111 | G6 | drpPeriod = GetDayRange() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — drpPeriod = GetDayRange(): 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (drpPeriod = GetDayRange()) |
| WK-SCM0014-0112 | X-ROW | (Excel — BaseForm 표준 export) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — (Excel — BaseForm 표준 export): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 ((Excel — BaseForm 표준 export)) |
| WK-SCM0014-0113 | X-ROW | SCM0014_ValidationShipmentResult.BtnItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.BtnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCM0014_ValidationShipmentResult.Btn) |
| WK-SCM0014-0114 | X-ROW | SCM0014_ValidationShipmentResult.BtnProj | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.BtnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCM0014_ValidationShipmentResult.Btn) |
| WK-SCM0014-0115 | X-ROW | SCM0014_ValidationShipmentResult.CboDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.CboDivision_Selec: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0014_ValidationShipmentResult.Cbo) |
| WK-SCM0014-0116 | X-ROW | SCM0014_ValidationShipmentResult.ClearUs | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.ClearUsrCheckedLi: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, |  | 4 (ACT:SCM0014_ValidationShipmentResult.Cle) |
| WK-SCM0014-0117 | X-ROW | SCM0014_ValidationShipmentResult.CreateS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0014_ValidationShipmentResult.Cre) |
| WK-SCM0014-0118 | X-ROW | SCM0014_ValidationShipmentResult.DefineP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0014_ValidationShipmentResult.Def) |
| WK-SCM0014-0119 | X-ROW | SCM0014_ValidationShipmentResult.EditBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.EditButton: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0014_ValidationShipmentResult.Edi) |
| WK-SCM0014-0120 | X-ROW | SCM0014_ValidationShipmentResult.FindBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCM0014_ValidationShipmentResult.Fin) |
| WK-SCM0014-0121 | X-ROW | SCM0014_ValidationShipmentResult.Find_Da | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.Find_Data: 진입점 집계 5검사 — NOT_RUN:3 · PASS:1 · REVIEW:1 |  | 42 (ACT:SCM0014_ValidationShipmentResult.Fin) |
| WK-SCM0014-0122 | X-ROW | SCM0014_ValidationShipmentResult.Form_Lo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0014_ValidationShipmentResult.For) |
| WK-SCM0014-0123 | X-ROW | SCM0014_ValidationShipmentResult.GetDayR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.GetDayRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0014_ValidationShipmentResult.Get) |
| WK-SCM0014-0124 | X-ROW | SCM0014_ValidationShipmentResult.InitCon | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0014_ValidationShipmentResult.Ini) |
| WK-SCM0014-0125 | X-ROW | SCM0014_ValidationShipmentResult.InitSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0014_ValidationShipmentResult.Ini) |
| WK-SCM0014-0126 | X-ROW | SCM0014_ValidationShipmentResult.InitSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.InitSpread_2: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0014_ValidationShipmentResult.Ini) |
| WK-SCM0014-0127 | X-ROW | SCM0014_ValidationShipmentResult.SetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.SetChangedControl: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0014_ValidationShipmentResult.Set) |
| WK-SCM0014-0128 | X-ROW | SCM0014_ValidationShipmentResult.clbDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0014_ValidationShipmentResult.clbDivision_Selec: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0014_ValidationShipmentResult.clb) |
| WK-SCM0014-0129 | G5 | drpPeriod = GetDayRange() | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — drpPeriod = GetDayRange(): 행 집계 — G5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (drpPeriod = GetDayRange()) |
| WK-SCM0014-0130 | H6 | drpPeriod = GetDayRange() | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — drpPeriod = GetDayRange(): 행 집계 — H6 6요소: NOT_RUN:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (drpPeriod = GetDayRange()) |
| WK-SCM0014-0131 | M4 | drpPeriod = GetDayRange() | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — drpPeriod = GetDayRange(): 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (drpPeriod = GetDayRange()) |
