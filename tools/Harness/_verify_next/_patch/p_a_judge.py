# -*- coding: utf-8 -*-
"""구간 A2 — judge.py AI 판정 검토 반입: 판정 대기 미검증 행(검토 때 판정필요로 본 행)과 근거 확인된 NA(대상 없음) 미검증 행도 반입"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pt import patch

D = sys.argv[1]
patch(os.path.join(D, 'judge.py'), [
    ("            _swept = r['result'] == 'ERROR' and '기계 판정 불가 — 수동 검수 대상' in ev0 and v_.get('cur_result') in ('FAIL', '판정필요')   # 바로 위 판정필요 정리가 ERROR 로 바꾼 행(검토 때는 판정필요)\n",
     "            _swept = r['result'] == 'ERROR' and '기계 판정 불가 — 수동 검수 대상' in ev0 and v_.get('cur_result') in ('FAIL', '판정필요')   # 바로 위 판정필요 정리가 ERROR 로 바꾼 행(검토 때는 판정필요)\n"
     "            # 2026-11-20 A2(사용자 승인 결정 1): 판정 대기 미검증(분류표 담당 '판단' — 검토 때 판정필요로 봄)과, 대상 없음 근거(AS-IS 원문·등록 룰)가 확인된 NA 는 미검증 행에도 반입\n"
     "            _swept = _swept or (r['result'] == 'ERROR' and (v_.get('cur_result') == '판정필요' or (v_.get('cur_result') == 'ERROR' and v_.get('verdict') == 'NA')))\n"),
])
