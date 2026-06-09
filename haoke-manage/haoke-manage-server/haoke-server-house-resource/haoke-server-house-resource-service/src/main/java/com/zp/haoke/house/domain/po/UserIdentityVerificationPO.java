package com.zp.haoke.house.domain.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.zp.haoke.framework.core.domain.pojo.BasePojo;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("user_identity_verification")
public class UserIdentityVerificationPO extends BasePojo {
    @TableId(value = "id", type = IdType.ASSIGN_ID)
    private String id;

    @TableField("user_id")
    private String userId;

    @TableField("real_name")
    private String realName;

    @TableField("id_card_no")
    private String idCardNo;

    @TableField("id_card_front")
    private String idCardFront;

    @TableField("id_card_back")
    private String idCardBack;

    @TableField("status")
    private String status;

    @TableField("reject_reason")
    private String rejectReason;

    @TableField("submitted_at")
    private LocalDateTime submittedAt;

    @TableField("reviewed_at")
    private LocalDateTime reviewedAt;
}
