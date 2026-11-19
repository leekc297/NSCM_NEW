# SCP0005 미검증 분류 · 2026-11-19 17:08:50 · 라운드 1

- 원장 미검증(ERROR) 392 → 392행. 처리 대상(엔진·대조표·판단·미분류·자동 남음) 283 · 사람 확인 1 · 집계 108
- 집계 행 = 하위 행 판정을 따라감. 하위 행이 풀리면 같이 풀림(따로 고치지 않음).
- 자동 재측정: 없음

| 담당 | 유형 | 행 |
|---|---|---|
| 엔진 | 검사기공백 | 133 |
| 판단 | 판단 | 120 |
| 집계 | 집계 | 108 |
| 엔진 | 미분류 | 25 |
| 엔진 | 데이터전제 | 3 |
| 자동 | 재실행 | 2 |
| 사람 | 스냅샷승인 | 1 |

## 담당 엔진 (161행)

### 검사기공백 · 규칙 A4 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-28e296d5 [RULE_SCREEN] SCP0005 화면 |  | [미검증] 검사기(_trace.spec(@trace) W4d 재조회 전 시트 초기화(Division 전환 조회))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_trace.spec(@trace) W4d 재조회 전 시트 초기화(Division 전환 조회))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검

### 검사기공백 · 규칙 A5 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-aa4e2eb2 [TRACE] DAYS / Departure Days | DAYS: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203)

### 검사기공백 · 규칙 A6 · 5행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-2f7778bd [TRACE] SCP0005_GET_DISTRIBUTION_ROUTEID | SCP0005_GET_DISTRIBUTION_ROUTEID: 화면 진입·조회 경로에서 이 SP 가 결과를 반환하지 않음(팝업·셀 이벤트 SP) — 해당 시나리오에서 실측 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-336fa068 [TRACE] SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID: 화면 진입·조회 경로에서 이 SP 가 결과를 반환하지 않음(팝업·셀 이벤트 SP) — 해당 시나리오에서 실측 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-f0f809e9 [TRACE] PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY | PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY: 화면 진입·조회 경로에서 이 SP 가 결과를 반환하지 않음(팝업·셀 이벤트 SP) — 해당 시나리오에서 실측 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-f574c4a3 [SP] SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | AS-IS ORDER BY [FROM_COUNTRY,FROM_CITY,TO_COUNTRY,TO_CITY,PRIORITY] ↔ TO-BE [] — TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-fc7cfdc8 [SP] SCP0005_GET_DISTRIBUTION_ROUTEID | AS-IS ORDER BY [FROM_COUNTRY,FROM_CITY,TO_COUNTRY,TO_CITY,PRIORITY] ↔ TO-BE [] — TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 검사기공백 · 규칙 A7 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-4d5799f3 [SP] SCP0005_GET_DISTRIBUTION_ROUTEID |  | [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(tools/DbConn/golden.py <sp>.cols.csv(공란 컬럼·같은 키 불일치) → judge)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 

### 검사기공백 · 규칙 C1 · 2행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-1f03b82a [RULE_SCREEN] SCP0005 시나리오 [자동] LT_TYPE 셀 콤보 후보 = 서버 콤보 LookupCommon | [측정 경로 없음] [자동] LT_TYPE 셀 콤보 후보 = 서버 콤보 LookupCommon: 서버 콤보 LookupCommon 응답 없음(수집 24건) · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:8036행·신규0·호출2·요청8 → gridcands:8037행·신규1·호출2·요청8 → 끝:8037행·신규1·호출2·요청8 · 문서 자동 생
- V-2e931168 [RULE_SCREEN] SCP0005 시나리오 [자동] TRANSPORT_MODE 셀 콤보 후보 = 서버 콤보 LookupCommon | [측정 경로 없음] [자동] TRANSPORT_MODE 셀 콤보 후보 = 서버 콤보 LookupCommon: 서버 콤보 LookupCommon 응답 없음(수집 48건) · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:8036행·신규0·호출2·요청8 → gridcands:8037행·신규1·호출2·요청8 → 끝:8037행·신규1·호출2·요청8 · 

### 검사기공백 · 규칙 C2 · 2행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-6e75e40a [TRACE] PRIORITY / Priority | PRIORITY 연쇄 원천 해석 불가 — AS-IS — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7)
- T-c7a43f16 [TRACE] DAYS / Departure Days | DAYS 연쇄 원천 해석 불가 — AS-IS — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7)

### 검사기공백 · 규칙 C3 · 14행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-2c380c91 [TRACE] LT_ARRIVAL_INLAND / Arrival Inland | LT_ARRIVAL_INLAND 연쇄 원천 컬럼 해석 불가 — AS-IS spdMainDataModel_Changed:983 siMain.GetColumnIndex(DefColumns.LT_ARRIVAL_INLAND) [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:] → 기계 
- T-305e2727 [TRACE] LT_LAY_OFF_CLEARANCE / Lay Off/Customs Clearance | LT_LAY_OFF_CLEARANCE 연쇄 원천 컬럼 해석 불가 — AS-IS spdMainDataModel_Changed:995 dt.Rows[nRow][DefColumns.LT_LAY_OFF_CLEARANCE].ToString() [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdate
- T-4dd85db6 [TRACE] DAYS / Departure Days | DAYS 연쇄 원천 컬럼 해석 불가 — AS-IS → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-8953d4ba [TRACE] LT_DEPARTURE_INLAND / Departure Inland | LT_DEPARTURE_INLAND 연쇄 원천 컬럼 해석 불가 — AS-IS spdMainDataModel_Changed:994 dt.Rows[nRow][DefColumns.LT_DEPARTURE_INLAND].ToString() [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
- T-8b3ad504 [TRACE] VALID_YN / Valid | VALID_YN 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRow:947 siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VALID_YN), "Y") [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) ==
- T-a9cf4fcb [TRACE] LT_VOYAGE / Voyage | LT_VOYAGE 연쇄 원천 컬럼 해석 불가 — AS-IS spdMainDataModel_Changed:996 dt.Rows[nRow][DefColumns.LT_VOYAGE].ToString() [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == s
- T-e776edc2 [TRACE] LT_WAIT_SHIPPING / Waiting For Shipping | LT_WAIT_SHIPPING 연쇄 원천 컬럼 해석 불가 — AS-IS spdMainDataModel_Changed:993 dt.Rows[nRow][DefColumns.LT_WAIT_SHIPPING].ToString() [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if 
- V-11fc9455 [ASIS] dt.Rows[nRow][DefColumns.LT_WAIT_SHIPPING] | 원천 컬럼 분기 해석 불가 — 조건 'try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.C' → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-8447aae1 [ASIS] dt.Rows[nRow][DefColumns.LT_SUM] | 원천 컬럼 분기 해석 불가 — 조건 'try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.C' → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-95abdd8e [ASIS] dt.Rows[nRow][DefColumns.LT_SUM] | 원천 컬럼 분기 해석 불가 — 조건 'try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.C' → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-980834ad [ASIS] dt.Rows[nRow][DefColumns.LT_DEPARTURE_INLAND] | 원천 컬럼 분기 해석 불가 — 조건 'try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.C' → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-a24da326 [ASIS] dt.Rows[nRow][DefColumns.LT_ARRIVAL_INLAND] | 원천 컬럼 분기 해석 불가 — 조건 'try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.C' → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- 외 2행(unverified_triage.csv)

### 검사기공백 · 규칙 C6 · 2행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-6e2ef7c8 [TRACE] PRIORITY / Priority | PRIORITY 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7)
- T-dc040561 [TRACE] DAYS / Departure Days | DAYS 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7)

### 검사기공백 · 규칙 DB-SYN · 3행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-74b664fb [TRACE] SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 실측[T-74b664fb]: 검사기(syn_check.py·fixture dberr)는 있으나 이 대상(SP)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(syn_check.py·fixture dberr)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7)
- T-9374e9e4 [TRACE] SCP0005_GET_DISTRIBUTION_ROUTEID | 실측[T-9374e9e4]: 검사기(syn_check.py·fixture dberr)는 있으나 이 대상(SP)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(syn_check.py·fixture dberr)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7)
- T-e3d3d7ca [TRACE] SCP0005_SAVE_DISTRIBUTION_ROUTE | 실측[T-e3d3d7ca]: 검사기(syn_check.py·fixture dberr)는 있으나 이 대상(SP)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(syn_check.py·fixture dberr)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7)

