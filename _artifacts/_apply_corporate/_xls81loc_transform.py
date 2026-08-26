# -*- coding: utf-8 -*-
"""[E20260819-XLS81LOC] DMF0082 Excel Form/Upload = Division 81 계열 전용 + measure LOC 한정.
   입력: PKG_DMF0082_BODY_PRE_XLS81LOC_20260819.sql (신선 덤프) → 출력: PKG_DMF0082_BODY_XLS81LOC_20260819.sql"""
import re, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

body = open('PKG_DMF0082_BODY_PRE_XLS81LOC_20260819.sql', encoding='utf-8').read()
M = "[E20260819-XLS81LOC]"
cnt = {}

def rep1(key, old, new):
    global body
    n = body.count(old)
    assert n == 1, (key, n)
    body = body.replace(old, new)
    cnt[key] = 1

# ---- E1: UPLOAD division 승격 40 → 81% ----
rep1('E1_div_gate',
     "        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'\n"
     "        AND    A.ATTRIBUTE1 = '40';",
     "        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'\n"
     f"        AND    A.ATTRIBUTE1 LIKE '81%';   /* {M} Excel Upload = Division 81 계열 전용 (2026-08-19 사용자 지시 — 구 40 전용 역전) */")

# ---- E2: division 오류 문구 ----
rep1('E2_div_msg',
     "             , MESSAGE_TEXT       = MESSAGE_TEXT || ',Invalid Division(40 Only).'",
     f"             , MESSAGE_TEXT       = MESSAGE_TEXT || ',Invalid Division(81 Only).'   /* {M} */")

# ---- E3: EC 체크 — '40' 하드코딩 2곳 → division 상관 (상관 깊이 제약 회피 = DIV 컬럼 승격 후 depth-1 필터) ----
rep1('E3a_ec_divcol',
     "        SET    A.ATTRIBUTE302 = (SELECT MAX(EC.CODE)\n"
     "                                 FROM  (SELECT DISTINCT SI.PROJECT_CODE AS CODE\n"
     "                                             , NVL(D.SEGMENT3, SI.PROJECT_CODE) AS NAME",
     "        SET    A.ATTRIBUTE302 = (SELECT MAX(EC.CODE)\n"
     "                                 FROM  (SELECT DISTINCT SI.PROJECT_CODE AS CODE\n"
     "                                             , NVL(D.SEGMENT3, SI.PROJECT_CODE) AS NAME\n"
     f"                                             , SI.DIVISION_ID AS DIV   /* {M} division 상관 승격 (스칼라 서브쿼리 상관 깊이 1 제약) */")
rep1('E3b_ec_drop40',
     "                                        AND    SI.DIVISION_ID = '40'\n"
     "                                        AND    SI.VALID_YN    = 'Y'\n"
     "                                        UNION",
     f"                                        AND    SI.VALID_YN    = 'Y'   /* {M} 구 SI.DIVISION_ID='40' 하드코딩 제거 — depth-1 EC.DIV 필터로 이동 */\n"
     "                                        UNION")
rep1('E3c_ec_union_divcol',
     "                                        SELECT SEGMENT2 AS CODE\n"
     "                                             , SEGMENT3 AS NAME\n"
     "                                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL\n"
     "                                        WHERE  LOOKUP_TYPE = 'END_CUSTOMER'",
     "                                        SELECT SEGMENT2 AS CODE\n"
     "                                             , SEGMENT3 AS NAME\n"
     f"                                             , SEGMENT1 AS DIV   /* {M} */\n"
     "                                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL\n"
     "                                        WHERE  LOOKUP_TYPE = 'END_CUSTOMER'")
rep1('E3d_ec_union_drop40',
     "                                        AND    SEGMENT1 = '40') EC\n"
     "                                 WHERE EC.NAME = A.ATTRIBUTE2)",
     f"                                        ) EC   /* {M} 구 SEGMENT1='40' 하드코딩 제거 */\n"
     "                                 WHERE EC.NAME = A.ATTRIBUTE2\n"
     f"                                 AND   EC.DIV  = A.ATTRIBUTE301)   /* {M} 행 division 상관 (81 계열 정합) */")

# ---- E4: SALES SITE 체크 '40' → 행 division ----
rep1('E4_salessite',
     "                                 AND    MS.DIVISION_ID = '40'\n"
     "                                 AND    MS.SCM_SITE_ID = A.ATTRIBUTE3)",
     f"                                 AND    MS.DIVISION_ID = A.ATTRIBUTE301   /* {M} 구 '40' 하드코딩 → 행 division */\n"
     "                                 AND    MS.SCM_SITE_ID = A.ATTRIBUTE3)")

