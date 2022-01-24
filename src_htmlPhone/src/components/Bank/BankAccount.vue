<template>
    <div class='elemnts'>
      <div class="header">
        <button class="btn-back" @click.stop="onBackspace"><i class="fa fa-arrow-left" @click.stop="onBackspace"></i></button>
        <div class="logo">
          <img :src="'/html/static/img/app_bank/FleecaBank.png'" />
        </div>
        <p></p>
        <div class="balance">
          <h2>Solde :</h2>
          <h1 id="amount">$ {{ bankAmountF }}</h1>
        </div>
      </div>
      <div id="transactions" :class="{'ease': ready === false}" :style="{ top: TopTransactions + 'px'}" ref="transactions">
        <div class="gradient" />
        <div class="content">
          <div class="history">
          <h2>Historique</h2>
          </div>
          <div class="hr"></div>
          <div class="element" 
            v-for="(jour, key) in Operations"
            :key="key"
            >
            <h2 class="date">{{ key }} </h2>
            <div class="transaction" v-for="(operation, id) of jour" :key="id">
              <div class="image">
                <img :src="DefineIcon(operation.society) || '/html/static/img/app_bank/society_fleeca.png'" onerror="this.onerror=null; this.src='/html/static/img/app_bank/society_fleeca.png'" class="picture" />
              </div>
              <div class="nature">
                {{ operation.type }}
              </div>
              <div class="amount">
                <h1 :class="{ 'text-danger': operation.amount > 0}">{{ AmountOperation(operation.amount) }}</h1>
              </div>
            </div>
          </div>
          <div class="hr"></div>
        </div>
      </div>
    </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  components: {
  },
  data () {
    return {
      showInfoBar: true,
      Slider: null,
      ready: false,
      Operations: [],
      TopY: 0,
      WidthY: 0,
      TopTransactions: 750,
      MaxSlide: 0
    }
  },

  computed: {
    ...mapGetters(['IntlString', 'bankAmont', 'transactions']),
    bankAmountF () {
      return Intl.NumberFormat().format(this.bankAmont)
    }
  },
  methods: {
    ...mapActions(['GetBankData']),
    onBackspace () {
      this.$router.push({ name: 'menu' })
    },
    StartSlideUp () {
      this.MaxSlide = 800 - (this.$refs.transactions.clientHeight)
      this.Slide(-1)
    },
    StartSlideDown () {
      this.MaxSlide = 800 - (this.$refs.transactions.clientHeight)
      this.Slide(1)
    },
    Slide (sens) {
      clearInterval(this.Slider)
      if (sens === 1) {
        if (this.TopTransactions < 170) this.TopTransactions += 50
      } else {
        if (this.TopTransactions > this.MaxSlide - 50) this.TopTransactions -= 50
      }
      this.Slider = setTimeout(function (app) {
        app.Slide(sens)
      }, 100, this)
    },
    StopSlide () {
      clearInterval(this.Slider)
    },
    bankAmontFormat (value) {
      return Intl.NumberFormat().format(value)
    },
    AmountOperation (amount) {
      var text = ''
      if (amount < 0) {
        text += '-'
        amount *= -1
      } else {
        text += '+'
      }
      text += this.bankAmontFormat(amount) + ' $'
      return text
    },
    SortOperations () {
      var FilteredOperations = {}
      const Today = new Date()
      Today.setHours(0)
      Today.setMinutes(0)
      Today.setSeconds(0)
      const Yesterday = new Date()
      Yesterday.setHours(0)
      Yesterday.setMinutes(0)
      Yesterday.setSeconds(0)
      const tabmois = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre']
      Yesterday.setDate(Yesterday.getDate() - 1)
      this.transactions.forEach((operation) => {
        const date = new Date(operation.date)
        var nameDate = ''
        if (date.getDate() === Today.getDate()) {
          nameDate = 'Aujourd\'hui'
        } else if (date.getDate() === Yesterday.getDate()) {
          nameDate = 'Hier'
        } else {
          nameDate = date.getDate() + ' ' + tabmois[(date.getMonth())] + ' ' + date.getFullYear()
        }
        if (FilteredOperations[nameDate] === undefined) {
          FilteredOperations[nameDate] = []
        }
        FilteredOperations[nameDate].push(operation)
      })
      return FilteredOperations
    },
    DefineIcon (nature) {
      const base = '/html/static/img/app_bank/'
      return base + nature + '.png'
    }
  },
  created () {
    this.$bus.$on('keyUpBackspace', this.onBackspace)
    this.$bus.$on('keyUpArrowUp', this.StartSlideUp)
    this.$bus.$on('keyUpArrowDown', this.StartSlideDown)
    this.$bus.$on('EndPressArrowUp', this.StopSlide)
    this.$bus.$on('EndPressArrowDown', this.StopSlide)
    this.TopTransactions = 750
    setTimeout(function (app) {
      app.TopTransactions = 170
      setTimeout(function (app) {
        app.ready = true
      }, 100, app)
    }, 100, this)
  },
  watch: {
    transactions () {
      this.Operations = this.SortOperations()
    }
  },
  mounted () {
    this.Operations = this.SortOperations()
  },
  beforeDestroy () {
    this.$bus.$off('keyUpArrowUp', this.StartSlideUp)
    this.$bus.$off('keyUpArrowDown', this.StartSlideDown)
    this.$bus.$off('EndPressArrowUp', this.StopSlide)
    this.$bus.$off('EndPressArrowDown', this.StopSlide)
  }
}
</script>

