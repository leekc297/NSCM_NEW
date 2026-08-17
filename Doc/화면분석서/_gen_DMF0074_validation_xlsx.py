# -*- coding: utf-8 -*-
"""DMF0074 Metal Link Price — Excel Upload Validation 목록 xlsx 생성기.

원천(전부 실측):
  · SP 원문   : SCM_MGR.PKG_DMF0074 BODY(ALL_SOURCE 덤프) P_DMF0074_EXCEL_UPLOAD L890~2622
  · 메타      : SCM_ADM_EXCEL_COLUMNS(DMF0074 55토큰 / DMF0074_40 53토큰)
  · 실행 검증 : 2026-08-16 사내 Oracle + 로컬 BE HTTP 26케이스 업로드 실측
                (정정 패치 배포 전 PASS 19 → 배포 후 PASS 23) + 원장 적재 왕복 1행 실측
생성: python Doc/화면분석서/_gen_DMF0074_validation_xlsx.py
"""
import pathlib

from openpyxl import Workbook
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter

OUT = pathlib.Path(__file__).parent / "DMF0074_MetalLinkPrice_ExcelUpload_Validation_v1.1.xlsx"

HDR_FILL = PatternFill("solid", fgColor="1F4E79")
HDR_FONT = Font(color="FFFFFF", bold=True, size=10)
SEC_FILL = PatternFill("solid", fgColor="DDEBF7")
BAD_FILL = PatternFill("solid", fgColor="FCE4E4")
OK_FILL = PatternFill("solid", fgColor="E7F4E4")
WARN_FILL = PatternFill("solid", fgColor="FFF2CC")
THIN = Side(style="thin", color="BFBFBF")
BORDER = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)
BASE_FONT = Font(size=10)


def style_sheet(ws, widths, freeze="A3", header_row=2):
    for i, w in enumerate(widths, start=1):
        ws.column_dimensions[get_column_letter(i)].width = w
    for c in ws[header_row]:
        c.fill, c.font = HDR_FILL, HDR_FONT
        c.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
        c.border = BORDER
    for row in ws.iter_rows(min_row=header_row + 1):
        for c in row:
            c.font = BASE_FONT
            c.alignment = Alignment(vertical="top", wrap_text=True)
            c.border = BORDER
    ws.freeze_panes = freeze
    ws.auto_filter.ref = f"A{header_row}:{get_column_letter(ws.max_column)}{ws.max_row}"


def title(ws, text, span):
    ws["A1"] = text
    ws["A1"].font = Font(bold=True, size=12, color="1F4E79")
    ws.merge_cells(f"A1:{get_column_letter(span)}1")
    ws.row_dimensions[1].height = 22


METALS = ["Ni", "Co", "Li2CO3", "LIOH", "Al", "Mn", "Cu"]
# 금속 n번째 ↔ 정규화 ATTRIBUTE (Key / PeriodFr / PeriodTo / ContractPrice / ChangePrice / MetalIndex)
KEY_A = {m: 14 + i for i, m in enumerate(METALS)}
FR_A = {m: 21 + i for i, m in enumerate(METALS)}
TO_A = {m: 28 + i for i, m in enumerate(METALS)}
CP_A = {m: 35 + i for i, m in enumerate(METALS)}
MP_A = {m: 42 + i for i, m in enumerate(METALS)}
MI_A = {m: 49 + i for i, m in enumerate(METALS)}
# 룩업 SEGMENT2 표기 — SP 원문 그대로 (Li2CO3 는 룩업 조회 시 'Li2Co3' 대소문자 상이)
LOOKUP_SEG2 = {"Ni": "Ni", "Co": "Co", "Li2CO3": "Li2Co3", "LIOH": "LIOH",
               "Al": "Al", "Mn": "Mn", "Cu": "Cu"}

GATE = "Metal Link='Y' AND Exception in (N, 공란)"
V = []  # (검증ID, SP라인, 대상항목, ATTRIBUTE, 판정조건, 오류메시지, 적용범위, 선행게이트, 실측, 비고)

# ── C2 : 필수값 NULL (단일 UPDATE 안의 CASE 8분기 — 위에서부터 먼저 걸린 1건만 표기) ──
for item, att, msg, scope, note in [
    # 메시지는 SP MESSAGE_TEXT 원문 그대로 (Div→'NULL DIVISION.' 처럼 항목명과 다른 건이 있음)
    ("Div", "A1", "NULL DIVISION.", "전 division", ""),
    ("Plan Date", "A2", "NULL PLAN DATE.", "전 division", ""),
    ("End Customer", "A4", "NULL END CUSTOMER.", "전 division", ""),
    ("Project Code", "A5", "NULL PROJECT CODE.", "division ≠ 40",
     "40 은 Project Code 열 자체가 없음(53열 카탈로그) — 조건에 ATTRIBUTE1<>'40' 명시"),
    ("Sales Site", "A9", "NULL SALES SITE.", "전 division", ""),
    ("Currency", "A10", "NULL CURRENCY.", "전 division", ""),
    ("FCST type", "A11", "NULL FCST TYPE.", "전 division", ""),
    ("Metal Link", "A8", "NULL Metal Link.", "전 division", "2024.09.06 추가"),
]:
    V.append(("C2", 1260, item, att, f"{item} 값이 공란(NULL)", msg, scope, "-", "PASS", note))
