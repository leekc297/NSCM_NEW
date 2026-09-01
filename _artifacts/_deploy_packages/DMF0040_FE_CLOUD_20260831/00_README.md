# DMF0040 MKT FCST Comparison — FE 클라우드 이관 (2026-08-31, 토일월 수정분)

## 포함 (2 파일 + d.ts 블록)
- `features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx` — UM02FIX(EndCustomerByDivision + 40 한정 cascade)
- `.../MktFcstComparisonGrid.tsx` — 주말 수정 최종본
- `procedures.d.ts.DMF0040_BLOCK.txt` — 블록 단위 병합용

## 반영 방법
- `nscm-fe/` 이하 **실경로 그대로** 클라우드 소스에 덮어쓰기 (축약·평탄화 ⛔ — 룰 22 §1.8).
- `procedures.d.ts.*_BLOCK.txt` 는 클라우드 d.ts 에 **블록 단위 병합**만 (전체본 덮어쓰기 ⛔, hook #148). 동일하면 스킵.
- 취합 기준: 2026-08-29(토)~08-31(월) 수정분 최종본. 금요일(08-28) 이관분에서 미수정 파일은 미포함.
- 검증: 로컬 type-check 13/13 PASS + lint 0 error (2026-08-31, fe-check.ps1 — 넥서스 미접속).
