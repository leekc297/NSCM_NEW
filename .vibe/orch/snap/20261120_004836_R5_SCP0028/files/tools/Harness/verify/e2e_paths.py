#!/usr/bin/env python3
"""e2e_paths — 화면별 E2E 결과·로그 위치 찾기 (2026-11-06 사용자 지시: 화면 ID 중간 폴더)

배경: 여러 화면 CheckList 를 동시에 돌리면 공용 Doc/e2e/results/results.json·_summary.csv·artifacts 를 서로 덮어써
      (11-06 10:17 SCP0084·0037·0016 smoke 동시) 결과를 쓸 수 없었다. run-e2e.cmd <종류> <ID 1개> 는 이제
        결과  Doc/e2e/results/<ID>/  (results.json · html/ · artifacts/ · shots/ · dberr_partial.json · _summary.csv · _summary.md)
        로그  Doc/e2e/logs/<ID>/     (run_<RUNID>_<종류>.log · _run.log)
      에 쓴다. 공용 Doc/e2e/results/_summary.csv 는 화면별 요약을 모은 색인(report.js 가 잠금 안에서 원자 교체)으로 남는다.

읽는 규칙(모든 도구 공통):
  · 화면 하나의 결과 = 화면 폴더가 있으면 그 파일, 없으면(전환 전 결과) 공용 위치에서 그 화면 행/파일만
  · 화면 전체 목록이 필요하면 공용 색인(index_rows)
"""
import csv
import glob
import os
import re

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
E2E = os.path.join(ROOT, 'Doc', 'e2e')
RES = os.path.join(E2E, 'results')
LOGS = os.path.join(E2E, 'logs')


def _rows(p):
    if not os.path.exists(p):
        return []
    try:
        with open(p, encoding='utf-8-sig', newline='') as f:
            return list(csv.DictReader(f))
    except Exception:
        return []


def results_dir(mid):
    """화면 smoke·crud 결과 폴더 — 화면 폴더(Doc/e2e/results/<ID>)가 있으면 그것, 없으면 공용 폴더"""
    d = os.path.join(RES, str(mid).upper())
    return d if os.path.isdir(d) else RES


def summary_path(mid):
    """화면 요약 CSV 경로 — 화면 폴더 요약이 있으면 그것, 없으면 공용 색인"""
    p = os.path.join(RES, str(mid).upper(), '_summary.csv')
    return p if os.path.exists(p) else os.path.join(RES, '_summary.csv')


def summary_rows(mid, kind=None):
    """화면 하나의 E2E 요약 행(menu_id 일치 · kind 지정 시 그 종류만)"""
    m = str(mid).upper()
    rs = [r for r in _rows(summary_path(m)) if (r.get('menu_id') or '').upper() == m]
    return [r for r in rs if r.get('kind') == kind] if kind else rs


def index_rows():
    """공용 색인 전체(화면 전체 목록이 필요할 때)"""
    return _rows(os.path.join(RES, '_summary.csv'))


def _first_line(p):
    try:
        with open(p, encoding='utf-8', errors='ignore') as f:
            return f.readline()
    except Exception:
        return ''


def run_logs(mid, kind='smoke'):
    """이 화면의 run-e2e 실행 로그(최신 먼저) — 화면 폴더 logs/<ID>/ + 공용 logs/ 중 첫 줄 '==== … run-e2e <종류> … <ID>' 인 것
    kind = 'smoke'|'crud'|'auth'|'authcrud'|'all'|None(전부)"""
    m = str(mid).upper()
    pat = f'run_*_{kind}.log' if kind else 'run_*.log'
    out = list(glob.glob(os.path.join(LOGS, m, pat)))
    for f in glob.glob(os.path.join(LOGS, pat)):
        if re.search(rf'run-e2e\b.*\b{re.escape(m)}\b', _first_line(f), re.I):
            out.append(f)
    return sorted(out, key=lambda f: os.path.getmtime(f) if os.path.exists(f) else 0, reverse=True)


def shots_dirs(mid):
    """스모크 캡처 폴더 후보(먼저 찾은 파일 우선) — 화면 폴더 shots → 공용 shots"""
    m = str(mid).upper()
    return [d for d in (os.path.join(RES, m, 'shots'), os.path.join(RES, 'shots')) if os.path.isdir(d)]



def golden_path(mid):
    """골든 요약 CSV — 화면 폴더 Doc/golden/<ID>/_summary.csv(2026-11-06 golden.py 화면별 정본)가 있으면 그것, 없으면 공용 색인 Doc/golden/_summary.csv"""
    g = os.path.join(ROOT, 'Doc', 'golden')
    f = os.path.join(g, str(mid).upper(), '_summary.csv')
    return f if os.path.exists(f) else os.path.join(g, '_summary.csv')

if __name__ == '__main__':
    import sys
    for a in sys.argv[1:] or []:
        print(a, '| 결과', results_dir(a), '| 요약', summary_path(a), f'({len(summary_rows(a))}행)', '| 로그', (run_logs(a) or ['-'])[0], '| 캡처', shots_dirs(a), '| 골든', golden_path(a))
