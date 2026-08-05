#!/usr/bin/env python3
"""
03_dump_sources.py — 폐포에 포함된 PL/SQL 유닛의 ALL_SOURCE 전문 덤프 (동적 SQL 정적 파싱용)
입력: closure.csv  출력: sources/{OWNER}.{NAME}.{TYPE}.sql + sources_index.csv
"""
import csv, sys, pathlib

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
from ora import conn_info
import oracledb

PLSQL_TYPES = ("PACKAGE BODY", "PROCEDURE", "FUNCTION", "TRIGGER", "TYPE BODY")

def main():
    units = set()
    with (HERE / "closure.csv").open(encoding="utf-8-sig", newline="") as f:
        for r in csv.DictReader(f):
            if r["TYPE"] in ("PACKAGE", "PROCEDURE", "FUNCTION", "TRIGGER", "TYPE"):
                units.add((r["OWNER"], r["OBJECT_NAME"]))
    print(f"target units: {len(units)}")
    outdir = HERE / "sources"
    outdir.mkdir(exist_ok=True)
    u, p, d = conn_info()
    idx = []
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.arraysize = 5000
        for owner, name in sorted(units):
            cur.execute(
                "SELECT TYPE, LINE, TEXT FROM ALL_SOURCE "
                "WHERE OWNER = :o AND NAME = :n AND TYPE IN "
                "('PACKAGE BODY','PROCEDURE','FUNCTION','TRIGGER','TYPE BODY') "
                "ORDER BY TYPE, LINE", o=owner, n=name)
            by_type = {}
            for t, line, text in cur.fetchall():
                by_type.setdefault(t, []).append(text or "")
            for t, lines in by_type.items():
                fn = outdir / f"{owner}.{name}.{t.replace(' ', '_')}.sql"
                fn.write_text("".join(lines), encoding="utf-8")
                idx.append([owner, name, t, len(lines)])
    with (HERE / "sources_index.csv").open("w", newline="", encoding="utf-8-sig") as f:
        w = csv.writer(f); w.writerow(["OWNER", "NAME", "TYPE", "LINES"]); w.writerows(idx)
    print(f"dumped: {len(idx)} unit-bodies -> sources/")

if __name__ == "__main__":
    main()
