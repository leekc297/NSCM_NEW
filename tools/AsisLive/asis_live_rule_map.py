# -*- coding: utf-8 -*-
"""AS-IS 관찰 문구 → TO-BE 룰 대응표 생성 (2026-11-13 · 사용자 "TO-BE RULE 로 정의된 부분은 AS-IS 와 차이가 발생해도 오류가 아니다")

  python tools/AsisLive/asis_live_rule_map.py            (대응표 다시 만들기)
입력  tools/Harness/rules/tobe_rule_registry.csv   TO-BE 룰 원장(kind=TOBE_DIFF · 보류·N 제외)
      AS-IS 메시지 사전: UP_FX_GetMessageInfoList(메시지 코드 → 문구 · 조회만) → Doc/asislive/_asis_messages.json 에 보관
      tools/AsisLive/asis_obs_rule_map_manual.csv   사람이 적은 행(있으면 그대로 합친다)
방법  ① 룰 본문(title·requirement)에 AS-IS 메시지 코드(MSGnnnnn)가 적혀 있으면 그 코드의 문구를 패턴으로 만든다({0} 같은 자리는 아무 글자).
      ② 편집 모드 계열: 룰 CR-103("AS-IS 편집 버튼 경로의 안내 메시지는 TO-BE 에 없어도 정상") · CR-093 · CR-084 가 가리키는 '수정 모드가 아니어서 못 한다' 류 메시지 —
         메시지 사전에서 문구에 '수정모드'·'편집모드'·'modify mode'·'edit mode' 가 든 것 전부.
      level  confirmed = 룰 본문이 "오류가 아니다 / 정상이다 / 없어도 된다" 고 적었거나 ② 계열 → 분기 대조에서 **오류 아님**으로 처리
             candidate = 룰이 그 메시지를 언급만 함(무엇을 정했는지는 사람이 읽어야 함) → 분기 대조에서 **판정필요**(룰 ID 표시)
산출  tools/AsisLive/asis_obs_rule_map.csv   pattern · rule_ids · note · scope(ALL 또는 화면 ID 목록) · level · source · msg_id
한계  문구가 사전과 다르게 조립되는 메시지(코드에서 직접 만든 문장)는 잡지 못한다. 룰 본문에 메시지 코드가 없는 룰은 ②·수동 행으로만 들어온다.
"""
import csv, json, os, re, sys, collections

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
P = lambda *a: os.path.join(ROOT, *a)
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception: pass
BAD = {"보류", "N"}
OKTEXT = re.compile(r"오류가\s*아니|오류\s*아님|정상이다|정상\s*처리|없어도\s*(된다|정상)|FAIL\s*이\s*아니")
EDIT = re.compile(r"수정\s*모드|편집\s*모드|modify mode|edit mode", re.I)
# 편집 모드 계열 중 소스로 경로를 확인한 것만 '오류 아님' — 나머지는 판정필요(무엇을 막는 메시지인지 화면마다 다를 수 있다)
#   BaseForm.OnClickEditButton(3664~): MSG00115·MSG00139·MSG00162 = 편집 버튼을 눌렀을 때의 안내(CR-103 이 말하는 '편집 버튼 경로의 안내 메시지')
#   BaseForm(3950~3954)·화면 소스: MSG00008·MSG00009·MSG00010·MSG00135 = 수정 모드가 아니어서 추가·삭제·저장·입력을 못 한다(TO-BE 는 상시 편집 CR-093·CR-084)
EDIT_CONFIRMED = {"MSG00115", "MSG00139", "MSG00162", "MSG00008", "MSG00009", "MSG00010", "MSG00135"}


def messages():
    f = P("Doc", "asislive", "_asis_messages.json")
    try:
        sys.path.insert(0, P("tools", "DbConn")); import dbconn
        cur = dbconn.connect("asis").cursor(); cur.execute("exec UP_FX_GetMessageInfoList @Search=?", None)
        cols = [d[0] for d in cur.description]; M = {str(r[0]).strip(): {c: ("" if v is None else str(v)) for c, v in zip(cols, r)} for r in cur.fetchall()}
        json.dump(M, open(f, "w", encoding="utf-8"), ensure_ascii=False, indent=0); return M, "DB"
    except Exception as ex:
        try: return json.load(open(f, encoding="utf-8")), "보관본(DB 조회 실패: %s)" % str(ex)[:60]
        except Exception: return {}, "없음"


