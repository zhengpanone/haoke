package com.zp.haoke.house.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.zp.haoke.framework.core.domain.pojo.BasePojo;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("wallet_record")
public class WalletRecordPO extends BasePojo {
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private String id;

    @TableField("user_id")
    private String userId;

    @TableField("record_type")
    private String recordType;

    @TableField("title")
    private String title;

    @TableField("amount")
    private BigDecimal amount;

    @TableField("income")
    private Boolean income;

    @TableField("status")
    private String status;

    @TableField("record_time")
    private LocalDateTime recordTime;
}
