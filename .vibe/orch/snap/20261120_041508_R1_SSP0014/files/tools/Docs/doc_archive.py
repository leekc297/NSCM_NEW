"""버전 문서 공용 — 다음 버전 번호 · 이전 버전 old/ 이동 (2026-10-28 사용자 요청)

사용자 요청(10-28): 문서 생성 시 신규 버전을 만들면 같은 UI 의 이전 버전 문서는 그 폴더의 old 폴더로 옮긴다(old 없으면 만든다).
  같은 UI·같은 문서 = 파일명 접두 '{ID}_{화면명}_{문서종류}' 가 정확히 같은 것(ID 만으로 맞추면 DMF0003 ↔ DMF0003_1 같은 별개 화면이 섞인다)
  버전 번호는 old/ 까지 포함해 센다(옮긴 뒤 v1 로 되돌아가지 않게).
  쓰는 곳: tools/Docs/make_docs.py · tools/Docs/make_testcases.py · tools/Harness/verify/make_verify_docs.py
"""
import glob, os, re, shutil

OLD = 'old'
VER = re.compile(r'_v(\d+)(?:\.\d+)?(?:_\d{8})?\.xlsx$')


def _files(folders, prefix):
    out = []
    for d in folders:
        for sub in ('', OLD):
            out += glob.glob(os.path.join(d, sub, glob.escape(prefix) + '_v*.xlsx'))
    return [f for f in out if VER.search(os.path.basename(f)) and os.path.basename(f).startswith(prefix + '_v')]


def next_version(folder, prefix, also=()):
    """folder(+ old/) 와 also 폴더(이전 위치, + old/)에서 prefix_v<N> 의 최대 N + 1"""
    os.makedirs(folder, exist_ok=True)
    return max([0] + [int(VER.search(os.path.basename(f)).group(1)) for f in _files([folder, *also], prefix)]) + 1


def archive_previous(new_path):
    """new_path 와 같은 폴더·같은 접두의 다른 버전 파일을 <폴더>/old/ 로 옮긴다. 반환 = 옮긴 파일 목록"""
    folder, base = os.path.split(os.path.abspath(new_path))
    m = VER.search(base)
    if not m:
        return []
    prefix = base[:m.start()]
    od = os.path.join(folder, OLD)
    moved = []
    for f in glob.glob(os.path.join(folder, glob.escape(prefix) + '_v*.xlsx')):
        b = os.path.basename(f)
        if os.path.abspath(f) == os.path.abspath(new_path) or not VER.search(b) or not b.startswith(prefix + '_v') or b.startswith('~$'):
            continue
        os.makedirs(od, exist_ok=True)
        dst = os.path.join(od, b)
        k = 1
        while os.path.exists(dst):  # old 에 같은 이름이 이미 있으면 덮어쓰지 않는다
            dst = os.path.join(od, f'{b[:-5]}_dup{k}.xlsx'); k += 1
        try:
            shutil.move(f, dst); moved.append(dst)
        except OSError as ex:  # Excel 로 열려 있는 파일 등 — 옮기지 못한 것은 알린다(새 문서 생성은 유지)
            print(f'  [WARN] 이전 버전 이동 실패(열려 있음?): {b} — {ex}')
    if moved:
        print(f"  이전 버전 {len(moved)}개 → {od}: {', '.join(os.path.basename(x) for x in moved[:6])}{' …' if len(moved) > 6 else ''}")
    return moved


def all_versions(pattern_dirs, pattern):
    """사용자 의견 누적처럼 이전 버전까지 읽어야 하는 곳 — 폴더들(+ old/)의 glob 결과(중복 제거)"""
    out = []
    for d in pattern_dirs:
        for sub in ('', OLD):
            out += glob.glob(os.path.join(d, sub, pattern))
    return sorted(set(out))
