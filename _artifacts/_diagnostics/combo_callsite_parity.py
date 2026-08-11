#!/usr/bin/env python3
"""combo_callsite_parity.py — AS-IS ↔ TO-BE **콤보 호출 지점 수(N:N) 대사** (2026-08-08 신설)

배경(hook #117 §5.12): SQL 도 파라미터도 맞는데 **부르는 시점이 빠지면 기능이 조용히 죽는다.**
같은 날 2건이 나왔다 —
  · `FCST_PRICE_EDIT_MEASURE` AS-IS 6지점 vs TO-BE 1지점 → **InsertRow 누락**으로 사이트 특성(VMI_YN)
    measure 필터가 시드복사 정상흐름에서 상시 미적용
  · `CELL_PROD_SITE_ID` AS-IS 2지점 vs TO-BE 0지점 (매핑표엔 "구현" 오기재)
기존 게이트(섹션 7 / E2E D2축)는 "올바른 데이터를 주는가" 만 본다 — "제때 부르는가" 는 본 도구가 담당.

추출 (다중 패턴 — anti-simplification):
  AS-IS `.cs`  ① `GetLookupValues("CODE", …)` 범용 디스패처 호출부 리터럴
               ② `Data.Type.<Code>` (기본판 은닉 호출)
               ③ `Data.User<Code>(` (은닉 호출 — UserSiteByEndCustomer 등)
               ④ `Parameters["CODE"] = "리터럴"` = **명명 헬퍼 정의** → 헬퍼의 **호출부**로 치환
               ⑤ 주석(`//`) 라인 제외 — 사문 호출은 미이관이 파리티(제외 건수 보고)
  TO-BE FE     ⑥ `getCombo({comboId:'X'…})` 명시 호출부 (+ 감싸는 함수명)
               ⑦ `useTabComboQueries` filters 리터럴 = 페이지 1회 프리페치
               ⑧ `SHEET_COLUMNS.CELL_COMBO_DATA_TYPE` = DataGrid 자동 바인딩(렌더 1회)

판정:
  FAIL  AS-IS 라이브 호출 ≥2 인데 TO-BE 명시 호출 0 & 메타 자동 바인딩도 없음 → 배선 자체 부재
  FAIL  AS-IS 에 **행 생성(InsertRow) 지점**이 있는데 TO-BE 에 신규행 프라이밍 경로 없음
        (시드복사 화면은 전 사용자가 이 경로를 타므로 가장 치명적)
  WARN  AS-IS 호출 지점 수 > TO-BE 호출 지점 수 (트리거 부족 의심 — 사유 기재 필요)
  PASS  그 외

사용:
  python combo_callsite_parity.py --menu DMF0082 --page nscm-fe/features/demand/src/pages/forecast-price
  python combo_callsite_parity.py --all          # FE MENU_ID 상수 보유 화면 전수
"""
import argparse
import datetime
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
# ⭐ AS-IS 원천 = **최신 소스 `GSCM/06.UIL`** (memory: asis-source-folders, 사용자 지정 2026-07-16).
#   `Doc/_legacy_source/` 는 **그보다 이전의 부분 사본**이다 — 정본 판정에 쓰면 안 된다.
#   (2026-08-09 실측: 구 코드가 legacy 를 읽고 DMF0042 구정본 3,477행을 집었다.)
GSCM_UIL = ROOT / "GSCM" / "06.UIL"
LEGACY = ROOT / "Doc" / "_legacy_source"      # GSCM 부재 시 폴백(리포트에 경고 표기)
FE_ROOT = ROOT / "nscm-fe" / "features"
REPORT_DIR = ROOT / "_artifacts" / "_gate_reports"

# ⭐ AS-IS 정본 레지스트리 (2026-08-09 신설) — 자동 규칙으로 **유일 확정이 안 되는** 화면만 등록한다.
#   값 = ROOT 기준 상대경로. 여기에 없고 자동 규칙도 모호하면 **FAIL**(조용한 임의 선택 금지).
#   ⛔ 배경: 구 `resolve_cs()` 는 `rglob("{menu}_*.cs")` 의 `hits[0]` 을 그대로 썼다.
#      DMF0042 는 후보가 10개였고 구정본 `DMF0042_1_BizPlan.cs`(3,477행)가 뽑혀
#      전체 대사 결과(FAIL 5/WARN 6/PASS 3)가 무의미해졌다. hook #126 §5 "게이트 자기검증".
ASIS_CANON = {
    # DMF0043 = Contribute Main/View 2본이 같은 MENU_ID 를 공유 — 메인 화면이 정본.
    "DMF0043": "GSCM/06.UIL/GSCM.DM.Forms.UIL/Master/DMF0043_Contribute_Main/DMF0043_Contribute_Main.cs",
}

# ⛔ `{MENU}_1_` / `{MENU}_2_` / `{MENU}_T_` 접미는 **변형본이 아니라 별개 화면**이다
#   (사용자 확정 2026-07-16 — "DMF0003_1 / DMF0003_T 는 별개 화면, DMF0003 아님. 분석·대조 범위 어디에도 포함 금지").
#   따라서 정본 탐색에서 **제외**한다. 이 규칙이 없으면 DMF0042 후보가 10개로 불어난다.
SEPARATE_SCREEN_RE = re.compile(r"^[A-Z]{2,4}\d{4}_(?:\d+|T)_")

# AS-IS CODE ↔ TO-BE SQL_ID 별칭 — 정규화(영숫자 소문자) 매칭이 안 되는 개명분.
#   ⚠️ 여기에 없는 미매칭은 '미식별 WARN' 으로 노출된다(조용한 통과 금지).
CODE_ALIAS = {
    "AS_INCOTERMS": "AsIncotermsEdit",          # AS 사이트 전용 Incoterms 편집판
    "DM_CUSTOMS_HANDBOOK": "CustomsHandbook",   # lookup DM_CUSTOMS_HANDBOOK_40
    "SiteByEndCustomer40": "ScmSitebyEndCustomer40",
    "FromSiteByDivision": "PlantByDivisionCompany",
}

