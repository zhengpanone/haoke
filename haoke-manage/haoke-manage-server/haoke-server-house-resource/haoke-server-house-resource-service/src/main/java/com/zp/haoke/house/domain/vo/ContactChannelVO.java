package com.zp.haoke.house.domain.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ContactChannelVO {
    private String type;
    private String title;
    private String value;
    private String description;
}
