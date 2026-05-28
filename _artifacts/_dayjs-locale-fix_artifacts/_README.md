# dayjs Locale Fix — 클라우드 적용 가이드

작성: 2026-05-22
원인 화면: DMF0020 (sales-future-price) 외 DatePicker 사용 4개 화면 (forecast-price / customer-fcst-upload / sales-plan-waterfall / SalesPriceRangeModal) 잠재 영향

## 1. 무엇을 고치는가

`@lges/design-system@1.0.17` 의 DatePicker 컴포넌트가 `import(\`dayjs/locale/${locale}\`)` 동적 템플릿 import 를 사용. Vite 는 변수 보간 dynamic import 의 bare specifier 를 정적 분석/rewrite 못함 → 브라우저에서 `Uncaught (in promise) TypeError: Failed to resolve module specifier 'dayjs/locale/ko'` 발생.

## 2. 해결 방식

| # | 파일 | 종류 | 역할 |
|---|---|---|---|
| 1 | `apps/web/src/dayjs-setup.ts` | 신규 | `dayjs/locale/ko/en/zh-cn` 정적 import + 기본 locale 'ko' 설정 |
| 2 | `apps/web/src/index.tsx` | 수정 | `import './dayjs-setup';` 를 **최상단** 첫 줄에 추가 (App mount 전 실행 보장) |
| 3 | `apps/web/vite.config.ts` | 수정 | `optimizeDeps.esbuildOptions.plugins` 에 esbuild 플러그인 추가하여 `lib-main.mjs` 의 dynamic locale import 5건을 `Promise.resolve()` 로 치환 + `optimizeDeps.include` 에 dayjs locale 3종 명시 |

## 3. 클라우드 적용 절차 (3 step)

```
[Step 1] 압축 해제 후 fe/ 내부 파일을 nscm-fe/ 위에 그대로 덮어쓰기
  cp -r fe/apps/web/src/dayjs-setup.ts        <CLOUD_ROOT>/nscm-fe/apps/web/src/dayjs-setup.ts
  cp -r fe/apps/web/src/index.tsx             <CLOUD_ROOT>/nscm-fe/apps/web/src/index.tsx
  cp -r fe/apps/web/vite.config.ts            <CLOUD_ROOT>/nscm-fe/apps/web/vite.config.ts

[Step 2] Vite pre-bundle 캐시 무효화 (필수)
  # Windows
  Remove-Item -Recurse -Force <CLOUD_ROOT>/nscm-fe/apps/web/node_modules/.vite
  # Unix
  rm -rf <CLOUD_ROOT>/nscm-fe/apps/web/node_modules/.vite

[Step 3] dev 서버 재기동
  cd <CLOUD_ROOT>/nscm-fe
  pnpm dev
```

## 4. 검증

DMF0020 (sales-future-price) 오픈 → 브라우저 콘솔 확인:

- ❌ 사라져야 할 오류: `TypeError: Failed to resolve module specifier 'dayjs/locale/ko'`
- ❌ 사라져야 할 경고: `Your locale has not been found. ... fallback on English locale`
- ✅ 동작: 검색 영역의 `Period` (DatePickerCalendar) 가 정상 렌더 및 한국어 locale 적용

esbuild 플러그인이 정상 동작했는지 직접 확인하려면:

```
<CLOUD_ROOT>/nscm-fe/apps/web/node_modules/.vite/deps/@lges_design-system.js
```

위 파일을 열어 `Promise.resolve().then(() => {` 라인이 5건 (원래는 `import(\`dayjs/locale/${X}\`).then(() => {`) 으로 치환됐는지 확인.

## 5. BE / DB 영향

없음. 본 fix 는 FE dev 인프라 (Vite pre-bundle) 단계만 변경합니다.

## 6. 부수 효과 / Side-Effects

- i18n 언어 토글 (KO ↔ EN ↔ CN) 시 dayjs locale 도 자동 동기화하는 로직은 별도 작업 필요. 현재는 기본 'ko' 고정.
- 향후 `@lges/design-system` 업그레이드 시 라이브러리에서 동적 import 가 제거되면 본 vite.config.ts 의 `lgesDayjsLocalePatch` 도 제거 가능.

## 7. 변경 파일 상세

```
fe/
└── apps/
    └── web/
        ├── src/
        │   ├── dayjs-setup.ts     (신규)
        │   └── index.tsx          (수정 — 1줄 추가)
        └── vite.config.ts         (수정 — esbuild 플러그인 + optimizeDeps 확장)
```