# ⭐ 화면별 별칭 (2026-08-09 신설) — 개명은 **화면마다 다르다**. 전역 CODE_ALIAS 에 넣으면
#   타 화면을 오매칭시킨다(예: AS-IS `FromSiteByDivision` = DMF0082 `PlantByDivisionCompany`
#   ↔ DMF0042 조회조건 `PlantSitebyEndCustomer`). 화면별이 전역보다 **우선**한다.
MENU_CODE_ALIAS = {
    "DMF0042": {
        # 조회조건 (AS-IS InitControls L250~331 / cboDivision_SelectedIndexChanged L1490~1563)
        #   ↔ BusinessPlanForm.tsx — 2026-07-23 조회조건 AS-IS 정합(사용자 승인) 산출물.
        "TeamByDivision": "UserTeamByDivision",          # TeamField comboId (:179)
        "DM_BIZ_TYPE": "DmBizType",                      # 40 Biz Type (:76)
        "SiteByEndCustomer40": "UserSiteByEndCustomer",   # SalesSiteField comboId (:216) — 40 cascade 포함
        "PlantSiteByDivision": "PlantSitebyEndCustomer",  # Plant Site (:80, endCustomer='ALL' — 2026-08-05 F-4)
        # 그리드 InsertRow 셀 콤보 (AS-IS L1233~1252 권한판) ↔ TO-BE 메타 비권한판
        "EndCustomerByDivisionDeptAuth": "EndCustomerByDivisionDept",
        "TeamByDivisionAuth": "DeptId",
        "SiteByEndCustomerAuth": "SiteByEndCustomer",
    },
    "DMF0044": {
        # AS-IS `.cs` L1224 `Data.Common(Type.DMF0044_MDF_ENDCUST_REPORT, false, "", "")` 는
        #   END_CUST_REPORT **컬럼**에 SetCellTypeCombo 로 재바인딩한다(파라미터 없음 = 전량 동일 목록).
        # 근거 3축 (2026-08-10, AS-IS DB 직접 대조):
        #   ① 적용 컬럼이 END_CUST_REPORT (`.cs` L1230 SetCellTypeCombo)
        #   ② AS-IS SCM_MST_SHEET_COLUMNS 의 그 컬럼 = FPComboBox / CELL_COMBO_DATA_TYPE='END_CUST_REPORT'
        #      → AS-IS 자신도 같은 콤보를 메타로 이미 붙여 두고 있다(= 재바인딩은 동일 목록 재적용)
        #   ③ AS-IS LOOKUP 인벤토리에 END_CUST 계열은 END_CUST_REPORT(780행) 하나뿐 (TO-BE 765행)
        # ⚠ 한계: AS-IS 콤보 SQL 자체는 BizService(서버측)에 있어 본 저장소에서 읽을 수 없다.
        #   위 3축 정황으로 동일 콤보 개명으로 판정한다 — 반증이 나오면 즉시 재판정할 것.
        "DMF0044_MDF_ENDCUST_REPORT": "END_CUST_REPORT",
    },
}

# 화면별 '이식 안 함' 판정 — 사유 없는 WARN 이 쌓이면 게이트가 무시된다(hook #117 §5.6 규약).
DISPOSITION = {
    "DMF0082": {
        "NO_DATA": "AS-IS 는 빈 목록 콤보로 입력 차단 — TO-BE 는 빈 DataMap 스왑으로 동등 구현(콤보 불요)",
        "TeamByDivisionAuth": "TEAM_ID 는 SAVE 파라미터 부재 = 표시 전용 → 편집판 미적용(hook #117 §5.10)",
    },
    "DMF0049": {
        # ⭐ 2026-08-10 판정 — 근거 = AS-IS DB 직접 대조. DMF0049 `SCM_MST_SHEET_COLUMNS` 는
        #   AS-IS ↔ TO-BE 가 **42행 / VISIBLE_FLAG='Y' 33행 완전 일치**이고, 아래 두 콤보가 붙는
        #   컬럼은 **양쪽 모두 VISIBLE_FLAG='N'**(숨김)이다. AS-IS `.cs` 도 `GetColumnIndex(...) != -1`
        #   가드를 두고 호출하므로 숨김 상태에서는 셀 콤보가 적용되지 않는다 ⇒ 미이관이 파리티.
        "EndCustomerByDivisionDeptAuth":
            "AS-IS L989(InsertRow, 81계열)가 END_CUSTOMER 컬럼에 권한판을 붙이지만 그 컬럼은 "
            "AS-IS·TO-BE 메타 모두 VISIBLE_FLAG='N'(숨김) — 사용자가 편집할 수 없어 적용 대상 없음. "
            "(참고: DMF0042 실측으로 권한판 자체가 '교체 금지' 확정된 계열)",
        "SiteByEndCustomer":
            "AS-IS L1410 이 END_CUSTOMER 변경 시 SCM_SITE_ID 에 붙이지만, TO-BE·AS-IS 메타 모두 "
            "SCM_SITE_ID = CTRL 공백 + VISIBLE_FLAG='N' 이고 **트리거인 END_CUSTOMER 도 숨김**이라 "
            "이벤트 자체가 발생하지 않는다 — 적용 대상 없음",
    },
    "DMF0042": {
        # ⚠ 아래 3종은 '이식 안 함' 이 아니라 **비권한판으로 이식** 했다는 판정이다(별칭은 MENU_CODE_ALIAS).
        #   AS-IS 는 InsertRow 에서 *Auth(권한 필터) 판을 셀 콤보로 붙인다. TO-BE 는 메타 비권한판을 쓴다.
        #
        #   ⭐ 2026-08-09 실측으로 **미적용 확정** (`dmf0042_auth_combo_probe.py`, 사용자 승인 하 조사):
        #     (A) 권한판 0행 계정 8건 — 그 계정은 셀 콤보가 통째로 빈다.
        #         yooah.chung(40 Viewer) EC·Site / bpark416(81 Planner)·wonqthanq(82 **Admin**)·
        #         ys_cho(82 Planner) Team / yeonjusung(82 Viewer) 3종 전부.
        #     (B) 원장(DM_PLN_BP_FCST) 값 중 권한판 후보 **밖** 건수 — 전부 >0 = CODE→NAME 표시 파손:
        #         END_CUSTOMER 79/15,756(0.5%) · DEPT_ID 11,763/16,124(**73.0%**) · SCM_SITE_ID 899/1,296,517(0.1%)
        #   ⇒ hook #117 §5.10 / memory feedback_edit_display_combo_dualization 판정식 = **메타 교체 금지**.
        "EndCustomerByDivisionDeptAuth": "AS-IS InsertRow 권한판 → TO-BE 메타 비권한판 EndCustomerByDivisionDept. "
                                          "2026-08-09 실측: 원장 후보밖 79건(0.5%) + Viewer 2계정 0행 → 교체 금지 확정",
        "TeamByDivisionAuth": "AS-IS InsertRow 권한판 → TO-BE 메타 비권한판 DeptId. "
                               "2026-08-09 실측: 원장 후보밖 11,763건(73.0%) + DM Admin 포함 3계정 0행 → 교체 금지 확정",
        "SiteByEndCustomerAuth": "AS-IS InsertRow 권한판(40) → TO-BE 메타 비권한판 SiteByEndCustomer. "
                                  "2026-08-09 실측: 원장 후보밖 899건(0.1%) + Viewer 2계정 0행 → 교체 금지 확정",
    },
}

# 행 생성(InsertRow) 성격의 AS-IS 메서드명 — 가장 치명적인 누락 지점
INSERT_METHOD_RE = re.compile(r"insert(row|button)?|btninsert|addrow", re.I)


# ── AS-IS 추출 ────────────────────────────────────────────────────────────────
def strip_comments(text: str) -> str:
    """`//` 주석 라인을 공백으로 치환(라인 수·오프셋 보존). 블록 주석도 제거."""
    text = re.sub(r"/\*.*?\*/", lambda m: re.sub(r"[^\n]", " ", m.group(0)), text, flags=re.S)
    out = []
    for line in text.split("\n"):
        s = line.lstrip()
        out.append(" " * len(line) if s.startswith("//") else line)
    return "\n".join(out)


METHOD_RE = re.compile(
    r"^[ \t]*(?:public|private|protected|internal)\s+(?:static\s+|override\s+|async\s+|virtual\s+)*"
    r"[\w<>\[\],\. ]+?\s+(\w+)\s*\([^)]*\)\s*$",
    re.M,
)


