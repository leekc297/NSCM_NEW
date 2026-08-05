# -*- coding: utf-8 -*-
"""SYS0017 메타 등록 SQL 생성기 — 실측값 기반(추측 0). 산출: 01~09_*.sql"""
import pathlib
HERE = pathlib.Path(__file__).resolve().parent
AUD = "'admin', SYSDATE, 'admin', SYSDATE"

def q(s):
    return "'" + str(s).replace("'", "''") + "'"

out = []

# ══ 01 P1: MNU + MSG(MNU/MSG/LBL) + API_M + BTN_MPG ══
L = ["-- 01_P1_meta_wiring.sql — SYS0017 메타 배선 (MNU/MSG/LBL/API_M/BTN_MPG)",
     "-- 근거: 화면설계서 v1.0 시트8 / 사내 실측 2026-07-29(SYS0017 0건, MSG MAX 689, LBL MAX 773)",
     "-- AS-IS 실문구 원천: TB_FX_MessageInfo(LGCE_SCMDEV) Ko/En/Ch 실측. 감사 'admin'. 전 문장 멱등.", ""]

L.append("-- ① MNU_M (형제 SYS0016 기준: UPPR='System', LV3, UNIT '-')")
L.append(f"""INSERT INTO SCM_ADM_MNU_M (MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, SORT_ORD, MNU_LV_NO,
       MNU_TP_CD, UNIT_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SYS0017', 'System', 'mail-setup', 'MNU00690', 'Mail Setup', 9, 3, 'SCREEN', '-', 'Y', {AUD}
  FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M WHERE MNU_ID = 'SYS0017');""")

# MSG_M rows: (id, tp, ko, en, cn)
msgs = [("MNU00690", "MNU", "Mail Setup", "Mail Setup", "Mail Setup")]
# 신규 MSG 9종 — AS-IS TB_FX_MessageInfo 실측 문구
asis = [
    ("MSG00690", "저장에 실패하였습니다.", "Failed to save.", "Failed to save."),
    ("MSG00691", "조회 조건 {0} 중 하나를 입력하십시오.", "Enter one of the search criteria {0}.", "Enter one of the search criteria {0}."),
    ("MSG00692", "모듈을 먼저 선택해 주세요 !", "Select a module first!", "Select a module first!"),
    ("MSG00693", "주기를 먼저 선택해 주세요 !", "Select Period first!", "Select Period first!"),
    ("MSG00694", "삭제할 데이터가 포함되어 있습니다. 해당 카테고리에 등록된 메세지와 수신자 정보도 함께 삭제됩니다. 계속하시겠습니까?",
     "Contains the data to be deleted. Messages and recipient information that are registered in that category are also deleted. Do you want to continue?",
     "Contains the data to be deleted. Messages and recipient information that are registered in that category are also deleted. Do you want to continue?"),
    ("MSG00695", "Main 정보가 MONTH/WEEK인 경우, SUB1과 SUB2는 필수입력사항입니다.",
     "SUB1 and SUB2 are mandatory inputs when the main information is MONTH / WEEK.",
     "SUB1 and SUB2 are mandatory inputs when the main information is MONTH / WEEK."),
    ("MSG00696", "Main 정보가 DAY/RT인 경우, SUB1는 필수입력사항입니다.",
     "If Main information is DAY / RT, SUB1 is a mandatory entry.",
     "If Main information is DAY / RT, SUB1 is a mandatory entry."),
    ("MSG00697", "Main 정보는 필수입력사항입니다.", "Main information is mandatory.", "Main information is mandatory."),
    ("MSG00698", "입력할 수 있는 자리수를 초과하였습니다.", "You have exceeded the number of digits you can enter.",
     "You have exceeded the number of digits you can enter."),
]
msgs += [(i, "MSG", k, e, c) for i, k, e, c in asis]
# 신규 LBL 9종 (KO=EN, hook i18n)
lbls = [
    ("LBL00774", "Mail Setup"), ("LBL00775", "Category *"), ("LBL00776", "Main *"),
    ("LBL00777", "Sub1"), ("LBL00778", "Sub2"), ("LBL00779", "Sub3"),
    ("LBL00780", "SQL VIEW"), ("LBL00781", "Mail Title *"), ("LBL00782", "Mail Content *"),
]
msgs += [(i, "LBL", n, n, n) for i, n in lbls]

