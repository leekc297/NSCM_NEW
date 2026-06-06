# AS-IS TB_FX_ProgramInfo → Oracle SCM_ADM_PROGRAM INSERT (NOT EXISTS 멱등)
def esc(s, default=None):
    if s is None or s == 'NULL' or s == '':
        return "'" + default + "'" if default else "NULL"
    return "'" + s.replace("'", "''").replace(chr(31), '|') + "'"

OUT = []
with open('program.txt', 'r', encoding='utf-8', errors='replace') as f:
    for line in f:
        line = line.rstrip('\r\n')
        if not line.strip():
            continue
        parts = line.split('|')
        if len(parts) < 6:
            continue
        pid, pname, ppath, cname, useYn, regt = [p.strip() for p in parts[:6]]
        OUT.append(
            f"INSERT INTO SCM_MGR.SCM_ADM_PROGRAM (PROGRAM_ID, PROGRAM_NAME, PROGRAM_PATH, CLASS_NAME, USE_YN, REGT_USER_ID, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n"
            f"SELECT {esc(pid,'-')}, {esc(pname,'-')}, {esc(ppath,'-')}, {esc(cname,'-')}, {esc(useYn,'Y')}, {esc(regt,'system')}, 'system', SYSDATE, 'system', SYSDATE FROM DUAL\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_PROGRAM X WHERE X.PROGRAM_ID = {esc(pid,'-')});\n"
        )

with open('insert_program.sql', 'w', encoding='utf-8') as f:
    f.write("-- AS-IS TB_FX_ProgramInfo → SCM_ADM_PROGRAM import\n")
    f.write("\n".join(OUT))
    f.write("\nCOMMIT;\n")
print(f"insert_program.sql: {len(OUT)} rows")
