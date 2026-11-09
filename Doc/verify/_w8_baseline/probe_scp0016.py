import sys, time, datetime
sys.path.insert(0,'tools/DbConn'); import dbconn, golden
cfg=dbconn.load_cfg(); ca=dbconn.connect('asis',cfg); ct=dbconn.connect('tobe',cfg)
log=lambda *a: print(datetime.datetime.now().strftime('%H:%M:%S'), *a, flush=True)
c=ca.cursor()
for q in ["SELECT TOP 5 VERSION_NO, COUNT(*) FROM SCP_ANL_SHIPMENT_PLAN_FG_C WHERE DIVISION_ID='40' GROUP BY VERSION_NO ORDER BY VERSION_NO DESC",
          "SELECT COUNT(*) FROM SCP_ANL_SHIPMENT_PLAN_FG_C WHERE DIVISION_ID='40' AND VERSION_NO='SP_W_20260824'",
          "SELECT TOP 6 USER_ID, COUNT(*) FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID='SCP0016' GROUP BY USER_ID"]:
    t=time.time()
    try: c.execute(q); log('AS-IS:', q[:70], '→', c.fetchall(), f'{time.time()-t:.1f}s')
    except Exception as e: log('AS-IS ERR', q[:50], str(e)[:160])
c2=ct.cursor()
for q in ["SELECT * FROM (SELECT VERSION_NO, COUNT(*) n FROM SCP_ANL_SHIPMENT_PLAN_FG_C WHERE DIVISION_ID='40' GROUP BY VERSION_NO ORDER BY VERSION_NO DESC) WHERE ROWNUM<=5",
          "SELECT USER_ID, COUNT(*) FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID='SCP0016' GROUP BY USER_ID"]:
    t=time.time()
    try: c2.execute(q); log('TO-BE:', q[:70], '→', c2.fetchall()[:6], f'{time.time()-t:.1f}s')
    except Exception as e: log('TO-BE ERR', q[:50], str(e)[:160])
base={"p_from_yyyymmdd":"20260824","p_to_yyyymmdd":"20270822","p_division_id":"40","p_biz_type":"P","p_project_code":"","p_item_id":"","p_version_no":"SP_W_20260824","p_electype":"","p_program_id":"SCP0016","p_sheet_name":"Shipment Plan FG","debug_mode":"F","p_user_id":"minyonglee1"}
for label, ps in [('user minyonglee1 debug F', base), ('user bpark416', {**base,'p_user_id':'bpark416'})]:
    t=time.time()
    try: s=golden.run_asis(ca,'SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL',ps); log(label,'→ AS-IS sets', [len(x[1]) for x in s], 'cols', (s[0][0][:8] if s and s[0][0] else None), f'{time.time()-t:.1f}s')
    except Exception as e: log(label,'ERR',str(e)[:200], f'{time.time()-t:.1f}s')
ca.rollback(); ct.rollback(); ca.close(); ct.close(); log('DONE')
