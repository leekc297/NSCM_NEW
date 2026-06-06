# AS-IS DQ pipe-delim dump → Oracle INSERT SQL (NOT EXISTS 멱등)
# 사용: python convert_to_oracle.py
import sys

def esc(s, default=None):
    """Oracle string literal escape. default = string fallback for NOT NULL columns."""
    if s is None or s == 'NULL' or s == '':
        if default is not None:
            return "'" + default + "'"
        return "NULL"
    return "'" + s.replace("'", "''") + "'"

def to_date(s):
    if not s or s == 'NULL':
        return "SYSDATE"
    return f"TO_DATE('{s}', 'YYYY-MM-DD HH24:MI:SS')"

def to_num(s):
    if not s or s == 'NULL':
        return "NULL"
    return s.strip()

# Convert CHAR(31) back to '|' (we escaped pipe inside DQ_NAME/DESC/TEXT)
def unescape_pipe(s):
    return s.replace(chr(31), '|') if s else s

OWNER = 'SCM_MGR'

def process(infile, table, columns, types, pk_cols, defaults=None):
    """
    columns: list of (col_name, idx)
    types: dict col_name -> 'str' | 'num' | 'date'
    pk_cols: list of col_names for NOT EXISTS clause
    defaults: dict col_name -> string fallback (for NOT NULL cols)
    """
    defaults = defaults or {}
    with open(infile, 'r', encoding='utf-8', errors='replace') as f:
        lines = [l.rstrip('\r\n') for l in f if l.strip()]
    out = []
    for line in lines:
        parts = line.split('|')
        if len(parts) < len(columns):
            continue
        vals = {}
        for col, idx in columns:
            raw = parts[idx].strip() if idx < len(parts) else ''
            raw = unescape_pipe(raw)
            t = types.get(col, 'str')
            if t == 'num':
                vals[col] = to_num(raw)
            elif t == 'date':
                vals[col] = to_date(raw)
            else:
                vals[col] = esc(raw, defaults.get(col))
        col_list = ', '.join(c for c, _ in columns)
        val_list = ', '.join(vals[c] for c, _ in columns)
        # NOT EXISTS pk check
        where = ' AND '.join(f'X.{c} = {vals[c]}' for c in pk_cols)
        out.append(
            f"INSERT INTO {OWNER}.{table} ({col_list})\n"
            f"SELECT {val_list} FROM DUAL\n"
            f"WHERE NOT EXISTS (SELECT 1 FROM {OWNER}.{table} X WHERE {where});\n"
        )
    return out

# ============================================================================
# 1. SCM_ADM_DQ_LIST (11 col: DQ_ID, DIVISION_ID, DQ_NAME, DESCRIPTION, DQ_TEXT, VALID_YN, ADMIN_ONLY_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
# ============================================================================
out = process(
    'dq_list.txt', 'SCM_ADM_DQ_LIST',
    [('DQ_ID',0),('DIVISION_ID',1),('DQ_NAME',2),('DESCRIPTION',3),('DQ_TEXT',4),
     ('VALID_YN',5),('ADMIN_ONLY_YN',6),('CREATED_BY',7),('CREATION_DATE',8),
     ('LAST_UPDATED_BY',9),('LAST_UPDATE_DATE',10)],
    {'DQ_ID':'num','CREATION_DATE':'date','LAST_UPDATE_DATE':'date'},
    ['DQ_ID'],
    defaults={'DIVISION_ID':'-','DQ_NAME':'-','DESCRIPTION':'-','DQ_TEXT':'-',
              'VALID_YN':'Y','ADMIN_ONLY_YN':'N','CREATED_BY':'system','LAST_UPDATED_BY':'system'}
)
with open('insert_dq_list.sql', 'w', encoding='utf-8') as f:
    f.write("-- AS-IS SCM_ADM_DQ_LIST import (auto-generated)\n")
    f.write("\n".join(out))
    f.write("\nCOMMIT;\n")
print(f"insert_dq_list.sql: {len(out)} rows")

# ============================================================================
# 2. SCM_ADM_DQ_COLUMN
# ============================================================================
out = process(
    'dq_column.txt', 'SCM_ADM_DQ_COLUMN',
    [('DQ_ID',0),('COLUMN_NAME',1),('VALUE_YN',2),('VALUE_TYPE',3),('VALID_YN',4),
     ('CREATED_BY',5),('CREATION_DATE',6),('LAST_UPDATED_BY',7),('LAST_UPDATE_DATE',8)],
    {'DQ_ID':'num','CREATION_DATE':'date','LAST_UPDATE_DATE':'date'},
    ['DQ_ID','COLUMN_NAME'],
    defaults={'COLUMN_NAME':'-','VALUE_YN':'N','VALUE_TYPE':'-','VALID_YN':'Y',
              'CREATED_BY':'system','LAST_UPDATED_BY':'system'}
)
with open('insert_dq_column.sql', 'w', encoding='utf-8') as f:
    f.write("-- AS-IS SCM_ADM_DQ_COLUMN import\n")
    f.write("\n".join(out))
    f.write("\nCOMMIT;\n")
print(f"insert_dq_column.sql: {len(out)} rows")

# ============================================================================
# 3. SCM_ADM_DQ_PARAMETER
# ============================================================================
out = process(
    'dq_parameter.txt', 'SCM_ADM_DQ_PARAMETER',
    [('DQ_ID',0),('PARAMETER_ID',1),('PARAMETER_TYPE',2),('OPERATION_ID',3),
     ('VALID_YN',4),('REP_YN',5),('CREATED_BY',6),('CREATION_DATE',7),
     ('LAST_UPDATED_BY',8),('LAST_UPDATE_DATE',9)],
    {'DQ_ID':'num','CREATION_DATE':'date','LAST_UPDATE_DATE':'date'},
    ['DQ_ID','PARAMETER_ID'],
    defaults={'PARAMETER_ID':'-','PARAMETER_TYPE':'-','OPERATION_ID':'-',
              'VALID_YN':'Y','REP_YN':'N','CREATED_BY':'system','LAST_UPDATED_BY':'system'}
)
with open('insert_dq_parameter.sql', 'w', encoding='utf-8') as f:
    f.write("-- AS-IS SCM_ADM_DQ_PARAMETER import\n")
    f.write("\n".join(out))
    f.write("\nCOMMIT;\n")
print(f"insert_dq_parameter.sql: {len(out)} rows")

# ============================================================================
# 4. SCM_ADM_DQ_USER_GROUP
# ============================================================================
out = process(
    'dq_user_group.txt', 'SCM_ADM_DQ_USER_GROUP',
    [('DQ_ID',0),('GROUP_ID',1),('VALID_YN',2),('CREATED_BY',3),
     ('CREATION_DATE',4),('LAST_UPDATED_BY',5),('LAST_UPDATE_DATE',6)],
    {'DQ_ID':'num','CREATION_DATE':'date','LAST_UPDATE_DATE':'date'},
    ['DQ_ID','GROUP_ID'],
    defaults={'GROUP_ID':'-','VALID_YN':'Y','CREATED_BY':'system','LAST_UPDATED_BY':'system'}
)
with open('insert_dq_user_group.sql', 'w', encoding='utf-8') as f:
    f.write("-- AS-IS SCM_ADM_DQ_USER_GROUP import\n")
    f.write("\n".join(out))
    f.write("\nCOMMIT;\n")
print(f"insert_dq_user_group.sql: {len(out)} rows")

print("DONE")
