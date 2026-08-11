#!/usr/bin/env python3
"""
wiring_chain_check.py — FE→BE→SP 배선 체인 자동 검증기 (2026-08-07 신설)

배경: DMF0072 유형 사고(FE 는 완성·BTN_MPG SAVE 의 API_ID 가 API_M 에 없어 저장 불통) 를
      "지적 이전" 에 자동 검출. 근본해결 도구 4종 중 ② (최우선).
정본 해석 체인: PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST (ALL_SOURCE 실측 2026-08-07)
      BTN_MPG(MNU_ID,SHT_NM,MNU_BTN_CD) → API_ID → API_M.API_URL(=PROC_NM) → PROC_M 컬럼 메타

검증 링크 (각 링크 실측 — SELECT only):
  L1  FE: features/*/src/pages/*/ 에서 MENU_ID 상수 보유 폴더 + SHEETS enum 값 전수 추출
  L2  각 (MNU_ID, SHT_NM=SHEETS값) 에 BTN_MPG 행 존재
  L2A ⭐ v2(2026-08-07 액션 축): FE 실사용 액션 (MNU_ID, SHT_NM, MNU_BTN_CD) 단위 BTN_MPG 존재
      — 원천 ①`/{MENU}/{sheet}/{ACTION}/call-proc` 리터럴 ②useTabProcQuery(→SEARCH)/useProcMutation(→SAVE)
        ③hotkeyConfig 활성 search/insert/delete/save. **모달 파일(components/**/*Modal|Dialog*.tsx) 포함 전 파일 스캔**
  L2P ⭐ v2(권한 축): 위 각 액션의 SCM_ADM_USER_GR_MNU_BTN_MPG_M ≥1 그룹 (0그룹 = 아무도 사용 불가)
  L3  BTN_MPG.API_ID → API_M 행 존재 · USE_YN='Y'  (SEARCH/SAVE 의 API_ID NULL 도 FAIL)
  L4  API_M.API_URL(PROC_NM) → PROC_M 행수 > 0
  L5  PROC_NM 이 실제 SP(PKG 멤버 또는 standalone) 로 존재 · VALID
  L6  PROC_M positional ↔ ALL_ARGUMENTS (개수 · IN/OUT · 순서) 대조
  L7  (역방향) BTN_MPG 에는 있는데 FE SHEETS 에 없는 시트 = 미사용 배선 [WARN]

사용:
  python wiring_chain_check.py --menu DMF0072            # 단건
  python wiring_chain_check.py --all                     # 전 화면 소급 스윕
  python wiring_chain_check.py --all --report out.md     # 스윕 + 판정표 md 저장
  exit code: 0 = 전 링크 PASS(WARN 허용) / 1 = FAIL 존재 / 2 = 실행 오류

추출 한계 (anti-simplification §2.1 [필수 4] 명시):
  - FE 시트 원천은 페이지 폴더 내 *.constants.ts 의 `enum SHEETS` + `const SHEETS = {...}` 두 형태만
    파싱한다. 문자열 리터럴로 직접 sheetName 을 넘기는 비표준 코드는 L2 대상에 잡히지 않는다
    (역방향 L7 이 이 경우를 미사용 배선 WARN 으로 노출).
  - DB 는 SCM_MGR 스키마 기준(ALL_*). 타 스키마 synonym 경유는 ALL_SYNONYMS 1단 해석까지만.
"""
import argparse
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
FE_PAGES_GLOB = "features/*/src/pages/*/"
FE_ROOT = ROOT / "nscm-fe"

RE_MENU_ID = re.compile(r"\bMENU_ID\s*=\s*'([A-Z]{2,4}\d{4})'")
# 주의: `[^}]*` 금지 — 주석 속 `#{shtNm}` 의 `}` 에서 조기 종료 (DMF0074 실측). 행 시작 `}` 까지 비탐욕.
RE_ENUM_SHEETS = re.compile(r"enum\s+SHEETS\s*\{(.*?)\n\}", re.S)
RE_CONST_SHEETS = re.compile(r"const\s+SHEETS\s*=\s*\{(.*?)\n\}", re.S)
RE_CONST_SHEET_NAME = re.compile(r"\bconst\s+SHEET_NAME\s*=\s*'([^']+)'")  # DMF0007 단일 시트 변형
RE_STR_VAL = re.compile(r"[:=]\s*'([^']+)'")


def strip_ts_comments(text: str) -> str:
    """TS/JS 주석(`//`, `/* */`)을 **공백으로 치환**해 제거 (문자열·템플릿 리터럴 내부는 보존).

    ⚠️ 2026-08-09 정정 — 주석을 지우지 않아 `enum SHEETS { ... }` **블록 주석 안의**
      `P_CATE='BP'` 가 enum 멤버로 추출됐다(DMF0042 실측 → 존재하지 않는 시트 'BP' 로 L2 FAIL 오탐).
      길이를 보존(공백 치환)해 다른 regex 의 span 계산과 어긋나지 않게 한다.
    """
    out = list(text)
    i, n = 0, len(text)
    quote = None  # 현재 열려 있는 따옴표 문자
    while i < n:
        c = text[i]
        if quote:
            if c == "\\":
                i += 2
                continue
            if c == quote:
                quote = None
            i += 1
            continue
        if c in "'\"`":
            quote = c
            i += 1
            continue
        if c == "/" and i + 1 < n and text[i + 1] == "/":
            while i < n and text[i] != "\n":
                out[i] = " "
                i += 1
            continue
        if c == "/" and i + 1 < n and text[i + 1] == "*":
            while i < n and not (text[i] == "*" and i + 1 < n and text[i + 1] == "/"):
                if text[i] != "\n":
                    out[i] = " "
                i += 1
            for _ in range(2):
                if i < n:
                    out[i] = " "
                    i += 1
            continue
        i += 1
    return "".join(out)

