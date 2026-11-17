# 작업 원장 — SCP0108 · 2026-11-14 18:04

> 검사 인스턴스 543건 중 PASS·NA 235건 외 **308건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 26 | 재판정 PASS |
| W5 | 검사기 연결 | 7 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 67 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 207 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 207 · 사람 판정 / AS-IS 원문 확인 → 재판정 67 · FE 16 · 화면 FE 10 · 하네스 7 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  |  |  |  |  |  | 51 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  | 8 |  |  |  | 10 |  | 30 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B4 | COMBO |  |  |  |  | 1 |  |  |  | 25 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  |  | 1 |  |  |  | 23 | 콤보 후보 정렬 = AS-IS |
| G1 | GEN |  |  |  |  |  |  |  |  | 24 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 18 | 배경·글자색 규칙 |
| G4 | DESIGN |  |  | 12 |  | 2 |  |  |  |  | 조회조건 표시·라벨·활성 |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 13 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  |  |  |  | 13 | 라벨 명칭 |
| H6 | POPUP |  |  |  |  | 1 | 1 |  |  | 8 | 팝업 표준·열림 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 10 | 그리드 셀 cascade 후보 |
| A6 | GEN |  |  |  |  |  |  |  |  | 9 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| C1 | CASCADE |  |  | 5 |  |  |  | 3 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| D1 | EDIT |  |  |  |  |  |  |  |  | 8 | 컬럼 편집 가능 여부(신규행·기존행) |
| G5 | POPUP |  |  |  |  | 1 |  |  |  | 6 | 팝업 조건 연동(인자) |
| F4 | DB |  |  |  |  |  |  |  |  | 7 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| M4 | POPUP |  |  |  |  |  |  | 3 |  | 3 | 팝업 선택값 반영 |
| M3 | POPUP |  |  |  |  |  |  |  |  | 2 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| K4 | COMMON |  |  | 1 |  |  |  |  |  |  | 버튼 구성·조건별 노출 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J1 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  |  |  |  | 1 | 조회조건 저장·복원 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| D6 | EDIT |  |  |  |  |  |  |  |  | 1 | Insert 위치·상태 유지 |
| E4 | EDIT |  |  |  |  |  |  |  |  | 1 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A10 | GEN |  |  |  |  |  |  |  |  | 1 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |

## W3 동작 수정 (26)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0001 | C1 | cboDivision / Division / Div / Div. | FE(repairScope=DB_ONLY — 이번 범위 밖) | C1 FAIL 수정 — cboDivision / Division / Div / Div.: 원장 V-657b342e SEARCH / 실측[T-cd6ab79d]: 상위 조회조건 [Division / Div / Div.] 칸 없음 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshDivis) |
| WK-SCP0108-0002 | C1 | clbFactory / Building / Factory | FE(repairScope=DB_ONLY — 이번 범위 밖) | C1 FAIL 수정 — clbFactory / Building / Factory: 실측[T-ba90725d]: 상위 조회조건 [Building / Factory] 칸 없음 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshFacto) |
| WK-SCP0108-0003 | C1 | clbLine / Line | FE(repairScope=DB_ONLY — 이번 범위 밖) | C1 FAIL 수정 — clbLine / Line: 실측[T-b2c54bd0]: 상위 조회조건 [Line] 칸 없음 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshLine:) |
| WK-SCP0108-0004 | C1 | clbOperation / Operation | FE(repairScope=DB_ONLY — 이번 범위 밖) | C1 FAIL 수정 — clbOperation / Operation: 실측[T-08b32c52]: 상위 조회조건 [Operation] 칸 없음 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshOpera) |
| WK-SCP0108-0005 | C1 | clbPlant / Plant | FE(repairScope=DB_ONLY — 이번 범위 밖) | C1 FAIL 수정 — clbPlant / Plant: 실측[T-9a195eb8]: 상위 조회조건 [Plant] 칸 없음 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshPlant) |
| WK-SCP0108-0006 | K4 | SCP0108 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | K4 FAIL 수정 — SCP0108 화면: 원장 V-dad03d7f GENERAL / 원장 V-200c362c GENERAL / 원장 V-1814b1bd GENERAL / 원장 V-2811f159 GENERAL / 원장 V-43fd |  | 9 (ACT:SCP0108_CAPA_LOB_Report.btnColumn_Cl) |
| WK-SCP0108-0007 | G4 | `components/CapaLobReportForm.tsx` | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — `components/CapaLobReportForm.tsx`: 행 집계 — 대조표 `components/CapaLobReportForm.tsx` '`usrConditionPanel1`(dsn:133~141)  |  | 1 (`components/CapaLobReportForm.tsx`) |
| WK-SCP0108-0008 | G4 | cboDivision / Division / Div / Div. | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — cboDivision / Division / Div / Div.: 원장 V-bc1fc362 SEARCH / E2E smoke labels — 누락 라벨 (FX-SCP0108-002) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0009 | G4 | cboVersion / Plan Month / Version / Ver. | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — cboVersion / Plan Month / Version / Ver.: 원장 V-3c4cbfdf SEARCH / 원장 V-06170cb1 SEARCH / E2E smoke labels — 누락 라벨 (FX- |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0010 | G4 | cboVersionSeq / Version / Version Seq /  | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — cboVersionSeq / Version / Version Seq / Ver. / Version.: 원장 V-06170cb1 SEARCH / E2E smoke labels — 누락 라벨 (FX-SCP0108- |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0011 | G4 | clbFactory / Building / Factory | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbFactory / Building / Factory: 원장 V-a7f8eb15 SEARCH / E2E smoke labels — 누락 라벨 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0012 | G4 | clbLine / Line | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbLine / Line: 원장 V-151cf204 SEARCH / E2E smoke labels — 누락 라벨 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0013 | G4 | clbOperation / Operation | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbOperation / Operation: 원장 V-35b893a0 SEARCH / E2E smoke labels — 누락 라벨 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0014 | G4 | clbPlant / Plant | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbPlant / Plant: 원장 V-c1db73c0 SEARCH / E2E smoke labels — 누락 라벨 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0015 | G4 | clbSite / Site | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbSite / Site: 원장 V-8fc61407 SEARCH / E2E smoke labels — 누락 라벨 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0016 | G4 | entryPoints | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — entryPoints: 행 집계 — 대조표 entryPoints '15' 의 G4 11요소: FAIL:9 · NOPATH:2 · FAIL 요소: rgrpDivisionType / Division Ty — 원장  |  | 1 (entryPoints) |
| WK-SCP0108-0017 | G4 | rgrpDivisionType / Division Type / Opera | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — rgrpDivisionType / Division Type / Operation group: 원장 V-03c504d5 SEARCH / E2E smoke labels — 누락 라벨 (FX-SCP0108-006) |  | 4 (ACT:SCP0108_CAPA_LOB_Report.Form_Load AC) |
| WK-SCP0108-0018 | G4 | 필수 조회조건 UI(`*`) · Search 전 alert | 화면 FE(범위 밖(가이드만)) | G4 FAIL 수정 — 필수 조회조건 UI(`*`) · Search 전 alert: 행 집계 — 대조표 필수 조회조건 UI(`*`) · Search 전 alert '`DataUtil.InitCheck`(DataUtil:370~622) |  | 1 (필수 조회조건 UI(`*`) · Search 전 alert) |
| WK-SCP0108-0019 | X-ROW | SCP0108_CAPA_LOB_Report.Form_Load | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0108_CAPA_LOB_Report.Form_Load: 진입점 집계 3검사 — NA:1 · ERROR:1 · FAIL:1 (FX-SCP0108-012) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.Form_Load:97) |
| WK-SCP0108-0020 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshDivision | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0108_CAPA_LOB_Report.RefreshDivision: 진입점 집계 1검사 — FAIL:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.RefreshDivis) |
| WK-SCP0108-0021 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshFactory | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0108_CAPA_LOB_Report.RefreshFactory: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshFacto) |
| WK-SCP0108-0022 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshLine | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0108_CAPA_LOB_Report.RefreshLine: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshLine ) |
| WK-SCP0108-0023 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshOperation | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0108_CAPA_LOB_Report.RefreshOperation: 진입점 집계 2검사 — ERROR:1 · FAIL:1 |  | 7 (ACT:SCP0108_CAPA_LOB_Report.RefreshOpera) |
| WK-SCP0108-0024 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshPlant | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0108_CAPA_LOB_Report.RefreshPlant: 진입점 집계 1검사 — FAIL:1 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshPlant) |
| WK-SCP0108-0025 | X-ROW | SCP0108_CAPA_LOB_Report.btnColumn_Click | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0108_CAPA_LOB_Report.btnColumn_Click: 진입점 집계 7검사 — ERROR:4 · FAIL:1 · PASS:1 · NA:1 (FX-SCP0108-013) |  | 3 (ACT:SCP0108_CAPA_LOB_Report.btnColumn_Cl) |
| WK-SCP0108-0026 | X-ROW | SCP0108_CAPA_LOB_Report.btnItem_Click | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0108_CAPA_LOB_Report.btnItem_Click: 진입점 집계 2검사 — ERROR:1 · FAIL:1 (FX-SCP0108-014) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.btnItem_Clic) |

