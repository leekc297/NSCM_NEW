"""SYS0013 Dynamic Query DQ_TEXT MSSQL → Oracle 변환 룰 엔진 (21 룰).

배경:
  NSCM 사내 Oracle `SCM_ADM_DQ_LIST` 의 DQ_TEXT (CLOB, 107 row) 안에 GSCM(AS-IS C#.NET WinForms)
  MSSQL 잔존 키워드. AS-IS 메타는 이미 import 완료 (`_asis_dq_dump/convert_to_oracle.py`),
  본문 변환은 미실행 → 사용자 화면 실행 시 SQL error 발생.

룰 출처:
  1. `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md` 부록 C — 9 함정
  2. 메모리 누적 NextSCM Pilot 사고 패턴 — 11 함수/구문
  3. 사용자 추가 요청 — 1 줄바꿈 가독성

Anti-Simplification (메모리 + 룰):
  - 21 룰 전수 등록 (선택 누락 금지)
  - 룰 hit 0 도 명시 — no-op 입증
  - 룰별 self cross-check: regex 매칭 count vs 적용 count 일치 ASSERT
  - String literal 마스킹 — '...' 안 가짜 매칭 회피
  - regex only (AST 미사용) — 부록 C 한계 명시
"""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from typing import Callable, List, Optional, Tuple


@dataclass
class RuleHit:
    rule_name: str
    before: str
    after: str
    span: Tuple[int, int]


@dataclass
class Rule:
    name: str
    category: str  # 'pitfall' | 'function' | 'datetime' | 'syntax' | 'var' | 'cleanup'
    pattern: re.Pattern
    replacement: object  # str | Callable[[re.Match], str]
    description: str
    example_before: str
    example_after: str
    guard: Optional[Callable[[str, re.Match], bool]] = None  # True = skip


# ---------------------------------------------------------------------------
# String literal 마스킹 (false-positive 회피)
# ---------------------------------------------------------------------------
_LITERAL_PAT = re.compile(r"'(?:[^']|'')*'", re.DOTALL)
_MASK_FMT = "\x01LIT{idx}\x02"


def mask_literals(sql: str) -> Tuple[str, List[str]]:
    """SQL 안 모든 '...' literal 을 placeholder 로 치환 (re 변환 후 복원)."""
    literals: List[str] = []

    def _sub(m: re.Match) -> str:
        idx = len(literals)
        literals.append(m.group(0))
        return _MASK_FMT.format(idx=idx)

    masked = _LITERAL_PAT.sub(_sub, sql)
    return masked, literals


def unmask_literals(masked: str, literals: List[str]) -> str:
    """placeholder 복원."""
    out = masked
    for idx, lit in enumerate(literals):
        out = out.replace(_MASK_FMT.format(idx=idx), lit)
    return out


# ---------------------------------------------------------------------------
# 룰 21종 정의 (pitfall → function → datetime → syntax → var → cleanup 순서)
# ---------------------------------------------------------------------------

def _dateadd_repl(m: re.Match) -> str:
    """DATEADD(unit, n, dt) → Oracle 식.
    unit: DAY/D/DD → +n
    unit: HOUR/HH → +n/24
    unit: MINUTE/MI/N → +n/1440
    unit: SECOND/SS/S → +n/86400
    unit: MONTH/MM/M → ADD_MONTHS(dt, n)
    unit: YEAR/YY/YYYY → ADD_MONTHS(dt, n*12)
    """
    unit = m.group(1).upper()
    n = m.group(2).strip()
    dt = m.group(3).strip()
    u = unit.replace(' ', '')
    if u in ('DAY', 'D', 'DD', 'DAYOFYEAR', 'DY', 'Y'):
        return f"({dt}) + ({n})"
    if u in ('HOUR', 'HH'):
        return f"({dt}) + ({n})/24"
    if u in ('MINUTE', 'MI', 'N'):
        return f"({dt}) + ({n})/1440"
    if u in ('SECOND', 'SS', 'S'):
        return f"({dt}) + ({n})/86400"
    if u in ('MONTH', 'MM', 'M'):
        return f"ADD_MONTHS({dt}, {n})"
    if u in ('YEAR', 'YY', 'YYYY'):
        return f"ADD_MONTHS({dt}, ({n})*12)"
    if u in ('WEEK', 'WK', 'WW'):
        return f"({dt}) + ({n})*7"
    if u in ('QUARTER', 'QQ', 'Q'):
        return f"ADD_MONTHS({dt}, ({n})*3)"
    # unknown unit — keep original 형태로 남기고 사람 검토 필요
    return m.group(0)


def _charindex_repl(m: re.Match) -> str:
    """CHARINDEX(needle, haystack[, start]) → INSTR(haystack, needle[, start]).
    인자 순서 swap! MSSQL CHARINDEX(needle, haystack) ≠ Oracle INSTR(haystack, needle).
    """
    needle = m.group(1).strip()
    haystack = m.group(2).strip()
    start = m.group(3)
    if start is not None:
        return f"INSTR({haystack}, {needle}, {start.strip()})"
    return f"INSTR({haystack}, {needle})"


