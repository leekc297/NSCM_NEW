# -*- coding: utf-8 -*-
"""
Phase 5 — 화면 ID ↔ 화면명 실측 (09_program_names.json)

권위 원천 (임의 명명 금지):
  1순위  SCM_ADM_MNU_M.MNU_MSG_ID → SCM_ADM_MSG_M.MSG_NM (LANG_CD='KO')  ← 화면에 실제 표시되는 라벨
  2순위  SCM_ADM_MNU_M.MNU_DESC                                          ← MSG 미등록 시 폴백

실측 특이사항 (2026-09-18):
  · DMF0082  MNU_DESC='Fcst MGMT' 이지만 실제 표시 라벨은 MSG 'Fcst&Price MGMT' — MSG 가 정본
  · DMF0035  MNU_MSG_ID='MNU00691' 이 SCM_ADM_MSG_M 에 **미등록** → MNU_DESC 폴백
  · DMF0051  USE_YN='N' (비활성 메뉴) — DMF0035 BIZ PLAN TYPE 의 메타 소속 PROGRAM_ID 로만 쓰인다
"""
import re
import json
import pathlib
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent

# 통합테스트 프로세스에 등장하는 전 화면 + DMF0035 종속 PROGRAM_ID(0022/0051)
SCREENS = ("DMF0003", "DMF0014", "DMF0020", "DMF0021", "DMF0022", "DMF0035",
           "DMF0042", "DMF0044", "DMF0049", "DMF0051", "DMF0082")


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'",
                  sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


with conn() as db:
    cur = db.cursor()
    cur.execute("""
        SELECT M.MNU_ID, M.MNU_MSG_ID, M.MNU_DESC, M.UPPR_MNU_ID, M.USE_YN, M.ROUTE_PATH,
               (SELECT S.MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M S
                 WHERE S.MSG_ID = M.MNU_MSG_ID AND S.LANG_CD = 'KO') AS MSG_KO
          FROM SCM_MGR.SCM_ADM_MNU_M M
         WHERE M.MNU_ID IN ({})
         ORDER BY 1""".format(",".join("'%s'" % x for x in SCREENS)))
    rows = cur.fetchall()

names, detail = {}, []
for mnu_id, msg_id, desc, uppr, use_yn, path, msg_ko in rows:
    label = msg_ko or desc
    src = "MSG({})".format(msg_id) if msg_ko else "MNU_DESC(MSG 미등록)"
    names[mnu_id] = label
    detail.append({"MNU_ID": mnu_id, "NAME": label, "SOURCE": src,
                   "MNU_MSG_ID": msg_id, "MNU_DESC": desc,
                   "UPPR_MNU_ID": uppr, "USE_YN": use_yn, "ROUTE_PATH": path})

missing = [x for x in SCREENS if x not in names]
if missing:
    raise SystemExit("SCM_ADM_MNU_M 미등록: {}".format(missing))

(D / "09_program_names.json").write_text(
    json.dumps({"names": names, "detail": detail}, ensure_ascii=False, indent=1),
    encoding="utf-8")

print("화면명 실측 {}건".format(len(names)))
for d in detail:
    print("   {:8s} {:24s} {:24s} USE={} {}".format(
        d["MNU_ID"], d["NAME"], d["SOURCE"], d["USE_YN"], d["ROUTE_PATH"]))
