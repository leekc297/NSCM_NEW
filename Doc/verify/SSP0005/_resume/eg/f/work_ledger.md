# 작업 원장 — SSP0005 · 2026-11-20 09:29

> 검사 인스턴스 429건 중 PASS·NA 310건 외 **119건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 28 | 재판정 PASS |
| W5 | 검사기 연결 | 1 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 21 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 69 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 69 · FE 22 · 사람 판정 / AS-IS 원문 확인 → 재판정 21 · 사람판정 3 · 화면 FE 2 · DB 1 · 하네스 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-REASON | DESIGN |  |  | 20 |  |  |  |  |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | GEN |  |  |  |  |  |  | 18 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  |  |  |  | 15 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| X-ROW | GEN |  |  | 3 |  |  |  |  |  | 8 | 대조표 행이 서술한 동작을 화면에서 재현 |
| D3 | EDIT |  |  |  |  |  |  |  |  | 10 | 행 값 기반 조건부 잠금 |
| E4 | EDIT |  |  | 2 |  |  |  |  |  | 7 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| D1 | EDIT |  |  |  |  |  |  |  |  | 9 | 컬럼 편집 가능 여부(신규행·기존행) |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 8 | 연쇄 자동 채움 |
| A6 | GEN |  |  | 3 |  |  |  |  |  | 1 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-LOC | GEN |  |  |  |  |  |  | 2 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| B3 | COMBO |  |  |  |  | 1 |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| SC1 | DESIGN |  |  |  |  |  |  | 1 |  |  | 조회조건 순서 = 기준표 |
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

