"""1차 적용분(4그룹: CAPA Planner N · System Monitor · SSP ADMIN · '/') 제거 — 사용자 재결정('-' 교체 · CAPA Y · 매핑 이관) 반영 전 정리."""
import sys, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
u, p, d = conn_info(); cn = oracledb.connect(user=u, password=p, dsn=d); cur = cn.cursor()
for t, c in [("SCM_ADM_USER_GR_MPG_M","USER_GR_ID"),("SCM_ADM_USER_GR_UNIT_AUTH_MPG_M","USER_GR_ID"),("SCM_ADM_USER_GR_MNU_MPG_M","USER_GR_ID"),("SCM_ADM_USER_GR_MNU_BTN_MPG_M","USER_GR_ID"),("SCM_MST_AUTH_REQUEST","GROUP_ID")]:
    cur.execute(f"SELECT COUNT(*) FROM {t} WHERE {c}='/'"); n = cur.fetchone()[0]; assert n == 0, (t, n)
cur.execute("DELETE FROM SCM_ADM_USER_GR_M WHERE USER_GR_ID IN ('CAPA Planner','System Monitor','SSP ADMIN','/') AND CREATED_BY='admin' AND CREATION_DATE >= DATE '2026-10-15'")
print("deleted", cur.rowcount); cn.commit()