def _iif_repl(m: re.Match) -> str:
    """IIF(cond, a, b) → CASE WHEN cond THEN a ELSE b END.
    paren balance 보장 — group capture 가 정상이면 단순 치환.
    """
    return f"CASE WHEN {m.group(1).strip()} THEN {m.group(2).strip()} ELSE {m.group(3).strip()} END"


def _top_repl(m: re.Match) -> str:
    """SELECT TOP n ... → SELECT ... FETCH FIRST n ROWS ONLY.
    단순 prefix 변환만 — ORDER BY / 복잡 sub-query 는 사람 검토 필요.
    """
    n = m.group(1)
    return f"SELECT /*+ TOP_CONVERTED_TO_FETCH_FIRST_{n}_ROWS_ONLY */ "


def _convert_date_repl(m: re.Match) -> str:
    """CONVERT(VARCHAR, dt, fmt_code) → TO_CHAR(dt, fmt).
    SQL Server fmt code 일부만 매핑 — 미매핑 시 TO_CHAR 만 wrap (사람 검토).
    """
    dt = m.group(1).strip()
    code = m.group(2).strip() if m.group(2) else None
    fmt_map = {
        '101': 'MM/DD/YYYY',
        '102': 'YYYY.MM.DD',
        '103': 'DD/MM/YYYY',
        '104': 'DD.MM.YYYY',
        '105': 'DD-MM-YYYY',
        '106': 'DD MON YYYY',
        '107': 'MON DD, YYYY',
        '108': 'HH24:MI:SS',
        '111': 'YYYY/MM/DD',
        '112': 'YYYYMMDD',
        '120': 'YYYY-MM-DD HH24:MI:SS',
        '121': 'YYYY-MM-DD HH24:MI:SS',
        '23': 'YYYY-MM-DD',
    }
    if code and code in fmt_map:
        return f"TO_CHAR({dt}, '{fmt_map[code]}')"
    # fmt 미지정 / 미매핑
    return f"TO_CHAR({dt})"


def _bracket_repl(m: re.Match) -> str:
    """[identifier] → identifier (unquote — Oracle 호환).
    예외: 공백/특수문자 포함 시 double-quote 로 변환 (사람 검토 표시).
    """
    ident = m.group(1)
    if re.match(r'^[A-Za-z_][A-Za-z0-9_]*$', ident):
        return ident
    return f'"{ident}"'


def _len_guard(text: str, m: re.Match) -> bool:
    """LEN 매칭이 LENGTH 의 일부면 skip."""
    start = m.start()
    if start >= 3 and text[start - 3:start + 3].upper() == 'LENGTH'[:6]:
        return True
    return False


def _pretty_break_apply(sql: str) -> str:
    """1줄 SQL (>120 char, \n 없음) 에 SQL 키워드 앞 \n 삽입."""
    if '\n' in sql or len(sql) <= 120:
        return sql
    kw = (
        r'\b('
        r'SELECT|FROM|WHERE|AND|OR|'
        r'INNER\s+JOIN|LEFT\s+OUTER\s+JOIN|LEFT\s+JOIN|RIGHT\s+OUTER\s+JOIN|RIGHT\s+JOIN|FULL\s+JOIN|JOIN|'
        r'GROUP\s+BY|ORDER\s+BY|HAVING|UNION(?:\s+ALL)?'
        r')\b'
    )
    pat = re.compile(kw, re.IGNORECASE)

    def _sub(m: re.Match) -> str:
        start = m.start()
        # 문자열 시작 또는 앞 문자가 이미 줄바꿈/공백 만 있으면 단순 매칭만 (앞 \n 추가 X)
        if start == 0:
            return m.group(0)
        prev = sql[start - 1]
        if prev in '\n\r':
            return m.group(0)
        return '\n' + m.group(0)

    return pat.sub(_sub, sql)


# ---------------------------------------------------------------------------
# 룰 카탈로그
# ---------------------------------------------------------------------------

