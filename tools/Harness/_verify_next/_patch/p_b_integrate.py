# -*- coding: utf-8 -*-
"""구간 B 연결 — 기준 원장(criteria_build.py)을 CheckList 흐름에 넣는다
   run_verify.py      원장 생성(ledger.py) 바로 뒤에 기준 정리(AI 종류 criteria · 입력이 같으면 호출 없음)
   judge.py           판정 끝(중복 정리 상속 뒤)에 기준 반영: 대상 아님(기계 확인) = NA · 같은 확인 구성원 = 대표 결과 상속
   dedup_screen.py    기준 원장이 정리한 다른 문서 행(GENERAL·CONFIRMED·DEFECT)은 중복 정리 AI 에 보내지 않는다
   llm_review.py      기준 원장의 같은 확인 구성원은 판정 검토에서 뺀다(대표 행만)
   make_verify_docs.py CheckList '기준' 시트(판단 대기 · 대상 아님 · 룰 결합 · AI 지정 항목 + 사용자의견 열)"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _pt import patch

D = sys.argv[1]
patch(os.path.join(D, 'run_verify.py'), [
    ("    if run([py, os.path.join(HERE, 'ledger.py'), mid, '--asis', asis]):\n        return 6\n",
     "    if run([py, os.path.join(HERE, 'ledger.py'), mid, '--asis', asis]):\n        return 6\n"
     "    # 2026-11-20 구간 B(사용자 지시 '기준을 잘 정리하는 것부터'): AS-IS 파싱·AS-IS 실측·TO-BE 룰을 화면 요소에 묶은 기준 원장(Doc/verify/<ID>/criteria/).\n"
     "    #   다른 문서 행(결함 유형·확정 요구) 정리와 TO-BE 룰 결합은 AI(입력 내용이 같으면 호출 없음) · judge 가 판정 끝에 반영 · 실패해도 체인 계속\n"
     "    llm_step('criteria', [py, os.path.join(HERE, 'criteria_build.py'), mid])\n"),
])
patch(os.path.join(D, 'judge.py'), [
    ("    except Exception as _e:\n        print(f'  [WARN] 중복 정리 상속 적용 실패: {type(_e).__name__} {_e}')\n",
     "    except Exception as _e:\n        print(f'  [WARN] 중복 정리 상속 적용 실패: {type(_e).__name__} {_e}')\n"
     "    # 2026-11-20 구간 B 기준 원장(criteria_build.py · Doc/verify/<ID>/criteria/): 대상 아님(검색 0건 또는 TO-BE 룰 인용 확인) = NA · 같은 확인 구성원 = 대표 결과 상속(미측정 행만)\n"
     "    try:\n"
     "        import criteria_build as _cb; _cn = _cb.apply(mid, rows)\n"
     "        if _cn['na'] or _cn['inherit']: stat['CRITERIA_NA'] = _cn['na']; stat['CRITERIA_INHERIT'] = _cn['inherit']\n"
     "    except Exception as _e:\n"
     "        print(f'  [WARN] 기준 원장 반영 실패: {type(_e).__name__} {_e}')\n"),
])
patch(os.path.join(D, 'dedup_screen.py'), [
    ("    keep = user_rows(mid); out = collections.defaultdict(list)\n    for r in rows:\n        if r['row_id'] in keep or not r.get('rule_id'):\n            continue\n",
     "    keep = user_rows(mid); out = collections.defaultdict(list)\n"
     "    # 2026-11-20 구간 B: 기준 원장이 정리한 다른 문서 행(결함 유형·확정 요구·이 화면 결함)은 여기서 묻지 않는다\n"
     "    crit_done = {x['row_id'] for x in read_csv(os.path.join(vdir(mid), 'criteria', 'row_map.csv')) if x.get('source') in ('GENERAL', 'CONFIRMED', 'DEFECT') and x.get('decision')}\n"
     "    for r in rows:\n        if r['row_id'] in keep or not r.get('rule_id') or r['row_id'] in crit_done:\n            continue\n"),
])
patch(os.path.join(D, 'llm_review.py'), [
    ("    _by = {r['row_id']: r for r in rows}\n",
     "    _by = {r['row_id']: r for r in rows}\n"
     "    # 2026-11-20 구간 B: 기준 원장의 같은 확인 구성원(대표 행이 따로 있음)은 대표만 검토\n"
     "    _crit_mem = {x['row_id']: x.get('crit_id', '') for x in read_csv(P('Doc', 'verify', mid, 'criteria', 'row_map.csv')) if x.get('role') == '구성원'}\n"),
    ("        if why:\n            out.append(blank(r, '검토 제외', why))\n        else:\n            targets.append(r)\n",
     "        if not why and r['row_id'] in _crit_mem:\n            why = f\"기준 원장 같은 확인 구성원({_crit_mem[r['row_id']]} 대표를 검토)\"\n"
     "        if why:\n            out.append(blank(r, '검토 제외', why))\n        else:\n            targets.append(r)\n"),
])
patch(os.path.join(D, 'make_verify_docs.py'), [
    ("    write_sheet(wb, '판정 필요', LH, [lrow(i, r) for i, r in enumerate(_rv, 1)], LW, result_col=RESULT_COL)\n",
     "    write_sheet(wb, '판정 필요', LH, [lrow(i, r) for i, r in enumerate(_rv, 1)], LW, result_col=RESULT_COL)\n"
     "    # 2026-11-20 구간 B '기준' 시트: 기준 원장(Doc/verify/<ID>/criteria/criteria.csv) 중 사람이 볼 항목 = 판단 대기 · 대상 아님 · TO-BE 룰 결합 · AI 가 요소를 정한 항목.\n"
     "    #   사용자의견 열에 '대상 아님' · 'TO-BE RULE' · '오류 아님' · '확정' 을 적으면 다음 기준 정리(criteria_build.py)가 그 항목에 고정한다(AI 보다 우선)\n"
     "    try:\n"
     "        _cr = [x for x in read_csv(P('Doc', 'verify', mid, 'criteria', 'criteria.csv')) if x.get('status') != '확정' or x.get('by') not in ('코드', '')]\n"
     "        _ord = {'판단 대기': 0, '대상 아님': 1, '확정': 2}\n"
     "        _cr.sort(key=lambda x: (_ord.get(x.get('status'), 3), x.get('elem_key', ''), x.get('rule_id', '')))\n"
     "        CH = ['No', '기준 항목', '상태', '요소', '규칙', '확인', '기대', '근거', 'AS-IS 실측', 'TO-BE 룰', '정한 주체', '원장 행 수', '사용자의견']\n"
     "        write_sheet(wb, '기준', CH, [[i, x['crit_id'], x.get('status', ''), x.get('elem_key', ''), x.get('rule_id', ''), x.get('check', ''), x.get('expected', ''), x.get('basis', ''),\n"
     "                                     x.get('src_live', ''), x.get('src_rule', ''), x.get('by', ''), len([y for y in (x.get('rows') or '').split(';') if y]), ''] for i, x in enumerate(_cr, 1)],\n"
     "                    [6, 16, 10, 22, 8, 40, 40, 50, 30, 14, 10, 8, 30])\n"
     "    except Exception as _ex:\n"
     "        print(f'  [WARN] 기준 시트 작성 실패: {_ex}')\n"),
])