def pat(text):
    """메시지 문구 → 정규식(자리 표시 {0}·줄바꿈 표기는 느슨하게)"""
    t = re.sub(r"\\[nr]", " ", text or "").strip()
    parts = re.split(r"\{\d+\}", t)
    return r".{0,60}".join(re.sub(r"\\ ", r"\\s*", re.escape(p.strip())) for p in parts if p.strip() != "" or len(parts) == 1)


def main():
    M, src = messages(); rows = []; seen = set()
    reg = [r for r in csv.DictReader(open(P("tools", "Harness", "rules", "tobe_rule_registry.csv"), encoding="utf-8-sig")) if r.get("kind") == "TOBE_DIFF" and (r.get("status") or "").strip() not in BAD]
    for r in reg:
        body = (r.get("title") or "") + " " + (r.get("requirement") or "")
        for code in sorted(set(re.findall(r"MSG\d{4,}", body))):
            m = M.get(code)
            if not m or not (m.get("Ko") or "").strip(): rows.append({"pattern": "", "rule_ids": r["rule_id"], "note": "메시지 사전에 %s 없음 — 패턴을 만들지 못함" % code, "scope": r.get("scope") or "ALL", "level": "unusable", "source": "원장:MSG 코드", "msg_id": code}); continue
            for lang in ("Ko", "En"):
                p = pat(m.get(lang))
                if not p or (p, r["rule_id"]) in seen: continue
                seen.add((p, r["rule_id"]))
                rows.append({"pattern": p, "rule_ids": r["rule_id"], "note": (r.get("title") or "")[:70], "scope": r.get("scope") or "ALL", "level": "confirmed" if OKTEXT.search(body) else "candidate",
                             "source": "원장:MSG 코드", "msg_id": code})
    for code, m in sorted(M.items()):
        if EDIT.search((m.get("Ko") or "") + " " + (m.get("En") or "")):
            for lang in ("Ko", "En"):
                p = pat(m.get(lang))
                if not p or (p, "EDIT") in seen: continue
                seen.add((p, "EDIT"))
                rows.append({"pattern": p, "rule_ids": "CR-093;CR-084;CR-103", "note": "AS-IS 는 수정 모드(Edit F2)가 있어야 하는 동작 — TO-BE 는 편집 버튼 없이 상시 편집(편집 버튼 경로 안내 메시지는 TO-BE 에 없어도 정상)",
                             "scope": "ALL", "level": "confirmed" if code in EDIT_CONFIRMED else "candidate",
                             "source": "편집 모드 계열(%s)" % ("소스 경로 확인 BaseForm.cs" if code in EDIT_CONFIRMED else "메시지 사전 문구만 — 경로 미확인"), "msg_id": code})
    man = P("tools", "AsisLive", "asis_obs_rule_map_manual.csv")
    if os.path.exists(man):
        for r in csv.DictReader(open(man, encoding="utf-8-sig")):
            rows.append({"pattern": r.get("pattern"), "rule_ids": r.get("rule_ids"), "note": r.get("note") or "", "scope": r.get("scope") or "ALL", "level": r.get("level") or "confirmed", "source": "수동", "msg_id": r.get("msg_id") or ""})
    ok = []
    for r in rows:
        if r["level"] != "unusable":
            try: re.compile(r["pattern"])
            except re.error: r["level"] = "unusable"; r["note"] += " (패턴 오류)"
        ok.append(r)
    with open(P("tools", "AsisLive", "asis_obs_rule_map.csv"), "w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["pattern", "rule_ids", "note", "scope", "level", "source", "msg_id"]); w.writeheader(); w.writerows(ok)
    c = collections.Counter(r["level"] for r in ok)
    print("메시지 사전 %d개(%s) · TO-BE 차이 룰 %d개 · 대응 행 %d = 오류 아님 %d · 판정필요 %d · 패턴 못 만듦 %d" % (len(M), src, len(reg), len(ok), c["confirmed"], c["candidate"], c["unusable"]))
    print("룰 수: 오류 아님 %d · 판정필요 %d · 메시지 코드 수 %d" % (len({x for r in ok if r["level"] == "confirmed" for x in r["rule_ids"].split(";")}), len({r["rule_ids"] for r in ok if r["level"] == "candidate"}), len({r["msg_id"] for r in ok if r["msg_id"]})))
    print("@@LINK 📄 관찰 문구→룰 대응표|tools/AsisLive/asis_obs_rule_map.csv")


if __name__ == "__main__":
    main()
