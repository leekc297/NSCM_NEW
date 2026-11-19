import { defineConfig, loadEnv, type Plugin } from 'vite';
import react from '@vitejs/plugin-react';
import svgr from 'vite-plugin-svgr';
import tsconfigPaths from 'vite-tsconfig-paths';
import path from 'node:path';
import fsPromises from 'node:fs/promises';
import AutoImport from 'unplugin-auto-import/vite';
import { visualizer } from 'rollup-plugin-visualizer';
import dayjs from 'dayjs';
import type { Plugin as EsbuildPlugin } from 'esbuild';

/**
 * `@lges/design-system` 의 DatePicker 컴포넌트 5곳이 `import(`dayjs/locale/${locale}`)`
 * 동적 템플릿 import 를 사용. Vite 는 변수 보간 dynamic import 의 bare specifier 를
 * 정적 분석/rewrite 불가 → 브라우저 런타임에서 `TypeError: Failed to resolve module
 * specifier 'dayjs/locale/ko'` 발생.
 *
 * esbuild pre-bundling 단계에서 해당 dynamic import 자체를 `Promise.resolve()` 로 치환.
 * locale 데이터는 `apps/web/src/dayjs-setup.ts` 에서 정적 import 로 사전 등록되어 있어
 * 동적 로딩이 불필요.
 */
const DAYJS_LOCALE_DYNAMIC_IMPORT = /import\(`dayjs\/locale\/\$\{[^}]+\}`\)/g;
const LGES_LIB_MAIN = /[\\/]@lges[\\/]design-system[\\/]lib-main\.mjs$/;

// [dev] esbuild 사전번들(optimizeDeps) 경로 — 동적 locale import 를 Promise.resolve() 로 치환.
const lgesDayjsLocalePatch: EsbuildPlugin = {
  name: 'lges-dayjs-locale-patch',
  setup(build) {
    build.onLoad({ filter: LGES_LIB_MAIN }, async args => {
      const source = await fsPromises.readFile(args.path, 'utf8');
      const patched = source.replace(DAYJS_LOCALE_DYNAMIC_IMPORT, 'Promise.resolve()');
      return { contents: patched, loader: 'js' };
    });
  },
};

// [build] 운영 빌드(Rollup) 경로 — 위 esbuild 플러그인은 optimizeDeps(dev 사전번들)에만 적용돼
//   `vite build` 에는 반영되지 않는다. 그래서 운영 번들에서는 패치가 빠져 `@lges/design-system`
//   DatePicker 의 `import(\`dayjs/locale/${locale}\`)` 가 그대로 남아 브라우저가 bare specifier
//   `dayjs/locale/ko` 를 resolve 못해 `Failed to resolve module specifier` + 연쇄 TypeError
//   (startTime)가 났다(운영 전용 재발, 2026-11-17). Vite transform 훅(apply:'build')으로 동일
//   치환을 운영 빌드에도 적용한다. locale 데이터는 dayjs-setup.ts 정적 import 가 이미 등록한다.
const lgesDayjsLocaleBuildPatch: Plugin = {
  name: 'lges-dayjs-locale-patch-build',
  apply: 'build',
  transform(code, id) {
    if (!LGES_LIB_MAIN.test(id)) return null;
    const patched = code.replace(DAYJS_LOCALE_DYNAMIC_IMPORT, 'Promise.resolve()');
    return patched === code ? null : { code: patched, map: null };
  },
};

export default ({ mode }: { mode: string }) => {
  console.log(`env mode: ${mode}`);

  const env = loadEnv(mode, process.cwd(), '');
  console.log(`VITE_ENV: ${env.VITE_ENV}`);
  console.log(`VITE_API_BASE_URL: ${env.VITE_API_BASE_URL}`);

  return defineConfig({
    plugins: [
      lgesDayjsLocaleBuildPatch,
      tsconfigPaths(),
      react(),
      svgr(),
      AutoImport({
        imports: [
          {
            '@foundation/i18n': ['useTranslation'],
          },
        ],
        dts: '../../configs/types/auto-imports.d.ts',

        eslintrc: {
          enabled: true,
        },
      }),
      visualizer({
        filename: `./.report/report_${dayjs().format('YYYYMMDD_hhmmss')}.html`, // 분석 결과 저장 경로
        open: true, // 빌드 후 자동으로 브라우저 열기
        gzipSize: true, // gzip 압축 시 크기 표시
        brotliSize: true, // brotli 압축 시 크기 표시
      }),
    ],
    publicDir: path.resolve(__dirname, '../../public'),
    server: {
      port: 3000,
      strictPort: false,
      proxy: {
        '/api': {
          target: env.VITE_API_BASE_URL,
          changeOrigin: true,
          rewrite: path => path.replace(/^\/api/, ''),
        },
      },
    },
    resolve: {
      alias: {
        '@foundation/styles': path.resolve(__dirname, '../../packages/foundation/src/styles'),
      },
    },
    build: {
      outDir: 'dist',
      sourcemap: mode === 'development',
      rollupOptions: {
        output: {
          manualChunks: {
            vendor: ['react', 'react-dom'],
            router: ['react-router-dom'],
          },
        },
      },
    },
    css: {
      preprocessorOptions: {
        scss: {
          additionalData: `@use '@foundation/styles/global' as *;`,
        },
      },
    },
    optimizeDeps: {
      include: ['zustand', 'dayjs', 'dayjs/locale/ko', 'dayjs/locale/en', 'dayjs/locale/zh-cn'],
      esbuildOptions: {
        plugins: [lgesDayjsLocalePatch],
      },
    },
  });
};
