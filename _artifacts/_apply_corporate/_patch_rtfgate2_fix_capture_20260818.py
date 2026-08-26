#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_patch_rtfgate2_fix_capture_20260818.py — RTFGATE2 GET 측 컬럼명 캡처 버그 정정

증상: 81(및 40) RTF[R+P] 편집 전면 불가.
원인: GET 측 게이트의 스칼라 서브쿼리 `FROM DM_MST_VERSION V` 안에서 무한정 `ATTRIBUTE1/2` 가
      **V 의 동명 컬럼**(DM_MST_VERSION 도 ATTRIBUTE1~10 보유)으로 해석된다. 값이 NULL 이라
      DECODE→NULL, 앵커 NULL, `V.CREATION_DATE > NULL` = UNKNOWN → 카운트 0 → 게이트 상시 차단.
      (SAVE 측은 `B.ATTRIBUTE1` 로 이미 한정돼 있어 무영향.)
조치: lookup 테이블에 별칭 `L` 부여 후 서브쿼리 안 참조를 `L.ATTRIBUTE1/2` 로 한정.
"""
import os

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "PKG_DMF0021_BODY_RTFGATE2_20260818.sql")

OLD = """    SELECT COUNT(1)
      INTO v_meas_cnt
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
       AND VALID_YN    = 'Y'
       AND (SEGMENT1 = p_userinfo  --[AUTHUNION 2026-08-04] 보유그룹 합집합 판정 (사용자 확정)
            OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                            WHERE G.USER_ID IN (p_userinfo, p_created_by) AND G.USE_YN = 'Y'))
       AND SEGMENT2    = v_p_program_id
       --AND SEGMENT3  = LEFT(@p_division_id, 2) --[E20260331-000648]_원소스 주석처리
       AND SEGMENT3    = p_division_id
       AND SEGMENT4    = 'RTF_SYS_RP'"""

NEW = """    SELECT COUNT(1)
      INTO v_meas_cnt
      --[RTFGATE2-FIX 2026-08-18] 별칭 L 필수 — 아래 서브쿼리의 DM_MST_VERSION 도 ATTRIBUTE1~10 을
      --  가지고 있어, 무한정 ATTRIBUTE1/2 는 lookup 이 아니라 **버전 테이블 컬럼**으로 잡힌다
      --  (NULL → DECODE NULL → 앵커 NULL → 비교 UNKNOWN → 권한 상시 0 = RTF 편집 전면 불가).
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
     WHERE L.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
       AND L.VALID_YN    = 'Y'
       AND (L.SEGMENT1 = p_userinfo  --[AUTHUNION 2026-08-04] 보유그룹 합집합 판정 (사용자 확정)
            OR L.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                            WHERE G.USER_ID IN (p_userinfo, p_created_by) AND G.USE_YN = 'Y'))
       AND L.SEGMENT2    = v_p_program_id
       --AND SEGMENT3  = LEFT(@p_division_id, 2) --[E20260331-000648]_원소스 주석처리
       AND L.SEGMENT3    = p_division_id
       AND L.SEGMENT4    = 'RTF_SYS_RP'"""

# 게이트 조건부 — 무한정 ATTRIBUTE1/2 → L. 한정
OLD_COND = """       AND (ATTRIBUTE1 IS NULL
            OR (SELECT COUNT(DISTINCT V.YYYYMMDD)
                  FROM DM_MST_VERSION V
                 WHERE V.VERSION_TYPE  = 'SP_W'
                   AND V.DIVISION_ID   = p_division_id
                   AND V.CREATION_DATE >
                       (CASE WHEN TRUNC(SYSDATE, 'IW')
                                  + DECODE(ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
                                  + NVL(TO_NUMBER(SUBSTR(ATTRIBUTE2, 1, 2)), 0) / 24
                                  + NVL(TO_NUMBER(SUBSTR(ATTRIBUTE2, 3, 2)), 0) / 1440 > SYSDATE
                             THEN TRUNC(SYSDATE, 'IW') - 7 ELSE TRUNC(SYSDATE, 'IW') END)
                       + DECODE(ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
                       + NVL(TO_NUMBER(SUBSTR(ATTRIBUTE2, 1, 2)), 0) / 24
                       + NVL(TO_NUMBER(SUBSTR(ATTRIBUTE2, 3, 2)), 0) / 1440) = 1);"""

NEW_COND = """       AND (L.ATTRIBUTE1 IS NULL
            OR (SELECT COUNT(DISTINCT V.YYYYMMDD)
                  FROM DM_MST_VERSION V
                 WHERE V.VERSION_TYPE  = 'SP_W'
                   AND V.DIVISION_ID   = p_division_id
                   AND V.CREATION_DATE >
                       (CASE WHEN TRUNC(SYSDATE, 'IW')
                                  + DECODE(L.ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
                                  + NVL(TO_NUMBER(SUBSTR(L.ATTRIBUTE2, 1, 2)), 0) / 24
                                  + NVL(TO_NUMBER(SUBSTR(L.ATTRIBUTE2, 3, 2)), 0) / 1440 > SYSDATE
                             THEN TRUNC(SYSDATE, 'IW') - 7 ELSE TRUNC(SYSDATE, 'IW') END)
                       + DECODE(L.ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
                       + NVL(TO_NUMBER(SUBSTR(L.ATTRIBUTE2, 1, 2)), 0) / 24
                       + NVL(TO_NUMBER(SUBSTR(L.ATTRIBUTE2, 3, 2)), 0) / 1440) = 1);"""


def replace_once(text, old, new, tag):
    if text.count(old) != 1:
        raise SystemExit(f"[{tag}] 기준선 불일치 — {text.count(old)}회. 중단.")
    return text.replace(old, new)


def main():
    with open(SRC, encoding="utf-8") as f:
        body = f.read()
    body = replace_once(body, OLD, NEW, "P1 별칭")
    body = replace_once(body, OLD_COND, NEW_COND, "P2 조건 한정")
    with open(SRC, "w", encoding="utf-8", newline="") as f:
        f.write(body)
    print(f"정정 반영: {SRC}")
    print(f"  RTFGATE2-FIX 마커 {body.count('[RTFGATE2-FIX 2026-08-18]')}건")


if __name__ == "__main__":
    main()
