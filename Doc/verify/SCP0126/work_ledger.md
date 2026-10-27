# 작업 원장 — SCP0126 · 2026-10-26 12:55

> 검사 인스턴스 1062건 중 PASS·NA 204건 외 **858건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 2 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 79 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 4 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 38 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 243 | 실행 → PASS |
| W7 | 기대값 확정 | 489 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 2 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 482 · E2E 243 · 대조표 86 · 하네스 42 · FE 3 · 선행 W1 완료 후 E2E 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 5건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 157 | 1 |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 79 |  |  |  |  | 16 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 32 | 16 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A5 | DESIGN |  |  |  |  |  | 12 | 31 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 7 | 32 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 8 | 29 |  |  | 라벨 명칭 |
| D3 | EDIT |  |  |  |  |  | 18 | 16 |  |  | 행 값 기반 조건부 잠금 |
| C3 | CASCADE |  |  |  |  |  | 16 | 16 |  |  | 연쇄 자동 채움 |
| D1 | EDIT |  |  |  |  |  | 18 | 14 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| A1 | GEN |  |  |  |  |  |  | 29 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| F4 | DB |  |  |  |  |  | 22 | 5 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G1 | GEN |  |  |  |  |  | 8 | 16 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| D4 | EDIT |  |  |  |  |  | 7 | 15 | 1 |  | 신규행 기본값·자동세팅·Insert 전제 |
| G4 | DESIGN |  |  |  |  | 6 | 11 | 5 |  |  | 조회조건 표시·라벨·활성 |
| C2 | CASCADE |  |  |  |  |  | 11 | 10 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 7 | 10 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G6 | GEN |  |  |  |  |  | 11 | 5 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| E3 | EDIT |  |  |  |  |  |  | 16 |  |  | 필수 입력 검증 |
| B4 | COMBO |  |  |  |  | 7 |  | 8 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A6 | GEN |  |  |  |  |  | 10 | 5 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| D5 | EDIT |  |  |  |  |  | 6 | 5 |  |  | 셀 에디터 유형 |
| C1 | CASCADE |  |  |  |  |  | 7 | 3 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| B3 | COMBO |  |  |  | 4 |  |  | 5 |  |  | 콤보 후보 정렬 = AS-IS |
| M4 | POPUP |  |  |  |  |  | 7 | 2 |  |  | 팝업 선택값 반영 |
| G5 | POPUP |  |  |  |  | 6 |  | 2 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 4 | 2 | 2 |  |  | 팝업 표준·열림 |
| B1 | COMBO |  |  |  |  | 4 |  | 3 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 4 |  | 3 |  |  | 콤보 후보 중복 없음 |
| C4 | CASCADE |  |  |  |  |  | 4 | 3 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| X-REASON | DESIGN |  |  |  |  |  |  | 7 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| E1 | EDIT |  |  |  |  |  | 2 | 3 |  |  | 숫자 소수자리·정수·부호·범위 |
| M3 | POPUP |  |  |  |  |  | 5 |  |  |  | 팝업 내부 기능(조회·CRUD) |
| B6 | COMBO |  |  |  |  | 4 |  |  |  |  | ALL 옵션·다중선택 사양 |
| X-NOTIMPL | GEN | 2 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W1 기능 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0126-0001 | X-NOTIMPL | I-1 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — I-1 `SetChangedControl()`(cs:229)이 `_sActiveSheetName` 대입(cs:249)보다 앞 → **최초 로드 시 82 의 OSP 가 후보에 남는다**. 탭을 한 번 바꿔야  |  | 1 (I-1) |
| WK-SCP0126-0002 | X-NOTIMPL | I-2 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — I-2 `ChangeSheet()`(615)가 `InitEvent()` 이전이라 I-1 이 자동 교정되지 않는다 동상(I-1 에 흡수) I-1 에 흡수되는 동일 블로커 미구현 |  | 1 (I-2) |

## W2 구현 위치 확인 (79)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0126-0003 | X-LOC | BG-01 `fps == null`(Delete) · BG-02 `fps | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG-01 `fps == null`(Delete) · BG-02 `fps) |
| WK-SCP0126-0004 | X-LOC | BG-05 `fps == null`(Save) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG-05 `fps == null`(Save)) |
| WK-SCP0126-0005 | X-LOC | BG-06 `ActiveSheetIndex < 0` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG-06 `ActiveSheetIndex < 0`) |
| WK-SCP0126-0006 | X-LOC | BG-07 `_isFinding` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG-07 `_isFinding`) |
| WK-SCP0126-0007 | X-LOC | BG-08 `!IsLock` + MSG00129 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BG-08 `!IsLock` + MSG00129) |
| WK-SCP0126-0008 | X-LOC | C-03 `usrConditionPanel1` (`PanelType.Hi | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C-03 `usrConditionPanel1` (`PanelType.Hi) |
| WK-SCP0126-0009 | X-LOC | C-06·C-07 Division / `cboDivision` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C-06·C-07 Division / `cboDivision`) |
| WK-SCP0126-0010 | X-LOC | C-08·C-09 Plan Group / `cboPlanGroup` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C-08·C-09 Plan Group / `cboPlanGroup`) |
| WK-SCP0126-0011 | X-LOC | C-10·C-11 Period / `mrpPeriod` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C-10·C-11 Period / `mrpPeriod`) |
| WK-SCP0126-0012 | X-LOC | C-13·C-14 Plant / `clbPlant` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C-13·C-14 Plant / `clbPlant`) |
| WK-SCP0126-0013 | X-LOC | C-15·C-16 Line / `clbLine` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C-15·C-16 Line / `clbLine`) |
| WK-SCP0126-0014 | X-LOC | C-17·C-18 Nick Name / `txtNickName` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C-17·C-18 Nick Name / `txtNickName`) |
| WK-SCP0126-0015 | X-LOC | C-19·C-20 Model / `txtModel` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C-19·C-20 Model / `txtModel`) |
| WK-SCP0126-0016 | X-LOC | C-22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C-22) |
| WK-SCP0126-0017 | X-LOC | C-24 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C-24) |
| WK-SCP0126-0018 | X-LOC | C-26 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (C-26) |
| WK-SCP0126-0019 | X-LOC | CB-01 `BLUtils.GetDivision` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CB-01 `BLUtils.GetDivision`) |
| WK-SCP0126-0020 | X-LOC | CB-02~CB-06 `init` Tables[0..4] | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CB-02~CB-06 `init` Tables[0..4]) |
| WK-SCP0126-0021 | X-LOC | CB-07 `SCP0121` Tables[3] | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CB-07 `SCP0121` Tables[3]) |
| WK-SCP0126-0022 | X-LOC | CB-08 `dtType` 리터럴(cs:233-245) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CB-08 `dtType` 리터럴(cs:233-245)) |
| WK-SCP0126-0023 | X-LOC | CB-09 `dtFixCombo` 리터럴(cs:253-265) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CB-09 `dtFixCombo` 리터럴(cs:253-265)) |
| WK-SCP0126-0024 | X-LOC | E-01 `ClbDivision_SelectedIndexChanged`( | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E-01 `ClbDivision_SelectedIndexChanged`() |
| WK-SCP0126-0025 | X-LOC | E-02 `CboPlanGroup_SelectedIndexChanged` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E-02 `CboPlanGroup_SelectedIndexChanged`) |
| WK-SCP0126-0026 | X-LOC | E-03 `ClbPlant_SelectedIndexChanged`(cs: | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E-03 `ClbPlant_SelectedIndexChanged`(cs:) |
| WK-SCP0126-0027 | X-LOC | E-04 ExcelUpload Click (cs:3833-3839) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E-04 ExcelUpload Click (cs:3833-3839)) |
| WK-SCP0126-0028 | X-LOC | E-06 BatchSave Click (cs:3847-3859) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E-06 BatchSave Click (cs:3847-3859)) |
| WK-SCP0126-0029 | X-LOC | E-07 / EP-12 `ActiveSheetChanging` (cs:3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E-07 / EP-12 `ActiveSheetChanging` (cs:3) |
| WK-SCP0126-0030 | X-LOC | E-08 / EP-13 `ActiveSheetChanged` (cs:36 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (E-08 / EP-13 `ActiveSheetChanged` (cs:36) |
| WK-SCP0126-0031 | X-LOC | EP-01~EP-08 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EP-01~EP-08) |
| WK-SCP0126-0032 | X-LOC | F-01 PlanGroup `DIVISION_ID` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (F-01 PlanGroup `DIVISION_ID`) |
| WK-SCP0126-0033 | X-LOC | F-02·F-03 Plant EE_UC 사전조회 + 최종(+SEQ) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (F-02·F-03 Plant EE_UC 사전조회 + 최종(+SEQ)) |
| WK-SCP0126-0034 | X-LOC | F-06·F-07·F-08 Line EE_UC / 일반 + Plant 제 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (F-06·F-07·F-08 Line EE_UC / 일반 + Plant 제) |
| WK-SCP0126-0035 | X-LOC | F-12 Operation(영역2·3 공유) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (F-12 Operation(영역2·3 공유)) |
| WK-SCP0126-0036 | X-LOC | G-01 / F-14 `RemoveSheet`(CreateSpread c | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G-01 / F-14 `RemoveSheet`(CreateSpread c) |
| WK-SCP0126-0037 | X-LOC | G-02·G-03 `VisibleTab(true)` (cs:632·640 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G-02·G-03 `VisibleTab(true)` (cs:632·640) |
| WK-SCP0126-0038 | X-LOC | G-06 `SwitchLock()` (cs:842) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G-06 `SwitchLock()` (cs:842)) |
| WK-SCP0126-0039 | X-LOC | G-54·G-55·G-56 / F-25·F-26 (cs:3391-3462 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G-54·G-55·G-56 / F-25·F-26 (cs:3391-3462) |
| WK-SCP0126-0040 | X-LOC | OV-01 `FindButton`(923) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (OV-01 `FindButton`(923)) |
| WK-SCP0126-0041 | X-LOC | OV-02 `SaveButton`(937) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (OV-02 `SaveButton`(937)) |
| WK-SCP0126-0042 | X-LOC | OV-03 `DeleteButton`(763) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (OV-03 `DeleteButton`(763)) |
| WK-SCP0126-0043 | X-LOC | OV-04 `EditButton`(833) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (OV-04 `EditButton`(833)) |
| WK-SCP0126-0044 | X-LOC | OV-05 `InsertButton`(928) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (OV-05 `InsertButton`(928)) |
| WK-SCP0126-0045 | X-LOC | R-01 Division 별 컬럼 표시 토글(cs:724-756) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-01 Division 별 컬럼 표시 토글(cs:724-756)) |
| WK-SCP0126-0046 | X-LOC | R-02 조회 직후 전 컬럼 잠금(cs:1229-1230) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-02 조회 직후 전 컬럼 잠금(cs:1229-1230)) |
| WK-SCP0126-0047 | X-LOC | R-03 Edit 이 유일 해제 경로 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-03 Edit 이 유일 해제 경로) |
| WK-SCP0126-0048 | X-LOC | R-05 비EE_UC `LINE_TYPE` 잠금 + 기본값 `'-'`(c | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-05 비EE_UC `LINE_TYPE` 잠금 + 기본값 `'-'`(c) |
| WK-SCP0126-0049 | X-LOC | R-06 Daily Capa × EE_UC 행 교차 잠금(cs:848-8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-06 Daily Capa × EE_UC 행 교차 잠금(cs:848-8) |
| WK-SCP0126-0050 | X-LOC | R-07 `LINE_TYPE` 콤보 EE_UC 한정(cs:3806-381 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-07 `LINE_TYPE` 콤보 EE_UC 한정(cs:3806-381) |
| WK-SCP0126-0051 | X-LOC | R-08 `LINE_ID`→`LINE_NAME`(cs:3569-3573) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-08 `LINE_ID`→`LINE_NAME`(cs:3569-3573)) |
| WK-SCP0126-0052 | X-LOC | R-09 `LINE_ID`→`OPERATION_ID`(cs:3575-35 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-09 `LINE_ID`→`OPERATION_ID`(cs:3575-35) |
| WK-SCP0126-0053 | X-LOC | R-10 `PLANT_ID` 변경 → LINE 클리어(cs:3546-35 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-10 `PLANT_ID` 변경 → LINE 클리어(cs:3546-35) |
| WK-SCP0126-0054 | X-LOC | R-11 `ITEM_ID` 더블클릭 팝업(cs:3732-3765) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-11 `ITEM_ID` 더블클릭 팝업(cs:3732-3765)) |
| WK-SCP0126-0055 | X-LOC | R-12 붙여넣기 `LINE_NAME` 재파생(cs:3638-3661) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-12 붙여넣기 `LINE_NAME` 재파생(cs:3638-3661)) |
| WK-SCP0126-0056 | X-LOC | R-13 `NO_WORK_DATE`→`DAY_OF_WEEK`(cs:361 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-13 `NO_WORK_DATE`→`DAY_OF_WEEK`(cs:361) |
| WK-SCP0126-0057 | X-LOC | R-14 행 추가 = 편집모드 전제(cs:928·983) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-14 행 추가 = 편집모드 전제(cs:928·983)) |
| WK-SCP0126-0058 | X-LOC | R-15 신규행 기본값(cs:992-1049) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-15 신규행 기본값(cs:992-1049)) |
| WK-SCP0126-0059 | X-LOC | R-16 신규행 = 기존행 잠금 동일(cs:1002-1054 ↔ 876- | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-16 신규행 = 기존행 잠금 동일(cs:1002-1054 ↔ 876-) |
| WK-SCP0126-0060 | X-LOC | R-17 삭제 시트별 가드(cs:770-789) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-17 삭제 시트별 가드(cs:770-789)) |
| WK-SCP0126-0061 | X-LOC | R-18 셀 클릭 행 인덱스(cs:3768-3770) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-18 셀 클릭 행 인덱스(cs:3768-3770)) |
| WK-SCP0126-0062 | X-LOC | R-19 Plant 셀콤보 2차 제한(cs:394-432) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-19 Plant 셀콤보 2차 제한(cs:394-432)) |
| WK-SCP0126-0063 | X-LOC | R-20 Line 셀콤보 EE_UC/Plant 2중(cs:473-505) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-20 Line 셀콤보 EE_UC/Plant 2중(cs:473-505)) |
| WK-SCP0126-0064 | X-LOC | R-21 Operation 후보 시트 의존(cs:507-543) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-21 Operation 후보 시트 의존(cs:507-543)) |
| WK-SCP0126-0065 | X-LOC | R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·29 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·29) |
| WK-SCP0126-0066 | X-LOC | V-01 `MSG00344` Period 역전 (cs:1071-1075) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V-01 `MSG00344` Period 역전 (cs:1071-1075)) |
| WK-SCP0126-0067 | X-LOC | V-58 `MSG00129` (cs:3679) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (V-58 `MSG00129` (cs:3679)) |
| WK-SCP0126-0068 | X-LOC | `ROUTE_PATH` `'supply/opt-plan/opt-capa' | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`ROUTE_PATH` `'supply/opt-plan/opt-capa') |
| WK-SCP0126-0069 | X-LOC | `editMode`(Edit 잠금 토글) 전체 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`editMode`(Edit 잠금 토글) 전체) |
| WK-SCP0126-0070 | X-LOC | `findDuplicateKey` 가 Daily Capa 에도 적용 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`findDuplicateKey` 가 Daily Capa 에도 적용) |
| WK-SCP0126-0071 | X-LOC | cs:1573-1580 `M_MIN` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cs:1573-1580 `M_MIN`) |
| WK-SCP0126-0072 | X-LOC | cs:1582-1588 `LANE` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cs:1582-1588 `LANE`) |
| WK-SCP0126-0073 | X-LOC | cs:1590-1596 `WIDE_YN` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cs:1590-1596 `WIDE_YN`) |
| WK-SCP0126-0074 | X-LOC | cs:1654-1659 `CAPA` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cs:1654-1659 `CAPA`) |
| WK-SCP0126-0075 | X-LOC | 기간 중첩·역전 대조 원천 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (기간 중첩·역전 대조 원천) |
| WK-SCP0126-0076 | X-LOC | 데이터모델 이벤트 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (데이터모델 이벤트) |
| WK-SCP0126-0077 | X-LOC | 붙여넣기 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (붙여넣기) |
| WK-SCP0126-0078 | X-LOC | 셀 병합 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (셀 병합) |
| WK-SCP0126-0079 | X-LOC | 셀 타입 기타 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (셀 타입 기타) |
| WK-SCP0126-0080 | X-LOC | 셀 타입 콤보 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (셀 타입 콤보) |
| WK-SCP0126-0081 | X-LOC | 행 높이·색 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (행 높이·색) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0126-0082 | H10 | SCP0126 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0126 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: opt-capa.constants.ts |  | 12 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |

## W4 검사기 구현 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0126-0083 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0126_CAPA.GetOperationByLine ACT:) |
| WK-SCP0126-0084 | B3 | OPERATION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPERATION_ID | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0126_CAPA.GetOperationByLine ACT:) |
| WK-SCP0126-0085 | B3 | PLANT_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLANT_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0126_CAPA.GetOperationByLine ACT:) |
| WK-SCP0126-0086 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 1 (C-06·C-07 Division / `cboDivision`) |

