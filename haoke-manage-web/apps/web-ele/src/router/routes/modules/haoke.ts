import type { RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
  {
    meta: {
      icon: 'lucide:building-2',
      order: 10,
      title: '好客业务',
    },
    name: 'HaokeBusiness',
    path: '/haoke',
    children: [
      {
        component: () => import('#/views/haoke/recommend-houses/index.vue'),
        meta: {
          icon: 'lucide:home',
          title: '推荐房源管理',
        },
        name: 'HaokeRecommendHouses',
        path: '/haoke/recommend-houses',
      },
      {
        component: () => import('#/views/haoke/news/index.vue'),
        meta: {
          icon: 'lucide:newspaper',
          title: '最新资讯管理',
        },
        name: 'HaokeNews',
        path: '/haoke/news',
      },
      {
        component: () => import('#/views/haoke/viewing-records/index.vue'),
        meta: {
          icon: 'lucide:calendar-clock',
          title: '看房记录管理',
        },
        name: 'HaokeViewingRecords',
        path: '/haoke/viewing-records',
      },
      {
        component: () => import('#/views/haoke/orders/index.vue'),
        meta: {
          icon: 'lucide:receipt-text',
          title: '订单管理',
        },
        name: 'HaokeOrders',
        path: '/haoke/orders',
      },
      {
        component: () => import('#/views/haoke/favorites/index.vue'),
        meta: {
          icon: 'lucide:heart',
          title: '收藏管理',
        },
        name: 'HaokeFavorites',
        path: '/haoke/favorites',
      },
      {
        component: () => import('#/views/haoke/identities/index.vue'),
        meta: {
          icon: 'lucide:id-card',
          title: '身份认证管理',
        },
        name: 'HaokeIdentities',
        path: '/haoke/identities',
      },
      {
        component: () => import('#/views/haoke/contracts/index.vue'),
        meta: {
          icon: 'lucide:file-signature',
          title: '电子合同管理',
        },
        name: 'HaokeContracts',
        path: '/haoke/contracts',
      },
      {
        component: () => import('#/views/haoke/wallets/index.vue'),
        meta: {
          icon: 'lucide:wallet-cards',
          title: '钱包管理',
        },
        name: 'HaokeWallets',
        path: '/haoke/wallets',
      },
      {
        component: () => import('#/views/haoke/contacts/index.vue'),
        meta: {
          icon: 'lucide:headphones',
          title: '联系我们配置',
        },
        name: 'HaokeContacts',
        path: '/haoke/contacts',
      },
    ],
  },
];

export default routes;
