#!/usr/bin/env python3
"""
PKG_DMF0044 BODY 라인 정밀 치환 패처 (적용 전 assert — 전제 불일치 시 즉시 중단).

입력 : 00_BACKUP_PKG_DMF0044_BODY_LIVE.sql (ALL_SOURCE 전문 덤프 = 라이브 정본)
출력 : 01_PATCHED_PKG_DMF0044_BODY.sql
정정 : ①-1 [E20260820-CFMERGE]  ①-2 [E20260820-CFSETBASED]  ①-3 [E20260820-CFNOSTATS]
       ②   [E20260820-EXAUTH]  (환율 팝업 2 SP × UNION ALL 2 분기 = 4 site)
"""
import pathlib, sys

HERE = pathlib.Path(__file__).resolve().parent
SRC = HERE / "00_BACKUP_PKG_DMF0044_BODY_LIVE.sql"
DST = HERE / "01_PATCHED_PKG_DMF0044_BODY.sql"

lines = SRC.read_text(encoding="utf-8").split("\n")   # lines[i] == ALL_SOURCE LINE i+1


def L(n):  # 1-based
    return lines[n - 1]


def must(n, needle):
    if needle not in L(n):
        sys.exit(f"ASSERT FAIL @L{n}: expected {needle!r}\n  actual: {L(n)!r}")


# ── 전제 assert (치환 전 전량 확인) ───────────────────────────────────────────
must(1895, "PROCEDURE P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP")
must(2039, "PROCEDURE P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA")
must(4689, "PROCEDURE P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF")
must(6311, "PROCEDURE P_DMF0044_SAVE_TEXTBOX")          # _C_CF 범위 종단 확인

EXAUTH_SITES = [1951, 1976, 2096, 2121]                 # INNER JOIN 시작 라인
for n in EXAUTH_SITES:
    must(n, "INNER JOIN (SELECT * -- EDIT_YN")
    must(n + 1, "FROM SCM_ADM_USER_MNU_EDIT_AUTH_V")
    must(n + 2, "WHERE USER_ID = P_USER_ID")
    must(n + 3, "AND MNU_ID = P_MNU_ID")
    must(n + 4, "AND UNIT_TP_CD = 'D') T2")
    must(n + 5, "ON T1.DIVISION_ID = T2.UNIT_ID")
    assert 1895 <= n <= 2183, f"site {n} 이 환율 팝업 2 SP 범위 밖"

must(6188, "MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A")
must(6195, ") LOOKA ON (LOOKA.MODEL = A.ITEM_ID AND LOOKA.DIVISION_ID = A.DIVISION_ID)")
must(6196, "WHEN MATCHED THEN UPDATE")
must(6200, "A.LAST_UPDATE_DATE              = SYSDATE")
must(6201, "WHERE A.DIVISION_ID = '40' AND A.VERSION_NO = V_VERSION_NO;")
# WHEN NOT MATCHED 절 부재 = ON 이동 등가성의 전제
assert not any("WHEN NOT MATCHED" in L(n).upper() for n in range(6188, 6202)), \
    "WHEN NOT MATCHED 절 존재 — ON 이동 등가성 성립 안 함. 중단."

must(4905, "FOR REC IN (")
must(4906, "SELECT ROWID AS RID,")
must(4907, "DENSE_RANK() OVER")
must(4912, "UPDATE SCM_MGR.GT_0044_RESULTS_MST_C SET SEQ_RANK = REC.NEW_SEQ_RANK WHERE ROWID = REC.RID;")
must(4913, "END LOOP;")
must(4915, "FOR REC IN (")
must(4917, "ROW_NUMBER() OVER ( PARTITION BY SEQ_RANK")
must(4923, "UPDATE SCM_MGR.GT_0044_RESULTS_MST_C SET SEQ_ROWNUM = REC.NEW_SEQ_ROWNUM WHERE ROWID = REC.RID;")
must(4924, "END LOOP;")

must(4934, "-- GTT INSERT 후 통계 수집 (JOIN 사용)")
must(4935, "DBMS_STATS.GATHER_TABLE_STATS(")
must(4936, "tabname => 'GT_0044_RESULTS_MST_C'")
must(4937, "method_opt => 'FOR ALL COLUMNS SIZE 1');")
print("ASSERT: 전제 전량 통과")

# ── 치환 (라인 번호 역순 — 앞 구간 치환이 뒷 구간 번호를 흔들지 않게) ────────
CFMERGE = [
    "    ) LOOKA ON (LOOKA.MODEL = A.ITEM_ID AND LOOKA.DIVISION_ID = A.DIVISION_ID",
    "                --[E20260820-CFMERGE] 대상표 필터를 UPDATE WHERE 에서 ON 절로 이동.",
    "                --  이 MERGE 에는 WHEN NOT MATCHED 절이 없어 ON 에서 탈락한 행은 아무 동작도 하지 않으므로",
    "                --  갱신 대상 집합은 이동 전과 동일하다. ON 참조 컬럼(DIVISION_ID/VERSION_NO)은 SET 대상이",
    "                --  아니라 ORA-38104 도 없다. PK(VERSION_NO,DIVISION_ID) 선두 2컬럼을 필터로 태워",
    "                --  대상표 3.93M 행 전량 스캔을 피한다. 동일 PKG _C 판(L4413~4419)과 같은 형태.",
    "                AND A.DIVISION_ID = '40' AND A.VERSION_NO = V_VERSION_NO)",
]
lines[6201 - 1] = "    --[E20260820-CFMERGE] (구 WHERE A.DIVISION_ID = '40' AND A.VERSION_NO = V_VERSION_NO — ON 절로 이동)"
lines[6200 - 1] = L(6200).replace("= SYSDATE       --", "= SYSDATE;      --")
assert "SYSDATE;" in L(6200), "6200 종결자 부여 실패"
lines[6195 - 1: 6195] = CFMERGE

