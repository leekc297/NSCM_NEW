"""
excel_upload_case_e2e.py — 케이스별 단일시트 xlsx 를 실제 BE(/excel-upload, P_MODE=0 검증)에 올려 MESSAGE_TEXT 를 실측한다.

  python excel_upload_case_e2e.py DMF0014                 # Doc/단위테스트/_excel_upload_cases/DMF0014/*.xlsx
  python excel_upload_case_e2e.py DMF0074 --form DMF0074_40 --sheet "Metal Link Price"

  로그인 = /user/login {userId} (사내 BE, 비밀번호 없음) · 계정 minyonglee1(ADMIN)
  판정 = 업로드 응답 result 의 list 커서(MESSAGE_TEXT/UPLOAD_STATUS_CODE) — 없으면 스테이징(SCM_ADM_EXCEL_UPLOAD) 최신 배치 직접 조회
  리포트 = _artifacts/_gate_reports/<PROGRAM>_excel_upload_cases_<ts>.md
"""
import sys, os, json, glob, datetime, argparse, re
import requests
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb

ROOT = r"C:\Projects\NSCM"
ap = argparse.ArgumentParser()
ap.add_argument("program"); ap.add_argument("--form", default=None); ap.add_argument("--sheet", default=None)
ap.add_argument("--base", default="http://localhost:8080"); ap.add_argument("--user", default="minyonglee1")
ap.add_argument("--only", default=None, help="파일명 부분일치 필터")
a = ap.parse_args()
form = a.form or a.program
sheet = a.sheet or {"DMF0014": "FCST Upload", "DMF0074": "Metal Link Price"}[a.program]
# [E20260831-REGEN] 최신 cases_*.json 자동 선택 (구 20260827 하드코딩)
_case_jsons = sorted(glob.glob(os.path.join(ROOT, "Doc", "단위테스트", "_excel_upload_cases", "cases_*.json")))
cases = json.load(open(_case_jsons[-1], encoding="utf-8"))[a.program]
print("cases json:", os.path.basename(_case_jsons[-1]))
exp = {f"{c['no']:02d}_{c['cid']}"[:31]: c for c in cases}
files = sorted(glob.glob(os.path.join(ROOT, "Doc", "단위테스트", "_excel_upload_cases", a.program, "*.xlsx")))
if a.only: files = [f for f in files if a.only in os.path.basename(f)]

s = requests.Session()
r = s.post(f"{a.base}/user/login", json={"userId": a.user}, timeout=30); assert r.status_code == 200, r.text[:200]
print("login", (r.json().get("result") or {}).get("userId"))
u, p, d = ora.conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()

def find_msgs(obj, acc):
    """응답 JSON 어디에 있든 MESSAGE_TEXT/UPLOAD_STATUS_CODE 를 가진 dict 를 수집"""
    if isinstance(obj, dict):
        keys = {k.upper(): k for k in obj}
        if "MESSAGE_TEXT" in keys or "UPLOAD_STATUS_CODE" in keys:
            acc.append({"status": obj.get(keys.get("UPLOAD_STATUS_CODE", ""), ""), "msg": obj.get(keys.get("MESSAGE_TEXT", ""), "")})
        for v in obj.values(): find_msgs(v, acc)
    elif isinstance(obj, list):
        for v in obj: find_msgs(v, acc)

rows_out = []; shape_printed = False
for f in files:
    name = os.path.splitext(os.path.basename(f))[0]
    with open(f, "rb") as fh:
        resp = s.post(f"{a.base}/{form}/{sheet}/UPLOAD/excel-upload", files={"file": (os.path.basename(f), fh,
                      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")}, timeout=300)
    try: body = resp.json()
    except Exception: body = {"raw": resp.text[:300]}
    if not shape_printed:
        print("response keys:", list(body.keys()), "| result keys:", list((body.get("result") or {}).keys()) if isinstance(body.get("result"), dict) else type(body.get("result")).__name__)
        shape_printed = True
    acc = []; find_msgs(body.get("result"), acc)
    # 스테이징 직접 조회(최신 배치) — 응답에 행 목록이 없을 때 폴백 + 교차검증
    cur.execute("""SELECT UPLOAD_STATUS_CODE, MESSAGE_TEXT, COUNT(*) FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                    WHERE PROGRAM_ID = :p AND SHEET_NAME = :s AND CREATED_BY = :u
                      AND CREATION_DATE = (SELECT MAX(CREATION_DATE) FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD WHERE PROGRAM_ID = :p AND SHEET_NAME = :s AND CREATED_BY = :u)
                      AND NVL(UPLOAD_STATUS_CODE,'-') NOT IN ('V_TITLE','@TITLE')
                    GROUP BY UPLOAD_STATUS_CODE, MESSAGE_TEXT ORDER BY 1, 2""", p=form, s=sheet, u=a.user)
    stg = cur.fetchall()
    msgs = sorted({(x["status"], x["msg"]) for x in acc if x["msg"]})
    stg_msgs = sorted({(r_[0], r_[1] or "") for r_ in stg})
    e = exp.get(name, {}); expect = e.get("expect", "?")
    got = [m for st, m in stg_msgs if st == "ERROR"] or [m for st, m in msgs if m]
    got_s = " | ".join(sorted(set(got))) if got else "(오류 없음 — " + ",".join(f"{st}:{n}" for st, m, n in stg) + ")"
    ok_expected_none = expect.startswith("(")
    verdict = ("PASS" if (ok_expected_none and not got) else "PASS" if (not ok_expected_none and any(expect.split(" : ")[0] in g for g in got)) else "FAIL")
    rows_out.append((name, e.get("title", ""), expect, got_s, verdict, resp.status_code, body.get("code")))
    print(f"{verdict:4} {name:22} http={resp.status_code} code={body.get('code')} | expect={expect[:45]!s:45} | got={got_s[:80]}")

ts = datetime.datetime.now().strftime("%Y%m%d_%H%M")
rep = os.path.join(ROOT, "_artifacts", "_gate_reports", f"{a.program}_excel_upload_cases_{ts}.md")
with open(rep, "w", encoding="utf-8") as fh:
    fh.write(f"# {a.program} Excel Upload 케이스별 실측 — {ts} (form={form} sheet={sheet} user={a.user} base={a.base})\n\n")
    fh.write(f"- 러너: `_artifacts/_diagnostics/excel_upload_case_e2e.py` · 파일: `Doc/단위테스트/_excel_upload_cases/{a.program}/`\n")
    fh.write(f"- 판정: 기대 메시지(접미 제외)가 실측 ERROR MESSAGE_TEXT 에 포함되면 PASS · 기대가 '(정상…)' 이면 오류 0 일 때 PASS\n\n")
    fh.write("| 케이스 | 제목 | 기대 | 실측 | 판정 |\n|---|---|---|---|---|\n")
    for n, t, ex, g, v, hs, cd in rows_out: fh.write(f"| {n} | {t} | {ex} | {g} | **{v}** |\n")
    fh.write(f"\n## 종합: PASS {sum(1 for r_ in rows_out if r_[4]=='PASS')} / FAIL {sum(1 for r_ in rows_out if r_[4]=='FAIL')} / 총 {len(rows_out)}\n")
print("report:", rep)
