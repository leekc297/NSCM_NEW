"""정합검증 최신 여부 확인 → 최신이 아니면 정합검증 실행 (2026-10-28)

사용자 요청(10-28): 자동 보완 시 정합검증이 최신이 아니면 정합검증을 먼저 진행한 뒤 보완한다.
  Vibe_Manager '보완' 카테고리 메뉴(🛠️·🧯·🚒·🩹·🔗) 체인 첫 단계 = 이 스크립트(S8.verifyIfStale). 보완은 그 결과의 조치 필요(fixlist.csv action_needed=Y)를 일괄 대상으로 삼는다.

최신 = 직전 정합검증 시작 시각(Doc/verify/<ID>/prereq.json generated · 없으면 verify_ledger.csv 시각) 이후 아래가 하나도 바뀌지 않았고, 그 실행이 문서까지 끝났음(fixlist.csv 가 그보다 나중)
  · 화면 FE 폴더 소스(nscm-fe/features/*/src/pages/<화면>)
  · 화면이 부르는 PKG 의 LAST_DDL_TIME(SCM_ADM_MNU_BTN_MPG_M → SCM_ADM_API_M.API_URL 의 패키지)
  · 화면 메타 LAST_UPDATE_DATE(SCM_MST_SHEET_COLUMNS · SCM_ADM_MNU_BTN_MPG_M · SCM_ADM_MNU_M)
  DB 시각을 읽지 못하면 최신으로 단정하지 않는다(= 정합검증 실행)

  python tools/Harness/verify/verify_if_stale.py <MENU_ID> [--skip-e2e] [--check]   (--check = 판정만, 실행 안 함 · rc 0 최신 / 10 최신 아님)
"""
import datetime, json, os, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from prereq import page_dir, newest  # noqa: E402

DBQ = [
    ('PKG DDL', """SELECT MAX(O.LAST_DDL_TIME) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID = B.API_ID
                  JOIN ALL_OBJECTS O ON O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = REGEXP_SUBSTR(A.API_URL, '^[^.]+') WHERE B.MNU_ID = :m"""),
    ('시트 컬럼 메타', "SELECT MAX(LAST_UPDATE_DATE) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = :m"),
    ('버튼·API 매핑 메타', "SELECT MAX(LAST_UPDATE_DATE) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = :m"),
    ('메뉴 메타', "SELECT MAX(LAST_UPDATE_DATE) FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID = :m"),
]


def ts(t):
    return datetime.datetime.fromtimestamp(t).strftime('%m-%d %H:%M:%S') if t else '-'


def checklist_dir():
    """개선안 20261124012048_SELF(R83): CheckList 폴더 = harness.json paths.checklistDir 1곳(make_verify_docs 와 같은 값) · 없으면 Doc/UI_CHECKLIST"""
    try:
        with open(os.path.join(ROOT, 'tools', 'Harness', 'harness.json'), encoding='utf-8-sig') as f:
            hp = (json.load(f) or {}).get('paths')
    except (OSError, ValueError):
        hp = None
    d = (hp.get('checklistDir') if isinstance(hp, dict) else None) or 'Doc/UI_CHECKLIST'
    return os.path.normpath(d if os.path.isabs(d) else os.path.join(ROOT, d))


def asis_of(mid):
    """AS-IS 화면 ID(run_verify.asis_of 와 같은 map_screen.csv) · 없으면 같은 ID"""
    import csv
    try:
        with open(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'map_screen.csv'), encoding='utf-8-sig', newline='') as f:
            for r in csv.DictReader(f):
                if (r.get('tobe_id') or '').upper() == mid and r.get('asis_id'):
                    return r['asis_id'].upper()
    except OSError:
        pass
    return mid


def file_changes(mid, done_at):
    """2026-11-18 사용자 지시: DB·FE 밖의 판정 입력이 직전 CheckList 뒤에 바뀌었는지.
    기준 시각 done_at = fixlist.csv 시각(문서 단계 끝). 체인 안에서 쓰는 사실 파일은 그보다 앞서 쓰여 걸리지 않는다.
      ① 사용자 판정(_user_verdicts_direct.csv) 이 화면 행 = 원장 결과와 다르면 반영 전(날짜만 있는 파일이라 시각 대신 내용 대조)
      ② 정적 판정(static_verdicts.csv) 수정 시각
      ③ CheckList Excel 을 문서 생성 뒤 저장(사용자의견 열 입력)
      ④ AS-IS 파싱 결과(Doc/asisfacts/screens/<AS-IS ID>) 수정 시각"""
    import csv, glob
    vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    why = []
    try:
        with open(os.path.join(vd, 'verify_ledger.csv'), encoding='utf-8-sig', newline='') as f:
            led = {r['row_id']: (r.get('result') or '').strip() for r in csv.DictReader(f)}
        with open(os.path.join(ROOT, 'Doc', 'verify', '_user_verdicts_direct.csv'), encoding='utf-8-sig', newline='') as f:
            diff = [r['row_id'] for r in csv.DictReader(f)
                    if (r.get('menu_id') or '').strip().upper() == mid and r.get('row_id') in led
                    and led[r['row_id']] != (r.get('verdict') or '').strip()]
        if diff:
            why.append(f"사용자 판정 {len(diff)}건 원장 미반영({', '.join(diff[:5])}{' 외' if len(diff) > 5 else ''})")
    except OSError:
        pass
    sv = os.path.join(vd, 'static_verdicts.csv')
    if os.path.exists(sv) and os.path.getmtime(sv) > done_at:
        why.append(f'정적 판정 변경 {ts(os.path.getmtime(sv))} > CheckList {ts(done_at)}')
    xs = glob.glob(os.path.join(checklist_dir(), f'{mid}_*_CheckList_v*.xlsx'))
    if xs:
        xm = max(os.path.getmtime(x) for x in xs)
        if xm > done_at + 120:  # 문서 생성 직후 저장 여유 2분
            why.append(f'CheckList Excel 저장 {ts(xm)} > CheckList {ts(done_at)} (사용자의견 입력 반영 필요)')
    fd = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', asis_of(mid))
    fm = max((os.path.getmtime(x) for x in glob.glob(os.path.join(fd, '**', '*'), recursive=True) if os.path.isfile(x)), default=0)
    if fm > done_at:
        why.append(f'AS-IS 파싱 결과 변경 {ts(fm)} > CheckList {ts(done_at)} ({os.path.relpath(fd, ROOT)})')
    return why