V.append(("C2", 1260, "Team", "A3", "(체크 제외)", "-", "전 division", "-", "-",
          "[PJ2024-50461] 메탈링크 업로드는 팀정보 미관리 → 필수 체크에서 제외(주석 처리)"))

# ── 개별 검증 ──
V.append(("C3", 1308, "Div", "A1",
          "해당 division 에 금주 Sales Plan Waterfall(SP_W) 의 Monthly Rolling Forecast='Y' 버전이 없음",
          "There is no version of Monthly Rolling Forest:Y in Sales Plan Waterfall this week.",
          "전 division", "-", "미검증",
          "테스트 계정 조회 시 40 만 버전 보유 → 40 은 통과. 81/82 는 RESULT_C 0행"))
V.append(("C4", 1330, "Key_* 7종", "A14~A20",
          "Key 7종이 전부 공란", "NULL APPLY PRICE TYPE CODE.", "전 division", GATE, "PASS",
          "요청변경(2024-08-21): 5종 이상 → 1종만 입력해도 통과"))
for i, m in enumerate(METALS):
    V.append((f"C{5+i}", 1357 + i * 23, f"Key_{m}", f"A{KEY_A[m]}",
              f"값이 있으나 LOOKUP 'METAL_KEY_VALUE'(SEG1=Div 앞2자리, SEG2='{LOOKUP_SEG2[m]}', "
              f"SEG3=입력값, VALID_YN='Y') 에 미등재",
              f"Invalid KEY CODE : {m}", "전 division", GATE,
              "PASS" if m == "Ni" else "미검증(동일 패턴)",
              "40 의 Ni 유효코드 실측 = M035 / M036"))
V.append(("C12", 1531, "Div·Plan Date·End Customer·Project Code·Model Code·Sales Site·Currency·FCST type",
          "A1,A2,A4,A5,A7,A9,A10,A11", "동일 8키 조합이 파일 내 2행 이상",
          "Duplication Model.", "전 division", "-", "PASS(정정 후)",
          "결함 D3 — 정정 전에는 division 40 이 Project Code 를 NULL 로 강제(L1174)하는데 상관조건이 "
          "T.COL5 = ATTRIBUTE5 라 NULL=NULL(UNKNOWN) → 40 에서 중복 무검출. "
          "2026-08-16 8개 상관조건 양변 NVL 정정 배포 후 TC25/26 실측 검출 확인"))
V.append(("C13", 1579, "Plan Date", "A2",
          "6자리 숫자(YYYYMM)가 아니거나 월이 01~12 범위 밖", "Invalid Date Format.",
          "전 division", "-", "PASS", ""))
V.append(("C14", 1598, "Plan Date", "A2", "당월(SYSDATE YYYYMM)보다 과거", "Past Date.",
          "전 division", "-", "PASS", ""))
V.append(("C15", 1623, "End Customer", "A4",
          "LOOKUP 'END_CUSTOMER'(SEG1=Div, SEG2=입력값, VALID_YN='Y') 미등재",
          "Invalid END CUSTOMER.", "전 division", "-", "PASS", ""))
V.append(("C15", 1639, "Project Code", "A5",
          "SCM_MST_PROJECT(DIVISION_ID, PROJECT_CODE) 미등재", "Invalid PROJECT CODE.",
          "division ≠ 40", "-", "미검증", "40 은 대상 외"))
V.append(("C16", 1662, "Model Code", "A7",
          "SCM_MST_SITE ⋈ SCM_MST_SITE_ITEM 조합(Div, Project Code, Site, Item, VALID_YN='Y') 미존재",
          "Invalid MODEL.", "전 division", "-", "PASS(정정 후)",
          "결함 D1 — 정정 전에는 NVL(ATTRIBUTE7,'')<>'' 가 항상 UNKNOWN 이라 영구 미발동이었음. "
          "2026-08-16 센티널 정정 배포 후 TC13 실측 'Invalid MODEL.' 정상 출력"))
V.append(("C17", 1693, "Model Code", "A7",
          "82 사업부에서 ENERGY 값이 없는 모델", "Invalid MODEL : NULL ENERGY",
          "division 82", "-", "정정됨(82 데이터 미보유로 미실행)", "결함 D1 동일 원인·동일 정정"))
V.append(("C18", 1716, "Model Code", "A7",
          "DM_MST_ITEM_SINGLE_V.ITEM_TYPE 이 '제품(P)' 이 아님", "Invalid MODEL : TYPE P.",
          "전 division", "-", "정정됨(케이스 미구성)", "결함 D1 동일 원인·동일 정정"))
V.append(("C19", 1737, "Model Code·Sales Site·Currency·FCST type", "A7,A9,A10,A11",
          "금주 MRF 버전의 DM_PLN_SALES_PLAN_RESULT_C 에 (Div, Project/EndCust, Item, Site, Currency, "
          "FCST type) 조합이 없음", "Invalid Sales Plan Waterfall MODEL.", "전 division", "-", "PASS",
          "C21·C22·C23 보다 먼저 실행 → Sales Site/Currency/FCST type 오류도 이 메시지로 먼저 표기됨(마스킹)"))
V.append(("C20", 1816, "Metal Link", "A8", "UPPER(값) 이 'Y'/'N' 이 아님", "Invalid Metal Link.",
          "전 division", "-", "PASS", ""))
V.append(("C21", 1833, "Sales Site", "A9", "SCM_MST_SITE(Div, Site, VALID_YN='Y') 미등재",
          "Invalid Sales Site.", "전 division", "-", "PASS(마스킹)",
          "단독 재현 시 C19 가 먼저 걸림 — 조건 자체는 정상"))
