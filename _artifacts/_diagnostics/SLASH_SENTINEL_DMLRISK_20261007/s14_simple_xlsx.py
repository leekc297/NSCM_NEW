"""[xlsx 생성] NULL 센티널 '/' 전환 — 단순 정리 (사용자 지시 10-07 저녁)
  ① DEFAULT : 대상 컬럼 전부 '/' — 기존 DEFAULT 가 '-' 가 아니면 그 값 유지('N' 등). 미적용 = 백업·복사본 의심 테이블(별도 파일)
  ② DML     : AS-IS 실제 '-' 는 건드리지 않음. TO-BE 에 지금 바뀔 행('-'·공백만)이 있는 컬럼만 — 현재 → 변경 후
출력: 슬래시전환_DEFAULT_DML_정리_20261007.xlsx
"""
import sys, json, re, pathlib, collections, datetime, shutil
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.utils import get_column_letter
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE)); import s1_data_scan as s
PS = json.loads((HERE / "_partner_scan.json").read_text(encoding="utf-8"))
DUP = json.loads((HERE / "_dupcheck.json").read_text(encoding="utf-8")) if (HERE / "_dupcheck.json").exists() else {}
CN = json.loads(s.COUNTS.read_text(encoding="utf-8"))
ST = {(r["table"], r["column"]): r for r in json.loads((HERE / "_scan_stats.json").read_text(encoding="utf-8"))["rows"]}
EX = json.loads((HERE / "_pop_extra.json").read_text(encoding="utf-8"))["rows"]
measured = {(k.split(".", 1)[1], c): v for k, e in CN.items() for c, v in e.get("cols", {}).items()}
tmp = HERE / "_src_copy.xlsx"; shutil.copy2(s.SRC, tmp)
wbs = openpyxl.load_workbook(tmp, read_only=True, data_only=True)
r1 = list(wbs["1_컬럼판정"].iter_rows(values_only=True)); h1 = [str(c) for c in r1[0]]
def num(v):
    try: return int(str(v).replace(",", ""))
    except Exception: return None
ASIS = {}; STATE = {}
for r in r1[1:]:
    if r and r[1]:
        ASIS[(r[1], r[2])] = dict(dash=num(r[h1.index("AS-IS '-' 행수(10-01)")]), blank=num(r[h1.index("AS-IS 빈값 행수(10-01, ''+' ' 합산)")]))
        STATE[(r[1], r[2])] = r[h1.index("현재 DB 상태")]
for t, e in PS.items():
    for c, a in e.get("asis", {}).items():
        if a and "missing" not in a and (t, c) not in ASIS: ASIS[(t, c)] = dict(dash=a["dash"], blank=a["null"] + a["empty"] + a["space"])
# 현재 DEFAULT (사내 사전)
cur = s.connect().cursor()
cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual"); at = cur.fetchone()[0]
cur.execute("SELECT TABLE_NAME, COLUMN_NAME, NULLABLE, DEFAULT_ON_NULL, DATA_DEFAULT FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'")
DFT = {(t, c): (n, o, (str(d).strip() if d is not None else None)) for t, c, n, o, d in cur}

# ── ① DEFAULT ──
cols = []
for c in s.population(): cols.append((c["table"], c["column"], "1차 목록"))
for e in EX: cols.append((e["table"], e["column"], "정제전 탈락 추가" if e.get("kind") != "new_table" else "신규 테이블"))
seen = set(); DEF = []; cnt = collections.Counter()
for t, c, src in cols:
    if (t, c) in seen: continue
    seen.add((t, c))
    n, on, d = DFT.get((t, c), (None, None, None))
    if n is None: apply, why = "미적용", "사내 DB 에 컬럼 없음"
    elif n == "Y": apply, why = "미적용", "NULL 허용 컬럼 — 대상 아님"
    elif d is None or d == "'-'": apply, why = "'/'", ("현재 DEFAULT 없음 → 신설" if d is None else "현재 '-' → '/'")
    else: apply, why = f"{d} 유지", "기존 DEFAULT 가 '-' 아님 → 유지"
    cnt[apply if apply in ("'/'", "미적용") else "기존값 유지"] += 1
    ddl = f"ALTER TABLE SCM_MGR.{t} MODIFY ({c} DEFAULT ON NULL '/');" if apply == "'/'" else ""
    DEF.append([t, c, src, d, "YES" if on == "YES" else "", apply, why, ddl])
