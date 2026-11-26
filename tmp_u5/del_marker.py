import sys, csv, datetime
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
ts = datetime.datetime.now().strftime('%Y%m%d_%H%M%S'); out = r'C:\Projects\NSCM\Doc\verify\SCP0005\cleanup'
c = dbconn.connect('tobe', write=True); cur = c.cursor(); log = []
W = "ROUTE_ID in (11172, 11173) and CREATED_BY = 'jooyong026' and CREATION_DATE > sysdate - 1"
try:
    for t in ('SCP_MST_DISTRIBUTION_ROUTE_H', 'SCP_MST_DISTRIBUTION_ROUTE'):
        cur.execute(f"select * from {t} where {W}"); cols = [d[0] for d in cur.description]; rows = cur.fetchall()
        with open(f"{out}\{ts}_{t}.csv", 'w', newline='', encoding='utf-8-sig') as f:
            w = csv.writer(f); w.writerow(cols); w.writerows(rows)
        cur.execute(f"delete from {t} where {W}"); n = cur.rowcount
        assert n == len(rows) == 2, (t, n, len(rows))
        log.append(f"delete from {t} where {W}; -- 백업 {len(rows)} · 삭제 {n}")
    c.commit(); log.append('commit;')
except Exception as e:
    c.rollback(); log.append(f'rollback; -- {e}'); raise
finally:
    open(f"{out}\cleanup_{ts}.sql", 'w', encoding='utf-8').write('\n'.join(log) + '\n'); print('\n'.join(log)); c.close()
