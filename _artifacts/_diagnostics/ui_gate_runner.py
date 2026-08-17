#!/usr/bin/env python3
"""
ui_gate_runner.py — 화면 완료 선언 단일 게이트 러너 (2026-08-07 신설)

배경: SYS0017 근본원인 감사 — "8게이트 통과" 주장이 실측 기록 없이 통용됨(감사 §1).
      완료 선언 = 본 러너 리포트 경로 첨부 의무 (screen-completion-gate 등재).

일괄 실행 9개 섹션 (섹션 5 = 2026-08-07 CRUD·모달 축 / 섹션 6 = 2026-08-07 HTTP 셀프 E2E — hook #125
                    / 섹션 7 = 2026-08-08 UP_FX 콤보 파라미터 정합 — hook #117 §5.5~§5.10):
  (1) check-ui-gates.ps1 — 페이지 폴더 전 .ts/.tsx 에 G-A~G-G 적용 (stdin JSON 규약)
  (2) asis_mapping_gate --check — EID 1:1 대사표 잔여 0 검증
      (__asis-mapping__.md 부재 시: --analysis 지정돼 있으면 FAIL, 아니면 SKIP+사유)
  (3) wiring_chain_check --menu — FE→BE→SP 배선 체인 L1~L7 + v2 액션·권한 축 L2A/L2P
  (5) asis_mapping_gate --check --matrix-only — CRUD·모달 매트릭스 잔여 0
      (MAIN UI 와 모달의 CRUD 누락 0 — 사용자 요구 2026-08-07)
  (7) UP_FX 콤보 파라미터 정합 — 셀 콤보 @토큰 ↔ FE 전달 대조 / quoting / 빈 .catch / 토큰 대사표
  (8) 콤보 호출 지점(트리거) 대사 — AS-IS 이벤트 핸들러 수 ↔ TO-BE 트리거 수 (InsertRow 누락 검출)
  (9) 단위테스트 — 배분/편집판정 등 순수 함수의 **값**을 AS-IS 산식과 1:1 대사
  (4) 메타 값 단언 (SELECT only) — SCM_MST_SHEET_COLUMNS 해당 PROGRAM_ID:
      · CELL_CONTROL_OBJECT_TYPE_CODE 화이트리스트 = column-config.ts CELL_CONTROL_TYPE 실값
        (FP* 14종) + NULL/공백(이관 표준 — 전수 4,884행/176화면 실측, FE 는 default 폴백으로 NULL 동치)
        + 'S'(hidden 용도 실데이터 존재 — 감사 §5) — 그 외('C' 등) = FAIL
      · INPUT_TP_CD: CELL_INPUT_EDIT_TYPE {S,O,M,IO,IM} 외 코드 = FAIL /
        시트 전 행 단일 'IM' = WARN (편집 화면 전면 잠금 의심 — SYS0017 #4 계보)

사용:
  python ui_gate_runner.py --menu SYS0017 --page nscm-fe/features/admin/src/pages/mail-setup [--analysis <분석md>]
  출력: _artifacts/_gate_reports/{MNU_ID}_{YYYYMMDD_HHMM}.md (4섹션 PASS/FAIL + 근거 + 종합 판정)
  exit code: 0 = 종합 PASS / 1 = FAIL / 2 = 실행 오류
"""
import argparse
import datetime
import json
import pathlib
import re
import subprocess
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
HOOK_PS1 = ROOT / ".claude" / "hooks" / "check-ui-gates.ps1"
COLUMN_CONFIG = ROOT / "nscm-fe" / "packages" / "foundation" / "src" / "constants" / "column-config.ts"
REPORT_DIR = ROOT / "_artifacts" / "_gate_reports"
DIAG = pathlib.Path(__file__).resolve().parent

INPUT_TP_WHITELIST = {"S", "O", "M", "IO", "IM"}  # CELL_INPUT_EDIT_TYPE (column-config.ts)

# ── 섹션 7 (UP_FX 콤보 파라미터 정합, 2026-08-08 신설 — hook #117 §5.5~§5.10) ────────────
# BE 가 세션에서 자동 주입하는 토큰. LookupServiceImpl.retrieveCombo(단건 /admin/combo) 기준.
#   ⚠ @userId / @langCd 는 /admin/combo-muti 에만 주입되고 FE 실사용 경로(단건)에는 미주입 →
#      자동 주입으로 인정하지 않는다 (미전달 = '' 치환).
COMBO_SERVER_TOKENS = {"sesUserId", "sesLangCd"}


def _token_is_lenient(sql: str, tok: str) -> bool:
    """토큰 미전달('' 치환) 시 무필터로 통과하는 관대형 관용구인지 판정.

    관대형: `@t IS NULL OR …` / `NVL(TRIM(@t),'ALL')='ALL' OR …` / `@t = '' OR` / `@t = 'ALL' OR`
    비관대형(`COL = @t`)은 '' 치환 시 NULL 비교가 되어 **0행** — 조용한 빈 콤보.

    ⭐ `CASE @t WHEN 'EN' THEN … ELSE … END` 형태는 **행 필터가 아니라 표시 선택자**이므로 관대형이다.
      (예: `TeambyDivision` 의 `@langCd` — 미전달 시 ELSE 분기로 떨어져 한국어 명칭. 행수 불변 161 실측)
    """
    pats = [
        rf"@{tok}\b\s+IS\s+NULL",
        rf"NVL\s*\(\s*TRIM\s*\(\s*@{tok}\b",
        rf"NVL\s*\(\s*@{tok}\b",
        rf"@{tok}\b\s*=\s*''",
        rf"@{tok}\b\s*=\s*'ALL'",
        rf"CASE\s+@{tok}\b",  # 표시 선택자 — ELSE 폴백 존재
    ]
    return any(re.search(p, sql, re.I) for p in pats)


