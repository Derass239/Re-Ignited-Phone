<template>
  <div class="splash">
    <img src="/html/static/img/app_bank/FleecaBank.png">
  </div>
</template>

<script>
import { mapActions } from 'vuex'
export default {
  methods: {
    ...mapActions(['GetBankData'])
  },
  created () {
    this.GetBankData()
    setTimeout(() => {
      this.$router.push({ name: 'bank.screen' })
    }, 1250)
  }
}
</script>

<style scoped>
  .splash{
    width: 100%;
    height: 100%;
    background-color: white;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  img {
    width: 80px;
    animation-name: zoom;
    animation-duration: 0.35s;
    animation-fill-mode: forwards;
  }
  @keyframes zoom {
    from {width: 180px;}
    to {width: 250px;}
  }
</style>
