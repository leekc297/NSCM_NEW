# 스냅샷 검토 SSP0023 — 2026-11-14 14:51

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | NEW |  | Doc\verify\SSP0023\snap\received\조회조건_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0023\snap\received\조회조건_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 조회영역 aria(161줄 · formItem 공통 조상) · |
| 버튼_Div_40 | 버튼 | Div 40 | NEW |  | Doc\verify\SSP0023\snap\received\버튼_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\SSP0023\snap\received\버튼_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 버튼 바 aria(16줄) · 보이는 버튼 KOR,이 이민용,Ho |
| 헤더_Shipment_Plan_Detail | 헤더 | Shipment Plan Detail | NEW |  | Doc\verify\SSP0023\snap\received\헤더_Shipment_Plan_Detail.txt |  | 골든 없음 — 수신본 Doc\verify\SSP0023\snap\received\헤더_Shipment_Plan_Detail.txt 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 헤더 3행 · 칸 66 |
| 헤더_Shipment_Plan_Detail_Excel | 헤더 | Shipment Plan Detail Excel | NEW |  | Doc\verify\SSP0023\snap\received\헤더_Shipment_Plan_Detail_Excel.txt |  | 골든 없음 — 수신본 Doc\verify\SSP0023\snap\received\헤더_Shipment_Plan_Detail_Excel.txt 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 헤더 1행 · 칸 40 |
| 화면샷_1920 | 화면샷 | 1920 | NEW | Doc\verify\SSP0023\snap\golden\화면샷_1920.png | C:\Projects\NSCM\Doc\verify\SSP0023\e2e\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | C:\Projects\NSCM\Doc\verify\SSP0023\e2e\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 차이 — Error: [2mexpect([22m[31mpage[39m[2m).[22mtoHaveScreenshot[2m([22m[32mexpected[39m[2m)[22m failed 553678 pixels |
| 화면샷_1366 | 화면샷 | 1366 | NEW | Doc\verify\SSP0023\snap\golden\화면샷_1366.png | C:\Projects\NSCM\Doc\verify\SSP0023\e2e\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | C:\Projects\NSCM\Doc\verify\SSP0023\e2e\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | 골든 없음(승인 전) — 자동 생성 골든 후보 png 와 차이 — Error: [2mexpect([22m[31mpage[39m[2m).[22mtoHaveScreenshot[2m([22m[32mexpected[39m[2m)[22m failed 370155 pixels |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
