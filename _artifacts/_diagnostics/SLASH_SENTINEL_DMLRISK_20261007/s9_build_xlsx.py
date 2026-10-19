"""[xlsx 생성] '-'→'/' 일괄 변환(DML) 위험 점검 보고 — 보류 51 제외 · 추가분 115 포함
입력: _risk.json(s4) · _join_break.json(s8) · _pop_extra.json(s7) · _partner_scan.json(s5)
출력: 슬래시전환_DML위험점검_20261007.xlsx
"""
import json, pathlib, collections, datetime, re
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.utils import get_column_letter

HERE = pathlib.Path(__file__).resolve().parent
R = json.loads((HERE / "_risk.json").read_text(encoding="utf-8"))
JB = json.loads((HERE / "_join_break.json").read_text(encoding="utf-8")) if (HERE / "_join_break.json").exists() else {}
EX = json.loads((HERE / "_pop_extra.json").read_text(encoding="utf-8"))["rows"]
PS = json.loads((HERE / "_partner_scan.json").read_text(encoding="utf-8"))
ST = json.loads((HERE / "_scan_stats.json").read_text(encoding="utf-8"))
M = R["meta"]

def eff(a, jb):
    """회귀 가능 행 상한 = min(양쪽 '-' 로 성립하는 행, 변환 쪽 AS-IS 빈값 유래 행, 상대 쪽 AS-IS 빈값 유래 행) — 아는 값만"""
    if not jb or "error" in jb: return None
    return min(v for v in (jb["broken"], a["conv_rows"], a["other_blank"]) if v is not None)

def judge(a, jb):
    k = a["other_kind"]
    e = eff(a, jb)
    if e is not None:
        if e == 0: return "이상 없음 — AS-IS 빈값 유래 행끼리 맞던 조인이 끊길 여지 0 (상대의 실제 '-' 와 안 맞게 되는 것은 AS-IS 동작 복원)"
        base = f"회귀 가능 행 ≤ {e:,} — "
    else:
        base = "실측 실패/미측정 — "
    if "이관 생성" in k: return base + "상대 컬럼의 '-' 가 전부 이관 때 생긴 값 → 상대 컬럼을 변환 범위에 넣으면 해소"
    if "AS-IS 에 없음" in k: return base + "TO-BE 신규 테이블이라 AS-IS 대조 불가 → 상대 컬럼 변환 범위 추가 검토"
    if "공존" in k or "실제 '-' 보유" in k: return base + "상대 컬럼의 '-' 중 AS-IS 빈값 유래분만 문제 → 그 행만 '/' 로 함께 변환(행 단위 대조, 타 팀) 또는 상대 컬럼 범위 추가"
    if "보류51" in k: return base + "상대 컬럼이 보류 51 → 보류 51 결정에 종속"
    return base + "상대 컬럼 실태 미확인 → 실측 필요"

wb = openpyxl.Workbook()
def sheet(name, head, rows, widths, freeze="B2"):
    w = wb.create_sheet(name); w.append(head)
    for c in w[1]: c.font = Font(bold=True, color="FFFFFF"); c.fill = PatternFill("solid", fgColor="305496"); c.alignment = Alignment(wrap_text=True, vertical="center")
    for r in rows: w.append([("" if v is None else (json.dumps(v, ensure_ascii=False) if isinstance(v, (list, dict)) else v)) for v in r])
    for i, wd in enumerate(widths, 1): w.column_dimensions[get_column_letter(i)].width = wd
    w.freeze_panes = freeze
    if rows: w.auto_filter.ref = w.dimensions
    return w

