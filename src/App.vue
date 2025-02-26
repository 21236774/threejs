<script setup lang="ts">
import type { MenuOption } from "naive-ui";
import { NEllipsis } from "naive-ui";
import { h } from "vue";
import Tint from "./view/tint/index.vue";

const options: MenuOption[] = [
  {
    label: () =>
      h(NEllipsis, null, { default: () => "电灯熄灭 物换星移 泥牛入海" }),
    key: "1",
  },
  {
    label: () =>
      h(NEllipsis, null, { default: () => "黑暗好像 一颗巨石 按在胸口" }),
    key: "2",
  },
];
</script>

<template>
  <n-layout has-sider>
    <n-layout-sider>
      <n-menu :options="options" style="width: 180px" default-value="1" />
    </n-layout-sider>
    <n-layout>
      <n-layout-header>颐和园路</n-layout-header>
      <n-layout-content content-style="padding: 24px;">
        <Tint />
      </n-layout-content>
      <n-layout-footer>成府路</n-layout-footer>
    </n-layout>
  </n-layout>
</template>

<style scoped></style>
