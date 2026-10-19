"""[xlsx 생성] NULL 센티널 '/' 전환 — 최종 정리 (사용자 지시 10-07 저녁: 데이터 변환 없음)
  ① DEFAULT : 대상 컬럼 전부 '/' — 기존 DEFAULT 가 '-' 아니면 유지('N' 등) / 미적용
  ② DB 객체(PKG·SP·VIEW·FUNCTION) : 대상 테이블·컬럼을 쓰는 줄 중 바뀌어야 할 것만 — 현재 원문 → 변경 후
     규칙: AS-IS 에 '-' 가 있던 컬럼 = '-' 비교·분기 로직 유지 / 빈값 자리표시 '-'(NVL(x,'-')·리터럴 '-'·빈값 비교) = '/'
원천: 다른 세션 작업대상 xlsx 3_TOBE_변경목록 (TO-BE 원문 6,542 '-' 출현 · 액션·변경안) + AS-IS 실측(1_컬럼판정·s5)
출력: 슬래시전환_DEFAULT_DB객체_정리_20261007.xlsx
"""
import sys, json, re, pathlib, collections, datetime, shutil
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.utils import get_column_letter
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE)); import s1_data_scan as s
PS = json.loads((HERE / "_partner_scan.json").read_text(encoding="utf-8"))
EX = json.loads((HERE / "_pop_extra.json").read_text(encoding="utf-8"))["rows"]
tmp = HERE / "_src_copy.xlsx"; shutil.copy2(s.SRC, tmp)
wbs = openpyxl.load_workbook(tmp, read_only=True, data_only=True)
r1 = list(wbs["1_컬럼판정"].iter_rows(values_only=True)); h1 = [str(c) for c in r1[0]]
def num(v):
    try: return int(str(v).replace(",", ""))
    except Exception: return None
ASIS = {}
for r in r1[1:]:
    if r and r[1]: ASIS[(r[1], r[2])] = dict(dash=num(r[h1.index("AS-IS '-' 행수(10-01)")]), blank=num(r[h1.index("AS-IS 빈값 행수(10-01, ''+' ' 합산)")]))
for t, e in PS.items():
    for c, a in e.get("asis", {}).items():
        if a and "missing" not in a and (t, c) not in ASIS: ASIS[(t, c)] = dict(dash=a["dash"], blank=a["null"] + a["empty"] + a["space"])
# 사용자 지적(10-07): AS-IS DEV 의 2026-09 이후 생성 행은 사내 오라클에서 넘어간 것일 수 있음 → "AS-IS 가 원래 '-' 를 쓰던 컬럼" 판정은 9월 이전 생성 '-' 행만으로 (s16)
BD = {}
for f in HERE.glob("_asis_dash_bydate*.json"):
    for t, cols_ in json.loads(f.read_text(encoding="utf-8")).items():
        for c, e in cols_.items():
            if "before_sep" in e: BD[(t, c)] = e
for k, e in BD.items():
    ASIS.setdefault(k, {})["dash_all"] = e["dash"]; ASIS[k]["dash"] = e["before_sep"]; ASIS[k]["dash_after"] = e["after_sep"]

