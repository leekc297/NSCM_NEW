# DMF0081 MKT FCST (AUTO) — Deploy Package (SKELETON)

> Phase B-8 — DMF0003_1_MktFcst reference + 3 Sheet 변형
> 작성: 2026-06-07
> 분석서: Doc/_analysis/domain_DM/screens/DMF0081_MktFcst_Auto/ (8 MD, Phase A 작성)

## SKELETON (5 파일 + Router)

- `features/demand/src/pages/mkt-forecast-auto/` (5 파일)
- `route-paths.ts`: DMF0081: 'mkt-forecast-auto'
- `Router.tsx`: DEMAND > DEMAND_PLAN > DMF0081
- URL: `/demand/demand-plan/mkt-forecast-auto`

## 특수성

- 3 Sheet (Mkt Fcst + PSI + Car Fcst) — Multi-Sheet Tab UI 의무
- 6 PKG SP (메인 9IN+3OUT / PSI / Detail Popup / Save Popup / Excel Upload / DDL Template)
- 50+ DefColumns + 측정 9 (M3/M2/M1 CUST/MKT_FCST) + 누적 18 (SUM_03/06/12 etc.)
- 자동차 사업부 특화 (자동 계산 + Excel Upload 배치)
- 1 신규 popup (CustDemandAnlDetail — 변경 사유 입력)

## ⚠️ Phase B-8 후속 (cs 6,386줄 정밀 분석 의무)

- 3 Sheet Tabs UI (active sheet 별 grid 분리)
- CustDemandAnlDetailModal 신규 (8 IN 조회 + 12 IN 저장)
- Car Fcst 시트 Excel Upload + DDL Template 다운로드
- 30+ event handler 정밀 매핑
- 50+ DefColumns + 동적 시간축 정밀
- POPUP_STATUS (MODIFY/READ_OK/READ_NONE) cell 색상 분기
- 메타 SQL 7-BLOCK