def parse_methods(text: str):
    """(메서드명, 시작오프셋, 끝오프셋) 목록 — 시그니처 다음 '{' 부터 중괄호 균형까지."""
    out = []
    for m in METHOD_RE.finditer(text):
        i = text.find("{", m.end())
        if i < 0:
            continue
        depth, j = 0, i
        while j < len(text):
            if text[j] == "{":
                depth += 1
            elif text[j] == "}":
                depth -= 1
                if depth == 0:
                    break
            j += 1
        out.append((m.group(1), m.start(), j))
    return out


def method_at(methods, pos):
    """오프셋이 속한 **가장 안쪽** 메서드명."""
    best, best_span = "(전역)", None
    for name, s, e in methods:
        if s <= pos <= e and (best_span is None or (e - s) < best_span):
            best, best_span = name, e - s
    return best


CODE_PATTERNS = [
    (re.compile(r'GetLookupValues\s*\(\s*"([^"]+)"'), "GetLookupValues"),
    (re.compile(r"Data\.Type\.(\w+)"), "Data.Common"),
    (re.compile(r"Data\.User(\w+)\s*\("), "Data.User*"),
]
HELPER_DEF_RE = re.compile(r'Parameters\s*\[\s*"CODE"\s*\]\s*=\s*"([^"]+)"')


def scan_asis(cs_path: pathlib.Path):
    """{CODE: {'sites': [(메서드, 라인)], 'helpers': [헬퍼명], 'commented': n}}"""
    raw = cs_path.read_text(encoding="utf-8", errors="ignore")
    live = strip_comments(raw)
    methods = parse_methods(live)
    lineno = lambda p: live.count("\n", 0, p) + 1  # noqa: E731

    codes = {}

    def add(code, pos, kind):
        e = codes.setdefault(code, {"sites": [], "helpers": [], "commented": 0, "kinds": set()})
        e["sites"].append((method_at(methods, pos), lineno(pos)))
        e["kinds"].add(kind)

    for rex, kind in CODE_PATTERNS:
        for m in rex.finditer(live):
            add(m.group(1), m.start(), kind)

    # ④ 명명 헬퍼 — 정의 안의 CODE 리터럴을 헬퍼 **호출부**로 치환
    for m in HELPER_DEF_RE.finditer(live):
        holder = method_at(methods, m.start())
        if holder == "(전역)":
            continue
        code = m.group(1)
        if not re.fullmatch(r"[A-Za-z_][\w]*", code):
            continue  # 파라미터 변수(p_code 등) = 범용 디스패처 → ①이 처리
        span = next(((s, e) for n, s, e in methods if n == holder), None)
        e = codes.setdefault(code, {"sites": [], "helpers": [], "commented": 0, "kinds": set()})
        e["helpers"].append(holder)
        e["kinds"].add("헬퍼")
        for cm in re.finditer(r"\b%s\s*\(" % re.escape(holder), live):
            if span and span[0] <= cm.start() <= span[1]:
                continue  # 자기 정의 내부
            e["sites"].append((method_at(methods, cm.start()), lineno(cm.start())))

    # ⑤ 주석 처리된 호출 건수 (사문 = 미이관이 파리티, 은폐 방지용 보고)
    dead = strip_comments(raw)
    for code, e in codes.items():
        pat = re.compile(r'(?:"%s"|Data\.Type\.%s\b)' % (re.escape(code), re.escape(code)))
        e["commented"] = len(pat.findall(raw)) - len(pat.findall(dead))
        e["sites"] = sorted(set(e["sites"]), key=lambda t: t[1])
        e["kinds"] = sorted(e["kinds"])
    return codes


# ── TO-BE 추출 ────────────────────────────────────────────────────────────────
# ⚠️ 일반 `const x = 값` 을 함수로 오인하면 enclosing 이 지역변수가 되어 트리거 추출이 통째로 죽는다
#   (2026-08-08 실측: enclosing 이 div/site/inco/item 으로 잡혀 Insert 프라이밍 미인식 → 오탐 FAIL).
#   → **화살표 함수 / function 선언만** 함수로 인정한다.
FN_RE = re.compile(
    r"^\s*(?:const\s+(\w+)\s*=\s*(?:async\s*)?\([^)]*\)\s*(?::[^=\n]+)?=>"
    r"|function\s+(\w+)\s*\()",
    re.M,
)


PASTE_METHOD_RE = re.compile(r"paste|clipboard", re.I)


def tobe_shares_paste(page_dir: pathlib.Path) -> bool:
    """TO-BE 가 pastedCell/pastingCell 에 **편집 핸들러를 그대로 등록**하면 Paste 는 별도 트리거가 아니다."""
    for f in list(page_dir.rglob("*.tsx")) + list(page_dir.rglob("*.ts")):
        if re.search(r"paste(d|ing)Cell\.addHandler", f.read_text(encoding="utf-8", errors="ignore")):
            return True
    return False


# ⭐ 반응형 배선 훅 (2026-08-09 신설) — TO-BE 표준은 `useTabComboQueries` 다.
#   구 스캐너는 `getCombo(` 만 '호출'로 인정해서, 이 훅만 쓰는 화면은 **트리거 0** 으로 보였다
#   (DMF0042 실측: 13코드 중 트리거 인식 0 → FAIL 5/WARN 5 전량이 이 사각지대 때문).
#   훅은 queryKey 에 파라미터가 들어가므로 **파라미터가 바뀌면 자동 재조회** = AS-IS 의
#   "이벤트마다 재호출" 과 등가다. 따라서 파라미터를 동반한 훅 호출 = 재조회 트리거로 센다.
HOOK_COMBO_RE = re.compile(r"\buseTabComboQuer(?:ies|y)\s*\(")
# 메타 주도 셀 콤보를 한 구독으로 가져오는 호출의 표식 (comboId 가 리터럴이 아님)
META_DYNAMIC = "(동적 메타 콤보)"
# 공용 조회조건 필드 (DivisionField/TeamField/…) — 페이지 폴더 **밖**에 있어 구 스캐너가 못 봤다.
SHARED_FIELDS = ROOT / "nscm-fe" / "features" / "master" / "src" / "components" / "searchFields"
RE_SHARED_IMPORT = re.compile(r"from\s+'(?:features/master/src/components[^']*|@master[^']*)'")
RE_EXPORT_CONST = re.compile(r"^export\s+const\s+(\w+)", re.M)


def _balanced(text: str, start: int, open_ch: str, close_ch: str) -> str:
    depth, i = 0, start
    while i < len(text):
        if text[i] == open_ch:
            depth += 1
        elif text[i] == close_ch:
            depth -= 1
            if depth == 0:
                return text[start : i + 1]
        i += 1
    return text[start:]


