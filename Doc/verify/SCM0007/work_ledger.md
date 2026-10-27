# 작업 원장 — SCM0007 · 2026-10-26 12:51

> 검사 인스턴스 207건 중 PASS·NA 4건 외 **203건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 11 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 138 | 실행 → PASS |
| W7 | 기대값 확정 | 54 | 기대 확정 → PASS/FAIL |

- 담당: E2E 138 · 사람 판정 / AS-IS 원문 확인 → 재판정 54 · 하네스 11
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 35 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 19 | 1 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A5 | DESIGN |  |  |  |  |  | 13 | 1 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 13 | 1 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 13 | 1 |  |  | 라벨 명칭 |
| D5 | EDIT |  |  |  |  |  | 13 | 1 |  |  | 셀 에디터 유형 |
| M4 | POPUP |  |  |  |  |  | 9 | 2 |  |  | 팝업 선택값 반영 |
| C3 | CASCADE |  |  |  |  |  | 8 | 1 |  |  | 연쇄 자동 채움 |
| F4 | DB |  |  |  |  |  | 8 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| D1 | EDIT |  |  |  |  |  | 5 | 1 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 5 | 1 |  |  | 행 값 기반 조건부 잠금 |
| G1 | GEN |  |  |  |  |  | 5 |  |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| DB-SYN | DB |  |  |  |  | 4 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G5 | POPUP |  |  |  |  | 2 |  | 2 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 |  | 2 |  |  | 팝업 표준·열림 |
| C2 | CASCADE |  |  |  |  |  | 4 |  |  |  | 그리드 셀 cascade 후보 |
| A1 | GEN |  |  |  |  |  |  | 4 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C1 | CASCADE |  |  |  |  |  | 3 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C6 | CASCADE |  |  |  |  |  | 3 |  |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G4 | DESIGN |  |  |  |  |  | 3 |  |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 3 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| A6 | GEN |  |  |  |  |  | 2 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| M3 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 내부 기능(조회·CRUD) |

## W5 검사기 연결 (11)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0007-0001 | F2 | SCM0007 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCM0007 화면 | 판단불가(대상 단위 SCREEN) | 225 (ACT:SCM0007_PopContent.SaveData ACT:SCM0) |
| WK-SCM0007-0002 | F6 | SCM0007 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCM0007 화면 | 판단불가(대상 단위 SCREEN) | 225 (ACT:SCM0007_PopContent.SaveData ACT:SCM0) |
| WK-SCM0007-0003 | DB-SYN | SCM0006_GET_RECIPIENT_MASTER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0006_GET_RECIPIENT_MASTER | 없음(PROC_M 대응 없음) | 7 (ACT:SCM0007_SMS_Setup.FindData_Main:337:) |
| WK-SCM0007-0004 | DB-SYN | SCM0006_GET_RECIPIENT_MESSAGE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0006_GET_RECIPIENT_MESSAGE | 없음(PROC_M 대응 없음) | 7 (ACT:SCM0007_SMS_Setup.SaveData:473:50 AC) |
| WK-SCM0007-0005 | DB-SYN | SCM0006_SAVE_RECIPIENT_MASTER | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0006_SAVE_RECIPIENT_MASTER | 없음(PROC_M 대응 없음) | 5 (ACT:SCM0007_SMS_Setup.SaveData:468:48 AC) |
| WK-SCM0007-0006 | DB-SYN | SCM0006_SAVE_RECIPIENT_MESSAGE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0006_SAVE_RECIPIENT_MESSAGE | 없음(PROC_M 대응 없음) | 5 (ACT:SCM0007_SMS_Setup.SaveData:473:50 AC) |
| WK-SCM0007-0007 | G03-WIRE | SCM0007 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCM0007 화면 | 판단불가(대상 단위 SCREEN) | 23 (ACT:SCM0007_PopContent..ctor ACT:SCM0007) |
| WK-SCM0007-0008 | G5 | MESSAGE_CONTENT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL MESSAGE_CONTENT | 있음(SHEET_COLUMNS) | 20 (ACT:SCM0007_SMS_Setup.SprMessage_CellDou) |
| WK-SCM0007-0009 | G5 | SCM0007_PopContent | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SCM0007_PopContent | 판단불가(대상 단위 POPUP) | 4 (ACT:SCM0007_SMS_Setup.SprMessage_CellDou) |
| WK-SCM0007-0010 | H6 | MESSAGE_CONTENT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL MESSAGE_CONTENT | 있음(SHEET_COLUMNS) | 20 (ACT:SCM0007_SMS_Setup.SprMessage_CellDou) |
| WK-SCM0007-0011 | H6 | SCM0007_PopContent | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SCM0007_PopContent | 판단불가(대상 단위 POPUP) | 4 (ACT:SCM0007_SMS_Setup.SprMessage_CellDou) |