V.append(("C22", 1854, "Currency", "A10", "DM_MST_EXCHANGE_RATE(Div, UNIT_CURRENCY) 미등재",
          "Invalid CURRENCY.", "전 division", "-", "PASS(마스킹)", "C19 선행 마스킹 동일"))
V.append(("C23", 1876, "FCST type", "A11",
          "LOOKUP 'SALES_TYPE_CODE'(SEG2=입력값, SEG4<>'FREE', VALID_YN='Y') 미등재",
          "Invalid FCST TYPE.", "전 division", "-", "PASS(마스킹)", "C19 선행 마스킹 동일"))
V.append(("C24", 1899, "Exception", "A12", "값이 있고 UPPER(값) 이 'Y'/'N' 이 아님",
          "Invalid EXCEPTION.", "전 division", "-", "PASS(정정 후)",
          "결함 D2 — 정정 전 실측: Exception='Q' 가 오류 없이 SUCCESS(원장 유입 가능). "
          "2026-08-16 센티널 정정 배포 후 TC17 실측 'Invalid EXCEPTION.' 정상 출력"))
V.append(("C25", 1926, "(GTT 적재)", "-",
          "LOOKUP 'METAL_KEY_VALUE' 중 SEGMENT4 IN ('미사용','미연동') 코드 수집",
          "-", "전 division", "-", "-", "검증이 아니라 C26~C39 의 판정 기준 GTT 적재 단계"))
for i, m in enumerate(METALS):
    V.append((f"C{26+i}", 1942 + i * 31, f"PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_{m}",
              f"A{FR_A[m]},A{TO_A[m]},A{CP_A[m]},A{MP_A[m]},A{MI_A[m]}",
              f"Key_{m} 가 공란이거나 '미사용/미연동' 코드인데 5개 값 중 하나라도 입력됨",
              f"NEED EMPTY VALUE - {m} : (Period(Fr)/Period(To)/Contract Price/Change Price/"
              f"Metal Index (Fr) 중 먼저 걸린 항목명)", "전 division", GATE, "미검증", ""))
for i, m in enumerate(METALS):
    V.append((f"C{33+i}", 2173 + i * 30, f"PeriodFr/To·ContractPrice·ChangePrice·MetalIndex_{m}",
              f"A{FR_A[m]},A{TO_A[m]},A{CP_A[m]},A{MP_A[m]},A{MI_A[m]}",
              f"Key_{m} 가 유효코드인데 5개 값 중 하나라도 공란",
              f"NULL {m} : (Period(Fr)/Period(To)/Contract Price/Change Price/"
              f"Metal Index (Fr) 중 먼저 걸린 항목명)",
              "division 앞2자리 ≠ 81", GATE, "PASS(Ni)" if m == "Ni" else "미검증(동일 패턴)",
              "[PJ2024-50461] 81 사업부는 광물 미입력 체크 제외"))
V.append(("C40", 2395, "PeriodFr/To·ContractPrice·ChangePrice·MetalIndex 전 35열", "A21~A55",
          r"값이 있으나 숫자 형식(^-?[0-9]+(\.[0-9]+)?$) 아님", "Invalid NUMERIC.",
          "전 division", GATE, "PASS", ""))
V.append(("C41", 2455, "PeriodFr/To·ContractPrice·ChangePrice 28열", "A21~A48",
          "숫자이지만 음수", "Negative Number.", "전 division", GATE, "PASS",
          "MetalIndex(A49~A55) 는 음수 허용"))
V.append(("C42", 2509, "PeriodFr/To 14열", "A21~A34",
          "12 초과이거나 소수점 포함", "Invalid INTEGER 0 ~ 12.", "전 division", GATE, "PASS", ""))
V.append(("C43", 2554, "PeriodFr_* / PeriodTo_* 7쌍", "A21~A27 ↔ A28~A34",
          "PeriodFr <= PeriodTo (From 이 To 보다 크지 않음)",
          "From Value must be larger than To Value.", "전 division", GATE, "PASS", ""))
V.append(("C44", 2586, "(결과 반영)", "-",
          "GTT 판정(ERROR) 을 SCM_ADM_EXCEL_UPLOAD 원본에 MERGE", "-", "-", "-", "-",
          "소숫점 2자리 체크는 미수행 — 셋째 자리 반올림 처리(2024.07.08 확인)"))
V.append(("GATE", 2649, "(전량 게이트)", "-",
          "ERROR 행이 1건이라도 있으면 P_MODE=1(적재) 자체를 수행하지 않음", "-", "전 division", "-",
          "PASS", "실측: 오류 21건 상태에서 OK 호출 → 원장 DM_BPS_METAL_LINK_PRICE Δ0 / _H Δ0"))

wb = Workbook()

# ── Sheet 1 : Validation 목록 ──
ws = wb.active
ws.title = "1_Validation목록"
cols = ["No", "검증ID(SP LOG)", "SP 라인", "대상 항목(엑셀 헤더)", "ATTRIBUTE(정규화)", "판정 조건",
        "오류 메시지(MESSAGE_TEXT)", "적용 범위", "선행 게이트", "실측(2026-08-16)", "비고"]
title(ws, "DMF0074 Metal Link Price — Excel Upload Validation 목록 "
          "(SP: PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD, P_MODE=0 검증단계 / 총 "
          f"{len([v for v in V if v[5] != '-'])} 판정 · 실행순서대로)", len(cols))