# 판정 정책: SEARCH/SAVE 버튼의 API 미배선 = FAIL (조회·저장 불통), 그 외 버튼 = WARN(FE-local 가능)
API_MANDATORY_BTNS = {"SEARCH", "SAVE"}

# BE 정본 (BaseService.makeProcedure L367~398 실측 2026-08-07):
#   COL_TP_CD 는 .equals("IN")/.equals("OUT") 정확 일치만 바인딩 — 'I'/'O' 등은 행 자체 SKIP = 결함
#   DATA_TP_CD 는 아래 8종만 placeholder 생성 — 그 외('VARCHAR2' 등)는 placeholder 누락 = malformed call
BE_KNOWN_DATA_TP = {"VARCHAR", "JVARCHAR", "NUMBER", "CLOB", "NUMERIC", "DATE", "CURSOR", "PROC_RESULT"}
TYPE_COMPAT = {
    # PROC_M DATA_TP_CD → 허용 SP 타입 (jdbc 바인딩 기준). set 밖 = 판정 대상
    "VARCHAR": {"VARCHAR2", "CHAR", "NVARCHAR2", "NCHAR", "CLOB"},
    "JVARCHAR": {"VARCHAR2", "CHAR", "CLOB"},  # BE 는 jdbcType=VARCHAR 로 바인딩 (BaseService L375)
    "NUMBER": {"NUMBER", "FLOAT", "BINARY_DOUBLE", "BINARY_FLOAT", "INTEGER", "BINARY_INTEGER", "PLS_INTEGER"},
    "NUMERIC": {"NUMBER", "FLOAT", "BINARY_DOUBLE", "BINARY_FLOAT", "INTEGER", "BINARY_INTEGER", "PLS_INTEGER"},
    "DATE": {"DATE", "TIMESTAMP"},
    "CLOB": {"CLOB", "VARCHAR2"},
    "CURSOR": {"REF CURSOR"},
    "PROC_RESULT": {"REF CURSOR"},
}
# 암묵 형변환으로 동작은 하나 NLS 위험(hook #109) — WARN 강등 쌍
TYPE_IMPLICIT_WARN = {("VARCHAR", "NUMBER"), ("VARCHAR", "DATE"), ("VARCHAR", "FLOAT")}


# ──────────────────────────────────────────────────────────────────────────────
# L1. FE 스캔
# ──────────────────────────────────────────────────────────────────────────────
# ── v2 액션 축 추출 regex (2026-08-07) ────────────────────────────────────────
RE_ENUM_MEMBER = re.compile(r"([A-Z0-9_]+)\s*=\s*'([^']+)'")
RE_CALLPROC_ENUM = re.compile(r"/\$\{MENU_ID\}/\$\{SHEETS\.([A-Z0-9_]+)\}/([A-Z_]+)/call-proc")
RE_CALLPROC_SHEETNAME = re.compile(r"/\$\{MENU_ID\}/\$\{SHEET_NAME\}/([A-Z_]+)/call-proc")
RE_CALLPROC_LITERAL = re.compile(r"/\$\{MENU_ID\}/([a-zA-Z][a-zA-Z0-9]*)/([A-Z_]+)/call-proc")
RE_CALLPROC_FULL_LITERAL = re.compile(r"['\"`]/([A-Z]{2,4}\d{4})/([a-zA-Z][a-zA-Z0-9]*)/([A-Z_]+)/call-proc")
RE_CALLPROC_DYNAMIC = re.compile(r"/call-proc")
RE_HOOK_QUERY = re.compile(r"useTabProcQuery\s*(?:<[^>]*>)?\s*\(")
RE_HOOK_MUTATION = re.compile(r"useProcMutation\s*(?:<[^>]*>)?\s*\(")
RE_SHEETNAME_ARG = re.compile(r"sheetName\s*:\s*(?:SHEETS\.([A-Z0-9_]+)|SHEET_NAME|'([^']+)')")
RE_GENERIC_SHEET = re.compile(r"<\s*(?:typeof\s+)?MENU_ID\s*,\s*SHEETS\.([A-Z0-9_]+)")
RE_GENERIC_OTHER_MENU = re.compile(r"<\s*'([A-Z]{2,4}\d{4})'")  # <'COM0008', ...> 타 메뉴 공용 호출
RE_MENUID_ARG_LITERAL = re.compile(r"menuId\s*:\s*'([A-Z]{2,4}\d{4})'")
RE_HOTKEY_BLOCK = re.compile(r"hotkeyConfig\s*[:=][^;]{0,40}\{")
RE_HOTKEY_KEYS = re.compile(r"\b(search|insert|delete|save)\s*:\s*([^,}\n]+)")  # 값 false = 비활성(제외)
HOTKEY_TO_BTN = {"search": "SEARCH", "insert": "INSERT", "delete": "DELETE", "save": "SAVE"}