L.append("\n-- ② MSG_M — 메뉴명 1 + 신규 MSG 9(AS-IS 실문구) + 신규 LBL 9 (각 3언어)")
for mid, tp, ko, en, cn in msgs:
    for lang, txt in (("KO", ko), ("EN", en), ("CN", cn)):
        L.append(f"""INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT {q(mid)}, {q(lang)}, {q(txt)}, {q(tp)}, 'Y', {AUD} FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MSG_M WHERE MSG_ID={q(mid)} AND LANG_CD={q(lang)});""")

# API_M 9종 — API_MSG_ID NOT NULL
apis = [
    ("SYS0017_main_SEARCH",        "PROC_SELECT", "PKG_SYS0017.P_SYS0017_GET_RECIPIENT_MASTER",  "SYS0017 카테고리 마스터 조회"),
    ("SYS0017_main_SAVE",          "PROC_SAVE",   "PKG_SYS0017.P_SYS0017_SAVE_RECIPIENT_MASTER", "SYS0017 카테고리 마스터 저장(^ bulk)"),
    ("SYS0017_message_SEARCH",     "PROC_SELECT", "PKG_SYS0017.P_SYS0017_GET_RECIPIENT_MESSAGE", "SYS0017 언어별 메시지 조회"),
    ("SYS0017_message_SAVE",       "PROC_SAVE",   "PKG_SYS0017.P_SYS0017_SAVE_RECIPIENT_MESSAGE","SYS0017 언어별 메시지 저장(^ bulk)"),
    ("SYS0017_allReceiver_SEARCH", "PROC_SELECT", "PKG_SYS0017.P_SYS0017_GET_USERINFO_LIST",     "SYS0017 사용자 검색"),
    ("SYS0017_selReceiver_SEARCH", "PROC_SELECT", "PKG_SYS0017.P_SYS0017_GET_RECIPIENT_ASSIGN",  "SYS0017 배정 수신자 조회"),
    ("SYS0017_selReceiver_SAVE",   "PROC_SAVE",   "PKG_SYS0017.P_SYS0017_SAVE_RECIPIENT_ASSIGN", "SYS0017 수신자 저장(^ bulk)"),
    ("SYS0017_sqlText_SEARCH",     "PROC_SELECT", "PKG_SYS0017.P_SYS0017_GET_SQL_LONG_TEXT",     "SYS0017 수신자추출 SQL 조회"),
    ("SYS0017_sqlText_SAVE",       "PROC_SAVE",   "PKG_SYS0017.P_SYS0017_SAVE_RECIPIENT_MASTER_U","SYS0017 수신자추출 SQL 저장"),
]
L.append("\n-- ③ API_M 9종")
for aid, tp, url, desc in apis:
    L.append(f"""INSERT INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT {q(aid)}, {q(tp)}, {q('MSG_API_' + aid)}, {q(desc)}, {q(url)}, 'Y', {AUD} FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_API_M WHERE API_ID={q(aid)});""")

# BTN_MPG — FE SHEETS 전 시트 (dayRange 사고 재발 방지)
btns = [("main", "SEARCH"), ("main", "SAVE"), ("main", "INSERT"), ("main", "DELETE"),
        ("message", "SEARCH"), ("message", "SAVE"), ("message", "INSERT"), ("message", "DELETE"),
        ("allReceiver", "SEARCH"),
        ("selReceiver", "SEARCH"), ("selReceiver", "SAVE"), ("selReceiver", "DELETE"),
        ("sqlText", "SEARCH"), ("sqlText", "SAVE")]
BTN_API = {("main","SEARCH"):"SYS0017_main_SEARCH", ("main","SAVE"):"SYS0017_main_SAVE",
           ("main","INSERT"):"SYS0017_main_SEARCH", ("main","DELETE"):"SYS0017_main_SAVE",
           ("message","SEARCH"):"SYS0017_message_SEARCH", ("message","SAVE"):"SYS0017_message_SAVE",
           ("message","INSERT"):"SYS0017_message_SEARCH", ("message","DELETE"):"SYS0017_message_SAVE",
           ("allReceiver","SEARCH"):"SYS0017_allReceiver_SEARCH",
           ("selReceiver","SEARCH"):"SYS0017_selReceiver_SEARCH", ("selReceiver","SAVE"):"SYS0017_selReceiver_SAVE",
           ("selReceiver","DELETE"):"SYS0017_selReceiver_SAVE",
           ("sqlText","SEARCH"):"SYS0017_sqlText_SEARCH", ("sqlText","SAVE"):"SYS0017_sqlText_SAVE"}
