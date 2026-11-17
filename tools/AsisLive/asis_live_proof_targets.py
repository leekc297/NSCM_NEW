# -*- coding: utf-8 -*-
"""asis_live_proof_targets.py — 증명 목록(_proof_backlog)의 미증명 검사 단위 가운데 AS-IS 런처 실행으로 정답을 줄 수 있는 것을 고른다 (2026-11-14 사용자 지시: 27화면에서 미검증·미판단 0 먼저)

입력  Doc/verify/_proof_backlog_detail_by_screen.csv (proof_backlog.py 출력: bucket, check, reason, menu_id, count)
      Doc/asislive/_scenarios_spec_summary.csv, Doc/asislive/_summary.csv, asis_live_batch.EXCLUDED
출력  Doc/asislive/_proof_live_targets.csv        (화면 × 분류 × 사유 종류 × 런처 조작 × 건수)
      Doc/asislive/_proof_live_targets_summary.csv (화면 × 사유 종류 건수)
분류  사유 글을 아래 KINDS 정규식으로 위에서부터 맞춘다. 어디에도 안 맞으면 '그 밖'으로 남긴다(버리지 않음). 합계 = 입력 합계가 아니면 exit 1.
한계  사유 글로만 나눈다. 런처로 정답을 줄 수 있다는 것은 조작 종류가 있다는 뜻이고 실행해서 확인한 것은 아니다. 검사기 쪽 작업(재실행, 실행 경로 연결, 대조표 기입)은 '검사기 쪽'으로 표시만 한다.

  python tools/AsisLive/asis_live_proof_targets.py            증명 목록에 있는 화면 전부
  python tools/AsisLive/asis_live_proof_targets.py <ID> …     지정 화면
"""
import csv, os, re, sys, collections, time

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
try: sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception: pass
csv.field_size_limit(10 ** 8)
P = lambda *a: os.path.join(ROOT, *a)

# (사유 종류, 정규식, 맡는 쪽, 런처 조작)
KINDS = [
    ("재실행 대기", r"아직 재실행되지 않음|측정 시점 조건", "검사기 쪽", ""),
    ("차등 검증 인자", r"파라미터 미정|골든 비교 케이스 없음|SKIP AS-IS", "런처", "팝업·셀·버튼 실행에서 잡은 SP 인자를 차등 검증 입력으로 전달"),
    ("TO-BE 셀 위치", r"셀 위치 확인 불가|팝업이 열리지 않아", "검사기 쪽", ""),
    ("팝업·셀 이벤트 호출", r"진입·조회 중 호출 없음|결과를 반환하지 않음\(팝업·셀 이벤트|팝업 조회 호출 없음", "런처", "트리거 셀·버튼 실행, 그때 호출된 SP·인자·행 수 기록"),
    ("팝업 사용처", r"팝업 사용처를 기계로 확정하지 못함|트리거 셀을 화면 메타에서 찾지 못함|팝업 셀 해석 불가|팝업 셀 .* 현재 그리드에 없음", "런처", "셀마다 더블클릭해 어느 팝업이 열리는지 기록"),
    ("팝업 내부", r"팝업 내부|팝업을 연 상태에서", "런처", "팝업을 연 상태로 내부 조건·그리드 덤프, 내부 조회 실행"),
    ("팝업 값 반영", r"팝업 선택|팝업에서 가져온 값|더블클릭\+Esc|팝업 문장|인자 없는 팝업", "런처", "트리거 셀 더블클릭, 팝업 첫 행 선택, 바뀐 셀 기록"),
    ("신규행 전제", r"신규행 없음|행 추가|Insert 했으나|버튼 비노출", "런처", "같은 조회 조건에서 행 추가 버튼 실행, 추가된 행 수와 메시지 기록"),
    ("편집 불가 셀", r"편집 불가|원천 셀을 열 수 없", "런처", "같은 행의 셀 잠금·배경색 읽기, 편집 가능한 행 조건 찾기"),
    ("행 조건 계산", r"조건 계산 불가|조건식을 행 값으로", "런처", "조회 뒤 행마다 조건 컬럼 값과 셀 잠금·색 읽기"),
    ("저장 밖 경로 메시지", r"경로 메시지|Save 진입점에서 닿지 않음", "런처", "그 메시지가 있는 버튼·이벤트 분기 실행, 대화상자 문구 기록"),
    ("검증 위반 입력", r"위반 입력 자동 생성 불가|기존행 기반 위반 입력 불가", "런처", "조건식의 위반 값을 셀에 넣고 저장 버튼 실행(검증에서 멈춤), 메시지 기록"),
    ("분기 해석", r"분기 해석 불가|원천/대상 해석 불가|연쇄 원천 컬럼 해석 불가|원천 실행 불가", "런처", "조건 컬럼 값이 다른 행에서 원천 셀 변경, 바뀐 셀 기록"),
    ("그리드에 없는 컬럼", r"현재 그리드에 없음", "런처", "AS-IS 시트 덤프에서 그 컬럼의 표시 여부 읽기"),
    ("검사기 실행 경로", r"실행하지 못함|검증 엔진 확장 대상|실행하는 경로 없음|실행 필요|판정하지 못함", "검사기 쪽", ""),
    ("집계 행", r"진입점 집계|행 집계", "검사기 쪽", ""),
    ("대조표 기입", r"구현 위치|대조표 기록 보강|사유·근거", "검사기 쪽", ""),
    ("동작 재현 시나리오", r"진입점 동작 재현 시나리오 필요", "런처", "그 진입점(버튼·이벤트) 분기 실행, 호출·메시지·그리드 변화 기록"),
    ("AS-IS 문장 연결 없음", r"연결된 문장·요소 검사가 없다|문장 추출 0", "검사기 쪽", ""),
    ("죽은 코드 확인", r"진입점 미연결|살아있는 코드 없음", "검사기 쪽", ""),
    ("TO-BE 룰 근거 NA", r"룰 CR-|TO-BE 룰|룰 \S+ —", "확정 후보", ""),
    ("조건 데이터 없음", r"조건을 만족하는 행 없음|조건 데이터 없음", "런처", "조건을 만족하는 행이 나오는 조회 조건 찾기, 없으면 시험 행 넣기"),
]
OPEN = ("B01", "B02", "B04", "B05", "B06", "B07", "B08", "B09", "B10", "B11", "B12", "B13", "B14", "B15", "B16")