def extract_fe_actions(folder, enum_map, single_sheet, page_menu_id=None):
    """FE 실사용 액션 전수 — {(sheet, ACTION): set(원천파일)} + hotkey {ACTION: set(파일)} + dynamic [파일].

    스캔 대상 = 페이지 폴더 전 .ts/.tsx (모달 components/**/*Modal|Dialog*.tsx 포함)."""
    actions, hotkeys, dynamic, gate_codes = {}, {}, [], set()
    btn_gates = set()  # 페이지 전체 hasButton('X') — L3 UI 전용 버튼 판정용
    for f in sorted(list(folder.rglob("*.ts")) + list(folder.rglob("*.tsx"))):
        # 주석 제거(길이 보존) — 주석에 적힌 call-proc URL·hotkeyConfig 예시가 **실사용 액션**으로
        #   집계되는 오탐 차단(2026-08-09, enum 'BP' 오탐과 동일 계보).
        text = strip_ts_comments(f.read_text(encoding="utf-8", errors="ignore"))
        rel = str(f.relative_to(folder)).replace("\\", "/")
        covered_spans = []
        # ① call-proc 리터럴 (enum / SHEET_NAME / 시트 리터럴 / 전체 리터럴)
        for m in RE_CALLPROC_ENUM.finditer(text):
            sheet = enum_map.get(m.group(1))
            if sheet:
                actions.setdefault((sheet, m.group(2)), set()).add(rel)
            covered_spans.append(m.span())
        for m in RE_CALLPROC_SHEETNAME.finditer(text):
            if single_sheet:
                actions.setdefault((single_sheet, m.group(1)), set()).add(rel)
            covered_spans.append(m.span())
        for m in RE_CALLPROC_LITERAL.finditer(text):
            if any(s <= m.start() < e for s, e in covered_spans):
                continue
            actions.setdefault((m.group(1), m.group(2)), set()).add(rel)
            covered_spans.append(m.span())
        for m in RE_CALLPROC_FULL_LITERAL.finditer(text):
            actions.setdefault((m.group(2), m.group(3)), set()).add(rel)
            covered_spans.append(m.span())
        # 미해석 call-proc (동적 `${sheet}/${btnCd}` 등)
        for m in RE_CALLPROC_DYNAMIC.finditer(text):
            if not any(s <= m.start() < e or (m.end() >= s and m.start() <= e) for s, e in covered_spans):
                dynamic.append(rel)
                break
        # ② useTabProcQuery → SEARCH / ③ useProcMutation → SAVE
        for rx, action in ((RE_HOOK_QUERY, "SEARCH"), (RE_HOOK_MUTATION, "SAVE")):
            for m in rx.finditer(text):
                head = text[max(0, m.start() - 20) : m.end() + 200]
                args_win = text[m.end() : m.end() + 500]
                # 타 메뉴 공용 호출 (<'COM0008',...> / menuId:'COM0008') — 본 화면 배선 검증 대상 아님
                other = RE_GENERIC_OTHER_MENU.search(head) or RE_MENUID_ARG_LITERAL.search(args_win)
                if other and page_menu_id and other.group(1) != page_menu_id:
                    continue
                sheet = None
                g = RE_GENERIC_SHEET.search(head)
                if g:
                    sheet = enum_map.get(g.group(1))
                if not sheet:
                    a = RE_SHEETNAME_ARG.search(args_win)
                    if a:
                        sheet = enum_map.get(a.group(1)) if a.group(1) else (a.group(2) or single_sheet)
                if sheet:
                    actions.setdefault((sheet, action), set()).add(rel)
                else:
                    dynamic.append(f"{rel} ({action} 시트 미해석)")
        for g in re.findall(r"hasButton\(\s*'([A-Z_]+)'\s*\)", text):
            btn_gates.add(g)

        # ④ hotkeyConfig 활성 키 (+ 블록 내 hasButton 게이트 코드)
        for m in RE_HOTKEY_BLOCK.finditer(text):
            # 탐지 창 확대 (2026-08-08) — hotkeyConfig 가 길면 2000자 뒤 키를 놓친다
            block = text[m.end() : m.end() + 8000]
            # ⭐ 2026-08-08 — 실제 노출 게이트를 읽는다. FE 는 여러 hotkey 를 **하나의 버튼 권한**으로
            #   묶어 게이트하는 경우가 있다(예: DMF0082 `hasButton('SAVE') ? {insert, delete, save}`).
            #   이때 delete 전용 권한이 0그룹이어도 버튼은 정상 노출되므로 "비표시" 라는 판정이 틀린다.
            for g in re.findall(r"hasButton\(\s*'([A-Z_]+)'\s*\)", block):
                gate_codes.add(g)
            for k, val in RE_HOTKEY_KEYS.findall(block):
                if val.strip() == "false":  # 명시 비활성 (조회 전용 화면 등) — 액션 아님
                    continue
                hotkeys.setdefault(HOTKEY_TO_BTN[k], set()).add(rel)
    return actions, hotkeys, sorted(set(dynamic)), gate_codes, btn_gates


