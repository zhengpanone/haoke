package com.yourcompany.${package.ModuleName}.interfaces.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@ApiModel(value = "${entity}VO对象", description = "${table.comment!}")
public class ${entity}VO implements Serializable {
private static final long serialVersionUID = 1L;
<#list table.fields as field>

    @Schema(description = "${field.comment!}")
    private ${field.propertyType} ${field.propertyName};
</#list>
}