DEF.sort(key=lambda r: (r[5] != "'/'", r[0], r[1]))

# ── ② DML ──
DML = []; dcnt = collections.Counter()
exclude_tab = {"SCM_ADM_LOOKUP_MASTER_DETAIL"}
newtab = {(e["table"], e["column"]) for e in EX if e.get("kind") == "new_table"}
dup_tabs = {}
for k, d in DUP.items():
    if d.get("dup_groups"): dup_tabs[d["table"]] = f"PK 중복 가능 {d['dup_groups']:,}그룹 — 변환 전 키 확인"
for t, c, src, d, on, apply, why, ddl in DEF:
    if apply == "미적용" or (t, c) in newtab or t in exclude_tab: continue
    m = measured.get((t, c)); st = ST.get((t, c)) or {}; a = ASIS.get((t, c)) or {}
    if m is not None: now_dash, now_blank, basis = m["dash"], m["blank"], "실측"
    elif t in s.SKIP: now_dash, now_blank, basis = None, None, "1억 초과 — 실측 제외"
    elif st.get("flag") == "none": now_dash, now_blank, basis = 0, None, f"통계('-' 없음, {st.get('analyzed')})"
    else: now_dash, now_blank, basis = None, None, f"통계 불명({st.get('flag')})"
    asis_dash = a.get("dash"); asis_blank = a.get("blank")
    # 사용자 지시(10-07 저녁): AS-IS 에 '-' 가 있던 컬럼은 TO-BE 에서도 '-' 를 그대로 쓴다 → DML 대상 아님(기존 로직 유지)
    if (asis_dash or 0) > 0:
        dcnt["DML 없음(AS-IS '-' 사용 컬럼 — 기존 로직 유지)"] += 1; continue
    if now_dash == 0 and not (now_blank or 0):
        dcnt["DML 없음(바뀔 행 없음)"] += 1; continue
    if asis_dash is None:
        mode = "확인 필요"; after = "AS-IS 에 '-' 가 있었는지 미확인 — 있으면 DML 없음, 없으면 일괄"; stmt = ""
    else:
        mode = "일괄"
        after = (f"'-'·공백 {((now_dash or 0) + (now_blank or 0)):,}행 → '/' · '-' 0행" if now_dash is not None else "현재 행수 미실측 — AS-IS 에 '-' 없으므로 TO-BE '-' 는 전부 빈값 유래 → 일괄 가능")
        stmt = f"UPDATE SCM_MGR.{t} SET {c} = '/' WHERE {c} = '-' OR TRIM({c}) IS NULL;"
    dcnt[mode] += 1
    DML.append([t, c, src, now_dash, now_blank, basis, asis_dash, asis_blank, mode, after, stmt, dup_tabs.get(t, "")])
DML.sort(key=lambda r: (["일괄", "확인 필요"].index(r[8]), r[0], r[1]))

wb = openpyxl.Workbook()
def sheet(name, head, rows, widths):
    w = wb.create_sheet(name); w.append(head)
    for x in w[1]: x.font = Font(bold=True, color="FFFFFF"); x.fill = PatternFill("solid", fgColor="305496"); x.alignment = Alignment(wrap_text=True, vertical="center")
    for r in rows: w.append(["" if v is None else v for v in r])
    for i, wd in enumerate(widths, 1): w.column_dimensions[get_column_letter(i)].width = wd
    w.freeze_panes = "C2"; w.auto_filter.ref = w.dimensions
sheet("1_DEFAULT", ["테이블", "컬럼", "출처", "현재 DEFAULT", "ON NULL", "적용", "사유", "DDL (검토용 — 실행하지 않음)"], DEF, [34, 26, 14, 14, 8, 12, 30, 80])
sheet("2_DML", ["테이블", "컬럼", "출처", "현재 TO-BE '-' 행", "현재 TO-BE 공백만 행", "현재값 근거", "AS-IS 실제 '-' 행", "AS-IS 빈값 행", "변경 방식", "변경 후 모습", "DML (검토용 — 실행하지 않음)", "주의"],
      DML, [34, 26, 14, 14, 14, 26, 12, 12, 18, 70, 90, 36])
