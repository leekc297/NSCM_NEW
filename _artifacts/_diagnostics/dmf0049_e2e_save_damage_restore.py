#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0049_e2e_save_damage_restore.py — E2E SAVE 왕복이 훼손한 1셀 복원 (2026-08-11)

## 사고
`ui_http_e2e.py --menu DMF0049` 의 F축(SAVE 왕복 M +1 → 원복)이 **원복에 실패**하고
실데이터 1행을 바꿔 놓았다.

대상 키: DIVISION_ID='40' / VERSION_NO='R_S_20260128_V002_C' / DATA_SEQ=120
        / MEASURE='SalesAmt_KRW' / YYYYMMDD='20250701'

| 항목 | 사고 전(추정 기준선) | 사고 후(현재) |
|---|---|---|
| QTY | 0.0 | **655826.0** |
| NICK_NAME | NULL | **'M53F1A'** |
| FORECAST_INFO_SPEC | NULL | **'21700'** |
| LAST_UPDATE_DATE | 2026-01-28 10:44 | 2026-08-11 14:04 |

## 기준선 근거 (추정 아님 — 실측 2종)
① **형제 11개월 전수**: 같은 (DATA_SEQ=120, SalesAmt_KRW) 의 나머지 11개월이 **전부**
   QTY=0.0 / NICK_NAME=NULL / FORECAST_INFO_SPEC=NULL / LAST_UPDATE=2026-01-28 10:44 이다.
   20250701 만 오늘 14:04 로 튄다.
② **이력 전수**: `DM_PLN_SALES_ETC_REPORT_H` 에서 이 키(**VERSION_NO 포함**)의 이력은
   오늘 내 쓰기 2건(14:02 655827 / 14:04 655826)이 전부다. 그 이전 이력이 없다
   ⇒ 01-28 최초 적재 이후 오늘까지 변경된 적이 없다.
   ⚠ VERSION_NO 를 빼고 조회하면 '기타매출' 이력 31건이 섞여 나온다(**다른 버전**) — 오판 주의.
③ 값의 출처: 이 버전 전체에서 NICK_NAME='M53F1A' 인 행은 **이 행 하나뿐**이다
   ⇒ 다른 행에서 옮겨온 게 아니라 조회 PIVOT 표시값(SUM)과 저장 SP 보강값이 되쓰인 것.

## 조치
해당 1행을 기준선으로 되돌린다. QTY/NICK_NAME/FORECAST_INFO_SPEC 3컬럼만 건드리고
감사컬럼은 'admin' 규약을 따른다. **DELETE 하지 않는다**(행 자체는 01-28 적재분이 맞다).

사용:
  python dmf0049_e2e_save_damage_restore.py --show / --restore
"""
import argparse
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

KEY = dict(div="40", ver="R_S_20260128_V002_C", seq=120,
           mea="SalesAmt_KRW", ymd="20250701")

_WHERE = """ WHERE DIVISION_ID = :div AND VERSION_NO = :ver AND DATA_SEQ = :seq
               AND MEASURE = :mea AND YYYYMMDD = :ymd """

_SEL_SIB = """
SELECT YYYYMMDD, QTY, NVL(NICK_NAME,'<NULL>'), NVL(FORECAST_INFO_SPEC,'<NULL>'),
       TO_CHAR(LAST_UPDATE_DATE,'MM-DD HH24:MI')
  FROM DM_PLN_SALES_ETC_REPORT_C
 WHERE DIVISION_ID = :div AND VERSION_NO = :ver AND DATA_SEQ = :seq AND MEASURE = :mea
 ORDER BY YYYYMMDD
"""


def _dump(cur):
    # ⚠ 형제 조회는 YYYYMMDD 를 묶지 않는다 — :ymd 를 넘기면 DPY-4008(미사용 바인드)
    cur.execute(_SEL_SIB, div=KEY["div"], ver=KEY["ver"], seq=KEY["seq"], mea=KEY["mea"])
    print("  %-9s %12s %-10s %-8s %s" % ("YYYYMMDD", "QTY", "NICK", "SPEC", "UPD"))
    off = 0
    for ymd, qty, nick, spec, upd in cur.fetchall():
        mark = "  ← 대상" if ymd == KEY["ymd"] else ""
        if ymd != KEY["ymd"] and (qty != 0 or nick != "<NULL>" or spec != "<NULL>"):
            off += 1
        print("  %-9s %12s %-10s %-8s %s%s" % (ymd, qty, nick, spec, upd, mark))
    print("  형제 중 기준선(0.0/NULL/NULL) 이탈 = %d건 (0 이어야 복원 근거가 성립)" % off)


def cmd_show():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        _dump(con.cursor())
    return 0


def cmd_restore():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        print("[before]")
        _dump(cur)
        cur.execute("""
            UPDATE DM_PLN_SALES_ETC_REPORT_C
               SET QTY = 0, NICK_NAME = NULL, FORECAST_INFO_SPEC = NULL,
                   LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
        """ + _WHERE, **KEY)
        n = cur.rowcount
        print("\n[update] %d행 (기대 1)" % n)
        if n != 1:
            con.rollback()
            sys.exit("[error] %d행 — 롤백" % n)
        con.commit()
        print("\n[after]")
        _dump(cur)
    return 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--show", action="store_true")
    ap.add_argument("--restore", action="store_true")
    a = ap.parse_args()
    if a.show:
        sys.exit(cmd_show())
    if a.restore:
        sys.exit(cmd_restore())
    ap.error("--show / --restore 중 하나 필요")


if __name__ == "__main__":
    main()