def scan_fe_pages():
    """{menu_id: {'folders':[Path], 'sheets':{sheet:[정의파일]}, 'actions':{(sheet,ACTION):set(src)},
        'hotkeys':{ACTION:set(src)}, 'dynamic':[src]}} — 폴더 전수 (v2: 액션 축 포함)."""
    pages = {}
    no_menu_id = []
    for folder in sorted(FE_ROOT.glob(FE_PAGES_GLOB)):
        if not folder.is_dir():
            continue
        menu_id, sheets, enum_map, single_sheet = None, {}, {}, None
        const_files = sorted(folder.rglob("*.constants.ts"))
        for cf in const_files:
            # 주석 제거본으로 시트/메뉴 추출 — 주석 속 `X='Y'` 를 enum 멤버로 오인하지 않게 한다(2026-08-09).
            text = strip_ts_comments(cf.read_text(encoding="utf-8", errors="ignore"))
            m = RE_MENU_ID.search(text)
            if m and not menu_id:
                menu_id = m.group(1)
            for block_re in (RE_ENUM_SHEETS, RE_CONST_SHEETS):
                for blk in block_re.finditer(text):
                    for member, v in RE_ENUM_MEMBER.findall(blk.group(1)):
                        sheets.setdefault(v, []).append(str(cf.relative_to(FE_ROOT)))
                        enum_map.setdefault(member, v)
            for m2 in RE_CONST_SHEET_NAME.finditer(text):
                sheets.setdefault(m2.group(1), []).append(str(cf.relative_to(FE_ROOT)))
                single_sheet = single_sheet or m2.group(1)
        if menu_id:
            actions, hotkeys, dynamic, gate_codes, btn_gates = extract_fe_actions(
                folder, enum_map, single_sheet, menu_id
            )
            entry = pages.setdefault(
                menu_id,
                {"folders": [], "sheets": {}, "actions": {}, "hotkeys": {},
                 "dynamic": [], "gates": set(), "btnGates": set()},
            )
            entry.setdefault("gates", set()).update(gate_codes)
            entry.setdefault("btnGates", set()).update(btn_gates)
            entry["folders"].append(folder)
            for s, srcs in sheets.items():
                entry["sheets"].setdefault(s, []).extend(srcs)
            for k, srcs in actions.items():
                entry["actions"].setdefault(k, set()).update(srcs)
            for k, srcs in hotkeys.items():
                entry["hotkeys"].setdefault(k, set()).update(srcs)
            entry["dynamic"].extend(dynamic)
        else:
            no_menu_id.append(folder)
    return pages, no_menu_id


# ──────────────────────────────────────────────────────────────────────────────
# DB 실측 (SELECT only)
# ──────────────────────────────────────────────────────────────────────────────
def chunks(lst, n=900):
    for i in range(0, len(lst), n):
        yield lst[i : i + n]


def q_in(cur, sql_tpl, values):
    """IN 리스트 bind 분할 실행 → 행 합집합."""
    rows = []
    for ch in chunks(sorted(set(values))):
        binds = {f"b{i}": v for i, v in enumerate(ch)}
        placeholders = ",".join(f":b{i}" for i in range(len(ch)))
        cur.execute(sql_tpl.format(inlist=placeholders), binds)
        rows.extend(cur.fetchall())
    return rows


def fetch_db(menu_ids):
    import oracledb

    u, p, d = conn_info()
    out = {}
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        # BTN_MPG + API_M
        out["btn"] = q_in(
            cur,
            """SELECT T1.MNU_ID, T1.SHT_NM, T1.MNU_BTN_CD, T1.API_ID, T1.USE_YN,
                      T2.API_URL, T2.USE_YN
                 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M T1
                 LEFT JOIN SCM_MGR.SCM_ADM_API_M T2 ON T1.API_ID = T2.API_ID
                WHERE T1.MNU_ID IN ({inlist})""",
            menu_ids,
        )
        proc_nms = sorted({r[5] for r in out["btn"] if r[5]})
        # PROC_M
        out["proc_m"] = (
            q_in(
                cur,
                """SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD
                     FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM IN ({inlist})""",
                proc_nms,
            )
            if proc_nms
            else []
        )
        # SP 존재·VALID + ALL_ARGUMENTS
        names = sorted({(pn.split(".", 1) + [None])[0] if "." not in pn else pn.split(".", 1)[0] for pn in proc_nms} | {pn.split(".", 1)[1] for pn in proc_nms if "." in pn} | {pn for pn in proc_nms if "." not in pn})
        out["objects"] = (
            q_in(
                cur,
                """SELECT object_name, object_type, status FROM all_objects
                    WHERE owner='SCM_MGR' AND object_name IN ({inlist})
                      AND object_type IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY','SYNONYM')""",
                names,
            )
            if names
            else []
        )
        out["pkg_procs"] = (
            q_in(
                cur,
                """SELECT object_name, procedure_name FROM all_procedures
                    WHERE owner='SCM_MGR' AND object_name IN ({inlist})
                      AND procedure_name IS NOT NULL""",
                sorted({pn.split(".", 1)[0] for pn in proc_nms if "." in pn}),
            )
            if any("." in pn for pn in proc_nms)
            else []
        )
        arg_names = sorted({pn.split(".", 1)[1] if "." in pn else pn for pn in proc_nms})
        out["args"] = (
            q_in(
                cur,
                """SELECT NVL(package_name,'-'), object_name, NVL(overload,'1'),
                          position, argument_name, data_type, in_out
                     FROM all_arguments
                    WHERE owner='SCM_MGR' AND object_name IN ({inlist}) AND data_level = 0
                    ORDER BY package_name, object_name, overload, position""",
                arg_names,
            )
            if arg_names
            else []
        )
        # 권한 (v2 L2P) — 액션별 허용 그룹 수
        out["perms"] = q_in(
            cur,
            """SELECT MNU_ID, SHT_NM, MNU_BTN_CD, COUNT(DISTINCT USER_GR_ID)
                 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
                WHERE USE_YN = 'Y' AND MNU_ID IN ({inlist})
                GROUP BY MNU_ID, SHT_NM, MNU_BTN_CD""",
            menu_ids,
        )
        # synonym 1단 해석 (standalone 미발견 대비)
        out["synonyms"] = (
            q_in(
                cur,
                """SELECT synonym_name, table_owner, table_name FROM all_synonyms
                    WHERE owner IN ('SCM_MGR','PUBLIC') AND synonym_name IN ({inlist})""",
                sorted({pn for pn in proc_nms if "." not in pn}),
            )
            if any("." not in pn for pn in proc_nms)
            else []
        )
    return out


