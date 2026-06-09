package com.zp.haoke.house.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.zp.haoke.framework.core.domain.pojo.BasePojo;
import lombok.Data;

import java.time.LocalDate;

@Data
@TableName("house_contract")
public class HouseContractPO extends BasePojo {
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private String id;

    @TableField("user_id")
    private String userId;

    @TableField("house_id")
    private String houseId;

    @TableField("order_id")
    private String orderId;

    @TableField("contract_no")
    private String contractNo;

    @TableField("title")
    private String title;

    @TableField("period_start")
    private LocalDate periodStart;

    @TableField("period_end")
    private LocalDate periodEnd;

    @TableField("status")
    private String status;

    @TableField("pdf_url")
    private String pdfUrl;

    @TableField("sign_url")
    private String signUrl;
}
