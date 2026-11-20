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
            cur.execute("SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", t=t); ctype = {r[0]: r[1] for r in cur.fetchall()}; cols = set(ctype)
            keys = [k for k in pk if k in item] or [k for k in ('DIVISION_ID', 'SCM_SITE_ID', 'ITEM_ID', 'PLANT_SITE_ID', 'PROJECT_CODE', 'MEASURE') if k in cols and k in item]
            if not keys:
                out['skipped'][t] = f'행 값과 맞는 키 없음(PK {",".join(pk) or "없음"})'; continue
            w = ' AND '.join(f'{k} = :{k}' for k in keys)
            # 2026-11-07 T161(SCP0127·SCP0131 F6/F7/F8 '[측정 경로 누락] 변경된 행이 없어'): 그리드 날짜 칸은 Date → str() 이 ISO(UTC) 라 VARCHAR2 'YYYYMMDD' 키와 불일치 → 0행 · T158 과 같은 정규화 사용
            from restore_touched import _key_value
            cur.execute(f'SELECT * FROM {t} WHERE {w} AND ROWNUM <= 20001', {k: _key_value(item[k], k, ctype.get(k, '')) for k in keys})
            names = [d[0] for d in cur.description]; rows = cur.fetchall()
            if len(rows) > 20000:
                out['skipped'][t] = f'키 {",".join(keys)} 로 20000행 초과 — 행 단위 비교 불가'; continue
            # 2026-11-17 SCP0111: 그리드 표시값(OPERATION_GROUP 'Pack')이 DB 코드('P')와 달라 키 조회 0행 → 저장 전후 모두 0행이라 '변화 0' 허위 판정(V-4b9aa2ea)
            #   → 0행이면 비교하지 않고 사유를 남긴다(skipped = 측정 불가 · 판정은 미검증으로 남는다)
            dropped = []
            if not rows and len(keys) > 1:
                # 표시값과 코드가 다른 키 찾기: 그 키 하나를 뺀 조건으로 행이 나오면(50행 이하) 그 키를 빼고 비교한다 — 저장 전후 같은 조건이라 비교가 성립
                for k_ in keys:
                    ks = [k for k in keys if k != k_]
                    cur.execute(f"SELECT * FROM {t} WHERE {' AND '.join(f'{k} = :{k}' for k in ks)} AND ROWNUM <= 51", {k: _key_value(item[k], k, ctype.get(k, '')) for k in ks})
                    rr = cur.fetchall()
                    if 0 < len(rr) <= 50:
                        names = [d[0] for d in cur.description]; rows = rr; dropped = [k_]; keys = ks; break
            if not rows:
                out['skipped'][t] = '키 값으로 0행 — 화면 표시값과 DB 코드가 다를 수 있음(' + ', '.join(f'{k}={str(item[k])[:20]}' for k in keys)[:200] + ')'; continue
            conv = lambda v: v.isoformat() if isinstance(v, (datetime.datetime, datetime.date)) else (None if v is None else str(v))
            out['tables'][t] = {'keys': keys, 'pk': pk, 'dropped_keys': dropped, 'n': len(rows), 'rows': [dict(zip(names, map(conv, r))) for r in rows]}
    print(json.dumps(out, ensure_ascii=False))
    return 0


if __name__ == '__main__':
    sys.exit(main())
