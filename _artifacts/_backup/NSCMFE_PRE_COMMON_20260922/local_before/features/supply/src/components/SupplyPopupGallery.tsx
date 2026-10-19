import {
  ItemByDivisionModal,
  MaterialByDivisionModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import { useState } from 'react';

import { Button, InputField } from '@shared/lges';

import { CapaItemPopup, type CapaItemPopupParams } from './CapaItemPopup';
import { ElecMaterialPopup, type ElecMaterialPopupParams } from './ElecMaterialPopup';
import { ModelByDivisionPopup, type ModelByDivisionPopupParams } from './ModelByDivisionPopup';
import { OwnerByDivisionPopup } from './OwnerByDivisionPopup';
import { ProjectByDivisionPopup, type ProjectByDivisionPopupParams } from './ProjectByDivisionPopup';
import { SalesReportPopup } from './SalesReportPopup';
import { VersionPopup } from './VersionPopup';

// supply 공통 팝업을 클릭해 열어 보는 데모 영역.
//   공통 COM 팝업(COM0008 등)은 기존 master 컴포넌트를 그대로 연결하고,
//   SCM0002 고유 팝업(모1·모2·프1·아1)만 supply 자체 컴포넌트를 쓴다.
type PopupKind =
  | 'model'
  | 'elec'
  | 'nickname'
  | 'material'
  | 'project'
  | 'projectEx'
  | 'owner'
  | 'item'
  | 'version'
  | 'salesReport';

interface ActivePopup {
  kind: PopupKind;
  variant: string;
  // 모1(Model) 만 조회 파라미터를 넘긴다.
  params?: ModelByDivisionPopupParams;
}

// AS-IS SCP0016 Model 팝업(SCM0002_ItembyDivisionPopup) 트리거에 하드코딩으로 넘길 파라미터.
const SCP0016_MODEL_PARAMS = {
  divisionId: '40',
  projectCode: '',
  scmSiteId: '',
  itemId: '',
} as const;

// AS-IS SCP0095 Elec Material 팝업(SCM0002_ItembyDivisionPopupEE) 파라미터.
//   divisionId 는 parent 화면(SCP0095) 표시용, 실제 조회 division 은 팝업 내부에서 '81,82,40' 고정.
const SCP0095_ELEC_PARAMS: ElecMaterialPopupParams = {
  divisionId: '81',
  companyId: 'ALL',
  itemId: '',
};

// AS-IS DMF0014 Model/Nickname 팝업 = DM0002_ItembyDivisionPopupEx = 공통 COM0008.
//   → 기존 master ItemByDivisionModal 을 그대로 연결(재사용). DMF0014 조회조건 값을 preSearchParams 로 넘긴다.
const DMF0014_ITEM_PRESEARCH = {
  divisionId: '40',
  deptId: 'ALL',
  endCustomer: 'ALL',
  salesSite: 'ALL',
  projectCode: '',
} as const;

// AS-IS SCP0022 Material 팝업 = SCM0002_MaterialByDivisionPopup = 공통 COM0013.
//   → 기존 master MaterialByDivisionModal 을 그대로 연결(재사용). scpModuleType 은 호출 화면 코드.
const SCP0022_MAT_PRESEARCH = {
  divisionId: '40',
  operationGroup: '',
  scpModuleType: 'SCP0022',
} as const;

// AS-IS SCP0009 Project 팝업(SCM0002_ProjectbyDivisionPopup base = SCM0002 고유) 파라미터.
const SCP0009_PROJ_PARAMS: ProjectByDivisionPopupParams = {
  divisionId: '81',
  projectCode: '',
};

// AS-IS SCP0104 CAPA Item 팝업(SCM0002_CAPAItemPopup = SCM0002 고유) 파라미터.
const SCP0104_CAPA_PARAMS: CapaItemPopupParams = {
  divisionId: '81',
  itemId: '',
};

// 아직 트리거를 필드로 만들지 않은 나머지 라벨 — 임시 버튼.
const PENDING_BUTTONS: { label: string; kind: PopupKind }[] = [
  { label: '오1', kind: 'owner' },
  { label: '버1', kind: 'version' },
  { label: '버2', kind: 'version' },
  { label: '세1', kind: 'salesReport' },
];

export const SupplyPopupGallery = () => {
  // 한 번에 하나의 팝업만 열린다.
  const [active, setActive] = useState<ActivePopup | null>(null);
  // 모1 Model / 모2 Material / 모3 Model·Nickname / 메1 Material 필드에 팝업 선택값이 채워진다.
  const [modelValue, setModelValue] = useState('');
  const [materialValue, setMaterialValue] = useState('');
  const [nicknameValue, setNicknameValue] = useState('');
  const [materialByDivValue, setMaterialByDivValue] = useState('');
  const [projectValue, setProjectValue] = useState('');
  const [projectExValue, setProjectExValue] = useState('');
  const [capaItemValue, setCapaItemValue] = useState('');
  const close = () => setActive(null);

  // 모1 = AS-IS SCP0016 Model 팝업. 부모 입력창 텍스트를 itemId 로 넘겨 팝업에 자동 입력.
  const openModel1 = () =>
    setActive({ kind: 'model', variant: '모1', params: { ...SCP0016_MODEL_PARAMS, itemId: modelValue } });
  // 모2 = AS-IS SCP0095 Elec Material 팝업.
  const openElec2 = () => setActive({ kind: 'elec', variant: '모2' });
  // 모3 = AS-IS DMF0014 Model/Nickname 팝업(공통 COM0008 = master ItemByDivisionModal 재사용).
  const openNick3 = () => setActive({ kind: 'nickname', variant: '모3' });
  // 메1 = AS-IS SCP0022 Material 팝업(공통 COM0013 재사용).
  const openMat1 = () => setActive({ kind: 'material', variant: '메1' });
  // 프1 = AS-IS SCP0009 Project 팝업(SCM0002 고유).
  const openProj1 = () => setActive({ kind: 'project', variant: '프1' });
  // 프2 = AS-IS DMF0040 Project 팝업(DMF000_ProjectbyDivisionPopupEx = 공통 COM0005 재사용).
  const openProj2 = () => setActive({ kind: 'projectEx', variant: '프2' });
  // 아1 = AS-IS SCP0104 CAPA Item 팝업(SCM0002 고유).
  const openItem1 = () => setActive({ kind: 'item', variant: '아1' });

  return (
    <section aria-labelledby='supply-common-popup'>
      <h2 id='supply-common-popup'>Supply 공통 팝업</h2>

      {/* 모1 = AS-IS SCP0016 Model 팝업. */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '12px' }}>
        <span style={{ width: '32px', color: '#888' }}>모1</span>
        <label style={{ width: '48px' }}>Model</label>
        <div style={{ width: '220px' }}>
          <InputField
            fullWidth
            value={modelValue}
            onChange={e => setModelValue(e.target.value)}
            placeholder='Model 입력 또는 검색'
          />
        </div>
        <Button appearance='outlined' priority='normal' size='medium' buttonLabel='검색' onClick={openModel1} />
      </div>

      {/* 모2 = AS-IS SCP0095 Elec Material 팝업. */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '12px' }}>
        <span style={{ width: '32px', color: '#888' }}>모2</span>
        <label style={{ width: '48px' }}>Material</label>
        <div style={{ width: '220px' }}>
          <InputField
            fullWidth
            value={materialValue}
            onChange={e => setMaterialValue(e.target.value)}
            placeholder='Material 입력 또는 검색'
          />
        </div>
        <Button appearance='outlined' priority='normal' size='medium' buttonLabel='검색' onClick={openElec2} />
      </div>

      {/* 모3 = AS-IS DMF0014 Model/Nickname 팝업(공통 COM0008 = master ItemByDivisionModal). */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '12px' }}>
        <span style={{ width: '32px', color: '#888' }}>모3</span>
        <label style={{ width: '48px' }}>Model</label>
        <div style={{ width: '220px' }}>
          <InputField
            fullWidth
            value={nicknameValue}
            onChange={e => setNicknameValue(e.target.value)}
            placeholder='Model/Nickname 입력 또는 검색'
          />
        </div>
        <Button appearance='outlined' priority='normal' size='medium' buttonLabel='검색' onClick={openNick3} />
      </div>

      {/* 메1 = AS-IS SCP0022 Material 팝업(공통 COM0013). */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '12px' }}>
        <span style={{ width: '32px', color: '#888' }}>메1</span>
        <label style={{ width: '48px' }}>Material</label>
        <div style={{ width: '220px' }}>
          <InputField
            fullWidth
            value={materialByDivValue}
            onChange={e => setMaterialByDivValue(e.target.value)}
            placeholder='Material 입력 또는 검색'
          />
        </div>
        <Button appearance='outlined' priority='normal' size='medium' buttonLabel='검색' onClick={openMat1} />
      </div>

      {/* 프1 = AS-IS SCP0009 Project 팝업(SCM0002 고유). */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '12px' }}>
        <span style={{ width: '32px', color: '#888' }}>프1</span>
        <label style={{ width: '48px' }}>Project</label>
        <div style={{ width: '220px' }}>
          <InputField
            fullWidth
            value={projectValue}
            onChange={e => setProjectValue(e.target.value)}
            placeholder='Project 입력 또는 검색'
          />
        </div>
        <Button appearance='outlined' priority='normal' size='medium' buttonLabel='검색' onClick={openProj1} />
      </div>

      {/* 프2 = AS-IS DMF0040 Project 팝업(공통 COM0005 = master ProjectByDivisionModal). */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '12px' }}>
        <span style={{ width: '32px', color: '#888' }}>프2</span>
        <label style={{ width: '48px' }}>Project</label>
        <div style={{ width: '220px' }}>
          <InputField
            fullWidth
            value={projectExValue}
            onChange={e => setProjectExValue(e.target.value)}
            placeholder='Project 입력 또는 검색'
          />
        </div>
        <Button appearance='outlined' priority='normal' size='medium' buttonLabel='검색' onClick={openProj2} />
      </div>

      {/* 아1 = AS-IS SCP0104 CAPA Item 팝업(SCM0002 고유). */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '12px' }}>
        <span style={{ width: '32px', color: '#888' }}>아1</span>
        <label style={{ width: '48px' }}>Item</label>
        <div style={{ width: '220px' }}>
          <InputField
            fullWidth
            value={capaItemValue}
            onChange={e => setCapaItemValue(e.target.value)}
            placeholder='Item 입력 또는 검색'
          />
        </div>
        <Button appearance='outlined' priority='normal' size='medium' buttonLabel='검색' onClick={openItem1} />
      </div>

      {/* 나머지 라벨은 임시 버튼 — 각 팝업 스펙 확정 시 실제 트리거로 교체 */}
      <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
        {PENDING_BUTTONS.map(({ label, kind }) => (
          <Button
            key={label}
            appearance='outlined'
            priority='normal'
            size='medium'
            buttonLabel={label}
            onClick={() => setActive({ kind, variant: label })}
          />
        ))}
      </div>

      <ModelByDivisionPopup
        open={active?.kind === 'model'}
        params={active?.kind === 'model' ? active.params : undefined}
        onClose={close}
        onSelect={selected => setModelValue(selected.itemId)}
      />
      <ElecMaterialPopup
        open={active?.kind === 'elec'}
        params={active?.kind === 'elec' ? { ...SCP0095_ELEC_PARAMS, itemId: materialValue } : undefined}
        onClose={close}
        onSelect={selected => setMaterialValue(selected.itemId)}
      />
      {/* 모3 — 기존 master ItemByDivisionModal 그대로 연결(COM0008 재사용). */}
      <ItemByDivisionModal
        open={active?.kind === 'nickname'}
        modalClose={close}
        setSelectedValue={items => setNicknameValue(items)}
        preSearchParams={{ ...DMF0014_ITEM_PRESEARCH, itemId: nicknameValue }}
        callFromCell={false}
        headerTitle='Model by DivisionPopup'
      />
      {/* 메1 — 기존 master MaterialByDivisionModal 그대로 연결(COM0013 재사용). */}
      <MaterialByDivisionModal
        open={active?.kind === 'material'}
        modalClose={close}
        setSelectedValue={items => setMaterialByDivValue(items)}
        preSearchParams={{ ...SCP0022_MAT_PRESEARCH, itemId: materialByDivValue }}
        headerTitle='Material by Division Popup'
      />
      <ProjectByDivisionPopup
        open={active?.kind === 'project'}
        params={active?.kind === 'project' ? { ...SCP0009_PROJ_PARAMS, projectCode: projectValue } : undefined}
        onClose={close}
        onSelect={selected => setProjectValue(selected.projectCode)}
      />
      {/* 프2 — 기존 master ProjectByDivisionModal 그대로 연결(COM0005 재사용). */}
      <ProjectByDivisionModal
        open={active?.kind === 'projectEx'}
        modalClose={close}
        setSelectedValue={proj => setProjectExValue(proj)}
        preSearchParams={{
          divisionId: '40',
          deptId: 'ALL',
          endCustomer: 'ALL',
          salesSite: 'ALL',
          etc: '',
          projectCode: projectExValue,
        }}
        callFromCell={false}
      />
      <CapaItemPopup
        open={active?.kind === 'item'}
        params={active?.kind === 'item' ? { ...SCP0104_CAPA_PARAMS, itemId: capaItemValue } : undefined}
        onClose={close}
        onSelect={selected => setCapaItemValue(selected.itemId)}
      />
      <OwnerByDivisionPopup open={active?.kind === 'owner'} variant={active?.variant} onClose={close} />
      <VersionPopup open={active?.kind === 'version'} variant={active?.variant} onClose={close} />
      <SalesReportPopup open={active?.kind === 'salesReport'} variant={active?.variant} onClose={close} />
    </section>
  );
};
