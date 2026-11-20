# -*- coding: utf-8 -*-
"""AS-IS facts variant 판정 단일 원천(2026-11-09 SSP0024·SSP0025 CheckList exit 6 — 검사기 결함 T172).

AsisFacts Pack.cs Variants() 의 분류(tools/AsisFacts/src/Pack.cs:291-312):
  current = 화면 전용 csproj 파일 · legacy = 전용 csproj 에 같은 이름이 있는 다른 UIL 사본(구버전)
  shared  = 전용 csproj 가 있는 화면에서 그 밖(도메인 공용 프로젝트)의 파일 — 주로 팝업
  only    = 화면 전용 csproj 가 없는 화면(공용 프로젝트 GSCM.SSP.Plan.UIL 등)의 모든 파일 — 그 화면의 유일한 현행 소스
소비자가 'current' 정확 일치로 읽으면 only 화면(2026-11-09 실측 445 중 180 · SSP 전 화면)에서 파일 0건 → exit 6 또는 AS-IS 사실 0건(조용한 누락).

  is_cur(row)        = 현행(legacy 제외 — current·shared·only·빈값)                 ← 종전 ('current','shared') 자리
  is_main(row, sdir) = 화면 본체 파일의 행                                           ← 종전 == 'current' 자리
     화면 본체(main_files) = ① current 가 있으면 current
                          ② 없으면 only 중 팝업이 아닌 파일('\\Popup\\' 폴더 또는 파일명에 Popup — Pack 의 current/shared 구분을 경로로 재현)
                          ③ 그것도 없으면(화면 자체가 팝업 — 실측 56 화면: FPC 팝업류·SSP0300·SSP0301 등) only 전부
     sdir(Doc/asisfacts/screens/<ID>) 를 주면 그 화면 files.csv 기준 · 없으면 행 단위(②까지, ③ 폴백 없음)
  한계: ③ 화면에 팝업이 여러 개면 서로 구분하지 못한다(Pack 이 분류 근거를 남기지 않음).
"""
import csv
import os
import re

POPUP_RX = re.compile(r'(^|[\\/])popups?[\\/]|popup[^\\/]*$', re.I)
_CACHE = {}


def _v(row):
    return (((row or {}).get('variant') or 'current').strip()) or 'current'


def is_cur(row):
    return _v(row) != 'legacy'


def main_files(sdir):
    """화면 본체 파일 집합(files.csv 기준 · 없으면 None)"""
    key = os.path.normcase(os.path.abspath(sdir))
    if key in _CACHE:
        return _CACHE[key]
    p = os.path.join(sdir, 'files.csv')
    if not os.path.exists(p):
        _CACHE[key] = None
        return None
    with open(p, encoding='utf-8-sig', newline='') as fh:
        rows = list(csv.DictReader(fh))
    cur = {r['file'] for r in rows if _v(r) == 'current'}
    if not cur:
        only = [r['file'] for r in rows if _v(r) == 'only']
        cur = {f for f in only if not POPUP_RX.search(f)} or set(only)
    _CACHE[key] = cur
    return cur


def is_main(row, sdir=None):
    v = _v(row)
    if v in ('legacy', 'shared'):
        return False
    if sdir:
        mf = main_files(sdir)
        if mf is not None:
            return v == 'current' or str((row or {}).get('file') or '') in mf
    if v == 'current':
        return True
    return v == 'only' and not POPUP_RX.search(str((row or {}).get('file') or ''))
