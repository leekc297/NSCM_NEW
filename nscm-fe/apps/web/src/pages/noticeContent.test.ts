import { describe, expect, it } from 'vitest';

import { sanitizeNoticeHtml } from './noticeContent';

const queryImg = (html: string) => {
  const tpl = document.createElement('template');
  tpl.innerHTML = html;
  return tpl.content.querySelector('img');
};

describe('noticeContent sanitizeNoticeHtml - 이미지', () => {
  it('data-notice-image 가 있는 img 는 유지하고 src 를 fileId 로 재조립한다', () => {
    const out = sanitizeNoticeHtml('<img data-notice-image="F9" src="http://evil/x" onerror="x()">');
    const img = queryImg(out);
    expect(img).not.toBeNull();
    expect(img!.getAttribute('data-notice-image')).toBe('F9');
    expect(img!.getAttribute('onerror')).toBeNull();
    expect(img!.getAttribute('src')).toContain('/file/image/F9');
    expect(img!.getAttribute('src')).not.toContain('evil');
  });

  it('data-notice-image 가 없는 img 는 제거한다', () => {
    expect(queryImg(sanitizeNoticeHtml('<img src="http://evil/x">'))).toBeNull();
  });
});
