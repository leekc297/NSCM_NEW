# -*- coding: utf-8 -*-
"""02_load_scm_mst_site.py — 클라우드 추출본(scm_mst_site_cloud.dat)을 사내(로컬) Oracle 에 적재.

사용:
  python 02_load_scm_mst_site.py <dat 파일 경로> --dry   # 드라이런: 파싱·건수·변경 예상만 (DB 무변경)
  python 02_load_scm_mst_site.py <dat 파일 경로>         # 실적재: PK(DIVISION_ID, SCM_SITE_ID) MERGE UPSERT

방식: 전 39컬럼 MERGE — 기존재 행은 값 갱신(UPDATE), 부재 행은 INSERT. DELETE 없음(사내 전용 행 보존).
감사컬럼(CREATED_BY 등)은 데이터 이관이므로 **클라우드 원값 보존**. 적재 후 검증 요약 출력.
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "_diagnostics"))
from ora import conn_info  # noqa: E402

import oracledb  # noqa: E402

sys.stdout.reconfigure(encoding="utf-8", errors="replace")

COLS = ["DIVISION_ID", "SCM_SITE_ID", "PLANT_ID", "OPERATION_GROUP", "SITE_DESCRIPTION", "SITE_TYPE",
        "CITY", "COUNTRY", "VMI_YN", "VALID_YN", "NEW_YN", "SITE_HRCY_ID", "OSP_YN",
        "SHIP_FROZEN", "PROD_FROZEN", "END_CUSTOMER", "SOLDTO_CUSTOMER", "FP_PLAN_PERIOD", "BUILD_AHEAD",
        "LOGISTIC_PLANT_ID", "PACKER_ITEM_ID_SUFFIX", "HQ_VENDOR_CODE", "COMPANY_ID", "SITE_ID",
        "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE",
        "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5",
        "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "DEPT_ID"]
NUM_COLS = {"SHIP_FROZEN", "PROD_FROZEN", "FP_PLAN_PERIOD", "BUILD_AHEAD"}
DATE_COLS = {"CREATION_DATE", "LAST_UPDATE_DATE"}
PK = ["DIVISION_ID", "SCM_SITE_ID"]
SEP = "|@|"


def parse(path):
    rows = []
    bad = 0
    for raw in pathlib.Path(path).read_text(encoding="utf-8", errors="replace").splitlines():
        if not raw.strip():
            continue
        parts = raw.split(SEP)
        if len(parts) != len(COLS):
            bad += 1
            continue
        rec = {}
        for c, v in zip(COLS, parts):
            v = v.replace("\\n", "\n").replace("\\r", "\r")
            if v == "":
                rec[c] = None
            elif c in NUM_COLS:
                rec[c] = float(v) if "." in v else int(v)
            else:
                rec[c] = v
        rows.append(rec)
    return rows, bad


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 1
    path = sys.argv[1]
    dry = "--dry" in sys.argv
    rows, bad = parse(path)
    print(f"파싱: {len(rows)}행 (형식 불일치 skip {bad}건 — 0 이어야 정상)")
    if bad:
        print("⛔ 형식 불일치 행 존재 — 추출 스풀의 잘림/개행 확인 필요. 중단.")
        return 1
    u, pw, d = conn_info()
    con = oracledb.connect(user=u, password=pw, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT COUNT(*), COUNT(DEPT_ID) FROM SCM_MGR.SCM_MST_SITE")
    before_total, before_dept = cur.fetchone()
    print(f"사내 적재 전: {before_total}행 / DEPT_ID 보유 {before_dept}")
    if dry:
        cur.execute("SELECT DIVISION_ID || '|' || SCM_SITE_ID FROM SCM_MGR.SCM_MST_SITE")
        existing = {r[0] for r in cur.fetchall()}
        keys = {f"{r['DIVISION_ID']}|{r['SCM_SITE_ID']}" for r in rows}
        print(f"[dry] INSERT 예상 {len(keys - existing)} / UPDATE 예상 {len(keys & existing)}")
        print(f"[dry] 클라우드본 DEPT_ID 보유: {sum(1 for r in rows if r['DEPT_ID'])}")
        con.close()
        return 0
    set_cols = [c for c in COLS if c not in PK]
    sets = ", ".join(
        f"T.{c} = TO_DATE(:{c}, 'YYYYMMDDHH24MISS')" if c in DATE_COLS else f"T.{c} = :{c}"
        for c in set_cols)
    ins_vals = ", ".join(
        f"TO_DATE(:{c}, 'YYYYMMDDHH24MISS')" if c in DATE_COLS else f":{c}" for c in COLS)
    stmt = f"""MERGE INTO SCM_MGR.SCM_MST_SITE T
USING (SELECT :DIVISION_ID AS DIVISION_ID, :SCM_SITE_ID AS SCM_SITE_ID FROM DUAL) S
ON (T.DIVISION_ID = S.DIVISION_ID AND T.SCM_SITE_ID = S.SCM_SITE_ID)
WHEN MATCHED THEN UPDATE SET {sets}
WHEN NOT MATCHED THEN INSERT ({', '.join(COLS)}) VALUES ({ins_vals})"""
    # executemany 는 dict 바인드 목록 — MERGE 의 USING 바인드가 SET 절과 이름 겹치므로 전 키 전달
    BATCH = 500
    done = 0
    for i in range(0, len(rows), BATCH):
        cur.executemany(stmt, rows[i:i + BATCH])
        done += len(rows[i:i + BATCH])
    con.commit()
    print(f"MERGE 완료: {done}행 처리")
    cur.execute("SELECT COUNT(*), COUNT(DEPT_ID) FROM SCM_MGR.SCM_MST_SITE")
    after_total, after_dept = cur.fetchone()
    cur.execute("""SELECT COUNT(DISTINCT A.DEPT_ID) FROM SCM_MGR.SCM_MST_SITE A
                   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO B ON A.DEPT_ID = B.DEPT_ID
                   WHERE A.SITE_TYPE = 'SALES' AND A.DIVISION_ID = '81'""")
    sales81 = cur.fetchone()[0]
    print(f"사내 적재 후: {after_total}행 / DEPT_ID 보유 {after_dept} / SALES·81 부서(SSO 조인) {sales81}팀")
    print("→ DMF0021 Team 콤보(81) 기대: AS-IS ~30팀 수준 복원 (브라우저 새로고침 후 확인)")
    con.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
