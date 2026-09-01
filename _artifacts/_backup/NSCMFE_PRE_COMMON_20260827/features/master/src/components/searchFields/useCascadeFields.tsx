import { useCallback, useEffect, useMemo } from 'react';
import { useTranslation } from 'react-i18next';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import {
  CASCADE_LEVELS,
  blankValue,
  cell,
  normalizeLevel,
  readValue,
  toCodeSet,
  writeValue,
} from './CascadeFields.utils';
import type {
  CascadeLevelKey,
  FieldValue,
  Row,
  UseCascadeFieldsOptions,
} from './CascadeFields.utils';
import { logLevelCascade } from './SearchFields.debug';

// ====================================================================================
// useCascadeFields
// ====================================================================================
/**
 * 단계별 엘리먼트를 만들어 돌려주는 훅.
 *
 * 단계를 붙여서 렌더할 수 있으면 CascadeFields 컴포넌트를 그대로 쓰면 되고,
 * NnMasterMappingForm 처럼 중간에 다른 조회조건(popup input 등)이 끼어서 배치가 찢어지는
 * 화면은 이 훅으로 받아 원하는 자리에 하나씩 꽂는다.
 *
 * 필수: cascade 계산 순서는 levels 배열 순서다 — 화면 배치 순서가 아니다.
 * salesSite 를 Project / Model 뒤에 그리든 앞에 그리든 division -> team -> ... 순으로 좁혀진다.
 */
