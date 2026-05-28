/**
 * dayjs locale 사전 등록 — App mount 전에 반드시 실행되어야 함.
 *
 * Why: `@lges/design-system` 의 DatePicker 컴포넌트가
 *      `import(\`dayjs/locale/${locale}\`)` 동적 템플릿 import 를 사용함.
 *      Vite 는 변수 보간 dynamic import 의 bare specifier 를 정적 분석/rewrite
 *      할 수 없어, 브라우저가 `dayjs/locale/ko` 를 resolve 못해 TypeError 발생.
 *      → 사용 가능한 locale 을 정적 import 로 사전 등록 + 기본 locale 설정.
 *      → `vite.config.ts` 의 esbuild 플러그인이 위 동적 import 자체를
 *        `Promise.resolve()` 로 치환하므로, 본 파일은 locale 데이터 등록만 담당.
 *
 * 지원 언어: i18n KO/EN/CN ↔ dayjs ko/en/zh-cn.
 */
import dayjs from 'dayjs';

import 'dayjs/locale/ko';
import 'dayjs/locale/en';
import 'dayjs/locale/zh-cn';

dayjs.locale('ko');
