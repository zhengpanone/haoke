<script lang="ts" setup>
import type { ViewingRecord } from '#/api/haoke';

import { onMounted, reactive, ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  ElButton,
  ElCard,
  ElForm,
  ElFormItem,
  ElInput,
  ElMessage,
  ElOption,
  ElPagination,
  ElPopconfirm,
  ElSelect,
  ElSpace,
  ElTable,
  ElTableColumn,
  ElTag,
} from 'element-plus';

import {
  deleteViewingRecordApi,
  queryViewingRecordsApi,
  updateViewingRecordStatusApi,
} from '#/api/haoke';

const statusOptions = [
  { label: '待看房', value: 'PENDING' },
  { label: '已看房', value: 'COMPLETED' },
  { label: '已取消', value: 'CANCELLED' },
];

const query = reactive({
  keyword: '',
  pageNum: 1,
  pageSize: 10,
  status: '',
  userId: '',
});

const loading = ref(false);
const rows = ref<ViewingRecord[]>([]);
const total = ref(0);

async function fetchData() {
  loading.value = true;
  try {
    const data = await queryViewingRecordsApi({
      keyword: query.keyword || undefined,
      pageNum: query.pageNum,
      pageSize: query.pageSize,
      status: query.status || undefined,
      userId: query.userId || undefined,
    });
    rows.value = data.records || [];
    total.value = data.total || 0;
  } catch (error) {
    ElMessage.error((error as Error).message || '加载看房记录失败');
  } finally {
    loading.value = false;
  }
}

async function changeStatus(row: unknown, status: string) {
  const item = row as ViewingRecord;
  try {
    await updateViewingRecordStatusApi(item.id, { status });
    ElMessage.success('状态已更新');
    await fetchData();
  } catch (error) {
    ElMessage.error((error as Error).message || '状态更新失败');
  }
}

async function removeRow(row: unknown) {
  const item = row as ViewingRecord;
  try {
    await deleteViewingRecordApi(item.id);
    ElMessage.success('看房记录已删除');
    await fetchData();
  } catch (error) {
    ElMessage.error((error as Error).message || '删除失败');
  }
}

function statusLabel(value?: string) {
  return statusOptions.find((item) => item.value === value)?.label || '未知';
}

function statusType(value?: string) {
  return value === 'COMPLETED'
    ? 'success'
    : value === 'CANCELLED'
      ? 'info'
      : 'warning';
}

onMounted(fetchData);
</script>

<template>
  <Page title="看房记录管理">
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
              placeholder="房源/地址/联系人"
            />
          </ElFormItem>
          <ElFormItem label="状态">
            <ElSelect
              v-model="query.status"
              clearable
              placeholder="全部"
              style="width: 140px"
            >
              <ElOption
                v-for="item in statusOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </ElSelect>
          </ElFormItem>
          <ElFormItem>
            <ElButton type="primary" @click="fetchData">查询</ElButton>
          </ElFormItem>
        </ElForm>

        <ElTable v-loading="loading" :data="rows" stripe>
          <ElTableColumn label="房源" min-width="220" prop="title" />
          <ElTableColumn label="用户ID" min-width="170" prop="userId" />
          <ElTableColumn
            label="预约时间"
            min-width="160"
            prop="appointmentTime"
          />
          <ElTableColumn label="联系人" width="180">
            <template #default="{ row }">
              <div>{{ row.contactName || '-' }}</div>
              <div class="text-xs text-gray-400">
                {{ row.contactPhone || '-' }}
              </div>
            </template>
          </ElTableColumn>
          <ElTableColumn label="状态" width="110">
            <template #default="{ row }">
              <ElTag :type="statusType(row.status)">{{
                statusLabel(row.status)
              }}</ElTag>
            </template>
          </ElTableColumn>
          <ElTableColumn label="备注" min-width="180" prop="note" />
          <ElTableColumn fixed="right" label="操作" width="260">
            <template #default="{ row }">
              <ElSpace>
                <ElButton
                  link
                  type="success"
                  @click="changeStatus(row, 'COMPLETED')"
                  >完成</ElButton
                >
                <ElButton
                  link
                  type="warning"
                  @click="changeStatus(row, 'CANCELLED')"
                  >取消</ElButton
                >
                <ElPopconfirm
                  title="确认删除该看房记录？"
                  @confirm="removeRow(row)"
                >
                  <template #reference>
                    <ElButton link type="danger">删除</ElButton>
                  </template>
                </ElPopconfirm>
              </ElSpace>
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
