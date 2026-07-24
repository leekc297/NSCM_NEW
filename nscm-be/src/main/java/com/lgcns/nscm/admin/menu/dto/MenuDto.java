package com.lgcns.nscm.admin.menu.dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Builder
@AllArgsConstructor
public class MenuDto {
    private String mnuId;
    private String upprMnuId;
    private String mnuUrl;
    private String routePath;
    private String mnuMsgId;
    private String mnuDesc;
    private BigDecimal sortOrd;

    @Setter
    private boolean favorite;

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    @Builder.Default
    private List<MenuDto> children = new ArrayList<>();

    public static MenuDto of(Map<String, Object> data) {
    	return MenuDto.builder()
    		.mnuId((String) data.get("MNU_ID"))
    		.upprMnuId((String) data.get("UPPR_MNU_ID"))
    		.mnuUrl((String) data.get("MNU_URL"))
            .routePath((String) data.get("ROUTE_PATH"))
    		.mnuMsgId((String) data.get("MNU_MSG_ID"))
    		.mnuDesc((String) data.get("MNU_DESC"))
    		.sortOrd((BigDecimal) data.get("SORT_ORD"))
    		.favorite(data.get("BMK_YN").equals("Y") ? true : false)
    		.build();
    }

    public static List<MenuDto> listOf(List<Map<String, Object>> datas) {
    	List<MenuDto> result = new ArrayList<>();
    	for (int i = 0; i < datas.size(); i++) {
    		result.add(MenuDto.of(datas.get(i)));
		}
    	return result;
    }

    public static List<MenuDto> treeOf(List<MenuDto> menus) {
        if (menus == null || menus.isEmpty()) return new ArrayList<>();

        menus.sort(Comparator.comparing(MenuDto::getSortOrd, Comparator.nullsLast(BigDecimal::compareTo)));

        Map<String, MenuDto> menuMap = menus.stream()
                .collect(Collectors.toMap(MenuDto::getMnuId, menu -> menu));

        List<MenuDto> rootMenus = new ArrayList<>();

        for (MenuDto menu : menus) {
            String parentId = menu.getUpprMnuId();

            if (parentId == null) {
                rootMenus.add(menu);
            } else {
                MenuDto parentMenu = menuMap.get(parentId);
                if (parentMenu != null) {
                    parentMenu.getChildren().add(menu);
                }
            }
        }

        return rootMenus;
    }
}
