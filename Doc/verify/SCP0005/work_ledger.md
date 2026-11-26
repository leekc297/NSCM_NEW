# 작업 원장 — SCP0005 · 2026-11-26 02:39

> 검사 인스턴스 560건 중 PASS·NA 487건 외 **73건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 57 | 재판정 PASS |
| W7 | 기대값 확정 | 3 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 13 | 원인 해소 → 재판정 |

- 담당: 화면 FE 36 · 하네스·환경 13 · 공통 컴포넌트 10 · FE 8 · DB 객체 3 · 사람 판정 / AS-IS 원문 확인 → 재판정 3
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 17 |  |  |  | 2 |  | 2 | 대조표 행이 서술한 동작을 화면에서 재현 |
| H6 | POPUP |  |  | 16 |  |  |  |  |  | 4 | 팝업 표준·열림 |
| H2 | DESIGN |  |  | 18 |  |  |  |  |  |  | 배경·글자색 규칙 |
| E4 | EDIT |  |  | 4 |  |  |  |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F4 | DB |  |  |  |  |  |  |  |  | 3 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| M3 | POPUP |  |  | 1 |  |  |  |  |  | 1 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | POPUP |  |  |  |  |  |  |  |  | 2 | 팝업 선택값 반영 |
| F1 | CRUD |  |  | 1 |  |  |  |  |  |  | 저장 후 DB 반영(마커 행) |
| I1 | DESIGN |  |  |  |  |  |  | 1 |  |  | LBL/MSG 언어별 등록 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |

## W3 동작 수정 (57)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0001 | F1 | SCP0005 화면 | DB 객체(PKG/SP)(적용 예정) | F1 FAIL 수정 — SCP0005 화면: 원장 V-c9c3b04a RULE_SCREEN / 원장 V-4e4af2a4 RULE_SCREEN / 원장 V-ed1875e6 RULE_SCREEN / 원장 V-26d2974c RULE_SC |  | 202 (R14/R15 저장응답 색칠(99010/99020) R18 Insert/) |
| WK-SCP0005-0002 | H2 | COMMON:UC-07 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 H2 30요소: PASS:22 · FAIL:8 · |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0003 | H2 | DB메타 구동(gridColumns=[]) | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — DB메타 구동(gridColumns=[]): 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 H2 |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0004 | H2 | FROM_CITY | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — FROM_CITY: 원장 V-0810a59e (FX-SCP0005-005) |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0005 | H2 | FROM_CITY | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — FROM_CITY: 원장 V-17e451a7 (FX-SCP0005-008) |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0006 | H2 | FROM_CITY / City | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — FROM_CITY / City: 원장 V-a15f8422 COLUMN / 원장 V-0810a59e ASIS / 원장 V-17e451a7 ASIS / 원장 V-06e7dec2 ASIS / 실측[T-44723d88 |  | 5 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0007 | H2 | PRIORITY / Priority | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — PRIORITY / Priority: 원장 V-a4b02e55 COLUMN / 원장 V-b4651880 ASIS / 원장 V-fa71e89c ASIS / 실측[T-a86cad2c]: PRIORITY: 신규행 편 |  | 7 (R1 숫자셀 범위(cellType) R14/R15 저장응답 색칠(9901) |
| WK-SCP0005-0008 | H2 | R10 TRK→港/Forwarder 7 '-' | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R10 TRK→港/Forwarder 7 '-': 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 H2 30요소: PASS:22 · FA |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0009 | H2 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R11/R12 FROM/TO 셀 더블클릭→도시팝업: 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionM |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0010 | H2 | R16/R17 클라 검증 색칠 | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R16/R17 클라 검증 색칠: 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 H2 30요소: PASS:22 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0011 | H2 | R18 Insert/Delete | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R18 Insert/Delete: 행 집계 — 대조표 R18 Insert/Delete '`GridAction.addRow` / `removeRow(grid, true)`(신규만)' 의 H2 30요소: PASS: |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0012 | H2 | R7 조회 databind | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R7 조회 databind: 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 H2 30요소: PASS:22 · FAIL:8 · FAIL 요소: PRIORITY / |  | 1 (R7 조회 databind) |
| WK-SCP0005-0013 | H2 | R9 TRK/AIR→DAYS 7 'Y' | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — R9 TRK/AIR→DAYS 7 'Y': 행 집계 — 대조표 R9 TRK/AIR→DAYS 7 'Y' '`daysAllYes()` cellEditEnded' 의 H2 30요소: PASS:22 · FAIL:8 ·  |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0014 | H2 | SCP0005_DistributionRoute.CreateSpread | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — SCP0005_DistributionRoute.CreateSpread: 진입점 집계 — 대조표 SCP0005_DistributionRoute.CreateSpread 의 H2 30요소: PASS:22 · FAIL |  | 5 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0015 | H2 | SCP0005_DistributionRoute.SetImageCell | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — SCP0005_DistributionRoute.SetImageCell: 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetImageCell 의 H2 5요소: PASS:3 · FAIL:2 |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0016 | H2 | TO_CITY | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — TO_CITY: 원장 V-c099fa4f (FX-SCP0005-006) |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0017 | H2 | TO_CITY | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — TO_CITY: 원장 V-e63ff383 (FX-SCP0005-009) |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0018 | H2 | TO_CITY / City | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — TO_CITY / City: 원장 V-2c0c4c1d COLUMN / 원장 V-c099fa4f ASIS / 원장 V-e63ff383 ASIS / 원장 V-bc631885 ASIS / 원장 V-dc54eed4 A |  | 6 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0019 | H2 | siMain.SetBGColor | 화면 FE(범위 밖(가이드만)) | H2 FAIL 수정 — siMain.SetBGColor: 원장 V-b4651880 (FX-SCP0005-007) |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0020 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-3134fc3e / 실측[T-ece1c98b]: 99010: TO-BE 알림 = 응답 MSG 열 그대로(가짜 응답 표지 실측) · 서버 문구 'DUP DATA.'(PKG_SCP0005 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0021 | E4 | MSG00043 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00043: 원장 V-3134fc3e ASIS |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0022 | E4 | MSG00265 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00265: 원장 V-4a0b6271 / 실측[T-2c4e7c8a]: MSG00265→MSG01273 · AS-IS btnEaxel_Upload('Upload') → btnEaxel_Upload_Click |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0023 | E4 | MSG00265 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00265: 원장 V-4a0b6271 ASIS |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0024 | X-ROW | SCP0005_DistributionRoute.CheckValid | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.CheckValid: 진입점 집계 14검사 — FAIL:7 · PASS:4 · NA:2 · WARN:1 (FX-SCP0005-025) |  | 39 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0025 | X-ROW | SCP0005_DistributionRoute.CreateSpread | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.CreateSpread: 진입점 집계 4검사 — PASS:3 · FAIL:1 (FX-SCP0005-026) |  | 1 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0026 | X-ROW | SCP0005_DistributionRoute.InitSpread | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.InitSpread: 진입점 집계 29검사 — PASS:28 · FAIL:1 (FX-SCP0005-029) |  | 1 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0027 | X-ROW | SCP0005_DistributionRoute.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.SaveData: 진입점 집계 33검사 — PASS:20 · FAIL:6 · NA:6 · WARN:1 (FX-SCP0005-030) |  | 3 (ACT:SCP0005_DistributionRoute.SaveData:6) |
| WK-SCP0005-0028 | X-ROW | SCP0005_DistributionRoute.SetImageCell | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.SetImageCell: 진입점 집계 36검사 — PASS:23 · NA:10 · FAIL:3 (FX-SCP0005-033) |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0029 | X-ROW | SCP0005_DistributionRoute.btnEaxel_Uploa | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.btnEaxel_Upload_Click: 진입점 집계 7검사 — PASS:3 · FAIL:2 · ERROR:1 · WARN:1 (FX-SCP0005-034) |  | 4 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0030 | X-ROW | SCP0005_DistributionRoute.btnFromSrch_Cl | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.btnFromSrch_Click: 진입점 집계 15검사 — PASS:9 · FAIL:4 · ERROR:1 · NA:1 (FX-SCP0005-036) |  | 3 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0031 | X-ROW | SCP0005_DistributionRoute.btnToSrch_Clic | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.btnToSrch_Click: 진입점 집계 15검사 — PASS:9 · FAIL:4 · ERROR:1 · NA:1 (FX-SCP0005-037) |  | 3 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0032 | X-ROW | SCP0005_DistributionRoute.spdMain_CellDo | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.spdMain_CellDoubleClick: 진입점 집계 44검사 — PASS:19 · NA:12 · ERROR:7 · FAIL:6 (FX-SCP0005-04 |  | 11 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0033 | X-ROW | SCP0005_DistributionRoutePopup..ctor | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoutePopup..ctor: 진입점 집계 2검사 — NA:1 · FAIL:1 (FX-SCP0005-042) |  | 2 (ACT:SCP0005_DistributionRoutePopup..ctor) |
| WK-SCP0005-0034 | X-ROW | SCP0005_DistributionRoutePopup.CreateSpr | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoutePopup.CreateSpread: 진입점 집계 1검사 — FAIL:1 (FX-SCP0005-043) |  | 6 (ACT:SCP0005_DistributionRoutePopup.Creat) |
| WK-SCP0005-0035 | X-ROW | SCP0005_DistributionRoutePopup.DefinePro | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoutePopup.DefineProperty: 진입점 집계 2검사 — PASS:1 · FAIL:1 (FX-SCP0005-044) |  | 2 (ACT:SCP0005_DistributionRoutePopup.Defin) |
| WK-SCP0005-0036 | X-ROW | SCP0005_DistributionRoutePopup.Dispose | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoutePopup.Dispose: 진입점 집계 2검사 — PASS:1 · FAIL:1 (FX-SCP0005-045) |  | 3 (ACT:SCP0005_DistributionRoutePopup.Dispo) |
| WK-SCP0005-0037 | X-ROW | SCP0005_DistributionRoutePopup.FindButto | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoutePopup.FindButton: 진입점 집계 4검사 — PASS:2 · FAIL:1 · ERROR:1 (FX-SCP0005-046) |  | 2 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0038 | X-ROW | SCP0005_DistributionRoutePopup.FindData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoutePopup.FindData: 진입점 집계 6검사 — PASS:4 · ERROR:1 · FAIL:1 (FX-SCP0005-047) |  | 12 (ACT:SCP0005_DistributionRoutePopup.FindD) |
| WK-SCP0005-0039 | X-ROW | SCP0005_DistributionRoutePopup.Form_Load | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoutePopup.Form_Load: 진입점 집계 2검사 — PASS:1 · FAIL:1 (FX-SCP0005-048) |  | 5 (ACT:SCP0005_DistributionRoutePopup.Form_) |
| WK-SCP0005-0040 | X-ROW | SCP0005_DistributionRoutePopup.InitSprea | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoutePopup.InitSpread: 진입점 집계 30검사 — PASS:28 · FAIL:2 (FX-SCP0005-049) |  | 12 (ACT:SCP0005_DistributionRoutePopup.InitS) |
| WK-SCP0005-0041 | H6 | FROM_CITY / City | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — FROM_CITY / City: 원장 V-cca901cb ASIS / 원장 V-c9dc5aa7 ASIS / 원장 EG-e97f075b 팝업 실측 SCM0002_CitybyCountry CELL:FROM_CITY |  | 36 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0042 | H6 | FROM_COUNTRY / Country | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — FROM_COUNTRY / Country: 원장 V-cca901cb ASIS / 원장 V-c9dc5aa7 ASIS / 원장 EG-813457a4 팝업 실측 SCM0002_CitybyCountry CELL:FRO |  | 35 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0043 | H6 | ProgressForm | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — ProgressForm: 행 집계 — 대조표 ProgressForm 'react-query isFetching(별도 팝업 불요)' 의 H6 22요소: FAIL:13 · ERROR:4 · PASS:3 · NA:2 |  | 1 (ProgressForm) |
| WK-SCP0005-0044 | H6 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — R11/R12 FROM/TO 셀 더블클릭→도시팝업: 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionM |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0045 | H6 | SCP0005_DistributionRoute.spdMain_CellDo | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — SCP0005_DistributionRoute.spdMain_CellDoubleClick: 원장 V-0e9099ba ASIS / 원장 V-4cfc72f5 ASIS / 원장 V-cca901cb ASIS / 원장  |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0046 | H6 | TO_CITY / City | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — TO_CITY / City: 원장 EG-7b7aa573 팝업 실측 SCM0002_CitybyCountry CELL:TO_CITY BTN_ORDER / 원장 EG-5f3353a4 팝업 실측 SCM0002_City |  | 5 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0047 | H6 | btnFromSrch | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — btnFromSrch: 원장 V-718e1a16 ASIS / 원장 V-7cdbda05 ASIS / 원장 EG-b395018a 팝업 실측 SCM0002_CitybyCountry BTN:btnFromSrch BTN |  | 2 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0048 | H6 | btnToSrch | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — btnToSrch: 원장 V-616b4d31 ASIS / 원장 V-ac0769f6 ASIS / 원장 EG-b395018a 팝업 실측 SCM0002_CitybyCountry BTN:btnFromSrch BTN_O |  | 2 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0049 | H6 | popCity.Form_Load(false, sCountry, sCity | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popCity.Form_Load(false, sCountry, sCity): 원장 V-cca901cb |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0050 | H6 | popCity.Form_Load(true, sCountry, sCity) | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popCity.Form_Load(true, sCountry, sCity): 원장 V-718e1a16 |  | 1 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0051 | H6 | popCity.Form_Load(true, sCountry, sCity) | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — popCity.Form_Load(true, sCountry, sCity): 원장 V-616b4d31 (FX-SCP0005-011) |  | 1 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0052 | H6 | popCity.ShowDialog() | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — popCity.ShowDialog(): 원장 V-7cdbda05 (FX-SCP0005-010) |  | 1 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0053 | H6 | popCity.ShowDialog() | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — popCity.ShowDialog(): 원장 V-ac0769f6 |  | 1 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0054 | H6 | popCity.ShowDialog() | 공통 컴포넌트(범위 밖(가이드만 · 공통 컴포넌트)) | H6 FAIL 수정 — popCity.ShowDialog(): 원장 V-c9dc5aa7 (FX-SCP0005-012) |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0055 | H6 | txtFromCountry / From Country | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — txtFromCountry / From Country: 원장 EG-b395018a 팝업 실측 SCM0002_CitybyCountry BTN:btnFromSrch BTN_ORDER (조건 txtFromCountr |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0056 | H6 | txtToCountry / To Country | FE(repairScope=DB_ONLY — 이번 범위 밖) | H6 FAIL 수정 — txtToCountry / To Country: 원장 EG-09469e15 팝업 실측 SCM0002_CitybyCountry BTN:btnToSrch BTN_ORDER (조건 txtToCountry 을 읽고 채 |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0057 | M3 | SCP0005_DistributionRoutePopup | 화면 FE(범위 밖(가이드만)) | M3 FAIL 수정 — SCP0005_DistributionRoutePopup: 원장 V-a46588cb ASIS / 실측[T-6d14c72c]: ROUTE_ID 더블클릭(r0) → 10초 동안 대화상자 0 · 서버 호출 0 · 편집 |  | 8 (ACT:SCP0005_DistributionRoutePopup..ctor) |

## W7 기대값 확정 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0058 | I1 | SCP0005 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | I1 기대값 확정 — SCP0005 화면: 원장 V-29c34a39 RULE_SCREEN / 원장 V-38472e83 RULE_SCREEN / 원장 V-cad0bff9 RULE_SCREEN / 원장 V-27f623b5 DEFECT / |  | 15 (PRIORITY>=1 (MSG00107) FROM/TO City Name) |
| WK-SCP0005-0059 | X-ROW | SCP0005_DistributionRoute.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.FindDataMain: 진입점 집계 14검사 — PASS:9 · NA:4 · WARN:1 |  | 6 (ACT:SCP0005_DistributionRoute.FindDataMa) |
| WK-SCP0005-0060 | X-ROW | SCP0005_DistributionRoute.spdMainDataMod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.spdMainDataModel_Changed: 진입점 집계 119검사 — PASS:82 · NA:36 · WARN:1 |  | 21 (ACT:SCP0005_DistributionRoute.spdMainDat) |

## W9 도구 오류 (13)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0061 | K4 | SCP0005 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-4da2eeab GENERAL / 원장 V-971d34fe GENERAL / 원장 V-df84cd6a GENERAL / 원장 V-88b2cf80 GENERAL / 원장 V-7990c634 GENERAL / |  | 33 (COMMON:UC-01 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0005-0062 | F4 | FindDataMain 파라미터 6종 'ALL'→'' | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 F4 5요소: PASS:3 · ERROR:2 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0063 | F4 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 하네스·환경 | F4 도구 오류 — 실측[T-ea530cd5]: SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID: SCP0005/history/SEARCH — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0064 | F4 | SCP0005_GET_DISTRIBUTION_ROUTEID | 하네스·환경 | F4 도구 오류 — 실측[T-719d403c]: SCP0005_GET_DISTRIBUTION_ROUTEID: SCP0005/route/SEARCH_ROUTEID — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시 |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0065 | X-ROW | SCP0005_DistributionRoute.FindButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:8 · ERROR:1 |  | 1 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0066 | X-ROW | SCP0005_DistributionRoute.FindDataReceiv | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — PASS:4 · NA:2 · ERROR:1 · WARN:1 |  | 7 (ACT:SCP0005_DistributionRoute.FindDataRe) |
| WK-SCP0005-0067 | H6 | ROUTE_ID / Route Id | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba ASIS / 원장 V-4cfc72f5 ASIS |  | 9 (R8 ROUTE_ID ACT:SCP0005_DistributionRout) |
| WK-SCP0005-0068 | H6 | SCP0005_DistributionRoutePopup | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba ASIS |  | 2 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0069 | H6 | new GSCM.SCM.PopUp.UIL.SCP0005_Distribut | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0070 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-4cfc72f5 |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0071 | M3 | new GSCM.SCM.PopUp.UIL.SCP0005_Distribut | 하네스·환경 | M3 도구 오류 — 원장 V-a46588cb |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0072 | M4 | SCP0005_DistributionRoute.spdMain_CellDo | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.spdMain_CellDoubleClick 의 M4 8요소: PASS:7 · ERROR:1 |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0073 | M4 | SCP0005_DistributionRoutePopup | 하네스·환경 | M4 도구 오류 — 실측[T-fce350f2]: 검증 엔진이 실행됐으나 이 대상(POPUP SCP0005_DistributionRoutePopup)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 → 기계 판 |  | 2 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
