# 작업 원장 — SCP0111 · 2026-11-18 11:03

> 검사 인스턴스 331건 중 PASS·NA 305건 외 **26건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 8 | 재판정 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 5 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 12 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 12 · 화면 FE 5 · 사람 판정 / AS-IS 원문 확인 → 재판정 5 · DB 객체 3 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 3 |  |  |  | 1 |  | 6 | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 4 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| F4 | DB |  |  | 1 |  |  |  |  |  | 2 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| F6 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 값 보존 |
| D6 | EDIT |  |  | 1 |  |  |  |  |  |  | Insert 위치·상태 유지 |
| G4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 표시·라벨·활성 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (8)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0001 | F1 | SCP0111 화면 | DB 객체(PKG/SP)(적용 예정) | F1 FAIL 수정 — SCP0111 화면: 원장 V-3937cc87 RULE_SCREEN / 원장 V-bded1ccf RULE_SCREEN / 원장 V-56473196 RULE_SCREEN / 원장 V-6f8e8fd5 RULE_SC |  | 378 (일반 저장 ADMIN 저장 SaveButton InsertButton D) |
| WK-SCP0111-0002 | F5 | SCP0111 화면 | 화면 FE(범위 밖(가이드만)) | F5 FAIL 수정 — SCP0111 화면: 원장 V-02e2f75a RULE_SCREEN / 원장 V-23d0a714 RULE_SCREEN / 원장 V-271762c3 RULE_SCREEN / 원장 V-222881c4 DEFECT  |  | 1 (DeleteButton) |
| WK-SCP0111-0003 | F6 | SCP0111 화면 | DB 객체(PKG/SP)(적용 예정) | F6 FAIL 수정 — SCP0111 화면: 원장 V-64f29823 RULE_SCREEN / 원장 V-4b9aa2ea RULE_SCREEN / 원장 V-b3afa86b RULE_SCREEN / 원장 V-65accf87 RULE_SC |  | 368 (일반 저장 ADMIN 저장 ACT:SCP0111_IntegrationPS) |
| WK-SCP0111-0004 | F4 | PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE | DB 객체(PKG/SP)(적용 예정) | F4 FAIL 수정 — PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE: 실측[T-236699af]: PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE: SCP0111/essPackLine |  | 4 (ESS Pack Line ACT:SCP0111_IntegrationPSI) |
| WK-SCP0111-0005 | D6 | SCP0111 화면 | 화면 FE(범위 밖(가이드만)) | D6 FAIL 수정 — SCP0111 화면: 원장 V-65789ebc RULE_SCREEN / 원장 V-7b1419f1 RULE_SCREEN / 원장 V-daa3f0ba RULE_SCREEN / 원장 V-309492cc GENERAL |  | 4 (InsertButton 대상 행 미선택 ACT:SCP0111_Integr) |
| WK-SCP0111-0006 | X-ROW | SCP0111_IntegrationPSI.GetEssPackLineAll | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.GetEssPackLineAll: 진입점 집계 5검사 — PASS:2 · NA:2 · FAIL:1 (FX-SCP0111-036) |  | 3 (ACT:SCP0111_IntegrationPSI.GetEssPackLin) |
| WK-SCP0111-0007 | X-ROW | SCP0111_IntegrationPSI.InsertButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.InsertButton: 진입점 집계 1검사 — FAIL:1 (FX-SCP0111-037) |  | 1 (ACT:SCP0111_IntegrationPSI.InsertButton) |
| WK-SCP0111-0008 | X-ROW | SCP0111_IntegrationPSI.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0111_IntegrationPSI.SaveData: 진입점 집계 29검사 — NA:15 · PASS:10 · FAIL:2 · ERROR:2 (FX-SCP0111-038) |  | 11 (ACT:SCP0111_IntegrationPSI.SaveData:1105) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0009 | G4 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0111_IntegrationPSI.InitControls ) |