def _shared_field_combos(page_dir: pathlib.Path):
    """페이지가 **실제로 import 한** 공용 조회조건 필드가 소유한 comboId → {comboId: 필드명}.

    페이지 폴더만 스캔하면 `<DivisionField/>` 가 내부에서 쓰는 `MyDivision` 이 '미이관'으로 보인다
    (2026-08-09 실측 — AS-IS `Data.Type.MyDivision` 과 이름까지 같은데 FAIL 직전이었다).
    import 한 컴포넌트로 범위를 한정해 과대 귀속을 막는다.
    """
    names = set()
    for f in list(page_dir.rglob("*.tsx")) + list(page_dir.rglob("*.ts")):
        text = f.read_text(encoding="utf-8", errors="ignore")
        for im in RE_SHARED_IMPORT.finditer(text):
            head = text[max(0, im.start() - 600) : im.start()]
            blk = head[head.rfind("import") :]
            names.update(re.findall(r"\b([A-Z]\w+Field)\b", blk))
    if not names or not SHARED_FIELDS.is_dir():
        return {}
    # 페이지가 JSX prop 으로 넘긴 comboId → 소유 필드 (예: <SalesSiteField comboId='UserSiteByEndCustomer'/>)
    prop_owner = {}
    for f in list(page_dir.rglob("*.tsx")):
        text = f.read_text(encoding="utf-8", errors="ignore")
        for jm in re.finditer(r"<([A-Z]\w*Field)\b([\s\S]{0,1500}?)/>", text):
            for lit in re.findall(r"comboId\s*=\s*'([^']+)'", jm.group(2)):
                prop_owner.setdefault(lit, jm.group(1))
    found = {}
    field_keys = {}
    for f in SHARED_FIELDS.rglob("*.ts*"):
        text = f.read_text(encoding="utf-8", errors="ignore")
        marks = [(m.group(1), m.start()) for m in RE_EXPORT_CONST.finditer(text)]
        for i, (name, pos) in enumerate(marks):
            if name not in names:
                continue
            end = marks[i + 1][1] if i + 1 < len(marks) else len(text)
            body = text[pos:end]
            for lit in re.findall(r"comboId\s*:\s*'([^']+)'", body):
                found.setdefault(lit, name)
            for lit in re.findall(r"filters\s*:\s*\[\s*'([^']+)'", body):
                found.setdefault(lit, name)
            for lit in re.findall(r"\?\?\s*'([^']+)'", body):
                found.setdefault(lit, name)
            # 필드가 자체 훅에서 넘기는 파라미터 = 그 콤보의 **반응형 재조회 키**
            keys = set()
            for hm in HOOK_COMBO_RE.finditer(body):
                region = _balanced(body, hm.end() - 1, "(", ")")
                keys |= {
                    k for k in re.findall(r"[{,]\s*([A-Za-z_$][\w$]*)\s*:", region)
                    if k not in ("comboId", "filters", "enabled", "queryOptions")
                }
            if keys:
                field_keys[name] = sorted(keys)
    for cid, owner in prop_owner.items():
        found.setdefault(cid, owner)
    return {cid: (owner, field_keys.get(owner, [])) for cid, owner in found.items()}


def cascade_bindings(page_dir: pathlib.Path):
    """행 컨텍스트 dataMap 스왑이 **실제로 배선된** 컬럼 binding 집합 (hook #59 §5-G).

    AS-IS 는 `InsertRow`/`ComboSelChange` 에서 셀 콤보를 **행 값으로 재바인딩**한다. TO-BE 의 등가물은
    `GRID_CASCADE_FILTERS` + `beginningEdit` 에서의 dataMap 스왑이다 — 편집 진입 시점이라
    **신규행도 포함**한다(오히려 AS-IS 보다 적용 범위가 넓다).
    ⚠️ 선언(상수)만으로는 인정하지 않는다. `beginningEdit` 핸들러에서 행 필터를 적용하는 코드가
      같이 있어야 한다 — 반쪽 구현(상수만 두고 미배선)을 통과시키지 않기 위함.
    """
    declared, wired = set(), False
    for f in list(page_dir.rglob("*.ts")) + list(page_dir.rglob("*.tsx")):
        text = f.read_text(encoding="utf-8", errors="ignore")
        m = re.search(r"GRID_CASCADE_FILTERS[^=]*=\s*\{", text)
        if m:
            blk = _balanced(text, m.end() - 1, "{", "}")
            declared |= set(re.findall(r"^\s{2}([A-Z][A-Z0-9_]*)\s*:", blk, re.M))
        if re.search(r"beginningEdit", text) and re.search(r"filterComboRowsByRow|GRID_CASCADE_FILTERS\[", text):
            wired = True
    return declared if wired else set()


def row_swap_combo_ids(page_dir: pathlib.Path, id_maps, col_combo=None):
    """`beginningEdit` 핸들러 본문에서 **행 컨텍스트로 골라 스왑**되는 콤보 ID 집합.

    ⭐ 2026-08-10 — `cascade_bindings` 는 `GRID_CASCADE_FILTERS`(컬럼 binding → 메타 콤보) 경로만 본다.
      그런데 AS-IS `.cs` 런타임 `SetCellTypeCombo` 계열은 **메타에 컬럼 자체가 없어서**
      TO-BE 가 상수 맵(`ROW_COMBO_IDS.X`) + 리졸버로 붙인다(DMF0044 DEPT_ID 3분기).
      binding→메타 매핑이 존재하지 않으므로 그 경로로는 영원히 인정될 수 없다 → 별도 인식이 필요하다.
      (인정 조건은 동일하게 엄격: `beginningEdit` 핸들러 **본문 안**에서의 참조만 센다.)
    """
    hits = set()
    for f in list(page_dir.rglob("*.ts")) + list(page_dir.rglob("*.tsx")):
        text = strip_comments(f.read_text(encoding="utf-8", errors="ignore"))
        for hm in re.finditer(r"beginningEdit\w*\s*=\s*\(", text):
            # ⚠ 파라미터에 인라인 객체 타입(`e: { cancel: boolean }`)이 오면 첫 `{` 가 본문이 아니다.
            #   괄호를 먼저 균형 소비해 파라미터 구간을 건너뛴 뒤 본문 `{` 를 찾는다.
            params = _balanced(text, hm.end() - 1, "(", ")")
            body_at = text.find("{", hm.end() - 1 + len(params))
            if body_at < 0:
                continue
            body = _balanced(text, body_at, "{", "}")
            for name, kv in id_maps.items():
                for key in re.findall(r"\b%s\s*\.\s*([A-Za-z_$][\w$]*)" % re.escape(name), body):
                    if key in kv:
                        hits.add(kv[key])
            # ⭐ 2026-08-10 — 스왑의 **기본 분기**는 메타 콤보 결과를 그대로 쓰는 경우가 많다
            #   (`comboRowsRef.current.DEPT_ID` — 화면 진입 시 메타로 받아둔 행). 상수 맵만 보면
            #   그 분기를 못 봐서 "스왑 없음" 으로 오판한다. 컬럼 binding → 메타 콤보 매핑으로 해소.
            for binding in re.findall(
                r"comboRowsRef\s*\.\s*current\s*(?:\.\s*([A-Z][A-Z0-9_]*)|\[\s*'([^']+)'\s*\])", body
            ):
                b = binding[0] or binding[1]
                cid = (col_combo or {}).get(b)
                if cid:
                    hits.add(cid)
    return hits


_CONST_MAP_RE = re.compile(
    r"\bconst\s+([A-Z][A-Z0-9_]*)\s*=\s*\{", re.M
)