## W6 검증 실행 (138)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0007-0012 | J2 | SCM0007 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCM0007 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 35 (ACT:SCM0007_PopContent.btnButtonList_Usr) |
| WK-SCM0007-0013 | C1 | cboActive / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboActive / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCM0007_SMS_Setup.InitControls:169:4) |
| WK-SCM0007-0014 | C1 | cboModule / Module | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboModule / Module · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.CboModule_Selected) |
| WK-SCM0007-0015 | C1 | cboSubModule / Sub Module | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboSubModule / Sub Module · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.CboModule_Selected) |
| WK-SCM0007-0016 | C2 | CYCLE_CLASS_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CYCLE_CLASS_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:SCM0007_SMS_Setup.SprCategory_ComboS) |
| WK-SCM0007-0017 | C2 | DETAIL_CLASS_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DETAIL_CLASS_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SCM0007_SMS_Setup.SprCategory_ComboS) |
| WK-SCM0007-0018 | C2 | SEND_TIME_TEXT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SEND_TIME_TEXT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCM0007_SMS_Setup.SprCategory_ComboS) |
| WK-SCM0007-0019 | C2 | SUB_MODULE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SUB_MODULE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 0 () |
| WK-SCM0007-0020 | C3 | CATEGORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CATEGORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.SetSelData ACT:SCM) |
| WK-SCM0007-0021 | C3 | CYCLE_CLASS_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CYCLE_CLASS_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 9 (ACT:SCM0007_SMS_Setup.SprCategory_ComboS) |
| WK-SCM0007-0022 | C3 | DETAIL_CLASS_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DETAIL_CLASS_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCM0007_SMS_Setup.SprCategory_ComboS) |
| WK-SCM0007-0023 | C3 | MESSAGE_CONTENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MESSAGE_CONTENT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCM0007_SMS_Setup.Message_EditChange) |
| WK-SCM0007-0024 | C3 | MOBILE_PHONE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MOBILE_PHONE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.SetSelData ACT:SCM) |
| WK-SCM0007-0025 | C3 | SEND_TIME_TEXT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SEND_TIME_TEXT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SCM0007_SMS_Setup.SprCategory_ComboS) |
| WK-SCM0007-0026 | C3 | SMS_GROUP_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SMS_GROUP_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCM0007_SMS_Setup.SetSelData ACT:SCM) |
| WK-SCM0007-0027 | C3 | SMS_PHONE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SMS_PHONE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCM0007_SMS_Setup.All_Receiver_EditC) |
| WK-SCM0007-0028 | C6 | CYCLE_CLASS_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — CYCLE_CLASS_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:SCM0007_SMS_Setup.SprCategory_ComboS) |
| WK-SCM0007-0029 | C6 | DETAIL_CLASS_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DETAIL_CLASS_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SCM0007_SMS_Setup.SprCategory_ComboS) |
| WK-SCM0007-0030 | C6 | SEND_TIME_TEXT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SEND_TIME_TEXT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCM0007_SMS_Setup.SprCategory_ComboS) |
| WK-SCM0007-0031 | K4 | SCM0007 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCM0007 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 35 (ACT:SCM0007_PopContent.btnButtonList_Usr) |
| WK-SCM0007-0032 | F1 | SCM0007 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCM0007 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 235 (ACT:SCM0007_PopContent.SaveData ACT:SCM0) |
| WK-SCM0007-0033 | F5 | SCM0007 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCM0007 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 10 (ACT:SCM0007_SMS_Setup.DeleteButton ACT:S) |
| WK-SCM0007-0034 | F4 | PKG_SCM0007.P_SCM0007_GET_RECIPIENT_SMS_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0007.P_SCM0007_GET_RECIPIENT_SMS_ASSIGN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 3 (ACT:SCM0007_SMS_Setup.ShowReceiver:1297:) |
| WK-SCM0007-0035 | F4 | PKG_SCM0007.P_SCM0007_GET_RECIPIENT_SMS_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0007.P_SCM0007_GET_RECIPIENT_SMS_GROUP_LIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 235 (ACT:SCM0007_SMS_Setup.FindButton ACT:SCM) |
| WK-SCM0007-0036 | F4 | PKG_SCM0007.P_SCM0007_SAVE_RECIPIENT_SMS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0007.P_SCM0007_SAVE_RECIPIENT_SMS_ASSIGN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — |  | 216 (ACT:SCM0007_SMS_Setup.SaveButton ACT:SCM) |
| WK-SCM0007-0037 | F4 | PKG_SCM0007.P_SCM0007_SAVE_RECIPIENT_SMS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0007.P_SCM0007_SAVE_RECIPIENT_SMS_GROUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 216 (ACT:SCM0007_SMS_Setup.SaveButton ACT:SCM) |
| WK-SCM0007-0038 | F4 | SCM0006_GET_RECIPIENT_MASTER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0006_GET_RECIPIENT_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 243 (ACT:SCM0007_SMS_Setup.FindButton ACT:SCM) |
| WK-SCM0007-0039 | F4 | SCM0006_GET_RECIPIENT_MESSAGE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0006_GET_RECIPIENT_MESSAGE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 218 (ACT:SCM0007_SMS_Setup.SaveButton ACT:SCM) |
| WK-SCM0007-0040 | F4 | SCM0006_SAVE_RECIPIENT_MASTER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0006_SAVE_RECIPIENT_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 217 (ACT:SCM0007_SMS_Setup.SaveButton ACT:SCM) |
| WK-SCM0007-0041 | F4 | SCM0006_SAVE_RECIPIENT_MESSAGE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0006_SAVE_RECIPIENT_MESSAGE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 216 (ACT:SCM0007_SMS_Setup.SaveButton ACT:SCM) |
| WK-SCM0007-0042 | A5 | ACTIVE_FLAG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ACTIVE_FLAG · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0043 | A5 | CATEGORY_DESC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CATEGORY_DESC · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 7 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0044 | A5 | CATEGORY_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CATEGORY_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0045 | A5 | CYCLE_CLASS_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CYCLE_CLASS_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0046 | A5 | DETAIL_CLASS_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DETAIL_CLASS_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0047 | A5 | LANGUAGE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LANGUAGE_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0048 | A5 | MESSAGE_CONTENT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MESSAGE_CONTENT · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0049 | A5 | MODULE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MODULE_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0050 | A5 | SEND_TIME_TEXT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEND_TIME_TEXT · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0051 | A5 | SMS_GROUP_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SMS_GROUP_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0052 | A5 | SMS_PHONE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SMS_PHONE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SCM0007_SMS_Setup.All_Receiver_KeyPr) |
| WK-SCM0007-0053 | A5 | SUB_MODULE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SUB_MODULE_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 7 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0054 | A5 | USE_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — USE_TYPE_CODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0055 | G4 | cboActive / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboActive / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCM0007_SMS_Setup.InitControls ACT:S) |
| WK-SCM0007-0056 | G4 | cboModule / Module | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboModule / Module · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCM0007_SMS_Setup.InitControls ACT:S) |
| WK-SCM0007-0057 | G4 | cboSubModule / Sub Module | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboSubModule / Sub Module · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0007_SMS_Setup.InitControls ACT:S) |
| WK-SCM0007-0058 | H2 | ACTIVE_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ACTIVE_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0059 | H2 | CATEGORY_DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CATEGORY_DESC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0060 | H2 | CATEGORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CATEGORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0061 | H2 | CYCLE_CLASS_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CYCLE_CLASS_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0062 | H2 | DETAIL_CLASS_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DETAIL_CLASS_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0063 | H2 | LANGUAGE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LANGUAGE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0064 | H2 | MESSAGE_CONTENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MESSAGE_CONTENT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0065 | H2 | MODULE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MODULE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0066 | H2 | SEND_TIME_TEXT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEND_TIME_TEXT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0067 | H2 | SMS_GROUP_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SMS_GROUP_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0068 | H2 | SMS_PHONE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SMS_PHONE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0069 | H2 | SUB_MODULE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SUB_MODULE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0070 | H2 | USE_TYPE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — USE_TYPE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0071 | H5 | ACTIVE_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ACTIVE_FLAG · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0072 | H5 | CATEGORY_DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CATEGORY_DESC · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0073 | H5 | CATEGORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CATEGORY_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0074 | H5 | CYCLE_CLASS_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CYCLE_CLASS_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0075 | H5 | DETAIL_CLASS_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DETAIL_CLASS_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0076 | H5 | LANGUAGE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LANGUAGE_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0077 | H5 | MESSAGE_CONTENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MESSAGE_CONTENT · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0078 | H5 | MODULE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MODULE_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0079 | H5 | SEND_TIME_TEXT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEND_TIME_TEXT · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0080 | H5 | SMS_GROUP_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SMS_GROUP_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0081 | H5 | SMS_PHONE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SMS_PHONE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0082 | H5 | SUB_MODULE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SUB_MODULE_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0083 | H5 | USE_TYPE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — USE_TYPE_CODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0084 | I1 | SCM0007 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCM0007 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 27 (ACT:SCM0007_PopContent.ChkContent:244:7 ) |
| WK-SCM0007-0085 | D1 | CATEGORY_DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CATEGORY_DESC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCM0007_SMS_Setup.InsertRow:794:13) |
| WK-SCM0007-0086 | D1 | CATEGORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CATEGORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:SCM0007_SMS_Setup.EditButton ACT:SCM) |
| WK-SCM0007-0087 | D1 | LANGUAGE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LANGUAGE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.EditButton:300:5 A) |
| WK-SCM0007-0088 | D1 | MODULE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MODULE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCM0007_SMS_Setup.EditButton ACT:SCM) |
| WK-SCM0007-0089 | D1 | SUB_MODULE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SUB_MODULE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.EditButton:295:2 A) |
| WK-SCM0007-0090 | D3 | CATEGORY_DESC | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CATEGORY_DESC · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCM0007_SMS_Setup.InsertRow:794:13) |
| WK-SCM0007-0091 | D3 | CATEGORY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CATEGORY_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:SCM0007_SMS_Setup.EditButton ACT:SCM) |
| WK-SCM0007-0092 | D3 | LANGUAGE_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LANGUAGE_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.EditButton:300:5 A) |
| WK-SCM0007-0093 | D3 | MODULE_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MODULE_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCM0007_SMS_Setup.EditButton ACT:SCM) |
| WK-SCM0007-0094 | D3 | SUB_MODULE_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SUB_MODULE_CODE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.EditButton:295:2 A) |
| WK-SCM0007-0095 | D5 | ACTIVE_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ACTIVE_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0096 | D5 | CATEGORY_DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CATEGORY_DESC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0097 | D5 | CATEGORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CATEGORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0098 | D5 | CYCLE_CLASS_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CYCLE_CLASS_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0099 | D5 | DETAIL_CLASS_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DETAIL_CLASS_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0100 | D5 | LANGUAGE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LANGUAGE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0101 | D5 | MESSAGE_CONTENT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MESSAGE_CONTENT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0102 | D5 | MODULE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MODULE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0103 | D5 | SEND_TIME_TEXT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SEND_TIME_TEXT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0104 | D5 | SMS_GROUP_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SMS_GROUP_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0105 | D5 | SMS_PHONE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SMS_PHONE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0106 | D5 | SUB_MODULE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SUB_MODULE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0107 | D5 | USE_TYPE_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — USE_TYPE_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SCM0007_SMS_Setup.InitSpread ACT:SCM) |
| WK-SCM0007-0108 | D6 | SCM0007 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCM0007 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InsertButton ACT:S) |
| WK-SCM0007-0109 | E4 | CATEGORY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CATEGORY_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0007_SMS_Setup.SetSelData ACT:SCM) |
| WK-SCM0007-0110 | E4 | DETAIL_CLASS_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DETAIL_CLASS_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0007_SMS_Setup.SprCategory_CellCl) |
| WK-SCM0007-0111 | E4 | MESSAGE_CONTENT | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MESSAGE_CONTENT · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0007_SMS_Setup.Message_EditChange) |
| WK-SCM0007-0112 | E4 | MOBILE_PHONE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MOBILE_PHONE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCM0007_SMS_Setup.SetSelData ACT:SCM) |
| WK-SCM0007-0113 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0007_SMS_Setup.ChkMsgValidation:1) |
| WK-SCM0007-0114 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCM0007_SMS_Setup.SaveData:501:69 AC) |
| WK-SCM0007-0115 | E4 | MSG00005 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00005 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0007_PopContent.ChkContent:244:7) |
| WK-SCM0007-0116 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCM0007_SMS_Setup.SaveData:510:74 AC) |
| WK-SCM0007-0117 | E4 | MSG00060 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00060 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SCM0007_SMS_Setup.ChkCategoryValidat) |
| WK-SCM0007-0118 | E4 | MSG00111 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00111 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0007_SMS_Setup.SprCategory_CellCl) |
| WK-SCM0007-0119 | E4 | MSG00112 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00112 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0007_SMS_Setup.SprCategory_CellCl) |
| WK-SCM0007-0120 | E4 | MSG00121 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00121 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0007_SMS_Setup.SaveData:466:46) |
| WK-SCM0007-0121 | E4 | MSG00122 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00122 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0007_SMS_Setup.ChkCategoryValidat) |
| WK-SCM0007-0122 | E4 | MSG00123 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00123 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0007_SMS_Setup.ChkCategoryValidat) |
| WK-SCM0007-0123 | E4 | MSG00124 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00124 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0007_SMS_Setup.ChkCategoryValidat) |
| WK-SCM0007-0124 | E4 | MSG00165 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00165 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCM0007_PopContent.RtxtContent_TextC) |
| WK-SCM0007-0125 | E4 | SMS_GROUP_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SMS_GROUP_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SCM0007_SMS_Setup.SetSelData ACT:SCM) |
| WK-SCM0007-0126 | E4 | SMS_PHONE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SMS_PHONE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCM0007_SMS_Setup.SetSelData ACT:SCM) |
| WK-SCM0007-0127 | E4 | SUB_MODULE_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SUB_MODULE_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0007_SMS_Setup.SprCategory_CellCl) |
| WK-SCM0007-0128 | A10 | SCM0007 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCM0007 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 59 (ACT:SCM0007_PopContent.Form_Load ACT:SCM) |
| WK-SCM0007-0129 | A6 | PKG_SCM0007.P_SCM0007_GET_RECIPIENT_SMS_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0007.P_SCM0007_GET_RECIPIENT_SMS_GROUP_LIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 20 (ACT:SCM0007_SMS_Setup.FindButton ACT:SCM) |
| WK-SCM0007-0130 | A6 | SCM0006_GET_RECIPIENT_MASTER | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0006_GET_RECIPIENT_MASTER · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spe |  | 28 (ACT:SCM0007_SMS_Setup.FindButton ACT:SCM) |
| WK-SCM0007-0131 | G1 | cboActive / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboActive / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0007_SMS_Setup.FindData_Main ACT:) |
| WK-SCM0007-0132 | G1 | cboModule / Module | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboModule / Module · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0007_SMS_Setup.FindData_Main ACT:) |
| WK-SCM0007-0133 | G1 | cboSubModule / Sub Module | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboSubModule / Sub Module · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0007_SMS_Setup.FindData_Main ACT:) |
| WK-SCM0007-0134 | G1 | txtGroup / MessageHelper.GetTerm(lcGroup | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtGroup / MessageHelper.GetTerm(lcGroupName.Text) · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0007_SMS_Setup.FindData_AllReceiv) |
| WK-SCM0007-0135 | G1 | txtPhone / MessageHelper.GetTerm(lcCallP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtPhone / MessageHelper.GetTerm(lcCallPhone.Text) · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0007_SMS_Setup.FindData_AllReceiv) |
| WK-SCM0007-0136 | G6 | cboActive / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboActive / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitControls ACT:S) |
| WK-SCM0007-0137 | G6 | cboModule / Module | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboModule / Module · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.InitControls ACT:S) |
| WK-SCM0007-0138 | G6 | cboSubModule / Sub Module | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboSubModule / Sub Module · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.InitControls ACT:S) |
| WK-SCM0007-0139 | X-REOPEN | SCM0007 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCM0007 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 16 (ACT:SCM0007_PopContent.Dispose ACT:SCM00) |
| WK-SCM0007-0140 | M3 | SCM0007_PopContent | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SCM0007_PopContent · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 9 (ACT:SCM0007_PopContent..ctor ACT:SCM0007) |
| WK-SCM0007-0141 | M4 | CATEGORY_DESC | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CATEGORY_DESC · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCM0007_SMS_Setup.SprCategory_CellDo) |
| WK-SCM0007-0142 | M4 | CATEGORY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CATEGORY_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCM0007_SMS_Setup.SprCategory_CellDo) |
| WK-SCM0007-0143 | M4 | CYCLE_CLASS_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CYCLE_CLASS_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCM0007_SMS_Setup.SprCategory_CellDo) |
| WK-SCM0007-0144 | M4 | DETAIL_CLASS_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DETAIL_CLASS_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 11 (ACT:SCM0007_SMS_Setup.SprCategory_CellDo) |
| WK-SCM0007-0145 | M4 | MESSAGE_CONTENT | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MESSAGE_CONTENT · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 20 (ACT:SCM0007_SMS_Setup.SprMessage_CellDou) |
| WK-SCM0007-0146 | M4 | MODULE_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MODULE_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 6 (ACT:SCM0007_SMS_Setup.SprCategory_CellDo) |
| WK-SCM0007-0147 | M4 | SCM0007_PopContent | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM0007_PopContent · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCM0007_SMS_Setup.SprMessage_CellDou) |
| WK-SCM0007-0148 | M4 | SEND_TIME_TEXT | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SEND_TIME_TEXT · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (ACT:SCM0007_SMS_Setup.SprCategory_CellDo) |
| WK-SCM0007-0149 | M4 | SUB_MODULE_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SUB_MODULE_CODE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 11 (ACT:SCM0007_SMS_Setup.SprCategory_CellDo) |

