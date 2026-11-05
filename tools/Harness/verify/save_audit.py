"""F8 감사 필드 · F7 저장 연계 테이블 정적 판정 — CRUD 실제 저장(E2E) 이 남긴 행의 정리 백업으로 판정 (2026-10-27)

사용자 요청(10-27): 단위테스트 두 시트 오류(예: SYS0012 Reject Reason·Request Date 파생 필드 · 저장 연계)가 다른 화면에 같은 형태로 있으면 찾아야 한다.
  F7·F8 은 검사기가 없어 모든 화면에서 '검사기 없음'으로 지나갔다.

원천
  TO-BE : cleanup_marker.py 가 E2E 마커 행을 지우기 전에 남긴 백업 Doc/verify/<ID>/cleanup/<시각>_<테이블>.csv + cleanup_<시각>.sql(계정·생성 시각 기준)
          = 화면 저장 1회가 실제로 기록한 테이블·행(루트 + 연쇄)
  AS-IS : 저장 SP 원문 Doc/asisfacts/db/modules/dbo.<SAVE SP>.sql 의 DML 대상 테이블(MERGE/INSERT = 신규행 저장 경로 · UPDATE/DELETE 만 = 기존행 경로)
          저장 SP = Doc/golden/golden_cases.csv kind=SAVE 의 asis_sp
판정
  F8  루트 행 CREATED_BY · LAST_UPDATED_BY = 저장 계정 · CREATION_DATE · LAST_UPDATE_DATE = 저장 시각(정리 SQL 기준 시각 ±10분) — 감사 컬럼 없으면 NA
  F7  AS-IS 저장 SP 가 신규행 경로(MERGE/INSERT)로 쓰는 업무 테이블마다 TO-BE 저장이 행을 남겼는지 — 없으면 FAIL
      로그 테이블(이름에 LOG)·임시(#·@) 제외 · UPDATE 만 하는 테이블은 신규행 1건 시험의 대상 아님(NA 메모) · TO-BE 에만 기록한 테이블은 참고(판정 영향 없음)

  python save_audit.py <MENU_ID>   → Doc/verify/<ID>/save_audit.json
"""
import csv, datetime, glob, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
AUDIT = ('CREATED_BY', 'CREATION_DATE', 'LAST_UPDATED_BY', 'LAST_UPDATE_DATE')


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))


def asis_targets(sp):
    p = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules', f'dbo.{sp}.sql')
    if not os.path.exists(p):
        return None
    ins, upd = set(), set()
    for line in open(p, encoding='utf-8', errors='ignore'):
        code = line.split('--')[0]
        for kind, t in re.findall(r'(?i)\b(MERGE\s+INTO|INSERT\s+INTO|UPDATE|DELETE\s+FROM)\s+(?:\[?dbo\]?\.)?\[?([A-Za-z_][\w]*)\]?', code):
            t = t.upper()
            if t.startswith(('#', '@')) or 'LOG' in t or t in ('SET', 'TOP'):
                continue
            (ins if re.match(r'(?i)(MERGE|INSERT)', kind) else upd).add(t)
    return ins, upd - ins


