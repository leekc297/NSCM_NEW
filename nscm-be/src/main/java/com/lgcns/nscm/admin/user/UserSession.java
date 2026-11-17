package com.lgcns.nscm.admin.user;

import java.io.Serializable;
import java.util.List;

import com.lgcns.nscm.admin.menu.dto.MenuDto;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
public class UserSession implements Serializable {

	private static final long serialVersionUID = 1L;

	/* 세션에서 관리할 항목 정의 */
	private String userId;
	private String userNm;
	private String userEngNm;
	private String langCd;
	private String tmzCd;
	private List<MenuDto> menus;
	private boolean isGuest;
	private List<String> groups;
	private String div;
	private String companyId;

	@Builder
	public UserSession(String userId, String userNm, String userEngNm, String langCd, String tmzCd, List<MenuDto> menus, boolean isGuest, List<String> groups, String div, String companyId) {
		this.userId = userId;
		this.userNm = userNm;
		this.userEngNm = userEngNm;
		this.langCd = langCd;
		this.tmzCd = tmzCd;
		this.menus = menus;
		this.isGuest = isGuest;
		this.groups = groups;
		this.div = div;
		this.companyId = companyId;
	}
}
