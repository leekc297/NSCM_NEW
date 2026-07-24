# DMF0003 조회조건 AS-IS 데이터 추출 정합 (전건 보완 P1~P6) — 2026-07-23

## 배경 (전수 점검 결과)
DMF0003 조회조건 14항목의 AS-IS(BigFilter.xml + UP_FX_GetCommonDataList_DM + PR_GET_DAY_RANGE) ↔ TO-BE(CMBO/카탈로그) 대조에서 6건 불일치 실측 확인 → 전건 보완 (사용자 지시 2026-07-23).

## 보완 내용 (사내 적용 완료)

| # | 항목 | 불일치 | 보완 |
|---|---|---|---|
| P1 | Biz Type | 81/82 후보 전량 누락 (lookup 3행만) | CMBO **BizTypebyDivision** 신규 = DM_BIZ_TYPE(40) UNION SCM_MST_PROJECT BIZ_TYPE(비40, 실측 72행) + FE division 필터 |
| P2 | End Customer | 40 lookup-only 929행 누락 + NOT NULL 강제 | CMBO **EndCustomerByDivision** 신규 = AS-IS 3-branch UNION 1:1 (owner-dept PROJECT_CODE + lookup-only + 비40 END_CUSTOMER) |
| P4 | Team | DEPT 소스 상이(SITE_ITEM.DEPT_ID vs owner 1토큰 부서 — 차집합 35/64 실측) | CMBO **UserTeamByDivision** 신규 = AS-IS owner-token 로직 1:1 (@langCd 다국어 포함) |
| P3 | Sales Site | EndCustomer/Team cascade 미구현 + AS(W/S) 분기 미반영 + OPERATION_GROUP 'W' 제외 누락 | CMBO **SiteByEndCustomer_DMF0003** 신규 = UP_FX SiteByEndCustomer/40 1:1 (@divisionId/@endCustomer/@deptId/@asYn 서버 바인드, AS=AS_SITE_PLANT lookup UNION·SITE_DESCRIPTION 표기·선두 정렬) |
| P5 | Sender Code | 표시명=코드 (AS-IS는 ATTRIBUTE1 제조사명) + 정렬 | CMBO **SenderCode** 정정 = NAME=NVL(ATTRIBUTE1,SEGMENT2) + SEGMENT1,DISPLAY_SEQ 정렬. FE division prefix 매칭(81 계열 전부 '81' 행) |
| P6 | Period 기본값 | 당일~+180일 (AS-IS는 월초~+6개월 말일) | store 기본값 = PR_GET_DAY_RANGE(p_month=6) 1:1 클라 달력 계산 (해당월 1일 ~ (+6개월 1일)-1일, 로컬타임 포맷) |

### ⚠ 공유 콤보 보호
- 공유 `SiteByEndCustomer`(waterfall·DMF0020 셀콤보 사용)는 **원본 유지**(잠시 덮었다가 아티팩트 원문으로 즉시 복원, 실행 검증 2,429행 OK). DMF0003은 전용 ID `SiteByEndCustomer_DMF0003` 사용.
- 공유 `TeambyDivision`/`EndCustomer`/`BizType`도 무변경 — 카탈로그 필드(TeamField/EndCustomerField/BizTypeField)에 **opt-in `comboId`/`division` prop**(기본값=기존 동작)만 추가.

## 파일 / 적용 순서 (클라우드)
```
1) sql/01_CMBO_REGISTER.sql   (CMBO 5종 멱등 MERGE — 신규4 + SenderCode 정정)
2) FE 이관 — 본 폴더 fe/ 동봉 (repo 상대경로 그대로 덮어쓰기):
   - fe/features/master/src/components/searchFields/SearchFields.tsx   (TeamField/EndCustomerField comboId, BizTypeField comboId+division — opt-in)
   - fe/features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx  (콤보 전환 + SalesSite 서버바인드 cascade/asYn + Sender prefix 필터)
   - fe/features/demand/src/pages/mkt-fcst/useMktFcstStore.ts          (Period 기본값 월초~+6개월 말일)
```
> ⚠ 동봉 FE 스냅샷은 titleset 면역 패키지(DMF0003_TITLESET_IMMUNIZE_20260723)의 FE 변경(columnType='C'/selectableOnly 등)도 포함한 최신본 — 두 패키지 함께 적용 권장.

## 검증 (사내 OCGSCMD_P01, 2026-07-23)
- CMBO 5종 바인드 치환 실행 OK: BizTypebyDivision 72 / UserTeamByDivision 190 / EndCustomerByDivision 2,378 / SiteByEndCustomer_DMF0003 2,398 / SenderCode 15행.
- 공유 SiteByEndCustomer 복원 후 실행 OK(2,429행).
- FE type-check(master/demand) 통과.
- AS-IS 원소스 정본: `04.WSL/FoxQuery/DM/Common/BigFilter.xml` + AS-IS MSSQL `UP_FX_GetCommonDataList_DM`/`PR_GET_DAY_RANGE`(OBJECT_DEFINITION 실측) — scratchpad 백업 동봉.

## 잔여
- 화면 실동작 확인: ① Div 81/82에서 Biz Type 후보 표시 ② Team/EndCustomer 후보(owner-dept 기준) ③ EndCustomer 선택→Sales Site 재조회 cascade ④ Sender Code 제조사명 표시 ⑤ Period 기본값(월초~6개월 말일).
- 일치 확인 완료 8항목(Division/Bucket/Project/Model/PlantSite/ItemType/Owner/체크박스)은 무변경.
