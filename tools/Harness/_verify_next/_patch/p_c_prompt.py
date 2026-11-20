# -*- coding: utf-8 -*-
"""구간 C3·C5 — quick.json '🧪 미검증 해소' 프롬프트
   C3 목록 전 행을 이번 라운드에 처리(다음 라운드로 넘기지 않음 · 못 하면 행마다 사유) · 파일이 겹치지 않는 묶음은 하위 에이전트로 나눠 동시 처리
      판단 행은 AI 판정 검토가 먼저 본다(결론 안 난 행 = 담당 '결정' · 처리 대상 아님) · 기준 원장(criteria.md) 입력 추가
   C5 결정 목록 = 같은 결정끼리 묶은 한 표(정할 내용 · 행 수 · 권장안 · 근거 경로:줄) · 기준 원장 판단 대기 항목 포함"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pt import patch

F = sys.argv[1]   # quick.json 경로
patch(F, [
    ("참고: Doc/verify/_checker_defects.md(검사기 결함 유형 T1~)",
     "기준 원장 Doc/verify/${id}/criteria/criteria.md(AS-IS 파싱·실측·TO-BE 룰을 화면 요소에 묶은 기준 · 판단 대기 · 대상 아님)를 같이 읽는다. 참고: Doc/verify/_checker_defects.md(검사기 결함 유형 T1~)"),
    ("처리 순서는 행 수가 많은 묶음부터.",
     "처리 순서는 행 수가 많은 묶음부터. 2026-11-20 사용자 지시(미검증 1회 해소): 목록의 모든 행을 이번 라운드에 처리한다. '다음 라운드 대상'으로 넘기지 않는다. 처리하지 못한 행은 _unverified_plan.md 에 행마다 사유(막힌 파일·원인·필요한 결정)를 적는다. 묶음이 서로 다른 검사기 파일을 고치면 Agent 도구로 묶음별 하위 에이전트에 나눠 동시에 맡긴다(같은 파일을 고치는 묶음은 한 에이전트 · 하위 에이전트가 고친 내용은 직접 다시 확인)."),
    ("- 판단: TO-BE 룰 원장과 AS-IS 원문에서 근거를 찾는다.",
     "- 판단: 2026-11-20 부터 판단 행은 CheckList 1단계의 AI 판정 검토(llm_review.py)가 판정필요와 같이 먼저 본다. 근거가 확인된 행은 판정이 이미 바뀌었고, 결론이 안 난 행은 담당 '결정'으로 분류돼 이 목록에 없다(결정 목록에만 적는다). 목록에 남은 판단 행은 TO-BE 룰 원장과 AS-IS 원문에서 근거를 찾는다."),
    ("결정 목록은 Doc/verify/${id}/_unverified_decisions.md(행 ID, 정할 내용, 근거).",
     "결정 목록은 Doc/verify/${id}/_unverified_decisions.md 에 같은 결정끼리 묶은 한 표로 쓴다(열 = 정할 내용, 행 수, 행 ID, 권장안, 근거 경로:줄). 권장안은 원문 근거가 있는 쪽으로 적고 근거가 없으면 '근거 없음'으로 적는다. 담당 '결정' 행(unverified_triage.csv)과 기준 원장 판단 대기 항목(criteria.md)을 같이 넣는다."),
])
json.load(open(F, encoding='utf-8-sig'))   # JSON 깨짐 확인
print('quick.json JSON OK')