def _balanced_object(text: str, start: int) -> str:
    """text[start] == '{' 인 위치에서 균형 잡힌 객체 리터럴 문자열을 반환 (중첩 허용)."""
    depth, i = 0, start
    while i < len(text):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return text[start : i + 1]
        i += 1
    return text[start:]


def _balanced_paren(text: str, start: int) -> str:
    """text[start] == '(' 인 위치에서 균형 잡힌 인자 구간을 반환."""
    depth, i = 0, start
    while i < len(text):
        if text[i] == "(":
            depth += 1
        elif text[i] == ")":
            depth -= 1
            if depth == 0:
                return text[start : i + 1]
        i += 1
    return text[start:]


_KEY_RE = re.compile(r"(?:^|[{,])\s*([A-Za-z_$][\w$]*)\s*:", re.M)
_COMBOID_RE = re.compile(r"comboId\s*:\s*'([^']+)'")


def _top_level_pairs(obj: str):
    """객체 리터럴 문자열의 **최상위** (키, 값) 쌍만 추출.

    중첩 객체·배열·호출 인자·문자열/템플릿 안은 건너뛴다. 정규식만으로는
    `{ filters: [{ comboId: 'X' }] }` 의 래퍼가 comboId 를 가진 것처럼 보여 오탐이 난다(2026-08-08).
    """
    pairs, i, n = [], 1, len(obj) - 1  # 바깥 중괄호 제외
    while i < n:
        while i < n and obj[i] in " \t\r\n,":
            i += 1
        km = re.match(r"([A-Za-z_$][\w$]*)\s*:", obj[i:n])
        if not km:
            # 키 형태가 아니면 다음 최상위 구분자까지 건너뛴다 (스프레드·주석 등)
            depth, ins, i0 = 0, "", i
            while i < n:
                c = obj[i]
                if ins:
                    if c == ins and obj[i - 1] != "\\":
                        ins = ""
                elif c in "'\"`":
                    ins = c
                elif c in "{[(":
                    depth += 1
                elif c in "}])":
                    depth -= 1
                elif c == "," and depth == 0:
                    break
                i += 1
            if i == i0:
                i += 1
            continue
        key = km.group(1)
        i += km.end()
        start, depth, ins = i, 0, ""
        while i < n:
            c = obj[i]
            if ins:
                if c == ins and obj[i - 1] != "\\":
                    ins = ""
            elif c in "'\"`":
                ins = c
            elif c in "{[(":
                depth += 1
            elif c in "}])":
                depth -= 1
            elif c == "," and depth == 0:
                break
            i += 1
        pairs.append((key, obj[start:i].strip()))
    return pairs