# ──────────────────────────────────────────────────────────────────────────────
# 링크 판정
# ──────────────────────────────────────────────────────────────────────────────
def build_indexes(db):
    idx = {}
    idx["btn_by_menu"] = {}
    for r in db["btn"]:
        idx["btn_by_menu"].setdefault(r[0], []).append(r)
    idx["proc_m_by_nm"] = {}
    for r in db["proc_m"]:
        idx["proc_m_by_nm"].setdefault(r[0], []).append(r)
    for v in idx["proc_m_by_nm"].values():
        v.sort(key=lambda x: x[4])
    idx["obj_status"] = {}
    for name, otype, status in db["objects"]:
        idx["obj_status"].setdefault(name, {})[otype] = status
    idx["pkg_members"] = {}
    for pkg, proc in db["pkg_procs"]:
        idx["pkg_members"].setdefault(pkg, set()).add(proc)
    idx["args"] = {}
    for pkg, obj, ovl, pos, aname, dtype, inout in db["args"]:
        idx["args"].setdefault((pkg, obj), {}).setdefault(ovl, []).append((pos, aname, dtype, inout))
    idx["synonyms"] = {s: (o, t) for s, o, t in db["synonyms"]}
    idx["perms"] = {(m, s, b): c for m, s, b, c in db.get("perms", [])}
    return idx


def check_sp(proc_nm, idx):
    """L5: (존재여부, VALID여부, 상세)"""
    if "." in proc_nm:
        pkg, member = proc_nm.split(".", 1)
        if member not in idx["pkg_members"].get(pkg, set()):
            return False, False, f"PKG '{pkg}' 에 멤버 '{member}' 없음 (ALL_PROCEDURES)"
        st = idx["obj_status"].get(pkg, {})
        spec, body = st.get("PACKAGE"), st.get("PACKAGE BODY")
        if spec != "VALID" or body != "VALID":
            return True, False, f"PKG 상태 spec={spec}/body={body}"
        return True, True, "PKG 멤버 VALID"
    st = idx["obj_status"].get(proc_nm, {})
    for t in ("PROCEDURE", "FUNCTION"):
        if t in st:
            return (True, st[t] == "VALID", f"standalone {t} {st[t]}")
    if proc_nm in idx["synonyms"]:
        return True, True, f"SYNONYM → {idx['synonyms'][proc_nm]} (상태 미해석 — 한계 명시)"
    return False, False, "SCM_MGR 에 PROCEDURE/FUNCTION/SYNONYM 없음 (ALL_OBJECTS)"


def check_args(proc_nm, idx):
    """L6: PROC_M positional ↔ ALL_ARGUMENTS (BE BaseService 바인딩 의미론 기준).

    return (fails:list, warns:list) — 빈 리스트 = 이상 없음."""
    pm = idx["proc_m_by_nm"].get(proc_nm, [])
    if not pm:
        return [], []  # L4 에서 이미 FAIL
    fails, warns = [], []
    # BE 정본: COL_TP_CD 'IN'/'OUT' 정확 일치 외 행은 바인딩 SKIP → 그 자체가 결함
    for r in pm:
        ctp, dtp = r[3], r[2]
        if ctp not in ("IN", "OUT"):
            fails.append(f"SORT_ORD {r[4]} '{r[1]}' COL_TP_CD='{ctp}' — BE .equals('IN'/'OUT') 불일치, 바인딩 제외됨 (BaseService L371/L383)")
        elif dtp not in BE_KNOWN_DATA_TP:
            fails.append(f"SORT_ORD {r[4]} '{r[1]}' DATA_TP_CD='{dtp}' — BE 미인식(8종 외), placeholder 누락 = malformed call")
    if fails:
        return fails, warns  # 코드 자체가 깨진 상태 — positional 대조는 무의미
    key = tuple(proc_nm.split(".", 1)) if "." in proc_nm else ("-", proc_nm)
    overloads = idx["args"].get(key)
    if not overloads:
        return ["ALL_ARGUMENTS 0행 (SP 부재/파라미터 없음) — L5 참조"], warns
    pm_seq = [(r[3], r[2]) for r in pm]  # (COL_TP_CD, DATA_TP_CD) by SORT_ORD
    best = None  # (fail수+warn수, fails, warns)
    for ovl, args in overloads.items():
        args = [a for a in args if a[0] and a[0] > 0]  # position 0 = function return 제외
        f, w = [], []
        if len(pm_seq) != len(args):
            f.append(f"개수 불일치 PROC_M {len(pm_seq)} vs ALL_ARGUMENTS {len(args)}")
        for i, ((ctp, dtp), (pos, aname, adtype, ainout)) in enumerate(zip(pm_seq, args), 1):
            want_io = "OUT" if ctp == "OUT" else "IN"
            if ainout not in (want_io, "IN/OUT"):
                f.append(f"pos{i} IN/OUT 불일치: PROC_M {ctp} vs SP {aname} {ainout}")
                continue
            compat = TYPE_COMPAT.get(dtp, {dtp})
            if adtype not in compat:
                if (dtp, adtype) in TYPE_IMPLICIT_WARN:
                    w.append(f"pos{i} 암묵 형변환: PROC_M {dtp} → SP {aname} {adtype} (동작하나 NLS 위험 — hook #109)")
                else:
                    f.append(f"pos{i} 타입 불일치: PROC_M {dtp} vs SP {aname} {adtype}")
        if not f and not w:
            return [], []  # 하나의 overload 라도 완전 일치 = PASS
        if best is None or (len(f), len(w)) < (len(best[1]), len(best[2])):
            best = (ovl, f, w)
    return best[1], best[2]


