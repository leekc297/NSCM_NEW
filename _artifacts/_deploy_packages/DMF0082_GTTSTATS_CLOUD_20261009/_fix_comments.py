import pathlib
for fn in ["00_PRECHECK_CLOUD.sql","10_SET_GTT_STATS.sql","90_VERIFY.sql","99_ROLLBACK_GTT_STATS.sql"]:
    p = pathlib.Path(fn); lines = p.read_text(encoding="utf-8").splitlines(); out=[]; inc=False
    for l in lines:
        s = l.strip()
        if not inc and s.startswith("/*"):
            inc = not s.endswith("*/"); out.append("-- " + s[2:].removesuffix("*/").strip()); continue
        if inc:
            if s.endswith("*/"): inc = False
            out.append("-- " + s.removesuffix("*/").strip()); continue
        out.append(l)
    p.write_text("\n".join(out) + "\n", encoding="utf-8", newline="\n"); print(fn, "ok")
