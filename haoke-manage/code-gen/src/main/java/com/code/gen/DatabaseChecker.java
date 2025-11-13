package com.code.gen;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DatabaseChecker {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:30031/haoke?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
        String username = "root";
        String password = "root";
        
        try (Connection conn = DriverManager.getConnection(url, username, password)) {
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet tables = metaData.getTables("haoke", null, "%", new String[]{"TABLE"});
            
            System.out.println("数据库中的表：");
            List<String> tableNames = new ArrayList<>();
            while (tables.next()) {
                String tableName = tables.getString("TABLE_NAME");
                tableNames.add(tableName);
                System.out.println(" - " + tableName);
            }
            
            if (tableNames.isEmpty()) {
                System.out.println("数据库中没有表！");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}