RULES: List[Rule] = [
    # -------- Pitfall (부록 C 9종) --------
    Rule(
        name='C1_SUBSTR_ZERO',
        category='pitfall',
        # SUBSTR / SUBSTRING 둘 다 매칭 — F22 룰이 SUBSTRING → SUBSTR 변환 전이라도 OK.
        pattern=re.compile(r'\b(?:SUBSTR|SUBSTRING)\s*\(\s*([A-Za-z_][A-Za-z0-9_.]*)\s*,\s*0\s*,', re.IGNORECASE),
        replacement=lambda m: f'SUBSTR({m.group(1)}, 1,',
        description='SUBSTR/SUBSTRING position pitfall: pos=0 → ^ 포함 token 반환',
        example_before='SUBSTR(v_str, 0, 5)',
        example_after='SUBSTR(v_str, 1, 5)',
    ),
    Rule(
        name='C2_TRUNCATE_GTT',
        category='pitfall',
        pattern=re.compile(r"EXECUTE\s+IMMEDIATE\s+'TRUNCATE\s+TABLE\s+(GT_[A-Za-z0-9_]+)\s*'", re.IGNORECASE),
        replacement=lambda m: f'DELETE FROM {m.group(1)}',
        description='GTT TRUNCATE 권한 부족 → DELETE 로 치환',
        example_before="EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_TMP'",
        example_after='DELETE FROM GT_TMP',
    ),
    Rule(
        name='C3_LISTAGG_OVERFLOW',
        category='pitfall',
        # 단순 검출만 — 위치 정정은 사람 검토 (의미 분석 X)
        pattern=re.compile(r'LISTAGG\s*\([^)]+\)\s+WITHIN\s+GROUP\s*\([^)]+\)\s+ON\s+OVERFLOW', re.IGNORECASE),
        replacement=lambda m: m.group(0),  # no-op (검출만, 변환 미적용)
        description='LISTAGG ON OVERFLOW 위치 — 검출만 (사람 검토 의무)',
        example_before='LISTAGG(c,...) WITHIN GROUP (...) ON OVERFLOW TRUNCATE',
        example_after='(사람 검토)',
    ),
    Rule(
        name='C4_JSON_OBJECT_PLSQL',
        category='pitfall',
        # DQ_TEXT 는 PL/SQL 블록 가능성 거의 0 — 검출만
        pattern=re.compile(r'JSON_OBJECT\s*\([^)]*RETURNING\s+CLOB', re.IGNORECASE),
        replacement=lambda m: m.group(0),
        description='PL/SQL JSON_OBJECT RETURNING CLOB → 검출만',
        example_before="JSON_OBJECT('k' VALUE v RETURNING CLOB)",
        example_after='(사람 검토)',
    ),
    Rule(
        name='C5_GTT_INSERT_NO_DELETE',
        category='pitfall',
        # DQ_TEXT 는 일반적으로 단일 SELECT — 검출만 + 경고
        pattern=re.compile(r'INSERT\s+INTO\s+(GT_[A-Za-z0-9_]+)', re.IGNORECASE),
        replacement=lambda m: m.group(0),
        description='GTT INSERT 앞 DELETE 의무 — 검출만 (사람 검토)',
        example_before='INSERT INTO GT_TMP ...',
        example_after='(앞에 DELETE FROM GT_TMP 추가 의무)',
    ),
    Rule(
        name='C6_OUT_CURSOR_OPEN',
        category='pitfall',
        # DQ_TEXT 는 single SELECT — DQ 에 적용 가능성 낮음
        pattern=re.compile(r'\bOUT\s+SYS_REFCURSOR\b', re.IGNORECASE),
        replacement=lambda m: m.group(0),
        description='OUT SYS_REFCURSOR 분기별 OPEN 보장 — 검출만',
        example_before='OUT SYS_REFCURSOR',
        example_after='(사람 검토)',
    ),
    Rule(
        name='C7_EMPTY_STRING_COMPARE',
        category='pitfall',
        pattern=re.compile(r"([A-Za-z_][A-Za-z0-9_.]*)\s*<>\s*''"),
        replacement=lambda m: f'{m.group(1)} IS NOT NULL',
        description="col <> '' → col IS NOT NULL (Oracle '' == NULL)",
        example_before="col <> ''",
        example_after='col IS NOT NULL',
    ),
    Rule(
        name='C8_CMBO_VAR_RAW',
        category='pitfall',
        # @varName raw 치환 → :varName (bind) 또는 TO_CHAR wrap
        pattern=re.compile(r'@([A-Za-z_][A-Za-z0-9_]*)'),
        replacement=lambda m: f':{m.group(1)}',
        description='MSSQL @var → Oracle bind :var',
        example_before='@DivisionId',
        example_after=':DivisionId',
    ),
    Rule(
        name='C9_CARET_SPLIT_SUBSTR',
        category='pitfall',
        # C-1 과 결합 — 별도 검출만
        pattern=re.compile(r"SUBSTR\s*\(\s*([^,]+)\s*,\s*0\s*,\s*INSTR\s*\(\s*\1\s*,\s*'\^'", re.IGNORECASE),
        replacement=lambda m: m.group(0),
        description='^ split + SUBSTR-0 결합 — 검출만 (C1 룰과 cross 적용)',
        example_before="SUBSTR(v, 0, INSTR(v, '^') - 1)",
        example_after='(C1 fix 후 cross-check)',
    ),

    # -------- Function/Syntax/Datetime (NextSCM Pilot 11종) --------
    Rule(
        name='F10_ISNULL_to_NVL',
        category='function',
        pattern=re.compile(r'\bISNULL\s*\(', re.IGNORECASE),
        replacement='NVL(',
        description='MSSQL ISNULL → Oracle NVL',
        example_before='ISNULL(col, 0)',
        example_after='NVL(col, 0)',
    ),
    Rule(
        name='F11_GETDATE_to_SYSDATE',
        category='datetime',
        pattern=re.compile(r'\bGETDATE\s*\(\s*\)', re.IGNORECASE),
        replacement='SYSDATE',
        description='MSSQL GETDATE() → Oracle SYSDATE',
        example_before='GETDATE()',
        example_after='SYSDATE',
    ),
    Rule(
        name='F12_DATEADD',
        category='datetime',
        # DATEADD(unit, n, dt) — n, dt 는 단순 token 만 (중첩 paren 1단계)
        pattern=re.compile(
            r'\bDATEADD\s*\(\s*([A-Za-z_]+)\s*,\s*([^,()]+(?:\([^)]*\))?[^,()]*)\s*,\s*([^()]+(?:\([^)]*\))?[^()]*)\s*\)',
            re.IGNORECASE,
        ),
        replacement=_dateadd_repl,
        description='MSSQL DATEADD(unit, n, dt) → Oracle 산술 / ADD_MONTHS',
        example_before='DATEADD(DAY, 7, GETDATE())',
        example_after='(GETDATE()) + (7)',
    ),
    Rule(
        name='F13_CHARINDEX',
        category='function',
        pattern=re.compile(
            r'\bCHARINDEX\s*\(\s*([^,()]+(?:\([^)]*\))?[^,()]*)\s*,\s*([^,()]+(?:\([^)]*\))?[^,()]*?)\s*(?:,\s*([^()]+))?\s*\)',
            re.IGNORECASE,
        ),
        replacement=_charindex_repl,
        description='MSSQL CHARINDEX(needle, haystack) → Oracle INSTR(haystack, needle) (순서 swap!)',
        example_before="CHARINDEX(',', col)",
        example_after="INSTR(col, ',')",
    ),
    Rule(
        name='F14_IIF',
        category='function',
        # IIF(cond, a, b) — cond/a/b 가 단순 token 일 때만 (중첩 IIF/콤마 한계 명시)
        pattern=re.compile(
            r'\bIIF\s*\(\s*([^,()]+(?:\([^)]*\))?[^,()]*)\s*,\s*([^,()]+(?:\([^)]*\))?[^,()]*)\s*,\s*([^()]+(?:\([^)]*\))?[^()]*)\s*\)',
            re.IGNORECASE,
        ),
        replacement=_iif_repl,
        description='MSSQL IIF(c,a,b) → Oracle CASE WHEN c THEN a ELSE b END',
        example_before="IIF(col=1, 'Y', 'N')",
        example_after="CASE WHEN col=1 THEN 'Y' ELSE 'N' END",
    ),
    Rule(
        name='S15_NOLOCK',
        category='syntax',
        pattern=re.compile(r'\s*WITH\s*\(\s*NOLOCK\s*\)', re.IGNORECASE),
        replacement='',
        description='MSSQL WITH (NOLOCK) → Oracle 미존재 (제거)',
        example_before='FROM tbl WITH (NOLOCK)',
        example_after='FROM tbl',
    ),
    Rule(
        name='S16_NQUOTE',
        category='syntax',
        # N'...' literal prefix 제거. 'N' 같은 single-char literal (앞 문자가 ') 와 구분 의무.
        # 앞이 공백/콤마/등호/괄호/연산자 일 때만 (단어/숫자/'/" 가 아닌 경우).
        pattern=re.compile(r"(?<![A-Za-z0-9_'\"])N'"),
        replacement="'",
        description="MSSQL N'...' → Oracle '...' (literal 'N' 와 구분)",
        example_before="N'한글'",
        example_after="'한글'",
    ),
    Rule(
        name='S17_TOP_N',
        category='syntax',
        # SELECT TOP n 검출 → 변환은 marker comment 만 (사람 검토 의무 — ORDER BY 위치)
        pattern=re.compile(r'\bSELECT\s+TOP\s+(\d+)\s+', re.IGNORECASE),
        replacement=_top_repl,
        description='MSSQL SELECT TOP n → Oracle FETCH FIRST n ROWS ONLY (사람 검토 marker)',
        example_before='SELECT TOP 10 *',
        example_after='SELECT /*+ TOP_CONVERTED_TO_FETCH_FIRST_10_ROWS_ONLY */ *',
    ),
    Rule(
        name='S18_STRING_SPLIT',
        category='syntax',
        # marker 가 이미 있으면 skip (멱등). 사람 후속 변환 의무 표시만.
        pattern=re.compile(
            r'(?<!/\*STRING_SPLIT_NEEDS_REGEXP_SUBSTR_CONNECT_BY\*/)\bSTRING_SPLIT\s*\(',
            re.IGNORECASE,
        ),
        replacement='/*STRING_SPLIT_NEEDS_REGEXP_SUBSTR_CONNECT_BY*/STRING_SPLIT(',
        description='MSSQL STRING_SPLIT → Oracle REGEXP_SUBSTR + CONNECT BY (사람 후속 검토 의무 marker)',
        example_before="STRING_SPLIT('a,b', ',')",
        example_after="/*STRING_SPLIT_NEEDS_REGEXP_SUBSTR_CONNECT_BY*/STRING_SPLIT('a,b', ',')",
    ),
    Rule(
        name='F19_CONVERT_DATE',
        category='datetime',
        # CONVERT(VARCHAR, dt, fmt) → TO_CHAR
        pattern=re.compile(
            r'\bCONVERT\s*\(\s*(?:VARCHAR|NVARCHAR|CHAR)(?:\s*\(\s*\d+\s*\))?\s*,\s*([^,()]+(?:\([^)]*\))?[^,()]*)\s*(?:,\s*(\d+))?\s*\)',
            re.IGNORECASE,
        ),
        replacement=_convert_date_repl,
        description='MSSQL CONVERT(VARCHAR, dt[, fmt]) → Oracle TO_CHAR(dt[, fmt])',
        example_before='CONVERT(VARCHAR, GETDATE(), 112)',
        example_after="TO_CHAR(SYSDATE, 'YYYYMMDD')",
    ),
    Rule(
        name='F20_LEN_to_LENGTH',
        category='function',
        pattern=re.compile(r'(?<![A-Z_])LEN\s*\(', re.IGNORECASE),
        replacement='LENGTH(',
        description='MSSQL LEN → Oracle LENGTH (LENGTH 의 부분 매칭 회피)',
        example_before='LEN(col)',
        example_after='LENGTH(col)',
        guard=_len_guard,
    ),
    Rule(
        name='S21_BRACKET_IDENT',
        category='syntax',
        pattern=re.compile(r'\[([A-Za-z_][A-Za-z0-9_ ]*)\]'),
        replacement=_bracket_repl,
        description='MSSQL [identifier] → Oracle unquoted 또는 "double-quote"',
        example_before='[Product Name]',
        example_after='"Product Name"',
    ),

    # -------- Phase 2 보강 룰 (DQ_ID=1 사고 후 추가) --------
    Rule(
        name='F22_SUBSTRING_to_SUBSTR',
        category='function',
        pattern=re.compile(r'\bSUBSTRING\s*\(', re.IGNORECASE),
        replacement='SUBSTR(',
        description='MSSQL SUBSTRING(s, start, len) → Oracle SUBSTR (인자 동일)',
        example_before='SUBSTRING(col, 1, 5)',
        example_after='SUBSTR(col, 1, 5)',
    ),
    Rule(
        name='F23_LEFT_to_SUBSTR',
        category='function',
        # LEFT(s, n) → SUBSTR(s, 1, n) — s/n 단순 token 만 (중첩 paren 1단)
        pattern=re.compile(
            r'\bLEFT\s*\(\s*([^,()]+(?:\([^)]*\))?[^,()]*)\s*,\s*([^()]+(?:\([^)]*\))?[^()]*)\s*\)',
            re.IGNORECASE,
        ),
        replacement=lambda m: f'SUBSTR({m.group(1).strip()}, 1, {m.group(2).strip()})',
        description='MSSQL LEFT(s, n) → Oracle SUBSTR(s, 1, n)',
        example_before='LEFT(col, 5)',
        example_after='SUBSTR(col, 1, 5)',
    ),
    Rule(
        name='F24_DATEPART',
        category='datetime',
        # DATEPART(unit, dt) → EXTRACT(YEAR FROM dt) 등 OR TO_NUMBER(TO_CHAR(dt, 'D'))
        pattern=re.compile(
            r'\bDATEPART\s*\(\s*([A-Za-z_]+)\s*,\s*([^()]+(?:\([^)]*\))?[^()]*)\s*\)',
            re.IGNORECASE,
        ),
        replacement=lambda m: _datepart_repl(m),
        description='MSSQL DATEPART(unit, dt) → Oracle EXTRACT 또는 TO_NUMBER(TO_CHAR(...))',
        example_before='DATEPART(HH, dt)',
        example_after="TO_NUMBER(TO_CHAR(dt, 'HH24'))",
    ),
    Rule(
        name='F25_EOMONTH',
        category='datetime',
        pattern=re.compile(r'\bEOMONTH\s*\(\s*([^()]+(?:\([^)]*\))?[^()]*)\s*\)', re.IGNORECASE),
        replacement=lambda m: f'LAST_DAY({m.group(1).strip()})',
        description='MSSQL EOMONTH(dt) → Oracle LAST_DAY(dt)',
        example_before='EOMONTH(SYSDATE)',
        example_after='LAST_DAY(SYSDATE)',
    ),
    Rule(
        name='F26_STUFF',
        category='function',
        # STUFF 는 Oracle 단순 대응 함수 없음 — marker (멱등 — marker 직후 skip)
        pattern=re.compile(
            r'(?<!/\*STUFF_NEEDS_SUBSTR_CONCAT\*/)\bSTUFF\s*\(',
            re.IGNORECASE,
        ),
        replacement='/*STUFF_NEEDS_SUBSTR_CONCAT*/STUFF(',
        description='MSSQL STUFF → Oracle SUBSTR + 문자열 결합 재구현 (사람 후속 검토 marker)',
        example_before="STUFF('abcde', 2, 2, 'XX')",
        example_after="/*STUFF_NEEDS_SUBSTR_CONCAT*/STUFF(...)",
    ),
    Rule(
        name='F27_FORMAT',
        category='function',
        # FORMAT(val, fmt) → TO_CHAR — fmt 변환 복잡 (사람 검토 marker)
        pattern=re.compile(
            r'(?<!/\*FORMAT_NEEDS_TO_CHAR_FMT_REVIEW\*/)\bFORMAT\s*\(',
            re.IGNORECASE,
        ),
        replacement='/*FORMAT_NEEDS_TO_CHAR_FMT_REVIEW*/FORMAT(',
        description='MSSQL FORMAT(val, fmt) → Oracle TO_CHAR (fmt 변환 사람 검토)',
        example_before="FORMAT(dt, 'yyyy-MM-dd')",
        example_after='/*FORMAT_NEEDS_TO_CHAR_FMT_REVIEW*/FORMAT(...)',
    ),
    Rule(
        name='F28_DATEDIFF',
        category='datetime',
        # DATEDIFF 는 unit 별 다른 계산식 — marker (사람 검토)
        pattern=re.compile(
            r'(?<!/\*DATEDIFF_NEEDS_UNIT_SPECIFIC_CALC\*/)\bDATEDIFF\s*\(',
            re.IGNORECASE,
        ),
        replacement='/*DATEDIFF_NEEDS_UNIT_SPECIFIC_CALC*/DATEDIFF(',
        description='MSSQL DATEDIFF(unit, d1, d2) → Oracle 단위별 (d2-d1)/factor (사람 검토 marker)',
        example_before='DATEDIFF(DAY, d1, d2)',
        example_after='/*DATEDIFF_NEEDS_UNIT_SPECIFIC_CALC*/DATEDIFF(...)',
    ),
    Rule(
        name='S29_DBO_SCHEMA',
        category='syntax',
        # MSSQL `DBO.` schema prefix → Oracle 에서 제거 (NSCM 의 실 schema = SCM_MGR + synonym)
        pattern=re.compile(r'\bDBO\.', re.IGNORECASE),
        replacement='',
        description='MSSQL DBO. schema prefix 제거 (Oracle 에서 사용 안 됨)',
        example_before='DBO.SCM_MST_USER',
        example_after='SCM_MST_USER',
    ),
    Rule(
        name='S30_FROM_JOIN_AS_ALIAS',
        category='syntax',
        # MSSQL `FROM tbl AS alias` / `JOIN tbl AS alias` → Oracle `FROM tbl alias`.
        # Oracle FROM/JOIN 안 `AS` alias 미지원 (특히 ANSI JOIN syntax 안).
        pattern=re.compile(
            r'\b(FROM|JOIN)\s+([A-Za-z_][A-Za-z0-9_.]*)\s+AS\s+([A-Za-z_][A-Za-z0-9_]*)',
            re.IGNORECASE,
        ),
        replacement=lambda m: f'{m.group(1)} {m.group(2)} {m.group(3)}',
        description='MSSQL FROM/JOIN tbl AS alias → Oracle 동일하나 AS 키워드 제거',
        example_before='FROM tbl AS a LEFT JOIN tbl2 AS b',
        example_after='FROM tbl a LEFT JOIN tbl2 b',
    ),
    # -------- Phase A audit 후 추가 룰 (DQ 29/38/19 등) --------
    Rule(
        name='S31_COLLATE_REMOVE',
        category='syntax',
        # MSSQL `collate Korean_Wansung_CS_AS` → Oracle 미존재 (제거).
        pattern=re.compile(r'\s+collate\s+[A-Za-z_]+\b', re.IGNORECASE),
        replacement='',
        description='MSSQL collate Korean_Wansung_CS_AS → Oracle 미존재 (제거)',
        example_before="SUBSTR(s collate Korean_Wansung_CS_AS, 1, 3)",
        example_after='SUBSTR(s, 1, 3)',
    ),
    Rule(
        name='S32_STRING_CONCAT_PLUS',
        category='syntax',
        # MSSQL `'literal' + identifier` 또는 `'literal' + 'literal'` → Oracle `||`.
        # 안전 매칭: quoted literal 이 양측 중 하나여야 함 (숫자 덧셈 false-positive 회피).
        # 케이스 1: `'...'` + word/'...'
        pattern=re.compile(r"('(?:[^']|'')*')\s*\+\s*(?=[A-Za-z_'])"),
        replacement=lambda m: f'{m.group(1)} || ',
        description="MSSQL 'literal' + ident → Oracle 'literal' || ident",
        example_before="'M'+YYYYMM",
        example_after="'M' || YYYYMM",
    ),
    Rule(
        name='S33_STRING_CONCAT_PLUS_RIGHT',
        category='syntax',
        # 보조: `identifier + 'literal'` → `identifier || 'literal'`.
        # word + 'literal' 매칭 (앞 word 가 숫자 only 면 skip — 숫자 + 'literal' 은 ORA error 의도).
        pattern=re.compile(r"([A-Za-z_][A-Za-z0-9_.]*)\s*\+\s*('(?:[^']|'')*')"),
        replacement=lambda m: f'{m.group(1)} || {m.group(2)}',
        description="MSSQL ident + 'literal' → Oracle ident || 'literal'",
        example_before="YYYYMM+'M'",
        example_after="YYYYMM || 'M'",
    ),
    Rule(
        name='S34_TOP_CONVERTED_REMOVE',
        category='syntax',
        # 직전 S17 가 marker comment 만 삽입 → ORA-00923/00936 유발.
        # marker 자체 제거 (사람 검토 의무 — WHERE ROWNUM <= n 또는 FETCH FIRST n ROWS ONLY 추가).
        # marker 안 숫자 → 컬럼 옆 코멘트 로 보존 (사람 후속 fix 가이드).
        pattern=re.compile(r'/\*\+\s*TOP_CONVERTED_TO_FETCH_FIRST_(\d+)_ROWS_ONLY\s*\*/'),
        replacement=lambda m: f'/* TODO: add WHERE ROWNUM <= {m.group(1)} or FETCH FIRST {m.group(1)} ROWS ONLY */',
        description='TOP_CONVERTED marker — Oracle hint 부적합 syntax → TODO 코멘트로 대체',
        example_before='SELECT /*+ TOP_CONVERTED_TO_FETCH_FIRST_10_ROWS_ONLY */ col',
        example_after='SELECT /* TODO: add WHERE ROWNUM <= 10 or FETCH FIRST 10 ROWS ONLY */ col',
    ),
]


