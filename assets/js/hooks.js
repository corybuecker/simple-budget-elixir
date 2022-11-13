import { Datepicker } from 'vanillajs-datepicker'

let Hooks = {}

Hooks.DatePicker = {
  mounted() {
    this.datePicker = new Datepicker(this.el, { format: 'yyyy-mm-dd' })
  },
  destroyed() {
    this.datePicker.destroy()
  },
  updated() {
    this.datePicker.destroy()
    this.datePicker = new Datepicker(this.el, { format: 'yyyy-mm-dd' })
  }
}

export default Hooks
