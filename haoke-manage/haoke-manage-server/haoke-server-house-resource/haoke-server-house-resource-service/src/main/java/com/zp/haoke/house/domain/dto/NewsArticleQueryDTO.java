package com.zp.haoke.house.domain.dto;

import com.zp.haoke.framework.core.domain.dto.PageDTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class NewsArticleQueryDTO extends PageDTO {

    private String title;

    private Integer status;
}
