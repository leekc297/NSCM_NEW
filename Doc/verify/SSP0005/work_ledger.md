# 작업 원장 — SSP0005 · 2026-11-14 22:31

> 검사 인스턴스 425건 중 PASS·NA 242건 외 **183건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 5 | 재판정 PASS |
| W5 | 검사기 연결 | 7 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 57 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 114 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 114 · 사람 판정 / AS-IS 원문 확인 → 재판정 36 · 대조표 21 · 하네스 7 · 사람판정 3 · 화면 FE 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-REASON | DESIGN |  |  |  |  |  |  | 21 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | GEN |  |  |  |  |  |  | 18 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-LOC | GEN |  |  |  |  |  |  | 15 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G1 | GEN |  |  |  |  |  |  |  |  | 14 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| X-ROW | GEN |  |  | 2 |  |  |  |  |  | 10 | 대조표 행이 서술한 동작을 화면에서 재현 |
| D3 | EDIT |  |  |  |  |  |  |  |  | 12 | 행 값 기반 조건부 잠금 |
| D4 | EDIT |  |  |  |  |  |  |  |  | 11 | 신규행 기본값·자동세팅·Insert 전제 |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 10 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| D1 | EDIT |  |  |  |  |  |  |  |  | 9 | 컬럼 편집 가능 여부(신규행·기존행) |
| E4 | EDIT |  |  |  |  |  |  |  |  | 9 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| B3 | COMBO |  |  |  |  | 3 |  |  |  | 4 | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 2 |  |  |  | 5 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| H5 | DESIGN |  |  |  |  |  |  |  |  | 7 | 라벨 명칭 |
| A6 | GEN |  |  | 3 |  |  |  | 1 |  | 2 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 6 | 연쇄 자동 채움 |
| F4 | DB |  |  |  |  |  |  |  |  | 4 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 1 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G4 | DESIGN |  |  |  |  | 1 |  |  |  |  | 조회조건 표시·라벨·활성 |
| SC1 | DESIGN |  |  |  |  |  |  | 1 |  |  | 조회조건 순서 = 기준표 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  |  |  |  | 1 | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  |  |  |  | 1 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |

## W3 동작 수정 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0001 | A6 | B03 | 사람판정(사람판정 대기) | A6 FAIL 수정 — B03: 행 집계 — 대조표 B03 '`Data.Common(Data.Type.LookupCommon, false, "WEEK_' 의 A6 4요소: ERROR:2 · FAIL:1 · NOT_RUN:1 · FAI |  | 1 (B03) |
| WK-SSP0005-0002 | A6 | PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKI | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY: 원장 V-1b666fe8 SP / 원장 V-4089d95c SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['S |  | 36 (S01 ACT:SSP0005_ShipmentWorkingDay.FindB) |
| WK-SSP0005-0003 | A6 | U01 | 사람판정(사람판정 대기) | A6 FAIL 수정 — U01: 행 집계 — 대조표 U01 '`ProgressForm`(FindData_Main) cs:372' 의 A6 4요소: ERROR:2 · FAIL:1 · NOT_RUN:1 · FAIL 요소: PKG_SSP0 |  | 1 (U01) |
| WK-SSP0005-0004 | X-ROW | SSP0005_ShipmentWorkingDay.FindButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0005_ShipmentWorkingDay.FindButton: 진입점 집계 6검사 — PASS:2 · ERROR:2 · REVIEW:1 · FAIL:1 (FX-SSP0005-032) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.FindButto) |
| WK-SSP0005-0005 | X-ROW | SSP0005_ShipmentWorkingDay.FindData_Main | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0005_ShipmentWorkingDay.FindData_Main: 진입점 집계 14검사 — PASS:7 · ERROR:3 · NA:2 · REVIEW:1 · FAIL:1 (FX-SSP0005-03 |  | 7 (ACT:SSP0005_ShipmentWorkingDay.FindData_) |

## W5 검사기 연결 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0006 | B3 | COLUMN_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL COLUMN_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0005_ShipmentWorkingDay.GetDayOfW) |
| WK-SSP0005-0007 | B3 | DAY_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL DAY_CODE | 있음(FE 소스) | 2 (ACT:SSP0005_ShipmentWorkingDay.GetDayOfW) |
| WK-SSP0005-0008 | B3 | cboDayWeek / Day of the week / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND cboDayWeek / Day of the week / Day Week | 있음(FE 소스) | 1 (C16) |
| WK-SSP0005-0009 | B4 | COLUMN_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL COLUMN_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0005_ShipmentWorkingDay.GetDayOfW) |
| WK-SSP0005-0010 | B4 | DAY_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DAY_CODE | 있음(FE 소스) | 2 (ACT:SSP0005_ShipmentWorkingDay.GetDayOfW) |
| WK-SSP0005-0011 | DB-SYN | P_SSP0005_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SSP0005_GET | 없음(PROC_M 대응 없음) | 1 (S01) |
| WK-SSP0005-0012 | G4 | btnInput | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnInput | 있음(FE 소스) | 3 (C12 ACT:SSP0005_ShipmentWorkingDay.InitE) |