def _scan_combo_calls(page_dir: pathlib.Path):
    """페이지 폴더의 콤보 호출을 정적 파싱.

    반환: (grid_params, params_by_combo, quote_viol, catch_viol)
      grid_params      : <DataGrid comboParams={{...}}> 로 전 셀 콤보에 일괄 전달되는 키 집합
      params_by_combo  : {SQL_ID: {키…}} — comboId 리터럴을 가진 객체에서 수집
      quote_viol       : quoting 누락 위반 [(파일, comboId, 키, 값)]
      catch_viol       : 빈 .catch 위반 [(파일, 근방 comboId)]
      dynamic_params   : comboId 가 변수라 귀속 불가한 호출에서 전달되는 키 (판정 완화용)
    """
    grid_params, params_by_combo, dynamic_params = set(), {}, set()
    quote_viol, catch_viol = [], []
    files = sorted(list(page_dir.rglob("*.ts")) + list(page_dir.rglob("*.tsx")))
    for f in files:
        text = f.read_text(encoding="utf-8", errors="ignore")
        rel = f.relative_to(page_dir).as_posix()

        # (a) comboParams={{ ... }}
        for m in re.finditer(r"comboParams\s*=\s*\{", text):
            obj = _balanced_object(text, m.end() - 1)  # 바깥 {
            inner_at = obj.find("{", 1)
            inner = _balanced_object(obj, inner_at) if inner_at >= 0 else obj
            pairs = _top_level_pairs(inner)
            for k, _ in pairs:
                grid_params.add(k)
            quote_viol += _check_quoting(rel, "(comboParams)", pairs)

        # (b) 실제 **호출 문맥** 안의 콤보 파라미터 객체만 대상으로 한다.
        #     ⚠ 설정 상수(GRID_EDIT_COMBO 등)도 `comboId` 키를 갖지만 그건 호출이 아니라 정의이므로
        #       전역 스캔하면 오탐이 난다(2026-08-08 실측). getCombo(...) / useTabComboQueries(...) 의
        #       인자 구간만 잘라서 그 안의 객체를 본다 — .map() 으로 만드는 객체도 이 구간에 포함된다.
        for cm in re.finditer(r"\b(?:getCombo|useTabComboQueries)\s*\(", text):
            region = _balanced_paren(text, cm.end() - 1)
            for om in re.finditer(r"\{", region):
                obj = _balanced_object(region, om.start())
                pairs = _top_level_pairs(obj)
                cid_val = next((v for k, v in pairs if k == "comboId"), None)
                if cid_val is None:
                    continue  # 콤보 파라미터 객체가 아님 (filters/enabled 래퍼 등)
                lit = re.fullmatch(r"'([^']+)'", cid_val)
                sql_id = lit.group(1) if lit else "(동적)"
                keys = {k for k, _ in pairs if k not in ("comboId", "enabled", "queryOptions")}
                if lit:
                    params_by_combo.setdefault(sql_id, set()).update(keys)
                else:
                    # comboId 가 설정 맵에서 오는 경우(GRID_EDIT_COMBO.map 등) 정적 귀속이 불가하다.
                    # 이 페이지가 "어딘가에서" 그 토큰을 넘기고 있다는 사실만 기록해 판정을 완화한다.
                    dynamic_params.update(keys)
                quote_viol += _check_quoting(rel, sql_id, pairs)

        # (b2) ⭐ 2026-08-12 — **빌더 함수의 return 객체**도 수집 (DMF0021 comboContext 계보).
        #     콤보 파라미터를 헬퍼(buildXxxComboFilter 등)가 조립해 useTabComboQueries 에 변수로
        #     넘기는 화면은 (b) 호출-구간 스캔이 놓친다 → 런타임 실전달인데 '미전달 FAIL' 오탐.
        #     `return { comboId: 'X', ... }` 형태만 수집(정의 상수 오탐 방지 — return 구문 한정).
        for rm in re.finditer(r"\breturn\s*\{", text):
            obj = _balanced_object(text, rm.end() - 1)
            pairs = _top_level_pairs(obj)
            cid_val = next((v for k, v in pairs if k == "comboId"), None)
            if cid_val is None:
                continue
            lit = re.fullmatch(r"'([^']+)'", cid_val)
            keys = {k for k, _ in pairs if k not in ("comboId", "enabled", "queryOptions")}
            if lit:
                params_by_combo.setdefault(lit.group(1), set()).update(keys)
                quote_viol += _check_quoting(rel, lit.group(1), pairs)
            else:
                dynamic_params.update(keys)

        # (b3) ⭐ 2026-08-15 — **화살표 함수의 즉시 반환 객체** `=> ({ comboId … })` 도 수집
        #     (DMF0003 gridCombos 계보). (b2) 는 `return {` 구문만 봐서 이 형태를 통째로 놓쳤고,
        #     그 결과 런타임에 실제로 싣는 토큰이 '미전달' 로 찍혔다
        #     (실측 2026-08-15 DMF0003: buildGridComboFilter/buildEditComboFilter/buildParam 4곳의
        #      `mnuId`·`param1`·`divisionId` 가 전부 오탐 FAIL/WARN).
        #     comboId 가 리터럴이면 그 콤보에, 변수(shorthand 포함)면 dynamic_params 로 귀속한다.
        for am in re.finditer(r"=>\s*\(\s*\{", text):
            obj = _balanced_object(text, text.index("{", am.end() - 1))
            pairs = _top_level_pairs(obj)
            cid_val = next((v for k, v in pairs if k == "comboId"), None)
            if cid_val is None:
                continue
            lit = re.fullmatch(r"'([^']+)'", cid_val)
            keys = {k for k, _ in pairs if k not in ("comboId", "enabled", "queryOptions")}
            if lit:
                params_by_combo.setdefault(lit.group(1), set()).update(keys)
                quote_viol += _check_quoting(rel, lit.group(1), pairs)
            else:
                # comboId 가 변수(`comboId` shorthand / `cfg.comboId`) — 어느 콤보인지 정적 귀속 불가.
                # "이 화면이 그 토큰을 싣는다"는 사실만 남겨 판정을 완화한다((b) 동적 처리와 동일 규약).
                #   ⚠ quoting 검사는 하지 않는다 — comboId 를 담은 **디스크립터 객체**
                #     (`{ comboId, binding, rows, param }`)와 파라미터 객체를 정적으로 가를 수 없어
                #     검사하면 정상 코드가 위반으로 찍힌다(2026-08-15 실측 5건). 리터럴 귀속 건만 검사.
                dynamic_params.update(keys)

        # (c) 빈 .catch — 콤보 호출의 조용한 실패 (hook #117 §5.8)
        for m in re.finditer(
            # 탐지 창 확대 (2026-08-08) — .then 체인이 길면 600자로는 빈 catch 를 놓친다
            r"getCombo\s*\([\s\S]{0,3000}?\.catch\s*\(\s*\(\s*\)\s*=>\s*\{\s*(?:/\*[\s\S]*?\*/\s*)?\}\s*\)", text
        ):
            near = _COMBOID_RE.search(m.group(0))
            catch_viol.append((rel, near.group(1) if near else "(?)"))
    return grid_params, params_by_combo, quote_viol, catch_viol, dynamic_params


