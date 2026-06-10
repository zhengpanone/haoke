package com.zp.haoke.house.domain.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NewsArticleUpdateDTO {

    @NotBlank(message = "资讯 ID 不能为空")
    private String id;

    @NotBlank(message = "资讯标题不能为空")
    @Size(max = 100, message = "资讯标题不能超过 100 个字符")
    private String title;

    @Size(max = 255, message = "资讯摘要不能超过 255 个字符")
    private String summary;

    @NotBlank(message = "资讯正文不能为空")
    private String content;

    private String coverUrl;

    private String source;

    private Integer status;

    private Integer sort;

    private LocalDateTime publishTime;
}
