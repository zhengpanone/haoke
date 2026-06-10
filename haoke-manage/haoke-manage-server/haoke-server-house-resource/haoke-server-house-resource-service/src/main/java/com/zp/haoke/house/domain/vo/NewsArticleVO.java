package com.zp.haoke.house.domain.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NewsArticleVO {

    private String id;

    private String title;

    private String summary;

    private String content;

    private String coverUrl;

    private String source;

    private Integer status;

    private Integer sort;

    private LocalDateTime publishTime;

    private LocalDateTime created;

    private LocalDateTime updated;
}
