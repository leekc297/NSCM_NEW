# Hook — useProcMutation `onSuccess` override 시 default 동작 명시 호출 의무

> **트리거**: `mutate(payload, { onSuccess: ... })` 사용 시
>
> **목적**: 사용자 정의 onSuccess 가 `useProcMutation` 의 default onSuccess (invalidate + toast) 를 **완전 대체** 한다는 사실을 인지 → refetch 누락 + toast 누락 사고 방지

작성: 2026-06-06 (SCM0008 ADD 후 grid 미갱신 + SCM0009 Approve 후 toast 미표시 사고)
관련 룰: `_tobe/04_store.md`, `_tobe/11_be_controller_service.md`
상위 룰: `anti-simplification.md`

---

## §0. 사고 (2026-06-06)

### §0.1 SCM0008 ADD onSuccess 사고

```typescript
// ❌ 위반 패턴
mutateMyAuth(rows, {
  onSuccess: () => {
    setRecentlyAddedKeys(addedKeys);
  },
});
```

**결과**:
- `setRecentlyAddedKeys` 만 실행 → queryClient.invalidateQueries 호출 안 됨 → MyAuthorityList grid **데이터 미갱신**
- toast "성공적으로 저장되었습니다" 미표시
- 사용자가 추가가 안 된 줄 알고 재차 ADD 클릭 → 중복 등록 시도

### §0.2 SCM0009 Approve onSuccess 사고

```typescript
// ❌ 동일 패턴
mutateApprove(payload, {
  onSuccess: () => { setToast({ message: '승인 완료' }); },
});
```

→ refetch 누락 → grid 에 승인 결과 미반영.

---

## §1. 원인

`useProcMutation` (`packages/shared/src/hooks/useCustomQueryClient.ts`) 의 default onSuccess:

```typescript
onSuccess:
  onSuccess ??                                              // ⭐ ?? 연산자
  (() => {
    void queryClient.invalidateQueries({ queryKey: [tabId] });
    setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
  }),
```

**`??` 연산자**: 사용자가 onSuccess 를 전달하면 default 완전 대체. partial override / merge 아님.

---

## §2. 의무 패턴 (PRE-WRITE)

### §2.1 onSuccess override 시 4 요소 의무

```typescript
import { useQueryClient } from '@tanstack/react-query';

const queryClient = useQueryClient();
const setToast = useMessageStore(state => state.setToast);

mutateXxx(payload, {
  onSuccess: () => {
    // (1) 화면 특화 로직 — recentlyAddedKeys, 다른 mutation 체이닝, etc.
    setRecentlyAddedKeys(addedKeys);
    if (chainedUpdate.length > 0) mutateOther(chainedUpdate);

    // (2) ⭐ default 의무 #1: refetch
    void queryClient.invalidateQueries({ queryKey: [tabId] });

    // (3) ⭐ default 의무 #2: success toast
    setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
  },
});
```

**4 요소**:
1. 화면 특화 로직
2. `queryClient.invalidateQueries({ queryKey: [tabId] })`
3. `setToast({ type: 'success', message: ... })`
4. (선택) 추가 grid clear / state reset

### §2.2 화면 특화 로직 없는 경우

→ **onSuccess 전달 자체를 생략**:

```typescript
// ✅ default 활용 (refetch + toast 자동)
mutateXxx(payload);
```

→ default 가 자동으로 invalidate + toast 실행. 코드 단순.

---

## §3. POST-WRITE 자동 검증 grep

```bash
MAIN="features/{domain}/src/pages/{screen}/{Name}.tsx"

# 모든 mutate*(payload, { onSuccess: ... }) 검출
awk '/mutate\w+\(.*\{[\s]*$/,/^\s*\}\)\s*;/' "$MAIN" > /tmp/mutate_blocks.txt

# 각 블록에 invalidateQueries / setToast 존재 검증
if grep -q "onSuccess:" /tmp/mutate_blocks.txt; then
  grep -c "invalidateQueries" /tmp/mutate_blocks.txt   # ≥ 1
  grep -c "setToast\|setAlert" /tmp/mutate_blocks.txt  # ≥ 1
fi

# anti-simplification: onSuccess 안에 setRecentlyXxx / state update 만 있고
# invalidate 누락 → 위반 (사용자 보고 사고 재현)
```

---

## §4. PR 머지 게이트

- [ ] 모든 `mutate*({onSuccess})` 호출은 (a) refetch + toast 명시 또는 (b) onSuccess 전달 생략
- [ ] 화면 특화 + default 동작이 모두 필요한 경우 4 요소 (특화 + invalidate + toast + reset) 명시
- [ ] `?? 연산자 = 완전 대체` 의미 분석 결과를 `__asis-mapping__.md ## Mutation` 표에 기재

---

## §5. cross-ref

| 항목 | 룰 |
|---|---|
| useProcMutation default 동작 | `packages/shared/src/hooks/useCustomQueryClient.ts:110~115` |
| recentlyAddedKeys 패턴 | `feedback_recently_added_loadedrows_pattern` 메모리 |
| toast 표준 메시지 (MSG00002 등) | `13_I18N_MESSAGES.md` |

---

## §6. 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-06 | 초안 작성 | SCM0008 ADD / SCM0009 Approve 사고 |
