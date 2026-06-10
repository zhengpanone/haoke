<script lang="ts" setup>
import type { ContactChannel } from '#/api/haoke';

import { onMounted, ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  ElButton,
  ElCard,
  ElMessage,
  ElTable,
  ElTableColumn,
  ElTag,
} from 'element-plus';

import { queryContactChannelsApi } from '#/api/haoke';

const loading = ref(false);
const rows = ref<ContactChannel[]>([]);

async function fetchData() {
  loading.value = true;
  try {
    rows.value = await queryContactChannelsApi();
  } catch (error) {
    ElMessage.error((error as Error).message || '加载联系渠道失败');
  } finally {
    loading.value = false;
  }
}

function typeLabel(value?: string) {
  if (value === 'phone') {
    return '电话';
  }
  if (value === 'email') {
    return '邮箱';
  }
  if (value === 'address') {
    return '地址';
  }
  return value || '渠道';
}

onMounted(fetchData);
</script>

<template>
  <Page title="联系我们配置">
    <div class="p-5">
      <ElCard shadow="never">
        <div class="mb-4 flex justify-end">
          <ElButton type="primary" @click="fetchData">刷新</ElButton>
        </div>

        <ElTable v-loading="loading" :data="rows" stripe>
          <ElTableColumn label="渠道" width="120">
            <template #default="{ row }">
              <ElTag type="info">{{ typeLabel(row.type) }}</ElTag>
            </template>
          </ElTableColumn>
          <ElTableColumn label="标题" min-width="160" prop="title" />
          <ElTableColumn label="内容" min-width="220" prop="value" />
          <ElTableColumn label="说明" min-width="260" prop="description" />
        </ElTable>
      </ElCard>
    </div>
  </Page>
</template>