## W3 동작 수정 (28)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0001 | X-REASON | A06 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — A06: [대조표 근거 없음] 요소 '저장 대상 = action AND 글자색 Red cs:491-492' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS |  | 1 (A06) |
| WK-SSP0005-0002 | X-REASON | A07 | DB(🛠️/🧯 적용 가능) | X-REASON FAIL 수정 — A07: [대조표 근거 없음] 요소 '`iCount==0` 시 첫/끝 행 플래그 cs:514-515' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 |  | 1 (A07) |
| WK-SSP0005-0003 | X-REASON | A09 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — A09: [대조표 근거 없음] 요소 '`DefineProperty()` 빈 본문 cs:142-144' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 |  | 1 (A09) |
| WK-SSP0005-0004 | X-REASON | C10 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — C10: [대조표 근거 없음] 요소 '`emptySpaceItem1`' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 |  | 1 (C10) |
| WK-SSP0005-0005 | X-REASON | C11 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — C11: [대조표 근거 없음] 요소 '`emptySpaceItem2`' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 |  | 1 (C11) |
| WK-SSP0005-0006 | X-REASON | C20 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — C20: [대조표 근거 없음] 요소 '`components`(Container)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞 |  | 1 (C20) |
| WK-SSP0005-0007 | X-REASON | D08 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — D08: [대조표 근거 없음] 요소 '`ds == null`' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 사유에  |  | 1 (D08) |
| WK-SSP0005-0008 | X-REASON | D09 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — D09: [대조표 근거 없음] 요소 '`!CanModelChange`(Changed)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식 |  | 1 (D09) |
| WK-SSP0005-0009 | X-REASON | D10 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — D10: [대조표 근거 없음] 요소 '`ds == null`(Changed)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 |  | 1 (D10) |
| WK-SSP0005-0010 | X-REASON | E04 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — E04: [대조표 근거 없음] 요소 '`SpdMain_Changed`' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표 |  | 1 (E04) |
| WK-SSP0005-0011 | X-REASON | G09 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — G09: [대조표 근거 없음] 요소 '`SwitchLock`(EditButton)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이  |  | 1 (G09) |
| WK-SSP0005-0012 | X-REASON | G12 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — G12: [대조표 근거 없음] 요소 '`LockColumn(0, max, true)`(조회 직후 전열 잠금)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS- |  | 1 (G12) |
| WK-SSP0005-0013 | X-REASON | G15 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — G15: [대조표 근거 없음] 요소 '`GetModelColumnFromViewColumn`(cRow)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS  |  | 1 (G15) |
| WK-SSP0005-0014 | X-REASON | G16 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — G16: [대조표 근거 없음] 요소 '`GetModelColumnFromViewColumn`(cCol)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS  |  | 1 (G16) |
| WK-SSP0005-0015 | X-REASON | G22 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — G22: [대조표 근거 없음] 요소 '`Visible=`(`M_` → `W_` 토글)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식 |  | 1 (G22) |
| WK-SSP0005-0016 | X-REASON | G23 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — G23: [대조표 근거 없음] 요소 '`Visible=`(`M_` → `D_` 숨김)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식 |  | 1 (G23) |
| WK-SSP0005-0017 | X-REASON | G24 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — G24: [대조표 근거 없음] 요소 '`Visible=`(`W_` → `D_` 토글)' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식 |  | 1 (G24) |
| WK-SSP0005-0018 | X-REASON | P08 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — P08: [대조표 근거 없음] 요소 '`SpdMain_CellDoubleClick` cs:834' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구 |  | 1 (P08) |
| WK-SSP0005-0019 | X-REASON | P09 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — P09: [대조표 근거 없음] 요소 '`SpdMain_Changed` cs:872' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이  |  | 1 (P09) |
| WK-SSP0005-0020 | X-REASON | V07 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — V07: [대조표 근거 없음] 요소 '`MSG00050` 숫자 형식' 제외 사유 '' 에 룰·지시·AS-IS 원문·이동 위치 근거 없음 · 권장 조치: AS-IS 동작 구현, 미이식이 맞으면 대조표  |  | 1 (V07) |
| WK-SSP0005-0021 | E4 | MSG00135 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00135: 원장 V-6f1aea63 ASIS / 실측[T-57fe96b8]: MSG00135(조회 전 가드) · 조회 전 'Bulk Update' 클릭 → 알림 없음 · 모달 열림 |  | 2 (V04 ACT:SSP0005_ShipmentWorkingDay.BtnIn) |
| WK-SSP0005-0022 | E4 | MSG00135 | FE(repairScope=DB_ONLY — 이번 범위 밖) | E4 FAIL 수정 — MSG00135: 원장 V-6f1aea63 / 실측[T-db2a4710]: MSG00135(조회 전 가드) · 조회 전 'Bulk Update' 클릭 → 알림 없음 · 모달 열림 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0023 | A6 | B03 | 사람판정(사람판정 대기) | A6 FAIL 수정 — B03: 행 집계 — 대조표 B03 '`Data.Common(Data.Type.LookupCommon, false, "WEEK_' 의 A6 4요소: FAIL:1 · ERROR:1 · PASS:1 · NA:1 · |  | 1 (B03) |
| WK-SSP0005-0024 | A6 | PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKI | 사람판정(사람판정 대기) | A6 FAIL 수정 — PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY: 원장 V-1b666fe8 SP / 원장 V-4089d95c SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['S |  | 36 (S01 ACT:SSP0005_ShipmentWorkingDay.FindB) |
| WK-SSP0005-0025 | A6 | U01 | 사람판정(사람판정 대기) | A6 FAIL 수정 — U01: 행 집계 — 대조표 U01 '`ProgressForm`(FindData_Main) cs:372' 의 A6 4요소: FAIL:1 · ERROR:1 · PASS:1 · NA:1 · FAIL 요소: PKG_ |  | 1 (U01) |
| WK-SSP0005-0026 | X-ROW | SSP0005_ShipmentWorkingDay.BtnInput_Clic | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SSP0005_ShipmentWorkingDay.BtnInput_Click: 진입점 집계 13검사 — ERROR:8 · NA:3 · FAIL:2 |  | 5 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0027 | X-ROW | SSP0005_ShipmentWorkingDay.FindButton | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0005_ShipmentWorkingDay.FindButton: 진입점 집계 6검사 — PASS:4 · REVIEW:1 · FAIL:1 (FX-SSP0005-031) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.FindButto) |
| WK-SSP0005-0028 | X-ROW | SSP0005_ShipmentWorkingDay.FindData_Main | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0005_ShipmentWorkingDay.FindData_Main: 진입점 집계 14검사 — PASS:8 · ERROR:2 · NA:2 · REVIEW:1 · FAIL:1 (FX-SSP0005-03 |  | 7 (ACT:SSP0005_ShipmentWorkingDay.FindData_) |

## W5 검사기 연결 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0029 | B3 | cboDayWeek / Day of the week / Day Week | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND cboDayWeek / Day of the week / Day Week | 있음(FE 소스) | 1 (C16) |

## W7 기대값 확정 (21)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0030 | SC1 | SSP0005 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | SC1 기대값 확정 — SSP0005 화면: 원장 V-d0e01e7d RULE_SCREEN / 원장 V-d77fd8e5 CONFIRMED / E2E smoke cond order / 게이트 SC2 기준표가 BUTTON_AREA(조회조 |  | 4 (C09 C12 B04 Δ6) |
| WK-SSP0005-0031 | A1 | A02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A02: 행 집계 — 대조표 A02 '필수값 검증 2건 cs:377·456' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — gol |  | 1 (A02) |
| WK-SSP0005-0032 | A1 | A04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A04: 행 집계 — 대조표 A04 'Division 권한 게이트 cs:161-162' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP |  | 1 (A04) |
| WK-SSP0005-0033 | A1 | A15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — A15: 행 집계 — 대조표 A15 '`GetDayOfWeek` = dsSpdTitle 역조회 cs:824-830' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_ |  | 1 (A15) |
| WK-SSP0005-0034 | A1 | B03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B03: 행 집계 — 대조표 B03 '`Data.Common(Data.Type.LookupCommon, false, "WEEK_' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SS |  | 1 (B03) |
| WK-SSP0005-0035 | A1 | B04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B04: 행 집계 — 대조표 B04 '`Data.Common(YesOrNo)` cs:48' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SH |  | 1 (B04) |
| WK-SSP0005-0036 | A1 | C09 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — C09: 행 집계 — 대조표 C09 '`layoutControlItem10`(TextVisible=false)' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SS |  | 1 (C09) |
| WK-SSP0005-0037 | A1 | C12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — C12: 행 집계 — 대조표 C12 '`btnInput`' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — golden DIFF A |  | 1 (C12) |
| WK-SSP0005-0038 | A1 | D01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D01: 행 집계 — 대조표 D01 '`Columns.Get(0).Visible == false`' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_G |  | 1 (D01) |
| WK-SSP0005-0039 | A1 | G13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G13: 행 집계 — 대조표 G13 '`SmartColMerge`(조회 후)' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — go |  | 1 (G13) |
| WK-SSP0005-0040 | A1 | P01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P01: 행 집계 — 대조표 P01 '`FindButton` cs:330' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — gold |  | 1 (P01) |
| WK-SSP0005-0041 | A1 | PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY: golden DIFF AS-IS 0행 ↔ TO-BE 0행: Doc/golden/SSP0005/SSP0005_GET_SHIPME |  | 36 (S01 ACT:SSP0005_ShipmentWorkingDay.FindB) |
| WK-SSP0005-0042 | A1 | P_SSP0005_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SSP0005_GET: 골든 비교 케이스 없음(P_SSP0005_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (S01) |
| WK-SSP0005-0043 | A1 | U01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — U01: 행 집계 — 대조표 U01 '`ProgressForm`(FindData_Main) cs:372' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP000 |  | 1 (U01) |
| WK-SSP0005-0044 | A1 | V04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — V04: 행 집계 — 대조표 V04 '`MSG00135` 편집모드 아님' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — golde |  | 1 (V04) |
| WK-SSP0005-0045 | A1 | Δ1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Δ1: 행 집계 — 대조표 Δ1 '`Period*` 빈값 조회 **차단**' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — gol |  | 1 (Δ1) |
| WK-SSP0005-0046 | A1 | Δ11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Δ11: 행 집계 — 대조표 Δ11 '붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SS |  | 1 (Δ11) |
| WK-SSP0005-0047 | A1 | Δ6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Δ6: 행 집계 — 대조표 Δ6 '빈 `D_` 셀 변경건 전송 제외' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P_SSP0005_GET_SHIP — golden  |  | 1 (Δ6) |
| WK-SSP0005-0048 | A1 | Δ9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Δ9: 행 집계 — 대조표 Δ9 '`Company` 빈값 조회 **차단**(gap-resolve iter-1 신설)' 의 A1 4요소: REVIEW:2 · PASS:2 · FAIL 요소: PKG_SSP0005.P |  | 1 (Δ9) |
| WK-SSP0005-0049 | X-LOC | Δ2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Δ2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Δ2) |
| WK-SSP0005-0050 | X-LOC | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — —: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 (행의 식별자 filterCalls, DBUtils, RowFilter 를 화면 소스·프로시저 목록에서 |  | 1 (—) |

## W9 도구 오류 (69)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0005-0051 | J2 | SSP0005 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-f885dd85 RULE_SCREEN / 원장 V-85cb4be1 DEFECT / 원장 V-42616e24 GENERAL / 원장 V-5d5f56c6 GENERAL / 원장 V-83fd2b9b GENERA |  | 96 (C09 C12 V01 V02 V04 S02 B04 D01 G13 P01 ) |
| WK-SSP0005-0052 | C3 | DAY_CODE | 하네스·환경 | C3 도구 오류 — 실측[T-3e579fb8]: 조회 결과 0행 — 연쇄 측정 불가 |  | 1 (A15) |
| WK-SSP0005-0053 | C3 | P_FIRST_ROW | 하네스·환경 | C3 도구 오류 — 실측[T-94eb5239]: 조회 결과 0행 — 연쇄 측정 불가 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.SaveData_) |
| WK-SSP0005-0054 | C3 | P_LAST_ROW | 하네스·환경 | C3 도구 오류 — 실측[T-542b856c]: 조회 결과 0행 — 연쇄 측정 불가 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.SaveData_) |
| WK-SSP0005-0055 | C3 | SAT | 하네스·환경 | C3 도구 오류 — 실측[T-3912ade6]: 조회 결과 0행 — 연쇄 측정 불가 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0056 | C3 | SSP0005_ShipmentWorkingDay.CboDayWeek_Se | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0005_ShipmentWorkingDay.CboDayWeek_SelectedIndexChanged 의 C3 5요소: ERROR:5 |  | 5 (ACT:SSP0005_ShipmentWorkingDay.CboDayWee) |
| WK-SSP0005-0057 | C3 | SSP0005_ShipmentWorkingDay.SpdMain_Chang | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SSP0005_ShipmentWorkingDay.SpdMain_Changed 의 C3 5요소: ERROR:5 |  | 12 (ACT:SSP0005_ShipmentWorkingDay.SpdMain_C) |
| WK-SSP0005-0058 | C3 | SUN | 하네스·환경 | C3 도구 오류 — 실측[T-37d62dbc]: 조회 결과 0행 — 연쇄 측정 불가 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0059 | C3 | Δ11 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 Δ11 '붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설' 의 C3 5요소: ERROR:5 |  | 1 (Δ11) |
| WK-SSP0005-0060 | K4 | SSP0005 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-99eb0d71 GENERAL / 원장 V-d8d564f4 GENERAL / 원장 V-e8f6c900 GENERAL / 원장 V-6df5c22d GENERAL / 원장 V-ceca4b3b GENERAL / |  | 68 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0061 | F1 | SSP0005 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-45ceb78a RULE_SCREEN / 원장 V-657eef0e RULE_SCREEN / 원장 V-f8bcc179 RULE_SCREEN / 원장 V-e4f681b2 RULE_SCREEN / 원장 V-f7 |  | 98 (V01 V02 S02 P03 P05 U02 A01 A02 A14 Δ3 Δ) |
| WK-SSP0005-0062 | F2 | SSP0005 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-5c9fabe3 RULE_SCREEN / 원장 V-75c9d6f8 RULE_SCREEN / 원장 V-25b2fb7e GENERAL / 원장 V-056a94d1 GENERAL / 원장 V-b006a500 G |  | 95 (V01 V02 S02 P05 A01 A02 A14 Δ3 Δ4 ACT:SS) |
| WK-SSP0005-0063 | F3 | SSP0005 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-af14b50c RULE_SCREEN / 원장 V-6ac126ba RULE_SCREEN / 원장 V-a9a43704 GENERAL / 원장 V-7e36c00e GENERAL / 원장 V-5f46d3dc G |  | 1 (Δ11) |
| WK-SSP0005-0064 | F6 | SSP0005 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-2bc6b855 RULE_SCREEN / 원장 V-81b4003b RULE_SCREEN / 원장 V-400f4037 RULE_SCREEN / 원장 V-2c074ac3 RULE_SCREEN / 원장 V-a1 |  | 87 (U02 ACT:SSP0005_ShipmentWorkingDay.SaveB) |
| WK-SSP0005-0065 | H10 | SSP0005 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 13 (C08 V01 V02 V03 V04 V05 V06 D01 D03 D05 ) |
| WK-SSP0005-0066 | H4 | SSP0005 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-909c64fd RULE_SCREEN / 원장 V-0a997734 RULE_SCREEN / 원장 V-edb955cc RULE_SCREEN / 원장 V-f2bd7c17 RULE_SCREEN / 원장 V-49 |  | 7 (E05 G08 P10 ACT:SSP0005_ShipmentWorkingD) |
| WK-SSP0005-0067 | I1 | SSP0005 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-ffc58b3d RULE_SCREEN / 원장 V-d75aa24b RULE_SCREEN / 원장 V-c80a8e31 RULE_SCREEN / 원장 V-a7cfad14 DEFECT / 원장 V-963c6c0 |  | 20 (C08 V01 V02 V03 V04 V05 V06 D01 D03 D05 ) |
| WK-SSP0005-0068 | D1 | COMPANY_ID / Company | 하네스·환경 | D1 도구 오류 — 원장 V-a7ff1087 COLUMN / 실측[T-4aa8e925]: 조회 결과 0행 — 기존행 프로브 불가 |  | 5 (G10 ACT:SSP0005_ShipmentWorkingDay.EditB) |
| WK-SSP0005-0069 | D1 | D01 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 D01 '`Columns.Get(0).Visible == false`' 의 D1 3요소: ERROR:2 · NA:1 |  | 1 (D01) |
| WK-SSP0005-0070 | D1 | DIVISION_ID / Divison | 하네스·환경 | D1 도구 오류 — 원장 V-e60b34c2 COLUMN / 실측[T-35395986]: 조회 결과 0행 — 기존행 프로브 불가 |  | 2 (G10 ACT:SSP0005_ShipmentWorkingDay.EditB) |
| WK-SSP0005-0071 | D1 | P04 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 P04 '`EditButton` cs:346' 의 D1 3요소: ERROR:2 · NA:1 |  | 1 (P04) |
| WK-SSP0005-0072 | D1 | P05 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 P05 '`SaveButton` cs:360' 의 D1 3요소: ERROR:2 · NA:1 |  | 1 (P05) |
| WK-SSP0005-0073 | D1 | SSP0005_ShipmentWorkingDay.EditButton | 하네스·환경 | D1 도구 오류 — 진입점 집계 — 대조표 SSP0005_ShipmentWorkingDay.EditButton 의 D1 2요소: ERROR:2 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.EditButto) |
| WK-SSP0005-0074 | D1 | V04 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 V04 '`MSG00135` 편집모드 아님' 의 D1 3요소: ERROR:2 · NA:1 |  | 1 (V04) |
| WK-SSP0005-0075 | D1 | Δ11 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 Δ11 '붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설' 의 D1 3요소: ERROR:2 · NA:1 |  | 1 (Δ11) |
| WK-SSP0005-0076 | D1 | Δ2 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 Δ2 '편집 기본 ON(모드 토글 미이식)' 의 D1 3요소: ERROR:2 · NA:1 |  | 1 (Δ2) |
| WK-SSP0005-0077 | D3 | COMPANY,DIVISION | 하네스·환경 | D3 도구 오류 — 원장 V-1f2690f4 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.EditButto) |
| WK-SSP0005-0078 | D3 | D01 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D01 '`Columns.Get(0).Visible == false`' 의 D3 4요소: NA:2 · ERROR:2 |  | 1 (D01) |
| WK-SSP0005-0079 | D3 | P04 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 P04 '`EditButton` cs:346' 의 D3 4요소: NA:2 · ERROR:2 |  | 1 (P04) |
| WK-SSP0005-0080 | D3 | P05 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 P05 '`SaveButton` cs:360' 의 D3 4요소: NA:2 · ERROR:2 |  | 1 (P05) |
| WK-SSP0005-0081 | D3 | SSP0005_ShipmentWorkingDay.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-4a7ffdbe ASIS / 원장 V-1f2690f4 ASIS |  | 1 (ACT:SSP0005_ShipmentWorkingDay.EditButto) |
| WK-SSP0005-0082 | D3 | V04 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 V04 '`MSG00135` 편집모드 아님' 의 D3 4요소: NA:2 · ERROR:2 |  | 1 (V04) |
| WK-SSP0005-0083 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-4a7ffdbe |  | 1 (ACT:SSP0005_ShipmentWorkingDay.EditButto) |
| WK-SSP0005-0084 | D3 | Δ10 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 Δ10 '툴바 `Insert`/`Delete` NO-OP 노출을 **버튼 권한 축으로 게이트**(g' 의 D3 4요소: NA:2 · ERROR:2 |  | 1 (Δ10) |
| WK-SSP0005-0085 | D3 | Δ11 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 Δ11 '붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설' 의 D3 4요소: NA:2 · ERROR:2 |  | 1 (Δ11) |
| WK-SSP0005-0086 | D3 | Δ2 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 Δ2 '편집 기본 ON(모드 토글 미이식)' 의 D3 4요소: NA:2 · ERROR:2 |  | 1 (Δ2) |
| WK-SSP0005-0087 | D6 | SSP0005 화면 | 하네스·환경 | D6 도구 오류 — 원장 V-67877bc6 RULE_SCREEN / 원장 V-13080996 RULE_SCREEN / 원장 V-3a321dcf RULE_SCREEN / 원장 V-7f4b0615 GENERAL / 원장 V-6630b2 |  | 4 (P02 Δ1 Δ7 Δ10) |
| WK-SSP0005-0088 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-8c0b1fa7 ASIS / 실측[T-cd6386c9]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (V01 ACT:SSP0005_ShipmentWorkingDay.SaveD) |
| WK-SSP0005-0089 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-8c0b1fa7 / 실측[T-d9af9685]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.SaveData_) |
| WK-SSP0005-0090 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-23e055de ASIS / 실측[T-f5e2b116]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (V05 ACT:SSP0005_ShipmentWorkingDay.BtnIn) |
| WK-SSP0005-0091 | E4 | MSG00093 | 하네스·환경 | E4 도구 오류 — 원장 V-23e055de / 실측[T-c61b1188]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0092 | E4 | MSG00134 | 하네스·환경 | E4 도구 오류 — 원장 V-21c0cf89 ASIS / 실측[T-59de933f]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (V06 Δ8 ACT:SSP0005_ShipmentWorkingDay.Bt) |
| WK-SSP0005-0093 | E4 | MSG00134 | 하네스·환경 | E4 도구 오류 — 원장 V-21c0cf89 / 실측[T-f6d2008f]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SSP0005_ShipmentWorkingDay.BtnInput_) |
| WK-SSP0005-0094 | E4 | cboInputValue / Input Value | 하네스·환경 | E4 도구 오류 — 실측[T-bc60d5c7]: 조회 0행 — 기존행 기반 위반 입력 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (D03 ACT:SSP0005_ShipmentWorkingDay.BtnIn) |
| WK-SSP0005-0095 | A10 | SSP0005 화면 | 하네스·환경 | A10 도구 오류 — 원장 V-494abd53 RULE_SCREEN / 원장 V-da97d1f8 GENERAL / 실측[T-b297258d]: 화면 진입 직후(조회 전) 그리드 0행 · 진입 시 호출 Shipment Working D |  | 69 (ACT:SSP0005_ShipmentWorkingDay.Form_Load) |
| WK-SSP0005-0096 | A6 | P_SSP0005_GET | 하네스·환경 | A6 도구 오류 — 실측[T-09965270]: 상속(API 별칭 P_SSP0005_GET = PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY) [T-267333fd]: PKG_SSP0005.P_S |  | 1 (S01) |
| WK-SSP0005-0097 | G1 | A02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 A02 '필수값 검증 2건 cs:377·456' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (A02) |
| WK-SSP0005-0098 | G1 | A04 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 A04 'Division 권한 게이트 cs:161-162' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (A04) |
| WK-SSP0005-0099 | G1 | A15 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 A15 '`GetDayOfWeek` = dsSpdTitle 역조회 cs:824-830' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (A15) |
| WK-SSP0005-0100 | G1 | B04 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 B04 '`Data.Common(YesOrNo)` cs:48' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (B04) |
| WK-SSP0005-0101 | G1 | C09 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 C09 '`layoutControlItem10`(TextVisible=false)' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (C09) |
| WK-SSP0005-0102 | G1 | C12 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 C12 '`btnInput`' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (C12) |
| WK-SSP0005-0103 | G1 | D01 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 D01 '`Columns.Get(0).Visible == false`' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (D01) |
| WK-SSP0005-0104 | G1 | G13 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 G13 '`SmartColMerge`(조회 후)' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (G13) |
| WK-SSP0005-0105 | G1 | P01 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 P01 '`FindButton` cs:330' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (P01) |
| WK-SSP0005-0106 | G1 | V04 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 V04 '`MSG00135` 편집모드 아님' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (V04) |
| WK-SSP0005-0107 | G1 | clbDivision / Division / Div / Div. | 하네스·환경 | G1 도구 오류 — 원장 V-9bf88d42 SEARCH / E2E smoke cond combo |  | 2 (ACT:SSP0005_ShipmentWorkingDay.FindData_) |
| WK-SSP0005-0108 | G1 | drpPeriod / Period / From / To / 기간 | 하네스·환경 | G1 도구 오류 — 원장 V-0ac85697 SEARCH / E2E smoke cond period |  | 3 (ACT:SSP0005_ShipmentWorkingDay.FindData_) |
| WK-SSP0005-0109 | G1 | Δ1 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Δ1 '`Period*` 빈값 조회 **차단**' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (Δ1) |
| WK-SSP0005-0110 | G1 | Δ11 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Δ11 '붙여넣기(`pastingCell`)에도 편집 게이트(gap-resolve iter-1 신설' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (Δ11) |
| WK-SSP0005-0111 | G1 | Δ6 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Δ6 '빈 `D_` 셀 변경건 전송 제외' 의 G1 3요소: ERROR:2 · PASS:1 |  | 1 (Δ6) |
| WK-SSP0005-0112 | X-ROW | SSP0005_ShipmentWorkingDay.CboDayWeek_Se | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · ERROR:1 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.CboDayWee) |
| WK-SSP0005-0113 | X-ROW | SSP0005_ShipmentWorkingDay.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.Form_Load) |
| WK-SSP0005-0114 | X-ROW | SSP0005_ShipmentWorkingDay.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — PASS:9 · NA:6 · ERROR:1 |  | 5 (ACT:SSP0005_ShipmentWorkingDay.InitContr) |
| WK-SSP0005-0115 | X-ROW | SSP0005_ShipmentWorkingDay.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — PASS:3 · ERROR:1 · NA:1 |  | 1 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0116 | X-ROW | SSP0005_ShipmentWorkingDay.InitSpreadDat | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 8 (ACT:SSP0005_ShipmentWorkingDay.InitSprea) |
| WK-SSP0005-0117 | X-ROW | SSP0005_ShipmentWorkingDay.SaveData_Main | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 18검사 — ERROR:8 · PASS:6 · NA:4 |  | 11 (ACT:SSP0005_ShipmentWorkingDay.SaveData_) |
| WK-SSP0005-0118 | X-ROW | SSP0005_ShipmentWorkingDay.SpdMain_Chang | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NA:3 · ERROR:1 |  | 2 (ACT:SSP0005_ShipmentWorkingDay.SpdMain_C) |
| WK-SSP0005-0119 | X-ROW | SSP0005_ShipmentWorkingDay.SpdMain_TopCh | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:SSP0005_ShipmentWorkingDay.SpdMain_T) |
