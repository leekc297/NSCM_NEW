import { API_CONFIG } from '@foundation/constants';

import type { NoticeSetupRow } from './notice-setup.types';

const ALLOWED_NOTICE_TAGS = new Set([
  'a',
  'b',
  'br',
  'div',
  'em',
  'h1',
  'h2',
  'h3',
  'i',
  'li',
  'ol',
  'p',
  'span',
  'strong',
  'u',
  'ul',
]);

const ALLOWED_NOTICE_FORMATS = new Set(['p', 'h1', 'h2']);
const NOTICE_DATE_PATTERN = /^\d{4}-\d{2}-\d{2}$/;

const isSafeLink = (href: string) => {
  try {
    const baseUrl = globalThis.location?.origin ?? 'https://localhost';
    const url = new URL(href, baseUrl);
    return ['http:', 'https:', 'mailto:'].includes(url.protocol);
  } catch {
    return false;
  }
};

export const createEmptyNotice = (): NoticeSetupRow => ({
  NOTICE_ID: '',
  MODULE: 'DM',
  MODULE_NM: '',
  SUB_MODULE: 'DM',
  SUB_MODULE_NM: '',
  NOTICE: '',
  ACTIVE: 'N',
  START_DATE: '',
  END_DATE: '',
  PUBLICATION_PERIOD: '',
  POPUP_YN: 'Y',
  NOTICE_TITLE: '',
  NOTICE_CONTENT: '',
  NOTICE_IMAGE: '',
  IMAGE_FILE_NM: '',
  CREATED_BY: '',
  CREATION_DATE: '',
  ACTION: '',
});

export const sanitizeNoticeHtml = (html?: string | null) => {
  if (!html) return '';
  if (!globalThis.document) return html;

  const template = globalThis.document.createElement('template');
  template.innerHTML = html;

  Array.from(template.content.querySelectorAll('*')).forEach(element => {
    const tagName = element.tagName.toLowerCase();

    if (!ALLOWED_NOTICE_TAGS.has(tagName)) {
      element.replaceWith(...Array.from(element.childNodes));
      return;
    }

    Array.from(element.attributes).forEach(attribute => {
      const isAllowedLinkAttribute =
        tagName === 'a' && ['href', 'target', 'rel'].includes(attribute.name.toLowerCase());
      const isAllowedFormatAttribute =
        tagName === 'span' &&
        attribute.name.toLowerCase() === 'data-notice-format' &&
        ALLOWED_NOTICE_FORMATS.has(attribute.value);
      if (!isAllowedLinkAttribute && !isAllowedFormatAttribute) {
        element.removeAttribute(attribute.name);
      }
    });

    if (tagName === 'a') {
      const href = element.getAttribute('href') ?? '';
      if (!isSafeLink(href)) element.removeAttribute('href');
      element.setAttribute('target', '_blank');
      element.setAttribute('rel', 'noreferrer noopener');
    }
  });

  return template.innerHTML;
};

export const getNoticePlainText = (html?: string | null) => {
  if (!html) return '';
  if (!globalThis.document) return html.replace(/<[^>]*>/g, ' ');
  const container = globalThis.document.createElement('div');
  container.innerHTML = sanitizeNoticeHtml(html);
  return container.textContent ?? '';
};

export const getSafeNoticeImageSource = (fileId?: string | null) => {
  const value = fileId?.trim() ?? '';
  if (!value) return '';

  const baseUrl = String(API_CONFIG.BASE_URL ?? '').replace(/\/$/, '');
  return `${baseUrl}/file/image/${encodeURIComponent(value)}`;
};
