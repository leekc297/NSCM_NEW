import sys
p = sys.argv[1]
s = open(p, encoding='utf-8').read()
R = [
 ("| D00-1-008 | §1 spdMain / FpSpread | Grid:360-367 ", "| D00-1-008 | §1 spdMain / FpSpread | Grid:376-386 "),
 ("| D00-1-009 | §1 spdMain_Sheet1 / SheetView | Grid:360-367 ", "| D00-1-009 | §1 spdMain_Sheet1 / SheetView | Grid:376-386 "),
 ("Grid:69,286-333 (다단 헤더 총높이 rAF", "Grid:87-88,301-349 (다단 헤더 총높이 48px rAF"),
 ("| Grid:138-185 (3단 머지헤더 group 구성 — 제목/헤더 시트 병합을 wijmo columnGroups 로 재현) |", "| Grid:154-222 (3단 머지헤더 group 구성 — 3SPAN 서버 라벨 LARGE/SMALL/COLUMN_LABEL 로 wijmo columnGroups 재현) ← Page:133-148 (calendar 시트 조회) |"),
 ("| Grid:234-237 (formatItem ColumnHeader 토=#1e56c8/일=#c0392b, weekdayByBinding) |", "| Grid:231-232,247-254 (formatItem ColumnHeader leaf 행 — 3SPAN DAY_CODE SAT=WEEKEND_HEADER_COLOR.SAT/SUN=…SUN, dayCodeByBinding · Const:82-85) | 2026-10-20 3차: dayjs 요일 → 서버 DAY_CODE(.cs:192,206) |"),
 ("| D00-3-004 | §3 ColumnHeaderSpan / 212 | Grid:177-185 (dayGroups 월→주차→일 3단 span) |", "| D00-3-004 | §3 ColumnHeaderSpan / 212 | Grid:181-202 (dayGroups 월→주차→일 3단 span, 라벨 변경 시 마감 = 연속 run) |"),
 ("| D00-3-005 | §3 ColumnHeaderSpan / 213 | Grid:177-185 (월 대헤더 span) |", "| D00-3-005 | §3 ColumnHeaderSpan / 213 | Grid:181-185,194-196 (월 대헤더 span = LARGE_CLASS_LABEL_NAME) |"),
 ("| D00-3-006 | §3 ColumnHeaderSpan / 218 | Grid:180-184 (주차 소헤더 span) |", "| D00-3-006 | §3 ColumnHeaderSpan / 218 | Grid:186-191,197-201 (주차 소헤더 span = SMALL_CLASS_LABEL_NAME, 월 경계에서 강제 마감) |"),
 ("| D00-3-007 | §3 ColumnHeaderSpan / 219 | Grid:180-184 (주차 소헤더 span) |", "| D00-3-007 | §3 ColumnHeaderSpan / 219 | Grid:186-191,197-201 (주차 소헤더 span) |"),
 ("| D00-3-008 | §3 ColumnHeaderSpan / 227 | Grid:188-202 (SUM 열 헤더 — W_/M_ sumGroups) |", "| D00-3-008 | §3 ColumnHeaderSpan / 227 | Grid:149,206-219 (SUM 열 헤더 — 3SPAN W_/M_ sumGroups, 숨김) |"),
 ("| D00-3-009 | §3 ColumnHeaderSpan / 228 | Grid:188-202 (SUM 열 헤더 span) |", "| D00-3-009 | §3 ColumnHeaderSpan / 228 | Grid:206-219 (SUM 열 헤더 span) |"),
 ("| D00-3-010 | §3 ColumnHeaderSpan / 238 | Grid:138-185 (일 pivot 헤더 span 분기) |", "| D00-3-010 | §3 ColumnHeaderSpan / 238 | Grid:154-202 (일 pivot 헤더 span 분기) |"),
 ("| D00-3-011 | §3 ColumnHeaderSpan / 239 | Grid:138-185 (주 pivot 헤더 span 분기) |", "| D00-3-011 | §3 ColumnHeaderSpan / 239 | Grid:154-202 (주 pivot 헤더 span 분기) |"),
 ("| D00-3-012 | §3 ColumnHeaderSpan / 240 | Grid:138-185 (월 pivot 헤더 span 분기) |", "| D00-3-012 | §3 ColumnHeaderSpan / 240 | Grid:154-202 (월 pivot 헤더 span 분기) |"),
 ("| Grid:286-333 (3단 헤더 총높이 60px 불변식 정규화) |  |", "| Grid:301-349 (3단 헤더 총높이 48px 불변식 정규화 — Const:99 HEADER_TOTAL_HEIGHT) | 2026-10-20 3차: 60px(AS-IS 20×3) → 48px(hook #93 · 10_RULES_KEEP D3, 자매 SCP0095 동일) |"),
 ("| Grid:119 (fixed=c.fixed admin 위임)", "| Grid:109 (fixed=c.fixed admin 위임)"),
 ("| Grid:168 (D_ leaf visible:true) | W_ 열은 GET SP 가 만들지 않음(AS-IS·Oracle 동일) — D_ 만 해당 |", "| Grid:173 (D_ leaf visible:true) | W_ 열은 AS-IS 도 같은 루프 뒤 :353-356 이 chkSum(false)로 다시 숨김 — 결과적으로 D_ 만 표시(D00-3-019) |"),
 ("| Grid:210 (sumGroups visible: showSum — 항상 false) |", "| Grid:216 (sumGroups visible: showSum — 항상 false) |"),
 ("| Page:117-123,181-188 (useTabProcQuery GET SP + handleSearch invalidateQueries) |  |", "| Page:115-121,199-206 (useTabProcQuery GET SP + handleSearch invalidateQueries) + Store:129-156 (setFilters 가 calendarFilters 도 조회기간 스냅샷으로 갱신 = FindData_Main → InitSpread → GetSpdTitle .cs:438) |  |"),
 ("| Grid:297-345 (조회 후 updatedLayout", "| Grid:301-349 (조회 후 updatedLayout"),
 ("| Hook:116-117 (dayCol.weekday===targetWeekday 매칭 셀만 writeCell) |  |", "| Hook:78-80,117 (dayCol.dayCode === dayWeekCode.toUpperCase() 매칭 셀만 writeCell = AS-IS GetDayOfWeek DAY_CODE 비교 .cs:796-798,811-818) | 2026-10-20 3차: dayjs 요일 인덱스(WEEKDAY_CODE_TO_INDEX) → 3SPAN DAY_CODE |"),
 ("+ Grid:161 D_ 셀 dataMap DAY_CELL_DATA_MAP(Y/N) |", "+ Grid:178 D_ 셀 dataMap DAY_CELL_DATA_MAP(Y/N) |"),
 ("| Grid:161 (D_ 셀 dataMap DAY_CELL_DATA_MAP)", "| Grid:178 (D_ 셀 dataMap DAY_CELL_DATA_MAP)"),
 ("| Grid:347-369 (FlexGridFilter", "| Grid:351-373 (FlexGridFilter"),
 ("| Hook:46-128 (useShipmentWorkingDayOspInputValue", "| Hook:46-129 (useShipmentWorkingDayOspInputValue"),
 ("← Page:335-343 배선 |", "← Page:353-361 배선 |"),
]
for a,b in R:
    n = s.count(a)
    if n != 1:
        print('MISS', n, a[:80]); continue
    s = s.replace(a,b)
