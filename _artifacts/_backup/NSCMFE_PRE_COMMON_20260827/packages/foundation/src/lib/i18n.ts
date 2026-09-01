import i18nOrigin from 'i18next';
import type { InitOptions } from 'i18next';
import HttpApi from 'i18next-http-backend';
import { initReactI18next } from 'react-i18next';

export { t } from 'i18next';
export { I18nextProvider, useTranslation } from 'react-i18next';

export const supportedLngs = ['KO', 'EN', 'CN'];

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
    loadPath: '/locales/{{lng}}.json',
    // version: Date.now(), // 초기 로드 시점의 타임스탬프
  },

  // 리소스가 로드되지 않았을 때 서스펜스를 사용할지 여부
  react: {
    useSuspense: true,
  },
};

void i18nOrigin.use(HttpApi).use(initReactI18next).init(commonI18nConfig);

export const i18n = i18nOrigin;