### 검사기공백 · 규칙 E1 · 18행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-0267c456 [COLUMN] route.LT_SUM (Sum) |  | [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W
- V-031c14fe [COLUMN] POPUP.LT_VOYAGE (Voyage) | [입력 경로 실패] LT_VOYAGE r0: 유효값 '1' 이 편집기·키보드 모두 들어가지 않음 — 규칙 밖 값 거부를 판정할 수 없음(입력 안 됨('0'→'0' · 더블클릭 뒤 포커스 INPUT:0))
- V-0bbe47b0 [COLUMN] Distribution Route.LT_SUM (Total L/T) |  | [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W
- V-1695d2c6 [COLUMN] Distribution Route.Two_SEGMENT_COST (Freight Cost) |  | [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W
- V-37908d70 [COLUMN] route.LT_ARRIVAL_INLAND (Arrival Inland) | [입력 경로 실패] LT_ARRIVAL_INLAND r0: 유효값 '1' 이 편집기·키보드 모두 들어가지 않음 — 규칙 밖 값 거부를 판정할 수 없음(입력 안 됨('0'→'0' · 더블클릭 뒤 포커스 INPUT:0))
- V-52fae0d0 [COLUMN] route.LT_VOYAGE (Sea/Air Ferry) | [입력 경로 실패] LT_VOYAGE r0: 유효값 '1' 이 편집기·키보드 모두 들어가지 않음 — 규칙 밖 값 거부를 판정할 수 없음(입력 안 됨('0'→'0' · 더블클릭 뒤 포커스 INPUT:0))
- V-7255622e [COLUMN] Distribution Route.LT_LAY_OFF_CLEARANCE (Lay Off/Customs Clearance) | [입력 경로 실패] LT_LAY_OFF_CLEARANCE r0: 유효값 '1' 이 편집기·키보드 모두 들어가지 않음 — 규칙 밖 값 거부를 판정할 수 없음(입력 안 됨('0'→'0' · 더블클릭 뒤 포커스 INPUT:0))
- V-7c5eafbc [COLUMN] route.LT_WAIT_SHIPPING (Waiting For Shipping) | [입력 경로 실패] LT_WAIT_SHIPPING r0: 유효값 '1' 이 편집기·키보드 모두 들어가지 않음 — 규칙 밖 값 거부를 판정할 수 없음(입력 안 됨('0'→'0' · 더블클릭 뒤 포커스 INPUT:0))
- V-83f0ce16 [COLUMN] route.LT_LAY_OFF_CLEARANCE (Lay Off/Customs Clearance) | [입력 경로 실패] LT_LAY_OFF_CLEARANCE r0: 유효값 '1' 이 편집기·키보드 모두 들어가지 않음 — 규칙 밖 값 거부를 판정할 수 없음(입력 안 됨('0'→'0' · 더블클릭 뒤 포커스 INPUT:0))
- V-85979f1f [COLUMN] Distribution Route.LT_VOYAGE (Voyage) | [입력 경로 실패] LT_VOYAGE r0: 유효값 '1' 이 편집기·키보드 모두 들어가지 않음 — 규칙 밖 값 거부를 판정할 수 없음(입력 안 됨('0'→'0' · 더블클릭 뒤 포커스 INPUT:0))
- V-901f78dd [COLUMN] POPUP.LT_LAY_OFF_CLEARANCE (Lay Off/Customs Clearance) | [입력 경로 실패] LT_LAY_OFF_CLEARANCE r0: 유효값 '1' 이 편집기·키보드 모두 들어가지 않음 — 규칙 밖 값 거부를 판정할 수 없음(입력 안 됨('0'→'0' · 더블클릭 뒤 포커스 INPUT:0))
- V-a16c3b7e [COLUMN] POPUP.LT_ARRIVAL_INLAND (Arrival Inland) | [입력 경로 실패] LT_ARRIVAL_INLAND r0: 유효값 '1' 이 편집기·키보드 모두 들어가지 않음 — 규칙 밖 값 거부를 판정할 수 없음(입력 안 됨('0'→'0' · 더블클릭 뒤 포커스 INPUT:0))
- 외 6행(unverified_triage.csv)

### 검사기공백 · 규칙 E4 · 8행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-2c4e7c8a [TRACE] MSG00265 | MSG00265 — btnEaxel_Upload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btnEaxel_Upload_Click)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-6a512ae5 [TRACE] MSG00209 | MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(spdMainDataModel_Changed)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-dba493fd [TRACE] MSG00209 | MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(spdMainDataModel_Changed)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-e19b6757 [TRACE] MSG00265 | MSG00265 — btnEaxel_Upload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btnEaxel_Upload_Click)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-eea49685 [TRACE] LT_ARRIVAL_INLAND / Arrival Inland | MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(spdMainDataModel_Changed)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-3e95d2be [ASIS] MSG00209 | MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(spdMainDataModel_Changed)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-4a0b6271 [ASIS] MSG00265 | MSG00265 — btnEaxel_Upload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btnEaxel_Upload_Click)에서 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-b3450ff5 [RULE_SCREEN] SCP0005 키 중복 신규행 |  | [미검증] 검사기(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 

### 검사기공백 · 규칙 F1 · 3행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-26d2974c [RULE_SCREEN] SCP0005 2행 동시 저장 |  | [미검증] 검사기(_verify.spec(@verify) 실저장·crud spec)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify) 실저장·crud spec)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify) 실저장·crud 
- V-4e4af2a4 [RULE_SCREEN] SCP0005 컬럼별 저장 왕복 |  | [미검증] 검사기(_verify.spec(@verify) 실저장·crud spec)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify) 실저장·crud spec)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify) 실저장·crud 
- V-c9c3b04a [RULE_SCREEN] SCP0005 화면 | [측정 경로 누락] 빈 키 없음(신규행 경로 무효) · 초기 {"ROUTE_ID":""}: 키 값 없음 ['ROUTE_ID'] · 추천 0건 → 수정 저장 경로: 편집 가능 셀 없음(전 컬럼 잠금 또는 조회 행 0 · 계정 그룹 권한 확인) — 저장 검사 미실행 · 수정 저장 경로 강제(edit-save) · 편집 가능 셀 24개 시도 — 값이 바뀌는 셀 없음

### 검사기공백 · 규칙 F2 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-c3ce3016 [RULE_SCREEN] SCP0005 화면 | [측정 경로 누락] 빈 키 없음(신규행 경로 무효) · 초기 {"ROUTE_ID":""}: 키 값 없음 ['ROUTE_ID'] · 추천 0건 → 수정 저장 경로: 편집 가능 셀 없음(전 컬럼 잠금 또는 조회 행 0 · 계정 그룹 권한 확인) — 저장 검사 미실행 · 수정 저장 경로 강제(edit-save) · 편집 가능 셀 24개 시도 — 값이 바뀌는 셀 없음

### 검사기공백 · 규칙 F3 · 9행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-3d0ea655 [RULE_SCREEN] SCP0005 시나리오 [자동] DAYS_SUN 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사 | [측정 경로 없음] [자동] DAYS_SUN 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사: 값 토큰 @copy:out 해석 실패(값 없음) — 이 행 후보 1건 밖 값을 가진 기존 행 없음 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:8036행·신규0·호출2·요청8 → paste:8037행·신규1·호출
- V-5804ccc8 [RULE_SCREEN] SCP0005 시나리오 [자동] DAYS_TUE 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사 | [측정 경로 없음] [자동] DAYS_TUE 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사: 값 토큰 @copy:out 해석 실패(값 없음) — 이 행 후보 1건 밖 값을 가진 기존 행 없음 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:8036행·신규0·호출2·요청8 → paste:8037행·신규1·호출
- V-5a4e9648 [RULE_SCREEN] SCP0005 시나리오 [자동] DAYS_WED 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사 | [측정 경로 없음] [자동] DAYS_WED 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사: 값 토큰 @copy:out 해석 실패(값 없음) — 이 행 후보 1건 밖 값을 가진 기존 행 없음 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:8036행·신규0·호출2·요청8 → paste:8037행·신규1·호출
- V-6f2db8d3 [RULE_SCREEN] SCP0005 시나리오 [자동] TRANSPORT_MODE 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사 | [측정 경로 없음] [자동] TRANSPORT_MODE 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사: 값 토큰 @copy:out 해석 실패(값 없음) — 이 행 후보 4건 밖 값을 가진 기존 행 없음 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:8036행·신규0·호출2·요청8 → paste:8037행·
- V-753a87af [RULE_SCREEN] SCP0005 시나리오 [자동] DAYS_FRI 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사 | [측정 경로 없음] [자동] DAYS_FRI 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사: 값 토큰 @copy:out 해석 실패(값 없음) — 이 행 후보 1건 밖 값을 가진 기존 행 없음 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:8036행·신규0·호출2·요청8 → paste:8037행·신규1·호출
- V-7ac42873 [RULE_SCREEN] SCP0005 시나리오 [자동] DAYS_THU 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사 | [측정 경로 없음] [자동] DAYS_THU 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사: 값 토큰 @copy:out 해석 실패(값 없음) — 이 행 후보 1건 밖 값을 가진 기존 행 없음 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:8036행·신규0·호출2·요청8 → paste:8037행·신규1·호출
- V-ba8f9817 [RULE_SCREEN] SCP0005 시나리오 [자동] DAYS_MON 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사 | [측정 경로 없음] [자동] DAYS_MON 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사: 값 토큰 @copy:out 해석 실패(값 없음) — 이 행 후보 1건 밖 값을 가진 기존 행 없음 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:8036행·신규0·호출2·요청8 → paste:8037행·신규1·호출
- V-cb7ed54f [RULE_SCREEN] SCP0005 시나리오 [자동] DAYS_SAT 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사 | [측정 경로 없음] [자동] DAYS_SAT 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사: 값 토큰 @copy:out 해석 실패(값 없음) — 이 행 후보 1건 밖 값을 가진 기존 행 없음 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:8036행·신규0·호출2·요청8 → paste:8037행·신규1·호출
- V-d8ff8497 [RULE_SCREEN] SCP0005 시나리오 [자동] VALID_YN 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사 | [측정 경로 없음] [자동] VALID_YN 기존 행 셀 Copy → 신규 행 붙여넣기 — 후보 밖 값(비활성 등) 행에서 복사: 값 토큰 @copy:out 해석 실패(값 없음) — 이 행 후보 1건 밖 값을 가진 기존 행 없음 · 저장 요청 0 · 편집기 null · search:0행·신규0·호출1·요청6 → insert:8036행·신규0·호출2·요청8 → paste:8037행·신규1·호출