def main():
    mid = sys.argv[1].upper()
    out = os.path.join(ROOT, 'Doc', 'verify', mid, 'save_audit.json')
    sqls = sorted(glob.glob(os.path.join(ROOT, 'Doc', 'verify', mid, 'cleanup', 'cleanup_*.sql')))
    res = {'menu_id': mid, 'generated': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'F8': None, 'F7': None}
    if not sqls:
        res['F8'] = res['F7'] = {'verdict': 'NOT_RUN', 'note': 'CRUD 실제 저장 정리 기록 없음(E2E 저장 미실행)'}
        json.dump(res, open(out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        print(f"{mid}: 저장 정리 기록 없음 — F7/F8 NOT_RUN")
        return
    # 가장 최근 '백업 1건 이상' 정리 실행
    for sp in reversed(sqls):
        ts = os.path.basename(sp)[8:-4]
        backs = {os.path.basename(b)[len(ts) + 1:-4]: read_csv(b) for b in glob.glob(os.path.join(os.path.dirname(sp), f'{ts}_*.csv'))}
        if any(backs.values()):
            break
    head = open(sp, encoding='utf-8', errors='ignore').read()
    user = (re.search(r'계정 (\S+)', head) or [None, ''])[1]
    if not user:  # 정리 SQL 머리글에 계정이 없으면 E2E 기본 계정 — 빈 값과 비교하면 정상 계정이 '불일치' 로 나온다(2026-11-02 SCP0028 허위 F8)
        try:
            user = json.load(open(os.path.join(ROOT, 'tools', 'E2E', 'e2e.config.json'), encoding='utf-8-sig')).get('defaultAccount', '')
        except (OSError, ValueError):
            user = ''
    t0 = re.search(r"TO_DATE\('(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)'", head)
    t0 = datetime.datetime.strptime(t0.group(1), '%Y-%m-%d %H:%M:%S') if t0 else None
    spec = json.load(open(os.path.join(HERE, 'cleanup_spec.json'), encoding='utf-8')).get(mid, {})
    root_t = (spec.get('root') or {}).get('table') or next((t for t, v in backs.items() if v), '')
    root = backs.get(root_t) or []
    res['run'] = {'cleanup_sql': os.path.relpath(sp, ROOT), 'account': user, 'saved_at': t0.strftime('%Y-%m-%d %H:%M:%S') if t0 else '',
                  'tables': {t: len(v) for t, v in backs.items()}}
    # F8
    if not user:
        res['F8'] = {'verdict': 'NOT_RUN', 'note': '저장 계정을 알 수 없음(정리 SQL 머리글·e2e.config 모두 없음)'}
    elif not root:
        res['F8'] = {'verdict': 'NOT_RUN', 'note': f'루트 테이블 {root_t} 백업 행 없음'}
    elif not any(c in root[0] for c in AUDIT):
        res['F8'] = {'verdict': 'NA', 'note': f'{root_t} 에 감사 컬럼 없음'}
    else:
        bad = []
        for r in root:
            for c in ('CREATED_BY', 'LAST_UPDATED_BY'):
                if c in r and (r[c] or '').lower() != user.lower():
                    bad.append(f"{c}='{r[c]}' ≠ 저장 계정 '{user}'")
            for c in ('CREATION_DATE', 'LAST_UPDATE_DATE'):
                if c in r:
                    try:
                        v = datetime.datetime.strptime(r[c][:19], '%Y-%m-%d %H:%M:%S')
                        if t0 and abs((v - t0).total_seconds()) > 600:
                            bad.append(f"{c}={r[c]} ≠ 저장 시각 {t0:%Y-%m-%d %H:%M}")
                    except ValueError:
                        bad.append(f"{c}='{r[c]}' 날짜 아님/공란")
        vals = ' · '.join(f"{c}={root[0].get(c, '')}" for c in AUDIT if c in root[0])
        res['F8'] = {'verdict': 'FAIL' if bad else 'PASS', 'note': ('; '.join(dict.fromkeys(bad)) if bad else f"감사 컬럼 = 저장 계정·저장 시각 ({vals})") + f" · {root_t} {len(root)}행"}
    # F7
    sys.path.insert(0, HERE); from asis_live import live_golden, asis_of
    asis = asis_of(mid, sys.argv[sys.argv.index('--asis') + 1] if '--asis' in sys.argv else '')
    save_sp = next((g['asis_sp'] for g in live_golden(mid, asis, 'SAVE')), '')  # 실행되지 않는 AS-IS 메서드의 저장 SP 제외(2026-10-30 SCP0041)
    tg = asis_targets(save_sp) if save_sp else None
    if not tg:
        res['F7'] = {'verdict': 'NA' if not save_sp else 'NOT_RUN', 'note': '저장 SP 없음' if not save_sp else f'AS-IS 저장 SP 원문 없음({save_sp})'}
    else:
        ins, upd_only = tg
        wrote = {t for t, v in backs.items() if v}
        miss = sorted(t for t in ins if t not in wrote)
        extra = sorted(t for t in wrote if t not in ins | upd_only)
        res['F7'] = {'verdict': 'FAIL' if miss else 'PASS', 'asis_sp': save_sp, 'asis_insert_tables': sorted(ins), 'asis_update_only': sorted(upd_only),
                     'tobe_written': sorted(wrote), 'tobe_extra': extra,
                     'note': (f"AS-IS {save_sp} 신규행 경로 기록 테이블 {', '.join(miss)} 에 TO-BE 저장이 행을 남기지 않음" if miss else
                              f"AS-IS 신규행 경로 테이블 {', '.join(sorted(ins))} 모두 기록")
                             + (f" · UPDATE 만(신규 1건 시험 대상 아님): {', '.join(sorted(upd_only))}" if upd_only else '')
                             + (f" · TO-BE 에만 기록(참고 — AS-IS 트리거·다른 경로 여부 확인): {', '.join(extra)}" if extra else '')}
    json.dump(res, open(out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f"{mid}: F8 {res['F8']['verdict']} · F7 {res['F7']['verdict']} — {res['F8']['note'][:120]} | {res['F7']['note'][:200]} → {out}")


if __name__ == '__main__':
    main()