def _check_quoting(rel: str, sql_id: str, pairs):
    """콤보 파라미터 값의 quoting 누락 검출 (hook #117 §5.7).

    BE makeComboQuery 는 raw 문자열 치환이므로 문자열 리터럴은 FE 가 작은따옴표를 포함해 보내야 한다.
    허용: `'..'` / `` `'${..}'` `` / q(..)·quote(..) 헬퍼 / 숫자.
    `enabled` 는 훅 옵션이지 콤보 파라미터가 아니므로 제외.
    """
    viol = []
    for key, val in pairs:
        if key in ("comboId", "enabled", "queryOptions") or not val:
            continue
        if val.startswith("'") or val.startswith('"'):
            continue
        if val.startswith("`'") or re.match(r"^`[^`]*'\$\{", val):
            continue
        # ⭐ 2026-08-15 — 프로젝트 표준 quoting 헬퍼 `quoteParam(x)`(= `'` + x + `'`) 추가.
        #   FE 전 화면이 이 헬퍼로 따옴표를 싣는데 whitelist 에 없어 정상 코드가 위반으로 찍혔다.
        if re.match(r"^(q|quote|qs|quoteParam)\s*\(", val):
            continue
        if re.match(r"^[\d.]+$", val):
            continue
        viol.append((rel, sql_id, key, val[:60]))
    return viol


def run_section7(menu, page_dir):
    """UP_FX 콤보 파라미터 정합 (2026-08-08 신설).

    AS-IS UP_FX_GetCommonDataList 계통의 TO-BE 등가물은 ①CMBO 등록 ②소비지점 배선 ③FE 파라미터 전달
    3분할이다. ①만 보면 "등록됨"으로 통과하므로 ②③ 축을 여기서 강제한다.
    """
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(
            # 셀 '콤보' 만 대상. 제외 사유:
            #   · TRIM = NULL — CELL_COMBO_DATA_TYPE 이 공백 1칸인 "콤보 아님" 센티널 (실데이터 다수)
            #   · CTRL <> 'FPComboBox' — FPModal(ProjectByDivision 등)은 모달 검색 API 로 해소되며
            #     SCM_ADM_CMBO_SQL_M 대상이 아니다 (오탐 방지, 2026-08-08 실측)
            #   · ⭐ 2026-08-10 — VISIBLE_FLAG 집계를 함께 가져온다. 붙은 컬럼이 **전부 숨김**이면
            #     그 콤보는 렌더 자체가 안 되므로 "토큰 미전달"이 결함이 아니다(오탐 차단).
            """SELECT C.CELL_COMBO_DATA_TYPE,
                      MAX(CASE WHEN NVL(C.VISIBLE_FLAG,'Y') = 'Y' THEN 1 ELSE 0 END) AS ANY_VISIBLE,
                      LISTAGG(C.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY C.COLUMN_NAME) AS COLS
                 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE C.PROGRAM_ID = :m
                  AND TRIM(C.CELL_COMBO_DATA_TYPE) IS NOT NULL
                  AND C.CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox'
                  AND NVL(C.VALID_YN,'Y') = 'Y'
                GROUP BY C.CELL_COMBO_DATA_TYPE
                ORDER BY 1""",
            {"m": menu},
        )
        _rows = cur.fetchall()
        combo_ids = [r[0] for r in _rows]
        hidden_only = {r[0]: r[2] for r in _rows if r[1] == 0}
        sqls = {}
        for cid in combo_ids:
            cur.execute(
                "SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :s", {"s": cid}
            )
            row = cur.fetchone()
            sqls[cid] = (row[0].read() if hasattr(row[0], "read") else str(row[0])) if row else None

    grid_params, params_by_combo, quote_viol, catch_viol, dyn_params = _scan_combo_calls(page_dir)

    fails, warns, details = [], [], []
    details.append(f"셀 콤보 {len(combo_ids)}종 / DataGrid comboParams 키 {sorted(grid_params) or '없음'}")
    details.append("")
    details.append("| SQL_ID | 필요 토큰 | 서버자동 | FE전달 | 미전달 | 판정 |")
    details.append("|---|---|---|---|---|---|")
    for cid in combo_ids:
        sql = sqls.get(cid)
        if sql is None:
            fails.append(f"CMBO '{cid}' 미등록 — SHEET_COLUMNS 는 참조하나 SCM_ADM_CMBO_SQL_M 에 없음(조용한 빈 콤보)")
            details.append(f"| {cid} | (미등록) | - | - | - | ⛔ FAIL |")
            continue
        toks = set(re.findall(r"@(\w+)", sql))
        server = toks & COMBO_SERVER_TOKENS
        need = toks - COMBO_SERVER_TOKENS
        provided = grid_params | params_by_combo.get(cid, set())
        missing = sorted(need - provided - dyn_params)
        dyn_only = sorted((need - provided) & dyn_params)
        verdict = "✅ PASS" if not dyn_only else "✅ PASS(동적)"
        if missing and cid in hidden_only:
            # 붙은 컬럼이 전부 VISIBLE_FLAG='N' — 사용자가 셀을 열 수 없어 콤보가 렌더되지 않는다.
            # ⚠ 숨김 여부는 **AS-IS 메타와 대조**해 파리티를 확인한 뒤에만 이 경로를 신뢰할 것.
            details.append(
                f"| {cid} | {sorted(need) or '-'} | {sorted(server) or '-'} | "
                f"{sorted(need & provided) or '-'} | {missing} | ✅ PASS(숨김) |"
            )
            details.append(
                f"  ↳ 컬럼 `{hidden_only[cid]}` 전부 VISIBLE_FLAG='N' — 렌더 안 됨(토큰 미전달 무해)"
            )
            continue
        for t in missing:
            if _token_is_lenient(sql, t):
                warns.append(f"CMBO '{cid}' 토큰 @{t} 미전달 — 관대형이라 무필터(전체 목록)로 동작. AS-IS 필터 의도 대조 필요")
                verdict = "⚠ WARN"
            else:
                fails.append(f"CMBO '{cid}' 토큰 @{t} 미전달 + 비관대형(`COL = @{t}`) — '' 치환 → **0행**(조용한 빈 콤보)")
                verdict = "⛔ FAIL"
        details.append(
            f"| {cid} | {sorted(need) or '-'} | {sorted(server) or '-'} | "
            f"{sorted(need & provided) or '-'} | {missing or '-'} | {verdict} |"
        )

    if quote_viol:
        details.append("")
        details.append("**quoting 누락 (hook #117 §5.7 — BE raw 치환 → ORA-00904/01722)**")
        for rel, cid, key, val in quote_viol:
            fails.append(f"quoting 누락 {rel} · {cid} · {key}: {val} — `'값'` 형태 필요")
            details.append(f"- `{rel}` · {cid} · `{key}: {val}`")
    if catch_viol:
        details.append("")
        details.append("**조용한 실패 (hook #117 §5.8 — 빈 .catch 로 ORA 오류 은폐)**")
        for rel, cid in catch_viol:
            fails.append(f"빈 .catch {rel} · {cid} — 최소 console.error 필요")
            details.append(f"- `{rel}` · {cid}")

    mapping = page_dir / "__asis-mapping__.md"
    if mapping.is_file():
        mtext = mapping.read_text(encoding="utf-8", errors="ignore")
        if not re.search(r"토큰\s*대사표", mtext):
            warns.append("__asis-mapping__.md 에 토큰 대사표 섹션 부재 (hook #117 §5.6)")
    else:
        warns.append("__asis-mapping__.md 부재 — 토큰 대사표 판정 불가 (hook #117 §5.6)")

    status = "FAIL" if fails else ("WARN" if warns else "PASS")
    body = ["⛔ " + f for f in fails] + ["⚠ " + w for w in warns] + [""] + details
    return status, f"셀 콤보 {len(combo_ids)}종 — FAIL {len(fails)} / WARN {len(warns)}", body