## W7 기대값 확정 (54)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0007-0150 | C3 | SCM0007_SMS_Setup.SetSelData | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCM0007_SMS_Setup.SetSelData: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCM0007_SMS_Setup.SetSelData:1540:1 ) |
| WK-SCM0007-0151 | F4 | SCM0007_PopContent.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCM0007_PopContent.SaveData: 진입점 집계 — F4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCM0007_PopContent.SaveData) |
| WK-SCM0007-0152 | A5 | SCM0007_SMS_Setup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCM0007_SMS_Setup.CreateSpread: 진입점 집계 — A5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCM0007_SMS_Setup.CreateSpread:178:1) |
| WK-SCM0007-0153 | H2 | SCM0007_SMS_Setup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCM0007_SMS_Setup.CreateSpread: 진입점 집계 — H2 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCM0007_SMS_Setup.CreateSpread:178:1) |
| WK-SCM0007-0154 | H5 | SCM0007_SMS_Setup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCM0007_SMS_Setup.CreateSpread: 진입점 집계 — H5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCM0007_SMS_Setup.CreateSpread:178:1) |
| WK-SCM0007-0155 | D1 | SCM0007_SMS_Setup.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCM0007_SMS_Setup.EditButton: 진입점 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCM0007_SMS_Setup.EditButton:297:3 A) |
| WK-SCM0007-0156 | D3 | SCM0007_SMS_Setup.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCM0007_SMS_Setup.EditButton: 진입점 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCM0007_SMS_Setup.EditButton:297:3 A) |
| WK-SCM0007-0157 | D5 | SCM0007_SMS_Setup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCM0007_SMS_Setup.CreateSpread: 진입점 집계 — D5 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCM0007_SMS_Setup.CreateSpread:178:1) |
| WK-SCM0007-0158 | E4 | SCM0007_SMS_Setup.SetSelData | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCM0007_SMS_Setup.SetSelData: 진입점 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCM0007_SMS_Setup.SetSelData:1540:1 ) |
| WK-SCM0007-0159 | A1 | PKG_SCM0007.P_SCM0007_GET_RECIPIENT_SMS_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0007.P_SCM0007_GET_RECIPIENT_SMS_ASSIGN: 골든 비교 케이스 없음(PKG_SCM0007.P_SCM0007_GET_RECIPIENT_SMS_ASSIGN — 팝업·보조 SP |  | 1 (ACT:SCM0007_SMS_Setup.ShowReceiver:1312:) |
| WK-SCM0007-0160 | A1 | PKG_SCM0007.P_SCM0007_GET_RECIPIENT_SMS_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0007.P_SCM0007_GET_RECIPIENT_SMS_GROUP_LIST: 골든 비교 케이스 없음(PKG_SCM0007.P_SCM0007_GET_RECIPIENT_SMS_GROUP_LIST —  |  | 20 (ACT:SCM0007_SMS_Setup.FindButton ACT:SCM) |
| WK-SCM0007-0161 | A1 | SCM0006_GET_RECIPIENT_MASTER | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0006_GET_RECIPIENT_MASTER: 골든 비교 케이스 없음(SCM0006_GET_RECIPIENT_MASTER — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케 |  | 28 (ACT:SCM0007_SMS_Setup.FindButton ACT:SCM) |
| WK-SCM0007-0162 | A1 | SCM0006_GET_RECIPIENT_MESSAGE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0006_GET_RECIPIENT_MESSAGE: 골든 비교 케이스 없음(SCM0006_GET_RECIPIENT_MESSAGE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 |  | 1 (ACT:SCM0007_SMS_Setup.ShowMessage:1272:1) |
| WK-SCM0007-0163 | X-ROW | SCM0007_PopContent..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_PopContent..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0007_PopContent..ctor:76:1 ACT:SC) |
| WK-SCM0007-0164 | X-ROW | SCM0007_PopContent.ChkContent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_PopContent.ChkContent: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCM0007_PopContent.ChkContent ACT:SC) |
| WK-SCM0007-0165 | X-ROW | SCM0007_PopContent.Define | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_PopContent.Define: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCM0007_PopContent.Define ACT:SCM000) |
| WK-SCM0007-0166 | X-ROW | SCM0007_PopContent.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_PopContent.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0007_PopContent.Dispose:16:1 ACT:) |
| WK-SCM0007-0167 | X-ROW | SCM0007_PopContent.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_PopContent.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0007_PopContent.Form_Load ACT:SCM) |
| WK-SCM0007-0168 | X-ROW | SCM0007_PopContent.RtxtContent_TextChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_PopContent.RtxtContent_TextChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 19 (ACT:SCM0007_PopContent.RtxtContent_TextC) |
| WK-SCM0007-0169 | X-ROW | SCM0007_PopContent.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_PopContent.SaveData: 진입점 집계 6검사 — NOT_RUN:3 · NOPATH:2 · REVIEW:1 |  | 4 (ACT:SCM0007_PopContent.SaveData:181:1 AC) |
| WK-SCM0007-0170 | X-ROW | SCM0007_PopContent.SetTextBold | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_PopContent.SetTextBold: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0007_PopContent.SetTextBold ACT:S) |
| WK-SCM0007-0171 | X-ROW | SCM0007_PopContent.btnButtonList_UsrButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_PopContent.btnButtonList_UsrButtonList_Cli: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0007_PopContent.btnButtonList_Usr) |
| WK-SCM0007-0172 | X-ROW | SCM0007_SMS_Setup.All_Receiver_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.All_Receiver_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0007_SMS_Setup.All_Receiver_CellD) |
| WK-SCM0007-0173 | X-ROW | SCM0007_SMS_Setup.All_Receiver_EditChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.All_Receiver_EditChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCM0007_SMS_Setup.All_Receiver_EditC) |
| WK-SCM0007-0174 | X-ROW | SCM0007_SMS_Setup.All_Receiver_KeyPress | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.All_Receiver_KeyPress: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCM0007_SMS_Setup.All_Receiver_KeyPr) |
| WK-SCM0007-0175 | X-ROW | SCM0007_SMS_Setup.CboModule_SelectedInde | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.CboModule_SelectedIndexChanged: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0007_SMS_Setup.CboModule_Selected) |
| WK-SCM0007-0176 | X-ROW | SCM0007_SMS_Setup.ChkCategoryValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.ChkCategoryValidation: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 43 (ACT:SCM0007_SMS_Setup.ChkCategoryValidat) |
| WK-SCM0007-0177 | X-ROW | SCM0007_SMS_Setup.ChkMsgValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.ChkMsgValidation: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 36 (ACT:SCM0007_SMS_Setup.ChkMsgValidation A) |
| WK-SCM0007-0178 | X-ROW | SCM0007_SMS_Setup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0007_SMS_Setup.CreateSpread) |
| WK-SCM0007-0179 | X-ROW | SCM0007_SMS_Setup.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0007_SMS_Setup.DefineProperty ACT) |
| WK-SCM0007-0180 | X-ROW | SCM0007_SMS_Setup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCM0007_SMS_Setup.FindButton) |
| WK-SCM0007-0181 | X-ROW | SCM0007_SMS_Setup.FindData_AllReceiver | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.FindData_AllReceiver: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:1 · PASS:1 |  | 2 (ACT:SCM0007_SMS_Setup.FindData_AllReceiv) |
| WK-SCM0007-0182 | X-ROW | SCM0007_SMS_Setup.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.FindData_Main: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:1 · NOPATH:1 |  | 2 (ACT:SCM0007_SMS_Setup.FindData_Main:354:) |
| WK-SCM0007-0183 | X-ROW | SCM0007_SMS_Setup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0007_SMS_Setup.Form_Load) |
| WK-SCM0007-0184 | X-ROW | SCM0007_SMS_Setup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.InitControls: 진입점 집계 11검사 — NOT_RUN:10 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0007_SMS_Setup.InitControls:167:2) |
| WK-SCM0007-0185 | X-ROW | SCM0007_SMS_Setup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.InitSpread: 진입점 집계 53검사 — NOT_RUN:53 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0007_SMS_Setup.InitSpread) |
| WK-SCM0007-0186 | X-ROW | SCM0007_SMS_Setup.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0007_SMS_Setup.InsertButton) |
| WK-SCM0007-0187 | X-ROW | SCM0007_SMS_Setup.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.InsertRow: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 18 (ACT:SCM0007_SMS_Setup.InsertRow ACT:SCM0) |
| WK-SCM0007-0188 | X-ROW | SCM0007_SMS_Setup.Message_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.Message_EditChange: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCM0007_SMS_Setup.Message_EditChange) |
| WK-SCM0007-0189 | X-ROW | SCM0007_SMS_Setup.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.SaveData: 진입점 집계 22검사 — NOT_RUN:13 · NOPATH:6 · PASS:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0007_SMS_Setup.SaveData:427:19 AC) |
| WK-SCM0007-0190 | X-ROW | SCM0007_SMS_Setup.SetSelData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.SetSelData: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:2 |  | 4 (ACT:SCM0007_SMS_Setup.SetSelData:1544:3 ) |
| WK-SCM0007-0191 | X-ROW | SCM0007_SMS_Setup.ShowMessage | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.ShowMessage: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:1 · REVIEW:1 |  | 16 (ACT:SCM0007_SMS_Setup.ShowMessage ACT:SC) |
| WK-SCM0007-0192 | X-ROW | SCM0007_SMS_Setup.ShowReceiver | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.ShowReceiver: 진입점 집계 4검사 — NOT_RUN:2 · PASS:1 · REVIEW:1 |  | 15 (ACT:SCM0007_SMS_Setup.ShowReceiver ACT:S) |
| WK-SCM0007-0193 | X-ROW | SCM0007_SMS_Setup.SprCategory_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.SprCategory_CellClick: 진입점 집계 11검사 — NOT_RUN:11 (미실행 검사가 남아 판정필요) |  | 38 (ACT:SCM0007_SMS_Setup.SprCategory_CellCl) |
| WK-SCM0007-0194 | X-ROW | SCM0007_SMS_Setup.SprCategory_CellDouble | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.SprCategory_CellDoubleClick: 진입점 집계 22검사 — NOT_RUN:20 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCM0007_SMS_Setup.SprCategory_CellDo) |
| WK-SCM0007-0195 | X-ROW | SCM0007_SMS_Setup.SprCategory_ComboSelCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.SprCategory_ComboSelChange: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCM0007_SMS_Setup.SprCategory_ComboS) |
| WK-SCM0007-0196 | X-ROW | SCM0007_SMS_Setup.SprMessage_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.SprMessage_CellClick: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCM0007_SMS_Setup.SprMessage_CellCli) |
| WK-SCM0007-0197 | X-ROW | SCM0007_SMS_Setup.SprMessage_CellDoubleC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0007_SMS_Setup.SprMessage_CellDoubleClick: 진입점 집계 8검사 — NOPATH:4 · NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCM0007_SMS_Setup.SprMessage_CellDou) |
| WK-SCM0007-0198 | G5 | SCM0007_SMS_Setup.All_Receiver_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCM0007_SMS_Setup.All_Receiver_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCM0007_SMS_Setup.All_Receiver_CellD) |
| WK-SCM0007-0199 | G5 | SCM0007_SMS_Setup.SprCategory_CellDouble | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCM0007_SMS_Setup.SprCategory_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SCM0007_SMS_Setup.SprCategory_CellDo) |
| WK-SCM0007-0200 | H6 | SCM0007_SMS_Setup.All_Receiver_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCM0007_SMS_Setup.All_Receiver_CellDoubleClick: 진입점 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCM0007_SMS_Setup.All_Receiver_CellD) |
| WK-SCM0007-0201 | H6 | SCM0007_SMS_Setup.SprCategory_CellDouble | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCM0007_SMS_Setup.SprCategory_CellDoubleClick: 진입점 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SCM0007_SMS_Setup.SprCategory_CellDo) |
| WK-SCM0007-0202 | M4 | SCM0007_SMS_Setup.All_Receiver_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCM0007_SMS_Setup.All_Receiver_CellDoubleClick: 진입점 집계 — M4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCM0007_SMS_Setup.All_Receiver_CellD) |
| WK-SCM0007-0203 | M4 | SCM0007_SMS_Setup.SprCategory_CellDouble | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCM0007_SMS_Setup.SprCategory_CellDoubleClick: 진입점 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SCM0007_SMS_Setup.SprCategory_CellDo) |
