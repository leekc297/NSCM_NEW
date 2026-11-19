# 작업 원장 — SCP0111 · 2026-11-19 13:16

> 검사 인스턴스 331건 중 PASS·NA 303건 외 **28건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 13 | 재판정 PASS |
| W7 | 기대값 확정 | 10 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 5 | 원인 해소 → 재판정 |

- 담당: 화면 FE 10 · 사람 판정 / AS-IS 원문 확인 → 재판정 10 · 하네스·환경 5 · DB 1 · DB 객체 1 · 사람판정 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 5 |  |  |  | 3 |  | 2 | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 5 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  | 4 |  |  |  |  |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| F4 | DB |  |  | 1 |  |  |  |  |  | 2 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| H4 | DESIGN |  |  | 1 |  |  |  |  |  |  | 레이아웃·스크롤·크기 |
| D6 | EDIT |  |  | 1 |  |  |  |  |  |  | Insert 위치·상태 유지 |
| I1 | DESIGN |  |  |  |  |  |  | 1 |  |  | LBL/MSG 언어별 등록 |
| X-LOC | GEN |  |  |  |  |  |  | 1 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |

## W3 동작 수정 (13)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0001 | F1 | SCP0111 화면 | DB(🛠️/🧯 적용 가능) | F1 FAIL 수정 — SCP0111 화면: 원장 V-3937cc87 RULE_SCREEN / 원장 V-bded1ccf RULE_SCREEN / 원장 V-56473196 RULE_SCREEN / 원장 V-6f8e8fd5 RULE_SC |  | 378 (일반 저장 ADMIN 저장 SaveButton InsertButton D) |
| WK-SCP0111-0002 | F4 | PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE: 실측[T-236699af]: PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE: SCP0111/essPackLine |  | 4 (ESS Pack Line ACT:SCP0111_IntegrationPSI) |
| WK-SCP0111-0003 | H4 | SCP0111 화면 | 사람판정(사람판정 대기) | H4 FAIL 수정 — SCP0111 화면: 원장 V-c119ea9a RULE_SCREEN / 원장 V-963e0867 RULE_SCREEN / 원장 V-8511f635 RULE_SCREEN / 원장 V-171648d3 RULE_SC |  | 4 (ACT:SCP0111_IntegrationPSI.SpdMain_TopCh) |
| WK-SCP0111-0004 | D6 | SCP0111 화면 | 화면 FE(범위 밖(가이드만)) | D6 FAIL 수정 — SCP0111 화면: 원장 V-65789ebc RULE_SCREEN / 원장 V-7b1419f1 RULE_SCREEN / 원장 V-daa3f0ba RULE_SCREEN / 원장 V-309492cc GENERAL |  | 4 (InsertButton 대상 행 미선택 ACT:SCP0111_Integr) |
| WK-SCP0111-0005 | G1 | FindButton | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — FindButton: 행 집계 — 대조표 FindButton 'search=handleSearch' 의 G1 8요소: PASS:5 · NA:2 · FAIL:1 · FAIL 요소: MSG00344 — 원장 V-c |  | 1 (FindButton) |
| WK-SCP0111-0006 | G1 | MSG00344 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — MSG00344: 원장 V-c73d3323 (FX-SCP0111-010) |  | 1 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0007 | G1 | 메인 조회 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — 메인 조회: 행 집계 — 대조표 메인 조회 '`P_SCP0111_GET_INTEGRATION_PSI` (10 IN + O_RC[PIVO' 의 G1 8요소: PASS:5 · NA:2 · FAIL:1 · FAIL  |  | 1 (메인 조회) |
| WK-SCP0111-0008 | G1 | 조회기간 from>to 금지 | 화면 FE(범위 밖(가이드만)) | G1 FAIL 수정 — 조회기간 from>to 금지: 행 집계 — 대조표 조회기간 from>to 금지 'Form 조회 전' 의 G1 8요소: PASS:5 · NA:2 · FAIL:1 · FAIL 요소: MSG00344 — 원장 V-c |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0009 | X-ROW | SCP0111_IntegrationPSI.FindData_Main | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.FindData_Main: 진입점 집계 17검사 — PASS:9 · NA:5 · REVIEW:1 · WARN:1 · FAIL:1 (FX-SCP0111-048) |  | 8 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0010 | X-ROW | SCP0111_IntegrationPSI.GetEssPackLineAll | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.GetEssPackLineAll: 진입점 집계 5검사 — NA:2 · PASS:2 · FAIL:1 (FX-SCP0111-049) |  | 3 (ACT:SCP0111_IntegrationPSI.GetEssPackLin) |
| WK-SCP0111-0011 | X-ROW | SCP0111_IntegrationPSI.InsertButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.InsertButton: 진입점 집계 1검사 — FAIL:1 (FX-SCP0111-050) |  | 1 (ACT:SCP0111_IntegrationPSI.InsertButton) |
| WK-SCP0111-0012 | X-ROW | SCP0111_IntegrationPSI.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.SaveData: 진입점 집계 29검사 — NA:15 · PASS:11 · FAIL:1 · ERROR:1 · WARN:1 (FX-SCP0111-051) |  | 11 (ACT:SCP0111_IntegrationPSI.SaveData:1105) |
| WK-SCP0111-0013 | X-ROW | SCP0111_IntegrationPSI.SpdMain_TopChange | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.SpdMain_TopChange: 진입점 집계 1검사 — FAIL:1 (FX-SCP0111-052) |  | 2 (ACT:SCP0111_IntegrationPSI.SpdMain_TopCh) |