def parse_ctrl_whitelist():
    """column-config.ts 의 CELL_CONTROL_TYPE enum 실값 파싱 (하드코딩 금지 — 원천 단일화)."""
    text = COLUMN_CONFIG.read_text(encoding="utf-8", errors="ignore")
    m = re.search(r"enum\s+CELL_CONTROL_TYPE\s*\{([^}]*)\}", text, re.S)
    if not m:
        raise RuntimeError(f"CELL_CONTROL_TYPE enum 파싱 실패: {COLUMN_CONFIG}")
    vals = set(re.findall(r"=\s*'([^']+)'", m.group(1)))
    if not vals:
        raise RuntimeError("CELL_CONTROL_TYPE 값 0건")
    return vals


def run_section1(page_dir):
    """check-ui-gates.ps1 를 폴더 전 파일에 적용."""
    files = sorted(list(page_dir.rglob("*.ts")) + list(page_dir.rglob("*.tsx")))
    blocks, warns, details = 0, 0, []
    for f in files:
        payload = json.dumps({"tool_name": "Write", "tool_input": {"file_path": str(f)}})
        r = subprocess.run(
            ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", str(HOOK_PS1)],
            input=payload.encode("utf-8"), capture_output=True, timeout=120,
        )
        err = r.stderr.decode("utf-8", errors="replace").strip()
        if r.returncode == 2:
            blocks += 1
            details.append(f"⛔ BLOCK {f.relative_to(page_dir)}\n```\n{err}\n```")
        elif r.returncode == 1:
            warns += 1
            details.append(f"⚠ WARN {f.relative_to(page_dir)}\n```\n{err}\n```")
    status = "FAIL" if blocks else ("WARN" if warns else "PASS")
    summary = f"{len(files)}개 파일 스캔 — BLOCK {blocks} / WARN {warns}"
    return status, summary, details


def run_section2(page_dir, analysis):
    mapping = page_dir / "__asis-mapping__.md"
    if not mapping.is_file():
        if analysis:
            return "FAIL", f"__asis-mapping__.md 부재 (분석 md 지정됨 — asis_mapping_gate --init 선생성 의무)", []
        return "SKIP", "__asis-mapping__.md 부재 + --analysis 미지정 — 분석 md 존재 여부 판정 후 hook #123(md 선생성) 적용 대상인지 확인 필요 (사유 명시 SKIP)", []
    r = subprocess.run(
        [sys.executable, str(DIAG / "asis_mapping_gate.py"), "--check", str(page_dir)],
        capture_output=True, timeout=120,
    )
    out = r.stdout.decode("utf-8", errors="replace").strip()
    return ("PASS" if r.returncode == 0 else "FAIL"), out.splitlines()[0] if out else "", [f"```\n{out}\n```"] if r.returncode else []


def run_section5(page_dir, analysis):
    """CRUD·모달 매트릭스 (asis_mapping_gate --check --matrix-only)."""
    mapping = page_dir / "__asis-mapping__.md"
    if not mapping.is_file():
        if analysis:
            return "FAIL", "__asis-mapping__.md 부재 (분석 md 지정됨 — --init 선생성 의무, CRUD·모달 매트릭스 포함)", []
        return "SKIP", "__asis-mapping__.md 부재 + --analysis 미지정 — 매트릭스 판정 불가 (사유 명시 SKIP)", []
    r = subprocess.run(
        [sys.executable, str(DIAG / "asis_mapping_gate.py"), "--check", str(page_dir), "--matrix-only"],
        capture_output=True, timeout=120,
    )
    out = r.stdout.decode("utf-8", errors="replace").strip()
    return ("PASS" if r.returncode == 0 else "FAIL"), out.splitlines()[0] if out else "", [f"```\n{out}\n```"] if r.returncode else []


