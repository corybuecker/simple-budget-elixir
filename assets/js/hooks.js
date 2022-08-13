import { Datepicker } from 'vanillajs-datepicker'

let Hooks = {}

Hooks.DatePicker = {
  mounted() {
    new Datepicker(this.el, { format: 'yyyy-mm-dd' })
  }
}

export default Hooks
