"""[파일 생성] 1차 목록 추가분 — 기준 파일 '정제전' 에 있고 사내 DB 에 DEFAULT '-' 가 설정돼 있는데 '처리대상이력' 에 없는 컬럼 (사용자 지시 2026-10-07: 일괄 추가)
출력: _pop_extra.json  (처리대상이력 과 같은 필드: owner/table/column/col_id/dtype/nullable/file_default/file_ddl + 추가 사유)
      DEFAULT범위_확대후보_20261007.xlsx 의 1_확대후보 '결정' 열 기입
"""
import json, pathlib, collections, openpyxl
HERE = pathlib.Path(__file__).resolve().parent
X = HERE / "DEFAULT범위_확대후보_20261007.xlsx"
wb = openpyxl.load_workbook(X); ws = wb["1_확대후보"]
h = [c.value for c in ws[1]]; I = {k: i for i, k in enumerate(h)}
pre_wb = openpyxl.load_workbook(HERE / "_pop_src_copy.xlsx", read_only=True, data_only=True)
pre = {(r[1], r[2]): r for r in list(pre_wb["정제전"].iter_rows(values_only=True))[1:] if r and r[0]}
extra = []; stat = collections.Counter()
for row in ws.iter_rows(min_row=2):
    t, c = row[I["테이블"]].value, row[I["컬럼"]].value
    where = row[I["기준 파일에서의 위치"]].value
    if (t, c) in pre and row[I["현재 DEFAULT"]].value == "'-'":
        r = pre[(t, c)]
        row[I["결정(확대 / 제외)"]].value = "확대"
        row[I["비고"]].value = "사용자 지시 2026-10-07 — 정제전 목록에 있고 DEFAULT 설정됨 → 일괄 추가"
        extra.append({"owner": r[0], "table": t, "column": c, "col_id": r[3], "dtype": r[4], "nullable": r[5], "file_default": r[6],
                      "file_ddl": f"ALTER TABLE {t} MODIFY ({c} DEFAULT ON NULL '-');", "added": "2026-10-07 사용자 지시 — 정제전에 있고 사내 DB DEFAULT '-' 설정됨", "where": where})
        stat["확대"] += 1; stat["제외테이블 시트에 있던 테이블" if "'제외테이블' 시트에 있음" in where else "제외 사유 기록 없던 것"] += 1
    else:
        stat["미결(정제전에 없음·임시)"] += 1
wb.save(X)
(HERE / "_pop_extra.json").write_text(json.dumps({"rows": extra, "rule": "기준 파일 '정제전' 시트에 있음 AND 사내 ZIOUI1 현재 DEFAULT '-' AND '처리대상이력' 에 없음", "decided": "2026-10-07 사용자 지시"}, ensure_ascii=False, indent=1), encoding="utf-8")
print(dict(stat)); print("테이블", len({e["table"] for e in extra}))
tb = collections.Counter(e["table"] for e in extra)
print(sorted(tb.items(), key=lambda x: -x[1]))
print("NULLABLE(정제전):", collections.Counter(e["nullable"] for e in extra))
