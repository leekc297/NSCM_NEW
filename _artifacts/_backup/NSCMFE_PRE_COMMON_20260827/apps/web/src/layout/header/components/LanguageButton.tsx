import { useState } from 'react';

import { ArrowDropDown } from '@shared/icons';
import { Button, Tooltip } from '@shared/lges';
import { useSessionStore } from '@shared/stores';

import styles from './LanguageButton.module.scss';

interface LanguageTooltipListProps {
  languages: { cmnCd: string; cmnCdNm: string }[];
  close: () => void;
}

const languages: { cmnCd: string; cmnCdNm: string }[] = [
  {
    cmnCd: 'KO',
    cmnCdNm: 'KOR',
  },
  {
    cmnCd: 'EN',
    cmnCdNm: 'ENG',
  },
  {
    cmnCd: 'CN',
    cmnCdNm: 'CHN',
  },
];

const LanguageTooltipList = ({ languages, close }: LanguageTooltipListProps) => {
  const changeLanguage = useSessionStore(state => state.changeLanguage);

  const handleLanguageChange = (
    e: React.MouseEvent<HTMLButtonElement, MouseEvent>,
    lang: string
  ) => {
    void changeLanguage(lang);
    e.preventDefault();
    close();
  };

  return (
    <div className={styles.tooltip}>
      {languages?.map(language => (
        <Button
          appearance='unfilled'
          priority='normal'
          className={styles.language}
          key={language.cmnCd}
          id={language.cmnCd}
          onClick={e => handleLanguageChange(e, language.cmnCd)}
        >
          <p id={language.cmnCd}>{language.cmnCdNm}</p>
        </Button>
      ))}
    </div>
  );
};

export const LanguageButton = () => {
  const session = useSessionStore(state => state.session);
  const currentLanguage = session.langCd;

  const [open, setOpen] = useState(false);

  const handleTooltip = () => {
    setOpen(!open);
  };
  const handleTooltipClose = () => {
    setOpen(false);
  };

  const getCurrentLanguageName = (cmnCd: string) => {
    return languages.find(item => item.cmnCd === cmnCd)?.cmnCdNm;
  };
  return (
    <Tooltip
      classes={{ tooltip: styles.tooltipWrapper }}
      open={open}
      title={<LanguageTooltipList languages={languages} close={handleTooltipClose} />}
    >
      <div>
        <Button
          appearance='unfilled'
          priority='normal'
          className={styles.button}
          onClick={handleTooltip}
        >
          <span className={styles.label}>{getCurrentLanguageName(currentLanguage)}</span>
          <ArrowDropDown sx={{ width: '16px', height: '16px', fill: '#1f1f1f' }} />
        </Button>
      </div>
    </Tooltip>
  );
};