def check_menu(menu_id, fe_entry, idx, known_issues=None):
    """한 화면 판정 → {'menu','folders','results':[(link,level,subject,detail)],'verdict'}"""
    results = []
    btn_rows = idx["btn_by_menu"].get(menu_id, [])
    fe_sheets = set(fe_entry["sheets"].keys()) if fe_entry else set()
    db_sheets = {r[1] for r in btn_rows}

    if fe_entry:
        results.append(("L1", "PASS", f"FE {len(fe_entry['folders'])}폴더", f"SHEETS {len(fe_sheets)}종: {', '.join(sorted(fe_sheets))}"))
    else:
        results.append(("L1", "WARN", "FE 폴더 미발견", "MENU_ID 상수 보유 페이지 폴더 없음 (DB-only 검증)"))

    if fe_entry and not fe_sheets:
        results.append(("L1", "FAIL", "SHEETS 추출 0", "constants 에 enum/const SHEETS 부재 — 파싱 한계 또는 비표준"))

    # L2
    for s in sorted(fe_sheets - db_sheets):
        results.append(("L2", "FAIL", f"sheet '{s}'", "BTN_MPG 행 0건 — 시트 배선 부재"))
    # L7
    for s in sorted(db_sheets - fe_sheets):
        lvl = "WARN" if fe_entry else "INFO"
        results.append(("L7", lvl, f"sheet '{s}'", "BTN_MPG 에만 존재 — FE SHEETS 미사용 배선(또는 리터럴 sheetName)"))

    # ── v2 액션 축 (2026-08-07): L2A 액션 단위 BTN_MPG + L2P 권한 ≥1그룹 ─────────
    btn_index = {(r[1], r[2]): r for r in btn_rows}
    if fe_entry:
        for (sheet, action), srcs in sorted(fe_entry.get("actions", {}).items()):
            src = ", ".join(sorted(srcs))
            is_modal = any(("Modal" in s or "Dialog" in s) for s in srcs)
            tag = " [모달]" if is_modal else ""
            row = btn_index.get((sheet, action))
            if row is None:
                results.append(("L2A", "FAIL", f"{sheet}/{action}{tag}", f"FE 실사용 액션인데 BTN_MPG 행 없음 (원천: {src})"))
                continue
            if row[4] == "N":
                results.append(("L2A", "FAIL", f"{sheet}/{action}{tag}", f"BTN_MPG USE_YN='N' — FE 는 호출 중 (원천: {src})"))
            gr = idx["perms"].get((menu_id, sheet, action), 0)
            if gr == 0:
                results.append(("L2P", "FAIL", f"{sheet}/{action}{tag}", f"USER_GR_MNU_BTN_MPG_M 0그룹 — 아무 그룹도 사용 불가 (원천: {src})"))
        # hotkey 활성 액션 — WARN 축 (FE 는 `hasButton(X) ? handler : false` 런타임 게이트가 표준이라
        #   권한/배선 0행 = "버튼 비표시" 로 무해할 수 있음. 단 기능 의도라면 등록 누락 — 의도 확인 노출.
        #   INSERT/DELETE 는 FE-local 그리드 조작(BTN_MPG API 배선 불필요, 실저장은 SAVE 경유) — SYS0002 정본 실측.
        for action, srcs in sorted(fe_entry.get("hotkeys", {}).items()):
            src = ", ".join(sorted(srcs))
            has_btn = any(r[2] == action and r[4] == "Y" for r in btn_rows)
            has_perm = any(b == action and c > 0 for (m, s, b), c in idx["perms"].items() if m == menu_id)
            if not has_perm:
                # 같은 hotkeyConfig 블록이 다른 버튼 코드로 게이트하면(예: hasButton('SAVE') 로 insert/delete/save
                # 일괄 노출) 해당 액션 전용 권한이 0그룹이어도 버튼은 정상 노출된다 — 오판정 방지.
                gate = next(
                    (g for g in sorted(fe_entry.get("gates", set()))
                     if any(b == g and c > 0 for (m, s, b), c in idx["perms"].items() if m == menu_id)),
                    None,
                )
                if gate:
                    results.append(("L2P", "INFO", f"hotkey {action}", f"{action} 전용 권한은 0그룹이지만 hotkeyConfig 가 hasButton('{gate}') 로 일괄 게이트 — 버튼 노출 정상 (원천: {src})"))
                else:
                    results.append(("L2P", "WARN", f"hotkey {action}", f"hotkeyConfig {action} 활성인데 권한(USER_GR) 0그룹 — hasButton 게이트로 버튼 비표시됨. 기능 의도면 권한 등록 필요 (원천: {src})"))
            elif action in ("SEARCH", "SAVE") and not has_btn:
                results.append(("L2A", "WARN", f"hotkey {action}", f"{action} 권한은 있는데 BTN_MPG 행 0건 — generic call 시 NO_DATA_FOUND 위험 (원천: {src})"))
        for d in fe_entry.get("dynamic", []):
            results.append(("L2A", "INFO", "동적 call-proc", f"정적 해석 불가 — 수동 확인 필요: {d}"))

    # L3~L6 (BTN_MPG 행 단위)
    seen_proc = set()
    for mnu, sht, btn, api_id, use_yn, api_url, api_use in sorted(btn_rows, key=lambda r: (r[1], r[2])):
        subj = f"{sht}/{btn}"
        if use_yn == "N":
            results.append(("L3", "INFO", subj, "BTN_MPG USE_YN='N' — 비활성 배선 (검증 제외)"))
            continue
        if not api_id:
            # ⭐ 2026-08-08 — UI 전용 버튼(권한 게이트 역할만) 은 API 배선이 없는 것이 정상이다.
            #   FE 가 `hasButton('EDIT')` 로 편집모드 토글 / `hasButton('INSERT')` 로 행 추가 노출만 하고,
            #   실제 저장은 SAVE 경유이므로 API_ID 가 없다(L2P 주석의 SYS0002 정본 실측과 동일 성격).
            #   판정 근거 = FE 가 그 코드를 hasButton 게이트로 소비하고 있을 것.
            if btn not in API_MANDATORY_BTNS and btn in fe_entry.get("btnGates", set()):
                results.append(("L3", "INFO", subj,
                                f"API_ID NULL — FE 가 hasButton('{btn}') 권한 게이트로만 소비하는 UI 전용 버튼 (실저장은 SAVE 경유)"))
                continue
            lvl = "FAIL" if btn in API_MANDATORY_BTNS else "WARN"
            results.append(("L3", lvl, subj, "API_ID NULL — 버튼 API 미배선"))
            continue
        if api_url is None:
            results.append(("L3", "FAIL", subj, f"API_ID '{api_id}' 가 API_M 에 없음 — DMF0072 유형(체인 단절)"))
            continue
        if api_use == "N":
            results.append(("L3", "FAIL", subj, f"API_M '{api_id}' USE_YN='N'"))
            continue
        if api_url in seen_proc:
            continue
        seen_proc.add(api_url)
        pm_cnt = len(idx["proc_m_by_nm"].get(api_url, []))
        if pm_cnt == 0:
            results.append(("L4", "FAIL", api_url, "PROC_M 0행 — 컬럼 메타 부재(PR_GET_PROC_INFO_LIST fallback 경로)"))
        exists, valid, detail = check_sp(api_url, idx)
        if not exists:
            results.append(("L5", "FAIL", api_url, detail))
        elif not valid:
            results.append(("L5", "FAIL", api_url, detail))
        if exists and pm_cnt > 0:
            arg_fails, arg_warns = check_args(api_url, idx)
            for msg in arg_fails:
                results.append(("L6", "FAIL", api_url, msg))
            for msg in arg_warns:
                results.append(("L6", "WARN", api_url, msg))

    fails = [r for r in results if r[1] == "FAIL"]
    warns = [r for r in results if r[1] == "WARN"]
    verdict = "FAIL" if fails else ("WARN" if warns else "PASS")
    known = (known_issues or {}).get(menu_id, "")
    return {"menu": menu_id, "results": results, "verdict": verdict, "fails": fails, "warns": warns, "known": known}


