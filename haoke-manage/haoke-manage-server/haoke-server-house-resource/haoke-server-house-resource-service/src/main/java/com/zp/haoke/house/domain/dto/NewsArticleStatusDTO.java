package com.zp.haoke.house.domain.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class NewsArticleStatusDTO {

    @NotNull(message = "资讯状态不能为空")
    private Integer status;
}
