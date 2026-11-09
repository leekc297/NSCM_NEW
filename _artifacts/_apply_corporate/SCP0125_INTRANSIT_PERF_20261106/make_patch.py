# PKG_SCP0125 BODY 수정본 생성 — 착수 시 새로 조회한 기준본(PKG_SCP0125_BODY.ASIS.sql) 위 외과 치환(#152 §3.2) → PKG_SCP0125_BODY.TOBE.sql
import os, re
D = os.path.dirname(os.path.abspath(__file__))
base = open(os.path.join(D, 'PKG_SCP0125_BODY.ASIS.sql'), encoding='utf-8').read()
new_sel = open(os.path.join(D, 'new_select_hint.sql'), encoding='utf-8').read().replace(' /* HINTV1 */', '')

OLD = """        /* 해상재고 뷰를 사업부 · 기준일로 먼저 내려받는다 - 조인과 함께 읽으면 뷰 조건 밀어넣기 계획으로 수십 분이 걸린다 */
        INSERT INTO GT_0125_INTRANSIT_V
                    (
                      DIVISION_ID
                    , RESULT_TYPE
                    , ITEM_ID
                    , TO_SCM_SITE_ID
                    , FROM_SCM_SITE_ID
                    , FINAL_INCOTERMS
                    , ETA_DATE
                    , DELIVERY_QTY
                    , PROJECT_CODE
                    )
        SELECT DIVISION_ID
             , RESULT_TYPE
             , ITEM_ID
             , TO_SCM_SITE_ID
             , FROM_SCM_SITE_ID
             , FINAL_INCOTERMS
             , ETA_DATE
             , DELIVERY_QTY
             , PROJECT_CODE
          FROM SCM_DNM_INTRANSIT_V
         WHERE RESULT_TYPE IN ('I', 'C')
           AND TO_SCM_SITE_ID IS NOT NULL
           AND DIVISION_ID = P_DIVISION_ID
           AND RESULT_DATE = V_CUTOFF_DAY;"""

# 바인드 → PKG 변수 · 들여쓰기 8칸
sel = new_sel.replace(':P_DIVISION_ID', 'P_DIVISION_ID').replace(':V_CUTOFF_DAY', 'V_CUTOFF_DAY')
sel = '\n'.join(('        ' + l) if l.strip() else l for l in sel.split('\n'))
NEW = """        /* 해상재고 뷰를 사업부 · 기준일로 먼저 내려받는다 - 조인과 함께 읽으면 뷰 조건 밀어넣기 계획으로 수십 분이 걸린다 */
        /* 2026.11.06 (START) 해상재고 적재 속도 — 공용 뷰 SCM_DNM_INTRANSIT_V 를 직접 읽지 않고 I · C 갈래만 같은 원문으로 펼쳐 조건을 갈래 안에 넣는다
           뷰는 I · C · V(VMI) 세 갈래를 UNION 하는데 V 갈래의 ROW_NUMBER() OVER (PARTITION BY 'V' ...) 때문에 사업부 · 기준일 조건이
           뷰 안으로 들어가지 못해 매 호출 전 사업부 · 전 일자를 만든 뒤 거른다(사내 실측 1.3~2.5초).
           여기는 RESULT_TYPE IN ('I', 'C') 만 쓰므로 V 갈래는 결과에 들 수도, UNION 중복 제거로 I · C 행과 겹칠 수도 없다(RESULT_TYPE 이 다름).
           갈래 원문 · UNION(전 열 중복 제거) · VMI LT 가산 · WarrantyPlant 제외 · 'W' 출발 사이트 제외는 뷰(LAST_DDL 2026-10-09 13:38:41)와 같다.
           NO_PUSH_PRED 힌트: 사업부 · 기준일은 변수라 처음 실행 값으로 계획이 굳는다 — 작은 사업부로 굳으면 리드타임 뷰(SCP_MST_BOD_N_V)를
           행마다 다시 계산하는 중첩 반복 계획이 되어 큰 사업부가 7~9초(사내 실측 2026-11-06). 밀어넣기를 막아 어떤 값이든 해시 조인으로 둔다.
           뷰를 바꾸면 이 문장도 같이 맞춘다. 대조: _artifacts/_apply_corporate/SCP0125_INTRANSIT_PERF_20261106/cmp_result_hint.txt */
        INSERT INTO GT_0125_INTRANSIT_V
                    (
                      DIVISION_ID
                    , RESULT_TYPE
                    , ITEM_ID
                    , TO_SCM_SITE_ID
                    , FROM_SCM_SITE_ID
                    , FINAL_INCOTERMS
                    , ETA_DATE
                    , DELIVERY_QTY
                    , PROJECT_CODE
                    )
""" + sel + """;
        /* 2026.11.06 (END) 해상재고 적재 속도 */"""

assert base.count(OLD) == 1, f'대상 매칭 {base.count(OLD)} != 1 — 원문이 바뀌었거나 이미 반영됨'
tobe = base.replace(OLD, NEW)
open(os.path.join(D, 'PKG_SCP0125_BODY.TOBE.sql'), 'w', encoding='utf-8').write(tobe)
print('ok', len(base), '→', len(tobe), '자')