export const useCascadeFields = <V extends object>({
  comboId,
  levels,
  value,
  onChange,
  gridSize,
  enabled = true,
  debugLabel,
}: UseCascadeFieldsOptions<V>) => {
  const { t } = useTranslation();
  // 콤보는 화면당 1건. 같은 comboId 를 쓰는 다른 화면과 react-query 캐시를 공유하므로
  // levels 를 3개로 줄이든 4개로 늘리든 네트워크 호출 수는 그대로 1이다.
  const [comboRows] = useTabComboQueries({ filters: [comboId], enabled });
  const rows = useMemo(() => (comboRows ?? []) as Row[], [comboRows]);

  // levels 는 호출부가 인라인 배열로 넘기는 게 자연스러운 prop 이라 매 렌더 새 참조다.
  // 내용이 같으면 같은 memo 를 쓰도록 값 기준 서명으로 고정한다 — 호출부에 useMemo 를 강요하지 않는다.
  const levelsSignature = JSON.stringify(levels);

  // 단계 확정 — 컬럼은 몇 번째 단계든 카탈로그 풀네임 그대로다 (콤보 SQL 규약).
  const resolved = useMemo(
    () =>
      levels.map(normalizeLevel).map(spec => {
        const preset = CASCADE_LEVELS[spec.key];
        return {
          ...spec,
          preset,
          field: spec.field ?? spec.key,
          columns: spec.columns ?? { code: preset.code, name: preset.name },
        };
      }),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [levelsSignature]
  );

  // value 는 화면 스토어 전체(projectCode 타이핑 등 무관한 변경까지 포함)라 그대로 의존하면
  // 관계없는 입력 한 글자마다 콤보 전량을 다시 훑게 된다. 단계 값만 뽑아 서명으로 쓴다.
  const selected = resolved.map(({ field }) => readValue(value, field));
  // 구분자는 조회조건 값에 절대 안 나오는 문자여야 한다 - 콤마는 다중선택 조인에 이미 쓰인다.
  const selectedSignature = selected.join('\u0001');

  // 단계별 옵션 — i 번째 옵션은 0..i-1 단계 선택으로 좁힌 행에서 뽑는다.
  // 상위 단계가 미선택('ALL')이면 그 단계는 건너뛰므로 전량이 그대로 흘러간다.
  const computed = useMemo(() => {
    let current = rows;
    const snapshots: Parameters<typeof logLevelCascade>[0]['levels'] = [];
    const optionsByLevel = resolved.map(({ key, columns }, i) => {
      const options = [
        ...new Map(
          current
            .map(r => [cell(r, columns.code), cell(r, columns.name)] as const)
            .filter(([code]) => code !== '')
            .map(([code, name]) => [code, { label: name || code, value: code }] as const)
        ).values(),
      ];
      const filter = toCodeSet(selected[i]);
      if (filter) current = current.filter(r => filter.has(cell(r, columns.code)));
      if (debugLabel)
        snapshots.push({ key, column: columns.code, filter, remaining: current.length, options });
      return options;
    });
    return { optionsByLevel, snapshots };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rows, resolved, selectedSignature, debugLabel]);
  const optionsByLevel = computed.optionsByLevel;

  // 임시 로컬 디버그 — 입력이 실제로 바뀐 시점에만 찍는다 (렌더마다 찍히지 않게).
  const debugSignature = `${rows.length}|${selectedSignature}`;
  useEffect(() => {
    if (!debugLabel) return;
    logLevelCascade({ label: debugLabel, comboId, rawRows: rows, levels: computed.snapshots });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [debugLabel, debugSignature]);

  /**
   * 한 단계 변경 = 그 값 + 하위 단계 전부 초기화. 화면은 자기 고유 항목만 얹으면 된다.
   * 쓰기 값은 스토어 필드 모양에 맞춘다 — 문자열 필드면 문자열, 배열 필드면 배열.
   */
  const handleChange = useCallback(
    (index: number, raw: string) => {
      const next: Record<string, FieldValue> = {
        [resolved[index].field]: writeValue(value, resolved[index].field, raw),
      };
      resolved.slice(index + 1).forEach(lv => {
        next[lv.field] = blankValue(value, lv.field);
      });
      // V 는 화면 스토어라 여기서는 정체를 모르는 제네릭이다. 키 문자열로 조립한 객체와
      // Partial<V> 는 서로 겹치는 타입이 아니라 unknown 을 거쳐야 한다. field 이름 자체는
      // CascadeLevelSpec<FieldOf<V>> 로 호출부에서 이미 검증된다.
      onChange(next as unknown as Partial<V>, resolved[index].key);
    },
    [resolved, onChange, value]
  );

  // division 자동 보정 없음 (2026-08-23 사용자 요청) — 스토어 값이 옵션 목록에 없어도
  // 첫 옵션으로 덮어쓰지 않는다. 옵션이 1건인 단계도 ALL 과 그 1건을 그대로 보여 주고
  // 선택은 사용자에게 맡긴다.

  // levels 순서대로 만든 엘리먼트. 화면이 이 중 필요한 것만 골라 원하는 자리에 꽂아도
  // 위 cascade 계산에는 영향이 없다 — 렌더 위치와 계산 순서는 분리돼 있다.
  const fields = resolved.map((level, i) => {
    const { key, field, preset, label, disabled } = level;
    return (
      <Grid key={key} size={level.gridSize ?? gridSize ?? 4}>
        <FormItem
          className={commonStyles.formItem}
          label={label ?? t(preset.labelCode, { defaultValue: preset.labelEn })}
          labelAlign='right'
          required={preset.required}
          render={() => (
            <CustomDropdown
              multiple={preset.multiple}
              allOption={preset.allOption}
              useClearIcon={preset.allOption}
              limitTags={1}
              disabled={disabled}
              value={readValue(value, field)}
              options={optionsByLevel[i]}
              onChange={(_, options) => handleChange(i, String(options ?? ''))}
            />
          )}
        />
      </Grid>
    );
  });

  /** 단계 하나만 꺼내 원하는 자리에 렌더. levels 에 없는 key 면 아무것도 그리지 않는다. */
  const field = (key: CascadeLevelKey) => {
    const index = resolved.findIndex(level => level.key === key);
    return index < 0 ? null : fields[index];
  };

  return { fields, field };
};