## W5 검사기 연결 (38)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0126-0087 | B1 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-005) |
| WK-SCP0126-0088 | B1 | cboPlanGroup / Plan Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboPlanGroup / Plan Group | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0126-0089 | B1 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0126-0090 | B1 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0126-0091 | B2 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-005) |
| WK-SCP0126-0092 | B2 | cboPlanGroup / Plan Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboPlanGroup / Plan Group | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0126-0093 | B2 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0126-0094 | B2 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0126-0095 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0126_CAPA.GetOperationByLine ACT:) |
| WK-SCP0126-0096 | B4 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_ID | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0126_CAPA.GetOperationByLine ACT:) |
| WK-SCP0126-0097 | B4 | PLANT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0126_CAPA.GetOperationByLine ACT:) |
| WK-SCP0126-0098 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (D00-1-005 C-06·C-07 Division / `cboDivis) |
| WK-SCP0126-0099 | B4 | cboPlanGroup / Plan Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanGroup / Plan Group | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0126-0100 | B4 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0126-0101 | B4 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0126-0102 | B6 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-005) |
| WK-SCP0126-0103 | B6 | cboPlanGroup / Plan Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboPlanGroup / Plan Group | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0126-0104 | B6 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0126-0105 | B6 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0126-0106 | F2 | SCP0126 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0126 화면 | 판단불가(대상 단위 SCREEN) | 121 (D00-1-002 D00-2-002 D00-4d-005 COMMON:UC) |
| WK-SCP0126-0107 | F6 | SCP0126 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0126 화면 | 판단불가(대상 단위 SCREEN) | 107 (ACT:SCP0126_CAPA.SaveButton ACT:SCP0126_) |
| WK-SCP0126-0108 | G4 | btnBatchSave | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnBatchSave | 없음 | 2 (ACT:SCP0126_CAPA.InitEvent ACT:SCP0126_C) |
| WK-SCP0126-0109 | G4 | btnCancel | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnCancel | 없음 | 2 (ACT:SCP0126_SingleDatePopup.frmDatePicke) |
| WK-SCP0126-0110 | G4 | btnExcelForm | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnExcelForm | 없음 | 2 (ACT:SCP0126_CAPA.InitEvent ACT:SCP0126_C) |
| WK-SCP0126-0111 | G4 | btnExcelUpload | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnExcelUpload | 없음 | 2 (ACT:SCP0126_CAPA.InitEvent ACT:SCP0126_C) |
| WK-SCP0126-0112 | G4 | btnExit | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnExit | 없음 | 2 (ACT:SCP0126_SingleDatePopup.frmDatePicke) |
| WK-SCP0126-0113 | G4 | btnOK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnOK | 있음(FE 소스) | 2 (ACT:SCP0126_SingleDatePopup.frmDatePicke) |
| WK-SCP0126-0114 | G03-WIRE | SCP0126 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0126 화면 | 판단불가(대상 단위 SCREEN) | 42 (ACT:SCP0126_CAPA..ctor ACT:SCP0126_CAPA.) |
| WK-SCP0126-0115 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 34 (D00-2-011 D00-4d-009 D00-4d-010 D00-4d-0) |
| WK-SCP0126-0116 | G5 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (R-11 `ITEM_ID` 더블클릭 팝업(cs:3732-3765)) |
| WK-SCP0126-0117 | G5 | SCP0126_NoWork_BatchPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SCP0126_NoWork_BatchPopup | 판단불가(대상 단위 POPUP) | 4 (MODAL:NoWorkBatchModal `SCP0126_SingleDa) |
| WK-SCP0126-0118 | G5 | SCP0126_SingleDatePopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SCP0126_SingleDatePopup | 판단불가(대상 단위 POPUP) | 3 (`SCP0126_SingleDatePopup` ACT:SCP0126_CA) |
| WK-SCP0126-0119 | G5 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0120 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0121 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 34 (D00-2-011 D00-4d-009 D00-4d-010 D00-4d-0) |
| WK-SCP0126-0122 | H6 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (R-11 `ITEM_ID` 더블클릭 팝업(cs:3732-3765)) |
| WK-SCP0126-0123 | H6 | SCP0126_NoWork_BatchPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SCP0126_NoWork_BatchPopup | 판단불가(대상 단위 POPUP) | 4 (MODAL:NoWorkBatchModal `SCP0126_SingleDa) |
| WK-SCP0126-0124 | H6 | SCP0126_SingleDatePopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SCP0126_SingleDatePopup | 판단불가(대상 단위 POPUP) | 3 (`SCP0126_SingleDatePopup` ACT:SCP0126_CA) |

## W6 검증 실행 (243)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0126-0125 | J2 | SCP0126 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0126 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 102 (D00-1-002 D00-2-002 D00-3-004 D00-3-005 ) |
| WK-SCP0126-0126 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0126_CAPA.InitControls:295:49) |
| WK-SCP0126-0127 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-005 ACT:SCP0126_CAPA.InitControls:) |
| WK-SCP0126-0128 | C1 | cboPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-006 ACT:SCP0126_CAPA.RefreshPlanGr) |
| WK-SCP0126-0129 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0126_NoWork_BatchPopup.InitContro) |
| WK-SCP0126-0130 | C1 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (C-15·C-16 Line / `clbLine` ACT:SCP0126_C) |
| WK-SCP0126-0131 | C1 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-007 ACT:SCP0126_CAPA.RefreshPlantI) |
| WK-SCP0126-0132 | C1 | clbScmSite / Plant / Scm Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbScmSite / Plant / Scm Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0126_NoWork_BatchPopup.InitContro) |
| WK-SCP0126-0133 | C2 | DAY_OF_WEEK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DAY_OF_WEEK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (D00-3-061 ACT:SCP0126_CAPA._defaultDataM) |
| WK-SCP0126-0134 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0126_CAPA.ClbDivision_SelectedInd) |
| WK-SCP0126-0135 | C2 | FIX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FIX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0126_CAPA.SpdMain_CellClick:4155:) |
| WK-SCP0126-0136 | C2 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (D00-3-057 R-08 `LINE_ID`→`LINE_NAME`(cs:) |
| WK-SCP0126-0137 | C2 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (D00-3-058 D00-3-059 D00-3-062 R-08 `LINE) |
| WK-SCP0126-0138 | C2 | LINE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LINE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0126_CAPA.SpdMain_CellClick:4168:) |
| WK-SCP0126-0139 | C2 | NO_WORK_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NO_WORK_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SCP0126_CAPA._defaultDataModel_Chang) |
| WK-SCP0126-0140 | C2 | NO_WORK_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NO_WORK_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0126_CAPA.SpdMain_CellClick:4175:) |
| WK-SCP0126-0141 | C2 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (D00-3-060 ACT:SCP0126_CAPA.SpdMain_CellC) |
| WK-SCP0126-0142 | C2 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 11 (ACT:SCP0126_CAPA.SpdMain_CellClick:4137:) |
| WK-SCP0126-0143 | C2 | TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0126_CAPA.SpdMain_CellClick:4183:) |
| WK-SCP0126-0144 | C3 | CAPA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CAPA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0145 | C3 | DAY_OF_WEEK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DAY_OF_WEEK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (D00-3-061 ACT:SCP0126_CAPA.SetVisibleShe) |
| WK-SCP0126-0146 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SCP0126_CAPA.ClbDivision_SelectedInd) |
| WK-SCP0126-0147 | C3 | FIX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FIX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0148 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0149 | C3 | LANE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LANE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0150 | C3 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (D00-3-057 R-08 `LINE_ID`→`LINE_NAME`(cs:) |
| WK-SCP0126-0151 | C3 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (D00-3-058 D00-3-059 D00-3-062 R-08 `LINE) |
| WK-SCP0126-0152 | C3 | M_MIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — M_MIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0153 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0154 | C3 | NO_WORK_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NO_WORK_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0155 | C3 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (D00-3-060 ACT:SCP0126_CAPA.SpdMain_Combo) |
| WK-SCP0126-0156 | C3 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SCP0126_CAPA.SpdMain_ComboSelChange ) |
| WK-SCP0126-0157 | C3 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0158 | C3 | WEEK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — WEEK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0159 | C3 | WIDE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — WIDE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0160 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-005) |
| WK-SCP0126-0161 | C4 | cboPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-006) |
| WK-SCP0126-0162 | C4 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (C-15·C-16 Line / `clbLine`) |
| WK-SCP0126-0163 | C4 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-007) |
| WK-SCP0126-0164 | C6 | DAY_OF_WEEK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DAY_OF_WEEK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (D00-3-061 ACT:SCP0126_CAPA._defaultDataM) |
| WK-SCP0126-0165 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0126_CAPA.ClbDivision_SelectedInd) |
| WK-SCP0126-0166 | C6 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (D00-3-057 R-08 `LINE_ID`→`LINE_NAME`(cs:) |
| WK-SCP0126-0167 | C6 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (D00-3-058 D00-3-059 D00-3-062 R-08 `LINE) |
| WK-SCP0126-0168 | C6 | NO_WORK_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NO_WORK_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SCP0126_CAPA._defaultDataModel_Chang) |
| WK-SCP0126-0169 | C6 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (D00-3-060 ACT:SCP0126_CAPA.SpdMain_Combo) |
| WK-SCP0126-0170 | C6 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0126_CAPA.SpdMain_ComboSelChange ) |
| WK-SCP0126-0171 | G3 | SCP0126 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0126 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 9 (D00-1-012 D00-1-013 D00-1-028 COMMON:UC-) |
| WK-SCP0126-0172 | K-SA | SCP0126 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0126 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 4 (D00-1-012 D00-1-013 D00-1-028 C-03 `usrC) |
| WK-SCP0126-0173 | K4 | SCP0126 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0126 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 51 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0126-0174 | F1 | SCP0126 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0126 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 141 (D00-1-002 D00-2-002 D00-3-004 D00-3-005 ) |
| WK-SCP0126-0175 | F3 | SCP0126 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0126 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 14 (D00-2-001 D00-2-012 R-12 붙여넣기 `LINE_NAME) |
| WK-SCP0126-0176 | F5 | SCP0126 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0126 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 23 (D00-3-004 D00-3-005 D00-4d-001 D00-4d-00) |
| WK-SCP0126-0177 | F4 | PKG_COM0000.P_SCP0121_GET_SEARCH_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0121_GET_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 3 (C-08·C-09 Plan Group / `cboPlanGroup` AC) |
| WK-SCP0126-0178 | F4 | PKG_SCP0126.P_SCP0126_GET_CAPA_SEARCH_IN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_GET_CAPA_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 4 (ACT:SCP0126_CAPA.GetSearchInfo:324:5 ACT) |
| WK-SCP0126-0179 | F4 | PKG_SCP0126.P_SCP0126_GET_DAILY_CAPA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_GET_DAILY_CAPA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 127 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0180 | F4 | PKG_SCP0126.P_SCP0126_GET_NO_WORK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_GET_NO_WORK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 127 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0181 | F4 | PKG_SCP0126.P_SCP0126_GET_NO_WORK_WEEK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_GET_NO_WORK_WEEK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 127 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0182 | F4 | PKG_SCP0126.P_SCP0126_GET_PREP_RT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_GET_PREP_RT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 127 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0183 | F4 | PKG_SCP0126.P_SCP0126_GET_RAMP_UP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_GET_RAMP_UP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 127 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0184 | F4 | PKG_SCP0126.P_SCP0126_GET_RAMP_UP_ITVL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_GET_RAMP_UP_ITVL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 127 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0185 | F4 | PKG_SCP0126.P_SCP0126_GET_SOP_EOP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_GET_SOP_EOP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 127 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0186 | F4 | PKG_SCP0126.P_SCP0126_GET_UTIL_RT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_GET_UTIL_RT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 127 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0187 | F4 | PKG_SCP0126.P_SCP0126_GET_YLD_ELEC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_GET_YLD_ELEC · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 127 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0188 | F4 | PKG_SCP0126.P_SCP0126_SAVE_DAILY_CAPA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_SAVE_DAILY_CAPA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 24 (ACT:SCP0126_CAPA.SaveButton ACT:SCP0126_) |
| WK-SCP0126-0189 | F4 | PKG_SCP0126.P_SCP0126_SAVE_NO_WORK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_SAVE_NO_WORK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 24 (ACT:SCP0126_CAPA.SaveButton ACT:SCP0126_) |
| WK-SCP0126-0190 | F4 | PKG_SCP0126.P_SCP0126_SAVE_NO_WORK_BATCH | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_SAVE_NO_WORK_BATCH · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 85 (ACT:SCP0126_NoWork_BatchPopup.SaveButton) |
| WK-SCP0126-0191 | F4 | PKG_SCP0126.P_SCP0126_SAVE_NO_WORK_WEEK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_SAVE_NO_WORK_WEEK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 24 (ACT:SCP0126_CAPA.SaveButton ACT:SCP0126_) |
| WK-SCP0126-0192 | F4 | PKG_SCP0126.P_SCP0126_SAVE_PREP_RT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_SAVE_PREP_RT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 24 (ACT:SCP0126_CAPA.SaveButton ACT:SCP0126_) |
| WK-SCP0126-0193 | F4 | PKG_SCP0126.P_SCP0126_SAVE_RAMP_UP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_SAVE_RAMP_UP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 24 (ACT:SCP0126_CAPA.SaveButton ACT:SCP0126_) |
| WK-SCP0126-0194 | F4 | PKG_SCP0126.P_SCP0126_SAVE_RAMP_UP_ITVL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_SAVE_RAMP_UP_ITVL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 24 (ACT:SCP0126_CAPA.SaveButton ACT:SCP0126_) |
| WK-SCP0126-0195 | F4 | PKG_SCP0126.P_SCP0126_SAVE_SOP_EOP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_SAVE_SOP_EOP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 24 (ACT:SCP0126_CAPA.SaveButton ACT:SCP0126_) |
| WK-SCP0126-0196 | F4 | PKG_SCP0126.P_SCP0126_SAVE_UTIL_RT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_SAVE_UTIL_RT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 24 (ACT:SCP0126_CAPA.SaveButton ACT:SCP0126_) |
| WK-SCP0126-0197 | F4 | PKG_SCP0126.P_SCP0126_SAVE_YLD_ELEC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0126.P_SCP0126_SAVE_YLD_ELEC · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 24 (ACT:SCP0126_CAPA.SaveButton ACT:SCP0126_) |
| WK-SCP0126-0198 | F4 | SCM0001_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.GetDivisio) |
| WK-SCP0126-0199 | A5 | CAPA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CAPA · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (cs:739 `IndexOf("EE")>=0` → CAPA 숨김) |
| WK-SCP0126-0200 | A5 | DAY_OF_WEEK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DAY_OF_WEEK · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0201 | A5 | DESC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DESC · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0202 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0126_CAPA.CreateSpread ACT:SCP012) |
| WK-SCP0126-0203 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0204 | A5 | LANE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LANE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (cs:739 `IndexOf("EE")>=0` → CAPA 숨김) |
| WK-SCP0126-0205 | A5 | M_MIN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — M_MIN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (cs:739 `IndexOf("EE")>=0` → CAPA 숨김) |
| WK-SCP0126-0206 | A5 | NO_WORK_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NO_WORK_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0207 | A5 | OFF_TIME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OFF_TIME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0208 | A5 | SEQ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEQ · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (R-21 Operation 후보 시트 의존(cs:507-543) ACT:) |
| WK-SCP0126-0209 | A5 | WEEK_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — WEEK_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0210 | A5 | WIDE_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — WIDE_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (cs:739 `IndexOf("EE")>=0` → CAPA 숨김) |
| WK-SCP0126-0211 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0126_CAPA.InitControls ACT:SCP012) |
| WK-SCP0126-0212 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (D00-1-005 ACT:SCP0126_CAPA.InitControls ) |
| WK-SCP0126-0213 | G4 | cboPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanGroup / Plan Group · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-006 ACT:SCP0126_CAPA.InitEvent ACT) |
| WK-SCP0126-0214 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0126_NoWork_BatchPopup.InitContro) |
| WK-SCP0126-0215 | G4 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbLine / Line · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-007) |
| WK-SCP0126-0216 | G4 | clbPlant / Plant | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlant / Plant · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-008 ACT:SCP0126_CAPA.InitEvent ACT) |
| WK-SCP0126-0217 | G4 | clbScmSite / Plant / Scm Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbScmSite / Plant / Scm Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0126_NoWork_BatchPopup.InitContro) |
| WK-SCP0126-0218 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (ACT:SCP0126_NoWork_BatchPopup.InitContro) |
| WK-SCP0126-0219 | G4 | txtModel / Model / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtModel / Model / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-026) |
| WK-SCP0126-0220 | G4 | txtNickName / Nick Name / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-027) |
| WK-SCP0126-0221 | G4 | txtWeek / Week | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtWeek / Week · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitContro) |
| WK-SCP0126-0222 | H2 | DAY_OF_WEEK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DAY_OF_WEEK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0223 | H2 | DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DESC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0224 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0126_CAPA.CreateSpread ACT:SCP012) |
| WK-SCP0126-0225 | H2 | LINE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LINE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-07 `LINE_TYPE` 콤보 EE_UC 한정(cs:3806-381) |
| WK-SCP0126-0226 | H2 | NO_WORK_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NO_WORK_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0227 | H2 | OFF_TIME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OFF_TIME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0228 | H2 | SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (R-21 Operation 후보 시트 의존(cs:507-543) ACT:) |
| WK-SCP0126-0229 | H5 | DAY_OF_WEEK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DAY_OF_WEEK · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0230 | H5 | DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DESC · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0231 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0126_CAPA.CreateSpread ACT:SCP012) |
| WK-SCP0126-0232 | H5 | NO_WORK_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NO_WORK_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0233 | H5 | OFF_TIME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OFF_TIME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0234 | H5 | SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEQ · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (R-21 Operation 후보 시트 의존(cs:507-543) ACT:) |
| WK-SCP0126-0235 | H5 | cboDivision / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboDivision / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0126_CAPA.CreateSpread ACT:SCP012) |
| WK-SCP0126-0236 | H5 | clbLine / Line | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbLine / Line · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (C-15·C-16 Line / `clbLine`) |
| WK-SCP0126-0237 | I1 | SCP0126 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0126 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 81 (COMMON:UC-02 C-02 E-07 / EP-12 `ActiveSh) |
| WK-SCP0126-0238 | SC1 | SCP0126 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0126 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 11 (D00-1-005 D00-1-006 D00-1-007 D00-1-008 ) |
| WK-SCP0126-0239 | D1 | CAPA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CAPA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (D00-3-009 R-06 Daily Capa × EE_UC 행 교차 잠) |
| WK-SCP0126-0240 | D1 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0126_CAPA.EditButton:932:20) |
| WK-SCP0126-0241 | D1 | DAY_OF_WEEK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DAY_OF_WEEK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (D00-3-017 D00-3-035 ACT:SCP0126_CAPA.Edi) |
| WK-SCP0126-0242 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 24 (D00-3-007 D00-3-013 D00-3-015 D00-3-020 ) |
| WK-SCP0126-0243 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (R-11 `ITEM_ID` 더블클릭 팝업(cs:3732-3765)) |
| WK-SCP0126-0244 | D1 | LANE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LANE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (D00-3-011 R-06 Daily Capa × EE_UC 행 교차 잠) |
| WK-SCP0126-0245 | D1 | LAST_UPDATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 21 (D00-3-008 D00-3-014 D00-3-018 D00-3-023 ) |
| WK-SCP0126-0246 | D1 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 13 (D00-3-016 D00-3-021 D00-3-026 D00-3-034 ) |
| WK-SCP0126-0247 | D1 | LINE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LINE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 12 (D00-3-019 D00-3-024 D00-3-037 D00-3-043 ) |
| WK-SCP0126-0248 | D1 | M_MIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — M_MIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (D00-3-010 R-06 Daily Capa × EE_UC 행 교차 잠) |
| WK-SCP0126-0249 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 10 (D00-3-022 D00-3-029 D00-3-041 D00-3-050 ) |
| WK-SCP0126-0250 | D1 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (R-06 Daily Capa × EE_UC 행 교차 잠금(cs:848-8) |
| WK-SCP0126-0251 | D1 | OPMZ_PLAN_GR_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPMZ_PLAN_GR_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 17 (D00-3-015 D00-3-020 D00-3-025 D00-3-028 ) |
| WK-SCP0126-0252 | D1 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 20 (D00-3-008 D00-3-014 D00-3-018 D00-3-023 ) |
| WK-SCP0126-0253 | D1 | SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.EditButton) |
| WK-SCP0126-0254 | D1 | WEEK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — WEEK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0126_CAPA.EditButton ACT:SCP0126_) |
| WK-SCP0126-0255 | D1 | WIDE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — WIDE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (D00-3-012 R-06 Daily Capa × EE_UC 행 교차 잠) |
| WK-SCP0126-0256 | D1 | YYYYMM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — YYYYMM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (D00-3-007 D00-3-013 ACT:SCP0126_CAPA.Edi) |
| WK-SCP0126-0257 | D3 | CAPA | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CAPA · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (D00-3-009 R-06 Daily Capa × EE_UC 행 교차 잠) |
| WK-SCP0126-0258 | D3 | CHK | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CHK · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0126_CAPA.EditButton:932:20) |
| WK-SCP0126-0259 | D3 | DAY_OF_WEEK | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DAY_OF_WEEK · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (D00-3-017 D00-3-035 ACT:SCP0126_CAPA.Edi) |
| WK-SCP0126-0260 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 24 (D00-3-007 D00-3-013 D00-3-015 D00-3-020 ) |
| WK-SCP0126-0261 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (R-11 `ITEM_ID` 더블클릭 팝업(cs:3732-3765)) |
| WK-SCP0126-0262 | D3 | LANE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LANE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (D00-3-011 R-06 Daily Capa × EE_UC 행 교차 잠) |
| WK-SCP0126-0263 | D3 | LAST_UPDATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 21 (D00-3-008 D00-3-014 D00-3-018 D00-3-023 ) |
| WK-SCP0126-0264 | D3 | LINE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LINE_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 13 (D00-3-016 D00-3-021 D00-3-026 D00-3-034 ) |
| WK-SCP0126-0265 | D3 | LINE_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LINE_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 13 (D00-3-019 D00-3-024 D00-3-037 D00-3-043 ) |
| WK-SCP0126-0266 | D3 | M_MIN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — M_MIN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (D00-3-010 R-06 Daily Capa × EE_UC 행 교차 잠) |
| WK-SCP0126-0267 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 10 (D00-3-022 D00-3-029 D00-3-041 D00-3-050 ) |
| WK-SCP0126-0268 | D3 | OPERATION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (R-06 Daily Capa × EE_UC 행 교차 잠금(cs:848-8) |
| WK-SCP0126-0269 | D3 | OPMZ_PLAN_GR_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPMZ_PLAN_GR_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 17 (D00-3-015 D00-3-020 D00-3-025 D00-3-028 ) |
| WK-SCP0126-0270 | D3 | PRE_KEY_VALUES | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRE_KEY_VALUES · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 20 (D00-3-008 D00-3-014 D00-3-018 D00-3-023 ) |
| WK-SCP0126-0271 | D3 | SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SEQ · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.EditButton) |
| WK-SCP0126-0272 | D3 | WEEK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — WEEK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0126_CAPA.EditButton ACT:SCP0126_) |
| WK-SCP0126-0273 | D3 | WIDE_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — WIDE_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (D00-3-012 R-06 Daily Capa × EE_UC 행 교차 잠) |
| WK-SCP0126-0274 | D3 | YYYYMM | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — YYYYMM · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (D00-3-007 D00-3-013 ACT:SCP0126_CAPA.Edi) |
| WK-SCP0126-0275 | D4 | DAY_OF_WEEK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DAY_OF_WEEK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-061) |
| WK-SCP0126-0276 | D4 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-063) |
| WK-SCP0126-0277 | D4 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-057) |
| WK-SCP0126-0278 | D4 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 3 (D00-3-058 D00-3-059 D00-3-062) |
| WK-SCP0126-0279 | D4 | LINE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — LINE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R-05 비EE_UC `LINE_TYPE` 잠금 + 기본값 `'-'`(c) |
| WK-SCP0126-0280 | D4 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-064) |
| WK-SCP0126-0281 | D4 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-060) |
| WK-SCP0126-0282 | D5 | DAY_OF_WEEK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DAY_OF_WEEK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0283 | D5 | DESC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DESC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0284 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0126_CAPA.CreateSpread ACT:SCP012) |
| WK-SCP0126-0285 | D5 | NO_WORK_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NO_WORK_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0286 | D5 | OFF_TIME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — OFF_TIME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0287 | D5 | SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0288 | D6 | SCP0126 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0126 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 18 (D00-3-031 D00-3-032 D00-3-038 D00-3-044 ) |
| WK-SCP0126-0289 | E1 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SCP0126_CAPA.SpdMain_ClipboardPasted) |
| WK-SCP0126-0290 | E1 | LINE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — LINE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (R-12 붙여넣기 `LINE_NAME` 재파생(cs:3638-3661) ) |
| WK-SCP0126-0291 | E4 | ASSY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ASSY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0126_CAPA.CheckDouble:3651:11) |
| WK-SCP0126-0292 | E4 | CAPA | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CAPA · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (cs:1654-1659 `CAPA` ACT:SCP0126_CAPA.Set) |
| WK-SCP0126-0293 | E4 | DAY_OF_WEEK | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DAY_OF_WEEK · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0294 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (F-01 PlanGroup `DIVISION_ID`) |
| WK-SCP0126-0295 | E4 | ELEC_POST | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ELEC_POST · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0126_CAPA.CheckDouble:3651:11) |
| WK-SCP0126-0296 | E4 | FIX | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FIX · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0297 | E4 | LANE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LANE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (cs:1582-1588 `LANE` ACT:SCP0126_CAPA.Set) |
| WK-SCP0126-0298 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SCP0126_CAPA.Save_DailyCapa:1886:64 ) |
| WK-SCP0126-0299 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 9 (ACT:SCP0126_CAPA.Save_DailyCapa:2084:165) |
| WK-SCP0126-0300 | E4 | MSG00020 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00020 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0126_NoWork_BatchPopup.SaveData:4) |
| WK-SCP0126-0301 | E4 | MSG00046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0126_CAPA.Save_NoWork:1472:86) |
| WK-SCP0126-0302 | E4 | MSG00050 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00050 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (ACT:SCP0126_CAPA.CheckDouble:3687:14 ACT) |
| WK-SCP0126-0303 | E4 | MSG00061 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00061 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0126_NoWork_BatchPopup.SaveData:3) |
| WK-SCP0126-0304 | E4 | MSG00105 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00105 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·29) |
| WK-SCP0126-0305 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·29) |
| WK-SCP0126-0306 | E4 | MSG00129 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00129 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (V-58 `MSG00129` (cs:3679) BG-08 `!IsLock) |
| WK-SCP0126-0307 | E4 | MSG00260 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00260 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (`findDuplicateKey` 가 Daily Capa 에도 적용 AC) |
| WK-SCP0126-0308 | E4 | MSG00330 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00330 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0126_NoWork_BatchPopup.SaveData:3) |
| WK-SCP0126-0309 | E4 | MSG00344 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00344 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (V-01 `MSG00344` Period 역전 (cs:1071-1075)) |
| WK-SCP0126-0310 | E4 | MSG00443 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00443 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (`findDuplicateKey` 가 Daily Capa 에도 적용 AC) |
| WK-SCP0126-0311 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (C-02) |
| WK-SCP0126-0312 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0126-0313 | E4 | MSG01149 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01149 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (E-07 / EP-12 `ActiveSheetChanging` (cs:3) |
| WK-SCP0126-0314 | E4 | MSG01340 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01340 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V-01 `MSG00344` Period 역전 (cs:1071-1075)) |
| WK-SCP0126-0315 | E4 | M_MIN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — M_MIN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (cs:1573-1580 `M_MIN` ACT:SCP0126_CAPA.Se) |
| WK-SCP0126-0316 | E4 | NO_WORK_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NO_WORK_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0317 | E4 | SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SEQ · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (F-02·F-03 Plant EE_UC 사전조회 + 최종(+SEQ)) |
| WK-SCP0126-0318 | E4 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0319 | E4 | WEEK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — WEEK_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0320 | E4 | WIDE_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — WIDE_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (cs:1590-1596 `WIDE_YN` ACT:SCP0126_CAPA.) |
| WK-SCP0126-0321 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 3 (ACT:SCP0126_CAPA.SetVisibleSheetColumns ) |
| WK-SCP0126-0322 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 4 (ACT:SCP0126_CAPA.SetVisibleSearchControl) |
| WK-SCP0126-0323 | A10 | SCP0126 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0126 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 148 (ACT:SCP0126_CAPA.Form_Load ACT:SCP0126_C) |
| WK-SCP0126-0324 | A6 | PKG_COM0000.P_SCP0121_GET_SEARCH_INFO | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0121_GET_SEARCH_INFO · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _ |  | 1 (C-08·C-09 Plan Group / `cboPlanGroup`) |
| WK-SCP0126-0325 | A6 | PKG_SCP0126.P_SCP0126_GET_DAILY_CAPA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0126.P_SCP0126_GET_DAILY_CAPA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0326 | A6 | PKG_SCP0126.P_SCP0126_GET_NO_WORK | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0126.P_SCP0126_GET_NO_WORK · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trac |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0327 | A6 | PKG_SCP0126.P_SCP0126_GET_NO_WORK_WEEK | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0126.P_SCP0126_GET_NO_WORK_WEEK · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0328 | A6 | PKG_SCP0126.P_SCP0126_GET_PREP_RT | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0126.P_SCP0126_GET_PREP_RT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trac |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0329 | A6 | PKG_SCP0126.P_SCP0126_GET_RAMP_UP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0126.P_SCP0126_GET_RAMP_UP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trac |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0330 | A6 | PKG_SCP0126.P_SCP0126_GET_RAMP_UP_ITVL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0126.P_SCP0126_GET_RAMP_UP_ITVL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0331 | A6 | PKG_SCP0126.P_SCP0126_GET_SOP_EOP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0126.P_SCP0126_GET_SOP_EOP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trac |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0332 | A6 | PKG_SCP0126.P_SCP0126_GET_UTIL_RT | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0126.P_SCP0126_GET_UTIL_RT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trac |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0333 | A6 | PKG_SCP0126.P_SCP0126_GET_YLD_ELEC | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0126.P_SCP0126_GET_YLD_ELEC · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tra |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0334 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0126_CAPA.FindData_Main ACT:SCP01) |
| WK-SCP0126-0335 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-005 ACT:SCP0126_CAPA.FindData_Main) |
| WK-SCP0126-0336 | G1 | cboPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanGroup / Plan Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-006 ACT:SCP0126_CAPA.FindData_Main) |
| WK-SCP0126-0337 | G1 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbLine / Line · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-007 ACT:SCP0126_CAPA.FindData_Main) |
| WK-SCP0126-0338 | G1 | clbPlant / Plant | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlant / Plant · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-008 ACT:SCP0126_CAPA.FindData_Main) |
| WK-SCP0126-0339 | G1 | txtModel / Model / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtModel / Model / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-026 ACT:SCP0126_CAPA.FindData_Main) |
| WK-SCP0126-0340 | G1 | txtNickName / Nick Name / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-027 C-17·C-18 Nick Name / `txtNick) |
| WK-SCP0126-0341 | G1 | txtWeek / Week | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtWeek / Week · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0126_NoWork_BatchPopup.FindData A) |
| WK-SCP0126-0342 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0126_CAPA.InitControls ACT:SCP012) |
| WK-SCP0126-0343 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-005 ACT:SCP0126_CAPA.InitControls ) |
| WK-SCP0126-0344 | G6 | cboPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-006 ACT:SCP0126_CAPA.InitEvent ACT) |
| WK-SCP0126-0345 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0126_NoWork_BatchPopup.InitContro) |
| WK-SCP0126-0346 | G6 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-007) |
| WK-SCP0126-0347 | G6 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-008 ACT:SCP0126_CAPA.InitEvent ACT) |
| WK-SCP0126-0348 | G6 | clbScmSite / Plant / Scm Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbScmSite / Plant / Scm Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0126_NoWork_BatchPopup.InitContro) |
| WK-SCP0126-0349 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (ACT:SCP0126_NoWork_BatchPopup.InitContro) |
| WK-SCP0126-0350 | G6 | txtModel / Model / Model/Nickname | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtModel / Model / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-026) |
| WK-SCP0126-0351 | G6 | txtNickName / Nick Name / Model/Nickname | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-027) |
| WK-SCP0126-0352 | G6 | txtWeek / Week | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtWeek / Week · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitContro) |
| WK-SCP0126-0353 | X-REOPEN | SCP0126 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0126 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 27 (ACT:SCP0126_CAPA.Dispose ACT:SCP0126_CAP) |
| WK-SCP0126-0354 | H6 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0355 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0356 | M3 | SCP0126_NoWork_BatchPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SCP0126_NoWork_BatchPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 22 (ACT:SCP0126_NoWork_BatchPopup..ctor ACT:) |
| WK-SCP0126-0357 | M3 | SCP0126_SingleDatePopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SCP0126_SingleDatePopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 24 (ACT:SCP0126_SingleDatePopup..ctor ACT:SC) |
| WK-SCP0126-0358 | M3 | btnCancel | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnCancel · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 5 (ACT:SCP0126_SingleDatePopup.btnCancel_Cl) |
| WK-SCP0126-0359 | M3 | btnExit | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnExit · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 4 (ACT:SCP0126_SingleDatePopup.frmDatePicke) |
| WK-SCP0126-0360 | M3 | btnOK | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnOK · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 5 (ACT:SCP0126_SingleDatePopup.btnOK_Click ) |
| WK-SCP0126-0361 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 34 (D00-2-011 D00-4d-009 D00-4d-010 D00-4d-0) |
| WK-SCP0126-0362 | M4 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (R-11 `ITEM_ID` 더블클릭 팝업(cs:3732-3765) ACT) |
| WK-SCP0126-0363 | M4 | SCP0126_NoWork_BatchPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCP0126_NoWork_BatchPopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (MODAL:NoWorkBatchModal `SCP0126_SingleDa) |
| WK-SCP0126-0364 | M4 | SCP0126_SingleDatePopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCP0126_SingleDatePopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (`SCP0126_SingleDatePopup` ACT:SCP0126_CA) |
| WK-SCP0126-0365 | M4 | WEEK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — WEEK_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 16 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0366 | M4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0367 | M4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |

## W7 기대값 확정 (489)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0126-0368 | C1 | E-01 `ClbDivision_SelectedIndexChanged`( | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E-01 `ClbDivision_SelectedIndexChanged`(cs:3391): 행 집계 — C1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (E-01 `ClbDivision_SelectedIndexChanged`() |
| WK-SCP0126-0369 | C1 | E-02 `CboPlanGroup_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E-02 `CboPlanGroup_SelectedIndexChanged`(cs:3528): 행 집계 — C1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (E-02 `CboPlanGroup_SelectedIndexChanged`) |
| WK-SCP0126-0370 | C1 | E-03 `ClbPlant_SelectedIndexChanged`(cs: | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — E-03 `ClbPlant_SelectedIndexChanged`(cs:3533): 행 집계 — C1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (E-03 `ClbPlant_SelectedIndexChanged`(cs:) |
| WK-SCP0126-0371 | C2 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-2-001: 행 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0126-0372 | C2 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-2-013: 행 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-013) |
| WK-SCP0126-0373 | C2 | SCP0126_CAPA.CboPlanGroup_SelectedIndexC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0126_CAPA.CboPlanGroup_SelectedIndexChanged: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA.CboPlanGroup_SelectedIn) |
| WK-SCP0126-0374 | C2 | SCP0126_CAPA.ClbDivision_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0126_CAPA.ClbDivision_SelectedIndexChanged: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0126_CAPA.ClbDivision_SelectedInd) |
| WK-SCP0126-0375 | C2 | SCP0126_CAPA.ClbPlant_SelectedIndexChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0126_CAPA.ClbPlant_SelectedIndexChanged: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0126_CAPA.ClbPlant_SelectedIndexC) |
| WK-SCP0126-0376 | C2 | SCP0126_CAPA.SpdMain_ActiveSheetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0126_CAPA.SpdMain_ActiveSheetChanged: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0126_CAPA.SpdMain_ActiveSheetChan) |
| WK-SCP0126-0377 | C2 | SCP0126_CAPA.SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0126_CAPA.SpdMain_ComboSelChange: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0126_CAPA.SpdMain_ComboSelChange:) |
| WK-SCP0126-0378 | C2 | SCP0126_CAPA._defaultDataModel_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0126_CAPA._defaultDataModel_Changed: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA._defaultDataModel_Chang) |
| WK-SCP0126-0379 | C2 | SCP0126_CAPA.cboBucketType_SelectedIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0126_CAPA.cboBucketType_SelectedIndexChanged: 진입점 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0126_CAPA.cboBucketType_SelectedI) |
| WK-SCP0126-0380 | C2 | 데이터모델 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 데이터모델 이벤트: 행 집계 — C2 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (데이터모델 이벤트) |
| WK-SCP0126-0381 | C3 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-001: 행 집계 — C3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0126-0382 | C3 | D00-2-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-012: 행 집계 — C3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-012) |
| WK-SCP0126-0383 | C3 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-013: 행 집계 — C3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-013) |
| WK-SCP0126-0384 | C3 | SCP0126_CAPA.CboPlanGroup_SelectedIndexC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0126_CAPA.CboPlanGroup_SelectedIndexChanged: 진입점 집계 — C3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA.CboPlanGroup_SelectedIn) |
| WK-SCP0126-0385 | C3 | SCP0126_CAPA.ClbDivision_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0126_CAPA.ClbDivision_SelectedIndexChanged: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0126_CAPA.ClbDivision_SelectedInd) |
| WK-SCP0126-0386 | C3 | SCP0126_CAPA.ClbPlant_SelectedIndexChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0126_CAPA.ClbPlant_SelectedIndexChanged: 진입점 집계 — C3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0126_CAPA.ClbPlant_SelectedIndexC) |
| WK-SCP0126-0387 | C3 | SCP0126_CAPA.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0126_CAPA.SetChangedControl: 진입점 집계 — C3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0126_CAPA.SetChangedControl:585:1) |
| WK-SCP0126-0388 | C3 | SCP0126_CAPA.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0126_CAPA.SetSpreadInit: 진입점 집계 — C3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0126_CAPA.SetSpreadInit:721:1 ACT) |
| WK-SCP0126-0389 | C3 | SCP0126_CAPA.SetVisibleSearchControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0126_CAPA.SetVisibleSearchControls: 진입점 집계 — C3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0126_CAPA.SetVisibleSearchControl) |
| WK-SCP0126-0390 | C3 | SCP0126_CAPA.SetVisibleSheetColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0126_CAPA.SetVisibleSheetColumns: 진입점 집계 — C3 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0126_CAPA.SetVisibleSheetColumns:) |
| WK-SCP0126-0391 | C3 | SCP0126_CAPA.SpdMain_ActiveSheetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0126_CAPA.SpdMain_ActiveSheetChanged: 진입점 집계 — C3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0126_CAPA.SpdMain_ActiveSheetChan) |
| WK-SCP0126-0392 | C3 | SCP0126_CAPA.SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0126_CAPA.SpdMain_ComboSelChange: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0126_CAPA.SpdMain_ComboSelChange:) |
| WK-SCP0126-0393 | C3 | SCP0126_CAPA._defaultDataModel_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0126_CAPA._defaultDataModel_Changed: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA._defaultDataModel_Chang) |
| WK-SCP0126-0394 | C3 | SCP0126_CAPA.cboBucketType_SelectedIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0126_CAPA.cboBucketType_SelectedIndexChanged: 진입점 집계 — C3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0126_CAPA.cboBucketType_SelectedI) |
| WK-SCP0126-0395 | C3 | 데이터모델 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 데이터모델 이벤트: 행 집계 — C3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (데이터모델 이벤트) |
| WK-SCP0126-0396 | C3 | 붙여넣기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 붙여넣기: 행 집계 — C3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (붙여넣기) |
| WK-SCP0126-0397 | C4 | E-01 `ClbDivision_SelectedIndexChanged`( | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — E-01 `ClbDivision_SelectedIndexChanged`(cs:3391): 행 집계 — C4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E-01 `ClbDivision_SelectedIndexChanged`() |
| WK-SCP0126-0398 | C4 | E-02 `CboPlanGroup_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — E-02 `CboPlanGroup_SelectedIndexChanged`(cs:3528): 행 집계 — C4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E-02 `CboPlanGroup_SelectedIndexChanged`) |
| WK-SCP0126-0399 | C4 | E-03 `ClbPlant_SelectedIndexChanged`(cs: | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — E-03 `ClbPlant_SelectedIndexChanged`(cs:3533): 행 집계 — C4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (E-03 `ClbPlant_SelectedIndexChanged`(cs:) |
| WK-SCP0126-0400 | C6 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-2-001: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0126-0401 | C6 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-2-013: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-013) |
| WK-SCP0126-0402 | C6 | SCP0126_CAPA.CboPlanGroup_SelectedIndexC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0126_CAPA.CboPlanGroup_SelectedIndexChanged: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA.CboPlanGroup_SelectedIn) |
| WK-SCP0126-0403 | C6 | SCP0126_CAPA.ClbDivision_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0126_CAPA.ClbDivision_SelectedIndexChanged: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0126_CAPA.ClbDivision_SelectedInd) |
| WK-SCP0126-0404 | C6 | SCP0126_CAPA.ClbPlant_SelectedIndexChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0126_CAPA.ClbPlant_SelectedIndexChanged: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0126_CAPA.ClbPlant_SelectedIndexC) |
| WK-SCP0126-0405 | C6 | SCP0126_CAPA.SpdMain_ActiveSheetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0126_CAPA.SpdMain_ActiveSheetChanged: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0126_CAPA.SpdMain_ActiveSheetChan) |
| WK-SCP0126-0406 | C6 | SCP0126_CAPA.SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0126_CAPA.SpdMain_ComboSelChange: 진입점 집계 — C6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0126_CAPA.SpdMain_ComboSelChange:) |
| WK-SCP0126-0407 | C6 | SCP0126_CAPA._defaultDataModel_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0126_CAPA._defaultDataModel_Changed: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA._defaultDataModel_Chang) |
| WK-SCP0126-0408 | C6 | SCP0126_CAPA.cboBucketType_SelectedIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0126_CAPA.cboBucketType_SelectedIndexChanged: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0126_CAPA.cboBucketType_SelectedI) |
| WK-SCP0126-0409 | C6 | 데이터모델 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 데이터모델 이벤트: 행 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (데이터모델 이벤트) |
| WK-SCP0126-0410 | B1 | CB-08 `dtType` 리터럴(cs:233-245) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — CB-08 `dtType` 리터럴(cs:233-245): 행 집계 — B1 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (CB-08 `dtType` 리터럴(cs:233-245)) |
| WK-SCP0126-0411 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0126-0412 | B1 | D00-2-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — D00-2-010: 행 집계 — B1 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-010) |
| WK-SCP0126-0413 | B2 | CB-08 `dtType` 리터럴(cs:233-245) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — CB-08 `dtType` 리터럴(cs:233-245): 행 집계 — B2 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (CB-08 `dtType` 리터럴(cs:233-245)) |
| WK-SCP0126-0414 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0126-0415 | B2 | D00-2-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — D00-2-010: 행 집계 — B2 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-010) |
| WK-SCP0126-0416 | B3 | CB-01 `BLUtils.GetDivision` | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — CB-01 `BLUtils.GetDivision`: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (CB-01 `BLUtils.GetDivision`) |
| WK-SCP0126-0417 | B3 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-001: 행 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0126-0418 | B3 | SCP0126_CAPA.GetOperationByLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0126_CAPA.GetOperationByLine: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0126_CAPA.GetOperationByLine:3913) |
| WK-SCP0126-0419 | B3 | SCP0126_CAPA.GetPlanGroupByUserID | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0126_CAPA.GetPlanGroupByUserID: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0126_CAPA.GetPlanGroupByUserID:34) |
| WK-SCP0126-0420 | B3 | SCP0126_CAPA.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0126_CAPA.GetSearchInfo: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0126_CAPA.GetSearchInfo:317:1 ACT) |
| WK-SCP0126-0421 | B4 | CB-01 `BLUtils.GetDivision` | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — CB-01 `BLUtils.GetDivision`: 행 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (CB-01 `BLUtils.GetDivision`) |
| WK-SCP0126-0422 | B4 | CB-08 `dtType` 리터럴(cs:233-245) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — CB-08 `dtType` 리터럴(cs:233-245): 행 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (CB-08 `dtType` 리터럴(cs:233-245)) |
| WK-SCP0126-0423 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0126-0424 | B4 | D00-2-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-2-010: 행 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-010) |
| WK-SCP0126-0425 | B4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-001: 행 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0126-0426 | B4 | SCP0126_CAPA.GetOperationByLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0126_CAPA.GetOperationByLine: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0126_CAPA.GetOperationByLine:3913) |
| WK-SCP0126-0427 | B4 | SCP0126_CAPA.GetPlanGroupByUserID | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0126_CAPA.GetPlanGroupByUserID: 진입점 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0126_CAPA.GetPlanGroupByUserID:34) |
| WK-SCP0126-0428 | B4 | SCP0126_CAPA.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0126_CAPA.GetSearchInfo: 진입점 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0126_CAPA.GetSearchInfo:317:1 ACT) |
| WK-SCP0126-0429 | F4 | E-06 BatchSave Click (cs:3847-3859) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — E-06 BatchSave Click (cs:3847-3859): 행 집계 — F4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (E-06 BatchSave Click (cs:3847-3859)) |
| WK-SCP0126-0430 | F4 | OV-01 `FindButton`(923) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — OV-01 `FindButton`(923): 행 집계 — F4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (OV-01 `FindButton`(923)) |
| WK-SCP0126-0431 | F4 | SCP0126_NoWork_BatchPopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0126_NoWork_BatchPopup.FindButton: 진입점 집계 — F4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0126_NoWork_BatchPopup.FindButton) |
| WK-SCP0126-0432 | F4 | SCP0126_NoWork_BatchPopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0126_NoWork_BatchPopup.FindData: 진입점 집계 — F4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0126_NoWork_BatchPopup.FindData) |
| WK-SCP0126-0433 | F4 | hook #92 → **#113 로 전환 완료**(iter-3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — hook #92 → **#113 로 전환 완료**(iter-3): 행 집계 — F4 22요소: NOT_RUN:22 (미실행 요소가 남아 판정필요) |  | 1 (hook #92 → **#113 로 전환 완료**(iter-3)) |
| WK-SCP0126-0434 | A5 | 3 그리드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 3 그리드: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (3 그리드) |
| WK-SCP0126-0435 | A5 | 3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2)) |
| WK-SCP0126-0436 | A5 | BG-08 `!IsLock` + MSG00129 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — BG-08 `!IsLock` + MSG00129: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (BG-08 `!IsLock` + MSG00129) |
| WK-SCP0126-0437 | A5 | C-15·C-16 Line / `clbLine` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — C-15·C-16 Line / `clbLine`: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (C-15·C-16 Line / `clbLine`) |
| WK-SCP0126-0438 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0126-0439 | A5 | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-024: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-024) |
| WK-SCP0126-0440 | A5 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-025: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SCP0126-0441 | A5 | E-01 `ClbDivision_SelectedIndexChanged`( | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E-01 `ClbDivision_SelectedIndexChanged`(cs:3391): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (E-01 `ClbDivision_SelectedIndexChanged`() |
| WK-SCP0126-0442 | A5 | E-04 ExcelUpload Click (cs:3833-3839) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E-04 ExcelUpload Click (cs:3833-3839): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (E-04 ExcelUpload Click (cs:3833-3839)) |
| WK-SCP0126-0443 | A5 | E-08 / EP-13 `ActiveSheetChanged` (cs:36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E-08 / EP-13 `ActiveSheetChanged` (cs:3684-3696): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (E-08 / EP-13 `ActiveSheetChanged` (cs:36) |
| WK-SCP0126-0444 | A5 | G-01 / F-14 `RemoveSheet`(CreateSpread c | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — G-01 / F-14 `RemoveSheet`(CreateSpread cs:562-618): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (G-01 / F-14 `RemoveSheet`(CreateSpread c) |
| WK-SCP0126-0445 | A5 | G-06 `SwitchLock()` (cs:842) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — G-06 `SwitchLock()` (cs:842): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (G-06 `SwitchLock()` (cs:842)) |
| WK-SCP0126-0446 | A5 | Lock 계열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Lock 계열: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Lock 계열) |
| WK-SCP0126-0447 | A5 | OV-03 `DeleteButton`(763) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — OV-03 `DeleteButton`(763): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (OV-03 `DeleteButton`(763)) |
| WK-SCP0126-0448 | A5 | R-04 시트별 고정 잠금 집합(cs:871-917) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-04 시트별 고정 잠금 집합(cs:871-917): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-04 시트별 고정 잠금 집합(cs:871-917)) |
| WK-SCP0126-0449 | A5 | R-15 신규행 기본값(cs:992-1049) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-15 신규행 기본값(cs:992-1049): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-15 신규행 기본값(cs:992-1049)) |
| WK-SCP0126-0450 | A5 | R-17 삭제 시트별 가드(cs:770-789) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-17 삭제 시트별 가드(cs:770-789): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-17 삭제 시트별 가드(cs:770-789)) |
| WK-SCP0126-0451 | A5 | R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트)) |
| WK-SCP0126-0452 | A5 | R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·2950-2986): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·29) |
| WK-SCP0126-0453 | A5 | R19 `fps` 가드 2건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R19 `fps` 가드 2건: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R19 `fps` 가드 2건) |
| WK-SCP0126-0454 | A5 | SCP0126_CAPA.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0126_CAPA.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SCP0126_CAPA.CreateSpread:595:1 ACT:) |
| WK-SCP0126-0455 | A5 | SCP0126_CAPA.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0126_CAPA.SetSpreadInit: 진입점 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0126_CAPA.SetSpreadInit:721:1 ACT) |
| WK-SCP0126-0456 | A5 | `findDuplicateKey` 가 Daily Capa 에도 적용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `findDuplicateKey` 가 Daily Capa 에도 적용: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (`findDuplicateKey` 가 Daily Capa 에도 적용) |
| WK-SCP0126-0457 | A5 | 기간 중첩·역전 대조 원천 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 기간 중첩·역전 대조 원천: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (기간 중첩·역전 대조 원천) |
| WK-SCP0126-0458 | A5 | 데이터모델 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 데이터모델 이벤트: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (데이터모델 이벤트) |
| WK-SCP0126-0459 | A5 | 붙여넣기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 붙여넣기: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (붙여넣기) |
| WK-SCP0126-0460 | A5 | 셀 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 셀 병합: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합) |
| WK-SCP0126-0461 | A5 | 셀 타입 기타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 셀 타입 기타: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 기타) |
| WK-SCP0126-0462 | A5 | 셀 타입 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 셀 타입 콤보: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 콤보) |
| WK-SCP0126-0463 | A5 | 주석처리된 `lciNickName`/`lciModel` 숨김 코드(cs: | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 주석처리된 `lciNickName`/`lciModel` 숨김 코드(cs:3702·3723): 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (주석처리된 `lciNickName`/`lciModel` 숨김 코드(cs:) |
| WK-SCP0126-0464 | A5 | 행 높이·색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 행 높이·색: 행 집계 — A5 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (행 높이·색) |
| WK-SCP0126-0465 | G4 | 2 조회조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 2 조회조건: 행 집계 — G4 17요소: NOT_RUN:11 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (2 조회조건) |
| WK-SCP0126-0466 | G4 | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-028: 행 집계 — G4 17요소: NOT_RUN:11 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-028) |
| WK-SCP0126-0467 | G4 | D00-1-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-030: 행 집계 — G4 17요소: NOT_RUN:11 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-030) |
| WK-SCP0126-0468 | G4 | R-19 Plant 셀콤보 2차 제한(cs:394-432) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — R-19 Plant 셀콤보 2차 제한(cs:394-432): 행 집계 — G4 17요소: NOT_RUN:11 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (R-19 Plant 셀콤보 2차 제한(cs:394-432)) |
| WK-SCP0126-0469 | G4 | hook #138 (`ACTIVE_YN` 삭제) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — hook #138 (`ACTIVE_YN` 삭제): 행 집계 — G4 17요소: NOT_RUN:11 · NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (hook #138 (`ACTIVE_YN` 삭제)) |
| WK-SCP0126-0470 | H2 | 3 그리드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 3 그리드: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (3 그리드) |
| WK-SCP0126-0471 | H2 | 3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2)) |
| WK-SCP0126-0472 | H2 | BG-08 `!IsLock` + MSG00129 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — BG-08 `!IsLock` + MSG00129: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (BG-08 `!IsLock` + MSG00129) |
| WK-SCP0126-0473 | H2 | C-15·C-16 Line / `clbLine` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — C-15·C-16 Line / `clbLine`: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (C-15·C-16 Line / `clbLine`) |
| WK-SCP0126-0474 | H2 | C-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — C-22: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (C-22) |
| WK-SCP0126-0475 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0126-0476 | H2 | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-024: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-024) |
| WK-SCP0126-0477 | H2 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-025: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SCP0126-0478 | H2 | E-01 `ClbDivision_SelectedIndexChanged`( | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E-01 `ClbDivision_SelectedIndexChanged`(cs:3391): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (E-01 `ClbDivision_SelectedIndexChanged`() |
| WK-SCP0126-0479 | H2 | E-04 ExcelUpload Click (cs:3833-3839) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E-04 ExcelUpload Click (cs:3833-3839): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (E-04 ExcelUpload Click (cs:3833-3839)) |
| WK-SCP0126-0480 | H2 | E-08 / EP-13 `ActiveSheetChanged` (cs:36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E-08 / EP-13 `ActiveSheetChanged` (cs:3684-3696): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (E-08 / EP-13 `ActiveSheetChanged` (cs:36) |
| WK-SCP0126-0481 | H2 | G-01 / F-14 `RemoveSheet`(CreateSpread c | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G-01 / F-14 `RemoveSheet`(CreateSpread cs:562-618): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (G-01 / F-14 `RemoveSheet`(CreateSpread c) |
| WK-SCP0126-0482 | H2 | G-02·G-03 `VisibleTab(true)` (cs:632·640 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G-02·G-03 `VisibleTab(true)` (cs:632·640): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (G-02·G-03 `VisibleTab(true)` (cs:632·640) |
| WK-SCP0126-0483 | H2 | G-06 `SwitchLock()` (cs:842) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G-06 `SwitchLock()` (cs:842): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (G-06 `SwitchLock()` (cs:842)) |
| WK-SCP0126-0484 | H2 | Lock 계열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Lock 계열: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (Lock 계열) |
| WK-SCP0126-0485 | H2 | OV-03 `DeleteButton`(763) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — OV-03 `DeleteButton`(763): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (OV-03 `DeleteButton`(763)) |
| WK-SCP0126-0486 | H2 | R-04 시트별 고정 잠금 집합(cs:871-917) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-04 시트별 고정 잠금 집합(cs:871-917): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R-04 시트별 고정 잠금 집합(cs:871-917)) |
| WK-SCP0126-0487 | H2 | R-15 신규행 기본값(cs:992-1049) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-15 신규행 기본값(cs:992-1049): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R-15 신규행 기본값(cs:992-1049)) |
| WK-SCP0126-0488 | H2 | R-17 삭제 시트별 가드(cs:770-789) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-17 삭제 시트별 가드(cs:770-789): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R-17 삭제 시트별 가드(cs:770-789)) |
| WK-SCP0126-0489 | H2 | R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트)) |
| WK-SCP0126-0490 | H2 | R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·2950-2986): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·29) |
| WK-SCP0126-0491 | H2 | R19 `fps` 가드 2건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R19 `fps` 가드 2건: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R19 `fps` 가드 2건) |
| WK-SCP0126-0492 | H2 | SCP0126_CAPA.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0126_CAPA.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SCP0126_CAPA.CreateSpread:595:1 ACT:) |
| WK-SCP0126-0493 | H2 | SCP0126_CAPA.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0126_CAPA.SetSpreadInit: 진입점 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0126_CAPA.SetSpreadInit:721:1 ACT) |
| WK-SCP0126-0494 | H2 | `findDuplicateKey` 가 Daily Capa 에도 적용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `findDuplicateKey` 가 Daily Capa 에도 적용: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`findDuplicateKey` 가 Daily Capa 에도 적용) |
| WK-SCP0126-0495 | H2 | 기간 중첩·역전 대조 원천 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 기간 중첩·역전 대조 원천: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (기간 중첩·역전 대조 원천) |
| WK-SCP0126-0496 | H2 | 데이터모델 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 데이터모델 이벤트: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (데이터모델 이벤트) |
| WK-SCP0126-0497 | H2 | 붙여넣기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 붙여넣기: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (붙여넣기) |
| WK-SCP0126-0498 | H2 | 셀 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 셀 병합: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합) |
| WK-SCP0126-0499 | H2 | 셀 타입 기타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 셀 타입 기타: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 기타) |
| WK-SCP0126-0500 | H2 | 셀 타입 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 셀 타입 콤보: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 콤보) |
| WK-SCP0126-0501 | H2 | 행 높이·색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 행 높이·색: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (행 높이·색) |
| WK-SCP0126-0502 | H5 | 3 그리드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 3 그리드: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (3 그리드) |
| WK-SCP0126-0503 | H5 | 3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2)) |
| WK-SCP0126-0504 | H5 | BG-08 `!IsLock` + MSG00129 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — BG-08 `!IsLock` + MSG00129: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (BG-08 `!IsLock` + MSG00129) |
| WK-SCP0126-0505 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0126-0506 | H5 | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-024: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-024) |
| WK-SCP0126-0507 | H5 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-025: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SCP0126-0508 | H5 | E-01 `ClbDivision_SelectedIndexChanged`( | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E-01 `ClbDivision_SelectedIndexChanged`(cs:3391): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (E-01 `ClbDivision_SelectedIndexChanged`() |
| WK-SCP0126-0509 | H5 | E-04 ExcelUpload Click (cs:3833-3839) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E-04 ExcelUpload Click (cs:3833-3839): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (E-04 ExcelUpload Click (cs:3833-3839)) |
| WK-SCP0126-0510 | H5 | E-08 / EP-13 `ActiveSheetChanged` (cs:36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E-08 / EP-13 `ActiveSheetChanged` (cs:3684-3696): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (E-08 / EP-13 `ActiveSheetChanged` (cs:36) |
| WK-SCP0126-0511 | H5 | G-01 / F-14 `RemoveSheet`(CreateSpread c | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G-01 / F-14 `RemoveSheet`(CreateSpread cs:562-618): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (G-01 / F-14 `RemoveSheet`(CreateSpread c) |
| WK-SCP0126-0512 | H5 | G-06 `SwitchLock()` (cs:842) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G-06 `SwitchLock()` (cs:842): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (G-06 `SwitchLock()` (cs:842)) |
| WK-SCP0126-0513 | H5 | Lock 계열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Lock 계열: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Lock 계열) |
| WK-SCP0126-0514 | H5 | OV-03 `DeleteButton`(763) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — OV-03 `DeleteButton`(763): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (OV-03 `DeleteButton`(763)) |
| WK-SCP0126-0515 | H5 | R-04 시트별 고정 잠금 집합(cs:871-917) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-04 시트별 고정 잠금 집합(cs:871-917): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R-04 시트별 고정 잠금 집합(cs:871-917)) |
| WK-SCP0126-0516 | H5 | R-15 신규행 기본값(cs:992-1049) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-15 신규행 기본값(cs:992-1049): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R-15 신규행 기본값(cs:992-1049)) |
| WK-SCP0126-0517 | H5 | R-17 삭제 시트별 가드(cs:770-789) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-17 삭제 시트별 가드(cs:770-789): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R-17 삭제 시트별 가드(cs:770-789)) |
| WK-SCP0126-0518 | H5 | R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트)) |
| WK-SCP0126-0519 | H5 | R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·2950-2986): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R-23 기간 4방향 중첩(cs:2136-2173·2694-2730·29) |
| WK-SCP0126-0520 | H5 | R19 `fps` 가드 2건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R19 `fps` 가드 2건: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R19 `fps` 가드 2건) |
| WK-SCP0126-0521 | H5 | SCP0126_CAPA.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0126_CAPA.CreateSpread: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SCP0126_CAPA.CreateSpread:595:1 ACT:) |
| WK-SCP0126-0522 | H5 | SCP0126_CAPA.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0126_CAPA.SetSpreadInit: 진입점 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0126_CAPA.SetSpreadInit:721:1 ACT) |
| WK-SCP0126-0523 | H5 | `findDuplicateKey` 가 Daily Capa 에도 적용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `findDuplicateKey` 가 Daily Capa 에도 적용: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`findDuplicateKey` 가 Daily Capa 에도 적용) |
| WK-SCP0126-0524 | H5 | 기간 중첩·역전 대조 원천 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 기간 중첩·역전 대조 원천: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (기간 중첩·역전 대조 원천) |
| WK-SCP0126-0525 | H5 | 데이터모델 이벤트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 데이터모델 이벤트: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (데이터모델 이벤트) |
| WK-SCP0126-0526 | H5 | 붙여넣기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 붙여넣기: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (붙여넣기) |
| WK-SCP0126-0527 | H5 | 셀 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 셀 병합: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합) |
| WK-SCP0126-0528 | H5 | 셀 타입 기타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 셀 타입 기타: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 기타) |
| WK-SCP0126-0529 | H5 | 셀 타입 콤보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 셀 타입 콤보: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (셀 타입 콤보) |
| WK-SCP0126-0530 | H5 | 행 높이·색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 행 높이·색: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (행 높이·색) |
| WK-SCP0126-0531 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)  AS-IS SP 실측(`asis.py proc SCP0126_GET_DAILY_CAPA` 133- |  | 1 (COMMON:UC-06) |
| WK-SCP0126-0532 | X-REASON | `Preparation Rate` 탭 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `Preparation Rate` 탭 제외목록 실측상 등록 7 division 전건 제외. 미등록 7 division 에서만 나타난다 → 04 ⑦ V-1 |  | 1 (`Preparation Rate` 탭) |
| WK-SCP0126-0533 | X-REASON | cs:1561 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — cs:1561 기본값·필수검증은 `FlagI‖FlagM` 행만 동 — `activeFlag === 'D'` 조기 반환 |  | 1 (cs:1561) |
| WK-SCP0126-0534 | X-REASON | cs:1564 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — cs:1564 `pre_key_values.Split(' ')[0] == ""` → `action = FlagI` 동 2번. 근거: `GET_DAILY_CAPA` 가 원장을 OUTER JOIN(`PK |  | 1 (cs:1564) |
| WK-SCP0126-0535 | X-REASON | cs:1569 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — cs:1569 `division_id == "EE" ‖ (== "EE_UC" && operation_id == "E2000")` `isElectrodeCapaRow()` — **행의** `DIVISI |  | 1 (cs:1569) |
| WK-SCP0126-0536 | X-REASON | cs:1599 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — cs:1599 전극 분기 → `capa = "0.0"` 동 3번 — `DAILY_CAPA_SAVE_DEFAULT.CAPA` |  | 1 (cs:1599) |
| WK-SCP0126-0537 | X-REASON | cs:1662-1664 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — cs:1662-1664 그 외 → `m_min="0"`, `lane="0"`, `wide_yn="Y"` 동 3번 |  | 1 (cs:1662-1664) |
| WK-SCP0126-0538 | D1 | BG-08 `!IsLock` + MSG00129 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — BG-08 `!IsLock` + MSG00129: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (BG-08 `!IsLock` + MSG00129) |
| WK-SCP0126-0539 | D1 | D00-1-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-1-030: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-030) |
| WK-SCP0126-0540 | D1 | D00-3-053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-053: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-053) |
| WK-SCP0126-0541 | D1 | E-07 / EP-12 `ActiveSheetChanging` (cs:3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — E-07 / EP-12 `ActiveSheetChanging` (cs:3664-3681): 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (E-07 / EP-12 `ActiveSheetChanging` (cs:3) |
| WK-SCP0126-0542 | D1 | G-06 `SwitchLock()` (cs:842) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G-06 `SwitchLock()` (cs:842): 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (G-06 `SwitchLock()` (cs:842)) |
| WK-SCP0126-0543 | D1 | Lock 계열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Lock 계열: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (Lock 계열) |
| WK-SCP0126-0544 | D1 | OV-04 `EditButton`(833) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — OV-04 `EditButton`(833): 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (OV-04 `EditButton`(833)) |
| WK-SCP0126-0545 | D1 | R-02 조회 직후 전 컬럼 잠금(cs:1229-1230) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-02 조회 직후 전 컬럼 잠금(cs:1229-1230): 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (R-02 조회 직후 전 컬럼 잠금(cs:1229-1230)) |
| WK-SCP0126-0546 | D1 | R-03 Edit 이 유일 해제 경로 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-03 Edit 이 유일 해제 경로: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (R-03 Edit 이 유일 해제 경로) |
| WK-SCP0126-0547 | D1 | R-04 시트별 고정 잠금 집합(cs:871-917) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-04 시트별 고정 잠금 집합(cs:871-917): 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (R-04 시트별 고정 잠금 집합(cs:871-917)) |
| WK-SCP0126-0548 | D1 | R-14 행 추가 = 편집모드 전제(cs:928·983) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-14 행 추가 = 편집모드 전제(cs:928·983): 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (R-14 행 추가 = 편집모드 전제(cs:928·983)) |
| WK-SCP0126-0549 | D1 | R-16 신규행 = 기존행 잠금 동일(cs:1002-1054 ↔ 876- | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-16 신규행 = 기존행 잠금 동일(cs:1002-1054 ↔ 876-918): 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (R-16 신규행 = 기존행 잠금 동일(cs:1002-1054 ↔ 876-) |
| WK-SCP0126-0550 | D1 | SCP0126_CAPA.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0126_CAPA.EditButton: 진입점 집계 — D1 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0126_CAPA.EditButton:891:1 ACT:SC) |
| WK-SCP0126-0551 | D1 | `editMode`(Edit 잠금 토글) 전체 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `editMode`(Edit 잠금 토글) 전체: 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (`editMode`(Edit 잠금 토글) 전체) |
| WK-SCP0126-0552 | D3 | BG-08 `!IsLock` + MSG00129 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — BG-08 `!IsLock` + MSG00129: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (BG-08 `!IsLock` + MSG00129) |
| WK-SCP0126-0553 | D3 | C-22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — C-22: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (C-22) |
| WK-SCP0126-0554 | D3 | D00-1-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-1-030: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-030) |
| WK-SCP0126-0555 | D3 | D00-3-053 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-053: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-053) |
| WK-SCP0126-0556 | D3 | E-07 / EP-12 `ActiveSheetChanging` (cs:3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — E-07 / EP-12 `ActiveSheetChanging` (cs:3664-3681): 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (E-07 / EP-12 `ActiveSheetChanging` (cs:3) |
| WK-SCP0126-0557 | D3 | G-02·G-03 `VisibleTab(true)` (cs:632·640 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-02·G-03 `VisibleTab(true)` (cs:632·640): 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (G-02·G-03 `VisibleTab(true)` (cs:632·640) |
| WK-SCP0126-0558 | D3 | G-06 `SwitchLock()` (cs:842) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G-06 `SwitchLock()` (cs:842): 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (G-06 `SwitchLock()` (cs:842)) |
| WK-SCP0126-0559 | D3 | Lock 계열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Lock 계열: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (Lock 계열) |
| WK-SCP0126-0560 | D3 | OV-04 `EditButton`(833) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — OV-04 `EditButton`(833): 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (OV-04 `EditButton`(833)) |
| WK-SCP0126-0561 | D3 | R-02 조회 직후 전 컬럼 잠금(cs:1229-1230) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-02 조회 직후 전 컬럼 잠금(cs:1229-1230): 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (R-02 조회 직후 전 컬럼 잠금(cs:1229-1230)) |
| WK-SCP0126-0562 | D3 | R-03 Edit 이 유일 해제 경로 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-03 Edit 이 유일 해제 경로: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (R-03 Edit 이 유일 해제 경로) |
| WK-SCP0126-0563 | D3 | R-04 시트별 고정 잠금 집합(cs:871-917) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-04 시트별 고정 잠금 집합(cs:871-917): 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (R-04 시트별 고정 잠금 집합(cs:871-917)) |
| WK-SCP0126-0564 | D3 | R-14 행 추가 = 편집모드 전제(cs:928·983) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-14 행 추가 = 편집모드 전제(cs:928·983): 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (R-14 행 추가 = 편집모드 전제(cs:928·983)) |
| WK-SCP0126-0565 | D3 | R-16 신규행 = 기존행 잠금 동일(cs:1002-1054 ↔ 876- | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-16 신규행 = 기존행 잠금 동일(cs:1002-1054 ↔ 876-918): 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (R-16 신규행 = 기존행 잠금 동일(cs:1002-1054 ↔ 876-) |
| WK-SCP0126-0566 | D3 | SCP0126_CAPA.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0126_CAPA.EditButton: 진입점 집계 — D3 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0126_CAPA.EditButton:891:1 ACT:SC) |
| WK-SCP0126-0567 | D3 | `editMode`(Edit 잠금 토글) 전체 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `editMode`(Edit 잠금 토글) 전체: 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (`editMode`(Edit 잠금 토글) 전체) |
| WK-SCP0126-0568 | D4 | 3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2): 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2)) |
| WK-SCP0126-0569 | D4 | BG-07 `_isFinding` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — BG-07 `_isFinding`: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (BG-07 `_isFinding`) |
| WK-SCP0126-0570 | D4 | C-06·C-07 Division / `cboDivision` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — C-06·C-07 Division / `cboDivision`: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (C-06·C-07 Division / `cboDivision`) |
| WK-SCP0126-0571 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0126-0572 | D4 | D00-3-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-031: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-031) |
| WK-SCP0126-0573 | D4 | D00-3-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-032: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-032) |
| WK-SCP0126-0574 | D4 | D00-3-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-038: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-038) |
| WK-SCP0126-0575 | D4 | D00-3-044 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-044: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-044) |
| WK-SCP0126-0576 | D4 | D00-3-048 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-048: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-048) |
| WK-SCP0126-0577 | D4 | G-01 / F-14 `RemoveSheet`(CreateSpread c | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — G-01 / F-14 `RemoveSheet`(CreateSpread cs:562-618): 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (G-01 / F-14 `RemoveSheet`(CreateSpread c) |
| WK-SCP0126-0578 | D4 | OV-05 `InsertButton`(928) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — OV-05 `InsertButton`(928): 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (OV-05 `InsertButton`(928)) |
| WK-SCP0126-0579 | D4 | R-14 행 추가 = 편집모드 전제(cs:928·983) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — R-14 행 추가 = 편집모드 전제(cs:928·983): 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R-14 행 추가 = 편집모드 전제(cs:928·983)) |
| WK-SCP0126-0580 | D4 | R-15 신규행 기본값(cs:992-1049) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — R-15 신규행 기본값(cs:992-1049): 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (R-15 신규행 기본값(cs:992-1049)) |
| WK-SCP0126-0581 | D4 | `editMode`(Edit 잠금 토글) 전체 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — `editMode`(Edit 잠금 토글) 전체: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`editMode`(Edit 잠금 토글) 전체) |
| WK-SCP0126-0582 | D4 | 셀 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 셀 병합: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합) |
| WK-SCP0126-0583 | D5 | CB-08 `dtType` 리터럴(cs:233-245) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — CB-08 `dtType` 리터럴(cs:233-245): 행 집계 — D5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (CB-08 `dtType` 리터럴(cs:233-245)) |
| WK-SCP0126-0584 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0126-0585 | D5 | D00-2-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — D00-2-010: 행 집계 — D5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-010) |
| WK-SCP0126-0586 | D5 | SCP0126_CAPA.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0126_CAPA.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SCP0126_CAPA.CreateSpread:595:1 ACT:) |
| WK-SCP0126-0587 | D5 | SCP0126_CAPA.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0126_CAPA.SetSpreadInit: 진입점 집계 — D5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0126_CAPA.SetSpreadInit:721:1 ACT) |
| WK-SCP0126-0588 | E1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D00-2-001: 행 집계 — E1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0126-0589 | E1 | D00-2-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — D00-2-012: 행 집계 — E1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-012) |
| WK-SCP0126-0590 | E1 | 붙여넣기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 붙여넣기: 행 집계 — E1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (붙여넣기) |
| WK-SCP0126-0591 | E3 | CB-01 `BLUtils.GetDivision` | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — CB-01 `BLUtils.GetDivision`: 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (CB-01 `BLUtils.GetDivision`) |
| WK-SCP0126-0592 | E3 | CB-02~CB-06 `init` Tables[0..4] | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — CB-02~CB-06 `init` Tables[0..4]: 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (CB-02~CB-06 `init` Tables[0..4]) |
| WK-SCP0126-0593 | E3 | CB-07 `SCP0121` Tables[3] | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — CB-07 `SCP0121` Tables[3]: 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (CB-07 `SCP0121` Tables[3]) |
| WK-SCP0126-0594 | E3 | CB-08 `dtType` 리터럴(cs:233-245) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — CB-08 `dtType` 리터럴(cs:233-245): 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (CB-08 `dtType` 리터럴(cs:233-245)) |
| WK-SCP0126-0595 | E3 | CB-09 `dtFixCombo` 리터럴(cs:253-265) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — CB-09 `dtFixCombo` 리터럴(cs:253-265): 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (CB-09 `dtFixCombo` 리터럴(cs:253-265)) |
| WK-SCP0126-0596 | E3 | E-04 ExcelUpload Click (cs:3833-3839) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — E-04 ExcelUpload Click (cs:3833-3839): 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (E-04 ExcelUpload Click (cs:3833-3839)) |
| WK-SCP0126-0597 | E3 | E-05 ExcelForm Click (cs:3841-3844) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — E-05 ExcelForm Click (cs:3841-3844): 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (E-05 ExcelForm Click (cs:3841-3844)) |
| WK-SCP0126-0598 | E3 | E-06 BatchSave Click (cs:3847-3859) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — E-06 BatchSave Click (cs:3847-3859): 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (E-06 BatchSave Click (cs:3847-3859)) |
| WK-SCP0126-0599 | E3 | E-07 / EP-12 `ActiveSheetChanging` (cs:3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — E-07 / EP-12 `ActiveSheetChanging` (cs:3664-3681): 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (E-07 / EP-12 `ActiveSheetChanging` (cs:3) |
| WK-SCP0126-0600 | E3 | E-08 / EP-13 `ActiveSheetChanged` (cs:36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — E-08 / EP-13 `ActiveSheetChanged` (cs:3684-3696): 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (E-08 / EP-13 `ActiveSheetChanged` (cs:36) |
| WK-SCP0126-0601 | E3 | F-06·F-07·F-08 Line EE_UC / 일반 + Plant 제 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — F-06·F-07·F-08 Line EE_UC / 일반 + Plant 제한: 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (F-06·F-07·F-08 Line EE_UC / 일반 + Plant 제) |
| WK-SCP0126-0602 | E3 | F-12 Operation(영역2·3 공유) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — F-12 Operation(영역2·3 공유): 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (F-12 Operation(영역2·3 공유)) |
| WK-SCP0126-0603 | E3 | R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트): 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트)) |
| WK-SCP0126-0604 | E3 | SEQ | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — SEQ: AS-IS 필수 표시(grid_rule 라벨 *) 정보 없음 — TO-BE 필수=False |  | 1 (F-02·F-03 Plant EE_UC 사전조회 + 최종(+SEQ)) |
| WK-SCP0126-0605 | E3 | V-01 `MSG00344` Period 역전 (cs:1071-1075) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — V-01 `MSG00344` Period 역전 (cs:1071-1075): 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (V-01 `MSG00344` Period 역전 (cs:1071-1075)) |
| WK-SCP0126-0606 | E3 | V-58 `MSG00129` (cs:3679) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — V-58 `MSG00129` (cs:3679): 행 집계 — E3 6요소: PASS:5 · REVIEW:1 |  | 1 (V-58 `MSG00129` (cs:3679)) |
| WK-SCP0126-0607 | E4 | CB-01 `BLUtils.GetDivision` | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CB-01 `BLUtils.GetDivision`: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (CB-01 `BLUtils.GetDivision`) |
| WK-SCP0126-0608 | E4 | CB-02~CB-06 `init` Tables[0..4] | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CB-02~CB-06 `init` Tables[0..4]: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (CB-02~CB-06 `init` Tables[0..4]) |
| WK-SCP0126-0609 | E4 | CB-07 `SCP0121` Tables[3] | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CB-07 `SCP0121` Tables[3]: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (CB-07 `SCP0121` Tables[3]) |
| WK-SCP0126-0610 | E4 | CB-08 `dtType` 리터럴(cs:233-245) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CB-08 `dtType` 리터럴(cs:233-245): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (CB-08 `dtType` 리터럴(cs:233-245)) |
| WK-SCP0126-0611 | E4 | CB-09 `dtFixCombo` 리터럴(cs:253-265) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CB-09 `dtFixCombo` 리터럴(cs:253-265): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (CB-09 `dtFixCombo` 리터럴(cs:253-265)) |
| WK-SCP0126-0612 | E4 | E-04 ExcelUpload Click (cs:3833-3839) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — E-04 ExcelUpload Click (cs:3833-3839): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (E-04 ExcelUpload Click (cs:3833-3839)) |
| WK-SCP0126-0613 | E4 | E-05 ExcelForm Click (cs:3841-3844) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — E-05 ExcelForm Click (cs:3841-3844): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (E-05 ExcelForm Click (cs:3841-3844)) |
| WK-SCP0126-0614 | E4 | E-06 BatchSave Click (cs:3847-3859) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — E-06 BatchSave Click (cs:3847-3859): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (E-06 BatchSave Click (cs:3847-3859)) |
| WK-SCP0126-0615 | E4 | E-08 / EP-13 `ActiveSheetChanged` (cs:36 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — E-08 / EP-13 `ActiveSheetChanged` (cs:3684-3696): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (E-08 / EP-13 `ActiveSheetChanged` (cs:36) |
| WK-SCP0126-0616 | E4 | F-06·F-07·F-08 Line EE_UC / 일반 + Plant 제 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — F-06·F-07·F-08 Line EE_UC / 일반 + Plant 제한: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (F-06·F-07·F-08 Line EE_UC / 일반 + Plant 제) |
| WK-SCP0126-0617 | E4 | F-12 Operation(영역2·3 공유) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — F-12 Operation(영역2·3 공유): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (F-12 Operation(영역2·3 공유)) |
| WK-SCP0126-0618 | E4 | R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (R-22 저장 전 키중복·키변경(cs:1314-1345 외 7시트)) |
| WK-SCP0126-0619 | E4 | SCP0126_CAPA.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0126_CAPA.SetChangedControl: 진입점 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0126_CAPA.SetChangedControl:585:1) |
| WK-SCP0126-0620 | E4 | SCP0126_CAPA.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0126_CAPA.SetSpreadInit: 진입점 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0126_CAPA.SetSpreadInit:721:1 ACT) |
| WK-SCP0126-0621 | E4 | SCP0126_CAPA.SetVisibleSearchControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0126_CAPA.SetVisibleSearchControls: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0126_CAPA.SetVisibleSearchControl) |
| WK-SCP0126-0622 | E4 | SCP0126_CAPA.SetVisibleSheetColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0126_CAPA.SetVisibleSheetColumns: 진입점 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0126_CAPA.SetVisibleSheetColumns:) |
| WK-SCP0126-0623 | A1 | 2 조회조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2 조회조건: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (2 조회조건) |
| WK-SCP0126-0624 | A1 | C-17·C-18 Nick Name / `txtNickName` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — C-17·C-18 Nick Name / `txtNickName`: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (C-17·C-18 Nick Name / `txtNickName`) |
| WK-SCP0126-0625 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (COMMON:UC-02) |
| WK-SCP0126-0626 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (COMMON:UC-07) |
| WK-SCP0126-0627 | A1 | D00-3-052 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-052: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (D00-3-052) |
| WK-SCP0126-0628 | A1 | E-06 BatchSave Click (cs:3847-3859) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E-06 BatchSave Click (cs:3847-3859): 행 집계 — A1 10요소: REVIEW:10 |  | 1 (E-06 BatchSave Click (cs:3847-3859)) |
| WK-SCP0126-0629 | A1 | E-07 / EP-12 `ActiveSheetChanging` (cs:3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E-07 / EP-12 `ActiveSheetChanging` (cs:3664-3681): 행 집계 — A1 10요소: REVIEW:10 |  | 1 (E-07 / EP-12 `ActiveSheetChanging` (cs:3) |
| WK-SCP0126-0630 | A1 | F-02·F-03 Plant EE_UC 사전조회 + 최종(+SEQ) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — F-02·F-03 Plant EE_UC 사전조회 + 최종(+SEQ): 행 집계 — A1 10요소: REVIEW:10 |  | 1 (F-02·F-03 Plant EE_UC 사전조회 + 최종(+SEQ)) |
| WK-SCP0126-0631 | A1 | OV-01 `FindButton`(923) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — OV-01 `FindButton`(923): 행 집계 — A1 10요소: REVIEW:10 |  | 1 (OV-01 `FindButton`(923)) |
| WK-SCP0126-0632 | A1 | PKG_COM0000.P_SCP0121_GET_SEARCH_INFO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0121_GET_SEARCH_INFO: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0121_GET_SEARCH_INFO — 팝업·보조 SP 는 golden_cases.cs |  | 1 (C-08·C-09 Plan Group / `cboPlanGroup`) |
| WK-SCP0126-0633 | A1 | PKG_SCP0126.P_SCP0126_GET_DAILY_CAPA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0126.P_SCP0126_GET_DAILY_CAPA: 골든 비교 케이스 없음(PKG_SCP0126.P_SCP0126_GET_DAILY_CAPA — 팝업·보조 SP 는 golden_cases.csv  |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0634 | A1 | PKG_SCP0126.P_SCP0126_GET_NO_WORK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0126.P_SCP0126_GET_NO_WORK: 골든 비교 케이스 없음(PKG_SCP0126.P_SCP0126_GET_NO_WORK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실 |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0635 | A1 | PKG_SCP0126.P_SCP0126_GET_NO_WORK_WEEK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0126.P_SCP0126_GET_NO_WORK_WEEK: 골든 비교 케이스 없음(PKG_SCP0126.P_SCP0126_GET_NO_WORK_WEEK — 팝업·보조 SP 는 golden_cases. |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0636 | A1 | PKG_SCP0126.P_SCP0126_GET_PREP_RT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0126.P_SCP0126_GET_PREP_RT: 골든 비교 케이스 없음(PKG_SCP0126.P_SCP0126_GET_PREP_RT — 팝업·보조 SP 는 golden_cases.csv 에 FE 실 |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0637 | A1 | PKG_SCP0126.P_SCP0126_GET_RAMP_UP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0126.P_SCP0126_GET_RAMP_UP: 골든 비교 케이스 없음(PKG_SCP0126.P_SCP0126_GET_RAMP_UP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실 |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0638 | A1 | PKG_SCP0126.P_SCP0126_GET_RAMP_UP_ITVL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0126.P_SCP0126_GET_RAMP_UP_ITVL: 골든 비교 케이스 없음(PKG_SCP0126.P_SCP0126_GET_RAMP_UP_ITVL — 팝업·보조 SP 는 golden_cases. |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0639 | A1 | PKG_SCP0126.P_SCP0126_GET_SOP_EOP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0126.P_SCP0126_GET_SOP_EOP: 골든 비교 케이스 없음(PKG_SCP0126.P_SCP0126_GET_SOP_EOP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실 |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0640 | A1 | PKG_SCP0126.P_SCP0126_GET_UTIL_RT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0126.P_SCP0126_GET_UTIL_RT: 골든 비교 케이스 없음(PKG_SCP0126.P_SCP0126_GET_UTIL_RT — 팝업·보조 SP 는 golden_cases.csv 에 FE 실 |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0641 | A1 | PKG_SCP0126.P_SCP0126_GET_YLD_ELEC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0126.P_SCP0126_GET_YLD_ELEC: 골든 비교 케이스 없음(PKG_SCP0126.P_SCP0126_GET_YLD_ELEC — 팝업·보조 SP 는 golden_cases.csv 에 FE |  | 96 (ACT:SCP0126_CAPA.FindButton ACT:SCP0126_) |
| WK-SCP0126-0642 | A1 | R-02 조회 직후 전 컬럼 잠금(cs:1229-1230) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-02 조회 직후 전 컬럼 잠금(cs:1229-1230): 행 집계 — A1 10요소: REVIEW:10 |  | 1 (R-02 조회 직후 전 컬럼 잠금(cs:1229-1230)) |
| WK-SCP0126-0643 | A1 | R-08 `LINE_ID`→`LINE_NAME`(cs:3569-3573) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-08 `LINE_ID`→`LINE_NAME`(cs:3569-3573): 행 집계 — A1 10요소: REVIEW:10 |  | 1 (R-08 `LINE_ID`→`LINE_NAME`(cs:3569-3573)) |
| WK-SCP0126-0644 | A1 | R-09 `LINE_ID`→`OPERATION_ID`(cs:3575-35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-09 `LINE_ID`→`OPERATION_ID`(cs:3575-3580 → 3594-: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (R-09 `LINE_ID`→`OPERATION_ID`(cs:3575-35) |
| WK-SCP0126-0645 | A1 | R-19 Plant 셀콤보 2차 제한(cs:394-432) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R-19 Plant 셀콤보 2차 제한(cs:394-432): 행 집계 — A1 10요소: REVIEW:10 |  | 1 (R-19 Plant 셀콤보 2차 제한(cs:394-432)) |
| WK-SCP0126-0646 | A1 | SCP0126_NoWork_BatchPopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0126_NoWork_BatchPopup.FindButton: 진입점 집계 — A1 10요소: REVIEW:10 |  | 1 (ACT:SCP0126_NoWork_BatchPopup.FindButton) |
| WK-SCP0126-0647 | A1 | SCP0126_NoWork_BatchPopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0126_NoWork_BatchPopup.FindData: 진입점 집계 — A1 10요소: REVIEW:10 |  | 1 (ACT:SCP0126_NoWork_BatchPopup.FindData) |
| WK-SCP0126-0648 | A1 | V-01 `MSG00344` Period 역전 (cs:1071-1075) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — V-01 `MSG00344` Period 역전 (cs:1071-1075): 행 집계 — A1 10요소: REVIEW:10 |  | 1 (V-01 `MSG00344` Period 역전 (cs:1071-1075)) |
| WK-SCP0126-0649 | A1 | hook #138 (`ACTIVE_YN` 삭제) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — hook #138 (`ACTIVE_YN` 삭제): 행 집계 — A1 10요소: REVIEW:10 |  | 1 (hook #138 (`ACTIVE_YN` 삭제)) |
| WK-SCP0126-0650 | A1 | hook #92 → **#113 로 전환 완료**(iter-3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — hook #92 → **#113 로 전환 완료**(iter-3): 행 집계 — A1 10요소: REVIEW:10 |  | 1 (hook #92 → **#113 로 전환 완료**(iter-3)) |
| WK-SCP0126-0651 | A1 | 기간 중첩·역전 대조 원천 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 기간 중첩·역전 대조 원천: 행 집계 — A1 10요소: REVIEW:10 |  | 1 (기간 중첩·역전 대조 원천) |
| WK-SCP0126-0652 | A6 | E-06 BatchSave Click (cs:3847-3859) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — E-06 BatchSave Click (cs:3847-3859): 행 집계 — A6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (E-06 BatchSave Click (cs:3847-3859)) |
| WK-SCP0126-0653 | A6 | OV-01 `FindButton`(923) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — OV-01 `FindButton`(923): 행 집계 — A6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (OV-01 `FindButton`(923)) |
| WK-SCP0126-0654 | A6 | SCP0126_NoWork_BatchPopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0126_NoWork_BatchPopup.FindButton: 진입점 집계 — A6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0126_NoWork_BatchPopup.FindButton) |
| WK-SCP0126-0655 | A6 | SCP0126_NoWork_BatchPopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0126_NoWork_BatchPopup.FindData: 진입점 집계 — A6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0126_NoWork_BatchPopup.FindData) |
| WK-SCP0126-0656 | A6 | hook #92 → **#113 로 전환 완료**(iter-3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — hook #92 → **#113 로 전환 완료**(iter-3): 행 집계 — A6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (hook #92 → **#113 로 전환 완료**(iter-3)) |
| WK-SCP0126-0657 | G1 | 2 조회조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2 조회조건: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (2 조회조건) |
| WK-SCP0126-0658 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0126-0659 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0126-0660 | G1 | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-028: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-028) |
| WK-SCP0126-0661 | G1 | D00-1-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-030: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-030) |
| WK-SCP0126-0662 | G1 | D00-3-052 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-052: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-052) |
| WK-SCP0126-0663 | G1 | E-07 / EP-12 `ActiveSheetChanging` (cs:3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E-07 / EP-12 `ActiveSheetChanging` (cs:3664-3681): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (E-07 / EP-12 `ActiveSheetChanging` (cs:3) |
| WK-SCP0126-0664 | G1 | F-02·F-03 Plant EE_UC 사전조회 + 최종(+SEQ) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — F-02·F-03 Plant EE_UC 사전조회 + 최종(+SEQ): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (F-02·F-03 Plant EE_UC 사전조회 + 최종(+SEQ)) |
| WK-SCP0126-0665 | G1 | OV-01 `FindButton`(923) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — OV-01 `FindButton`(923): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (OV-01 `FindButton`(923)) |
| WK-SCP0126-0666 | G1 | R-02 조회 직후 전 컬럼 잠금(cs:1229-1230) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-02 조회 직후 전 컬럼 잠금(cs:1229-1230): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R-02 조회 직후 전 컬럼 잠금(cs:1229-1230)) |
| WK-SCP0126-0667 | G1 | R-08 `LINE_ID`→`LINE_NAME`(cs:3569-3573) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-08 `LINE_ID`→`LINE_NAME`(cs:3569-3573): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R-08 `LINE_ID`→`LINE_NAME`(cs:3569-3573)) |
| WK-SCP0126-0668 | G1 | R-09 `LINE_ID`→`OPERATION_ID`(cs:3575-35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-09 `LINE_ID`→`OPERATION_ID`(cs:3575-3580 → 3594-: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R-09 `LINE_ID`→`OPERATION_ID`(cs:3575-35) |
| WK-SCP0126-0669 | G1 | R-19 Plant 셀콤보 2차 제한(cs:394-432) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-19 Plant 셀콤보 2차 제한(cs:394-432): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (R-19 Plant 셀콤보 2차 제한(cs:394-432)) |
| WK-SCP0126-0670 | G1 | V-01 `MSG00344` Period 역전 (cs:1071-1075) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — V-01 `MSG00344` Period 역전 (cs:1071-1075): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (V-01 `MSG00344` Period 역전 (cs:1071-1075)) |
| WK-SCP0126-0671 | G1 | hook #138 (`ACTIVE_YN` 삭제) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — hook #138 (`ACTIVE_YN` 삭제): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (hook #138 (`ACTIVE_YN` 삭제)) |
| WK-SCP0126-0672 | G1 | 기간 중첩·역전 대조 원천 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 기간 중첩·역전 대조 원천: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (기간 중첩·역전 대조 원천) |
| WK-SCP0126-0673 | G6 | 2 조회조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 2 조회조건: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (2 조회조건) |
| WK-SCP0126-0674 | G6 | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-028: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-028) |
| WK-SCP0126-0675 | G6 | D00-1-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-030: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-030) |
| WK-SCP0126-0676 | G6 | R-19 Plant 셀콤보 2차 제한(cs:394-432) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — R-19 Plant 셀콤보 2차 제한(cs:394-432): 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (R-19 Plant 셀콤보 2차 제한(cs:394-432)) |
| WK-SCP0126-0677 | G6 | hook #138 (`ACTIVE_YN` 삭제) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — hook #138 (`ACTIVE_YN` 삭제): 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (hook #138 (`ACTIVE_YN` 삭제)) |
| WK-SCP0126-0678 | X-LOC | **계** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — **계**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (**계**) |
| WK-SCP0126-0679 | X-LOC | 1 Layout | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1 Layout: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1 Layout) |
| WK-SCP0126-0680 | X-LOC | 2 조회조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2 조회조건: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2 조회조건) |
| WK-SCP0126-0681 | X-LOC | 3 그리드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3 그리드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3 그리드) |
| WK-SCP0126-0682 | X-LOC | 3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3 그리드 — iter-3 추가(설계 미규정, §6.1·6.2)) |
| WK-SCP0126-0683 | X-LOC | R08 탭 인덱스 음수 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R08 탭 인덱스 음수 가드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R08 탭 인덱스 음수 가드) |
| WK-SCP0126-0684 | X-LOC | R19 `fps` 가드 2건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R19 `fps` 가드 2건: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R19 `fps` 가드 2건) |
| WK-SCP0126-0685 | X-LOC | `SCP0126_SingleDatePopup` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SCP0126_SingleDatePopup`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SCP0126_SingleDatePopup`) |
| WK-SCP0126-0686 | X-LOC | cs:731 `IndexOf("EE_UC")>=0` → 4컬럼 표시 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cs:731 `IndexOf("EE_UC")>=0` → 4컬럼 표시: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cs:731 `IndexOf("EE_UC")>=0` → 4컬럼 표시) |
| WK-SCP0126-0687 | X-LOC | cs:739 `IndexOf("EE")>=0` → CAPA 숨김 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cs:739 `IndexOf("EE")>=0` → CAPA 숨김: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cs:739 `IndexOf("EE")>=0` → CAPA 숨김) |
| WK-SCP0126-0688 | X-LOC | cs:746 else → CAPA 만 표시 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cs:746 else → CAPA 만 표시: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cs:746 else → CAPA 만 표시) |
| WK-SCP0126-0689 | X-LOC | hook #138 (`ACTIVE_YN` 삭제) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — hook #138 (`ACTIVE_YN` 삭제): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (hook #138 (`ACTIVE_YN` 삭제)) |
| WK-SCP0126-0690 | X-LOC | hook #68 (신규행 콤보 PARAM9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — hook #68 (신규행 콤보 PARAM9): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (hook #68 (신규행 콤보 PARAM9)) |
| WK-SCP0126-0691 | X-LOC | hook #81 (탭 구동 lazy fetch) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — hook #81 (탭 구동 lazy fetch): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (hook #81 (탭 구동 lazy fetch)) |
| WK-SCP0126-0692 | X-LOC | hook #92 (`DIVISION_ID` 콤마토큰 구방식) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — hook #92 (`DIVISION_ID` 콤마토큰 구방식): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (hook #92 (`DIVISION_ID` 콤마토큰 구방식)) |
| WK-SCP0126-0693 | X-LOC | 주석처리된 `lciNickName`/`lciModel` 숨김 코드(cs: | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 주석처리된 `lciNickName`/`lciModel` 숨김 코드(cs:3702·3723): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (주석처리된 `lciNickName`/`lciModel` 숨김 코드(cs:) |
| WK-SCP0126-0694 | X-ROW | **계** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — **계**: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (**계**) |
| WK-SCP0126-0695 | X-ROW | 1 Layout | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 1 Layout: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (1 Layout) |
| WK-SCP0126-0696 | X-ROW | BG-06 `ActiveSheetIndex < 0` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BG-06 `ActiveSheetIndex < 0`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (BG-06 `ActiveSheetIndex < 0`) |
| WK-SCP0126-0697 | X-ROW | C-10·C-11 Period / `mrpPeriod` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-10·C-11 Period / `mrpPeriod`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-10·C-11 Period / `mrpPeriod`) |
| WK-SCP0126-0698 | X-ROW | C-13·C-14 Plant / `clbPlant` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-13·C-14 Plant / `clbPlant`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-13·C-14 Plant / `clbPlant`) |
| WK-SCP0126-0699 | X-ROW | C-19·C-20 Model / `txtModel` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-19·C-20 Model / `txtModel`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-19·C-20 Model / `txtModel`) |
| WK-SCP0126-0700 | X-ROW | C-24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — C-24: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (C-24) |
| WK-SCP0126-0701 | X-ROW | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-001) |
| WK-SCP0126-0702 | X-ROW | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-003) |
| WK-SCP0126-0703 | X-ROW | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-004) |
| WK-SCP0126-0704 | X-ROW | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-021: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-021) |
| WK-SCP0126-0705 | X-ROW | D00-1-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-022: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-022) |
| WK-SCP0126-0706 | X-ROW | D00-1-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-023: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-023) |
| WK-SCP0126-0707 | X-ROW | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-003) |
| WK-SCP0126-0708 | X-ROW | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-004) |
| WK-SCP0126-0709 | X-ROW | D00-2-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-008) |
| WK-SCP0126-0710 | X-ROW | D00-2-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-009: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-009) |
| WK-SCP0126-0711 | X-ROW | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-001) |
| WK-SCP0126-0712 | X-ROW | D00-3-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-002) |
| WK-SCP0126-0713 | X-ROW | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-003) |
| WK-SCP0126-0714 | X-ROW | D00-3-054 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-054: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-054) |
| WK-SCP0126-0715 | X-ROW | D00-3-055 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-055: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-055) |
| WK-SCP0126-0716 | X-ROW | D00-3-056 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-056: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-056) |
| WK-SCP0126-0717 | X-ROW | D00-4c-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-001) |
| WK-SCP0126-0718 | X-ROW | D00-4c-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-002) |
| WK-SCP0126-0719 | X-ROW | D00-4c-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-003) |
| WK-SCP0126-0720 | X-ROW | D00-4c-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-004) |
| WK-SCP0126-0721 | X-ROW | D00-4c-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-005) |
| WK-SCP0126-0722 | X-ROW | D00-4c-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-006) |
| WK-SCP0126-0723 | X-ROW | D00-4c-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-007) |
| WK-SCP0126-0724 | X-ROW | D00-4c-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-008) |
| WK-SCP0126-0725 | X-ROW | D00-4c-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-009: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-009) |
| WK-SCP0126-0726 | X-ROW | D00-4c-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-010) |
| WK-SCP0126-0727 | X-ROW | D00-4c-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-011) |
| WK-SCP0126-0728 | X-ROW | D00-4c-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-012: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-012) |
| WK-SCP0126-0729 | X-ROW | D00-4c-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-013: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-013) |
| WK-SCP0126-0730 | X-ROW | D00-4c-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-014: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-014) |
| WK-SCP0126-0731 | X-ROW | D00-4c-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-015: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-015) |
| WK-SCP0126-0732 | X-ROW | D00-4c-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-016: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-016) |
| WK-SCP0126-0733 | X-ROW | D00-4c-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-017: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-017) |
| WK-SCP0126-0734 | X-ROW | D00-4c-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-018: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-018) |
| WK-SCP0126-0735 | X-ROW | D00-4c-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-019: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-019) |
| WK-SCP0126-0736 | X-ROW | D00-4c-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-020: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-020) |
| WK-SCP0126-0737 | X-ROW | D00-4c-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-021: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-021) |
| WK-SCP0126-0738 | X-ROW | D00-4c-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-022: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-022) |
| WK-SCP0126-0739 | X-ROW | D00-4c-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-023: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-023) |
| WK-SCP0126-0740 | X-ROW | D00-4c-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-024: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-024) |
| WK-SCP0126-0741 | X-ROW | D00-4c-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-025: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-025) |
| WK-SCP0126-0742 | X-ROW | D00-4c-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-026: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-026) |
| WK-SCP0126-0743 | X-ROW | D00-4c-027 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-027: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-027) |
| WK-SCP0126-0744 | X-ROW | D00-4c-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-028: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-028) |
| WK-SCP0126-0745 | X-ROW | D00-4c-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-029: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-029) |
| WK-SCP0126-0746 | X-ROW | D00-4c-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-030: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-030) |
| WK-SCP0126-0747 | X-ROW | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-006) |
| WK-SCP0126-0748 | X-ROW | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-007) |
| WK-SCP0126-0749 | X-ROW | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-008) |
| WK-SCP0126-0750 | X-ROW | EP-01~EP-08 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EP-01~EP-08: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (EP-01~EP-08) |
| WK-SCP0126-0751 | X-ROW | G-54·G-55·G-56 / F-25·F-26 (cs:3391-3462 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G-54·G-55·G-56 / F-25·F-26 (cs:3391-3462): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G-54·G-55·G-56 / F-25·F-26 (cs:3391-3462) |
| WK-SCP0126-0752 | X-ROW | R-01 Division 별 컬럼 표시 토글(cs:724-756) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R-01 Division 별 컬럼 표시 토글(cs:724-756): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R-01 Division 별 컬럼 표시 토글(cs:724-756)) |
| WK-SCP0126-0753 | X-ROW | R-10 `PLANT_ID` 변경 → LINE 클리어(cs:3546-35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R-10 `PLANT_ID` 변경 → LINE 클리어(cs:3546-3567): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R-10 `PLANT_ID` 변경 → LINE 클리어(cs:3546-35) |
| WK-SCP0126-0754 | X-ROW | R-13 `NO_WORK_DATE`→`DAY_OF_WEEK`(cs:361 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R-13 `NO_WORK_DATE`→`DAY_OF_WEEK`(cs:3619-3636): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R-13 `NO_WORK_DATE`→`DAY_OF_WEEK`(cs:361) |
| WK-SCP0126-0755 | X-ROW | R-18 셀 클릭 행 인덱스(cs:3768-3770) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R-18 셀 클릭 행 인덱스(cs:3768-3770): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R-18 셀 클릭 행 인덱스(cs:3768-3770)) |
| WK-SCP0126-0756 | X-ROW | R-20 Line 셀콤보 EE_UC/Plant 2중(cs:473-505) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R-20 Line 셀콤보 EE_UC/Plant 2중(cs:473-505): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R-20 Line 셀콤보 EE_UC/Plant 2중(cs:473-505)) |
| WK-SCP0126-0757 | X-ROW | R08 탭 인덱스 음수 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — R08 탭 인덱스 음수 가드: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (R08 탭 인덱스 음수 가드) |
| WK-SCP0126-0758 | X-ROW | SCP0126_CAPA.BtnBatchSave_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.BtnBatchSave_Click: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0126_CAPA.BtnBatchSave_Click:4209) |
| WK-SCP0126-0759 | X-ROW | SCP0126_CAPA.BtnExcelUpload_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.BtnExcelUpload_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0126_CAPA.BtnExcelUpload_Click:41) |
| WK-SCP0126-0760 | X-ROW | SCP0126_CAPA.CboPlanGroup_SelectedIndexC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.CboPlanGroup_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA.CboPlanGroup_SelectedIn) |
| WK-SCP0126-0761 | X-ROW | SCP0126_CAPA.CheckDouble | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.CheckDouble: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 18 (ACT:SCP0126_CAPA.CheckDouble ACT:SCP0126) |
| WK-SCP0126-0762 | X-ROW | SCP0126_CAPA.ClbDivision_SelectedIndexCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.ClbDivision_SelectedIndexChanged: 진입점 집계 6검사 — REVIEW:3 · NOT_RUN:3 |  | 5 (ACT:SCP0126_CAPA.ClbDivision_SelectedInd) |
| WK-SCP0126-0763 | X-ROW | SCP0126_CAPA.ClbPlant_SelectedIndexChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.ClbPlant_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA.ClbPlant_SelectedIndexC) |
| WK-SCP0126-0764 | X-ROW | SCP0126_CAPA.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.FindButton: 진입점 집계 27검사 — NOT_RUN:18 · REVIEW:9 |  | 1 (ACT:SCP0126_CAPA.FindButton) |
| WK-SCP0126-0765 | X-ROW | SCP0126_CAPA.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.FindData_Main: 진입점 집계 46검사 — NOT_RUN:28 · REVIEW:9 · PASS:9 |  | 14 (ACT:SCP0126_CAPA.FindData_Main:1137:1 AC) |
| WK-SCP0126-0766 | X-ROW | SCP0126_CAPA.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA.Form_Load) |
| WK-SCP0126-0767 | X-ROW | SCP0126_CAPA.GetPlanGroupByUserID | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.GetPlanGroupByUserID: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_CAPA.GetPlanGroupByUserID AC) |
| WK-SCP0126-0768 | X-ROW | SCP0126_CAPA.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.GetSearchInfo: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_CAPA.GetSearchInfo ACT:SCP01) |
| WK-SCP0126-0769 | X-ROW | SCP0126_CAPA.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0126_CAPA.InitControls:222:3 ACT:) |
| WK-SCP0126-0770 | X-ROW | SCP0126_CAPA.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0126_CAPA.InitSpread ACT:SCP0126_) |
| WK-SCP0126-0771 | X-ROW | SCP0126_CAPA.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA.InsertButton) |
| WK-SCP0126-0772 | X-ROW | SCP0126_CAPA.Insert_Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.Insert_Row: 진입점 집계 16검사 — NOT_RUN:16 (미실행 검사가 남아 판정필요) |  | 43 (ACT:SCP0126_CAPA.Insert_Row ACT:SCP0126_) |
| WK-SCP0126-0773 | X-ROW | SCP0126_CAPA.RefreshLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.RefreshLine: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0126_CAPA.RefreshLine ACT:SCP0126) |
| WK-SCP0126-0774 | X-ROW | SCP0126_CAPA.RefreshLineByCombo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.RefreshLineByCombo: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/GRID_SET/LOCAL, 연결된 요 |  | 13 (ACT:SCP0126_CAPA.RefreshLineByCombo ACT:) |
| WK-SCP0126-0775 | X-ROW | SCP0126_CAPA.RefreshLineTypeByCombo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.RefreshLineTypeByCombo: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/LOCAL, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0126_CAPA.RefreshLineTypeByCombo ) |
| WK-SCP0126-0776 | X-ROW | SCP0126_CAPA.RefreshOperationByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.RefreshOperationByDivision: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/GRID_SET/LOCAL, 연결된 요소 |  | 9 (ACT:SCP0126_CAPA.RefreshOperationByDivis) |
| WK-SCP0126-0777 | X-ROW | SCP0126_CAPA.RefreshPlanGroupByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.RefreshPlanGroupByDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0126_CAPA.RefreshPlanGroupByDivis) |
| WK-SCP0126-0778 | X-ROW | SCP0126_CAPA.RefreshPlantIdByCombo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.RefreshPlantIdByCombo: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/GRID_SET/LOCAL, 연결 |  | 17 (ACT:SCP0126_CAPA.RefreshPlantIdByCombo A) |
| WK-SCP0126-0779 | X-ROW | SCP0126_CAPA.RefreshPlantIdByDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.RefreshPlantIdByDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0126_CAPA.RefreshPlantIdByDivisio) |
| WK-SCP0126-0780 | X-ROW | SCP0126_CAPA.Save_DailyCapa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.Save_DailyCapa: 진입점 집계 25검사 — NOT_RUN:15 · PASS:10 (미실행 검사가 남아 판정필요) |  | 174 (ACT:SCP0126_CAPA.Save_DailyCapa ACT:SCP0) |
| WK-SCP0126-0781 | X-ROW | SCP0126_CAPA.Save_NoWork | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.Save_NoWork: 진입점 집계 28검사 — NOT_RUN:18 · PASS:10 (미실행 검사가 남아 판정필요) |  | 165 (ACT:SCP0126_CAPA.Save_NoWork ACT:SCP0126) |
| WK-SCP0126-0782 | X-ROW | SCP0126_CAPA.Save_NoWork_Week | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.Save_NoWork_Week: 진입점 집계 25검사 — NOT_RUN:15 · PASS:10 (미실행 검사가 남아 판정필요) |  | 107 (ACT:SCP0126_CAPA.Save_NoWork_Week ACT:SC) |
| WK-SCP0126-0783 | X-ROW | SCP0126_CAPA.Save_PrepRt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.Save_PrepRt: 진입점 집계 27검사 — NOT_RUN:17 · PASS:10 (미실행 검사가 남아 판정필요) |  | 154 (ACT:SCP0126_CAPA.Save_PrepRt ACT:SCP0126) |
| WK-SCP0126-0784 | X-ROW | SCP0126_CAPA.Save_Rampup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.Save_Rampup: 진입점 집계 27검사 — NOT_RUN:17 · PASS:10 (미실행 검사가 남아 판정필요) |  | 181 (ACT:SCP0126_CAPA.Save_Rampup ACT:SCP0126) |
| WK-SCP0126-0785 | X-ROW | SCP0126_CAPA.Save_Rampup_Itvl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.Save_Rampup_Itvl: 진입점 집계 25검사 — NOT_RUN:15 · PASS:10 (미실행 검사가 남아 판정필요) |  | 187 (ACT:SCP0126_CAPA.Save_Rampup_Itvl ACT:SC) |
| WK-SCP0126-0786 | X-ROW | SCP0126_CAPA.Save_SopEop | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.Save_SopEop: 진입점 집계 25검사 — NOT_RUN:15 · PASS:10 (미실행 검사가 남아 판정필요) |  | 145 (ACT:SCP0126_CAPA.Save_SopEop ACT:SCP0126) |
| WK-SCP0126-0787 | X-ROW | SCP0126_CAPA.Save_UtilRt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.Save_UtilRt: 진입점 집계 27검사 — NOT_RUN:17 · PASS:10 (미실행 검사가 남아 판정필요) |  | 154 (ACT:SCP0126_CAPA.Save_UtilRt ACT:SCP0126) |
| WK-SCP0126-0788 | X-ROW | SCP0126_CAPA.Save_YieldElec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.Save_YieldElec: 진입점 집계 25검사 — NOT_RUN:15 · PASS:10 (미실행 검사가 남아 판정필요) |  | 116 (ACT:SCP0126_CAPA.Save_YieldElec ACT:SCP0) |
| WK-SCP0126-0789 | X-ROW | SCP0126_CAPA.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA.SetChangedControl) |
| WK-SCP0126-0790 | X-ROW | SCP0126_CAPA.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA.SetSpreadInit) |
| WK-SCP0126-0791 | X-ROW | SCP0126_CAPA.SetVisibleSearchControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.SetVisibleSearchControls: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0126_CAPA.SetVisibleSearchControl) |
| WK-SCP0126-0792 | X-ROW | SCP0126_CAPA.SpdMain_ActiveSheetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.SpdMain_ActiveSheetChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA.SpdMain_ActiveSheetChan) |
| WK-SCP0126-0793 | X-ROW | SCP0126_CAPA.SpdMain_ActiveSheetChanging | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.SpdMain_ActiveSheetChanging: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0126_CAPA.SpdMain_ActiveSheetChan) |
| WK-SCP0126-0794 | X-ROW | SCP0126_CAPA.SpdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.SpdMain_CellClick: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 26 (ACT:SCP0126_CAPA.SpdMain_CellClick ACT:S) |
| WK-SCP0126-0795 | X-ROW | SCP0126_CAPA.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.SpdMain_CellDoubleClick: 진입점 집계 22검사 — NOT_RUN:13 · NOPATH:6 · REVIEW:3 |  | 6 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0796 | X-ROW | SCP0126_CAPA.SpdMain_ClipboardPasted | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.SpdMain_ClipboardPasted: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA.SpdMain_ClipboardPasted) |
| WK-SCP0126-0797 | X-ROW | SCP0126_CAPA.SpdMain_ComboSelChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.SpdMain_ComboSelChange: 진입점 집계 18검사 — NOT_RUN:15 · REVIEW:3 |  | 5 (ACT:SCP0126_CAPA.SpdMain_ComboSelChange:) |
| WK-SCP0126-0798 | X-ROW | SCP0126_CAPA._defaultDataModel_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA._defaultDataModel_Changed: 진입점 집계 9검사 — NOT_RUN:6 · REVIEW:3 |  | 1 (ACT:SCP0126_CAPA._defaultDataModel_Chang) |
| WK-SCP0126-0799 | X-ROW | SCP0126_CAPA.cboBucketType_SelectedIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_CAPA.cboBucketType_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0126_CAPA.cboBucketType_SelectedI) |
| WK-SCP0126-0800 | X-ROW | SCP0126_NoWork_BatchPopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_NoWork_BatchPopup..ctor:92:1) |
| WK-SCP0126-0801 | X-ROW | SCP0126_NoWork_BatchPopup.ClbScmSite_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.ClbScmSite_SelectedIndex: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_NoWork_BatchPopup.ClbScmSite) |
| WK-SCP0126-0802 | X-ROW | SCP0126_NoWork_BatchPopup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0126_NoWork_BatchPopup.CreateSpre) |
| WK-SCP0126-0803 | X-ROW | SCP0126_NoWork_BatchPopup.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_NoWork_BatchPopup.DefineProp) |
| WK-SCP0126-0804 | X-ROW | SCP0126_NoWork_BatchPopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0126_NoWork_BatchPopup.Dispose:16) |
| WK-SCP0126-0805 | X-ROW | SCP0126_NoWork_BatchPopup.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.EditButton: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0126_NoWork_BatchPopup.EditButton) |
| WK-SCP0126-0806 | X-ROW | SCP0126_NoWork_BatchPopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_NoWork_BatchPopup.FindButton) |
| WK-SCP0126-0807 | X-ROW | SCP0126_NoWork_BatchPopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.FindData: 진입점 집계 5검사 — REVIEW:3 · NOT_RUN:2 |  | 21 (ACT:SCP0126_NoWork_BatchPopup.FindData:2) |
| WK-SCP0126-0808 | X-ROW | SCP0126_NoWork_BatchPopup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0126_NoWork_BatchPopup.Form_Load ) |
| WK-SCP0126-0809 | X-ROW | SCP0126_NoWork_BatchPopup.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.GetDayRange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0126_NoWork_BatchPopup.GetDayRang) |
| WK-SCP0126-0810 | X-ROW | SCP0126_NoWork_BatchPopup.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.GetDivision: 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0126_NoWork_BatchPopup.GetDivisio) |
| WK-SCP0126-0811 | X-ROW | SCP0126_NoWork_BatchPopup.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.GetSearchInfo: 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0126_NoWork_BatchPopup.GetSearchI) |
| WK-SCP0126-0812 | X-ROW | SCP0126_NoWork_BatchPopup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.InitControls: 진입점 집계 12검사 — NOT_RUN:12 (미실행 검사가 남아 판정필요) |  | 17 (ACT:SCP0126_NoWork_BatchPopup.InitContro) |
| WK-SCP0126-0813 | X-ROW | SCP0126_NoWork_BatchPopup.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.InitEvent: 진입점 집계 5검사 — NOT_RUN:4 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_NoWork_BatchPopup.InitEvent:) |
| WK-SCP0126-0814 | X-ROW | SCP0126_NoWork_BatchPopup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.InitSpread: 진입점 집계 22검사 — NOT_RUN:22 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0126_NoWork_BatchPopup.InitSpread) |
| WK-SCP0126-0815 | X-ROW | SCP0126_NoWork_BatchPopup.RefreshLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.RefreshLine: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0126_NoWork_BatchPopup.RefreshLin) |
| WK-SCP0126-0816 | X-ROW | SCP0126_NoWork_BatchPopup.SCP0126_NoWork | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.SCP0126_NoWork_BatchPopu: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_NoWork_BatchPopup.SCP0126_No) |
| WK-SCP0126-0817 | X-ROW | SCP0126_NoWork_BatchPopup.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.SaveButton: 진입점 집계 5검사 — NOT_RUN:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0126_NoWork_BatchPopup.SaveButton) |
| WK-SCP0126-0818 | X-ROW | SCP0126_NoWork_BatchPopup.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.SaveData: 진입점 집계 13검사 — NOT_RUN:10 · NOPATH:2 · PASS:1 (미실행 검사가 남아 판정필요) |  | 82 (ACT:SCP0126_NoWork_BatchPopup.SaveData:3) |
| WK-SCP0126-0819 | X-ROW | SCP0126_NoWork_BatchPopup.SpdMain_CellCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.SpdMain_CellClick: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0126_NoWork_BatchPopup.SpdMain_Ce) |
| WK-SCP0126-0820 | X-ROW | SCP0126_NoWork_BatchPopup.btnButtonList_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_NoWork_BatchPopup.btnButtonList_UsrButtonL: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0126_NoWork_BatchPopup.btnButtonL) |
| WK-SCP0126-0821 | X-ROW | SCP0126_SingleDatePopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0126_SingleDatePopup..ctor:94:1 A) |
| WK-SCP0126-0822 | X-ROW | SCP0126_SingleDatePopup.AddGridViewColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.AddGridViewColumns: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 28 (ACT:SCP0126_SingleDatePopup.AddGridViewC) |
| WK-SCP0126-0823 | X-ROW | SCP0126_SingleDatePopup.ChangeCurrentCel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.ChangeCurrentCell: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0126_SingleDatePopup.ChangeCurren) |
| WK-SCP0126-0824 | X-ROW | SCP0126_SingleDatePopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0126_SingleDatePopup.Dispose:18:1) |
| WK-SCP0126-0825 | X-ROW | SCP0126_SingleDatePopup.FillCells | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.FillCells: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 70 (ACT:SCP0126_SingleDatePopup.FillCells AC) |
| WK-SCP0126-0826 | X-ROW | SCP0126_SingleDatePopup.FillComboxes | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.FillComboxes: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0126_SingleDatePopup.FillComboxes) |
| WK-SCP0126-0827 | X-ROW | SCP0126_SingleDatePopup.FirstDayOfMonth | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.FirstDayOfMonth: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_SingleDatePopup.FirstDayOfMo) |
| WK-SCP0126-0828 | X-ROW | SCP0126_SingleDatePopup.GetIso8601WeekOf | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.GetIso8601WeekOfYear: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0126_SingleDatePopup.GetIso8601We) |
| WK-SCP0126-0829 | X-ROW | SCP0126_SingleDatePopup.NextPrevMonth | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.NextPrevMonth: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0126_SingleDatePopup.NextPrevMont) |
| WK-SCP0126-0830 | X-ROW | SCP0126_SingleDatePopup.SelectCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.SelectCell: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0126_SingleDatePopup.SelectCell A) |
| WK-SCP0126-0831 | X-ROW | SCP0126_SingleDatePopup.btnCancel_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.btnCancel_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_SingleDatePopup.btnCancel_Cl) |
| WK-SCP0126-0832 | X-ROW | SCP0126_SingleDatePopup.btnOK_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.btnOK_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0126_SingleDatePopup.btnOK_Click:) |
| WK-SCP0126-0833 | X-ROW | SCP0126_SingleDatePopup.btn_NextMonth_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.btn_NextMonth_Click: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0126_SingleDatePopup.btn_NextMont) |
| WK-SCP0126-0834 | X-ROW | SCP0126_SingleDatePopup.btn_PrevMonth_Cl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.btn_PrevMonth_Click: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0126_SingleDatePopup.btn_PrevMont) |
| WK-SCP0126-0835 | X-ROW | SCP0126_SingleDatePopup.cmb_Months_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.cmb_Months_SelectedIndexCh: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0126_SingleDatePopup.cmb_Months_S) |
| WK-SCP0126-0836 | X-ROW | SCP0126_SingleDatePopup.cmb_Years_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.cmb_Years_SelectedIndexCha: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0126_SingleDatePopup.cmb_Years_Se) |
| WK-SCP0126-0837 | X-ROW | SCP0126_SingleDatePopup.dgvDates_CellEnt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.dgvDates_CellEnter: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0126_SingleDatePopup.dgvDates_Cel) |
| WK-SCP0126-0838 | X-ROW | SCP0126_SingleDatePopup.dgv_Dates_MouseD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.dgv_Dates_MouseDoubleClick: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_SingleDatePopup.dgv_Dates_Mo) |
| WK-SCP0126-0839 | X-ROW | SCP0126_SingleDatePopup.dgv_Dates_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.dgv_Dates_SelectionChanged: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 43 (ACT:SCP0126_SingleDatePopup.dgv_Dates_Se) |
| WK-SCP0126-0840 | X-ROW | SCP0126_SingleDatePopup.exitButton_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.exitButton_Click: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_SingleDatePopup.exitButton_C) |
| WK-SCP0126-0841 | X-ROW | SCP0126_SingleDatePopup.frmDatePicker_Lo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.frmDatePicker_Load: 진입점 집계 8검사 — NOT_RUN:4 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 20 (ACT:SCP0126_SingleDatePopup.frmDatePicke) |
| WK-SCP0126-0842 | X-ROW | SCP0126_SingleDatePopup.frmDatePicker_Pa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.frmDatePicker_Paint: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0126_SingleDatePopup.frmDatePicke) |
| WK-SCP0126-0843 | X-ROW | SCP0126_SingleDatePopup.lbl_Today_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.lbl_Today_Click: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0126_SingleDatePopup.lbl_Today_Cl) |
| WK-SCP0126-0844 | X-ROW | SCP0126_SingleDatePopup.tr_Mins_Scroll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0126_SingleDatePopup.tr_Mins_Scroll: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0126_SingleDatePopup.tr_Mins_Scro) |
| WK-SCP0126-0845 | X-ROW | `ROUTE_PATH` `'supply/opt-plan/opt-capa' | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `ROUTE_PATH` `'supply/opt-plan/opt-capa'` → `'supp: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`ROUTE_PATH` `'supply/opt-plan/opt-capa') |
| WK-SCP0126-0846 | X-ROW | cs:731 `IndexOf("EE_UC")>=0` → 4컬럼 표시 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — cs:731 `IndexOf("EE_UC")>=0` → 4컬럼 표시: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (cs:731 `IndexOf("EE_UC")>=0` → 4컬럼 표시) |
| WK-SCP0126-0847 | X-ROW | cs:746 else → CAPA 만 표시 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — cs:746 else → CAPA 만 표시: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (cs:746 else → CAPA 만 표시) |
| WK-SCP0126-0848 | X-ROW | hook #68 (신규행 콤보 PARAM9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — hook #68 (신규행 콤보 PARAM9): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (hook #68 (신규행 콤보 PARAM9)) |
| WK-SCP0126-0849 | X-ROW | hook #81 (탭 구동 lazy fetch) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — hook #81 (탭 구동 lazy fetch): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (hook #81 (탭 구동 lazy fetch)) |
| WK-SCP0126-0850 | X-ROW | hook #92 (`DIVISION_ID` 콤마토큰 구방식) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — hook #92 (`DIVISION_ID` 콤마토큰 구방식): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (hook #92 (`DIVISION_ID` 콤마토큰 구방식)) |
| WK-SCP0126-0851 | G5 | MODAL:NoWorkExcelUploadModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:NoWorkExcelUploadModal: 행 집계 — G5 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:NoWorkExcelUploadModal) |
| WK-SCP0126-0852 | G5 | SCP0126_CAPA.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0126_CAPA.SpdMain_CellDoubleClick: 진입점 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0853 | H6 | MODAL:NoWorkExcelUploadModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:NoWorkExcelUploadModal: 행 집계 — H6 6요소: NOPATH:4 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:NoWorkExcelUploadModal) |
| WK-SCP0126-0854 | H6 | SCP0126_CAPA.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0126_CAPA.SpdMain_CellDoubleClick: 진입점 집계 — H6 4요소: NOPATH:2 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |
| WK-SCP0126-0855 | M4 | MODAL:NoWorkExcelUploadModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:NoWorkExcelUploadModal: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:NoWorkExcelUploadModal) |
| WK-SCP0126-0856 | M4 | SCP0126_CAPA.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0126_CAPA.SpdMain_CellDoubleClick: 진입점 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0126_CAPA.SpdMain_CellDoubleClick) |

## W8 구현 후 검증 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0126-0857 | D4 | I-1 | 선행 W1 완료 후 E2E | D4 — 대조표 미구현 행 I-1 구현 후 검증 · 대상 I-1 |  | 1 (I-1) |
| WK-SCP0126-0858 | X-ROW | I-2 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행 I-2 구현 후 검증 · 대상 I-2 |  | 1 (I-2) |
