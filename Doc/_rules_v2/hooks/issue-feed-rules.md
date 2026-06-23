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

<!-- DAILY-APPEND-MARKER: 신규 날짜 블록은 이 주석 위에 추가 -->
