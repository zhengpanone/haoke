package com.zp.haoke.house.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.zp.haoke.framework.core.domain.pojo.BasePojo;
import lombok.Data;

import java.math.BigDecimal;

@Data
@TableName("user_wallet")
public class UserWalletPO extends BasePojo {
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private String id;

    @TableField("user_id")
    private String userId;

    @TableField("balance")
    private BigDecimal balance;

    @TableField("frozen_amount")
    private BigDecimal frozenAmount;
}
