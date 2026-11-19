# 스냅샷 검토 SCP0096 — 2026-11-19 00:28

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | DIFF | Doc\verify\SCP0096\snap\golden\조회조건_Div_40.aria.yml | Doc\verify\SCP0096\snap\received\조회조건_Div_40.aria.yml | Doc\verify\SCP0096\snap\diff\조회조건_Div_40.txt | 골든 Doc\verify\SCP0096\snap\golden\조회조건_Div_40.aria.yml 와 4줄 다름(Doc\verify\SCP0096\snap\diff\조회조건_Div_40.txt) — 첫 차이: - [골든 2] - text: Div. · 조회영역 aria(16줄 · for |
| 버튼_Div_40 | 버튼 | Div 40 | MATCH | Doc\verify\SCP0096\snap\golden\버튼_Div_40.aria.yml | Doc\verify\SCP0096\snap\received\버튼_Div_40.aria.yml |  | 골든 Doc\verify\SCP0096\snap\golden\버튼_Div_40.aria.yml 와 일치 · 버튼 바 aria(10줄) · 보이는 버튼 KOR,이 이민용,Home,Shipment Working Day(OSP),Scroll tabs left,Scroll tabs right, |
| 헤더_Shipment_Working_Day_OSP | 헤더 | Shipment Working Day OSP | MATCH | Doc\verify\SCP0096\snap\golden\헤더_Shipment_Working_Day_OSP.txt | Doc\verify\SCP0096\snap\received\헤더_Shipment_Working_Day_OSP.txt |  | 골든 Doc\verify\SCP0096\snap\golden\헤더_Shipment_Working_Day_OSP.txt 와 일치 · 헤더 3행 · 칸 368 |
| 화면샷_1920 | 화면샷 | 1920 | MATCH | Doc\verify\SCP0096\snap\golden\화면샷_1920.png |  |  | 골든 화면샷과 일치(maxDiffPixelRatio 0.002) |
| 화면샷_1366 | 화면샷 | 1366 | MATCH | Doc\verify\SCP0096\snap\golden\화면샷_1366.png |  |  | 골든 화면샷과 일치(maxDiffPixelRatio 0.002) |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