L.append("\n-- ④ BTN_MPG — FE SHEETS 전 시트 × 버튼 (권한 체크 대상, dayRange 사고 재발 방지)")
for sht, btn in btns:
    L.append(f"""INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SYS0017', {q(sht)}, {q(btn)}, {q(BTN_API[(sht,btn)])}, 'Y', {AUD} FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SYS0017' AND SHT_NM={q(sht)} AND MNU_BTN_CD={q(btn)});""")
L.append("\nCOMMIT;")
out.append(("01_P1_meta_wiring.sql", L))

# ══ 02 P2: PROC_M (ALL_ARGUMENTS positional 실측 = PKG 시그니처) ══
L = ["-- 02_P2_proc_m.sql — PROC_M (PKG_SYS0017 멤버 positional). FE 키 = camelCase, 세션=sesUserId",
     "-- 실측 기준: PKG_SYS0017 ALL_ARGUMENTS (2026-07-29 취합 직후). 멱등: 기존 행 DELETE 후 INSERT", ""]
PROCS = {
 "P_SYS0017_GET_RECIPIENT_MASTER": [("useType","VARCHAR","IN"),("module","VARCHAR","IN"),("submodule","VARCHAR","IN"),("active","VARCHAR","IN"),("o_rc1","CURSOR","OUT"),("O_RESULT_CURSOR","PROC_RESULT","OUT")],
 "P_SYS0017_GET_RECIPIENT_MESSAGE":[("useType","VARCHAR","IN"),("categoryId","VARCHAR","IN"),("o_rc1","CURSOR","OUT"),("O_RESULT_CURSOR","PROC_RESULT","OUT")],
 "P_SYS0017_GET_RECIPIENT_ASSIGN": [("useType","VARCHAR","IN"),("categoryId","VARCHAR","IN"),("o_rc1","CURSOR","OUT"),("O_RESULT_CURSOR","PROC_RESULT","OUT")],
 "P_SYS0017_GET_USERINFO_LIST":    [("user","VARCHAR","IN"),("dept","VARCHAR","IN"),("o_rc1","CURSOR","OUT"),("O_RESULT_CURSOR","PROC_RESULT","OUT")],
 "P_SYS0017_GET_SQL_LONG_TEXT":    [("useType","VARCHAR","IN"),("module","VARCHAR","IN"),("submodule","VARCHAR","IN"),("categoryId","VARCHAR","IN"),("o_rc1","CURSOR","OUT"),("O_RESULT_CURSOR","PROC_RESULT","OUT")],
 "P_SYS0017_SAVE_RECIPIENT_MASTER":[("activeFlag","VARCHAR","IN"),("useType","VARCHAR","IN"),("module","VARCHAR","IN"),("submodule","VARCHAR","IN"),("categoryId","VARCHAR","IN"),("categoryDesc","VARCHAR","IN"),("cycleClassCode","VARCHAR","IN"),("detailClassCode","VARCHAR","IN"),("sendTimeText","VARCHAR","IN"),("sendMinTimeText","VARCHAR","IN"),("active","VARCHAR","IN"),("createdBy","VARCHAR","IN"),("creationDate","VARCHAR","IN"),("lastUpdatedBy","VARCHAR","IN"),("o_rc1","CURSOR","OUT"),("O_RESULT_CURSOR","PROC_RESULT","OUT")],
 "P_SYS0017_SAVE_RECIPIENT_MESSAGE":[("activeFlag","VARCHAR","IN"),("useType","VARCHAR","IN"),("categoryId","VARCHAR","IN"),("language","VARCHAR","IN"),("title","VARCHAR","IN"),("content","VARCHAR","IN"),("createdBy","VARCHAR","IN"),("creationDate","VARCHAR","IN"),("lastUpdatedBy","VARCHAR","IN"),("o_rc1","CURSOR","OUT"),("O_RESULT_CURSOR","PROC_RESULT","OUT")],
 "P_SYS0017_SAVE_RECIPIENT_ASSIGN":[("activeFlag","VARCHAR","IN"),("useType","VARCHAR","IN"),("categoryId","VARCHAR","IN"),("userId","VARCHAR","IN"),("createdBy","VARCHAR","IN"),("creationDate","VARCHAR","IN"),("lastUpdatedBy","VARCHAR","IN"),("O_RESULT_CURSOR","PROC_RESULT","OUT")],
 "P_SYS0017_SAVE_RECIPIENT_MASTER_U":[("useType","VARCHAR","IN"),("module","VARCHAR","IN"),("submodule","VARCHAR","IN"),("categoryId","VARCHAR","IN"),("sqlText","VARCHAR","IN"),("lastUpdatedBy","VARCHAR","IN"),("o_rc1","CURSOR","OUT"),("O_RESULT_CURSOR","PROC_RESULT","OUT")],
}
for m, cols in PROCS.items():
    pn = f"PKG_SYS0017.{m}"
    L.append(f"DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = {q(pn)};")
    for i, (cn, dt, io) in enumerate(cols, 1):
        L.append(f"""INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES ({q(pn)}, {q(cn)}, {q(dt)}, {q(io)}, {i}, {AUD});""")