## W7 기대값 확정 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0010 | A1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton: 행 집계 — 대조표 FindButton 'search=handleSearch' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: P_SCP0111_GET — 골든 비교 케 |  | 1 (FindButton) |
| WK-SCP0111-0011 | A1 | PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE: golden DIFF AS-IS 32행 ↔ TO-BE 50행: Doc/golden/SCP0111/SCP0111_GET_ESS_PACK_LI |  | 1 (ESS Pack Line) |
| WK-SCP0111-0012 | A1 | P_SCP0111_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0111_GET: 골든 비교 케이스 없음(P_SCP0111_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (메인 조회) |
| WK-SCP0111-0013 | A1 | 조회기간 from>to 금지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회기간 from>to 금지: 행 집계 — 대조표 조회기간 from>to 금지 'Form 조회 전' 의 A1 3요소: REVIEW:2 · PASS:1 · FAIL 요소: P_SCP0111_GET — 골든 비교 케 |  | 1 (조회기간 from>to 금지) |
| WK-SCP0111-0014 | X-ROW | SCP0111_IntegrationPSI.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0111_IntegrationPSI.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/VALUE_SET, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0111_IntegrationPSI.OnShown ACT:S) |

## W9 도구 오류 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0111-0015 | J2 | SCP0111 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-7c5a2756 RULE_SCREEN / 원장 V-23a7d751 DEFECT / 원장 V-ab60b58e GENERAL / 원장 V-1e620509 GENERAL / 원장 V-9fa0d5b0 GENERA |  | 43 (메인 조회 일반 저장 ADMIN 저장 FindButton SaveButt) |
| WK-SCP0111-0016 | K4 | SCP0111 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-3b3010d2 GENERAL / 원장 V-97eaffab GENERAL / 원장 V-c530b2d7 GENERAL / 원장 V-38c57113 GENERAL / 원장 V-e24201f7 GENERAL / |  | 27 (ACT:SCP0111_IntegrationPSI.BtnCellItem_I) |
| WK-SCP0111-0017 | F4 | PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_P | 하네스·환경 | F4 도구 오류 — 실측[T-ea67ed5b]: [측정 경로 없음] PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI: 이번 Save 는 main/SAVEDETAIL 로 저장(정상 호출) — 이 SP 경로  |  | 366 (일반 저장 ACT:SCP0111_IntegrationPSI.SaveBut) |
| WK-SCP0111-0018 | F4 | P_SCP0111_SAVE | 하네스·환경 | F4 도구 오류 — 실측[T-03071eab]: [측정 경로 없음] P_SCP0111_SAVE: 이번 Save 는 main/SAVEDETAIL 로 저장(정상 호출) — 이 SP 경로 main/SAVE 는 다른 시트·버튼 저장이라 이  |  | 1 (일반 저장) |
| WK-SCP0111-0019 | H4 | SCP0111 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-c119ea9a RULE_SCREEN / 원장 V-963e0867 RULE_SCREEN / 원장 V-8511f635 RULE_SCREEN / 원장 V-171648d3 RULE_SCREEN / 원장 V-e1 |  | 4 (ACT:SCP0111_IntegrationPSI.SpdMain_TopCh) |
| WK-SCP0111-0020 | I1 | SCP0111 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-5b8cf7b5 RULE_SCREEN / 원장 V-20b686a3 RULE_SCREEN / 원장 V-198950ce RULE_SCREEN / 원장 V-fc7c6b51 DEFECT / 원장 V-9f001c1 |  | 24 (조회기간 from>to 금지 필수값 공백(15건) OPERATION_GR) |
| WK-SCP0111-0021 | X-ROW | SCP0111_IntegrationPSI.BtnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:5 · ERROR:2 · NA:2 |  | 5 (ACT:SCP0111_IntegrationPSI.BtnItemId_Cli) |
| WK-SCP0111-0022 | X-ROW | SCP0111_IntegrationPSI.BtnNickName_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:5 · ERROR:2 · NA:2 |  | 5 (ACT:SCP0111_IntegrationPSI.BtnNickName_C) |
| WK-SCP0111-0023 | X-ROW | SCP0111_IntegrationPSI.FindData_Main | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 17검사 — PASS:12 · NA:4 · ERROR:1 |  | 8 (ACT:SCP0111_IntegrationPSI.FindData_Main) |
| WK-SCP0111-0024 | X-ROW | SCP0111_IntegrationPSI.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:5 · NA:3 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0111_IntegrationPSI.InitControls:) |
| WK-SCP0111-0025 | X-ROW | SCP0111_IntegrationPSI.SpdMain_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SCP0111_IntegrationPSI.SpdMain_TopCh) |
| WK-SCP0111-0026 | X-ROW | SCP0111_IntegrationPSI._defaultDataModel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 24검사 — NA:23 · ERROR:1 |  | 3 (ACT:SCP0111_IntegrationPSI._defaultDataM) |
