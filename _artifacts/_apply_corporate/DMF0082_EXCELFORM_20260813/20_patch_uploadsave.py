# -*- coding: utf-8 -*-
"""
[E20260813-UPLOADSAVE] PKG_DMF0082 BODY 패치 생성기 (2026-08-13)

  P1 검증 확장   : 숫자/음수/0 검증에 M13~M16(ATTRIBUTE20~23) 추가
                   근거 = 13개월 전 컬럼 입력을 유도하는 개선이라, 미검증 구간에 비숫자가 들어오면
                          배분 단계 TO_NUMBER 에서 ORA-01722 로 업로드 전체가 죽고 원인 행을 알 수 없다.
  P2 파싱부 분리 : P_DMF0082_SAVE_MAIN_DATA 의 '^' 파싱부를 skip 가능하게 (본체 무수정 재사용)
  P3 적재 분기   : P_DMF0082_EXCEL_UPLOAD 에 p_mode>0 ELSE 신설 → 본체 1회 호출

  ⚠ 라인 번호는 BACKUP_PKG_DMF0082_BODY_pre_excelform_20260813.sql 기준.
     적용 전 앵커 텍스트를 대조하고, 하나라도 불일치하면 즉시 중단한다(조용한 오패치 방지).
"""
import re, sys, io

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate"
SRC = rf"{BASE}\DMF0082_EXCELFORM_20260813\02_PKG_DMF0082_BODY_excelform.sql"
OUT = rf"{BASE}\DMF0082_EXCELFORM_20260813\03_PKG_DMF0082_BODY_uploadsave.sql"

lines = io.open(SRC, encoding='utf-8').read().split('\n')


def at(n):
    return lines[n - 1]


def expect(n, frag):
    if frag not in at(n):
        sys.exit(f"[중단] 앵커 불일치 L{n}: 기대 '{frag}' / 실제 {at(n)!r}")


# ---------------------------------------------------------------- P1 검증 확장
MONTHS = [(20, 'M13'), (21, 'M14'), (22, 'M15'), (23, 'M16')]

expect(4811, "VALIDATE_CONVERSION(ATTRIBUTE19 AS NUMBER) = 0)    --M12")
expect(4844, "TO_NUMBER(ATTRIBUTE19 DEFAULT NULL ON CONVERSION ERROR) < 0)    --M12")
expect(4877, "TO_NUMBER(ATTRIBUTE19 DEFAULT NULL ON CONVERSION ERROR) = 0)    --M12")

IND = ' ' * 19


def ext_numeric(n):
    body = at(n).rstrip().rstrip()  # M12 줄 (마지막 항이라 뒤에 OR 없음)
    body = body[:body.rindex(')') + 1] + ' OR --M12'
    add = [body]
    for a, m in MONTHS:
        tail = ' OR' if m != 'M16' else '   '
        add.append(f"{IND}(ATTRIBUTE{a} IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE{a} AS NUMBER) = 0){tail} --{m}"
                   + ("  --[E20260813-UPLOADSAVE] M13~M16 검증 확장" if m == 'M16' else ""))
    return add


def ext_cmp(n, op):
    body = at(n).rstrip()
    body = body[:body.rindex(')') + 1] + ' OR --M12'
    add = [body]
    for a, m in MONTHS:
        tail = ' OR' if m != 'M16' else '   '
        add.append(f"{IND}(ATTRIBUTE{a} IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE{a} AS NUMBER) = 1 "
                   f"AND TO_NUMBER(ATTRIBUTE{a} DEFAULT NULL ON CONVERSION ERROR) {op} 0){tail} --{m}"
                   + ("  --[E20260813-UPLOADSAVE] M13~M16 검증 확장" if m == 'M16' else ""))
    return add


repl = {4811: ext_numeric(4811), 4844: ext_cmp(4844, '<'), 4877: ext_cmp(4877, '=')}

# ---------------------------------------------------------------- P3 적재 분기 (EXCEL_UPLOAD)
expect(4915, "END IF;")
expect(4087, "n_error_cnt")  # 선언부 존재 확인용(범위 가드)

