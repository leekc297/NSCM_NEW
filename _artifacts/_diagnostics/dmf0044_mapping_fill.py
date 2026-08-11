#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_mapping_fill.py — DMF0044 대사표 148행 기입 (2026-08-10)

`asis_mapping_gate --init/--handlers` 가 만든 빈 행에 [구현 위치] 또는 [제외/해당없음 + 사유]를 채운다.
행을 손으로 편집하면 누락·오타가 나므로 **ID→(위치, 사유, 상태) 사전**을 단일 출처로 두고 기계 치환한다.

원천:
  · AS-IS  `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0044_Sales_Reports/DMF0044_Sales_Reports.cs` (1,483행)
  · 분석서 `Doc/화면분석서/DMF0044_SalesReports_{주요이벤트_상세분석,제약매트릭스_상세}.md`
  · 정책   `__asis-mapping__.md` §0 정책 확정 (사용자 2026-07-22)

팝업 번호(제약매트릭스 §0): 2=Sales_VersionPopUp / 3=VersionCopyPopUp / 4=United_Version /
  5=MDFVersionPopUp / 6=SalesReportExchange / 7=SalesReport_Textbox
  ⇒ **2·3·5 = dead 3종**(호출 경로 없음, 정책 확정 ②로 이관 제외) / 4·6·7 = 활성.
