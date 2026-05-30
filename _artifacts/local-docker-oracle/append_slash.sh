#!/bin/bash
for f in /tmp/seeds/30_DMF0043_Contribute_Main_Registration_DBeaver.sql \
         /tmp/seeds/31_DMF0043_01_Contribute_View_Registration_DBeaver.sql \
         /tmp/seeds/32_DMF0072_NNMasterMapping_Registration_DBeaver.sql \
         /tmp/seeds/33_DMF_MENU_URL_GUEST_Perm_Fix_DBeaver.sql \
         /tmp/seeds/34_DMF0043_DMF0072_PROC_Meta_Insert_DBeaver.sql \
         /tmp/seeds/35_DMF0043_Main_Stub_SP_DBeaver.sql; do
  if [ -f "$f" ]; then
    last=$(tail -1 "$f")
    if [ "$last" != "/" ]; then
      printf '\n/\n' >> "$f"
      echo "appended /: $f"
    else
      echo "already has /: $f"
    fi
  else
    echo "MISSING: $f"
  fi
done
