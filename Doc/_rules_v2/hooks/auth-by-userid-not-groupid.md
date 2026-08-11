# Hook #128 — auth-by-userid-not-groupid (권한 판정은 UI 가 넘긴 GROUP_ID 가 아니라 **USER_ID 로 서버가 보유 권한 전체를 조회**해서 한다)

> **Trigger**: T01 (신규 화면) / T01M (화면 수정) / T06 (SP 변환) / T07 (사내 DB 적용) — **권한·편집가능 판정이 등장하는 모든 작업**
> **PR 차단 강도**: ⭐⭐⭐ (오판정 시 정당 사용자가 편집 불가 / 무권한 사용자가 편집 가능)
> **신설일**: 2026-08-10 (사용자 명시)
> **선행 계보**: `feedback_session_groupid_ghost_field`(AUTHUNION 2026-08-04) · #117 §5 · #125 §4.1

---

## §0. 사용자 원문 (2026-08-10)

> "UI 에서 GROUP_ID 를 넘기는 방식이 아니고, **사용자 기준으로 가지고 있는 전체 권한 중 편집 가능 권한이 있으면
> 편집 가능**해야 합니다. DMF0044 와 같이 ADMIN 권한이 있는 사용자가 편집 가능한 경우라면 현재의 사용자는
> 편집이 가능해야합니다. **DM ADMIN 권한도 가지고 있는 여러 권한 중의 하나이기 때문입니다.**"
>
> "권한 사용 시 UI에서 GROUP_ID 를 받아서 권한 CHECK 하는 부분을 **USER_ID 로 보유하고 있는 권한을 찾아서
> 권한에 대한 답을 주는 방식**으로 변경되어야 합니다. 이부분도 RULE 로 적용해서 **모든 화면에 적용**될 수 있도록"

---

## §1. 결론 (3줄)

- ⛔ **UI 가 "현재 그룹" 하나를 골라 보내고 서버가 그것만 비교하는 방식 금지.**
- ✅ **서버가 `USER_ID` 로 `SCM_ADM_USER_GR_MPG_M` 을 조회해 보유 그룹 전체를 얻고, 그 합집합으로 판정**한다.
- ✅ 판정식은 **"보유 그룹 중 하나라도 권한 목록에 있으면 허용"**(OR/합집합). AND·단일 비교 금지.

## §2. 왜 — AS-IS `NowGroupID` 의 오해

AS-IS(WinForms)는 `UserInfoContext.Current["NowGroupID"]` 로 **로그인 시 선택된 단일 그룹**을 들고 다녔다.
TO-BE 웹에는 그런 "현재 그룹 선택" UI 가 없다. 그대로 옮기면:

- FE 가 보낼 값이 없어 `session.groupId`(**존재하지 않는 유령 필드**)를 쓰거나 빈 문자열을 보낸다
- 또는 첫 번째 그룹 하나만 보내 **나머지 보유 권한이 통째로 무시**된다

⇒ `ADMIN`·`DM ADMIN` 을 모두 가진 사용자가 편집 불가가 되는 오판정이 발생한다.

## §3. 서버측 표준 판정식 (정본)

`PKG_DMF0044` L1155~1175 가 정본이다 — 파라미터로 온 값 **과** USER_ID 로 찾은 보유 그룹을 **둘 다** 본다:

```sql
SELECT 1 INTO v_dummy FROM DUAL
 WHERE EXISTS (
   SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
      AND VALID_YN    = 'Y'
      AND SEGMENT2    = 'ALL'          -- 화면 한정 추가 그룹 제외
      AND ( SEGMENT1 = P_USER_GROUP    -- ① 파라미터 직접 일치(하위호환)
            OR SEGMENT1 IN (           -- ② ⭐ USER_ID 로 찾은 보유 그룹 합집합
                 SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                  WHERE G.USER_ID IN (P_USER_GROUP, P_USER_ID, P_CREATED_BY)
                    AND G.USE_YN = 'Y') ) );
V_GROUP_ID := 'ADMIN';
EXCEPTION WHEN NO_DATA_FOUND THEN V_GROUP_ID := '';
```

- `P_USER_GROUP` 에 **그룹명이 오든 USER_ID 가 오든** 둘 다 성립하게 `IN (P_USER_GROUP, P_USER_ID, P_CREATED_BY)` 로 받는다.
- **권한 그룹 목록은 하드코딩하지 않는다** — `GET_ADMIN_GROUP` 룩업이 단일 소스.
  ⛔ `WHERE NowGroupID = 'ADMIN'` 같은 리터럴 비교로 축소 금지([[feedback_combo_sp_prologue_and_call_sites]]).

### §3.1 FE 측 계약

- FE 는 **세션 `userId` 를 그대로** `P_USER_GROUP` / `P_USER_ID` 에 싣는다(그룹을 고르지 않는다).
  정본: `useSalesReportsStore.ts` `userGroup: sesUserId` / `userId: sesUserId`.