# 1. 조인 한쪽만 변환 + 실측
A_rows = []
for a in R["A_join"]:
    jbs = [v for k, v in JB.items() if k.startswith(f'{a["conv_table"]}.{a["conv_col"]}={a["other_table"]}.{a["other_col"]} |')]
    if not jbs: jbs = [None]
    oa = a.get("other_asis") or {}
    for jb in jbs:
        A_rows.append([a["conv_table"], a["conv_col"], a["conv_cls"], a["conv_asis_dash"], a["conv_asis_blank"], a["conv_mode"], a["conv_rows"],
                       a["other_table"], a["other_col"], a["other_kind"], oa.get("dash") if "missing" not in oa else "AS-IS 없음", a["other_blank"], a["other_tobe_dash"] or None,
                       " & ".join(jb["join_cols"]) if jb else "", jb.get("now") if jb else None, jb.get("broken") if jb else None, eff(a, jb), (jb.get("error") or f"{jb['sec']}s") if jb else "미측정",
                       judge(a, jb), a["use_count"], a["objects"], a.get("sample", "")])
sheet("1_조인_한쪽만변환", ["변환 테이블", "변환 컬럼", "변환 컬럼 분류", "AS-IS '-' 행", "AS-IS 빈값 행", "변환 방식", "실제 '/' 가 되는 행(상한)", "상대 테이블(변환 안 됨)", "상대 컬럼", "상대 컬럼 실태", "상대 AS-IS '-' 행", "상대 AS-IS 빈값 행(NULL+''+' ')", "상대 TO-BE '-' 행",
                        "조인 조건(같은 문장의 등치 전부)", "현재 조인 성립 행", "양쪽 '-' 로 성립하는 행", "회귀 가능 행 상한", "측정", "판정", "사용 줄 수", "사용 객체", "원문 예"],
      A_rows, [30, 18, 26, 12, 12, 34, 14, 30, 18, 40, 12, 12, 12, 50, 14, 16, 14, 12, 60, 8, 50, 50])

# 2. 상대 미해석
half = R["A_join_half"]
sheet("2_조인_상대미해석", ["변환 테이블", "변환 컬럼", "상대 별칭", "상대 컬럼", "객체", "줄", "원문"],
      [[h["conv_table"], h["conv_col"], h["other_alias"], h["other_col"], h["obj"], h["line"], h["text"]] for h in half], [30, 18, 14, 18, 36, 8, 90])

# 3. 유니크 키
sheet("3_유니크키", ["테이블", "제약/인덱스", "종류", "키 컬럼", "변환 대상 키 컬럼", "'-' 보유 컬럼(AS-IS)", "'-'·'/' 공존 컬럼(TO-BE 실측)", "공백만 값 보유 컬럼(AS-IS)", "실측 필요", "비고"],
      [[b["table"], b["name"], b["type"], ", ".join(b["cols"]), ", ".join(b["conv_cols"]), ", ".join(b["dash_cols"]), ", ".join(b["both_cols"]), ", ".join(b["blank_cols"]), "예" if b["need_check"] else "", b["note"]] for b in R["B_unique"]],
      [30, 34, 12, 50, 40, 30, 24, 30, 8, 70])

# 4. FK · 5. 제약/인덱스/가상컬럼 · 파티션
sheet("4_FK", ["자식 테이블", "FK", "상태", "부모 테이블", "컬럼 매핑(상태)"], [[c["child"], c["fk"], c["status"], c["parent"], "; ".join(c["cols"])] for c in R["C_fk"]], [30, 44, 10, 30, 80])
sheet("5_제약_인덱스_가상컬럼", ["종류", "테이블", "이름", "관련 변환 컬럼", "식", "식에 '-' 포함", "상태", "판정"],
      [[e["kind"], e["table"], e["name"], ", ".join(e["cols"]), e["expr"], "예" if e["has_dash"] else "", e["status"], "식에 '-' 리터럴 없음 → 변환 무관(인덱스는 값 변경에 따라 자동 갱신)" if not e["has_dash"] else "식에 '-' 포함 → 수정 필요"] for e in R["E_expr"]],
      [14, 30, 36, 30, 70, 10, 10, 60])