# ---- E5: EC/SITE 쌍 체크 '40' → 행 division ----
rep1('E5_pair',
     "                           AND    MS.DIVISION_ID  = '40'\n"
     "                           AND    SI.PROJECT_CODE = A.ATTRIBUTE302",
     f"                           AND    MS.DIVISION_ID  = A.ATTRIBUTE301   /* {M} 구 '40' 하드코딩 → 행 division */\n"
     "                           AND    SI.PROJECT_CODE = A.ATTRIBUTE302")

# ---- E6: UPLOAD measure 매핑 LOC 한정 ----
rep1('E6_measure_loc',
     "                                     AND L.VALID_YN    = 'Y'            -- 사용여부\n"
     "                                     AND L.ATTRIBUTE1  = 'Y'            -- INSERT_YN 여부",
     "                                     AND L.VALID_YN    = 'Y'            -- 사용여부\n"
     "                                     AND L.ATTRIBUTE1  = 'Y'            -- INSERT_YN 여부\n"
     f"                                     AND L.SEGMENT3    = 'LOC'          /* {M} 대상 measure LOC 한정 (2026-08-19 사용자 지시 — 타 measure 명칭은 매핑 실패 → Invalid Measure ERROR 분류) */")

# ---- E7: measure 오류 문구 ----
rep1('E7_measure_msg',
     "             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Measure'",
     f"             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Measure(LOC Only)'   /* {M} */")

# ---- E8: GET_EXCEL_FORM_DATA 진입 가드 ----
form_anchor_re = re.compile(
    r"(\n[ \t]*-{40,}\n[ \t]*-- 1\) MAIN 조회 파이프라인 재사용)")
m = form_anchor_re.search(body); assert m, 'FORM anchor'
guard = ("\n"
    f"    /* {M} Excel Form = Division 81 계열 전용 (2026-08-19 사용자 지시 — 구 40 전용 역전).\n"
    "       비대상 division 은 처리 없이 결과커서 CODE '1' + MSG01014(신규 채번 3언어 — 기존 MSG00702 는 '40 only' 화면용이라 재사용 불가 실측).\n"
    "       FE 는 81 외 버튼 비노출 — 본 가드는 서버 권위(직호출 방어). */\n"
    "    IF p_division_id IS NULL OR p_division_id NOT LIKE '81%' THEN\n"
    "        OPEN o_rc1 FOR SELECT CAST(NULL AS VARCHAR2(10)) AS DIVISION_ID FROM DUAL WHERE 1 = 0;\n"
    "        OPEN o_result_cursor FOR\n"
    "            SELECT '1' AS RESULT_CODE, 'MSG01014' AS RESULT_MSG, '0' AS EVENT FROM DUAL;\n"
    "        RETURN;\n"
    "    END IF;\n")
body = body[:m.start()] + guard + body[m.start():]
cnt['E8_form_guard'] = 1

# ---- E9: FORM WT_MEASURE LOC 한정 ----
rep1('E9_form_measure',
     "           AND L.ATTRIBUTE1  = 'Y'          -- INSERT_YN (검증 SP L4709 동일)",
     "           AND L.ATTRIBUTE1  = 'Y'          -- INSERT_YN (검증 SP L4709 동일)\n"
     f"           AND L.SEGMENT3    = 'LOC'        /* {M} 대상 measure LOC 한정 (2026-08-19 사용자 지시) */")

# ---- E10: GET_EXCEL_UPLOAD_DATA BC '40' → v_division ----
rep1('E10_bc_vdiv',
     "               AND    BC.DIVISION_ID = '40') BC   /* AS-IS 원문 하드코딩('40') 그대로 보존 */",
     f"               AND    BC.DIVISION_ID = v_division) BC   /* {M} 구 '40' 하드코딩 → v_division (형제 스테이지 동형 — 81 BUCKET_CONVERSION 491행 실존: '40' 유지 시 81 커스텀 버킷 행이 BC/DEFAULT 양 분기 모두 탈락) */")

open('PKG_DMF0082_BODY_XLS81LOC_20260819.sql', 'w', encoding='utf-8', newline='').write(body)
print(cnt)
print('markers:', {k: body.count(k) for k in
      ('E20260819-XLS81LOC', 'E20260819-MULTIJOIN', 'E20260819-SENDERJOIN', 'E20260819-PJTNAME',
       'E20260818-PRICECHK1', 'E20260818-UPLOADBATCH')})
