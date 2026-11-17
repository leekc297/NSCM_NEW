# 스냅샷 검토 SCP0104 — 2026-11-17 04:58

| 키 | 종류 | 범위 | 상태 | 골든 | 수신 | 차이 | 설명 |
|---|---|---|---|---|---|---|---|
| 조회조건_Div_40 | 조회조건 | Div 40 | MATCH | Doc\verify\SCP0104\snap\golden\조회조건_Div_40.aria.yml | Doc\verify\SCP0104\snap\received\조회조건_Div_40.aria.yml |  | 골든 Doc\verify\SCP0104\snap\golden\조회조건_Div_40.aria.yml 와 일치 · 조회영역 aria(36줄 · formItem 공통 조상) · 시각 순서 6칸 |
| 버튼_Div_40 | 버튼 | Div 40 | MATCH | Doc\verify\SCP0104\snap\golden\버튼_Div_40.aria.yml | Doc\verify\SCP0104\snap\received\버튼_Div_40.aria.yml |  | 골든 Doc\verify\SCP0104\snap\golden\버튼_Div_40.aria.yml 와 일치 · 버튼 바 aria(13줄) · 보이는 버튼 KOR,이 이민용,Home,Line Assign,Scroll tabs left,Scroll tabs right,Close others,C |
| 헤더_ASSEMBLY | 헤더 | ASSEMBLY | MATCH | Doc\verify\SCP0104\snap\golden\헤더_ASSEMBLY.txt | Doc\verify\SCP0104\snap\received\헤더_ASSEMBLY.txt |  | 골든 Doc\verify\SCP0104\snap\golden\헤더_ASSEMBLY.txt 와 일치 · 헤더 2행 · 칸 45 |
| 화면샷_1920 | 화면샷 | 1920 | MATCH | Doc\verify\SCP0104\snap\golden\화면샷_1920.png |  |  | 골든 화면샷과 일치(maxDiffPixelRatio 0.002) |
| 화면샷_1366 | 화면샷 | 1366 | MATCH | Doc\verify\SCP0104\snap\golden\화면샷_1366.png |  |  | 골든 화면샷과 일치(maxDiffPixelRatio 0.002) |
| 헤더_ELTR | 헤더 | ELTR | MATCH | Doc\verify\SCP0104\snap\golden\헤더_ELTR.txt | Doc\verify\SCP0104\snap\received\헤더_ELTR.txt |  | 골든 Doc\verify\SCP0104\snap\golden\헤더_ELTR.txt 와 일치 · 헤더 2행 · 칸 46 |
| 헤더_LINE | 헤더 | LINE | MATCH | Doc\verify\SCP0104\snap\golden\헤더_LINE.txt | Doc\verify\SCP0104\snap\received\헤더_LINE.txt |  | 골든 Doc\verify\SCP0104\snap\golden\헤더_LINE.txt 와 일치 · 헤더 1행 · 칸 14 |
| 헤더_SOP_ASSEMBLY | 헤더 | SOP_ASSEMBLY | MATCH | Doc\verify\SCP0104\snap\golden\헤더_SOP_ASSEMBLY.txt | Doc\verify\SCP0104\snap\received\헤더_SOP_ASSEMBLY.txt |  | 골든 Doc\verify\SCP0104\snap\golden\헤더_SOP_ASSEMBLY.txt 와 일치 · 헤더 1행 · 칸 10 |
| 헤더_SOP_ELTR | 헤더 | SOP_ELTR | MATCH | Doc\verify\SCP0104\snap\golden\헤더_SOP_ELTR.txt | Doc\verify\SCP0104\snap\received\헤더_SOP_ELTR.txt |  | 골든 Doc\verify\SCP0104\snap\golden\헤더_SOP_ELTR.txt 와 일치 · 헤더 1행 · 칸 10 |
| 헤더_SOP_MODEL_ASSEMBLY | 헤더 | SOP_MODEL_ASSEMBLY | MATCH | Doc\verify\SCP0104\snap\golden\헤더_SOP_MODEL_ASSEMBLY.txt | Doc\verify\SCP0104\snap\received\헤더_SOP_MODEL_ASSEMBLY.txt |  | 골든 Doc\verify\SCP0104\snap\golden\헤더_SOP_MODEL_ASSEMBLY.txt 와 일치 · 헤더 1행 · 칸 10 |
| 헤더_SOP_MODEL_ELTR | 헤더 | SOP_MODEL_ELTR | MATCH | Doc\verify\SCP0104\snap\golden\헤더_SOP_MODEL_ELTR.txt | Doc\verify\SCP0104\snap\received\헤더_SOP_MODEL_ELTR.txt |  | 골든 Doc\verify\SCP0104\snap\golden\헤더_SOP_MODEL_ELTR.txt 와 일치 · 헤더 1행 · 칸 10 |

승인: `python tools/Harness/verify/snap_expect.py <ID>` → `snap_validate.py <ID>`(불일치 0 확인) → `snap_approve.py <ID> [--item 키] --by 이름 --opinion 사유`
