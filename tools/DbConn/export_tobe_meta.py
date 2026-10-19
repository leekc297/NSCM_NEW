# -*- coding: utf-8 -*-
"""
export_tobe_meta — To-Be Oracle 메타를 CSV 로 내려 Doc\tobefacts\db\ 에 둔다 (gap.js / gen.js / E2E 생성기가 읽는다).
  python export_tobe_meta.py              전체 8종(+추가)
  python export_tobe_meta.py proc_meta    하나만
SELECT 만 실행한다. 헤더는 소문자(기존 export_tobe_meta.sql 과 동일 규격).
"""
import sys as _sys
try: _sys.stdout.reconfigure(encoding='utf-8', errors='replace'); _sys.stderr.reconfigure(encoding='utf-8', errors='replace')
except Exception: pass
import sys, os, json, datetime
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dbconn

HARNESS_JSON = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'Harness', 'harness.json')
cfg = dbconn.load_cfg()
tobe_out = json.load(open(HARNESS_JSON, encoding='utf-8-sig'))['tobeOutDir'] if os.path.exists(HARNESS_JSON) else r'C:\Projects\NSCM\Doc\tobefacts'
out_dir = os.path.join(tobe_out, 'db')

Q = {
 'proc_meta': """SELECT DISTINCT M.MNU_ID menu_id, NVL(BMP.SHT_NM,'_DEFAULT_') sheet, NVL(BMP.MNU_BTN_CD,'SEARCH') btn, BMP.API_ID api_id, API.API_URL proc,
        REGEXP_SUBSTR(API.API_URL,'^[^.]+') pkg, REGEXP_SUBSTR(API.API_URL,'[^.]+$') proc_nm, M.USE_YN use_yn
   FROM SCM_MGR.SCM_ADM_MNU_M M
   LEFT JOIN SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BMP ON BMP.MNU_ID = M.MNU_ID
   LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BMP.API_ID
  ORDER BY 1,2,3""",
 'proc_params': "SELECT PROC_NM proc, COL_NM col_nm, DATA_TP_CD data_tp_cd, COL_TP_CD col_tp_cd, SORT_ORD sort_ord FROM SCM_MGR.SCM_ADM_PROC_M ORDER BY 1,4,5",
 'sheet_columns': """SELECT PROGRAM_ID program_id, SHEET_NAME sheet_name, COLUMN_NAME column_name, COLUMN_LABEL_NAME column_label_name, SORT_ORDER_NO sort_order_no,
        VISIBLE_FLAG visible_flag, DEFAULT_FLAG default_flag, USER_SELECTABLE_FLAG user_selectable_flag, VALID_YN valid_yn, DIVISION_ID division_id,
        INPUT_TP_CD input_tp_cd, CELL_CONTROL_OBJECT_TYPE_CODE cell_control_object_type_code, COLUMN_WIDTH column_width, FIXED_FLAG fixed_flag
   FROM SCM_MGR.SCM_MST_SHEET_COLUMNS ORDER BY 1,2,5""",
 'sheet_measures': "SELECT * FROM SCM_MGR.SCM_MST_SHEET_MEASURE ORDER BY 1,2",
 'combo_sql': "SELECT SQL_ID sql_id, USE_YN use_yn, SQL_DTL_CTN sql_dtl_ctn FROM SCM_MGR.SCM_ADM_CMBO_SQL_M ORDER BY 1",
 'menu': "SELECT * FROM SCM_MGR.SCM_ADM_MNU_M ORDER BY MNU_ID",
 'msg_master': "SELECT * FROM SCM_MGR.SCM_ADM_MSG_M ORDER BY 1",
 'btn_auth': "SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M ORDER BY 1,2,3",
 # E2E 권한·Division 매트릭스용 (테이블명이 다르면 FAIL 로 표시되고 나머지는 계속)
 'user_group': "SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_M ORDER BY 1",
 'user_group_user': "SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M ORDER BY 1,2",
 'user_group_menu': "SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M ORDER BY 1,2",
 'users': "SELECT * FROM SCM_MGR.SCM_ADM_USER_M ORDER BY 1",
 'division': "SELECT * FROM SCM_MGR.SCM_MST_DIVISION ORDER BY 1",
 'unit_auth': "SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M ORDER BY 1,2,3",
 # 테이블/컬럼 카탈로그 — 이름이 다를 때 여기서 찾는다
 'tables': "SELECT TABLE_NAME table_name, NUM_ROWS num_rows FROM ALL_TABLES WHERE OWNER='SCM_MGR' ORDER BY 1",
 'columns': "SELECT TABLE_NAME table_name, COLUMN_NAME column_name, DATA_TYPE data_type, DATA_LENGTH data_length, NULLABLE nullable, COLUMN_ID column_id FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND (TABLE_NAME LIKE 'SCM_ADM%' OR TABLE_NAME LIKE 'SCM_MST%') ORDER BY 1,6",
 'procs_catalog': """SELECT P.OWNER owner, P.OBJECT_TYPE object_type, P.OBJECT_NAME object_name, P.PROCEDURE_NAME procedure_name, O.LAST_DDL_TIME last_ddl_time, O.STATUS status
   FROM ALL_PROCEDURES P JOIN ALL_OBJECTS O ON O.OWNER = P.OWNER AND O.OBJECT_NAME = P.OBJECT_NAME AND O.OBJECT_TYPE = P.OBJECT_TYPE
  WHERE P.OWNER='SCM_MGR' AND (P.OBJECT_TYPE='PROCEDURE' OR (P.OBJECT_TYPE='PACKAGE' AND P.PROCEDURE_NAME IS NOT NULL)) ORDER BY 3,4""",
}
names = sys.argv[1:] or list(Q)
cx = dbconn.connect('tobe', cfg)
print('접속:', dbconn.describe('tobe', cfg))
ok, fail = [], []
for n in names:
    try:
        cur = cx.cursor()
        cur.execute(Q[n])
        cnt = dbconn.write_csv(os.path.join(out_dir, n + '.csv'), cur)
        ok.append((n, cnt)); print(f"  {n}.csv  {cnt}행")
    except Exception as e:
        fail.append((n, dbconn.mask(str(e), cfg).splitlines()[0][:200])); print(f"  {n}: FAIL {fail[-1][1]}")
cx.close()
stamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
with open(os.path.join(out_dir, '_export_log.md'), 'a', encoding='utf-8') as f:
    f.write(f"\n## {stamp}\n" + ''.join(f"- {n}.csv {c}행\n" for n, c in ok) + ''.join(f"- {n}: FAIL {m}\n" for n, m in fail))
print(f"완료: {out_dir}  (성공 {len(ok)} / 실패 {len(fail)})")
sys.exit(1 if fail and not ok else 0)
