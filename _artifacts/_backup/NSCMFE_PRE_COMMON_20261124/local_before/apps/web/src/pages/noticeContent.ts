import { API_CONFIG } from '@foundation/constants';

/**
 * 공지 내용 HTML 정화 · 이미지 URL 유틸.
 * ⚠️ 보안 정책은 관리자 공지관리(features/admin notice-setup.util.ts)와 동일해야 한다.
 * apps/web 는 admin 피처를 프로젝트 참조하지 않아(@admin import 시 rootDir 위반) 여기 미러링한다.
 */

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

const isSafeLink = (href: string) => {
  try {
    const baseUrl = globalThis.location?.origin ?? 'https://localhost';
    const url = new URL(href, baseUrl);
    return ['http:', 'https:', 'mailto:'].includes(url.protocol);
  } catch {
    return false;
  }
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

/**
 * 목록 요약용 — 내용 HTML 에서 태그를 걷어낸 한 줄 텍스트.
 * template 에 넣은 HTML 은 비활성 문서라 스크립트·리소스가 실행/요청되지 않는다(sanitize 와 동일).
 */
export const getNoticeTextPreview = (html?: string | null) => {
  if (!html) return '';

  if (!globalThis.document) {
    return html
      .replace(/<[^>]*>/g, ' ')
      .replace(/\s+/g, ' ')
      .trim();
  }

  const template = globalThis.document.createElement('template');
  template.innerHTML = html;
  return (template.content.textContent ?? '').replace(/\s+/g, ' ').trim();
};

export const getSafeNoticeImageSource = (fileId?: string | null) => {
  const value = fileId?.trim() ?? '';
  if (!value) return '';

  const baseUrl = String(API_CONFIG.BASE_URL ?? '').replace(/\/$/, '');
  return `${baseUrl}/file/image/${encodeURIComponent(value)}`;
};
