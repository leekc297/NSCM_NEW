# 중복 신규('I') 1셀로 ADMIN 저장 SP 호출 → 결과 MSG = MSG00428 확인. 중복 검사에서 RAISE 되어 데이터 변경 없음 · 세션 ROLLBACK · 자율 트랜잭션 오류 로그 1행은 확인 후 삭제
import sys, datetime
sys.path.insert(0, 'tools/DbConn')
from dbconn import connect
with connect('tobe', write=True) as cx:
    cur = cx.cursor()
    cur.execute("""select division_id, company_id, plant_id, plan_start_yyyymmdd, operation_group, cell_item_id, item_id, measure, value_type, to_product, line_id, to_site, incoterms, yyyymm, attribute2
                   from scm_mgr.scp_anl_psi_integration where attribute2 is not null and rownum = 1""")
    k = cur.fetchone(); print('기존 행 키', k)
    cur.execute("select sysdate from dual"); t0 = cur.fetchone()[0]
    cur.execute("select count(*) from scm_mgr.scp_anl_psi_integration where last_update_date >= :t", t=t0); n0 = cur.fetchone()[0]
    rc = cur.var(__import__('oracledb').DB_TYPE_CURSOR)
    # 인자 순서 = ALL_ARGUMENTS(P_ACTIVE_FLAG, P_PLAN_TYPE, P_DIVISION_ID, P_COMPANY_ID, P_PLANT_ID, P_PLAN_START_YYYYMMDD, P_OPERATION_GROUP, P_CELLITEM_ID, P_ITEM_ID, P_MEASURE, P_VALUATION_TYPE, P_TO_PRODUCT, P_LINE_ID, P_TO_SITE, P_INCOTERMS, P_BOH_QTY, P_SEQ_FLAG, P_YYYYMM, P_MODIQTY, P_USER_ID)
    args = ['I', k[14], k[0], k[1], k[2], k[3], k[4], k[5], k[6], k[7], k[8], k[9], k[10], k[11], k[12], '0', '', k[13], '0', 'minyonglee1', rc]
    cur.callproc('SCM_MGR.PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN', args)
    r = rc.getvalue(); cols = [d[0] for d in r.description]; row = r.fetchone(); print('결과', dict(zip(cols, row)))
    cx.rollback()
    cur.execute("select count(*) from scm_mgr.scp_anl_psi_integration where last_update_date >= :t", t=t0); print('변경 행(전/후)', n0, cur.fetchone()[0])
    cur.execute("select rowid, program_name, log_type, substr(log_message,1,120) from scm_mgr.scm_sys_log_batch where program_name like 'SCP0111%' and event_date >= :t", t=t0)
    logs = cur.fetchall(); print('오류 로그', logs)
    for rid, *_ in logs:
        cur.execute("delete from scm_mgr.scm_sys_log_batch where rowid = :r", r=rid)
    cx.commit(); print('시험 로그 삭제', len(logs))
