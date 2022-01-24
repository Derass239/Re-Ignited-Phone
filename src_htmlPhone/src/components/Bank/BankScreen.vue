<template>
  <div class="phone_app">
    <InfoBare />
    <div class="phone_content">
      <component v-bind:is="currentScreen.component"/>
    </div>
    <div class="bank_menu">
      <div
        v-for="(s, i) in screen"
        :key="i"
        class="bank_menu-item"
        :class="{select: i === currentScreenIndex}"
        @click.stop="openMenu(i)">
        <i class="fa" :class="s.icon" @click.stop="openMenu(i)"></i>
      </div>
    </div>
  </div>
</template>

<script>
import InfoBare from './../InfoBare'
import BankAccount from './BankAccount'
import BankFacture from './BankFacture'
import { mapGetters } from 'vuex'

export default {
  components: {
    InfoBare
  },
  data () {
    return {
      currentScreenIndex: 0
    }
  },
  computed: {
    ...mapGetters(['IntlString', 'useMouse']),
    screen () {
      return [
        {
          title: 'Compte',
          // this.IntlString('APP_TWITTER_VIEW_TWITTER'),
          component: BankAccount,
          icon: 'fa-home'
        },
        {
          title: 'Facture',
          component: BankFacture,
          icon: 'fas fa-file-invoice-dollar'
        }
      ]
    },
    currentScreen () {
      return this.screen[this.currentScreenIndex]
    }
  },
  watch: {
  },
  methods: {
    onLeft () {
      this.currentScreenIndex = Math.max(0, this.currentScreenIndex - 1)
    },
    onRight () {
      this.currentScreenIndex = Math.min(this.screen.length - 1, this.currentScreenIndex + 1)
    },
    home () {
      this.currentScreenIndex = 0
    },
    openMenu (index) {
      this.currentScreenIndex = index
    },
    quit () {
      if (this.currentScreenIndex === 0) {
        this.$router.push({ name: 'home' })
      } else {
        this.currentScreenIndex = 0
      }
    }
  },
  created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowLeft', this.onLeft)
      this.$bus.$on('keyUpArrowRight', this.onRight)
    }
    this.$bus.$on('bankHome', this.home)
  },
  mounted () {
  },
  beforeDestroy () {
    this.$bus.$off('keyUpArrowLeft', this.onLeft)
    this.$bus.$off('keyUpArrowRight', this.onRight)
    this.$bus.$off('bankHome', this.home)
  }
}
</script>

<style scoped>
.phone_content {
  overflow: hidden;
}
.bank_menu {
  border-top: 1px solid #CCC;
  height: 56px;
  display: flex;
  width: 100%;
  z-index: 100;
  background-color: white;
}
.bank_menu-item {
  flex-grow: 1;
  flex-basis: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #959595;
}
.bank_menu-item.select {
  color: #035e12;
}
.bank_menu-item:hover {
  color: #035e12;
}
</style>