## W7 기대값 확정 (10)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0014 | I1 | SCP0111 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | I1 기대값 확정 — SCP0111 화면: 원장 V-5b8cf7b5 RULE_SCREEN / 원장 V-20b686a3 RULE_SCREEN / 원장 V-198950ce RULE_SCREEN / 원장 V-fc7c6b51 DEFECT / |  | 24 (조회기간 from>to 금지 필수값 공백(15건) OPERATION_GR) |
| WK-SCP0111-0015 | A1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton: 행 집계 — 대조표 FindButton 'search=handleSearch' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_SCP0111.P_SCP0111_GET_INTE — |  | 1 (FindButton) |
| WK-SCP0111-0016 | A1 | PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE: golden DIFF AS-IS 32행 ↔ TO-BE 50행: Doc/golden/SCP0111/SCP0111_GET_ESS_PACK_LI |  | 1 (ESS Pack Line) |
| WK-SCP0111-0017 | A1 | PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI: golden DIFF AS-IS 1712행 ↔ TO-BE 1712행: Doc/golden/SCP0111/SCP0111_GET_INTEG |  | 58 (메인 조회 ACT:SCP0111_IntegrationPSI.FindBut) |
| WK-SCP0111-0018 | A1 | P_SCP0111_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0111_GET: 골든 비교 케이스 없음(P_SCP0111_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (메인 조회) |
| WK-SCP0111-0019 | A1 | 조회기간 from>to 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회기간 from>to 금지: 행 집계 — 대조표 조회기간 from>to 금지 'Form 조회 전' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_SCP0111.P_SCP0111_GET_INTE — |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0020 | X-LOC | ESS 파생검증 D1/D2 불일치 경고 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ESS 파생검증 D1/D2 불일치 경고: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 (행의 식별자 SCP0111_DERIV_MISMATCH 를 화면 소 |  | 1 (ESS 파생검증 D1/D2 불일치 경고) |
| WK-SCP0111-0021 | X-ROW | SCP0111_IntegrationPSI.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.FindButton: 진입점 집계 3검사 — PASS:2 · REVIEW:1 |  | 1 (ACT:SCP0111_IntegrationPSI.FindButton) |
| WK-SCP0111-0022 | X-ROW | SCP0111_IntegrationPSI.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/VALUE_SET, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0111_IntegrationPSI.OnShown ACT:S) |
| WK-SCP0111-0023 | X-ROW | SCP0111_IntegrationPSI._defaultDataModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI._defaultDataModel_Changed: 진입점 집계 24검사 — NA:23 · WARN:1 |  | 3 (ACT:SCP0111_IntegrationPSI._defaultDataM) |

## W9 도구 오류 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0024 | J2 | SCP0111 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-7c5a2756 RULE_SCREEN / 원장 V-23a7d751 DEFECT / 원장 V-ab60b58e GENERAL / 원장 V-1e620509 GENERAL / 원장 V-9fa0d5b0 GENERA |  | 43 (메인 조회 일반 저장 ADMIN 저장 FindButton SaveButt) |
| WK-SCP0111-0025 | F4 | PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_P | 하네스·환경 | F4 도구 오류 — 실측[T-ea67ed5b]: [측정 경로 없음] PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI: 이번 Save 는 main/SAVEDETAIL 로 저장(정상 호출) — 이 SP 경로  |  | 366 (일반 저장 ACT:SCP0111_IntegrationPSI.SaveBut) |
| WK-SCP0111-0026 | F4 | P_SCP0111_SAVE | 하네스·환경 | F4 도구 오류 — 실측[T-03071eab]: [측정 경로 없음] P_SCP0111_SAVE: 이번 Save 는 main/SAVEDETAIL 로 저장(정상 호출) — 이 SP 경로 main/SAVE 는 다른 시트·버튼 저장이라 이  |  | 1 (일반 저장) |
| WK-SCP0111-0027 | X-ROW | SCP0111_IntegrationPSI.BtnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:6 · NA:2 · ERROR:1 |  | 5 (ACT:SCP0111_IntegrationPSI.BtnItemId_Cli) |
| WK-SCP0111-0028 | X-ROW | SCP0111_IntegrationPSI.BtnNickName_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:6 · NA:2 · ERROR:1 |  | 5 (ACT:SCP0111_IntegrationPSI.BtnNickName_C) |