## W7 기대값 확정 (57)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0013 | SC1 | SSP0005 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | SC1 기대값 확정 — SSP0005 화면: 원장 V-d0e01e7d RULE_SCREEN / 원장 V-d77fd8e5 CONFIRMED / E2E smoke cond order / 게이트 SC2 기준표가 BUTTON_AREA(조회조 |  | 4 (C09 C12 B04 Δ6) |
| WK-SSP0005-0014 | X-REASON | A05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A05 `UnFilterInsertRow = true` cs:124 Insert 가 NO-OP 라 신규행이 생기지 않아 실효 없음. 컬럼셋은 조회 발사 시점 스냅샷으로만 재구성 미이식(실효 없음) |  | 1 (A05) |
| WK-SSP0005-0015 | X-REASON | A06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A06 저장 대상 = action AND 글자색 Red cs:491-492 **색상 축 폐기** — `CRUD_TYPE`(EditTracker) 단일 축. btnInput 도 `storeChange` |  | 1 (A06) |
| WK-SSP0005-0016 | X-REASON | A07 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A07 `iCount==0` 시 첫/끝 행 플래그 cs:514-515 **미이식 — AS-IS 결함 재현 금지.** `if (iCount>0)` 밖에서 `Rows[0]`/`Rows[iCount-1]` |  | 1 (A07) |
| WK-SSP0005-0017 | X-REASON | A09 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — A09 `DefineProperty()` 빈 본문 cs:142-144 대응물 없음 미이식(해당 없음) |  | 1 (A09) |
| WK-SSP0005-0018 | X-REASON | C10 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — C10 `emptySpaceItem1` dsn:420-426 여백 전용 — React 대응물 없음(Grid 잔여 칸이 등가) 미이식(해당 없음) |  | 1 (C10) |
| WK-SSP0005-0019 | X-REASON | C11 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — C11 `emptySpaceItem2` dsn:348-354 동일 — 여백 전용 미이식(해당 없음) |  | 1 (C11) |
| WK-SSP0005-0020 | X-REASON | C20 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — C20 `components`(Container) dsn:31 WinForms 인프라 — 대응물 없음 미이식(해당 없음) |  | 1 (C20) |
| WK-SSP0005-0021 | X-REASON | D08 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D08 `ds == null` cs:730 **구조 복제 금지 — AS-IS 잠재 결함.** 직전 cs:725 가 `dsdm.Changed -=` 를 실행한 뒤라 여기서 return 하면 핸들러가 영 |  | 1 (D08) |
| WK-SSP0005-0022 | X-REASON | D09 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D09 `!CanModelChange`(Changed) cs:873 E04 미이식에 포함 미이식(근거 기재) |  | 1 (D09) |
| WK-SSP0005-0023 | X-REASON | D10 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D10 `ds == null`(Changed) cs:885 동일. `finally { dt.AcceptChanges() }` 가 `dt` null 이면 NRE — 복제 금지 미이식(결함 재현 금지) |  | 1 (D10) |
| WK-SSP0005-0024 | X-REASON | E04 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — E04 `SpdMain_Changed` cs:872-907 **미이식** — `case CellsUpdated:` 본문이 비어 있어 실효 로직 0. 남은 것은 FarPoint 전용 재귀 방지/`Acc |  | 1 (E04) |
| WK-SSP0005-0025 | X-REASON | G09 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G09 `SwitchLock`(EditButton) cs:353 **미이식** — 편집모드 토글 폐기(convert-core §2.4). `canEdit = hasButton('EDIT')` 단일 축 |  | 1 (G09) |
| WK-SSP0005-0026 | X-REASON | G12 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G12 `LockColumn(0, max, true)`(조회 직후 전열 잠금) cs:420 **미이식** — G09 와 같은 축. 그대로 옮기면 편집이 영구 차단된다 미이식(근거 기재) |  | 1 (G12) |
| WK-SSP0005-0027 | X-REASON | G15 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G15 `GetModelColumnFromViewColumn`(cRow) cs:742 **미이식(사문)** — 산출값 `cRow`/`cCol` 이 이후 한 번도 쓰이지 않는다(cs:744 이후 전부  |  | 1 (G15) |
| WK-SSP0005-0028 | X-REASON | G16 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G16 `GetModelColumnFromViewColumn`(cCol) cs:743 동일 미이식(근거 기재) |  | 1 (G16) |
| WK-SSP0005-0029 | X-REASON | G22 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G22 `Visible=`(`M_` → `W_` 토글) cs:840 **미이식(사문)** — E03 동일 근거 미이식(근거 기재) |  | 1 (G22) |
| WK-SSP0005-0030 | X-REASON | G23 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G23 `Visible=`(`M_` → `D_` 숨김) cs:843 동일 미이식(근거 기재) |  | 1 (G23) |
| WK-SSP0005-0031 | X-REASON | G24 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — G24 `Visible=`(`W_` → `D_` 토글) cs:854 동일 미이식(근거 기재) |  | 1 (G24) |
| WK-SSP0005-0032 | X-REASON | P08 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — P08 `SpdMain_CellDoubleClick` cs:834 미이식(E03 사문) 미이식(근거 기재) |  | 1 (P08) |
| WK-SSP0005-0033 | X-REASON | P09 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — P09 `SpdMain_Changed` cs:872 미이식(E04 본문 공란) 미이식(근거 기재) |  | 1 (P09) |
| WK-SSP0005-0034 | X-REASON | V07 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — V07 `MSG00050` 숫자 형식 cs:714 **미이식 — 도달 불가.** `try` 블록(cs:708-717)에 숫자 파싱이 없어 `FormatException` 이 발생할 수 없다 미이식(근 |  | 1 (V07) |
| WK-SSP0005-0035 | A1 | A02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A02: 행 집계 — 대조표 A02 '필수값 검증 2건 cs:377·456' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — gol |  | 1 (A02) |
| WK-SSP0005-0036 | A1 | A04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A04: 행 집계 — 대조표 A04 'Division 권한 게이트 cs:161-162' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP |  | 1 (A04) |
| WK-SSP0005-0037 | A1 | A15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A15: 행 집계 — 대조표 A15 '`GetDayOfWeek` = dsSpdTitle 역조회 cs:824-830' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_ |  | 1 (A15) |
| WK-SSP0005-0038 | A1 | B03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B03: 행 집계 — 대조표 B03 '`Data.Common(Data.Type.LookupCommon, false, "WEEK_' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SS |  | 1 (B03) |
| WK-SSP0005-0039 | A1 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B04: 행 집계 — 대조표 B04 '`Data.Common(YesOrNo)` cs:48' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SH |  | 1 (B04) |
| WK-SSP0005-0040 | A1 | C09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — C09: 행 집계 — 대조표 C09 '`layoutControlItem10`(TextVisible=false)' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SS |  | 1 (C09) |
| WK-SSP0005-0041 | A1 | C12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — C12: 행 집계 — 대조표 C12 '`btnInput`' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — golden DIFF A |  | 1 (C12) |
| WK-SSP0005-0042 | A1 | D01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D01: 행 집계 — 대조표 D01 '`Columns.Get(0).Visible == false`' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_G |  | 1 (D01) |
| WK-SSP0005-0043 | A1 | G13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G13: 행 집계 — 대조표 G13 '`SmartColMerge`(조회 후)' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — go |  | 1 (G13) |
| WK-SSP0005-0044 | A1 | P01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P01: 행 집계 — 대조표 P01 '`FindButton` cs:330' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — gold |  | 1 (P01) |
| WK-SSP0005-0045 | A1 | PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY: golden DIFF AS-IS 0행 ↔ TO-BE 0행: Doc/golden/SSP0005/SSP0005_GET_SHIPME |  | 36 (S01 ACT:SSP0005_ShipmentWorkingDay.FindB) |
| WK-SSP0005-0046 | A1 | P_SSP0005_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0005_GET: 골든 비교 케이스 없음(P_SSP0005_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (S01) |
| WK-SSP0005-0047 | A1 | U01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — U01: 행 집계 — 대조표 U01 '`ProgressForm`(FindData_Main) cs:372' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP000 |  | 1 (U01) |
| WK-SSP0005-0048 | A1 | V04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — V04: 행 집계 — 대조표 V04 '`MSG00135` 편집모드 아님' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — golde |  | 1 (V04) |
| WK-SSP0005-0049 | A1 | Δ1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Δ1: 행 집계 — 대조표 Δ1 '`Period*` 빈값 조회 **차단**' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — gol |  | 1 (Δ1) |
| WK-SSP0005-0050 | A1 | Δ11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Δ11: 행 집계 — 대조표 Δ11 '붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SS |  | 1 (Δ11) |
| WK-SSP0005-0051 | A1 | Δ6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Δ6: 행 집계 — 대조표 Δ6 '빈 `D_` 셀 변경건 전송 제외' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — golden  |  | 1 (Δ6) |
| WK-SSP0005-0052 | A1 | Δ9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Δ9: 행 집계 — 대조표 Δ9 '`Company` 빈값 조회 **차단**(gap-resolve iter-1 신설)' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P |  | 1 (Δ9) |
| WK-SSP0005-0053 | A6 | P_SSP0005_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — P_SSP0005_GET: 검증 엔진이 실행됐으나 이 대상(SP P_SSP0005_GET)을 판정하지 못함 — 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · |  | 1 (S01) |
| WK-SSP0005-0054 | G03-WIRE | SSP0005 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SSP0005 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 / 게이트 G03 As-is 이벤트 spdMain.CellDoubleClick → SpdM  |  | 13 (ACT:SSP0005_ShipmentWorkingDay..ctor ACT) |
| WK-SSP0005-0055 | X-LOC | B01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — B01: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (B01) |
| WK-SSP0005-0056 | X-LOC | B03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — B03: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (B03) |
| WK-SSP0005-0057 | X-LOC | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — B04: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (B04) |
| WK-SSP0005-0058 | X-LOC | Δ1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ1) |
| WK-SSP0005-0059 | X-LOC | Δ10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ10) |
| WK-SSP0005-0060 | X-LOC | Δ11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ11) |
| WK-SSP0005-0061 | X-LOC | Δ2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ2) |
| WK-SSP0005-0062 | X-LOC | Δ3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ3) |
| WK-SSP0005-0063 | X-LOC | Δ4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ4) |
| WK-SSP0005-0064 | X-LOC | Δ5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ5) |
| WK-SSP0005-0065 | X-LOC | Δ6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ6) |
| WK-SSP0005-0066 | X-LOC | Δ7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ7) |
| WK-SSP0005-0067 | X-LOC | Δ8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ8) |
| WK-SSP0005-0068 | X-LOC | Δ9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ9) |
| WK-SSP0005-0069 | X-LOC | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — —: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (—) |