UPLOAD_DECL = """    --[E20260813-UPLOADSAVE] 원장 적재 분기 전용
    v_rc_a           SYS_REFCURSOR;
    v_rc_b           SYS_REFCURSOR;
    v_rc_c           SYS_REFCURSOR;
    v_rc_save        SYS_REFCURSOR;
    v_save_code      VARCHAR2(10  CHAR);
    v_save_msg       VARCHAR2(4000 CHAR);
    v_save_event     VARCHAR2(400 CHAR);
    n_save_cnt       PLS_INTEGER := 0;"""

SAVE_BRANCH = """
    ELSE
        --================================================================================================
        -- [E20260813-UPLOADSAVE] p_mode > 0 : 검증 통과분을 **원장에 적재**한다.
        --   수신 원본에는 이 분기가 아예 없어 OK(2단계)가 원장에 아무것도 쓰지 않았다 (2026-08-13 실측).
        --   적재는 화면 저장과 **동일 경로**(P_DMF0082_SAVE_MAIN_DATA 본체)를 재사용한다 —
        --   MERGE 5종과 검증 게이트를 복제하지 않기 위해, 그 SP 의 '^' 파싱부만 건너뛰고(g_skip_parse)
        --   GT_PRDM1_T_MAIN 을 집합으로 채운 뒤 본체를 **1회** 호출한다.
        --   (행 단위 호출은 파싱 로컬이 VARCHAR2(4000) 이라 호출 폭증 — 사용자 확정: 본체 1회 호출)
        --================================================================================================
        SELECT COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'SUCCESS' THEN 1 END)
             , COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'ERROR'   THEN 1 END)
        INTO   n_success_cnt, n_error_cnt
        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date;

        -- 전량 게이트 — 오류 1건이라도 남았거나 대상이 없으면 적재하지 않는다 (FE 전량 게이트와 이중 방어)
        IF n_error_cnt > 0 OR n_success_cnt = 0 THEN
            OPEN O_RESULT_CURSOR FOR
                SELECT '1' AS RESULT_CODE
                     , 'NOT_SAVABLE (SUCCESS=' || TO_CHAR(n_success_cnt)
                       || ', ERROR=' || TO_CHAR(n_error_cnt) || ')' AS RESULT_MSG
                     , TO_CHAR(NVL(p_mode, 0)) AS EVENT
                FROM   DUAL;
            RETURN;
        END IF;

        ------------------------------------------------------------------------
        -- 1) 월→일 배분 = 조회 SP 의 GTT 파이프라인 재사용 (배분 산식 복제 금지)
        ------------------------------------------------------------------------
        SCM_MGR.PKG_DMF0082.P_DMF0082_GET_EXCEL_UPLOAD_DATA(p_created_by, v_rc_a, v_rc_b, v_rc_c);
        BEGIN IF v_rc_a IS NOT NULL THEN CLOSE v_rc_a; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN IF v_rc_b IS NOT NULL THEN CLOSE v_rc_b; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN IF v_rc_c IS NOT NULL THEN CLOSE v_rc_c; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;

        ------------------------------------------------------------------------
        -- 2) VMI_In_Req = **배분 없이 월 1일에 전량** (사용자 확정 2026-08-13)
        --    배분 파이프라인은 MKT_FCST / LOC 만 처리하므로, 확장하지 않으면 VMI 는
        --    검증을 통과하고도 DAILY 0건이 되어 조용히 누락된다.
        ------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
        ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
        , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
        , KEY_VALUE, YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW
        , BUCKET_CNT, MONTHLY_QTY, WEEKLY_QTY, LAST_DAY_YN, DAILY_QTY )
        SELECT U.DIVISION_ID, U.END_CUSTOMER, U.SCM_SITE_ID, U.ITEM_ID, U.INCOTERMS
             , U.FCST_TYPE, U.DOM_EXP, U.CELL_PROD_SITE, U.CURRENCY, U.MEASURE
             , U.KEY_VALUE, U.YYYYMM, U.YYYYMM || '01', NULL
             , 1, U.QTY, U.QTY, 'Y', U.QTY
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT U
        WHERE  U.MEASURE = 'VMI_In_Req'
        AND    NVL(U.QTY, 0) <> 0;

        ------------------------------------------------------------------------
        -- 3) COMMIT — 본체가 검증 실패로 ROLLBACK 하면 **GTT 적재분도 함께 사라진다**
        --    (ON COMMIT PRESERVE ROWS 는 "커밋해도 안 지운다"이지 롤백 면제가 아니다)
        ------------------------------------------------------------------------
        COMMIT;

        ------------------------------------------------------------------------
        -- 4) 저장 본체 입력 GTT 를 집합으로 1회 적재
        --    · 미입력(빈칸) 월 제외 = MONTHLY_QTY <> 0. 빈칸은 UNPIVOT INCLUDE NULLS+NVL 로 0 이 되고,
        --      0 입력은 검증이 거부하므로 "월 합계 0" == "그 달은 손대지 않았다" 가 성립한다.
        --      (DAILY_QTY <> 0 으로 거르면 배분 FLOOR 결과가 0인 정상 일자를 버려 총량이 깨진다)
        --    · PLANT_SITE_ID 는 양식 토큰에 없다(추가하면 중복키 검사가 전량 ERROR) → 원장 역참조.
        ------------------------------------------------------------------------
        DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;

        INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
        ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
        , PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY
        , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4
        , V_ATTRIBUTE5, V_ATTRIBUTE6, V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
        SELECT 'M'                                   -- 양식 행 = 기존 키의 값 갱신
             , D.DIVISION_ID
             , D.END_CUSTOMER                        -- 40 은 PROJECT_CODE = END_CUSTOMER
             , D.END_CUSTOMER
             , D.SCM_SITE_ID
             , D.ITEM_ID
             , D.DOM_EXP
             , D.FCST_TYPE
             , D.INCOTERMS
             , D.MEASURE
             , NVL( (SELECT MAX(X.PLANT_SITE_ID)
                       FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN X
                      WHERE X.DIVISION_ID       = D.DIVISION_ID
                        AND X.PROJECT_CODE      = D.END_CUSTOMER
                        AND X.SCM_SITE_ID       = D.SCM_SITE_ID
                        AND X.ITEM_ID           = D.ITEM_ID
                        AND X.DOM_EXP           = D.DOM_EXP
                        AND X.FCST_TYPE         = D.FCST_TYPE
                        AND X.INCOTERMS         = D.INCOTERMS
                        AND X.CELL_PROD_SITE_ID = D.CELL_PROD_SITE)
                  , '-' )
             , D.CELL_PROD_SITE
             , D.BASIS_YYYYMMDD
             , D.CURRENCY
             , D.DAILY_QTY
             , p_created_by
             , '', '', '', '', '', '', '', '', '', '', '', ''
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY D
        WHERE  NVL(D.MONTHLY_QTY, 0) <> 0;

        SELECT COUNT(*) INTO n_save_cnt FROM SCM_MGR.GT_PRDM1_T_MAIN;
        COMMIT;

        IF n_save_cnt = 0 THEN
            OPEN O_RESULT_CURSOR FOR
                SELECT '1' AS RESULT_CODE
                     , 'NO_TARGET_ROW (입력된 값이 없습니다)' AS RESULT_MSG
                     , TO_CHAR(NVL(p_mode, 0)) AS EVENT
                FROM   DUAL;
            RETURN;
        END IF;

        ------------------------------------------------------------------------
        -- 5) 저장 본체 1회 호출 (파싱부 skip — GT_PRDM1_T_MAIN 은 위에서 이미 적재)
        ------------------------------------------------------------------------
        g_skip_parse := 'Y';
        BEGIN
            SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA(
                'M', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
              , NULL, NULL, NULL, NULL, NULL, p_created_by, NULL, v_rc_save);
        EXCEPTION
            WHEN OTHERS THEN
                g_skip_parse := 'N';
                RAISE;
        END;
        g_skip_parse := 'N';

        v_save_code := NULL; v_save_msg := NULL; v_save_event := NULL;
        BEGIN
            FETCH v_rc_save INTO v_save_code, v_save_msg, v_save_event;
            CLOSE v_rc_save;
        EXCEPTION WHEN OTHERS THEN NULL; END;

        -- 적재 성공분 마킹 — 재클릭 이중 적재 방지 (다음 mode>0 은 SUCCESS 0건이라 게이트에서 거부)
        IF NVL(v_save_code, 'F') = '0' THEN
            UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'SAVED'
                 , LAST_UPDATED_BY    = p_created_by
                 , LAST_UPDATE_DATE   = SYSDATE
             WHERE PROGRAM_ID = v_program_id
             AND   SHEET_NAME = v_sheet_name
             AND   CREATED_BY = p_created_by
             AND   TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
             AND   UPLOAD_STATUS_CODE = 'SUCCESS';
            COMMIT;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT NVL(v_save_code, 'F') AS RESULT_CODE
                 , CASE WHEN NVL(v_save_code, 'F') = '0'
                        THEN 'SAVED=' || TO_CHAR(n_save_cnt)
                        ELSE NVL(v_save_msg, 'SAVE FAILED') END AS RESULT_MSG
                 , TO_CHAR(NVL(p_mode, 0)) AS EVENT
            FROM   DUAL;
        RETURN;
"""

