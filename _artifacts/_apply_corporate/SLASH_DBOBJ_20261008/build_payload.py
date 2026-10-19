# -*- coding: utf-8 -*-
"""클라우드 적용 페이로드 = '지금 사내에 적용되어 있는 원문' 스냅샷(97객체) → 05_CLOUD_PAYLOAD_corp/ + payload_manifest.json
   각 객체에 대해 우리 '/' 변경 줄(patches.json edits.new)이 현재 사내 원문에 전부 살아 있는지 확인 → 없는 객체는 payload 제외(사내 재적용 먼저)."""
import sys, json, pathlib, hashlib, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_apply_corporate\SLASH_DBOBJ_20261008")
import engine
HERE = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\SLASH_DBOBJ_20261008")
OUT = HERE / "05_CLOUD_PAYLOAD_corp"; OUT.mkdir(exist_ok=True)
rows = json.loads((HERE / "manifest_objects.json").read_text(encoding="utf-8"))
P = json.loads((HERE / "patches.json").read_text(encoding="utf-8"))["patches"]
con = engine.connect(None); cur = con.cursor(); man = []; excluded = []
for r in rows:
    src, kind = engine.fetch_source(cur, r["otype"], r["name"]); st, ddl_t = engine.obj_status(cur, r["otype"], r["name"])
    edits = P[f"{r['otype']}|{r['name']}"]["edits"]
    cur_set = {l.rstrip() for l in src}
    missing = [e for e in edits if e["new"].rstrip() not in cur_set]
    newf = (HERE / "01_NEW_corp" / r["file"]).read_text(encoding="utf-8").split("\n")
    same_as_applied = [l.rstrip() for l in src] == [l.rstrip() for l in newf] if kind == "source" else ("\n".join(l.strip() for l in src).strip() == "\n".join(l.strip() for l in newf).strip())
    item = dict(otype=r["otype"], name=r["name"], file=r["file"], kind=kind, status=st, last_ddl=ddl_t, lines=len(src), dash_lines=sum(1 for l in src if "'-'" in l),
                slash_lines=sum(1 for l in src if "'/'" in l), sha1=hashlib.sha1("\n".join(src).encode("utf-8")).hexdigest(), our_edits=len(edits), our_edits_missing=len(missing),
                same_as_01_NEW=same_as_applied, snapshot_at=datetime.datetime.now().isoformat(timespec="seconds"))
    if missing:
        excluded.append(dict(item, missing_lines=[dict(line=e["found"], new=e["new"].strip()[:120]) for e in missing])); continue
    (OUT / r["file"]).write_text("\n".join(src), encoding="utf-8"); man.append(item)
json.dump(dict(mark="[E20261008-SLASHOBJ]", source_db=con.dsn, at=datetime.datetime.now().isoformat(timespec="seconds"), objects=man, excluded=excluded), open(HERE / "payload_manifest.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("payload objects:", len(man), "| excluded (our edits missing in corp now):", len(excluded), "| changed after apply but edits intact:", sum(1 for m in man if not m["same_as_01_NEW"]))
for m in man:
    if not m["same_as_01_NEW"]: print("   CHANGED-INTACT", m["otype"], m["name"], m["last_ddl"], "lines", m["lines"])
for e in excluded: print("   EXCLUDED", e["otype"], e["name"], e["last_ddl"], "missing", e["our_edits_missing"], "/", e["our_edits"], [x["new"][:80] for x in e["missing_lines"]])
