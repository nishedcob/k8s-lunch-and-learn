<!-- eslint-disable vue/multi-word-component-names -->
<template>
  <v-simple-table>
    <template #default >
      <thead>
        <tr>
          <th class="text-left">

          </th>
          <th class="text-left">
            Hydrogen
          </th>
          <th class="text-left">
            Oxygen
          </th>
          <th class="text-left">
            Helium
          </th>
          <th class="text-left">
            Chlorine
          </th>
          <th class="text-left">
            Sodium
          </th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Hydrogen</td>
          <td>
            <span class="material-icons success-connexion">
              check_circle
            </span>
          </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons success-connexion">
              check_circle
            </span>
          </td>
        </tr>
        <tr>
          <td>Oxygen</td>
          <td>
            <span class="material-icons success-connexion">
              check_circle
            </span>
          </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons success-connexion">
              check_circle
            </span>
          </td>
        </tr>
        <tr>
          <td>Helium</td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons success-connexion">
              check_circle
            </span>
        </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons success-connexion">
              check_circle
            </span>
          </td>
        </tr>
        <tr>
          <td>Chlorine</td>
         <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons success-connexion">
              check_circle
            </span>
        </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons success-connexion">
              check_circle
            </span>
          </td>
        </tr>
        <tr>
          <td>Sodium</td>
          <td>
            <span class="material-icons success-connexion">
              check_circle
            </span>
          </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons error-connexion">
              cancel
            </span>
          </td>
          <td>
            <span class="material-icons success-connexion">
              check_circle
            </span>
          </td>
        </tr>
      </tbody>
    </template>
  </v-simple-table>
</template>

<script>
  export default {
    data () {
      return {
        desserts: [
          {
            name: 'Frozen Yogurt',
            calories: 159,
          },
          {
            name: 'Ice cream sandwich',
            calories: 237,
          },
          {
            name: 'Eclair',
            calories: 262,
          },
          {
            name: 'Cupcake',
            calories: 305,
          },
          {
            name: 'Gingerbread',
            calories: 356,
          },
          {
            name: 'Jelly bean',
            calories: 375,
          },
          {
            name: 'Lollipop',
            calories: 392,
          },
          {
            name: 'Honeycomb',
            calories: 408,
          },
          {
            name: 'Donut',
            calories: 452,
          },
          {
            name: 'KitKat',
            calories: 518,
          },
        ],
      }
    },
  }
</script>

<style>
  td{
    text-align: center;
  }
  .success-connexion{
    color: green;
  }
  .error-connexion{
    color: red;
  }
</style>