package com.yourcompany.${package.ModuleName}.interfaces.query;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value = "${entity}Query对象", description = "${table.comment!}查询条件")
public class ${entity}Query {

@Schema(description = "页码")
private Integer pageNum = 1;

@Schema(description = "每页数量")
private Integer pageSize = 10;

@Schema(description = "关键字")
private String keyword;
<#list table.fields as field>
    <#if field.propertyType == "String">

        @Schema(description = "${field.comment!}")
        private ${field.propertyType} ${field.propertyName};
    </#if>
</#list>
}