def const_id_maps(page_dir: pathlib.Path):
    """페이지 전역의 `const NAME = { KEY: 'COMBO_ID', … } as const` 상수 맵을 수집.

    ⭐ 2026-08-10 — 콤보 ID 를 **상수 맵에 모아두고 훅에서 `Object.values(NAME)` 로 넘기는** 배선이
      표준(hook #59 §5-G 행별 콤보). 훅 인자 안에 리터럴이 없으니 리터럴만 보던 스캐너는
      이 방식을 통째로 '미식별 WARN' 으로 떨궜다(DMF0044 4건). 배선 방식이 다를 뿐 실호출은 동일하다.

    반환: ({NAME: [combo_id,…]}, {식별자: {참조하는 NAME,…}})  ← 별칭 1단계 해소용
    """
    maps, alias = {}, {}
    for f in sorted(list(page_dir.rglob("*.ts")) + list(page_dir.rglob("*.tsx"))):
        text = strip_comments(f.read_text(encoding="utf-8", errors="ignore"))
        for m in _CONST_MAP_RE.finditer(text):
            body = _balanced(text, m.end() - 1, "{", "}")
            pairs = re.findall(r"([A-Za-z_$][\w$]*)\s*:\s*'([^']+)'", body)
            # 값이 전부 문자열이고 콤보 ID 모양(대문자/숫자/_)일 때만 콤보 맵으로 본다
            if not pairs or len(pairs) != body.count(":"):
                continue
            kv = {k: v for k, v in pairs if re.fullmatch(r"[A-Za-z_][\w]*", v)}
            if len(kv) == len(pairs):
                maps[m.group(1)] = kv
        # 별칭 — `const rowComboIds = useMemo(() => Object.values(ROW_COMBO_IDS), [])`
        for m in re.finditer(r"\bconst\s+([A-Za-z_$][\w$]*)\s*=\s*([^;]{0,300});", text):
            refs = {n for n in re.findall(r"\b([A-Z][A-Z0-9_]{2,})\b", m.group(2))}
            if refs:
                alias.setdefault(m.group(1), set()).update(refs)
    return maps, alias


def scan_tobe(page_dir: pathlib.Path, id_maps=None, aliases=None):
    """{comboId: {'sites': [(파일, 함수, 라인)], 'prefetch': n, 'triggers': [binding]}}"""
    out = {}
    id_maps = id_maps if id_maps is not None else {}
    aliases = aliases if aliases is not None else {}
    for f in sorted(list(page_dir.rglob("*.ts")) + list(page_dir.rglob("*.tsx"))):
        text = f.read_text(encoding="utf-8", errors="ignore")
        rel = f.relative_to(page_dir).as_posix()
        fns = [((m.group(1) or m.group(2)), m.start()) for m in FN_RE.finditer(text)]
        enclosing = lambda p: next(  # noqa: E731
            (n for n, s in reversed(fns) if s < p), "(모듈)"
        )
        # JSX prop 형식: <SalesSiteField comboId={cond ? 'A' : 'B'} /> — 카탈로그 필드 바인딩(프리페치성)
        for jm in re.finditer(r"comboId\s*=\s*\{([^}]{0,300})\}", text):
            for lit in re.findall(r"'([A-Za-z_][\w]*)'", jm.group(1)):
                out.setdefault(lit, {"sites": [], "prefetch": 0, "triggers": set()})["prefetch"] += 1
        # ⚠ 2026-08-09 — JSX 문자열 prop `comboId='X'` (중괄호 없음) 도 동일한 배선이다.
        #   구 패턴은 `comboId={…}` 만 봐서 `<SalesSiteField comboId='UserSiteByEndCustomer'/>` 를
        #   통째로 놓쳤다(DMF0042 SiteByEndCustomer40 이 '배선 없음' FAIL 로 오탐).
        for jm in re.finditer(r"comboId\s*=\s*'([A-Za-z_][\w]*)'", text):
            out.setdefault(jm.group(1), {"sites": [], "prefetch": 0, "triggers": set()})["prefetch"] += 1
        # ⭐ 반응형 훅 배선 — useTabComboQueries({filters:[…]}) 인자 구간 안의 comboId 는
        #   '설정'이 아니라 **실호출**이다. 파라미터를 동반하면 그 파라미터가 곧 재조회 트리거다.
        hook_spans = []
        for hm in HOOK_COMBO_RE.finditer(text):
            region = _balanced(text, hm.end() - 1, "(", ")")
            base = hm.end() - 1
            for om in re.finditer(r"comboId\s*:\s*'([^']+)'", region):
                cid = om.group(1)
                e = out.setdefault(cid, {"sites": [], "prefetch": 0, "triggers": set()})
                obj_at = region.rfind("{", 0, om.start())
                obj = _balanced(region, obj_at, "{", "}") if obj_at >= 0 else ""
                keys = sorted(
                    {k for k in re.findall(r"[{,]\s*([A-Za-z_$][\w$]*)\s*:", obj)}
                    - {"comboId", "enabled", "queryOptions"}
                )
                e["sites"].append((rel, "(반응형 훅)", text.count("\n", 0, base + om.start()) + 1))
                if keys:
                    e["triggers"].add("(반응형 재조회: %s)" % ", ".join(keys))
                hook_spans.append((base + om.start(), base + om.end()))
            # comboId 가 **메타에서 오는 동적 값**(`comboId: c.cellCboDataTp`)인 호출 —
            #   화면이 메타 셀 콤보 전량을 이 한 구독으로 파라미터와 함께 가져온다는 사실을 기록한다.
            #   리터럴이 아니라 개별 귀속은 불가하므로 analyze() 가 meta 매칭 행에 일괄 적용한다.
            for om in re.finditer(r"comboId\s*:\s*(?!')[A-Za-z_$]", region):
                obj_at = region.rfind("{", 0, om.start())
                obj = _balanced(region, obj_at, "{", "}") if obj_at >= 0 else ""
                keys = sorted(
                    {k for k in re.findall(r"[{,]\s*([A-Za-z_$][\w$]*)\s*:", obj)}
                    - {"comboId", "enabled", "queryOptions"}
                )
                if keys:
                    out.setdefault(META_DYNAMIC, {"sites": [], "prefetch": 0, "triggers": set()})[
                        "triggers"
                    ].add("(메타 반응형 재조회: %s)" % ", ".join(keys))
            # ⭐ 상수 맵 경유 배선 — 훅 인자가 `Object.values(ROW_COMBO_IDS)` 처럼 식별자로 들어온 경우.
            #   구간에 등장하는 식별자를 별칭 1단계까지 풀어 상수 맵을 찾고, 그 값들을 실배선으로 인정한다.
            region_ids = set(re.findall(r"\b([A-Za-z_$][\w$]*)\b", region))
            hit_maps = {n for n in region_ids if n in id_maps}
            for ident in region_ids & set(aliases):
                hit_maps |= aliases[ident] & set(id_maps)
            for name in sorted(hit_maps):
                trig = "(상수 맵 %s 경유 일괄 구독)" % name
                for cid in id_maps[name].values():
                    e = out.setdefault(cid, {"sites": [], "prefetch": 0, "triggers": set()})
                    e["sites"].append((rel, "(반응형 훅)",
                                       text.count("\n", 0, base) + 1))
                    e["triggers"].add(trig)
            # 리터럴 문자열 필터(`filters: ['DmBizType', …]`) = 파라미터 없는 프리페치
            for sm in re.finditer(r"'([A-Za-z_][\w]*)'", region):
                if any(s <= base + sm.start() < t for s, t in hook_spans):
                    continue
                lit = sm.group(1)
                if lit in out or re.match(r"^[A-Z][A-Za-z0-9_]*$", lit):
                    out.setdefault(lit, {"sites": [], "prefetch": 0, "triggers": set()})["prefetch"] += 1
                    hook_spans.append((base + sm.start(), base + sm.end()))
        for m in re.finditer(r"comboId\s*:\s*'([^']+)'", text):
            if any(s <= m.start() < t for s, t in hook_spans):
                continue  # 반응형 훅 구간에서 이미 집계
            cid = m.group(1)
            head = text[: m.start()]
            # 직전 400자에 getCombo( 가 있으면 명시 호출, 아니면 프리페치/설정
            # 탐지 창 — 좁으면 그 자체가 조용한 누락이다. getCombo 호출과 comboId 사이 거리는
            # 옵션 체이닝·주석으로 길어질 수 있어 넉넉히 잡는다(2026-08-08 상한 감사).
            is_call = "getCombo" in head[-2000:]
            e = out.setdefault(cid, {"sites": [], "prefetch": 0, "triggers": set()})
            if is_call:
                fn = enclosing(m.start())
                e["sites"].append((rel, fn, text.count("\n", 0, m.start()) + 1))
                # 트리거 = 그 함수를 부르는 곳 주변의 binding === 'X'
                for cm in re.finditer(r"\b%s\s*\(" % re.escape(fn), text):
                    ctx = text[max(0, cm.start() - 500) : cm.start()]
                    for bm in re.finditer(r"binding\s*===\s*'([A-Z_0-9]+)'", ctx):
                        e["triggers"].add(bm.group(1))
                    if re.search(r"CRUD_TYPE'?\]?\s*===?\s*'I'", ctx) or "primed" in ctx:
                        e["triggers"].add("(신규행 프라이밍)")
            else:
                e["prefetch"] += 1
    for e in out.values():
        e["triggers"] = sorted(e["triggers"])
    return out


