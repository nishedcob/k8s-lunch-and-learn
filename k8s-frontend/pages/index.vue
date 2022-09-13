<template>
  <v-main class="main">
    <v-container class="title">
      <!-- header -->
      <v-row>
        <v-col class="colum">
          <div class="date"><span>Lunch And Learn</span></div>
          <h1>KUBERNETES AND MESH SERVICE</h1>
          <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Sapiente est officia, debitis explicabo distinctio culpa maiores beatae quam! Veniam, officiis exercitationem aliquid eos cumque suscipit vel saepe illo labore a.</p>
          <div class="line"></div>
        </v-col>
      </v-row>
    </v-container>
    <v-container>
      <v-row class="colum">
        <v-col cols="12">
            <Table />
        </v-col>
      </v-row>
    </v-container>
  </v-main>
</template>

<script>
export default {
  name: 'IndexPage',
}
</script>

<style>
  .title{
    min-height: 11rem;
  }
  .colum {
    margin: 0 10rem 0 10rem;
  }
  h1{
    color: #111; font-family: 'Open Sans Condensed', sans-serif; font-size: 64px; font-weight: 700; line-height: 64px; margin: 0 0 0; padding: 20px 30px; text-align: center; text-transform: uppercase;
  }
  .line { border-top: 1px solid #111; display: block; margin-top: 60px; padding-top: 50px; position: relative; }
  p { color: #111; font-family: 'Open Sans', sans-serif; font-size: 16px; line-height: 28px; margin: 0 0 48px; }
  .date { color: #111; display: block; font-family: 'Open Sans', sans-serif; font-size: 16px; position: relative; text-align: center; z-index: 1; }
  .date:before { border-top: 1px solid #111; content: ""; position: absolute; top: 12px; left: 0; width: 100%; z-index: -1; }
  .date span {
    background: #fdfdfd; padding: 0 10px; text-transform: uppercase;
  }
</style>