L.append("\nCOMMIT;")
out.append(("02_P2_proc_m.sql", L))

# ══ 03 SHEET_COLUMNS ══
SHEETS = {
 "main": [("USE_TYPE_CODE","Use Type",1,"N",80,"C","N"),("MODULE_CODE","Module *",2,"Y",110,"C","Y"),
          ("SUB_MODULE_CODE","Sub Module *",3,"Y",110,"C","Y"),("CATEGORY_ID","Category",4,"Y",90,"C","N"),
          ("CATEGORY_DESC","Category *",5,"Y",280,"L","Y"),("ACTIVE_FLAG","Active",6,"Y",80,"C","Y"),
          ("CYCLE_CLASS_CODE","Main *",7,"Y",100,"C","Y"),("DETAIL_CLASS_CODE","Sub1",8,"Y",100,"C","Y"),
          ("SEND_TIME_TEXT","Sub2",9,"Y",100,"C","Y"),("SEND_MIN_TIME_TEXT","Sub3",10,"Y",100,"C","Y"),
          ("VIEW","SQL VIEW",11,"Y",100,"C","N")],
 "message": [("USE_TYPE_CODE","Use Type",1,"N",80,"C","N"),("CATEGORY_ID","Category ID",2,"N",90,"C","N"),
             ("CATEGORY_DESC","Category",3,"Y",240,"L","N"),("LANGUAGE_CODE","Language *",4,"Y",110,"C","Y"),
             ("MAIL_TITLE","Mail Title *",5,"Y",260,"L","Y"),("MESSAGE_CONTENT","Mail Content *",6,"Y",420,"L","Y")],
 "allReceiver": [("USERID","User ID",1,"Y",110,"L","N"),("USERNAME","Name",2,"Y",110,"L","N"),
                 ("DEPT_NAME","Department",3,"Y",180,"L","N"),("EMAIL","Email",4,"N",180,"L","N"),
                 ("CELLPHONENUM","TEL",5,"N",130,"C","N"),("LANGUAGE","Language",6,"N",90,"C","N")],
 "selReceiver": [("USE_TYPE_CODE","Use Type",1,"N",80,"C","N"),("CATEGORY_ID","Category ID",2,"N",90,"C","N"),
                 ("CATEGORY_DESC","Category",3,"Y",200,"L","N"),("USERID","User ID",4,"Y",110,"L","N"),
                 ("USERNAME","Name",5,"Y",110,"L","N"),("DEPT_NAME","Department",6,"Y",180,"L","N"),
                 ("EMAIL","Email",7,"N",180,"L","N"),("CELLPHONENUM","TEL",8,"N",130,"C","N"),
                 ("LANGUAGE","Language",9,"N",90,"C","N")],
}
CELL_COMBO = {("main","MODULE_CODE"):"MailModule", ("main","SUB_MODULE_CODE"):"MailSubModule",
              ("main","ACTIVE_FLAG"):"YesOrNo", ("main","CYCLE_CLASS_CODE"):"MailSendCycle",
              ("main","DETAIL_CLASS_CODE"):"MailSendCycleDetail", ("main","SEND_TIME_TEXT"):"MailSendCycleDetail",
              ("main","SEND_MIN_TIME_TEXT"):"MailSendCycleDetail", ("message","LANGUAGE_CODE"):"MailLanguage"}
L = ["-- 03_sheet_columns.sql — SHEET_COLUMNS (4 시트). 정렬코드 단일문자 C/L/R(hook #96), INPUT_TP_CD 'IM'",
     "-- NOT NULL 실측(2026-07-29): PROGRAM_ID/SHEET_NAME/COLUMN_NAME/COLUMN_LABEL_NAME/SORT_ORDER_NO/VALID_YN/CREATED_BY/LAST_UPDATED_BY", ""]
