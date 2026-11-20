#!/usr/bin/env bash
# 구간 A·B·C·D 패치를 실제 엔진 파일에 반영(진행 중 CheckList 가 끝난 뒤 실행) — 각 패치는 종전 문장이 정확히 1번 있을 때만 적용, 이미 적용됐으면 건너뜀
set -e
cd /c/Projects/NSCM
V=tools/Harness/verify
N=tools/Harness/_verify_next
P=$N/_patch
date '+[반영 시작] %Y-%m-%d %H:%M:%S'
python $P/p_a_llmcall.py $V
python $P/p_a_review.py $V
python $P/p_a_judge.py $V
python $P/p_a_dedup.py $V
python $P/p_a_docs.py $V
python $P/p_c_resolve.py $V
python $P/p_b_integrate.py $V
python $P/p_c_prompt.py tools/VibeManager/quick.json
python $P/p_d_prompts.py tools/Harness/prompts/new_screen.md tools/VibeManager/quick.json
# 신규 도구(사본 → 실제)
for f in criteria_build.py port_review.py ai_usage.py; do
  if [ -f $V/$f ] && ! cmp -s $N/$f $V/$f; then cp -p $V/$f $V/$f.bak_20261120_aipts; fi
  cp -p $N/$f $V/$f
done
# guess_scan LLM 탐지 보강(사본에서 직접 고친 파일)
if ! cmp -s $N/guess_scan.py $V/guess_scan.py; then
  python - <<'EOF'
import re
p='tools/Harness/verify/guess_scan.py'; s=open(p,encoding='utf-8').read()
old='''RX_LLM = re.compile(r"claude\\s+-p|['\\"]claude['\\"]\\s*,|spawn\\w*\\(\\s*['\\"]claude|_prompt\\.txt")'''
new='''RX_LLM = re.compile(r"claude\\s+-p|['\\"]claude['\\"]\\s*,|spawn\\w*\\(\\s*['\\"]claude|_prompt\\.txt|llm_call\\.ask\\(|\\bask\\(\\s*mid\\s*,\\s*['\\"]")   # 2026-11-20: 공용 호출기(llm_call.ask) 호출도 LLM 지점(종전 정규식이 못 잡음)'''
if new not in s:
    assert s.count(old)==1, 'guess_scan anchor'
    import shutil; shutil.copy2(p, p+'.bak_20261120_aipts')
    open(p,'w',encoding='utf-8').write(s.replace(old,new)); print('ok guess_scan.py (1 변경)')
EOF
fi
python -m py_compile $V/llm_call.py $V/llm_review.py $V/judge.py $V/dedup_screen.py $V/make_verify_docs.py $V/run_verify.py $V/llm_desc.py $V/unverified_resolve.py $V/checklist_run.py $V/criteria_build.py $V/port_review.py $V/ai_usage.py $V/guess_scan.py
for t in llm_call llm_review llm_desc criteria_build port_review ai_usage; do python $V/$t.py --selftest | tail -1; done
python $V/dedup_screen.py --selftest | tail -1
date '+[반영 끝] %Y-%m-%d %H:%M:%S'