def kind(reason):
    for k, rx, who, op in KINDS:
        if re.search(rx, reason or ""): return k, who, op
    return "그 밖", "미분류", ""


def main():
    ids = [a.upper() for a in sys.argv[1:] if not a.startswith("-")]
    src = P("Doc", "verify", "_proof_backlog_detail_by_screen.csv")
    if not os.path.exists(src): print("[ERROR] %s 없음. proof_backlog.py 먼저" % src); return 3
    rows = [r for r in csv.DictReader(open(src, encoding="utf-8-sig")) if r["bucket"][:3] in OPEN and (not ids or r["menu_id"] in ids)]
    sys.path.insert(0, HERE)
    try:
        import asis_live_batch as B; excl = set(B.EXCLUDED)
    except Exception: excl = set()
    live = {}
    f = P("Doc", "asislive", "_summary.csv")
    if os.path.exists(f): live = {r["id"]: r.get("status", "") for r in csv.DictReader(open(f, encoding="utf-8-sig"))}
    agg = collections.Counter(); per = collections.defaultdict(collections.Counter); total = 0
    for r in rows:
        n = int(r.get("count") or 1); total += n
        k, who, op = kind(r.get("reason"))
        mid = r["menu_id"]
        st = "런처 제외 화면" if mid in excl else ("런처 기본 실행 " + (live.get(mid) or "없음"))
        agg[(mid, r["bucket"][:3], k, who, op, st)] += n; per[mid][k] += n
    out = P("Doc", "asislive", "_proof_live_targets.csv")
    with open(out, "w", encoding="utf-8-sig", newline="") as fo:
        w = csv.writer(fo); w.writerow(["menu_id", "bucket", "kind", "owner", "launcher_op", "launcher_state", "count"])
        for key, n in sorted(agg.items()): w.writerow(list(key) + [n])
    kinds = [k for k, _, _, _ in KINDS] + ["그 밖"]
    with open(P("Doc", "asislive", "_proof_live_targets_summary.csv"), "w", encoding="utf-8-sig", newline="") as fo:
        w = csv.writer(fo); w.writerow(["menu_id"] + kinds + ["합계"])
        for mid in sorted(per): w.writerow([mid] + [per[mid][k] for k in kinds] + [sum(per[mid].values())])
    if sum(agg.values()) != total: print("[ERROR] 합계 불일치 %d ≠ %d" % (sum(agg.values()), total)); return 1
    tk = collections.Counter(); tw = collections.Counter()
    for (mid, b, k, who, op, st), n in agg.items(): tk[k] += n; tw[who] += n
    print("[실측 %s] 화면 %d, 미증명 검사 단위 %d" % (time.strftime("%Y-%m-%d %H:%M"), len(per), total))
    print("  맡는 쪽: " + ", ".join("%s %d" % kv for kv in tw.most_common()))
    print("  사유 종류: " + ", ".join("%s %d" % kv for kv in tk.most_common()))
    print("@@LINK 📂 런처 정답 연결 대상|%s" % out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
