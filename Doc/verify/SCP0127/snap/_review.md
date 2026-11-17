# 스냅샷 검토 SCP0127 — 2026-11-14 09:08

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | NEW |  | Doc\verify\SCP0127\snap\received\조회조건_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SCP0127\snap\received\조회조건_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 조회영역 aria(31줄 · formItem 공통 조상) ·  |
| 버튼_Div_40 | 버튼 | Div 40 | MATCH | Doc\verify\SCP0127\snap\golden\버튼_Div_40.aria.yml | Doc\verify\SCP0127\snap\received\버튼_Div_40.aria.yml |  | 골든 Doc\verify\SCP0127\snap\golden\버튼_Div_40.aria.yml 와 일치 · 버튼 바 aria(11줄) · 보이는 버튼 KOR,이 이민용,Home,Precede/Safety Stock Day,Scroll tabs left,Scroll tabs right,C |
| 헤더_PRECEDE_SAFETY_STOCK_DAY | 헤더 | PRECEDE / SAFETY STOCK DAY | MATCH | Doc\verify\SCP0127\snap\golden\헤더_PRECEDE_SAFETY_STOCK_DAY.txt | Doc\verify\SCP0127\snap\received\헤더_PRECEDE_SAFETY_STOCK_DAY.txt |  | 골든 Doc\verify\SCP0127\snap\golden\헤더_PRECEDE_SAFETY_STOCK_DAY.txt 와 일치 · 헤더 1행 · 칸 15 |
| 팝업_Model_Nickname | 팝업 | Model/Nickname | MATCH | Doc\verify\SCP0127\snap\golden\팝업_Model_Nickname.aria.yml | Doc\verify\SCP0127\snap\received\팝업_Model_Nickname.aria.yml |  | 골든 Doc\verify\SCP0127\snap\golden\팝업_Model_Nickname.aria.yml 와 일치 · 팝업 aria(226줄) |
| 화면샷_1920 | 화면샷 | 1920 | DIFF | Doc\verify\SCP0127\snap\golden\화면샷_1920.png | C:\Projects\NSCM\Doc\verify\SCP0127\e2e\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | C:\Projects\NSCM\Doc\verify\SCP0127\e2e\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | 화면샷 차이 — Error: [2mexpect([22m[31mpage[39m[2m).[22mtoHaveScreenshot[2m([22m[32mexpected[39m[2m)[22m failed 6358 pixels (ratio 0.02 of all image pixe |
| 화면샷_1366 | 화면샷 | 1366 | DIFF | Doc\verify\SCP0127\snap\golden\화면샷_1366.png | C:\Projects\NSCM\Doc\verify\SCP0127\e2e\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | C:\Projects\NSCM\Doc\verify\SCP0127\e2e\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | 화면샷 차이 — Error: [2mexpect([22m[31mpage[39m[2m).[22mtoHaveScreenshot[2m([22m[32mexpected[39m[2m)[22m failed 6358 pixels (ratio 0.02 of all image pixe |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
