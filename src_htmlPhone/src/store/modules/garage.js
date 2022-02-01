import PhoneAPI from './../../PhoneAPI'

const state = {
  cars: []
}

const getters = {
  cars: ({ cars }) => cars
}

const actions = {
  fetchCars () {
    PhoneAPI.garage_getCars()
  }
}

const mutations = {
  SET_GARAGE_CARS (state, { cars }) {
    state.cars = cars
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}

if (process.env.NODE_ENV !== 'production') {
  state.cars = [
    { 'plate': 'AZER1234', 'vehiclename': 'Blista', 'garage': 'Square' },
    { 'plate': 'TYUI5678', 'vehiclename': 'Tornado', 'garage': 'Square' },
    { 'plate': 'QSDF1234', 'vehiclename': 'Tigon', 'garage': 'Square' },
    { 'plate': 'WXCV1234', 'vehiclename': 'Rasta machine', 'garage': 'Square' },
    { 'plate': 'POIU1234', 'vehiclename': 'Blista', 'garage': 'Square' }
  ]
}
