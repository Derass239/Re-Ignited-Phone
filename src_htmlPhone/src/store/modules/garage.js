import PhoneAPI from './../../PhoneAPI'

const state = {
  cars: []
}

const getters = {
  cars: ({ cars }) => cars,
}

const actions = {
  fetchCars ({ state }) {
    PhoneAPI.garage_getCars()
  }
}

export default {
  state,
  getters,
  actions
}