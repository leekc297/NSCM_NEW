# SCP0096 단위테스트 실행 결과 — 2026-10-20 10:34

- 대상: `nscm-fe/features/supply/src/pages/shipment-working-day-osp/__tests__/ShipmentWorkingDayOsp.spec.ts` (TC-SCP0096-001~009)
- 실행: features/supply 에 임시 `vitest.scp0096.tmp.config.ts`(baseVitestConfig + include `src/pages/shipment-working-day-osp/__tests__/*.spec.ts`, environment node)로
  `node ../../node_modules/vitest/vitest.mjs run --config vitest.scp0096.tmp.config.ts` → 실행 직후 임시 설정 삭제(feature 트리 무변경).
- 이유: `features/supply/vitest.config.ts` include 는 `src/**/*.test.ts` 라 B20 명명(`__tests__/*.spec.ts`)을 기본 실행에서 제외한다 — 공용 설정 변경 금지(regression-zero)라 명시 실행.
- 결과: Test Files 1 passed / Tests 9 passed (vitest v4.0.18, 3.50s).
