import json, sys
base = sys.argv[1]
rows = [json.loads(l) for l in open(base + '/r1b.jsonl', encoding='utf-8')]

R1 = ('1', '계산 방어식 — 0/NULL/음수/범위밖 값을 1·0·기본값·상하한으로 대체해 산식만 보호, 저장 차단·대상행 제외 없음')
R1F = ('1', '계산 방어식 — 분모 0 방지용 계산 입력 필터(산식 원천 서브쿼리/UPDATE 원천에서 0·NULL 값 배제), 저장 차단·검증 목적 행 제외 아님')
R1Y = ('1', '계산 방어식 — 수율 0·NULL·1초과(또는 <=0) → 1 보정(0 나눗셈·과다수량 방지), 저장 차단·행 제외 없음')
R1T = ('1', '계산 방어식 — 계산 T/T 0(또는 원천 미존재) 시 is_use=N/use_yn=N 로 산출, 행은 그대로 생성(제외·차단 없음)')
R1D = ('1', '계산 방어식 — DIO/재고/부하율 산식의 0 나눗셈·음수·상한(365) 보정, 저장 차단·검증 목적 행 제외 없음')
R4F = ('4', '일반 범위·계산 로직 분기 — Frozen 적용 옵션(lookup SCP_FROZEN_APPLY_YN) 값 기본화/분기로 처리 경로 선택, 입력 데이터 검증 아님')
R4B = ('4', '일반 범위 — 엔진 BOM 전개 대상 업무 범위 선택(활성·유효기간·대치BOM SCP 지정/1순위), 검증 목적 제외 아님')

M = {}
def s(idx, dec, rule_reason=None, new_class='', reason=None):
    M[idx] = (dec, rule_reason, new_class, reason)

yield_rows = [13,16,18,19,20,21,22,25,27,28,29,30,32,34,49,50,51,52,54,55,56,57,58,59,60,61,62,69,71,72,74,96,97,98,100,101,102,103,106,121,124,125,133,134,136,138,139,140]
for i in yield_rows: s(i, 'drop', R1Y)
for i in [26,31,33,63,66,68,70,73,75,105,117,118]: s(i, 'drop', R1T)
for i in [3,17,43,53,65,84,99,64,67]: s(i, 'drop', R1F)
for i in [130,131,132,135,137,141,143,144,145,146,147,148,149,150,151,152,153,154,155,156,161,162,164,165,166,169,172,173,176,177,178,179,181]: s(i, 'drop', R1D)
for i in [142,1,2,4,5,6,14,15,23,24,35,38,39,41,42,44,45,46,47,48,76,78,81,85,86,87,88,89,90,104,109,110,113,114,115,116,119,120,122,123,126,127,129,157,158,159,160,163,170,171,174,175,180]: s(i, 'drop', R1)
for i in [0,7,11,36,79,80,82,83,91,92,94,95,111,93]: s(i, 'drop', R4F)
for i in [37,77,112]: s(i, 'drop', R4B)
s(12, 'drop', ('4', '계산 로직 분기 — Material PSI/Capa 미사용으로 R 타입 child 소요율을 1 로 고정하는 엔진 산식 규칙, 검증 아님'))
s(40, 'drop', ('4', '계산 로직 — 기간이 다른 동일 Item BOD 를 MIN 집계로 1건 적재(엔진 테이블 키 구성), 입력 중복을 오류로 보고 제외하는 검증 아님'))
s(107, 'drop', ('4', '계산 로직 분기 — Tact Time Exception 분할 대상 선정(미사용 라인·소형 CAPA 분리 공정 NOT EXISTS) 및 예외 수율 1 보정, 검증 아님'))
s(108, 'drop', ('4', '계산 로직 — 예외 분할 원행 NOT EXISTS 제외 후 UNION ALL 적재(분할행 대체), T/T 0 is_use=N, 수율 NULL→1; 검증 목적 제외 아님'))
s(128, 'drop', ('4', '계산 로직 — UNPEGGING 수량 = 완료수량 - Pegging 합 재계산, 검증 아님'))
s(167, 'drop', ('4', '값 조회용 일반 조인 — BOD 미지정(-) SEMI_SHIP_PLAN 행에 BOD 마스터 조회값(BOD_ID·L/T) 채움, 검증 아님'))
s(168, 'drop', ('4', '계산 로직 분기 — PR 플랜 생산계획 합 0 모델에 A_SET 표식(저장 시 1 처리용), 차단·제외 없음'))
s(182, 'drop', ('4', '계산 로직 분기 — PR 플랜 생산계획 합 0 모델에 A_SET 표식(저장 시 1 처리용), 차단·제외 없음'))
s(184, 'drop', ('4', '계산 로직 — 확정구간 마지막 일자 = MAX(요청 최대일, 오늘+9) 산출, 행 제외·저장 차단 없음'))
s(190, 'drop', ('2', '화면 표시 설정 기본값 — 사용자 컬럼 설정이 없을 때만 기본 컬럼(default_flag=Y) 자동 생성'))
s(191, 'drop', ('2', '화면 표시 설정 기본값 — 사용자 Measure 설정이 없을 때만 기본 Measure 자동 생성'))
s(8, 'keep', reason='Ship Frozen 경계(yyyymmdd < plan+ship_frozen)로 SP 가 SSP 확정건을 Fixed Plan 적재에서 직접 제외 + 엔진 BOD INNER JOIN — 기준 3 단서(SP 가 경계로 행 제외)에 해당, C/RANGE 유지')
s(9, 'keep', reason='SCP 확정 출하 Fixed Plan 적재 시 f.qty > 0 로 수량 0 이하 행 제외(적재 대상 행 제외 → C). TE+FP전용 옵션 분기 부분은 기준 4 성격이나 동일 WHERE 로 묶여 행 단위 유지')
s(10, 'keep', reason='be.bod_id IS NOT NULL(LEFT JOIN+NOT NULL) 로 엔진 BOD 미존재 확정건을 Fixed Plan 적재 대상에서 제외 + Frozen 경계 제외 — 존재 검증형 C 유지')
s(183, 'keep', reason='FN_GET_SSP_ANL_SHIP_FROZEN 경계(오늘~오늘+N일) 및 Frozen<=0 사이트를 SP 가 자동확정 대상에서 직접 제외 — 기준 3 단서(경계로 행 제외) C/RANGE 유지')
for i in [185,186,187,188]:
    s(i, 'keep', reason='Ship Req 원장에서 확정구간 이후 수량 0 행을 DELETE(대상 테이블 행 제거) — 값 판정으로 행 제외하는 C/QTY 유지(보존구간 조건은 업무 범위)')