def staleness(mid):
    """(최신 여부, 사유 목록)"""
    vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    fl, env_p = os.path.join(vd, 'fixlist.csv'), os.path.join(vd, 'run_verify.result.json')
    if not os.path.exists(fl):
        return False, ['CheckList 결과 없음(fixlist.csv)']
    # 기준 = run_verify 결과 봉투(시작 started · 상태 state). prereq 만 따로 돈 기록(prereq.json)은 정합검증이 아니다
    try:
        env = json.load(open(env_p, encoding='utf-8'))
    except (OSError, ValueError):
        return False, ['CheckList 결과 봉투 없음(run_verify.result.json)']
    if env.get('state') != 'completed':
        return False, [f"직전 CheckList 가 끝나지 않음(state {env.get('state')})"]
    try:
        at = datetime.datetime.strptime(env['started'], '%Y-%m-%d %H:%M:%S').timestamp()
    except (KeyError, ValueError, TypeError):  # 시작 시각 기록 전(2026-10-28 이전) 봉투 — 종료 시각 기준(보수적으로 짧게 잡지 않음)
        at = os.path.getmtime(env_p) - 3 * 3600
    why = []
    if os.path.getmtime(fl) < at:
        why.append(f'직전 CheckList 가 문서 단계까지 끝나지 않음(fixlist {ts(os.path.getmtime(fl))} < 시작 {ts(at)})')
    pdir = page_dir(mid)
    if pdir and newest(pdir) > at:
        why.append(f'FE 소스 변경 {ts(newest(pdir))} > CheckList {ts(at)} ({os.path.relpath(pdir, ROOT)})')
    why += file_changes(mid, os.path.getmtime(fl))
    try:
        from dbconn import connect
        with connect('tobe') as cx:
            cur = cx.cursor()
            for name, q in DBQ:
                cur.execute(q, {'m': mid})
                v = cur.fetchone()[0]
                if v and v.timestamp() > at:
                    why.append(f'{name} 변경 {v:%m-%d %H:%M:%S} > CheckList {ts(at)}')
    except Exception as ex:  # DB 시각을 모르면 최신으로 단정하지 않는다
        why.append(f'DB 변경 시각 확인 실패({ex}) — 최신 단정 불가')
    return not why, why


def running(mid):
    """같은 화면 정합검증이 지금 실행 중인가 — E2E 공용 잠금(Doc/e2e/_run.lock: args 'verify <ID>') + pid 생존.
    2026-10-28: 다른 세션의 정합검증 도중(원장 재생성 직후 NOT_RUN 상태)에 문서·보완을 돌려 중간 상태 정합검증서가 생긴 사고"""
    try:
        lk = json.load(open(os.path.join(ROOT, 'Doc', 'e2e', '_run.lock'), encoding='utf-8'))
    except (OSError, ValueError):
        return None
    if not str(lk.get('args', '')).upper().split()[-1:] == [mid] or 'verify' not in str(lk.get('args', '')):
        return None
    try:
        out = subprocess.run(['tasklist', '/FI', f"PID eq {int(lk.get('pid'))}", '/NH'], capture_output=True, text=True, timeout=20).stdout
        return lk if str(lk.get('pid')) in out else None
    except (OSError, ValueError, subprocess.SubprocessError):
        return lk  # 생존 확인 불가 = 실행 중으로 본다(중간 상태 사용 방지)


def main():
    a = sys.argv[1:]
    mid = next(x for x in a if not x.startswith('--')).upper()
    lk = running(mid)
    if lk:
        print(f"[BUSY] {mid} CheckList 가 이미 실행 중(실행 ID {lk.get('runId')} · 시작 {lk.get('started')}) — 새로 돌리지 않음. 끝난 뒤 다시 실행하거나, 보완은 직전 완료 결과(fixlist.csv)로 진행")
        return 4
    fresh, why = staleness(mid)
    if fresh:
        print(f'[OK] {mid} CheckList 최신 — 다시 실행하지 않음 (Doc/verify/{mid}/fixlist.csv 의 action_needed=Y 가 보완 대상)')
        return 0
    print(f'[STALE] {mid} CheckList 최신 아님: ' + ' · '.join(why))
    if '--check' in a:
        return 10
    print(f'→ CheckList 실행: run_verify.py {mid}', flush=True)
    return subprocess.call([sys.executable, os.path.join(HERE, 'run_verify.py'), mid] + (['--skip-e2e'] if '--skip-e2e' in a else []), cwd=ROOT)


if __name__ == '__main__':
    sys.exit(main())
