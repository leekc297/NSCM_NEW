# -*- coding: utf-8 -*-
"""결과 봉투 vibe-result/1 — 판정 산출물 옆 <이름>.result.json (2026-10-26)

짝 = tools/Harness/lib/envelope.js (같은 규칙 — 한쪽만 고치지 말 것). 형식은 Atlas Studio 결과 봉투를 따른다.
  state   = completed | failed | input-required(사람 확인 대기) | error(실행·판정 불가)
  verdict = pass | fail | hold | None
  evidence.kind: 기계 = test·build·lint·schema·exec·db·source(evidence_check 가 verified=True 로 확인한 인용)
                 사람 = human(by 필수, AI 이름 불가) / AI 판단 = agent-judgment
읽기 규칙: 파일 없음·깨짐·형식 위반 = state 'error' — 판정이 없는 것을 통과로 보지 않는다.
"""
import datetime
import json
import os
import re

SCHEMA = 'vibe-result/1'
STATES = ('completed', 'failed', 'input-required', 'error')
VERDICTS = ('pass', 'fail', 'hold')
MACHINE = ('test', 'build', 'lint', 'schema', 'exec', 'db')
AI_NAMES = re.compile(r'^(ai|claude|agent|assistant|bot)\b', re.I)


def sidecar(path):
    return path if path.endswith('.result.json') else re.sub(r'\.(md|csv|json|xlsx)$', '', path, flags=re.I) + '.result.json'


def is_hard(ev):
    if not isinstance(ev, dict):
        return False
    k = ev.get('kind')
    if k in MACHINE:
        return ev.get('verified') is not False
    if k == 'source':
        return ev.get('verified') is True
    if k == 'human':
        by = str(ev.get('by') or '').strip()
        return bool(by) and not AI_NAMES.match(by)
    return False


def grade_of(issue):
    return 'hard' if any(is_hard(e) for e in (issue or {}).get('evidence') or []) else 'soft'


def write(path, env):
    out = {'schema': SCHEMA, 'ts': datetime.datetime.now().astimezone().isoformat(timespec='seconds')}
    out.update(env)
    if out.get('state') not in STATES:
        raise ValueError(f"state 값 오류: {out.get('state')}")
    if out.get('verdict') is not None and out['verdict'] not in VERDICTS:
        raise ValueError(f"verdict 값 오류: {out['verdict']}")
    out['issues'] = [dict(i, grade=i.get('grade') or grade_of(i)) for i in out.get('issues') or []]
    out.setdefault('evidence', [])
    p = sidecar(path)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p + '.tmp', 'w', encoding='utf-8') as f:
        json.dump(out, f, ensure_ascii=False, indent=1)
    os.replace(p + '.tmp', p)
    return p


def read(path):
    p = sidecar(path)
    err = lambda why: {'schema': SCHEMA, 'state': 'error', 'verdict': None, 'issues': [], 'evidence': [], 'why': why, 'file': p}
    if not os.path.exists(p):
        return err('결과 파일 없음')
    try:
        with open(p, encoding='utf-8-sig') as f:
            j = json.load(f)
    except (OSError, ValueError) as e:
        return err(f'결과 파일 해석 실패: {e}')
    if not isinstance(j, dict) or j.get('schema') != SCHEMA:
        return err(f"schema 불일치: {isinstance(j, dict) and j.get('schema')}")
    if j.get('state') not in STATES:
        return err(f"state 값 오류: {j.get('state')}")
    if j.get('verdict') is not None and j['verdict'] not in VERDICTS:
        return err(f"verdict 값 오류: {j['verdict']}")
    j.setdefault('issues', [])
    j.setdefault('evidence', [])
    j['file'] = p
    return j
