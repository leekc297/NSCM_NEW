import { describe, expect, it } from 'vitest';

import { sanitizeNoticeHtml } from './notice-setup.util';
import { createNoticeImageElement, getClipboardImageFile } from './notice-setup.util';

const queryImg = (html: string) => {
  const tpl = document.createElement('template');
  tpl.innerHTML = html;
  return tpl.content.querySelector('img');
};

describe('sanitizeNoticeHtml - 이미지', () => {
  it('data-notice-image 가 있는 img 는 유지하고 src 를 fileId 로 재조립한다', () => {
    const out = sanitizeNoticeHtml(
      '<p>x</p><img data-notice-image="F123" src="http://evil/x" onerror="alert(1)" alt="cap">'
    );
    const img = queryImg(out);
    expect(img).not.toBeNull();
    expect(img!.getAttribute('data-notice-image')).toBe('F123');
    expect(img!.getAttribute('onerror')).toBeNull();
    expect(img!.getAttribute('alt')).toBe('cap');
    expect(img!.getAttribute('src')).toContain('/file/image/F123');
    expect(img!.getAttribute('src')).not.toContain('evil');
  });

  it('data-notice-image 가 없는 img 는 제거한다', () => {
    const out = sanitizeNoticeHtml('<img src="http://evil/x" onerror="alert(1)">');
    expect(queryImg(out)).toBeNull();
  });
});

describe('getClipboardImageFile', () => {
  const makeFile = (type: string) => new File(['x'], 'f', { type });

  it('이미지 파일이 있으면 첫 이미지 File 을 반환한다', () => {
    const data = { files: [makeFile('text/plain'), makeFile('image/png')] } as unknown as DataTransfer;
    expect(getClipboardImageFile(data)?.type).toBe('image/png');
  });

  it('이미지가 없으면 null 을 반환한다', () => {
    const data = { files: [makeFile('text/plain')] } as unknown as DataTransfer;
    expect(getClipboardImageFile(data)).toBeNull();
  });

  it('clipboardData 가 null 이면 null 을 반환한다', () => {
    expect(getClipboardImageFile(null)).toBeNull();
  });
});

describe('createNoticeImageElement', () => {
  it('data-notice-image·alt·src 를 세팅한 img 를 만든다', () => {
    const img = createNoticeImageElement('F7', 'cap.png');
    expect(img.tagName).toBe('IMG');
    expect(img.getAttribute('data-notice-image')).toBe('F7');
    expect(img.getAttribute('alt')).toBe('cap.png');
    expect(img.getAttribute('src')).toContain('/file/image/F7');
  });
});
