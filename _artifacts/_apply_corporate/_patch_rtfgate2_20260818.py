#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_patch_rtfgate2_20260818.py — PKG_DMF0021 BODY RTFGATE2 패치 생성 (2026-08-18)

기준선 = 사내 배포본 실측 덤프(BACKUP_PKG_DMF0021_BODY_pre_rtfgate2_20260818.sql).
치환 3건, 각 1회 정확 일치 아니면 즉시 중단 (조용한 부분적용 금지).

  P1 GET  : EDIT_AUTH_RTF_SYS_RP 산출 조건 — 시간창 경과 → 직전 앵커 이후 Cutoff 원장 실존
  P2 SAVE : 저장 게이트 — 동일 판정 + 행별 → division/user DISTINCT 집합 판정(행별 재평가 제거)
  P3 MSG  : MSG00704 → MSG01001 (원장 문구 충돌 회피 — 신규 01001+ 대역 채번)
"""
import os

SRC = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                   "BACKUP_PKG_DMF0021_BODY_pre_rtfgate2_20260818.sql")
DST = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                   "PKG_DMF0021_BODY_RTFGATE2_20260818.sql")

# ── P1 GET ────────────────────────────────────────────────────────────────────
GET_OLD = """       --[RTFGATE 2026-08-12] Sales Plan Cutoff 시간창 — "이번 주 A1 요일 A2 시각 이후"만 인정
       --  (통합테스트 1st No.58. A1 NULL=상시. 40=MON1600 / 81=SAT1600 — 익주 진입 시 자동 차단=2차 Cutoff)
       AND (ATTRIBUTE1 IS NULL
            OR SYSDATE >= TRUNC(SYSDATE, 'IW')
               + DECODE(ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
               + NVL(TO_NUMBER(SUBSTR(ATTRIBUTE2, 1, 2)), 0) / 24
               + NVL(TO_NUMBER(SUBSTR(ATTRIBUTE2, 3, 2)), 0) / 1440);"""

GET_NEW = """       --[RTFGATE2 2026-08-18] Sales Plan Cutoff **원장 실존** 판정 (통합테스트 1st No.58 (1)(3)(4))
       --  구 RTFGATE(2026-08-12)는 "이번 주 A1 요일 A2 시각 경과"만 봤다 — 시각은 Cutoff 실행 여부와
       --  무관하게 흐르므로 결함 원문("Sales Plan Cutoff 미완료 상태인데도 수정이 가능함")을 막지 못하고,
       --  반대로 81(SAT1600)은 당주 Cutoff 가 완료돼도 토요일까지 잠기는 역차단이 실측됐다
       --  (2026-08-18 실측: 81 SP_W_20260817 월 20:22 완료인데 게이트 BLOCKED).
       --  A1/A2 = 기준 시점(40=MON1600 / 81=SAT1600 — (3)의 "SCP Final 수행 완료" 시점을 lookup 이 지배).
       --    앵커  = 그 요일·시각의 **직전 도래분** (이번 주 분이 아직 미래면 지난 주 같은 시점).
       --    허용  = 앵커 이후 SALES_PLAN WEEKLY CUTOFF(SP_W) 가 **정확히 1 일자** 존재.
       --            0 = Cutoff 미완료 → 차단 ((1))  /  2 이상 = 2차 Cutoff 완료 → 차단 ((4)).
       --    회차는 VERSION_NO 가 아니라 **DISTINCT YYYYMMDD** — 한 배치가 같은 날 V001~V003 을 남기는
       --    사례(81_HD 2026-08-12 15:06 3건)가 있어 행수로 세면 1차를 2차로 오판한다.
       AND (ATTRIBUTE1 IS NULL
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

# ── P2 SAVE ───────────────────────────────────────────────────────────────────
SAVE_OLD = """    --[RTFGATE 2026-08-12] RTF[R+P] Sales Plan Cutoff 게이트 (통합테스트 1st No.58 ①②)
    --  RTF_SYS_RP 저장 행이 있는데, 그 행 division 에 대해 사용자 보유그룹(AUTHUNION) 매칭 +
    --  시간창 통과 lookup 행이 하나도 없으면 저장 전체 차단 (MSG00704).
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN TMP
            WHERE TMP.V_MEASURE = 'RTF_SYS_RP'
            AND NOT EXISTS (
                SELECT 1
                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B
                WHERE  B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                AND    B.VALID_YN    = 'Y'
                AND    B.SEGMENT2    = 'DMF0021'
                AND    B.SEGMENT3    = TMP.V_DIVISION_ID
                AND    B.SEGMENT4    = 'RTF_SYS_RP'
                AND    (B.SEGMENT1 = TMP.V_CREATED_BY
                        OR B.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                          WHERE G.USER_ID = TMP.V_CREATED_BY AND G.USE_YN = 'Y'))
                AND    (B.ATTRIBUTE1 IS NULL
                        OR SYSDATE >= TRUNC(SYSDATE, 'IW')
                           + DECODE(B.ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
                           + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 1, 2)), 0) / 24
                           + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 3, 2)), 0) / 1440)
            )
        );
        v_log_type := 'INVALID'; V_S_CODE := 'MSG00704'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;"""

SAVE_NEW = """    --[RTFGATE2 2026-08-18] RTF[R+P] Sales Plan Cutoff 게이트 (통합테스트 1st No.58 (1)(2)(3)(4))
    --  RTF_SYS_RP 저장 행이 있는데, 그 division 에 대해 사용자 보유그룹(AUTHUNION) 매칭 +
    --  "직전 앵커 이후 SP_W Cutoff 가 정확히 1 일자" 인 lookup 행이 하나도 없으면 저장 전체 차단.
    --  판정 산식은 GET 측(EDIT_AUTH_RTF_SYS_RP 산출)과 동일 — 화면 편집색과 저장 차단이 어긋나지 않는다.
    --  ⚠ 대상은 GT 전행이 아니라 DISTINCT (division, user) — 행별 재평가는 대량 저장 시 앵커 산식을
    --    행 수만큼 반복시킨다 (행별 스칼라 연산 = 성능 1순위 함정).
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1
            FROM ( SELECT DISTINCT V_DIVISION_ID, V_CREATED_BY
                     FROM GT_F021_SALES_PLAN
                    WHERE V_MEASURE = 'RTF_SYS_RP' ) TMP
            WHERE NOT EXISTS (
                SELECT 1
                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B
                WHERE  B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                AND    B.VALID_YN    = 'Y'
                AND    B.SEGMENT2    = 'DMF0021'
                AND    B.SEGMENT3    = TMP.V_DIVISION_ID
                AND    B.SEGMENT4    = 'RTF_SYS_RP'
                AND    (B.SEGMENT1 = TMP.V_CREATED_BY
                        OR B.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                          WHERE G.USER_ID = TMP.V_CREATED_BY AND G.USE_YN = 'Y'))
                AND    (B.ATTRIBUTE1 IS NULL
                        OR (SELECT COUNT(DISTINCT V.YYYYMMDD)
                              FROM DM_MST_VERSION V
                             WHERE V.VERSION_TYPE  = 'SP_W'
                               AND V.DIVISION_ID   = TMP.V_DIVISION_ID
                               AND V.CREATION_DATE >
                                   (CASE WHEN TRUNC(SYSDATE, 'IW')
                                              + DECODE(B.ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
                                              + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 1, 2)), 0) / 24
                                              + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 3, 2)), 0) / 1440 > SYSDATE
                                         THEN TRUNC(SYSDATE, 'IW') - 7 ELSE TRUNC(SYSDATE, 'IW') END)
                                   + DECODE(B.ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
                                   + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 1, 2)), 0) / 24
                                   + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 3, 2)), 0) / 1440) = 1)
            )
        );
        -- MSG01001 = "Sales Plan Cutoff 완료 후에만 RTF[R+P] 수정이 가능합니다."
        --   구 MSG00704 는 클라우드에 이미 다른 뜻("수정 중인 데이터가 있습니다...")으로 존재해
        --   2026-08-15 사내 원장이 그 문구로 덮여 있었다 → 채번 규약(2026-08-14)대로 01001+ 대역 신규 채번.
        v_log_type := 'INVALID'; V_S_CODE := 'MSG01001'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;"""


def replace_once(text: str, old: str, new: str, tag: str) -> str:
    cnt = text.count(old)
    if cnt != 1:
        raise SystemExit(f"[{tag}] 기준선 불일치 — 정확히 1회여야 하는데 {cnt}회. 패치 중단.")
    return text.replace(old, new)


def main():
    with open(SRC, encoding="utf-8") as f:
        body = f.read()

    body = replace_once(body, GET_OLD, GET_NEW, "P1 GET")
    body = replace_once(body, SAVE_OLD, SAVE_NEW, "P2 SAVE")

    # P3 검증 — MSG00704 잔존 0 (SAVE_NEW 안에서 이미 MSG01001 로 교체됨)
    live = [ln for ln in body.splitlines()
            if "MSG00704" in ln and not ln.lstrip().startswith("--")]
    if live:
        raise SystemExit(f"[P3 MSG] 비주석 MSG00704 잔존 {len(live)}건: {live[:3]}")

    with open(DST, "w", encoding="utf-8", newline="") as f:
        f.write(body)
    print(f"패치 생성: {DST}")
    print(f"  라인수 {len(body.splitlines())} (기준선 3616 + 증분)")
    print(f"  RTFGATE2 마커 {body.count('[RTFGATE2 2026-08-18]')}건 / MSG01001 {body.count('MSG01001')}건")


if __name__ == "__main__":
    main()
