"""다국어 JSON 재생성 — `pnpm gen` 과 같은 내용을 pnpm 없이 실행 (로컬 전용, 2026-10-28 사용자 요청)

  pnpm gen = gen:icons(node scripts/generate-icons.mjs) && gen:i18n(node scripts/sync-i18n.mjs)   (nscm-fe/package.json)
  로컬 전용: 메시지 원천 = 로컬 BE http://127.0.0.1:8080/admin/message 만.
    sync-i18n.mjs 는 로컬 실패 시 구주소로 넘어가고, KO.json 이 없으면 목데이터로 locales 를 덮어쓴다(2026-08-13 실사고 계보).
    → 먼저 로컬 BE 가 메시지를 돌려주는지 확인하고(아니면 아무것도 바꾸지 않고 중단), NSCM_I18N_API 를 로컬로 지정해 실행한다.
  산출: nscm-fe/public/locales/{KO,EN,CN}.json · nscm-fe/configs/types/generated-keys.d.ts · 아이콘 생성물 — 전후 키 수를 보고

  python tools/Env/fe_gen_i18n.py
"""
import json, os, subprocess, sys, urllib.request

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
FE = os.path.join(ROOT, 'nscm-fe')
LOCAL = 'http://127.0.0.1:8080/admin/message'
LOC = os.path.join(FE, 'public', 'locales')


def keys():
    out = {}
    for lang in ('KO', 'EN', 'CN'):
        p = os.path.join(LOC, f'{lang}.json')
        try:
            out[lang] = len(json.load(open(p, encoding='utf-8')))
        except (OSError, ValueError):
            out[lang] = None
    return out


def main():
    print(f'== 다국어 JSON 재생성 (pnpm gen 내용 · 로컬 전용) — {FE}', flush=True)
    try:
        with urllib.request.urlopen(LOCAL, timeout=60) as r:
            n = len((json.loads(r.read().decode('utf-8')) or {}).get('result') or [])
    except Exception as ex:
        print(f'[FAIL] 로컬 BE 메시지 API 응답 없음({LOCAL}: {ex}) — 로컬 BE 기동 후 다시 실행. 아무 파일도 바꾸지 않았습니다')
        return 5
    if n <= 0:
        print(f'[FAIL] 로컬 BE 메시지 0건({LOCAL}) — 목데이터 덮어쓰기를 막기 위해 중단. 아무 파일도 바꾸지 않았습니다')
        return 5
    before = keys()
    print(f'로컬 메시지 {n}건 확인 · 실행 전 키 수 {before}', flush=True)
    for name, script in (('gen:icons', 'scripts/generate-icons.mjs'), ('gen:i18n', 'scripts/sync-i18n.mjs')):
        print(f'\n$ node {script}   ({name})', flush=True)
        rc = subprocess.call(['node', script], cwd=FE, env=dict(os.environ, NSCM_I18N_API=LOCAL))
        if rc:
            print(f'[FAIL] {name} 종료코드 {rc} — 중단 (실행 전 키 수 {before} · 현재 {keys()})')
            return rc
    after = keys()
    bad = [l for l, v in after.items() if not v or v < 100]
    print(f'\n실행 후 키 수 {after} (실행 전 {before})')
    if bad:
        print(f'[FAIL] {", ".join(bad)} 키 수 비정상(없음 또는 100 미만 — 목데이터 의심) — public/locales 확인')
        return 3
    print('[OK] 다국어 JSON 재생성 완료 — 화면 새로고침으로 반영(FE dev 서버 재기동 불필요)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