def run_section6(menu):
    """HTTP 셀프 E2E 리포트 확인 (hook #125 §2) — 러너 산출물 존재 + 종합 PASS/WARN.

    리포트는 `ui_http_e2e.py --menu {MNU}` 가 생성한다(로컬 BE 기동 필요).
    최신 리포트가 없으면 FAIL — "실행 없는 완료 선언" 차단이 본 섹션의 목적.
    """
    reports = sorted(REPORT_DIR.glob(f"{menu}_http_e2e_*.md"))
    if not reports:
        return ("FAIL",
                f"HTTP 셀프 E2E 리포트 부재 — `python _artifacts/_diagnostics/ui_http_e2e.py --menu {menu}` 실행 필요 (hook #125 §2)",
                [])
    latest = reports[-1]
    text = latest.read_text(encoding="utf-8", errors="ignore")
    m = re.search(r"## 종합: \*\*(PASS|WARN|FAIL)\*\*.*", text)
    verdict = m.group(1) if m else "UNKNOWN"
    head = (m.group(0) if m else "종합 판정 파싱 실패")
    status = {"PASS": "PASS", "WARN": "WARN", "FAIL": "FAIL"}.get(verdict, "FAIL")
    fails = [l for l in text.splitlines() if l.startswith("- ⛔ FAIL")]
    # 전량 표기 (2026-08-08 — 리포트 절단 제거. 잘라 보여주면 "그게 전부"로 읽힌다)
    return status, f"{latest.name} — {head}", ([f"```\n" + "\n".join(fails) + "\n```"] if fails else [])


def run_section3(menu):
    r = subprocess.run(
        [sys.executable, str(DIAG / "wiring_chain_check.py"), "--menu", menu],
        capture_output=True, timeout=600,
    )
    out = r.stdout.decode("utf-8", errors="replace").strip()
    err = r.stderr.decode("utf-8", errors="replace").strip()
    if r.returncode == 2:  # 실행 오류 (DB 연결 실패 등 — 판정 아님, 재실행 필요)
        return "ERROR", f"wiring_chain_check 실행 오류 — 재실행 필요: {err.splitlines()[-1] if err else '(원인 미상)'}", [f"```\n{err}\n```"]
    lines = [l for l in out.splitlines() if l.strip()]
    verdict_line = next((l for l in lines if l.startswith("===")), "")
    status = "PASS" if r.returncode == 0 else "FAIL"
    if status == "PASS" and "[WARN]" in verdict_line:
        status = "WARN"
    detail = [f"```\n{out}\n```"] + ([f"stderr:\n```\n{err}\n```"] if err else [])
    return status, verdict_line.strip("= ").strip(), detail


def run_section4(menu, ctrl_whitelist):
    import oracledb

    u, p, d = conn_info()
    details, fails, warns = [], [], []
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(
            """SELECT SHEET_NAME, NVL(CELL_CONTROL_OBJECT_TYPE_CODE,'(NULL)'), INPUT_TP_CD, COUNT(*)
                 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                WHERE PROGRAM_ID = :m
                GROUP BY SHEET_NAME, CELL_CONTROL_OBJECT_TYPE_CODE, INPUT_TP_CD
                ORDER BY 1, 2, 3""",
            {"m": menu},
        )
        rows = cur.fetchall()
    if not rows:
        return "FAIL", f"SCM_MST_SHEET_COLUMNS PROGRAM_ID='{menu}' 0행 — 컬럼 메타 미등록", []
    total = sum(r[3] for r in rows)
    details.append(f"실측 분포 ({total}행):")
    details.append("| SHEET_NAME | CTRL | INPUT_TP_CD | 행수 |")
    details.append("|---|---|---|---|")
    sheet_inputs = {}
    for sheet, ctrl, itp, cnt in rows:
        # ⭐ 2026-08-09 — 공백(CHR(32)) = **컨트롤 미지정**의 이관 표준값이다. NULL 과 동치로 취급한다.
        #   실측 근거: SCM_MST_SHEET_COLUMNS 전수 4,884행 / 176 화면이 ' ' (NULL 은 598행 / 33 화면뿐).
        #   FE 소비부(columnMapping.ts getDataType/getFormat/getEditor, DataGrid/dataGridUtils)는 전부
        #   `=== CELL_CONTROL_TYPE.X` 동등비교 + default 폴백 → ' ' 는 NULL 과 동일하게 기본 텍스트 셀.
        #   ⚠️ 공백만 동치다. 'C' 등 **미지의 코드**는 계속 FAIL (SYS0017 #5 계보 방어 유지).
        ctrl_norm = "(NULL)" if (ctrl == "(NULL)" or not str(ctrl).strip()) else ctrl
        details.append(f"| {sheet} | {'(공백)' if ctrl_norm == '(NULL)' and ctrl != '(NULL)' else ctrl} | {itp} | {cnt} |")
        sheet_inputs.setdefault(sheet, set()).add(itp)
        if ctrl_norm != "(NULL)" and ctrl_norm not in ctrl_whitelist and ctrl_norm != "S":
            fails.append(f"CTRL '{ctrl}' ({sheet}, {cnt}행) — 화이트리스트(column-config.ts FP* {len(ctrl_whitelist)}종 + NULL/공백 + 'S') 밖 (SYS0017 #5 계보)")
        if itp not in INPUT_TP_WHITELIST:
            fails.append(f"INPUT_TP_CD '{itp}' ({sheet}, {cnt}행) — CELL_INPUT_EDIT_TYPE {sorted(INPUT_TP_WHITELIST)} 밖")
    for sheet, itps in sheet_inputs.items():
        if itps == {"IM"}:
            warns.append(f"시트 '{sheet}' 전 행 INPUT_TP_CD='IM' 단일 코드 — 편집 화면이면 전면 잠금 의심 (SYS0017 #4 계보 · READONLY 시트면 무해)")
    status = "FAIL" if fails else ("WARN" if warns else "PASS")
    body = ["⛔ " + f for f in fails] + ["⚠ " + w for w in warns] + details
    return status, f"CTRL 위반 {len(fails)}건 / 전면-IM 시트 {len(warns)}건", body