## W5 검사기 연결 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0027 | B3 | FACTORY_ID / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL FACTORY_ID / Building | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrFacto) |
| WK-SCP0108-0028 | B4 | FACTORY_ID / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FACTORY_ID / Building | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrFacto) |
| WK-SCP0108-0029 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0030 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0031 | G03-WIRE | SCP0108 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0108 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:SCP0108_CAPA_LOB_Report..ctor ACT:SC) |
| WK-SCP0108-0032 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnItemId | 있음(FE 소스) | 0 () |
| WK-SCP0108-0033 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 0 () |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0034 | H6 | txtItem / Basic Nickname / Item | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItem / Basic Nickname / Item · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 0 () |

## W7 기대값 확정 (67)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0035 | C1 | cboVersion / Plan Month / Version / Ver. | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — cboVersion / Plan Month / Version / Ver.: 검증 엔진이 실행됐으나 이 대상(COND cboVersion)을 판정하지 못함 — 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화  |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshVersi) |
| WK-SCP0108-0036 | C1 | cboVersionSeq / Version / Version Seq /  | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — cboVersionSeq / Version / Version Seq / Ver. / Ver: 검증 엔진이 실행됐으나 이 대상(COND cboVersionSeq)을 판정하지 못함 — 상위 조회조건 변경 → 하위 후 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshVersi) |
| WK-SCP0108-0037 | C1 | clbSite / Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — clbSite / Site: 검증 엔진이 실행됐으나 이 대상(COND clbSite)을 판정하지 못함 — 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 시나리오 수동 확인 또는 엔진 확장 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshSite:) |
| WK-SCP0108-0038 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0108-0039 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0108-0040 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0108-0041 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0108-0042 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0108-0043 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0108-0044 | X-LOC | ADMIN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ADMIN: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ADMIN) |
| WK-SCP0108-0045 | X-LOC | AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패)) |
| WK-SCP0108-0046 | X-LOC | AS-IS 헤더 높이 75px(1단 35 + 2·3단 20) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS 헤더 높이 75px(1단 35 + 2·3단 20): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS 헤더 높이 75px(1단 35 + 2·3단 20)) |
| WK-SCP0108-0047 | X-LOC | Bottleneck **행 인덱스** 대응 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Bottleneck **행 인덱스** 대응: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Bottleneck **행 인덱스** 대응) |
| WK-SCP0108-0048 | X-LOC | CAPA Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CAPA Planner: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CAPA Planner) |
| WK-SCP0108-0049 | X-LOC | Edit 버튼(`customButtons`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Edit 버튼(`customButtons`): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Edit 버튼(`customButtons`)) |
| WK-SCP0108-0050 | X-LOC | FP Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FP Planner: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FP Planner) |
| WK-SCP0108-0051 | X-LOC | FP Viewer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FP Viewer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FP Viewer) |
| WK-SCP0108-0052 | X-LOC | Formation(`AFFFF`) **전역** 제외 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Formation(`AFFFF`) **전역** 제외: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Formation(`AFFFF`) **전역** 제외) |
| WK-SCP0108-0053 | X-LOC | G1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G1) |
| WK-SCP0108-0054 | X-LOC | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G2) |
| WK-SCP0108-0055 | X-LOC | G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G3) |
| WK-SCP0108-0056 | X-LOC | G4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G4) |
| WK-SCP0108-0057 | X-LOC | G5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G5) |
| WK-SCP0108-0058 | X-LOC | G6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G6) |
| WK-SCP0108-0059 | X-LOC | SCM PI Admin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCM PI Admin: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCM PI Admin) |
| WK-SCP0108-0060 | X-LOC | SCM Viewer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCM Viewer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCM Viewer) |
| WK-SCP0108-0061 | X-LOC | SCP Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP Planner: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP Planner) |
| WK-SCP0108-0062 | X-LOC | SCP Tester | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP Tester: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP Tester) |
| WK-SCP0108-0063 | X-LOC | `CapaLineMasterEE_SCP_ALL` 콤보 스왑 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `CapaLineMasterEE_SCP_ALL` 콤보 스왑: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`CapaLineMasterEE_SCP_ALL` 콤보 스왑) |
| WK-SCP0108-0064 | X-LOC | `LockColumn` 컬럼명 상수 배열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `LockColumn` 컬럼명 상수 배열: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`LockColumn` 컬럼명 상수 배열) |
| WK-SCP0108-0065 | X-LOC | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0066 | X-LOC | `_ASSIGN_PRIORITY` 제외 필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `_ASSIGN_PRIORITY` 제외 필터: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`_ASSIGN_PRIORITY` 제외 필터) |
| WK-SCP0108-0067 | X-LOC | `_dateStartColIdx` / `_dateEndColIdx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `_dateStartColIdx` / `_dateEndColIdx`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`_dateStartColIdx` / `_dateEndColIdx`) |
| WK-SCP0108-0068 | X-LOC | `dtFromYYYY`(`YearFromThisYear_SCP_ALL`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `dtFromYYYY`(`YearFromThisYear_SCP_ALL`): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`dtFromYYYY`(`YearFromThisYear_SCP_ALL`)) |
| WK-SCP0108-0069 | X-LOC | `dtYesOrNo` 필드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `dtYesOrNo` 필드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`dtYesOrNo` 필드) |
| WK-SCP0108-0070 | X-LOC | `fetchStaticMeasures` / `staticMeasures` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `fetchStaticMeasures` / `staticMeasures`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`fetchStaticMeasures` / `staticMeasures`) |
| WK-SCP0108-0071 | X-LOC | `frozenColumns={1}` 하드코딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `frozenColumns={1}` 하드코딩: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`frozenColumns={1}` 하드코딩) |
| WK-SCP0108-0072 | X-LOC | `imageList1` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `imageList1`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`imageList1`) |
| WK-SCP0108-0073 | X-LOC | `isEditMode` state | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `isEditMode` state: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`isEditMode` state) |
| WK-SCP0108-0074 | X-LOC | `spdMain_TopChange` 스크롤 핸들러 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `spdMain_TopChange` 스크롤 핸들러: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`spdMain_TopChange` 스크롤 핸들러) |
| WK-SCP0108-0075 | X-LOC | `statusIdx = UIUtils.GetIndexByCode(...) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `statusIdx = UIUtils.GetIndexByCode(...)`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`statusIdx = UIUtils.GetIndexByCode(...)) |
| WK-SCP0108-0076 | X-LOC | `useProcMutation`/`useSaveWithValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `useProcMutation`/`useSaveWithValidation`/`EditTra: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`useProcMutation`/`useSaveWithValidation) |
| WK-SCP0108-0077 | X-LOC | `usrLayoutControl1` / `layoutControlGrou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `usrLayoutControl1` / `layoutControlGroup1`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`usrLayoutControl1` / `layoutControlGrou) |
| WK-SCP0108-0078 | X-LOC | buttonGuards | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — buttonGuards: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (buttonGuards) |
| WK-SCP0108-0079 | X-LOC | comboCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — comboCalls: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (comboCalls) |
| WK-SCP0108-0080 | X-LOC | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — entryPoints: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (entryPoints) |
| WK-SCP0108-0081 | X-LOC | events | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — events: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (events) |
| WK-SCP0108-0082 | X-LOC | extractionLimits | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — extractionLimits: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (extractionLimits) |
| WK-SCP0108-0083 | X-LOC | gridColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridColumns: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridColumns) |
| WK-SCP0108-0084 | X-LOC | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridSignals: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridSignals) |
| WK-SCP0108-0085 | X-LOC | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — validations: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (validations) |
| WK-SCP0108-0086 | X-LOC | 데드 핸들러 `cboSheetType_SelectedIndexChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 데드 핸들러 `cboSheetType_SelectedIndexChanged` / `cboF: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (데드 핸들러 `cboSheetType_SelectedIndexChange) |
| WK-SCP0108-0087 | X-LOC | 시트 탭 UI(`TabWrapper`/`TabPanel`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 시트 탭 UI(`TabWrapper`/`TabPanel`): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (시트 탭 UI(`TabWrapper`/`TabPanel`)) |
| WK-SCP0108-0088 | X-LOC | 필수 조회조건 UI(`*`) · Search 전 alert | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 필수 조회조건 UI(`*`) · Search 전 alert: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (필수 조회조건 UI(`*`) · Search 전 alert) |
| WK-SCP0108-0089 | X-ROW | SCP0108_CAPA_LOB_Report.BeforeFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.BeforeFindData: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.BeforeFindDa) |
| WK-SCP0108-0090 | X-ROW | SCP0108_CAPA_LOB_Report.ChangeColumnName | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.ChangeColumnNameToCodeName: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/GRID_SET, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.ChangeColumn) |
| WK-SCP0108-0091 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 7 (ACT:SCP0108_CAPA_LOB_Report.RefreshAll A) |
| WK-SCP0108-0092 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshDateColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshDateColumnStatus: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/LOCAL/UI_MISC |  | 16 (ACT:SCP0108_CAPA_LOB_Report.RefreshDateC) |
| WK-SCP0108-0093 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshFactoryAl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshFactoryAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshFacto) |
| WK-SCP0108-0094 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshLineAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshLineAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshLineA) |
| WK-SCP0108-0095 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshPlanType: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/VALUE_SET, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.RefreshPlanT) |
| WK-SCP0108-0096 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshPlantAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshPlantAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshPlant) |
| WK-SCP0108-0097 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshSheetHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshSheetHeader: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY/GRID_INIT, 연결된 요소 검 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshSheet) |
| WK-SCP0108-0098 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshSiteAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshSiteAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshSiteA) |
| WK-SCP0108-0099 | M4 | btnColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnColumn: 검증 엔진이 실행됐으나 이 대상(BTN btnColumn)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (`components/modals/CapaLobReportColumnMo) |
| WK-SCP0108-0100 | M4 | btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnItemId: 검증 엔진이 실행됐으나 이 대상(BTN btnItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 0 () |
| WK-SCP0108-0101 | M4 | txtItem / Basic Nickname / Item | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtItem / Basic Nickname / Item: 검증 엔진이 실행됐으나 이 대상(COND txtItem)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 0 () |

## W9 도구 오류 (207)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0102 | J1 | this.SetDivisionAuthCheck | 하네스·환경 | J1 도구 오류 — 원장 V-60b26aa8 / 실측[T-50639cb9]: [측정 전제 미충족] 조회 응답 행 없음·호출 0건 상태에서 대상 없음 류 증거 — 화면 결함이 아니라 측정 실패로 분류(P1 게이트) · 원 실측: Div |  | 1 (ACT:SCP0108_CAPA_LOB_Report.InitControls) |
| WK-SCP0108-0103 | J2 | SCP0108 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-85821f66 RULE_SCREEN / 원장 V-f3e904f3 DEFECT / 원장 V-1f9a5331 GENERAL / 원장 V-ce06704a GENERAL / 원장 V-9c50f064 GENERA |  | 37 (validations gridSignals entryPoints butt) |
| WK-SCP0108-0104 | C2 | SCP0108_CAPA_LOB_Report.cboDivision_Sele | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.cboDivision_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 6 (ACT:SCP0108_CAPA_LOB_Report.cboDivision_) |
| WK-SCP0108-0105 | C2 | SCP0108_CAPA_LOB_Report.cboVersionSeq_Se | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.cboVersionSeq_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.cboVersionSe) |
| WK-SCP0108-0106 | C2 | SCP0108_CAPA_LOB_Report.cboVersion_Selec | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.cboVersion_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.cboVersion_S) |
| WK-SCP0108-0107 | C2 | SCP0108_CAPA_LOB_Report.clbFactory_Selec | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.clbFactory_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.clbFactory_S) |
| WK-SCP0108-0108 | C2 | SCP0108_CAPA_LOB_Report.clbLine_Selected | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.clbLine_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbLine_Sele) |
| WK-SCP0108-0109 | C2 | SCP0108_CAPA_LOB_Report.clbOperation_Sel | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.clbOperation_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbOperation) |
| WK-SCP0108-0110 | C2 | SCP0108_CAPA_LOB_Report.clbPlant_Selecte | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.clbPlant_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 3 (ACT:SCP0108_CAPA_LOB_Report.clbPlant_Sel) |
| WK-SCP0108-0111 | C2 | SCP0108_CAPA_LOB_Report.clbSite_Selected | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.clbSite_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.clbSite_Sele) |
| WK-SCP0108-0112 | C2 | SCP0108_CAPA_LOB_Report.rgrpDivisionType | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.rgrpDivisionType_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.rgrpDivision) |
| WK-SCP0108-0113 | C2 | VER_SEQ / Seq | 하네스·환경 | C2 도구 오류 — 실측[T-b4d406d5]: 조회 결과 0행 — 연쇄 측정 불가 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshVersi) |
| WK-SCP0108-0114 | B3 | SCP0108_CAPA_LOB_Report.GetSpdTitle | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.GetSpdTitle 의 B3 23요소: NA:10 · ERROR:10 · PASS:2 · NOPATH:1 |  | 7 (ACT:SCP0108_CAPA_LOB_Report.GetSpdTitle:) |
| WK-SCP0108-0115 | B3 | SCP0108_CAPA_LOB_Report.getDivisionType | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getDivisionType 의 B3 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getDivisionT) |
| WK-SCP0108-0116 | B3 | SCP0108_CAPA_LOB_Report.getElectrodeType | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getElectrodeType 의 B3 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getElectrode) |
| WK-SCP0108-0117 | B3 | SCP0108_CAPA_LOB_Report.getFactory | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getFactory 의 B3 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getFactory:4) |
| WK-SCP0108-0118 | B3 | SCP0108_CAPA_LOB_Report.getLine | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getLine 의 B3 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getLine:492:) |
| WK-SCP0108-0119 | B3 | SCP0108_CAPA_LOB_Report.getOperation | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getOperation 의 B3 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getOperation) |
| WK-SCP0108-0120 | B3 | SCP0108_CAPA_LOB_Report.getPlanType | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getPlanType 의 B3 23요소: NA:10 · ERROR:10 · PASS:2 · NOPATH:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.getPlanType:) |
| WK-SCP0108-0121 | B3 | SCP0108_CAPA_LOB_Report.getPlant | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getPlant 의 B3 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getPlant:444) |
| WK-SCP0108-0122 | B3 | SCP0108_CAPA_LOB_Report.getProgressStatu | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getProgressStatus 의 B3 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getProgressS) |
| WK-SCP0108-0123 | B3 | SCP0108_CAPA_LOB_Report.getShopGroup | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getShopGroup 의 B3 23요소: NA:10 · ERROR:10 · PASS:2 · NOPATH:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.getShopGroup) |
| WK-SCP0108-0124 | B3 | SCP0108_CAPA_LOB_Report.getSite | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getSite 의 B3 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getSite:406:) |
| WK-SCP0108-0125 | B3 | SCP0108_CAPA_LOB_Report.getVersion | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getVersion 의 B3 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getVersion:2) |
| WK-SCP0108-0126 | B3 | SCP0108_CAPA_LOB_Report.getVersionSeq | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getVersionSeq 의 B3 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getVersionSe) |
| WK-SCP0108-0127 | B3 | cboProgressStatus / Status / Progress St | 하네스·환경 | B3 도구 오류 — 원장 V-8ef5d88b SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getProgressS) |
| WK-SCP0108-0128 | B3 | cboVersion / Plan Month / Version / Ver. | 하네스·환경 | B3 도구 오류 — 원장 V-3e957087 SEARCH / 원장 V-ef9284b6 SEARCH |  | 3 (ACT:SCP0108_CAPA_LOB_Report.getVersion A) |
| WK-SCP0108-0129 | B3 | cboVersionSeq / Version / Version Seq /  | 하네스·환경 | B3 도구 오류 — 원장 V-ef9284b6 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getVersionSe) |
| WK-SCP0108-0130 | B3 | clbElectrodeType / Line Type / Electrode | 하네스·환경 | B3 도구 오류 — 원장 V-4edd9468 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getElectrode) |
| WK-SCP0108-0131 | B3 | clbFactory / Building / Factory | 하네스·환경 | B3 도구 오류 — 원장 V-94646c85 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getFactory A) |
| WK-SCP0108-0132 | B3 | clbLine / Line | 하네스·환경 | B3 도구 오류 — 원장 V-7bb91b1e SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getLine ACT:) |
| WK-SCP0108-0133 | B3 | clbOperation / Operation | 하네스·환경 | B3 도구 오류 — 원장 V-f818d013 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getOperation) |
| WK-SCP0108-0134 | B3 | clbPlant / Plant | 하네스·환경 | B3 도구 오류 — 원장 V-b4c14489 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getPlant ACT) |
| WK-SCP0108-0135 | B3 | clbSite / Site | 하네스·환경 | B3 도구 오류 — 원장 V-ac7a95a5 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getSite ACT:) |
| WK-SCP0108-0136 | B3 | rgrpDivisionType / Division Type / Opera | 하네스·환경 | B3 도구 오류 — 원장 V-7d230606 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getDivisionT) |
| WK-SCP0108-0137 | B4 | SCP0108_CAPA_LOB_Report.GetSpdTitle | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.GetSpdTitle 의 B4 23요소: ERROR:11 · NA:10 · NOPATH:1 · PASS:1 |  | 7 (ACT:SCP0108_CAPA_LOB_Report.GetSpdTitle:) |
| WK-SCP0108-0138 | B4 | SCP0108_CAPA_LOB_Report.getBottleneck | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getBottleneck 의 B4 1요소: ERROR:1 |  | 3 (ACT:SCP0108_CAPA_LOB_Report.getBottlenec) |
| WK-SCP0108-0139 | B4 | SCP0108_CAPA_LOB_Report.getDivisionType | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getDivisionType 의 B4 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getDivisionT) |
| WK-SCP0108-0140 | B4 | SCP0108_CAPA_LOB_Report.getElectrodeType | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getElectrodeType 의 B4 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getElectrode) |
| WK-SCP0108-0141 | B4 | SCP0108_CAPA_LOB_Report.getFactory | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getFactory 의 B4 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getFactory:4) |
| WK-SCP0108-0142 | B4 | SCP0108_CAPA_LOB_Report.getLine | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getLine 의 B4 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getLine:492:) |
| WK-SCP0108-0143 | B4 | SCP0108_CAPA_LOB_Report.getOperation | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getOperation 의 B4 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getOperation) |
| WK-SCP0108-0144 | B4 | SCP0108_CAPA_LOB_Report.getPlanType | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getPlanType 의 B4 23요소: ERROR:11 · NA:10 · NOPATH:1 · PASS:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.getPlanType:) |
| WK-SCP0108-0145 | B4 | SCP0108_CAPA_LOB_Report.getPlant | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getPlant 의 B4 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getPlant:444) |
| WK-SCP0108-0146 | B4 | SCP0108_CAPA_LOB_Report.getProgressStatu | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getProgressStatus 의 B4 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getProgressS) |
| WK-SCP0108-0147 | B4 | SCP0108_CAPA_LOB_Report.getShopGroup | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getShopGroup 의 B4 23요소: ERROR:11 · NA:10 · NOPATH:1 · PASS:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.getShopGroup) |
| WK-SCP0108-0148 | B4 | SCP0108_CAPA_LOB_Report.getSite | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getSite 의 B4 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getSite:406:) |
| WK-SCP0108-0149 | B4 | SCP0108_CAPA_LOB_Report.getVersion | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getVersion 의 B4 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getVersion:2) |
| WK-SCP0108-0150 | B4 | SCP0108_CAPA_LOB_Report.getVersionSeq | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getVersionSeq 의 B4 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getVersionSe) |
| WK-SCP0108-0151 | B4 | cboBottleneck / Bottleneck | 하네스·환경 | B4 도구 오류 — 원장 V-d15a8ae3 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getBottlenec) |
| WK-SCP0108-0152 | B4 | cboProgressStatus / Status / Progress St | 하네스·환경 | B4 도구 오류 — 원장 V-676cf47a SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getProgressS) |
| WK-SCP0108-0153 | B4 | cboVersion / Plan Month / Version / Ver. | 하네스·환경 | B4 도구 오류 — 원장 V-dc9d0fc7 SEARCH / 원장 V-9be617a4 SEARCH |  | 3 (ACT:SCP0108_CAPA_LOB_Report.getVersion A) |
| WK-SCP0108-0154 | B4 | cboVersionSeq / Version / Version Seq /  | 하네스·환경 | B4 도구 오류 — 원장 V-9be617a4 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getVersionSe) |
| WK-SCP0108-0155 | B4 | clbElectrodeType / Line Type / Electrode | 하네스·환경 | B4 도구 오류 — 원장 V-20e1e0b7 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getElectrode) |
| WK-SCP0108-0156 | B4 | clbFactory / Building / Factory | 하네스·환경 | B4 도구 오류 — 원장 V-9384d55d SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getFactory A) |
| WK-SCP0108-0157 | B4 | clbLine / Line | 하네스·환경 | B4 도구 오류 — 원장 V-eef5fa21 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getLine ACT:) |
| WK-SCP0108-0158 | B4 | clbOperation / Operation | 하네스·환경 | B4 도구 오류 — 원장 V-f498dfc0 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getOperation) |
| WK-SCP0108-0159 | B4 | clbPlant / Plant | 하네스·환경 | B4 도구 오류 — 원장 V-e342d04d SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getPlant ACT) |
| WK-SCP0108-0160 | B4 | clbSite / Site | 하네스·환경 | B4 도구 오류 — 원장 V-5f522f72 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getSite ACT:) |
| WK-SCP0108-0161 | B4 | rgrpDivisionType / Division Type / Opera | 하네스·환경 | B4 도구 오류 — 원장 V-22dbe59c SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getDivisionT) |
| WK-SCP0108-0162 | G3 | SCP0108 화면 | 하네스·환경 | G3 도구 오류 — 원장 V-2e6d069c RULE_SCREEN / 원장 V-9e9250fc GENERAL / 원장 V-8938a3a7 GENERAL / 원장 V-6920e13a GENERAL / 원장 V-21bd1dfc CONFI |  | 1 (`components/CapaLobReportForm.tsx`) |
| WK-SCP0108-0163 | F6 | SCP0108 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-07b3c280 RULE_SCREEN / 원장 V-1900776b RULE_SCREEN / 원장 V-c7365d8a GENERAL / 원장 V-28a2308e GENERAL / 원장 V-2a9b5eca G |  | 1 (`useProcMutation`/`useSaveWithValidation) |
| WK-SCP0108-0164 | F4 | PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE | 하네스·환경 | F4 도구 오류 — 실측[T-ee8a699a]: PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE: SCP0104/spreadTitle/SEARCH, SCP0105/spreadTitle/SEARCH, SCP0106 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.GetSpdTitle:) |
| WK-SCP0108-0165 | F4 | SCP0108_CAPA_LOB_Report.FindButton | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.FindButton 의 F4 1요소: ERROR:1 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.FindButton A) |
| WK-SCP0108-0166 | F4 | SCP0108_CAPA_LOB_Report.FindData | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.FindData 의 F4 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.FindData ACT) |
| WK-SCP0108-0167 | F4 | SCP0108_CAPA_LOB_Report.FindDataMain | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.FindDataMain 의 F4 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.FindDataMain) |
| WK-SCP0108-0168 | F4 | `CapaLobReport.tsx` | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 `CapaLobReport.tsx` '`Form_Load`(cs:965~976) · `FindButton`(cs:1267~128' 의 F4 1요소: ERROR:1 |  | 1 (`CapaLobReport.tsx`) |
| WK-SCP0108-0169 | F4 | `hooks/useCapaLobReportConditionEffects. | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 `hooks/useCapaLobReportConditionEffects.ts` '`BeforeFindData`(cs:1312~1319) · `GetSpdTitle`(cs:' 의 F4 1요소: E |  | 1 (`hooks/useCapaLobReportConditionEffects.) |
| WK-SCP0108-0170 | F4 | `useProcMutation`/`useSaveWithValidation | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 `useProcMutation`/`useSaveWithValidation`/`EditTracker`/`CRU '자매 전 화면 구현' 의 F4 1요소: ERROR:1 |  | 1 (`useProcMutation`/`useSaveWithValidation) |
| WK-SCP0108-0171 | A5 | (3) **시트 잠금** | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 (3) **시트 잠금** '`BaseForm:3302~3340`(`CheckValidation`)' 의 A5 1요소: ERROR:1 |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0172 | A5 | ELTR_LN_TP_CD / Line Type | 하네스·환경 | A5 도구 오류 — 실측[T-897e3a15]: ELTR_LN_TP_CD: [측정 경로 없음] AS-IS 시트 CURRENT/CUTOFF/MAIN 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 2 (G1 `frozenColumns={1}` 하드코딩) |
| WK-SCP0108-0173 | A5 | G2 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 G2 '`_si.Delete()` (신규행 한정)' 의 A5 1요소: ERROR:1 |  | 1 (G2) |
| WK-SCP0108-0174 | A5 | G3 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 G3 '`SetRowFormat(r,c,1,"###,##0.0","",false,columnCol' 의 A5 1요소: ERROR:1 |  | 1 (G3) |
| WK-SCP0108-0175 | A5 | G4 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 G4 '`_si.Query(ds)` + `ds.Tables[1].Copy()`' 의 A5 1요소: ERROR:1 |  | 1 (G4) |
| WK-SCP0108-0176 | A5 | G5 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 G5 '`_si.LockColumn(0, GetMaxColumnIndex(), true)`' 의 A5 1요소: ERROR:1 |  | 1 (G5) |
| WK-SCP0108-0177 | A5 | G6 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 G6 '`SetSheetMerge()` → `RightColMerge2()` (3경로: cs:12' 의 A5 1요소: ERROR:1 |  | 1 (G6) |
| WK-SCP0108-0178 | A5 | SCP0108_CAPA_LOB_Report.CreateSpread | 하네스·환경 | A5 도구 오류 — 실측[T-f74d5e17]: AS-IS 기본 표시 컬럼 3 ⊆ TO-BE 그리드 0: 누락 COMPANY_ID, DIVISION_ID, DV (AS-IS 숨김·코드추가 helper 컬럼은 비교 제외: ELTR_LN |  | 4 (ACT:SCP0108_CAPA_LOB_Report.CreateSpread) |
| WK-SCP0108-0179 | A5 | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현 'cs:1131. 소비처는 `SetFilterALLCancel` **한 곳뿐**(`BaseF' 의 A5  |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0180 | A5 | `capa-lob-report.constants.ts` | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 `capa-lob-report.constants.ts` '`SpdSheet`·`DateColumns`·`ProgressStatusType`(CAPA' 의 A5 1요소: ERROR:1 |  | 1 (`capa-lob-report.constants.ts`) |
| WK-SCP0108-0181 | A5 | `hooks/useCapaLobReportConditionEffects. | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 `hooks/useCapaLobReportConditionEffects.ts` '`BeforeFindData`(cs:1312~1319) · `GetSpdTitle`(cs:' 의 A5 1요소: E |  | 1 (`hooks/useCapaLobReportConditionEffects.) |
| WK-SCP0108-0182 | A5 | spCalls | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 spCalls '3' 의 A5 1요소: ERROR:1 |  | 1 (spCalls) |
| WK-SCP0108-0183 | A5 | 시트 탭 UI(`TabWrapper`/`TabPanel`) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 시트 탭 UI(`TabWrapper`/`TabPanel`) '`TabStripPolicy.Never`(cs:1197)' 의 A5 1요소: ERROR:1 |  | 1 (시트 탭 UI(`TabWrapper`/`TabPanel`)) |
| WK-SCP0108-0184 | H2 | (2) **버튼 ACL** | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 (2) **버튼 ACL** '`BaseForm:3023~3032`(Select) · `3171~3231`(C/U/D)' 의 H2 1요소: ERROR:1 |  | 1 ((2) **버튼 ACL**) |
| WK-SCP0108-0185 | H2 | (3) **시트 잠금** | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 (3) **시트 잠금** '`BaseForm:3302~3340`(`CheckValidation`)' 의 H2 1요소: ERROR:1 |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0186 | H2 | ELTR_LN_TP_CD / Line Type | 하네스·환경 | H2 도구 오류 — 원장 V-a12d903f COLUMN / 원장 V-c768cca5 COLUMN / 실측[T-6417257d]: ELTR_LN_TP_CD 현재 그리드에 없음 |  | 2 (G1 `frozenColumns={1}` 하드코딩) |
| WK-SCP0108-0187 | H2 | G2 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 G2 '`_si.Delete()` (신규행 한정)' 의 H2 1요소: ERROR:1 |  | 1 (G2) |
| WK-SCP0108-0188 | H2 | G3 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 G3 '`SetRowFormat(r,c,1,"###,##0.0","",false,columnCol' 의 H2 1요소: ERROR:1 |  | 1 (G3) |
| WK-SCP0108-0189 | H2 | G4 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 G4 '`_si.Query(ds)` + `ds.Tables[1].Copy()`' 의 H2 1요소: ERROR:1 |  | 1 (G4) |
| WK-SCP0108-0190 | H2 | G5 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 G5 '`_si.LockColumn(0, GetMaxColumnIndex(), true)`' 의 H2 1요소: ERROR:1 |  | 1 (G5) |
| WK-SCP0108-0191 | H2 | G6 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 G6 '`SetSheetMerge()` → `RightColMerge2()` (3경로: cs:12' 의 H2 1요소: ERROR:1 |  | 1 (G6) |
| WK-SCP0108-0192 | H2 | SCP0108_CAPA_LOB_Report.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.CreateSpread 의 H2 1요소: ERROR:1 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.CreateSpread) |
| WK-SCP0108-0193 | H2 | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현 'cs:1131. 소비처는 `SetFilterALLCancel` **한 곳뿐**(`BaseF' 의 H2  |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0194 | H2 | `capa-lob-report.constants.ts` | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 `capa-lob-report.constants.ts` '`SpdSheet`·`DateColumns`·`ProgressStatusType`(CAPA' 의 H2 1요소: ERROR:1 |  | 1 (`capa-lob-report.constants.ts`) |
| WK-SCP0108-0195 | H2 | `components/CapaLobReportGrid.tsx` | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 `components/CapaLobReportGrid.tsx` '`spdMain` + `RefreshDateColumnStatus`(cs:1351~1396' 의 H2 1요소: ERROR:1 |  | 1 (`components/CapaLobReportGrid.tsx`) |
| WK-SCP0108-0196 | H2 | `hooks/useCapaLobReportConditionEffects. | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 `hooks/useCapaLobReportConditionEffects.ts` '`BeforeFindData`(cs:1312~1319) · `GetSpdTitle`(cs:' 의 H2 1요소: E |  | 1 (`hooks/useCapaLobReportConditionEffects.) |
| WK-SCP0108-0197 | H2 | `spdMain_TopChange` 스크롤 핸들러 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 `spdMain_TopChange` 스크롤 핸들러 'cs:1252~1259' 의 H2 1요소: ERROR:1 |  | 1 (`spdMain_TopChange` 스크롤 핸들러) |
| WK-SCP0108-0198 | H2 | events | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 events '12' 의 H2 1요소: ERROR:1 |  | 1 (events) |
| WK-SCP0108-0199 | H2 | gridSignals | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 gridSignals '6' 의 H2 1요소: ERROR:1 |  | 1 (gridSignals) |
| WK-SCP0108-0200 | H2 | spCalls | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 spCalls '3' 의 H2 1요소: ERROR:1 |  | 1 (spCalls) |
| WK-SCP0108-0201 | H2 | 시트 탭 UI(`TabWrapper`/`TabPanel`) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 시트 탭 UI(`TabWrapper`/`TabPanel`) '`TabStripPolicy.Never`(cs:1197)' 의 H2 1요소: ERROR:1 |  | 1 (시트 탭 UI(`TabWrapper`/`TabPanel`)) |
| WK-SCP0108-0202 | H4 | SCP0108 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-1926b008 RULE_SCREEN / 원장 V-3d7c4f8c RULE_SCREEN / 원장 V-ad31d7bb RULE_SCREEN / 원장 V-393037d5 RULE_SCREEN / 원장 V-7f |  | 6 (events `spdMain_TopChange` 스크롤 핸들러 ACT:S) |
| WK-SCP0108-0203 | H5 | (3) **시트 잠금** | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 (3) **시트 잠금** '`BaseForm:3302~3340`(`CheckValidation`)' 의 H5 1요소: ERROR:1 |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0204 | H5 | ELTR_LN_TP_CD / Line Type | 하네스·환경 | H5 도구 오류 — 실측[T-3eb7bd27]: ELTR_LN_TP_CD 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (G1 `frozenColumns={1}` 하드코딩) |
| WK-SCP0108-0205 | H5 | G2 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 G2 '`_si.Delete()` (신규행 한정)' 의 H5 1요소: ERROR:1 |  | 1 (G2) |
| WK-SCP0108-0206 | H5 | G3 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 G3 '`SetRowFormat(r,c,1,"###,##0.0","",false,columnCol' 의 H5 1요소: ERROR:1 |  | 1 (G3) |
| WK-SCP0108-0207 | H5 | G4 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 G4 '`_si.Query(ds)` + `ds.Tables[1].Copy()`' 의 H5 1요소: ERROR:1 |  | 1 (G4) |
| WK-SCP0108-0208 | H5 | G5 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 G5 '`_si.LockColumn(0, GetMaxColumnIndex(), true)`' 의 H5 1요소: ERROR:1 |  | 1 (G5) |
| WK-SCP0108-0209 | H5 | G6 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 G6 '`SetSheetMerge()` → `RightColMerge2()` (3경로: cs:12' 의 H5 1요소: ERROR:1 |  | 1 (G6) |
| WK-SCP0108-0210 | H5 | SCP0108_CAPA_LOB_Report.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.CreateSpread 의 H5 1요소: ERROR:1 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.CreateSpread) |
| WK-SCP0108-0211 | H5 | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현 'cs:1131. 소비처는 `SetFilterALLCancel` **한 곳뿐**(`BaseF' 의 H5  |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0212 | H5 | `capa-lob-report.constants.ts` | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 `capa-lob-report.constants.ts` '`SpdSheet`·`DateColumns`·`ProgressStatusType`(CAPA' 의 H5 1요소: ERROR:1 |  | 1 (`capa-lob-report.constants.ts`) |
| WK-SCP0108-0213 | H5 | `hooks/useCapaLobReportConditionEffects. | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 `hooks/useCapaLobReportConditionEffects.ts` '`BeforeFindData`(cs:1312~1319) · `GetSpdTitle`(cs:' 의 H5 1요소: E |  | 1 (`hooks/useCapaLobReportConditionEffects.) |
| WK-SCP0108-0214 | H5 | spCalls | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 spCalls '3' 의 H5 1요소: ERROR:1 |  | 1 (spCalls) |
| WK-SCP0108-0215 | H5 | 시트 탭 UI(`TabWrapper`/`TabPanel`) | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 시트 탭 UI(`TabWrapper`/`TabPanel`) '`TabStripPolicy.Never`(cs:1197)' 의 H5 1요소: ERROR:1 |  | 1 (시트 탭 UI(`TabWrapper`/`TabPanel`)) |
| WK-SCP0108-0216 | D1 | (3) **시트 잠금** | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 (3) **시트 잠금** '`BaseForm:3302~3340`(`CheckValidation`)' 의 D1 1요소: ERROR:1 |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0217 | D1 | Edit 버튼(`customButtons`) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 Edit 버튼(`customButtons`) '`EditButton` override 0건 → 베이스 빈 구현' 의 D1 1요소: ERROR:1 |  | 1 (Edit 버튼(`customButtons`)) |
| WK-SCP0108-0218 | D1 | G5 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 G5 '`_si.LockColumn(0, GetMaxColumnIndex(), true)`' 의 D1 1요소: ERROR:1 |  | 1 (G5) |
| WK-SCP0108-0219 | D1 | _si.LockColumn | 하네스·환경 | D1 도구 오류 — 원장 V-03468942 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.AfterFindDat) |
| WK-SCP0108-0220 | D1 | `LockColumn` 컬럼명 상수 배열 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 `LockColumn` 컬럼명 상수 배열 'cs:1406' 의 D1 1요소: ERROR:1 |  | 1 (`LockColumn` 컬럼명 상수 배열) |
| WK-SCP0108-0221 | D1 | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현 'cs:1131. 소비처는 `SetFilterALLCancel` **한 곳뿐**(`BaseF' 의 D1  |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0222 | D1 | `isEditMode` state | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 `isEditMode` state '01 L-33. `IsEditMode` true 세팅 경로 0건' 의 D1 1요소: ERROR:1 |  | 1 (`isEditMode` state) |
| WK-SCP0108-0223 | D1 | gridSignals | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 gridSignals '6' 의 D1 1요소: ERROR:1 |  | 1 (gridSignals) |
| WK-SCP0108-0224 | D6 | SCP0108 화면 | 하네스·환경 | D6 도구 오류 — 원장 V-679f3896 RULE_SCREEN / 원장 V-e81ce84d RULE_SCREEN / 원장 V-a97a7393 RULE_SCREEN / 원장 V-edd3b04a GENERAL / 원장 V-f76669 |  | 9 (entryPoints `CapaLobReport.tsx` (1) **Di) |
| WK-SCP0108-0225 | E4 | MSG00423 | 하네스·환경 | E4 도구 오류 — 실측[T-94a8b9c6]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (validations ACT:SCP0108_CAPA_LOB_Report.) |
| WK-SCP0108-0226 | A10 | SCP0108 화면 | 하네스·환경 | A10 도구 오류 — 원장 V-98102a79 RULE_SCREEN / 원장 V-cb3fd2bc GENERAL / 실측[T-e002c9bb]: 화면 진입 직후(조회 전) 그리드 -1행 · 진입 시 호출 없음 — 기대 빈 그리드·조회  |  | 46 (ACT:SCP0108_CAPA_LOB_Report.Form_Load AC) |
| WK-SCP0108-0227 | A6 | SCP0108_CAPA_LOB_Report.FindButton | 하네스·환경 | A6 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.FindButton 의 A6 4요소: ERROR:4 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.FindButton A) |
| WK-SCP0108-0228 | A6 | SCP0108_CAPA_LOB_Report.FindData | 하네스·환경 | A6 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.FindData 의 A6 4요소: ERROR:4 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.FindData ACT) |
| WK-SCP0108-0229 | A6 | SCP0108_CAPA_LOB_Report.FindDataMain | 하네스·환경 | A6 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.FindDataMain 의 A6 4요소: ERROR:4 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.FindDataMain) |
| WK-SCP0108-0230 | A6 | `CapaLobReport.tsx` | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 `CapaLobReport.tsx` '`Form_Load`(cs:965~976) · `FindButton`(cs:1267~128' 의 A6 4요소: ERROR:4 |  | 1 (`CapaLobReport.tsx`) |
| WK-SCP0108-0231 | A6 | `hooks/useCapaLobReportConditionEffects. | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 `hooks/useCapaLobReportConditionEffects.ts` '`BeforeFindData`(cs:1312~1319) · `GetSpdTitle`(cs:' 의 A6 4요소: E |  | 1 (`hooks/useCapaLobReportConditionEffects.) |
| WK-SCP0108-0232 | A6 | dtElectrode = DBUtils.Sort(dtElectrode,  | 하네스·환경 | A6 도구 오류 — 원장 V-1e5741f0 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshElect) |
| WK-SCP0108-0233 | A6 | dtElectrodeAll = DBUtils.Sort(dtElectrod | 하네스·환경 | A6 도구 오류 — 원장 V-8772d41d |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshElect) |
| WK-SCP0108-0234 | A6 | dtOperation = DBUtils.Sort(dtOperation,  | 하네스·환경 | A6 도구 오류 — 원장 V-7c8d8319 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshOpera) |
| WK-SCP0108-0235 | A6 | dtOperationAll = DBUtils.Sort(dtOperatio | 하네스·환경 | A6 도구 오류 — 원장 V-3320f2bc |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshOpera) |
| WK-SCP0108-0236 | G1 | (1) **Division 권한 0건** | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 (1) **Division 권한 0건** '`cs:1133~1134` → `BaseForm:5269~5277`' 의 G1 3요소: ERROR:3 |  | 1 ((1) **Division 권한 0건**) |
| WK-SCP0108-0237 | G1 | 1 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 1 'Site/Plant/Building/Line 변경 시 Line Type **후보 목록** ' 의 G1 3요소: ERROR:3 |  | 0 () |
| WK-SCP0108-0238 | G1 | 6 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 6 'AS-IS 는 콤보 조회 실패와 Division 권한 0건을 구분하지 않는다(동기 로드라 ' 의 G1 3요소: ERROR:3 |  | 1 (6) |
| WK-SCP0108-0239 | G1 | 7 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 7 'AS-IS 는 컬럼 메타 조회 실패를 별도로 알리지 않는다' 의 G1 3요소: ERROR:3 |  | 1 (7) |
| WK-SCP0108-0240 | G1 | ADMIN | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 ADMIN 'True' 의 G1 3요소: ERROR:3 |  | 1 (ADMIN) |
| WK-SCP0108-0241 | G1 | AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패) 'cs:291~312' 의 G1 3요소: ERROR:3 |  | 1 (AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패)) |
| WK-SCP0108-0242 | G1 | FP Planner | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FP Planner 'True' 의 G1 3요소: ERROR:3 |  | 1 (FP Planner) |
| WK-SCP0108-0243 | G1 | FP Viewer | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FP Viewer 'True' 의 G1 3요소: ERROR:3 |  | 1 (FP Viewer) |
| WK-SCP0108-0244 | G1 | MSG00423 | 하네스·환경 | G1 도구 오류 — 원장 V-1f89d394 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.FindButton:1) |
| WK-SCP0108-0245 | G1 | SCM PI Admin | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SCM PI Admin 'True' 의 G1 3요소: ERROR:3 |  | 1 (SCM PI Admin) |
| WK-SCP0108-0246 | G1 | SCM Viewer | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SCM Viewer 'True' 의 G1 3요소: ERROR:3 |  | 1 (SCM Viewer) |
| WK-SCP0108-0247 | G1 | SCP Planner | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SCP Planner 'True' 의 G1 3요소: ERROR:3 |  | 1 (SCP Planner) |
| WK-SCP0108-0248 | G1 | SCP0108_CAPA_LOB_Report.FindButton | 하네스·환경 | G1 도구 오류 — 원장 V-1f89d394 ASIS |  | 4 (ACT:SCP0108_CAPA_LOB_Report.FindButton:1) |
| WK-SCP0108-0249 | G1 | SCP0108_CAPA_LOB_Report.FindData | 하네스·환경 | G1 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.FindData 의 G1 3요소: ERROR:3 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.FindData:148) |
| WK-SCP0108-0250 | G1 | SCP0108_CAPA_LOB_Report.FindDataMain | 하네스·환경 | G1 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.FindDataMain 의 G1 3요소: ERROR:3 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.FindDataMain) |
| WK-SCP0108-0251 | G1 | `CapaLobReport.tsx` | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 `CapaLobReport.tsx` '`Form_Load`(cs:965~976) · `FindButton`(cs:1267~128' 의 G1 3요소: ERROR:3 |  | 1 (`CapaLobReport.tsx`) |
| WK-SCP0108-0252 | G1 | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현 'cs:1131. 소비처는 `SetFilterALLCancel` **한 곳뿐**(`BaseF' 의 G1  |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0253 | G1 | `capa-lob-report.types.ts` | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 `capa-lob-report.types.ts` 'GET SP 반환 형상(03 §4.2/§4.4)' 의 G1 3요소: ERROR:3 |  | 1 (`capa-lob-report.types.ts`) |
| WK-SCP0108-0254 | G1 | `components/CapaLobReportForm.tsx` | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 `components/CapaLobReportForm.tsx` '`usrConditionPanel1`(dsn:133~141) + LayoutControlI' 의 G1 3요소: ERROR:3 |  | 1 (`components/CapaLobReportForm.tsx`) |
| WK-SCP0108-0255 | G1 | clbLine / Line | 하네스·환경 | G1 도구 오류 — 원장 V-a1dd972f SEARCH / E2E smoke cond CustomDropdown |  | 1 (2) |
| WK-SCP0108-0256 | G1 | clbSite / Site | 하네스·환경 | G1 도구 오류 — 원장 V-1ed1cd54 SEARCH / E2E smoke cond CustomDropdown |  | 1 (2) |
| WK-SCP0108-0257 | G1 | entryPoints | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 entryPoints '15' 의 G1 3요소: ERROR:3 |  | 1 (entryPoints) |
| WK-SCP0108-0258 | G1 | validations | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 validations '1' 의 G1 3요소: ERROR:3 |  | 1 (validations) |
| WK-SCP0108-0259 | G1 | 필수 조회조건 UI(`*`) · Search 전 alert | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 필수 조회조건 UI(`*`) · Search 전 alert '`DataUtil.InitCheck`(DataUtil:370~622) 전문 read' 의 G1 3요소: ERROR:3 |  | 1 (필수 조회조건 UI(`*`) · Search 전 alert) |
| WK-SCP0108-0260 | X-ROW | SCP0108_CAPA_LOB_Report.AfterFindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOPATH:1 · ERROR:1 |  | 10 (ACT:SCP0108_CAPA_LOB_Report.AfterFindDat) |
| WK-SCP0108-0261 | X-ROW | SCP0108_CAPA_LOB_Report.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · ERROR:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.CreateSpread) |
| WK-SCP0108-0262 | X-ROW | SCP0108_CAPA_LOB_Report.FindButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:3 · NOT_RUN:2 · NOPATH:1 · NA:1 · PASS:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.FindButton A) |
| WK-SCP0108-0263 | X-ROW | SCP0108_CAPA_LOB_Report.GetSpdTitle | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOPATH:2 · PASS:2 · ERROR:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.GetSpdTitle) |
| WK-SCP0108-0264 | X-ROW | SCP0108_CAPA_LOB_Report.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitControls) |
| WK-SCP0108-0265 | X-ROW | SCP0108_CAPA_LOB_Report.InitDatasAll | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.InitDatasAll) |
| WK-SCP0108-0266 | X-ROW | SCP0108_CAPA_LOB_Report.InitQueryDics | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.InitQueryDic) |
| WK-SCP0108-0267 | X-ROW | SCP0108_CAPA_LOB_Report.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.InitSpread) |
| WK-SCP0108-0268 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshElectrode | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:1 · PASS:1 |  | 7 (ACT:SCP0108_CAPA_LOB_Report.RefreshElect) |
| WK-SCP0108-0269 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshElectrode | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshElect) |
| WK-SCP0108-0270 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshOperation | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshOpera) |
| WK-SCP0108-0271 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshSite | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshSite ) |
| WK-SCP0108-0272 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshVersion | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshVersi) |
| WK-SCP0108-0273 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshVersionSe | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · ERROR:1 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshVersi) |
| WK-SCP0108-0274 | X-ROW | SCP0108_CAPA_LOB_Report.SetQueryInfoGet | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0108_CAPA_LOB_Report.SetQueryInfo) |
| WK-SCP0108-0275 | X-ROW | SCP0108_CAPA_LOB_Report.SetSheetMerge | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.SetSheetMerg) |
| WK-SCP0108-0276 | X-ROW | SCP0108_CAPA_LOB_Report.SetVisibleElectr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0108_CAPA_LOB_Report.SetVisibleEl) |
| WK-SCP0108-0277 | X-ROW | SCP0108_CAPA_LOB_Report.SetVisibleOperat | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0108_CAPA_LOB_Report.SetVisibleOp) |
| WK-SCP0108-0278 | X-ROW | SCP0108_CAPA_LOB_Report.SetVisibleSheetC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.SetVisibleSh) |
| WK-SCP0108-0279 | X-ROW | SCP0108_CAPA_LOB_Report.ShowItem | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:5 |  | 9 (ACT:SCP0108_CAPA_LOB_Report.ShowItem ACT) |
| WK-SCP0108-0280 | X-ROW | SCP0108_CAPA_LOB_Report.cboDivision_Sele | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.cboDivision_) |
| WK-SCP0108-0281 | X-ROW | SCP0108_CAPA_LOB_Report.cboVersionSeq_Se | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.cboVersionSe) |
| WK-SCP0108-0282 | X-ROW | SCP0108_CAPA_LOB_Report.cboVersion_Selec | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.cboVersion_S) |
| WK-SCP0108-0283 | X-ROW | SCP0108_CAPA_LOB_Report.clbFactory_Selec | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbFactory_S) |
| WK-SCP0108-0284 | X-ROW | SCP0108_CAPA_LOB_Report.clbLine_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbLine_Sele) |
| WK-SCP0108-0285 | X-ROW | SCP0108_CAPA_LOB_Report.clbOperation_Sel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbOperation) |
| WK-SCP0108-0286 | X-ROW | SCP0108_CAPA_LOB_Report.clbPlant_Selecte | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbPlant_Sel) |
| WK-SCP0108-0287 | X-ROW | SCP0108_CAPA_LOB_Report.clbSite_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbSite_Sele) |
| WK-SCP0108-0288 | X-ROW | SCP0108_CAPA_LOB_Report.rgrpDivisionType | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.rgrpDivision) |
| WK-SCP0108-0289 | X-ROW | SCP0108_CAPA_LOB_Report.spdMain_TopChang | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.spdMain_TopC) |
| WK-SCP0108-0290 | G5 | `components/modals/CapaLobReportItemPopu | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 `components/modals/CapaLobReportItemPopup.tsx` '`ShowItem`(cs:1580~1602) → `SCM0002_CAPAItemPopup`' 의 G5 7요소 |  | 1 (`components/modals/CapaLobReportItemPopu) |
| WK-SCP0108-0291 | G5 | entryPoints | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 entryPoints '15' 의 G5 7요소: ERROR:3 · PASS:2 · NOPATH:1 · NA:1 |  | 1 (entryPoints) |
| WK-SCP0108-0292 | G5 | new SCM0002_CAPAItemPopup() | 하네스·환경 | G5 도구 오류 — 원장 V-24ab266b |  | 1 (ACT:SCP0108_CAPA_LOB_Report.ShowItem:158) |
| WK-SCP0108-0293 | G5 | pop.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-512e6195 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.ShowItem:159) |
| WK-SCP0108-0294 | G5 | popups | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 popups '2' 의 G5 7요소: ERROR:3 · PASS:2 · NOPATH:1 · NA:1 |  | 1 (popups) |
| WK-SCP0108-0295 | G5 | txtItem / Basic Nickname / Item | 하네스·환경 | G5 도구 오류 — 원장 V-f44047fb SEARCH |  | 0 () |
| WK-SCP0108-0296 | H6 | `components/modals/CapaLobReportItemPopu | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 `components/modals/CapaLobReportItemPopup.tsx` '`ShowItem`(cs:1580~1602) → `SCM0002_CAPAItemPopup`' 의 H6 7요소 |  | 1 (`components/modals/CapaLobReportItemPopu) |
| WK-SCP0108-0297 | H6 | btnColumn | 하네스·환경 | H6 도구 오류 — 원장 V-97fa0a50 ASIS / 원장 V-dd9b33ea ASIS |  | 1 (`components/modals/CapaLobReportColumnMo) |
| WK-SCP0108-0298 | H6 | entryPoints | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 entryPoints '15' 의 H6 7요소: ERROR:5 · NOT_RUN:1 · NOPATH:1 |  | 1 (entryPoints) |
| WK-SCP0108-0299 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-dd9b33ea |  | 1 (ACT:SCP0108_CAPA_LOB_Report.btnColumn_Cl) |
| WK-SCP0108-0300 | H6 | new SCM0002_CAPAItemPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-5f9eb5f4 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.ShowItem:158) |
| WK-SCP0108-0301 | H6 | new SCM002_CAPAColumnPopup("SCP0108", th | 하네스·환경 | H6 도구 오류 — 원장 V-97fa0a50 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.btnColumn_Cl) |
| WK-SCP0108-0302 | H6 | pop.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-40fcff99 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.ShowItem:159) |
| WK-SCP0108-0303 | H6 | popups | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 popups '2' 의 H6 7요소: ERROR:5 · NOT_RUN:1 · NOPATH:1 |  | 1 (popups) |
| WK-SCP0108-0304 | M3 | new SCM0002_CAPAItemPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-61400640 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.ShowItem:158) |
| WK-SCP0108-0305 | M3 | new SCM002_CAPAColumnPopup("SCP0108", th | 하네스·환경 | M3 도구 오류 — 원장 V-7d095d23 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.btnColumn_Cl) |
| WK-SCP0108-0306 | M4 | `components/modals/CapaLobReportItemPopu | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 `components/modals/CapaLobReportItemPopup.tsx` '`ShowItem`(cs:1580~1602) → `SCM0002_CAPAItemPopup`' 의 M4 3요소 |  | 1 (`components/modals/CapaLobReportItemPopu) |
| WK-SCP0108-0307 | M4 | entryPoints | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 entryPoints '15' 의 M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (entryPoints) |
| WK-SCP0108-0308 | M4 | popups | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 popups '2' 의 M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (popups) |
