# issue-feed-rules — 일일 이슈목록 → 룰 후보 누적 피드

> **성격**: append-only 누적 피드. `C:\TRANFILE\RECEIVE\이슈목록관리.xlsx` 일일 스냅샷에서 도출한 룰 후보를 날짜별로 누적한다.
> **운영**: 매일 자동 작업이 본 파일 하단에 신규 날짜 블록을 **추가만** 한다(기존 블록 수정/삭제 금지).
> **편입 절차**: 사람이 검토 후, 정식 룰로 승격할 후보는 해당 hook 또는 `_tobe` 룰 문서로 이관하고 본 피드의 상태를 `편입완료`로 표기한다.
> ⚠️ anti-simplification 정책상 정식 룰 문서 직접 자동수정은 금지. 본 피드는 **후보 적재용 단일 안전지대**이다.
> **원본 정리본**: `_analysis/이슈목록_{날짜}.md`

---

## 2026-06-23 (스냅샷 11건, 룰 후보 5건)

> ✅ **편입완료 (2026-06-23)**: R-1~R-5 전건 → 정식 hook `screen-combo-validation-message-mandatory.md` 승격 (사용자 명시 요청). 매핑: L=R-1·R-5 / V=R-2 / M=R-4 / D=R-3.

| # | 출처 No. | 화면ID | 룰 후보 | 적용 트리거 | 상태 |
|---:|---:|---|---|---|---|
| R-1 | 5 | DMF0043_01 | 콤보박스 옵션 **하드코딩 금지**, `useTabLookupQueries({ filters: [...] })` 룩업 후 `CODE/NAME` 가공. 빈 결과 시 기본 옵션 fallback. | 모달/콤보박스 작성 | ✅ 편입완료 (§1 L) |
| R-2 | 6 | DMF0072 | 날짜 셀 표시 형식(`MM/DD/YYYY`)과 **유효성 검증 형식 일치**. `YYYYMMDD` 고정 검증 금지. | Wijmo 날짜 validation | ✅ 편입완료 (§2 V) |
| R-3 | 8 | DMF0020 | 다단 헤더 Depth 는 `getColumnDepth` 가 DB 라벨(`sClsLblNm/lClsLblNm/colLblNm`)로 결정 → 화면 하드코딩은 임시방편, 근본은 DB 메타 정비. | 다단 헤더 그리드 | ✅ 편입완료 (§4 D) |
| R-4 | 9 | DMF0043 | 메시지 코드 **중복 사용 금지**. 동일 코드가 화면마다 다른 문구면 의미별 신규 코드 분리(`MSG00004`→`MSG_NO_CHANGE`). | 공통 메시지/`useCustomQueryClient` | ✅ 편입완료 (§3 M) |
| R-5 | 11 | SYS0001 | 콤보박스 룩업(`MSG_TP_CD` 등) 적용 시 별도 룩업 조회 화면/소스 정비 필요. | Lookup Type 적용 | ✅ 편입완료 (§1 L) |

## 2026-06-23 (2차 / PM 갱신 — 스냅샷 15건, 신규 룰 후보 6건)

> 원본 Excel PM 수정분(18:08, `_analysis/이슈목록관리.xlsx`) 반영. 오전 11건(R-1~R-5) 이후 추가분: No.7·No.10 처리내역 신규 + 신규 No.12~14 + SYS0010(미부여).
> ✅ **편입완료 (2026-06-23 PM)**: R-6·R-7·R-9·R-10 + R-8 → 정식 hook `screen-grid-edit-merge-and-meta-mandatory.md` (#89) 승격 (사용자 "이슈목록 Rule 적용" 명시 요청). 매핑: G=R-10 / E=R-7·R-9 / A=R-6 / P=R-10 / M연장=R-8. R-11(SYS0010)은 처리내역 부재 → 후속조치(미승격).

| # | 출처 No. | 화면ID | 룰 후보 | 적용 트리거 | 상태 |
|---:|---:|---|---|---|---|
| R-6 | 7 | DMF0072 | 프로시저 조회 JOIN 키 `SCM_ADM_MNU_BTN_MPG_M.API_ID` ↔ `SCM_ADM_API_M.API_ID` 매칭 필수. 화면설계서 API_ID(`P_DMF0072_SAVE`)로 동기화. 불일치 시 프로시저 미발견 → 저장 에러. | SP 저장 안됨 / 프로시저 못 찾음 | ✅ 편입완료 (§3 A) |
| R-7 | 10 | DMF0072 | 일부 컬럼만 수정 가능 = `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD = 'IM'` / 전체 수정 = `'M'`. 화면 readonly 하드코딩 금지(admin 메타 제어). | 컬럼 편집 가능 범위 제어 | ✅ 편입완료 (§2 E) |
| R-8 | 12 | DMF0043 | 비규격 메시지 코드 → 표준 코드 교체(`MSG_SAVE_DONE`→`MSG00002`, `MSG_SAVE_FAIL`→`MSG00003`). 임의 문자열 코드 금지, `SCM_ADM_MSG_M` 표준 코드 사용. | 저장 완료/실패 메시지 | ✅ 편입완료 (#87 §3 M 연장 + §5) |
| R-9 | 13 | DMF0072 | 특정 `DATA_TYPE_CODE`(예 `'ERP'`) 행 편집 잠금 = `gridRef.beginningEdit` handler useEffect 등록/해제(closure 갇힘 방지). | 조건부 행 편집 잠금 | ✅ 편입완료 (§2 E + P7 cross-ref) |
| R-10 | 14 | DMF0020 | AI 재작업 5: ①mergeManager는 DataGrid props 직접 세팅(useEffect 주입 무시) ②sameRow 머지 기준 `CRUD_TYPE`+`INSERT_GROUP_ID` ③Div 변경 검색조건 초기화+그리드 비움(Div40 Project·PlantSite / Div82 PlantSite disabled) ④period default 당월1일~6개월말일 ⑤Div≠40 Currency·Measure LOC 주간 row만 수정. | 머지 그리드 / Division cascade / period default | ✅ 편입완료 (§1 G + §4 P) |
| R-11 | (미부여) | SYS0010 | Detail 그리드 저장 안됨(스크립트 에러 + '수정행 없음'). 처리내역 부재 → 근본 규명 후 룰화. | (후속조치) | ⏳ 미처리(후속) |

<!-- DAILY-APPEND-MARKER: 신규 날짜 블록은 이 주석 위에 추가 -->
