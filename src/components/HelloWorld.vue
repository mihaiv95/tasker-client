<script setup lang="ts">
import { ref } from 'vue'

defineProps<{ msg: string }>()
const resp = ref()
const loading = ref(true)
const error = ref('')

console.log('API URL:', __API_URL__)

fetch(`${__API_URL__}/WeatherForecast`)
  .then((res) => {
    console.log('Response status:', res.status)
    return res.json()
  })
  .then((data) => {
    console.log('API response:', data)
    resp.value = data
    loading.value = false
  })
  .catch((err) => {
    console.error('Error fetching data:', err)
    error.value = err.message
    loading.value = false
  })

const count = ref(0)
</script>

<template>
  <h1>{{ msg }}</h1>
  <h2>Weather Data</h2>
  <div v-if="loading">Loading weather data...</div>
  <div v-else-if="error" style="color: red;">Error: {{ error }}</div>
  <div v-else-if="resp">
    <pre>{{ JSON.stringify(resp, null, 2) }}</pre>
  </div>
  <div v-else>No data available</div>
  <div class="card">
    <button type="button" @click="count++">count is {{ count }}</button>
    <p>
      Edit
      <code>components/HelloWorld.vue</code> to test HMR
    </p>
  </div>

  <p>
    Check out
    <a href="https://vuejs.org/guide/quick-start.html#local" target="_blank">create-vue</a>, the official Vue + Vite
    starter
  </p>
  <p>
    Learn more about IDE Support for Vue in the
    <a href="https://vuejs.org/guide/scaling-up/tooling.html#ide-support" target="_blank">Vue Docs Scaling up Guide</a>.
  </p>
  <p class="read-the-docs">Click on the Vite and Vue logos to learn more</p>
</template>

<style scoped>
.read-the-docs {
  color: #888;
}
</style>
