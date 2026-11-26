# -*- coding: utf-8 -*-
"""SSP LOOKUP 이관 : MSSQL 에서 실행하면 Oracle MERGE INTO 문장을 행마다 돌려주는 생성 쿼리 파일을 만든다
  python lookup_merge_gen.py <출력 .sql>
  변환 규칙(2026-11-25 11:22 ZIOUI1 · LGCE_SCMDEV 실측 근거)
    키 SEGMENT1~5        '' → '-'   (AS-IS 키 '' 16개, '-' 로 바꾸면 TO-BE 키와 일치)
    ATTRIBUTE1~15         '' → ' '   (기존 이관 데이터 15,495 + 911건이 ' ')
    DESCRIPTION           '' → NULL  (기존 이관 데이터 458건이 NULL)
    VALID_YN              대문자 · 상세는 NULL/'' → '/' (AS-IS 'y' 16건, TO-BE 는 'Y')
    그 밖의 문자 열       '' → NULL
    일시                  초 단위(밀리초 버림, 기존 데이터와 같음)
    특수 문자             ' 두 번 · & ? : CR LF TAB → CHR() (DBeaver · SQL Developer 변수 처리 회피)"""
import sys, io
ATTR = ['ATTRIBUTE%d' % i for i in range(1, 16)]
SEG = ['SEGMENT%d' % i for i in range(1, 6)]
MASTER = ['LOOKUP_TYPE', 'DESCRIPTION', 'LOOKUP_GROUP', 'VALID_YN'] + SEG + ['CREATED_BY', 'CREATION_DATE', 'LAST_UPDATED_BY', 'LAST_UPDATE_DATE'] + ATTR
DETAIL = ['LOOKUP_TYPE'] + SEG + ['DISPLAY_SEQ', 'VALID_YN', 'DESCRIPTION', 'CREATED_BY', 'CREATION_DATE', 'LAST_UPDATED_BY', 'LAST_UPDATE_DATE'] + ATTR
DATES = {'CREATION_DATE', 'LAST_UPDATE_DATE'}
NUMS = {'DISPLAY_SEQ'}
ESC = [('CHAR(39)', 'CHAR(39) + CHAR(39)')] + [('CHAR(%d)' % n, "CHAR(39) + ' || CHR(%d) || ' + CHAR(39)" % n) for n in (38, 63, 58, 13, 10, 9)]
# 2026-11-25 : DBeaver 가 문자열 안 ; · '''' 에서 쿼리를 나눠 'Cannot execute more than one query in one tab' → 따옴표 = CHAR(39), ; = CHAR(59), 빈 문자열 = DATALENGTH

def esc(v):
    s = v
    for a, b in ESC: s = 'REPLACE(%s, %s, %s)' % (s, a, b)
    return s

def value(al, c, detail):
    x = '%s.%s' % (al, c)
    if c in SEG: return "CASE WHEN DATALENGTH(%s) = 0 THEN N'-' ELSE %s END" % (x, x)
    if c in ATTR: return "CASE WHEN DATALENGTH(%s) = 0 THEN N' ' ELSE %s END" % (x, x)
    if c == 'VALID_YN':
        return ("CASE WHEN %s IS NULL OR DATALENGTH(%s) = 0 THEN N'/' ELSE UPPER(%s) END" if detail else "UPPER(CASE WHEN DATALENGTH(%s) = 0 THEN NULL ELSE %s END)") % ((x, x, x) if detail else (x, x))
    if c == 'LOOKUP_TYPE': return x
    return "CASE WHEN DATALENGTH(%s) = 0 THEN NULL ELSE %s END" % (x, x)

def lit(al, c, detail):
    x = '%s.%s' % (al, c)
    if c in DATES:
        return ("CASE WHEN %s IS NULL THEN 'NULL' ELSE 'TO_DATE(' + CHAR(39) + CONVERT(VARCHAR(8), %s, 112) + REPLACE(CONVERT(VARCHAR(8), %s, 108), CHAR(58), SPACE(0)) + CHAR(39) + ', ' + CHAR(39) + 'YYYYMMDDHH24MISS' + CHAR(39) + ')' END" % (x, x, x))
    if c in NUMS: return "CASE WHEN %s IS NULL THEN 'NULL' ELSE CONVERT(VARCHAR(20), %s) END" % (x, x)
    v = value(al, c, detail)
    return "CASE WHEN %s IS NULL THEN 'NULL' ELSE CHAR(39) + %s + CHAR(39) END" % (v, esc(v))