ws.append(cols)
for i, v in enumerate(V, start=1):
    ws.append([i, v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9]])
style_sheet(ws, [5, 13, 8, 30, 20, 52, 44, 14, 26, 16, 46])
for r in range(3, ws.max_row + 1):
    val = str(ws.cell(r, 10).value)
    if "FAIL" in val or "DEAD" in val:
        for c in range(1, len(cols) + 1):
            ws.cell(r, c).fill = BAD_FILL
    elif val.startswith("PASS"):
        ws.cell(r, 10).fill = OK_FILL
    elif "미검증" in val:
        ws.cell(r, 10).fill = WARN_FILL

# ── Sheet 2 : 실행 테스트 결과 ──
ws2 = wb.create_sheet("2_실행테스트결과")
title(ws2, "실제 업로드 실행 테스트 — 2026-08-16 / 사내 Oracle(OCGSCMD_P01) + 로컬 BE / "
           "계정 minyonglee1 / division 40 / DMF0074_40(53열) / 26행 1파일", 6)
ws2.append(["TC", "케이스", "기대 메시지", "정정 전 실측", "정정 전 판정", "정정 후 재실행 판정"])
TC = [
    # (TC, 케이스, 기대 메시지, 정정 전 실측, 정정 전 판정, 정정 후 재실행 판정)
    ("TC01", "정상 (Metal Link=N)", "(정상)", "SUCCESS", "PASS", "PASS"),
    ("TC02", "정상 (Metal Link=Y, 광물 1종 완전입력)", "(정상)", "SUCCESS", "PASS", "PASS"),
    ("TC03", "Plan Date 공란", "NULL PLAN DATE.", "NULL PLAN DATE.", "PASS", "PASS"),
    ("TC04", "Plan Date 형식오류(2026-09)", "Invalid Date Format.", "Invalid Date Format.", "PASS", "PASS"),
    ("TC05", "Plan Date 과거월(202601)", "Past Date.", "Past Date.", "PASS", "PASS"),
    ("TC06", "End Customer 공란", "NULL END CUSTOMER.", "NULL END CUSTOMER.", "PASS", "PASS"),
    ("TC07", "Sales Site 공란", "NULL SALES SITE.", "NULL SALES SITE.", "PASS", "PASS"),
    ("TC08", "Currency 공란", "NULL CURRENCY.", "NULL CURRENCY.", "PASS", "PASS"),
    ("TC09", "FCST type 공란", "NULL FCST TYPE.", "NULL FCST TYPE.", "PASS", "PASS"),
    ("TC10", "Metal Link 공란", "NULL Metal Link.", "NULL Metal Link.", "PASS", "PASS"),
    ("TC11", "Metal Link 코드오류(X)", "Invalid Metal Link.", "Invalid Metal Link.", "PASS", "PASS"),
    ("TC12", "End Customer 미등록", "Invalid END CUSTOMER.", "Invalid END CUSTOMER.", "PASS", "PASS"),
    ("TC13", "Model 미등록", "Invalid MODEL.", "Invalid Sales Plan Waterfall MODEL.",
     "FAIL(결함 D1)", "PASS ✅ 정정확인"),
    ("TC14", "Sales Site 미등록", "Invalid Sales Site.", "Invalid Sales Plan Waterfall MODEL.",
     "FAIL(순서 마스킹)", "FAIL — D5 미조치(순서 이슈, 별도 판단)"),
    ("TC15", "Currency 미등록", "Invalid CURRENCY.", "Invalid Sales Plan Waterfall MODEL.",
     "FAIL(순서 마스킹)", "FAIL — D5 미조치"),
    ("TC16", "FCST type 미등록", "Invalid FCST TYPE.", "Invalid Sales Plan Waterfall MODEL.",
     "FAIL(순서 마스킹)", "FAIL — D5 미조치"),
    ("TC17", "Exception 코드오류(Q)", "Invalid EXCEPTION.", "(오류 미검출·SUCCESS)",
     "FAIL(결함 D2)", "PASS ✅ 정정확인"),
    ("TC18", "Metal Link=Y + Key 전무", "NULL APPLY PRICE TYPE CODE.",
     "NULL APPLY PRICE TYPE CODE.", "PASS", "PASS"),
    ("TC19", "Key 코드 오류(Ni=BOGUS)", "Invalid KEY CODE : Ni", "Invalid KEY CODE : Ni", "PASS", "PASS"),
    ("TC20", "PeriodFr 비숫자(abc)", "Invalid NUMERIC.", "Invalid NUMERIC.", "PASS", "PASS"),
    ("TC21", "PeriodFr 음수(-1)", "Negative Number.", "Negative Number.", "PASS", "PASS"),
    ("TC22", "PeriodFr 12 초과(13)", "Invalid INTEGER 0 ~ 12.", "Invalid INTEGER 0 ~ 12.", "PASS", "PASS"),
    ("TC23", "PeriodFr(1) <= PeriodTo(3)", "From Value must be larger than To Value.",
     "From Value must be larger than To Value.", "PASS", "PASS"),
    ("TC24", "Key 유효 + Period 전무", "NULL Ni : ", "NULL Ni : Period(Fr) ", "PASS", "PASS"),
    ("TC25", "중복행 A (8키 동일)", "Duplication Model.", "(오류 미검출·SUCCESS)",
     "FAIL(결함 D3)", "PASS ✅ 정정확인"),
    ("TC26", "중복행 B (A와 동일키)", "Duplication Model.", "(오류 미검출·SUCCESS)",
     "FAIL(결함 D3)", "PASS ✅ 정정확인"),
]
for t in TC:
    ws2.append(list(t))