for sht, cols in SHEETS.items():
    L.append(f"DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SYS0017' AND SHEET_NAME={q(sht)};")
    for cn, lb, so, vis, w, al, edit in cols:
        combo = CELL_COMBO.get((sht, cn))
        ctype = "'C'" if combo else "NULL"
        cdata = q(combo) if combo else "NULL"
        L.append(f"""INSERT INTO SCM_MST_SHEET_COLUMNS (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
       FIXED_FLAG, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, HORIZONTAL_ALIGN_CODE,
       UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, INPUT_TP_CD,
       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES ('SYS0017', {q(sht)}, {q(cn)}, {q(lb)}, {so}, 'N', {w}, {ctype}, {cdata}, {q(al)},
       'N', {q(vis)}, 'Y', 'Y', 'Y', 'IM', {AUD});""")
L.append("\nCOMMIT;")
out.append(("03_sheet_columns.sql", L))

# ══ 04 권한 2테이블 ══
L = ["-- 04_P4_user_gr.sql — 권한(메뉴+버튼)",
     "-- 미러링 원본 정정(2026-07-29 실측): SYS0016 권한 0건 → SYS0014(ADMIN/SCM PI Admin) 사용", ""]
L.append(f"""INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT G.USER_GR_ID, 'SYS0017', G.USE_YN, {AUD}
  FROM SCM_ADM_USER_GR_MNU_MPG_M G
 WHERE G.MNU_ID = 'SYS0014'
   AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M X WHERE X.USER_GR_ID = G.USER_GR_ID AND X.MNU_ID = 'SYS0017');""")
L.append(f"""INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT G.USER_GR_ID, 'SYS0017', B.SHT_NM, B.MNU_BTN_CD, 'Y', {AUD}
  FROM (SELECT DISTINCT USER_GR_ID FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'SYS0017' AND USE_YN='Y') G
 CROSS JOIN (SELECT SHT_NM, MNU_BTN_CD FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = 'SYS0017' AND USE_YN='Y') B
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M X
                    WHERE X.USER_GR_ID = G.USER_GR_ID AND X.MNU_ID = 'SYS0017'
                      AND X.SHT_NM = B.SHT_NM AND X.MNU_BTN_CD = B.MNU_BTN_CD);""")
L.append("\nCOMMIT;")
out.append(("04_P4_user_gr.sql", L))

# ══ 05 CMBO ══
CMBOS = [
 ("MailModule", "DM", "Mail Module",
  "SELECT DISTINCT SEGMENT1 AS CODE, SEGMENT3 AS NAME, MIN(DISPLAY_SEQ) AS SORT_SEQ "
  "FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'SMS_MAIL_SEND_SYSTEM' AND VALID_YN = 'Y' "
  "GROUP BY SEGMENT1, SEGMENT3 ORDER BY SORT_SEQ"),
 ("MailSubModule", "DM", "Mail Sub Module (Module 종속)",
  "SELECT DISTINCT SEGMENT2 AS CODE, SEGMENT4 AS NAME, SEGMENT1 AS PARENT_CODE, MIN(DISPLAY_SEQ) AS SORT_SEQ "
  "FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'SMS_MAIL_SEND_SYSTEM' AND VALID_YN = 'Y' "
  "GROUP BY SEGMENT2, SEGMENT4, SEGMENT1 ORDER BY SORT_SEQ"),
 ("MailSendCycle", "DM", "Mail Send Cycle (Main)",
  "SELECT DISTINCT SEGMENT1 AS CODE, SEGMENT3 AS NAME, MIN(DISPLAY_SEQ) AS SORT_SEQ "
  "FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'MAIL_SEND_CYCLE' AND VALID_YN = 'Y' "
  "GROUP BY SEGMENT1, SEGMENT3 ORDER BY SORT_SEQ"),
 ("MailSendCycleDetail", "DM", "Mail Send Cycle Detail (Sub1~3, PARENT_CODE 종속)",
  "SELECT DISTINCT SEGMENT2 AS CODE, SEGMENT3 AS NAME, SEGMENT1 AS PARENT_CODE, MIN(DISPLAY_SEQ) AS SORT_SEQ "
  "FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'MAIL_SEND_CYCLE_DETAIL' AND VALID_YN = 'Y' "
  "GROUP BY SEGMENT2, SEGMENT3, SEGMENT1 ORDER BY SORT_SEQ"),
 ("MailLanguage", "ALL", "Mail Language",
  "SELECT DISTINCT SEGMENT1 AS CODE, SEGMENT2 AS NAME, MIN(DISPLAY_SEQ) AS SORT_SEQ "
  "FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'LANGUAGE' AND VALID_YN = 'Y' "
  "GROUP BY SEGMENT1, SEGMENT2 ORDER BY SORT_SEQ"),
]
L = ["-- 05_P5_cmbo.sql — 콤보 5종(LOOKUP 원천 실측: SMS_MAIL_SEND_SYSTEM 15 / MAIL_SEND_CYCLE 8 / _DETAIL 132 / LANGUAGE 3)",
     "-- 종속 콤보는 PARENT_CODE 를 함께 내려 FE 에서 cascade 필터(그리드 dataMap 원복 표준)", ""]
