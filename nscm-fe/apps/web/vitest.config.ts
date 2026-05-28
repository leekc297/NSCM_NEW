import tsconfigPaths from 'vite-tsconfig-paths';
import { defineConfig, mergeConfig } from 'vitest/config';
import { baseVitestConfig } from '../../configs/vitest.config';

export default mergeConfig(
  baseVitestConfig,
  defineConfig({
    plugins: [tsconfigPaths()],
    test: {
      name: 'appsWebTest',
      passWithNoTests: true,
      // pool: 'forks',
      // 브라우저 환경 jsdom or happy-dom (mocking을 통한 DOM API 사용 가능)
      environment: 'jsdom',
      // 전역 변수 사용
      globals: true,
      // 공통 실행 로직
      setupFiles: ['src/setup.ts'],
      // 테스트 파일
      include: ['src/**/*.test.ts', 'src/**/*.test.tsx'],
    },
  })
);
