<!-- eslint-disable vue/multi-word-component-names -->
<template>
  <v-simple-table>
    <template #default>
      <thead>
        <tr>
          <th class="text-left"></th>
          <th class="text-left">Hydrogen</th>
          <th class="text-left">Oxygen</th>
          <th class="text-left">Helium</th>
          <th class="text-left">Chlorine</th>
          <th class="text-left">Sodium</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Hydrogen</td>
          <td>
            <span class="material-icons success-connexion"> check_circle </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons success-connexion"> check_circle </span>
          </td>
        </tr>
        <tr>
          <td>Oxygen</td>
          <td>
            <span class="material-icons success-connexion"> check_circle </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons success-connexion"> check_circle </span>
          </td>
        </tr>
        <tr>
          <td>Helium</td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons success-connexion"> check_circle </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons success-connexion"> check_circle </span>
          </td>
        </tr>
        <tr>
          <td>Chlorine</td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons success-connexion"> check_circle </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons success-connexion"> check_circle </span>
          </td>
        </tr>
        <tr>
          <td>Sodium</td>
          <td>
            <span class="material-icons success-connexion"> check_circle </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons error-connexion"> cancel </span>
          </td>
          <td>
            <span class="material-icons success-connexion"> check_circle </span>
          </td>
        </tr>
      </tbody>
    </template>
  </v-simple-table>
</template>

<script>
export default {
  data: () => ({
    posts: '',
  }),
  async fetch() {
      this.mountains = await fetch(
        'https://api.nuxtjs.dev/mountains'
      ).then(res => console.log(res.json()))
  },
  fetchOnServer: true,
  // // multiple components can return the same `fetchKey` and Nuxt will track them both separately
  // fetchKey: 'site-sidebar',
  // // alternatively, for more control, a function can be passed with access to the component instance
  // // It will be called in `created` and must not depend on fetched data
  // fetchKey(getCounter) {
  //   // getCounter is a method that can be called to get the next number in a sequence
  //   // as part of generating a unique fetchKey.
  //   return this.someOtherData + getCounter('sidebar')
  // },
  // methods: {
  //   async fetchData() {
  //     this.posts = await this.$http.$get('helium.default.svc.cluster.local/v1/access/helium/v1/health')
  //     console.log(this.posts)
  //   }
  // },
  // mounted() {
  //   this.fetchData();
  // }
}
</script>

<style>
td {
  text-align: center;
}
.success-connexion {
  color: green;
}
.error-connexion {
  color: red;
}
</style>
