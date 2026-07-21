# -*- coding: utf-8 -*-
"""DMF0003 전체 이관 — 사내 SP/PKG DDL dump → sp/*.sql (CREATE OR REPLACE)."""
import io, importlib.util

spec = importlib.util.spec_from_file_location("ora", r"C:\Projects\NSCM\_artifacts\_diagnostics\ora.py")
ora = importlib.util.module_from_spec(spec); spec.loader.exec_module(ora)
import oracledb
u, p, d = ora.conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d); cur = cn.cursor()
OUT = r'C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0003_20260720_1625\sp'

# 화면 직접 사용 standalone SP (PROC_M/BTN 배선 대상) + PKG
cur.execute("""SELECT DISTINCT object_name, object_type FROM all_objects
   WHERE owner='SCM_MGR' AND object_type IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY')
     AND (object_name LIKE 'DMF0003%' OR object_name='PKG_DMF0003')
   ORDER BY object_name, object_type""")
objs = cur.fetchall()

def dump_source(name, otype):
    cur.execute("""SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line""",
                n=name, t=otype)
    lines = [r[0] for r in cur.fetchall()]
    if not lines: return None
    body = ''.join(lines)
    return "CREATE OR REPLACE " + body + "\n/\n"

manifest = []
for name, otype in objs:
    if otype == 'PACKAGE BODY':
        src = dump_source(name, 'PACKAGE BODY'); fn = name + '_BODY.sql'
    elif otype == 'PACKAGE':
        src = dump_source(name, 'PACKAGE'); fn = name + '_SPEC.sql'
    else:
        src = dump_source(name, otype); fn = name + '.sql'
    if not src: continue
    with io.open(OUT + '\\' + fn, 'w', encoding='utf-8', newline='\n') as f:
        f.write(src)
    manifest.append((fn, otype, len(src)))

# 매니페스트
with io.open(OUT + r'\_SP_MANIFEST.md', 'w', encoding='utf-8', newline='\n') as f:
    f.write("# DMF0003 SP/PKG DDL 매니페스트 (사내 실측 dump, CREATE OR REPLACE)\n\n")
    f.write("| 파일 | 종류 | 크기(KB) |\n|---|---|---:|\n")
    for fn, ot, sz in manifest:
        f.write("| %s | %s | %.1f |\n" % (fn, ot, sz/1024))
    f.write("\n> 적용 순서: PACKAGE(SPEC) → PACKAGE BODY → 나머지 PROCEDURE/FUNCTION. ")
    f.write("standalone DMF0003_SAVE_MKT_FCST 는 sql/02 의 p_authority 반영본을 우선(본 dump 는 현재 사내 상태=반영 완료본).\n")
    f.write("> ⚠ 의존 뷰(SCP_MST_BOD_V 등)·공유 함수(UP_FX_*)·GTT 는 별도 인프라 — 클라우드 기존재 가정. ")
    f.write("컴파일 오류 시 의존 객체 우선 확인.\n")

print("SP DUMP: %d objects" % len(manifest))
for fn, ot, sz in manifest:
    print("  %-52s %-14s %.1f KB" % (fn, ot, sz/1024))