ws2.append([])
ws2.append(["합계", "26행 1파일", "정정 전 Total=26 Success=5 Error=21", "정정 후 Total=26 Success=2 Error=24", "PASS 19 · FAIL 7", "PASS 23 · FAIL 3"])
ws2.append(["게이트", "오류 잔존 상태에서 [OK](P_MODE=1) 호출", "적재 차단 + 원장 불변",
            "DM_BPS_METAL_LINK_PRICE Δ0 / _H Δ0", "PASS", "PASS (정정 전·후 동일)"])
style_sheet(ws2, [8, 40, 40, 12, 42, 18])
for r in range(3, ws2.max_row + 1):
    val = str(ws2.cell(r, 6).value)
    if val.startswith("FAIL"):
        for c in range(1, 7):
            ws2.cell(r, c).fill = BAD_FILL
    elif val.startswith("PASS"):
        ws2.cell(r, 6).fill = OK_FILL

# ── Sheet 3 : 발견 결함 ──
ws3 = wb.create_sheet("3_발견결함")
title(ws3, "실행 테스트에서 확인된 결함 (전부 재현 SQL 로 원인 확정)", 7)
ws3.append(["ID", "심각도", "제목", "현상(실측)", "근본 원인", "재현/근거", "권고 조치 · 조치 결과"])
STATUS = {
    "D1": "✅ 2026-08-16 사내 적용 완료 — 재검증 TC13 PASS",
    "D2": "✅ 2026-08-16 사내 적용 완료 — 재검증 TC17 PASS",
    "D3": "✅ 2026-08-16 사내 적용 완료 — 재검증 TC25/26 PASS",
    "D6": "✅ 2026-08-16 사내 적용 완료 — 케이스 미구성(회귀 없음 확인)",
    "D7": "✅ 2026-08-16 사내 적용 완료 — 형제 블록과 표준식 통일",
    "D4": "⏸ 보류 — 응답 계약 변경이라 별도 판단 필요(FE 모달이 Error>0 시 [OK] 차단 중)",
    "D5": "⏸ 보류 — 검증 순서 변경이라 AS-IS 파리티 확인 후 판단. 잔여 FAIL 3건(TC14~16)이 이 건",
}
D = [
    ("D1", "중", "모델 검증 3종(C16·C17·C18) 영구 미발동",
     "미등록 모델(ZZ_NO_MODEL) 업로드 시 'Invalid MODEL.' 이 아니라 C19 의 "
     "'Invalid Sales Plan Waterfall MODEL.' 로 표기. ENERGY 없는 82 모델·ITEM_TYPE≠P 검증도 무발동",
     "선행조건 NVL(ATTRIBUTE7,'') <> '' 가 Oracle 에서 ''=NULL 이라 항상 UNKNOWN → WHERE 전체가 거짓. "
     "MSSQL ISNULL(x,'')<>'' 를 직역한 변환 결함",
     "SELECT CASE WHEN NVL('MODEL1','')<>'' THEN 'FIRE' ELSE 'DEAD' END FROM DUAL → DEAD "
     "(센티널판 NVL(x,'@#@#@#')<>'@#@#@#' → FIRE)",
     "3개소를 NVL(ATTRIBUTE7,'@#@#@#') <> '@#@#@#' 로 정정 (동 SP 내 C19 가 이미 쓰는 표준식). "
     "정정 시 오류 메시지가 구체화되므로 AS-IS 메시지 대조 후 적용"),
    ("D2", "높", "Exception 코드 검증(C24) 영구 미발동 — 잘못된 값이 원장 유입",
     "Exception='Q' 행이 오류 없이 SUCCESS 판정(실측 TC17). 전량 게이트도 통과하므로 "
     "P_MODE=1 에서 원장 적재 대상이 됨",
     "NVL(ATTRIBUTE12,'') <> '' 가 항상 UNKNOWN → 'Y/N 아님' 판정에 도달 불가. D1 과 동일 계보",
     "TC17 실측 SUCCESS + NVL 술어 DEAD 재현",
     "NVL(ATTRIBUTE12,'@#@#@#') <> '@#@#@#' 로 정정. 원장 METAL_EXCEPTION_YN 오염분 사후 점검 권고"),
    ("D3", "높", "중복 업로드 검증(C12)이 division 40 에서 무작동",
     "8키가 완전히 동일한 2행을 올려도 'Duplication Model.' 미검출 → 두 행 모두 SUCCESS "
     "(실측 TC25/TC26). 40 은 원장 MERGE 시 동일 키 2행이 유입",
     "40 은 L1174 에서 Project Code 를 '' (=Oracle NULL) 로 강제하는데, 중복 판정 상관조건이 "
     "T.COL5 = ATTRIBUTE5 → NULL=NULL 은 UNKNOWN 이라 EXISTS 가 항상 거짓. "
     "MSSQL 에서는 ''=''  가 TRUE 라 정상 작동하던 로직",
     "동일 형태 SQL 재현: div 81(PRJ 값 있음)=DUP 검출 / div 40(PRJ NULL)=미검출 (4행 대조 실측)",
     "상관조건을 NVL(T.COL5,'@#@#@#') = NVL(ATTRIBUTE5,'@#@#@#') 로 정정 "
     "(또는 40 의 Project Code 를 센티널 '-' 로 통일 — PK 센티널 표준과 정합)"),
    ("D4", "중", "P_MODE=1 이 아무것도 적재하지 않고도 CODE='0' SUCCESS 반환",
     "오류 21건 잔존 상태에서 [OK] 호출 → 원장 Δ0 인데 응답은 "
     "{CODE:'0', MSG:'SUCCESS', EVENT:'0'}",
     "IF P_MODE>0 AND V_COUNT=0 블록을 건너뛴 뒤에도 말미에서 공통 SUCCESS 커서를 연다 "
     "(적재 0건 가드 없음)",
     "실측 ③ — 원장 DM_BPS_METAL_LINK_PRICE Δ0 / _H Δ0 인데 SUCCESS",
     "DMF0014 에 이미 적용된 '허위 성공 차단 가드'(적재 0건이면 CODE='-1') 를 동일 적용. "
     "현재는 FE 모달이 Error>0 이면 [OK] 를 막아 실사용 노출은 없음"),
    ("D6", "중", "CURRENCY 폴백(2024.10.22 요구)이 사문화 — C19 2개소",
     "SPW 원장(RESULT_C/PLAN_C) 의 CURRENCY 가 NULL 인 조합은 SSPM(SITE_ITEM) 통화로 대체돼 통과해야 하는데, "
     "대체가 일어나지 않아 항상 'Invalid Sales Plan Waterfall MODEL.' 로 탈락",
     "CASE WHEN NVL(RC.CURRENCY,'') = '' THEN SI.CURRENCY ELSE RC.CURRENCY END 에서 "
     "NVL(x,'')='' 가 항상 UNKNOWN → 무조건 ELSE(RC.CURRENCY) 분기. NULL 과 비교하므로 조인 실패",
     "SP L1760(RESULT_C) · L1790(PLAN_C) 정적 확인 + D1 과 동일한 술어 재현",
     "NVL(RC.CURRENCY, SI.CURRENCY) 로 정정 (2024.10.22 주석의 의도 그대로)"),
    ("D7", "낮", "Exception 게이트가 형제 블록과 불일치 — C10·C26",
     "Exception 이 공란인 행에서 C10(Key_Mn 룩업)·C26(NEED EMPTY VALUE - Ni) 만 검사에서 제외됨. "
     "나머지 형제 블록(C5~C9, C11, C27~C32)은 검사함",
     "두 곳만 (ATTRIBUTE12='N' OR ATTRIBUTE12='') 로 쓰여 있고 ''=NULL 이라 뒷항이 항상 UNKNOWN. "
     "다른 블록은 NVL(ATTRIBUTE12,'@#@#@#')='@#@#@#' 표준식 사용",
     "SP L1476 · L1952 정적 확인(동일 SP 내 형제 20여 블록과 문자열 대조)",
     "형제 블록과 동일한 센티널 표준식으로 통일"),
    ("D5", "낮", "C19 가 C21·C22·C23 보다 먼저 실행돼 구체 메시지를 가림",
     "Sales Site/Currency/FCST type 이 미등록이면 각각의 메시지 대신 "
     "'Invalid Sales Plan Waterfall MODEL.' 로 표기(실측 TC14·TC15·TC16)",
     "C19 의 조합 검증이 Site/Currency/FCST type 을 조인 키로 포함 — 실행 순서상 선행",
     "TC14/15/16 실측",
     "AS-IS 파리티 확인 후 판단. 사용자 안내 관점에서는 C21~C23 을 C19 앞으로 옮기는 것이 "
     "원인 파악에 유리 (기능 결함은 아님)"),
]
for d in D:
    row = list(d)
    row[6] = f"{row[6]}\n\n[조치] {STATUS.get(row[0], '-')}"
    ws3.append(row)
