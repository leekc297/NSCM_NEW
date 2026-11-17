package com.lgcns.nscm.admin.menu.dto;

import java.util.List;

import com.lgcns.nscm.admin.auth.dto.UnitDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class MenuAuthDto {
    private List<String> mnuBtnAuth;
    private List<UnitDto> unitAuth;
}