def stmt(tb, cols, keys, al, detail):
    sel = []
    for i, c in enumerate(cols):
        sel.append("       + %s%s + ' AS %s'" % ("', ' + " if i else '', lit(al, c, detail), c))
    on = ' AND '.join('T.%s = S.%s' % (k, k) for k in keys)
    upd = ', '.join('T.%s = S.%s' % (c, c) for c in cols if c not in keys)
    ins = ', '.join(cols); vals = ', '.join('S.' + c for c in cols)
    head = "SELECT CAST('MERGE INTO %s T USING (SELECT ' AS NVARCHAR(MAX))\n" % tb
    tail = ("       + ' FROM DUAL) S ON (%s) WHEN MATCHED THEN UPDATE SET %s WHEN NOT MATCHED THEN INSERT (%s) VALUES (%s)' + CHAR(59) AS SQL_TEXT\n" % (on, upd, ins, vals))
    return head + '\n'.join(sel) + '\n' + tail

def build():
    m = stmt('SCM_ADM_LOOKUP_MASTER', MASTER, ['LOOKUP_TYPE'], 'M', False)
    d = stmt('SCM_ADM_LOOKUP_MASTER_DETAIL', DETAIL, ['LOOKUP_TYPE'] + SEG, 'D', True)
    m = m.replace(' AS SQL_TEXT\n', ' AS SQL_TEXT\n     , 1 AS ORD, M.LOOKUP_TYPE AS K0' + ''.join(", CAST(NULL AS NVARCHAR(200)) AS K%d" % i for i in range(1, 6)) + '\n')
    d = d.replace(' AS SQL_TEXT\n', ' AS SQL_TEXT\n     , 2 AS ORD, D.LOOKUP_TYPE AS K0' + ''.join(', D.SEGMENT%d AS K%d' % (i, i) for i in range(1, 6)) + '\n')
    m += "  FROM dbo.SCM_ADM_LOOKUP_MASTER M WITH (NOLOCK)\n WHERE M.LOOKUP_GROUP = 'SSP'\n"
    d += ("  FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL D WITH (NOLOCK)\n WHERE D.LOOKUP_TYPE IN (SELECT G.LOOKUP_TYPE\n"
          "                           FROM dbo.SCM_ADM_LOOKUP_MASTER G WITH (NOLOCK)\n                          WHERE G.LOOKUP_GROUP = 'SSP')\n"
          "   AND D.LOOKUP_TYPE <> 'IF_STOCK_CHECK'   /* 재고 수신 확인 상태 값. 키에 일자(SEGMENT5)가 있어 제외 */\n")
    body = m + 'UNION ALL\n' + d
    body = '\n'.join('       ' + l for l in body.rstrip('\n').split('\n'))
    return 'SELECT X.SQL_TEXT\n  FROM (\n' + body + '\n       ) X\n ORDER BY X.ORD, X.K0, X.K1, X.K2, X.K3, X.K4, X.K5;\n'

