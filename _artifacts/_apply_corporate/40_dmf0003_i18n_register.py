#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
40_dmf0003_i18n_register.py
===============================================================================
DMF0003 (mkt-fcst) i18n MSG/LBL 사내 등록 handoff — 멱등(idempotent).

목적
  DMF0003 화면이 런타임에 사용하는 MSG/LBL 키 중, 사내 SCM_ADM_MSG_M 에
  실측(2026-06-28) 결과 "미존재"로 확인된 진짜 신규 키만 KO/EN/CN 3행씩 등록.
  기존 정확 텍스트 일치 키(MSG00004 / LBL00001·00003·00005·00011·00013·00024·
  00032·00044·00068·00080·00082·00085·00090·00310)는 재사용 → 본 스크립트 미포함.

근거(실측, READ 전용)
  - 사내 MAX(LBL)=LBL00678 → 신규 LBL00679+.
  - 사내 MAX(MSG, sentinel 제외)=MSG00630 → 신규 MSG00631+.
  - GSCM-era MSG ID(MSG00002 등)는 사내 의미 불일치(MSG00002='성공적으로 저장되었습니다.')
    → AS-IS 한글 원문 텍스트 매칭(READ) 후 재채번. MSG00004='저장하시겠습니까?' 만 정확 일치 재사용.