def run_section8(menu, page_dir):
    """AS-IS ↔ TO-BE 콤보 **호출 지점(트리거) 대사** — hook #117 §5.12 (2026-08-08 신설).

    섹션 7·E2E D2축은 "올바른 데이터를 주는가" 만 본다. 이 섹션은 **"제때 부르는가"** 를 본다 —
    특히 AS-IS 의 행 생성(InsertRow) 지점 누락(시드복사 화면은 전 사용자가 이 경로를 탄다).
    """
    r = subprocess.run(
        [sys.executable, str(DIAG / "combo_callsite_parity.py"), "--menu", menu, "--page", str(page_dir)],
        capture_output=True, timeout=600,
    )
    out = r.stdout.decode("utf-8", errors="replace").strip()
    err = r.stderr.decode("utf-8", errors="replace").strip()
    head = next((l for l in out.splitlines() if l.startswith("FAIL ")), "")
    if not head:
        return "ERROR", f"combo_callsite_parity 실행 오류 — 재실행 필요: {err.splitlines()[-1] if err else '(원인 미상)'}", []
    rep = next((l.split(":", 1)[1].strip() for l in out.splitlines() if l.startswith("리포트:")), "")
    n_fail = int(head.split()[1])
    n_warn = int(head.split()[4])
    status = "FAIL" if n_fail else ("WARN" if n_warn else "PASS")
    body = []
    if rep and pathlib.Path(rep).is_file():
        txt = pathlib.Path(rep).read_text(encoding="utf-8", errors="ignore")
        bad = [l for l in txt.splitlines() if l.startswith("|") and ("⛔" in l or "⚠" in l)]
        if bad:
            body = ["```\n" + "\n".join(bad) + "\n```"]  # 전량 표기 (2026-08-08)
    return status, f"{head} — {rep}", body


