import i18nOrigin from 'i18next';
import type { InitOptions } from 'i18next';
import HttpApi from 'i18next-http-backend';
import { initReactI18next } from 'react-i18next';

export { t } from 'i18next';
export { I18nextProvider, useTranslation } from 'react-i18next';

export const supportedLngs = ['KO', 'EN', 'CN'];

// 다국어는 정적 public/locales/{KO,EN,CN}.json 을 런타임 로드한다(사용자 지시 2026-10-26 — DB
//   런타임 직접 조회에서 복귀). 각 JSON 은 배포 시 sync-i18n.mjs 가 해당 환경 DB(SCM_ADM_MSG_M)
//   에서 생성한다. loadPath 의 {{lng}} 는 i18next 가 로드 중인 언어(KO/EN/CN)로 치환돼 자기
//   언어 파일만 로드하므로 언어 버킷 간 오염(desync)이 구조적으로 없다.
// SCM_ADM_MSG_M 메시지에는 개행/탭이 리터럴 이스케이프("\n","\r","\t")로 저장돼 있고(AS-IS 관행
//   — 예: MSG01261, MSG00457 등) 생성된 JSON 에도 JSON 이스케이프된 형태("\\n\\r")로 그대로
//   들어간다. i18next 는 이를 그대로 반환하고 알림창(CustomDialogContent white-space:pre-line)은
//   실제 개행만 줄바꿈하므로, 로드 시 실제 제어문자로 되돌린다("\r\n"/"\n\r" 조합은 단일 개행으로
//   합침). 이스케이프가 없는 메시지는 무변경.
const unescapeControlChars = (s: string): string =>
  s.replace(/\\r\\n|\\n\\r|\\n|\\r/g, '\n').replace(/\\t/g, '\t');

const commonI18nConfig: InitOptions = {
  fallbackLng: 'KO',
  supportedLngs: supportedLngs, // 허용할 언어 목록

  nsSeparator: false,
  keySeparator: false,
  // 네임스페이스 설정 (우리는 translation.json 하나를 쓰기로 했으므로)
  ns: ['translation'],
  defaultNS: 'translation',

  interpolation: {
    escapeValue: false, // React는 기본적으로 XSS 방지를 하므로 false 설정
  },

  backend: {
    // 정적 locales 파일을 로드한다. {{lng}} 는 로드 중인 언어로 치환된다.
    loadPath: '/locales/{{lng}}.json',
    // 생성된 JSON 의 리터럴 이스케이프("\\n" 등)를 실제 제어문자로 복원한다(위 주석 참고).
    parse: (data: string) => {
      const obj = JSON.parse(data) as Record<string, unknown>;
      for (const key of Object.keys(obj)) {
        if (typeof obj[key] === 'string') {
          obj[key] = unescapeControlChars(obj[key] as string);
        }
      }
      return obj;
    },
  },

  // 리소스가 로드되지 않았을 때 서스펜스를 사용할지 여부.
  // 금지: true 로 되돌리지 말 것 — Header 는 MainLayout 이 eager import 라 Suspense 경계 밖에 있다
  //   (경계는 LazyLoader/ViewContainer 안쪽 페이지에만 있음). 언어 전환으로 {lng}.json 을 새로
  //   받는 동안 Header 의 useTranslation 이 suspend 하면 받아줄 fallback 이 없다.
  //   false 면 t() 가 그동안 호출부 fallback 인자를 돌려주고 로드 완료 시 자연스럽게 교체된다.
  react: {
    useSuspense: false,
  },
};

void i18nOrigin.use(HttpApi).use(initReactI18next).init(commonI18nConfig);

export const i18n = i18nOrigin;