대상 분류
  [A] new_corporate     : DMF0003 신규 정식 채번 (LBL00679~00717 gap 포함 / MSG00631~00653).
                          (LBL00710=bucket #5, LBL00711~00717=Column/Measure 버튼·모달 #3 포함)
  [B] shared_cross_screen: 타화면(sales-future-price 등)과 공유하며 사내 미존재인 키
       (LBL00665/00666/00669, MSG00606/00618). 멱등 skip-if-exists 로 중복등록 방지.
       DMF0003 가 의존하므로 화면 자급 차원에서 포함(이미 다른 handoff 가 등록했으면 skip).

NOT NULL 전수 보강 (desc SCM_ADM_MSG_M 2026-06-28):
  MSG_ID / LANG_CD / MSG_TP_CD / USE_YN / CREATED_BY / CREATION_DATE /
  LAST_UPDATED_BY / LAST_UPDATE_DATE = 전부 NOT NULL → 명시.
  MSG_NM / MSG_DESC = nullable (MSG_DESC = MSG_NM 동일 입력).

멱등성
  --mode skip   (default) : (MSG_ID, LANG_CD) 존재 시 INSERT 건너뜀.
  --mode replace          : 동일 (MSG_ID, LANG_CD) DELETE 후 INSERT (본문 갱신용).

실행
  사내 접속(READ/WRITE 공용 env):
    export NSCM_ORA_USER='SCM_MGR' NSCM_ORA_PASS='!SCMroqkf2026' \
           NSCM_ORA_DSN='121.162.245.167:2521/OCGSCMD_P01'
  검토(쓰기 없음, 기본)        : python 40_dmf0003_i18n_register.py
  실제 적용(commit)            : python 40_dmf0003_i18n_register.py --apply
  본문 갱신 재적용             : python 40_dmf0003_i18n_register.py --apply --mode replace

  ⚠️ --apply 없으면 dry-run: 채번 재확인 + 대상/skip 집계만 출력하고 절대 쓰지 않음.
     (작성자 검토 후 직접 --apply — 본 작업은 적용 보류.)
===============================================================================
"""
import os
import sys
import argparse

TABLE = "SCM_MGR.SCM_ADM_MSG_M"
CREATED_BY = "admin"  # 기존 200_AS_IS_MSG_codes_register.sql 선례와 동일.

# -----------------------------------------------------------------------------
# 등록 대상 (ID -> (TP, {KO,EN,CN}))  ※ FE 코드/locale 와 1:1 정합.
# -----------------------------------------------------------------------------
NEW_CORPORATE = {
    # --- 컬럼 라벨 신규 (division.ts) ---
    "LBL00679": ("LBL", "FCST Type", "FCST Type", "FCST Type"),
    "LBL00680": ("LBL", "Customs Handbook", "Customs Handbook", "Customs Handbook"),
    # --- 조회조건/폼 라벨 신규 (MktFcstForm.tsx — 사내 동ID 텍스트 불일치로 재채번) ---
    "LBL00682": ("LBL", "Daily", "Daily", "Daily"),
    "LBL00683": ("LBL", "Weekly", "Weekly", "Weekly"),
    "LBL00684": ("LBL", "Monthly", "Monthly", "Monthly"),
    "LBL00685": ("LBL", "AS", "AS", "AS"),
    "LBL00686": ("LBL", "Project", "Project", "Project"),
    "LBL00687": ("LBL", "Sum", "Sum", "Sum"),
    "LBL00688": ("LBL", "Color", "Color", "Color"),
    "LBL00689": ("LBL", "Qty ≥ 0", "Qty ≥ 0", "Qty ≥ 0"),
    "LBL00690": ("LBL", "Cell Qty", "Cell Qty", "Cell Qty"),
    "LBL00691": ("LBL", "Search", "Search", "Search"),
    # --- 모달 헤더/필드 라벨 신규 (modals) ---
    "LBL00694": ("LBL", "SSP Sync Compare", "SSP Sync Compare", "SSP Sync Compare"),
    "LBL00695": ("LBL", "SSP Sync Result", "SSP Sync Result", "SSP Sync Result"),
    "LBL00696": ("LBL", "PR Request", "PR Request", "PR Request"),
    "LBL00697": ("LBL", "PR Header", "PR Header", "PR Header"),
    "LBL00698": ("LBL", "Purchasing Mgr", "Purchasing Mgr", "Purchasing Mgr"),
    "LBL00699": ("LBL", "Purchasing Group", "Purchasing Group", "Purchasing Group"),
    "LBL00700": ("LBL", "PR History", "PR History", "PR History"),
    "LBL00701": ("LBL", "Master Change", "Master Change", "主数据变更"),
    # --- PR contextMenu 메시지 (prContext.ts — AS-IS MessageBox.Show 원문, LBL 신규) ---
    "LBL00702": ("LBL", "일자컬럼에서만 사용가능합니다.", "Available only on date columns.", "仅可用于日期列。"),
    "LBL00703": ("LBL", "실적 구간이 포함되어 있습니다.", "Selection includes the actual (past) period.", "选择范围包含实绩区间。"),
    "LBL00704": ("LBL", "Request 할 내용이 없습니다.", "There is nothing to request.", "没有可请求的内容。"),
    "LBL00705": ("LBL", "Model 은 중복될 수 없습니다.", "Model must not be duplicated.", "Model 不能重复。"),
    "LBL00706": ("LBL", "Project 는 동일해야 합니다.", "Project must be identical.", "Project 必须相同。"),
    "LBL00707": ("LBL", "한 개의 셀만 선택할 수 있습니다.", "Only one cell can be selected.", "只能选择一个单元格。"),
    "LBL00708": ("LBL", "BNP In 메저행에서만 사용가능합니다.", "Available only on the BNP In measure row.", "仅可用于 BNP In 度量行。"),
    "LBL00709": ("LBL", "선택된 셀이 없습니다.", "No cell is selected.", "未选择任何单元格。"),
    # --- 조회조건 Bucket 라벨 신규 (#5) ---
    #   사내 LBL00032='Sales Bucket'(타화면 공유) 수정 금지 → DMF0003 전용 'bucket' 신규 채번.
    "LBL00710": ("LBL", "bucket", "bucket", "bucket"),
    # --- #3 Column / Measure 버튼 + Measure 선택 모달 라벨 신규 ---
    "LBL00711": ("LBL", "Column", "Column", "列"),
    "LBL00712": ("LBL", "Measure", "Measure", "度量"),
    "LBL00713": ("LBL", "Measure 를 1개 이상 선택하세요.", "Select at least one measure.", "请至少选择一个度量。"),
    "LBL00714": ("LBL", "전체 선택", "Select All", "全选"),
    "LBL00715": ("LBL", "전체 해제", "Deselect All", "全部取消"),
    "LBL00716": ("LBL", "확인", "OK", "确定"),
    "LBL00717": ("LBL", "취소", "Cancel", "取消"),

    # --- Validation MSG 신규 (constants.ts MSG 객체) ---
    "MSG00631": ("MSG", "[{0}] 은 필수 입력사항입니다.", "[{0}] is a required field.", "[{0}] 是必填项。"),
    "MSG00632": ("MSG", "MKT FCST 수량이 입력된 일자가 없습니다.", "No date has MKT FCST quantity entered.", "没有输入 MKT FCST 数量的日期。"),
    "MSG00633": ("MSG", "저장시 중복 오류가 발생하였습니다. {0}", "A duplication error occurred during save. {0}", "保存时发生重复错误. {0}"),
    "MSG00634": ("MSG", "0 보다 큰 수를 입력하세요.", "Please enter a number greater than 0.", "请输入大于0的数。"),
    "MSG00635": ("MSG", "Division 을 선택하세요.", "Please select a Division.", "请选择 Division。"),
    "MSG00636": ("MSG", "조회 기간이 잘못되었습니다 (시작일 > 종료일).", "The search period is invalid (start date > end date).", "查询期间无效 (开始 > 结束)。"),
    "MSG00637": ("MSG", "복사할 데이터를 선택하세요.", "Please select the data to copy.", "请选择要复制的数据。"),
    "MSG00638": ("MSG", "조회 기간은 3년 이내로 입력해주세요.", "Please enter a search period within 3 years.", "请输入3年以内的查询期间。"),
    "MSG00639": ("MSG", "실적 수량보다 작은 숫자를 넣을 수 없습니다.", "You cannot enter a number smaller than the actual quantity.", "不能输入小于实绩数量的数字。"),
    "MSG00640": ("MSG", "Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.", "Bucket cannot be changed because there are inserted rows.", "存在 Insert 行时无法更改 Bucket。"),
    "MSG00641": ("MSG", "조회 후 수정모드로 가능합니다.", "Available only in edit mode after search.", "查询后可进入修改模式。"),
    "MSG00642": ("MSG", "신규 입력 데이터 중 중복된 데이터가 있습니다.", "There is duplicated data among the newly entered data.", "新输入的数据中存在重复数据。"),
    "MSG00643": ("MSG", "AS From-Site 를 ALL 로 저장할 수 없습니다.", "AS From-Site cannot be saved as ALL.", "AS From-Site 不能以 ALL 保存。"),
    "MSG00644": ("MSG", "유효하지 않은 FCST Type 코드입니다.", "The FcstType code is invalid.", "无效的 FCST Type 代码。"),
    "MSG00645": ("MSG", "조회 기간을 입력하세요.", "Please enter a search period.", "请输入查询期间。"),
    "MSG00646": ("MSG", "저장할 데이터가 없습니다.", "There is no data to save.", "没有要保存的数据。"),
    "MSG00649": ("MSG", "PR 을 발행하시겠습니까?", "Do you want to issue the PR?", "是否发行 PR？"),
    "MSG00650": ("MSG", "PR 이 발행되었습니다.", "The PR has been issued.", "PR 已发行。"),
    "MSG00651": ("MSG", "PR 발행에 실패했습니다.", "Failed to issue the PR.", "PR 发行失败。"),
    "MSG00652": ("MSG", "이력이 없습니다.", "No history found.", "没有找到历史记录。"),
    "MSG00653": ("MSG",
                 "Master Change 는 SP 설정(DMF0000_GET_MASTER_CHG_POPUP)이 필요합니다. 사내 DB 적용 대기 중.",
                 "Master Change requires SP setup (DMF0000_GET_MASTER_CHG_POPUP). Pending corporate DB apply.",
                 "Master Change 需要 SP 设置(DMF0000_GET_MASTER_CHG_POPUP)，等待内部 DB 应用。"),
}

SHARED_CROSS_SCREEN = {
    "LBL00665": ("LBL", "Loading...", "Loading...", "Loading..."),
    "LBL00666": ("LBL", "Only new rows can be deleted.", "Only new rows can be deleted.", "Only new rows can be deleted."),
    "LBL00669": ("LBL", "Model", "Model", "Model"),
    "MSG00606": ("MSG", "데이터가 저장되었습니다.", "Data has been saved.", "数据已保存."),
    "MSG00618": ("MSG", "저장 중 오류가 발생했습니다.", "An error occurred while saving.", "保存时发生错误."),
}

LANGS = ("KO", "EN", "CN")
INS_SQL = (
    "INSERT INTO " + TABLE + " "
    "(MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, "
    " CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) "
    "VALUES (:id, :lang, :nm, :nm, :tp, 'Y', :cb, SYSDATE, :cb, SYSDATE)"
)
EXISTS_SQL = "SELECT 1 FROM " + TABLE + " WHERE MSG_ID = :id AND LANG_CD = :lang"
DEL_SQL = "DELETE FROM " + TABLE + " WHERE MSG_ID = :id AND LANG_CD = :lang"
MAXLBL_SQL = ("SELECT MAX(MSG_ID) FROM " + TABLE +
              " WHERE REGEXP_LIKE(MSG_ID,'^LBL[0-9]{5}$')")
MAXMSG_SQL = ("SELECT MAX(MSG_ID) FROM " + TABLE +
              " WHERE REGEXP_LIKE(MSG_ID,'^MSG[0-9]{5}$') AND TO_NUMBER(SUBSTR(MSG_ID,4)) < 90000")


def rows_for(catalog):
    """ (id, tp, {lang:text}) 단위로 펼치기. """
    out = []
    for mid, (tp, ko, en, cn) in catalog.items():
        out.append((mid, tp, {"KO": ko, "EN": en, "CN": cn}))
    return out


def main():
    ap = argparse.ArgumentParser(description="DMF0003 i18n MSG/LBL 사내 등록 (멱등)")
    ap.add_argument("--apply", action="store_true", help="실제 INSERT + commit (없으면 dry-run)")
    ap.add_argument("--mode", choices=("skip", "replace"), default="skip",
                    help="skip=존재 시 건너뜀(default) / replace=DELETE 후 INSERT")
    args = ap.parse_args()

    try:
        import oracledb
    except ImportError:
        sys.exit("ERROR: pip install oracledb 필요")

    u = os.environ.get("NSCM_ORA_USER")
    p = os.environ.get("NSCM_ORA_PASS")
    d = os.environ.get("NSCM_ORA_DSN")
    if not (u and p and d):
        sys.exit("ERROR: NSCM_ORA_USER/PASS/DSN 환경변수 필요")

    new_rows = rows_for(NEW_CORPORATE)
    shared_rows = rows_for(SHARED_CROSS_SCREEN)
    all_rows = new_rows + shared_rows

    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()

        # --- 채번 재확인 (실행 시점 max+1) ---
        cur.execute(MAXLBL_SQL)
        max_lbl = cur.fetchone()[0]
        cur.execute(MAXMSG_SQL)
        max_msg = cur.fetchone()[0]
        print("=== 채번 재확인 (실행 시점) ===")
        print("  MAX LBL =", max_lbl, "-> 신규 LBL 은 그 다음(LBL00679+) 이어야 함")
        print("  MAX MSG =", max_msg, "(sentinel 제외) -> 신규 MSG 는 MSG00631+ 이어야 함")

        # 채번 안전성 검증 — 신규 ID 가 현재 max 이하이면 충돌 위험 경고 (LBL00669 등 shared gap-fill 제외).
        def numpart(mid):
            return int(mid[3:])
        lbl_max_n = numpart(max_lbl) if max_lbl else 0
        msg_max_n = numpart(max_msg) if max_msg else 0
        warn = []
        for mid, tp, _ in new_rows:
            n = numpart(mid)
            if tp == "LBL" and n <= lbl_max_n:
                warn.append(mid + " (LBL <= max " + str(max_lbl) + ")")
            if tp == "MSG" and n <= msg_max_n:
                warn.append(mid + " (MSG <= max " + str(max_msg) + ")")
        if warn:
            print("  [경고] 신규 채번이 현재 max 이하 — 검토 필요:")
            for w in warn:
                print("    -", w)
        else:
            print("  [OK] 모든 신규(new_corporate) ID 가 현재 max 초과 — 채번 정상.")

        # --- 멱등 등록 ---
        ins = skip = repl = 0
        for label, rows in (("NEW_CORPORATE", new_rows), ("SHARED_CROSS_SCREEN", shared_rows)):
            print("\n=== " + label + " (" + str(len(rows)) + " keys x 3 lang) ===")
            for mid, tp, texts in rows:
                for lang in LANGS:
                    cur.execute(EXISTS_SQL, {"id": mid, "lang": lang})
                    present = cur.fetchone() is not None
                    binds = {"id": mid, "lang": lang, "nm": texts[lang], "tp": tp, "cb": CREATED_BY}
                    if present:
                        if args.mode == "replace":
                            if args.apply:
                                cur.execute(DEL_SQL, {"id": mid, "lang": lang})
                                cur.execute(INS_SQL, binds)
                            repl += 1
                        else:
                            skip += 1
                    else:
                        if args.apply:
                            cur.execute(INS_SQL, binds)
                        ins += 1

        print("\n=== 집계 ===")
        print("  INSERT 예정/실행 :", ins)
        print("  SKIP(이미 존재)  :", skip)
        print("  REPLACE          :", repl)
        print("  대상 키 총       :", len(all_rows), "(new", len(new_rows), "+ shared", len(shared_rows), ") x 3 lang =", len(all_rows) * 3, "row")

        if args.apply:
            con.commit()
            print("\n[APPLIED] commit 완료.")
        else:
            con.rollback()
            print("\n[DRY-RUN] 쓰기 없음 (rollback). 실제 적용은 --apply.")


if __name__ == "__main__":
    main()
