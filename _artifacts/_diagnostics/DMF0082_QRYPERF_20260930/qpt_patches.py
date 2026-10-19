# -*- coding: utf-8 -*-
"""PKG_DMF0082_QPT 실험 패치 모음. 각 함수: (proc_text) -> (patched_text, 적용건수). 건수 assert 내장."""
import re

FP_FROM = "FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A\n"


def _hint_select_before(proc, from_anchor, hint, expect):
    """from_anchor 가 나오는 각 위치에서 거꾸로 올라가 가장 가까운 문장-최상위 'SELECT' 줄에 힌트를 붙인다."""
    out, pos, n = proc, 0, 0
    while True:
        k = out.find(from_anchor, pos)
        if k < 0:
            break
        # 거꾸로 가장 가까운 줄머리 SELECT (공백 뒤 SELECT) — 사이에 다른 SELECT 가 없어야 한다(select-list 에 서브쿼리 없음 전제 검증)
        seg = out[:k]
        m = list(re.finditer(r"(?m)^(\s*)SELECT\b", seg))
        assert m, "SELECT 미발견"
        s = m[-1]
        between = out[s.end():k]
        assert "SELECT" not in between.upper(), f"select-list 에 중첩 SELECT 존재 — 수동 확인 필요 @ {s.start()}"
        assert "/*+" not in out[s.end():s.end() + 5], "이미 힌트 존재"
        out = out[:s.end()] + " " + hint + out[s.end():]
        pos = k + len(hint) + 1 + len(from_anchor)
        n += 1
    assert n == expect, f"적용 {n} != 기대 {expect}"
    return out, n


def idx82(proc):
    """[실험] SCM_MST_FUTURE_PRICE 계획구간 읽기 2곳(L1243 LAST_DATA_SETUP_PRICE, L1671 판가 INSERT) 에 IDX02 지정.
    둘 다 술어 = DIVISION_ID=:p AND YYYYMMDD BETWEEN — IDX02(DIVISION_ID,YYYYMMDD,ITEM_ID,SCM_SITE_ID,PROJECT_CODE) 선두 일치."""
    return _hint_select_before(proc, FP_FROM, "/*+ INDEX(A IDX02_SCM_MST_FUTURE_PRICE) */", 2)


def _rep1(proc, old, new):
    c = proc.count(old)
    assert c == 1, f"앵커 {c}건 (1 기대): {old[:80]!r}"
    return proc.replace(old, new)


def vmi82fold(proc):
    """[실험] div82 후행 UPDATE 2건(L4155 VMI_STD_DIO 상관 스칼라 서브쿼리 / L4165 EDIT_FLAG='N' 전행)을
    MF_SP INSERT 시점으로 흡수 (hook #129 1순위 — SET 절 스칼라 서브쿼리 → 선집계 LEFT JOIN).
    등가 근거: ① UPDATE 대상 = MF_SP 전행이고 MF_SP 행 추가는 이 INSERT 1곳뿐(이후 MERGE 는 ATTR1/CELL_PROD 만 갱신)
              ② 상관 MAX(...) WHERE DIVISION_ID='82' AND SCM_SITE_ID=T.SCM_SITE_ID ≡ SCM_SITE_ID 별 MAX 선집계 LEFT JOIN
                 (미매칭·T.SCM_SITE_ID NULL → NULL 동일) ③ SCM_SITE_ID 는 INSERT GROUP BY 키라 그룹 내 VD 값 단일 → MAX 무손실
              ④ EDIT_FLAG: 82 는 UPDATE 로 무조건 'N' → CASE 첫 분기 'N' 과 동일 ⑤ GT 컬럼 DEFAULT 없음(실측) → 비82 NULL 동일"""
    n = 0
    proc = _rep1(proc, "    , NEW_FLAG, AS_YN)  --[E20260812-PERF] 전행 UPDATE 2회",
                 "    , NEW_FLAG, AS_YN, VMI_STD_DIO)  --[QPT-VMI82FOLD] VMI_STD_DIO INSERT 흡수 / --[E20260812-PERF] 전행 UPDATE 2회"); n += 1
    proc = _rep1(proc, "         , CASE WHEN V_GROUP_ID = 'ADMIN' THEN 'Y'\n                WHEN EXISTS (\n                    SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE MA",
                 "         , CASE WHEN p_division_id = '82' THEN 'N'  --[QPT-VMI82FOLD] 구 후행 UPDATE EDIT_FLAG='N'(82 조회전용) 흡수\n"
                 "                WHEN V_GROUP_ID = 'ADMIN' THEN 'Y'\n                WHEN EXISTS (\n                    SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE MA"); n += 1
    proc = _rep1(proc, "                    THEN 'Y' ELSE 'N' END) AS AS_YN\n    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F\n",
                 "                    THEN 'Y' ELSE 'N' END) AS AS_YN\n         , MAX(VD.VMI_STD_DIO) AS VMI_STD_DIO  --[QPT-VMI82FOLD] 82 외 = NULL(조인 미성립)\n"
                 "    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F\n"); n += 1
    proc = _rep1(proc, "          AND PVT.INCOTERMS   = F.INCOTERMS\n    GROUP BY F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID",
                 "          AND PVT.INCOTERMS   = F.INCOTERMS\n"
                 "    LEFT JOIN ( --[QPT-VMI82FOLD] 구 L4155 상관 스칼라 서브쿼리 → SCM_SITE_ID 별 선집계 (1회)\n"
                 "        SELECT S.SCM_SITE_ID, MAX(S.VMI_YN || '^' || NVL(TO_CHAR(S.ATTRIBUTE5),'')) AS VMI_STD_DIO\n"
                 "        FROM   SCM_MGR.SCM_MST_SITE S\n"
                 "        WHERE  S.DIVISION_ID = '82'\n"
                 "        GROUP BY S.SCM_SITE_ID\n"
                 "    ) VD ON  VD.SCM_SITE_ID = F.SCM_SITE_ID\n"
                 "         AND p_division_id  = '82'\n"
                 "    GROUP BY F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID"); n += 1
    old_upd = re.search(r"        UPDATE SCM_MGR\.GT_DMF0082_MF_SP T\n        SET    T\.VMI_STD_DIO = \(\n.*?AND    A\.SCM_SITE_ID = T\.SCM_SITE_ID\);\n", proc, re.S)
    assert old_upd and proc.count(old_upd.group(0)) == 1
    proc = proc.replace(old_upd.group(0), "        NULL;  --[QPT-VMI82FOLD] VMI_STD_DIO 후행 UPDATE → MF_SP INSERT 흡수\n"); n += 1
    proc = _rep1(proc, "        UPDATE SCM_MGR.GT_DMF0082_MF_SP SET EDIT_FLAG = 'N';\n",
                 "        NULL;  --[QPT-VMI82FOLD] EDIT_FLAG='N' 전행 UPDATE → MF_SP INSERT CASE 흡수\n"); n += 1
    return proc, n


