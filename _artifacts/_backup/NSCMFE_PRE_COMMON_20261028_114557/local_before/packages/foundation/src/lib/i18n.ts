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
//   2026-09-29). 경로: FE i18next → GET /admin/message?langCd={{lng}} → MessageService → SCM_ADM_MSG_M.
//   중요(2026-10-01): i18next 가 로드하는 언어(lng)를 쿼리 파라미터로 명시해 넘긴다. 과거에는 lng 를
//   넘기지 않고 BE 가 세션 langCd 로만 응답했는데, i18next 는 언어별 리소스 버킷을 캐시하므로
//   부팅 시 fallbackLng('KO') 버킷을 세션 언어 적용 전에 먼저 로드하면 그 순간 세션이 비-KO 일 때
//   KO 버킷이 다른 언어로 영구 오염돼 "KOR 표시 + 다른 언어 메시지" desync 가 났다. 이제 각 버킷은
//   자기 lng 로 조회되므로 캐시가 안전하다. BE 는 langCd 파라미터가 없을 때만 세션 langCd 로 폴백한다.
//   gen:i18n(사내 서버 의존) 정적 번들에 의존하지 않는다.
// SCM_ADM_MSG_M 메시지에는 개행/탭이 리터럴 이스케이프("\n","\r","\t")로 저장돼 있다(AS-IS 관행
//   — 예: MSG01261 "...입니다 .\n\rUser ID : {0}", MSG00457/MSG01067/MSG01124 등 다수). i18next 는
//   이를 그대로 반환하고 알림창(CustomDialogContent white-space:pre-line)은 실제 개행만 줄바꿈하므로,
//   그대로 두면 "\n\r" 이 글자 그대로 노출된다. 로드 시 실제 제어문자로 되돌린다("\r\n"/"\n\r"
//   조합은 단일 개행으로 합침). 이스케이프가 없는 메시지는 무변경.
const unescapeControlChars = (s: string): string =>
  s.replace(/\\r\\n|\\n\\r|\\n|\\r/g, '\n').replace(/\\t/g, '\t');

const loadDbMessages = (
  url: string,
  onLoaded: (error: unknown, response: { status: number; data: string }) => void
): void => {
  apiClient
    .get<DbMessage[]>(url)
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
    // 정적 파일 경로 대신 DB 엔드포인트에서 로드한다. loadPath 의 {{lng}} 는 i18next 가 로드 중인
    //   언어로 치환돼 url 로 들어오고(단일 언어 로드), request 가 그 url 그대로 조회한다
    //   (응답을 {messageId: text} 맵으로 가공). 언어를 명시해 보내는 것이 desync 방지의 핵심이다.
    loadPath: 'admin/message?langCd={{lng}}',
    request: (
      _options: unknown,
      url: string,
      _payload: unknown,
      callback: (error: unknown, response: { status: number; data: string }) => void
    ) => loadDbMessages(url, callback),
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
