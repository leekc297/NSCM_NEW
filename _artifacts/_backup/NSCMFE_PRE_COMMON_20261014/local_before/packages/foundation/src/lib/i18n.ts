import i18nOrigin from 'i18next';
import type { InitOptions } from 'i18next';
import HttpApi from 'i18next-http-backend';
import { initReactI18next } from 'react-i18next';

import { apiClient } from '../apis/axios';

export { t } from 'i18next';
export { I18nextProvider, useTranslation } from 'react-i18next';

export const supportedLngs = ['KO', 'EN', 'CN'];

// /admin/message(MessageController) 응답 1건 — SCM_ADM_MSG_M 실 DB 값(MessageDto).
interface DbMessage {
  messageId: string;
  messageNm?: string;
  i18nCtn?: string;
  langCd?: string;
}

// 다국어는 정적 public/locales/*.json 이 아니라 DB(SCM_ADM_MSG_M)를 런타임 로드한다(사용자 지시
//   2026-09-29). 경로: FE i18next → GET /admin/message → MessageService → SCM_ADM_MSG_M.
//   /admin/message 는 세션 langCd 기준 메시지를 반환하고, 언어 전환도 세션 langCd 단방향 동기화
//   (apps/web Providers.tsx: session.langCd → i18n.changeLanguage)라, i18next 가 요청하는 lng 와
//   엔드포인트가 돌려주는 언어가 항상 일치한다. gen:i18n(사내 서버 의존) 정적 번들에 의존하지 않는다.
// SCM_ADM_MSG_M 메시지에는 개행/탭이 리터럴 이스케이프("\n","\r","\t")로 저장돼 있다(AS-IS 관행
//   — 예: MSG01261 "...입니다 .\n\rUser ID : {0}", MSG00457/MSG01067/MSG01124 등 다수). i18next 는
//   이를 그대로 반환하고 알림창(CustomDialogContent white-space:pre-line)은 실제 개행만 줄바꿈하므로,
//   그대로 두면 "\n\r" 이 글자 그대로 노출된다. 로드 시 실제 제어문자로 되돌린다("\r\n"/"\n\r"
//   조합은 단일 개행으로 합침). 이스케이프가 없는 메시지는 무변경.
const unescapeControlChars = (s: string): string =>
  s.replace(/\\r\\n|\\n\\r|\\n|\\r/g, '\n').replace(/\\t/g, '\t');

const loadDbMessages = (
  onLoaded: (error: unknown, response: { status: number; data: string }) => void
): void => {
  apiClient
    .get<DbMessage[]>('admin/message')
    .then(res => {
      const list = res.data.result ?? [];
      const resources: Record<string, string> = {};
      for (const msg of list) {
        // MSG_NM 우선, 없으면 I18N_CTN, 그것도 없으면 코드 자체(누락 가시화).
        resources[msg.messageId] = unescapeControlChars(
          msg.messageNm ?? msg.i18nCtn ?? msg.messageId
        );
      }
      onLoaded(null, { status: 200, data: JSON.stringify(resources) });
    })
    .catch((error: unknown) => {
      // 로드 실패 시(예: BE 미기동) i18next 는 각 t() 호출부의 defaultValue 로 폴백한다
      //   (useSuspense:false). 빈 카탈로그를 넘겨 파싱 오류 없이 실패 처리한다.
      onLoaded(error, { status: 500, data: '{}' });
    });
};

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
    // 정적 파일 경로 대신 DB 엔드포인트에서 로드한다. loadPath 는 형식상 지정하고,
    //   실제 요청·변환은 request 가 담당한다(응답을 {messageId: text} 맵으로 가공).
    loadPath: 'admin/message',
    request: (
      _options: unknown,
      _url: string,
      _payload: unknown,
      callback: (error: unknown, response: { status: number; data: string }) => void
    ) => loadDbMessages(callback),
  },

  // 리소스가 로드되지 않았을 때 서스펜스를 사용할지 여부.
  // 금지: true 로 되돌리지 말 것 — Header 는 MainLayout 이 eager import 라 Suspense 경계 밖에 있다
  //   (경계는 LazyLoader/ViewContainer 안쪽 페이지에만 있음). 언어 전환으로 DB 메시지를 새로
  //   받는 동안 Header 의 useTranslation 이 suspend 하면 받아줄 fallback 이 없다.
  //   false 면 t() 가 그동안 호출부 fallback 인자를 돌려주고 로드 완료 시 자연스럽게 교체된다.
  react: {
    useSuspense: false,
  },
};

void i18nOrigin.use(HttpApi).use(initReactI18next).init(commonI18nConfig);

export const i18n = i18nOrigin;