# 6. 변환 대상 값 실태(AS-IS)
sheet("6_변환대상_값실태(AS-IS)", ["테이블", "컬럼", "분류", "AS-IS '-' 사용", "AS-IS '-' 행", "AS-IS 빈값 행(''+' ')", "AS-IS '' 행", "AS-IS 공백만 행", "AS-IS 뒤공백 값 행", "TO-BE '/' 행(부분 실측)", "TO-BE '--' 행(부분 실측)", "판정"],
      [[f["table"], f["col"], f["cls"], f["use"], f["asis_dash"], f["asis_blank"], f["asis_empty"], f["asis_space"], f["asis_trail"], f["tobe_slash"], f["tobe_ddash"],
        ("AS-IS 에 실제 '-' 값 있음 → 일괄 변환 시 그 값도 '/' 가 됨 (의미 사용이면 보류 51 과 같은 결정 필요)" if f["asis_dash"] else "") + (" / 공백만 값 → 공백→'/' 규칙 적용 대상" if f["asis_space"] else "") + (" / 뒤공백 값 → RTRIM 규칙 적용 대상" if f["asis_trail"] else "")] for f in R["F_values"]],
      [30, 20, 34, 18, 12, 14, 10, 12, 12, 12, 12, 70])

# 7·8. 코드 ↔ 데이터 어긋남
sheet("7_코드유지_데이터변환", ["객체", "서브프로그램", "줄", "액션(작업대상 xlsx)", "쓰임", "확정/후보", "관련 변환 컬럼(AS-IS 실태)", "원문", "사유", "비고", "판정"],
      [[g["obj"], g["sub"], g["line"], g["action"], g["use"], g["level"], g["cols"], g["text"], g["reason"], g["note"],
        "코드는 '-' 를 쓰는데 데이터는 '/' 로 바뀜 — 적재면 '-' 재유입, 비교면 불일치. 작업대상 xlsx 의 액션 재검토"] for g in R["G_code_keeps_dash"]], [36, 36, 8, 16, 16, 8, 50, 70, 40, 30, 60])
sheet("8_코드변환_데이터유지", ["객체", "서브프로그램", "줄", "액션(작업대상 xlsx)", "쓰임", "관련 컬럼(변환 안 됨)", "원문", "사유", "비고", "판정"],
      [[h["obj"], h["sub"], h["line"], h["action"], h["use"], h["cols"], h["text"], h["reason"], h["note"],
        "코드가 '/' 로 바뀌는데 그 컬럼의 데이터는 '-' 로 남음 → 비교 불일치. 컬럼을 변환 범위에 넣거나 코드 액션을 '유지' 로"] for h in R["H_code_to_slash_data_stays"]], [36, 36, 8, 16, 16, 60, 70, 40, 30, 60])

# 9. 추가분 115
ex_rows = []
for e in EX:
    t, c = e["table"], e["column"]
    a = (PS.get(t) or {}).get("asis", {}).get(c); b = (PS.get(t) or {}).get("tobe", {}).get(c)
    ex_rows.append(["신규 테이블 — DEFAULT 만" if e.get("kind") == "new_table" else "정제전 탈락 — DEFAULT + DML", t, c, e["col_id"], e["dtype"], e["nullable"], e.get("apply_default", "'/'"), e["where"],
                    a.get("dash") if a and "missing" not in a else (a or {}).get("missing", "미실측"), (a["null"] + a["empty"] + a["space"]) if a and "missing" not in a else None,
                    b.get("dash") if b else None, e["added"]])
sheet("9_추가분", ["구분", "테이블", "컬럼", "순번", "데이터형", "NULL 허용", "적용 DEFAULT", "기준 파일에서의 위치", "AS-IS '-' 행(실측·일부)", "AS-IS 빈값 행(실측·일부)", "TO-BE '-' 행(실측·일부)", "추가 근거"], ex_rows, [26, 30, 20, 6, 10, 8, 12, 44, 14, 14, 14, 60])

# 10. 코드 마스터 조인 NVL
Lr = R.get("L_lookup_join", [])
sheet("10_코드마스터_조인_NVL", ["객체", "유형", "줄", "코드 마스터 컬럼", "코드 마스터 AS-IS '-' 행", "코드 마스터 AS-IS 빈값 행", "상대 컬럼(변환 NOT NULL)", "상대 분류", "상대 AS-IS 빈값 행", "원문", "변경안(DML 코드에만)", "주의"],
      [[l["obj"], l["type"], l["line"], l["lookup_col"], l["lookup_asis_dash"], l["lookup_asis_blank"], l["other"], l["other_cls"], l["other_asis_blank"], l["text"], l["proposal"],
        "NVL 은 NULL 만 '/' 로 본다 — 코드 마스터에 이관 때 '-' 로 들어온 빈값 유래 행(AS-IS 빈값 행 수 참조)은 NVL 로 안 잡히므로 그 행은 별도 정정 또는 NVL(NULLIF(x,'-'),'/') 검토"] for l in Lr],
      [36, 14, 8, 16, 12, 12, 40, 30, 12, 90, 70, 60])