# ── ① DEFAULT ──
cur = s.connect().cursor()
cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual"); at = cur.fetchone()[0]
cur.execute("SELECT TABLE_NAME, COLUMN_NAME, NULLABLE, DEFAULT_ON_NULL, DATA_DEFAULT FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'")
DFT = {(t, c): (n, o, (str(d).strip() if d is not None else None)) for t, c, n, o, d in cur}
cols = [(c["table"], c["column"], "1차 목록") for c in s.population()] + [(e["table"], e["column"], "정제전 탈락 추가" if e.get("kind") != "new_table" else "신규 테이블") for e in EX]
seen = set(); DEF = []; cnt = collections.Counter(); TARGET = {}
for t, c, src in cols:
    if (t, c) in seen: continue
    seen.add((t, c)); n, on, d = DFT.get((t, c), (None, None, None))
    if n is None: apply, why = "미적용", "사내 DB 에 컬럼 없음"
    elif n == "Y": apply, why = "미적용", "NULL 허용 컬럼 — 대상 아님"
    elif d is None or d == "'-'": apply, why = "'/'", ("현재 DEFAULT 없음 → 신설" if d is None else "현재 '-' → '/'")
    else: apply, why = f"{d} 유지", "기존 DEFAULT 가 '-' 아님 → 유지"
    cnt["'/'" if apply == "'/'" else ("미적용" if apply == "미적용" else "기존값 유지")] += 1
    DEF.append([t, c, src, d, "YES" if on == "YES" else "", apply, why, f"ALTER TABLE SCM_MGR.{t} MODIFY ({c} DEFAULT ON NULL '/');" if apply == "'/'" else ""])
    if apply != "미적용": TARGET[(t, c)] = src
DEF.sort(key=lambda r: (r[5] != "'/'", r[0], r[1]))
NEWTAB = {(e["table"], e["column"]) for e in EX if e.get("kind") == "new_table"}

# ── ② DB 객체 ──
r3 = list(wbs["3_TOBE_변경목록"].iter_rows(values_only=True)); h3 = [str(c) for c in r3[0]]; I = {k: i for i, k in enumerate(h3)}
def pcols(sv):
    out = []
    for x in re.split(r"[,;\n]+", str(sv or "")):
        m = re.match(r"\s*([A-Z_][\w$#]*)\.([A-Z_][\w$#]*)", x.strip())
        if m: out.append((m.group(1), m.group(2)))
    return out
