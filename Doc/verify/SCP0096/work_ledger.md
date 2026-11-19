# 작업 원장 — SCP0096 · 2026-11-19 10:02

> 검사 인스턴스 372건 중 PASS·NA 345건 외 **27건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 9 | 재판정 PASS |
| W6 | 검증 실행 | 2 | 실행 → PASS |
| W7 | 기대값 확정 | 5 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 11 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 11 · FE 8 · 사람 판정 / AS-IS 원문 확인 → 재판정 5 · E2E 2 · 화면 FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 1 |  |  |  | 3 |  | 3 | 대조표 행이 서술한 동작을 화면에서 재현 |
| H5 | DESIGN |  |  |  |  |  |  | 1 |  | 6 | 라벨 명칭 |
| D3 | EDIT |  |  | 5 |  |  |  |  |  |  | 행 값 기반 조건부 잠금 |
| G4 | DESIGN |  |  |  |  |  | 2 |  |  | 2 | 조회조건 표시·라벨·활성 |
| X-REASON | DESIGN |  |  | 2 |  |  |  |  |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  |  | 1 |  |  | LBL/MSG 언어별 등록 |

## W3 동작 수정 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0001 | F5 | SCP0096 화면 | 화면 FE(범위 밖(가이드만)) | F5 FAIL 수정 — SCP0096 화면: 원장 V-4a2afe1f RULE_SCREEN / 원장 V-010f6aa2 RULE_SCREEN / 원장 V-43f92736 RULE_SCREEN / 원장 V-81765b2a DEFECT  |  | 1 (CRUD:DELETE) |
| WK-SCP0096-0002 | X-REASON | D00-3-020 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — D00-3-020: [대조표 근거 없음] 요소 '§3 LockColumn / 405 (spdInfo 제목시트 잠금)' 제외 사유 '제목/헤더 시트 편집 불가 = TO-BE 는 헤더가 columnGro |  | 1 (D00-3-020) |
| WK-SCP0096-0003 | X-REASON | D00-3-032 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — D00-3-032: [대조표 근거 없음] 요소 '§3 SetDblClickColumnShowHide / 819' 제외 사유 '더블클릭 컬럼 접기/펼치기 — AS-IS 부가기능(핵심 조회/편집/저장 무 |  | 1 (D00-3-032) |
| WK-SCP0096-0004 | D3 | COMMON:UC-02 | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 '수정 중 재조회 시 confirm (MSG00703)' 의 D3 8요소: PASS:7 · FAIL:1 · FAIL 요소: spreadInfo |  | 1 (COMMON:UC-02) |
| WK-SCP0096-0005 | D3 | D00-1-011 | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — D00-1-011: 행 집계 — 대조표 D00-1-011 '§1 usrButton1 / UsrButton' 의 D3 8요소: PASS:7 · FAIL:1 · FAIL 요소: spreadInfo.LockColum |  | 1 (D00-1-011) |
| WK-SCP0096-0006 | D3 | D00-4d-002 | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — D00-4d-002: 행 집계 — 대조표 D00-4d-002 '§4d BtnInput_Click 가드 편집모드 아님' 의 D3 8요소: PASS:7 · FAIL:1 · FAIL 요소: spreadInfo.Loc |  | 1 (D00-4d-002) |
| WK-SCP0096-0007 | D3 | D00-4d-006 | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — D00-4d-006: 행 집계 — 대조표 D00-4d-006 '§4d BtnInput_Click 권한(!CanModelChange, 무메시지)' 의 D3 8요소: PASS:7 · FAIL:1 · FAIL 요소: |  | 1 (D00-4d-006) |
| WK-SCP0096-0008 | D3 | spreadInfo.LockColumn | FE(repairScope=DB_ONLY — 이번 범위 밖) | D3 FAIL 수정 — spreadInfo.LockColumn: 원장 V-9e29a0e2 / 실측[T-8f523386]: spreadInfo.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0009 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SetLock | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0096_Shipment_Working_Day_OSP.SetLockSumColumn: 진입점 집계 3검사 — NA:2 · FAIL:1 |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |

## W6 검증 실행 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0010 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (D00-1-005 ACT:SCP0096_Shipment_Working_D) |
| WK-SCP0096-0011 | G4 | usrButton1 / Button1 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — usrButton1 / Button1 · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-011) |

## W7 기대값 확정 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0012 | H5 | chkSum / Sum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — chkSum / Sum: 검증 엔진이 실행됐으나 이 대상(COND chkSum)을 판정하지 못함 — 라벨 명칭 시나리오 수동 확인 또는 엔진 확장 |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0013 | I1 | SCP0096 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | I1 기대값 확정 — SCP0096 화면: 원장 V-721a7ae2 RULE_SCREEN / 원장 V-67eb6936 RULE_SCREEN / 원장 V-0f26785c RULE_SCREEN / 원장 V-de85e28c DEFECT / |  | 12 (D00-4d-001 D00-4d-003 D00-4d-004 D00-4d-) |
| WK-SCP0096-0014 | X-ROW | SCP0096_Shipment_Working_Day_OSP.BtnInpu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.BtnInput_Click: 진입점 집계 7검사 — PASS:6 · WARN:1 |  | 5 (ACT:SCP0096_Shipment_Working_Day_OSP.Btn) |
| WK-SCP0096-0015 | X-ROW | SCP0096_Shipment_Working_Day_OSP.FindDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.FindData_Main: 진입점 집계 15검사 — PASS:11 · NA:3 · WARN:1 |  | 8 (ACT:SCP0096_Shipment_Working_Day_OSP.Fin) |
| WK-SCP0096-0016 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SaveDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0096_Shipment_Working_Day_OSP.SaveData_Main: 진입점 집계 16검사 — PASS:10 · NA:5 · WARN:1 |  | 6 (ACT:SCP0096_Shipment_Working_Day_OSP.Sav) |

## W9 도구 오류 (11)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0096-0017 | G4 | COMMON:UC-06 | 하네스·환경 | G4 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 콤마 다중 입력 전건 조회' 의 G4 7요소: PASS:3 · NA:2 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0096-0018 | G4 | D00-1-010 | 하네스·환경 | G4 도구 오류 — 행 집계 — 대조표 D00-1-010 '§1 usrConditionPanel1 / UsrConditionPanel' 의 G4 7요소: PASS:3 · NA:2 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-010) |
| WK-SCP0096-0019 | H5 | D00-1-008 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-008 '§1 spdMain / FpSpread' 의 H5 3요소: PASS:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-008) |
| WK-SCP0096-0020 | H5 | D00-1-009 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-1-009 '§1 spdMain_Sheet1 / SheetView' 의 H5 3요소: PASS:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-009) |
| WK-SCP0096-0021 | H5 | D00-3-002 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-3-002 '§3 SmartColMerge / 162 (spdInfo 제목시트)' 의 H5 3요소: PASS:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-002) |
| WK-SCP0096-0022 | H5 | D00-3-014 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 D00-3-014 '§3 SmartColMerge / 258 (좌측키 세로병합)' 의 H5 3요소: PASS:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-014) |
| WK-SCP0096-0023 | H5 | SCP0096_Shipment_Working_Day_OSP.CreateS | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SCP0096_Shipment_Working_Day_OSP.CreateSpread 의 H5 3요소: PASS:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Cre) |
| WK-SCP0096-0024 | H5 | SCP0096_Shipment_Working_Day_OSP.SetSpre | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SCP0096_Shipment_Working_Day_OSP.SetSpreadColumn 의 H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
| WK-SCP0096-0025 | X-ROW | SCP0096_Shipment_Working_Day_OSP.CreateS | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — PASS:3 · ERROR:1 |  | 1 (ACT:SCP0096_Shipment_Working_Day_OSP.Cre) |
| WK-SCP0096-0026 | X-ROW | SCP0096_Shipment_Working_Day_OSP.DefineP | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:1 · NA:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0096_Shipment_Working_Day_OSP.Def) |
| WK-SCP0096-0027 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SetSpre | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — PASS:3 · NA:3 · ERROR:1 · NOT_RUN:1 |  | 3 (ACT:SCP0096_Shipment_Working_Day_OSP.Set) |
