import 'i18next';
import { commonI18nConfig } from '../i18n';

declare global {
  type TResource = typeof import('../../public/locales/ko.json')
  type translation = keyof TResource;
}

declare module 'i18next' {

  interface CustomTypeOptions {
    defaultNS: 'translation';
    resources: {
      translation: TResource;
    };
  }
}