### 검사기공백 · 규칙 F4 · 5행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-719d403c [TRACE] SCP0005_GET_DISTRIBUTION_ROUTEID | SCP0005_GET_DISTRIBUTION_ROUTEID: SCP0005/route/SEARCH_ROUTEID — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리오에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-829cf301 [TRACE] PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY | PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY: SCP0005/route/SEARCH_CITY — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리오에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-ea530cd5 [TRACE] SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID: SCP0005/route/SEARCH_ROUTEID — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시나리오에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-9c62f0b4 [RULE_SCREEN] SCP0005 화면 | [측정 경로 누락] 빈 키 없음(신규행 경로 무효) · 초기 {"ROUTE_ID":""}: 키 값 없음 ['ROUTE_ID'] · 추천 0건 → 수정 저장 경로: 편집 가능 셀 없음(전 컬럼 잠금 또는 조회 행 0 · 계정 그룹 권한 확인) — 저장 검사 미실행 · 수정 저장 경로 강제(edit-save) · 편집 가능 셀 24개 시도 — 값이 바뀌는 셀 없음
- V-be38da4d [RULE_SCREEN] SCP0005 경계값 저장 | [측정 경로 누락] 빈 키 없음(신규행 경로 무효) · 초기 {"ROUTE_ID":""}: 키 값 없음 ['ROUTE_ID'] · 추천 0건 → 수정 저장 경로: 편집 가능 셀 없음(전 컬럼 잠금 또는 조회 행 0 · 계정 그룹 권한 확인) — 저장 검사 미실행 · 수정 저장 경로 강제(edit-save) · 편집 가능 셀 24개 시도 — 값이 바뀌는 셀 없음

### 검사기공백 · 규칙 F6 · 4행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-337cb2f9 [RULE_SCREEN] SCP0005 저장 행 수 불변 |  | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W
- V-7116d2aa [RULE_SCREEN] SCP0005 0 값 저장 |  | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W
- V-72fbb5b2 [RULE_SCREEN] SCP0005 빈값 저장 |  | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W
- V-77a721bf [RULE_SCREEN] SCP0005 화면 | [측정 경로 누락] 빈 키 없음(신규행 경로 무효) · 초기 {"ROUTE_ID":""}: 키 값 없음 ['ROUTE_ID'] · 추천 0건 → 수정 저장 경로: 편집 가능 셀 없음(전 컬럼 잠금 또는 조회 행 0 · 계정 그룹 권한 확인) — 저장 검사 미실행 · 수정 저장 경로 강제(edit-save) · 편집 가능 셀 24개 시도 — 값이 바뀌는 셀 없음

