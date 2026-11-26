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
  'img',
  'li',
  'ol',
  'p',
  'span',
  'strong',
  'u',
  'ul',
]);

const ALLOWED_NOTICE_FORMATS = new Set(['p', 'h1', 'h2']);
// 2026-09-16 - 굵게/기울임/밑줄 토글용 커스텀 span 속성.
const ALLOWED_NOTICE_STYLE_ATTRIBUTES = new Set([
  'data-notice-bold',
  'data-notice-italic',
  'data-notice-underline',
]);
const ALLOWED_NOTICE_STYLE_VALUES = new Set(['on', 'off']);
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
  // 2026-09-11 사용자 요구 - 신규 등록 시 Active 기본값 Y
  ACTIVE: 'Y',
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

export const getSafeNoticeImageSource = (fileId?: string | null) => {
  const value = fileId?.trim() ?? '';
  if (!value) return '';

  const baseUrl = String(API_CONFIG.BASE_URL ?? '').replace(/\/$/, '');
  return `${baseUrl}/file/image/${encodeURIComponent(value)}`;
};

// 첨부파일 다운로드 URL. 엔드포인트가 Content-Disposition: attachment 로 내려주므로 <a> 로 바로 받는다.
export const getAttachmentDownloadUrl = (fileId?: string | null) => {
  const value = fileId?.trim() ?? '';
  if (!value) return '';

  const baseUrl = String(API_CONFIG.BASE_URL ?? '').replace(/\/$/, '');
  return `${baseUrl}/file/download/${encodeURIComponent(value)}`;
};

// byte 크기를 사람이 읽는 단위로 표기한다.
export const formatFileSize = (bytes?: number) => {
  const value = typeof bytes === 'number' && bytes > 0 ? bytes : 0;
  const units = ['B', 'KB', 'MB', 'GB'];
  let size = value;
  let unitIndex = 0;
  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex += 1;
  }
  const rounded = unitIndex === 0 ? size : Math.round(size * 10) / 10;
  return `${rounded} ${units[unitIndex]}`;
};

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
      const isAllowedStyleAttribute =
        tagName === 'span' &&
        ALLOWED_NOTICE_STYLE_ATTRIBUTES.has(attribute.name.toLowerCase()) &&
        ALLOWED_NOTICE_STYLE_VALUES.has(attribute.value);
      const isAllowedImageAttribute =
        tagName === 'img' &&
        ['data-notice-image', 'alt'].includes(attribute.name.toLowerCase());
      if (
        !isAllowedLinkAttribute &&
        !isAllowedFormatAttribute &&
        !isAllowedStyleAttribute &&
        !isAllowedImageAttribute
      ) {
        element.removeAttribute(attribute.name);
      }
    });

    if (tagName === 'a') {
      const href = element.getAttribute('href') ?? '';
      if (!isSafeLink(href)) element.removeAttribute('href');
      element.setAttribute('target', '_blank');
      element.setAttribute('rel', 'noreferrer noopener');
    }

    if (tagName === 'img') {
      const fileId = element.getAttribute('data-notice-image')?.trim() ?? '';
      // src 는 HTML 값을 신뢰하지 않고 fileId 로만 재조립한다(XSS/외부 URL 차단).
      if (!fileId) {
        element.remove();
        return;
      }
      element.setAttribute('src', getSafeNoticeImageSource(fileId));
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

export const getClipboardImageFile = (clipboardData: DataTransfer | null): File | null => {
  if (!clipboardData) return null;
  const files = Array.from(clipboardData.files ?? []);
  return files.find(file => file.type.startsWith('image/')) ?? null;
};

export const createNoticeImageElement = (fileId: string, fileName?: string): HTMLImageElement => {
  const img = globalThis.document.createElement('img');
  img.setAttribute('data-notice-image', fileId);
  if (fileName) img.setAttribute('alt', fileName);
  img.setAttribute('src', getSafeNoticeImageSource(fileId));
  return img;
};
