"""[조회 전용] '-'→'/' 일괄 변환(DML) 위험 점검 2 — 모집단 밖 동명 컬럼의 '-' 보유 여부 (통계 1차 선별)

전수 읽기(영구 테이블 16억 행)는 공유 DB 부하가 커서 하지 않는다. 컬럼 통계의 최솟값(LOW_VALUE)으로 선별한다.
  '-'(0x2D) 는 숫자·영문보다 앞이라, 컬럼에 '-' 단독 값이 있으면 최솟값이 '-' 이거나 그보다 앞 문자(공백 ! " # $ % & ' ( ) * + ,)로 시작한다.
  → LOW = '-'  : '-' 보유 (통계 시점 기준 확정)
  → LOW < '-'  : 판정 불가 (실측 필요)   → LOW > '-' : '-' 없음 (통계 시점 기준)
결과 = _scan_stats.json  (통계가 없는 컬럼은 nostat)
"""
import sys, json, pathlib, datetime
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import s1_data_scan as s

HERE = pathlib.Path(__file__).resolve().parent
pop = s.population()
P = {(c["table"], c["column"]) for c in pop}
names = {c["column"] for c in pop}
cur = s.connect().cursor()
cur.execute("""SELECT C.TABLE_NAME, C.COLUMN_NAME, C.NULLABLE, C.DATA_TYPE, C.DATA_LENGTH, T.NUM_ROWS, T.TEMPORARY, T.PARTITIONED, T.ROW_MOVEMENT,
                      S.NUM_DISTINCT, S.NUM_NULLS, S.LOW_VALUE, S.HIGH_VALUE, TO_CHAR(S.LAST_ANALYZED,'YYYY-MM-DD HH24:MI'), S.HISTOGRAM,
                      C.DATA_DEFAULT
                 FROM ALL_TAB_COLUMNS C
                 JOIN ALL_TABLES T ON T.OWNER = C.OWNER AND T.TABLE_NAME = C.TABLE_NAME
                 LEFT JOIN ALL_TAB_COL_STATISTICS S ON S.OWNER = C.OWNER AND S.TABLE_NAME = C.TABLE_NAME AND S.COLUMN_NAME = C.COLUMN_NAME
                WHERE C.OWNER = 'SCM_MGR' AND C.DATA_TYPE IN ('VARCHAR2','CHAR','NVARCHAR2','NCHAR')""")
out = []
for t, c, nul, dt, dl, nr, tmp, part, rm, nd, nn, lo, hi, la, hist, dd in cur:
    inpop = (t, c) in P
    if not inpop and c not in names: continue
    def dec(raw):
        if raw is None: return None
        try: return bytes(raw).decode("utf-8", "replace")
        except Exception: return None
    los, his = dec(lo), dec(hi)
    if los is None: flag = "nostat"
    elif los == "-": flag = "dash"
    elif los < "-": flag = "unknown(low<'-')"
    else: flag = "none"
    out.append(dict(table=t, column=c, inpop=inpop, nullable=nul, dtype=dt, len=dl, num_rows=nr, temp=tmp, part=part, row_movement=rm,
                    ndv=nd, nulls=nn, low=los, high=his, analyzed=la, hist=hist, default=(str(dd).strip() if dd is not None else None), flag=flag))
(HERE / "_scan_stats.json").write_text(json.dumps(dict(at=str(datetime.datetime.now()), rows=out), ensure_ascii=False), encoding="utf-8")
import collections
print("전체", len(out), "모집단", sum(o["inpop"] for o in out))
print("모집단 밖·영구:", collections.Counter(o["flag"] for o in out if not o["inpop"] and o["temp"] == "N"))
print("모집단:", collections.Counter(o["flag"] for o in out if o["inpop"]))