def norm(s: str) -> str:
    return re.sub(r"[^a-z0-9]", "", s.lower())


def _lines(p: pathlib.Path) -> int:
    try:
        return sum(1 for _ in p.open(encoding="utf-8", errors="ignore"))
    except Exception:
        return 0


def _asis_candidates(menu: str, root: pathlib.Path):
    """정본 후보 = 최신 소스의 메인 화면 `.cs` 만. 아래는 전부 **제외 근거 보유**."""
    out = []
    for p in root.rglob("%s*.cs" % menu):
        if p.name.endswith(".Designer.cs"):
            continue
        if "POPUP" in p.parts:               # 팝업은 메인 화면이 아님
            continue
        if "_old" in p.stem or "복사본" in p.stem:
            continue
        if SEPARATE_SCREEN_RE.match(p.stem):  # `_1_`/`_T_` = 별개 화면 (사용자 확정)
            continue
        out.append(p)
    return sorted(out)


def resolve_cs(menu: str):
    """AS-IS 정본 `.cs` 해석. 반환 = (path|None, 사유, 후보수, 후보목록).

    우선순위:
      1) `ASIS_CANON` 레지스트리 (명시 등록)
      2) `*Forms.UIL` **폴더 단위** 프로젝트(`.../{stem}/{stem}.cs`) 가 유일한 경우
         — memory asis-source-folders: "정본 = GSCM.DM.Forms.UIL/Plan/{화면}/ 프로젝트 폴더.
           GSCM.DM.Plan.UIL 평면본은 구버전 사본으로 잔존(정본 아님)"
      3) 후보가 애초에 1개
      4) 그 외 = **모호 → None (FAIL)**. 임의 선택하지 않는다.
    """
    root, src_note = (GSCM_UIL, "") if GSCM_UIL.exists() else (LEGACY, " ⚠ 최신 소스 `GSCM/` 부재 — legacy 부분사본 사용")

    reg = ASIS_CANON.get(menu)
    if reg:
        p = ROOT / reg
        if p.exists():
            return p, "레지스트리 등록" + src_note, 1, [p]
        return None, "레지스트리 경로 부재: %s" % reg, 0, []

    cands = _asis_candidates(menu, root)
    if not cands:
        return None, "후보 없음" + src_note, 0, []

    forms = [p for p in cands if any("Forms.UIL" in s for s in p.parts) and p.parent.name == p.stem]
    if len(forms) == 1:
        return forms[0], "Forms.UIL 폴더단위 유일" + src_note, len(cands), cands
    if len(cands) == 1:
        return cands[0], "후보 유일" + src_note, 1, cands

    return None, "⛔ 정본 모호 — 후보 %d개, ASIS_CANON 등록 필요" % len(cands), len(cands), cands


def fe_pages():
    out = {}
    for f in FE_ROOT.rglob("*.constants.ts"):
        m = re.search(r"export\s+const\s+MENU_ID\s*=\s*'([^']+)'", f.read_text(encoding="utf-8", errors="ignore"))
        if m:
            out.setdefault(m.group(1), f.parent)
    return dict(sorted(out.items()))


