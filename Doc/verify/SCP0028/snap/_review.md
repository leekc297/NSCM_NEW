# 스냅샷 검토 SCP0028 — 2026-11-24 17:59

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | MATCH | Doc\verify\SCP0028\snap\golden\조회조건_Div_40.aria.yml | Doc\verify\SCP0028\snap\received\조회조건_Div_40.aria.yml |  | 골든 Doc\verify\SCP0028\snap\golden\조회조건_Div_40.aria.yml 와 일치 · 조회영역 aria(24줄 · formItem 공통 조상) · 시각 순서 7칸 |
| 버튼_Div_40 | 버튼 | Div 40 | MATCH | Doc\verify\SCP0028\snap\golden\버튼_Div_40.aria.yml | Doc\verify\SCP0028\snap\received\버튼_Div_40.aria.yml |  | 골든 Doc\verify\SCP0028\snap\golden\버튼_Div_40.aria.yml 와 일치 · 버튼 바 aria(13줄) · 보이는 버튼 KOR,최 최상민,Home,SSP Lot Size,Scroll tabs left,Scroll tabs right,Close others, |
| 헤더_Shipment_Lot_Size | 헤더 | Shipment Lot Size | MATCH | Doc\verify\SCP0028\snap\golden\헤더_Shipment_Lot_Size.txt | Doc\verify\SCP0028\snap\received\헤더_Shipment_Lot_Size.txt |  | 골든 Doc\verify\SCP0028\snap\golden\헤더_Shipment_Lot_Size.txt 와 일치 · 헤더 1행 · 칸 15 |
| 화면샷_1920 | 화면샷 | 1920 | DIFF | Doc\verify\SCP0028\snap\golden\화면샷_1920.png | C:\Projects\NSCM\Doc\verify\SCP0028\e2e\read13\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | C:\Projects\NSCM\Doc\verify\SCP0028\e2e\read13\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | 화면샷 차이 — Error: [2mexpect([22m[31mpage[39m[2m).[22mtoHaveScreenshot[2m([22m[32mexpected[39m[2m)[22m failed 12379 pixels (ratio 0.03 of all image pix |
| 화면샷_1366 | 화면샷 | 1366 | DIFF | Doc\verify\SCP0028\snap\golden\화면샷_1366.png | C:\Projects\NSCM\Doc\verify\SCP0028\e2e\read13\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | C:\Projects\NSCM\Doc\verify\SCP0028\e2e\read13\artifacts\_snap--snap-스냅샷-형상-검사-snap-화면샷-패널-헤더-띠-1920-1366-chromium | 화면샷 차이 — Error: [2mexpect([22m[31mpage[39m[2m).[22mtoHaveScreenshot[2m([22m[32mexpected[39m[2m)[22m failed 9445 pixels (ratio 0.03 of all image pixe |
| 팝업_Model | 팝업 | Model | DIFF | Doc\verify\SCP0028\snap\golden\팝업_Model.aria.yml | Doc\verify\SCP0028\snap\received\팝업_Model.aria.yml | Doc\verify\SCP0028\snap\diff\팝업_Model.txt | 골든 Doc\verify\SCP0028\snap\golden\팝업_Model.aria.yml 와 29줄 다름(Doc\verify\SCP0028\snap\diff\팝업_Model.txt) — 첫 차이: - [골든 22]           - checkbox "Deselect All Row |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
