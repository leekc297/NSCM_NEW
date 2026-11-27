# 스냅샷 검토 DMF0042 — 2026-11-26 09:33

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | NEW |  | Doc\verify\DMF0042\snap\received\조회조건_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\DMF0042\snap\received\조회조건_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 조회영역 aria(49줄 · formItem 공통 조상) ·  |
| 버튼_Div_40 | 버튼 | Div 40 | NEW |  | Doc\verify\DMF0042\snap\received\버튼_Div_40.aria.yml |  | 골든 없음 — 수신본 Doc\verify\DMF0042\snap\received\버튼_Div_40.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 버튼 바 aria(18줄) · 보이는 버튼 KOR,이 이민용,Ho |
| 헤더_Biz_Plan | 헤더 | Biz Plan | NEW |  | Doc\verify\DMF0042\snap\received\헤더_Biz_Plan.txt |  | 골든 없음 — 수신본 Doc\verify\DMF0042\snap\received\헤더_Biz_Plan.txt 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 헤더 3행 · 칸 21 |
| 팝업_PJT | 팝업 | PJT | ERROR |  |  |  | 팝업 열기/aria 실패 TimeoutError: locator.click: Timeout 5000ms exceeded.
Call log:
  - waiting for locator('[data-e2e-cond="snap1"]').f |
| 팝업_Model_Nickname | 팝업 | Model/Nickname | NEW |  | Doc\verify\DMF0042\snap\received\팝업_Model_Nickname.aria.yml |  | 골든 없음 — 수신본 Doc\verify\DMF0042\snap\received\팝업_Model_Nickname.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 팝업 aria(43줄) |
| 팝업_Owner | 팝업 | Owner | NEW |  | Doc\verify\DMF0042\snap\received\팝업_Owner.aria.yml |  | 골든 없음 — 수신본 Doc\verify\DMF0042\snap\received\팝업_Owner.aria.yml 를 snap_validate.py 로 AS-IS 기대와 대조한 뒤 snap_approve.py 로 승인 · 팝업 aria(66줄) |
| 화면샷_1920 | 화면샷 | 1920 | NEW | Doc\verify\DMF0042\snap\golden\화면샷_1920.png |  |  | 골든 없음 — 첫 캡처가 골든 후보로 저장됨(승인 전에는 판정필요) |
| 화면샷_1366 | 화면샷 | 1366 | NEW | Doc\verify\DMF0042\snap\golden\화면샷_1366.png |  |  | 골든 없음 — 첫 캡처가 골든 후보로 저장됨(승인 전에는 판정필요) |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
