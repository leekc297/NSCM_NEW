# -*- coding: utf-8 -*-
"""저장 전후 DB 스냅샷(2026-10-31 E05) — 저장 대상 테이블에서 화면 행과 같은 키의 행을 읽는다. 저장 세부 판정(행 수 불변·감사 컬럼·연계 테이블)의 원천

  python tools/Harness/verify/db_snapshot.py <MENU_ID> '<행 dataItem JSON>'   → stdout JSON {"tables": {T: {"keys": [...], "n": N, "rows": [...]}}, "skipped": {T: 사유}}
  대상 = cleanup_spec.json 의 tables + unresolved_tables(기반 테이블 제외)
  키 = 그 테이블 PK(없으면 유일 인덱스) 중 행 dataItem 에 값이 있는 컬럼. 키가 하나도 안 맞거나 PK 일부만 맞아 20000행을 넘으면 skipped(잴 수 없음을 숨기지 않는다)
"""
import datetime, json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect  # noqa: E402

INFRA = re.compile(r'(?i)^SCM_SYS_LOG|TITLESET|EXCEL_UP|_UPLOAD|_TMP$|_TEMP$|_WRK$|_LOG$|^SCM_COM_ATCH')


def main():
    mid, item = sys.argv[1].upper(), json.loads(sys.argv[2])
    item = {k.upper(): v for k, v in item.items() if v not in (None, '')}
    spec = json.load(open(os.path.join(HERE, 'cleanup_spec.json'), encoding='utf-8')).get(mid) or {}
    tables = [t for t in dict.fromkeys((spec.get('tables') or []) + (spec.get('unresolved_tables') or [])) if not INFRA.search(t)]
    out = {'tables': {}, 'skipped': {}}
    if not tables:
        out['skipped']['*'] = 'cleanup_spec 에 대상 테이블 없음'
    with connect('tobe') as cx:
        cur = cx.cursor()
        for t in tables:
            cur.execute("SELECT C.COLUMN_NAME FROM ALL_CONSTRAINTS K JOIN ALL_CONS_COLUMNS C ON C.OWNER=K.OWNER AND C.CONSTRAINT_NAME=K.CONSTRAINT_NAME WHERE K.OWNER='SCM_MGR' AND K.TABLE_NAME=:t AND K.CONSTRAINT_TYPE='P' ORDER BY C.POSITION", t=t)
            pk = [r[0] for r in cur.fetchall()]
            if not pk:
                cur.execute("SELECT C.COLUMN_NAME FROM ALL_INDEXES I JOIN ALL_IND_COLUMNS C ON C.INDEX_OWNER=I.OWNER AND C.INDEX_NAME=I.INDEX_NAME WHERE I.TABLE_OWNER='SCM_MGR' AND I.TABLE_NAME=:t AND I.UNIQUENESS='UNIQUE' ORDER BY I.INDEX_NAME, C.COLUMN_POSITION", t=t)
                pk = list(dict.fromkeys(r[0] for r in cur.fetchall()))
            cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", t=t); cols = {r[0] for r in cur.fetchall()}
            keys = [k for k in pk if k in item] or [k for k in ('DIVISION_ID', 'SCM_SITE_ID', 'ITEM_ID', 'PLANT_SITE_ID', 'PROJECT_CODE', 'MEASURE') if k in cols and k in item]
            if not keys:
                out['skipped'][t] = f'행 값과 맞는 키 없음(PK {",".join(pk) or "없음"})'; continue
            w = ' AND '.join(f'{k} = :{k}' for k in keys)
            cur.execute(f'SELECT * FROM {t} WHERE {w} AND ROWNUM <= 20001', {k: str(item[k]) for k in keys})
            names = [d[0] for d in cur.description]; rows = cur.fetchall()
            if len(rows) > 20000:
                out['skipped'][t] = f'키 {",".join(keys)} 로 20000행 초과 — 행 단위 비교 불가'; continue
            conv = lambda v: v.isoformat() if isinstance(v, (datetime.datetime, datetime.date)) else (None if v is None else str(v))
            out['tables'][t] = {'keys': keys, 'pk': pk, 'n': len(rows), 'rows': [dict(zip(names, map(conv, r))) for r in rows]}
    print(json.dumps(out, ensure_ascii=False))
    return 0


if __name__ == '__main__':
    sys.exit(main())
