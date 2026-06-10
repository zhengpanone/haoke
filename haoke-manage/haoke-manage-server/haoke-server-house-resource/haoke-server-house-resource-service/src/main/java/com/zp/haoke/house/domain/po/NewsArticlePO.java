package com.zp.haoke.house.domain.po;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.zp.haoke.framework.core.domain.pojo.BasePojo;
import lombok.Data;

import java.io.Serial;
import java.time.LocalDateTime;

@Data
@TableName("news_article")
public class NewsArticlePO extends BasePojo {

    @Serial
    private static final long serialVersionUID = 1L;

    @TableId("id")
    private String id;

    @TableField("title")
    private String title;

    @TableField("summary")
    private String summary;

    @TableField("content")
    private String content;

    @TableField("cover_url")
    private String coverUrl;

    @TableField("source")
    private String source;

    @TableField("status")
    private Integer status;

    @TableField("sort")
    private Integer sort;

    @TableField("publish_time")
    private LocalDateTime publishTime;
}