style_sheet(ws3, [6, 8, 40, 52, 52, 46, 52])
for r in range(3, ws3.max_row + 1):
    ws3.cell(r, 2).fill = BAD_FILL if ws3.cell(r, 2).value == "높" else WARN_FILL

# ── Sheet 4 : 엑셀 헤더 ↔ ATTRIBUTE 매핑 ──
ws4 = wb.create_sheet("4_헤더매핑")
title(ws4, "SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT 토큰 ↔ 스테이징 ATTRIBUTE 매핑 (실측 2026-08-16) — "
           "DMF0074=55열 / DMF0074_40=53열(Project Code·Project 없음). "
           "SP 가 40 을 2칸 시프트해 정규화 열로 맞춘다", 5)
ws4.append(["토큰 순번(DMF0074)", "엑셀 헤더 토큰", "DMF0074 ATTRIBUTE", "DMF0074_40 ATTRIBUTE",
            "정규화(GTT) ATTRIBUTE / 의미"])
base = ["Div", "Plan Date", "Team", "End Customer", "Project Code", "Project", "Model Code",
        "Metal Link", "Sales Site", "Currency", "FCST type", "Exception", "Energy"]
norm_meaning = {
    "Div": "A1 DIVISION_ID", "Plan Date": "A2 PLAN_YYYYMM", "Team": "A3 DEPT_NAME(미사용)",
    "End Customer": "A4 END_CUSTOMER", "Project Code": "A5 PROJECT_CODE(40=NULL 강제)",
    "Project": "(정규화 대상 아님)", "Model Code": "A7 ITEM_ID", "Metal Link": "A8 METAL_LINK_YN",
    "Sales Site": "A9 SCM_SITE_ID", "Currency": "A10 CURRENCY", "FCST type": "A11 FCST_TYPE",
    "Exception": "A12 METAL_EXCEPTION_YN", "Energy": "A13 ENERGY",
}
n40 = 0
for i, h in enumerate(base, start=1):
    if h in ("Project Code", "Project"):
        a40 = "(열 없음)"
    else:
        n40 += 1
        a40 = f"A{n40}"
    ws4.append([i, h, f"A{i}", a40, norm_meaning[h]])