### 검사기공백 · 규칙 F7 · 3행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-7b5ef8a4 [RULE_SCREEN] SCP0005 저장 연계·이력 표 |  | [미검증] 검사기(tools/Harness/verify/save_audit.py(CRUD 실제 저장 정리 백업 ↔ AS-IS )가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(tools/Harness/verify/save_audit.py(CRUD 실제 저장 정리 백업 ↔ AS-IS )가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 
- V-7e3ffe10 [RULE_SCREEN] SCP0005 2회 저장 행 수 |  | [미검증] 검사기(tools/Harness/verify/save_audit.py(CRUD 실제 저장 정리 백업 ↔ AS-IS )가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(tools/Harness/verify/save_audit.py(CRUD 실제 저장 정리 백업 ↔ AS-IS )가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 
- V-96cee22e [RULE_SCREEN] SCP0005 저장 연계 테이블 |  | [미검증] 검사기(tools/Harness/verify/save_audit.py(CRUD 실제 저장 정리 백업 ↔ AS-IS )가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(tools/Harness/verify/save_audit.py(CRUD 실제 저장 정리 백업 ↔ AS-IS )가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 

### 검사기공백 · 규칙 F8 · 3행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-4bee5c9b [RULE_SCREEN] SCP0005 수정 감사 컬럼 |  | [미검증] 검사기(tools/Harness/verify/save_audit.py(정리 백업 루트 행 감사 컬럼 = 저장 계정·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(tools/Harness/verify/save_audit.py(정리 백업 루트 행 감사 컬럼 = 저장 계정·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 
- V-91dc58e6 [RULE_SCREEN] SCP0005 이력 행 값 |  | [미검증] 검사기(tools/Harness/verify/save_audit.py(정리 백업 루트 행 감사 컬럼 = 저장 계정·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(tools/Harness/verify/save_audit.py(정리 백업 루트 행 감사 컬럼 = 저장 계정·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 
- V-a8518547 [RULE_SCREEN] SCP0005 저장 감사 필드 |  | [미검증] 검사기(tools/Harness/verify/save_audit.py(정리 백업 루트 행 감사 컬럼 = 저장 계정·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(tools/Harness/verify/save_audit.py(정리 백업 루트 행 감사 컬럼 = 저장 계정·)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 

### 검사기공백 · 규칙 G4 · 3행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-7e1a41bb [TRACE] btnToSrch | [측정 경로 없음] AS-IS btnToSrch 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인)
- T-85f3a8bb [TRACE] btnFromSrch | [측정 경로 없음] AS-IS btnFromSrch 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인)
- T-eb5343b6 [TRACE] btnEaxel | [측정 경로 없음] AS-IS btnEaxel 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인)

### 검사기공백 · 규칙 G5 · 12행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-3beee65f [TRACE] FROM_CITY_NAME / City Name | 실측[T-3beee65f]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하
- T-438facd0 [TRACE] txtToCity / To City | 실측[T-438facd0]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COND)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행
- T-7be01876 [TRACE] TO_CITY / City | 실측[T-7be01876]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하
- T-9a728188 [TRACE] txtFromCity / From City | 실측[T-9a728188]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COND)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행
- T-a391f109 [TRACE] TO_CITY_NAME / City Name | 실측[T-a391f109]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하
- T-c1fcf050 [TRACE] txtFromCountry / From Country | 실측[T-c1fcf050]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COND)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행
- T-cd3710ae [TRACE] txtToCountry / To Country | 실측[T-cd3710ae]: 검사기(popup_args_check.py · _verify.spec(@verify))는 있으나 이 대상(COND)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행
- V-2e28bbf0 [ASIS] popCity.Form_Load(true, sCountry, sCity) |  | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(popup_args_chec
- V-595a9098 [ASIS] popCity.ShowDialog() |  | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(popup_args_chec
- V-a6bb7234 [ASIS] frm.ShowDialog() |  | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(popup_args_chec
- V-b16a17a1 [ASIS] popCity.Form_Load(true, sCountry, sCity) |  | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(popup_args_chec
- V-c6dd7839 [ASIS] popCity.ShowDialog() |  | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(popup_args_chec

### 검사기공백 · 규칙 H2 · 11행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-06e7dec2 [ASIS] FROM_CITY_NAME,FROM_CITY | [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 8036행 중 조건 만족 0행 · 평가 불가 8036행 — 조건 RAW(iCount > 0) && !(RAW(response.DataSet.Tables[0].Rows[0][0].ToS
- V-0810a59e [ASIS] FROM_CITY | [측정 경로 없음] 조건 만족 행에 값 있는 기간 칸 없음 · AS-IS SCP0005_DistributionRoute:1278 SetBGColor 편집 모드 색 UnLockColor(조회 모드 UnLockColor) · 조건 TRUE · 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP 
- V-17e451a7 [ASIS] FROM_CITY | [측정 경로 없음] 조건 FALSE 을 만족하는 계정·Division 조합 없음(계정 minyonglee1/jooyong026/dana.robot · Division 후보 40)
- V-b4651880 [ASIS] siMain.SetBGColor | [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 8036행 중 조건 만족 0행 · 평가 불가 8036행 — 조건 RAW(intPRIORITY < 1)
- V-b6f27092 [ASIS] LT_TYPE,TRANSPORT_MODE | [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 8036행 중 조건 만족 0행 · 평가 불가 8036행 — 조건 RAW(iCount > 0) && !(RAW(response.DataSet.Tables[0].Rows[0][0].ToS
- V-bc631885 [ASIS] D_PORT_NAME,TO_CITY | [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 8036행 중 조건 만족 0행 · 평가 불가 8036행 — 조건 RAW(iCount > 0) && !(RAW(response.DataSet.Tables[0].Rows[0][0].ToS
- V-c099fa4f [ASIS] TO_CITY | [측정 경로 없음] 조건 만족 행에 값 있는 기간 칸 없음 · AS-IS SCP0005_DistributionRoute:1279 SetBGColor 편집 모드 색 UnLockColor(조회 모드 UnLockColor) · 조건 TRUE · 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP 
- V-c56bdc72 [ASIS] siMain.SetBGColor | [측정 경로 없음] 조건 만족 행에 값 있는 기간 칸 없음 · AS-IS SCP0005_DistributionRoute:1276 SetBGColor 편집 모드 색 UnLockColor(조회 모드 UnLockColor) · 조건 TRUE · 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP 
- V-dc54eed4 [ASIS] TO_CITY_NAME,TO_CITY | [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 8036행 중 조건 만족 0행 · 평가 불가 8036행 — 조건 RAW(iCount > 0) && !(RAW(response.DataSet.Tables[0].Rows[0][0].ToS
- V-e63ff383 [ASIS] TO_CITY | [측정 경로 없음] 조건 FALSE 을 만족하는 계정·Division 조합 없음(계정 minyonglee1/jooyong026/dana.robot · Division 후보 40)
- V-fa71e89c [ASIS] PRIORITY,PRIORITY | [측정 경로 없음] 계정 minyonglee1(그룹 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/DM Viewer/JV Planner/SCP Planner) · Div 40 조회 8036행 중 조건 만족 0행 · 평가 불가 8036행 — 조건 RAW(iCount > 0) && !(RAW(response.DataSet.Tables[0].Rows[0][0].ToS

### 검사기공백 · 규칙 H6 · 10행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-117d4f08 [TRACE] txtToCountry / To Country | 실측[T-117d4f08]: 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7)
- T-709cb183 [TRACE] TO_CITY / City | 실측[T-709cb183]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작
- T-7eacee67 [TRACE] FROM_CITY_NAME / City Name | 실측[T-7eacee67]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작
- T-cdb32d07 [TRACE] txtFromCountry / From Country | 실측[T-cdb32d07]: 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7)
- T-e425f595 [TRACE] TO_CITY_NAME / City Name | 실측[T-e425f595]: 검사기(_verify.spec(@verify)·smoke popup)는 있으나 이 대상(COL)을 실행하는 경로 없음 — 검증 엔진 연결 필요(@trace 또는 ledger.py 항목 생성) | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작
- V-0e9099ba [ASIS] new GSCM.SCM.PopUp.UIL.SCP0005_DistributionRoutePopup() | 팝업이 열리지 않아 표준 확인 불가(G5 행 참고) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-4cfc72f5 [ASIS] popup.ShowDialog() | 팝업이 열리지 않아 표준 확인 불가(G5 행 참고) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-616b4d31 [ASIS] popCity.Form_Load(true, sCountry, sCity) |  | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가
- V-718e1a16 [ASIS] popCity.Form_Load(true, sCountry, sCity) |  | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가
- V-e14533b1 [ASIS] frm.ShowDialog() |  | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가

### 검사기공백 · 규칙 I1 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-38472e83 [RULE_SCREEN] SCP0005 시나리오 [자동] KO 언어 · 변경 없이 저장 → KO 수정사항 없음 알림 | [측정 경로 없음] [자동] KO 언어 · 변경 없이 저장 → KO 수정사항 없음 알림: [측정 경로 없음] 다른 화면 E2E 동시 실행(SSP0005) — 계정 언어 전환 생략(T200) · 저장 요청 0 · 편집기 null · lang:0행·신규0·호출1·요청8 → 끝:0행·신규0·호출1·요청8 · 문서 자동 생성 P01 · btn_auth SAVE

### 검사기공백 · 규칙 I2 · 2행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- EG-4431808c [RULE_SCREEN] SCP0005 언어 전환 EN | [측정 경로 없음] [측정 경로 없음] 다른 화면 E2E 동시 실행(SCP0028,SSP0005) — 계정 언어 전환이 그 화면 측정을 오염시켜 전환 생략(T200)
- EG-928e0116 [RULE_SCREEN] SCP0005 언어 전환 KO | [측정 경로 없음] [측정 경로 없음] 다른 화면 E2E 동시 실행(SCP0028,SSP0005) — 계정 언어 전환이 그 화면 측정을 오염시켜 전환 생략(T200)

### 검사기공백 · 규칙 I3 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-5a7b8946 [RULE_SCREEN] SCP0005 화면 | [측정 코드 없음] 언어 전환 비교 미구현 — 명칭 컬럼 FROM_CITY_NAME,D_PORT_NAME,A_PORT_NAME,TO_CITY_NAME 표본 50건 중 한글 0(참고값 · 판정 근거 아님, 종전엔 무조건 PASS 였음 2026-10-31)

### 검사기공백 · 규칙 J4 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정 · 입력 경로 실패 = 칸 설정·편집기 실측 · PARTIAL = 측정 못 한 칸의 원문 근거 확인(2026-11-19 SCP0096 F6·J4)
- V-ecd963f8 [DEFECT] 그룹ID별 메뉴·버튼 권한(MENU AUTH · BTN AUTH) 운영데이터 동기화 | 그룹별 메뉴·버튼 권한 대조 2026-11-19 17:06:38: PARTIAL — 그룹 15↔15 · ADMIN U→EDIT: TO-BE 메뉴에 EDIT 버튼 정의 없음; SCM PI Admin U→EDIT: TO-BE 메뉴에 EDIT 버튼 정의 없음; SSP Planner U→EDIT: TO-BE 메뉴에 EDIT 버튼 정의 없음 · AS-IS 그룹 {'ADMIN': 'CRUD', 'CAP

### 검사기공백 · 규칙 L1 · 1행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-f16ab22d [RULE_SCREEN] SCP0005 저장 응답 시간 |  | [미검증] 검사기(_trace.spec(@trace) W4d 조회 응답시간)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_trace.spec(@trace) W4d 조회 응답시간)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_trace.spec(@trace) W4d 조회 응답시간)가 이 대상을

### 검사기공백 · 규칙 M1 · 4행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- V-219edc76 [CONFIRMED] Excel Upload Validation 메시지(Sales Site/Project/Model) | [측정 코드 없음] Excel Upload 버튼 있음 [KOR | 이 이민용 | Home | Distribution Route | Scroll tabs left | Scroll tabs right | Close others | Close All | Full screen | Open | Search(F5) | Excel Form | Excel Upload | Insert(F8) | Delete
- V-57e814bb [CONFIRMED] Excel Upload 컬럼명 검증 메시지 · 파일 첨부 개수 | [측정 코드 없음] Excel Upload 버튼 있음 [KOR | 이 이민용 | Home | Distribution Route | Scroll tabs left | Scroll tabs right | Close others | Close All | Full screen | Open | Search(F5) | Excel Form | Excel Upload | Insert(F8) | Delete
- V-98e969ba [CONFIRMED] Excel Upload 헤더 검증 메시지 | [측정 코드 없음] Excel Upload 버튼 있음 [KOR | 이 이민용 | Home | Distribution Route | Scroll tabs left | Scroll tabs right | Close others | Close All | Full screen | Open | Search(F5) | Excel Form | Excel Upload | Insert(F8) | Delete
- V-a32c8abf [CONFIRMED] Excel Form 버튼 | [측정 코드 없음] Excel Upload 버튼 있음 [KOR | 이 이민용 | Home | Distribution Route | Scroll tabs left | Scroll tabs right | Close others | Close All | Full screen | Open | Search(F5) | Excel Form | Excel Upload | Insert(F8) | Delete

### 검사기공백 · 규칙 M3 · 2행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-6d14c72c [TRACE] SCP0005_DistributionRoutePopup | [검사기 미검증] ROUTE_ID 더블클릭 → 팝업 열림 감지 실패
- V-a46588cb [ASIS] new GSCM.SCM.PopUp.UIL.SCP0005_DistributionRoutePopup() |  | [미검증] 검사기(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) )가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) )가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 

### 데이터전제 · 규칙 J1 · 2행
- 처리: 검사기가 조회조건·Division·행 선택을 바꿔 측정 전제를 만족시키도록 보완(ensureRows 계열 · 전 후보 순회)
- ES-0967e6d0 [RULE_SCREEN] SCP0005 E2E auth Division 40 조회 · 계정 40:ADMIN,81:ADMIN,82:ADMIN | [측정 전제 미충족] Division 40 선택 못 함 · 40 set=false rows=8036 alert=
- ES-fe8e48bc [RULE_SCREEN] SCP0005 E2E auth Division 40 조회 · 계정 40:SCP Planner | [측정 전제 미충족] Division 40 선택 못 함 · 40 set=false rows=8036 alert=

### 데이터전제 · 규칙 K1 · 1행
- 처리: 검사기가 조회조건·Division·행 선택을 바꿔 측정 전제를 만족시키도록 보완(ensureRows 계열 · 전 후보 순회)
- V-fe05fe48 [RULE_SCREEN] SCP0005 필터 편집기 항목 | [측정 경로 없음] 조회 0행

### 미분류 · 규칙 B3 · 4행
- 처리: 분류표(unverified_classes.csv)에 유형 정규식을 더하고 원인에 맞게 검사기 보완
- EG-2b3aaac3 [RULE_SCREEN] SCP0005 팝업 (TO-BE 메타 팝업) CELL:FROM_COUNTRY ORDER | 기대 팝업 목록 순서 = AS-IS ORDER BY · 실제 AS-IS 조회 SP 원문 없음() · 근거 
- EG-3ef59312 [RULE_SCREEN] SCP0005 팝업 (TO-BE 메타 팝업) CELL:FROM_CITY ORDER | 기대 팝업 목록 순서 = AS-IS ORDER BY · 실제 AS-IS 조회 SP 원문 없음() · 근거 
- EG-d26067ce [RULE_SCREEN] SCP0005 팝업 (TO-BE 메타 팝업) CELL:TO_CITY ORDER | 기대 팝업 목록 순서 = AS-IS ORDER BY · 실제 AS-IS 조회 SP 원문 없음() · 근거 
- EG-da97889a [RULE_SCREEN] SCP0005 팝업 (TO-BE 메타 팝업) CELL:TO_COUNTRY ORDER | 기대 팝업 목록 순서 = AS-IS ORDER BY · 실제 AS-IS 조회 SP 원문 없음() · 근거 

### 미분류 · 규칙 C3 · 4행
- 처리: 분류표(unverified_classes.csv)에 유형 정규식을 더하고 원인에 맞게 검사기 보완
- T-38e03b62 [TRACE] TO_COUNTRY / Country | [전제 미충족 T300] TO_COUNTRY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가
- T-5edb7122 [TRACE] FROM_CITY / City | [전제 미충족 T300] FROM_CITY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가
- T-653f2a16 [TRACE] TO_CITY / City | [전제 미충족 T300] TO_CITY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가
- T-b82f895f [TRACE] FROM_COUNTRY / Country | [전제 미충족 T300] FROM_COUNTRY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가

### 미분류 · 규칙 G1 · 1행
- 처리: 분류표(unverified_classes.csv)에 유형 정규식을 더하고 원인에 맞게 검사기 보완
- V-43efa55d [SEARCH] 조회조건 Trans Mode | [멀티선택 Trans Mode] 'RAIL' 1개 선택 조회 → 41행 · TRANSPORT_MODE 값 조건 밖 1종(RAI) (기본 ALL 8036행) · 조회 요청 0건 · 조건 칸 표시 'RAIL' · 결과 컬럼 TRANSPORT_MODE 값에서 고를 후보를 못 찾아 임의 후보 선택 — [측정 실패] 선택 후 조회 요청이 나가지 않음(알림·필수 조건으로 조회 차단 가능) — 조건 반영

### 미분류 · 규칙 G4 · 8행
- 처리: 분류표(unverified_classes.csv)에 유형 정규식을 더하고 원인에 맞게 검사기 보완
- EG-230569d4 [RULE_SCREEN] SCP0005 팝업 (TO-BE 메타 팝업) CELL:TO_CITY COND_LIST | 기대 AS-IS 조건 칸 ↔ TO-BE · 실제 AS-IS 원문을 찾지 못함 · 근거 
- EG-5682aaf9 [RULE_SCREEN] SCP0005 팝업 (TO-BE 메타 팝업) CELL:FROM_COUNTRY COND_LIST | 기대 AS-IS 조건 칸 ↔ TO-BE · 실제 AS-IS 원문을 찾지 못함 · 근거 
- EG-607e32f7 [RULE_SCREEN] SCP0005 팝업 (TO-BE 메타 팝업) CELL:FROM_CITY COND_LIST | 기대 AS-IS 조건 칸 ↔ TO-BE · 실제 AS-IS 원문을 찾지 못함 · 근거 
- EG-976c38c8 [RULE_SCREEN] SCP0005 팝업 (TO-BE 메타 팝업) CELL:TO_COUNTRY COND_LIST | 기대 AS-IS 조건 칸 ↔ TO-BE · 실제 AS-IS 원문을 찾지 못함 · 근거 
- T-6d65f303 [TRACE] txtToCountry / To Country | r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증)
- T-88891164 [TRACE] txtFromCity / From City | r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증)
- T-90d2d30f [TRACE] txtToCity / To City | r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증)
- T-9b463365 [TRACE] txtFromCountry / From Country | r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증)

### 미분류 · 규칙 K3 · 3행
- 처리: 분류표(unverified_classes.csv)에 유형 정규식을 더하고 원인에 맞게 검사기 보완
- V-36b6c266 [GENERAL] [DMF0020 결함 유형] Exchange Rate 그리드 Copy·Header Hide Column | copy PASS: 선택 0,1,0,1 · 0행 LT_TYPE 표시값 'AVERAGE' · Ctrl+C 클립보드 'AVERAGE'(일치) · 우클릭 Copy 'AVERAGE'(일치) | hide PASS: 헤더(FROM_CITY_NAME) 우클릭 → Hide Column → 컬럼 비표시 · Unhide All 복원 · 필수 컬럼 LT_TYPE 은 Hide Column 비활성(숨김 금지 규칙)
- V-57cbc36c [DEFECT] 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | f5 PASS: F5 → 조회 호출 1건(SEARCH) · 페이지 이동 0회 · 미포함: 팝업 그리드(이 시험은 메인 그리드만), Sort/Filter·정렬 후 동작(K1 smoke 행) → 실측 범위 PASS · 미포함 항목은 수동 검수 대상(작업 원장 W7)
- V-8fd091cc [GENERAL] [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | K3 조작 실측(이 행 문구는 Ctrl·헤더·Copy·Hide·F5 외 — Sort/Filter 동적 컬럼·팝업 No.·붙여넣기 등 별도 확인): copy PASS: 선택 0,1,0,1 · 0행 LT_TYPE 표시값 'AVERAGE' · Ctrl+C 클립보드 'AVERAGE'(일치) · 우클릭 Copy 'AVERAGE'(일치) | ctrl PASS: Ctrl+클릭 0행·2행(LT_TYPE) 

### 미분류 · 규칙 M3 · 1행
- 처리: 분류표(unverified_classes.csv)에 유형 정규식을 더하고 원인에 맞게 검사기 보완
- EG-6a0f18bc [RULE_SCREEN] SCP0005 팝업 ExcelUploadForm2 BTN:Upload OPEN | 기대 AS-IS btnEaxel_Upload_Click 팝업(ExcelUploadForm2) 열림 · 실제 BTN: 버튼 [Upload/Upload/Eaxel_Upload] 비노출 — 화면 버튼 [KOR, 이 이민용, Home, Distribution Route, Close others, Close All, Search(F5), Excel Form, Excel Upload, Insert(F8

### 미분류 · 규칙 M4 · 4행
- 처리: 분류표(unverified_classes.csv)에 유형 정규식을 더하고 원인에 맞게 검사기 보완
- T-26aaaaf4 [TRACE] txtToCity / To City | r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증)
- T-3d44d32d [TRACE] txtFromCountry / From Country | r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증)
- T-47ab9353 [TRACE] txtFromCity / From City | r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증)
- T-ef2618be [TRACE] txtToCountry / To Country | r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증)

## 담당 판단 (120행)

### 판단 · 규칙 A7 · 1행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- V-6e159871 [SP] SCP0005_GET_DISTRIBUTION_ROUTE | 공통 컬럼 41 중 공란 컬럼 0 · 확인 필요 5 — a_port_name: 같은 키(routeid) 8036행 중 8행 값 다름(0%) 예: 662: ''↔'/' / 2444: ''↔'/' | shipping_company: 같은 키(routeid) 8036행 중 334행 값 다름(4%) 예: 27: ''↔'/' / 43: ''↔'/' | last_updated_by: 같은 키(route

### 판단 · 규칙 B4 · 3행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- V-5bcb735c [COLUMN] Distribution Route.LT_TYPE (L/T Type*) | [신규행()] AS-IS 0건 vs TO-BE 3건 · 차이 3건 설명 불가: AVERAGE: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); MIN: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); MAX: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음) · AS-IS만 0 [] · TO-BE만 3 ['AVERA
- V-82d97d20 [COLUMN] Distribution Route.TRANSPORT_MODE (Trans Mode*) | [신규행()] AS-IS 0건 vs TO-BE 5건 · 차이 5건 설명 불가: AIR: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); FRY: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); TRK: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); SEA: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증
- V-afc23080 [COLUMN] route.LT_TYPE (L/T Type) | [신규행()] AS-IS 0건 vs TO-BE 3건 · 차이 3건 설명 불가: AVERAGE: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); MIN: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); MAX: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음) · AS-IS만 0 [] · TO-BE만 3 ['AVERA

### 판단 · 규칙 C2 · 20행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- T-23ec1123 [TRACE] LT_VOYAGE / Voyage | LT_VOYAGE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-31aa93b0 [TRACE] LT_ARRIVAL_INLAND / Arrival Inland | LT_ARRIVAL_INLAND 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-46b9927d [TRACE] LT_WAIT_SHIPPING / Waiting For Shipping | LT_WAIT_SHIPPING 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-58285076 [TRACE] DAYS_WED / Wed | TRANSPORT_MODE='AIR' → DAYS_WED 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_WED 후보 2건 · TRANSPORT_MODE='TRUCK' → DAYS_WED 후보 2건 · TRANSPORT_MODE='SEA' → DAYS_WED 후보 2건 · TRANSPORT_MODE='RAIL' → DAYS_WED 후보 2건 — 원천 값과 무관하게 후보 동
- T-6a6f8160 [TRACE] A_PORT_CODE / Port Code | A_PORT_CODE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-6e161066 [TRACE] A_COUNTRY / Country | A_COUNTRY 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-6feb4248 [TRACE] LT_LAY_OFF_CLEARANCE / Lay Off/Customs Clearance | LT_LAY_OFF_CLEARANCE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-745157a9 [TRACE] SHIPPING_COMPANY / Forwarder | SHIPPING_COMPANY 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-765c437b [TRACE] LT_SUM / Total L/T | LT_SUM 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-83feba7d [TRACE] A_PORT_NAME / Port | A_PORT_NAME 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-840a1fc6 [TRACE] DAYS_SAT / Sat | TRANSPORT_MODE='AIR' → DAYS_SAT 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_SAT 후보 2건 · TRANSPORT_MODE='TRUCK' → DAYS_SAT 후보 2건 · TRANSPORT_MODE='SEA' → DAYS_SAT 후보 2건 · TRANSPORT_MODE='RAIL' → DAYS_SAT 후보 2건 — 원천 값과 무관하게 후보 동
- T-87cfd2b2 [TRACE] D_PORT_CODE / Port Code | D_PORT_CODE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- 외 8행(unverified_triage.csv)

### 판단 · 규칙 C3 · 2행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- T-0803d2d0 [TRACE] TO_CITY_NAME / City Name | TO_CITY_NAME: 원천 TO_CITY 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-1d878a60 [TRACE] FROM_CITY_NAME / City Name | FROM_CITY_NAME: 원천 TO_CITY/FROM_CITY 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 판단 · 규칙 C6 · 7행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- V-0adb17b9 [ASIS] dt.Rows[nRow][DefColumns.LT_SUM] | LT_ARRIVAL_INLAND='0' 더블클릭+Esc(값 변경 없음) → — 대상 값을 채우지 못해 판정 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-156b0f5d [ASIS] dt.Rows[nRow][DefColumns.LT_SUM] | LT_ARRIVAL_INLAND='0' 더블클릭+Esc(값 변경 없음) → — 대상 값을 채우지 못해 판정 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-5580d731 [ASIS] dt.Rows[nRow][DefColumns.LT_WAIT_SHIPPING] | LT_WAIT_SHIPPING='0' 더블클릭+Esc(값 변경 없음) → — 대상 값을 채우지 못해 판정 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-74b7f3ca [ASIS] dt.Rows[nRow][DefColumns.LT_VOYAGE] | LT_ARRIVAL_INLAND='0' 더블클릭+Esc(값 변경 없음) → — 대상 값을 채우지 못해 판정 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-94daba6e [ASIS] dt.Rows[nRow][DefColumns.LT_LAY_OFF_CLEARANCE] | LT_LAY_OFF_CLEARANCE='0' 더블클릭+Esc(값 변경 없음) → — 대상 값을 채우지 못해 판정 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-e99b3a48 [ASIS] dt.Rows[nRow][DefColumns.LT_DEPARTURE_INLAND] | LT_DEPARTURE_INLAND='999' 더블클릭+Esc(값 변경 없음) → — 대상 값을 채우지 못해 판정 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-eef89e27 [ASIS] dt.Rows[nRow][DefColumns.LT_ARRIVAL_INLAND] | LT_ARRIVAL_INLAND='0' 더블클릭+Esc(값 변경 없음) → — 대상 값을 채우지 못해 판정 불가 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 판단 · 규칙 D1 · 80행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- V-0c943a4c [COLUMN] POPUP.LAST_UPDATED_BY (Last Updated By) | 신규행 r0 LAST_UPDATED_BY 편집=false — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-0ca2a4ea [COLUMN] route.D_COUNTRY (Country) | 기존행 r0 D_COUNTRY 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-1619a565 [COLUMN] route.TO_CITY (City) | 기존행 r0 TO_CITY 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-16de807e [COLUMN] POPUP.LT_WAIT_SHIPPING (Waiting For Shipping) | 기존행 r0 LT_WAIT_SHIPPING 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-1afc1aeb [COLUMN] POPUP.LAST_UPDATE_DATE (Last Update Date) | 신규행 r0 LAST_UPDATE_DATE 편집=false — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-1bc44512 [COLUMN] route.D_COUNTRY (Country) | 신규행 r0 D_COUNTRY 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-1f11c130 [COLUMN] POPUP.DAYS_SAT (Sat) | 기존행 r0 DAYS_SAT 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-2144e9aa [COLUMN] POPUP.DAYS_MON (Mon) | 기존행 r0 DAYS_MON 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-222e2ec8 [COLUMN] POPUP.LT_LAY_OFF_CLEARANCE (Lay Off/Customs Clearance) | 기존행 r0 LT_LAY_OFF_CLEARANCE 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-2ad82300 [COLUMN] POPUP.LT_VOYAGE (Voyage) | 신규행 r0 LT_VOYAGE 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-2b51dd40 [COLUMN] POPUP.LT_DEPARTURE_INLAND (Departure Inland) | 기존행 r0 LT_DEPARTURE_INLAND 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- V-33598a73 [COLUMN] route.LT_WAIT_SHIPPING (Waiting For Shipping) | 신규행 r0 LT_WAIT_SHIPPING 편집=true — 기대: AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- 외 68행(unverified_triage.csv)

### 판단 · 규칙 E3 · 1행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- T-24a1a8c9 [TRACE] DAYS / Departure Days | AS-IS 필수 표시(grid_rule 라벨 *) 정보 없음 — TO-BE 필수=False → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 판단 · 규칙 E6 · 1행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- V-18c565cc [GENERAL] [DMF0049 결함 유형] 신규 입력 그리드(복사/붙여넣기·한글 입력·자동완성·병합 셀) | ime NA: 신규행 FROM_COUNTRY 선택(편집기 닫힘·포커스 DIV.wj-cell wj-state-selected wj-s) → IME 조합 '한글' → 편집기 '(안 열림)' · 셀 값 '' — 첫 타건에 조합 받을 입력칸 없음(실제 OS IME 에선 첫 글자가 영문으로 들어가는 원인) · 대조군(편집기 연 뒤 같은 조합) '한글' = 모사 유효 (CDP IME 모사 — OS IM

### 판단 · 규칙 H5 · 1행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- T-d786155a [TRACE] DAYS / Departure Days | DAYS 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 판단 · 규칙 H6 · 2행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- T-50c6a15b [TRACE] txtToCity / To City | E2E smoke cond popup / 실측[T-50c6a15b]: E2E smoke cond popup → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- T-fd52bd41 [TRACE] txtFromCity / From City | E2E smoke cond popup / 실측[T-fd52bd41]: E2E smoke cond popup → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 판단 · 규칙 M4 · 1행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- T-fce350f2 [TRACE] SCP0005_DistributionRoutePopup | 실측[T-fce350f2]: 검증 엔진이 실행됐으나 이 대상(POPUP SCP0005_DistributionRoutePopup)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

### 판단 · 규칙 MS1 · 1행
- 처리: 기계가 결론 못 낸 비교(헤더 글자 잘림·팝업 조회조건 구성 등) — TO-BE 룰 원장·AS-IS 원문으로 근거 확인 → 근거 있으면 판정 경로 보완 · 없으면 결정 목록
- V-e458f301 [MSG] MSG00265 | AS-IS MSG00265 '다시 조회하시겠습니까?' → 같은 문구의 TO-BE ID MSG01273 '다시 조회하시겠습니까?' — [AS-IS] MSG00265 '다시 조회하시겠습니까?' (SCP0005_DistributionRoute.cs:381 SCP0005_DistributionRoute.b) | [TO-BE 사용] MSG00265 'Excel 업로드가 완료되었습니다. 재조회합니다.'

## 담당 자동 (2행)

### 재실행 · 규칙 F1 · 2행
- 처리: 같은 조건으로 다시 측정(run_verify --only 규칙 · E2E 결과 없음은 e2e_suite)
- ES-836708a8 [RULE_SCREEN] SCP0005 E2E authcrud 저장 왕복(insert) jooyong026 | [측정 전제 미충족: 실행 예외] 저장 기능 판정 못 함 · mode=insert save=Y insert=Y delete=Y editable=- inserted=Y saved=N found=N updated=N cleaned=Y restored=Y saveCalls=0 · 예외: TimeoutError: locator.click: Timeout 5000ms exceeded. · 오류: Er
- ES-88905017 [RULE_SCREEN] SCP0005 E2E crud 저장 왕복(insert) | [측정 전제 미충족: 실행 예외] 저장 기능 판정 못 함 · mode=insert save=Y insert=Y delete=Y editable=- inserted=Y saved=N found=N updated=N cleaned=Y restored=Y saveCalls=0 · 예외: TimeoutError: locator.click: Timeout 5000ms exceeded. · 오류: Er

## 담당 사람 (1행)

### 스냅샷승인 · 규칙 K4 · 1행
- 처리: snap_validate.py 로 AS-IS 기대 대조 결과를 붙여 사용자 승인(snap_approve.py) 요청
- V-5daefe3f [RULE_SCREEN] SCP0005 스냅샷 버튼 Div 40 | [재실측 스냅샷 버튼] 골든 없음(승인 전) · 골든 없음 — 수신본 Doc\verify\SCP0005\snap\received\버튼_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 버튼 바 aria(13줄) · 보이는 버튼 KOR,이 이민용,Home,Distribution Route,Scroll tabs

## 담당 집계 (108행)

### 집계 · 규칙 A5 · 7행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-17ffc70f [TRACE] DB메타 구동(gridColumns=[]) · `staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Distri | 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 A5 16요소: PASS:15 · ERROR:1
- T-1df5459b [TRACE] COMMON:UC-07 · 필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns) | 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 A5 16요소: PASS:15 · ERROR:1
- T-4a09ea63 [TRACE] R7 조회 databind · `useTabProcQuery` o_rc1 | 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 A5 16요소: PASS:15 · ERROR:1
- 외 4행(unverified_triage.csv)

### 집계 · 규칙 B4 · 3행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-aadc4a90 [GENERAL] [DMF0082 결함 유형] FCST Type 후보 | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-5bcb735c] Distribution Route.LT_TYPE (L/T Type*): [신규행()] AS-IS 0건 vs TO-BE 3건 · 차이 3건 설명 불가: AVERAGE: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); MIN: 설명 불가(공통 후보 없음 — 마스터 조건 해석을
- V-c5224eb6 [GENERAL] [DMF0053 결함 유형] Biz Type·Plant Site 조건 후보 vs 결과 컬럼값 | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-5bcb735c] Distribution Route.LT_TYPE (L/T Type*): [신규행()] AS-IS 0건 vs TO-BE 3건 · 차이 3건 설명 불가: AVERAGE: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); MIN: 설명 불가(공통 후보 없음 — 마스터 조건 해석을
- V-fc76022a [GENERAL] [SYS0006 결함 유형] API Type 조회조건 | 규칙 B4 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-5bcb735c] Distribution Route.LT_TYPE (L/T Type*): [신규행()] AS-IS 0건 vs TO-BE 3건 · 차이 3건 설명 불가: AVERAGE: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); MIN: 설명 불가(공통 후보 없음 — 마스터 조건 해석을

### 집계 · 규칙 B5 · 3행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-0b6ea6d5 [GENERAL] [DMF0003 결함 유형] FCST Type 콤보 · Measure 입력 가능 | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-5bcb735c] Distribution Route.LT_TYPE (L/T Type*): [신규행()] AS-IS 0건 vs TO-BE 3건 · 차이 3건 설명 불가: AVERAGE: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); MIN: 설명 불가(공통 후보 없음 — 마스터 조건 해석을
- V-62a8d96c [GENERAL] [DMF0082 결함 유형] FCST Type 후보 | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-5bcb735c] Distribution Route.LT_TYPE (L/T Type*): [신규행()] AS-IS 0건 vs TO-BE 3건 · 차이 3건 설명 불가: AVERAGE: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); MIN: 설명 불가(공통 후보 없음 — 마스터 조건 해석을
- V-88ebd80c [GENERAL] [DMF0003 결함 유형] FCST Type 후보 | 규칙 B5 판정 2행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [V-5bcb735c] Distribution Route.LT_TYPE (L/T Type*): [신규행()] AS-IS 0건 vs TO-BE 3건 · 차이 3건 설명 불가: AVERAGE: 설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음); MIN: 설명 불가(공통 후보 없음 — 마스터 조건 해석을

### 집계 · 규칙 C1 · 2행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-4356fd55 [GENERAL] [DMF0044 결함 유형] 조회조건 Report Type→Data Type | 규칙 C1 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-1f03b82a] SCP0005 시나리오 [자동] LT_TYPE 셀 콤보 후보 = 서버 콤보 LookupCommon: [측정 경로 없음] [자동] LT_TYPE 셀 콤보 후보 = 서버 콤보 LookupCommon: 서버 콤보 LookupCommon 응답 없음(수집 24건) · 저장 요청 0 · 편집기 null · s
- V-9c3917c7 [GENERAL] [DMF0035 결함 유형] 조회조건 전체(숫자·ITEM TYPE 포함) | 규칙 C1 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [V-1f03b82a] SCP0005 시나리오 [자동] LT_TYPE 셀 콤보 후보 = 서버 콤보 LookupCommon: [측정 경로 없음] [자동] LT_TYPE 셀 콤보 후보 = 서버 콤보 LookupCommon: 서버 콤보 LookupCommon 응답 없음(수집 24건) · 저장 요청 0 · 편집기 null · s

### 집계 · 규칙 C2 · 8행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-9bd59181 [TRACE] R10 TRK→港/Forwarder 7 '-' · `portsDash()` cellEditEnded | 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 C2 25요소: ERROR:22 · NA:3
- T-b24c88f4 [TRACE] SCP0005_DistributionRoute.spdMainDataModel_Changed | 진입점 집계 — 대조표 SCP0005_DistributionRoute.spdMainDataModel_Changed 의 C2 23요소: ERROR:20 · NA:3
- V-3ff1c08d [GENERAL] [DMF0005 결함 유형] Cust Group-End Customer-Sales Site 관계 · Active 컬럼 | 규칙 C2 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [T-6feb4248] LT_LAY_OFF_CLEARANCE / Lay Off/Customs Clearance: LT_LAY_OFF_CLEARANCE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)
- 외 5행(unverified_triage.csv)

### 집계 · 규칙 C3 · 4행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-2fa6936f [TRACE] SCP0005_DistributionRoute.SetImageCell | 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetImageCell 의 C3 5요소: ERROR:5
- T-cede2a75 [TRACE] R10 TRK→港/Forwarder 7 '-' · `portsDash()` cellEditEnded | 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 C3 52요소: PASS:29 · ERROR:21 · NA:2
- T-d3c2b6de [TRACE] SCP0005_DistributionRoute.SetCityCode | 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetCityCode 의 C3 6요소: ERROR:6
- 외 1행(unverified_triage.csv)

### 집계 · 규칙 C6 · 1행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-504f1b9e [TRACE] R10 TRK→港/Forwarder 7 '-' · `portsDash()` cellEditEnded | 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 C6 46요소: PASS:29 · ERROR:15 · NA:2

### 집계 · 규칙 D1 · 4행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-67afeda8 [TRACE] R16/R17 클라 검증 색칠 · `validateRows`(전 편집행 누적, iter-2 G4) → `invalidCells` state →  | 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 D1 8요소: ERROR:5 · NA:2 · PASS:1
- T-78140e1b [TRACE] EditButton (SwitchLock 편집모드) · NSCM 상시편집 표준으로 대체(Edit 토글 없음) — 셀별 editLock 판정 | 행 집계 — 대조표 EditButton (SwitchLock 편집모드) 'NSCM 상시편집 표준으로 대체(Edit 토글 없음) — 셀별 editLock 판정' 의 D1 8요소: ERROR:5 · NA:2 · PASS:1
- T-f8485dfc [TRACE] SCP0005_DistributionRoute.EditButton | 진입점 집계 — 대조표 SCP0005_DistributionRoute.EditButton 의 D1 6요소: ERROR:5 · PASS:1
- 외 1행(unverified_triage.csv)

### 집계 · 규칙 DB-SYN · 1행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-42c71c59 [TRACE] FindDataMain 파라미터 6종 'ALL'→'' · store `setFilter()` `orEmpty()` | 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 DB-SYN 5요소: ERROR:3 · PASS:2

### 집계 · 규칙 F1 · 7행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-237e2ed0 [GENERAL] [SYS0017 결함 유형] 신규 행 Insert 후 Save | 규칙 F1 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [ES-836708a8] SCP0005 E2E authcrud 저장 왕복(insert) jooyong026: [측정 전제 미충족: 실행 예외] 저장 기능 판정 못 함 · mode=insert save=Y insert=Y delete=Y editable=- inserted=Y saved=N found=N updated=N 
- V-63bace30 [GENERAL] [SCM0007 결함 유형] 신규 행 Insert 후 Save | 규칙 F1 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [ES-836708a8] SCP0005 E2E authcrud 저장 왕복(insert) jooyong026: [측정 전제 미충족: 실행 예외] 저장 기능 판정 못 함 · mode=insert save=Y insert=Y delete=Y editable=- inserted=Y saved=N found=N updated=N 
- V-71a6b86d [GENERAL] [SYS0004 결함 유형] Insert 저장 / Delete CRUD Status | 규칙 F1 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [ES-836708a8] SCP0005 E2E authcrud 저장 왕복(insert) jooyong026: [측정 전제 미충족: 실행 예외] 저장 기능 판정 못 함 · mode=insert save=Y insert=Y delete=Y editable=- inserted=Y saved=N found=N updated=N 
- 외 4행(unverified_triage.csv)

### 집계 · 규칙 F4 · 1행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-78600da2 [TRACE] FindDataMain 파라미터 6종 'ALL'→'' · store `setFilter()` `orEmpty()` | 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 F4 5요소: ERROR:3 · PASS:1 · NA:1

### 집계 · 규칙 G1 · 6행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-03607842 [TRACE] COMMON:UC-07 · 필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns) | 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 G1 8요소: NA:4 · PASS:3 · ERROR:1
- T-47228590 [TRACE] btnEaxel_Upload → ExcelUploadForm2 · customButton 'Excel Upload' → `ExcelUploadM | 행 집계 — 대조표 btnEaxel_Upload → ExcelUploadForm2 "customButton 'Excel Upload' → `ExcelUploadModal` →" 의 G1 8요소: NA:4 · PASS:3 · ERROR:1
- T-5b2e156a [TRACE] FindButton(Search) · `hotkeyConfig.search`=handleSearch (hasButton) | 행 집계 — 대조표 FindButton(Search) '`hotkeyConfig.search`=handleSearch (hasButton)' 의 G1 8요소: NA:4 · PASS:3 · ERROR:1
- 외 3행(unverified_triage.csv)

### 집계 · 규칙 G4 · 2행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-b2386d37 [TRACE] cascade(clbFromCountry→City) · 없음(주석 폐기) — 무cascade | 행 집계 — 대조표 cascade(clbFromCountry→City) '없음(주석 폐기) — 무cascade' 의 G4 9요소: ERROR:7 · PASS:2
- T-db2429ef [TRACE] FindDataMain 파라미터 6종 'ALL'→'' · store `setFilter()` `orEmpty()` | 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 G4 9요소: ERROR:7 · PASS:2

### 집계 · 규칙 G5 · 5행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-27795148 [TRACE] R11/R12 FROM/TO 셀 더블클릭→도시팝업 · `onFromCellDblClick`/`onToCellDblClick`→`RegionMod | 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 G5 22요소: ERROR:14 · NA:8
- T-e499d5e0 [TRACE] ProgressForm · react-query isFetching(별도 팝업 불요) | 행 집계 — 대조표 ProgressForm 'react-query isFetching(별도 팝업 불요)' 의 G5 22요소: ERROR:14 · NA:8
- V-326d9325 [GENERAL] [SCP0007 결함 유형] Route 검색 팝업 결과 | 규칙 G5 판정 19행 중 FAIL 0 · 판정필요 0 · 미검증 10 — 연결 판정 반영 후 재계산(원 판정 FAIL) — [V-2e28bbf0] popCity.Form_Load(true, sCountry, sCity): ERROR | [미검증] 검사기(popup_args_check.py · _verify.spec(@verify))가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 
- 외 2행(unverified_triage.csv)

### 집계 · 규칙 H2 · 10행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-1169e814 [TRACE] SCP0005_DistributionRoute.SetImageCell | 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetImageCell 의 H2 5요소: ERROR:3 · PASS:2
- T-117a91ca [TRACE] DB메타 구동(gridColumns=[]) · `staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Distri | 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 H2 31요소: ERROR:19 · PASS:11 · NA:1
- T-1254494a [TRACE] R7 조회 databind · `useTabProcQuery` o_rc1 | 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 H2 31요소: ERROR:19 · PASS:11 · NA:1
- 외 7행(unverified_triage.csv)

### 집계 · 규칙 H5 · 8행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-02e57ce2 [TRACE] R10 TRK→港/Forwarder 7 '-' · `portsDash()` cellEditEnded | 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 H5 16요소: PASS:15 · ERROR:1
- T-040a12ca [TRACE] COMMON:UC-07 · 필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns) | 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 H5 16요소: PASS:15 · ERROR:1
- T-1bdf35aa [TRACE] R18 Insert/Delete · `GridAction.addRow` / `removeRow(grid, true)`(신규만) | 행 집계 — 대조표 R18 Insert/Delete '`GridAction.addRow` / `removeRow(grid, true)`(신규만)' 의 H5 16요소: PASS:15 · ERROR:1
- 외 5행(unverified_triage.csv)

### 집계 · 규칙 H6 · 6행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-e999c1bd [TRACE] ProgressForm · react-query isFetching(별도 팝업 불요) | 행 집계 — 대조표 ProgressForm 'react-query isFetching(별도 팝업 불요)' 의 H6 22요소: ERROR:16 · PASS:6
- T-ffd8cc98 [TRACE] R11/R12 FROM/TO 셀 더블클릭→도시팝업 · `onFromCellDblClick`/`onToCellDblClick`→`RegionMod | 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 H6 22요소: ERROR:16 · PASS:6
- V-9b7f9fbb [CONFIRMED] From City 검색 버튼 | 규칙 H6 판정 30행 중 FAIL 0 · 판정필요 0 · 미검증 8 — [V-718e1a16] popCity.Form_Load(true, sCountry, sCity): | [미검증] 검사기(_verify.spec(@verify)·smoke popup)가 이 대상을 실행하지 못함 — 검증 엔진 확장 대상(작업 원장 W7) | [미검증] 검사기(_verify.spec(@verify)·smok
- 외 3행(unverified_triage.csv)

### 집계 · 규칙 J1 · 7행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-68745a57 [DEFECT] 사용자 Division 권한 콤보 쿼리(DIVISION_ID · 권한 USE_YN) 필터 | 규칙 J1 판정 11행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [ES-0967e6d0] SCP0005 E2E auth Division 40 조회 · 계정 40:ADMIN,81:ADMIN,82:ADMIN: [측정 전제 미충족] Division 40 선택 못 함 · 40 set=false rows=8036 alert= | [ES-fe8e48bc] SCP0005 E2E auth Divi
- V-834a93e7 [CONFIRMED] Division 조회조건 후보 | 규칙 J1 판정 11행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [ES-0967e6d0] SCP0005 E2E auth Division 40 조회 · 계정 40:ADMIN,81:ADMIN,82:ADMIN: [측정 전제 미충족] Division 40 선택 못 함 · 40 set=false rows=8036 alert= | [ES-fe8e48bc] SCP0005 E2E auth Divi
- V-86d10682 [GENERAL] [DMF0074 결함 일반화] 조회조건 Division 콤보(DIVISION_ID) 권한 자동 선택 · Period(PERIOD) 입력란 크기 | 규칙 J1 판정 11행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [ES-0967e6d0] SCP0005 E2E auth Division 40 조회 · 계정 40:ADMIN,81:ADMIN,82:ADMIN: [측정 전제 미충족] Division 40 선택 못 함 · 40 set=false rows=8036 alert= | [ES-fe8e48bc] SCP0005 E2E auth Divi
- 외 4행(unverified_triage.csv)

### 집계 · 규칙 M3 · 1행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-b36ee21b [GENERAL] [DMF0082 결함 유형] Excel Form 팝업 Search | 규칙 M3 판정 1행 중 FAIL 0 · 판정필요 0 · 미검증 1 — [EG-6a0f18bc] SCP0005 팝업 ExcelUploadForm2 BTN:Upload OPEN: 기대 AS-IS btnEaxel_Upload_Click 팝업(ExcelUploadForm2) 열림 · 실제 BTN: 버튼 [Upload/Upload/Eaxel_Upload] 비노출 — 화면 버튼 [KOR, 이 이민용,

### 집계 · 규칙 M4 · 1행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-9343bbce [TRACE] SCP0005_DistributionRoute.spdMain_CellDoubleClick | 진입점 집계 — 대조표 SCP0005_DistributionRoute.spdMain_CellDoubleClick 의 M4 8요소: PASS:5 · NA:2 · ERROR:1

### 집계 · 규칙 X-ROW · 21행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-004bd1d4 [TRACE] SCP0005_DistributionRoutePopup.CreateSpread | 진입점 집계 1검사 — ERROR:1
- T-09365c5b [TRACE] SCP0005_DistributionRoutePopup.FindData | 진입점 집계 6검사 — ERROR:4 · REVIEW:1 · PASS:1
- T-0aa76ea9 [TRACE] SCP0005_DistributionRoute.InitSpread | 진입점 집계 29검사 — PASS:28 · ERROR:1
- 외 18행(unverified_triage.csv)

