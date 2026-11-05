# SCP0007 CheckList 자기검증(변이 시험) — 2026-10-28 16:52:52

| 규칙 | 주입 대상 | 주입 | 결과 | 근거 |
|---|---|---|---|---|
| C2 | * | 콤보 후보 고정+첫 후보 누락(원천 값에 따른 후보 재구성 안 함) — dataMap 7개 | **미검출** | 주입했는데 3행 PASS 유지(검사기 결함): [V-05550393] TO_SITE PLANT 'CN00732500_40-P' → INCOTERMS_SSP 후보 10·편집=true / SALES 'APRO_KR_ANY' → 후보 10·편집=false · 편집 분기 후보 10 ↔ AS- / [V-3fb6d815] TO_SITE PLANT 'CN00732500 |
