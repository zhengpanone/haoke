package com.yourcompany.${package.ModuleName}.interfaces.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value = "${entity}DTO对象", description = "${table.comment!}")
public class ${entity}DTO implements Serializable {
private static final long serialVersionUID = 1L;
<#list table.fields as field>
    <#if field.propertyName != "id" && field.propertyName != "created" && field.propertyName != "updated">

        @Schema(description = "${field.comment!}")
        private ${field.propertyType} ${field.propertyName};
    </#if>
</#list>
}