"""
import pathlib
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
MAP = ROOT / "nscm-fe/features/demand/src/pages/sales-reports/__asis-mapping__.md"

P = "nscm-fe/features/demand/src/pages/sales-reports"           # 페이지 루트(표기 축약)
DEAD = ("AS-IS 호출 경로 없음(제약매트릭스 §0 실측: 팝업2 호출부 주석 / 팝업3 은 팝업2 경유만 / "
        "팝업5 는 7파일 내 호출 0). 정책 확정 ② — dead 팝업 3종 이관 제외")
WINFORMS = "WinForms 배관 — Wijmo/React 아키텍처에 대응 개념 없음(플랫폼 차이)"

# ID: (구현 위치, 사유, 상태)
F = {}


def impl(ids, loc):
    for i in ids:
        F[i] = (loc, "", "구현")


def excl(ids, why):
    for i in ids:
        F[i] = ("", why, "제외")


def na(ids, why):
    for i in ids:
        F[i] = ("", why, "해당없음")


# ── 이벤트 E (주요이벤트 md §0~§11) ─────────────────────────────────────────────
na(["E00"], "분석 배경 서술(정본 vs Plan.UIL 변형 차이) — 구현 대상 조문 아님")
impl(["E01"], f"{P}/SalesReports.tsx mount useEffect + useSalesReportsStore 초기화")
na(["E01-1"], WINFORMS + " (생성자/InitializeComponent)")
impl(["E01-2"], f"{P}/SalesReports.tsx useEffect(mount) — 메타 fetch → 조회조건 초기화 순서")
impl(["E01-3"], f"{P}/components/SalesReportsForm.tsx useTabComboQueries(조회조건 콤보 전수)")
impl(["E01-4"], f"{P}/components/SalesReportsGrid.tsx staticColumns/dynamicColumns (admin 메타 주도, hook #113)")
impl(["E01-5"], f"{P}/SalesReports.tsx useTabBtnPermissions(hasButton) — 버튼 노출 권한")
impl(["E02"], f"{P}/useSalesReportsStore.ts setFilter + SalesReports.tsx useTabProcQuery(SHEETS.MAIN)")
impl(["E03"], f"{P}/utils/sales-reports.editLock.ts evalSalesReportCell (4변수 매트릭스)")
impl(["E03-1"], f"{P}/SalesReports.tsx:152 handleInsert + utils/sales-reports.editLock.ts insertStaticEditable")
impl(["E03-2"], f"{P}/SalesReports.tsx:174 handleDelete")
impl(["E04"], f"{P}/SalesReports.tsx:185 handleSave + utils/sales-reports.save.ts")
impl(["E04-1"], f"{P}/utils/sales-reports.save.ts buildEtcSaveRows → utils/sales-reports.api.ts callSaveEtc")
impl(["E04-2"], f"{P}/utils/sales-reports.save.ts buildCutoffSaveRows → callSaveCutoff")
impl(["E05"], "nscm-fe/features/demand/src/components/versionModal/VersionModal.tsx (활성 1종만 이관)")
impl(["E05-1"], "nscm-fe/features/demand/src/components/versionModal/VersionModal.tsx (AS-IS United 727행 1:1)")
excl(["E05-2", "E05-3", "E05-4"], DEAD)
impl(["E06"], f"{P}/components/modals/ExchangeRateModal.tsx")
impl(["E07"], f"{P}/components/modals/TextboxModal.tsx (division 82 전용)")
impl(["E08"], f"{P}/components/SalesReportsGrid.tsx — beginningEdit/cellEditEnded/formatItem/dblclick 배선")
impl(["E08-1"], f"{P}/components/SalesReportsGrid.tsx cellEditEndedHandler(수치 빈값→'0', DEPARTMENT_ID clear) + beginningEditHandler(행별 콤보 스왑)")
impl(["E08-2"], f"{P}/components/SalesReportsGrid.tsx dblclickHandler (ITEM_ID, '기타매출' 제외)")
impl(["E09"], f"{P}/SalesReports.tsx:304 hotkeyConfig + :316 customButtons")
impl(["E09-1"], f"{P}/SalesReports.tsx:304 hotkeyConfig(search/insert/delete/save)")
impl(["E09-2"], f"{P}/SalesReports.tsx:316 customButtons(Text/Exchange/Column/Measure)")
impl(["E10"], "SCM_ADM_MNU_BTN_MPG_M MNU_ID='DMF0044' 28행(8시트) — 배선 체인 게이트 섹션3 PASS 로 실증")
impl(["E11"], f"{P}/utils/sales-reports.validate.ts + sales-reports.constants.ts MSG (대사표 §5)")

# ── 제약 A (권한 축) ─────────────────────────────────────────────────────────
impl(["A-1"], "features/master/src/components/searchFields DivisionField (CMBO 'MyDivision' — 권한 division 만)")
impl(["A-2"], f"{P}/useSalesReportsStore.ts:133 userGroup 전달 → SP EDIT_FLAG 산출")
impl(["A-3"], f"{P}/utils/sales-reports.editLock.ts:59 EDIT_FLAG=='Y' 전 구간 개방")
excl(["A-4", "A-5", "A-7", "A-10", "A-11", "A-13"], DEAD)
na(["A-6", "A-8", "A-9"],
   "AS-IS `IsPopup=true` = WinForms BaseForm 권한체크 우회 배관. TO-BE 모달은 부모 화면 권한 컨텍스트를 "
   "그대로 쓰므로 우회 개념 자체가 없음(플랫폼 차이)")
impl(["A-12"], "components/versionModal/VersionModal.tsx — division 은 부모 전달값 고정(disabled)")
impl(["A-14"], f"{P}/components/modals/ExchangeRateModal.tsx — 조회 division = 부모 조회조건 승계")
na(["A-15", "A-16", "A-17"],
   "AS-IS 는 NowGroupID∈{ADMIN,DM ADMIN} 그룹 게이트. TO-BE 환율 모달은 **행별 EDIT_YN**"
   "(ExchangeRateModal.tsx:157)으로 편집을 통제한다 — DMF0042 선례와 동일한 표준화 Δ(그룹→행 권한)")
na(["A-18", "A-19", "A-20"],
   "동상 — Textbox 모달은 버튼 권한(hasButton('TEXTBOX')) + division 82 게이트로 노출을 통제. "
   "AS-IS 의 ADMIN 그룹 하드코딩은 미승계(표준화 Δ)")

# ── 제약 D (division 축) ─────────────────────────────────────────────────────
impl(["D-1"], f"{P}/SalesReports.tsx:317 hasButton('TEXTBOX') && isDiv82(sc.divisionId)")
impl(["D-2"], f"{P}/utils/sales-reports.editLock.ts:66-69 RTF·Business_Plan × isDiv40")
impl(["D-3"], f"{P}/utils/sales-reports.editLock.ts:71 기타 measure — d40 && isPast")
impl(["D-4"], f"{P}/SalesReports.tsx:141 handleDivisionChange (버튼 토글 + 버전 리셋)")
excl(["D-5", "D-6"], DEAD)

# ── 제약 M (measure/컬럼 축) ─────────────────────────────────────────────────
impl(["M-1"], f"{P}/utils/sales-reports.editLock.ts:62-65 LOC — 계획구간(!isPast)만")
impl(["M-2"], f"{P}/utils/sales-reports.editLock.ts:66-69 RTF 포함/Business_Plan 분기")
impl(["M-3"], f"{P}/utils/sales-reports.editLock.ts:71 else — d40 && isPast")
impl(["M-4"], f"{P}/SalesReports.tsx:152 handleInsert(2행 세트 measure 강제) + editLock.ts INSERT_LOCKED_COLUMNS 의 MEASURE")
impl(["M-5"], f"{P}/components/SalesReportsGrid.tsx cellEditEndedHandler — 동적 셀 빈값 → '0'")
impl(["M-6"], f"{P}/utils/sales-reports.gridCombos.ts resolveDeptIdRows(3분기) + DEPARTMENT_CHANGE_CLEAR "
              "(2026-08-09 이관 — CMBO DMF0044_DEPARTMENT_TEAM / _ETC_SALE_RESULT_TYPE_40 신규 등록)")
impl(["M-7"], f"{P}/utils/sales-reports.gridCombos.ts ROW_COMBO_IDS.CUST_REPORT('DMF0005_REPORT_GROUP2') "
              "— beginningEdit 스왑. 'MDF' 분기의 ITEM/NICK 강제세팅은 §6 승계 금지 대상")
impl(["M-8"], f"{P}/components/SalesReportsGrid.tsx dblclickHandler — ITEM_ID '기타매출' 제외")

# ── 제약 V (기간·버전 축) ────────────────────────────────────────────────────
impl(["V-1"], f"{P}/useSalesReportsStore.ts thisMonth = dayjs().format('YYYYMM') (조회 시점 고정)")
impl(["V-2"], f"{P}/utils/sales-reports.editLock.ts isPast 판정 — BP(Business_Plan) 전 구간 개방은 D-2 경로")
impl(["V-3"], f"{P}/utils/sales-reports.editLock.ts isPast = ym < thisMonth (전 구간 과거면 전량 잠금)")
impl(["V-4"], f"{P}/utils/sales-reports.editLock.ts ym<thisMonth 비교로 컬럼별 판정 — 순회 탐색 불요(선언적)")
impl(["V-5"], f"{P}/utils/sales-reports.validate.ts:8 validateFind (MSG00283)")
impl(["V-6"], f"{P}/utils/sales-reports.validate.ts:13 validateVersionForAction (MSG00688 — AS-IS 00281 원문 신설)")
impl(["V-7"], f"{P}/SalesReports.tsx:273 handleExchangeRate → validateVersionForAction")
impl(["V-8"], f"{P}/SalesReports.tsx:291 handleTextbox → validateVersionForAction")
excl(["V-9"], "AS-IS CUTOFF_YYYYMMDD 공급 경로가 dead 팝업2 뿐이라 활성 경로(United)에서는 빈 문자열. "
              "정책 확정 ① — 빈값 파리티(TO-BE 도 빈 문자열 전달)")
impl(["V-10"], f"{P}/components/SalesReportsForm.tsx Type 변경 → 버전 리셋 + 라벨 분기")
impl(["V-11"], f"{P}/SalesReports.tsx:141 handleDivisionChange — 버전 리셋")
impl(["V-12"], "components/versionModal/VersionModal.tsx — btnSPVer 진입, 반환 버전 채택")
impl(["V-13"], f"{P}/components/SalesReportsForm.tsx 연도 콤보(CMBO 'CALENDAR_YYYY', 기본 올해) + spreadTitle 시트")
impl(["V-14"], "components/versionModal/version-modal.api.ts callTransfer — SEND_YN='N' 게이트")
impl(["V-15"], "components/versionModal/version-modal.api.ts callTransfer('C') — SEND_YN='Y' 게이트")
impl(["V-16"], "components/versionModal/version-modal.api.ts callAction('D') — SEND_YN∈{N,C} 게이트")
impl(["V-17"], "components/versionModal/VersionModal.tsx Copy — chkResult/BasicDate + callAction('CP')")
impl(["V-18"], "components/versionModal/VersionModal.tsx Create — callAction('CR')")
impl(["V-19"], "components/versionModal/VersionModal.tsx OK — 선택 버전 확정 후 close")
impl(["V-20"], "components/versionModal/version-modal.constants.ts — Type 별 CREATE/COPY 모드 버튼 노출")
impl(["V-21"], "components/versionModal/VersionModal.tsx chkResult ↔ BasicDate/chkUpdate 연동")
impl(["V-22"], "components/versionModal/VersionModal.tsx chkMV ↔ MvMonth(기본 전월) 연동")
impl(["V-23"], "components/versionModal/version-modal.api.ts callAction 파라미터 8키")

# ── 제약 L (잠금 축) ─────────────────────────────────────────────────────────
impl(["L-01", "L-02", "L-04", "L-06"],
     f"{P}/components/SalesReportsGrid.tsx beginningEditHandler — 정적(헤더)영역은 기존행 전량 잠금"
     "(existingStaticEditable)")
impl(["L-03"], f"{P}/utils/sales-reports.editLock.ts:64 LOC 과거구간 잠금(!isPast)")
impl(["L-05", "L-08"], f"{P}/utils/sales-reports.editLock.ts:68,71 비40 행 전체 잠금(editable=false)")
impl(["L-07"], f"{P}/utils/sales-reports.editLock.ts:71 40 기타 measure — 현재월~끝 잠금(isPast 만 개방)")
impl(["L-09"], f"{P}/components/SalesReportsGrid.tsx — 조회 직후 기본 잠금(편집은 beginningEdit 게이트 통과분만)")
for _lid, _col in [("L-10", "DEPARTMENT_NAME"), ("L-11", "DEPT_NAME"), ("L-12", "CUTOFF_YYYYMMDD"),
                   ("L-13", "NICK_NAME"), ("L-14", "SCM_SITE_ID"), ("L-15", "PROJECT_CODE"),
                   ("L-16", "APPLICATION"), ("L-17", "BIZ_TYPE_NAME"), ("L-18", "BIZ_TYPE_NAME40"),
                   ("L-19", "DMS_SALES"), ("L-20", "DMS_CUSTOMER"), ("L-21", "MEASURE")]:
    F[_lid] = (f"{P}/utils/sales-reports.editLock.ts INSERT_LOCKED_COLUMNS 의 '{_col}'", "", "구현")
excl(["L-22", "L-23", "L-25"], DEAD)
impl(["L-24"], "components/versionModal/VersionModal.tsx — 그리드 조회 전용(편집 없음)")
impl(["L-26", "L-27", "L-28", "L-29"],
     f"{P}/components/modals/ExchangeRateModal.tsx — 키 컬럼 잠금 + 과거월 잠금(:161) + EDIT_YN 게이트(:157)")
impl(["L-30"], f"{P}/components/modals/TextboxModal.tsx — Action 열 외 잠금")

# ── CRUD·모달 매트릭스 ───────────────────────────────────────────────────────
impl(["CRUD:E02:SEARCH"], f"{P}/SalesReports.tsx:126 handleSearch → useTabProcQuery(SHEETS.MAIN)")
impl(["CRUD:E03:EDIT"], f"{P}/utils/sales-reports.editLock.ts evalSalesReportCell + Grid beginningEdit")
impl(["CRUD:E04:SAVE"], f"{P}/SalesReports.tsx:185 handleSave → callSaveEtc / callSaveCutoff")
impl(["MODAL:ExchangeRateModal"], f"{P}/components/modals/ExchangeRateModal.tsx")
impl(["MODAL:MeasureSelectModal"], f"{P}/components/modals/MeasureSelectModal.tsx")
impl(["MODAL:TextboxModal"], f"{P}/components/modals/TextboxModal.tsx")
impl(["MODAL:SalesReportsModals"], f"{P}/components/SalesReportsModals.tsx (모달 컨테이너)")
excl(["MODAL:DMF0044_MDFVersionPopUp", "MODAL:DMF0044_Sales_VersionCopyPopUp",
      "MODAL:DMF0044_Sales_VersionPopUp", "MODAL:Sales_VersionPopUp"], DEAD)
na(["MODAL:ImagePopUp"], "AS-IS `siMain.ImagePopUp`(L203) = FarPoint 셀 이미지 리소스 — 모달 아님(추출 아티팩트)")
na(["MODAL:PopUp"], "md 본문의 일반 단어 매칭 — 실체 없음(추출 아티팩트)")
na(["MODAL:ShowDialog"], "WinForms 모달 표시 **메서드명** — 모달 자체가 아님(추출 아티팩트)")

# ── AS-IS 핸들러 인벤토리 ────────────────────────────────────────────────────
impl(["HANDLER:Form_Load"], f"{P}/SalesReports.tsx mount useEffect")
impl(["HANDLER:FindData"], f"{P}/useSalesReportsStore.ts setFilter + SalesReports.tsx:126 handleSearch")
impl(["HANDLER:EditButton"], f"{P}/utils/sales-reports.editLock.ts evalSalesReportCell (상시편집 + 셀 게이트)")
impl(["HANDLER:InsertRow"], f"{P}/SalesReports.tsx:152 handleInsert (2행 세트 + 잠금 12)")
impl(["HANDLER:DeleteButton"], f"{P}/SalesReports.tsx:174 handleDelete")
impl(["HANDLER:SaveData"], f"{P}/SalesReports.tsx:185 handleSave + utils/sales-reports.save.ts")
impl(["HANDLER:ExcelButton"], f"{P}/SalesReports.tsx hotkeyConfig — 공통 Excel(hook #64 자동 제공)")
impl(["HANDLER:btnExchangeRate_Click"], f"{P}/SalesReports.tsx:273 handleExchangeRate")
impl(["HANDLER:btnMeasure_Click"], f"{P}/SalesReports.tsx:349 customButtons Measure → MeasureSelectModal")
impl(["HANDLER:btnSPVer_Click"], "components/versionModal/VersionModal.tsx 진입 (SalesReportsForm 버전 버튼)")
impl(["HANDLER:btnTextbox_Click"], f"{P}/SalesReports.tsx:291 handleTextbox")
impl(["HANDLER:clbDivision_SelectedIndexChanged"], f"{P}/SalesReports.tsx:141 handleDivisionChange")
impl(["HANDLER:clbType_SelectedIndexChanged"], f"{P}/components/SalesReportsForm.tsx Type 변경 핸들러")
impl(["HANDLER:spdMain_Changed"], f"{P}/components/SalesReportsGrid.tsx cellEditEndedHandler")
impl(["HANDLER:spdMain_CellDoubleClick"], f"{P}/components/SalesReportsGrid.tsx dblclickHandler")
excl(["HANDLER:FindButton", "HANDLER:InsertButton", "HANDLER:SaveButton"],
     "AS-IS 라이브 3행 = 사문(빈 몸통, 실제 동작은 FindData/InsertRow/SaveData 가 수행). 미이관이 파리티")

RE_ROW = re.compile(r"^\|\s*([A-Za-z][\w:.\-]*)\s*\|(.*)\|\s*$")


def main():
    if not MAP.is_file():
        sys.exit("[error] 대사표 없음: %s" % MAP)
    out, filled, missing = [], 0, []
    for line in MAP.read_text(encoding="utf-8").splitlines():
        m = RE_ROW.match(line)
        if not m or m.group(1) not in F:
            out.append(line)
            continue
        cells = [c.strip() for c in m.group(2).split("|")]
        if len(cells) < 4:
            out.append(line)
            continue
        loc, why, st = F[m.group(1)]
        cells[1], cells[2], cells[3] = loc, why, st
        out.append("| %s | %s |" % (m.group(1), " | ".join(cells)))
        filled += 1
    MAP.write_text("\n".join(out) + "\n", encoding="utf-8")
    for k in F:
        if k not in "\n".join(out):
            missing.append(k)
    print("[fill] %d행 기입 → %s" % (filled, MAP))
    if missing:
        print("  ⚠ 사전에는 있으나 대사표에 없는 ID %d개: %s" % (len(missing), ", ".join(missing[:15])))
    print("  사전 정의 %d개 / 기입 %d행" % (len(F), filled))


if __name__ == "__main__":
    main()