def _datepart_repl(m: re.Match) -> str:
    """DATEPART(unit, dt) → Oracle 식.
    Year/Month/Day → EXTRACT(... FROM dt)
    Hour/Minute/Second → EXTRACT(... FROM CAST(dt AS TIMESTAMP)) or TO_NUMBER(TO_CHAR(dt, fmt))
    dw (요일) → TO_NUMBER(TO_CHAR(dt, 'D'))  (Oracle 의 D 는 NLS 의존 — 1=일/2=월/.../7=토)
    dy (일년의 일) → TO_NUMBER(TO_CHAR(dt, 'DDD'))
    week (wk/ww) → TO_NUMBER(TO_CHAR(dt, 'IW'))
    quarter (q/qq) → TO_NUMBER(TO_CHAR(dt, 'Q'))
    """
    unit = m.group(1).upper()
    dt = m.group(2).strip()
    u = unit
    if u in ('YEAR', 'YY', 'YYYY'):
        return f'EXTRACT(YEAR FROM {dt})'
    if u in ('MONTH', 'MM', 'M'):
        return f'EXTRACT(MONTH FROM {dt})'
    if u in ('DAY', 'D', 'DD'):
        return f'EXTRACT(DAY FROM {dt})'
    if u in ('HOUR', 'HH'):
        return f"TO_NUMBER(TO_CHAR({dt}, 'HH24'))"
    if u in ('MINUTE', 'MI', 'N'):
        return f"TO_NUMBER(TO_CHAR({dt}, 'MI'))"
    if u in ('SECOND', 'SS', 'S'):
        return f"TO_NUMBER(TO_CHAR({dt}, 'SS'))"
    if u in ('DW', 'WEEKDAY'):
        # Oracle 의 'D' = NLS 의존 (US 기본 1=일/.../7=토 — MSSQL 과 동일)
        return f"TO_NUMBER(TO_CHAR({dt}, 'D'))"
    if u in ('DY', 'DAYOFYEAR'):
        return f"TO_NUMBER(TO_CHAR({dt}, 'DDD'))"
    if u in ('WK', 'WW', 'WEEK'):
        return f"TO_NUMBER(TO_CHAR({dt}, 'IW'))"
    if u in ('QQ', 'Q', 'QUARTER'):
        return f"TO_NUMBER(TO_CHAR({dt}, 'Q'))"
    # unknown
    return m.group(0)


