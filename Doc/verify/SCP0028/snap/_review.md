# 스냅샷 검토 SCP0028 — 2026-11-20 01:02

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | MATCH | Doc\verify\SCP0028\snap\golden\조회조건_Div_40.aria.yml | Doc\verify\SCP0028\snap\received\조회조건_Div_40.aria.yml |  | 골든 Doc\verify\SCP0028\snap\golden\조회조건_Div_40.aria.yml 와 일치 · 조회영역 aria(24줄 · formItem 공통 조상) · 시각 순서 7칸 |
| 버튼_Div_40 | 버튼 | Div 40 | MATCH | Doc\verify\SCP0028\snap\golden\버튼_Div_40.aria.yml | Doc\verify\SCP0028\snap\received\버튼_Div_40.aria.yml |  | 골든 Doc\verify\SCP0028\snap\golden\버튼_Div_40.aria.yml 와 일치 · 버튼 바 aria(13줄) · 보이는 버튼 KOR,이 이민용,Home,SSP Lot Size,Scroll tabs left,Scroll tabs right,Close others, |
| 헤더_Shipment_Lot_Size | 헤더 | Shipment Lot Size | MATCH | Doc\verify\SCP0028\snap\golden\헤더_Shipment_Lot_Size.txt | Doc\verify\SCP0028\snap\received\헤더_Shipment_Lot_Size.txt |  | 골든 Doc\verify\SCP0028\snap\golden\헤더_Shipment_Lot_Size.txt 와 일치 · 헤더 1행 · 칸 15 |
| 화면샷_1920 | 화면샷 | 1920 | MATCH | Doc\verify\SCP0028\snap\golden\화면샷_1920.png |  |  | 골든 화면샷과 일치(maxDiffPixelRatio 0.002) |
| 화면샷_1366 | 화면샷 | 1366 | MATCH | Doc\verify\SCP0028\snap\golden\화면샷_1366.png |  |  | 골든 화면샷과 일치(maxDiffPixelRatio 0.002) |
| 팝업_Model | 팝업 | Model | MATCH | Doc\verify\SCP0028\snap\golden\팝업_Model.aria.yml | Doc\verify\SCP0028\snap\received\팝업_Model.aria.yml |  | 골든 Doc\verify\SCP0028\snap\golden\팝업_Model.aria.yml 와 일치 · 팝업 aria(60줄) |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
