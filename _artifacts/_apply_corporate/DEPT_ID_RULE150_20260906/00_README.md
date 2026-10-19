# DEPT_ID 추출 기준 변경 (hook #150) — 적용 패키지 (AJS 175.211.29.206:2521, SCM_MGR)

- 원장: `_artifacts/_diagnostics/dept_id_rule_change_20260905/00_TARGET_LIST.md` (대상 10 객체 / 35 지점)
- 룰: `Doc/_rules_v2/hooks/dept-id-derivation-standard.md`
- 편집 방식: 기존 라인 `-- [hook#150 2026-09-06 AJS] AS-IS:` 접두 주석 보존 + 신규 라인 `hook#150` 마커 (라인 기반, `apply_edits_linebased.py`)
- 사용자 확정(2026-09-06): ① `NEW_DEPT_ID_TBL` MAX 유지 ② DMF0082 5066 대상 적용 ③ PR_DM_BPS_* 잔존 SU 조인 = 대상 아님(미변경)

## 적용 순서
```
python _artifacts/_diagnostics/ora.py exec _artifacts/_apply_corporate/DEPT_ID_RULE150_20260906/01_APPLY/01_PKG_DMF0022.sql
... 02 ~ 10 순서대로 (의존 없음 — 순서 무관)
python _artifacts/_diagnostics/ora.py errors            # USER_ERRORS 0 확인
python _artifacts/_diagnostics/ora.py invalid           # INVALID 0 확인
```
원복: `00_BACKUP_ASIS/NN_<obj>.ASIS.sql` (적용 직전 USER_SOURCE 원문 + CREATE OR REPLACE 헤더) 를 동일 방법으로 실행.

## 건수 대사
```
python 90_VERIFY/harness_rowcount.py after      # 동일 파라미터로 15 GET SP × 3 division 재호출 → baseline_after.json
python 90_VERIFY/compare_before_after.py        # before/after 커서별 행수·DEPT 분포·해시 대사
```
`baseline_before.json` = 적용 전 실측 (2026-09-06 01:34). standalone POPUP|40 은 GT_DMF0020_PJT 적재 >10분으로 제외,
DMF0040|40 은 호출 300초 초과(기존 성능), DMF0082 GET_MAIN_DATA(_CURRENT) 는 적용 전부터 `ORA-00904 SORT_KEY` 로 실패(기존 결함) — 해당 지점은 블록 SQL 대조로 갈음.

## 편집 지점 (객체별)
| 객체 | 지점 | 변경 |
|---|---|---|
| DMF0020_GET_SCM_MST_FUTURE_PRICE | 706·708-709 / 1034·1043-1048 | PJT `SU.DEPT_ID`→`SI.DEPT_ID`(SU 조인 제거) / TEAM = DEPT_INFO ON SITE_ITEM.DEPT_ID (+T1.DEPT_ID) |
| …_SAVE_PRICE_POPUP | 297·309 / 369-375→390 뒤 / 751-752→779 뒤 (+766) | GT_PJT div40 `SI.DEPT_ID` / TEAM·DEPRTMENT 를 SITE_ITEM 뒤로 이동, `SITE_ITEM.DEPT_ID` / SITE_PROJECT 블록 동일 |
| PKG_DMF0020 | 2781·2857 / 3804-3807×3 / 5294-5297·5623·5632-5637 / 8010·8022·8082-8088→8103 뒤·8472-8473→8500 뒤(+8487) | TEMPLATE TEAM=DEPT_INFO ON SI.DEPT_ID / OWNER_DATA `A.DEPT_ID=C.DEPT_ID` / FUTURE_PRICE·POPUP 미러 |
| PKG_DMF0022 | 1802-1803 | 스칼라 → `A.DEPT_ID` |
| PKG_DMF0035 | 2247-2249 | 스칼라 → `A.DEPT_ID` |
| PKG_DMF0040 | 1313·1335-1341·1347 | E 에 DEPT_ID 추가 / TEAM=DEPT_INFO ON E.DEPT_ID / K ON E.DEPT_ID |
| PKG_DMF0044 | 3087·3095·3098·3102 / 8588-8589 / 8718 / 8825 / 8847 | 스칼라 4 → SITE_ITEM PK 스칼라 / C(USER_INFO) 제거·D ON B.DEPT_ID / D ON B.DEPT_ID ×3 |
| PKG_DMF0051 | 1177·1182-1185 / 1205·1215·1227 뒤 | OW.DEPT_ID→SMSI.DEPT_ID / GT_DM51_SCM_CITY DEPT = SITE_ITEM(A PK 4키) |
| PKG_DMF0074 | 131-138·235-242·670-677·749-756 | TEAM=DEPT_INFO ON SITE_ITEM/SI.DEPT_ID ×4 |
| PKG_DMF0082 | 903-912·919-921 / 5071-5074·5081-5083 / 7431-7437·7444 / 10395·10399 / 10484-10492→10508 뒤 / 11044-11045→11071 뒤(+11060) | TEAM=DEPT_INFO ON F.DEPT_ID·K ON F.DEPT_ID / UPLOAD DI ON SI.DEPT_ID / 미러 / GT_PJT SI.DEPT_ID / POPUP 이동 ×2 |

## 사전 실측 (건수 동일성 근거 / 예상 변화)
- `SCM_MST_SITE_ITEM.DEPT_ID` 117,948행 == OWNER 첫 토큰→SSO_USER_INFO.DEPT_ID (DIFF 0·편측 0·DEPT_INFO 고아 0) → ③ 치환 지점 값·건수 불변
- DMF0044 8588 체인 old=new 전 division / 3084 스칼라 23,199 전건 동일 / 8718 은 `'MDF_DEPARTMENT'||div` 룩업 부재로 before·after 0행(기존 사각)
- **변화 예상**: DMF0044 82분기 8825 site부서∈DEPT_INFO 38,621 → item부서 35,557 / DMF0082 5066 END_CUSTOMER 후보 81 333→340·82 1,297→1,375 / DMF0020 OWNER_DATA V_TMPDEPT 81 108→109 (다중 OWNER 결함 해소, 상위집합)
