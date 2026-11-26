# -*- coding: utf-8 -*-
"""TO-BE 실측 녹화 — Playwright 실행 기록(trace.zip)의 화면 장면(screencast)을 GIF 1개로 묶는다 (2026-11-20 사용자 지시 '녹화')
   Playwright 동영상 녹화는 전용 ffmpeg(ms-playwright/ffmpeg-*) 가 필요한데 이 PC 에 없고 받으려면 외부 다운로드가 필요하다.
   실행 기록은 ffmpeg 없이 장면(jpeg)을 저장하므로 그 장면을 시각 순서로 이어 GIF 로 만든다(장면 사이 실제 간격 · 최대 2초).

  python tools/E2E/trace_gif.py <폴더>     폴더 안 *.zip(실행 기록)마다 같은 이름 .gif 를 만든다
  python tools/E2E/trace_gif.py --selftest
"""
import glob
import io
import json
import os
import re
import sys
import zipfile


def frames_of(zp):
    """[(시각 ms, jpeg bytes)] — trace 안 screencast-frame 이벤트 순서"""
    out = []
    with zipfile.ZipFile(zp) as z:
        names = set(z.namelist())
        for n in sorted(x for x in names if x.endswith('.trace')):
            for ln in z.read(n).decode('utf-8', 'replace').splitlines():
                if '"screencast-frame"' not in ln:
                    continue
                try:
                    e = json.loads(ln)
                except ValueError:
                    continue
                sha = e.get('sha1') or ''
                key = next((k for k in (e.get('file') or '', f'resources/{sha}', sha) if k and k in names), None)   # 형식 v10 = file(screencast/page@….jpeg) · 옛 형식 = sha1
                if key:
                    out.append((float(e.get('timestamp') or 0), z.read(key)))
    out.sort(key=lambda x: x[0])
    return out


def make_gif(zp, out=None, width=1280):
    from PIL import Image
    fr = frames_of(zp)
    if not fr:
        return None, 0
    ims, durs = [], []
    for i, (t, b) in enumerate(fr):
        im = Image.open(io.BytesIO(b)).convert('RGB')
        if im.width > width:
            im = im.resize((width, int(im.height * width / im.width)))
        ims.append(im)
        nxt = fr[i + 1][0] if i + 1 < len(fr) else t + 1000
        durs.append(int(min(2000, max(100, nxt - t))))
    W = max(i.width for i in ims); H = max(i.height for i in ims)
    pal = []
    for im in ims:
        c = Image.new('RGB', (W, H), (60, 60, 60)); c.paste(im, (0, 0)); pal.append(c.convert('P', palette=Image.ADAPTIVE, colors=128))
    out = out or re.sub(r'\.zip$', '.gif', zp, flags=re.I)
    pal[0].save(out, save_all=True, append_images=pal[1:], duration=durs, loop=0)
    return out, len(pal)


def main():
    a = sys.argv[1:]
    if a and a[0] == '--selftest':
        ok = re.sub(r'\.zip$', '.gif', 'x/a.ZIP', flags=re.I) == 'x/a.gif'
        print('SELFTEST ' + ('OK' if ok else 'FAIL')); return 0 if ok else 1
    if not a:
        print(__doc__); return 2
    n = 0
    for zp in sorted(glob.glob(os.path.join(a[0], '*.zip'))):
        try:
            g, k = make_gif(zp)
            if g:
                n += 1; print(f'[TO-BE 녹화] {os.path.basename(g)} 장면 {k}')
            else:
                print(f'[TO-BE 녹화] {os.path.basename(zp)} 장면 없음')
        except Exception as e:
            print(f'[WARN] {os.path.basename(zp)} GIF 실패: {e}')
    print(f'[TO-BE 녹화] GIF {n}개 → {a[0]}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
