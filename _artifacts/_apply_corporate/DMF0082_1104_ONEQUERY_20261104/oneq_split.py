# -*- coding: utf-8 -*-
"""[E20261104-DMF0082ONEQUERY] 룩업 CTE → GTT 적재 분리 (2026-11-04 17:3x 결정)

배경: WS/MEA/LD 를 CTE 로 두면 옵티마이저가 SYS_TEMP 로 물질화하고 통계가 없어 MEA 를 3,118행(TITLESET_USER 기준)으로 추정,
      MERGE JOIN CARTESIAN → PK 인덱스 행별 NL 로 빠져 S2 가 30분+ (SQL_ID 38w5z8smdhxva · 계획 1173473358 · 17:14~ 실측).
      원문은 같은 룩업을 GTT(10-09 SHARED 고정 통계)로 읽어 안전했다. 룩업은 GTT 적재(소형 INSERT)로 되돌리고 큰 적재만 CTE 로 둔다.
"""
import re

GTT = {
    'WS':  ('SCM_MGR.GT_DMF0082_T_WS_FCST', 'FCST_TYPE'),
    'MEA': ('SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE', 'MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID'),
    'LD':  ('SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST', 'DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY'),
    'VER': ('SCM_MGR.GT_DMF0082_T_VERSION', 'VERSION_NO, VERSION_NO_W, NOW_YYYYMMDD, SP_VERSION_NO'),
    'LDC': ('SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C', 'DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, VERSION_NO, CREATE_DATE, LAST_UPDATED_BY'),
    'LPC': ('SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C', 'DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY'),
}
LOOKUP_ORDER = ['WS', 'MEA', 'LD', 'VER', 'LDC', 'LPC']
MEA_PARTS = ['MEA1', 'MEA2', 'MEA3']


def _ctes(s):
    """S2 텍스트 → (prefix(INSERT 헤더), [(name, body)], tail(최종 SELECT))"""
    w = s.index('    WITH ')
    prefix, rest = s[:w], s[w + 9:]            # '    WITH ' 제거
    bounds = [(m.start(), m.end(), m.group(1)) for m in re.finditer(r'(?:^|\n    \), )(\w+) AS \(', rest)]
    assert bounds and bounds[0][0] == 0
    ctes = []
    for i, (st, en, name) in enumerate(bounds):
        nxt = bounds[i + 1][0] if i + 1 < len(bounds) else None
        body = rest[en:nxt] if nxt is not None else None
        if body is None:
            last = rest[en:]
            k = last.rindex('\n    )')
            body, tail = last[:k], last[k + 6:]
        ctes.append([name, body])
    return prefix, ctes, tail


def _refs(text):
    """FROM/JOIN 참조만 GTT 이름으로 (별칭 'LD.' 등은 불변 · LDC8 는 CTE 유지)"""
    for n, (g, _) in GTT.items():
        # 별칭 없이 쓰인 참조(예: 'LEFT JOIN LD\n  ON LD.x')는 CTE 이름이 곧 별칭이므로 GTT 뒤에 같은 별칭을 붙인다
        text = re.sub(rf'\b(JOIN|FROM)\s+{n}\b(?![\.\d])(?=\s*(?:\n|ON\b|WHERE\b|\)))', rf'\1 {g} {n}', text)
        text = re.sub(rf'\b(JOIN|FROM)\s+{n}\b(?![\.\d])(?!\s+{n}\b)', rf'\1 {g}', text)
    text = re.sub(r'\(SELECT \* FROM ' + re.escape(GTT['VER'][0]) + r' WHERE VERSION_NO', '(SELECT * FROM ' + GTT['VER'][0] + ' WHERE VERSION_NO', text)
    return text


