# -*- coding: utf-8 -*-
"""asis_live_proof_join.py — 런처 정답 연결(_proof_live_answers.csv)에 판정 단위와 다음 조치를 붙인다 (2026-11-16 사용자 지시: 정적으로 되는 것은 정적으로, 런처는 동적 항목만)

입력  Doc/asislive/_proof_live_answers.csv (asis_live_proof_answers.py 출력)
출력  Doc/asislive/_proof_live_join.csv (화면 × 사유 종류: 건수 · 상태 · 판정 단위 · 증명 반영 가능 여부 · 다음 조치)
판정 단위  행 = 원장 행의 대상(SP·메시지)이 실행 기록에 있는지 본 것 / 화면 = 그 화면에 같은 종류 실행이 1건 이상 있는지만 본 것
한계  '정답 있음'은 AS-IS 쪽 관찰이 있다는 뜻이다. TO-BE 와 대조하기 전에는 증명됨이 아니다. 화면 단위 판정은 원장 행마다 정답이 있다는 근거가 아니다.
합계가 입력과 다르면 exit 1.
"""
import csv, os, sys, collections, time

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
try: sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception: pass
P = lambda *a: os.path.join(ROOT, *a)

ROW_KINDS = {"저장 밖 경로 메시지", "팝업·셀 이벤트 호출", "차등 검증 인자"}
# 사유 종류 → (1차 해결 방식, 다음 조치)
NEXT = {
    "차등 검증 인자": ("동적", "관찰한 SP 인자로 차등 검증 재실행(TO-BE 조회) 뒤 판정"),
    "팝업·셀 이벤트 호출": ("동적", "같은 셀·버튼 조작을 TO-BE 에서 실행해 호출 대조"),
    "저장 밖 경로 메시지": ("동적", "같은 분기를 TO-BE 에서 실행해 문구 대조"),
    "그리드에 없는 컬럼": ("정적", "AS-IS 시트 정의 원문의 Visible 과 TO-BE 컬럼 메타 대조"),
    "편집 불가 셀": ("정적 우선", "잠금 규칙 원문(lock_rules)과 TO-BE 편집 속성 대조. 행 값 조건이 붙은 것만 동적"),
    "행 조건 계산": ("정적 우선", "조건식 원문과 TO-BE 조건 대조. 조건 컬럼 값이 필요한 것만 동적"),
    "분기 해석": ("정적 우선", "분기 원문과 TO-BE 구현 위치 대조. 값에 따라 갈리는 것만 동적"),
    "검증 위반 입력": ("정적 우선", "검증 조건·메시지 원문과 TO-BE 검증 대조. 메시지 순서가 실행에 달린 것만 동적"),
    "팝업 사용처": ("정적", "셀 더블클릭 처리기 원문에서 팝업 종류 확정"),
    "팝업 내부": ("동적", "팝업 조건·그리드 덤프를 TO-BE 팝업과 대조"),
    "팝업 값 반영": ("동적", "팝업 선택 뒤 바뀐 셀을 TO-BE 와 대조"),
    "신규행 전제": ("동적", "행 추가 결과(행 수·기본값)를 TO-BE 와 대조"),
    "동작 재현 시나리오": ("동적", "진입점 실행 기록을 TO-BE 시나리오와 대조"),
    "조건 데이터 없음": ("동적", "행이 나오는 조회 조건으로 TO-BE 재실행"),
}


def main():
    src = P("Doc", "asislive", "_proof_live_answers.csv")
    if not os.path.exists(src): print("[ERROR] %s 없음" % src); return 3
    rows = list(csv.DictReader(open(src, encoding="utf-8-sig")))
    out = []; tot = collections.Counter(); way = collections.Counter()
    for r in rows:
        n = int(r["count"] or 0); k = r["kind"]; st = r["state"]
        unit = "행" if k in ROW_KINDS else "화면"
        how, nxt = NEXT.get(k, ("미분류", ""))
        if st != "정답 있음": ready = "아니오"; nxt2 = "정답 없음(%s)" % st
        elif unit == "행": ready = "TO-BE 대조 가능"; nxt2 = nxt
        else: ready = "행 연결 필요"; nxt2 = nxt
        out.append([r["menu_id"], k, n, st, unit, how, ready, nxt2, r["evidence"]])
        tot[(st == "정답 있음", unit)] += n; way[(how, st == "정답 있음")] += n
    if sum(tot.values()) != sum(int(r["count"] or 0) for r in rows): print("[ERROR] 합계 불일치"); return 1
    dst = P("Doc", "asislive", "_proof_live_join.csv")
    with open(dst + ".tmp", "w", encoding="utf-8-sig", newline="") as f:
        w = csv.writer(f); w.writerow(["menu_id", "kind", "count", "state", "judge_unit", "solve_by", "proof_ready", "next", "evidence"]); w.writerows(out)
    os.replace(dst + ".tmp", dst)
    print("[실측 %s] 런처 몫 %d건" % (time.strftime("%Y-%m-%d %H:%M"), sum(tot.values())))
    print("  정답 있음·행 단위 %d · 정답 있음·화면 단위 %d · 정답 없음 %d" % (tot[(True, "행")], tot[(True, "화면")], tot[(False, "행")] + tot[(False, "화면")]))
    for (how, ok), n in sorted(way.items()): print("  %s · %s: %d" % (how, "정답 있음" if ok else "정답 없음", n))
    print("@@LINK 📂 런처 정답 결합|%s" % dst)
    return 0


if __name__ == "__main__":
    sys.exit(main())