HEAD = """-- ==============================================================================================================
-- SSP LOOKUP 이관 2/4 · MSSQL(클라우드 QA) 에서 실행 · Oracle MERGE INTO 문장 생성
-- 앞 단계 : 1/4 파일로 Oracle QA LOOKUP 테이블 백업을 끝낸 뒤 실행
-- 대상 : SCM_ADM_LOOKUP_MASTER 의 LOOKUP_GROUP = 'SSP' 유형 · 그 유형의 SCM_ADM_LOOKUP_MASTER_DETAIL 행
-- 실행 : MSSQL 쪽은 DBeaver 에서 쿼리 하나씩(커서를 쿼리 안에 두고 Ctrl+Enter). [M1], [M3], [M2] 각 1쿼리. [M2] 는 한 쿼리라 Alt+X 로 실행하지 않음
-- 사용 : [M1] 건수 확인 → [M2] 실행 → 결과 열 SQL_TEXT 전체 복사 → Oracle QA 에서 스크립트 실행(DBeaver Alt+X · SQL Developer F5)
--        → 3/4 파일 [O1] ~ [O3] 확인 → COMMIT. 되돌릴 때는 4/4 파일
-- 결과 행 : 마스터 1행 = MERGE 1문장, 상세 1행 = MERGE 1문장. 마스터가 먼저 나옴
-- 변환 규칙(2026-11-25 로컬 실측 근거)
--   상세 키 SEGMENT1~5 빈 문자열 → '-'
--   ATTRIBUTE1~15 빈 문자열 → 공백 1자(기존 이관 데이터와 같은 값)
--   DESCRIPTION 빈 문자열 → NULL
--   VALID_YN 대문자로 바꿈. 상세 VALID_YN 빈 값 → '/'
--   일시 = 초 단위(밀리초 버림)
--   작은따옴표는 두 번 씀. 이 쿼리 안의 따옴표와 세미콜론은 CHAR(39), CHAR(59) 로 써서 DBeaver 가 쿼리를 나누지 않음. 앰퍼샌드, 물음표, 콜론, 줄바꿈, 탭은 CHR() 로 바꿔 DBeaver · SQL Developer 변수 입력 창이 뜨지 않게 함
-- MERGE 동작 : 키가 있으면 키 외 전 열 UPDATE, 없으면 INSERT. Oracle 에만 있는 행은 지우지 않음
-- 상세 제외 : IF_STOCK_CHECK(재고 수신 확인). SEGMENT5(일자)가 키라서 MERGE 하면 묶음마다 일자 다른 행이 하나 더 생기고
--             산출 진입 조건(모든 행 SEGMENT5 = 당일)이 막힘. 인터페이스 프로시저가 매일 바꾸는 값이라 Oracle QA 값을 그대로 둠
--             (로컬 시험 2026-11-25 : 포함하면 123묶음 중 14묶음이 2행이 됨). 마스터 행은 MERGE 함
-- ==============================================================================================================

-- ==============================================================================================================
-- [M1] 건수 확인(MSSQL) : [M2] 결과 행 수 = MASTER_CNT + DETAIL_CNT
-- ==============================================================================================================
SELECT (SELECT COUNT(*)
          FROM dbo.SCM_ADM_LOOKUP_MASTER M WITH (NOLOCK)
         WHERE M.LOOKUP_GROUP = 'SSP') AS MASTER_CNT
     , (SELECT COUNT(*)
          FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL D WITH (NOLOCK)
         WHERE D.LOOKUP_TYPE IN (SELECT G.LOOKUP_TYPE
                                   FROM dbo.SCM_ADM_LOOKUP_MASTER G WITH (NOLOCK)
                                  WHERE G.LOOKUP_GROUP = 'SSP')
           AND D.LOOKUP_TYPE <> 'IF_STOCK_CHECK') AS DETAIL_CNT;

-- ==============================================================================================================
-- [M3] 유형별 상세 건수(MSSQL) : Oracle 실행 뒤 3/4 파일 [O2] 결과와 유형별로 비교
-- ==============================================================================================================
SELECT M.LOOKUP_TYPE
     , M.VALID_YN
     , (SELECT COUNT(*)
          FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL D WITH (NOLOCK)
         WHERE D.LOOKUP_TYPE = M.LOOKUP_TYPE) AS DETAIL_CNT
  FROM dbo.SCM_ADM_LOOKUP_MASTER M WITH (NOLOCK)
 WHERE M.LOOKUP_GROUP = 'SSP'
 ORDER BY M.LOOKUP_TYPE;

-- ==============================================================================================================
-- [M2] Oracle MERGE INTO 문장 생성(MSSQL 조회 문장. MSSQL 데이터는 바뀌지 않음)
-- ==============================================================================================================
"""

if __name__ == '__main__':
    io.open(sys.argv[1], 'w', encoding='utf-8', newline='\r\n').write(HEAD + build())
    print('written', sys.argv[1])
