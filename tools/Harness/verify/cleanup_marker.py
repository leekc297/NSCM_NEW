"""정합검증 CRUD 실제 저장 마커 행 정리 — 사내 DB(tobe)에서 E2E 마커 행과 그 저장이 연쇄로 만든 행을 백업 후 삭제(2026-10-24)

  python tools/Harness/verify/cleanup_marker.py <MENU_ID> [--dry-run]

정의 = tools/Harness/verify/cleanup_spec.json  { "<MENU_ID>": { "root": {...}, "children": [...] } }
  root     : {"table", "marker_col", "key_col", "creator_col", "created_col"} — 마커(E2E_ 로 시작) + 생성자(E2E 계정) + 오늘 생성 행만 대상
  children : [{"table", "key_col", "match": {"col": "root 컬럼"…}, "extra": "추가 조건 SQL(바인드 :created 사용 가능)"}] — 연쇄 생성 행
원칙(사용자 지시 2026-10-23 CRUD 실제 저장 · 기존 원장 행 무변경):
  · 대상 특정 = 마커 + 생성자 + 생성 시각(루트 행 생성 시각 이후) — 같은 키의 과거 행(예 BOD_H 9/18 타 사용자 이력)은 남긴다
  · 삭제 전 CSV 백업(Doc/verify/<ID>/cleanup/<시각>_<테이블>.csv) · 건수 단언(백업 건수 = 삭제 건수, 다르면 ROLLBACK)
  · 실행한 SQL·결과를 Doc/verify/<ID>/cleanup/cleanup_<시각>.sql 에 남긴다(사내 실행 작업 전부 SQL 기록)
"""
import csv
import datetime
import json
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect  # noqa: E402

SPEC = os.path.join(os.path.dirname(__file__), 'cleanup_spec.json')
E2E_CFG = os.path.join(ROOT, 'tools', 'E2E', 'e2e.config.json')


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if not args:
        print(__doc__)
        return 2
    mid, dry = args[0].upper(), '--dry-run' in sys.argv
    spec = json.load(open(SPEC, encoding='utf-8')).get(mid) if os.path.exists(SPEC) else None
    if not spec:
        print(f'[SKIP] {mid}: cleanup_spec.json 정의 없음 — 실제 저장 행이 생기면 정의를 추가한다')
        return 0
    cfg = json.load(open(E2E_CFG, encoding='utf-8-sig'))
    user = cfg.get('forceAccount') or cfg.get('defaultAccount')
    if spec.get('mode') == 'editonly':  # 기존행 수정·원복만 — 삭제 정리 없음(잔존은 save_residue.py)
        print(f'{mid}: editonly — 삭제 정리 대상 없음')
        return 0
    if spec.get('mode') == 'keyset':
        return keyset_cleanup(mid, spec, user, dry)
    marker = cfg.get('crudMarker', 'E2E_')
    stamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    out_dir = os.path.join(ROOT, 'Doc', 'verify', mid, 'cleanup')
    os.makedirs(out_dir, exist_ok=True)
    rt = spec['root']
    log = [f'-- 정합검증 CRUD 마커 행 정리 {mid} · {stamp} · 계정 {user} · 마커 {marker}* (cleanup_marker.py)']
    with connect('tobe') as cx:
        cur = cx.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','DB_NAME') FROM DUAL")
        log.append(f'-- 대상 DB = {cur.fetchone()[0]}')
        cur.execute(f"SELECT {rt['key_col']}, {rt['created_col']} FROM {rt['table']} WHERE {rt['marker_col']} LIKE :m || '%' "
                    f"AND {rt['creator_col']} = :u AND {rt['created_col']} >= TRUNC(SYSDATE) - 1", m=marker, u=user)
        roots = cur.fetchall()
        if not roots:
            print(f'{mid}: 정리할 마커 행 없음')
            return 0
        plan = []  # (table, where, binds)
        for key, created in roots:
            for ch in spec.get('children', []):
                w = f"{ch['key_col']} = :k AND {ch.get('created_col', 'CREATION_DATE')} >= :created" + (f" AND {ch['extra']}" if ch.get('extra') else '')
                plan.append((ch['table'], w, {'k': key, 'created': created}))
            plan.append((rt['table'], f"{rt['key_col']} = :k AND {rt['marker_col']} LIKE :m || '%' AND {rt['creator_col']} = :u",
                         {'k': key, 'm': marker, 'u': user}))
        total = 0
        try:
            for tbl, w, b in plan:
                cur.execute(f'SELECT * FROM {tbl} WHERE {w}', b)
                cols = [d[0] for d in cur.description]
                rows = cur.fetchall()
                bp = os.path.join(out_dir, f'{stamp}_{tbl}.csv')
                new = not os.path.exists(bp)
                with open(bp, 'a', encoding='utf-8-sig', newline='') as f:
                    wr = csv.writer(f)
                    if new:
                        wr.writerow(cols)
                    wr.writerows(rows)
                lit = w
                for k, v in b.items():
                    lit = lit.replace(f':{k}', f"TO_DATE('{v:%Y-%m-%d %H:%M:%S}','YYYY-MM-DD HH24:MI:SS')" if isinstance(v, datetime.datetime) else f"'{v}'")
                log.append(f'DELETE FROM {tbl} WHERE {lit};  -- 백업 {len(rows)}건')
                if not dry:
                    cur.execute(f'DELETE FROM {tbl} WHERE {w}', b)
                    if cur.rowcount != len(rows):
                        raise RuntimeError(f'{tbl}: 백업 {len(rows)}건 ≠ 삭제 {cur.rowcount}건')
                total += len(rows)
            if dry:
                cx.rollback()
            else:
                cx.commit()
                log.append('COMMIT;')
        except Exception as ex:  # noqa: BLE001 — 건수 불일치·오류 = 전체 ROLLBACK
            cx.rollback()
            log.append(f'-- ROLLBACK: {ex}')
            print(f'[FAIL] {mid} 정리 ROLLBACK — {ex}')
            open(os.path.join(out_dir, f'cleanup_{stamp}.sql'), 'w', encoding='utf-8').write('\n'.join(log) + '\n')
            return 1
        cur.execute(f"SELECT COUNT(*) FROM {rt['table']} WHERE {rt['marker_col']} LIKE :m || '%' AND {rt['creator_col']} = :u", m=marker, u=user)
        left = cur.fetchone()[0]
        log.append(f'-- 잔존 마커 행 {left}건')
    open(os.path.join(out_dir, f'cleanup_{stamp}.sql'), 'w', encoding='utf-8').write('\n'.join(log) + '\n')
    print(f"{mid}: 마커 루트 {len(roots)}건 · 정리 {total}행{' (dry-run, ROLLBACK)' if dry else ''} · 잔존 {left} → Doc/verify/{mid}/cleanup/cleanup_{stamp}.sql")
    return 0 if left == 0 or dry else 1


