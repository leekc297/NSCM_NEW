import pathlib
f = pathlib.Path("engine.py"); t = f.read_text(encoding="utf-8")
old = '''    for (otype, name), lines in by_obj.items():
        status, ddl = obj_status(cur, otype, name)'''
new = '''    only = set(args.only.split(",")) if getattr(args, "only", None) else None
    for (otype, name), lines in by_obj.items():
        if only and name not in only: continue
        status, ddl = obj_status(cur, otype, name)'''
assert t.count(old) == 1, "p1"; t = t.replace(old, new)
old = '''        for lno, rows in lines.items():
            idx, how = first[lno]
            if idx is None and shift is not None: idx, how = locate(src, lno, max((r["현재"] or "" for r in rows), key=len), shift)
            if idx is None and lno in ordinal: idx, how = ordinal[lno], "ordinal"
            if idx is None and shift is not None:
                txt = max((r["현재"] or "" for r in rows), key=len).strip(); hits = [i for i, l in enumerate(src) if l.strip() == txt]
                if len(hits) >= 2:
                    ds = sorted((abs(i - (lno - 1 + shift)), i) for i in hits)
                    if ds[0][0] <= 60 and ds[1][0] >= 3 * max(ds[0][0], 1): idx, how = ds[0][1], f"nearest-shift({ds[0][0]})"'''
new = '''        used = {idx for idx, how in first.values() if idx is not None}   # 1차(exact/search)로 확정된 줄은 다른 시트 줄의 후보에서 제외(중복 매핑 금지)
        for lno, rows in lines.items():
            idx, how = first[lno]
            txt = max((r["현재"] or "" for r in rows), key=len).strip()
            if idx is None and shift is not None:
                i2, h2 = locate(src, lno, txt, shift)
                if i2 is not None and i2 not in used: idx, how = i2, h2
            if idx is None and lno in ordinal and ordinal[lno] not in used: idx, how = ordinal[lno], "ordinal"
            if idx is None and shift is not None:
                hits = [i for i, l in enumerate(src) if l.strip() == txt and i not in used]
                if len(hits) >= 2:
                    ds = sorted((abs(i - (lno - 1 + shift)), i) for i in hits)
                    if ds[0][0] <= 60 and ds[1][0] >= 3 * max(ds[0][0], 1): idx, how = ds[0][1], f"nearest-shift({ds[0][0]})"
                elif len(hits) == 1 and abs(hits[0] - (lno - 1 + shift)) <= 60: idx, how = hits[0], "last-free"
            if idx is not None and how not in ("exact", "search") and idx in used: idx, how = None, "dup-target"
            if idx is not None: used.add(idx)'''
assert t.count(old) == 1, "p2"; t = t.replace(old, new)
old = '''        for txt, lnos in by_text.items():
            hits = [i for i, l in enumerate(src) if l.strip() == txt]
            if len(hits) <= 1: continue'''
new = '''        used0 = {idx for idx, how in first.values() if idx is not None}
        for txt, lnos in by_text.items():
            hits = [i for i, l in enumerate(src) if l.strip() == txt]
            lnos = [l for l in lnos if first[l][0] is None]; hits = [i for i in hits if i not in used0]
            if len(hits) == 1 and len(lnos) == 1: ordinal[lnos[0]] = hits[0]; continue
            if len(hits) <= 1: continue'''
assert t.count(old) == 1, "p3"; t = t.replace(old, new)
old = '''    (HERE / "patches.json").write_text(json.dumps(dict(planned_at=datetime.datetime.now().isoformat(timespec="seconds"), db=con.dsn, patches=patches), ensure_ascii=False, indent=1), encoding="utf-8")'''
new = '''    if only and (HERE / "patches.json").exists():   # --only: 다른 객체의 기존 계획은 보존
        prev = json.loads((HERE / "patches.json").read_text(encoding="utf-8"))["patches"]; prev.update(patches); patches = prev
    (HERE / "patches.json").write_text(json.dumps(dict(planned_at=datetime.datetime.now().isoformat(timespec="seconds"), db=con.dsn, patches=patches), ensure_ascii=False, indent=1), encoding="utf-8")'''
assert t.count(old) == 1, "p4"; t = t.replace(old, new)
f.write_text(t, encoding="utf-8"); print("patched8 ok")
