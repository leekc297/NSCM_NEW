# DMF0082 클라우드 이관 — 행 정렬 표시정합 + Measure Modal 정본화 (2026-08-26)

> 두 건 모두 **FE 단독** 수정 — DB 이관물 없음. (SP 정렬 시도분은 미투영 컬럼 참조 결함으로 당일 원복 — 사내/이관 흔적 0)

## B_FE — 1본 (실경로 구조 — `B_FE/` 하위를 nscm-fe 루트에 그대로 덮어쓰기)

| 파일 | 내용 |
|---|---|
| `B_FE/features/demand/src/pages/forecast-price/ForecastPrice.tsx` | ①[E20260826-DISPSORT] 그리드 행 정렬 = **표시값 기준** (개인화 표시 컬럼 순서, ENDCUSTDISP 고객명 교체 후 정렬 — Audi→VW→BMW 어긋남 해소. stable sort 라 메저 행 순서는 SP 원 순서 유지, 40 은 표시값=원장값이라 회귀 0) ②Measure Modal 정본화 — `showMeasureCode` 제거 (DMF0003 사용형 = 정본, 통합테스트 1st No.40 역전 — 2026-08-26 사용자 확정, hook #132 금지 4호) ③SiteEndCustomerMap 콤보 q() 인용 |

## ⚠ 주의

1. **이 파일은 `DMF0082_CLOUD_20260826_PENDING` 패키지의 동일 경로 파일과 같은 최신 단일본** — PENDING 을 함께 적용하면 이 폴더는 중복 적용해도 무해(동일 파일). PENDING 미적용 상태로 이 폴더만 적용하는 것은 ⛔ (Excel Form 계약 등 PENDING FE 3본과 한 몸).
2. 전제: 공통소스 `gridNegativeText.ts` 포함 세대 (PENDING README 동일).
3. FE 검증: type-check @demand 강제 PASS / eslint forecast-price error 0 (2026-08-26).

**상태: 취합 완료 / 클라우드 미적용**
