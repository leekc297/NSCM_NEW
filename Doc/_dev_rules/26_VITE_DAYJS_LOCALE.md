# 26. Vite + @lges/design-system dayjs/locale 동적 import 해결

> ⭐ DatePicker 컴포넌트가 처음 사용된 페이지에서 `Failed to resolve module specifier 'dayjs/locale/ko'` TypeError 발생 시 본 룰 적용.
>
> 작성: 2026-05-22 (DMF0020 첫 오픈 시 발견)
> 관련: 03_FE_RULES.md / 21_TROUBLESHOOTING.md

---

## 1. 증상

DMF0020 (또는 기타 DatePickerCalendar / DateField 사용 화면) 첫 오픈 시 브라우저 콘솔:

```
Uncaught (in promise) TypeError: Failed to resolve module specifier 'dayjs/locale/ko'
    at @lges_design-system.js?v=XXXXX:94547
```

또는 (locale 미등록 fallback 경고):
```
Your locale has not been found.
Either the locale key is not a supported one. ...
fallback on English locale
```

DatePicker 본체는 영문으로 렌더되지만 일부 화면 컴포넌트가 깨질 수 있음. Vite HMR 재시작 / 캐시 무효화로 해결 안 됨.

---

## 2. 근본 원인

`@lges/design-system@1.0.17` 의 DatePicker 5곳 (`lib-main.mjs`):

```js
useEffect(() => {
  import(`dayjs/locale/${g}`).then(() => {
    se.locale(g);
  });
}, [g]);
```

이 **변수 보간 dynamic import** 는 Vite 의 정적 분석/rewrite 대상 외:
- Static dynamic import (`import('./foo.js')`) — Vite rewrite OK
- Template literal dynamic import (`import(\`./${x}\`)`) — 사용자 코드는 `@rollup/plugin-dynamic-import-vars` 패턴으로 Vite 가 부분 지원, 하지만 **node_modules 내 패키지의 dynamic import 는 별도 처리 없이는 미지원**

결과: pre-bundled `node_modules/.vite/deps/@lges_design-system.js` 에 동일 패턴이 그대로 보존 → 브라우저는 `dayjs/locale/ko` 라는 bare specifier 를 resolve 못함 → TypeError.

---

## 3. 해결 (3-파일 정공법)

### 3.1 `apps/web/src/dayjs-setup.ts` 신규

```ts
/**
 * dayjs locale 사전 등록 — App mount 전에 반드시 실행되어야 함.
 *
 * Why: @lges/design-system 의 DatePicker 컴포넌트가
 *      `import(\`dayjs/locale/${locale}\`)` 동적 템플릿 import 를 사용함.
 *      Vite 는 변수 보간 dynamic import 의 bare specifier 를 정적 분석/rewrite 불가.
 *      → 정적 import 로 사전 등록 + 기본 locale 설정.
 *      → vite.config.ts 의 esbuild 플러그인이 동적 import 를 Promise.resolve() 로 치환.
 *
 * 지원 언어: i18n KO/EN/CN ↔ dayjs ko/en/zh-cn.
 */
import dayjs from 'dayjs';

import 'dayjs/locale/ko';
import 'dayjs/locale/en';
import 'dayjs/locale/zh-cn';

dayjs.locale('ko');
```

### 3.2 `apps/web/src/index.tsx` 최상단에 import 추가

```ts
import './dayjs-setup';            // ⭐ 반드시 최상단 첫 줄
import '@foundation/i18n';
import React from 'react';
import ReactDOM from 'react-dom/client';
import { App } from './core/App';
import '@foundation/styles/wijmo/wijmo.scss';
```

### 3.3 `apps/web/vite.config.ts` 에 esbuild plugin + optimizeDeps 확장

```ts
import fsPromises from 'node:fs/promises';
import type { Plugin as EsbuildPlugin } from 'esbuild';

const lgesDayjsLocalePatch: EsbuildPlugin = {
  name: 'lges-dayjs-locale-patch',
  setup(build) {
    build.onLoad({ filter: /[\\/]@lges[\\/]design-system[\\/]lib-main\.mjs$/ }, async args => {
      const source = await fsPromises.readFile(args.path, 'utf8');
      const patched = source.replace(
        /import\(`dayjs\/locale\/\$\{[^}]+\}`\)/g,
        'Promise.resolve()'
      );
      return { contents: patched, loader: 'js' };
    });
  },
};

export default ({ mode }) => defineConfig({
  // ...
  optimizeDeps: {
    include: ['zustand', 'dayjs', 'dayjs/locale/ko', 'dayjs/locale/en', 'dayjs/locale/zh-cn'],
    esbuildOptions: {
      plugins: [lgesDayjsLocalePatch],
    },
  },
});
```

---

## 4. 검증

```
[Step 1] node_modules/.vite/deps 캐시 무효화
  Windows: Remove-Item -Recurse -Force apps/web/node_modules/.vite
  Unix   : rm -rf apps/web/node_modules/.vite

[Step 2] pnpm dev 재실행

[Step 3] DMF0020 (또는 DatePickerCalendar 사용 화면) 오픈
  → 콘솔에서 'Failed to resolve module specifier' 사라짐
  → fallback on English 경고 사라짐

[Step 4] (선택) pre-bundle 산출물 직접 확인
  apps/web/node_modules/.vite/deps/@lges_design-system.js 의
  L94547 대 (또는 5건) 가 `Promise.resolve().then(() => { se.locale(...) })` 로 치환됐는지 확인
```

---

## 5. 부수 효과

- i18n 언어 토글 (KO/EN/CN) 시 dayjs locale 자동 동기화 로직은 별도 작업 필요 (현재는 'ko' 고정)
- `@lges/design-system` 업그레이드 시 dynamic import 가 제거됐는지 확인 후 esbuild plugin 제거 가능 여부 판단
- DatePicker 미사용 화면이라도 페이지 단위 lazy-load 로 시점 차이만 있을 뿐 동일 오류 발생 가능 — 본 fix 가 전역 보호

---

## 6. 이관 패키지

```
C:\Projects\NSCM\_artifacts\dayjs-locale-fix_20260522.zip   (4,802 bytes)
└── fe/apps/web/
    ├── src/dayjs-setup.ts         (신규)
    ├── src/index.tsx              (수정 — 1줄 추가)
    └── vite.config.ts             (수정 — esbuild plugin + optimizeDeps)
```

---

## 7. 다른 동일 패턴 라이브러리

`@mui/x-date-pickers` 등도 유사한 dynamic locale 패턴 사용. 본 화면 작업 외에 새 라이브러리 도입 시 동일 점검 필요.

```powershell
# 패키지 내부 dynamic locale import 패턴 grep
Get-ChildItem -Path 'node_modules' -Recurse -Filter '*.mjs' -ErrorAction SilentlyContinue |
  Select-String -Pattern 'import\(`[^`]*locale/\$\{' -SimpleMatch:$false |
  Select-Object Path, LineNumber, Line
```

매치되는 패키지가 발견되면 본 룰 §3.3 의 esbuild plugin filter 에 추가 패턴 등록.
