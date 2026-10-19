import tsconfigPaths from 'vite-tsconfig-paths';
import { defineConfig, mergeConfig } from 'vitest/config';

import { baseVitestConfig } from '../../configs/vitest.config';

export default mergeConfig(
  baseVitestConfig,
  defineConfig({
    plugins: [tsconfigPaths()],
    test: {
      environment: 'jsdom',
      globals: true,
      include: ['src/**/*.test.ts', 'src/**/*.test.tsx'],
      passWithNoTests: true,
    },
  })
);
