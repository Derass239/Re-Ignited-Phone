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
          <h1 id="amount">$ {{ bankAmontF }}</h1>
        </div>
      </div>
      <div class="transactions" >
        <div class="gradient" />
        <div class="content">
          <div class="history">
          <h2>Facture à payer</h2>
          </div>
          <div class="hr"></div>

          <div id='bills_list' @contextmenu.prevent="showOptions">
            <div class="bill" v-bind:class="{ select: id === selectBill}" v-for='(bill, id) in Operations' v-bind:key="bill.id"
              @click.stop="onActionMessage(bill)"
            >
              <h2 class="date">{{ bill.date }} </h2>
              <div class="billContent">
                <div class="image">
                  <img :src="DefineIcon(bill.target) || '/html/static/img/app_bank/FleecaBank.png'" onerror="this.onerror=null; this.src='/html/static/img/app_bank/FleecaBank.png'" class="picture" />
                </div>
                <div class="nature">
                  {{ bill.label }}
                </div>
                <div class="amount">
                  <h1>{{ bill.amount + ' $' }}</h1>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import Modal from '@/components/Modal/index.js'

export default {
  components: {
  },
  data () {
    return {
      ignoreControls: false,
      showInfoBar: true,
      ready: false,
      Operations: [],
      MaxSlide: 0,
      selectBill: 0
    }
  },

  computed: {
    ...mapGetters(['IntlString', 'bankAmont', 'bills']),
    bankAmontF () {
      return Intl.NumberFormat().format(this.bankAmont)
    }
  },
  methods: {
    ...mapActions(['GetBankData']),
    resetScroll () {
      this.$nextTick(() => {
        let elem = document.querySelector('#bills_list')
        elem.scrollTop = elem.scrollHeight
        this.selectBill = -1
      })
    },
    scrollIntoViewIfNeeded () {
      this.$nextTick(() => {
        const elem = this.$el.querySelector('.select')
        if (elem !== null) {
          elem.scrollIntoViewIfNeeded()
        }
      })
    },
    onUp: function () {
      if (this.ignoreControls === true) return
      if (this.selectBill === -1) {
        this.selectBill = this.Operations.length - 1
      } else {
        this.selectBill = this.selectBill === 0 ? 0 : this.selectBill - 1
      }
      this.scrollIntoViewIfNeeded()
    },
    onDown () {
      if (this.ignoreControls === true) return
      if (this.selectBill === -1) {
        this.selectBill = this.Operations.length - 1
      } else {
        this.selectBill = this.selectBill === this.Operations.length - 1 ? this.selectBill : this.selectBill + 1
      }
      this.scrollIntoViewIfNeeded()
    },
    onEnter () {
      if (this.ignoreControls === true) return
      if (this.selectBill !== -1) {
        this.onActionMessage(this.Operations[this.selectBill])
        console.log(this.Operations[this.selectBill])
      }
    },
    onBackspace () {
      if (this.ignoreControls === true) return
      if (this.selectMessage !== -1) {
        this.selectMessage = -1
      } else {
        this.quit()
      }
    },
    bankAmontFormat (value) {
      return Intl.NumberFormat().format(value)
    },
    SortOperations () {
      var FilteredOperations = []
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
      this.bills.forEach((operation) => {
        var NewOperation = Object.assign({}, operation)
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
        NewOperation.date = nameDate
        FilteredOperations.push(NewOperation)
      })
      return FilteredOperations
    },
    DefineIcon (nature) {
      const base = '/html/static/img/app_bank/'
      return base + nature + '.png'
    },
    async onActionMessage (bill) {
      try {
        let choix = [{
          id: 'pay',
          title: this.IntlString('APP_BANK_PAY_BILL'),
          icons: 'fa-usd'
        }, {
          id: -1,
          title: this.IntlString('CANCEL'),
          icons: 'fa-undo'
        }, {
          id: -1,
          title: ' '
        }]
        this.ignoreControls = true
        const data = await Modal.CreateModal({choix})
        if (data.id === 'pay') {
          this.payBill({
            id: bill.id
          })
        }
      } catch (e) {
      } finally {
        this.ignoreControls = false
        this.selectBill = -1
      }
    }
  },
  created () {
    this.$bus.$on('keyUpBackspace', this.onBackspace)
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpEnter', this.onEnter)
    }
    this.TopTransactions = 750
  },
  watch: {
    bills () {
      this.Operations = this.SortOperations()
    }
  },
  mounted () {
    this.Operations = this.SortOperations()
  },
  beforeDestroy () {
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUpBackspace', this.onBackspace)
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

#bills_list{
    height: calc(100% - 34px - 26px);
    overflow-y: auto;
    padding-bottom: 8px;
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
  z-index: 10;
  transition: 0.1s all linear;
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

.bill {
  display: grid;
  align-items: center;
}

.bill {
  padding-left: 15px;
  padding-right: 15px;
}

.bill .date {
  margin: 10px 0 10px 0;
  font-weight: 500;
}

.billContent {
  display: flex;
  justify-content: center;
}

.billContent img {
  height: 35px;
}

.billContent h1 {
  font-size: 1em;
}

.billContent .nature {
  margin-top: 5px;
  margin-left: 15px;
  font-weight: 40s0;
}

.billContent .nature {
  flex: 1 1 50%;
}

.billContent .amount h1 {
  margin-top: 5px;
  font-weight: 500;
}

.bill.select .billContent, .billContent:hover {
  background-color: #cfcfcf3d !important;
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