# ──────────────────────────────────────────────────────────────────────────────
# 출력
# ──────────────────────────────────────────────────────────────────────────────
def print_menu_report(rep, fe_entry):
    folders = ", ".join(str(f.relative_to(FE_ROOT)) for f in fe_entry["folders"]) if fe_entry else "(FE 폴더 없음)"
    print(f"\n=== {rep['menu']}  [{rep['verdict']}]  {folders}" + (f"  ({rep['known']})" if rep["known"] else ""))
    for link, lvl, subj, detail in rep["results"]:
        if lvl == "PASS" and link != "L1":
            continue
        print(f"  {link} {lvl:4} | {subj} | {detail}")
    if rep["verdict"] == "PASS":
        print("  L2~L7 전 링크 PASS")


NEW_AXIS_LINKS = {"L2A", "L2P"}


def write_sweep_report(path, reports, pages, no_menu_id, known_issues):
    lines = []
    lines.append("# 전 화면 배선 체인 소급 스윕 판정표 v2 (wiring_chain_check --all — 액션·모달 축 확장)")
    lines.append("")
    lines.append("> v2 실행: 2026-08-07 (v1 동일자 — CRUD 액션·모달 축 L2A/L2P 추가 재스윕) · 도구: `_artifacts/_diagnostics/wiring_chain_check.py` · DB: 사내 SCM_MGR@OCGSCMD_P01 (SELECT only)")
    lines.append("> 체인 정본: `PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST` (BTN_MPG→API_M→PROC_M) · FE 원천: `*.constants.ts` SHEETS enum + **전 .ts/.tsx 액션 스캔(모달 components/*Modal|Dialog*.tsx 포함)**")
    lines.append("> 판정 정책(기존 v1): SEARCH/SAVE API 미배선·API_M 부재·PROC_M 0행·SP 부재/INVALID·시그니처 불일치 = FAIL / INSERT·DELETE API NULL·미사용 배선 = WARN")
    lines.append("> ⭐ 신규 축(v2): **L2A** FE 실사용 액션(call-proc 리터럴/useTabProcQuery→SEARCH/useProcMutation→SAVE/hotkeyConfig) 단위 BTN_MPG 부재 = FAIL / **L2P** 액션 권한 `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 0그룹 = FAIL")
    lines.append("")
    n_fail = sum(1 for r in reports if r["verdict"] == "FAIL")
    n_warn = sum(1 for r in reports if r["verdict"] == "WARN")
    n_pass = sum(1 for r in reports if r["verdict"] == "PASS")
    n_new_fail_menus = sum(1 for r in reports if any(l in NEW_AXIS_LINKS for l, _, _, _ in r["fails"]))
    n_new_fail_rows = sum(sum(1 for l, _, _, _ in r["fails"] if l in NEW_AXIS_LINKS) for r in reports)
    n_old_fail_rows = sum(sum(1 for l, _, _, _ in r["fails"] if l not in NEW_AXIS_LINKS) for r in reports)
    lines.append(f"## 요약 — 총 {len(reports)} 화면 (FE 페이지 폴더 {sum(len(p['folders']) for p in pages.values())}개): FAIL {n_fail} / WARN {n_warn} / PASS {n_pass}")
    lines.append("")
    lines.append(f"- 기존 축(L1~L7) FAIL 항목 {n_old_fail_rows}건 / **신규 축(v2 L2A·L2P) FAIL 항목 {n_new_fail_rows}건 ({n_new_fail_menus}개 화면)** — 아래 표에서 열 분리.")
    lines.append("")
    lines.append("| MNU_ID | 판정 | FE 폴더 | 기존 축 FAIL (v1 L1~L7) | ⭐ 신규 축 FAIL (v2 L2A/L2P) | 비고 |")
    lines.append("|---|---|---|---|---|---|")
    for r in sorted(reports, key=lambda x: ({"FAIL": 0, "WARN": 1, "PASS": 2}[x["verdict"]], x["menu"])):
        fe = pages.get(r["menu"])
        folders = "<br>".join(str(f.relative_to(FE_ROOT)).replace("\\", "/") for f in fe["folders"]) if fe else "(없음)"
        old_fails = [(l, s) for l, _, s, _ in r["fails"] if l not in NEW_AXIS_LINKS]
        new_fails = [(l, s) for l, _, s, _ in r["fails"] if l in NEW_AXIS_LINKS]
        old_sum = "; ".join(f"{l}:{s}" for l, s in old_fails[:4]) + ("" if len(old_fails) <= 4 else f" 외 {len(old_fails)-4}") or "—"
        new_sum = "; ".join(f"{l}:{s}" for l, s in new_fails[:4]) + ("" if len(new_fails) <= 4 else f" 외 {len(new_fails)-4}") or "—"
        lines.append(f"| {r['menu']} | {r['verdict']} | {folders} | {old_sum} | {new_sum} | {r['known'] or ''} |")
    lines.append("")
    lines.append("## 화면별 상세 (FAIL/WARN 만 — 근거 = 실측 행)")
    for r in sorted(reports, key=lambda x: x["menu"]):
        if r["verdict"] == "PASS":
            continue
        lines.append("")
        lines.append(f"### {r['menu']} [{r['verdict']}]" + (f" — {r['known']}" if r["known"] else ""))
        lines.append("")
        lines.append("| 링크 | 레벨 | 대상 | 근거 |")
        lines.append("|---|---|---|---|")
        for link, lvl, subj, detail in r["results"]:
            if lvl in ("FAIL", "WARN", "INFO"):
                lines.append(f"| {link} | {lvl} | {subj} | {detail} |")
    if no_menu_id:
        lines.append("")
        lines.append("## MENU_ID 상수 미보유 페이지 폴더 (검증 불가 — 파싱 한계)")
        for f in no_menu_id:
            lines.append(f"- `{f.relative_to(FE_ROOT)}`")
    lines.append("")
    lines.append("## 추출 한계 (anti-simplification 명시 의무)")
    lines.append("- FE 시트 원천 = `*.constants.ts` 의 `enum SHEETS`/`const SHEETS`/`SHEET_NAME`. 리터럴 sheetName 직접 전달 코드는 L2 미포착(L7 WARN + v2 액션 스캔이 부분 보완).")
    lines.append("- v2 액션 추출 = call-proc 템플릿 리터럴 4형 + useTabProcQuery/useProcMutation(제네릭·sheetName 인자 해석) + hotkeyConfig 4키. 완전 동적 URL(`${sheet}/${btnCd}`)·시트 미해석 훅은 INFO(수동 확인)로 노출 — 은폐 없음.")
    lines.append("- hotkey 액션의 시트 귀속(활성 그리드)은 정적 해석 불가 — '메뉴 내 ≥1 시트 행 존재+≥1그룹' 완화 판정.")
    lines.append("- synonym 은 1단 해석까지 (해석 후 상태 미확인 — 상세에 명기).")
    lines.append("- BTN_MPG USE_YN='N' 행은 비활성 배선으로 간주하고 검증 제외(INFO) — 단 FE 실사용 액션이면 L2A FAIL.")
    p = pathlib.Path(path)
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text("\n".join(lines), encoding="utf-8")
    print(f"\n[report] {p}")