- ⛔ `session.groupId` 참조 금지 — **유령 필드**다. [[feedback_session_groupid_ghost_field]]
- 버튼 노출 권한은 `useTabBtnPermissions({ menuId })` 가 담당하며, 이 역시 서버가 세션 사용자 기준으로
  보유 그룹 합집합을 계산해 돌려준다(#125 §4.1). 모달도 **같은 메커니즘**을 쓴다.

## §4. 적용 절차 (모든 화면 공통)

1. **탐지** — 그룹 비교가 있는 SP 를 전수 조사한다:
   ```sql
   SELECT NAME, LINE, TEXT FROM ALL_SOURCE
    WHERE OWNER='SCM_MGR' AND TYPE IN ('PACKAGE BODY','PROCEDURE','FUNCTION')
      AND (UPPER(TEXT) LIKE '%GET_ADMIN_GROUP%' OR REGEXP_LIKE(TEXT,'GROUP_ID\s*=\s*''','i'))
      AND LTRIM(TEXT) NOT LIKE '--%' ORDER BY NAME, LINE;
   ```
2. **분류** — ①합집합 이미 적용 ②파라미터 단일 비교만 ③리터럴 그룹명 하드코딩.
3. **정정** — ②③ 을 §3 정본 형태로 바꾼다. 마커 `[AUTHUNION yyyy-mm-dd]` 를 남긴다.
4. **검증(필수)** — 아래 §5 를 **실행**한다. 정적 통과로 끝내지 않는다.

## §5. 검증 — 실측 2축 (hook #126 정직성 계약)

| 축 | 방법 | 합격 |
|---|---|---|
| A. 다중그룹 사용자 | 편집 권한 그룹을 **부차적으로만** 보유한 계정(예: 주 그룹이 Viewer, 부 그룹이 DM ADMIN)으로 조회 | 편집 허용 판정(EDIT_FLAG='Y' 등) |
| B. 무권한 사용자 | 편집 권한 그룹을 **하나도** 보유하지 않은 계정 | 편집 차단 |

- FE 가 실제로 보내는 payload **그대로** HTTP 로 호출해 확인한다(테스트용으로 `userGroup:'ADMIN'` 을
  손으로 넣어 통과시키는 것은 **검증이 아니다** — 2026-08-10 실측 시 이 함정을 실제로 밟았다).
- 계정 로스터는 #125 §5 (Division×역할 15계정)를 쓴다.

## §6. ⚠ 편집 불가의 원인을 권한으로 단정하지 말 것 (2026-08-10 실측 교훈)

DMF0044 "편집 가능 메저가 안 보인다" 신고를 추적한 결과 **권한은 정상**이었고 원인은 따로 있었다:

| 조회 축 | 실측 | 원인 |
|---|---|---|
| Data Type = **ETC** | 76행 **전부 EDIT_FLAG='Y'** | 합집합 판정 정상 동작 |
| Data Type = **Cutoff** | 2,429행 **전부 'N'** | 편집 대상 행(DATA_TYPE='2')은 `CUTOFF_TYPE='REPORT_SP_W_E'` 라 `R.CUTOFF_TYPE = P_MDF_TYPE('REPORT_SP_W')` 필터에서 **아예 제외**됨 ⇒ `AND (DATA_TYPE='2')` 조건은 이 경로에서 **도달 불가(dead)** |
| Data Type = **ALL** | — | FE 게이트0 전면 차단 |

⇒ 권한 판정을 고치기 전에 **①조회 행수 ②EDIT_FLAG 분포 ③FE 편집 매트릭스** 3층을 각각 실측해
어느 층에서 막혔는지 먼저 가른다. [[feedback_gate_tool_false_positive_families]] 와 같은 계보의 오진 방지.

## §7. POST-WRITE grep

```bash
# ① FE — 유령 필드 참조 0 이어야 한다
grep -rn "session\.groupId\|groupId:" nscm-fe/features nscm-fe/packages --include=*.ts --include=*.tsx
# ② FE — 권한 파라미터는 세션 userId 여야 한다
grep -rn "userGroup:" nscm-fe/features --include=*.ts | grep -v "sesUserId"
```
둘 다 **0건**이어야 한다(②는 정당 예외 시 사유 주석 필수).

## §8. 잔여 인벤토리 (2026-08-10 전수 실측 — FE features 전 화면 grep)

`session.groupId || sesUserId` **fallback 형** 잔존 5화면. 유령 필드가 항상 undefined 라
**기능상으로는 이미 userId 로 동작**하나(우연히 옳음), 룰 위반 형태이므로 **해당 화면 작업 시** 정리한다
(무관한 화면 임의 수정 금지 — 회귀 관리 단위 유지, #127 §1.1 과 동일 원칙):

| 화면 | 위치 |
|---|---|
| DMF0014 customer-fcst-upload | `useCustomerFcstUploadStore.ts:89` |
| DMF0082 forecast-price | `SavePricePeriodModal.tsx:304` |
| DMF0003 mkt-fcst | `MktFcst.tsx:615` · `useMktFcstStore.ts:261` |
| DMF0048 sales-monitoring | `useSalesMonitoringStore.ts:146` |

별개 유형(§8-2): `MktFcst.tsx:183/188` 은 **그룹명 리터럴을 FE 가 직접 전송**(`GROUP.SCP_PLANNER` 등) —
서버 판정식이 §3 정본이면 무해하지만, FE 가 그룹을 "선택"하는 구조라 화면 작업 시 §3.1 로 전환한다.
DMF0049 etc-sales-reports 의 `userGroup` 은 편집게이트 로직 인자(파라미터 전송 아님) — 대상 아님.
