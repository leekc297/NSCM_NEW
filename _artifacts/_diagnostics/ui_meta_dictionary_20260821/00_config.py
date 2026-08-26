#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""00_config.py — UI 메타 지식사전 파이프라인 단일 설정.

경로·대상·정규화 규칙을 여기에만 둔다 (하드코딩 분산 금지 — 플랜 Phase 0).

접속정보 외부화 (플랜 Phase 5 대비):
  AS-IS  : 환경변수 NSCM_ASIS_HOST/PORT/DB/USER/PASS 우선 → 없으면 프로젝트 루트 .env.asis 의 ASIS_DB_*
           (.env.asis 는 수정하지 않는다. QA 전환은 환경변수만으로 가능하다.)
  TO-BE  : ora.conn_info() (NSCM_ORA_USER/PASS/DSN → .env.asis TOBE_DB_*)
"""
import os
import sys

NL = chr(10)          # 산출물 개행 고정 (재현성 G7 — CRLF 혼입 방지)
HERE = os.path.dirname(os.path.abspath(__file__))
DIAG = os.path.dirname(HERE)                      # _artifacts/_diagnostics
ROOT = os.path.dirname(os.path.dirname(DIAG))     # C:\Projects\NSCM
sys.path.insert(0, DIAG)

# ── 산출물 경로 ───────────────────────────────────────────────────────────────
OUT_JSON = HERE                                                   # JSON 정본
DICT_DIR = os.path.join(ROOT, "Doc", "_rules_v2", "_dictionary")   # MD 정본
XLSX_DIR = os.path.join(ROOT, "Doc", "화면분석서")                  # xlsx 뷰
XLSX_NAME = "UI메타_지식사전_v1.0.xlsx"
FIXSQL_DIR = os.path.join(ROOT, "_artifacts", "_deploy_packages", "UIMETA_DRIFT_FIX_20260821")

# 조회조건 1차 근거 (기존 MATRIX 파이프라인 — 재작성 금지, 읽기 전용 참조)
SEARCHCOND_PIPELINE = os.path.join(DIAG, "searchcond_matrix_20260819")
SEARCHCOND_EXTRACT = os.path.join(SEARCHCOND_PIPELINE, "extract")
SEARCHCOND_CATALOG = os.path.join(ROOT, "Doc", "_rules_v2", "_mapping", "search_conditions_scp_dm.md")

# ── 스냅샷 표기 (사전 머리말에 박는다 — 플랜 §한계 1) ─────────────────────────
SNAPSHOT_DATE = "2026-08-21"
ASIS_SOURCE_LABEL = os.environ.get("NSCM_ASIS_LABEL", "DEV / LGCE_SCMDEV")

# ── 건수 검증 (게이트 G1) ─────────────────────────────────────────────────────
#
# ⚠️ 2026-08-21 실측: AS-IS DEV(LGCE_SCMDEV) 는 **작업 중 실시간 변동**한다.
#    같은 날 50분 간격으로 SHEET_COLUMNS 15,105 → 14,675 / SHEET_MEASURE 1,703 → 1,505 로 바뀌었고,
#    그 사이 committed COUNT(*) 가 0 을 반환하는 재적재 창(window)까지 관측됐다
#    (RCSI=OFF 인데 clean=0 / NOLOCK=14,675 로 갈렸다).
#    ⇒ 고정 기대치 ASSERT 는 정상 변동에도 오탐을 낸다. 대신 **스냅샷 정합성**을 검사한다:
#       ① clean COUNT == NOLOCK COUNT == sys.partitions rows   (재적재 창 아님)
#       ② 간격을 두고 두 번 샘플링한 값이 동일               (변동 중 아님)
#       ③ 직전 baseline 대비 증감은 **차단이 아니라 보고**    (사람이 판단)
#    baseline 은 baseline_counts.json 에 기록되고 실행할 때마다 갱신 이력이 남는다.
BASELINE_FILE = "baseline_counts.json"
STABILITY_SAMPLES = 2          # 샘플 횟수
STABILITY_GAP_SEC = float(os.environ.get("NSCM_DICT_STABLE_GAP", "8"))
STABILITY_RETRIES = int(os.environ.get("NSCM_DICT_STABLE_RETRY", "6"))

# 최초 관측 baseline (참고용 — 실행 시 baseline_counts.json 이 우선한다)
BASELINE_SEED = {
    "asis_columns": 14675,
    "asis_measures": 1505,
    "tobe_columns": 15704,
    "tobe_measures": 1711,
    "cmbo": 167,
}

# ── MEASURE 대사 대상 (플랜 Phase 3 — DM 도메인 우선) ────────────────────────
MEASURE_PROGRAMS = [
    "DM0003", "DM0007", "DM0013", "DM0022", "DM0035",
    "DMF0003", "DMF0020", "DMF0021", "DMF0022", "DMF0035", "DMF0041", "DMF0042",
    "DMF0044", "DMF0045", "DMF0048", "DMF0049", "DMF0051", "DMF0051_1", "DMF0053",
    "DMF0066", "DMF0081", "DMF0082", "DMF1006", "DMF1007", "DMNF0006",
]

# ── ⭐ division별 AS-IS 기준 원천 (사용자 지정 2026-08-21, 같은 날 정정) ──────────
#
# 문제: TO-BE 가 AS-IS 보다 **넓은 division 을 개방**한 화면이 있다. 그 화면의 AS-IS 원본에는
#       개방된 division 의 동작 근거가 아예 없어서, "AS-IS 대조" 를 해도 답이 나오지 않는다.
#
# ⇒ 규칙: division 마다 **어느 AS-IS 화면의 UI CATEGORY SETUP 데이터를 기준으로 삼을지** 명시한다.
#         기준 화면이 다르면 "AS-IS 에 없다" 가 곧 "결함" 이 아니다 — 기준 화면에서 뽑아 대조한다.
#
# ⚠️ **기준은 언제나 AS-IS 데이터다.** TO-BE 화면끼리 베끼면 오류가 전파된다 —
#    실제로 TO-BE DMF0003 이 PLANT_SITE_ID 콤보를 AS-IS `FromSiteByDivision`(사이트 코드) 에서
#    `PlantByDivisionCompany`(플랜트 코드) 로 바꿨고, TO-BE DMF0082 가 그 **변경본을 복사**해
#    조회조건(사이트 코드)과 그리드 셀(플랜트 코드)의 값 도메인 교집합이 **0건**이 됐다.
#    (사용자 확인 2026-08-21: "DMF0003 도 표준이 아니다. AS-IS 사전정보 기준이면 FromSiteByDivision 이 맞다")
#
# 형식: {대상 TO-BE 화면: {"target_sheet": 시트, "by_division": {division: (AS-IS 기준화면, 기준시트)}}}
#   ⚠ **시트 단위**로 지정한다. 화면 전체로 비교하면 기준 화면의 다른 시트 컬럼이 섞여 기준이 오염된다.
DIVISION_BASELINE = {
    "DMF0082": {
        "target_sheet": "FcstNPrice",
        "by_division": {
            # 40 = AS-IS DMF0003(Mkt Fcst) 기준
            "40":    ("DMF0003", "Mkt Fcst"),
            # 81 계열·82 = AS-IS DMF0082(FcstNPrice) 자기 화면 기준
            "81":    ("DMF0082", "FcstNPrice"),
            "81_UC": ("DMF0082", "FcstNPrice"),
            "81_HM": ("DMF0082", "FcstNPrice"),
            "81_ST": ("DMF0082", "FcstNPrice"),
            "81_HD": ("DMF0082", "FcstNPrice"),
            "81_HG": ("DMF0082", "FcstNPrice"),
            "82":    ("DMF0082", "FcstNPrice"),
        },
    },
}

DIVISION_BASELINE_JOIN = "COLUMN_NAME"

# ⭐ 컬럼명 정규화 — 화면마다 division 분리 규약이 다르다.
#   AS-IS DMF0003 은 **division 40 전용 컬럼에 '40' 접미**를 붙여 81/82 판과 행을 나눈다
#   (실측: DIVISION_ID/DIVISION_ID40 · END_CUSTOMER/END_CUSTOMER40 · ITEM_ID/ITEM_ID40 ·
#    SCM_SITE_ID/SCM_SITE_ID40 — 라벨은 같고 DIVISION_ID 만 '40' vs '82,81,...').
#   DMF0082 는 한 컬럼으로 전 division 을 덮는다.
#   ⇒ 접미를 떼지 않으면 같은 축이 "기준에만 4 + TO-BE만 4" 로 갈라져 **허위 격차 8건**이 된다.
DIVISION_BASELINE_NAME_SUFFIXES = ("40",)


def norm_col(name):
    """대조용 컬럼명 정규화 — division 접미 제거 + UPPER."""
    n = (name or "").strip().upper()
    for suf in DIVISION_BASELINE_NAME_SUFFIXES:
        if n.endswith(suf) and len(n) > len(suf) + 1:
            return n[: -len(suf)]
    return n

# 조회조건 MATRIX 실측 13UI
SEARCHCOND_UIS = ["DMF0003", "DMF0004", "DMF0005", "DMF0006", "DMF0007", "DMF0014",
                  "DMF0020", "DMF0021", "DMF0042", "DMF0048", "DMF0072", "DMF0074", "DMF0082"]

# ── 값 도메인 (FE 실행 기준 — nscm-fe/packages/foundation/src/constants/column-config.ts) ──
CELL_CONTROL_TYPES = [
    # ⭐ 2026-08-22 신설 — 텍스트 입력 + 모달 동시 허용(AS-IS `TextCellType`+`ImagePopUp` 파리티).
    #   FPModal 이 편집차단·아이콘·팝업스타일 3가지를 묶어 지배해 표현 불가였던 조합.
    "FPTextModal",
    "FPModal", "FPComboBox", "FPButton", "FPDate", "FPDateMonth", "FPDateTime",
    "FPDateText", "FPCheckBox", "FPNumberText", "FPTextBox", "FPPercent", "FPText",
    "FPNumber", "FPMultiLineTextBox",
]
# lookup(SCM_ADM_LOOKUP_MASTER_DETAIL)에만 있고 FE enum 에 없는 값 — 사용 시 미해석
LOOKUP_ONLY_CONTROLS = ["FPExNum"]
INPUT_TP_CODES = ["S", "O", "M", "IO", "IM"]
ALIGN_CODES = ["C", "L", "R"]

# 실사고로 확인된 오값 (플랜 Phase 2 D6/D7/D8)
BAD_INPUT_TP = {"MI": "IM", "OI": "IO"}                  # 역순 기입 → 비편집 fallthrough
BAD_ALIGN = {"Center": "C", "Left": "L", "Right": "R"}   # 레거시 풀네임 → 좌측 fallback

# 셀 콤보/모달이 붙는 컨트롤 (편집표준 모집단)
EDIT_CONTROLS = ["FPComboBox", "FPModal", "FPTextModal"]

# 모달을 보유하는 컨트롤 — **CELL_COMBO_DATA_TYPE**(모달키) 필수 대상
#   (2026-08-22 규약 전환 — 종전 ATTRIBUTE1 에서 이전. AS-IS 는 모달 개념이 없어
#    ATTRIBUTE1 은 `sParam1`(파라미터) 자리로 돌아갔다.)
MODAL_CONTROLS = ["FPModal", "FPTextModal"]

# 알려진 모달키 값 — ATTRIBUTE1 에 이 값이 남아 있으면 구 규약 잔재(D13).
#   실측 원천 = 모달 컨트롤 행의 CELL_COMBO_DATA_TYPE / ATTRIBUTE1 실사용값.
# ⭐ AS-IS 와 **의도적으로 다른** TO-BE 메타값 등록부 (2026-08-22 신설)
#
#   AS-IS 대조만 보고 되돌리면 화면이 깨지는 값들이다. 근거 없이 "AS-IS 와 다름" 으로 정정하지 말 것
#   (CELL_PROD_SITE_ID 계보 — 잘못된 기대값이 검증 스크립트·이관 패키지로 전파된 사고).
#   키 = (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, FIELD) · 값 = (AS-IS, TO-BE, 사유)
INTENTIONAL_DIVERGENCE = {
    ("DMF0082", "FcstNPrice", "VERSION_NO", "VISIBLE_FLAG"): (
        "N", "Y",
        "AS-IS 는 메타가 'N' 인데 **화면에는 보인다** — DMF0082 가 쓰는 프레임워크 오버로드 "
        "`SpreadInfo.CreateSheetHeaderColumn`(SpreadInfo.cs:1324, 호출 .cs:421)이 VISIBLE_FLAG 를 "
        "전혀 읽지 않고 VALID_YN 으로만 판정하기 때문이다(다른 오버로드 5곳은 검사). "
        "TO-BE 는 플래그를 정상 적용하므로 'N' 이면 AS-IS 에 있던 컬럼이 사라진다 → 화면 파리티로 'Y'. "
        "사용자 결정 2026-08-22."),
    ("DMF0082", "FcstNPrice", "MEASURE", "VISIBLE_FLAG"): (
        "N", "Y",
        "위 VERSION_NO 와 동일 사유(같은 오버로드). AS-IS `.cs:538` Freeze 가 고정컬럼 상시 표시를 "
        "증명한다. 선행 적용분."),
}

MODAL_KEYS = [
    "ITEM", "PROJECT",
    "ProjectAuthRegModal", "MyWorkModal", "UserMgmt", "SsoUser",
    "LevelOneMenu", "LevelTwoMenu", "LevelThreeMenu",
]

# 텍스트 입력이 허용되는 컨트롤 — "모달인데 자유입력" 판정에서 제외해야 한다
TEXT_EDITABLE_CONTROLS = ["FPTextBox", "FPText", "FPTextModal"]

# division 토큰 (DIVISION_ID CSV 정규화 대상)
DIVISION_TOKENS = ["40", "81", "81_UC", "81_HM", "81_ST", "81_HD", "81_HG", "82"]

# ── 미확인 표기 (공란 금지 규약 — 게이트 G2) ─────────────────────────────────
UNKNOWN_PREFIX = "미확인"


def unknown(reason):
    """공란 대신 사유를 동반한 미확인 표기를 만든다."""
    return f"{UNKNOWN_PREFIX}({reason})"


def is_unknown(v):
    return isinstance(v, str) and v.startswith(UNKNOWN_PREFIX)


# ── 접속 ──────────────────────────────────────────────────────────────────────
def asis_env():
    """AS-IS(MSSQL) 접속정보. 환경변수 우선, 없으면 .env.asis 의 ASIS_DB_*."""
    kv = {}
    p = os.path.join(ROOT, ".env.asis")
    if os.path.exists(p):
        for ln in open(p, encoding="utf-8-sig"):
            ln = ln.strip()
            if ln and not ln.startswith("#") and "=" in ln:
                k, v = ln.split("=", 1)
                kv[k.strip()] = v.strip()
    g = os.environ.get
    return {
        "host": g("NSCM_ASIS_HOST") or kv.get("ASIS_DB_HOST"),
        "port": g("NSCM_ASIS_PORT") or kv.get("ASIS_DB_PORT", "1433"),
        "db": g("NSCM_ASIS_DB") or kv.get("ASIS_DB_NAME"),
        "user": g("NSCM_ASIS_USER") or kv.get("ASIS_DB_USER"),
        "pwd": g("NSCM_ASIS_PASS") or kv.get("ASIS_DB_PASS"),
        "driver": g("NSCM_ASIS_DRIVER") or kv.get("ASIS_DB_DRIVER", "ODBC Driver 17 for SQL Server"),
    }


def asis_connect():
    import pyodbc
    e = asis_env()
    missing = [k for k, v in e.items() if not v]
    if missing:
        raise SystemExit(f"AS-IS 접속정보 누락: {missing}")
    cs = (f"DRIVER={{{e['driver']}}};SERVER={e['host']},{e['port']};DATABASE={e['db']};"
          f"UID={e['user']};PWD={e['pwd']};TrustServerCertificate=yes;Encrypt=no")
    return pyodbc.connect(cs, timeout=20)


def tobe_connect():
    import oracledb
    import ora
    u, p, d = ora.conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def jdump(obj, name):
    """JSON 정본 저장 — 재현성(G7) 위해 키 정렬 + 고정 들여쓰기, 타임스탬프 미포함."""
    import json
    path = os.path.join(OUT_JSON, name)
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        json.dump(obj, f, ensure_ascii=False, indent=1, sort_keys=True)
    return path


def jload(name, base=None):
    import json
    path = name if os.path.isabs(name) else os.path.join(base or OUT_JSON, name)
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def load_baseline():
    import json
    p = os.path.join(OUT_JSON, BASELINE_FILE)
    if os.path.exists(p):
        with open(p, encoding="utf-8") as f:
            return json.load(f)
    return {"counts": dict(BASELINE_SEED), "history": []}


def save_baseline(bl):
    import json
    with open(os.path.join(OUT_JSON, BASELINE_FILE), "w", encoding="utf-8", newline=NL) as f:
        json.dump(bl, f, ensure_ascii=False, indent=1, sort_keys=True)


def report_drift(bl, key, actual, note=""):
    """baseline 대비 증감을 보고한다 (차단하지 않음). 이력은 baseline_counts.json 에 남긴다."""
    prev = bl["counts"].get(key)
    if prev is None:
        print(f"  [BASELINE 신규] {key}: {actual}")
    elif prev == actual:
        print(f"  [BASELINE 일치] {key}: {actual}")
    else:
        print(f"  ⚠ [BASELINE 변동] {key}: {prev} → {actual} ({actual - prev:+d}) {note}")
        bl["history"].append({"key": key, "from": prev, "to": actual,
                              "snapshot": SNAPSHOT_DATE, "note": note})
    bl["counts"][key] = actual


def stable_count(sample_fn, label):
    """재적재 창·변동 중이 아님을 확인하고 확정 건수를 돌려준다 (G1).

    sample_fn() -> (clean, dirty, part)   dirty/part 를 못 구하는 원천은 clean 을 그대로 넘긴다.
    """
    import time
    last = None
    for attempt in range(1, STABILITY_RETRIES + 1):
        clean, dirty, part = sample_fn()
        consistent = (clean == dirty) and (part is None or clean == part)
        if not consistent:
            print(f"  [{label}] 재적재 창 감지 (clean={clean} dirty={dirty} part={part})"
                  f" — {attempt}/{STABILITY_RETRIES} 재시도")
            last = None
            time.sleep(STABILITY_GAP_SEC)
            continue
        if last is not None and last == clean:
            print(f"  [{label}] 안정 확인: {clean}행 (2회 연속 동일 · clean=dirty=partition)")
            return clean
        last = clean
        time.sleep(STABILITY_GAP_SEC)
    raise SystemExit(
        f"[STABILITY FAIL] {label}: {STABILITY_RETRIES}회 시도에도 안정 상태 미확보." + NL +
        "  → AS-IS 원천이 적재 중입니다. 작업이 끝난 뒤 재실행하십시오 "
        "(부분/찢어진 스냅샷으로 사전을 만들지 않습니다)."
    )


def norm_div(v):
    """DIVISION_ID CSV → 정규화 토큰 집합 (순서 차이 오탐 방지 / '' == NULL)."""
    if v is None:
        return frozenset()
    s = str(v).strip()
    if not s:
        return frozenset()
    return frozenset(t.strip() for t in s.split(",") if t.strip())


def norm_txt(v):
    """'' 과 NULL 을 동치로 두고 양끝 공백을 제거한다 (Oracle ''=NULL)."""
    if v is None:
        return ""
    return str(v).strip()


def norm_num(v):
    if v is None or (isinstance(v, str) and not v.strip()):
        return None
    try:
        f = float(v)
        return int(f) if f == int(f) else f
    except (TypeError, ValueError):
        return str(v).strip()
