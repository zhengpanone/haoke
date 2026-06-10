<script lang="ts" setup>
import type { HouseFavorite } from '#/api/haoke';

import { onMounted, reactive, ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  ElButton,
  ElCard,
  ElForm,
  ElFormItem,
  ElInput,
  ElMessage,
  ElPagination,
  ElPopconfirm,
  ElTable,
  ElTableColumn,
  ElTag,
} from 'element-plus';

import { deleteHouseFavoriteApi, queryHouseFavoritesApi } from '#/api/haoke';

const query = reactive({
  keyword: '',
  pageNum: 1,
  pageSize: 10,
  userId: '',
});

const loading = ref(false);
const rows = ref<HouseFavorite[]>([]);
const total = ref(0);

async function fetchData() {
  loading.value = true;
  try {
    const data = await queryHouseFavoritesApi({
      keyword: query.keyword || undefined,
      pageNum: query.pageNum,
      pageSize: query.pageSize,
      userId: query.userId || undefined,
    });
    rows.value = data.records || [];
    total.value = data.total || 0;
  } catch (error) {
    ElMessage.error((error as Error).message || '加载收藏失败');
  } finally {
    loading.value = false;
  }
}

async function removeRow(row: unknown) {
  const item = row as HouseFavorite;
  try {
    await deleteHouseFavoriteApi(item.id);
    ElMessage.success('收藏已删除');
    await fetchData();
  } catch (error) {
    ElMessage.error((error as Error).message || '删除失败');
  }
}

function tagList(tags?: string) {
  return (tags || '')
    .split(',')
    .map((item) => item.trim())
    .filter(Boolean);
}

onMounted(fetchData);
</script>

<template>
  <Page title="收藏管理">
    <div class="p-5">
      <ElCard shadow="never">
        <ElForm :inline="true" :model="query">
          <ElFormItem label="用户ID">
            <ElInput
              v-model="query.userId"
              clearable
              placeholder="输入用户ID"
            />
          </ElFormItem>
          <ElFormItem label="关键词">
            <ElInput
              v-model="query.keyword"
              clearable
              placeholder="房源/地址/标签"
            />
          </ElFormItem>
          <ElFormItem>
            <ElButton type="primary" @click="fetchData">查询</ElButton>
          </ElFormItem>
        </ElForm>

        <ElTable v-loading="loading" :data="rows" stripe>
          <ElTableColumn label="房源" min-width="220" prop="title" />
          <ElTableColumn label="用户ID" min-width="170" prop="userId" />
          <ElTableColumn label="租金" width="110">
            <template #default="{ row }"> ¥{{ row.price || 0 }} </template>
          </ElTableColumn>
          <ElTableColumn label="标签" min-width="180">
            <template #default="{ row }">
              <ElTag
                v-for="tag in tagList(row.tags)"
                :key="tag"
                class="mr-1"
                type="info"
                >{{ tag }}</ElTag
              >
            </template>
          </ElTableColumn>
          <ElTableColumn label="收藏时间" min-width="160" prop="favoriteTime" />
          <ElTableColumn label="地址" min-width="220" prop="address" />
          <ElTableColumn fixed="right" label="操作" width="100">
            <template #default="{ row }">
              <ElPopconfirm title="确认删除该收藏？" @confirm="removeRow(row)">
                <template #reference>
                  <ElButton link type="danger">删除</ElButton>
                </template>
              </ElPopconfirm>
            </template>
          </ElTableColumn>
        </ElTable>

        <div class="mt-4 flex justify-end">
          <ElPagination
            v-model:current-page="query.pageNum"
            v-model:page-size="query.pageSize"
            :page-sizes="[10, 20, 50]"
            :total="total"
            layout="total, sizes, prev, pager, next"
            @change="fetchData"
          />
        </div>
      </ElCard>
    </div>
  </Page>
</template>