def analyze(menu, page_dir, meta_combos, combo_tokens, col_combo=None):
    cs, canon_why, ncand, cands = resolve_cs(menu)  # ⚠ 루프 내 `why` 와 섀도잉 금지
    if not cs:
        # ⛔ 모호·부재를 조용히 넘기지 않는다 — 후보 목록까지 리포트에 남겨 등록을 유도한다.
        detail = "AS-IS 정본 미확정 — %s" % canon_why
        if cands:
            detail += "\n" + "\n".join("    · %s (%d행)" % (p.relative_to(ROOT).as_posix(), _lines(p)) for p in cands)
        return None, detail, False
    asis = scan_asis(cs)
    id_maps, aliases = const_id_maps(page_dir)
    tobe = scan_tobe(page_dir, id_maps, aliases)
    # 공용 조회조건 필드가 소유한 콤보도 **이 화면의 배선**이다 (import 한 필드로 한정).
    shared = _shared_field_combos(page_dir)
    for cid, (owner, keys) in shared.items():
        e = tobe.setdefault(cid, {"sites": [], "prefetch": 0, "triggers": []})
        e["prefetch"] += 1
        marks = {"(공용 %s)" % owner}
        if keys:
            marks.add("(반응형 재조회: %s · 공용 %s)" % (", ".join(keys), owner))
        e["triggers"] = sorted(set(e["triggers"]) | marks)
    # 행 컨텍스트 스왑(beginningEdit)이 걸린 컬럼의 콤보 = 행 종속 요구 충족 (hook #59 §5-G)
    for binding in cascade_bindings(page_dir):
        cid = (col_combo or {}).get(binding)
        if not cid:
            continue
        e = tobe.setdefault(cid, {"sites": [], "prefetch": 0, "triggers": []})
        e["triggers"] = sorted(set(e["triggers"]) | {"(행 컨텍스트 스왑: %s)" % binding})
    # 메타에 컬럼이 없는 `.cs` 런타임 콤보 — 상수 맵 + beginningEdit 리졸버 경로 (위 함수 주석 참조)
    for cid in row_swap_combo_ids(page_dir, id_maps, col_combo or {}):
        e = tobe.setdefault(cid, {"sites": [], "prefetch": 0, "triggers": []})
        e["triggers"] = sorted(set(e["triggers"]) | {"(행 컨텍스트 스왑: 상수 맵 리졸버)"})
    tobe_norm = {norm(k): k for k in tobe}
    meta_norm = {norm(k): k for k in meta_combos}

    shares_paste = tobe_shares_paste(page_dir)
    rows = []
    for code, e in sorted(asis.items()):
        # ⚠️ AS-IS 는 같은 이벤트 핸들러 안에서 여러 번 부르기도 한다(ComboSelChange 2회 등).
        #   트리거 등가 비교의 단위는 **호출 횟수가 아니라 구별된 이벤트 핸들러 수**다.
        methods = {m for m, _ in e["sites"]}
        if shares_paste:
            methods = {m for m in methods if not PASTE_METHOD_RE.search(m)}
        n_a = len(methods)
        n_sites = len(e["sites"])
        if n_a == 0 and not e["helpers"]:
            continue
        # 화면별 별칭이 전역보다 우선 (개명은 화면마다 다르다 — MENU_CODE_ALIAS 주석 참조)
        alias = MENU_CODE_ALIAS.get(menu, {}).get(code) or CODE_ALIAS.get(code, code)
        key = tobe_norm.get(norm(code)) or tobe_norm.get(norm(alias))
        meta_key = meta_norm.get(norm(code)) or meta_norm.get(norm(alias))
        note = DISPOSITION.get(menu, {}).get(code)
        t = tobe.get(key, {"sites": [], "prefetch": 0, "triggers": []})
        # 메타 셀 콤보는 화면이 **동적 comboId 구독 1개**로 전량을 파라미터와 함께 가져온다.
        if meta_key and META_DYNAMIC in tobe:
            t = dict(t)
            t["triggers"] = sorted(set(t["triggers"]) | set(tobe[META_DYNAMIC]["triggers"]))
        # ⚠️ AS-IS 는 같은 헬퍼를 이벤트마다 재호출하므로 '호출부 수'가 곧 트리거 수지만,
        #   TO-BE 는 헬퍼 1개를 여러 트리거가 부른다 → **트리거 수**로 비교해야 등가다
        #   (정의 수로 비교하면 정상 구현도 항상 '부족'으로 보인다 — 2026-08-08 실측 오탐).
        n_t = len(t["triggers"]) or len(t["sites"])
        insert_asis = any(INSERT_METHOD_RE.search(mth) for mth in methods)
        # ⭐ 2026-08-09 — 행 컨텍스트 요구를 만족시키는 TO-BE 기법은 2가지다:
        #   ① 신규행 프라이밍(명시 재조회)  ② beginningEdit dataMap 스왑(hook #59 §5-G)
        #   ②는 **편집 진입 시점**이라 신규행을 포함하며 기존행에도 적용된다 — ①의 상위 집합.
        #   ①만 인정하면 ②로 구현한 화면이 영구 FAIL 로 남는다(DMF0042 SCM_SITE_ID40 실측 오탐).
        swap_tobe = any(str(x).startswith("(행 컨텍스트 스왑") for x in t["triggers"])
        insert_tobe = "(신규행 프라이밍)" in t["triggers"] or swap_tobe
        # 반응형 훅 구독 = 파라미터 변화마다 자동 재조회. AS-IS 의 N개 재호출 지점을 **1개 구독**이
        #   대체하므로 개수 비교(n_a > n_t) 대상이 아니다.
        reactive = [str(x) for x in t["triggers"] if "반응형 재조회" in str(x)]
        # ⭐ 행 종속 토큰(@divisionId/@itemId/@scmSiteId/@endCustomer …)을 가진 콤보는
        #   메타 자동 바인딩(렌더 1회)이 **행 생성 시점 재조회를 대체하지 못한다**.
        #   반대로 파라미터 없는 콤보는 메타 바인딩으로 충분하다(AS-IS 가 InsertRow 에서 부르는 것은
        #   셀 콤보를 붙이기 위함일 뿐) — 이 구분이 없으면 오탐이 쏟아진다.
        row_tokens = combo_tokens.get(key or meta_key or "", set())
        # ⭐ 2026-08-10 — 토큰이 **행 스코프가 아니라 화면 스코프**인 경우가 있다.
        #   `DM_LOOKUP_DIV(@param1=division, @param2=컬럼 ATTRIBUTE1)` 이 대표 —
        #   두 값 모두 선택된 division 과 컬럼 메타에서 나오므로 **행마다 달라지지 않는다**.
        #   이때 반응형 구독(파라미터 변화 시 자동 재조회)은 신규행 프라이밍과 등가다
        #   (새 행도 같은 목록을 쓴다). 이 구분이 없으면 정상 구현이 영구 FAIL 로 남는다.
        SCREEN_SCOPE_TOKENS = {"param1", "param2", "param3", "divisionId", "mnuId"}
        reactive_keys = set()
        for x in reactive:
            reactive_keys |= {k.strip() for k in
                              str(x).split(":", 1)[-1].rstrip(")").split(",") if k.strip()}
        if reactive and row_tokens and row_tokens <= (SCREEN_SCOPE_TOKENS & reactive_keys):
            insert_tobe = True

        if n_a == 0 and n_sites == 0:
            continue
        if note:
            v, why = "✅ PASS", "이식 안 함(사유 기재): " + note
        elif n_a >= 2 and n_t == 0 and t["prefetch"] == 0 and not meta_key:
            v, why = "⛔ FAIL", "AS-IS %d지점인데 TO-BE 배선 자체가 없음" % n_a
        elif insert_asis and not insert_tobe and row_tokens:
            v, why = "⛔ FAIL", (
                "AS-IS 에 **행 생성 지점**(%s)이 있고 콤보가 행 종속 토큰(%s)을 갖는데 "
                "TO-BE 신규행 프라이밍 없음 — 메타 자동 바인딩은 렌더 1회라 대체 불가"
                % (", ".join(sorted({m for m in methods if INSERT_METHOD_RE.search(m)})),
                   ", ".join(sorted(row_tokens)))
            )
        elif n_a > max(n_t, 1) and (n_t > 0 or t["prefetch"] > 0):
            # ⭐ 2026-08-09 — TO-BE 콤보 SQL 에 **문맥 토큰이 하나도 없으면** 몇 번을 다시 불러도
            #   결과가 같다. AS-IS 가 division 변경마다 재호출하더라도(예: `Data.Common(DM_BIZ_TYPE,
            #   false, "", "", "", "")` — 인자 전부 빈 문자열) 프리페치 1회와 **등가**다.
            #   이 구분이 없으면 무파라미터 콤보가 영구 WARN 으로 남아 게이트가 무시된다.
            if not row_tokens:
                v, why = "✅ PASS", (
                    "AS-IS %d지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 "
                    "프리페치 %d회로 등가" % (n_a, t["prefetch"])
                )
            elif reactive:
                v, why = "✅ PASS", (
                    "AS-IS %d지점 ↔ TO-BE **반응형 구독 1개**로 대체 — queryKey 파라미터 변화 시 자동 "
                    "재조회 %s" % (n_a, "; ".join(reactive))
                )
            else:
                v, why = "⚠ WARN", "AS-IS 이벤트 %d종 > TO-BE 트리거 %d — 부족 의심" % (n_a, n_t)
        elif n_t == 0 and t["prefetch"] == 0 and not meta_key:
            v, why = "⚠ WARN", "TO-BE 대응 콤보 미식별 (명명 상이 or 미이관)"
        else:
            v, why = "✅ PASS", ""
        rows.append(
            {
                "code": code, "tobe": key or meta_key or "-", "n_a": n_a, "n_t": n_t, "n_sites": n_sites,
                "prefetch": t["prefetch"], "meta": bool(meta_key), "verdict": v, "why": why,
                "methods": sorted({m for m, _ in e["sites"]}), "triggers": t["triggers"],
                "commented": e["commented"], "kinds": e["kinds"],
            }
        )
    src = "%s (%d행) — 선택 근거: %s / 후보 %d개" % (
        cs.relative_to(ROOT).as_posix(), _lines(cs), canon_why, ncand)
    return rows, src, shares_paste


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--menu")
    ap.add_argument("--page")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--out")
    a = ap.parse_args()

    import oracledb

    u, p, d = conn_info()
    targets = {}
    if a.all:
        targets = fe_pages()
    elif a.menu:
        targets = {a.menu: pathlib.Path(a.page) if a.page else fe_pages().get(a.menu)}
    if not targets or any(v is None for v in targets.values()):
        sys.exit("[error] --menu <ID> [--page <폴더>] 또는 --all 필요")

    meta, combo_tokens, col_combo = {}, {}, {}
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        for menu in targets:
            cur.execute(
                """SELECT DISTINCT COLUMN_NAME, CELL_COMBO_DATA_TYPE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID = :m AND TRIM(CELL_COMBO_DATA_TYPE) IS NOT NULL
                      AND NVL(VALID_YN,'Y') = 'Y'""",
                {"m": menu},
            )
            pairs = cur.fetchall()
            meta[menu] = {c for _, c in pairs}
            col_combo[menu] = {col: c for col, c in pairs}
        # 콤보별 행 종속 토큰 (서버 자동 주입 제외) — 메타 바인딩 대체 가능 여부 판정용
        cur.execute("SELECT SQL_ID, SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M")
        for sid, ctn in cur.fetchall():
            s = ctn.read() if hasattr(ctn, "read") else str(ctn)
            toks = set(re.findall(r"@(\w+)", s)) - {"sesUserId", "sesLangCd", "mnuId", "langCd", "userId"}
            combo_tokens[sid] = toks

    ts = datetime.datetime.now()
    L = [
        "# AS-IS ↔ TO-BE 콤보 **호출 지점 수(N:N)** 대사",
        "",
        f"> 실행 {ts:%Y-%m-%d %H:%M} · `_artifacts/_diagnostics/combo_callsite_parity.py` · **읽기 전용**",
        "> 룰 = hook #117 §5.12. SQL·파라미터가 맞아도 **부르는 시점이 빠지면 조용히 죽는다.**",
        "> 섹션 7·E2E D2축이 못 보는 축 — 이 대사표가 유일한 방어선이다.",
        "",
        "판정: **FAIL** = 배선 자체 부재(AS-IS ≥2 지점) 또는 **행 생성(InsertRow) 지점 누락** /",
        "**WARN** = AS-IS 지점 수 > TO-BE(트리거 부족 의심) 또는 대응 콤보 미식별 / **PASS** = 그 외",
        "",
    ]
    tot = {"⛔ FAIL": 0, "⚠ WARN": 0, "✅ PASS": 0}
    detail = []
    for menu, page_dir in targets.items():
        rows, src, shares_paste = analyze(
            menu, page_dir, meta.get(menu, set()), combo_tokens, col_combo.get(menu, {})
        )
        if rows is None:
            detail += ["## %s — SKIP" % menu, "", src, ""]
            continue
        for r in rows:
            tot[r["verdict"]] += 1
        bad = [r for r in rows if r["verdict"] != "✅ PASS"]
        detail += [
            "## %s (%s)" % (menu, "FAIL %d / WARN %d / PASS %d" % (
                sum(1 for r in rows if "FAIL" in r["verdict"]),
                sum(1 for r in rows if "WARN" in r["verdict"]),
                sum(1 for r in rows if "PASS" in r["verdict"]))),
            "",
            "> AS-IS 원천: `%s`" % src,
            "",
            "> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). "
            + ("TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다."
               if shares_paste else "TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함."),
            "",
            "| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |",
            "|---|---|---:|---:|---:|---:|:-:|---|---|",
        ]
        for r in rows:
            detail.append("| %s | %s | %d | %d | %d | %d | %s | %s | %s |" % (
                r["code"], r["tobe"], r["n_a"], r["n_sites"], r["n_t"], r["prefetch"],
                "O" if r["meta"] else "-", r["verdict"], r["why"]))
        if bad:
            detail += ["", "### 상세 (FAIL/WARN)", ""]
            for r in bad:
                detail.append("- **%s** → `%s` · AS-IS 호출 메서드: %s%s" % (
                    r["code"], r["tobe"], ", ".join(r["methods"]) or "-",
                    " · 주석처리 %d건(사문=미이관 파리티)" % r["commented"] if r["commented"] else ""))
                detail.append("  - TO-BE 트리거: %s" % (", ".join(r["triggers"]) or "없음"))
        detail.append("")
    L += ["## 종합 — FAIL **%d** / WARN **%d** / PASS **%d** (화면 %d개)" % (
        tot["⛔ FAIL"], tot["⚠ WARN"], tot["✅ PASS"], len(targets)), ""] + detail
    L += [
        "## 한계 (은폐 없음)",
        "- AS-IS 명명 헬퍼는 **1단계**만 해소한다(헬퍼 안의 헬퍼는 미추적).",
        "- TO-BE 트리거 추출은 `binding === 'X'` 정적 매칭 — 동적 분기(맵/스위치)는 누락될 수 있다.",
        "- 이름이 다른 대응 콤보는 정규화(영숫자 소문자) 매칭이 실패하면 '미식별 WARN' 으로 노출한다(조용한 통과 없음).",
        "- 주석 처리된 AS-IS 호출은 **제외하되 건수를 표에 기록**한다 — 사문 = 미이관이 파리티.",
        "",
    ]
    out = pathlib.Path(a.out) if a.out else (
        REPORT_DIR / ("COMBO_CALLSITE_PARITY_%s_%s.md" % (
            ("ALL" if a.all else a.menu), ts.strftime("%Y%m%d_%H%M"))))
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(L) + "\n", encoding="utf-8")
    print("FAIL %d / WARN %d / PASS %d" % (tot["⛔ FAIL"], tot["⚠ WARN"], tot["✅ PASS"]))
    print("리포트:", out)
    sys.exit(1 if tot["⛔ FAIL"] else 0)


if __name__ == "__main__":
    main()