# D00-4-005 row
import re
lines = s.split('\n')
for i,l in enumerate(lines):
    if l.startswith('| D00-4-005 |'):
        lines[i] = ("| D00-4-005 | §4 SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN / SCP0009_GET_SHEET_CALENDAR_3SPAN (GetSpdTitle .cs:825-838 — 3단 헤더 타이틀) "
            "| Const:17-22 SHEETS.CALENDAR='calendar' · Const:40 RESPONSE_SET.CALENDAR='o_rc1' + Page:133-148 (useTabProcQuery calendar · calendarRows) + Store:32,147-150,157-171 (calendarFilters startYyyymmdd/endYyyymmdd = PROC_M COL_NM · 조회 스냅샷 · 초기 1회 sync) + Page:161-168 (조회 전 초기 1회) → 사내 배선 SCP0096/calendar/SEARCH → SCP0009_SHEET_CALENDAR_3SPAN_GET → PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN "
            "| 2026-10-20 3차 보완(M09 정정): 이전 '데이터 커서 alias + o_rc1_columns 로 1회 호출에 흡수' 는 BE 원문(BaseService.java:84/128/164 = OUT COL_NM 만 응답, o_rc1_columns 는 DynamicQueryServiceImpl.java:46,73 SYS0013 전용)과 달라 기간 컬럼 0 이었다 — 배선 시트를 실제 조회하도록 구현. 사내 ZIOUI1 실측(20261020~20261108 → 26행 D_19·W_5·M_2) "
            "| 구현 |")
s = '\n'.join(lines)
open(p,'w',encoding='utf-8', newline='\n').write(s)
print('ok')