COMPARE = ("조건절 비교", "분기", "NVL 비교", "CASE 조건")
CHANGE_ACTS = ("NVL→'/'", "비교→'/'", "리터럴→'/'", "변형정규화→'/'")
CH, KEEP, ASK, VIA = [], [], [], []
stat = collections.Counter()
for r in r3[1:]:
    if not r or not r[I["객체명"]]: continue
    act = str(r[I["액션"]]); use = str(r[I["쓰임"]] or ""); text = str(r[I["원문"]] or ""); prop = str(r[I["변경안"]] or "")
    tc = [k for k in pcols(r[I["대상 컬럼(확정)"]]) if k in TARGET]; cc = [k for k in pcols(r[I["후보 컬럼(미확정)"]]) if k in TARGET]
    via = ""
    if not tc:
        if cc: tc, via = cc, "경유(GTT·변수·파생 → 대상 컬럼)"; stat["경유 포함"] += 1   # 사용자 확인(10-07): 경유도 변환 대상 — 같은 규칙 적용
        else: stat["대상 컬럼 참조 아님"] += 1; continue
    base = [r[I["스키마"]], r[I["객체유형"]], r[I["객체명"]], r[I["서브프로그램"]], r[I["줄"]], use, act, via]
    colstr = ", ".join(f"{t}.{c}" for t, c in tc)
    if all(k in NEWTAB for k in tc):
        KEEP.append(base + [colstr, text, "신규 테이블 — DEFAULT 만, 코드 변경 없음"]); stat["유지"] += 1; continue
    dashes = [ASIS.get(k, {}).get("dash") for k in tc]
    real = any((d or 0) > 0 for d in dashes); unknown = any(d is None for d in dashes) and not real
    # 사용자 확정(10-07): 판정 축 = "그 컬럼이 9월 이전 AS-IS 데이터에서 실제 '-' 를 쓰는가" 하나. 쓰면 '-' 유지(리터럴·비교 모두), 안 쓰면 '/'. GTT 경유도 동일
    def occ_replace():
        col = r[I["열"]]; pos = [m.start() for m in re.finditer(r"'-'", text)]
        hit = [p for p in pos if isinstance(col, int) and abs(p + 1 - col) <= 1] or (pos if len(pos) == 1 else [])
        if hit: return text[:hit[0]] + "'/'" + text[hit[0] + 3:]
        # 한 줄에 '-' 가 여러 개여도 이 줄이 참조하는 대상 컬럼이 전부 AS-IS '-' 미사용이면 전부 빈값 자리표시 → 모두 '/'
        return text.replace("'-'", "'/'") if pos and not real and not unknown else None
    asis_info = " · ".join(f"{t}.{c}: AS-IS '-' {ASIS.get((t, c), {}).get('dash')}" + (f"(9월 이전 기준 · 9월 이후 {ASIS[(t, c)].get('dash_after')} 제외)" if (t, c) in BD else "") + f" / 빈값 {ASIS.get((t, c), {}).get('blank')}" for t, c in tc)
    # 사용자 지적(10-07): NVL(x,'-')='-' · NVL(NULLIF(TRIM(x),''),'-')='-' 는 NULL·'' 도 '-' 로 바꿔 잡는 "빈값 검사" — '-' 값 비교가 아니므로 컬럼에 '-' 가 있어도 '/' 로 변경
    #   유지는 x = '-' / x <> '-' 처럼 '-' 자체를 비교하고, 그 컬럼에 9월 이전 AS-IS '-' 가 실재할 때만
    blank_test = use.startswith(("NVL 비교", "변형정규화")) or re.search(r"NVL\s*\(", text, re.I) is not None and act in ("NVL→'/'", "비교→'/'")
    is_cmp = use.startswith(COMPARE) and not blank_test
    # 사용자 지시(10-07): NVL(x,'-') 는 전부 NVL(x,'/') 변경 대상 — 컬럼 사정·액션과 무관(유지·확인필요에 있던 것도 변경으로)
    is_nvl = act == "NVL→'/'" or use.startswith("NVL 비교") or (act != "유지(비센티널)" and re.search(r"NVL\s*\([^()]*(\([^()]*\)[^()]*)*,\s*'-'\s*\)", text, re.I) is not None)
    if is_nvl:
        after = prop if (prop and prop != text) else re.sub(r"(NVL\s*\([^()]*(?:\([^()]*\)[^()]*)*,\s*)'-'(\s*\))", r"\1'/'\2", text, flags=re.I)
        if use.startswith("NVL 비교") or re.search(r"NVL\s*\([^;]*'-'\s*\)\s*(=|<>|!=)\s*'-'", after, re.I): after = re.sub(r"(NVL\s*\([^;]*?'/'\s*\)\s*(?:=|<>|!=)\s*)'-'", r"\1'/'", after, flags=re.I)
        CH.append(base + [colstr, text, after, "NVL(x,'-') → NVL(x,'/') — 빈값 자리표시(사용자 지시 10-07, 컬럼 사정 무관)" + (" · 비교 리터럴도 '/'" if "=" in after else "") + " (" + asis_info + ")"]); stat["변경"] += 1; continue
    if act == "유지(비센티널)": KEEP.append(base + [colstr, text, "'-' 가 구분자·표기 — 센티널 아님"]); stat["유지"] += 1
    elif unknown: ASK.append(base + [colstr, text, prop, "AS-IS '-' 보유 여부 미확인 — 있으면 유지, 없으면 변경 (" + asis_info + ")"]); stat["확인 필요"] += 1
    elif real and (is_cmp or act in ("유지(AS-IS 값)", "미확정(검토)", "리터럴→'/'")):
        KEEP.append(base + [colstr, text, "이 컬럼은 9월 이전 AS-IS 데이터에서 실제 '-' 를 사용 — '-' 유지 (" + asis_info + ")"]); stat["유지"] += 1
    elif act in ("유지(AS-IS 값)", "미확정(검토)"):
        after = prop if (act != "유지(AS-IS 값)" and prop and prop != text) else occ_replace()
        if after:
            CH.append(base + [colstr, text, after, "이 컬럼은 AS-IS 데이터에서 '-' 를 쓰지 않음(9월 이전 0행) → 빈값 자리표시 '-' 를 '/' 로" + (" — AS-IS 코드에 '-' 리터럴이 있었으나 데이터 미사용" if act == "유지(AS-IS 값)" else "") + " (" + asis_info + ")"]); stat["변경"] += 1
        else:
            ASK.append(base + [colstr, text, prop, "한 줄에 '-' 가 여러 개라 위치 특정 불가 — 수작업 (" + asis_info + ")"]); stat["확인 필요"] += 1
    elif act in CHANGE_ACTS:
        why = {"NVL→'/'": "빈값 자리표시 NVL(x,'-') → '/' (새로 들어오는 빈값 = DEFAULT '/')", "비교→'/'": ("NVL(…,'-')='-' 는 NULL·'' 까지 '-' 로 바꿔 잡는 빈값 검사 → '/' (AS-IS ISNULL(x,'')='' 대응)" if blank_test else "빈값 비교 '-' → '/' (이 컬럼에 9월 이전 AS-IS '-' 없음 — '-' 는 빈값만 뜻함)"),
               "리터럴→'/'": "이관 때 넣은 빈값 자리표시 리터럴 '-' → '/'", "변형정규화→'/'": "빈값 변형 정규화 결과 '-' → '/' (IN 목록에 '/' 추가)"}[act]
        if real and not blank_test: why += " ※ 이 컬럼에는 9월 이전 AS-IS '-' 도 있음 — 적재 쪽만 변경"
        CH.append(base + [colstr, text, prop, why + " (" + asis_info + ")"]); stat["변경"] += 1
    else:
        ASK.append(base + [colstr, text, prop, "자동 변경안 없음(" + act + ") — 수작업 판단 (" + asis_info + ")"]); stat["확인 필요"] += 1

