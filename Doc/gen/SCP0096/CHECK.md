# [Harness] SCP0096 shipment-working-day-osp — BLOCK 3 / WARN 2 (final)

- BLOCK B26 RESPONSE_SET 응답 키 = 사내 PROC_M OUT COL_NM(proc_params.csv) — DYN_COLUMNS='o_rc1_columns' → 사내 PROC_M OUT 어디에도 없음(ResultSetMetaData 사이드카 = SYS0013 DynamicQuery 전용, 일반 call-proc 응답에 없음) — 이 키로 읽는 값은 항상 undefined(빈 그리드·빈 팝업으로 보이고 오류는 안 남). 동적 헤더 원천은 사내 배선 타이틀 SP 시트(B27) 또는 Object.keys(rows[0])(mybatis callSettersOnNulls=true)
- BLOCK B27 동적 헤더 원천 SCP0009_GET_SHEET_CALENDAR_3SPAN → FE 조회 — As-is GetSpdTitle → SCP0009_GET_SHEET_CALENDAR_3SPAN [sp명+메서드 + grid_code DB루프 InitSpreadDateColumn:196,InitSpreadDateColumn:203] · 사내 배선 시트 'calendar'(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN)를 FE 가 조회하지 않음 → 기간 컬럼이 그려지지 않음. SHEETS 에 시트 추가 + useTabProcQuery 로 조회기간을 넘겨 o_rc1(COLUMN_NAME·COLUMN_LABEL_NAME·SMALL/LARGE_CLASS_LABEL_NAME·DAY_CODE)로 헤더 생성(As-is InitSpreadDateColumn 1:1)
- WARN M08 대사표에 As-is DB루프 컬럼 생성 행 없음: InitSpreadDateColumn:196, InitSpreadDateColumn:203 — '## §6 동적 컬럼' 에 행 추가(요지 'InitSpreadDateColumn / 196 (DB루프 컬럼 생성 ← 타이틀 SP)', 구현 위치 = 동적 컬럼 생성 코드 + 타이틀 시트 조회 위치) @__asis-mapping__.md
- BLOCK M09 구현 근거 불일치: D00-4-005 'SCP0009_GET_SHEET_CALENDAR_3SPAN' 가 '구현' 인데 사내 배선 시트 'calendar'(SEARCH)를 FE 가 조회하지 않음 — 구현 위치/사유의 대체 설명을 BE·메타 원문으로 검증하고, 아니면 배선 시트를 조회하도록 구현 @__asis-mapping__.md
- WARN T02 tsc 가 다른 파일에서 오류를 보고(페이지 범위 밖) — exit 134
