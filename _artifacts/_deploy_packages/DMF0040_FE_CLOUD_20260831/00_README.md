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

## 2026-09-01 2차 보강
- 화면 폴더 **전체본** 재취합 — constants/types/스토어 등이 클라우드 구본(클라우드 type-check 실측 오류 TS2305 FOOTER_FORMAT/scaleOf/widthOf 의 원인). 부분(수정분만) 취합 기준 폐기 → 공통소스 내용 대조 기준
- d.ts DMF0040 블록: 공통소스(8f0b2a60)와 **동일** 확인 — 병합 시 스킵 가능