CFNOSTATS = [
    "    --[E20260820-CFNOSTATS] 저장 SP 본문의 GTT 통계수집 제거. 저장 1회마다 수집 비용이 붙고",
    "    --  단일 트랜잭션 중 부분 커밋 위험이 있다(DMF0082 계보 55s->11s 와 동일 조치).",
    "    --  카디널리티는 SP 도입부 ALTER SESSION SET optimizer_dynamic_sampling=2 로 확보한다.",
    "    --  (제거분: GT_0044_RESULTS_MST_C 대상 통계수집 호출 1건. 원문은 백업 00_BACKUP_..._LIVE.sql L4935~4937.",
    "    --   hook #138 에 따라 호출 원문을 주석으로 남기지 않는다 — 주석이 LIVE 코드로 오독/부활되는 사고 방지.)",
]
lines[4934 - 1: 4937] = CFNOSTATS

CFSETBASED = [
    "    --[E20260820-CFSETBASED] 행별 ROWID 커서 루프 2블록을 등가 set-based MERGE 2문으로 전환.",
    "    --  루프는 GTT 행수만큼 UPDATE 를 개별 실행(저장 1회에 수만 회 왕복)했다. MERGE 는 원 커서와",
    "    --  완전히 동일한 SELECT 집합을 USING 으로 쓰고 ROWID 로 1:1 매칭하므로 갱신 결과가 같다.",
    "    --  (원 루프도 커서 오픈 시점 스냅샷 기준이었고, 갱신 컬럼 SEQ_RANK/SEQ_ROWNUM 은 각 커서의",
    "    --   ORDER BY/PARTITION BY 입력에 자기 자신이 들어가지 않아 문장 단위 처리와 결과가 일치한다.)",
    "    MERGE INTO SCM_MGR.GT_0044_RESULTS_MST_C T",
    "    USING (",
    "        SELECT ROWID AS RID,",
    "               DENSE_RANK() OVER ( ORDER BY DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,",
    "                                             DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID,",
    "                                             ITEM_ID, SUBSTR(YYYYMMDD, 1, 6), CURRENCY ) AS NEW_SEQ_RANK",
    "        FROM SCM_MGR.GT_0044_RESULTS_MST_C",
    "    ) S",
    "    ON (T.ROWID = S.RID)",
    "    WHEN MATCHED THEN UPDATE SET T.SEQ_RANK = S.NEW_SEQ_RANK;",
    "",
    "    --[E20260820-CFSETBASED] 2번째 루프. SEQ_RANK 는 위 MERGE 가 같은 트랜잭션에서 확정한 값을 읽는다.",
    "    MERGE INTO SCM_MGR.GT_0044_RESULTS_MST_C T",
    "    USING (",
    "        SELECT ROWID AS RID,",
    "               ROW_NUMBER() OVER ( PARTITION BY SEQ_RANK",
    "                                   ORDER BY DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,",
    "                                            DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID,",
    "                                            ITEM_ID, SUBSTR(YYYYMMDD, 1, 6), CURRENCY ) AS NEW_SEQ_ROWNUM",
    "        FROM SCM_MGR.GT_0044_RESULTS_MST_C",
    "    ) S",
    "    ON (T.ROWID = S.RID)",
    "    WHEN MATCHED THEN UPDATE SET T.SEQ_ROWNUM = S.NEW_SEQ_ROWNUM;",
]
lines[4905 - 1: 4924] = CFSETBASED

for n in sorted(EXAUTH_SITES, reverse=True):
    indent = L(n)[: len(L(n)) - len(L(n).lstrip())]
    lines[n - 1] = L(n).replace("INNER JOIN (SELECT * -- EDIT_YN", "LEFT  JOIN (SELECT * -- EDIT_YN")
    lines[n - 1: n - 1] = [
        indent + "--[E20260820-EXAUTH] 권한 뷰 INNER JOIN 은 편집권한을 조회 필터로 만들어 AS-IS 에 없던 행 탈락을 낳는다",
        indent + "--  (AS-IS 원문 = DM_PLN_SALES_REPORT_EXCHANGE_C 단일 테이블 SELECT, JOIN 0건 / EDIT_YN 컬럼 없음).",
        indent + "--  LEFT JOIN 으로 조회 행수를 AS-IS 로 복원하고 편집 게이트는 NVL(T2.EDIT_YN,'N') 로 그대로 유지한다.",
        indent + "--  뷰가 (USER_ID,MNU_ID,UNIT_TP_CD,UNIT_ID) 로 GROUP BY 되어 있어 행 증식은 없다(실측 max 1행/키).",
    ]

out = "\n".join(lines)
DST.write_text(out, encoding="utf-8", newline="\n")

# ── 산출물 마커 카운트 ────────────────────────────────────────────────────────
for m, exp in (("[E20260820-CFMERGE]", 2), ("[E20260820-CFSETBASED]", 2),
               ("[E20260820-CFNOSTATS]", 1), ("[E20260820-EXAUTH]", 4)):
    got = out.count(m)
    print(f"  marker {m:26s} = {got} (expect {exp}) {'OK' if got == exp else '!! MISMATCH'}")
    if got != exp:
        sys.exit("marker count mismatch — 중단")
print(f"WROTE {DST.name}  ({len(lines)} lines, 원본 {len(SRC.read_text(encoding='utf-8').split(chr(10)))} lines)")