grp_norm = [("Key", "APPLY_PRICE_TYPE_CODE", 14), ("PeriodFr", "FROM_PERIOD", 21),
            ("PeriodTo", "TO_PERIOD", 28), ("ContractPrice", "CONTRACT_UNIT", 35),
            ("ChangePrice", "METAL_APPLY", 42), ("MetalIndex", "METAL_REQR", 49)]
idx = 14
for g, col, start in grp_norm:
    for j, m in enumerate(METALS):
        n40 += 1
        ws4.append([idx, f"{g}_{m}", f"A{idx}", f"A{n40}", f"A{start+j} {col}{j+1}"])
        idx += 1
style_sheet(ws4, [16, 22, 18, 20, 34])

# ── Sheet 5 : 원천·재현 방법 ──
ws5 = wb.create_sheet("5_원천및재현")
title(ws5, "원천 · 재현 방법 (모두 실측 — 추정 없음)", 2)
ws5.append(["항목", "내용"])
for k, v in [
    ("작성일", "2026-08-16"),
    ("SP 원문", "SCM_MGR.PKG_DMF0074 PACKAGE BODY (ALL_SOURCE 3,973줄 덤프) 중 "
                "P_DMF0074_EXCEL_UPLOAD L890~2622"),
    ("SP 시그니처", "P_MODE(0=검증 / >0=적재), P_CREATED_BY, P_PROGRAM_ID, P_SHEET_NAME, O_RESULT_CURSOR"),
    ("2단 계약", "① [Upload] → POST /{formId}/{sheet}/UPLOAD/excel-upload (P_MODE=0, 검증·분류) / "
                 "② [OK] → POST /DMF0074/{sheet}/SAVE/call-proc {mode:1} (Error=0 일 때만 적재)"),
    ("formId", "division 40 = 'DMF0074_40'(53열) / 그 외 = 'DMF0074'(55열). "
               "⚠ 40 을 DMF0074 로 올리면 SP 의 2칸 시프트와 어긋나 전 행 'NULL Metal Link.' 로 떨어짐(실측)"),
    ("스테이징", "SCM_MGR.SCM_ADM_EXCEL_UPLOAD (PROGRAM_ID/SHEET_NAME/CREATED_BY/CREATION_DATE 최신 배치). "
                 "헤더행은 UPLOAD_STATUS_CODE='@TITLE'"),
    ("검증 GTT", "SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW (40 은 여기 적재 시 2칸 시프트 정규화)"),
    ("적재 대상", "SCM_MGR.DM_BPS_METAL_LINK_PRICE (MERGE) + DM_BPS_METAL_LINK_PRICE_H (이력 INSERT)"),
    ("메타", "SCM_ADM_EXCEL_COLUMNS 2행(DMF0074 / DMF0074_40, STORAGE_SQL_ID="
             "PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD)"),
    ("테스트 환경", "사내 Oracle 100.65.143.121:1521/OCGSCMD_P01 + 로컬 BE(localhost:8080) / "
                    "계정 minyonglee1(ADMIN) / division 40"),
    ("테스트 파일", "26행 1파일 — Team 열에 케이스 마커 TC01~TC26 (Team 은 검증 대상 아님) "
                    "→ 스테이징 ATTRIBUTE3 로 케이스별 1:1 대조"),
    ("원장 영향", "없음 — 오류 잔존 상태에서만 [OK] 를 호출해 전량 게이트 차단을 실증. "
                  "DM_BPS_METAL_LINK_PRICE 36,870 / _H 1,539 사전·사후 동일"),
]:
    ws5.append([k, v])
style_sheet(ws5, [16, 130])

# ── Sheet 6 : 정정 패치 (작성 완료 / 배포 대기) ──
ws6 = wb.create_sheet("6_정정패치")
title(ws6, "정정 패치 — 파일 작성 완료 · 사내 DB 배포는 미실행(권한 승인 대기)", 5)
ws6.append(["결함", "SP 위치", "정정 전", "정정 후", "건수"])
for d_, loc, before, after, n in [
    ("D1", "L1666 / L1697 / L1720", "NVL(ATTRIBUTE7, '') <> ''",
     "NVL(ATTRIBUTE7, '@#@#@#') <> '@#@#@#'", 3),
    ("D2", "L1903", "NVL(ATTRIBUTE12, '') <> ''",
     "NVL(ATTRIBUTE12, '@#@#@#') <> '@#@#@#'", 1),
    ("D7", "L1476 / L1952", "(ATTRIBUTE12 ='N' OR ATTRIBUTE12 ='')",
     "(ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')", 2),
    ("D6", "L1760", "CASE WHEN NVL(RC.CURRENCY,'')='' THEN SI.CURRENCY ELSE RC.CURRENCY END",
     "NVL(RC.CURRENCY, SI.CURRENCY)", 1),
    ("D6", "L1790", "CASE WHEN NVL(PC.CURRENCY,'')='' THEN SI.CURRENCY ELSE PC.CURRENCY END",
     "NVL(PC.CURRENCY, SI.CURRENCY)", 1),
    ("D3", "L1557~L1565", "T.COLn = ATTRIBUTEn (8개 상관조건)",
     "NVL(T.COLn,'@#@#@#') = NVL(ATTRIBUTEn,'@#@#@#') (8개 전부 NULL 안전)", 1),
]:
    ws6.append([d_, loc, before, after, n])