KNOWN_ISSUES = {
    "DMF0072": "기지 결함 — nn-master-mapping SAVE 체인 단절 (사용자 확정 미진행, 수정 금지·표기만)",
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--menu")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--report")
    args = ap.parse_args()
    if not args.menu and not args.all:
        ap.error("--menu MNU_ID 또는 --all 필요")

    pages, no_menu_id = scan_fe_pages()
    if args.menu:
        targets = [args.menu]
        if args.menu not in pages:
            print(f"[warn] FE 페이지 폴더에서 MENU_ID '{args.menu}' 미발견 — DB-only 검증 진행")
    else:
        targets = sorted(pages.keys())

    db = fetch_db(targets)
    idx = build_indexes(db)

    reports = []
    for m in targets:
        rep = check_menu(m, pages.get(m), idx, KNOWN_ISSUES)
        reports.append(rep)
        print_menu_report(rep, pages.get(m))

    n_fail = sum(1 for r in reports if r["verdict"] == "FAIL")
    print(f"\n== 총 {len(reports)} 화면: FAIL {n_fail} / WARN {sum(1 for r in reports if r['verdict']=='WARN')} / PASS {sum(1 for r in reports if r['verdict']=='PASS')}")

    if args.report:
        write_sweep_report(args.report, reports, pages, no_menu_id, KNOWN_ISSUES)

    sys.exit(1 if n_fail else 0)


if __name__ == "__main__":
    try:
        main()
    except SystemExit:
        raise
    except Exception as e:
        print(f"[error] {e}", file=sys.stderr)
        sys.exit(2)
