#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0003 대사표 잔여(미구현 19 + 미판정 27) — **축별 올바른 원천**에서 판정.

⚠ 축을 잘못 고르면 오판이다. 원천을 나눠 본다.
   · lookup 타입명(TMM_MEASURE_ADMIN 등)  → **DB `SCM_ADM_LOOKUP_MASTER_DETAIL`**  (FE 소스에 없는 게 정상)
   · SP 명(DMF0010_GET_..., DMF0000_...)  → **DB ALL_PROCEDURES / SCM_ADM_API_M**
   · AS-IS 전용 개념(BigFilter/UP_FX_/layoutControlItem/lci*) → TO-BE 에 대응 없음이 **정상**(해당없음)
   · AS-IS 핸들러(spdMain_*/cbo*/chk*)     → TO-BE 대응 함수를 FE 에서 찾는다
   · 그 외                                  → 미판정 유지(사람 확인) — 조용히 밀어내지 않는다
"""
import io, re, sys, pathlib
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info
import oracledb

PAGE = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\mkt-fcst")
MAP = PAGE / "__asis-mapping__.md"
SRC = {}
for f in PAGE.rglob("*"):
    if f.suffix in (".ts", ".tsx"):
        try: SRC[f.relative_to(PAGE).as_posix()] = f.read_text(encoding="utf-8").split("\n")
        except Exception: pass

u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()

def in_lookup(name):
    cur.execute("""SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE LOOKUP_TYPE=:1 AND VALID_YN='Y'""", [name])
    return cur.fetchone()[0]

def in_db_obj(name):
    cur.execute("""SELECT OBJECT_TYPE FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                   AND UPPER(OBJECT_NAME)=UPPER(:1) AND ROWNUM=1""", [name])
    r = cur.fetchone()
    if r: return f"ALL_OBJECTS {r[0]}"
    cur.execute("""SELECT 'PROCEDURE' FROM ALL_PROCEDURES WHERE OWNER='SCM_MGR'
                   AND UPPER(PROCEDURE_NAME)=UPPER(:1) AND ROWNUM=1""", [name])
    if cur.fetchone(): return "PKG PROCEDURE"
    cur.execute("SELECT API_ID FROM SCM_ADM_API_M WHERE UPPER(API_ID)=UPPER(:1)", [name])
    r = cur.fetchone()
    return f"API_M {r[0]}" if r else None

def in_fe(*tokens):
    for tk in tokens:
        if len(tk) < 4: continue
        pat = re.compile(re.escape(tk), re.I)
        for fn, ls in SRC.items():
            for i, ln in enumerate(ls, 1):
                if pat.search(ln): return f"{fn}:{i}", tk
    return None, None

# AS-IS 전용 개념 — TO-BE 대응 없음이 정상
ASIS_ONLY = re.compile(
    r"BigFilter|UP_FX_GetCommonDataList|layoutControlItem|lciASCheck|TB_FX_|PM_TEAM_MAPPING"
    r"|NowGroupID|\.cs 라인|FarPoint|spdMain_|cbo[A-Z]\w*_|clb\w*_|chk[A-Z]\w*")
# AS-IS 핸들러 → TO-BE 대응 후보 (개념 매핑)
HANDLER_MAP = {
    "cboDivision": ("division 변경 cascade", ["applyCascadeClear", "divisionId"]),
    "clbTeam": ("team 변경 cascade", ["TEAM_ID", "applyCascadeClear"]),
    "clbCustomer": ("customer 변경 cascade", ["END_CUSTOMER", "applyCascadeClear"]),
    "cboBucketType": ("bucket 변경", ["bucketType"]),
    "spdMain_ComboSelChange": ("셀 콤보 변경 cascade", ["applyCascadeClear"]),
    "spdMain_CellDoubleClick": ("셀 더블클릭(드릴다운/SSP)", ["DoubleClick", "drill"]),
    "spdMain_EditChange": ("셀 편집", ["cellEditEnded", "beginningEdit"]),
    "spdMain_ClipboardPasted": ("붙여넣기", ["paste", "Paste"]),
    "spdMain_CellClick": ("셀 클릭", ["CellClick", "onCellClick", "selectionChanged"]),
    "cboAS_CheckedChanged": ("AS 체크", ["asYn", "AS_YN"]),
    "chkColor": ("Color 체크(AS-IS 미표시)", ["chkColor"]),
}

lines = MAP.read_text(encoding="utf-8").split("\n")
SEC = re.compile(r"^§[0-9.]+ *")
stat = {"구현": 0, "해당없음": 0, "미구현": 0, "미판정": 0}
log = []
for i, l in enumerate(lines):
    if not l.startswith("| "): continue
    c = l.split("|")
    if len(c) < 6 or c[5].strip() not in ("미구현", ""): continue
    rid, gist = c[1].strip(), c[2].strip()
    if not rid or rid == "ID": continue
    g = SEC.sub("", gist).replace("[원문 무번호]", "").strip()
    st = loc = why = None

    # 1) lookup 타입명
    m = re.search(r"\*\*([A-Z][A-Z0-9_]{4,})\*\*", g)
    if m and not st:
        n = in_lookup(m.group(1))
        if n:
            st, loc, why = "구현", f"DB `SCM_ADM_LOOKUP_MASTER_DETAIL` LOOKUP_TYPE='{m.group(1)}' {n}행", ""
    # 2) DB 객체/SP/API
    if not st:
        for nm in re.findall(r"`([A-Z][A-Z0-9_]{6,})`", g):
            o = in_db_obj(nm)
            if o:
                st, loc, why = "구현", f"DB {o} — `{nm}`", ""
                break
    # 3) AS-IS 핸들러 → TO-BE 대응
    if not st:
        for k, (desc, toks) in HANDLER_MAP.items():
            if k in g:
                fl, tk = in_fe(*toks)
                if fl:
                    st, loc, why = "구현", f"{fl} ({desc} — 토큰 `{tk}`)", ""
                else:
                    st, loc, why = "해당없음", "AS-IS 전용 이벤트", f"AS-IS `{k}` 대응 TO-BE 구현 미발견 — {desc}. WinForms 이벤트 모델 전용"
                break
    # 4) AS-IS 전용 개념
    if not st and ASIS_ONLY.search(g):
        st, loc, why = "해당없음", "AS-IS 전용 개념", "AS-IS(WinForms/BigFilter/TB_FX_) 전용 — TO-BE 는 CMBO·메타 체계로 대체. 이식 대상 아님"

    if st:
        c[3] = f" {loc} "; c[4] = f" {why} "; c[5] = f" {st} "
        lines[i] = "|".join(c); stat[st] += 1
        log.append((st, rid, g[:60], loc[:56]))
    else:
        stat["미판정"] += 1
        log.append(("미판정", rid, g[:70], ""))

MAP.write_text("\n".join(lines), encoding="utf-8")
con.close()
print(f"[판정] 구현 {stat['구현']} / 해당없음 {stat['해당없음']} / 미판정 {stat['미판정']}\n")
for st in ("구현", "해당없음", "미판정"):
    sel = [x for x in log if x[0] == st]
    if not sel: continue
    print(f"── {st} {len(sel)}건 ──")
    for _, rid, g, loc in sel[:18]:
        print(f"   {rid:<10}{g[:58]:<60}{loc}")
    if len(sel) > 18: print(f"   … 외 {len(sel)-18}건")
