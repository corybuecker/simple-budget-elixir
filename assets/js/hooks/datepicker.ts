import Datepicker from 'vanillajs-datepicker/Datepicker';

export const DatePicker = {
  datepicker: undefined,
  mounted() {
    this.datepicker = new Datepicker(this.el, { format: 'yyyy-mm-dd'})
  },
  updated() {
    this.datepicker.destroy()
    this.datepicker = new Datepicker(this.el, { format: 'yyyy-mm-dd'})
  }
}
