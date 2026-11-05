import sys, csv
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
cols = ["COLUMN_NAME","COLUMN_LABEL_NAME","SORT_ORDER_NO","DATA_SORT_METHOD_CODE","SMALL_CLASS_LABEL_NAME","LARGE_CLASS_LABEL_NAME","FIXED_FLAG","COLUMN_WIDTH","CELL_CONTROL_OBJECT_TYPE_CODE","CELL_COMBO_DATA_TYPE","DATA_SCALE_NUMBER","DATA_MAX_LENGTH","HORIZONTAL_ALIGN_CODE","UPPERCASE_APPLY_FLAG","VISIBLE_FLAG","DIVISION_ID","DEFAULT_FLAG","USER_SELECTABLE_FLAG","VALID_YN","ATTRIBUTE1","ATTRIBUTE2","ATTRIBUTE3","ATTRIBUTE4","ATTRIBUTE5","INPUT_TP_CD"]
def norm(v):
    if v is None: return ''
    s=str(v).strip()
    if s.endswith('.0'): s=s[:-2]
    return s
a = dbconn.connect('asis'); c=a.cursor()
c.execute("SELECT "+",".join(cols)+" FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0111'")
asis={r[0]:dict(zip(cols,map(norm,r))) for r in c.fetchall()}
c.execute("SELECT DISTINCT SHEET_NAME FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0111'"); print('ASIS sheets',c.fetchall())
t = dbconn.connect('tobe'); d=t.cursor()
d.execute("SELECT "+",".join(cols)+" FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0111'")
tobe={r[0]:dict(zip(cols,map(norm,r))) for r in d.fetchall()}
print('asis',len(asis),'tobe',len(tobe))
print('only asis',sorted(set(asis)-set(tobe)),'only tobe',sorted(set(tobe)-set(asis)))
for k in sorted(set(asis)&set(tobe), key=lambda k:int(asis[k]['SORT_ORDER_NO'] or 0)):
    diffs=[(f,asis[k][f],tobe[k][f]) for f in cols if asis[k][f]!=tobe[k][f]]
    if diffs: print(k, diffs)
