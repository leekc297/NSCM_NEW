// SCP0096 __tests__/*.spec.ts 실행용 임시 설정 — features/supply/vitest.config.ts 의 include(src/**/*.test.ts)가 spec 을 제외해 명시 실행한다.
import tsconfigPaths from 'vite-tsconfig-paths';
import { defineConfig } from 'vitest/config';

export default defineConfig({
  plugins: [tsconfigPaths({ root: 'C:/Projects/NSCM/nscm-fe/features/supply' })],
  test: {
    root: 'C:/Projects/NSCM/nscm-fe/features/supply',
    environment: 'node',
    globals: true,
    include: ['src/pages/shipment-working-day-osp/__tests__/*.spec.ts'],
  },
});