def dedupchk(proc):
    """[실험] L3462 중복 제거 안전망: 동일 60컬럼 키 중복이 **있을 때만** 기존 ROW_NUMBER DELETE 실행.
    판정 = 같은 컬럼 목록 GROUP BY HAVING COUNT(*)>1 (GROUP BY·PARTITION BY 모두 NULL 을 같은 값으로 묶음 → 판정 등가).
    중복 0 이면 원 DELETE 도 0행 → 결과 동일. 중복 존재 시 원문 그대로 실행."""
    m = re.search(r"(        DELETE FROM SCM_MGR\.GT_DMF0082_TEMP_FCST_N_PRICE\n         WHERE ROWID IN \(SELECT RID\n.*?"
                  r"PARTITION BY (.*?)\n\s*ORDER BY QTY DESC NULLS LAST, ROWID\) AS RN\n.*?WHERE RN > 1\);\n)", proc, re.S)
    assert m and proc.count(m.group(1)) == 1
    cols = m.group(2).strip()
    new = ("        --[QPT-DEDUPCHK] 중복 존재 시에만 안전망 DELETE (0행 삭제에 전량 윈도정렬 비용 제거)\n"
           "        SELECT COUNT(*) INTO V_QPT_DUP_CNT FROM (\n"
           "            SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE\n"
           f"            GROUP BY {cols}\n"
           "            HAVING COUNT(*) > 1) WHERE ROWNUM = 1;\n"
           "        IF V_QPT_DUP_CNT > 0 THEN\n" + m.group(1) + "        END IF;\n")
    proc = proc.replace(m.group(1), new)
    proc = _rep1(proc, "    V_LIMIT_CNT         NUMBER := 0;",
                 "    V_LIMIT_CNT         NUMBER := 0;\n"
                 "    V_QPT_DUP_CNT       NUMBER := 0;  --[QPT-DEDUPCHK] 전용 (타 변수 재사용 금지)")
    return proc, 1


def nostats(proc):
    """[실험] 활성 DBMS_STATS.GATHER_TABLE_STATS 호출을 NULL; 로 치환 (주석 처리분은 이미 비활성)."""
    pat = re.compile(r"(?m)^(\s*)(DBMS_STATS\.GATHER_TABLE_STATS\([^;]*\);)")
    n = len(pat.findall(proc))
    out = pat.sub(lambda m: m.group(1) + "NULL; --[QPT-NOSTATS] " + m.group(2).replace("\n", " "), proc)
    return out, n