s(189, 'keep', reason='Ship Target 적재 시 동일 Plant 이동(FROM=TO)·음수 수량(P.QTY>=0) 행 제외 — 정합/수량 판정 행 제외 C 유지')
s(192, 'keep', reason='사용자가 선택한 컬럼을 titleset_user 에 저장 시 NOT EXISTS 로 기존 등록 컬럼 중복 INSERT 제외 — 기본값 생성(기준 2)이 아닌 저장 중복 제외 C/DUP 유지')
s(193, 'keep', reason='SCP0104~0108 사용자 컬럼 저장 시 폭 0 컬럼·기존 등록 컬럼 INSERT 제외 — 저장 중복/대상 제외 C/DUP 유지(기준 2 기본값 생성 아님)')

missing = [i for i in range(len(rows)) if i not in M]
extra = [i for i in M if i >= len(rows)]
if missing or extra:
    print('MISSING', missing, 'EXTRA', extra); sys.exit(1)

out = []
for i, d in enumerate(rows):
    dec, rr, nc, reason = M[i]
    if dec == 'drop':
        rule, why = rr
        reason = f"[기준{rule}] {why} | 원행: {d['class']}/{d['check_type']} {d['desc_ko'][:90]}"
    else:
        rule = ''
    out.append(json.dumps({"_batch": d['_batch'], "unit": d['unit'], "line_from": d['line_from'], "decision": dec, "rule": rule, "new_class": nc, "reason": reason}, ensure_ascii=False))
open(base + '/r1b_out.jsonl', 'w', encoding='utf-8', newline='\n').write('\n'.join(out) + '\n')
from collections import Counter
c = Counter((json.loads(l)['decision'], json.loads(l)['rule']) for l in out)
print(len(rows), len(out), c)
