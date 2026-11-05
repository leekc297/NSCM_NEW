# 작업 원장 — SCP0111 · 2026-11-05 07:58

> 검사 인스턴스 269건 중 PASS·NA 190건 외 **79건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 31 | 재판정 PASS |
| W5 | 검사기 연결 | 7 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 29 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 12 | 원인 해소 → 재판정 |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 29 · 하네스·환경 12 · DB 객체 10 · FE 10 · 화면 FE 8 · 하네스 7 · 사람판정 3
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 5건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 9 |  |  |  | 2 |  | 11 | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  |  |  |  |  |  | 20 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| F4 | DB |  |  | 5 |  |  |  |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G4 | DESIGN |  |  | 3 |  | 2 |  |  |  |  | 조회조건 표시·라벨·활성 |
| DB-SYN | DB |  |  |  |  | 5 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| A1 | GEN |  |  |  |  |  |  | 5 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| E4 | EDIT |  |  | 3 |  |  |  |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A6 | GEN |  |  | 2 |  |  |  | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  | 1 |  |  |  |  |  |  | 1회 저장(변경 감지) |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| F6 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 값 보존 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| H4 | DESIGN |  |  | 1 |  |  |  |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  | 1 |  |  |  |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  | 1 |  |  |  |  |  |  | Insert 위치·상태 유지 |
| X-REOPEN | GEN |  |  | 1 |  |  |  |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |

## W3 동작 수정 (31)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0001 | F1 | SCP0111 화면 | DB 객체(PKG/SP)(적용 예정) | F1 FAIL 수정 — SCP0111 화면: 원장 V-1a8b7e39 RULE_SCREEN / 원장 V-bded1ccf RULE_SCREEN / 원장 V-56473196 RULE_SCREEN / 원장 V-6f8e8fd5 RULE_SC |  | 378 (일반 저장 ADMIN 저장 SaveButton InsertButton D) |
| WK-SCP0111-0002 | F2 | SCP0111 화면 | 화면 FE(적용 예정) | F2 FAIL 수정 — SCP0111 화면: 원장 V-b5cfd22a RULE_SCREEN / 원장 V-129ff7c5 RULE_SCREEN / 원장 V-30816eaf GENERAL / 원장 V-800b7aa0 GENERAL / 원 |  | 377 (일반 저장 ADMIN 저장 SaveButton InsertButton 필) |
| WK-SCP0111-0003 | F5 | SCP0111 화면 | 화면 FE(적용 예정) | F5 FAIL 수정 — SCP0111 화면: 원장 V-9df393e4 RULE_SCREEN / 원장 V-23d0a714 RULE_SCREEN / 원장 V-271762c3 RULE_SCREEN / 원장 V-222881c4 DEFECT  |  | 1 (DeleteButton) |
| WK-SCP0111-0004 | F6 | SCP0111 화면 | DB 객체(PKG/SP)(적용 예정) | F6 FAIL 수정 — SCP0111 화면: 원장 V-2220c069 RULE_SCREEN / 원장 V-4b9aa2ea RULE_SCREEN / 원장 V-b3afa86b RULE_SCREEN / 원장 V-65accf87 RULE_SC |  | 368 (일반 저장 ADMIN 저장 ACT:SCP0111_IntegrationPS) |
| WK-SCP0111-0005 | F4 | PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_P | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI: 실측[T-ea67ed5b]: PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI: 셀을 수정하고 Save  |  | 366 (일반 저장 ACT:SCP0111_IntegrationPSI.SaveBut) |
| WK-SCP0111-0006 | F4 | PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN: 실측[T-81330c67]: PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN: 셀을 수정하고 Save 를 눌렀는데 main/ |  | 1 (ADMIN 저장) |
| WK-SCP0111-0007 | F4 | P_SCP0111_SAVE | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — P_SCP0111_SAVE: 실측[T-03071eab]: P_SCP0111_SAVE: 셀을 수정하고 Save 를 눌렀는데 main/SAVE 호출 0건 — Save 버튼이 저장 호출을 내지 않음 · 알림 'SAV |  | 1 (일반 저장) |
| WK-SCP0111-0008 | F4 | P_SCP0111_SAVE_ADMIN | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — P_SCP0111_SAVE_ADMIN: 실측[T-c715eadc]: P_SCP0111_SAVE_ADMIN: 셀을 수정하고 Save 를 눌렀는데 main/SAVEDETAIL 호출 0건 — Save 버튼이 저장 호 |  | 1 (ADMIN 저장) |
| WK-SCP0111-0009 | F4 | SCP0111_SAVE_INTEGRATION_PSI_ADMIN | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — SCP0111_SAVE_INTEGRATION_PSI_ADMIN: 실측[T-5c60353e]: SCP0111_SAVE_INTEGRATION_PSI_ADMIN: 셀을 수정하고 Save 를 눌렀는데 main/SAVE |  | 365 (ACT:SCP0111_IntegrationPSI.SaveButton AC) |
| WK-SCP0111-0010 | G4 | cboDivision / Division / Div / Div. | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — cboDivision / Division / Div / Div.: 원장 V-7678aab0 SEARCH / E2E smoke labels |  | 4 (ACT:SCP0111_IntegrationPSI.InitControls ) |
| WK-SCP0111-0011 | G4 | cboPlanDate / Plan-date / Plan Date | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — cboPlanDate / Plan-date / Plan Date: 원장 V-7ea998d1 SEARCH / E2E smoke labels |  | 4 (ACT:SCP0111_IntegrationPSI.InitControls ) |
| WK-SCP0111-0012 | G4 | cboPlanType / Plan-type / Plan Type | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — cboPlanType / Plan-type / Plan Type: E2E smoke labels / 실측[T-d40c573d]: 조회조건 'plan-type, plantype' 은 TO-BE 조회조건 기준표(s |  | 4 (ACT:SCP0111_IntegrationPSI.InitControls ) |
| WK-SCP0111-0013 | H10 | SCP0111 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H10 FAIL 수정 — SCP0111 화면: 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 9 (조회기간 from>to 금지 필수값 공백(15건) OPERATION_GR) |
| WK-SCP0111-0014 | H4 | SCP0111 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H4 FAIL 수정 — SCP0111 화면: 원장 V-612fbb0b RULE_SCREEN / 원장 V-963e0867 RULE_SCREEN / 원장 V-8511f635 RULE_SCREEN / 원장 V-171648d3 RULE_SC |  | 4 (ACT:SCP0111_IntegrationPSI.SpdMain_TopCh) |
| WK-SCP0111-0015 | I1 | SCP0111 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | I1 FAIL 수정 — SCP0111 화면: 원장 V-a09babe7 RULE_SCREEN / 원장 V-20b686a3 RULE_SCREEN / 원장 V-198950ce RULE_SCREEN / 원장 V-fc7c6b51 DEFECT  |  | 24 (조회기간 from>to 금지 필수값 공백(15건) OPERATION_GR) |
| WK-SCP0111-0016 | D6 | SCP0111 화면 | 화면 FE(적용 예정) | D6 FAIL 수정 — SCP0111 화면: 원장 V-65789ebc RULE_SCREEN / 원장 V-7b1419f1 RULE_SCREEN / 원장 V-daa3f0ba RULE_SCREEN / 원장 V-309492cc GENERAL |  | 4 (InsertButton 대상 행 미선택 ACT:SCP0111_Integr) |
| WK-SCP0111-0017 | E4 | MSG00004 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00004: 원장 V-e52e3323 ASIS / 원장 V-4d16fe68 ASIS / 실측[T-7258c056]: MSG00004: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 |  | 3 (저장 대상 변경 없음 ACT:SCP0111_IntegrationPSI.S) |
| WK-SCP0111-0018 | E4 | MSG00004 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00004: 원장 V-e52e3323 / 실측[T-606c7349]: 검사 대상 아님 — catch 블록 예외 메시지(프레임워크 공통 오류 표시) (FX-SCP0111-042) |  | 1 (ACT:SCP0111_IntegrationPSI.SaveData:1419) |
| WK-SCP0111-0019 | E4 | MSG00004 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00004: 원장 V-4d16fe68 / 실측[T-c1a21167]: 검사 대상 아님 — catch 블록 예외 메시지(프레임워크 공통 오류 표시) (FX-SCP0111-043) |  | 1 (ACT:SCP0111_IntegrationPSI.SaveData:1681) |
| WK-SCP0111-0020 | A6 | PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE: 원장 V-a77f1a53 SP / 정렬대조 FAIL 3번째 키부터 다름: AS-IS ['LINE_ID'] ↔ TO-BE ['SCM_SIT |  | 1 (ESS Pack Line) |
| WK-SCP0111-0021 | A6 | PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PS | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI: 원장 V-b6cf8233 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['YYYYMM'] ↔ TO-BE ["(CASE  |  | 58 (메인 조회 ACT:SCP0111_IntegrationPSI.FindBut) |
| WK-SCP0111-0022 | X-REOPEN | SCP0111 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REOPEN FAIL 수정 — SCP0111 화면: 실측[T-4488b2b4]: 탭 닫기 → 재오픈: 치명 콘솔 0 · 5xx 1 · 재오픈 직후 행 0(최초 진입 0) |  | 9 (ACT:SCP0111_IntegrationPSI.Dispose ACT:S) |
| WK-SCP0111-0023 | X-ROW | SCP0111_IntegrationPSI.FindButton | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.FindButton: 진입점 집계 3검사 — REVIEW:1 · FAIL:1 · PASS:1 (FX-SCP0111-068) |  | 1 (ACT:SCP0111_IntegrationPSI.FindButton) |
| WK-SCP0111-0024 | X-ROW | SCP0111_IntegrationPSI.FindData_Main | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.FindData_Main: 진입점 집계 17검사 — NA:7 · PASS:6 · FAIL:3 · REVIEW:1 (FX-SCP0111-069) |  | 8 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0025 | X-ROW | SCP0111_IntegrationPSI.GetBucketType | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.GetBucketType: 진입점 집계 5검사 — NOPATH:3 · NA:1 · FAIL:1 |  | 1 (ACT:SCP0111_IntegrationPSI.GetBucketType) |
| WK-SCP0111-0026 | X-ROW | SCP0111_IntegrationPSI.GetEssPackLineAll | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.GetEssPackLineAll: 진입점 집계 5검사 — NOPATH:2 · NA:1 · PASS:1 · FAIL:1 |  | 3 (ACT:SCP0111_IntegrationPSI.GetEssPackLin) |
| WK-SCP0111-0027 | X-ROW | SCP0111_IntegrationPSI.InitControls | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.InitControls: 진입점 집계 9검사 — PASS:5 · FAIL:3 · NA:1 (FX-SCP0111-070) |  | 2 (ACT:SCP0111_IntegrationPSI.InitControls:) |
| WK-SCP0111-0028 | X-ROW | SCP0111_IntegrationPSI.InsertButton | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.InsertButton: 진입점 집계 1검사 — FAIL:1 (FX-SCP0111-071) |  | 1 (ACT:SCP0111_IntegrationPSI.InsertButton) |
| WK-SCP0111-0029 | X-ROW | SCP0111_IntegrationPSI.SaveData | 화면 FE(적용 예정) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.SaveData: 진입점 집계 26검사 — NA:12 · FAIL:10 · PASS:3 · NOPATH:1 (FX-SCP0111-073) |  | 13 (ACT:SCP0111_IntegrationPSI.SaveData:1105) |
| WK-SCP0111-0030 | X-ROW | SCP0111_IntegrationPSI.SpdMain_TopChange | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.SpdMain_TopChange: 진입점 집계 1검사 — FAIL:1 |  | 2 (ACT:SCP0111_IntegrationPSI.SpdMain_TopCh) |
| WK-SCP0111-0031 | X-ROW | SCP0111_IntegrationPSI._defaultDataModel | 사람판정(사람판정 대기) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI._defaultDataModel_Changed: 진입점 집계 6검사 — NOT_RUN:3 · NA:2 · FAIL:1 (FX-SCP0111-074) |  | 4 (ACT:SCP0111_IntegrationPSI._defaultDataM) |

## W5 검사기 연결 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0032 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0111_IntegrationPSI.GetBucketType) |
| WK-SCP0111-0033 | DB-SYN | P_SCP0111_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0111_GET | 없음(PROC_M 대응 없음) | 1 (메인 조회) |
| WK-SCP0111-0034 | DB-SYN | P_SCP0111_SAVE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0111_SAVE | 없음(PROC_M 대응 없음) | 1 (일반 저장) |
| WK-SCP0111-0035 | DB-SYN | P_SCP0111_SAVE_ADMIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0111_SAVE_ADMIN | 없음(PROC_M 대응 없음) | 1 (ADMIN 저장) |
| WK-SCP0111-0036 | DB-SYN | SCP0111_SAVE_INTEGRATION_PSI_ADMIN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0111_SAVE_INTEGRATION_PSI_ADMIN | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0111_IntegrationPSI.SaveData:1379) |
| WK-SCP0111-0037 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0111_IntegrationPSI.InitEvent ACT) |
| WK-SCP0111-0038 | G4 | btnNickName | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnNickName | 있음(FE 소스) | 2 (ACT:SCP0111_IntegrationPSI.InitEvent ACT) |

## W7 기대값 확정 (29)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0039 | A1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton: 행 집계 — 대조표 FindButton 'search=handleSearch' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_SCP0111.P_SCP0111_GET_INTE — |  | 1 (FindButton) |
| WK-SCP0111-0040 | A1 | PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0111/SCP0111_GET_ESS_PACK_LI |  | 1 (ESS Pack Line) |
| WK-SCP0111-0041 | A1 | PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0111/SCP0111_GET_INTEGRATI |  | 58 (메인 조회 ACT:SCP0111_IntegrationPSI.FindBut) |
| WK-SCP0111-0042 | A1 | P_SCP0111_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0111_GET: 골든 비교 케이스 없음(P_SCP0111_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (메인 조회) |
| WK-SCP0111-0043 | A1 | 조회기간 from>to 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회기간 from>to 금지: 행 집계 — 대조표 조회기간 from>to 금지 'Form 조회 전' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_SCP0111.P_SCP0111_GET_INTE — |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0044 | A6 | P_SCP0111_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_SCP0111_GET: 검증 엔진이 실행됐으나 이 대상(SP P_SCP0111_GET)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · |  | 1 (메인 조회) |
| WK-SCP0111-0045 | G03-WIRE | SCP0111 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0111 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 / 게이트 G03 As-is 이벤트 btnNickName.Click → BtnNickNam  |  | 14 (ACT:SCP0111_IntegrationPSI..ctor ACT:SCP) |
| WK-SCP0111-0046 | X-LOC | (공용) Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — (공용) Excel: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ((공용) Excel) |
| WK-SCP0111-0047 | X-LOC | ADMIN 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ADMIN 저장: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ADMIN 저장) |
| WK-SCP0111-0048 | X-LOC | DeleteButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DeleteButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DeleteButton) |
| WK-SCP0111-0049 | X-LOC | ESS Pack Line | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ESS Pack Line: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ESS Pack Line) |
| WK-SCP0111-0050 | X-LOC | ESS 파생검증 D1/D2 불일치 경고 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ESS 파생검증 D1/D2 불일치 경고: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ESS 파생검증 D1/D2 불일치 경고) |
| WK-SCP0111-0051 | X-LOC | EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EditButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EditButton) |
| WK-SCP0111-0052 | X-LOC | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FindButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FindButton) |
| WK-SCP0111-0053 | X-LOC | InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — InsertButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (InsertButton) |
| WK-SCP0111-0054 | X-LOC | Line 미지정("-") 저장 확인 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Line 미지정("-") 저장 확인: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Line 미지정("-") 저장 확인) |
| WK-SCP0111-0055 | X-LOC | OPERATION_GROUP NAME→CODE lookup 부재 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — OPERATION_GROUP NAME→CODE lookup 부재: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (OPERATION_GROUP NAME→CODE lookup 부재) |
| WK-SCP0111-0056 | X-LOC | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SaveButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SaveButton) |
| WK-SCP0111-0057 | X-LOC | 대상 행 미선택 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 대상 행 미선택: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (대상 행 미선택) |
| WK-SCP0111-0058 | X-LOC | 메인 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 메인 조회: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (메인 조회) |
| WK-SCP0111-0059 | X-LOC | 신규행 중복(INSERT_KEY_COLS) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 신규행 중복(INSERT_KEY_COLS): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (신규행 중복(INSERT_KEY_COLS)) |
| WK-SCP0111-0060 | X-LOC | 일반 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 일반 저장: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (일반 저장) |
| WK-SCP0111-0061 | X-LOC | 저장 대상 변경 없음 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 저장 대상 변경 없음: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (저장 대상 변경 없음) |
| WK-SCP0111-0062 | X-LOC | 저장 성공 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 저장 성공: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (저장 성공) |
| WK-SCP0111-0063 | X-LOC | 저장 실패 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 저장 실패: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (저장 실패) |
| WK-SCP0111-0064 | X-LOC | 조회기간 from>to 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회기간 from>to 금지: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0065 | X-LOC | 필수값 공백(15건) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 필수값 공백(15건): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (필수값 공백(15건)) |
| WK-SCP0111-0066 | X-ROW | SCP0111_IntegrationPSI.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/VALUE_SET, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0111_IntegrationPSI.OnShown ACT:S) |
| WK-SCP0111-0067 | X-ROW | SCP0111_IntegrationPSI.spdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.spdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/FLAG/GRID_SE |  | 34 (ACT:SCP0111_IntegrationPSI.spdMain_CellC) |