def run_section9(page_dir):
    """단위테스트 — AS-IS 산식 1:1 대사 (2026-08-08 신설).

    섹션 2 는 "대사표 빈 칸 0", 섹션 8 은 "제때 부르는가" 를 본다. 둘 다 **값이 맞는지**는 못 본다.
    2026-08-08 실측: 함수는 존재하고 대사표는 "구현"인데 주배분 분기식·LOC 기준일이 틀렸다.
    배분 로직은 순수 함수라 값으로 못 박을 수 있다 — 테스트 부재 = WARN, 실패 = FAIL.
    """
    page = pathlib.Path(page_dir)
    tests = sorted(page.rglob("*.test.ts")) + sorted(page.rglob("*.test.tsx"))
    if not tests:
        return "WARN", "단위테스트 0건 — 배분/판정 등 순수 함수는 값 검증 대상 (hook asis-coverage-check §0.4)", []
    feat = page
    while feat.name != "src" and feat.parent != feat:
        feat = feat.parent
    feat = feat.parent  # features/{domain}
    vitest = ROOT / "nscm-fe" / "node_modules" / ".bin" / ("vitest.cmd" if sys.platform == "win32" else "vitest")
    rel = [str(t.relative_to(feat)).replace("\\", "/") for t in tests]
    r = subprocess.run([str(vitest), "run", *rel], cwd=str(feat), capture_output=True, timeout=900)
    out = (r.stdout.decode("utf-8", errors="replace") + r.stderr.decode("utf-8", errors="replace"))
    summary = next((l.strip() for l in out.splitlines() if "Tests " in l and ("passed" in l or "failed" in l)), "")
    summary = re.sub("\[[0-9;]*m", "", summary)
    # ⭐ "값이 틀림(FAIL)" 과 "실행 환경이 깨짐(ERROR)" 을 구분한다 — 섞으면 게이트가 무시된다.
    #   2026-08-08 실측: jsdom 초기화 실패(`MIMEType is not a constructor` — Node↔jsdom 버전 불일치)로
    #   기존 store 테스트가 **한 번도 실행된 적이 없었다**. 이건 로직 결함이 아니라 환경 결함이다.
    env_broken = ("Failed to start" in out and "worker" in out) or "MIMEType is not a constructor" in out
    if r.returncode == 0:
        return "PASS", f"{len(tests)}개 파일 — {summary}", []
    if env_broken and "failed" not in summary:
        return (
            "ERROR",
            f"{len(tests)}개 파일 — 테스트 **환경 오류**(실행 불가, 로직 결함 아님): jsdom 초기화 실패. "
            f"통과분 = {summary or '없음'}",
            ["```\n" + out[-2000:] + "\n```"],
        )
    return "FAIL", f"{len(tests)}개 파일 — {summary or ('exit ' + str(r.returncode))}", [
        "```\n" + out[-3000:] + "\n```"
    ]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--menu", required=True)
    ap.add_argument("--page", required=True)
    ap.add_argument("--analysis")
    args = ap.parse_args()
    page_dir = pathlib.Path(args.page)
    if not page_dir.is_absolute():
        page_dir = ROOT / page_dir
    if not page_dir.is_dir():
        sys.exit(f"[error] 페이지 폴더 없음: {page_dir}")

    ctrl_wl = parse_ctrl_whitelist()
    sections = []

    def guarded(label, fn, *a):
        """섹션 실행 오류(DB 연결 등) = ERROR 상태 (판정 아님 — 리포트에 사유 명시, 재실행 필요)."""
        try:
            return (label,) + fn(*a)
        except Exception as e:  # noqa: BLE001 — 환경성 오류를 판정과 구분해 보고
            return (label, "ERROR", f"실행 오류 — 재실행 필요: {e}", [])

    print(f"[1/9] check-ui-gates.ps1 (G-A~G-G) — {page_dir}")
    sections.append(guarded("1. 실행 hook check-ui-gates.ps1 (G-A~G-G)", run_section1, page_dir))
    print("[2/9] asis_mapping_gate --check")
    sections.append(guarded("2. EID 1:1 대사표 (asis_mapping_gate --check)", run_section2, page_dir, args.analysis))
    print("[3/9] wiring_chain_check --menu (v2 액션·권한 축 포함)")
    sections.append(guarded("3. FE→BE→SP 배선 체인 (wiring_chain_check L1~L7+L2A/L2P)", run_section3, args.menu))
    print("[4/9] 메타 값 단언 (SHEET_COLUMNS)")
    sections.append(guarded("4. 메타 값 단언 (SHEET_COLUMNS CTRL/INPUT_TP_CD)", run_section4, args.menu, ctrl_wl))
    print("[5/9] CRUD·모달 매트릭스 (asis_mapping_gate --check --matrix-only)")
    sections.append(guarded("5. CRUD·모달 매트릭스 (--matrix-only — MAIN UI·모달 CRUD 누락 0)", run_section5, page_dir, args.analysis))
    print("[6/9] HTTP 셀프 E2E 리포트 (ui_http_e2e — 권한별·모달·SAVE 왕복 실행 증명)")
    sections.append(guarded("6. HTTP 셀프 E2E (hook #125 §2 — 실행 증명 리포트)", run_section6, args.menu))
    print("[7/9] UP_FX 콤보 파라미터 정합 (토큰 대사·quoting·조용한 실패)")
    sections.append(guarded("7. UP_FX 콤보 파라미터 정합 (hook #117 §5.5~§5.10)", run_section7, args.menu, page_dir))
    print("[8/9] 콤보 호출 지점(트리거) 대사 — AS-IS N:N")
    sections.append(guarded("8. 콤보 호출 지점 대사 (hook #117 §5.12 — 제때 부르는가)", run_section8, args.menu, page_dir))
    print("[9/9] 단위테스트 (AS-IS 산식 1:1 — 값이 맞는가)")
    sections.append(guarded("9. 단위테스트 (asis-coverage-check §0.4 — 값 검증)", run_section9, page_dir))

    overall = "PASS"
    if any(s[1] == "FAIL" for s in sections):
        overall = "FAIL"
    elif any(s[1] == "ERROR" for s in sections):
        overall = "ERROR"  # 판정 불능 섹션 존재 — 완료 선언 불가, 재실행 필요
    elif any(s[1] in ("WARN", "SKIP") for s in sections):
        overall = "WARN"

    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M")
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    report = REPORT_DIR / f"{args.menu}_{ts}.md"
    lines = [
        f"# UI 완료 게이트 리포트 — {args.menu}",
        "",
        f"> 실행: {datetime.datetime.now():%Y-%m-%d %H:%M} · 러너: `_artifacts/_diagnostics/ui_gate_runner.py` · 페이지: `{page_dir}`",
        f"> 완료 선언 규약: 이 리포트 경로 첨부 없이는 화면 작업 미완료 간주 (screen-completion-gate · 2026-08-07)",
        "",
        f"## 종합 판정: **{overall}**",
        "",
        "| 섹션 | 판정 | 요약 |",
        "|---|---|---|",
    ]
    for name, status, summary, _ in sections:
        lines.append(f"| {name} | {status} | {summary} |")
    for name, status, summary, details in sections:
        lines.append("")
        lines.append(f"## {name} — {status}")
        lines.append("")
        lines.append(summary)
        for d in details:
            lines.append("")
            lines.append(d)
    report.write_text("\n".join(lines) + "\n", encoding="utf-8")

    print(f"\n== 종합 {overall} — 리포트: {report}")
    for name, status, summary, _ in sections:
        print(f"   {status:4} | {name} | {summary}")
    sys.exit(0 if overall not in ("FAIL", "ERROR") else 1)


if __name__ == "__main__":
    try:
        main()
    except SystemExit:
        raise
    except Exception as e:
        print(f"[error] {e}", file=sys.stderr)
        sys.exit(2)