# ---------------------------------------------------------------- P2 파싱부 분리 (SAVE_MAIN_DATA)
expect(10360, "v_p_as_from_site_raw VARCHAR2(4000 CHAR)")
expect(10488, "DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;")
expect(10509, "마지막 데이터 처리를 위한 구분자 추가")
expect(10643, "END IF;")

SAVE_DECL = """    --[E20260813-UPLOADSAVE] '^' 파싱부 skip 여부 (Excel Upload 적재 경로가 GT_PRDM1_T_MAIN 을 직접 적재)
    v_skip_parse        VARCHAR2(1 CHAR);"""

SKIP_HEAD = """    --[E20260813-UPLOADSAVE] 패키지 전역 플래그를 **1회용으로 소비**한다 (세션 누수 방지).
    --   화면 저장 경로는 g_skip_parse 를 세팅하지 않으므로 항상 'N' = 종전과 완전히 동일하게 동작.
    v_skip_parse := NVL(g_skip_parse, 'N');
    g_skip_parse := 'N';

    IF v_skip_parse = 'N' THEN
        DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;
    END IF;"""

# ---------------------------------------------------------------- 조립
out = []
for i, ln in enumerate(lines, start=1):
    if i in repl:
        out.extend(repl[i])
        continue
    if i == 4915:
        out.append(SAVE_BRANCH)
        out.append(ln)
        continue
    if i == 4087:
        out.append(ln)
        out.append(UPLOAD_DECL)
        continue
    if i == 10360:
        out.append(ln)
        out.append(SAVE_DECL)
        continue
    if i == 10488:
        out.append(SKIP_HEAD)
        continue
    if i == 10509:
        out.append("    IF v_skip_parse = 'N' THEN   --[E20260813-UPLOADSAVE] 파싱부 시작")
        out.append(ln)
        continue
    if i == 10643:
        out.append(ln)
        out.append("    END IF;   --[E20260813-UPLOADSAVE] 파싱부 끝")
        continue
    out.append(ln)

