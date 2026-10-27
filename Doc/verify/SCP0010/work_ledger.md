# 작업 원장 — SCP0010 · 2026-10-26 12:52

> 검사 인스턴스 500건 중 PASS·NA 129건 외 **371건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 21 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 6 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 26 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 100 | 실행 → PASS |
| W7 | 기대값 확정 | 217 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 216 · E2E 100 · 하네스 32 · 대조표 22 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 12건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 88 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 21 |  |  |  |  | 27 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 27 | 14 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| H5 | DESIGN |  |  |  |  |  | 4 | 19 |  |  | 라벨 명칭 |
| G4 | DESIGN |  |  |  |  | 7 | 11 | 4 |  |  | 조회조건 표시·라벨·활성 |
| A1 | GEN |  |  |  |  |  |  | 19 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| B3 | COMBO |  |  |  | 6 |  |  | 11 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 6 |  | 11 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G1 | GEN |  |  |  |  |  | 9 | 8 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | GEN |  |  |  |  |  | 11 | 4 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F4 | DB |  |  |  |  |  | 11 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 8 |  | 1 |  |  | BE 계정 시노님·권한·대상 객체 |
| C1 | CASCADE |  |  |  |  |  | 9 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G5 | POPUP |  |  |  |  | 1 |  | 3 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 |  | 3 |  |  | 팝업 표준·열림 |
| A6 | GEN |  |  |  |  |  | 4 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| M4 | POPUP |  |  |  |  |  | 1 | 3 |  |  | 팝업 선택값 반영 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| M3 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 내부 기능(조회·CRUD) |
| X-REASON | DESIGN |  |  |  |  |  |  | 1 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |

## W2 구현 위치 확인 (21)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0010-0001 | X-LOC | 3-span 헤더 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3-span 헤더) |
| WK-SCP0010-0002 | X-LOC | BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래)) |
| WK-SCP0010-0003 | X-LOC | Bucket×chkSum visible 토글(§2.4, chkAll 예외 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Bucket×chkSum visible 토글(§2.4, chkAll 예외) |
| WK-SCP0010-0004 | X-LOC | Cascade 콤보 filter 정확 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: Form.tsx 없음 |  | 1 (Cascade 콤보 filter 정확) |
| WK-SCP0010-0005 | X-LOC | EE 조건부 표시 3건(R-A) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EE 조건부 표시 3건(R-A)) |
| WK-SCP0010-0006 | X-LOC | Fix 하이라이트(O_RC3) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Fix 하이라이트(O_RC3)) |
| WK-SCP0010-0007 | X-LOC | INVENTORY W_/M_ 후처리(마지막 D_ 값) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (INVENTORY W_/M_ 후처리(마지막 D_ 값)) |
| WK-SCP0010-0008 | X-LOC | `DeleteButton`(Click, `.cs` 본문 주석 1줄 NO- | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`DeleteButton`(Click, `.cs` 본문 주석 1줄 NO-) |
| WK-SCP0010-0009 | X-LOC | `EditButton`(잠금토글, buttonGuards #2/#3) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`EditButton`(잠금토글, buttonGuards #2/#3)) |
| WK-SCP0010-0010 | X-LOC | `ExcelButton` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`ExcelButton`) |
| WK-SCP0010-0011 | X-LOC | `SaveButton`(Click) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SaveButton`(Click)) |
| WK-SCP0010-0012 | X-LOC | `btnFix`(`BtnFix_Click`, 가드 CanUpdate/Is | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`btnFix`(`BtnFix_Click`, 가드 CanUpdate/Is) |
| WK-SCP0010-0013 | X-LOC | `btnNew`(`SCM0002_ShipmentPlanInsertPopu | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`btnNew`(`SCM0002_ShipmentPlanInsertPopu) |
| WK-SCP0010-0014 | X-LOC | `btnUnfix`(Fix 와 동일 가드 + MSG00016 confir | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`btnUnfix`(Fix 와 동일 가드 + MSG00016 confir) |
| WK-SCP0010-0015 | X-LOC | `pnlCondition`(HidePanel) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`pnlCondition`(HidePanel)) |
| WK-SCP0010-0016 | X-LOC | btnFix/Unfix/New 공통 disabled(`Set_FixBut | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnFix/Unfix/New 공통 disabled(`Set_FixBut) |
| WK-SCP0010-0017 | X-LOC | lint(`pnpm --dir nscm-fe/features/supply | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: bod/Bod.tsx 없음 |  | 1 (lint(`pnpm --dir nscm-fe/features/supply) |
| WK-SCP0010-0018 | X-LOC | type-check(`pnpm --dir nscm-fe/features/ | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: src/pages/integration-psi/IntegrationPsi.tsx 없음 |  | 1 (type-check(`pnpm --dir nscm-fe/features/) |
| WK-SCP0010-0019 | X-LOC | 인접 정보컬럼 세로 병합(R-I, Freeze=measure_label) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (인접 정보컬럼 세로 병합(R-I, Freeze=measure_label)) |
| WK-SCP0010-0020 | X-LOC | 저장 셀단위 검증(MSG00084/MSG00317) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (저장 셀단위 검증(MSG00084/MSG00317)) |
| WK-SCP0010-0021 | X-LOC | 정보컬럼 전건 잠금(R-J) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (정보컬럼 전건 잠금(R-J)) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0010-0022 | H10 | SCP0010 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0010 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: ShipmentPlanSemi.tsx |  | 3 (`btnUnfix`(Fix 와 동일 가드 + MSG00016 confir) |

## W4 검사기 구현 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0010-0023 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 5 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastPl) |
| WK-SCP0010-0024 | B3 | cboOperGroup / Operation Group / Oper Gr | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboOperGroup / Operation Group / Oper Group / Oper | 있음(FE 소스) | 1 (cboOperGroup) |
| WK-SCP0010-0025 | B3 | cboPlanDate / Plan-date / Plan Date | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 8 (ACT:SCP0010_Shipment_Plan_SEMI.GetDayRan) |
| WK-SCP0010-0026 | B3 | cboPlanSeq / Seq / Plan Seq / Seq. | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanSeq / Seq / Plan Seq / Seq. | 있음(FE 소스) | 4 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastPl) |
| WK-SCP0010-0027 | B3 | cboPlanType / Plan-type / Plan Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 6 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastPl) |
| WK-SCP0010-0028 | B3 | clbElecType / Electrode / Elec Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbElecType / Electrode / Elec Type | 있음(FE 소스) | 1 (clbElecType) |

## W5 검사기 연결 (26)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0010-0029 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 5 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastPl) |
| WK-SCP0010-0030 | B4 | cboOperGroup / Operation Group / Oper Gr | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboOperGroup / Operation Group / Oper Group / Oper | 있음(FE 소스) | 1 (cboOperGroup) |
| WK-SCP0010-0031 | B4 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 8 (ACT:SCP0010_Shipment_Plan_SEMI.GetDayRan) |
| WK-SCP0010-0032 | B4 | cboPlanSeq / Seq / Plan Seq / Seq. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanSeq / Seq / Plan Seq / Seq. | 있음(FE 소스) | 4 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastPl) |
| WK-SCP0010-0033 | B4 | cboPlanType / Plan-type / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 6 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastPl) |
| WK-SCP0010-0034 | B4 | clbElecType / Electrode / Elec Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbElecType / Electrode / Elec Type | 있음(FE 소스) | 1 (clbElecType) |
| WK-SCP0010-0035 | F2 | SCP0010 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0010 화면 | 판단불가(대상 단위 SCREEN) | 803 (`SaveButton`(Click) `btnFix`(`BtnFix_Cli) |
| WK-SCP0010-0036 | F6 | SCP0010 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0010 화면 | 판단불가(대상 단위 SCREEN) | 798 (`btnFix`(`BtnFix_Click`, 가드 CanUpdate/Is) |
| WK-SCP0010-0037 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0010_Shipment_Plan_SEMI.GetBucket) |
| WK-SCP0010-0038 | DB-SYN | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastRa) |
| WK-SCP0010-0039 | DB-SYN | SCP0010_GET_SHIPMENT_PLAN_SEMI | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0010_GET_SHIPMENT_PLAN_SEMI | 없음(PROC_M 대응 없음) | 6 (ACT:SCP0010_Shipment_Plan_SEMI.FindData_) |
| WK-SCP0010-0040 | DB-SYN | SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0041 | DB-SYN | SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_ | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET | 없음(PROC_M 대응 없음) | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0042 | DB-SYN | SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEKLY | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0043 | DB-SYN | SCP0011_GET_LAST_PLAN_VERSION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0011_GET_LAST_PLAN_VERSION | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastPl) |
| WK-SCP0010-0044 | DB-SYN | SCP0013_GET_PLAN_TYPE_SAVE_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0013_GET_PLAN_TYPE_SAVE_YN | 없음(PROC_M 대응 없음) | 5 (`btnFix`(`BtnFix_Click`, 가드 CanUpdate/Is) |
| WK-SCP0010-0045 | G4 | btnFix | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnFix | 있음(FE 소스) | 2 (ACT:SCP0010_Shipment_Plan_SEMI.InitEvent) |
| WK-SCP0010-0046 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 3 (Model(txtItemId+btnItem_Id) ACT:SCP0010_) |
| WK-SCP0010-0047 | G4 | btnNew | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnNew | 있음(FE 소스) | 2 (ACT:SCP0010_Shipment_Plan_SEMI.InitEvent) |
| WK-SCP0010-0048 | G4 | btnUnfix | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnUnfix | 있음(FE 소스) | 2 (ACT:SCP0010_Shipment_Plan_SEMI.InitEvent) |
| WK-SCP0010-0049 | G4 | btnW26 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnW26 | 없음 | 2 (ACT:SCP0010_Shipment_Plan_SEMI.InitEvent) |
| WK-SCP0010-0050 | G4 | btnW52 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnW52 | 없음 | 2 (ACT:SCP0010_Shipment_Plan_SEMI.InitEvent) |
| WK-SCP0010-0051 | G4 | btnWLast | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnWLast | 없음 | 4 (ACT:SCP0010_Shipment_Plan_SEMI.InitContr) |
| WK-SCP0010-0052 | G03-WIRE | SCP0010 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0010 화면 | 판단불가(대상 단위 SCREEN) | 36 (ACT:Calc_Measure..ctor ACT:Calc_Measure.) |
| WK-SCP0010-0053 | G5 | btnNew | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnNew | 있음(FE 소스) | 1 (`btnNew`(`SCM0002_ShipmentPlanInsertPopu) |
| WK-SCP0010-0054 | H6 | btnNew | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnNew | 있음(FE 소스) | 1 (`btnNew`(`SCM0002_ShipmentPlanInsertPopu) |

## W6 검증 실행 (100)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0010-0055 | J2 | SCP0010 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0010 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 116 (`FindButton`(Click) `SaveButton`(Click) ) |
| WK-SCP0010-0056 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.InitContr) |
| WK-SCP0010-0057 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.InitContr) |
| WK-SCP0010-0058 | C1 | cboOperGroup / Operation Group / Oper Gr | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboOperGroup / Operation Group / Oper Group / Oper · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.RefreshOp) |
| WK-SCP0010-0059 | C1 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.RefreshPl) |
| WK-SCP0010-0060 | C1 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.RefreshPl) |
| WK-SCP0010-0061 | C1 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.RefreshPl) |
| WK-SCP0010-0062 | C1 | clbElecType / Electrode / Elec Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.InitContr) |
| WK-SCP0010-0063 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.RefreshFr) |
| WK-SCP0010-0064 | C1 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.RefreshTo) |
| WK-SCP0010-0065 | G3 | SCP0010 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0010 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 1 (`pnlCondition`(HidePanel)) |
| WK-SCP0010-0066 | K-SA | SCP0010 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0010 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (`pnlCondition`(HidePanel)) |
| WK-SCP0010-0067 | K4 | SCP0010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0010 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 90 (ACT:SCP0010_Shipment_Plan_SEMI.BtnFix_Cl) |
| WK-SCP0010-0068 | F1 | SCP0010 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0010 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 805 (`SaveButton`(Click) `DeleteButton`(Click) |
| WK-SCP0010-0069 | F5 | SCP0010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0010 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 2 (`DeleteButton`(Click, `.cs` 본문 주석 1줄 NO-) |
| WK-SCP0010-0070 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.GetBucket) |
| WK-SCP0010-0071 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 3 (Period(dCalendar)+W26/W52/WLast ACT:SCP0) |
| WK-SCP0010-0072 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 873 (ACT:SCP0010_Shipment_Plan_SEMI.FindButto) |
| WK-SCP0010-0073 | F4 | SCM0001_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.GetDivisi) |
| WK-SCP0010-0074 | F4 | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_SCP_DAILY_PLAN_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastRa) |
| WK-SCP0010-0075 | F4 | SCP0010_GET_SHIPMENT_PLAN_SEMI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0010_GET_SHIPMENT_PLAN_SEMI · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 873 (ACT:SCP0010_Shipment_Plan_SEMI.FindButto) |
| WK-SCP0010-0076 | F4 | SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 585 (ACT:SCP0010_Shipment_Plan_SEMI.SaveButto) |
| WK-SCP0010-0077 | F4 | SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — |  | 211 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0078 | F4 | SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEKLY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 585 (ACT:SCP0010_Shipment_Plan_SEMI.SaveButto) |
| WK-SCP0010-0079 | F4 | SCP0011_GET_LAST_PLAN_VERSION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0011_GET_LAST_PLAN_VERSION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 3 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastPl) |
| WK-SCP0010-0080 | F4 | SCP0013_GET_PLAN_TYPE_SAVE_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0013_GET_PLAN_TYPE_SAVE_YN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 587 (`btnFix`(`BtnFix_Click`, 가드 CanUpdate/Is) |
| WK-SCP0010-0081 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0010_Shipment_Plan_SEMI.DefinePro) |
| WK-SCP0010-0082 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (cboDivision ACT:SCP0010_Shipment_Plan_SE) |
| WK-SCP0010-0083 | G4 | cboOperGroup / Operation Group / Oper Gr | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboOperGroup / Operation Group / Oper Group / Oper · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboOperGroup cboOperGroup 이중배선(From/To S) |
| WK-SCP0010-0084 | G4 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboPlanDate→Type→Seq ACT:SCP0010_Shipmen) |
| WK-SCP0010-0085 | G4 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0010_Shipment_Plan_SEMI.InitContr) |
| WK-SCP0010-0086 | G4 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0010_Shipment_Plan_SEMI.InitContr) |
| WK-SCP0010-0087 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.InitEvent) |
| WK-SCP0010-0088 | G4 | clbElecType / Electrode / Elec Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (clbElecType ACT:SCP0010_Shipment_Plan_SE) |
| WK-SCP0010-0089 | G4 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbFromSite / From Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (clbFromSite) |
| WK-SCP0010-0090 | G4 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbToSite / To Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (clbToSite) |
| WK-SCP0010-0091 | G4 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (Model(txtItemId+btnItem_Id)) |
| WK-SCP0010-0092 | H4 | SCP0010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0010 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 8 (ACT:SCP0010_Shipment_Plan_SEMI.SpdMain_T) |
| WK-SCP0010-0093 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 18 (ACT:SCP0010_Shipment_Plan_SEMI.SetSpread) |
| WK-SCP0010-0094 | H5 | cboOperGroup / Operation Group / Oper Gr | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboOperGroup / Operation Group / Oper Group / Oper · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_ |  | 1 (cboOperGroup 이중배선(From/To Site 재필터 + `_c) |
| WK-SCP0010-0095 | H5 | chkAll / lbchkAll / All | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkAll / lbchkAll / All · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (Bucket×chkSum visible 토글(§2.4, chkAll 예외) |
| WK-SCP0010-0096 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (Bucket×chkSum visible 토글(§2.4, chkAll 예외) |
| WK-SCP0010-0097 | I1 | SCP0010 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0010 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 34 (`btnUnfix`(Fix 와 동일 가드 + MSG00016 confir) |
| WK-SCP0010-0098 | SC1 | SCP0010 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0010 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 12 (cboDivision cboOperGroup clbFromSite clb) |
| WK-SCP0010-0099 | D6 | SCP0010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0010 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (Insert 시 확정 searchParams 기준 division 권한 ) |
| WK-SCP0010-0100 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (필수 검증(Division/OperationGroup MSG00002, ) |
| WK-SCP0010-0101 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0102 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0103 | E4 | MSG00010 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00010 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.BtnFix_Cl) |
| WK-SCP0010-0104 | E4 | MSG00016 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00016 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (`btnUnfix`(Fix 와 동일 가드 + MSG00016 confir) |
| WK-SCP0010-0105 | E4 | MSG00017 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00017 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.ValidateU) |
| WK-SCP0010-0106 | E4 | MSG00026 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00026 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0107 | E4 | MSG00046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0108 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (필수 검증(Division/OperationGroup MSG00002, ) |
| WK-SCP0010-0109 | E4 | MSG00059 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00059 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.ValidateU) |
| WK-SCP0010-0110 | E4 | MSG00084 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00084 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (저장 셀단위 검증(MSG00084/MSG00317) ACT:SCP0010) |
| WK-SCP0010-0111 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0010_Shipment_Plan_SEMI.BtnFix_Cl) |
| WK-SCP0010-0112 | E4 | MSG00134 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00134 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0113 | E4 | MSG00171 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00171 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.ValidateU) |
| WK-SCP0010-0114 | E4 | MSG00172 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00172 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.ValidateU) |
| WK-SCP0010-0115 | E4 | MSG00182 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00182 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.Get_IsSav) |
| WK-SCP0010-0116 | E4 | MSG00233 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00233 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.ValidateU) |
| WK-SCP0010-0117 | E4 | MSG00252 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00252 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0118 | E4 | MSG00265 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00265 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.BtnNew_Cl) |
| WK-SCP0010-0119 | E4 | MSG00317 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00317 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (저장 셀단위 검증(MSG00084/MSG00317) ACT:SCP0010) |
| WK-SCP0010-0120 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 18 (ACT:SCP0010_Shipment_Plan_SEMI.SetSpread) |
| WK-SCP0010-0121 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 14 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0122 | E4 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.SetChange) |
| WK-SCP0010-0123 | E4 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시 |  | 12 (ACT:SCP0010_Shipment_Plan_SEMI.Set_FixBu) |
| WK-SCP0010-0124 | E4 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.Set_FixBu) |
| WK-SCP0010-0125 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0010_Shipment_Plan_SEMI.SetSpread) |
| WK-SCP0010-0126 | E4 | clbElecType / Electrode / Elec Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 4 (ACT:SCP0010_Shipment_Plan_SEMI.SetChange) |
| WK-SCP0010-0127 | A10 | SCP0010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0010 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 178 (ACT:SCP0010_Shipment_Plan_SEMI.DefinePro) |
| WK-SCP0010-0128 | A6 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 1 (Period(dCalendar)+W26/W52/WLast) |
| WK-SCP0010-0129 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 77 (ACT:SCP0010_Shipment_Plan_SEMI.FindButto) |
| WK-SCP0010-0130 | A6 | SCP0010_GET_SHIPMENT_PLAN_SEMI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0010_GET_SHIPMENT_PLAN_SEMI · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.s |  | 79 (ACT:SCP0010_Shipment_Plan_SEMI.FindButto) |
| WK-SCP0010-0131 | A6 | SCP0013_GET_PLAN_TYPE_SAVE_YN | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0013_GET_PLAN_TYPE_SAVE_YN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.sp |  | 1 (`btnFix`(`BtnFix_Click`, 가드 CanUpdate/Is) |
| WK-SCP0010-0132 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboDivision ACT:SCP0010_Shipment_Plan_SE) |
| WK-SCP0010-0133 | G1 | cboOperGroup / Operation Group / Oper Gr | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboOperGroup / Operation Group / Oper Group / Oper · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (cboOperGroup cboOperGroup 이중배선(From/To S) |
| WK-SCP0010-0134 | G1 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboPlanDate→Type→Seq ACT:SCP0010_Shipmen) |
| WK-SCP0010-0135 | G1 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.FindData_) |
| WK-SCP0010-0136 | G1 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.FindData_) |
| WK-SCP0010-0137 | G1 | clbElecType / Electrode / Elec Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbElecType ACT:SCP0010_Shipment_Plan_SE) |
| WK-SCP0010-0138 | G1 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbFromSite ACT:SCP0010_Shipment_Plan_SE) |
| WK-SCP0010-0139 | G1 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbToSite / To Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbToSite ACT:SCP0010_Shipment_Plan_SEMI) |
| WK-SCP0010-0140 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (Model(txtItemId+btnItem_Id) ACT:SCP0010_) |
| WK-SCP0010-0141 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SCP0010_Shipment_Plan_SEMI.DefinePro) |
| WK-SCP0010-0142 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 8 (cboDivision ACT:SCP0010_Shipment_Plan_SE) |
| WK-SCP0010-0143 | G6 | cboOperGroup / Operation Group / Oper Gr | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboOperGroup / Operation Group / Oper Group / Oper · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboOperGroup cboOperGroup 이중배선(From/To S) |
| WK-SCP0010-0144 | G6 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboPlanDate→Type→Seq ACT:SCP0010_Shipmen) |
| WK-SCP0010-0145 | G6 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0010_Shipment_Plan_SEMI.InitContr) |
| WK-SCP0010-0146 | G6 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0010_Shipment_Plan_SEMI.InitContr) |
| WK-SCP0010-0147 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.InitEvent) |
| WK-SCP0010-0148 | G6 | clbElecType / Electrode / Elec Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (clbElecType ACT:SCP0010_Shipment_Plan_SE) |
| WK-SCP0010-0149 | G6 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (clbFromSite) |
| WK-SCP0010-0150 | G6 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (clbToSite) |
| WK-SCP0010-0151 | G6 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (Model(txtItemId+btnItem_Id)) |
| WK-SCP0010-0152 | X-REOPEN | SCP0010 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0010 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 15 (ACT:SCP0010_Shipment_Plan_SEMI.Dispose A) |
| WK-SCP0010-0153 | M3 | Calc_Measure | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — Calc_Measure · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 5 (ACT:Calc_Measure..ctor ACT:Calc_Measure.) |
| WK-SCP0010-0154 | M4 | btnNew | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnNew · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (`btnNew`(`SCM0002_ShipmentPlanInsertPopu) |

## W7 기대값 확정 (217)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0010-0155 | B3 | SCP0010_Shipment_Plan_SEMI.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetBucketType: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.GetBucket) |
| WK-SCP0010-0156 | B3 | SCP0010_Shipment_Plan_SEMI.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetDayRange: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0010_Shipment_Plan_SEMI.GetDayRan) |
| WK-SCP0010-0157 | B3 | SCP0010_Shipment_Plan_SEMI.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetDivision: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.GetDivisi) |
| WK-SCP0010-0158 | B3 | SCP0010_Shipment_Plan_SEMI.GetIsEditable | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetIsEditable: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 36 (ACT:SCP0010_Shipment_Plan_SEMI.GetIsEdit) |
| WK-SCP0010-0159 | B3 | SCP0010_Shipment_Plan_SEMI.GetLastPlanVe | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetLastPlanVersion: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastPl) |
| WK-SCP0010-0160 | B3 | SCP0010_Shipment_Plan_SEMI.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetLastRange: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastRa) |
| WK-SCP0010-0161 | B3 | SCP0010_Shipment_Plan_SEMI.GetNewInsertR | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetNewInsertRowIndex: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SCP0010_Shipment_Plan_SEMI.GetNewIns) |
| WK-SCP0010-0162 | B3 | SCP0010_Shipment_Plan_SEMI.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetSpdTitle: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0010_Shipment_Plan_SEMI.GetSpdTit) |
| WK-SCP0010-0163 | B3 | SCP0010_Shipment_Plan_SEMI.Get_IsSaveYn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Get_IsSaveYn: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0010_Shipment_Plan_SEMI.Get_IsSav) |
| WK-SCP0010-0164 | B3 | dead code 4건(SetChangedPeriod/GetLastPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — dead code 4건(SetChangedPeriod/GetLastPlanVersion/G: 행 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 1 (dead code 4건(SetChangedPeriod/GetLastPla) |
| WK-SCP0010-0165 | B3 | 콤보/Lookup 메타(2.76) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 콤보/Lookup 메타(2.76): 행 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 1 (콤보/Lookup 메타(2.76)) |
| WK-SCP0010-0166 | B4 | SCP0010_Shipment_Plan_SEMI.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetBucketType: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.GetBucket) |
| WK-SCP0010-0167 | B4 | SCP0010_Shipment_Plan_SEMI.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetDayRange: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0010_Shipment_Plan_SEMI.GetDayRan) |
| WK-SCP0010-0168 | B4 | SCP0010_Shipment_Plan_SEMI.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetDivision: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.GetDivisi) |
| WK-SCP0010-0169 | B4 | SCP0010_Shipment_Plan_SEMI.GetIsEditable | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetIsEditable: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 36 (ACT:SCP0010_Shipment_Plan_SEMI.GetIsEdit) |
| WK-SCP0010-0170 | B4 | SCP0010_Shipment_Plan_SEMI.GetLastPlanVe | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetLastPlanVersion: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastPl) |
| WK-SCP0010-0171 | B4 | SCP0010_Shipment_Plan_SEMI.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetLastRange: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastRa) |
| WK-SCP0010-0172 | B4 | SCP0010_Shipment_Plan_SEMI.GetNewInsertR | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetNewInsertRowIndex: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SCP0010_Shipment_Plan_SEMI.GetNewIns) |
| WK-SCP0010-0173 | B4 | SCP0010_Shipment_Plan_SEMI.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetSpdTitle: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0010_Shipment_Plan_SEMI.GetSpdTit) |
| WK-SCP0010-0174 | B4 | SCP0010_Shipment_Plan_SEMI.Get_IsSaveYn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Get_IsSaveYn: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0010_Shipment_Plan_SEMI.Get_IsSav) |
| WK-SCP0010-0175 | B4 | dead code 4건(SetChangedPeriod/GetLastPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — dead code 4건(SetChangedPeriod/GetLastPlanVersion/G: 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (dead code 4건(SetChangedPeriod/GetLastPla) |
| WK-SCP0010-0176 | B4 | 콤보/Lookup 메타(2.76) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 콤보/Lookup 메타(2.76): 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (콤보/Lookup 메타(2.76)) |
| WK-SCP0010-0177 | DB-SYN | SCP0010_Shipment_Plan_SEMI.SCM_SYS_LOG_B | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SCM_SYS_LOG_BATCH: 진입점 집계 — DB-SYN 11요소: NOPATH:8 · PASS:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.SCM_SYS_L) |
| WK-SCP0010-0178 | F4 | SCP0010_Shipment_Plan_SEMI.SCM_SYS_LOG_B | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SCM_SYS_LOG_BATCH: 진입점 집계 — F4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.SCM_SYS_L) |
| WK-SCP0010-0179 | G4 | Period(dCalendar)+W26/W52/WLast | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Period(dCalendar)+W26/W52/WLast: 행 집계 — G4 18요소: NOT_RUN:11 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (Period(dCalendar)+W26/W52/WLast) |
| WK-SCP0010-0180 | G4 | dead code 4건(SetChangedPeriod/GetLastPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — dead code 4건(SetChangedPeriod/GetLastPlanVersion/G: 행 집계 — G4 18요소: NOT_RUN:11 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (dead code 4건(SetChangedPeriod/GetLastPla) |
| WK-SCP0010-0181 | G4 | 조회조건 필수 alert | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 조회조건 필수 alert: 행 집계 — G4 18요소: NOT_RUN:11 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 필수 alert) |
| WK-SCP0010-0182 | G4 | 필수 검증(Division/OperationGroup MSG00002,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 필수 검증(Division/OperationGroup MSG00002, Period MSG: 행 집계 — G4 18요소: NOT_RUN:11 · NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (필수 검증(Division/OperationGroup MSG00002, ) |
| WK-SCP0010-0183 | H5 | 3-span 헤더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 3-span 헤더: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (3-span 헤더) |
| WK-SCP0010-0184 | H5 | BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래)) |
| WK-SCP0010-0185 | H5 | EE 조건부 표시 3건(R-A) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — EE 조건부 표시 3건(R-A): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (EE 조건부 표시 3건(R-A)) |
| WK-SCP0010-0186 | H5 | Fix 하이라이트(O_RC3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Fix 하이라이트(O_RC3): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Fix 하이라이트(O_RC3)) |
| WK-SCP0010-0187 | H5 | Freeze(`FrozenColumnCount` 상당) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Freeze(`FrozenColumnCount` 상당): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Freeze(`FrozenColumnCount` 상당)) |
| WK-SCP0010-0188 | H5 | INVENTORY W_/M_ 후처리(마지막 D_ 값) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — INVENTORY W_/M_ 후처리(마지막 D_ 값): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (INVENTORY W_/M_ 후처리(마지막 D_ 값)) |
| WK-SCP0010-0189 | H5 | Lock 계열(SwitchLock 1/LockColumn 2/LockRa | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Lock 계열(SwitchLock 1/LockColumn 2/LockRange 22/Loc: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Lock 계열(SwitchLock 1/LockColumn 2/LockRa) |
| WK-SCP0010-0190 | H5 | Measure 세트(CELL/ELECTRODE, OperationGrou | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Measure 세트(CELL/ELECTRODE, OperationGroup 기준): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Measure 세트(CELL/ELECTRODE, OperationGrou) |
| WK-SCP0010-0191 | H5 | SCP0010_Shipment_Plan_SEMI.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0010_Shipment_Plan_SEMI.CreateSpread: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0010_Shipment_Plan_SEMI.CreateSpr) |
| WK-SCP0010-0192 | H5 | SCP0010_Shipment_Plan_SEMI.SetSpreadColu | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SetSpreadColumn: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.SetSpread) |
| WK-SCP0010-0193 | H5 | Weekly Dept Day 자동분배(R-DeptDist) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Weekly Dept Day 자동분배(R-DeptDist): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Weekly Dept Day 자동분배(R-DeptDist)) |
| WK-SCP0010-0194 | H5 | `EditButton`(잠금토글, buttonGuards #2/#3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `EditButton`(잠금토글, buttonGuards #2/#3): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`EditButton`(잠금토글, buttonGuards #2/#3)) |
| WK-SCP0010-0195 | H5 | `SHIP_PLAN_AMEND` 편집가능 판정(BlockCellsChec | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `SHIP_PLAN_AMEND` 편집가능 판정(BlockCellsChecking/_2): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`SHIP_PLAN_AMEND` 편집가능 판정(BlockCellsChec) |
| WK-SCP0010-0196 | H5 | 동적 D_/W_/M_ pivot(calendar SP, Bucket 무관 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 동적 D_/W_/M_ pivot(calendar SP, Bucket 무관 항상 전체): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (동적 D_/W_/M_ pivot(calendar SP, Bucket 무관) |
| WK-SCP0010-0197 | H5 | 셀 병합(SmartColMerge 5건, `.cs:389,466,1105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 셀 병합(SmartColMerge 5건, `.cs:389,466,1105,4456,4718: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합(SmartColMerge 5건, `.cs:389,466,1105) |
| WK-SCP0010-0198 | H5 | 인접 정보컬럼 세로 병합(R-I, Freeze=measure_label) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 인접 정보컬럼 세로 병합(R-I, Freeze=measure_label): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (인접 정보컬럼 세로 병합(R-I, Freeze=measure_label)) |
| WK-SCP0010-0199 | H5 | 저장 셀단위 검증(MSG00084/MSG00317) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 저장 셀단위 검증(MSG00084/MSG00317): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (저장 셀단위 검증(MSG00084/MSG00317)) |
| WK-SCP0010-0200 | H5 | 정보컬럼 27개(admin `SCM_MST_SHEET_COLUMNS` 등 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 정보컬럼 27개(admin `SCM_MST_SHEET_COLUMNS` 등록 확인): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (정보컬럼 27개(admin `SCM_MST_SHEET_COLUMNS` 등) |
| WK-SCP0010-0201 | H5 | 정보컬럼 전건 잠금(R-J) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 정보컬럼 전건 잠금(R-J): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (정보컬럼 전건 잠금(R-J)) |
| WK-SCP0010-0202 | X-REASON | 셀 타입 콤보(`SetCellTypeCombo`) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 셀 타입 콤보(`SetCellTypeCombo`) 해당없음 design/03 §0 DB 실측 — 이 화면 그리드 콤보/팝업 셀 0건 확정(정보컬럼 전건 read-only, pivot 은 숫자입력) |  | 1 (셀 타입 콤보(`SetCellTypeCombo`)) |
| WK-SCP0010-0203 | E4 | C/U/D/R 독립 확인 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — C/U/D/R 독립 확인: 행 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (C/U/D/R 독립 확인) |
| WK-SCP0010-0204 | E4 | SCP0010_Shipment_Plan_SEMI.SetChangedPer | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SetChangedPeriod: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0010_Shipment_Plan_SEMI.SetChange) |
| WK-SCP0010-0205 | E4 | SCP0010_Shipment_Plan_SEMI.SetFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SetFromSite: 진입점 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SetFromSi) |
| WK-SCP0010-0206 | E4 | SCP0010_Shipment_Plan_SEMI.SetSpreadColu | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SetSpreadColumn: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.SetSpread) |
| WK-SCP0010-0207 | E4 | SCP0010_Shipment_Plan_SEMI.SetTableInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SetTableInfo: 진입점 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0010_Shipment_Plan_SEMI.SetTableI) |
| WK-SCP0010-0208 | E4 | SCP0010_Shipment_Plan_SEMI.SetToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SetToSite: 진입점 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SetToSite) |
| WK-SCP0010-0209 | E4 | SCP0010_Shipment_Plan_SEMI.Set_FPOperati | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Set_FPOperationColor: 진입점 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 14 (ACT:SCP0010_Shipment_Plan_SEMI.Set_FPOpe) |
| WK-SCP0010-0210 | E4 | SCP0010_Shipment_Plan_SEMI.Set_FixButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Set_FixButtonEnabled: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0010_Shipment_Plan_SEMI.Set_FixBu) |
| WK-SCP0010-0211 | E4 | SCP0010_Shipment_Plan_SEMI.Set_FixCellCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Set_FixCellColor: 진입점 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SCP0010_Shipment_Plan_SEMI.Set_FixCe) |
| WK-SCP0010-0212 | E4 | SCP0010_Shipment_Plan_SEMI.Set_InsertCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Set_InsertColumnsFont: 진입점 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0010_Shipment_Plan_SEMI.Set_Inser) |
| WK-SCP0010-0213 | E4 | SCP0010_Shipment_Plan_SEMI.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Set_SumValues: 진입점 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 20 (ACT:SCP0010_Shipment_Plan_SEMI.Set_SumVa) |
| WK-SCP0010-0214 | E4 | `btnFix`(`BtnFix_Click`, 가드 CanUpdate/Is | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `btnFix`(`BtnFix_Click`, 가드 CanUpdate/IsLock/`Get_: 행 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (`btnFix`(`BtnFix_Click`, 가드 CanUpdate/Is) |
| WK-SCP0010-0215 | E4 | dead code 4건(SetChangedPeriod/GetLastPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — dead code 4건(SetChangedPeriod/GetLastPlanVersion/G: 행 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (dead code 4건(SetChangedPeriod/GetLastPla) |
| WK-SCP0010-0216 | E4 | 조회조건 필수 alert | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 조회조건 필수 alert: 행 집계 — E4 27요소: NOT_RUN:27 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 필수 alert) |
| WK-SCP0010-0217 | A1 | Model(txtItemId+btnItem_Id) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Model(txtItemId+btnItem_Id): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Model(txtItemId+btnItem_Id)) |
| WK-SCP0010-0218 | A1 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD: 골든 비교 케이스 없음(PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD — 팝업·보조 SP 는 golden_ca |  | 1 (Period(dCalendar)+W26/W52/WLast) |
| WK-SCP0010-0219 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 77 (ACT:SCP0010_Shipment_Plan_SEMI.FindButto) |
| WK-SCP0010-0220 | A1 | SCP0010_GET_SHIPMENT_PLAN_SEMI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0010_GET_SHIPMENT_PLAN_SEMI: 골든 비교 케이스 없음(SCP0010_GET_SHIPMENT_PLAN_SEMI — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미 |  | 79 (ACT:SCP0010_Shipment_Plan_SEMI.FindButto) |
| WK-SCP0010-0221 | A1 | SCP0013_GET_PLAN_TYPE_SAVE_YN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0013_GET_PLAN_TYPE_SAVE_YN: 골든 비교 케이스 없음(SCP0013_GET_PLAN_TYPE_SAVE_YN — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 |  | 1 (`btnFix`(`BtnFix_Click`, 가드 CanUpdate/Is) |
| WK-SCP0010-0222 | A1 | `FindButton`(Click) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `FindButton`(Click): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (`FindButton`(Click)) |
| WK-SCP0010-0223 | A1 | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (cboDivision) |
| WK-SCP0010-0224 | A1 | cboOperGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboOperGroup: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (cboOperGroup) |
| WK-SCP0010-0225 | A1 | cboOperGroup 이중배선(From/To Site 재필터 + `_c | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboOperGroup 이중배선(From/To Site 재필터 + `_curSheetNam: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (cboOperGroup 이중배선(From/To Site 재필터 + `_c) |
| WK-SCP0010-0226 | A1 | cboPlanDate→Type→Seq | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboPlanDate→Type→Seq: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (cboPlanDate→Type→Seq) |
| WK-SCP0010-0227 | A1 | clbElecType | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbElecType: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (clbElecType) |
| WK-SCP0010-0228 | A1 | clbFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbFromSite: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (clbFromSite) |
| WK-SCP0010-0229 | A1 | clbToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbToSite: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (clbToSite) |
| WK-SCP0010-0230 | A1 | dead code 4건(SetChangedPeriod/GetLastPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — dead code 4건(SetChangedPeriod/GetLastPlanVersion/G: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (dead code 4건(SetChangedPeriod/GetLastPla) |
| WK-SCP0010-0231 | A1 | 권한 입력(2.8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 권한 입력(2.8): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (권한 입력(2.8)) |
| WK-SCP0010-0232 | A1 | 메뉴 등록(2.7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 메뉴 등록(2.7): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (메뉴 등록(2.7)) |
| WK-SCP0010-0233 | A1 | 조회조건 필수 alert | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회조건 필수 alert: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (조회조건 필수 alert) |
| WK-SCP0010-0234 | A1 | 필수 검증(Division/OperationGroup MSG00002,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 필수 검증(Division/OperationGroup MSG00002, Period MSG: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (필수 검증(Division/OperationGroup MSG00002, ) |
| WK-SCP0010-0235 | A1 | 필요 영역만 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 필요 영역만 재조회: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (필요 영역만 재조회) |
| WK-SCP0010-0236 | G1 | Period(dCalendar)+W26/W52/WLast | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Period(dCalendar)+W26/W52/WLast: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (Period(dCalendar)+W26/W52/WLast) |
| WK-SCP0010-0237 | G1 | `FindButton`(Click) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `FindButton`(Click): 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (`FindButton`(Click)) |
| WK-SCP0010-0238 | G1 | dead code 4건(SetChangedPeriod/GetLastPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — dead code 4건(SetChangedPeriod/GetLastPlanVersion/G: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (dead code 4건(SetChangedPeriod/GetLastPla) |
| WK-SCP0010-0239 | G1 | 권한 입력(2.8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 권한 입력(2.8): 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (권한 입력(2.8)) |
| WK-SCP0010-0240 | G1 | 메뉴 등록(2.7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 메뉴 등록(2.7): 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (메뉴 등록(2.7)) |
| WK-SCP0010-0241 | G1 | 조회조건 필수 alert | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회조건 필수 alert: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 필수 alert) |
| WK-SCP0010-0242 | G1 | 필수 검증(Division/OperationGroup MSG00002,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 필수 검증(Division/OperationGroup MSG00002, Period MSG: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (필수 검증(Division/OperationGroup MSG00002, ) |
| WK-SCP0010-0243 | G1 | 필요 영역만 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 필요 영역만 재조회: 행 집계 — G1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (필요 영역만 재조회) |
| WK-SCP0010-0244 | G6 | Period(dCalendar)+W26/W52/WLast | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Period(dCalendar)+W26/W52/WLast: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (Period(dCalendar)+W26/W52/WLast) |
| WK-SCP0010-0245 | G6 | dead code 4건(SetChangedPeriod/GetLastPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — dead code 4건(SetChangedPeriod/GetLastPlanVersion/G: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (dead code 4건(SetChangedPeriod/GetLastPla) |
| WK-SCP0010-0246 | G6 | 조회조건 필수 alert | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 조회조건 필수 alert: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 필수 alert) |
| WK-SCP0010-0247 | G6 | 필수 검증(Division/OperationGroup MSG00002,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 필수 검증(Division/OperationGroup MSG00002, Period MSG: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (필수 검증(Division/OperationGroup MSG00002, ) |
| WK-SCP0010-0248 | X-LOC | 2줄+ 접기/펼치기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2줄+ 접기/펼치기: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2줄+ 접기/펼치기) |
| WK-SCP0010-0249 | X-LOC | C/U/D/R 독립 확인 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — C/U/D/R 독립 확인: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (C/U/D/R 독립 확인) |
| WK-SCP0010-0250 | X-LOC | CODE 아닌 NAME 표시 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CODE 아닌 NAME 표시: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CODE 아닌 NAME 표시) |
| WK-SCP0010-0251 | X-LOC | Insert 시 확정 searchParams 기준 division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Insert 시 확정 searchParams 기준 division: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Insert 시 확정 searchParams 기준 division) |
| WK-SCP0010-0252 | X-LOC | Lock 계열(SwitchLock 1/LockColumn 2/LockRa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Lock 계열(SwitchLock 1/LockColumn 2/LockRange 22/Loc: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Lock 계열(SwitchLock 1/LockColumn 2/LockRa) |
| WK-SCP0010-0253 | X-LOC | Model(txtItemId+btnItem_Id) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Model(txtItemId+btnItem_Id): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Model(txtItemId+btnItem_Id)) |
| WK-SCP0010-0254 | X-LOC | Period(dCalendar)+W26/W52/WLast | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Period(dCalendar)+W26/W52/WLast: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Period(dCalendar)+W26/W52/WLast) |
| WK-SCP0010-0255 | X-LOC | SP 실행체인(2.9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SP 실행체인(2.9): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SP 실행체인(2.9)) |
| WK-SCP0010-0256 | X-LOC | SubTitle 공용 아이콘 순서 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SubTitle 공용 아이콘 순서: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SubTitle 공용 아이콘 순서) |
| WK-SCP0010-0257 | X-LOC | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboDivision) |
| WK-SCP0010-0258 | X-LOC | cboOperGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboOperGroup: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboOperGroup) |
| WK-SCP0010-0259 | X-LOC | cboOperGroup 이중배선(From/To Site 재필터 + `_c | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboOperGroup 이중배선(From/To Site 재필터 + `_curSheetNam: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboOperGroup 이중배선(From/To Site 재필터 + `_c) |
| WK-SCP0010-0260 | X-LOC | cboPlanDate→Type→Seq | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboPlanDate→Type→Seq: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboPlanDate→Type→Seq) |
| WK-SCP0010-0261 | X-LOC | clbElecType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbElecType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbElecType) |
| WK-SCP0010-0262 | X-LOC | clbFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbFromSite: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbFromSite) |
| WK-SCP0010-0263 | X-LOC | clbToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbToSite: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbToSite) |
| WK-SCP0010-0264 | X-LOC | dead code 4건(SetChangedPeriod/GetLastPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — dead code 4건(SetChangedPeriod/GetLastPlanVersion/G: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (dead code 4건(SetChangedPeriod/GetLastPla) |
| WK-SCP0010-0265 | X-LOC | grep 10종(상대경로/console/inline style/any/d | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — grep 10종(상대경로/console/inline style/any/direct cast: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (grep 10종(상대경로/console/inline style/any/d) |
| WK-SCP0010-0266 | X-LOC | hotkeyConfig NO-OP 배선(DeleteButton) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — hotkeyConfig NO-OP 배선(DeleteButton): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (hotkeyConfig NO-OP 배선(DeleteButton)) |
| WK-SCP0010-0267 | X-LOC | 권한 입력(2.8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 권한 입력(2.8): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (권한 입력(2.8)) |
| WK-SCP0010-0268 | X-LOC | 단축키 동작 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 단축키 동작: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (단축키 동작) |
| WK-SCP0010-0269 | X-LOC | 셀 병합 AS-IS 동일 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 셀 병합 AS-IS 동일: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (셀 병합 AS-IS 동일) |
| WK-SCP0010-0270 | X-LOC | 셀 병합(SmartColMerge 5건, `.cs:389,466,1105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 셀 병합(SmartColMerge 5건, `.cs:389,466,1105,4456,4718: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (셀 병합(SmartColMerge 5건, `.cs:389,466,1105) |
| WK-SCP0010-0271 | X-LOC | 조회조건 필수 alert | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회조건 필수 alert: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (조회조건 필수 alert) |
| WK-SCP0010-0272 | X-LOC | 컬럼/Measure 메타(2.75) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 컬럼/Measure 메타(2.75): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (컬럼/Measure 메타(2.75)) |
| WK-SCP0010-0273 | X-LOC | 콤보/Lookup 메타(2.76) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 콤보/Lookup 메타(2.76): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (콤보/Lookup 메타(2.76)) |
| WK-SCP0010-0274 | X-LOC | 필요 영역만 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 필요 영역만 재조회: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (필요 영역만 재조회) |
| WK-SCP0010-0275 | X-ROW | 2줄+ 접기/펼치기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 2줄+ 접기/펼치기: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (2줄+ 접기/펼치기) |
| WK-SCP0010-0276 | X-ROW | CODE 아닌 NAME 표시 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CODE 아닌 NAME 표시: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CODE 아닌 NAME 표시) |
| WK-SCP0010-0277 | X-ROW | Calc_Measure..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Calc_Measure..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:Calc_Measure..ctor:5030:1 ACT:Calc_M) |
| WK-SCP0010-0278 | X-ROW | Calc_Measure.RetDoubleValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Calc_Measure.RetDoubleValue: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:Calc_Measure.RetDoubleValue ACT:Calc) |
| WK-SCP0010-0279 | X-ROW | Calc_Measure.RetIntValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Calc_Measure.RetIntValue: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:Calc_Measure.RetIntValue ACT:Calc_Me) |
| WK-SCP0010-0280 | X-ROW | Calc_Measure.RetLongValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Calc_Measure.RetLongValue: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:Calc_Measure.RetLongValue ACT:Calc_M) |
| WK-SCP0010-0281 | X-ROW | Calc_Measure.SetCalcMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Calc_Measure.SetCalcMeasure: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 84 (ACT:Calc_Measure.SetCalcMeasure ACT:Calc) |
| WK-SCP0010-0282 | X-ROW | Cascade 콤보 filter 정확 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Cascade 콤보 filter 정확: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Cascade 콤보 filter 정확) |
| WK-SCP0010-0283 | X-ROW | SCP0010_Shipment_Plan_SEMI.BlockCellsChe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.BlockCellsChecking: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/FLOW/GRID_LOCK/ |  | 81 (ACT:SCP0010_Shipment_Plan_SEMI.BlockCell) |
| WK-SCP0010-0284 | X-ROW | SCP0010_Shipment_Plan_SEMI.BlockCellsChe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.BlockCellsChecking_2: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/FLOW/ |  | 91 (ACT:SCP0010_Shipment_Plan_SEMI.BlockCell) |
| WK-SCP0010-0285 | X-ROW | SCP0010_Shipment_Plan_SEMI.BtnItem_Id_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.BtnItem_Id_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0010_Shipment_Plan_SEMI.BtnItem_I) |
| WK-SCP0010-0286 | X-ROW | SCP0010_Shipment_Plan_SEMI.BtnNew_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.BtnNew_Click: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0010_Shipment_Plan_SEMI.BtnNew_Cl) |
| WK-SCP0010-0287 | X-ROW | SCP0010_Shipment_Plan_SEMI.BtnW26_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.BtnW26_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 0 () |
| WK-SCP0010-0288 | X-ROW | SCP0010_Shipment_Plan_SEMI.BtnW52_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.BtnW52_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 0 () |
| WK-SCP0010-0289 | X-ROW | SCP0010_Shipment_Plan_SEMI.BtnWLast_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.BtnWLast_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 0 () |
| WK-SCP0010-0290 | X-ROW | SCP0010_Shipment_Plan_SEMI.CalculateSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.CalculateSum: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/LOCAL, 연결된 요소 검사  |  | 47 (ACT:SCP0010_Shipment_Plan_SEMI.Calculate) |
| WK-SCP0010-0291 | X-ROW | SCP0010_Shipment_Plan_SEMI.CboBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.CboBucketType_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.CboBucket) |
| WK-SCP0010-0292 | X-ROW | SCP0010_Shipment_Plan_SEMI.CboDivision_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.CboDivision_SelectedInd: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.CboDivisi) |
| WK-SCP0010-0293 | X-ROW | SCP0010_Shipment_Plan_SEMI.CboOperGroup_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.CboOperGroup_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.CboOperGr) |
| WK-SCP0010-0294 | X-ROW | SCP0010_Shipment_Plan_SEMI.CboPlanDate_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.CboPlanDate_SelectedInd: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.CboPlanDa) |
| WK-SCP0010-0295 | X-ROW | SCP0010_Shipment_Plan_SEMI.CboPlanSeq_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.CboPlanSeq_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.CboPlanSe) |
| WK-SCP0010-0296 | X-ROW | SCP0010_Shipment_Plan_SEMI.CboPlanType_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.CboPlanType_SelectedInd: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.CboPlanTy) |
| WK-SCP0010-0297 | X-ROW | SCP0010_Shipment_Plan_SEMI.ChkSum_Checke | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.ChkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.ChkSum_Ch) |
| WK-SCP0010-0298 | X-ROW | SCP0010_Shipment_Plan_SEMI.CreateBinding | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.CreateBindingDataSet: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/DATA_OP/ENTRY/LOCAL/RE |  | 10 (ACT:SCP0010_Shipment_Plan_SEMI.CreateBin) |
| WK-SCP0010-0299 | X-ROW | SCP0010_Shipment_Plan_SEMI.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.CreateSpr) |
| WK-SCP0010-0300 | X-ROW | SCP0010_Shipment_Plan_SEMI.DefinePropert | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.DefinePro) |
| WK-SCP0010-0301 | X-ROW | SCP0010_Shipment_Plan_SEMI.EditBlockChec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.EditBlockChecking: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/LOCAL/RETURN |  | 23 (ACT:SCP0010_Shipment_Plan_SEMI.EditBlock) |
| WK-SCP0010-0302 | X-ROW | SCP0010_Shipment_Plan_SEMI.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.EditButto) |
| WK-SCP0010-0303 | X-ROW | SCP0010_Shipment_Plan_SEMI.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP,  |  | 15 (ACT:SCP0010_Shipment_Plan_SEMI.ExcelButt) |
| WK-SCP0010-0304 | X-ROW | SCP0010_Shipment_Plan_SEMI.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.FindButto) |
| WK-SCP0010-0305 | X-ROW | SCP0010_Shipment_Plan_SEMI.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.FindData_Main: 진입점 집계 19검사 — NOT_RUN:15 · REVIEW:2 · PASS:1 · NOPATH:1 |  | 11 (ACT:SCP0010_Shipment_Plan_SEMI.FindData_) |
| WK-SCP0010-0306 | X-ROW | SCP0010_Shipment_Plan_SEMI.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.Form_Load) |
| WK-SCP0010-0307 | X-ROW | SCP0010_Shipment_Plan_SEMI.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetBucketType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.GetBucket) |
| WK-SCP0010-0308 | X-ROW | SCP0010_Shipment_Plan_SEMI.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.GetDivisi) |
| WK-SCP0010-0309 | X-ROW | SCP0010_Shipment_Plan_SEMI.GetIsEditable | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetIsEditable: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.GetIsEdit) |
| WK-SCP0010-0310 | X-ROW | SCP0010_Shipment_Plan_SEMI.GetLastPlanVe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetLastPlanVersion: 진입점 집계 14검사 — NOPATH:6 · TODO:4 · REVIEW:2 · NOT_RUN:2 |  | 4 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastPl) |
| WK-SCP0010-0311 | X-ROW | SCP0010_Shipment_Plan_SEMI.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetLastRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.GetLastRa) |
| WK-SCP0010-0312 | X-ROW | SCP0010_Shipment_Plan_SEMI.GetNewInsertR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetNewInsertRowIndex: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.GetNewIns) |
| WK-SCP0010-0313 | X-ROW | SCP0010_Shipment_Plan_SEMI.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.GetSpdTit) |
| WK-SCP0010-0314 | X-ROW | SCP0010_Shipment_Plan_SEMI.Get_IsSaveYn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Get_IsSaveYn: 진입점 집계 13검사 — NOT_RUN:4 · NOPATH:4 · TODO:3 · REVIEW:2 |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.Get_IsSav) |
| WK-SCP0010-0315 | X-ROW | SCP0010_Shipment_Plan_SEMI.HandleBinding | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.HandleBindingDataSet: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/LOCAL |  | 74 (ACT:SCP0010_Shipment_Plan_SEMI.HandleBin) |
| WK-SCP0010-0316 | X-ROW | SCP0010_Shipment_Plan_SEMI.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.InitControls: 진입점 집계 17검사 — NOT_RUN:16 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0010_Shipment_Plan_SEMI.InitContr) |
| WK-SCP0010-0317 | X-ROW | SCP0010_Shipment_Plan_SEMI.InitDictionar | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.InitDictionary: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.InitDicti) |
| WK-SCP0010-0318 | X-ROW | SCP0010_Shipment_Plan_SEMI.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.InitSprea) |
| WK-SCP0010-0319 | X-ROW | SCP0010_Shipment_Plan_SEMI.InitSpreadDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0010_Shipment_Plan_SEMI.InitSprea) |
| WK-SCP0010-0320 | X-ROW | SCP0010_Shipment_Plan_SEMI.InitSpread_2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.InitSpread_2: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0010_Shipment_Plan_SEMI.InitSprea) |
| WK-SCP0010-0321 | X-ROW | SCP0010_Shipment_Plan_SEMI.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/CALL_LOCAL/DATA_OP/ENTRY/EXPR/GRID_ |  | 117 (ACT:SCP0010_Shipment_Plan_SEMI.InsertRow) |
| WK-SCP0010-0322 | X-ROW | SCP0010_Shipment_Plan_SEMI.RefreshFromSi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.RefreshFromSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0010_Shipment_Plan_SEMI.RefreshFr) |
| WK-SCP0010-0323 | X-ROW | SCP0010_Shipment_Plan_SEMI.RefreshOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.RefreshOperationGroup: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0010_Shipment_Plan_SEMI.RefreshOp) |
| WK-SCP0010-0324 | X-ROW | SCP0010_Shipment_Plan_SEMI.RefreshPlanDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.RefreshPlanDate: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0010_Shipment_Plan_SEMI.RefreshPl) |
| WK-SCP0010-0325 | X-ROW | SCP0010_Shipment_Plan_SEMI.RefreshPlanSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.RefreshPlanSeq: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0010_Shipment_Plan_SEMI.RefreshPl) |
| WK-SCP0010-0326 | X-ROW | SCP0010_Shipment_Plan_SEMI.RefreshPlanTy | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.RefreshPlanType: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0010_Shipment_Plan_SEMI.RefreshPl) |
| WK-SCP0010-0327 | X-ROW | SCP0010_Shipment_Plan_SEMI.RefreshToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.RefreshToSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0010_Shipment_Plan_SEMI.RefreshTo) |
| WK-SCP0010-0328 | X-ROW | SCP0010_Shipment_Plan_SEMI.RetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.RetValue: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0010_Shipment_Plan_SEMI.RetValue ) |
| WK-SCP0010-0329 | X-ROW | SCP0010_Shipment_Plan_SEMI.SCM_SYS_LOG_B | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SCM_SYS_LOG_BATCH: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0010_Shipment_Plan_SEMI.SCM_SYS_L) |
| WK-SCP0010-0330 | X-ROW | SCP0010_Shipment_Plan_SEMI.SaveData_FixI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SaveData_FixInfo: 진입점 집계 17검사 — NOT_RUN:12 · NOPATH:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0331 | X-ROW | SCP0010_Shipment_Plan_SEMI.SaveData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SaveData_Main: 진입점 집계 20검사 — NOT_RUN:13 · NOPATH:6 · PASS:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0010_Shipment_Plan_SEMI.SaveData_) |
| WK-SCP0010-0332 | X-ROW | SCP0010_Shipment_Plan_SEMI.SetChangedCon | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SetChange) |
| WK-SCP0010-0333 | X-ROW | SCP0010_Shipment_Plan_SEMI.SetChangedPer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SetChangedPeriod: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0010_Shipment_Plan_SEMI.SetChange) |
| WK-SCP0010-0334 | X-ROW | SCP0010_Shipment_Plan_SEMI.SetFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SetFromSite: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SetFromSi) |
| WK-SCP0010-0335 | X-ROW | SCP0010_Shipment_Plan_SEMI.SetSpreadColu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SetSpreadColumn: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0010_Shipment_Plan_SEMI.SetSpread) |
| WK-SCP0010-0336 | X-ROW | SCP0010_Shipment_Plan_SEMI.SetTableInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SetTableInfo: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SetTableI) |
| WK-SCP0010-0337 | X-ROW | SCP0010_Shipment_Plan_SEMI.SetToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SetToSite: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SetToSite) |
| WK-SCP0010-0338 | X-ROW | SCP0010_Shipment_Plan_SEMI.Set_FPOperati | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Set_FPOperationColor: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.Set_FPOpe) |
| WK-SCP0010-0339 | X-ROW | SCP0010_Shipment_Plan_SEMI.Set_FixButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Set_FixButtonEnabled: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.Set_FixBu) |
| WK-SCP0010-0340 | X-ROW | SCP0010_Shipment_Plan_SEMI.Set_FixCellCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Set_FixCellColor: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.Set_FixCe) |
| WK-SCP0010-0341 | X-ROW | SCP0010_Shipment_Plan_SEMI.Set_InsertCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Set_InsertColumnsFont: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0010_Shipment_Plan_SEMI.Set_Inser) |
| WK-SCP0010-0342 | X-ROW | SCP0010_Shipment_Plan_SEMI.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.Set_SumValues: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0010_Shipment_Plan_SEMI.Set_SumVa) |
| WK-SCP0010-0343 | X-ROW | SCP0010_Shipment_Plan_SEMI.SpdMain_CellD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SpdMain_C) |
| WK-SCP0010-0344 | X-ROW | SCP0010_Shipment_Plan_SEMI.SpdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SpdMain_KeyUp: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0010_Shipment_Plan_SEMI.SpdMain_K) |
| WK-SCP0010-0345 | X-ROW | SCP0010_Shipment_Plan_SEMI.SpdMain_TopCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.SpdMain_T) |
| WK-SCP0010-0346 | X-ROW | SCP0010_Shipment_Plan_SEMI.SubSumMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SubSumMerge: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/LOCAL/STATE_RE |  | 36 (ACT:SCP0010_Shipment_Plan_SEMI.SubSumMer) |
| WK-SCP0010-0347 | X-ROW | SCP0010_Shipment_Plan_SEMI.TotalCellsMer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.TotalCellsMerge: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/LOCAL/UI_PROP, 연결된  |  | 49 (ACT:SCP0010_Shipment_Plan_SEMI.TotalCell) |
| WK-SCP0010-0348 | X-ROW | SCP0010_Shipment_Plan_SEMI.ValidateUserI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.ValidateUserInput: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 30 (ACT:SCP0010_Shipment_Plan_SEMI.ValidateU) |
| WK-SCP0010-0349 | X-ROW | SCP0010_Shipment_Plan_SEMI.btnMeasure_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.btnMeasure_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0010_Shipment_Plan_SEMI.btnMeasur) |
| WK-SCP0010-0350 | X-ROW | SCP0010_Shipment_Plan_SEMI.cboOperGrp_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.cboOperGrp_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.cboOperGr) |
| WK-SCP0010-0351 | X-ROW | SCP0010_Shipment_Plan_SEMI.chkSum_Checke | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.chkSum_Ch) |
| WK-SCP0010-0352 | X-ROW | SCP0010_Shipment_Plan_SEMI.spdMain_CellC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.spdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 9 (ACT:SCP0010_Shipment_Plan_SEMI.spdMain_C) |
| WK-SCP0010-0353 | X-ROW | SCP0010_Shipment_Plan_SEMI.spdMain_Chang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.spdMain_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0010_Shipment_Plan_SEMI.spdMain_C) |
| WK-SCP0010-0354 | X-ROW | SCP0010_Shipment_Plan_SEMI.spdMain_TopCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0010_Shipment_Plan_SEMI.spdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0010_Shipment_Plan_SEMI.spdMain_T) |
| WK-SCP0010-0355 | X-ROW | SubTitle 공용 아이콘 순서 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SubTitle 공용 아이콘 순서: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SubTitle 공용 아이콘 순서) |
| WK-SCP0010-0356 | X-ROW | `ExcelButton` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `ExcelButton`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`ExcelButton`) |
| WK-SCP0010-0357 | X-ROW | btnFix/Unfix/New 공통 disabled(`Set_FixBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — btnFix/Unfix/New 공통 disabled(`Set_FixButtonEnabled: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (btnFix/Unfix/New 공통 disabled(`Set_FixBut) |
| WK-SCP0010-0358 | X-ROW | grep 10종(상대경로/console/inline style/any/d | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — grep 10종(상대경로/console/inline style/any/direct cast: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (grep 10종(상대경로/console/inline style/any/d) |
| WK-SCP0010-0359 | X-ROW | lint(`pnpm --dir nscm-fe/features/supply | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — lint(`pnpm --dir nscm-fe/features/supply lint:fix`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (lint(`pnpm --dir nscm-fe/features/supply) |
| WK-SCP0010-0360 | X-ROW | type-check(`pnpm --dir nscm-fe/features/ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — type-check(`pnpm --dir nscm-fe/features/supply typ: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (type-check(`pnpm --dir nscm-fe/features/) |
| WK-SCP0010-0361 | X-ROW | 단축키 동작 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 단축키 동작: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (단축키 동작) |
| WK-SCP0010-0362 | X-ROW | 컬럼/Measure 메타(2.75) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 컬럼/Measure 메타(2.75): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (컬럼/Measure 메타(2.75)) |
| WK-SCP0010-0363 | G5 | BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래): 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래)) |
| WK-SCP0010-0364 | G5 | Insert 시 확정 searchParams 기준 division | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — Insert 시 확정 searchParams 기준 division: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (Insert 시 확정 searchParams 기준 division) |
| WK-SCP0010-0365 | G5 | SCP0010_Shipment_Plan_SEMI.SpdMain_CellD | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SpdMain_CellDoubleClick: 진입점 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SpdMain_C) |
| WK-SCP0010-0366 | H6 | BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래): 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래)) |
| WK-SCP0010-0367 | H6 | Insert 시 확정 searchParams 기준 division | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — Insert 시 확정 searchParams 기준 division: 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (Insert 시 확정 searchParams 기준 division) |
| WK-SCP0010-0368 | H6 | SCP0010_Shipment_Plan_SEMI.SpdMain_CellD | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SpdMain_CellDoubleClick: 진입점 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SpdMain_C) |
| WK-SCP0010-0369 | M4 | BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래): 행 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래)) |
| WK-SCP0010-0370 | M4 | Insert 시 확정 searchParams 기준 division | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — Insert 시 확정 searchParams 기준 division: 행 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Insert 시 확정 searchParams 기준 division) |
| WK-SCP0010-0371 | M4 | SCP0010_Shipment_Plan_SEMI.SpdMain_CellD | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0010_Shipment_Plan_SEMI.SpdMain_CellDoubleClick: 진입점 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0010_Shipment_Plan_SEMI.SpdMain_C) |
