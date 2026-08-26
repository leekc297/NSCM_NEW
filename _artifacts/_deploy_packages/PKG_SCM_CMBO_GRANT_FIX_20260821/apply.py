#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""PKG_SCM_CMBO / T_CMBO_TAB / T_CMBO_ROW — 앱 계정 EXECUTE 권한 복구.

증상 (2026-08-21 21:51 BE 로그 실측)
    DMF0082 Division 조회조건이 빈 목록.
    BE 는 sesUserId 를 정상 전달했다:
        SELECT CODE, NAME FROM TABLE(SCM_MGR.PKG_SCM_CMBO.GET_DIVISION('minyonglee1'))
    그런데 실행에서
        ORA-00904: "SCM_MGR"."PKG_SCM_CMBO"."GET_DIVISION": 부적합한 식별자

원인
    · BE 접속 계정 = SCMP_APP (config-local.yml) ≠ SCM_MGR.
    · PKG_SCM_CMBO(08-21 20:13) / T_CMBO_TAB·T_CMBO_ROW(08-21 19:45) 가 당일 재생성되면서
      **EXECUTE 권한이 0건**이 됐다. 스키마 접두가 있어도 권한이 없으면 Oracle 은
      "부적합한 식별자"(ORA-00904)로 응답한다 → 콤보 0행 → 조회조건 빈 목록.
    · 같은 이름을 SCM_MGR 로 직접 실행하면 8행이 나와 "DB 는 정상" 으로 오판하기 쉽다.
      **반드시 앱 계정 권한을 따로 확인해야 한다.**

표준 부여 대상 (기존 PKG 들과 동일 패턴 — PKG_DMF0082 등 실측)
    SCMP_APP · SCMD_APP · RL_SCM_DML  <- EXECUTE

⚠ 파이프라인 TABLE() 호출은 패키지뿐 아니라 **반환 TYPE 2종에도 EXECUTE 가 필요**하다.
   패키지만 부여하면 ORA-00904 가 그대로 남는다.

멱등: 이미 있으면 건너뛴다. 실행: python apply.py   (점검만: python apply.py --dry)
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

OBJECTS = ["PKG_SCM_CMBO", "T_CMBO_TAB", "T_CMBO_ROW"]
GRANTEES = ["SCMP_APP", "SCMD_APP", "RL_SCM_DML"]


def missing(cur):
    out = []
    for obj in OBJECTS:
        for g in GRANTEES:
            cur.execute("""SELECT COUNT(*) FROM all_tab_privs
                            WHERE table_schema='SCM_MGR' AND table_name=:o
                              AND grantee=:g AND privilege='EXECUTE'""", o=obj, g=g)
            if cur.fetchone()[0] == 0:
                out.append((obj, g))
    return out


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    # 대상 객체 실존·유효 확인 (없는 객체에 GRANT 하면 오해를 남긴다)
    for obj in OBJECTS:
        cur.execute("""SELECT status FROM all_objects
                        WHERE owner='SCM_MGR' AND object_name=:o
                          AND object_type IN ('PACKAGE','TYPE') AND ROWNUM=1""", o=obj)
        row = cur.fetchone()
        if not row:
            sys.exit(f"[ABORT] SCM_MGR.{obj} 미존재 — 배포 상태부터 확인하십시오.")
        print(f"   {obj}: {row[0]}")

    need = missing(cur)
    print(f"== 누락 권한 {len(need)}건 ==")
    for obj, g in need:
        print(f"   MISSING  {g:12s} EXECUTE ON SCM_MGR.{obj}")
    if dry:
        print("== --dry: 변경 없이 종료 ==")
        con.close()
        return 0
    if not need:
        print("== 부여할 것이 없습니다 (이미 완료) ==")
        con.close()
        return 0

    for obj, g in need:
        cur.execute(f"GRANT EXECUTE ON SCM_MGR.{obj} TO {g}")
        print(f"   GRANTED  {g:12s} EXECUTE ON SCM_MGR.{obj}")

    left = missing(cur)
    print("== VERIFY ==")
    print(f"   {'PASS' if not left else 'FAIL'}  누락 권한 기대 0 / 실제 {len(left)}")
    for obj, g in left:
        print(f"      여전히 누락: {g} / {obj}")
    con.close()
    return 1 if left else 0


if __name__ == "__main__":
    sys.exit(main())
