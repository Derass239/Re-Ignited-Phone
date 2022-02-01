<template>
  <div class="phone_app">
    <PhoneTitle :title="IntlString('APP_GARAGE_TITLE')" backgroundColor="#17046b" color="white" @back="onBackspace"/>
    <div class="elements">
      <div id="cars_list" @contextmenu.prevent="showOptions">
        <div class="hr"></div>
        <div class="car" v-bind:class="{ select: plate === selectCar}" v-for='(car, plate) in cars' v-bind:key="car.plate"
          @click.stop="onActionMessage(car)"
        >
          <div class="car_content">
            <h1>
              {{ car.vehiclename }}
            </h1>
            <h2>
              {{ car.plate }}
            </h2>
          </div>
          <div class="car_garage">
            <h2>
              {{ car.garage }}
            </h2>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import Modal from '@/components/Modal/index.js'
import PhoneTitle from './../PhoneTitle'

export default {
  components: {
    PhoneTitle
  },
  data () {
    return {
      ignoreControls: false,
      selectCar: -1
    }
  },
  computed: {
    ...mapGetters(['cars', 'IntlString'])
  },
  methods: {
    ...mapActions(['fetchCars']),
    onBackspace () {
      this.$router.push({ name: 'home' })
    },
    resetScroll () {
      this.$nextTick(() => {
        let elem = document.querySelector('#cars_list')
        elem.scrollTop = elem.scrollHeight
        this.selectCar = -1
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
    onUp () {
      if (this.ignoreControls === true) return
      if (this.selectCar === -1) {
        this.selectCar = this.cars.length - 1
      } else {
        this.selectCar = this.selectCar === 0 ? this.cars.length - 1 : this.selectCar - 1
      }
      this.scrollIntoViewIfNeeded()
    },
    onDown () {
      if (this.ignoreControls === true) return
      if (this.selectCar === -1) {
        this.selectCar = 0
      } else {
        this.selectCar = this.selectCar === this.cars.length - 1 ? 0 : this.selectCar + 1
      }
      this.scrollIntoViewIfNeeded()
    },
    onEnter () {
      if (this.ignoreControls === true) return
      if (this.selectCar !== -1) {
        this.onActionMessage(this.cars[this.selectCar])
      }
    },
    async onActionMessage (car) {
      try {
        this.ignoreControls = true
        let choix = [{
          id: 'marker',
          title: this.IntlString('APP_GARAGE_MARKER'),
          icons: ''
        }, {
          id: -1,
          title: this.IntlString('CANCEL'),
          icons: 'fa-undo'
        }]
        const data = await Modal.CreateModal({choix})
        if (data.id === 'marker') {
          this.$phoneAPI.setGaragePos(car.garage)
        }
      } catch (e) {
      } finally {
        this.ignoreControls = false
        this.selectCar = -1
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
  },
  mounted () {
    this.fetchCars()
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
h1 {
  color: #32ac0d;
  font-size: 1.2em;
  margin: 0;
  font-weight: 500;
}

h2 {
  color: #ffffff;
  font-size: 1em;
  margin: 0;
  font-weight: 400;
}

.elements{
  height: calc(100% - 34px);
  overflow-y: auto;
}

#cars_list{
  height: calc(100%);
  overflow-y: auto;
  background-color: #17046b;
  color: #302f34
}

.car {
  display: flex;
  justify-content: space-between;
}


.car {
  padding-left: 15px;
  padding-right: 15px;
}

.car .h2 {
  color: #ffffff;
  font-size: 1em;
  font-weight: 400;
}

.car_content {
  display: grid;
  margin: 10px;
}

.car_garage {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.car.select, .car:hover {
  background-color: #cfcfcf3d !important;
}

.hr {
  width: 100%;
  height: 2px;
  border-radius: 20px;
  background-color: #d8d8d8;
  margin: auto;
  margin-bottom: 10px;
}
</style>
