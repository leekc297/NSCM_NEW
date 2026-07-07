# DMF0014 (CustomerFcstUpload / 고객 FCST 업로드) — 클라우드 이관 (증분)

> **기존 화면 DMF0014 의 수정/보완 변경분** + 의존 공유 파일 취합.
- 작성: 2026-07-08
- 화면 ID: **DMF0014** | 도메인: `demand` | slug: `customer-fcst-upload`
- 범위: **FE** (BE Java 무변경). ⚠️ 업로드 Lock 은 DB SP/운영 이슈 — 별도(§4).

## 1. 패키지 구성
```
_dmf0014_artifacts/
├── fe/
│   ├── features/demand/src/pages/customer-fcst-upload/   (8 파일 — 화면 변경분)
│   ├── features/demand/src/components/fcst-upload-modal/  (2 파일 — 공유 업로드 모달)
│   ├── features/master/src/components/searchFields/       (2 파일 — ⚠️ 공유)
│   ├── packages/foundation/src/apis/axios.ts              (⚠️ 공유 인프라)
│   └── packages/shared/src/components/organisms/sub-title/SubTitle.tsx  (⚠️ 공유)
├── sql/   (Excel Upload Lock 진단·조치 — §4)
└── _README.md
```

## 2. 화면 전용 변경 (customer-fcst-upload)
- **Cascade**: Team→(EndCustomer/SalesSite) clear, EndCustomer→SalesSite clear. EndCustomer/SalesSite 옵션에 **Division + Team(DEPT_ID)** 필터.
- **Division 기준 enable**: `81*/82` 만 Project·Plant Site 활성, 그 외(40 등) 비활성 (AS-IS 1:1 + Plant Site 확장).
- **라벨**: PJT → `LBL00617 'Project'`, Customs Handbook → `LBL00091`.
- **Period 시작일 = 당일** (dayRange 월경계 시작 대신 오늘).
- **저장 확인 메시지**: `MSG00004`(수정내용 없음) → **`MSG00001`('저장 하시겠습니까?')**.

## 3. ⚠️ 공유 파일 (덮어쓰기 전 diff 검토)
| 파일 | 변경 | 영향 |
|---|---|---|
| `components/fcst-upload-modal/FcstUploadModal.tsx` + `.module.scss` | 파일 옆 업로드 버튼 삭제 / File Box width 2배(480px) / 컨테이너 min-height(파일 선택 시 잘림·넘침 방지) | Excel 업로드 모달 사용 화면 공통 |
| `master/components/searchFields/SearchFields.tsx` + `.module.scss` | `ProjectField`/`PopupSearchInput` `disabled` prop (additive) | master 조회조건 공통 |
| `foundation/src/apis/axios.ts` | **FormData POST 시 Content-Type 제거** → multipart 자동설정(파일 업로드 견고화) | **전 화면 POST 공통**(JSON 무영향, FormData만 분기) |
| `shared/.../sub-title/SubTitle.tsx` | Excel Upload 버튼에 `LBL00346 'Excel Upload'` 텍스트 | 전 화면 upload 버튼 공통 |

## 4. ⚠️ Excel Upload Lock (DB/운영 — FE 무관) — 근본원인 확정 + 조치
업로드 무반응의 근본 원인은 **공유 검증 SP `PR_DM_PLN_CUST_FCST_TO_MKT_FCST` 내부의 `EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DPCF_*'`(DDL) 8곳**. 세션전용 GTT 를 TRUNCATE(DDL) 로 비우는데, 동시 업로드 세션들이 **library cache / cursor: mutex X / row cache mutex** 경합으로 hang → BE 응답 없음(파일 전송·파싱은 정상).
- **라이브 확인**: SID 261·393 이 `TRUNCATE TABLE GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI` 에서 수시간 정체. (구 진단 'enq: TX row lock' 은 오판 — mutex 경합이 실제.)
- ⭐ **2중 결함**: ①을 풀자 **결함 ② 커서 무한 루프**가 드러남 — `V_FETCH_STATUS := 0` 선언 후 재할당 전무 → `WHILE V_FETCH_STATUS = 0` 영원히 참 (MSSQL `@@FETCH_STATUS` 자동갱신 변환 누락). 10건 업로드에 내부 INSERT **12,786,821회** 실행(V$SQL 실측). 조치 = 두 FETCH 직후 `V_FETCH_STATUS := CASE WHEN CUR_CAR_RESULT%NOTFOUND THEN 1 ELSE 0 END;`
- `sql/05_SP_PR_DM_PLN_fetchstatus_infinite_loop_FIX.sql` — ⭐⭐ **최종 조치 SP (04 포함: TRUNCATE→DELETE 8건 + FETCH_STATUS 2건). 클라우드는 05 하나만 배포.** 검증 = STATUS VALID + 잔존 TRUNCATE 0 + `%NOTFOUND` 2건. 2026-07-08 사내 배포·검증 완료.
- `sql/04_SP_PR_DM_PLN_truncate_to_delete_DEPLOY.sql` — 조치 ① 단독본 (이력용). `04_..._ORIG_backup.sql` — 원본 백업(GET_DDL, SCM_MGR).
- `sql/03_kill_stuck_upload_sessions.sql` — 멈춘 세션 kill(DBA). **⚠️ 배포 전제: 멈춘/폭주 세션이 SP library cache pin 을 물면 `CREATE OR REPLACE` 도 hang → kill 선행 + SERIAL# kill 직전 재조회(ORA-00026). 구버전 SP 살아있는 동안 업로드 재시도 금지**(시도마다 새 폭주 세션이 배포 재차단).
- `sql/01·02_*editflag*` — 편집권한(EDIT_FLAG) 진단·ADMIN 등록 (별건, 조치 완료).

> **적용 순서**: ③ DBA kill(전수) → ⑤ `05_SP` 재배포(VALID+잔존0+%NOTFOUND 2) → 업로드 재시도. 룰: hook #107 `sp-hang-runaway-loop-diagnosis` / 부록 C-2·C-10.

## 5. 적용
```bash
# 화면 전용
cp -r fe/features/demand/src/pages/customer-fcst-upload nscm-fe/features/demand/src/pages/
# ⚠️ 공유 — 파일별 diff 검토 후 반영
cp fe/features/demand/src/components/fcst-upload-modal/*   nscm-fe/features/demand/src/components/fcst-upload-modal/
cp fe/features/master/src/components/searchFields/*        nscm-fe/features/master/src/components/searchFields/
cp fe/packages/foundation/src/apis/axios.ts               nscm-fe/packages/foundation/src/apis/axios.ts
cp fe/packages/shared/src/components/organisms/sub-title/SubTitle.tsx nscm-fe/packages/shared/src/components/organisms/sub-title/SubTitle.tsx
```