def split_s2(s):
    """returns (loads_plsql, insert_sql)"""
    prefix, ctes, tail = _ctes(s)
    names = [n for n, _ in ctes]
    loads, keep = [], []
    mea_parts = {}
    for name, body in ctes:
        if name in MEA_PARTS:
            mea_parts[name] = body
        elif name == 'MEA':
            g, cols = GTT['MEA']
            w = ', '.join(f"{p} AS ({mea_parts[p]}\n    )" for p in MEA_PARTS)
            loads.append(f"    DELETE FROM {g};\n    INSERT INTO {g} ({cols})\n    WITH {w}\n{body.strip()};\n")
        elif name in ('LDC', 'LPC'):
            # [E20261105-DMF0082ONEQUERY-VERLOOP] 11-05 04:25 실측: T_VERSION(1행) × TEMP_SITE_ITEM(40,204행) MERGE JOIN CARTESIAN 을
            # 옵티마이저가 1행으로 추정(GTT 통계 없음·동적 샘플링) → IDX_DM_PLN_MKT_FCST_C_N3 행별 NL 40,204회 · LIO 64.2M · 457s (원문 L1355/L1376 도 동일 계획).
            # T_VERSION 조인을 버전별 PL/SQL 루프 + 바인드 등가조건으로 바꿔 카티션 자체를 제거한다(힌트 없음 · #129 ②).
            # 등가: 원문은 V 의 다른 열을 쓰지 않고 GROUP BY 에 VERSION_NO 가 있으므로(LPC 는 버전 미구분 8키 집계이나 원문도 V 조인만) 버전별 적재 합집합 = 원문 적재.
            #       T_VERSION 중복 VERSION_NO 는 DISTINCT 로 1회(원문은 중복 조인 후 MAX 집계 → 동일) · NULL VERSION_NO 는 원문도 조인 불일치 → 제외.
            g, cols = GTT[name]
            body = _refs(body).strip()
            n_join = len(re.findall(r'INNER JOIN SCM_MGR\.GT_DMF0082_T_VERSION V ON V\.VERSION_NO = A\.VERSION_NO', body))
            assert n_join == 2, (name, n_join)
            body = re.sub(r'\n\s*INNER JOIN SCM_MGR\.GT_DMF0082_T_VERSION V ON V\.VERSION_NO = A\.VERSION_NO', '', body)
            body, n_div = re.subn(r'(AND    A\.DIVISION_ID = p_division_id)', r'\1\n        AND    A.VERSION_NO = VL.VERSION_NO', body)
            assert n_div == 2, (name, n_div)
            assert 'V.' not in body and 'T_VERSION' not in body, name
            loads.append(f"    DELETE FROM {g};\n"
                         f"    V_VERLOOP_CNT := 0;\n"
                         f"    FOR VL IN (SELECT DISTINCT VERSION_NO FROM {GTT['VER'][0]} WHERE VERSION_NO IS NOT NULL ORDER BY VERSION_NO) LOOP  "
                         f"-- [E20261105-DMF0082ONEQUERY-VERLOOP] T_VERSION 조인 → 버전별 바인드(카티션 1행 추정·NL 457s 제거) · 순수 Current 는 0회\n"
                         f"    V_VERLOOP_CNT := V_VERLOOP_CNT + 1;\n"
                         f"    INSERT INTO {g} ({cols})\n{body};\n"
                         f"    END LOOP;\n")
            if name == 'LPC':
                # LPC 는 원문이 VERSION_NO 없이 8키 집계(이상⑤: 버전 간 MAX 로 1행). 버전별 적재는 버전 수만큼 행이 생기므로
                # 버전이 2개 이상일 때만 8키 재집계(MAX 는 결합법칙 → 버전별 MAX 의 MAX = 원문 전체 MAX · GROUP BY 의 NULL 키 동치도 원문과 같음).
                k8 = 'DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE'
                loads.append(f"    IF V_VERLOOP_CNT > 1 THEN  -- [E20261105-DMF0082ONEQUERY-VERLOOP] 복수 버전 → 원문(8키 버전 미구분 집계 · 이상⑤) 과 같게 재집계\n"
                             f"        MERGE INTO {g} T\n"
                             f"        USING (SELECT MIN(ROWID) AS RID, MAX(CREATE_DATE) AS CD, MAX(LAST_UPDATED_BY) AS LU\n"
                             f"               FROM   {g}\n"
                             f"               GROUP BY {k8}\n"
                             f"               HAVING COUNT(*) > 1) S\n"
                             f"        ON (T.ROWID = S.RID)\n"
                             f"        WHEN MATCHED THEN UPDATE SET T.CREATE_DATE = S.CD, T.LAST_UPDATED_BY = S.LU;\n"
                             f"        DELETE FROM {g} T\n"
                             f"        WHERE  T.ROWID NOT IN (SELECT MIN(ROWID) FROM {g} GROUP BY {k8});\n"
                             f"    END IF;\n")
        elif name in GTT:
            g, cols = GTT[name]
            loads.append(f"    DELETE FROM {g};\n    INSERT INTO {g} ({cols})\n{_refs(body).strip()};\n")
        else:
            keep.append((name, _refs(body)))
    assert keep and 'BASE' in [n for n, _ in keep], names      # 2-B 는 LDC8 가 BASE 앞에 남는다
    chain = ', '.join(f"{n} AS ({b}\n    )" for n, b in keep)
    insert = prefix + '    WITH ' + chain + tail
    return ''.join(loads), insert


if __name__ == '__main__':
    import sys
    sys.path.insert(0, '.')
    import oneq_blocks as B, oneq_2b as B2
    for tag, f in (('2A', B.s2_fcst_n_price_current), ('2B', B2.s2_fcst_n_price_all)):
        lo, ins = split_s2(f())
        print(tag, 'loads', lo.count('INSERT INTO'), 'chars', len(lo), '| insert chars', len(ins), '| CTEs', re.findall(r'(?:WITH|\), )(\w+) AS \(', ins))