def keyset_cleanup(mid, spec, user, dry):
    """keyset 모드 — ledger_guard.py record 가 남긴 Doc/verify/<ID>/crud_keys.json 의 키마다
    저장 대상 테이블에서 그 키 + 저장 시각 이후 생성 행을 백업·삭제하고, 스냅샷 공유 마스터를 원래 값으로 되돌린다.
    (가드가 저장 전 그 키의 행 0건을 확인했으므로 저장 시각 이후 그 키의 행 = E2E 생성분)"""
    kp = os.path.join(ROOT, 'Doc', 'verify', mid, 'crud_keys.json')
    entries = json.load(open(kp, encoding='utf-8')) if os.path.exists(kp) else []
    if not entries:
        print(f'{mid}: 정리할 저장 키 없음(crud_keys.json)')
        return 0
    stamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    out_dir = os.path.join(ROOT, 'Doc', 'verify', mid, 'cleanup')
    os.makedirs(out_dir, exist_ok=True)
    log = [f'-- 정합검증 CRUD 저장 키 정리 {mid} · {stamp} · 계정 {user} (cleanup_marker.py keyset)']
    total, left = 0, 0
    with connect('tobe') as cx:
        cur = cx.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','DB_NAME') FROM DUAL")
        log.append(f'-- 대상 DB = {cur.fetchone()[0]}')
        try:
            for e in entries:
                since = datetime.datetime.fromisoformat(e['saved_before']) - datetime.timedelta(minutes=1)
                # 2026-11-25 T640: 키마다 저장한 계정(crud.ts 정리 위임 · 권한 계정 시험)을 남긴다 — save_audit F8 이 키별 기대 계정으로 읽는다
                log.append(f"-- 저장 키 {json.dumps(e['keys'], ensure_ascii=False)} · 계정 {e.get('account') or user} · 저장 시각 {since + datetime.timedelta(minutes=1):%Y-%m-%d %H:%M:%S}")
                kw = ' AND '.join(f'{k} = :{k}' for k in e['keys'])
                for t in spec['tables']:
                    cur.execute("SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t AND COLUMN_NAME='CREATION_DATE'", t=t)
                    has_cd = cur.fetchone()[0] > 0
                    w = kw + (' AND CREATION_DATE >= :since' if has_cd else '')
                    b = dict(e['keys'], **({'since': since} if has_cd else {}))
                    cur.execute(f'SELECT * FROM {t} WHERE {w}', b)
                    cols = [d[0] for d in cur.description]
                    rows = cur.fetchall()
                    if rows:
                        bp = os.path.join(out_dir, f'{stamp}_{t}.csv')
                        new = not os.path.exists(bp)
                        with open(bp, 'a', encoding='utf-8-sig', newline='') as f:
                            wr = csv.writer(f)
                            if new:
                                wr.writerow(cols)
                            wr.writerows(rows)
                    lit = ' AND '.join(f"{k} = '{v}'" for k, v in e['keys'].items()) + (f" AND CREATION_DATE >= TO_DATE('{since:%Y-%m-%d %H:%M:%S}','YYYY-MM-DD HH24:MI:SS')" if has_cd else '')
                    log.append(f'DELETE FROM {t} WHERE {lit};  -- 백업 {len(rows)}건')
                    if rows and not dry:
                        cur.execute(f'DELETE FROM {t} WHERE {w}', b)
                        if cur.rowcount != len(rows):
                            raise RuntimeError(f'{t}: 백업 {len(rows)}건 ≠ 삭제 {cur.rowcount}건')
                    total += len(rows)
                    # 2026-11-25 T640: 키가 다른 연쇄 행(예 SCP0005 이력 표 신규 저장 행 ROUTE_ID 0) — 마커 칸 값 + 저장 계정 + 저장 시각 이후 생성 행만(표에 세 칸이 다 있을 때)
                    mk = e.get('marker') or {}
                    if mk.get('col') and mk.get('value') and has_cd:
                        cur.execute("SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t AND COLUMN_NAME IN (:c, 'CREATED_BY')", t=t, c=mk['col'])
                        if cur.fetchone()[0] == 2:
                            mw = f"{mk['col']} LIKE :mk || '%' AND CREATED_BY = :acc AND CREATION_DATE >= :since"
                            mb = {'mk': mk['value'], 'acc': e.get('account') or user, 'since': since}
                            cur.execute(f'SELECT * FROM {t} WHERE {mw}', mb)
                            mcols = [d[0] for d in cur.description]; mrows = cur.fetchall()
                            if mrows:
                                bp = os.path.join(out_dir, f'{stamp}_{t}.csv')
                                new = not os.path.exists(bp)
                                with open(bp, 'a', encoding='utf-8-sig', newline='') as f:
                                    wr = csv.writer(f)
                                    if new:
                                        wr.writerow(mcols)
                                    wr.writerows(mrows)
                            log.append(f"DELETE FROM {t} WHERE {mk['col']} LIKE '{mk['value']}%' AND CREATED_BY = '{mb['acc']}' AND CREATION_DATE >= TO_DATE('{since:%Y-%m-%d %H:%M:%S}','YYYY-MM-DD HH24:MI:SS');  -- 마커 백업 {len(mrows)}건")
                            if mrows and not dry:
                                cur.execute(f'DELETE FROM {t} WHERE {mw}', mb)
                                if cur.rowcount != len(mrows):
                                    raise RuntimeError(f'{t}: 마커 백업 {len(mrows)}건 ≠ 삭제 {cur.rowcount}건')
                            total += len(mrows)
                for sn in e.get('snapshots', []):
                    sw = ' AND '.join(f'{k} = :{k}' for k in sn['keys'])
                    for row in sn['rows']:
                        vals = {c: (datetime.datetime.fromisoformat(v) if isinstance(v, str) and len(v) >= 19 and v[4] == '-' and 'T' in v else v) for c, v in row.items()}
                        cur.execute(f"SELECT {', '.join(vals)} FROM {sn['table']} WHERE {sw}", sn['keys'])
                        cur_row = cur.fetchone()
                        if cur_row and list(cur_row) != list(vals.values()):
                            setc = ', '.join(f'{c} = :v_{c}' for c in vals)
                            log.append(f"UPDATE {sn['table']} SET {', '.join(f'{c} = {v!r}' for c, v in row.items())} WHERE {' AND '.join(f'{k} = {v!r}' for k, v in sn['keys'].items())};  -- 저장 전 값 원복(저장이 {dict(zip(vals, cur_row))} 로 바꿈)")
                            if not dry:
                                cur.execute(f"UPDATE {sn['table']} SET {setc} WHERE {sw}", dict(sn['keys'], **{f'v_{c}': v for c, v in vals.items()}))
            if dry:
                cx.rollback()
            else:
                cx.commit()
                log.append('COMMIT;')
        except Exception as ex:  # noqa: BLE001
            cx.rollback()
            log.append(f'-- ROLLBACK: {ex}')
            open(os.path.join(out_dir, f'cleanup_{stamp}.sql'), 'w', encoding='utf-8').write('\n'.join(log) + '\n')
            print(f'[FAIL] {mid} 정리 ROLLBACK — {ex}')
            return 1
        for e in entries:
            kw = ' AND '.join(f'{k} = :{k}' for k in e['keys'])
            for t in spec['tables']:
                cur.execute(f'SELECT COUNT(*) FROM {t} WHERE {kw}', e['keys'])
                left += cur.fetchone()[0]
        log.append(f'-- 잔존(키 전체 기준) {left}건')
    open(os.path.join(out_dir, f'cleanup_{stamp}.sql'), 'w', encoding='utf-8').write('\n'.join(log) + '\n')
    if not dry:
        done = os.path.join(ROOT, 'Doc', 'verify', mid, 'crud_keys.done.json')
        prev = json.load(open(done, encoding='utf-8')) if os.path.exists(done) else []
        json.dump(prev + [dict(e, cleaned=stamp) for e in entries], open(done, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        os.remove(kp)
    print(f"{mid}: 저장 키 {len(entries)}건 · 정리 {total}행{' (dry-run)' if dry else ''} · 잔존 {left} → Doc/verify/{mid}/cleanup/cleanup_{stamp}.sql")
    return 0 if left == 0 or dry else 1


if __name__ == '__main__':
    sys.exit(main())
