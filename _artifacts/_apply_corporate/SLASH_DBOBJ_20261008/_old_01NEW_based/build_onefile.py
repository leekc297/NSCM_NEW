# -*- coding: utf-8 -*-
"""03/99 단일 파일 생성: @@ 인클루드가 안 되는 도구(DBeaver 등)용 — 97객체 CREATE OR REPLACE 를 한 파일에. 객체별 START/END 마커로 DIFF 객체 블록 제거 가능."""
import pathlib, json, datetime
HERE = pathlib.Path(__file__).resolve().parent
rows = json.loads((HERE / "manifest_objects.json").read_text(encoding="utf-8"))
def build(src_dir, out, title):
    parts = [f"-- [E20261008-SLASHOBJ] {title} · 생성 {datetime.datetime.now():%Y-%m-%d %H:%M} · {len(rows)}객체 · SCM_MGR 접속 후 파일 전체 실행(F5). 02_CLOUD_PRECHECK 에서 DIFF/MISSING 인 객체는 아래 '-- ##### START <객체>' ~ '-- ##### END <객체>' 블록을 통째로 지우고 실행.",
             "SET DEFINE OFF", ""]
    for r in rows:
        body = (HERE / src_dir / r["file"]).read_text(encoding="utf-8")
        body = "\n".join(l for l in body.split("\n") if not l.startswith("-- [E20261008-SLASHOBJ]"))
        parts += [f"-- ##### START {r['otype']} {r['name']}", body.strip("\n"), f"-- ##### END {r['otype']} {r['name']}", ""]
    (HERE / out).write_text("\n".join(parts) + "\n", encoding="utf-8")
    print(out, "objects", len(rows), "bytes", (HERE / out).stat().st_size)
build("03_CLOUD_APPLY_sqlplus", "03_CLOUD_APPLY_ONEFILE.sql", "03_CLOUD_APPLY_ONEFILE — 적용 후 원문(사내 적용본) 전체")
build("99_CLOUD_ROLLBACK_sqlplus", "99_CLOUD_ROLLBACK_ONEFILE.sql", "99_CLOUD_ROLLBACK_ONEFILE — 사내 적용 전 원문으로 원복")
# 블록 구조 점검: 각 블록에 '/' 종결자와 SHOW ERRORS 가 1개씩
t = (HERE / "03_CLOUD_APPLY_ONEFILE.sql").read_text(encoding="utf-8")
starts = t.count("-- ##### START "); ends = t.count("-- ##### END "); slashes = sum(1 for l in t.split("\n") if l.strip() == "/"); shows = t.count("\nSHOW ERRORS ")
print("blocks", starts, ends, "| '/' lines", slashes, "| SHOW ERRORS", shows)
