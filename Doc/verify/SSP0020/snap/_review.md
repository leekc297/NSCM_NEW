# 스냅샷 검토 SSP0020 — 2026-11-16 17:41

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | MATCH | Doc\verify\SSP0020\snap\golden\조회조건_Div_40.aria.yml | Doc\verify\SSP0020\snap\received\조회조건_Div_40.aria.yml |  | 골든 Doc\verify\SSP0020\snap\golden\조회조건_Div_40.aria.yml 와 일치 · 조회영역 aria(17줄 · formItem 공통 조상) · 시각 순서 3칸 |
| 버튼_Div_40 | 버튼 | Div 40 | MATCH | Doc\verify\SSP0020\snap\golden\버튼_Div_40.aria.yml | Doc\verify\SSP0020\snap\received\버튼_Div_40.aria.yml |  | 골든 Doc\verify\SSP0020\snap\golden\버튼_Div_40.aria.yml 와 일치 · 버튼 바 aria(10줄) · 보이는 버튼 KOR,이 이민용,Home,Delegate,Scroll tabs left,Scroll tabs right,Close others,Clos |
| 헤더_Delegate | 헤더 | Delegate | NEW |  | Doc\verify\SSP0020\snap\received\헤더_Delegate.txt |  | 골든 없음 — 수신본 Doc\verify\SSP0020\snap\received\헤더_Delegate.txt 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 헤더 1행 · 칸 7 |
| 팝업_Delegatee | 팝업 | Delegatee | MATCH | Doc\verify\SSP0020\snap\golden\팝업_Delegatee.aria.yml | Doc\verify\SSP0020\snap\received\팝업_Delegatee.aria.yml |  | 골든 Doc\verify\SSP0020\snap\golden\팝업_Delegatee.aria.yml 와 일치 · 팝업 aria(225줄) |
| 화면샷_1920 | 화면샷 | 1920 | MATCH | Doc\verify\SSP0020\snap\golden\화면샷_1920.png |  |  | 골든 화면샷과 일치(maxDiffPixelRatio 0.002) |
| 화면샷_1366 | 화면샷 | 1366 | MATCH | Doc\verify\SSP0020\snap\golden\화면샷_1366.png |  |  | 골든 화면샷과 일치(maxDiffPixelRatio 0.002) |
| 헤더_Delegated_List | 헤더 | Delegated List | NEW |  | Doc\verify\SSP0020\snap\received\헤더_Delegated_List.txt |  | 골든 없음 — 수신본 Doc\verify\SSP0020\snap\received\헤더_Delegated_List.txt 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 헤더 1행 · 칸 7 |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