for sid, mdu, nm, sql in CMBOS:
    L.append(f"""INSERT INTO SCM_ADM_CMBO_SQL_M (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT {q(sid)}, {q(mdu)}, {q(nm)}, {q(sql)}, 'Y', {AUD} FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID = {q(sid)});""")
L.append("\nCOMMIT;")
out.append(("05_P5_cmbo.sql", L))

# ══ 06 verify ══
L = ["-- 06_P6_verify.sql — 전부 SELECT (기대값 주석)", ""]
V = [("MNU_M SYS0017 (1)", "SELECT COUNT(*) C FROM SCM_ADM_MNU_M WHERE MNU_ID='SYS0017'"),
     ("MSG 신규 MSG 9x3=27", "SELECT COUNT(*) C FROM SCM_ADM_MSG_M WHERE MSG_ID BETWEEN 'MSG00690' AND 'MSG00698'"),
     ("LBL 신규 9x3=27", "SELECT COUNT(*) C FROM SCM_ADM_MSG_M WHERE MSG_ID BETWEEN 'LBL00774' AND 'LBL00782'"),
     ("API_M 9", "SELECT COUNT(*) C FROM SCM_ADM_API_M WHERE API_ID LIKE 'SYS0017%'"),
     ("BTN_MPG 14", "SELECT COUNT(*) C FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SYS0017'"),
     ("PROC_M 9 SP", "SELECT COUNT(DISTINCT PROC_NM) C FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE 'PKG_SYS0017.%'"),
     ("SHEET_COLUMNS 32", "SELECT COUNT(*) C FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SYS0017'"),
     ("권한 메뉴", "SELECT COUNT(*) C FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='SYS0017'"),
     ("권한 버튼", "SELECT COUNT(*) C FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='SYS0017'"),
     ("CMBO 5", "SELECT COUNT(*) C FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ('MailModule','MailSubModule','MailSendCycle','MailSendCycleDetail','MailLanguage')"),
     ("PKG VALID 2", "SELECT COUNT(*) C FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SYS0017' AND STATUS='VALID'"),
     ("PROC_M vs ALL_ARGUMENTS 불일치 0",
      "SELECT COUNT(*) C FROM (SELECT SUBSTR(PROC_NM, INSTR(PROC_NM,'.')+1) NM, COL_NM, TO_NUMBER(SORT_ORD) SO FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE 'PKG_SYS0017.%') P "
      "FULL OUTER JOIN (SELECT OBJECT_NAME NM, ARGUMENT_NAME AN, POSITION PO FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_SYS0017') A "
      "ON P.NM=A.NM AND P.SO=A.PO WHERE P.NM IS NULL OR A.NM IS NULL")]
for name, sql in V:
    L.append(f"PROMPT === {name} ===")
    L.append(sql + ";")
out.append(("06_P6_verify.sql", L))

# ══ 99 route ══
out.append(("99_route_path.sql", [
 "-- 99_route_path.sql — ROUTE_PATH 최종 (반드시 마지막). '<features 도메인>/<페이지 폴더>' 2단 + 상위 경로",
 "UPDATE SCM_ADM_MNU_M SET ROUTE_PATH = 'admin/system/mail-setup', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE",
 " WHERE MNU_ID = 'SYS0017' AND (ROUTE_PATH IS NULL OR ROUTE_PATH <> 'admin/system/mail-setup');",
 "COMMIT;"]))

for fn, lines in out:
    (HERE / fn).write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(fn, len(lines), "lines")