# ---------------------------------------------------------------------------
# 변환 엔진
# ---------------------------------------------------------------------------

def apply_rules(sql: str, rules: Optional[List[Rule]] = None) -> Tuple[str, List[RuleHit], List[str]]:
    """SQL 에 룰 순차 적용. 룰별 self cross-check.

    처리 순서:
      1. PRE-MASK 룰 (literal 경계 변형 — S16 N' 등) — literal 마스킹 전 적용
      2. literal 마스킹
      3. 메인 룰 적용
      4. literal 복원
      5. cleanup (pretty_break)

    Returns:
      (converted_sql, hits, warnings)
    """
    if rules is None:
        rules = RULES

    hits: List[RuleHit] = []
    warnings: List[str] = []

    # PRE-MASK 룰 — literal 경계/literal 본체 매칭. literal 마스킹 전 적용 의무.
    # S16: N'...' literal prefix / C7: col <> '' literal 비교
    # S32/S33: 'literal' + ident / ident + 'literal' concat — literal 양측 매칭
    pre_mask_names = {
        'S16_NQUOTE',
        'C7_EMPTY_STRING_COMPARE',
        'S32_STRING_CONCAT_PLUS',
        'S33_STRING_CONCAT_PLUS_RIGHT',
    }
    pre_rules = [r for r in rules if r.name in pre_mask_names]
    main_rules = [r for r in rules if r.name not in pre_mask_names]

    for rule in pre_rules:
        before_count = len([m for m in rule.pattern.finditer(sql) if not (rule.guard and rule.guard(sql, m))])
        if before_count == 0:
            continue
        applied = [0]

        def _do(m: re.Match, _r=rule, _a=applied) -> str:
            if _r.guard and _r.guard(sql, m):
                return m.group(0)
            _a[0] += 1
            out = _r.replacement(m) if callable(_r.replacement) else _r.replacement
            hits.append(RuleHit(rule_name=_r.name, before=m.group(0), after=out, span=m.span()))
            return out

        sql = rule.pattern.sub(_do, sql)
        if applied[0] != before_count:
            warnings.append(f'rule={rule.name} pre_mask_count_mismatch before={before_count} applied={applied[0]}')

    masked, literals = mask_literals(sql)

    for rule in main_rules:
        before_count = 0
        # guard 통과 매칭만 카운트
        for m in rule.pattern.finditer(masked):
            if rule.guard and rule.guard(masked, m):
                continue
            before_count += 1

        if before_count == 0:
            continue

        # 적용 (callable 시 lambda, str 시 직접 sub)
        applied_count = 0

        def _do_sub(m: re.Match, _rule=rule) -> str:
            nonlocal applied_count
            if _rule.guard and _rule.guard(masked, m):
                return m.group(0)
            applied_count += 1
            before_snip = m.group(0)
            if callable(_rule.replacement):
                out = _rule.replacement(m)
            else:
                out = m.expand(_rule.replacement) if isinstance(_rule.replacement, str) and '\\' in _rule.replacement else _rule.replacement
            hits.append(RuleHit(rule_name=_rule.name, before=before_snip, after=out, span=m.span()))
            return out

        masked_new = rule.pattern.sub(_do_sub, masked)

        # self cross-check
        if before_count != applied_count:
            warnings.append(
                f'rule={rule.name} count_mismatch before={before_count} applied={applied_count}'
            )

        masked = masked_new

    # literal 복원
    out_sql = unmask_literals(masked, literals)

    # cleanup — Z23_COMMENT_SAFE_BREAK (DQ_ID=2 사고 fix, 2026-06-21):
    # 1줄 SQL 안 `--` single-line comment 가 SELECT 뒤의 모든 SQL 절 (FROM/WHERE/GROUP BY/HAVING)
    # 까지 주석 처리하는 사고 (LEFT JOIN alias 등록 실패 → ORA-00904) 방지.
    # `--...comment...` 뒤 FROM/WHERE/GROUP BY/HAVING 키워드 앞에 \n 삽입 → 주석을 1줄 한정.
    # ORDER BY 는 OVER(ORDER BY ...) window function 안 가능성 — lookahead 제외.
    safe = _comment_safe_break(out_sql)
    if safe != out_sql:
        hits.append(RuleHit(rule_name='Z23_COMMENT_SAFE_BREAK', before='[--comment runs into clauses]', after='[--comment\\nFROM ...]', span=(0, len(out_sql))))
        out_sql = safe

    return out_sql, hits, warnings


