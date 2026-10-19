import { CRUD_TYPE } from '@foundation/constants';
import type { ComboResponse } from '@foundation/models';
import { useMessageStore } from '@shared/stores';

import { MSG } from '../demand-group-master.constants';
import type { GroupMasterRow, ModelListRow } from '../demand-group-master.types';

const str = (v: unknown): string => {
  if (v == null) return '';
  if (typeof v === 'string') return v;
  if (typeof v === 'number' || typeof v === 'boolean') return String(v);
  return '';
};

/**
 * SCP0110 저장검증 (AS-IS SaveData white-list, design 03 §3-E 1:1).
 *   1) 그룹명 중복 — 신규간 / 기존(dtGroupMaster)대비 (MSG00043).
 *   2) 복수 Project 동일그룹 금지 — 수정간 / 기존(dtModelListAll)대비 (리터럴 → MSG 신규 등록 대상).
 * 필수값(OPERATION_GROUP*·GROUP_NAME*) 검증은 useSaveWithValidation(메타 라벨 '*')이 담당.
 */
export const useDemandGroupMasterValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // MSG00043 은 등록 문구가 'Duplicate error on save. {0}'(KO/EN/CN 실측)로 {0} placeholder 를 가진다.
  //   자매 화면(sales-future-price/bod) 관례대로 위반 값으로 {0} 를 치환한다 — 미치환 시 리터럴 '{0}' 노출.
  const fail = (msgId: string, fallback: string, arg?: string): false => {
    const base = t(msgId, fallback);
    void setAlert({ type: 'alert', content: arg !== undefined ? base.replace('{0}', arg) : base });
    return false;
  };

  // 그룹명 중복 — 같은 DIVISION_ID+OPERATION_GROUP 안에서 GROUP_NAME 중복 금지.
  //   dirty(I/M) 행 간 + 기존 그룹마스터(GroupMaster_SCP_ALL) 대비(GROUP_ID 다른 행과 동일 NAME).
  const validateGroupMaster = (
    dirtyRows: GroupMasterRow[],
    existingGroups: ComboResponse[]
  ): boolean => {
    const targets = dirtyRows.filter(
      r => (r as { CRUD_TYPE?: string }).CRUD_TYPE !== CRUD_TYPE.DELETE
    );

    const seen = new Set<string>();
    for (const row of targets) {
      const key = `${str(row.DIVISION_ID)}|${str(row.OPERATION_GROUP)}|${str(row.GROUP_NAME).trim()}`;
      if (str(row.GROUP_NAME).trim() === '') continue;
      // 신규/수정 행 간 중복.
      if (seen.has(key))
        return fail(
          MSG.DUPLICATE_GROUP_NAME,
          '_저장시 중복 오류가 발생하였습니다. {0}',
          str(row.GROUP_NAME).trim()
        );
      seen.add(key);
      // 기존 그룹마스터 대비 — 같은 division+opGroup 에 같은 NAME 이면서 GROUP_ID 가 다른 행.
      const collide = existingGroups.some(g => {
        const rec = g as Record<string, unknown>;
        return (
          str(rec.DIVISION_ID) === str(row.DIVISION_ID) &&
          str(rec.OPERATION_GROUP) === str(row.OPERATION_GROUP) &&
          str(g.NAME).trim() === str(row.GROUP_NAME).trim() &&
          str(g.CODE) !== str(row.GROUP_ID)
        );
      });
      if (collide)
        return fail(
          MSG.DUPLICATE_GROUP_NAME,
          '_저장시 중복 오류가 발생하였습니다. {0}',
          str(row.GROUP_NAME).trim()
        );
    }
    return true;
  };

  // 복수 Project 동일그룹 금지 — 한 GROUP_ID 는 하나의 PROJECT_CODE 에만 매핑.
  //   수정(M) 행의 GROUP_ID 가 (다른 수정행/전체 모델리스트)의 다른 PROJECT_CODE 와 겹치면 차단.
  const validateModelList = (
    dirtyRows: ModelListRow[],
    allModelRows: ModelListRow[]
  ): boolean => {
    const edited = dirtyRows.filter(
      r => (r as { CRUD_TYPE?: string }).CRUD_TYPE === CRUD_TYPE.MODIFY && str(r.GROUP_ID) !== ''
    );
    // GROUP_ID -> 그 그룹에 매핑된 PROJECT_CODE 집합(수정 결과 반영: 편집행이 원본을 덮는다).
    const byGroup = new Map<string, Set<string>>();
    const add = (groupId: string, projectCode: string) => {
      if (groupId === '') return;
      const set = byGroup.get(groupId) ?? new Set<string>();
      set.add(projectCode);
      byGroup.set(groupId, set);
    };
    // 편집되지 않은 기존 매핑 + 편집 결과.
    const editedKeys = new Set(edited.map(r => `${str(r.DIVISION_ID)}|${str(r.PROJECT_CODE)}|${str(r.ITEM_ID)}`));
    for (const row of allModelRows) {
      const rowKey = `${str(row.DIVISION_ID)}|${str(row.PROJECT_CODE)}|${str(row.ITEM_ID)}`;
      if (editedKeys.has(rowKey)) continue; // 편집행은 아래에서 새 GROUP_ID 로 반영
      add(str(row.GROUP_ID), str(row.PROJECT_CODE));
    }
    for (const row of edited) add(str(row.GROUP_ID), str(row.PROJECT_CODE));

    for (const projects of byGroup.values()) {
      if (projects.size > 1) {
        return fail(
          MSG.MULTI_PROJECT_SAME_GROUP,
          '_복수의 Project를 같은 그룹으로 저장할 수 없습니다.'
        );
      }
    }
    return true;
  };

  return { validateGroupMaster, validateModelList };
};
