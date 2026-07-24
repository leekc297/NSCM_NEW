# DMF0003 titleset 오염 재발 방지 (DEPT_ID/MEASURE 조회 오류 근본 조치) — 2026-07-23

## 사고 구조 (근본 원인 — 실측 확정)
DMF0003 메인 조회(P_DMF0003_GET_MKT_FCST_DATA)는 동적 PIVOT 컬럼목록(V_COLUMN)을
`SCM_MST_TITLESET_USER`(TYPE='C', 사용자 Column Setting 캐시)에서 조립하는데, **캐시 오염 시 오류**:

| 오염 유형 | 결과 |
|---|---|
| 고정컬럼(MEASURE 등 DEFAULT_FLAG ' '/'-')이 캐시에 유입 | branch②와 2회 → **ORA-00918** |
| MF_BASE 미산출 컬럼(DEPT_ID/DEPT_NAME/DEPT_NAME_KO 등 5종) 유입 | **ORA-00904** |

**재발 메커니즘**: Column Setting 모달의 후보 SP(DMF0002_GET_TITLESET_POPUP)가
SHEET_COLUMNS VALID_YN='Y' **전체 67컬럼**을 후보로 반환(USER_SELECTABLE 미필터)
+ DEPT_ID 등이 `USER_SELECTABLE_FLAG='Y'`(이관 flag 결함) → 사용자가 선택·저장하면 즉시 캐시 오염.
일회성 DELETE 정정은 저장할 때마다 재오염 → 두더지잡기.

추가 결함(모달): ① FE가 `columnType='Mkt Fcst'`(시트명) 전달 → usr CTE 0행 → **저장해도 재오픈 시 DEFAULT 복원**(저장 미유지)
② SHEET_COLUMNS에 PK/UNIQUE 없음 → 중복행 유입 시 모달 중복 표시·이동/체크 오동작(itemKey 충돌).

## 3층 방어 (이번 조치)

### L1 — SP 면역화 (최종 방어선, 오류 구조적 불가)
`sp/PKG_DMF0003_BODY_immunized.sql` — branch① 커서에 가드 2종 (본문 그 외 무수정):
- `NVL(C.DEFAULT_FLAG,'N') NOT IN ('-',' ')` + `C.VALID_YN='Y'` — 고정컬럼은 branch② 전담 (00918 차단)
- `U.COLUMN_NAME IN (MF_BASE 산출 57 whitelist)` — 미산출 컬럼 차단 (00904 차단).
  whitelist는 본 SP PIVOT #1/#2 MF_BASE SELECT 리스트에서 실측 추출 — **MF_BASE 컬럼 추가 시 whitelist 동기 의무**(주석 명기).
- ⚠ flag 기반 필터가 아님: 'N'-flag 40개 중 35개는 MF_BASE 산출(사용자 추가선택 정당) — flag 필터는 이전에 조회 파손(539→9행) 전례.

### L2 — FE/모달 정합 (오동작 보완)
- `MktFcst.tsx`: `columnType='C'` 정정 (**저장 미유지 fix** — 재오픈 시 서버 저장값 복원) + `selectableOnly` 적용.
- 공용 `ColumnSettingModal.tsx`: ① **COLUMN_NAME dedup**(중복 표시/이동 오동작 방어, 무조건) ② `selectableOnly`(opt-in) — USER_SELECTABLE!='Y' + 고정컬럼 후보 제외. 기본 undefined = DMF0020/0043 무영향.
- `MeasureSelectModal.tsx`: colNm dedup (동일 계열 방어). measure는 메인 SP가 SHEET_MEASURE VALID_YN 조인으로 이미 면역.

### L3 — 메타 정정 (오염 후보 원천 제거)
- DEPT_ID/DEPT_NAME/DEPT_NAME_KO `USER_SELECTABLE_FLAG 'Y'→'N'` (산출 불가 컬럼이 선택 가능 = 명백 결함).
- 고정컬럼 8종의 selectable='Y'는 메타 관례 유지(임의 변경 금지) — L2 모달 필터가 제외 담당.

## 파일 / 적용 순서 (클라우드)
```
1) sql/01_META_SHEET_COLUMNS_FULL_SYNC.sql   (사내 정본 67행 전면 DELETE+INSERT — 중복행/flag 드리프트 일괄 해소)
2) sql/02_TITLESET_C_CLEANUP_ALL_USERS.sql   (전 사용자 'C' 캐시 오염 전수 정리 — SP 가드와 동일 규칙)
3) sp/PKG_DMF0003_BODY_immunized.sql         (body 만 재배포 — spec 무변경.
                                              ⚠ ORA-12841 fix 패키지(DMF0003_ORA12841_FIX_20260723) 적용 시 그쪽 BODY 가 최신 — 그 파일로 대체)
4) FE 이관 — 본 폴더 fe/ 동봉 (repo 상대경로 그대로 덮어쓰기):
   - fe/features/demand/src/pages/mkt-fcst/MktFcst.tsx                          (columnType='C' + selectableOnly)
   - fe/features/master/src/components/columnSettingModal/ColumnSettingModal.tsx (dedup + selectableOnly opt-in)
   - fe/features/demand/src/pages/mkt-fcst/components/modals/MeasureSelectModal.tsx (colNm dedup)
```
> ⚠ 동봉 FE 스냅샷은 조회조건 정합 패키지(DMF0003_SEARCHCOND_ASIS_ALIGN_20260723)의 변경도 포함한 최신본 — 두 패키지 함께 적용 권장.
> SCM_MST_SHEET_COLUMNS 유니크 인덱스는 **보류** — 사내 전사에 (PROGRAM,SHEET,COLUMN) 중복 1키 존재(타 프로그램)로 전사 인덱스 불가.

## 검증 (사내 OCGSCMD_P01, 2026-07-23 적용 완료)
- PKG_DMF0003 BODY VALID, errors 0.
- **회귀**: division 40 실측 파라미터 — 패치 전후 **539행/350컬럼/SHA-256 해시 완전 동일** (PASS).
- **면역 테스트**: 테스트 사용자 titleset에 DEPT_ID/MEASURE/DEPT_NAME 3행 강제 주입 → 조회 **오류 0 + 기준 해시 동일**(IMMUNE PASS) → 테스트 데이터 정리 완료.
- 메타 정정 3행 적용(사내), FE type-check(features/master·demand) 통과.

## 잔여
- 클라우드 1)~4) 적용 후: Column Setting에서 컬럼 선택·이동·저장 → 재오픈 복원 확인 + 메인 SEARCH 정상 확인.
- DMF0002_GET_TITLESET_POPUP의 P_DIVISION_ID 미사용(선언만)은 공통 SP라 보류 — 필요 시 별도 결정.
