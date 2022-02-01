import PhoneAPI from './../../PhoneAPI'

const state = {
  bankAmont: '0',
  transactions: [],
  bills: []
}

const getters = {
  bankAmont: ({ bankAmont }) => bankAmont,
  transactions: ({ transactions }) => transactions,
  bills: ({ bills }) => bills
}

const actions = {
  GetBankData () {
    PhoneAPI.GetBankData()
  },
  PayBill ({ commit }, { bill }) {
    PhoneAPI.PayBill(bill)
  }
}

const mutations = {
  SET_BANK_AMONT (state, bankAmont) {
    state.bankAmont = bankAmont
  },
  SET_BANK_TRANSACTION (state, { transactions }) {
    state.transactions = transactions
  },
  SET_BANK_BILLS (state, { bills }) {
    state.bills = bills
    state.bills.sort(function (x, y) {
      return y.date - x.date
    })
  },
  ADD_TRANSACTION (state, transaction) {
    state.transactions.unshift(transaction)
  },
  REMOVE_BILL (state, billId) {
    const index = state.bills.findIndex(v => v.id === billId)
    console.log(index)
    state.bills.splice(index, 1)
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}

if (process.env.NODE_ENV !== 'production') {
  state.bankAmont = 2568709
  state.transactions = [
    { 'id': 1, 'type': 'LS Custom Ville', 'amount': -4652, 'date': 1619158014000, 'society': 'society_mechanic' },
    { 'id': 2, 'type': 'Hopital', 'amount': -500, 'date': 1619258014000, 'society': 'society_ambulance' },
    { 'id': 3, 'type': 'Dépot', 'amount': 5000, 'date': 1619058014000, 'society': 'society_in' },
    { 'id': 4, 'type': 'Bahama mas', 'amount': -15000, 'date': 1651098014000, 'society': 'society_bahama' },
    { 'id': 5, 'type': 'Mécano', 'amount': -5000, 'date': 1619088014000, 'society': 'society_mechanic' },
    { 'id': 6, 'type': 'Hopital', 'amount': -500, 'date': 1619058014000, 'society': 'society_ambulance' },
    { 'id': 7, 'type': 'Paye', 'amount': 5000, 'date': 1619158014000, 'society': 'society_paye' },
    { 'id': 8, 'type': 'Bahama mas', 'amount': -15000, 'date': 1619458014000, 'society': 'society_bahama' }
  ]
  state.bills = [
    { 'id': 1, 'target': 'society_unicorn', 'label': 'Unicorn', 'amount': 100, 'date': 1619858014000 },
    { 'id': 4, 'target': 'society_banker', 'label': 'Banque', 'amount': 900000, 'date': 1617858014000 },
    { 'id': 2, 'target': 'society_police', 'label': 'Amende: Prise d\'ôtage', 'amount': 8000, 'date': 1619558014000 },
    { 'id': 3, 'target': 'society_mechanic', 'label': 'Mécano', 'amount': 14230, 'date': 1619958014000 },
    { 'id': 5, 'target': 'society_unicorn', 'label': 'Unicorn', 'amount': 100, 'date': 1619858014000 },
    { 'id': 6, 'target': 'society_banker', 'label': 'Banque', 'amount': 900000, 'date': 1617858014000 },
    { 'id': 7, 'target': 'society_police', 'label': 'Amende: Prise d\'ôtage', 'amount': 8000, 'date': 1619558014000 },
    { 'id': 8, 'target': 'society_mechanic', 'label': 'Mécano', 'amount': 14230, 'date': 1619958014000 }
  ]
}