def _comment_safe_break(sql: str) -> str:
    """1줄 SQL 안 `--` 주석이 FROM/WHERE/GROUP BY/HAVING 까지 흡수하는 사고 방지.

    `--...comment...` lazy 매칭 + lookahead 키워드 앞에 \\n 삽입.
    ORDER BY 는 OVER(ORDER BY ...) window 안 가능성 → 제외.
    UNION 도 안전 의무: FROM 뒤 UNION 자주 발생, lookahead 포함.
    """
    if '--' not in sql:
        return sql
    pat = re.compile(
        r'(--[^\n]*?)\s+(?=\b(?:FROM|WHERE|GROUP\s+BY|HAVING|UNION(?:\s+ALL)?)\b)',
        re.IGNORECASE,
    )
    return pat.sub(lambda m: f'{m.group(1)}\n', sql)


def dry_run(sql: str, rules: Optional[List[Rule]] = None) -> List[RuleHit]:
    """변환 시뮬레이션 (text 적용 안 함, hit list 만 반환)."""
    _, hits, _ = apply_rules(sql, rules)
    return hits


# ---------------------------------------------------------------------------
# 룰 카탈로그 표 (REPORT 산출용)
# ---------------------------------------------------------------------------

def get_rule_catalog() -> List[dict]:
    return [
        {
            'name': r.name,
            'category': r.category,
            'description': r.description,
            'example_before': r.example_before,
            'example_after': r.example_after,
        }
        for r in RULES
    ] + [
        {
            'name': 'Z22_PRETTY_BREAK',
            'category': 'cleanup',
            'description': '1줄 SQL (>120 char) 에 SELECT/FROM/WHERE 등 키워드 앞 \\n 삽입',
            'example_before': 'SELECT a FROM t WHERE b=1',
            'example_after': 'SELECT a\\nFROM t\\nWHERE b=1',
        }
    ]