ws = wb.active; ws.title = "요약"
dup_done = [d for d in DUP.values() if "error" not in d]
S = [["NULL 센티널 '/' 전환 — DEFAULT · DML 정리"], [], ["작성", datetime.datetime.now().strftime("%Y-%m-%d %H:%M"), f"사내 ZIOUI1 컬럼 사전 {at}"],
     ["원칙", "AS-IS 에 '-' 가 있던 컬럼은 TO-BE 에서도 '-' 그대로(기존 로직 유지) → DML 대상 아님. DML 은 AS-IS 에 '-' 가 전혀 없던 컬럼에서 이관·DEFAULT 로 생긴 '-' 와 공백만 '/'. DEFAULT 는 대상 컬럼 전부 '/'(기존 'N' 등은 유지)."], [],
     ["① DEFAULT", len(DEF), json.dumps(dict(cnt), ensure_ascii=False)],
     ["   미적용(별도)", "", "백업·테스트·CDC 복사본 의심 신규 테이블 3,454 컬럼 — DEFAULT범위_확대후보_20261007.xlsx 시트 3 (운영 테이블이면 추가)"],
     ["② DML", len(DML), json.dumps(dict(dcnt), ensure_ascii=False)],
     ["   일괄", dcnt["일괄"], "AS-IS 에 '-' 가 없던 컬럼 → UPDATE … WHERE col='-' OR TRIM(col) IS NULL (TO-BE 이관·DEFAULT 로 생긴 '-' 와 공백만 바뀜)"],
     ["   확인 필요", dcnt["확인 필요"], "AS-IS 실측이 없는 컬럼(추가분 등) — AS-IS 에 '-' 가 있었으면 DML 없음, 없었으면 일괄"],
     ["   DML 없음(AS-IS '-' 사용)", dcnt["DML 없음(AS-IS '-' 사용 컬럼 — 기존 로직 유지)"], "AS-IS 에 '-' 가 있던 컬럼 → TO-BE '-' 그대로, 기존 '-' 로직 유지. 단, 이관 때 빈값에서 '-' 가 된 행도 '-' 로 남고 앞으로 들어오는 빈값은 '/' 가 됨(DEFAULT) — 같은 컬럼에 '-'·'/' 가 섞이는 점은 인지 필요"],
     ["   DML 없음(바뀔 행 없음)", dcnt["DML 없음(바뀔 행 없음)"], "TO-BE 에 '-'·공백 행 0 → UPDATE 문을 만들지 않음"],
     ["   보류 51 · 코드 마스터", "", "AS-IS '-' 사용 컬럼이라 위와 같이 DML 없음, DEFAULT 만 '/'"],
     ["   신규 테이블", "", "DEFAULT 만 '/', DML 없음"], [],
     ["코드(PKG/SP)", "", "변경 없음 — 범위 밖 컬럼을 '/' 와 비교하게 되는 87줄은 '-' 유지, 코드 마스터 NVL 198줄은 무동작이라 불필요 (상세: 슬래시전환_변환전후비교_20261007.xlsx)"],
     ["PK 중복 시뮬레이션", f"{len(dup_done)}/12", f"중복 있음 {sum(1 for d in dup_done if d.get('dup_groups'))} — 있으면 2_DML '주의' 열에 표시"], [],
     ["한계"], ["  '현재 TO-BE 행' 이 통계 기준인 컬럼은 실측이 아님. 1억 초과 2 테이블·3천만 초과 테이블은 실측 생략."],
     ["  AS-IS 빈값·'-' 행수는 DEV(10-01) 기준(NULL 미포함). 운영 원천이면 다를 수 있음."], ["  DB 변경 없음 — DDL·DML 은 검토용 문자열."]]
for r in S: ws.append(r)
ws["A1"].font = Font(bold=True, size=13); ws.column_dimensions["A"].width = 28; ws.column_dimensions["B"].width = 10; ws.column_dimensions["C"].width = 130
out = HERE / "슬래시전환_DEFAULT_DML_정리_20261007.xlsx"; wb.save(out); print(out); print("DEFAULT", dict(cnt)); print("DML", dict(dcnt))
