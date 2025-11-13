package com.yourcompany.${package.ModuleName}.application.command;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
@ApiModel(value = "${entity}Command对象", description = "${table.comment!}命令")
public class ${entity}Command {
<#list table.fields as field>
    <#if field.propertyName != "id" && field.propertyName != "created" && field.propertyName != "updated">
        <#if field.propertyType == "String">

            @NotBlank(message = "${field.comment!}不能为空")
            @Schema(description = "${field.comment!}")
            private ${field.propertyType} ${field.propertyName};
        <#else>

            @NotNull(message = "${field.comment!}不能为空")
            @Schema(description = "${field.comment!}")
            private ${field.propertyType} ${field.propertyName};
        </#if>
    </#if>
</#list>
}