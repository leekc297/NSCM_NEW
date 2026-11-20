# -*- coding: utf-8 -*-
"""구간 D2·D5·D6 — 개발·보완 프롬프트에 AI 지점 연결
   new_screen.md (D2): 기준 원장 이식 목록(Doc/gen/<ID>/port_plan.csv) 행 단위로 이식하고 행마다 구현 위치를 적는다 · 끝나면 독립 검토(port_review --review)
   quick.json 🧯 (D5·D6): 보완 진단(port_review --diag → repair_diag.csv) 먼저 · 정해진 보완(repair_apply.py)으로 풀리는 묶음 먼저 · 남은 묶음만 직접 수정
                          · 확인은 수정분 재점검(checklist_run.py --delta)"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pt import patch

NS, QJ = sys.argv[1], sys.argv[2]
patch(NS, [
    ("## 완료 정의(DoD)",
     "9. **이식 목록(기준 원장 · 2026-11-20 사용자 지시 'UI 개발 과정에 AI 적용')**: `python tools/Harness/verify/port_review.py <ID> --plan` 이 만든 `Doc/gen/<ID>/port_plan.csv` 가 이식할 확인 항목 전체다"
     "(AS-IS 파싱·AS-IS 실측·TO-BE 룰을 화면 요소에 묶은 기준 · 대상 아님 항목은 빠져 있음). 행 단위로 이식하고, 행마다 `impl_where` 열에 구현 위치(파일:줄)를 적는다. "
     "목록이 없으면 `python tools/Harness/verify/criteria_build.py <ID>` → `--plan` 순서로 만든다. 끝나면 `python tools/Harness/verify/port_review.py <ID> --review` (다른 검토자가 구현 위치 인용을 확인) 결과의 미구현 의심 0 을 맞춘다.\n\n"
     "## 완료 정의(DoD)"),
])
patch(QJ, [
    ("[원인 계층 실측 — 2026-11-11] 보완 전에",
     "[보완 진단 · 정해진 보완 먼저 — 2026-11-20 사용자 지시 'UI 보완 과정에 AI 적용 · 불필요한 AI 사용 제거'] 보완 전에 `python tools/Harness/verify/port_review.py ${id} --diag` 로 원인 묶음마다 고칠 계층·위치(파일:줄 인용 확인)·정해진 보완 처방을 받는다(Doc/verify/${id}/repair_diag.md). "
     "처방(recipe)이 있는 묶음은 `python tools/Harness/verify/repair_apply.py ${id}` (dry-run 확인 뒤 --apply)로 먼저 풀고, 남은 묶음만 직접 고친다. 진단의 위치 인용이 확인 안 된(verified N) 묶음은 원문을 직접 확인한 뒤 고친다. "
     "보완 뒤 확인은 전체 재수행 대신 `python tools/Harness/verify/checklist_run.py ${id} --delta` (바뀐 소스 범위만 재측정)로 한다. [원인 계층 실측 — 2026-11-11] 보완 전에"),
])
import json
json.load(open(QJ, encoding='utf-8-sig'))
print('quick.json JSON OK')
