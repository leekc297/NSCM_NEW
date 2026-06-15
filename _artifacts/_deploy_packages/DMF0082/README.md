# DMF0082 FCST & PRICE MGMT — Deploy Package (SKELETON, 12 화면 중 최복잡)

> Phase B-9 — DMF0081 (FCST) + DMF0020 (PRICE) 결합
> 작성: 2026-06-07
> AS-IS .cs 9,418줄 / PKG body 3,038줄
> 분석서: Doc/_analysis/domain_DM/screens/DMF0082_FcstNPrice_Mgmt/ (8 MD, Phase A 작성)
> Figma: ✅ DMF0082.svg + DMF0082_Table_v2.svg

## SKELETON (5 파일 + Router)

- `features/demand/src/pages/fcst-price-mgmt/` (5 파일)
- `route-paths.ts`: 임시 path 'fcst-price-mgmt' (Router.tsx 에 hardcoded — ROUTE_PATHS 정정 필요)
- `Router.tsx`: DEMAND > DEMAND_PLAN > 'fcst-price-mgmt'
- URL: `/demand/demand-plan/fcst-price-mgmt`

## 특수성 (12 화면 최복잡)

- **6 ResultSet 메인 SP** (O_RC1=FCST / O_RC2=PRICE / O_RC3=MEASURE / O_RC4=CALENDAR / O_RC5=WEEK / O_RESULT_CURSOR)
- **권한 4 분기** (bEDIT_AUTH_SCM_FCST / MKT_FCST / LOC / VMI_IN_REQ)
- 월간→일별 배분 logic (SCM_SYS_CALENDAR_M)
- Clipboard Paste 최적화 (2025-07-22 — 대량 cell + 권한 분기)
- Mon-Sun 권한 분기 (월요일 SCM_FCST 입력 → MKT FCST 잠금, E20250729-000433)
- 3 신규 popup (FuturePriceInfo + MeasureCountInfo + WeekData)
- SAVE SP 신규 재구현 (16 IN + 1 OUT — 주석 처리된 P_DMF0082_SAVE_MAIN_DATA)

## ⚠️ Phase B-9 후속 (가장 복잡 — cs 9,418줄 전체 read 의무)

| # | 항목 | 분량 |
|---:|---|---:|
| 1 | .cs 9,418줄 + .Designer.cs 전체 read + 40+ event 정밀 매핑 | 5-7일 |
| 2 | 6 ResultSet 분리 (FCST + PRICE 병렬 grid 행) | 2일 |
| 3 | 권한 4 분기 cell 색상 + 편집 가능/불가 logic | 2일 |
| 4 | 월간→일별 배분 logic (utils `monthToDailyDistribute.ts`) | 1일 |
| 5 | Clipboard Paste 최적화 (대량 + 권한 분기) | 2일 |
| 6 | Mon-Sun 권한 분기 (월요일 SCM_FCST → MKT FCST 잠금) | 1일 |
| 7 | SAVE SP 신규 작성 (16 IN + Trigger) + FE handleSave | 2일 |
| 8 | 3 신규 modal (FuturePriceInfo / MeasureCountInfo / WeekData) | 2일 |
| 9 | Figma 1:1 재현 (figma-mapping-check hook) | 1일 |
| 10 | 메타 SQL 7-BLOCK | 1일 |
| | **총** | **약 20일** |

## ⚠️ ROUTE_PATHS 정정 필요

기존 ROUTE_PATHS.DMF0082 = 'forecast-price' (deprecated 화면 매핑).
신규 DMF0082 = 'fcst-price-mgmt' 로 변경 필요.
또는 기존 features/demand/src/pages/forecast-price/ 폴더를 fcst-price-mgmt 로 변경 / 통합.

본 SKELETON 은 Router.tsx 의 path 를 'fcst-price-mgmt' hardcoded 로 등록.
사용자 결정 필요: 기존 'forecast-price' 폐기 vs 통합.