NL = chr(10)
src = NL.join(out)

# 패키지 전역 선언 — 첫 PROCEDURE 앞(=패키지 선언부)에 삽입
GLOBAL_DECL = NL.join([
    "    --[E20260813-UPLOADSAVE] Excel Upload 적재 경로 전용 플래그.",
    "    --   P_DMF0082_SAVE_MAIN_DATA 의 '^' 파싱부를 건너뛰게 한다(본체는 무수정 재사용).",
    "    --   시그니처를 바꾸지 않으므로 PROC_M/BE/FE 배선은 손댈 필요가 없다.",
    "    g_skip_parse VARCHAR2(1 CHAR) := 'N';",
    "",
])
body_lines = src.split(NL)
hdr = next((k for k, t in enumerate(body_lines) if t.upper().startswith('CREATE OR REPLACE PACKAGE BODY')), None)
if hdr is None:
    sys.exit('[중단] BODY 선두 앵커 불일치')
body_lines.insert(hdr + 1, GLOBAL_DECL)
src = NL.join(body_lines)

io.open(OUT, 'w', encoding='utf-8').write(src)
print('생성:', OUT)
print('라인수 %d -> %d' % (len(lines), len(src.split('\n'))))
for tag in ('E20260813-UPLOADSAVE', 'g_skip_parse', 'v_skip_parse'):
    print(f'  {tag}: {src.count(tag)}건')