ws6.append([])
for k, v in [
    ("패치 파일", "_artifacts/_apply_corporate/PKG_DMF0074_BODY_NULLFIX_20260816.sql (3,975줄 전체 본문)"),
    ("백업 파일", "_artifacts/_apply_corporate/BACKUP_PKG_DMF0074_BODY_pre_nullfix_20260816.sql (3,973줄)"),
    ("마커", "[E20260816-NULLFIX] — 정정 지점마다 인라인 주석"),
    ("치환 검증", "기대 건수 불일치 시 즉시 중단하는 가드로 생성 — 실측 3/1/2/1/1/1 전부 일치, "
                  "잔존 NVL(x,'') 비교 0건"),
    ("배포 상태", "✅ 사내 적용 완료 (2026-08-16, 사용자 승인) — PACKAGE / PACKAGE BODY 모두 VALID, "
                  "컴파일 에러 0건"),
    ("배포 후 재검증", "26케이스 재실행 PASS 19 → 23. TC13(Invalid MODEL.) · TC17(Invalid EXCEPTION.) · "
                       "TC25/26(Duplication Model.) 전부 PASS 전환 확인. "
                       "정상 케이스 TC01/TC02 회귀 없음"),
    ("미적용 항목", "D4(허위 성공 가드) · D5(검증 순서) — 응답 계약/순서 변경이라 별도 판단 대상으로 보류. "
                    "잔여 FAIL 3건(TC14~16)은 전부 D5"),
    ("클라우드", "⛔ 미적용 — 사내만 적용. 이관 패키지 별도 작성 필요"),
    ("원복 방법", "BACKUP_PKG_DMF0074_BODY_pre_nullfix_20260816.sql 를 그대로 실행하면 정정 전으로 복귀"),
]:
    ws6.append([k, v, "", "", ""])
style_sheet(ws6, [8, 24, 58, 58, 6])

# ── Sheet 7 : 원장 적재(P_MODE=1) 왕복 실측 ──
ws7 = wb.create_sheet("7_원장적재왕복")
title(ws7, "2단계 ②[OK] P_MODE=1 실제 원장 적재 왕복 실측 (2026-08-16, 사용자 승인) — "
           "정정 패치 배포 후 · div 40 · 1행", 3)
ws7.append(["단계", "수행 내용", "실측 결과"])
for step, act, res in [
    ("사전 확인", "대상 월 202609 원장 행수 (전 division)", "0행 — 안전 삭제 전제 성립 "
                  "(202608 이후 데이터가 전 division 통틀어 없음. 40 최신=202607 15행)"),
    ("기준선", "DM_BPS_METAL_LINK_PRICE / _H 카운트", "36,870 / 1,539"),
    ("① Upload", "1행 업로드(Metal Link=Y, Ni 1종 완전입력) → P_MODE=0",
     "Total=1 Success=1 Error=0"),
    ("② OK", "SAVE call-proc {mode:1} → P_MODE=1", "CODE='0' MSG='SUCCESS' EVENT='1'"),
    ("적재 검증", "원장 신규 행 실조회", "1행 적재 — DIVISION_ID=40 / PLAN_YYYYMM=202609 / "
                  "END_CUSTOMER=Ather Energy / PROJECT_CODE=- (40 센티널) / PLANT_SITE_ID=NJ01 / "
                  "ITEM_ID=MCCM356015B1 / SCM_SITE_ID=Ather Energy_IN_BLR / CURRENCY=USD / "
                  "FCST_TYPE=MPS / METAL_KIND_CODE=Ni / APPLY_PRICE_TYPE_CODE=M035 / "
                  "FROM_PERIOD=6 / TO_PERIOD=0 / CONTRACT_UNIT_PRICE=1 / METAL_APPLY=1 / "
                  "METAL_REQR=1 / CREATED_BY=minyonglee1 / ATTRIBUTE10=SP_W_20260515_V001"),
    ("이력", "DM_BPS_METAL_LINK_PRICE_H", "1행 append (설계상 이력 테이블)"),
    ("변환 확인", "업로드 'Mass' → 원장 FCST_TYPE", "'MPS' — SP 가 LOOKUP SALES_TYPE_CODE 로 "
                  "표시명→코드 변환 (정상 동작)"),
    ("변환 확인", "div 40 Project Code", "'-' 센티널로 저장 — MERGE ON NVL(B.PROJECT_CODE,'-') 와 정합"),
    ("원복", "PLAN_YYYYMM='202609' 키만 정밀 삭제 (PRICE 1행 + _H 1행)", "삭제 1 / 1"),
    ("최종", "카운트 복원 확인", "36,870 / 1,539 — 사전과 완전 동일 (복원 PASS)"),
]:
    ws7.append([step, act, res])
style_sheet(ws7, [12, 46, 92])

wb.save(OUT)
print(f"생성 완료 -> {OUT}")
print(f"  Sheet1 Validation {len(V)} 행 / Sheet2 TC {len(TC)} / Sheet3 결함 {len(D)}")