<style scoped>
h2 {
  color: #888888;
  font-size: 1em;
  margin: 0;
  font-weight: 400;
}

h1 {
  margin: 0;
  white-space: nowrap;
}

.text-danger {
  color: green;
}

.screen {
  position: relative;
  left: 0;
  right: 0;
  width: 100%;
  height: 100%;
  padding: 18px;
  background-color: white;
}
.title {
  padding-left: 16px;
  height: 34px;
  line-height: 34px;
  font-weight: 700;
  color: white;
  background-color: rgb(76, 175, 80);
}

.elements {
  position: relative;
  width: 100%;
  height: 100%;
  justify-content: center;
  padding-top: 32px;
}

.header .logo img {
  position: absolute;
  right: 15px;
  top: 37px;
  height: 60px;
}

.balance {
  padding-left: 15px;
  padding-right: 47px;
  padding-top: 40px;  
}

.history {
  padding-left: 15px;
  padding-right: 47px;
  padding-top: 8px;
  padding-bottom: 8px;
}

.balance .rh {
  height: 1px;
  margin-top: 10px;
  background-color: #d8d8d8;
}

#transactions {
  position: absolute;
  top: 560px;
  width: 100%;
  top: -750px;
  z-index: 10;
  transition: 0.1s all linear;
}

#transactions.ease {
  transition: 0.5a all ease;
}

#transactions.Open {
  top: 260px
}

.content {
  width: 100%;
  border-radius: 20px 20px 0px 0px;
  background-color: white;
  padding-top: 20px;
  padding-bottom: 10px;
}

.gradient {
  background: linear-gradient(180deg, rgba(0,0,0,0) 0%, rgba(0,0,0,0.4) 100%);
  height: 30px;
  margin-bottom: -20px;
}

.element {
  padding-left: 15px;
  padding-right: 15px;
}

.element img {
  height: 35px;
}

.element .date {
  margin: 20px 0 10px 0;
  font-weight: 500;
}

.transaction {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 10px;
}

.transaction h1 {
  font-size: 1em;
}

.transaction .nature {
  margin-left: 15px;
  font-weight: 500;
}

.transaction .nature {
  flex: 1 1 50%;
}

.transaction .amount h1 {
  font-weight: 400;
}

.btn-back {
  width: 42px;
  height: 42px;
  line-height: 42px;
  background-color: transparent;
  border: none;
  margin: 0;
  padding: 0;
  position: absolute;
  left: 5px;
  top: 37px;
  color: rgba(0, 0, 0, 0.7);
  outline: none;
  text-shadow: none;
  text-align: center;
}

.btn-back:hover {
  color: rgba(0, 0, 0, 1.0);
  cursor: pointer;
}

.hr {
  width: 60%;
  height: 2px;
  border-radius: 20px;
  background-color: #d8d8d8;
  margin: auto;
  margin-bottom: 10px;
}
</style>
