# -*- coding: utf-8 -*-
"""C01_ENV_STATE.sql 생성 — 사내 기준값(_corp_baseline.json, _collect_corp_baseline.py 채취)을 인라인 대조 데이터로 삽입."""
import json, pathlib, datetime
B = json.loads(pathlib.Path("_corp_baseline.json").read_text(encoding="utf-8"))
tabs = B["tables"]
inl = ",\n       ".join(", ".join(f"'{t}'" for t in tabs[i:i + 5]) for i in range(0, len(tabs), 5))


def q(s):
    return "NULL" if s is None else "'" + str(s).replace("'", "''") + "'"


par = "\n  UNION ALL ".join(f"SELECT {q(n)} N, {q(v)} V FROM DUAL" for n, v in B["param"])
st = "\n  UNION ALL ".join(f"SELECT {q(t)} T, {r} R, {mb} MB, {q(la)} LA FROM DUAL" for t, r, la, mb, _deg, _p in B["stats"])
ix = "\n  UNION ALL ".join(f"SELECT {q(t)} T, {q(i)} I, {q(c)} C FROM DUAL" for t, i, _s, c in B["idx"] if not i.startswith("SYS_IL"))
now = B.get("fetched", datetime.datetime.now().strftime("%Y-%m-%d %H:%M"))

tpl = pathlib.Path("_c01_template.sql").read_text(encoding="utf-8")
sql = (tpl.replace("{{NOW}}", now).replace("{{PARAM}}", par).replace("{{IDX}}", ix)
          .replace("{{STATS}}", st).replace("{{TABLES}}", inl))
pathlib.Path("C01_ENV_STATE.sql").write_text(sql, encoding="utf-8")
print("written C01_ENV_STATE.sql", len(sql), "chars")
