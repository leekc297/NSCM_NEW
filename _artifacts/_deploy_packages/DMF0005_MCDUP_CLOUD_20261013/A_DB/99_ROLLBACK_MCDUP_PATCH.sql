-- 99 ROLLBACK — [E20261013-DMF0005MCDUP] 역치환 (이 DB 의 USER_SOURCE 를 읽어 끼워 넣은 3곳을 걷어낸 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 되돌린 뒤 마커 0 이어야 실행. ⚠ 되돌리면 키가 겹치는 변경은 다시 ORA-00001 (화면 SQL ERROR) 로 실패한다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261013-DMF0005MCDUP';
    c_old1  CONSTANT VARCHAR2(32767) :=   -- 앵커 1: 변경 이력 줄
        ' * 2026.10.01   Claude(Code)   [DMF0005] AS-IS DMF0005_SAVE_MODEL_CHANGE_POPUP 변환 신규' || CHR(10);
    c_new1  CONSTANT VARCHAR2(32767) :=
        ' * 2026.10.01   Claude(Code)   [DMF0005] AS-IS DMF0005_SAVE_MODEL_CHANGE_POPUP 변환 신규' || CHR(10) ||
        ' * 2026.10.13   Claude(Code)   [E20261013-DMF0005MCDUP] 키 중복 사전 검증 추가 (ORA-00001 대신 검증 메시지)' || CHR(10);
    c_old2  CONSTANT VARCHAR2(32767) :=   -- 앵커 2: CHANGE_TABLE 설명 주석
        '    -- 테이블 1개 갱신' || CHR(10);
    c_new2  CONSTANT VARCHAR2(32767) :=
        '    --[E20261013-DMF0005MCDUP] 키 중복 사전 검증 (START)' || CHR(10) ||
        '    --   ITEM_ID 를 포함한 유일 인덱스가 있는 테이블은, 변경 전 Model 행의 ITEM_ID 를 바꾸면 키가 겹칠 수 있다' || CHR(10) ||
        '    --   (같은 키에 변경 후 Model 이 이미 등록된 경우). 종전에는 ORA-00001 로 실패해 화면에 SQL ERROR 만 보였다.' || CHR(10) ||
        '    --   AS-IS 도 사전 검사 없이 실패(전체 ROLLBACK)하므로 저장 불가 결과는 같다 — 안내 문구만 더한다.' || CHR(10) ||
        '    --   ① 유일 인덱스·키 컬럼은 딕셔너리에서 읽는다 (환경마다 키 구성이 달라도 동작)' || CHR(10) ||
        '    --   ② 판정 = 갱신 뒤 키가 겹치는가. 상대 행이 같은 배치에서 다른 코드로 옮겨가면 겹치지 않고,' || CHR(10) ||
        '    --      서로 다른 변경 전 Model 두 개가 같은 변경 후 Model 로 모여도 겹친다.' || CHR(10) ||
        '    PROCEDURE CHECK_DUP(P_TABLE IN VARCHAR2, P_DIV40 IN BOOLEAN) IS' || CHR(10) ||
        '        V_PAIRS   SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();   -- BEFORE(12) || AFTER(12)' || CHR(10) ||
        '        V_XF      VARCHAR2(100) := CASE WHEN P_DIV40 THEN '' AND X.DIVISION_ID = ''''40'''''' END;' || CHR(10) ||
        '        V_YF      VARCHAR2(100) := CASE WHEN P_DIV40 THEN '' AND Y.DIVISION_ID = ''''40'''''' END;' || CHR(10) ||
        '        V_JOIN    VARCHAR2(8000);' || CHR(10) ||
        '        V_KEYTXT  VARCHAR2(8000);' || CHR(10) ||
        '        V_B       VARCHAR2(200);' || CHR(10) ||
        '        V_A       VARCHAR2(200);' || CHR(10) ||
        '        V_KEY     VARCHAR2(4000);' || CHR(10) ||
        '        V_FOUND   BOOLEAN;' || CHR(10) ||
        '    BEGIN' || CHR(10) ||
        '        FOR I IN 1 .. V_BEF_LIST.COUNT LOOP' || CHR(10) ||
        '            V_PAIRS.EXTEND;' || CHR(10) ||
        '            V_PAIRS(I) := V_BEF_LIST(I) || V_MAP(V_BEF_LIST(I));' || CHR(10) ||
        '        END LOOP;' || CHR(10) ||
        '        FOR IX IN ( SELECT I.INDEX_NAME' || CHR(10) ||
        '                      FROM USER_INDEXES I' || CHR(10) ||
        '                     WHERE I.TABLE_NAME = P_TABLE' || CHR(10) ||
        '                       AND I.UNIQUENESS = ''UNIQUE''' || CHR(10) ||
        '                       AND EXISTS ( SELECT 1 FROM USER_IND_COLUMNS C' || CHR(10) ||
        '                                     WHERE C.INDEX_NAME = I.INDEX_NAME AND C.COLUMN_NAME = ''ITEM_ID'' )' || CHR(10) ||
        '                       AND NOT EXISTS ( SELECT 1 FROM USER_IND_COLUMNS C' || CHR(10) ||
        '                                         WHERE C.INDEX_NAME = I.INDEX_NAME' || CHR(10) ||
        '                                           AND NOT EXISTS ( SELECT 1 FROM USER_TAB_COLUMNS T' || CHR(10) ||
        '                                                             WHERE T.TABLE_NAME = P_TABLE AND T.COLUMN_NAME = C.COLUMN_NAME ) )' || CHR(10) ||
        '                     ORDER BY I.INDEX_NAME ) LOOP' || CHR(10) ||
        '            V_JOIN   := NULL;' || CHR(10) ||
        '            V_KEYTXT := NULL;' || CHR(10) ||
        '            FOR C IN ( SELECT IC.COLUMN_NAME, TC.DATA_TYPE, TC.NULLABLE' || CHR(10) ||
        '                         FROM USER_IND_COLUMNS IC' || CHR(10) ||
        '                         JOIN USER_TAB_COLUMNS TC ON TC.TABLE_NAME = P_TABLE AND TC.COLUMN_NAME = IC.COLUMN_NAME' || CHR(10) ||
        '                        WHERE IC.INDEX_NAME  = IX.INDEX_NAME' || CHR(10) ||
        '                          AND IC.COLUMN_NAME <> ''ITEM_ID''' || CHR(10) ||
        '                        ORDER BY IC.COLUMN_POSITION ) LOOP' || CHR(10) ||
        '                -- NOT NULL 컬럼은 등호(인덱스 사용), NULL 허용 컬럼은 NULL 끼리도 같은 값으로 본다(유일 인덱스 규칙)' || CHR(10) ||
        '                V_JOIN := V_JOIN || CASE WHEN C.NULLABLE = ''N''' || CHR(10) ||
        '                                         THEN '' AND Y.'' || C.COLUMN_NAME || '' = X.'' || C.COLUMN_NAME' || CHR(10) ||
        '                                         ELSE '' AND DECODE(Y.'' || C.COLUMN_NAME || '', X.'' || C.COLUMN_NAME || '', 1, 0) = 1'' END;' || CHR(10) ||
        '                -- 날짜는 형식을 명시해 문자로 바꾼다 (세션 날짜 형식에 기대지 않는다)' || CHR(10) ||
        '                V_KEYTXT := V_KEYTXT || CASE WHEN V_KEYTXT IS NOT NULL THEN '' || '''', '''' || '' END' || CHR(10) ||
        '                         || '''''''' || C.COLUMN_NAME || ''='''' || ''' || CHR(10) ||
        '                         || CASE WHEN C.DATA_TYPE = ''DATE'' OR C.DATA_TYPE LIKE ''TIMESTAMP%''' || CHR(10) ||
        '                                 THEN ''TO_CHAR(X.'' || C.COLUMN_NAME || '', ''''YYYY-MM-DD HH24:MI:SS'''')''' || CHR(10) ||
        '                                 ELSE ''TO_CHAR(X.'' || C.COLUMN_NAME || '')'' END;' || CHR(10) ||
        '            END LOOP;' || CHR(10) ||
        '            BEGIN' || CHR(10) ||
        '                EXECUTE IMMEDIATE' || CHR(10) ||
        '                       ''SELECT B, A, K FROM (''' || CHR(10) ||
        '                    || '' SELECT SUBSTR(L.COLUMN_VALUE, 1, 12) AS B, SUBSTR(L.COLUMN_VALUE, 13, 12) AS A''' || CHR(10) ||
        '                    || ''      , SUBSTR('' || NVL(V_KEYTXT, ''''''-'''''') || '', 1, 500) AS K''' || CHR(10) ||
        '                    || ''   FROM TABLE(:L1) L JOIN '' || P_TABLE || '' X ON X.ITEM_ID = SUBSTR(L.COLUMN_VALUE, 1, 12)''' || CHR(10) ||
        '                    || ''  WHERE 1 = 1'' || V_XF' || CHR(10) ||
        '                    || ''    AND EXISTS ( SELECT 1 FROM '' || P_TABLE || '' Y''' || CHR(10) ||
        '                    || ''                  WHERE Y.ROWID <> X.ROWID'' || V_JOIN' || CHR(10) ||
        '                    || ''                    AND ( ( Y.ITEM_ID = SUBSTR(L.COLUMN_VALUE, 13, 12)''' || CHR(10) ||
        '                    || ''                            AND NOT ( Y.ITEM_ID IN (SELECT SUBSTR(L2.COLUMN_VALUE, 1, 12) FROM TABLE(:L2) L2)'' || V_YF || '' ) )''' || CHR(10) ||
        '                    || ''                       OR ( Y.ITEM_ID IN (SELECT SUBSTR(L3.COLUMN_VALUE, 1, 12) FROM TABLE(:L3) L3''' || CHR(10) ||
        '                    || ''                                           WHERE SUBSTR(L3.COLUMN_VALUE, 13, 12) = SUBSTR(L.COLUMN_VALUE, 13, 12))'' || V_YF || '' ) ) )''' || CHR(10) ||
        '                    || '' ) WHERE ROWNUM = 1''' || CHR(10) ||
        '                    INTO V_B, V_A, V_KEY' || CHR(10) ||
        '                    USING V_PAIRS, V_PAIRS, V_PAIRS;' || CHR(10) ||
        '                V_FOUND := TRUE;' || CHR(10) ||
        '            EXCEPTION' || CHR(10) ||
        '                WHEN NO_DATA_FOUND THEN' || CHR(10) ||
        '                    V_FOUND := FALSE;' || CHR(10) ||
        '            END;' || CHR(10) ||
        '            IF V_FOUND THEN' || CHR(10) ||
        '                RAISE_INVALID(''변경 후 Model 코드가 같은 키로 이미 등록되어 있어 변경할 수 없습니다.'' || CHR(10)' || CHR(10) ||
        '                           || ''MODEL : '' || V_B || '' -> '' || V_A || CHR(10)' || CHR(10) ||
        '                           || ''TABLE : '' || P_TABLE || CHR(10)' || CHR(10) ||
        '                           || ''KEY : '' || V_KEY);' || CHR(10) ||
        '            END IF;' || CHR(10) ||
        '        END LOOP;' || CHR(10) ||
        '    END CHECK_DUP;' || CHR(10) ||
        '    --[E20261013-DMF0005MCDUP] 키 중복 사전 검증 (END)' || CHR(10) ||
        '    -- 테이블 1개 갱신' || CHR(10);
    c_old3  CONSTANT VARCHAR2(32767) :=   -- 앵커 3: CHANGE_TABLE 대상 0건 반환
        '        IF V_RIDS.COUNT = 0 THEN' || CHR(10) ||
        '            RETURN;' || CHR(10) ||
        '        END IF;' || CHR(10);
    c_new3  CONSTANT VARCHAR2(32767) :=
        '        IF V_RIDS.COUNT = 0 THEN' || CHR(10) ||
        '            RETURN;' || CHR(10) ||
        '        END IF;' || CHR(10) ||
        '        CHECK_DUP(P_TABLE, P_DIV40);   --[E20261013-DMF0005MCDUP] 갱신 직전 키 중복 검증 — 겹치면 검증 메시지로 차단(전체 ROLLBACK)' || CHR(10);
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0005' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 1(변경 이력 줄) 매칭 ' || cnt(v_src, c_new1) || '건 (1 기대). 원문 무변경');
    END IF;
    IF cnt(v_src, c_new2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 적용 문구 2(CHANGE_TABLE 설명 주석) 매칭 ' || cnt(v_src, c_new2) || '건 (1 기대). 원문 무변경');
    END IF;
    IF cnt(v_src, c_new3) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — 적용 문구 3(CHANGE_TABLE 대상 0건 반환) 매칭 ' || cnt(v_src, c_new3) || '건 (1 기대). 원문 무변경');
    END IF;
    v_new := v_src;
    v_new := REPLACE(v_new, c_new3, c_old3);
    v_new := REPLACE(v_new, c_new2, c_old2);
    v_new := REPLACE(v_new, c_new1, c_old1);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0005' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0005' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0005' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0005 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0005' ORDER BY OBJECT_TYPE;