## W9 도구 오류 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0068 | K4 | SCP0111 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-3b3010d2 GENERAL / 원장 V-97eaffab GENERAL / 원장 V-c530b2d7 GENERAL / 원장 V-38c57113 GENERAL / 원장 V-e24201f7 GENERAL / |  | 27 (ACT:SCP0111_IntegrationPSI.BtnCellItem_I) |
| WK-SCP0111-0069 | X-ROW | SCP0111_IntegrationPSI.BtnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:4 · NA:4 · ERROR:1 |  | 5 (ACT:SCP0111_IntegrationPSI.BtnItemId_Cli) |
| WK-SCP0111-0070 | X-ROW | SCP0111_IntegrationPSI.BtnNickName_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:4 · NA:4 · ERROR:1 |  | 5 (ACT:SCP0111_IntegrationPSI.BtnNickName_C) |
| WK-SCP0111-0071 | X-ROW | SCP0111_IntegrationPSI.CboDivision_Selec | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CboDivision_S) |
| WK-SCP0111-0072 | X-ROW | SCP0111_IntegrationPSI.CboPlanDate_Selec | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CboPlanDate_S) |
| WK-SCP0111-0073 | X-ROW | SCP0111_IntegrationPSI.CboPlanType_Selec | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CboPlanType_S) |
| WK-SCP0111-0074 | X-ROW | SCP0111_IntegrationPSI.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.CreateSpread) |
| WK-SCP0111-0075 | X-ROW | SCP0111_IntegrationPSI.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 22검사 — NA:16 · PASS:5 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0111_IntegrationPSI.EditButton AC) |
| WK-SCP0111-0076 | X-ROW | SCP0111_IntegrationPSI.SetCalendar | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0111_IntegrationPSI.SetCalendar A) |
| WK-SCP0111-0077 | X-ROW | SCP0111_IntegrationPSI.SetChangedPeriod | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:3 · NOT_RUN:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0111_IntegrationPSI.SetChangedPer) |
| WK-SCP0111-0078 | X-ROW | SCP0111_IntegrationPSI.SetSpreadColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:5 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0111_IntegrationPSI.SetSpreadColu) |
| WK-SCP0111-0079 | X-ROW | SCP0111_IntegrationPSI.SetVisibleSheetCo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0111_IntegrationPSI.SetVisibleShe) |
