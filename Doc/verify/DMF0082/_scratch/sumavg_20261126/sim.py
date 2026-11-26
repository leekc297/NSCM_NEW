import re,glob,os
d=r'C:/Projects/NSCM/'
pk=open(d+'_artifacts/_deploy_packages/DMF0082_CLOUD_DB_MOD_20261126_1333/A_DB/20_PKG_PKG_DMF0082.sql',encoding='utf-8').read()
body=pk[pk.index('/* PACKAGE BODY PKG_DMF0082'):]
hunks=re.findall(r"v_o := v_o \|\| q'~(.*?)~';\s*v_n := NULL;\s*v_n := v_n \|\| q'~(.*?)~';\s*hunk\((\d)\);",body,re.S)
print('hunks',len(hunks))
corp_now=open(d+'_artifacts/_apply_corporate/DMF0082_PRICE_AVG_QTY_20261126/01_PKG_DMF0082_BODY.TOBE.sql',encoding='utf-8').read().replace('\r\n','\n')
def run(src,label):
    v=src.replace('\r\n','\n')
    for o,n,k in hunks:
        c=v.count(o)
        if c==0 and v.count(n)==1: print(label,'hunk',k,'이미 반영 · 건너뜀'); continue
        if c!=1: print(label,'hunk',k,'중단 count',c); return
        v=v.replace(o,n,1); print(label,'hunk',k,'적용')
    print(label,'조립 결과 = 사내 원문:', v==corp_now)
# 경우 1: 클라우드 = 사내 11-24 13:36 판(CURMON)
run(open(d+'_artifacts/_apply_corporate/DMF0082_PRICE_AVG_QTY_20261126/00_BACKUP_PKG_DMF0082_BODY.ASIS.sql',encoding='utf-8').read(),'CURMON판')
# 경우 2: 클라우드 = 11-24 TEMP 판
run(open(d+'_artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/04_BACKUP_PKG_DMF0082_BODY_TEMP.ASIS.sql',encoding='utf-8').read().split('PACKAGE BODY',1)[1].join(['PACKAGE BODY',''][::-1]) if False else open(d+'_artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/04_BACKUP_PKG_DMF0082_BODY_TEMP.ASIS.sql',encoding='utf-8').read(),'TEMP판')
