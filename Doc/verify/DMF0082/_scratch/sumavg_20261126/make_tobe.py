import io
d=r'C:/Projects/NSCM/Doc/verify/DMF0082/_scratch/sumavg_20261126/'
base=open(d+'BODY.ASIS.sql',encoding='utf-8').read()
QM="'MKT_FCST','MKT_FCST_PP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL','SCM_FCST','RTF_SYS_RP','RTF_SYS_RP_CAR','RTF_SYS_RP_CELL','RTF_SCP','TMM_FCST'"
QM2=QM.replace("'","''")
old1="""            V_Q := V_Q || CHR(10) || ', KEYS AS (SELECT ROWNUM AS KID_, K.* FROM (SELECT ' || v_ksel
                || ' FROM SRCA X WHERE ' || V_QF || ' GROUP BY ' || REPLACE(v_jk, ',', ', ') || ') K)'
                || CHR(10) || ', DISPK AS (SELECT K.KID_, X.' || REPLACE(V_REST, ',', ', X.') || ', SUM(X.QTY) AS QTY, COUNT(*) AS CNT_'
                || ' FROM SRCA X JOIN KEYS K ON ' || V_KJOIN || ' WHERE ' || V_QF
                || ' GROUP BY K.KID_, X.' || REPLACE(V_REST, ',', ', X.') || ')';"""
new1=f"""            -- [E20261126-DMF0082PRICEAVGQTY] 단가(KRW·USD·LOC) 월 SUM 칸 평균 = 같은 품목 키(10키)에 수량 메저가 있는 주(YYYYMMWW)의 단가만 (사용자 요청 2026-11-26 13:22)
            --   QW_ = 수량 메저({QM.replace("'","")}) QTY<>0 인 10키×주 목록. DISPK 단가 행에 QTYQ_(그 주 단가 합)·CNTQ_(그 주 단가 건수)를 싣는다.
            --   종전 DISPK = SUM(X.QTY) AS QTY, COUNT(*) AS CNT_ 만 (D_·W_ 칸과 수량 메저 칸은 종전 값 그대로)
            V_Q := V_Q || CHR(10) || ', KEYS AS (SELECT ROWNUM AS KID_, K.* FROM (SELECT ' || v_ksel
                || ' FROM SRCA X WHERE ' || V_QF || ' GROUP BY ' || REPLACE(v_jk, ',', ', ') || ') K)'
                || CHR(10) || ', QW_ AS (SELECT ' || V_K10A || ', X.YYYYMMWW FROM SRCA X WHERE X.MEASURE IN ({QM2}) AND X.QTY <> 0 GROUP BY ' || V_K10 || ', X.YYYYMMWW)'
                || CHR(10) || ', DISPK AS (SELECT K.KID_, X.' || REPLACE(V_REST, ',', ', X.') || ', SUM(X.QTY) AS QTY, COUNT(*) AS CNT_'
                || ', SUM(CASE WHEN R.YYYYMMWW IS NOT NULL THEN X.QTY END) AS QTYQ_, COUNT(R.YYYYMMWW) AS CNTQ_'
                || ' FROM SRCA X JOIN KEYS K ON ' || V_KJOIN
                || ' LEFT JOIN QW_ R ON X.MEASURE IN (''KRW'',''USD'',''LOC'') AND R.YYYYMMWW = X.YYYYMMWW AND ' || V_K10J
                || ' WHERE ' || V_QF
                || ' GROUP BY K.KID_, X.' || REPLACE(V_REST, ',', ', X.') || ')';"""
old2="""        SELECT KID_, 'M_' || YYYYMM AS PIVOT_BUCKET, SUM(QTY) / SUM(CNT_) AS QTY
        FROM DISPK
        WHERE MEASURE IN ('KRW','USD','LOC')
        [@V_GROUPBY], NOTATION, YYYYMM"""
new2="""        SELECT KID_, 'M_' || YYYYMM AS PIVOT_BUCKET
             , CASE WHEN SUM(CNTQ_) > 0 THEN SUM(QTYQ_) / SUM(CNTQ_) ELSE SUM(QTY) / SUM(CNT_) END AS QTY  /* [E20261126-DMF0082PRICEAVGQTY] 수량 있는 주 단가 평균 · 그 달 수량 없으면 종전 전 일자 평균 (종전 = SUM(QTY) / SUM(CNT_)) */
        FROM DISPK
        WHERE MEASURE IN ('KRW','USD','LOC')
        [@V_GROUPBY], NOTATION, YYYYMM"""
assert base.count(old1)==1, base.count(old1)
assert base.count(old2)==1, base.count(old2)
tobe=base.replace(old1,new1).replace(old2,new2)
open(d+'BODY.TOBE.sql','w',encoding='utf-8').write(tobe)
print('ok', len(tobe.splitlines()))