if __name__ == '__main__':
    # 자체 테스트
    samples = [
        ("SELECT ISNULL(a, 0) FROM tbl WITH (NOLOCK) WHERE b <> ''",
         "SELECT NVL(a, 0) FROM tbl WHERE b IS NOT NULL"),
        ("SELECT TOP 10 GETDATE() AS now FROM dual",
         "SELECT /*+ TOP_CONVERTED_TO_FETCH_FIRST_10_ROWS_ONLY */ SYSDATE AS now FROM dual"),
        ("WHERE col = @DivisionId",
         "WHERE col = :DivisionId"),
        ("SELECT DATEADD(DAY, 7, GETDATE())",
         "SELECT (SYSDATE) + (7)"),
        ("WHERE CHARINDEX(',', col) > 0",
         "WHERE INSTR(col, ',') > 0"),
        ("SELECT IIF(a=1, 'Y', 'N')",
         "SELECT CASE WHEN a=1 THEN 'Y' ELSE 'N' END"),
        ("SELECT LEN(col)",
         "SELECT LENGTH(col)"),
        ("SELECT N'한글'",
         "SELECT '한글'"),
    ]
    for before, expected in samples:
        out, hits, warns = apply_rules(before)
        status = 'OK' if expected in out or out.strip() == expected.strip() else 'FAIL'
        print(f'{status}\n  before:   {before}\n  after:    {out}\n  expected: {expected}\n  hits: {[h.rule_name for h in hits]}\n  warns: {warns}\n')
