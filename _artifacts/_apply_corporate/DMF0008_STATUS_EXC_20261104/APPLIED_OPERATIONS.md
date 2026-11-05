# DMF0008 Status Update 실패 → 「완료」 표시 보완 (GAP-138) — 2026-11-04

작업 모드: **DB MODE (DB_ONLY)**. `tools/Harness/harness.json`의 repairScope 값이 DB_ONLY라서 DB 객체만 고쳤고, FE는 아래 §3 가이드로만 남겼습니다.

## 1. 사내 적용 (ZIOUI1 · SCM_MGR)

| 순서 | 작업 | 파일 | 결과 |
|---|---|---|---|
| 1 | 착수 시 원문 조회·백업 (LAST_DDL 2026-11-04 15:39:15 · VALID · 23:35:05 조회) | `00_BACKUP_PKG_DMF0008_BODY.sql` | 원복본 |
| 2 | `P_DMF0008_STATUS_UPDATE` 끝에 EXCEPTION 블록 추가 (기존 줄 변경 0 · 16줄 추가 · 표식 `[E20261104-STATUSEXC]`) | `01_PATCH_PKG_DMF0008_BODY.sql` | — |
| 3 | 적용 직전 재조회 비교(FRESH-GATE) 일치 → CREATE OR REPLACE PACKAGE BODY | `apply.py --apply` | 23:35:06 |
| 4 | 확인: STATUS VALID · ALL_ERRORS 0 · LAST_DDL 2026-11-04 23:35:06 · 표식 1줄 | — | PASS |
| 5 | 예외 경로의 결과 형태 확인. 같은 구문을 강제 오류로 실행했고, 실제 Status Update는 돌리지 않았으며 로그도 남기지 않았음 | — | `('-1', 'ORA-20999: …', None)` |

**원복 방법:** `00_BACKUP_PKG_DMF0008_BODY.sql`을 실행합니다(전체 F5).

## 2. 동작 변화

- **이전:** 래퍼 안에서 오류가 나면 BE `SqlException`이 HTTP 500으로 응답합니다(`GlobalExceptionHandler.java:120-134`). FE 공통 응답 처리(`axios-interceptors.ts:57-59`)는 500을 오류로 던지지 않으므로, `ErpEdiMaster.tsx:255`가 「Status Update 완료. 재조회합니다.」를 띄웁니다. 검증 V-2ffa0a67에서 FAIL로 확인했습니다.
  - 래퍼 안 오류의 예: 하위 프로시저 무효(ORA-06508), 패키지 상태 무효(ORA-04068), 로그 조회 오류.
- **이후:** 래퍼가 오류를 잡아 오류 로그를 남기고(`PR_SCM_SYS_LOG_BATCH`, 프로그램명 `P_DMF0008_STATUS_UPDATE`), `CODE='-1'`과 오류 문구를 돌려줍니다. FE 인터셉터는 이를 Error로 던지고, 화면에는 오류 알림이 뜹니다. 이 경로는 검증 V-e65a425f에서 PASS로 확인됐습니다.
- **정상 경로:** 바뀐 것이 없습니다. 상태 갱신 프로시저 자체는 이전부터 오류를 삼켜 ERROR 로그를 남기고, 래퍼는 그 로그를 보고 CODE -1을 돌려줍니다.

## 3. FE 가이드 — 남은 경로 (DB로 막을 수 없는 HTTP 500)

래퍼 밖에서 생기는 HTTP 500은 이번 DB 보완으로 막을 수 없습니다. 예를 들어 BE DB 연결 실패, 커넥션 풀 고갈, 요청 매핑 오류가 그렇습니다. 이 경우 여전히 「완료」가 표시됩니다.

- **파일:라인:** `nscm-fe/features/master/src/pages/erp-edi-master/ErpEdiMaster.tsx:254-255`
- **변경 전**
  ```ts
  await apiClient.post(`/${MENU_ID}/main/STATUS_UPDATE/call-proc`, {});
  void setToast({ type: 'success', message: 'Status Update 완료. 재조회합니다.' });
  ```
- **변경 후 (화면 국소 수정 — 공용 인터셉터는 바꾸지 않음)**
  ```ts
  const res = await apiClient.post(`/${MENU_ID}/main/STATUS_UPDATE/call-proc`, {});
  // 500 응답은 공용 인터셉터가 오류로 던지지 않고 응답을 돌려준다(axios-interceptors.ts:57-59) — 여기서 실패로 처리
  if (res.status >= 400 || Number(res.data?.code)) {
    throw new Error(res.data?.message || 'Status Update 실패');
  }
  void setToast({ type: 'success', message: 'Status Update 완료. 재조회합니다.' });
  ```
- **이유:** 이 경로에서는 실패가 성공 토스트로 보입니다. AS-IS(.cs L2565~2626)는 오류가 나면 오류 문구를 표시합니다.
- **공용 인터셉터를 바꾸지 않는 이유:** 공용 인터셉터가 500을 응답으로 돌려주는 것은 다른 화면들이 의존하는 동작일 수 있습니다. 공통 컴포넌트 수정 금지 규칙에 따라 화면 단위로만 고칩니다.
- **검증법:** 검증 시나리오 `DMF0008 Status Update 서버 500 → 오류 표시(완료 아님)`를 실행합니다(가짜 500 응답, 서버 미전송). 현재는 FAIL이고, 수정 후 PASS여야 합니다.
  - 실행 명령: `SCN_ONLY='Status Update' VERIFY_ID=DMF0008 … node … test _verify --grep "문서 시나리오"`
  - 함께 확인할 것: CODE -1 시나리오와 SUCCESS 시나리오는 계속 PASS여야 합니다.

## 4. 클라우드 이관 패키지

- 위치: `_artifacts/_deploy_packages/DMF0008_CLOUD_DB_MOD_20261104_2336/` (cloud_pkg 1.1.0 · 사내 리허설 OK · 경고 0)
- 이번 보완이 담긴 파일: `A_DB/20_PKG_PKG_DMF0008.sql` (표식 `[E20261104-STATUSEXC]` 포함)
- 이관 기준선이 없어 화면 소유 DB 객체 전체가 포함됐습니다. 모든 SQL은 멱등(여러 번 실행해도 같은 결과)입니다.
- 클라우드 적용 상태: **미적용** (적용은 사용자가 진행)