# 요약
ws = wb.active; ws.title = "요약"
jb_ok = [v for v in JB.values() if "error" not in v]
S = [["NULL 센티널 '-' → '/' 일괄 변환(DML) 위험 점검 — 보류 51 컬럼 제외"], [],
     ["작성", datetime.datetime.now().strftime("%Y-%m-%d %H:%M")],
     ["범위", f"DEFAULT '/' 대상 = 1차 목록 1,797 + 정제전 탈락 추가 {sum(1 for e in EX if e.get('kind') != 'new_table')} + 신규 테이블 {sum(1 for e in EX if e.get('kind') == 'new_table')} = {M['pop']:,} 컬럼. 데이터 변환(DML) 대상 = 그중 보류 51 · 코드 마스터 SCM_ADM_LOOKUP_MASTER_DETAIL · 신규 테이블 제외 = {M['pop'] - M['held']:,} 컬럼"],
     ["기존 데이터 실태", "AS-IS 개발 DB(LGCE_SCMDEV) 기준 — 작업대상 xlsx 1_컬럼판정 의 AS-IS 실측(10-01·10-07) + 조인 상대 컬럼 실측(10-07 s5). TO-BE 의 '-' 건수는 전부 '/' 로 바뀔 값이라 판정에 쓰지 않음(사용자 지시)."],
     ["", "AS-IS 의 '-' 중 TO-BE 이관으로 생긴 것은 의미 없음(사용자 지시) — 상대 컬럼은 AS-IS '-' 행 vs 빈값 행으로 '실제 '-'' 과 '이관 생성' 을 가름. 변환 대상 컬럼 자체는 '-' 건수가 아니라 AS-IS 코드의 비교·분기(보류 51)로 판정."],
     ["코드", "TO-BE 사내 ZIOUI1 전 프로그램·뷰 699객체 원문(10-07 14:39 조회) 정적 분석 + 작업대상 xlsx 3_TOBE_변경목록(6,542 '-' 출현)"],
     ["DB 변경", "없음 — 전부 조회"], [],
     ["유형", "건수", "결과"],
     ["1 조인의 한쪽만 변환", len(R["A_join"]), f"양쪽 모두 AS-IS 빈값 유래 행이 있는 쌍만. 회귀 가능 행 0 = {sum(1 for r in A_rows if r[16] == 0)} · 1 이상 = {sum(1 for r in A_rows if r[16])} · 미측정 = {sum(1 for r in A_rows if r[16] is None)}"],
     ["   (판정 기준)", "", "사용자 지시 10-07: '/' 가 되는 행 = AS-IS 에서 NULL·''·' ' 였던 행만. AS-IS 실제 '-' 는 변환·비교 대상 아님 → 변환 쪽 빈값 0 이거나 상대 쪽 '-' 가 전부 실제 값인 쌍은 제외(후자는 변환 후 안 맞게 되는 것이 AS-IS 동작 복원). 회귀 가능 행 상한 = min(양쪽 '-' 성립 행, 변환 쪽 빈값 유래 행, 상대 쪽 빈값 유래 행)"],
     ["2 조인 상대 미해석(별칭이 서브쿼리 등)", len(half), "정적 분석 한계 — 상대 테이블을 못 찾은 등치. 컬럼명으로 2차 확인 필요"],
     ["3 유니크 키에 변환 컬럼 포함", len(R["B_unique"]), f"실측 필요 {sum(1 for b in R['B_unique'] if b['need_check'])} (공백만 값 보유 → 공백→'/' 규칙 적용 시 중복 가능) · 나머지는 '/' 값 없음 → 1:1 사상"],
     ["4 FK", len(R["C_fk"]), "양쪽 다 변환 대상 — 부모→자식 순서 또는 제약 비활성 후 일괄"],
     ["5 CHECK·함수기반 인덱스·가상 컬럼", len(R["E_expr"]), f"식에 '-' 포함 {sum(1 for e in R['E_expr'] if e['has_dash'])} → 변환 무관"],
     ["6 변환 대상 중 AS-IS 실제 '-'·공백 값 보유", len(R["F_values"]), f"AS-IS 실제 '-' {sum(1 for f in R['F_values'] if f['asis_dash'])} · 공백만 {sum(1 for f in R['F_values'] if f['asis_space'])} · 뒤공백 {sum(1 for f in R['F_values'] if f['asis_trail'])}"],
     ["7 코드 '-' 유지 ↔ 데이터 '/' 변환", len(R["G_code_keeps_dash"]), f"확정 {sum(1 for g in R['G_code_keeps_dash'] if g['level'] == '확정')} · 후보 {sum(1 for g in R['G_code_keeps_dash'] if g['level'] == '후보')}"],
     ["8 코드 '/' 변환 ↔ 데이터 '-' 유지", len(R["H_code_to_slash_data_stays"]), "변환 범위 밖 컬럼을 '/' 와 비교하게 되는 줄"],
     ["9 추가분", len(EX), f"정제전 탈락 {sum(1 for e in EX if e.get('kind') != 'new_table')} = DEFAULT + 데이터 변환(AS-IS '-' 사용 분류 미실시) · 신규 테이블 {sum(1 for e in EX if e.get('kind') == 'new_table')} = DEFAULT '/' 만(DML·코드 수정 없음, 사용자 지시)"],
     ["10 코드 마스터(SCM_ADM_LOOKUP_MASTER_DETAIL) 조인 NVL", len(Lr), "코드 마스터는 데이터 변환 제외(사용자 지시 10-07). NOT NULL 변환 컬럼과 조인하는 코드 자리에 NVL(x,'/') — DML 코드에만"],
     ["파티션 키", len(R["D_partkey"]), "해당 없음"], [],
     ["읽는 법"], ["  시트 1 의 '끊김 행' 이 0 이면 그 조인은 변환 후에도 같은 결과. 0 보다 크면 '판정' 열의 조치가 필요."],
     ["  시트 1·8 의 상대 컬럼 실태 '이관 생성' = AS-IS 가 빈값이었는데 TO-BE 에 '-' 로 들어온 것 → 변환 범위 확대로 해소. '실제 '-' 보유' = AS-IS 에서도 '-' → 범위 확대로는 해소 안 됨."], [],
     ["한계"], ["  조인 추출은 정적 분석(문장 단위 별칭 해석). 서브쿼리·동적 SQL·USING 절 경유는 시트 2 로만 남음."],
     ["  시트 1 의 '현재 조인 성립 행' 은 같은 문장의 등치 조건만 넣은 수치 — 기간·사업부 상수 조건이 빠져 실제 실행 결과보다 클 수 있음. 끊김 행의 존재·규모 확인 용도."],
     ["  1억 행 초과 2 테이블(SCP_ANL_SHIPMENT_PLAN_FG · SCP_ANL_PRODUCTION_PLAN)은 사용자 지시로 실측 제외 — 변환 대상 컬럼 실태는 AS-IS 기준이라 영향 없음."],
     ["  추가분 115 의 AS-IS 실측은 조인 상대로 조회된 일부만 있음. AS-IS DEFAULT 없음 + 코드 NVL(x,'-') 로만 '-' 가 들어가는 컬럼(예 SCM_MST_SITE.COMPANY_ID)은 DEFAULT 범위 밖이라 별도."]]
for r in S: ws.append(r)
ws["A1"].font = Font(bold=True, size=13); ws.column_dimensions["A"].width = 44; ws.column_dimensions["B"].width = 12; ws.column_dimensions["C"].width = 120
out = HERE / "슬래시전환_DML위험점검_20261007.xlsx"; wb.save(out); print(out)