wb = openpyxl.Workbook()
def sheet(name, head, rows, widths):
    w = wb.create_sheet(name); w.append(head)
    for x in w[1]: x.font = Font(bold=True, color="FFFFFF"); x.fill = PatternFill("solid", fgColor="305496"); x.alignment = Alignment(wrap_text=True, vertical="center")
    for rr in rows: w.append(["" if v is None else v for v in rr])
    for i, wd in enumerate(widths, 1): w.column_dimensions[get_column_letter(i)].width = wd
    w.freeze_panes = "D2"; w.auto_filter.ref = w.dimensions
sheet("1_DEFAULT", ["테이블", "컬럼", "출처", "현재 DEFAULT", "ON NULL", "적용", "사유", "DDL (검토용 — 실행하지 않음)"], DEF, [34, 26, 14, 14, 8, 12, 30, 80])
B = ["스키마", "객체유형", "객체명", "서브프로그램", "줄", "쓰임", "작업대상 xlsx 액션", "경유"]
sheet("2_DB객체_변경", B + ["대상 테이블.컬럼", "현재", "변경 후", "사유"], CH, [10, 14, 34, 34, 8, 16, 14, 14, 40, 90, 90, 80])
sheet("3_DB객체_확인필요", B + ["대상 테이블.컬럼", "현재", "변경안(참고)", "확인 사항"], ASK, [10, 14, 34, 34, 8, 16, 14, 14, 40, 90, 90, 80])
sheet("4_DB객체_유지", B + ["대상 테이블.컬럼", "현재", "유지 사유"], KEEP, [10, 14, 34, 34, 8, 16, 14, 14, 40, 90, 80])
ws = wb.active; ws.title = "요약"
objs = lambda L: len({(x[2]) for x in L})
S = [["NULL 센티널 '/' 전환 — DEFAULT · DB 객체 정리 (데이터 변환 없음)"], [], ["작성", datetime.datetime.now().strftime("%Y-%m-%d %H:%M"), f"사내 ZIOUI1 컬럼 사전 {at} · TO-BE 원문 = 작업대상 xlsx(10-07 13:51)"],
     ["원칙", "데이터는 바꾸지 않는다. 판정 축 하나 = 그 컬럼이 2026-09-01 이전 AS-IS 데이터에서 실제 '-' 를 쓰는가. 쓰면 '-' 유지(리터럴 적재·비교 모두, 예 CELL_PROD_SITE_ID), 안 쓰면 '/'(AS-IS 코드에 '-' 리터럴이 있었어도). NVL(x,'-') 는 항상 NVL(x,'/'). GTT·변수 경유도 최종 대상 컬럼 기준으로 동일. 9월 이후 생성 행은 사내 오라클 유입 가능성으로 제외."], [],
     ["① DEFAULT", len(DEF), json.dumps(dict(cnt), ensure_ascii=False) + " · 미적용(별도): 백업·복사본 의심 신규 테이블 3,454 컬럼 (DEFAULT범위_확대후보 xlsx 시트 3)"], [],
     ["② DB 객체 — 대상 컬럼을 참조하는 '-' 출현", sum(v for k, v in stat.items() if k != "대상 컬럼 참조 아님"), f"원문 6,542 출현 중 대상 컬럼 미참조 {stat['대상 컬럼 참조 아님']:,} 제외"],
     ["   변경 (시트 2)", stat["변경"], f"{objs(CH)} 객체 — 현재 → 변경 후"],
     ["   확인 필요 (시트 3)", stat["확인 필요"], f"{objs(ASK)} 객체 — AS-IS '-' 보유 미확인 컬럼 또는 자동 변경안 없는 자리"],
     ["   유지 (시트 4)", stat["유지"], f"{objs(KEEP)} 객체 — 9월 이전 AS-IS '-' 실재 컬럼의 '-' 자체 비교·분기 / 실제 값 리터럴 / 구분자 / 신규 테이블"],
     ["   (경유 포함)", stat["경유 포함"], "GTT·변수·파생 테이블을 거쳐 대상 컬럼에 닿는 자리 — 같은 규칙으로 위 세 시트에 배분(‘경유’ 열 표시)"],
     ["   9월 기준 AS-IS '-' 판정", f"{len(BD)} 컬럼", f"AS-IS '-' 가 전부 9월 이후 생성(원래 값 아님) = {sum(1 for e in BD.values() if e['before_sep'] == 0)} 컬럼 · 9월 이전 '-' 실재 = {sum(1 for e in BD.values() if e['before_sep'] > 0)} 컬럼"], [],
     ["변경 안 함(확정)", "", "코드 마스터 조인 NVL(x,'/') 198줄(NOT NULL 이라 무동작) · 범위 밖 컬럼('-' 실제 값)을 '/' 와 비교하게 되는 87줄 · 신규 테이블 참조"], [],
     ["한계"], ["  '-' 출현·액션·변경안은 다른 세션의 정적 분석 결과(컬럼 특정은 별칭·FROM 기준) — 시트 3·5 는 사람이 확인"],
     ["  AS-IS '-' 보유 여부는 DEV(10-01) 실측 기준. 추가분 115 는 일부만 실측(시트 3 으로 분류)"], ["  DB 객체·데이터 변경 없음 — DDL·변경안은 검토용"]]
for r in S: ws.append(r)
ws["A1"].font = Font(bold=True, size=13); ws.column_dimensions["A"].width = 40; ws.column_dimensions["B"].width = 10; ws.column_dimensions["C"].width = 130
out = HERE / "슬래시전환_DEFAULT_DB객체_정리_20261007.xlsx"
try: wb.save(out)
except PermissionError:
    out = HERE / "슬래시전환_DEFAULT_DB객체_정리_20261007_v2.xlsx"; wb.save(out); print("원본 파일이 열려 있어 _v2 로 저장")
print(out); print("DEFAULT", dict(cnt)); print("DB객체", dict(stat)); print("9월 기준 적용 컬럼", len(BD))
print("변경 객체별:", collections.Counter(x[2] for x in CH).most_common(10))
print("변경 액션별:", collections.Counter(x[6] for x in CH))