## W9 도구 오류 (114)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0070 | J2 | SSP0005 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-f885dd85 RULE_SCREEN / 원장 V-85cb4be1 DEFECT / 원장 V-42616e24 GENERAL / 원장 V-5d5f56c6 GENERAL / 원장 V-83fd2b9b GENERA |  | 96 (C09 C12 V01 V02 V04 S02 B04 D01 G13 P01 ) |
| WK-SSP0005-0071 | C3 | DAY_CODE | 하네스·환경 | C3 도구 오류 — 실측[T-3e579fb8]: 조회 결과 0행 — 연쇄 측정 불가 |  | 1 (A15) |
| WK-SSP0005-0072 | C3 | P_FIRST_ROW | 하네스·환경 | C3 도구 오류 — 실측[T-94eb5239]: 조회 결과 0행 — 연쇄 측정 불가 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.SaveData_) |
| WK-SSP0005-0073 | C3 | P_LAST_ROW | 하네스·환경 | C3 도구 오류 — 실측[T-542b856c]: 조회 결과 0행 — 연쇄 측정 불가 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.SaveData_) |
| WK-SSP0005-0074 | C3 | SSP0005_ShipmentWorkingDay.CboDayWeek_Se | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0005_ShipmentWorkingDay.CboDayWeek_SelectedIndexChanged 의 C3 3요소: ERROR:3 |  | 5 (ACT:SSP0005_ShipmentWorkingDay.CboDayWee) |
| WK-SSP0005-0075 | C3 | SSP0005_ShipmentWorkingDay.SpdMain_Chang | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0005_ShipmentWorkingDay.SpdMain_Changed 의 C3 3요소: ERROR:3 |  | 12 (ACT:SSP0005_ShipmentWorkingDay.SpdMain_C) |
| WK-SSP0005-0076 | C3 | Δ11 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 Δ11 '붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설' 의 C3 3요소: ERROR:3 |  | 1 (Δ11) |
| WK-SSP0005-0077 | B3 | B03 | 하네스·환경 | B3 도구 오류 — 행 집계 — 대조표 B03 '`Data.Common(Data.Type.LookupCommon, false, "WEEK_' 의 B3 6요소: NOPATH:3 · PASS:1 · ERROR:1 · NA:1 |  | 1 (B03) |
| WK-SSP0005-0078 | B3 | B04 | 하네스·환경 | B3 도구 오류 — 행 집계 — 대조표 B04 '`Data.Common(YesOrNo)` cs:48' 의 B3 6요소: NOPATH:3 · PASS:1 · ERROR:1 · NA:1 |  | 1 (B04) |
| WK-SSP0005-0079 | B3 | COMPANY_ID / Company | 하네스·환경 | B3 도구 오류 — 원장 V-831acbe0 COLUMN |  | 1 (B02) |
| WK-SSP0005-0080 | B3 | SSP0005_ShipmentWorkingDay.GetDayRange | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 SSP0005_ShipmentWorkingDay.GetDayRange 의 B3 6요소: NOPATH:3 · PASS:1 · ERROR:1 · NA:1 |  | 5 (ACT:SSP0005_ShipmentWorkingDay.GetDayRan) |
| WK-SSP0005-0081 | B4 | B03 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 B03 '`Data.Common(Data.Type.LookupCommon, false, "WEEK_' 의 B4 6요소: NA:2 · NOPATH:2 · PASS:1 · ERROR:1 |  | 1 (B03) |
| WK-SSP0005-0082 | B4 | B04 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 B04 '`Data.Common(YesOrNo)` cs:48' 의 B4 6요소: NA:2 · NOPATH:2 · PASS:1 · ERROR:1 |  | 1 (B04) |
| WK-SSP0005-0083 | B4 | COMPANY_ID / Company | 하네스·환경 | B4 도구 오류 — 원장 V-2cb6636e COLUMN |  | 1 (B02) |
| WK-SSP0005-0084 | B4 | GC01 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 GC01 '`AddComboColumn(label, name, FPMerge.None, 70, tru' 의 B4 6요소: NA:2 · NOPATH:2 · PASS:1 · ERROR:1 |  | 1 (GC01) |
| WK-SSP0005-0085 | B4 | SSP0005_ShipmentWorkingDay.GetDayRange | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SSP0005_ShipmentWorkingDay.GetDayRange 의 B4 6요소: NA:2 · NOPATH:2 · PASS:1 · ERROR:1 |  | 5 (ACT:SSP0005_ShipmentWorkingDay.GetDayRan) |
| WK-SSP0005-0086 | K4 | SSP0005 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-99eb0d71 GENERAL / 원장 V-d8d564f4 GENERAL / 원장 V-e8f6c900 GENERAL / 원장 V-6df5c22d GENERAL / 원장 V-ceca4b3b GENERAL / |  | 68 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0087 | F1 | SSP0005 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-45ceb78a RULE_SCREEN / 원장 V-657eef0e RULE_SCREEN / 원장 V-f8bcc179 RULE_SCREEN / 원장 V-e4f681b2 RULE_SCREEN / 원장 V-f7 |  | 98 (V01 V02 S02 P03 P05 U02 A01 A02 A14 Δ3 Δ) |
| WK-SSP0005-0088 | F2 | SSP0005 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-5c9fabe3 RULE_SCREEN / 원장 V-75c9d6f8 RULE_SCREEN / 원장 V-25b2fb7e GENERAL / 원장 V-b54dd29c GENERAL / 원장 V-cdaae85a G |  | 95 (V01 V02 S02 P05 A01 A02 A14 Δ3 Δ4 ACT:SS) |
| WK-SSP0005-0089 | F3 | SSP0005 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-af14b50c RULE_SCREEN / 원장 V-6ac126ba RULE_SCREEN / 원장 V-a9a43704 GENERAL / 원장 V-7e36c00e GENERAL / 원장 V-5f46d3dc G |  | 1 (Δ11) |
| WK-SSP0005-0090 | F6 | SSP0005 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-2bc6b855 RULE_SCREEN / 원장 V-81b4003b RULE_SCREEN / 원장 V-400f4037 RULE_SCREEN / 원장 V-2c074ac3 RULE_SCREEN / 원장 V-a1 |  | 87 (U02 ACT:SSP0005_ShipmentWorkingDay.SaveB) |
| WK-SSP0005-0091 | F4 | B03 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 B03 '`Data.Common(Data.Type.LookupCommon, false, "WEEK_' 의 F4 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (B03) |
| WK-SSP0005-0092 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 하네스·환경 | F4 도구 오류 — E2E smoke call-proc / 실측[T-686bcc89]: PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: SCP0009/calendar/SEARCH, SCP0010/ |  | 118 (S03 ACT:SSP0005_ShipmentWorkingDay.FindB) |
| WK-SSP0005-0093 | F4 | U01 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 U01 '`ProgressForm`(FindData_Main) cs:372' 의 F4 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (U01) |
| WK-SSP0005-0094 | F4 | U02 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 U02 '`ProgressForm`(SaveData_Main) cs:438' 의 F4 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (U02) |
| WK-SSP0005-0095 | A5 | A17 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 A17 '`spdInfo` vs `siMain` 는 같은 시트' 의 A5 1요소: ERROR:1 |  | 1 (A17) |
| WK-SSP0005-0096 | A5 | B04 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 B04 '`Data.Common(YesOrNo)` cs:48' 의 A5 1요소: ERROR:1 |  | 1 (B04) |
| WK-SSP0005-0097 | A5 | C01 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 C01 '`usrConditionPanel1`(HidePanel)' 의 A5 1요소: ERROR:1 |  | 1 (C01) |
| WK-SSP0005-0098 | A5 | C09 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 C09 '`layoutControlItem10`(TextVisible=false)' 의 A5 1요소: ERROR:1 |  | 1 (C09) |
| WK-SSP0005-0099 | A5 | C18 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 C18 '`spdMain`(FpSpread)' 의 A5 1요소: ERROR:1 |  | 1 (C18) |
| WK-SSP0005-0100 | A5 | C19 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 C19 '`spdMain_Sheet1`(SheetView)' 의 A5 1요소: ERROR:1 |  | 1 (C19) |
| WK-SSP0005-0101 | A5 | D01 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D01 '`Columns.Get(0).Visible == false`' 의 A5 1요소: ERROR:1 |  | 1 (D01) |
| WK-SSP0005-0102 | A5 | DIVISION | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-cf1c437a]: DIVISION: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 3 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0103 | A5 | P02 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 P02 '`InsertButton` cs:335' 의 A5 1요소: ERROR:1 |  | 1 (P02) |
| WK-SSP0005-0104 | A5 | Δ11 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 Δ11 '붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설' 의 A5 1요소: ERROR:1 |  | 1 (Δ11) |
| WK-SSP0005-0105 | H10 | SSP0005 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 13 (C08 V01 V02 V03 V04 V05 V06 D01 D03 D05 ) |
| WK-SSP0005-0106 | H4 | SSP0005 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-909c64fd RULE_SCREEN / 원장 V-0a997734 RULE_SCREEN / 원장 V-edb955cc RULE_SCREEN / 원장 V-f2bd7c17 RULE_SCREEN / 원장 V-49 |  | 7 (E05 G08 P10 ACT:SSP0005_ShipmentWorkingD) |
| WK-SSP0005-0107 | H5 | A17 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 A17 '`spdInfo` vs `siMain` 는 같은 시트' 의 H5 1요소: ERROR:1 |  | 1 (A17) |
| WK-SSP0005-0108 | H5 | B04 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 B04 '`Data.Common(YesOrNo)` cs:48' 의 H5 1요소: ERROR:1 |  | 1 (B04) |
| WK-SSP0005-0109 | H5 | C18 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 C18 '`spdMain`(FpSpread)' 의 H5 1요소: ERROR:1 |  | 1 (C18) |
| WK-SSP0005-0110 | H5 | C19 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 C19 '`spdMain_Sheet1`(SheetView)' 의 H5 1요소: ERROR:1 |  | 1 (C19) |
| WK-SSP0005-0111 | H5 | DIVISION | 하네스·환경 | H5 도구 오류 — 실측[T-52caa56a]: DIVISION 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0112 | H5 | SSP0005_ShipmentWorkingDay.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SSP0005_ShipmentWorkingDay.CreateSpread 의 H5 1요소: ERROR:1 |  | 4 (ACT:SSP0005_ShipmentWorkingDay.CreateSpr) |
| WK-SSP0005-0113 | H5 | Δ11 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 Δ11 '붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설' 의 H5 1요소: ERROR:1 |  | 1 (Δ11) |
| WK-SSP0005-0114 | I1 | SSP0005 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-ffc58b3d RULE_SCREEN / 원장 V-d75aa24b RULE_SCREEN / 원장 V-c80a8e31 RULE_SCREEN / 원장 V-a7cfad14 DEFECT / 원장 V-963c6c0 |  | 20 (C08 V01 V02 V03 V04 V05 V06 D01 D03 D05 ) |
| WK-SSP0005-0115 | D1 | COMPANY | 하네스·환경 | D1 도구 오류 — 실측[T-a70c25ab]: 조회 결과 0행 — 기존행 프로브 불가 |  | 5 (G10 ACT:SSP0005_ShipmentWorkingDay.EditB) |
| WK-SSP0005-0116 | D1 | D01 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D01 '`Columns.Get(0).Visible == false`' 의 D1 3요소: ERROR:2 · NA:1 |  | 1 (D01) |
| WK-SSP0005-0117 | D1 | DIVISION | 하네스·환경 | D1 도구 오류 — 실측[T-bbab90dd]: 조회 결과 0행 — 기존행 프로브 불가 |  | 2 (G10 ACT:SSP0005_ShipmentWorkingDay.EditB) |
| WK-SSP0005-0118 | D1 | P04 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 P04 '`EditButton` cs:346' 의 D1 3요소: ERROR:2 · NA:1 |  | 1 (P04) |
| WK-SSP0005-0119 | D1 | P05 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 P05 '`SaveButton` cs:360' 의 D1 3요소: ERROR:2 · NA:1 |  | 1 (P05) |
| WK-SSP0005-0120 | D1 | SSP0005_ShipmentWorkingDay.EditButton | 하네스·환경 | D1 도구 오류 — 진입점 집계 — 대조표 SSP0005_ShipmentWorkingDay.EditButton 의 D1 2요소: ERROR:2 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.EditButto) |
| WK-SSP0005-0121 | D1 | V04 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 V04 '`MSG00135` 편집모드 아님' 의 D1 3요소: ERROR:2 · NA:1 |  | 1 (V04) |
| WK-SSP0005-0122 | D1 | Δ11 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 Δ11 '붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설' 의 D1 3요소: ERROR:2 · NA:1 |  | 1 (Δ11) |
| WK-SSP0005-0123 | D1 | Δ2 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 Δ2 '편집 기본 ON(모드 토글 미이식)' 의 D1 3요소: ERROR:2 · NA:1 |  | 1 (Δ2) |
| WK-SSP0005-0124 | D3 | COMPANY | 하네스·환경 | D3 도구 오류 — 원장 V-1f2690f4 ASIS / 실측[T-3ba36206]: COMPANY: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 5 (G10 ACT:SSP0005_ShipmentWorkingDay.EditB) |
| WK-SSP0005-0125 | D3 | COMPANY,DIVISION | 하네스·환경 | D3 도구 오류 — 원장 V-1f2690f4 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.EditButto) |
| WK-SSP0005-0126 | D3 | D01 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D01 '`Columns.Get(0).Visible == false`' 의 D3 4요소: ERROR:4 |  | 1 (D01) |
| WK-SSP0005-0127 | D3 | DIVISION | 하네스·환경 | D3 도구 오류 — 원장 V-1f2690f4 ASIS / 실측[T-661b63bd]: DIVISION: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 2 (G10 ACT:SSP0005_ShipmentWorkingDay.EditB) |
| WK-SSP0005-0128 | D3 | P04 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 P04 '`EditButton` cs:346' 의 D3 4요소: ERROR:4 |  | 1 (P04) |
| WK-SSP0005-0129 | D3 | P05 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 P05 '`SaveButton` cs:360' 의 D3 4요소: ERROR:4 |  | 1 (P05) |
| WK-SSP0005-0130 | D3 | SSP0005_ShipmentWorkingDay.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-4a7ffdbe ASIS / 원장 V-1f2690f4 ASIS |  | 1 (ACT:SSP0005_ShipmentWorkingDay.EditButto) |
| WK-SSP0005-0131 | D3 | V04 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 V04 '`MSG00135` 편집모드 아님' 의 D3 4요소: ERROR:4 |  | 1 (V04) |
| WK-SSP0005-0132 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-4a7ffdbe |  | 1 (ACT:SSP0005_ShipmentWorkingDay.EditButto) |
| WK-SSP0005-0133 | D3 | Δ10 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 Δ10 '툴바 `Insert`/`Delete` NO-OP 노출을 **버튼 권한 축으로 게이트**(g' 의 D3 4요소: ERROR:4 |  | 1 (Δ10) |
| WK-SSP0005-0134 | D3 | Δ11 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 Δ11 '붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설' 의 D3 4요소: ERROR:4 |  | 1 (Δ11) |
| WK-SSP0005-0135 | D3 | Δ2 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 Δ2 '편집 기본 ON(모드 토글 미이식)' 의 D3 4요소: ERROR:4 |  | 1 (Δ2) |
| WK-SSP0005-0136 | D4 | DAY_CODE | 하네스·환경 | D4 도구 오류 — 실측[T-c38775b6]: Insert 버튼 비노출 — 신규행 기본값(D4) 측정 대상 없음 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (G21) |
| WK-SSP0005-0137 | D4 | G17 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 G17 '`SetText` SelectDay + 행 선택' 의 D4 1요소: ERROR:1 |  | 1 (G17) |
| WK-SSP0005-0138 | D4 | G18 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 G18 '`SetText` SelectDay + 열 선택' 의 D4 1요소: ERROR:1 |  | 1 (G18) |
| WK-SSP0005-0139 | D4 | G19 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 G19 '`SetText` SelectDay + 블록' 의 D4 1요소: ERROR:1 |  | 1 (G19) |
| WK-SSP0005-0140 | D4 | G20 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 G20 '`SetText` EveryDay' 의 D4 1요소: ERROR:1 |  | 1 (G20) |
| WK-SSP0005-0141 | D4 | P02 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 P02 '`InsertButton` cs:335' 의 D4 1요소: ERROR:1 |  | 1 (P02) |
| WK-SSP0005-0142 | D4 | Δ1 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 Δ1 '`Period*` 빈값 조회 **차단**' 의 D4 1요소: ERROR:1 |  | 1 (Δ1) |
| WK-SSP0005-0143 | D4 | Δ10 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 Δ10 '툴바 `Insert`/`Delete` NO-OP 노출을 **버튼 권한 축으로 게이트**(g' 의 D4 1요소: ERROR:1 |  | 1 (Δ10) |
| WK-SSP0005-0144 | D4 | Δ4 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 Δ4 'btnInput 입력분이 반드시 저장 대상에 포함' 의 D4 1요소: ERROR:1 |  | 1 (Δ4) |
| WK-SSP0005-0145 | D4 | Δ7 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 Δ7 '`MyDivision` 콤보에 `mnuId` 전송' 의 D4 1요소: ERROR:1 |  | 1 (Δ7) |
| WK-SSP0005-0146 | D4 | Δ9 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 Δ9 '`Company` 빈값 조회 **차단**(gap-resolve iter-1 신설)' 의 D4 1요소: ERROR:1 |  | 1 (Δ9) |
| WK-SSP0005-0147 | D6 | SSP0005 화면 | 하네스·환경 | D6 도구 오류 — 원장 V-67877bc6 RULE_SCREEN / 원장 V-13080996 RULE_SCREEN / 원장 V-3a321dcf RULE_SCREEN / 원장 V-7f4b0615 GENERAL / 원장 V-6630b2 |  | 4 (P02 Δ1 Δ7 Δ10) |
| WK-SSP0005-0148 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-8c0b1fa7 ASIS / 실측[T-cd6386c9]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (V01 ACT:SSP0005_ShipmentWorkingDay.SaveD) |
| WK-SSP0005-0149 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-8c0b1fa7 / 실측[T-d9af9685]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.SaveData_) |
| WK-SSP0005-0150 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-23e055de ASIS / 실측[T-f5e2b116]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (V05 ACT:SSP0005_ShipmentWorkingDay.BtnIn) |
| WK-SSP0005-0151 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-23e055de / 실측[T-c61b1188]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0152 | E4 | MSG00134 | 하네스·환경 | E4 도구 오류 — 원장 V-21c0cf89 ASIS / 실측[T-59de933f]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (V06 Δ8 ACT:SSP0005_ShipmentWorkingDay.Bt) |
| WK-SSP0005-0153 | E4 | MSG00134 | 하네스·환경 | E4 도구 오류 — 원장 V-21c0cf89 / 실측[T-f6d2008f]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0154 | E4 | MSG00135 | 하네스·환경 | E4 도구 오류 — 원장 V-6f1aea63 ASIS / 실측[T-57fe96b8]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (V04 ACT:SSP0005_ShipmentWorkingDay.BtnIn) |
| WK-SSP0005-0155 | E4 | MSG00135 | 하네스·환경 | E4 도구 오류 — 원장 V-6f1aea63 / 실측[T-db2a4710]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0156 | E4 | cboInputValue / Input Value | 하네스·환경 | E4 도구 오류 — 실측[T-bc60d5c7]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (D03 ACT:SSP0005_ShipmentWorkingDay.BtnIn) |
| WK-SSP0005-0157 | A10 | SSP0005 화면 | 하네스·환경 | A10 도구 오류 — 원장 V-494abd53 RULE_SCREEN / 원장 V-da97d1f8 GENERAL / 실측[T-b297258d]: 화면 진입 직후(조회 전) 그리드 0행 · 진입 시 호출 Shipment Working D |  | 69 (ACT:SSP0005_ShipmentWorkingDay.Form_Load) |
| WK-SSP0005-0158 | A6 | PKG_COM0000.P_SCM0001_GET_SCP_PERIOD | 하네스·환경 | A6 도구 오류 — 원장 V-d8939952 SP / 정렬대조 NA AS-IS·TO-BE 모두 ORDER BY 없음 — 결과 1행 집계 SP → CR-075  / 실측[T-c7d508e6]: PKG_COM0000.P_SCM0001_G |  | 1 (S04) |
| WK-SSP0005-0159 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 하네스·환경 | A6 도구 오류 — 원장 V-b97e26b3 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측 순서대조 PASS 공통 2640행(Doc/golden/SSP0005/SCP0009_GET_SHEET_CALENDAR_3SPAN.ord |  | 34 (S03 ACT:SSP0005_ShipmentWorkingDay.FindB) |
| WK-SSP0005-0160 | G1 | A02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 A02 '필수값 검증 2건 cs:377·456' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (A02) |
| WK-SSP0005-0161 | G1 | A04 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 A04 'Division 권한 게이트 cs:161-162' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (A04) |
| WK-SSP0005-0162 | G1 | A15 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 A15 '`GetDayOfWeek` = dsSpdTitle 역조회 cs:824-830' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (A15) |
| WK-SSP0005-0163 | G1 | B04 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 B04 '`Data.Common(YesOrNo)` cs:48' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (B04) |
| WK-SSP0005-0164 | G1 | C09 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 C09 '`layoutControlItem10`(TextVisible=false)' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (C09) |
| WK-SSP0005-0165 | G1 | C12 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 C12 '`btnInput`' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (C12) |
| WK-SSP0005-0166 | G1 | D01 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D01 '`Columns.Get(0).Visible == false`' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (D01) |
| WK-SSP0005-0167 | G1 | G13 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 G13 '`SmartColMerge`(조회 후)' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (G13) |
| WK-SSP0005-0168 | G1 | P01 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 P01 '`FindButton` cs:330' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (P01) |
| WK-SSP0005-0169 | G1 | V04 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 V04 '`MSG00135` 편집모드 아님' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (V04) |
| WK-SSP0005-0170 | G1 | clbDivision / Division / Div / Div. | 하네스·환경 | G1 도구 오류 — 원장 V-9bf88d42 SEARCH / E2E smoke cond combo |  | 2 (ACT:SSP0005_ShipmentWorkingDay.FindData_) |
| WK-SSP0005-0171 | G1 | Δ1 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Δ1 '`Period*` 빈값 조회 **차단**' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (Δ1) |
| WK-SSP0005-0172 | G1 | Δ11 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Δ11 '붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (Δ11) |
| WK-SSP0005-0173 | G1 | Δ6 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Δ6 '빈 `D_` 셀 변경건 전송 제외' 의 G1 3요소: PASS:2 · ERROR:1 |  | 1 (Δ6) |
| WK-SSP0005-0174 | X-ROW | SSP0005_ShipmentWorkingDay.BtnInput_Clic | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 13검사 — ERROR:10 · NA:2 · WARN:1 |  | 5 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0175 | X-ROW | SSP0005_ShipmentWorkingDay.CboDayWeek_Se | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.CboDayWee) |
| WK-SSP0005-0176 | X-ROW | SSP0005_ShipmentWorkingDay.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.CreateSpr) |
| WK-SSP0005-0177 | X-ROW | SSP0005_ShipmentWorkingDay.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.Form_Load) |
| WK-SSP0005-0178 | X-ROW | SSP0005_ShipmentWorkingDay.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — PASS:11 · NA:4 · ERROR:1 |  | 5 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0179 | X-ROW | SSP0005_ShipmentWorkingDay.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:3 · NA:2 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0180 | X-ROW | SSP0005_ShipmentWorkingDay.InitSpreadDat | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 8 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0181 | X-ROW | SSP0005_ShipmentWorkingDay.SaveData_Main | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 18검사 — ERROR:9 · PASS:5 · NA:4 |  | 11 (ACT:SSP0005_ShipmentWorkingDay.SaveData_) |
| WK-SSP0005-0182 | X-ROW | SSP0005_ShipmentWorkingDay.SpdMain_Chang | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NA:2 · WARN:1 · ERROR:1 |  | 2 (ACT:SSP0005_ShipmentWorkingDay.SpdMain_C) |
| WK-SSP0005-0183 | X-ROW | SSP0005_ShipmentWorkingDay.SpdMain_TopCh | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SSP0005_ShipmentWorkingDay.SpdMain_T) |
