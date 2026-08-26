# 추출 사양 (extract_spec.md) — DMF 13UI 조회조건 MATRIX

## 목적
담당 UI 별로 조회조건(SearchArea/필터 영역)의 AS-IS ↔ TO-BE 전수 레코드를 JSON 으로 산출.
**예측 금지 — 소스·메타 실측만.** 산출 위치: `extract/{MENU_ID}.json` (UTF-8).

## 원천 (모두 읽기 전용)
- AS-IS 본문: `asis_stripped/{MENU_ID}.cs` — **주석이 공백 치환된 전처리본. 반드시 이것으로 분석**
  (hook #138: 주석은 분석 근거 아님). 라인번호 = 원본과 1:1 이므로 evidence 는 이 라인번호 그대로.
- AS-IS Designer: 원본 폴더의 `{원본명}.Designer.cs` — 컨트롤 타입·라벨 텍스트·배치 확인용
  (InitializeComponent). 주석처리된 코드는 근거 금지.
- AS-IS 콤보 SQL: `C:\Projects\NSCM\GSCM\04.WSL\FoxQuery\DM\Common\BigFilter.xml`
  (GetDMInnerTable 계열 — sql id="list_line_dm" 멀티 result-set. DataService.cs:3682 의
  switch(result_columname) 가 Tables[n] 인덱스 매핑) /
  `C:\Projects\NSCM\_artifacts\_diagnostics\asis_sp_bodies\UP_FX_GetCommonDataList.sql`
  (Data.Common → @Code 분기. ⚠ 같은 폴더 `_asis_*.live.sql` 은 인코딩 깨짐 — 사용 금지).
  Data.Common 경로의 실 SP 는 `UP_FX_GetCommonDataList_SCP`(모듈 dispatcher) — 브랜치가 위 파일에
  없으면 `combo_note` 에 "「_SCP 변형 — 본 파일 미수록」" 이라 적고 **내용을 지어내지 말 것**.
- Data.Type enum(→@Code 매핑): `C:\Projects\NSCM\GSCM\01.Framework\GSCM.Windows.Forms\Class\Data_SCP.cs`
  (231 enum, [Description] = @Code. `Common(type, isAddALL, param1..5)` — isAddALL=true 는 BLL 이
  CODE='ALL' 행을 0번에 삽입).
- TO-BE Form: 지정된 `*Form.tsx` **전문 Read** + 같은 화면 store(`use*Store.ts`) 의 searchParams
  초기값(default)·setFilters 매핑 부분. Form 밖(페이지 루트)에 조회조건 관련 콤보가 있으면 포함.
- TO-BE 공용 필드: `C:\Projects\NSCM\nscm-fe\features\master\src\components\searchFields\SearchFields.tsx`
  — `<XxxField>` 사용 시 내부 기본 comboId·바인드 파라미터·disabled 조건을 여기서 확인
  (기본: DivisionField=MyDivision / TeamField=TeambyDivision / EndCustomerField=EndCustomer /
  SalesSiteField=SalesSite / PlantSiteField=PlantSitebyEndCustomer(disabled=!division.startsWith('81')) /
  BizTypeField=BizType / BucketField=BucketType / Project·Item·Owner·Version=팝업 / Period=달력 /
  SearchOverRange=체크). `comboId` prop 오버라이드·동적 comboId 는 실코드 그대로 기재.
- TO-BE 콤보 메타: `cmbo_meta.json` (SCM_ADM_CMBO_SQL_M 165건 실덤프 — SQL_ID/MDU_DIVS_CD/SQL_NM/
  TOKENS/SQL_DTL_CTN). 화면이 쓰는 콤보ID 전건을 여기서 찾아 TOKENS(@변수)·핵심 WHERE 필터를 요약.
  콤보ID 가 여기 없으면 "「CMBO 미등록」" 표기(지어내기 금지).
- 교차 대사: `C:\Projects\NSCM\Doc\_rules_v2\_mapping\search_conditions_scp_dm.md` — DM 화면 섹션
  (대략 L1167~1615)에서 담당 화면 표를 찾아 As-Is 행수·To-Be 행수를 세고 내 추출 카운트와 대조.
  (카탈로그는 2026-01-22 스냅샷 — 불일치 시 **소스 실측 우선**, 사유를 crosscheck.reason 에 기재.)
- 참고(있으면): 화면 폴더 `__asis-mapping__.md`, `Doc\화면분석서\{화면}_조회조건_*.md/xlsx`.

## 범위
- 조회조건 영역의 **모든 컨트롤 전수**: 콤보(단일/다중)·텍스트·팝업버튼·달력·체크박스·라디오.
  AS-IS 는 폼 상단 필터 패널(pnl/grpSearch 계열)의 컨트롤 + Search 버튼 클릭 검증(필수) 포함.
- 제외(단, excluded 배열에 명시): 그리드 셀 콤보, 모달 내부 콤보, 기능 버튼(Save/Excel 등).
  조회조건 필드에 딸린 팝업 버튼(Project/Model/Version 검색 팝업)은 **포함** (control='팝업').

## JSON 스키마 (extract/{MENU_ID}.json)
```json
{
  "ui": "DMF0074",
  "ui_name_asis": "Metal Link Price",
  "asis_file": "asis_stripped/DMF0074.cs",
  "tobe_form": "nscm-fe/.../MetalLinkPriceForm.tsx",
  "conditions": [
    {
      "cond": "Div.",                    // 표준명 (아래 '가로축 표준명')
      "asis": {
        "label": "Division",             // Designer 라벨 원문
        "control": "콤보다중(CheckedListBox)",
        "combo": "GetDMInnerTable('MyDivision')",   // 원천 호출 그대로
        "params": "GROUP_ID(NowGroupID), USER_ID",  // 전달 변수 나열
        "filter": "BigFilter Tables[0] — 사용자 권한 division (TB_FX_UserGroupAuthExtention)",
        "cascade": "변경 시 Team/EndCustomer/ScmSite/PlantSite/... reset (SIC L249)",
        "div40": "공통", "div81": "공통", "div82": "공통",  // 상이 시 각각 서술
        "required": "Y|N|조건부(설명)",
        "default": "로그인 사용자 division",
        "evidence": ["DMF0074.cs:L167", "DMF0074.cs:L100-159"]
      },
      "tobe": {
        "label": "Div. (LBL00001)",
        "control": "콤보단일(CustomDropdown)",
        "combo": "MyDivision (CMBO)",
        "params": "@sesUserId(세션자동)",
        "filter": "SCM_ADM_USER_GR_UNIT_AUTH_MPG_M UNIT_TP_CD='D' 사용자 권한",
        "cascade": "변경 시 team/endCustomer/salesSite/plantSite/project/version clear",
        "div40": "공통", "div81": "공통", "div82": "공통",
        "required": "Y", "default": "session.div ?? '40'",
        "evidence": ["MetalLinkPriceForm.tsx:L65-87"]
      }
    }
  ],
  "cascade_chains": [
    "ASIS: Division→Team→EndCustomer→SalesSite (SIC 체인, L238/L198)",
    "TOBE: Division→(team,endCustomer,salesSite,plantSite,project,version) 일괄 clear"
  ],
  "excluded": ["그리드 셀 콤보 N종 (…Grid.tsx)", "모달 X 내부 콤보"],
  "crosscheck": {
    "catalog_screen": "Metal Link Price",
    "catalog_asis_rows": 9, "catalog_tobe_rows": 9,
    "my_asis_count": 9, "my_tobe_count": 9,
    "reason": "일치 / 또는 차이 사유 (카탈로그 이후 소스 변경 등)"
  },
  "notes": ["특기사항"]
}
```
- 한쪽에만 존재하는 조건: 없는 쪽을 null 로 두고 notes 에 사유(예: "TO-BE 미구현", "AS-IS 없음·신규").
- 값 문자열은 매트릭스 셀에 그대로 들어갈 **간결한 한국어 요약** (파일 dump 금지).
- **공란 금지**: 모르는 값은 "미확인(사유)" 로 명기.

## 가로축 표준명 (hook #112 rename)
Div. / Team / End Customer / Sales Site / Plant Site / PJT / Model/Nickname / Period /
Ver. / Biz. Type / Bucket / Owner / Item Type / Sender Code / Sold Customer / Active(YesOrNo) /
Search Over Range / DOM/EXP / MDF Type / Year / FCST Type — 목록에 없는 조건은 화면 라벨 기반으로
간결 명명하고 notes 에 "표준명 외" 표기.

## 주의 (실측 확정 함정)
- FE grep 시 `BACKUP_20260818/` 제외. 광역 ripgrep 20초 타임아웃 조용히 잘림 — 파일 지정 Read/Grep 사용.
- 동적 comboId(3항 연산자)·행소스 스왑은 조건식 그대로 기재 (예: "40&&team0&&ec0 ? ScmSitebyEndCustomer40 : UserSiteByEndCustomer").
- AS-IS isAddALL=true 의 'ALL' 행은 SP 밖 삽입 — filter 나 notes 에 "+ALL행(BLL)" 표기.
- TO-BE 미전달 @토큰은 '' 치환(0행 함정) — 화면이 실제 전달하는 파라미터 기준으로 params 작성.
